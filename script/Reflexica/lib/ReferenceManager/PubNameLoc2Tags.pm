#version 1.0
#Author: Neyaz Ahmad
package ReferenceManager::PubNameLoc2Tags;
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(PubNameMarkFromIni PubLocMarkFromIni PubNameLocMarkFromIni);

use ReferenceManager::ReferenceRegex;
my %regx = ReferenceManager::ReferenceRegex::new();

BEGIN{
  $SCRITPATH=$0;
  $SCRITPATH=~s/(.*)([\/\\])(.*?)\.(pl|exe)/$1/g;
}

#=============================================================================================================================
sub PubLocMarkFromIni{
  my $TextBody=shift;
  my $application=shift;
  my $commonPubName='(Cambridge|Oxford|Wageningen|Lincoln|Stanford|California|Houndmills|Harvard)';

  $PublisherLocationRef=&readPubLocINI($SCRITPATH);

  #--------------------------------
  # use ReferenceManager::PublisherLocationDB;
  # $PublisherLocationRef=&SortedPublisherLocationDB;
  #--------------------------------

  my ($sleepCounter, $sleep1, $sleep2)=(0, 0, 0);
  if (defined $application){
    if($application eq "AMPP" || $application eq "ampp"){
      $sleep1=0;
      $sleep2=0;
      # $sleep1=0.01;
      # $sleep2=0.001;

    }
  }

  foreach (@$PublisherLocationRef)
   {
     my $PubLoc="$_";
     $PubLoc=~s/[ \t]/ /gs;
     $PubLoc=~s/([\s])$//gs;
     $PubLoc=~s/^([\s])//gs;
     $PubLoc=~s/[ \t]/ /gs;

     $TextBody=~s/\s\Q$PubLoc\E([\?\!\,\.\'\"\:\;\) ]?)<\/bib>/ <cny>$PubLoc<\/cny>$1<\/bib>/gs;

  #   $TextBody=~s/\(\Q$PubLoc\E\)<\/bib>/\(<cny>$1<\/cny>\)/gs;
     $TextBody=~s/([\?\!\.\:\;\'\"\,\`\(\)\]\/\-]+\s*|‚Äù |‚Äô |[íî] |\\newblock\s*|[Aa]uflage |<\/i> )\Q$PubLoc\E([\?\!\,\.\'\"\:\;\)\( ]?)<\/bib>/$1<cny>$PubLoc<\/cny>$2<\/bib>/gs;
     $TextBody=~s/<pbl>([^<>]+?)<\/pbl>([\.\;\:\, ]+)<pt>$PubLoc<\/pt>/<pbl>$1<\/pbl>$2<cny>$PubLoc<\/cny>/gs;
     $TextBody=~s/([\.\;\:\, ]+)<pt>$PubLoc<\/pt>([\.\,\: ]+)$regx{volumePrefix}/$1<pbl>$PubLoc<\/pbl>$3$4/gs;
     $TextBody=~s/([\?\!\.\:\;\'\"\,\`\(\)\]\/]+\s*|‚Äù |‚Äô |[íî] |\\newblock\s*|[Aa]uflage |<\/i> )\Q$PubLoc\E ([\(\[]?)/$1<cny>$PubLoc<\/cny> $2/gs;
     $TextBody=~s/([\?\!\.\:\;\'\"\,\`\(\)\]]+\s*|‚Äù |‚Äô |[íî] |\\newblock\s*|[Aa]uflage |<\/i> )\Q$PubLoc\E([\/\?\!\,\.\'\"\:\;\)]+) /$1<cny>$PubLoc<\/cny>$2 /gs;
     $TextBody=~s/([\?\!\.\:\;\'\"\,\`\(\)\]\/\-]+\s*|‚Äù |‚Äô |[íî] |\\newblock\s*|[Aa]uflage |<\/i> )\Q$PubLoc\E([\?\!\,\.\'\"\:\;\)]+)</$1<cny>$PubLoc<\/cny>$2</gs;
     $TextBody=~s/([\?\!\.\:\;\'\"\,\`\(\)\]\/\-]+\s*|‚Äù |‚Äô |[íî] |\\newblock\s*|[Aa]uflage |<\/i> )\Q$PubLoc\E([\;\,\.\( ]+)</$1<cny>$PubLoc<\/cny>$2</gs;
     $TextBody=~s/([\?\!\.\;\:\'\"\,\`\(\)\]\/\-]+\s*|‚Äù |‚Äô |[íî] |\\newblock\s*|[Aa]uflage |<\/i> )\Q$PubLoc\E([\)\.\,\; ]*?)(<\/bib>|<cny>)/$1<cny>$PubLoc<\/cny>$2$3/gs;
     $TextBody=~s/([\?\!\.\:\;\'\"\,\`\(\)\]]+\s*|‚Äù |‚Äô |[íî] |\\newblock\s*|[Aa]uflage |<\/i> )$commonPubName([\?\!\,\.\'\"\:\;\) ]+)<pbl>/$1<cny>$2<\/cny>$3<pbl>/gs;
     #$TextBody=~s/([\?\!\.\;\:\'\"\,\`\(\)]+\s*|\\newblock\s*|[Aa]uflage |<\/cny>[\, ]*?|\/)\Q$PubLoc\E([\?\!\,\.\'\"\:\;\)\( ]+|<\/bib>|[\?\!\,\.\'\"\:\;\)\( ]<pbl>|[\?\!\,\.\'\"\:\;\)\( ]<yr>)/$1<cny>$2<\/cny>$3/gs;
     $TextBody=~s/<\/cny> (u\.[ ]?a\.|u\.[ ]?a|a\.[ ]?M\.|a\.[ ]?M)/ $1<\/cny>/gs;

     $TextBody=~s/(<\/cny>[\,\/\-\& ]+?|<\/cny> [au]nd |<\/pbl>[\;\,\)\: ]+?|\\newblock\s*|[Aa]uflage |<\/i> )\Q$PubLoc\E([\/\-\?\!\,\.\'\"\:\;\)\( ]+|<\/bib>|[\?\!\,\.\'\"\:\;\)\( ]+<pbl>|[\?\!\,\.\'\"\:\;\)\( ]+<yr>)/$1<cny>$PubLoc<\/cny>$2/gs;
     $TextBody=~s/([\?\!\.\:\;\'\"\,\`\(\)\]\/\-]+\s*|\\newblock\s*|[Aa]uflage |<\/i> )\Q$PubLoc\E([\/\-\?\!\,\.\'\"\:\;\)\( ]+|<\/bib>|[\?\!\,\.\'\"\:\;\)\( ]+<pbl>|[\?\!\,\.\'\"\:\;\)\( ]+<cny>|[\?\!\,\.\'\"\:\;\)\( ]+<yr>)/$1<cny>$PubLoc<\/cny>$2/gs;

     $TextBody=~s/(<\/cny>[\,\/\-\& ]+?|<\/cny> [au]nd |<\/pbl>[\;\,\)\: ]+?|\\newblock\s*|[Aa]uflage |<\/i> )\Q$PubLoc\E([\/\-\?\!\,\.\'\"\:\;\)\( ]+|<\/bib>|[\?\!\,\.\'\"\:\;\)\( ]+<pbl>|[\?\!\,\.\'\"\:\;\)\( ]+<cny>|[\?\!\,\.\'\"\:\;\)\( ]+<yr>)/$1<cny>$PubLoc<\/cny>$2/gs;
     $TextBody=~s/(<\/cny>[\, ]+?|<\/cny>[\/\-])([A-Z\.]+)([\?\!\,\.\'\"\:\;\)\( ]+|<\/bib>|[\?\!\,\.\'\"\:\;\)\( ]+<pbl>|[\?\!\,\.\'\"\:\;\)\( ]+<yr>)/$1<cny>$2<\/cny>$3/gs;
    $TextBody=~s/(<\/cny>[\,\/\-\& ]+?|<\/cny> [au]nd |<\/pbl>[\;\,\)\: ]+?|\\newblock\s*|[Aa]uflage |<\/i> )\Q$PubLoc\E([\/\-\?\!\,\.\'\"\:\;\)\( ]+|<\/bib>|[\?\!\,\.\'\"\:\;\)\( ]+<pbl>|[\?\!\,\.\'\"\:\;\)\( ]+<yr>)/$1<cny>$PubLoc<\/cny>$2/gs;
     #     print "$TextBody\n";

     #select(undef, undef, undef, $sleep2);
      if($sleepCounter == 5){
        $sleepCounter=0;
        select(undef, undef, undef, $sleep1);
      }
     $sleepCounter++;
   }


  $TextBody=~s/<cny>([^<>]+?)<\/cny>\: <pt>([^<>]+?)<\/pt>([\.]?)<\/bib>/<cny>$1<\/cny>\: $2$3<\/bib>/gs;
  $TextBody=~s/<i>([^<>]+?)<pbl>([^<>]+?)<\/pbl>([^<>]+?)<\/i>([\:\,\.\; ]+)<cny>/<i>$1$2$3<\/i>$4<cny>/gs;
  $TextBody=~s/\. <pbl>([^<>]+?)<\/pbl>([\.\,\:]+ )<pt>([^<> ]+)<\/pt>\, $regx{volumePrefix}/\. <pbl>$1<\/pbl>$2<cny>$3<\/cny>\, $4/gs;
  $TextBody=~s/<pbl>West<\/pbl> <cny>([^<>]+?)<\/cny>/<cny>West $1<\/cny>/gs;
  $TextBody=~s/<\/cny> ([au]nd) ([A-Z][^0-9\)\'\"\;\?\(<>]+)\, <cny>/ $1 $2\, /gs;
  $TextBody=~s/<\/cny>\, <cny>(S[\.?]|P[\.?])<\/cny> <pg>/<\/cny>\, $1 <pg>/gs;

  $TextBody=~s/\. ([A-Z]{2,3})\: <pbl>/\. <cny>$1<\/cny>\: <pbl>/gs;
  $TextBody=~s/([\.\,\)] )<cny>([^<>]+?)<\/cny>\: <pbl>([^<>]+?)<\/pbl>\, <cny>([^<> ]+?)<\/cny>/$1<cny>$2<\/cny>\: <pbl>$3\, $4<\/pbl>/gs;

  $TextBody=~s/<cny>([^<>]+?)<\/cny>\:<cny>([^<>]+?)<\/cny> ([\w])/<cny>$1<\/cny>: $2 $3/gs;
  #print $TextBody;exit;


  $TextBody=~s/<\/cny> (u\.[ ]?a\.|u\.[ ]?a|a\.[ ]?M\.|a\.[ ]?M)/ $1<\/cny>/gs;
  $TextBody=~s/<\/cny> \((u\.[ ]?a\.|u\.[ ]?a|a\.[ ]?M\.|a\.[ ]?M)\)/ \($1\)<\/cny>/gs;
  $TextBody=~s/<\/cny>([\,\/]?) (U[\. ]*S[\. ]*A[\.]?|UK|USSR)([\,\.]|<)/ $1 $2<\/cny>$3/gs;
  $TextBody=~s/ <cny>([^<>]+?)<\/cny> ([A-Za-z][^<>\.\,\;\:\'\"]+ [A-Za-z][^<>\.\,\;\:\'\"]+)/ $1 $2/gs;
  $TextBody=~s/([\(]?)(1[987][0-9][0-9][a-z]?|20[0-9][0-9][a-z]?|in press|n\.d\.|z\.d\.)([\).]*?) <cny>([^<>]+?)<\/cny> ([A-Za-z][a-z]+)/$1$2$3 $4 $5/gs;
  $TextBody=~s/<cny>([^<>]+?)<\/cny>, (Ill[\.]?)([\.\:\,])/<cny>$1, $2<\/cny>$3/gs;
  $TextBody=~s/<\/cny>\, <v>([ILV]+)<\/v>([\,\.]?) $regx{pagePrefix}$regx{optionalSpace}<pg>/\, $1<\/cny>$2 $3$4<pg>/gs;


  my $publisherSuffix='([Uu]niversity [Pp]ress|[Pp]ublishing [Cc]ompany|[Pp]ublishing [Ll]imited|Publishing [Ll]td[\.]?|[Pp]ublications L[tT][dD][\.]?|[Pp]ublisher[s]? [Ll][tT][dD][\.]?|[Pp]ublications\, Inc[\.]?|[Pp]ublications Inc|[Pp]ublishing Inc|[Pp]ress [Ll]td[\.]?|[Ff]oundation [Pp]ress|\b[Pp]ress [Pp]ublication|[R]esearch [Ii]nstitute|Publishing Co\.[\,]? Inc[\.]?|[Pp]ublishing Co[\.]?|[Cc]ompany Inc[\.]?|Pty Ltd[\.]?|[Pp]ublishing [Hh]ouse|\b[Pp]ress [Ii]nc[\.]?|[Pp]ublications|[Pp]ublishing|[Aa]ssociation|[Pp]ublisher[s]?|Univ[\.]? Press|\b[Pp]ress of [A-Za-z ]+|\b[Pp]ress and [A-Za-z ]+|\b[Pp]ress [A-Z][A-Za-z ]+|Presses|\b[Pp]?ress|Verlag Gmbh|[Vv]erlag|[Ll]imited|Media Group|Publ[\.]? Co[\.]|\, Inc[\.]?|Inc[\.]?|Ltd[\.]?|[Cc]ompany|Books|Institute|University)';

  $TextBody=~s/<pbl>([^<>]+?)<\/pbl>([\/\, ]*?)$publisherSuffix/<pbl>$1$2$3<\/pbl>/gs;

  $TextBody=~s/([\.\,\:]|\\newblock|<\/i>) ([\(]?)([^<>\,\.\:\;]+[\, ]*?)$publisherSuffix([\)\.]*?)([\,\:]?) ([\(]?<cny>|[\(]?<yr>|[pPS\. ]*?<pg>|[\(]?<doig>)/$1 $2<pbl>$3$4<\/pbl>$5$6 $7/gs;
  $TextBody=~s/([\.\,\:]|\\newblock|<\/i>) ([\(]?)([^<>\,\.\:\;]+[\, ]*?)$publisherSuffix([\)\.]*?)<\/bib>/$1 $2<pbl>$3$4<\/pbl>$5<\/bib>/gs;
 
  $TextBody=~s/<pbl>([^<>]+?)<\/pbl>([\.\,\: ]+)<cny>([^<>]+?)<\/cny>([\.\,\; ]+)<pbl>([Ii]n [pP]ress)<\/pbl>([\.]?)<\/bib>/<pbl>$1<\/pbl>$2<cny>$3<\/cny>$4$5$6<\/bib>/gs;
  #<cny>Chestnut Hill, MA</cny>: <pbl>TIMSS & PIRLS International Study Center, <cny>Boston</cny> College</pbl>
  $TextBody=~s/<pbl>([^<>]*?)<cny>([^<>]+?)<\/cny>([^<>]+?)<\/pbl>/<pbl>$1$2$3<\/pbl>/gs;

  $TextBody=~s/<bib([^<>]*?)>([^<>]+?)([\,\.\)]) ([^\.\,\:\;\)\(<>]+) $publisherSuffix ([^\.\:\,\;\)\(<>]+)\, <cny>([^<>]+?)<\/cny>((?:(?!<[\/]?pbl>)(?!<bib)(?!<\/bib>).)*?)<\/bib>/<bib$1>$2$3 <pbl>$4 $5 $6<\/pbl>\, <cny>$7<\/cny>$8<\/bib>/gs;
  $TextBody=~s/<bib([^<>]*?)>([^<>]+?)<pbl>([^<>]+)<\/pbl>\, ([A-Z]\.[A-Z]\.[A-Z]\.|[A-Z]\.[A-Z]\.|[A-Z]{2,3})([\.]?<\/bib>|[\.\,\( ]*<pg>|[\.\,\( ]*<url[g]?>|[\.\,\( ]*<doi[g]?>|[\.\,( ]*<comment>)/<bib$1>$2<pbl>$3<\/pbl>\, <cny>$4<\/cny>$5/gs;


  $TextBody=~s/ New Delhi\, <cny>India<\/cny>/ <cny>New Delhi\, India<\/cny>/gs;
  $TextBody=~s/<\/cny>([\,\:\;\.\/ ]+| \& | [au]nd )<cny>/$1/gs;
  $TextBody=~s/<cny>([^<>]+?)<\/cny> Patent([\,\.\;])/$1 Patent$2/gs;
  $TextBody=~s/<\/cny>\.([\:\;\,])/\.<\/cny>$1/gs;
  $TextBody=~s/<\/cny>([\/\-\, ]+)<cny>/$1/gs;
  $TextBody=~s/<\/pbl>([\/\-\, ]+)<pbl>/$1/gs;
  $TextBody=~s/<\/pbl>([\,\;\.\/] | \& | [au]nd )<pbl>/$1/gs;
  
  $TextBody=~s/\, (S|P)<\/cny>([\.\, ]+)<pg>/<\/cny>\, $1$2<pg>/gs;
  $TextBody=~s/([\,\.]?) (ISBN)<\/cny>/<\/cny>$1 $2/gs;

  $TextBody=~s/<pbl>([^<>]+?)<\/pbl>([\.\:\,\) ]+)([^<>]+?)([\.\:\,\) ]+)<pbl>([^<>]+?)<\/pbl>([\.\,\;\: ]+)<cny>/$1$2$3$4<pbl>$5<\/pbl>$6<cny>/gs;
  $TextBody=~s/<pbl>([^<>]+?)<\/pbl>([\.\:\,\) ]+)([^<>]+?)([\.\:\,\) ]+)<cny>([^<>]+?)<\/cny>([\.\,\;\: ]+)<pbl>/$1$2$3$4<cny>$5<\/cny>$6<pbl>/gs;
  $TextBody=~s/<pt>((?:(?!<[\/]?pt>)(?!<[\/]?pbl>)(?!<[\/]?cny>)(?!<bib)(?!<\/bib>).)*?)<\/pt>((?:(?!<[\/]?pt>)(?!<[\/]?pbl>)(?!<[\/]?cny>)(?!<bib)(?!<\/bib>).)*?)<(cny|pbl)>((?:(?!<[\/]?pt>)(?!<[\/]?pbl>)(?!<[\/]?cny>)(?!<bib)(?!<\/bib>).)*?)<\/\3>((?:(?!<[\/]?pt>)(?!<[\/]?pbl>)(?!<[\/]?cny>)(?!<bib)(?!<\/bib>).)*?)<v>/<pt>$1<\/pt>$2$4$5<v>/gs;
  $TextBody=~s/<pbl>$commonPubName<\/pbl>([\;\, ]+)<cny>([^<>]+?)<\/cny>([\:\, ]+)<pbl>/<cny>$1$2$3<\/cny>$4<pbl>/gs;
  $TextBody=~s/ <cny>([^<>]+?)\: $commonPubName<\/cny>([\.]?<\/bib>|[\.\, ]+<yr>|[\.\, ]+<comment>|[\.\, ]+<url>)/ <cny>$1<\/cny>\: <pbl>$2<\/pbl>$3/gs;

  $TextBody=~s/([\w\d\)]+[\.\,]?) <cny>([^<>]+?)\: ([^<>]+)<\/cny> ([^<>\.]+?)([\.]?<\/bib>|[\.\,]? <yr>|[\.\,]? <comment>|[\.\,]? <url>|\. )/$1 <cny>$2<\/cny>\: <pbl>$3 $4<\/pbl>$5/gs;
  $TextBody=~s/([\.\,]) <cny>([^<>]+)<\/cny>([\:\,]) <pbl>([^<>]+?)<\/pbl> <cny>([^<>]+?)<\/cny>/$1 <cny>$2<\/cny>$3 <pbl>$4 $5<\/pbl>/gs;


  $TextBody=~s/<cny>([^<>]+?)<\/cny>\; <cny>([^<>]+?)<\/cny>/<cny>$1\; $2<\/cny>/gs;
  $TextBody=~s/([\.\,>]) ([Vv]olume[s]?[\.]?|[Vv]ol[s]?[\.]?|[Jj]g[\.]?|Bd[\.]?|[vV]\.|H\.) <pbl>([0-9]+)\- /$1 $2 $3\- <pbl>/gs;
  $TextBody=~s/<pbl>([^<>]*?)<cny>([^<>]*?)<\/cny>([^<>]*?)<\/pbl>/<pbl>$1$2$3<\/pbl>/gs;

  $TextBody=~s/([A-Za-z]+) (of|in|at|from|for|f¸r|with|has|have|had|to) <cny>([^<>]+?)<\/cny>/$1 $2 $3/gs;

  $TextBody=~s/<\/cny>([\.\,\?\!\;] [Rr]ev[\.]?|[\.\,\?\!\;]?) ([\(]?)([0-9]+)( [rR]ev[\s\.]+|[\s\.]+)([Ee]dition|printing[\.]? edn|[eE]dn[\.]?|[eE][dD][\.]?|[Aa]ufl[\.]?|Bd[\.]?|[Aa]uflage[\.]?)([\)]?)([\.\,\:\;]?)/<\/cny>$1 $2<edn>$3<\/edn>$4$5$6$7/gs;
  $TextBody=~s/<\/cny>([\.\,\?\!\;] [Rr]ev[\.]?|[\.\,\?\!\;]?) ([\(]?)([0-9]+)([nr]d|th|st|<sup>[nr]d<\/sup>|<sup>th<\/sup>|<sup>st<\/sup>)( [rR]ev[\s\.]+|[\s\.]+)([Ee]dition|printing[\.]? edn|[eE]dn[\.]?|[eE][dD][\.]?|[Aa]ufl[\.]?|Bd[\.]?|[Aa]uflage[\.]?)([\)]?)([\.\,\:\;]?)/<\/cny>$1 $2<edn>$3<\/edn>$4$5$6$7$8/gs;

  $TextBody=~s/<cny>([^<>]+?)<\/cny>([^<>]+?)(et al[\.\,]?|et\. al[\.\,]?|[\(]?[eE]ditor[s]?[\.]?[\)]?|[\(]?[Hh]erausgeber[\.]?[\)]?|[\(]?\b[Ee]ds\b[\.]?[\)]?|\(\b[Ee]d\b[\.]?\)|[\(]?[Hh]rsg[\.]?[\)]?|[\(]?\b[Hh]g\b[\.]?[\)]?|[\(]?\bred\b[\.]?[\)]?)/$1$2$3/gs;
  $TextBody=~s/\, ([0-9\-]+)\. <cny>([^<>]+)<\/cny>\, <pt>([A-Z][A-Z])\: ([^<>0-9\.\,]+)<\/pt>\, ([vV]ol[\.]?)/\, $1\. <cny>$2, $3<\/cny>\: <pbl>$4<\/pbl>\, $5/gs;

  $TextBody=~s/<\/cny>([\.\,\: ]+)<pbl>$publisherSuffix<\/pbl> ([^<>0-9]+?)([\.]?<\/bib>)/<\/cny>$1<pbl>$2 $3<\/pbl>$4/gs;

  $TextBody=~s/<pt>([^<> ]+?)<\/pt> ([^<>0-9]+) <(cny|pbl)>([^<>]+)<\/\3>([\:\.\, ]+)<(cny|pbl)>([^<>]+?)<\/\6>/$1 $2 <$3>$4<\/$3>$5<$6>$7<\/$6>/gs;
  while($TextBody=~s/<comment>((?:(?!<[\/]?comment>)(?!<bib)(?!<\/bib>).)+?)<cny>([^<>]*?)<\/cny>((?:(?!<[\/]?comment>)(?!<bib)(?!<\/bib>).)*?)<\/comment>/<comment>$1$2$3<\/comment>/gs){}
  while($TextBody=~s/<url>((?:(?!<[\/]?url>)(?!<bib)(?!<\/bib>).)+?)<cny>([^<>]*?)<\/cny>((?:(?!<[\/]?url>)(?!<bib)(?!<\/bib>).)*?)<\/url>/<url>$1$2$3<\/url>/gs){}


  return $TextBody;
}
#=============================================================================================================================
sub PubNameMarkFromIni{
  my $TextBody=shift;
  my $application=shift;

  $TextBody=~s/([Ii]nstitute of )<pt>([Mm]edicine)<\/pt>/$1$2/gs;
  $TextBody=~s/([a-zA-Z]+) <pt>([^<>]+?)<\/pt>([\,\.\; ]+)<yr>([^<>]+?)<\/yr>([\.]?)<\/bib>/$1 $2$3<yr>$4<\/yr>$5<\/bib>/gs;
  my $commonPubName='(Cambridge|Oxford|Wageningen|Lincoln|Stanford|California|Houndmills|Harvard)';

  $PublisherNameRef=&readPubNameINI($SCRITPATH);
  #--------------------------------------------------
   #use ReferenceManager::PublisherNameDB;
   #$PublisherNameRef=&SortedPublisherNameDB;
  #---------------------------------------------------

  my ($sleepCounter, $sleep1, $sleep2)=(0, 0, 0);
  if (defined $application){
    if($application eq "AMPP" || $application eq "ampp"){
      $sleep1=0;
      $sleep2=0;

      # $sleep1=0.01;
      # $sleep2=0.001;
    }
  }
  
  foreach (@$PublisherNameRef)
   {
     my $PubName="$_";
     $PubName=~s/[ \t]/ /gs;
     $PubName=~s/([\s])$//gs;
     $PubName=~s/^([\s])//gs;
     $PubName=~s/[ \t]/ /gs;

     $TextBody=~s/([\?\!\.\;\:\'\"\,\`\(\)\/]+\s*|\\newblock\s*|‚Äù |‚Äô |[íî] |[Aa]uflage |[Pp]ublished by |<\/pbl> [ua]nd |<\/pbl> \& |<\/pbl>[ ]?\/[ ]?|<\/i> )\Q$PubName\E([\?\,\.\'\"\:\;\)\( ]?)<\/bib>/$1<pbl>$PubName<\/pbl>$2<\/bib>/gs;
     $TextBody=~s/([\?\!\.\;\:\'\"\,\`\(\)]+\s*|\\newblock\s*|‚Äù |‚Äô |[íî] |[Aa]uflage |[Pp]ublished by |<\/pbl> [ua]nd |<\/pbl> \& |<\/pbl>[ ]?\/[ ]?|<\/i> )\Q$PubName\E ([\(\[])/$1<pbl>$PubName<\/pbl> $2/gs;
     $TextBody=~s/([\?\!\.\;\:\'\"\,\`\(\)]+\s*|\\newblock\s*|‚Äù |‚Äô |[íî] |[Aa]uflage |[Pp]ublished by |<\/pbl> [ua]nd |<\/pbl> \& |<\/pbl>[ ]?\/[ ]?|<\/i> )\Q$PubName\E([\?\,\/\.\'\"\:\;\)]+|\&quot\;) /$1<pbl>$PubName<\/pbl>$2 /gs;
     $TextBody=~s/([\?\!\.\;\:\'\"\,\`\(\)]+\s*|\\newblock\s*|‚Äù |‚Äô |[íî] |[Aa]uflage |[Pp]ublished by |<\/pbl> [ua]nd |<\/pbl> \& |<\/pbl>[ ]?\/[ ]?|<\/i> )\Q$PubName\E([\?\,\/\.\'\"\:\;\)]+|\&quot\;)</$1<pbl>$PubName<\/pbl>$2</gs;
     $TextBody=~s/([\?\!\.\;\:\'\"\,\`\(\)]+\s*|\\newblock\s*|‚Äù |‚Äô |[íî] |[Aa]uflage |[Pp]ublished by |<\/pbl> [ua]nd |<\/pbl> \& |<\/pbl>[ ]?\/[ ]?|<\/i> )\Q$PubName\E([\?\,\/\.\'\"\:\;\)]+|\&quot\;)/$1<pbl>$PubName<\/pbl>$2/gs;
     $TextBody=~s/([\?\!\.\;\:\'\"\,\`\(\)]+\s*|\\newblock\s*|‚Äù |‚Äô |[íî] |[Aa]uflage |[Pp]ublished by |<\/pbl> [ua]nd |<\/pbl> \& |<\/pbl>[ ]?\/[ ]?|<\/i> )\Q$PubName\E([\)\,\/\:\; ]+|\&quot\; )(<yr>|<pg>)/$1<pbl>$PubName<\/pbl>$2$3/gs;
     $TextBody=~s/([\?\!\.\;\:\'\"\,\`\(\)]+\s*|\\newblock\s*|‚Äù |‚Äô |[íî] |[Aa]uflage |[Pp]ublished by |<\/pbl> [ua]nd |<\/pbl> \& |<\/pbl>[ ]?\/[ ]?|<\/i> )\Q$PubName\E([\)\.\, ]*?)(<\/bib>)/$1<pbl>$PubName<\/pbl>$2$3/gs;

     #select(undef, undef, undef, $sleep2);
      #if($sleepCounter == 5){
      #  $sleepCounter=0;
      #  select(undef, undef, undef, $sleep1);
      #}
     $sleepCounter++;

   }


  $TextBody=~s/ ([A-Z]\.) <pbl>([A-Z][a-z]+)<\/pbl> / $1 $2 /gs;



  my $publisherSuffix='([Uu]niversity [Pp]ress|[Pp]ublishing [Cc]ompany|[Pp]ublishing [Ll]imited|Publishing [Ll]td[\.]?|[Pp]ublications L[tT][dD][\.]?|[Pp]ublisher[s]? [Ll][tT][dD][\.]?|[Pp]ublications\, Inc[\.]?|[Pp]ublications Inc|[Pp]ublishing Inc|[Pp]ress [Ll]td[\.]?|[Ff]oundation [Pp]ress|[Pp]ress [Pp]ublication|[R]esearch [Ii]nstitute|Publishing[\,]? Co\.[\,]? Inc[\.]?|[Pp]ublishing[\,]? Corporation|[Pp]ublishing[\,]? Co[\.]?|[Cc]ompany Inc[\.]?|Pty Ltd[\.]?|[Pp]ublishing [Hh]ouse|[Pp]ress [Ii]nc[\.]?|[Pp]ublications|[Pp]ublishing|[Aa]ssociation|[Pp]ublisher[s]?|Univ[\.]? Press|[Pp]ress of [A-Za-z ]+|[Pp]ress and [A-Za-z ]+|[Pp]ress [A-Z][A-Za-z ]+|Presses|[Pp]?ress|Verlag Gmbh|[Vv]erlag|[Ll]imited|Media Group|Publ[\.]?[\,]? Co[\.]|Publ\.|\, Inc[\.]?|Inc[\.]?|Ltd[\.]?|[Cc]ompany|Books|Institute|University)';

  #Princeton
  $TextBody=~s/( [\(])([^<>\,\.\:\;\(]+[\, ]*?)\b$publisherSuffix([\)]?)([\,\:\;\.]?) ([\(]?<cny>|[\(]?<pbl>|[\(]?<yr>|[pPS\. ]*?<pg>|[\(]?<doig>)/$1<pbl>$2$3<\/pbl>$4$5 $6/gs;
  $TextBody=~s/([\.\,\:]|\\newblock|<\/i>) ([\(]?)([^<>\,\.\:\;\(]+[\, ]*?)\b$publisherSuffix([\)]?)([\,\:\;\.]?) ([\(]?<cny>|[\(]?<pbl>|[\(]?<yr>|[pPS\. ]*?<pg>|[\(]?<doig>)/$1 $2<pbl>$3$4<\/pbl>$5$6 $7/gs;


  $TextBody=~s/( [\(])([^<>\,\.\:\;\(]+[\, ]*?)\b$publisherSuffix([\)]?)([\,\:\;\.]) /$1<pbl>$2$3<\/pbl>$4$5 /gs;
  $TextBody=~s/([\.\,\:]|\\newblock|<\/i>) ([\(]?)([^<>\,\.\:\;\(]+[\, ]*?)\b$publisherSuffix([\)]?)([\,\:\;\.]) /$1 $2<pbl>$3$4<\/pbl>$5$6 /gs;
  $TextBody=~s/([\.\,\:]|\\newblock|<\/i>|\W) ([\(]?)([^<>\,\.\:\;\(]+[\, ]*?)\b$publisherSuffix([\)]?)([\,\:\;\.]) /$1 $2<pbl>$3$4<\/pbl>$5$6 /gs;
  $TextBody=~s/([\.\,\:]|\\newblock|<\/i>) ([\(]?)([^<>\,\.\:\;\(]+[\, ]*?)\b$publisherSuffix([\)\.]?)<\/bib>/$1 $2<pbl>$3$4<\/pbl>$5<\/bib>/gs;
  $TextBody=~s/\: <pbl>([a-z]+) ([^<>]+?)<\/pbl>/\: $1 $2/gs;

  #<pbl>Harvard</pbl> Press,
  $TextBody=~s/<pbl>([^<>]+?)<\/pbl>([\.\,\& ]+| [au]nd | [\w ]+ )$publisherSuffix([\)]?)([\,\:\;\.]?) ([\(]?<cny>|[\(]?<yr>|[pPS\. ]*?<pg>|[\(]?<doig>)/<pbl>$1$2$3<\/pbl>$4$5 $6/gs;
  $TextBody=~s/<pbl>([^<>]+?)<\/pbl>([\.\,\& ]+| [au]nd | [\w ]+ )$publisherSuffix([\)]?)([\,\:\;\.]) /<pbl>$1$2$3<\/pbl>$4$5 /gs;
  $TextBody=~s/<pbl>([^<>]+?)<\/pbl>([\.\,\& ]+| [au]nd | [\w ]+ )$publisherSuffix([\)\.]?)<\/bib>/<pbl>$1$2$3<\/pbl>$4<\/bib>/gs;
  $TextBody=~s/<pbl>(\b1[987][0-9][0-9][a-z]?|\b20[0-9][0-9][a-z]?|\bin press|\bn\.d\.[0-9]?|\bz\.d\.|\b16[0-9][0-9][a-z]?)([\.\)\,]) ([^<>]+?)<\/pbl>([^<>]+?)<pbl>/$1$2 $3$4<pbl>/gs;

  $TextBody=~s/ ([A-Z\- ]+\.) <pbl>([A-Z][a-z]+)<\/pbl>((?:(?!<[\/]?pt>)(?!<[\/]?pbl>)(?!<[\/]?cny>)(?!<bib)(?!<\/bib>).)*?)<pbl>/ $1 $2$3<pbl>/gs;

  $TextBody=~s/<\/pbl>([\,\:]) <pbl>$commonPubName<\/pbl>/<\/pbl>$1 <cny>$2<\/cny>/gs;
  $TextBody=~s/<pbl>$commonPubName<\/pbl>([\:\,]) <pbl>/<cny>$1<\/cny>$2 <pbl>/gs;
  $TextBody=~s/<pbl>$commonPubName<\/pbl>\, ([A-Z]+)\: <pbl>/$1\, $2\: <pbl>/gs;
  $TextBody=~s/<pbl>$commonPubName<\/pbl> (and [A-Za-z]+)\: <pbl>/<cny>$1 $2<\/cny>\: <pbl>/gs;
  $TextBody=~s/<pbl>$commonPubName<\/pbl>\: <pbl>$commonPubName ([^<>]+?)<\/pbl>/<cny>$1<\/pbl>\: <pbl>$2 $3<\/pbl>/gs;

  $TextBody=~s/\s*\\newblock\s*<pbl>/ <pbl>/gs;
  $TextBody=~s/<\/pbl>\.([\:\;\,])/\.<\/pbl>$1/gs;
  $TextBody=~s/www\.([^ ]+?)<pbl>([^<>]*?)<\/pbl>\.([^ ]+?)/www\.$1$2\.$3/gs;
  $TextBody=~s/www\.<pbl>([^<>]*?)<\/pbl>\.([^ ]+?)/www\.$1\.$2/gs;

  $TextBody=~s/<pbl>([^<>]+?) by ([^<>]+?)<\/pbl>/$1 by <pbl>$2<\/pbl>/gs;
  $TextBody=~s/ ([Pp]ublished [bB]y) <pbl>([tT]he [aA]uthor)<\/pbl>/ <pbl>$1 $2<\/pbl>/gs;
  $TextBody=~s/([\.\/] [Ii]n[\:\.]? |[\.\/]? [Ii]n[\:\.] )([^<>4-9\(\)\+\=]+?)<pbl>([^<> ]+)<\/pbl>([^<>4-9\(\)\+\=]+?)([\(]?)$regx{editorSuffix}([\)\;\.\, ])/$1$2$3$4$5$6$7/gs;
  #<bib id="bib1">Gold, <pbl>Thomas</pbl>
  $TextBody=~s/<bib([^<>]+?)>$regx{mAuthorFullSirName}\, <pbl>([^<> ]+)<\/pbl>/<bib$1>$2\, $3/gs;
  $TextBody=~s/<bib([^<>]+?)>$regx{mAuthorFullFirstName}\, <pbl>([^<> ]+)<\/pbl>/<bib$1>$2\, $3/gs;
  $TextBody=~s/\(([^<>]+?)([\.\:\,]) <pbl>([^<>\(\)]+?)\) ([^<>]+?)<\/pbl>/\($1$2 $3\) <pbl>$4<\/pbl>/gs;


  $TextBody=~s/\. ([A-Z][A-Z]+)\: <pbl>([^<>]+?)<\/pbl>([\.]?)<\/bib>/\. <cny>$1<\/cny>\: <pbl>$2<\/pbl>$3<\/bib>/gs;
  $TextBody=~s/([\:\,\.]) <pbl>(IEEE|IEEE\/ACM)<\/pbl> (Trans|[Tt]ransactions|[Cc]onference)/$1 $2 $3/gs;
  $TextBody=~s/<pbl>([^<>]+?)<\/pbl>([\,\; ]+)<pbl>([^<>]+?)<\/pbl>/<pbl>$1$2$3<\/pbl>/gs;
  $TextBody=~s/<pbl>([^<>]*?)<pbl>([^<>]*?)<\/pbl>([^<>]*?)<\/pbl>/<pbl>$1$2$3<\/pbl>/gs;
  $TextBody=~s/<pbl>([iI]n [pP]ress)<\/pbl>/$1/gs;
  $TextBody=~s/ ([iI]n)\: <pbl>([A-Z][^A-Z]+)<\/pbl>\, / $1\: $2\, /gs;

  while($TextBody=~s/<comment>((?:(?!<[\/]?comment>)(?!<bib)(?!<\/bib>).)+?)<pbl>([^<>]*?)<\/pbl>((?:(?!<[\/]?comment>)(?!<bib)(?!<\/bib>).)*?)<\/comment>/<comment>$1$2$3<\/comment>/gs){}


  return $TextBody;
}
#=============================================================================================================================



sub PubNameLocMarkFromIni{
  my $TextBody=shift;
  #Company New Delhi, India

  $PublisherNameRef=&readPubNameINI($SCRITPATH);
  $PublisherLocationRef=&readPubLocINI($SCRITPATH);

  #--------------------------------------------------------
   #use ReferenceManager::PublisherNameDB;
   #$PublisherNameRef=&SortedPublisherNameDB;
   #use ReferenceManager::PublisherLocationDB;
   #$PublisherLocationRef=&SortedPublisherLocationDB;
  #--------------------------------------------------------

  foreach my $Loc(@$PublisherLocationRef)
    {
      $PublisherName{$Loc}="";
    }
  foreach (@$PublisherNameRef)
   {
     my $PubName="$_";
     $PubName=~s/[ \t]/ /gs;
     $PubName=~s/([\s])$//gs;
     $PubName=~s/^([\s])//gs;
     $PubName=~s/[ \t]/ /gs;
      if($TextBody=~/([\?\!\.\;\:\'\"\,\`\(]+\s*|‚Äù |‚Äô |<\/i> )\Q$PubName\E ([^<>]*?)([\. ]*?)(<\/bib>|([SpP]+[\. ]*)<pg>)/)
        {
	  my $temploc=$2;
	  if(exists$PublisherName{$temploc})
	    {
	      $TextBody=~s/([\?\!\.\;\:\'\"\,\`\(]+\s*|‚Äù |‚Äô |<\/i> )\Q$PubName\E $temploc([\. ]*?)(<\/bib>|([SpP]+[\. ]*)<pg>)/$1<pbl>$PubName<\/pbl> <cny>$temploc<\/cny>$2$3/gs;
	    }
        }
     if($TextBody=~/([\?\!\.\;\:\'\"\,\`\(\)]+\s*|‚Äù |‚Äô |<\/i> )\Q$PubName\E <cny>([^<>]*?)<\/cny>/)
       {
	  my $temploc=$2;
	  if(exists$PublisherName{$temploc})
	    {
	      $TextBody=~s/([\?\!\.\;\:\'\"\,\`\(\)]+\s*|‚Äù |‚Äô |<\/i> )\Q$PubName\E <cny>$temploc<\/cny>/$1<pbl>$PubName<\/pbl> <cny>$temploc<\/cny>/gs;
	    }
        }

   }

  return $TextBody;
}
#=============================================================================================================================


sub readPubLocINI{
  my $SCRITPATH=shift;
  undef $/;
  open(PUBINI, "<$SCRITPATH/PublisherLocationDB.ini")||die("\n\n$SCRITPATH/PublisherLocationDB.ini File cannot be opened\n\nPlease check the file...\n\n");
  my  $PublisherLocationText=<PUBINI>;
  close(PUBINI);
  #my %PublisherLocationIni;
  my @PublisherLocationIni=();
  while($PublisherLocationText=~m/<PublisherLocation>(.*?)<\/PublisherLocation>/g){
#    $PublisherLocationIni{$1}="";
      push (@PublisherLocationIni, $1);
    }
  undef $PublisherLocationText;

  my @SortedPublisherLocationIni =  map { $_->[0] } sort { $b->[1] <=> $a->[1] } map { [ $_, length($_) ] } @PublisherLocationIni;

  return \@SortedPublisherLocationIni;
}

#=============================================================================================================================

sub readPubNameINI{
  my $SCRITPATH=shift;
  undef $/;
  open(PUBINI, "<$SCRITPATH/PublisherNameDB.ini")||die("\n\n$SCRITPATH/PublisherNameDB.ini File cannot be opened\n\nPlease check the file...\n\n");
  my  $PublisherNameText=<PUBINI>;
  close(PUBINI);
#  my %PublisherNameIni;
  my @PublisherNameIni=();
  while($PublisherNameText=~m/<PublisherName>(.*?)<\/PublisherName>/g){
 #       $PublisherNameIni{$1}="";
      push (@PublisherNameIni, $1);
    }
  undef $PublisherNameText;
  my @SortedPublisherNameIni =  map { $_->[0] } sort { $b->[1] <=> $a->[1] } map { [ $_, length($_) ] } @PublisherNameIni;

  return \@SortedPublisherNameIni;
}

#=============================================================================================================================


return 1;