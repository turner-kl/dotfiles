# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## リポジトリの概要

このリポジトリは個人用のdotfilesを管理しており、開発環境のセットアップを自動化します。主にMac環境を対象としていますが、WindowsのWSL2環境にも対応しています。

## アーキテクチャ

### シンボリックリンク方式
**このリポジトリが設定ファイルの実体**であり、ホームディレクトリ側はシンボリックリンクです。設定ファイルの編集は必ずこのリポジトリ内で行います:
- `ln -s $(pwd)/[設定ファイル] ~/[リンク先]`
- 削除時: `unlink ~/[リンク先]`

### 手順書
READMEがセットアップ手順書を兼ねています。設定ファイルを追加・変更した場合はREADMEの手順も更新してください。
