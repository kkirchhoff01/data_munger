package ANALYSIS::Lsl;

use strict;
use warnings;
use CGI qw(:standard);
#################################
#
#
#
#################################

sub do_command ($) {
  my $cgi = shift;
  my $cgi_vars = $cgi->Vars();
  my $command = '';
  my $output = '';
#Is RMS vs Time checkbox selected?
  if ($cgi->param('type_rms')) {
    $command = 'rmsRunner.py';
  }
  #is RMS Histogram checkbox selected?
  if ($cgi->param('type_hist')) {
    $command = 'histRunner.py';
    }
#Only run command if checkboxes are selected
  if ($command ne '') {
    # for demo, it is sufficient to remove previous output before generating new
    $cgi_vars->{'status_bg'} = '#00ff00';
    system('convert -size 1x1 xc:white /var/www/html/img/example.png');
    $output = `python  /var/www/html/lib/$command /home/quincy/056952_000117775 /var/www/html/img/example $cgi_vars->{'chunk_size'} $cgi_vars->{'chunk_count'};`;
  }
  else {
    system('convert -size 1x1 xc:white /var/www/html/img/example.png');
    $output = "No action taken. Be sure to check the appropriate analysis box!"; 
  }
  return($output);

}
"Perl thinks this is true.";
