##############################################################################################################################
# Author     : Neyaz Ahmad
#
# Desciption : This Module return DateTime Hash Ref and SmartDateTime scalar [yyyy-mm-dd h:m:s].
#
# Version    : v1.1
#
#############################################################################################################################

package DateTime;

require Exporter;
our @ISA    = qw(Exporter);
our @EXPORT = qw(GetDateTime);

sub GetDateTime{
  my($sec,$min,$hr,$day,$month,$yr) = (localtime())[0..5];
  $month++;
  my $year = 1900 + $yr; 
  my $t = time;
  my $ms = sprintf "%03d", ($t-int($t))*1000; # without rounding
  my %DateTime=(dd=>$day, mm=>$month, yy=>$year, h=>$hr, m=>$min, s=>$sec, ms=>$ms);
  foreach my $Key (keys %DateTime){
    if($DateTime{$Key} < 10){
      $DateTime{$Key}="0"."$DateTime{$Key}";
    }
  }
  my $SmartDateTime="$DateTime{yy}-$DateTime{mm}-$DateTime{dd} $DateTime{h}:$DateTime{m}:$DateTime{s}:";
  return (\%DateTime, $SmartDateTime);
}

1;
