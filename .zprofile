eval "$(/opt/homebrew/bin/brew shellenv)"

# pyenv
export PYENV_ROOT="$HOME/.anyenv/envs/pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"