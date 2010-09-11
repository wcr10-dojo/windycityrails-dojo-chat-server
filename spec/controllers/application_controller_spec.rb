require 'spec_helper'

describe ApplicationController do
  
  describe '#gravatar_url' do
    it "should take an e-mail address" do
      lambda {
        controller.gravatar_url("ddemaree@metromix.com")
      }.should_not raise_error
    end
    
    it "should generate an MD5 hash of the given e-mail address" do
      Digest::MD5.should_receive(:hexdigest).with("ddemaree@metromix.com")
      controller.gravatar_url("ddemaree@metromix.com")
    end
    
    it "should return a gravatar.com URL" do
      gravatar_url = controller.gravatar_url("ddemaree@metromix.com")
      gravatar_url.should =~ %r{http://gravatar.com}
    end
  end
  
end