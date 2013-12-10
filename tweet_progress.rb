require 'rubygems'
require 'twitter' # gem install twitter
require 'pdf-reader' # gem install pdf-reader

# 設定(適切に編集してください)
file_name = "thesis.pdf" # ここで指定したPDFファイルのページ数の変化をつぶやきます
CONSUMER_KEY = "" # https://dev.twitter.com/
CONSUMER_SECRET = ""
ACCESS_TOKEN = ""
ACCESS_TOKEN_SECRET = ""

#
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
record_file_name = file_name[0...file_name.rindex(".")] + "_page_count_history.csv"
last_count_time = 0
last_count = 0
if File.exist?(record_file_name)
  File.open(record_file_name, "r").each do |line|
    last_count_time, last_count = $1.to_i, $2.to_i if /(\d+),(\d+)/ =~ line
    break
  end
elsif
  File.open(record_file_name, "w").close
end

count = PDF::Reader.new(file_name).page_count
File.open(record_file_name,'r+') do |f|
  f.print "#{Time.now.to_i},#{count}\n#{File.open(record_file_name).read.chomp}"
end

diff_count = count - last_count
if diff_count == 0
  message = "今日は卒論を1ページも書き進めませんでした"
elsif diff_count > 0
  message = "今日は卒論を#{diff_count}ページ書き進めました"
else
  message = "今日は卒論を#{-diff_count}ページ削りました"
end

puts message
puts "このつぶやきを投稿しますか？(y/n)"
exit if STDIN.gets.chomp != "y"

begin
  client = Twitter::REST::Client.new do |config|
    config.consumer_key        = CONSUMER_KEY
    config.consumer_secret     = CONSUMER_SECRET
    config.access_token        = ACCESS_TOKEN
    config.access_token_secret = ACCESS_TOKEN_SECRET
  end
  client.update(message)
  puts "投稿しました"
rescue Twitter::Error
  puts "CONSUMER_KEY, CONSUMER_SECRET, ACCESS_TOKEN, ACCESS_TOKEN_SECRETのどれかが間違っています"
end
