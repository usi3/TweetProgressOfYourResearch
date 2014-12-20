# -*- encoding: utf-8 -*-
require 'rubygems'
require 'yaml'
require 'twitter' # gem install twitter
require 'pdf-reader' # gem install pdf-reader

# 設定の読み込み
YCONF = YAML.load_file("config.yaml")
enable_hashtag = YCONF["ENABLE_HASHTAG"]
pdf_path = YCONF["PDF_FILE_PATH"]
tex_path = YCONF["TEX_FILE_PATH"]
tex_file_encoding = YCONF["TEX_FILE_ENCODING"]
thesis_name = YCONF["THESIS_NAME"]

#
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
record_file_name = pdf_path[0...pdf_path.rindex(".")] + "_history.csv"
last_count_time = 0
last_page_count = 0
last_character_count = 0
if File.exist?(record_file_name)
  File.open(record_file_name, "r").each do |line|
    last_count_time, last_page_count, last_character_count = $1.to_i, $2.to_i, $3.to_i if /(\d+),(\d+),(\d+)/ =~ line
    break
  end
elsif
  File.open(record_file_name, "w").close
end

page_count = PDF::Reader.new(pdf_path).page_count

if File.exist?(tex_path)
  content = File.open(tex_path, "r:#{tex_file_encoding}").read
  character_count = content.split(//).size
end

File.open(record_file_name,'r+') do |f|
  f.print "#{Time.now.to_i},#{page_count},#{character_count}\n#{File.open(record_file_name).read.chomp}"
end

diff_page_count = page_count - last_page_count
diff_character_count = character_count - last_character_count

# 進捗に関する投稿
message_list = []
if diff_page_count == 0
  if diff_character_count == 0
    message_list.push "今日は#{thesis_name}を1文字も書き進めませんでした"
  elsif diff_character_count > 0
    message_list.push "今日は#{thesis_name}を#{diff_character_count}文字書き進めました"
  else
    message_list.push "今日は#{thesis_name}を#{-diff_character_count}文字削りました"
  end
elsif diff_page_count > 0
  message_list.push "今日は#{thesis_name}を#{diff_page_count}ページ書き進めました"
else
  message_list.push "今日は#{thesis_name}を#{-diff_page_count}ページ削りました"
end

# 実績解除に関する投稿
if page_count >= 50 && page_count/10 - last_page_count/10 > 0
  message_list.push "[祝]#{thesis_name}のページ数が#{(page_count/10)*10}ページを超えました"
end
if character_count >= 40000 && character_count/5000 - last_character_count/5000 > 0
  message_list.push "[祝]#{thesis_name}の文字数が#{(character_count/5000)*5000}文字を超えました"
end

begin
  client = Twitter::REST::Client.new do |config|
    config.consumer_key        = YCONF["CONSUMER_KEY"]
    config.consumer_secret     = YCONF["CONSUMER_SECRET"]
    config.access_token        = YCONF["ACCESS_TOKEN"]
    config.access_token_secret = YCONF["ACCESS_TOKEN_SECRET"]
  end
  
  message_list.each do |mes|
    if enable_hashtag
      mes += " ##{thesis_name}クエスト https://github.com/usi3/TweetProgressOfYourResearch"
    end
    puts mes
    puts "このつぶやきを投稿しますか？(y/n)"
    next if STDIN.gets.chomp != "y"
    client.update(mes)
    puts "投稿しました"
  end
rescue Twitter::Error
  puts "CONSUMER_KEY, CONSUMER_SECRET, ACCESS_TOKEN, ACCESS_TOKEN_SECRETのどれかが間違っています"
  puts "進捗の履歴は#{record_file_name}に記録されました"
end
