#version 1.0.4)
#Author: Neyaz Ahmad
package ReferenceManager::ElementReArrange;

use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(BibReArrange CleanupAfterReArrange);

use ReferenceManager::ReferenceRegex;
my %regx = ReferenceManager::ReferenceRegex::new();

###################################################################################################################################################
sub BibReArrange
{
    my $TempBibTexts="";
    $TempBibTexts=shift;

    $TempBibTexts=~s/<span([^<>]*?)>/\&lt\;span$1&gt;/gs;
    $TempBibTexts=~s/<\/span>/\&lt\;\/span\&gt\;/gs;

    my $TempBibTextsUnchange=$TempBibTexts;
    my %RefernceStyle=();


    while($TempBibTexts=~/<([a-zA-Z0-9\-]+)>([^<>]*?)<\/\1>/s)
    {
	my $tagKey=$1;
	my $tagText=$2;
                	                      #$tagText=~s/^<aus>(.*)<\/auf>/<aus>(.*)<\/auf>/gs;
	$RefernceStyle{$tagKey}=$tagText;
	$TempBibTexts=~s/<([a-zA-Z0-9\-]+)>([^<>]*?)<\/\1>//os;
    }

                                         #    print "**** ", %RefernceStyle, "\n";
    delete $RefernceStyle{""};
    my $BibIniStyle=&readINI;
    my $RefStruct="0";
    my @StylesArray=split(/\n/, $BibIniStyle);
#------------------------------------------------------
    foreach my $style (@StylesArray)
    {

	$style=~s/<i>/&lt;i&gt;/g;
	$style=~s/<\/i>/&lt;\/i&gt;/g;
	$style=~s/<b>/&lt;b&gt;/g;
	$style=~s/<\/b>/&lt;\/b&gt;/g;
	$style=~s/<u>/&lt;u&gt;/g;
	$style=~s/<\/u>/&lt;\/u&gt;/g;
	$style=~s/<sup>/&lt;sup&gt;/g;
	$style=~s/<\/sup>/&lt;\/sup&gt;/g;
	$style=~s/<sub>/&lt;sub&gt;/g;
	$style=~s/<\/sub>/&lt;\/sub&gt;/g;
	$style=~s/<sp>/&lt;sp&gt;/g;
	$style=~s/<\/sp>/&lt;\/sp&gt;/g;
	$style=~s/<sb>/&lt;sb&gt;/g;
	$style=~s/<\/sb>/&lt;\/sb&gt;/g;

	 my $StylesSequence=$style;

	 my %StylesHash=();
	 while($style=~/<([a-zA-Z0-9]+)>/)
	 {
	     my $stylekey=$1;
	     $StylesHash{$stylekey}="";
	     $style=~s/<([a-zA-Z0-9]+)>/\&lt\;$1\&gt\;/o;
	 }
	 my $IniStyle="";
	 foreach (sort keys(%StylesHash)){
	     $IniStyle="$IniStyle"."$_";
	 }

	 my $BibStyle="";
	 foreach (sort keys(%RefernceStyle)){
	     $BibStyle="$BibStyle"."$_";
	 }
	if ($IniStyle eq $BibStyle)
	{
	      $RefStruct="1";
	      while($StylesSequence=~/<([a-zA-Z0-9]+)>/)
	      {
		  my $styleseqkey=$1;
		  $RefernceStyle{$styleseqkey}=~s/\,$//gs;
		  $StylesSequence=~s/<([a-zA-Z0-9]+)>/\&lt\;$1\&gt\;$RefernceStyle{$styleseqkey}\&lt\;\/$1\&gt\;/o;
	      }

	      $TempBibTexts=~s/\&lt\;b\&gt\;\&lt\;\/b\&gt\;//gs;  #delete bold ital tag
	      $TempBibTexts=~s/\&lt\;b\&gt\;([\.\,\;\: ]+)\&lt\;\/b\&gt\;/$1 /gs;  #delete bold italic tag
	      $TempBibTexts=~s/\&lt\;i\&gt\;\&lt\;\/i\&gt\;//gs;  #delete bold ital tag
	      $TempBibTexts=~s/\&lt\;i\&gt\;([\.\,\;\: ]+)\&lt\;\/i\&gt\;/ /gs;  #delete bold italic tag
	      $TempBibTexts=~s/\&lt\;[\/]?i\&gt\;/ /gs;  #delete bold italic tag
	      $TempBibTexts=~s/<(b|i)><\/\1>//gs;  #delete bold italic tag
	      $TempBibTexts=~s/\&\#X([0-9]+)\;/<#X$1>/gs;  #delete punctutions
	      $TempBibTexts=~s/\&lt\;([\/]?)([a-z]+)\&gt\;/<$1$2>/gs;
	      $TempBibTexts=~s/\&lt\;span ([^<>\/]+?)\&gt\;/<span $1>/gs;
	      $TempBibTexts=~s/ ([Ii]n)([\.\:]+) //gs;  #delete In punctutions
	      $TempBibTexts=~s/([^a-zA-Z0-9]+?)([\.\,\:\(\)\[\]\; \/]+)/$1/gs;  #delete punctutions
	      $TempBibTexts=~s/(^|\n)([\.\,\:\(\)\[\]\; \/]+)/$1/gs;  #delete punctutions
	      $TempBibTexts=~s/(^|\n|<[^<>]+?>)([\.\,\:\(\)\[\]\; \/ ]+)$/$1/gs;  #delete punctutions
	      $TempBibTexts=~s/(^|\n)[  ]*(\&quot\;[ ]*\&quot\;|\&quot\;)([\s]*)$/$1/gs;  #delete punctutions
	      $TempBibTexts=~s/(^|\n|<[^<>]+?>)[ ]*(\&quot\;[ ]*\&quot\;|\&quot\;)([\s]*)$/$1/gs;  #delete punctutions
		  #commented by Biswajit
	      #$TempBibTexts=~s/([^a-zA-Z0-9]+?)([`\.\,\:\(\)\[\]\;‘„“\"“” \/\']+)/$1/gs;  #delete punctutions
	      #$TempBibTexts=~s/(^|\n)([`\.\,\:\(\)\[\]\;‘„“\"“” \/\']+)/$1/gs;  #delete punctutions
	      #$TempBibTexts=~s/(^|\n|<[^<>]+?>)([`‘\.\,\:\(\)\[\]\;„“\"“” \/\' ]+)$/$1/gs;  #delete punctutions
	      #$TempBibTexts=~s/(^|\n)[  ]*(\&quot\;[ ]*\&quot\;|\&quot\;)([\s]*)$/$1/gs;  #delete punctutions
	      #$TempBibTexts=~s/(^|\n|<[^<>]+?>)[ ]*(\&quot\;[ ]*\&quot\;|\&quot\;)([\s]*)$/$1/gs;  #delete punctutions

	      $TempBibTexts=~s/<#X([0-9]+)>/\&\#X$1\;/gs;  #delete punctutions
	      $TempBibTexts=~s/^([\s]*)//gs;
	      $TempBibTexts=~s/([\s]*)$//gs;
	      #$TempBibTexts=~s/^$regx{allLeftQuote}(.*?)$regx{allRightQuote}$/$1/gs;
	      $TempBibTexts=~s/^$regx{leftRightSingleQuote}$//gs;

	      if($TempBibTexts ne "")
	      {
		  $TempBibTexts="$StylesSequence"."\&lt\;NS\&gt\;$TempBibTexts\&lt\;\/NS\&gt\;"; 
	      }else
	      {
		  $TempBibTexts="$StylesSequence";
	      }
	      goto Endforeach;
	}

	my  $punctuation=$style;

    } #Foreach Loop End
  Endforeach:
#------------------------------------------------------    
    if ($RefStruct eq "0"){
	$TempBibTexts="$TempBibTextsUnchange";
      }

    $TempBibTexts=~s/\&lt\;span([^<>]*?)\&gt\;/<span$1>/gs;
    $TempBibTexts=~s/\&lt\;\/span\&gt\;/<\/span>/gs;

    

    return $TempBibTexts;
}
#==================================================================================================================================================

sub readINI
{
    undef $/;
    my $BibGetIniStyle="";
    my $SCRITPATH=$0;
    $SCRITPATH=~s/(.*)([\/\\])(.*?)\.(pl|exe)/$1/g;
    my $RefStyleName=$ARGV[2];
    my $RefStyleIniFile=$ARGV[3];

    open(BIBSTYLEIN, "<${SCRITPATH}/${RefStyleIniFile}")||die("\n\n${SCRITPATH}/${RefStyleIniFile} File cannot be opened\n\nPlease check the file...\n\n");
    my  $BibIniStyle=<BIBSTYLEIN>;
    close(BIBSTYLEIN);

    $BibIniStyle=~s/\n/<BRK>/g;
    $BibIniStyle=~s/(<BRK>)+/<BRK>/g;

    if ($BibIniStyle=~/Style\{$RefStyleName\}=>\[\[(.*?)\]\]/)
    {
	my $FindStyles=$1;
	$FindStyles=~s/^<BRK>//g;
	$FindStyles=~s/<BRK>$//g;
	$BibGetIniStyle=$FindStyles;
    }

    $BibGetIniStyle=~s/^<BRK>//g;
    $BibGetIniStyle=~s/<BRK>$//g;
    $BibGetIniStyle=~s/<BRK>/\n/g;
    $BibIniStyle=~s/<BRK>/\n/g;

    return $BibGetIniStyle;
}

#==================================================================================================================================

sub CleanupAfterReArrange
  {
    my $bibText=shift;

    use ReferenceManager::ReferenceRegex;
    my %regx = ReferenceManager::ReferenceRegex::new();


    my $tagGroup='(vg|issg|pgg|edng|doig|yrg|atg|ptg|btg|stg|srtg|cnyg|pblg|misc1g|edrg|aug|urlg|collabg|rptg)';
    $bibText=~s/\&lt\;aug\&gt\;\&lt\;edr\&gt\;((?:(?!\&lt\;[\/]?aug\&gt\;).)*)\&lt\;\/aug\&gt\;/\&lt\;edrg\&gt\;\&lt\;edr\&gt\;$1\&lt\;\/edrg\&gt\;/gs;
    $bibText=~s/\&lt\;${tagGroup}\&gt\;/<$1>/gs;
    $bibText=~s/\&lt\;\/${tagGroup}\&gt\;/<\/$1>/gs;
    #. &lt;comment&gt;(L. Solotarof, Trans.)&lt;/comment&gt;</btg>&lt;/i&gt;

    $bibText=~s/\(<cnyg>((?:(?!<[\/]?cnyg>).)*?) \&lt\;comment\&gt\;((?:(?!\&lt\;[\/]?comment\&gt\;).)*?)\&lt\;\/comment\&gt\;<\/cnyg>([\:\, ]+)<pblg>((?:(?!<[\/]?pblg>).)*?)<\/pblg>\)([\.\,\;\:])/\(<cnyg>$1<\/cnyg>$3 <pblg>$4<\/pblg>\)$5 &lt;comment&gt;$2&lt;\/comment&gt;/gs;
    $bibText=~s/<cnyg>((?:(?!<[\/]?cnyg>).)*?) \&lt\;comment\&gt\;((?:(?!\&lt\;[\/]?comment\&gt\;).)*?)\&lt\;\/comment\&gt\;<\/cnyg>([\:\, ]+)<pblg>((?:(?!<[\/]?pblg>).)*?)<\/pblg>([\.\,\;\:])/<cnyg>$1<\/cnyg>$3<pblg>$4<\/pblg>$5 &lt;comment&gt;$2&lt;\/comment&gt;/gs;

   $bibText=~s/\(<pblg>((?:(?!<[\/]?pblg>).)*?) \&lt\;comment\&gt\;((?:(?!\&lt\;[\/]?comment\&gt\;).)*?)\&lt\;\/comment\&gt\;<\/pblg>([\:\, ]+)<cnyg>((?:(?!<[\/]?cnyg>).)*?)<\/cnyg>\)([\.\,\;\:])/\(<pblg>$1<\/pblg>$3 <cnyg>$4<\/cnyg>\)$5 &lt;comment&gt;$2&lt;\/comment&gt;/gs;
    $bibText=~s/<pblg>((?:(?!<[\/]?pblg>).)*?) \&lt\;comment\&gt\;((?:(?!\&lt\;[\/]?comment\&gt\;).)*?)\&lt\;\/comment\&gt\;<\/pblg>([\:\, ]+)<cnyg>((?:(?!<[\/]?cnyg>).)*?)<\/cnyg>([\.\,\;\:])/<pblg>$1<\/pblg>$3<cnyg>$4<\/cnyg>$5 &lt;comment&gt;$2&lt;\/comment&gt;/gs;
    $bibText=~s/(\,\;\:)<\/(cnyg|pblg)>([\,\;\: ]+)/<\/$2>$3/gs;

    $bibText=~s/<\/(pblg|cnyg|pgg)>([\;\,\: ]+)\&lt\;comment\&gt\;((?:(?!\&lt\;[\/]?comment\&gt\;).)*?)\&lt\;\/comment\&gt\;([\.\,\;\: ]+)<yrg>([^<>]+?)<\/yrg>([\)\.]*)/<\/$1>$2<yrg>$5<\/yrg>$6 \&lt\;comment\&gt\;$3\&lt\;\/comment\&gt\;$4/gs;

    $bibText=~s/<\/(aug|edrg|ia)>([\,\;\:\.\(\)\[ ]+)<yrg>([^<>]+?) &lt;comment&gt;((?:(?!\&lt\;[\/]?comment\&gt\;).)*?)&lt;\/comment&gt;<\/yrg>(.*)$/<\/$1>$2<yrg>$3<\/yrg>$5 \&lt;comment\&gt\;$4\&lt\;\/comment\&gt\;/gs;


    $bibText=~s/(\&[a-z0-9]+\;)([\)\]\.\;\:\,\"\'\`\ ]+)&lt;comment&gt;((?:(?!\&lt\;[\/]?comment\&gt\;).)*?)&lt;\/comment\&gt\;<\/([a-z0-9]+g)>(&lt;\/i&gt;)/$1<\/$4>$5$2&lt;comment&gt;$3&lt;\/comment\&gt\;/gs;
    $bibText=~s/(\&[a-z0-9]+\;)([\)\]\.\;\:\,\"\'\`\ ]+)&lt;comment&gt;((?:(?!\&lt\;[\/]?comment\&gt\;).)*?)&lt;\/comment\&gt\;<\/([a-z0-9]+g)>([\)\]\.\;\:\,\"\'\`\ ]+)/$1<\/$4>$2&lt;comment&gt;$3&lt;\/comment\&gt\;$5/gs;

    $bibText=~s/\) &lt;comment&gt;((?:(?!\&lt\;[\/]?comment\&gt\;).)*?)&lt;\/comment\&gt\;\)/\) &lt;comment&gt;$1&lt;\/comment\&gt\;/gs;

    $bibText=~s/\s+$//gs;

    if($ARGV[2]=~/^(Basic|Chemistry|MPS|APS|Vancouver|APA|Chicago|ApaOrg)$/){
      $bibText=~s/\&lt\;[\/]?comment\&gt\;//gs;
      $bibText=~s/<[\/]?comment>//gs;
    }

    $bibText=~s/([\.\?\!])<\/${tagGroup}>([\.])/$1<\/$2>/gs;
    $bibText=~s/([\?\!])<\/${tagGroup}>([\.\;])/$1<\/$2>/gs;
    $bibText=~s/\,<\/${tagGroup}>([\,\;])/$2<\/$1>/gs;

    $bibText=~s/([\?\!])\&lt\;\/(at|pt|bt|misc1)\&gt\;<\/${tagGroup}>([\.\,\;])/$1\&lt\;\/$2\&gt\;<\/$3>/gs;
    $bibText=~s/([\.])\&lt\;\/(auf|aus)\&gt\;\&lt\;\/au\&gt\;<\/${tagGroup}>([\.\,\;])/$1\&lt\;\/$2\&gt\;\&lt\;\/au\&gt\;<\/$3>/gs;
    $bibText=~s/ ([Ii]n)<\/misc1g>([\.\:]*) ([Ii]n[\.\:]) /<\/misc1g> $3 /gs;  #In
    $bibText=~s/\b([Ii]n[\.\:]*) <edrg>([Ii]n[\.\:]) /$1 <edrg>/gs;
    $bibText=~s/\b([Ii]n[\.\:]*) <edrg>([Ii]n) /$1 <edrg>/gs;
    $bibText=~s/\b([Ii]n[\.\:]*) <edrg>\&lt\;i\&gt\;([Ii]n[\.\:]?)\&lt\;\/i\&gt\;([\.\:]?) /$1 <edrg>/gs;
    $bibText=~s/\b([Ii]n)([\.\:]*) <edrg>$regx{editorSuffix} ([^<>]*?)<\/edrg>([\,\.]*) &lt;i&gt;<btg>([Ii]n)([\.\:]*) /$1$2 <edrg>$4\, $3<\/edrg>$5 <btg>/gs;

    #In: <edrg>ed &lt;edr&gt;&lt;eds&gt;Atkinson&lt;/eds&gt; &lt;edm&gt;BG&lt;/edm&gt;&lt;/edr&gt;, and &lt;edr&gt;&lt;eds&gt;Walden&lt;/eds&gt;, &lt;edm&gt;D.B.&lt;/edm&gt;&lt;/edr&gt;</edrg> <btg>In:
    $bibText=~s/\b([Ii]n)([\.\:]*) <edrg>$regx{editorSuffix} ([^<>]*?)<\/edrg>([\,\.]*) &lt;i&gt;<btg>([Ii]n)([\.\:]*) /$1$2 <edrg>$4\, $3<\/edrg>$5 <btg>/gs;
    $bibText=~s/\b([Ii]n)([\.\:]*) <edrg>$regx{editorSuffix} ([^<>]*?)<\/edrg>([\,\.]*) <btg>([Ii]n)([\.\:]*) /$1$2 <edrg>$4\, $3<\/edrg>$5 <btg>/gs;
    $bibText=~s/\b([Ii]n)([\.\:]*) <edrg>([^<>]*?) $regx{editorSuffix}<\/edrg>([\,\.]*) <btg>([Ii]n)([\.\:]*)&lt;/$1$2 <edrg>$3 $4<\/edrg>$5 <btg>&lt;/gs;
    $bibText=~s/\b([Ii]n)([\.\:]*) <edrg>([^<>]*?) $regx{editorSuffix}<\/edrg>([\,\.]*) &lt;i&gt;<btg>([Ii]n)([\.\:]*)&lt;/$1$2 <edrg>$3 $4<\/edrg>$5 &lt;i&gt;<btg>&lt;/gs;
    $bibText=~s/\b([Ii]n[\:\.]?) \&lt\;i\&gt\;<btg>([^<>]*?)<\/btg>([\.\,\;]?)\&lt\;\/i\&gt\; <edrg>([Ii]n[\:\. ]*?)([^<>]*?)\b$regx{editorSuffix}<\/edrg> /\b$1 \&lt\;i\&gt\;$2<\/btg>$3\&lt\;\/i\&gt\; <edrg>$6 $5<\/edrg>/gs;


    # $bibText=~s/\b([Ii]n[\:\.]?) \&lt\;i\&gt\;<btg>([^<>]*?)<\/btg>([\.\,\;]?)\&lt\;\/i\&gt\; <edrg>([Ii]n[\:\.]?) /\b$1 \&lt\;i\&gt\;$2<\/btg>$3\&lt\;\/i\&gt\; <edrg>/gs;

    $bibText=~s/<\/ptg>([\.\, ]+)<vg>$regx{volumePrefix}([\.\: ]+)\&lt\;v\&gt\;/<\/ptg>$1<vg>\&lt\;v\&gt\;/gs;


    $bibText=~s/\.\&lt\;\/bt\&gt\;<\/btg>\&lt\;\/i\&gt\;\./\&lt\;\/bt\&gt\;<\/btg>\&lt\;\/i\&gt\;\./gs;
    $bibText=~s/\.\&lt\;\/pt\&gt\;<\/ptg>\&lt\;\/i\&gt\;\./\&lt\;\/pt\&gt\;<\/ptg>\&lt\;\/i\&gt\;\./gs;

    $bibText=~s/\.\&lt\;\/pt\&gt\;<\/ptg>\./\.\&lt\;\/pt\&gt\;<\/ptg>/gs;

    $bibText=~s/\.\&lt\;\/bt\&gt\;<\/btg>\./\&lt\;\/bt\&gt\;<\/btg>\./gs;

    $bibText=~s/\.\&lt\;\/at\&gt\;<\/atg>\./\&lt\;\/at\&gt\;<\/atg>\./gs;
    $bibText=~s/\.\&lt\;\/misc1\&gt\;<\/misc1g>\./\&lt\;\/misc1\&gt\;<\/misc1g>\./gs;
    $bibText=~s/(\?|\!)\&lt\;\/bt\&gt\;<\/btg>\&lt\;\/i\&gt\;\./$1\&lt\;\/bt\&gt\;<\/btg>\&lt\;\/i\&gt\;/gs;
    $bibText=~s/(\?|\!)\&lt\;\/bt\&at\;<\/atg>\&lt\;\/i\&gt\;\./$1\&lt\;\/at\&gt\;<\/atg>\&lt\;\/i\&gt\;/gs;
    $bibText=~s/(\?|\!)\&lt\;\/misc1\&at\;<\/misc1g>\&lt\;\/i\&gt\;\./$1\&lt\;\/misc1\&gt\;<\/misc1g>\&lt\;\/i\&gt\;/gs;
    $bibText=~s/\)<\/yrg>\)/<\/yrg>\)/gs;

    #<ia>in: Mansbridge, Jane, J. (Hg.)</ia>:
    $bibText=~s/(\s*)\($regx{editorSuffix}\)\&lt\;\/ia\&gt\;/\&lt\;\/ia\&gt\;$1\($2\)/gs;
    $bibText=~s/\b([Ii]n[\:\. ]+)\&lt\;ia\&gt\;([Ii]n[\:\. ]+)/$1 \&lt\;ia\&gt\;/gs;
    $bibText=~s/\&lt\;ia\&gt\;([Ii]n[\:\. ]+)/$1 \&lt\;ia\&gt\;/gs;
    $bibText=~s/(\s*)\($regx{editorSuffix}\)<\/ia>/<\/ia>$1\($2\)/gs;
    $bibText=~s/\b([Ii]n[\:\. ]+)<ia>([Ii]n[\:\. ]+)/$1<ia>/gs;
    $bibText=~s/<ia>([Ii]n[\:\. ]+)/$1<ia>/gs;
    $bibText=~s/\&lt\;ia\&gt\;([Ii]n[\:\. ]+)/$1 \&lt\;ia\&gt\;/gs;
    $bibText=~s/<edrg>$regx{editorSuffix} [iI]n[\:\.\,]? /<edrg>$1 /gs;
    $bibText=~s/\. $regx{editorSuffix}\&lt\;\/ia\&gt\;/\&lt\;\/ia\&gt\;\. $1/gs;

     if($ARGV[2] eq "APA" or $ARGV[2] eq "ApaOrg"){
       $bibText=~s/\(([eE]ditor[s]?[\.]?|[Ee]d[s]?[\.]?|[Hh]rsg[\.]?|[Hh]g[\.]?|red[\.]?)\)[\.]?<\/edrg> \(<yrg>/\($1\)<\/edrg>\. \(<yrg>/gs;
     }


     if($ARGV[2] eq "Vancouver"){
       $bibText=~s/<\/vg>\(<issg>([Ss]uppl[\.]?)[ ]?\&lt\;iss\&gt\;([0-9\-\/]+)\&lt\;\/iss&gt;<\/issg>\)/<\/vg> <issg>Suppl \&lt\;iss\&gt\;$2\&lt\;\/iss&gt;<\/issg>/gs;
       $bibText=~s/\([Ss]uppl[\.]?\)<\/edrg> \(<yrg>/\($1\)<\/edrg>\. \(<yrg>/gs;
     }


    return $bibText;
       }

return 1;

