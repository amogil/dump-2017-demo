require 'telegram/bot'
require 'asciiart'

token = '352327673:AAE_NrgQdkAA1xojcXeWHbqi6Ok85NKwA10'

Telegram::Bot::Client.run(token) do |bot|
  puts 'Starting the chatbot'

  bot.listen do |message|
    puts "Received message: #{message.inspect}"

    photo = message.photo.first
    reply = if photo
              file = bot.api.get_file(file_id: photo.file_id)
              file_path = file['result']['file_path']
              url = "https://api.telegram.org/file/bot#{token}/#{file_path}"
              art = AsciiArt.new(url)
              "`#{art.to_ascii_art(:width => 50)}`"
            else
              "Привет, #{message.from.first_name}! Ты написал: #{message.text}"
            end

    bot.api.send_message(chat_id: message.chat.id, text: reply, parse_mode: 'Markdown')
  end
end