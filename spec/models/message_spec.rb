require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Message do
  before :each do
    RedisClient.redis.flushall
  end

  it "can be created" do
    now = Time.local(2010, 1, 10, 13, 15, 30)
    Time.stub!(:now).and_return(now)

    Message.create!(
      username = 'ryankinderman',
      email = 'ryan@kinderman.net',
      message = 'profound message')

    Message.find_last.should == {
      :username => username,
      :email => email,
      :message => message,
      :time_stamp => now.to_f * 1000,
      :posted_at => "13:15:30"
    }.to_json
  end
  
  describe '#parse' do
    
    it 'parses strings that match images into an image tag' do
      Message.new('user', 'email', 'http://image.jpg').message.should == '<img src="http://image.jpg" />'
    end
    
    it 'parses strings that match youtube videos into embeds' do
      embed_code = %q|<object width="480" height="385"><param name="movie" value="http://www.youtube.com/v/jP0K6NnuP3w?fs=1&amp;hl=en_US"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/jP0K6NnuP3w?fs=1&amp;hl=en_US" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="480" height="385"></embed></object>|
      Message.new('user', 'email', 'http://www.youtube.com/watch?v=jP0K6NnuP3w').message.should == embed_code
    end
    
    it 'doesnt mess with plain ol strings' do
      Message.new('user', 'email', 'some message').message.should == 'some message'
    end
    
  end

  private

  def message_args
    ['ryankinderman', 'ryan@kinderman.net', "profound message"]
  end
end
