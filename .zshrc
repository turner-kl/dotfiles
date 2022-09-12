# brew
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"

# wabt
export PATH="$HOME/.wabt/bin:$PATH"

# deno
export DENO_INSTALL="/Users/ryo/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# asdf
. $(brew --prefix asdf)/libexec/asdf.sh
th=(${ASDF_DIR}/completions $fpath)
autoload -Uz compinit && compinit

# Source Prezto
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# alias
alias ll='ls -al'
alias g='git'
alias tree='tree -a -I "\.DS_Store|\.git|node_modules|build|dist|cache|coverage|\.nyc_output|vendor\/bundle" -N'
alias awsmfa='sh ~/.scripts/aws-mfa.sh'

# tmux
alias ide='sh ~/.scripts/ide.sh'

# peco settings
function peco-select-history() {
  BUFFER=$(\history -n -r 1 | peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

# search a destination from cdr list
if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
    autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
    add-zsh-hook chpwd chpwd_recent_dirs
    zstyle ':completion:*' recent-dirs-insert both
    zstyle ':chpwd:*' recent-dirs-default true
    zstyle ':chpwd:*' recent-dirs-max 1000
    zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/chpwd-recent-dirs"
fi

function peco-cdr () {
    local selected_dir="$(cdr -l | sed 's/^[0-9]\+ \+//' | peco --prompt="cdr >" --query "$LBUFFER")"
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
}
zle -N peco-cdr
bindkey '^E' peco-cdr

# peco - ghq
function peco-src () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-src
bindkey '^G' peco-src

# branch
alias -g lb='`git branch | peco --prompt "GIT BRANCH>" | head -n 1 | sed -e "s/^\*\s*//g"`'

# aws cli profile
function peco-aws-profile() {
   PROFILES=$(aws configure list-profiles)
   PROFILES_ARRAY=($(echo $PROFILES))
   SELECTED_PROFILE=$(echo $PROFILES | peco)

   [[ -n ${PROFILES_ARRAY[(re)${SELECTED_PROFILE}]} ]] && export AWS_PROFILE=${SELECTED_PROFILE}; echo 'Updated profile' || echo ''
}
zle -N peco-aws-profile
bindkey '^A' peco-aws-profile

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
