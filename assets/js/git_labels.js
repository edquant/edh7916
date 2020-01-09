---
---

var urlToGetLabels = "https://api.github.com/repos/edquant/edh7916/labels";

function returnColor(val) {
    
}

$("#gitlabels").append("<ul id='gl_newlist'></ul>");
$(document).ready(function () {
    $.getJSON(urlToGetLabels, function (allLabels) {
        $.each(allLabels, function (i, label) {
	    var textcolor = (label.name == "Bug" || label.name == "Suggestion") ? "white" : "black";
            $("#gl_newlist")
	       .append("<li><span class=\"IssueLabel--big d-inline-block v-align-top lh-condensed js-label-link gitlabel\"" +
		       " style=\"background-color: #" +
		       label.color +
		       "; color: " +
		       textcolor +
		       ";\">" +
		       label.name +
		       "</span></li>");
        });
    });
});
