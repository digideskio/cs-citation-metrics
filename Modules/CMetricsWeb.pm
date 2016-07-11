##############################################################################################################################
# Author     : Neyaz Ahmad
#
# Desciption : This Module will contain the Subroutines to process the Web Services
#
# Version    : v1.1
#
#############################################################################################################################

package CMetricsWeb;
require Exporter;
our @ISA    = qw(Exporter);
our @EXPORT = qw(Save_Token Check_Status File_Upload Validate_Params Process_Queue);

use DBI;
use DBConnection;
use MQ;
use GetConfig;
my $config=&get_config();

sub Save_Token{
    my ($Uuid_Token, $File_Name, $XmlPath)=@_;

    use DateTime;
    my $currentTime=&GetDateTime;
    
    my $dbh = dbConnect();
    eval {
	my $stmt = qq(INSERT INTO Citation_DB.RequestManager (TokenID,Start_Time,SMStatusID,InputParameter,comments,XmlPath)
      VALUES ("$Uuid_Token", "$currentTime", "1", "$File_Name", "Job in queue", "$XmlPath"));
	my $rv = $dbh->do($stmt) or die $DBI::errstr;
    }; warn $@ if $@;
    
    $dbh->disconnect();
}

#===========================================================================

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

#===========================================================================
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
#===========================================================================

sub Validate_Params{
    my $self=shift;
    my $params=shift;
    my @errorMessage=();

    if($$params{Service_Type}=~/^Historical|Live$/){
	
	if($$params{Service_Type}=~/^Historical$/){
	    eval {$$params{File_Name} = $$params{Input_File}->filename;}; warn $@ if $@;
	    
	}
	
	# unless ($$params{Key}){
	#     push (@errorMessage, "No API Key found");
	# }

	# unless ($config->{'ApiKey.user1'} eq $$params{Key}){
	#     push (@errorMessage, "No Valid API Key");
	# }
	
	unless ($$params{Input_Type}){
	    push (@errorMessage, "No Input_Type define");
	}
	unless ($$params{Input_Type}=~/^(xml|doi)$/i){
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

#===========================================================================

sub Process_Queue{
   my ($File_Name, $In_Location, $Uuid_Token)=@_;

   my $File_Location="$In_Location"."\/"."$Uuid_Token"."\/"."$File_Name";
   
   my $msg = qq({"message":"Job in queue","token":"$Uuid_Token", "in_file_location":"$File_Location", "file_name":"$File_Name"});
   
   &Send_Message('task_queue', 'task_queue', $msg);   #queue, routing_key, msg

}





1;
