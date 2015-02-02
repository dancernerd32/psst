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

var messageArea = document.getElementById("message_text");
var message = document.getElementById("characters");
var minLength = 100;
var checkLength = function() {
  if(messageArea.value.length < minLength) {
    message.innerHTML = (minLength-messageArea.value.length) + " more characters needed";
  }
  else {
    message.innerHTML = "0 more characters needed. Feel free to keep adding to your message.";
  }
}
setInterval(checkLength, 10);

document.getElementById('message_text').onkeypress=function(e){
  if(("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ").indexOf(String.fromCharCode(e.keyCode))===-1){
    e.preventDefault();
    return false;
  }
}
