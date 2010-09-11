class Image < Message::Processor
  
  def process
    return false unless @message =~ /^http:\/\/.+\.(png|jpg|jpeg|gif)$/i 
    %Q|<img src="#{@message}" />|
  end
  
end
