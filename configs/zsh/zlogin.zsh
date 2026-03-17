# zlogin

autoload -U zsource
zsource $ZDOTDIR/local/zlogin.before.zsh
zsource $XDG_DATA_HOME/zsh/zlogin.before.zsh

# End of zprof
if (( $+builtins[zprof] )); then
   zprof > ./zprof.log
fi

zsource $ZDOTDIR/local/zlogin.after.zsh
zsource $XDG_DATA_HOME/zsh/zlogin.after.zsh
