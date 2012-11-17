$(function() {
  function onLogout() {
    $.ajax({
      type: 'POST',
      url: '/logout',
      success: function(res, status, xhr) { window.location = '/login'; },
      error: function(xhr, status, err) { alert("Logout failure: " + err); }
    });
  }

  navigator.id.watch({ loggedInUser: 'bob@example.org', onlogin: function(){}, onlogout: onLogout });
  $('.logout').click(function() {
    navigator.id.logout();
    return false;
  });
});
