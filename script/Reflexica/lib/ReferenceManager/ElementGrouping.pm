#version 1.0.4
#Author: Neyaz Ahmad
package ReferenceManager::ElementGrouping;
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(TagGruopings);

#=======================================================================================================================================
sub TagGruopings
{
    my $FileText=shift;
    my %regx = ReferenceManager::ReferenceRegex::new();

    # $FileText=~s/<[\/]?(vg|issg|pgg|edng|doig|yrg|atg|ptg|btg|cnyg|pblg|misc1g|urlg|collabg|rpt)>//gs;
    $FileText=~s/<\/at>([\.\;\:\?\! ]+)([SPp][\. ]+)<pg>(\d+[\–\-0-9]+)<\/pg>(\s*)([Ii]n[\:\. ]*?)<pt>((?:(?!<\/pt>)(?!<bib)(?!<\/bib>)(?!<pt>).)*)<\/pt>([\.\,\; ]+)([J]g[\.\,\; ]*?)<v>((?:(?!<\/v>)(?!<v>).)*)<\/v>([\.\,\; ]+)([Hh]eft[\.\,\; ]*?)<iss>/<\/at>$1<pg>$3<\/pg>$4<pt>$6<\/pt>$7<v>$9<\/v>$10<iss>/gs;

    $FileText=~s/\&lt\;(au|edr|aug|auf|aus|eds|edf|par|prefix|aum|edm|edrg|iss|at|pt|cny|cty|pbl|pg|st|srt|v|yr|url|ia|misc1|issn|isbn|coden|doi|edn|collab|bt|proc|suffix|rpt|thesis|pat|org|eml|pco|pbo|rol|tel|fax|number|comment)\&gt\;/<$1>/gs;
    $FileText=~s/\&lt\;\/(au|edr|aug|auf|aus|eds|edf|par|prefix|aum|edm|edrg|iss|at|pt|cny|cty|pbl|pg|st|srt|v|yr|url|ia|misc1|issn|isbn|coden|doi|edn|collab|bt|proc|suffix|rpt|thesis|pat|org|eml|pco|pbo|rol|tel|fax|number|comment)\&gt\;/<\/$1>/gs;

     while($FileText=~/<bib([^<>]*?)>(.*?)<\/bib>/s)
     {
	 my $bibtext=$2;
	 $bibtext=~s/<\/number><au>(.*)<\/au>/<\/number><aug><au>$1<\/au><\/aug>/os;
	 $bibtext=~s/<\/number><edr>(.*)<\/edr>/<\/number><edrg><edr>$1<\/edr><\/edrg>/os;
	 $bibtext=~s/^<au>(.*)<\/au>/<aug><au>$1<\/au><\/aug>/os;
	 $bibtext=~s/^<edr>(.*)<\/edr>/<edrg><edr>$1<\/edr><\/edrg>/os;
	 $bibtext=~s/<edrg><edrg>/<edrg>/os;
	 $bibtext=~s/<\/edrg><\/edrg>/<edrg>/os;
	 $FileText=~s/<bib([^<>]*?)>(.*?)<\/bib>/<Xbib$1>${bibtext}<\/Xbib>/os;
     }
    $FileText=~s/<Xbib/<bib/gs;
    $FileText=~s/<\/Xbib>/<\/bib>/gs;

    $FileText=~s/<au><au>/<au>/gs;
    $FileText=~s/<edr><edr>/<edr>/gs;
    $FileText=~s/<\/au><\/au>/<\/au>/gs;
    $FileText=~s/<\/edr><\/edr>/<\/edr>/gs;
    $FileText=~s/<doi>doi:$regx{doi}<\/doi>/doi:<doi>$1<\/doi>/gs;

    #-----------------move text inside Author and editors groups
    $FileText=~s/<\/aug>([\., ]*)<par>([^\&\;\/]*?)<\/par>/$1<par>$2<\/par><\/aug>/gs;
    $FileText=~s/<\/aug>([\., ]*)<suffix>([^\&\;\/]*?)<\/suffix>/$1<suffix>$2<\/suffix><\/aug>/gs;
    $FileText=~s/<\/aug>([\., ]*)<prefix>([^\&\;\/]*?)<\/prefix>/$1<prefix>$2<\/prefix><\/aug>/gs;
    $FileText=~s/<\/edrg>([\., ]*)<par>([^\&\;\/]*?)<\/par>/$1<par>$2<\/par><\/edrg>/gs;
    $FileText=~s/<\/edrg>([\., ]*)<suffix>([^\&\;\/]*?)<\/suffix>/$1<suffix>$2<\/suffix><\/edrg>/gs;
    $FileText=~s/<\/edrg>([\., ]*)<prefix>([^\&\;\/]*?)<\/prefix>/$1<prefix>$2<\/prefix><\/edrg>/gs;

    #************move eds
    $FileText=~s/\b([Ii]n[\:]?)(\s*)<bt>([^<>]*?)<\/bt>([\,\. ]*?)$regx{editorSuffix} <edrg>((?:(?!<edrg>)(?!<\/edrg>).)*)<\/edrg>([\.\,]?)/$2<bt>$3<\/bt>$4$1 <edrg>$6$7 $5<\/edrg>/gs;
    $FileText=~s/\b([Ii]n[\:]?)(\s*)<bt>([^<>]*?)<\/bt>([\,\. ]*?)\($regx{editorSuffix}\)([\.]?) <edrg>((?:(?!<edrg>)(?!<\/edrg>).)*)<\/edrg>([\.\,]?)/$2<bt>$3<\/bt>$4$1 <edrg>$7$8 \($5\)$6<\/edrg>/gs;
    $FileText=~s/\b([Ii]n[\:]?)(\s*)<bt>([^<>]*?)<\/bt>([\,\. ]*?)\[$regx{editorSuffix}\]([\.]?) <edrg>((?:(?!<edrg>)(?!<\/edrg>).)*)<\/edrg>([\.\,]?)/$2<bt>$3<\/bt>$4$1 <edrg>$7$8 \[$5\]$6<\/edrg>/gs;

 
    $FileText=~s/<\/aug>([\;\., ]*)(u\. a\.|v\. d\.|et al[\.]?|\(Hg[\.]?\)|\([Hrsg[\.]?\)|\([Hrg[\.]?\)|\([eE]d[s]?[\.]?\)|\&hellip\;)/$1$2<\/aug>/gs;
    $FileText=~s/<\/edrg>([\;\., ]*)(u\. a\.|v\. d\.|et al[\.]?|\(Hg[\.]?\)|\(Hrsg[\.]?\)|\([Hrg[\.]?\)|\(eds[\.]?\))/$1$2<\/edrg>/gs;
    $FileText=~s/<\/edrg> (et al[\.]?|et al\.\,) ([eE]ditor[s]?|[Ee]ds[\.]?|Hrsg|Hrg|Hg|\(Hg[\.]?\)|\(Hrsg[\.]?\)|\([Hrg[\.]?\)|\(eds[\.]?\))/ $1 $2<\/edrg>/gs;
    $FileText=~s/<\/aug> (et al[\.]?|et al\.\,) ([eE]ditor[s]?|[Ee]ds[\.]?|Hrsg|Hrg|Hg|\(Hg[\.]?\)|\(Hrsg[\.]?\)|\([Hrg[\.]?\)|\(eds[\.]?\))/ $1 $2<\/aug>/gs;
    $FileText=~s/<\/aug>([\,\; ]*)(et al[\.]?|u\. a\.|v\. d\.)/$1$2<\/aug>/gs;
    $FileText=~s/<\/edrg>([\,\; ]*)(et al[\.]?|u\. a\.|v\. d\.)/$1$2<\/edrg>/gs;
    $FileText=~s/<\/edrg>([\.\, ]*)(et al[\.]?) $regx{editorSuffix}/$1$2 $3<\/edrg>/gs;
    $FileText=~s/<\/aug>([\.\, ]*)(et al[\.]?) ([\(\[])$regx{editorSuffix}([\)\]])/$1 $2 $3$4$5<\/aug>/gs;
    $FileText=~s/<\/edrg>([\.\, ]*)([\(\[])$regx{editorSuffix}([\)\]])/$1 $2$3$4<\/edrg>/gs;
    $FileText=~s/<\/edrg>([\.\, ]*)$regx{editorSuffix}/$1 $2<\/edrg>/gs;
    $FileText=~s/<\/aug>([\.\, ]*)\($regx{editorSuffix}\)/$1 \($2\)<\/aug>/gs;
    $FileText=~s/<\/aug>([\.\, ]*)$regx{editorSuffix}/$1 $2<\/aug>/gs;
    $FileText=~s/<\/edrg>([ ]+)\($regx{editorSuffix}\)<\/edrg>/ \($2\)<\/edrg>/gs;
    $FileText=~s/<\/edrg>([\.\, ]* et al[\.\, ]*)\($regx{editorSuffix}\)<\/edrg>/$1\($2\)<\/edrg>/gs;
    $FileText=~s/<\/edrg>([\.\, ]* et al[\.\, ]*)$regx{editorSuffix}<\/edrg>/$1\($2\)<\/edrg>/gs;
    $FileText=~s/<\/edrg>([ ]+)$regx{editorSuffix}<\/edrg>/ \($2\)<\/edrg>/gs;
    $FileText=~s/<\/edrg><\/edrg>/<\/edrg>/gs;
    $FileText=~s/<edrg><edrg>/<edrg>/gs;
    $FileText=~s/([>\.\, ]+)$regx{editorSuffix} <edrg>/$1<edrg>$2 /gs;
#-----------------------------------------------------------------------------------------------------------------------------------------
    $FileText=~s/\&lt\;\/(sub|sup|i|u|b)\&gt<\/([a-z1]+)>\;/\&lt\;\/$1\&gt\;<\/$2>/gs;


    $FileText=~s/<aug>((?:(?!<aug>)(?!<\/aug>).)*)<\/aug>([^<>]*?)([\.\,\;\: ]+)\(<yr>/<aug>$1$2<\/aug>$3\(<yr>/gs;
    $FileText=~s/<aug>((?:(?!<aug>)(?!<\/aug>).)*)<\/aug>([^<>]*?)([\.\,\;\: ]+)<yr>/<aug>$1$2<\/aug>$3<yr>/gs;

    $FileText=~s/<aug>((?:(?!<aug>)(?!<\/aug>).)*) et al([^<>]*?)<\/aug>([\.\,\;\: ]+)<yr>/<aug>$1 et al<\/aug>$2$3<yr>/gs;
    $FileText=~s/<aug>((?:(?!<aug>)(?!<\/aug>).)*)<\/au>\. ([a-zA-Z]+[^<>]*?)<\/aug>([\.\,\;\: ]+)<yr>/<aug>$1<\/au><\/aug>\. $2$3<yr>/gs;
    $FileText=~s/<aug>((?:(?!<aug>)(?!<\/aug>).)*)<\/aug>([^<>\(\)0-9]*?)\($regx{editorSuffix}\)/<aug>$1$2\($3\)<\/aug>/gs;

    $FileText=~s/<aug>((?:(?!<aug>)(?!<\/aug>).)*)<\/aug>([^<>\(\)0-9]*?)\b$regx{editorSuffix}\b/<aug>$1$2$3<\/aug>/gs;

    $FileText=~s/\(([A-Za-z\.]+)<\/aug> <yr>/<\/aug>\($1 <yr>/gs;

    $FileText=~s/<edrg>((?:(?!<edrg>)(?!<\/edrg>).)*)<\/edrg>([^<>0-9\(\)]*?)([\[\(])$regx{editorSuffix}([\)\]])/<edrg>$1$2$3$4$5<\/edrg>/gs;
    $FileText=~s/<edrg>((?:(?!<edrg>)(?!<\/edrg>).)*)<\/edrg>([^<>0-9\(\)]*?)\b$regx{editorSuffix}\b/<edrg>$1$2$3<\/edrg>/gs;

    $FileText=~s/([> ]+)([\.\,\;\: ]+)([^<>]*?[^\.\,\;\:\(]) <edrg>((?:(?!<edrg>)(?!<\/edrg>).)*)<\/edrg>/$1$2<edrg>$3 $4<\/edrg>/gs;
    $FileText=~s/>([\)]+)([\.\,\;\: ]+)([^<>]*?) <edrg>((?:(?!<edrg>)(?!<\/edrg>).)*)<\/edrg>/>$1$2<edrg>$3 $4<\/edrg>/gs;
    $FileText=~s/<edrg>((?:(?!<edrg>)(?!<\/edrg>).)*)<\/edrg>([^\.\,\;\:\)][^<>]*?)([\.\,\;\:])([ <])/<edrg>$1$2<\/edrg>$3$4/gs;
    $FileText=~s/([\.\, ]+)$regx{editorSuffix}([\:\., ]+)<edrg>/$1<edrg>$2$3/gs;
    $FileText=~s/\($regx{editorSuffix}([\.\:] +)<edrg>/\(<edrg>$1$2/gs;

    #--------------groupings -----------------------------
    #First Preference
    $FileText=~s/(e|S|R)<pg>((?:(?!<pg>)(?!<\/pg>).)*)<\/pg>/<pgg>$1&lt;pg&gt;$2&lt;\/pg&gt;<\/pgg>/gs;
    $FileText=~s/\(([A-Za-z\.\, ]+)<pg>((?:(?!<pg>)(?!<\/pg>).)*)<\/pg>\)/\(<pgg>$1&lt;pg&gt;$2&lt;\/pg&gt;<\/pgg>\)/gs;
    $FileText=~s/\b([p]+[\.]?|S[\.]?)([ ]*)<pg>([0-9A-Za-z\-–â€“\/]+)<\/pg>/<pgg>$1$2&lt;pg&gt;$3&lt;\/pg&gt;<\/pgg>/gs;
    $FileText=~s/\(<edn>([0-9A-Za-z\-\/]+)<\/edn>([\. ]*)$regx{ednPrifix}\.\)/\(<edng>&lt;edn&gt;$1&lt;\/edn&gt;$2$3\.<\/edng>\)/gs;

    $FileText=~s/\(<edn>([0-9A-Za-z\-\/]+)<\/edn>([nr]d|th|st|\&lt\;sup\&gt\;[nr]d\&lt\;\/sup\&gt\;|\&lt\;sup\&gt\;th\&lt\;\/sup\&gt\;|\&lt\;sup\&gt\;st\&lt\;\/sup\&gt\;)([\, ]*)$regx{ednPrifix}\.\)/\(<edng>&lt;edn&gt;$1&lt;\/edn&gt;$2$3$4\.<\/edng>\)/gs;
    $FileText=~s/<edn>([0-9A-Za-z\-\/]+)<\/edn>([nr]d|th|st|\&lt\;sup\&gt\;[nr]d\&lt\;\/sup\&gt\;|\&lt\;sup\&gt\;th\&lt\;\/sup\&gt\;|\&lt\;sup\&gt\;st\&lt\;\/sup\&gt\;)([\, ]*)$regx{ednPrifix}\b/<edng>&lt;edn&gt;$1&lt;\/edn&gt;$2$3$4<\/edng>/gs;
    $FileText=~s/<edn>([0-9A-Za-z\-\/]+)<\/edn>([\. ]*)$regx{ednPrifix}\b/<edng>&lt;edn&gt;$1&lt;\/edn&gt;$2$3<\/edng>/gs;
    $FileText=~s/\b$regx{ednPrifix}([ ]*)<edn>([0-9A-Za-z\-\/]+)<\/edn>/<edng>$1$2&lt;edn&gt;$3&lt;\/edn&gt;<\/edng>/gs;
    $FileText=~s/\b([dD][oO][iI][\.\:]*?)([ ]*)<doi>$regx{doi}<\/doi>/<doig>$1$2&lt;doi&gt;$3&lt;\/doi&gt;<\/doig>/gs;


    $FileText=~s/( |\()\b$regx{volumePrefix}\. $regx{pagePrefix}\. <v>([^<>]+?)<\/v>([\.\,]) <pg>([^<>]+?)<\/pg>/$1$2\. <v>$4<\/v>$5 $3\. <pg>$6<\/pg>/gs;

    #####************vols volume merge
  # $FileText=~s/<bt>((?:(?!<bt>)(?!<\/bt>).)*)<\/bt>([\.\,\; ]+)$regx{volumePrefix}([ ]*)<v>([0-9A-Za-z\-–â€“\/]+)<\/v>([\.\, ]+)<pbl>/<btg>&lt;bt&gt;$1&lt;\/bt&gt;$2$3$4$5<\/btg>$6<pbl>/gs;
   # $FileText=~s/<bt>((?:(?!<bt>)(?!<\/bt>).)*)<\/bt>([\,\.\;\: ]+)$regx{volumePrefix} ([0-9\/A-Z]+)([\.\, ]+)/<btg>&lt;bt&gt;$1&lt;\/bt&gt;$2$3 $4<\/btg>$5/gs;

    $FileText=~s/\b$regx{volumePrefix}([ ]*)<v>([0-9A-Za-z\-–â€“\/]+)<\/v>([^\.\,\;\:<>]*?)([\,\.\;])/<vg>$1$2&lt;v&gt;$3&lt;\/v&gt;$4<\/vg>$5/gs;

    $FileText=~s/\b$regx{volumePrefix}([ ]*)<v>([0-9A-Za-z\-–â€“\/]+)<\/v>/<vg>$1$2&lt;v&gt;$3&lt;\/v&gt;<\/vg>/gs;
    $FileText=~s/\(<yr>((?:(?!<yr>)(?!<\/yr>).)*)<\/yr>\, ([A-Za-z ]+)\)/\(<yrg>&lt;yr&gt;$1&lt;\/yr&gt;\, $2<\/yrg>\)/gs;
    $FileText=~s/<yr>((?:(?!<yr>)(?!<\/yr>).)*)<\/yr> ([A-Za-z ]+)\;</<yrg>&lt;yr&gt;$1&lt;\/yr&gt; $2<\/yrg>\;</gs;
    $FileText=~s/\(([A-Za-z\.\, ]+)<iss>((?:(?!<iss>)(?!<\/iss>).)*)<\/iss>\)/\(<issg>$1&lt;iss&gt;$2&lt;\/iss&gt;<\/issg>\)/gs;

#------------------------------------------------------------
    #Publisher Location <yr> groupings

    #, Feb. <yr>2012
    $FileText=~s/([\.\,\; ]+)$regx{monthPrefix}$regx{puncSpace}<yr>$regx{year}<\/yr>/$1<yrg>$2$3&lt;yr&gt;$4&lt;\/yr&gt;<\/yrg>/gs;
    $FileText=~s/\(<yr>([^<>]*?)<\/yr>([\,\.]?) $regx{dateDay}([\,\.]?) $regx{monthPrefix}\)/\(<yrg>&lt;yr&gt;$1&lt;\/yr&gt;$2 $3$4 $5<\/yrg>\)/gs;
    $FileText=~s/\(<yr>([^<>]*?)<\/yr>([\,\.]?) $regx{monthPrefix}([\,\.]?) $regx{dateDay}\)/\(<yrg>&lt;yr&gt;$1&lt;\/yr&gt;$2 $3$4 $5<\/yrg>\)/gs;

    $FileText=~s/([\.\,\; ]+)\(([A-Za-z\d\.\, ]+)<\/(aug|ia)>([\.\,\; ]+)<yr>([\d\-a-z]+)<\/yr>\)/<\/$3>$1\($2$4<yr>$5<\/yr>\)/gs;
    $FileText=~s/([\.\,\; ]+)<\/(aug|ia)>/<\/$2>$1/gs;
    $FileText=~s/\(([A-Za-z\d\.\, ]+)([\.\,\; ]+)<yr>([\d\-a-z]+)<\/yr>\)/\(<yrg>$1$2&lt;yr&gt;$3&lt;\/yr&gt;<\/yrg>\)/gs;

    $FileText=~s/<yr>((?:(?!<yr>)(?!<\/yr>).)*)<\/yr>([^\.\,\;\:\)][^<>]*?)([\.\,\;\:])([ <])/<yrg>&lt;yr&gt;$1&lt;\/yr&gt;$2<\/yrg>$3$4/gs;
    $FileText=~s/([> ]+)([\.\,\;\: ]+)([^<>]*?[^\.\,\;\:\(]) <yr>((?:(?!<yr>)(?!<\/yr>).)*)<\/yr>/$1$2<yrg>$3 &lt;yr&gt;$4&lt;\/yr&gt;<\/yrg>/gs;
    $FileText=~s/>([\)]+)([\.\,\;\: ]+)([^<>]*?) <yr>((?:(?!<yr>)(?!<\/yr>).)*)<\/yr>/>$1$2<yrg>$3 &lt;yr&gt;$4&lt;\/yr&gt;<\/yrg>/gs;
    $FileText=~s/<yr>([\(\)0-9A-Za-z\-–â€“\/]+)<\/yr>/<yrg>&lt;yr&gt;$1&lt;\/yr&gt;<\/yrg>/gs;
    $FileText=~s/<yrg>((?:(?!<yrg>)(?!<\/yrg>).)*)<\/yrg>([^<>]*?)<\/bib>/<yrg>$1$2<\/yrg><\/bib>/gs;
    $FileText=~s/<yrg>\(/\(<yrg>/gs;
    $FileText=~s/\(<yrg>\&lt\;yr\&gt\;([\(\)0-9A-Za-z\-–â€“\/]+)\&lt\;\/yr\&gt\;\)((?:(?!<[\/]?yrg>).)*?)<\/yrg>/\(<yrg>\&lt\;yr\&gt\;$1\&lt\;\/yr\&gt\;<\/yrg>\)$2/gs;
    $FileText=~s/\(<yrg>\&lt\;yr\&gt\;([\(\)0-9A-Za-z\-–â€“\/]+)\&lt\;\/yr\&gt\;<\/yrg>\, ([A-Z][a-z\.]+) ([0-9\.]+)\)/\(<yrg>\&lt\;yr\&gt\;$1\&lt\;\/yr\&gt\;\, $2 $3<\/yrg>\)/gs;
    $FileText=~s/\(<yrg>\&lt\;yr\&gt\;([\(\)0-9A-Za-z\-–â€“\/]+)\&lt\;\/yr\&gt\;<\/yrg>\, ([A-Z][a-z\.]+|[A-Z][a-z\.]+\/[A-Z][a-z\.]+)\)/\(<yrg>\&lt\;yr\&gt\;$1\&lt\;\/yr\&gt\;\, $2<\/yrg>\)/gs;
    #</yrg>. Apr;<v>
    $FileText=~s/\&lt\;\/yr\&gt\;<\/yrg>([\. ]+)$regx{monthPrefix}([\; ]+)<([\/]?[a-z]+)>/\&lt\;\/yr\&gt\;$1$2<\/yrg>$3<$4>/gs;
    $FileText=~s/([\.\:\,] )([\[\(]\d\d\d\d[\]\)])<\/aug> <yrg>\&lt\;yr\&gt\;/<\/aug>$1<yrg>$2\&lt\;yr\&gt\;/gs;


    #Journal title <at> groupings  *******This program based on structrung pattern ini
    $FileText=~s/<at>((?:(?!<at>)(?!<\/at>).)*)<\/at>([^\.\,\;\:\)][^<>]*?)([\.\,\;\:‘”“\'])([ <])/<atg>&lt;at&gt;$1&lt;\/at&gt;$2<\/atg>$3$4/gs;
    $FileText=~s/([> ]+)([\.\,\;\: ]+)([^<>]*?[^\.\,\;\:“\'\`\(]) <at>((?:(?!<at>)(?!<\/at>).)*)<\/at>/$1$2<atg>$3 &lt;at&gt;$4&lt;\/at&gt;<\/atg>/gs;
    $FileText=~s/>([\)]+)([\.\,\;\:“\'\`„‚ ]+)([^<>]*?) <at>((?:(?!<at>)(?!<\/at>).)*)<\/at>/>$1$2<atg>$3 &lt;at&gt;$4&lt;\/at&gt;<\/atg>/gs;
    $FileText=~s/>([\.\,\;\:“\'\`„‚ ]+)([^<>]*?)<at>((?:(?!<at>)(?!<\/at>).)*)<\/at>/>$1<atg>$2&lt;at&gt;$3&lt;\/at&gt;<\/atg>/gs;
    $FileText=~s/<at>((?:(?!<at>)(?!<\/at>).)*)<\/at>/<atg>&lt;at&gt;$1&lt;\/at&gt;<\/atg>/gs;
    $FileText=~s/([\.\,\?]) \[([Ii]n [Cc]hinese[\.]?|[Aa]uf [Cc]hinesisch[\.]?)\]\&lt\;\/at\&gt\;<\/atg>/$1\&lt\;\/at\&gt\; \[$2\]<\/atg>/gs;
    $FileText=~s/([\.\,\?]) \(([Ii]n [Cc]hinese[\.]?|[Aa]uf [Cc]hinesisch[\.]?)\)\&lt\;\/at\&gt\;<\/atg>/$1\&lt\;\/at\&gt\; \($2\)<\/atg>/gs;
    $FileText=~s/([\.\,]) (http|ftp|www)([^<> ]+?)\&lt\;\/at\&gt\;<\/atg>/\&lt\;\/at\&gt\;$1 $2$3<\/atg>/gs;
    $FileText=~s/([\.\,]) (http|ftp|www)([^<> ]+?)<\/at><\/atg>/<\/at>$1 $2$3<\/atg>/gs;

    $FileText=~s/<atg>\&quot\;[\s]?\&lt\;at\&gt\;((?:(?!<[\/]?atg>).)*)\&lt\;\/at\&gt\;<\/atg>([\.\,]?)\&quot\;/<atg>\&quot\;\&lt\;at\&gt\;$1\&lt\;\/at\&gt\;$2\&quot\;<\/atg>/gs;
    $FileText=~s/<atg>"\&lt\;at\&gt\;((?:(?!<[\/]?atg>).)*)\&lt\;\/at\&gt\;<\/atg>([\.\,]?)"/<atg>"\&lt\;at\&gt\;$1\&lt\;\/at\&gt\;$2"<\/atg>/gs;


    $FileText=~s/<ia>((?:(?!<[\/]?ia>).)*)<\/ia>([^<>]*?)([\.\,\;\: \(]+)<yrg>([^<>]+?)<\/yrg>$regx{optionaEndPunc}<\/bib>/<iax>$1<\/iax>$2$3<yrg>$4<\/yrg>$5<\/bib>/gs; #change <iax> to <ia>
    $FileText=~s/<ia>((?:(?!<[\/]?ia>).)*)<\/ia>([^<>]*?)([\.\,\;\: \(]+)<([a-z0-9]+)>/<ia>$1$2<\/ia>$3<$4>/gs;
    #<ia>Wendt, G. Gerhard</ia>, Hrsg. (<yr>
    #<bib id="bib8"><ia>Eunomia (Hg.): Have We Got the Bottle? Implementing a Deposit Refund Scheme in the UK</ia>, <yrg>&lt;yr&gt;2010&lt;/yr&gt;.</yrg></bib>
    $FileText=~s/<bib([^<>]*?)><ia>([^<>]+?) ([\(]?)$regx{editorSuffix}([\)\:]+?) ([^<>]+?)<\/ia>$regx{puncSpace}<yrg>([^<>]+?)<\/yrg>$regx{optionaEndPunc}<\/bib>/<bib$1><ia>$2<\/ia> $3$4$5 $6$7<yrg>$8<\/yrg>$9<\/bib>/gs;
    $FileText=~s/<([\/]?)iax>/<$1ia>/gs;
    #Journal title <pt> groupings This program based on structrung pattern ini


    $FileText=~s/<pt>((?:(?!<pt>)(?!<\/pt>).)*)<\/pt>([^\.\,\;\:\)][^<>]*?)([\.\,\;\:])([ <])/<ptg>&lt;pt&gt;$1&lt;\/pt&gt;$2<\/ptg>$3$4/gs;
    $FileText=~s/([> ]+)([\.\,\;\: ]+)([^<>]*?[^\.\,\;\:\(]) <pt>((?:(?!<pt>)(?!<\/pt>).)*)<\/pt>/$1$2<ptg>$3 &lt;pt&gt;$4&lt;\/pt&gt;<\/ptg>/gs;
    $FileText=~s/>([\)]+)([\.\,\;\: ]+)([^<>]*?) <pt>((?:(?!<pt>)(?!<\/pt>).)*)<\/pt>/>$1$2<ptg>$3 &lt;pt&gt;$4&lt;\/pt&gt;<\/ptg>/gs;
    $FileText=~s/>([\.\,\;\: ]+)([^<>]*?)<pt>((?:(?!<pt>)(?!<\/pt>).)*)<\/pt>/>$1<ptg>$2&lt;pt&gt;$3&lt;\/pt&gt;<\/ptg>/gs;
    $FileText=~s/<pt>((?:(?!<pt>)(?!<\/pt>).)*)<\/pt>/<ptg>&lt;pt&gt;$1&lt;\/pt&gt;<\/ptg>/gs;
    #</ptg> (<yrg>Wiley-Blackwell) &lt;yr&gt;
    $FileText=~s/<\/ptg> \(<yrg>((?:(?!<[\/]?yrg>)(?!<[\/]?bib>).)*)\) \&lt\;yr\&gt\;/ \($1\)<\/ptg> <yrg>\&lt\;yr\&gt\;/gs;
    $FileText=~s/<\/ptg>([\.\,\;:]?) ([A-Z]) <(v|vg)>/$1 $2<\/ptg> <$3>/gs;


    #Book title <bt> groupings
    $FileText=~s/<bt>((?:(?!<[\/]?bt>).)*)<\/bt>([^\.\,\;\:\)][^<>]*?)(”|“|‘|[\.\,\;\:\'])([ <])/<btg>&lt;bt&gt;$1&lt;\/bt&gt;$2<\/btg>$3$4/gs;
    $FileText=~s/([> ]+)([\.\,\;\: ]+)([^<>]*?[^\.\,\;\:\(]) <bt>((?:(?!<[\/]?bt>).)*)<\/bt>/$1$2<btg>$3 &lt;bt&gt;$4&lt;\/bt&gt;<\/btg>/gs;
    $FileText=~s/>([\)]+)([\.\,\;\: ]+)([^<>]*?) <bt>((?:(?!<[\/]?bt>).)*)<\/bt>/>$1$2<btg>$3 &lt;bt&gt;$4&lt;\/bt&gt;<\/btg>/gs;
    $FileText=~s/>([\.\,\;\: ]+)([^<>]*?)<bt>((?:(?!<[\/]?bt>).)*)<\/bt>/>$1<btg>$2&lt;bt&gt;$3&lt;\/bt&gt;<\/btg>/gs;
    $FileText=~s/<bt>((?:(?!<[\/]?bt>).)*)<\/bt>/<btg>&lt;bt&gt;$1&lt;\/bt&gt;<\/btg>/gs;

    #Series title <srt> groupings
    $FileText=~s/<srt>((?:(?!<[\/]?srt>).)*)<\/srt>([^\.\,\;\:\)][^<>]*?)(”|“|‘|[\.\,\;\:\'])([ <])/<srtg>&lt;srt&gt;$1&lt;\/srt&gt;$2<\/srtg>$3$4/gs;
    $FileText=~s/([> ]+)([\.\,\;\: ]+)([^<>]*?[^\.\,\;\:\(]) <srt>((?:(?!<[\/]?srt>).)*)<\/srt>/$1$2<srtg>$3 &lt;srt&gt;$4&lt;\/srt&gt;<\/srtg>/gs;
    $FileText=~s/>([\)]+)([\.\,\;\: ]+)([^<>]*?) <srt>((?:(?!<[\/]?srt>).)*)<\/srt>/>$1$2<srtg>$3 &lt;srt&gt;$4&lt;\/srt&gt;<\/srtg>/gs;
    $FileText=~s/>([\.\,\;\: ]+)([^<>]*?)<srt>((?:(?!<[\/]?srt>).)*)<\/srt>/>$1<srtg>$2&lt;srt&gt;$3&lt;\/srt&gt;<\/srtg>/gs;
    $FileText=~s/<srt>((?:(?!<[\/]?srt>).)*)<\/srt>/<srtg>&lt;srt&gt;$1&lt;\/srt&gt;<\/srtg>/gs;

    #Book title <collab> groupings
    $FileText=~s/<collab>((?:(?!<[\/]?collab>).)*)<\/collab>([^\.\,\;\:\)][^<>]*?)(”|“|‘|[\.\,\;\:\'])([ <])/<collabg>&lt;collab&gt;$1&lt;\/collab&gt;$2<\/collabg>$3$4/gs;
    $FileText=~s/([> ]+)([\.\,\;\: ]+)([^<>]*?[^\.\,\;\:\(]) <collab>((?:(?!<[\/]?collab>).)*)<\/collab>/$1$2<collabg>$3 &lt;collab&gt;$4&lt;\/collab&gt;<\/collabg>/gs;
    $FileText=~s/>([\)]+)([\.\,\;\: ]+)([^<>]*?) <collab>((?:(?!<[\/]?collab>).)*)<\/collab>/>$1$2<collabg>$3 &lt;collab&gt;$4&lt;\/collab&gt;<\/collabg>/gs;
    $FileText=~s/>([\.\,\;\: ]+)([^<>]*?)<collab>((?:(?!<[\/]?collab>).)*)<\/collab>/>$1<collabg>$2&lt;collab&gt;$3&lt;\/collab&gt;<\/collabg>/gs;
    $FileText=~s/<collab>((?:(?!<[\/]?collab>).)*)<\/collab>/<collabg>&lt;collab&gt;$1&lt;\/collab&gt;<\/collabg>/gs;


    #print $FileText;
    #chapter title <misc1> groupings
    $FileText=~s/<misc1>((?:(?!<misc1>)(?!<\/misc1>).)*)<\/misc1>([^\.\,\;\:\)][^<>]*?)(”|“|‘|[\.\,\;\:\'])([ <])/<misc1g>&lt;misc1&gt;$1&lt;\/misc1&gt;$2<\/misc1g>$3$4/gs;
    $FileText=~s/([> ]+)([\.\,\;\: ]+)([^<>]*?[^\.\,\;\:\(]) <misc1>((?:(?!<misc1>)(?!<\/misc1>).)*)<\/misc1>/$1$2<misc1g>$3 &lt;misc1&gt;$4&lt;\/misc1&gt;<\/misc1g>/gs;
    $FileText=~s/>([\)]+)([\.\,\;\: ]+)([^<>]*?) <misc1>((?:(?!<misc1>)(?!<\/misc1>).)*)<\/misc1>/>$1$2<misc1g>$3 &lt;misc1&gt;$4&lt;\/misc1&gt;<\/misc1g>/gs;
    $FileText=~s/>([\.\,\;\:“\'\`„‚ ]+)([^<>]*?)<misc1>((?:(?!<misc1>)(?!<\/misc1>).)*)<\/misc1>/>$1<misc1g>$2&lt;misc1&gt;$3&lt;\/misc1&gt;<\/misc1g>/gs;
    $FileText=~s/<misc1>((?:(?!<misc1>)(?!<\/misc1>).)*)<\/misc1>/<misc1g>&lt;misc1&gt;$1&lt;\/misc1&gt;<\/misc1g>/gs;
    $FileText=~s/ ([Ii]n)<\/misc1g>([\.\:]) /<\/misc1g> $1$2 /gs;
    $FileText=~s/ ([Ii]n)<\/misc1g> /<\/misc1g> $1 /gs;


    #Publisher <pbl> groupings
    $FileText=~s/<pbl>((?:(?!<pbl>)(?!<\/pbl>).)*)<\/pbl>([^\.\,\;\:\)][^<>]*?)([\.\,\;\:])([ <])/<pblg>&lt;pbl&gt;$1&lt;\/pbl&gt;$2<\/pblg>$3$4/gs;
    $FileText=~s/([> ]+)([\.\,\;\: ]+)([^<>]*?[^\.\,\;\:\(]) <pbl>((?:(?!<pbl>)(?!<\/pbl>).)*)<\/pbl>/$1$2<pblg>$3 &lt;pbl&gt;$4&lt;\/pbl&gt;<\/pblg>/gs;
    $FileText=~s/>([\)]+)([\.\,\;\: ]+)([^<>]*?) <pbl>((?:(?!<pbl>)(?!<\/pbl>).)*)<\/pbl>/>$1$2<pblg>$3 &lt;pbl&gt;$4&lt;\/pbl&gt;<\/pblg>/gs;
    $FileText=~s/>([\.\,\;\: ]+)([^<>]*?)<pbl>((?:(?!<pbl>)(?!<\/pbl>).)*)<\/pbl>/>$1<pblg>$2&lt;pbl&gt;$3&lt;\/pbl&gt;<\/pblg>/gs;
    $FileText=~s/<pbl>((?:(?!<pbl>)(?!<\/pbl>).)*)<\/pbl>/<pblg>&lt;pbl&gt;$1&lt;\/pbl&gt;<\/pblg>/gs;
    $FileText=~s/<\/pblg>([^<>]*?)<\/bib>/$1<\/pblg><\/bib>/gs;
    $FileText=~s/([\,\.\:])<\/pblg><\/bib>/<\/pblg>$1<\/bib>/gs;
    #Publisher Location <cny> groupings
    $FileText=~s/<cny>((?:(?!<cny>)(?!<\/cny>).)*)<\/cny>([^\.\,\;\:\)][^<>]*?)([\.\,\;\:])([ <])/<cnyg>&lt;cny&gt;$1&lt;\/cny&gt;$2<\/cnyg>$3$4/gs;
    $FileText=~s/([> ]+)([\.\,\;\: ]+)([^<>]*?[^\.\,\;\:\(]) <cny>((?:(?!<cny>)(?!<\/cny>).)*)<\/cny>/$1$2<cnyg>$3 &lt;cny&gt;$4&lt;\/cny&gt;<\/cnyg>/gs;
    $FileText=~s/>([\)]+)([\.\,\;\: ]+)([^<>]*?) <cny>((?:(?!<cny>)(?!<\/cny>).)*)<\/cny>/>$1$2<cnyg>$3 &lt;cny&gt;$4&lt;\/cny&gt;<\/cnyg>/gs;
    $FileText=~s/>([\.\,\;\: ]+)([^<>]*?)<cny>((?:(?!<cny>)(?!<\/cny>).)*)<\/cny>/>$1<cnyg>$2&lt;cny&gt;$3&lt;\/cny&gt;<\/cnyg>/gs;
    $FileText=~s/<cny>((?:(?!<cny>)(?!<\/cny>).)*)<\/cny>/<cnyg>&lt;cny&gt;$1&lt;\/cny&gt;<\/cnyg>/gs;
    $FileText=~s/<\/cnyg>([^<>]*?)<\/bib>/$1<\/cnyg><\/bib>/gs;
    $FileText=~s/([\,\.\:])<\/cnyg><\/bib>/<\/cnyg>$1<\/bib>/gs;

 
    #Volume <v> groupings
    $FileText=~s/<v>((?:(?!<[\/]?v>).)*)<\/v>([\.\,\;\:\)\s]+)$regx{volumePrefix}([\.\,\;\:])([ <])/<vg>&lt;v&gt;$1&lt;\/v&gt;$2$3<\/vg>$4$5/gs;
    $FileText=~s/<v>((?:(?!<[\/]?v>).)*)<\/v>([^\.\,\;\:\)][^<>]*?)([\.\,\;\:]+)([ <])/<vg>&lt;v&gt;$1&lt;\/v&gt;$2<\/vg>$3$4/gs;
    $FileText=~s/([> ]+)([\.\,\;\: ]+)([^<>]*?[^\.\,\;\:\(]) <v>((?:(?!<[\/]?v>).)*?)<\/v>/$1$2<vg>$3 &lt;v&gt;$4&lt;\/v&gt;<\/vg>/gs;
    $FileText=~s/>([\)]+)([\.\,\;\: ]+)([^<>]*?) <v>((?:(?!<[\/]?v>).)*)<\/v>/>$1$2<vg>$3 &lt;v&gt;$4&lt;\/v&gt;<\/vg>/gs;
    $FileText=~s/>([\.\,\;\: ]+)([^<>]*?)<v>((?:(?!<[\/]?v>).)*)<\/v>/>$1<vg>$2&lt;v&gt;$3&lt;\/v&gt;<\/vg>/gs;
    $FileText=~s/<v>((?:(?!<[\/]?v>).)*?)<\/v>/<vg>&lt;v&gt;$1&lt;\/v&gt;<\/vg>/gs;
    $FileText=~s/\&lt\;\/v\&gt\;\((\d+ [Ss]uppl[\.]?)<\/vg>/\&lt\;\/v\&gt\;<\/vg>\($1/gs;
    $FileText=~s/\&lt\;\/v\&gt\;([\)\,\.\:\;])<\/vg>/\&lt\;\/v\&gt\;<\/vg>$1/gs;


    #issue <iss> groupings
    $FileText=~s/<\/vg>([\.\,\;\: ]*?)\(([a-zA-Z0-9\. ]+)<iss>((?:(?!<[\/]?iss>).)*)<\/iss>\)/<\/vg>$1\(<issg>$2&lt;iss&gt;$3&lt;\/iss&gt;<\/issg>\)/gs;
    $FileText=~s/<iss>((?:(?!<[\/]?iss>).)*)<\/iss>([^\.\,\;\:\)][^<>]*?)([\.\,\;\:])([ <])/<issg>&lt;iss&gt;$1&lt;\/iss&gt;$2<\/issg>$3$4/gs;
    $FileText=~s/([> ]+)([\.\,\;\: ]+)([^<>]*?[^\.\,\;\:\(]) <iss>((?:(?!<[\/]?iss>).)*)<\/iss>/$1$2<issg>$3 &lt;iss&gt;$4&lt;\/iss&gt;<\/issg>/gs;
    $FileText=~s/>([\)]+)([\.\,\;\: ]+)([^<>]*?) <iss>((?:(?!<[\/]?iss>).)*)<\/iss>/>$1$2<issg>$3 &lt;iss&gt;$4&lt;\/iss&gt;<\/issg>/gs;
    $FileText=~s/<iss>((?:(?!<[\/]?iss>).)*)<\/iss>/<issg>&lt;iss&gt;$1&lt;\/iss&gt;<\/issg>/gs;
    $FileText=~s/([\)\]])<\/issg>([\.\:\,])/<\/issg>$1/gs;
    $FileText=~s/\.<\/pg>/<\/pg>\./gs;
    $FileText=~s/\b$regx{issuePrefix}([ ]?)<issg>/<issg>$1$2/gs;
    $FileText=~s/\/iss\&gt\; \(INT<\/issg>\)/\/iss\&gt\; \(INT\)<\/issg>/gs;
    $FileText=~s/ \b$regx{issuePrefix}\(<issg>\&lt\;iss\&gt\;/ \(<issg>$1\&lt\;iss\&gt\;/gs;


    #page <pg> groupings
    $FileText=~s/<pg>((?:(?!<[\/]?pg>).)*?)<\/pg>([^\.\,\;\:\)][^<>]*?)([\.\,\;\:])([ <])/<pgg>&lt;pg&gt;$1&lt;\/pg&gt;$2<\/pgg>$3$4/gs;
    $FileText=~s/([> ]+)([\.\,\;\:\) ]+)([^<>]*?[^\.\,\;\:\(]) <pg>((?:(?!<[\/]?pg>).)*?)<\/pg>/$1$2<pgg>$3 &lt;pg&gt;$4&lt;\/pg&gt;<\/pgg>/gs;
    $FileText=~s/>([\.\,\;\:\) ]+)([^<>]*?)<pg>((?:(?!<[\/]?pg>).)*?)<\/pg>/>$1<pgg>$2&lt;pg&gt;$3&lt;\/pg&gt;<\/pgg>/gs;
    $FileText=~s/<pg>((?:(?!<[\/]?pg>).)*)<\/pg>/<pgg>&lt;pg&gt;$1&lt;\/pg&gt;<\/pgg>/gs;
    $FileText=~s/<pgg>((?:(?!<pgg>)(?!<\/pgg>).)*?)<\/pgg>([^<>]*?)<\/bib>/<pgg>$1$2<\/pgg><\/bib>/gs;
    $FileText=~s/([\,\.]) ([0-9\-]+)([\,\.]) <pgg>/$1 <pgg>$2$3 /gs;
#    <pg>1448&#150;1450</pg>

    #editions <edn> groupings
    $FileText=~s/<edn>((?:(?!<[\/]?edn>).)*)<\/edn>([^\.\,\;\:\)][^<>]*?)([\.\,\;\:])([ <])/<edng>&lt;edn&gt;$1&lt;\/edn&gt;$2<\/edng>$3$4/gs;
    $FileText=~s/([> ]+)([\.\,\;\: ]+)([^<>]*?[^\.\,\;\:\(]) <edn>((?:(?!<[\/]?edn>).)*)<\/edn>/$1$2<edng>$3 &lt;edn&gt;$4&lt;\/edn&gt;<\/edng>/gs;
    $FileText=~s/\&gt<\/([a-z]+)>\;/\&gt\;<\/$1>/gs;
    $FileText=~s/>([\)]+)([\.\,\;\: ]+)([^<>]*?) <edn>((?:(?!<[\/]?edn>).)*)<\/edn>/>$1$2<edng>$3 &lt;edn&gt;$4&lt;\/edn&gt;<\/edng>/gs;
    $FileText=~s/>([\.\,\;\: ]+)([^<>]*?)<edn>((?:(?!<[\/]?edn>).)*)<\/edn>/>$1<edng>$2&lt;edn&gt;$3&lt;\/edn&gt;<\/edng>/gs;
    $FileText=~s/<edn>([0-9A-Za-z\-\/]+)<\/edn>/<edng>&lt;edn&gt;$1&lt;\/edn&gt;<\/edng>/gs;
    $FileText=~s/<edng>In([\.\:]) In([\.\:]) /In$1<edng>/gs;
    $FileText=~s/In([\.\:]) <edng>In([\.\:]) /In$1<edng>/gs;
    $FileText=~s/<edng>In([\.\:]) in([\.\:]) /In$1<edng>/gs;
    $FileText=~s/In([\.\:]) <edng>in([\.\:]) /In$1<edng>/gs;
    $FileText=~s/\, ([Rr]ev[.]? )<edng>/\, <edng>$1/gs;
    $FileText=~s/<\/edng>([\.\,]? [eE][dD][n]?)([\.])/$1<\/edng>$2/gs;
    $FileText=~s/\"<\/(atg|ptg|srtg|btg|misc1)>/<\/$1>\"/gs;


    $FileText=~s/<url><url>((?:(?!<[\/]?url>).)*)<\/url><\/url>/<url>$1<\/url>/gs;
    #<url> groupings
    #$TextBody=~s/([Aa]vailable [fF]rom)([\:\. ]+)(https\:\/\/|http\:\/\/|www|ftp)([\/\\\_\.\~\%\#\@\$\&\*\(\)\w\d\-]+)/<urlg>$1$2<url>$3$4<\/url><\/urlg>/gs;
    $FileText=~s/([> ]+)([Aa]vailable [fF]rom|[Aa]vailable at|[Rr]etrieved [ff]rom|[Rr]etrieved at)([\:\. ]+)<url>((?:(?!<[\/]?url>).)*?)<\/url>/$1<urlg>$2$3&lt;url&gt;$4&lt;\/url&gt;<\/urlg>/gs;
    $FileText=~s/\&lt\;<url>((?:(?!<[\/]?url>).)*)<\/url>\&gt\;/<urlg>&lt;&lt;url&gt;$1&lt;\/url&gt;&gt;<\/urlg>/gs;
    $FileText=~s/<url>((?:(?!<[\/]?url>).)*)<\/url>/<urlg>&lt;url&gt;$1&lt;\/url&gt;<\/urlg>/gs;
    $FileText=~s/<\/(pblg|cnyg|btg)>\. (\([A-Z0-9]+\))\. <urlg>/<\/$1>\. <urlg>$2\. /gs;

    $FileText=~s/\&lt\;\/url\&gt\;<\/urlg>([ \.]+)([^<>]+?)([\.]?)<\/bib>/\&lt\;\/url\&gt\;$1$2<\/urlg>$3<\/bib>/gs;
    #$FileText=~s/<ia>Innovationsallianz Green Carbody Technologies (Hrsg.): Online</ia>//gs;
    $FileText=~s/<ia>([^<>]+?) ([\(]?)$regx{editorSuffix}([\)]?)([\:\.\,\; ]+)([^<>]+?)<\/ia>([\.\,\:\; ]+)<urlg>/<ia>$1 $2$3$4<\/ia>$5<urlg>$6$7/gs;


    #editions <doi> groupings
    $FileText=~s/<doi>((?:(?!<[\/]?doi>).)*?)<\/doi>([^\.\,\;\:\)][^<>]*?)([\.\,\;\:])([ <])/<doig>&lt;doi&gt;$1&lt;\/doi&gt;$2<\/doig>$3$4/gs;
    $FileText=~s/([> ]+)([\.\,\;\: ]+)([^<>]*?[^\.\,\;\:\(]) <doi>((?:(?!<[\/]?doi>).)*?)<\/doi>/$1$2<doig>$3 &lt;doi&gt;$4&lt;\/doi&gt;<\/doig>/gs;
    $FileText=~s/>([\)]+)([\.\,\;\: ]+)([^<>]*?) <doi>((?:(?!<[\/]?doi>).)*?)<\/doi>/>$1$2<doig>$3 &lt;doi&gt;$4&lt;\/doi&gt;<\/doig>/gs;
    $FileText=~s/<doi>$regx{doi}<\/doi>/<doig>&lt;doi&gt;$1&lt;\/doi&gt;<\/doig>/gs;
    $FileText=~s/([\.\,\:\; ]+)([dD][oO][iI])\:<doig>([Dd][Oo][Ii]) \&lt\;doi\&gt\;/$1<doig>$2\:$3 \&lt\;doi\&gt\;/gs;
    $FileText=~s/\&lt\;\/doi\&gt\;<\/doig>([ \.]+)([^<>]+?)([\.]?)<\/bib>/\&lt\;\/doi\&gt\;$1$2<\/doig>$3<\/bib>/gs;

    $FileText=~s/<\/ptg>\, ([^<>]+?[\.]?) <doig>/<\/ptg>\, <doig>$1 /gs;
    #print "XX: $FileText\n";exit;
    #For Comments
    $FileText=~s/([\.\, ]+)<comment>([^<>]+?)<\/comment>([\.]?)<\/bib>/<\/bib>$1<comment>$2<\/comment>$3/gs;
    $FileText=~s/<\/([a-z0-9]+g)>([\.\,\;\:\)\(\]\[\'\"\` ]+)<comment>((?:(?!<[\/]?comment>).)*?)<\/comment>/$2<comment>$3<\/comment><\/$1>/gs;
    $FileText=~s/<\/([a-z0-9]+g)>([\.\,\;\:\)\(\]\[\'\"\` ]+)\&lt\;comment\&gt\;((?:(?!\&lt\;[\/]?comment\&gt\;).)*)\&lt\;\/comment\&gt\;/$2\&lt\;comment\&gt\;$3\&lt\;\/comment\&gt\;<\/$1>/gs;


    #------------------------------------------- 
    $FileText=~s/  / /gs;

    #<ptg>In: 
    $FileText=~s/\&lt\;\/at\&gt\; ([iI]n)<\/atg>([:\. ]+)<ptg>/\&lt\;\/at\&gt\;<\/atg> <ptg>$1$2/gs;
    $FileText=~s/<ptg>[iI]n[:\. ]+\&lt\;pt\&gt\;/<ptg>\&lt\;pt\&gt\;/gs;
    $FileText=~s/<ptg>“[\.\,]? [iI]n[:\. ]+\&lt\;pt\&gt\;/<ptg>\&lt\;pt\&gt\;/gs;
    $FileText=~s/<ptg>\&quot\;[\.\,]? in[:\. ]+\&lt\;pt\&gt\;/<ptg>\&lt\;pt\&gt\;/gs;
    $FileText=~s/([\.\,])<\/pgg>/<\/pgg>$1/gs;
    $FileText=~s/<(au|auf|aus|edr|eds|edf|aum|edm|pg|edn|v|suffix|par|prefix|iss|comment)>/&lt;$1&gt;/gs;
    $FileText=~s/<\/(au|auf|aus|edr|eds|edf|aum|edm|pg|edn|v|suffix|par|prefix|iss|comment)>/&lt;\/$1&gt;/gs;
    $FileText=~s/\&lt\;\/(i|b|u|sup|sub)\&gt<\/([a-z0-9]+)>\;/\&lt\;\/$1\&gt\;<\/$2>/gs;
	#commented By Biswajit
   # $FileText=~s/<atg>([“„‚\`\'” ]+)\&lt\;at\&gt\;/$1<atg>\&lt\;at\&gt\;/gs;
   # $FileText=~s/<ptg>([“„‚\`\'” ]+)\&lt\;pt\&gt\;/$1<ptg>\&lt\;pt\&gt\;/gs;
   # $FileText=~s/([\,“„‚\`\'” ]+)<\/atg>/<\/atg>$1/gs;
   # $FileText=~s/([\,“„‚\`\'” ]+)<\/misc1g>/<\/misc1g>$1/gs;
   # $FileText=~s/<misc1g>([“„‚\`\']+)\&lt\;misc1\&gt\;/$1<misc1g>\&lt\;misc1\&gt\;/gs;
   # $FileText=~s/<\/misc1g>([\.\,])<btg>(|�|”|’||[�]+) \&lt\;bt\&gt\;/<\/misc1g>$1$2 <btg>\&lt\;bt\&gt\;/gs;
    $FileText=~s/<(pgg|yrg|vg|edng|issg)>$regx{allRightQuote} /$2 <$1>/gs;
     #$FileText=~s/\&lt\;\/bt\&gt\;<\/btg>//gs;
    #<pblg>(&lt;pbl&gt;Gaussian Inc.&lt;/pbl&gt;</pblg>
    $FileText=~s/<pblg>\(&lt;pbl&gt;([^<>]*?)&lt;\/pbl&gt;<\/pblg>([\.\,\:\; ]+)<cnyg>([^<>]*?)<\/cnyg>([\.\,\:\; ]+)<yrg>&lt;yr&gt;([^<>]*?)&lt;\/yr&gt;\)([\.\,\:\;]?)<\/yrg>/\(<pblg>&lt;pbl&gt;$1&lt;\/pbl&gt;<\/pblg>$2<cnyg>$3<\/cnyg>$4<yrg>&lt;yr&gt;$5&lt;\/yr&gt;<\/yrg>\)$6/gs;
    $FileText=~s/<([a-z]+g)> / <$1>/gs;
    $FileText=~s/\&hellip<\/aug>\;/\&hellip\;<\/aug>/gs;

    $FileText=~s/([\,\.])\&lt\;\/(pt|at|bt)\&gt\;<\/\2g>/\&lt\;\/$2\&gt\;<\/$2g>$1/gs;
    $FileText=~s/<\/ptg> \(([^<>]+?)\)([\.\,\; ]*?)<(yrg|vg)>/ \($1\)<\/ptg>$2<$3>/gs;

    #</ptg>, Vol 52. <yrg>
    $FileText=~s/<\/ptg>\, ([^<>]+)\. <yrg>/\, $1<\/ptg>\. <yrg>/gs;
    #print "$FileText\n";

    $FileText=~s/<([a-z1]+)g>\)([\.\, ]*)\&lt\;\1\&gt\;/\)$2<$1g>&lt\;$1\&gt\;/gs;
    $FileText=~s/<([a-z1]+)g>([\.\,\;]?) \&lt\;\1\&gt\;/$2 <$1g>\&lt\;$1\&gt\;/gs;
    $FileText=~s/<\/(aug|edrg|ia)>([\.\,\:\( ]+)<yrg>\&lt\;yr\&gt\;([^<>]+?)\&lt\;\/yr\&gt\;([^<>]+?)<\/yrg>([\.]?)<\/bib>/<\/$1>$2<yrg>\&lt\;yr\&gt\;$3\&lt\;\/yr\&gt\;<\/yrg>$4$5<\/bib>/gs;
    $FileText=~s/<\/(aug|edrg|ia)>([^<>]+?)<yrg>([^<>]*?)\&lt\;yr\&gt\;([^<>]+?)\&lt\;\/yr\&gt\;([^<>]+?)<\/yrg>([\.]?)<\/bib>/<\/$1>$2<yrg>$3\&lt\;yr\&gt\;$4\&lt\;\/yr\&gt\;<\/yrg>$5$6<\/bib>/gs;

    #<ia>Australian Bureau of Statistics</ia>. 2033.0.55.001 - Census of Population and Housing: Socio-Economic Indexes for Areas (SEIFA), Australia - data only, <yrg>&lt;yr&gt;2006&lt;/yr&gt; [Internet; updated 27 March 2013; cited 30 March 2013]. Available from: http://www.abs.gov.au/AUSSTATS/abs@.nsf/DetailsPage/2033.0.55.0012006.</yrg></bib>

    #$FileText=~s/&lt;(bt|at|misc1)\&gt\;\"((?:(?!<\/pt>)(?!<bib)(?!\")(?!<\/bib>)(?!<misc1>)(?!<atg>)(?!<btg>).)*)\"&lt\;\/\1\&gt\;/\"&lt;$1\&gt\;$2&lt\;\/$1\&gt\;\"/gs;
    $FileText=~s/ \(([^<>\(\)]+?)<\/aug> <yrg>\&lt\;yr\&gt\;$regx{year}\&lt\;\/yr\&gt\;<\/yrg>\, <btg>([^<>\(\)]+?)\). \&lt\;bt\&gt\;/<\/aug> \(<yrg>$1 \&lt\;yr\&gt\;$2\&lt\;\/yr\&gt\;\, $3<\/yrg>\). <btg>\&lt\;bt\&gt\;/gs;

    $FileText=~s/\&lt\;\/auf\&gt\;\&lt\;\/au\&gt\;\.\, /\.\&lt\;\/auf\&gt\;\&lt\;\/au\&gt\;\, /gs;
    $FileText=~s/([\.\,\; ]+)$regx{pagePrefix}<\/([a-z1-3]+)>([\. ]+)<pgg>/<\/$3>$1<pgg>$2$4/gs;
    $FileText=~s/\&lt\;\/([a-z]+)\&gt\;([\.\, ]+)([(]?)$regx{ednPrifix}<\/\1g>\. <edng>/\&lt\;\/$1\&gt\;<\/$1g>$2$3<edng>$4\. /gs;
    $FileText=~s/\&gt\;([\.\, ]+)([(]?)$regx{ednPrifix}<\/([a-z]+g)>\. <edng>/<\/$4>$1$2<edng>$3\. /gs;
    $FileText=~s/<\/pblg>([\.\,\:\; ]+)([^<>]+?[\:\.\,][ ]?)<urlg>/<\/pblg>$1<urlg>$2/gs;
    $FileText=~s/<\/pgg>\, ([^<>]+?)\, <vg>/\, $1<\/pgg>\, <vg>/gs;
    $FileText=~s/<\/([^<>]+?)>([\.\)\]\,]+[ ]?)([\(\[]?[A-Za-z0-9]+[^<>]+?[\.]?)<\/bib>/<\/$1>$2<comment>$3<\/comment><\/bib>/gs;
    $FileText=~s/\(<([a-z0-9]+)>([^<>\(\)]+?)\)<\/\1>/\(<$1>$2<\/$1>\)/gs;
    $FileText=~s/<([a-z0-9]+)>\(([^<>\(\)]+?)<\/\1>\)/\(<$1>$2<\/$1>\)/gs;
    $FileText=~s/\(<([a-z1]+g)>([^\(\)]+)\)([ \,\.\:\;])<\/([a-z1]+g)>/\(<$1>$2<\/$4>\)$3/gs;
    $FileText=~s/\&lt\;\/([a-z0-9]+)\&gt\; \(([^<>\(\)]+)<\/\1g>([\.\,\;\: ]+)<([a-z0-9]+)>([^<>\)\(]+)<\/\4>\)/\&lt\;\/$1\&gt\;<\/$1g> \(<$4>$2$3$5<\/$4>\)/gs;
    #$FileText=~s/<([a-z]+)g>\“\&lt\;\1\&gt\;([^<>]+?)&lt;\/\1&gt;<\/\1g>\”/\“<$1g>\&lt\;$1\&gt\;$2&lt;\/$1&gt;<\/$1g>\”/gs;
    $FileText=~s/<ia>((?:(?!<[\/]?ia>)(?!<[\/]?aug>)(?!<bib)(?!<\/bib).)+?)([\.\,\:]?) $regx{allLeftQuote}((?:(?!<[\/]?ia>)(?!<[\/]?aug>)(?!<bib)(?!<\/bib).)+?)<\/ia>/<ia>$1<\/ia>$2 $3$4/gs;

    $FileText=~s/<\/(pblg|cnyg|vg|issg|edng)>([\.\,\;\:]+ )([^<>]+?)([\.\,\;\:]+ )<(cnyg|vg|issg|pblg|edng|yrg)>/$2$3<\/$1>$4<$5>/gs;
    $FileText=~s/\(([^\(\)<>]+?)<\/([a-z1]+)g>([^\(\)<>]+?)\)([\.\,\:\; ]+)/\($1$3\)<\/$2g>$4/gs;
    $FileText=~s/<\/(btg|misc1g|collabg)>([\.\,\:\; ]+)([\(]?)$regx{editorSuffix}([\)\.\:\, ]+)<ia>/<\/$1>$2<ia>$3$4$5/gs;
    #$FileText=~s/<([a-z1]+)g>\"((?:(?!\")(?!<[\/]?\1g>)(?!<bib)(?!<\/bib).)+?)<\/\1g>([\,\.\:\;\?]*)\"/\"<$1g>$2<\/$1g>$3\"/gs;
    #$FileText=~s/<([a-z1]+)g>\"((?:(?!\")(?!<[\/]?\1g>)(?!<bib)(?!<\/bib).)+?)\"<\/\1g>/\"<$1g>$2<\/$1g>$3/gs;
    $FileText=~s/\"<([a-z1]+)g>((?:(?!\")(?!<[\/]?\1g>)(?!<bib)(?!<\/bib).)+?)\"<\/\1g>/\"<$1g>$2<\/$1g>$3/gs;
    $FileText=~s/<([a-z1]+)g>$regx{allLeftQuote}$regx{noQoute}<\/\1g>([\,\.\:\;\?]*)$regx{allRightQuote}/$2<$1g>$3<\/$1g>$4$5/gs;
    $FileText=~s/<([a-z1]+)g>$regx{allLeftQuote}$regx{noQoute}$regx{allRightQuote}<\/\1g>/$2<$1g>$3<\/$1g>$4/gs;
    $FileText=~s/$regx{allLeftQuote}<([a-z1]+)g>$regx{noQoute}$regx{allRightQuote}<\/\2g>/$1<$2g>$3<\/$2g>$4/gs;
    $FileText=~s/\&quot\;<([a-z1]+g)>$regx{noQoute}<\/\1>([\.\?\, ]+)<([a-z]+g)>\&quot\;([\.\, ]+)/\&quot\;<$1>$2<\/$1>$3\&quot\;$5<$4>/gs;
    $FileText=~s/\`\`<([a-z1]+g)>$regx{noQoute}<\/\1>([\.\?\, ]+)<([a-z]+g)>\'\'([\.\, ]+)/\`\`<$1>$2<\/$1>$3\'\'$5<$4>/gs;
    $FileText=~s/\`\`<([a-z1]+g)>$regx{noQoute}<\/\1>([\.\?\, ]+)<([a-z]+g)>\"([\.\, ]+)/\`\`<$1>$2<\/$1>$3\"$5<$4>/gs;
    $FileText=~s/<cnyg>\(&lt;cny&gt;([^<>]+?)\&lt\;\/cny\&gt\;<\/cnyg> <pblg>([^<>]+?)\)([\.\,\: ]+)\&lt\;pbl\&gt\;/<cnyg>\(&lt;cny&gt;$1\&lt\;\/cny\&gt\; $2\)<\/cnyg>$3 <pblg>\&lt\;pbl\&gt\;/gs;
    $FileText=~s/<\/edng>$regx{numberSuffix} <edrg>$regx{ednPrifix}([\.]?)\, /$1 $2$3<\/edng>\, <edrg>/gs;
    $FileText=~s/<\/edng>([\.]?) <edrg>$regx{ednPrifix}([\.]?)\, /$1 $2$3<\/edng>\, <edrg>/gs;

    $FileText=~s/\&lt\;\/([A-Za-z0-9]+)\&gt<\/\1g>\;/\&lt\;\/$1\&gt\;<\/$1g>/gs;

    $FileText=~s/<\/(pblg|cnyg)>\, ([^<>]+?)\, <pgg>/<\/$1>\, <pgg>$2\, /gs;
 

    return $FileText;
}

#=================================================================================
return 1;
