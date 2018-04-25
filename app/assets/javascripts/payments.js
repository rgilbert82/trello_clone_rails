jQuery(function($) {
  $('#payment-form').submit(function(e) {
    var $form = $(this);
    var $submitButton = $form.find('input[type="submit"]');

    $submitButton.val("...processing");
    $submitButton.addClass('processing_payment');
    $submitButton.prop('disabled', true);
    Stripe.createToken($form, stripeResponseHandler);
    return false;
  });
});

var stripeResponseHandler = function(status, response) {
  var $form = $('#payment-form');
  var $submitButton = $form.find('input[type="submit"]');

  if (response.error) {
    // Show the errors on the form
    $form.find('.payment-errors').text(response.error.message);
    $submitButton.val("Create New Account");
    $submitButton.removeClass('processing_payment');
    $submitButton.prop('disabled', false);
  } else {
    // token contains id, last4, and card type
    var token = response.id;
    console.log(token);
    // Insert the token into the form so it gets submitted to the server
    $form.append($('<input type="hidden" name="stripeToken" />').val(token));
    // and submit
    $form.get(0).submit();
  }
};
