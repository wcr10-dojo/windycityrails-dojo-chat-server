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

  private

  def message_args
    ['ryankinderman', 'ryan@kinderman.net', "profound message"]
  end
end
