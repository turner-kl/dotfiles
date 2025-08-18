# Dotfiles

## 構築手順

### Mac
1. Homebrewをインストール  
- `ln -s $(pwd)/.Brewfile ~/.Brewfile`
2. Preztoをインストール
3. ターミナルの設定をProに変更し、フォントサイズを16にする
4. GitHubを設定する
5. 各ツールをインストールしていく
6. リンクを設定
- `ln -s $(pwd)/.zshrc ~/.zshrc`
- `ln -s $(pwd)/.zprofile ~/.zprofile`
- `ln -s $(pwd)/.vimrc ~/.vimrc`
- `ln -s $(pwd)/.tmux.conf ~/.tmux.conf`
- `ln -s $(pwd)/.gitconfig ~/.gitconfig`
- `ln -s $(pwd)/mise.toml ~/.config/mise/config.toml`
- `ln -s $(pwd)/.gitignore-global ~/.config/git/ignore`

### Windows
- dotfileのシンボリックリンクを設定する前に、zpreztoを設定する

#### WSL2
- WSL2(Windows Subsystem for Linux)導入手順   
https://qiita.com/kenchan1193/items/74edfc67910b51469b45

- Windows 10 用 Windows Subsystem for Linux のインストール ガイド  
https://docs.microsoft.com/ja-jp/windows/wsl/install-win10

#### Terminal
- Win10でzsh+preztoを使ってPowerline環境を作る  
https://qiita.com/mtsgi/items/8a844870f30b30ef21e4

- Windows TerminalでWSLのデフォルトのディレクトリを設定する   
https://qiita.com/kuangyujing/items/08d0fb01732bf67b8704


## ツール
- シンボリックリンクを貼る
```
ln -s ~/workspace/dotfiles/.zshrc ~/.zshrc

```

- 削除する
```
unlink ~/.zshrc
```

### zsh関連
#### Prezto
zshrcが存在するとエラーとなるため、dotfilesを使用する前に下記を実行し、後からリンクを貼る。  
https://github.com/sorin-ionescu/prezto  
1. Installation  
```
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
```

2. 下記を実行する
```
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done
```

3. vim ~/.zpreztorc
```
ln -s $(pwd)/.zpreztorc ~/.zpreztorc
```

#### vim
https://github.com/Shougo/neobundle.vim

#### その他
- brewでインストールするツール
```
brew bundle
```

- miseでインストールするツール
```
mise install
```

### Docker
- Windows 10 Home で WSL 2 + Docker を使う  
https://qiita.com/KoKeCross/items/a6365af2594a102a817b

### istioctl
```
curl -L https://istio.io/downloadIstio | sh -
sudo mv ~/istioctl /usr/local/bin/istioctl
```

#### プラグイン
1. インストール
```
go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2
```

2. パスを通す
```
echo 'export PATH="$PATH:'$(go env GOPATH)'/bin"' >> ~/.zshrc
```

### AWS CLI
https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/getting-started-install.html
```
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
```

#### git-secrets
```
git secrets --register-aws --global
git secrets --install ~/.git-templates/git-secrets
git config --global init.templatedir '~/.git-templates/git-secrets'
```

### zip
```
sudo apt install zip
```

## 言語

### Node.js
#### Node.js
```
mise use --global node@22
```

### Python
#### Python
```
mise use -g python@3
```