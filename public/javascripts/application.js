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

    $('.show_more').live('click', function(event){
      $(this).next('.message-extended').toggle();
      $(this).hide();
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
          
        $('div.chat_window').prepend(formatChatMessage(this));
      });
      setTimeout(poll, 500);
    });

    function formatChatMessage(message) {
      var chatMessage = "<b>" + message["username"] + "</b> " + message["message"].substring(0, 499);

      if (message["message"].length > 500) {
        chatMessage += "<span class='extended'> <a href='#' class='show_more'>more</a> <span class='message-extended' style='display:none'>" + message["message"].substring(500, message.length) + "</span></span>";
      }

      chatMessage = "<p>" + chatMessage + "</p>";
      var chatElement = $(chatMessage);

      if(! WCR.odd) {
        chatElement.addClass("odd");
        WCR.odd = true;
      } else {
        WCR.odd = false;
      }
      return chatElement;
    }
  }
})(jQuery)
