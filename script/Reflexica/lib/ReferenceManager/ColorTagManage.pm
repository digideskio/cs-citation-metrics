#version 1.0.4
#Author: Neyaz Ahmad
package ReferenceManager::ColorTagManage;
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(htmlPreCleanup RefColorToTag RefTagToColor);

#=======================================================================================================================================
sub RefColorToTag
{
    my $Text = shift;

    $Text=&AuthorGroupBoundary($Text);
    my ($Colour2TagRef, $Tag2ColourRef)=&ColorAndTag;

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

    $Text=~s/<\/[0-9]+span/<\/span/gs;
    $Text=~s/<[0-9]+span/<span/gs;
    $Text=~s/<X[0-9]+span/<span/gs;
    $Text=~s/<Xspan/<span/gs;


    $Text=~s/<span([\s]*)style=\'border:([^\'<>]*?)padding:([0-9a-z]+)\'>(.*?)<\/span>/&lt;au&gt;$4&lt;\/au&gt;/gs;
    #<span style='border:dotted maroon 1.0pt;padding:0pt'>
    $Text=~s/<\/(aug|ia|edrg)>\&lt\;\/(auf|aus|eds|edm|suffix|par|prefix)\&gt\;\&lt\;\/(au|edr)\&gt\;/\&lt\;\/$2\&gt\;\&lt\;\/$3\&gt\;<\/$1>/gs;
   # print $Text;exit;

    while($Text =~ /<edrg>((?:(?!<[\/]?aug>)(?!<[\/]?edrg>)(?!<\/p>).)*?)<\/edrg>/s)
      {
	my $editorText=$1;
	$editorText=~s/\&lt\;([\/]?)au\&gt\;/\&lt\;$1edr\&gt\;/gs;
	$Text=~s/<edrg>((?:(?!<[\/]?aug>)(?!<[\/]?edrg>)(?!<\/p>).)*?)<\/edrg>/<edrgX>$editorText<\/edrgX>/s;
      }
    $Text=~s/<([\/]?)edrgX>/<$1edrg>/gs;
  
    # $Text=~s/\&lt\;au\&gt\;\&lt\;(edm|eds)\&gt\;/\&lt\;edr\&gt\;\&lt\;$1\&gt\;/gs;
    # $Text=~s/\&lt\;\/(eds|edm)\&gt\;\&lt\;\/au\&gt\;/\&lt\;\/$1\&gt\;\&lt\;\/edr\&gt\;/gs;
    $Text=~s/\&lt\;\/([a-z]+)\&gt\;\&lt\;\1\&gt\;//gs;

    $Text=~s/\&lt\;\/at\&gt\;<\/span>\&lt\;at\&gt\;(.*?)\&lt\;\/at\&gt\;/$1\&lt\;\/at\&gt\;<\/span>/gs;
    $Text=~s/<\/span><span lang=EN-US>//gs;
    $Text=~s/<\/(aug|edrg|ia)>\&lt\;\/(auf|aus|edm|eds)\&gt\;\&lt\;\/(au|edr)\&gt\;/\&lt\;\/$2\&gt\;\&lt\;\/$3\&gt\;<\/$1>/gs;
    return($Text);
}

#============================================================================================================================================


sub AuthorGroupBoundary
{
  my  $Text = shift;
  my  $Sequence=1;

  $Text=~s/<span([\s]*)style=\'border:([\s]*)dotted([\s]*)([a-zA-Z]+)([\s]*)1\.0pt\;([\s]*)padding:([\s]*)0pt\;([\s]*)background:\#([^\']*?)\'>([^<>]*?)<\/span>/<span style=\'border:dotted $4 1\.0pt\;padding:0pt\'><span style=\'background:\#$9\'>$10<\/span><\/span>/gs;
  $Text=~s/<span([\s]*)style='background:#[^']*?'>(\s+)<\/span>/$2/gs;
  $Text=~s/<span([\s]*)style=\'color\:\#FF6600\'>(.*?)<\/span>/$2/gs;

    while($Text=~/<span\s*([^<>]*?)>((?:(?!<span\s*([^<>]*?)>)(?!<\/span>).)*)<\/span>/s)
    {
	$Text=~s/<span\s*([^<>]*?)>((?:(?!<span\s*([^<>]*?)>)(?!<\/span>).)*)<\/span>/<${Sequence}span $1>$2<\/${Sequence}span>/gs;
	    $Sequence++;
    }
    return($Text);
}


#==============================================================================================================================
sub RefTagToColor
{
    my $Text = shift;

    $Text=~s/^\&lt\;html\&gt\;\n//g;
    $Text=~s/^\&lt\;body\&gt\;//g;
    $Text=~s/\n&lt;\/html&gt;$//g;
    $Text=~s/\n&lt;body&gt;$//g;
    $Text=~s/\n&lt;\/body&gt;$//g;
    $Text=~s/<title[^>]*?>.*?<\/title>//gs;

    $Text=&nbspInserting($Text);

    $Text=~s/&lt;(au|edr|aug|edrg|at|pt|cny|cty|pbl|pg|st|srt|v|yr|url|ia|misc1|issn|isbn|coden|doi|edn|collab|bt|proc|suffix|rpt|thesis|pat|org|eml|pco|pbo|rol|tel|fax)&gt;((<\/span>)*(<span[^>]*?>)*)/$2&lt;$1&gt;/gs;


    #----------------------------------------------------------------------- 
    my ($Colour2TagRef, $Tag2ColourRef)=&ColorAndTag;

    foreach my $Keys(keys(%$Tag2ColourRef))
    {
	$Text=~s/&lt;$Keys&gt;/<span style=\'background\:$$Tag2ColourRef{$Keys}\'>/gs;
	$Text=~s/&lt;\/$Keys&gt;/<\/span>/gs;
		#print "$Keys => $$Tag2ColourRef{$Keys}\n";
    }
    #----------------------------------------------------------------------- 


    $Text=~s/&lt;(p class=.*?)&gt;/<$1>/gs;
    $Text=~s/&lt;\/p&gt;/<\/p>/gs;
    $Text=~s/&lt;(span.*?)&gt;/<$1>/gs;
    $Text=~s/&lt;\/span&gt;/<\/span>/gs;
    $Text=~s/&lt;i&gt;/<i>/gs;
    $Text=~s/&lt;\/i&gt;/<\/i>/gs;
    $Text=~s/&lt;b&gt;/<b>/gs;
    $Text=~s/&lt;\/b&gt;/<\/b>/gs;

#check
    $Text=~s/&lt;pt&gt;//gs;
    $Text=~s/&lt;\/pt&gt;//gs;
    # $Text=~s/&lt;au&gt;//g;
    # $Text=~s/&lt;\/au&gt;//g;
    $Text=~s/&lt;aug&gt;/<aug>/g;
    $Text=~s/&lt;\/aug&gt;/<\/aug>/g;
    $Text=~s/&lt;edrg&gt;/<edrg>/g;
    $Text=~s/&lt;\/edrg&gt;/<\/edrg>/g;

    $Text=~s/&lt;au&gt;/<span style=\'border:dotted windowtext 1.0pt;padding:0pt\'>/g;
    $Text=~s/&lt;\/au&gt;/<\/span>/g;
    $Text=~s/&lt;edr&gt;/<span style=\'border:dotted maroon 1.0pt;padding:0pt\'>/g;
    $Text=~s/&lt;\/edr&gt;/<\/span>/g;

    $Text=~s/&lt;(b|i|u|sup|sub|sb|sp)&gt;/<$1>/gs;
    $Text=~s/&lt;\/(b|i|u|sup|sub|sb|sp)&gt;/<\/$1>/gs;

    $Text=~s/<number>/\&lt\;number\&gt\;/gs;
    $Text=~s/<\/number>/\&lt\;\/number\&gt\;/gs;

    ######
    #    $Text=&unicodentitiesconv($Text);
    #    print $Text; 
    if($ARGV[5] eq "A++"){
      use ReferenceManager::utfEntitiesConv;
      $Text=&ReferenceManager::utfEntitiesConv::unicodeEntitiesConv($Text, "NormalText", "HexaEntity");#unicode to texEntities
      $Text=&ReferenceManager::utfEntitiesConv::unicodeEntitiesConv($Text, "DecEntity", "HexaEntity");#unicode to texEntities
      $Text=~s/\&amp\;nbsp\;/\&\#x00A0\;/gs;
    }else
      {
      $Text=&ReferenceManager::utfEntitiesConv::unicodeEntitiesConv($Text, "NormalText", "DecEntity");#unicode to texEntities
      }

    ######
    if($ARGV[1]==5 || $ARGV[1]==6)
      {
	$Text=&LabelTypeGenerate($Text);
      }

    return($Text);
}

#======================================================================================================
sub ColorAndTag
{
    my $Colour2TagRef=();
    my $Tag2ColourRef=();
    my %Tag2Colour=();


    #####  '#00A5E0' => 'cny', OLD
    #####  '#C0FFC0' => 'cny', New

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


sub nbspInserting
{
    my $Text = shift;

    #<span style='background:#9999FF'>2.</span> Aufl.

    $Text=~s/\&lt\;(au|edr|aug|auf|aus|eds|edf|par|prefix|aum|edm|edrg|iss|at|pt|cny|cty|pbl|pg|st|srt|v|yr|url|ia|misc1|issn|isbn|coden|doi|edn|collab|bt|proc|suffix|rpt|thesis|pat|org|eml|pco|pbo|rol|tel|fax|comment)\&gt\;/<$1>/gs;
    $Text=~s/\&lt\;\/(au|edr|aug|auf|aus|eds|edf|par|prefix|aum|edm|edrg|iss|at|pt|cny|cty|pbl|pg|st|srt|v|yr|url|ia|misc1|issn|isbn|coden|doi|edn|collab|bt|proc|suffix|rpt|thesis|pat|org|eml|pco|pbo|rol|tel|fax|comment)\&gt\;/<\/$1>/gs;

    $Text=~s/<edn>([^<>]*?)<\/edn> ([Ee]dition|edn[\.]?|Aufl[\.]?|Bd[\.]?|Auflage)/<edn>$1<\/edn>\&amp\;nbsp\;$2/gs;
    $Text=~s/<edn>([^<>]*?)<\/edn> ([Ee]dition|edn[\.]?|Aufl[\.]?|Bd[\.]?|Auflage)<\/edng>/<edn>$1<\/edn>\&amp\;nbsp\;$2<\/edng>/gs;
    $Text=~s/<edn>([^<>]*?)<\/edn>([nr]d|th|st|\&lt\;sup\&gt\;[nr]d\&lt\;\/sup\&gt\;|\&lt\;sup\&gt\;th\&lt\;\/sup\&gt\;|\&lt\;sup\&gt\;st\&lt\;\/sup\&gt\;) ([Ee]dition|edn[\.]?|Aufl[\.]?|Bd[\.]?|Auflage)/<edn>$1<\/edn>$2\&amp\;nbsp\;$3/gs;

    $Text=~s/\b([p]+[\.]?|S[\.]?|Aufl[\.]?|Bd[\.]?) ([ivxIVX]+)([\-]+)([ivxIVX]+)/$1\&amp\;nbsp\;$2$3$4/gs;
    $Text=~s/\b([p]+[\.]?|S[\.]?|Aufl[\.]?|Bd[\.]?) ([ivxIVX]+)\b/$1\&amp\;nbsp\;$2/gs;
    $Text=~s/\b([p]+[\.]?|S[\.]?|Aufl[\.]?|Bd[\.]?) ([SRCA][0-9]+)([\-]+)([SRC][0-9]+)/$1\&amp\;nbsp\;$2$3$4/gs;
    $Text=~s/\b([p]+[\.]?|S[\.]?|Aufl[\.]?|Bd[\.]?) ([SRC][0-9]+)/ $1\&amp\;nbsp\;$2/gs;
    $Text=~s/\b([p]+[\.]?|S[\.]?|Aufl[\.]?|Bd[\.]?) ([SRC][0-9]+)([\-]+)([SRC][0-9]+)/$1\&amp\;nbsp\;$2$3$4/gs;
    $Text=~s/\b([p]+[\.]?|S[\.]?|Aufl[\.]?|Bd[\.]?) ([0-9]+[SRC])/$1\&amp\;nbsp\;$2/gs;
    $Text=~s/\b([p]+[\.]?|S[\.]?|Aufl[\.]?|Bd[\.]?) ([0-9\-]+)/$1\&amp\;nbsp\;$2/gs;

    $Text=~s/\b([p]+[\.]?|S[\.]?) <pg>/$1\&amp\;nbsp\;<pg>/gs;
    $Text=~s/<pgg>(pp|p|pp\.|p\.|S|S\.) <pg>/<pgg>$1\&amp\;nbsp\;<pg>/gs;
    $Text=~s/\b(Bd[\.]?|Aufl[\.]?) <edn>/$1\&amp\;nbsp\;<edn>/gs;
    $Text=~s/<edng>(Bd[\.]?|Aufl[\.]?) <edn>/<edng>$1\&amp\;nbsp\;<edn>/gs;
    $Text=~s/\b([vV]olume|[vV]ol[s]?[\.]?|Bd[\.]?) <v>/$1\&amp\;nbsp\;<v>/gs;
    $Text=~s/\b([vV]olume|[vV]ol[s]?[\.]?|Bd[\.]?) ([0-9\/\-ivxA-Z]+)</$1\&amp\;nbsp\;$2</gs;
    $Text=~s/\b([vV]olume|[vV]ol[s]?[\.]?|Bd[\.]?) ([0-9\/\-ivxA-Z]+)([\.\, ]+)/$1\&amp\;nbsp\;$2$3/gs;

    $Text=~s/\&nbsp\;/\&amp\;nbsp\;/gs;

    $Text=~s/<(au|edr|aug|auf|aus|eds|edf|par|prefix|aum|edm|edrg|iss|at|pt|cny|cty|pbl|pg|st|srt|v|yr|url|ia|misc1|issn|isbn|coden|doi|edn|collab|bt|proc|suffix|rpt|thesis|pat|org|eml|pco|pbo|rol|tel|fax|comment)>/&lt;$1&gt;/gs;
    $Text=~s/<\/(au|edr|aug|auf|aus|eds|edf|par|prefix|aum|edm|edrg|iss|at|pt|cny|cty|pbl|pg|st|srt|v|yr|url|ia|misc1|issn|isbn|coden|doi|edn|collab|bt|proc|suffix|rpt|thesis|pat|org|eml|pco|pbo|rol|tel|fax|comment)>/&lt;\/$1&gt;/gs;

return $Text;

}

#===========================================================================
sub htmlPreCleanup
{
    my $FileText=shift;
    my $Body="";

    $$FileText=~s/^\n+/\n/gs;
    $$FileText=~s/\n+$/\n/gs;
    $$FileText=~s/\&lt\;petemp\&gt\;\&lt\;petemp\&gt\;/\&lt\;petemp\&gt\;/gs;
    $$FileText=~s/\&lt\;\/petemp\&gt\;\&lt\;\/petemp\&gt\;/\&lt\;\/petemp\&gt\;/gs;
    $$FileText=~s/<p([\s]*)class\=Bibentry><span lang\=([A-Za-z\-]+)>\&lt\;petemp\&gt\;/<petemp><p class=Bibentry><span lang=EN-US>/gs;
    $$FileText=~s/<p([\s]*)class\=Bib_entry><span lang\=([A-Za-z\-]+)>\&lt\;petemp\&gt\;/<petemp><p class=Bib_entry><span lang=EN-US>/gs;
    $$FileText=~s/<p([^<>]*?)><span lang=([A-Za-z\-]+)>\&lt\;petemp\&gt\;\&lt\;petemp\&gt\;\&lt\;/<petemp><p class=Bib_entry><span lang=EN-US>/gs;
    $$FileText=~s/\&lt\;petemp\&gt\;/<petemp>/gs;
    $$FileText=~s/\&lt\;\/petemp\&gt\;/<\/petemp>/gs;
    $$FileText=~s/\&lt\;\/petemp\&gt\;<\/span>/<\/span><\/petemp>/gs;
    $$FileText=~s/<\/petemp><\/span>/<\/span><\/petemp>/gs;
    $$FileText=~s/<\/petemp><\/p>/<\/p><\/petemp>/gs;

    $$FileText=~s/<i><edrg>(In[\:\.]? |[Ii]n[\:\.] |In[\:]?)<\/i>/<edrg>$1/gs;
    $$FileText=~s/<edrg><i>(In[\:\.]? |[Ii]n[\:\.] |In[\:]?)<\/i>/<edrg>$1/gs;

    $$FileText=~s/<span\s([^<>]+?)><(vg|issg|pgg|edng|doig|yrg|atg|ptg|btg|stg|srtg|cnyg|pblg|misc1g|edrg|aug|urlg|collabg|rpt)>([^<>]+?)<\/span>/<$2><span $1>$3<\/span>/gs;
    $$FileText=~s/\&nbsp\;/ /gs;

    $$FileText=~s/<span\s([^<>]+?)>([^<>]+?)<\/(vg|issg|pgg|edng|doig|yrg|atg|ptg|btg|stg|srtg|cnyg|pblg|misc1g|edrg|aug|urlg|collabg|rpt)><\/span><\/span>/<span$1>$2<\/span><\/span><\/$3>/gs;

    # $$FileText=~s/<span\s*style=\'border:dotted\s*windowtext\s*1.0pt;\s?padding:0pt;\s*background:\s*#([A-Z0-9]+)\'>([^<>]+?)<\/span><span\s*style='border:dotted\s*windowtext\s?1.0pt;\s*padding:0pt\'>([\,\;\.\/ ]+)<span\s*style=\'background:\s*#([A-Z0-9]+)\'>([^<>]+?)<\/span><\/span>/<span style=\'border:dotted windowtext 1.0pt; padding:0pt\'><span style=\'background:#$1\'>$2<\/span>$3<span style='background:#$4'>$5<\/span><\/span>/gs;

    # $$FileText=~s/<span\s*style=\'border:dotted\s*windowtext\s1.0pt;\s*padding:0pt;\s*background:\s*#([A-Z0-9]+)\'>([^<>]+?)<\/span><span\s*style=\'border:dotted\s*windowtext\s1.0pt;\spadding:0pt\'>([\,\;\.\/ ]+)<span\s*style=\'background:\s*#([A-Z0-9]+)\'>([^<>]+?)<\/span>([\,\;\.\/ ]+)<span\s*style=\'background:\s*#([A-Z0-9]+)\'>([^<>]+?)<\/span><\/span>/<span style=\'border:dotted windowtext 1.0pt; padding:0pt><style=\'background:#$1\'>$2<\/span>$3<span style=\'background:#$4\'>$5<\/span>$6<span style=\'background:#$7\'>$8<\/span><\/span>/gs;


    $$FileText=~s/<span\s*style=\'border:dotted\s*([^<>]+?);\s*background:\s*#([A-Z0-9]+)\'>([^<>]+?)<\/span><span\s*style=\'border:dotted\s*([^<>]+?)padding:0pt\'>([\,\;\.\/ ]+)<span\s*style=\'background:\s*#([A-Z0-9]+)\'>([^<>]+?)<\/span>([\,\;\.\/ ]+)<span\s*style=\'background:\s*#([A-Z0-9]+)\'>([^<>]+?)<\/span><\/span>/<span style=\'border:dotted $1\'><span style=\'background:#$2\'>$3<\/span>$5<span style=\'background:#$6\'>$7<\/span>$8<span style=\'background:#$9\'>$10<\/span><\/span>/gs;
    $$FileText=~s/<span\s*style=\'border:dotted\s*([^<>]+?);\s*background:\s*#([A-Z0-9]+)\'>([^<>]+?)<\/span><span\s*style='border:dotted\s*([^<>]+?)padding:0pt\'>([\,\;\.\/ ]+)<span\s*style=\'background:\s*#([A-Z0-9]+)\'>([^<>]+?)<\/span><\/span>/<span style=\'border:dotted $1\'><span style=\'background:#$2\'>$3<\/span>$5<span style=\'background:#$6\'>$7<\/span><\/span>/gs;
    $$FileText=~s/padding:\s*0pt\'>/padding:0pt\'>/gs;


    if ($$FileText=~/<petemp>(.*?)<\/petemp>/s){
	$Body="$1";
    }elsif($$FileText=~/<body([^<>].*?)>(.*)<\/body>/s){
	$Body="$2";
    }else{
	$Body=$$FileText;
    }

    while($Body=~/<xspan([^<>].*?)>/s)
      {
	my  $spanbody=$1;
	$spanbody=~s/style=\'border\:dotted([^\'<>]*?)\;background\:\#([a-zA-Z0-9]+)\'/style=\'background\:\#$2\'/gs;
	$Body=~s/<xspan([^<>].*?)>/<span$spanbody>/os;
    }

    $Body=~s/<span class\=SpellE>([a-zA-Z0-9\"\'\=\-\_\&\;\,\:\/\.]*)<\/span>/$1/gs;
    $Body=~s/<\/span>([\,\;\,\'\"\?\!]+)([\s]+)<span/<\/span>$1 <span/gs;
    $Body=~s/<\/span>([\s]+)<span/<\/span> <span/gs;
    $Body=~s/\n([\n]+)/<LINEBRK>/gs;
    $Body=~s/\n/ /gs;
    $Body=~s/<\/p>([ ]+)<p>/<\/p>\n<p>/gs;
    $Body=~s/<\/p>([ ]+)<p ([^<>]*?)>/<\/p>\n<p $2>/gs;
    $Body=~s/<LINEBRK>/\n\n/gs;
    $Body=~s/\&lt\;UnStr\/\&gt\;//g;
    $Body=~s/\&lt\;UnStr\&gt\;//g;
    $Body=~s/\&lt\;\/UnStr\&gt\;//g;
    $Body=~s/<UnStr>//g;
    $Body=~s/<\/UnStr>//g;


    if ($$FileText=~/<petemp>(.*?)<\/petemp>/s){
    	$$FileText=~s/<petemp>(.*?)<\/petemp>/\&lt\;petemp\&gt\;$Body\&lt\;\/petemp&gt\;/os;

    }elsif($$FileText=~/<body([^<>].*?)>(.*)<\/body>/s){
    	$$FileText=~s/<body([^<>].*?)>(.*)<\/body>/<body$1>$Body<\/body>/os;
    }else{
    	$$FileText="$Body";
    }

    return $$FileText;
}
#======================================================================================================================================
sub unicodentitiesconv
    {
	my $TextBody=shift;
	my $SCRITPATH=$0;
	$SCRITPATH=~s/(.*)([\/\\])(.*?)\.(pl|exe)/$1/g;

	open(ENTITYIN, "<$SCRITPATH/entities.ini")||die("\n\n$SCRITPATH/entities.ini File cannot be opened\n\nPlease check the file...\n\n");
	my  $Entities=<ENTITYIN>;
	close(ENTITYIN);
	my %UnicodeEntites=();

	while($Entities=~/<Series>([0-9]+)<\/Series><NormalText>(.*?)<\/NormalText><Entity>(.*?)<\/Entity>/s)
	    {
		$Series=$1;
		$NormalText=$2;
		$Entity=$3;
		$UnicodeEntites{$Series}{$NormalText}="$Entity";
		$Entities=~s/<Series>([0-9]+)<\/Series><NormalText>(.*?)<\/NormalText><Entity>(.*?)<\/Entity>/<XSeries>$1<\/XSeries><XNormalText>$2<\/XNormalText><XEntity>$3<\/XEntity>/os;
	    }

	foreach my $Series (sort(keys(%UnicodeEntites)))
	    {
		my $SeriesUnicodeEntites=$UnicodeEntites{$Series};
		foreach my $UnicodeKey (keys(%$SeriesUnicodeEntites))
		{
		  #print "$UnicodeKey=> $$SeriesUnicodeEntites{$UnicodeKey}\n";
		  $TextBody=~s/$UnicodeKey/$$SeriesUnicodeEntites{$UnicodeKey}/gs;
		}
	      }

	return $TextBody;
    }
#=======================================================================================================================================
sub LabelTypeGenerate
    {
      my $Text=shift;

      use ReferenceManager::RefType;
      my $TypeText=&ReferenceManager::RefType::ReferenceType($Text);
      foreach my $Key (keys %$TypeText)
	{
	  $ReplaceTypeText=$$TypeText{$Key};
	  $SearchTypeText=$Key;
	  #print "$Key=>$$TypeText{$Key}\n";
	  $SearchTypeText=~s/</\&lt\;/gs;
	  $SearchTypeText=~s/>/\&gt\;/gs;
	  $SearchTypeText=~s/\"/&quot;/gs;
	  $ReplaceTypeText=~s/</\&lt\;/gs;
	  $ReplaceTypeText=~s/>/\&gt\;/gs;
	  $ReplaceTypeText=~s/\"/&quot;/gs;
	  #$$labelText{$Key};
	  $Text=~s/\Q$SearchTypeText\E/$ReplaceTypeText/gs;
	}

      if($Text!~/\&lt\;number\&gt\;/)
	{
	  use ReferenceManager::Label;
	  my $labelText=&ReferenceManager::Label::ReferenceLabel($Text);

	  foreach my $Key (keys %$labelText)
	    {
	      $ReplaceLable=$$labelText{$Key};
	      $SearchLabel=$Key;
	      #print "$Key=>$$labelText{$Key}\n";
	      $SearchLabel=~s/</\&lt\;/gs;
	      $SearchLabel=~s/>/\&gt\;/gs;
	      $SearchLabel=~s/\"/&quot;/gs;
	      $ReplaceLable=~s/</\&lt\;/gs;
	      $ReplaceLable=~s/>/\&gt\;/gs;
	      $ReplaceLable=~s/\"/&quot;/gs;
	      #$$labelText{$Key};
	      $Text=~s/\Q$SearchLabel\E/$ReplaceLable/gs;
	    }
	}

      return $Text;
    }

#============================================================

return 1;

