for i in './dot.*' $CUSTOM_DIR; do
    ls -1 $i | while read line; do
        echo $line
        ln -fs `pwd`/$line ~/`echo $line | sed -e 's/^\.\/dot//' | sed -e 's/^\.\.\/dot//'`;
    done
done

mkdir -p "${HOME}/.config"
mkdir -p "${HOME}/.config/ghostty"

ln -sf starship.toml "${HOME}/.config/starship.toml"
ln -sf ghostty_config "${HOME}/.config/ghostty/config"

brew install starship zsh-syntax-highlighting zsh-autosuggestions
