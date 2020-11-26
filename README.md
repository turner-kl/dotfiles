## General
dotfilesの.zshrcにシンボリックリンクを貼る 
```
ln -s ~/workspace/dotfiles/.zshrc ~
```

## zsh
### Prezto
https://github.com/sorin-ionescu/prezto  
1. Installation  
```
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
```
2. Create a new Zsh configuration by copying the Zsh configuration files provided:
```
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done
```

3. vim ~/.zpreztorc
```
zstyle ':prezto:module:prompt' theme 'pure'
```

"" Mac環境構築  
1.Homebrewをインストール  

