#!/bin/bash
dir=$(pwd)
sudo dnf install $(cat $dotfiles/awesome/dependencies-fedora.txt) -y
git clone "https://github.com/awesomeWM/awesome" /tmp/awesome
cd /tmp/awesome
make
make package
sudo rpm -Uvh build/awesome-*.rpm
luarocks install --local dbus_proxy --deps-mode none
cd $dir
