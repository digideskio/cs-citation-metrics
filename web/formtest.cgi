#!/usr/bin/perl

#============================================================================================================
#Author: Neyaz Ahmad
#Version=1.0
#
#perl /etc/EXT/Citation_Metrics/web/formtest.cgi get -v -M PUT /
#
#perl /etc/EXT/Citation_Metrics/web/formtest.cgi get -v -M get /nothing?_method=PUT
#perl /etc/EXT/Citation_Metrics/web/formtest.cgi get -v -M post /test?headerText=xxxx
#

#http://10.113.5.197:8080/cMetrix/formtest.cgi

#morbo /etc/EXT/Citation_Metrics/web/formtest.cgi
#http://localhost:3000
#-l https://[::]:6000

#============================================================================================================

use Mojolicious::Lite;

get '/' => 'form';

# PUT  /nothing
# POST /nothing?_method=PUT

post '/test' => sub {
  my $self = shift;

 my %params=(test =>'', param1=>'', param2=>'', Body=>'');
 my $test="";

    foreach my $param (keys %params){
	$params{$param} = $self->param("$param") if(defined $self->param("$param"));
	$test=$test . " => $param :". $self->param("$param") if(defined $self->param("$param"));
    }
  my $host = $self->req->url->to_abs->host;
  my $ua   = $self->req->headers->user_agent;
  $test= "$test => Host: $host =>UA: $ua";
  my $Body=$self->req->body;

 # $self->render(json => {Header => $test});
    
 $self->render(data => $Body);

  };


put '/nothing' => sub {
  my $c = shift;

  # Prevent double form submission with redirect
  my $value = $c->param('whatever');
  $c->flash(confirmation => "We did nothing with your value ($value).");
  $c->redirect_to('form');
};

app->start;
__DATA__

@@ form.html.ep
<!DOCTYPE html>
<html>
  <body>
    % if (my $confirmation = flash 'confirmation') {
      <p><%= $confirmation %></p>
    % }
    %= form_for nothing => begin
      %= text_field whatever => ''
      %= submit_button
    % end
  </body>
</html>


@@ test.html.ep
<!DOCTYPE html>
<html>
  <body>
<p> VALUE = <%= $value %></p>
  </body>
</html>
