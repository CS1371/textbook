$('.container').prepend('<div class="push"></div>');

$('.push').height(function(){
    h = $(this).siblings('.content').height();
    return h;
});

$(window).resize(function() {
  $('.push').css({'height':($('.content').height())+'px'});
});

