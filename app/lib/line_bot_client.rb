require "line/bot"

class LineBotClient
  class << self
    attr_reader :client

    def client
      @client ||= Line::Bot::Client.new do |config|
        config.channel_secret = ENV['CAFE_LINE_CHANNEL_SECRET']
        config.channel_token = ENV['CAFE_LINE_CHANNEL_TOKEN']
      end
    end

    def push_message(text, to: ENV['CAFE_LINE_USER_ID'])
      message = {
        type: 'text',
        text: text
      }
      client.push_message(to, message)
    rescue => exception
      puts "[Error] Push Line message failed!"
      puts exception
    end
  end
end
