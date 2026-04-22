# zshenv

autoload -U zsource
zsource $XDG_DATA_HOME/zsh/zshenv.before.zsh

autoload -U add-to-env
add-to-env path $HOME/.local/bin

zsource $XDG_DATA_HOME/zsh/zshenv.after.zsh
