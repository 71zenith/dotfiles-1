#!/bin/zsh

# history
HISTFILE=~/.cache/zsh/history
HISTSIZE=100000
SAVEHIST=100000

# basic settings
setopt autocd nomatch INC_APPEND_HISTORY HIST_IGNORE_ALL_DUPS
unsetopt beep extendedglob notify

# colors
autoload -U colors && colors

# vi mode
bindkey -v
export KEYTIMEOUT=1

# for autocompletion {{{
fpath=($ZDOTDIR $fpath)
autoload -Uz compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-}={A-Z\_}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
  'r:|?=** m:{a-z\-}={A-Z\_}'
zmodload zsh/complist
DISABLE_UPDATE_PROMPT=true
compinit -d ~/.cache/zsh/zcompdump
_comp_options+=(globdots)		# Include hidden files
zstyle ':completion:*' list-colors
eval "$(dircolors)"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# }}}

# change cursor shape for different vi modes {{{
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.
# }}}

# ls colors
export LS_COLORS="*.jpeg=35:*.jpg=35:*.png=35:*.md=90:*.pdf=32:*.gif=35:*.tgz=31:*.mp3=92:*.tar.gz=31:*.zip=31:*.ico=35:*.css=36:*.html=05;31"

# for menus
bindkey '^[[Z' reverse-menu-complete
bindkey -M menuselect '\e' send-break
bindkey -M menuselect '^h' vi-backward-char
bindkey -M menuselect '^k' vi-up-line-or-history
bindkey -M menuselect '^l' vi-forward-char
bindkey -M menuselect '^j' vi-down-line-or-history

# for backspace working properly
bindkey "^?" backward-delete-char

# for syntax-highlighting
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=blue,underline
ZSH_HIGHLIGHT_STYLES[precommand]=fg=blue,underline
ZSH_HIGHLIGHT_STYLES[arg0]=fg=blue

# last minute startup
source ~/.local/bin/zsh/zsh-autosuggestions
source ~/.local/bin/zsh/zsh-autopair
source "$ZDOTDIR/.aliases"
source ~/.local/bin/zsh/zsh-system-clipboard
source ~/.local/bin/zsh/zsh-syntax-highlighting
source ~/.local/bin/zsh/zsh-history-substring-search

# history-substring settings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# for fzf-tab
if [ "$TERM" != "xterm-256color" ]; then
	source ~/.config/zsh/fzf-tab/fzf-tab.plugin.zsh
	zstyle ':fzf-tab:complete:*:*' fzf-preview 'fzf-preview ${(Q)realpath}'
	zstyle ':fzf-tab:complete:git:*' fzf-preview 'git help $word | bat -plman --color=always'
	zstyle ':fzf-tab:complete:git-*:*' fzf-preview 'git log --color=always $word'
	zstyle ':fzf-tab:complete:git-help:*' fzf-preview 'git help $word | bat -plman --color=always'
fi

# prompt
autoload -U promptinit; promptinit
prompt spaceship
# vim:foldmethod=marker
