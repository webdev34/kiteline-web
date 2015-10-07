StackExchange.postValidation=function(){function e(e,t,n,i){var r=e.find('input[type="submit"]:visible'),a=r.length&&r.is(":enabled");a&&r.attr("disabled",!0),o(e,i),s(e,t,n,i),c(e),u(e),d(e);var f=function(){1!=t||e.find(C).length?(l(e,i),a&&r.attr("disabled",!1)):setTimeout(f,250)};f()}function t(t,i,o,s,l){e(t,i,s,o);var c,u=function(e){if(e.success)if(l)l(e);else{var n=window.location.href.split("#")[0],r=e.redirectTo.split("#")[0];0==r.indexOf("/")&&(r=window.location.protocol+"//"+window.location.hostname+r),c=!0,window.location=e.redirectTo,n.toLowerCase()==r.toLowerCase()&&window.location.reload(!0)}else e.captchaHtml?e.nocaptcha?StackExchange.nocaptcha.init(e.captchaHtml,u):StackExchange.captcha.init(e.captchaHtml,u):e.errors?(t.find("input[name=priorAttemptCount]").val(function(e,t){return(+t+1||0).toString()}),p(e.errors,t,i,o,e.warnings)):t.find('input[type="submit"]:visible').parent().showErrorMessage(e.message)};t.submit(function(){if(t.find("#answer-from-ask").is(":checked"))return!0;var e=t.find(E);if("[Edit removed during grace period]"==$.trim(e.val()))return g(e,["Comment reserved for system use. Please use an appropriate comment."],f()),!1;a(),StackExchange.navPrevention&&StackExchange.navPrevention.stop();var i=t.find('input[type="submit"]:visible');if(i.parent().addSpinner(),StackExchange.helpers.disableSubmitButton(t),StackExchange.options.site.enableNewTagCreationWarning){var s=t.find(C).parent().find("input#tagnames"),l=s.prop("defaultValue");if(s.val()!==l)return $.ajax({"type":"GET","url":"/posts/new-tags-warning","dataType":"json","data":{"tags":s.val()},"success":function(e){e.showWarning?i.loadPopup({"html":e.html,"dontShow":!0,"prepend":!0,"loaded":function(e){n(e,t,c,o,u)}}):r(t,o,c,u)}}),!1}return setTimeout(function(){r(t,o,c,u)},0),!1})}function n(e,t,n,a,o){e.bind("popupClose",function(){i(t,n)}),e.find(".submit-post").click(function(i){return StackExchange.helpers.closePopups(e),r(t,a,n,o),i.preventDefault(),!1}),e.show()}function i(e,t){StackExchange.helpers.removeSpinner(),t||StackExchange.helpers.enableSubmitButton(e)}function r(e,t,n,r){$.ajax({"type":"POST","dataType":"json","data":e.serialize(),"url":e.attr("action"),"success":r,"error":function(){var n;switch(t){case"question":n="An error occurred submitting the question.";break;case"answer":n="An error occurred submitting the answer.";break;case"edit":n="An error occurred submitting the edit.";break;case"tags":n="An error occurred submitting the tags.";break;case"post":default:n="An error occurred submitting the post."}e.find('input[type="submit"]:visible').parent().showErrorMessage(n)},"complete":function(){i(e,n)}})}function a(){for(var e=0;e<M.length;e++)clearTimeout(M[e]);M=[]}function o(e,t){var n=e.find(k);n.length&&n.blur(function(){M.push(setTimeout(function(){var i=n.val(),r=$.trim(i);if(0==r.length)return w(e,n),void 0;var a=n.data("min-length");if(a&&r.length<a)return g(n,[function(e){return 1==e.minLength?"Title must be at least "+e.minLength+" character.":"Title must be at least "+e.minLength+" characters."}({"minLength":a})],f()),void 0;var o=n.data("max-length");return o&&r.length>o?(g(n,[function(e){return 1==e.maxLength?"Title cannot be longer than "+e.maxLength+" character.":"Title cannot be longer than "+e.maxLength+" characters."}({"maxLength":o})],f()),void 0):($.ajax({"type":"POST","url":"/posts/validate-title","data":{"title":i},"success":function(i){i.success?w(e,n):g(n,i.errors.Title,f()),"edit"!=t&&m(e,n,i.warnings.Title)},"error":function(){w(e,n)}}),void 0)},_))})}function s(e,t,n,i){var r=e.find(S);r.length&&r.blur(function(){M.push(setTimeout(function(){var a=r.val(),o=$.trim(a);if(0==o.length)return w(e,r),void 0;if(5==t){var s=r.data("min-length");return s&&o.length<s?g(r,[function(e){return"Wiki Body must be at least "+e.minLength+" characters. You entered "+e.actual+"."}({"minLength":s,"actual":o.length})],f()):w(e,r),void 0}(1==t||2==t)&&$.ajax({"type":"POST","url":"/posts/validate-body","data":{"body":a,"oldBody":r.prop("defaultValue"),"isQuestion":1==t,"isSuggestedEdit":n},"success":function(t){t.success?w(e,r):g(r,t.errors.Body,f()),"edit"!=i&&m(e,r,t.warnings.Body)},"error":function(){w(e,r)}})},_))})}function l(e,t){var n=e.find(C);if(n.length){var i=n.parent().find("input#tagnames");i.blur(function(){M.push(setTimeout(function(){var r=i.val(),a=$.trim(r);return 0==a.length?(w(e,n),void 0):($.ajax({"type":"POST","url":"/posts/validate-tags","data":{"tags":r,"oldTags":i.prop("defaultValue")},"success":function(i){if(i.success?w(e,n):g(n,i.errors.Tags,f()),"edit"!=t&&(m(e,n,i.warnings.Tags),i.source&&i.source.Tags&&i.source.Tags.length)){var r=$("#post-form input[name='warntags']");r&&StackExchange.using("gps",function(){var e=r.val()||"";$.each(i.source.Tags,function(t,n){n&&!r.data("tag-"+n)&&(r.data("tag-"+n,n),e=e.length?e+" "+n:n,StackExchange.gps.track("tag_warning.show",{"tag":n},!0))}),r.val(e),StackExchange.gps.sendPending()})}},"error":function(){w(e,n)}}),void 0)},_))})}}function c(e){var t=e.find(E);t.length&&t.blur(function(){M.push(setTimeout(function(){var n=t.val(),i=$.trim(n);if(0==i.length)return w(e,t),void 0;var r=t.data("min-length");if(r&&i.length<r)return g(t,[function(e){return 1==e.minLength?"Your edit summary must be at least "+e.minLength+" character.":"Your edit summary must be at least "+e.minLength+" characters."}({"minLength":r})],f()),void 0;var a=t.data("max-length");return a&&i.length>a?(g(t,[function(e){return 1==e.maxLength?"Your edit summary cannot be longer than "+e.maxLength+" character.":"Your edit summary cannot be longer than "+e.maxLength+" characters."}({"maxLength":a})],f()),void 0):(w(e,t),void 0)},_))})}function u(e){var t=e.find(T);t.length&&t.blur(function(){M.push(setTimeout(function(){var n=t.val(),i=$.trim(n);if(0==i.length)return w(e,t),void 0;var r=t.data("min-length");if(r&&i.length<r)return g(t,[function(e){return"Wiki Excerpt must be at least "+e.minLength+" characters; you entered "+e.actual+"."}({"minLength":r,"actual":i.length})],f()),void 0;var a=t.data("max-length");return a&&i.length>a?(g(t,[function(e){return"Wiki Excerpt cannot be longer than "+e.maxLength+" characters; you entered "+e.actual+"."}({"maxLength":a,"actual":i.length})],f()),void 0):(w(e,t),void 0)},_))})}function d(e){var t=e.find(I);t.length&&t.blur(function(){M.push(setTimeout(function(){var n=t.val(),i=$.trim(n);return 0==i.length?(w(e,t),void 0):/^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,20}$/i.test(n)?(w(e,t),void 0):(g(t,["This email does not appear to be valid."],h()),void 0)},_))})}function f(){var e=$("#sidebar, .sidebar").first().width()||270;return{"position":{"my":"left top","at":"right center"},"css":{"max-width":e,"min-width":e},"closeOthers":!1}}function h(){var e=$("#sidebar, .sidebar").first().width()||270;return{"position":{"my":"left top","at":"right center"},"css":{"min-width":e},"closeOthers":!1}}function p(e,t,n,i,r){if(e){var a=function(){var n=0,a=t.find(C),o=t.find(k),s=t.find(S);g(o,e.Title,f())?n++:w(t,o),r&&m(t,o,r.Title),g(s,e.Body,f())?n++:w(t,s),r&&m(t,s,r.Body),g(a,e.Tags,f())?n++:w(t,a),r&&m(t,a,r.Tags),g(t.find(E),e.EditComment,f())?n++:w(t,t.find(E)),g(t.find(T),e.Excerpt,f())?n++:w(t,t.find(T)),g(t.find(I),e.Email,h())?n++:w(t,t.find(I));var l=t.find(".general-error"),c=e.General&&e.General.length>0;if(c||n>0){if(!l.length){var u=t.find('input[type="submit"]:visible');u.before('<div class="general-error-container"><div class="general-error"></div><br class="cbt" /></div>'),l=t.find(".general-error")}if(c)g(l,e.General,{"position":"inline","css":{"float":"left","margin-bottom":"10px"},"closeOthers":!1,"dismissable":!1});else{w(t,l);var d;switch(i){case"question":d=function(e){return 1==e.specificErrorCount?"Your question couldn't be submitted. Please see the error above.":"Your question couldn't be submitted. Please see the errors above."}({"specificErrorCount":n});break;case"answer":d=function(e){return 1==e.specificErrorCount?"Your answer couldn't be submitted. Please see the error above.":"Your answer couldn't be submitted. Please see the errors above."}({"specificErrorCount":n});break;case"edit":d=function(e){return 1==e.specificErrorCount?"Your edit couldn't be submitted. Please see the error above.":"Your edit couldn't be submitted. Please see the errors above."}({"specificErrorCount":n});break;case"tags":d=function(e){return 1==e.specificErrorCount?"Your tags couldn't be submitted. Please see the error above.":"Your tags couldn't be submitted. Please see the errors above."}({"specificErrorCount":n});break;case"post":default:d=function(e){return 1==e.specificErrorCount?"Your post couldn't be submitted. Please see the error above.":"Your post couldn't be submitted. Please see the errors above."}({"specificErrorCount":n})}l.text(d)}}else t.find(".general-error-container").remove();var p;y()&&($("#sidebar").animate({"opacity":.4},500),p=setInterval(function(){y()||($("#sidebar").animate({"opacity":1},500),clearInterval(p))},500));var v;t.find(".validation-error").each(function(){var e=$(this).offset().top;(!v||v>e)&&(v=e)});var b=function(){for(var e=0;3>e;e++)t.find(".message").animate({"left":"+=5px"},100).animate({"left":"-=5px"},100)};if(v){var x=$(".review-bar").length;v=Math.max(0,v-(x?125:30)),$("html, body").animate({"scrollTop":v},b)}else b()},o=function(){1!=n||t.find(C).length?a():setTimeout(o,250)};o()}}function m(e,t,n){var i=f();if(i.type="warning",!n||0==n.length)return b(e,t),!1;var r=t.data("error-popup"),a=0;return r&&(a=r.height()+5),v(t,n,i,a)}function g(e,t,n){return n.type="error",v(e,t,n)}function v(e,t,n,i){var r,o=n.type;if(!(t&&0!=t.length&&e.length&&$("html").has(e).length))return!1;if(r=1==t.length?t[0]:"<ul><li>"+t.join("</li><li>")+"</li></ul>",r&&r.length>0){var s=e.data(o+"-popup");if(s&&s.is(":visible")){var l=e.data(o+"-message");if(l==r)return s.animateOffsetTop&&s.animateOffsetTop(i||0),!0;s.fadeOutAndRemove()}i>0&&(n.position.offsetTop=i);var c=StackExchange.helpers.showMessage(e,r,n);return c.find("a").attr("target","_blank"),c.click(a),e.addClass("validation-"+o).data(o+"-popup",c).data(o+"-message",r),!0}return!1}function b(e,t){x("warning",e,t)}function w(e,t){x("error",e,t)}function x(e,t,n){if(!n||0==n.length)return!1;var i=n.data(e+"-popup");return i&&i.is(":visible")&&i.fadeOutAndRemove(),n.removeClass("validation-"+e),n.removeData(e+"-popup"),n.removeData(e+"-message"),t.find(".validation-"+e).length||t.find(".general-"+e+"-container").remove(),!0}function y(){var e=!1,t=$("#sidebar, .sidebar").first();if(!t.length)return!1;var n=t.offset().left;return $(".message").each(function(){var t=$(this);return t.offset().left+t.outerWidth()>n?(e=!0,!1):void 0}),e}var k="input#title",S="textarea.wmd-input:first",C=".tag-editor",E="input[id^=edit-comment]",T="textarea#excerpt",I="input#m-address",M=[],_=250;return{"initOnBlur":e,"initOnBlurAndSubmit":t,"showErrorsAfterSubmission":p,"getSidebarPopupOptions":f}}();