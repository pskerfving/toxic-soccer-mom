/**
 * Created by petterskerfving on 19/10/15.
 */
$(document).ready(function() {
    $('.all_btn a').click(function(evt) {
        evt.preventDefault();
        $('.all_btn').addClass("active");
        $('.upcoming_btn').removeClass("active");
        $('.game_container').isotope({filter: '*'});
    });

    $('.upcoming_btn a').click(function(evt) {
        evt.preventDefault();
        $('.all_btn').removeClass("active");
        $('.upcoming_btn').addClass("active");
        $('.game_container').isotope({filter: ':not(.game_final)'});
    });

    $('.write_comment_button').click(function(evt) {
        evt.preventDefault();
        var game_id = $(this).closest('.game_box').attr('id');
        $.getScript("/getcommentform.js?game=" + game_id);
    });

    $('.expand_list').hide();
    $('.show_expand_button').click(function() {
        if ($(this).text() == "Visa") {
            $(this).text('Göm');
            $('.expand_list', $(this).closest('.expand_content')).show();
        } else {
            $(this).text('Visa');
            $('.expand_list', $(this).closest('.expand_content')).hide();
        }
        $('.game_container').isotope('layout');
        return false;
    });

});

skel.on("ready", function() {
    // TODO: Find a correct solution to this terribel ugly hack.
    setTimeout(function() {
        console.log("RELAYOUT------------");
        $('.game_container').isotope('layout');
    }, 1000);
});
