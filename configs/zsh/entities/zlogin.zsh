# zlogin

autoload -U zsource
zsource $XDG_DATA_HOME/zsh/zlogin.before.zsh

# End of zprof
if (( $+builtins[zprof] )); then
   zprof > ./zprof.log
fi

zsource $XDG_DATA_HOME/zsh/zlogin.after.zsh
