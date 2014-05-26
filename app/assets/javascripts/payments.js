function PaymillResponseHandler(error, result) {
	if (error) {
		// Displays the error above the form
		$(".payment-errors").text(error.apierror);
	} else {
		$(".payment-errors").text("");

		var form = $("#payment-form");
		// Token
		var token = result.token;

		// Insert token into form in order to submit to server
		form.append("<input type='hidden' name='paymillToken' value='" + token + "'/>");
		form.get(0).submit();
	}
	$(".submit-button").removeAttr("disabled");
}


$(document).ready(function() {
	
  $("#payment-form").submit(function(event) {
    // Deactivate submit button to avoid further clicks
    $('.submit-button').attr("disabled", "disabled");

	if (!paymill.validateCardNumber($('.card-number').val())) {
		$(".payment-errors").text("Invalid card number");
		$(".submit-button").removeAttr("disabled");
		return false;
	}

	if (!paymill.validateExpiry($('.card-expiry-month').val(), $('.card-expiry-year').val())) {
		$(".payment-errors").text("Invalid expiration date");
		$(".submit-button").removeAttr("disabled");
		return false;
	}

    paymill.createToken({
      number: $('.card-number').val(),  // required, ohne Leerzeichen und Bindestriche
      exp_month: $('.card-expiry-month').val(),   // required
      exp_year: $('.card-expiry-year').val(),     // required, vierstellig z.B. "2016"
      cvc: $('.card-cvc').val(),                  // required
      amount_int: $('.card-amount-int').val(),    // required, integer, z.B. "15" für 0,15 Euro 
      currency: $('.card-currency').val(),    // required, ISO 4217 z.B. "EUR" od. "GBP"
      cardholder: $('.card-holdername').val() // optional
    }, PaymillResponseHandler);                   // Info dazu weiter unten

    return false;
  });
});
