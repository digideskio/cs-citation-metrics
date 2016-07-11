##############################################################################################################################
# Author     : Neyaz Ahmad
#
# Desciption : This Module Generate Random and Unique Token [universally unique identifier].
#
# Version    : v1.1
#
#############################################################################################################################

package UuidToken;

require Exporter;
our @ISA    = qw(Exporter);
our @EXPORT = qw(Generate_Token);

use UUID::Random;

sub Generate_Token {

  my $uuid_Token = UUID::Random::generate;

  return $uuid_Token;
}

1;
