# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## リポジトリの概要

このリポジトリは個人用のdotfilesを管理しており、開発環境のセットアップを自動化します。主にMac環境を対象としていますが、WindowsのWSL2環境にも対応しています。

## アーキテクチャ

### シンボリックリンク方式
設定ファイルはリポジトリ内で管理し、ホームディレクトリへシンボリックリンクを張る方式を採用しています:
- `ln -s $(pwd)/[設定ファイル] ~/[リンク先]`
- 削除時: `unlink ~/[リンク先]`

### パッケージ管理の階層
1. **Homebrew** (.Brewfile): システムレベルのツールとアプリケーション
   - コマンド: `brew bundle`
2. **mise** (mise.toml): プログラミング言語のバージョン管理
   - コマンド: `mise install`
   - 管理対象: Go, Node.js, Python, uv, Deno

## セットアップ手順の順序

Mac環境の場合、以下の順序でセットアップを行う必要があります:

1. Homebrewをインストール → .Brewfileをリンク
2. Prezto(zshフレームワーク)をインストール
   - **注意**: dotfilesをリンクする前に実行する必要がある
   - 理由: Preztoのセットアップスクリプトは既存のzshrcファイルがあるとエラーになる
3. 各種設定ファイルをシンボリックリンク
4. miseでプログラミング言語をインストール

## 重要な依存関係

### Preztoのセットアップ
```bash
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done
ln -s $(pwd)/.zpreztorc ~/.zpreztorc
```

### git-secretsの設定
AWS関連の機密情報を誤ってコミットしないための設定:
```bash
git secrets --register-aws --global
git secrets --install ~/.git-templates/git-secrets
git config --global init.templatedir '~/.git-templates/git-secrets'
```

## 主要な設定ファイル

- `.zshrc`: シェルの基本設定
- `.zpreztorc`: Preztoのモジュール設定
- `.vimrc`: Vim設定(NeoBundle使用)
- `.tmux.conf`: ターミナルマルチプレクサ設定
- `.gitconfig`: Git全体設定
- `.Brewfile`: Homebrew管理パッケージリスト
- `mise.toml`: 言語バージョン管理設定
- `claude/settings.json`: Claude Code設定
- `claude/CLAUDE.md`: Claude Codeグローバル指示(個人設定)

## プラットフォーム固有の注意事項

### Windows/WSL2
- dotfilesのシンボリックリンク設定前にzpreztoを先にセットアップする
- Windows Terminalのデフォルトディレクトリ設定が必要な場合がある
