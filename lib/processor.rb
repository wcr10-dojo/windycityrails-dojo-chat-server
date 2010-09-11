class Processor
  
  def initialize(message)
    @message = message
  end
  
  def self.process(message)
    new(message).process
  end
  
  def process
    #implement this in custom processor
  end
  
end
