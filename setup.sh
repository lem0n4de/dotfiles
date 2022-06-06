#!/usr/bin/env sh
sudo pacman -S - < packages.list
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
if [ ! -d "$__config/awesome" ]; then
	echo "Linking $__config/awesome"
	ln -s "$dotfiles/awesome" "$__config/awesome"
fi
if [ ! -f "$HOME/.gitconfig" ]; then
	echo "Linking $HOME/.gitconfig"
	ln -s "$dotfiles/git/gitconfig" "$HOME/.gitconfig"
fi
if [ ! -d "$__config/kitty" ]; then
	echo "Linking $__config/kitty"
	ln -s "$dotfiles/kitty" "$__config/kitty"
fi
if [ ! -d "$__config/qtile" ]; then
	echo "Linking $__config/qtile"
	ln -s "$dotfiles/qtile" "$__config/qtile"
fi
if [ ! -f "$HOME/.zshrc" ]; then
	echo "Linking $HOME/.zshrc"
	ln -s "$dotfiles/zsh/zshrc" "$HOME/.zshrc"
fi

if [ ! -f "$HOME/.bashrc" ]; then
	echo "Linking $HOME/.bashrc"
	ln -s "$dotfiles/bash/bashrc" "$HOME/.bashrc"
fi

mkdir -p "$__config/systemd/user"
if [ ! -f "$__config/systemd/user/auto-connection.service" ]; then
	echo "Linking $__config/systemd/user/auto-connection.service";
	ln -s "$DOTFILES/configuration/wifi/auto-connection.service" "$config/systemd/user/auto-connection.service"
	systemctl --user enable auto-connection.service
fi

echo DONE
exit 0
