# dotfile使い方
- dotfilesの.zshrcにシンボリックリンクを貼る 
```
ln -s ~/workspace/dotfiles/.zshrc ~/.zshrc
```

- 削除
```
unlink ~/.zshrc
```

## zsh
### Prezto
zshrcが存在するとエラーとなるため、dotfilesを使用する前に下記を実行し、後からリンクを貼る。  
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
あるいはリンク
```
ln -s ~/workspace/dotfiles/.zpreztorc ~
```

# Mac環境構築  
1.Homebrewをインストール  

# Windows環境構築
dotfileのシンボリックリンクを設定する前に、zpreztoを設定する。
## WSL2
- WSL2(Windows Subsystem for Linux)導入手順   
https://qiita.com/kenchan1193/items/74edfc67910b51469b45

- Windows 10 用 Windows Subsystem for Linux のインストール ガイド  
https://docs.microsoft.com/ja-jp/windows/wsl/install-win10

## peco
```
brew install peco
```

## ghq 
```
brew install ghq
``` 

## GitHub設定
- SSH設定

## Terminal
- Win10でzsh+preztoを使ってPowerline環境を作る  
https://qiita.com/mtsgi/items/8a844870f30b30ef21e4

- Windows TerminalでWSLのデフォルトのディレクトリを設定する   
https://qiita.com/kuangyujing/items/08d0fb01732bf67b8704

## tmux
```
brew install tmux
```

## Docker
- Windows 10 Home で WSL 2 + Docker を使う  
https://qiita.com/KoKeCross/items/a6365af2594a102a817b

## asdf
```
brew install asdf
```

### Node.js
- Node.js
```
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install nodejs 16.6.2
```

## AWS CLI
```
pip install awscli --upgrade
pip install aws-sam-cli
```

## Git
```
git config --global user.email "sample@email.com"
git config --global user.name "turner-kl"
git config --global ghq.root '~/workspace'
git config --global alias.co checkout
```

## git-secrets
```
brew install git-secrets
git secrets --register-aws --global
git secrets --install ~/.git-templates/git-secrets
git config --global init.templatedir '~/.git-templates/git-secrets'
```

## zip
```
sudo apt install zip
```

## Java
- sdkman
```
curl -s https://get.sdkman.io | bash
```

- java 
```
sdk install java
```

## cmake
```
brew install cmake
```

## deno
- https://deno.land/
```
curl -fsSL https://deno.land/x/install/install.sh | sh
```