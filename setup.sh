#!/usr/bin/env bash

set -e
function available() {
	echo "$1 available...";
}

is_fedora() {
	cat /etc/os-release | grep "Fedora" -q
}

is_arch() {
	cat /etc/os-release | grep "Arch" -q
}

is_awesome_installed() {
	which awesome > /dev/null 2>&1
}

is_awesome_git() {
	! awesome --version | head -n 1 | grep "v4.3.3"
}

# sudo pacman -S - < packages.list
__config="$HOME/.config"
dotfiles="$HOME/.dotfiles"
echo "Checking if $__config exists..."
if [ -d "$__config" ]; then
	echo "EXISTS"
else
	echo "$__config not found. Creating..."
	mkdir "$__config"
	exit 1
fi
echo "Linking directories"
if [ ! -d "$HOME/bin" ]; then 
	echo "Linking $HOME/bin/"
	ln -s "$dotfiles/bin" "$HOME/bin"
fi
available "$HOME/bin";

if [ ! -d "$__config/awesome" ]; then
	echo "Linking $__config/awesome"
	ln -s "$dotfiles/awesome" "$__config/awesome"
	if is_arch; then
		sed -i "s/BACKLIGHT_INC/xbacklight -inc 5/" $dotfiles/awesome/config.lua
		sed -i "s/BACKLIGHT_DEC/xbacklight -dec 5/" $dotfiles/awesome/config.lua
	elif is_fedora; then
		sed -i "s/BACKLIGHT_INC/light -A 5/" $dotfiles/awesome/config.lua
		sed -i "s/BACKLIGHT_DEC/light -U 5/" $dotfiles/awesome/config.lua
	fi
fi
available "$__config/awesome";

if is_fedora; then
	echo "Installing Fedora dependencies"
	sudo dnf install $(cat dependencies-fedora.txt) -y
	# awesome not installed or an old version of it is installed
	if ! is_awesome_installed || ! is_awesome_git; then
		echo "Installing awesome from source"
		dotfiles=$dotfiles $dotfiles/awesome/fedora.install.sh
	fi
elif is_arch; then
	echo "Installing Arch dependencies"
	sudo pacman -S $(cat dependencies-arch.txt) -y
	if ! where awesome > /dev/null 2>&1 || awesome --version | head -n 1 | grep "v4.3.3" -q; then
		sudo yay -S awesome-git -y
	fi
fi
echo "Awesome from git installed"
if [ ! -f "$HOME/.gitconfig" ]; then
	echo "Linking $HOME/.gitconfig"
	ln -s "$dotfiles/git/gitconfig" "$HOME/.gitconfig"
fi
available "$HOME/.gitconfig";

if [ ! -d "$__config/kitty" ]; then
	echo "Linking $__config/kitty"
	ln -s "$dotfiles/kitty" "$__config/kitty"
fi
available "$__config/kitty";

if [ ! -d "$__config/qtile" ]; then
	echo "Linking $__config/qtile"
	ln -s "$dotfiles/qtile" "$__config/qtile"
fi
available "$__config/qtile";

if [ ! -f "$HOME/.zshrc" ]; then
	echo "Linking $HOME/.zshrc"
	ln -s "$dotfiles/zsh/zshrc" "$HOME/.zshrc"
fi
if [ ! -d "$dotfiles/zsh/ohmyzsh" ]; then
	git submodule update --init --recursive
	sh $dotfiles/zsh/ohmyzsh/tools/install.sh
	rm "$HOME/.zshrc"
	ln -s "$dotfiles/zsh/zshrc" "$HOME/.zshrc"
fi
available "$HOME/.zshrc";

if [ ! -f "$HOME/.bashrc" ]; then
	echo "Linking $HOME/.bashrc"
	ln -s "$dotfiles/bash/bashrc" "$HOME/.bashrc"
fi
available "$HOME/.bashrc";

# mkdir -p "$__config/systemd/user"
# if [ ! -f "$__config/systemd/user/auto-connection.service" ]; then
# 	echo "Linking $__config/systemd/user/auto-connection.service";
# 	ln -s "$dotfiles/configuration/wifi/auto-connection.service" "$__config/systemd/user/auto-connection.service"
# 	systemctl --user enable auto-connection.service
# fi
# available "$__config/systemd/user/auto-connection.service"

rofi_dir="$__config/rofi"
mkdir -p "$rofi_dir"
if [ ! -f "$rofi_dir/config.rasi" ]; then
	echo "Linking $rofi_dir/config.rasi";
	ln -s "$dotfiles/configuration/rofi/config.rasi" "$rofi_dir/config.rasi";
fi
available "$rofi_dir/config.rasi"

echo DONE
exit 0
