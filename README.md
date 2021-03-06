卒論クエスト
===========================
TeXで書いている学位請求論文の進捗をTwitterに投稿するRubyスクリプトです．  
設定すれば「修論クエスト」および「博論クエスト」にも変更可能です．

TeXファイルの文字数の変化やPDFファイルのページ数の変化をつぶやきます．  
一定のページ数や文字数を超えた場合は実績解除のお祝いメッセージもつぶやきます．

## 依存ライブラリ
このプログラムを実行するためにはRubyの実行環境が必要です．  
次の二つのライブラリに依存しています．

- [sferik/twitter](https://github.com/sferik/twitter)
- [yob/pdf-reader](https://github.com/yob/pdf-reader)

ライブラリの導入コマンド

```sh
> gem install twitter
> gem install pdf-reader
```

## 設定
`config.yaml`を適切に編集してから実行してください．

```ruby
# 設定ファイル
# 
# つぶやきにハッシュタグを加えるかどうか[true,false]
ENABLE_HASHTAG: false
# texファイルのパス
# Windowsで絶対パスを指定する場合は\(バックスラッシュ)の扱いに気をつけてください
TEX_FILE_PATH: "thesis.tex"
# texファイルのエンコーディング
TEX_FILE_ENCODING: "UTF-8"
# pdfファイルのパス
PDF_FILE_PATH: "thesis.pdf"
# Xクエスト（Xには"卒論", "修論", "博論"などを指定）
THESIS_NAME: "卒論"
# OAuth認証の設定
# 次の開発者向けページで新規アプリケーションを作成してください
# https://dev.twitter.com/
CONSUMER_KEY: ""
CONSUMER_SECRET: ""
ACCESS_TOKEN: ""
ACCESS_TOKEN_SECRET: ""
```

## 使用例
「進捗ありません・・・」

	>ruby tweet_progress.rb
	今日は卒論を1文字も書き進めませんでした
	このつぶやきを投稿しますか？(y/n)
	y
	投稿しました

「進捗はありますが・・・わざわざつぶやく必要性を感じません．どうしてつぶやくんですか？」

	>ruby tweet_progress.rb
	[祝]卒論のページ数が50ページを超えました
	このつぶやきを投稿しますか？(y/n)
	n

「あ！今日は！著しい進捗がありました！！！」

	>ruby tweet_progress.rb
	[祝]卒論の文字数が40000文字を超えました
	このつぶやきを投稿しますか？(y/n)
	y
	投稿しました

## 進捗のロギング
このプログラムは起動してすぐに`PDF_FILE_PATH`から拡張子を除いて`_history.csv`を付加したパスに次のフォーマットで進捗を記録します．

	<UNIX Time>,<TeXファイルの文字数>,<PDFファイルのページ数>

この機能はTwitterのOAuth認証に関する設定がなくても動作します．この場合の使用例を次に示します．

	>ruby tweet_progress.rb
	今日は卒論を1文字も書き進めませんでした
	このつぶやきを投稿しますか？(y/n)
	y
	CONSUMER_KEY, CONSUMER_SECRET, ACCESS_TOKEN, ACCESS_TOKEN_SECRETのどれかが間違っています
	進捗の履歴はthesis_history.csvに記録されました
