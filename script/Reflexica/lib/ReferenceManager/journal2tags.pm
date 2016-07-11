#version 1.0
#Author: Neyaz Ahmad
package ReferenceManager::journal2tags;
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(journalMarkFromIni);

BEGIN{
  $SCRITPATH=$0;
  $SCRITPATH=~s/(.*)([\/\\])(.*?)\.(pl|exe)/$1/g;
}

#=============================================================================================================================
sub journalMarkFromIni{
  my $TextBody=shift;
  my $application=shift;

  $JournalsNameRef=&readJournalINI($SCRITPATH);

  #-------------------------------------
   #use ReferenceManager::JournalNamesDB;
   #$JournalsNameRef=&SortedJournalNamesDB;
  #-------------------------------------

  #<i>J Gerontol B Psychol Sci Soc Sci <v>61</v> (<iss>1</iss>): <pg>P33-P45</pg></i>

  $TextBody=~s/<i>([A-Za-z]+[^<>]+?) <v>([^<>]+?)<\/v>([\, \(]+)<iss>([^<>]+?)<\/iss>([\:\, \)]+)<pg>([^<>]+?)<\/pg><\/i>/<i>$1<\/i> <i><v>$2<\/v>$3<iss>$4<\/iss>$5<pg>$6<\/pg><\/i>/gs;
  $TextBody=~s/<i>([A-Za-z]+[^<>]+?) <v>([^<>]+?)<\/v>([\, \(]+)<iss>([^<>]+?)<\/iss>([\:\, \)]+)<\/i>/<i>$1<\/i> <i><v>$2<\/v>$3<iss>$4<\/iss>$5<\/i>/gs;
  $TextBody=~s/<i>([A-Za-z]+[^<>]+?) <v>([^<>]+?)<\/v>([\,\: ]+)<pg>([^<>]+?)<\/pg><\/i>/<i>$1<\/i> <i><v>$2<\/v>$3<pg>$4<\/pg><\/i>/gs;

  my ($sleepCounter, $sleep1, $sleep2, $sleep3)=(0, 0, 0, 0);
  if (defined $application){
    if($application eq "AMPP" || $application eq "ampp"){
      # $sleep3=1;
      # $sleep1=0.01;
      # $sleep2=0.0001;
      $sleep3=0;
      $sleep1=0;
      $sleep2=0;
    }
  }

  foreach (@$JournalsNameRef)
   {
     my $Jname="$_";
     $Jname=~s/[ \t]/ /gs;
     $Jname=~s/([\s])$//gs;
     $Jname=~s/^([\s])//gs;
     $Jname=~s/[ \t]/ /gs;
     my $dotlessJname=$Jname;
     $dotlessJname=~s/ ([A-Z][a-z]+)\.$/ $1/s;
     $dotlessJname=~s/ ([A-Z])\.$/ $1/s;
     $TextBody=~s/\,<\/url>/<\/url>\,/gs;
     $TextBody=~s/<([ib])>\Q$dotlessJname\E([\,\.]?)<\/\1>/<pt><$1>$dotlessJname$2<\/$1><\/pt>/gs;
     $TextBody=~s/<([ib])>\Q$Jname\E([\,\.]?)<\/\1>/<pt><$1>$Jname$2<\/$1><\/pt>/gs;
     # $TextBody=~s/<b>\Q$Jname\E<\/b>/<pt><b>$Jname<\/b><\/pt>/gs;
     $TextBody=~s/\\textit\{\Q$Jname\E([\,\.]?)\}/<pt><i>$Jname$1<\/i><\/pt>/gs;

     $TextBody=~s/([\?\.\:\;\'\"\,\`\(\)\]”“]+\s*|<\/i>\s*|\\newblock\s*|’\s+|\s+|[��]\s+|\&quot\;\s+|<\/yr>[\.\,]? | [a-z]+ [a-z]+ )\Q$Jname\E([\?\,\.\'\"\:\;\)\( ]+)<(yr|v|iss|doig|doi|\/bib)>/$1<pt>$Jname<\/pt>$2<$3>/gs;
     $TextBody=~s/([\?\.\:\;\'\"\,\`\(\)\]”“]+\s*|<\/i>\s*|\\newblock\s*|’\s+|\s+|[��]\s+|&quot\;\s+|<\/yr>[\.\,]?| [a-z]+ [a-z]+ )\Q$dotlessJname\E([\?\,\.\'\"\:\;\)\( ]+)<(yr|v|doig|doi|\/bib)>/$1<pt>$dotlessJname<\/pt>$2<$3>/gs;
     $TextBody=~s/([\?\.\:\;\'\"\,\`\(\)\]”“]+\s*|<\/i>\s*|\\newblock\s*|’\s+|\s+|[��]\s+|\&quot\;\s+|<\/yr>[\.\,]? | [a-z]+ [a-z]+ )\Q$Jname\E([\.\, ]+\[[a-zA-Z0-9 ]+\][\.\,\; ]+)<(yr|v|doig|doi|\/bib)>/$1<pt>$Jname<\/pt>$2<$3>/gs;


     # while ($TextBody =~ m/([\?\.\:\;\'\"\,\`\(\)\]]\s*)(?i)\Q$Jname\E(?-i)/gsi){
     #   print "xx\t$&\n";
     # }

     $TextBody=~s/([\?\.\:\;\'\"\,\`\(\)\]”“]+\s*|<\/i>\s*|\\newblock\s*|’\s+|\s+|[��]\s+|\&quot\;\s+|In[\:\. ][Ii]n[\:\.] |<\/yr>[\.\,]? | [a-z]+ [a-z]+ )\Q$Jname\E([\?\,\.\'\"\:\;\)\( ]+)([vV]ol[\.]? [Nn]o[. ]*|[Vv][\. ]*|[Vv][Oo][Ll][s]?[\. ]*|[Bb]and[\. ]*|\([\w\(\)\d\:\.\,\- ]+\)[ ]*)<(yr|v|doig|doi)>/$1<pt>$Jname<\/pt>$2$3<$4>/gs;
     $TextBody=~s/([\?\.\:\;\'\"\,\`\(\)\]”“]+\s*|<\/i>\s*|\\newblock\s*|’\s+|\s+|[��]\s+|\&quot\;\s+|In[\:\. ][Ii]n[\:\.] |<\/yr>[\.\,]? | [a-z]+ [a-z]+ )\Q$Jname\E([\?\,\.\'\"\:\;\)\( ]+)([vV]ol[\.]? [Nn]o[. ]*||<[bi]>[Vv][\. ]*|[Vv][Oo][Ll][s]?[\. ]*|[Bb]and[\. ]*)<(yr|v|doig|doi)>/$1<pt>$Jname<\/pt>$2$3<$4>/gs;
     $TextBody=~s/([\?\.\:\;\'\"\,\`\(\)\]”“]+\s*|<\/i>\s*|\\newblock\s*|’\s+|\s+|[��]\s+|\&quot\;\s+|In[\:\. ]|[Ii]n[\:\.] |<\/yr>[\.\,]? | [a-z]+ [a-z]+ )\Q$Jname\E([\?\,\.\'\"\:\;\)\( ]+)<([bi])><v>/$1<pt>$Jname<\/pt>$2<$3><v>/gs;
     $TextBody=~s/([\?\.\:\;\'\"\,\`\(\)\]”“]+\s*|<\/i>\s*|\\newblock\s*|’\s+|\s+|[��]\s+|\&quot\;\s+|In[\:\. ]|[Ii]n[\:\.] |<\/yr>[\.\,]? | [a-z]+ [a-z]+ )\Q$Jname\E([\,\;\. ]+)\(([Ii]n [pP]ress|[Ii]n [pP]rint)\)/$1<pt>$Jname<\/pt>$2\($3\)/gs;
 #    $TextBody=~s/([\?\.\:\;\'\"\,\`\(\)\]]+\s*|<\/i>\s*|\\newblock\s*|’\s+)\Q$Jname\E([\?\,\.\'\"\:\;\) ]+)<b><v>/$1<pt>$Jname<\/pt>$2<b><v>/gs;
     $TextBody=~s/([\?\.\:\;\'\"\,\`\(\)\]”“]+\s*|<\/i>\s*|\\newblock\s*|’\s+|\s+|[��]\s+|\&quot\;\s+|In[\:\. ][Ii]n[\:\.] |<\/yr>[\.\,]? | [a-z]+ [a-z]+ )\Q$Jname\E<v>/$1<pt>$Jname<\/pt><v>/gs;

     $TextBody=~s/([\?\.\:\;\'\"\,\`\(\)\]”“]+\s*|<\/i>\s*|\\newblock\s*|’\s+|\s+|[��]\s+|\&quot\;\s+|<\/yr>[\.\,]? | [a-z]+ [a-z]+ )\Q$Jname\E([\?\,\.\'\"\:\;\)\( ]+)([0-9]+)/$1<pt>$Jname<\/pt>$2$3/gs;
     $TextBody=~s/ (\\newblock|[a-z0-9]+) \Q$Jname\E([\?\,\.\'\"\:\;\)\( ]+)<(yr|v|doig|doi)>/ $1 <pt>$Jname<\/pt>$2<$3>/gs;
     $TextBody=~s/ (\\newblock|[a-z0-9]+) \Q$Jname\E([\?\,\.\'\"\:\;\)\( ]+)<([bi])><v>/ $1 <pt>$Jname<\/pt>$2<$3><v>/gs;

     $TextBody=~s/(In[\:\.]?)([\s]*)\Q${Jname}\E([\?\,\.\'\"\:\;\)\( ]?)([ ]?[vV]ol[\.]? [Nn]o[. ]*|[ ]?[vV][Oo][Ll][s]?|[ ]?[Bb]and)\b/$1$2<pt>$Jname<\/pt>$3$4/gs;
     $TextBody=~s/(In[\:\.]?)([\s]*)\Q${Jname}\E([\?\,\.\'\"\:\;\)\( ])/$1$2<pt>$Jname<\/pt>$3/gs;
     #J Neuroimaging. Apr <yr>2007</yr>;<v>17</v>*********
     $TextBody=~s/([\?\.\:\;\'\"\,\`\(\)\]”“]+\s*|<\/i>\s*|\\newblock\s*|’\s+|\s+|[��]\s+|\&quot\;\s+|<\/yr>[\.\,]? | [a-z]+ [a-z]+ )\Q$Jname\E([\?\,\.\'\"\:\;\)\(]+ )((?:(?!<bib[^<>]*?>)(?!<[\/]?pt>)(?!<[\/]?doi[g]?>)(?!<[\/]?url>)(?!<[\/]?v>)(?!<\/bib>).)*?)<(v|doig|doi)>/$1<pt>$Jname<\/pt>$2$3<$4>/gs;
     $TextBody=~s/<i>\Q$Jname\E<\/i>((?:(?!<bib[^<>]*?>)(?!<[\/]?pt>)(?!<[\/]?doi[g]?>)(?!<[\/]?url>)(?!<[\/]?v>)(?!<\/bib>).)*?)<(v|doig|doi)>/<pt><i>$Jname<\/i><\/pt>$2<$3>/gs;

     $TextBody=~s/ \Q$Jname\E([\?\,\.\'\"\:\;\)\( ]+)<(yr|v|doig|doi)>/ <pt>$Jname<\/pt>$1<$2>/gs;
     $TextBody=~s/ \Q$Jname\E([\?\,\.\'\"\:\;\)\( ]+)<([bi])><v>/ <pt>$Jname<\/pt>$1<$2><v>/gs;

     #select(undef, undef, undef, $sleep2);
    # if($sleepCounter == 500){
    #   $sleepCounter=0;
    #   sleep $sleep3;
    #   #select(undef, undef, undef, $sleep1);
    # }
     $sleepCounter++;
   }


  #select(undef, undef, undef, 0.1);

 while($TextBody=~s/<comment>((?:(?!<[\/]?comment>)(?!<bib)(?!<\/bib>).)+?)<(pt|cny|pbl)>([^<>]*?)<\/\2>((?:(?!<[\/]?comment>)(?!<bib)(?!<\/bib>).)*?)<\/comment>/<comment>$1$3$4<\/comment>/gs){}

   {}while($TextBody=~s/<pt><pt>((?:(?!<bib[^<>]*?>)(?!<\/bib>).)*?)<\/pt><\/pt>/<pt>$1<\/pt>/gs);
  $TextBody=~s/<pt><pt>((?:(?!<\/pt>)(?!<bib)(?!<\/bib>)(?!<pt>).)*?)<\/pt><\/pt>/<pt>$1<\/pt>/gs;
  $TextBody=~s/<pt><pt>((?:(?!<\/pt>)(?!<bib)(?!<\/bib>)(?!<pt>).)*?)<\/pt><\/pt>/<pt>$1<\/pt>/gs;

  $TextBody=~s/\. In <pt>([^<>]+?)<\/pt> ([^<>]+?)([\(\.\,\; ]+)$regx{editorSuffix}([\.\,\)]+)/\. In $1 $2$3$4$5/gs;

  $TextBody=~s/<pt>((?:(?!<[\/]?pt>)(?!<bib)(?!<\/bib>).)*?)<pt>((?:(?!<[\/]?pt>)(?!<bib)(?!<\/bib>).)*?)<\/pt>((?:(?!<[\/]?pt>)(?!<bib)(?!<\/bib>).)*)<\/pt>/<pt>$1$2$3<\/pt>/gs;
  $TextBody=~s/<pt>((?:(?!<[\/]?pt>)(?!<bib)(?!<\/bib>).)*?)<pt>((?:(?!<[\/]?pt>)(?!<bib)(?!<\/bib>).)*?)<\/pt><\/pt>/<pt>$1$2<\/pt>/gs;
  $TextBody=~s/<pt><pt>((?:(?!<[\/]?pt>)(?!<bib)(?!<\/bib>).)*?)<\/pt>((?:(?!<[\/]?pt>)(?!<bib)(?!<\/bib>).)*?)<\/pt>/<pt>$1$2<\/pt>/gs;

  $TextBody=~s/([a-z]+) <pt>((?:(?!<[\/]?pt>)(?!<bib)(?!<\/bib>).)*?)<\/pt>\. <pt>/ $1 $2\. <pt>/gs;
  $TextBody=~s/([a-z]+)\, <pt>((?:(?!<[\/]?pt>)(?!<bib)(?!<\/bib>).)*?)<\/pt>\. <pt>/$1\, $2\. <pt>/gs;

  return $TextBody;
}

#=============================================================================================================================

sub readJournalINI{
  my $SCRITPATH=shift;
  undef $/;
  open(JOURNALINI, "<$SCRITPATH/JournalNamesDB.ini")||die("\n\n$SCRITPATH/JournalNamesDB.ini File cannot be opened\n\nPlease check the file...\n\n");
  my  $JournaliniText=<JOURNALINI>;
  close(JOURNALINI);
  my %Journalini;
  my @Journalini=();
  # select(undef, undef, undef, 0.02);
  while($JournaliniText=~m/<pt>(.*?)<\/pt>/g){
    $Journalini{$1}="";
      push (@Journalini, $1);
   # select(undef, undef, undef, 0.0005);
    }
  #select(undef, undef, undef, 0.02);
  undef $JournaliniText;
  my @SortedJournalini =  map { $_->[0] } sort { $b->[1] <=> $a->[1] } map { [ $_, length($_) ] } @Journalini;

  return \@SortedJournalini;
}

#=============================================================================================================================


return 1;