(function($) {
  WCR = {};
  
 $(document).ready(function() {
    WCR.odd = $('div.chat_window p:first').hasClass("odd");
    $('.chat_input_container input').keyup(function(e) {
       if (e.keyCode == 13) {
         $.post('/chat/push', {message: $(this).val()});
         $(this).val("");
       }
    });

    setTimeout(poll, 500);

    $('.chat_input_container').wrap('<div class="float-wrapper"/>').wrap('<div class="floated-input-wrapper"/>');
    $('.chat_window').css({'padding-top':$('.floated-input-wrapper').innerHeight()});

    $(window).resize(function(){
      $('.float-wrapper').css({'position':'fixed','left':(256 + 18), 'width': ( $('.chat_container').outerWidth() - 0 ) })
    });

    $(window).resize();
  });

  function poll() {
    if(WCR.stop) {
      setTimeout(poll, 500);
      return;
    }
    var last_sync = $('#last_sync').text();
    $.get('/chat/pull/' + last_sync, function(data) {
      $('#last_sync').text(data['time']);
      $(data['delta']).each(function() {
        var message = this;
		console.log(message);
        var chatMessageTemplate = '<div class="chat_message clearfix"><span class="identity"><img src="{{gravatar_url}}" /></span><span class="message">({{posted_at}}) <b class="username">{{username}}</b> {{{message}}}</span></div>';

        //var chatMessage = "<img src=\"" + message["gravatar_url"] + "\" class=\"gravatar\" /><b>" + message["username"] + "</b> " + message["message"];
        var chatMessage = Mustache.to_html(chatMessageTemplate, message);
        var chatElement = $(chatMessage);
        if(! WCR.odd) {
          chatElement.addClass("odd");
          WCR.odd = true;
        } else {
          WCR.odd = false;
        }
          
        $('div.chat_window').prepend(chatElement);
        $(window).scrollTo(0);
      });
      setTimeout(poll, 500);
    });
  }
})(jQuery)
