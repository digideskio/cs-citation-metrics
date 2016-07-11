##############################################################################################################################
# Author     : Rahul Wagh
#
# Desciption : This Module will contain the Subroutine to return the application configuration from the configuration file at path Config/app.config 
#
# Version    :  v 1.1
#
#############################################################################################################################


#!/usr/bin/perl 

package DBConnection;

use DBI;
use GetConfig;
use Data::Dumper;

BEGIN{
	require Exporter;
	@ISA    = qw(Exporter);
	@EXPORT = qw(dbConnect);
}

my $CONFIG = get_config();

sub dbConnect {
	my $dsn          = "DBI".":"."$CONFIG->{'Database.dbtype'}".":"."$CONFIG->{'Database.dbname'}";
	my $db_user_name = "$CONFIG->{'Database.user_name'}";
	my $db_password  = "$CONFIG->{'Database.password'}";

#print Dumper $CONFIG;

#print "\n Dsn is = $dsn \n";

	$dbh = DBI->connect
 	($dsn, $db_user_name, $db_password, {RaiseError => 1}) || die("cannot connect to DB: ".DBI::errstr."\n",$dbh);

return $dbh;
}

1;
