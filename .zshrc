# Lines configured by zsh-newuser-install
setopt autocd extendedglob nomatch
unsetopt beep notify
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/destycoon/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

clear

eval "$(starship init zsh)"

fastfetch