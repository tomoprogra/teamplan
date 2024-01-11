$(document).ready(function() {
  $('#accept-invitation-button').on('click', function(event) {
    event.preventDefault();

    var url = $(this).attr('href');
    var csrfToken = $('meta[name="csrf-token"]').attr('content');

    $.ajax({
      url: url,
      type: 'PATCH',
      headers: {
        'X-CSRF-Token': csrfToken
      },
      success: function(response) {
        // Handle the response here.
      }
    });
  });
});

// これいらないかもしれないけど、一応残しておく