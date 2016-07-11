#!/usr/local/bin/perl

 BEGIN {
    our $SCRITPATH=$0;
    $SCRITPATH=~s/(.*)([\/\\])(.*?)\.(pl|exe)/$1/g;
};

use lib "$SCRITPATH/lib";

#Version 1.0.0.0
#Revision 1.1.2.0
#Revision 1.1.3.0
#Revision 1.1.4.0
#Revision 1.2.2.0
#Revision 1.3.0.0
#Revision 1.4.0.0
#Revision 1.5.1.0
#Revision 1.5.2.0
#Revision 2.0.0.0
#Revision 2.0.1.0
#Revision 2.0.2.0
#Revision 2.0.3.0
#Revision 2.1.4.0
#Revision 3.0.0.0
#Revision 3.0.1.0
#Revision 3.0.1.1
#Revision 3.2.0.3
#Revision 3.3.0.0
#Revision 3.3.1.0
#Revision 3.3.2.0
#Revision 3.4.0.0
#Revision 3.5.0.0
#Author: Neyaz Ahmad

#perl d:/Working/ReferenceManager/newRefManager/BibRestructuring.pl -f d:/RefeTest/test.htm -o htmlrestuct -s Basic
#############################################################################################################################
#                                                                                                                           #
# Name: BibRestructuring.pl (Perl script)                                                                                   #
# Author: Neyaz Ahmad; neyaz.ahmad@crest-premedia.in                                                                        #
# Created on: 29 Jan 2013                                                                                                   #
# Scope:  Refrence Restructuring                                                                                            #
# Client: Springer                                                                                                          #
#                                                                                                                           #
#############################################################################################################################


##############################################################################################################################
#       <Reference Styles>                           => <Environments>                                                       #
#----------------------------------------------------------------------------------------------------------------------------#
# 1. Basic Springer Reference Style                  =>   Basic                                                              #
# 2. Chemistry Reference Style                       =>   Chemistry                                                          #
# 3. Math and Physical Sciences Reference Style      =>   MPS                                                                #
# 4. American Physical Society (APS) Reference Style =>   APS (MathPhysSci)                                                  #
# 5. Vancouver Reference Style                       =>   Vancouver                                                          #
# 6. APA Reference Style (Springer)                  =>   APA                                                                #
# 7. Chicago Reference Style                         =>   Chicago                                                            #
# 8. Pure APA Reference Style                        =>   ApaOrg                                                             #
# 9. Elsevier APA Reference Style                    =>   ElsAPA5                                                            #
# 10. Elsevier Vancouver Reference Style             =>   ElsVancouver                                                       #
# 11. Elsevier ACS 3rd Edition Reference Style       =>   ElsACS                                                             #
# 12. As per manuscript                              =>   none                                                               #
##############################################################################################################################

#use strict;
#use warnings;
use Getopt::Long ();
use ReferenceManager::ColorTagManage;
use ReferenceManager::TexTagManager;
use ReferenceManager::HtmlTagEntityManage;
use ReferenceManager::ElementGrouping;
use ReferenceManager::ElementReArrange;
use ReferenceManager::RecorededData;
use ReferenceManager::ReferenceRegex;
use ReferenceManager::RefPage;
use ReferenceManager::TagValidation;
#use Lingua::Identify::CLD;
use ReferenceManager::LangEditing;
use ReferenceManager::DeleteMultipleLocation;

my $cls="cls";


######################################################################################################################################
#==============================                   *** Main ***             ===========================================================
my $VERSION="3.6.0.5";
my $SCRITPATH=$0;
$SCRITPATH=~s/(.*)([\/\\])(.*?)\.(pl|exe)/$1/g;
my $command=$0;
my $scriptname=$command;
$scriptname=~s/(.*)([\/\\])(.*?)\.(pl|exe)/$3\.$4/g;


my $OPTIONvalue='(color2tag|tag2color|tag2texcolor|htmlrestuct|texrestuct|htmlautostruct|texautostruct)';
my $STYLEvalue='(none|MPS|MathPhysSci|mps|Basic|Chemistry|APS|Vancouver|APA|Chicago|ApaOrg|ElsAPA5|ElsVancouver|ElsACS)';
my $APPLICATIONvalue='(AMPP|Tex|Catalyst|Reflexica|Bookmetrix)';
my $CLIENTvalue='(springer|elsevier|springerlncs)';
my $LANGUAGEvalue='(En|EN|De|DE)';
my $STYLEINIvalue='(bibstyle.ini)';
my $inputfname;
my $option;
my $style;
my $styleini='bibstyle.ini'; #default
my $language='EN'; #default
my $client;
my $application;
my $xmlOption;
my $help;
my $version;
my $perlmode;
my %regx = ReferenceManager::ReferenceRegex::new();

Getopt::Long::GetOptions(
   'f|filelocation=s' => \$inputfname,
   'o|option=s' => \$option,
   's|style=s' => \$style,
   'i|styleini=s' => \$styleini,
   'l|language=s' => \$language,
   'c|client=s' => \$client,
   'a|application=s' => \$application,
   'x|xml' => \$xmlOption,
   'h|?|help' => \$help,
   'p|perlmode' => \$perlmode,
   'v|version' => \$version
)
or usage("Invalid commmand line options.");
if (defined $help){
  &help;
}
if (defined $version){
  print "Version: $VERSION";
  exit 0;
}

usage("The file name must be specified.")
   unless defined $inputfname;
usage("The option must be specified.")
   unless defined $option;
usage("The option must be specified.")
   unless $option=~/^$OPTIONvalue$/;

if ($option=~/^(htmlrestuct|texrestuct|htmlautostruct|texautostruct)$/){
usage("The option must be specified.")
   unless defined $style;
   if($style!~/^$STYLEvalue$/){
     print "!!Wrong style argument!!\n";
     &RefrenceStylehelp;
   }
}

chomp($inputfname);
chomp($xmlOption);
chomp($style);
chomp($option);
chomp($language);
chomp($styleini);

if (defined $style){
  $style="MPS" if ($style eq "MathPhysSci" || $style eq "mps");
}

if (defined $client){
  $client="\L$client";
 }

#-----------------
##use ReferenceManager::ExpiryDate;
##&CheckExpireDate;
#-----------------

our $InputFile=$inputfname;
#my $ext=$1 if($inputfname=~s/\.([a-z]+)$//os);
$ARGV[0]=$InputFile;
$ARGV[1]=$option;
if (defined $style){
  $ARGV[2]=$style;
}else{
$ARGV[2]="none";
}
$ARGV[3]=$styleini;
$ARGV[4]=$language;
if (defined $application){
  $ARGV[6]=$application;
}else{
  $ARGV[6]="Reflexica";
}
$ARGV[5]="$xmlOption";

if ($style eq "none"){
  print "Error: No Style define \(none\)\!";
  exit;
}

if($option ne ""){
  #system($cls);
  &main;
  print "\n###############################################################################\n\n";
  print "            ********  Job Done  ********\n\n            Developed by Crest Technology\n\n"; 
  print "###############################################################################\n";
}else{
  #system($cls);
  &help;
}

sub usage{
  my $message = $_[0];
  if (defined $message && length $message) {
    $message .= "\n"
      unless $message =~ /\n$/;
  }
  print STDERR (
		$message,
		"usage: $command -f filelocation -o $OPTIONvalue [-s $STYLEvalue] [-i $STYLEINIvalue] [-l $LANGUAGEvalue] [-c $CLIENTvalue] [-a $APPLICATIONvalue] [-x] [-h] [-v]\n\nOR\n\n" .
		"usage: $command -filelocation filelocation -option $OPTIONvalue [-style $STYLEvalue] [-styleini $STYLEINIvalue] [-language $LANGUAGEvalue] [-client $CLIENTvalue] [-application $APPLICATIONvalue] [-xml] [-help] [-version]\n" .

		"       ...\n"
	       );
   die("\n")
 }


########################################################################################################################################

sub help{
  print "\n\n################################################################################\n";
  print "Syntax: $command -f filelocation -o $OPTIONvalue [-s $STYLEvalue] [-i $STYLEINIvalue] [-l $LANGUAGEvalue] [-c $CLIENTvalue] [-a $APPLICATIONvalue] [-x] [-h] [-v]\n";
  print "\nOption can be any from the following:\n\n";
  print "1	Convert Reference's Color to Tag.\n Syntax: $scriptname -f d:/RefeTest/test.htm -o color2tag\n\n";
  print "2	Convert Reference's Tag to Color.\n Syntax: $scriptname -f d:/RefeTest/test.htm -o tag2color\n\n";
  print "3	Reference Restructuring (HTML input).\n Syntax: $scriptname -f d:/RefeTest/test.htm -o htmlrestuct -s Basic -c springer -l En -a AMPP\n\n";
  print "4	Reference Restructuring (TeX/Latex input).\n Syntax: $scriptname -f d:/RefeTest/test.htm -o texrestuct -s APA -c springer -l De -a Tex\n\n";
  print "5	Reference Restructuring for Auto Marking Service.\n Syntax: $scriptname -f test.htm -o htmlautostruct -s MPS -c springer -l De -a Catalyst\n\n";
  print "6	Reference Restructuring for Auto Marking Service.\n Syntax: $scriptname -f test.htm -o texautostruct -s ElsAPA5 -c elsevier -l De -a Catalyst\n\n";
  print "################################################################################\n";
  exit;
}
#=======================================================================================================================================

sub RefrenceStylehelp
{
print "###############################################################################\n";
print "# Syntax: RefRestruct.pl <File Location> OPTION <Reference Style> inifile.ini #\n";
print "#                                                                             #\n";
print "#    <Reference Styles>                              => <Environments>        #\n";
print "#                                                                             #\n";
print "# 1. Basic Springer Reference Style                  =>   Basic               #\n";
print "# 2. Chemistry Reference Style                       =>   Chemistry           #\n";
print "# 3. Math and Physical Sciences Reference Style      =>   MPS(MathPhysSci)    #\n";
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

#=======================================================================================================================================
sub main{
  my $htmfname=$InputFile;
  my $hext=$1 if($htmfname=~s/\.([a-z]+)$//os);
  my $FileText=&OpenInputFile;
  my $InFileText=$FileText;
  
  if($option eq "color2tag"){
    $FileText=&DeleteOrgBib(\$FileText);
    $FileText=htmlPreCleanup(\$FileText);
    $FileText=RefColorToTag($FileText);
    $FileText=~s/<i>([\,\;\:\. ]+)/$1<i>/gs;
    $FileText=~s/<(i|b)>\&lt\;([a-zA-Z0-9]+)\&gt\;/\&lt\;$1\&gt\;\&lt\;$2\&gt\;/gs;
    $FileText=~s/\&lt\;\/([a-zA-Z0-9]+)\&gt\;<\/(i|b)>/\&lt\;\/$1\&gt\;\&lt\;\/$2\&gt\;/gs;
    open(OUTA, ">${htmfname}.$hext")|| die("${htmfname}.$hext File cannot be opened\n");;
    print OUTA "$FileText";
    close(OUTA);
  }
  elsif($option eq "tag2color"){
    #my $FileText=&OpenInputFile;
    $FileText = RefTagToColor($FileText);
    $FileText=~s/\&(i|b|u|sup|sub|sb|sp)\;/<$1>/gs;
    $FileText=~s/\&\/(i|b|u|sup|sub|sb|sp)\;/<\/$1>/gs;
    open(OUTB,">${htmfname}.$hext");
    print OUTB $FileText;
    close(OUTB);
  }
  elsif($option eq "htmlrestuct"){
    $FileText=&RefrenceRestructuring($FileText);  #*****
    &outConvertedFile($FileText, $htmfname, $hext, $InFileText);
  }
  elsif($option eq "htmlautostruct"){
    $FileText=AutoStructRefrenceRestructuring($FileText, $htmfname, $hext);
    &outConvertedFile($FileText, $htmfname, $hext, $InFileText);
  }
  elsif($option eq "texautostruct"){
    $FileText=TeXAutoStructRefrenceRestructuring($FileText);
    &outConvertedFile($FileText, $htmfname, $hext, $InFileText);
  }
  elsif($option eq "tag2texcolor"){
    $FileText=TeXAutoStructRefrence($FileText);
    &outConvertedFile($FileText, $htmfname, $hext, $InFileText);
  }
  elsif($option eq "texrestuct"){
    $FileText=TeXRefrenceResturcturing($FileText);
    &outConvertedFile($FileText, $htmfname, $hext, $InFileText);
  }
}#end main sub

#=======================================================================================================================================
sub OpenInputFile{
  my $htmfname=$InputFile;
  my $hext=$1 if($htmfname=~s/\.([a-z]+)$//os);
  if (!-e $InputFile){
    print "\n\n\n\n\n\n\n\n\n${htmfname}.$hext file not exist!!\n\n\n\n\n\n\n\n\n";
    exit ;
  }
  undef $/;
  open(INFILE, "<:bytes", "$InputFile");
  #open(INFILE,"<$InputFile")|| die("$InputFile File cannot be opened\n");
  my $FileText=<INFILE>;
  close(INFILE);
  return $FileText;
}

#========================================================================================================================================
sub RefrenceRestructuring{
  my $FileText=shift;

  if($FileText=~/\\bibitem/){
    $FileText=&TeX2Tag($FileText);
  }

  $FileText=htmlPreCleanup(\$FileText); 
  ($FileText, my $Symboltable)=&SymbolFonts($FileText);
  $FileText=RefColorToTag($FileText);
  $FileText=&bibReStructuring($FileText);


  foreach my $KEY(keys %$Symboltable) #%$Symboltableref
    {
      my $symbolKEY="\&\#X$KEY\;";
      $FileText=~s/$symbolKEY/$$Symboltable{$KEY}/s;
    }
  $FileText = RefTagToColor($FileText);
  if($FileTex=~/\\bibitem/){
    $FileText=TeXTagReplacement($FileText);
  }
  return $FileText;
}

#======================================================================================================================================
sub outConvertedFile{
  my $FileText=shift;
  my $htmfname=shift;
  my $hext=shift;
  my $InFileText=shift;

  $InFileText=~s/\&lt\;petemp\&gt\;(.*?)\&lt\;\/petemp&gt;/<petemp>$1<\/petemp>/s;
  $FileText=~s/\&lt\;petemp\&gt\;(.*?)\&lt\;\/petemp&gt;/<petemp>$1<\/petemp>/s;

  if ($FileText=~/<petemp>(.*?)<\/petemp>/s){
    $FileText="$1";
  }elsif($FileText=~/<body([^<>].*?)>(.*)<\/body>/s){
    $FileText="$2";
  }

  if ($InFileText=~/<petemp>(.*?)<\/petemp>/s){
    $InFileText=~s/<petemp>(.*?)<\/petemp>/\&lt\;petemp\&gt\;$FileText\&lt\;\/petemp&gt\;/os;
  }elsif($InFileText=~/<body([^<>].*?)>(.*)<\/body>/s){
    $InFileText=~s/<body([^<>].*?)>(.*)<\/body>/<body$1>$FileText<\/body>/os;
  }elsif($InFileText=~/\\bibitem/s){
    $InFileText=$FileText;
  }else{
      $InFileText="<html><body>\n"."$FileText"."\n<\/body><\/html>";
    }

  if($option=~/^(texautostruct|tag2texcolor|texrestuct)$/){
    $InFileText=~s/([\s]*)\&lt\;petemp\&gt\;([\s]*)//gs;
    $InFileText=~s/([\s]*)\&lt\;\/petemp\&gt\;([\s]*)//gs;
  }else{
    $InFileText=~s/([\s]*)\&lt\;petemp\&gt\;([\s]*)/\n<\!\-\-StartFragment\-\->\n/gs;
    $InFileText=~s/([\s]*)\&lt\;\/petemp\&gt\;([\s]*)/\n<\!\-\-EndFragment\-\->\n/gs;
  }

  #Biswajit Cleanup---
 
  $InFileText=~s/\&lt\;NS\&gt\;/ /gs;
  $InFileText=~s/\&lt\;\/NS\&gt\;//gs;
  $InFileText=~s/(\(<[^<>\/]+?>)\(/$1/gs;
  $InFileText=~s/[^\w<>](\.\&lt\;\/bib\&gt\;<\/p>)/$1/gs;
  $InFileText=~s/[^\w<>\.](\&lt\;\/bib\&gt\;<\/p>)/$1/gs;

  
  #open(OUTFILE, ">:encoding(UTF-8)", "${htmfname}.$hext");
  open(OUTFILE,">${htmfname}.$hext");
  print OUTFILE $InFileText;
  close(OUTFILE);
  unlink "${htmfname}\.out";
}
#======================================================================================================================================

sub bibReStructuring{
  my $FileText=shift;

  if($client eq "springer"){
    $FileText=&renameSpringerUnstrElement(\$FileText);
  }

  $FileText = RemoveBoldItalTag(\$FileText);  #remove bold and italic (e.g. bold volume <v><b>5</b></v> => <v>5</v>)

  $FileText = HtmlEntitytoTag(\$FileText);

  $FileText = TagGruopings($FileText);

  $FileText = puncEditings($FileText);      ############## pp./S. editings, pagepunc

  $FileText = AuthorGroupEditings($FileText);   #Author Group Editing

  $FileText = EditorGroupEditings($FileText);   #Author Group Editing

  #$FileText = ArticleTitleEditings($FileText); #Article Title Editings

  $FileText = JournalTitleEditings($FileText);  #Journal Title Editings (Abbreviated to Full and Full to Abbreviated)

  $FileText = EditPageRange(\$FileText);         #Page Range Editings

  $FileText = BookTitleEditing($FileText);      #Remove italic, volume Inside Book title editings.


  $FileText = delete_location($FileText,$SCRITPATH) if($style ne 'APS' || $style ne 'Chicago');          ###Remove multiple locations for single publisher


  ###$FileText = PublisherNameEditing($FileText);  #Remove words such as ‘Publisher(s)’, ‘Verlag’, ‘Press’, ‘Co.’, from the publisher name 

  ####$FileText=~s/<(vg|issg|pgg|edng|doig|yrg|atg|ptg|btg|cnyg|pblg|misc1g|edrg|aug|urlg|collabg|rpt)> / <$1>/gs;
  ####Within the title of an article, chapter or book, if colon is present, the next word's first letter should be capitalize

  $FileText = LanguageEditing(\$FileText);       #Upper case after : 

  $FileText=&revertRenameTags(\$FileText);

  ######check and move right place*****
  $FileText=~s/\&lt\;v\&gt\;\&lt\;b\&gt\;([0-9A-Z]+)\&lt\;\/b\&gt\;\&lt\;\/v&gt;/\&lt\;v\&gt\;$1\&lt\;\/v&gt;/gs;

  ######Big Change : first edrg to aug *****

  #<bib id="bib3"><number>119</number>
  $FileText=~s/<bib([^<>]*?)><number>([^<>]+?)<\/number>/<bib$1 \&lt;number&\gt;$2\&lt\;\/number\&gt\;>/gs;
  $FileText=~s/<bib([^<>]*?)><edrg>((?:(?!<[\/]?edrg>).)*)<\/edrg>/<bib$1><aug>$2<\/aug>/gs;
  $FileText=~s/\(([eE]d[s]?[\.]?|[Hh]rsg[\.]?)\)([\.\,\;\:])<\/aug>/\($1\)<\/aug>$2/gs;
  $FileText=~s/<([a-z0-9]+g)> &lt;/ <$1>&lt;/gs;
  $FileText=~s/<aug>([^<>]*?)<ia>([^<>]+?)<\/ia>([^<>]*?)<\/aug>/<aug>$1\&lt\;ia\&gt\;$2\&lt\;\/ia\&gt\;$3<\/aug>/gs;


  while($FileText=~/<bib([^<>]*?)>(.*?)<\/bib>/s)
    {
      my $bibText=$2;
      $bibText=BibReArrange($bibText);
      $bibText=CleanupAfterReArrange($bibText);
      $FileText=~s/<bib([^<>]*?)>(.*?)<\/bib>/&lt;bib$1&gt;${bibText}&lt;\/bib&gt;/os;
    }
	#print $FileText;exit;
  $FileText=~s/\&lt\;bib id=\"([^<>\"]+?)\" \&lt\;number&gt;([^<>]+?)&lt;\/number\&gt\;&gt\;/\&lt\;bib id=\"$1\"&gt\;<number>$2<\/number>/gs;
  $FileText=~s/\&lt\;bib \&lt\;number&gt;([^<>]+?)&lt;\/number\&gt\;&gt\;/\&lt\;bib&gt\;<number>$1<\/number>/gs;

  $FileText=~s/\.\&lt;\/([a-z0-9]+)\&gt\;<\/\1g>\./\.\&lt;\/$1\&gt\;<\/$1g>/gs;
  $FileText=~s/\.\&lt\;\/pbl\&gt\;<\/pblg>\./\.\&lt\;\/pbl\&gt\;<\/pblg>/gs;

  ############For Demo Only##########
  if($style eq "Vancouver"){
    $FileText=~s/<aug>([^<>]+?)<\/aug>[\.]? <yrg>\&lt\;yr\&gt\;([^<>]+?)\&lt\;\/yr\&gt\;<\/yrg>\. ([^<>]+?)\. <urlg>([^<>]+?)<\/urlg>([\.]?)\&lt\;\/bib\&gt\;/<aug>$1<\/aug>\. $3\, <yrg>&lt;yr&gt;$2&lt;\/yr&gt;<\/yrg>\. <urlg>$4<\/urlg>$5\&lt\;\/bib\&gt\;/gs;
    $FileText=~s/<aug>([^<>]+?)<\/aug>[\.]? <yrg>\&lt\;yr\&gt\;([^<>]+?)\&lt\;\/yr\&gt\;<\/yrg>\. ([^<>]+?) (PhD [dD]issertation)\, ([^<>]+?)\&lt\;\/bib\&gt\;/<aug>$1<\/aug>\. $3 $4\, <yrg>\&lt\;yr\&gt\;$2\&lt\;\/yr\&gt\;<\/yrg>\. $5\&lt\;\/bib\&gt\;/gs;

    $FileText=~s/<aug>([^<>]+?)<\/aug>[\.]? <yrg>\&lt\;yr\&gt\;([^<>]+?)\&lt\;\/yr\&gt\;<\/yrg>\. ([^<>]+?)\. (http[s]?\:\/\/www\.|http[s]?\:\/\/|www\.|ftp)([^<> ]+?)([\.]?)\&lt\;\/bib\&gt\;/<aug>$1<\/aug>\. $3\, <yrg>&lt;yr&gt;$2&lt;\/yr&gt;<\/yrg>\. $4$5$6\&lt\;\/bib\&gt\;/gs;

    $FileText=~s/([^\.])<\/urlg>\&lt\;\/bib\&gt\;/$1<\/urlg>\.\&lt\;\/bib\&gt\;/gs;
    $FileText=~s/([^\.])\&lt\;\/bib\&gt\;/$1\.\&lt\;\/bib\&gt\;/gs;
    $FileText=~s/([^\.])<\/aug> ([\w])/$1<\/aug>\. $2/gs;
    $FileText=~s/\&lt\;\/comment\&gt\;<\/p>/\&lt\;\/comment\&gt\;\.<\/p>/gs;
    $FileText=~s/\.\&lt;\/([a-z0-9]+)\&gt\;<\/\1g>\./\.\&lt;\/$1\&gt\;<\/$1g>/gs;
    $FileText=~s/\.<\/([a-z0-9]+)>\./\.<\/$1>/gs;
    $FileText=~s/<\/([a-z]+)g>\,\, /<\/([a-z]+)g>\, /gs;
    $FileText=~s/(editor[s]?|Herausgeber)<\/edrg> <([a-z]+)>/$1<\/edrg>\. <$2>/gs;
    $FileText=~s/[\,\.\;] Herausgeber\&lt\;\/ia\&gt\;\, editor[s]?\b/\&lt\;\/ia\&gt\;\, Herausgeber/gs;
    $FileText=~s/\, ([eE]ditor[s]?|[Ee]d[s]?[\.]?)\&lt\;\/ia\&gt\;\, editor[s]?\b/\&lt\;\/ia\&gt\;\, editor/gs;
    $FileText=~s/et al[\.]? editors/et al\, editors/gs;
    $FileText=~s/([^\.]+?)\&lt\;\/(au|edr)\&gt\; ([A-Z][^<>]+ \[[^<>]+\])<\/\2g>([\.\,\:\;]? )/$1\&lt\;\/$2\&gt\;\. $3<\/$2g>$4/gs;
    $FileText=~s/([^\.]+?)\&lt\;\/(au|edr)\&gt\;<\/\2g>([\.\,\:\;]? )/$1\&lt\;\/$2\&gt\;<\/$2g>\. /gs;
    $FileText=~s/([^\.]+?)<\/ia>([\.\,\:]? )/$1<\/ia>\. /gs;
	#biswajit
	
    $FileText=~s/\b([eE]ditor[s]?|[Ee]d[s]?[\.]?)\&lt\;\/ia\&gt\;\, editor[s]?\b/\&lt\;\/ia\&gt\;\, editor/gs;
	$FileText=~s/\bHerausgeber\&lt\;\/ia\&gt\;\, editor[s]?\b/\&lt\;\/ia\&gt\;\, Herausgeber/gs;
    $FileText=~s/\b(Herausgeber|Hrsg[\.]?)[\,]*(\&lt\;\/ia\&gt\;)\W/$2 Herausgeber\./gs;
    $FileText=~s/\b(Herausgeber|Hrsg[\.]?)[\,]*(<\/ia>)\W/$2 Herausgeber\./gs;
    $FileText=~s/\b([eE]ditor[s]?|[Ee]d[s]?[\.]?)[\,]*(\&lt\;\/ia\&gt\;)\W/$2 editor\./gs;
    $FileText=~s/\b([eE]ditor[s]?|[Ee]d[s]?[\.]?)[\,]*(<\/ia>)\W/$2 editor\./gs;
    $FileText=~s/\s*<\/ia> editor\./<\/ia> editor\./gs;
    $FileText=~s/\s*<\/ia> Herausgeber\./<\/ia> Herausgeber\./gs;
    $FileText=~s/\s*\&lt\;\/ia\&gt\; editor\./<\/ia> editor\./gs;
    $FileText=~s/\s*\&lt\;\/ia\&gt\;Herausgeber\./<\/ia> Herausgeber\./gs;
	
    $FileText=~s/\b([Ii]n\:)\s*<ia>/$1 <ia>/gs;
    $FileText=~s/\b([Ii]n\:)\s*\&lt\;ia\&gt\;/$1 \&lt\;ia\&gt\;/gs;
    $FileText=~s/\&lt\;\/v\&gt\;\s+\&lt\;iss\&gt\;/\&lt\;\/v\&gt\;\&lt\;iss\&gt\;/gs;
    $FileText=~s/\s<\/ia>/<\/ia>/gs;
    $FileText=~s/\,<\/ia>/<\/ia>\,/gs;
	$FileText=~s/\s\&lt\;\/ia\&gt\;/\&lt\;\/ia\&gt\;/gs;
    $FileText=~s/\,\&lt\;\/ia\&gt\;/\&lt\;\/ia\&gt\;\,/gs;
	
	
 }

  if($style eq "Basic" || $style eq "Chemistry" ){
    $FileText=~s/([^\.])<\/urlg>\&lt\;\/bib\&gt\;/$1<\/urlg>\.\&lt\;\/bib\&gt\;/gs;
    $FileText=~s/\.<\/([a-z]+)>\&lt\;\/bib\&gt\;/<\/$1>\&lt\;\/bib\&gt\;/gs;
    $FileText=~s/\.\&lt\;\/bib\&gt\;/\&lt\;\/bib\&gt\;/gs;
    $FileText=~s/\&lt\;\/comment\&gt\;\.<\/p>/\&lt\;\/comment\&gt\;<\/p>/gs;
    $FileText=~s/\&lt\;\/ia\&gt\;[\,\.\;]? \((Herausgeber|Hrsg)[\.]?\)[ ]+\([eE]d[s]?[\.]?\)/\&lt\;\/ia\&gt\; \(Hrsg\)/gs;
    $FileText=~s/\&lt\;\/ia\&gt\;[\,\.\;]? \(([eE]ditor[s]?|[Ee]d[s]?[\.]?)\)[ ]+\(([eE]d[s]?)[\.]?\)/\&lt\;\/ia\&gt\; \($2\)/gs;

    $FileText=~s/<\/(ia|aug|edrg)>\. ([^<>]+?)([\,\.]) <yrg>([^<>]+?)<\/yrg>([\.\:]?) ([^<>]+?)&lt;\/bib&gt;/<\/$1> \(<yrg>$4<\/yrg>\) $2$3 $6&lt;\/bib&gt;/gs;

  }

  if($style eq "APA"){
    $FileText=~s/([^\.])<\/urlg>\&lt\;\/bib\&gt\;/$1<\/urlg>\.\&lt\;\/bib\&gt\;/gs;
    $FileText=~s/\.<\/([a-z]+)>\&lt\;\/bib\&gt\;/<\/$1>\.\&lt\;\/bib\&gt\;/gs;
    $FileText=~s/([^\.\?])\&lt\;\/bib\&gt\;/$1\.\&lt\;\/bib\&gt\;/gs;
    $FileText=~s/\&lt\;\/comment\&gt\;<\/p>/\&lt\;\/comment\&gt\;\.<\/p>/gs;
    $FileText=~s/\.\&lt;\/([a-z0-9]+)\&gt\;<\/\1g>\./\.\&lt;\/$1\&gt\;<\/$1g>/gs;
    $FileText=~s/\&lt\;\/ia\&gt\;[\,\.\;]? \((Herausgeber|Hrsg)[\.]?\)[ ]+\([eE]d[s]?[\.]?\)/\&lt\;\/ia\&gt\; \(Hrsg\.\)/gs;
    $FileText=~s/\&lt\;\/ia\&gt\;[\,\.\;]? \(([eE]ditor[s]?|[Ee]d[s]?[\.]?)\)[ ]+\(([eE]d[s]?)[\.]?\)/\&lt\;\/ia\&gt\; \($2\.\)/gs;

  }

  if($style eq "MPS"){

    $FileText=~s/([^\.])<\/urlg>\&lt\;\/bib\&gt\;/$1<\/urlg>\.\&lt\;\/bib\&gt\;/gs;
    $FileText=~s/\.<\/([a-z]+)>\&lt\;\/bib\&gt\;/<\/$1>\&lt\;\/bib\&gt\;/gs;
    $FileText=~s/\.\&lt\;\/bib\&gt\;/\&lt\;\/bib\&gt\;/gs;
    $FileText=~s/\&lt\;\/comment\&gt\;\.<\/p>/\&lt\;\/comment\&gt\;<\/p>/gs;
    #$FileText=~s/\&lt\;\/ia\&gt\; \(Ed[\.]?\) \([eE]d[s]?[.]?\)
    $FileText=~s/\&lt\;\/ia\&gt\;[\,\.\;]? \((Herausgeber|Hrsg)[\.]?\)[ ]+\([eE]d[s]?\.\)/\&lt\;\/ia\&gt\; \(Hrsg\.\)/gs;
    $FileText=~s/\&lt\;\/ia\&gt\;[\,\.\;]? \(([eE]ditor[s]?|[Ee]d[s]?[\.]?)\)[ ]+\(([eE]d[s]?)\.\)/\&lt\;\/ia\&gt\; \($2\.\)/gs;

    $FileText=~s/\&lt\;bib([^<>]*?)\&gt\;<number>([^<>]+?)<\/number><(aug|edrg|ia)>([^<>]+?)<\/\3> /\&lt\;bib$1\&gt\;<number>$2<\/number><$3>$4<\/$3>\: /gs;
    $FileText=~s/\&lt\;bib([^<>]*?)\&gt\;<(aug|edrg|ia)>([^<>]+?)<\/\2> /\&lt\;bib$1\&gt\;<$2>$3<\/$2>\: /gs;
  }

  if($style eq "Chicago"){
    $FileText=~s/([^\.])<\/urlg>\&lt\;\/bib\&gt\;/$1<\/urlg>\.\&lt\;\/bib\&gt\;/gs;
    $FileText=~s/\.<\/([a-z]+)>\&lt\;\/bib\&gt\;/<\/$1>\.\&lt\;\/bib\&gt\;/gs;
    $FileText=~s/([^\.\?])\&lt\;\/bib\&gt\;/$1\.\&lt\;\/bib\&gt\;/gs;
    $FileText=~s/\&lt\;\/comment\&gt\;<\/p>/\&lt\;\/comment\&gt\;\.<\/p>/gs;
    $FileText=~s/\.\&lt;\/([a-z0-9]+)\&gt\;<\/\1g>\./\.\&lt;\/$1\&gt\;<\/$1g>/gs;
    $FileText=~s/([\.]?)<\/(ia|aug|edrg)>([\.\,\;\:\( ]+)<yrg>([^<>]+?)<\/yrg>([\)\,\.\:]+ )/$1<\/$2>\. <yrg>$4<\/yrg>\. /gs;
    $FileText=~s/([\.]?)<\/(ia|aug|edrg)>([\.\,\;\:\( ]+)<yrg>([^<>]+?)<\/yrg>([\)\,\.\: ]+)/$1<\/$2>\. <yrg>$4<\/yrg>\. /gs;
    $FileText=~s/\.<\/([a-z0-9]+)>\./\.<\/$1>/gs;
    $FileText=~s/\.\&lt\;\/(auf|edm|suffix)\&gt\;\&lt\;\/(au|edr)\&gt\;<\/aug>\. /\.\&lt\;\/$1\&gt\;\&lt\;\/$2\&gt\;<\/aug> /gs;
    $FileText=~s/<\/([a-z]+)g>\,\, /<\/([a-z]+)g>\, /gs;
    $FileText=~s/ ed\. &lt;ia&gt;([^<>]+?) Hrsg\&lt\;\/ia\&gt\;/ Hrsg\. &lt;ia&gt;$1\&lt\;\/ia\&gt\;/g;

  }
############### Author: Pravin Pardeshi  ###################  
	if($style eq 'APS') {
	#print $FileText; exit;
		my (@refs) = $FileText =~ m!(\&lt\;bib.*?\/bib&gt\;)!isg;
		foreach my $ref(@refs) {
			my $orig = $ref;
			$ref =~ s!<\/aug>\.!</aug>!s;
			my (@auth_group) = $ref =~ m!(<aug>.*?<\/aug>)!isg;
			foreach my $auth_grp(@auth_group) {
				my $orig_auth_grp = $auth_grp;
				if($auth_grp =~ m!\bed\.\b!) {
					$auth_grp =~ s!(?<\!\()ed!(ed!is;
					$auth_grp =~ s!(?\!\))ed!ed)!is;
					$auth_grp =~ s!(?\!\.)ed\)!ed.!is;
					$ref =~ s!\Q$orig_auth_grp\E!$auth_grp!s;
				}
				my (@each_auth) = $auth_grp =~ m!(\&lt\;au\&gt\;.*?\&lt\;(auf|edm)\&gt\;.*?\&lt\;\/(auf|edm)\&gt\;.*?\&lt\;\/au\&gt\;)!isg;
				foreach my $auth(@each_auth) {
					next if($auth eq 'auf' || $auth eq 'edm');
					my $orig_auth = $auth;
					my ($temp) = $auth =~ m!(auf|edm)!is;
					$auth =~ s!(\&lt\;(auf|edm)\&gt\;.*?\&lt\;\/(auf|edm)\&gt\;)!!isg;
					my $auth_first_name = $1;
					$auth_first_name =~ s!\&lt\;(auf|edm)\&gt\;(.*?)\&lt\;\/(auf|edm)\&gt\;!!sg;
					$temp_first_name = $2;
					$temp_first_name =~ s!\s+!!g;
					$temp_first_name =~ s!([a-z])!$1.!sg if($temp_first_name =~ m![a-z]\.!sg);
					$auth_first_name = '&lt;'.$temp.'&gt;'.$temp_first_name.'&lt;/'.$temp.'&gt;';
					$auth =~ s!(\&lt\;au\&gt\;)!$1$auth_first_name!s;
					$ref =~ s!\Q$orig_auth\E!$auth!s;
				}
			}
			
			if($ref =~ m!<ptg>!is) {
				my $year_group;
				my $doi_group;
				if($ref =~ m!<yrg>!is) {
						$ref =~ s!(\s*\(?<yrg>.*?<\/yrg>\.?\)?\.?)! !sg;
						$year_group = $1;
						$year_group =~ s!^!(!s if($year_group !~ m!\(!);
						$year_group =~ s!$!)!s if($year_group !~ m!\)!);
						$year_group =~ s!\.\)!)!sg;
						$year_group =~ s!$!.!s if($year_group !~ m!\.\s*$!s);
				}
				if($ref =~ m!<doig>!is) {
					$ref =~ s!(\s*<doig>.*?<\/doig>\.?)! !sg;
					$doi_group = $1;
					$doi_group =~ s!.$!!s if($doi_group =~ m!\.$!s);
					$doi_group =~ s!doi\:\s*!doi:!s;
				}
				###If year and doi present
				if($year_group && $doi_group) {
					$ref =~ s!(\&lt\;\/bib\&gt\;)!$year_group$doi_group$1!s;
				}
				else {
					$ref =~ s!(\&lt\;\/bib\&gt\;)!$year_group$1!s if($year_group); ###For year at last
					$ref =~ s!(\&lt\;\/bib\&gt\;)!$doi_group$1!s if($doi_group); ###For doi at last
				}
			}
			else {
				if($ref =~ m!<pgg>!is) {
					$ref =~ s!\(?(<pgg>.*?<\/pgg>)\)?\.?! !sg;
					my $page_group = $1;
					$page_group =~ s!\&amp\;nbsp\;!&nbsp;!sg;
					$page_group =~ s![\(\)]?!!sg;
					if($page_group =~ m!\Q&#8211;\E! && $page_group =~ m![^p]p\.\&nbsp!s && $page_group !~ m!S\.!) { $page_group =~ s!([^p])(p\.\&nbsp)!$1p$2!; }
					if($page_group =~ m!\Q&#8211;\E! && $page_group !~ m!pp\.(\&nbsp\;)?! && $page_group !~ m!S\.!) { $page_group =~ s!<pgg>!<pgg>pp.&nbsp;!s }
					if($page_group =~ m!\Q&#8211;\E! && $page_group =~ m!(\&lt\;pg\&gt\;)(pp\.)!) { $page_group =~ s!(\&lt\;pg\&gt\;)(pp\.)(\&nbsp\;)?!$2$3$1!s }
					#print $page_group,"\n\n";# exit;
					$ref =~ s!(\&lt\;\/bib\&gt\;)! $page_group$1!s; ###For page group at last 
					#print $ref,"\n\n";
				}
				my $vol_group;
				if($ref =~ m!<vg>!) {
						($vol_group) = $ref =~ m!\s*(<vg>.*?<\/vg>[\,\.]?\s*)!is;
						$vol_group =~ s![\(\)]?!!sg;
						$ref =~ s!\s*(<vg>.*?<\/vg>[\,\.]?\s*)! $vol_group !s;
				}
				if($ref !~ m!<misc!is && $ref =~ m!<edrg>!i && $ref =~ m!<btg>!i) { ###For ref. with editor 
					$ref =~ s!\/(btg|edng|edrg)>[\,\:\.\;]?!/$1>!sg;
					$ref =~ s!(\s*<edrg>.*?<\/edrg>[\,\.]?)\s*(<btg>.*?<\/btg>\s*)([^<]*<edng>.*?<\/edng>\)?)?! in $2 $3  ed. by $1 !s;
					$ref =~ s!(\s*<btg>.*?<\/btg>)[\,\.]?([^<]*<edng>.*?<\/edng>)?(\s*<edrg>.*?<\/edrg>,?\s*)! in $1 $2  ed. by $3 !s;
					$ref =~ s!(<edng>.*?)Edition\s+edn\.!$1 edn.!s;
					$ref =~ s!(<edng>.*?)Edition\.?\s*!$1 edn. !s;
					$ref =~ s!\(?(<edng>.*?<\/edng>)\)?!$1!s;
					$ref =~ s![\,\.]\s*<\/edrg>\s*[\,\.]*!</edrg> !s;
					$ref =~ s![\,\.]?\s*<\/btg>\s*[\,\.]?!,</btg> !s;
					if($ref =~ m!<vg>!) {
						$ref =~ s!\s*(<vg>.*?<\/vg>[\,\.]?\s*)!!s;
						$ref =~ s!(<\/btg>[\,\.]?\s*)!$1 $vol_group !s;
					}
				}
				if($ref =~ m!<yrg>! && $ref =~ m!<pblg>! && $ref =~ m!<cnyg>!) {
						$ref =~ s!\s*\(?(<yrg>.*?<\/yrg>)\.?\)?\.?\:?! !sg;
						my $year_group = $1;
						$ref =~ s!\s*\(?(<pblg>.*?<\/pblg>)[\,\.\;]?\)?! !sg;
						my $pbl_group = $1;
						$ref =~ s!(\s*<cnyg>.*?<\/cnyg>)[\,\.:]?! !sg;
						my $cny_group = $1;
						$ref =~ s!,?\s*<pgg>! \($pbl_group, $cny_group, $year_group\), <pgg>!sg if($ref =~ m!<pgg>!);
						$ref =~ s!(\&lt\;\/bib\&gt\;)! \($pbl_group, $cny_group, $year_group\)$1!sg if($ref !~ m!<pgg>!);
				}
			}
			$ref =~ s!,\s+(\&lt\;i\&gt\;<btg>\&lt\;bt\&gt\;)in\s+!, in $1!sg if($ref =~ m!<btg>!is && $ref =~ m!,\s+(\&lt\;i\&gt\;<btg>\&lt\;bt\&gt\;)in\s+!s); ###For book title in italics	
			$ref =~ s!(<btg>[^<]*<\/btg>)!&lt;i&gt;$1&lt;/i&gt;!sg if($ref !~ m!\&lt\;i\&gt\;\s*<btg>!is && $ref =~ m!<btg>!is); ###For book title in italics

			$ref =~ s!,\s+(\&lt\;i\&gt\;)in\s!, in $1!s if($ref =~ m!,\s+(\&lt\;i\&gt\;)in\s!s); ###For book title in italics
			$ref =~ s!,\s+(\&lt\;i\&gt\;)\s*<btg>in\s!, in $1<btg>!s if($ref =~ m!,\s+(\&lt\;i\&gt\;)\s*<btg>in\s!s); ###For book title in italics

			if($ref =~ m!<ptg>!is) {
				$ref =~ s!<vg>([^<]*)<\/vg>!<vg><b>$1</b></vg>!sg if($ref =~ m!<vg>!is); ###For volume in bold
			}
			else {
				$ref =~ s!(<vg>[^<]*vol)s\.!$1.!sg if($ref =~ m!<vg>!is); ###For volume "vol."
				$ref =~ s!\svol[^\.]!vol.!sg if($ref =~ m!<vg>!is); ###For volume "vol."
			}
			$ref =~ s!(<atg>.*?<\/atg>)([^\.])!$1.$2!sg if($ref =~ m!<atg>.*?<\/atg>[^\.]!s && $ref !~ m![\?\!]\&lt\;\/at\&gt\;<\/atg>!s); ###For putting end period after articel title
			$ref =~ s!(in(\s+\&lt\;i\&gt\;)?<btg>\s*)in\s*!$1!sg; ###For removing double "in"
			$ref =~ s!,\s+(\&lt\;i\&gt\;)in!, in$1 !sg; ###For in to non italic

			$ref =~ s!\s*\,?\s*\.(\s*\&lt\;\/bib\&gt\;)!$1! if($ref =~ m!\.\s*\&lt\;\/bib\&gt\;!s); ###Removing end period for Journal title only
			$ref =~ s!([^\s])<(atg|ptg|btg)>!$1 <$2>!sg; ###Space before atg,btg and ptg
			$ref =~ s!(\&lt\;aus\&gt\;[^,]*?)\,(\&lt\;\/aus\&gt\;)!$1$2!si if($ref =~ m!\<\/aug\>\,!s);
			$ref =~ s!<\/aug>([^,])!</aug>,$1!s if($ref !~ m!<\/aug>\s*,!s && $ref !~ m!,<\/aug>!s);
			$ref =~ s!(\&lt\;i\&gt\;)\s+(\<btg\>)!$1$2!sg;
			$ref =~ s!\s\s+! !sg;
			$ref =~ s!(<vg>.*?<\/vg>)\s*(\(<issg>.*?<\/issg>\))!$1$2!s;
			$ref =~ s!<\/pgg>\.!</pgg> !s;
			$ref =~ s!\(?Hrsg\.?\)?!!sg if($ref =~ m!ed\.?\s+by!i);
			$ref =~ s!\,\s*\,!\,!sg;
			##### For edited book
			if($ref =~ m!\((eds?)\.?\)?(\s*<\/(edrg|aug)>)!) {
				$ref =~ s!\(ed(s?)\.?\)?(\s*<\/(edrg|aug)>)!ed$1.$2!isg;
				#if($ref =~ m!<pgg>!s) {
				#	my ($page) = $ref =~ m!<pgg>(.*?)<\/pgg>!s;
				#	my $orig = $page;
				#	$page =~ s!\&lt\;\/?pg\&gt\;!!sg;
				#	$page =~ s!\s+!!;
				#	$page =~ s!pp?\.?(\&nbsp\;)?!!;
				#	$page =~ s!^(.*)!pp.&nbsp;&lt;pg&gt;pp.$1&lt;/pg&gt;!sg;
				#	$ref =~ s!\Q$orig\E!$page!s;
				#}
			}###END
			#print $ref,"\n\n";
			$FileText =~ s!\Q$orig\E!$ref!is;
		}
	}
#print $FileText;exit;
###################  END of APS  #####################



#--------------------------------------------------------------------------------- 
#    Change by Biswajit 
#--------------------------------------------------------------------------------- 
	if($style eq 'Chemistry') {
		while($FileText=~ /<p[\s|>](.*?)<\/p>/sgm){
			my $file_data_org = $1;
			my $file_data = $file_data_org;
			if($file_data =~ /<ptg>/ig) {
				$file_data=~s/<\/vg>\s([\(]*<issg>)/<\/vg>$1/gs;
				if($file_data=~ /[\(]*(<\w+>&lt;yr&gt;.*?&lt;\/yr&gt;<\/\w+>)[\)]*\s*/smg){
					my $year = $1 ;
					$file_data=~ s/[\(]*\Q$year\E[\)]*\s*//sg;
					$file_data=~s/(<\/aug>\W+)</$1\($year\) </sg; 
				}
				$file_data=~s/(<\/issg>[\)]*)[\s|\,|\.|\;|\:]*/$1\:/gs;
				$file_data=~s/<\/vg>[\s|\,|\.|\;|\:]*/<\/vg>\:/gs if($file_data !~ /<issg>/g);
				$file_data=~s/<\/yrg>\)\./<\/yrg>\)/gs;
				$file_data=~s/<\/aug>\,/<\/aug>/gs;
				$file_data=~s/<\/ptg>[\,|\.]/<\/ptg>/gs;
				$file_data=~s/>\W+<doig>/>\. <doig>/gs;
				$file_data=~s/&lt;\/pt&gt;[\.|\,]/&lt;\/pt&gt;/gs;
				$file_data=~s/[\.|\,]&lt;\/bib&gt;/&lt;\/bib&gt;/gs;
				$file_data=~s/\s\s+/ /gs;
				$FileText=~ s/<p([\s|>])\Q$file_data_org\E<\/p>/<RRR$1$file_data<\/RRR>/smg;
			}else{
				$file_data=~s/<\/edrg>\W/<\/edrg> /gs;
				$file_data=~s/In\s*<ia>/In\: <ia>/gs;
				$file_data=~s/\&lt\;\/edr\&gt\;\./\&lt\;\/edr\&gt\;/gs;
				$file_data=~s/<edrg>In[\:]*\s\&lt\;/<edrg>\&lt\;/gs;
				$file_data=~s/\/pbl\&gt\;\W*?([<|\w|\&])/\/pbl\&gt\;\, $1/gs;

				if($file_data=~ /<aug>.*?[\(]*(<yrg>&lt;yr&gt;.*?&lt;\/yr&gt;<\/yrg>)[\)]*\s*/smg){
					my $year = $1 ;
					$file_data=~ s/[\(]*\Q$year\E[\)]*\s*//sm;
					$file_data=~s/(<\/aug>)\W*?([<|\w|\&])/$1 \($year\) $2/sg; 
				}
				if($file_data=~ /<cnyg>/g && $file_data=~ /(<pblg>.*?<\/pblg>\W*?)[<|\w|\&]/smg ){
					my $pblg = $1 ;
					$file_data=~ s/\Q$pblg\E//sm;
					$pblg =~ s/(.*?<\/pblg>).*/$1/sg;
					$file_data=~s/<\/cnyg>\W*?([<|\w|\&])/<\/cnyg>\, $1/sg; 
					$file_data=~s/<cnyg>/$pblg\, <cnyg>/sg;
				}
				if($file_data=~ /<\/yrg>/g && $file_data=~ /[\(]?(<edrg>.*?<\/edrg>)[\)]?/smg){
					my $pblg = $1 ;
					$file_data=~ s/In\:\s[\(]?\Q$pblg\E[\)]?//sg ;
					$file_data=~ s/[\(]?\Q$pblg\E[\)]?//sg ;
					$file_data=~s/<\/yrg>\)\W*?([<|\w|\&])/<\/yrg>\) In\: $pblg $1/sg; 
				}
				if($file_data=~ /<\/yrg>/g && $file_data=~ /(<misc1g>.*?<\/misc1g>\W)/smg){
					my $pblg = $1 ;
					$file_data=~ s/\Q$pblg\E//sg;
					$file_data=~s/<\/yrg>\)\W*?([<|\w|\&])/<\/yrg>\) $pblg $1/sg; 
				}
				if($file_data=~ /<\/yrg>/g && $file_data !~ /<misc1g>/g && $file_data=~ /(\&lt\;misc1\&gt\;.*?\&lt\;\/misc1\&gt\;\W)/smg){
					my $pblg = $1 ;
					$file_data=~ s/\Q$pblg\E//sg;
					$file_data=~s/<\/yrg>\)\W*?([<|\w|\&])/<\/yrg>\) $pblg $1/sg; 
				}
				if($file_data=~ /<\/btg>/g && $file_data=~ /(<vg>.*?<\/vg>\W)/smg){
					my $pblg = $1 ;
					$file_data=~ s/\Q$pblg\E//sg;
					$file_data=~s/(<\/btg>\W*?)([<|\w|\&])/$1$pblg $2/sg; 
				}
				if($file_data=~ /<\/btg>/g && $file_data=~ /(<issg>.*?<\/issg>[^<|\w|\&]*?)/smg){
					my $pblg = $1 ;
					$file_data=~ s/\Q$pblg\E//sg;
					$file_data=~s/(<\/vg>\W*?)([<|\w|\&])/$1$pblg $2/sg if($file_data=~ /<\/vg>/g); 
					$file_data=~s/(<\/btg>\W*?)([<|\w|\&])/$1$pblg $2/sg if($file_data !~ /<\/vg>/g); 
				}
				$file_data=~s/(.*([>|\w|\&]))(\W*?<pgg>.*?<\/pgg>)[\)]?(.*)\&lt\;\/bib\&gt\;/$1$4$3\&lt\;\/bib\&gt\;/sg;
				$file_data=~s/<\/cnyg>\W*?([<|\w|\&])/<\/cnyg>\, $1/sg;
				
				$file_data=~s/[\(\[]([Hh]rsg|[Hh]g)[\.]?[\)\]][\.]?<\/edrg>/\(Hrsg\)<\/edrg>/gs;
				$file_data=~s/<edrg>[\(\[]?([Hh]rsg|[Hh]g)[\.]?[\)\]]?[\.]?\s(.*?)<\/edrg>/<edrg>$2 \(Hrsg\)<\/edrg>/gs;
				
				$file_data=~s/[\(\[]([Ee]d|[Ee]ds)[\.]?[\)\]][\.]?<\/edrg>/\(\l$1\E\)<\/edrg>/gs;
				$file_data=~s/<edrg>[\(\[]?([Ee]d|[Ee]ds)[\.]?[\)\]]?[\.]?\s(.*?)<\/edrg>/<edrg>$2 \(\l$1\E\)<\/edrg>/gs;
				
				$file_data=~s/([Hh]rsg|[Hh]g)[\.]?<\/edrg>/\(Hrsg\)<\/edrg>/gs;
				$file_data=~s/<edrg>([Hh]rsg|[Hh]g)[\.]?\s(.*?)<\/edrg>/<edrg>$2 \(Hrsg\)<\/edrg>/gs;
				
				$file_data=~s/([Ee]d|[Ee]ds)[\.]?<\/edrg>/\(\l$1\E\)<\/edrg>/gs;
				$file_data=~s/<edrg>([Ee]d|[Ee]ds)[\.]?\s(.*?)<\/edrg>/<edrg>$2 \(\l$1\E\)<\/edrg>/gs;
				
				$file_data=~s/[\(\[]?[Ee]ditors[\)\]\.]*<\/edrg>/\(eds\)<\/edrg>/gs;
				$file_data=~s/<edrg>[\(\[]?[Ee]ditors[\)\]\.]*\s(.*?)<\/edrg>/<edrg>$2 \(eds\)<\/edrg>/gs;
				
				$file_data=~s/[\(\[]?[Ee]ditor[\)\]\.]*<\/edrg>/\(ed\)<\/edrg>/gs;
				$file_data=~s/<edrg>[\(\[]?[Ee]ditor[\)\]\.]*\s(.*?)<\/edrg>/<edrg>$2 \(ed\)<\/edrg>/gs;
				
				$file_data=~s/[\(\[]?[Hh]erausgeber[\.\)\]]*<\/edrg>/\(Hrsg\)<\/edrg>/gs;
				$file_data=~s/<edrg>[\(\[]?[Hh]erausgeber[\.\)\]]*\s(.*?)<\/edrg>/<edrg>$2 \(Hrsg\)<\/edrg>/gs;
								
				$file_data=~s/\, (\(ed[s]?\))/ $1/gs;
				$file_data=~s/<pblg>\(/<pblg>/gs;
				$file_data=~s/<\/btg>([^\.|\,|\:|\;]*?)[\.|\,|\:|\;]*([\s])/<\/btg>$1\,$2/gs;
				$file_data=~s/\&lt\;\/bt\&gt\;[\.|\,|\:|\;]*([\s])/\&lt\;\/bt\&gt\;\,$1/gs;
				$file_data=~s/\(<pblg>/<pblg>/gs;
				$file_data=~s/\(<cnyg>/<cnyg>/gs;
				$file_data=~s/<cnyg>\(/<cnyg>/gs;
				$file_data=~s/<vg>\(/<vg>/gs;
				$file_data=~s/\(<vg>/<vg>/gs;
				$file_data=~s/\(<edng>/<edng>/gs;
				$file_data=~s/<\/edng>\)/<\/edng>/gs;
				$file_data=~s/\)<\/edng>/<\/edng>/gs;
				$file_data=~s/<edng>\(/<edng>/gs;
				$file_data=~s/\bIn(\W+<btg>)/$1/gs;
				$file_data=~s/\(\&lt\;pbl\&gt\;/\&lt\;pbl\&gt\;/gs;
				$file_data=~s/\&lt\;\/pbl\&gt\;\W<\/pblg>/\&lt\;\/pbl\&gt\;<\/pblg>/gs;
			
				$file_data=~s/[\.|\,|\s|\)]+\&lt\;\/bib\&gt\;/\&lt\;\/bib\&gt\;/gs;
				$file_data=~s/\, <\/pblg>\,/<\/pblg>\,/gs;
				$file_data=~s/\:\&lt\;pg\&gt\;/\&lt\;pg\&gt\;/gs;
				
				$file_data=~s/\bed[\.|\,|\:|\;|\s|\)]*?<\/edng>[\.|\,|\:|\;]?/edn\.<\/edng>/gs;
				$file_data=~s/\bed[\.|\,|\:|\;|\s]/edn\./gs;
				$file_data=~s/<\/btg>\,([^\.]+<\/pblg>)/<\/btg>\.$1/gs;
				$file_data=~s/<\/btg>\,([^\.]+<cnyg>)/<\/btg>\.$1/gs;
				$file_data=~s/\&lt\;\/bt\&gt\;\,([^\.]+$)/\&lt\;\/bt\&gt\;\.$1/gs;
				
				$file_data=~s/<pgg>(\&lt\;pg\&gt\;.*?–)/<pgg>pp $1/gs;
				$file_data=~s/<pgg>(\&lt\;pg\&gt\;)/<pgg>p $1/gs;
				$file_data=~s/(\W[^(pp)]\W+)(\&lt\;pg\&gt\;.*?–)/$1pp $2/gs;
				$file_data=~s/(\W[^(pp)]\W+)(\&lt\;pg\&gt\;)/$1pp $2/gs;
				##$file_data=~s/<pgg>(\&lt\;pg\&gt\;)/<pgg>p  $1/gs;
				$file_data=~s/\.<\/edng>[\.|\,|\:|\;|\)]/\.<\/edng>/gs;
				$file_data=~s/\s\s+/ /gs;
				
				$FileText=~ s/<p([\s|>])\Q$file_data_org\E<\/p>/<RRR$1$file_data<\/RRR>/smg;
			}
		}
		$FileText=~s/<RRR([\s|>])/<p$1/gs;
		$FileText=~s/<\/RRR>/<\/p>/gs;
	}
#=====================================END=====================================================

  #&lt;/bib&gt;&lt;comment&gt;Retrieved from http://www.aauw.org/learn/research/upload/whysofew.pdf&lt;/comment&gt;
  $FileText=~s/\&lt\;\/bib\&gt\;([\.\, ]+)\&lt\;comment&gt;([^<>]+?)\&lt\;\/comment\&gt\;([\.\?]?)/$1&lt;comment\&gt\;$2\&lt;\/comment\&gt\;$3&lt\;\/bib\&gt\;/gs;
  $FileText=~s/\.\. \&lt\;comment\&gt\;/\. \&lt\;comment\&gt\;/gs;
  $FileText=~s/\.\, \&lt\;comment\&gt\;/\. \&lt\;comment\&gt\;/gs;
  #$FileText=~s/(\.[`\.\,\:\(\)\[\]\;‘„“\"“” \/\'ΓÇ¥]+)\&lt\;\/at\&gt\;<\/atg>\./$1\&lt\;\/at\&gt\;/gs;
  $FileText=~s/<\/([a-z1-2]+)>\.\. /<\/$1>\. /gs;

  $FileText=~s/<[\/]?(aug|edrg|atg|btg|ptg|misc1g|urlg|doig|yrg|issg|vg|pgg|edng|cnyg|pblg|collabg)>//gs;
  
#print $FileText;exit;
  $FileText=HtmlTagToEntity(\$FileText);

  return $FileText;
}
#==================================================================================================================================
sub RemoveBoldItalTag
{
  my $FileText=shift;

  $$FileText=~s/\&lt\;([\/]?)(i|b|u)\&gt\;/<$1$2>/gs; ##  &lt;pt&gt;&lt;i&gt;Pan-Pac. Entomol.&lt;/i&gt;&lt;/pt&gt;
  $$FileText=~s/\&lt\;\/pt\&gt\;([\,\; ]+)<(i|b)>([A-Za-z\,\;\:\(\) ]+?)<\/\2>/\&lt\;\/pt\&gt\;$1$3/gs;

  $$FileText=~s/<i>([\.\,\;\? ]+)\&lt\;pt\&gt\;/$1<i>\&lt\;pt\&gt\;/gs;
  $$FileText=~s/<\/i> <i>/ /gs;
  $$FileText=~s/<\/b> <b>/ /gs;
  $$FileText=~s/\&lt\;pt\&gt;<i>((?:(?!<i>)(?!<\/i>)(?!\&lt\;\/pt\&gt\;).)*)<\/i>\&lt\;\/pt\&gt\;/\&lt\;pt\&gt;$1&lt;\/pt\&gt\;/gs;
  $$FileText=~s/<b>\(&lt\;iss\&gt\;((?:(?!\&lt\;[\/]?iss\&gt\;).)*?)\&lt\;\/iss&gt;\)<\/b>/\(&lt\;iss\&gt\;$1\&lt\;\/iss&gt;\)/gs;


  $$FileText=~s/<(b|i)>\&lt\;v\&gt\;([^<>]+)\(([^<>]+)\&lt\;\/iss\&gt\;\)<\/\1>/\&lt\;v\&gt\;$2\($3\&lt\;\/iss\&gt\;\)/gs;

  $$FileText=~s/<(b|i|u)>\&lt\;(v|iss|pg|pt|at|bt|srt|misc1)\&gt\;((?:(?!<[\/]?\1>)(?!\&lt\;[\/]?\2\&gt\;).)*?)\&lt\;\/\1\&gt\;<\/\1>/\&lt\;$2\&gt\;$3\&lt\;\/$2\&gt\;/gs;
  $$FileText=~s/\&lt\;(v|iss|pg|pt|at|bt|srt|misc1)\&gt\;<(b|i|u)>((?:(?!<[\/]?\2>)(?!\&lt\;[\/]?\1\&gt\;).)*?)<\/\2>\&lt\;\/\1\&gt\;/\&lt\;$1\&gt\;$3\&lt\;\/$1\&gt\;/gs;

  $$FileText=~s/<(b|i)>\&lt\;(v|iss|pg|pt|at|bt|srt|misc1|collab)\&gt\;([^<>]+?)\&lt\;\/(v|iss|pg|pt|at|bt|srt|misc1|collab)\&gt\;<\/\1>/\&lt\;$2\&gt\;$3\&lt\;\/$4\&gt\;/gs; 
  #$$FileText=~s/\&lt\;\/([a-zA-Z0-9]+)\&gt\;<\/(b|i)>/\&lt\;\/$1\&gt\;/gs; 
  #$$FileText=~s/<(b|i)>\&lt\;([a-zA-Z0-9]+)\&gt\;/\&lt\;$2\&gt\;/gs;


  $$FileText=~s/<i>et al([\.]?)<\/i>/et al$1/gs;
  $$FileText=~s/\&lt\;\/(misc1|at|pt|bt|srt|collab|eds|edm|auf|aus)\&gt\;\&lt\;\1\&gt\;((?:(?!\&lt\;[\/]?\1\&gt\;).)*?)\&lt\;\/\1\&gt\;/$2\&lt\;\/$1\&gt\;/gs;
  $$FileText=~s/\&lt\;\/(misc1|at|pt|bt|srt|collab|eds|edm|auf|aus)\&gt\;([\.\, ]+)\&lt\;\1\&gt\;((?:(?!\&lt\;[\/]?\1\&gt\;).)*?)\&lt\;\/\1\&gt\;/$2$3\&lt\;\/$1\&gt\;/gs;

  return $$FileText;
}

#==================================================================================================================================================

sub AuthorsGroupings
{
  my $bibText=shift;
  $bibText=~s/^\&lt\;aus\&gt\;(.*)\&lt\;\/auf\&gt\;((?:(?!\&lt\;aus\&gt\;).)*)/<aug>\&lt\;aus\&gt\;$1\&lt\;\/auf\&gt\;<\/aug>$2/gs;
  $bibText=~s/^\&lt\;auf\&gt\;(.*)\&lt\;\/aus\&gt\;((?:(?!\&lt\;auf\&gt\;).)*)/<aug>\&lt\;auf\&gt\;$1\&lt\;\/aus\&gt\;<\/aug>$2/gs;
  $bibText=~s/^\&lt\;aus\&gt\;(.*)\&lt\;\/aus\&gt\;((?:(?!\&lt\;auf\&gt\;).)*)/<aug>\&lt\;aus\&gt\;$1\&lt\;\/aus\&gt\;<\/aug>$2/gs;
  $bibText=~s/^\&lt\;auf\&gt\;(.*)\&lt\;\/auf\&gt\;((?:(?!\&lt\;aus\&gt\;).)*)/<aug>\&lt\;auf\&gt\;$1\&lt\;\/auf\&gt\;<\/aug>$2/gs;
  $bibText=~s/^\&lt\;au\&gt\;(.*)\&lt\;\/au\&gt\;((?:(?!\&lt\;au\&gt\;).)*)/<aug>\&lt\;au\&gt\;$1\&lt\;\/au\&gt\;<\/aug>$2/gs;
  $bibText=~s/<\/aug>([\., ]*)\&lt\;par\&gt;([^\&\;\/]*?)\&lt\;\/par\&gt;/$1\&lt\;par\&gt;$2\&lt\;\/par\&gt;<\/aug>/gs;
  $bibText=~s/<\/aug>([\., ]*)\&lt\;suffix\&gt;([^\&\;\/]*?)\&lt\;\/suffix\&gt;/$1\&lt\;suffix\&gt;$2\&lt\;\/suffix\&gt;<\/aug>/gs;
  $bibText=~s/<\/aug>([\., ]*)\&lt\;suffix\&gt;([^\&\;\/]*?)\&lt\;\/suffix\&gt;/$1\&lt\;prefix\&gt;$2\&lt\;\/prefix\&gt;<\/aug>/gs;
  $bibText=~s/<\/aug>([\., ]*)(et al[\.]?|\([Hh]rsg[\.]?\)|\([Hh]g[\.]?\)|\(eds[\.]?\)|\&hellip\;)/$1$2<\/aug>/gs;
  $bibText=~s/<\/edrg>([\., ]*)(et al[\.]?|\([Hh]rsg[\.]?\)|\([Hh]g[\.]?\)|\(eds[\.]?\)|\&hellip\;)/$1$2<\/edrg>/gs;
  $bibText=~s/<\/edrg> (et al[\.]?|et al\.\,|\&hellip\;) ([eE]ditor[s]?|[Ee]d[s]?|[Hh]rsg|Hg|\([Hh]g[\.]?\)|\([Hh]rsg[\.]?\)|\([eE]d[s]?[\.]?\))/ $1 $2<\/edrg>/gs;
  $bibText=~s/<\/aug> (et al[\.]?|et al\.\,|\&hellip\;) ([eE]ditor[s]?|[Ee]d[s]?|[Hh]rsg|Hg|\([Hh]g[\.]?\)|\([Hh]rsg[\.]?\)|\([eE]d[s]?[\.]?\))/ $1 $2<\/aug>/gs;
  $bibText=~s/(\&lt\;edm\&gt\;|\&lt\;edf\&gt\;|\&lt\;eds\&gt\;)(.*)(\&lt\;\/edm\&gt\;|\&lt\;\/edf\&gt\;|\&lt\;\/eds\&gt\;)/<edrg>$1$2$3<\/edrg>/os;
  return $bibText;
}

#==================================================================================================================================================

sub SymbolFonts
{
    my $TextBody=shift;
    my $ID=0;
    my %Symboltable=();
    my $Symboltableref="";
               #<span lang=EN-US style='font-family: "Helvetica","sans-serif"'>ﾘﾟ</span>
               #<span([\s]+)lang=EN-US([\s]+)style=\'font-family:Symbol;background:#FF9933\'>b</span>
    while($TextBody=~/<span([\s]+)lang\=EN\-US([\s]+)style\=\'([^\'<>]*?)font-family\:([a-zA-Z0-9 \_\-\"\,\s]+)\'>([^<>])<\/span>/s)
    {
    	my $symbols="<span lang\=EN\-US style\=\'$3font-family\:$4\'>$5<\/span>";
    	$TextBody=~s/<span([\s]+)lang\=EN\-US([\s]+)style\=\'([^\'<>]*?)font-family\:([a-zA-Z0-9 \_\-\"\,\s]+)\'>([^<>])<\/span>/&\#X$ID;/os;
    	$Symboltable{$ID}="$symbols";
    	$ID++;
    }

    while($TextBody=~/<span([\s]+)style\=\'([^\'<>]*?)font-family\:([a-zA-Z0-9 \_\-\"\,\s]+)\'>([^<>])<\/span>/s)
    {
    	my $symbols="<span style\=\'$2font-family\:$3\'>$4<\/span>";
    	$TextBody=~s/<span([\s]+)style\=\'([^\'<>]*?)font-family\:([a-zA-Z0-9 \_\-\"\,\s]+)\'>([^<>])<\/span>/&\#X$ID;/os;
    	$Symboltable{$ID}="$symbols";
    	$ID++;
    }
    $TextBody=~s/<\/span>\&\#([\&\#0-9A-Za-z\;]+)\;<span([\s]+)style\=\'([^\'<>]*?)font-family\:([a-zA-Z0-9 \_\-\"\,\s]+)\'>/\&\#$1\;/gs;
    $Symboltableref=\%Symboltable;
    return ($TextBody, $Symboltableref) ;
}

#==================================================================================================================================================

sub SymbolFontsOLD
{
    my $FileText=shift;
    my $ID=0;
    my %Symboltable=();
    my $Symboltableref="";
               #<span lang=EN-US style='font-family: "Helvetica","sans-serif"'>ﾘﾟ</span>
               #<span([\s]+)lang=EN-US([\s]+)style=\'font-family:Symbol;background:#FF9933\'>b</span>
    while($FileText=~/<span([\s]+)lang=EN-US([\s]+)style=\'font-family:([a-zA-Z0-9\_\-\"\,\s]+);background:([\#a-zA-Z0-9]+)\'>([^\<\>]*?)<\/span>/s)
      {
	my $background=$4;
	my $symbols="<span lang\=EN\-US style\=\'font-family\:$3\'>$5<\/span>";
	$FileText=~s/<span([\s]+)lang=EN-US([\s]+)style=\'font-family:([a-zA-Z0-9\_\-\"\,\s]+);background:([\#a-zA-Z0-9]+)\'>([^\<\>]*?)<\/span>/<span style='background:$background'>&\#X$ID;<\/span>/os;
	$Symboltable{$ID}="$symbols";
	$ID++;
      }

    while($FileText=~/<span([\s]+)lang\=EN\-US([\s]+)style\=\'font-family\:([a-zA-Z0-9\_\-\"\,\s]+)\'>([^\<\>]*?)<\/span>/s)
      {
     	my $symbols="<span lang\=EN\-US style\=\'font-family\:$3\'>$4<\/span>";
     	$FileText=~s/<span([\s]+)lang\=EN\-US([\s]+)style\=\'font-family\:([a-zA-Z0-9\_\-\"\,\s]+)\'>([^\<\>]*?)<\/span>/&\#X$ID;/os;
     	$Symboltable{$ID}="$symbols";
     	$ID++;
      }
    $Symboltableref=\%Symboltable;
    return $Symboltableref;
}
#================================================================================================================================================

sub AutoStructRefrenceRestructuring
{
    my $FileText=shift;
    my $htmfname=shift;
    my $hext=shift;

    $FileText=htmlPreCleanup(\$FileText);

    ($FileText, my $Symboltable)=&SymbolFonts($FileText);

    $FileText=bibReStructuring($FileText);
    foreach my $KEY(keys %$Symboltable) #%$Symboltableref
      {
	my $symbolKEY="\&\#X$KEY\;";
	$FileText=~s/$symbolKEY/$$Symboltable{$KEY}/s;
      }
	
	$FileText=~s/(\.\W+)\&lt\;\/\w+\&gt\;\./$1\&lt\;\/at\&gt\;/gs;
    $FileText = RefTagToColor($FileText);

    $FileText = DeleteTagForCrossLinking($FileText);#
	
    $FileText=~s/<[\/]?(vg|issg|pgg|edng|doig|yrg|atg|ptg|btg|stg|srtg|cnyg|pblg|misc1g|edrg|aug|urlg|collabg|rpt)>//gs;

	if (defined $style){
		if($style ne "none"){
			if($application=~/^([Rr]eflexica|[Cc]atalyst)$/){
				$FileText = AddOriginalData($FileText, $InputFile);
			}
		}
    }
	
    return $FileText;
}

#========================================================================================================================================

sub TeXAutoStructRefrenceRestructuring
{
    my $FileText=shift;

    $FileText = htmlPreCleanup(\$FileText);

    $FileText = bibReStructuring($FileText);
    $FileText = RefTagToColor($FileText);

    $FileText=~s/<(vg|issg|pgg|edng|doig|yrg|atg|ptg|btg|stg|srtg|cnyg|pblg|misc1g|edrg|aug|urlg|collabg|rpt)>//gs;
    $FileText=~s/<\/(vg|issg|pgg|edng|doig|yrg|atg|ptg|btg|stg|srtg|cnyg|pblg|misc1g|edrg|aug|urlg|collabg|rpt)>//gs;

    $FileText = RefColorToTag($FileText);

    $FileText=~s/\&lt\;(au|edr|aug|auf|aus|eds|edf|par|prefix|aum|edm|edrg|iss|at|pt|s|m|f|cny|cty|pbl|pg|st|srt|v|yr|url|ia|misc1|issn|isbn|coden|doi|edn|collab|bt|proc|suffix|rpt|thesis|pat|org|eml|pco|pbo|rol|tel|fax|comment)\&gt\;/<$1>/gs;
    $FileText=~s/\&lt\;\/(au|edr|aug|auf|aus|eds|edf|par|prefix|aum|edm|edrg|iss|at|pt|s|m|f|cny|cty|pbl|pg|st|srt|v|yr|url|ia|misc1|issn|isbn|coden|doi|edn|collab|bt|proc|suffix|rpt|thesis|pat|org|eml|pco|pbo|rol|tel|fax|comment)&gt;/<\/$1>/gs;
    $FileText=~s/<i><(bt|pt|srt|misc1|v|iss)><i>((?:(?!<\/\1>)(?!<\1>).)*)<\/i><\/\1><\/i>/<$1><i>$2<\/i><\/$1>/gs;
    $FileText = TeXTagReplacement($FileText);
    return $FileText;
}

#========================================================================================================================================

sub TeXAutoStructRefrence
{
    my $FileText=shift;

    use ReferenceManager::TexTagManager;

    $FileText=~s/<span lang=([^<>]*?)>//gs;
    $FileText=~s/<\/span>//gs;

    $FileText = RefTagToColor($FileText);

    $FileText=~s/<[\/]?(vg|issg|pgg|edng|doig|yrg|atg|ptg|btg|stg|srtg|cnyg|pblg|misc1g|edrg|aug|urlg|collabg|rpt)>//gs;

    $FileText = RefColorToTag($FileText);

    $FileText=~s/\&lt\;(au|edr|aug|auf|aus|eds|edf|par|prefix|aum|edm|edrg|iss|at|pt|s|m|f|cny|cty|pbl|pg|st|srt|v|yr|url|ia|misc1|issn|isbn|coden|doi|edn|collab|bt|proc|suffix|rpt|thesis|pat|org|eml|pco|pbo|rol|tel|fax|comment)\&gt\;/<$1>/gs;
    $FileText=~s/\&lt\;\/(au|edr|aug|auf|aus|eds|edf|par|prefix|aum|edm|edrg|iss|at|pt|s|m|f|cny|cty|pbl|pg|st|srt|v|yr|url|ia|misc1|issn|isbn|coden|doi|edn|collab|bt|proc|suffix|rpt|thesis|pat|org|eml|pco|pbo|rol|tel|fax|comment)&gt;/<\/$1>/gs;
    $FileText=~s/<i><(bt|pt|srt|misc1|v|iss)><i>((?:(?!<\/\1>)(?!<\1>).)*)<\/i><\/\1><\/i>/<$1><i>$2<\/i><\/$1>/gs;
    $FileText = TeXTagReplacement($FileText);
    return $FileText;
}

#=================================================================================================================
sub TeXRefrenceResturcturing
{
    my $FileText=shift;

    $FileText=TeX2Tag($FileText);
    $FileText=bibReStructuring($FileText);
    $FileText=RefTagToColor($FileText);

    $FileText=~s/<[\/]?(vg|issg|pgg|edng|doig|yrg|atg|ptg|btg|stg|srtg|cnyg|pblg|misc1g|edrg|aug|urlg|collabg|rpt)>//gs;
    $FileText=RefColorToTag($FileText);

    $FileText=~s/\&lt\;(au|edr|aug|auf|aus|eds|edf|par|prefix|aum|edm|edrg|iss|at|pt|s|m|f|cny|cty|pbl|pg|st|srt|v|yr|url|ia|misc1|issn|isbn|coden|doi|edn|collab|bt|proc|suffix|rpt|thesis|pat|org|eml|pco|pbo|rol|tel|fax|comment)\&gt\;/<$1>/gs;
    $FileText=~s/\&lt\;\/(au|edr|aug|auf|aus|eds|edf|par|prefix|aum|edm|edrg|iss|at|pt|s|m|f|cny|cty|pbl|pg|st|srt|v|yr|url|ia|misc1|issn|isbn|coden|doi|edn|collab|bt|proc|suffix|rpt|thesis|pat|org|eml|pco|pbo|rol|tel|fax|comment)&gt;/<\/$1>/gs;
    $FileText=~s/<i><(bt|pt|srt|misc1|v|iss)><i>((?:(?!<\/\1>)(?!<\1>).)*?)<\/i><\/\1><\/i>/<$1><i>$2<\/i><\/$1>/gs;
    $FileText=TeXTagReplacement($FileText);
    return $FileText;
}
#=================================================================================================================

sub DeleteTagForCrossLinking{
  my $FileText=shift;
  #$FileText=~s/<aug>//gs;
  #$FileText=~s/<\/aug>//gs;
  $FileText=~s/<yrg>//gs;
  $FileText=~s/<\/yrg>//gs;
  $FileText=~s/(\&\#8194\;|\&\#x2002\;|\&\#8195\;|\&\#x2003\;)/ /gs;
  $FileText=~s/<span style=\'background:#66FF66\'>([^<>]*?)<\/span>/<span style=\'background:#66FF66\'>$1<\/span>/gs;

  return $FileText;
}

#=================================================================================================================
sub AuthorGroupEditings{
  my $FileText=shift; 

  #$FileText=~s/\&lt\;(au|aus|auf|par|suffix|prefix)\&gt\;/<$1>/gs;
  $FileText=~s/\&lt\;([\/]?)(au|aus|auf|par|suffix|prefix)\&gt\;/<$1$2>/gs;
  while($FileText=~/<aug>((?:(?!<aug>)(?!<\/aug>).)*)<\/aug>/s)
    {
      my $augText=$1;
      #$augText=AuthorFirstNameEditing($augText);#commented by Biswajit
      $augText=AuthorLastNameFirstNameSep($augText);
      $augText=AuthorsSeprate($augText);  #et al; and|und|&; \,\;
      $FileText=~s/<aug>((?:(?!<aug>)(?!<\/aug>).)*)<\/aug>/<augX>$augText<\/augX>/os;
    }
  $FileText=~s/<augX>(.*?)<\/augX>/<aug>$1<\/aug>/gs;
  #$FileText=~s/<(au|aus|auf|par|suffix|prefix)>/\&lt\;$1\&gt\;/gs;
  $FileText=~s/<([\/]?)(au|aus|auf|par|suffix|prefix)>/\&lt\;$1$2\&gt\;/gs;
  return $FileText;
}

#================================================================================================================

sub EditorGroupEditings{
  my $FileText=shift; 

  $FileText=~s/\&lt\;(edr|eds|edm|par|suffix|prefix)\&gt\;/<$1>/gs;
  $FileText=~s/\&lt\;\/(edr|eds|edm|par|suffix|prefix)\&gt\;/<\/$1>/gs;

  {}while($FileText=~s/<edr>((?:(?!<[\/]?edr>)(?!<[\/]?edrg>).)*?)<\/edr>([\.\, ]+)(\&|[aA]nd|[uU]nd)([\.\, ]+)<edr>((?:(?!<[\/]?edr>)(?!<[\/]?edrg>).)*?)<\/edr>([\.\, ]+)(\&|[aA]nd|[uU]nd)([\.\, ]+)<edr>/<edr>$1<\/edr>$2<edr>$5<\/edr>$6$7$8<edr>/gs);

  #<bib id="bib16"><number>16.</number>
  $FileText=~s/<bib([^<>]*?)><number>([^<>]+?)<\/number><edrg>((?:(?!<edrg>)(?!<\/edrg>).)*)<\/edrg>/<bib$1><number>$2<\/number><edrg><auedr>$3<\/auedr><\/edrg>/gs;
  $FileText=~s/<bib([^<>]*?)><edrg>((?:(?!<edrg>)(?!<\/edrg>).)*)<\/edrg>/<bib$1><edrg><auedr>$2<\/auedr><\/edrg>/gs;
  $FileText=~s/  / /gs;
  $FileText=~s/<edm>([A-Z\.]+)\.([A-Z])<\/edm><\/edr>\./<edm>$1\.$2\.<\/edm><\/edr>/gs;


  while($FileText=~/<edrg>((?:(?!<edrg>)(?!<\/edrg>).)*)<\/edrg>/s)
    {
      my $edrgText=$1;
      #$edrgText=EditorFirstNameEditing($edrgText);#commented by Biswajit 
      $edrgText=EditorLastNameFirstNameSep($edrgText);
      $edrgText=EditorSeprate($edrgText);
      $edrgText=~s/  / /gs;
      $edrgText=~s/<edr>(.*?)<\/edr>([^<>]*?)<edr>(.*?)<\/edr>([\,]?) \(editor([\.]?)\)/<edr>$1<\/edr>$2<edr>$3<\/edr>$4 \(editors$5\)/gs;
      $edrgText=~s/<edr>(.*?)<\/edr>([^<>]*?)<edr>(.*?)<\/edr>([\,]?) \(ed([\.]?)\)/<edr>$1<\/edr>$2<edr>$3<\/edr>$4 \(eds$5\)/gs;
      $edrgText=~s/<edr>(.*?)<\/edr>([^<>]*?)<edr>(.*?)<\/edr>([\,]?) \(Ed([\.]?)\)/<edr>$1<\/edr>$2<edr>$3<\/edr>$4 \(Eds$5\)/gs;
      $edrgText=~s/<edr>(.*?)<\/edr>([^<>]*?)<edr>(.*?)<\/edr>([\,]?) \(Hg([\.]?)\)/<edr>$1<\/edr>$2<edr>$3<\/edr>$4 \(Hrgs$5\)/gs;
      $edrgText=~s/<edr>(.*?)<\/edr>([^<>]*?)<edr>(.*?)<\/edr>([\,]?) editor\b([\.]?)/<edr>$1<\/edr>$2<edr>$3<\/edr>$4 editors$5/gs;
      $edrgText=~s/<edr>(.*?)<\/edr>([^<>]*?)<edr>(.*?)<\/edr>([\,]?) ed\b([\.]?)/<edr>$1<\/edr>$2<edr>$3<\/edr>$4 eds$5/gs;
      $edrgText=~s/<edr>(.*?)<\/edr>([^<>]*?)<edr>(.*?)<\/edr>([\,]?) Ed\b([\.]?)/<edr>$1<\/edr>$2<edr>$3<\/edr>$4 Eds$5/gs;
      $edrgText=~s/<edr>(.*?)<\/edr>([^<>]*?)<edr>(.*?)<\/edr>([\,]?) Hg\b([\.]?)/<edr>$1<\/edr>$2<edr>$3<\/edr>$4 Hrgs$5/gs;

      $edrgText=~s/^ed([\.]?) <edr>(.*?)<\/edr>([^<>]*?)<edr>(.*?)<\/edr>/eds$1 <edr>$2<\/edr>$3<edr>$4<\/edr>/gs;
      $edrgText=~s/^Hg([\.]?) <edr>(.*?)<\/edr>([^<>]*?)<edr>(.*?)<\/edr>/Hrgs$1 <edr>$2<\/edr>$3<edr>$4<\/edr>/gs;

      $edrgText=~s/(^[Ii]n[\:\.\, ]*|^)<edr>((?:(?!<[\/]?edrg>)(?!<[\/]?edr>)(?!<[\/]?auedr>).)*)<\/edr>([\, \(]+)([eE]ditor|[Ee]d)s([\.\)]*)$/$1<edr>$2<\/edr>$3$4$5/gs;
      $edrgText=~s/^([\(]?)([eE]ditor|[Ee]d)s([\.\:\)]*) <edr>((?:(?!<[\/]?edrg>)(?!<[\/]?edr>)(?!<[\/]?auedr>).)*)<\/edr>([^<>]*?)$/$1$2$3 <edr>$4<\/edr>$5/gs;
      $edrgText=~s/^<auedr><edr>((?:(?!<[\/]?edrg>)(?!<[\/]?edr>)(?!<[\/]?auedr>).)*)<\/edr>([\, \(]+)([eE]ditor|[Ee]d)s/<auedr><edr>$1<\/edr>$2$3/gs;

      $FileText=~s/<edrg>((?:(?!<edrg>)(?!<\/edrg>).)*)<\/edrg>/<edrgX>$edrgText<\/edrgX>/os;
    }
  $FileText=~s/<edrgX>(.*?)<\/edrgX>/<edrg>$1<\/edrg>/gs;
  $FileText=~s/<[\/]?auedr>//gs;

  $FileText=~s/<(edr|eds|edm|par|suffix|prefix)>/\&lt\;$1\&gt\;/gs;
  $FileText=~s/<\/(edr|eds|edm|par|suffix|prefix)>/\&lt\;\/$1\&gt\;/gs;


  return $FileText;
}


#=================================================================================================================
sub AuthorFirstNameEditing{
  my $augText=shift;
if($style eq "Basic" or $style eq "Chemistry" or $style eq "Vancouver" or $style eq "ElsVancouver")
  {
    while($augText=~/<auf>([^<>]*)<\/auf>/)
      {
	my $Fname=$1;
	$Fname=authorFirstNameAbbreviateNodot($Fname);
	$augText=~s/<auf>([^<>]*)<\/auf>/\&lt\;auf\&gt\;$Fname\&lt\;\/auf\&gt\;/os;
      }
	$augText=~s/\&lt\;auf\&gt\;/<auf>/gs;
	$augText=~s/\&lt\;\/auf\&gt\;/<\/auf>/gs;
  }

if($style eq "MPS" or $style eq "APA" or $style eq "ApaOrg" or $style eq "ElsAPA5" or $style eq "ElsACS")
  {
    while($augText=~/<auf>([^<>]*)<\/auf>/)
      {
	my $Fname=$1;
	$Fname=authorFirstNameAbbreviateDot($Fname);
	if($style eq "APA" or $style eq "ApaOrg" or $style eq "ElsAPA5" or $style eq "ElsACS")
	  {
	    $Fname=~s/\.([A-Za-z])/\. $1/gs; #Condition 3
	  }
	$augText=~s/<auf>([^<>]*)<\/auf>/\&lt\;auf\&gt\;$Fname\&lt\;\/auf\&gt\;/os;
      }
	$augText=~s/\&lt\;auf\&gt\;/<auf>/gs;
	$augText=~s/\&lt\;\/auf\&gt\;/<\/auf>/gs;
  }

if($style eq "APS")
  {
    while($augText=~/<auf>([^<>]*)<\/auf>/)
      {
	my $Fname=$1;
	$Fname=authorFirstNameAbbreviateDot($Fname);
	$augText=~s/<auf>([^<>]*)<\/auf>/\&lt\;auf\&gt\;$Fname\&lt\;\/auf\&gt\;/os;
      }
	$augText=~s/\&lt\;auf\&gt\;/<auf>/gs;
	$augText=~s/\&lt\;\/auf\&gt\;/<\/auf>/gs;
  }
    if($style eq "Chicago")
      {
    	while($augText=~/<auf>([^<>]*?)<\/auf>/)
    	  {
    	    my $Fname=$1;
    	    $fname=~s/^([A-Z])[\. ]*([A-Z])[\. ]*([A-Z])[\. ]*([A-Z])[\.]?$/$1\. $2\. $3\. $4\./gs; 
    	    $Fname=~s/^([A-Z])[\. ]*([A-Z])[\. ]*([A-Z])[\.]?$/$1\. $2\. $3\./gs; 
    	    $Fname=~s/^([A-Z])[\. ]*([A-Z])[\.]?$/$1\. $2\./gs; 
    	    $Fname=~s/^([A-Z])[\.]?$/$1\./gs; 
	    $Fname=~s/\-([A-Z])$/\-$1\./gs;
    	    $augText=~s/<auf>([^<>]*)<\/auf>/\&lt\;auf\&gt\;$Fname\&lt\;\/auf\&gt\;/os;
    	  }
    	$augText=~s/\&lt\;auf\&gt\;/<auf>/gs;
    	$augText=~s/\&lt\;\/auf\&gt\;/<\/auf>/gs;


      }
 return $augText;
}

#=================================================================================================================

sub AuthorLastNameFirstNameSep{

  my $augText=shift;

if($style eq "Basic" or $style eq "Chemistry" or $style eq "Vancouver" or $style eq "ElsVancouver")
  {

    #$augText=~s/<au><par>Van de<\/par> <aus>//gs;
    $augText=~s/<au><aus>([^<>]*?)<\/aus>([\;\,\. ]*?)<auf>([^<>]*?)<\/auf><\/au>/<au><aus>$1<\/aus> <auf>$3<\/auf><\/au>/gs;
    $augText=~s/<au><auf>([^<>]*?)<\/auf>([\,\;\. ]*?)<aus>([^<>]*?)<\/aus><\/au>/<au><aus>$3<\/aus> <auf>$1<\/auf><\/au>/gs;
    $augText=~s/<au><aus>([^<>]*?)<\/aus>([\,\;\. ]*?)<auf>([^<>]*?)<\/auf>([\,\. ]*?)<suffix>([^<>]*?)<\/suffix><\/au>/<au><aus>$1<\/aus> <auf>$3<\/auf> <suffix>$5<\/suffix><\/au>/gs;
    $augText=~s/<au><auf>([^<>]*?)<\/auf>([\,\;\. ]*?)<aus>([^<>]*?)<\/aus>([\,\. ]*?)<suffix>([^<>]*?)<\/suffix><\/au>/<au><aus>$3<\/aus> <auf>$1<\/auf> <suffix>$5<\/suffix><\/au>/gs;
    $augText=~s/<au><auf>([^<>]*?)<\/auf>([\,\;\. ]*?)<suffix>([^<>]*?)<\/suffix>([\,\. ]*?)<aus>([^<>]*?)<\/aus><\/au>/<au><aus>$5<\/aus> <auf>$1<\/auf> <suffix>$3<\/suffix><\/au>/gs;
    $augText=~s/<au><aus>([^<>]*?)<\/aus>([\,\;\. ]*?)<suffix>([^<>]*?)<\/suffix>([\,\. ]*?)<auf>([^<>]*?)<\/auf><\/au>/<au><aus>$1<\/aus> <auf>$5<\/auf> <suffix>$3<\/suffix><\/au>/gs;
    $augText=~s/<au><aus>([^<>]*?)<\/aus>([\,\;\. ]*?)<auf>([^<>]*?)<\/auf>([\,\. ]*?)<par>([^<>]*?)<\/par><\/au>/<au><aus>$1<\/aus> <auf>$3<\/auf> <par>$5<\/par><\/au>/gs;
    $augText=~s/<au><auf>([^<>]*?)<\/auf>([\,\;\. ]*?)<par>([^<>]*?)<\/par>([\,\. ]*?)<aus>([^<>]*?)<\/aus><\/au>/<au><par>$3<\/par> <aus>$5<\/aus> <auf>$1<\/auf><\/au>/gs;
    $augText=~s/<au><par>([^<>]*?)<\/par>([\,\;\. ]*?)<aus>([^<>]*?)<\/aus>([\,\. ]*?)<auf>([^<>]*?)<\/auf><\/au>/<au><par>$1<\/par> <aus>$3<\/aus> <auf>$5<\/auf><\/au>/gs;
    $augText=~s/<au><par>([^<>]*?)<\/par>([\,\;\. ]*?)<aus>([^<>]*?)<\/aus>([\,\. ]*?)<auf>([^<>]*?)<\/auf>([\,\. ]+)<suffix>([^<>]*?)<\/suffix><\/au>/<au><par>$1<\/par> <aus>$3<\/aus> <auf>$5<\/auf> <suffix>$7<\/suffix><\/au>/gs;

    $augText=~s/<au><par>([^<>]*?)<\/par>([\,\;\. ]*?)<aus>([^<>]*?)<\/aus>([\,\. ]*?)<auf>([^<>]*?)<\/auf><\/au>/<au><par>$1<\/par> <aus>$3<\/aus> <auf>$5<\/auf><\/au>/gs;
    $augText=~s/<au><prefix>([^<>]*?)<\/prefix>([\,\;\. ]*?)<aus>([^<>]*?)<\/aus>([\,\. ]*?)<auf>([^<>]*?)<\/auf><\/au>/<au><prefix>$1<\/prefix> <aus>$3<\/aus> <auf>$5<\/auf><\/au>/gs;
    $augText=~s/<suffix>([^<>]*?)\.<\/suffix>/<suffix>$1<\/suffix>/gs; #Remove . from Suffix
	
  }


if($style eq "MPS" or $style eq "APA" or $style eq "Chicago" or $style eq "ApaOrg" or $style eq "ElsAPA5" or $style eq "ElsACS")
  {
    $augText=~s/<au><aus>([^<>]*?)<\/aus>([\,\;\. ]*?)<auf>([^<>]*?)<\/auf><\/au>/<au><aus>$1<\/aus>\, <auf>$3<\/auf><\/au>/gs;
    $augText=~s/<au><auf>([^<>]*?)<\/auf>([\,\. ]*?)<aus>([^<>]*?)<\/aus><\/au>/<au><aus>$3<\/aus>\, <auf>$1<\/auf><\/au>/gs;
    $augText=~s/<au><aus>([^<>]*?)<\/aus>([\,\;\. ]*?)<auf>([^<>]*?)<\/auf>([\,\. ]*?)<suffix>([^<>]*?)<\/suffix><\/au>/<au><aus>$1<\/aus>\, <auf>$3<\/auf> <suffix>$5<\/suffix><\/au>/gs;
    $augText=~s/<au><auf>([^<>]*?)<\/auf>([\,\;\. ]*?)<aus>([^<>]*?)<\/aus>([\,\. ]*?)<suffix>([^<>]*?)<\/suffix><\/au>/<au><aus>$3<\/aus>\, <auf>$1<\/auf> <suffix>$5<\/suffix><\/au>/gs;

    $augText=~s/<au><auf>([^<>]*?)<\/auf>([\,\;\. ]*?)<suffix>([^<>]*?)<\/suffix>([\,\. ]*?)<aus>([^<>]*?)<\/aus><\/au>/<au><aus>$1<\/aus>\, <auf>$5<\/auf> <suffix>$3<\/suffix><\/au>/gs;
    $augText=~s/<au><aus>([^<>]*?)<\/aus>([\,\;\. ]*?)<suffix>([^<>]*?)<\/suffix>([\,\. ]*?)<auf>([^<>]*?)<\/auf><\/au>/<au><aus>$1<\/aus>\, <auf>$5<\/auf> <suffix>$3<\/suffix><\/au>/gs;

    $augText=~s/<au><aus>([^<>]*?)<\/aus>([\,\;\. ]*?)<auf>([^<>]*?)<\/auf>([\,\. ]*?)<par>([^<>]*?)<\/par><\/au>/<au><par>$5<\/par> <aus>$1<\/aus>\, <auf>$3<\/auf><\/au>/gs;
    $augText=~s/<au><auf>([^<>]*?)<\/auf>([\,\;\. ]*?)<par>([^<>]*?)<\/par>([\,\. ]*?)<aus>([^<>]*?)<\/aus><\/au>/<au><par>$3<\/par> <aus>$5<\/aus>\, <auf>$1<\/auf><\/au>/gs;
    $augText=~s/<au><par>([^<>]*?)<\/par>([\,\;\. ]*?)<aus>([^<>]*?)<\/aus>([\,\. ]*?)<auf>([^<>]*?)<\/auf><\/au>/<au><par>$1<\/par> <aus>$3<\/aus>\, <auf>$5<\/auf><\/au>/gs;
    $augText=~s/<au><par>([^<>]*?)<\/par>([\,\;\. ]*?)<aus>([^<>]*?)<\/aus>([\,\. ]*?)<auf>([^<>]*?)<\/auf>([\,\. ]*?)<suffix>([^<>]*?)<\/suffix><\/au>/<au><par>$1<\/par> <aus>$3<\/aus>\, <auf>$5<\/auf> <suffix>$7<\/suffix><\/au>/gs;
   # print "$augText\n";
    if($style eq "MPS" or $style eq "APA" or $style eq "ApaOrg" or $style eq "ElsAPA5" or $style eq "ElsACS"){
      $augText=~s/<suffix>([^<>]*?)[\.]?<\/suffix>/<suffix>$1<\/suffix>/gs; #Remove . from Suffix
      $augText=~s/<suffix>(Jr|Sr)[\.]?<\/suffix>/<suffix>$1\.<\/suffix>/gs; #Add . in Suffix
    }
  }


if($style eq "APS")
  {
    $augText=~s/<au><aus>([^<>]*?)<\/aus>([\,\. ]*?)<auf>([^<>]*?)<\/auf><\/au>/<au><auf>$3<\/auf> <aus>$1<\/aus><\/au>/gs;
    $augText=~s/<au><auf>([^<>]*?)<\/auf>([\,\. ]*?)<aus>([^<>]*?)<\/aus><\/au>/<au><auf>$1<\/auf> <aus>$3<\/aus><\/au>/gs;
    $augText=~s/<au><auf>([^<>]*?)<\/auf>([\,\. ]*?)<suffix>([^<>]*?)<\/suffix>([\,\. ]*?)<aus>([^<>]*?)<\/aus><\/au>/<au><auf>$1<\/auf> <aus>$5<\/aus> <suffix>$3<\/suffix><\/au>/gs;
    $augText=~s/<au><aus>([^<>]*?)<\/aus>([\,\. ]*?)<suffix>([^<>]*?)<\/suffix>([\,\. ]*?)<auf>([^<>]*?)<\/auf><\/au>/<au><auf>$5<\/auf> <aus>$1<\/aus> <suffix>$3<\/suffix><\/au>/gs;

    $augText=~s/<au><aus>([^<>]*?)<\/aus>([\,\. ]*?)<auf>([^<>]*?)<\/auf>([\,\. ]*?)<suffix>([^<>]*?)<\/suffix><\/au>/<au><auf>$3<\/auf> <aus>$1<\/aus> <suffix>$5<\/suffix><\/au>/gs;
    $augText=~s/<au><aus>([^<>]*?)<\/aus>([\,\. ]*?)<auf>([^<>]*?)<\/auf>([\,\. ]*?)<par>([^<>]*?)<\/par><\/au>/<au><auf>$3<\/auf> <par>$5<\/par> <aus>$1<\/aus><\/au>/gs;
    $augText=~s/<au><par>([^<>]*?)<\/par>([\,\. ]*?)<aus>([^<>]*?)<\/aus>([\,\. ]*?)<auf>([^<>]*?)<\/auf><\/au>/<au><auf>$5<\/auf> <par>$1<\/par> <aus>$3<\/aus><\/au>/gs;
    $augText=~s/<au><auf>([^<>]*?)<\/auf>([\,\. ]*?)<par>([^<>]*?)<\/par>([\,\. ]*?)<aus>([^<>]*?)<\/aus><\/au>/<au><auf>$1<\/auf> <par>$3<\/par> <aus>$5<\/aus><\/au>/gs;
    $augText=~s/<au><par>([^<>]*?)<\/par>([\,\. ]*?)<aus>([^<>]*?)<\/aus>([\,\. ]*?)<auf>([^<>]*?)<\/auf>([\,\. ]*?)<suffix>([^<>]*?)<\/suffix><\/au>/<au> <auf>$5<\/auf> <par>$1<\/par> <aus>$3<\/aus> <suffix>$7<\/suffix><\/au>/gs;


    $augText=~s/<au><auf>([^<>]*?)<\/auf>([\,\. ]*?)<aus>([^<>]*?)<\/aus><\/au>/<au><auf>$1<\/auf> <aus>$3<\/aus><\/au>/gs;
    $augText=~s/<au><auf>([^<>]*?)<\/auf>([\,\. ]*?)<aus>([^<>]*?)<\/aus>([\,\. ]*?)<suffix>([^<>]*?)<\/suffix><\/au>/<au><auf>$1<\/auf> <aus>$3<\/aus> <suffix>$5<\/suffix><\/au>/gs;
    $augText=~s/<suffix>([^<>]*?)[\.]?<\/suffix>/<suffix>$1<\/suffix>/gs; #Remove . from Suffix
    $augText=~s/<suffix>(Jr|Sr)[\.]?<\/suffix>/<suffix>$1\.<\/suffix>/gs; #Remove . from Suffix
  }


if($style eq "Chicago")
  {
    $augText=~s/^<au><aus>([^<>]*?)<\/aus>([\,\/ ]*?)<auf>([^<>]*?)<\/auf><\/au>/<auX><aus>$1<\/aus>\, <auf>$3<\/auf><\/auX>/gs;
    $augText=~s/^<au><auf>([^<>]*?)<\/auf>([\,\/ ]*?)<aus>([^<>]*?)<\/aus><\/au>/<auX><aus>$3<\/aus>\, <auf>$1<\/auf><\/auX>/gs;
    $augText=~s/^<au><aus>([^<>]*?)<\/aus>([\,\/ ]*?)<auf>([^<>]*?)<\/auf>([\,\/ ]*?)<suffix>([^<>]*?)<\/suffix><\/au>/<auX><aus>$1<\/aus>\, <auf>$3<\/auf> <suffix>$5<\/suffix><\/auX>/gs;
    $augText=~s/^<au><aus>([^<>]*?)<\/aus>([\,\/ ]*?)<auf>([^<>]*?)<\/auf>([\,\/ ]*?)<par>([^<>]*?)<\/par><\/au>/<auX><aus>$1<\/aus>\, <par>$5<\/par> <auf>$3<\/auf><\/auX>/gs;
    $augText=~s/^<au><par>([^<>]*?)<\/par>([\,\/ ]*?)<aus>([^<>]*?)<\/aus>([\,\/ ]*?)<auf>([^<>]*?)<\/auf><\/au>/<auX><par>$1<\/par> <aus>$3<\/aus>\, <auf>$5<\/auf><\/au>/gs;
    #<au><par>de</par> <aus>Saussure</aus>, <auf>F.</auf></au>
    $augText=~s/<au><par>([^<>]*?)<\/par>([\,\. ]*?)<aus>([^<>]*?)<\/aus>([\,\. ]*?)<auf>([^<>]*?)<\/auf><\/au>/<au><auf>$5<\/auf> <par>$1<\/par> <aus>$3<\/aus><\/au>/gs;
    $augText=~s/<au><aus>([^<>]*?)<\/aus>([\,\. ]*?)<auf>([^<>]*?)<\/auf><\/au>/<au><auf>$3<\/auf> <aus>$1<\/aus><\/au>/gs;
    $augText=~s/<au><aus>([^<>]*?)<\/aus>([\,\. ]*?)<auf>([^<>]*?)<\/auf>([\, ]+)<suffix>([^<>]*?)<\/suffix><\/au>/<au><auf>$3<\/auf> <aus>$1<\/aus> <suffix>$5<\/suffix><\/au>/gs;
    $augText=~s/<au><aus>([^<>]*?)<\/aus>([\,\. ]*?)<auf>([^<>]*?)<\/auf>([\, ]+)<par>([^<>]*?)<\/par><\/au>/<au><auf>$3<\/auf> <par>$5<\/par> <aus>$1<\/aus><\/au>/gs;
    $augText=~s/<au><par>([^<>]*?)<\/par>([\,\. ]*?)<aus>([^<>]*?)<\/aus>,([ ]?)<auf>([^<>]*?)<\/auf><\/au>/<au><auf>$5<\/auf> <par>$1<\/par> <aus>$3<\/aus><\/au>/gs;
    $augText=~s/<au><par>([^<>]*?)<\/par>([\,\. ]*?)<aus>([^<>]*?)<\/aus>,([ ]?)<auf>([^<>]*?)<\/auf>([\, ]+)<suffix>([^<>]*?)<\/suffix><\/au>/<au> <auf>$5<\/auf> <par>$1<\/par> <aus>$3<\/aus> <suffix>$7<\/suffix><\/au>/gs;
    $augText=~s/<au><auf>([^<>]*?)<\/auf>([\,\. ]*?)<aus>([^<>]*?)<\/aus><\/au>/<au><auf>$1<\/auf> <aus>$3<\/aus><\/au>/gs;
    $augText=~s/<au><auf>([^<>]*?)<\/auf>([\,\. ]*?)<aus>([^<>]*?)<\/aus>([\, ]+)<suffix>([^<>]*?)<\/suffix><\/au>/<au><auf>$1<\/auf> <aus>$3<\/aus> <suffix>$5<\/suffix><\/au>/gs;

   # print  "$augText\n";
    $augText=~s/<auX>/<au>/gs;
    $augText=~s/<\/auX>/<\/au>/gs;

  }

  return $augText;
}

#========================================================================
sub AuthorsSeprate{
  my  $augText=shift;

  while($augText=~s/<\/au>([\,\;\.\/ ]*?)([aAuU]nd|u\.|U\.|\&|\&amp\;|\&[ ]?\&hellip\;|\&hellip\;|\.\.\.[ ]?\&|\.\.\.[ ]?[aAuU]nd)([\, ]*?)<au>((?:(?!\n)(?!<edrg>)(?!<misc1>)(?!<bt>).)*)<\/au>([\,\;\.\/ ]*?)([aAuU]nd|u\.|U\.|\&|\&amp\;|\&[ ]?\&hellip\;|\&hellip\;|\.\.\.[ ]?\&|\.\.\.[ ]?[aAuU]nd)([\, ]*?)<au>/<\/au>$1$3<au>$4<\/au>$5$6$7<au>/gs){}

  if($style eq "Basic" or $style eq "Chemistry" or $style eq "MPS" or $style eq "APS" or $style eq "Vancouver" or $style eq "ElsVancouver"){
    $augText=~s/<\/au>([\,\;\.\/ ]*?)([aAuU]nd|u\.|U\.|\&|\&amp\;|\&[ ]?\&hellip\;|\&hellip\;|\.\.\.[ ]?\&|\.\.\.[ ]?[aAuU]nd)([\, ]*?)<au>/<\/au>\, <au>/gs; #and und &
    $augText=~s/<\/au>([\,\;\/ ]*?)<au>/<\/au>\, <au>/gs;
  }
  if($style eq "Basic" or $style eq "Chemistry"){
    $augText=authorEditorEtalEdit($augText, 'au', ' et al');
    $augText=~s/<\/au>([\,\;\/ ]*?)<au>/<\/au>\, <au>/gs;
  }
  if($style eq "MPS" or $style eq "APA" or $style eq "ApaOrg" or $style eq "Chicago" or $style eq "ElsAPA5"){
    $augText=authorEditorEtalEdit($augText, 'au', ', et al.');
    $augText=~s/<\/au>([\,\;\/ ]*?)<au>/<\/au>\, <au>/gs;
  }
  if($style eq "APS"){
    $augText=authorEditorEtalEdit($augText, 'au', ' et al.');
    $augText=~s/<\/au>([\,\;\/ ]*?)<au>/<\/au>\, <au>/gs;
  }
  if($style eq "APA"){
    $augText=~s/<\/au>([\,\;\.\/ ]*?)([aAuU]nd|u\.|U\.|\&|\&amp\;|\&[ ]?\&hellip\;|\&hellip\;|\.\.\.[ ]?\&|\.\.\.[ ]?[aAuU]nd)([\, ]*?)<au>/<\/au>\, \&amp\; <au>/gs;  #and und
    $augText=~s/<\/au>([\,\;\/ ]*?)<au>/<\/au>\, <au>/gs;
    $augText=~s/<au>(.*?)<\/au>([\,\;\/ ]*?)<au>((?:(?!<au>)(?!<\/au>).)*)<\/au>([\,\;\/ ]*?)<ia>([^<>]+?)<\/ia>$/<au>$1<\/au>\, \&amp\; <au>$3<\/au>$4<ia>$5<\/ia>/gs;
    $augText=~s/<au>(.*?)<\/au>([\,\;\/ ]*?)<au>((?:(?!<au>)(?!<\/au>).)*)<\/au>([\s]*)$/<au>$1<\/au>\, \&amp\; <au>$3<\/au>$4/gs;
   # $augText=&listSixAuthorEtalEdit($augText);
  }
  if($style eq "ApaOrg"){
    $augText=~s/<\/au>([\,\;\.\/ ]*?)([aAuU]nd|u\.|U\.|\&|\&amp\;|\.\.\.[ ]?\&|\.\.\.[ ]?[aAuU]nd)([\, ]*?)<au>/<\/au>\, \&amp\; <au>/gs;  #and und
    $augText=~s/<\/au>([\,\;\/ ]*?)<au>/<\/au>\, <au>/gs;
    $augText=~s/<au>(.*?)<\/au>([\,\;\/ ]*?)<au>((?:(?!<au>)(?!<\/au>).)*)<\/au>([\,\;\/ ]*?)<ia>([^<>]+?)<\/ia>$/<au>$1<\/au>\, \&amp\; <au>$3<\/au>$4<ia>$5<\/ia>/gs;
    $augText=~s/<au>(.*?)<\/au>([\,\;\/ ]*?)<au>((?:(?!<au>)(?!<\/au>).)*)<\/au>([\s]*)$/<au>$1<\/au>\, \&amp\; <au>$3<\/au>$4/gs;
    $augText=~s/^<au>((?:(?!<au>)(?!<\/au>).)*)<\/au>([\,\;\/ ]*?)<au>((?:(?!<au>)(?!<\/au>).)*)<\/au>([\,\;\/ ]*?)<au>((?:(?!<au>)(?!<\/au>).)*)<\/au>([\,\;\/ ]*?)<au>((?:(?!<au>)(?!<\/au>).)*)<\/au>([\,\;\/ ]*?)<au>((?:(?!<au>)(?!<\/au>).)*)<\/au>([\,\;\/ ]*?)<au>((?:(?!<au>)(?!<\/au>).)*)<\/au>([\,\;\/ ]*?)<au>((?:(?!<au>)(?!<\/au>).)*)<\/au>([\,\;\/ ]+|[\, ]+\&amp;\s*|[\, ]+\&hellip\;\s*|[\, ]+[aA][nN][dD]\s*)<au>((?:(?!<au>)(?!<\/au>).)*)<\/au>([\s]*)$/<au>$1<\/au>$2<au>$3<\/au>$4<au>$5<\/au>$6<au>$7<\/au>$8<au>$9<\/au>$10<au>$11<\/au>\,&hellip;<au>$15<\/au>/gs;
    $augText=~s/^<au>((?:(?!<au>)(?!<\/au>).)*)<\/au>([\,\;\/ ]*?)<au>((?:(?!<au>)(?!<\/au>).)*)<\/au>([\,\;\/ ]*?)<au>((?:(?!<au>)(?!<\/au>).)*)<\/au>([\,\;\/ ]*?)<au>((?:(?!<au>)(?!<\/au>).)*)<\/au>([\,\;\/ ]*?)<au>((?:(?!<au>)(?!<\/au>).)*)<\/au>([\,\;\/ ]*?)<au>((?:(?!<au>)(?!<\/au>).)*)<\/au>([\,\;\/ ]*?)<au>(.*)<\/au>([\,\;\/ ]+|[\, ]+\&amp;\s*|[\, ]+\&hellip\;\s*|[\, ]+[aA][nN][dD]\s*)<au>((?:(?!<au>)(?!<\/au>).)*)<\/au>([\s]*)$/<au>$1<\/au>$2<au>$3<\/au>$4<au>$5<\/au>$6<au>$7<\/au>$8<au>$9<\/au>$10<au>$11<\/au>\,\&hellip\;<au>$15<\/au>/gs;
    $augText=~s/<\/au>[\, ]+\&hellip\;\s*<au>/<\/au>\,&hellip\;<au>/gs;
  }
  if($style eq "ElsAPA5"){
    $augText=~s/<\/au>([\,\;\.\/ ]*?)([aAuU]nd|u\.|U\.|\&|\&amp\;|\.\.\.[ ]?\&|\.\.\.[ ]?[aAuU]nd)([\, ]*?)<au>/<\/au>\, <au>/gs;  #and und
    $augText=~s/<\/au>([\,\;\/ ]*?)<au>/<\/au>\, <au>/gs;
    $augText=~s/<au>(.*?)<\/au>([\,\;\/ ]*?)<au>((?:(?!<au>)(?!<\/au>).)*)<\/au>([\,\;\/ ]*?)<ia>([^<>]+?)<\/ia>$/<au>$1<\/au>\, \&amp\; <au>$3<\/au>$4<ia>$5<\/ia>/gs;
    $augText=~s/<au>(.*?)<\/au>([\,\;\/ ]*?)<au>((?:(?!<au>)(?!<\/au>).)*)<\/au>([\s]*)$/<au>$1<\/au>\, \&amp\; <au>$3<\/au>$4/gs;
    $augText=&listSixAuthorEtalEdit($augText);
  }

  if($style eq "ElsACS"){
    $augText=~s/<\/au>([\,\;\.\/ ]*?)([aAuU]nd|u\.|U\.|\&|\&amp\;|\.\.\.[ ]?\&|\.\.\.[ ]?[aAuU]nd)([\, ]*?)<au>/<\/au>\; <au>/gs;  #and und
    $augText=~s/<\/au>([\,\;\/ ]*?)<au>/<\/au>\; <au>/gs;
    $augText=~s/<au>(.*?)<\/au>([\,\;\/ ]*?)<au>((?:(?!<au>)(?!<\/au>).)*)<\/au>([\s]*)$/<au>$1<\/au>\; <au>$3<\/au>$4/gs;
  }

  if($style eq "Vancouver"){
      $augText=authorEditorEtalEdit($augText, 'au', ', et al');
      $augText=~s/<\/au>([\,\;\/ ]*?)<au>/<\/au>\, <au>/gs;
    }

  if($style eq "ElsVancouver"){
    $augText=authorEditorEtalEdit($augText, 'au', ', et al');
    $augText=~s/<\/au>([\,\;\/ ]*?)<au>/<\/au>\, <au>/gs;
    $augText=~s/^<au>((?:(?!<au>)(?!<\/au>).)*)<\/au>([\,\;\/ ]*?)<au>((?:(?!<au>)(?!<\/au>).)*)<\/au>([\,\;\/ ]*?)<au>((?:(?!<au>)(?!<\/au>).)*)<\/au>([\,\;\/ ]*?)<au>((?:(?!<au>)(?!<\/au>).)*)<\/au>([\,\;\/ ]*?)<au>((?:(?!<au>)(?!<\/au>).)*)<\/au>([\,\;\/ ]*?)<au>((?:(?!<au>)(?!<\/au>).)*)<\/au>([\,\;\/ ]+|[\, ]+\&amp;\s*|[\, ]+\&hellip\;\s*|[\, ]+[aA][nN][dD]\s*)<au>((?:(?!<au>)(?!<\/au>).)*)<\/au>([\s]*)$/<au>$1<\/au>$2<au>$3<\/au>$4<au>$5<\/au>$6<au>$7<\/au>$8<au>$9<\/au>$10<au>$11<\/au>\, et al\./gs;
    $augText=~s/^<au>((?:(?!<au>)(?!<\/au>).)*)<\/au>([\,\;\/ ]*?)<au>((?:(?!<au>)(?!<\/au>).)*)<\/au>([\,\;\/ ]*?)<au>((?:(?!<au>)(?!<\/au>).)*)<\/au>([\,\;\/ ]*?)<au>((?:(?!<au>)(?!<\/au>).)*)<\/au>([\,\;\/ ]*?)<au>((?:(?!<au>)(?!<\/au>).)*)<\/au>([\,\;\/ ]*?)<au>((?:(?!<au>)(?!<\/au>).)*)<\/au>([\,\;\/ ]*?)<au>(.*)<\/au>([\,\;\/ ]+|[\, ]+\&amp;\s*|[\, ]+\&hellip\;\s*|[\, ]+[aA][nN][dD]\s*)<au>((?:(?!<au>)(?!<\/au>).)*)<\/au>([\s]*)$/<au>$1<\/au>$2<au>$3<\/au>$4<au>$5<\/au>$6<au>$7<\/au>$8<au>$9<\/au>$10<au>$11<\/au>\, et al\./gs;
  }

  if($style eq "Chicago"){
    $augText=~s/<\/au>([\,\;\.\/ ]*?)([uU]nd|u\.|U\.|\.\.\.[ ]?\&|\.\.\.[ ]?[uU]nd)([\, ]*?)<au>/<\/au>\, und <au>/gs;
    $augText=~s/<\/au>([\,\;\.\/ ]*?)([aA]nd|\&|\&amp\;|\.\.\.[ ]?\&|\.\.\.[ ]?[aA]nd)([\, ]*?)<au>/<\/au>\, and <au>/gs;
    $augText=~s/<au>(.*?)<\/au>([\,\;\/ ]*?)<au>((?:(?!<au>)(?!<\/au>).)*)<\/au>([\,\;\/ ]*?)<ia>([^<>]+?)<\/ia>$/<au>$1<\/au>\, and <au>$3<\/au>$4<ia>$5<\/ia>/gs;
    $augText=~s/<au>(.*?)<\/au>([\,\;\/ ]*?)<au>((?:(?!<au>)(?!<\/au>).)*)<\/au>([\s]*)$/<au>$1<\/au>\, and <au>$3<\/au>$4/gs;
    $augText=~s/<au>(.*?)<\/au>([\,\;\/ ]*?)<au>((?:(?!<au>)(?!<\/au>).)*)<\/au>([^<>]+)$/<au>$1<\/au>\, and <au>$3<\/au>$4/gs;
    $augText=~s/<\/au>([\,\;\/ ]*?)<au>/<\/au>\, <au>/gs;
  }
  return $augText;
}

#======================================================================================================================================================
################################################################################################################
sub EditorFirstNameEditing{
  my $augText=shift;


  if($style eq "Basic" or $style eq "Chemistry" or $style eq "Vancouver" or $style eq "ElsVancouver"){
    while($augText=~/<edm>([^<>]*)<\/edm>/){
      my $Fname=$1;
      $Fname=authorFirstNameAbbreviateNodot($Fname);
      $augText=~s/<edm>([^<>]*)<\/edm>/\&lt\;edm\&gt\;$Fname\&lt\;\/edm\&gt\;/os;
    }
    $augText=~s/\&lt\;([\/]?)edm\&gt\;/<$1edm>/gs;
  }
  if($style eq "MPS" or $style eq "APA" or $style eq "ApaOrg" or $style eq "ElsAPA5" or $style eq "ElsACS"){
    while($augText=~/<edm>([^<>]*)<\/edm>/){
      my $Fname=$1;
      $Fname=authorFirstNameAbbreviateDot($Fname);
      if($style eq "APA" or $style eq "ApaOrg" or $style eq "ElsAPA5" or $style eq "ElsACS"){
	$Fname=~s/\.([A-Za-z])/\. $1/gs; #Condition 3
      }
      $augText=~s/<edm>([^<>]*)<\/edm>/\&lt\;edm\&gt\;$Fname\&lt\;\/edm\&gt\;/os;
    }
    $augText=~s/\&lt\;([\/]?)edm\&gt\;/<$1edm>/gs;
  }
  if($style eq "APS"){
    while($augText=~/<edm>([^<>]*)<\/edm>/){
      my $Fname=$1;
      $Fname=authorFirstNameAbbreviateDot($Fname);
      $augText=~s/<edm>([^<>]*)<\/edm>/\&lt\;edm\&gt\;$Fname\&lt\;\/edm\&gt\;/os;
    }
    $augText=~s/\&lt\;([\/]?)edm\&gt\;/<$1edm>/gs;
  }
  if($style eq "Chicago"){
    while($augText=~/<edm>([^<>]*?)<\/edm>/){
      my $Fname=$1;
      $fname=~s/^([A-Z])[\. ]*([A-Z])[\. ]*([A-Z])[\. ]*([A-Z])[\.]?$/$1\. $2\. $3\. $4\./gs; 
      $Fname=~s/^([A-Z])[\. ]*([A-Z])[\. ]*([A-Z])[\.]?$/$1\. $2\. $3\./gs; 
      $Fname=~s/^([A-Z])[\. ]*([A-Z])[\.]?$/$1\. $2\./gs; 
      $Fname=~s/^([A-Z])[\.]?$/$1\./gs; 
      #print "\[$Fname\]\n";
      $augText=~s/<edm>([^<>]*)<\/edm>/\&lt\;edm\&gt\;$Fname\&lt\;\/edm\&gt\;/os;
    }
    $augText=~s/\&lt\;([\/]?)edm\&gt\;/<$1edm>/gs;
    #print "$augText\n";
  }
  return $augText;
}

#=================================================================================================================

sub EditorLastNameFirstNameSep{
  my $augText=shift;
  my %regx = ReferenceManager::ReferenceRegex::new();

  if($style eq "Basic" or $style eq "Chemistry" or $style eq "Vancouver" or $style eq "ElsVancouver"){
    $augText=~s/\.<\/edm>\./\.<\/edm>/gs;
    $augText=~s/<edr><eds>([^<>]*?)<\/eds>([\,\. ]*?)<edm>([^<>]*?)<\/edm><\/edr>/<edr><eds>$1<\/eds> <edm>$3<\/edm><\/edr>/gs;
    $augText=~s/<edr><edm>([^<>]*?)<\/edm>([\,\. ]*?)<eds>([^<>]*?)<\/eds><\/edr>/<edr><eds>$3<\/eds> <edm>$1<\/edm><\/edr>/gs;
    $augText=~s/<edr><eds>([^<>]*?)<\/eds>([\,\. ]*?)<edm>([^<>]*?)<\/edm>([\, ]+)<suffix>([^<>]*?)<\/suffix><\/edr>/<edr><eds>$1<\/eds> <edm>$3<\/edm> <suffix>$5<\/suffix><\/edr>/gs;
    $augText=~s/<edr><edm>([^<>]*?)<\/edm>([\,\. ]*?)<eds>([^<>]*?)<\/eds>([\, ]+)<suffix>([^<>]*?)<\/suffix><\/edr>/<edr><eds>$3<\/eds> <edm>$1<\/edm> <suffix>$5<\/suffix><\/edr>/gs;
    $augText=~s/<edr><eds>([^<>]*?)<\/eds>([\,\. ]*?)<suffix>([^<>]*?)<\/suffix>([\,\. ]*?)<edm>([^<>]*?)<\/edm><\/edr>/<edr><eds>$1<\/eds> <edm>$5<\/edm> <suffix>$3<\/suffix><\/edr>/gs;
    $augText=~s/<edr><eds>([^<>]*?)<\/eds>([\,\. ]*?)<edm>([^<>]*?)<\/edm>([\, ]+)<par>([^<>]*?)<\/par><\/edr>/<edr><eds>$1<\/eds> <edm>$3<\/edm> <par>$5<\/par><\/edr>/gs;
    $augText=~s/<edr><par>([^<>]*?)<\/par>([\,\. ]*?)<eds>([^<>]*?)<\/eds>,([ ]?)<edm>([^<>]*?)<\/edm><\/edr>/<edr><par>$1<\/par> <eds>$3<\/eds> <edm>$5<\/edm><\/edr>/gs;
    $augText=~s/<edr><par>([^<>]*?)<\/par>([\,\. ]*?)<eds>([^<>]*?)<\/eds>,([ ]?)<edm>([^<>]*?)<\/edm>([\, ]+)<suffix>([^<>]*?)<\/suffix><\/edr>/<edr><par>$1<\/par> <eds>$3<\/eds> <edm>$5<\/edm> <suffix>$7<\/suffix><\/edr>/gs;
    $augText=~s/<edr><edm>([^<>]*?)<\/edm>([\,\. ]*?)<par>([^<>]*?)<\/par>([\,\. ]*?)<eds>([^<>]*?)<\/eds><\/edr>/<edr><par>$3<\/par> <eds>$5<\/eds> <edm>$1<\/edm><\/edr>/gs;
  }

  if($style eq "Vancouver" or $style eq "ElsVancouver"){
    $augText=~s/<suffix>([^<>]*?)[\.]?<\/suffix>/<suffix>$1<\/suffix>/gs; #Remove . from Suffix
  }

  if($style eq "MPS" or $style eq "Chicago" or $style eq "ElsACS"){
    $augText=~s/\.<\/edm>\./\.<\/edm>/gs;

    $augText=~s/<edr><eds>([^<>]*?)<\/eds>([\,\. ]*?)<edm>([^<>]*?)<\/edm><\/edr>/<edr><eds>$1<\/eds>\, <edm>$3<\/edm><\/edr>/gs;
    $augText=~s/<edr><edm>([^<>]*?)<\/edm>([\,\. ]*?)<eds>([^<>]*?)<\/eds><\/edr>/<edr><eds>$3<\/eds>\, <edm>$1<\/edm><\/edr>/gs;
    $augText=~s/<edr><eds>([^<>]*?)<\/eds>([\,\. ]*?)<edm>([^<>]*?)<\/edm>([\,\. ]+)<suffix>([^<>]*?)<\/suffix><\/edr>/<edr><eds>$1<\/eds>\, <edm>$3<\/edm> <suffix>$5<\/suffix><\/edr>/gs;
    $augText=~s/<edr><edm>([^<>]*?)<\/edm>([\,\. ]*?)<eds>([^<>]*?)<\/eds>([\, ]+)<suffix>([^<>]*?)<\/suffix><\/edr>/<edr><eds>$3<\/eds>\, <edm>$1<\/edm> <suffix>$5<\/suffix><\/edr>/gs;
    $augText=~s/<edr><eds>([^<>]*?)<\/eds>([\,\. ]*?)<suffix>([^<>]*?)<\/suffix>([\,\. ]*?)<edm>([^<>]*?)<\/edm><\/edr>/<edr><eds>$1<\/eds>\, <edm>$5<\/edm> <suffix>$3<\/suffix><\/edr>/gs;
    $augText=~s/<edr><eds>([^<>]*?)<\/eds>([\,\. ]*?)<edm>([^<>]*?)<\/edm>([\,\. ]+)<par>([^<>]*?)<\/par><\/edr>/<edr><par>$5<\/par> <eds>$1<\/eds>\, <edm>$3<\/edm><\/edr>/gs;
    $augText=~s/<edr><par>([^<>]*?)<\/par>([\,\. ]*?)<eds>([^<>]*?)<\/eds>,([ ]?)<edm>([^<>]*?)<\/edm><\/edr>/<edr><par>$1<\/par> <eds>$3<\/eds>\, <edm>$5<\/edm><\/edr>/gs;
    $augText=~s/<edr><par>([^<>]*?)<\/par>([\,\. ]*?)<eds>([^<>]*?)<\/eds>,([ ]?)<edm>([^<>]*?)<\/edm>([\.\, ]+)<suffix>([^<>]*?)<\/suffix><\/edr>/<edr><par>$1<\/par> <eds>$3<\/eds>\, <edm>$5<\/edm> <suffix>$7<\/suffix><\/edr>/gs;
    $augText=~s/<suffix>([^<>]*?)[\.]?<\/suffix>/<suffix>$1<\/suffix>/gs; #Remove . from Suffix
    $augText=~s/<suffix>(Jr|Sr)[\.]?<\/suffix>/<suffix>$1\.<\/suffix>/gs; #Remove . from Suffix

    $augText=~s/<auedr>$regx{editorSuffix}([\.]?)\s*((?:(?!<auedr>)(?!<\/auedr>).)*)<\/auedr>/<auedr>$3 $1$2<\/auedr>/gs;
     if($augText=~/<auedr>/){
       $augText=~s/<auedr><edr><eds>([^<>]*?)<\/eds>([\,\. ]*?)<edm>([^<>]*?)<\/edm><\/edr>/<auedr><edrX><eds>$1<\/eds>, <edm>$3<\/edm><\/edrX>/gs;
       $augText=~s/<auedr><edr><edm>([^<>]*?)<\/edm>([\,\. ]*?)<eds>([^<>]*?)<\/eds><\/edr>/<auedr><edrX><eds>$3<\/eds>, <edm>$1<\/edm><\/edrX>/gs;
       $augText=~s/^<edr><eds>([^<>]*?)<\/eds>([\,\. ]*?)<edm>([^<>]*?)<\/edm><\/edr>/<edrX><eds>$1<\/eds>, <edm>$3<\/edm><\/edrX>/gs;
       $augText=~s/^<edr><edm>([^<>]*?)<\/edm>([\,\. ]*?)<eds>([^<>]*?)<\/eds><\/edr>/<edrX><eds>$3<\/eds>, <edm>$1<\/edm><\/edrX>/gs;
       $augText=~s/<auedr><edr><edm>([^<>]*?)<\/edm>([\,\. ]*?)<eds>([^<>]*?)<\/eds><\/edr>/<auedr><edr><eds>$3<\/eds>\, <edm>$1<\/edm><\/edr>/gs;
       $augText=~s/<auedr><edr><par>([^<>]*?)<\/par>([\, ]+)<edm>([^<>]*?)<\/edm>([\,\. ]*?)<eds>([^<>]*?)<\/eds><\/edr>/<auedr><edr><eds>$5<\/eds>\, <edm>$3<\/edm> <par>$1<\/par><\/edr>/gs;
       $augText=~s/<auedr><edr><suffix>([^<>]*?)<\/suffix>([\, ]+)<edm>([^<>]*?)<\/edm>([\,\. ]*?)<eds>([^<>]*?)<\/eds><\/edr>/<auedr><edr><eds>$5<\/eds>\, <edm>$3<\/edm> <suffix>$1<\/suffix><\/edr>/gs;
     }
  }


  if($style eq "APA" or $style eq "ApaOrg" or $style eq "ElsAPA5"){
    $augText=~s/\.<\/edm>\./\.<\/edm>/gs;
    $augText=~s/<edr><eds>([^<>]*?)<\/eds>([\,\. ]*?)<edm>([^<>]*?)<\/edm><\/edr>/<edr><edm>$3<\/edm> <eds>$1<\/eds><\/edr>/gs;
    $augText=~s/<edr><edm>([^<>]*?)<\/edm>([\,\. ]*?)<eds>([^<>]*?)<\/eds><\/edr>/<edr><edm>$1<\/edm> <eds>$3<\/eds><\/edr>/gs;
    $augText=~s/<edr><eds>([^<>]*?)<\/eds>([\,\. ]*?)<edm>([^<>]*?)<\/edm>([\, ]+)<suffix>([^<>]*?)<\/suffix><\/edr>/<edr><edm>$3<\/edm> <eds>$1<\/eds> <suffix>$5<\/suffix><\/edr>/gs;
    $augText=~s/<edr><edm>([^<>]*?)<\/edm>([\,\. ]*?)<eds>([^<>]*?)<\/eds>([\, ]+)<suffix>([^<>]*?)<\/suffix><\/edr>/<edr><edm>$1<\/edm> <eds>$3<\/eds> <suffix>$5<\/suffix><\/edr>/gs;
    $augText=~s/<edr><eds>([^<>]*?)<\/eds>([\,\. ]*?)<suffix>([^<>]*?)<\/suffix>([\,\. ]*?)<edm>([^<>]*?)<\/edm><\/edr>/<edr><edm>$5<\/edm> <eds>$1<\/eds> <suffix>$3<\/suffix><\/edr>/gs;
    $augText=~s/<edr><eds>([^<>]*?)<\/eds>([\,\. ]*?)<edm>([^<>]*?)<\/edm>([\, ]+)<par>([^<>]*?)<\/par><\/edr>/<edr><par>$5<\/par> <edm>$3<\/edm> <eds>$1<\/eds><\/edr>/gs;
    $augText=~s/<edr><par>([^<>]*?)<\/par>([\,\. ]*?)<eds>([^<>]*?)<\/eds>,([ ]?)<edm>([^<>]*?)<\/edm><\/edr>/<edr><par>$1<\/par> <edm>$5<\/edm> <eds>$3<\/eds><\/edr>/gs;
    $augText=~s/<edr><par>([^<>]*?)<\/par>([\,\. ]*?)<eds>([^<>]*?)<\/eds>,([ ]?)<edm>([^<>]*?)<\/edm>([\, ]+)<suffix>([^<>]*?)<\/suffix><\/edr>/<edr><suffix>$7<\/suffix> <par>$1<\/par> <eds>$3<\/eds> <edm>$5<\/edm><\/edr>/gs;
    $augText=~s/<suffix>([^<>]*?)[\.]?<\/suffix>/<suffix>$1<\/suffix>/gs; #Remove . from Suffix
    $augText=~s/<suffix>(Jr|Sr)[\.]?<\/suffix>/<suffix>$1\.<\/suffix>/gs; #Remove . from Suffix

    if($augText=~/<auedr>/){
      $augText=~s/<edr><edm>([^<>]*?)<\/edm>([\,\. ]*?)<eds>([^<>]*?)<\/eds><\/edr>/<edr><eds>$3<\/eds>\, <edm>$1<\/edm><\/edr>/gs;
      $augText=~s/<edr><par>([^<>]*?)<\/par>([\, ]+)<edm>([^<>]*?)<\/edm>([\,\. ]*?)<eds>([^<>]*?)<\/eds><\/edr>/<edr><eds>$5<\/eds>\, <edm>$3<\/edm> <par>$1<\/par><\/edr>/gs;
      $augText=~s/<edr><suffix>([^<>]*?)<\/suffix>([\, ]+)<edm>([^<>]*?)<\/edm>([\,\. ]*?)<eds>([^<>]*?)<\/eds><\/edr>/<edr><eds>$5<\/eds>\, <edm>$3<\/edm> <suffix>$1<\/suffix><\/edr>/gs;
    }
  }

  if($style eq "APS"){
    $augText=~s/\.<\/edm>\./\.<\/edm>/gs;
    $augText=~s/<edr><eds>([^<>]*?)<\/eds>([\,\. ]*?)<edm>([^<>]*?)<\/edm><\/edr>/<edr><edm>$3<\/edm> <eds>$1<\/eds><\/edr>/gs;
    $augText=~s/<edr><edm>([^<>]*?)<\/edm>([\,\. ]*?)<eds>([^<>]*?)<\/eds><\/edr>/<edr><edm>$1<\/edm> <eds>$3<\/eds><\/edr>/gs;
    $augText=~s/<edr><eds>([^<>]*?)<\/eds>([\,\. ]*?)<edm>([^<>]*?)<\/edm>([\, ]+)<suffix>([^<>]*?)<\/suffix><\/edr>/<edr><edm>$3<\/edm> <eds>$1<\/eds> <suffix>$5<\/suffix><\/edr>/gs;
    $augText=~s/<edr><eds>([^<>]*?)<\/eds>([\,\. ]*?)<suffix>([^<>]*?)<\/suffix>([\,\. ]*?)<edm>([^<>]*?)<\/edm><\/edr>/<edr><edm>$5<\/edm> <eds>$1<\/eds> <suffix>$3<\/suffix><\/edr>/gs;
    $augText=~s/<edr><eds>([^<>]*?)<\/eds>([\,\. ]*?)<edm>([^<>]*?)<\/edm>([\, ]+)<par>([^<>]*?)<\/par><\/edr>/<edr><edm>$3<\/edm> <par>$5<\/par> <eds>$1<\/eds><\/edr>/gs;
    $augText=~s/<edr><par>([^<>]*?)<\/par>([\,\. ]*?)<eds>([^<>]*?)<\/eds>,([ ]?)<edm>([^<>]*?)<\/edm><\/edr>/<edr><edm>$5<\/edm> <par>$1<\/par> <eds>$3<\/eds><\/edr>/gs;
    $augText=~s/<edr><par>([^<>]*?)<\/par>([\,\. ]*?)<eds>([^<>]*?)<\/eds>,([ ]?)<edm>([^<>]*?)<\/edm>([\, ]+)<suffix>([^<>]*?)<\/suffix><\/edr>/<edr> <edm>$5<\/edm> <par>$1<\/par> <eds>$3<\/eds> <suffix>$7<\/suffix><\/edr>/gs;
    $augText=~s/<edr><edm>([^<>]*?)<\/edm>([\,\. ]*?)<eds>([^<>]*?)<\/eds><\/edr>/<edr><edm>$1<\/edm> <eds>$3<\/eds><\/edr>/gs;
    $augText=~s/<edr><edm>([^<>]*?)<\/edm>([\,\. ]*?)<eds>([^<>]*?)<\/eds>([\, ]+)<suffix>([^<>]*?)<\/suffix><\/edr>/<edr><edm>$1<\/edm> <eds>$3<\/eds> <suffix>$5<\/suffix><\/edr>/gs;
    $augText=~s/<suffix>([^<>]*?)[\.]?<\/suffix>/<suffix>$1<\/suffix>/gs; #Remove . from Suffix
    $augText=~s/<suffix>(Jr|Sr)[\.]?<\/suffix>/<suffix>$1\.<\/suffix>/gs; #Remove . from Suffix
  }


  if($style eq "Chicago"){
    $augText=~s/\.<\/edm>\./\.<\/edm>/gs;
    $augText=~s/<edr><par>([^<>]*?)<\/par>([\,\. ]*?)<eds>([^<>]*?)<\/eds>([\,\. ]*?)<edm>([^<>]*?)<\/edm><\/edr>/<edr><edm>$5<\/edm> <par>$1<\/par> <eds>$3<\/eds><\/edr>/gs;
    $augText=~s/<edr><eds>([^<>]*?)<\/eds>([\,\. ]*?)<edm>([^<>]*?)<\/edm><\/edr>/<edr><edm>$3<\/edm> <eds>$1<\/eds><\/edr>/gs;
    $augText=~s/<edr><eds>([^<>]*?)<\/eds>([\,\. ]*?)<edm>([^<>]*?)<\/edm>([\, ]+)<suffix>([^<>]*?)<\/suffix><\/edr>/<edr><edm>$3<\/edm> <eds>$1<\/eds> <suffix>$5<\/suffix><\/edr>/gs;
    $augText=~s/<edr><eds>([^<>]*?)<\/eds>([\,\. ]*?)<edm>([^<>]*?)<\/edm>([\, ]+)<par>([^<>]*?)<\/par><\/edr>/<edr><edm>$3<\/edm> <par>$5<\/par> <eds>$1<\/eds><\/edr>/gs;
    $augText=~s/<edr><par>([^<>]*?)<\/par>([\,\. ]*?)<eds>([^<>]*?)<\/eds>,([ ]?)<edm>([^<>]*?)<\/edm><\/edr>/<edr><edm>$5<\/edm> <par>$1<\/par> <eds>$3<\/eds><\/edr>/gs;
    $augText=~s/<edr><par>([^<>]*?)<\/par>([\,\. ]*?)<eds>([^<>]*?)<\/eds>,([ ]?)<edm>([^<>]*?)<\/edm>([\, ]+)<suffix>([^<>]*?)<\/suffix><\/edr>/<edr> <edm>$5<\/edm> <par>$1<\/par> <eds>$3<\/eds> <suffix>$7<\/suffix><\/edr>/gs;
    $augText=~s/<edr><edm>([^<>]*?)<\/edm>([\,\. ]*?)<eds>([^<>]*?)<\/eds><\/edr>/<edr><edm>$1<\/edm> <eds>$3<\/eds><\/edr>/gs;
    $augText=~s/<edr><edm>([^<>]*?)<\/edm>([\,\. ]*?)<eds>([^<>]*?)<\/eds>([\, ]+)<suffix>([^<>]*?)<\/suffix><\/edr>/<edr><edm>$1<\/edm> <eds>$3<\/eds> <suffix>$5<\/suffix><\/edr>/gs;

     if($augText=~/<auedr>/){
       $augText=~s/<auedr><edr><edm>([^<>]*?)<\/edm>([\,\. ]*?)<par>([^<>]*?)<\/par>([\,\. ]*?)<eds>([^<>]*?)<\/eds><\/edr>/<auedr><edrX><par>$3<\/par>$4<eds>$5<\/eds>\, <edm>$1<\/edm><\/edrX>/gs;
       $augText=~s/<auedr><edr><eds>([^<>]*?)<\/eds>([\,\. ]*?)<edm>([^<>]*?)<\/edm><\/edr>/<auedr><edrX><eds>$1<\/eds>, <edm>$3<\/edm><\/edrX>/gs;
       $augText=~s/<auedr><edr><edm>([^<>]*?)<\/edm>([\,\. ]*?)<eds>([^<>]*?)<\/eds><\/edr>/<auedr><edrX><eds>$3<\/eds>, <edm>$1<\/edm><\/edrX>/gs;
       $augText=~s/^<edr><eds>([^<>]*?)<\/eds>([\,\. ]*?)<edm>([^<>]*?)<\/edm><\/edr>/<edrX><eds>$1<\/eds>, <edm>$3<\/edm><\/edrX>/gs;
       $augText=~s/^<edr><edm>([^<>]*?)<\/edm>([\,\. ]*?)<eds>([^<>]*?)<\/eds><\/edr>/<edrX><eds>$3<\/eds>, <edm>$1<\/edm><\/edrX>/gs;
       $augText=~s/<auedr><edr><edm>([^<>]*?)<\/edm>([\,\. ]*?)<eds>([^<>]*?)<\/eds><\/edr>/<auedr><edr><eds>$3<\/eds>\, <edm>$1<\/edm><\/edr>/gs;
       $augText=~s/<auedr><edr><par>([^<>]*?)<\/par>([\, ]+)<edm>([^<>]*?)<\/edm>([\,\. ]*?)<eds>([^<>]*?)<\/eds><\/edr>/<auedr><edr><eds>$5<\/eds>\, <par>$1<\/par> <edm>$3<\/edm><\/edr>/gs;
       $augText=~s/<auedr><edr><suffix>([^<>]*?)<\/suffix>([\, ]+)<edm>([^<>]*?)<\/edm>([\,\. ]*?)<eds>([^<>]*?)<\/eds><\/edr>/<auedr><edr><eds>$5<\/eds>\, <edm>$3<\/edm> <suffix>$1<\/suffix><\/edr>/gs;
     }

    $augText=~s/<edrX>/<edr>/gs;
    $augText=~s/<\/edrX>/<\/edr>/gs;
  }

  return $augText;
}

#========================================================================

sub EditorSeprate{
  my  $augText=shift;

  $augText=~s/<edr><eds>([aAuU]nd|u\.|U\.|\&|\&amp\;|\&[ ]?\&hellip\;|\&hellip\;|\.\.\.[ ]?\&|\.\.\.[ ]?[aAuU]nd) ([^<>]+?)<\/eds>/$1 <edr><eds>$2<\/eds>/gs;
  $augText=~s/<au><aus>([aAuU]nd|u\.|U\.|\&|\&amp\;|\&[ ]?\&hellip\;|\&hellip\;|\.\.\.[ ]?\&|\.\.\.[ ]?[aAuU]nd) ([^<>]+?)<\/aus>/$1 <au><aus>$2<\/aus>/gs;
  $augText=~s/<([\/]?)edrX>/<$1edr>/gs;
  while($augText=~s/<\/edr>([\,\;\.\/ ]*?)([aAuU]nd|u\.|U\.|\&|\&amp\;|\&[ ]?\&hellip\;|\&hellip\;|\.\.\.[ ]?\&|\.\.\.[ ]?[aAuU]nd)([\, ]*?)<edr>((?:(?!\n)(?!<edrg>)(?!<misc1>)(?!<bt>).)*)<\/edr>([\,\;\.\/ ]*?)([aAuU]nd|u\.|U\.|\&|\&amp\;|\&[ ]?\&hellip\;|\&hellip\;|\.\.\.[ ]?\&|\.\.\.[ ]?[aAuU]nd)([\, ]*?)<edr>/<\/edr>$1$3<edr>$4<\/edr>$5$6$7<au>/gs){}

  if($style eq "Basic" or $style eq "Chemistry" or $style eq "MPS" or $style eq "APS" or $style eq "Vancouver" or $style eq "ElsVancouver"){
    $augText=~s/<\/edr>([\,\.\/ ]*?)([aAuU]nd|u\.|U\.|\&|\&amp\;|\&[ ]?\&hellip\;|\&hellip\;|\.\.\.[ ]?\&|\.\.\.[ ]?[aAuU]nd)([\, ]*?)<edr>/<\/edr>\, <edr>/gs; #and und
    $augText=~s/<\/edr>([\,\;\/ ]*?)<edr>/<\/edr>\, <edr>/gs;
  }
  if($style eq "Basic" or $style eq "Chemistry"){
    $augText=authorEditorEtalEdit($augText, 'edr', ' et al');
    $augText=~s/<\/edr>\, \(([eE]ditor[s]?[\.]?|[Hh]erausgeber|[Ee]d[s]?[\.]?|[Hh]rsg[\.]?|[Hh]g[\.]?|red[\.]?)\)[\.]?/<\/edr> \($1\)/gs;
    $augText=~s/([Ii]n[\:\,\.]?) <edr>(.*?)<\/edr>$/$1 <edr>$2<\/edr> \(ed\)/gs;
    $augText=~s/([Ii]n[\:\,\.]?) <edr>(.*)<\/edr>$/$1 <edr>$2<\/edr> \(eds\)/gs;
  }
  if($style eq "Vancouver" or $style eq "ElsVancouver"){
    $augText=authorEditorEtalEdit($augText, 'edr', ' et al');
    $augText=~s/<\/edr>[\,]? \(([eE]ditor[s]?[\.]?|[Hh]erausgeber|[Ee]d[s]?[\.]?|[Hh]rsg[\.]?|[Hh]g[\.]?|red[\.]?)\)[\.]?/<\/edr>\, $1/gs;
    $augText=~s/<\/edr>[\,]? ([eE]ditor[s]?[\.]?|[Hh]erausgeber|[Ee]d[s]?[\.]?|[Hh]rsg[\.]?|[Hh]g[\.]?|red[\.]?)[\.]?/<\/edr>\, $1/gs;
    $augText=~s/([Ii]n[\:\,\.]?) <edr>(.*?)<\/edr>$/$1 <edr>$2<\/edr>\, editor/gs;
    $augText=~s/([Ii]n[\:\,\.]?) <edr>(.*)<\/edr>$/$1 <edr>$2<\/edr>\, editors/gs;
  }
  if($style eq "MPS"){
    $augText=authorEditorEtalEdit($augText, 'edr', ', et al.');
    $augText=~s/<\/edr>\, \(([eE]ditor[s]?[\.]?|[Hh]erausgeber|[Ee]d[s]?[\.]?|[Hh]rsg[\.]?|[Hh]g[\.]?|red[\.]?)\)[\.]?/<\/edr> \($1\)/gs;
     $augText=~s/([Ii]n[\:\,\.]?) <edr>(.*?)<\/edr>$/$1 <edr>$2<\/edr> \(ed\.\)/gs;
     $augText=~s/([Ii]n[\:\,\.]?) <edr>(.*)<\/edr>$/$1 <edr>$2<\/edr> \(eds\.\)/gs;
  }
  if($style eq "APS"){
    $augText=authorEditorEtalEdit($augText, 'edr', ' et al.');
    $augText=~s/<\/edr>\, \(([eE]ditor[s]?[\.]?|[Hh]erausgeber|[Ee]d[s]?[\.]?|[Hh]rsg[\.]?|[Hh]g[\.]?|red[\.]?)\)[\.]?/<\/edr> \($1\)/gs;
  }
  if($style eq "APA" or $style eq "ApaOrg" or $style eq "ElsAPA5"){

    $augText=~s/<\/edr>([\,\.\/ ]*?)([aAuU]nd|u\.|U\.|\&|\&amp\;|\&[ ]?\&hellip\;|\&hellip\;|\.\.\.[ ]?\&|\.\.\.[ ]?[aAuU]nd)([\, ]*?)<edr>/<\/edr>\, <edr>/s;
    $augText=~s/<\/edr>([\,\;\/ ]*?)<edr>/<\/edr>\, <edr>/gs;
    $augText=~s/<edr>(.*)<\/edr>([\,\;\/ ]*?)<edr>((?:(?!<[\/]?edr>).)*?)<\/edr>/<edr>$1<\/edr> \&amp\; <edr>$3<\/edr>/s;
    $augText=~s/<edr>(.*?)<\/edr>([\,\;\/ ]*?)<edr>((?:(?!<[\/]?edr>).)*?)<\/edr> \(/<edr>$1<\/edr> \&amp\; <edr>$3<\/edr> \(/s;
    $augText=~s/<edr>(.*?)<\/edr>([\,\;\/ ]*?)<edr>((?:(?!<[\/]?edr>).)*?)<\/edr> ([Hh]rsg|[Hh]g|[eE]ditor[s]?|[eE]d[s]?|[Hh]erausgeber)/<edr>$1<\/edr> \&amp\; <edr>$3<\/edr> $4/s;
    $augText=~s/<auedr>((?:(?!<auedr>)(?!<\/auedr>).)*)<\/edr> \&amp\; <edr>((?:(?!<auedr>)(?!<\/auedr>).)*)<\/auedr>/<auedr>$1<\/edr>\, \&amp\; <edr>$2<\/auedr>/s;
    $augText=~s/<\/edr>\, \(([eE]ditor[s]?[\.]?|[Hh]erausgeber|[Ee]d[s]?[\.]?|[Hh]rsg[\.]?|[Hh]g[\.]?|red[\.]?)\)[\.]?/<\/edr> \($1\)/s;
    $augText=~s/\(([eE]ditor[s]?[\.]?|[Hh]erausgeber|[Ee]d[s]?[\.]?|[Hh]rsg[\.]?|[Hh]g[\.]?|red[\.]?)\)<\/auedr>/\($1\)\.<\/auedr>/gs;
    $augText=~s/([Ii]n[\:\,\.]?) <edr>(.*?)<\/edr>$/$1 <edr>$2<\/edr> \(Ed\.\)/gs;
    $augText=~s/([Ii]n[\:\,\.]?) <edr>(.*)<\/edr>$/$1 <edr>$2<\/edr> \(Eds\.\)/gs;
  }
  if($style eq "ElsACS"){
    $augText=~s/<\/edr>([\,\;\.\/ ]*?)([aAuU]nd|u\.|U\.|\&|\&amp\;|\.\.\.[ ]?\&|\.\.\.[ ]?[aAuU]nd)([\, ]*?)<edr>/<\/edr>\; <edr>/gs;  #and und
    $augText=~s/<edr>(.*)<\/edr>([\,\;\/ ]*?)<edr>((?:(?!<[\/]?edr>).)*?)<\/edr>/<edr>$1<\/edr>\; <edr>$3<\/edr>/s;
    $augText=~s/<\/edr>\, \(([eE]ditor[s]?[\.]?|[Hh]erausgeber|[Ee]d[s]?[\.]?|[Hh]rsg[\.]?|[Hh]g[\.]?|red[\.]?)\)[\.]?/<\/edr>\, $1/s;
    $augText=~s/<\/edr> ([eE]ditor[s]?[\.]?|[Hh]erausgeber|[Ee]d[s]?[\.]?|[Hh]rsg[\.]?|[Hh]g[\.]?|red[\.]?)/<\/edr>\, $1/s;
  }
  if($style eq "Chicago"){
    $augText=~s/<\/edr>([\,\.\/ ]*?)([uU]nd|u\.|U\.|\.\.\.[ ]?\&|\.\.\.[ ]?[uU]nd)([\, ]*?)<edr>/<\/edr>\, und <edr>/gs; #and und
    $augText=~s/<\/edr>([\,\.\/ ]*?)([aA]nd|\&|\&amp\;|\.\.\.[ ]?\&|\.\.\.[ ]?[aA]nd)([\, ]*?)<edr>/<\/edr>\, and <edr>/gs; #and und
    $augText=~s/<edr>(.*)<\/edr>([\,\;\/ ]*?)<edr>((?:(?!<edr>)(?!<\/edr>).)*)<\/edr>([\s]*)$/<edr>$1<\/edr>\, and <edr>$3<\/edr>$4/gs;
    $augText=~s/<edr>(.*)<\/edr>([\,\;\/ ]*?)<edr>((?:(?!<edr>)(?!<\/edr>).)*)<\/edr>([\s]*)<\/auedr>([\s]*)$/<edr>$1<\/edr>\, and <edr>$3<\/edr>$4<\/auedr>$5/gs;
    $augText=~s/<edr>(.*)<\/edr>([\,\;\/ ]*?)<edr>((?:(?!<edr>)(?!<\/edr>).)*)<\/edr>([^<>]+)<\/auedr>$/<edr>$1<\/edr>\, and <edr>$3<\/edr>$4<\/auedr>/gs;
    $augText=~s/<edr>(.*)<\/edr>([\,\;\/ ]*?)<edr>((?:(?!<edr>)(?!<\/edr>).)*)<\/edr>([^<>]+?)$/<edr>$1<\/edr>\, and <edr>$3<\/edr>$4/gs;

    $augText=~s/<\/edr>([\,\;\/ ]*?)<edr>/<\/edr>\, <edr>/gs;
    $augText=~s/<\/edr>[\,\.\;]? ([eE]ditor[s]?[\.]?|[Hh]erausgeber|[Ee]d[s]?[\.]?|[Hh]rsg[\.]?|[Hh]g[\.]?|red[\.]?)/<\/edr>\, $1/gs;
    $augText=~s/([Ii]n[\:\,\.]?) <edr>(.*?)<\/edr>$/$1 <edr>$2<\/edr>\, ed\./gs;
    $augText=~s/([Ii]n[\:\,\.]?) <edr>(.*)<\/edr>$/$1 <edr>$2<\/edr>\, eds\./gs;
    $augText=~s/^<edr>(.*?)<\/edr>$/ed\. <edr>$1<\/edr>/gs;
    $augText=~s/^<edr>(.*)<\/edr>$/eds\. <edr>$1<\/edr>/gs;
    $augText=~s/^<edr>(.*)<\/edr>\, ([Hh]rsg|[Hh]g|[eE]ditor[s]?|[eE]d[s]?|[Hh]erausgeber) /$2\. <edr>$1<\/edr> /gs; 
    $augText=~s/^<edr>(.*)<\/edr>([\, ]+)et al/eds\. <edr>$1<\/edr>$2et al/gs;
  }
  return $augText;
}
#====================================================================================================================================================

sub JournalTitleEditings{
  my $FileText=shift; 
  my  %JNameHash=();
  $FileText=~s/\&lt\;pt\&gt\;/<pt>/gs;
  $FileText=~s/\&lt\;\/pt\&gt\;/<\/pt>/gs;
  #print $FileText;
  while($FileText=~/<pt>((?:(?!<[\/]?pt>).)*)<\/pt>/s){

    my $JTitle=$1;
    $TempJTitle=$JTitle;
    my $JTitleNoParen=$JTitle;
    $JTitle=~s/([\.\,])//g;
    $JTitleNoParen=~s/^(.+) \(([^<>\)\(]+?)\)$/$1/gs;
    $JNameHash{$JTitle}="";
    $JNameHash{$TempJTitle}="";
    $JNameHash{$JTitleNoParen}="";
    $JTitleNoParen=~s/\b([oO]n|[oO]f|[iI]n|[aA]nd|[fF]or|[tT]he)\b/\u$1\E/gs;
    $JNameHash{$JTitleNoParen}="";
    $JTitle=~s/\b([oO]n|[oO]f|[iI]n|[aA]nd|[fF]or|[tT]he)\b/\u$1\E/gs;
    $JNameHash{$JTitle}="";
    $JTitleNoParen=~s/\b([oO]n|[oO]f|[iI]n|[aA]nd|[fF]or|[tT]he)\b/\l$1\E/gs;
    $JNameHash{$JTitleNoParen}="";
    $JTitle=~s/\b([oO]n|[oO]f|[iI]n|[aA]nd|[fF]or|[tT]he)\b/\l$1\E/gs;
    $JNameHash{$JTitle}="";

    $FileText=~s/<pt>((?:(?!<[\/]?pt>).)*)<\/pt>/\&lt\;pt\&gt\;$1\&lt\;\/pt\&gt\;/os;
  }
  my $colName="";   #value should be 'abbr' or 'full'
  if($style eq "Basic" or $style eq "Chemistry" or $style eq "MPS" or $style eq "APS" or $style eq "Vancouver" or $style eq "ElsVancouver" or $style eq "ElsACS"){
    $colName='full'; #  Return abbr
  }
  elsif($style eq "APA" or $style eq "Chicago" or $style eq "ApaOrg" or $style eq "ElsAPA5"){
    $colName='abbr'; # Return full
  }
  #--------------------------------------------------------------------------------------------------------------------

  use ReferenceManager::getJName::getJournalInfo;
  #my $NameHashRef= new ReferenceManager::getJName::getJournalInfo();
  my $JNameHashRef=&ReferenceManager::getJName::getJournalInfo::main(\%JNameHash, $colName);#use Data::Dumper;print Dumper \%$JNameHashRef;exit;
  #my $JNameHashRef=$NameHashRef->getFullName(\%JNameHash, $colName);
  foreach my $hashVal (keys %$JNameHashRef){
    if($$JNameHashRef{$hashVal} ne "")
      {
	my $tepmHashval=$hashVal;
	my $JTitleNoParen=$hashVal;
	$JTitleNoParen=~s/^(.+) \(([^<>\)\(]+?)\)$/$1/gs;
	#\(([^<>\)\(])\)
	$tepmHashval=~s/ /\. /gs;

	$FileText=~s/\&lt\;pt\&gt\;\Q$tepmHashval\E\&lt\;\/pt\&gt\;/\&lt\;pt\&gt\;$$JNameHashRef{$hashVal}\&lt\;\/pt\&gt\;/gs;
	$FileText=~s/\&lt\;pt\&gt\;\Q$hashVal\E\&lt\;\/pt\&gt\;/\&lt\;pt\&gt\;$$JNameHashRef{$hashVal}\&lt\;\/pt\&gt\;/gs;
	$FileText=~s/\&lt\;pt\&gt\;\Q$JTitleNoParen\E \(([^<>\)\(]+?)\)\&lt\;\/pt\&gt\;/\&lt\;pt\&gt\;$$JNameHashRef{$JTitleNoParen}\&lt\;\/pt\&gt\;/gs;
	$FileText=~s/\&lt\;pt\&gt\;\Q$hashVal\E \(([^<>\)\(]+?)\)\&lt\;\/pt\&gt\;/\&lt\;pt\&gt\;$$JNameHashRef{"$hashVal ($1)"}\&lt\;\/pt\&gt\;/gs;

	$hashVal=~s/\b([oO]n|[oO]f|[iI]n|[aA]nd|[fF]or|[tT]he)\b/\u$1\E/gs;
	if(exists $$JNameHashRef{$hashVal}){
	  if($$JNameHashRef{$hashVal} ne ""){
	    $FileText=~s/\&lt\;pt\&gt\;\Q$hashVal\&lt\;\/pt\&gt\;/\&lt\;pt\&gt\;$$JNameHashRef{$hashVal}\&lt\;\/pt\&gt\;/gs;
	    $FileText=~s/\&lt\;pt\&gt\;\Q$hashVal\E \(([^<>\)\(]+?)\)\&lt\;\/pt\&gt\;/\&lt\;pt\&gt\;$$JNameHashRef{$hashVal}\&lt\;\/pt\&gt\;/gs;
	    my $temphashVal=$hashVal;
	    $temphashVal=~s/\b([oO]n|[oO]f|[iI]n|[aA]nd|[fF]or|[tT]he)\b/\l$1\E/gs;
	    $FileText=~s/\&lt\;pt\&gt\;\Q$temphashVal\&lt\;\/pt\&gt\;/\&lt\;pt\&gt\;$$JNameHashRef{$hashVal}\&lt\;\/pt\&gt\;/gs;
	    $FileText=~s/\&lt\;pt\&gt\;\Q$temphashVal\E \(([^<>\)\(]+?)\)\&lt\;\/pt\&gt\;/\&lt\;pt\&gt\;$$JNameHashRef{$hashVal}\&lt\;\/pt\&gt\;/gs;
	  }
	}
	$hashVal=~s/\b([oO]n|[oO]f|[iI]n|[aA]nd|[fF]or|[tT]he)\b/\l$1\E/gs;
	if(exists $$JNameHashRef{$hashVal}){
	  if($$JNameHashRef{$hashVal} ne ""){
	    $FileText=~s/\&lt\;pt\&gt\;\Q$hashVal\E \(([^<>\)\(]+?)\)\&lt\;\/pt\&gt\;/\&lt\;pt\&gt\;$$JNameHashRef{$hashVal}\&lt\;\/pt\&gt\;/gs;
	    $FileText=~s/\&lt\;pt\&gt\;\Q$hashVal\&lt\;\/pt\&gt\;/\&lt\;pt\&gt\;$$JNameHashRef{$hashVal}\&lt\;\/pt\&gt\;/gs;

	    my $temphashVal=$hashVal;
	    $temphashVal=~s/\b([oO]n|[oO]f|[iI]n|[aA]nd|[fF]or|[tT]he)\b/\u$1\E/gs;
	    $FileText=~s/\&lt\;pt\&gt\;\Q$temphashVal\E \(([^<>\)\(]+?)\)\&lt\;\/pt\&gt\;/\&lt\;pt\&gt\;$$JNameHashRef{$hashVal}\&lt\;\/pt\&gt\;/gs;
	    $FileText=~s/\&lt\;pt\&gt\;\Q$temphashVal\&lt\;\/pt\&gt\;/\&lt\;pt\&gt\;$$JNameHashRef{$hashVal}\&lt\;\/pt\&gt\;/gs;
	  }
	}

	$JTitleNoParen=~s/\b([oO]n|[oO]f|[iI]n|[aA]nd|[fF]or|[tT]he)\b/\u$1\E/gs;
	if(exists $$JNameHashRef{$JTitleNoParen}){
	  if($$JNameHashRef{$JTitleNoParen} ne ""){
	    $FileText=~s/\&lt\;pt\&gt\;\Q$JTitleNoParen\E \(([^<>\)\(]+?)\)\&lt\;\/pt\&gt\;/\&lt\;pt\&gt\;$$JNameHashRef{$JTitleNoParen}\&lt\;\/pt\&gt\;/gs;
	    $FileText=~s/\&lt\;pt\&gt\;\Q$JTitleNoParen\&lt\;\/pt\&gt\;/\&lt\;pt\&gt\;$$JNameHashRef{$JTitleNoParen}\&lt\;\/pt\&gt\;/gs;
	    my $tempJTitleNoParen=$JTitleNoParen;
	    $temphashVal=~s/\b([oO]n|[oO]f|[iI]n|[aA]nd|[fF]or|[tT]he)\b/\l$1\E/gs;
	    $FileText=~s/\&lt\;pt\&gt\;\Q$tempJTitleNoParen\E \(([^<>\)\(]+?)\)\&lt\;\/pt\&gt\;/\&lt\;pt\&gt\;$$JNameHashRef{$JTitleNoParen}\&lt\;\/pt\&gt\;/gs;
	    $FileText=~s/\&lt\;pt\&gt\;\Q$tempJTitleNoParen\&lt\;\/pt\&gt\;/\&lt\;pt\&gt\;$$JNameHashRef{$JTitleNoParen}\&lt\;\/pt\&gt\;/gs;
	  }
	}

	$JTitleNoParen=~s/\b([oO]n|[oO]f|[iI]n|[aA]nd|[fF]or|[tT]he)\b/\l$1\E/gs;
	if(exists $$JNameHashRef{$JTitleNoParen}){
	  if($$JNameHashRef{$JTitleNoParen} ne ""){
	    $FileText=~s/\&lt\;pt\&gt\;\Q$JTitleNoParen\E \(([^<>\)\(]+?)\)\&lt\;\/pt\&gt\;/\&lt\;pt\&gt\;$$JNameHashRef{$JTitleNoParen}\&lt\;\/pt\&gt\;/gs;
	    $FileText=~s/\&lt\;pt\&gt\;\Q$JTitleNoParen\&lt\;\/pt\&gt\;/\&lt\;pt\&gt\;$$JNameHashRef{$JTitleNoParen}\&lt\;\/pt\&gt\;/gs;
	    my $tempJTitleNoParen=$JTitleNoParen;
	    $temphashVal=~s/\b([oO]n|[oO]f|[iI]n|[aA]nd|[fF]or|[tT]he)\b/\u$1\E/gs;
	    $FileText=~s/\&lt\;pt\&gt\;\Q$tempJTitleNoParen\E \(([^<>\)\(]+?)\)\&lt\;\/pt\&gt\;/\&lt\;pt\&gt\;$$JNameHashRef{$JTitleNoParen}\&lt\;\/pt\&gt\;/gs;
	    $FileText=~s/\&lt\;pt\&gt\;\Q$tempJTitleNoParen\&lt\;\/pt\&gt\;/\&lt\;pt\&gt\;$$JNameHashRef{$JTitleNoParen}\&lt\;\/pt\&gt\;/gs;

	  }
	}
      }#If End
  }#Foreach End

  if($style eq "Basic" or $style eq "Chemistry" or $style eq "Vancouver" or  $style eq "ElsVancouver"){
    $FileText=~s/\&lt\;([\/]?)pt\&gt\;/<$1pt>/gs;
    while($FileText=~/<pt>((?:(?!<[\/]?pt>).)+)<\/pt>/s)
      {
	my $JTitle=$1;
	$JTitle=~s/([\.\,])//g;
	$JTitle=~s/ ([aAuU]nd|\&|\&amp\;|\&[ ]?\&hellip\;|\&hellip\;) / /gs; #and und
	$FileText=~s/<pt>((?:(?!<[\/]?pt>).)+)<\/pt>/\&lt\;pt\&gt\;$JTitle\&lt\;\/pt\&gt\;/os;
      }
    $FileText=~s/<([\/]?)pt>/\&lt\;$1pt\&gt\;/gs;
  }

  if($style eq "MPS" or $style eq "APS" or  $style eq "ElsACS"){
    $FileText=~s/\&lt\;pt\&gt\;/<pt>/gs;
    $FileText=~s/\&lt\;\/pt\&gt\;/<\/pt>/gs;
    while($FileText=~/<pt>((?:(?!<[\/]?pt>).)+)<\/pt>/s){
		my $JTitle=$1;
		my $JTitle1=$JTitle;
		my $JTitleNoParen=$JTitle;
		$JTitle1=~s/\.//gs;
		$JTitle1=~s/  / /gs;
		$JTitleNoParen=~s/^(.+) \(([^<>\)\(]+?)\)$/$1/gs;
		use ReferenceManager::getJName::getJAbbriwithdot;  #Abb Journal  => dot Abb Journal 
		my $JAbbrRef=&ReferenceManager::getJName::getJAbbriwithdot::main("dot");
		my $JAbbrRefdotCheck=&ReferenceManager::getJName::getJAbbriwithdot::main("nodot");
		#my $JAbbrRef=$NameHashRef->JAbbriwithdot("dot");
		#my $JAbbrRefdotCheck=$NameHashRef->JAbbriwithdot("nodot");
      if(exists $$JAbbrRef{$JTitle}){
	$FileText=~s/<pt>$JTitle<\/pt>/\&lt\;pt\&gt\;$$JAbbrRef{$JTitle}\&lt\;\/pt\&gt\;/gs;
      }elsif(exists $$JAbbrRefdotCheck{"$JTitle\."}){
	$FileText=~s/<pt>$JTitle<\/pt>/\&lt\;pt\&gt\;$JTitle\.\&lt\;\/pt\&gt\;/gs;
      }elsif(exists $$JAbbrRef{$JTitle1}){
	$FileText=~s/<pt>$JTitle<\/pt>/\&lt\;pt\&gt\;$$JAbbrRef{$JTitle1}\&lt\;\/pt\&gt\;/gs;
      }elsif(exists $$JAbbrRef{$JTitleNoParen}){
	$FileText=~s/<pt>$JTitle \(([^<>\)\(]+?)\)<\/pt>/\&lt\;pt\&gt\;$$JAbbrRef{$JTitleNoParen}\&lt\;\/pt\&gt\;/gs;
      }else{
	$FileText=~s/<pt>((?:(?!<[\/]?pt>).)+)<\/pt>/\&lt\;pt\&gt\;$1\&lt\;\/pt\&gt\;/os;
      }
    }
    $FileText=~s/<([\/]?)pt>/\&lt\;$1pt\&gt\;/gs;
  }


  return $FileText;
}
#================================================================================================================================
sub ArticleTitleEditings{
  my $FileText=shift; 
  #  print $FileText;exit;
  # if($style eq "Basic" or $style eq "Chemistry" or $style eq "Vancouver")
  #   {

  #   }
  return $FileText;
}

#================================================================================================================================
sub BookTitleEditing{
  my $FileText=shift;
  $FileText=~s/\&lt\;([\/]?)bt\&gt\;/<$1bt>/gs;
  if($style eq "Basic" || $style eq "Chemistry"){
    while($FileText=~/<bt>((?:(?!<[\/]?bt>).)*)<\/bt>/s){
      my $BTitle=$1;
      $BTitle=~s/^\&lt\;i\&gt\;((?:(?!\&lt\;[\/]?i\&gt\;).)*)\&lt\;\/i\&gt\;$/$1/gs;
      $BTitle=~s/\b[Vv]ol\b([\.]?) ([0-9]+)/vol $2/gs;
      $BTitle=~s/\b[Vv]ols\b([\.]?) ([0-9]+)/vols $2/gs;
      $BTitle=~s/\bVol\b/vol/gs;
      $BTitle=~s/\bVols\b/vols/gs;
      $FileText=~s/<bt>((?:(?!<[\/]?bt>).)*)<\/bt>/\&lt\;bt\&gt\;$BTitle\&lt\;\/bt\&gt\;/s;
    }
    $FileText=~s/<([\/]?)bt>/\&lt\;$1bt\&gt\;/gs;
  }

  if($style eq "Vancouver" or $style eq "ElsVancouver"){
    while($FileText=~/<bt>((?:(?!<[\/]?bt>).)*)<\/bt>/s){
      my $BTitle=$1;
      $BTitle=~s/^\&lt\;i\&gt\;((?:(?!\&lt\;[\/]?i\&gt\;).)*)\&lt\;\/i\&gt\;$/$1/gs;
      $BTitle=~s/\b[Vv]ol\b([\.]?) ([0-9]+)/Vol $2/gs;
      $BTitle=~s/\b[Vv]ols\b([\.]?) ([0-9]+)/Vols $2/gs;
      $FileText=~s/<bt>((?:(?!<[\/]?bt>).)*)<\/bt>/\&lt\;bt\&gt\;$BTitle\&lt\;\/bt\&gt\;/s;
    }
    $FileText=~s/<([\/]?)bt>/\&lt\;$1bt\&gt\;/gs;
  }

  if($style eq "MPS"){
    while($FileText=~/<bt>((?:(?!<[\/]?bt>).)*)<\/bt>/s){
      my $BTitle=$1;
      $BTitle=~s/^\&lt\;i\&gt\;((?:(?!\&lt\;[\/]?i\&gt\;).)*)\&lt\;\/i\&gt\;$/$1/gs;
      $BTitle=~s/\b[Bb]d\b([\.]?) ([0-9]+)/Bd\. $2/gs;
      $BTitle=~s/\b[Vv]ol\b([\.]?) ([0-9]+)/vol\. $2/gs;
      $BTitle=~s/\b[Vv]ols\b([\.]?) ([0-9]+)/vols\. $2/gs;
      $BTitle=~s/\bVol\b[\.]?/vol\./gs;
      $BTitle=~s/\bBd\b[\.]?/Bd\./gs;
      $BTitle=~s/\bVols\b[\.]?/vols\./gs;
      $BTitle=~s/\b(vol[s])[\.]+/$1\./gs;
      $BTitle=~s/\bEdition[s]?[\.]? ([0-9]+)/edn\. $1/gs;
      $BTitle=~s/\bAuflage[s]?[\.]? ([0-9]+)/Aufl\. $1/gs;
      $FileText=~s/<bt>((?:(?!<[\/]?bt>).)*)<\/bt>/\&lt\;bt\&gt\;$BTitle\&lt\;\/bt\&gt\;/s;
    }
  }
  $FileText=~s/<([\/]?)bt>/\&lt\;$1bt\&gt\;/gs;
  return $FileText;
}
#================================================================================================================================
sub PublisherNameEditing{
  my $FileText=shift;

  if($style eq "Basic" || $style eq "Chemistry")
    {
      $FileText=~s/\&lt\;([\/]?)pbl\&gt\;/<$1pbl>/gs;

      while($FileText=~/<pbl>((?:(?!<[\/]?pbl>).)*)<\/pbl>/s)
	{
	  my $PubName=$1;
	  if($PubName!~/Universti/)
	    {
	      $PubName=~s/ \b([Pp]ublisher[s]?|[Vv]erlag|[Pp]ress|Co\.)\b / /gs;
	      $PubName=~s/ \b([Pp]ublisher[s]?|[Vv]erlag|[Pp]ress|Co\.)\b/ /gs;
	      $PubName=~s/\b[Pp]ublisher[s]?\b//gs;
	      $PubName=~s/\-\b[Vv]erlag\b//gs;
	      $PubName=~s/\b[Vv]erlag\b//gs;
	      $PubName=~s/\b[Pp]ress\b//gs;
	      $PubName=~s/\bCo\.\b//gs;
	      $PubName=~s/  / /gs;
	      $PubName=~s/ $//gs;
	    }
	      # $PubName=~s/John Wiley and Sons//gs;
	  $FileText=~s/<pbl>((?:(?!<[\/]?pbl>).)*)<\/pbl>/\&lt\;pbl\&gt\;$PubName\&lt\;\/pbl\&gt\;/s;
	}
      $FileText=~s/<([\/]?)bt>/\&lt\;$1bt\&gt\;/gs;
    }

  return $FileText;
}

#================================================================================================================
sub EditPageRange{
  my $FileText=shift;

  if($style eq "Vancouver" or $style eq "ElsVancouver")
      {
  	$$FileText=AbriviatePageRange($$FileText);
      }elsif($style eq "Basic" or $style eq "Chemistry" or $style eq "MPS" or $style eq "APS" or $style eq "APA" or $style eq "Chicago" or $style eq "ApaOrg" or $style eq "ElsAPA5" or $style eq "ElsACS")
      {
  	$$FileText=ExpandPagerange($$FileText);
      }
  return $$FileText;
}

#===================================================================================================================
sub puncEditings
  {
    my $FileText=shift;
    my %regx = ReferenceManager::ReferenceRegex::new();

    if($style=~/^(Basic)$/ || $style=~/^(Chemistry)$/ )
      {


	$FileText=&deleteInFromTitle($FileText);

	$FileText=~s/\&lt\;suffix\&gt\;([Jj]r|[Ss]r|1st|2nd|3rd|4th|II|III)\.\&lt\;\/suffix\&gt\;&lt\;\/edr\&gt\;/\&lt\;suffix\&gt\;$1\&lt\;\/suffix\&gt\;&lt\;\/edr\&gt\;\./gs;
	$FileText=~s/<edrg>([eE]dited [bB]y|Ed[s]?\. [bB]y|[eE]dit[eo]r[s]?\:|[Ee]d[s]?[\:]) \&lt\;edr\&gt\;/<edrg>eds \&lt\;edr\&gt\;/gs;

	$FileText=~s/<edrg>([eE]d[s]?[\.]?) [bB]y \&lt\;edr\&gt\;/<edrg>$1 \&lt\;edr\&gt\;/gs;
	$FileText=~s/<edrg>([Hh]rsg|Hg|[Ee]d|[Ee]ds)[\. ]+\&lt\;edr\&gt\;((?:(?!<[\/]?edrg>)(?!<[\/]?bib)(?!<[\/]?aug>).)*)\&lt\;\/edr\&gt\;<\/edrg>/<edrg>\&lt\;edr\&gt\;$2\&lt\;\/edr\&gt\; \($1\)<\/edrg>/gs;

	$FileText=~s/<(vg|iss)>\/ /\/ <$1>/gs;
	$FileText=~s/[\(\[]([Hh]rsg|[Hh]g)[\.]?[\)\]][\.]?<\/edrg>/\(Hrsg\)<\/edrg>/gs;
	$FileText=~s/[\(\[]([Ee]d|[Ee]ds)[\.]?[\)\]][\.]?<\/edrg>/\(\l$1\E\)<\/edrg>/gs;
	$FileText=~s/([Hh]rsg|[Hh]g)[\.]?<\/edrg>/\(Hrsg\)<\/edrg>/gs;
	$FileText=~s/([Ee]d|[Ee]ds)[\.]?<\/edrg>/\(\l$1\E\)<\/edrg>/gs;
	$FileText=~s/[\(\[]?[Ee]ditors[\)\]\.]*<\/edrg>/\(eds\)<\/edrg>/gs;
	$FileText=~s/[\(\[]?[Ee]ditor[\)\]\.]*<\/edrg>/\(ed\)<\/edrg>/gs;
	$FileText=~s/[\(\[]?[Hh]erausgeber[\.\)\]]*<\/edrg>/\(Hrsg\)<\/edrg>/gs;

	$FileText=~s/([\.\,\'\"\:>]) ([Ii]n[\:\.\,]*) <ia>([^<>]+?)[\.\,]* [\(]?([Hh]erausgeber|[Hh]rsg|[Hh]g)[\.\)]*<\/ia>/$1 $2 <ia>$3 (Hrsg)<\/ia>/gs;
	$FileText=~s/([\.\,\'\"\:>]) <ia>([^<>]+?)[\.\,]? [\(]?$regx{editorSuffix}([\.\)]*)<\/ia>/$1 <ia>$2<\/ia>/gs;
	#$FileText=~s/([\.\,\'\"\:>]) ([Ii]n[\:\.\,]*) <ia>([^<>]+?)[\.\,]? [\(]?$regx{editorSuffix}([\.\)]*)<\/ia>/$1 <ia>$3 ($4)<\/ia>/gs;

	$FileText=~s/<pgg>\&lt\;pg\&gt\;([0-9\-]+)\&lt\;\/pg\&gt\; ([pSP]+)<\/pgg>/<pgg>$2 \&lt\;pg\&gt\;$1\&lt\;\/pg\&gt\;<\/pgg>/gs;
	$FileText=~s/<pgg>([pP]ages[\.\: ]*)/<pgg>pp /gs;
	$FileText=~s/<pgg>([pP]age[\.\: ]*)/<pgg>p /gs;
	$FileText=~s/<pgg>P[\.\:]?/<pgg>p/gs;
	$FileText=~s/<pgg>PP[\.\:]?/<pgg>pp/gs;
	$FileText=~s/<pgg>([pSP]+)[\.\:]?/<pgg>$1/gs;

	$FileText=~s/\&lt\;pgg\&gt;([pSP]+)\./\&lt\;pgg\&gt;$1/gs;
	$FileText=~s/<issg>([0-9\.]+) ([Ss]uppl)\./<issg>$1 $2/gs;
	$FileText=~s/<pgg>([pSP]+)\&lt\;pg\&gt\;/<pgg>$1 \&lt\;pg\&gt\;/gs;

	$FileText=~s/<(pblg|cnyg)>\(\&lt\;(pbl|cny)\&gt\;/\(<$1>\&lt\;$2\&gt\;/gs;
	$FileText=~s/\&lt\;\/(pbl|cny)\&gt\;\)<\/(pblg|cnyg)>/\&lt\;\/$1\&gt\;<\/$2>\)/gs;

	$FileText=~s/<vg>([Vv]ol[s]?)[\.]?[ ]?\&lt\;v\&gt\;/<vg>\l$1\E \&lt\;v\&gt\;/gs;
	$FileText=~s/<vg>[Vv]olume[ ]?\&lt\;v\&gt\;/<vg>vol \&lt\;v\&gt\;/gs;
	$FileText=~s/<vg>[Vv]olumes[ ]?\&lt\;v\&gt\;/<vg>vols \&lt\;v\&gt\;/gs;
	$FileText=~s/<ia>([^<>]*?)<\/ia>\. \(<yrg>/<ia>$1<\/ia> \(<yrg>/gs; #Remove dot
	$FileText=~s/ \(([0-9]+[.]? [JFMASOND][a-z]+)<\/aug> <yrg>\&lt\;yr\&gt\;([1-2][0987][0-9][0-9][a-z]?)\&lt\;\/yr&gt\;<\/yrg>\)/<\/aug> \(<yrg>$1 \&lt\;yr\&gt\;$2\&lt\;\/yr&gt\;<\/yrg>\)/gs;
	$FileText=~s/\; \(([^<>\(\)]+?)<\/aug> <yrg>\&lt\;yr\&gt\;([1-2][0987][0-9][0-9][a-z]?)\&lt\;\/yr&gt\;<\/yrg>\)/<\/aug>\; \(<yrg>$1 \&lt\;yr\&gt\;$2\&lt\;\/yr&gt\;<\/yrg>\)/gs;
	$FileText=~s/\&lt\;\/yr\&gt\;\)<\/yrg>/\&lt\;\/yr\&gt\;<\/yrg>\)/gs;

	$FileText=~s/ [eE]d[n]?[\.]?<\/edng>/ edn<\/edng>/gs; #for editions
	$FileText=~s/ [Ee]dition[s]?[\.]?<\/edng>/ edn<\/edng>/gs; #for editions
	$FileText=~s/ [Aa]uflage[s]?[\.]?<\/edng>/ Aufl<\/edng>/gs; #for editions


	$FileText=&deleteVolIssuePrefix($FileText);
	$FileText=&deletePagePrefix($FileText);

	$FileText=~s/<\/pgg> <ptg>([iI]n[\:\.\,]?)\s*\&lt\;pt\&gt\;/<\/pgg> <ptg>\&lt\;pt\&gt\;/gs;
	$FileText=~s/ \&lt\;\/pg\&gt\;<\/pgg>\)/\&lt\;\/pg\&gt\;<\/pgg>\)/gs;
	$FileText=~s/<pgg>([^<>\(\)]+?)\)<\/pgg>/<pgg>$1<\/pgg>\)/gs;
	$FileText=~s/\.$regx{allRightQuote}\&lt\;\/(at|bt|misc1)\&gt\;<\/\2g>/$1\&lt\;\/$2\&gt\;<\/$2g>/gs;

	$FileText=~s/<pgg>Pp[\.]?[ ]?\&lt\;pg\&gt\;/<pgg>pp \&lt\;pg\&gt\;/gs;
	$FileText=~s/&lt;\/yr&gt;\.<\/yrg>/&lt;\/yr&gt;<\/yrg>/gs;

	$FileText=~s/\&lt\;\/v\&gt\;\. <\/vg>([\,\.\;\:])/\&lt\;\/v\&gt\;<\/vg>$1/gs;
	$FileText=~s/\&lt\;at\&gt\;\&lt\;i\&gt\;((?:(?!\&lt\;i\&gt\;)(?!\&lt\;\/i\&gt\;)(?!<atg>)(?!<\/atg>).)*)\&lt\;\/i\&gt\;([\?\.\!]?)\&lt\;\/at\&gt\;/\&lt\;at\&gt\;$1$2\&lt\;\/at\&gt\;/gs;
	$FileText=~s/\.\&lt\;\/auf\&gt\;\&lt\;\/au\&gt\;\./\.\&lt\;\/auf\&gt\;\&lt\;\/au\&gt\;/gs;
	$FileText=~s/<btg>[iI]n[\.\,\: ]+\&lt\;bt\&gt\;((?:(?!<[\/]?btg>)(?!<[\/]?bib)(?!<[\/]?edrg>).)*)<\/btg>([\.\;\, ]+)<edrg>\&lt\;edr\&gt\;/<btg>\&lt\;bt\&gt\;$1<\/btg>$2<edrg>\&lt\;edr\&gt\;/gs;
	$FileText=~s/<btg>[iI]n[\.\,\: ]+“\&lt\;bt\&gt\;((?:(?!<[\/]?btg>)(?!<[\/]?bib)(?!<[\/]?edrg>).)*)\&lt\;\/bt&gt;<\/btg>”/<btg>\&lt\;bt\&gt\;$1\&lt\;\/bt&gt;<\/btg>/gs;
	#<btg>In: &lt;bt&gt;The Multiple Ligament Injured Knee. A Practical Guide to Management&lt;/bt&gt;</btg>. <edng>&lt;edn&gt;Second&lt;/edn&gt; edn</edng>. <edr
	$FileText=~s/<btg>[iI]n[\.\,\: ]+\&lt\;bt\&gt\;((?:(?!<[\/]?btg>)(?!<[\/]?bib)(?!<[\/]?edrg>).)*)\&lt\;\/bt\&gt\;<\/btg>((?:(?!<[\/]?btg>)(?!<[\/]?bib)(?!<[\/]?edrg>).)*)<edrg>/<btg>\&lt\;bt\&gt\;$1\&lt\;\/bt\&gt\;<\/btg>$2<edrg>/gs;

	$FileText=~s/<cnyg>\&lt\;cny\&gt\;([Ff]rankfurt a\. M)\&lt\;\/cny\&gt\;<\/cnyg>/<cnyg>\&lt\;cny\&gt\;$1\.\&lt\;\/cny\&gt\;<\/cnyg>/gs;
	$FileText=~s/<atg>\&quot\;((?:(?!<[\/]?atg>)(?!<[\/]?bib).)*?)([\,\.]?)\&quot\;<\/atg>/<atg>$1<\/atg>$2/gs;
	$FileText=~s/<atg>"((?:(?!<[\/]?atg>)(?!<[\/]?bib).)*?)([\,\.]?)"<\/atg>/<atg>$1<\/atg>$2/gs;
	$FileText=~s/<atg>((?:(?!<[\/]?atg>)(?!<[\/]?bib).)*?)([\,\.]?)<\/atg>/<atg>$1<\/atg>$2/gs;

	#for adding pp or p in pagegroup
	$FileText=addEditPagePrefix(\$FileText, "nodot");

	$FileText=~s/\&lt\;\/([a-z]+)\&gt\; <\/([a-z]+)> /\&lt\;\/$1\&gt\;<\/$2> /gs;
	$FileText=~s/\s+<\/([a-z0-9]+)> /<\/$1> /gs;
	$FileText=~s/([\.\;\:\,\?]+) <\/([a-z0-9]+)>([\.\;\:\,\?])/$1<\/$2>$3/gs;

      }

    if($style=~/^(Vancouver)$/)
      {

	$FileText=&deleteInFromTitle($FileText);
	$FileText=~s/&lt;\/([a-z0-9]+)\&gt\;([\.\:\,]+)<\/\1g>/&lt;\/$1\&gt\;<\/$1g>$2/gs;

	$FileText=~s/\&lt\;suffix\&gt\;([Jj]r|[Ss]r|1st|2nd|3rd|4th|II|III)\.\&lt\;\/suffix\&gt\;&lt\;\/edr\&gt\;/\&lt\;suffix\&gt\;$1\&lt\;\/suffix\&gt\;&lt\;\/edr\&gt\;\./gs;
	$FileText=~s/<edrg>([eE]dited [bB]y|Ed[s]?\. [bB]y|[eE]dit[eo]r[s]?\:|[Ee]d[s]?[\:]) \&lt\;edr\&gt\;/<edrg>editor \&lt\;edr\&gt\;/gs;

	$FileText=~s/<edrg>([eE]d[s]?[\.]?) [bB]y \&lt\;edr\&gt\;/<edrg>$1 \&lt\;edr\&gt\;/gs;
	$FileText=~s/<edrg>([Hh]rsg|Hg|[Ee]ds|[eE]ditor[s]?|[Hh]erausgeber)[\. ]+\&lt\;edr\&gt\;((?:(?!<[\/]?edrg>)(?!<[\/]?bib)(?!<[\/]?aug>).)*)\&lt\;\/edr\&gt\;<\/edrg>/<edrg>\&lt\;edr\&gt\;$2\&lt\;\/edr\&gt\; \($1\)<\/edrg>/gs;
	$FileText=~s/<(vg|iss)>\/ /\/ <$1>/gs;
	$FileText=~s/([\.\, ]+)[\(\[]([Hh]rsg|[Hh]g|[Hh]erausgeber)[\.]?[\)\]]/, Herausgeber/gs; #by ketan kadu
	$FileText=~s/([\.\, ]+)[\(\[]([eE]d|[Ee]ditor)[\.]?[\)\]]/, editor/gs;
	$FileText=~s/([\.\, ]+)[\(\[]([eE]ds|[Ee]ditors)[\.]?[\)\]]/, editors/gs;

	$FileText=~s/\b([Ee]ditor[\.]?|[Ee]d[\.]?)<\/edrg>/editor<\/edrg>/gs;
	$FileText=~s/\b([Ee]ditors[\.]?|[Ee]ds[\.]?)<\/edrg>/editors<\/edrg>/gs;
	$FileText=~s/\b([Hh]rsg|[Hh]g)[\.]?<\/edrg>/Herausgeber<\/edrg>/gs;
	$FileText=~s/\b[Hh]erausgeber[\.]?<\/edrg>/Herausgeber<\/edrg>/gs;

	$FileText=~s/([\.\,\'\"\:>]) ([Ii]n[\:\.\,]*) <ia>([^<>]+?)[\.\,]* [\(]?([Hh]erausgeber|[Hh]rsg|[Hh]g)[\.\)]*<\/ia>/$1 $2 <ia>$3\, Herausgeber<\/ia>/gs;
	$FileText=~s/([\.\,\'\"\:>]) ([Ii]n[\:\.\,]*) <ia>([^<>]+?)[\.\,]* [\(]?$regx{editorSuffix}([\.\)]*)<\/ia>/$1 $2 <ia>$3\, editor<\/ia>/gs;
	#$FileText=~s/([\.\,\'\"\:>]) <ia>([^<>]+?)[\.\,]* [\(]?$regx{editorSuffix}([\.\)]*)<\/ia>/$1 <ia>$2<\/ia>/gs;

	$FileText=~s/<pgg>\&lt\;pg\&gt\;([0-9\-]+)\&lt\;\/pg\&gt\; ([pSP]+)<\/pgg>/<pgg>$2 \&lt\;pg\&gt\;$1\&lt\;\/pg\&gt\;<\/pgg>/gs;
	$FileText=~s/<pgg>([pP]ages[\.\: ]*)/<pgg>pp\. /gs;
	$FileText=~s/<pgg>([pP]age[\.\: ]*)/<pgg>p\. /gs;
	$FileText=~s/<pgg>P[\.\:]?/<pgg>p\./gs;
	$FileText=~s/<pgg>PP[\.\:]?/<pgg>pp\./gs;
	$FileText=~s/<pgg>([pSP]+)[\.\:]?([^a-z])/<pgg>$1\.$2/gs;
	$FileText=~s/\&lt\;pgg\&gt;([pSP]+)\b[\.]?/\&lt\;pgg\&gt;$1\./gs;
	$FileText=~s/<issg>([0-9\.]+) ([Ss]uppl)\./<issg>$1 $2/gs;
	$FileText=~s/<pgg>([pSP]+)\&lt\;pg\&gt\;/<pgg>$1 \&lt\;pg\&gt\;/gs;

	$FileText=~s/<(pblg|cnyg)>\(\&lt\;(pbl|cny)\&gt\;/\(<$1>\&lt\;$2\&gt\;/gs;
	$FileText=~s/\&lt\;\/(pbl|cny)\&gt\;\)<\/(pblg|cnyg)>/\&lt\;\/$1\&gt\;<\/$2>\)/gs;

	$FileText=~s/<vg>([Vv]ol[s]?)[\.]?[ ]?\&lt\;v\&gt\;/<vg>\u$1\E\. \&lt\;v\&gt\;/gs;
	$FileText=~s/<vg>[Vv]olume[ ]?\&lt\;v\&gt\;/<vg>Vol. \&lt\;v\&gt\;/gs;
	$FileText=~s/<vg>[Vv]olumes[ ]?\&lt\;v\&gt\;/<vg>Vols. \&lt\;v\&gt\;/gs;

	$FileText=~s/ \(([0-9]+[.]? [JFMASOND][a-z]+)<\/aug> <yrg>\&lt\;yr\&gt\;([1-2][0987][0-9][0-9][a-z]?)\&lt\;\/yr&gt\;<\/yrg>\)/<\/aug> \(<yrg>$1 \&lt\;yr\&gt\;$2\&lt\;\/yr&gt\;<\/yrg>\)/gs;
	$FileText=~s/\; \(([^<>\(\)]+?)<\/aug> <yrg>\&lt\;yr\&gt\;([1-2][0987][0-9][0-9][a-z]?)\&lt\;\/yr&gt\;<\/yrg>\)/<\/aug>\; \(<yrg>$1 \&lt\;yr\&gt\;$2\&lt\;\/yr&gt\;<\/yrg>\)/gs;
	$FileText=~s/\&lt\;\/yr\&gt\;\)<\/yrg>/\&lt\;\/yr\&gt\;<\/yrg>\)/gs;

	$FileText=~s/[\.]? [eE]d[n]?[\.]?<\/edng>/ ed\.<\/edng>/gs; #for editions
	$FileText=~s/[\.]? [Ee]dition[s]?[\.]?<\/edng>/ ed\.<\/edng>/gs; #for editions
	$FileText=~s/[\.]? [Aa]uflage[s]?[\.]?<\/edng>/\. Aufl\.<\/edng>/gs; #*****\. for editions

	$FileText=&deleteVolIssuePrefix($FileText);
	$FileText=&deletePagePrefix($FileText);

	$FileText=~s/<\/pgg> <ptg>([iI]n[\:\.\,]?)\s*\&lt\;pt\&gt\;/<\/pgg> <ptg>\&lt\;pt\&gt\;/gs;
	$FileText=~s/ \&lt\;\/pg\&gt\;<\/pgg>\)/\&lt\;\/pg\&gt\;<\/pgg>\)/gs;
	$FileText=~s/<pgg>([^<>\(\)]+?)\)<\/pgg>/<pgg>$1<\/pgg>\)/gs;

	$FileText=~s/<pgg>Pp[\.]?[ ]?\&lt\;pg\&gt\;/<pgg>pp\. \&lt\;pg\&gt\;/gs;
	$FileText=~s/&lt;\/yr&gt;\.<\/yrg>/&lt;\/yr&gt;<\/yrg>/gs;

	$FileText=~s/\&lt\;\/v\&gt\;\. <\/vg>([\,\.\;\:])/\&lt\;\/v\&gt\;<\/vg>$1/gs;
	$FileText=~s/\&lt\;at\&gt\;\&lt\;i\&gt\;((?:(?!\&lt\;i\&gt\;)(?!\&lt\;\/i\&gt\;)(?!<atg>)(?!<\/atg>).)*)\&lt\;\/i\&gt\;([\?\.\!]?)\&lt\;\/at\&gt\;/\&lt\;at\&gt\;$1$2\&lt\;\/at\&gt\;/gs;
	$FileText=~s/\.\&lt\;\/auf\&gt\;\&lt\;\/au\&gt\;\./\.\&lt\;\/auf\&gt\;\&lt\;\/au\&gt\;/gs;
	$FileText=~s/<btg>[iI]n[\.\,\: ]+\&lt\;bt\&gt\;((?:(?!<[\/]?btg>)(?!<[\/]?bib)(?!<[\/]?edrg>).)*)<\/btg>([\.\;\, ]+)<edrg>\&lt\;edr\&gt\;/<btg>\&lt\;bt\&gt\;$1<\/btg>$2<edrg>\&lt\;edr\&gt\;/gs;
	$FileText=~s/<btg>[iI]n[\.\,\: ]+“\&lt\;bt\&gt\;((?:(?!<[\/]?btg>)(?!<[\/]?bib)(?!<[\/]?edrg>).)*)\&lt\;\/bt&gt;<\/btg>”/<btg>\&lt\;bt\&gt\;$1\&lt\;\/bt&gt;<\/btg>/gs;

	$FileText=~s/<cnyg>\&lt\;cny\&gt\;([Ff]rankfurt a\. M)\&lt\;\/cny\&gt\;<\/cnyg>/<cnyg>\&lt\;cny\&gt\;$1\.\&lt\;\/cny\&gt\;<\/cnyg>/gs;
	$FileText=~s/<vg>[vV]ol\. \&lt\;v&gt\;([0-9]+)([^a-zA-Z0-9\.\,\;\"\:\(\)\[\]\@\$\%\&\*\!\~\+\=\?\<\>\/]+)([0-9]+)\&lt\;\/v\&gt\;<\/vg>/<vg>Vols\. \&lt\;v&gt\;$1$2$3\&lt\;\/v\&gt\;<\/vg>/gs;
	#$FileText=~s/<atg>\&quot\;((?:(?!<[\/]?atg>)(?!<[\/]?bib).)*?)([\,\.]?)\&quot\;<\/atg>/<atg>$1<\/atg>$2/gs;
	#$FileText=~s/<atg>"((?:(?!<[\/]?atg>)(?!<[\/]?bib).)*?)([\,\.]?)"<\/atg>/<atg>$1<\/atg>$2/gs;
	#$FileText=~s/<atg>((?:(?!<[\/]?atg>)(?!<[\/]?bib).)*?)([\,\.]?)<\/atg>/<atg>$1<\/atg>$2/gs;

	$FileText=addEditPagePrefix(\$FileText, "withdot");

	$FileText=~s/\&lt\;\/([a-z]+)\&gt\; <\/([a-z]+)> /\&lt\;\/$1\&gt\;<\/$2> /gs;
	$FileText=~s/\s+<\/([a-z0-9]+)> /<\/$1> /gs;
	$FileText=~s/([\.\;\:\,\?]+) <\/([a-z0-9]+)>([\.\;\:\,\?])/$1<\/$2>$3/gs;

      }

    if($style=~/^(Chicago)$/)
      {
	$FileText=&deleteInFromTitle($FileText);
	$FileText=~s/<ia>In[\:\.]? ([^<>]+?)([\,\.]?) ([\(]?)$regx{editorSuffix}([\)]?)<\/ia>/<ia>$1<\/ia>/gs;

	$FileText=~s/<edrg>([eE]dited [bB]y|Ed[s]?\. [bB]y|[eE]dit[eo]r[s]?\:|[Ee]d[s]?[\:]) \&lt\;edr\&gt\;/<edrg>eds \&lt\;edr\&gt\;/gs;
	$FileText=~s/<edrg>([eE]d[s]?[\.]?) [bB]y \&lt\;edr\&gt\;/<edrg>$1 \&lt\;edr\&gt\;/gs;
	$FileText=~s/<edrg>([Hh]rsg|Hg|[Ee]d|[Ee]ds)[\. ]+\&lt\;edr\&gt\;((?:(?!<[\/]?edrg>)(?!<[\/]?bib)(?!<[\/]?aug>).)*)\&lt\;\/edr\&gt\;<\/edrg>/<edrg>\&lt\;edr\&gt\;$2\&lt\;\/edr\&gt\; $1<\/edrg>/gs;

	$FileText=~s/<(vg|iss)>\/ /\/ <$1>/gs;
	$FileText=~s/<pgg>\&lt\;pg\&gt\;([0-9\-]+)\&lt\;\/pg\&gt\; ([pSP]+)<\/pgg>/<pgg>$2 \&lt\;pg\&gt\;$1\&lt\;\/pg\&gt\;<\/pgg>/gs;

	$FileText=~s/[\(\[]([Hh]rsg|[Hh]g)[\.]?[\)\]][\.]?<\/edrg>/Hrsg\.<\/edrg>/gs;
	$FileText=~s/[\(\[]([Ee]d|[Ee]ds)[\.]?[\)\]][\.]?<\/edrg>/\l$1\E\.<\/edrg>/gs;
	$FileText=~s/([Hh]rsg|[Hh]g)[\.]?<\/edrg>/Hrsg\.<\/edrg>/gs;
	$FileText=~s/([Ee]d|[Ee]ds)[\.]?<\/edrg>/\l$1\E\.<\/edrg>/gs;
	$FileText=~s/[\(\[]?[Ee]ditors[\]\)\.]*<\/edrg>/eds\.<\/edrg>/gs;
	$FileText=~s/[\(\[]?[Ee]ditor[\]\)\.]*<\/edrg>/ed\.<\/edrg>/gs;
	$FileText=~s/[\(\[]?[Hh]erausgeber[\]\.\)]*<\/edrg>/Hrsg\.<\/edrg>/gs;
	$FileText=~s/\.\.<\/edrg>/\.<\/edrg>/gs;

	# $FileText=~s/([\.\,\'\"\:>]) ([Ii]n[\:\.\,]?) <ia>([^<>]+?)[\.\,]? [\(]?$regx{editorSuffix}([\.\)]*)<\/ia>/$1 <ia>$3<\/ia>/gs;
	# $FileText=~s/([\.\,\'\"\:>]) <ia>([^<>]+?)[\.\,]? [\(]?$regx{editorSuffix}([\.\)]*)<\/ia>/$1 <ia>$2<\/ia>/gs;

	$FileText=~s/([\.\,\'\"\:>]) ([Ii]n[\:\.\,]*) <ia>([^<>]+?)[\.\,]* [\(]?([Hh]erausgeber|[Hh]rsg|[Hh]g)[\.\)]*<\/ia>/$1 $2 <ia>$3 Hrsg<\/ia>/gs;
	$FileText=~s/([\.\,\'\"\:>]) ([Ii]n[\:\.\,]*) <ia>([^<>]+?)[\.\,]? [\(]?$regx{editorSuffix}([\.\)]*)<\/ia>/$1 <ia>$3 $4<\/ia>/gs;

	$FileText=~s/<(pblg|cnyg)>\(\&lt\;(pbl|cny)\&gt\;/\(<$1>\&lt\;$2\&gt\;/gs;
	$FileText=~s/\&lt\;\/(pbl|cny)\&gt\;\)<\/(pblg|cnyg)>/\&lt\;\/$1\&gt\;<\/$2>\)/gs;

	$FileText=~s/ [eE]d[n]?[\.]?<\/edng>/ ed\.<\/edng>/gs; #for editions
	$FileText=~s/ [Ee]dition[s]?[\.]?<\/edng>/ ed\.<\/edng>/gs; #for editions
	$FileText=~s/ [Aa]uflage[s]?[\.]?<\/edng>/ Aufl\.<\/edng>/gs; #for editions

	$FileText=~s/<pgg>\&lt\;pg\&gt\;([0-9\-]+)\&lt\;\/pg\&gt\; ([pSP]+)<\/pgg>/<pgg>$2 \&lt\;pg\&gt\;$1\&lt\;\/pg\&gt\;<\/pgg>/gs;
	$FileText=~s/<pgg>([pP]ages[\.\: ]*)/<pgg>/gs;
	$FileText=~s/<pgg>([pP]age[\.\: ]*)/<pgg>/gs;
	$FileText=~s/<pgg>P[\.\:]?/<pgg>/gs;
	$FileText=~s/<pgg>PP[\.\:]?/<pgg>/gs;
	$FileText=~s/<pgg>([pSP]+)[\.\:]?[ ]?/<pgg>/gs;

	$FileText=~s/\&lt\;pgg\&gt;([pSP]+)[\.]?[ ]?/\&lt\;pgg\&gt;/gs;
	$FileText=~s/<issg>([0-9\.]+) ([Ss]uppl)[\.]?/<issg>$1 $2/gs;
	$FileText=~s/<pgg>([pSP]+)\&lt\;pg\&gt\;/<pgg>$1 \&lt\;pg\&gt\;/gs;

	$FileText=~s/<(pblg|cnyg)>\(\&lt\;(pbl|cny)\&gt\;/\(<$1>\&lt\;$2\&gt\;/gs;
	$FileText=~s/\&lt\;\/(pbl|cny)\&gt\;\)<\/(pblg|cnyg)>/\&lt\;\/$1\&gt\;<\/$2>\)/gs;

	$FileText=&deleteVolIssuePrefix($FileText);
	$FileText=&deletePagePrefix($FileText);

	$FileText=~s/<vg>([B]d[s]?)[\.]?[ ]?\&lt\;v\&gt\;/<vg>\u$1\E\. \&lt\;v\&gt\;/gs;
	$FileText=~s/<vg>([Vv]ol[s]?)[\.]?[ ]?\&lt\;v\&gt\;/<vg>\l$1\E\. \&lt\;v\&gt\;/gs;
	$FileText=~s/<vg>[Vv]olume[ ]?\&lt\;v\&gt\;/<vg>vol\. \&lt\;v\&gt\;/gs;
	$FileText=~s/<vg>[Vv]olumes[ ]?\&lt\;v\&gt\;/<vg>vols\. \&lt\;v\&gt\;/gs;

	$FileText=~s/ \(([0-9]+[.]? [JFMASOND][a-z]+)<\/aug> <yrg>\&lt\;yr\&gt\;([1-2][0987][0-9][0-9][a-z]?)\&lt\;\/yr&gt\;<\/yrg>\)/<\/aug> \(<yrg>$1 \&lt\;yr\&gt\;$2\&lt\;\/yr&gt\;<\/yrg>\)/gs;
	$FileText=~s/\; \(([^<>\(\)]+?)<\/aug> <yrg>\&lt\;yr\&gt\;([1-2][0987][0-9][0-9][a-z]?)\&lt\;\/yr&gt\;<\/yrg>\)/<\/aug>\; \(<yrg>$1 \&lt\;yr\&gt\;$2\&lt\;\/yr&gt\;<\/yrg>\)/gs;
	$FileText=~s/\&lt\;\/yr\&gt\;\)<\/yrg>/\&lt\;\/yr\&gt\;<\/yrg>\)/gs;


	$FileText=~s/<\/pgg> <ptg>([iI]n[\:\.\,]?)\s*\&lt\;pt\&gt\;/<\/pgg> <ptg>\&lt\;pt\&gt\;/gs;
	$FileText=~s/\&lt\;i\&gt\;(et al[\.]?)\&lt\;\/i\&gt\;/$1/gs;
	$FileText=~s/ \&lt\;\/pg\&gt\;<\/pgg>\)/\&lt\;\/pg\&gt\;<\/pgg>\)/gs;
	$FileText=~s/<pgg>([^<>\(\)]+?)\)<\/pgg>/<pgg>$1<\/pgg>\)/gs;

	$FileText=~s/<pgg>Pp[\.]?[ ]?\&lt\;pg\&gt\;/<pgg>pp\. \&lt\;pg\&gt\;/gs;
	$FileText=~s/&lt;\/yr&gt;\.<\/yrg>/&lt;\/yr&gt;<\/yrg>/gs;
	$FileText=~s/\&lt\;\/v\&gt\;\. <\/vg>([\,\.\;\:])/\&lt\;\/v\&gt\;<\/vg>$1/gs;
	$FileText=~s/\&lt\;at\&gt\;\&lt\;i\&gt\;((?:(?!\&lt\;i\&gt\;)(?!\&lt\;\/i\&gt\;)(?!<atg>)(?!<\/atg>).)*)\&lt\;\/i\&gt\;([\?\.\!]?)\&lt\;\/at\&gt\;/\&lt\;at\&gt\;$1$2\&lt\;\/at\&gt\;/gs;

	$FileText=~s/<edrg>\&lt\;i\&gt\;([Ii]n[\:\,\.]?)\&lt\;\/i\&gt\;([\:\,\. ]*)\&lt\;edr\&gt\;\&lt\;/<edrg>\&lt\;edr\&gt\;\&lt\;/gs;
	$FileText=~s/<edrg>([Ii]n[\:\,\. ]*)\&lt\;edr\&gt\;\&lt\;/<edrg>\&lt\;edr\&gt\;\&lt\;/gs;
	$FileText=~s/<edrg>((?:(?!<edrg>)(?!<\/edrg>).)*)$regx{editorSuffix}([\.]?)<\/edrg>/<edrg>$2$3 $1<\/edrg>/gs;
	$FileText=~s/<edrg>((?:(?!<edrg>)(?!<\/edrg>).)*)\($regx{editorSuffix}([\.]?)\)<\/edrg>/<edrg>$2$3 $1<\/edrg>/gs;

	$FileText=~s/<edrg>$regx{editorSuffix}([\. ]+)([Ii]n[\:\,\. ]*)\&lt\;edr\&gt\;\&lt\;/<edrg>$1$2\&lt\;edr\&gt\;\&lt\;/gs;
	$FileText=~s/<edrg>$regx{editorSuffix}([\. ]+)\&lt\;i\&gt\;([Ii]n[\:\,\.]?)\&lt\;\/i\&gt\;([\:\,\. ]*)\&lt\;edr\&gt\;\&lt\;/<edrg>$1$2\&lt\;edr\&gt\;\&lt\;/gs;
	$FileText=~s/\.\&lt\;\/auf\&gt\;\&lt\;\/au\&gt\;\./\.\&lt\;\/auf\&gt\;\&lt\;\/au\&gt\;/gs;
	$FileText=~s/\&lt\;\/([a-z]+)\&gt\; <\/([a-z]+)> /\&lt\;\/$1\&gt\;<\/$2> /gs;

	$FileText=~s/<btg>[iI]n[\.\,\: ]+\&lt\;bt\&gt\;((?:(?!<[\/]?btg>)(?!<[\/]?bib)(?!<[\/]?edrg>).)*)<\/btg>([\.\;\, ]+)<edrg>\&lt\;edr\&gt\;/<btg>\&lt\;bt\&gt\;$1<\/btg>$2<edrg>\&lt\;edr\&gt\;/gs;
	$FileText=~s/<btg>[iI]n[\.\,\: ]+“\&lt\;bt\&gt\;((?:(?!<[\/]?btg>)(?!<[\/]?bib)(?!<[\/]?edrg>).)*)\&lt\;\/bt&gt;<\/btg>”/<btg>\&lt\;bt\&gt\;$1\&lt\;\/bt&gt;<\/btg>/gs;
	$FileText=~s/<btg>[iI]n[\.\,\: ]+\&lt\;bt\&gt\;/<btg>\&lt\;bt\&gt\;/gs;

	$FileText=~s/<cnyg>\&lt\;cny\&gt\;([Ff]rankfurt a\. M)[\.]?\&lt\;\/cny\&gt\;[\.]?<\/cnyg>/<cnyg>\&lt\;cny\&gt\;$1\&lt\;\/cny\&gt\;<\/cnyg>/gs;

	$FileText=~s/<atg>\&quot\;((?:(?!<[\/]?atg>)(?!<[\/]?bib).)*?)([\,\.]?)\&quot\;<\/atg>/<atg>$1<\/atg>$2/gs;
	$FileText=~s/<atg>"((?:(?!<[\/]?atg>)(?!<[\/]?bib).)*?)([\,\.]?)"<\/atg>/<atg>$1<\/atg>$2/gs;
	$FileText=~s/<atg>((?:(?!<[\/]?atg>)(?!<[\/]?bib).)*?)([\,\.]?)<\/atg>/<atg>$1<\/atg>$2/gs;

	$FileText=~s/<vg>vol\. \&lt\;v&gt\;([0-9]+)([^a-zA-Z0-9\.\,\;\"\:\(\)\[\]\@\$\%\&\*\!\~\+\=\?\<\>\/]+)([0-9]+)\&lt\;\/v\&gt\;<\/vg>/<vg>vols\. \&lt\;v&gt\;$1$2$3\&lt\;\/v\&gt\;<\/vg>/gs;
	# $FileText=~s/\, $regx{editorSuffix} $regx{year}\)<\/edrg>/\, $1 $2<\/edrg>\)/gs;

	$FileText=~s/\&lt\;\/edr\&gt\;\.<\/edrg>/\&lt\;\/edr\&gt\;<\/edrg>\./gs;

	#&lt;/edr&gt;, </edrg>)
	$FileText=~s/&lt\;\/([a-z0-9]+)&gt\;([\.\:\,]+) <\/\1g>([\,\.\:\;\)])/&lt\;\/$1&gt\;<\/$1g>$2$3/gs;

	$FileText=~s/\&lt\;\/([a-z]+)\&gt\; <\/([a-z]+)> /\&lt\;\/$1\&gt\;<\/$2> /gs;
	$FileText=~s/\s+<\/([a-z0-9]+)> /<\/$1> /gs;
	$FileText=~s/([\.\;\:\,\?]+) <\/([a-z0-9]+)>([\.\;\:\,\?\)])/$1<\/$2>$3/gs;
      }	

    if($style=~/^(APA)$/)
      {
	$FileText=&deleteInFromTitle($FileText);

	$FileText=~s/<edrg>([eE]dited [bB]y|Ed[s]?\. [bB]y|[eE]dit[eo]r[s]?\:|[Ee]d[s]?[\:]) \&lt\;edr\&gt\;/<edrg>eds \&lt\;edr\&gt\;/gs;
	$FileText=~s/<edrg>([eE]d[s]?[\.]?) [bB]y \&lt\;edr\&gt\;/<edrg>$1 \&lt\;edr\&gt\;/gs;
	$FileText=~s/<edrg>([Hh]rsg|[Ee]d|[Ee]ds)[\. ]+\&lt\;edr\&gt\;((?:(?!<[\/]?edrg>)(?!<[\/]?bib)(?!<[\/]?aug>).)*)\&lt\;\/edr\&gt\;<\/edrg>/<edrg>\&lt\;edr\&gt\;$2\&lt\;\/edr\&gt\; \($1\.\)<\/edrg>/gs;

	$FileText=~s/<(vg|iss)>\/ /\/ <$1>/gs;
	$FileText=~s/[\[\(]([Hh]rsg|[Hh]g)[\]\)]/\(Hrsg\.\)/gs;
	$FileText=~s/<pgg>\&lt\;pg\&gt\;([0-9\-]+)\&lt\;\/pg\&gt\; ([pSP]+)<\/pgg>/<pgg>$2 \&lt\;pg\&gt\;$1\&lt\;\/pg\&gt\;<\/pgg>/gs;
	$FileText=~s/<pgg>([pP]ages[\.\: ]*)/<pgg>pp\. /gs;
	$FileText=~s/<pgg>([pP]age[\.\: ]*)/<pgg>p\. /gs;
	$FileText=~s/<pgg>P[\.\:]?/<pgg>p\./gs;
	$FileText=~s/<pgg>PP[\.\:]?/<pgg>pp\./gs;
	$FileText=~s/<pgg>([SPp]+)[\.\:]? /<pgg>$1\. /gs;
	$FileText=~s/\&lt\;pgg\&gt;([SPp]+) /<pgg>$1\. /gs;
	$FileText=~s/<issg>([0-9\.]+) ([Ss]uppl) /<issg>$1 $2\./gs;
	$FileText=~s/<pgg>([pSP]+)\&lt\;pg\&gt\;/<pgg>$1 \&lt\;pg\&gt\;/gs;

	$FileText=~s/[\(\[]([Hh]rsg|[Hh]g)[\.]?[\)\]][\.]?<\/edrg>/\(Hrsg\.\)<\/edrg>/gs;
	$FileText=~s/[\(\[]([Ee]d|[Ee]ds)[\.]?[\)\]][\.]?<\/edrg>/\(\u$1\E\.\)<\/edrg>/gs;
	$FileText=~s/([Hh]rsg|[Hh]g)[\.]?<\/edrg>/\(Hrsg\.\)<\/edrg>/gs;
	$FileText=~s/([Ee]d|[Ee]ds)[\.]?<\/edrg>/\(\u$1\E\.\)<\/edrg>/gs;
	$FileText=~s/[\(\[]?[Ee]ditors[\]\)\.]*<\/edrg>/\(Eds\.\)<\/edrg>/gs;
	$FileText=~s/[\(\[]?[Ee]ditor[\]\)\.]*<\/edrg>/\(Ed\.\)<\/edrg>/gs;
	$FileText=~s/[\(\[]?[Hh]erausgeber[\.\)]*<\/edrg>/\(Hrsg\.\)<\/edrg>/gs;
	$FileText=~s/\.\)<\/edrg>\. /\.\)<\/edrg>\, /gs;

	$FileText=~s/([\.\,\'\"\:>]) ([Ii]n[\:\.\,]*) <ia>([^<>]+?)[\.\,]* [\(]?([Hh]erausgeber|[Hh]rsg|[Hh]g)[\.\)]*<\/ia>/$1 $2 <ia>$3 (Hrsg)<\/ia>/gs;
	$FileText=~s/([\.\,\'\"\:>]) ([Ii]n[\:\.\,]*) <ia>([^<>]+?)[\.\,]? [\(]?$regx{editorSuffix}([\.\)]*)<\/ia>/$1 <ia>$3 ($4)<\/ia>/gs;
	# $FileText=~s/([\.\,\'\"\:>]) ([Ii]n[\:\.\,]?) <ia>([^<>]+?)[\.\,]? [\(]?$regx{editorSuffix}([\.\)]*)<\/ia>/$1 <ia>$3<\/ia>/gs;
	# $FileText=~s/([\.\,\'\"\:>]) <ia>([^<>]+?)[\.\,]? [\(]?$regx{editorSuffix}([\.\)]*)<\/ia>/$1 <ia>$2<\/ia>/gs;

	$FileText=~s/<(pblg|cnyg)>\(\&lt\;(pbl|cny)\&gt\;/\(<$1>\&lt\;$2\&gt\;/gs;
	$FileText=~s/\&lt\;\/(pbl|cny)\&gt\;\)<\/(pblg|cnyg)>/\&lt\;\/$1\&gt\;<\/$2>\)/gs;

	$FileText=~s/ [eE]d[n]?[\.]?<\/edng>/ edn\.<\/edng>/gs; #for editions
	$FileText=~s/ [Ee]dition[s]?[\.]?<\/edng>/ edn\.<\/edng>/gs; #for editions
	$FileText=~s/ [Aa]uflage[s]?[\.]?<\/edng>/ Aufl\.<\/edng>/gs; #for editions


	$FileText=&deleteVolIssuePrefix($FileText);
	$FileText=&deletePagePrefix($FileText);

	$FileText=~s/<vg>([B]d[s]?)[\.]?[ ]?\&lt\;v\&gt\;/<vg>\u$1\E\. \&lt\;v\&gt\;/gs;
	$FileText=~s/<vg>([Vv]ol[s]?)[\.]?[ ]?\&lt\;v\&gt\;/<vg>\u$1\E\. \&lt\;v\&gt\;/gs;
	$FileText=~s/<vg>[Vv]olume[ ]?\&lt\;v\&gt\;/<vg>Vol\. \&lt\;v\&gt\;/gs;
	$FileText=~s/<vg>[Vv]olumes[ ]?\&lt\;v\&gt\;/<vg>Vols\. \&lt\;v\&gt\;/gs;

	$FileText=~s/ \(([0-9]+[.]? [JFMASOND][a-z]+)<\/aug> <yrg>\&lt\;yr\&gt\;([1-2][0987][0-9][0-9][a-z]?)\&lt\;\/yr&gt\;<\/yrg>\)/<\/aug> \(<yrg>$1 \&lt\;yr\&gt\;$2\&lt\;\/yr&gt\;<\/yrg>\)/gs;
	$FileText=~s/\; \(([^<>\(\)]+?)<\/aug> <yrg>\&lt\;yr\&gt\;([1-2][0987][0-9][0-9][a-z]?)\&lt\;\/yr&gt\;<\/yrg>\)/<\/aug>\; \(<yrg>$1 \&lt\;yr\&gt\;$2\&lt\;\/yr&gt\;<\/yrg>\)/gs;
	$FileText=~s/\&lt\;\/yr\&gt\;\)<\/yrg>/\&lt\;\/yr\&gt\;<\/yrg>\)/gs;

	$FileText=~s/<\/pgg> <ptg>([iI]n[\:\.\,]?)\s*\&lt\;pt\&gt\;/<\/pgg> <ptg>\&lt\;pt\&gt\;/gs;
	$FileText=~s/\&lt\;i\&gt\;(et al[\.]?)\&lt\;\/i\&gt\;/$1/gs;
	$FileText=~s/ \&lt\;\/pg\&gt\;<\/pgg>\)/\&lt\;\/pg\&gt\;<\/pgg>\)/gs;
	$FileText=~s/<pgg>([^<>\(\)]+?)\)<\/pgg>/<pgg>$1<\/pgg>\)/gs;

	$FileText=~s/<pgg>Pp[\.]?[ ]?\&lt\;pg\&gt\;/<pgg>pp\. \&lt\;pg\&gt\;/gs;
	#$FileText=~s/\.<\/yrg>/<\/yrg>/gs;
	$FileText=~s/&lt;\/yr&gt;\.<\/yrg>/&lt;\/yr&gt;<\/yrg>/gs;
	$FileText=~s/\&lt\;\/v\&gt\;\. <\/vg>([\,\.\;\:])/\&lt\;\/v\&gt\;<\/vg>$1/gs;
	$FileText=~s/\&lt\;at\&gt\;\&lt\;i\&gt\;((?:(?!\&lt\;i\&gt\;)(?!\&lt\;\/i\&gt\;)(?!<atg>)(?!<\/atg>).)*)\&lt\;\/i\&gt\;([\?\.\!]?)\&lt\;\/at\&gt\;/\&lt\;at\&gt\;$1$2\&lt\;\/at\&gt\;/gs;
	$FileText=~s/\.\&lt\;\/auf\&gt\;\&lt\;\/au\&gt\;\./\.\&lt\;\/auf\&gt\;\&lt\;\/au\&gt\;/gs;
	$FileText=~s/\&lt\;\/([a-z]+)\&gt\; <\/([a-z]+)> /\&lt\;\/$1\&gt\;<\/$2> /gs;
	$FileText=~s/<btg>[iI]n[\.\,\: ]+\&lt\;bt\&gt\;((?:(?!<[\/]?btg>)(?!<[\/]?bib)(?!<[\/]?edrg>).)*)<\/btg>([\.\;\, ]+)<edrg>\&lt\;edr\&gt\;/<btg>\&lt\;bt\&gt\;$1<\/btg>$2<edrg>\&lt\;edr\&gt\;/gs;
	$FileText=~s/<btg>[iI]n[\.\,\: ]+“\&lt\;bt\&gt\;((?:(?!<[\/]?btg>)(?!<[\/]?bib)(?!<[\/]?edrg>).)*)\&lt\;\/bt&gt;<\/btg>”/<btg>\&lt\;bt\&gt\;$1\&lt\;\/bt&gt;<\/btg>/gs;
	$FileText=~s/<cnyg>\&lt\;cny\&gt\;([Ff]rankfurt a\. M)\&lt\;\/cny\&gt\;<\/cnyg>/<cnyg>\&lt\;cny\&gt\;$1\.\&lt\;\/cny\&gt\;<\/cnyg>/gs;

	$FileText=~s/<atg>\&quot\;((?:(?!<[\/]?atg>)(?!<[\/]?bib).)*?)([\,\.]?)\&quot\;<\/atg>/<atg>$1<\/atg>$2/gs;
	$FileText=~s/<atg>"((?:(?!<[\/]?atg>)(?!<[\/]?bib).)*?)([\,\.]?)"<\/atg>/<atg>$1<\/atg>$2/gs;
	$FileText=~s/<atg>((?:(?!<[\/]?atg>)(?!<[\/]?bib).)*?)([\,\.]?)<\/atg>/<atg>$1<\/atg>$2/gs;

	$FileText=addEditPagePrefix(\$FileText, "withdot");

	$FileText=~s/<vg>[vV]ol\. \&lt\;v&gt\;([0-9]+)([^a-zA-Z0-9\.\,\;\"\:\(\)\[\]\@\$\%\&\*\!\~\+\=\?\<\>\/]+)([0-9]+)\&lt\;\/v\&gt\;<\/vg>/<vg>Vols\. \&lt\;v&gt\;$1$2$3\&lt\;\/v\&gt\;<\/vg>/gs;
	$FileText=~s/\&lt\;\/([a-z]+)\&gt\; <\/([a-z]+)> /\&lt\;\/$1\&gt\;<\/$2> /gs;
	$FileText=~s/\s+<\/([a-z0-9]+)> /<\/$1> /gs;
	$FileText=~s/([\.\;\:\,\?]+) <\/([a-z0-9]+)>([\.\;\:\,\?])/$1<\/$2>$3/gs;

      }	


    if($style=~/^(ApaOrg)$/)
      {
	$FileText=~s/(\&gt\;[\,\. ]+| )$regx{and}([\,]?) $regx{etal}([\.\,\;\:]?)<\/(aug|edrg|ia)>/$1$4$5<\/$6>/gs;
  
	$FileText=~s/<btg>([Ii]n[\:\. ]+)\&lt\;bt\&gt\;((?:(?!<[\/]?bib)(?!<[\/]?aug>).)*?)<edrg>$regx{editorSuffix}([\.\, ]+)&lt;edr&gt;/<btg>\&lt\;bt\&gt\;$2<edrg>$3$4&lt;edr&gt;/gs;
	$FileText=~s/<btg>([Ii]n[\:\. ]+)\&lt\;bt\&gt\;((?:(?!<[\/]?bib)(?!<[\/]?aug>).)*?)<edrg>&lt;edr&gt;/<btg>\&lt\;bt\&gt\;$2<edrg>&lt;edr&gt;/gs;
	$FileText=~s/<edrg>([eE]dited by|[eE]dit[eo]r[s]?:) \&lt\;edr\&gt\;/<edrg>eds \&lt\;edr\&gt\;/gs;
	$FileText=~s/<edrg>([eE]d[s]?[\.]?) by \&lt\;edr\&gt\;/<edrg>$1 \&lt\;edr\&gt\;/gs;
	$FileText=~s/<edrg>([Hh]rsg|[Ee]d|[Ee]ds)[\. ]+\&lt\;edr\&gt\;((?:(?!<[\/]?edrg>)(?!<[\/]?bib)(?!<[\/]?aug>).)*)\&lt\;\/edr\&gt\;<\/edrg>/<edrg>\&lt\;edr\&gt\;$2\&lt\;\/edr\&gt\; \($1\.\)<\/edrg>/gs;
	$FileText=~s/<edrg>([eE]d[s]?[\.]?) by \&lt\;edr\&gt\;/<edrg>$1 \&lt\;edr\&gt\;/gs;

	$FileText=~s/<(vg|iss)>\/ /\/ <$1>/gs;
	$FileText=~s/\(([Hh]rsg|[Hh]g)\)/\(Hrsg\.\)/gs;
	$FileText=~s/<pgg>\&lt\;pg\&gt\;([0-9\-]+)\&lt\;\/pg\&gt\; ([pSP]+)<\/pgg>/<pgg>$2 \&lt\;pg\&gt\;$1\&lt\;\/pg\&gt\;<\/pgg>/gs;
	$FileText=~s/<pgg>([pP]ages[\.\: ]*)/<pgg>pp\. /gs;
	$FileText=~s/<pgg>([pP]age[\.\: ]*)/<pgg>p\. /gs;
	$FileText=~s/<pgg>P[\.\:]?/<pgg>p\./gs;
	$FileText=~s/<pgg>PP[\.\:]?/<pgg>pp\./gs;
	$FileText=~s/<pgg>([SPp]+)[\.\:]? /<pgg>$1\. /gs;
	$FileText=~s/\&lt\;pgg\&gt;([SPp]+) /<pgg>$1\. /gs;
	$FileText=~s/<issg>([0-9\.]+) ([Ss]uppl) /<issg>$1 $2\./gs;
	$FileText=~s/<pgg>([pSP]+)\&lt\;pg\&gt\;/<pgg>$1 \&lt\;pg\&gt\;/gs;

	$FileText=~s/[\(\[]([Hh]rsg|[Hh]g)[\.]?[\]\)][\.]?<\/edrg>/\(Hrsg\.\)<\/edrg>/gs;
	$FileText=~s/[\(\[]([Ee]d|[Ee]ds)[\.]?[\]\)][\.]?<\/edrg>/\(\u$1\E\.\)<\/edrg>/gs;
	$FileText=~s/([Hh]rsg|[Hh]g)[\.]?<\/edrg>/\(Hrsg\.\)<\/edrg>/gs;
	$FileText=~s/([Ee]d|[Ee]ds)[\.]?<\/edrg>/\(\u$1\E\.\)<\/edrg>/gs;
	$FileText=~s/[\(\[]?[Ee]ditors[\]\)\.]*<\/edrg>/\(Eds\.\)<\/edrg>/gs;
	$FileText=~s/[\(\[]?[Ee]ditor[\]\)\.]*<\/edrg>/\(Ed\.\)<\/edrg>/gs;
	$FileText=~s/[\(\[]?[Hh]erausgeber[\]\)\.]*<\/edrg>/\(Hrsg\.\)<\/edrg>/gs;
	$FileText=~s/<(pblg|cnyg)>\(\&lt\;(pbl|cny)\&gt\;/\(<$1>\&lt\;$2\&gt\;/gs;
	$FileText=~s/\&lt\;\/(pbl|cny)\&gt\;\)<\/(pblg|cnyg)>/\&lt\;\/$1\&gt\;<\/$2>\)/gs;


	$FileText=~s/ [eE]d[n]?[\.]?<\/edng>/ ed\.<\/edng>/gs; #for editions
	$FileText=~s/ [Ee]dition[s]?[\.]?<\/edng>/ ed\.<\/edng>/gs; #for editions
	$FileText=~s/ [Aa]uflage[s]?[\.]?<\/edng>/ Aufl\.<\/edng>/gs; #for editions

	$FileText=&deleteVolIssuePrefix($FileText);
	$FileText=&deletePagePrefix($FileText);

	$FileText=~s/<vg>([B]d[s]?)[\.]?[ ]?\&lt\;v\&gt\;/<vg>\u$1\E\. \&lt\;v\&gt\;/gs;
	$FileText=~s/<vg>([Vv]ol[s]?)[\.]?[ ]?\&lt\;v\&gt\;/<vg>\u$1\E\. \&lt\;v\&gt\;/gs;
	$FileText=~s/<vg>[Vv]olume[ ]?\&lt\;v\&gt\;/<vg>Vol\. \&lt\;v\&gt\;/gs;
	$FileText=~s/<vg>[Vv]olumes[ ]?\&lt\;v\&gt\;/<vg>Vols\. \&lt\;v\&gt\;/gs;

	$FileText=~s/ \(([0-9]+[.]? [JFMASOND][a-z]+)<\/aug> <yrg>\&lt\;yr\&gt\;([1-2][0987][0-9][0-9][a-z]?)\&lt\;\/yr&gt\;<\/yrg>\)/<\/aug> \(<yrg>$1 \&lt\;yr\&gt\;$2\&lt\;\/yr&gt\;<\/yrg>\)/gs;
	$FileText=~s/\; \(([^<>\(\)]+?)<\/aug> <yrg>\&lt\;yr\&gt\;([1-2][0987][0-9][0-9][a-z]?)\&lt\;\/yr&gt\;<\/yrg>\)/<\/aug>\; \(<yrg>$1 \&lt\;yr\&gt\;$2\&lt\;\/yr&gt\;<\/yrg>\)/gs;
	$FileText=~s/\&lt\;\/yr\&gt\;\)<\/yrg>/\&lt\;\/yr\&gt\;<\/yrg>\)/gs;

	$FileText=~s/<\/pgg> <ptg>([iI]n[\:\.\,]?)\s*\&lt\;pt\&gt\;/<\/pgg> <ptg>\&lt\;pt\&gt\;/gs;
	$FileText=~s/\&lt\;i\&gt\;(et al[\.]?)\&lt\;\/i\&gt\;/$1/gs;
	$FileText=~s/ \&lt\;\/pg\&gt\;<\/pgg>\)/\&lt\;\/pg\&gt\;<\/pgg>\)/gs;
	#$FileText=~s/\)<\/pgg>/<\/pgg>/gs;
	$FileText=~s/<pgg>([^<>\(\)]+?)\)<\/pgg>/<pgg>$1<\/pgg>\)/gs;

	$FileText=~s/<pgg>Pp[\.]?[ ]?\&lt\;pg\&gt\;/<pgg>pp\. \&lt\;pg\&gt\;/gs;
	#$FileText=~s/\.<\/yrg>/<\/yrg>/gs;
	$FileText=~s/&lt;\/yr&gt;\.<\/yrg>/&lt;\/yr&gt;<\/yrg>/gs;

	$FileText=~s/\&lt\;\/v\&gt\;\. <\/vg>([\,\.\;\:])/\&lt\;\/v\&gt\;<\/vg>$1/gs;
	$FileText=~s/\&lt\;at\&gt\;\&lt\;i\&gt\;((?:(?!\&lt\;i\&gt\;)(?!\&lt\;\/i\&gt\;)(?!<atg>)(?!<\/atg>).)*)\&lt\;\/i\&gt\;([\?\.\!]?)\&lt\;\/at\&gt\;/\&lt\;at\&gt\;$1$2\&lt\;\/at\&gt\;/gs;
	$FileText=~s/\.\&lt\;\/auf\&gt\;\&lt\;\/au\&gt\;\./\.\&lt\;\/auf\&gt\;\&lt\;\/au\&gt\;/gs;
	$FileText=~s/\&lt\;\/([a-z]+)\&gt\; <\/([a-z]+)> /\&lt\;\/$1\&gt\;<\/$2> /gs;
	$FileText=~s/<btg>[iI]n[\.\,\: ]+\&lt\;bt\&gt\;((?:(?!<[\/]?btg>)(?!<[\/]?bib)(?!<[\/]?edrg>).)*)<\/btg>([\.\;\, ]+)<edrg>\&lt\;edr\&gt\;/<btg>\&lt\;bt\&gt\;$1<\/btg>$2<edrg>\&lt\;edr\&gt\;/gs;
	$FileText=~s/<btg>[iI]n[\.\,\: ]+“\&lt\;bt\&gt\;((?:(?!<[\/]?btg>)(?!<[\/]?bib)(?!<[\/]?edrg>).)*)\&lt\;\/bt&gt;<\/btg>”/<btg>\&lt\;bt\&gt\;$1\&lt\;\/bt&gt;<\/btg>/gs;
	$FileText=~s/<cnyg>\&lt\;cny\&gt\;([Ff]rankfurt a\. M)\&lt\;\/cny\&gt\;<\/cnyg>/<cnyg>\&lt\;cny\&gt\;$1\.\&lt\;\/cny\&gt\;<\/cnyg>/gs;

	$FileText=~s/<atg>\&quot\;((?:(?!<[\/]?atg>)(?!<[\/]?bib).)*?)([\,\.]?)\&quot\;<\/atg>/<atg>$1<\/atg>$2/gs;
	$FileText=~s/<atg>"((?:(?!<[\/]?atg>)(?!<[\/]?bib).)*?)([\,\.]?)"<\/atg>/<atg>$1<\/atg>$2/gs;
	$FileText=~s/<atg>((?:(?!<[\/]?atg>)(?!<[\/]?bib).)*?)([\,\.]?)<\/atg>/<atg>$1<\/atg>$2/gs;

	$FileText=addEditPagePrefix(\$FileText, "withdot");

	$FileText=~s/<vg>[vV]ol\. \&lt\;v&gt\;([0-9]+)([^a-zA-Z0-9\.\,\;\"\:\(\)\[\]\@\$\%\&\*\!\~\+\=\?\<\>\/]+)([0-9]+)\&lt\;\/v\&gt\;<\/vg>/<vg>Vols\. \&lt\;v&gt\;$1$2$3\&lt\;\/v\&gt\;<\/vg>/gs;
	$FileText=~s/\&lt\;\/([a-z]+)\&gt\; <\/([a-z]+)> /\&lt\;\/$1\&gt\;<\/$2> /gs;
	$FileText=~s/\s+<\/([a-z0-9]+)> /<\/$1> /gs;
	$FileText=~s/([\.\;\:\,\?]+) <\/([a-z0-9]+)>([\.\;\:\,\?])/$1<\/$2>$3/gs;

      }	


    if($style=~/^(ElsAPA5)$/)
      {
	$FileText=&deleteInFromTitle($FileText);
	$FileText=~s/&lt;\/([a-z0-9]+)\&gt\;([\.\:\,]+)<\/\1g>/&lt;\/$1\&gt\;<\/$1g>$2/gs;

	$FileText=~s/<edrg>([eE]dited by|[eE]dit[eo]r[s]?:) \&lt\;edr\&gt\;/<edrg>eds \&lt\;edr\&gt\;/gs;
	$FileText=~s/<edrg>([eE]d[s]?[\.]?) by \&lt\;edr\&gt\;/<edrg>$1 \&lt\;edr\&gt\;/gs;
	$FileText=~s/<edrg>([Hh]rsg|[Ee]d|[Ee]ds)[\. ]+\&lt\;edr\&gt\;((?:(?!<[\/]?edrg>)(?!<[\/]?bib)(?!<[\/]?aug>).)*)\&lt\;\/edr\&gt\;<\/edrg>/<edrg>\&lt\;edr\&gt\;$2\&lt\;\/edr\&gt\; \($1\.\)<\/edrg>/gs;

	$FileText=~s/<(vg|iss)>\/ /\/ <$1>/gs;
	$FileText=~s/\(([Hh]rsg|[Hh]g)\)/\(Hrsg\.\)/gs;
	$FileText=~s/<pgg>\&lt\;pg\&gt\;([0-9\-]+)\&lt\;\/pg\&gt\; ([pSP]+)<\/pgg>/<pgg>$2 \&lt\;pg\&gt\;$1\&lt\;\/pg\&gt\;<\/pgg>/gs;
	$FileText=~s/<pgg>([pP]ages[\.\: ]*)/<pgg>pp\. /gs;
	$FileText=~s/<pgg>([pP]age[\.\: ]*)/<pgg>p\. /gs;
	$FileText=~s/<pgg>P[\.\:]?/<pgg>p\./gs;
	$FileText=~s/<pgg>PP[\.\:]?/<pgg>pp\./gs;
	$FileText=~s/<pgg>([SPp]+)[\.\:]? /<pgg>$1\. /gs;
	$FileText=~s/\&lt\;pgg\&gt;([SPp]+) /<pgg>$1\. /gs;
	$FileText=~s/<issg>([0-9\.]+) ([Ss]uppl) /<issg>$1 $2\./gs;
	$FileText=~s/<pgg>([pSP]+)\&lt\;pg\&gt\;/<pgg>$1 \&lt\;pg\&gt\;/gs;

	$FileText=~s/[\(\[]([Hh]rsg|[Hh]g)[\.]?[\]\)][\.]?<\/edrg>/\(Hrsg\.\)<\/edrg>/gs;
	$FileText=~s/[\(\[]([Ee]d|[Ee]ds)[\.]?[\]\)][\.]?<\/edrg>/\(\u$1\E\.\)<\/edrg>/gs;
	$FileText=~s/([Hh]rsg|[Hh]g)[\.]?<\/edrg>/\(Hrsg\.\)<\/edrg>/gs;
	$FileText=~s/([Ee]d|[Ee]ds)[\.]?<\/edrg>/\(\u$1\E\.\)<\/edrg>/gs;
	$FileText=~s/[\(\[]?[Ee]ditors[\]\)\.]*<\/edrg>/\(Eds\.\)<\/edrg>/gs;
	$FileText=~s/[\(\[]?[Ee]ditor[\]\)\.]*<\/edrg>/\(Ed\.\)<\/edrg>/gs;
	$FileText=~s/[\(\[]?[Hh]erausgeber[\]\)\.]*<\/edrg>/\(Hrsg\.\)<\/edrg>/gs;
	$FileText=~s/<(pblg|cnyg)>\(\&lt\;(pbl|cny)\&gt\;/\(<$1>\&lt\;$2\&gt\;/gs;
	$FileText=~s/<edrg>[eE]dited by &lt;edr&gt;((?:(?!<[\/]?edrg>)(?!<[\/]?bib)(?!<[\/]?aug>).)*)\&lt\;\/edr\&gt\;<\/edrg>/<edrg>&lt;edr&gt;$1\&lt\;\/edr\&gt\; Ed.<\/edrg>/gs;

	$FileText=~s/\&lt\;\/(pbl|cny)\&gt\;\)<\/(pblg|cnyg)>/\&lt\;\/$1\&gt\;<\/$2>\)/gs;
	$FileText=~s/ [eE]d[n]?[\.]?<\/edng>/ ed\.<\/edng>/gs; #for editions
	$FileText=~s/ [Ee]dition[s]?[\.]?<\/edng>/ ed\.<\/edng>/gs; #for editions
	$FileText=~s/ [Aa]uflage[s]?[\.]?<\/edng>/ Aufl\.<\/edng>/gs; #for editions

	$FileText=&deleteVolIssuePrefix($FileText);
	$FileText=&deletePagePrefix($FileText);

	$FileText=~s/<vg>([B]d[s]?)[\.]?[ ]?\&lt\;v\&gt\;/<vg>\u$1\E\. \&lt\;v\&gt\;/gs;
	$FileText=~s/<vg>([Vv]ol[s]?)[\.]?[ ]?\&lt\;v\&gt\;/<vg>\u$1\E\. \&lt\;v\&gt\;/gs;
	$FileText=~s/<vg>[Vv]olume[ ]?\&lt\;v\&gt\;/<vg>Vol\. \&lt\;v\&gt\;/gs;
	$FileText=~s/<vg>[Vv]olumes[ ]?\&lt\;v\&gt\;/<vg>Vols\. \&lt\;v\&gt\;/gs;

	$FileText=~s/ \(([0-9]+[.]? [JFMASOND][a-z]+)<\/aug> <yrg>\&lt\;yr\&gt\;([1-2][0987][0-9][0-9][a-z]?)\&lt\;\/yr&gt\;<\/yrg>\)/<\/aug> \(<yrg>$1 \&lt\;yr\&gt\;$2\&lt\;\/yr&gt\;<\/yrg>\)/gs;
	$FileText=~s/\; \(([^<>\(\)]+?)<\/aug> <yrg>\&lt\;yr\&gt\;([1-2][0987][0-9][0-9][a-z]?)\&lt\;\/yr&gt\;<\/yrg>\)/<\/aug>\; \(<yrg>$1 \&lt\;yr\&gt\;$2\&lt\;\/yr&gt\;<\/yrg>\)/gs;
	$FileText=~s/\&lt\;\/yr\&gt\;\)<\/yrg>/\&lt\;\/yr\&gt\;<\/yrg>\)/gs;

	$FileText=~s/\&lt\;i\&gt\;(et al[\.]?)\&lt\;\/i\&gt\;/$1/gs;
	$FileText=~s/ \&lt\;\/pg\&gt\;<\/pgg>\)/\&lt\;\/pg\&gt\;<\/pgg>\)/gs;
	#$FileText=~s/\)<\/pgg>/<\/pgg>/gs;
	$FileText=~s/<pgg>([^<>\(\)]+?)\)<\/pgg>/<pgg>$1<\/pgg>\)/gs;

	$FileText=~s/<pgg>Pp[\.]?[ ]?\&lt\;pg\&gt\;/<pgg>pp\. \&lt\;pg\&gt\;/gs;
	#$FileText=~s/\.<\/yrg>/<\/yrg>/gs;
	$FileText=~s/&lt;\/yr&gt;\.<\/yrg>/&lt;\/yr&gt;<\/yrg>/gs;

	$FileText=~s/\&lt\;\/v\&gt\;\. <\/vg>([\,\.\;\:])/\&lt\;\/v\&gt\;<\/vg>$1/gs;
	$FileText=~s/\&lt\;at\&gt\;\&lt\;i\&gt\;((?:(?!\&lt\;i\&gt\;)(?!\&lt\;\/i\&gt\;)(?!<atg>)(?!<\/atg>).)*)\&lt\;\/i\&gt\;([\?\.\!]?)\&lt\;\/at\&gt\;/\&lt\;at\&gt\;$1$2\&lt\;\/at\&gt\;/gs;
	$FileText=~s/\.\&lt\;\/auf\&gt\;\&lt\;\/au\&gt\;\./\.\&lt\;\/auf\&gt\;\&lt\;\/au\&gt\;/gs;
	$FileText=~s/\&lt\;\/([a-z]+)\&gt\; <\/([a-z]+)> /\&lt\;\/$1\&gt\;<\/$2> /gs;

	$FileText=~s/<cnyg>\&lt\;cny\&gt\;([Ff]rankfurt a\. M)\&lt\;\/cny\&gt\;<\/cnyg>/<cnyg>\&lt\;cny\&gt\;$1\.\&lt\;\/cny\&gt\;<\/cnyg>/gs;

	$FileText=~s/<atg>\&quot\;((?:(?!<[\/]?atg>)(?!<[\/]?bib).)*?)([\,\.]?)\&quot\;<\/atg>/<atg>$1<\/atg>$2/gs;
	$FileText=~s/<atg>"((?:(?!<[\/]?atg>)(?!<[\/]?bib).)*?)([\,\.]?)"<\/atg>/<atg>$1<\/atg>$2/gs;
	$FileText=~s/<atg>((?:(?!<[\/]?atg>)(?!<[\/]?bib).)*?)([\,\.]?)<\/atg>/<atg>$1<\/atg>$2/gs;

	$FileText=addEditPagePrefix(\$FileText, "withdot");

	$FileText=~s/<vg>[vV]ol\. \&lt\;v&gt\;([0-9]+)([^a-zA-Z0-9\.\,\;\"\:\(\)\[\]\@\$\%\&\*\!\~\+\=\?\<\>\/]+)([0-9]+)\&lt\;\/v\&gt\;<\/vg>/<vg>Vols\. \&lt\;v&gt\;$1$2$3\&lt\;\/v\&gt\;<\/vg>/gs;
	$FileText=~s/\&lt\;\/([a-z]+)\&gt\; <\/([a-z]+)> /\&lt\;\/$1\&gt\;<\/$2> /gs;
	$FileText=~s/\s+<\/([a-z0-9]+)> /<\/$1> /gs;
	$FileText=~s/([\.\;\:\,\?]+) <\/([a-z0-9]+)>([\.\;\:\,\?])/$1<\/$2>$3/gs;

      }	


    if($style=~/^(ElsACS)$/)
      {
	$FileText=&deleteInFromTitle($FileText);
	$FileText=~s/&lt;\/([a-z0-9]+)\&gt\;([\.\:\,]+)<\/\1g>/&lt;\/$1\&gt\;<\/$1g>$2/gs;

	$FileText=~s/<edrg>([eE]dited by|[eE]dit[eo]r[s]?:) \&lt\;edr\&gt\;/<edrg>eds \&lt\;edr\&gt\;/gs;
	$FileText=~s/<edrg>([eE]d[s]?[\.]?) by \&lt\;edr\&gt\;/<edrg>$1 \&lt\;edr\&gt\;/gs;
	$FileText=~s/<edrg>([Hh]rsg|[Ee]d|[Ee]ds)[\. ]+\&lt\;edr\&gt\;((?:(?!<[\/]?edrg>)(?!<[\/]?bib)(?!<[\/]?aug>).)*)\&lt\;\/edr\&gt\;<\/edrg>/<edrg>\&lt\;edr\&gt\;$2\&lt\;\/edr\&gt\; $1\.<\/edrg>/gs;


	$FileText=~s/<issg>([0-9\.]+) ([Ss]uppl) /<issg>$1 $2\./gs;
	$FileText=~s/<(vg|iss)>\/ /\/ <$1>/gs;

	$FileText=~s/<pgg>\&lt\;pg\&gt\;([0-9\-]+)\&lt\;\/pg\&gt\; ([pSP]+)<\/pgg>/<pgg>$2 \&lt\;pg\&gt\;$1\&lt\;\/pg\&gt\;<\/pgg>/gs;
	$FileText=~s/<pgg>([pP]ages[\.\: ]*)/<pgg>pp /gs;
	$FileText=~s/<pgg>([pP]age[\.\: ]*)/<pgg>p /gs;
	$FileText=~s/<pgg>P[\.\:]?/<pgg>p/gs;
	$FileText=~s/<pgg>PP[\.\:]?/<pgg>pp/gs;
	$FileText=~s/<pgg>([SPp]+)[\.\:]? /<pgg>$1 /gs;
	$FileText=~s/\&lt\;pgg\&gt;([SPp]+)[\.]? /<pgg>$1 /gs;
	$FileText=~s/<pgg>([pSP]+)\&lt\;pg\&gt\;/<pgg>$1 \&lt\;pg\&gt\;/gs;

	$FileText=~s/[\(\[]([Hh]rsg|[Hh]g)[\]\)]/Hrsg\./gs;
	$FileText=~s/[\(\[]([Hh]rsg|[Hh]g)[\.]?[\]\)][\.]?<\/edrg>/Hrsg\.<\/edrg>/gs;
	$FileText=~s/[\(\[]([Ee]d|[Ee]ds)[\.]?[\]\)][\.]?<\/edrg>/\u$1\E\.<\/edrg>/gs;
	$FileText=~s/([Hh]rsg|[Hh]g)[\.]?<\/edrg>/Hrsg\.<\/edrg>/gs;
	$FileText=~s/([Ee]d|[Ee]ds)[\.]?<\/edrg>/\u$1\E\.<\/edrg>/gs;
	$FileText=~s/[\(\[]?[Ee]ditors[\]\)\.]*<\/edrg>/Eds\.<\/edrg>/gs;
	$FileText=~s/[\(\[]?[Ee]ditor[\]\)\.]*<\/edrg>/Ed\.<\/edrg>/gs;
	$FileText=~s/[\(\[]?[Hh]erausgeber[\]\)\.]*<\/edrg>/Hrsg\.<\/edrg>/gs;
	$FileText=~s/<edrg>[eE]dited by &lt;edr&gt;((?:(?!<[\/]?edrg>)(?!<[\/]?bib)(?!<[\/]?aug>).)*)\&lt\;\/edr\&gt\;<\/edrg>/<edrg>&lt;edr&gt;$1\&lt\;\/edr\&gt\; Ed.<\/edrg>/gs;

	$FileText=~s/<(pblg|cnyg)>\(\&lt\;(pbl|cny)\&gt\;/\(<$1>\&lt\;$2\&gt\;/gs;
	$FileText=~s/\&lt\;\/(pbl|cny)\&gt\;\)<\/(pblg|cnyg)>/\&lt\;\/$1\&gt\;<\/$2>\)/gs;

	$FileText=~s/ [eE]d[n]?[\.]?<\/edng>/ ed\.<\/edng>/gs; #for editions
	$FileText=~s/ [Ee]dition[s]?[\.]?<\/edng>/ ed\.<\/edng>/gs; #for editions
	$FileText=~s/ [Aa]uflage[s]?[\.]?<\/edng>/ Aufl\.<\/edng>/gs; #for editions

	$FileText=&deleteVolIssuePrefix($FileText);
	$FileText=&deletePagePrefix($FileText);

	$FileText=~s/<vg>([B]d[s]?)[\.]?[ ]?\&lt\;v\&gt\;/<vg>\u$1\E\. \&lt\;v\&gt\;/gs;
	$FileText=~s/<vg>([Vv]ol[s]?)[\.]?[ ]?\&lt\;v\&gt\;/<vg>\u$1\E\. \&lt\;v\&gt\;/gs;
	$FileText=~s/<vg>[Vv]olume[ ]?\&lt\;v\&gt\;/<vg>Vol\. \&lt\;v\&gt\;/gs;
	$FileText=~s/<vg>[Vv]olumes[ ]?\&lt\;v\&gt\;/<vg>Vols\. \&lt\;v\&gt\;/gs;

	$FileText=~s/ \(([0-9]+[.]? [JFMASOND][a-z]+)<\/aug> <yrg>\&lt\;yr\&gt\;([1-2][0987][0-9][0-9][a-z]?)\&lt\;\/yr&gt\;<\/yrg>\)/<\/aug> \(<yrg>$1 \&lt\;yr\&gt\;$2\&lt\;\/yr&gt\;<\/yrg>\)/gs;
	$FileText=~s/\; \(([^<>\(\)]+?)<\/aug> <yrg>\&lt\;yr\&gt\;([1-2][0987][0-9][0-9][a-z]?)\&lt\;\/yr&gt\;<\/yrg>\)/<\/aug>\; \(<yrg>$1 \&lt\;yr\&gt\;$2\&lt\;\/yr&gt\;<\/yrg>\)/gs;
	$FileText=~s/\&lt\;\/yr\&gt\;\)<\/yrg>/\&lt\;\/yr\&gt\;<\/yrg>\)/gs;

	$FileText=~s/\&lt\;i\&gt\;(et al[\.]?)\&lt\;\/i\&gt\;/$1/gs;
	$FileText=~s/ \&lt\;\/pg\&gt\;<\/pgg>\)/\&lt\;\/pg\&gt\;<\/pgg>\)/gs;

	#$FileText=~s/\)<\/pgg>/<\/pgg>/gs;
	$FileText=~s/<pgg>([^<>\(\)]+?)\)<\/pgg>/<pgg>$1<\/pgg>\)/gs;
	$FileText=~s/<pgg>Pp[\.]?[ ]?\&lt\;pg\&gt\;/<pgg>pp \&lt\;pg\&gt\;/gs;
	#$FileText=~s/\.<\/yrg>/<\/yrg>/gs;

	$FileText=~s/&lt;\/yr&gt;\.<\/yrg>/&lt;\/yr&gt;<\/yrg>/gs;
	$FileText=~s/\&lt\;\/v\&gt\;\. <\/vg>([\,\.\;\:])/\&lt\;\/v\&gt\;<\/vg>$1/gs;

	$FileText=~s/\&lt\;at\&gt\;\&lt\;i\&gt\;((?:(?!\&lt\;i\&gt\;)(?!\&lt\;\/i\&gt\;)(?!<atg>)(?!<\/atg>).)*)\&lt\;\/i\&gt\;([\?\.\!]?)\&lt\;\/at\&gt\;/\&lt\;at\&gt\;$1$2\&lt\;\/at\&gt\;/gs;
	$FileText=~s/\.\&lt\;\/auf\&gt\;\&lt\;\/au\&gt\;\./\.\&lt\;\/auf\&gt\;\&lt\;\/au\&gt\;/gs;
	$FileText=~s/\&lt\;\/([a-z]+)\&gt\; <\/([a-z]+)> /\&lt\;\/$1\&gt\;<\/$2> /gs;

	$FileText=~s/<cnyg>\&lt\;cny\&gt\;([Ff]rankfurt a\. M)\&lt\;\/cny\&gt\;<\/cnyg>/<cnyg>\&lt\;cny\&gt\;$1\.\&lt\;\/cny\&gt\;<\/cnyg>/gs;

	$FileText=~s/<atg>\&quot\;((?:(?!<[\/]?atg>)(?!<[\/]?bib).)*?)([\,\.]?)\&quot\;<\/atg>/<atg>$1<\/atg>$2/gs;
	$FileText=~s/<atg>"((?:(?!<[\/]?atg>)(?!<[\/]?bib).)*?)([\,\.]?)"<\/atg>/<atg>$1<\/atg>$2/gs;
	$FileText=~s/<atg>((?:(?!<[\/]?atg>)(?!<[\/]?bib).)*?)([\,\.]?)<\/atg>/<atg>$1<\/atg>$2/gs;

	$FileText=addEditPagePrefix(\$FileText, "nodot");

	$FileText=~s/<vg>[vV]ol\. \&lt\;v&gt\;([0-9]+)([^a-zA-Z0-9\.\,\;\"\:\(\)\[\]\@\$\%\&\*\!\~\+\=\?\<\>\/]+)([0-9]+)\&lt\;\/v\&gt\;<\/vg>/<vg>Vols\. \&lt\;v&gt\;$1$2$3\&lt\;\/v\&gt\;<\/vg>/gs;
	$FileText=~s/\&lt\;\/([a-z]+)\&gt\; <\/([a-z]+)> /\&lt\;\/$1\&gt\;<\/$2> /gs;
	$FileText=~s/\s+<\/([a-z0-9]+)> /<\/$1> /gs;
	$FileText=~s/([\.\;\:\,\?]+) <\/([a-z0-9]+)>([\.\;\:\,\?])/$1<\/$2>$3/gs;

      }	


    if($style=~/^(ElsVancouver)$/)
      {

	$FileText=&deleteInFromTitle($FileText);
	$FileText=~s/&lt;\/([a-z0-9]+)\&gt\;([\.\:\,]+)<\/\1g>/&lt;\/$1\&gt\;<\/$1g>$2/gs;

	$FileText=~s/<edrg>([eE]dited by|[eE]dit[eo]r[s]?:) \&lt\;edr\&gt\;/<edrg>eds \&lt\;edr\&gt\;/gs;
	$FileText=~s/<edrg>([eE]d[s]?[\.]?) by \&lt\;edr\&gt\;/<edrg>$1 \&lt\;edr\&gt\;/gs;
	$FileText=~s/<edrg>([Hh]rsg|[Ee]d|[Ee]ds)[\. ]+\&lt\;edr\&gt\;((?:(?!<[\/]?edrg>)(?!<[\/]?bib)(?!<[\/]?aug>).)*)\&lt\;\/edr\&gt\;<\/edrg>/<edrg>\&lt\;edr\&gt\;$2\&lt\;\/edr\&gt\; \($1\.\)<\/edrg>/gs;

	$FileText=~s/<(vg|iss)>\/ /\/ <$1>/gs;
	$FileText=~s/<pgg>\&lt\;pg\&gt\;([0-9\-]+)\&lt\;\/pg\&gt\; ([pSP]+)<\/pgg>/<pgg>$2 \&lt\;pg\&gt\;$1\&lt\;\/pg\&gt\;<\/pgg>/gs;
	$FileText=~s/<pgg>([pP]ages[\.\: ]*)/<pgg>pp\. /gs;
	$FileText=~s/<pgg>([pP]age[\.\: ]*)/<pgg>p\. /gs;
	$FileText=~s/<pgg>P[\.\:]?/<pgg>p\./gs;
	$FileText=~s/<pgg>PP[\.\:]?/<pgg>pp\./gs;
	$FileText=~s/<pgg>([SPp]+)[\.\:]? /<pgg>$1\. /gs;
	$FileText=~s/\&lt\;pgg\&gt;([SPp]+) /<pgg>$1\. /gs;
	$FileText=~s/<issg>([0-9\.]+) ([Ss]uppl) /<issg>$1 $2\./gs;
	$FileText=~s/<pgg>([pSP]+)\&lt\;pg\&gt\;/<pgg>$1 \&lt\;pg\&gt\;/gs;

	$FileText=~s/([\.\, ]+)[\(\[]([Hh]rsg|[Hh]g|[Hh]erausgeber)[\.]?[\]\)]/, Herausgeber/gs; #by ketan kadu
	$FileText=~s/([\.\, ]+)[\(\[]([eE]d|[Ee]ditor)[\.]?[\]\)]/, editor/gs;
	$FileText=~s/([\.\, ]+)[\(\[]([eE]ds|[Ee]ditors)[\.]?[\]\)]/, editors/gs;
	$FileText=~s/[Hh]erausgeber[\.]?<\/edrg>/Herausgeber<\/edrg>/gs;

	$FileText=~s/<(pblg|cnyg)>\(\&lt\;(pbl|cny)\&gt\;/\(<$1>\&lt\;$2\&gt\;/gs;
	$FileText=~s/<edrg>[eE]dited by &lt;edr&gt;((?:(?!<[\/]?edrg>)(?!<[\/]?bib)(?!<[\/]?aug>).)*)\&lt\;\/edr\&gt\;<\/edrg>/<edrg>&lt;edr&gt;$1\&lt\;\/edr\&gt\; Ed.<\/edrg>/gs;

	$FileText=~s/\&lt\;\/(pbl|cny)\&gt\;\)<\/(pblg|cnyg)>/\&lt\;\/$1\&gt\;<\/$2>\)/gs;
	$FileText=~s/ [eE]d[n]?[\.]?<\/edng>/ ed\.<\/edng>/gs; #for editions
	$FileText=~s/ [Ee]dition[s]?[\.]?<\/edng>/ ed\.<\/edng>/gs; #for editions
	$FileText=~s/ [Aa]uflage[s]?[\.]?<\/edng>/ Aufl\.<\/edng>/gs; #for editions

	$FileText=&deleteVolIssuePrefix($FileText);
	$FileText=&deletePagePrefix($FileText);

	$FileText=~s/<vg>([B]d[s]?)[\.]?[ ]?\&lt\;v\&gt\;/<vg>\u$1\E\. \&lt\;v\&gt\;/gs;
	$FileText=~s/<vg>([Vv]ol[s]?)[\.]?[ ]?\&lt\;v\&gt\;/<vg>\u$1\E\. \&lt\;v\&gt\;/gs;
	$FileText=~s/<vg>[Vv]olume[ ]?\&lt\;v\&gt\;/<vg>Vol\. \&lt\;v\&gt\;/gs;
	$FileText=~s/<vg>[Vv]olumes[ ]?\&lt\;v\&gt\;/<vg>Vols\. \&lt\;v\&gt\;/gs;

	$FileText=~s/ \(([0-9]+[.]? [JFMASOND][a-z]+)<\/aug> <yrg>\&lt\;yr\&gt\;([1-2][0987][0-9][0-9][a-z]?)\&lt\;\/yr&gt\;<\/yrg>\)/<\/aug> \(<yrg>$1 \&lt\;yr\&gt\;$2\&lt\;\/yr&gt\;<\/yrg>\)/gs;
	$FileText=~s/\; \(([^<>\(\)]+?)<\/aug> <yrg>\&lt\;yr\&gt\;([1-2][0987][0-9][0-9][a-z]?)\&lt\;\/yr&gt\;<\/yrg>\)/<\/aug>\; \(<yrg>$1 \&lt\;yr\&gt\;$2\&lt\;\/yr&gt\;<\/yrg>\)/gs;
	$FileText=~s/\&lt\;\/yr\&gt\;\)<\/yrg>/\&lt\;\/yr\&gt\;<\/yrg>\)/gs;

	$FileText=~s/\&lt\;i\&gt\;(et al[\.]?)\&lt\;\/i\&gt\;/$1/gs;
	$FileText=~s/ \&lt\;\/pg\&gt\;<\/pgg>\)/\&lt\;\/pg\&gt\;<\/pgg>\)/gs;
	#$FileText=~s/\)<\/pgg>/<\/pgg>/gs;
	$FileText=~s/<pgg>([^<>\(\)]+?)\)<\/pgg>/<pgg>$1<\/pgg>\)/gs;

	$FileText=~s/<pgg>Pp[\.]?[ ]?\&lt\;pg\&gt\;/<pgg>pp\. \&lt\;pg\&gt\;/gs;
	#$FileText=~s/\.<\/yrg>/<\/yrg>/gs;
	$FileText=~s/&lt;\/yr&gt;\.<\/yrg>/&lt;\/yr&gt;<\/yrg>/gs;

	$FileText=~s/\&lt\;\/v\&gt\;\. <\/vg>([\,\.\;\:])/\&lt\;\/v\&gt\;<\/vg>$1/gs;
	$FileText=~s/\&lt\;at\&gt\;\&lt\;i\&gt\;((?:(?!\&lt\;i\&gt\;)(?!\&lt\;\/i\&gt\;)(?!<atg>)(?!<\/atg>).)*)\&lt\;\/i\&gt\;([\?\.\!]?)\&lt\;\/at\&gt\;/\&lt\;at\&gt\;$1$2\&lt\;\/at\&gt\;/gs;
	$FileText=~s/\.\&lt\;\/auf\&gt\;\&lt\;\/au\&gt\;\./\.\&lt\;\/auf\&gt\;\&lt\;\/au\&gt\;/gs;
	$FileText=~s/\&lt\;\/([a-z]+)\&gt\; <\/([a-z]+)> /\&lt\;\/$1\&gt\;<\/$2> /gs;

	$FileText=~s/<cnyg>\&lt\;cny\&gt\;([Ff]rankfurt a\. M)\&lt\;\/cny\&gt\;<\/cnyg>/<cnyg>\&lt\;cny\&gt\;$1\.\&lt\;\/cny\&gt\;<\/cnyg>/gs;

	$FileText=~s/<atg>\&quot\;((?:(?!<[\/]?atg>)(?!<[\/]?bib).)*?)([\,\.]?)\&quot\;<\/atg>/<atg>$1<\/atg>$2/gs;
	$FileText=~s/<atg>"((?:(?!<[\/]?atg>)(?!<[\/]?bib).)*?)([\,\.]?)"<\/atg>/<atg>$1<\/atg>$2/gs;
	$FileText=~s/<atg>((?:(?!<[\/]?atg>)(?!<[\/]?bib).)*?)([\,\.]?)<\/atg>/<atg>$1<\/atg>$2/gs;

	$FileText=addEditPagePrefix(\$FileText, "withdot");

	$FileText=~s/<vg>[vV]ol\. \&lt\;v&gt\;([0-9]+)([^a-zA-Z0-9\.\,\;\"\:\(\)\[\]\@\$\%\&\*\!\~\+\=\?\<\>\/]+)([0-9]+)\&lt\;\/v\&gt\;<\/vg>/<vg>Vols\. \&lt\;v&gt\;$1$2$3\&lt\;\/v\&gt\;<\/vg>/gs;
	$FileText=~s/\&lt\;\/([a-z]+)\&gt\; <\/([a-z]+)> /\&lt\;\/$1\&gt\;<\/$2> /gs;
	$FileText=~s/\s+<\/([a-z0-9]+)> /<\/$1> /gs;
	$FileText=~s/([\.\;\:\,\?]+) <\/([a-z0-9]+)>([\.\;\:\,\?])/$1<\/$2>$3/gs;

      }	

    if($style=~/^(Chemistry)$/)
      {
	
	$FileText=~s/(\&gt\;[\,\. ]+| )$regx{and}([\,]?) $regx{etal}([\.\,\;\:]?)<\/(aug|edrg|ia)>/$1$4$5<\/$6>/gs;

	$FileText=~s/<btg>([Ii]n[\:\. ]+)\&lt\;bt\&gt\;((?:(?!<[\/]?bib)(?!<[\/]?aug>).)*?)<edrg>$regx{editorSuffix}([\.\, ]+)&lt;edr&gt;/<btg>\&lt\;bt\&gt\;$2<edrg>$3$4&lt;edr&gt;/gs;
	$FileText=~s/<btg>([Ii]n[\:\. ]+)\&lt\;bt\&gt\;((?:(?!<[\/]?bib)(?!<[\/]?aug>).)*?)<edrg>&lt;edr&gt;/<btg>\&lt\;bt\&gt\;$2<edrg>&lt;edr&gt;/gs;

	$FileText=~s/<edrg>([eE]d[\.]?) by \&lt\;edr\&gt\;/<edrg>$1 \&lt\;edr\&gt\;/gs;

	$FileText=~s/<(vg|iss)>\/ /\/ <$1>/gs;
	$FileText=~s/<pgg>\&lt\;pg\&gt\;([0-9\-]+)\&lt\;\/pg\&gt\; ([pSP]+)<\/pgg>/<pgg>$2 \&lt\;pg\&gt\;$1\&lt\;\/pg\&gt\;<\/pgg>/gs;

	$FileText=&deleteVolIssuePrefix($FileText);
	$FileText=&deletePagePrefix($FileText);


	$FileText=~s/\&lt\;i\&gt\;(et al[\.]?)\&lt\;\/i\&gt\;/$1/gs;
	$FileText=~s/ \&lt\;\/pg\&gt\;<\/pgg>\)/\&lt\;\/pg\&gt\;<\/pgg>\)/gs;
	#$FileText=~s/\)<\/pgg>/<\/pgg>/gs;
	$FileText=~s/<pgg>([^<>\(\)]+?)\)<\/pgg>/<pgg>$1<\/pgg>\)/gs;

	#$FileText=~s/\.<\/yrg>/<\/yrg>/gs;
	$FileText=~s/&lt;\/yr&gt;\.<\/yrg>/&lt;\/yr&gt;<\/yrg>/gs;
	$FileText=~s/\&lt\;\/v\&gt\;\. <\/vg>([\,\.\;\:])/\&lt\;\/v\&gt\;<\/vg>$1/gs;
	$FileText=~s/\&lt\;at\&gt\;\&lt\;i\&gt\;((?:(?!\&lt\;i\&gt\;)(?!\&lt\;\/i\&gt\;)(?!<atg>)(?!<\/atg>).)*)\&lt\;\/i\&gt\;([\?\.\!]?)\&lt\;\/at\&gt\;/\&lt\;at\&gt\;$1$2\&lt\;\/at\&gt\;/gs;
	$FileText=~s/\.\&lt\;\/auf\&gt\;\&lt\;\/au\&gt\;\./\.\&lt\;\/auf\&gt\;\&lt\;\/au\&gt\;/gs;
	$FileText=~s/\&lt\;\/([a-z]+)\&gt\; <\/([a-z]+)> /\&lt\;\/$1\&gt\;<\/$2> /gs;
	$FileText=~s/([\.\;\:\,\?]+) <\/([a-z0-9]+)>([\.\;\:\,\?])/$1<\/$2>$3/gs;

      }	


    if($style=~/^(MPS)$/)
      {
	$FileText=&deleteInFromTitle($FileText);

	$FileText=~s/<edrg>([eE]dited [bB]y|Ed[s]?\. [bB]y|[eE]dit[eo]r[s]?\:|[Ee]d[s]?[\:]) \&lt\;edr\&gt\;/<edrg>eds \&lt\;edr\&gt\;/gs;
	$FileText=~s/<edrg>([eE]d[s]?[\.]?) [bB]y \&lt\;edr\&gt\;/<edrg>$1 \&lt\;edr\&gt\;/gs;
	$FileText=~s/<edrg>([Hh]rsg|[Ee]d|[Ee]ds)[\. ]+\&lt\;edr\&gt\;((?:(?!<[\/]?edrg>)(?!<[\/]?bib)(?!<[\/]?aug>).)*)\&lt\;\/edr\&gt\;<\/edrg>/<edrg>\&lt\;edr\&gt\;$2\&lt\;\/edr\&gt\; \($1\)<\/edrg>/gs;
	$FileText=~s/<(vg|iss)>\/ /\/ <$1>/gs;
	$FileText=~s/[\(\[]([Hh]rsg|[Hh]g)[\.]?[\]\)][\.]?<\/edrg>/\(Hrsg\.\)<\/edrg>/gs;
	$FileText=~s/[\(\[]([Ee]d|[Ee]ds)[\.]?[\]\)][\.]?<\/edrg>/\(\l$1\E\.\)<\/edrg>/gs;
	$FileText=~s/([Hh]rsg|[Hh]g)[\.]?<\/edrg>/\(Hrsg\.\)<\/edrg>/gs;
	$FileText=~s/([Ee]d|[Ee]ds)[\.]?<\/edrg>/\(\l$1\E\.\)<\/edrg>/gs;
	$FileText=~s/[\(\[]?[Ee]ditors[\]\)\.]*<\/edrg>/\(eds\.\)<\/edrg>/gs;
	$FileText=~s/[\(\[]?[Ee]ditor[\]\)\.]*<\/edrg>/\(ed\.\)<\/edrg>/gs;
	$FileText=~s/[\(\[]?[Hh]erausgeber[\]\)\.]*<\/edrg>/\(Hrsg\.\)<\/edrg>/gs;

	$FileText=~s/([\.\,\'\"\:>]) ([Ii]n[\:\.\,]*) <ia>([^<>]+?)[\.\,]* [\(]?([Hh]erausgeber|[Hh]rsg|[Hh]g)[\.\)]*<\/ia>/$1 $2 <ia>$3 (Hrsg)<\/ia>/gs;
	$FileText=~s/([\.\,\'\"\:>]) ([Ii]n[\:\.\,]*) <ia>([^<>]+?)[\.\,]? [\(]?$regx{editorSuffix}([\.\)]*)<\/ia>/$1 <ia>$3 ($4)<\/ia>/gs;

	$FileText=~s/<(pblg|cnyg)>\(\&lt\;(pbl|cny)\&gt\;/\(<$1>\&lt\;$2\&gt\;/gs;
	$FileText=~s/\&lt\;\/(pbl|cny)\&gt\;\)<\/(pblg|cnyg)>/\&lt\;\/$1\&gt\;<\/$2>\)/gs;
	$FileText=~s/<pgg>\&lt\;pg\&gt\;([0-9\-]+)\&lt\;\/pg\&gt\; ([pSP]+)<\/pgg>/<pgg>$2\. \&lt\;pg\&gt\;$1\&lt\;\/pg\&gt\;<\/pgg>/gs;
	$FileText=~s/<pgg>([pP]ages[\.\: ]*)/<pgg>pp\. /gs;
	$FileText=~s/<pgg>([pP]age[\.\: ]*)/<pgg>p\. /gs;
	$FileText=~s/<pgg>P[\.\:]?/<pgg>p\./gs;
	$FileText=~s/<pgg>PP[\.\:]?/<pgg>pp\./gs;
	$FileText=~s/<pgg>([pSP]+)[\.\:]?/<pgg>$1\./gs;


	#print $FileText;
	$FileText=~s/ [eE]d[n]?[\.]?<\/edng>/ edn\.<\/edng>/gs; #for editions
	$FileText=~s/ [Ee]dition[s]?[\.]?<\/edng>/ edn\.<\/edng>/gs; #for editions
	$FileText=~s/ [Aa]uflage[s]?[\.]?<\/edng>/ Aufl\.<\/edng>/gs; #for editions
	$FileText=~s/ edn<\/edng>/ edn\.<\/edng>/gs; #for editions
	$FileText=~s/<pgg>\&lt\;pg\&gt\;([0-9\-]+)\&lt\;\/pg\&gt\; ([pSP]+)<\/pgg>/<pgg>$2 \&lt\;pg\&gt\;$1\&lt\;\/pg\&gt\;<\/pgg>/gs;

	$FileText=&deleteVolIssuePrefix($FileText);
	$FileText=&deletePagePrefix($FileText);

	$FileText=~s/<vg>([B]d[s]?)[\.]?[ ]?\&lt\;v\&gt\;/<vg>\u$1\E\. \&lt\;v\&gt\;/gs;
	$FileText=~s/<vg>([Vv]ol[s]?)[\.]?[ ]?\&lt\;v\&gt\;/<vg>\l$1\E\. \&lt\;v\&gt\;/gs;
	$FileText=~s/<vg>[Vv]olume[ ]?\&lt\;v\&gt\;/<vg>vol\. \&lt\;v\&gt\;/gs;
	$FileText=~s/<vg>[Vv]olumes[ ]?\&lt\;v\&gt\;/<vg>vols\. \&lt\;v\&gt\;/gs;

	$FileText=~s/ \(([0-9]+[.]? [JFMASOND][a-z]+)<\/aug> <yrg>\&lt\;yr\&gt\;([1-2][0987][0-9][0-9][a-z]?)\&lt\;\/yr&gt\;<\/yrg>\)/<\/aug> \(<yrg>$1 \&lt\;yr\&gt\;$2\&lt\;\/yr&gt\;<\/yrg>\)/gs;
	$FileText=~s/\; \(([^<>\(\)]+?)<\/aug> <yrg>\&lt\;yr\&gt\;([1-2][0987][0-9][0-9][a-z]?)\&lt\;\/yr&gt\;<\/yrg>\)/<\/aug>\; \(<yrg>$1 \&lt\;yr\&gt\;$2\&lt\;\/yr&gt\;<\/yrg>\)/gs;
	$FileText=~s/\&lt\;\/yr\&gt\;\)<\/yrg>/\&lt\;\/yr\&gt\;<\/yrg>\)/gs;

	$FileText=~s/<\/pgg> <ptg>([iI]n[\:\.\,]?)\s*\&lt\;pt\&gt\;/<\/pgg> <ptg>\&lt\;pt\&gt\;/gs;
	$FileText=~s/\&lt\;i\&gt\;(et al[\.]?)\&lt\;\/i\&gt\;/$1/gs;
	$FileText=~s/ \&lt\;\/pg\&gt\;<\/pgg>\)/\&lt\;\/pg\&gt\;<\/pgg>\)/gs;
	$FileText=~s/\)<\/pgg>/<\/pgg>/gs;
	$FileText=~s/<pgg>\&lt\;pg\&gt\;([0-9\-]+)\&lt\;\/pg\&gt\; ([pSP]+)<\/pgg>/<pgg>$2 \&lt\;pg\&gt\;$1\&lt\;\/pg\&gt\;<\/pgg>/gs;
	$FileText=~s/<pgg>Pp[\.]?[ ]?\&lt\;pg\&gt\;/<pgg>pp\. \&lt\;pg\&gt\;/gs;
	$FileText=~s/<pgg>pp([^<> \.\,\0-9a-zA-Z]+)/<pgg>pp\.$1/gs;

	#$FileText=~s/\.<\/yrg>/<\/yrg>/gs;
	$FileText=~s/&lt;\/yr&gt;\.<\/yrg>/&lt;\/yr&gt;<\/yrg>/gs;

	$FileText=~s/\&lt\;\/v\&gt\;\. <\/vg>([\,\.\;\:])/\&lt\;\/v\&gt\;<\/vg>$1/gs;
	$FileText=~s/\&lt\;at\&gt\;\&lt\;i\&gt\;((?:(?!\&lt\;i\&gt\;)(?!\&lt\;\/i\&gt\;)(?!<atg>)(?!<\/atg>).)*)\&lt\;\/i\&gt\;([\?\.\!]?)\&lt\;\/at\&gt\;/\&lt\;at\&gt\;$1$2\&lt\;\/at\&gt\;/gs;
	$FileText=~s/\.\&lt\;\/auf\&gt\;\&lt\;\/au\&gt\;\./\.\&lt\;\/auf\&gt\;\&lt\;\/au\&gt\;/gs;
	$FileText=~s/<btg>[iI]n[\.\,\: ]+\&lt\;bt\&gt\;((?:(?!<[\/]?btg>)(?!<[\/]?bib)(?!<[\/]?edrg>).)*)<\/btg>([\.\;\, ]+)<edrg>\&lt\;edr\&gt\;/<btg>\&lt\;bt\&gt\;$1<\/btg>$2<edrg>\&lt\;edr\&gt\;/gs;
	$FileText=~s/<btg>[iI]n[\.\,\: ]+“\&lt\;bt\&gt\;((?:(?!<[\/]?btg>)(?!<[\/]?bib)(?!<[\/]?edrg>).)*)\&lt\;\/bt&gt;<\/btg>”/<btg>\&lt\;bt\&gt\;$1\&lt\;\/bt&gt;<\/btg>/gs;
	$FileText=~s/<cnyg>\&lt\;cny\&gt\;([Ff]rankfurt a\. M)[\.]?\&lt\;\/cny\&gt\;[\.]?<\/cnyg>/<cnyg>\&lt\;cny\&gt\;$1\&lt\;\/cny\&gt\;<\/cnyg>/gs;
	$FileText=~s/<atg>\&quot\;((?:(?!<[\/]?atg>)(?!<[\/]?bib).)*?)([\,\.]?)\&quot\;<\/atg>/<atg>$1<\/atg>$2/gs;
	$FileText=~s/<atg>"((?:(?!<[\/]?atg>)(?!<[\/]?bib).)*?)([\,\.]?)"<\/atg>/<atg>$1<\/atg>$2/gs;
	$FileText=~s/<atg>((?:(?!<[\/]?atg>)(?!<[\/]?bib).)*?)([\,\.]?)<\/atg>/<atg>$1<\/atg>$2/gs;

	#for adding pp or p in pagegroup
	$FileText=addEditPagePrefix(\$FileText, "withdot");

	$FileText=~s/<vg>vol\. \&lt\;v&gt\;([0-9]+)([^a-zA-Z0-9\.\,\;\"\:\(\)\[\]\@\$\%\&\*\!\~\+\=\?\<\>\/]+)([0-9]+)\&lt\;\/v\&gt\;<\/vg>/<vg>vols\. \&lt\;v&gt\;$1$2$3\&lt\;\/v\&gt\;<\/vg>/gs;
	$FileText=~s/\&lt\;\/([a-z]+)\&gt\; <\/([a-z]+)> /\&lt\;\/$1\&gt\;<\/$2> /gs;
	$FileText=~s/\s+<\/([a-z0-9]+)> /<\/$1> /gs;
	$FileText=~s/([\.\;\:\,\?]+) <\/([a-z0-9]+)>([\.\;\:\,\?])/$1<\/$2>$3/gs;

	#print $FileText;

      }

    if($style=~/^(APS)$/)
      {

	$FileText=~s/(\&gt\;[\,\. ]+| )$regx{and}([\,]?) $regx{etal}([\.\,\;\:]?)<\/(aug|edrg|ia)>/$1$4$5<\/$6>/gs;
	$FileText=~s/<btg>([Ii]n[\:\. ]+)\&lt\;bt\&gt\;((?:(?!<[\/]?bib)(?!<[\/]?aug>).)*?)<edrg>$regx{editorSuffix}([\.\, ]+)&lt;edr&gt;/<btg>\&lt\;bt\&gt\;$2<edrg>$3$4&lt;edr&gt;/gs;
	$FileText=~s/<btg>([Ii]n[\:\. ]+)\&lt\;bt\&gt\;((?:(?!<[\/]?bib)(?!<[\/]?aug>).)*?)<edrg>&lt;edr&gt;/<btg>\&lt\;bt\&gt\;$2<edrg>&lt;edr&gt;/gs;
	$FileText=~s/<edrg>([eE]dited by|[eE]dit[eo]r[s]?:) \&lt\;edr\&gt\;/<edrg>eds \&lt\;edr\&gt\;/gs;
	$FileText=~s/<edrg>([eE]d[s]?[\.]?) by \&lt\;edr\&gt\;/<edrg>$1 \&lt\;edr\&gt\;/gs;
	$FileText=~s/<edrg>([Hh]rsg|[Ee]d|[Ee]ds)[\. ]+\&lt\;edr\&gt\;((?:(?!<[\/]?edrg>)(?!<[\/]?bib)(?!<[\/]?aug>).)*)\&lt\;\/edr\&gt\;<\/edrg>/<edrg>\&lt\;edr\&gt\;$2\&lt\;\/edr\&gt\; \($1\)<\/edrg>/gs;

	$FileText=~s/<(vg|iss)>\/ /\/ <$1>/gs;
	$FileText=~s/<pgg>\&lt\;pg\&gt\;([0-9\-]+)\&lt\;\/pg\&gt\; ([pSP]+)<\/pgg>/<pgg>$2 \&lt\;pg\&gt\;$1\&lt\;\/pg\&gt\;<\/pgg>/gs;
	$FileText=~s/[\(\[]([Hh]rsg|[Hh]g)[\.]?[\]\)][\.]?<\/edrg>/\(Hrsg\.\)<\/edrg>/gs;
	$FileText=~s/[\(\[]([Ee]d|[Ee]ds)[\.]?[\]\)][\.]?<\/edrg>/\(\l$1\E\.\)<\/edrg>/gs;
	$FileText=~s/([Hh]rsg|[Hh]g)[\.]?<\/edrg>/\(Hrsg\.\)<\/edrg>/gs;
	$FileText=~s/([Ee]d|[Ee]ds)[\.]?<\/edrg>/\(\l$1\E\.\)<\/edrg>/gs;
	$FileText=~s/[\(\[]?[Ee]ditors[\]\)\.]*<\/edrg>/\(eds\.\)<\/edrg>/gs;
	$FileText=~s/[\(\[]?[Ee]ditor[\]\)\.]*<\/edrg>/\(ed\.\)<\/edrg>/gs;
	$FileText=~s/[\(\[]?[Hh]erausgeber[\]\)\.]*<\/edrg>/\(Hrsg\.\)<\/edrg>/gs;

	$FileText=~s/<(pblg|cnyg)>\(\&lt\;(pbl|cny)\&gt\;/\(<$1>\&lt\;$2\&gt\;/gs;
	$FileText=~s/\&lt\;\/(pbl|cny)\&gt\;\)<\/(pblg|cnyg)>/\&lt\;\/$1\&gt\;<\/$2>\)/gs;
	$FileText=~s/<\/misc1g>((?:(?!<[\/]?bib )(?!<[\/]?misc1g )(?!<[\/]?edrg)(?!<[\/]?aug).)*)<edrg>((?:(?!<[\/]?bib )(?!<[\/]?edrg)(?!<[\/]?aug).)*)\&lt\;\/edr\&gt\;[\,]? [\(]?([Ee]d[s]?|[Hh]rsg)[\.]?[\)]?<\/edrg>/<\/misc1g>$1<edrg>$2\&lt\;\/edr\&gt\;<\/edrg>/gs;

	$FileText=~s/<pgg>\&lt\;pg\&gt\;([0-9\-]+)\&lt\;\/pg\&gt\; ([pSP]+)<\/pgg>/<pgg>$2 \&lt\;pg\&gt\;$1\&lt\;\/pg\&gt\;<\/pgg>/gs;
	$FileText=~s/<pgg>([pSP]+)[\.]?/<pgg>$1\./gs;
	$FileText=~s/ [eE]d[n]?[\.]?<\/edng>/ edn\.<\/edng>/gs; #for editions
	$FileText=~s/ [Ee]dition[s]?[\.]?<\/edng>/ edn\.<\/edng>/gs; #for editions
	$FileText=~s/ [Aa]uflage[s]?[\.]?<\/edng>/ Aufl\.<\/edng>/gs; #for editions
	$FileText=~s/ edn<\/edng>/ edn\.<\/edng>/gs; #for editions

	$FileText=&deleteVolIssuePrefix($FileText);
	$FileText=&deletePagePrefix($FileText);

	$FileText=~s/<vg>([B]d[s]?)[\.]?[ ]?\&lt\;v\&gt\;/<vg>\u$1\E\. \&lt\;v\&gt\;/gs;
	$FileText=~s/<vg>([Vv]ol[s]?)[\.]?[ ]?\&lt\;v\&gt\;/<vg>\l$1\E\. \&lt\;v\&gt\;/gs;
	$FileText=~s/<vg>[Vv]olume[ ]?\&lt\;v\&gt\;/<vg>vol\. \&lt\;v\&gt\;/gs;
	$FileText=~s/<vg>[Vv]olumes[ ]?\&lt\;v\&gt\;/<vg>vols\. \&lt\;v\&gt\;/gs;

	$FileText=~s/ \(([0-9]+[.]? [JFMASOND][a-z]+)<\/aug> <yrg>\&lt\;yr\&gt\;([1-2][0987][0-9][0-9][a-z]?)\&lt\;\/yr&gt\;<\/yrg>\)/<\/aug> \(<yrg>$1 \&lt\;yr\&gt\;$2\&lt\;\/yr&gt\;<\/yrg>\)/gs;
	$FileText=~s/\; \(([^<>\(\)]+?)<\/aug> <yrg>\&lt\;yr\&gt\;([1-2][0987][0-9][0-9][a-z]?)\&lt\;\/yr&gt\;<\/yrg>\)/<\/aug>\; \(<yrg>$1 \&lt\;yr\&gt\;$2\&lt\;\/yr&gt\;<\/yrg>\)/gs;
	$FileText=~s/\&lt\;\/yr\&gt\;\)<\/yrg>/\&lt\;\/yr\&gt\;<\/yrg>\)/gs;

	$FileText=~s/<\/pgg> <ptg>([iI]n[\:\.\,]?)\s*\&lt\;pt\&gt\;/<\/pgg> <ptg>\&lt\;pt\&gt\;/gs;
	$FileText=~s/\&lt\;i\&gt\;(et al[\.]?)\&lt\;\/i\&gt\;/$1/gs;
	$FileText=~s/ \&lt\;\/pg\&gt\;<\/pgg>\)/\&lt\;\/pg\&gt\;<\/pgg>\)/gs;
	#$FileText=~s/\)<\/pgg>/<\/pgg>/gs;
	$FileText=~s/<pgg>([^<>\(\)]+?)\)<\/pgg>/<pgg>$1<\/pgg>\)/gs;

	$FileText=~s/<pgg>Pp[\.]?[ ]?\&lt\;pg\&gt\;/<pgg>pp\. \&lt\;pg\&gt\;/gs;
	$FileText=~s/<pgg>pp([^<> \.\,\0-9a-zA-Z]+)/<pgg>pp\.$1/gs;

	#$FileText=~s/\.<\/yrg>/<\/yrg>/gs;
	$FileText=~s/&lt;\/yr&gt;\.<\/yrg>/&lt;\/yr&gt;<\/yrg>/gs;
	$FileText=~s/\&lt\;\/v\&gt\;\. <\/vg>([\,\.\;\:])/\&lt\;\/v\&gt\;<\/vg>$1/gs;
	$FileText=~s/\&lt\;at\&gt\;\&lt\;i\&gt\;((?:(?!\&lt\;i\&gt\;)(?!\&lt\;\/i\&gt\;)(?!<atg>)(?!<\/atg>).)*)\&lt\;\/i\&gt\;([\?\.\!]?)\&lt\;\/at\&gt\;/\&lt\;at\&gt\;$1$2\&lt\;\/at\&gt\;/gs;
	$FileText=~s/<edrg>([iI]n[\:\.\,]?)\s*((?:(?!<edrg>)(?!<\/edrg>).)*)\s*$regx{editorSuffix}([\.]?)<\/edrg>/<edrg>$2<\/edrg>/gs; #check for APS
	$FileText=~s/<edrg>([iI]n[\:\.\,]?)\s*((?:(?!<edrg>)(?!<\/edrg>).)*)\s*\($regx{editorSuffix}([\.]?)\)([\.]?)<\/edrg>/<edrg>$2<\/edrg>/gs; #check for APS
	$FileText=~s/<edrg>([iI]n[\:\.\,]?)\s*\&lt\;edr\&gt\;/<edrg>\&lt\;edr\&gt\;/gs;
	$FileText=~s/\.\&lt\;\/auf\&gt\;\&lt\;\/au\&gt\;\./\.\&lt\;\/auf\&gt\;\&lt\;\/au\&gt\;/gs;

	$FileText=~s/<btg>[iI]n[\.\,\: ]+\&lt\;bt\&gt\;((?:(?!<[\/]?btg>)(?!<[\/]?bib)(?!<[\/]?edrg>).)*)<\/btg>([\.\;\, ]+)<edrg>\&lt\;edr\&gt\;/<btg>\&lt\;bt\&gt\;$1<\/btg>$2<edrg>\&lt\;edr\&gt\;/gs;
	$FileText=~s/<btg>[iI]n[\.\,\: ]+“\&lt\;bt\&gt\;((?:(?!<[\/]?btg>)(?!<[\/]?bib)(?!<[\/]?edrg>).)*)\&lt\;\/bt&gt;<\/btg>”/<btg>\&lt\;bt\&gt\;$1\&lt\;\/bt&gt;<\/btg>/gs;
	$FileText=~s/<cnyg>\&lt\;cny\&gt\;([Ff]rankfurt a\. M)[\.]?\&lt\;\/cny\&gt\;[\.]?<\/cnyg>/<cnyg>\&lt\;cny\&gt\;$1\&lt\;\/cny\&gt\;<\/cnyg>/gs;
	$FileText=~s/<atg>\&quot\;((?:(?!<[\/]?atg>)(?!<[\/]?bib).)*?)([\,\.]?)\&quot\;<\/atg>/<atg>$1<\/atg>$2/gs;
	$FileText=~s/<atg>"((?:(?!<[\/]?atg>)(?!<[\/]?bib).)*?)([\,\.]?)"<\/atg>/<atg>$1<\/atg>$2/gs;
	$FileText=~s/<atg>((?:(?!<[\/]?atg>)(?!<[\/]?bib).)*?)([\,\.]?)<\/atg>/<atg>$1<\/atg>$2/gs;
#	$FileText=~s/<edrg>([eE]d[\.]?) by \&lt\;edr\&gt\;/<edrg>$1 \&lt\;edr\&gt\;/gs;

	#for adding pp or p in pagegroup
	$FileText=addEditPagePrefix(\$FileText, "withdot");

	$FileText=~s/<vg>vol\. \&lt\;v&gt\;([0-9]+)([^a-zA-Z0-9\.\,\;\"\:\(\)\[\]\@\$\%\&\*\!\~\+\=\?\<\>\/]+)([0-9]+)\&lt\;\/v\&gt\;<\/vg>/<vg>vols\. \&lt\;v&gt\;$1$2$3\&lt\;\/v\&gt\;<\/vg>/gs;
	$FileText=~s/\&lt\;\/([a-z]+)\&gt\; <\/([a-z]+)> /\&lt\;\/$1\&gt\;<\/$2> /gs;
	$FileText=~s/\s+<\/([a-z0-9]+)> /<\/$1> /gs;

      }

    $FileText=~s/<pgg>((?:(?!<[\/]?ppg>)(?!<[\/]?btg>)(?!<[\/]?bib)(?!<[\/]?aug>).)*) \(((?:(?!<[\/]?ppg>)(?![\)\(])(?!<[\/]?btg>)(?!<[\/]?bib)(?!<[\/]?aug>).)*)<\/pgg>([\.]?)<\/bib>/<pgg>$1 \($2\)<\/pgg>$3<\/bib>/gs;

    $FileText=~s/\(([iI]n [Cc]hinese)<\/([a-z]+)><\/bib>/\($1\)<\/$2><\/bib>/gs;

     return $FileText; 
  }

#===================================================================
sub deleteInFromTitle{
  my $FileText=shift;
  my %regx = ReferenceManager::ReferenceRegex::new();

  $FileText=~s/(\&gt\;[\,\. ]+| )$regx{and}([\,]?) $regx{etal}([\.\,\;\:]?)<\/(aug|edrg|ia)>/$1$4$5<\/$6>/gs;
  $FileText=~s/(doi[\:])[\:]/$1/igs;

  $FileText=~s/<collabg>([Ii]n[\:\. ]+|In[\:\.\, ]+)\&lt\;collab\&gt\;((?:(?!<[\/]?bib)(?!<[\/]?aug>).)*?)<edrg>$regx{editorSuffix}([\.\, ]+)&lt;edr&gt;/<collabg>\&lt\;collab\&gt\;$2<edrg>$3$4&lt;edr&gt;/gs;
  $FileText=~s/<collabg>([Ii]n[\:\. ]+|In[\:\.\, ]+)\&lt\;collab\&gt\;((?:(?!<[\/]?bib)(?!<[\/]?aug>).)*?)<edrg>([eE]dited by[\.\, ]+)&lt;edr&gt;/<collabg>\&lt\;collab\&gt\;$2<edrg>$3$4&lt;edr&gt;/gs;
  $FileText=~s/<collabg>([Ii]n[\:\. ]+|In[\:\.\, ]+)\&lt\;collab\&gt\;((?:(?!<[\/]?bib)(?!<[\/]?aug>).)*?)<edrg>&lt;edr&gt;/<collabg>\&lt\;collab\&gt\;$2<edrg>&lt;edr&gt;/gs;

  $FileText=~s/<btg>([Ii]n[\:\. ]+|In[\:\.\, ]+)\&lt\;bt\&gt\;((?:(?!<[\/]?bib)(?!<[\/]?aug>).)*?)<edrg>$regx{editorSuffix}([\.\, ]+)&lt;edr&gt;/<btg>\&lt\;bt\&gt\;$2<edrg>$3$4&lt;edr&gt;/gs;
  $FileText=~s/<btg>([Ii]n[\:\. ]+|In[\:\.\, ]+)\&lt\;bt\&gt\;((?:(?!<[\/]?bib)(?!<[\/]?aug>).)*?)<edrg>([eE]dited by[\.\, ]+|[eE]dit[eo]r[s]?\:|[Ee]d[s]?\:)([\.\, ]+)&lt;edr&gt;/<btg>\&lt\;bt\&gt\;$2<edrg>$3$4&lt;edr&gt;/gs;
  $FileText=~s/<btg>([Ii]n[\:\. ]+|In[\:\.\, ]+)\&lt\;bt\&gt\;((?:(?!<[\/]?bib)(?!<[\/]?aug>).)*?)<edrg>&lt;edr&gt;/<btg>\&lt\;bt\&gt\;$2<edrg>&lt;edr&gt;/gs;

  $FileText=~s/<btg>[iI]n[\.\: ]+\&lt\;bt\&gt\;((?:(?!<[\/]?btg>)(?!<[\/]?bib)(?!<[\/]?edrg>).)*)<\/btg>([\.\;\, ]+)<(edrg|ia)>/<btg>\&lt\;bt\&gt\;$1<\/btg>$2<$3>/gs;
  $FileText=~s/<btg>[iI]n[\.\,\: ]+“\&lt\;bt\&gt\;((?:(?!<[\/]?btg>)(?!<[\/]?bib)(?!<[\/]?edrg>).)*)\&lt\;\/bt&gt;<\/btg>”/<btg>\&lt\;bt\&gt\;$1\&lt\;\/bt&gt;<\/btg>/gs;
  $FileText=~s/<btg>[iI]n[\.\,\: ]+$regx{allLeftQuote}\&lt\;bt\&gt\;((?:(?!<[\/]?btg>)(?!<[\/]?bib)(?!<[\/]?edrg>).)*)\&lt\;\/bt&gt;<\/btg>$regx{allRightQuote}/<btg>\&lt\;bt\&gt\;$2\&lt\;\/bt&gt;<\/btg>/gs;

#  $FileText=~s/<btg><\/btg>. <misc1g>In: &lt;
#  print "XXXX: $FileText\n"; exit;

  #$FileText=~s/<([a-z0-9]+)g>\&lt\;\1\&gt\;$regx{allLeftQuote}$regx{noQoute}$regx{allRightQuote}&lt;\/\1\&gt\;<\/\1g>/<$1g>\&lt\;$1\&gt\;$3&lt;\/$1\&gt\;<\/$1g>/gs;
  $FileText=~s/<\/pgg> <ptg>([iI]n[\:\.\,]?)\s*\&lt\;pt\&gt\;/<\/pgg> <ptg>\&lt\;pt\&gt\;/gs;
  $FileText=~s/<\/misc1g>\. <btg>([Ii]n[\:\.\,] |In )\&lt\;bt\&gt\;/<\/misc1g>\. <btg>\&lt\;bt\&gt\;/gs;
  $FileText=~s/<\/(btg|misc1g|collabg)>([\.\,\;\: ]+)<ia>$regx{editorSuffix}([\.\:\,]+ )/<\/$1>$2<ia>/gs;

  return $FileText;
}
#===================================================================

sub deleteVolIssuePrefix
  {
    my $FileText=shift;
    my %regx = ReferenceManager::ReferenceRegex::new();


    $FileText=~s/<\/ptg>([\.\:\?\,\/\(\; ]+)<yrg>&lt;yr&gt;$regx{year}&lt;\/yr&gt;<\/yrg>([\.\:\?\,\/\)\; ]+)<vg>$regx{volumePrefix}\s*/<\/ptg>$1<yrg>&lt;yr&gt;$2&lt;\/yr&gt;<\/yrg>$3<vg>/gs;
    #$FileText=~s/<vg>$regx{volumePrefix}\s*\&lt\;v\&gt\;((?:(?!<[\/]?vg>)(?!<[\/]?bib>)(?!<[\/]?aug>).)*?)\&lt\;\/v\&gt\;<\/vg>([\.\,\: \(]+)<issg>/<vg>\&lt\;v\&gt\;$2\&lt\;\/v\&gt\;<\/vg>$3<issg>/gs;#biswajit
    $FileText=~s/<\/ptg>([\.\, ]+)<vg>$regx{volumePrefix}\s*/<\/ptg>$1<vg>/gs;
    $FileText=~s/<\/issg>([\.\,\/ ]+)<vg>$regx{volumePrefix}\s*/<\/issg>$1<vg>/gs;
    $FileText=~s/$regx{volumePrefix}<\/vg>/<\/vg>/gs;

    $FileText=~s/<\/vg>([\.\,\: \(]+)<issg>$regx{issuePrefix1}\s*$regx{pagePrefix}\s*/<\/vg>$1<issg>/gs; 
    $FileText=~s/<\/vg>([\.\,\: \(]+)<issg>$regx{issuePrefix1}\s*/<\/vg>$1<issg>/gs; 

    $FileText=~s/<\/ptg>([\.\, ]+)<issg>$regx{issuePrefix1}\s*/<\/ptg>$1<issg>/gs; 
    $FileText=~s/<\/ptg>((?:(?!<[\/]?issg>)(?!<[\/]?ptg>)(?!<[\/]?bib>)(?!<[\/]?aug>).)*?)<issg>$regx{issuePrefix1}\s*\&lt\;iss\&gt\;/<\/ptg>$1<issg>\&lt\;iss\&gt\;/gs;
    $FileText=~s/<\/ptg>((?:(?!<[\/]?issg>)(?!<[\/]?ptg>)(?!<[\/]?bib>)(?!<[\/]?aug>).)*?)<issg>$regx{issuePrefix1}\s*\&lt\;iss\&gt\;/<\/ptg>$1<issg>\&lt\;iss\&gt\;/gs;
    $FileText=~s/<\/ptg>([\.\:\?\,\(\; ]+)<vg>V\&lt\;v\&gt\;/<\/ptg>$1<vg>\&lt\;v\&gt\;/gs;

    $FileText=~s/<\/ptg>((?:(?!<[\/]?ptg>)(?!<[\/]?bib>)(?!<[\/]?aug>).)*?)<pgg>\&lt\;pg\&gt\;([^<>]+?)\&lt\;\/pg&gt;$regx{pagePrefix}<\/pgg>/<\/ptg>$1<pgg>\&lt\;pg\&gt\;$2\&lt\;\/pg&gt;<\/pgg>/gs;


    return $FileText;
  }
#=====================================================================================
  sub deletePagePrefix
    {
      my $FileText=shift;
      my %regx = ReferenceManager::ReferenceRegex::new();

      $FileText=~s/<\/issg>([\)\:\.\, ]+)<pgg>$regx{pagePrefix}\s*\&lt\;pg\&gt\;/<\/issg>$1<pgg>\&lt\;pg\&gt\;/g;

      $FileText=~s/<\/atg>([\.\, ]+)<pgg>$regx{pagePrefix}\s*\&lt\;pg\&gt\;/<\/atg>$1<pgg>\&lt\;pg\&gt\;/g;

      $FileText=~s/<\/ptg>((?:(?!<[\/]?ptg>)(?!<bib )(?!<[\/]?btg>)(?!<[\/]?bib>)(?!<[\/]?aug>).)*?)<pgg>$regx{pagePrefix}\s*&lt\;pg\&gt\;/<\/ptg>$1<pgg>&lt\;pg\&gt\;/gs;

    return $FileText;
  }
#===================================================================================
sub LanguageEditing{
  my $FileText=shift;

 # if($style eq "ElsAPA5"){
 #     $FileText=&SentanceCase($FileText, "at");
 #     $FileText=&UpperCaseAfterColon($FileText);
 #     $FileText=&SentanceCase($FileText, "bt");
 #     $FileText=&UpperCaseAfterColon($FileText);
 #   }
 #
 # if($style eq "ElsACS"){
 #     $FileText=&TitleCase($FileText, "at");
 #     $FileText=&UpperCaseAfterColon($FileText);
 #     $FileText=&TitleCase($FileText, "bt");
 #     $FileText=&UpperCaseAfterColon($FileText);
 #   }
 #
 # if($style eq "Vancouver"){
 #     #$FileText=&SentanceCase($FileText, "at");
 #     #$FileText=&SentanceCase($FileText, "bt");
 #   }
 #
 # if($style eq "APA" or $style eq "Chicago"){
 #   $FileText=&UpperCaseAfterColonLangBased($FileText);
 # }
 #
 # if($style eq "Basic" or $style eq "Chemistry" or $style eq "Vancouver"){
 #   $FileText=&LowerCaseAfterColonLangBased($FileText);
 # }


  $FileText=PagePrefixEditing($FileText); #Page Prifix editing based on Lang

  $FileText=EdnPrefixEditing($FileText); #Edition Prifix editing based on Lang

  $FileText=VolPrefixEditing($FileText); #Volume Prifix editing based on Lang

  $FileText=EditorSuffixEditing($FileText); #Editor Suffix editing based on Lang

  $FileText=GermanEnglishQuote($FileText, $language); #Quote editing based on Lang

  $FileText=MdashToNdash($FileText, $language); #Mdash to Ndash editing based on Lang

  $FileText=SpecialPrefixTermEditing($FileText, $language, \%regx); #Accessed/Zugegriffen to Zugegriffen/Accessed editing based on Lang

  $FileText=EditMonthName($FileText, $language, \%regx); #Accessed/Zugegriffen to Zugegriffen/Accessed editing based on Lang


  return $$FileText;
}
#===================================================================
sub UpperCaseAfterColon{
  my $FileText=shift;
  $$FileText=~s/\&lt\;([\/]?)(at|misc1|bt)\&gt\;/<$1$2>/gs;
  while($$FileText=~/<(at|misc1|bt)>((?:(?!<\1>)(?!<\/\1>).)*)<\/\1>/s)
    {
      my $ElementText=$2;
      $ElementText=~s/\: ([a-z])/\: \U$1/gs;
      $$FileText=~s/<(at|misc1|bt)>((?:(?!<\1>)(?!<\/\1>).)*)<\/\1>/\&lt\;$1\&gt\;$ElementText\&lt\;\/$1\&gt\;/os;
    }
  $$FileText=~s/<([\/]?)(at|misc1|bt)>/\&lt\;$1$2\&gt\;/gs;
  return $FileText;
}
#=========================================================================
sub UpperCaseAfterColonLangBased{
  my $FileText=shift;
  my $cld = Lingua::Identify::CLD->new();

  $$FileText=~s/\&lt\;([\/]?)(at|misc1|bt)\&gt\;/<$1$2>/gs;
  while($$FileText=~/<(at|misc1|bt)>((?:(?!<\1>)(?!<\/\1>).)*)<\/\1>/s)
    {
      my $ElementText=$2;
      my $lang = $cld->identify("$ElementText");
      if ($lang eq "ENGLISH"){
	$ElementText=~s/(\:|—) ([a-z][^A-Z0-9])/$1 \u$2/gs;
	$ElementText=~s/ $regx{mdash1} ([a-z][^A-Z0-9])/ $1 \u$2/gs;
      }
      $$FileText=~s/<(at|misc1|bt)>((?:(?!<\1>)(?!<\/\1>).)*)<\/\1>/\&lt\;$1\&gt\;$ElementText\&lt\;\/$1\&gt\;/os;
    }
  $$FileText=~s/<([\/]?)(at|misc1|bt)>/\&lt\;$1$2\&gt\;/gs;
  return $FileText;
}
#=========================================================================
sub LowerCaseAfterColonLangBased{
  my $FileText=shift;
  my $cld = Lingua::Identify::CLD->new();
  $$FileText=~s/\&lt\;([\/]?)(at|misc1|bt)\&gt\;/<$1$2>/gs;
  while($$FileText=~/<(at|misc1|bt)>((?:(?!<\1>)(?!<\/\1>).)*)<\/\1>/s)
    {
      my $ElementText=$2;
      my $lang = $cld->identify("$ElementText");
      if ($lang eq "ENGLISH"){
	$ElementText=~s/(\:|—) ([A-Z][^A-Z0-9])/$1 \l$2/gs;
	$ElementText=~s/ $regx{mdash1} ([A-Z][^A-Z0-9])/ $1 \l$2/gs;
      }
      $$FileText=~s/<(at|misc1|bt)>((?:(?!<\1>)(?!<\/\1>).)*)<\/\1>/\&lt\;$1\&gt\;$ElementText\&lt\;\/$1\&gt\;/os;
    }
  $$FileText=~s/<([\/]?)(at|misc1|bt)>/\&lt\;$1$2\&gt\;/gs;
  return $FileText;
}
#=========================================================================

sub SentanceCase{
  my $FileText=shift;
  my $elemnt=shift;
  $$FileText=~s/\&lt\;([\/]?)$elemnt\&gt\;/<$1$elemnt>/gs;

  %PrpperNounDatbase=('world health'=> 'World Health', 'youth health services'=> 'Youth Health Services', 'research report series'=> 'Research Report Series', 'new south wales'=>'new south wales');
  while($$FileText=~m/<$elemnt>((?:(?!<[\/]?$elemnt>)(?!<[\/]?bib>).)*?)<\/$elemnt>/gs)
    {
      my $title=$1;
      #(world health|assembly|world|organization|youth health services|research report series|new south wales)

      $title=~s/\(([A-Z][^A-Z ]+)([\:\,][ ]?)([A-Z][^A-Z ]+)\)/\(<uppercase>$1$2<uppercase>$3\)/gs;
      $title=~s/ \b(II\.|I\.|III\.) ([A-Z][^A-Z ]+)/ $1 <uppercase>$2/gs;
      $title=~s/\(([A-Z][^A-Z ]+)\)/\(<uppercase>$1\)/gs;
      $title=~s/<i>([^ ]+?) ([^ ]+?) ([^<>]+?)<\/i>/<i>$1 $2<\/i> $3/gs;   #by Megha 
      {}while($title=~s/ ([A-Z][^A-Z0-9 ]+)([\-\.\,\;\:\/\)\]\"\' ])/ \L$1\E$2/gs);
      {}while($title=~s/([\-\(\[\`\"\'])([A-Z][a-z]+)([\-\.\,\;\:\/\)\]\"\'< ])/$1\L$2\E$3/gs);
      $title=~s/([\-\(\[\`\"\' ])([A-Z][^A-Z0-9 ]+)$/$1\L$2\E/gs;
      $title=~s/<i>([A-Z][^A-Z ]+[\.]?) ([A-Z][^A-Z ]+[\.]?)<\/i>/<i>\u$1\E \L$2\E<\/i>/gs;
      $title=~s/\: A /\: a /gs;
      $title=~s/<uppercase>([a-z])/\u$1/gs;
      $title=~s/<uppercase>//gs;
      $title=~s/\b(india|pakistan|china|america|canada|germany|france|japan|south|western|australia|swaziland|mexico|turkey|brazil|israel|egypt|delhi|nigeria|indonesia|the hague|st. louis|berlin|bangalore|new delhi|the netherlands|north holland|las vegas|french guiana|argentina|sri lanka|los alamos|costa rica|san marino|Springfield|garden city|newbury|austin|new york|new-york|north-holland|united kingdom|thousands oaks|pacific groove|cayman islands|st. petersburg|frankfurt|salt lake city|illinois|malaysia|san deigo|cape town|los angeles|cambridge|harvard|oxford|chicago|tokyo|sydney|washington|united arab emirates|singapore|san francisco|berling|heidelberg|paris|hong kong|iraq|netherlands|cuba|texas|kenya|moscow|england|belgium|holland|morocco|london|dhaka|beijing|nepal|spain|upper saddle river|massachusetts|amsterdam|january|february|march|april|may|june|july|august|september|october|oovember|december|pimeliine|coleoptera|tenebrionidae|amazon|lepidoptera|heliconidae|gonasida|ewing|mullerian|batesian|scorpiones|channel|island|windows|mojave|desert|north|american|asidini|pogonomyrmex|gaussian|canberra|cat\.|child|australian|assembly|world|organization)\b/\u$1\E/gs;

      $$FileText=~s/<$elemnt>((?:(?!<[\/]?$elemnt>)(?!<[\/]?bib>).)*?)<\/$elemnt>/\&lt\;$elemnt\&gt\;$title\&lt\;\/$elemnt\&gt\;/s;
    }
  return $FileText;
}

#===================================================================
sub TitleCase{
  my $FileText=shift;
  my $elemnt=shift;
  $$FileText=~s/\&lt\;([\/]?)$elemnt\&gt\;/<$1$elemnt>/gs;
  while($$FileText=~m/<$elemnt>((?:(?!<[\/]?$elemnt>)(?!<[\/]?bib>).)*?)<\/$elemnt>/gs)
    {
      my $title=$1;
      #$title=~s/<i>([^ ]+?) ([^ ]+?) ([^<>]+?)<\/i>/<i>$1 $2<\/i> $3/gs;   #by Megha 
      {}while($title=~s/ ([a-z][^A-Z0-9 ]+)([\-\.\,\;\:\/\)\]\"\' ])/ \u$1\E$2/gs);
      {}while($title=~s/([\-\(\[\`\"\'])([a-z][a-z]+)([\-\.\,\;\:\/\)\]\"\'< ])/$1\u$2\E$3/gs);
      $title=~s/([\-\(\[\`\"\' ])([a-z][^A-Z0-9 ]+)$/$1\u$2\E/gs;
      #$title=~s/<i>([A-Z][^A-Z ]+[\.]?) ([A-Z][^A-Z ]+[\.]?)<\/i>/<i>\u$1\E \L$2\E<\/i>/gs;
      $title=~s/ (a|an|the|and|is|are|am|or|but|than|nor|in|on|at|up|for|to|as|by|from|into|upon|of|off|over|than|till|with|down|amid|atop|near|per|plus|so|yet|onto|if)\b/ \L$1\E/igs;

      # $title=~s/\b(be|am|are|is|was|were|being|been|have|has|had|having|may|might|must|need|ought|shall|should|will|would|can|could|dare|do|does|did|a|an|and|aboard|about|above|across|after|against|along|amid|among|anti|around|as|at|before|behind|below|beneath|beside|besides|between|beyond|but|by|concerning|considering|despite|down|during|except|excepting|excluding|following|for|from|in|inside|into|like|minus|near|of|off|on|onto|opposite|outside|over|past|per|plus|regarding|round|save|since|than|through|to|toward|towards|under|underneath|unlike|until|up|upon|versus|via|with|within|without|the)\b/\L$1\E/igs;
      $title=~s/(^|\. )\b(a|an|the|and|is|are|am|or|but|than|nor|in|on|at|up|for|to|as|by|from|into|upon|of|off|over|than|till|with|down|amid|atop|near|per|plus|so|yet|onto|if)\b/$1\u$2\E/igs;
      $$FileText=~s/<$elemnt>((?:(?!<[\/]?$elemnt>)(?!<[\/]?bib>).)*?)<\/$elemnt>/\&lt\;$elemnt\&gt\;$title\&lt\;\/$elemnt\&gt\;/s;
    }
  return $FileText;
}
#===================================================================
sub PagePrefixEditing{
  my $FileText=shift;
  $$FileText=~s/\&lt\;([\/]?)(pg|misc1|bt|srt|cny|pbl|edn)\&gt\;/<$1$2>/g;

  my %pageSuffixPunc = (Basic=>' ', Chemistry=>' ', ElsACS=>' ', APA=>'. ', MPS=>'. ', Vancouver=>'. ', APS=>'. ', ApaOrg=>'. ', ElsAPA5=>'. ', ElsVancouver=>'. ');
  #Chicago=No prefix and punc

  if(exists $pageSuffixPunc{$style}){
    $$FileText=~s/<pgg>([pP])([pP]?)\s*<pg>/<pgg>$1$2$pageSuffixPunc{$style}<pg>/g;
    $$FileText=~s/<pgg>([sS])\s*<pg>/<pgg>S$pageSuffixPunc{$style}<pg>/g;
    $$FileText=~s/<pgg>[pP]([pP]?)[\. ]?<pg>([0-9A-Zivx]+)([–\-]+)/<pgg>pp$pageSuffixPunc{$style}<pg>$2–/g;
    $$FileText=~s/<pgg>[pP]([pP]?)[\. ]?<pg>([0-9A-Zivx]+)<\/pg>/<pgg>p$pageSuffixPunc{$style}<pg>$2<\/pg>/g;

    if($language eq "En"){
      $$FileText=~s/<misc1g>((?:(?!<ptg>)(?!<misc1g>)(?!<[\/]?bib).)*?)<pgg><pg>([0-9A-Zivx]+)([–\-]+)/<misc1g>$1<pgg>pp$pageSuffixPunc{$style}<pg>$2$3/g;
      $$FileText=~s/<misc1g>((?:(?!<ptg>)(?!<misc1g>)(?!<[\/]?bib).)*?)<pgg>([pS]+)([\. ]*)<pg>([0-9A-Zivx]+)([–\-]+)/<misc1g>$1<pgg>pp$pageSuffixPunc{$style}<pg>$4$5/g;
      $$FileText=~s/<misc1g>((?:(?!<ptg>)(?!<misc1g>)(?!<[\/]?bib).)*?)<pgg>([pS]+)([\. ]*)<pg>([0-9A-Zivx]+)<\/pg>/<misc1g>$1<pgg>p$pageSuffixPunc{$style}<pg>$4<\/pg>/g;
      $$FileText=~s/<misc1g>((?:(?!<ptg>)(?!<misc1g>)(?!<[\/]?bib).)*?)<pgg><pg>([0-9A-Zivx]+)<\/pg>/<misc1g>$1<pgg>pp$pageSuffixPunc{$style}<pg>$2<\/pg>/g;

      $$FileText=~s/<btg>((?:(?!<ptg>)(?!<btg>)(?!<misc1g>)(?!<[\/]?bib).)*?)<pgg><pg>([0-9A-Zivx]+)([–\-]+)/<btg>$1<pgg>pp$pageSuffixPunc{$style}<pg>$2$3/g;
      $$FileText=~s/<btg>((?:(?!<ptg>)(?!<btg>)(?!<misc1g>)(?!<[\/]?bib).)*?)<pgg>([pS]+)([\. ]*)<pg>([0-9A-Zivx]+)([–\-]+)/<btg>$1<pgg>pp$pageSuffixPunc{$style}<pg>$4$5/g;
      $$FileText=~s/<btg>((?:(?!<ptg>)(?!<btg>)(?!<misc1g>)(?!<[\/]?bib).)*?)<pgg><pg>([0-9A-Zivx]+)<\/pg>/<btg>$1<pgg>pp$pageSuffixPunc{$style}<pg>$2<\/pg>/g;
      $$FileText=~s/<btg>((?:(?!<ptg>)(?!<btg>)(?!<misc1g>)(?!<[\/]?bib).)*?)<pgg>([pS]+)([\. ]*)<pg>([0-9A-Zivx]+)<\/pg>/<btg>$1<pgg>p$pageSuffixPunc{$style}<pg>$4<\/pg>/g;

    }
    if($language eq "De"){
      $$FileText=~s/<misc1g>((?:(?!<ptg>)(?!<misc1g>)(?!<[\/]?bib).)*?)<pgg><pg>([0-9A-Zivx]+)/<misc1g>$1<pgg>S$pageSuffixPunc{$style}<pg>$2/g;
      $$FileText=~s/<misc1g>((?:(?!<ptg>)(?!<misc1g>)(?!<[\/]?bib).)*?)<pgg>([pS]+)[\. ]+<pg>([0-9A-Zivx]+)/<misc1g>$1<pgg>S$pageSuffixPunc{$style}<pg>$3/g;
      $$FileText=~s/<btg>((?:(?!<ptg>)(?!<btg>)(?!<misc1g>)(?!<[\/]?bib).)*?)<pgg><pg>([0-9A-Zivx]+)/<btg>$1<pgg>S$pageSuffixPunc{$style}<pg>$2/g;
      $$FileText=~s/<btg>((?:(?!<ptg>)(?!<btg>)(?!<misc1g>)(?!<[\/]?bib).)*?)<pgg>([pS]+)[\. ]+<pg>([0-9A-Zivx]+)/<btg>$1<pgg>S$pageSuffixPunc{$style}<pg>$3/g;
    }
  }
  $$FileText=~s/<([\/]?)(pg|misc1|bt|srt|cny|pbl|edn|pg)>/\&lt\;$1$2\&gt\;/g;
  return $FileText;
}

#=========================================================================================================================================================
sub EdnPrefixEditing{
  my $FileText=shift;
  $$FileText=~s/\&lt\;([\/]?)(pg|misc1|bt|srt|cny|pbl|edn)\&gt\;/<$1$2>/g;

  my %editionSuffix = (
		       En=> {
			     Basic=>'edn', Chemistry=>'edn.', ElsACS=>'ed.', APA=>'edn.', MPS=>'edn.', Vancouver=>'ed.', Chicago=>'ed.', APS=>'edn.', ApaOrg=>'ed.', ElsAPA5=>'ed.', ElsVancouver=>'ed.', ElsACS=>'ed.'
			    },
		       De=> {
			     Basic=>'Aufl', Chemistry=>'Aufl', ElsACS=>'aufl.', APA=>'Aufl.', MPS=>'Aufl.', Vancouver=>'Aufl.', Chicago=>'Aufl.', APS=>'Aufl.', ApaOrg=>'Aufl.', ElsAPA5=>'Aufl.', ElsVancouver=>'Aufl.', ElsACS=>'Aufl.'
			    }
		      );    #print $editionSuffix{De}->{Basic};
  if(exists $editionSuffix{$language}->{$style}){
    $$FileText=~s/\b([eE]d[n]?|[Ee]dition[s]?|[Aa]uflage[s]?|[Aa]ufl)[\.]?<\/edng>[\.]?/$editionSuffix{$language}->{$style}<\/edng>/gs; #for editions
  }

  $$FileText=~s/<([\/]?)(pg|misc1|bt|srt|cny|pbl|edn|pg)>/\&lt\;$1$2\&gt\;/g;
  return $FileText;
}

#=========================================================================================================================================================
sub VolPrefixEditing{
  my $FileText=shift;
  $$FileText=~s/\&lt\;([\/]?)(pg|misc1|bt|srt|cny|pbl|edn)\&gt\;/<$1$2>/g;

  my %volSuffix = (
		       En=> {
			     Basic=>'vol ', Chemistry=>'vol ', ElsACS=>'Vol. ', APA=>'Vol. ', MPS=>'vol. ', Vancouver=>'Vol. ', Chicago=>'vol. ', APS=>'vol. ', ApaOrg=>'Vol. ', ElsAPA5=>'Vol. ', ElsVancouver=>'Vol. ', ElsACS=>'Vol. '
			    },
		       De=> {
			     Basic=>'Bd ', Chemistry=>'Bd ', ElsACS=>'Bd. ', APA=>'Bd. ', MPS=>'Bd. ', Vancouver=>'Bd. ', Chicago=>'Bd. ', APS=>'Bd. ', ApaOrg=>'Bd. ', ElsAPA5=>'Bd. ', ElsVancouver=>'Bd. ', ElsACS=>'Bd. '
			    }
		      );    #print $volSuffix{De}->{Basic};

  if(exists $volSuffix{$language}->{$style}){
    $$FileText=~s/<vg>(Volume|Vol|V|No)([s]?)[\. ]*\&lt\;v\&gt\;/<vg>$volSuffix{$language}->{$style}\&lt\;v\&gt\;/igs; #for editions
    $$FileText=~s/<vg>(Bd|Band)([s]?)[\. ]*\&lt\;v\&gt\;/<vg>$volSuffix{$language}->{$style}\&lt\;v\&gt\;/igs; #for editions
  }

  $$FileText=~s/<([\/]?)(pg|misc1|bt|srt|cny|pbl|edn|pg)>/\&lt\;$1$2\&gt\;/g;
  return $FileText;
}

#===========================================================================================================

sub EditorSuffixEditing{
  my $FileText=shift;
  $$FileText=~s/\&lt\;([\/]?)(pg|misc1|bt|srt|cny|pbl|edn|edr)\&gt\;/<$1$2>/g;

  my %editorSuffixSingle = (
		       En=> {
			     Basic=>'(ed)', Chemistry=>'(ed)', ElsACS=>'Ed.', APA=>'(Ed.)', MPS=>'(ed.)', Vancouver=>'editor', Chicago=>'ed.', APS=>'(ed.)', ApaOrg=>'(Ed.)', ElsAPA5=>'(Ed.)', ElsVancouver=>'editor', ElsACS=>'Ed.'
			    },
		       De=> {
			     Basic=>'(Hrsg)', Chemistry=>'(Hrsg)', ElsACS=>'Hrsg.', APA=>'(Hrsg.)', MPS=>'(Hrsg.)', Vancouver=>'Herausgeber', Chicago=>'Hrsg.', APS=>'(Hrsg.)', ApaOrg=>'(Hrsg.)', ElsAPA5=>'(Hrsg.)', ElsVancouver=>'Herausgeber', ElsACS=>'Hrsg.'
			    }
		      );    #print $editorSuffixSingle{De}->{Basic};


  my %editorSuffixMult = (
		       En=> {
			     Basic=>'(eds)', Chemistry=>'(eds)', ElsACS=>'Eds.', APA=>'(Eds.)', MPS=>'(eds.)', Vancouver=>'editors', Chicago=>'eds.', APS=>'(eds.)', ApaOrg=>'(Eds.)', ElsAPA5=>'(Eds.)', ElsVancouver=>'editors', ElsACS=>'Eds.'
			    },
		       De=> {
			     Basic=>'(Hrsg)', Chemistry=>'(Hrsg)', ElsACS=>'Hrsg.', APA=>'(Hrsg.)', MPS=>'(Hrsg.)', Vancouver=>'Herausgeber', Chicago=>'Hrsg.', APS=>'(Hrsg.)', ApaOrg=>'(Hrsg.)', ElsAPA5=>'(Hrsg.)', ElsVancouver=>'Herausgeber', ElsACS=>'Hrsg.'
			    }
		      );    #print $editorSuffixMult{De}->{Basic};

  if(exists $editorSuffixSingle{$language}->{$style}){

    $$FileText=~s/<edrg>([^<>]*<edr>)((?:(?!<[\/]?edr>)(?!<[\/]?edrg>).)*)(<\/edr>)([\., ]*?)[\(]?(ed[s]?|editor[s]?|Hrsg|Herausgeber|Hg)([\.]?)[\)]?[\.\,\:]?<\/edrg>/<edrg>$1$2$3$4$editorSuffixSingle{$language}->{$style}<\/edrg>/igs;

    $$FileText=~s/<edrg>[\(]?(ed[s]?|editor[s]?|Hrsg|Herausgeber|Hg)([\.]?[\)]?[\.\,\:]?[ ]*?)(<edr>)((?:(?!<[\/]?edr>)(?!<[\/]?edrg>).)*)(<\/edr>[^<>]*?)<\/edrg>/<edrg>$editorSuffixSingle{$language}->{$style} $3$4$5<\/edrg>/igs;

    #$$FileText=~s/<ia>((?:(?!<[\/]?bib>)(?!<[\/]?ia>)(?! [\(]?\b[eE]d[s]?\b[\)\.\,]?)(?! [\(]?\b[eE]ditor[s]?\b[\)\.\,]?)(?! [\(]?\bHrsg\b[\)\.\,]?)(?! [\(]?\bHerausgeber\b[\)\.\,]?).)*?)<\/ia>([\.\,:\; ]+)<btg>/<ia>$1 $editorSuffixSingle{$language}->{$style}<\/ia>$2<btg>/gs;
    #$$FileText=~s/<ia>((?:(?!<[\/]?bib>)(?!<[\/]?ia>).)*?)([\., ]*)[\(]?(ed[s]?|editor[s]?|Hrsg|Herausgeber|Hg)([\.]?)[\)]?[\.\,\:]?<\/ia>([\.]?)/<ia>$1$2$editorSuffixSingle{$language}->{$style}<\/ia>/igs;
    #$$FileText=~s/<ia>[\(]?(ed[s]?|editor[s]?|Hrsg|Herausgeber|Hg)\b([\.]?[\)]?[\.\,\:]?[ ]*?)((?:(?!<[\/]?bib>)(?!<[\/]?ia>).)*?)<\/ia>/<ia>$editorSuffixSingle{$language}->{$style} $2$3<\/ia>/igs;

    #$$FileText=~s/<ia>([^<>]+?)<\/ia>([\., ]*)[\(](ed[s]?|editor[s]?|Hrsg|Herausgeber|Hg)([\.]?)[\)]/<ia>$1<\/ia>$2$editorSuffixSingle{$language}->{$style}/gs;
    #$$FileText=~s/<ia>([^<>]+?)<\/ia>([\., ]*)(ed[s]?|editor[s]?|Hrsg|Herausgeber|Hg)[\.]?([\.\:\,])/<ia>$1<\/ia>$2$editorSuffixSingle{$language}->{$style}$4/gs;
 }

  if(exists $editorSuffixMult{$language}->{$style}){
    #print $$FileText;

    $$FileText=~s/((?:(?!<[\/]?edrg>).)*)(<\/edr>[^<>]*?<edr>)((?:(?!<[\/]?edr>)(?!<[\/]?edrg>).)*)(<\/edr>)([\, ]*et al[\., ]*|[\, ]*u\.a[\.\, ]*|[\,\. ]*)[\(]?(ed[s]?|editor[s]?|Hrsg|Herausgeber|Hg)([\.]?)[\)]?[\.\,\:]?<\/edrg>/$1$2$3$4$5$editorSuffixMult{$language}->{$style}<\/edrg>/igs;
    $$FileText=~s/<edrg>([^<>]*<edr>)((?:(?!<edr>)(?!<[\/]?edrg>).)*)(<\/edr>)([\, ]*et al[\., ]*|[\, ]*u\.a[\.\, ]*)[\(]?(ed[s]?|editor[s]?|Hrsg|Herausgeber|Hg)([\.]?)[\)]?[\.\,\:]?<\/edrg>/<edrg>$1$2$3$4$editorSuffixMult{$language}->{$style}<\/edrg>/igs;
    $$FileText=~s/<edrg>[\(]?(ed[s]?|editor[s]?|Hrsg|Herausgeber|Hg)([\.]?[\)]?[\.\,\:]?[ ]*?)(<edr>)((?:(?!<[\/]?edr>)(?!<[\/]?edrg>).)*)(<\/edr>[^<>]*?<edr>)((?:(?!<[\/]?edrg>).)*)<\/edrg>/<edrg>$editorSuffixMult{$language}->{$style} $3$4$5$6<\/edrg>/igs;
  }

  $$FileText=~s/<([\/]?)(pg|misc1|bt|srt|cny|pbl|edn|edr)>/\&lt\;$1$2\&gt\;/g;
  return $FileText;
}

#===============================================================================================================

sub authorEditorEtalEdit{
  my ($augText, $auEdr, $etal)=@_;
  $augText=~s/<\/$auEdr>([\,\;\.]?) (et al|etal|al[\.\,]* e)([\.\,]?)/<\/$auEdr>$etal/gs;
  $augText=~s/<\/$auEdr>([\,\;\.]?) <i>(et al|etal|al[\.\,]* e)([\.\,])<\/i>([\.\,])/<\/$auEdr>$etal/gs;

  #$augText=~s/<\/$auEdr>([\,\;\.]?) et al([\.\,]?)/<\/$auEdr>$etal/gs;
  #$augText=~s/<\/$auEdr>([\,\;\.]?) etal([\.\,])/<\/$auEdr>$etal/gs;
  #$augText=~s/<\/$auEdr>([\,\;\.]?) <i>et al([\.\,])<\/i>([\.\,])/<\/$auEdr>$etal/gs;
  #$augText=~s/<\/$auEdr>([\,\;\.]?) <i>etal([\.\,])<\/i>([\.\,])/<\/$auEdr>$etal/gs;
  return $augText;
}

sub listSixAuthorEtalEdit{
  my $augText=shift;
  $augText=~s/^<au>((?:(?!<[\/]?au>).)*?)<\/au>([\,\;\/ ]*?)<au>((?:(?!<[\/]?au>).)*?)<\/au>([\,\;\/ ]*?)<au>((?:(?!<[\/]?au>).)*)<\/au>([\,\;\/ ]*?)<au>((?:(?!<[\/]?au>).)*)<\/au>([\,\;\/ ]*?)<au>((?:(?!<[\/]?au>).)*)<\/au>([\,\;\/ ]*?)<au>((?:(?!<[\/]?au>).)*)<\/au>([\,\;\/ ]*?)<au>((?:(?!<[\/]?au>).)*)<\/au>([\,\;\/ ]+|[\, ]+\&amp;\s*|[\, ]+\&hellip\;\s*|[\, ]+[aA][nN][dD]\s*)<au>((?:(?!<[\/]?au>).)*)<\/au>([\s]*)$/<au>$1<\/au>$2<au>$3<\/au>$4<au>$5<\/au>$6<au>$7<\/au>$8<au>$9<\/au>$10<au>$11<\/au>\, et al\./gs;
  $augText=~s/^<au>((?:(?!<[\/]?au>).)*)<\/au>([\,\;\/ ]*?)<au>((?:(?!<[\/]?au>).)*)<\/au>([\,\;\/ ]*?)<au>((?:(?!<[\/]?au>).)*)<\/au>([\,\;\/ ]*?)<au>((?:(?!<[\/]?au>).)*)<\/au>([\,\;\/ ]*?)<au>((?:(?!<[\/]?au>).)*)<\/au>([\,\;\/ ]*?)<au>((?:(?!<[\/]?au>).)*)<\/au>([\,\;\/ ]+|[\, ]+\&amp;\s*|[\, ]+\&hellip\;\s*|[\, ]+[aA][nN][dD]\s*)<au>((?:(?!<au>)(?!<\/au>).)*)<\/au>([\s]*)$/<au>$1<\/au>$2<au>$3<\/au>$4<au>$5<\/au>$6<au>$7<\/au>$8<au>$9<\/au>$10<au>$11<\/au>\, et al\./gs;
  $augText=~s/^<au>((?:(?!<[\/]?au>).)*)<\/au>([\,\;\/ ]*?)<au>((?:(?!<[\/]?au>).)*)<\/au>([\,\;\/ ]*?)<au>((?:(?!<[\/]?au>).)*)<\/au>([\,\;\/ ]*?)<au>((?:(?!<[\/]?au>).)*)<\/au>([\,\;\/ ]*?)<au>((?:(?!<[\/]?au>).)*)<\/au>([\,\;\/ ]*?)<au>((?:(?!<[\/]?au>).)*)<\/au>([\,\;\/ ]*?)<au>(.*)<\/au>([\,\;\/ ]+|[\, ]+\&amp;\s*|[\, ]+\&hellip\;\s*|[\, ]+[aA][nN][dD]\s*)<au>((?:(?!<[\/]?au>).)*)<\/au>([\s]*)$/<au>$1<\/au>$2<au>$3<\/au>$4<au>$5<\/au>$6<au>$7<\/au>$8<au>$9<\/au>$10<au>$11<\/au>\, et al\./gs;

  return $augText;
}

#===================================================================
sub authorFirstNameAbbreviateNodot{
  my $Fname=shift;

  $Fname=~s/(^|\. |\.)([A-Z]|[A-Z]\.[ ]?[A-Z])\.([ ]?[a-z])\./$1$2<TEMP>\.$3\./gs;
  $Fname=~s/^([A-Z])([a-z])\.([ ]?[A-Z]|[ ]?[A-Z]\.[ ]?[A-Z])\.$/$1<TEMP>$2\.$3\./gs;
  $Fname=~s/^([A-Z]|[A-Z]\.[ ]?[A-Z])\.([ ]?[A-Z])([a-z])\.$/$1\.$2<TEMP>$3\./gs;
  $Fname=~s/^([A-Z])\. ([A-Z])([^A-Z\.]+)$/$1 $2/gs;
  $Fname=~s/^([A-Z])([^A-Z\.]+)\-([A-Z])([^A-Z\.]+) ([A-Z])([^A-Z\.]+)$/$1\-$3 $5/gs;
  $Fname=~s/^([A-Z])([^A-Z\.]+)\-([A-Z])([^A-Z\.]+)$/$1\-$3/gs;
  $Fname=~s/^([A-Z])([^A-Z\.]+) (Th[\.]?)$/$1 $3/gs;
  $Fname=~s/^([A-Z])([^A-Z\.]+) ([A-Z])([^A-Z\.]+)$/$1 $3/gs;
  $Fname=~s/^([A-Z])([dhvtu][\.]?)$/$1<TEMP>$2/gs;
  $Fname=~s/^([A-Z])([^A-Z\-]+?)$/$1/gs;
  $Fname=~s/^(Ch[\.]?)([ ]?[A-Z])/$1<TEMP>$2/gs;
  $Fname=~s/^([A-Z])([dhvtu][\.]?) /$1<TEMP>$2 /gs;
  $Fname=~s/^([A-Z])([^A-Z\-<>]+?) /$1/gs;
  $Fname=~s/ ([A-Z])([^A-Z<>]*?) /$1/gs;
  $Fname=~s/ ([A-Z])([dhvtu][\.]?)$/ $1<TEMP>$2/gs;
  $Fname=~s/ ([A-Z])([^A-Z\-<>]*?)$/$1/gs;
  $Fname=~s/([\. ]+)//gs;
  $Fname=~s/<TEMP>//gs;
  $Fname=~s/<T.E.M.P.>//gs;

  return $Fname;
}

#===================================================================
sub authorFirstNameAbbreviateDot{
  my $Fname=shift;

  $Fname=~s/(^|\. |\.)([A-Z]|[A-Z]\.[ ]?[A-Z])\.([ ]?[a-z])\./$1$2<DOT>$3<DOT>/gs;
  $Fname=~s/^([A-Z])([a-z])\.([ ]?[A-Z]|[ ]?[A-Z]\.[ ]?[A-Z])\.$/$1<TEMP>$2<DOT>$3<DOT>/gs;
  $Fname=~s/^([A-Z]|[A-Z]\.[ ]?[A-Z])\.([ ]?[A-Z])([a-z])\.$/$1<DOT>$2<TEMP>$3<DOT>/gs;
  $Fname=~s/^([A-Z])([^A-Z\.]+)\-([A-Z])([^A-Z\.]+) ([A-Z])([^A-Z\.]+)$/$1\-$3 $5/gs;
  $Fname=~s/^([A-Z])([^A-Z\.]+)\-([A-Z])([^A-Z\.]+)$/$1\-$3/gs;
  $Fname=~s/^([A-Z])([^A-Z\.]+) (Th[\.]?)$/$1 $3/gs;
  $Fname=~s/^([A-Z])([^A-Z\.]+) ([A-Z])([^A-Z\.]+)$/$1 $3/gs;
  $Fname=~s/^([A-Z])([dhvtu][\.]?)$/$1<TEMP>$2/gs;
  $Fname=~s/^([A-Z])([^A-Z]*?)$/$1/gs;
  $Fname=~s/^(Ch[\.]?)([ ]?[A-Z])/$1<TEMP>$2/gs;
  $Fname=~s/^([A-Z])([dhvtu][\.]?) /$1<TEMP>$2 /gs;
  $Fname=~s/^([A-Z])([^A-Z<>]*?) /$1/gs;
  $Fname=~s/ ([A-Z])([^A-Z<>]*?) /$1/gs;
  $Fname=~s/ ([A-Z])([dhvtu][\.]?)$/ $1<TEMP>$2/gs;
  $Fname=~s/ ([A-Z])([^A-Z<>]*?)$/$1/gs;
  $Fname=~s/([A-Z])([A-Z])([^A-Z<>]*?)([A-Z])$/$1$2$4/gs;
  $Fname=~s/([\. ]+)//gs;
  $Fname=~s/([A-Z])([^a-z\.<>])/$1\.$2/gs;
  $Fname=~s/([A-Z])([^a-z\.<>])/$1\.$2/gs;
  $Fname=~s/(Ch)\b</$1\.</gs;
  $Fname=~s/([A-Z])$/$1\./gs;
  $Fname=~s/([A-Z]) /$1\. /gs;
  $Fname=~s/<TEMP>//gs;
  $Fname=~s/<T.E.M.P[.]?>//gs;
  $Fname=~s/<D[\.]?O[\.]?T[\.]?>/\./gs;

  return $Fname;
}
#===================================================================
sub DeleteOrgBib{
  my $FileText=shift;
  my $openOrgbibCount=$$FileText=~s/<orgbib>/<orgbib>/gs;
  my $closeOrgbibCount=$$FileText=~s/<\/orgbib>/<\/orgbib>/gs;
  if($openOrgbibCount ==  $closeOrgbibCount){
    $$FileText=~s/<orgbib>(.*?)<\/orgbib>//gs;
  }
  $$FileText=~s/<orgfootnote>(.*?)<\/orgfootnote>//gs;
  return $$FileText;
}
#===================================================================

sub addEditPagePrefix{
  my $FileText=shift;
  my $dotOption=shift;
  my $prefixPunc="";

  if ($dotOption eq "withdot"){
    $prefixPunc=".";
  }

  $$FileText=~s/<\/btg>((?:(?!<[\/]?ppg>)(?!<[\/]?btg>)(?!<[\/]?bib)(?!<[\/]?aug>).)*)<pgg>\&lt\;pg\&gt\;([a-zA-Z]?[0-9]+)([^a-zA-Z0-9\.\,\;\"\:\(\)\[\]\@\$\%\&\*\!\~\+\=\?\<\>\/]+)([a-zA-Z]?[0-9]+)\&lt\;\/pg\&gt\;<\/pgg>/<\/btg>$1<pgg>pp$prefixPunc \&lt\;pg\&gt\;$2$3$4\&lt\;\/pg\&gt\;<\/pgg>/gs;
  $$FileText=~s/<\/btg>((?:(?!<[\/]?ppg>)(?!<[\/]?btg>)(?!<[\/]?bib)(?!<[\/]?aug>).)*)<pgg>\&lt\;pg\&gt\;([a-zA-Z]?[0-9]+)\&lt\;\/pg\&gt\;<\/pgg>/<\/btg>$1<pgg>p$prefixPunc \&lt\;pg\&gt\;$2\&lt\;\/pg\&gt\;<\/pgg>/gs;
  $$FileText=~s/<\/(misc1g|btg)>((?:(?!<[\/]?ppg>)(?!<[\/]?misc1g>)(?!<[\/]?btg>)(?!<[\/]?bib)(?!<[\/]?aug>).)*)<pgg>p[\.]?[ ]?\&lt\;pg\&gt\;([a-zA-Z]?[0-9]+)([^a-zA-Z0-9\.\,\;\"\:\(\)\[\]\@\$\%\&\*\!\~\+\=\?\<\>\/]+)([a-zA-Z]?[0-9]+)\&lt\;\/pg\&gt\;<\/pgg>/<\/$1>$2<pgg>pp$prefixPunc \&lt\;pg\&gt\;$3$4$5\&lt\;\/pg\&gt\;<\/pgg>/gs;

  $$FileText=~s/<\/btg>((?:(?!<[\/]?ppg>)(?!<[\/]?btg>)(?!<[\/]?bib)(?!<[\/]?aug>).)*)<pgg>\&lt\;pg\&gt\;([a-zA-Z]+)([^a-zA-Z0-9\.\,\;\"\:\(\)\[\]\@\$\%\&\*\!\~\+\=\?\<\>\/]+)([a-zA-Z]+)\&lt\;\/pg\&gt\;<\/pgg>/<\/btg>$1<pgg>pp$prefixPunc \&lt\;pg\&gt\;$2$3$4\&lt\;\/pg\&gt\;<\/pgg>/gs;
  $$FileText=~s/<\/btg>((?:(?!<[\/]?ppg>)(?!<[\/]?btg>)(?!<[\/]?bib)(?!<[\/]?aug>).)*)<pgg>\&lt\;pg\&gt\;([a-zA-Z]+)\&lt\;\/pg\&gt\;<\/pgg>/<\/btg>$1<pgg>p$prefixPunc \&lt\;pg\&gt\;$2\&lt\;\/pg\&gt\;<\/pgg>/gs;
  $$FileText=~s/<\/(misc1g|btg)>((?:(?!<[\/]?ppg>)(?!<[\/]?misc1g>)(?!<[\/]?btg>)(?!<[\/]?bib)(?!<[\/]?aug>).)*)<pgg>p[\.]?[ ]?\&lt\;pg\&gt\;([a-zA-Z]+)([^a-zA-Z0-9\.\,\;\"\:\(\)\[\]\@\$\%\&\*\!\~\+\=\?\<\>\/]+)([a-zA-Z]+)\&lt\;\/pg\&gt\;<\/pgg>/<\/$1>$2<pgg>pp$prefixPunc \&lt\;pg\&gt\;$3$4$5\&lt\;\/pg\&gt\;<\/pgg>/gs;

  $$FileText=~s/<pgg>pp[\.]?[ ]?\&lt\;pg\&gt\;([a-zA-Z]?[0-9]+)\&lt\;\/pg\&gt\;<\/pgg>/<pgg>p\. \&lt\;pg\&gt\;$1\&lt\;\/pg\&gt\;<\/pgg>/gs;
  $$FileText=~s/<pgg>pp[\.]?[ ]?\&lt\;pg\&gt\;([ivxlIVXL]+)\&lt\;\/pg\&gt\;<\/pgg>/<pgg>p\. \&lt\;pg\&gt\;$1\&lt\;\/pg\&gt\;<\/pgg>/gs;

  # print $$FileText;

  return $$FileText;
}

#===================================================================

#Text Color Transformation Done
#Reference Styles2
