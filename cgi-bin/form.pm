#!/usr/bin/perl

use strict;
use warnings;
use CGI qw(:standard);

# Create CGI object
my $cgi = new CGI;
my $cgi_vars = $cgi->Vars();

#import JQuery
my $jquery ='http://24.124.100.208/lib/jquery.min.js';

#import latest version of d3
my $d3 = 'https://cdnjs.cloudflare.com/ajax/libs/d3/3.5.10/d3.js';

#my project's JavaScript src Path
my $java_src = 'http://24.124.100.208/lib/actions.js';

#my project's analysis Perl module scripts
use ANALYSIS::Lsl;

#################################
#
#
#
#################################

#Right now, we only use DRX data types, but this can expand
open my $handle1, '<', '../lib/data_types.txt';
chomp(my @data_types = <$handle1>);
close $handle1;

#Import the tool description text from a text file
open my $handle2, '<', '../lib/desc.txt';
my $desc = <$handle2>;
close $handle2;

sub log_error($) {
  my $error = shift;
  return ($error.$cgi->br());
}


sub find_error($) {
  my $cgi = shift;
  my $cgi_vars = $cgi->Vars();

  my $error = '';
  my $output = '';

  $cgi_vars->{'status_bg'} = '#888888';  

#--BEGIN RULES--#
#Don't allow 0 forms or text to generate output.
  if ($cgi->param('form_count') < 1) {
    $error .= log_error("Must allocate at least one form to generate!");
  }
#TEMPORARY Forbid more than 1 form
  if ($cgi->param('form_count') > 1) {
    $error .= log_error("Sorry, this demo only works with one form.");
  }
#TEMPORARY Override to allow multiple forms 
   
#--END RULES--#
  if ($error eq '') {
  # no errors, process data
    return undef;
  }
  else {
  # warn user, pass errors
    return $error;
  }
}


sub form_instance($;$) {
  my $output = shift;
  my $cgi = shift;
  my $cgi_vars = $cgi->Vars();  

  my $instance = $cgi->start_form(-action=>"data_munger.cgi",
                                     -method=>"post",
                                     -name=>"data_munger",
                                     -id=>"data_munger").
  $cgi->div({-name=>'main_form',
             -class=>'main_form',
             -style=>'position:relative;left:22%;width:800px;'},
    $cgi->table({-style=>'width:100%;'},
      $cgi->Tr($cgi->td({-name=>'data_type',
                         -id=>'data_type',
                         -style=>'background:#74feee;width:160px;'},
                         $cgi->input({-type=>'checkbox',
                                      -name=>'type_rms',
                                      -id=>'type_rms',
                                      -value=>"on",
                                      -onclick=>'toggle_option(\'type_rms\')'},
                                      'RMS vs Time'
                                    ),
                         $cgi->br(),
                         $cgi->input({-type=>'checkbox',
                                      -name=>'type_hist',
                                      -id=>'type_hist',
                                      -value=>"on",
                                      -onclick=>'toggle_option(\'type_hist\')'},
                                      'RMS Hist'
                                    ),
                       ),
               $cgi->td({-name=>'command',
                         -id=>'command',
                         -style=>'background:#ffee55;width:480px;'},
#Hackalicious. Need robust solution.
                         $cgi->center(
                         $cgi->input({-type=>'text',
                                      -id=>'chunk_size',
                                      -name=>'chunk_size',
                                      -value=>"$cgi_vars->{'chunk_size'}",
                                      -placeholder=>'Frames in a Chunk?'}
                                    ),
                         $cgi->input({-type=>'text',
                                      -id=>'chunk_count',
                                      -name=>'chunk_count',
                                      -value=>"$cgi_vars->{'chunk_count'}",
                                      -placeholder=>'Chunk Count?'}
                                    )
                         )
                       ),
               #jQuery animations lag with cells, using div
               $cgi->div({-class=>'status_container'},
                         $cgi->td({-name=>'status',
                                   -id=>'status',
                                   -class=>'status_container',
                                   -style=>'background:'.$cgi_vars->{'status_bg'}.';'},
                                 )
                        )
              ),
      $cgi->Tr($cgi->td({-name=>'output_control',
                        -id=>'output_control',
                        -colspan=>'3',
                        -style=>'background:#f911f2;width:800px;',
                        -onclick=>'view_output()'},
                        'Display output?'
                       )
              ),
      $cgi->Tr($cgi->td({-colspan=>'3'},
                         $cgi->div({-name=>'output_view',
                                    -id=>'output_view',
                                    -style=>'background:#ffffff;display:none;'},
                                    $cgi->center($cgi->img({-src=>'http://24.124.100.208/img/example.png'}),
                                                           $cgi->button({-id=>"graph_maker",
                                                                         -name=>"graph_maker",
                                                                         -onclick=>"draw_graph('http://24.124.100.208/img/example_t1p0.json');draw_graph('http://24.124.100.208/img/example_t1p1.json');draw_graph('http://24.124.100.208/img/example_t2p0.json');draw_graph('http://24.124.100.208/img/example_t2p1.json');",
                                                                         -value=>"Generate SVG from JSON, via JS"}
                                                             )
                                                )
                                  )
                       )
              ),
      $cgi->Tr($cgi->td({-name=>'log_control',
                         -id=>'log_control',
                         -colspan=>'3',
                         -style=>'background:#237ef9;width:800px;',
                         -onclick=>'view_log()'},
                         'Display log?'
                       )
              ),
      $cgi->Tr($cgi->td({-colspan=>'3'},
                         $cgi->div({-name=>'log_view',
                                    -id=>'log_view',
                                    -style=>'background:#efe311;display:none;'},
                                  $output 
                                  )
                       )
              )),
             $cgi->center(
             $cgi->input({-type=>'submit',
                          -id=>'submit_button',
                          -name=>'submit_button',
                          -style=>'font-size:200%;width:50%;position:inherit;left:50%',
                          -value=>'MUNGE!',
                          -onclick=>'process_indicator();'}
                        )
                        ));
return $instance;
 } 
sub html_gen ($;$;$) {

  my $cgi = shift;
  my $cgi_vars = $cgi->Vars();
  my $error = shift;
  my $output = shift;
  $cgi_vars->{'out_log'}= $output;
  #TEMPORARY must retain values after multiple forms work
  $cgi_vars->{'chunk_size'} = '';
  $cgi_vars->{'chunk_count'} = '';

#---BEGIN HEADER---#
  my $header = $cgi->start_html(-title=>'Data Munger',
                                -head=>[$cgi->Link({-rel=>'SHORTCUT ICON',
                                        -href=>'http://24.124.100.208/favicon.ico'}),],
                                -script=> [{-src=>$jquery},
                                           {-src=>$d3},
                                           {-src=>$java_src}]
                               );

#--BEGIN SIDEBAR--#
  my $sidebar = 
    $cgi->div({-style=>'background:#f0f0f0;position:fixed;left:0px;top:0px;bottom:0px;width:20%'},
              $cgi->img({-src=>'http://24.124.100.208/img/data_munger.png',
                         -style=>'position:relative;top:20px;',
                         -width=>'100%'}
                       ),
              $cgi->div({-align=>'center'},
                        $cgi->div({-name=>'description',
                                   -id=>'description',
                                   -style=>'position:relative;top:30px;width:80%;height:60px;overflow:hidden;font-size:85%;',
                                   -align=>'justify'},
                                   $desc,
                                   $cgi->div({-id=>'mask',
                                              -name=>'mask',
                                              -style=>'width:100%;height:100%;background:linear-gradient(to bottom,rgba(240,240,240,0),rgba(240,240,240,1));display:block;position:absolute;top:0px;'})
                                 )
                       ),
              $cgi->div({-style=>'position:relative;top:40px;',
                         -align=>'center',
                         -id=>'data_container'},'Choose data type:',
                        $cgi->popup_menu({-type=>'text',
                                          -name=>'data_selector',
                                          -id=>'data_selector',
                                          -values=>[@data_types],
                                          -onchange=>'',
                                          -style=>'position:relative;width:95%;'},
                                         'Choose data format:'
                                        ),
                       $cgi->br(),$cgi->br(),
                       $cgi->center($cgi->input({-type=>'text',
                                                 -id=>'form_count',
                                                 -name=>'form_count',
                                                 -style=>'width:80%;',
                                                 -value=>"$cgi_vars->{'form_count'}",
                                                 -placeholder=>'How many tasks?'}
                                    )
                                   ),
                       $cgi->br(),
                       $cgi->input({-type=>'submit',
                                    -id=>'submit_button',
                                    -name=>'submit_button',
                                    -value=>'Generate Forms'}
                                  )
                       ),
             ).
    $cgi->end_form();

#---BEGIN BODY---#


  #Generate forms first
  my $form_master = '';

  if ( $cgi->param('form_count') ) {
    for (my $i=0; $i < $cgi->param('form_count'); $i++) {
      $form_master .= $cgi->div(form_instance($output,$cgi)).$cgi->br().$cgi->br();
    }
  }

  my $body = 
    #Cheesey way to run fader if error exists in the form. Better solution?
    $cgi->body({-onload=>'clear_fields();fade_error(\''.$error.'\');'}). 
    $cgi->div({-name=>'error_view',
               -id=>'error_view',
               -style=>'display:block;z-index:99;background:rgba(255,255,255,0.9);color:#ff0000;font-weight:bold;font-size:200%;top:50px;position:fixed;left:22%;'},
               $error
             ).
             $cgi->start_form(-action=>"data_munger.cgi",
                              -method=>"post",
                              -name=>"data_munger",
                              -id=>"data_munger"
                             ).
             $form_master;

#---BEGIN FOOTER---#
  my $footer = $cgi->end_html();

return $header . $body . $sidebar . $footer
}

sub process_form($) {
  my $cgi = shift;
  #We already know there aren't errors. Give it null.
  my $error = '';
  my $output = ANALYSIS::Lsl::do_command($cgi);
  print html_gen($cgi,$error,$output);
  }
