# zshrc

autoload -U zsource
zsource $XDG_DATA_HOME/zsh/zshrc.before.zsh

# Create XDG Base Directory as needed
[[ -d $XDG_DATA_HOME/zsh ]]  || mkdir -p $XDG_DATA_HOME/zsh
[[ -d $XDG_CACHE_HOME/zsh ]] || mkdir -p $XDG_CACHE_HOME/zsh
[[ -d $XDG_STATE_HOME/zsh ]] || mkdir -p $XDG_STATE_HOME/zsh

###############################################################################
# Basic
###############################################################################

HISTFILE=$XDG_STATE_HOME/zsh/history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt share_history

setopt auto_cd
setopt auto_pushd

LISTMAX=0 # show all completion candidates
setopt list_packed

setopt no_beep

REPORTTIME=3

# Disable correction
ENABLE_CORRECTION="false"
unsetopt correct_all
unsetopt correct

WORDCHARS='*?_-.[]~=&;!#$%^(){}<>' # exclude "/" for ctrl-W convenience
bindkey -d  # reset keybind
bindkey -e  # emacs keybind

###############################################################################
# Plugins (zinit)
###############################################################################

typeset -g -A ZINIT
ZINIT[HOME_DIR]=$XDG_CACHE_HOME/zinit
ZINIT[BIN_DIR]=$ZINIT[HOME_DIR]/bin
ZINIT[ZCOMPDUMP_PATH]=$XDG_CACHE_HOME/zsh/compdump
ZPFX=$ZINIT[HOME_DIR]/polaris

if [[ ! -d $ZINIT[BIN_DIR] ]]; then
   print "==> Setup zinit..."
   [[ -d $ZINIT[HOME_DIR] ]] || mkdir -p $ZINIT[HOME_DIR]
   (( $+commands[git] )) && git clone https://github.com/zdharma-continuum/zinit.git $ZINIT[BIN_DIR]
fi

if [[ -f $ZINIT[BIN_DIR]/zinit.zsh ]]; then
   source $ZINIT[BIN_DIR]/zinit.zsh
fi

if (( $+functions[zinit] )); then
   # Prompt (pure)
   zinit ice pick"async.zsh" src"pure.zsh"; zinit light sindresorhus/pure

   # Cosmetic
   zinit ice wait"0" atinit"zpcompinit; zpcdreplay"; zinit light zsh-users/zsh-syntax-highlighting
   zinit ice wait"0" atload"zpcompinit; zpcdreplay"; zinit light ascii-soup/zsh-url-highlighter
   zinit ice wait"0" blockf; zinit snippet OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh

   # Experience
   zinit ice wait"0" atload"_zsh_autosuggest_start"; zinit light zsh-users/zsh-autosuggestions

   # Function development
   zinit ice wait"0"; zinit light mollifier/zload

   # Completions
   zinit ice wait"0" blockf; zinit light zsh-users/zsh-completions
   zinit ice lucid nocompile; zinit load MenkeTechnologies/zsh-cargo-completion
fi

###############################################################################
# Completion
###############################################################################

autoload +X -U compinit && compinit -C -d $XDG_CACHE_HOME/zsh/compdump

autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey '^P' history-beginning-search-backward-end
bindkey '^N' history-beginning-search-forward-end

bindkey '^[[Z' reverse-menu-complete # reverse completion by Shift-Tab

# 補完方法毎にグループ化する。
zstyle ':completion:*' format '%B%F{blue}%d%f%b'
zstyle ':completion:*' group-name ''

# 補完侯補をメニューから選択する。
# select=2: 補完候補を一覧から選択する。補完候補が2つ以上なければすぐに補完する。
zstyle ':completion:*:default' menu select=2

# 補完候補がなければより曖昧に候補を探す。
# m:{a-z}={A-Z}: 小文字を大文字に変えたものでも補完する。
# r:|[._-]=*: 「.」「_」「-」の前にワイルドカード「*」があるものとして補完する。
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' keep-prefix
zstyle ':completion:*' recent-dirs-insert both

# 補完候補
# _oldlist 前回の補完結果を再利用する。
# _complete: 補完する。
# _match: globを展開しないで候補の一覧から補完する。
# _history: ヒストリのコマンドも補完候補とする。
# _ignored: 補完候補にださないと指定したものも補完候補とする。
# _approximate: 似ている補完候補も補完候補とする。
# _prefix: カーソル以降を無視してカーソル位置までで補完する。
zstyle ':completion:*' completer _complete _match _approximate _prefix

# 補完候補をキャッシュする。
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path $XDG_CACHE_HOME/zsh/compcache

# sudo の時にコマンドを探すパス
zstyle ':completion:*:sudo:*' command-path \
   /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin

# Better SSH/Rsync/SCP Autocomplete
# source: https://www.codyhiar.com/blog/zsh-autocomplete-with-ssh-config-file/
zstyle ':completion:*:(scp|rsync):*' tag-order \
   ' hosts:-ipaddr:ip\ address hosts:-host:host files'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns \
   '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns \
   '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' \
   '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'

stty stop   undef   # Free Ctrl-S
stty start  undef   # Free Ctrl-Q

###############################################################################
# Applications
###############################################################################

# Editors
if [[ "$TERM_PROGRAM" == "vscode" ]]; then
   export VISUAL="code --wait"
   export EDITOR="$VISUAL"
elif [[ "$TERM_PROGRAM" == "zed" ]]; then
   export VISUAL="zed"
   export EDITOR="$VISUAL"
elif (( $+commands[nvim] )); then
   export VISUAL="nvim"
   export EDITOR="$VISUAL"
else
   export VISUAL="vim"
   export EDITOR="$VISUAL"
fi

# ls
autoload -Uz add-zsh-hook
autoload -U colors && colors
export LS_COLORS=di="1;34:ln=35:so=32:pi=33:ex=31:bd=30;46:cd=30;43:su=30;41:sg=30;46:tw=37;42:ow=30;43"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
case $(uname -s) in
   Linux)
      alias ls='ls --color=auto --group-directories-first'
      zstyle ':completion:*' list-dirs-first true
      ;;
   Darwin)
      export LSCOLORS="Exfxcxdxbxagadabaghcad"
      export CLICOLOR=1
      ;;
esac

# brew
case $(uname -s) in
   Linux)
      BREW_ROOT=${BREW_ROOT:-/home/linuxbrew/.linuxbrew}
      ;;
   Darwin)
      BREW_ROOT=${BREW_ROOT:-/opt/homebrew}
      ;;
esac
if [[ -d $BREW_ROOT ]]; then
   eval "$($BREW_ROOT/bin/brew shellenv)"
else
   unset BREW_ROOT
fi

# mise
if (( $+commands[mise] )); then
   eval "$(mise activate zsh)"
   eval "$(mise completion zsh)"
fi

# psql
[[ -d $XDG_STATE_HOME/psql ]] || mkdir -p $XDG_STATE_HOME/psql
export PSQL_HISTORY="$XDG_STATE_HOME/psql/history"

# navi
if (( $+commands[navi] )); then
   eval "$(navi widget zsh)"
   typeset -T -Ux NAVI_PATH navi_path
fi

# vim
## Alias for custom vimrc; avoid VIMINIT to interfere with neovim's config
alias vim='vim -u $XDG_CONFIG_HOME/vim/vimrc'

# tmux
## config
export TMUX_CONFIG_DIR=$XDG_CONFIG_HOME/tmux
alias tmux='tmux -f $TMUX_CONFIG_DIR/tmux.conf'
## auto-update environment variable
if [[ -n $TMUX ]]; then
   autoload -Uz tmux-update-env
   autoload -Uz add-zsh-hook
   add-zsh-hook preexec tmux-update-env
fi

# rm
## safety mechanism
if (( ${+commands[mv2trash]} )); then
   alias rm='mv2trash'
else
   alias rm='rm -i'
fi

# tac
## alias if unavailable (e.g. on macOS)
if (( ! ${+commands[tac]} )); then
   alias tac="tail -r"
fi

# fzf
if (( ${+commands[fzf]} )); then
   source <(fzf --zsh)
fi

alias grep='grep --color=auto'

autoload -U unarchive && alias -s {gz,tgz,zip,lzh,bz2,tbz,Z,tar,arj,xz,7z}='unarchive'
alias -s {png,jpg,bmp,PNG,JPG,BMP}='open'

autoload -Uz colors256

if (( $+commands[sshfs] )); then
   autoload -Uz sshmount
fi

if (( $+commands[git] )); then
   autoload -Uz git-root
fi

if (( $+commands[git] && $+commands[fzf] )); then
   autoload -Uz git-checkout-fzf
fi

if (( $+commands[ghq] && $+commands[fzf] )); then
   autoload -Uz ghq-cd-fzf
fi

compdef zsource='source'

# Clipboard compatibility
if [[ $(uname -s) = Linux ]] && (( $+commands[xclip] )); then
   alias pbcopy='xclip -sel c'
   alias pbpaste='xclip -sel c -o'
fi

zsource $XDG_DATA_HOME/zsh/zshrc.after.zsh
