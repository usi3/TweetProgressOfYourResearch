卒論の進捗をTwitterに投稿するRubyスクリプト
===========================
指定PDFファイルのページ数の変化をTwitterに投稿するスクリプトです．

スクリプト中の次の行を適切に編集してから実行してください．

	file_name = "thesis.pdf" # ここで指定したPDFファイルのページ数の変化をつぶやきます
	CONSUMER_KEY = "" # https://dev.twitter.com/
	CONSUMER_SECRET = ""
	ACCESS_TOKEN = ""
	ACCESS_TOKEN_SECRET = ""

Windowsで`file_name`に絶対パスを設定するときは\の扱いに気をつけてください．

使用例

	>ruby tweet_progress.rb
	今日は卒論を1ページも書き進めませんでした
	このつぶやきを投稿しますか？(y/n)
	y
	投稿しました

