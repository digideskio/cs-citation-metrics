#line 1 "JSON/XS.pm"

#line 101

package JSON::XS;

use common::sense;

our $VERSION = 3.01;
our @ISA = qw(Exporter);

our @EXPORT = qw(encode_json decode_json);

use Exporter;
use XSLoader;

use Types::Serialiser ();

#line 1604

BEGIN {
   *true    = \$Types::Serialiser::true;
   *true    = \&Types::Serialiser::true;
   *false   = \$Types::Serialiser::false;
   *false   = \&Types::Serialiser::false;
   *is_bool = \&Types::Serialiser::is_bool;

   *JSON::XS::Boolean:: = *Types::Serialiser::Boolean::;
}

XSLoader::load "JSON::XS", $VERSION;

#line 1627

1

