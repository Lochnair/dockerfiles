#!/bin/bash

apt-key add /tmp/emdebian-toolchain-archive.key
rm -rf /tmp/*
dpkg --add-architecture mips
apt-get update