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
        var chatMessage = "<img src=\"" + message["gravatar_url"] + "\" class=\"gravatar\" /><b>" + message["username"] + "</b> " + message["message"];

        var chatElement = $('<p>' + chatMessage + '</p>');
        if(! WCR.odd) {
          chatElement.addClass("odd");
          WCR.odd = true;
        } else {
          WCR.odd = false;
        }
          
        $('div.chat_window').prepend(chatElement);
      });
      setTimeout(poll, 500);
    });
  }
})(jQuery)
