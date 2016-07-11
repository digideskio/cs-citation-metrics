#version 1.0.4
#Author: Neyaz Ahmad
package ReferenceManager::xmlConv;
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(XmlTaging);
my $useXMLmodule="use ReferenceManager::SpringerAplusplus";
eval { $useXMLmodule };                                    	#use ReferenceManager::SpringerAplusplus;

###################################################################################################################################################
sub XmlTaging
    {
	my $SourceText =shift;
	my $inputfname=shift;
	my $ext=shift;
	my $XMLtype=shift;
	my $application=shift;
	my $XMLtypefn="$XMLtype"."XML";
	######################### EXIT for now all application except Bookmetrix
	if($application ne "Bookmetrix"){
	  exit;
	}


	if ($XMLtype eq "A++"){
	  $XMLtype = "SpringerAplusplus"; 
	}
	use ReferenceManager::SpringerAplusplus;
	#use ReferenceManager::Elsevier;
	my $XMLtypefn="$XMLtype"."XML";
	eval "require ReferenceManager::$XMLtype";
	eval "use ReferenceManager::$XMLtype";
	use ReferenceManager::utfEntitiesConv;
	$SourceText=~s/\&amp\;\#x/\&\#x/gs;
	$SourceText=&HtmlEntitytoTag($SourceText);

	$SourceText=&{\&{$XMLtypefn}}($SourceText, $XMLtype, $application);     	#$SourceText=&SpringerAplusplusXML($SourceText, $XMLtype, $application);

	$SourceText=&ReferenceManager::utfEntitiesConv::unicodeEntitiesConv($SourceText, "NormalText", "HexaEntity");#unicode to Hexa Entities
	$SourceText=&ReferenceManager::utfEntitiesConv::unicodeEntitiesConv($SourceText, "DecEntity", "HexaEntity");#Decimal to Hexa Entities

	$SourceText=~s/\&amp\;nbsp\;/\&\#x00A0\;/gs;
	$SourceText=~s/\&amp\;hellip\;/\&\#x2026\;/gs;
	$SourceText=~s/\&hellip\;/\&\#x2026\;/gs;
	$SourceText=~s/\&\#x0026\;nbsp\;/\&\#x00A0\;/gs;
	$SourceText=~s/\&\#146\;/\&\#x2019\;/gs;
	$SourceText=~s/ \& / \&\#x0026\; /gs;

	$SourceText=~s/\&lt\;\!\-\-(.*?)\-\-\&gt\;/<\!--$1-->/gs;

	##my $XMLHeader="<\?xml version=\"1\.0\" encoding=\"UTF\-8\" standalone=\"no\"\?>\n<ChapterBackmatter>\n<Bibliography ID=\"Bib1\">\n";
	##my $XMLFooter="\n<\/Bibliography>\n<\/ChapterBackmatter>";
	open(OUTXMLFILE,">${inputfname}.$ext")|| die("${inputfname}.$ext File cannot be Wright\n");
	##print OUTXMLFILE $XMLHeader;
	print OUTXMLFILE "$SourceText";
	##print OUTXMLFILE $XMLFooter;
	close(OUTXMLFILE);

	system("cls");
	print "\n################################################################################\n\n";
	print "Reference Conversion Done...\n\n";
	print "################################################################################\n\n";

    }

#================================================================================================================================================
sub HtmlEntitytoTag
{
    my $SourceText=shift;

    my $TextBody="";
    $SourceText=~s/\&lt\;petemp\&gt\;/<petemp>/gs;
    $SourceText=~s/\&lt;\/petemp\&gt\;/<\/petemp>/gs;

    if($SourceText=~/<petemp>(.*?)<\/petemp>/s)
    {
	$TextBody=$1;
    }elsif($SourceText=~/<body([^<>]*?)>(.*?)<\/body>/s)
    {
    	$TextBody=$2;
    }else{
    	$TextBody="$SourceText";
    }

    $TextBody=~s/\&lt\;bib id=\&quot\;([a-zA-Z0-9\-\_]+)\&quot\;\&gt\;([ ]*)/<bib id=\"$1\">/gs;

    $TextBody=~s/\&lt\;bib id=\&quot\;([a-zA-Z0-9\-\_]+)\&quot\; type=\&quot\;([a-zA-Z0-9 \-\_ ]+)\&quot\;\&gt\;\&lt\;number\&gt\;([\[\]\(\)a-zA-Z0-9\.]+)\&lt\;\/number\&gt\;([ ]*)/<bib id=\"$1\" type=\"$2\" number=\"$3\">/gs;
    $TextBody=~s/\&lt\;bib id=\&quot\;([a-zA-Z0-9\-\_]+)\&quot\; type=\&quot\;([a-zA-Z0-9 \-\_ ]+)\&quot\;\&gt\;&lt;number&gt;([\[\]\(\)a-zA-Z0-9\.]+)&lt;\/number&gt;([ ]*)/<bib id=\"$1\" type=\"$2\" number=\"$3\">/gs;
    $TextBody=~s/\&lt\;bib id=\&quot\;([a-zA-Z0-9\-\_]+)\&quot\; type=\&quot\;([a-zA-Z0-9 \-\_ ]+)\&quot\;\&gt\;([ ]*)/<bib id=\"$1\" type="$2">/gs;
    $TextBody=~s/\&lt\;bib id=\&quot\;([a-zA-Z0-9\-\_]+)\&quot\; label=\&quot\;([^\=]*?)\&quot\; type=\&quot\;([a-zA-Z0-9\-\_ ]+)\&quot\;\&gt\;([ ]*)/<bib id=\"$1\" label=\"$2\" type=\"$3\">/gs;


    $TextBody=~s/&lt;(bib|b|i|u|sup|sub|sb|sp|aus|auf|aum|eds|edm|edf|aug|au|edr|edrg|iss|at|pt|s|m|f|cny|cty|pbl|pg|st|srt|v|yr|url|ia|misc1|issn|isbn|coden|doi|edn|collab|bt|proc|suffix|par|rpt|thesis|pat|org|eml|pco|pbo|rol|tel|fax|number|petemp|comment)&gt;/<$1>/gs;
    $TextBody=~s/&lt;\/(bib|b|i|u|sup|sub|sb|sp|aus|auf|aum|eds|edm|edf|au|aug|edr|edrg|iss|at|pt|s|m|f|cny|cty|pbl|pg|st|srt|v|yr|url|ia|misc1|issn|isbn|coden|doi|edn|collab|bt|proc|suffix|par|rpt|thesis|pat|org|eml|pco|pbo|rol|tel|fax|number|petemp|comment)&gt;/<\/$1>/gs;


    $TextBody=~s/<p ([^<>]*?)>//gs;
    $TextBody=~s/<p>//gs;
    $TextBody=~s/<\/p>//gs;
    $TextBody=~s/<span([^<>]*?)>//gs;
    $TextBody=~s/<\/span>//gs;

    $TextBody=~s/<\/pg><pg>\&\#x2013\;/\&\#x2013\;/gs;
    $TextBody=~s/<\/pg><pg>\&amp\;\#/\&amp\;\#/gs;
    $TextBody=~s/<\/pg><pg>\&amp\;\#/\&amp\;\#/gs;
    $TextBody=~s/<pg>([ 0-9A-Za-z]+)\&amp\;\#x2013\;([ 0-9A-Za-z]+)<\/pg>/<fpg>$1<\/fpg>\&amp\;\#x2013\;<lpg>$2<\/lpg>/gs;
    $TextBody=~s/<pg>([ 0-9A-Za-z]+)\&#x2013\;([ 0-9A-Za-z]+)<\/pg>/<fpg>$1<\/fpg>\&\#x2013\;<lpg>$2<\/lpg>/gs;

    $TextBody=~s/<pg>([ 0-9A-Za-z]+)([–\-])([ 0-9A-Za-z]+)<\/pg>/<fpg>$1<\/fpg>\&\#x2013\;<lpg>$3<\/lpg>/gs;
    $TextBody=~s/<pg>([ 0-9A-Za-z]+)â€“([ 0-9A-Za-z]+)<\/pg>/<fpg>$1<\/fpg>\&\#x2013\;<lpg>$2<\/lpg>/gs;
    $TextBody=~s/<pg>([ 0-9A-Za-z]+)\â([ 0-9A-Za-z]+)<\/pg>/<fpg>$1<\/fpg>\&\#x2013\;<lpg>$2<\/lpg>/gs;
    $TextBody=~s/<pg>([ 0-9A-Za-z]+)([^0-9A-Za-z\.\,\":\;\(\)\*\^\%\$\#\@\!\`\'\?\<\>]*?)([ 0-9A-Za-z]+)<\/pg>/<fpg>$1<\/fpg>\&\#x2013\;<lpg>$3<\/lpg>/gs;
    $TextBody=~s/<pg>(.*?)<\/pg>/<fpg>$1<\/fpg>/gs;

 
    return $TextBody;
}


##########################################

return 1;
