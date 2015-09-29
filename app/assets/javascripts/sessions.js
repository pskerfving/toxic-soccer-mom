$(document).ready(function() {
    $('.social a.more-info').click(function(evt) {
        evt.preventDefault();
        $('.social p.more-info').toggle('0.25s');
    });
});