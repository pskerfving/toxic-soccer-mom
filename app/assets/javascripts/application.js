// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//= require jquery.isotope.min
//= require jquery.scrolling-parallax

(function($) {
	
	$(function(){
//	  $.scrollingParallax('asphalt.jpg');
	  $('#main_content').isotope({
	    itemSelector : '.game_box',
	    columnWidth : 220,		
	  });
	});

	// Expanding the comments fields of the games view (and closing)
	$(document).ready(function() {
		$('.game_comment_list').hide();
		$('.show_game_comments_button').click(function() {
			if ($(this).text() == "Visa") {
				$(this).text('Göm');
				$('.game_comment_list', $(this).closest('.game_comments')).show();				
			} else {
				$(this).text('Visa');
				$('.game_comment_list', $(this).closest('.game_comments')).hide();								
			}
			$('#main_content').isotope('reLayout');
			return false;
		});
	});

	// Placing tips through AJAX (and if your an admin, changing the current result of the game.)
	$(document).ready(function() {
		$('.tip_panel_button').click(function() {
			var game_id = $(this).closest('.game_box').attr('id');
			var url = "/games/" + game_id;
			if ($(this).closest('.game_ongoing').length > 0) {
				url = url + "/ajax_update_score";
			} else {
				url = url + "/ajax_update_tip";
			}
			var button = $(this);
			var notification = $(this).closest('.game_box').find('.notification');
			notification.text("Sparar...")
			$.post(url, { adjust: $(this).attr('adjust'), team: $(this).attr('team') },
				function(data) { 
					button.closest('.game_result').find('.home_score').text(data.home_score);
					button.closest('.game_result').find('.away_score').text(data.away_score);
					notification.text("Resultat sparat.");
				 }, 'json');
		});
	});

	$(document).ready(function() {
		$('#main_content').isotope('reLayout');	
		
		// Hide the notification if it is empty.
		$('div#notifications').find('p:empty').parent().hide();
	});
	
})(jQuery);
