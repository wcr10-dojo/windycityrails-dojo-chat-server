require File.expand_path("../bot_base", __FILE__)

class EchoBot < BotBase
  
  def respond(message_user, message_text)
    if message_user == username
      nil
    else
      Rails.logger.info %Q{Echoing "#{message_text}" from #{message_user}}
      message_text
    end
  end
end

if __FILE__ == $0
  EchoBot.run!("Annoy-o-Tron-omatic")
end
