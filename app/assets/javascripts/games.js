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
});