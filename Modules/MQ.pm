##############################################################################################################################
# Author     : Neyaz Ahmad
#
# Desciption : This Module will contain the Subroutines to process the Rabbit MQ
#
# Version    : v1.1
#
#############################################################################################################################

package MQ;
require Exporter;
our @ISA    = qw(Exporter);
our @EXPORT = qw(Send_Message);

use Net::RabbitFoot;
use GetConfig;

my $config=&get_config();


sub Send_Message{
    my ($queue, $routing_key, $msg)=@_;

    my $conn = &MQConnect();
  
    my $chan = $conn->open_channel();
    
    $chan->declare_queue(
	queue => $queue,
	durable => 1,
	);
    
    $chan->publish(
	exchange => '',
	routing_key => $routing_key,
	body => $msg,
	);
    
    $conn->close();
    
}


sub MQConnect{
    my $conn = Net::RabbitFoot->new()->load_xml_spec()->connect(
	host => $config->{'RabbitMQ.host'},
	port => $config->{'RabbitMQ.port'},
	user => $config->{'RabbitMQ.user'},
	pass => $config->{'RabbitMQ.pass'},
	vhost => $config->{'RabbitMQ.vhost'},
	);

 return $conn;
}


1;
