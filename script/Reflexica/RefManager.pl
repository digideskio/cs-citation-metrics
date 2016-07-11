#!/usr/local/bin/perl
#Scope: Plain Reference Text to Markup Text (Tagged), Re-Structuring and A++ XML.
#Author: Neyaz Ahmad

#perl /etc/EXT/Citation_Metrics/script/Reflexica/RefManager.pl -f /etc/EXT/Citation_Metrics/Input/test/66_2014_712_test.htm -o color -x A++ -a Bookmetrix -c springerbookmetrix

#perl /home/rahulw/Citation_Metrics/BookMetrix/Reflexica/RefManager.pl -f /home/rahulw/Citation_Metrics/BookMetrix/LOGS/10.1007%2F978-0-387-77650-7_5_Ref.htm" -o color -x A++ -a Bookmetrix -c springerbookmetrix
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#(A) Doc/HTML Input
#  Scope: Structuring + Re-Structuring + A-plus-plus Springer XML
#  perlf d:/Working/ReferenceManager/newRefManager/RefManager.pl -f D:/RefeTest/master.htm -o color -s Basic -c Springer -l En -x A++ -a AMPP
#
#  Scope: Structuring + Re-Structuring
#  perlf d:/Working/ReferenceManager/newRefManager/RefManager.pl -f D:/RefeTest/master.htm -o color -s Basic -c Springer
#
#  Scope: Only Structuring
#  perlf d:/Working/ReferenceManager/newRefManager/RefManager.pl -f D:/RefeTest/master.htm -o color -c Springer
#
#  OLD Syntax
#(B) TeX/LaTeX Input
#  Scope: Structuring + Re-Structuring
#  perlf d:/Working/ReferenceManager/newRefManager/RefManager.pl -f D:/RefeTest/master.htm -o texcolor -s MPS -c Springer
#
#  Scope: Structuring
#  perlf d:/Working/ReferenceManager/newRefManager/RefManager.pl -f D:/RefeTest/master.htm -o texcolor -c Springer
#
#(C) A++ XML from Structured Document
#   perlf d:/Working/ReferenceManager/Refautostruct.pl d:/Working/ReferenceManager/test1/GeneralHtml.htm -o A++
#
#(D) A++ XML from Un-Structured Docoment (Manual structuring's task  xmltag
#   perlf d:/Working/ReferenceManager/Refautostruct.pl d:/Working/ReferenceManager/test1/GeneralHtml.htm -o xmltag
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


my $VERSION="3.6.1.0";
BEGIN {
    our $SCRITPATH=$0;
    $SCRITPATH=~s/(.*)([\/\\])(.*?)\.(pl|exe)/$1/g;
};

use lib "$SCRITPATH/lib";

#BEGIN{
 # system ("cls");
  #  our $SCRITPATH=$0;
  #  $SCRITPATH=~s/(.*)([\/\\])(.*?)\.(pl|exe)/$1/g;
#}

#perl2exe_include utf8
#perl2exe_include "unicore/Heavy.pl"
#perl2exe_include "unicore/Heavy.pl"
#perl2exe_include "unicore/lib/Gc/P.pl"
#perl2exe_include "unicore/lib/Gc/L.pl"
#perl2exe_include "unicore/lib/Gc/Lu.pl"
#perl2exe_include "unicore/lib/Gc/Ll.pl"
#===========================================================================================================================================

use strict;
use Getopt::Long ();

my $SCRITPATH=$0;
$SCRITPATH=~s/(.*)([\/\\])(.*?)\.(pl|exe)/$1/g;
my $command=$0;
my $scriptname=$command;
$scriptname=~s/(.*)([\/\\])(.*?)\.(pl|exe)/$3\.$4/g;

my $OPTIONvalue='(color|texcolor|xmltag|A\+\+)';
my $STYLEvalue='(none|MPS|MathPhysSci|mps|Basic|Chemistry|APS|Vancouver|APA|Chicago|ApaOrg|ElsAPA5|ElsVancouver|ElsACS)';
my $APPLICATIONvalue='(AMPP|Tex|Catalyst|Reflexica|Bookmetrix)';
my $CLIENTvalue='(springer|elsevier|springerlncs|springerbookmetrix)';
my $LANGUAGEvalue='(En|De)';
my $STYLEINIvalue='(bibstyle.ini)';

my $inputfname;
my $option;
my $style;
my $styleini='bibstyle.ini'; #default
my $language="EN"; #default 'EN' for Special Case otherwise 'En'
my $client;
my $application;
my $xmlOption;
my $help;
my $version;
my $perlmode;

Getopt::Long::GetOptions(
   'f|filelocation=s' => \$inputfname,
   'o|option=s' => \$option,
   's|style=s' => \$style,
   'i|styleini=s' => \$styleini,
   'l|language=s' => \$language,
   'c|client=s' => \$client,
   'a|application=s' => \$application,
   'x|xml=s' => \$xmlOption,
   'h|?|help' => \$help,
   'p|perlmode' => \$perlmode,
   'v|version' => \$version
)
or usage("Invalid commmand line options.");

if (defined $help) {
  &help;
}

 if (defined $version) {
   print "Version: $VERSION";
   exit 0;
 }

usage("The file name must be specified.")
   unless defined $inputfname;
usage("The option must be specified.")
   unless defined $option;
usage("The correct option must be specified.")
   unless $option=~/^$OPTIONvalue$/;

system("cls");
print "\n################################################################################\n\n";
print "Reference Structuring Inprocess...\n\n\n";
print "################################################################################\n\n";


chomp($inputfname);
chomp($xmlOption);
chomp($style);
chomp($option);
chomp($language);
our $InputFile=$inputfname;


if (defined $style){
  $style="MPS" if ($style eq "MathPhysSci" || $style eq "mps");
}

if (defined $client){
  $client="\L$client";
 }

my ($sleep1, $sleep2, $sleep3)=(0, 0, 0);
if (defined $application){
  if($application eq "AMPP" || $application eq "ampp"){
    $sleep1=1;
    $sleep2=0.3;
    $sleep3=0.5;
  }
}


my $ext=$1 if($inputfname=~s/\.([a-z]+)$//os);
$ARGV[0]=$InputFile;
$ARGV[1]=$option;
if (defined $style){
  $ARGV[2]=$style;
}else{
$ARGV[2]="none";
}

$ARGV[3]=$language;

if (defined $application){
  $ARGV[5]=$application;
}else{
  $ARGV[5]="Reflexica";
}

$ARGV[5]=$application;
$ARGV[4]=$xmlOption;

######################***** XML Option close ============

#-----------------------------------------------------
##use ReferenceManager::ExpiryDate;
##&CheckExpireDate;
#-----------------------------------------------------

use ReferenceManager::ReferenceRegex;
my %regx = ReferenceManager::ReferenceRegex::new();


if($option eq "color"){
  ##### Scope: Structuring / Structuring + Re-Structuring / Structuring + Re-Structuring + A-plus-plus Springer XML #####
  &HtmlInputStructuring($SCRITPATH, $inputfname, $ext); #HTML Source or Plain text source
}elsif($option eq "texcolor"){
  ##### Scope: Structuring / Structuring + Re-Structuring #####
  &TeXInputStructuring($SCRITPATH, $inputfname, $ext); #TeX/LaTeX Source
}elsif($option eq "xmltag"){
  ##### Scope: XML conversion #####
  my $SourceText=&main;   #Standard Marking
  use ReferenceManager::xmlConv;
  $xmlOption="A++"  if(!defined $xmlOption);
  if($application eq "Reflexica" or $application eq "Bookmetrix"){
    XmlTaging($SourceText, $inputfname, $ext, $xmlOption, $application);
  }
}elsif($option eq "A++"){
  ##### Scope: Springer A++ XML Generation from Structured Source ######
  $xmlOption="A++"  if(!defined $xmlOption);
  if($application eq "Reflexica" or $application eq "Bookmetrix"){
    &RefXML($InputFile, $ext, $xmlOption, $application);
  }
}else{
  system("cls");
  print "\n\nSorry!!!  Please place the correct arguments\n\n";
  &help;
}


sub usage {
  my $message = $_[0];
  if (defined $message && length $message) {
    $message .= "\n"
      unless $message =~ /\n$/;
  }
  print STDERR (
		$message,
		"usage: $command -f FileLocation -o $OPTIONvalue [-s $STYLEvalue] [-l $LANGUAGEvalue] [-c $CLIENTvalue] [-a $APPLICATIONvalue] [-i $STYLEINIvalue] [-x A++] [-h] [-v]\n\nOR\n\n" .
		"usage: $command -filelocation FileLocation -option $OPTIONvalue [-style $STYLEvalue] [-language $LANGUAGEvalue] [-client $CLIENTvalue] [-application $APPLICATIONvalue] [-styleini $STYLEINIvalue] [-xml A++] [-help] [-version]\n" .

		"       ...\n"
	       );
   die("\n")
 }

#===========================================================================================================================================
sub help{
  print "################################################################################\n";
  print "Scope : Plain Reference Text to Markup Text (Tagged), Re-Structuring and A++ XML\n\n\n";
  print "usage: $command -f FileLocation -o $OPTIONvalue [-s $STYLEvalue] [-l $LANGUAGEvalue] [-c $CLIENTvalue] [-a $APPLICATIONvalue] [-i $STYLEINIvalue] [-x A++] [-h] [-v]\n\nOR\n\n";
  print  "usage: $command -filelocation FileLocation -option $OPTIONvalue [-style $STYLEvalue] [-language $LANGUAGEvalue] [-client $CLIENTvalue] [-application $APPLICATIONvalue] [-styleini $STYLEINIvalue] [-xml A++] [-help] [-version]\n\n";

  print "\nScope: Only Structuring\t [Input Type: DOC/HTML/PlainText]\n";
  print "$command -f D:/RefeTest/master.htm -o color -c springer -a Reflexica\n";
  print "\n\tOR\n$command -filelocation D:/RefeTest/master.htm -option color -client springer -application Catalyst\n\n";

  print "\nScope: Structuring + Re-Structuring\t [Input Type: DOC/HTML/PlainText]\n";
  print "$command -f D:/RefeTest/master.htm -o color -s Basic -l En -c springer -a Reflexica\n\n";
  print "\n\tOR\n$command -filelocation D:/RefeTest/master.htm -option color -style MPS -language En -client springerlncs -application Catalyst\n\n";

  print "\nScope: Structuring + Re-Structuring\t [Input Type: TeX/LaTeX]\n";
  print "$command -f D:/RefeTest/master.htm -o texcolor -s MPS -l En -c springer -a Tex\n\n";
  print "\n\tOR\n$command -filelocation D:/RefeTest/master.htm -option texcolor -style Basic -language De -client elsevier -application Tex\n\n";

  print "\nScope: Only Structuring\t [Input Type: TeX/LaTeX]\n";
  print "$command -f D:/RefeTest/master.htm -o texcolor -c springer -a Reflexica\n";
  print "\n\tOR\n$command -filelocation D:/RefeTest/master.htm -option texcolor -client springerlncs -application Tex\n\n";

  print "################################################################################\n";
  exit;
}
#===========================================================================================================================================
sub main{

  use ReferenceManager::Cleanup;
  use ReferenceManager::mapping;
  use ReferenceManager::journal2tags;
  use ReferenceManager::PubNameLoc2Tags;
  use ReferenceManager::looseJournal;
  use ReferenceManager::TagCleanup;
  use ReferenceManager::AuthorEditorGrouping;
  use ReferenceManager::AuthorGroupBoundry;
  use ReferenceManager::TagValidation;
  use ReferenceManager::Label;


  my ($SourceText, $inputfname, $ext)=("", "", "");


  if($option eq "texcolor"){
    ($SourceText, $inputfname, $ext)=&GetTeXSourceData;
  }else{
    ($SourceText, $inputfname, $ext)=&GetSourceData;

  }
  my $TextBody="";
  if($SourceText=~/<petemp>(.*?)<\/petemp>/s){
    $TextBody=$1;
  }elsif($SourceText=~/<body([^<>]*?)>(.*?)<\/body>/s){
    $TextBody=$2;
  }else{
    $TextBody="$SourceText";
  }


  $TextBody=formatTextBody(\$TextBody);
  #select(undef, undef, undef, $sleep3);

  ($TextBody, my $symbolTableRef)=&SymbolFonts(\$TextBody); #Store Symbal in Hash Ref
  #select(undef, undef, undef, $sleep3);

  #print "preCleanup\n";
  $TextBody=preCleanup(\$TextBody, $application);
  #select(undef, undef, undef, $sleep3);

  #print "ID\n";
  my $bibidRef=&storeID(\$TextBody);
  #select(undef, undef, undef, $sleep3);

  #print "VIPY\n";
  $TextBody=YrVolIssPg($TextBody, $application);
  #select(undef, undef, undef, $sleep3);

  #print "VIP\n";
  $TextBody=VolIssPg($TextBody, $application);
  #select(undef, undef, undef, $sleep3);

  #print "P\n";
  $TextBody=loosePage($TextBody, $application);
  # #select(undef, undef, undef, $sleep1);
#  sleep(1);

  #print "Journal Start:\n";
  $TextBody=journalMarkFromIni($TextBody, $application);
  #print "Journal End:\n";
  #select(undef, undef, undef, $sleep2);

  $TextBody=looseJournalMark($TextBody);
  #select(undef, undef, undef, $sleep2);

  $TextBody=validateWithIni($TextBody);
  #select(undef, undef, undef, $sleep2);


  #print "Pub Name Start:\n";
  $TextBody=PubNameMarkFromIni($TextBody, $application);
  #print "Pub Name End:\n";
  #select(undef, undef, undef, $sleep1);

  #print "Pub Loc Start:\n";
  $TextBody=PubLocMarkFromIni($TextBody, $application);
  #print "Pub Loc End:\n";
  #select(undef, undef, undef, $sleep1);

  $TextBody=PubNameLocMarkFromIni($TextBody);
  #select(undef, undef, undef, $sleep2);


  $TextBody=&miscellaneous(\$TextBody);
  #select(undef, undef, undef, $sleep2);

  if($client eq "elsevier"){
    #start_here by Sanjeev Kumar Rai at 3/6/2014
    $TextBody = proceedings($TextBody);  # In: Proceedings of
    #end_here
  }elsif($client eq "springerlncs"){
    #start_here by Sanjeev Kumar Rai at 3/6/2014
    $TextBody = proceedings($TextBody);
    #end_here
  }

  $TextBody=authorMark($TextBody, $application);
  #select(undef, undef, undef, $sleep2);
								
  $TextBody=AtAndEdrgMarking(\$TextBody);  #<edrg> and <at>
  #select(undef, undef, undef, $sleep2);

  $TextBody=TagInsideTagClenup(\$TextBody);
  #select(undef, undef, undef, $sleep2);

  $TextBody=AuthorGroup($TextBody, "aug", "au", "aus", "auf");
  #select(undef, undef, undef, $sleep2);

  $TextBody=EditorGroup($TextBody, "edrg", "edr", "eds", "edm");
  #select(undef, undef, undef, $sleep2);

  $TextBody=MarkBookChapterTitle(\$TextBody);
  #select(undef, undef, undef, $sleep2);
  
  $TextBody=EndCommnetMarking(\$TextBody);
  #select(undef, undef, undef, $sleep2);


  if (defined $application){
    $TextBody=tagEditing(\$TextBody, $application);
  }else{
    $TextBody=tagEditing(\$TextBody);
  }
  #
  #select(undef, undef, undef, $sleep2);
  $TextBody=TagInsideTagClenup(\$TextBody);
  #select(undef, undef, undef, $sleep2);

  ###########$TextBody=applyBoundry(\$TextBody); #no need this function
  ##select(undef, undef, undef, $sleep2);


  if(!defined $style){
    if($client eq "springer"){
       $TextBody=removeComment(\$TextBody);
    }
  }else{
    if($style eq "none" and $client eq "springer"){
      $TextBody=removeComment(\$TextBody);
    }
  }


  $TextBody=MakeOtherRef($TextBody, $client);  #Validation 
  #select(undef, undef, undef, $sleep2);

  #$TextBody=&RefSort($TextBody);

  $TextBody=&TagtoEntityTag(\$TextBody);       #***** <at> Tag to &lt;at&gt;
  #select(undef, undef, undef, $sleep2);

  foreach my $KEY(keys %$symbolTableRef){
    my $symbolKEY="\&\#X$KEY\;";
    $TextBody=~s/$symbolKEY/$$symbolTableRef{$KEY}/s;
    $TextBody=~s/mso-symbol-font-family\:/font-family\:/gs;
  }

  $TextBody=~s/\-\-/\–/gs;
  $TextBody=~s/\&lt\;yr\&gt\;\(/\(\&lt\;yr\&gt\;/gs;
  $TextBody=~s/\n<span lang=EN-US>(.*?)<\/span>\n/\n<p class=Bib_entry><span lang=EN-US>$1<\/span><\/p>\n/gs;

 
  $SourceText=&ReplaceSourceText(\$SourceText, \$TextBody);

  #select(undef, undef, undef, $sleep2);


  return $SourceText;
}
#===========================================================================================================================================
sub TagtoEntityTag{
  my $TextBody=shift;
  my %htmlformatingtags=('i' => 'i', 'b' => 'b', 'u' => 'u', 'sup' => 'sup', 'sub'=> 'sub');
  my $atrString='^\"<>';
  my $tagString="a-zA-Z0-9\-";
  while($$TextBody=~/<bib id=\"([$atrString]+?)\">(.*?)<\/bib>/s){
    my $bibtext=$2;
    while($bibtext=~/<([$tagString]+)>/){
      my $bibtags=$1;
      if(exists $htmlformatingtags{$bibtags}){
	$bibtext=~s/<$bibtags>/<\#X$htmlformatingtags{$bibtags}>/gs;
	$bibtext=~s/<\/$bibtags>/<\/\#X$htmlformatingtags{$bibtags}>/gs;
      }else{
	$bibtext=~s/<$bibtags>/\&lt\;${bibtags}\&gt\;/gs;
	$bibtext=~s/<$bibtags ([^<>]+?)>/\&lt\;${bibtags} $1\&gt\;/gs;
	$bibtext=~s/<\/$bibtags>/\&lt\;\/${bibtags}\&gt\;/gs;
      }
    }
    $bibtext=~s/<([\/]?)\#X([$tagString]+)>/<$1$2>/gs;
    $bibtext=~s/</\&lt\;/gs;
    $bibtext=~s/>/\&gt\;/gs;
    $$TextBody=~s/<bib id=\"([$atrString]+?)\">(.*?)<\/bib>/<bibX id=\"$1\">$bibtext<\/bibX>/os;
  }
  $$TextBody=~s/<bibX id=\"([$atrString]+?)\">(.*?)<\/bibX>/<bib id=\"$1\">$2<\/bib>/gs;
  $$TextBody=~s/<bib id=\"([$atrString]+?)\">(.*?)<\/bib>/<span lang=EN-US><bib id=\"$1\">$2<\/bib><\/span>/gs;
  $$TextBody=~s/<bib id=\"([$atrString]+?)\">/\&lt\;bib id=\&quot\;$1\&quot\;&gt\;/gs;
  $$TextBody=~s/<bib id=\"([$atrString]+?)\" type="([a-zA-Z0-9\:\-\_ ]+)">/\&lt\;bib id=\&quot\;$1\&quot\; type=\&quot\;$2\&quot\;\&gt\;/gs;
  $$TextBody=~s/<([\/]?)bib>/\&lt\;$1bib&gt\;/gs;
  $$TextBody=~s/\&\#X([0-9]+)\&lt\;\/([a-z0-9]+)\&gt\;\;/\&\#X$1\;\&lt\;\/$2\&gt\;/gs;

  return $$TextBody;
}
#===========================================================================================================================================
sub SymbolFonts{
  my $TextBody=shift;
  my $ID=0;
  my %Symboltable=();

  $$TextBody=~s/<span ([^<>]*?)> <\/span>/ /gs; #for space
  #<span lang=EN-US style='font-family: "Helvetica","sans-serif"'>Øß</span>
  #<span([\s]+)lang=EN-US([\s]+)style=\'font-family:Symbol;background:#FF9933\'>b</span>
  while($$TextBody=~/<cspan c([^<>]*?)\'>([^<>]*?)<\/cspan>/s){
    my $symbols="<span lang\=EN\-US style\=\'font-family\:$1\'>$2<\/span>";
    $$TextBody=~s/<cspan c([^<>]*?)\'>([^<>]*?)<\/cspan>/&\#X$ID;/os;
    $Symboltable{$ID}="$symbols";
    $ID++;
  }

  $$TextBody=~s/<span([\s]+)lang\=([A-Za-z\-]+)([\s]+)style\=\'([^\'<>]*?)font-family\:([a-zA-Z0-9 \_\-\"\,\s]+)\'>([A-Z][a-z\-]+)([^<>]+?)<\/span>/$6$7/gs;
  $$TextBody=~s/<span([\s]+)lang\=([A-Za-z\-]+)([\s]+)style\=\'([^\'<>]*?)\'>(http|ftp|www)([^<>]+?)<\/span>/$5$6/gs;

  while($$TextBody=~/<span([\s]+)lang\=([A-Za-z\-]+)([\s]+)style\=\'([^\'<>]*?)font-family\:([a-zA-Z0-9 \_\-\"\,\s]+)\'>([^<>]*?)<\/span>/s){
    my $symbols="<span lang\=EN\-US style\=\'$4font-family\:$5\'>$6<\/span>";
    $$TextBody=~s/<span([\s]+)lang\=([A-Za-z\-]+)([\s]+)style\=\'([^\'<>]*?)font-family\:([a-zA-Z0-9 \_\-\"\,\s]+)\'>([^<>]*?)<\/span>/&\#X$ID;/os;
    $Symboltable{$ID}="$symbols";
    $ID++;
  }

  while($$TextBody=~/<span([\s]+)style\=\'([^\'<>]*?)font-family\:([a-zA-Z0-9 \_\-\"\,\s]+)\'>([^<>]*?)<\/span>/s){
    my $symbols="<span style\=\'$2font-family\:$3\'>$4<\/span>";
    $$TextBody=~s/<span([\s]+)style\=\'([^\'<>]*?)font-family\:([a-zA-Z0-9 \_\-\"\,\s]+)\'>([^<>]*?)<\/span>/&\#X$ID;/os;
    $Symboltable{$ID}="$symbols";
    $ID++;
  }
  $$TextBody=~s/<\/span>\&\#X([\&\#0-9A-Za-z\;]+)\;<span([\s]+)style\=\'([^\'<>]*?)font-family\:([a-zA-Z0-9 \_\-\"\,\s]+)\'>/\&\#X$1\;/gs;
  $$TextBody=~s/<\/span>\&\#X([\&\#0-9A-Za-z\;]+)\;<span([\s]+)lang=([A-Za-z\-]+)([\s]+)style\=\'([^\'<>]*?)font-family\:([a-zA-Z0-9 \_\-\"\,\s]+)\'>/\&\#X$1\;/gs;
  $$TextBody=~s/<\/span>\&\#X([\&\#0-9A-Za-z\;]+)\;<span([\s]+)lang=([A-Za-z\-]+)>/\&\#X$1\;/gs;
  return ($$TextBody, \%Symboltable) ;
}
#===========================================================================================================================================

sub miscellaneous{
  my $TextBody=shift;

  $$TextBody=~s/ <\/([a-zA-Z0-9]+)> /<\/$1> /gs;
  $$TextBody=~s/<([\/]?)(bib|aug|edrg|au|aus|edr|edm)>([A-Z\. \-]+) <pbl>([^<> ]+?)<\/pbl>\,/<$1$2>$3 $4\,/gs;
  $$TextBody=~s/([A-Z\. \-]+) <pbl>([^<> ]+?)<\/pbl>\, ([A-Z\. \-]+) /$1 $2\, $3 /gs;
  $$TextBody=~s/<bib id=\"<([a-z0-9]+)>([^<>]*?)<\/\1>\">/<bib id=\"$2\">/gs;
  $$TextBody=~s/\: <cny>$regx{noTagAnystring}<\/cny> lectures<\/i>/\: $1 lectures<\/i>/gs;

  $$TextBody=~s/<\/pt>([\.\,\; ]+)<v>((?:(?!<[\/]?v>)(?!<\/bib>).)*?)<\/v>([\)\.\,\:\;\( ]+)<iss>$regx{noTagAnystring}<\/iss>([\)\.\,\:\;\( ]+)<pg>$regx{noTagAnystring}<\/pg>([\.\,\; ]+)<cny>$regx{noTagAnystring}<\/cny>([\.\,\;\: ]+)<pbl>$regx{noTagAnystring}<\/pbl>/<\/pt>$1<v>$2<\/v>$3<iss>$4<\/iss>$5<pg>$6<\/pg>$7<comment>$8$9$10<\/comment>/gs;
  $$TextBody=~s/<\/pt>([\.\,\; ]+)<v>((?:(?!<[\/]?v>)(?!<\/bib>).)*?)<\/v>([\)\.\,\:\;\( ]+)<iss>$regx{noTagAnystring}<\/iss>([\)\.\,\:\;\( ]+)<pg>$regx{noTagAnystring}<\/pg>([\.\,\; ]+)<pbl>$regx{noTagAnystring}<\/pbl><\/bib>/<\/pt>$1<v>$2<\/v>$3<iss>$4<\/iss>$5<pg>$6<\/pg>$7<comment>$8<\/comment>/gs;
  $$TextBody=~s/<\/pt>([\.\,\; ]+)<v>((?:(?!<[\/]?v>)(?!<\/bib>).)*?)<\/v>([\.\,\;\: ]+)<pg>$regx{noTagAnystring}<\/pg>([\.\,\; ]+)<cny>$regx{noTagAnystring}<\/cny>([\.\,\;\: ]+)<pbl>$regx{noTagAnystring}<\/pbl>/<\/pt>$1<v>$2<\/v>$3<pg>$4<\/pg>$5<comment>$6$7$8<\/comment>/gs;


  $$TextBody=~s/(<\/pbl>|<\/cny>)([\:\;\,\. ]+)$regx{year}([\.\;\, ]+)$regx{pagePrefix}$regx{optionalSpace}$regx{page}([\.]?)<\/bib>/$1$2<yr>$3<\/yr>$4$5$6<pg>$7<\/pg>$8<\/bib>/gs;
  $$TextBody=~s/(<\/pbl>|<\/cny>)([\:\;\,\. ]+)$regx{year}([\.\;\, ]+)$regx{pagePrefix}$regx{optionalSpace}<pg>$regx{page}<\/pg>([\.]?)<\/bib>/$1$2<yr>$3<\/yr>$4$5$6<pg>$7<\/pg>$8<\/bib>/gs;

  $$TextBody=~s/<bib$regx{noTagOpString}>$regx{noTagAnystring} <pt>([^<>]+?)<\/pt> <v>$regx{noTagAnystring}<\/v>\, <pg>$regx{noTagAnystring}<\/pg>([\.\,\:\;]) ([^<>]+?)([\.\,\;\:]) <(pbl|cny)>$regx{noTagAnystring}<\/\9>, <(cny|pbl)>$regx{noTagAnystring}<\/\11>([\.]?)<\/bib>/<bib$1>$2 $3 $4\, $5$6 $7$8 <$9>$10<\/$9>, <$11>$12<\/$11>$13<\/bib>/gs;
  $$TextBody=~s/<bib$regx{noTagOpString}>$regx{noTagAnystring} ([\w ]+?) <v>$regx{noTagAnystring}<\/v>\, <pg>$regx{noTagAnystring}<\/pg>([\.\,\:\;]) ([^<>]+?)([\.\,\;\:]) <(pbl|cny)>$regx{noTagAnystring}<\/\9>, <(cny|pbl)>$regx{noTagAnystring}<\/\11>([\.]?)<\/bib>/<bib$1>$2 $3 $4\, $5$6 $7$8 <$9>$10<\/$9>, <$11>$12<\/$11>$13<\/bib>/gs;
  $$TextBody=~s/<bib$regx{noTagOpString}>$regx{noTagAnystring} <pt>([^<>]+?)<\/pt> <v>$regx{noTagAnystring}<\/v> <pg>$regx{noTagAnystring}<\/pg>([\.\,\:\;]) ([^<>]+?)([\.\,\;\:]) <(pbl|cny)>$regx{noTagAnystring}<\/\9>, <(cny|pbl)>$regx{noTagAnystring}<\/\11>([\.]?)<\/bib>/<bib$1>$2 $3 $4 $5$6 $7$8 <$9>$10<\/$9>, <$11>$12<\/$11>$13<\/bib>/gs;
  $$TextBody=~s/<bib$regx{noTagOpString}>$regx{noTagAnystring} ([\w ]+?) <v>$regx{noTagAnystring}<\/v> <pg>$regx{noTagAnystring}<\/pg>([\.\,\:\;]) ([^<>]+?)([\.\,\;\:]) <(pbl|cny)>$regx{noTagAnystring}<\/\9>, <(cny|pbl)>$regx{noTagAnystring}<\/\11>([\.]?)<\/bib>/<bib$1>$2 $3 $4 $5$6 $7$8 <$9>$10<\/$9>, <$11>$12<\/$11>$13<\/bib>/gs;

  $$TextBody=~s/<bib$regx{noTagOpString}>$regx{noTagAnystring} <pt><i>([^<>]+?)<\/i><\/pt> \(<v>$regx{noTagAnystring}<\/v>([\, ]*)<pg>$regx{noTagAnystring}<\/pg>\)([\.\,\:\; ]+)<(pbl|cny)>$regx{noTagAnystring}<\/\8>([\:\, ]+)<(cny|pbl)>$regx{noTagAnystring}<\/\11>([\.]?)<\/bib>/<bib$1>$2 <i>$3<\/i> \($4$5$6\)$7<$8>$9<\/$8>10<$11>$12<\/$11>$13<\/bib>/gs;
  #<pt><i>Annual Review of Psychology</i></pt> (Bd. 52, S. 141-166). <cny>Palo Alto, CA</cny>: <pbl>Annual Reviews</pbl>
  $$TextBody=~s/<bib$regx{noTagOpString}>$regx{noTagAnystring} <pt><i>([^<>]+?)<\/i><\/pt> \(([^<>]+?)\)([\.\,\:\; ]+)<(pbl|cny)>$regx{noTagAnystring}<\/\6>([\:\, ]+)<(cny|pbl)>$regx{noTagAnystring}<\/\9>([\.]?)<\/bib>/<bib$1>$2 <i>$3<\/i> \($4\)$5<$6>$7<\/$6>$8<$9>$10<\/$9>$11<\/bib>/gs;

  $$TextBody=~s/ ([A-Z\.\-]+)\, <pbl>([A-Za-z]+)<\/pbl> ([A-Z\.\-]+[\,]?) / $1\, $2 $3 /gs;
  $$TextBody=~s/([A-Z][a-z]+)\, <cny>([A-Z\. ]+)<\/cny>\, ([A-Z][a-z]+)\, ([A-Z\. ]+)/$1\, $2\, $3\, $4/gs;
  #, Jg</pt>. <v>
  $$TextBody=~s/(\,[\s]?)([Jj]g)<\/pt>([\.\:\; ]+)<v>/<\/pt>$1$2$3<v>/gs;
  #. S.329-348 In: Journal of European Public Policy 6: 2.</bib>
  $$TextBody=~s/([\.\,\:\? ]+)([SPp][\. ]+)(\d+[\–\-0-9]+)(\s*)([Ii]n[\:\.\,]?)(\s*)<pt>((?:(?!<\/pt>)(?!<bib)(?!<\/bib>)(?!<pt>).)*)<\/pt>([\, ]*?)<v>(\d+)<\/v>([\;\:\, ]+)<pg>(\d+)<\/pg>([\.]?)<\/bib>/$1$2<pg>$3<\/pg>$4$5$6<pt>$7<\/pt>$8<v>$9<\/v>$10<iss>$11<\/iss>$12<\/bib>/gs;
  #. S. 429-452 in: Comparative Political Studies 34.</bib>
  $$TextBody=~s/([\.\,\:\? ]+)([SPp][\. ]+)(\d+[\–\-0-9]+)(\s*)([Ii]n[\:\.\,]?)(\s*)<pt>((?:(?!<\/pt>)(?!<bib)(?!<\/bib>)(?!<pt>).)*)<\/pt>([\, ]*?)(\d+)([\.]?)<\/bib>/$1$2<pg>$3<\/pg>$4$5$6<pt>$7<\/pt>$8<v>$9<\/v>$10<\/bib>/gs;
  #S. 523-542 in KZfSS, <pt>Jg</pt>. <v>
  $$TextBody=~s/([\.\,\:\? ]+)([SPp][\. ]+)(\d+[\–\-0-9]+)(\s*)([Ii]n[\:\.\,]?)(\s*)([^0-9]+)([\,\. ]+)<pt>([jJ]g)<\/pt>([\,\. ]+)<v>/$1$2<pg>$3<\/pg>$4$5$6<pt>$7<\/pt>$8$9$10<v>/gs;
  #. S. 389-416 in: <pt>
  $$TextBody=~s/([\.\,\:\? ]+)([SPp][\. ]+)(\d+[\–\-0-9]+)(\s*)([Ii]n[\:\.\,]?)(\s*)<pt>/$1$2<pg>$3<\/pg>$4$5$6<pt>/gs;
  #-------------------------

  $$TextBody=~s/<pt>((?:(?!<\/pt>)(?!<pt>).)*)\. <cny>([^<>]*?)<\/cny>([\,\: ]+)<pbl>([^<>]*?)<\/pbl>([\,\.])<\/pt>/$1\. <cny>$2<\/cny>$3<pbl>$4<\/pbl>$5/gs;
  $$TextBody=~s/<\/cny>\: ([^0-9<>]+?)([\p{P}]?)<\/bib>/<\/cny>\: <pbl>$1<\/pbl>$2<\/bib>/gs;
  $$TextBody=~s/ (In|in)([\.\:\,]?) <pbl>$regx{noTagAnystring}<\/pbl>/ $1$2 $3/gs; #take care
  $$TextBody=~s/<\/pbl>([\, ]+)(pp|S)([\. ]+)([0-9\-]+)([\,\. ]+)<doig>/<\/pbl>$1$2$3<pg>$4<\/pg>$5<doig>/gs;
  $$TextBody=~s/  / /gs;
  $$TextBody=~s/ <pbl>([A-Z][a-z]+)<\/pbl>([\,]?) ([A-Z \.\-]+[\.\,]+)/ $1$2 $3/gs;
  $$TextBody=~s/ ([A-Z \.\-]+[\.\,]+) <cny>([A-Z][a-z]+)<\/cny>([\,]?) ([A-Z \.\-]+[\.\,]+)/ $1 $2$3 $4/gs;
  $$TextBody=~s/ ([A-Z \.\-]+[\.\,]+) <cny>([A-Z][a-z]+)<\/cny>([\,]?) ([A-Z \.\-]+) / $1 $2$3 $4 /gs;
  $$TextBody=~s/\, ([A-Z \.\-]+[\.\,]?) <cny>([A-Z][a-z]+)<\/cny>([\,]?) ([A-Z \.\-]+) /\, $1 $2$3 $4 /gs;
  $$TextBody=~s/\, ([A-Z \.\-]+[\.\,]?) <cny>([A-Z][a-z]+)<\/cny>([\,]?) ([A-Z \.\-]+[\.\,]?) /\, $1 $2$3 $4 /gs;
  $$TextBody=~s/<cny>([^<>]*?)<cny>$regx{noTagAnystring}<\/cny>([^<>]*?)<\/cny>/<cny>$1$2$3<\/cny>/gs;
  $$TextBody=~s/ ([A-Z\-])\. <(cny|pbl)>([A-Za-z]+)<\/\2>\. ([\(]?\d{4}[a-z]?[\)]?)/ $1\. $3\. $4/gs;
  $$TextBody=~s/<cny>([^<>]+?)<\/cny>([\, ]+[^<>]+?[\. ]+)<pt>/$1$2<pt>/gs;

  #<pt>Organic Synthesis: Theory and Applications, edited by T. Hudlicky (<pbl>JAI Press</pbl>, <cny>Greenwich, CT</cny>, 1993)</pt>
  $$TextBody=~s/<pt>((?:(?!<\/pt>)(?!<pt>).)*)(<pbl>[^<>]+?<\/pbl>[^<>]+?<cny>[^<>]+?<\/cny>)((?:(?!<\/pt>)(?!<pt>).)*)<\/pt>/$1$2$3/gs;
  $$TextBody=~s/<pt>((?:(?!<\/pt>)(?!<pt>).)*)([eE]dited by|\b[Ee]d[s][\.]? by\b|\([Ee]ds[\.]?\))((?:(?!<\/pt>)(?!<pt>).)*)<\/pt>/$1$2$3/gs;

  return $$TextBody;
}
#========================================================================================================================================

sub MarkBookChapterTitle{
  my $TextBody=shift;

  #-----misc-------------
  $$TextBody=~s/<\/edrg>([\.\:\, ]+?)$regx{noTagAnystring}<pt>$regx{noTagAnystring}<\/pt>([\.\, ]+)$regx{volumePrefix}([\.\, ]+)<v>/<\/edrg>$1<pt>$2$3<\/pt>$4$5$6<v>/gs;
  $$TextBody=~s/<cny>$regx{noTagAnystring}\: Princeton<\/cny>/<cny>$1<\/cny>\: <pbl>Princeton<\/pbl>/gs;
  $$TextBody=~s/<aus>([A-Z][a-z]+)<\/aus><\/au>\, Jr\.\,/<aus>$1<\/aus>\, <suffix>Jr\.<\/suffix><\/au>\,/gs;
  $$TextBody=~s/<\/eds> <edm><\/edm><\/edr>\, <edr>/<\/eds><edm><\/edm><\/edr>\, <edr>/gs;
  $$TextBody=~s/<\/edm> <eds><\/eds><\/edr>\, <edr>/<\/edm><eds><\/eds><\/edr>\, <edr>/gs;
  $$TextBody=~s/<\/aus> <auf><\/auf><\/au>\, <au>/<\/aus><auf><\/auf><\/au>\, <au>/gs;
  $$TextBody=~s/<\/auf> <aus><\/aus><\/au>\, <au>/<\/auf><aus><\/aus><\/au>\, <au>/gs;
  #<ia>In: Dieter Prokop (Hrsg.)</ia>

  $$TextBody=~s/<yr>$regx{year}<\/yr>\/$regx{year}/<yr>$1\/$2<\/yr>/gs;
  #$$TextBody=~s/<\/edrg>([\, ]+)$regx{editorSuffix}([\,\. ]+)$regx{edn}$regx{numberSuffix} $regx{ednSuffix}([\,\. ]+)<(pbl|cny)>/<\/edrg>$1$2$3<edn>$4<\/edn>$5 $6$7<$8>/gs;
  $$TextBody=~s/([\, ]+)$regx{editorSuffix}([\,\. ]+)$regx{edn}$regx{numberSuffix} $regx{ednSuffix}([\,\. ]+)<(pbl|cny)>/$1$2$3<edn>$4<\/edn>$5 $6$7<$8>/gs;

  #. 4th ed pp 936--947, <cny>
  $$TextBody=~s/([\.\, ]+)([0-9]+)$regx{numberSuffix} [eE][dD]([\.\, ]+)([pP][pP][\.]?|S[\.]?|p[\.]?)([ ]+)([0-9A-Z\-]+)\, <(cny|pbl)>/$1<edn>$2<\/edn>$3 ed$4$5$6<pg>$7<\/pg>, <$8>/gs;

  #####Return Refrence############
  $TextBody=iatoEdrg($TextBody);

  #</aug> (<yr>1987</yr>) <i>The Making of Democratic Streets</i>. Public Streets for Public Use. <edrg><edr><edm>A.</edm> <eds>Vernez Moudon</eds></edr>, Ed.</edrg> <cny>
  $$TextBody=~s/<\/(aug|yr|ia)>([\:\.\,\)]+ )<i>$regx{noTagAnystring}<\/i>([\.\,\? ]+)((?:(?!<bt>)(?!<collab>)(?!<[\/]?yr>)(?!<[\/]?pg>)(?!<edn>)(?!<edrg>)(?!<[\/]?bib>)(?!<[\/]?cny>)(?!<[\/]?pbl>).)+?)([\.\,\?\(]+ )<edrg>((?:(?!<[\/]?edrg>)(?!<[\/]?bib>)(?!<[\/]?cny>)(?!<[\/]?pbl>).)+?)<\/edrg>([\.\,\?\( ]+| et al[\.]?[\,]? [Ee]d[s]?\. )<(pbl|cny)>/<\/$1>$2<misc1><i>$3<\/i><\/misc1>$4<bt>$5<\/bt>$6<edrg>$7<\/edrg>$8<$9>/gs;
  $$TextBody=~s/<\/(aug|yr|ia)>([\:\.\,\)]+ )(|�|“|‘|�|[��]+)$regx{noTagAnystring}(|�|”|’||[�]+)([\.\,\? ]+)<i>((?:(?!<bt>)(?!<collab>)(?!<[\/]?yr>)(?!<[\/]?pg>)(?!<edn>)(?!<edrg>)(?!<[\/]?bib>)(?!<[\/]?cny>)(?!<[\/]?pbl>).)+?)<\/i>([\.\,\?\(]+ )<edrg>((?:(?!<[\/]?edrg>)(?!<[\/]?bib>)(?!<[\/]?cny>)(?!<[\/]?pbl>).)+?)<\/edrg>([\.\,\?\( ]+| et al[\.]?[\,]? [Ee]d[s]?\. )<(pbl|cny)>/<\/$1>$2$3<misc1>$4<\/misc1>$5$6<bt><i>$7<\/i><\/bt>$8<edrg>$9<\/edrg>$10<$11>/gs;
  $$TextBody=~s/<\/(aug|yr|ia)>([\:\.\,\)]+ )(|�|“|‘|�|[��]+)$regx{noTagAnystring}(|�|”|’||[�]+)([\.\,\? ]+)((?:(?!<bt>)(?!<collab>)(?!<[\/]?yr>)(?!<[\/]?pg>)(?!<edn>)(?!<edrg>)(?!<[\/]?bib>)(?!<[\/]?cny>)(?!<[\/]?pbl>).)+?)([\.\,\?\(]+ )<edrg>((?:(?!<[\/]?edrg>)(?!<[\/]?bib>)(?!<[\/]?cny>)(?!<[\/]?pbl>).)+?)<\/edrg>([\.\,\?\( ]+| et al[\.]?[\,]? [Ee]d[s]?\. )<(pbl|cny)>/<\/$1>$2$3<misc1>$4<\/misc1>$5$6<bt>$7<\/bt>$8<edrg>$9<\/edrg>$10<$11>/gs;
  $$TextBody=~s/<\/(aug|yr|ia)>([\:\.\,\)]+ )<i>$regx{noTagAnystring}<\/i>([\.\,\?]+ )<edrg>((?:(?!<[\/]?edrg>)(?!<[\/]?bib>)(?!<[\/]?cny>)(?!<[\/]?pbl>).)+?)<\/edrg>([\.\,\?\( ]+)<(pbl|cny)>/<\/$1>$2<bt><i>$3<\/i><\/bt>$4<edrg>$5<\/edrg>$6<$7>/gs;

  $$TextBody=~s/<\/edrg>([\:\.\,\) ]+)((?:(?!<bt>)(?!<collab>)(?!<[\/]?yr>)(?!<[\/]?pg>)(?!<edn>)(?!<edrg>)(?!<[\/]?bib>)(?!<[\/]?cny>)(?!<[\/]?pbl>).)+)([\.\,\?\( ]+)<pbl>/<\/edrg>$1<bt>$2<\/bt>$3<pbl>/gs;
  $$TextBody=~s/<\/edrg>([\:\.\,\) ]+)((?:(?!<bt>)(?!<collab>)(?!<[\/]?yr>)(?!<[\/]?pg>)(?!<edn>)(?!<edrg>)(?!<[\/]?bib>)(?!<[\/]?cny>)(?!<[\/]?pbl>).)+)([\.\,\?\( ]+)<cny>/<\/edrg>$1<bt>$2<\/bt>$3<cny>/gs;

  $$TextBody=~s/<\/ia>([\:\.\,\) ]+)((?:(?!<bt>)(?!<collab>)(?!<[\/]?yr>)(?!<[\/]?pg>)(?!<edn>)(?!<edrg>)(?!<[\/]?bib>)(?!<cny>)(?!<[\/]?pbl>).)+)([\.\,\?\( ]+)<pbl>/<\/ia>$1<bt>$2<\/bt>$3<pbl>/gs;
  $$TextBody=~s/<\/ia>([\:\.\,\) ]+)((?:(?!<bt>)(?!<collab>)(?!<[\/]?yr>)(?!<[\/]?pg>)(?!<edn>)(?!<edrg>)(?!<[\/]?bib>)(?!<cny>)(?!<[\/]?pbl>).)+)([\.\,\?\( ]+)<cny>/<\/ia>$1<bt>$2<\/bt>$3<cny>/gs;
  #</aug>. The naturalist on the Thames. <yr>1902</yr>. <cny>London</cny>: <pbl>
  $$TextBody=~s/<\/(aug|ia|edrg)>\. ((?:(?!<bt>)(?!<collab>)(?!<[\/]?yr>)(?!<[\/]?pg>)(?!<edn>)(?!<edrg>)(?!<[\/]?bib>)(?!<cny>)(?!<[\/]?pbl>).)+?)([\.\,] [\(]?)<yr>$regx{noTagAnystring}<\/yr>([\.\,\)] )<(cny|pbl)>/<\/$1>\. <bt>$2<\/bt>$3<yr>$4<\/yr>$5<$6>/gs;
  $$TextBody=~s/<\/edrg>([\,\;\.\) ]+)<bt>([\(]?)([eE]ditor[s]?|[eE]d[s]?|[Hh]rsg|[hH]g)([\.]?)([\);\,\.]*?)<\/bt>/<\/edrg>$1$2$3$4$5/gs;
  $$TextBody=~s/<\/edrg>([\,\;\.\) ]+)<bt>([\(]?)([eE]ditor[s]?|[eE]d[s]?|[Hh]rsg|[hH]g)([\.]?)([\);\,\.]*? )/<\/edrg>$1$2$3$4$5<bt>/gs;#biswajit


  #<bt>Ed.;</bt>
  #</yr>) Sleep and dreaming. In “Principles of Neural Science” <edrg>
  $$TextBody=~s/<\/yr>([\:\.\,\) ]+)((?:(?!<edrg>)(?!<[\/]?bib>)(?!<yr>)(?!<aug>)(?!<[\/]?bt>).)+)([\.\,\? ]+)In (“|``)((?:(?!<edrg>)(?!<[\/]?bib>)(?!<yr>)(?!<aug>)(?!<[\/]?bt>).)+)(”|\'\')([\.\,\? ]*)<edrg>/<\/yr>$1<misc1>$2<\/misc1>$3In $4<bt>$5<\/bt>$6$7<edrg>/gs;
  $$TextBody=~s/<\/yr>([\:\.\,\) ]+)((?:(?!<edrg>)(?!<[\/]?bib>)(?!<yr>)(?!<aug>)(?!<[\/]?collab>)(?!<[\/]?bt>).)+)([\.\,\? ]+)<edrg>/<\/yr>$1<misc1>$2<\/misc1>$3<edrg>/gs;
  $$TextBody=~s/<\/aug>([\:\.\,\) ]+)((?:(?!<edrg>)(?!<[\/]?bib>)(?!<yr>)(?!<aug>(?!<[\/]?collab>))(?!<[\/]?bt>).)+)([\.\,\? ]+)<edrg>/<\/aug>$1<misc1>$2<\/misc1>$3<edrg>/gs;
  $$TextBody=~s/<\/yr>([\:\.\,\) ]+)((?:(?!<edrg>)(?!<\/bib>)(?!<yr>)(?!<aug>)(?!<[\/]?collab>)(?!<\/bt>).)+)([\.\,\? ]+)<ia>/<\/yr>$1<misc1>$2<\/misc1>$3<ia>/gs;
  $$TextBody=~s/<\/aug>([\:\.\,\) ]+)((?:(?!<edrg>)(?!<\/bib>)(?!<yr>)(?!<aug>)(?!<[\/]?collab>)(?!<\/bt>).)+)([\.\,\? ]+)<ia>/<\/aug>$1<misc1>$2<\/misc1>$3<ia>/gs;

  $$TextBody=~s/<\/(yr|aug|ia)>([\:\.\,\) ]+)((?:(?!<edrg>)(?!<\/bib>)(?!<yr>)(?!<aug>)(?!<[\/]?collab>)(?!<\/bt>).)+)([\.\,\? ]+)([Ii]n[: ]+)<bt>/<\/$1>$2<misc1>$3<\/misc1>$4$5<bt>/gs;

  $$TextBody=~s/<\/edrg>([\.\:\;\,\(\) ]+)<bt>$regx{editorSuffix}([\.\:\;\:\,\) \(]+)$regx{year}([\.\:\;\:\,\) \(]+)$regx{pagePrefix}$regx{optionalSpace}$regx{page}([\.\,\;]?)<\/bt>/<\/edrg>$1$2$3<yr>$4<\/yr>$5$6$7<pg>$8<\/pg>$9/gs;


  $$TextBody=~s/<misc1>((?:(?!<misc1>)(?!<\/misc1>)(?!<yr>).)*)<(cny|pbl|yr)>([^<>]*?)<\/\2>((?:(?!<misc1>)(?!<\/misc1>)(?!<yr>).)*?)<\/misc1>/<misc1>$1$3$4<\/misc1>/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\:\.\,\) ]+)((?:(?!<[\/]?edrg>)(?!<[\/]?bib>)(?!<[\/]?yr>)(?!<[\/]?misc1>)(?!<[\/]?aug>)(?!<[\/]?ia>)(?!<[\/]?collab>)(?!<\/bt>).)+)([\.\;\,\? ]+)([iI]n) <bt>((?:(?!<[\/]?bib>)(?!<[\/]?edrg>)(?!<[\/]?bt>).)*)<\/bt>([\,\.]?) ([eE]d[s]?[.]? [bB]y|[eE]dited by) <edrg>/<\/$1>$2<misc1>$3<\/misc1>$4$5 <bt>$6<\/bt>$7 $8 <edrg>/gs;

  #</aug> Selecting the Correct pH Value for HPLC. In <bt>; <edrg>
  $$TextBody=~s/<\/(aug|ia|yr)>([\:\.\,\) ]+)((?:(?!<[\/]?edrg>)(?!<[\/]?bib>)(?!<[\/]?yr>)(?!<[\/]?misc1>)(?!<[\/]?aug>)(?!<[\/]?ia>)(?!<[\/]?collab>)(?!<\/bt>).)+)([\.\;\,\? ]+)([iI]n) <bt>((?:(?!<[\/]?bib>)(?!<[\/]?edrg>)(?!<[\/]?bt>).)*)<\/bt>([\,\;\. ]+)<edrg>/<\/$1>$2<misc1>$3<\/misc1>$4$5 <bt>$6<\/bt>$7 <edrg>/gs;

  $$TextBody=~s/<\/yr>([\:\.\,\) ]+)((?:(?!<[\/]?edrg>)(?!<[\/]?bib>)(?!<[\/]?yr>)(?!<[\/]?aug>)(?!<[\/]?pbl>)(?!<[\/]?ia>)(?!<[\/]?cny>)(?!<[\/]?bt>)(?!<[\/]?collab).)+?)([\:\.\,\?\( ]+)((?:[Ii]n[\.\:\,\; ])?\s*<collab)/<\/yr>$1<misc1>$2<\/misc1>$3$4/gs;
  $$TextBody=~s/<\/aug>([\:\.\,\) ]+)((?:(?!<[\/]?edrg>)(?!<[\/]?bib>)(?!<[\/]?yr>)(?!<[\/]?aug>)(?!<[\/]?pbl>)(?!<[\/]?ia>)(?!<[\/]?cny>)(?!<[\/]?bt>)(?!<[\/]?collab).)+?)([\:\.\,\?\( ]+)((?:[Ii]n[\.\:\,\; ])?\s*<collab)/<\/aug>$1<misc1>$2<\/misc1>$3$4/gs;
  #</yr>). Interactional sociolinguistics: A personal perspective. In <i>The handbook of discourse analysis</i> (pp. 215--228). <cny>
  $$TextBody=~s/<\/(yr|aug|ia)>([\:\.\,\)]+ )((?:(?!<[\/]?edrg>)(?!<[\/]?bib>)(?!<[\/]?yr>)(?!<[\/]?misc1>)(?!<[\/]?aug>)(?!<[\/]?ia>)(?!<[\/]?collab>)(?!<\/bt>).)+)([\.\;\,\?] +)([iI]n) <i>$regx{noTagAnystring}<\/i>([\.\, ]+)/<\/$1>$2<misc1>$3<\/misc1>$4$5 <bt><i>$6<\/i><\/bt>$7/gs;


  #</aug>. The multiple ligament injured knee: what I have learned. In, <bt>The Multiple Ligament Injured Knee. A Practical Guide to Management. Second Edition</bt>. Editor: <edrg>
  $$TextBody=~s/<\/(yr|aug|ia)>([\:\.\,\)]+ )((?:(?!<[\/]?edrg>)(?!<[\/]?bib>)(?!<[\/]?yr>)(?!<[\/]?misc1>)(?!<[\/]?aug>)(?!<[\/]?ia>)(?!<[\/]?collab>)(?!<\/bt>).)+)([\.\;\,\?] +)([iI]n[\,\.]?) <bt>((?:(?!<[\/]?edrg>)(?!<[\/]?bib>)(?!<[\/]?bt>).)+)<\/bt>((?:(?!<[\/]?edrg>)(?!<[\/]?bib>)(?!<[\/]?yr>)(?!<[\/]?misc1>)(?!<[\/]?aug>)(?!<[\/]?ia>)(?!<[\/]?collab>)(?!<\/bt>).)+)<edrg>/<\/$1>$2<misc1>$3<\/misc1>$4$5 <bt>$6<\/bt>$7<edrg>/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\:\.\,\)]+ )((?:(?!<[\/]?edrg>)(?!<[\/]?bib>)(?!<[\/]?yr>)(?!<[\/]?misc1>)(?!<[\/]?aug>)(?!<[\/]?ia>)(?!<[\/]?collab>)(?!<\/bt>).)+)([\.\;\,\?] +)([iI]n[\,\:\.]?) <edrg>((?:(?!<[\/]?edrg>)(?!<[\/]?bib>)(?!<[\/]?bt>).)+)<\/edrg>((?:(?!<[\/]?edrg>)(?!<[\/]?bib>)(?!<[\/]?yr>)(?!<[\/]?misc1>)(?!<[\/]?aug>)(?!<[\/]?ia>)(?!<[\/]?bt>).)+)<bt>/<\/$1>$2<misc1>$3<\/misc1>$4$5 <edrg>$6<\/edrg>$7<bt>/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\:\.\,\)]+ )((?:(?!<[\/]?edrg>)(?!<[\/]?bib>)(?!<[\/]?yr>)(?!<[\/]?misc1>)(?!<[\/]?aug>)(?!<[\/]?ia>)(?!<[\/]?collab>)(?!<\/bt>).)+)([\.\;\,\?] +)<edrg>([iI]n[\,\:\.]?) ((?:(?!<[\/]?edrg>)(?!<[\/]?bib>)(?!<[\/]?bt>).)+)<\/edrg>((?:(?!<[\/]?edrg>)(?!<[\/]?bib>)(?!<[\/]?yr>)(?!<[\/]?misc1>)(?!<[\/]?aug>)(?!<[\/]?ia>)(?!<[\/]?bt>).)+)<bt>/<\/$1>$2<misc1>$3<\/misc1>$4<edrg>$5 $6<\/edrg>$7<bt>/gs;

  #-----------------------------------------------------------------------------------------------------------------------------------------------------
  $$TextBody=~s/<\/yr>([\:\.\,\) ]+)((?:(?!<[\/]?edrg>)(?!<[\/]?bib>)(?!<[\/]?yr>)(?!<[\/]?pg>)(?!<[\/]?aug>)(?!<[\/]?pbl>)(?!<[\/]?ia>)(?!<[\/]?cny>)(?!<[\/]?bt>)(?!<[\/]?collab).)+?)([\:\.\,\?\( ]+)<(cny|pbl)>/<\/yr>$1<bt>$2<\/bt>$3<$4>/gs;
  #$$TextBody=~s/<\/yr>([\:\.\,\) ]+)((?:(?!<[\/]?edrg>)(?!<[\/]?bib>)(?!<[\/]?yr>)(?!<[\/]?aug>)(?!<[\/]?pbl>)(?!<[\/]?ia>)(?!<[\/]?cny>)(?!<[\/]?bt>)(?!<[\/]?collab).)+?)([\:\.\,\?\( ]+)<pbl>/<\/yr>$1<bt>$2<\/bt>$3<pbl>/gs;

  $$TextBody=~s/<\/aug>([\:\.\,\) ]+)((?:(?!<[\/]?edrg>)(?!<[\/]?bib>)(?!<[\/]?yr>)(?!<[\/]?pg>)(?!<[\/]?aug>)(?!<[\/]?pbl>)(?!<[\/]?ia>)(?!<[\/]?cny>)(?!<[\/]?bt>)(?!<[\/]?collab).)+?)([\:\.\,\?\( ]+)<(cny|pbl)>/<\/aug>$1<bt>$2<\/bt>$3<$4>/gs;
  #$$TextBody=~s/<\/aug>([\:\.\,\) ]+)((?:(?!<[\/]?edrg>)(?!<[\/]?bib>)(?!<[\/]?yr>)(?!<[\/]?aug>)(?!<[\/]?pbl>)(?!<[\/]?ia>)(?!<[\/]?cny>)(?!<[\/]?bt>)(?!<[\/]?collab).)+?)([\:\.\,\?\( ]+)<pbl>/<\/aug>$1<bt>$2<\/bt>$3<pbl>/gs;

  $$TextBody=~s/<\/ia>([\:\.\,\) ]+)((?:(?!<[\/]?edrg>)(?!<[\/]?bib>)(?!<[\/]?yr>)(?!<[\/]?pg>)(?!<[\/]?aug>)(?!<[\/]?pbl>)(?!<[\/]?ia>)(?!<[\/]?cny>)(?!<[\/]?bt>)(?!<[\/]?collab).)+?)([\:\.\,\?\( ]+)<(cny|pbl)>/<\/ia>$1<bt>$2<\/bt>$3<$4>/gs;
  #$$TextBody=~s/<\/ia>([\:\.\,\) ]+)((?:(?!<[\/]?edrg>)(?!<[\/]?bib>)(?!<[\/]?yr>)(?!<[\/]?aug>)(?!<[\/]?pbl>)(?!<[\/]?ia>)(?!<[\/]?cny>)(?!<[\/]?bt>)(?!<[\/]?collab).)+?)([\:\.\,\?\( ]+)<pbl>/<\/ia>$1<bt>$2<\/bt>$3<pbl>/gs;

  $$TextBody=~s/<bt>((?:(?!<[\/]?bt>)(?!<[\/]?bib>).)*?)([\:\;\.\,\) ]+)<collab>((?:(?!<[\/]?collab>)(?!<[\/]?bib>).)*?)<\/collab>([\:\;\.\,\) ]+)<\/bt>/<misc1>$1<\/misc1>$2<collab>$3<\/collab>$4/gs;
  $$TextBody=~s/<bib([^<>]*?)><i>$regx{noTagAnystring}<\/i>([\;\,\.\, ]+)<(pbl|cny|edrg)>/<bib$1><bt>$2<\/bt>$3<$4>/gs;
  $$TextBody=~s/(<\/aug>|<\/ia>)([\:\.\,]) ((?:(?!<[\/]?edrg>)(?!<[\/]?bib>)(?!<[\/]?yr>)(?!<[\/]?aug>)(?!<[\/]?pbl>)(?!<[\/]?ia>)(?!<[\/]?cny>)(?!<[\/]?bt>)(?!<[\/]?collab).)+?)([\.\,]) ([Ii]n[:]?) <bt>/$1$2 <misc1>$3<\/misc1>$4 $5 <bt>/gs;

  $$TextBody=~s/<\/(aug|yr|ia)>([\:\.\,\) ]+)((?:(?!<[\/]?edrg>)(?!<[\/]?bib>)(?!<[\/]?yr>)(?!<[\/]?pg>)(?!<[\/]?aug>)(?!<[\/]?pbl>)(?!<[\/]?ia>)(?!<[\/]?cny>)(?!<[\/]?bt>)(?!<[\/]?collab).)+?)([\:\.\,\?\( ]+)<(edn|pg|v)>((?:(?!<[\/]?edrg>)(?!<[\/]?bib>)(?!<[\/]?yr>)(?!<[\/]?aug>)(?!<[\/]?pbl>)(?!<[\/]?ia>)(?!<[\/]?cny>)(?!<[\/]?bt>)(?!<[\/]?collab).)+?)<(pbl|cny)>/<\/$1>$2<bt>$3<\/bt>$4<$5>$6<$7>/gs;
  

  $$TextBody=~s/<(bt|misc1|at|collab)>([eE]ditor[s]?|[eE]d[s]?|[Hh]rsg|[hH]g)([\.\, ]+)/$2$3<$1>/gs;
  $$TextBody=~s/<(bt|misc1|at|collab)><i>([eE]ditor[s]?[\.]?|[eE]d[s]?[\.]?|[Hh]rsg[\.]?|[hH]g[\.]?)<\/i>([\.\, ]+)/<i>$2<\/i>$3<$1>/gs;
  $$TextBody=~s/<bt>$regx{editorSuffix}\)([\.\:\,]+) $regx{noTagAnystring}<\/bt>/$1\)$2 <bt>$3<\/bt>/gs;
  $$TextBody=~s/<bt>$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionalPunc}<\/bt>/$1$2<pg>$3<\/pg>$4/gs;
  $$TextBody=~s/<bt>$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{optionalPunc}<\/bt>/$1$2<v>$3<\/v>$4/gs;
  $$TextBody=~s/<bt>$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{puncSpace}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionalPunc}<\/bt>/$1$2<v>$3<\/v>$4$5$6<pg>$7<\/pg>$8/gs;


  $$TextBody=~s/<bt><ct>((?:(?!<[\/]?bt>)(?!<[\/]?ct>)(?!<\/bib>).)*?)<\/ct><\/bt>/<bt>$1<\/bt>/gs;
  $$TextBody=~s/<bt><ct>((?:(?!<[\/]?bt>)(?!<[\/]?ct>)(?!<\/bib>).)*?)<\/ct>([\.\,\;\:\s\w\d]+)<\/bt>/<bt>$1<\/bt>$2/gs;
  $$TextBody=~s/<ct>((?:(?!<aug>)(?!<edrg>)(?!<pt>)(?!<[\/]?at>)(?!<[\/]?yr>)(?!<bib[^<>]*?>).)*)<\/ct>((?:(?!<[\/]?ct>)(?!<[\/]?bt>)(?!<[\/]?bib[^<>]*?>).)*)<bt>/<misc1>$1<\/misc1>$2<bt>/gs; #for bib tex modules

  $$TextBody=~s/<\/(aug|yr)>([\)\.\:\;\, ]+)<misc1>([^<>]+?)<\/misc1>([\.\,\:\; ]+)<edrg>((?:(?!<[\/]?bt>)(?!<[\/]?edrg>)(?!<\/bib>).)*?)<\/edrg>((?:(?!<[\/]?bt>)(?!<[\/]?misc1>)(?!<[\/]?bt>)(?!<[\/]?edrg>)(?!<\/bib>).)*?)<(cny|pbl)>/<\/$1>$2<bt>$3<\/bt>$4<edrg>$5<\/edrg>$6<$7>/gs;
  $$TextBody=~s/([\.\,\; ]+)$regx{editorSuffix}([\:\.\,]?)<\/bt>/<\/bt>$1$2$3/gs;


  #----------------------------------------------------------------------------------------------------------------------
  $TextBody=PubLocMarkNexToBt($TextBody);  # Return Ref
  $TextBody=PubNameMarkNexToBt($TextBody); # Return Ref
  #-----------------------------------------------------------------------------------------------------------------------

#</aug> “Environmental Management of the Saguling Dam.” (<yr>1989</yr>) <misc1>Guidelines of Lake Management, Volume One: Principles of Lake Management (2nd edition).</misc1> <edrg>
  $$TextBody=~s/<\/(aug|ia)> $regx{allLeftQuote}([^<>]+?)$regx{allRightQuote}([\.\, \(]+)<yr>$regx{year}<\/yr>([\)\.\,\: ]+)<misc1>([^<>]+?)<\/misc1>([\.\,\:\;\(\) ]+)<edrg>/<\/$1> $2<misc1>$3<\/misc1>$4$5<yr>$6<\/yr>$7<bt>$8<\/bt>$9<edrg>/gs;

  my $AuthorString="A-Za-zßØÃﬂ¡ýÿþÜÛÚÙØÖÕÔÓÒÑÐÏÎÍÌËÊÈÉÇÆŒœšŠÅÄÂÁÀñïïîííêçæåãâáõôóòùúûéèàäćíÃüöİı…â€™Ã¦Ã³Ã±Ã˜Ã¤Ã§Ã®Ã¨ÃŸÃ¼Ã¶Ã©Ã¥Ã¸`’\\\-Ã‡Ã–\\\"–\\\-\\\�����������������������������������������������'";

  $$TextBody=~s/<ia>In ([A-Z][a-z]+ [A-Za-z][a-z]+ [A-Za-z]+ [^<>]+?) $regx{editorSuffix}<\/ia> <bt>([$AuthorString ]+)([\,]?) $regx{firstName}([\,]?) $regx{noTagAnystring} ([$AuthorString ]+)([\,]?) $regx{firstName}<\/bt>/In <bt>$1<\/bt> $2 <edrg>$3$4 $5$6 $7 $8$9 $10<\/edrg>/gs;
  $$TextBody=~s/<ia>In ([A-Z][a-z]+ [A-Za-z][a-z]+ [A-Za-z]+ [^<>]+?) $regx{editorSuffix}<\/ia> <bt>([$AuthorString ]+)([\,]?) $regx{firstName}<\/bt>/In <bt>$1<\/bt> $2 <edrg>$3$4 $5<\/edrg>/gs;
  $$TextBody=~s/<ia>In ([A-Z][a-z]+ [A-Za-z][a-z]+ [A-Za-z]+ [^<>]+?) $regx{editorSuffix}<\/ia> <bt>$regx{firstName}([\,]?) ([$AuthorString ]+)([\,]?) $regx{noTagAnystring} $regx{firstName}([\,]?) ([$AuthorString ]+)<\/bt>/In <bt>$1<\/bt> $2 <edrg>$3$4 $5$6 $7 $8$9 $10<\/edrg>/gs;
  $$TextBody=~s/<ia>In ([A-Z][a-z]+ [A-Za-z][a-z]+ [A-Za-z]+ [^<>]+?) $regx{editorSuffix}<\/ia> <bt>$regx{firstName}([\,]?) ([$AuthorString ]+)<\/bt>/In <bt>$1<\/bt> $2 <edrg>$3$4 $5<\/edrg>/gs;
  $$TextBody=~s/<ia>In ([A-Z][a-z]+ [A-Za-z][a-z]+ [A-Za-z]+ [^<>]+?) $regx{editorSuffix}<\/ia> <bt>([$AuthorString ]+)([\,]?) ([$AuthorString ]+)<\/bt>/In <bt>$1<\/bt> $2 <edrg>$3$4 $5<\/edrg>/gs;

  $$TextBody=~s/<bt>$regx{noTagAnystring}([\.\,] [Ii]n[\:] )$regx{noTagAnystring}<\/bt>/<misc1>$1<\/misc1>$2<bt>$3<\/bt>/gs;
  $$TextBody=~s/ <\/bt>\(<(pbl|cny)>/<\/bt> \(<$1>/gs;
  $$TextBody=~s/<bt><\/bt>//gs;
  $$TextBody=~s/<at>([\:\.\) ]+)/$1<at>/gs;

  $$TextBody=~s/<bt><pg>(.*?)<\/pg>([\.\,]?)<\/bt>/<pg>$1<\/pg>$2/gs;
  $$TextBody=~s/<\/bt>([\,\.]?) \(<edrg>([^\(\)]+?)<\/edrg> <bt>([^\(\)\[\]<>\.]+?)\)([\.]?)<\/bt>/<\/bt>$1 \(<edrg>$2<\/edrg> $3\)$4/gs;
  $$TextBody=~s/<\/edrg> <bt>$regx{year}\)([\.]?)<\/bt>/<\/edrg> $1\)$2/gs;

  $$TextBody=~s/([\.\,\: ]+)([SPp][\. ]+)(\d+[\–\-0-9]+)<\/misc1> /<\/misc1>$1$2<pg>$3<\/pg> /gs;
  #----------------------edn and page with bt------------------------------------------------

  $$TextBody=~s/<\/(cny|pbl)>([\.\,\?\!\;\( ]+)([0-9]+)( [rR]ev[\s\.]+|[\s\.])$regx{ednSuffix}([\)]?)/<\/$1>$2<edn>$3<\/edn>$4$5/gs;
  $$TextBody=~s/<\/(cny|pbl)>([\.\,\?\!\;\( ]+)([0-9]+)$regx{numberSuffix} $regx{ednSuffix}/<\/$1>$2<edn>$3<\/edn>$4 $5/gs;
  #</i> (2nd ed., pp. 3--22).</bt>

  $$TextBody=~s/>([\.\,\?\!\; ]*)\(([0-9]+)$regx{numberSuffix} $regx{ednSuffix}\,([ ]?)([SpPP]+\.) ([0-9A-Z\-]+)\)([\.]?)<\/$regx{bookTitlesCollab}>/><\/$9>$1\(<edn>$2<\/edn>$3 $4\,$5$6 <pg>$7<\/pg>\)$8/gs;
  $$TextBody=~s/([\.\,\?\!\; ]+)\(([0-9]+)$regx{numberSuffix} $regx{ednSuffix}\,([ ]?)([SpPP]+\.) ([0-9A-Z\-]+)\)([\.]?)<\/$regx{bookTitlesCollab}>/<\/$9>$1\(<edn>$2<\/edn>$3 $4\,$5$6 <pg>$7<\/pg>\)$8/gs;
  #(Winter, 3. Aufl.) #exception
  $$TextBody=~s/<\/([a-z]+)>([\.\,\?\!\; ]+)\(Winter([\.\,\?\!\; ]+)([0-9]+)\. $regx{ednSuffix}\)/<\/$1>$2\(<pbl>Winter<\/pbl>$3<edn>$4<\/edn>\. $5\)/gs;
#</cny> (Winter, <edn>3</edn>. Aufl.)
  $$TextBody=~s/<\/([a-z]+)>([\.\,\?\!\; ]+)\(Winter([\.\,\?\!\; ]+)<edn>([0-9]+)<\/edn>\. $regx{ednSuffix}\)/<\/$1>$2\(<pbl>Winter<\/pbl>$3<edn>$4<\/edn>\. $5\)/gs;

  $$TextBody=~s/<\/([a-z]+)>([\.\?\!\; ]+)([0-9]+)\. $regx{ednSuffix}\)/<\/$1>$2<edn>$3<\/edn>\. $4\)/gs;
  $$TextBody=~s/<bt>((?:(?!<[\/]?bt>).)*?)([\. \(]+?)([Ff]irst|[Ss]oecond|[Tt]herd|[Ff]ourth|[Ff]ifth|[Ss]ixth|[Ss]eventh|[0-9])([\. ]+)$regx{ednSuffix}<\/bt>([\.]?)/<bt>$1<\/bt>$2<edn>$3<\/edn>$4$5$6/gs;
  #<bt>Measuring Inequality. Fifth ed</bt>., <cny>
  $$TextBody=~s/<bt>((?:(?!<[\/]?bt>).)*?)([\.\, \(]+?)([Ff]irst|[Ss]oecond|[Tt]herd|[Ff]ourth|[Ff]ifth|[Ss]ixth|[Ss]eventh|[0-9])([\. ]+)$regx{ednSuffix}([\)]?)<\/bt>([\.]?)/<bt>$1<\/bt>$2<edn>$3<\/edn>$4$5$6$7/gs;

  $$TextBody=~s/<\/i>([\, ]+)([0-9–\-]+)\.<\/$regx{chapterBookCollabTitle}>/<\/i><\/$3>$1<pg>$2<\/pg>\./gs;
  $$TextBody=~s/<\/bt>([\,\.\;]) $regx{pageRange}([\.\;\,]) <(cny|pbl)>/<\/bt>$1 <pg>$2<\/pg>$3 <$4>/gs;


  $$TextBody=~s/<\/i>([\, ]+)\((pp|s|[pP]age[s]?)([\. ]*?)([0-9–\-]+)\)\.<\/$regx{chapterBookCollabTitle}>/<\/i><\/$5>$1\($2$3<pg>$4<\/pg>\)\./gs;

  $$TextBody=~s/([\,\.\;]) ([SpP]+[\.]?|[pP]age[s]?[\.]+)<\/$regx{chapterBookCollabTitle}>([\. ]*?)<pg>/<\/$3>$1 $2$4<pg>/gs;

  #</collab>, vol. 6, pp. 124-140. <pbl>
  $$TextBody=~s/<\/(bt|collab)>\, $regx{volumePrefix}([\, ]+?)$regx{volume}([\,\. ]*?)$regx{pagePrefix}([\. ]*?)$regx{page}([\.\, ]+?)<(pbl|cny|yr)>/<\/$1>\, $2$3<v>$4<\/v>$5$6$7<pg>$8<\/pg>$9<$10>/gs;
  #</i>. 6 vols.</bt>
  $$TextBody=~s/([\.\,]?) $regx{volume} $regx{volumePrefix}([\.\,]?)<\/(misc1|bt|collab)>/<\/$5>$1 <v>$2<\/v> $3$4/gs;

  #</collab>, pp. 61-70 (
  #</collab>, pp. 372-381, <pbl>
  $$TextBody=~s/<\/(bt|collab)>\, ([SpP]+[\. ]+|[pP]age[s]?[\. ]+)([A-Z]?\d+[0-9–A-Z\-]*?)([\.\, ]+)<(pbl|cny|yr)>/<\/$1>\, $2<pg>$3<\/pg>$4<$5>/gs;
  $$TextBody=~s/<\/(bt|collab)>\, ([SpP]+[\. ]+|[pP]age[s]?[\. ]+)([A-Z]?\d+[0-9–A-Z\-]*?)([\.\, ]+)\(/<\/$1>\, $2<pg>$3<\/pg>$4\(/gs;
  #</bt> (pp. 20-60, Vol. 1st). 
  $$TextBody=~s/<\/(bt|collab|misc1)>([\.\,]?) ([\(]?)$regx{pagePrefix}([\.\, ]*?)$regx{page}([\.\,\; ]+)$regx{volumePrefix}([\.\, ]*?)$regx{volume}$regx{numberSuffix}?([\)\.]*?) /<\/$1>$2 $3$4$5<pg>$6<\/pg>$7$8$9<v>$10<\/v>$11$12 /gs;
  $$TextBody=~s/<\/(bt|collab|misc1)>([\.\,]?) ([\(]?)$regx{volumePrefix}([\.\, ]*?)$regx{volume}$regx{numberSuffix}?([\.\,\; ]+)$regx{pagePrefix}([\.\, ]*?)$regx{page}([\)\.]*?) /<\/$1>$2 $3$4$5<v>$6<\/v>$7$8$9$10<pg>$11<\/pg>$12 /gs;


  #(pp. 35-70)</i>.</bt>
  $$TextBody=~s/\. \(([SpP]+[\. ]+|[pP]age[s]?[\. ]+)([A-Z]?\d+[0-9–A-Z\-]*?)\)<\/i>([\.]?)<\/$regx{chapterBookCollabTitle}>/<\/i><\/$4>\. \($1<pg>$2<\/pg>\)$3/gs;
  $$TextBody=~s/\. \(([SpP]+[\. ]+|[pP]age[s]?[\. ]+)([A-Z]?\d+[0-9–A-Z\-]*?)\)([\.]?)<\/i><\/$regx{chapterBookCollabTitle}>/<\/i><\/$4>\. \($1<pg>$2<\/pg>\)$3/gs;
  $$TextBody=~s/>([\, ]+)\(([SpP]+[\.]?|[pP]age[s]?) ([A-Z]?\d+[0-9–A-Z\-]*?)\)([\.]?)<\/$regx{chapterBookCollabTitle}>/><\/$5>$1\($2 <pg>$3<\/pg>\)$4/gs;
  $$TextBody=~s/([\, ]+)\(([SpP]+[\.]?|[pP]age[s]?) ([A-Z]?\d+[0-9–A-Z\-]*?)\)([\.]?)<\/i><\/$regx{chapterBookCollabTitle}>/<\/i><\/$5>$1\($2 <pg>$3<\/pg>\)$4/gs;
  $$TextBody=~s/([\, ]+)\(([SpP]+[\.]?|[pP]age[s]?) ([A-Z]?\d+[0-9–A-Z\-]*?)\)\. ([^<>]*?)\:<\/$regx{chapterBookCollabTitle}> <pbl>/<\/$5>$1\($2 <pg>$3<\/pg>\)\. <cny>$4<\/cny>\: <pbl>/gs;
  $$TextBody=~s/([\, ]+)\(([SpP]+[\.]?|[pP]age[s]?) ([A-Z]?\d+[0-9–A-Z\-]*?)\)\.<\/$regx{bookTitlesCollab}>/<\/$4>$1\($2 <pg>$3<\/pg>\)\./gs;
  $$TextBody=~s/([\, ]+)([SpP]+[\.]?|[pP]age[s]?)(\s*)([A-Z]?\d+[0-9–A-Z\-]*?)([\.\,]?)<\/$regx{bookTitlesCollab}>/<\/$6>$1$2$3<pg>$4<\/pg>$5/gs;

  $$TextBody=~s/ \($regx{pagePrefix}([\. ]*?)$regx{page}\)([\.\,]?)<\/$regx{chapterBookCollabTitle}>/<\/$5> \($1$2<pg>$3<\/pg>\)$4/gs;
  $$TextBody=~s/ \($regx{pagePrefix}([\. ]*?)$regx{page}\)([\.\,\:\; ]+)<(cny|pbl)>/ \($1$2<pg>$3<\/pg>\)$4<$5>/gs;

  $$TextBody=~s/>([\.\,\?\!\;] [Rr]ev[.]?|[\.\,\?\!\;]?) ([\(]?)([0-9]+)( [rR]ev[\s\.]+|[\s\.]+)$regx{ednSuffix}([\)]?)([\.\,\:\;]?)<\/(bt|collab)>/><\/$8>$1 $2<edn>$3<\/edn>$4$5$6$7/gs;
  $$TextBody=~s/>([\.\,\?\!\;] [Rr]ev[.]?|[\.\,\?\!\;]?) ([\(]?)([0-9]+)$regx{numberSuffix}( [rR]ev[\s\.]+|[\s\.]+)$regx{ednSuffix}([\)]?)([\.\,\:\;]?)<\/(bt|collab)>/><\/$9>$1 $2<edn>$3<\/edn>$4$5$6$7$8/gs;
  $$TextBody=~s/([\.\,\?\!\;] [Rr]ev[.]?|[\.\,\?\!\;]?) ([\(]?)([0-9]+)$regx{numberSuffix}( [rR]ev[\s\.]+|[\s\.]+)$regx{ednSuffix}([\)]?)([\.\,\:\;]?)<\/(bt|collab)>/<\/$9>$1 $2<edn>$3<\/edn>$4$5$6$7$8/gs;
  $$TextBody=~s/([\.\,\?\!\;] [Rr]ev[.]?|[\.\,\?\!\;]?) ([\(]?)([0-9]+)( [rR]ev[\s\.]+|[\s\.]+)$regx{ednSuffix}([\)]?)([\.\,\:\;]?)<\/(bt|collab)>/<\/$8>$1 $2<edn>$3<\/edn>$4$5$6$7/gs;
  $$TextBody=~s/([\,\.]) $regx{ednSuffix}([\s]*)([0-9]+)([\.\,]+)<\/(bt|collab)>/<\/$6>$1 $2$3<edn>$4<\/edn>$5/gs;

 #(2<sup>nd</sup> Edition)</i></bt>  # (3<sup>rd</sup> ed.)</i></bt>  # (2<sup>nd</sup>edition)</i></bt>
  $$TextBody=~s/([\.\,\?\!\;]? [\(]?|\()([0-9]+)$regx{numberSuffix}( [rR]ev[\s\.]+|[\s\.]+)$regx{ednSuffix}([\)]?[\.\,\:\;]?)<\/i><\/(bt|collab)>/<\/i><\/$7>$1<edn>$2<\/edn>$3$4$5$6/gs;


  $$TextBody=~s/([\,\.]) ([0-9]+)\. ([a-z ]+)\. $regx{ednSuffix}([\.\:\,]+)<\/(bt|collab)>/<\/$6>$1 $2\. $3\. $4$5/gs;
  $$TextBody=~s/([\,\. ]+)([Vv]ol[s]?[\.]?|[Jj]g[\.]?|[Vv]olume[s]?)([\s\,]*)([0-9–\-]+[A-Z]?|[A-Z]|[IVX]+)([\.\,\:]?)<\/(bt|collab)>/<\/$6>$1$2$3<v>$4<\/v>$5/gs;
  $$TextBody=~s/( \()([Vv]ol[s]?[\.]?|[Jj]g[\.]?|[Vv]olume[s]?)([\s\,]*)([0-9–\-]+[A-Z]?|[A-Z]|[IVX]+)\)([\.\,\:]?)<\/(bt|collab)>/<\/$6>$1$2$3<v>$4<\/v>\)$5/gs;

  #, Vol, 157</bt>  #> (2nd ed.)</bt>   #</i>. (Vol. 26, pp. 501-508)</bt>.
  $$TextBody=~s/( \(|\. )([Vv]ol[s]?[\.]?|[Jj]g[\.]?|[Vv]olume[s]?)([\s]*)([0-9–\-]+[A-Z]?|[IVX]+)\, ([SpP]+[\.]?|[pP]age[s]?) ([A-Z]?\d+[0-9–A-Z\-]*?)(\)[\.]?|[\.\,\:]?)<\/$regx{bookTitlesCollab}>/<\/$8>$1$2$3<v>$4<\/v>\, $5 <pg>$6<\/pg>$7/gs;

  #(Vol. pp. xvi. 288. )</bt>.
  $$TextBody=~s/ ([\(]?)$regx{volumePrefix}\. $regx{pagePrefix}\. $regx{volume}\. $regx{page}([\.]?[\)]?)<\/bt>/<\/bt> $1$2\. $3\. <v>$4<\/v>\. <pg>$5<\/pg>$6/gs;
  $$TextBody=~s/ ([\(]?)$regx{volumePrefix}\. $regx{pagePrefix}\. ([xivlXIVL]+)\. $regx{page}([\.]?[\)]?)<\/bt>/<\/bt> $1$2\. $3\. <v>$4<\/v>\. <pg>$5<\/pg>$6/gs;

  #</i> (2nd ed., Vol. 6, pp. 329-341).</bt>
  $$TextBody=~s/( \(|\. )([0-9]+)$regx{numberSuffix}( [rR]ev[\s\.]+|[\s\.]+)$regx{ednSuffix}([\.\:\, ]+)$regx{volumePrefix}([\, ]+?)$regx{volume}([\,\. ]+?)$regx{pagePrefix}([\. ]*?)$regx{page}(\)[\.]?|[\.]?)<\/$regx{chapterBookCollabTitle}>/<\/$15>$1<edn>$2<\/edn>$3$4$5$6$7$8<v>$9<\/v>$10$11$12<pg>$13<\/pg>$14/gs;
  $$TextBody=~s/( \(|\. )([0-9]+)( [rR]ev[\s\.]+|[\s\.]+)$regx{ednSuffix}([\.\:\, ]+)$regx{volumePrefix}([\, ]+?)$regx{volume}([\,\. ]+?)$regx{pagePrefix}([\. ]*?)$regx{page}(\)[\.]?|[\.]?)<\/$regx{chapterBookCollabTitle}>/<\/$14>$1<edn>$2<\/edn>$3$4$5$6$7<v>$8<\/v>$9$10$11<pg>$12<\/pg>$13/gs;

  #</cny>: 2nd ed., 
  $$TextBody=~s/<\/(cny|bt|collab|misc1|pbl)>([\.\:\, ]+)([0-9]+)$regx{numberSuffix} $regx{ednSuffix}([\.\:\,\; ]+)/<\/$1>$2<edn>$3<\/edn>$4 $5$6/gs;
  $$TextBody=~s/<\/(cny|bt|collab|misc1|pbl)>([\.\:\, ]+)$regx{ordinalNumber} $regx{ednSuffix}([\.\:\,\; ]+)/<\/$1>$2<edn>$3<\/edn> $4$5/gs;
  $$TextBody=~s/([\.\,\;\?] )$regx{ordinalNumber} $regx{ednSuffix}([\.\:]?)<\/(cny|bt|collab|misc1|pbl)>/<\/$5>$1 <edn>$2<\/edn> $3$4/gs;
  $$TextBody=~s/([\.\,\;\?]) $regx{ordinalNumber} $regx{ednSuffix}<\/i>([\.\:]?)<\/(cny|bt|collab|misc1|pbl)>/$1<\/i><\/$5> <i><edn>$2<\/edn><\/i> $3$4/gs;



  $$TextBody=~s/>([\.\,\?\!\;]?) ([\(]?)([0-9]+)( [rR]ev[\s\.]+|[\s\.]+)$regx{ednSuffix}([\)]?)([\.\,\:\;]?)<\/(bt|collab)>/><\/$8>$1 $2<edn>$3$4$5<\/edn>$6$7/gs;
  $$TextBody=~s/([\.\,\?\!\;]) ([\(]?)([0-9]+)( [rR]ev[\s\.]+|[\s\.]+)$regx{ednSuffix}([\)]?)([\.\,\:\;]?)<\/(bt|collab)>/<\/$8>$1 $2<edn>$3$4$5<\/edn>$6$7/gs;
  $$TextBody=~s/([\.\,\?\!\;]?) ([\(]?)([0-9]+)$regx{numberSuffix}( [rR]ev[\s\.]+|[\s\.]+)$regx{ednSuffix}([\)]?)([\.\,\:\;]?)<\/(bt|collab)>/<\/$9>$1 $2<edn>$3<\/edn>$4$5$6$7$8/gs;
  $$TextBody=~s/([ \(]+)$regx{edn}([.]?) $regx{ednSuffix}([\.\:\,\;]?) $regx{pagePrefix} $regx{page}([\)\.]*)<\/bt>/<\/bt>$1<edn>$2<\/edn>$3 $4$5 $6 <pg>$7<\/pg>$8/gs;
  $$TextBody=~s/([ \(]+)$regx{ednSuffix}([\.]?) $regx{edn}([\,\;]?) $regx{pagePrefix} $regx{page}([\)\.]*)<\/bt>/<\/bt>$1$2$3 <edn>$4<\/edn>$5 $6 <pg>$7<\/pg>$8/gs;
  $$TextBody=~s/([\.\,\;]) $regx{edn}<\/bt> $regx{ednSuffix}\. /<\/bt>$1 <edn>$2<\/edn> $3\. /gs;

  #</i>, 3rd</bt> ed.
  $$TextBody=~s/<bt>([^<>]+?)([\.\,]? )$regx{edn}$regx{numberSuffix}<\/bt>([\. ]+)$regx{ednSuffix}([\.\:\,\; ]+)/<bt>$1<\/bt>$2<edn>$3<\/edn>$4$5$6$7/gs;
  $$TextBody=~s/<bt><i>([^<>]+?)<\/i>([\.\,]? )$regx{edn}$regx{numberSuffix}<\/bt>([\. ]+)$regx{ednSuffix}([\.\:\,\; ]+)/<bt><i>$1<\/i><\/bt>$2<edn>$3<\/edn>$4$5$6$7/gs;

  $$TextBody=~s/([\,\.]) $regx{edn}([\.]?) $regx{ednSuffix}([\.\)]*)<\/bib>/$1 <edn>$2<\/edn>$3 $4$5<\/bib>/gs;
  $$TextBody=~s/([\,\.]) $regx{edn}$regx{numberSuffix}([\. ]+)$regx{ednSuffix}([\.\)]*)<\/bib>/$1 <edn>$2<\/edn>$3$4$5$6<\/bib>/gs;

  $$TextBody=~s/ \\newblock<\/(bt|collab)> <(cny|pbl)>/<\/$1> <$2>/gs;
  $$TextBody=~s/([\.\,]?)([\( ]+)$regx{volumePrefix}([\.\, ]*?)$regx{volume}([\)\.]*)<\/(bt|collab|misc1)>/<\/$7>$1$2$3$4<v>$5<\/v>$6/gs;
  $$TextBody=~s/([\.\,]?)([\( ]+)$regx{volume}([\.\, ]*?)$regx{volumePrefix}([\)\.]*)<\/(bt|collab|misc1)>/<\/$7>$1$2<v>$3<\/v>$4$5$6/gs;
  $$TextBody=~s/<misc1>((?:(?!<[\/]?misc1>)(?!<[\/]?bib>).)*?)<\/misc1>([\.\,\;\:\)\( ]+)<bt>$regx{volumePrefix}([\.\, ]*?)$regx{volume}<\/bt>/<bt>$1<\/bt>$2$3$4<v>$5<\/v>/gs;
  $$TextBody=~s/<bt>$regx{volumePrefix}([\.\, ]*?)$regx{volume}<\/bt>/$1$2<v>$3<\/v>/gs;

  #<bt>The Sino-Tibetan languages (pp. 126--130, Routledge language family series</bt>
  $$TextBody=~s/<bt><i>([^<>]+?)<\/i> \($regx{pagePrefix}$regx{optionalSpace}$regx{page}([\.\,\; ]+)([^<>]+)<\/bt>/<bt><i>$1<\/i><\/bt> \($2$3<pg>$4<\/pg>$5$6/gs;
  $$TextBody=~s/<bt>([^<>]+?) \($regx{pagePrefix}$regx{optionalSpace}$regx{page}([\.\,\; ]+)([^<>\)\(]+)<\/bt>/<bt>$1<\/bt> \($2$3<pg>$4<\/pg>$5$6/gs;
  $$TextBody=~s/<\/(cny|bt|collab|misc1|pbl)>([\.\,\;\:]? |[\.\,\;\: ]+)\($regx{edn}([\. ]*)$regx{ednSuffix}([\.]?)\)/<\/$1>$2\(<edn>$3<\/edn>$4$5$6\)/gs;
  $$TextBody=~s/([\.\,\;\:]? |[\.\,\;\: ]+)$regx{volumePrefix}$regx{optionalSpace}$regx{volume}([\.\,\;]?)<\/(cny|bt|collab|misc1|pbl)>/<\/$6>$1$2$3<v>$4<\/v>$5/gs;
  $$TextBody=~s/<\/bt> \($regx{pagePrefix}$regx{optionalSpace}$regx{page}\)\./<\/bt> \($1$2<pg>$3<\/pg>\)\./gs;
  $$TextBody=~s/ e\.V<\/([a-z1]+)>\./ e\.V\.<\/$1>/gs;
  $$TextBody=~s/([\.\,\:\;]? |[\.\,\:\; ]+)\($regx{volumePrefix}$regx{optionalSpace}$regx{volume}([\.\,\:\; ]+)$regx{pagePrefix}$regx{optionalSpace}$regx{page}([\.]?)\)<\/bt>/<\/bt>$1\($2$3<v>$4<\/v>$5$6$7<pg>$8<\/pg>$9\)/gs;
  $$TextBody=~s/([\.\,\;\:\)\]]) $regx{edn}<\/bt>([\. ]*)$regx{ednSuffix}([\.\: ])/<\/bt>$1 <edn>$2<\/edn>$3$4$5/gs;

  #-----------------------------------------------------------------
  #page after pbl
  $$TextBody=~s/<\/(cny|pbl|bt|collab)>([\.\;\:\, ]+)([SP][\.]?|[p]+[\.]?) ([A-Zxiv0-9\-]+)(\p{P}?)<\/bib>/<\/$1>$2$3 <pg>$4<\/pg>$5<\/bib>/gs;
  #$$TextBody=~s/<\/pbl>([\.\;\:\, ]+)([SP][\.]?|[p]+[\.]?) ([A-Zxiv0-9\-]+)(\p{P}?)<\/bib>/<\/pbl>$1$2 <pg>$3<\/pg>$4<\/bib>/gs;
  #year after pbl
  $$TextBody=~s/<\/(cny|pbl|bt|collab)>([\.\;\:\, ]+)(\d{4}[a-z]?)(\p{P}?)<\/bib>/<\/$1>$2<yr>$3<\/yr>$4<\/bib>/gs;
  $$TextBody=~s/<pt>([Vv]ol[s]?[\.]?|[Jj]g[\.]?|[Vv]olume[s]?)<\/pt>([\.]?) <v>/$1$2 <v>/gs;
  $$TextBody=~s/<pt>$regx{noTagAnystring}([\.\,\:\;]+) ([Vv]ol[s]?[\.]?|[Jj]g[\.]?|[Vv]olume[s]?)<\/pt>/<pt>$1<\/pt>$2 $3/gs;

  #--------------------------------------------------------------------------------------

  $TextBody=QuotePuncHandle($TextBody); #Return Ref

  #----------------------check below--------------
  #A guide for women with early breast cancer. Sydney: National Breast Cancer; 2003.
  $$TextBody=~s/<bib([^<>]*?)>$regx{noTagAnystring}\. <(cny|pbl)>/<bib$1><bt>$2<\/bt>\. <$3>/gs;
  #Atherton, J. Behaviour modification [Internet]. 2010 [updated 2010 Feb 10; cited 2010 Apr 10]. Available from: http://www.learningandteaching.info
  $$TextBody=~s/<\/(aug|edr|ia)> $regx{noTagAnystring}\. <yr>$regx{noTagAnystring}<\/yr> (\[[^<>]+?)<url>/<\/$1> <bt>$2<\/bt>. <yr>$3<\/yr> $4<url>/gs;

  #----------------------------------------------------------------------------------------
  #comment
  if($client eq "elsevier")
    {
      $$TextBody=~s/<\/i> \[([^<>\[\]]+?)\]<\/(bt|at)>([\.\,\;])/<\/i><\/$2> <comment>\[$1\]<\/comment>$3/gs;
      $$TextBody=~s/<\/i> \(([^<>\(\)]+?)\)<\/(bt|at)>([\.\,\;])/<\/i><\/$2> <comment>\($1\)<\/comment>$3/gs;
      $$TextBody=~s/ \[\s?([Oo]nline|[Oo]nline early access|[Ii]nternet|[sS]erial [oO]nline|[dD]issertation|[Pp]h[\.]?\s?[Dd][\.]? [tT]hesis|[Uu]npublished [dD]octoral [dD]issertation|[mM]onograph [oO]nline)\]<\/bt>([\.\,\;])/<\/i><\/bt> <comment>\[$1\]<\/comment>$2/gs;
      $$TextBody=~s/ \(\s?([Oo]nline|[Oo]nline early access|[Ii]nternet|[sS]erial [oO]nline|[dD]issertation|[Pp]h[\.]?\s?[Dd][\.]? [tT]hesis|[Uu]npublished [dD]octoral [dD]issertation|[mM]onograph [oO]nline)\)<\/bt>([\.\,\;])/<\/i><\/bt> <comment>\($1\)<\/comment>$2/gs;

      $$TextBody=~s/$regx{wordPuncPrefix}\[([^<>\[\]]+?)\]<\/(bt|at)>([\.\,\;])/$1<\/$3><comment>\[$2\]<\/comment>$4/gs;
      $$TextBody=~s/$regx{wordPuncPrefix}\(([^<>\(\)]+?)\)<\/(bt|at)>([\.\,\;])/$1<\/$3><comment>\($2\)<\/comment>$4/gs;
      $$TextBody=~s/<(at|pt|bt)>([\(\[]?)$regx{comment}([\]\)]?)<\1>/<comment>$2$3$4<\/comment>/gs;
      $$TextBody=~s/<\/([a-z0-9]+)>([\,\.\:\;\'\"\` ]+)([\(\[])$regx{comment}([\]\)])([\,\.\:\; ]+)<([a-z0-9]+)>/<\/$1>$2<comment>$3$4$5<\/comment>$6<$7>/gs;
      $$TextBody=~s/<\/([a-z0-9]+)>([\,\.\:\;\'\"\` ]+)$regx{comment}([\,\.\:\; ]+)<([a-z0-9]+)>/<\/$1>$2<comment>$3<\/comment>$4<$5>/gs;
      $$TextBody=~s/<\/pt> \[$regx{noTagAnystring}\]([\.\,\; ]+)<(yr|v)>/<\/pt> <comment>\[$1\]<\/comment>$2<$3>/gs;
      $$TextBody=~s/<\/pt> \($regx{noTagAnystring}\)([\.\,\; ]+)<(yr|v)>/<\/pt> <comment>\($1\)<\/comment>$2<$3>/gs;
      $$TextBody=~s/<\/at> \[$regx{noTagAnystring}\]([\.\,\; ]+)<(pt)>/<\/at> <comment>\[$1\]<\/comment>$2<$3>/gs;
      $$TextBody=~s/<\/at> \($regx{noTagAnystring}\)([\.\,\; ]+)<(pt)>/<\/at> <comment>\($1\)<\/comment>$2<$3>/gs;
      $$TextBody=~s/<\/([a-z0-9]+)>([\,\.\:\;\'\"\` ]+)([\(\[]?)([uU]pdated [0-9A-Za-z ]+\; [cC]ited [0-9A-Za-z ]+)([\]\)])([\,\.\:\; ]+)/<\/$1>$2<comment>$3$4$5<\/comment>$6/gs;
    }

    $$TextBody=~s/<\/at> ([\(\[]?)$regx{comment}([\]\)]?)\. / $1$2$3<\/at>\. /gs;

  $$TextBody=~s/([\(\[])$regx{comment}([\]\)])$regx{optionaEndPunc}$regx{extraInfo}/<comment>$1$2$3<\/comment>$4$5/gs;
  $$TextBody=~s/<\/([a-z0-9]+)>([\,\.\:\;\'\"\` ]+)$regx{comment}$regx{optionaEndPunc}$regx{extraInfo}/<\/$1>$2<comment>$3<\/comment>$4$5/gs;
  $$TextBody=~s/<\/([a-z]+)> \[$regx{noTagAnystring}\]([\.]?)<\/bib>/<\/$1> <comment>\[$2\]<\/comment>$3<\/bib>/gs;
  $$TextBody=~s/<\/([a-z]+)> \($regx{noTagAnystring}\)([\.]?)<\/bib>/<\/$1> <comment>\($2\)<\/comment>$3<\/bib>/gs;
  #<cny>Singapore</cny>: <pbl>World Scientific</pbl>. Book chapter accepted for publication.</bib>
  $$TextBody=~s/<(cny|pbl)>$regx{noTagAnystring}<\/\1>([\:\,\. ]+)<(cny|pbl)>$regx{noTagAnystring}<\/\4>([\.\,\:]?) $regx{noTagAnystring}([\.]?)<\/bib>/<$1>$2<\/\1>$3<$4>$5<\/$4>$6 <comment>$7<\/comment>$8<\/bib>/gs;

  #</yr> [updated 2010 Feb 10; cited 2010 Apr 10].
  $$TextBody=~s/<\/([a-z0-9]+)>([\,\.\:\;\'\"\` ]+)([\(\[]?)([uU]pdated [0-9A-Za-z ]+\; [cC]ited [0-9A-Za-z ]+)([\]\)])([\,\.\:\; ]+)([^<>]+)<\/bib>/<\/$1>$2<comment>$3$4$5$6<\/comment>$7<\/bib>/gs;
  #----------------------------------------------------------------------------------------------------
  $$TextBody=~s/\, $regx{pageRange}<\/bt>\. <cny>$regx{noTagAnystring}<\/cny>\: <pbl>$regx{noTagAnystring}<\/pbl>([\.]?)<\/bib>/<\/bt>\, <pg>$1<\/pg>\. <cny>$2<\/cny>\: <pbl>$3<\/pbl>$4<\/bib>/gs;
  $$TextBody=~s/<\/(pbl|cny)>\. <comment>\($regx{pagePrefix}$regx{optionalSpace}$regx{page}\)<\/comment>([\.]?)<\/bib>/<\/$1>\. \($2$3<pg>$4<\/pg>\)$5<\/bib>/gs;
  $$TextBody=~s/<\/(pbl|cny|bt|edrg)>([\.\,\(\)\:\; ]+)$regx{pagePrefix}$regx{optionalSpace}$regx{page}([\.\,\(\)\:\; ]+)<(cny|pbl)>/<\/$1>$2$3$4<pg>$5<\/pg>$6<$7>/gs;
  $$TextBody=~s/<\/(pbl|cny|bt|edrg)>([\.\,\(\)\:\; ]+)$regx{volumePrefix}$regx{optionalSpace}$regx{volume}([\.\,\(\)\:\; ]+)(<cny>|<pbl>|<pg>|[pPS\.]+ <pg>|[pPS\.]+ [0-9]+)/<\/$1>$2$3$4<v>$5<\/v>$6$7/gs;

  $$TextBody=~s/<cny>$regx{noTagAnystring}<\/cny>\, $regx{year}\, <pbl>$regx{noTagAnystring}<\/pbl>/<cny>$1<\/cny>\, <yr>$2<\/yr>\, <pbl>$3<\/pbl>/gs;
  $$TextBody=~s/<cny>$regx{noTagAnystring}<\/cny>\, $regx{year}-$regx{year}\, <pbl>$regx{noTagAnystring}<\/pbl>/<cny>$1<\/cny>\, <yr>$2\-$3<\/yr>\, <pbl>$4<\/pbl>/gs;
  #<cny>Princeton, NJ</cny>, <pbl>1979, 
  $$TextBody=~s/<cny>$regx{noTagAnystring}<\/cny>\, <pbl>$regx{year}\, $regx{noTagAnystring}<\/pbl>/<cny>$1<\/cny>\, <yr>$2<\/yr>\, <pbl>$3<\/pbl>/gs;
  $$TextBody=~s/<$regx{titlesPubNamLoc}>([\.\,\;\)\(\]\[ ]*?)<\/\1>/$2/gs;
  $$TextBody=~s/([\.\;\,\: ]+)<\/(bt|at)>/<\/$2>$1/gs;

  $$TextBody=~s/<\/aug>([\.\;\,\: ]+)<misc1>((?:(?!<[\/]?aug>)(?!<[\/]?misc1>)(?!<[\/]?bib>).)*?)\, ([iI]n[\:]?) ((?:(?!<[\/]?aug>)(?!<[\/]?misc1>)(?!<[\/]?bib>).)*?)<\/misc1>\; <edrg>((?:(?!<[\/]?edrg>)(?!<[\/]?bt>)(?!<[\/]?collab>)(?!<[\/]?bib>).)*?)<\/edrg>((?:(?!<[\/]?aug>)(?!<[\/]?edrg>)(?!<[\/]?bt>)(?!<[\/]?collab>)(?!<[\/]?misc1>)(?!<[\/]?bib>).)*?)<\/bib>/<\/aug>$1<misc1>$2<\/misc1>\, $3 <bt>$4<\/bt>\; <edrg>$5<\/edrg>$6<\/bib>/gs;
  $$TextBody=~s/<\/aug>([\.\;\,\: ]+)<misc1>((?:(?!<[\/]?aug>)(?!<[\/]?misc1>)(?!<[\/]?bib>).)*)<\/misc1>((?:(?!<[\/]?aug>)(?!<[\/]?bt>)(?!<[\/]?collab>)(?!<[\/]?misc1>)(?!<[\/]?bib>).)*)<\/bib>/<\/aug>$1<bt>$2<\/bt>$3<\/bib>/gs;

  $$TextBody=~s/<bt>([Ii]n[\:\. ]+)<i>([^<>]+?)<\/i>([\.\,\?\:]?)<\/bt>/$1<bt><i>$2<\/i>$3<\/bt>/gs;
  $$TextBody=~s/<bt>$regx{allLeftQuote}([^<>]+?)([\.]?)$regx{allRightQuote}([\.]?) ([iI]n[\:\.] )([^<>]+?)<\/bt>/$1<misc1>$2<\/misc1>$3$4$5 $6<bt>$7<\/bt>/gs;

  $$TextBody=~s/<misc1><misc1>$regx{noTagAnystring}<\/misc1>\, ([Ii]n[\:]?) <collab>$regx{noTagAnystring}<\/collab>, edited by<\/misc1>/<misc1>$1<\/misc1>\, $2 <collab>$3<\/collab>, edited by/gs;
  $$TextBody=~s/<misc1><misc1>$regx{noTagAnystring}<\/misc1><\/misc1>/<misc1>$1<\/misc1>/gs;

  $$TextBody=~s/([\,\.\;]) $regx{editorSuffix}([\.\,\;])<bt>([\.\,\;]) /$1 $2$3$4 <bt>/gs;
  $$TextBody=~s/<bt><month>$regx{noTagAnystring}<\/month>\)\. /<month>$1<\/month>\)\. <bt>/gs;
  $$TextBody=~s/<bt>([\(\[]?)$regx{editorSuffix}([\)\]]?)([\.\, ]+)/$1$2$3$4<bt>/gs;
  $$TextBody=~s/\(([^\(\)<>]+?)<yr>([^<>]+?)<\/yr>([\.\,\:\; ]+)<bt>([^\(\)<>]+?)\)([\.\,\:]?) /\($1<yr>$2<\/yr>$3$4\)$5 <bt>/gs;

  $$TextBody=~s/<misc1>((?:(?!<[\/]?aug>)(?!<[\/]?misc1>)(?!<[\/]?bib>).)*?)<\/misc1>([\.\;\,]) ([iI]n[\:]?) <bt>((?:(?!<[\/]?aug>)(?!<[\/]?bt>)(?!<[\/]?bib>).)*?)<\/bt>([\.\;\,])  <edrg>((?:(?!<[\/]?edrg>)(?!<[\/]?bt>)(?!<[\/]?collab>)(?!<[\/]?bib>).)*?)<\/edrg>([\.\;\,]) $regx{editorSuffix}([\.\;\,]) <bt>((?:(?!<[\/]?aug>)(?!<[\/]?bt>)(?!<[\/]?bib>).)*?)<\/bt>/<misc1>$1<\/misc1>$2 $3 <bt>$4<\/bt>$5  <edrg>$6<\/edrg>$7 $8$9 <srt>$10<\/srt>/gs;

  $$TextBody=~s/<bt>([^<>]+?)\. \(([^<>\)\(]+?)<\/bt>([^<>\)\(]+?)<v>([^<>]+?)<\/v>\)/<bt>$1<\/bt>\. \($2$3<v>$4<\/v>\)/gs;

  $$TextBody=~s/ <(misc1|at|bt)>\\newblock / <$1>/gs;
  $$TextBody=~s/([\.\:\, ]+)\\newblock<\/(misc1|at|bt)> /<\/$2>$1 /gs;
  $$TextBody=~s/ \\newblock<\/(misc1|at|bt)> /<\/$1> /gs;
  $$TextBody=~s/([\.\,\,\;]+ )<(misc1|at|bt)>\: /$1\: <$2>/gs; 
  $$TextBody=~s/<\/(misc1|at|bt|collab)>\?/\?<\/$1>/gs;
  $$TextBody=~s/([\.\,\;\:]+ )(Hrgs[\.\:]|Ed[s]?[\.\:]|Editor[s]?:|[Ee]dited [bB]y|Ed[s]?[\.] [Bb]y)<\/(misc1|bt|collab)>/<\/$3>$1$2/gs;
  $$TextBody=~s/<misc1><misc1>((?:(?!<[\/]?misc1>)(?!<\/bib>).)*?)<\/misc1><\/misc1>/<misc1>$1<\/misc1>/gs;
  $$TextBody=~s/<bt><edn>([^<>]+?)<\/edn>([^<>]+?)$regx{ednSuffix}([\.\)\,\:]*)<\/bt>/<edn>$1<\/edn>$2$3$4/gs;

  return $$TextBody;
}
#=======================================================================================================================================
sub ReplaceSourceText{
  my ($SourceText, $TextBody)=@_;
  if($$SourceText=~/<petemp>(.*?)<\/petemp>/s){
    $$SourceText=~s/<petemp>(.*?)<\/petemp>/\&lt\;petemp\&gt\;$$TextBody\&lt\;\/petemp\&gt\;/os;
  }elsif($$SourceText=~/<body([^<>]*?)>(.*?)<\/body>/s)
    {
      $$SourceText=~s/<body([^<>]*?)>(.*?)<\/body>/<body$1>$$TextBody<\/body>/os;
    }else{
      $$SourceText="$$TextBody";
    }
  $$SourceText=~s/(\&lt\;|<)[\/]?doig(\&gt\;|>)//gs;
  return $$SourceText;
}
#===========================================================================================================================================
sub formatTextBody{
  my $TextBody=shift;


  $$TextBody=~s/\&lt\;bib([\s]+)id=\&quot\;([0-9]+)\&quot\;&gt\;/<bib id=\"bib$2\">/gs;
  $$TextBody=~s/\&lt\;bib([\s]+)id=\&quot\;bib([a-z0-9]+)\&quot\;&gt\;/<bib id=\"bib$2\">/gs;
  $$TextBody=~s/\&lt\;bib([\s]+)id=\&quot\;bib([a-z0-9]+)\&quot\;([\s]+)type=\&quot\;([a-zA-Z 0-9\_\-]+)\&quot\;\&gt\;/<bib id=\"bib$2\">/gs;
  $$TextBody=~s/\&lt\;bib([\s]+)id=\&quot\;bib([a-z0-9]+)\&quot\;([\s]+)label=\&quot\;([^\=]*?)\&quot\;([\s]+)type=\&quot\;([a-zA-Z 0-9\_\-]+)\&quot\;\&gt\;/<bib id=\"bib$2\">/gs;


  $$TextBody=~s/\s*\s*<bib([^<>]*?)>/ <bib$1>/gs;
  $$TextBody=~s/([0-9]+[\.]?)\s*<bib([^<>]*?)>/<bib$2>$1 /gs;
  $$TextBody=~s/([0-9]+[\.]?)\s*<span([^<>]*?)><bib([^<>]*?)>/<span$2><bib$3>$1 /gs;

  $$TextBody=~s/\&lt\;\/number\&gt\;\s+/\&lt\;\/number\&gt\;/gs;
  $$TextBody=~s/<bib id=\"bibbib([a-z0-9]+)\">/<bib id=\"bib$1\">/gs;
  $$TextBody=~s/\&lt\;\/bib&gt\;/<\/bib>/gs;


  while($$TextBody=~/<p>((?:(?!<[\/]?p>).)*?)<\/p>/os){#for line runon
    my $paratext=$1;
    $paratext=~s/([\s]+)/ /gs;
    $$TextBody=~s/<p>((?:(?!<[\/]?p>).)*?)<\/p>/<123p>$paratext<\/123p>/os;
  }

  while($$TextBody=~/<p ([^<>]*?)>((?:(?!<p \1>)(?!<\/p>).)*?)<\/p>/os){#for line runon
    my $paratext=$2;
    $paratext=~s/([\s]+)/ /gs;
    $$TextBody=~s/<p ([^<>]*?)>((?:(?!<p \1>)(?!<\/p>).)*?)<\/p>/<123p $1>$paratext<\/123p>/os;
  }

  $$TextBody=~s/<123p/<p/gs;
  $$TextBody=~s/<\/123p>/<\/p>/gs;


  my $bibtagfound="1";
  if($$TextBody!~/<bib ([^<>]*?)>/){
    $$TextBody=~s/<p([^<>]*?)>([\s]*)/<p$1><bib id=\"bib0\">/gs;  # add bib if not persent
    $$TextBody=~s/([\s]*)<\/p>/<\/bib><\/p>/gs;
    $bibtagfound="0";
  }
  $$TextBody=~s/<bib $regx{noTagAnystring}><bib>((?:(?!<[\/]?bib>).)*?)<\/bib><\/bib>/<bib $1>$2<\/bib>/gs;

  if($$TextBody!~/<bib id=\"bib[1-9]+\">/){
    my $id=1;
    while($$TextBody=~/<bib id=\"bib0\">/)
      {
	$$TextBody=~s/<bib id=\"bib0\">/<bib id=\"bib$id\">/;
	$id++;
      }
  }

  #Delete bib if any persent
  $$TextBody=~s/<p ([^<>]*?)><bib id=\"bib0\"><span([^<>]*?)><bib([^<>]*?)>/<p$1><span$2><bib$3>/gs;
  $$TextBody=~s/<p ([^<>]*?)><bib id=\"bib0\"><bib([^<>]*?)>/<p$1><bib$2>/gs;

  $$TextBody=~s/<\/bib><\/bib><\/p>/<\/bib><\/p>/gs;
  $$TextBody=~s/<\/bib><\/span><\/bib><\/p>/<\/bib><\/span><\/p>/gs;

  $$TextBody=~s/<p([^<>]*?)><span([^<>]*?)><bib id=\"bib0\"><span([^<>]*?)>\&nbsp\;<\/span><\/bib><\/span><\/p>/<p$1><span$2>\&nbsp\;<\/span><\/p>/gs;
  $$TextBody=~s/<p([^<>]*?)><bib id=\"bib0\">\&nbsp\;<\/bib><\/p>/<p$1>\&nbsp\;<\/p>/gs;

  $$TextBody=~s/<p([^<>]*?)><bib id=\"bib0\"><span([^<>]*?)>\&nbsp\;<\/span><\/bib><\/p>/<p$1>\&nbsp\;<\/p>/gs;
  $$TextBody=~s/<p([^<>]*?)><span([^<>]*?)><bib id=\"bib0\"><span([^<>]*?)>([a-zA-Z\-\. \(\)]+)<\/span><\/bib><\/span><\/p>/<p$1><span$2>$4<\/span><\/p>/gs;

  $$TextBody=~s/<p([^<>]*?)><bib id=\"bib0\">([a-zA-Z\-\. \(\)]+)<\/bib><\/p>/<p$1>$2<\/p>/gs;
  $$TextBody=~s/<p([^<>]*?)><bib id=\"bib0\"><span([^<>]*?)>([a-zA-Z\-\. \(\)]+)<\/span><\/bib><\/p>/<p$1>$3<\/p>/gs;
  
  {}while($$TextBody=~s/<bib([^<>]*?)>([0-9\.\s]+)( | [ ]+) /<bib$1>$2 /gs);
  $$TextBody=~s/<bib([^<>]+?)>([0-9\.\]\[\)\(]+)(�[ ]?|�[�]+[ ]?)([A-Z<])/<bib$1>$2 $4/gs;


  $$TextBody=~s/<p([^<>]*?)><span([^<>]*?)><bib([^<>]*?)>([0-9\.\s]+)([Â \  ]*) /<p$1><span$2><bib$3>$4 /gs;
  $$TextBody=~s/<span([^<>]*?)><bib([^<>]*?)>([0-9\.\s]+)( | [ ]+) /<span$1><bib$2>$3 /gs;
#  $$TextBody=~s/<span([^<>]*?)><bib([^<>]*?)>([0-9\.\s]+)([Â \  ]*) /<span$1><bib$2>$3 /gs;
  $$TextBody=~s/<bib([^<>]*?)>\s*<(b|i|u)>([\(\)\[\]\d\.]+)<\/\2>/<bib$1>$3/gs;

  $$TextBody=~s/<bib([^<>]*?)><span class=([a-zA-Z]+)>([\[\]\(\)0-9\.]+)\s+/<bib$1>$3 <span class=$2>/gs; 

  $$TextBody=~s/<bib([^<>]*?)>([\s]*)\&lt\;number\&gt\;([\[\]\(\)a-zA-Z0-9\.]+)\&lt\;\/number\&gt\;([\s]*)/<bib$1 number=\"$3\">/gs;
  $$TextBody=~s/<bib([^<>]*?)>([\s]*)([\[\]\(\)0-9\.]+)([\s]+)/<bib$1 number=\"$3\">/gs;

  $$TextBody=~s/<bib([^<>]*?)>([\s]*)(\([a-z][\.]?\))([\s]+)/<bib$1 number=\"$3\">/gs;

  $$TextBody=~s/<bib([^<>]*?)>([\s]*)(\([ivxl]+[\.]?\))([\s]+)/<bib$1 number=\"$3\">/gs;
  $$TextBody=~s/<bib([^<>]*?)>([\s]*)([a-z][\.]?\))([\s]+)/<bib$1 number=\"$3\">/gs;

  $$TextBody=~s/number=\"([\[\]\(\)a-zA-Z0-9\.]+)\" number=\"([\[\]\(\)a-zA-Z0-9\.]+)\">/number=\"$1\">/gs;


  $$TextBody=~s/<p><bib ([^<>]*?)><\/bib><\/p>//gs;
  return $$TextBody;
}
#===========================================================================================================================================
sub storeID{
  my $TextBody=shift;
  my @bibid=();
  while($$TextBody=~/<bib([^<>]*?)>/s){
    push(@bibid, $1);
    $$TextBody=~s/<bib([^<>]*?)>/<Xbib$1>/os;
  }
  $$TextBody=~s/<Xbib([^<>]*?)>/<bib$1>/gs;
  return \@bibid;
}
#===========================================================================================================================================
sub GetSourceData{
  my $inputfname=$InputFile;
  chomp($inputfname);
  my $ext=$1 if($inputfname=~s/\.([a-z]+)$//os);
  if (!-e $InputFile){
    print "\n\n\n\n\n\n\n\n\nError: ${inputfname}.$ext file not exist!!\n\n\n\n\n\n\n\n\n";
    exit ;
  }

  my $SourceText=readSourceFile(\$InputFile);

  if($$SourceText!~/<\/p>/){
    if($$SourceText=~/<\/bib>/){
      $$SourceText=~s/<bib([^<>]*?)>/<p><bib$1>/gs;
      $$SourceText=~s/<\/bib>/<\/bib><\/p>/gs;
    }else{
      $$SourceText=~s/([\s]*)\n([\s]+)/\n/gs;
      $$SourceText=~s/^([\s]*)(.*?)([\s]*)$/<p>$2<\/p>/gs;
      $$SourceText=~s/\n/<\/p>\n<p>/gs;
      $$SourceText=~s/<p>(\-\->|<\!\-\-|<\/[a-zA-Z0-9\-]+>|<[a-zA-Z0-9\-]+>|<[a-zA-Z0-9\-]+ [^<>]+?>|[\{\@]?font-[^<>\n]+|[\{\@]?margin-[^<>\n]+|[\{\@]?panose-[^<>\n]+|\/*[^<>]+?\*\/)<\/p>/$1/gs;
    }
  }
  $$SourceText=~s/<(u|b|i)><span$regx{noTagAnystring}>$regx{noTagAnystring}\&lt\;\/bib\&gt\;<\/span><\/\1>/<$1><span$2>$3<\/span><\/$1>\&lt\;\/bib\&gt\;/gs;
  $$SourceText=~s/([A-Za-z][\.]?)( |�)([0-9A-Z])/$1 $3/gs;
  $$SourceText=~s/([\.\,\:])( |�)\s+/$1 /gs;
  $$SourceText=~s/<orgbib>(.*?)<\/orgbib>//gs;
  $$SourceText=~s/<orgfootnote>(.*?)<\/orgfootnote>//gs;
  open(ORIGINAL,">${inputfname}-org.$ext")|| die("${inputfname}-org.$ext File cannot be Wright\n");
  print ORIGINAL "$$SourceText\n";
  close(ORIGINAL);

  #<p class=BibEntry><a name="_ENREF_62">
  $$SourceText=~s/<p $regx{noTagAnystring}><a $regx{noTagAnystring}>((?:(?!<p [^<>]+?>)(?!<\/p>).)*?)<\/p>(\s+)<a\s+$regx{noTagAnystring}><\/a>((?:(?!<p [^<>]+?>)(?!<\/p>).)*?)<\/p>/<p $1><a $2>$3<\/p>$4<p $1>$6<\/p>/gs;

  $$SourceText=~s/\\bibitem(.*?)\n/<bib>\\bibitem$1<\/bib>\n/gs;
  $$SourceText=~s/<bib>\\bibitem\[([^\]\[\\]*?)\]/\\bibitem\[$1\]<bib>/gs;
  $$SourceText=~s/<bib>\\bibitem\b([\\\{ ])/\\bibitem<bib>$1/gs;
  $$SourceText=~s/<bib>\{([a-z\-\_0-9\:]+)\}/<bib id=\"$1\">/gs;
  $$SourceText=~s/\\bibitem(.*?)\n/<p class=Bibentry>\\bibitem$1<\/p>\n/gs;

  $$SourceText=~s/\&nbsp\;\&nbsp\;/\&nbsp\;/gs;
  $$SourceText=~s/\&nbsp\;\&nbsp\;/\&nbsp\;/gs;
  $$SourceText=~s/([\.\,\:\;\? ])\&nbsp\;([a-zA-Z0-9]+)/$1 $2/gs;
  $$SourceText=~s/([\.\,\:\;\? ])\&nbsp\;([\.\,\:\;\?]+)/$1 $2/gs;
  $$SourceText=~s/\&nbsp\;$regx{ednSuffix}/ $1/gs;
  $$SourceText=~s/\&nbsp\;$regx{ednSuffix}/ $1/gs;
  $$SourceText=~s/$regx{volumePrefix}\&nbsp\;/$1 /gs;
  $$SourceText=~s/$regx{issuePrefix}\&nbsp\;/$1 /gs;
  $$SourceText=~s/$regx{pagePrefix}\&nbsp\;/$1 /gs;
  $$SourceText=~s/([Pp]art)\&nbsp\;/$1 /gs;
  $$SourceText=~s/\b([0-9]+)\&nbsp\;([A-Z][\.\,\:\; <])/$1 $2/gs;

  $$SourceText=~s/([\.\,\;\:])�\s/$1 /gs;
  $$SourceText=~s/<i>�\&lt\;\/bib\&gt\;<\/i>/\&lt\;\/bib\&gt\;/gs;
  $$SourceText=~s/\&nbsp\;\: /\: /gs;
  $$SourceText=~s/<[\/]?ins>//gs;
  $$SourceText=~s/<a\s+name=\"[^<>\"]+?">((?:(?!<a\s+name=\"[^<>\"]+?\")(?!<[\/]?a>).)*)<\/a>/$1/gs;
  $$SourceText=~s/<(i|b|sub|sup|u)\s+style=\'[^<>\']+?\'>((?:(?!<\1\s+style=\"[^<>\"]+?\")(?!<\1\s+name=\"[^<>\"]+?\")(?!<[\/]?\1>).)*)<\/\1>/<$1>$2<\/$1>/gs;

  $$SourceText=~s/<span\s*style=\'font:([0-9\.]+[a-z]+) \"([a-zA-Z\- ]+)\"\'> <\/span>/ /gs;
  $$SourceText=~s/<span\s*style=\'font:([0-9\.]+[a-z]+) \"([a-zA-Z\- ]+)\"\'>\n<\/span>/ /gs;
  $$SourceText=~s/<span\s+class=apple-converted-space>\&nbsp\;<\/span>/ /gs;

  $$SourceText=~s/<span\s*style=\'font:([0-9\.]+[a-z]+) \"([a-zA-Z\- ]+)\"\'>\&nbsp\;\s*<\/span>/ /gs;

  $$SourceText=~s/<span\s*style=\'line-height:[0-9]+\%\'>((?:(?!<span[^<>]*?>)(?!<\/span>).)*)<\/span>/$1/gs;
  $$SourceText=~s/<span\s*class=medium-font[0-9\.]+>((?:(?!<span[^<>]*?>)(?!<\/span>).)*)<\/span>/$1/gs;
  $$SourceText=~s/<span\s*style=\'font-size\:\s*[0-9\.]+pt\;\s*font-family\:\s*\"[\w\d ]+\",\s*\"[\w\d ]+\"\'>([0-9\-\.\,\: ]+)<\/span>/$1/gs;
  $$SourceText=~s/<span\s*style=\'font-size\:\s*[0-9\.]+pt\;\s*font-family\:\s*\"Times New Roman\"\,\s*\"serif\"\'>([^a-zA-Z]+)<\/span>/$1/gs;
  $$SourceText=~s/<span\s*style=\'font-size\:\s*[0-9\.]+pt\;\s*line-height\:\s*[0-9\.]+\%\;\s*font-family\:\s*\"[\w\d ]+\"\,\s*\"[\w\d ]+\"\'>([0-9\-\.\,\: ]+)<\/span>/$1/gs;
  $$SourceText=~s/<span\s*style=\'font-size\:\s*[0-9\.]+pt\;\s*line-height\:\s*[0-9\.]+\%\;\s*font-family\:\s*\"[\w\d ]+\"\,\s*\"[\w\d ]+\"\'>([^a-zA-Z]+)<\/span>/$1/gs;
  $$SourceText=~s/<span\s*style=\'font-size\:\s*[0-9\.]+pt\;\s*font-family\:\s*\"[\w\d ]+\"\,\s*\"[\w\d ]+\"\'>((?:(?!<span[^<>]*?>)(?!<\/span>).)*)<\/span>/$1/gs;#********Check
  while($$SourceText=~s/<span\s*style=\'font-family\:\s*[\w\-\d ]+\'>((?:(?!<span[^<>]*?>)(?!<\/span>).)*?)<\/span>/$1/gs){}
  while($$SourceText=~s/<span\s+style=\'font-family\:\s*\"[\w\-\d ]+\"\s*\,\s*\"[\w]+\"\'>((?:(?!<span[^<>]*?>)(?!<\/span>).)*?)<\/span>/$1/gs){}


  $$SourceText=~s/<span([\s]*)lang=([a-zA-Z\-]+)([\s]*)style=\'([^<>\'\"]*?)font-family:([\s])\"([A-Za-z0-9 \-\_]+) Italic\"\,\"([a-zA-Z]+)\"\'>\.<\/span>/\./gs;
  $$SourceText=~s/<span([\s]*)lang=([a-zA-Z\-]+)([\s]*)style=\'font-family:\"([A-Za-z0-9 \-\_]+) Italic\"\,\"([a-zA-Z]+)\"\'>((?:(?!<span[^<>]*?>)(?!<\/span>).)*)<\/span>/<i>$6<\/i>/gs;
   $$SourceText=~s/<span([\s]*)lang=([a-zA-Z\-]+)([\s]*)style=\'([^<>\'\"]*?)font-family:\"([A-Za-z0-9 \-\_]+) Italic\",\"([a-zA-Z\-]+)\"\'>((?:(?!<span[^<>]*?>)(?!<\/span>).)*)<\/span>/<i>$7<\/i>/gs;
   $$SourceText=~s/<span(\s*)lang=([a-zA-Z\-]+)(\s*)style=\'font-family:\"([A-Za-z0-9 \-\_]+)\"\,\"([a-zA-Z\-]+)\"\'>((?:(?!<span[^<>]*?>)(?!<\/span>).)*)<\/span>/$6/gs;
   $$SourceText=~s/<span(\s*)lang=([a-zA-Z\-]+)(\s*)style=\'([^<>\'\"]*?)font-family:\"([A-Za-z0-9 \-\_]+)\",\"([a-zA-Z\-]+)\"\'>((?:(?!<span[^<>]*?>)(?!<\/span>).)*)<\/span>/$7/gs;
   $$SourceText=~s/<span(\s*)lang=([a-zA-Z\-]+)(\s*)style=\'([^<>\'\"]*?)font-family:([\s])\"([A-Za-z0-9 \-\_]+) Italic\"\,\"([a-zA-Z\-]+)\"\'>((?:(?!<span[^<>]*?>)(?!<\/span>).)*)<\/span>/<i>$8<\/i>/gs;
   $$SourceText=~s/<span(\s*)lang=([a-zA-Z\-]+)(\s*)style=\'([^<>\'\"]*?)font-family:([\s])\"([A-Za-z0-9 \-\_]+)\"\,\"([a-zA-Z\-]+)\"\'>((?:(?!<span[^<>]*?>)(?!<\/span>).)*)<\/span>/$8/gs;
  $$SourceText=~s/<span\s*lang=([a-zA-Z\-]+)\s*style=\'font-size:([^\'\"]*?);\s*font-family:\"([A-Za-z0-9 \-\_]+)\",\s*\"([a-zA-Z\-]+)\"\'>((?:(?!<span[^<>]*?>)(?!<\/span>).)*)<\/span>/$5/gs;
  $$SourceText=~s/<a\s+$regx{noTagAnystring}>\s*<span\s*style=\'font-family:\s*\"Times New Roman\",\s*\"serif\"\'>$regx{noTagAnystring}<\/span><\/a>/$2/gs;
  $$SourceText=~s/<\/span><\/b><b><span/<\/span><span/gs;

  $$SourceText=~s/<span\s*style=\'([^\'\"]*?);\s*font-family:\s*\"(Arial Unicode MS|Arial)\",\s*\"sans-serif"\'>([^<>]*?)<\/span>/$3/gs;
  $$SourceText=~s/<span\s*style=\'font-family:\s*\"(Arial Unicode MS|Arial)\",\s*\"sans-serif\"\'>([^<>]*?)<\/span>/$2/gs;

  $$SourceText=~s/<span\s*style=\'font-size:([^\'\"]*?)\;\s*line-height:\s*([^\;\"\']+)\;\s*font-family:\s*\"([A-Za-z0-9 \-\_]+)\",\s*\"serif\"\'>&#8208;<\/span>/\-/gs;
  $$SourceText=~s/<span\s*style=\'font-size\:\s*[0-9\.]+pt\;\s*line-height:\s*[0-9]+\%\;\s*font-family:\s*\"[\w ]+\"\,\s*\"serif\"\'>([\,\.\:\; ]+)<\/span>/$1/gs;

  $$SourceText=~s/<span\s*style=\'font-size:([^\'\"]*?);\s*line-height:([^\;\"\']+);\s*font-family:\s*\"Arial\",\s*\"sans-serif\"\'>((?:(?!<span[^<>]*?>)(?!<\/span>).)*)<\/span>/$3/gs;

  $$SourceText=~s/<span\s*([^<>]+?)>\&lt\;bib\s*id=\&quot\;bib([0-9]+)\&quot\;\&gt\;([0-9\.\)\(\]\[ ]+|\([A-Z][\.]?\))<\/span>\s*<span\s*([^<>]+?)> /\&lt\;bib id=\&quot\;bib$2\&quot\;\&gt\;$3 <span $4>/gs;
  $$SourceText=~s/<span\s*style=\'font-size:([^\'\"]*?);\s*line-height:([^\;\"\']+);\s*font-family:\s*\"Times New Roman\",\s*\"(sans-serif|serif)\"\'>((?:(?!<span[^<>]*?>)(?!<\/span>).)*)<\/span>/$4/gs;
  $$SourceText=~s/<\/strong> <strong>/ /gs;
  $$SourceText=~s/&lt;bib\s*id=\"([^<>\;\"\&]+?)\"\&gt\;/&lt;bib id=\&quot\;$1\&quot\;\&gt\;/gs;
  $$SourceText=~s/&lt;bib\s*id=\&quot\;([^<>\;\"\&]+?)\&quot\;\&gt\;\s*\[([0-9\.]+)\]([a-zA-Z])/&lt;bib id=\&quot\;$1\&quot\;\&gt\; \[$2\] $3/gs;
  $$SourceText=~s/&lt;bib\s*id=\&quot\;([^<>\;\"\&]+?)\&quot\;\&gt\;\s*\[([0-9\.]+)\]([^<>\(\)\@\#\%\&\&\w\-]*?)([\w\&])/&lt;bib id=\&quot\;$1\&quot\;\&gt\;\[$2\] $4/gs;

  # $$SourceText=~s/&lt;bib\s*id=\&quot\;([^<>\;\"\&]+?)\&quot\;\&gt\;\s*\(([0-9\.]+)\)([^<>\&\w\-]*?)([\w\&])/&lt;bib id=\&quot\;$1\&quot\;\&gt\;$2 $4/gs;
  #********************check

  $$SourceText=~s/<p\s+$regx{noTagAnystring}>\[([0-9\.]+)\]([\w\&])/<p $1>\[$2\] $3/gs;
  $$SourceText=~s/<p\s+$regx{noTagAnystring}>\[([0-9\.]+)\]([^<>\&\d\w\-]*?)([\w\&])/<p $1>\[$2\] $4/gs;
  $$SourceText=~s/<p\s+$regx{noTagAnystring}>([0-9\.]+)\&nbsp\;/<p $1>$2 /gs;
  $$SourceText=~s/<span\s+style=\"border\:none\s+windowtext\s+[0-9\.]+pt\;padding:[0-9\.]+\;\"> <\/span>/ /gs;
  $$SourceText=~s/<p\s+$regx{noTagAnystring}>\s+/<p $1>/gs;
  #------------------------Third party Cleanup--------------------
  {}while($$SourceText=~s/\&lt\;background-color\:(\#[A-Z0-9]*?)\;(i|b|u|sup|sub)\&gt\;((?:(?!<\/p>)(?!<p class=\"Bibentry\")(?!<bib )(?!<[\/]?bib>)(?!\&lt\;background-color\:).)*)\&lt\;\/background-color\:\1\;\2\&gt\;/<$2>$3<\/$2>/gs);
  {}while($$SourceText=~s/\&lt\;background-color\:(\#[A-Z0-9]*?)\;\&gt\;((?:(?!<\/p>)(?!<p class=\"Bibentry\")(?!<bib )(?!<[\/]?bib>)(?!\&lt\;background-color\:).)*)\&lt\;\/background-color\:\1\;\&gt\;/$2/gs);
  {}while($$SourceText=~s/\&lt\;background-color\:\;\&gt\;((?:(?!<\/p>)(?!<p class=\"Bibentry\")(?!<bib )(?!<[\/]?bib>)(?!\&lt\;background-color\:).)*)\&lt\;\/background-color\:\;\&gt\;/$1/gs);
  $$SourceText=~s/\&lt\;background-color\:\;(i|b|u|sup|sub)\&gt\;((?:(?!<\/p>)(?!<p class=\"Bibentry\")(?!<bib )(?!<[\/]?bib>)(?!\&lt\;background-color\:).)*)\&lt\;\/background-color\:\;\1\&gt\;/<$1>$2<\/$1>/gs;

  $$SourceText=~s/\&lt\;[\/]?background-color\:(\#[A-Z0-9]+?\;)\&gt\;//gs;
  $$SourceText=~s/\&lt\;ivertical-align:super\;\&gt\;<span style="[^<>]+?">([^<>]+?)<\/span>\&lt\;\/ivertical-align:super\;&gt\;/<i>$1<\/i>/gs;
  $$SourceText=~s/\&lt\;bvertical-align:super\;&gt\;<span style="[^<>]+?"><\/span>\&lt\;\/bvertical-align:super\;&gt\;//gs;
  $$SourceText=~s/\&lt\;[\/]?direction\:ltr\;\&gt\;//gs;
#  print "$$SourceText\n";exit;

  #&lt;/background-color:#FFFFFF;&gt;
  #---------------------------------------------------------------

  $$SourceText=~s/\&gt\;\&lt\;number\&gt\;([0-9]+)&lt\;\/number\&gt\;\./\&gt\;\&lt\;number\&gt\;$1\.&lt\;\/number\&gt\;/gs;
  $$SourceText=~s/\&gt\;\&lt\;number\&gt\;([0-9]+)\.&lt\;\/number\&gt\;\./\&gt\;\&lt\;number\&gt\;$1\.&lt\;\/number\&gt\;/gs;

  $$SourceText=~s/<\/span><span(\s*)lang=EN-US(\s*)style=\'([^<>\'\"]*?)\'>\&lt\;number\&gt\;/\&lt\;number\&gt\;/gs;

  $$SourceText=~s/<i>\&lt\;\/bib\&gt\;<\/i>/\&lt\;\/bib\&gt\;/gs;
  $$SourceText=~s/<b>\&lt\;\/bib\&gt\;<\/b>/\&lt\;\/bib\&gt\;/gs;
  $$SourceText=~s/\&lt\;\/bib\&gt\;[\s]*<\/i>/<\/i>\&lt\;\/bib\&gt\;/gs;
  $$SourceText=~s/\&lt\;\/bib\&gt\;[\s]*<\/b>/<\/b>\&lt\;\/bib\&gt\;/gs;
  $$SourceText=~s/<(b|i|u)>\&nbsp\;<\/\1>/\&nbsp\;/gs;
  $$SourceText=~s/<(b|i|u|sup|sub)>\&nbsp<\/$1>\;/\&nbsp\;/gs;
  $$SourceText=~s/<i><\/i>//gs;
  $$SourceText=~s/<b><\/b>//gs;
  $$SourceText=~s/: <\/i>/<\/i>: /gs;

  $$SourceText=~s/<\!\-\-StartFragment\-\->/<petemp>/gs;
  $$SourceText=~s/<\!\-\-EndFragment\-\->/<\/petemp>/gs;

  #---precleanup---------
  $$SourceText=~s/<span([\s]*)lang=([a-zA-Z\-]+)([\s]*)style=\'color:([a-zA-Z]+)\'>/<span lang=EN-US>/gs;
  $$SourceText=~s/<span([\s]*)style=\'color:([a-zA-Z]+)\'>/<span>/gs;
  $$SourceText=~s/<span([\s]*)lang=([A-Za-z\-]+)>/<span lang=EN-US>/gs;

  $$SourceText=~s/<span([^<>]*?)>([\s]*)\&lt\;\/petemp\&gt\;<\/span>([\s]*)/<\/petemp>/gs;
  $$SourceText=~s/<p([^<>]*?)><span([^<>]*?)>\&lt\;petemp\&gt\;<\/span><\/p>/<petemp>/gs;
  $$SourceText=~s/<p([^<>]*?)><span([^<>]*?)>\&lt\;\/petemp\&gt\;<\/span><\/p>/<\/petemp>/gs;
  $$SourceText=~s/<span([^<>]*)>([\s])*\&lt\;\/petemp\&gt\;<\/span><\/p>/<\/p><\/petemp>/gs;
  $$SourceText=~s/ <\/span><\/p>/<\/span><\/p>/gs;

  #$$SourceText=~s/lang=([A-Za-z\-]+)/lang=EN-US/gs;
  $$SourceText=~s/<span([\s]*)lang=([A-Za-z\-]+)>([\s]+)<\/span>/ /gs;
  $$SourceText=~s/<span([\s]*)lang=([A-Za-z\-]+)><\/span>//gs;

  $$SourceText=~s/<i>([\.\:\,\;]) /$1 <i>/gs;
  $$SourceText=~s/<i><span([\s]*)lang=([A-Za-z\-]+)>([\.\,\?\:\;])<\/span><\/i>/$3/gs;

  $$SourceText=~s/<p([^<>]*?)><span([^<>]*?)>([0-9]+)\.([\s]*)/<p$1>$3\. /gs;

  $$SourceText=~s/<p([^<>]*?)><span([^<>]*?)>([0-9]+)<\/span><span([^<>]*?)>\.([\s]*)/<p$1>$3\. /gs;
  $$SourceText=~s/<\/a>//gs;

  $$SourceText=~s/<a name=bookmark([0-9]+)>//gs;
  $$SourceText=~s/ ([\ ]+)/ /gs;

  $$SourceText=~s/–/--/g;
  $$SourceText=~s/([0-9a-zA-Z\.\,\:\;\"\?\)\]>\s]) ([\sa-zA-Z<])/$1$2/gs;
  $$SourceText=~s/â/--/g;
  $$SourceText=~s/â€“/--/g;
  $$SourceText=~s/([0-9]+)[–]+([0-9]+)/$1\-\-$2/gs;

  $$SourceText=~s/<i>\.&lt;\/bib&gt;<\/i>/\.&lt;\/bib&gt;/gs;
  $$SourceText=~s/\.&lt;\/bib&gt;<\/i>/<\/i>\.&lt;\/bib&gt;/gs;
  $$SourceText=~s/<o\:p>([\s]*)<\/o\:p>//gs;
  $$SourceText=~s/<o:p>\&nbsp\;<\/o:p>//gs;
  $$SourceText=~s/<p ([^<>]*?)><span([^<>]*?)>([\s]*)<\/span><\/p>//gs;
  $$SourceText=~s/<p><span([^<>]*?)>([\s]*)<\/span><\/p>//gs;
  $$SourceText=~s/<p ([^<>]*?)>([\s]*)<\/p>//gs;
  $$SourceText=~s/<p>([\s]*)<\/p>//gs;
  $$SourceText=~s/\&lt\;([\/]?)[Pp][e]?temp\&gt\;/\&lt\;$1petemp\&gt\;/igs;
  $$SourceText=~s/<([\/]?)[Pp][e]?temp>/<$1petemp>/igs;
  $$SourceText=~s/<br[^<>]*?>/\n/gs;
  #$$SourceText=~s/<\/span><span([\s]*)lang=([a-zA-Z\-]+)>([^<>]*?)<\/span>([\s]*)<span([\s]*)lang=([a-zA-Z\-]+)([\s]*)style=\'([^\'\<>]*?)\'>/$3/gs;
  $$SourceText=~s/<span([^<>]*?)>\&lt\;\/petemp\&gt\;<\/span>/<\/petemp>/gs;
  $$SourceText=~s/<span([^<>]*?)><\/petemp><\/span>/<\/petemp>/gs;
  $$SourceText=~s/<p class\=([a-zA-Z\_\-]+)><span([^<>]*?)>\&lt\;petemp\&gt\;/<petemp><p class\=$1><span$2>/gs;
  $$SourceText=~s/<p><span([^<>]*?)>\&lt\;petemp\&gt\;/<petemp><p><span$1>/gs;
  $$SourceText=~s/<p ([^<>]*?)><span([^<>]*?)>\&lt\;petemp\&gt\;/<petemp><p $1><span$2>/gs;
  $$SourceText=~s/<p class=([a-zA-Z\_\-]+)><span([\s]*)lang=([a-zA-Z\-]+)([\s]*)style=\'([^\'\<\>]*?)\'>\&lt\;petemp\&gt\;/<petemp><p class\=$1><span lang\=$3>/gs;
  $$SourceText=~s/<p class\=Bibentry><span lang\=([a-zA-Z\-]+)>\&lt\;petemp\&gt\;/<petemp><p class\=Bibentry><span lang\=$1>/gs;
  $$SourceText=~s/<p class\=Bib_entry><span lang\=([a-zA-Z\-]+)>\&lt\;petemp\&gt\;/<petemp><p class\=Bib_entry><span lang\=$1>/gs;
  $$SourceText=~s/\&lt\;\/petemp\&gt\;<\/span><\/p>/<\/span><\/p><\/petemp>/g;
  $$SourceText=~s/\&lt\;\/petemp\&gt\;<\/p>/<\/p><\/petemp>/g;
  $$SourceText=~s/<p>&lt;petemp&gt;/<petemp><p>/g;
  $$SourceText=~s/<\/petemp><\/p>/<\/p><\/petemp>/g;
  $$SourceText=~s/<p><petemp>/<petemp><p>/g;
  $$SourceText=~s/<p>(\&nbsp\;)*<\/p>//gs;
  $$SourceText=~s/<p ([^<>]*?)>(\&nbsp\;)*<\/p>//gs;
  $$SourceText=~s/<p>(\s*)<p>/<p>/gs;
  $$SourceText=~s/<p ([^<>]*?)>(\s*)<p ([^<>]*?)>/<p $1>/gs;


  $$SourceText=~s/<p ([^<>]*?)>&lt;petemp&gt;/<petemp><p>/gs;
  $$SourceText=~s/<p>&lt;petemp&gt;/<petemp><p>/gs;
  $$SourceText=~s/<p ([^<>]*?)><span([^<>]*?)>\&lt\;\/petemp\&gt\;/<\/petemp><p$1><span$2>/gs;
  $$SourceText=~s/<p><span([^<>]*?)>\&lt\;\/petemp\&gt\;/<\/petemp><p><span$1>/gs;
  $$SourceText=~s/<b>\. <\/b>/. /gs;
  $$SourceText=~s/<em>(.*?)<\/em>/<i>$1<\/i>/gs;
  $$SourceText=~s/([\.\:\;\?\,])([\s]*)<\/(i|b)>([\s]+)/<\/$3>$1 /gs;
  $$SourceText=~s/([\.\:\;\?\,])([\s]*)<\/(i|b)>/<\/$3>$1 /gs;
  $$SourceText=~s/<(i|b|u|sub|sup|sb|sp)>([\s]+)/ <$1>/gs;
  $$SourceText=~s/<(i|b|u|sub|sup|sb|sp)>([\s]+)/ <$1>/gs;
  $$SourceText=~s/([\s]+)<\/(i|b|u|sub|sup)>/<\/$2> /gs;
  $$SourceText=~s/<\/i> <i>/ /gs;
  $$SourceText=~s/<i><\/i>//gs;
  $$SourceText=~s/<i> <\/i>/ /gs;
  $$SourceText=~s/<p ([^<>]*?)>�([\(A-Za-z0-9]+)/<p $1>$2/gs;
  $$SourceText=~s/<p>�([\(A-Za-z0-9]+)/<p>$1/gs;

  $$SourceText=~s/<(u|sub|sup)>([\s]+)/ <$1>/gs;
  $$SourceText=~s/([\s]+)<\/(u|sub|sup)>/<\/$1> /gs;

  $$SourceText=~s/<p ([^<>]*?)>\&nbsp\;<\/p>//gs;
  $$SourceText=~s/<p>\&nbsp\;<\/p>//gs;
  $$SourceText=~s/\(([0-9a-z \/\\]+)\)\.\&nbsp\;<i>/\($1\)\. <i>/gs;

  $$SourceText=~s/<span([^<>]*?)>([\s]*)<span([^<>]*?)>&nbsp;<\/span>([\s]*)<\/span>/ /gs;
  $$SourceText=~s/\.\.<\/span>/\.<\/span>/gs;

  $$SourceText=~s/[ \t]+/ /gs;
  $$SourceText=~s/S<span[\s]?style=\'background[\s]?:#96C864\'>&nbsp;<\/span>/S/gs;
  $$SourceText=~s/<span[\s]?style=\'background[\s]?:#96C864\'>&nbsp;<\/span>/\&nbsp\;/gs;
  $$SourceText=~s/<b>\(<\/b>([0-9]+)/\($1/gs;
  $$SourceText=~s/([0-9]+)<b>\)<\/b>/$1\)/gs;
  $$SourceText=~s/doi:doi:/doi:/gs;
  $$SourceText=~s/$regx{tabchar}([ ]*)/ /gs;
  $$SourceText=~s/([0-9\.]+)[�]+ /$1 /gs;

  $$SourceText=~s/\&gt\;&lt\;number\&gt\;([0-9\.]+)\&lt\;number\&gt\;[\s]*/\&gt\;&lt\;number\&gt\;$1\&lt\;\/number\&gt\;/gs; 
  $$SourceText=~s/\&lt\;bib\s*id=\&quot\;bib([\/.\[\]\(\)0-9]+)\&quot\;\&gt\;\s*([\(\[\.]?)([\/.0-9]+)([\]\)\.]?)\s*([A-Za-z])/\&lt\;bib id=\&quot\;bib$1\&quot\;\&gt\;$2$3$4 $5/gs;

  $$SourceText=~s/<p([^<>]*?)><span([^<>]*?)>(\&nbsp\;)*<\/span><\/p>//gs;
  $$SourceText=~s/<p([^<>]*?)>(\&nbsp\;)<\/p>//gs;


  #****check for iso to text entites
  $$SourceText=~s/\&ouml\;/�/gs;
  #select(undef, undef, undef, $sleep2);

  use ReferenceManager::utfEntitiesConv;
  $$SourceText=&ReferenceManager::utfEntitiesConv::unicodeEntitiesConv($$SourceText, "IsoEntity", "NormalText", $application);#unicode to texEntities
  $$SourceText=&ReferenceManager::utfEntitiesConv::unicodeEntitiesConv($$SourceText, "DecEntity", "NormalText", $application);#unicode to texEntities


  return ($$SourceText, $inputfname, $ext);
}

#===========================================================================================================================================
sub GetTeXSourceData{
  my ($inputfname, $ext) = split(/\.([a-zA-Z]+)$/, $InputFile);
  if (!-e $InputFile){
    print "\n\n\n\n\n\n\n\n\nError: ${inputfname}.$ext file not exist!!\n\n\n\n\n\n\n\n\n";
    exit ;
  }

  my $bblDataRef="";
  my $bibProcess="False"; 
  my $SourceText="";
  if($InputFile =~ /\.bbl/)
    {
      use ReferenceManager::common;
      ($bblDataRef, $bibProcess) = &ReferenceManager::common::main(@ARGV);
      if($bibProcess eq "True"){
	$SourceText=$$bblDataRef;
	$SourceText=~s/\s*\\bibitem/\n\n\\bibitem/gs;
	goto SourceLabel;
      }
    }

  my $SourceText=readSourceFile(\$InputFile);

 SourceLabel:

  #$$SourceText=~s/\\\%/\&\#x0025\;/gs;
  #$$SourceText=~s/\\begin\{thebibliography\}\{[0-9a-zA-Z\.]*?\}\s*((?:(?!\\bibitem).)*)\%\\bibitem/\%\\bibitem/s;
  $$SourceText=~s/\\begin\{thebibliography\}\{[0-9a-zA-Z\.]*?\}\s*((?:(?!\\bibitem).)*)\\bibitem/\\bibitem/s;
  $$SourceText=~s/\s*\\begin\{thebibliography\}\{[0-9A-Za-z\.]*?\}\s*//gs; 
  $$SourceText=~s/\s*\\end\{thebibliography\}\s*/\n/gs;
  $$SourceText=~s/(.*)$/$1\n/gs;

  $$SourceText=~s/^(.*)$/<petemp>\n$1\n<\/petemp>/gs;
  $$SourceText=~s/\n\s*\n/<parabreak>/gs;
  $$SourceText=~s/\s+\\newblock/ \\newblock/gs;
  $$SourceText=~s/\n([\s])/$1/gs;
  $$SourceText=~s/\n([^\s])/ $1/gs;
  $$SourceText=~s/(<parabreak>)*?\\bibitem/\n\n\\bibitem/gs;
  $$SourceText=~s/<parabreak>/\n\n/gs;
  $$SourceText=~s/\n\s+$/\n/gs;
  $$SourceText=~s/\\bibitem\s+\{([^\}{]+)}/\\bibitem\{$1}/gs;
  $$SourceText=~s/\\bibitem(.*?)\n/<bib>\\bibitem$1<\/bib>\n/gs;
  $$SourceText=~s/<bib>\\bibitem\[([^\]\[]*?)\]/\\bibitem\[$1\]<bib>/gs;
  $$SourceText=~s/<bib>\\bibitem\b([\\\{ ])/\\bibitem<bib>$1/gs;
  $$SourceText=~s/\{\\bf ([0-9\)\(\/]+)\}/\\textbf\{$1\}/gs;
  #----------------------------------

  use ReferenceManager::handleCurlyDoller;

  $SourceText=&ReferenceManager::handleCurlyDoller::matchCurly($SourceText); #in and out $TeXData refrence

  $$SourceText=~s/<(ct|pt|at|bt|pbl|cny)><cur([0-9]+)>([\s]?[^\\]+)((?:(?!<[\/]?cur\2>).)*)<\/cur\2><\/\1>/<$1>$3$4<\/$1>/gs;
  $$SourceText=~s/\]<bib><cur([0-9]+)>((?:(?!<cur\1>)(?!<\/cur\1>).)*)<\/cur\1>/\]<bib id=\"$2\">/gs;
  $$SourceText=~s/<bib><cur([0-9]+)>((?:(?!<cur\1>)(?!<\/cur\1>).)*)<\/cur\1>/<bib id=\"$2\">/gs;
  $$SourceText=~s/\\newblock(\s*)<cur([0-9]+)>\\(em|it|textit|bf|textbf|mathit|tt|texttt)\s*<cur([0-9]+)>((?:(?!<[\/]?cur\2>)(?!<[\/]?cur\4>).)*)<\/cur\4><\/cur\2>/\\newblock$1<cur$4>\\$3 $5<\/cur$4>/gs;
  $$SourceText=~s/\> <cur1>([^<>]*?)<\/cur1>/\> $1/gs;

  $SourceText=&ReferenceManager::handleCurlyDoller::rearrangeCurly($SourceText); #in and out $TeXData refrence

  #----------------------------------
  $$SourceText=~s/\\bibitem(.*?)\n/<p class=Bibentry>\\bibitem$1<\/p>\n/gs;
  $$SourceText=~s/\{([\s]*)\\(it|em|emph)([\s]*)([^\}\{]*?)\}/<i>$4<\/i>/gs;
  $$SourceText=~s/\\(it|em|emph)([\s]*)\{([^\}\{]*?)\}/<i>$3<\/i>/gs;
  $$SourceText=~s/([0-9]+)([^\.\,\)\(\[\]0-9a-zA-Z\:\;\"\`\"\- ]+?)([0-9]+)/$1$2$3/gs;
  $$SourceText=~s/â/--/g;
  $$SourceText=~s/â€“/--/g;
  $$SourceText=~s/<\/i>\.[\s]*\,/\.<\/i>\,/gs;
  $$SourceText=~s/\.[\s]*\,<\/i>/\.<\/i>\,/gs;
  $$SourceText=~s/\\\,\:/\:/gs;
  $$SourceText=~s/([Vv]olume[s]?[\.]?|[Vv]ol[s]?[\.]?|[J]g[\.]?)\~([0-9]+)/$1 $2/gs;
  $$SourceText=~s/([Nn]o[\.]?|[Hh]eft|[Ii]ssue|[pp]age[s]?)\~([0-9]+)/$1 $2/gs;
  $$SourceText=~s/([\.A-Za-z]+)\~([A-Za-z]+)/$1 $2/gs;
  $$SourceText=~s/ \`\`\{([a-zA-Z\-0-9]+)\}/ \`\`$1/gs; 
  $$SourceText=~s/\\textit\{([^\{\}]*?)\}/<i>$1<\/i>/gs;
  $$SourceText=~s/\\emph\{([^\{\}]*?)\}/<i>$1<\/i>/gs;


  use ReferenceManager::utfEntitiesConv;
  $$SourceText=&ReferenceManager::utfEntitiesConv::unicodeEntitiesConv($$SourceText, "TeXEntity", "NormalText", $application);#unicode to texEntities

  $$SourceText=~s/\\\&/\&/g;
  $$SourceText=~s/\\textbf\{([^\{\}]*?)\}/<b>$1<\/b>/gs;
  $$SourceText=~s/\\uppercase\{[a-zA-Z]\}/\U$1/g;
  $$SourceText=~s/([p]+)\.\~([eSP]?[0-9]+)/$1\. $2/gs;

  $$SourceText=~s/\.\: \{([A-Z])\}/\.\: $1/gs;
  $$SourceText=~s/ ([A-Za-z0-9–\-]+)\{([^\{\}]*?)\}/ $1$2/gs;
  $$SourceText=~s/\}([A-Za-z0-9–\-]+) \{([^\{\}]*?)\}/\}$1 $2/gs;
  $$SourceText=~s/\{\{([A-Z])\}\}/\{$1\}/gs;
  $$SourceText=~s/ \{([A-Z])\} / $1 /gs;
  $$SourceText=~s/\\newblock \{([A-Za-z]+)\}/\\newblock $1/gs;
  $$SourceText=~s/ ([A-Za-z0-9–\-]+[\.\,\:\; ]*) \{([^\{\}]*?)\}/ $1 $2/gs;
  $$SourceText=~s/ ([A-Za-z0-9–\-]+[\.\,\:\; ]*) \{([^\{\}]*?)\}/ $1 $2/gs;
  $$SourceText=~s/\{\\natexlab\{([a-z])\}\}/$1/gs;
  $$SourceText=~s/ ([A-Za-z0-9–\-]+)\{([^\{\}]*?)\}/ $1$2/gs;
  $$SourceText=~s/ ([A-Za-z0-9–\-]+[\.\,\:\; ]*) \{([^\{\}]*?)\}/ $1 $2/gs;
  $$SourceText=~s/<(at|bt|ct|pt|pbl|cny)>\{([^\{\}]*?)\}/<$1>$2/gs;
  $$SourceText=~s/([A-Za-z]+)\.\~\{([^\{\}]*?)\}/$1\. $2/gs;
  $$SourceText=~s/\\penalty0 / /gs;
  $$SourceText=~s/\&\#x0025\;/\\\%/gs;

  return ($$SourceText, $inputfname, $ext);
}
#===========================================================================================================================================
sub OUTStructuredData{
  my ($TextBody, $inputfname, $ext)=@_;

  if($option eq "texcolor") {
    my $entityString="a-zA-Z0-9\#";
    use ReferenceManager::utfEntitiesConv;
    $$TextBody = &ReferenceManager::utfEntitiesConv::unicodeEntitiesConv($$TextBody, "NormalText", "TeXEntity", $application);#unicode to texEntities
    $$TextBody =~ s/\&([$entityString]+)\;/<amp>$1\;/gs;
    $$TextBody =~ s/\\\&/<AMPENT>/gs;
    $$TextBody =~ s/\&/\\\&/gs;
    $$TextBody =~ s/<AMPENT>/\\\&/gs;
    $$TextBody =~ s/<amp>([$entityString]+)\;/\&$1\;/gs;
  }

  open(OUTHTDATAFILE,">${inputfname}.$ext")|| die("${inputfname}.$ext File cannot be Wright\n");
  print OUTHTDATAFILE "$$TextBody\n";
  close(OUTHTDATAFILE);
}
#===========================================================================================================================================
sub HtmlInputStructuring {
  my ($SCRITPATH, $inputfname, $ext)=@_;
  if (defined $style){
    if($style !~/^$STYLEvalue$/){
      system("cls");
      print "!!Wrong Reference style argument!!\n";
      &RefrenceStylehelp;
    }
  }

  my $SourceText=&main;   #Standard Marking
  #select(undef, undef, undef, $sleep2);

  &OUTStructuredData(\$SourceText, $inputfname, $ext);
  system("cls");
  print "\n################################################################################\n\n";
  print "Text Color Transformation Done...\n\n\n";
  print "################################################################################\n\n";
  #Re-Structuring
  #select(undef, undef, undef, $sleep2);
  &HtmlInputReStructuring($SCRITPATH, $inputfname, $ext);
}
#==================================================================================================================================================
sub TeXInputStructuring{
  my ($SCRITPATH, $inputfname, $ext)=@_;
  my $SourceText=&main;   #Standard Marking
  &OUTStructuredData(\$SourceText, $inputfname, $ext);
  print "################################################################################\n\n";
  print "Text Color Transformation Done...\n\n";
  print "################################################################################\n\n";
  #Re-Structuring
  &TexInputReStructuring($SCRITPATH, $inputfname, $ext);
}
#==================================================================================================================================================
sub HtmlInputReStructuring {
  my ($SCRITPATH, $inputfname, $ext)=@_;
  my $runautostructuring="";
  if(defined $style){
        if($style eq "none"){
	  #Only Structuring
	  my $runTagtoColorScrpit="";
	  if (defined $perlmode){
	    $runTagtoColorScrpit="perl \"${SCRITPATH}\/BibRestructuring.pl\" -f \"$InputFile\" -o tag2color";
	  }else{
	    $runTagtoColorScrpit="\"${SCRITPATH}\/BibRestructuring.pl\" -f \"$InputFile\" -o tag2color";
	  }
	  system($runTagtoColorScrpit);
	  if(defined $xmlOption){
	    if($application eq "Reflexica" or $application eq "Bookmetrix"){
	      &RefXML($InputFile, "xml", $xmlOption, $application);
	    }
	  }
	}else{
	  # Structuring and Re-Structuring
	  if (defined $perlmode){
	    if (defined $client){
	      $runautostructuring="perl \"${SCRITPATH}\/BibRestructuring.pl\" -f \"$InputFile\" -o htmlautostruct -s $style -c $client -l $language -a $application -i bibstyle.ini";
	    }else{
	      $runautostructuring="perl \"${SCRITPATH}\/BibRestructuring.pl\" -f \"$InputFile\" -o htmlautostruct -s $style -l $language -a $application -i bibstyle.ini";
	    }
	  }else{
	    if (defined $client){
	      $runautostructuring="\"${SCRITPATH}\/BibRestructuring.pl\" -f \"$InputFile\" -o htmlautostruct -s $style -c $client -l $language -a $application -i bibstyle.ini";
	    }else{
	      $runautostructuring="\"${SCRITPATH}\/BibRestructuring.pl\" -f \"$InputFile\" -o htmlautostruct -s $style -l $language -a $application -i bibstyle.ini";
	    }
	  }
	  system($runautostructuring);
	  if(defined $xmlOption){
	    if($application eq "Reflexica" or $application eq "Bookmetrix"){
	      &RefXML($InputFile, "xml", $xmlOption, $application);
	    }
	  }
	}
      }else{
	#Only Structuring
	my $runTagtoColorScrpit="";
	if (defined $perlmode){
	  $runTagtoColorScrpit="perl \"${SCRITPATH}\/BibRestructuring.pl\" -f \"$InputFile\" -o tag2color";
	}else{
	  $runTagtoColorScrpit="\"${SCRITPATH}\/BibRestructuring.pl\" -f \"$InputFile\" -o tag2color";
	}
	system($runTagtoColorScrpit);
	if(defined $xmlOption){
	  if($application eq "Reflexica" or $application eq "Bookmetrix"){
	    &RefXML($InputFile, "xml", $xmlOption, $application);
	  }
	}
      }
}#sub End

#===========================================================================================================================================
sub TexInputReStructuring{
  my ($SCRITPATH, $inputfname, $ext)=@_;
  if (defined $style){
      if($style eq "none"){
	#tag2texcolor for Only Structuring
	my $runTagtoColorScrpit="";
	if (defined $perlmode){
	  $runTagtoColorScrpit="perl \"${SCRITPATH}\/BibRestructuring.pl\" -f \"$InputFile\" -o tag2texcolor";
	}else{
	  $runTagtoColorScrpit="\"${SCRITPATH}\/BibRestructuring.pl\" -f \"$InputFile\" -o tag2texcolor";
	}
	system($runTagtoColorScrpit); 
	if(defined $xmlOption){
	  if($application eq "Reflexica" or $application eq "Bookmetrix"){
	    &RefXML($InputFile, "xml", $xmlOption, $application);
	  }
	}
      }else{
	# Structuring and Re-Structuring ***********
	my $runautostructuring="";
	if (defined $perlmode){
	  $runautostructuring="perl \"${SCRITPATH}\/BibRestructuring.pl\" -f \"$InputFile\" -o texautostruct -s $style -a $application -l $language -i bibstyle.ini";
	}else{
	  $runautostructuring="\"${SCRITPATH}\/BibRestructuring.pl\" -f \"$InputFile\" -o texautostruct -s $style -a $application -l $language -i bibstyle.ini";
	}
	system($runautostructuring);
	if(defined $xmlOption){
	  if($application eq "Reflexica" or $application eq "Bookmetrix"){
	    &RefXML($InputFile, "xml", $xmlOption, $application);
	  }
	}
      }
  }else{
    #tag2texcolor for Only Structuring
    my $runTagtoColorScrpit="";
    if (defined $perlmode){
      $runTagtoColorScrpit="perl \"${SCRITPATH}\/BibRestructuring.pl\" -f \"$InputFile\" -o tag2texcolor";
    }else{
      $runTagtoColorScrpit="\"${SCRITPATH}\/BibRestructuring.pl\" -f \"$InputFile\" -o tag2texcolor";
    }
    system($runTagtoColorScrpit);   #Only Structuring
    if(defined $xmlOption){
      if($application eq "Reflexica" or $application eq "Bookmetrix"){
	&RefXML($InputFile, "xml", $xmlOption, $application);
      }
    }
  }
}
#==========================================================================================================================================
sub RefXML{
  my $InputFile=shift;
  my $xmlext=shift;
  my $xmlOption=shift;
  my $application=shift;

  use ReferenceManager::AplusCleanup;
  use ReferenceManager::xmlConv;
  my $SourceText=ColorToAPlusXml($InputFile);
  $SourceText=~s/<[\/]?petemp>//gs;
                    ##my $ext="xml";
                    ##$xmlOption="A++" if(!defined $xmlOption);
  XmlTaging($SourceText, $inputfname, $xmlext, $xmlOption, $application);
}

#===========================================================================================================
sub QuotePuncHandle{
  my $TextBody=shift;

  $$TextBody=~s/([\.\,\:]+)<\/$regx{titlesPubNamLoc}>/<\/$2>$1/gs;
  $$TextBody=~s/<\/$regx{titlesPubNamLoc}>\.\:/\.<\/$1>\:/gs;
  $$TextBody=~s/<\/$regx{titlesPubNamLoc}>\.\,/\.<\/$1>\,/gs;
  $$TextBody=~s/<(pbl|cny|at)><\/\1>//gs;

  $$TextBody=~s/([”])([  ])<\/$regx{titlesPubNamLoc}>/$1<\/$3>/gs;
  #$$TextBody=~s/<$regx{titlesPubNamLoc}>â((?:(?!<\/\1>)(?!<\1>).)*)â<\/\1>/â<$1>$2<\/$1>â/gs;
  #$$TextBody=~s/<$regx{titlesPubNamLoc}>“((?:(?!<\/\1>)(?!<\1>).)*)”<\/\1>/“<$1>$2<\/$1>”/gs;
  #$$TextBody=~s/<$regx{titlesPubNamLoc}>‘((?:(?!<\/\1>)(?!<\1>).)*)’<\/\1>/‘<$1>$2<\/$1>’/gs;
  #$$TextBody=~s/<$regx{titlesPubNamLoc}>\`\`((?:(?!<\/\1>)(?!<\1>).)*)\"<\/\1>/\`\`<$1>$2<\/$1>\"/gs;
  #$$TextBody=~s/<$regx{titlesPubNamLoc}>\`\`((?:(?!<\/\1>)(?!<\1>).)*)\'\'<\/\1>/\`\`<$1>$2<\/$1>\'\'/gs;
  #$$TextBody=~s/<$regx{titlesPubNamLoc}>\`((?:(?!<\/\1>)(?!<\1>).)*)\'<\/\1>/\`<$1>$2<\/$1>\'/gs;
  #$$TextBody=~s/<$regx{titlesPubNamLoc}>([“])((?:(?!<\/\1>)(?!<\1>).)*)([\,]?[”  ]+)<\/\1>/$2<$1>$3<\/$1>$4/gs;
  #$$TextBody=~s/<$regx{titlesPubNamLoc}>“((?:(?!<\/\1>)(?!<\1>).)*)“<\/\1>/“<$1>$2<\/$1>“/gs;
  #$$TextBody=~s/<$regx{titlesPubNamLoc}>“((?:(?!<\/\1>)(?!<\1>).)*)\,”<\/\1>/“<$1>$2<\/$1>\,”/gs;
  #$$TextBody=~s/<$regx{titlesPubNamLoc}>“((?:(?!<\/\1>)(?!<\1>).)*)”<\/\1>/“<$1>$2<\/$1>”/gs;
  #$$TextBody=~s/<$regx{titlesPubNamLoc}>„((?:(?!<\/\1>)(?!<\1>).)*)“<\/\1>/„<$1>$2<\/$1>“/gs;
  #$$TextBody=~s/<$regx{titlesPubNamLoc}>‚((?:(?!<\/\1>)(?!<\1>).)*)‘<\/\1>/‚<$1>$2<\/$1>‘/gs;
  #$$TextBody=~s/<$regx{titlesPubNamLoc}>(\"|\&quot\;)((?:(?![\"\'\`]+?)(?!‚)(?!\&quot\;)(?!”)(?!<\/\1>)(?!<\1>).)*)<\/\1>/$2<$1>$3<\/$1>/gs;
#print $$TextBody;exit;

  $$TextBody=~s/<$regx{titlesPubNamLoc}>([\.]+)/$2<$1>/gs;
  $$TextBody=~s/<\/(misc1|bt|collab|pt|at)>\)([\.\,\:])/\)<\/$1>$2/gs;
  $$TextBody=~s/([\.\,\:])<\/$regx{titlesPubNamLoc}>/<\/$2>$1/gs;
  $$TextBody=~s/\.<\/aug>([\:\,]?) ([^0-9\(]*?)/<\/aug>\.$1 $2/gs;
  $$TextBody=~s/<bib([^<>]*?) number=\"([\[\]\(\)a-zA-Z0-9\.]+)\">/<bib$1>\&lt\;number\&gt\;$2\&lt\;\/number\&gt\;/gs;
  $$TextBody=~s/([\n]*)$//gs;
  $$TextBody=~s/<\/(i|b)>([\;\,\.])<\/(misc1|bt|collab|pbl|cny|pt|at|v|iss)>/<\/$1><\/$3>$2/gs;
  $$TextBody=~s/ ([^\& ]+)([\;\,])<\/(misc1|bt|collab|pbl|cny|pt|at|v|iss)>/ $1<\/$3>$2/gs;
  $$TextBody=~s/<$regx{titlesPubNamLoc}>(et al[\.\,]*) /$2 <$1>/gs;
  $$TextBody=~s/<$regx{bookTitlesCollab}>([\(\[]?)$regx{editorSuffix}([\)\]]?)<\/\1>/$2$3$4/gs;
  $$TextBody=~s/([\,\.]) <$regx{bookTitlesCollab}>([\(\[]?)$regx{editorSuffix}([\)\]]?)([\.\:]?) /$1 $3$4$5$6 <$2>/gs;
  $$TextBody=~s/([\,\;\. ]+)<$regx{bookTitlesCollab}>$regx{editorSuffix}([\.\:\)]+?)<\/\2>/$1$3$4/gs;
  $$TextBody=~s/<$regx{titlesPubNamLoc}>([\)\]\.\;\'\"\(\) ]+)<\/\1>/$2/gs;
  #$$TextBody=~s/<(bt|misc1|collab|at)>(|�|“|‘|�|[��]+)<\1>((?:(?!<[\/]?\1>).)+?)<\/\1>(|�|”|’||[�]+)<\/\1>/$2<$1>$3<\/$1>$4/gs;
  #$$TextBody=~s/<(bt|misc1|collab|at)>(\&\#x201C\;|\&ldquo\;)((?:(?!<[\/]?\1>)(?!\2).)+?)(\&\#x201D\;|\&rdquo\;)<\/\1>/$2<$1>$3<\/$1>$4/gs;
  #$$TextBody=~s/<(bt|misc1|collab|at)>(\&\#x2018\;|\&lsquo\;)((?:(?!<[\/]?\1>)(?!\2).)+?)(\&\#x2019\;|\&rdquo\;)<\/\1>/$2<$1>$3<\/$1>$4/gs;

  return $TextBody;
}

#===========================================================================================================

sub PubLocMarkNexToBt{
  my $TextBody=shift;

  #Logical <cny>   #. Cambridgexl (KK)</bt>: <pbl>Polity Press</pbl></bib>   #. Cambridgexl</bt> (<cny>UK</cny>): <pbl>
  $$TextBody=~s/\:<\/bt> <pbl>/<\/bt>\: <pbl>/gs;
  $$TextBody=~s/(\.|[\!\?]\;|\)[\,]?) ([^\.<>\(\)]+? [A-Z\(\)\. ]+)<\/bt>\: <pbl>$regx{noTagAnystring}<\/pbl>$regx{bookLastElemnt}/<\/bt>$1 <cny>$2<\/cny>\: <pbl>$3<\/pbl>$4$5/gs;
  $$TextBody=~s/(\,) ([^\.<>\(\)\,]+? [A-Z\(\)\. ]+)<\/bt>\: <pbl>$regx{noTagAnystring}<\/pbl>$regx{bookLastElemnt}/<\/bt>$1 <cny>$2<\/cny>\: <pbl>$3<\/pbl>$4$5/gs;
  $$TextBody=~s/>(\.|[\!\?]\;|\)[\,]?) ([^\.\,<>]+?)<\/bt>\: <pbl>$regx{noTagAnystring}<\/pbl>$regx{bookLastElemnt}/><\/bt>$1 <cny>$2<\/cny>\: <pbl>$3<\/pbl>$4$5/gs;
  $$TextBody=~s/>(\.|[\!\?]\;|\)[\,]?) ([^\.<>]+?)<\/bt>\: <pbl>$regx{noTagAnystring}<\/pbl>$regx{bookLastElemnt}/><\/bt>$1 <cny>$2<\/cny>\: <pbl>$3<\/pbl>$4$5/gs;
  $$TextBody=~s/(\.|[\!\?]\;|\)[\,]?) ([^\.\,<>\)]+?)<\/bt>\: <pbl>$regx{noTagAnystring}<\/pbl>$regx{bookLastElemnt}/<\/bt>$1 <cny>$2<\/cny>\: <pbl>$3<\/pbl>$4$5/gs;
  $$TextBody=~s/(\.|[\!\?]\;|\)[\,]?) ([^\.<>\)]+?)<\/bt>\: <pbl>$regx{noTagAnystring}<\/pbl>$regx{bookLastElemnt}/<\/bt>$1 <cny>$2<\/cny>\: <pbl>$3<\/pbl>$4$5/gs;
  $$TextBody=~s/(\,) ([^<>\.\,\)]+?)<\/bt>\: <pbl>$regx{noTagAnystring}<\/pbl>$regx{bookLastElemnt}/<\/bt>$1 <cny>$2<\/cny>\: <pbl>$3<\/pbl>$4$5/gs;
  $$TextBody=~s/(\.|[\!\?]\;|\)[\,]?) ([^<>\.\,\)]+?)<\/bt> \(<cny>([A-Z\.]+)<\/cny>\)([\:\,]) <pbl>/<\/bt>$1 <cny>$2 \($3\)<\/cny>$4 <pbl>/gs;
  $$TextBody=~s/<\/bt>([\.\;\,\( ]+)<pbl>$regx{noTagAnystring}<\/pbl>\: ([^\.<>\(\)\,]+? [A-Z\(\)\. ]+)$regx{bookLastElemnt}/<\/bt>$1<pbl>$2<\/pbl>\: <cny>$3<\/cny>$4/gs;
  $$TextBody=~s/<\/bt>([\.\;\,\( ]+)<pbl>$regx{noTagAnystring}<\/pbl>\: ([^\.<>\(\)0-9\,]+?)$regx{bookLastElemnt}/<\/bt>$1<pbl>$2<\/pbl>\: <cny>$3<\/cny>$4/gs;
  $$TextBody=~s/<\/bt>((?:(?!<[\/]?cny>)(?!<[\/]?yr>)(?!<[\/]?pbl>)(?!<[\/]?bib>).)*?)<pbl>$regx{noTagAnystring}<\/pbl>: ([^<>\.0-9\[\](\)]+?)$regx{bookLastElemnt}/<\/bt>$1<pbl>$2<\/pbl>\: <cny>$3<\/cny>$4/gs;

  $$TextBody=~s/<cny>([^<>]+?)<\/cny> \(([A-Z][A-Z]+)\)\: /<cny>$1 \($2\)<\/cny>\: /gs;


  return $TextBody;
}
#===========================================================================================================

sub PubNameMarkNexToBt{
  my $TextBody=shift;

  $$TextBody=~s/<([a-z]+)><\/\1>//gs;
  $$TextBody=~s/<(bt|at|misc1|pt)>([\.\,\:\;])<\/\1>/$2/gs;
  $$TextBody=~s/<cny>$regx{noTagAnystring}\: $regx{noTagAnystring}<\/cny>([\,]?) ([^<>\.0-9\[\]]+?)$regx{bookLastElemnt}/<cny>$1<\/cny>\: $2$3 $4$5/gs;
  $$TextBody=~s/[ ]?([\:\.\,])<\/bt> <cny>/<\/bt>$1 <cny>/gs;
  $$TextBody=~s/>(\.|[\!\?]\;|\)[\,]?) ([^\.\,<>\[\]\(\)]+?)<\/bt>\: <cny>$regx{noTagAnystring}<\/cny>$regx{bookLastElemnt}/><\/bt>$1 <pbl>$2<\/pbl>\: <cny>$3<\/cny>$4$5/gs;
  $$TextBody=~s/>(\.|[\!\?]\;|\)[\,]?) ([^\.<>\[\]\(\)]+?)<\/bt>\: <cny>$regx{noTagAnystring}<\/cny>$regx{bookLastElemnt}/><\/bt>$1 <pbl>$2<\/pbl>\: <cny>$3<\/cny>$4$5/gs;
  $$TextBody=~s/(\.|[\!\?]\;|\)[\,]?) ([^\.\,<>\[\]\(\)]+?)<\/bt>\: <cny>$regx{noTagAnystring}<\/cny>$regx{bookLastElemnt}/<\/bt>$1 <pbl>$2<\/pbl>\: <cny>$3<\/cny>$4$5/gs;
  $$TextBody=~s/(\.|[\!\?]\;|\)[\,]?) ([^\.<>\[\]\(\)]+?)<\/bt>\: <cny>$regx{noTagAnystring}<\/cny>$regx{bookLastElemnt}/<\/bt>$1 <pbl>$2<\/pbl>\: <cny>$3<\/cny>$4$5/gs;
  $$TextBody=~s/(\,) ([^<>\.\,\)]+?)<\/bt>\: <cny>$regx{noTagAnystring}<\/cny>$regx{bookLastElemnt}/<\/bt>$1 <pbl>$2<\/pbl>\: <cny>$3<\/cny>$4$5/gs;
  $$TextBody=~s/<\/bt>([\.\;\,\( ]+)<cny>$regx{noTagAnystring}<\/cny>\: ([^<>\.0-9\[\]]+?\([^<>\.0-9\[\]]+\))$regx{bookLastElemnt}/<\/bt>$1<cny>$2<\/cny>\: <pbl>$3<\/pbl>$4/gs;
  $$TextBody=~s/<\/bt>([\.\;\,\( ]+)<cny>$regx{noTagAnystring}<\/cny>\: ([^<>\.0-9\[\](\)]+?)$regx{bookLastElemnt}/<\/bt>$1<cny>$2<\/cny>\: <pbl>$3<\/pbl>$4/gs;
  $$TextBody=~s/<\/bt>\. <cny>$regx{noTagAnystring}<\/cny>\: ([^<>\.0-9\[\](\)]+?)([\.\;, ]+)<yr>/<\/bt>\. <cny>$1<\/cny>\: <pbl>$2<\/pbl>$3<yr>/gs;
  $$TextBody=~s/<\/bt>\. <cny>$regx{noTagAnystring}<\/cny>\: ([^<>\.0-9\[\](\)]+?)([\.\;, ]+)$regx{pagePrefix}$regx{optionalSpace}<pg>/<\/bt>\. <cny>$1<\/cny>\: <pbl>$2<\/pbl>$3$4$5<pg>/gs;
  $$TextBody=~s/<\/bt>\. <cny>$regx{noTagAnystring}<\/cny>\: ([^<>\.0-9\[\](\)]+?)([\.\;, ]+)<pg>/<\/bt>\. <cny>$1<\/cny>\: <pbl>$2<\/pbl>$3<pg>/gs;

  #<bt> <cny>Washington, DC</cny>: The National Academies Press.; <yr>

  $$TextBody=~s/([\,\.]) $regx{monthPrefix}<\/pbl> <yr>$regx{noTagAnystring}<\/yr>/<\/pbl>$1 $2 <yr>$3<\/yr>/gs;
  $$TextBody=~s/<\/bt>([\.\,\:\; ]+)<pbl>([^<>]+?)<\/pbl>([\,\.\: ]+)([A-Z][A-Z])([\.]?)<\/bib>/<\/bt>$1<pbl>$2<\/pbl>$3<cny>$4<\/cny>$5<\/bib>/gs;

  #check ***: Routledge & Kegan Paul 1987</bib>
  $$TextBody=~s/<bib([^<>]*?)>((?:(?!<[\/]?cny>)(?!<[\/]?yr>)(?!<[\/]?pbl>)(?!<[\/]?bib>).)*?)<cny>([^<>]+?)<\/cny>([\.\;\:\, ]+)([^<>\.\:\(]*?) ($regx{year})(\p{P}?)<\/bib>/<bib$1>$2<cny>$3<\/cny>$4<pbl>$5<\/pbl> <yr>$6<\/yr>$7<\/bib>/gs;
  $$TextBody=~s/<bib([^<>]*?)>((?:(?!<[\/]?cny>)(?!<[\/]?yr>)(?!<[\/]?pbl>)(?!<[\/]?bib>).)*?)<pbl>([^<>]+?)<\/pbl>([\.\;\:\, ]+)([^<>\:\(]*?) ($regx{year})(\p{P}?)<\/bib>/<bib$1>$2<pbl>$3<\/pbl>$4<cny>$5<\/cny> <yr>$6<\/yr>$7<\/bib>/gs;
  $$TextBody=~s/<bib([^<>]*?)>((?:(?!<[\/]?cny>)(?!<[\/]?pg>)(?!<[\/]?pbl>)(?!<[\/]?bib>).)*?)<cny>([^<>]+?)<\/cny>([\.\;\:\, ]+)([^<>0-9\(\:\.]*?)([\.\;\:\, ]+)(S[\.]?|p[\.]?|pp[\.]?|P[\.]?)([\s]?)<pg>/<bib$1>$2<cny>$3<\/cny>$4<pbl>$5<\/pbl>$6$7$8<pg>/gs;
  $$TextBody=~s/<bib([^<>]*?)>((?:(?!<[\/]?cny>)(?!<[\/]?pg>)(?!<[\/]?pbl>)(?!<[\/]?bib>).)*?)<pbl>([^<>]+?)<\/pbl>([\.\;\:\, ]+)([^<>0-9\:\(]*?)([\.\;\:\, ]+)(S[\.]?|p[\.]?|pp[\.]?|P[\.]?)([\s]?)<pg>/<bib$1>$2<cny>$3<\/cny>$4<cny>$5<\/cny>$6$7$8<pg>/gs;

  #(<yr>1995</yr>) <bt><i>Masculinities</i> Sydne</bt>: <pbl>Allen & Unwin</pbl></bib>
  $$TextBody=~s/<bt><i>([^<>]+?)<\/i> ([\a-zA-Z ]+)<\/bt>\: <pbl>([^<>]+?)<\/pbl>$regx{bookLastElemnt}/<bt><i>$1<\/i><\/bt> <cny>$2<\/cny>\: <pbl>$3<\/pbl>$4/gs;
  $$TextBody=~s/<bt><i>([^<>]+?)<\/i> ([\a-zA-Z ]+)<\/bt>\: <cny>([^<>]+?)<\/cny>$regx{bookLastElemnt}/<bt><i>$1<\/i><\/bt> <pbl>$2<\/pbl>\: <cny>$3<\/cny>$4/gs;

  $$TextBody=~s/<\/bt>((?:(?!<[\/]?cny>)(?!<[\/]?yr>)(?!<[\/]?pbl>)(?!<[\/]?bib>).)*?)<cny>$regx{noTagAnystring}<\/cny>: ([^<>\.0-9\[\](\)]+?)$regx{bookLastElemnt}/<\/bt>$1<cny>$2<\/cny>\: <pbl>$3<\/pbl>$4/gs;

  return $TextBody;
}
#===========================================================================================================
sub EndCommnetMarking{
  my $TextBody=shift;

  $$TextBody=~s/<\/pt>((?:(?!<[\/]?comment>)(?!<bib)(?!<\/bib>).)*?)<v>([^<>]+?)<\/v>((?:(?!<[\/]?comment>)(?!<bib)(?!<\/bib>).)*?)<(pbl|cny)>([^<>]+?)<\/\4>([\:\.\,\; ]+?)<(pbl|cny)>([^<>]+?)<\/\7>([\.]?)<\/bib>/<\/pt>$1<v>$2<\/v>$3<comment>$5$6$8<\/comment>$9<\/bib>/gs;
  $$TextBody=~s/<\/pt>((?:(?!<[\/]?comment>)(?!<bib)(?!<\/bib>).)*?)<v>([^<>]+?)<\/v>((?:(?!<[\/]?comment>)(?!<bib)(?!<\/bib>).)*?)<(pbl|cny)>((?:(?!<[\/]?comment>)(?!<bib)(?!<[\/]?pt>)(?!<[\/]?v>)(?!<[\/]?\4>)(?!<[\/]?bib>).)*?)<\/\4>([\.]?)<\/bib>/<\/pt>$1<v>$2<\/v>$3<comment>$5<\/comment>$6<\/bib>/gs;

  while($$TextBody=~s/<comment>((?:(?!<[\/]?comment>)(?!<bib)(?!<\/bib>).)+?)<(pt|cny|pbl)>([^<>]*?)<\/\2>((?:(?!<[\/]?comment>)(?!<bib)(?!<\/bib>).)*?)<\/comment>/<comment>$1$3$4<\/comment>/gs){}

  $$TextBody=~s/<\/(v|iss|pg|yr|cny|pbl|doig|url|issn|doi)>([\.\,\:\; ]+)((?:(?!<[\/]?v>)(?!<[\/]?iss>)(?!<[\/]?pg>)(?!<[\/]?yr>)(?!<[\/]?pbl>)(?!<[\/]?cny>)(?!<[\/]?doi[g]?>)(?!<[\/]?issn[g]?>)(?!<[\/]?at>)(?!<[\/]?ia>)(?!<[\/]?edn>)(?!<[\/]?edrg>)(?!<[\/]?url>)(?!<[\/]?comment>)(?!<[\/]?aug>)(?!<[\/]?pt>)(?!<[\/]?misc1>)(?!<[\/]?bt>)(?!<[\/]?isbn[g]?>)(?!<\/bib>).)*?)([\.]?)<\/bib>/<\/$1>$2<comment>$3<\/comment>$4<\/bib>/gs;

  $$TextBody=~s/<bib([^<>]*?)><aug>((?:(?!<[\/]?aug>)(?!<\/bib>).)*?)<\/aug>([\.\,\:\( ]+)<yr>([^<>]+?)<\/yr>([\.\)\, ]+)<comment>((?:(?!<[\/]?comment>)(?!<\/bib>).)*?)<\/comment>([\.]?)<\/bib>/<bib$1><aug>$2<\/aug>$3<yr>$4<\/yr>$5$6<\/bib>/gs;

  $$TextBody=~s/\(<pbl>([^<>\)\(]+?)<\/pbl>([\,\.\: ]+)<cny>([^<>\)\(]+?)<\/cny>([\,\.\: ]+)<comment>([^\(\)\[\]+]+)\)([\.\,\:\; ]+ [^<>]+?)<\/comment>/\(<pbl>$1<\/pbl>$2<cny>$3<\/cny>$4$5\)$6/gs;
  $$TextBody=~s/<pg>$regx{page}<\/pg> <comment>$regx{pagePrefix}<\/comment>([\.]?)<\/bib>/<pg>$1<\/pg> $2$3<\/bib>/gs;
  $$TextBody=~s/([\.\,\: ]+)<comment>$regx{pagePrefix}$regx{optionalSpace}$regx{page}([ \.\,\:]+)/$1$2$3<pg>$4<\/pg>$5<comment>/gs;
  $$TextBody=~s/<comment><\/comment>//gs;
  $$TextBody=~s/\(([^\(\)<>]+)<\/([a-z0-9]+)> <comment>([^<>\(\)]+?)\)<\/comment>/<\/$2><comment>\($1 $3\)<\/comment>/gs;
  #print $$TextBody;#exit;

  $$TextBody=~s/\[([^<>\[\]]+?)<comment>([^<>\[\]]+?)\]([^<>]+?)<\/comment>/<comment>\[$1$2\]$3<\/comment>/gs;
  $$TextBody=~s/\(([^<>\(\)]+?)<comment>([^<>\(\)]+?)\)([^<>]+?)<\/comment>/<comment>\($1$2\)$3<\/comment>/gs;
  $$TextBody=~s/<comment>([^<>\(\)]+?)\)<\/comment>/<comment>$1<\/comment>\)/gs;

  $$TextBody=~s/<bib([^<>]*?)>((?:(?!<[\/]?yr>)(?!<[\/]?comment>)(?!<bib)(?!<\/bib>).)*?)<(pbl|cny)>([^<>]+?)<\/\3>([\,\.]) $regx{year}([\,\.]?) <comment>([^<>]+?)<\/comment>((?:(?!<[\/]?yr>)(?!<[\/]?comment>)(?!<bib)(?!<\/bib>).)*?)<\/bib>/<bib$1>$2<$3>$4<\/$3>$5 <yr>$6<\/yr>$7 <comment>$8<\/comment>$9<\/bib>/gs;
  $$TextBody=~s/<comment>([\)\]])<\/comment>([\.]?)<\/bib>/$1$2<\/bib>/gs;
  $$TextBody=~s/<comment>\)<\/comment>/\)/gs;

  return $$TextBody;
}
#===========================================================================================================
sub removeComment{
  my $TextBody=shift;

  #-----------------shoud be revert-----
  #$TextBody=~s/<comment>([^<>]+?)<\/comment>([\.]?)<\/bib>/&comment\;$1\&\/comment\;$2<\/bib>/gs;
  $$TextBody=~s/<([\/]?)comment>//gs;
  $$TextBody=~s/\&([\/]?)comment\;/<$1comment>/gs;
  return $$TextBody;
}

#============================================================================================================

sub iatoEdrg{
  my $TextBody=shift;

  while($$TextBody=~/<ia>([Ii]n[\:\.\, ]+)([A-Z][^0-9\.\,\;\&]+?) ([A-Z][^0-9\.\,\;\&]+?) \($regx{editorSuffix}([\.]?)\)<\/ia>/s)
    {
      my $iaText="$2 $3";
      if($iaText=~/\b$regx{instName}\b/)
	{
	  $$TextBody=~s/<ia>([Ii]n[\:\.\, ]+)([A-Z][^0-9\.\,\;\&]+?) ([A-Z][^0-9\.\,\;\&]+?) \($regx{editorSuffix}([\.]?)\)<\/ia>/<iaX>$1$2 $3 \($4$5\)<\/iaX>/s;
	}else{
	  $$TextBody=~s/<ia>([Ii]n[\:\.\, ]+)([A-Z][^0-9\.\,\;\&]+?) ([A-Z][^0-9\.\,\;\&]+?) \($regx{editorSuffix}([\.]?)\)<\/ia>/<edrg>$1<edr><edm>$2<\/edm> <eds>$3<\/eds><\/edr> \($4$5\)<\/edrg>/s;
	}
    }

  while($$TextBody=~/<ia>([Ii]n[\:\.\, ]+)([A-Z][^0-9\.\,\;\&]+?) ([A-Z][^0-9\.\,\;\&]+?) $regx{editorSuffix}([\.]?)<\/ia>/s)
    {
      my $iaText="$2 $3";
      if($iaText=~/\b$regx{instName}\b/)
	{
	  $$TextBody=~s/<ia>([Ii]n[\:\.\, ]+)([A-Z][^0-9\.\,\;\&]+?) ([A-Z][^0-9\.\,\;\&]+?) $regx{editorSuffix}([\.]?)<\/ia>/<iaX>$1$2 $3 $4$5<\/iaX>/s;
	}else{
	  $$TextBody=~s/<ia>([Ii]n[\:\.\, ]+)([A-Z][^0-9\.\,\;\&]+?) ([A-Z][^0-9\.\,\;\&]+?) $regx{editorSuffix}([\.]?)<\/ia>/<edrg>$1<edr><edm>$2<\/edm> <eds>$3<\/eds><\/edr> $4$5<\/edrg>/s;
	}
    }
  $$TextBody=~s/<([\/]?)iaX>/<$1ia>/gs;

  return $TextBody;
}


#===========================================================================================================================

sub RefSort{
  my $TextBody=shift;

  #<bib id="bib4"><aug><au><auf>P.</auf> <aus>Sucan</aus></au>, <au><auf>Ph.</auf> <aus>Mauron</aus></au></aug>, <at>Ch.&#8201;Emmenegger</at>, <pt>J. Power Sources</pt> <v>118</v>, <pg>1</pg> (<yr>2003</yr>).</bib>
  my %RefData=();
  my @AuthorYear=();
  while($TextBody=~s/<bib id="([^<>\"]+)">((?:(?!<bib id)(?!<[\/]?bib>).)*?)<\/bib>//s)
    {
      my $refid="$1";
      my $refText="$2";
      my $RefNumberLabel=$1 if($refText=~s/^\s*\&lt\;number\&gt\;((?:(?!\&lt\;[\/]?number\&gt\;).)*?)\&lt\;\/number\&gt\;//);
      $refText=~s/^\s*//gs;
      my $nameString=$2 if($refText=~/^<(aug|ia|edrg)>((?:(?!<[\/]?aug>)(?!<[\/]?edrg>)(?!<[\/]?ia>).)*?)<\/\1>/);
      my $Year=$1 if($refText=~/<yr>([^<>]+)<\/yr>/);
      my $SirName="";
      my $TempnameString=$nameString;
      my $SirName="";
       while ($TempnameString=~s/<(aus|eds|ia)>((?:(?!<[\/]?aus>)(?!<[\/]?eds>)(?!<[\/]?ia>).)*?)<\/\1>//s){
	 if ($SirName eq ""){
	   $SirName="$2";
	 }else{
	   $SirName=$SirName. " $2";
	 }
       }
      push(@AuthorYear, "$SirName $Year $refid");
      $RefData{"$SirName $Year $refid"}="<bib id=\"$refid\"><number>$RefNumberLabel<\/number>$refText<\/bib>";
    }
  my $sortData="";
  foreach my $Key (sort (keys %RefData)){
    $sortData="$sortData"."$RefData{$Key}\n";
  }

  return $sortData;
}


#===========================================================================================================================

 sub RefrenceStylehelp
  {
    print "###############################################################################\n";
    print "# Syntax: BibRestructuring.pl <File Location> OPTION <Reference Style>        #\n";
    print "#                                                                             #\n";
    print "#    <Reference Styles>                              => <Environments>        #\n";
    print "#                                                                             #\n";
    print "# 1. Basic Springer Reference Style                  =>   Basic               #\n";
    print "# 2. Chemistry Reference Style                       =>   Chemistry           #\n";
    print "# 3. Math and Physical Sciences Reference Style      =>   MPS                 #\n";
    print "# 4. American Physical Society (APS) Reference Style =>   APS                 #\n";
    print "# 5. Vancouver Reference Style                       =>   Vancouver           #\n";
    print "# 6. APA Reference Style (Springer)                  =>   APA                 #\n";
    print "# 7. Chicago Reference Style                         =>   Chicago             #\n";
    print "# 8. Pure APA Reference Style                        =>   ApaOrg              #\n";
    print "# 9. Elsevier APA Reference Style                    =>   ElsAPA5             #\n";
    print "# 10. Elsevier Vancouver Reference Style             =>   ElsVancouver        #\n";
    print "# 11. Elsevier ACS 3rd Edition Reference Style       =>   ElsACS              #\n";
    print "# 12. As per manuscript                              =>   none                #\n";
    print "###############################################################################\n";
    exit;
}
#===========================================================================================================================================
sub readSourceFile{
  my $InputFile=shift;
  undef $/;
  open(INFILE,"<$$InputFile")|| die("$InputFile File cannot be opened\n");
  my $SourceText=<INFILE>;
  close(INFILE);

  return \$SourceText;
}
#=============================================================================================================================================

