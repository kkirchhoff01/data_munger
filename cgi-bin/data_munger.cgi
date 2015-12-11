#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard);
use form;
# Create CGI object
my $cgi = new CGI;
my $cgi_vars = $cgi->Vars();
#################################
#
#
#
#################################


my $error;
print $cgi->header();
#Process form if values present..
if ($cgi->param('form_count') ne '') {
  #Find errors
  $error = find_error($cgi);
  #no errors on the page. display it...
  if (!$error) {
    process_form($cgi);
  }
  #...there were errors. redisplay page with errors
  else {
    print html_gen($cgi , $error);
  }
}
#...otherwise just Display the form
else {
  print html_gen($cgi);
}
