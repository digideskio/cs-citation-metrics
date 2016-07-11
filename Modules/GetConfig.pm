 
############################################################################################################################################################
# Author     : Rahul Wagh
#
# Desciption : This Module will contain the Subroutine to return the application configuration from the configuration file at path Config/app.config 
#
# Version    :  v 1.1
#
############################################################################################################################################################

package GetConfig;


BEGIN{
	$VERSION   = '1.1';
	require Exporter;
	@ISA       = qw(Exporter);
	@EXPORT    = qw(get_config);
}


 
use strict;
use warnings;
use Data::Dumper;
use Config::Simple;
use Cwd qw/ realpath /;


my $PATH = realpath($0);

$PATH =~ s/(.*?)Citation_Metrics.*/$1Citation_Metrics/;


sub get_config{

	my $file=shift;
	my %config= ();
	
	if (!defined $file) {
		$file = "$PATH/Config/app.config";
	}
  	
	my $cfg = new Config::Simple();
	$cfg    = new Config::Simple(syntax=>'ini');
	$cfg->read("$file");
	%config = $cfg->vars();

	return \%config;
}

1;

