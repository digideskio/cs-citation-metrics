#perl /etc/EXT/Citation_Metrics/rabbitmq/reftest.pl

use strict;
use warnings;

$|++;
use Net::RabbitFoot;

my $conn = Net::RabbitFoot->new()->load_xml_spec()->connect(
    host => '10.113.5.197',
    port => 5672,
    user => 'cmetrix',
    pass => 'crest123',
    vhost => '/',
);


my $chan = $conn->open_channel();

$chan->publish(
    exchange => '',
    routing_key => 'Reflexica',
    body => 'Hello World!',
);

 print " [x] Sent 'Hello World!'\n";

 $conn->close();

