require File.expand_path("../bot_base", __FILE__)
Bundler.require(:twitter_bot) if defined?(Bundler)
class TwitterBot < BotBase

  def run
     bot = self
     bot.push('Starting up!')
     twstream = TweetStream::Client.new('ipadipadipad', 'georocks!')
      twstream.on_error {|error| bot.push('Error!' + error)}
      twstream.on_limit {|skip_count| bot.push("Skipped #{skip_count}") }
      twstream.track('#wcr10', '#testytest') do |status|
        puts("#{status.inspect}")
        bot.push("#{status[:user][:screen_name]}: #{status[:text]}")
      end
    end

end

if __FILE__ == $0
  TwitterBot.run!("twitterbot")
end