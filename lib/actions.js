


var desc_view=false;

jQuery(function ($) {
         //Callback function to display text
         $("#mask").hover(function(){
           $("#data_container").fadeOut('slow',
             function () {
                          $("#mask").css('background','linear-gradient(to bottom,rgba(240,240,240,0),rgba(240,240,240,0))');
                          $("#mask").css('height','100px');
                          $("#description").css('overflow','');
                         }
            )
         },function(){
           $("#description").css('overflow','hidden');
           $("#data_container").show();
           $("#mask").css('height','60px');
           $("#mask").css('background','linear-gradient(to bottom,rgba(240,240,240,0),rgba(240,240,240,1))');
         });
});

var output_view=false;
var log_view=false;

function view_output() { 
  if(output_view==false){
    $("#output_view").slideDown();
    output_view=true;
  }
  else {
    $("#output_view").slideUp();
    output_view=false;
  }
}

function view_log() { 
  if(log_view==false){
    $("#log_view").slideDown();
    log_view=true;
  }
  else {
    $("#log_view").slideUp();
    log_view=false;
  }
}

function fade_error(error) {
  if (error != '') {
    $(".main_form").fadeOut(1500, function() {
      $("#error_view").fadeOut(1500);
      $(".main_form").fadeIn(1500);
    });
  }
}


function toggle_option(type) {
  if ( (type=='type_hist') ){
    document.getElementById('type_rms').checked = false;
  }
  if ( (type=='type_rms') ) {
    document.getElementById('type_hist').checked = false;
  }
}

function clear_fields() {
  document.getElementById('chunk_size').value = "";
  document.getElementById('chunk_count').value = "";
}


var process_indicator = function () {
  $("#status").fadeOut(function() {
                      $("#status").css('background','#00ff00');
                      $("#status").fadeIn(function () {
                                         $("#status").fadeOut(function () {
                                                             $("#status").css('background','#888888').fadeIn().fadeIn(process_indicator());
                                                             });
                                         });
                      });
}

