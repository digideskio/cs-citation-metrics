#!/usr/bin/perl

#============================================================================================================
#Author: Neyaz Ahmad
#Version=1.0
#
#perl /etc/EXT/Citation_Metrics/web/cMetrix get -v -M GET /
#
#perl /etc/EXT/Citation_Metrics/web/cMetrix get -v -M POST /eProofing?"Input_Type=XML&Key=IN4mJl11HTB3hvSdjTRGNS6gzychYyk9WvbSBCdfhkI&Input_File=/etc/EXT/Citation_Metrics/Input.105_2014_3530_Article.xml"
#
#perl /etc/EXT/Citation_Metrics/web/cMetrix get -v -M POST /Status?"Token=3780e99a-fc2c-54e5-2c31-417f945c1792"
#
#perl c:/Apache/htdocs/CitationMetrix/cMetrix.pl cgi
#http://10.113.5.197:8080/cMetrix
#============================================================================================================

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

use DateTime;
our $currentTime=&GetDateTime;

my $configLocation=$scriptLocation;
$configLocation=~s/(^.*\/|^)([^\/\\]+?)$/$1Config\/app\.config/;


my $Uuid_Token="";

use Mojolicious::Lite;
use Data::Dumper;
use DBI;
use UuidToken;
use Net::RabbitFoot;
plugin 'RenderFile';


##Get app.config file and retrun $config Hash   [syntax: $$config{"web.Upload_Location"}]
use GetConfig;

my $config=&get_config($configLocation);

#_____________________________________________________________________________________________


##Client Test
get '/' => sub{
  shift->render(template => 'client');
};


##Main Web Service
post '/:Service_Type' => sub{
    my $self=shift;
    
    my %params=(Service_Type =>'', Input_Type=>'', Input_File=>'', File_Name=>'', DOI=>'',Key=>'', Status=>'', Token=>'');
    
    foreach my $param (keys %params){
	$params{$param} = $self->param("$param") if(defined $self->param("$param"));
    }
    
    
    my $paramErrorMessage=&Validate_Params($self, \%params);
    
    if(@$paramErrorMessage){
	$self->render(json => {status => "error", data => { message => "$$paramErrorMessage[0]"}});
	return undef;
    }
    
    
    if($params{Service_Type}=~/^eProofing|DDS$/){
	
	$Uuid_Token=&Generate_Token;  #Generate UuidToken
	
	my $File_Name=&File_Upload($self, $config->{'web.Upload_Location'}, $Uuid_Token);
	
	&Save_Token($Uuid_Token, $File_Name); #save token in Citation_DB.RequestManager
	
	&Process_Queue($Uuid_Token, $File_Name);

	$self->render(json => {status => "success", data => { token => "$Uuid_Token",  message => "Job in queue"}});
	
    }elsif($params{Service_Type}=~/^Status$/){
	
	my  $TokenStatus=&Check_Status($params{Token});

		# my $download_file='/etc/EXT/Citation_Metrics/Output/3e7d0436-cf34-1c2e-54ed-1715192fdc6f/105_2014_3530_Article.xml';
		# $self->render_file('filepath' => "$download_file", 'filename' => "$$TokenStatus{InputParameter}");

	if($$TokenStatus{RowCount} ne 0){
	    if($$TokenStatus{Comments} eq "completed"){
		#my $download_file="$config->{'web.Download_Location'}"."/"."$params{Token}"."\/"."$$TokenStatus{InputParameter}";
		my $download_file='/etc/EXT/Citation_Metrics/Output/3e7d0436-cf34-1c2e-54ed-1715192fdc6f/105_2014_3530_Article.xml';
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
sub File_Upload{
    my ($self, $upload_Location, $Uuid_Token)=@_;
    
    #Make Upload Dir
    $upload_Location="$upload_Location\/$Uuid_Token";
    eval{
	if(!-e "$upload_Location"){
	    mkdir $upload_Location;
	}
    }; warn $@ if $@;
    
    # Process uploaded file
    my $Input_File = $self->param('Input_File');
    
    my $File_Name="";
    eval {
	$File_Name = $Input_File->filename;
	my $upload = $self->req->upload('Input_File');
	$upload->move_to("$upload_Location/$File_Name");
	
    }; warn $@ if $@;
    
    return $File_Name;
}
#========================================================================================================
sub Save_Token{
    my $Uuid_Token=shift;
    my $File_Name=shift;
    
    my $dbh = dbConnect();
    eval {
	my $stmt = qq(INSERT INTO Citation_DB.RequestManager (TokenID,Start_Time,SMStatusID,InputParameter,comments)
      VALUES ("$Uuid_Token", "$currentTime", "1", "$File_Name", "Job in queue"));
	my $rv = $dbh->do($stmt) or die $DBI::errstr;
    }; warn $@ if $@;
    
    $dbh->disconnect();
}

#========================================================================================================

sub Check_Status{
    my $Token=shift;
    my %TokenStatus=();
    
    my $dbh = dbConnect();
    
    eval {
	my $sth = $dbh->prepare("SELECT * FROM Citation_DB.RequestManager where TokenId = \'\Q$Token\E\'");
	$sth->execute() or die $DBI::errstr;
	$TokenStatus{RowCount} = $sth->rows;
	
	if($TokenStatus{RowCount} ne 0){
	    while (my @row = $sth->fetchrow_array()) {
		#ID, TokenID, Start_Time, End_Time, SMStatusID, InputParameter, Comments
		foreach(@row){
		    $TokenStatus{"ID"}=$row[0];
		    $TokenStatus{"TokenID"}=$row[1];
		    $TokenStatus{"Start_Time"}=$row[2];
		    $TokenStatus{"End_Time"}=$row[3];
		    $TokenStatus{"SMStatusID"}=$row[4];
		    $TokenStatus{"InputParameter"}=$row[5];
		    $TokenStatus{"Comments"}=$row[6];
		}
	    }
	}
    }; warn $@ if $@;
    
    $dbh->disconnect();
    
    return \%TokenStatus;
}

#===============================================
sub Validate_Params{
    my $self=shift;
    my $params=shift;
    my @errorMessage=();

    if($$params{Service_Type}=~/^eProofing|DDS$/){
	
	if($$params{Service_Type}=~/^eProofing$/){
	    eval {$$params{File_Name} = $$params{Input_File}->filename;}; warn $@ if $@;
	    
	}
	
	unless ($$params{Key}){
	    push (@errorMessage, "No API Key found");
	}


	unless ($config->{'ApiKey.user1'} eq $$params{Key}){
	    push (@errorMessage, "No Valid API Key");
	}
	
	unless ($$params{Input_Type}){
	    push (@errorMessage, "No Input_Type define");
	}
	unless ($$params{Input_Type}=~/xml|doi/i){
	    push (@errorMessage, "Invalid Input_Type");
	}
	
	unless ($$params{Input_File}){
	    push (@errorMessage, "No Input_File define");
	}
	unless ($$params{File_Name}){
	    push (@errorMessage, "No Input_File found");
	}
	unless ($$params{File_Name}=~/\.(xml|XML)$/){
	    push (@errorMessage, "No xml file");
	}
	
	push (@errorMessage, "File is too big")  if $self->req->is_limit_exceeded;


    }elsif($$params{Service_Type}=~/^Status$/){
	unless ($$params{Token}){
	    push (@errorMessage, "No Token found");
	}
    }else{
	push (@errorMessage, "No Service_Type found");
    }
    
    return \@errorMessage;
}

#========================================================================================================
sub Process_Queue{
    my $Uuid_Token=shift;
    my $File_Name=shift;
 
    my $conn = Net::RabbitFoot->new()->load_xml_spec()->connect(
	host => $config->{'RabbitMQ.host'},
	port => $config->{'RabbitMQ.port'},
	user => $config->{'RabbitMQ.user'},
	pass => $config->{'RabbitMQ.pass'},
	vhost => $config->{'RabbitMQ.vhost'},
	);

    my $chan = $conn->open_channel();

    $chan->declare_queue(
	queue => 'task_queue',
	durable => 1,
	);
    
    my $msg = join(' ', $File_Name) || "No File";
    
    $chan->publish(
	exchange => '',
	routing_key => 'task_queue',
	body => $msg,
	);
    
    $conn->close();
}

#========================================================================================================
sub dbConnect {
     my $dsn          = "DBI".":"."$config->{'Database.dbtype'}".":"."$config->{'Database.dbname'}";
     my $db_user_name = "$config->{'Database.user_name'}";
     my $db_password  = "$config->{'Database.password'}";
     my $dbh = DBI->connect($dsn, $db_user_name, $db_password, { RaiseError => 1 })
                       or die ("cannot connect to DB: $DBI::errstr\n");
    return $dbh;
}

