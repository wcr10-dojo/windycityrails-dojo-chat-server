class Youtube < Message::Processor
  def process
    return unless @message.match(/youtube.com\/watch\?v=(\w+)/)
    %Q|<object width="480" height="385"><param name="movie" value="http://www.youtube.com/v/#{$1}?fs=1&amp;hl=en_US"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/#{$1}?fs=1&amp;hl=en_US" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="480" height="385"></embed></object>|
  end
end