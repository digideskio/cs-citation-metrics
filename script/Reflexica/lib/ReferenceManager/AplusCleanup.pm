#version 1.0.4
#Author: Neyaz Ahmad
package ReferenceManager::AplusCleanup;
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(ColorToAPlusXml);

###################################################################################################################################################
###################################################################################################################################################
sub ColorToAPlusXml
  {
    my $InputFile=shift; 
    my ($SourceText, $inputfname, $ext)=&GetSourceData($InputFile);

    my $TextBody="";
    if($SourceText=~/<petemp>(.*?)<\/petemp>/s){
      $TextBody=$1;
    }elsif($SourceText=~/<body([^<>]*?)>(.*?)<\/body>/s){
      $TextBody=$2;
    }else{
      $TextBody="$SourceText";
    }

  $TextBody=~s/<orgbib>(.*?)<\/orgbib>//gs;
  $TextBody=~s/<orgfootnote>(.*?)<\/orgfootnote>//gs;

#-------
    # if($TextBody=~/\\bibitem/)
    #   {
    # 	$TextBody=TeXPreProcess($TextBody);
    #   }
#-------

    #$TextBody=TeXTagReplacement($TextBody);

    $TextBody=formatTextBody($TextBody);

    $TextBody=&SymbolEntityConversion($TextBody);

    $TextBody=&RefColorToTag($TextBody);

    $TextBody=~s/<a[\s]([^<>]*?)>[\s]*\&lt\;\/(bib|b|i|u|sup|sub|sb|sp|aus|auf|aum|eds|edm|edf|aug|au|edr|edrg|iss|at|pt|s|m|f|cny|cty|pbl|pg|st|srt|v|yr|url|ia|misc1|issn|isbn|doi|edn|collab|bt|proc|suffix|par|number|petemp)\&gt\;<\/i>/\&lt\;\/$2\&gt\;<\/i><a $1>/gs;
    $TextBody=~s/<a[\s]([^<>]*?)>[\s]*\&lt\;\/(bib|b|i|u|sup|sub|sb|sp|aus|auf|aum|eds|edm|edf|aug|au|edr|edrg|iss|at|pt|s|m|f|cny|cty|pbl|pg|st|srt|v|yr|url|ia|misc1|issn|isbn|doi|edn|collab|bt|proc|suffix|par|number|petemp)\&gt\;/\&lt\;\/$2\&gt\;<a $1>/gs;

    $TextBody=~s/<a[\s]([^<>]*?)><span([^<>]*?)>((?:(?!<span>)(?!<\/span>).)*)<\/span><\/span>/<span$2>$3<\/span><a $1><\/span>/gs;

    $TextBody=~s/<a[\s]([^<>]*?)>[\s]*<\/span><span([^<>]*?)><span([^<>]*?)><\!([^<>]*?)><a[\s]([^<>]*?)>\[QAu[0-9]+]<\!\-\-/<\!\-\-/gs;

    $TextBody=~s/\-\-\><\!\[endif\]><span([^<>]*?)>(\&nbsp\;)?<\/span><\/span><\/span>/\-\->/gs;

    $TextBody=~s/<[\/]?petemp>//gs;
    return $TextBody;
  }

#===============================================================================================
sub GetSourceData{
  my $InputFile=shift;
  #print "IN: $InputFile\n";
  my ($inputfname, $ext) = split(/.(htm|html|txt|sgml|text)/, $InputFile);
  if (!-e $InputFile){
    print "\n\n\n\n\n\n\n\n\n${inputfname}.$ext file not exist!!\n\n\n\n\n\n\n\n\n";
    exit ;
  }
  undef $/;
  open(INFILE,"<$InputFile")|| die("$InputFile File cannot be opened\n");
  my $SourceText=<INFILE>;
  close(INFILE);
  if($SourceText!~/<\/p>/){
    $SourceText=~s/([\s]*)\n([\s]+)/\n/gs;
    $SourceText=~s/^([\s]*)(.*?)([\s]*)$/<p>$2<\/p>/gs;
    $SourceText=~s/\n/<\/p>\n<p>/gs;
  }
  $SourceText=~s/<\!\-\-StartFragment\-\->/<petemp>/gs;
  $SourceText=~s/<\!\-\-EndFragment\-\->/<\/petemp>/gs;

  $SourceText=&AuthorQuery($SourceText);

############################For Demo Purpose By Avijeet Sir #####################
  $SourceText=~s/<p class=Bibentry>/<petemp><p class=Bibentry>/os;
  $SourceText=~s/(.*)<p class=Bibentry>((?:(?!<\/p>).)*)<\/p>/$1<p class=Bibentry>$2<\/p><\/petemp>/os;
  $SourceText=~s/<i([\s]*)style=\'([^<>]*?)\'>/<i>/gs;
#########################################################################


  #---precleanup---------
  $SourceText=~s/<span([\s]*)lang=([a-zA-Z\-]+)([\s]*)style=\'color:([a-zA-Z]+)\'>/<span lang=EN-US>/gs;
  $SourceText=~s/<span([\s]*)style=\'color:([a-zA-Z]+)\'>/<span>/gs;
  $SourceText=~s/<span([\s]*)lang=([A-Za-z\-]+)>/<span lang=EN-US>/gs;
  $SourceText=~s/<span([^<>]*?)>([\s]*)\&lt\;\/petemp\&gt\;<\/span>([\s]*)/<\/petemp>/gs;
  $SourceText=~s/<p([^<>]*?)><span([^<>]*?)>\&lt\;petemp\&gt\;<\/span><\/p>/<petemp>/gs;
  $SourceText=~s/<p([^<>]*?)><span([^<>]*?)>\&lt\;\/petemp\&gt\;<\/span><\/p>/<\/petemp>/gs;
  $SourceText=~s/<span([^<>]*)>([\s])*\&lt\;\/petemp\&gt\;<\/span><\/p>/<\/p><\/petemp>/gs;
  $SourceText=~s/ <\/span><\/p>/<\/span><\/p>/gs;
  $SourceText=~s/lang=([A-Za-z\-]+)/lang=En-US/gs;
  $SourceText=~s/<span([\s]*)lang=([A-Za-z\-]+)>([\s]+)<\/span>/ /gs;
  $SourceText=~s/<span([\s]*)lang=([A-Za-z\-]+)><\/span>//gs;
  $SourceText=~s/<i>([\.\:\,\;]) /$1 <i>/gs;
  $SourceText=~s/<i><span([\s]*)lang=([A-Za-z\-]+)>([\.\,\?\:\;])<\/span><\/i>/$3/gs;
  $SourceText=~s/<p([^<>]*?)><span([^<>]*?)>([0-9]+)\.([\s]*)/<p$1>$3\. /gs;
  $SourceText=~s/<p([^<>]*?)><span([^<>]*?)>([0-9]+)<\/span><span([^<>]*?)>\.([\s]*)/<p$1>$3\. /gs;
  $SourceText=~s/<\/a>//gs;
  $SourceText=~s/<a name=bookmark([0-9]+)>//gs;
  $SourceText=~s/ ([\ ]+)/ /gs;
  $SourceText=~s/([ ]+)//gs;
  #$SourceText=~s/–//gs
  $SourceText=~s/–/--/g;
  $SourceText=~s/â/--/g;
  $SourceText=~s/â€“/--/g;
  $SourceText=~s/<i>\.&lt;\/bib&gt;<\/i>/\.&lt;\/bib&gt;/gs;
  $SourceText=~s/\.&lt;\/bib&gt;<\/i>/<\/i>\.&lt;\/bib&gt;/gs;
  $SourceText=~s/<o:p>([\s]*)<\/o:p>//gs;

  $SourceText=~s/\&lt\;[Pp]etemp\&gt\;/\&lt\;petemp\&gt\;/igs;
  $SourceText=~s/\&lt\;\/[Pp]etemp\&gt\;/\&lt\;\/petemp\&gt\;/igs;
  $SourceText=~s/\&lt\;[Pp]temp\&gt\;/\&lt\;petemp\&gt\;/igs;
  $SourceText=~s/\&lt\;\/[Pp]temp\&gt\;/\&lt\;\/petemp\&gt\;/igs;
  $SourceText=~s/<[Pp]etemp>/<petemp>/igs;
  $SourceText=~s/<\/[Pp]etemp>/<\/petemp>/igs;
  $SourceText=~s/<[pP]temp>/<petemp>/igs;
  $SourceText=~s/<\/[pP]temp>/<\/petemp>/igs;

  $SourceText=~s/<br[^<>]*?>/\n/gs;

  $SourceText=~s/<span([^<>]*?)>\&lt\;\/petemp\&gt\;<\/span>/<\/petemp>/gs;
  $SourceText=~s/<span([^<>]*?)><\/petemp><\/span>/<\/petemp>/gs;
  $SourceText=~s/<p class\=([a-zA-Z\_\-]+)><span([^<>]*?)>\&lt\;petemp\&gt\;/<petemp><p class\=$1><span$2>/gs;
  $SourceText=~s/<p([^<>]*?)><span([^<>]*?)>\&lt\;petemp\&gt\;/<petemp><p$1><span$2>/gs;
  $SourceText=~s/<p class=([a-zA-Z\_\-]+)><span([\s]*)lang=([a-zA-Z\-]+)([\s]*)style=\'([^\'\<\>]*?)\'>\&lt\;petemp\&gt\;/<petemp><p class\=$1><span lang\=$3>/gs;
  $SourceText=~s/<p class\=Bibentry><span lang\=([a-zA-Z\-]+)>\&lt\;petemp\&gt\;/<petemp><p class\=Bibentry><span lang\=$1>/gs;
  $SourceText=~s/<p class\=Bib_entry><span lang\=([a-zA-Z\-]+)>\&lt\;petemp\&gt\;/<petemp><p class\=Bib_entry><span lang\=$1>/gs;
  $SourceText=~s/\&lt\;\/petemp\&gt\;<\/span><\/p>/<\/span><\/p><\/petemp>/g;
  $SourceText=~s/\&lt\;\/petemp\&gt\;<\/p>/<\/p><\/petemp>/g;
  $SourceText=~s/<p>&lt;petemp&gt;/<petemp><p>/g;
  $SourceText=~s/<\/petemp><\/p>/<\/p><\/petemp>/g;
  $SourceText=~s/<p><petemp>/<petemp><p>/g;
  $SourceText=~s/<p([^<>]*?)>&lt;petemp&gt;/<petemp><p>/gs;
  $SourceText=~s/<p([^<>]*?)><span([^<>]*?)>\&lt\;\/petemp\&gt\;/<\/petemp><p$1><span$2>/gs;
  $SourceText=~s/<b>\. <\/b>/. /gs;
  $SourceText=~s/<em>(.*?)<\/em>/<i>$1<\/i>/gs;
  $SourceText=~s/([\.\:\;\?\,])([\s]*)<\/(i|b)>([\s]+)/<\/$3>$1 /gs;
  $SourceText=~s/([\.\:\;\?\,])([\s]*)<\/(i|b)>/<\/$3>$1/gs;
  $SourceText=~s/<(i|b|u|sub|sup|sb|sp)>([\s]+)/ <$1>/gs;
  $SourceText=~s/<(i|b|u|sub|sup|sb|sp)>([\s]+)/ <$1>/gs;
  $SourceText=~s/([\s]+)<\/(i|b|u|sub|sup)>/<\/$2> /gs;
  $SourceText=~s/<\/i> <i>/ /gs;
  $SourceText=~s/<i><\/i>//gs;
  $SourceText=~s/<i> <\/i>/ /gs;

  $SourceText=~s/<(u|sub|sup)>([\s]+)/ <$1>/gs;
  $SourceText=~s/<\/(u|sub|sup)>([\s]+)/ <\/$1>/gs;

  $SourceText=~s/<(u|sub|sup)>/\&$1\;/gs;
  $SourceText=~s/<\/(u|sub|sup)>/ \&\/$1\;/gs;
  $SourceText=~s/<p([^<>]*?)>\&nbsp\;<\/p>//gs;
  $SourceText=~s/\(([0-9a-z \/\\]+)\)\.\&nbsp\;<i>/\($1\)\. <i>/gs;

  return ($SourceText, $inputfname, $ext);
}

#==================================================================================================================================
sub formatTextBody{
  my $TextBody=shift;


  $TextBody=~s/\&lt\;bib([\s]+)id=\&quot\;(bib[0-9]+)\&quot\;((?:(?!\&gt\;).)*)\&gt\;/<bib id=\"$2\">/gs;
  $TextBody=~s/\&lt\;bib([\s]+)id=\&quot\;([0-9]+)\&quot\;((?:(?!\&gt\;).)*)\&gt\;/<bib id=\"bib$2\">/gs;

  $TextBody=~s/\&lt\;\/number\&gt\; /\&lt\;\/number\&gt\;/gs;
  $TextBody=~s/<bib id=\"bibbib([a-z0-9]+)\">/<bib id=\"bib$1\">/gs;
  $TextBody=~s/\&lt\;\/bib&gt\;/<\/bib>/gs;

  while($TextBody=~/<p([^<>]*?)>(.*?)<\/p>/os){#for line runon
    my $paratext=$2;
    $paratext=~s/([\s]+)/ /gs;
    $TextBody=~s/<p([^<>]*?)>(.*?)<\/p>/<123p$1>$paratext<\/123p>/os;
  }
  $TextBody=~s/<123p/<p/gs;
  $TextBody=~s/<\/123p>/<\/p>/gs;

  my $bibtagfound="1";
  if($TextBody!~/<bib ([^<>]*?)>/){
    $TextBody=~s/<p([^<>]*?)>([\s]*)/<p$1><bib id=\"bib0\">/gs;  # add bib if not persent
    $TextBody=~s/([\s]*)<\/p>/<\/bib><\/p>/gs;
    $bibtagfound="0";
  }


  $TextBody=~s/<span([\s]*)style=\'color:#D9D9D9\'>\&lt\;number\&gt\;<\/span>[\s]*/\&lt\;number\&gt\;/gs;
  $TextBody=~s/<span([\s]*)style=\'color:#D9D9D9\'>\&lt\;\/number\&gt\;<\/span>[\s]*/\&lt\;\/number\&gt\;/gs;

  $TextBody=~s/<span([^<>]*?)><bib([^<>]*?)><\/span>/<bib$2>/gs;
  $TextBody=~s/<span([^<>]*?)>\&amp\;\#x0026\;<\/span>/\&/gs;
  $TextBody=~s/background\:[\s]*\#/background\:\#/gs;
  $TextBody=~s/border\:[\s]*dotted/border\:dotted/gs;
  $TextBody=~s/1\.0pt\;[\s]*padding:[\s]*0pt/1\.0pt\;padding:0pt/gs;
  $TextBody=~s/<span[\s]*lang=[a-zA-Z\-]+[\s]*style=\'border:dotted/<span style=\'border:dotted/gs;
  $TextBody=~s/style=\'[^<>\']*?border:dotted/style=\'border:dotted/gs;
  $TextBody=~s/border:dotted maroon 1\.0pt\;padding:0pt/border:dotted windowtext 1\.0pt\;padding:0pt/gs;
  $TextBody=~s/style=\'border:dotted windowtext 1\.0pt\;\s*mso-border-alt:dotted\s*windowtext\s*\.5pt\;\s*padding:0pt/style=\'border:dotted windowtext 1\.0pt\;padding:0pt/gs;

  # $TextBody=~s/style='border:dotted windowtext 1.0pt;mso-border-alt:dotted windowtext .5pt; padding:0pt'//gs;
  $TextBody=~s/<span([^<>]*?style=\'border\:[\s]*dotted)[^<>]*?(background\:\#[A-Z0-9]+[^<>]*?')>((?:(?!<span[^<>]*?>)(?!<\/span>).)*)<\/span>/<spand$1 windowtext 1.0pt;padding:0pt\'><spanb style=\'$2>$3<\/spanb><\/spand>/gs;
  $TextBody=~s/<span[^<>]*?(style=\'border:dotted windowtext 1.0pt;padding:0pt\')>([\,\;\. ]+)<span[\s]*(style=\'background:#[A-Z0-9]+[^<>]*?\')>([^<>]*?)<\/span><\/span>/<spand $1>$2<spanb $3>$4<\/spanb><\/spand>/gs;
  $TextBody=~s/<\/spand><\/span><spand/<\/spand><spand/gs;
  $TextBody=~s/<\/spanb><\/spand><spand[^<>\']*?style=\'border:dotted windowtext 1.0pt;padding:0pt\'><spanb[\s]*(style=\'background:#[A-Z0-9]+[^<>]*?\')>//gs;
  $TextBody=~s/<\/spand><spand[^<>\']*?style='border:dotted windowtext 1.0pt;padding:0pt'>//gs;


  $TextBody=~s/<spanb/<span/gs;
  $TextBody=~s/<\/spanb>/<\/span>/gs;
  $TextBody=~s/<spand([^<>]*)>/<au>/gs;
  $TextBody=~s/<\/spand>/<\/au>/gs;

  $TextBody=~s/<bib([^<>]*?)>[\s ]+/<bib$1>/gs;
  $TextBody=~s/<p class=([a-zA-Z]+)> /<p class=$1>/gs;
  $TextBody=~s/<\/span> \, <span/<\/span>\, <span/gs;

  $TextBody=~s/<p([^<>]*?)><bib id=\"bib0\"><span([^<>]*?)><bib([^<>]*?)>/<p$1><span$2><bib$3>/gs;
  $TextBody=~s/<p([^<>]*?)><bib id=\"bib0\"><bib([^<>]*?)>/<p$1><bib$2>/gs;

  $TextBody=~s/<\/bib><\/bib><\/p>/<\/bib><\/p>/gs;
  $TextBody=~s/<\/bib><\/span><\/bib><\/p>/<\/bib><\/span><\/p>/gs;

  $TextBody=~s/<p([^<>]*?)><span([^<>]*?)><bib id=\"bib0\"><span([^<>]*?)>\&nbsp\;<\/span><\/bib><\/span><\/p>/<p$1><span$2>\&nbsp\;<\/span><\/p>/gs;
  $TextBody=~s/<p([^<>]*?)><bib id=\"bib0\">\&nbsp\;<\/bib><\/p>/<p$1>\&nbsp\;<\/p>/gs;

  $TextBody=~s/<p([^<>]*?)><bib id=\"bib0\"><span([^<>]*?)>\&nbsp\;<\/span><\/bib><\/p>/<p$1>\&nbsp\;<\/p>/gs;
  $TextBody=~s/<p([^<>]*?)><span([^<>]*?)><bib id=\"bib0\"><span([^<>]*?)>([a-zA-Z\-\. \(\)]+)<\/span><\/bib><\/span><\/p>/<p$1><span$2>$4<\/span><\/p>/gs;

  $TextBody=~s/<p([^<>]*?)><bib id=\"bib0\">([a-zA-Z\-\. \(\)]+)<\/bib><\/p>/<p$1>$2<\/p>/gs;
  $TextBody=~s/<p([^<>]*?)><bib id=\"bib0\"><span([^<>]*?)>([a-zA-Z\-\. \(\)]+)<\/span><\/bib><\/p>/<p$1>$3<\/p>/gs;

  $TextBody=~s/<p([^<>]*?)><span([^<>]*?)><bib([^<>]*?)>([0-9\.\s]+)([Â \  ]*) /<p$1><span$2><bib$3>$4 /gs;

  $TextBody=~s/<span([^<>]*?)><bib([^<>]*?)>([0-9\.\s]+)([Â \  ]*) /<span$1><bib$2>$3 /gs;

  $TextBody=~s/<bib([^<>]*?)>([\s]*)\&lt\;number\&gt\;([\[\]\(\)a-zA-Z0-9\.]+)\&lt\;\/number\&gt\;([\s]*)/<bib$1 number=\"$3\">/gs;
  $TextBody=~s/<bib([^<>]*?)>([\s]*)([\[\]\(\)0-9\.]+)([\s]+)/<bib$1 number=\"$3\">/gs;
  $TextBody=~s/<p><bib ([^<>]*?)><\/bib><\/p>//gs;
  $TextBody=~s/<o:p>\&nbsp\;<\/o:p>//gs;
  $TextBody=~s/<p class=MsoNormal>([\s]*)<\/p>//gs;
  $TextBody=~s/^(.*)[\s]*<\/div>[\s]*/$1/gs;
  $TextBody=~s/^[\s]*<div([^<>]*?)>[\s]*(.*)/$2/gs;
  $TextBody=~s/\n\n*/\n/gs;
  return $TextBody;
}

#=======================================================================================================================================
sub RefColorToTag
{
    my $Text = shift;

    $Text=~s/<span([\s]*)style=\'border:([\s]*)dotted([\s]*)([a-zA-Z]+)([\s]*)1\.0pt\;([\s]*)padding:([\s]*)0pt\;([\s]*)background:\#([^\']*?)\'>([^<>]*?)<\/span>/<span style=\'border:dotted $4 1\.0pt\;padding:0pt\'><span style=\'background:\#$9\'>$10<\/span><\/span>/gs;
    $Text=~s/<span([\s]*)style='background:#[^']*?'>(\s+)<\/span>/$2/gs;
    $Text=~s/<span([\s]*)style=\'color\:\#FF6600\'>(.*?)<\/span>/$2/gs;

    $Text=&AuthorGroupBoundary($Text);

    print "Autor grouping Done\n";

    my ($Colour2TagRef, $Tag2ColourRef)=&ColorAndTag;

    print "Color tag conf done\n";

    while($Text=~/<([0-9]+)span\s*([^>]*?)style=\'([^>]*?)background:\s*(\#[0-9A-Z]+)([^>]*?)>(.*?)<\/\1span>/is)
    {
	my $color=$4;
	if(exists $$Colour2TagRef{$color})
	{
	    $Text=~s/<([0-9]+)span\s*([^>]*?)style=\'([^>]*?)background:\s*$color([^>]*?)>(.*?)<\/\1span>/\&lt\;$$Colour2TagRef{$color}\&gt\;$5\&lt\;\/$$Colour2TagRef{$color}\&gt\;/gsi;
	                                                #print "$$Colour2TagRef{$color}\n";
	}else
	{
	    $Text=~s/<([0-9]+)span\s*([^>]*?)style=\'([^>]*?)background:\s*(\#[0-9A-Z]+)([^>]*?)>(.*?)<\/\1span>/<X$1span $2style=\'$3background:$4$5>$6<\/\1span>/osi;
	}
    }


#--------------------testing-------------------------------------------------------------------
    while($Text=~/<span\s*([^>]*?)style=\'([^>]*?)background:\s*(\#[0-9A-Z]+)([^>]*?)>(.*?)<\/span>/is)
      {
	my $color=$3;
	if(exists $$Colour2TagRef{$color})
	  {
	    $Text=~s/<span\s*([^>]*?)style=\'([^>]*?)background:\s*$color([^>]*?)>(.*?)<\/span>/\&lt\;$$Colour2TagRef{$color}\&gt\;$4\&lt\;\/$$Colour2TagRef{$color}\&gt\;/osi;
	    # print "$$Colour2TagRef{$color}\n";
	  }else
	    {
	    $Text=~s/<span\s*([^>]*?)style=\'([^>]*?)background:\s*(\#[0-9A-Z]+)([^>]*?)>(.*?)<\/\1span>/<Xspan $1style=\'$2background:$3$4>$5<\/span>/osi;
	  }
      }

#-------------------------------------------------
    #######
    $Text=~s/<\/[0-9]+span/<\/span/gs;
    $Text=~s/<[0-9]+span/<span/gs;
    $Text=~s/<X[0-9]+span/<span/gs;
    $Text=~s/<Xspan/<span/gs;

    $Text=~s/<span([\s]*)style=\'border:([^\'<>]*?)padding:([0-9a-z]+)\'>(.*?)<\/span>/&lt;au&gt;$4&lt;\/au&gt;/gs;

    $Text=~s/\&lt\;\/([a-z]+)\&gt\;\&lt\;\1\&gt\;//gs;
    $Text=~s/\&lt\;\/at\&gt\;<\/span>\&lt\;at\&gt\;(.*?)\&lt\;\/at\&gt\;/$1\&lt\;\/at\&gt\;<\/span>/gs;
    $Text=~s/<\/span><span lang=EN-US>//gs;

    $Text=~s/<au>\&lt\;(eds|edm)\&gt\;/<edr>\&lt\;$1\&gt\;/gs;
    $Text=~s/\&lt\;\/(eds|edm)\&gt\;<\/au>/\&lt\;\/$1\&gt\;<\/edr>/gs;

 

    return($Text);
}

#============================================================================================================================================

sub ColorAndTag
{
    my $Colour2TagRef=();
    my $Tag2ColourRef=();
    my %Tag2Colour=();

    my %Colour2Tag=(
	'#C0FFC0' => 'cny',
	'#66FFFF' => 'cty',
	'#FFFF80' => 'par', #	'#FFFF80' => 'par', Jr
	'#C8BE84' => 'iss',
	'#FFFF49' => 'pbl',
	'#D279FF' => 'pg',
	'#00CC99' => 'st',
	'#FFCC66' => 'v',
	'#66FF66' => 'yr',
	'#FF3300' => 'url',
	'#FF9933' => 'misc1',
	'#BDBAD6' => 'ia',
	'#A17189' => 'issn',
	'#C8EBFC' => 'isbn',
	'#F9A88F' => 'coden',
	'#CFBFB1' => 'doi',
	'#9999FF' => 'edn',
	'#5F5F5F' => 'collab',
	'#CCCCFF' => 'at',
	'#FFD9B3' => 'bt',
	'#5A96A2' => 'proc',
	'#CCFF99' => 'pt',
	'#D7E553' => 'rpt',
	'#E5D007' => 'srt',
	'#B26510' => 'pat',
	'#00FF99' => 'org',
	'#FFCC00' => 'eml',
	'#33CCCC' => 'str',
	'#C6C6C6' => 'pco',
	'#F7D599' => 'pbo',
	'#7FFA54' => 'role',
	'#FFA86D' => 'suffix',
	'#FF8633' => 'prefix',
	'#00C400' => 'deg',
	'#91C8FF' => 'tel',
	'#FEC0CC' => 'fax',
	'#BCBCBC' => 'aus',
	'#DDDDDD' => 'auf',
	'#9C9C9C' => 'aum',
	'#FF95CA' => 'eds',
	'#FF67B3' => 'edf',
	'#FFD1E8' => 'edm',
	'#FFFF0F' => 'comment',
	);

    $Colour2TagRef=\%Colour2Tag;
    foreach my $Keyes(keys %Colour2Tag)
    {
	$Tag2Colour{$Colour2Tag{$Keyes}}=$Keyes;
    }
    $Tag2ColourRef=\%Tag2Colour;

    return ($Colour2TagRef, $Tag2ColourRef);
}


#========================================================================================================================================

sub AuthorGroupBoundary
{
  my  $Text = shift;
  my  $Sequence=1;
    while($Text=~/<span\s*([^<>]*?)>((?:(?!<span\s*([^<>]*?)>)(?!<\/span>).)*)<\/span>/s)
    {
      $Text=~s/<span\s*([^<>]*?)>((?:(?!<span\s*([^<>]*?)>)(?!<\/span>).)*)<\/span>/<${Sequence}span $1>$2<\/${Sequence}span>/gs;
      $Sequence++;
    }
    return($Text);
}


#==============================================================================================================================

sub SymbolEntityConversion
{
    my $XMLContent=shift;
    my $SCRITPATH=$0;
    $SCRITPATH=~s/(.*)([\/\\])(.*?)\.(pl|exe)/$1/g;
    my $EntitiesXMLPATH=$SCRITPATH."\/Ref-Entities\.xml";
    my $FONTNAME=&loadEntitiesXML($EntitiesXMLPATH);  #return FONTNAME hash ref

    while($XMLContent=~/<\!\-\-<div class=\"Font\"=([a-zA-Z0-9 ]+)>\-\->\&\#x([a-zA-Z0-9]+)\;<\!\-\-<\/div>\-\->/)
    {
	my $Fonttype=$1;
	my $WCCEntity=$2;
	my $changeFont="";
	if(exists ${$$FONTNAME{$Fonttype}}{"$WCCEntity"})
	{
	    $changeFont=${$$FONTNAME{$Fonttype}}{"$WCCEntity"};
	}else
	{
	    print "$Fonttype: $WCCEntity => Font Not Define in Entities XML\n";
	    $changeFont=$WCCEntity;
	}
	#print "\n****$Fonttype: $WCCEntity => $changeFont\n";

	$XMLContent=~s/<\!\-\-<div class=\"Font\"=([a-zA-Z0-9 ]+)>\-\->\&\#x([a-zA-Z0-9]+)\;<\!\-\-<\/div>\-\->/<\!\-\-<div class=\"CFont\"=$1>\-\->\&\#x${changeFont}\;<\!\-\-<\/div>\-\->/os;
    }

    return $XMLContent;
}

#==========================================================================================================================================================
sub loadEntitiesXML
{
    my  $EntitiesXMLPATH=shift;
    undef $/;
    open(ENXML,"<$EntitiesXMLPATH")|| die("$EntitiesXMLPATH Can't open the file for reading!\n");
    my $ENContent=<ENXML>;
    close(ENXML); 

    #<WCC>0020</WCC><IFont>Symbol</IFont><IDUni>0020</IDUni>
    my %FONTNAME=();
    while($ENContent=~/<WCC>([0-9A-Za-z]+)<\/WCC><IFont>([A-Za-z0-9\- ]+)<\/IFont><IDUni>([0-9A-Za-z]+)<\/IDUni>/)
    {
	my $WCC=$1;
	my $IFont=$2;
	my $IDUni=$3;
	$FONTNAME{$IFont}{$WCC}="$IDUni";
	$ENContent=~s/<WCC>([0-9A-Za-z]+)<\/WCC><IFont>([A-Za-z0-9\- ]+)<\/IFont><IDUni>([0-9A-Za-z]+)<\/IDUni>//os;
    }

    my  $FONTREF=\%FONTNAME;

    return $FONTREF;
}
#==========================================================================================================================================================


sub AuthorQuery
  {
    my $SourceText=shift;
    while($SourceText=~/<p class=Bibentry>(.*?)<\/p>/s)
      {
	$Bibentry="";
	$Bibentry=$1;
	#print $Bibentry;
	if($Bibentry=~/\[([QAu0-9]+)\]<\/a>/)
	  {
	    $QAu="";
	    $QAu=$1;
	    if($SourceText=~/\[([QAu0-9]+)\]<\/a><\!\[endif\]><\/span><\/span><\/span><span\s*lang=[A-Za-z\-\_]+>(.*?)<\/span>/s)
	      {
		$aqdetail="";
		$aqdetail=$2;
	      }
	    $Bibentry=~s/\[$QAu\]<\/a>/\[$QAu\]<\/a><\!\-\- $QAu: $aqdetail \-\->/;
	  }
	$SourceText=~s/<p class=Bibentry>(.*?)<\/p>/<123p class=Bibentry>$Bibentry<\/123p>/s;
      }
    $SourceText=~s/<123p /<p /g;
    $SourceText=~s/<\/123p>/<\/p>/g;

    return $SourceText;
  }


##########################################

#==========================================================
sub TeXTagReplacement{
  my $TextBody=shift;

  our %TAGS2TeX = (
	     'au' => '\refau',
	     'auf' => '\reffn',
	     'aus' => '\refsn',
	     'edr' => '\refed',
	     'eds' => '\refedsn',
	     'edm' => '\refedfn',
	     'par' => '\refpar',
	     'suffix' => '\refsuffix',
	     'prefix' => '\refprefix',
	     'at' => '\refat',
	     'pt' => '\refjt',
	     'misc1' => '\refct',
	     'bt' => '\refbt',
	     'srt' => '\refsrt',
	     'pbl' => '\refpname',
	     'cny' => '\refploc',
	     'pg' => '\refpg',
	     'iss' => '\refissue',
	     'edn' => '\refen',
	     'v' => '\refvol',
	     'yr' => '\refyr',
	     'ia' => '\refia',
	     'doi' => '\refdoi',
	     'url' => '\refurl',
	     'comment' => '\refcomment',
	     'collab' => '\refcollab',
	     'rpt' => '\refrpt',
	    );

  my %TeX2TAGS=();

  foreach my $Keyes(keys %TAGS2TeX)
    {
      $TeX2TAGS{$TAGS2TeX{$Keyes}}=$Keyes;
    }

  foreach my $key (keys(%TeX2TAGS)){
    my $xmltag=$key;
    $xmltag=~s/\\/\\\\/gs;
    $TextBody=~s/$xmltag<cur1>(.*?)<\/cur1>/<$TeX2TAGS{$key}>$1<\/$TeX2TAGS{$key}>/gs;
    $TextBody=~s/$xmltag<cur2>(.*?)<\/cur2>/<$TeX2TAGS{$key}>$1<\/$TeX2TAGS{$key}>/gs;
    $TextBody=~s/$xmltag<cur3>(.*?)<\/cur3>/<$TeX2TAGS{$key}>$1<\/$TeX2TAGS{$key}>/gs;
    $TextBody=~s/<i>${xmltag}\\it<cur2>(.*?)<\/cur2><\/i>/<i><$TeX2TAGS{$key}>$1<\/$TeX2TAGS{$key}><\/i>/gs;
    $TextBody=~s/${xmltag}\\it<cur2>(.*?)<\/cur2>/<i><$TeX2TAGS{$key}>$1<\/$TeX2TAGS{$key}><\/i>/gs;
    $TextBody=~s/${xmltag}<i>(.*?)<\/i>/<i><$TeX2TAGS{$key}>$1<\/$TeX2TAGS{$key}><\/i>/gs;
    $TextBody=~s/${xmltag}<b>(.*?)<\/b>/<b><$TeX2TAGS{$key}>$1<\/$TeX2TAGS{$key}><\/b>/gs;
  }
  $TextBody=~s/<p><\/p>//gs;

  $TextBody=~s/\\it<cur1>(.*?)<\/cur1>/<i>$1<\/i>/gs;
  $TextBody=~s/\\bf<cur1>(.*?)<\/cur1>/<b>$1<\/b>/gs;

  $TextBody=~s/\$\^<cur1>(.*?)<\/cur1>\$/<sp>$1<\/sp>/gs;
  $TextBody=~s/\$\^<cur2>(.*?)<\/cur2>\$/<sp>$2<\/sp>/gs;
  $TextBody=~s/\$\_<cur1>(.*?)<\/cur1>\$/<sb>$1<\/sb>/gs;
  $TextBody=~s/\$\_<cur2>(.*?)<\/cur2>\$/<sb>$2<\/sb>/gs;

  $TextBody=~s/\^<cur1>(.*?)<\/cur1>/<sp>$1<\/sp>/gs;
  $TextBody=~s/\^<cur2>(.*?)<\/cur2>/<sp>$2<\/sp>/gs;
  $TextBody=~s/\_<cur1>(.*?)<\/cur1>/<sb>$1<\/sb>/gs;
  $TextBody=~s/\_<cur2>(.*?)<\/cur2>/<sb>$2<\/sb>/gs;

  return  $TextBody;
}


#=========================================================================================================
sub ReferencesCleanup{
  my $BibText=shift;

  $BibText=~s/^\s*<dummyCurly>//gs;
  $BibText=~s/<bib([^<>]*)>([\s]+)/<bib$1>/gs;
  $BibText=~s/\&\#x00A0\;/\~/gs;
  $BibText=~s/\&\#x201C\;/\`\`/gs;
  $BibText=~s/\&\#x201D\;/\'\'/gs;
  $BibText=~s/\&\#x2018\;/\'/gs;
  $BibText=~s/\&\#x2019\;/\`/gs;
  $BibText=~s/\&\#x2013\;/\-\-/gs;
  $BibText=~s/\\&\\ /& /gs;
  $BibText=~s/ \\& / & /gs;
  $BibText=~s/ \\ / /gs;
  $BibText=~s/ \\\; / /gs;
  $BibText=~s/<(i|b)>\\ /\\<$1> /gs;

  $BibText=~s/<href>((?:(?!<href>)(?!<\/href>).)*)<\/href><cur1>\1<\/cur1>/<href>$1<\/href>/gs;
  $BibText=~s/<href>((?:(?!<href>)(?!<\/href>).)*)<\/href><cur1>(.*?)<\/cur1>/<href>$2<\/href>/gs;
  $BibText=~s/<href>((?:(?!<href>)(?!<\/href>).)*)<\/href><cur2>(.*?)<\/cur2>/<href>$2<\/href>/gs;
  while($BibText=~/<href>((?:(?!<href>)(?!<\/href>).)*)<\/href>/s)
    {
      my $href=$1;
      $href=~s/\&\#x0025\;/\%/gs;
      $href=~s/\&\#x00A0\;/\~/gs;
      $href=~s/\&\#x002B\;/+/gs;
      $href=~s/\&\#x0026\;/\&/gs;
      $href=~s/\&\#x0023\;/\#/gs;
      $href=~s/\\\&/\&/gs;
      $href=~s/\\\_/\_/gs;
      $BibText=~s/<href>((?:(?!<href>)(?!<\/href>).)*)<\/href>/$href/os;
    }

  $BibText=~s/\b(p|pp|Pages)\.\~ ([A-Z0-9]+)([\s]*)([\-]+)([\s]*)([A-Z0-9]+)/$1\. $2$4$6/gs;
  $BibText=~s/\b(p|pp|Pages)\. \~([A-Z0-9]+)([\s]*)([\-]+)([\s]*)([A-Z0-9]+)/$1\. $2$4$6/gs;
  $BibText=~s/\b(p|pp|Pages)\.\~([A-Z0-9]+)([\s]*)([\-]+)([\s]*)([A-Z0-9]+)/$1\. $2$4$6/gs;
  $BibText=~s/\b(p|pp|Pages)\. ([A-Z0-9]+)([\s]*)([\-]+)([\s]*)([A-Z0-9]+)/$1\. $2$4$6/gs;
  $BibText=~s/\b(p|pp|Pages)\.([A-Z0-9]+)([\s]*)([\-]+)([\s]*)([A-Z0-9]+)/$1\. $2$4$6/gs;
  $BibText=~s/\b(p|pp|Pages)~([A-Z0-9]+)([\s]*)([\-]+)([\s]*)([A-Z0-9]+)/$1 $2$4$6/gs;
  $BibText=~s/\,\b(p|pp)\. ([0-9]+)--([0-9]+)\,/\, $1\. $2--$3\,/gs;
  $BibText=~s/\,([A-Z]) ([A-Z][a-z]+) /\, $1 $2 /gs;
  $BibText=~s/\b(p|pp|Pages|pages|Page|page)([\.]?)\~([A-Z0-9]+)/$1$2 $3/gs;
  $BibText=~s/\,\~\`\`/\, \`\`/gs;
  $BibText=~s/\, \`\` /\, \`\`/gs; 
  $BibText=~s/\,\"<i>/\,\'\' <i>/gs;
  $BibText=~s/\,\" <i>/\,\'\' <i>/gs;
  $BibText=~s/\" <i>/\'\' <i>/gs;
  $BibText=~s/\"\, <i>/\'\'\, <i>/gs;
  $BibText=~s/\, \'\' <i>/\,\'\' <i>/gs;
  $BibText=~s/\'\'\,<i>/\'\'\, <i>/gs;
  $BibText=~s/ \, /\, /gs;
  $BibText=~s/<\/i>([0-9]+)\(([0-9]+)\)/<\/i> $1\($2\)/gs;
  $BibText=~s/ <cur2><i>((?:(?!<cur2>)(?!<\/cur2>).)*)<\/i><\/cur2>/ <i>$1<\/i>/gs;
  $BibText=~s/ \`\'<cur2>((?:(?!<cur2>)(?!<\/cur2>).)*)<\/cur2>([\.\,])\'\'/ \`\'$1$2\'\'/gs;
  $BibText=~s/<cur2>\&\#x([0-9a-zA-Z]+)\;<\/cur2>/\&$1\#\;/gs;
  $BibText=~s/ <cur1>((?:(?!<cur1>)(?!<\/cur1>).)*)<\/cur1>/ $1/gs;
  $BibText=~s/([\(\[\`\-])<cur1>((?:(?!<cur1>)(?!<\/cur1>).)*)<\/cur1>/$1$2/gs;
  $BibText=~s/\(<cur1>((?:(?!<cur1>)(?!<\/cur1>).)*)<\/cur1>\)/$1/gs;

  $BibText=~s/ ([A-Za-z0-9]+)<cur1>((?:(?!<cur1>)(?!<\/cur1>).)*)<\/cur1>/ $1$2/gs;
  $BibText=~s/<doi><cur1>((?:(?!<cur1>)(?!<\/cur1>).)*)<\/cur1>(.*?)<\/doi>/$1$2/gs;
  
  $BibText=~s/<cur1>\\sc((?:(?!<cur1>)(?!<\/cur1>).)*)<\/cur1>/$1/gs;
  $BibText=~s/<cur1>\\textsc((?:(?!<cur1>)(?!<\/cur1>).)*)<\/cur1>/$1/gs;
  $BibText=~s/\\sc<cur1>((?:(?!<cur1>)(?!<\/cur1>).)*)<\/cur1>/$1/gs;
  $BibText=~s/\\sc<cur2>((?:(?!<cur2>)(?!<\/cur2>).)*)<\/cur2>/$1/gs;

  $BibText=~s/\\textsc<cur1>((?:(?!<cur1>)(?!<\/cur1>).)*)<\/cur1>/$1/gs;
  $BibText=~s/\\textsc<cur2>((?:(?!<cur2>)(?!<\/cur2>).)*)<\/cur2>/$1/gs;
  $BibText=~s/<sf>((?:(?!<sf>)(?!<\/sf>).)*)<\/sf>/$1/gs;

  $BibText=~s/([A-Z])\.\~ ([A-Z])\./$1\. $2\./gs;
  $BibText=~s/([A-Z])\. \~([A-Z])\./$1\. $2\./gs;

  $BibText=~s/([A-Z])\.\~([A-Z])\./$1\. $2\./gs;
  $BibText=~s/([A-Z])\.\~([A-Z])\./$1\. $2\./gs;
  $BibText=~s/([A-Z])\.\~([A-Z][a-z]+)/$1\. $2/gs;
  $BibText=~s/([A-Z])\. \~([A-Z][a-z]+)/$1\. $2/gs;
  $BibText=~s/([A-Z])\.\~([a-z]+)/$1\. $2/gs;
  $BibText=~s/([a-z])\~([A-Z][a-z]+)/$1 $2/gs;

  $BibText=~s/(vol|no)\.([\s]*)\~([\s]*)([0-9]+)/$1\. $4/gs;
  $BibText=~s/\, \~([0-9][0-9][0-9][0-9])/\, $1/gs;
  $BibText=~s/\,\~([0-9][0-9][0-9][0-9])/\, $1/gs;
  $BibText=~s/\, (vol|no)\.([0-9]+)\,/\, $1\. $2\,/gs;
  $BibText=~s/<\/bib>\n\n<bib([^<>]*)>/<\/bib>\n<bib$1>/gs;
  $BibText=~s/\\(refjt|refat|refct|refbt|refvol|refissue|refpg|reffn|refsn|refpname|refploc|refyr)<cur([0-9])>\\\1<cur([0-9])>((?:(?!<cur\3>)(?!<\/cur\3>).)*)<\/cur\3><\/cur\2>/\\$1<cur$3>$4<\/cur$3>/gs;
  $BibText=~s/ <cur2>\\(refjt|refat|refct|refbt|refvol|refissue|refpg|reffn|refsn|refpname|refploc|refyr)<i>/ \\$1<cur2><i>/gs;


  $BibText=~s/([\.\,\;\:\>]) <cur([0-9])>\\refct<cur([0-9])>((?:(?!<cur\3>)(?!<\/cur\3>).)*)<\/cur\3><\/cur\2>/$1 \\refct<cur$3>$4<\/cur$3>/gs;

#  print $BibText;exit;
    return $BibText;
  }
#=========================================================================================================================
# sub TeXPreProcess{
#   my $TextBody=shift;
#     my $TeXData=\$TextBody;
#     use TeX2XML::handleCurlyDoller;
#     $TeXData=&TeX2XML::handleCurlyDoller::matchCurly($TeXData); #in and out $TeXData refrence

#     use TeX2XML::Latex2Tag;
#     my $normalizeTags = TeX2XML::Latex2Tag->new(TeXData => $TeXData);
#     #    print $$TeXData;exit;
#     $TeXData=$normalizeTags->normalizeLatex2Tag();
#     my $TextBody=$$TeXData;
#     $TextBody=~s/<p>\\bibitem(.*?)<\/p>/<bib>$1<\/bib>/gs;
#     $TextBody=~s/<p><bib>(.*?)<\/p><\/bib>/<bib>$1<\/bib>/gs;

#     my $ID=1;
#     while($TextBody=~m/<bib>([\s]*)<cur1>([^<>]*?)<\/cur1>([\s]*)/g)
#     {
# 	my $RefLableID="CR"."$ID";
# 	my $RefLable=$2;
# 	$TextBody=~s/<bib>([\s]*)<cur1>([^<>]*?)<\/cur1>/<bib id=\"$RefLableID\">/os;
# 	$ID++;
#     }

#     my $ID=1;
#     while($TextBody=~m/<bib>([\s]*)\[(.*?)\]<cur([0-9]+)>((?:(?!<cur\3>)(?!<\/cur\3>).)*)<\/cur\3>([\s]*)/g){
#       my $RefLableID="CR"."$ID";
#       my $RefLable=$4;
#       $TextBody=~s/<bib>([\s]*)\[(.*?)\]<cur([0-9]+)>((?:(?!<cur\3>)(?!<\/cur\3>).)*)<\/cur\3>([\s]*)/<bib id=\"$RefLableID\">/os;
#       $ID++;
#     }
#     $TextBody=&ReferencesCleanup($TextBody);

#     return $TextBody;
# }



#==================================
return 1;

