#!/usr/bin/python3
import os
import re
import shutil
import tarfile
from operator import itemgetter

import git
import requests
import sys
from git import Repo, Actor, Head, GitCmdObjectDB, InvalidGitRepositoryError
from natsort import natsorted
from requests import RequestException

# Define board names
boards = {
    'e50': 'edgerouter-x',
    'e100': 'edgerouter-lite',
    'e200': 'edgerouter',
    'e300': 'edgerouter-4',
    'e1000': 'edgerouter-infinity'
}

# Define what major/minor versions to import
versions_to_import = {
    '1': [
        '10'
    ],
    '2': [
        '0'
    ]
}

author = Actor("Nils Andreas Svee", "me@lochnair.net")
committer = author

headers = {'X-Requested-With': 'XMLHttpRequest'}


def get_releases(group):
    url = 'https://www.ui.com/download/?group=' + group
    try:
        resp = requests.get(url, headers=headers)
        return resp.json()['downloads']
    except RequestException as ex:
        print("Unexpected error: ", ex.strerror)
        exit(1)


def filter_releases(_releases):
    branches = {}

    for major in versions_to_import:
        for minor in versions_to_import[major]:
            branches['v' + major + "." + minor] = []

    for rel in _releases:
        if rel['category__slug'] != "firmware" or rel['sdk__id'] is None:
            continue

        # strip of v prefix and split up the subversion's
        ver = rel['version'][1:].split('.')
        major = ver[0]
        minor = ver[1]

        if major not in versions_to_import:
            continue

        if minor not in versions_to_import[major]:
            continue

        branches['v' + major + "." + minor].append(rel)

    for branch, releases in branches.items():
        branches[branch] = natsorted(releases, key=itemgetter('version'))

    return branches


def get_sdk_url(release):
    url = 'https://www.ui.com/download/?gpl=' + str(release['sdk__id']) + '&eula=true'
    try:
        resp = requests.get(url, headers=headers)
        return 'https://dl.ui.com' + resp.json()['download_url'].replace('downloads/', '')
    except RequestException as ex:
        print("Unexpected error: ", ex.strerror)
        exit(1)
    return 0


def download_sdk(url):
    local_path = url.split('/')[-1]

    with requests.get(url, stream=True) as resp:
        with open(local_path, 'wb') as f:
            shutil.copyfileobj(resp.raw, f)

    return local_path


def get_kernel_member(tar):
    try:
        for m in tar.getmembers():
            if re.search(r'kernel_.*\.tgz', m.name):
                return m
    except EOFError:
        print("  -> Error: Either download failed, or archive is corrupt on UBNT servers")
        return


def create_or_switch_branch(repo, branch):
    repo.head.reference = Head(repo, 'refs/heads/' + branch)
    repo.head.reset(index=True, working_tree=True)


def remove_working_tree(repo_path):
    for path in os.listdir(repo_path):
        if path != ".git":
            to_del = os.path.join(repo_path, path)
            if os.path.isfile(to_del):
                os.remove(to_del)
            elif os.path.isdir(to_del):
                shutil.rmtree(to_del)


def tar_strip_components(tar, prefix):
    if not prefix.endswith('/'):
        prefix += '/'
    offset = len(prefix)
    for tarinfo in tar.getmembers():
        if tarinfo.name.startswith(prefix):
            tarinfo.name = tarinfo.name[offset:]
            yield tarinfo


def add_all_except_git(repo, index, repo_path):
    items = os.listdir(repo_path)
    items.remove('.git')
    index.add(items)
    index.add(repo.untracked_files)


def apply_patches(repo, branch, version):
    _git = repo.git
    patch_folder = os.path.join(os.getcwd(), "patches")
    branch_patches = os.path.join(patch_folder, branch)
    version_patches = os.path.join(patch_folder, branch, version)
    patches = []

    for f in os.listdir(branch_patches):
        if os.path.isfile(os.path.join(branch_patches, f)):
            patches.append(os.path.join(branch_patches, f))

    if os.path.isdir(version_patches):
        for f in os.listdir(version_patches):
            if os.path.isfile(os.path.join(version_patches, f)):
                patches.append(os.path.join(version_patches, f))

    _git.am(patches)


def main():
    repo_path = os.path.join(os.getcwd(), "repo")

    if not os.path.isdir(repo_path):
        os.mkdir(repo_path)

    try:
        repo = Repo(repo_path, odbt=GitCmdObjectDB)
    except InvalidGitRepositoryError:
        repo = git.Repo.init(repo_path)
        new_repo = True

    board = sys.argv[1]
    group = boards[board]

    branches = filter_releases(get_releases(group))

    for branch, releases in branches.items():
        print('Processing branch:', branch)

        stock_branch = "{}/stock".format(branch)

        new_branch = stock_branch in repo.branches

        for rel in releases:
            release_branch = "{}/master".format(rel['version'])

            if release_branch in repo.branches:
                continue

            # Switch to stock branch
            create_or_switch_branch(repo, stock_branch)

            # Remove all files/folders in working tree
            remove_working_tree(repo_path)

            print(" -> Downloading GPL archive for: ", rel['version'])

            sdk_path = download_sdk(get_sdk_url(rel))
            kernel_path = None

            try:
                with tarfile.open(sdk_path, mode='r') as tar:
                    member = get_kernel_member(tar)

                    if not member:
                        print("  -> Couldn't find kernel archive.")
                        continue

                    kernel_path = member.name
                    tar.extractall(members=[member])
            except tarfile.ReadError:
                print("  -> Unable to open archive.")
                continue

            os.remove(sdk_path)

            with tarfile.open(kernel_path, mode='r') as tar:
                tar.extractall(path=repo_path, members=tar_strip_components(tar, 'kernel/'))

            os.remove(kernel_path)
            add_all_except_git(repo, repo.index, repo_path)
            commit = repo.index.commit('Import kernel sources from ' + rel['version'], author=author,
                                       committer=committer)
            repo.head.reference = Head(repo, 'refs/heads/' + release_branch)
            repo.head.reference.commit = commit
            apply_patches(repo, branch, rel['version'])


if __name__ == "__main__":
    main()

