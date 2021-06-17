# brew
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"

# anyenv
eval "$(anyenv init -)"

# pyenv
eval "$(pyenv init -)"

# Source Prezto
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# alias
alias ll='ls -al'
alias g='git'
alias tree='tree -a -I "\.DS_Store|\.git|node_modules|build|dist|cache|coverage|\.nyc_output|vendor\/bundle" -N'

# tmux
alias ide='sh ~/.scripts/ide.sh'

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
