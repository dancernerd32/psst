// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require foundation
//= require_tree .

$(function(){ $(document).foundation(); });
$(function(){
  console.log("loaded...");
});

var area = document.getElementById("message_text");
var message = document.getElementById("characters");
var minLength = 100;
var checkLength = function() {
  if(area.value.length < minLength) {
    characters.innerHTML = (minLength-area.value.length) + " more characters needed";
  }
  else {
    characters.innerHTML = "0 more characters needed. Feel free to keep adding to your message.";
  }
}
setInterval(checkLength, 300);
