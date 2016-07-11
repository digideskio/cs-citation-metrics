#version 1.0.4
#Author: Neyaz Ahmad
package ReferenceManager::Elsevier;
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(ElsevierXML);                  #function name shoud modulename+XML
use ReferenceManager::sortTag2XML;

#shortTagtoXml
###################################################################################################################################################
sub ElsevierXML
    {
	my $TextBody=shift;
	my $XMLtype=shift;
	my $application=shift;

	my $SCRITPATH=$0;
	$SCRITPATH=~s/(.*)([\/\\])(.*?)\.(pl|exe)/$1/g;
	my $XMLTagIniLocation="${SCRITPATH}\/XMLTag\.ini";	#XMLTag.ini
	my $short2Xmltags=&LoadXMLTagIni($XMLTagIniLocation, $XMLtype);
	#<fpg>2898&#150;2909</fpg>

	$TextBody=~s/<fpg>([^<>]+?)\&\#150\;([^<>]+?)<\/fpg>/<pg><fpg>$1<\/fpg>\&\#150\;<lpg>$2<\/lpg><\/pg>/gs;
	$TextBody=~s/<fpg>([0-9a-zA-Z]+?)<\/fpg>/<pg><fpg>$1<\/fpg><\/pg>/gs;
	$TextBody=~s/<pg><pg><fpg>([0-9a-zA-Z]+?)<\/fpg><\/pg>/<pg><fpg>$1<\/fpg>/gs;

	my $elementsRegx='(aus|auf|aum|eds|edm|edf|au|aug|edr|edrg|iss|at|pt|cny|cty|pbl|pg|v|yr|url|ia|misc1|issn|isbn|coden|doi|edn|collab|bt|proc|suffix|par|rpt|thesis|pat|org|eml|pco|pbo|st|rol|tel|fax|number|petemp|comment)';

	while($TextBody=~/<bib([^<>]*?)>((?:(?!<\/bib>)(?!<bib[^<>]*?>).)*?)<\/bib>/s)
	  {

	    my $bibattribute="$1";
	    my $BibText="$2";
	    my $PlainBibText="$BibText";
	    $BibText=~s/<$elementsRegx><\/(i|b|u)><\/\1>/<\/$2>/gs;
	    $BibText=~s/<$elementsRegx><i>((?:(?!<i>)(?!<\/i>).)*)<\/\1>/<i><$1>$2<\/$1>/gs;
	    $BibText=~s/<\/$elementsRegx><\1>\&\#x([a-zA-Z0-9]+)\;<\/\1><\1>/\&\#x$2\;/gs;
	    $BibText=~s/<\/$elementsRegx><\1>\&\#x([a-zA-Z0-9]+)\;/\&\#x$2\;/gs;

	  }#While End

	$TextBody=~s/\&amp\;/\&\#x0026\;/gs;
	#------arrange tag sequence
	return $TextBody;
    }
#==============================================================================================================================

##########################################

return 1;