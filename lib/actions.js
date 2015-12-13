


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

function draw_graph(json_input) {
  d3.json(json_input, function(data) {
  
    var max_x = 0;
    var max_y = 0;
    var min_x = 9999;
    var min_y = 9999;
  
    for (var i = 0; i < data.length; i++) {
      var tmp_x, tmp_y;
      var tmp_x = data[i].x;
      var tmp_y = data[i].y;
      if (tmp_x >= max_x) {max_x = tmp_x;}
      if (tmp_y >= max_y) {max_y = tmp_y;}
      if (tmp_x < min_x) {min_x = tmp_x;}
      if (tmp_y < min_y) {min_y = tmp_y;}
    }

    var svgContainer = d3.select("#output_view").append("svg")
                                        .attr("width",290)
                                        .attr("height",300);
    var xs_scale = d3.scale.linear()
                           .domain([min_x,max_x])
                           .range([0,200]);
  
    var ys_scale = d3.scale.linear()
                           .domain([min_y,max_y])
                           .range([200,0]);

    var line1 = d3.svg.line()
                      .x(function(d) {return xs_scale(d.x); })
                      .y(function(d) {return ys_scale(d.y); })
                      .interpolate("linear");

    var lineGraph = svgContainer.append("path")
                                .attr("d", line1(data))
                                .attr("stroke", "blue")
                                .attr("stroke-width",2)
                                .attr("transform", "translate(80,50)")
                                .attr("fill","none");

    var ax_x = d3.svg.axis()
                 .orient("bottom")
                 .scale(xs_scale);

    var ax_y = d3.svg.axis()
                 .orient("left")
                 .scale(ys_scale);

    svgContainer.append("g")
                .attr("class", "xaxis axis") //'axis' will be used for css formatting
                .attr("transform", "translate(80,250)")
                .call(ax_x);

    //rotate x-axis, text ONLY
    svgContainer.selectAll(".xaxis text")  
                .attr("transform", function(d) {
                  return "translate(-10,5)rotate(-45)";
                  }
                );

    svgContainer.append("g")
                .attr("class", "yaxis axis") //'axis' will be used for css formatting
                .attr("transform", "translate(80,50)")
                .call(ax_y);

    svgContainer.append("text")
                .attr("text-anchor", "middle")
                .attr("transform", "translate(180,290)")
                .text("Chunk #");

    svgContainer.append("text")
                .attr("text-anchor", "middle")
                .attr("transform", "translate(180,25)")
                .text("DRX Tuning/Polarity");

    svgContainer.append("text")
                .attr("text-anchor", "middle")
                .attr("transform", "translate(20,175)rotate(-90)")
                .text("ADC Magnitude");

  });
}

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

