$(function() {
  function onLogin(assertion) {
    $.ajax({
      type: 'POST',
      url: '/api/user',
      data: { assertion: assertion },
      success: function(res, status, xhr) { window.location = '/'; },
      error: function(xhr, status, err) { alert("Login failure: " + err); }
    });
  }

  navigator.id.watch({ onlogin: onLogin, onlogout: function(){} });
  $('.signin').click(function() {
    navigator.id.request({ siteName: 'Koalab' });
    return false;
  });
});
