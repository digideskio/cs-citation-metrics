##perl /etc/EXT/Citation_Metrics/rabbitmq/worker.pl
##daemon -r perl /etc/EXT/Citation_Metrics/rabbitmq/worker.pl
##ps -ef | grep worker.pl

BEGIN{
    $scriptLocation=$0;
    use Cwd;
    if($scriptLocation!~/[\/\\]/){
	my $pwd = getcwd;
	$pwd=~s/\//\//;
	$scriptLocation="$pwd"."\/"."$scriptLocation";
    }elsif($scriptLocation=~/^\.\/([^\/\\]+?)$/){
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

use DBConnection;
use GetConfig;
my $config=&get_config();

use strict;
use warnings;

$|++;
use Net::RabbitFoot;
use File::Copy;
use DBI;

my $conn = Net::RabbitFoot->new()->load_xml_spec()->connect(
    host => $config->{'RabbitMQ.host'},
    port => $config->{'RabbitMQ.port'},
    user => $config->{'RabbitMQ.user'},
    pass => $config->{'RabbitMQ.pass'},
    vhost => $config->{'RabbitMQ.vhost'},
);

my $ch = $conn->open_channel();

$ch->declare_queue(
    queue => 'task_queue',
    durable => 1,
);

print " [*] Waiting for messages. To exit press CTRL-C\n";

sub callback {
    my $var = shift;
    my $body = $var->{body}->{payload};

    print " [x] Received $body\n";
    #-----------------------------

    use JSON;
    my $body_message= decode_json $body;    #$body_message={message, token, file_name, in_file_location}
    my $IN_location=$config->{'web.Upload_Location'} . "\/" . $body_message->{token};
    my $OUT_location=$config->{'web.Download_Location'} . "\/" . $body_message->{token};

    my $Statistic_Location=$config->{'web.Overall_Statistics'} . "\/STAT.txt";

    my $run_Citation_Metrix_Script= "perl $config->{'Script.Citation_Metrix'} -f \"$body_message->{in_file_location}\" -l \"$IN_location\" -r \"$Statistic_Location\"";
    #my $run_Citation_Metrix_Script= "perl $config->{'Script.Citation_Metrix'} -f \"$body_message->{in_file_location}\" -l \"$IN_location\" -r \"/etc/EXT/Citation_Metrics/rabbitmq/STAT.txt\"";


    system($run_Citation_Metrix_Script);

    move($IN_location, $OUT_location);

    &Update_Stataus($body_message->{token}, $body_message->{file_name});

    #-------------------------------------------
    print " [x] Done\n";
    $ch->ack();
}

$ch->qos(prefetch_count => 1,);

$ch->consume(
    on_consume => \&callback,
    no_ack => 0,
);

# Wait forever
AnyEvent->condvar->recv;

#---------------------------------------------------------------
sub Update_Stataus{
    my $Uuid_Token=shift;
    my $File_Name=shift;

    use DateTime;
    our $currentTime=&GetDateTime;
    
    my $dbh = dbConnect();
    eval {
	my $stmt = qq(UPDATE Citation_DB.RequestManager SET End_Time= "$currentTime", Comments='completed' WHERE TokenID="$Uuid_Token");
	my $rv = $dbh->do($stmt) or die $DBI::errstr;
    }; warn $@ if $@;
    
    $dbh->disconnect();
}
