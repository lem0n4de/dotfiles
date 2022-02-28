#!env sh
__config="$HOME/.config"
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
	ln -s "$(pwd)/bin" "$HOME/bin"
fi
if [ ! -d "$__config/awesome" ]; then
	echo "Linking $__config/awesome"
	ln -s "$(pwd)/awesome" "$__config/awesome"
fi
if [ ! -f "$HOME/.gitconfig" ]; then
	echo "Linking $HOME/.gitconfig"
	ln -s "$(pwd)/git/gitconfig" "$HOME/.gitconfig"
fi
if [ ! -d "$__config/kitty" ]; then
	echo "Linking $__config/kitty"
	ln -s "$(pwd)/kitty" "$__config/kitty"
fi
if [ ! -d "$__config/qtile" ]; then
	echo "Linking $__config/qtile"
	ln -s "$(pwd)/qtile" "$__config/qtile"
fi
if [ ! -f "$HOME/.zshrc" ]; then
	echo "Linking $HOME/.zshrc"
	ln -s "$(pwd)/zsh/zshrc" "$HOME/.zshrc"
fi
echo DONE
exit 1
