function drawLeaderBoardGraph(){$.getJSON("historic_results",function(t){var e=["rgb(166,206,227)","rgb(31,120,180)","rgb(178,223,138)","rgb(51,160,44)","rgb(251,154,153)","rgb(227,26,28)","rgb(253,191,111)","rgb(255,127,0)","rgb(202,178,214)","rgb(106,61,154)"],a=d3.select("#legend");a.selectAll("div").data(t).enter().append("div").attr("class","legend_line").attr("data-path-id",function(t,e){return e}).append("div").attr("class","legend_text").text(function(t){return t[0]}),a.selectAll(".legend_line").insert("div",".legend_text").attr("class","legend_color").attr("style",function(t,a){return"background-color:"+e[a]});var n=300,r=500,i=(r-12)/(t[0].length-1),o=[];t.forEach(function(t){t.slice(1).forEach(function(t,e){parseInt(t)>(o[e]||0)&&(o[e]=parseInt(t))})});var l=[],s=0;t.forEach(function(t,e){l[e]=[],t.slice(1).forEach(function(t,a){var n=parseInt(t)-o[a];l[e][a]=n,s>n&&(s=n)})});var c=d3.select("#leaderboard_graph_canvas").append("svg");c.attr("width",r).attr("height",n).attr("class","leaderboard_canvas");var d=d3.scale.linear().domain([0,s]).range([10,n-20]),u=d3.svg.line().x(function(t,e){return e*i}).y(function(t){return d(t)}).interpolate("linear"),m=d3.svg.axis();m.scale(d).orient("right"),c.append("g").attr("class","leaderboard_axis").attr("transform","translate("+(r-22)+", 0)").call(m.tickSize(-r,0,0)),l.forEach(function(t,a){c.append("path").attr("d",u(t)).attr("stroke",e[a]).attr("stroke-width",3).attr("fill","none").attr("data-path-id",a).attr("class","leaderboard_graph_path")}),$(".legend_line").hover(function(){var t=$(".leaderboard_graph_path[data-path-id='"+$(this).attr("data-path-id")+"']");t.appendTo(".leaderboard_canvas"),t.attr("stroke-width",7)},function(){$(".leaderboard_graph_path").attr("stroke-width",3)})})}function PaymillResponseHandler(t,e){if(t)$(".payment-errors").text(t.apierror);else{$(".payment-errors").text("");var a=$("#payment-form"),n=e.token;a.append("<input type='hidden' name='paymillToken' value='"+n+"'/>"),a.get(0).submit()}$(".submit-button").removeAttr("disabled")}$(document).ready(function(){$(".all_btn a").click(function(t){t.preventDefault(),$(".all_btn").addClass("active"),$(".upcoming_btn").removeClass("active"),$(".game_container").isotope({filter:"*"})}),$(".upcoming_btn a").click(function(t){t.preventDefault(),$(".all_btn").removeClass("active"),$(".upcoming_btn").addClass("active"),$(".game_container").isotope({filter:":not(.game_final)"})}),$(".upcoming_btn").hasClass("active")&&$(".game_container").isotope({filter:":not(.game_final)"}),$(".write_comment_button").click(function(t){t.preventDefault();var e=$(this).closest(".game_box").attr("id");$.getScript("/getcommentform.js?game="+e)}),$(".expand_list").hide(),$(".show_expand_button").click(function(){return"Visa"==$(this).text()?($(this).text("Göm"),$(".expand_list",$(this).closest(".expand_content")).show()):($(this).text("Visa"),$(".expand_list",$(this).closest(".expand_content")).hide()),$(".game_container").isotope("layout"),!1})}),$(window).load(function(){$(".game_container").isotope("layout")}),function(t){function e(){var a=t(".game_ongoing").attr("id"),n=t(".game_ongoing").attr("data-time");t.getScript("/getgamebox.js?game_id="+a+"&after="+n),t(".game_ongoing").length>0&&setTimeout(e,7e3)}function a(){var e=t(".game_container").attr("data-time");t.getScript("/getnewcomments.js?after="+e),setTimeout(a,15e3)}t(function(){t(".game_container").isotope({itemSelector:".game_box",columnWidth:220})}),t(function(){t(".game_ongoing").length>0&&setTimeout(e,7e3),t(".game_container").length>0&&setTimeout(a,15e3)}),t(document).ready(function(){t(".tip_panel_button").click(function(){var e=t(this).closest(".game_box").attr("id"),a="/games/"+e;a+=t(this).closest(".game_ongoing").length>0?"/ajax_update_score":"/ajax_update_tip";var n=t(this),r=t(this).closest(".game_box").find(".notification");r.text("Sparar..."),t.post(a,{adjust:t(this).attr("adjust"),team:t(this).attr("team")},function(t){n.closest(".game_result").find(".home_score").text(t.home_score),n.closest(".game_result").find(".away_score").text(t.away_score),r.text("Resultat sparat.")},"json")})}),t(document).ready(function(){t("div#notifications").find("p:empty").parent().hide()}),t(document).ready(function(){t(".banner-toggle").click(function(){t("#banner-collapse").toggleClass("collapsed")})})}(jQuery),function(t){skel.init({reset:"full",breakpoints:{global:{range:"*",href:"/assets/style.css",containers:1400,grid:{gutters:{vertical:"4em",horizontal:0}}},xlarge:{range:"-1680",href:"/assets/style-xlarge.css",containers:1200},large:{range:"-1280",href:"/assets/style-large.css",containers:960,grid:{gutters:{vertical:"2.5em"}},viewport:{scalable:!1}},medium:{range:"-980",href:"/assets/style-medium.css",containers:"90%",grid:{collapse:1}},small:{range:"-736",href:"/assets/style-small.css",containers:"90%",grid:{gutters:{vertical:"1.25em"}}},xsmall:{range:"-480",href:"/assets/style-xsmall.css",grid:{collapse:2}}},plugins:{layers:{config:{transform:!0},navPanel:{animation:"pushX",breakpoints:"medium",clickToHide:!0,height:"100%",hidden:!0,html:'<div data-action="moveElement" data-args="nav"></div>',orientation:"vertical",position:"top-left",side:"left",width:250},navButton:{breakpoints:"medium",height:"4em",html:'<span class="toggle" data-action="toggleLayer" data-args="navPanel"></span>',position:"top-left",side:"top",width:"6em"}}}}),t(function(){})}(jQuery),$(document).ready(function(){$("#leaderboard_graph_button").length&&drawLeaderBoardGraph()}),$(document).ready(function(){$("#payment-form").submit(function(){return $(".submit-button").attr("disabled","disabled"),paymill.validateCardNumber($(".card-number").val())?paymill.validateExpiry($(".card-expiry-month").val(),$(".card-expiry-year").val())?(paymill.createToken({number:$(".card-number").val(),exp_month:$(".card-expiry-month").val(),exp_year:$(".card-expiry-year").val(),cvc:$(".card-cvc").val(),amount_int:$(".card-amount-int").val(),currency:$(".card-currency").val(),cardholder:$(".card-holdername").val()},PaymillResponseHandler),!1):($(".payment-errors").text("Invalid expiration date"),$(".submit-button").removeAttr("disabled"),!1):($(".payment-errors").text("Invalid card number"),$(".submit-button").removeAttr("disabled"),!1)})}),$(document).ready(function(){$(".social a.more-info").click(function(t){t.preventDefault(),$(".social p.more-info").toggle("0.25s")})}),function(t,e){t.rails!==e&&t.error("jquery-ujs has already been loaded!");var a,n=t(document);t.rails=a={linkClickSelector:"a[data-confirm], a[data-method], a[data-remote], a[data-disable-with]",buttonClickSelector:"button[data-remote]",inputChangeSelector:"select[data-remote], input[data-remote], textarea[data-remote]",formSubmitSelector:"form",formInputClickSelector:"form input[type=submit], form input[type=image], form button[type=submit], form button:not([type])",disableSelector:"input[data-disable-with], button[data-disable-with], textarea[data-disable-with]",enableSelector:"input[data-disable-with]:disabled, button[data-disable-with]:disabled, textarea[data-disable-with]:disabled",requiredInputSelector:"input[name][required]:not([disabled]),textarea[name][required]:not([disabled])",fileInputSelector:"input[type=file]",linkDisableSelector:"a[data-disable-with]",CSRFProtection:function(e){var a=t('meta[name="csrf-token"]').attr("content");a&&e.setRequestHeader("X-CSRF-Token",a)},fire:function(e,a,n){var r=t.Event(a);return e.trigger(r,n),r.result!==!1},confirm:function(t){return confirm(t)},ajax:function(e){return t.ajax(e)},href:function(t){return t.attr("href")},handleRemote:function(n){var r,i,o,l,s,c,d,u;if(a.fire(n,"ajax:before")){if(l=n.data("cross-domain"),s=l===e?null:l,c=n.data("with-credentials")||null,d=n.data("type")||t.ajaxSettings&&t.ajaxSettings.dataType,n.is("form")){r=n.attr("method"),i=n.attr("action"),o=n.serializeArray();var m=n.data("ujs:submit-button");m&&(o.push(m),n.data("ujs:submit-button",null))}else n.is(a.inputChangeSelector)?(r=n.data("method"),i=n.data("url"),o=n.serialize(),n.data("params")&&(o=o+"&"+n.data("params"))):n.is(a.buttonClickSelector)?(r=n.data("method")||"get",i=n.data("url"),o=n.serialize(),n.data("params")&&(o=o+"&"+n.data("params"))):(r=n.data("method"),i=a.href(n),o=n.data("params")||null);u={type:r||"GET",data:o,dataType:d,beforeSend:function(t,r){return r.dataType===e&&t.setRequestHeader("accept","*/*;q=0.5, "+r.accepts.script),a.fire(n,"ajax:beforeSend",[t,r])},success:function(t,e,a){n.trigger("ajax:success",[t,e,a])},complete:function(t,e){n.trigger("ajax:complete",[t,e])},error:function(t,e,a){n.trigger("ajax:error",[t,e,a])},crossDomain:s},c&&(u.xhrFields={withCredentials:c}),i&&(u.url=i);var p=a.ajax(u);return n.trigger("ajax:send",p),p}return!1},handleMethod:function(n){var r=a.href(n),i=n.data("method"),o=n.attr("target"),l=t("meta[name=csrf-token]").attr("content"),s=t("meta[name=csrf-param]").attr("content"),c=t('<form method="post" action="'+r+'"></form>'),d='<input name="_method" value="'+i+'" type="hidden" />';s!==e&&l!==e&&(d+='<input name="'+s+'" value="'+l+'" type="hidden" />'),o&&c.attr("target",o),c.hide().append(d).appendTo("body"),c.submit()},disableFormElements:function(e){e.find(a.disableSelector).each(function(){var e=t(this),a=e.is("button")?"html":"val";e.data("ujs:enable-with",e[a]()),e[a](e.data("disable-with")),e.prop("disabled",!0)})},enableFormElements:function(e){e.find(a.enableSelector).each(function(){var e=t(this),a=e.is("button")?"html":"val";e.data("ujs:enable-with")&&e[a](e.data("ujs:enable-with")),e.prop("disabled",!1)})},allowAction:function(t){var e,n=t.data("confirm"),r=!1;return n?(a.fire(t,"confirm")&&(r=a.confirm(n),e=a.fire(t,"confirm:complete",[r])),r&&e):!0},blankInputs:function(e,a,n){var r,i,o=t(),l=a||"input,textarea",s=e.find(l);return s.each(function(){if(r=t(this),i=r.is("input[type=checkbox],input[type=radio]")?r.is(":checked"):r.val(),!i==!n){if(r.is("input[type=radio]")&&s.filter('input[type=radio]:checked[name="'+r.attr("name")+'"]').length)return!0;o=o.add(r)}}),o.length?o:!1},nonBlankInputs:function(t,e){return a.blankInputs(t,e,!0)},stopEverything:function(e){return t(e.target).trigger("ujs:everythingStopped"),e.stopImmediatePropagation(),!1},disableElement:function(t){t.data("ujs:enable-with",t.html()),t.html(t.data("disable-with")),t.bind("click.railsDisable",function(t){return a.stopEverything(t)})},enableElement:function(t){t.data("ujs:enable-with")!==e&&(t.html(t.data("ujs:enable-with")),t.removeData("ujs:enable-with")),t.unbind("click.railsDisable")}},a.fire(n,"rails:attachBindings")&&(t.ajaxPrefilter(function(t,e,n){t.crossDomain||a.CSRFProtection(n)}),n.delegate(a.linkDisableSelector,"ajax:complete",function(){a.enableElement(t(this))}),n.delegate(a.linkClickSelector,"click.rails",function(n){var r=t(this),i=r.data("method"),o=r.data("params");if(!a.allowAction(r))return a.stopEverything(n);if(r.is(a.linkDisableSelector)&&a.disableElement(r),r.data("remote")!==e){if(!(!n.metaKey&&!n.ctrlKey||i&&"GET"!==i||o))return!0;var l=a.handleRemote(r);return l===!1?a.enableElement(r):l.error(function(){a.enableElement(r)}),!1}return r.data("method")?(a.handleMethod(r),!1):void 0}),n.delegate(a.buttonClickSelector,"click.rails",function(e){var n=t(this);return a.allowAction(n)?(a.handleRemote(n),!1):a.stopEverything(e)}),n.delegate(a.inputChangeSelector,"change.rails",function(e){var n=t(this);return a.allowAction(n)?(a.handleRemote(n),!1):a.stopEverything(e)}),n.delegate(a.formSubmitSelector,"submit.rails",function(n){var r=t(this),i=r.data("remote")!==e,o=a.blankInputs(r,a.requiredInputSelector),l=a.nonBlankInputs(r,a.fileInputSelector);if(!a.allowAction(r))return a.stopEverything(n);if(o&&r.attr("novalidate")==e&&a.fire(r,"ajax:aborted:required",[o]))return a.stopEverything(n);if(i){if(l){setTimeout(function(){a.disableFormElements(r)},13);var s=a.fire(r,"ajax:aborted:file",[l]);return s||setTimeout(function(){a.enableFormElements(r)},13),s}return a.handleRemote(r),!1}setTimeout(function(){a.disableFormElements(r)},13)}),n.delegate(a.formInputClickSelector,"click.rails",function(e){var n=t(this);if(!a.allowAction(n))return a.stopEverything(e);var r=n.attr("name"),i=r?{name:r,value:n.val()}:null;n.closest("form").data("ujs:submit-button",i)}),n.delegate(a.formSubmitSelector,"ajax:beforeSend.rails",function(e){this==e.target&&a.disableFormElements(t(this))}),n.delegate(a.formSubmitSelector,"ajax:complete.rails",function(e){this==e.target&&a.enableFormElements(t(this))}),t(function(){var e=t("meta[name=csrf-token]").attr("content"),a=t("meta[name=csrf-param]").attr("content");t('form input[name="'+a+'"]').val(e)}))}(jQuery);