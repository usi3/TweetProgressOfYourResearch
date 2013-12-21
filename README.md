卒論クエスト
===========================
TeXで書いている学位請求論文の進捗をTwitterに投稿するスクリプトです．

TeXファイルの文字数の変化やPDFファイルのページ数の変化をつぶやきます．
一定のページ数や文字数を超えた場合はお祝いメッセージもつぶやきます．

`config.yaml`を適切に編集してから実行してください．
	# 設定ファイル
	# 
	# つぶやきにハッシュタグを加えるかどうか[true,false]
	ENABLE_HASHTAG: true
	# texファイルのパス
	# Windowsで絶対パスを指定する場合は\(バックスラッシュ)の扱いに気をつけてください
	TEX_FILE_PATH: "thesis.tex"
	# texファイルのエンコーディング
	TEX_FILE_ENCODING: "UTF-8"
	# pdfファイルのパス
	PDF_FILE_PATH: "thesis.pdf"
	# OAuth認証の設定
	# 次のURLで新規アプリケーションを作成してください
	# https://dev.twitter.com/
	CONSUMER_KEY: ""
	CONSUMER_SECRET: ""
	ACCESS_TOKEN: ""
	ACCESS_TOKEN_SECRET: ""

## 使用例

	>ruby tweet_progress.rb
	今日は卒論を1文字も書き進めませんでした
	このつぶやきを投稿しますか？(y/n)
	y
	投稿しました

	>ruby tweet_progress.rb
	[祝]卒論のページ数が50ページを超えました
	このつぶやきを投稿しますか？(y/n)
	n

	>ruby tweet_progress.rb
	[祝]卒論の文字数が40000文字を超えました
	このつぶやきを投稿しますか？(y/n)
	y
	投稿しました
