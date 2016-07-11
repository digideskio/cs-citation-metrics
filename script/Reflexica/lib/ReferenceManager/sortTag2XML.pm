#version 1.0.4
#Author: Neyaz Ahmad
package ReferenceManager::sortTag2XML;
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(shortTagtoXml LoadXMLTagIni);


###################################################################################################################################################
sub shortTagtoXml{
  my $BibText=shift;
  my $short2Xmltags=shift;

  foreach my $shortTag (keys(%$short2Xmltags))
    {
      $BibText=~s/<$shortTag>/<$$short2Xmltags{$shortTag}>/gs;
      $BibText=~s/<\/$shortTag>/<\/$$short2Xmltags{$shortTag}>/gs;
    }
  return $BibText;
}
#===============================================================================================================================================
sub LoadXMLTagIni{
  my $XMLTagIniLocation=shift;
  my $XMLtype=shift;
  open(XMLTagin, "<$XMLTagIniLocation")||die("\n\n$XMLTagIniLocation File cannot be opened\n\nPlease check the file...\n\n");
  my  $XMLTagIni=<XMLTagin>;
  close(XMLTagin);
  #  my $XMLtype="SpringerAplusplus";  #e.g. Springer A++XML, NLM XML...
  my %short2Xmltags=();
  if ($XMLTagIni=~/Style\{$XMLtype\}=>\[\[(.*?)\]\]/s){
    my $FindStyles="$1";
    while($FindStyles=~/\'([A-Za-z0-9\-\:]+)\'([\s]*)\=\>([\s]*)\'([A-Za-z0-9]+)\'/s)
      {
	$FindStyles=~s/\'([A-Za-z0-9\-\:]+)\'([\s]*)\=\>([\s]*)\'([A-Za-z0-9]+)\'//os;
	$short2Xmltags{$4}=$1;
      }
  }
  return \%short2Xmltags;
}
#===============================================================================================================================================

##########################################

return 1;