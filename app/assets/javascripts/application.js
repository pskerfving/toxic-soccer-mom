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
	  $('#game_container').isotope({
	    itemSelector : '.game_box',
	    columnWidth : 220,		
	  });
	});

	$(function(){
		if($(".game_ongoing").length > 0) {
			setTimeout(updateGameBox, 7000);
		}

		if($("#game_container").length > 0) {
			setTimeout(updateComments, 15000);
		}

	});

	function updateGameBox() {
		var game_id = $(".game_ongoing").attr("id");
		var after = $(".game_ongoing").attr("data-time");
		$.getScript("/getgamebox.js?game_id=" + game_id + "&after=" + after);
		_gaq.push(['_trackPageview', '/getgamebox']);

		if($(".game_ongoing").length > 0) {
			setTimeout(updateGameBox, 7000);
		}

	};

	function updateComments() {
		var after = $("#game_container").attr("data-time");
		$.getScript("/getnewcomments.js?after=" + after);
		setTimeout(updateComments, 15000);
	}

	function connectHandlers() {
		$('.expand_list').hide();
		$('.show_expand_button').click(function() {
			if ($(this).text() == "Visa") {
				$(this).text('Göm');
				$('.expand_list', $(this).closest('.expand_content')).show();
			} else {
				$(this).text('Visa');
				$('.expand_list', $(this).closest('.expand_content')).hide();
			}
			$('#game_container').isotope('reLayout');
			return false;
		});
	};
	
	// Expanding the comments fields of the games view (and closing)
	$(document).ready(connectHandlers);

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
					_gaq.push(['_trackPageview', '/ajax_update_tip']);
				 }, 'json');
		});
	});
	
	$(document).ready(function (){
		$('.write_comment_button').click(function() {
			var game_id = $(this).closest('.game_box').attr('id');
			$.getScript("/getcommentform.js?game=" + game_id);
		});
	});

	$(document).ready(function() {
		$('#game_container').isotope('reLayout');	

		// Hide the notification if it is empty.
		$('div#notifications').find('p:empty').parent().hide();
	});
	
})(jQuery);
