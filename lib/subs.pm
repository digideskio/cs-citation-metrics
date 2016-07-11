#line 1 "subs.pm"
package subs;

our $VERSION = '1.00';

#line 28

require 5.000;

sub import {
    my $callpack = caller;
    my $pack = shift;
    my @imports = @_;
    foreach $sym (@imports) {
	*{"${callpack}::$sym"} = \&{"${callpack}::$sym"};
    }
};

1;
