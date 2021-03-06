#!/usr/bin/perl

#============================================================================================================
#Author: Neyaz Ahmad
#Version=1.0
#
#perl /etc/EXT/Citation_Metrics/web/CitationMetrics.cgi get -v -M GET /
#
#perl /etc/EXT/Citation_Metrics/web/CitationMetrics.cgi get -v -M POST /Historical?"Input_Type=XML&Key=IN4mJl11HTB3hvSdjTRGNS6gzychYyk9WvbSBCdfhkI&Input_File=/etc/EXT/Citation_Metrics/Input.105_2014_3530_Article.xml"
#
#curl -v -F Input_File=@/etc/EXT/Citation_Metrics/Input/test/66_2014_712_test.xml http://10.113.5.197:8080/CitationMetrics/CitationMetrics.cgi/Historical?"Input_Type=XML&Key=IN4mJl11HTB3hvSdjTRGNS6gzychYyk9WvbSBCdfhkI"
#
#perl /etc/EXT/Citation_Metrics/web/CitationMetrics.cgi get -v -M POST /Status?"Token=3780e99a-fc2c-54e5-2c31-417f945c1792"
#
#http://10.113.5.197:8080/CitationMetrics/CitationMetrics.cgi
#http://10.113.5.197:8080/CitationMetrics.cgi
#perl /etc/EXT/Citation_Metrics/web/CitationMetrics.cgi daemon -l http://10.113.5.197:3000
#daemon -r perl /etc/EXT/Citation_Metrics/web/CitationMetrics.cgi daemon -l http://10.113.5.197:3000
#============================================================================================================
#http://10.113.5.197:8080/CitationMetrics/<Historical or Live>?Input_Type=XML

BEGIN{
    $scriptLocation=$0;
    if($scriptLocation!~/[\/\\]/){
	use Cwd;
	my $pwd = getcwd;
	$pwd=~s/\//\//;
	$scriptLocation="$pwd"."\/"."$scriptLocation";
    }elsif($scriptLocation=~/^\.\/([^\/\\]+?)$/){
	use Cwd;
	my $pwd = getcwd;
	$pwd=~s/\//\//;
	$scriptLocation=~s/^\.\///;
	$scriptLocation="$pwd"."\/"."$scriptLocation";
    }
    $scriptLocation=~s/\/([^\/\\]+?)$//;
    my $moduleLocation=$scriptLocation;
    $moduleLocation=~s/(^.*\/|^)([^\/\\]+?)$/$1Modules/;
    unshift(@INC, "$moduleLocation");
}

my $configLocation=$scriptLocation;
$configLocation=~s/(^.*\/|^)([^\/\\]+?)$/$1Config\/app\.config/;

my $Uuid_Token="";

use Mojolicious::Lite;
use Data::Dumper;
use UuidToken;
plugin 'RenderFile';
use CMetricsWeb;

##Get app.config file and retrun $config Hash   [syntax: $$config{"web.Upload_Location"}]
use GetConfig;
my $config=&get_config($configLocation);

#_____________________________________________________________________________________________


##Client Test
get '/' => sub{
  shift->render(template => 'client1');
};


##post method validation
# any ['GET', 'PATCH', 'PUT', 'DELETE', 'COPY', 'HEAD'] => '/:Service_Type' => sub{
#     my $self=shift;
#     $self->render(json => {status => "error", data => {message => "wrong method"}});
# };


##Main Web Service
any '/:Service_Type' => sub{
    my $self=shift;

    my $method = $self->req->method;
    if ($method ne "POST"){
	$self->render(json => {status => "error", data => { message => "wrong method! POST method required"}});
	return undef;
    }
    
    #XmlPath
    my %params=(Service_Type =>'', Input_Type=>'', Input_File=>'', File_Name=>'', DOI=>'',Key=>'', Status=>'', Token=>'', XmlPath=>'null');
    
    foreach my $param (keys %params){
	$params{$param} = $self->param("$param") if(defined $self->param("$param"));
    }
    
    my $paramErrorMessage=&Validate_Params($self, \%params);
    
    if(@$paramErrorMessage){
	$self->render(json => {status => "error", data => { message => "$$paramErrorMessage[0]"}});
	return undef;
    }
    
    
    if($params{Service_Type}=~/^Historical|Live$/){
	
	$Uuid_Token=&Generate_Token;  #Generate UuidToken
	
	my $File_Name=&File_Upload($self, $config->{'web.Upload_Location'}, $Uuid_Token);
	
	&Save_Token($Uuid_Token, $File_Name, $params{XmlPath}); #save token in Citation_DB.RequestManager
	
	&Process_Queue($File_Name, $config->{'web.Upload_Location'}, $Uuid_Token);
	
	$self->render(json => {status => "success", data => { token => "$Uuid_Token",  message => "Job in queue"}});
	
    }elsif($params{Service_Type}=~/^Status$/){
	
	my  $TokenStatus=&Check_Status($params{Token});

	if($$TokenStatus{RowCount} ne 0){
	    if($$TokenStatus{Comments} eq "completed"){
		my $download_file="$config->{'web.Download_Location'}"."/"."$params{Token}"."\/"."$$TokenStatus{InputParameter}";
		$self->render_file('filepath' => "$download_file", 'filename' => "$$TokenStatus{InputParameter}");
		#$self->render(json => {status => "success", data => { token => "$params{Token}", file => "$$TokenStatus{InputParameter}",  message => "Download File"}});
		
	    }else{
		$self->render(json => {status => "success", data => { token => "$params{Token}", file => "$$TokenStatus{InputParameter}",  message => "$$TokenStatus{Comments}"}});
	    }
	}else{
	    $self->render(json => {status => "error", data => { token => "$params{Token}", message => "No Token found"}});
	}
	
    }
    
};
app->start;

#=============================================================================================================

