#!/usr/bin/python3
import os
from pathlib import Path
from shutil import copy2

from git import Repo, Actor, GitCmdObjectDB, InvalidGitRepositoryError

author = Actor("Nils Andreas Svee", "me@lochnair.net")
committer = author


def main():
    repo_path = os.path.join(os.getcwd(), "repo")
    cake_path = os.path.join(os.getcwd(), "sch_cake")

    try:
        repo = Repo(repo_path, odbt=GitCmdObjectDB)
        cake_repo = Repo(cake_path, odbt=GitCmdObjectDB)
    except InvalidGitRepositoryError:
        print("Not a Git repository")
        exit(1)

    cake_commit = cake_repo.head.commit.name_rev[:9]
    cake_msg = cake_repo.head.commit.summary

    print(str.format("Importing CAKE commit {}: {}", cake_commit, cake_msg))

    for b in repo.heads:
        if not b.name.endswith("/master"):
            continue

        repo.head.reference = b
        repo.head.reset(index=True, working_tree=True)

        version = b.name.split('/')[0]

        print(version)

        try:
            cake_branch = repo.heads[version + '/sch_cake']
        except IndexError:
            cake_branch = repo.create_head(version + '/sch_cake')

        repo.head.reference = cake_branch

        with open(os.path.join(cake_path, 'Kconfig'), 'r') as f:
            kconfig_lines = f.readlines()

        with open(os.path.join(repo_path, 'net', 'sched', 'Kconfig'), 'a+') as f:
            f.seek(0)
            if 'NET_SCH_CAKE' not in f.read():
                f.writelines(['\n'] + kconfig_lines)

        with open(os.path.join(repo_path, 'net', 'sched', 'Makefile'), 'a+') as f:
            f.seek(0)
            if 'NET_SCH_CAKE' not in f.read():
                f.writelines(['obj-$(CONFIG_NET_SCH_CAKE)	+= sch_cake.o'])

        source_files = Path(cake_path).glob("*.c") + Path(cake_path).glob("*.h")

        for f in Path(cake_path).glob("*.c"):
            copy2(str(f), os.path.join(repo_path, "net", "sched"))

        for f in Path(cake_path).glob("*.h"):
            copy2(str(f), os.path.join(repo_path, "net", "sched"))

        repo.index.add(['net/sched'])

        diff = repo.index.diff(cake_branch)

        # no changes found
        if len(diff) < 1:
            continue

        repo.index.commit(str.format('Import sch_cake source (commit {}): {}', cake_commit, cake_msg), author=author,
                          committer=committer)


if __name__ == "__main__":
    main()

