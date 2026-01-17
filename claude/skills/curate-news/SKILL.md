---
name: curate-news
description: engineering.fyi、hatena.blog/dev等から技術記事をキュレーション。ニュース、技術ブログ、エンジニアリング記事のピックアップ時に使用。
context: fork
agent: general-purpose
model: haiku
---

# News Curation Skill

技術ニュースとブログ記事をキュレーションするスキル。

## タスク

1. プロジェクトの `news/sources.md` からソースURLを取得
2. 各ソースの最新記事をWebFetchで取得（並列実行）
3. `news/preferences.md` の基準でフィルタリング
4. 5件選んで一次解説付きで返す

## ソース取得

以下のアグリゲーターから記事を取得:
- https://engineering.fyi/
- https://hatena.blog/dev

## フィルタリング基準

`news/preferences.md` に基づき、以下を優先:

### Primary Topics
- アジャイル/スクラム
- エンジニアリング組織/マネジメント
- プロダクト開発
- クラウド/AWS

### Secondary Topics
- データサイエンス
- フロントエンド
- 関数型プログラミング/並行処理

### 選定基準
1. 表面的なチュートリアルより、設計判断の背景や失敗談
2. 新しいツール紹介より、問題解決のアプローチ
3. 組織・チームに関する実践知見
4. 技術的に深い考察

## 出力形式

Markdown形式で以下を返す:

```markdown
## ピックアップ記事

### 1. [記事タイトル](URL)
**一次解説**: なぜピックアップしたか、記事の要点を2-3行で説明

### 2. [記事タイトル](URL)
**一次解説**: ...

（5件まで）
```

## 実行手順

1. WebFetchで engineering.fyi と hatena.blog/dev を並列取得
2. 取得した記事リストからpreferences.mdの基準に合う記事を選定
3. 選定した5件について一次解説を作成
4. 結果をMarkdown形式で返す

## 注意事項

- 日本語で解説を記述
- シニアエンジニア〜EM/テックリード向けの視点で選定
- 「Why」を重視した解説を心がける
