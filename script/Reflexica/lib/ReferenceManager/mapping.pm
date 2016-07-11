#version 1.0
#Author: Neyaz Ahmad
package ReferenceManager::mapping;
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(YrVolIssPg VolIssPg loosePage authorMark proceedings);

use ReferenceManager::ReferenceRegex;
my %regx = ReferenceManager::ReferenceRegex::new();

sub proceedings{
  my $TextBody = shift;
  while($TextBody =~ /<bib([^<>]*?)>((?:(?!<\/bib>).)*?)<\/bib>/s) {
    my ($bibid, $eachBibData) = ($1, $2);
    $eachBibData = &mark_proceedings($eachBibData);
    $TextBody =~ s/<bib([^<>]*?)>((?:(?!<\/bib>).)*?)<\/bib>/<xbib$1>$eachBibData<\/xbib>/s;
  }
  $TextBody =~ s/<(?:([\/]?))xbib([^<>]*?)>/<$1bib$2>/sg;
  return $TextBody;
}

 sub mark_proceedings{
  my $eachBibData = shift;
  my @prevTag = qw(sub sup);
  use ReferenceManager::ReferenceRegex;
  my %regx = ReferenceManager::ReferenceRegex::new();
  $eachBibData=~s/ (In: [^<>\,\.]+?) <yr>(\d\d\d\d)<\/yr>[\:]? ([Cc]onference|[Pp]roceeding[s]?|IEEE [Ss]ymposium|Symposium)/ $1 $2\: $3/gs;
  $eachBibData=~s/([Pp]roceeding[s]? of the|[Pp]roceeding[s]? of the [^<>\.\,\:\;]+?) <yr>(\d\d\d\d)<\/yr>/$1 $2/gs;
  $eachBibData =~ s/<$_>((?:(?!<\/$_>).)*?)<\/$_>/\&\#$_\#\&$1\&\#\#$_\#\#\&/g foreach (@prevTag);
  $eachBibData =~ s/<pt>Proceedings<\/pt>/Proceedings/g;

  $eachBibData =~ s/((?:[. ,;:]*?|[Ii]n[:. ]*?|<[i|b]>)\s*)(Conference Proceedings(?:(?:[^<>]*))|Proceedings(?:(?:[^<>]*))|IEEE [Ss]ymposiumon(?:(?:[^<>]*)))/$1<collab>$2<\/collab>/s;
  $eachBibData =~ s/([\?\.] In[\:\.][ ]?)(Proceedings(?:(?:[^<>]*))|IEEE [Ss]ymposiumon(?:(?:[^<>]*))|Proc\.(?:(?:[^<>]*))|Symposium(?:(?:[^<>]*)))/$1<collab>$2<\/collab>/s;
  $eachBibData =~ s/([\?\.] In[\:\.][ ]?)([A-Z][A-Za-z ]+[ \'0-9\:]+)<collab>(Proceedings|IEEE [Ss]ymposiumon|Conference|Symposium)/$1<collab>$2$3/s;

  $eachBibData =~ s/([., ;]*?)<\/collab>/<\/collab>$1/gs;
  $eachBibData =~ s/<i><collab>((?:(?!<[\/]?bib>).)*?)<\/collab><\/i>/<collab><i>$1<\/i><\/collab>/s;
  $eachBibData =~ s/<pt><collab>((?:(?!<[\/]?bib>).)*?)<\/collab><\/pt>/<pt>$1<\/pt>/s;
  $eachBibData =~ s/\&\#$_\#\&((?:(?!\&\#\#$_\#\#\&).)*?)\&\#\#$_\#\#\&/<$_>$1<\/$_>/g foreach (@prevTag);

#$regx{monthPrefix}
  $eachBibData =~ s/([\.\,\; ]+)\(<\/collab>/<\/collab>$1\(/gs;
  $eachBibData =~ s/([\.\,\; ]+)\($regx{monthPrefix}<\/collab>/<\/collab>$1\($2/gs;
  $eachBibData =~ s/([\.\,\; ]+)$regx{pagePrefix}<\/collab>/<\/collab>$1$2/gs;
  $eachBibData =~ s/\, $regx{pagePrefix}$regx{optionalSpace}$regx{page}([^<>]+?)<\/collab>/<\/collab>\, $1$2$3$4/gs;
  $eachBibData =~ s/\, $regx{volumePrefix}$regx{optionalSpace}$regx{volume}<\/collab>/<\/collab>\, $1$2$3/gs;
  $eachBibData =~ s/<collab>([^<>]+?)([\.\,]) ([eE]dited by) ([^<>]+?)<\/collab>/<collab>$1<\/collab>$2 $3 <edrg>$4<\/edrg>/gs;
  $eachBibData =~ s/([\.\,]? [Ii]n[:\.]? )<collab>([^<>]+?)\, ([eE]ds|[Ee]ditor) ([^<>]+?)<\/collab>\, <cny>/$1<collab>$2<\/collab>\, $3 <edrg>$4<\/edrg>\, <cny>/gs;

  return $eachBibData;
}

#================================================================================================================================
sub YrVolIssPg{
  my $TextBody=shift;
  my $application=shift;

  my ($sleepCounter, $sleep1, $sleep2)=(0, 0, 0);
  if (defined $application){
    if($application eq "AMPP" || $application eq "ampp"){
      # $sleep1=0.001;
      # $sleep2=0.001;
       $sleep1=0;
       $sleep2=0;
    }
  }


  $TextBody=~s/[ ]?\& nbsp\;/ /gs;

  $TextBody=~s/ ([pPS]+[\. ]+)([\d]+)\s*([\–\-]+)\s*([\d]+)/ $1$2$3$4/gs; ###
  $TextBody=~s/\&\#150\;/\-\-/gs;
  $TextBody=~s/(\) |\, |\:\s?)([0-9]+)\- ([0-9]+)([\.]?)<\/bib>/$1$2\-$3$4<\/bib>/gs;
  $TextBody=~s/(\) |\, |\:\s?)([0-9]+)\- ([0-9]+)([\.\, ]+)(doi|Doi|DOI)/$1$2\-$3$4$5/gs;

  #-------------for single year instead of issue.------------
  while($TextBody=~/<bib([^<>]*?)>((?:(?!<bib)(?!<\/bib).)*)<\/bib>/os)
    {
      my $Bibtextbody=$2;
      my $Bibtext="<bib$1>$2<\/bib>";

      my $yearcount=$Bibtextbody=~s/(1[987][0-9][0-9]|20[0-9][0-9])/$1/gs;
      if($yearcount eq 1)
	{
	  $Bibtext=~s/ \($regx{year}\)\, vol\. $regx{volume}\, no\. $regx{issue}\, $regx{pagePrefix}$regx{optionalSpace}$regx{page}<\/bib>/ \(<yr>$1<\/yr>\), vol\. <v>$2<\/v>, no\. <iss>$3<\/iss>, $4$5<pg>$6<\/pg><\/bib>/gs;

	  #, vol. 12, no. 9, pp. 1724-1736, Sept. 2013.</bib>
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{puncSpace}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{issuePunc}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionalPuncSpace}$regx{monthPrefix}$regx{optionalPuncSpace}$regx{year}$regx{optionaEndPunc}$regx{extraInfo}/$1$2$3<v>$4<\/v>$5$6$7<iss>$8<\/iss>$9$10$11<pg>$12<\/pg>$13$14$15<yr>$16<\/yr>$17$18/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{puncSpace}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{issuePunc}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionalPuncSpace}$regx{year}$regx{optionaEndPunc}$regx{extraInfo}/$1$2$3<v>$4<\/v>$5$6$7<iss>$8<\/iss>$9$10$11<pg>$12<\/pg>$13<yr>$14<\/yr>$15$16/gs;

	  $Bibtext=~s/$regx{wordPuncPrefix}<b>$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)<\/b>$regx{issuePunc}$regx{page}$regx{optionalPuncSpace}\($regx{year}\)$regx{extraInfo}/$1<v><b>$2<\/b><\/v>$3<b>\(<iss>$4<\/iss>\)<\/b>$5<pg>$6<\/pg>$7<yr>$8<\/yr>$9/gs;
	  #<b>28 (5)</b>, 103–109 (1994)
	  #$Bibtext=~s/$regx{wordPuncPrefix}<b>$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)<\/b>$regx{optionalPuncSpace}\($regx{year}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<v><b>$2<\/b><\/v>$3<b>\(<iss>$4<\/iss>\)<\/b>$5\(<yr>$6<\/yr>\)$7<pg>$8<\/pg>$9$10/gs;

	  #10 Suppl 2 (2011) S114–128.</bib>
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volume}$regx{optionalSpace}$regx{issuePrefix} $regx{issue}$regx{issuePunc}\($regx{year}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<v>$2<\/v>$3$4 <iss>$5<\/iss>$6\(<yr>$7<\/yr>\)$8<pg>$9<\/pg>$10$11/g;

	  #1988 Aug;8(4 Suppl):31S–37S
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{year} $regx{monthPrefix}$regx{puncSpace}$regx{volume}$regx{optionalSpace}\($regx{issue} $regx{issuePrefix}\)$regx{issuePunc}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr> $3$4<v>$5<\/v>$6\(<iss>$7<\/iss> $8\)$9<pg>$10<\/pg>$11$12/g;
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{year} $regx{monthPrefix}$regx{puncSpace}$regx{volume}$regx{optionalSpace}\($regx{issue} $regx{issuePrefix} $regx{issue}\)$regx{issuePunc}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr> $3$4<v>$5<\/v>$6\(<iss>$7 $8 $9<\/iss>\)$10<pg>$11<\/pg>$12$13/g;
	  #1988 Dec;20 Suppl 5:75–78
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{year} $regx{monthPrefix}$regx{puncSpace}$regx{volume} $regx{issuePrefix} $regx{issue}\:$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr> $3$4<v>$5<\/v> $6 <iss>$7<\/iss>\:<pg>$8<\/pg>$9$10/g;

	  #1998. 50(2 Suppl 1): S23–6.
	  $Bibtext=~s/$regx{optionalSpace}$regx{year}$regx{puncSpace}$regx{volume}$regx{optionalSpace}\($regx{issue} $regx{issuePrefix} $regx{issue}\)$regx{issuePunc}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v>$4<\/v>$5\(<iss>$6 $7 $8<\/iss>\)$9<pg>$10<\/pg>$11$12/g;
	  $Bibtext=~s/$regx{optionalSpace}$regx{year}$regx{puncSpace}<b>$regx{volume}<\/b>$regx{optionalSpace}\($regx{issue} $regx{issuePrefix} $regx{issue}\)$regx{issuePunc}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v><b>$4<\/b><\/v>$5\(<iss>$6 $7 $8<\/iss>\)$9<pg>$10<\/pg>$11$12/g;
	  $Bibtext=~s/$regx{optionalSpace}$regx{year}$regx{puncSpace}<i>$regx{volume}<\/i>$regx{optionalSpace}\($regx{issue} $regx{issuePrefix} $regx{issue}\)$regx{issuePunc}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v><i>$4<\/i><\/v>$5\(<iss>$6 $7 $8<\/iss>\)$9<pg>$10<\/pg>$11$12/g;

	  #1998. 50(2 Suppl 1): p. S23–6.
	  $Bibtext=~s/$regx{optionalSpace}$regx{year}$regx{puncSpace}$regx{volume}$regx{optionalSpace}\($regx{issue} $regx{issuePrefix} $regx{issue}\)$regx{issuePunc}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v>$4<\/v>$5\(<iss>$6 $7 $8<\/iss>\)$9$10$11<pg>$12<\/pg>$13$14/g;
	  $Bibtext=~s/$regx{optionalSpace}$regx{year}$regx{puncSpace}<b>$regx{volume}<\/b>$regx{optionalSpace}\($regx{issue} $regx{issuePrefix} $regx{issue}\)$regx{issuePunc}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v><b>$4<\/b><\/v>$5\(<iss>$6 $7 $8<\/iss>\)$9$10$11<pg>$12<\/pg>$13$14/g;
	  $Bibtext=~s/$regx{optionalSpace}$regx{year}$regx{puncSpace}<i>$regx{volume}<\/i>$regx{optionalSpace}\($regx{issue} $regx{issuePrefix} $regx{issue}\)$regx{issuePunc}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v><i>$4<\/i><\/v>$5\(<iss>$6 $7 $8<\/iss>\)$9$10$11<pg>$12<\/pg>$13$14/g;


	  #35(Suppl 5):S33-S36, 1994.</bib>
	  $Bibtext=~s/$regx{optionalSpace}$regx{volume}$regx{optionalSpace}\($regx{issuePrefix}$regx{optionalSpace}$regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{pagePunc}$regx{year}$regx{optionaEndPunc}$regx{extraInfo}/$1<v>$2<\/v>$3\($4$5<iss>$6<\/iss>\)$7<pg>$8<\/pg>$9<yr>$10<\/yr>$11$12/g;
	  #35(5):S33-S36, 1994.</bib>
	  $Bibtext=~s/$regx{optionalSpace}$regx{volume}$regx{optionalSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{pagePunc}$regx{year}$regx{optionaEndPunc}$regx{extraInfo}/$1<v>$2<\/v>$3\(<iss>$4<\/iss>\)$5<pg>$6<\/pg>$7<yr>$8<\/yr>$9$10/g;
	  $Bibtext=~s/$regx{optionalSpace}<b>$regx{volume}<\/b>$regx{optionalSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{pagePunc}$regx{year}$regx{optionaEndPunc}$regx{extraInfo}/$1<v><b>$2<\/b><\/v>$3\(<iss>$4<\/iss>\)$5<pg>$6<\/pg>$7<yr>$8<\/yr>$9$10/g;
	  #<b>35</b>(5):S33-S36, (1994).</bib>
	   $Bibtext=~s/$regx{optionalSpace}$regx{volume}$regx{optionalSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{puncSpace}\($regx{year}\)$regx{optionaEndPunc}$regx{extraInfo}/$1<v>$2<\/v>$3\(<iss>$4<\/iss>\)$5<pg>$6<\/pg>$7\(<yr>$8<\/yr>\)$9$10/g;
	  $Bibtext=~s/$regx{optionalSpace}<b>$regx{volume}<\/b>$regx{optionalSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{puncSpace}\($regx{year}\)$regx{optionaEndPunc}$regx{extraInfo}/$1<v><b>$2<\/b><\/v>$3\(<iss>$4<\/iss>\)$5<pg>$6<\/pg>$7\(<yr>$8<\/yr>\)$9$10/g;
	  $Bibtext=~s/$regx{optionalSpace}<i>$regx{volume}<\/i>$regx{optionalSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{puncSpace}\($regx{year}\)$regx{optionaEndPunc}$regx{extraInfo}/$1<v><i>$2<\/i><\/v>$3\(<iss>$4<\/iss>\)$5<pg>$6<\/pg>$7\(<yr>$8<\/yr>\)$9$10/g;

	  #$Bibtext=~s/$regx{optionalSpace}$regx{volume}$regx{optionalSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{pagePunc}([\(]?)$regx{year}([\)]?)$regx{optionaEndPunc}$regx{extraInfo}/$1<v>$2<\/v>$3\(<iss>$4<\/iss>\)$5<pg>$6<\/pg>$7$8<yr>$9<\/yr>$10$11$112/g;

	  #2012 J Biol Chem. 287(46):38625–36</bib>
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{year} ([^0-9\(\)<>\.\,\+\%\@\[\]]+)\. $regx{volume}$regx{optionalSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfoNoComment}/$1<yr>$2<\/yr> $3\. <v>$4<\/v>$5\(<iss>$6<\/iss>\)$7<pg>$8<\/pg>$9$10/g;

	  #134 (9 Pt 1) (2001) 795
	  $Bibtext=~s/$regx{optionalSpace}$regx{volume}$regx{optionalSpace}\($regx{issue} (\p{L}+ \d+)\) \($regx{year}\) $regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<v>$2<\/v>$3\(<iss>$4 $5<\/iss>\) \(<yr>$6<\/yr>\) <pg>$7<\/pg>$8$9/g;
	  # 81(8) (1984) pp 3684-3690</bib>
	  $Bibtext=~s/$regx{optionalSpace}$regx{volume}$regx{optionalSpace}\($regx{issue}\) \($regx{year}\) $regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<v>$2<\/v>$3\(<iss>$4<\/iss>\) \(<yr>$5<\/yr>\) $6$7<pg>$8<\/pg>$9$10/g;

	  #2006 Nov 20;<b>185</b>(10):562-64.</bib>
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{year}([\.]?) $regx{monthPrefix} $regx{month}([\.\,\; ]+)<b>$regx{volume}<\/b>$regx{optionalPuncSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3 $4 $5$6<b><v>$7<\/v><\/b>$8\(<iss>$9<\/iss>\)$10<pg>$11<\/pg>$12$13/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{year}([\.]?) $regx{monthPrefix} $regx{month}([\.\,\; ]+)<i>$regx{volume}<\/i>$regx{optionalPuncSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3 $4 $5$6<v><i>$7<\/i><\/v>$8\(<iss>$9<\/iss>\)$10<pg>$11<\/pg>$12$13/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{year}([\.]?) $regx{monthPrefix} $regx{month}([\.\,\; ]+)$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3 $4 $5$6<v>$7<\/v>$8\(<iss>$9<\/iss>\)$10<pg>$11<\/pg>$12$13/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{year}([\.]?) $regx{monthPrefix}([\:\.\,\; ]+)<b>$regx{volume}<\/b>$regx{optionalPuncSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3 $4$5<b><v>$6<\/v><\/b>$7\(<iss>$8<\/iss>\)$9<pg>$10<\/pg>$11$12/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{year}([\.]?) $regx{monthPrefix}([\:\.\,\; ]+)<i>$regx{volume}<\/i>$regx{optionalPuncSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3 $4$5<v><i>$6<\/i><\/v>$7\(<iss>$8<\/iss>\)$9<pg>$10<\/pg>$11$12/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{year}([\.]?) $regx{monthPrefix}([\:\.\,\; ]+)$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3 $4$5<v>$6<\/v>$7\(<iss>$8<\/iss>\)$9<pg>$10<\/pg>$11$12/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{year}([\.]?) $regx{monthPrefix}([\:\.\,\; ]+)<b>$regx{volume}<\/b>\:$regx{page}$regx{optionaEndPunc}$regx{extraInfoNoComment}/$1<yr>$2<\/yr>$3 $4$5<v><b>$6<\/b><\/v>\:<pg>$7<\/pg>$8$9/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{year}([\.]?) $regx{monthPrefix}([\:\.\,\; ]+)$regx{volume}\:$regx{page}$regx{optionaEndPunc}$regx{extraInfoNoComment}/$1<yr>$2<\/yr>$3 $4$5<v>$6<\/v>\:<pg>$7<\/pg>$8$9/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{year}([\.]?) $regx{monthPrefix}$regx{puncSpace}$regx{dateDay}([\.\,\; ]+)$regx{volume}\:$regx{page}$regx{optionaEndPunc}$regx{extraInfoNoComment}/$1<yr>$2<\/yr>$3 $4$5$6$7<v>$8<\/v>\:<pg>$9<\/pg>$10$11/gs;

	  #Modern Physics A <b>15</b>, (2000), 4341--4353.</bib>
	  #. <b>1</b> (1997) 108-121</bib>
	  $Bibtext=~s/$regx{wordPuncPrefix}<b>$regx{volume}<\/b>$regx{optionalPuncSpace}\($regx{year}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<v><b>$2<\/b><\/v>$3\(<yr>$4<\/yr>\)$5<pg>$6<\/pg>$7<\/bib>/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}<b>$regx{volume}<\/b>$regx{optionalPuncSpace}\(([A-Z][a-z]+[\.]? )$regx{year}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<v><b>$2<\/b><\/v>$3\($4<yr>$5<\/yr>\)$6<pg>$7<\/pg>$8<\/bib>/gs;

	  #<b>35 (3)</b> (1981) 148--150</bib>
	  $Bibtext=~s/$regx{wordPuncPrefix}<b>$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)<\/b>$regx{optionalPuncSpace}\($regx{year}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<v><b>$2<\/b><\/v>$3<b>\(<iss>$4<\/iss>\)<\/b>$5\(<yr>$6<\/yr>\)$7<pg>$8<\/pg>$9$10/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}<b>$regx{volume}<\/b>$regx{optionalPuncSpace}\($regx{issue}\)$regx{optionalPuncSpace}\($regx{year}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<v><b>$2<\/b><\/v>$3\(<iss>$4<\/iss>\)$5\(<yr>$6<\/yr>\)$7<pg>$8<\/pg>$9$10/gs;

	  #53 (6) (2008) 699-723; discussion 
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)$regx{optionalPuncSpace}\($regx{year}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<v>$2<\/v>$3\(<iss>$4<\/iss>\)$5\(<yr>$6<\/yr>\)$7<pg>$8<\/pg>$9$10/gs;

	  #. 2013 Apr;27(2):194-7</bib>
	  $Bibtext=~s/$regx{wordPuncPrefix} $regx{year} $regx{monthPrefix}([\:\.\,\; ]+)$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1 <yr>$2<\/yr> $3$4<v>$5<\/v>$6\(<iss>$7<\/iss>\)$8<pg>$9<\/pg>$10$11/gs;

	  #vol 53, no 4 (Sept. 1963), p 717–725
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{puncSpace}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{optionalPuncSpace}\($regx{monthPrefix}$regx{optionalPuncSpace}$regx{year}\)$regx{puncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1$2$3<v>$4<\/v>$5$6$7<iss>$8<\/iss>$9\($10$11<yr>$12<\/yr>\)$13<pg>$14<\/pg>$15$16/gs;

	  #, vol. 2, Oct. 2003, pp. 1527–1532.</bib>
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{puncSpace}$regx{monthPrefix}$regx{optionalPuncSpace}$regx{year}$regx{puncSpace}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1$2$3<v>$4<\/v>$5$6$7<yr>$8<\/yr>$9$10$11<pg>$12<\/pg>$13$14/gs;
	  #vol.~10, pp. 359--366, Jul. 2004. [online]
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{puncSpace}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionalPuncSpace}$regx{monthPrefix}$regx{optionalPuncSpace}$regx{year}$regx{optionaEndPunc}$regx{extraInfo}/$1$2$3<v>$4<\/v>$5$6$7<pg>$8<\/pg>$9$10$11<yr>$12<\/yr>$13$14/gs;

	  #. (2) <b>48</b>, 285-289 (1947)</bib>
	  $Bibtext=~s/$regx{wordPuncPrefix}\($regx{issue}\)$regx{optionalPuncSpace}<b>$regx{volume}<\/b>$regx{puncSpace}$regx{page}$regx{optionalPuncSpace}\($regx{year}\)$regx{optionaEndPunc}<\/bib>/$1\(<iss>$2<\/iss>\)$3<v><b>$4<\/b><\/v>$5<pg>$6<\/pg>$7\(<yr>$8<\/yr>\)$9<\/bib>/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}\($regx{issue}\)$regx{optionalPuncSpace}<i>$regx{volume}<\/i>$regx{puncSpace}$regx{page}$regx{optionalPuncSpace}\($regx{year}\)$regx{optionaEndPunc}<\/bib>/$1\(<iss>$2<\/iss>\)$3<v><i>$4<\/i><\/v>$5<pg>$6<\/pg>$7\(<yr>$8<\/yr>\)$9<\/bib>/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}\($regx{issue}\)$regx{optionalPuncSpace}<b>$regx{volume}<\/b>$regx{puncSpace}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionalPuncSpace}\($regx{year}\)$regx{optionaEndPunc}<\/bib>/$1\(<iss>$2<\/iss>\)$3<v><b>$4<\/b><\/v>$5$6$7<pg>$8<\/pg>$9\(<yr>$10<\/yr>\)$11<\/bib>/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}\($regx{issue}\)$regx{optionalPuncSpace}<i>$regx{volume}<\/i>$regx{puncSpace}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionalPuncSpace}\($regx{year}\)$regx{optionaEndPunc}<\/bib>/$1\(<iss>$2<\/iss>\)$3<v><i>$4<\/i><\/v>$5$6$7<pg>$8<\/pg>$9\(<yr>$10<\/yr>\)$11<\/bib>/gs;

	  #, 2009. <b>37</b>(2): p. W305-W311.</bib>
	  #, 2006. <b>34</b>(19): p. e130-e130.</bib>
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{year}$regx{optionalPuncSpace}<b>$regx{volume}<\/b>$regx{optionalSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<yr>$2<\/yr>$3<v><b>$4<\/b><\/v>$5\(<iss>$6<\/iss>\)$7$8$9<pg>$10<\/pg>$11<\/bib>/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{year}$regx{optionalPuncSpace}<i>$regx{volume}<\/i>$regx{optionalSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<yr>$2<\/yr>$3<v><i>$4<\/i><\/v>$5\(<iss>$6<\/iss>\)$7$8$9<pg>$10<\/pg>$11<\/bib>/gs;

	  # 2008; <b>20</b> (Suppl..1): 64-72.
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{year}$regx{optionalPuncSpace}<b>$regx{volume}<\/b>$regx{optionalSpace}\($regx{issuePrefix}$regx{optionalSpace}$regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v><b>$4<\/b><\/v>$5\($6$7<iss>$8<\/iss>\)$9<pg>$10<\/pg>$11$12/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{year}$regx{optionalPuncSpace}<i>$regx{volume}<\/i>$regx{optionalSpace}\($regx{issuePrefix}$regx{optionalSpace}$regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v><i>$4<\/i><\/v>$5\($6$7<iss>$8<\/iss>\)$9<pg>$10<\/pg>$11$12/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{year}$regx{optionalPuncSpace}$regx{volume}$regx{optionalSpace}\($regx{issuePrefix}$regx{optionalSpace}$regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v>$4<\/v>$5\($6$7<iss>$8<\/iss>\)$9<pg>$10<\/pg>$11$12/gs;

	  #, 2009. <b>37</b>(suppl 2): p. W305-W311.</bib>
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{year}$regx{optionalPuncSpace}<b>$regx{volume}<\/b>$regx{optionalSpace}\($regx{issuePrefix}$regx{optionalSpace}$regx{issue}\)$regx{optionalPuncSpace}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v><b>$4<\/b><\/v>$5\($6$7<iss>$8<\/iss>\)$9$10$11<pg>$12<\/pg>$13$14/gs;
	  #, 2009. <i>37</i>(suppl 2): p. W305-W311.</bib>
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{year}$regx{optionalPuncSpace}<i>$regx{volume}<\/i>$regx{optionalSpace}\($regx{issuePrefix}$regx{optionalSpace}$regx{issue}\)$regx{optionalPuncSpace}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v><i>$4<\/i><\/v>$5\($6$7<iss>$8<\/iss>\)$9$10$11<pg>$12<\/pg>$13$14/gs;

	  #, <b>2009<\/b>, <i>37</i>(suppl 2): p. W305-W311.</bib>
	  $Bibtext=~s/$regx{wordPuncPrefix}<b>$regx{year}<\/b>$regx{optionalPuncSpace}<i>$regx{volume}<\/i>$regx{optionalSpace}\($regx{issuePrefix}$regx{optionalSpace}$regx{issue}\)$regx{optionalPuncSpace}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr><b>$2<\/b><\/yr>$3<v><i>$4<\/i><\/v>$5\($6$7<iss>$8<\/iss>\)$9$10$11<pg>$12<\/pg>$13$14/gs;

	  #1994;35(Suppl. 5):S33-6.</bib>
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{year}([\s\.\,\;]+?)$regx{volume}\($regx{issuePrefix}$regx{optionalSpace}$regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v>$4<\/v>\($5$6<iss>$7<\/iss>\)$8<pg>$9<\/pg>$10$11/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{year}([\s\.\,\;]+?)<b>$regx{volume}<\/b>\($regx{issuePrefix}$regx{optionalSpace}$regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v><b>$4<\/b><\/v>\($5$6<iss>$7<\/iss>\)$8<pg>$9<\/pg>$10$11/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{year}([\s\.\,\;]+?)<b>$regx{volume}<\/b>\($regx{issuePrefix}$regx{puncSpace}$regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v><b>$4<\/b><\/v>\($5$6<iss>$7<\/iss>\)$8<pg>$9<\/pg>$10$11/gs;

	  #<b>1994<b>, <i>35</i> (Suppl. 5), S33–S36.</bib>
	  $Bibtext=~s/$regx{wordPuncPrefix}<b>$regx{year}<\/b>([\s\.\,\;]+?)<i>$regx{volume}<\/i>$regx{optionalSpace}\($regx{issuePrefix}$regx{optionalSpace}$regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr><b>$2<\/b><\/yr>$3<v><i>$4<\/i><\/v>$5\($6$7<iss>$8<\/iss>\)$9<pg>$10<\/pg>$11$12/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}<b>$regx{year}<\/b>([\s\.\,\;]+?)<i>$regx{volume}<\/i>$regx{optionalSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr><b>$2<\/b><\/yr>$3<v><i>$4<\/i><\/v>$5\(<iss>$6<\/iss>\)$7<pg>$8<\/pg>$9$10/gs;

	  #<b>1994<b>, <i>35</i> (Suppl. 5)</bib>
	  $Bibtext=~s/$regx{wordPuncPrefix}<b>$regx{year}<\/b>([\s\.\,\;]+?)<i>$regx{volume}<\/i>$regx{optionalSpace}\($regx{issuePrefix}$regx{optionalSpace}$regx{isksue}\)$regx{optionaEndPunc}<\/bib>/$1<yr><b>$2<\/b><\/yr>$3<v><i>$4<\/i><\/v>$5\($6$7<iss>$8<\/iss>\)$9<\/bib>/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}<b>$regx{year}<\/b>([\s\.\,\;]+?)<i>$regx{volume}<\/i>$regx{optionalSpace}\($regx{issue}\)$regx{optionaEndPunc}<\/bib>/$1<yr><b>$2<\/b><\/yr>$3<v><i>$4<\/i><\/v>$5\(<iss>$6<\/iss>\)$7<\/bib>/gs;

	  #Vol. 42, Issue 11, 148--150, 1981.</bib>
	  # $Bibtext=~s/$regx{wordPuncPrefix}$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{puncSpace}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{issueSpace}$regx{page}$regx{pagePunc}$regx{year}$regx{optionaEndPunc}<\/bib>/$1$2$3<v>$4<\/v>$5$6$7<iss>$8<\/iss>$9<pg>$10<\/pg>$11<yr>$12<\/yr>$13<\/bib>/gs;

	  #, Vol. 29, Iss. 2, 1989, S. 285-290.</bib>
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{puncSpace}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{puncSpace}$regx{year}$regx{puncSpace}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/$1$2$3<v>$4<\/v>$5$6$7<iss>$8<\/iss>$9<yr>$10<\/yr>$11$12$13<pg>$14<\/pg>$15<\/bib>/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{puncSpace}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{puncSpace}$regx{year}$regx{puncSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/$1$2$3<v>$4<\/v>$5$6$7<iss>$8<\/iss>$9<yr>$10<\/yr>$11<pg>$12<\/pg>$13<\/bib>/gs;

	  #, Vol. 15, No. 4 (Winter, 1984), S. 471-489.
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{puncSpace}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{puncSpace}\($regx{monthPrefix}$regx{puncSpace}$regx{year}\)$regx{puncSpace}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/$1$2$3<v>$4<\/v>$5$6$7<iss>$8<\/iss>$9\($10$11<yr>$12<\/yr>\)$13$14$15<pg>$16<\/pg>$17<\/bib>/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{puncSpace}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{optionalSpace}\($regx{monthPrefix}$regx{puncSpace}$regx{year}\)$regx{puncSpace}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/$1$2$3<v>$4<\/v>$5$6$7<iss>$8<\/iss>$9\($10$11<yr>$12<\/yr>\)$13$14$15<pg>$16<\/pg>$17<\/bib>/gs;

	  #398/399 (2001) 53.
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volume}\/$regx{volume}$regx{optionalPuncSpace}\($regx{year}\)$regx{puncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<v>$2\/$3<\/v>$4\(<yr>$5<\/yr>\)$6<pg>$7<\/pg>$8$9/gs;

	  #22, 5 (2006), 303–310
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volume}$regx{puncSpace}$regx{issue}$regx{optionalPuncSpace}\($regx{year}\)$regx{puncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<v>$2<\/v>$3<iss>$4<\/iss>$5\(<yr>$6<\/yr>\)$7<pg>$8<\/pg>$9$10/gs;

	  #<b>196</b>(2) (2008) 440--449</bib>
	  $Bibtext=~s/$regx{wordPuncPrefix}<b>$regx{volume}<\/b>$regx{optionalPuncSpace}\($regx{issue}\)$regx{optionalPuncSpace}\($regx{year}\)$regx{puncSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<v><b>$2<\/b><\/v>$3\(<iss>$4<\/iss>\)$5\(<yr>$6<\/yr>\)$7<pg>$8<\/pg>$9<\/bib>/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}<b>$regx{volume}<\/b>$regx{optionalPuncSpace}\($regx{issue}\)$regx{optionalPuncSpace}\($regx{year}$regx{ndash}([0-9]+)\)$regx{puncSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<v><b>$2<\/b><\/v>$3\(<iss>$4<\/iss>\)$5\(<yr>$6$7$8<\/yr>\)$9<pg>$10<\/pg>$11<\/bib>/gs;

	  #196(2) (2008) 440--449</bib>
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)$regx{optionalPuncSpace}\($regx{year}\)$regx{puncSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v>$3\(<iss>$4<\/iss>\)$5\(<yr>$6<\/yr>\)$7<pg>$8<\/pg>$9<\/bib>/gs;

	 #, <i>24</i>(Suppl. 2), 3--4.</bib>
	  $Bibtext=~s/$regx{wordPuncPrefix}<i>$regx{volume}<\/i>\($regx{issuePrefix}$regx{optionalSpace}$regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<v><i>$2<\/i><\/v>\($3$4<iss>$5<\/iss>\)$6<pg>$7<\/pg>$8$9/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}<i>$regx{volume}<\/i>\($regx{puncSpace}$regx{optionalSpace}$regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<v><i>$2<\/i><\/v>\($3$4<iss>$5<\/iss>\)$6<pg>$7<\/pg>$8$9/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}<b>$regx{volume}<\/b>\($regx{issuePrefix}$regx{optionalSpace}$regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<v><b>$2<\/b><\/v>\($3$4<iss>$5<\/iss>\)$6<pg>$7<\/pg>$8$9/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}<b>$regx{volume}<\/b>\($regx{issuePrefix}$regx{puncSpace}$regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<v><b>$2<\/b><\/v>\($3$4<iss>$5<\/iss>\)$6<pg>$7<\/pg>$8$9/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}<i>$regx{volume}<\/i>\($regx{issuePrefix}$regx{optionalSpace}$regx{issue}\)$regx{optionalPuncSpace}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<v><i>$2<\/i><\/v>\($3$4<iss>$5<\/iss>\)$6$7$8<pg>$9<\/pg>$10<\/bib>/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}<b>$regx{volume}<\/b>\($regx{issuePrefix}$regx{optionalSpace}$regx{issue}\)$regx{optionalPuncSpace}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<v><b>$2<\/b><\/v>\($3$4<iss>$5<\/iss>\)$6$7$8<pg>$9<\/pg>$10$11/gs;

	  #Blood 1979;59 Suppl 1:26–32.</bib>
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{year}$regx{puncSpace}$regx{volume}$regx{puncSpace}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{puncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v>$4<\/v>$5$6$7<iss>$8<\/iss>$9<pg>$10<\/pg>$11$12/gs;


	  #, Vol. 6, No. 2, 181-197.</bib>
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{puncSpace}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{issuePunc}$regx{page}$regx{optionaEndPunc}<\/bib>/$1$2$3<v>$4<\/v>$5$6$7<iss>$8<\/iss>$9<pg>$10<\/pg>$11<\/bib>/gs;

	  #, 127, 2, pp. 297 - 316, 2000.
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volume}$regx{volumePunc}$regx{issue}$regx{puncSpace}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{puncSpace}$regx{year}$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v>$3<iss>$4<\/iss>$5$6$7<pg>$8<\/pg>$9<yr>$10<\/yr>$11<\/bib>/gs;

	  #, 3(2), pp. 111-137, 1997.
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)$regx{puncSpace}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{puncSpace}$regx{year}$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v>$3\(<iss>$4<\/iss>\)$5$6$7<pg>$8<\/pg>$9<yr>$10<\/yr>$11<\/bib>/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}<b>$regx{volume}<\/b>$regx{optionalPuncSpace}\($regx{issue}\)$regx{puncSpace}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{puncSpace}$regx{year}$regx{optionaEndPunc}<\/bib>/$1<v><b>$2<\/b><\/v>$3\(<iss>$4<\/iss>\)$5$6$7<pg>$8<\/pg>$9<yr>$10<\/yr>$11<\/bib>/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}<i>$regx{volume}<\/i>$regx{optionalPuncSpace}\($regx{issue}\)$regx{puncSpace}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{puncSpace}$regx{year}$regx{optionaEndPunc}<\/bib>/$1<v><i>$2<\/i><\/v>$3\(<iss>$4<\/iss>\)$5$6$7<pg>$8<\/pg>$9<yr>$10<\/yr>$11<\/bib>/gs;

	  #48(3):498--532, June 1994.
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)$regx{puncSpace}$regx{page}$regx{pagePunc}$regx{monthPrefix}$regx{puncSpace}$regx{year}$regx{optionaEndPunc}/$1<v>$2<\/v>$3\(<iss>$4<\/iss>\)$5<pg>$6<\/pg>$7$8$9<yr>$10<\/yr>$11/gs;

	  #vol. 8(1 & 2), pp. <v>61-74</v>, <pg>2008</pg>.</bib>
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{optionalSpace}\($regx{issue}\)$regx{puncSpace}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{puncSpace}$regx{year}$regx{optionaEndPunc}<\/bib>/$1$2$3<v>$4<\/v>$5\(<iss>$6<\/iss>\)$7$8$9<pg>$10<\/pg>$11<yr>$12<\/yr>$13<\/bib>/gs;
	  #4(1):1--15, 2000.
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)$regx{puncSpace}$regx{page}$regx{pagePunc}$regx{year}$regx{optionaEndPunc}/$1<v>$2<\/v>$3\(<iss>$4<\/iss>\)$5<pg>$6<\/pg>$7<yr>$8<\/yr>$9/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}<b>$regx{volume}<\/b>$regx{optionalPuncSpace}\($regx{issue}\)$regx{puncSpace}$regx{page}$regx{pagePunc}$regx{year}$regx{optionaEndPunc}/$1<v><b>$2<\/b><\/v>$3\(<iss>$4<\/iss>\)$5<pg>$6<\/pg>$7<yr>$8<\/yr>$9/gs;

	  #11(3-4), 365-396 (Sep 2010)
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)$regx{puncSpace}$regx{page}$regx{pagePunc}\($regx{monthPrefix}$regx{puncSpace}$regx{year}\)$regx{optionaEndPunc}/$1<v>$2<\/v>$3\(<iss>$4<\/iss>\)$5<pg>$6<\/pg>$7\($8$9<yr>$10<\/yr>\)$11/gs;

	  #8(2), 173--195 (2000)
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)$regx{puncSpace}$regx{page}$regx{pagePunc}\($regx{year}\)$regx{optionaEndPunc}/$1<v>$2<\/v>$3\(<iss>$4<\/iss>\)$5<pg>$6<\/pg>$7\(<yr>$8<\/yr>\)$9/gs;
  $Bibtext=~s/$regx{wordPuncPrefix}<b>$regx{volume}<\/b>$regx{optionalPuncSpace}\($regx{issue}\)$regx{puncSpace}$regx{page}$regx{pagePunc}\($regx{year}\)$regx{optionaEndPunc}/$1<v><b>$2<\/b><\/v>$3\(<iss>$4<\/iss>\)$5<pg>$6<\/pg>$7\(<yr>$8<\/yr>\)$9/gs;

	  #15 (2), 2004, S. 1-14
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)$regx{puncSpace}$regx{year}$regx{puncSpace}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<v>$2<\/v>$3\(<iss>$4<\/iss>\)$5<yr>$6<\/yr>$7$8$9<pg>$10<\/pg>$11$12/gs;
	  #19(2), 2005, 255-271.</bib>
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)$regx{puncSpace}$regx{year}$regx{puncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<v>$2<\/v>$3\(<iss>$4<\/iss>\)$5<yr>$6<\/yr>$7<pg>$8<\/pg>$9$10/gs;

	  #</i> 8, no. <v>2</v> (<yr>1978</yr>): <pg>145--173</pg>.</bib>
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volume}$regx{optionalPuncSpace}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{optionalSpace}\($regx{year}\)$regx{puncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<v>$2<\/v>$3$4$5<iss>$6<\/iss>$7\(<yr>$8<\/yr>\)$9<pg>$10<\/pg>$11$12/gs;

	  #, (2) 2, 2010, S. 57-63.
	  $Bibtext=~s/$regx{wordPuncPrefix}\($regx{issue}\)$regx{optionalPuncSpace}$regx{volume}$regx{puncSpace}$regx{year}$regx{puncSpace}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1\(<iss>$2<\/iss>\)$3<v>$4<\/v>$5<yr>$6<\/yr>$7$8$9<pg>$10<\/pg>$11$12/gs;

	  #25(11), (1995) 
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)$regx{puncSpace}\($regx{year}\)$regx{extraInfo}/$1<v>$2<\/v>$3\(<iss>$4<\/iss>\)$5\(<yr>$6<\/yr>\)$7/gs;

	  #<b>13</b>1(3), 366--374 (2002)
	  #$Bibtext=~s/$regx{wordPuncPrefix}<b>$regx{volume}<\/b>$regx{optionalPuncSpace}\($regx{issue}\)$regx{puncSpace}$regx{page}$regx{pagePunc}\($regx{year}\)$regx{optionaEndPunc}/$1<v>$2<\/v>$3\(<iss>$4<\/iss>\)$5<pg>$6<\/pg>$7\(<yr>$8<\/yr>\)$9/gs;

	  #2008;321 (5887): pp. 385-388 (doi: 10.1126/science.1157996)
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{year}$regx{puncSpace}$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{pagePunc}\((DOI|doi|Doi)([\: ]+)([0-9a-zA-Z\/\\\:\_\.\-–\(\)]+)\)$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v>$4<\/v>$5\(<iss>$6<\/iss>\)$7$8$9<pg>$10<\/pg>$11\(<doig>$12$13<doi>$14<\/doi><\/doig>\)$15$16/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{year}$regx{puncSpace}$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{pagePunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v>$4<\/v>$5\(<iss>$6<\/iss>\)$7$8$9<pg>$10<\/pg>$11$12/gs;

	  #<b>463</b>, p.127--213, (2008).</bib>
	  $Bibtext=~s/$regx{wordPuncPrefix}<b>$regx{volume}<\/b>$regx{puncSpace}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionalPuncSpace}\($regx{year}\)$regx{optionaEndPunc}<\/bib>/$1<v><b>$2<\/b><\/v>$3$4$5<pg>$6<\/pg>$7\(<yr>$8<\/yr>\)$9<\/bib>/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}<i>$regx{volume}<\/i>$regx{puncSpace}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionalPuncSpace}\($regx{year}\)$regx{optionaEndPunc}<\/bib>/$1<v><i>$2<\/i><\/v>$3$4$5<pg>$6<\/pg>$7\(<yr>$8<\/yr>\)$9<\/bib>/gs;

	  #Phys. Rev. D. <b>40</b>, 967 (1989)</bib>
	  $Bibtext=~s/$regx{wordPuncPrefix}<b>$regx{volume}<\/b>$regx{optionalPuncSpace}$regx{page}$regx{optionalPuncSpace}\($regx{year}\/$regx{year}\)$regx{optionaEndPunc}<\/bib>/$1<v><b>$2<\/b><\/v>$3<pg>$4<\/pg>$5\(<yr>$6\/$7<\/yr>\)$8<\/bib>/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}<b>$regx{volume}<\/b>$regx{optionalPuncSpace}$regx{page}$regx{optionalPuncSpace}\($regx{year}\, $regx{year}\)$regx{optionaEndPunc}<\/bib>/$1<v><b>$2<\/b><\/v>$3<pg>$4<\/pg>$5\(<yr>$6\, $7<\/yr>\)$8<\/bib>/gs;

	  $Bibtext=~s/$regx{wordPuncPrefix}<b>$regx{volume}<\/b>$regx{optionalPuncSpace}$regx{page}$regx{optionalPuncSpace}\($regx{year}\)$regx{optionaEndPunc}<\/bib>/$1<v><b>$2<\/b><\/v>$3<pg>$4<\/pg>$5\(<yr>$6<\/yr>\)$7<\/bib>/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}<i>$regx{volume}<\/i>$regx{optionalPuncSpace}$regx{page}$regx{optionalPuncSpace}\($regx{year}\/$regx{year}\)$regx{optionaEndPunc}<\/bib>/$1<v><i>$2<\/i><\/v>$3<pg>$4<\/pg>$5\(<yr>$6\/$7<\/yr>\)$8<\/bib>/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}<i>$regx{volume}<\/i>$regx{optionalPuncSpace}$regx{page}$regx{optionalPuncSpace}\($regx{year}\)$regx{optionaEndPunc}<\/bib>/$1<v><i>$2<\/i><\/v>$3<pg>$4<\/pg>$5\(<yr>$6<\/yr>\)$7<\/bib>/gs;

	  #, <i>12</i>(1), 17-23.
	  $Bibtext=~s/\, <i>$regx{volume}<\/i>\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}\. ([A-Za-z]+)/\, <v><i>$1<\/i><\/v>\(<iss>$2<\/iss>\)$3<pg>$4<\/pg>\. $5/gs;

	  #. D1 (1997) 108-121</bib>
	  #1 (1997) 108-121</bib>
	  #15, (2000), 4341--4353.</bib>
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volume}$regx{optionalPuncSpace}\($regx{year}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v>$3\(<yr>$4<\/yr>\)$5<pg>$6<\/pg>$7<\/bib>/gs;

	  # Volume&nbsp;5242. (2008) 70–78</bib
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{optionalPuncSpace}\($regx{year}\)$regx{optionalSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/$1$2$3<v>$4<\/v>$5\(<yr>$6<\/yr>\)$7<pg>$8<\/pg>$9<\/bib>/gs;

	  #<b>78</b> (2008) 123532 [
	  #$Bibtext=~s/$regx{wordPuncPrefix}$regx{volume}$regx{optionalPuncSpace}\($regx{year}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v>$3\(<yr>$4<\/yr>\)$5<pg>$6<\/pg>$7<\/bib>/gs;

	  #236:133-178, 2000
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volume}$regx{volumePunc}$regx{page}$regx{pagePunc}$regx{year}$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v>$3<pg>$4<\/pg>$5<yr>$6<\/yr>$7<\/bib>/gs;

	  #8:31-60, March 2000.
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volume}$regx{volumePunc}$regx{page}$regx{pagePunc}$regx{monthPrefix}$regx{puncSpace}$regx{year}$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v>$3<pg>$4<\/pg>$5$6$7<yr>$8<\/yr>$9<\/bib>/gs;

	  #188:91-103, 2007, Elsevier.
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volume}$regx{volumePunc}$regx{page}$regx{pagePunc}$regx{year}([\.\,]) ([^<>]+?)<\/bib>/$1<v>$2<\/v>$3<pg>$4<\/pg>$5<yr>$6<\/yr>$7 $8<\/bib>/gs;

	  # 5144, pages 109–124, Jan 2008.
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volume}$regx{volumePunc}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{pagePunc}$regx{monthPrefix}$regx{puncSpace}$regx{year}$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v>$3$4$5<pg>$6<\/pg>$7$8$9<yr>$10<\/yr>$11<\/bib>/gs;

	  # 5144, pages 109–124, 2008.
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volume}$regx{volumePunc}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{pagePunc}$regx{year}$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v>$3$4$5<pg>$6<\/pg>$7<yr>$8<\/yr>$9<\/bib>/gs;

	  # 5144, pages 109–124, 2008. Springer-Verlag
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volume}$regx{volumePunc}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{pagePunc}$regx{year}([\.\,]) ([^<>]+?)<\/bib>/$1<v>$2<\/v>$3$4$5<pg>$6<\/pg>$7<yr>$8<\/yr>$9 $10<\/bib>/gs;

	  #147, 195-197 (1981)
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volume}$regx{volumePunc}$regx{page}$regx{puncSpace}\($regx{year}\)$regx{optionaEndPunc}$regx{extraInfoNoComment}/$1<v>$2<\/v>$3<pg>$4<\/pg>$5\(<yr>$6<\/yr>\)$7$8/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}<b>$regx{volume}<\/b>$regx{volumePunc}$regx{page}$regx{puncSpace}\($regx{year}\)$regx{optionaEndPunc}$regx{extraInfoNoComment}/$1<v><b>$2<\/b><\/v>$3<pg>$4<\/pg>$5\(<yr>$6<\/yr>\)$7$8/gs;

	  #, 34, 391-401, 1988.
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volume}([\,\:\s]+[pP]age[s]?|[pPS\.]+[\s]*)$regx{page}$regx{pagePunc}$regx{year}$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v>$3<pg>$4<\/pg>$5<yr>$6<\/yr>$7<\/bib>/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volume}$regx{volumePunc}$regx{page}$regx{pagePunc}$regx{year}$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v>$3<pg>$4<\/pg>$5<yr>$6<\/yr>$7<\/bib>/gs;

	  #2003, 33,8: 609–611  
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{year}$regx{puncSpace} $regx{volume}([\,\;][ ]?)$regx{issue}\: $regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3 <v>$4<\/v>$5<iss>$6<\/iss>\: <pg>$7<\/pg>$8$9/gs;

	  #New York (1997) 415–438</bib>
	  $Bibtext=~s/$regx{wordPuncPrefix}\($regx{year}\)$regx{optionalSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/$1\(<yr>$2<\/yr>\)$3<pg>$4<\/pg>$5<\/bib>/gs;
	  #, in press, 2010. http://dx.doi.org/10.1007/s10951-012-0270–4.
	  $Bibtext=~s/([a-zA-Z>\}][\.\,\:\; ]+ in press[\s\,]+)$regx{year}([\.\,\; ]+)(http\:[\/\\\_\.\~\%\#\@\$\&\*\(\)\w\d\-]+)$regx{optionaEndPunc}<\/bib>/$1<yr>$2<\/yr>$3$4$5<\/bib>/gs;

	  #<b>78</b> (2008) 123532 [
	  $Bibtext=~s/$regx{wordPuncPrefix}<b>$regx{volume}<\/b>$regx{optionalPuncSpace}\($regx{year}\)$regx{puncSpace}$regx{page}$regx{puncSpace}\[/$1<v><b>$2<\/b><\/v>$3\(<yr>$4<\/yr>\)$5<pg>$6<\/pg>$7\[/gs;

	  #. 18. Januar 2010;3:64.</bib>
	  $Bibtext=~s/$regx{wordPuncPrefix}([0-9]+[\.]? [JFAMSOND][a-z]+ )$regx{year}([\s\;]+?)$regx{volume}$regx{volumePunc}$regx{pageRange}$regx{optionaEndPunc}<\/bib>/$1$2<yr>$3<\/yr>$4<v>$5<\/v>$6<pg>$7<\/pg>$8<\/bib>/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}([0-9]+[\.]? [JFAMSOND][a-z]+ )$regx{year}([\s\;]+?)$regx{volume}$regx{volumePunc}$regx{page}$regx{optionaEndPunc}<\/bib>/$1$2<yr>$3<\/yr>$4<v>$5<\/v>$6<pg>$7<\/pg>$8<\/bib>/gs;

	  #, 1988. <b>20</b>(103-116).</bib>
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{year}([\s\.\,]+?)<b>$regx{volume}<\/b>$regx{optionalPuncSpace}\($regx{pageRange}\)$regx{optionaEndPunc}<\/bib>/$1<yr>$2<\/yr>$3<v><b>$4<\/b><\/v>$5\(<pg>$6<\/pg>\)$7<\/bib>/gs;

	  # 2011, 15: 211-240</bib>
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{year}([\s\.\,\;]+?)$regx{volume}$regx{volumePunc}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<yr>$2<\/yr>$3<v>$4<\/v>$5<pg>$6<\/pg>$7<\/bib>/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{year}([\s\.\,\;]+?)<b>$regx{volume}<\/b>$regx{volumePunc}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<yr>$2<\/yr>$3<v><b>$4<\/b><\/v>$5<pg>$6<\/pg>$7<\/bib>/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}<b>$regx{year}<\/b>([\s\.\,\;]+?)<i>$regx{volume}<\/i>$regx{volumePunc}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<b><yr>$2<\/yr><\/b>$3<i><v>$4<\/v><\/i>$5<pg>$6<\/pg>$7$8/gs;
	  #1960;156:362.80.</bib>
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{year}([\s\.\,\;]+?)$regx{volume}$regx{volumePunc}([0-9]+\.[0-9]+)$regx{optionaEndPunc}<\/bib>/$1<yr>$2<\/yr>$3<v>$4<\/v>$5<pg>$6<\/pg>$7<\/bib>/gs;
	  #Am. J. Med. 2009; 122: 248-56, e245
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{year}([\s\.\,\;]+?)<b>$regx{volume}<\/b>$regx{volumePunc}$regx{pageRange}\, $regx{page}$regx{optionaEndPunc}<\/bib>/$1<yr>$2<\/yr>$3<v><b>$4<\/b><\/v>$5<pg>$6\, $7<\/pg>$8<\/bib>/gs;
	  #2011;127:1486-93.e2
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{year}([\s\.\,\;]+?)$regx{volume}$regx{volumePunc}$regx{page}(\.e[0-9]*|\-e[0-9]*)$regx{optionaEndPunc}<\/bib>/$1<yr>$2<\/yr>$3<v>$4<\/v>$5<pg>$6$7<\/pg>$8<\/bib>/gs;
	  # $Bibtext=~s/$regx{wordPuncPrefix}$regx{year}([\s\.\,\;]+?)$regx{volume}$regx{volumePunc}(e[0-9\-]+\.e[0-9]*|e[0-9]+\-e)$regx{optionaEndPunc}<\/bib>/$1<yr>$2<\/yr>$3<v>$4<\/v>$5<pg>$6<\/pg>$7<\/bib>/gs;


	  # 2011, 15: 211-240 (
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{year}([\s\.\,\;]+?)$regx{volume}$regx{volumePunc}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v>$4<\/v>$5<pg>$6<\/pg>$7$8/igs;

	  #1995;Nov(320):110-4
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{year}$regx{yearPunc}$regx{monthPrefix}\($regx{issue}\)$regx{issuePunc}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3$4\(<iss>$5<\/iss>\)$6<pg>$7<\/pg>$8$9/igs;

	  #  2007 (180):263-83. PubMed
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{year}$regx{optionalPuncSpace}\($regx{issue}\)$regx{issuePunc}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3\(<iss>$4<\/iss>\)$5<pg>$6<\/pg>$7$8/igs;



	  #1999, <i>263<\/i>, 295.</bib>
	  $Bibtext=~s/([>\.\, ]+)$regx{year}$regx{puncSpace}<i>$regx{volume}<\/i>$regx{puncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v><i>$4<\/i><\/v>$5<pg>$6<\/pg>$7$8/gs;
	  #1999, 263, 295.</bib>
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{year}$regx{puncSpace}$regx{volume}$regx{puncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v>$4<\/v>$5<pg>$6<\/pg>$7$8/gs;
	  $Bibtext=~s/<\/i>([\.\,] ) $regx{year}$regx{puncSpace}$regx{volume}$regx{puncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/<\/i>$1<yr>$2<\/yr>$3<v>$4<\/v>$5<pg>$6<\/pg>$7$8/gs;

	  #<b>25</b> (2010) 1358-1365 <b>136</b>
	  $Bibtext=~s/$regx{wordPuncPrefix}<b>$regx{volume}<\/b> \($regx{year}\) $regx{page} <b>([0-9]+)<\/b>$regx{optionaEndPunc}<\/bib>/$1<v><b>$2<\/b><\/v> \(<yr>$3<\/yr>\) <pg>$4<\/pg> <b>$5<\/b>$6<\/bib>/gs;

	  #. 2013 Jan 18. PubMed
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{year}$regx{optionalPuncSpace}$regx{monthPrefix}([\.\s]+)$regx{month}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3$4$5$6$7$8/igs;

	  #27 (1973) 3, S.&nbsp;78–80.</bib>  ###########*****
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volume} \($regx{year}\) $regx{issue}\, $regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v> \(<yr>$3<\/yr>\) <iss>$4<\/iss>\, $5$6<pg>$7<\/pg>$8<\/bib>/gs;

	  #27 (1973), S.&nbsp;78–80.</bib>
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volume} \($regx{year}\)\, $regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v> \(<yr>$3<\/yr>\)\, $4$5<pg>$6<\/pg>$7<\/bib>/gs;
	  #78 (1998) S. 377-392.
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volume} \($regx{year}\) $regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v> \(<yr>$3<\/yr>\) $4$5<pg>$6<\/pg>$7<\/bib>/gs;

	  #54:130-142, 1977
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volume}$regx{volumePunc}$regx{page}$regx{pagePunc}$regx{year}$regx{optionaEndPunc}$regx{extraInfo}/$1<v>$2<\/v>$3<pg>$4<\/pg>$5<yr>$6<\/yr>$7$8/gs;

	  #, pages 392--398, 2012.</bib>
	  #, pp. 113-134, 1989.
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{pagePunc}$regx{year}$regx{optionaEndPunc}<\/bib>/$1$2$3<pg>$4<\/pg>$5<yr>$6<\/yr>$7<\/bib>/gs;

	  #select(undef, undef, undef,  $sleep1);

	  #, 1997: p. 12-14.
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{year}$regx{puncSpace}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<yr>$2<\/yr>$3$4$5<pg>$6<\/pg>$7<\/bib>/gs;

	  #Rev. 1004:91–97.</bib>
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volume}\:\$regx{page}$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v>\:<pg>$3<\/pg>$4<\/bib>/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}$regx{volume}\:\$regx{pageRange}$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v>\:<pg>$3<\/pg>$4<\/bib>/gs;

	  #</pbl> (2006)</bib>
	  $Bibtext=~s/<\/(pbl|cny)>$regx{optionalPunc}$regx{year}$regx{optionaEndPunc}$regx{extraInfoNoComment}/<\/$1>$2<yr>$3<\/yr>$4$5/gs;
	  $Bibtext=~s/$regx{year}\), $regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfoNoComment}/<yr>$1<\/yr>\), $2$3<pg>$4<\/pg>$5$6/gs;

	  #2012. (Epub 2012/07/04).</bib>
	  $Bibtext=~s/([A-Za-z]+[\.\,\?]?)$regx{puncSpace}$regx{year}$regx{optionalPuncSpace}$regx{extraInfoNoComment}/$1$2<yr>$3<\/yr>$4$5/gs;
	  $Bibtext=~s/<bib id=\"([A-Za-z]+)<yr>$regx{year}<\/yr>\">/<bib id=\"$1$2\">/gs;

	  #
	  $Bibtext=~s/$regx{wordPuncPrefix}<b>$regx{volume}<\/b>$regx{optionalPuncSpace}\($regx{issue}\)$regx{optionalPuncSpace}\($regx{year}\)$regx{optionalPuncSpace}$regx{extraInfoNoComment}/$1<v><b>$2<\/b><\/v>$3\(<iss>$4<\/iss>\)$5\(<yr>$6<\/yr>\)$7$8/gs;

	  #ews (0) (2012).</bib>
	  $Bibtext=~s/([A-Za-z]+[\.\,\?]?)$regx{optionalPuncSpace}\($regx{issue}\) \($regx{year}\)$regx{optionalPuncSpace}$regx{extraInfoNoComment}/$1$2\($3\) \(<yr>$4<\/yr>\)$5$6/gs;
	  $Bibtext=~s/\(([^\(\)<>\,\.]+)\, ([^\(\)<>\,\.]+)\, $regx{year}\)\, $regx{page}$regx{optionalPuncSpace}$regx{extraInfoNoComment}/\($1, $2\, <yr>$3<\/yr>\)\, $4$5$6/gs;
	  #doi:10.1016/j.anifeedsci.<yr>2011</yr>.<v>04</v>.<pg>002</pg>
	  $Bibtext=~s/ (DOI|doi|Doi)([\: ]+)([0-9a-zA-Z\/\\\:\_\.\-–\(\)<>]+)\.<yr>([^<>]+?)<\/yr>\.<v>([^<>]+?)<\/v>\.<pg>([^<>]+?)<\/pg>/ <doig>$1$2<doi>$3\.$4\.$5\.$6<\/doi><\/doig>/gs;

	  #<\/i> 36, 1981.</bib>
	  $Bibtext=~s/$regx{wordPuncPrefix} $regx{volume}\, $regx{year}$regx{optionalPuncSpace}$regx{extraInfoNoComment}/$1 <v>$2<\/v>\, <yr>$3<\/yr>$4$5/gs;
	  $Bibtext=~s/<\/i> $regx{volume}\, $regx{year}$regx{optionalPuncSpace}$regx{extraInfoNoComment}/<\/i> <v>$1<\/v>\, <yr>$2<\/yr>$3$4/gs;
	  $Bibtext=~s/$regx{wordPuncPrefix}<b>$regx{volume}<\/b>$regx{optionalPuncSpace}\($regx{year}\)$regx{optionalPuncSpace}<\/bib>/$1<v><b>$2<\/b><\/v>$3\(<yr>$4<\/yr>\)$5<\/bib>/gs;
	  #, 37. 1401–1415. doi
	  $Bibtext=~s/$regx{wordPuncPrefix} $regx{volume}\. $regx{page}$regx{optionaEndPunc}$regx{extraInfoNoComment}/$1 <v>$2<\/v>\. $3$4$5/gs;

	  #select(undef, undef, undef,  $sleep1);

	}
      $Bibtext=~s/<bib([^<>]*?)>((?:(?!<bib)(?!<\/bib).)*)<\/bib>/$2/gs;

      $TextBody=~s/<bib([^<>]*?)>((?:(?!<bib)(?!<\/bib).)*)<\/bib>/<Xbib$1>$Bibtext<\/Xbib>/os;
    }
  #select(undef, undef, undef,  $sleep1);

  $TextBody=~s/<Xbib id=\"([^<>]*?)<yr>$regx{year}<\/yr>([^<>]*?)\">/<bib id=\"$1$2$3\">/gs;
  $TextBody=~s/<Xbib([^<>]*?)>/<bib$1>/gs;
  $TextBody=~s/<\/Xbib>/<\/bib>/gs;
  $TextBody=~s/<bib id=\"([^<>]*?)<yr>$regx{year}<\/yr>([^<>]*?)\">/<bib id=\"$1$2$3\">/gs;
  $TextBody=~s/<bib id=\"([^<>]*?)\"><bib id=\"\1\">((?:(?!<bib )(?!<[\/]?bib>).)*?)<\/bib><\/bib>/<bib id=\"$1\">$2<\/bib>/gs;
#-----------------------------------------



  #for DOI
  $TextBody=~s/(doi\:[Dd][Oo][Ii]|DOI\:doi|[dD][oO][iI])([\: ]*)([^ ]+?)\.<yr>([0-9]+)<\/yr>\.<v>([0-9]+)<\/v>\.<iss>([0-9]+)<\/iss>\.<pg>([0-9]+)<\/pg>/$1$2$3\.$4\.$5\.$6\.$7/gs;
  $TextBody=~s/ (doi\:[Dd][Oo][Ii]|DOI\:doi|DOI|doi|Doi)([\: ]+)$regx{doi}\.<yr>([^<>]+?)<\/yr>\.<v>([^<>]+?)<\/v>\.<pg>([^<>]+?)<\/pg>/ <doig>$1$2<doi>$3\.$4\.$5\.$6<\/doi><\/doig>/gs;
  $TextBody=~s/([\.\/])([0-9a-zA-Z\/\@\\\:\_\.\-–\(\)]+)\.<yr>([^<>]+?)<\/yr>\.<v>([^<>]+?)<\/v>\.<pg>([^<>]+?)<\/pg>/$1$2\.$3\.$4\.$5/gs;
  $TextBody=~s/(doi\:[Dd][Oo][Ii]|DOI\:doi|DOI|doi|Doi)([\: ]+)([0-9a-zA-Z\/\@\\\:\_\.\-–\(\)]+)\/([a-z0-9\.\-\/]+)<yr>([^<>]+?)<\/yr>([0-9a-z\-]+)/$1$2$3\/$4$5$6/gs;

#	    'doi' => '([\w\d\.\/\\\_\~\@–â€“\&\-–\/\(\)\[\]\;\:]+)',
  $TextBody=~s/([\.\,\s ]+)(doi\:[Dd][Oo][Ii]|DOI\:doi|[dD]oi|DOI)([\: ]+)([\w\d\.\/\\\_\~\@–â€“\&\-–\/\(\)\[\]\;\:]+)$regx{optionaEndPunc}<\/bib>/$1<doig>$2$3<doi>$4<\/doi><\/doig>$5<\/bib>/g;
  $TextBody=~s/([\.\,\s ]+)\((doi\:[Dd][Oo][Ii]|DOI\:doi|[dD]oi|DOI)([\: ]+)$regx{doi}\)$regx{optionaEndPunc}<\/bib>/$1\(<doig>$2$3<doi>$4<\/doi><\/doig>\)$5<\/bib>/g;
  $TextBody=~s/([\.\,\s ]+)(\\newblock\s*)(\d+\.\d+\/)$regx{doi}$regx{optionaEndPunc}<\/bib>/$1<doig>$2<doi>$3$4<\/doi><\/doig>$5<\/bib>/g;
  $TextBody=~s/([\.\,\s ]+)(doi\:[Dd][Oo][Ii]|DOI\:doi|[dD]oi|DOI)([\: ]+)$regx{doi}$regx{optionaEndPunc}$regx{extraInfoNoComment}/$1<doig>$2$3<doi>$4<\/doi><\/doig>$5$6/g;
  $TextBody=~s/([\.\,\s ]+)\((doi\:[Dd][Oo][Ii]|DOI\:doi|[dD]oi|DOI)([\: ]+)$regx{doi}\)$regx{optionaEndPunc}$regx{extraInfoNoComment}/$1\(<doig>$2$3<doi>$4<\/doi><\/doig>\)$5$6/g;
  $TextBody=~s/([\.\,\s ]+)(\\newblock\s*)(\d+\.\d+\/)$regx{doi}$regx{optionaEndPunc}$regx{extraInfoNoComment}/$1<doig>$2<doi>$3$4<\/doi><\/doig>$5$6/g;
  $TextBody=~s/\. <\/doi><\/doig>/<\/doi><\/doig>\. /gs;
  $TextBody=~s/([\.\,\s ]+)(dx.doi.org|DOI)$regx{doi}$regx{optionaEndPunc}$regx{extraInfoNoComment}/$1<doig><doi>$2$3<\/doi><\/doig>$4$5/gs;
  $TextBody=~s/([\.\,\s ]+)(doi\:[Dd][Oo][Ii]|DOI\:doi|[dD]oi|DOI)([\: ]+)<i>$regx{doi}<\/i>$regx{optionaEndPunc}$regx{extraInfoNoComment}/$1<doig>$2$3<doi><i>$4<\/i><\/doi><\/doig>$5$6/g;


  #398/399 (2001) 53.
 $TextBody=~s/$regx{wordPuncPrefix}$regx{volume}\/$regx{volume}$regx{optionalPuncSpace}\($regx{year}\)$regx{puncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<v>$2\/$3<\/v>$4\(<yr>$5<\/yr>\)$6<pg>$7<\/pg>$8$9/gs;

  #2008;321 (5887): pp. 385-388 (doi: 10.1126/science.1157996)
  $TextBody=~s/$regx{wordPuncParenPrefix}$regx{year}$regx{puncSpace}$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{pagePunc}\((DOI|doi|Doi)([\: ]+)$regx{doi}\)$regx{optionaEndPunc}$regx{extraInfoNoComment}/$1<yr>$2<\/yr>$3<v>$4<\/v>$5\(<iss>$6<\/iss>\)$7$8$9<pg>$10<\/pg>$11\(<doig>$12$13<doi>$14<\/doi><\/doig>\)$15$16/gs;
  $TextBody=~s/$regx{wordPuncParenPrefix}$regx{year}$regx{puncSpace}$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{pagePunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v>$4<\/v>$5\(<iss>$6<\/iss>\)$7$8$9<pg>$10<\/pg>$11$12/gs;
  $TextBody=~s/$regx{wordPuncParenPrefix}$regx{year}$regx{puncSpace}$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v>$4<\/v>$5\(<iss>$6<\/iss>\)$7$8$9<pg>$10<\/pg>$11$12/gs;

  #(2007) 195 (4): 469–470
  $TextBody=~s/$regx{wordPuncPrefix}\($regx{year}\)$regx{optionalPuncSpace}$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)$regx{issuePunc}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1\(<yr>$2<\/yr>\)$3<v>$4<\/v>$5\(<iss>$6<\/iss>\)$7<pg>$8<\/pg>$9$10/gs;

  $TextBody=~s/$regx{wordPuncPrefix}$regx{monthPrefix} $regx{dateDay} $regx{year}([\.\,\; ]+)$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)$regx{issuePunc}$regx{page}$regx{optionaEndPunc}$regx{extraInfoNoComment}/$1 $2 $3 <yr>$4<\/yr>$5<v>$6<\/v>$7\(<iss>$8<\/iss>\)$9<pg>$10<\/pg>$11$12/gs;
  #1973 2:(7824):328–9
  #2009 54(2):495-6. Epub 2009 Jan 29.</bib>
  $TextBody=~s/$regx{wordPuncParenPrefix}$regx{year}$regx{puncSpace}$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{pagePunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v>$4<\/v>$5\(<iss>$6<\/iss>\)$7<pg>$8<\/pg>$9$10/gs;
  $TextBody=~s/$regx{wordPuncParenPrefix}$regx{year}$regx{puncSpace}$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v>$4<\/v>$5\(<iss>$6<\/iss>\)$7<pg>$8<\/pg>$9$10/gs;

  #vol 53, no 4 (Sept. 1963), p 717–725
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{puncSpace}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{optionalPuncSpace}\($regx{monthPrefix}$regx{optionalPuncSpace}$regx{year}\)$regx{puncSpace}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1$2$3<v>$4<\/v>$5$6$7<iss>$8<\/iss>$9\($10$11<yr>$12<\/yr>\)$13$14$15<pg>$16<\/pg>$17$18/gs;
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{puncSpace}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{optionalPuncSpace}\($regx{monthPrefix}$regx{optionalPuncSpace}$regx{year}\)$regx{puncSpace}$regx{optionaEndPunc}$regx{extraInfo}/$1$2$3<v>$4<\/v>$5$6$7<iss>$8<\/iss>$9\($10$11<yr>$12<\/yr>\)$13<pg>$14<\/pg>$15$16/gs;


  #1988 Aug;8(4 Suppl):31S–37S
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year} $regx{monthPrefix}$regx{puncSpace}$regx{volume}$regx{optionalSpace}\($regx{issue} $regx{issuePrefix}\)$regx{issuePunc}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr> $3$4<v>$5<\/v>$6\(<iss>$7<\/iss> $8\)$9<pg>$10<\/pg>$11$12/g;
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year} $regx{monthPrefix}$regx{puncSpace}$regx{volume}$regx{optionalSpace}\($regx{issue} $regx{issuePrefix} $regx{issue}\)$regx{issuePunc}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr> $3$4<v>$5<\/v>$6\(<iss>$7 $8 $9<\/iss>\)$10<pg>$11<\/pg>$12$13/g;
  #1988 Dec;20 Suppl 5:75–78
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year} $regx{monthPrefix}$regx{puncSpace}$regx{volume} $regx{issuePrefix} $regx{issue}\:$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr> $3$4<v>$5<\/v> $6 <iss>$7<\/iss>\:<pg>$8<\/pg>$9$10/g;


  #<b>35 (3)</b> (1981) 148--150</bib>
  $TextBody=~s/$regx{wordPuncPrefix}<b>$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)<\/b>$regx{optionalPuncSpace}\($regx{year}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<v><b>$2<\/b><\/v>$3<b>\(<iss>$4<\/iss>\)<\/b>$5\(<yr>$6<\/yr>\)$7<pg>$8<\/pg>$9$10/gs;
  $TextBody=~s/$regx{wordPuncPrefix}<b>$regx{volume}<\/b>$regx{optionalPuncSpace}\($regx{issue}\)$regx{optionalPuncSpace}\($regx{year}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<v><b>$2<\/b><\/v>$3\(<iss>$4<\/iss>\)$5\(<yr>$6<\/yr>\)$7<pg>$8<\/pg>$9$10/gs;


  #22, 5 (2006), 303–310
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volume}$regx{puncSpace}$regx{issue}$regx{optionalPuncSpace}\($regx{year}\)$regx{puncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<v>$2<\/v>$3<iss>$4<\/iss>$5\(<yr>$6<\/yr>\)$7<pg>$8<\/pg>$9$10/gs;

  #35(5):S33-S36, 1994.</bib>
  $TextBody=~s/$regx{optionalSpace}$regx{volume}$regx{optionalSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{pagePunc}$regx{year}$regx{optionaEndPunc}$regx{extraInfo}/$1<v>$2<\/v>$3\(<iss>$4<\/iss>\)$5<pg>$6<\/pg>$7<yr>$8<\/yr>$9$10/g;
  $TextBody=~s/$regx{optionalSpace}<b>$regx{volume}<\/b>$regx{optionalSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{pagePunc}$regx{year}$regx{optionaEndPunc}$regx{extraInfo}/$1<v><b>$2<\/b><\/v>$3\(<iss>$4<\/iss>\)$5<pg>$6<\/pg>$7<yr>$8<\/yr>$9$10/g;
  #35(5):S33-S36 (1994).</bib>
  $TextBody=~s/$regx{optionalSpace}$regx{volume}$regx{optionalSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{puncSpace}\($regx{year}\)$regx{optionaEndPunc}$regx{extraInfo}/$1<v>$2<\/v>$3\(<iss>$4<\/iss>\)$5<pg>$6<\/pg>$7\(<yr>$8<\/yr>\)$9$10/g;
  $TextBody=~s/$regx{optionalSpace}<b>$regx{volume}<\/b>$regx{optionalSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{puncSpace}\($regx{year}\)$regx{optionaEndPunc}$regx{extraInfo}/$1<v><b>$2<\/b><\/v>$3\(<iss>$4<\/iss>\)$5<pg>$6<\/pg>$7\(<yr>$8<\/yr>\)$9$10/g;

  #1974 <b>110</b>:1007.</bib>
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}$regx{puncSpace}<b>$regx{volume}<\/b>$regx{volumePunc}$regx{page}$regx{pagePunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v><b>$4<\/b><\/v>$5<pg>$6<\/pg>$7$8/gs;
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}$regx{puncSpace}<b>$regx{volume}<\/b>$regx{volumePunc}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v><b>$4<\/b><\/v>$5<pg>$6<\/pg>$7$8/gs;


  #1990 [cited 2010 Apr 22];15(4):437-58. Available
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year} \[cited([^<>\[\]]+?)\]$regx{optionalPuncSpace}<b>$regx{volume}<\/b>$regx{optionalSpace}\($regx{issue}\)$regx{issuePunc}$regx{page}$regx{pagePunc}$regx{extraInfoNoComment}/$1<yr>$2<\/yr> \[cited$3\]$4<b><v>$5<\/v><\/b>$6\(<iss>$7<\/iss>\)$8<pg>$9<\/pg>$10$11/gs;
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year} \[cited([^<>\[\]]+?)\]$regx{optionalPuncSpace}$regx{volume}$regx{optionalSpace}\($regx{issue}\)$regx{issuePunc}$regx{page}$regx{pagePunc}$regx{extraInfoNoComment}/$1<yr>$2<\/yr> \[cited$3\]$4<v>$5<\/v>$6\(<iss>$7<\/iss>\)$8<pg>$9<\/pg>$10$11/gs;

  $TextBody=~s/<i>([^<>0-9\_]*?), (\d+) \((\d+)\)\, (\p{L}?\d+[\–\-]?\p{L}?[0-9]*)<\/i>$regx{optionaEndPunc}<\/bib>/<i>$1<\/i>, <v><i>$2<\/i><\/v> \(<iss>$3<\/iss>\)\, <pg>$4<\/pg>$5<\/bib>/gs;

  #19(2), 2005, 255-271.</bib>
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)$regx{puncSpace}$regx{monthPrefix}$regx{puncSpace}$regx{year}$regx{puncSpace}$regx{page}$regx{pagePunc}$regx{extraInfo}/$1<v>$2<\/v>$3\(<iss>$4<\/iss>\)$5$6$7<yr>$8<\/yr>$9<pg>$10<\/pg>$11$12/gs;

  #10 Suppl 2 (2011) S114–128.</bib>
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volume}$regx{optionalSpace}$regx{issuePrefix} $regx{issue}$regx{issuePunc}\($regx{year}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<v>$2<\/v>$3$4 <iss>$5<\/iss>$6\(<yr>$7<\/yr>\)$8<pg>$9<\/pg>$10$11/g;
  

  #. 2013 Apr;27(2):194-7</bib>
  $TextBody=~s/$regx{wordPuncPrefix} $regx{year} $regx{monthPrefix}([\:\.\,\; ]+)$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1 <yr>$2<\/yr> $3$4<v>$5<\/v>$6\(<iss>$7<\/iss>\)$8<pg>$9<\/pg>$10$11/gs;

  #2006 Nov 20;<b>185</b>(10):562-64.</bib>
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}([\.]?) $regx{monthPrefix} $regx{month}([\.\,\; ]+)<b>$regx{volume}<\/b>$regx{optionalPuncSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3 $4 $5$6<b><v>$7<\/v><\/b>$8\(<iss>$9<\/iss>\)$10<pg>$11<\/pg>$12$13/gs;
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}([\.]?) $regx{monthPrefix} $regx{month}([\.\,\; ]+)<i>$regx{volume}<\/i>$regx{optionalPuncSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3 $4 $5$6<v><i>$7<\/i><\/v>$8\(<iss>$9<\/iss>\)$10<pg>$11<\/pg>$12$13/gs;
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}([\.]?) $regx{monthPrefix} $regx{month}([\.\,\; ]+)$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3 $4 $5$6<v>$7<\/v>$8\(<iss>$9<\/iss>\)$10<pg>$11<\/pg>$12$13/gs;
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}([\.]?) $regx{monthPrefix}([\:\.\,\; ]+)<b>$regx{volume}<\/b>$regx{optionalPuncSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3 $4$5<b><v>$6<\/v><\/b>$7\(<iss>$8<\/iss>\)$9<pg>$10<\/pg>$11$12/gs;
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}([\.]?) $regx{monthPrefix}([\:\.\,\; ]+)<i>$regx{volume}<\/i>$regx{optionalPuncSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3 $4$5<v><i>$6<\/i><\/v>$7\(<iss>$8<\/iss>\)$9<pg>$10<\/pg>$11$12/gs;
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}([\.]?) $regx{monthPrefix}([\:\.\,\; ]+)$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3 $4$5<v>$6<\/v>$7\(<iss>$8<\/iss>\)$9<pg>$10<\/pg>$11$12/gs;
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}([\.]?) $regx{monthPrefix}$regx{puncSpace}$regx{dateDay}([\.\,\; ]+)$regx{volume}\:$regx{page}$regx{optionaEndPunc}$regx{extraInfoNoComment}/$1<yr>$2<\/yr>$3 $4$5$6$7<v>$8<\/v>\:<pg>$9<\/pg>$10$11/gs;



  #<b>Vol. 42, Issue 11</b> (1981) 148--150</bib>
  $TextBody=~s/$regx{wordPuncPrefix}<b>$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{optionalPuncSpace}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}<\/b>$regx{optionalPuncSpace}\($regx{year}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1$2$3<v>$4<\/v>$5$6$7<iss>$8<\/iss>$9\(<yr>$10<\/yr>\)$11<pg>$12<\/pg>$13$14/gs;

  #<b>Vol. 42, Issue 11</b> (1981) 148--150</bib>
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{puncSpace}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{optionalPuncSpace}\($regx{year}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1$2$3<v>$4<\/v>$5$6$7<iss>$8<\/iss>$9\(<yr>$10<\/yr>\)$11<pg>$12<\/pg>$13$15/gs;


  $TextBody=~s/$regx{wordPuncPrefix}$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{puncSpace}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{issuePunc}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionalPuncSpace}$regx{monthPrefix}$regx{optionalPuncSpace}$regx{year}$regx{optionaEndPunc}$regx{extraInfo}/$1$2$3<v>$4<\/v>$5$6$7<iss>$8<\/iss>$9$10$11<pg>$12<\/pg>$13$14$15<yr>$16<\/yr>$17$18/gs;
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{puncSpace}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{issuePunc}$regx{pagePrefix}$regx{optionalSpace}$regx{pageRange}$regx{optionaEndPunc}$regx{extraInfo}/$1$2$3<v>$4<\/v>$5$6$7<iss>$8<\/iss>$9$10$11<pg>$12<\/pg>$13$14/gs;

  $TextBody=~s/$regx{wordPuncPrefix}$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{puncSpace}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{issuePunc}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionalPuncSpace}$regx{year}$regx{optionaEndPunc}$regx{extraInfo}/$1$2$3<v>$4<\/v>$5$6$7<iss>$8<\/iss>$9$10$11<pg>$12<\/pg>$13<yr>$14<\/yr>$15$16/gs;

  #Vol. 42, Issue 11, pp. 148--150, 1981.</bib>
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{puncSpace}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{issuePunc}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{pagePunc}$regx{year}$regx{optionaEndPunc}$regx{extraInfo}/$1$2$3<v>$4<\/v>$5$6$7<iss>$8<\/iss>$9$10$11<pg>$12<\/pg>$13<yr>$14<\/yr>$15$16/gs;

  #vol. 199, no. 1, pp. 98-110, 16-Nov, 2009.
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{puncSpace}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{issuePunc}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{pagePunc}([0-9\-]+)$regx{monthPrefix}$regx{puncSpace}$regx{year}$regx{optionaEndPunc}$regx{extraInfo}/$1$2$3<v>$4<\/v>$5$6$7<iss>$8<\/iss>$9$10$11<pg>$12<\/pg>$13$14$15$16<yr>$17<\/yr>$18$19/gs;

  #Vol. 42, Issue 11, 148--150, 1981.</bib>
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{puncSpace}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{issueSpace}$regx{page}$regx{pagePunc}$regx{year}$regx{optionaEndPunc}$regx{extraInfo}/$1$2$3<v>$4<\/v>$5$6$7<iss>$8<\/iss>$9<pg>$10<\/pg>$11<yr>$12<\/yr>$13$14/gs;

  $TextBody=~s/$regx{wordPuncPrefix}$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{puncSpace}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{puncSpace}$regx{year}$regx{puncSpace}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/$1$2$3<v>$4<\/v>$5$6$7<iss>$8<\/iss>$9<yr>$10<\/yr>$11$12$13<pg>$14<\/pg>$15<\/bib>/gs;
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{puncSpace}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{puncSpace}$regx{year}$regx{puncSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/$1$2$3<v>$4<\/v>$5$6$7<iss>$8<\/iss>$9<yr>$10<\/yr>$11<pg>$12<\/pg>$13<\/bib>/gs;

  #16 (42): 20. Oktober 2011</bib>
  $TextBody=~s/([^<>0-9\_]+[\:\.\, ]+)$regx{volume}$regx{optionalSpace}\($regx{issue}\)$regx{puncSpace}$regx{page}$regx{pagePunc}([A-Za-z][^<>]+ [1-2][0987][0-9][0-9][a-z]?)<\/bib>/$1<v>$2<\/v>$3\(<iss>$4<\/iss>\)$5<pg>$6<\/pg>$7<month>$8<\/month><\/bib>/g;

  $TextBody=~s/([^<>0-9\_]+[\:\.\, ]+)$regx{volume}$regx{optionalSpace}\($regx{issue}\)$regx{puncSpace}$regx{page}$regx{pagePunc}([A-Za-z][^<>]+) $regx{year}\. ([^<>]*?)<\/bib>/$1<v>$2<\/v>$3\(<iss>$4<\/iss>\)$5<pg>$6<\/pg>$7<month>$8<\/month> <yr>$9<\/yr>\. $10<\/bib>/g;


  #2006 Nov 20;<b>185</b>(10):562-64.</bib>
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year} $regx{monthPrefix} $regx{month}([\:\.\,\; ]+)<b>$regx{volume}<\/b>$regx{optionalPuncSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr> $3 $4$5<b><v>$6<\/v><\/b>$7\(<iss>$8<\/iss>\)$9<pg>$10<\/pg>$11$12/gs;
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year} $regx{monthPrefix} $regx{month}([\:\.\,\; ]+)<i>$regx{volume}<\/i>$regx{optionalPuncSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr> $3 $4$5<i><v>$6<\/v><\/i>$7\(<iss>$8<\/iss>\)$9<pg>$10<\/pg>$11$12/gs;
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year} $regx{monthPrefix} $regx{month}([\:\.\,\; ]+)$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr> $3 $4$5<v>$6<\/v>$7\(<iss>$8<\/iss>\)$9<pg>$10<\/pg>$11$12/gs;
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year} $regx{monthPrefix}([\:\.\,\; ]+)<b>$regx{volume}<\/b>$regx{optionalPuncSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr> $3$4<b><v>$5<\/v><\/b>$6\(<iss>$7<\/iss>\)$8<pg>$9<\/pg>$10$11/gs;
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year} $regx{monthPrefix}([\:\.\,\; ]+)<i>$regx{volume}<\/i>$regx{optionalPuncSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr> $3$4<i><v>$5<\/v><\/i>$6\(<iss>$7<\/iss>\)$8<pg>$9<\/pg>$10$11/gs;
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year} $regx{monthPrefix}([\:\.\,\; ]+)$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr> $3$4<v>$5<\/v>$6\(<iss>$7<\/iss>\)$8<pg>$9<\/pg>$10$11/gs;

  #g, 37(3): 155-203, 2006.
  $TextBody=~s/([^<>0-9\_]+[\:\.\, ]+)$regx{volume}$regx{optionalSpace}\($regx{issue}\)$regx{issuePunc}$regx{page}$regx{pagePunc}$regx{year}\. ([^<>]*?)<\/bib>/$1<v>$2<\/v>$3\(<iss>$4<\/iss>\)$5<pg>$6<\/pg>$7<yr>$8<\/yr>\. $9<\/bib>/g;

  #196(2) (2008) 440--449</bib>
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)$regx{optionalPuncSpace}\($regx{year}\)$regx{puncSpace}$regx{page}$regx{optionaEndPunc}(<\/bib|\(|[Pp]ub[Mm]ed|[Dd][Oo][Ii]|[\(]?[eE]pub)/$1<v>$2<\/v>$3\(<iss>$4<\/iss>\)$5\(<yr>$6<\/yr>\)$7<pg>$8<\/pg>$9$10/gs;

  #<b>53</b>(3), 464––501 (2011)</bib>
 $TextBody=~s/$regx{puncSpace}<b>$regx{volume}<\/b>$regx{optionalSpace}\($regx{issue}\)$regx{issuePunc}$regx{page}$regx{pagePunc}\($regx{year}\)$regx{optionaEndPunc}(<\/bib|\(|[Pp]ub[Mm]ed|[Dd][Oo][Ii]|[\(]?[eE]pub)/$1<v><b>$2<\/b><\/v>$3\(<iss>$4<\/iss>\)$5<pg>$6<\/pg>$7\(<yr>$8<\/yr>\)$9$10/g;

 $TextBody=~s/$regx{puncSpace}<b>$regx{volume}<\/b>$regx{volumePunc}$regx{page}$regx{pagePunc}\($regx{year}\)$regx{optionaEndPunc}<\/bib>/$1<v><b>$2<\/b><\/v>$3<pg>$4<\/pg>$5\(<yr>$6<\/yr>\)$7<\/bib>/g;

  #  vol. 59, no. 2, pp. 813--822, Feb.-Oct. 2010.</bib>
  $TextBody=~s/\b$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{volumePunc}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{issuePunc}$regx{pagePrefix}$regx{page}$regx{pagePunc}$regx{monthPrefix}([\.\s\-–]+)$regx{monthPrefix}([\.\s]+)$regx{year}$regx{optionaEndPunc}<\/bib>/$1$2<v>$3<\/v>$4$5$6<iss>$7<\/iss>$8$9<pg>$10<\/pg>$11$12$13$14$15<yr>$16<\/yr>$17<\/bib>/gs;

  # vol. 30, no. 14–15, pp. 2976--2986, Oct. 2007.
  $TextBody=~s/\b$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{volumePunc}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{issuePunc}$regx{pagePrefix}$regx{page}$regx{pagePunc}$regx{monthPrefix}([\.\s]+)$regx{year}$regx{optionaEndPunc}<\/bib>/$1$2<v>$3<\/v>$4$5$6<iss>$7<\/iss>$8$9<pg>$10<\/pg>$11$12$13<yr>$14<\/yr>$15<\/bib>/gs;

  # vol. 30, pp. 2976--2986, Oct. 2007.
  $TextBody=~s/\b$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{volumePunc}$regx{pagePrefix}$regx{page}$regx{pagePunc}$regx{monthPrefix}([\.\s]+)$regx{year}$regx{optionaEndPunc}<\/bib>/$1$2<v>$3<\/v>$4$5<pg>$6<\/pg>$7$8$9<yr>$10<\/yr>$11<\/bib>/gs;

  #, vol. 2, pp 1382--1387 (1997)</bib>
  $TextBody=~s/\b$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{volumePunc}$regx{pagePrefix}$regx{puncSpace}$regx{page}$regx{pagePunc}\($regx{year}\)$regx{optionaEndPunc}<\/bib>/$1$2<v>$3<\/v>$4$5$6<pg>$7<\/pg>$8\(<yr>$9<\/yr>\)$10<\/bib>/gs;

  $TextBody=~s/\b$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{volumePunc}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{issuePunc}$regx{pagePrefix}$regx{page}$regx{pagePunc}$regx{year}$regx{optionaEndPunc}<\/bib>/$1$2<v>$3<\/v>$4$5$6<iss>$7<\/iss>$8$9<pg>$10<\/pg>$11<yr>$12<\/yr>$13<\/bib>/gs;

  $TextBody=~s/\b$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{volumePunc}$regx{pagePrefix}$regx{page}$regx{pagePunc}$regx{year}$regx{optionaEndPunc}$regx{extraInfo}/$1$2<v>$3<\/v>$4$5<pg>$6<\/pg>$7<yr>$8<\/yr>$9$10/gs;

  #select(undef, undef, undef,  $sleep1);

  #2009 Apr;9(4):239-52 (
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}$regx{optionalPuncSpace}$regx{monthPrefix}$regx{optionalPuncSpace}$regx{volume}$regx{optionalSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionalPuncSpace}\(/$1<yr>$2<\/yr>$3$4$5<v>$6<\/v>$7\(<iss>$8<\/iss>\)$9<pg>$10<\/pg>$11\(/gs;

  #2009 Apr;9(4):239-52.
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}$regx{optionalPuncSpace}$regx{monthPrefix}$regx{optionalPuncSpace}$regx{volume}$regx{optionalSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}\./$1<yr>$2<\/yr>$3$4$5<v>$6<\/v>$7\(<iss>$8<\/iss>\)$9<pg>$10<\/pg>./gs;

  #2009 Apr;9(Pt 4):239-52.
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}$regx{optionalPuncSpace}$regx{monthPrefix}$regx{optionalPuncSpace}$regx{volume}$regx{optionalSpace}\($regx{issuePrefix1} $regx{issue}\)$regx{optionalPuncSpace}$regx{page}\./$1<yr>$2<\/yr>$3$4$5<v>$6<\/v>$7\($8 <iss>$9<\/iss>\)$10<pg>$11<\/pg>./gs;

  #, 2009. <b>37</b>(suppl 2): p. W305-W311.</bib>
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}$regx{optionalPuncSpace}<b>$regx{volume}<\/b>$regx{optionalSpace}\($regx{issuePrefix}$regx{optionalSpace}$regx{issue}\)$regx{optionalPuncSpace}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v><b>$4<\/b><\/v>$5\($6$7<iss>$8<\/iss>\)$9$10$11<pg>$12<\/pg>$13$14/gs;
	  # 2008; <b>20</b> (Suppl..1): 64-72.
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}$regx{optionalPuncSpace}<b>$regx{volume}<\/b>$regx{optionalSpace}\($regx{issuePrefix}$regx{optionalSpace}$regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v><b>$4<\/b><\/v>$5\($6$7<iss>$8<\/iss>\)$9<pg>$10<\/pg>$11$12/gs;
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}$regx{optionalPuncSpace}<i>$regx{volume}<\/i>$regx{optionalSpace}\($regx{issuePrefix}$regx{optionalSpace}$regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v><i>$4<\/i><\/v>$5\($6$7<iss>$8<\/iss>\)$9<pg>$10<\/pg>$11$12/gs;
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}$regx{optionalPuncSpace}$regx{volume}$regx{optionalSpace}\($regx{issuePrefix}$regx{optionalSpace}$regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v>$4<\/v>$5\($6$7<iss>$8<\/iss>\)$9<pg>$10<\/pg>$11$12/gs;

  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}$regx{puncSpace} $regx{volume}([\,\;][ ]?)$regx{issue}\: $regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3 <v>$4<\/v>$5<iss>$6<\/iss>\: <pg>$7<\/pg>$8$9/gs;


  #2012 May-Jun;6(3):220–30 (
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}$regx{optionalPuncSpace}$regx{monthPrefix}([\.\s\-–]+)$regx{monthPrefix}$regx{optionalPuncSpace}$regx{volume}$regx{optionalSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionalPuncSpace}\(/$1<yr>$2<\/yr>$3$4$5$6$7<v>$8<\/v>$9\(<iss>$10<\/iss>\)$11<pg>$12<\/pg>$13\(/gs;

  #2012 May-Jun;6(3):220–30.
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}$regx{optionalPuncSpace}$regx{monthPrefix}([\.\s\-–]+)$regx{monthPrefix}$regx{optionalPuncSpace}$regx{volume}$regx{optionalSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}\./$1<yr>$2<\/yr>$3$4$5$6$7<v>$8<\/v>$9\(<iss>$10<\/iss>\)$11<pg>$12<\/pg>./gs;

  #2012 May-Jun;6(Pt 3):220–30.
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}$regx{optionalPuncSpace}$regx{monthPrefix}([\.\s\-–]+)$regx{monthPrefix}$regx{optionalPuncSpace}$regx{volume}$regx{optionalSpace}\($regx{issuePrefix1} $regx{issue}\)$regx{optionalPuncSpace}$regx{page}\./$1<yr>$2<\/yr>$3$4$5$6$7<v>$8<\/v>$9\($10 <iss>$11<\/iss>\)$12<pg>$13<\/pg>\./gs;
  #2002 Apr 1;62(7):2162-8 (
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}$regx{optionalPuncSpace}$regx{monthPrefix}([\.\s]+)$regx{month}$regx{puncSpace}$regx{volume}$regx{optionalSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionalPuncSpace}\(/$1<yr>$2<\/yr>$3$4$5$6$7<v>$8<\/v>$9\(<iss>$10<\/iss>\)$11<pg>$12<\/pg>$13\(/gs;

  #2002 Apr 1;62(Pt 7):2162-8.
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}$regx{optionalPuncSpace}$regx{monthPrefix}([\.\s]+)$regx{month}$regx{puncSpace}$regx{volume}$regx{optionalSpace}\($regx{issuePrefix1} $regx{issue}\)$regx{optionalPuncSpace}$regx{pageRange}\./$1<yr>$2<\/yr>$3$4$5$6$7<v>$8<\/v>$9\($10 <iss>$11<\/iss>\)$12<pg>$13<\/pg>\./gs;
  #2002 Apr 1;62(Pt 7):2162-8.
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}$regx{optionalPuncSpace}$regx{monthPrefix}([\.\s]+)$regx{month}$regx{puncSpace}$regx{volume}$regx{optionalSpace}\($regx{issuePrefix1} $regx{issue}\)$regx{optionalPuncSpace}$regx{pageRange}$regx{optionalPuncSpace}\(/$1<yr>$2<\/yr>$3$4$5$6$7<v>$8<\/v>$9\($10 <iss>$11<\/iss>\)$12<pg>$13<\/pg>$14\(/gs;

  #1995;Nov(320):110-4
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}$regx{yearPunc}$regx{monthPrefix}\($regx{issue}\)$regx{issuePunc}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3$4\(<iss>$5<\/iss>\)$6<pg>$7<\/pg>$8$9/igs;

  # #2002 Apr 1;62(7):2162-8.
  # $TextBody=~s/$regx{wordPuncPrefix}$regx{year}$regx{optionalPuncSpace}$regx{monthPrefix}([\.\s]+)$regx{month}$regx{puncSpace}$regx{volume}$regx{optionalSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionalPuncSpace}\(/$1<yr>$2<\/yr>$3$4$5$6$7<v>$8<\/v>$9\(<iss>$10<\/iss>\)$11<pg>$12<\/pg>$13(/gs;

 $TextBody=~s/$regx{wordPuncPrefix}$regx{year}$regx{optionalPuncSpace}$regx{monthPrefix}([\.\s]+)$regx{month}$regx{puncSpace}$regx{volume}$regx{optionalSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}\./$1<yr>$2<\/yr>$3$4$5$6$7<v>$8<\/v>$9\(<iss>$10<\/iss>\)$11<pg>$12<\/pg>./gs;
#. 2011 Apr;3(4):255-66


  #<b>196</b>(2) (May 2008) 440--449</bib>
  $TextBody=~s/$regx{wordPuncPrefix}<b>$regx{volume}<\/b>$regx{optionalPuncSpace}\($regx{issue}\)$regx{optionalPuncSpace}\($regx{monthPrefix}$regx{puncSpace}$regx{year}\)$regx{puncSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<v><b>$2<\/b><\/v>$3\(<iss>$4<\/iss>\)$5\($6$7<yr>$8<\/yr>\)$9<pg>$10<\/pg>$11<\/bib>/gs;

  #196(2) (May 2008) 440--449</bib>
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)$regx{optionalPuncSpace}\($regx{monthPrefix}$regx{puncSpace}$regx{year}\)$regx{puncSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v>$3\(<iss>$4<\/iss>\)$5\($6$7<yr>$8<\/yr>\)$9<pg>$10<\/pg>$11<\/bib>/gs;

  #, 2004, vol. 9, pp. 581--592.</bib>
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}$regx{puncSpace}$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{volumePunc}$regx{pagePrefix}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<yr>$2<\/yr>$3$4$5<v>$6<\/v>$7$8<pg>$9<\/pg>$10<\/bib>/gs;

  # ders; 1980.p 1007--38.</bib>
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}$regx{puncSpace}$regx{optionalSpace}$regx{pagePrefix}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<yr>$2<\/yr>$3$4$5<pg>$6<\/pg>$7<\/bib>/g;

   #2003;170(6 Pt 1):2163-72.  
  $TextBody=~s/$regx{optionalSpace}$regx{year}$regx{puncSpace}$regx{volume}$regx{optionalSpace}\($regx{issue} $regx{issuePrefix} $regx{issue}\)$regx{issuePunc}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v>$4<\/v>$5\($6 $7 <iss>$8<\/iss>\)$9<pg>$10<\/pg>$11$12/g;
  $TextBody=~s/$regx{optionalSpace}$regx{year}$regx{puncSpace}$regx{volume}$regx{optionalSpace}\($regx{issue} $regx{issuePrefix} $regx{issue}\)$regx{issuePunc}$regx{pageRange}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v>$4<\/v>$5\($6 $7 <iss>$8<\/iss>\)$9<pg>$10<\/pg>$11$12/g;


  # 2002; 3(suppl 2): S94-S98.</bib></p>
  $TextBody=~s/$regx{optionalSpace}$regx{year}$regx{puncSpace}$regx{volume}$regx{optionalSpace}\($regx{issuePrefix} $regx{issue}\)$regx{issuePunc}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v>$4<\/v>$5\($6 <iss>$7<\/iss>\)$8<pg>$9<\/pg>$10$11/g;
  # 2008; 133 (6 Suppl): 340S-80S.</bib></p>
  $TextBody=~s/$regx{optionalSpace}$regx{year}$regx{puncSpace}$regx{volume}$regx{optionalSpace}\($regx{issue} $regx{issuePrefix}\)$regx{issuePunc}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v>$4<\/v>$5\(<iss>$6<\/iss> $7\)$8<pg>$9<\/pg>$10$11/g;

  #1998. 50(2 Suppl 1): S23–6.
  $TextBody=~s/$regx{optionalSpace}$regx{year}$regx{puncSpace}$regx{volume}$regx{optionalSpace}\($regx{issue} $regx{issuePrefix} $regx{issue}\)$regx{issuePunc}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v>$4<\/v>$5\(<iss>$6 $7 $8<\/iss>\)$9<pg>$10<\/pg>$11$12/g;
  $TextBody=~s/$regx{optionalSpace}$regx{year}$regx{puncSpace}<b>$regx{volume}<\/b>$regx{optionalSpace}\($regx{issue} $regx{issuePrefix} $regx{issue}\)$regx{issuePunc}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v><b>$4<\/b><\/v>$5\(<iss>$6 $7 $8<\/iss>\)$9<pg>$10<\/pg>$11$12/g;
  
  #1998. 50(2 Suppl 1): p. S23–6.
  $TextBody=~s/$regx{optionalSpace}$regx{year}$regx{puncSpace}$regx{volume}$regx{optionalSpace}\($regx{issue} $regx{issuePrefix} $regx{issue}\)$regx{issuePunc}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v>$4<\/v>$5\(<iss>$6 $7 $8<\/iss>\)$9$10$11<pg>$12<\/pg>$13$14/g;
  $TextBody=~s/$regx{optionalSpace}$regx{year}$regx{puncSpace}<b>$regx{volume}<\/b>$regx{optionalSpace}\($regx{issue} $regx{issuePrefix} $regx{issue}\)$regx{issuePunc}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v><b>$4<\/b><\/v>$5\(<iss>$6 $7 $8<\/iss>\)$9$10$11<pg>$12<\/pg>$13$14/g;

  #1998; 50(2 Suppl 1): S31-S36.</bib></p><with><yr>1998</yr>; <v>50</v>(<iss>2</iss> Suppl 1):<pg>S31-S36</pg>.</bib></p>
  $TextBody=~s/$regx{optionalSpace}$regx{year}$regx{puncSpace}$regx{volume}$regx{optionalSpace}\($regx{issue} (\p{L}+ \d+)\)$regx{issuePunc}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v>$4<\/v>$5\(<iss>$6 $7<\/iss>\)$8<pg>$9<\/pg>$10$11/g;

  #1998;121 (Pt 10):1819–40.</bib></p><with><yr>1998</yr>; <v>121</v>(<iss>Pt 10</iss>):<pg>1819–40</pg>.</bib></p>
  $TextBody=~s/$regx{optionalSpace}$regx{year}$regx{puncSpace}$regx{volume}$regx{optionalSpace}\((\p{L}+\s*\d+)\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v>$4<\/v>$5\(<iss>$6<\/iss>\)$7<pg>$8<\/pg>$9$10/g;

  $TextBody=~s/$regx{optionalSpace}$regx{year}$regx{puncSpace}$regx{volume}$regx{optionalSpace}\((\d+) $regx{issuePrefix} (\d+)\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v>$4<\/v>$5\($6 $7 <iss>$8<\/iss>\)$9<pg>$10<\/pg>$11$12/g;

  #Res.1998; <b>22</b>(4):954--61.</bib>
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}$regx{puncSpace}<b>$regx{volume}<\/b>$regx{optionalSpace}\($regx{issue}\)$regx{issuePunc}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v><b>$4<\/b><\/v>$5\(<iss>$6<\/iss>\)$7<pg>$8<\/pg>$9$10/g;

  #Med, 2012. <b>267<\/b>(2): p. 115-123.</bib>
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}$regx{puncSpace}<b>$regx{volume}<\/b>$regx{optionalSpace}\($regx{issue}\)$regx{issuePunc}$regx{pagePrefix}$regx{puncSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<yr>$2<\/yr>$3<v><b>$4<\/b><\/v>$5\(<iss>$6<\/iss>\)$7$8$9<pg>$10<\/pg>$11<\/bib>/g;
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}$regx{puncSpace}$regx{volume}$regx{optionalSpace}\($regx{issue}\)$regx{issuePunc}$regx{pagePrefix}$regx{puncSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<yr>$2<\/yr>$3<v>$4<\/v>$5\(<iss>$6<\/iss>\)$7$8$9<pg>$10<\/pg>$11<\/bib>/g;

  #Med, 2012. <b>267<\/b>(Pt 2): p. 115-123.</bib>
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}$regx{puncSpace}<b>$regx{volume}<\/b>$regx{optionalSpace}\(Pt $regx{issue}\)$regx{issuePunc}$regx{pagePrefix}$regx{puncSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<yr>$2<\/yr>$3<v><b>$4<\/b><\/v>$5\(Pt <iss>$6<\/iss>\)$7$8$9<pg>$10<\/pg>$11<\/bib>/g;

  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}$regx{puncSpace}<b>$regx{volume}<\/b>$regx{optionalSpace}\((\d+) Pt $regx{issue}\)$regx{issuePunc}$regx{pagePrefix}$regx{puncSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<yr>$2<\/yr>$3<v><b>$4<\/b><\/v>$5\($6 Pt <iss>$7<\/iss>\)$8$9$10<pg>$11<\/pg>$12<\/bib>/g;

  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}$regx{puncSpace}<b>$regx{volume}$regx{optionalSpace}\(Pt $regx{issue}\)<\/b>$regx{issuePunc}$regx{pagePrefix}$regx{puncSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<yr>$2<\/yr>$3<v><b>$4<\/b><\/v>$5\(Pt <iss>$6<\/iss>\)$7$8$9<pg>$10<\/pg>$11<\/bib>/g;


  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}$regx{puncSpace}<b>$regx{volume}<\/b>$regx{volumePunc}$regx{pagePrefix}$regx{puncSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<yr>$2<\/yr>$3<v><b>$4<\/b><\/v>$5$6$7<pg>$8<\/pg>$9<\/bib>/g;

  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}$regx{puncSpace}$regx{volume}$regx{volumePunc}([RCSP]+\d+)$regx{optionaEndPunc}<\/bib>/$1<yr>$2<\/yr>$3<v><b>$4<\/b><\/v>$5<pg>$6<\/pg>$7<\/bib>/g;

  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}$regx{puncSpace}$regx{volume}$regx{volumePunc}$regx{pagePrefix}$regx{puncSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<yr>$2<\/yr>$3<v>$4<\/v>$5$6$7<pg>$8<\/pg>$9<\/bib>/g;

  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}$regx{puncSpace}$regx{volume}$regx{volumePunc}$regx{page}([\.\,\; ]+)([tT]able of [cC]ontent[s]?)([\.\,]?)<\/bib>/$1<yr>$2<\/yr>$3<v>$4<\/v>$5<pg>$6<\/pg>$7$8$9<\/bib>/g;

#  $TextBody=~s/$regx{optionalSpace}$regx{year}([ \w\-]*?)(\p{P}+\s*)(\d+)$regx{optionalSpace}\((\d+[\–\-\/0-9]*)\)(\p{P}?\s*)(\w+[\.\–\-]*\w*)([\.\,\: ]+)<doig>/$1<yr>$2<\/yr>$3$4<v>$5<\/v>$6\(<iss>$7<\/iss>\)$8<pg>$9<\/pg>$10<doig>/g;

$TextBody=~s/\&\#8209\;/--/g;
  #Res 2001; 94(1--2):9--14.
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}$regx{puncSpace}$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)$regx{puncSpace}$regx{page}$regx{optionaEndPunc}(<\/bib|\(|PubMed|DOI)/$1<yr>$2<\/yr>$3<v>$4<\/v>$5\(<iss>$6<\/iss>\)$7<pg>$8<\/pg>$9$10/ig;

  $TextBody=~s/$regx{wordPuncPrefix}<b>$regx{year}<\/b>([\s\.\,\;]+?)<i>$regx{volume}<\/i>$regx{volumePunc}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<yr><b>$2<\/b><\/yr>$3<v><i>$4<\/i><\/v>$5<pg>$6<\/pg>$7<\/bib>/gs;
  #1998; 8:89–102.</bib></p><with><yr>1998</yr>; <v>8</v>:<pg>89–102</pg>.</bib></p>
  $TextBody=~s/$regx{optionalSpace}$regx{year}$regx{puncSpace}$regx{volume}$regx{volumePunc}$regx{pageRange}$regx{optionaEndPunc}<\/bib>/$1<yr>$2<\/yr>$3<v>$4<\/v>$5<pg>$6<\/pg>$7<\/bib>/g;
  $TextBody=~s/$regx{optionalSpace}$regx{year}$regx{puncSpace}$regx{volume}$regx{volumePunc}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<yr>$2<\/yr>$3<v>$4<\/v>$5<pg>$6<\/pg>$7<\/bib>/g;

  # 58, 1, 1968, 64–71
  $TextBody=~s/$regx{puncSpace}$regx{volume}$regx{volumePunc}$regx{issue}$regx{issuePunc}$regx{year}$regx{puncSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v>$3<iss>$4<\/iss>$5<yr>$6<\/yr>$7<pg>$8<\/pg>$9<\/bib>/g;
  # 58, 1968, 64–71
  $TextBody=~s/$regx{puncSpace}$regx{volume}$regx{volumePunc}$regx{year}$regx{puncSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v>$3<yr>$4<\/yr>$5<pg>$6<\/pg>$7<\/bib>/g;
  #98: 365-376. 1999.</bib>
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volume}$regx{volumePunc}$regx{page}$regx{puncSpace}$regx{year}$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v>$3<pg>$4<\/pg>$5<yr>$6<\/yr>$7<\/bib>/g;

  #2003; 6:129-159 (DOI
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}$regx{puncSpace}$regx{volume}$regx{volumePunc}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v>$4<\/v>$5<pg>$6<\/pg>$7$8/gs;

  #Alizadeh O (2011). Mycorrhizal Symbiosis. Adv Studies Biol (3)6: 273–281
  $TextBody=~s/<bib([^<>]*?)>((?:(?!<[\/]?bib>).)*?)$regx{year}((?:(?!<[\/]?bib>).)*?)$regx{wordPuncPrefix}\($regx{issue}\) <b>$regx{volume}<\/b>([\,\: ]+)$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/<bib$1>$2$3$4$5\(<iss>$6<\/iss>\) <v><b>$7<\/b><\/v>$8<pg>$9<\/pg>$10$11/gs;
  $TextBody=~s/<bib([^<>]*?)>((?:(?!<[\/]?bib>).)*?)$regx{year}((?:(?!<[\/]?bib>).)*?)$regx{wordPuncPrefix}\($regx{issue}\)$regx{volume}([\: ]+)$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/<bib$1>$2$3$4$5\(<iss>$6<\/iss>\)<v>$7<\/v>$8<pg>$9<\/pg>$10$11/gs;
  $TextBody=~s/<bib([^<>]*?)>((?:(?!<[\/]?bib>)(?!1[987][0-9][0-9][a-z]?|20[0-9][0-9][a-z]?).)*?)$regx{wordPuncPrefix}\($regx{issue}\)$regx{volume}([\: ]+)$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/<bib$1>$2\(<yr>$3<\/yr>\)<v>$4<\/v>$5<pg>$6<\/pg>$7$8/gs;

  #, vol. 2003; pp 177-180. http:
  #$TextBody=~s/$regx{wordPuncPrefix}$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{puncSpace}$regx{pagePrefix}$regx{puncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfoNoComment}/$1$2$3<v>$4<\/v>$5$6$7<pg>$8<\/pg>$9$10/gs;


  #. 36 (2009). <doig>
  $TextBody=~s/<bib([^<>]*?)>((?:(?!<[\/]?bib>)(?!1[987][0-9][0-9][a-z]?|20[0-9][0-9][a-z]?).)*?)$regx{wordPuncPrefix}$regx{volume}$regx{optionalPuncSpace}\($regx{year}\)$regx{puncSpace}<doig>/<bib$1>$2$3<v>$4<\/v>$5\(<yr>$6<\/yr>\)$7<doig>/gs;
  $TextBody=~s/<bib([^<>]*?)>((?:(?!<[\/]?bib>)(?!1[987][0-9][0-9][a-z]?|20[0-9][0-9][a-z]?).)*?)$regx{wordPuncPrefix}<b>$regx{volume}<\/b>$regx{optionalPuncSpace}\($regx{year}\)$regx{puncSpace}<doig>/<bib$1>$2$3<v><b>$4<\/b><\/v>$5\(<yr>$6<\/yr>\)$7<doig>/gs;

  #, pp. 85-103 (2004)</bib>
  $TextBody=~s/([\,\.\;] )$regx{pagePrefix}$regx{puncSpace}$regx{page}$regx{optionalSpace}\($regx{year}\)$regx{optionaEndPunc}$regx{extraInfoNoComment}/$1$2$3<pg>$4<\/pg>$5\(<yr>$6<\/yr>\)$7$8/gs;
  #, 2003; pp 177-180. http:
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}$regx{puncSpace}$regx{pagePrefix}$regx{puncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfoNoComment}/$1<yr>$2<\/yr>$3$4$5<pg>$6<\/pg>$7$8/gs;

  #Harvard U.P. 1965, 3-22.</bib>
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}$regx{puncSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<yr>$2<\/yr>$3<pg>$4<\/pg>$5<\/bib>/gs;

  #. 27 (2006) pp 1787-1799</bib>
  #$TextBody=~s/((?:(?!<[\/]?bib>)(?!1[987][0-9][0-9][a-z]?|20[0-9][0-9][a-z]?).)*?)$regx{wordPuncPrefix}$regx{vol}
  $TextBody=~s/<bib([^<>]*?)>((?:(?!<[\/]?bib>)(?!1[987][0-9][0-9][a-z]?|20[0-9][0-9][a-z]?).)*?)$regx{wordPuncPrefix}$regx{volume}$regx{optionalPuncSpace}\($regx{year}\)$regx{optionalPuncSpace}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/<bib$1>$2$3<v>$4<\/v>$5\(<yr>$6<\/yr>\)$7$8$9<pg>$10<\/pg>$11<\/bib>/gs;
  $TextBody=~s/<bib([^<>]*?)>((?:(?!<[\/]?bib>)(?!1[987][0-9][0-9][a-z]?|20[0-9][0-9][a-z]?).)*?)$regx{wordPuncPrefix}$regx{volume}$regx{optionalPuncSpace}\($regx{year}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/<bib$1>$2$3<v>$4<\/v>$5\(<yr>$6<\/yr>\)$7<pg>$8<\/pg>$9<\/bib>/gs;

  #118, 12, 1 (2003)</bib>
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volume}([\.\,\:\;][ ]?)$regx{issue}$regx{puncSpace}$regx{page}$regx{optionalPuncSpace}\($regx{year}\)$regx{optionaEndPunc}$regx{extraInfo}/$1<v>$2<\/v>$3<iss>$4<\/iss>$5<pg>$6<\/pg>$7\(<yr>$8<\/yr>\)$9$10/gs;
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volume}([\.\,\:\;][ ]?)\[$regx{issue}\]$regx{puncSpace}$regx{page}$regx{optionalPuncSpace}\($regx{year}\)$regx{optionaEndPunc}$regx{extraInfo}/$1<v>$2<\/v>$3\[<iss>$4<\/iss>\]$5<pg>$6<\/pg>$7\(<yr>$8<\/yr>\)$9$10/gs;

  #Harvard U.P. 1965.</bib>
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}$regx{optionaEndPunc}<\/bib>/$1<yr>$2<\/yr>$3<\/bib>/gs;
  $TextBody=~s/$regx{wordPuncPrefix}\($regx{year}\)$regx{optionaEndPunc}<\/bib>/$1\(<yr>$2<\/yr>\)$3<\/bib>/gs;
  $TextBody=~s/<yr>$regx{year}<\/yr>([a-z])([\.\:\;\,]) <v>/<yr>$1$2<\/yr>$3 <v>/gs;
  $TextBody=~s/([\,\;] )$regx{volumePrefix} <yr>$regx{year}<\/yr>/$1$2 <v>$3<\/v>/gs;

  $TextBody=~s/$regx{monthPrefix} $regx{month}([\,]?) $regx{year} $regx{year}$regx{puncSpace}$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/$1 $2$3 $4 <yr>$5<\/yr>$6<v>$7<\/v>$8\(<iss>$9<\/iss>\)$10<pg>$11<\/pg>$12<\/bib>/gs;
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}\;$regx{optionalSpace}$regx{volume}\:$regx{optionalSpace}$regx{page}\-(e)$regx{optionaEndPunc}<\/bib>/$1<yr>$2<\/yr>\;$3<v>$4<\/v>\:$5<pg>$6\-$7<\/pg>$8<\/bib>/gs;

  #1987;316:1519-1524, 1580--158</bib>
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}([\;][ ]?)$regx{volume}([\:][ ]?)$regx{pageRange}, $regx{page}$regx{optionaEndPunc}<\/bib>/$1<yr>$2<\/yr>$3<v>$4<\/v>$5<pg>$6, $7<\/pg>$8<\/bib>/gs;
#  print $TextBody;

#, (1964) 1915-1918.</bib>
	$TextBody=~s/<bib$regx{noTagOpString}>((?:(?!<[\/]?yr>)(?!<[\/]?\b1[9867][0-9][0-9][a-z]?>)(?!<[\/]?\20[012][0-9][a-z]?>)(?!<bib)(?!<\/bib>).)*)\($regx{year}\)$regx{puncSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/<bib$1>$2\(<yr>$3<\/yr>\)$4<pg>$5<\/pg>$6<\/bib>/gs;
	$TextBody=~s/<bib$regx{noTagOpString}>([^<>]+?)(\W)(\d\d\d\d[a-z]?|\bin press)(\W)([^<>]*?)<\/bib>/<bib$1>$2$3<yr>$4<\/yr>$5$6<\/bib>/gs;
  return $TextBody;
}
#===============================================================================================
sub VolIssPg{
  my $TextBody=shift;
  my $application=shift;

  my ($sleepCounter, $sleep1, $sleep2)=(0, 0, 0);
  if (defined $application){
    if($application eq "AMPP" || $application eq "ampp"){
      $sleep1=0;
      $sleep2=0;
      # $sleep1=0.001;
      # $sleep2=0.001;

    }
  }


  $TextBody=~s/([dD][oO][iI])([\: ]*)([^ ]+?)<yr>([0-9]+)<\/yr>\.<v>([0-9]+)<\/v>\.<iss>([0-9]+)<\/iss>\.<pg>([0-9]+)<\/pg>/$1$2$3$4\.$5\.$6\.$7/gs;
  $TextBody=~s/(\) |\, |\:\s?)([0-9]+)\- ([0-9]+)([\.]?)<\/bib>/$1$2\-$3$4<\/bib>/gs;
  $TextBody=~s/(\) |\, |\:\s?)([0-9]+)\- ([0-9]+)([\.\, ]+)(doi|Doi|DOI)/$1$2\-$3$4$5/gs;
  $TextBody=~s/([pP]+[\.]?) ([0-9]+)\- ([0-9]+)/$1 $2\-$3/gs;


  #, vol. 50; Issue No. 2536, 18p
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{volumePunc}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{puncSpace}$regx{page}$regx{pagePrefix}$regx{optionaEndPunc}$regx{extraInfo}/$1$2$3<v>$4<\/v>$5$6$7<iss>$8<\/iss>$9<pg>$10<\/pg>$11$12$13/gs;

  $TextBody=~s/$regx{wordPuncPrefix}<b>$regx{volume}<\/b>$regx{optionalPuncSpace}\($regx{issue}\)$regx{puncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<v><b>$2<\/b><\/v>$3\(<iss>$4<\/iss>\)$5<pg>$6<\/pg>$7$8/gs;

  #Vol.&nbsp;36, No. 1, 30 March, pp. 63-80 (18).</bib>
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{volumePunc}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{puncSpace}$regx{dateDay}$regx{puncSpace}$regx{monthPrefix}$regx{puncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1$2$3<v>$4<\/v>$5$6$7<iss>$8<\/iss>$9$10$11$12$13<pg>$14<\/pg>$15$16/gs;
  #; Vol. 29, Issue 4</i>, 221-230.</bib>
  $TextBody=~s/([\;\.\, ]+)$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{volumePunc}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}<\/i>$regx{puncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/<\/i>$1<i>$2$3<v>$4<\/v>$5$6$7<iss>$8<\/iss><\/i>$9<pg>$10<\/pg>$11$12/gs;
  #; Vol. 29</i>, 221-230.</bib>
  $TextBody=~s/([\;\.\, ]+)$regx{volumePrefix}$regx{optionalSpace}$regx{volume}<\/i>$regx{puncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfoNoComment}/<\/i>$1<i>$2$3<v>$4<\/v><\/i>$5<pg>$6<\/pg>$7$8/gs;

  #vol. 12 iss. 1. pp. 65--78.
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{volumePunc}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{puncSpace}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1$2$3<v>$4<\/v>$5$6$7<iss>$8<\/iss>$9$10$11<pg>$12<\/pg>$13$14/gs;


  #</i>, <i>80(2)</i>, 441-476.
 $TextBody=~s/$regx{wordPuncPrefix}<i>$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)<\/i>$regx{puncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<i><v>$2<\/v>$3\(<iss>$4<\/iss>\)<\/i>$5<pg>$6<\/pg>$7$8/gs;

  #19(6):602-605. doi:
 $TextBody=~s/$regx{wordPuncPrefix}$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)$regx{puncSpace}$regx{page}$regx{optionaEndPunc}(DOI|doi|Doi)([\: ]+)$regx{doi}<\/bib>/$1<v>$2<\/v>$3\(<iss>$4<\/iss>\)$5<pg>$6<\/pg>$7$8$9<doi>$8<\/doi>/gs;
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)$regx{puncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<v>$2<\/v>$3\(<iss>$4<\/iss>\)$5<pg>$6<\/pg>$7$8/gs;

  #61</i>(13): 1113-1116. 
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volumePrefix}$regx{optionalSpace}$regx{volume}<\/i>$regx{optionalPuncSpace}\($regx{issue}\)$regx{issuePunc}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<\/i><i>$2$3<v>$4<\/v><\/i>$5\(<iss>$6<\/iss>\)$7<pg>$8<\/pg>$9$10/gs;
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volume}<\/i>$regx{optionalPuncSpace}\($regx{issue}\)$regx{issuePunc}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<\/i><v><i>$2<\/i><\/v>$3\(<iss>$4<\/iss>\)$5<pg>$6<\/pg>$7$8/gs;
  #, <i>31</i>(4), 895-917.
  $TextBody=~s/$regx{wordPuncPrefix}<i>$regx{volume}<\/i>$regx{optionalPuncSpace}\($regx{issue}\)$regx{issuePunc}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<v><i>$2<\/i><\/v>$3\(<iss>$4<\/iss>\)$5<pg>$6<\/pg>$7$8/gs;
  $TextBody=~s/ <\/i>/<\/i> /gs;

  #, XXVIII(3), 715–732.</bib>
  $TextBody=~s/$regx{wordPuncPrefix}([XVI]+)$regx{optionalPuncSpace}\($regx{issue}\)$regx{puncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<v>$2<\/v>$3\(<iss>$4<\/iss>\)$5<pg>$6<\/pg>$7$8/gs;

  #Vol. 56, No. 2, Feb. 2010, pp. 678--687. DOI 10.1109/TIT.2009.2037044
  $TextBody=~s/\b$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{volumePunc}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{issuePunc}$regx{monthPrefix}([a-z 0-9A-Z\.\,\:]+)([\.\, ]+)$regx{pagePrefix}$regx{page}([\.\, ]+)(DOI|doi|Doi)([\: ]+)$regx{doi}<\/bib>/$1$2<v>$3<\/v>$4$5$6<iss>$7<\/iss>$8<month>$9 $10<\/month>$11$12<pg>$13<\/pg>$14$15$16<doi>$17<\/doi><\/bib>/gs;

  $TextBody=~s/\b$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{volumePunc}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{issuePunc}$regx{monthPrefix}([a-z 0-9A-Z\.\,\:]+)([\.\, ]+)$regx{pagePrefix}$regx{page}([\.\, ]+)<doig>/$1$2<v>$3<\/v>$4$5$6<iss>$7<\/iss>$8<month>$9 $10<\/month>$11$12<pg>$13<\/pg>$14<doig>/gs;

  #Vol. 2, No. 3, pp. 321--341, DOI 10.1007/s12304-009-9059-z</bib>
  $TextBody=~s/\b$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{volumePunc}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{issuePunc}$regx{pagePrefix}$regx{page}([\.\, ]+)(DOI|doi|Doi)([\: ]+)$regx{doi}<\/bib>/$1$2<v>$3<\/v>$4$5$6<iss>$7<\/iss>$8$9<pg>$10<\/pg>$11$12$13<doi>$14<\/doi><\/bib>/gs;

  $TextBody=~s/\b$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{volumePunc}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{issuePunc}$regx{pagePrefix}$regx{page}$regx{pagePunc}<doig>/$1$2<v>$3<\/v>$4$5$6<iss>$7<\/iss>$8$9<pg>$10<\/pg>$11<doig>/gs;

  #. Vol. 23, No. 2, pp. 242.226
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{volumePunc}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{issuePunc}$regx{pagePrefix}$regx{page}\.$regx{page}$regx{extraInfo}/$1$2$3<v>$4<\/v>$5$6$7<iss>$8<\/iss>$9$10<pg>$11\.$12<\/pg>$13/gs;

  #, 41, pp. 1693-1703, 1995.
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volume}$regx{volumePunc}$regx{pagePrefix}$regx{page}$regx{pagePunc}$regx{year}$regx{optionaEndPunc}$regx{extraInfo}/$1<v>$2<\/v>$3$4<pg>$5<\/pg>$6<yr>$7<\/yr>$8$9/gs;

  #. Vol. 7, No. S 1:5--24</bib>
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{volumePunc}$regx{issuePrefix}$regx{optionalSpace}$regx{pagePrefix}$regx{optionalSpace}$regx{issue}\:$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1$2$3<v>$4<\/v>$5$6$7$8$9<iss>$10<\/iss>\:<pg>$11<\/pg>$12$13/gs;

  #vol 34(5), pp. 582-586, September-October <yr>2007</yr>.
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{optionalSpace}\($regx{issue}\)$regx{issuePunc}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{pagePunc}$regx{monthPrefix}-$regx{monthPrefix}([\, ]+)<yr>$regx{year}<\/yr>$regx{optionaEndPunc}$regx{extraInfo}/$1$2$3<v>$4<\/v>$5\(<iss>$6<\/iss>\)$7$8$9<pg>$10<\/pg>$11$12-$13$14<yr>$15<\/yr>$16$17/gs;
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{optionalSpace}\($regx{issue}\)$regx{issuePunc}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{pagePunc}$regx{monthPrefix}-$regx{monthPrefix}([\, ]+)$regx{year}$regx{optionaEndPunc}$regx{extraInfo}/$1$2$3<v>$4<\/v>$5\(<iss>$6<\/iss>\)$7$8$9<pg>$10<\/pg>$11$12-$13$14<yr>$15<\/yr>$16$17/gs;

  #Vol. 2, pp. 321--341, DOI 10.1007/s12304-009-9059-z</bib>
  $TextBody=~s/\b$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{volumePunc}$regx{pagePrefix}$regx{page}$regx{pagePunc}(DOI|doi|Doi)([\: ]+)$regx{doi}<\/bib>/$1$2<v>$3<\/v>$4$5<pg>$6<\/pg>$7$8$9<doi>$10<\/doi><\/bib>/gs;

  #Vol. 1, pp. 221--138. <doig>
  $TextBody=~s/\b$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{volumePunc}$regx{pagePrefix}$regx{page}$regx{pagePunc}<doig>/$1$2<v>$3<\/v>$4$5<pg>$6<\/pg>$7<doig>/gs;

  #Vol. 40, No. 3, pp. 343--348, Nov. 1st.</bib>
  $TextBody=~s/\b$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{volumePunc}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{issuePunc}$regx{pagePrefix}$regx{page}$regx{pagePunc}$regx{monthPrefix}([a-z 0-9A-Z\.\,\:]+)$regx{optionaEndPunc}<\/bib>/$1$2<v>$3<\/v>$4$5$6<iss>$7<\/iss>$8$9<pg>$10<\/pg>$11<month>$12$13<\/month>$14<\/bib>/gs;

  #, Jg. 20, Nr. 2, S. 51-62.
  #Vol. 2, No. 3, pp. 321--341.</bib>
  $TextBody=~s/\b$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{volumePunc}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{issuePunc}$regx{pagePrefix}$regx{page}$regx{optionaEndPunc}<\/bib>/$1$2<v>$3<\/v>$4$5$6<iss>$7<\/iss>$8$9<pg>$10<\/pg>$11<\/bib>/gs;

 #Heft 1 / Jg. 25, S. 121-140.
  #$TextBody=~s/\b$regx{issuePrefix}$regx{optionalSpace}([\-–\/\d]+[A-Z]?)([\s\,\.\/]+)$regx{volumePrefix}$regx{optionalSpace}([A-Z]*[0-9\-–]+[A-Z]?)([\s\,\.]+)$regx{pagePrefix}([SP]?\d+[A-Z\-–]*?[\dA-Z]*?)([\.\,]*)<\/bib>/$1$2<iss>$3<\/iss>$4$5$6<v>$7<\/v>$8$9<pg>$10<\/pg>$11<\/bib>/gs;

$TextBody=~s/\b$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{puncSpace}$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{puncSpace}$regx{pagePrefix}$regx{page}$regx{optionaEndPunc}<\/bib>/$1$2<iss>$3<\/iss>$4$5$6<v>$7<\/v>$8$9<pg>$10<\/pg>$11<\/bib>/gs;

  #, 34. Jg. Nr. 2, S. 231-252.</bib>
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volume}$regx{volumePunc}$regx{volumePrefix}$regx{puncSpace}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}([\s\,\.]+[pPS\.]+\s*)$regx{page}$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v>$3$4$5$6$7<iss>$8<\/iss>$9<pg>$10<\/pg>$11<\/bib>/gs;
  #, 35. Jg., Heft 4, S. 432--439.</bib>
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volume}$regx{puncSpace}$regx{volumePrefix}$regx{puncSpace}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}([\s\,\.]+[pPS\.]+\s*)$regx{page}$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v>$3$4$5$6$7<iss>$8<\/iss>$9<pg>$10<\/pg>$11<\/bib>/gs;
  #, 35, Heft 4, S. 432--439.</bib>
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volume}$regx{puncSpace}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}([\s\,\.]+[pPS\.]+\s*)$regx{page}$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v>$3$4$5<iss>$6<\/iss>$7<pg>$8<\/pg>$9<\/bib>/gs;

  # 2 No(1):71-87</bib>
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volume}$regx{optionalSpace}$regx{issuePrefix}$regx{optionalSpace}\($regx{issue}\)$regx{issuePunc}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v>$3$4$5\(<iss>$6<\/iss>\)$7<pg>$8<\/pg>$9<\/bib>/gs;


  $TextBody=~s/\($regx{year}\)([^<>]+?)$regx{wordPuncPrefix}$regx{volume}$regx{volumePunc}\($regx{issue}\)\. $regx{monthPrefix} $regx{month}$regx{puncSpace}\1<\/bib>/\($1\)$2$3<v>$4<\/v>$5\(<iss>$6<\/iss>\)\. <comment>$7 $8$9$1<\/comment><\/bib>/gs;
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volume}$regx{volumePunc}\($regx{issue}\)\. $regx{monthPrefix} $regx{month}$regx{puncSpace}$regx{year}<\/bib>/$1<v>$2<\/v>$3\(<iss>$4<\/iss>\)\. $7 $8$9<yr>$10<\/yr><\/bib>/gs;

  #, 50. Jg., S. 45-62.</bib>
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volume}$regx{volumePunc}$regx{volumePrefix}([\s\,\.]+[pPS\.]+\s*)$regx{page}$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v>$3$4$5<pg>$6<\/pg>$7<\/bib>/gs;

  $TextBody=~s/\b$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{volumePunc}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{issuePunc}$regx{pagePrefix}$regx{page}([\.\,]*)<\/bib>/$1$2<v>$3<\/v>$4$5$6<iss>$7<\/iss>$8$9<pg>$10<\/pg>$11<\/bib>/gs;

	  #select(undef, undef, undef,  $sleep1);

  #Vol. 3, pp. 321--341.</bib>
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{volumePunc}$regx{pagePrefix}$regx{page}$regx{optionaEndPunc}<\/bib>/$1$2$3<v>$4<\/v>$5$6<pg>$7<\/pg>$8<\/bib>/gs;

  #No. 3, pp. 321--341.</bib>
  $TextBody=~s/$regx{wordPuncPrefix}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{issuePunc}$regx{pagePrefix}$regx{page}$regx{optionaEndPunc}<\/bib>/$1$2$3<iss>$4<\/iss>$5$6<pg>$7<\/pg>$8<\/bib>/gs;

  #Vol. 41, No. 3 (INT), pp. 28--34.</bib></p>
  $TextBody=~s/\b$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{volumePunc}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{optionalSpace}\((INT)\)$regx{puncSpace}$regx{pagePrefix}$regx{page}$regx{optionaEndPunc}<\/bib>/$1$2<v>$3<\/v>$4$5$6<iss>$7<\/iss>$8\($9\)$10$11<pg>$12<\/pg>$13<\/bib>/gs;


  #33: L19712, 5 <doig>
  $TextBody=~s/([^<>0-9\_]+?[\.\,\: ]+)$regx{volume}$regx{volumePunc}L$regx{issue}$regx{issuePunc}$regx{page}$regx{optionalPuncSpace}(<\/bib>|<doig>)/$1<v>$2<\/v>$3<iss>L$4<\/iss>$5<pg>$6<\/pg>$7$8/g;
#  32:557.e11–13.</bib>
  $TextBody=~s/([^<>0-9\_]+?[\.\,\: ]+)$regx{volume}:$regx{issue}\.$regx{page}$regx{optionalPuncSpace}(<\/bib>|<doig>)/$1<v>$2<\/v>:<iss>$3<\/iss>\.<pg>$4<\/pg>$5$6/g;

  $TextBody=~s/$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{volumePunc}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{issuePunc}$regx{pagePrefix}$regx{pageRange}$regx{optionaEndPunc}<\/bib>/$1$2<v>$3<\/v>$4$5$6<iss>$7<\/iss>$8$9<pg>$10<\/pg>$11<\/bib>/gs;


  #<i>Journal of Aging Studies, 23 (10)</i>. 48-59</bib>
  $TextBody=~s/([a-zA-Z]+)([\?\.\,\; ]+)$regx{volume}$regx{optionalSpace}\($regx{issue}\)$regx{optionalPunc}<\/i>\($regx{issuePunc}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<\/i><i>$2<\/i><v><i>$3<\/i><\/v>$4<i>\(<iss>$5<\/iss>\)<\/i>$6$7<pg>$8<\/pg>$9<\/bib>/g;

  #<i>Journal of Aging Studies, 23 (10). 48-59</i></bib>
  $TextBody=~s/([a-zA-Z]+)([\?\.\,\; ]+)$regx{volume}$regx{optionalSpace}\($regx{issue}\)$regx{issuePunc}$regx{pagePunc}$regx{optionalPunc}<\/i>$regx{optionaEndPunc}<\/bib>/$1<\/i><i>$2<\/i><v><i>$3<\/i><\/v>$4<i>\(<iss>$5<\/iss>\)<\/i>$6<pg>$7<\/pg>$8$9<\/bib>/g;

  $TextBody=~s/([a-zA-Z]+)\)([\.\,\; ]+)(\d+[\-–\d]+)<\/i>([ ]?)\(/$1\)<\/i>$2<i>$3<\/i>$4\(/g;
  $TextBody=~s/([a-zA-Z]+)\)([\.\,\; ]+)(\d+[A-Z]?)<\/i>([ ]?)\(/$1\)<\/i>$2<i>$3<\/i>$4\(/g;

  $TextBody=~s/([^<>0-9\_\,\:\?\!]+) (\d+[\-–\d]?)<\/i>/$1<\/i> <i>$2<\/i>/g;
  $TextBody=~s/([^<>0-9\_\,\:\?\!]+) (\d+[A-Z]?)<\/i>/$1<\/i> <i>$2<\/i>/g;


  # Injury 35 Suppl 2: SB23--35</bib></p>
  $TextBody=~s/([^<>0-9\_]+?[\.\,\: ]+)(\d+)([\.\,\: ]+)([\(]?)([Ss]uppl)([\.\,\: ]+)(\d+)([\)]?)([\.\,\;\: ]+)(\p{L}{0,2}\d+[\–\-]{0,2}\p{L}{0,2}[0-9]*)/$1<v>$2<\/v>$3$4<iss>$5$6$7<\/iss>$8$9<pg>$10<\/pg>/g;

  #84 (3 Suppl):i109–117.
  $TextBody=~s/([^<>0-9\_]+?[\.\,\: ]+)(\d+)([\.\,\: ]+)\((\d+)([\s]+)([Ss]uppl[\.]?)\)([\.\,\;\: ]+)([ie]?\d+[\–\-0-9]*)/$1<v>$2<\/v>$3\(<iss>$4<\/iss>$5$6\)$7<pg>$8<\/pg>/g;

  # ; 3(supplement);94-98.</bib></p>
  $TextBody=~s/(\p{P}?\s*)(\d+)$regx{optionalSpace}\((\p{L}+)\)$regx{optionalPunc}$regx{optionalSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v>$3\(<iss>$4<\/iss>\)$5$6<pg>$7<\/pg>$8<\/bib>/g;

  # 2002; 3(suppl 2): S94-S98.</bib></p>
  $TextBody=~s/(\p{P}?)\s*(\d+)\s*\((\p{L}+) (\d+)\)$regx{issuePunc}$regx{page}$regx{optionaEndPunc}<\/bib>/$1 <v>$2<\/v>\($3 <iss>$4<\/iss>\)$5<pg>$6<\/pg>$7<\/bib>/g;

  #1998; 50(2 Suppl 1): S31-S36.</bib></p><with><yr>1998</yr>; <v>50</v>(<iss>2</iss> Suppl 1):<pg>S31-S36</pg>.</bib></p>
  $TextBody=~s/(\p{P}?)\s*(\d+[A-Z]?)\s*\((\d+) (\p{L}+ \d+)\)$regx{issuePunc}$regx{page}$regx{optionaEndPunc}<\/bib>/$1 <v>$2<\/v>\(<iss>$3 $4<\/iss>\)$5<pg>$6<\/pg>$7<\/bib>/g;

  $TextBody=~s/([\.\;\, ]+?)(\d+[A-Z]?)\((\d+) ([Ss]uppl[\.]?)\)$regx{issuePunc}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v>\(<iss>$3<\/iss> $4\)$5<pg>$6<\/pg>$7<\/bib>/gs;

  #, 35(Suppl. 5), S33-S36.
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volume}\($regx{issuePrefix}$regx{optionalSpace}$regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<v>$2<\/v>\($3$4<iss>$5<\/iss>\)$6<pg>$7<\/pg>$8$9/gs;

  #24(11 Suppl. 4):27-35
  $TextBody=~s/([\.\;\, ]+?)(\d+[A-Z]?)\((\d+ [Ss]uppl[\.]?) (\d+)\)$regx{issuePunc}$regx{pageRange}$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v>\($3 <iss>$4<\/iss>\)$5<pg>$6<\/pg>$7<\/bib>/gs;
  $TextBody=~s/([\.\;\, ]+?)(\d+[A-Z]?)\((\d+ [Ss]uppl[\.]?) (\d+)\)$regx{issuePunc}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v>\($3 <iss>$4<\/iss>\)$5<pg>$6<\/pg>$7<\/bib>/gs;


  #172(5 Suppl):S<pg>1-S21</pg>.
  #1998;121 (Pt 10):1819–40.</bib></p><with><yr>1998</yr>; <v>121</v>(<iss>Pt 10</iss>):<pg>1819–40</pg>.</bib></p>
  $TextBody=~s/(\p{P}?\s*)(\d+)$regx{optionalSpace}\((\p{L}+\s*\d+)\)$regx{issuePunc}$regx{pageRange}$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v>$3\(<iss>$4<\/iss>\)$5<pg>$6<\/pg>$7<\/bib>/g;
  #6(4): 363–6</bib></p><with><yr>2005</yr>; <v>6</v>(<iss>4</iss>):<pg>363–6</pg></bib></p>
  $TextBody=~s/(\p{P}?\s*)$regx{volume}$regx{optionalSpace}\($regx{issue}\)$regx{issuePunc}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v>$3\(<iss>$4<\/iss>\)$5<pg>$6<\/pg>$7<\/bib>/g;

  #Research <i>13</i>(10), 89-–102.</bib></p><with>Research <v>13</v>, <pg>89–102</pg>.</bib></p>
  $TextBody=~s/([^<>0-9\_]+[\:\.\, ]*)(<i>)$regx{volume}(<\/i>[\s]?)\($regx{issue}\)$regx{issuePunc}$regx{page}$regx{optionalPunc}(\s?)(<\/bib>|<doig>| <doig>)/$1$2<v>$3<\/v>$4\(<iss>$5<\/iss>\)$6<pg>$7<\/pg>$8$9$10/g;

  #Research <i>13</i>(10), 89-–102.</bib></p><with>Research <v>13</v>, <pg>89–102</pg>.</bib></p>
  $TextBody=~s/([^<>0-9\_]+[\:\.\, ]*)(<i>)(\d+[A-Z]?)(<\/i>[\s]?)\($regx{issue}\)$regx{issuePunc}$regx{page}$regx{optionalPunc}(<\/bib>|<doig>| <doig>)/$1$2<v>$3<\/v>$4\(<iss>$5<\/iss>\)$6<pg>$7<\/pg>$8$9/g;

  #Research <i>13</i>(10), 89-–102.</bib></p><with>Research <v>13</v>, <pg>89–102</pg>.</bib></p>
  $TextBody=~s/([^<>0-9\_]+[\:\.\, ]*)(<i>)$regx{volume}(<\/i>[\s]?)\($regx{issue}\)$regx{issuePunc}$regx{page}$regx{optionalPunc}(<\/bib>|<doig>| <doig>)/$1$2<v>$3<\/v>$4\(<iss>$5<\/iss>\)$6<pg>$7<\/pg>$8$9/g;

  #, <i>17</i>(Special Issue), 155--165.</bib>
  #Research 13(10), 89-–102.</bib></p><with>Research <v>13</v>, <pg>89–102</pg>.</bib></p>
  $TextBody=~s/([^<>0-9\_]+[\:\.\, ]*)$regx{volume}$regx{optionalSpace}\($regx{issue}\)$regx{issuePunc}$regx{page}$regx{optionalPunc}(<\/bib>|[ ]?<doig>|[\s]?\([iI]n [Cc]hinese\))/$1<v>$2<\/v>$3\(<iss>$4<\/iss>\)$5<pg>$6<\/pg>$7$8/g;
  $TextBody=~s/([^<>0-9\_]+[\:\.\, ]*)$regx{volume}$regx{optionalSpace}\($regx{issue}\)$regx{issuePunc}$regx{page}$regx{optionalPunc}(<\/bib>|[ ]?<doig>|[\s]?\([iI]n [Cc]hinese\))/$1<v>$2<\/v>$3\(<iss>$4<\/iss>\)$5<pg>$6<\/pg>$7$8/g;


  #21, Hft. 1. 30–53
  $TextBody=~s/([^<>0-9\_]+[\:\.\, ]*)$regx{volume}$regx{volumePunc}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{issuePunc}$regx{page}$regx{optionalPunc}(<\/bib>|[ ]?<doig>)/$1<v>$2<\/v>$3$4$5<iss>$6<\/iss>$7<pg>$8<\/pg>$9$10/g;

  #Research 13A(10), 89-–102.</bib></p><with>Research <v>13</v>, <pg>89–102</pg>.</bib></p>
  $TextBody=~s/([^<>0-9\_]+[\:\.\, ]*)$regx{volume}$regx{optionalSpace}\($regx{issue}\)$regx{issuePunc}$regx{page}$regx{optionalPunc}(<\/bib>|<doig>| <doig>)/$1<v>$2<\/v>$3\(<iss>$4<\/iss>\)$5<pg>$6<\/pg>$7$8/g;

  #Research 13. (10), 89-–102.</bib></p><with>Research <v>13</v>, <pg>89–102</pg>.</bib></p>
  $TextBody=~s/([^<>0-9\_]+[\:\.\, ]*)$regx{volume}$regx{volumePunc}\($regx{issue}\)$regx{issuePunc}$regx{page}$regx{optionalPunc}(<\/bib>|[ ]?<doig>|[\s]?\([iI]n [Cc]hinese\))/$1<v>$2<\/v>$3\(<iss>$4<\/iss>\)$5<pg>$6<\/pg>$7$8/g;

  #, 3(2), pp. 111-137.
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)$regx{puncSpace}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v>$3\(<iss>$4<\/iss>\)$5$6$7<pg>$8<\/pg>$9<\/bib>/gs;

  #20 (1): 191–200.</bib>
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)$regx{puncSpace}$regx{page}$regx{pagePunc}\($regx{monthPrefix}$regx{puncSpace}$regx{year}\)$regx{optionaEndPunc}(<\/bib|[\(]?[Pp]ub[Mm]ed|[\(]?[Dd][Oo][Ii]|[\(]?[eE]pub|[\(]?[dD]iscussion|[\(]?[Rr]etriev[e]?[d]?|[ ]?<doig>)/$1<v>$2<\/v>$3\(<iss>$4<\/iss>\)$5<pg>$6<\/pg>$7\($8$9<yr>$10<\/yr>\)$11$12/gs;

  #Review 32(3)836-863.</bib>
 $TextBody=~s/$regx{wordPuncPrefix}$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<v>$2<\/v>$3\(<iss>$4<\/iss>\)$5<pg>$6<\/pg>$7$8/gs;
  #</i> 96 <b>(10)</b>, 10-14.</bib>
 $TextBody=~s/$regx{wordPuncPrefix}$regx{volume}$regx{optionalPuncSpace}<b>\($regx{issue}\)<\/b>$regx{optionalPuncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<v>$2<\/v>$3<b>\(<iss>$4<\/iss>\)<\/b>$5<pg>$6<\/pg>$7$8/gs;

  #xxx 9, 2: 158–81.
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volume}\, $regx{issue}: $regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<v>$2<\/v>\, <iss>$3<\/iss>: <pg>$4<\/pg>$5$6/gs;
  #Research 13. (10), pp. 89-–102.</bib></p><with>Research <v>13</v>, <pg>89–102</pg>.</bib></p>
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)$regx{issuePunc}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionalPunc}$regx{extraInfo}/$1<v>$2<\/v>$3\(<iss>$4<\/iss>\)$5$6$7<pg>$8<\/pg>$9$10/g;

  $TextBody=~s/([a-zA-Z]+)([\:\.\, ]+)$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)$regx{issuePunc}$regx{page}$regx{optionalPunc}<\/i>$regx{optionalPunc}(<\/bib|[\(]?[Pp]ub[Mm]ed|[\(]?[Dd][Oo][Ii]|[\(]?[eE]pub|[\(]?[dD]iscussion|[\(]?[Rr]etriev[e]?[d]?|[ ]?<doig>)/$1<\/i>$2<v>3<\/v>$4\(<iss>$5<\/iss>\)$6<pg>$7<\/pg>$8$9$10/g;

  $TextBody=~s/([a-zA-Z]+)([\:\.\, ]+)$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)$regx{issuePunc}([p]+[\. ]+)$regx{page}$regx{optionalPunc}<\/i>$regx{optionalPunc}(<\/bib|[\(]?[Pp]ub[Mm]ed|[\(]?[Dd][Oo][Ii]|[\(]?[eE]pub|[\(]?[dD]iscussion|[\(]?[Rr]etriev[e]?[d]?|[ ]?<doig>)/$1<\/i>$2<v><i>3<\/i><\/v>$4\(<iss>$5<\/iss>\)$6$7<pg>$8<\/pg>$9$10$11/g;

  $TextBody=~s/([a-zA-Z]+)<\/i>([\:\.\, ]+)(\d+[A-Z]?)([\s\.\,\:]*)\($regx{issue}\)$regx{issuePunc}([p]+[\. ]+)$regx{page}$regx{optionalPunc}(<\/bib|[\(]?[Pp]ub[Mm]ed|[\(]?[Dd][Oo][Ii]|[\(]?[eE]pub|[\(]?[dD]iscussion|[\(]?[Rr]etriev[e]?[d]?|[ ]?<doig>)/$1<\/i>$2<v>3<\/v>$4\(<iss>$5<\/iss>\)$6$7<pg>$8<\/pg>$9$10/g;


  #58 (2): P80–P87</bib>

  #In: Laboratory Invest. 78 (1998) S. 377--392.</bib>
  $TextBody=~s/([^<>0-9\_]+[\:\.\, ]*)$regx{volume}$regx{optionalPuncSpace}\($regx{year}\)([ ]?S[\. ]+)$regx{page}$regx{optionalPunc}(<\/bib|[\(]?[Pp]ub[Mm]ed|[\(]?[Dd][Oo][Ii]|[\(]?[eE]pub|[\(]?[dD]iscussion|[\(]?[Rr]etriev[e]?[d]?|[ ]?<doig>)/$1<v>$2<\/v>$3\(<yr>$4<\/yr>\)$5<pg>$6<\/pg>$7$8/g;

  #27:77-86 (2006)</bib>
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volume}$regx{volumePunc}$regx{page}$regx{optionalSpace}\($regx{year}\)$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v>$3<pg>$4<\/pg>$5\(<yr>$6<\/yr>\)$7<\/bib>/gs;


  #12: 3, S. 371--395.</bib>
  $TextBody=~s/([^<>0-9\_]+?[\.\,\: ]+)$regx{volume}$regx{volumePunc}$regx{issue}$regx{issuePunc}$regx{pagePrefix}$regx{pagePrefixPunc}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<v>$2<\/v>$3<iss>$4<\/iss>$5$6$7<pg>$8<\/pg>$9$10/g;

  $TextBody=~s/([^<>0-9\_]+?[\.\,\: ]+)$regx{volume}$regx{volumePunc}$regx{issue}$regx{issuePunc}$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<v>$2<\/v>$3<iss>$4<\/iss>$5<pg>$6<\/pg>$7$8/g;

 $TextBody=~s/([^<>0-9\_]+?[\.\,\: ]+)$regx{volume}$regx{volumePunc}$regx{issue}$regx{issuePunc}$regx{pagePrefix}$regx{pagePrefixPunc}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v>$3<iss>$4<\/iss>$5$6$7<pg>$8<\/pg>$9<\/bib>/g;

  #Research <i>13</i>, 89-–102.</bib></p><with>Research <v>13</v>, <pg>89–102</pg>.</bib></p>
  $TextBody=~s/([^<>0-9\_]+[\:\.\, ]*)(<i>)$regx{volume}(<\/i>)$regx{volumePunc}$regx{pageRange}$regx{optionalPunc}(<\/bib>|<doig>| <doig>)/$1$2<v>$3<\/v>$4$5<pg>$6<\/pg>$7$8/g;
  $TextBody=~s/([^<>0-9\_]+[\:\.\, ]*)(<i>)$regx{volume}(<\/i>)$regx{volumePunc}$regx{page}$regx{optionalPunc}(<\/bib>|<doig>| <doig>)/$1$2<v>$3<\/v>$4$5<pg>$6<\/pg>$7$8/g;

  # 2, 2, 2517-2522
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volume}$regx{volumePunc}$regx{issuePunc}$regx{issuePunc}$regx{pageRange}$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v>$3<iss>$4<\/iss>$5<pg>$6<\/pg>$7<\/bib>/g;
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volume}$regx{volumePunc}$regx{issuePunc}$regx{issuePunc}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v>$3<iss>$4<\/iss>$5<pg>$6<\/pg>$7<\/bib>/g;

  $TextBody=~s/$regx{wordPuncPrefix}$regx{volumePrefix}$regx{optionalSpace}$regx{volume}\, Part ([A-Z] [0-9])\, $regx{page}$regx{optionaEndPunc}<\/bib>/$1$2$3<v>$4<\/v>\, Part <iss>$5<\/iss>\, <pg>$6<\/pg>$7<\/bib>/gs;


  #Research 13, 89-–102.</bib></p><with>Research <v>13</v>, <pg>89–102</pg>.</bib></p>
  $TextBody=~s/([^0-9\_]+[\:\.\, ]*)$regx{volume}$regx{volumePunc}$regx{pageRange}$regx{optionalPunc}(<\/bib|[\(]?[Pp]ub[Mm]ed|[\(]?[Dd][Oo][Ii]|[\(]?[eE]pub|[\(]?[dD]iscussion|[\(]?[Rr]etriev[e]?[d]?|[ ]?<doig>|[\s]?\([iI]n [Cc]hinese\))/$1<v>$2<\/v>$3<pg>$4<\/pg>$5$6/g;
  $TextBody=~s/([^0-9\_]+[\:\.\, ]*)$regx{volume}$regx{volumePunc}$regx{page}$regx{optionalPunc}(<\/bib|[\(]?[Pp]ub[Mm]ed|[\(]?[Dd][Oo][Ii]|[\(]?[eE]pub|[\(]?[dD]iscussion|[\(]?[Rr]etriev[e]?[d]?|[ ]?<doig>|[\s]?\([iI]n [Cc]hinese\))/$1<v>$2<\/v>$3<pg>$4<\/pg>$5$6/g;

  #Research 13, 89-–102.</bib></p><with>Research <v>13</v>, <pg>89–102</pg>.</bib></p>
  $TextBody=~s/([^0-9\_]+[\:\.\, ]*)$regx{volume}$regx{volumePunc}$regx{pagePrefix}$regx{pagePrefixPunc}$regx{page}$regx{optionalPunc}(<\/bib|[\(]?[Pp]ub[Mm]ed|[\(]?[Dd][Oo][Ii]|[\(]?[eE]pub|[\(]?[dD]iscussion|[\(]?[Rr]etriev[e]?[d]?|[ ]?<doig>|[\s]?\([iI]n [Cc]hinese\))<\/bib>/$1<v>$2<\/v>$3$4$5<pg>$6<\/pg>$7$8/g;

  # v. GE-4, No. 1, p. 25-38
 $TextBody=~s/$regx{wordPuncPrefix}([Vv][\. ]+)$regx{volume}$regx{volumePunc}$regx{issuePrefix}$regx{issue}$regx{puncSpace}$regx{pagePrefix}$regx{page}$regx{optionaEndPunc}<\/bib>/$1$2<v>$3<\/v>$4$5<iss>$6<\/iss>$7$8<pg>$9<\/pg>$10<\/bib>/g;
 $TextBody=~s/$regx{wordPuncPrefix}([Vv][\. ]+)$regx{volume}$regx{volumePunc}$regx{pagePrefix}$regx{pagePrefixPunc}$regx{page}$regx{optionaEndPunc}<\/bib>/$1$2<v>$3<\/v>$4$5$6<pg>$7<\/pg>$8<\/bib>/g;
#  v.30, p. 580–607.

  #Am 35: 383--395, xi</bib></p><with>Am <v>35</v>: <pg>383--395</pg>, xi</bib></p>
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volume}$regx{volumePunc}$regx{pageRange}$regx{puncSpace}([a-z]+)$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v>$3<pg>$4<\/pg>$5$6$7<\/bib>/g;
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volume}$regx{volumePunc}$regx{pagePrefix}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v>$3$4<pg>$5<\/pg>$6<\/bib>/gs;

  ##25, Heft 1. 55–67</bib>
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volume}$regx{volumePunc}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{puncSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v>$3$4$5<iss>$6<\/iss>$7<pg>$8<\/pg>$9<\/bib>/g;

  $TextBody=~s/([A-Za-z]+[\?\.]?)<\/i>$regx{optionalPuncSpace}<i>$regx{volume}<\/i>$regx{volumePunc}$regx{page}$regx{optionaEndPunc}(DOI|doi|Doi)([\: ]+)$regx{doi}<\/bib>/$1<\/i>$2<v><i>$3<\/i><\/v>$4<pg>$5<\/pg>$6$7$8<doi>$9<\/doi><\/bib>/g;

  $TextBody=~s/([A-Za-z]+[\?\.]?)<\/i>$regx{optionalPuncSpace}<i>$regx{volume}<\/i>$regx{volumePunc}$regx{page}$regx{optionaEndPunc}(<\/bib|[\(]?[Pp]ub[Mm]ed|[\(]?[Dd][Oo][Ii]|[\(]?[eE]pub|[\(]?[dD]iscussion|[\(]?[Rr]etriev[e]?[d]?|[ ]?<doig>|[\s]?\([iI]n [Cc]hinese\))/$1<\/i>$2<v><i>$3<\/i><\/v>$4<pg>$5<\/pg>$6$7/g;

  $TextBody=~s/$regx{wordPuncPrefix}$regx{volume}$regx{volumePunc}$regx{page}\. (<u>[\(]?[Dd][Oo][Ii])/$1<v>$2<\/v>$3<pg>$4<\/pg>\. $5/gs;

  #</i>, <b>18</b>, 626-634</bib>
  $TextBody=~s/$regx{wordPuncPrefix}<b>$regx{volume}<\/b>\, $regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1<v><b>$2<\/b><\/v>\, <pg>$3<\/pg>$4$5/gs;

  # Am 30A: 735–744</bib>
  $TextBody=~s/ $regx{wordPuncPrefix}$regx{volume}$regx{volumePunc}$regx{page}$regx{optionaEndPunc}(<\/bib|[\(]?[Pp]ub[Mm]ed|[\(]?[Dd][Oo][Ii]|[\(]?[eE]pub|[\(]?[dD]iscussion|[\(]?[Rr]etriev[e]?[d]?|[ ]?<doig>|[\s]?\([iI]n [Cc]hinese\))/ $1<v>$2<\/v>$3<pg>$4<\/pg>$5$6/g;
  $TextBody=~s/ ([A-Za-z]+)$regx{puncSpace}$regx{volume}$regx{volumePunc}$regx{page}$regx{optionalPunc}<\/i>$regx{optionaEndPunc}<\/bib>/ $1<\/i>$2<v>$3<\/v>$4<pg>$5<\/pg>$6$7<\/bib>/g;
  $TextBody=~s/([A-Za-z]+)<\/i>$regx{puncSpace}$regx{volume}$regx{volumePunc}([pP][pP][\. ]*)$regx{page}$regx{optionaEndPunc}<\/bib>/$1<\/i>$2<v>$3<\/v>$4$5<pg>$6<\/pg>$7<\/bib>/g;
  $TextBody=~s/$regx{puncSpace}<i>$regx{volume}<\/i>$regx{puncSpace}$regx{page}$regx{optionalPuncSpace}\(([Ii]n [A-Za-z\, ]+)\)$regx{optionaEndPunc}<\/bib>/$1<i><v>$2<\/v><\/i>$3<pg>$4<\/pg>$5\($6\)$7<\/bib>/gs;


  #63:64-68. WOS:A1997WR94300013
  #3:749-755. http://www.jstor.org/stable/1444342
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volumeNoAlpha}$regx{volumePunc}$regx{page}$regx{puncSpace}$regx{extraInfo}/$1<v>$2<\/v>$3<pg>$4<\/pg>$5$6/g;
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volume}$regx{volumePunc}$regx{page}$regx{optionaEndPunc}$regx{extraInfoNoComment}/$1<v>$2<\/v>$3<pg>$4<\/pg>$5$6/g;
  #volumeNoAlpha
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volumePrefix}$regx{optionalSpace}<v>$regx{volume}<\/v>$regx{volumePunc}<pg>$regx{page}<\/pg>$regx{puncSpace}$regx{ednSuffix}/$1$2$3$4$5$6$7$8/g;

  $TextBody=~s/<bib([^<>]+?)>((?:(?!<bib)(?!<\/bib)(?!<[\/]?cny>)(?!<[\/]?pbl>)(?!<\/yr>).)+?) ([\(]?)$regx{year}([\)]?[\.]?) ((?:(?!<bib)(?!<\/bib)(?!<[\/]?cny>)(?!<[\/]?pbl>)(?!<\/yr>).)+? [a-zA-Z]+[\)\?\.\,]*) <yr>$regx{year}<\/yr>\:<pg>([^<>]+?)<\/pg>([\.]?)<\/bib>/<bib$1>$2 $3$4$5 $6 <v>$7<\/v>\:<pg>$8<\/pg>$9<\/bib>/gs;


  #</i> <b><i>38</i>,</b> 698-713   #</i>, <b><i>38</i></b>, 698-713</bib>
 $TextBody=~s/$regx{wordPuncPrefix}<b><i>$regx{volume}<\/i><\/b>\, $regx{page}$regx{optionaEndPunc}$regx{extraInfoNoComment}/$1<b><v><i>$2<\/i><\/v><\/b>\, <pg>$3<\/pg>$4$5/gs;

  #</i>, XLIX, 496-507</bib>
  $TextBody=~s/$regx{wordPuncPrefix}([XVLI]+)$regx{puncSpace}$regx{page}$regx{optionaEndPunc}$regx{extraInfoNoComment}/$1<v>$2<\/v>$3<pg>$4<\/pg>$5$6/gs;

  # One 4:e6754</bib></p>
  $TextBody=~s/([^<>0-9\_]+[\:\.\, ]*)(\d+)$regx{volumePunc}([eL]\d+)$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v>$3<pg>$4<\/pg>$5<\/bib>/g;

  #, <i>38</i>, L16706.</bib>
  $TextBody=~s/([\.\;\:\, ]+)<i>$regx{volume}<\/i>$regx{volumePunc}([eL]\d+)$regx{optionaEndPunc}<\/bib>/$1<v><i>$2<\/i><\/v>$3<pg>$4<\/pg>$5<\/bib>/g;


  # Am 30A: 735–744</bib>
  $TextBody=~s/([\.\,\;\:\? ]+)$regx{volume}$regx{volumePunc}$regx{page}$regx{optionaEndPunc}(<\/bib|[\(]?[Pp]ub[Mm]ed|[\(]?[Dd][Oo][Ii]|[\(]?[eE]pub|[\(]?[dD]iscussion|[\(]?[Rr]etriev[e]?[d]?|[ ]?<doig>|[\s]?\([iI]n [Cc]hinese\))/$1<v>$2<\/v>$3<pg>$4<\/pg>$5$6/g;
  $TextBody=~s/([a-zA-Z]+[\.]?)<\/i> <b>$regx{volume}<\/b>$regx{volumePunc}$regx{page}$regx{optionaEndPunc}(<\/bib|[\(]?[Pp]ub[Mm]ed|[\(]?[Dd][Oo][Ii]|[\(]?[eE]pub|[\(]?[dD]iscussion|[\(]?[Rr]etriev[e]?[d]?|[ ]?<doig>|[\s]?\([iI]n [Cc]hinese\))/$1<\/i> <v><b>$2<\/b><\/v>$3<pg>$4<\/pg>$5$6/gs;
  $TextBody=~s/([a-zA-Z]+[\.]?) <b>$regx{volume}<\/b>$regx{volumePunc}$regx{page}$regx{optionaEndPunc}(<\/bib|[\(]?[Pp]ub[Mm]ed|[\(]?[Dd][Oo][Ii]|[\(]?[eE]pub|[\(]?[dD]iscussion|[\(]?[Rr]etriev[e]?[d]?|[ ]?<doig>|[\s]?\([iI]n [Cc]hinese\))/$1 <v><b>$2<\/b><\/v>$3<pg>$4<\/pg>$5$6/gs;


  #. 43. 695-716.</bib>
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volume}\. $regx{pageRange}$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v>\. <pg>$3<\/pg>$4<\/bib>/g;

  $TextBody=~s/([A-Za-z]+)([\,\.\;]) ([e0-9\-]+) ([pPS]+)$regx{optionaEndPunc}<\/bib>/$1$2 <pg>$3<\/pg> $4$5<\/bib>/gs;

  #<\/i>\, <i>62<\/i>, S.&nbsp;15–21.
  $TextBody=~s/$regx{wordPuncPrefix} <i>$regx{volume}<\/i>\, $regx{pagePrefix}$regx{page}$regx{optionaEndPunc}<\/bib>/$1 <v><i>$2<\/i><\/v>\, $3<pg>$4<\/pg>$5<\/bib>/gs;

  #. 37, S-78-S-85</bib>
  $TextBody=~s/([\.\,\;\:\? ]+)$regx{volume}$regx{volumePunc}([Se]?[\-]?[0-9]+\-[Se]?[\-]?[0-9]+)$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v>$3<pg>$4<\/pg>$5<\/bib>/g;

  $TextBody=~s/([^0-9]+)([\.\,\; ]+)$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{volumePunc}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{optionaEndPunc}<\/bib>/$1$2$3$4<v>$5<\/v>$6$7$8<iss>$9<\/iss>$10<\/bib>/gs;
  $TextBody=~s/([^0-9\,\;\:\.]+ )$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{volumePunc}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{optionaEndPunc}<\/bib>/$1$2$3<v>$4<\/v>$5$6$7<iss>$8<\/iss>$9<\/bib>/gs;
  $TextBody=~s/([^0-9]+)([\.\,\; ]+)$regx{volume}$regx{optionalSpace}$regx{volumePrefix}$regx{puncSpace}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{optionaEndPunc}<\/bib>/$1$2<v>$3<\/v>$4$5$6$7$8<iss>$9<\/iss>$10<\/bib>/gs;
  $TextBody=~s/([^0-9\,\;\:\.]+ )$regx{volume}$regx{optionalSpace}$regx{volumePrefix}$regx{puncSpace}$regx{issuePrefix}$regx{optionalSpace}$regx{issue}$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v>$3$4$5$6$7<iss>$8<\/iss>$9<\/bib>/gs;
  $TextBody=~s/\,$regx{optionalSpace}$regx{pagePrefix}$regx{pagePrefixPunc}$regx{page}$regx{pagePunc}\($regx{year}\)$regx{optionaEndPunc}<\/bib>/\,$1$2$3<pg>$4<\/pg>$5\(<yr>$6<\/yr>\)$7<\/bib>/gs;


  #1981;36(10) [special issue].</bib>
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year}$regx{puncSpace}$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)$regx{optionaEndPunc}$regx{extraInfo}/$1<yr>$2<\/yr>$3<v>$4<\/v>$5\(<iss>$6<\/iss>\)$7$8/gs;

  $TextBody=~s/$regx{wordPuncPrefix}$regx{volume}$regx{optionalPuncSpace}\[$regx{issue}\], $regx{page}$regx{optionaEndPunc}$regx{extraInfoNoComment}/$1<v>$2<\/v>$3\[<iss>$4<\/iss>\], <pg>$5<\/pg>$6$7/gs;

  #19:317 S</bib>
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volume}$regx{volumePunc}$regx{page}$regx{optionalSpace}$regx{pagePrefix}$regx{optionaEndPunc}$regx{extraInfoNoComment}/$1<v>$2<\/v>$3<pg>$4<\/pg>$5$6$7$8/gs;

  $TextBody=~s/$regx{wordPuncPrefix}<i>$regx{volume}<\/i>$regx{optionalSpace}\($regx{issuePrefix} $regx{issue}\)$regx{issuePunc}$regx{page}$regx{optionaEndPunc}$regx{extraInfoNoComment}/$1<v><i>$2<\/i><\/v>$3\($4 <iss>$5<\/iss>\)$6<pg>$7<\/pg>$8$9/gs;
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volume}\. $regx{page}$regx{optionaEndPunc}$regx{extraInfoNoComment}/$1 <v>$2<\/v>\. $3$4$5/gs;
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volume}([\,\:\; ]+)([0-9]+)\.$regx{pageRange}\.([0-9]+)$regx{optionaEndPunc}<\/bib>/$1 <v>$2<\/v>$3<pg>$4\.$5\.$6<\/pg>$7<\/bib>/gs;
  $TextBody=~s/$regx{wordPuncPrefix}<i>$regx{volume}<\/i>([\,\:\; ]+)([0-9]+)\.$regx{pageRange}\.([0-9]+)$regx{optionaEndPunc}<\/bib>/$1<v><i>$2<\/i><\/v>$3<pg>$4\.$5\.$6<\/pg>$7<\/bib>/gs;
  $TextBody=~s/$regx{wordPuncPrefix}<i>$regx{volume}<\/i>([\,\.\:\; ]+)$regx{page}$regx{optionaEndPunc}$regx{extraInfoNoComment}/$1<v><i>$2<\/i><\/v>$3<pg>$4<\/pg>$5$6/gs;

  #36 (10) (special issue)
  #Psychologist, 36(10).</bib>
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volume}$regx{optionalPuncSpace}\($regx{issue}\)$regx{optionaEndPunc}$regx{extraInfoNoComment}/$1<v>$2<\/v>$3\(<iss>$4<\/iss>\)$5$6/gs;
  #81: 1688-1693; 1785–1789</bib>
  $TextBody=~s/$regx{wordPuncPrefix}$regx{volume}\: $regx{pageRange}\; $regx{pageRange}$regx{optionaEndPunc}$regx{extraInfo}/$1<v>$2<\/v>\: <pg>$3\; $4<\/pg>$5$6/gs;


  $TextBody=~s/([A-Za-z]+)<\/i>$regx{puncSpace}<i>$regx{volume}<\/i>\($regx{issue}\)$regx{optionaEndPunc}$regx{extraInfo}/$1<\/i>$2<v><i>$3<\/i><\/v>\(<iss>$4<\/iss>\)$5$6/gs;

   $TextBody=~s/>$regx{optionaEndPunc}(DOI|doi|Doi)([\: ]+)$regx{doi}<\/bib>/>$1$2$3<doi>$4<\/doi><\/bib>/g;

  #Patent
  $TextBody=~s/ ([Pp]atent)([\.\,\; ]+)([A-Z][A-Z0-9]+)<v>([^<>]+?)<\/v>([\.\,\;]) <pg>$regx{year}<\/pg>$regx{optionaEndPunc}$regx{extraInfo}/ $1$2$3$4$5 <yr>$6<\/pg>$7$8/gs;
  $TextBody=~s/ ([Pp]atent)([\.\,\; ]+)<v>([A-Z][A-Z0-9]+)<\/v>/ $1$2$3/gs;
  #China Patent

  #ISBN <v>978-3-89574</v> <pg>838-7</pg>.</bib>
  $TextBody=~s/([\.\,\;]) ISBN <v>([^<>]+)<\/v> <pg>([^<>]+?)<\/pg>$regx{optionaEndPunc}$regx{extraInfoNoComment}/$1 ISBN $2 $3$4$5/gs;


  $TextBody=~s/\] $regx{year} \[([^<>\[\]]+?)\]\. ([Aa]vailable)/\] <yr>$1<\/yr> \[$2\]\. $3/gs;

  #doi:10.1016/j.anifeedsci.<yr>2011</yr>.<v>04</v>.<pg>002</pg>
  $TextBody=~s/ (doi\:DOI|DOI\:doi|DOI|doi|Doi)([\: ]+)$regx{doi}\.<yr>([^<>]+?)<\/yr>\.<v>([^<>]+?)<\/v>\.<pg>([^<>]+?)<\/pg>/ <doig>$1$2<doi>$3\.$4\.$5\.$6<\/doi><\/doig>/gs;

  $TextBody=~s/([\.\/])([0-9a-zA-Z\/\@\\\:\_\.\-–\(\)]+)\.<yr>([^<>]+?)<\/yr>\.<v>([^<>]+?)<\/v>\.<pg>([^<>]+?)<\/pg>/$1$2\.$3\.$4\.$5/gs;

  #original work published 1965 
  $TextBody=~s/([oO]riginal [wW]ork [pP]ublished) <yr>$regx{year}<\/yr>/$1 $2/gs;

  #; 2006. http://
  $TextBody=~s/\; $regx{year}\. (http\:\/\/|www|ftp)/\; <yr>$1<\/yr>\. $2/gs;
  #\, May <v>18</v>, <pg>2004</pg>.</bib>

  $TextBody=~s/\, $regx{monthPrefix} <v>([^<>]*?)<\/v>([\,\;\.\: ]+)<pg>$regx{year}<\/pg>\.<\/bib>/\, $1 $2$3$4\.<\/bib>/gs;

  $TextBody=~s/<bib([^<>]*?)>((?:(?!<[\/]?bib>)(?!1[987][0-9][0-9][a-z]?|20[0-9][0-9][a-z]?).)+?)\, <v>([^<>]+?)<\/v>\, <iss>$regx{year}<\/iss>\, $regx{pagePrefix}$regx{optionalSpace}<pg>([^<>]+?)<\/pg>$regx{optionaEndPunc}<\/bib>/<bib$1>$2\, <v>$3<\/v>\, <yr>$4<\/yr>\, $5$6<pg>$7<\/pg>$8<\/bib>/gs;
  $TextBody=~s/<bib([^<>]*?)>((?:(?!<[\/]?bib>)(?!1[987][0-9][0-9][a-z]?|20[0-9][0-9][a-z]?).)+?)\, <v>([^<>]+?)<\/v>\, <iss>$regx{year}<\/iss>\, <pg>([^<>]+?)<\/pg>$regx{optionaEndPunc}<\/bib>/<bib$1>$2\, <v>$3<\/v>\, <yr>$4<\/yr>\, <pg>$5<\/pg>$6<\/bib>/gs;

  $TextBody=~s/doi\:([0-9]+\.[0-9]+)\/([0-9\-]+)\.<v>([0-9]+)<\/v> <pg>([0-9]+)<\/pg><\/bib>/<doi>doi\:$1\/$2\.$3 $4<\/doi><\/bib>/gs;

  $TextBody=~s/\(([aA]ccessed|[Zz]ugegriffen) $regx{monthPrefix} <v>([^<>]*?)<\/v>([\,\;\.\: ]+)<pg>$regx{year}<\/pg>\)/\($1 $2 $3$4$5\)/gs;
  #Accessed April 7, 1999
  $TextBody=~s/ ([Aa]ccessed|[Zz]ugegriffen) $regx{monthPrefix} <v>([^<>]*?)<\/v>([\,\;\.\: ]+)<pg>$regx{year}<\/pg>$regx{optionaEndPunc}<\/bib>/ $1 $2 $3$4<yr>$5<\/yr>$6<\/bib>/gs;
  #Accessed February <v>2</v><pg>6</pg>, <yr>2004</yr>.</bib>
  $TextBody=~s/ ([Aa]ccessed|[Zz]ugegriffen) $regx{monthPrefix} <v>([0-9\-]+)<\/v><pg>([0-9]+)<\/pg>([\,\;\.\: ]+)<yr>$regx{year}<\/yr>$regx{optionaEndPunc}<\/bib>/ $1 $2 $3$4$5<yr>$6<\/yr>$7<\/bib>/gs;

  #Accessed on April <v>9</v>, <pg>2014</pg>
  #Accessed Feb. <v>2</v> <pg>2009</pg>.</bib>
  $TextBody=~s/\b([aA]ccessed|[Zz]ugegriffen) $regx{monthPrefix}([\.]?) <v>([^<>]*?)<\/v>([\,\;\.\: ]+)<pg>$regx{year}<\/pg>([\.]?)$regx{extraInfo}/$1 $2$3 $4$5$6$7$8/gs;
  $TextBody=~s/\b([aA]ccessed|[Zz]ugegriffen) (on|at) $regx{monthPrefix}([\.]?) <v>([^<>]*?)<\/v>([\,\;\.\: ]+)<pg>$regx{year}<\/pg>([\.]?)$regx{extraInfo}/$1 $2 $3$4 $5$6$7$8$9/gs;
  #Accessed <v>07-26</v> <pg>2010</pg>.</bib>
  $TextBody=~s/\b([aA]ccessed|[Zz]ugegriffen) <v>([^<>]*?)<\/v>([\,\;\.\: ]+)<pg>$regx{year}<\/pg>([\.]?)$regx{extraInfoNoComment}/$1 $2$3$4$5$6/gs;

  $TextBody=~s/ $regx{pagePrefix}$regx{optionalSpace} ([A-Z]+)<v>([0-9]+)<\/v>, <pg>([A-Z][0-9]+)<\/pg>$regx{optionaEndPunc}<\/bib>/ $1$2 <pg>$3$4, $5<\/pg>$6<\/bib>/gs;
  #Oct <v>4</v>, <iss>2005</iss>, p <pg>H1</pg>.</bib>
  $TextBody=~s/\, $regx{monthPrefix} <v>([0-9]+)<\/v>\, <iss>$regx{year}<\/iss>\, $regx{pagePrefix}$regx{optionalSpace}<pg>$regx{page}<\/pg>\.<\/bib>/\, $1 $2\, <yr>$3<\/yr>\, $4$5<pg>$6<\/pg>\.<\/bib>/gs;
  #Mail 2010 Mar <v>8</v>:<pg>9</pg>.</bib>
  #2001 May <v>5</v>:<pg>22</pg></bib>
  $TextBody=~s/$regx{wordPuncPrefix}$regx{year} $regx{monthPrefix} <v>([0-9]+)<\/v>\:<pg>$regx{page}<\/pg>$regx{optionaEndPunc}<\/bib>/$1 <yr>$2<\/yr> $3 $4\:<pg>$5<\/pg>$6\.<\/bib>/gs;

  $TextBody=~s/$regx{wordPuncPrefix}<iss>([^<>]+?)<\/iss>\:([A-Z])<pg>([0-9]+\-[A-Z][0-9]+)<\/pg>$regx{optionaEndPunc}<\/bib>/$1<v>$2<\/v>\:<pg>$2$3$4<\/pg><\/bib>$5/gs;
  $TextBody=~s/ $regx{year} ([\(\[][u]pdated) <yr>$regx{year}<\/yr>/ <yr>$1<\/yr> $2 $3/gs;

  $TextBody=~s/\, <v>(0[1-9]|11|12)<\/v>\.<pg>(0[1-9]|[23][1-9])<\/pg>\.<yr>$regx{year}<\/yr>([\.]?)<\/bib>/\, $1\.$2\.$3$4<\/bib>/gs;
  $TextBody=~s/\, <v>(0[1-9]|[23][1-9])<\/v>\.<pg>(0[1-9]|11|12)<\/pg>\.<yr>$regx{year}<\/yr>([\.]?)<\/bib>/\, $1\.$2\.$3$4<\/bib>/gs;
  #, vol. <yr>1913</yr>,
  $TextBody=~s/ <v>(0[1-9])<\/v> <pg>$regx{year}<\/pg>([\.]?)<\/bib>/ $1 $2$3<\/bib>/gs;
  #, XLI<v>X</v>
  $TextBody=~s/ ([IVXL]+)<v>([IVXL])<\/v>/ <v>$1$2<\/v>/gs;
  $TextBody=~s/<bib([^<>]*?)>((?:(?!1[987][0-9][0-9])(?!20[0-9][0-9])(?!<[\/]?bib>)(?!<bib ).)*?)\, <v>$regx{volume}<\/v>\, <iss>$regx{page}<\/iss>\, <pg>$regx{year}<\/pg>$regx{optionaEndPunc}((?:(?!1[987][0-9][0-9])(?!20[0-9][0-9])(?!<[\/]?bib>)(?!<bib ).)*?)<\/bib>/<bib$1>$2\, <v>$3<\/v>\, <pg>$4<\/pg>\, <yr>$5<\/yr>$6$7<\/bib>/gs;
  $TextBody=~s/<bib([^<>]*?)>((?:(?!1[987][0-9][0-9])(?!20[0-9][0-9])(?!<[\/]?bib>)(?!<bib ).)*?)\, <v>$regx{volume}<\/v>\, <iss>$regx{page}<\/iss>\, <pg>$regx{year}<\/pg>$regx{optionaEndPunc}$regx{extraInfo}/<bib$1>$2\, <v>$3<\/v>\, <pg>$4<\/pg>\, <yr>$5<\/yr>$6$7/gs;

  $TextBody=~s/<bib([^<>]*?)>((?:(?!1[987][0-9][0-9])(?!20[0-9][0-9])(?!<[\/]?bib>)(?!<bib ).)*?) \($regx{year}\)$regx{optionaEndPunc}$regx{extraInfo}/<bib$1>$2 \(<yr>$3<\/yr>\)$4$5/gs;

  $TextBody=~s/([\.\:\,\;][ ]?)([Cc]hapter) <v>$regx{volume}<\/v>([\,\;\: ]+)<pg>$regx{page}<\/pg>([\.]?)<\/bib>/$1$2 $3$4<pg>$5<\/pg>$6<\/bib>/gs;
  $TextBody=~s/([\.\:\,\;][ ]?)([Cc]hapter) <v>$regx{volume}<\/v>([\,\;\: ]+)$regx{pagePrefix}$regx{optionalSpace}<pg>$regx{page}<\/pg>([\.]?)<\/bib>/$1$2 $3$4$5$6<pg>$7<\/pg>$8<\/bib>/gs;

  $TextBody=~s/(ISBN|ISSN) <v>([0-9]+\-[0-9\-]+[0-9]+)<\/v>([\.\,\; ]+)<pg>([^<>]+?)<\/pg><\/bib>/$1 $2$3<pg>$4<\/pg><\/bib>/gs;

 # select(undef, undef, undef,  $sleep1);

  return $TextBody;
}
#===============================================================================================
sub loosePage{
  my $TextBody=shift;
  my $application=shift;

  my ($sleepCounter, $sleep1, $sleep2)=(0, 0, 0);
  if (defined $application){
    if($application eq "AMPP" || $application eq "ampp"){
      $sleep1=0;
      $sleep2=0;
      # $sleep1=0.001;
      # $sleep2=0.001;
    }
  }

  $TextBody=~s/$regx{wordPuncPrefix}$regx{volumePrefix}$regx{puncSpace}$regx{volume}$regx{optionaEndPunc}<\/bib>/$1$2$3<v>$4<\/v>$5<\/bib>/gs;
  $TextBody=~s/([\.\, ]+)([A-Zxiv0-9]+[\–�\-]+[A-Zxiv0-9]+)$regx{optionaEndPunc}(<\/bib>|[ ]?<doig>|[\s]?\([iI]n [Cc]hinese\))/$1<pg>$2<\/pg>$3$4/g;
  $TextBody=~s/([^0-9\_]+[\.\, ]?)([A-Zxiv0-9]+[\–�\-]+[A-Zxiv0-9]+)$regx{optionaEndPunc}(<\/bib>|[ ]?<doig>|[\s]?\([iI]n [Cc]hinese\))/$1<pg>$2<\/pg>$3$4/g;
  $TextBody=~s/([\:\.\, ]+)<v>([0-9A-Z]+)\-<\/v>\-<pg>([0-9A-Z]+)<\/pg><\/bib>/$1 <pg>$2\-\-$3<\/pg><\/bib>/gs;
  $TextBody=~s/\b(S|S\.|p|pp|p\.|pp\.|P|P\.)$regx{optionalSpace}<v>([0-9A-Z]+)\-<\/v>\-<pg>([0-9A-Z]+)<\/pg><\/bib>/$1$2<pg>$3\-\-$4<\/pg><\/bib>/gs;
  $TextBody=~s/\b(S|pp|P)([\.]?) <v>([0-9]+[A-Z]?)\-<\/v>\-<pg>([0-9]+[A-Z]?)<\/pg>/$1$2 <pg>$3\-\-$4<\/pg>/gs;
  $TextBody=~s/<v>([^<>]*?)<\/v>\-<pg>([^<>]*?)<\/pg>$regx{optionaEndPunc}<\/bib>/<pg>$1\-$2<\/pg>$3<\/bib>/gs;
  $TextBody=~s/ ([VIXL]+)<pg>([VIXL]+)\-([VIXL]+)<\/pg>/ <pg>$1$2\-$3<\/pg>/gs;

  $TextBody=~s/ (\d\d)\.<v>(\d\d\d\d)\/<\/v> <pg>$regx{page}-$regx{page}<\/pg>([\.]?)<\/bib>/ <doi>$1\.$2\/$3-$4$5<\/doi><\/bib>/gs;
  $TextBody=~s/ISBN-<v>$regx{volume}<\/v>([\: ]+)<pg>$regx{page}<\/pg>/ISBN-$1$2$3/gs;
  $TextBody=~s/([a-zA-Z]+)\: <v>$regx{dateDay}<\/v>\.<pg>([10]?[0-9])<\/pg>\.<yr>$regx{year}<\/yr>([\.]?)<\/bib>/$1\: $2\.$3\.$4$5<\/bib>/gs;
  $TextBody=~s/([a-zA-Z]+)\: <v>([10]?[0-9])<\/v>\.<pg>$regx{dateDay}<\/pg>\.<yr>$regx{year}<\/yr>([\.]?)<\/bib>/$1\: $2\.$3\.$4$5<\/bib>/gs;
  #1.<v>07</v>:<pg>12--13</pg></bib>
  $TextBody=~s/$regx{wordPuncPrefix}([0-9][0-9]?)\.<v>$regx{volume}<\/v>\:<pg>$regx{page}<\/pg>([\.]?)<\/bib>/$1<v>$2\.$3<\/v>\:<pg>$4<\/pg>$5<\/bib>/gs;

  #select(undef, undef, undef,  $sleep1);

  $TextBody=~s/<\/i>\, $regx{pagePrefix}$regx{optionalSpace}([A-Z]+[0-9]+)$regx{optionaEndPunc}<\/bib>/<\/i>\, $1$2<pg>$3<\/pg>$4<\/bib>/gs;
  $TextBody=~s/<\/i>\, $regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/<\/i>\, $1$2<pg>$3<\/pg>$4<\/bib>/gs;
  $TextBody=~s/$regx{wordPuncPrefix}$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionaEndPunc}<\/bib>/$1$2$3<pg>$4<\/pg>$5<\/bib>/gs;

  $TextBody=~s/<\/pg>([\.\,\;\: ]+)([qQ]uiz )<pg>([^<>]+?)<\/pg>/<\/pg>$1$2$3/gs;

  $TextBody=~s/([Rr]esearch [Pp]aper [Nn]o[\.\,]?) <yr>([^<>]*?)<\/yr>\/<pg>([^<>]*?)<\/pg>([\.]?)$regx{extraInfoNoComment}/$1 $2\/$3$4$5/gs;
  #(Benjamin Press, New York, 1969), 239 p</bib>
  $TextBody=~s/\(([^<>\(\)0-9]+?)\, $regx{year}\)([\.\, ]+)$regx{page}$regx{optionalSpace}$regx{pagePrefix}$regx{extraInfoNoComment}/\($1\, <yr>$2<\/yr>\)$3<pg>$4<\/pg>$5$6$7/gs;

  #1997. p.&nbsp;134-48. (
  $TextBody=~s/ $regx{year}\. $regx{pagePrefix}$regx{optionalSpace}$regx{page}\. \(/ <yr>$1<\/yr>\. $2$3<pg>$4<\/pg>\. \(/gs;

  $TextBody=~s/(\&lt\;[\s]?)(http[s]?\:\/\/www\.|http[s]?\:\/\/|www\.|ftp)((?:(?!<[\/]?[a-z]+>)(?!\&gt\;)(?!\&lt\;).)*?)([\s]?\&gt\;)/$1<url>$2$3<\/url>$4/gs;

  {}while($TextBody=~s/(http[s]?\:\/\/www\.|http[s]?\:\/\/|www\.|ftp)([^\s<>]+?) \& ([^\s<>]+)/<url>$1$2\&$3<\/url>/gs);
  {}while($TextBody=~s/<url>(http[s]?\:\/\/www\.|http[s]?\:\/\/|www\.|ftp)([^\s<>]+?)<\/url> \& ([^\s<>]+)/<url>$1$2\&$3<\/url>/gs);


  $TextBody=~s/([0-9]+\.[0-9]+)\/([A-Za-z0-9\(\)\-\.]+)<pg>$regx{page}<\/pg>([\.]?)<\/bib>/$1\/$2$3$4<\/bib>/gs;

  $TextBody=~s/(http[s]?\:\/\/www\.|http[s]?\:\/\/|www\.|ftp)([^\s<>]+)/<url>$1$2<\/url>/gs;

  #db/journals/aai/aai17.html#Zeng03
  $TextBody=~s/(URL[\: ]+?| )(db\/journals\/)([^\s<>]+)/$1<url>$2$3<\/url>/gs;
  $TextBody=~s/<url>([^<>]+\/[^<>\/\.]+)<\/url> ([^<>\.]+[a-z])\.([a-z]+)([\.\, ]+|<\/bib>)/<url>$1 $2\.$3<\/url>$4/gs;

  $TextBody=~s/<url><url>([^<>]+?)<\/url><\/url>/<url>$1<\/url>/gs;

  $TextBody=~s/<\/url><yr>$regx{year}<\/yr>([^ \)\(\]\[<>]+)/$1$2<\/url>/gs;
  $TextBody=~s/<\/url> \%([^<> ]+?)\.([a-z]+)(<| )/ \%$1\.$2<\/url>$3/gs;
  $TextBody=~s/(\&lt\;[\s]?)<url><url>([^<>]+?)<\/url>([^<>]+?)<\/url>([\s]?\&gt\;)/$1<url>$2$3<\/url>$4/gs;
  #$TextBody=~s/(https\:\/\/|http\:\/\/|www|ftp)()


  $TextBody=~s/\&lt\;<url>/<url>\&lt\;/gs;
  $TextBody=~s/\&gt\;([\.\,\;]?)<\/url>/\&gt\;<\/url>$1/gs;
  $TextBody=~s/([\.\,\)]*?)<\/url>/<\/url>$1/gs;

  $TextBody=~s/\\url\{<url>([^<>]+?)<\/url>\}/<url>$1<\/url>/gs;

  $TextBody=~s/\b(ISBN[\:]?) ([0-9]+[\-]+[0-9]+[\-]+[0-9]+[\-]+)<pg>([^<>]+?)<\/pg>([\.]?)<\/bib>/$1 $2$3$4<\/bib>/igs;

  $TextBody=~s/$regx{extraInfo} $regx{monthPrefix}\, <v>([0-3]?[0-9])<\/v>\, <pg>$regx{year}<\/pg>([\.]?)<\/bib>/$1 $2\, $3\, $4$5<\/bib>/gs;
  $TextBody=~s/$regx{extraInfo}\, <v>([0-3][0-9])<\/v>\, <pg>$regx{year}<\/pg>([\.]?)<\/bib>/$1 $2\, $3$4<\/bib>/gs;

  #(Dec <v>14</v>, <pg>1993</pg>).</bib>
  $TextBody=~s/\($regx{monthPrefix} <v>([0-3]?[0-9])<\/v>, <pg>$regx{year}<\/pg>\)([\.]?)<\/bib>/\($1 $2, $3\)$4<\/bib>/gs;
  $TextBody=~s/([\.\,]) $regx{monthPrefix} <v>([0-3]?[0-9])<\/v>\, <pg>$regx{year}<\/pg>([\.]?)<\/bib>/$1 $2 $3\, $4$5<\/bib>/gs;
  #, April <v>23</v>, <pg>10</pg>.</bib>
  $TextBody=~s/(>|[a-z])\, $regx{monthPrefix} <v>([0-3]?[0-9])<\/v>, <pg>([0-3]?[0-9])<\/pg>([\.]?)<\/bib>/$1\, $2 $3, $4$5<\/bib>/gs;

  $TextBody=~s/([\,\)\.\;]) ([LIXV]+)<pg>([LIXV]+[\-]+[LIXV]+)<\/pg>/$1 <pg>$2$3<\/pg>/igs;
  $TextBody=~s/( [Rr]eport [A-Z]+)<pg>([A-Z]+)\-(\d+)<\/pg>/$1$2\-$3/gs;
  $TextBody=~s/ ([vV]ersion[s]? [0-9]+)\.<pg>([^<>]+?)<\/pg><\/bib>/ $1\.$2<\/bib>/gs;

  $TextBody=~s/([\.\,]) ([pp]+[\.]?|S[\.]?) ([0-9\-]+\, [0-9\-]+)\, <v>([0-9\-]+)<\/v>\, <iss>([0-9\-]+)<\/iss>\, <pg>([0-9\-]+)<\/pg>([\.]?)<\/bib>/$1 $2 <pg>$3\, $4\, $5\, $6<\/pg>$7<\/bib>/gs;
  $TextBody=~s/([\.\,]) ([pp]+[\.]?|S[\.]?) ([0-9\-]+)\, <v>([0-9\-]+)<\/v>\, <iss>([0-9\-]+)<\/iss>\, <pg>([0-9\-]+)<\/pg>([\.]?)<\/bib>/$1 $2 <pg>$3\, $4\, $5\, $6<\/pg>$7<\/bib>/gs;
  $TextBody=~s/([A-Z][A-Z])\-<pg>([0-9]+)-([0-9]+)<\/pg>([\.]?)<\/bib>/$1\-$2-$3$4<\/bib>/gs;
  $TextBody=~s/([\-[A-Z]+)\-<pg>([^<>]+?)<\/pg>/$1\-$2/gs;
  $TextBody=~s/([\-[A-Z])<pg>([A-Z][^<>]+?)<\/pg>/$1$2/gs;

  $TextBody=~s/([Rr]etriev[e]?[d]?|[Oo]nline|[Aa]vailable|[Oo]riginal [wW]ork [pP]ublished|[Ii]nternet|[Aa]ccessed|[Zz]ugegriffen|[uU]pdated|[cC]ited|[Rr]eprinted|[Ss]pecial [Ii]ssue [Ss]ection[s]?[\:]?|[Ss]pecial [Ii]ssue [tT]oward[s]?[\:\;]?|[Aa]vailable [a-zA-Z]+\:) $regx{monthPrefix}$regx{optionalPuncSpace}<v>$regx{volume}<\/v>([\,\: ]+)<pg>$regx{year}<\/pg>/$1 $2$3$4$5$6/gs;

  $TextBody=~s/\b([Zz]ugegriffen|[Aa]ccessed)([\:\.\, ]+)$regx{monthPrefix}([\,\. ]*?)<yr>$regx{year}<\/yr>([\.]?)<\/bib>/$1$2$3$4$5$6<\/bib>/gs;

  $TextBody=~s/<\/pg>([\;\.\, ]+)([dD]iscussion[s]? )<pg>([^<>]+?)<\/pg>([\.]?)<\/bib>/<\/pg>$1<comment>$2$3<\/comment>$4<\/bib>/gs;
  $TextBody=~s/<doig>(doi|Doi|DOI)([\: ]*)<doi>([Nn]ot)<\/doi><\/doig> ([aA]vailable[s]?[\.]?)<\/bib>/<comment>$1$2$3 $4<\/comment><\/bib>/gs;
  $TextBody=~s/<doig>(doi|Doi|DOI)([\: ]*)<doi>([^0-9]+)<\/doi><\/doig>/$1$2$3/gs;

  if($TextBody=~/<\/([a-z]+)>([\.\,\: ]+)([Rr]eview[\.\,] [Ee]rratum|[Ee]rratum in)((?:(?!<bib)(?!<\/bib>).)*?)([\.]?)<\/bib>/s){
    my $extraText=$4;
    $extraText=~s/<[\/]?(v|iss|pg|doig|doi|yr|url)>//gs;
    $TextBody=~s/<\/([a-z]+)>([\.\,\: ]+)([Rr]eview[\.\,] [Ee]rratum|[Ee]rratum in)((?:(?!<bib)(?!<\/bib>).)*?)([\.]?)<\/bib>/<\/$1>$2<comment>$3$extraText<\/comment>$5<\/bib>/s;
  }


  $TextBody=~s/([\.\,\;\?]|>) \(([Rr]eprint [eE]dn[\,\. ]|[Rr]eprinted [Ii]n |[Rr]eprinted\, |[Ss]pecial [Ii]ssue [Ss]ection[s]?[\:]?|[Ss]pecial [Ii]ssue [tT]oward[s]?[\:\;]?)([^\(\)]+?)\)([\.]?)<\/bib>/$1 <comment>\($2$3\)<\/comment>$4<\/bib>/gs;
  $TextBody=~s/$regx{allRightQuote} \(([Rr]eprint [eE]dn[\,\. ]|[Rr]eprinted [Ii]n |[Rr]eprinted\, |[Ss]pecial [Ii]ssue [Ss]ection[s]?[\:]?|[Ss]pecial [Ii]ssue [tT]oward[s]?[\:\;]?)([^\(\)]+?)\)([\.]?)<\/bib>/$1 <comment>\($2$3\)<\/comment>$4<\/bib>/gs;
  #. Retrieved from <url>http://www.acer.edu.au/documents/TIMSS-PIRLS_Monitoring-Australian-Year-4-Student-Achievement.pdf</url></bib>
  $TextBody=~s/([\.\,\;\?]) ([Rr]etriev[e]?[d]?|[Oo]nline|[Aa]vailable|[Oo]riginal [wW]ork [pP]ublished|[Ii]nternet|[Aa]ccessed|[Zz]ugegriffen|[uU]pdated|[cC]ited|[Rr]eprinted|[Ss]pecial [Ii]ssue [Ss]ection[s]?[\:]?|[Ss]pecial [Ii]ssue [tT]oward[s]?[\:\;]?|[Aa]vailable [a-zA-Z]+\:) ([^<>]+?) <url>([^<>]+?)<\/url>([\.]?)<\/bib>/$1 <comment>$2 $3 $4<\/comment>$5<\/bib>/gs;

  $TextBody=~s/([\.\,\;\?]) ([Rr]etriev[e]?[d]?|[Oo]nline|[Aa]vailable|[Oo]riginal [wW]ork [pP]ublished|[Ii]nternet|[Aa]ccessed|[Zz]ugegriffen|[uU]pdated|[cC]ited|[Rr]eprinted|[Ss]pecial [Ii]ssue [Ss]ection[s]?[\:]?|[Ss]pecial [Ii]ssue [tT]oward[s]?[\:\;]?|[Aa]vailable [a-zA-Z]+\:) ([^<>]+?) (http[s]?\:\/\/www\.|http[s]?\:\/\/|www\.|ftp)([^\s<>]+)([\.]?)<\/bib>/$1 <comment>$2 $3 $4$5<\/comment>$6<\/bib>/gs;

  $TextBody=~s/$regx{allRightQuote} ([Rr]etriev[e]?[d]?|[Oo]nline|[Aa]vailable|[Oo]riginal [wW]ork [pP]ublished|[Ii]nternet|[Aa]ccessed|[Zz]ugegriffen|[uU]pdated|[cC]ited|[Rr]eprinted|[Ss]pecial [Ii]ssue [Ss]ection[s]?[\:]?|[Ss]pecial [Ii]ssue [tT]oward[s]?[\:\;]?) ([^<>]+?) <url>([^<>]+?)<\/url>([\.]?)<\/bib>/$1 <comment>$2 $3 $4<\/comment>$5<\/bib>/gs;
  $TextBody=~s/([\.\,\;\?]) ([Rr]etriev[e]?[d]?|[Oo]nline|[Aa]vailable|[Oo]riginal [wW]ork [pP]ublished|[Ii]nternet|[Aa]ccessed|[Zz]ugegriffen|[uU]pdated|[cC]ited|[Rr]eprinted|[Ss]pecial [Ii]ssue [Ss]ection[s]?[\:]?|[Ss]pecial [Ii]ssue [tT]oward[s]?[\:\;]?|[Aa]vailable [a-zA-Z]+\:) ([^<>]+?) <url>([^<>]+?)<\/url>([^<>]+?)([\.]?)<\/bib>/$1 <comment>$2 $3 $4$5<\/comment>$6<\/bib>/gs;

  $TextBody=~s/([\.\,\;\?]) ([Rr]etriev[e]?[d]?|[Oo]nline|[Aa]vailable|[Oo]riginal [wW]ork [pP]ublished|[Ii]nternet|[Aa]ccessed|[Zz]ugegriffen|[uU]pdated|[cC]ited|[Rr]eprinted|[Ss]pecial [Ii]ssue [Ss]ection[s]?[\:]?|[Ss]pecial [Ii]ssue [tT]oward[s]?[\:\;]?|[Aa]vailable [a-zA-Z]+\:)(\:[ ]?)<url>([^<>]+?)<\/url>([^<>]+?)([\.]?)<\/bib>/$1 <comment>$2$3$4$5<\/comment>$6<\/bib>/gs;


  $TextBody=~s/\, $regx{pagePrefix}$regx{optionalSpace}$regx{page}\. \(([^<>]+?)\)<\/bib>/\, $1$2<pg>$3<\/pg>\. \($4\)<\/bib>/gs;
  while($TextBody=~/<bib([^<>]*?)>((?:(?!<bib)(?!<\/bib).)*)<\/bib>/s)
    {
      my $id=$1;
      my $Bibtext=$2;
      $Bibtext=~s/^(.+?)(?=.*<v>)(?=.*<yr>)(?=.*<pg>)(.*?)\(([^<>\(\)]+?)\)([\.]?)$/$1$2<comment>\($3\)<\/comment>$4/s;
      $Bibtext=~s/^(.+?)(?=.*<v>)(?=.*<iss>)(?=.*<pg>)(.*?)\(([^<>\(\)]+?)\)([\.]?)$/$1$2<comment>\($3\)<\/comment>$4/s;
      $Bibtext=~s/^(.+?)(?=.*<v>)(?=.*<pg>)(.*?)\(([^0-9<>\(\)]+?)\)([\.]?)$/$1$2<comment>\($3\)<\/comment>$4/s;
      $TextBody=~s/<bib([^<>]*?)>((?:(?!<bib)(?!<\/bib).)*)<\/bib>/<bibX$1>$Bibtext<\/bibX>/s;
      #select(undef, undef, undef,  $sleep1);
    }
  $TextBody=~s/<([\/]?)bibX>/<$1bib>/gs;
  $TextBody=~s/<bibX /<bib /gs;

  #$TextBody=~s/<bib([^<>]*?)>((?:(?!<v>)(?!<[\/]?bib)(?!<[\/]?pt>).)+?)<v>([^<>]+?)<\/v>([a-zA-Z\.\:\, ]+)<pg>([^<>]+?)<\/pg>([\)\.\,\;\: ]+)\(([A-Za-z]+[^\(\)]+?)\)([\.]?)<\/bib>/<bib$1>$2<v>$3<\/v>$4<pg>$5<\/pg>$6<comment>\($7\)<\/comment>$8<\/bib>/gs;

  $TextBody=~s/\($regx{pagePrefix}$regx{optionalSpace}$regx{page}\)([\.]?)<\/bib>/\($1$2<pg>$3<\/pg>\)$4<\/bib>/gs;
  $TextBody=~s/\, $regx{pagePrefix}$regx{optionalSpace}$regx{page} \($regx{comment}\)$regx{optionaEndPunc}<\/bib>/\, $1$2<pg>$3<\/pg> \($4\)$5<\/bib>/gs;
  #<p><bib id="bib3">MA Sutton, Digital Image Correlation. In W.N. Sharpe, Jr. editor, Springer Handbook of Experimental Solid Mechanics, Springer, Berlin 2008. ISBN: 978-0-387-26883-5.</bib></p>
  $TextBody=~s/<bib([^<>]*?)>((?:(?!<[\/]?bib>)(?!1[987][0-9][0-9][a-z]?|20[0-9][0-9][a-z]?).)*?) $regx{year}\. (ISBN[\:]? )$regx{isbn}$regx{optionaEndPunc}<\/bib>/<bib$1>$2 <yr>$3<\/yr>\. $4$5$6<\/bib>/gs;
  #print $TextBody;#exit;

  #ISBN 3-900051-07-0, URL http://www.R-project.org/
  $TextBody=~s/([\.\,\;]) (ISBN[\:]? [0-9\-]+\, URL[\:]?) <url>([^<>]+?)<\/url>([\.]?)<\/bib>/$1 <comment>$2 $3$4<\/comment><\/bib>/gs;
  $TextBody=~s/([\.\,\;]) (ISBN|ISSN) <pg>([^<>]+?)<\/pg>([\.]?)<\/bib>/$1 <comment>$2 $3<\/comment>$4<\/bib>/gs;


  return $TextBody;
}
#===============================================================================================
sub authorMark{
  my $TextBody=shift;
  my $application=shift;

  my ($sleepCounter, $sleep1, $sleep2)=(0, 0, 0);
  if (defined $application){
    if($application eq "AMPP" || $application eq "ampp"){
      # $sleep1=0.001;
      # $sleep2=0.001;
      $sleep1=0;
      $sleep2=0;
    }
  }

  my $AuthorString="A-Za-zßØÃﬂ¡ýÿþÜÛÚÙØÖÕÔÓÒÑÐÏÎÍÌËÊÈÉÇÆŒœšŠÅÄÂÁÀñïïîííêçæåãâáõôóòùúûéèàäćíÃüöİı…â€™Ã¦Ã³Ã±Ã˜Ã¤Ã§Ã®Ã¨ÃŸÃ¼Ã¶Ã©Ã¥Ã¸`’\\\-Ã‡Ã–\\\"–\\\-\\\�����������������������������������������������'";

  #---------------------------------------------------------------------------
  $TextBody=~s/(>|\, )([$AuthorString ]+) $regx{firstName}\, <pbl>([^<>]+?)<\/pbl> <cny>([A-Z]+)<\/cny>([\.\,]) /$1$2 $3\, $4 $5$6 /gs;
  #Klaus, P., <pbl>Müller</pbl>,
  $TextBody=~s/\, $regx{firstName}\, <pbl>([^<>]*?)<\/pbl>\, ((?:(?!<[\/]?bib>)(?!<[\/]?aug>)(?!<[\/]?pbl>).)*?)<pbl>/\, $1\, $2\, $3<pbl>/gs;
  $TextBody=~s/ $regx{firstName} <pbl>([^<>]*?)<\/pbl> \($regx{editorSuffix}\)/ $1 $2 \($3\)/gs;
  $TextBody=~s/ ([Ii]n[\:\.]?) $regx{firstName} <pbl>([^<>]*?)<\/pbl>([\, ]+)/ $1 $2 $3$4/gs;
  $TextBody=~s/ $regx{firstName}\, <pbl>([^<>]*?)<\/pbl> $regx{firstName}\, / $1\, $2 $3\, /gs;
  $TextBody=~s/ $regx{firstName}\, <pbl>([^<>]*?)<\/pbl> $regx{firstName} \(/ $1\, $2 $3 \(/gs;
  $TextBody=~s/(>|\, )([^<>]+?)\, <pbl>([^<> ]+?)<\/pbl>\, ((?:(?!<pbl>)(?!<[\/]?bib)(?!<[\/]?pt>).)+?)<(pbl|pt)>/$1$2\, $3\, $4<$5>/gs;
  $TextBody=~s/<pbl>([^<> ]+?)<\/pbl>([\;\,\. ]+)((?:(?!<[\/]?bib>)(?!<[\/]?aug>)(?!<[\/]?pbl>).)*?)([\.\,\:\;]) <pbl>([^<>]+?)<\/pbl>/$1$2$3$4 <pbl>$5<\/pbl>/gs;

  $TextBody=~s/<pt>([A-Z\.a-z\- ]+?)<\/pt>((?:(?!<[\/]?bib>)(?!<[\/]?aug>)(?!<[\/]?yr>)(?!<[\/]?pt>).)+?)<pt>([^<>]+?)<\/pt>/$1$2<pt>$3<\/pt>/gs;
  $TextBody=~s/<pt>([A-Z\.a-z\- ]+?)<\/pt>([\,\;\.\( ]+)<yr>([^<>]+?)<\/yr>((?:(?!<[\/]?bib>)(?!<[\/]?aug>)(?!<[\/]?yr>)(?!<[\/]?pt>).)+?)<pt>([^<>]+?)<\/pt>/$1$2<yr>$3<\/yr>$4<pt>$5<\/pt>/gs;

  $TextBody=~s/([\,\.] [Ii]n[\:\.\, ]+| [Ii]n[\:\.] +|\. In\b[ ]?)<pt>([^<>]+?)<\/pt> ([^<>]+?)([Ee]dited [bB]y|\b[Ee]d[s]?[\.]? [Bb]y)/$1$2 $3$4/gs;

  $TextBody=~s/<v>$regx{year}<\/v>((?:(?!<[\/]?bib>)(?!<[\/]?aug>)(?!<[\/]?yr>)(?!<[\/]?v>).)+?)<v>([^<>]+?)<\/v>/$1$2<v>$3<\/v>/gs;
  $TextBody=~s/ $regx{firstName}\, <pbl>([^<>]*?)<\/pbl> $regx{firstName}\. / $1\, $2 $3\. /gs;
  $TextBody=~s/([A-Z][a-z]+) $regx{firstName}\, <pbl>([^<>]*?)<\/pbl>\, $regx{firstName}([\, ])/$1 $2\, $3\, $4$5/gs;
  $TextBody=~s/([\;\,]) <cny>([A-Z][a-z]+)<\/cny>\, $regx{firstName}\; ([$AuthorString ]+)\, $regx{firstName}\;/$1 $2\, $3\; $4\, $5\;/gs;
  #Hennings, V.; <pbl>Müller</pbl>, L.
  $TextBody=~s/([$AuthorString ]+)\, $regx{firstName}\; <pbl>([^<>]+?)<\/pbl>\, $regx{firstName}([\; ])/$1\, $2\; $3\, $4$5/gs;
  #, <cny>U. K.</cny> Cauhan, P. Tripathi,
  $TextBody=~s/\, <cny>$regx{firstName}<\/cny> ([$AuthorString ]+)\, $regx{firstName} ([$AuthorString ]+)([\;\,\. ])/\, $1 $2\, $3 $4$5/gs;


  $TextBody=~s/<pbl>([^ <>]+?)<\/pbl>([\, ]+)<cny>([A-Z]+)<\/cny>([\.\, ]+)([^<>]+?) <(pt|cny|pbl)>/$1$2$3$4$5 <$6>/gs;

  #Lasch, <pbl>Christopher</pbl>. 1979. <i>The Culture of Narcissism</i>. <cny>New York</cny>: <pbl>Norton</pbl>.
  $TextBody=~s/<bib([^<>]*?)>((?:(?!<[\/]?bib>)(?!<[\/]?pt>)(?!<[\/]?cny>)(?!<[\/]?pbl>).)*)<cny>([^<> ]+?)<\/cny>([\.\,\: ]+)((?:(?!<[\/]?bib>)(?!<[\/]?pt>)(?!<[\/]?cny>)(?!<[\/]?pbl>).)+)([\.\,\:\(\[ ]+)<(cny|pbl)>([^<>]+?)<\/\7>([\,\:\.\; ]+)<(cny|pbl)>([^<>]+?)<\/\10>/<bib$1>$2$3$4$5$6<$7>$8<\/$7>$9<$10>$11<\/$10>/gs;
  $TextBody=~s/<bib([^<>]*?)>((?:(?!<[\/]?bib>)(?!<[\/]?pt>)(?!<[\/]?cny>)(?!<[\/]?pbl>).)*)<pbl>([^<> ]+?)<\/pbl>([\.\,\: ]+)((?:(?!<[\/]?bib>)(?!<[\/]?pt>)(?!<[\/]?cny>)(?!<[\/]?pbl>).)+)([\.\,\:\(\[ ]+)<(cny|pbl)>([^<>]+?)<\/\7>([\,\:\.\; ]+)<(cny|pbl)>([^<>]+?)<\/\10>/<bib$1>$2$3$4$5$6<$7>$8<\/$7>$9<$10>$11<\/$10>/gs;
  $TextBody=~s/<bib([^<>]*?)>((?:(?!<[\/]?bib>)(?!<[\/]?pt>)(?!<[\/]?cny>)(?!<[\/]?pbl>).)*?)<cny>([^<>]+?)<\/cny>((?:(?!<[\/]?bib>)(?!<[\/]?pt>)(?!<[\/]?cny>)(?!<[\/]?pbl>).)*?)<pt>/<bib$1>$2$3$4<pt>/gs;
  $TextBody=~s/<bib([^<>]*?)>((?:(?!<[\/]?bib>)(?!<[\/]?pt>)(?!<[\/]?cny>)(?!<[\/]?pbl>).)*?)<pbl>([^<>]+?)<\/pbl>((?:(?!<[\/]?bib>)(?!<[\/]?pt>)(?!<[\/]?cny>)(?!<[\/]?pbl>).)*?)<pt>/<bib$1>$2$3$4<pt>/gs;


  $TextBody=~s/ <cny>([^<>]+?)<\/cny> ([a-z][a-z]+ [a-z][a-z]+)/ $1 $2/gs;
  $TextBody=~s/<bib([^<>]*?)>((?:(?!<[\/]?bib>)(?!<[\/]?pt>)(?!<[\/]?cny>)(?!<[\/]?pbl>).)*?)<cny>([^<>]+?)<\/cny>([\.\;\, ]+)((?:(?!<[\/]?bib>)(?!<[\/]?pt>)(?!<[\/]?cny>).)+?) <cny>([^<>]+?)<\/cny>/<bib$1>$2$3$4$5 <cny>$6<\/cny>/gs;


  $TextBody=~s/ $regx{and} $regx{firstName} <pbl>([A-Z][a-z]+)<\/pbl>([\,\.\:] | \()/ $1 $2 <pblx>$3<\/pblx>$4/gs;
  $TextBody=~s/<pblx>([^<>]+?)<\/pblx>([\.\,\: ]+)<cny>/<pbl>$1<\/pbl>$2<cny>/gs;
  $TextBody=~s/<([\/]?)pblx>//gs;

  $TextBody=~s/\s+(\(\d{4}[a-z]?)(<i>|<b>)(\))([\.\,\;\: ]+)/ $1$3$4$2/g;
  $TextBody=~s/\s+(\(\d{4}[a-z]?\))(?!\p{P})\s+/ $1 /g;

  $TextBody=~s/\:\\newblock/\: \\newblock/gs;
  #<p><bib id="bib5">Cornish CJ. The naturalist on the Thames. 1902. <cny>London</cny>: <pbl>Seeley and Col. Ltd.</pbl></bib></p>
  $TextBody=~s/<bib([^<>]*?)>((?:(?!<[\/]?bib>)(?!<[\/]?pt>)(?!1[987][0-9][0-9]|20[0-9][0-9])(?!<[\/]?cny>)(?!<[\/]?pbl>).)+?)([\.\:\( ]+)$regx{year}([\,\.\;\:\) ]+)<(cny|pbl)>([^<>]+?)<\/\6>([\:\.\, ]+)<(cny|pbl)>([^<>]+?)<\/\9>([\)\.]*?)<\/bib>/<bib$1>$2$3<yr>$4<\/yr>$5<$6>$7<\/$6>$8<$9>$10<\/$9>$11<\/bib>/gs;
  #</pt>. 2013; <doig>
  $TextBody=~s/<bib([^<>]*?)>((?:(?!<[\/]?bib>)(?!1[987][0-9][0-9]|20[0-9][0-9])(?!<[\/]?cny>)(?!<[\/]?pbl>).)+?)([\.\:\( ]+)$regx{year}([\,\.\;\:\) ]+)<(doig)>/<bib$1>$2$3<yr>$4<\/yr>$5<$6>/gs;
  $TextBody=~s/<pbl>([^<> ]+?)<\/pbl>((?:(?!<[\/]?bib>)(?!<[\/]?pt>)(?!<[\/]?cny>)(?!<[\/]?pbl>).)*)$regx{year}([^<>]+?)<cny>([^<>]+?)<\/cny>([^<>]+?)<pbl>/$1$2$3$4<cny>$5<\/cny>$6<pbl>/gs;
  $TextBody=~s/<pbl>([^<> ]+?)<\/pbl>((?:(?!<[\/]?bib>)(?!<[\/]?pt>)(?!<[\/]?cny>)(?!<[\/]?pbl>).)*)$regx{year}([^<>]+?)<pbl>([^<>]+?)<\/pbl>([^<>]+?)<cny>/$1$2$3$4<pbl>$5<\/pbl>$6<cny>/gs;

  $TextBody=~s/([1-3])<sup>(rd|st|nd)<\/sup>/$1&lt;sup&gt;$2&lt;\/sup&gt;/gs;
  #---------------------------------------------------------------------------

  #In “Principles of Neural Science” Kandel ER, Schwartz JH, Jessell TM, eds
#  $TextBody=~s/<\/(aug|yr)>([\.\, ]+)\b(In[\:\. ]+|[Ii]n[\:\.]+ )$regx{allLeftQuote}([^<>4-90\:\?]+?)$regx{allRightQuote}([\.\, ]+)([^<>4-90\:\?]+?)([\, ]+)$regx{editorSuffix}/$1$2<bt>$3<\/bt>$4$5<edrg>$6<\/edrg>$7$8/g;

  $TextBody=~s/\b(In[\:\. ]+|[Ii]n[\:\.]+ )$regx{allLeftQuote}([^<>4-90\:\?]+?)$regx{allRightQuote}([\.\, ]+)([^<>4-90\:\?]+?)([\, ]+)$regx{editorSuffix}/$1<bt>$2$3$4<\/bt>$5<edrg>$6<\/edrg>$7$8/g;

  #In <i>HPLC Made to Measure: A Practical Handbook for Optimization</i>; Kromidas, S., Ed.;
  $TextBody=~s/([\.\,\;]) (In[\:\. ]+|[Ii]n[\:\.]+ )<i>([^<>]+?)<\/i>([\;\,\.]) ([^<>4-90\:\?]+?)\, $regx{editorSuffix}([\;\,])/$1 $2<bt><i>$3<\/i><\/bt>$4 <edrg>$5<\/edrg>\, $6$7/g;
  $TextBody=~s/([\.\;] In[\:\.]? |[\.\,\;] [Ii]n[\:\.]+ )([^<>4-90\:\?]+?)([\.\,]?) \($regx{editorSuffix}([\.]?)\)/$1<edrg>$2<\/edrg>$3 \($4$5\)/gs;
  $TextBody=~s/([\.\;] In[\:\.]? |[\.\,\;] [Ii]n[\:\.]+ )([^<>4-90\:\?]+?)([\.\,]?) \[$regx{editorSuffix}\]/$1<edrg>$2<\/edrg>$3 \[$4\]/gs;
  $TextBody=~s/([\.\;] In[\:\.]? |\. [Ii]n )([^<>4-90\:\?]+?)([\.\,]?) \[$regx{editorSuffix}\]/$1<edrg>$2<\/edrg>$3 \[$4\]/gs;
  $TextBody=~s/$regx{allRightQuote}([\,\.\;] [iI]n[\.\,:]?) ([^<>4-90\:\?]+?)([\.\,]?) \($regx{editorSuffix}([\.]?)\)/$1$2 <edrg>$3<\/edrg>$4 \($5$6\)/gs;


  #In <i>The Middle Works of John Dewey</i>, Vol. 9, ed. Jo Ann Boydston (<pbl>
  $TextBody=~s/([\.\,\; ]+)(In[\:\. ]+|[Ii]n[\:\.]+ )<i>([^<>]+?)<\/i>([\;\,\. ]+)$regx{volumePrefix}$regx{optionalSpace}$regx{volume}$regx{puncSpace}$regx{editorSuffix} ([^<>4-90\:\?]+?)([ \(\.\,]+)<(pbl|cny)>/$1$2<bt><i>$3<\/i><\/bt>$4$5$6<v>$7<\/v>$8$9 <edrg>$10<\/edrg>$11<$12>/g;
  $TextBody=~s/([\.\,\; ]+)(In[\:\. ]+|[Ii]n[\:\.]+ )<i>([^<>]+?)<\/i>([\;\,\. ]+)$regx{editorSuffix} ([^<>4-90\:\?]+?)([ \(\.\,]+)<(pbl|cny)>/$1$2<bt><i>$3<\/i><\/bt>$4$5 <edrg>$6<\/edrg>$7<$8>/g;
  #In Biotechnology of Antibiotics, 2nd edn (Strohl, W. R., Ed.)
  $TextBody=~s/ (In[\:\. ]+|[Ii]n[\:\.]+ )<i>([^<>]+?)<\/i>\, ([0-9]+)([nr]d|th|st|<sup>[nr]d<\/sup>|<sup>th<\/sup>|<sup>st<\/sup>) ([Ee]dition|[eE]dn[\.]?|[eE]d[\.]?|[Aa]ufl[\.]?|Bd[\.]?|[Aa]uflage[\.]?)([\.\,\;\: ]+)\(([^<>\(\)]+?)([\.\, ]+)$regx{editorSuffix}\)/ $1<bt><i>$2<\/i><\/bt>\, <edn>$3<\/edn>$4 $5$6\(<edrg>$7<\/edrg>$8$9\)/gs;
  $TextBody=~s/ (In[\:\. ]+|[Ii]n[\:\.]+ )([^<>]+?)\, ([0-9]+)([nr]d|th|st|<sup>[nr]d<\/sup>|<sup>th<\/sup>|<sup>st<\/sup>) ([Ee]dition|[eE]dn[\.]?|[eE]d[\.]?|[Aa]ufl[\.]?|Bd[\.]?|[Aa]uflage[\.]?)([\.\,\;\: ]+)\(([^<>\(\)]+?)\, $regx{editorSuffix}\)/ $1<bt>$2<\/bt>\, <edn>$3<\/edn>$4 $5$6\(<edrg>$7<\/edrg>\, $8\)/gs;

  #. In Consuming Geographies (D. Bell and G. Valentine, Eds 1997). 
  $TextBody=~s/ (In[\:\. ]+|[Ii]n[\:\.]+ )<i>([^<>]+?)<\/i>([\.\,\;\: ]+)\(([^<>\(\)]+?)([\.\, ]+)$regx{editorSuffix} $regx{year}\)/ $1<bt><i>$2<\/i><\/bt>$3\(<edrg>$4<\/edrg>$5$6 $7\)/gs;
  $TextBody=~s/ (In[\:\. ]+|[Ii]n[\:\.]+ )([^<>]+?) \(([^<>0-9\(\)]+?[^<>\(\)]+?)\, $regx{editorSuffix} $regx{year}\)/ $1<bt>$2<\/bt>\, \(<edrg>$3<\/edrg> $4 $5\)/gs;


   #  In Michael Fuchs et al., <i>Forschungsethik: Eine Einführung</i> (S. 41--55). <cny>
   #  . In Michael Fuchs et al., <i>Forschungsethik: Eine Einführung</i> (S. 56--81). <cny>
   #  In Michael Fuchs et al., Forschungsethik: Eine Einführung</i> (S. 98--119). <cny>
  $TextBody=~s/ ([Ii]n[\: ]+)([^0-9\n<>]*?) ([eE]ditor[s]?|[eE]d[s]?|[Hh]rsg|[hH]g|et al\.)\, <i>([^<>]*?)<\/i> \(S\. ([0-9\-]+)\)([\.\,]?) <(cny|pbl)>/ $1<edrg>$2<\/edrg> $3\, <bt><i>$4<\/i><\/bt> \(S\. <pg>$5 <\/pg>\)$6 <$7>/gs;
  $TextBody=~s/ <i>([^0-9\n<>]*?) ([Ii]n[\: ]+)([^0-9\n<>]*?) ([eE]ditor[s]?|[eE]d[s]?|[Hh]rsg|[hH]g|et al\.)\, ([^<>]*?)<\/i> \(S\. ([0-9\-]+)\)([\.\,]?) <(cny|pbl)>/ <misc1><i>$1<\/i><\/misc1> $2<edrg>$3<\/edrg> $4\, <bt><i>$5<\/i><\/bt> \(S\. <pg>$6 <\/pg>\)$7 <$8>/gs;
  $TextBody=~s/<edrg>([^<>\.\, ]*?) ([^<>\.\, ]*?)<\/edrg>/<edrg><edr><edm>$1<\/edm> <eds>$2<\/eds><\/edr><\/edrg>/gs;

  #</i>; Matta, <edrg>C. F</edrg>. (Ed.)
  $TextBody=~s/<\/i>([\.\;\, ]+)([^<>]+?)([\.\,\; ]+)\($regx{editorSuffix}([.]?)\)([\.\, ]+)/<\/i>$1<edrg>$2<\/edrg>$3\($4$5\)$6/gs;
 
  #In\, The Multiple Ligament Injured Knee. A Practical Guide to Management. Second Edition. Editor: Gregory C. Fanelli, M.D. <pbl>
  $TextBody=~s/([\.\,] In[\:\.\, ]+|[\.\,] [Ii]n[\:\.\,]+ ) ([^<>]+?)\. ([Ee]ditor[s]?)\: ([^<>\(\)4-90]+?)([\.\,\( ]+)<(pbl|cny)>/$1 <bt>$2<\/bt>\. $3\: <edrg>$4<\/edrg>$5<$6>/gs;


  #In <i>The Quinolones</i> (Andriole, V T., Ed.)
  $TextBody=~s/ (In[\:\. ]+|[Ii]n[\:\.]+ )<i>([^<>]+?)<\/i>([\.\,\;\: ]+)\(([^<>\(\)]+?)([\.\, ]+)$regx{editorSuffix}\)/ $1<bt><i>$2<\/i><\/bt>$3\(<edrg>$4<\/edrg>$5$6\)/gs;


  $TextBody=~s/ (In[\:\. ]+|[Ii]n[\:\.]+ )([^<>]+?) \(([^<>0-9\(\)]+?)\, $regx{editorSuffix}\)/ $1<bt>$2<\/bt> \(<edrg>$3<\/edrg>\, $4\)/gs;
  $TextBody=~s/ (In[\:\. ]+|[Ii]n[\:\.]+ )([^<>]+?) \(([^<>0-9\(\)]+?[^<>\(\)]+?) $regx{editorSuffix}\)/ $1<bt>$2<\/bt> \(<edrg>$3<\/edrg> $4\)/gs;
  $TextBody=~s/([\.\,\;]|<\/i> ) ([Ii]n[\:\. ]+)([^<>]+?) \(([^<>0-9\(\)]+?[^<>\(\)]+?) $regx{editorSuffix}\)/$1 $2<bt>$3<\/bt> \(<edrg>$4<\/edrg> $5\)/gs;


  #$TextBody=~s/ \(([^<>\(\)]+?)([\.\, ]+)$regx{editorSuffix}\)/ \(<edrg>$1<\/edrg>$2$3\)/gs;

  $TextBody=~s/\(([^<>0-9\(\)]+?)\, $regx{editorSuffix}\)/\(<edrg>$1<\/edrg>\, $2\)/gs;
  $TextBody=~s/\(([^<>0-9\(\)]+?[^<>\(\)]+?) $regx{editorSuffix}\)/\(<edrg>$1<\/edrg> $2\)/gs;
  $TextBody=~s/\; ([$AuthorString ]+)([\, ]+)$regx{firstName}\, $regx{editorSuffix}\; <(pbl|cny)>/\; <edrg>$1$2$3<\/edrg>\, $4\; <$5>/gs;


  $TextBody=~s/<i>([Ii]n[\:\,\.]?)<\/i>\s+([^<>4-90\:\?]+?)\s+\($regx{editorSuffix}\)/<i>$1<\/i> <edrg>$2<\/edrg> \($3\)/g;
  $TextBody=~s/<i>([Ii]n?)<\/i>([\:\,\. ]+)([^<>4-90\:\?]+?)\s+\($regx{editorSuffix}\)/<i>$1<\/i>$2<edrg>$3<\/edrg> \($4\)/g;

  $TextBody=~s/\b([Ii]n[\:\,\.]?) <b>([^<>]+?)<\/b> \($regx{editorSuffix}\)/$1 <edrg>$2<\/edrg> \($3\)/gs;

  $TextBody=~s/\b(In[\:\. ]+|[Ii]n[\:\.]+ )\s+([^<>4-90\:\?]+?)\s+\($regx{editorSuffix}\)/$1 <edrg>$2<\/edrg> \($3\)/g;
  $TextBody=~s/([\.\?]|\\newblock) (In[\:\,\.]?)\s+([^<>4-90\:\?]+?)\s+\($regx{editorSuffix}\)/$1 $2 <edrg>$3<\/edrg> \($4\)/g;
  $TextBody=~s/([\.\?]|\\newblock) (In[\:\,\.]?)\s+([^<>4-90\:\?]+?)\s+$regx{editorSuffix}/$1 $2 <edrg>$3<\/edrg> $4/g;

  $TextBody=~s/\b(In[\:\. ]+|[Ii]n[\:\.]+ )([^<>4-90\:\?]+?)\s+\($regx{editorSuffix}\)/$1<edrg>$2<\/edrg> \($3\)/g;

  $TextBody=~s/(\p{P}) (In[\:\. ]+|[Ii]n[\:\.]+ )([^<>4-90\:\?]+?)\s+\($regx{editorSuffix}\)/$1 $2<edrg>$3<\/edrg> \($4\)/g; #for correct


  $TextBody=~s/$regx{allRightQuote} ([Ii]n[\:\. ]+)([^<>4-90\:\?]+?)\s+\($regx{editorSuffix}\)/$1 $2<edrg>$3<\/edrg> \($4\)/g; #for correct
  $TextBody=~s/$regx{allRightQuote} ([Ii]n[\:\. ]+)([^<>4-90\:\?]+?)\s+$regx{editorSuffix}([\.\,\;])/$1 $2<edrg>$3<\/edrg> $4$5/g; #for correct

  #, in Engelstad F. and Teigen M. (eds)
  $TextBody=~s/([\,\.]|<\/i> ) ([Ii]n[\:\. ]+)([^<>4-90\:\?]+?)\s+\($regx{editorSuffix}\)( <i>|[\,\:\.] )/$1 $2<edrg>$3<\/edrg> \($4\)$5/g; #for probability

  #, in Kenneth K. Kurihara, ed.,
  $TextBody=~s/([\,\.]|<\/i> ) ([Ii]n[\:\. ]+)([^<>4-90\:\?]+?)\s+$regx{editorSuffix}( <i>|\, )/$1 $2<edrg>$3<\/edrg> $4$5/g; #for probability
  #  . In Sivaperuman C <i>et al</i>. (Eds).
  $TextBody=~s/([\.\,\:]) \b(In[\:\. ]+|[Ii]n[\:\.]+ )([^4-90\:\?]+?)(<i>et al[\.]?<\/i>[\. ]+)\s+\($regx{editorSuffix}\)/$1 $2<edrg>$3$4<\/edrg> \($5\)/g;


  $TextBody=~s/\, ([iI]n) ([^<>4-9\:\?\[\]\(\)]+) \($regx{editorSuffix}\)/\, $1 <edrg>$2<\/edrg> \($3\)/gs;#******

  #. In: Structural and functional aspects of transport in roots (Eds: Loughman, B.C., Gašparparíková, O., Kolek, J.,), <pbl>Kluwer</pbl>
  $TextBody=&bookEditorWithParen(\$TextBody);



  $TextBody=~s/<bib([^<>]*?)>([^<>4-90\:\?]+)([\p{P}]?)\s+$regx{etal}/<bib$1><aug>$2$3 $4<\/aug>/g;
  $TextBody=~s/<bib([^<>]*?)>([^<>4-90\:\?]+)([\p{P}]?)\s+([\(\[])$regx{editorSuffix}([\)\]])/<bib$1><edrg>$2$3 $4$5$6<\/edrg>/g;
  $TextBody=~s/([\.\,\? ]+)(In[\:\. ]+|[Ii]n[\:\.]+ )<pt>/$1<pt>$2/gs;
  $TextBody=~s/<bib([^<>]*?)><i>([^<>4-90\:\?]+)<\/i>([\.\,\:\; ]+)/<bib$1><aug>$2<\/aug>$3/g;
  $TextBody=~s/<bib([^<>]*?)><b>([^<>4-90\:\?]+)<\/b>([\.\,\:\; ]+)/<bib$1><aug>$2<\/aug>$3/g;
  $TextBody=~s/([\.\?]|\\newblock) ([Ii]n[\.\,\:]?) <edrg>([^<>]+?)\. ([Ii]n[\:\,\.]?)\s+([^<>]+?)<\/edrg>/$1 $2 $3\. $4 <edrg>$5<\/edrg>/gs;


  # $TextBody=~s/<bib([^<>]*?)><aug>$regx{augString}<\/aug>\, <pbl>([^<>]*?)<\/pbl> $regx{firstName} \(/<bib$1><aug>$2\, $3 $4<\/aug> \(/gs;
  #Bohay DR, Manoli A, 2nd (1996)<with><aug>Bohay DR, Manoli A, 2nd</aug> (<yr>1996</yr>) # for check

  $TextBody =~ s!<i>(.*?)<\/i>!xxxslant$1xxxsslant!g;
  $TextBody=~s/<bib([^<>]*?)>([^<>4-90]+?)([\.\;\:\, ]+|[\,\;]? <[ib]>et al<\/[ib]>[\.\,\:]*? )\($regx{year}\)/<bib$1><aug>$2<\/aug>$3\(<yr>$4<\/yr>\)/g;
  $TextBody =~ s!xxxslant!<i>!g;
  $TextBody =~ s!xxxsslant!<\/i>!g;

  $TextBody=~s/<bib([^<>]*?)>([^<>4-90]+?)([\.\;\:\, ]+|[\,\;]? <[ib]>et al<\/[ib]>[\.\,\:]*? )\($regx{year}\/$regx{year}\)/<bib$1><aug>$2<\/aug>$3\(<yr>$4\/$5<\/yr>\)/g;
  $TextBody=~s/<bib([^<>]*?)>([^<>4-90]+?)([\.\;\:\, ]+|[\,\;]? <[ib]>et al<\/[ib]>[\.\,\:]*? )\(([A-Za-z \.0-9]+[\, ]+)$regx{year}\)/<bib$1><aug>$2<\/aug>$3\($4<yr>$5<\/yr>\)/g;
  $TextBody=~s/<bib([^<>]*?)>([^<>4-90]+?)([\.\;\:\, ]+|[\,\;]? <[ib]>et al<\/[ib]>[\.\,\:]*? )\($regx{year}([\, ]+[A-Za-z \.0-9]+)\)/<bib$1><aug>$2<\/aug>$3\(<yr>$4<\/yr>$5\)/g;
  $TextBody=~s/<bib([^<>]*?)>([^<>4-90\:\?]+?)([\.\;\:\, ]+|[\,\;]? <[ib]>et al<\/[ib]>[\.\,\:]*? )$regx{year}([\,\:\. ]+)/<bib$1><aug>$2<\/aug>$3<yr>$4<\/yr>$5/g;##########

  $TextBody=~s/<yr>([^<>]+?)<\/yr>([\.\:\,])((?:(?!<[\/]?bib>)(?!<[\/]?aug>)(?!<[\/]?yr>)(?!<[\/]?pt>).)*?)<pt>((?:(?!<[\/]?bib>)(?!<[\/]?aug>)(?!<[\/]?yr>)(?!<[\/]?pt>).)*?)<\/pt>((?:(?!<[\/]?bib>)(?!<[\/]?aug>)(?!<[\/]?yr>)(?!<[\/]?pt>).)*?)<yr>([^<>]+?)<\/yr>/$1$2$3<pt>$4<\/pt>$5<yr>$6<\/yr>/gs;
  $TextBody=~s/(\, |>)([$AuthorString ]+) $regx{firstName}\. ([A-Za-z]+)<\/aug> $regx{year}([\:\.]) ([a-z]+)/$1$2 $3<\/aug>\. $4 $5$6 $7/gs;


  #, Buning, P.:  #, Schmid, J $  , Schmid, J:
  $TextBody=~s/<bib([^<>]*?)>([^<>4-90\:\?]+[\,\;\/] [^<>4-90\:\?]+ [A-Z\-\. ]+|[^<>4-90\:\,\?]+[\,]? [A-Z\-\. ]+) $regx{particleSuffix}\: /<bib$1><aug>$2 $3<\/aug>\: /g;
  $TextBody=~s/<bib([^<>]*?)>([^<>4-90\:\?]+[\,\;\/] [^<>4-90\:\?]+ [A-Z\-\. ]+|[^<>4-90\:\,\?]+[\,]? [A-Z\-\. ]+)\: /<bib$1><aug>$2<\/aug>\: /g;
  $TextBody=~s/<bib([^<>]*?)>([^<>4-90\:\?]+) ([aA]nd|[uU]nd|en|\&|\\&|\&amp\;|…|\&hellip\;)([\,]? [^<>4-90\:\,\?]+[\,]? [A-Z \-\.]+) $regx{particleSuffix}\: /<bib$1><aug>$2 $3$4 $5<\/aug>\: /g;
  $TextBody=~s/<bib([^<>]*?)>([^<>4-90\:\?]+) ([aA]nd|[uU]nd|en|\&|\\&|\&amp\;|…|\&hellip\;)([\,]? [^<>4-90\:\,\?]+[\,]? [A-Z \-\.]+)\: /<bib$1><aug>$2 $3$4<\/aug>\: /g;
  $TextBody=~s/<bib([^<>]*?)>([^<>\,\.\:\?]+)\: /<bib$1><aug>$2<\/aug>\: /g;
  $TextBody=~s/<bib([^<>]*?)>([^<>4-90\:\?]+\s+\p{L}[\-\.\s]?[\p{L}\-\.\s]*)(\.)([\,\.] [0-9A-Za-z]|[\,\.] “[0-9A-Za-z]|\:\s+)/<bib$1><aug>$2$3<\/aug>$4/g;

  $TextBody=~s/<bib([^<>]*?)>([^<>4-90\:\?]+\s+\p{L}[\-\.\s]?[\p{L}\-\.\s]*)(?!\.\s+\<)(?=\.\s+\p{Lu}\p{Ll}+\s+\p{Ll}+\s+\p{Ll}+)(\&\#8213\;|\:\s+|[\,\.] |[\,\.] “|[\,\.] â|\, \`\`|\.\s+|\,\s+|[\,]?\ [\(]?\d{4}[a-z]?[\)]?[\.\:]?\s+)([<>\p{L}]+)/<bib$1><aug>$2<\/aug>$3$4/g;


  $TextBody=~s/<bib([^<>]*?)>([A-Z][a-z]+ [A-Z\. ]+)\, ([A-Z][a-z]+ [A-Z\. ]+)\. $regx{and} ([$AuthorString ]+) $regx{firstName}\. /<bib$1><aug>$2\, $3\. $4 $5 $6<\/aug>\. /g;
  $TextBody=~s/<bib([^<>]*?)>([A-Z][a-z]+ [A-Z\. ]+)\, ([A-Z][a-z]+ [A-Z\. ]+)\. /<bib$1><aug>$2\, $3<\/aug>\. /g;

  #J. H. Payne, “
  $TextBody=~s/<bib([^<>]*?)>([^<>4-90\:\?]+)\, (“[A-Za-z<]+|[A-Za-z<]+)/<bib$1><aug>$2<\/aug>\, $3/g;
  $TextBody=~s/<bib([^<>]*?)>([^<>4-90\:\?]+)\, (\&quot\;[A-Za-z<]+)/<bib$1><aug>$2<\/aug>\, $3/g;
  $TextBody=~s/<bib([^<>]*?)>([^<>4-90\:\?]+)\, (\`\`[A-Za-z]+)/<bib$1><aug>$2<\/aug>\, $3/g;


  $TextBody=~s/<aug>$regx{augString}\. ([^<>\.\,\:]+?)<\/aug> $regx{year}([\,\.]?) ([a-z]+) ((?:(?!<bib)(?!<\/bib)(?!<\/yr>).)+?)([\.\,\;\: \(]+)<yr>$regx{year}<\/yr>/<aug>$1<\/aug>\. $2 $3$4 $5 $6$7<yr>$8<\/yr>/gs;
  $TextBody=~s/<bib([^<>]*?)><aug>$regx{augString}\, (“|â)$regx{augString}<\/aug>/<bib$1><aug>$2<\/aug>\, $3$4/g;

  $TextBody=~s/<bib([^<>]*?)>([^<>4-90\:\?]+\s+\p{L}[\-\.\s]?[\p{L}\-\.\s]*)\($regx{editorSuffix}\)/<bib$1><aug>$2\($3\)<\/aug>/g;
  $TextBody=~s/<bib([^<>]*?)>([^<>4-90\:\?]+\s+\p{L}[\-\.\s]?[\p{L}\-\.\s]*)$regx{editorSuffix}\b/<bib$1><aug>$2$3<\/aug>/g;


  $TextBody=~s/<bib([^<>]*?)>([^<>4-90\:\?]+\s+\p{L}[\-\.\s]?[\p{L}\-\.\s]*)(?<!Hannover)(?!\, Heft)(?! In)(?!\,[ \p{L}\,]* and)(?!\.\s+\<)(?!\.\s+\p{Lu}\p{Ll}+\s+\p{Lu}\p{Ll}*\s+\p{Lu}\p{Ll}*)(?!\. \w+ \w+ \w+ \w+ \w+)([\.\,] |[\.\,] �|[\.\,] “|[\.\,] ‘|[\.\,] �|[\.\,] [��]+|[\.\,] â|[\.\,] \&quot\;)([<>\p{L}]+)/<bib$1><aug>$2<\/aug>$3$4/g;
  $TextBody=~s/<bib([^<>]*?)>([^<>4-90\:\?]+\s+\p{L}[\-\.\s]?[\p{L}\-\.\s]*)(?<![University|Universität|Universitaet|Organization])(?<!Hannover)(?!\, Heft)(?! In)(?!\,[ \p{L}\,]* and)(?!\.\s+\<)(?!\.\s+\p{Lu}\p{Ll}+\s+\p{Lu}\p{Ll}*\s+\p{Lu}\p{Ll}*)(?!\. \w+ \w+ \w+ \w+ \w+)(\, |\. “|\.\s+|\,\s+|[\,]?\ [\(]?\d{4}[a-z]?[\)]?[\.\:]?\s+)([<>\p{L}]+)/<bib$1><aug>$2<\/aug>$3$4/g;

###### By Pravin Pardeshi for Article title at start
	#print "\nBEFORE\n",$TextBody; exit;
	use ReferenceManager::AuthorName_Regex;
	my %author_name_regex = ReferenceManager::AuthorName_Regex::new();
	my (@refs) = $TextBody =~ m!<bib\s+id.*?<\/bib>!isg;
	foreach my $ref(@refs) {
		my $orig_ref = $ref; 
		next if($ref =~ /<aug>[A-Z]\w*[\.|\,]/);
		if($ref =~ m!<aug>[A-Z]+.*?\s+\b[a-z]+\b[\,\.]?\s+[\,\.]?\b[a-z]+[^<\/]*!s && $ref =~ m!<pt>!s) {	###Check if <aug> tag has small case words ....
			my ($article_grp) = $ref =~ m!(<aug>.*<\/aug>)!s;
			my $orig_artcl_grp = $article_grp;
			my $size = keys %author_name_regex;
			for(my $count = 1;$count <= $size; $count++) {
				#print "\nREGEX $author_name_regex{$count}";
				my $res = 0;
				if($article_grp =~ m!<aug>.*?[\.\?]\s*$author_name_regex{$count}!s) {
					$res = $article_grp =~ s!<aug>(.*?[\.\?]\s*)($author_name_regex{$count})!<at>$1</at><aug>$2!s;
					if($res == 1) {
						$ref =~ s!\Q$orig_artcl_grp\E!$article_grp!s;
						$TextBody =~ s!\Q$orig_ref\E!$ref!s;
					}
					last if($res == 1);
				}
			}
		}
	}
 
###END
   $TextBody=singleAuthorMark(\$TextBody); #######

  $TextBody=~s/([$AuthorString ]+) $regx{firstName}<\/aug>\. ([$AuthorString]+) $regx{firstName}\./$1 $2\. $3 $4<\/aug>\./gs;
  $TextBody=~s/([$AuthorString ]+\s+[A-Z\-\.\s]+)<\/aug>\, ([$AuthorString ]+\s+[A-Z\-\.\s]+)(\, | \()/$1\, $2<\/aug>$3/gs;

  $TextBody=~s/<bib([^<>]*?)>([$AuthorString ]+) $regx{firstName} ([^\.\,\:\;\(\)<>]+ [a-z][^\.\,\:\;\(\)<>]+ [a-z][^\.\,\:\;\(\)<>]+ [a-z][^\.\,\:\;\(\)<> ]+)/<bib$1><aug>$2 $3<\/aug> $4/gs;
  #Rak J Microparticles in cancer. <pt>
  $TextBody=~s/<bib([^<>]*?)>([$AuthorString ]+) $regx{firstName} ([^\.\,\:\;\(\)<>]+ [a-z][^\.\,\:\;\(\)<>]+ [a-z][^\.\,\:\;\(\)<>]+)([\.\,]?) <(cny|pbl|pt)>/<bib$1><aug>$2 $3<\/aug> $4$5 <$6>/gs;
  $TextBody=~s/<bib([^<>]*?)>([$AuthorString ]+) $regx{firstName} ([^\.\,\:\;\(\)<>]+ [^\.\,\:\;\(\)<>]+ [^\.\,\:\;\(\)<>]+ [^\.\,\:\;\(\)<> ]+)/<bib$1><aug>$2 $3<\/aug> $4/gs;
  $TextBody=~s/<bib$regx{noTagOpString}>$regx{sAuthorString}, $regx{sAuthorString} $regx{firstName}\.\, /<bib$1><aug>$2, $3 $4\.<\/aug>\, /gs;

  $TextBody=~s/<bib([^<>]*?)><aug>$regx{augString}<\/aug>([\.\,\:\; ]+)<cny>([^<>]+?)<\/cny>/<bib$1><aug>$2<\/aug>$3$4/gs;


  #select(undef, undef, undef,  $sleep1);
  #***************
  $TextBody=~s/<bib([^<>]*?)>([^<>4-90\:\?]+\s+\p{L}[\-\.\s]?[\p{L}\-\.\s]*)(\. |\, |\: |\; )([^\.\,\:\;\(\)<>]+ [^\.\,\:\;\(\)<>]+ [^\.\,\:\;\(\)<>]+ [^\.\,\:\;\(\)<>]+ [^\.\,\:\;\(\)<> ]+)/<bib$1><aug>$2<\/aug>$3$4/g;

 $TextBody=~s/<bib([^<>]*?)><aug>([$AuthorString ]+\s+[A-Z\-\.\s]+)(\. |\: )([^\.\,\:\;\(\)<>]+ [^\.\,\:\;\(\)<>]+ [^\.\,\:\;\(\)<>]+ [^\.\,\:\;\(\)<>]+ [^\.\,\:\;\(\)<> ]+)<\/aug>/<bib$1><aug>$2<\/aug>$3$4/g;

  $TextBody=~s/<bib([^<>]*?)><aug>$regx{augString}([\,\.]) (|�|“|‘|�|[��]+|â)$regx{augString}<\/aug>/<bib$1><aug>$2<\/aug>$3 $4$5/g;
  $TextBody=~s/<bib([^<>]*?)><aug>$regx{augString}([\,\.]) (|�|“|‘|�|[��]+|â)$regx{augString}<\/aug>/<bib$1><aug>$2<\/aug>$3 $4$5/g;
  #<aug>C. J. M</aug>. Lasance,  
  $TextBody=~s/<bib([^<>]*?)><aug>$regx{firstName}<\/aug>\. ([$AuthorString]+)([\.\,\:]+ )(|�|“|‘|�|[��]+|â|<i>)/<bib$1><aug>$2\. $3<\/aug>$4$5/gs;

  $TextBody=~s/\, $regx{mAuthorFullSirName} $regx{firstName}<\/aug>\, $regx{mAuthorFullSirName} $regx{firstName}\; /\, $1 $2\, $3 $4<\/aug>\; /gs;

  #, and Long</aug>, J.S. (Eds.; 1990)
  #and McCurry</aug>, Ressie (Eds.
  $TextBody=~s/ $regx{and}([\,]?) $regx{mAuthorFullSirName}<\/aug>([\,]?) $regx{firstName} \($regx{editorSuffix}([\.\;\) ])/ $1$2 $3$4 $5<\/aug> \($6$7/gs;
  $TextBody=~s/ $regx{and}([\,]?) $regx{mAuthorString}<\/aug>([\,]?) $regx{mAuthorFullFirstName} \($regx{editorSuffix}([\.\;\) ])/ $1$2 $3$4 $5<\/aug> \($6$7/gs;
  #Reid, N., and Snell E.J. (Eds.; 1991):
  $TextBody=~s/([\,\;] |>)$regx{mAuthorFullSirName}<\/aug>\, $regx{firstName}([\,]?) $regx{and}([\,]?) $regx{mAuthorFullSirName}([\,]?) $regx{firstName} \($regx{editorSuffix}([\.\;\) ])/$1$2\, $3$4 $5$6 $7$8 $9<\/aug> \($10$11/gs;

  #and Diana E. E.</aug> Kleiner.  
  $TextBody=~s/( [au]nd | \& | en |\, |>)([$AuthorString]+) $regx{firstName}<\/aug>\. ([$AuthorString]+)([\.\,\:]+ )(|�|“|‘|�|[��]+|â|<i>)/$1$2 $3\. $4<\/aug>$5$6/gs;

  #. and S</aug>. Lutsenko “
  $TextBody=~s/ $regx{and}([\,]?) $regx{firstName}<\/aug>\. $regx{mAuthorFullSirName}([\:\;\.]?) $regx{allLeftQuote}/ $1$2 $3\. $4<\/aug>$5 $6/gs;
  $TextBody=~s/ $regx{and}([\,]?) $regx{firstName}<\/aug>\. $regx{mAuthorFullSirName}([\:\;\.]?) (\&quot\;|\"|\`\`|\'\')/ $1$2 $3\. $4<\/aug>$5 $6/gs;
  $TextBody=~s/<aug>$regx{firstName}<\/aug>([\.\,]*) $regx{mAuthorFullSirName}([\.\:\;]?) (\&quot\;|\"|\`\`|\'\')/<aug>$1$2 $3<\/aug>$4 $5/gs;
  $TextBody=~s/<aug>$regx{firstName}<\/aug>([\.\,]*) $regx{mAuthorFullSirName}([\.\:\;]?) $regx{allLeftQuote}/<aug>$1$2 $3<\/aug>$4 $5/gs;
  $TextBody=~s/<\/aug>([\,]?) $regx{and} $regx{mAuthorFullFirstName} $regx{mAuthorFullSirName}([\.\:]) /$1 $2 $3 $4<\/aug>$5 /gs;
  $TextBody=~s/<\/aug>([\,]?) $regx{and} $regx{mAuthorFullSirName}\, $regx{mAuthorFullFirstName}([\.\:]) /$1 $2 $3\, $4<\/aug>$5 /gs;
  $TextBody=~s/ $regx{firstName}<\/aug>\. $regx{firstName}\.([\,]?) \"/ $1\. $2\.<\/aug>$3 \"/gs;
  $TextBody=~s/$regx{mAuthorFullSirName} $regx{firstName}<\/aug>\. $regx{firstName}\.\, /$1 $2\. $3\.<\/aug>\, /gs;

  $TextBody=~s/<bib([^<>]*?)>([$AuthorString]+)([\,]?) ([$AuthorString ]+)([\.\,\:]+ )(|�|“|‘|�|[��]+|â|<i>)/<bib$1><aug>$2$3 $4<\/aug>$5$6/gs;
  #Tunstall, Kate E.  
  $TextBody=~s/<bib([^<>]*?)>([$AuthorString]+)([\,]?) ([$AuthorString]+) $regx{firstName}([\.\,\:]+ )(|�|“|‘|�|[��]+|â|<i>)/<bib$1><aug>$2$3 $4 $5<\/aug>$6$7/gs;
  #Bender, John, and Michael Marrinan. <i>
  $TextBody=~s/<bib([^<>]*?)>([$AuthorString]+)([\,]?) ([$AuthorString ]+)([\,]?) $regx{and} ([$AuthorString ]+) ([$AuthorString]+)([\.\,\:]+ )(|�|“|‘|�|[��]+|â|<i>)/<bib$1><aug>$2$3 $4$5 $6 $7 $8<\/aug>$9$10/gs;
  $TextBody=~s/<aug>([^\.\,\:\;<>]+? [^\.\,\:\;<>]+? [^\.\,\:\;<>]+? [^\.\,\:\;<>]+?)\. ([^<>\.\,\:4-9]+)<\/aug>\: ([a-zA-Z])/<aug>$1<\/aug>\. $2\: $3/gs;
  $TextBody=~s/<aug>([^\.\,\:\;<>]+? [^\.\,\:\;<>]+? [^\.\,\:\;<>]+?)\. ([^<>\.\,\:]+ [^<>\.\,\:]+ [^<>\.\,\:]+)<\/aug>\: ([a-zA-Z])/<aug>$1<\/aug>\. $2\: $3/gs;
  $TextBody=~s/<\/aug>([\.\, ]+)$regx{editorSuffix}([\(\.\: ]+)$regx{year}/<\/aug>$1$2$3<yr>$4<\/yr>/gs;
  $TextBody=~s/<aug>$regx{mAuthorString}([\,]?) $regx{firstName}\. ([A-Za-z][^A-Z\.\,]+ [A-Za-z][^A-Z\.\,]+ [a-z\-0-9]+ [a-z\-0-9]+[\.\,]?)<\/aug>/<aug>$1$2 $3<\/aug>\. $4/gs;
  $TextBody=~s/$regx{mAuthorString} ([A-Z\. ]+)\. ([A-Z])<\/aug>\. /$1 $2\. $3\.<\/aug> /gs;

  #<aug>Belady C. and Minichiello A., Effective Thermal Design for Electronic Systems, ElectronicsCooling Magazine, May issue</aug>
  $TextBody=~s/<aug>([^<>]+?) $regx{and} $regx{mAuthorString} $regx{firstName}([,\.]?) ([^\.\,\:\;<>]+? [^\.<>]+?)<\/aug>([\,\.\:\;] )/<aug>$1 $2 $3 $4<\/aug>$5 $6$7/gs;
  #<aug>Holpuch, G., Hummel, M., Tong, G., Seghi, P. Pei, P. Ma, R. Mumper, S. Mallery, T. Nanoparticles for Local Drug Delivery to the Oral Mucosa</aug>.
  $TextBody=~s/<aug>([^<>]+) $regx{mAuthorFullSirName}([\,]?) $regx{firstName}\. $regx{mAuthorFullSirName}([\,]?) $regx{firstName}\. ([A-Z][^A-Z\.]+ [A-Za-z][^A-Z\.]+ [A-Za-z][^A-Z\.]+ [^<>\.]+?)<\/aug>/<aug>$1 $2$3 $4\. $5$6 $7\.<\/aug> $8/gs;
  $TextBody=~s/<aug>([^<>]+?)\, $regx{editorSuffix}\. ([^<>]+?) $regx{editorSuffix}<\/aug>/<aug>$1, $2<\/aug>\. $3 $4/gs;

  $TextBody=~s/<aug>$regx{mAuthorFullSirName}([\,]?) $regx{firstName}\, ([^<>]+?)\, $regx{mAuthorFullSirName}([\,]?) $regx{firstName}\, $regx{mAuthorFullSirName}([\,]?) $regx{firstName}\; ([^\.\,\:\;<>]+? [^\.<>]+?)<\/aug>( [^\(]+? )/<aug>$1$2 $3\, $4\, $5$6 $7\, $8$9 $10<\/aug>\; $11$12/gs;

 $TextBody=~s/<aug>$regx{mAuthorFullSirName}([\,]?) $regx{firstName}\, $regx{mAuthorFullSirName}([\,]?) $regx{firstName}\, $regx{mAuthorFullSirName}([\,]?) $regx{firstName}\; ([^\.\,\:\;<>]+? [^\.<>]+?)<\/aug>( [^\(]+? )/<aug>$1$2 $3\, $4$5 $6\, $7$8 $9<\/aug>\; $10$11/gs;

  $TextBody=~s/<aug>$regx{firstName} $regx{mAuthorFullSirName}\, $regx{firstName} $regx{mAuthorFullSirName}\, $regx{firstName}<\/aug> $regx{mAuthorFullSirName}\,/<aug>$1 $2\, $3 $4\, $5 $6<\/aug>\,/gs;
  $TextBody=~s/<aug>$regx{firstName} $regx{mAuthorFullSirName}\, ([^<>]+) $regx{mAuthorFullSirName}\, $regx{firstName} $regx{mAuthorFullSirName}\, $regx{firstName}<\/aug> $regx{mAuthorFullSirName}\,/<aug>$1 $2\, $3 $4\, $5 $6\, $7 $8<\/aug>\,/gs;
  #<aug>Butler, J.N. and Cogley, D.R. Ionic Equilibrium</aug>.
  $TextBody=~s/<aug>$regx{mAuthorFullSirName}\, $regx{firstName}\. $regx{and} $regx{mAuthorFullSirName}\, $regx{firstName}\. ([A-Z][^A-Z \.]+ [A-Za-z][^A-Z\.]+ [A-Za-z][^\.<>]+)<\/aug>\. /<aug>$1\, $2\. $3 $4\, $5\.<\/aug> $6\. /gs;

  $TextBody=~s/<aug>$regx{mAuthorFullSirName}\, $regx{firstName}\. $regx{and} $regx{mAuthorFullSirName}\, $regx{firstName}\. ([A-Z][^A-Z \.]+ [A-Za-z][^A-Z\.]+)<\/aug>\. /<aug>$1\, $2\. $3 $4\, $5\.<\/aug> $6\. /gs;
  $TextBody=~s/<aug>([^<>]+?)([\,\;\.]) ([Ii]n[\.\:]?) ([^<>]+?)<\/aug>/<aug>$1<\/aug>$2 $3 $4/gs;
  $TextBody=~s/(\, |>)$regx{mAuthorFullSirName}\, $regx{firstName}\, $regx{particleSuffix}([\;\,]) $regx{mAuthorFullSirName}\, $regx{firstName}\. ([A-Z][a-z\-]+ [A-Za-z][a-z\-A-Z]+ [A-Za-z][a-z\-A-Z]+ [A-Za-z][a-z\-A-Z]+ [A-Za-z][a-z\-A-Z]+[^<>]+?)<\/aug>\./$1$2\, $3\, $4$5 $6\, $7<\/aug>\. $8\./gs;
  $TextBody=~s/(\, |>)$regx{firstName} $regx{mAuthorString}\, ([A-Z][a-z]+[A-Z-a-z]+ [a-zA-z][a-z\-]+ [a-zA-z][a-z\-]+ [a-zA-z][a-z\-]+ [^<>\.\,]+)<\/aug>/$1$2 $3<\/aug>\, $4/gs;
  #$TextBody=~s/<aug>$regx{firstName}<\/aug> <misc1>$regx{mAuthorFullSirName}\, \"/<aug>$1<\/aug> $2\, <misc1>\"/gs;
  $TextBody=~s/<aug>$regx{firstName}<\/aug>\. $regx{mAuthorString}\, \"/<aug>$1\. $2<\/aug>\, \"/gs;
  $TextBody=~s/<aug>$regx{firstName}<\/aug>\. $regx{mAuthorString}\, $regx{allLeftQuote}/<aug>$1\. $2<\/aug>\, $3/gs;

 # print $TextBody;

  #----------------------------------------------------------------

  #<aug>M. Birattari, and T</aug>. Stützle, "
  $TextBody=~s/(\, |>)$regx{firstName}\. $regx{mAuthorString}([\,]?) $regx{and} $regx{firstName}<\/aug>\. $regx{mAuthorFullSirName}([\.\,])/$1$2\. $3$4 $5 $6\. $7<\/aug>$8/gs;
  #, Chena; Zhenjie</aug>, Bin; Zhua, and Lia; Hongyan,
  $TextBody=~s/(\, |>)$regx{mAuthorFullSirName}\; $regx{mAuthorFullFirstName}<\/aug>, $regx{mAuthorFullSirName}\; $regx{mAuthorFullFirstName}\,/$1$2\; $3, $4\; $5<\/aug>\,/gs;
  #</aug>, Bin Zhua, and Lia; Hongyan,
  $TextBody=~s/(\, |>)$regx{mAuthorFullSirName}\; $regx{mAuthorFullFirstName}<\/aug>\, $regx{mAuthorFullSirName}\; $regx{mAuthorFullFirstName}([\,]?) $regx{and} $regx{mAuthorFullSirName}\; $regx{mAuthorFullFirstName}([\.\,])/$1$2\; $3\, $4\; $5$6 $7 $8\; $9<\/aug>$10/gs;

 $TextBody=~s/(\, |>)$regx{mAuthorFullSirName}\; $regx{mAuthorFullFirstName}<\/aug>\, $regx{and} $regx{mAuthorFullSirName}\; $regx{mAuthorFullFirstName}([\.\,])/$1$2\; $3\, $4 $5\; $6<\/aug>$7/gs;

  $TextBody=~s/(<aug>|\.\, |\.\;)$regx{mAuthorString}, $regx{firstName}\. $regx{and} $regx{mAuthorString}<\/aug>\, $regx{firstName}\. ([A-Z0-9][^A-Z\.]+ |[A-Z][A-Z][^\.]+ |\(\d+)/$1$2, $3\. $4 $5\, $6\.<\/aug> $7/gs;

  #<aug>Šücha, L</aug>. and Kotrlý, S.
  $TextBody=~s/(<aug>|\.\, |\.\;)$regx{mAuthorString}\, $regx{firstName}<\/aug>\. $regx{and} $regx{mAuthorString}\, $regx{firstName}\. ([A-Z0-9][^A-Z\.]+ |[A-Z][A-Z][^\.]+ |\(\d+)/$1$2\, $3\. $4 $5\, $6\.<\/aug>  $7/gs;
  $TextBody=~s/(<aug>|\.\, |\.\;)$regx{mAuthorString}\, $regx{firstName}<\/aug>\. $regx{and} $regx{mAuthorString}\, $regx{firstName}\. /$1$2\, $3\. $4 $5\, $6\.<\/aug> /gs;
  $TextBody=~s/\, ([A-Z\. ]+\. [A-Z]\.) $regx{and} $regx{mAuthorString}\, ([A-Z\. ])<\/aug>\. ([A-Z\. ]+)\. ([A-Z0-9][0-9a-z]+ |[A-Z][^A-Z][^\.]+ |\(\d+)/\, $1 $2 $3\, $4\. $5\.<\/aug> $6/gs;


  #<aug>Breitmaier, E., Jung, G. Organische Chemie - Grundlagen, Stoffklassen, Reaktionen, Konzepte</aug>,
  $TextBody=~s/<aug>$regx{mAuthorString}([\,]?) $regx{firstName}\, ([^<>]+)\, $regx{mAuthorString}([\,]?) $regx{firstName}\. ([A-Z][^A-Z\.]+ [A-Za-z][^A-Z\.]+ [A-Za-z][^A-Z\.]+ [^<>]+?)<\/aug>/<aug>$1$2 $3\, $4\, $5$6 $7<\/aug>\. $8/gs;
  $TextBody=~s/<aug>$regx{mAuthorString}([\,]?) $regx{firstName}\, ([^<>]+)\, $regx{mAuthorString}([\,]?) $regx{firstName}\. ([A-Z][^A-Z\.]+ [A-Za-z][^A-Z\. ]+ [^A-Za-z]+ [^<>]+?)<\/aug>/<aug>$1$2 $3\, $4\, $5$6 $7<\/aug>\. $8/gs;
  $TextBody=~s/<aug>$regx{mAuthorString}([\,]?) $regx{firstName}\, $regx{mAuthorString}([\,]?) $regx{firstName}\. ([A-Z][^A-Z\.]+ [A-Za-z][^A-Z\.]+ [A-Za-z][^A-Z\.]+ [^<>]+?)<\/aug>/<aug>$1$2 $3\, $4$5 $6<\/aug>\. $7/gs;
  $TextBody=~s/<aug>$regx{mAuthorString}([\,]?) $regx{firstName}\, $regx{mAuthorString}([\,]?) $regx{firstName}\. ([A-Z][^A-Z\.]+ [A-Za-z][^A-Z ]+ [^A-Za-z\.]+ [^<>]+?)<\/aug>/<aug>$1$2 $3\, $4$5 $6<\/aug>\. $7/gs;


  $TextBody=~s/<bib([^<>]*?)><edrg>([^<>]+?) (\([^<>\(\)]+\))\. ([^<>]+?) (\([^<>]+?\))<\/edrg>/<bib$1><aug>$2 $3<\/aug>\. $4 $5/gs;
  $TextBody=~s/<bib([^<>]*?)><aug>([^<>]+?) \($regx{editorSuffix}\)<\/aug>/<bib$1><edrg>$2 \($3\)<\/edrg>/gs;
  $TextBody=~s/<bib([^<>]*?)><aug>([^<>\.]+?)\. ([^<>\.]+?) \(([^<>]+?)\)<\/aug>/<bib$1><aug>$2<\/aug>\. $3 \($4\)/gs;
  #<aug>M.A. Moretton, D.A. Chiappetta, F. Andrade, J. das Neves, D. Ferreira, B. Sarmento, A. Sosnik, Hydrolyzed galactomannan-modified nanoparticles and flower-like polymeric micelles for the active targeting of rifampicin to macrophages</aug>,
  $TextBody=~s/<aug>([^<>]+), $regx{firstName} $regx{mAuthorFullSirName}, $regx{firstName} $regx{mAuthorFullSirName}([\,\.\:]) ([A-Z][^A-Z\.\,]+ [a-zA-Z][^A-Z]+ [0-9a-zA-Z][^A-Z]+ [a-zA-Z][^A-Z]+ [^<>]+)<\/aug>/<aug>$1, $2 $3, $4 $5<\/aug>$6 $7/gs;
  $TextBody=~s/<aug>([^<>]+), $regx{firstName} $regx{mAuthorFullSirName}, $regx{firstName} $regx{mAuthorFullSirName}([\,\.\:]) ([A-Z][^A-Z\.\,]+ [a-z0-9][^A-Z]+ [0-9a-z][^A-Z]+ [^<>]+)<\/aug>/<aug>$1, $2 $3, $4 $5<\/aug>$6 $7/gs;
  $TextBody=~s/<aug>$regx{firstName} $regx{mAuthorFullSirName}, $regx{firstName} $regx{mAuthorFullSirName}([\,\.\:]) ([A-Z][^A-Z\.\,]+ [a-zA-Z][^A-Z]+ [0-9a-zA-Z][^A-Z]+ [a-zA-Z][^A-Z]+ [^<>]+)<\/aug>/<aug>$1 $2\, $3 $4<\/aug>$5 $6/gs;
  $TextBody=~s/<aug>$regx{firstName} $regx{mAuthorFullSirName}, $regx{firstName} $regx{mAuthorFullSirName}([\,\.\:]) ([A-Z][^A-Z\.\,]+ [a-zA-Z][^A-Z]+ [a-zA-Z][^A-Z]+ [^<>]+)<\/aug>/<aug>$1 $2\, $3 $4<\/aug>$5 $6/gs;
  $TextBody=~s/<aug>([^<>]+)\, $regx{mAuthorFullSirName}, $regx{firstName}<\/aug>\. $regx{mAuthorFullSirName}\, $regx{firstName}\. ([^<>4-90\:\(\)]+)\, $regx{and} $regx{firstName}\. $regx{mAuthorFullSirName}([\,\.\:])/<aug>$1\, $2, $3\. $4\, $5\. $6\, $7 $8\. $9<\/aug>$10/gs;

  $TextBody=~s/<aug>$regx{mAuthorFullSirName}\, $regx{firstName}\., $regx{firstName}\. $regx{mAuthorFullSirName}([\,\.\:]) ([A-Z][^A-Z\.\,]+ [a-zA-Z][^A-Z]+ [0-9a-zA-Z][^A-Z]+ [a-zA-Z][^A-Z]+ [^<>]+)<\/aug>/<aug>$1\, $2\., $3\. $4<\/aug>$5 $6/gs;
  $TextBody=~s/<aug>$regx{mAuthorFullSirName}\, $regx{firstName}\., $regx{firstName}\. $regx{mAuthorFullSirName}([\,\.\:]) ([A-Z][^A-Z\.\,]+ [a-zA-Z][^A-Z]+ [a-zA-Z][^A-Z]+ [^<>]+)<\/aug>/<aug>$1\, $2\., $3\. $4<\/aug>$5 $6/gs;



  $TextBody=~s/<aug>$regx{mAuthorString}\, $regx{firstName}\., $regx{mAuthorString}\, $regx{firstName}\.<\/aug>\, $regx{mAuthorString}\, $regx{firstName}\. /<aug>$1\, $2\., $3\, $4\., $5\, $6\.<\/aug> /gs;
  $TextBody=~s/<aug>$regx{mAuthorString}\, $regx{firstName}\., ([^<>]+?)\.\, $regx{mAuthorString}\, $regx{firstName}\.<\/aug>\, $regx{mAuthorString}\, $regx{firstName}\. /<aug>$1\, $2\., $3\.\, $4\, $5\., $6\, $7\.<\/aug> /gs;
  $TextBody=~s/<aug>$regx{mAuthorString}\, $regx{firstName}\., $regx{mAuthorString}\, $regx{firstName}\., $regx{mAuthorString}<\/aug>\, $regx{firstName}\. /<aug>$1\, $2\., $3\, $4\., $5\, $6\.<\/aug> /gs;
  $TextBody=~s/<aug>$regx{mAuthorString}\, $regx{firstName}\., $regx{mAuthorString}<\/aug>\, $regx{firstName}\. /<aug>$1\, $2\., $3\, $4\.<\/aug> /gs;
  $TextBody=~s/<aug>$regx{mAuthorString}\, $regx{firstName}\., ([^<>]+?)\.\, $regx{mAuthorString}\, $regx{firstName}\., $regx{mAuthorString}<\/aug>\, $regx{firstName}\. /<aug>$1\, $2\., $3\., $4\, $5\., $6\, $7\.<\/aug> /gs;
  $TextBody=~s/<aug>$regx{firstName}\. $regx{mAuthorString}\, $regx{firstName}<\/aug>\. $regx{mAuthorString}\;/<aug>$1\. $2\, $3\. $4<\/aug>\;/gs;
  $TextBody=~s/\, $regx{firstName}\. $regx{sAuthorString}\, $regx{firstName}<\/aug>\. $regx{sAuthorString}\;/\, $1\. $2\, $3\. $4<\/aug>\;/gs;
  #<aug>S.H. Shaikh, S.K. Bhunia and N</aug>. Chaki;
  $TextBody=~s/(\, |<aug>)$regx{firstName}\. $regx{mAuthorString} $regx{and} $regx{firstName}<\/aug>\. $regx{mAuthorString}([\;\.\,] )/$1$2\. $3 $4 $5\. $6<\/aug>$7/gs;
  $TextBody=~s/<bib([^<>]*?)>$regx{firstName}\. $regx{mAuthorString}\; /<bib$1><aug>$2\. $3<\/aug>\; /gs;
  $TextBody=~s/<aug>$regx{mAuthorString}, $regx{firstName}\, $regx{mAuthorString}<\/aug>, $regx{firstName}([\.\:\;]) /<aug>$1, $2\, $3, $4<\/aug>$5 /gs;
  #bib19"><aug>Schiffner U</aug>, Jordan RA, Micheelis W (
  $TextBody=~s/<aug>$regx{mAuthorString} $regx{firstName}<\/aug>\, $regx{mAuthorString} $regx{firstName}\, /<aug>$1 $2\, $3 $4<\/aug>\, /gs;
  {}while($TextBody=~s/(<aug>|\, )$regx{mAuthorString} $regx{firstName}\, $regx{mAuthorString} $regx{firstName}<\/aug>\, $regx{mAuthorString} $regx{firstName}\, /$1$2 $3\, $4 $5\, $6 $7<\/aug>\, /gs);
  $TextBody=~s/(<aug>|\, )$regx{mAuthorString} $regx{firstName}<\/aug>\, $regx{mAuthorString} $regx{firstName} (\(|0-9)/$1$2 $3\, $4 $5<\/aug> $6/gs;
  #<aug>S. Francoeur, M. J. Seong, A. Mascarenhas, S. Tixier, M</aug>. Adamcyk.
  $TextBody=~s/<aug>$regx{firstName}\. $regx{mAuthorString}\, ([^<>]+?)\, $regx{firstName}\. $regx{mAuthorString}\, $regx{firstName}\. $regx{mAuthorString}\, $regx{firstName}<\/aug>\. $regx{mAuthorString}([\.\,\;\:]) /<aug>$1\. $2\, $3\, $4\. $5\, $6\. $7\, $8\. $9<\/aug>$10 /gs;
  $TextBody=~s/<aug>$regx{firstName}\. $regx{mAuthorString}\, $regx{firstName}\. $regx{mAuthorString}\, $regx{firstName}\. $regx{mAuthorString}\, $regx{firstName}<\/aug>\. $regx{mAuthorString}([\.\,\;\:]) /<aug>$1\. $2\, $3\. $4\, $5\. $6\, $7\. $8<\/aug>$9 /gs;
  $TextBody=~s/<aug>$regx{firstName}\. $regx{mAuthorString}\, $regx{firstName}\. $regx{mAuthorString}\, $regx{firstName}<\/aug>\. $regx{mAuthorString}([\.\,\;\:]) /<aug>$1\. $2\, $3. $4\, $5\. $6<\/aug>$7 /gs;
  $TextBody=~s/<aug>$regx{firstName}\. $regx{mAuthorString}\, $regx{firstName}<\/aug>\. $regx{mAuthorString}([\.\,\;\:]) /<aug>$1\. $2\, $3\. $4<\/aug>$5 /gs;
  $TextBody=~s/$regx{and} $regx{mAuthorString}<\/aug>\, $regx{firstName}\. /$1 $2\, $3<\/aug>\. /gs;
  $TextBody=~s/ $regx{mAuthorString}<\/aug>([\,]?) $regx{firstName}\. \(/ $1$2 $3<\/aug>\. \(/gs;
  $TextBody=~s/<aug>([^<>]+?) \[([^<>\[\]]+?)<\/aug>([\,\.\( ]+?)<yr>$regx{year}<\/yr>([^<>\]\[]+?)\]/<aug>$1<\/aug> \[$2$3$4$5\]/gs; #****
  $TextBody=~s/<bib([^<>]+?)>$regx{firstName} $regx{mAuthorString}\: /<bib$1><aug>$2 $3<\/aug>\: /gs;
  $TextBody=~s/<aug>$regx{mAuthorString} $regx{firstName}\. ([A-Z][A-Z]+[a-zA-Z\- ]+ [A-Za-z][^A-Z ]+ [A-Za-z][^A-Z ]+ [^<>\.]+)<\/aug>\,/<aug>$1 $2<\/aug>\. $3\,/gs;
  $TextBody=~s/<aug>$regx{mAuthorString}\, $regx{firstName}\., $regx{mAuthorString}\, $regx{firstName}\. ([A-Z][^\.\,\;]+ [^\.\,\;]+ [^\.\,\;]+ [^\.\,\;]+ [^<>\.]+)<\/aug>/<aug>$1\, $2\., $3\, $4\.<\/aug> $5/gs;
  $TextBody=~s/$regx{mAuthorString}<\/aug>\, $regx{firstName}\. <pt>/$1\, $2<\/aug>\. <pt>/gs;


  #select(undef, undef, undef,  $sleep1);

  $TextBody=~s/<aug>$regx{mAuthorFullSirName}<\/aug>\, $regx{mAuthorFullFirstName}\./<aug>$1\, $2<\/aug>\./gs;
  $TextBody=~s/<aug>$regx{mAuthorString}<\/aug>\, $regx{mAuthorFullFirstName}\. <yr>/<aug>$1\, $2<\/aug>\. <yr>/gs;

  $TextBody=~s/<aug>([A-Z][a-z]+ [a-z]+ [A-Z][a-z]+)\, ([^<>\.]+?)<\/aug>\, <(cny|pbl)>([^<>]+?)<\/\3>([.\,\: ]+)<(cny|pbl)>/<aug>$1<\/aug>\, $2\, <$3>$4<\/$3>$5<$6>/gs;
  #<aug>Symonds, John Addington. Sleep and Dreams</aug>:
  $TextBody=~s/<bib([^<>]*?)><aug>([$AuthorString]+)([\,]) ([$AuthorString ]+)\. ([$AuthorString]+) $regx{and} ([$AuthorString]+)<\/aug>\:/<bib$1><aug>$2$3 $4<\/aug>\. $5 $6 $7\:/gs;
  # , C. and Van Den Bosch</aug>, L.,
  $TextBody=~s/<bib([^<>]*?)><aug>$regx{augString}\, $regx{firstName} $regx{and} ([$AuthorString ]+)<\/aug>\, $regx{firstName}([\,\.]+) /<bib$1><aug>$2\, $3 $4 $5\, $6<\/aug>$7 /gs;
  #<aug>HÃ¸yer-Hansen, M</aug>. and JÃ¤Ã¤ttelÃ¤, M.,
  $TextBody=~s/<bib([^<>]*?)><aug>$regx{augString}\, $regx{firstName}<\/aug>\. $regx{and} ([$AuthorString ]+)\, $regx{firstName}\.\, /<bib$1><aug>$2\, $3\. $4 $5\, $6\.<\/aug>\, /gs;

  #>Patrzek, Andreas, Wer das Sagen hat
  $TextBody=~s/([> ])([A-Z][$AuthorString]+)\, ([A-Z][$AuthorString\.]+)\, ([A-Z][\w]+ [\w]+ [^<>\,\.]+ [\w]+)<\/aug>([\.\;\:\, ]+)([a-zA-Z\`„]+|<(cny|pbl|pt|v|iss|pg)>)/$1$2, $3<\/aug>, $4$5$6/gs;
  $TextBody=~s/([> ])([A-Z][$AuthorString]+)\, ([A-Z][$AuthorString\.]+)\, ([A-Z][\w\-]+ [\w\-]+ [\w\-]+ [^<>]+ [\w\-]+)<\/aug>([\.\;\:\, ]+)([a-zA-Z\`„]+|<(cny|pbl|pt|v|iss|pg)>)/$1$2, $3<\/aug>, $4$5$6/gs;
  $TextBody=~s/([> ])([A-Z][$AuthorString]+)\, ([A-Z][$AuthorString\.]+)\, ([A-Z][\w\-]+ [\w\-]+ [^<>\,]+ [\w\-]+ [\w\-]+)<\/aug>([\.\;\:\, ]+)([a-zA-Z\`„]+|<(cny|pbl|pt|v|iss|pg)>)/$1$2, $3<\/aug>, $4$5$6/gs;
  $TextBody=~s/([> ])([A-Z][$AuthorString]+)\, ([A-Z][$AuthorString\.]+)\, ([A-Z][\w]+ [\w ]+)<\/aug>([\.\;\:\, ]+)(<(cny|pbl|pt|v|iss|pg)>)/$1$2, $3<\/aug>, $4$5$6/gs;
  $TextBody=~s/([> ])([A-Z][$AuthorString]+)\, ([A-Z][$AuthorString\.]+)\, ([A-Z][\w]+)<\/aug>([\.\;\:\, ]+)(<(cny|pbl|pt|v|iss|pg)>)/$1$2, $3<\/aug>, $4$5$6/gs;
 $TextBody=~s/([> ])([A-Z][$AuthorString]+)\, ([A-Z][$AuthorString\.]+)\, ([^<>\,]+)\, ([0-9]+[\.]? [Aa]uflage)<\/aug>([\.\;\:\, ]+)(<(cny|pbl|pt|v|iss|pg)>)/$1$2, $3<\/aug>, $4\, $5$6$7/gs;


  #>Noack, Karsten, Kreativitätstechniken, 2. Auflage</aug>, <cny>
  $TextBody=~s/<aug>([^<>]*?)\, \„([^<>]*?)<\/aug>/<aug>$1<\/aug>, \„$2/gs;
  $TextBody=~s/<\/aug>([^<>\`\`]+?)([\.\, ]+)\`\`/$1<\/aug>$2\`\`/gs;
  $TextBody=~s/<aug>([^<>]*)\/([^0-9\,\;\:\`<>\/]+)\, ([^0-9\,\;\:\`<>\/]+)\, ([^<>\/]*?)<\/aug>/<aug>$1\/$2\, $3<\/aug>\, $4/gs;


  $TextBody=~s/<bib([^<>]*?)>$regx{mAuthorFullSirName}([\,]?) $regx{mAuthorFullFirstName}([\p{P}]?)\s+([\(]?)$regx{year}/<bib$1><aug>$2$3 $4<\/aug>$5 $6<yr>$7<\/yr>/g;
  $TextBody=~s/<bib([^<>]*?)>$regx{mAuthorFullFirstName}([\,]?) $regx{mAuthorFullSirName}([\p{P}]?)\s+([\(]?)$regx{year}/<bib$1><aug>$2$3 $4<\/aug>$5 $6<yr>$7<\/yr>/g;

  $TextBody=~s/<bib([^<>]*?)>([^<>4-90\:\?]+)([\p{P}]?)\s+\($regx{editorSuffix}([\, ]+)$regx{year}\)/<bib$1><ia>$2<\/ia>$3 \($4$5<yr>$6<\/yr>\)/g;
  $TextBody=~s/<bib([^<>]*?)>([^<>4-90\:\?]+)([\p{P}]?)\s+([\(]?)$regx{year}/<bib$1><ia>$2<\/ia>$3 $4<yr>$5<\/yr>/g;

  $TextBody=~s/<bib([^<>]*?)>([A-Za-z]+) ([A-Z \.\-]+)\:/<bib$1><aug>$2 $3<\/aug>\:/gs;

  #****
  $TextBody=~s/\, ([Ii]n)<\/aug>\:/<\/aug>\, $1\:/gs;
  $TextBody=~s/([\,\;]?) ([A-Z\-\.]+)<\/aug>\. ([A-Z\-\.]+)\. \(/$1 $2\. $3<\/aug>\. \(/gs;

  #</aug>, Olbers T <i>et al</>   #</aug>, <i>et al</i>.
  $TextBody=~s/<\/aug>(\p{P}?\s*)([\(]?)$regx{year}([\)]?)/<\/aug>$1$2<yr>$3<\/yr>$4/g;
  $TextBody=~s/<\/aug>(\p{P}?\s*)(\()$regx{year}([\.]?\))/<\/aug>$1$2<yr>$3<\/yr>$4/g;
  $TextBody=~s/<\/aug>(\p{P}?\s*et al[\.]?\s*)\($regx{year}([\.]?)\)/<\/aug>$1\(<yr>$2<\/yr>$3\)/g;
  $TextBody=~s/<\/aug>(\p{P}?\s*et\. al[\.]?\s*)\($regx{year}([\.]?)\)/<\/aug>$1\(<yr>$2<\/yr>$3\)/g;
  $TextBody=~s/<\/aug>([\.\,\;\/ ]+)([^<>\,\(\)\+\=\[\]\%\$\!\?\:]+?)([\.\,\;\:]?) <(i|b)>$regx{etal}<\/\4>/$1$2<\/aug>$3 <$4>$5<\/$4>/gs;



  $TextBody=~s/<bib([^<>]*?)>([$AuthorString ]+)\, $regx{firstName}([\.\,]+ )/<bib$1><aug>$2\, $3<\/aug>$4/gs;
  $TextBody=~s/<bib([^<>]*?)>([A-Z ]+)$regx{optionalSpace}([0-9\:\.\-]+) ([\(]?)$regx{year}([\(]?)/<bib$1><ia>$2$3$4<\/ia> $5<yr>$6<\/yr>$7/gs;
  $TextBody=~s/<bib([^<>]*?)>([A-Za-z ]+)$regx{optionalSpace}\(<pbl>([A-Za-z\- ]+)<\/pbl>\)([ ]*)([\(]?)$regx{year}([\(]?)/<bib$1><ia>$2$3\($4\)<\/ia>$5$6<yr>$7<\/yr>$8/gs;
  $TextBody=~s/<bib([^<>]*?)>([A-Za-z ]+)$regx{optionalSpace}\(([A-Za-z\- ]+)\)([ ]*)([\(]?)$regx{year}([\(]?)/<bib$1><ia>$2$3\($4\)<\/ia> $5$6<yr>$7<\/yr>$8/gs;

  $TextBody=~s/<\/aug>\, <pt>([A-Z\. \-]+), $regx{year}\. /\, $1<\/aug>, <yr>$2<\/yr>\. <pt>/gs;


  #(<yr>2005</yr>, May 16)
  $TextBody=~s/\(<yr>([^<>]*?)<\/yr>([\,\.]?) $regx{monthPrefix}([\,\.]?) $regx{dateDay}\)/\(<yr>$1<\/yr>$2 <month>$3$4 $5<\/month>\)/gs;
  $TextBody=~s/\(<yr>([^<>]*?)<\/yr>([\,\.]?) $regx{dateDay}([\,\.]?) $regx{monthPrefix}\)/\(<yr>$1<\/yr>$2 <month>$3$4 $5<\/month>\)/gs;
  $TextBody=~s/\(<yr>([^<>]*?)<\/yr>([\,\.]?) $regx{monthPrefix}([\,\.]?)\)/\(<yr>$1<\/yr>$2 <month>$3$4<\/month>\)/gs; 
  $TextBody=~s/\(<yr>([^<>]*?)<\/yr>([\,\.]?) $regx{monthPrefix}([\,\.\/\-]?)$regx{monthPrefix}\)/\(<yr>$1<\/yr>$2 <month>$3$4$5<\/month>\)/gs;

    #biswajit===========
	#$TextBody=~s/<aug>([^<>]+?) \(([iI]n [pP]ress)\)\. ([^<>]+?)<\/aug>/<aug>$1<\/aug> \(<yr>$2<\/yr>\)\. $3/gs;
	$TextBody=~s/<aug>([^<>]+?) \((In Press|In press|in press|in Press|In press|in press|Inpress|InPress|inpress|Inpress|submitted|Submitted|accepted|Accepted|rejected|Rejected|unpublished|Unpublished|In process|InProcess|in process|inprocess|InProcess)\)([^<>]+?)<\/aug>/<aug>$1<\/aug> \(<yr>$2<\/yr>\)$3/gs;
	$TextBody=~s/\((In Press|In press|in press|in Press|In press|in press|Inpress|InPress|inpress|Inpress|submitted|Submitted|accepted|Accepted|rejected|Rejected|unpublished|Unpublished|In process|InProcess|in process|inprocess|InProcess)\)/\(<yr>$1<\/yr>\)/gs;
	$TextBody=~s/\(<iss>(In Press|In press|in press|in Press|In press|in press|Inpress|InPress|inpress|Inpress|submitted|Submitted|accepted|Accepted|rejected|Rejected|unpublished|Unpublished|In process|InProcess|in process|inprocess|InProcess)<\/iss>\)/\(<yr>$1<\/yr>\)/gs;
	#biswajit===========
  $TextBody=~s/<bib([^<>]*?)>([^<>4-90\.]+)\:/<bib$1><aug>$2<\/aug>\:/gs;


  $TextBody=~s/([\.\,]) ([A-Z\.\-]+ [^<>4-90\:\;\,\)\(]+[^<>4-90\:\;\)\(]+?)\s+\($regx{editorSuffix}\)([\,\.])/$1 <edrg>$2<\/edrg> \($3\)$4/gs;
  $TextBody=~s/([\.\,]) ([^<>4-90\:\;\,\)\(]+[\,]? [A-Z\.\-]+[^<>4-90\:\;\)\(]+?)\s+\($regx{editorSuffix}\)([\,\.])/$1 <edrg>$2<\/edrg> \($3\)$4/gs;

  $TextBody=~s/<bib([^<>]*?)>([A-Z][a-z][a-z]+) ([a-z][a-z]+) ([A-Za-z][a-z][a-z]+) ([A-Za-z][a-z][a-z]+)\./<bib$1><aug>$2 $3 $4 $5<\/aug>\./gs;
  $TextBody=~s/<bib([^<>]*?)>([A-Z][a-z][a-z]+) ([A-Za-z][a-z][a-z]+) ([a-z][a-z]+) ([A-Za-z][a-z][a-z]+)\./<bib$1><aug>$2 $3 $4 $5<\/aug>\./gs;
  $TextBody=~s/<bib([^<>]*?)>([A-Z][^A-Z\.\,\:\;0-9\(\)<> ]+) ([A-Za-z][a-z][^A-Z\.\,\:\;0-9\(\)<> ]+) ([a-z][^A-Z\.\,\:\;0-9\(\)<> ]+) ([A-Za-z][a-z][^A-Z\.\,\:\;0-9\(\)<> ]+)\./<bib$1><aug>$2 $3 $4 $5<\/aug>\./gs;
  $TextBody=~s/<bib([^<>]*?)>([A-Z][^A-Z\.\,\:\;0-9\(\)<> ]+?) ([a-z][a-z][^A-Z\.\,\:\;0-9\(\)<> ]+) ([a-z][a-z][^A-Z\.\,\:\;0-9\(\)<> ]+)\./<bib$1><aug>$2 $3 $4<\/aug>\./gs;
  $TextBody=~s/<bib([^<>]*?)>([A-Z][a-z][a-z][a-z]+) ([A-Za-z][a-z][a-z][a-z]+) ([A-Za-z][[a-z]a-z][a-z]+)\./<bib$1><aug>$2 $3 $4<\/aug>\./gs;
  $TextBody=~s/<bib([^<>]*?)><aug>([A-Z][A-Za-z\-]+|[A-Z][A-Za-z\-]+ [A-Z][A-Za-z\-]+) ([0-9]+)<\/aug>\:$regx{page}\. /<bib$1><ia>$2 $3\:$4<\/ia>\. /gs;

  $TextBody=~s/([\,\: ]+)$regx{and} $regx{instName}\b([^<>]+?)<\/aug>/<\/aug>$1$2 $3$4/gs;
$TextBody=~s/<aug>((?:(?!<aug>)(?!<bib).)+?)( [(]?(Hrgs[\.\:]|Ed[s]?[\.\:]|Editor[s]?:|[Ee]dited [bB]y|Ed[s]?[\.] [Bb]y|Hrsg\.)[\)]?)<\/aug>/<edrg>$1<\/edrg>$2/gs;

  #------------------------------edited by-------------------------------------
  #. In <i>Politeness Across Cultures</i>, ed. by Francesca Bargiela-Chiappini and Dániel Z. Kádár, pp. 42-58. <cny>
  $TextBody=~s/ ([Ii]n[\: ]+)<i>([^<>]*?)<\/i>\, ([eE]d[\.]?|[eE]dited) ([bB]y) ([^<>]+?)([\,\.]?) $regx{pagePrefix}$regx{optionalSpace}$regx{page}([\.\,]) <(cny|pbl)>/ $1<bt><i>$2<\/i><\/bt>, $3 $4 <edrg>$5<\/edrg>$6 $7$8<pg>$9<\/pg>$10 <$11>/gs;
  $TextBody=~s/ ([Ii]n[\: ]+)<i>([^<>]*?)<\/i>\. (Ed[s]?\:|Editor[s]?:) ([^<>]+?)([\,\.]?) $regx{pagePrefix}$regx{optionalSpace}$regx{page}([\.\,]) <(cny|pbl)>/ $1<bt><i>$2<\/i><\/bt>\. $3 <edrg>$4<\/edrg>$5 $6$7<pg>$8<\/pg>$9 <$10>/gs;
  $TextBody=~s/([\.\,] [iI]n[\:\.]) ((?:(?!<[\/]?bib)(?!<[\/]?edrg)(?!<[\/]?bt).)+)\, ([eE]d[s]?[\.]?|[eE]dited) ([bB]y) ([^<>]+?)([\,\.]?) $regx{pagePrefix}$regx{optionalSpace}$regx{page}([\.\,]) <(cny|pbl)>/$1<bt>$2<\/bt>\, $3 $4 <edrg>$5<\/edrg>$6 $7$8<pg>$9<\/pg>$10 <$11>/gs;
  $TextBody=~s/([\.\,] [iI]n[\:\.]) ((?:(?!<[\/]?bib)(?!<[\/]?edrg)(?!<[\/]?bt).)+)\. (Ed[s]?\:|Editor[s]?:) ([^<>]+?)([\,\.]?) $regx{pagePrefix}$regx{optionalSpace}$regx{page}([\.\,]) <(cny|pbl)>/$1<bt>$2<\/bt>\. $3 <edrg>$4<\/edrg>$5 $6$7<pg>$8<\/pg>$9 <$10>/gs;

  $TextBody=~s/ ([Ii]n[\: ]+)<i>([^<>]*?)<\/i>\, ([eE]d[\.]?|[eE]dited) ([bB]y) ([^<>]+?)([\,\.]?) $regx{page}([\.\,]) <(cny|pbl)>/ $1<bt><i>$2<\/i><\/bt>, $3 $4 <edrg>$5<\/edrg>$6 <pg>$7<\/pg>$8 <$9>/gs;
  $TextBody=~s/([\.\,] [iI]n[\:\.]) ((?:(?!<[\/]?bib)(?!<[\/]?edrg)(?!<[\/]?bt).)+)\, ([eE]d[s]?[\.]?|[eE]dited) ([bB]y) ([^<>]+?)([\,\.]?) $regx{page}([\.\,]) <(cny|pbl)>/$1<bt>$2<\/bt>\, $3 $4 <edrg>$5<\/edrg>$6 <pg>$7<\/pg>$8 <$9>/gs;
  $TextBody=~s/([\.\,] [iI]n[\:\.]) ((?:(?!<[\/]?bib)(?!<[\/]?edrg)(?!<[\/]?bt).)+)\. (Ed[s]?\:|Editor[s]?:) ([^<>]+?)([\,\.]?) $regx{page}([\.\,]) <(cny|pbl)>/$1<bt>$2<\/bt>\, $3 <edrg>$4<\/edrg>$5 <pg>$6<\/pg>$7 <$8>/gs;

  $TextBody=~s/([\.\,] [iI]n[\:\.]?) <i>((?:(?!<[\/]?bib)(?!<[\/]?i>)(?!<[\/]?edrg)(?!<[\/]?bt).)+)<\/i>([\,\.]?) ([eE]d[\.]?|[eE]dited) by ([^<>]+?) \(<(pbl|cny)>/$1 <bt><i>$2<\/i><\/bt>$3 $4 by <edrg>$5<\/edrg> \(<$6>/gs;
  $TextBody=~s/([\.\,] In[\:\.]?) ((?:(?!<[\/]?bib)(?!<[\/]?edrg)(?!<[\/]?bt).)+)([\,\.]?) ([eE]d[\.]?|[eE]dited) ([bB]y) ([^<>]+?) \(<(pbl|cny)>/$1 <bt>$2<\/bt>$3 $4 $5 <edrg>$6<\/edrg> \(<$7>/gs;
  $TextBody=~s/([\.\,] In[\:\.]?) ((?:(?!<[\/]?bib)(?!<[\/]?edrg)(?!<[\/]?bt).)+)([\,\.]) (Ed[s]?\:|Editor[s]?:) ([^<>]+?) \(<(pbl|cny)>/$1 <bt>$2<\/bt>$3 $4 <edrg>$5<\/edrg> \(<$6>/gs;

  $TextBody=~s/([\.\,] [iI]n[\:\.]) ((?:(?!<[\/]?bib)(?!<[\/]?edrg)(?!<[\/]?bt).)+)([\,\.]?) ([eE]d[\.]?|[eE]dited) ([bB]y) ([^<>]+?) \(<(pbl|cny)>/$1 <bt>$2<\/bt>$3 $4 $5 <edrg>$6<\/edrg> \(<$7>/gs;
  $TextBody=~s/([\.\,] [iI]n[\:\.]?) ((?:(?!<[\/]?bib)(?!<[\/]?edrg)(?!<[\/]?bt).)+)(\, [eE]dited [bB]y |\, [eE]d[\.]? [bB]y |\. Ed[s]?\: |\. [eE]ditors\: )([^<>]+?)([\,\.]? [\(]?)<(pbl|cny)>/$1 <bt>$2<\/bt>$3<edrg>$4<\/edrg>$5<$6>/gs;

  $TextBody=~s/ $regx{pagePrefix}$regx{optionalSpace}$regx{page}([\.\,]?) ([iI]n[\:\.]?) ((?:(?!<[\/]?bib)(?!<[\/]?edrg)(?!<[\/]?bt).)+)(\, [eE]dited [bB]y |\, [eE]d[\.]? [bB]y )([^<>]+?)([\,\.]? [\(]?)<(pbl|cny)>/ $1$2$3$4 $5 <bt>$6<\/bt>$7<edrg>$8<\/edrg>$9<$10>/gs;

  #In <edrg>The New Palgrave Dictionary of Economics and the Law Vol. 2.</edrg> Edited by P. Newman.
  $TextBody=~s/ ([Ii]n[\:]?) <edrg>([^<>]+)\.<\/edrg> ([eE]d[s]?[\.]?|[eE]dited) ([bB]y) ([^<>4-90\?\:]+?)\. <(cny|pbl)>/ $1 <bt>$2\.<\/bt> $3 $4 <edrg>$5<\/edrg>\. <$6>/gs;


  #([eE]d[s]?[\.]?|[eE]dited) ([bB]y)
  $TextBody=~s/<(yr|aug)>([\)\.\: ]+)([^<>\.]+)\. ([eE]d[s]?[\.]?|[eE]dited) ([bB]y) ([^<>4-90\?\:]+)\, ([^<>\.]+)\. <(cny|pbl)>/<$1>$2<misc1>$3<\/misc1>\. $4 $5 <edrg>$6<\/edrg>\, <bt>$7<\/bt>\. <$8>/gs;
  $TextBody=~s/\b([Ii]n[\: ]+)<edrg>([^<>]+?)<\/edrg> ([eE]d[s]?|[eE]dited)(\. [Bb]y) ([^<>4-90]*?)([\,]?) ([0-9\-]+)([\.\,]) <(cny|pbl)>/$1<bt>$2<\/bt> $3$4 <edrg>$5<\/edrg>$6 <pg>$7<\/pg>$8 <$9>/gs;

  #----------------------------------------------------------------------------

  $TextBody=~s/([\.\,] [iI]n[\:\.]?) ((?:(?!<[\/]?bib)(?!<[\/]?i>)(?!<[\/]?edrg)(?!<[\/]?bt).)+)([\,\.]) <i>([^<>]+?)<\/i>([^<>]+?)<(cny|pbl)>/$1 <edrg>$2<\/edrg>$3 <bt><i>$4<\/i><\/bt>$5<$6>/gs;

  $TextBody=~s/ ([Ii]n[\: ]+)<i>([^<>]*?)<\/i>([\,]?) ([eE]ditor[s]?|[eE]d[s]?|[Hh]rsg|[hH]g)\. ([^<>]+?)([\,]?) $regx{pagePrefix}$regx{optionalSpace}$regx{page}([\.\,]) <(cny|pbl)>/ $1<bt><i>$2<\/i><\/bt>$3 $4\. <edrg>$5<\/edrg>$6 $7$8<pg>$9<\/pg>$10 <$11>/gs;
  $TextBody=~s/ ([Ii]n[\: ]+)<i>([^<>]*?)<\/i>([\,]?) ([eE]ditor[s]?|[eE]d[s]?|[Hh]rsg|[hH]g)\. ([^<>]*?)([\,]?) ([0-9\-]+)([\.\,]) <(cny|pbl)>/ $1<bt><i>$2<\/i><\/bt>$3 $4\. <edrg>$5<\/edrg>$6 <pg>$7<\/pg>$8 <$9>/gs;
  $TextBody=~s/ ([Ii]n[\: ]+)<i>([^<>]*?)<\/i>, ([eE]ditor[s]?|[eE]d[s]?|[Hh]rsg|[hH]g)\. ([^<>]*?)([\.\,]?) <(cny|pbl)>/ $1<bt><i>$2<\/i><\/bt>, $3\. <edrg>$4<\/edrg>$5 <$6>/gs;
  #biswajit
  $TextBody=~s/([\.\,]) In ([A-Z\.\-]+ [^<>4-90\:\;\,\)\(]+) $regx{and} ([A-Z\.\-]+ [^<>4-90\:\;\,\)\(]+)(\, | \(([eE]ditor[s]?|[eE]d[s]?|[Hh]rsg|[hH]g)[\.]?\))/$1 In <edrg>$2 $3 $4<\/edrg>$5/gs;
  $TextBody=~s/([\.\,]) In ([^<>4-90\:\;\,\)\(]+ [A-Z\.\-]+) $regx{and} ([^<>4-90\:\;\,\)\(]+ [A-Z\.\-]+)(\, | \(([eE]ditor[s]?|[eE]d[s]?|[Hh]rsg|[hH]g)[\.]?\))/$1 In <edrg>$2 $3 $4<\/edrg>$5/gs;

  #--------------------------------------------------------------------------
  $TextBody=~s/([\.\,] [iI]n[\:\.]?) <edrg>([^<>]+?\,)<\/edrg> $regx{editorSuffix}\. $regx{firstName} ([$AuthorString]+)\, $regx{firstName} ([$AuthorString]+) $regx{and} $regx{firstName} ([$AuthorString]+)\, $regx{pagePrefix}$regx{optionalSpace}$regx{page}\. <(cny|pbl)>/$1 <bt>$2<\/bt> $3\. <edrg>$4 $5\, $6 $7 $8 $9 $10<\/edrg>\, $11$12<pg>$13<\/pg>\. <$14>/gs;
  $TextBody=~s/([\.\,] [iI]n[\:\.]?) <edrg>([^<>]+?\,)<\/edrg> $regx{editorSuffix}\. $regx{firstName} ([$AuthorString]+)\, $regx{firstName} ([$AuthorString]+) $regx{and} $regx{firstName} ([$AuthorString]+)\, $regx{page}\. <(cny|pbl)>/$1 <bt>$2<\/bt> $3\. <edrg>$4 $5\, $6 $7 $8 $9 $10<\/edrg>\, <pg>$11<\/pg>\. <$12>/gs;
  $TextBody=~s/([\.\,] [iI]n[\:\.]?) <edrg>([^<>]+?\,)<\/edrg> $regx{editorSuffix}\. $regx{firstName} ([$AuthorString]+)\, $regx{firstName} ([$AuthorString]+) $regx{and} $regx{firstName} ([$AuthorString]+)\. <(cny|pbl)>/$1 <bt>$2<\/bt> $3\. <edrg>$4 $5\, $6 $7 $8 $9 $10<\/edrg>\. <$11>/gs;

  #. In <edrg>Language in the law,</edrg> eds. A. Marmor and S. Soames, pp. 14--30. <cny>
  $TextBody=~s/([\.\,] [iI]n[\:\.]?) <edrg>([^<>]+?\,)<\/edrg> $regx{editorSuffix}\. $regx{firstName} ([$AuthorString]+) $regx{and} $regx{firstName} ([$AuthorString]+)\, $regx{pagePrefix}$regx{optionalSpace}$regx{page}\. <(cny|pbl)>/$1 <bt>$2<\/bt> $3\. <edrg>$4 $5 $6 $7 $8<\/edrg>\, $9$10<pg>$11<\/pg>\. <$12>/gs;
  $TextBody=~s/([\.\,] [iI]n[\:\.]?) <edrg>([^<>]+?\,)<\/edrg> $regx{editorSuffix}\. $regx{firstName} ([$AuthorString]+) $regx{and} $regx{firstName} ([$AuthorString]+)\, $regx{page}\. <(cny|pbl)>/$1 <bt>$2<\/bt> $3\. <edrg>$4 $5 $6 $7 $8<\/edrg>\, <pg>$9<\/pg>\. <$10>/gs;
  $TextBody=~s/([\.\,] [iI]n[\:\.]?) <edrg>([^<>]+?\,)<\/edrg> $regx{editorSuffix}\. $regx{firstName} ([$AuthorString]+) $regx{and} $regx{firstName} ([$AuthorString]+)\. <(cny|pbl)>/$1 <bt>$2<\/bt> $3\. <edrg>$4 $5 $6 $7 $8<\/edrg>\. <$9>/gs;

  $TextBody=~s/([\.\,] [iI]n[\:\.]?) <edrg>([^<>]+?\,)<\/edrg> $regx{editorSuffix}\. ([$AuthorString]+) $regx{firstName} ([$AuthorString]+) $regx{and} ([$AuthorString]+) ([$AuthorString]+)\, $regx{pagePrefix}$regx{optionalSpace}$regx{page}\. <(cny|pbl)>/$1 <bt>$2<\/bt> $3\. <edrg>$4 $5 $6 $7 $8 $9<\/edrg>\, $10$11<pg>$12<\/pg>\. <$13>/gs;
  $TextBody=~s/([\.\,] [iI]n[\:\.]?) <edrg>([^<>]+?\,)<\/edrg> $regx{editorSuffix}\. ([$AuthorString]+) $regx{firstName} ([$AuthorString]+) $regx{and} ([$AuthorString]+) ([$AuthorString]+)\, $regx{page}\. <(cny|pbl)>/$1 <bt>$2<\/bt> $3\. <edrg>$4 $5 $6 $7 $8 $9<\/edrg>\, <pg>$10<\/pg>\. <$11>/gs;
$TextBody=~s/([\.\,] [iI]n[\:\.]?) <edrg>([^<>]+?\,)<\/edrg> $regx{editorSuffix}\. ([$AuthorString]+) $regx{firstName} ([$AuthorString]+) $regx{and} ([$AuthorString]+) ([$AuthorString]+)\. <(cny|pbl)>/$1 <bt>$2<\/bt> $3\. <edrg>$4 $5 $6 $7 $8 $9<\/edrg>\. <$10>/gs;


  $TextBody=~s/([\.\,] [iI]n[\:\.]?) <edrg>([^<>]+?\,)<\/edrg> $regx{editorSuffix}\. $regx{firstName} ([$AuthorString]+)\, $regx{pagePrefix}$regx{optionalSpace}$regx{page}\. <(cny|pbl)>/$1 <bt>$2<\/bt> $3\. <edrg>$4 $5<\/edrg>\, $6$7<pg>$8<\/pg>\. <$9>/gs;
  $TextBody=~s/([\.\,] [iI]n[\:\.]?) <edrg>([^<>]+?\,)<\/edrg> ([Ee]d[s]?[\.]?|[Hh]rgs[\.]?) ([$AuthorString]+) $regx{firstName} ([$AuthorString]+)\, $regx{page}\. <(cny|pbl)>/$1 <bt>$2<\/bt> $3 <edrg>$4 $5 $6<\/edrg>\, <pg>$7<\/pg>\. <$8>/gs;
  $TextBody=~s/([\.\,] [iI]n[\:\.]?) <edrg>([^<>]+?\,)<\/edrg> ([Ee]d[s]?[\.]?|[Hh]rgs[\.]?) $regx{firstName} ([$AuthorString]+)\, $regx{page}\. <(cny|pbl)>/$1 <bt>$2<\/bt> $3 <edrg>$4 $5<\/edrg>\, <pg>$6<\/pg>\. <$7>/gs;
  $TextBody=~s/([\.\,] [iI]n[\:\.]?) <edrg>([^<>]+?\,)<\/edrg> ([Ee]d[s]?[\.]?|[Hh]rgs[\.]?) ([$AuthorString]+) $regx{firstName}\, $regx{page}\. <(cny|pbl)>/$1 <bt>$2<\/bt> $3 <edrg>$4 $5<\/edrg>\, <pg>$6<\/pg>\. <$7>/gs;

#  print $TextBody;exit;

  $TextBody=~s/([\.\,] [iI]n[\:\.]?) <edrg>([^<>]+?\,)<\/edrg> $regx{editorSuffix}\. ([$AuthorString]+) ([$AuthorString]+) $regx{and} ([$AuthorString]+) ([$AuthorString]+)\, $regx{pagePrefix}$regx{optionalSpace}$regx{page}\. <(cny|pbl)>/$1 <bt>$2<\/bt> $3\. <edrg>$4 $5 $6 $7 $8<\/edrg>\, $9$10<pg>$11<\/pg>\. <$12>/gs;
  $TextBody=~s/([\.\,] [iI]n[\:\.]?) <edrg>([^<>]+?\,)<\/edrg> $regx{editorSuffix}\. ([$AuthorString]+) ([$AuthorString]+) $regx{and} ([$AuthorString]+) ([$AuthorString]+)\, $regx{page}\. <(cny|pbl)>/$1 <bt>$2<\/bt> $3\. <edrg>$4 $5 $6 $7 $8<\/edrg>\, <pg>$9<\/pg>\. <$10>/gs;

  $TextBody=~s/([\.\,] [iI]n[\:\.]?) <edrg>([^<>]+?\,)<\/edrg> $regx{editorSuffix} ([$AuthorString]+) ([$AuthorString]+) $regx{and} ([$AuthorString]+) ([$AuthorString]+)\, $regx{page}\. <(cny|pbl)>/$1 <bt>$2<\/bt> $3 <edrg>$4 $5 $6 $7 $8<\/edrg>\, <pg>$9<\/pg>\. <$10>/gs;

  #. S.E. Jorgensen and R.A. Vollenweider Eds. <cny>Shiga, Japan</cny>: <pbl>
  $TextBody=~s/([\.\;\,] )$regx{firstName} $regx{mAuthorString} $regx{and} $regx{firstName} $regx{mAuthorString} $regx{editorSuffix}\. <(cny|pbl)>([^<>]+?)<\/\8>([\.\,\;\: ]+)<(cny|pbl)>/$1<edrg>$2 $3 $4 $5 $6<\/edrg> $7\. <$8>$9<\/$8>$10<$11>/gs;

  #In <i>The Axial Age and Its Consequences</i>. Ed. By Robert H. Bellah and Hans Joas, 447-66. <cny>
  $TextBody=~s/( [Ii]n[\:\.]?) <i>((?:(?!<[\/]?bib)(?!<[\/]?edrg>)(?!<[\/]?i>)(?!<[\/]?bt>).)+?)<\/i>([\,\.]?) ([eE]d[\.]?|[eE]dited) ([bB]y) ([^<>]+?)([\,\.]? [\(]?)<(pbl|cny)>/$1 <bt><i>$2<\/i><\/bt>$3 $4 $5 <edrg>$6<\/edrg>$7 <$8>/gs;
  $TextBody=~s/( [Ii]n[\:\.]?) <i>((?:(?!<[\/]?bib)(?!<[\/]?edrg>)(?!<[\/]?i>)(?!<[\/]?bt>).)+?)<\/i>([\,\.]?) (Eds\:) ([^<>]+?)([\.\,]) <(pbl|cny)>/$1 <bt><i>$2<\/i><\/bt>$3 $4 <edrg>$5<\/edrg>$6 <$7>/gs;
  $TextBody=~s/(<\/i>[\.\?]|[a-z]+\.) $regx{firstName} ([$AuthorString ]+)([\,]? et al[\.]?)?([\,\.]) (Ed[s]?|Hrgs)\. <(cny|pbl)>/$1 <edrg>$2 $3$4<\/edrg>$5 $6\. <$7>/gs;
  $TextBody=~s/(<\/i>[\.\?]|[a-z]+\.) $regx{firstName} ([$AuthorString ]+) $regx{and} $regx{firstName} ([$AuthorString ]+)([\,]? et al[\.]?)?([\,\.]) (Ed[s]?|Hrgs)\. <(cny|pbl)>/$1 <edrg>$2 $3 $4 $5 $6$7<\/edrg>$8 $9\. <$10>/gs;

  $TextBody=~s/(<\/i>[\.\?]|[a-z]+\.) ([$AuthorString]+) ([$AuthorString]+)([\,]? et al[\.]?)?([\,\.]) (Ed[s]?|Hrgs)\. <(cny|pbl)>/$1 <edrg>$2 $3 $4<\/edrg>$5 $6\. <$7>/gs;
  $TextBody=~s/(<\/i>[\.\?]|[a-z]+\.) ([$AuthorString]+) ([$AuthorString]+) ([$AuthorString]+)([\,]? et al[\.]?)?([\,\.]) (Ed[s]?|Hrgs)\. <(cny|pbl)>/$1 <edrg>$2 $3 $4$5<\/edrg>$6 $7\. <$8>/gs;

  $TextBody=~s/<pt>([^<>]+)<\/pt>([^<>]+)<(cny|pbl)>([^<>]+?)<\/\3>/$1$2<$3>$4<\/$3>/gs;
  $TextBody=~s/<\/(yr|ia|aug)>([\.\)\,\:\;]? )([^<>\.]+)\. ([^<>\.]+)([\.\, ]+)$regx{volumePrefix}$regx{optionalSpace}$regx{volume}([\.\, ]+)$regx{edn}$regx{numberSuffix} $regx{ednSuffix}([\.\, ]+)$regx{pagePrefix}$regx{optionalSpace}$regx{page}([\.\, ]+)$regx{editorSuffix}([\.\:]?) ([^<>\.\,]+?[^<>]+?)([\.\,]? )<(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>\. <bt>$4<\/bt>$5$6$7<v>$8<\/v>$9<edn>$10<\/edn>$11 $12$13$14$15<pg>$16<\/pg>$17$18$19 <edrg>$20<\/edrg>$21<$22>/gs;

  $TextBody=~s/<\/(yr|ia|aug)>([\.\)\,\:\;]? )([^<>\.]+)\. ([Ii]n[\.\: ]+)<i>([^<>]+)<\/i>([\.\, ]+)$regx{volumePrefix}$regx{optionalSpace}$regx{volume}([\.\, ]+)$regx{edn}$regx{numberSuffix} $regx{ednSuffix}([\.\, ]+)$regx{pagePrefix}$regx{optionalSpace}$regx{page}([\.\, ]+)$regx{editorSuffix}([\.\:]?) ([^<>\.\,]+?[^<>]+?)([\.\,]? )<(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>\. $4<bt><i>$5<\/i><\/bt>$6$7$8<v>$9<\/v>$10<edn>$11<\/edn>$12 $13$14$15$16<pg>$17<\/pg>$18$19$20 <edrg>$21<\/edrg>$22<$23>/gs;


  #<p><bib id="bib2"><aug>Arendt, Hannah</aug>. <yr>1981</yr>. Karl Jaspers: citizen of the world. <i>The philosophy of Karl Jaspers: the library of living philosophers</i>, 2<sup>nd</sup> augmented ed. Ed. Paul A. Schilpp, 539-49. <cny>La Salle</cny>: <pbl>Open Court Publishing Company</pbl>.</bib></p>
  $TextBody=~s/<\/(yr|aug|ia)>([\.\:\) ]+)([^<>]+?)([\.\?] |[\.\,]? [iI]n[\.\:]? )<i>((?:(?!<[\/]?bib)(?!<[\/]?i>).)*?)<\/i>([\,\.]) ([0-9]+)$regx{numberSuffix} $regx{ednSuffix}\. ([Ee]d[s]?|Hrgs)\. ([^<>0-9]+?)\, $regx{page}\. <(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt><i>$5<\/i><\/bt>$6 <edn>$7<\/edn>$8 $9\. $10\. <edrg>$11<\/edrg>\, <pg>$12<\/pg>\. <$13>/gs;
  #<p><bib id="bib3"><aug>Arendt, Hannah</aug>. <yr>1981</yr>. Karl Jaspers: citizen of the world. <i>The philosophy of Karl Jaspers: the library of living philosophers</i>, Ed. Paul A. Schilpp, 539-49. <cny>La Salle</cny>: <pbl>Open Court Publishing Company</pbl>.</bib></p>
  $TextBody=~s/<\/(yr|aug|ia)>([\.\:\) ]+)([^<>]+?)([\.\?] |[\.\,]? [iI]n[\.\:]? )<i>((?:(?!<[\/]?bib)(?!<[\/]?i>).)*?)<\/i>([\,\.]) ([Ee]d[s]?|Hrgs)\. ([^<>0-9]+?)\, $regx{page}\. <(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt><i>$5<\/i><\/bt>$6 $7\. <edrg>$8<\/edrg>\, <pg>$9<\/pg>\. <$10>/gs;
  #<p><bib id="bib4"><aug>Arendt, Hannah</aug>. <yr>1981</yr>. Karl Jaspers: citizen of the world. <i>The philosophy of Karl Jaspers: the library of living philosophers</i>, Ed. Paul A. Schilpp. <cny>La Salle</cny>: <pbl>Open Court Publishing Company</pbl>.</bib></p>
  $TextBody=~s/<\/(yr|aug|ia)>([\.\:\) ]+)([^<>]+?)([\.\?] |[\.\,]? [iI]n[\.\:]? )<i>((?:(?!<[\/]?bib)(?!<[\/]?i>).)*?)<\/i>([\,\.]) ([Ee]d[s]?|Hrgs)\. ([^<>0-9]+?)\. <(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt><i>$5<\/i><\/bt>$6 $7\. <edrg>$8<\/edrg>\. <$9>/gs;
  $TextBody=~s/( [iI]n[\.\:]? )<i>((?:(?!<[\/]?bib)(?!<[\/]?i>).)*?)<\/i>([\,\.]) (Ed[s]?|Hrgs)\. ([^<>0-9]+?)\. <(cny|pbl)>/$1<bt><i>$2<\/i><\/bt>$3 $4\. <edrg>$5<\/edrg>\. <$6>/gs;
  #in <i>Social Connections in China: Institutions, Culture, and the Changing Nature of Guanxi</i>. Eds. Gold, Guthrie, and Wank. <cny>
  #, eds. P. Cole and L. Morgan, 43-58. <cny>
  #<yr>2013</yr>. Legal texts and canons of construction. A view from current pragmatic theory. In Law and language: Current legal issues, eds. M. Freeman and F. Smith pp. 8--34. <cny>
  $TextBody=~s/<\/(yr|aug|ia)>([\.\:\)]+ )([^<>]+?)([\.\,] [iI]n[\.\:]? )([^<>\.]+?)([\,\.]) ([Ee]d[s]?|Hrgs)\. ([^<>0-9]+?)([\,]?) $regx{pagePrefix}$regx{optionalSpace}$regx{page}\. <(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt>$5<\/bt>$6 $7\. <edrg>$8<\/edrg>$9 $10$11<pg>$12<\/pg>\. <$13>/gs;
  $TextBody=~s/<\/(yr|aug|ia)>([\.\:\)]+ )([^<>]+?)([\.\,] [iI]n[\.\:]? )([^<>\.]+?)([\,\.]) ([Ee]d[s]?|Hrgs)\. ([^<>0-9]+?)\, $regx{page}\. <(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt>$5<\/bt>$6 $7\. <edrg>$8<\/edrg>\, <pg>$9<\/pg>\. <$10>/gs;
  $TextBody=~s/<\/(yr|aug|ia)>([\.\:\)]+ )([^<>]+?)([\.\,] [iI]n[\.\:]? )([^<>\.]+?)([\,\.]) ([Ee]d[s]?|Hrgs)\. ([^<>0-9]+?)\. <(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt>$5<\/bt>$6 $7\. <edrg>$8<\/edrg>\. <$9>/gs;



  #</yr>) Web-Monitoring im Wahlkampf. In P. Brauckmann, Web-Monitoring (S. 321-337). <pbl>
  $TextBody=~s/<\/(yr|aug|ia)>([\.\:\)]+ )([^<>\.]+?)([\.\,] [iI]n[\.\:]? )([^<>]+?)\, ([^<>\,\.]+?) \($regx{pagePrefix}$regx{optionalSpace}$regx{page}\)\. <(pbl|cny)>/<\/$1>$2<misc1>$3<\/misc1>$4<edrg>$5<\/edrg>\, <bt>$6<\/bt> \($7$8<pg>$9<\/pg>\)\. <$10>/gs;
  #</yr>). Issues Management. In Meckel M, Schmid BF, Unternehmenskommunikation (2. Auflage, S. 323-353). <cny>
  $TextBody=~s/<\/(yr|aug|ia)>([\.\:\)]+ )([^<>\.]+?)([\.\,] [iI]n[\.\:]? )([^<>]+?)\, ([^<>\,\.]+?) \($regx{edn}([\.]?) $regx{ednSuffix}\, $regx{pagePrefix}$regx{optionalSpace}$regx{page}\)\. <(pbl|cny)>/<\/$1>$2<misc1>$3<\/misc1>$4<edrg>$5<\/edrg>\, <bt>$6<\/bt> \(<edn>$7<\/edn>$8 $9\, $10$11<pg>$12<\/pg>\)\. <$13>/gs;
  #</yr>) Agenda Setting. In: G. Bentele, H-B. Brosius & O. Jarren, Lexikon Kommunikations- und Medienwissenschaft, 2. Auflage (S. 13-14). <pbl>
  $TextBody=~s/<\/(yr|aug|ia)>([\.\:\)]+ )([^<>\.]+?)([\.\,] [iI]n[\.\:]? )([^<>]+?)\, ([^<>\,\.]+?)\, $regx{edn}([\.]?) $regx{ednSuffix} \($regx{pagePrefix}$regx{optionalSpace}$regx{page}\)\. <(pbl|cny)>/<\/$1>$2<misc1>$3<\/misc1>$4<edrg>$5<\/edrg>\, <bt>$6<\/bt>\, <edn>$7<\/edn>$8 $9 \($10$11<pg>$12<\/pg>\)\. <$13>/gs;

  #</yr>. The Flow of Cosmic Power: Religion, Ritual, and the People of Tiwanaku. In Tiwanaku: Ancestors of the Inca, ed M. Young-Sanchez, 97-125. <cny>
 $TextBody=~s/<\/(yr|aug|ia)>([\.\:\)]+ )([^<>\.]+?)([\.\,] [iI]n[\.\:]? )([^<>\.]+?)\, $regx{editorSuffix} $regx{firstName} $regx{mAuthorString}\, $regx{page}\. <(pbl|cny)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt>$5<\/bt>\, $6 <edrg>$7 $8<\/edrg>\, <pg>$9<\/pg>\. <$10>/gs;

  #</yr>. The evolution of chiefdoms. An economic anthropological model. In <edrg>Archaeological Perspectives on Political Economies,</edrg> eds Gary M. Feinman and Linda M. Nicholas, 7-24. <cny>
  $TextBody=~s/([\.\,] [iI]n[\:\.]?) <edrg>([^<>]+?\,)<\/edrg> $regx{editorSuffix} $regx{firstName} $regx{mAuthorString} $regx{and} $regx{firstName} $regx{mAuthorString}\, $regx{page}\. <(cny|pbl)>/$1 <bt>$2<\/bt> $3 <edrg>$4 $5 $6 $7 $8<\/edrg>\, <pg>$9<\/pg>\. <$10>/gs;

  $TextBody=~s/([\.\,] [iI]n[\:\.]?) <edrg>([\w]+ [\w]+ [\w]+ [\w\- ]+\,)<\/edrg> $regx{editorSuffix}([\.]?) $regx{sAuthorString} $regx{sAuthorString}\, $regx{page}\. <(cny|pbl)>/$1 <bt>$2<\/bt> $3$4 <edrg>$5 $6<\/edrg>\, <pg>$7<\/pg>\. <$8>/gs;
  $TextBody=~s/([\.\,] [iI]n[\:\.]?) <edrg>([A-Z0-9][^A-Z\.\,<> ]+ [^A-Z\.\,<> ]+ [^A-Z\.\,<>]+\,)<\/edrg> $regx{editorSuffix}([\.]?) $regx{sAuthorString} $regx{sAuthorString}\, $regx{page}\. <(cny|pbl)>/$1 <bt>$2<\/bt> $3$4 <edrg>$5 $6<\/edrg>\, <pg>$7<\/pg>\. <$8>/gs;
  $TextBody=~s/([\.\,] [iI]n[\:\.]?) <edrg>([A-Z0-9][^A-Z\.\,<> ]+ [^A-Z\.\,<> ]+ [^A-Z\.\,<> ]+ [^A-Z\.\,<>]+\,)<\/edrg> $regx{editorSuffix}([\.]?) ([^<>]+?)\, $regx{page}\. <(cny|pbl)>/$1 <bt>$2<\/bt> $3$4 <edrg>$5<\/edrg>\, <pg>$6<\/pg>\. <$7>/gs;

  $TextBody=~s/([\.\,] [iI]n[\:\.]?) <edrg>([\w\-]+ [\w\-]+ [\w\-]+ [\w\- ]+\,)<\/edrg> $regx{editorSuffix}([\.]?) $regx{sAuthorString} $regx{firstName} $regx{sAuthorString} $regx{and} $regx{sAuthorString} $regx{firstName} $regx{sAuthorString}\, $regx{page}\. <(cny|pbl)>/$1 <bt>$2<\/bt> $3$4 <edrg>$5 $6 $7 $8 $9 $10 $11<\/edrg>\, <pg>$12<\/pg>\. <$13>/gs;
  $TextBody=~s/([\.\,] [iI]n[\:\.]?) <edrg>([\w\-]+ [\w\-]+ [\w\-]+ [\w\- ]+\,)<\/edrg> $regx{editorSuffix}([\.]?) $regx{sAuthorString} $regx{sAuthorString} $regx{and} $regx{sAuthorString} $regx{firstName} $regx{sAuthorString}\, $regx{page}\. <(cny|pbl)>/$1 <bt>$2<\/bt> $3$4 <edrg>$5 $6 $7 $8 $9 $10<\/edrg>\, <pg>$11<\/pg>\. <$12>/gs;

  #In <edrg>The philosophy of John Locke,</edrg> ed. P. Laslett. <cny>
  $TextBody=~s/([\.\,] [iI]n[\:\.]?) <edrg>([\w\-]+ [\w\-]+ [^<>]+\,)<\/edrg> $regx{editorSuffix}([\.]?) $regx{firstName} $regx{mAuthorFullSirName}\. <(cny|pbl)>/$1 <bt>$2<\/bt> $3$4 <edrg>$5 $6<\/edrg>\. <$7>/gs;
  $TextBody=~s/([\.\,] [iI]n[\:\.]?) <edrg>([\w\-]+ [\w\-]+ [^<>]+\,)<\/edrg> $regx{editorSuffix}([\.]?) $regx{mAuthorFullFirstName} $regx{mAuthorFullSirName}\. <(cny|pbl)>/$1 <bt>$2<\/bt> $3$4 <edrg>$5 $6<\/edrg>\. <$7>/gs;
  $TextBody=~s/([\.\,] [iI]n[\:\.]?) <edrg>([\w\-]+ [\w\-]+ [\w\-]+ [^<>]+\,)<\/edrg> $regx{editorSuffix}([\.]?) $regx{firstName} $regx{mAuthorFullSirName} $regx{mAuthorFullSirName}\. <(cny|pbl)>/$1 <bt>$2<\/bt> $3$4 <edrg>$5 $6 $7<\/edrg>\. <$8>/gs;

  $TextBody=~s/([\.\,] [iI]n[\:\.]?) <edrg>([^<>]+\,)<\/edrg> $regx{editorSuffix}([\.]?) $regx{firstName} $regx{mAuthorFullSirName} $regx{etal}([\.]?) <(cny|pbl)>/$1 <bt>$2<\/bt> $3$4 <edrg>$5 $6 $7<\/edrg>$8 <$9>/gs;

  #. In <edrg>Colonización Resistencia y Mestizaje en las Américas Siglos XVI-XX,</edrg> ed. Guillame Boccara, 47-82. <cny>
  $TextBody=~s/(\. [Ii]n[\:]? )<edrg>([A-Z][^<>\.]+ [a-zA-Z][^<>\.]+ [^<>\.]+\,)<\/edrg> $regx{editorSuffix}([\.]?) $regx{mAuthorFullFirstName} $regx{mAuthorFullSirName}\, $regx{page}\. <cny>/$1<bt>$2<\/bt> $3$4 <edrg>$5 $6<\/edrg>\, <pg>$7<\/pg>\. <cny>/gs;

  #. In Beschäftigte in der Globalisierungsfalle?, Hrsg. E. Ahlers, B. Kraemer und A. Ziegler, 19-36. <cny>
  $TextBody=~s/(\. [Ii]n[\:\.]? )([^<>]+?)\, $regx{editorSuffix}([\.\:]) $regx{firstName} $regx{mAuthorFullSirName}\, $regx{firstName} $regx{mAuthorFullSirName} $regx{and} $regx{firstName} $regx{mAuthorFullSirName}\, $regx{page}\. <(cny|pbl)>/$1<bt>$2<\/bt>\, $3$4 <edrg>$5 $6\, $7 $8 $9 $10 $11<\/edrg>\, <pg>$12<\/pg>\. <$13>/gs;
  $TextBody=~s/(\. [Ii]n[\:\.]? )([^<>]+?)\, $regx{editorSuffix}([\.\:]) $regx{firstName} $regx{mAuthorFullSirName} $regx{and} $regx{firstName} $regx{mAuthorFullSirName}\, $regx{page}\. <(cny|pbl)>/$1<bt>$2<\/bt>\, $3$4 <edrg>$5 $6\, $7 $8 $9 $10 $11<\/edrg>\, <pg>$12<\/pg>\. <$13>/gs;
  $TextBody=~s/(\. [Ii]n[\:\.]? )([^<>]+?)\, $regx{editorSuffix}([\.\:]) $regx{firstName} $regx{mAuthorFullSirName}, $regx{firstName} $regx{mAuthorFullSirName}\, $regx{page}\. <(cny|pbl)>/$1<bt>$2<\/bt>\, $3$4 <edrg>$5 $6\, $7 $8 $9 $10 $11<\/edrg>\, <pg>$12<\/pg>\. <$13>/gs;

  $TextBody=~s/([\.\, ]+[Ii]n[\:\. ]*)<i>([^<>]+?)<\/i>([\?\.\;\:\, ]+)$regx{editorSuffix}([\.\:]) $regx{firstName} ([^<>4-90]+?)\, $regx{page}\. <(cny|pbl)>/$1<bt><i>$2<\/i><\/bt>$3$4$5 <edrg>$6 $7<\/edrg>\, <pg>$8<\/pg>\. <$9>/gs;
  $TextBody=~s/([\.\, ]+[Ii]n[\:\. ]*)<i>([^<>]+?)<\/i>([\?\.\;\:\, ]+)$regx{editorSuffix}([\.\:]) ([\w]+[\.]?)\, $regx{page}\. <(cny|pbl)>/$1<bt><i>$2<\/i><\/bt>$3$4$5 <edrg>$6<\/edrg>\, <pg>$7<\/pg>\. <$8>/gs;

  #select(undef, undef, undef,  $sleep1);

  #Locke, J. (1689/1975). An Essay on Human Understanding. Ed. P.H. Nidditch, Oxford: Clarendon Press ****Put above check and add (Edited by)*****
  $TextBody=~s/\. (Hrgs[\.\:]|Ed[s]?[\.\:]|Editor[s]?:|[Ee]dited [bB]y|Ed[s]?[\.] [Bb]y) $regx{firstName}([\,]?) $regx{mAuthorString}([\.\,]) <(cny|pbl)>/\. $1 <edrg>$2$3 $4<\/edrg>$5 <$6>/gs;
  $TextBody=~s/\. (Hrgs[\.\:]|Ed[s]?[\.\:]|Editor[s]?:|[Ee]dited [bB]y|Ed[s]?[\.] [Bb]y) $regx{mAuthorString}([\,]?) $regx{firstName}([\.\,]) <(cny|pbl)>/\. $1 <edrg>$2$3 $4<\/edrg>$5 <$6>/gs;
  $TextBody=~s/\. (Hrgs[\.\:]|Ed[s]?[\.\:]|Editor[s]?:|[Ee]dited [bB]y|Ed[s]?[\.] [Bb]y) $regx{firstName} $regx{mAuthorString}([\,]?) $regx{firstName} $regx{mAuthorString} $regx{and} $regx{firstName}([\,]?) $regx{mAuthorString}([\.\,]) <(cny|pbl)>/\. $1 <edrg>$2 $3$4 $5 $6 $7 $8$9 $10<\/edrg>$11 <$12>/gs;
  $TextBody=~s/\. (Hrgs[\.\:]|Ed[s]?[\.\:]|Editor[s]?:|[Ee]dited [bB]y|Ed[s]?[\.] [Bb]y) $regx{firstName}([\,]?) $regx{sAuthorString}([\,]?) $regx{firstName}([\,]?) $regx{sAuthorString}([\.\,]) <(cny|pbl)>/\. $1 <edrg>$2$3 $4$5 $7$8 $9<\/edrg>$10 <$11>/gs;
  $TextBody=~s/\. (Hrgs[\.\:]|Ed[s]?[\.\:]|Editor[s]?:|[Ee]dited [bB]y|Ed[s]?[\.] [Bb]y) $regx{firstName}([\,]?) $regx{mAuthorString}([\,]?) $regx{and} $regx{firstName}([\,]?) $regx{mAuthorString}\. <(cny|pbl)>/\. $1 <edrg>$2$3 $4$5 $6 $7$8 $9<\/edrg>\. <$10>/gs;
  $TextBody=~s/\. (Hrgs[\.\:]|Ed[s]?[\.\:]|Editor[s]?:|[Ee]dited [bB]y|Ed[s]?[\.] [Bb]y) $regx{mAuthorString}([\,]?) $regx{firstName}([\,]?) $regx{and} $regx{mAuthorString}([\,]?) $regx{mAuthorString}([\.\,]) <(cny|pbl)>/\. $1 <edrg>$2$3 $4$5 $6 $7$8 $9<\/edrg>$10 <$11>/gs;


   $TextBody=~s/([ \.\,\;\:]+)([\w]+ [\w\-\,\: ]+)<\/aug>\. ([Ii]n[\:\.]|In[\:\.]?) <edrg>([A-Z][A-Za-z\-]+ [\w\-]+ [\w\- ]+)([\;\.]) $regx{sAuthorString}([\,]?) $regx{firstName}((?:(?!<[\/]?bib)(?!<[\/]?edrg).)*?)<\/edrg>/$1$2<\/aug>\. $3 <bt>$4<\/bt>$5 <edrg>$6$7 $8$9<\/edrg>/gs;
  $TextBody=~s/([ \.\,\;\:]+)([\w]+ [\w\-\,\: ]+)<\/aug>\. ([Ii]n[\:\.]|In[\:\.]?) <edrg>([A-Z][A-Za-z\-]+ [\w\-]+ [\w\- ]+)([\;\.]) $regx{firstName}([\,]?) $regx{sAuthorString}((?:(?!<[\/]?bib)(?!<[\/]?edrg).)*?)<\/edrg>/$1$2<\/aug>\. $3 <bt>$4<\/bt>$5 <edrg>$6$7 $8$9<\/edrg>/gs;

  #-----------------------------------------------------------------------------------------------------------
  #Löwenthal, Leo. 1990a. Individuum und Terror. 1946. In <i>Falsche Propheten. Studien zum Autoritarismus. Schriften </i><span style='color:red'>Bd. 3, Hrsg. Leo Löwenthal, 161-174</span>. Frankfurt a. M.: Suhrkamp.


  $TextBody=bookItalicEditorAfterEds(\$TextBody);
  #----------------------------------------------------------------------------------------------------------

  #Nock, S. L., Kingston, P. W., & Holian, L. M. (2008) The distribution of obligations. Intergenerational Caregiving. eds. A. Booth, A.C. Crouter, S.M. Bianchi, J.A. Seltzer, pp.&nbsp;279–316. The Urban Institute, Washington, DC.

  #print  $TextBody;exit;

  $TextBody=editorAfterEds(\$TextBody);


  $TextBody=bookItalicEditorWithoutEds(\$TextBody);
  # print  $TextBody;exit;

  #Noelle-Neumann, E. (2000). Öffentliche Meinung. In: E. Noelle-Neumann, W. Schulz & J. Wilke: Fischer Lexikon Publizistik Massenkommunikation (S. 366–382). Frankfurt am Main: Fischer.

 
  $TextBody=&editorWithoutEds(\$TextBody);

#  print   $TextBody;exit;

  #, 447-66</edrg>. <cny>
  $TextBody=~s/([\,\.] )([p]+[\. ]+|S[\. ]+)([0-9\-]+)<\/edrg>([\.\, \(]+)<(cny|pbl)>/<\/edrg>$1$2<pg>$3<\/pg>$4<$5>/gs;
  $TextBody=~s/([\,\.] )([0-9\-]+)<\/edrg>([\.\, \(]+)<(cny|pbl)>/<\/edrg>$1<pg>$2<\/pg>$3 <$4>/gs;
#----------------------------------------------------------------------------------------------------------------------------------------------------

  $TextBody=~s/<(aug|ia)>([^<>]+)\. ([^\.\,]+)<\/\1>\. ([Ii]n[:\.]? )<edrg>/<$1>$2<\/\1>\. $3\. $4<edrg>/gs;

  $TextBody=~s/<\/aug>\, $regx{firstName} <i>/\, $1<\/aug> <i>/gs;
  $TextBody=~s/ $regx{firstName}\. ([A-Z])<\/aug>\./ $1\. $2\.<\/aug>/gs;
  $TextBody=~s/\. ([^<>\.]*?) ([a-z]+) ([a-z]+) ([a-z]+)<\/aug>\./<\/aug>\. $1 $2 $3 $4\./gs;
  $TextBody=~s/\. ([^<>\.]*?) ([a-z]+) ([a-z]+) ([a-z]+)<\/aug>\,/<\/aug>\. $1 $2 $3 $4\,/gs;

  $TextBody=~s/\, $regx{firstName}<\/aug>\. ([A-Z\. ]+[\.]) /\, $1\. $2<\/aug> /gs;
  $TextBody=~s/\, $regx{firstName}\.<\/aug> ([A-Z\. ]+[\.]) /\, $1\. $2<\/aug> /gs;
  $TextBody=~s/\, $regx{firstName}<\/aug>\. $regx{particle}\, /\, $1\. $2<\/aug>\, /gs;
  $TextBody=~s/\, $regx{firstName}\.<\/aug>  $regx{particle}\, /\, $1\. $2<\/aug>\, /gs;
  $TextBody=~s/\, $regx{firstName}<\/aug>\. /\, $1\.<\/aug> /gs;
  $TextBody=~s/$regx{augString}\, $regx{firstName}\.\; $regx{augString} $regx{firstName}<\/aug>\. /$1\, $2\.\; $3 $4\.<\/aug> /gs;
  $TextBody=~s/\, $regx{firstName}\.\; ([^\.\,]+?)<\/aug>/\, $1\.<\/aug>\; $2/gs;

  $TextBody=~s/<bib([^<>]*?)>([$AuthorString ]+)([\,]?) $regx{firstName}([\.\;\:]?) <i>/<bib$1><aug>$2$3 $4<\/aug>$5 <i>/gs;
  $TextBody=~s/<bib([^<>]*?)>([$AuthorString ]+)([\,]?) $regx{firstName}([\.\;\:]?) /<bib$1><aug>$2$3 $4<\/aug>$5 /gs;
  $TextBody=~s/<bib([^<>]*?)><aug>([$AuthorString ]+)([\,]?) $regx{firstName}([\.\;\:]) ([A-Z][a-z]+) ([A-Za-z][a-z]+) ([A-Za-z][a-z]+)<\/aug>/<bib$1><aug>$2$3 $4<\/aug>$5 $6 $7 $8/gs;

  $TextBody=~s/([\.\,\? ]+)<pt>([Ii]n[\:\,\.]+ |In[\:\,\.]+)/$1$2<pt>/gs;
  $TextBody=~s/([\.\,\:\>\; ]+)(In[\:\. ]+|[Ii]n[\:\.]+ )(\s+)<edrg>((?:(?!<edrg>)(?!<pt>)(?!<bt>)(?!<bib)(?!<\/edrg>).)*)([\.\,\:\>\; ]+)([Ii]n)([\:\,\. ]+)((?:(?!<edrg>)(?!<bib)(?!<pt>)(?!<bt>)(?!<\/edrg>).)*?)<\/edrg>/$1$2$3$4$5$6$7<edrg>$8<\/edrg>/gs;

  $TextBody=~s/([a-zA-Z]+) in <edrg>([\w0-9 ]+)([\.\,]) /$1 in $2$3 <edrg>/gs;
  $TextBody=~s/ (and|Und|und|\&) $regx{firstName}([\.\,]) <pbl>([A-Za-z]+)<\/pbl>([\.\,]) \\newblock/ $1 $2$3 $4$5 \\newblock/gs;

  $TextBody=~s/<\/aug>\, $regx{firstName} <pbl>([A-Za-z]+)<\/pbl>/<\/aug>\, $1 $2/gs;
  $TextBody=~s/\, $regx{firstName}([\.\,]) <pbl>([A-Za-z]+)<\/pbl>([\.\,]) $regx{firstName}([\.\,]) /\, $1$2 $3$4 $5$6 /gs;

  $TextBody=~s/<bib([^<>]*?)><edrg>([^<>]*?)<\/edrg>([\.\,\; ]+)\($regx{year}([\.]?)\)/<bib$1><edrg>$2<\/edrg>$3\(<yr>$4<\/yr>$5\)/gs;
  $TextBody=~s/<bib([^<>]*?)><edrg>([^<>]*?)<\/edrg>([\.\,\; ]+)$regx{year}([\.\:\, ]+)/<bib$1><edrg>$2<\/edrg>$3<yr>$4<\/yr>$5/gs;
  $TextBody=~s/<\/(cny|pbl)>([\.\,\; ]+)$regx{year}([\.\)]?)<\/bib>/<\/$1>$2<yr>$3<\/yr>$4<\/bib>/gs;
  $TextBody=~s/<aug>([^<>]*?)\:((?:(?!<[\/]?aug>).)*?)<\/aug>/<aug>$1<\/aug>\:$2/gs;


  #<aug>The AASM Manual</aug> <yr>2007</yr> for the scoring of sleep and associated events. Rules, terminology and technical specifications. <pbl>American Academy of Sleep Medicine</pbl>, <cny>Westchester, IL, USA</cny>, <yr>2007</yr>
  $TextBody=~s/<bib([^<>]*?)><aug>([^<>\.]+?)<\/aug> <yr>$regx{year}<\/yr> ([a-z]+ [^<>\.]+)\. ((?:(?!<bib)(?!<\/bib)(?!<\/yr>).)+?) <yr>$regx{year}<\/yr>/<bib$1><aug>$2 $3 $4<\/aug>\. $5 <yr>$6<\/yr>/gs;

  #<aug>Ackerknecht EH. Anticontagionism between</aug> <yr>1821</yr> and
  $TextBody=~s/<bib([^<>]*?)><aug>([^<>]+?) ([A-Z\- ]+)\. ([\w ]+ [a-z]+)<\/aug> <yr>$regx{year}<\/yr> ([a-z]+) ((?:(?!<bib)(?!<\/bib)(?!<\/yr>).)+?) <yr>$regx{year}<\/yr>/<bib$1><aug>$2 $3<\/aug>\. $4 $5 $6 $7 <yr>$8<\/yr>/gs;


  $TextBody=~s/<bib([^<>]*?)>([A-Z\- \.]+) ([A-Za-z ]+)\, \`\`/<bib$1><aug>$2 $3<\/aug>\, \`\`/gs;
  $TextBody=~s/ \& ([A-Z][A-Za-z\- ]+)<\/aug>\, $regx{firstName}\. / \& $1\, $2\.<\/aug> /gs; 


  $TextBody=~s/<bib([^<>]*?)><aug>([^<>]+)\. ([A-Z]) ([a-z][^<>\.]*?)<\/aug>\, ([a-z]|An [A-Za-z][a-z]+|A [A-Za-z][a-z]+)/<bib$1><aug>$2\.<\/aug> $3 $4\, $5/gs;
  #Gert Regenspurg. Entwicklung von Zentralprozessoren aus Einheitsbausteinen, 
  $TextBody=~s/<bib([^<>]*?)><aug>([^<>]+)\. ([A-Z][a-z\-]+[w+]* \w+ \w+ \w+ \w+[^<>\.]*?)<\/aug>\, /<bib$1><aug>$2\.<\/aug> $3\, /gs;
  $TextBody=~s/<bib([^<>]*?)><aug>([^<>]+)\. ([A-Z][a-z][\w\-]+) ([a-z][^<>\.]*?)<\/aug>\: ([a-z]|An [A-Za-z][a-z]+|A [A-Za-z][a-z]+)/<bib$1><aug>$2\.<\/aug> $3 $4\: $5/gs;
  #<aug>E. Strohmaier and H. Shan. APEX-Map</aug>: a 
  $TextBody=~s/<bib([^<>]*?)><aug>([^<>]+)\. ([A-Z][A-Z]+\-[\w]+)<\/aug>\: ([a-z]|[AI]n [A-Za-z][a-z]+|A [A-Za-z][a-z]+)/<bib$1><aug>$2\.<\/aug> $3\: $4/gs;
  $TextBody=~s/<bib([^<>]*?)><aug>([^<>]+)\. ([A-Z][\w\-]+ \w+ \w+ \w+[^<>\.]*?)<\/aug>\: ([a-z]|[AI]n [A-Za-z][a-z]+|A [A-Za-z][a-z]+)/<bib$1><aug>$2\.<\/aug> $3\: $4/gs;

  #<bib id="bib119"><aug>Thomsom L. Hypnosis for Children with Elimination Disorders. In</aug>: <edrg>
  $TextBody=~s/<bib([^<>]*?)><aug>((?:(?!<[\/]?aug>).)*?)\. ([A-Z][a-z][\w\-]+) ([a-z][^<>]*?)\. ([Ii]n)<\/aug>\:/<bib$1><aug>$2\.<\/aug> $3 $4\. $5/gs;
  $TextBody=~s/ $regx{and} $regx{firstName}<\/aug>\. ([$AuthorString]+)\,/ $1 $2\. $3<\/aug>\,/gs;
  $TextBody=~s/ $regx{and} $regx{firstName}<\/aug>\. ([$AuthorString]+) ([A-Z0-9])/ $1 $2\. $3<\/aug> $4/gs;
  $TextBody=~s/\, ([A-Z\.\-]+)<\/aug> ([$AuthorString]+)\, $regx{and} ([A-Z\.\- ]+ [$AuthorString]+)([\,]?) /\, $1 $2\, $3 $4<\/aug>$5 /gs;
  $TextBody=~s/<\/aug>([a-z]*[\.\,]) ([^<>4-90\:\;\)\(]+?)\. \\newblock/$1 $2<\/aug>\. \\newblock/gs;
  $TextBody=~s/<bib([^<>]*?)><aug>([^<>]*)\, ([^<>]*?) ([Ii]n [A-Za-z][a-z]+)<\/aug>/<bib$1><aug>$2<\/aug>\, $3 $4/gs;
  $TextBody=~s/<bib([^<>]*?)><aug>([^<>]*)<\/aug>\, $regx{and} ([A-Z\.\- ]+ [$AuthorString]+) /<bib$1><aug>$2\, $3 $4<\/aug> /gs;
  $TextBody=~s/<bib([^<>]*?)><aug>([^<>]*?) $regx{and} ([A-Z\.\- ]+ [$AuthorString]+)([\,]) ([^<>]*?)<\/aug>/<bib$1><aug>$2 $3 $4<\/aug>$5 $6/gs;
  $TextBody=~s/<bib([^<>]*?)><aug>([^<>]*?) $regx{and} ([A-Z\.\- ]+ [$AuthorString]+)<\/aug> ([^<>\.\,\:\?\;0-9\[\`\'\"�]+?)( \(|[\.\:])/<bib$1><aug>$2 $3 $4 $5<\/aug>$6/gs;


  $TextBody=~s/<aug>$regx{firstName}<\/aug>\. ([$AuthorString ]+)\,/<aug>$1\. $2<\/aug>\,/gs;
  $TextBody=~s/\, $regx{firstName} ([$AuthorString ]+)\, ([\w0-9\-]+ [a-z][\w]+)<\/aug> /\, $1 $2<\/aug>\, $3 /gs;
  #, Cho CH<\/aug>, Wang M.
  $TextBody=~s/(\, |>)([$AuthorString ]+) $regx{firstName}<\/aug>\, ([$AuthorString ]+) $regx{firstName}\. /$1 $2 $3\, $4 $5<\/aug>\. /gs;
  $TextBody=~s/(\, |>)$regx{firstName} ([A-Z][^A-Z\.]+)\, ([A-Za-z\-]+ [A-Za-z\-]+[^.<>]*?)<\/aug>\, /$1$2 $3<\/aug>\, $4\, /gs;
  $TextBody=~s/(\, |>)$regx{firstName} ([A-Z][^A-Z\.]+ [A-Z][^A-Z\.]+)\, ([A-Za-z\-]+ [A-Za-z\-]+[^.<>]*?)<\/aug>\, /$1$2 $3<\/aug>\, $4\, /gs;

  $TextBody=~s/<aug>((?:(?!<[\/]?aug>).)*)\, $regx{firstName}<\/aug> ([$AuthorString]+) $regx{and} ([A-Z\-\. ]+\. [$AuthorString ]+)\,/<aug>$1\, $2 $3 $4 $5<\/aug>\,/gs;
  #and A. Rinnooy</aug> Kan, 
  $TextBody=~s/<aug>$regx{augString}([\,\.\: ]+) ([“]|\&quot\;)$regx{augString}<\/aug>/<aug>$1<\/aug>$2 $3$4/gs;

  $TextBody=~s/$regx{and} ([$AuthorString ]+)<\/aug> ([$AuthorString]+)\, ([“]|\&quot\;)/$1 $2 $3<\/aug>\, $4/gs;
  $TextBody=~s/\, ([$AuthorString ]+)<\/aug>\, $regx{firstName}\. ([“]|\&quot\;)/\, $1\, $2\.<\/aug> $3/gs;
  $TextBody=~s/$regx{and} ([A-Z\-\. ]+ [$AuthorString ]+)<\/aug> ([$AuthorString]+)\, ([“]|\&quot\;)/$1 $2 $3<\/aug>\, $4/gs;

  $TextBody=~s/<aug>$regx{firstName}\. ([$AuthorString ]+)\, ([A-Z][\w\-]+ [a-z][\w\-]+ [a-z][\w\-]+ [a-z]+[\w\-]+[^<>]*?)<\/aug> (\w)/<aug>$1\. $2<\/aug>\, $3 $4/gs;
  $TextBody=~s/<bib([^<>]*?)>([$AuthorString ]+) $regx{firstName} ([A-Z][\w]+ [A-Za-z]+[\. ]+)<pt>/<bib$1><aug>$2 $3<\/aug> $4<pt>/gs;


  #<bib id="ManySAT"><aug>Y.</aug> Hamadi and L. Sais. \newblock
  $TextBody=~s/<bib([^<>]*?)><aug>$regx{firstName}<\/aug>([\.\,]*?) ([$AuthorString ]+) $regx{and} $regx{firstName}([\.\,]) ([$AuthorString ]+)\. \\newblock/<bib$1><aug>$2$3 $4 $5 $6$7 $8<\/aug>\. \\newblock/gs;
  $TextBody=~s/<bib([^<>]*?)>$regx{firstName}\. ([$AuthorString ]+)\, ([A-Z][\w\-]+ [a-z][\w]+ [a-z][\w]+ [a-z]+[\w]+[^<>]*?)/<bib$1><aug>$2\. $3<\/aug>\, $4/gs;
  $TextBody=~s/<bib([^<>]*?)>$regx{firstName}\. ([$AuthorString ]+)\. \\newblock/<bib$1><aug>$2\. $3<\/aug>\. \\newblock/gs;
  $TextBody=~s/<bib([^<>]*?)>([$AuthorString ]+) ([$AuthorString ]+) ([$AuthorString ]+)\. \\newblock/<bib$1><aug>$2 $3 $4<\/aug>\. \\newblock/gs;
  $TextBody=~s/<bib([^<>]*?)>([$AuthorString ]+) ([$AuthorString ]+)\. \\newblock/<bib$1><aug>$2 $3<\/aug>\. \\newblock/gs;
  $TextBody=~s/<bib([^<>]*?)>$regx{augString} ([$AuthorString ]+)\. \\newblock/<bib$1><aug>$2 $3<\/aug>\. \\newblock/gs;
  $TextBody=~s/<bib([^<>]*?)>([^0-9\.\:]+?)\(([^<>0-9\.\,]+?)\)\./<bib$1><aug>$2\($3\)<\/aug>\./gs;
  $TextBody=~s/<bib([^<>]*?)>((?:(?!<[\/]?[a-z1]+>).)*?)([\s\.\,]*)\&lt\;<url>/<bib$1><aug>$2<\/aug>$3\&lt\;<url>/gs;
  $TextBody=~s/<bib([^<>]*?)>((?:(?!<[\/]?[a-z1]+>).)*?)([\s\.\,]*)<url>/<bib$1><aug>$2<\/aug>$3<url>/gs;


  $TextBody=~s/<\/aug>([\.\,]+) $regx{firstName}([\.\,]) <pbl>([A-Za-z]+)<\/pbl>([\.\,]) \\newblock/$1 $2$3 $4<\/aug>$5 \\newblock/gs;
  $TextBody=~s/<aug>$regx{augString}([\.\:\,\;])\s*\\newblock$regx{augString}<\/aug>/<aug>$1<\/aug>$2\\newblock$3/gs;


  $TextBody=~s/<aug>$regx{augString}$regx{firstName}\. ([$AuthorString ]+)\, $regx{firstName}\. ([A-Z][$AuthorString ]+[a-z])\. $regx{augString}<\/aug> ([\w])/<aug>$1$2\. $3\, $4\. $5<\/aug>\. $6 $7/gs;
  $TextBody=~s/<aug>$regx{augString}$regx{firstName}\. ([$AuthorString ]+)\, $regx{firstName}\. ([A-Z][$AuthorString ]+[a-z])\. $regx{augString}<\/aug>([\w])/<aug>$1$2\. $3\, $4\. $5<\/aug>\. $6$7/gs;


  #<aug>van Hal SJ, Paterson DL. New Gram-positive antibiotics</aug>:
  $TextBody=~s/<aug>((?:(?!<[\/]?aug>).)*)\, $regx{mAuthorString} $regx{firstName}\, $regx{mAuthorString} $regx{firstName}\. ([^<>\.]+?)<\/aug>(\:| [a-zA-Z]+|\. [a-zA-Z]+)/<aug>$1\, $2 $3\, $4 $5<\/aug>\. $6$7/gs;

  $TextBody=~s/<aug>((?:(?!<[\/]?aug>).)*)\, $regx{mAuthorString} $regx{firstName}\. ([A-Z][A-Za-z]+ [a-zA-Z][a-z]+)([^<>]+?)<\/aug>(\:| [a-zA-Z]+|\. [a-zA-Z]+)/<aug>$1\, $2 $3<\/aug>\. $4$5$6/gs;


  $TextBody=~s/<aug>((?:(?!<[\/]?aug>).)*)\, $regx{mAuthorString} $regx{firstName}\. ([\w\-\(\)0-9\_ ]+)<\/aug>(\:| [a-zA-Z]+|\. [a-zA-Z]+)/<aug>$1\, $2 $3<\/aug>\. $4$5/gs;
  $TextBody=~s/<aug>((?:(?!<[\/]?aug>).)*)\, $regx{mAuthorString} $regx{firstName}\, ([A-Z][A-Za-z]+ [a-zA-Z][a-z]+)([^<>]+?)\. ([^<>]+?)<\/aug>(\:| [a-zA-Z]+|\. [a-zA-Z]+)/<aug>$1\, $2 $3\, $4$5<\/aug>\. $6$7/gs;
  #, Holcomb, M</aug>. C.:


  $TextBody=~s/([\,\;\/] |>)([$AuthorString ]+)\, ([A-Z]|Ch)<\/aug>\. ([A-Z]|[A-Z]\. [A-Z])\.\:/$1$2\, $3\. $4\.<\/aug>\:/gs;
  $TextBody=~s/([\,\;\/] |>)([$AuthorString ]+)\, ([A-Z \.]+)<\/aug>\. (II|III)\:/$1$2\, $3\. $4<\/aug>\:/gs;

  $TextBody=~s/\, $regx{firstName}<\/aug>\. $regx{firstName}\, ([$AuthorString ]+)\, $regx{firstName}\.\:/\, $1\. $2\, $3\, $4\.<\/aug>\:/gs;

  $TextBody=~s/<aug>((?:(?!<[\/]?aug>).)*)\, $regx{mAuthorString} $regx{firstName}\, ([^<>\.\,]+)\. ([A-Z][A-Za-z]+ [a-zA-Z][a-z]+)([^<>]+?)<\/aug> /<aug>$1\, $2 $3\, $4<\/aug>\. $5$6 /gs;


  $TextBody=~s/<aug>$regx{augString}([\,]?) $regx{and} $regx{mAuthorString}\, $regx{firstName}\, $regx{mAuthorString}\, $regx{firstName}\, ([^<>]*?)<\/aug>/<aug>$1$2 <$3> $4\, $5\, $6\, $7\, $8<\/aug>/gs;
  $TextBody=~s/<aug>$regx{augString}([\,]?) $regx{and} $regx{mAuthorString}\, $regx{firstName}\.([\,]?) $regx{and} $regx{mAuthorString}\, $regx{firstName}\.<\/aug>/<aug>$1$2 <$3> $4\, $5\.$6 $7 $8\, $9\.<\/aug>/gs;
  $TextBody=~s/<aug>$regx{augString}([\,]?) $regx{and} ([$AuthorString ]+)\, $regx{firstName}\, ([^<>]*?)<\/aug>/<aug>$1$2 $3 $4\, $5<\/aug>\, $6/gs;
  $TextBody=~s/<$regx{and}>/$1/gs;

  $TextBody=~s/<aug>$regx{augString}([\,]?) $regx{firstName}\, $regx{and} $regx{firstName}<\/aug>\. ([$AuthorString ]+)\./<aug>$1$2 $3\, $4 $5\. $6<\/aug>\./gs;
  $TextBody=~s/ $regx{and} ([$AuthorString ]+)<\/aug>\, $regx{firstName} / $1 $2\, $3<\/aug> /gs;
  $TextBody=~s/<aug>$regx{augString} $regx{and} $regx{firstName}<\/aug> ([$AuthorString ]+)\. \\newblock/<aug>$1 $2 $3 $4<\/aug>\. \\newblock/gs;
  $TextBody=~s/<aug>$regx{augString}<\/aug> ([$AuthorString]+)\. \\newblock/<aug>$1 $2<\/aug>\. \\newblock/gs;
  $TextBody=~s/ $regx{and} $regx{firstName}<\/aug>\. ([$AuthorString ]+)([\,\.]) / $1 $2\. $3<\/aug>$4 /gs;
  $TextBody=~s/ $regx{and} $regx{firstName}<\/aug> ([$AuthorString ]+)([\,\.]) / $1 $2 $3<\/aug>$4 /gs;
  $TextBody=~s/<aug>$regx{augString}\, $regx{and} $regx{firstName}<\/aug> ([A-Za-z][a-z][a-z\-][a-z]+)([\:\,\;]) /<aug>$1\, $2 $3 $4<\/aug>$5 /gs;
  $TextBody=~s/([\,\;] |>)$regx{firstName}\. ([$AuthorString ]+)<\/aug>([\,\;]?) $regx{and} $regx{firstName}\. ([$AuthorString ]+)\./$1 $2\. $3$4 $5 $6\. $7<\/aug>\./gs;

  $TextBody=~s/(>|[\,\;\/] )([$AuthorString ]+) $regx{firstName}\.<\/aug> $regx{and} ([$AuthorString ]+) $regx{firstName}\. /$1$2 $3\. $4 $5 $6\.<\/aug> /gs;
  $TextBody=~s/<\/aug>([\,\;\.]) ([$AuthorString ]+)([\,\.]?) $regx{firstName} $regx{and} ([$AuthorString ]+)([\,\.]?) $regx{firstName} ([\(]?<yr>)/$1 $2$3 $4 $5 $6$7 $8<\/aug> $9/gs;

  #, J. Wang</aug>, J. Feng.
  #<aug>G. Cormode</aug>, S. Muthukrishnan.
  #$TextBody=~s/(\, |>)$regx{firstName}\. ([A-Z][a-z]+)<\/aug>\, $regx{firstName}\. ([A-Z][a-z]+)\./$1 $2\. $3\, $4\. $5<\/aug>\./gs;
  $TextBody=~s/(\, |>)$regx{firstName}\. ([$AuthorString ]+)<\/aug>\, $regx{firstName}\. ([$AuthorString ]+)\./$1 $2\. $3\, $4\. $5<\/aug>\./gs;
  $TextBody=~s/(\; |>)$regx{firstName}\. ([$AuthorString ]+)<\/aug>\; $regx{firstName}\. ([$AuthorString ]+)\./$1 $2\. $3\; $4\. $5<\/aug>\./gs;
  #R. Rastogi, and K. Shim. SPIRIT</aug>
  $TextBody=~s/(\, |\; |>)$regx{firstName}\. ([A-Z][$AuthorString ]+)([\,]?) $regx{and} $regx{firstName}\. ([A-Z][a-z]+)\. $regx{augString}<\/aug>([\.\,\:] )/$1$2\. $3$4 $5 $6\. $7<\/aug>\. $8$9/gs;
  $TextBody=~s/(\, |\; |>)$regx{firstName}\. ([A-Z][$AuthorString ]+)([\,]?) $regx{and} $regx{firstName}\. ([A-Z][$AuthorString ]+)\. $regx{augString}<\/aug>([\.\,\:] )/$1$2\. $3$4 $5 $6\. $7<\/aug>\. $8$9/gs;


  $TextBody=~s/(\, |>)$regx{firstName}\. ([A-Z][a-z]+)\. ([A-Z][a-z]+ [A-Z]a-z[a-z]+ [^<>]+?)<\/aug>([\,\;\.\:]) /$1$2\. $3<\/aug>\. $4$5 /gs;
  $TextBody=~s/(\, |>)$regx{firstName}\. ([A-Z][a-z]+)\. ([A-Z][a-z]+ [A-Za-z][a-z]+)<\/aug>([\,\;\.\:]) /$1$2\. $3<\/aug>\. $4$5 /gs;
  $TextBody=~s/(\, |>)$regx{firstName}\. ([$AuthorString ]+)\. ([A-Z][a-z]+ [A-Z]a-z[a-z]+ [^<>]+?)<\/aug>([\,\;\.\:]) /$1$2\. $3<\/aug>\. $4$5 /gs;
  $TextBody=~s/(\, |>)$regx{firstName}\. ([$AuthorString ]+)\. ([A-Z][a-z]+ [A-Za-z][a-z]+)<\/aug>([\,\;\.\:]) /$1$2\. $3<\/aug>\. $4$5 /gs;


  #, and M. C. Hsu. PrefixSpan</aug>:
  $TextBody=~s/(\, |\; )$regx{and} ([A-Z\- \.]+)\. ([A-Z][a-z]+)\. ([A-Z][a-z]+|[A-Z]+)<\/aug>: /$1$2 $3\. $4<\/aug>\. $5: /gs;
  $TextBody=~s/(\, |>)([A-Z\- \.]+)\. ([A-Z][a-z]+)\. ([A-Z][a-z]+|[A-Z]+)<\/aug>: /$1 $2\. $3<\/aug>\. $4: /gs;

  $TextBody=~s/<aug>$regx{augString}\, $regx{and} $regx{firstName} ([$AuthorString]+) ([A-Z][A-Za-z\-]+ [A-Z][A-Za-z\-]+ [^<>]+?)<\/aug>/<aug>$1\, $2 $3 $4<\/aug> $5/gs;

  #<aug>R. J</aug>. Bayardo Jr.
  $TextBody=~s/<aug>([A-Z]\. [A-Z\. \-]+)<\/aug>\. ([A-Za-z ]+)\. /<aug>$1\. $2<\/aug>\. /gs;
  #, J. Feng. Frequent Pattern Mining with Uncertain Data</aug>,
  $TextBody=~s/(\; |\, |>)$regx{firstName}\. ([A-Z][a-z]+)\, ([A-Z][a-z\']+ [a-zA-Z][a-z]+ [^<>]+?)<\/aug>([\,\:\.\;])/$1$2\. $3<\/aug>\, $4$5/gs;
  $TextBody=~s/(\; |\, |>)$regx{firstName}\. ([A-Z][a-z]+)\. ([A-Z][a-z\']+ [a-zA-Z][a-z]+ [^<>]+?)<\/aug>([\,\:\.\;])/$1$2\. $3<\/aug>\. $4$5/gs;
  $TextBody=~s/(\; |\, |>)$regx{firstName}\. ([A-Z][a-z]+)\. ([A-Z][a-z\']+ [a-zA-Z][a-z]+)<\/aug>([\,\:\.\;])/$1$2\. $3<\/aug>\. $4$5/gs;


  ####-------for comama end seperator ---------------------------------------------------
  $TextBody=~s/<bib([^<>]*?)><aug>((?:(?!<[\/]?aug>).)+)\, ([^\,<>]+?) $regx{instName} ([^<>\,]+?)<\/aug>/<bib$1><aug>$2<\/aug>\, $3 $4 $5/gs;
  $TextBody=~s/<bib([^<>]*?)><aug>((?:(?!<[\/]?aug>).)+)\, ([^\,<>]+?) $regx{instName} ([^<>\,]+?)<\/aug>/<bib$1><aug>$2<\/aug>\, $3 $4 $5/gs;
  $TextBody=~s/<aug>((?:(?!<[\/]?aug>).)+)\, $regx{instName} ([^\,<>]+?)<\/aug>/<aug>$1<\/aug>\, $2 $3/gs;
  $TextBody=~s/<aug>((?:(?!<[\/]?aug>).)+)([A-Z\-\.]+) ([$AuthorString ]+)\, ([A-Z\-\.]+) ([$AuthorString ]+)\, ([A-Za-z0-9\(\[][A-Za-z0-9\)\-]+) ([A-Za-z0-9\(\]][A-Za-z0-9\)\-]+) ([A-Za-z0-9\(\]][A-Za-z0-9\)\-]+) ((?:(?!<[\/]?aug>).)*?)<\/aug>/<aug>$1$2 $3\, $4 $5<\/aug>\, $6 $7 $8 $9/gs;


  $TextBody=~s/<aug>((?:(?!<[\/]?aug>).)+)\, ([A-Z\- \.]+?)\. ([$AuthorString ]+)\, ([A-Z\- \.]+?)<\/aug>\. ([$AuthorString ]+)\, ([^<>4-90]*)\, ([A-Z\- \.]+?)\. ([$AuthorString ]+)(\, |\. )/<aug>$1\, $2\. $3\, $4\. $5\, $6\, $7\. $8<\/aug>$9/gs;
  $TextBody=~s/<aug>((?:(?!<[\/]?aug>).)*)\, ([A-Z\- \.]+?)\. ([$AuthorString ]+)<\/aug>\, ([A-Z\- \.]+?)\. ([$AuthorString ]+)\, ([^<>4-90]*)\, ([A-Z\- \.]+?)\. ([A-Z][^<>\,\.]+)(\, |\. )/<aug>$1\, $2\. $3\, $4\. $5\, $6\, $7\. $8<\/aug>$9/gs;
  $TextBody=~s/<aug>((?:(?!<[\/]?aug>).)*)\, ([A-Z\- \.]+?)\. ([$AuthorString ]+)\, ([A-Z\- \.]+?)<\/aug>\. ([$AuthorString ]+)\, ([A-Z\- \.]+?)\. ([$AuthorString ]+)(\, |\. |\:)/<aug>$1\, $2\. $3\, $4\. $5\, $6\. $7<\/aug>$8/gs;
  $TextBody=~s/<aug>((?:(?!<[\/]?aug>).)*)\, ([A-Z\- \.]+?)\. ([$AuthorString ]+)\, ([A-Z\- \.]+?)<\/aug>\. ([$AuthorString ]+)(\, |\. )/<aug>$1\, $2\. $3\, $4\. $5<\/aug>$6/gs;


  $TextBody=~s/<aug>([A-Z\- \.]+?)\. ([$AuthorString ]+)\, ([A-Z\- \.]+?)\.<\/aug> ([$AuthorString ]+)(\, |\. )/<aug>$1\. $2\, $3\. $4<\/aug>$5/gs;
  $TextBody=~s/<aug>([A-Z\- \.]+?)\. ([$AuthorString ]+)\, ([A-Z\- \.]+?)<\/aug>\. ([$AuthorString ]+)(\, |\. )/<aug>$1\. $2\, $3\. $4<\/aug>$5/gs;
  $TextBody=~s/<aug>((?:(?!<[\/]?aug>).)*)\, ([A-Z\- \.]+?)\. ([$AuthorString ]+)\, ([A-Za-z0-9][^A-Z<> \.\,]+) ([^A-Z<> \.\,]+) ([^A-Z<>\.\,]+) ([^<>\.\,]+)<\/aug>(\: |\. |\, )/<aug>$1\, $2\. $3<\/aug>\, $4 $5 $6 $7$8/gs;
  $TextBody=~s/<aug>((?:(?!<[\/]?aug>).)*)\, ([A-Z\- \.]+?)\. ([$AuthorString ]+)\, ([A-Za-z0-9][^A-Z<> \.\,]+) ([^A-Z<> \.\,]+) ([^A-Z<>\.\,]+)<\/aug>(\: |\. |\, )/<aug>$1\, $2\. $3<\/aug>\, $4 $5 $6$7/gs;
  $TextBody=~s/<aug>((?:(?!<[\/]?aug>).)*)\, ([A-Z\- \.]+?)\. ([$AuthorString ]+)\, ([A-Za-z0-9][^A-Z<> \.\,]+)\, ([^A-Z<> \.\,]+)<\/aug>\,/<aug>$1\, $2\. $3<\/aug>\, $4\, $5\,/gs;
  $TextBody=~s/<aug>((?:(?!<[\/]?aug>).)*)\, ([A-Z\- \.]+?)\. ([$AuthorString ]+)\, ([A-Za-z0-9][^A-Z<> \.\,]+) ([^A-Z<> \.\,]+)<\/aug>\:/<aug>$1\, $2\. $3<\/aug>\, $4 $5:/gs;
  $TextBody=~s/<aug>((?:(?!<[\/]?aug>).)*)\, ([A-Z\- \.]+?)\. ([$AuthorString ]+)\, ([A-Za-z0-9][^A-Z<> \.\,]+) ([A-Z]?[^A-Z<> \.\,]+) ([A-Z]?[^A-Z<> \.\,]+) ([A-Z]?[^A-Z<>\.\,]+)<\/aug>/<aug>$1\, $2\. $3<\/aug>\, $4 $5 $6 $7/gs;
  $TextBody=~s/<aug>((?:(?!<[\/]?aug>).)*)\, ([A-Z\- \.]+?)\. ([A-Za-z][^\,<>\.\,]+)\, ([A-Za-z0-9][^A-Z<> \.\,]+) ([A-Z]?[^A-Z<> \.\,]+) ([A-Z]?[^A-Z<> \.\,]+) ([A-Z]?[^A-Z<>\.\,]+)<\/aug>/<aug>$1\, $2\. $3<\/aug>\, $4 $5 $6 $7/gs;
  $TextBody=~s/\, ([A-Za-z\(0-9][^\,<>]+) ([^\,<>]+) ([a-z]+[^\,<>]+) ([^\,<>]+) ([a-z]+[^\,<>]+)<\/aug>\:/<\/aug>\, $1 $2 $3 $4 $5\:/gs;
  $TextBody=~s/<aug>([A-Z\- \.]+?)\. ([$AuthorString ]+)\, ([A-Z][^A-Z<> \.\,]+) ([A-Za-z][^A-Z<> \.\,]+)<\/aug>\. /<aug>$1\. $2<\/aug>\, $3 $4\. /gs;
  $TextBody=~s/<aug>([A-Z\- \.]+?)\. ([$AuthorString ]+)\, ([A-Z][^A-Z<> \.\,]+) ([A-Za-z][^A-Z<> \.\,]+) ([A-Za-z][^A-Z<> \.\,]+)<\/aug>\. /<aug>$1\. $2<\/aug>\, $3 $4 $5\. /gs;

  #, Lacy JM and Logan BK. A multi-drug intoxication fatality involving Xyrem</aug>
  $TextBody=~s/(\, |>)([$AuthorString ]+) $regx{firstName}([\,]?) $regx{and} ([$AuthorString ]+) $regx{firstName}\. ([A-Z][a-z]+[^<>]+?|A [a-z]+[^<>]+?|A [A-Z][a-z]+[^<>]+?)<\/aug>/$1$2 $3$4 $5 $6 $7<\/aug>\. $8/gs;

  $TextBody=~s/<aug>([$AuthorString ]+) ([A-Z\- \.]+?)\. ([A-Z][^A-Z<> \.\,]+?) ([A-Za-z][^A-Z<> \.\,]+)<\/aug>\. /<aug>$1 $2\.<\/aug> $3 $4\. /gs;
  $TextBody=~s/<aug>([$AuthorString ]+) ([A-Z\- \.]+?)\. ([A-Z][^A-Z<> \.\,]+?) ([A-Za-z][^A-Z<> \.\,]+?) ([A-Za-z][^A-Z<> \.\,]+)<\/aug>\. /<aug>$1 $2\.<\/aug> $3 $4 $5\. /gs;
  $TextBody=~s/<aug>$regx{augString}\, ([^a-z][^<>\.\;\:\,]+) ([^<>\.\;\:\,]+) ([^<>\.\;\:\,]+) ([^A-Z<>\.\;\,]+)<\/aug>([\:\,]?) ([^A-Z<> \.\;\,]+)/<aug>$1<\/aug>\, $2 $3 $4 $5$6 $7/gs;
  #<aug>Chiba M, Kimura M, Asari S Exosomes secreted from human colorectal cancer cell lines contain mRNAs, microRNAs and natural antisense RNAs</aug>, that
  $TextBody=~s/<aug>$regx{augString}\, ([^a-z][^<>\.\;\:\,]+) ([^<>\.\;\:\,]+) ([^<>\.\;\:\,]+) ([^<>\.\;\:\,]+) ((?:(?!et al[\.]?)(?!<[\/]?aug>).)*?)([\,\:]) ([^<>]*?)<\/aug>([\:\,]?) ([^A-Z<> \.\;\,]+)/<aug>$1<\/aug>\, $2 $3 $4 $5 $6$7 $8$9 $10/gs;
  $TextBody=~s/<aug>$regx{augString}\, ([^a-z][^<>\.\;\:\,]+) ([a-z0-9\(\)\/\-]+) ([a-z0-9\(\)\/\-]+) ([a-z0-9\(\)\/\-]+)([\,\:]) ([^<>]*?)<\/aug>([\:\,]?) ([^A-Z<> \.\;\,]+)/<aug>$1<\/aug>\, $2 $3 $4 $5$6 $7$8 $9/gs;
  #<aug>C.P. Reis, Encapsulação de fármacos peptídicos pelo método de emulsificação/gelificação interna, PhD Thesis</aug>,
  $TextBody=~s/<aug>$regx{augString}\, ([^a-z][a-z][^<>\.\;\:\,]+ [a-z][^<>\.\;\:\,]+ [a-z][^<>\.\;\:\,]+ [a-z][^<>\.\;\:\,]+ [a-z][^<>]+)<\/aug>([\:\,]?) /<aug>$1<\/aug>\, $2$3 /gs;


  #VG Porekar, PEGylation 2 therapeutic proteins</aug>,
  $TextBody=~s/<aug>$regx{augString}\, ([^a-z][A-Za-z]+[a-z][^<>\.\;\:\,]+ [0-9]+ [a-z][a-z][^<>\.\;\:\,]+ [a-z][a-z][^<>]+)<\/aug>([\:\,]?) /<aug>$1<\/aug>\, $2$3 /gs;
  #<aug>Hwang EH, Das Sarma S, Dielectric function, screening</aug>
  $TextBody=~s/<aug>$regx{augString}\, ([$AuthorString ]+) ([A-Z\-\. ]+?)\, ([A-Z][a-z]+) ([a-z][a-z]+)\, ([a-z][a-z]+)<\/aug>/<aug>$1\, $2 $3<\/aug>\, $4 $5\, $6/gs;
  #<aug>Sheem, S. K. Low-Cost Fiber Optic Pressure Sensor. U.S</aug>.
  $TextBody=~s/<aug>([$AuthorString]+)\, ([A-Z\-\. ]+?)\. ([A-Z][a-z]+[A-Z\-a-z]+ [A-Za-z][a-z]+ [A-Za-z][a-z][a-z]+ [A-Z][a-z][a-z]+ [^<>]*?)<\/aug>/<aug>$1\, $2<\/aug>\. $3/gs;
  #<aug>ACS Publications Division Home Page. http</aug>
  $TextBody=~s/<aug>([^<>]*?)\. http<\/aug>/<aug>$1<\/aug>\. http/gs;
#-----------------------------------


  $TextBody=~s/<bib([^<>]*?)><aug>$regx{augString} $regx{firstName}\. ([A-Za-z0-9][^A-Z<> \.\,]+) ([A-Za-z0-9][^A-Z<> \.\,]+)<\/aug>\. ([^<>]*?)\. <cny>/<bib$1><aug>$2 $3<\/aug>\. $4 $5\. $6\. <cny>/gs;
  $TextBody=~s/<aug>((?:(?!<[\/]?aug>).)*)([\.\:\,\;]) ([A-Z][a-z]* [A-Z][\w\-]+ [A-Z][\w\-]+) ((?:(?!<[\/]?aug>).)+)<\/aug>([\w])/<aug>$1<\/aug>$2 $3 $4$5/gs;
  $TextBody=~s/<aug>$regx{augString}([\.\:\,\; ]+)([A-Z][\w\-]+ [A-Za-z][\w\-]+ [A-Za-z][\w\-]+ [A-Za-z]+[\w]+ [^<>]*?)<\/aug> ([A-Za-z])/<aug>$1<\/aug>$2$3 $4/gs;
  $TextBody=~s/(>|[\,\;] | [au]nd | \& | en )([$AuthorString]+) $regx{firstName} ([$AuthorString ]+)\. ([A-Z][a-z]+[a-z\-A-Z]* [a-z][a-z]+ [a-z][a-z]+ [^<>]+?)<\/aug>/$1$2 $3 $4<\/aug>\. $5/gs;
  $TextBody=~s/(>|[\,\;] | [au]nd | \& | en )([$AuthorString]+) $regx{firstName} ([$AuthorString ]+)\. ([A-Z][a-z]+[a-z\-A-Z]* [A-Za-z][A-Za-z\-]+ [A-Za-z][A-Za-z\-]+ [^<>]+?)<\/aug>/$1$2 $3 $4<\/aug>\. $5/gs;
  $TextBody=~s/(>|[\,\;] | [au]nd | \& | en )([$AuthorString]+) $regx{firstName} ([$AuthorString ]+)\. ([A-Z][a-z]+[a-z\-A-Z]* [A-Z][A-Za-z\-]+ [A-Z][A-Za-z\-]+)<\/aug>/$1$2 $3 $4<\/aug>\. $5/gs;


  $TextBody=~s/<aug>$regx{augString}<\/aug>\.\, ([$AuthorString ]+ [A-Z\-\. ])\.\, <i>/<aug>$1\.\, $2\.<\/aug>\, <i>/gs;
  $TextBody=~s/<aug>$regx{augString} $regx{and} $regx{firstName}<\/aug> ([$AuthorString ]+)\. \\newblock/<aug>$1 $2 $3 $4<\/aug>\. \\newblock/gs;
  $TextBody=~s/<aug>$regx{augString}<\/aug> ([$AuthorString]+)\. \\newblock/<aug>$1 $2<\/aug>\. \\newblock/gs;
  $TextBody=~s/<aug>$regx{augString} $regx{and} $regx{firstName}\. ([$AuthorString ]+)\. ([A-Z][$AuthorString]+[a-z]+)<\/aug> ([\w])/<aug>$1 $2 $3\. $4<\/aug>\. $5/gs;
  $TextBody=~s/<aug>$regx{augString} $regx{firstName}\. ([$AuthorString ]+)\. ([A-Z][$AuthorString]+[a-z]+)<\/aug> ([\w])/<aug>$1 $2\. $3<\/aug>\. $4 $5/gs;


  $TextBody=~s/<\/aug>([\, ]+)([Jj]r[\.]?|[Ss]r[\.]?|1st[\.]?|2nd[\.]?|3rd[\.]?|4th[\.]?|II[\.]|III[\.]|[vV]an der|[vV]an de|[vV]an den|du|de|da|von|van|dos)(\,|\. )/$1$2<\/aug>$3/gs;

  $TextBody=~s/<yr>([^<>]*?)<\/yr>\. <pt>((?:(?!<[\/]?bib>)(?!<[\/]?aug>)(?!<[\/]?yr>)(?!<[\/]?pt>).)*)<\/pt>((?:(?!<[\/]?bib>)(?!<[\/]?aug>)(?!<[\/]?yr>)(?!<[\/]?pt>).)*)<yr>([^<>]*?)<\/yr>/$1\. <pt>$2<\/pt>$3<yr>$4<\/yr>/gs;


  #and Melba M</aug>. Crawford.
  $TextBody=~s/(>|[\,\;] | [au]nd | \& | en )([$AuthorString]+) $regx{firstName}<\/aug>\. ([$AuthorString]+)\. /$1$2 $3\. $4<\/aug>\. /gs;

  $TextBody=~s/<\/aug> ([$AuthorString ]+)(\. |[\.\,]? [\(]?)<yr>/ <iax>$1<\/iax><\/aug>$2<yr>/gs; #******
  $TextBody=~s/([A-Z][^a-z\.\,\;\/ ]+[^a-z\.\,\;\/ ]+)\, $regx{firstName}\. <iax>([^<>]+?)<\/iax><\/aug>/$1\, $2\.<\/aug> $3/gs;
  $TextBody=~s/<[\/]?iax>//gs;

  $TextBody=~s/<aug>$regx{augString}([\,]?) $regx{firstName}\, $regx{and} $regx{firstName}<\/aug>\. ([$AuthorString ]+)\./<aug>$1$2 $3\, $4 $5\. $6<\/aug>\./gs;
  $TextBody=~s/ $regx{and} ([$AuthorString ]+)<\/aug>\, $regx{firstName} / $1 $2\, $3<\/aug> /gs;
  #*****************


  #  and F.</aug> Di Cunto, <i>
  $TextBody=~s/ $regx{and} $regx{firstName}<\/aug>\. ([$AuthorString ]+)([\,\.]) / $1 $2\. $3<\/aug>$4 /gs;
  $TextBody=~s/ $regx{and} $regx{firstName}<\/aug> ([$AuthorString ]+)([\,\.]) / $1 $2 $3<\/aug>$4 /gs;
  $TextBody=~s/<\/aug>([\,\;\.]) ([$AuthorString ]+)([\,\.]?) $regx{firstName} $regx{and} ([$AuthorString ]+)([\,\.]?) $regx{firstName} ([\(]?<yr>)/$1 $2$3 $4 $5 $6$7 $8<\/aug> $9/gs;


  #*check below code
  $TextBody=~s/<aug>$regx{augString}\, ([$AuthorString ]+) $regx{firstName}\. ([A-Z]+)<\/aug> <yr>([0-9]+)<\/yr>((?:(?!<[\/]?bib>)(?!<[\/]?aug>).)*)<yr>([0-9]+)<\/yr>/<aug>$1\, $2 $3<\/aug>\. $4 $5$6<yr>$7<\/yr>/gs;


#---------------------------------------------------------------------------------
  #$TextBody=~s/<aug>$regx{augString}, Simon MC Hypoxia-induced angiogenesis</aug>:
  $TextBody=~s/([\,\;\/]) ([$AuthorString ]+) $regx{firstName}<\/aug>([\,\/]) ([$AuthorString]+) $regx{firstName} ([^<>\.\;\,\:\(\[]+)/$1 $2 $3$4 $5 $6<\/aug> $7/gs;
  $TextBody=~s/<aug>([$AuthorString ]+) $regx{firstName}<\/aug>([\,\/]) ([$AuthorString]+) $regx{firstName} ([^<>\.\;\,\:\(\[]+)/<aug>$1 $2$3 $4 $5<\/aug> $6/gs;

  $TextBody=~s/([\,\;\/]) ([$AuthorString ]+) $regx{firstName} $regx{particleSuffix}<\/aug>([\,\/]) ([$AuthorString]+) $regx{firstName} ([^<>\.\;\,\:\(\[]+)/$1 $2 $3 $4$5 $6 $7<\/aug> $8/gs;
  $TextBody=~s/<aug>([$AuthorString ]+) $regx{firstName} $regx{particleSuffix}<\/aug>([\,\/]) ([$AuthorString]+) $regx{firstName} ([^<>\.\;\,\:\(\[]+)/<aug>$1 $2 $3$4 $5 $6<\/aug> $7/gs;
  $TextBody=~s/([\,\;\/]) $regx{particleSuffix} ([$AuthorString ]+) $regx{firstName}<\/aug>([\,\/]) ([$AuthorString]+) $regx{firstName} ([^<>\.\;\,\:\(\[]+)/$1 $2 $3 $4$5 $6 $7<\/aug> $8/gs;
  $TextBody=~s/<aug>$regx{particleSuffix} ([$AuthorString ]+) $regx{firstName}<\/aug>([\,\/]) ([$AuthorString]+) $regx{firstName} ([^<>\.\;\,\:\(\[]+)/<aug>$1 $2 $3$4 $5 $6<\/aug> $7/gs;


  #select(undef, undef, undef,  $sleep1);

  $TextBody=~s/([\,\;\/]) ([$AuthorString ]+) $regx{firstName}<\/aug>([\,\/]) ([$AuthorString]+) $regx{firstName} $regx{particleSuffix} ([^<>\.\;\,\:\(\[]+)/$1 $2 $3$4 $5 $6 $7<\/aug> $8/gs;
  $TextBody=~s/<aug>([$AuthorString ]+) $regx{firstName}<\/aug>([\,\/]) ([$AuthorString]+) $regx{firstName} $regx{particleSuffix} ([^<>\.\;\,\:\(\[]+)/<aug>$1 $2$3 $4 $5 $6<\/aug> $7/gs;
  $TextBody=~s/([\,\;\/]) ([$AuthorString ]+) $regx{firstName}<\/aug>([\,\/]) $regx{particleSuffix} ([$AuthorString]+) $regx{firstName} ([^<>\.\;\,\:\(\[]+)/$1 $2 $3$4 $5 $6 $7<\/aug> $8/gs;
  $TextBody=~s/<aug>([$AuthorString ]+) $regx{firstName}<\/aug>([\,\/]) $regx{particleSuffix} ([$AuthorString]+) $regx{firstName} ([^<>\.\;\,\:\(\[]+)/<aug>$1 $2$3 $4 $5 $6<\/aug> $7/gs;

  $TextBody=~s/([\,\;\/]) ([$AuthorString ]+) $regx{firstName} $regx{particleSuffix}<\/aug>([\,\/]) ([$AuthorString]+) $regx{firstName} $regx{particleSuffix} ([^<>\.\;\,\:\(\[]+)/$1 $2 $3 $4$5 $6 $7 $8<\/aug> $9/gs;
  $TextBody=~s/<aug>([$AuthorString ]+) $regx{firstName} $regx{particleSuffix}<\/aug>([\,\/]) ([$AuthorString]+) $regx{firstName} $regx{particleSuffix} ([^<>\.\;\,\:\(\[]+)/<aug>$1 $2 $3$4 $5 $6 $7<\/aug> $8/gs;
  $TextBody=~s/([\,\;\/]) ([$AuthorString ]+) $regx{firstName} $regx{particleSuffix}<\/aug>([\,\/]) $regx{particleSuffix} ([$AuthorString]+) $regx{firstName} ([^<>\.\;\,\:\(\[]+)/$1 $2 $3 $4$5 $6 $7 $8<\/aug> $9/gs;
  $TextBody=~s/<aug>([$AuthorString ]+) $regx{firstName} $regx{particleSuffix}<\/aug>([\,\/]) $regx{particleSuffix} ([$AuthorString]+) $regx{firstName} ([^<>\.\;\,\:\(\[]+)/<aug>$1 $2 $3$4 $5 $6 $7<\/aug> $8/gs;


  #<aug>J. Aczél, J. K.</aug> Chung:
  $TextBody=~s/([\,\;\/] |>)$regx{firstName}\. ([$AuthorString ]+)\, $regx{firstName}<\/aug>\. ([$AuthorString]+)\:/$1$2\. $3\, $4\. $5<\/aug>\:/gs;

  #, Pacht E, J</aug>. Gadek W Davis,
  #, Aldouby Y, A.J</aug>. Domb A. Hoffman,
  $TextBody=~s/([\,\;\/] |>)([$AuthorString ]+) $regx{firstName}\, $regx{firstName}<\/aug>\. ([$AuthorString ]+) $regx{firstName}([\.]?) ([$AuthorString ]+)([\,]) /$1$2 $3\, $4\. $5 $6$7 $8<\/aug>$9 /gs;
  #<aug>Shoyele SA, N.</aug> Sivadas SA Cryan,
  $TextBody=~s/([\,\;\/] |>)([$AuthorString ]+) $regx{firstName}\, $regx{firstName}\.<\/aug> ([$AuthorString ]+) $regx{firstName}([\.]?) ([$AuthorString ]+)([\,]) /$1$2 $3\, $4\. $5 $6$7 $8<\/aug>$9 /gs;
  #, Med Mina, K. Ask, J. Gauldie
  $TextBody=~s/([\,\;\/] |>)([$AuthorString ]+) $regx{firstName}\, $regx{firstName}<\/aug>\. ([$AuthorString ]+)\, $regx{firstName}([\.]?) ([$AuthorString ]+)([\,]) /$1$2 $3\, $4\. $5\, $6$7 $8<\/aug>$9 /gs;
  $TextBody=~s/([\,\;\/] |>)([$AuthorString ]+) $regx{firstName}\, $regx{firstName}\,<\/aug> ([$AuthorString ]+)\, $regx{firstName}([\.]?) ([$AuthorString ]+)([\,]) /$1$2 $3\, $4\. $5\, $6$7 $8<\/aug>$9 /gs;
  #</aug>, G.R. Beck MH Cho
  $TextBody=~s/<\/aug>\, $regx{firstName} ([$AuthorString ]+)([\,]?) $regx{firstName}([\.]?) ([$AuthorString ]+)([\,]) /\, $1 $2$3 $4$5 $6<\/aug>$7 /gs;
  #, Med Mina, K</aug>. Ask, J. Gauldie,
  $TextBody=~s/([\,\;\/] |>)([$AuthorString]+) ([$AuthorString]+)\, $regx{firstName}<\/aug>\. ([$AuthorString ]+)\, $regx{firstName}([\.]?) ([$AuthorString ]+)([\,]) /$1$2 $3\, $4\. $5\, $6$7 $8<\/aug>$9 /gs;

  #, Haged Poorn, H.W</aug>. Frijlink,
  $TextBody=~s/([\,\;\/] |>)([$AuthorString]+) ([$AuthorString]+)\, $regx{firstName}<\/aug>\. ([$AuthorString ]+)\, /$1$2 $3\, $4\. $5<\/aug>\, /gs;
  #; Meteos, J. J.</aug>; Sänchez Crespo, M.
  #Meteos, J. J.</aug>; Sanchez Crespo, M.
  $TextBody=~s/([\,\;\/] |>)([$AuthorString ]+), $regx{firstName}\.<\/aug>\; ([$AuthorString ]+)\, $regx{firstName}\. /$1$2\, $3\; $4\, $5<\/aug>\. /gs;

  $TextBody=~s/([\,\;\/] |>)$regx{firstName}\. ([$AuthorString ]+) $regx{firstName}<\/aug>\. ([$AuthorString ]+)([\,]) /$1$2\. $3 $4\. $5<\/aug>$6 /gs;
  $TextBody=~s/([\,\;\/] |>)$regx{firstName}\. ([$AuthorString ]+) $regx{firstName}\.<\/aug> ([$AuthorString ]+)([\,]) /$1$2\. $3 $4\. $5<\/aug>$6 /gs;
  #, L.-q. Zhang, K.</aug> Shi,
  $TextBody=~s/([\,\;\/] |>)$regx{firstName}\-([a-z])\. ([$AuthorString ]+)\, $regx{firstName}\.<\/aug> ([$AuthorString ]+)([\,]) /$1$2\-$3\. $4\, $5\. $6<\/aug>$7 /gs;


  #J.A. Teixeira, V.M.</aug> Balcão,
  #<aug>McInnes D</aug>, Bollen J. <i>
  $TextBody=~s/([\,\;\/] |>)([$AuthorString ]+)$regx{firstName}<\/aug>\, ([$AuthorString ]+) $regx{firstName}\. <i>/$1$2$3\, $4 $5<\/aug>\. <i>/gs;
  #$TextBody=~s/([\,\;\/] |>)$regx{firstName}\. ([$AuthorString ]+)\, $regx{firstName}\.<\/aug> ([A-Z][^\(\.\,\/\;\?0-9]+)([\,]) /$1$2\. $3\, $4\. $5<\/aug>$6 /gs;
  $TextBody=~s/\, ([^<>\;\,\.]+?) $regx{firstName}\.<\/aug>\, ([$AuthorString ]+) $regx{firstName}\. /\, $1 $2\.\, $3 $4\.<\/aug> /gs;
  $TextBody=~s/\, ([^<>\;\,\.]+?) $regx{firstName}<\/aug>\, ([$AuthorString ]+) $regx{firstName}\. /\, $1 $2\, $3 $4\.<\/aug> /gs;
  $TextBody=~s/\; ([$AuthorString ]+)\, $regx{firstName}\.<\/aug>\; ([$AuthorString ]+)\, $regx{firstName}\.\; /\; $1\, $2\.\; $3\, $4\.<\/aug>\; /gs;
  $TextBody=~s/\; ([^<>\;\,\.]+?)\, $regx{firstName}\.<\/aug>\; ([$AuthorString ]+)\, $regx{firstName}\.\; /\; $1\, $2\.\; $3\, $4\.<\/aug>\; /gs;
  $TextBody=~s/\; ([^<>\;\,\.]+?)\, $regx{firstName}\.<\/aug>\; ([$AuthorString ]+)\, $regx{firstName}\. /\; $1\, $2\.\; $3\, $4\.<\/aug> /gs;
  $TextBody=~s/<aug>([$AuthorString]+)<\/aug>\, $regx{firstName}\. /<aug>$1\, $2<\/aug>\. /gs;  
  $TextBody=~s/<aug>([$AuthorString]+) ([$AuthorString]+)<\/aug>\, $regx{firstName}\. /<aug>$1 $2\, $3<\/aug>\. /gs; 
  $TextBody=~s/<bib([^<>]*?)>([A-Z][a-z]+) and ([A-Z][a-z]+)\./<bib$1><aug>$2 and $3<\/aug>\./gs;
#---------------------------------------------------------------------------------
  #print $TextBody;exit;


  #, Banks M</aug>. Hepatitis E:
  #, J. Wang</aug>, J. Feng.
  #<aug>G. Cormode</aug>, S. Muthukrishnan.
  $TextBody=~s/(\, |>)$regx{firstName}\. ([A-Z][a-z]+)<\/aug>\, $regx{firstName}\. ([A-Z][a-z]+)\./$1$2\. $3\, $4\. $5<\/aug>\./gs;
  $TextBody=~s/(\, |>)$regx{firstName}\. ([$AuthorString ]+)<\/aug>\, $regx{firstName}\. ([$AuthorString ]+)\./$1$2\. $3\, $4\. $5<\/aug>\./gs;
  $TextBody=~s/(\; |>)$regx{firstName}\. ([$AuthorString ]+)<\/aug>\; $regx{firstName}\. ([$AuthorString ]+)\./$1$2\. $3\; $4\. $5<\/aug>\./gs;

  $TextBody=~s/<aug>([$AuthorString ]+) $regx{firstName} ([A-Za-z][a-z][a-z\-][a-z\-A-Z]+ [A-Za-z][a-z][a-z\-A-Z]+ [a-z][a-z]+ [A-Za-z][a-z\-A-Z]+[\,\.]? [^<>]+?)<\/aug>/<aug>$1 $2<\/aug> $3/gs;
  #, B. Forbes, Long-term stability</aug>, biocompatibility
  #, S. Tiwari, Colloidal nanocarriers </aug>: a review
  $TextBody=~s/([\,\;\/] |>)$regx{firstName} ([$AuthorString ]+)\, ([A-Za-z][a-z][a-z\-][a-z\-A-Z]+ [A-Za-z][a-z][a-z][^<> \.\;\,\:]+[ ]?)<\/aug>([\,\:]) ([a-z0-9]+|<)/$1$2 $3<\/aug>\, $4$5 $6/gs;

  #<aug>Clinical and Laboratory Standards Institute. Methods for Dilution Antimicrobial Susceptibility Tests for Bacteria That Grow Aerobically-Seventh Edition</aug>
  $TextBody=~s/<aug>([A-Z][a-z][a-z\-][a-z\-A-Z]+) ([A-Za-z\-]+) ([A-Za-z\-]+) ([A-Za-z\-]+) ([^<>\.]+)\. $regx{augString}<\/aug>/<aug>$1 $2 $3 $4 $5<\/aug>\. $6/gs;

  $TextBody=~s/<aug>([A-Z][a-z][a-z\-][a-z\-A-Z]+) ([A-Za-z\-]+) ([A-Za-z\-]+) ([A-Za-z\-]+)\. $regx{augString}<\/aug>/<aug>$1 $2 $3 $4<\/aug>\. $5/gs;
  #<aug>InÃªs Lynce. Propositional satisfiability</aug>:

  $TextBody=~s/([$AuthorString]+) ([$AuthorString]+)\. ([A-Z][a-z]+[\-a-zA-z]* [a-z][a-z]+)<\/aug>([\:\,\.]) ([A-Z][a-z]+)/$1 $2<\/aug>\. $3$4 $5/gs;
  $TextBody=~s/(>|[\,\;] | [au]nd | \& | en )([$AuthorString]+) $regx{firstName}<\/aug>\. $regx{firstName} ([$AuthorString]+)\, <yr>/$1$2 $3\. $4 $5<\/aug>\, <yr>/gs;

  #<aug>Zielinska B. Donahue TL. 3D finite element model of meniscectomy</aug>:
  #$TextBody=~s/<aug>$regx{augString}\. ([A-Za-z0-9\-]+ \w+ \w+ [^<>\.]+?)<\/aug>\: ([a-z]+)/<aug>$1<\/aug>\. $2\: $3/gs;
  $TextBody=~s/<aug>$regx{augString} $regx{firstName}\. $regx{mAuthorString} $regx{firstName}\. ([A-Za-z0-9\-]+ \w+ \w+ [^<>\.]+?)<\/aug>\: ([a-z]+)/<aug>$1 $2\. $3 $4<\/aug>\. $5\: $6/gs;
  $TextBody=~s/<aug>$regx{mAuthorString} $regx{firstName}\. ([A-Za-z0-9\-]+ \w+ \w+ [^<>\.]+?)<\/aug>\: ([a-z]+)/<aug>$1 $2<\/aug>\. $3\: $4/gs;

  #and William B</aug>. Bonvillian.
  $TextBody=~s/(>|[\,\;] | [au]nd | \& | en )([$AuthorString]+) $regx{firstName}<\/aug>\. ([$AuthorString]+)\. ([A-Z][a-z]+)/$1$2 $3\. $4<\/aug>\. $5/gs;
  $TextBody=~s/ $regx{firstName}<\/aug>\. ([$AuthorString]+)\, $regx{and} ([$AuthorString]+) ([$AuthorString]+)\. ([A-Z][a-z]* [A-Za-z][a-z\-A-Z]+ [^<>]+?)/ $1\. $2\, $4 $5<\/aug>\. $6/gs;

  #, J. Oberdörster, Nanotoxicology </aug>: an
  $TextBody=~s/([\,\;\/] |>)$regx{firstName} ([A-Z][^\.\:\;\/<>\(\)0-9]+)\, ([A-Za-z][a-z][a-z\-][a-z\-A-Z]+[ ]?)<\/aug>([\,\:]) ([a-z0-9]+|<)/$1$2 $3<\/aug>\, $4$5 $6/gs;
 
 # $TextBody=~s/([\,\;\/] |>)$regx{firstName} ([$AuthorString ]+)\, ([A-Za-z][a-z][a-z\-][a-z\-A-Z]+ [A-Za-z][a-z][a-z][^<> \.\;\,\:]+[ ]?)<\/aug>: ([a-z0-9]+)/$1$2 $3<\/aug>\, $4: $5/gs;


  #, Thum T Exosomes</aug>: new
  $TextBody=~s/([\,\;\/] |>)([$AuthorString ]+) $regx{firstName} ([A-Z][^<> \.\;\,\:]+[ a-zA-Z0-9]*?)<\/aug>\: ([a-z0-9]+|<)/$1$2 $3<\/aug> $4\: $5/gs;
  #, Pegtel DM Exosomes: Fit 
  $TextBody=~s/([\,\;\/] |>)([$AuthorString ]+) $regx{firstName} ([A-Za-z][a-z][a-z\-][a-z\-A-Z]+ [A-Za-z][a-z][a-z]+ [^<> \.\;\,\:]+[ a-zA-Z0-9]*?)<\/aug>\: ([A-Za-z0-9]+|<)/$1$2 $3<\/aug> $4\: $5/gs;
  #en Vijay K</aug>. Bhargava, <yr>
  $TextBody=~s/(>|[\,\;] | [au]nd | \& | en )([$AuthorString ]+) $regx{firstName}<\/aug>\. ([$AuthorString]+)\, <yr>/$1$2 $3\. $4<\/aug>\, <yr>/gs;
  #$TextBody=~s/([\,\;\/] |>)([$AuthorString ]+) $regx{firstName} ([A-Za-z][a-z][a-z\-][a-z]+)<\/aug>([\:\,\;]) ([A-Za-z0-9]+|<)/$1$2 $3<\/aug> $4$5 $6/gs;
  #, and Z.W.</aug> Cheng,
  $TextBody=~s/<aug>$regx{augString}\, $regx{and} $regx{firstName}<\/aug> ([A-Za-z][a-z][a-z\-][a-z]+)([\:\,\;]) /<aug>$1\, $2 $3 $4<\/aug>$5 /gs;

  $TextBody=~s/([\,\;\/] |>)([$AuthorString ]+) $regx{firstName} ([A-Za-z][a-z][a-z\-][a-z]+[\-\/a-zA-Z]+)<\/aug>([\:\,\;]) ([A-Za-z0-9]+)/$1$2 $3<\/aug> $4$5 $6/gs;
  #<aug>OLeary C. Vitamin C does little to prevent winter cold. The West Australian. Forthcoming</aug>
  $TextBody=~s/([\,\;\/] |>)([$AuthorString ]+) $regx{firstName}\. ([A-Za-z][a-z][\-\/a-zA-Z]+ [A-Za-z]+ [a-z]+ [a-z]+ [^<> \.\;\,\:]+ [^<>]+)<\/aug>([\.\,\:\;]?) /$1$2 $3\.<\/aug> $4$5 /gs;

  #<aug>Atherton, J. Behaviour modification [Internet]</aug>
  $TextBody=~s/([\,\;\/] |>)$regx{mAuthorString}([\,]?) $regx{firstName}\. ([A-Za-z][a-z]+ [a-z][a-z]+[\.\,\:\;]? \[[^<>]+\])<\/aug>([\.\,\:\;]?) /$1$2$3 $4<\/aug>\. $5$6 /gs;
  #<aug>Marano HE. Making of a perfectionist. Psychol Today</aug>.
  $TextBody=~s/([\,\;\/] |>)$regx{mAuthorString} $regx{firstName}\. ([A-Za-z][a-z]+ [a-z]+ [a-z]+ [a-z]+[\.\,\:\;]? [^<>]+)<\/aug>([\.\,\:\;]?) /$1$2 $3\.<\/aug> $4$5 /gs;


  #<aug>Johnson A. Week three</aug>:
  $TextBody=~s/([\,\;\/] |>)$regx{mAuthorString} $regx{firstName}\. ([A-Za-z][a-z]+ [a-z]+)<\/aug>\: ([A-Za-z][a-z]+) /$1$2 $3\.<\/aug> $4\: $5 /gs;
  #<aug>Glaser R, Bond L, editors. Testing</aug>:
  $TextBody=~s/([\,\;\/] |>)([^<>]*?) $regx{editorSuffix} ([^<>]*?)<\/aug>/$1$2 $3<\/aug> $4/gs;

  #, Pandolfi PP A</aug> ceRNA
  $TextBody=~s/([\,\;\/] |>)$regx{mAuthorString} $regx{firstName} A<\/aug> ([a-z0-9]+)/$1$2 $3<\/aug> A $4/gs;
  $TextBody=~s/([\,\;\/] |>)$regx{mAuthorString} ([A-Z][\. ]*[A-Z]+\.) A<\/aug> ([A-Za-z0-9]+)/$1$2 $3<\/aug> A $4/gs;
  $TextBody=~s/([\,\;\/] |>)$regx{mAuthorString} $regx{firstName} ([A-Z][A-Z]+)<\/aug> ([a-z0-9]+)/$1$2 $3<\/aug> $4 $5/gs;
  $TextBody=~s/([\,\;\/] |>)$regx{mAuthorString} $regx{firstName} ([A-Z][a-z]+ [a-z]+)<\/aug>([\:\,\.]) ([A-Z0-9a-z]+)/$1$2 $3<\/aug> $4$5 $6/gs;
  #$TextBody=~s/<aug>$regx{augString}\, $regx{firstName} $regx{mAuthorString}\, $regx{firstName}<\/aug> $regx{mAuthorString}\,/<aug>$1\, $2 $3\, $4 $5<\/aug>\,/gs;
  $TextBody=~s/\, $regx{firstName}<\/aug>\. $regx{firstName}\. /\, $1\. $2<\/aug>\. /gs;
  $TextBody=~s/\, $regx{firstName}\.<\/aug> $regx{firstName}\. /\, $1\. $2<\/aug>\. /gs;
  $TextBody=~s/\, $regx{firstName}\.<\/aug> $regx{firstName}\.\; /\, $1\. $2\.<\/aug>\; /gs;


  #, and Z.W.</aug> Cheng,
  $TextBody=~s/<aug>$regx{augString}\, $regx{and} $regx{firstName}<\/aug> ([A-Za-z][a-z][a-z\-][a-z]+)([\:\,\;]) /<aug>$1\, $2 $3 $4<\/aug>$5 /gs;
  $TextBody=~s/([\,\;] |>)$regx{firstName}\. $regx{mAuthorString}<\/aug>([\,\;]?) $regx{and} $regx{firstName}\. $regx{mAuthorString}\./$1 $2\. $3$4 $5 $6\. $7<\/aug>\./gs;
  #, Mullington J</aug> and Pollmcher T.
  $TextBody=~s/(\, |>)$regx{mAuthorString} $regx{firstName}<\/aug> $regx{and} $regx{mAuthorString} $regx{firstName}\. /$1$2 $3 $4 $5 $6<\/aug>\. /gs;
  $TextBody=~s/ $regx{firstName}<\/aug>\.([\,\;\:]) / $1\.<\/aug>$2 /gs;
  #<aug>Saussure, F.</aug> de
  $TextBody=~s/<\/aug>([\.\,]?) $regx{particleSuffix}( [\(]|[\.\:] )/$1 $2<\/aug>$3/gs;

  $TextBody=~s/<bib([^<>]*?)><aug>([A-Z\.\- ]+)<\/aug>\. ([$AuthorString ]+)\,/<bib$1><aug>$2\. $3<\/aug>\,/gs;
  $TextBody=~s/ ([A-Z\- ]+)<\/aug>\. / $1\.<\/aug> /gs;
  $TextBody=~s/\,<\/edrg>/<\/edrg>\,/gs;

  $TextBody=~s/ \\newblock (In[\:\. ]+|[Ii]n[\:\.]+ )<edrg>/ $1<edrg>/gs;
  $TextBody=~s/([\.\,] [iI]n[\:\.]?) ((?:(?!<[\/]?bib)(?!<[\/]?edrg)(?!<[\/]?bt).)+)([\,\.]?) ([eE]d[\.]?) by ([^<>]+?) \(<(pbl|cny)>/$1 <bt>$2<\/bt>$3 $4 by <edrg>$5<\/edrg> \(<$6>/gs;
  $TextBody=~s/<aug>$regx{augString} \(([hH]ttp|www|[Ff]tp)<\/aug>/<aug>$1<\/aug> \($2/gs;
  $TextBody=~s/<\/aug>([\.\,\;]? et[\.]? al[\.]?)([\:]?)/$1<\/aug>$2/gs;

  $TextBody=~s/<bib([^<>]*?)>((?:(?!<bib)(?!<\/bib).)*?)\(<yr>$regx{year}<\/yr>\/$regx{year}\)((?:(?!<bib)(?!<\/bib).)*?)<yr>([^<>]*?)<\/yr>:<pg>([^<>]*?)<\/pg>$regx{optionaEndPunc}<\/bib>/<bib$1>$2\(<yr>$3\/$4<\/yr>\)$5<v>$6<\/v>:<pg>$7<\/pg>$8<\/bib>/gs;

  $TextBody=~s/<bib([^<>]*?)>((?:(?!<bib)(?!<\/bib).)*?)\(<yr>$regx{year}<\/yr>([\.]?)\)((?:(?!<bib)(?!<\/bib).)*?)<yr>([^<>]*?)<\/yr>:<pg>([^<>]*?)<\/pg>$regx{optionaEndPunc}<\/bib>/<bib$1>$2\(<yr>$3<\/yr>$4\)$5<v>$6<\/v>:<pg>$7<\/pg>$8<\/bib>/gs;

  #. IFNgamma-dependent</aug>
  $TextBody=~s/(\, |>)$regx{mAuthorString} $regx{firstName}\, $regx{mAuthorString} $regx{firstName}\. $regx{mAuthorString}<\/aug>\, ([a-z]+ [a-z]+) /$1$2 $3\, $4 $5<\/aug>\. $6\, $7 /gs;
  $TextBody=~s/(\, |>)$regx{mAuthorString} $regx{firstName}\, $regx{mAuthorString} $regx{firstName}\. ([A-Z]+[0-9]+|[A-Z][A-Z][0-9\-a\w]+)<\/aug>\, /$1$2 $3\, $4 $5<\/aug>\. $6\, /gs;
$TextBody=~s/(\, |>)$regx{mAuthorString} $regx{firstName}\, $regx{mAuthorString}<\/aug>\, $regx{firstName}\. (A [a-z]+|An [a-z]+|In [a-z]+) /$1$2 $3\, $4 $5<\/aug>\. $6\, /gs;

  #<aug>Lawson, J. (originally published in 1709</aug>
  $TextBody=~s/([\.\:\, ]+)\(([^<>\(\)]+?)<\/aug>([\.\,]?) <yr>$regx{year}<\/yr>/<\/aug>$1\($2$3 <yr>$4<\/yr>/gs;
  $TextBody=~s/<\/(aug|edrg|ia)>([\.\,\; ]+)\($regx{year}\/$regx{year}([\.]?)\)/<\/$1>$2\(<yr>$3\/$4<\/yr>$5\)/gs;
  $TextBody=~s/<\/(aug|edrg|ia)>([\.\,\; ]+)\(<yr>$regx{year}<\/yr>\/$regx{year}([\.]?)\)/<\/$1>$2\(<yr>$3\/$4<\/yr>$5\)/gs;
  $TextBody=~s/<\/(aug|edrg|ia)>([\.\,\; ]+)\(<yr>$regx{year}<\/yr>\/([1-9][0-9])([\.]?)\)/<\/$1>$2\(<yr>$3\/$4<\/yr>$5\)/gs;
  $TextBody=~s/<bib([^<>]*?)>((?:(?!<bib)(?!<\/bib).)*?) ([A-Za-z\-]+) <yr>([^<>]*?)<\/yr>((?:(?!<[\/]?bib).)*?)<\/(pbl|cny)>([\)\]\.\,\; ]+)<yr>([^<>]*?)<\/yr>/<bib$1>$2 $3 $4$5<\/$6>$7<yr>$8<\/yr>/gs;
  $TextBody=~s/ ([A-Z][A-Z]+)\.<\/aug> / $1<\/aug>\. /gs;
  $TextBody=~s/<bib([^<>]*?)><(edrg|aug)>([^<>]+?)<\/\2>([\,\;\:\( ]+)$regx{year}([\-]+)$regx{year}([\.\;\)\,\: ]+)/<bib$1><$2>$3<\/$2>$4<yr>$5$6$7<\/yr>$8/gs;



  #he 2001 symposium
  $TextBody=~s/<bib([^<>]*?)>((?:(?!<[\/]?bib).)*?) ([a-z]+) <yr>$regx{year}<\/yr> ([a-zA-Z]+) ((?:(?!<[\/]?bib).)*?)<yr>$regx{year}<\/yr>((?:(?!<[\/]?bib).)*?)<\/bib>/<bib$1>$2 $3 <yr>$4<\/yr> $5 $6<yr>$7<\/yr>$8<\/bib>/gs;
  $TextBody=~s/([Pp]roceeding[s]? of the) <yr>$regx{year}<\/yr>/$1 $2/gs;
  $TextBody=~s/([A-Z]+) <yr>$regx{year}<\/yr>([\.\,]?) (LNCS)/$1 $2$3 $4/gs;

  #Accessed April 7, <yr>1999</yr>
  $TextBody=~s/<bib([^<>]*?)>((?:(?!<[\/]?bib).)*?)<yr>([^<>]*?)<\/yr>((?:(?!<[\/]?bib).)*?)([Aa]ccessed|[Zz]ugegriffen) $regx{monthPrefix} ([0-9]+)([\.\,\;\:]+) <yr>([^<>]*?)<\/yr>/<bib$1>$2<yr>$3<\/yr>$4$5 $6 $7$8 $9/gs;

  $TextBody=~s/In <edrg>([A-Z][a-z]+ [A-Za-z][a-z]+ [A-Za-z]+ [^<>]+?)<\/edrg> $regx{editorSuffix} ([$AuthorString ]+)([\,]?) $regx{firstName}([\,]?) ([^<>]+?) ([$AuthorString ]+)([\,]?) $regx{firstName} <(cny|pbl)>/In <bt>$1<\/bt> $2 <edrg>$3$4 $5$6 $7 $8$9 $10<\/edrg> <$11>/gs;
  $TextBody=~s/In <edrg>([A-Z][a-z]+ [A-Za-z][a-z]+ [A-Za-z]+ [^<>]+?)<\/edrg> $regx{editorSuffix} ([$AuthorString ]+)([\,]?) $regx{firstName} <(cny|pbl)>/In <bt>$1<\/bt> $2 <edrg>$3$4 $5<\/edrg> <$6>/gs;

  $TextBody=~s/In <edrg>([A-Z][a-z]+ [A-Za-z][a-z]+ [A-Za-z]+ [^<>]+?)<\/edrg> $regx{editorSuffix} $regx{firstName}([\,]?) ([$AuthorString ]+)([\,]?) ([^<>]+?) $regx{firstName}([\,]?) ([$AuthorString ]+)  <(cny|pbl)>/In <bt>$1<\/bt> $2 <edrg>$3$4 $5$6 $7 $8$9 $10<\/edrg> <$11>/gs;
  $TextBody=~s/In <edrg>([A-Z][a-z]+ [A-Za-z][a-z]+ [A-Za-z]+ [^<>]+?)<\/edrg> $regx{editorSuffix} $regx{firstName}([\,]?) ([$AuthorString ]+) <(cny|pbl)>/In <bt>$1<\/bt> $2 <edrg>$3$4 $5<\/edrg> <$6>/gs;
  $TextBody=~s/In <edrg>([A-Z][a-z]+ [A-Za-z][a-z]+ [A-Za-z]+ [^<>]+?)<\/edrg> $regx{editorSuffix} ([$AuthorString ]+)([\,]?) ([$AuthorString ]+) <(cny|pbl)>/In <bt>$1<\/bt> $2 <edrg>$3$4 $5<\/edrg> <$6>/gs;

  
  $TextBody=~s/ $regx{firstName} ([$AuthorString ]+)([\,]) $regx{firstName}<\/aug> ([$AuthorString ]+)\;/ $1 $2$3 $4 $5<\/aug>\;/gs;
  $TextBody=~s/ et<\/aug>\. Al\.\;/ et al\.<\/aug>\;/gs;
  $TextBody=~s/ $regx{firstName} ([$AuthorString ]+) J\.<\/aug> <pt>Chem\./ $1 $2<\/aug> <pt>J\. Chem\./gs;
  $TextBody=~s/<\/aug>, $regx{firstName} ([$AuthorString ]+)\; <pt>/, $1 $2<\/aug>\; <pt>/gs;
  $TextBody=~s/\, ([A-Z][a-z]+)\. ([A-Z][a-z]+)<\/aug>\. ([A-Z][a-z]+)\./<\/aug>, <pt>$1\. $2\. $3<\/pt>\./gs;
  $TextBody=~s/<collab>([^<>]+?)\, edited by ([^<>]+?) \(<\/collab>/<collab>$1<\/collab>\, edited by <edrg>$2<\/edrg> \(/gs;
  $TextBody=~s/ $regx{volume} \($regx{year}\) pp $regx{page} <url>/ <v>$1<\/v> \(<yr>$2<\/yr>\) pp <pg>$3<\/pg> <url>/gs;

  $TextBody=~s/\, $regx{firstName}\. ([$AuthorString ]+)\. ([A-Z][A-Z]+)<\/aug>: /\, $1\. $2<\/aug>\. $3: /gs;
  $TextBody=~s/\, $regx{firstName}\. ([$AuthorString ]+)<\/aug>\. (II|III): /\, $1\. $2\. $3<\/aug>: /gs;

  $TextBody=~s/<aug>([$AuthorString]+) ([A-Z \.\-]+)\.<\/aug> ([$AuthorString]+)\, ([A-Z][\w]+ [\w]+ [\w]+ [\w]+)/<aug>$1 $2\. $3<\/aug>\, $4/gs;

  $TextBody=~s/\. ([Ii]n[\:]?) ((?:(?!<[\/]?bib)(?!<[\/]?edrg)(?!<[\/]?bt).)+)([\,\.]) <i>([^<>]+?)<\/i>([\,]?) ([\(]?)$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{optionalPuncSpace}(<cny>|<pbl>)/\. $1 <edrg>$2<\/edrg>$3 <i><bt>$4<\/bt><\/i>$5 $6$7$8<pg>$9<\/pg>$10$11/gs;
  $TextBody=~s/\. ([Ii]n[\:]?) ((?:(?!<[\/]?bib)(?!<[\/]?edrg)(?!<[\/]?bt).)+)$regx{etal}([\,\. ]+)((?:(?!<[\/]?bib)(?!<[\/]?edrg)(?!<[\/]?bt).)+)(<cny>|<pbl>)/\. $1 <edrg>$2$3<\/edrg>$4$5$6/gs;
  #<aug>Symonds, John Addington. Sleep and Dreams</aug>:

  #-------------------------For Series Title-------------------------
  $TextBody=~s/<\/aug>([ \.\,\;\:]+)([\w]+ [\w\-\,\: ]+)\. ([Ii]n[\:]?) <edrg>([A-Z][A-Za-z\-]+ [\w\-]+ [\w\- ]+)([\;\.]) ([$AuthorString ]+)([\,]?) $regx{firstName}((?:(?!<[\/]?bib)(?!<[\/]?edrg).)*?)<\/edrg>/<\/aug>$1$2\. $3 <bt>$4<\/bt>$5 <edrg>$6$7 $8$9<\/edrg>/gs;
  $TextBody=~s/<\/aug>([ \.\,\;\:]+)([\w]+ [\w\-\,\: ]+)\. ([Ii]n[\:]?) <edrg>([A-Z][A-Za-z\-]+ [\w\-]+ [\w\- ]+)([\;\.]) $regx{firstName}([\,]?) ([$AuthorString ]+)((?:(?!<[\/]?bib)(?!<[\/]?edrg).)*?)<\/edrg>/<\/aug>$1$2\. $3 <bt>$4<\/bt>$5 <edrg>$6$7 $8$9<\/edrg>/gs;
  #------------------------------------------------------------------
  $TextBody=~s/<\/aug>\, $regx{firstName}\. <i>/\, $1<\/aug>\. <i>/gs;
  $TextBody=~s/<u>doi <url>([^<>]+?)<\/url><\/u>/doi <url>$1<\/url>/gs;
  $TextBody=~s/([\]\)\.])<\/doi><\/doig>/<\/doi><\/doig>$1/gs;

  $TextBody=~s/([\,\; ]+)\&hellip<\/aug>\;/<\/aug>$1\&hellip\;/gs;
  #-------------------------------------------
  $TextBody=~s/<bib([^<>]*?)><aug>([^<>]+?)<\/aug>((?:(?!<bib)(?!<[\/]?yr>)(?!<\/bib).)*?)<pt>([^<>]+?)<\/pt>$regx{optionalPuncSpace}<v>$regx{volume}<\/v>$regx{optionalPuncSpace}\(<iss>$regx{year}<\/iss>\)$regx{optionalPuncSpace}<pg>([^<>]+?)<\/pg>$regx{optionaEndPunc}<\/bib>/<bib$1><aug>$2<\/aug>$3<pt>$4<\/pt>$5<v>$6<\/v>$7\(<yr>$8<\/yr>\)$9<pg>$10<\/pg>$11<\/bib>/gs;
  $TextBody=~s/<bib([^<>]*?)><(aug|edrg)>([^<>]+?)<\/\2>((?:(?!<bib)(?!<[\/]?yr>)(?!<\/bib).)*?)$regx{optionalPuncSpace}<v>$regx{volume}<\/v>$regx{optionalPuncSpace}\(<iss>$regx{year}<\/iss>\)$regx{optionalPuncSpace}<pg>([^<>]+?)<\/pg>$regx{optionaEndPunc}<\/bib>/<bib$1><$2>$3<\/$2>$4$5<v>$6<\/v>$7\(<yr>$8<\/yr>\)$9<pg>$10<\/pg>$11<\/bib>/gs;
  $TextBody=~s/(of|in)<\/aug> <yr>$regx{year}<\/yr>/$1 $2<\/aug>/gs;
  $TextBody=~s/<\/(aug|edrg)>\, $regx{suffix}([\, \(]+)<yr>/\, $2<\/$1>$3<yr>/gs;
  $TextBody=~s/<bib([^<>]*?)>([A-Z\-]+?)([\,\.\:\( ]+?)<yr>([^<>]+?)<\/yr>/<bib$1><ia>$2<\/ia>$3<yr>$4<\/yr>/gs;
  $TextBody=~s/<bib([^<>]*?)>(---[\-]+|——[—]+|––[–]+|−−[−]+|––[–]+)([\.\;\,]) /<bib$1><ia>$2<\/ia>$3 /gs;
  #<aug>ICD. Manual of the international classification of diseases</aug>
  $TextBody=~s/<bib([^<>]*?)><aug>([A-Z][A-Z\-]+?)([\.\:] )([A-Z][a-z]+ [a-zA-Z][a-z]+ [a-zA-Z][a-z]+ [a-zA-Z ]+)<\/aug>/<bib$1><ia>$2<\/ia>$3$4/gs;
  $TextBody=~s/<bib([^<>]*?)>([A-Z][^A-Z\, ]+?)([\,\.\:\( ]+?)<yr>([^<>]+?)<\/yr>/<bib$1><aug>$2<\/aug>$3<yr>$4<\/yr>/gs;

  #<bib id="bib10">Landes, Mark. <i>
  $TextBody=~s/<bib([^<>]*?)>([$AuthorString]+)\, ([$AuthorString]+)([\.]?) <i>/<bib$1><aug>$2, $3<\/aug>$4 <i>/gs;

  $TextBody=~s/<bib([^<>]*?)>([$AuthorString]+), ([$AuthorString]+) $regx{firstName}([\,\.\:\( ]+?)<yr>/<bib$1><aug>$2, $3 $4<\/aug>$5$6<yr>/gs;
  $TextBody=~s/<bib([^<>]*?)>([$AuthorString]+), ([$AuthorString]+)([\,\.\:\( ]+?)<yr>/<bib$1><aug>$2, $3<\/aug>$4$5<yr>/gs;
  $TextBody=~s/<bib([^<>]*?)><(aug|edrg)>([^<>]+?)<\/\2>((?:(?!<bib)(?!<[\/]?yr>)(?!<\/bib).)*?)<pbl>([Ii]n [Pp]ress)<\/pbl><\/bib>/<bib$1><$2>$3<\/$2>$4<yr>$5<\/yr><\/bib>/gs;
  $TextBody=~s/<bib([^<>]*?)>((?:(?!<bib)(?!<\/bib).)*?)<i>([^<>]+?)<cny>([^<>]+?)<\/cny>([^<>]+?)<\/i>((?:(?!<bib)(?!<\/bib).)*?)<cny>([^<>]+?)<\/cny>/<bib$1>$2<i>$3$4$5<\/i>$6<cny>$7<\/cny>/gs;
  $TextBody=~s/<bib([^<>]*?)>((?:(?!<bib)(?!<\/bib).)+?)<cny>([^<>]+?)<\/cny>((?:(?!<bib)(?!<\/bib).)+?)<cny>([^<>]+?)<\/cny>/<bib$1>$2$3$4<cny>$5<\/cny>/gs;
  $TextBody=~s/<\/(cny|pbl)>\, ([0-9]+)([\. ]+)([Ee]d|[eE]dn)([\.]?)\, <(yr|pbl|pg)>/<\/$1>\, <edn>$2<\/edn>$3$4$5\, <$6>/gs;
  $TextBody=~s/<pbl>(Cambridge|Oxford)<\/pbl> \(<cny>([A-Za-z\,\. ]+)<\/cny>\)\: <pbl>([^<>]+?)<\/pbl>/<cny>$1 ($2)<\/cny>\: <pbl>$3<\/pbl>/gs;
  $TextBody=~s/<pbl>(Cambridge|Oxford)<\/pbl> <cny>([A-Za-z\,\. ]+)<\/cny>\: <pbl>([^<>]+?)<\/pbl>/<cny>$1 $2<\/cny>\: <pbl>$3<\/pbl>/gs;
  $TextBody=~s/<pt>([^<>]+?) ([A-Z]|[A-Z][a-z])<\/pt>vol <v>/<pt>$1 $2vol<\/pt> <v>/gs;
  $TextBody=~s/<edrg>([lL]etter [tT]o [tT]he)<\/edrg>/$1/gs;
  $TextBody=~s/<edrg>([^<>]+?) (et al[\.]?)<\/edrg>/<edrg>$1<\/edrg> $2/gs;
  $TextBody=~s/<\/aug> <i>$regx{editorSuffix}<\/i>\./ <i>$1<\/i><\/aug>\./gs;
  $TextBody=~s/<bib([^<>]+?)>([^<>\.\, ]+ [^<>\.\,]+)([\.\,\:]?) $regx{allLeftQuote}/<bib$1><ia>$2 $3<\/ia>$4 $5/gs;
  $TextBody=~s/<bib([^<>]+?)><aug>((?:(?!<[\/]?aug>)(?!<bib)(?!<\/bib).)+?)([\.\,\:]?) $regx{allLeftQuote}((?:(?!<[\/]?aug>)(?!<bib)(?!<\/bib).)+?)<\/aug>/<bib$1><aug>$2<\/aug>$3 $4$5/gs;
  $TextBody=~s/ $regx{and} $regx{firstName}<\/aug>, $regx{mAuthorFullSirName}([\,\.\:]?) / $1 $2, $3<\/aug>$4 /gs;
  #<aug>Shah KV. Polyomaviruses</aug>. In: <edrg>
  $TextBody=~s/(<aug>|\, )$regx{mAuthorFullSirName} $regx{firstName}\. ([A-Z][a-z]+ [A-Z][a-z]+ [A-Z][a-z]+ [^\,\.]+|[A-Z][a-z]+ [A-Z][a-z]+|[A-Z][a-z]+)<\/aug>\. (In\: )<edrg>/$1$2 $3<\/aug>\. $4\. $5<edrg>/gs;

  $TextBody=~s/ In <edrg>([^<>]+?)<\/edrg> ([A-Za-z][a-z]+)\. <pt>/ In $1 $2\. <pt>/gs;
  $TextBody=~s/\, <pt>([Ss]upplement [Nn]o)<\/pt> <v>([^<>]+?)<\/v>([\: ]+)<pg>([^<>]+?)<\/pg>([\.]?)<\/bib>/\, $1 <iss>$2<\/iss>$3<pg>$4<\/pg>$5<\/bib>/gs;
  $TextBody=~s/<\/(cny|pbl)>([\.\,]) ([pp]+[\.]? |S[\.]? )<v>([^<>]+?)<\/v>\, <pg>([^<>]+?)<\/pg>([\.]?)<\/bib>/<\/$1>$2 $3<pg>$4\, $5<\/pg>$6<\/bib>/gs;
  #----------------------------------------------------------------------
  $TextBody=~s/<bib([^<>]*?)>([A-Z][A-Z][A-Z]+[\-0-9A-Z]*)([\.\:]) ([A-Z][a-z\-A-Z]+ [a-zA-Z][a-z]+ [a-zA-Z][a-z]+) /<bib$1><aug>$2<\/aug>$3 $4 /gs;
  #</aug> <yr>1821</yr> and 1867. <pt>Bull Hist Med</pt> <yr>1948</yr>
  $TextBody=~s/<bib([^<>]*?)>((?:(?!<bib)(?!<\/bib).)+?) <yr>$regx{year}<\/yr> ([a-z]+) ((?:(?!<bib)(?!<\/bib)(?!<\/yr>).)+?) <yr>$regx{year}<\/yr>/<bib$1>$2 $3 $4 $5 <yr>$6<\/yr>/gs;
  $TextBody=~s/ (of|in|from|at) <yr>$regx{year}<\/yr> ((?:(?!<bib)(?!<\/bib)(?!<\/yr>).)+?) <yr>$regx{year}<\/yr>/ $1 $2 $3 <yr>$4<\/yr>/gs;
 
  #</aug> (Eds.; 1991)
  $TextBody=~s/<\/aug>([\.\;\:\, ]+)\($regx{editorSuffix}([\.\;\:\, ]+)$regx{year}\)/<\/aug>$1\($2$3<yr>$4<\/yr>\)/gs;
  $TextBody=~s/<ia>([^<>]+?) \($regx{editorSuffix}([\.\;\:\,]+)<\/ia>([\.\;\:\, ]+)<yr>$regx{year}<\/yr>\)/<ia>$1<\/ia> \($2$3$4 <yr>$5<\/yr>\)/gs;

  $TextBody=~s/([\.\,\;]?) $regx{pagePrefix}([\.]?)<\/edrg>([ ]?)<pg>/<\/edrg>$1 $2$3$4<pg>/gs;  #, pp.</edrg> <pg>
  $TextBody=~s/\, \($regx{pagePrefix}$regx{optionalSpace}$regx{page}\)<\/edrg>\. <(cny|pbl)>/<\/edrg>\, \($1$2<pg>$3<\/pg>\)\. <$4>/gs;
  $TextBody=~s/ $regx{editorSuffix} <edrg>by ([A-Za-z])/ $1 by <edrg>$2/gs;
  $TextBody=~s/<doi>([^<>]+?)\(([^\)\(<>]+)<\/doi><\/doig>\)/<doi>$1\($2\)<\/doi><\/doig>/gs;
  #</aug>, <i>et al</i>
  $TextBody=~s/<\/aug>([\.\,\; ]+)<(i|b)>$regx{etal}<\/\2>([\,\.\;\: ]+)/$1<$2>$3<\/$2><\/aug>$4/gs;
  $TextBody=~s/([1-3])&lt;sup&gt;(rd|st|nd)&lt;\/sup&gt;/$1<sup>$2<\/sup>/gs;
  $TextBody=~s/\,<\/edrg>/<\/edrg>\,/gs;
  $TextBody=~s/<aug>([^<>]+?)<\/aug>\: ([A-Z]+)\. ([(]?)<yr>/<aug>$1\: $2<\/aug>\. $3<yr>/gs;
  $TextBody=~s/<aug>([^<>]+?)([\.\,]) (The [A-Z]+)<\/aug> ([\w]+)/<aug>$1<\/aug>$2 $3 $4/gs;
  $TextBody=~s/<aug>$regx{mAuthorFullSirName}\. $regx{firstName}\.<\/aug>/<aug>$1\, $2\.<\/aug>/gs;  #replace \. to \,
  $TextBody=~s/<bib([^<>]*?)>((?:(?!<[\/]?yr>)(?!<[\/]?bib>)(?!1[987][0-9][0-9][a-z]?|20[0-9][0-9][a-z]?).)*?)<\/(pbl|cny|bt)>([\.\,\;]) $regx{year}((?:(?!<[\/]?bib>)(?!<[\/]?yr>)(?!1[987][0-9][0-9][a-z]?|20[0-9][0-9][a-z]?).)*?)<\/bib>/<bib$1>$2<\/$3>$4 <yr>$5<\/yr>$6<\/bib>/gs;
  $TextBody=~s/<bib([^<>]*?)>((?:(?!<[\/]?yr>)(?!<[\/]?bib>).)*?)<\/(pbl|cny)>([\.\,\;]) $regx{year}\)((?:(?!<[\/]?bib>)(?!<[\/]?yr>).)*?)<\/bib>/<bib$1>$2<\/$3>$4 <yr>$5<\/yr>\)$6<\/bib>/gs;


  #------------------------------------------------------------------------

  return $TextBody;
}
#===============================================================================================

sub singleAuthorMark{
  $TextBody=shift;

  #<bib id="bib5">Jan Späth.  #Kevin O'Neill #Carlos Alós-Ferrer #Yüksel Özbay #H. Jäppinen.
  $$TextBody=~s/<bib([^<>]*?)>([^a-z\%\$\&\^\!\@\~\.\,\:\;\(\)\[\]0-9<> ][^A-Z\^\$\%\.\,\:\;\(\)\[\]0-9<> ]+? [^a-z\%\$\&\^\!\@\~\.\,\:\;\(\)\[\]0-9<> ]\'[^a-z\%\$\&\^\!\@\~\.\,\:\;\(\)\[\]0-9<> ][^A-Z\^\$\%\.\,\:\;\(\)\[\]0-9<> ]+?)\. /<bib$1><aug>$2<\/aug>\. /gs;
  $$TextBody=~s/<bib([^<>]*?)>([^a-z\%\$\&\^\!\@\~\.\,\:\;\(\)\[\]0-9<> ][^A-Z\^\$\%\.\,\:\;\(\)\[\]0-9<> ]+? [^a-z\%\$\&\^\!\@\~\.\,\:\;\(\)\[\]0-9<> ][^A-Z\^\$\%\.\,\:\;\(\)\[\]0-9<> ]+?)\. /<bib$1><aug>$2<\/aug>\. /gs;
  $$TextBody=~s/<bib([^<>]*?)>([^a-z\%\$\&\^\!\@\~\.\,\:\;\(\)\[\]0-9<> ][^A-Z\^\$\%\.\,\:\;\(\)\[\]0-9 ]+? [^a-z\%\$\&\^\!\@\~\.\,\:\;\(\)\[\]0-9<> ][^A-Z\^\$\%\.\,\:\;\(\)\[\]0-9 ]+?\-[^a-z\%\$\&\^\!\@\~\.\,\:\;\(\)\[\]0-9<> ][^A-Z\^\$\%\.\,\:\;\(\)\[\]0-9 ]+?)\. /<bib$1><aug>$2<\/aug>\. /gs;
  $$TextBody=~s/<bib([^<>]*?)>$regx{firstName} ([^a-z\%\$\&\^\!\@\~\.\,\:\;\(\)\[\]0-9<> ][^A-Z\^\$\%\.\,\:\;\(\)\[\]0-9 ]+?)\. /<bib$1><aug>$2 $3<\/aug>\. /gs;

  $$TextBody=~s/<bib([^<>]*?)>([^a-z\%\$\&\^\!\@\~\.\,\:\;\(\)\[\]0-9<> ][^A-Z\^\$\%\.\,\:\;\(\)\[\]0-9<> ]+? [^a-z\%\$\&\^\!\@\~\.\,\:\;\(\)\[\]0-9<> ][^A-Z\^\$\%\.\,\:\;\(\)\[\]0-9<> ]+?) $regx{and} ([^a-z\%\$\&\^\!\@\~\.\,\:\;\(\)\[\]0-9<> ][^A-Z\^\$\%\.\,\:\;\(\)\[\]0-9<> ]+? [^a-z\%\$\&\^\!\@\~\.\,\:\;\(\)\[\]0-9<> ][^A-Z\^\$\%\.\,\:\;\(\)\[\]0-9<> ]+?)\. /<bib$1><aug>$2 $3 $4<\/aug>\. /gs;
  $$TextBody=~s/<aug>([A-Z][^a-z0-9\- \.\,\;][^a-z0-9\- \.\,\;]+)\, $regx{firstName}\. ([^\.\,\(\)<>\;]+ [^\.\,\(\)<>\;]+ [^\.\,\(\)<>\;]+ [^\.\,\(\)<>\;]+)<\/aug>/<aug>$1\, $2<\/aug>\. $3/gs;

#  $$TextBody=~s/<bib([^<>]*?)>([^a-z\%\$\&\^\!\@\~\.\,\:\;\(\)\[\]0-9<> ][^A-Z\^\$\%\.\,\:\;\(\)\[\]0-9 ]+? [^a-z\%\$\&\^\!\@\~\.\,\:\;\(\)\[\]0-9<> ][^A-Z\^\$\%\.\,\:\;\(\)\[\]0-9 ]+?\-[^a-z\%\$\&\^\!\@\~\.\,\:\;\(\)\[\]0-9<> ][^A-Z\^\$\%\.\,\:\;\(\)\[\]0-9 ]+?) ([\(]?<yr>[^<>]+?<\/yr>)//gs;

  $$TextBody=~s/<bib([^<>]*?)>([^a-z\%\$\&\^\!\@\~\.\,\:\;\(\)\[\]0-9<> ][^A-Z\^\$\%\.\,\:\;\(\)\[\]0-9 ]+? [^a-z\%\$\&\^\!\@\~\.\,\:\;\(\)\[\]0-9<> ][^A-Z\^\$\%\.\,\:\;\(\)\[\]0-9 ]+?[^\^\$\%\.\,\:\;\(\)\[\]0-9]+?)([\. ]+)([\(]?<yr>[^<>]+?<\/yr>)/<bib$1><aug>$2<\/aug>$3$4/gs;

  $$TextBody=~s/<bib([^<>]*?)>([^a-z\%\$\&\^\!\@\~\.\,\:\;\(\)\[\]0-9<> ][^A-Z\^\$\%\.\,\:\;\(\)\[\]0-9 ]+? [^a-z\%\$\&\^\!\@\~\.\,\:\;\(\)\[\]0-9<> ][^A-Z\^\$\%\.\,\:\;\(\)\[\]0-9 ]+?[^\^\$\%\.\,\:\;\(\)\[\]0-9]+?)\. /<bib$1><aug>$2<\/aug>\. /gs;

#  print $$TextBody;exit;
  return $$TextBody;
}

#==========================================================================================================================================
sub editorWithoutEds{
  my $TextBody=shift;


  my $andPunc='([\,\;] |[\/ ]+| [au]nd | en | \& | \&amp\; )';

  #Noelle-Neumann, E. (2000). Öffentliche Meinung. In: E. Noelle-Neumann, W. Schulz & J. Wilke: Fischer Lexikon Publizistik Massenkommunikation (S. 366–382). Frankfurt am Main: Fischer.
  $$TextBody=~s/([\.\,\;]|<\/i>) ([Ii]n[\.:]?) $regx{firstName} $regx{mAuthorString}([\,\;] |[\/ ]+)$regx{editorString}${andPunc}$regx{firstName} $regx{mAuthorString}\: /$1 $2 <edrg>$3 $4$5$6 $7 $8 $9<\/edrg>\: /gs;
  $$TextBody=~s/([\.\,\;]|<\/i>) ([Ii]n[\.:]?) $regx{firstName} $regx{mAuthorString}${andPunc}$regx{firstName} $regx{mAuthorString}\: /$1 $2 <edrg>$3 $4$5$6 $7<\/edrg>\: /gs;

  $$TextBody=~s/([\.\,\;]|<\/i>) ([Ii]n[\.:]?) $regx{mAuthorString}([\,]? )$regx{firstName}([\,\;] |[\/ ]+)$regx{editorString}${andPunc}$regx{mAuthorString}([\,]? )$regx{firstName}\: /$1 $2 <edrg>$3$4$5$6$7 $8 $9$10$11<\/edrg>\: /gs;
  $$TextBody=~s/([\.\,\;]|<\/i>) ([Ii]n[\.:]?) $regx{mAuthorString}([\,]? )$regx{firstName}${andPunc}$regx{mAuthorString}([\,]? )$regx{firstName}\: /$1 $2 <edrg>$3$4$5$6$7$8$9<\/edrg>\: /gs;

  $$TextBody=~s/([\.\,\;]|<\/i>) ([Ii]n[\.:]?) $regx{mAuthorString}([\,]? )$regx{firstName}([\,]? )$regx{particleSuffix}([\,\;] |[\/ ]+)$regx{editorString}${andPunc}$regx{mAuthorString}([\,]? )$regx{firstName}\: /$1 $2 <edrg>$3$4$5$6$7$8$9$10$11$12$13<\/edrg>\: /gs;
  $$TextBody=~s/([\.\,\;]|<\/i>) ([Ii]n[\.:]?) $regx{mAuthorString}([\,]? )$regx{firstName}([\,\;] |[\/ ]+)$regx{editorString}${andPunc}$regx{mAuthorString}([\,]? )$regx{firstName}([\,]? )$regx{particleSuffix}\: /$1 $2 <edrg>$3$4$5$6$7$8$9$10$11$12$13<\/edrg>\: /gs;
  $$TextBody=~s/([\.\,\;]|<\/i>) ([Ii]n[\.:]?) $regx{mAuthorString}([\,]? )$regx{firstName}([\,]? )$regx{particleSuffix}([\,\;] |[\/ ]+)$regx{editorString}${andPunc}$regx{mAuthorString}([\,]? )$regx{firstName}([\,]? )$regx{particleSuffix}\: /$1 $2 <edrg>$3$4$5$6$7$8$9$10$11$12$13$14$15<\/edrg>\: /gs;

  $$TextBody=~s/([\.\,\;]|<\/i>) ([Ii]n[\.:]?) $regx{mAuthorString}([\,]? )$regx{firstName}([\,]? )$regx{particleSuffix}${andPunc}$regx{mAuthorString}([\,]? )$regx{firstName}\: /$1 $2 <edrg>$3$4$5$6$7$8$9$10$11<\/edrg>\: /gs;
  $$TextBody=~s/([\.\,\;]|<\/i>) ([Ii]n[\.:]?) $regx{mAuthorString}([\,]? )$regx{firstName}${andPunc}$regx{mAuthorString}([\,]? )$regx{firstName}([\,]? )$regx{particleSuffix}\: /$1 $2 <edrg>$3$4$5$6$7$8$9$10$11<\/edrg>\: /gs;
  $$TextBody=~s/([\.\,\;]|<\/i>) ([Ii]n[\.:]?) $regx{mAuthorString}([\,]? )$regx{firstName}([\,]? )$regx{particleSuffix}${andPunc}$regx{mAuthorString}([\,]? )$regx{firstName}([\,]? )$regx{particleSuffix}\: /$1 $2 <edrg>$3$4$5$6$7$8$9$10$11$12$13<\/edrg>\: /gs;

  $$TextBody=~s/\. In\: $regx{firstName} $regx{mAuthorFullSirName}\: /\. In\: <edrg>$1 $2<\/edrg>\: /gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\:\;\) ]+)([^<>\.\,]+?)\. In $regx{firstName}\. $regx{mAuthorString}([\,]?) $regx{and} $regx{firstName}\. $regx{mAuthorString}([\,\.]) ([^<>\,\.]+?)\. <(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>\. In <edrg>$4\. $5$6 $7 $8\. $9<\/edrg>$10 <bt>$11<\/bt>\. <$12>/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\:\;\) ]+)([^<>\.\,]+?)\. In $regx{firstName}\. $regx{mAuthorString}\, $regx{firstName}\. $regx{mAuthorString}([\,\.]) ([^<>\,\.]+?)\. <(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>\. In <edrg>$4\. $5\, $6\. $7<\/edrg>$8 <bt>$9<\/bt>\. <$10>/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\:\;\) ]+)([^<>\.\,]+?)\. In $regx{firstName}\. $regx{mAuthorString}([\,\.]) ([^<>\,\.]+?)\. <(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>\. In <edrg>$4\. $5<\/edrg>$6 <bt>$7<\/bt>\. <$8>/gs;

  #Lakowicz JR (ed.) (2006) Quenching of fluorescence. In: Principles of Fluorescence Spectroscopy, 3 edn. Springer, New York
  $$TextBody=~s/<\/(yr|aug|ia|edrg)>([\.\:\;\) ]+)([^<>\.\,]+?)\. ([Ii]n[\.:]?) <edrg>((?:(?![^<>\(\)\[\]\:05-9\?\%\+\!\.\,\;\/ ]+?[\,]? [A-Z\-\. ]+>)(?!<\/edrg>).)*?)\, $regx{edn}<\/edrg> $regx{ednSuffix}([\.\, ]+)<(pbl|cny)>/<\/$1>$2<misc1>$3<\/misc1>\. $4 <bt>$5<\/bt>\, <edn>$6<\/edn> $7$8<$9>/gs;
  $$TextBody=~s/<\/(aug|ia|edrg)>([\.\;\:\,\( ]+)$regx{year}([\.\:\;\) ]+)([^<>\.\,]+?)\. ([Ii]n[\.:]?) <edrg>((?:(?![^<>\(\)\[\]\:05-9\?\%\+\!\.\,\;\/ ]+?[\,]? [A-Z\-\. ]+>)(?!<\/edrg>).)*?)\, $regx{edn}<\/edrg> $regx{ednSuffix}([\.\, ]+)<(pbl|cny)>/<\/$1>$2<yr>$3<\/yr>$4<misc1>$5<\/misc1>\. $6 <bt>$7<\/bt>\, <edn>$8<\/edn> $9$10<$11>/gs;
  $$TextBody=~s/<\/(yr|aug|ia|edrg)>([\.\:\;\) ]+)([^<>\.\,]+?)\. ([Ii]n[\.:]?) <edrg>((?:(?![^<>\(\)\[\]\:05-9\?\%\+\!\.\,\;\/ ]+?[\,]? [A-Z\-\. ]+>)(?!<\/edrg>).)*?)\, $regx{edn}$regx{numberSuffix}<\/edrg> $regx{ednSuffix}([\.\, ]+)<(pbl|cny)>/<\/$1>$2<misc1>$3<\/misc1>\. $4 <bt>$5<\/bt>\, <edn>$6<\/edn>$7 $8$9<$10>/gs;
  $$TextBody=~s/<\/(aug|ia|edrg)>([\.\;\:\,\( ]+)$regx{year}([\.\:\;\) ]+)([^<>\.\,]+?)\. ([Ii]n[\.:]?) <edrg>((?:(?![^<>\(\)\[\]\:05-9\?\%\+\!\.\,\;\/ ]+?[\,]? [A-Z\-\. ]+>)(?!<\/edrg>).)*?)\, $regx{edn}$regx{numberSuffix}<\/edrg> $regx{ednSuffix}([\.\, ]+)<(pbl|cny)>/<\/$1>$2<yr>$3<\/yr>$4<misc1>$5<\/misc1>\. $6 <bt>$7<\/bt>$8\, <edn>$9<\/edn> $10$11<$12>/gs;

  #In <edrg>Molecular biology of DNA topoisomerases and its application to chemotherapy,</edrg> eds. T. Andoh &, H. Ikeda, and M. Oguro, 31--37. <cny>

  #In <edrg>Molecular biology of DNA topoisomerases and its application to chemotherapy,</edrg> eds. T. Andoh, H. Ikeda, and M. Oguro, 31--37. <cny>
  $$TextBody=~s/ ([Ii]n[\.:]?) <edrg>([^<>\.\,]+?)\,<\/edrg> $regx{editorSuffix}([\.]) $regx{firstName} $regx{mAuthorString}\, $regx{firstName} $regx{mAuthorString}([\,]?) $regx{and} $regx{firstName} $regx{mAuthorString}\, $regx{page}(\. [\(]?)<(cny|pbl)>/ $1 <bt>$2<\/bt>\, $3$4 <edrg>$5 $6\, $7 $8$9 $10 $11 $12<\/edrg>\, <pg>$13<\/pg>$14<$15>/gs;


  #</yr>) Intergenerational Caregiving of Germany, eds. A. Booth, A.C. Crouter, S.M. Bianchi, J.A. Seltzer, pp. <pg>
  $$TextBody=~s/ $regx{editorSuffix}([\.]) $regx{firstName} $regx{mAuthorString}\, $regx{firstName} $regx{mAuthorString}\, $regx{firstName} $regx{mAuthorString}(\,) $regx{firstName} $regx{mAuthorString}\, $regx{pagePrefix}$regx{optionalSpace}<(cny|pbl|pg)>/ $1$2 <edrg>$3 $4\, $5 $6\, $7 $8$9 $10 $11<\/edrg>\, $12$13<$14>/gs;
  $$TextBody=~s/ $regx{editorSuffix}([\.]) $regx{firstName} $regx{mAuthorString}\, $regx{firstName} $regx{mAuthorString}\, $regx{firstName} $regx{mAuthorString} $regx{and} $regx{firstName} $regx{mAuthorString}\, $regx{pagePrefix}$regx{optionalSpace}<(cny|pbl|pg)>/ $1$2 <edrg>$3 $4\, $5 $6\, $7 $8 $9 $10 $11<\/edrg>\, $12$13<$14>/gs;
  $$TextBody=~s/ $regx{editorSuffix}([\.]) $regx{firstName} $regx{mAuthorString}\, $regx{firstName} $regx{mAuthorString}(\,) $regx{firstName} $regx{mAuthorString}\, $regx{pagePrefix}$regx{optionalSpace}<(cny|pbl|pg)>/ $1$2 <edrg>$3 $4\, $5 $6$7 $8 $9<\/edrg>\, $10$11<$12>/gs;
  $$TextBody=~s/ $regx{editorSuffix}([\.]) $regx{firstName} $regx{mAuthorString}\, $regx{firstName} $regx{mAuthorString} $regx{and} $regx{firstName} $regx{mAuthorString}\, $regx{pagePrefix}$regx{optionalSpace}<(cny|pbl|pg)>/ $1$2 <edrg>$3 $4\, $5 $6 $7 $8 $9<\/edrg>\, $10$11<$12>/gs;
  $$TextBody=~s/ $regx{editorSuffix}([\.]) $regx{firstName} $regx{mAuthorString}(\,) $regx{firstName} $regx{mAuthorString}\, $regx{pagePrefix}$regx{optionalSpace}<(cny|pbl|pg)>/ $1$2 <edrg>$3 $4$5 $6 $7<\/edrg>\, $8$9<$10>/gs;
  $$TextBody=~s/ $regx{editorSuffix}([\.]) $regx{firstName} $regx{mAuthorString} $regx{and} $regx{firstName} $regx{mAuthorString}\, $regx{pagePrefix}$regx{optionalSpace}<(cny|pbl|pg)>/ $1$2 <edrg>$3 $4 $5 $6 $7<\/edrg>\, $8$9<$10>/gs;


  $$TextBody=~s/ $regx{editorSuffix}([\.]) $regx{firstName} $regx{mAuthorString}\, $regx{firstName} $regx{mAuthorString}\, $regx{firstName} $regx{mAuthorString}(\,) $regx{firstName} $regx{mAuthorString}\, $regx{pagePrefix}$regx{optionalSpace}$regx{page}(\. [\(]?)<(cny|pbl)>/ $1$2 <edrg>$3 $4\, $5 $6\, $7 $8$9 $10 $11<\/edrg>\, $12$13<pg>$14<\/pg>$15<$16>/gs;
  $$TextBody=~s/ $regx{editorSuffix}([\.]) $regx{firstName} $regx{mAuthorString}\, $regx{firstName} $regx{mAuthorString}\, $regx{firstName} $regx{mAuthorString}(\,) $regx{firstName} $regx{mAuthorString}\, $regx{page}(\. [\(]?)<(cny|pbl)>/ $1$2 <edrg>$3 $4\, $5 $6\, $7 $8$9 $10 $11<\/edrg>\, <pg>$12<\/pg>$13<$14>/gs;


  #, ed. J Marcus J and J.A. Sabloff, 183--208. <cny>
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\:\;\) ]+)([iI]n[\:\.]?) ([^<>\.\,]+?)([\,\.]) $regx{editorSuffix}([\.]?) $regx{firstName} $regx{mAuthorString}\, $regx{firstName} $regx{mAuthorString} $regx{and} $regx{firstName} $regx{mAuthorString}\, $regx{pagePrefix}$regx{optionalSpace}$regx{page}(\. [\(]?)<(cny|pbl)>/<\/$1>$2$3 <bt>$4<\/bt>$5 $6$7 <edrg>$8 $9\, $10 $11 $12 $13 $14<\/edrg>\, $15$16<pg>$17<\/pg>$18<$19>/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\:\;\) ]+)([iI]n[\:\.]?) ([^<>\.\,]+?)([\,\.]) $regx{editorSuffix}([\.]?) $regx{firstName} $regx{mAuthorString}\, $regx{firstName} $regx{mAuthorString}(\,) $regx{firstName} $regx{mAuthorString}\, $regx{pagePrefix}$regx{optionalSpace}$regx{page}(\. [\(]?)<(cny|pbl)>/<\/$1>$2$3 <bt>$4<\/bt>$5 $6$7 <edrg>$8 $9\, $10 $11$12 $13 $14<\/edrg>\, $15$16<pg>$17<\/pg>$18<$19>/gs;

  $$TextBody=~s/<\/(yr|aug|ia)>([\.\:\;\) ]+)([iI]n[\:\.]?) ([^<>\.\,]+?)([\,\.]) $regx{editorSuffix}([\.]?) $regx{firstName} $regx{mAuthorString}\, $regx{firstName} $regx{mAuthorString} $regx{and} $regx{firstName} $regx{mAuthorString}\, $regx{page}(\. [\(]?)<(cny|pbl)>/<\/$1>$2$3 <bt>$4<\/bt>$5 $6$7 <edrg>$8 $9\, $10 $11 $12 $13 $14<\/edrg>\, <pg>$15<\/pg>$16<$17>/gs;

  $$TextBody=~s/<\/(yr|aug|ia)>([\.\:\;\) ]+)([iI]n[\:\.]?) ([^<>\.\,]+?)([\,\.]) $regx{editorSuffix}([\.]?) $regx{firstName} $regx{mAuthorString} $regx{and} $regx{firstName} $regx{mAuthorString}\, $regx{pagePrefix}$regx{optionalSpace}$regx{page}(\. [\(]?)<(cny|pbl)>/<\/$1>$2$3 <bt>$4<\/bt>$5 $6$7 <edrg>$8 $9 $10 $11 $12<\/edrg>\, $13$14<pg>$15<\/pg>$16<$17>/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\:\;\) ]+)([iI]n[\:\.]?) ([^<>\.\,]+?)([\,\.]) $regx{editorSuffix}([\.]?) $regx{firstName} $regx{mAuthorString} $regx{and} $regx{firstName} $regx{mAuthorString}\, $regx{page}(\. [\(]?)<(cny|pbl)>/<\/$1>$2$3 <bt>$4<\/bt>$5 $6$7 <edrg>$8 $9 $10 $11 $12<\/edrg>\, <pg>$13<\/pg>$14<$15>/gs;
  $$TextBody=~s/([\,\.]) $regx{editorSuffix}\. $regx{firstName} $regx{mAuthorString} $regx{and} $regx{firstName} $regx{mAuthorString}\, $regx{page}(\. [\(]?)<(cny|pbl)>/$1 $2\. <edrg>$3 $4 $5 $6 $7<\/edrg>\, <pg>$8<\/pg>$9<$10>/gs;

  #</yr>. In Tiwanaku: Ancestors of the Inca, Ed. M. Young-Sanchez, 97--125. <cny>
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\:\;\) ]+)([iI]n[\:\.]?) ([^<>\.\,]+?)([\,\.]) $regx{editorSuffix}([\.]?) $regx{firstName} $regx{mAuthorString}\, $regx{pagePrefix}$regx{optionalSpace}$regx{page}(\. [\(]?)<(cny|pbl)>/<\/$1>$2$3 <bt>$4<\/bt>$5 $6$7 <edrg>$8 $9<\/edrg>\, $10$11<pg>$12<\/pg>$13<$14>/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\:\;\) ]+)([iI]n[\:\.]?) ([^<>\.\,]+?)([\,\.]) $regx{editorSuffix}([\.]?) $regx{firstName} $regx{mAuthorString}\, $regx{page}(\. [\(]?)<(cny|pbl)>/<\/$1>$2$3 <bt>$4<\/bt>$5 $6$7 <edrg>$8 $9<\/edrg>\, <pg>$10<\/pg>$11<$12>/gs;

  $$TextBody=~s/<\/(yr|aug|ia)>([\.\:\;\) ]+)([iI]n[\:\.]?) $regx{firstName}\. $regx{mAuthorString}\, ([^<>\.\,]+?)(\. [\(]?)<(cny|pbl)>/<\/$1>$2$3 <edrg>$4\. $5<\/edrg>\, <bt>$6<\/bt>$7<$8>/gs;

  #</yr>). In P. Brauckmann, Web-Monitoring (S. 321--337). <cny>
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\:\;\) ]+)([iI]n[\:\.]?) $regx{firstName} $regx{mAuthorString}\, ([^<>\.\,]+?)(\. | [\(]?)$regx{pagePrefix}$regx{optionalSpace}$regx{page}(\. [\(]?|\)\. )<(cny|pbl)>/<\/$1>$2$3 <edrg>$4 $5<\/edrg>\, <bt>$6<\/bt>$7$8$9<pg>$10<\/pg>$11<$12>/gs;

  #</yr>). In: G. Bentele, H-B. Brosius & O. Jarren, 
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\:\;\) ]+)([iI]n[\:\.]?) $regx{firstName} $regx{mAuthorString}\, $regx{firstName} $regx{mAuthorString}, $regx{firstName} $regx{mAuthorString}\, ([^<>\.\,]+?)(\. | [\(]?)/<\/$1>$2$3 <edrg>$4 $5\, $6 $7, $8 $9<\/edrg>\, $10$11/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\:\;\) ]+)([iI]n[\:\.]?) $regx{firstName} $regx{mAuthorString}\, $regx{firstName} $regx{mAuthorString}([,]?) $regx{and} $regx{firstName} $regx{mAuthorString}\, ([^<>\.\,]+?)(\. | [\(]?)/<\/$1>$2$3 <edrg>$4 $5\, $6 $7$8 $9 $10 $11<\/edrg>\, $12$13/gs;

  $$TextBody=~s/<\/(yr|aug|ia)>([\.\:\;\) ]+)([iI]n[\:\.]?) $regx{firstName} $regx{mAuthorString}, $regx{firstName} $regx{mAuthorString}\, ([^<>\.\,]+?)(\. | [\(]?)/<\/$1>$2$3 <edrg>$4 $5\, $6 $7<\/edrg>\, $8$9/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\:\;\) ]+)([iI]n[\:\.]?) $regx{firstName} $regx{mAuthorString}([,]?) $regx{and} $regx{firstName} $regx{mAuthorString}\, ([^<>\.\,]+?)(\. | [\(]?)/<\/$1>$2$3 <edrg>$4 $5$6 $7 $8 $9<\/edrg>\, $10$11/gs;

  return $$TextBody;
}
#==========================================================================================================================================

sub editorAfterEds{
  my $TextBody=shift;


  my $editedBy='([Ee]dited [bB]y|\b[Ee]d[s]?[\.]? [Bb]y)';

  $$TextBody=~s/(<aug>|[\,\.]+ )$regx{mAuthorString}\, $regx{firstName}\. ([A-Z][^A-A<>]+[\w\-]* [A-Za-z][^A-Z<>]+[\w\-]* [A-Za-z][^A-Z<>]+[^<>]+?)<\/aug>([\.] [Ii]n[\:]? )<edrg>/$1$2\, $3<\/aug>\. $4$5<edrg>/gs;
 # print  $$TextBody;exit;

  $$TextBody=~s/ In\: <edrg>([^<>]+?)\.<\/edrg> ([Ee]ditor[s]?|[eE]d[s]?[\.]?|Hrgs|Herausgeber)\: / In\: $1\. $2\: /gs;
  $$TextBody=~s/([iI]n[\:\;\.]?) $regx{firstName} <edrg>/$1 <edrg>$2 /gs;

  #Nock, S. L., Kingston, P. W., & Holian, L. M. (2008) The distribution of obligations. Intergenerational Caregiving. eds. A. Booth, A.C. Crouter, S.M. Bianchi, J.A. Seltzer, pp.&nbsp;279–316. The Urban Institute, Washington, DC.
  $$TextBody=~s/<\/(yr|aug)>([\)\.\: ]+)([A-Z][^<>\.]+)\. ([^<>]+?)([\.\, ]+)([eE]d[s]?[\.\:\,]|Hrgs[\.\:\,]|Herausgeber[\.\:\,]) $regx{firstName} $regx{mAuthorString}([\.\, ]+[\(]?)$regx{pagePrefix}$regx{optionalSpace}$regx{page}([\)\.\,\;\( ]+)<(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>\. <bt>$4<\/bt>$5$6 <edrg>$7 $8<\/edrg>$9$10$11<pg>$12<\/pg>$13<$14>/gs;
  $$TextBody=~s/<\/(yr|aug)>([\)\.\: ]+)([A-Z][^<>\.]+)\. ([^<>]+?)([\.\, ]+)([eE]d[s]?[\.\:\,]|Hrgs[\.\:\,]|Herausgeber[\.\:\,]) $regx{firstName} $regx{mAuthorString}([\,\; ]+[^<>4-90\(\)\:]+)([\.\, ]+[\(]?)$regx{pagePrefix}$regx{optionalSpace}$regx{page}([\)\.\,\;\( ]+)<(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>\. <bt>$4<\/bt>$5$6 <edrg>$7 $8$9<\/edrg>$10$11$12<pg>$13<\/pg>$14<$15>/gs;
  $$TextBody=~s/<\/(yr|aug)>([\)\.\: ]+)([A-Z][^<>\.]+)\. ([^<>]+?)([\.\, ]+)([eE]d[s]?[\.\:\,]|Hrgs[\.\:\,]|Herausgeber[\.\:\,]) $regx{firstName} $regx{mAuthorString}([\.\,][ \(]+|[\.\, ]+[\(]?)<(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>\. <bt>$4<\/bt>$5$6 <edrg>$7 $8<\/edrg>$9<$10>/gs;
  $$TextBody=~s/<\/(yr|aug)>([\)\.\: ]+)([A-Z][^<>\.]+)\. ([^<>]+?)([\.\, ]+)([eE]d[s]?[\.\:\,]|Hrgs[\.\:\,]|Herausgeber[\.\:\,]) $regx{firstName} $regx{mAuthorString}([\,\; ]+[^<>4-90]+)([\.\,][ \(]+|[\.\, ]+[\(]?)<(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>\. <bt>$4<\/bt>$5$6 <edrg>$7 $8$9<\/edrg>$10<$11>/gs;
  $$TextBody=~s/$regx{sAuthorString}\.<\/edrg>/$1<\/edrg>\./gs;
  $$TextBody=~s/<\/(yr|aug)>([\)\.\: ]+)([A-Z][^<>\.]+)\. ([^<>]+?)([\.\, ]+)([eE]d[s]?[\.\:\,]|Hrgs[\.\:\,]|Herausgeber[\.\:\,]) $regx{mAuthorString}([\,]?) $regx{firstName}([\.\, ]+[\(]?)$regx{pagePrefix}$regx{optionalSpace}$regx{page}([\)\.\,\;\( ]+)<(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>\. <bt>$4<\/bt>$5$6 <edrg>$7$8 $9<\/edrg>$10$11$12<pg>$13<\/pg>$14<$15>/gs;

  #eds. A. Booth, A.C. Crouter, S.M. Bianchi, J.A. Seltzer, pp. <pg>279--316</pg>. (<cny>
  $$TextBody=~s/<\/(yr|aug)>([\)\.\: ]+)([A-Z][^<>\.]+)\. ([^<>]+?)([\.\, ]+)([eE]d[s]?[\.\:\,]|Hrgs[\.\:\,]|Herausgeber[\.\:\,]) $regx{firstName} $regx{mAuthorString}([\.\, ]+[\(]?)$regx{pagePrefix}$regx{optionalSpace}<pg>$regx{page}<\/pg>([\)\.\,\;\( ]+)<(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>\. <bt>$4<\/bt>$5$6 <edrg>$7 $8<\/edrg>$9$10$11<pg>$12<\/pg>$13<$14>/gs;
  $$TextBody=~s/<\/(yr|aug)>([\)\.\: ]+)([A-Z][^<>\.]+)\. ([^<>]+?)([\.\, ]+)([eE]d[s]?[\.\:\,]|Hrgs[\.\:\,]|Herausgeber[\.\:\,]) $regx{firstName} $regx{mAuthorString}([\,\; ]+[^<>4-90\(\)\:]+)([\.\, ]+[\(]?)$regx{pagePrefix}$regx{optionalSpace}<pg>$regx{page}<\/pg>([\)\.\,\;\( ]+)<(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>\. <bt>$4<\/bt>$5$6 <edrg>$7 $8$9<\/edrg>$10$11$12<pg>$13<\/pg>$14<$15>/gs;
  $$TextBody=~s/<\/(yr|aug)>([\)\.\: ]+)([A-Z][^<>\.]+)\. ([^<>]+?)([\.\, ]+)([eE]d[s]?[\.\:\,]|Hrgs[\.\:\,]|Herausgeber[\.\:\,]) $regx{mAuthorString}([\,]?) $regx{firstName}([\.\, ]+[\(]?)$regx{pagePrefix}$regx{optionalSpace}<pg>$regx{page}<\/pg>([\)\.\,\;\( ]+)<(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>\. <bt>$4<\/bt>$5$6 <edrg>$7$8 $9<\/edrg>$10$11$12<pg>$13<\/pg>$14<$15>/gs;


  #“An Introduction to the Study of Guanxi” in Social Connections in China: Institutions, Culture, and the Changing Nature of Guanxi. Eds. Gold, Guthrie, and Wank David. New York
  $$TextBody=~s/<\/(aug|ia|yr)>([\.\)\: ]+)$regx{allLeftQuote}([^<>]+)$regx{allRightQuote}([\.\, ]+[iI]n[\:\.]? )([^<>]+)\. (Ed[s]?[\.\:]|Hrgs[\.\:]|Hg\.|Herausgeber\:) $regx{mAuthorFullSirName}([\,]?) $regx{mAuthorFullFirstName}\, $regx{mAuthorFullSirName}([\,]?) $regx{mAuthorFullFirstName}([\,]?) $regx{and} $regx{mAuthorFullSirName}([\,]?) $regx{mAuthorFullFirstName}(\. [\(]?)<(cny|pbl|pg)>/<\/$1>$2$3<misc1>$4<\/misc1>$5$6<bt>$7<\/bt>\. $8 <edrg>$9$10 $11\, $12$13 $14$15 $16 $17$18 $19<\/edrg>$20<$21>/gs;
  $$TextBody=~s/<\/(aug|ia|yr)>([\.\)\: ]+)$regx{allLeftQuote}([^<>]+)$regx{allRightQuote}([\.\, ]+[iI]n[\:\.]? )([^<>]+)\. (Ed[s]?[\.\:]|Hrgs[\.\:]|Hg\.|Herausgeber\:) $regx{mAuthorFullSirName}([\,]?) $regx{mAuthorFullFirstName}([\,]?) $regx{and} $regx{mAuthorFullSirName}([\,]?) $regx{mAuthorFullFirstName}(\. [\(]?)<(cny|pbl|pg)>/<\/$1>$2$3<misc1>$4<\/misc1>$5$6<bt>$7<\/bt>\. $8 <edrg>$9$10 $11$12 $13 $14$15 $16<\/edrg>$17<$18>/gs;
  $$TextBody=~s/<\/(aug|ia|yr)>([\.\)\: ]+)$regx{allLeftQuote}([^<>]+)$regx{allRightQuote}([\.\, ]+[iI]n[\:\.]? )([^<>]+)\. (Ed[s]?[\.\:]|Hrgs[\.\:]|Hg\.|Herausgeber\:) $regx{mAuthorFullSirName}([\,]?) $regx{mAuthorFullFirstName}(\. [\(]?)<(cny|pbl|pg)>/<\/$1>$2$3<misc1>$4<\/misc1>$5$6<bt>$7<\/bt>\. $8 <edrg>$9$10 $11<\/edrg>$12<$13>/gs;
  $$TextBody=~s/<\/(aug|ia|yr)>([\.\)\: ]+)$regx{allLeftQuote}([^<>]+)$regx{allRightQuote}([\,\. ]+[Ii]n[:.] )([^<>\.]+?)([\.\,]) $editedBy ([^<>\.\,]+?[^<>4-9]+?)([\.\,\:\; \(]+)(<cny>|<pbl>|[pPS\.]+ <pg>|[pPS\.]+ [0-9]+)/<\/$1>$2$3<misc1>$4<\/misc1>$5$6<bt>$7<\/bt>$8 $9 <edrg>$10<\/edrg>$11$12/gs;

   #</aug>, F-Race and iterated F-Race: An overview, In: <edrg>Experimental Methods for the Analysis of Optimization Algorithms, T. Bartz-Beielstein and M. Preuss,</edrg> eds.,
  $$TextBody=~s/$regx{INwithSpace}<edrg>([^<>\,\.]+?)([\.\,]) $regx{firstName} $regx{mAuthorString}([\,]) $regx{firstName} $regx{mAuthorString}([\,]?) $regx{and} $regx{firstName} $regx{mAuthorString}([\,\.]?)<\/edrg>([\.\,]?) $regx{editorSuffix}([\.\,\:\; \(]+)(<cny>|<pbl>|[pPS\.]+ <pg>|[pPS\.]+ [0-9]+)/$1<bt>$2<\/bt>$3 <edrg>$4 $5$6 $7 $8$9 $10 $11 $12$13<\/edrg>$14 $15$16$17/gs;
  $$TextBody=~s/$regx{INwithSpace}<edrg>([^<>\,\.]+?)([\.\,]) $regx{firstName} $regx{mAuthorString}([\,]?) $regx{and} $regx{firstName} $regx{mAuthorString}([\,\.]?)<\/edrg>([\.\,]?) $regx{editorSuffix}([\.\,\:\; \(]+)(<cny>|<pbl>|[pPS\.]+ <pg>|[pPS\.]+ [0-9]+)/$1<bt>$2<\/bt>$3 <edrg>$4 $5$6 $7 $8 $9$10<\/edrg>$11 $12$13$14/gs;
  $$TextBody=~s/$regx{INwithSpace}<edrg>([^<>\,\.]+?)([\.\,]) $regx{firstName} $regx{mAuthorString}([\,]?) $regx{firstName} $regx{mAuthorString}([\,\.]?)<\/edrg>([\.\,]?) $regx{editorSuffix}([\.\,\:\; \(]+)(<cny>|<pbl>|[pPS\.]+ <pg>|[pPS\.]+ [0-9]+)/$1<bt>$2<\/bt>$3 <edrg>$4 $5$6 $7 $8$9<\/edrg>$10 $11$12$13/gs;


  #. Eds. Quintin Hoare and Jeffrey Nowell Smith. <cny>
  $$TextBody=~s/<\/(aug|ia|yr)>([\.\)\: ]+)([^<>\.]+)\. (Ed[s]?[\.\:]|Hrgs[\.\:]|Hg\.|Herausgeber\:) $regx{mAuthorFullSirName}([\,]?) $regx{mAuthorFullFirstName}\, $regx{mAuthorFullSirName}([\,]?) $regx{mAuthorFullFirstName}([\,]?) $regx{and} $regx{mAuthorFullSirName}([\,]?) $regx{mAuthorFullFirstName}(\. )<(cny|pbl|pg)>/<\/$1>$2$3\. $4 <edrg>$5$6 $7\, $8$9 $10$11 $12 $13$14 $15<\/edrg>$16<$17>/gs;
  $$TextBody=~s/<\/(aug|ia|yr)>([\.\)\: ]+)([^<>\.]+)\. (Ed[s]?[\.\:]|Hrgs[\.\:]|Hg\.|Herausgeber\:) $regx{mAuthorFullSirName}([\,]?) $regx{mAuthorFullFirstName}([\,]?) $regx{and} $regx{mAuthorFullSirName}([\,]?) $regx{mAuthorFullFirstName}(\. )<(cny|pbl|pg)>/<\/$1>$2$3\. $4 <edrg>$5$6 $7$8 $9 $10$11 $12<\/edrg>$13<$14>/gs;
  $$TextBody=~s/<\/(aug|ia|yr)>([\.\)\: ]+)([^<>\.]+)\. (Ed[s]?[\.\:]|Hrgs[\.\:]|Hg\.|Herausgeber\:) $regx{mAuthorFullSirName}([\,]?) $regx{mAuthorFullFirstName}(\. )<(cny|pbl|pg)>/<\/$1>$2$3\. $4 <edrg>$5$6 $7<\/edrg>$8<$9>/gs;

  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\:\)]* )([^<>\.]+)\. (Hrgs[\.\:]|Ed[s]?[\.\:]|Editor[s]?:|Herausgeber\:|[Ee]dited [bB]y|Ed[s]?[\.] [Bb]y) $regx{mAuthorFullFirstName} $regx{mAuthorFullSirName}([\,]?) $regx{and} $regx{mAuthorFullFirstName} $regx{mAuthorFullSirName}([\:\;\.\,] )([^<>\.\,]+?)([\.\, ]+)<(cny|pbl)>/<\/$1>$2$3\. $4 <edrg>$5 $6$7 $8 $9 $10<\/edrg>$11<bt>$12<\/bt>$13<$14>/gs;

  #</yr>). The Power of Kings. Edited by Peter Laslett, John Smith, The Philosophy of John Locke. <cny>New York</cny>
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\:\)]* )([^<>\.]+)\. (Hrgs[\.\:]|Ed[s]?[\.\:]|Editor[s]?:|Herausgeber\:|[Ee]dited [bB]y|Ed[s]?[\.] [Bb]y) $regx{mAuthorFullFirstName} $regx{mAuthorFullSirName}\, $regx{mAuthorFullFirstName} $regx{mAuthorFullSirName}([\:\;\.\,] )([^<>\.\,]+?)([\.\, ]+)<(cny|pbl)>/<\/$1>$2$3\. $4 <edrg>$5 $6\, $7 $8<\/edrg>$9<bt>$10<\/bt>$11<$12>/gs;

  #Filmer, R. (1648/1984). The Power of Kings. Edited by Peter Laslett, The Philosophy of John Locke. New York: Garland
  $$TextBody=~s/<\/(yr|aug)>([\)\.\,\:]* )([^<>]+)\. (Hrgs[\.\:]|Ed[s]?[\.\:]|Editor[s]?:|Herausgeber\:|[Ee]dited [bB]y|Ed[s]?[\.] [Bb]y) $regx{mAuthorFullSirName}([\,]?) $regx{mAuthorFullFirstName}([\:\.\;\,]) ([^<>\.\,]+)\. <(cny|pbl)>/<\/$1>$2$3\. $4 <edrg>$5$6 $7<\/edrg>$8 $9\. <$10>/gs;
  $$TextBody=~s/<\/(yr|aug)>([\)\.\,\:]* )([^<>]+)\. (Hrgs[\.\:]|Ed[s]?[\.\:]|Editor[s]?:|Herausgeber\:|[Ee]dited [bB]y|Ed[s]?[\.] [Bb]y) $regx{mAuthorFullSirName}([\,]?) $regx{mAuthorFullFirstName}([\,]?) $regx{and} $regx{mAuthorFullSirName}([\,]?) $regx{mAuthorFullFirstName}([\.\,]) ([^<>\.\,]+)\. <(cny|pbl)>/<\/$1>$2$3\. $4 <edrg>$5$6 $7$8 $9n$10$11 $12<\/edrg>$13 $14\. <$15>/gs;

  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<edrg>([^<>]+?)([\.\,\;]? )$regx{volumePrefix}$regx{optionalSpace}$regx{volume}([\.\,])<\/edrg> $regx{editorSuffix}([\.\:]?) ([^<>\.\,]+?[^<>4-9]+?)\, $regx{pagePrefix}$regx{optionalSpace}$regx{page}\. <(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt>$5<\/bt>$6$7$8<v>$9<\/v>$10 $11$12 <edrg>$13<\/edrg>\, $14$15<pg>$16<\/pg>\. <$17>/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<edrg>([^<>]+?)([\.\,\;]? )$regx{volumePrefix}$regx{optionalSpace}$regx{volume}([\.\,])<\/edrg> $regx{editorSuffix}([\.\:]?) ([^<>\.\,]+?[^<>4-9]+?)\, $regx{page}\. <(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt>$5<\/bt>$6$7$8<v>$9<\/v>$10 $11$12 <edrg>$13<\/edrg>\, <pg>$14<\/pg>\. <$15>/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<edrg>([^<>]+?)([\.\,\;]? )$regx{edn}$regx{numberSuffix}<\/edrg>([\.]?) $regx{ednSuffix}([\.\,]) $regx{editorSuffix}([\.\:]?) ([^<>\.\,]+?[^<>4-9]+?)\, $regx{page}\. <(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt>$5<\/bt>$6<edn>$7<\/edn>$8$9 $10$11 $12$13 <edrg>$14<\/edrg>\, <pg>$15<\/pg>\. <$16>/gs;


  #Basis for selection of the dosage form. In: Development and formulation of veterinary dosage forms. 2nd edn. Eds Hardee, G.E. & Baggot, J.D. <pbl>
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<i>([^<>]+?)<\/i>\. $regx{edn}$regx{numberSuffix}([\.]?) $regx{ednSuffix}\. $regx{editorSuffix}([\.\:]?) ([^<>\.\,]+?[^<>4-9]+?)([\.\, ]+)<(pbl|cny)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt><i>$5<\/i><\/bt>\. <edn>$6<\/edn>$7$8 $9\. $10$11 <edrg>$12<\/edrg>$13<$14>/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<i>([^<>]+?)<\/i>\. $regx{edn}([\.]?) $regx{ednSuffix}\. $regx{editorSuffix}([\.\:]?) ([^<>\.\,]+?[^<>4-9]+?)([\.\, ]+)<(pbl|cny)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt><i>$5<\/i><\/bt>\. <edn>$6<\/edn>$7 $8\. $9$10 <edrg>$11<\/edrg>$12<$13>/gs;


  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}([^<>]+?)\. $regx{edn}$regx{numberSuffix}([\.]?) $regx{ednSuffix}\. $regx{editorSuffix}([\.\:]?) ([^<>\.\,]+?[^<>4-9]+?)([\.\, ]+)<(pbl|cny)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt>$5<\/bt>\. <edn>$6<\/edn>$7$8 $9\. $10$11 <edrg>$12<\/edrg>$13<$14>/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}([^<>]+?)\. $regx{edn}([\.]?) $regx{ednSuffix}\. $regx{editorSuffix}([\.\:]?) ([^<>\.\,]+?[^<>4-9]+?)([\.\, ]+)<(pbl|cny)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt>$5<\/bt>\. <edn>$6<\/edn>$7 $8\. $9$10 <edrg>$11<\/edrg>$12<$13>/gs;

 #</yr>). Basis for selection of the dosage form. In: Development and formulation of veterinary dosage forms. 2nd edn. Eds Hardee, G.E. & Baggot, J.D. pp. 7--144. <pbl>
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}([^<>]+?)\. $regx{edn}$regx{numberSuffix}([\.]?) $regx{ednSuffix}\. $regx{editorSuffix}([\.\:]?) ([^<>\.\,]+?[^<>4-9]+?)([\.\, ]+)$regx{pagePrefix}$regx{optionalSpace}$regx{page}([\.\, ]+)<(pbl|cny)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt>$5<\/bt>\. <edn>$6<\/edn>$7$8 $9\. $10$11 <edrg>$12<\/edrg>$13$14$15<pg>$16<\/pg>$17<$18>/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}([^<>]+?)\. $regx{edn}([\.]?) $regx{ednSuffix}\. $regx{editorSuffix}([\.\:]?) ([^<>\.\,]+?[^<>4-9]+?)([\.\, ]+)$regx{pagePrefix}$regx{optionalSpace}$regx{page}([\.\, ]+)<(pbl|cny)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt>$5<\/bt>\. <edn>$6<\/edn>$7 $8\. $9$10 <edrg>$11<\/edrg>$12$13$14<pg>$15<\/pg>$16<$17>/gs;

  #</aug>, Theory of hydrogen bonding in water, in <i>Water A comprehensive treatise</i>, Vol. 1, Ed. F. Franks (<pbl>
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<i>([^<>]+?)<\/i>([\.\,]) $regx{volumePrefix}$regx{optionalSpace}$regx{volume}([\.\,]) $regx{editorSuffix}([\.\:]?) ([^<>\.\,]+?[^<>4-9]+?)([\.\,\:\; \(]+)(<cny>|<pbl>|[pPS\.]+ <pg>|[pPS\.]+ [0-9]+)/<\/$1>$2<misc1>$3<\/misc1>$4<bt><i>$5<\/i><\/bt>$6 $7$8<v>$9<\/v>$10 $11$12 <edrg>$13<\/edrg>$14$15/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}([^<>]+?)([\.\,]) $regx{volumePrefix}$regx{optionalSpace}$regx{volume}([\.\,]) $regx{editorSuffix}([\.\:]?) ([^<>\.\,]+?[^<>4-9]+?)([\.\,\:\; \(]+)(<cny>|<pbl>|[pPS\.]+ <pg>|[pPS\.]+ [0-9]+)/<\/$1>$2<misc1>$3<\/misc1>$4<bt>$5<\/bt>$6 $7$8<v>$9<\/v>$10 $11$12 <edrg>$13<\/edrg>$14$15/gs;
  
  #” in: The Classical Temper in Western Europe, edited by John Hardy and Andrew McCredie (
  $$TextBody=~s/$regx{INwithSpace}([^<>\.]+?)([\.\,]) $editedBy ([^<>\.\,]+?[^<>4-9]+?)([\.\,\:\; \(]+)(<cny>|<pbl>|[pPS\.]+ <pg>|[pPS\.]+ [0-9]+)/$1<bt>$2<\/bt>$3 $4 <edrg>$5<\/edrg>$6$7/gs;
  $$TextBody=~s/$regx{allRightQuote}([\,\. ]+[Ii]n[:] |[\,\. ]+[Ii]n[:.] )([^<>\.]+?)([\.\,]) $editedBy ([^<>\.\,]+?[^<>4-9]+?)([\.\,\:\; \(]+)([pPS\.]+ <pg>|[pPS\.]+ [0-9]+|<cny>|<pbl>)/$1$2<bt>$3<\/bt>$4 $5 <edrg>$6<\/edrg>$7$8/gs;

  $$TextBody=~s/$regx{INwithSpace}<edrg>([^<>]+)\,<\/edrg> $editedBy ([^<>\.\,]+?[^<>4-9]+?)([\.\,\:\; \(]+)([pPS\.]+ <pg>|[pPS\.]+ [0-9]+|<cny>|<pbl>)/$1<bt>$2<\/bt>\, $3 <edrg>$4<\/edrg>$5$6/gs;

  #</aug>. Conformational Studies and Anti-HIV Activity. In <edrg>Nucleosides and Nucleotides as Antitumor and Antiviral Agents; Chu, C. K., Baker, D. C.,</edrg> Eds.; <pbl>
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<edrg>([^<>\.]+?)([\;\.\,] )([^<>\.\,]+?[^<>4-9]+?)([\.\,]?)<\/edrg>([\.\,\; ]+)$regx{editorSuffix}([\.\,\:\; \(]+)(<cny>|<pbl>|[pPS\.]+ <pg>|[pPS\.]+ [0-9]+)/<\/$1>$2<misc1>$3<\/misc1>$4<bt>$5<\/bt>$6<edrg>$7$8<\/edrg>$9$10$11$12/gs;
  #</yr>). Lipids and their metabolism. In Rose, A. H. & Harrison, J. S., The yeasts, vol. 3 (pp. 367--455). <cny>
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}$regx{mAuthorFullSirName}\, $regx{firstName}\. $regx{and} $regx{mAuthorFullSirName}\, $regx{firstName}\.\, ([^<>\.\,]+?[^<>\.]+?)\, (<cny>|<pbl>|[pPS\.]+ <pg>|[pPS\.]+ [0-9]+|[vV]ol[u]?[m]?[e]?[\.]? [0-9]+)/<\/$1>$2<misc1>$3<\/misc1>$4<edrg>$5\, $6\. $7 $8\, $9\.<\/edrg>\, <bt>$10<\/bt>\, $11/gs;

  # </yr>. Immigration and crime in the United States. In The immigration debate: Studies on the economic, immigration (pp. 367--387), eds. James P. Smith and Barry Edmonston. <cny>
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}([^<>\.\,]+?[^<>]+?)([\.\, \(]+)$regx{pagePrefix}$regx{optionalSpace}$regx{page}([\)\.\, ]+)$regx{editorSuffix}([\.\:]) ([^<>\.\,]+?[^<>4-9]+?)([\.\,\; \(]+)<cny>/<\/$1>$2<misc1>$3<\/misc1>$4<bt>$5<\/bt>$6$7$8<pg>$9<\/pg>$10$11$12 <edrg>$13<\/edrg>$14<cny>/gs;

  #print $$TextBody;#exit;

  return $$TextBody;
}



sub bookItalicEditorAfterEds{
  my $TextBody=shift;



  #Löwenthal, Leo. 1990a. Individuum und Terror. 1946. In <i>Falsche Propheten. Studien zum Autoritarismus. Schriften </i><span style='color:red'>Bd. 3, Hrsg. Leo Löwenthal, 161-174</span>. Frankfurt a. M.: Suhrkamp.
  #Fürstenberg, Friedrich. 1961. Art. Religionssoziologie. In Religion in Geschichte und Gegenwart, 3. Aufl. Bd.&nbsp;V, Hrsg. Friedrich Fürstenberg, 1027–1032. Tübingen: Mohr,
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<i>([^<>]+?)<\/i>([\?\.\,\; ]+)$regx{volumePrefix}$regx{optionalSpace}$regx{volume}\, $regx{editorSuffix}([\.\:]?) ([^<>\.\,]+?[^<>4-9]+?)\, $regx{pagePrefix}$regx{optionalSpace}$regx{page}\. <(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt><i>$5<\/i><\/bt>$6$7$8<v>$9<\/v>\, $10$11 <edrg>$12<\/edrg>\, $13$14<pg>$15<\/pg>\. <$16>/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<i>([^<>]+?)<\/i>([\?\.\,\; ]+)$regx{edn}$regx{numberSuffix}([\.]?) $regx{ednSuffix}([\.\, ]+)$regx{volumePrefix}$regx{optionalSpace}$regx{volume}\, $regx{editorSuffix}([\.\:]?) ([^<>\.\,]+?[^<>4-9]+?)\, $regx{pagePrefix}$regx{optionalSpace}$regx{page}\. <(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt><i>$5<\/i><\/bt>$6<edn>$7<\/edn>$8$9 $10$11$12$13<v>$14<\/v>\, $15$16 <edrg>$17<\/edrg>\, $18$19<pg>$20<\/pg>\. <$21>/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<i>([^<>]+?)<\/i>([\?\.\,\; ]+)$regx{edn}([\.]?) $regx{ednSuffix}([\.\, ]+)$regx{volumePrefix}$regx{optionalSpace}$regx{volume}\, $regx{editorSuffix}([\.\:]?) ([^<>\.\,]+?[^<>4-9]+?)\, $regx{pagePrefix}$regx{optionalSpace}$regx{page}\. <(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt><i>$5<\/i><\/bt>$6<edn>$7<\/edn>$8 $9$10$11$12<v>$13<\/v>\, $14$15 <edrg>$16<\/edrg>\, $17$18<pg>$19<\/pg>\. <$20>/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<i>([^<>]+?)<\/i>([\?\.\,\; ]+)$regx{edn}$regx{numberSuffix}([\.]?) $regx{ednSuffix}([\.\, ]+)$regx{volumePrefix}$regx{optionalSpace}$regx{volume}\, $regx{editorSuffix}([\.\:]?) ([^<>\.\,]+?[^<>4-9]+?)\, $regx{page}\. <(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt><i>$5<\/i><\/bt>$6<edn>$7<\/edn>$8$9 $10$11$12$13<v>$14<\/v>\, $15$16 <edrg>$17<\/edrg>\, <pg>$18<\/pg>\. <$19>/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<i>([^<>]+?)<\/i>([\?\.\,\; ]+)$regx{edn}([\.]?) $regx{ednSuffix}([\.\, ]+)$regx{volumePrefix}$regx{optionalSpace}$regx{volume}\, $regx{editorSuffix}([\.\:]?) ([^<>\.\,]+?[^<>4-9]+?)\, $regx{page}\. <(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt><i>$5<\/i><\/bt>$6<edn>$7<\/edn>$8 $9$10$11$12<v>$13<\/v>\, $14$15 <edrg>$16<\/edrg>\, <pg>$17<\/pg>\. <$18>/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<i>([^<>]+?)<\/i>([\?\.\,\; ]+)$regx{volumePrefix}$regx{optionalSpace}$regx{volume}\, $regx{editorSuffix}([\.\:]?) ([^<>\.\,]+?[^<>4-9]+?)\, $regx{page}\. <(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt><i>$5<\/i><\/bt>$6$7$8<v>$9<\/v>\, $10$11 <edrg>$12<\/edrg>\, <pg>$13<\/pg>\. <$14>/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<i>([^<>]+?)<\/i>([\?\.\,\; ]+)$regx{volumePrefix}$regx{optionalSpace}$regx{volume}\.$regx{volume}([\.]?)\, $regx{editorSuffix}([\.\:]?) ([^<>\.\,]+?[^<>4-9]+?)\, $regx{page}\. <(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt><i>$5<\/i><\/bt>$6$7$8<v>$9\.$10<\/v>$11\, $12$13 <edrg>$14<\/edrg>\, <pg>$15<\/pg>\. <$16>/gs;

  #Fürstenberg, Friedrich. 1961. Art. Religionssoziologie. In<i> Religion in Geschichte und Gegenwart</i>, <span style='color:red'>3. Aufl., Hrsg. Friedrich Fürstenberg, pp. 1027-1032</span>. Tübingen: Mohr,
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<i>([^<>]+?)<\/i>([\?\.\,\; ]+)$regx{edn}$regx{numberSuffix}([\.]?) $regx{ednSuffix}\, $regx{editorSuffix}([\.\:]?) ([^<>\.\,]+?[^<>4-9]+?)\, $regx{pagePrefix}$regx{optionalSpace}$regx{page}\. <(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt><i>$5<\/i><\/bt>$6<edn>$7<\/edn>$8$9 $10\, $11$12 <edrg>$13<\/edrg>\, $14$15<pg>$16<\/pg>\. <$17>/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<i>([^<>]+?)<\/i>([\?\.\,\; ]+)$regx{edn}$regx{numberSuffix}([\.]?) $regx{ednSuffix}\, $regx{editorSuffix}([\.\:]?) ([^<>\.\,]+?[^<>4-9]+?)\, $regx{page}\. <(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt><i>$5<\/i><\/bt>$6<edn>$7<\/edn>$8$9 $10\, $11$12 <edrg>$13<\/edrg>\, <pg>$14<\/pg>\. <$15>/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<i>([^<>]+?)<\/i>([\?\.\,\; ]+)$regx{edn}([\.]?) $regx{ednSuffix}\, $regx{editorSuffix}([\.\:]?) ([^<>\.\,]+?[^<>4-9]+?)\, $regx{pagePrefix}$regx{optionalSpace}$regx{page}\. <(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt><i>$5<\/i><\/bt>$6<edn>$7<\/edn>$8 $9\, $10$11 <edrg>$12<\/edrg>\, $13$14<pg>$15<\/pg>\. <$16>/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<i>([^<>]+?)<\/i>([\?\.\,\; ]+)$regx{edn}([\.]?) $regx{ednSuffix}\, $regx{editorSuffix}([\.\:]?) ([^<>\.\,]+?[^<>4-9]+?)\, $regx{page}\. <(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt><i>$5<\/i><\/bt>$6<edn>$7<\/edn>$8 $9\, $10$11 <edrg>$12<\/edrg>\, <pg>$13<\/pg>\. <$14>/gs;

  #Horkheimer, Max. 1971. Bemerkungen zur Liberalisierung der Religion. In <i>Hat die Religion Zukunft?</i>, <span style='color:red'>Hrsg. Oskar Schatz, 113-119.</span> Graz: Styria.
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<i>([^<>]+?)<\/i>([\?\.\,\; ]+) $regx{editorSuffix}([\.\:]?) $regx{mAuthorFullFirstName}([\,]?) $regx{mAuthorFullSirName}\, $regx{page}\. <(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt><i>$5<\/i><\/bt>$6 $7$8 <edrg>$9$10 $11<\/edrg>\, <pg>$12<\/pg>\. <$13>/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<i>([^<>]+?)<\/i>([\?\.\,\; ]+) $regx{editorSuffix}([\.\:]?) $regx{mAuthorFullFirstName}([\,]?) $regx{mAuthorFullSirName}([\,\;]) ([^<>\.\,]+?[^<>4-9]+?)\, $regx{page}\. <(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt><i>$5<\/i><\/bt>$6 $7$8 <edrg>$9$10 $11$12 $13<\/edrg>\, <pg>$14<\/pg>\. <$15>/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<i>([^<>]+?)<\/i>([?\.\,\; ]+) $regx{editorSuffix}([\.\:]?) $regx{mAuthorFullFirstName}([\,]?) $regx{mAuthorFullSirName}([\,\;]?) $regx{and} ([^<>\.\,]+?[^<>4-9]+?)\, $regx{page}\. <(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt><i>$5<\/i><\/bt>$6 $7$8 <edrg>$9$10 $11$12 $13 $14<\/edrg>\, <pg>$15<\/pg>\. <$16>/gs;


  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<i>([^<>]+?)<\/i>([\?\.\,\; ]+) $regx{editorSuffix}([\.\:]?) $regx{mAuthorFullSirName}([\,]?) $regx{mAuthorFullFirstName}\, $regx{page}\. <(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt><i>$5<\/i><\/bt>$6 $7$8 <edrg>$9$10 $11<\/edrg>\, <pg>$12<\/pg>\. <$13>/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<i>([^<>]+?)<\/i>([\?\.\,\; ]+) $regx{editorSuffix}([\.\:]?) $regx{mAuthorFullSirName}([\,]?) $regx{mAuthorFullFirstName}([\,\;]) ([^<>\.\,]+?[^<>4-9]+?)\, $regx{page}\. <(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt><i>$5<\/i><\/bt>$6 $7$8 <edrg>$9$10 $11$12 $13<\/edrg>\, <pg>$14<\/pg>\. <$15>/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<i>([^<>]+?)<\/i>([?\.\,\; ]+) $regx{editorSuffix}([\.\:]?) $regx{mAuthorFullFirstName}([\,]?) $regx{mAuthorFullSirName}([\,\;]?) $regx{and} ([^<>\.\,]+?[^<>4-9]+?)\, $regx{page}\. <(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt><i>$5<\/i><\/bt>$6 $7$8 <edrg>$9$10 $11$12 $13 $14<\/edrg>\, <pg>$15<\/pg>\. <$16>/gs;


  #</yr>). Major immediate-early enhancer. In Cytomegaloviruses: molecular biology, M. J. Reddehase, ed. (<cny>
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}([^<>\,]+?)\, $regx{firstName}([\,]?) $regx{mAuthorString}([\,]) $regx{firstName}([\,]?) $regx{mAuthorFullSirName}\, $regx{editorSuffix}([\.\,\; \(]+)<(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt>$5<\/bt>\, <edrg>$6$7 $8$9 $10$11 $12<\/edrg>\, $13$14<$15>/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}([^<>\,]+?)\, $regx{firstName}([\,]?) $regx{mAuthorString}([\,]?) $regx{and} $regx{firstName}([\,]?) $regx{mAuthorFullSirName}\, $regx{editorSuffix}([\.\,\; \(]+)<(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt>$5<\/bt>\, <edrg>$6$7 $8$9 $10 $11$12 $13<\/edrg>\, $14$15<$16>/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}([^<>\,]+?)\, $regx{firstName}([\,]?) $regx{mAuthorString}\, $regx{editorSuffix}([\.\,\; \(]+)<(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt>$5<\/bt>\, <edrg>$6$7 $8<\/edrg>\, $9$10<$11>/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}([^<>\,]+?)\, $regx{mAuthorFullSirName}([\,]?) $regx{firstName}\, $regx{editorSuffix}([\.\,\; \(]+)<(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt>$5<\/bt>\, <edrg>$6$7 $8<\/edrg>\, $9$10<$11>/gs;


  #Bose, S., and Banerjee, A.K. (2006) Viral Defense Mechanisms. In: The Interferons, Meager, A., Ed., Wiley-VCH Verlag GmbH & Co. KgaA, pp.&nbsp;227-273, Weinheim
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<edrg>([^<>\,\.]+?)\, $regx{mAuthorString}([\,]?) $regx{firstName}\, $regx{mAuthorFullSirName}([\,]?) $regx{firstName}([\,\.])<\/edrg> $regx{editorSuffix}([\.\,\; ]+?)<(pbl|cny)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt>$5<\/bt>\, <edrg>$6$7 $8\, $9$10 $11$12<\/edrg> $13$14<$15>/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<edrg>([^<>\,\.]+?)\, $regx{mAuthorString}([\,]?) $regx{firstName}([\,\.])<\/edrg> $regx{editorSuffix}([\.\,\; ]+?)<(pbl|cny)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt>$5<\/bt>\, <edrg>$6$7 $8$9<\/edrg> $10$11<$12>/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<edrg>([^<>\,\.]+?)\, $regx{firstName}([\,]?) $regx{mAuthorString}\, $regx{firstName}([\,]?) $regx{mAuthorFullSirName}([\,\.])<\/edrg> $regx{editorSuffix}([\.\,\; ]+?)<(pbl|cny)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt>$5<\/bt>\, <edrg>$6$7 $8\, $9$10 $11$12<\/edrg> $13$14<$15>/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<edrg>([^<>\,\.]+?)\, $regx{firstName}([\,]?) $regx{mAuthorString}([\,\.])<\/edrg> $regx{editorSuffix}([\.\,\; ]+?)<(pbl|cny)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt>$5<\/bt>\, <edrg>$6$7 $8$9<\/edrg> $10$11<$12>/gs;


  #</yr>. Nephrogenic diabetes insipidus. In <edrg>The Metabolic and Molecular Bases of Inherited Disease. C.R. Scriver, A.L. Beaudet, and B. Vogelstein,</edrg> editors. <cny>
  #</yr>). Analogies of language to life. In <edrg>The Scientist Speculates. J. J. Good, and J. Maynard-Smith</edrg>, (Eds.), <cny>
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<edrg>([^<>\,\.]+?)\. $regx{firstName}([\,]?) $regx{mAuthorString}([\,]?) $regx{firstName}([\,]?) $regx{mAuthorString}([\,]?) $regx{and} $regx{firstName}([\,]?) $regx{mAuthorString}([\.\,]?)<\/edrg>([\.\, \(]+)$regx{editorSuffix}([\)\.\,\:\; ]+)(<cny>|<pbl>|[pPS\.]+ <pg>|[pPS\.]+ [0-9]+)/<\/$1>$2<misc1>$3<\/misc1>$4<bt>$5<\/bt>\. <edrg>$6$7 $8$9 $10$11 $12$13 $14 $15$16 $17$18<\/edrg>$19$20$21$22/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<edrg>([^<>\,\.]+?)\. $regx{firstName}([\,]?) $regx{mAuthorString}([\,]?) $regx{firstName}([\,]?) $regx{mAuthorString}([\,]?) $regx{firstName}([\,]?) $regx{mAuthorString}([\.\,]?)<\/edrg>([\.\, \(]+)$regx{editorSuffix}([\)\.\,\:\; ]+)(<cny>|<pbl>|[pPS\.]+ <pg>|[pPS\.]+ [0-9]+)/<\/$1>$2<misc1>$3<\/misc1>$4<bt>$5<\/bt>\. <edrg>$6$7 $8$9 $10$11 $12$13 $14$15 $16$17<\/edrg>$18$19$20$21/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<edrg>([^<>\,\.]+?)\. $regx{firstName}([\,]?) $regx{mAuthorString}([\,]?) $regx{and} $regx{firstName}([\,]?) $regx{mAuthorString}([\.\,]?)<\/edrg>([\.\, \(]+)$regx{editorSuffix}([\)\.\,\:\; ]+)(<cny>|<pbl>|[pPS\.]+ <pg>|[pPS\.]+ [0-9]+)/<\/$1>$2<misc1>$3<\/misc1>$4<bt>$5<\/bt>\. <edrg>$6$7 $8$9 $10 $11$12 $13$14<\/edrg>$15$16$17$18/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<edrg>([^<>\,\.]+?)\. $regx{firstName}([\,]?) $regx{mAuthorString}([\,]?) $regx{firstName}([\,]?) $regx{mAuthorString}([\.\,]?)<\/edrg>([\.\, \(]+)$regx{editorSuffix}([\)\.\,\:\; ]+)(<cny>|<pbl>|[pPS\.]+ <pg>|[pPS\.]+ [0-9]+)/<\/$1>$2<misc1>$3<\/misc1>$4<bt>$5<\/bt>\. <edrg>$6$7 $8$9 $10$11 $12$13<\/edrg>$14$15$16$17/gs;
 $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<edrg>([^<>\,\.]+?)\. $regx{firstName}([\,]?) $regx{mAuthorString}([\.\,]?)<\/edrg>([\.\, \(]+)$regx{editorSuffix}([\)\.\,\:\; ]+)(<cny>|<pbl>|[pPS\.]+ <pg>|[pPS\.]+ [0-9]+)/<\/$1>$2<misc1>$3<\/misc1>$4<bt>$5<\/bt>\. <edrg>$6$7 $8$9<\/edrg>$10$11$12$13/gs;


  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<edrg>([^<>\,\.]+?)\. $regx{mAuthorString}([\,]?) $regx{firstName}([\,]?) $regx{and} $regx{mAuthorString}([\,]?) $regx{firstName}([\.\,]?)<\/edrg>([\.\, \(]+)$regx{editorSuffix}([\)\.\,\:\; ]+)(<cny>|<pbl>|[pPS\.]+ <pg>|[pPS\.]+ [0-9]+)/<\/$1>$2<misc1>$3<\/misc1>$4<bt>$5<\/bt>\. <edrg>$6$7 $8$9 $10 $11$12 $13$14<\/edrg>$15$16$17$18/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<edrg>([^<>\,\.]+?)\. $regx{mAuthorString}([\,]?) $regx{firstName}([\,]?) $regx{mAuthorString}([\,]?) $regx{firstName}([\.\,]?)<\/edrg>([\.\, \(]+)$regx{editorSuffix}([\)\.\,\:\; ]+)(<cny>|<pbl>|[pPS\.]+ <pg>|[pPS\.]+ [0-9]+)/<\/$1>$2<misc1>$3<\/misc1>$4<bt>$5<\/bt>\. <edrg>$6$7 $8$9 $10$11 $12$13<\/edrg>$14$15$16$17/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<edrg>([^<>\,\.]+?)\. $regx{mAuthorString}([\,]?) $regx{firstName}([\.\,]?)<\/edrg>([\.\, \(]+)$regx{editorSuffix}([\)\.\,\:\; ]+)(<cny>|<pbl>|[pPS\.]+ <pg>|[pPS\.]+ [0-9]+)/<\/$1>$2<misc1>$3<\/misc1>$4<bt>$5<\/bt>\. <edrg>$6$7 $8$9<\/edrg>$10$11$12$13/gs;


  #</yr>) Modelling pasture and animal production. In <edrg>Field and Laboratory Methods.</edrg> Eds. L Mannetje, RM Jones. pp 29--66.
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<edrg>([^<>\,\.]+?)\.<\/edrg> $regx{editorSuffix}([\.\:]?) $regx{firstName}([\,]?) $regx{mAuthorString}([\,]?) $regx{firstName}([\,]?) $regx{mAuthorString}([\,]?) $regx{firstName}([\,]?) $regx{mAuthorString}([\)\.\,\:\; ]+)(<cny>|<pbl>|[pPS\.]+ <pg>|[pPS\.]+ [0-9]+)/<\/$1>$2<misc1>$3<\/misc1>$4<bt>$5<\/bt>\. $6$7 <edrg>$8$9 $10$11 $12$13 $14$15 $16$17 $18<\/edrg>$19$20/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<edrg>([^<>\,\.]+?)\.<\/edrg> $regx{editorSuffix}([\.\:]?) $regx{firstName}([\,]?) $regx{mAuthorString}([\,]?) $regx{firstName}([\,]?) $regx{mAuthorString}([\,]?) $regx{and} $regx{firstName}([\,]?) $regx{mAuthorString}([\)\.\,\:\; ]+)(<cny>|<pbl>|[pPS\.]+ <pg>|[pPS\.]+ [0-9]+)/<\/$1>$2<misc1>$3<\/misc1>$4<bt>$5<\/bt>\. $6$7 <edrg>$8$9 $10$11 $12$13 $14$15 $16 $17$18 $19<\/edrg>$20$21/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<edrg>([^<>\,\.]+?)\.<\/edrg> $regx{editorSuffix}([\.\:]?) $regx{firstName}([\,]?) $regx{mAuthorString}([\,]?) $regx{firstName}([\,]?) $regx{mAuthorString}([\)\.\,\:\; ]+)(<cny>|<pbl>|[pPS\.]+ <pg>|[pPS\.]+ [0-9]+)/<\/$1>$2<misc1>$3<\/misc1>$4<bt>$5<\/bt>\. $6$7 <edrg>$8$9 $10$11 $12$13 $14<\/edrg>$15$16/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<edrg>([^<>\,\.]+?)\.<\/edrg> $regx{editorSuffix}([\.\:]?) $regx{firstName}([\,]?) $regx{mAuthorString}([\,]?) $regx{and} $regx{firstName}([\,]?) $regx{mAuthorString}([\)\.\,\:\; ]+)(<cny>|<pbl>|[pPS\.]+ <pg>|[pPS\.]+ [0-9]+)/<\/$1>$2<misc1>$3<\/misc1>$4<bt>$5<\/bt>\. $6$7 <edrg>$8$9 $10$11 $12 $13$14 $15<\/edrg>$16$17/gs;
  $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]* )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<edrg>([^<>\,\.]+?)\.<\/edrg> $regx{editorSuffix}([\.\:]?) $regx{firstName}([\,]?) $regx{mAuthorFullSirName}([\)\.\,\:\; ]+)(<cny>|<pbl>|[pPS\.]+ <pg>|[pPS\.]+ [0-9]+)/<\/$1>$2<misc1>$3<\/misc1>$4<bt>$5<\/bt>\. $6$7 <edrg>$8$9 $10<\/edrg>$11$12/gs;


  return $$TextBody;
}



sub bookItalicEditorWithoutEds{
  my $TextBody=shift;


  #Horkheimer, Max. 1988. Die Juden und Europa. 1939. In <i>Gesammelte Werke,</i> <span style='color:red'>Bd. 4, Max Horkheimer, 308-331</span>. Frankfurt a. M.: Fischer.
   $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]? )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<i>([^<>]+?)<\/i>([\?\.\,\; ]+)$regx{volumePrefix}$regx{optionalSpace}$regx{volume}\, ([^<>\.\,]+?[^<>4-9]+?)\, $regx{pagePrefix}$regx{optionalSpace}$regx{page}\. <(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt><i>$5<\/i><\/bt>$6$7$8<v>$9<\/v>\, <edrg>$10<\/edrg>\, $11$12<pg>$13<\/pg>\. <$14>/gs;
   $$TextBody=~s/<\/(yr|aug|ia)>([\.\,\)]? )([^<>\.\,]+?[^<>]+?)$regx{INwithSpace}<i>([^<>]+?)<\/i>([\?\.\,\; ]+)$regx{volumePrefix}$regx{optionalSpace}$regx{volume}\, ([^<>\.\,]+?[^<>4-9]+?)\, $regx{page}\. <(cny|pbl)>/<\/$1>$2<misc1>$3<\/misc1>$4<bt><i>$5<\/i><\/bt>$6$7$8<v>$9<\/v>\, <edrg>$10<\/edrg>\, <pg>$11<\/pg>\. <$12>/gs;

#  print $$TextBody;exit;
  return $$TextBody;
}



#===============================================================

sub bookEditorWithParen{
  my $TextBody=shift;
  my $InPrefix='([\,\.] [Ii]n[\:\.\, ]+| [Ii]n[\:\.] +|\. In\b)';
  my $editedBy='([Ee]dited [bB]y|\b[Ee]d[s]?[\.]? [Bb]y)';


  $$TextBody=~s/$InPrefix<edrg>([^<>]+?)<\/edrg> $regx{ednSuffix}\. \($regx{editorSuffix}([\:\. ]+)([^<>\(\)]+?)\)/$1$2 $3\. \($4$5$6\)/gs;

 #In: <i>Fields Virology</i>, 2nd ed. (eds. Fields BN and Knipe DM.)
  $$TextBody=~s/$InPrefix<i>([^<>]+?)<\/i>([\.\, ]+)$regx{edn}$regx{numberSuffix} $regx{ednSuffix}([\.\, ]+)\($regx{editorSuffix}([\:\. ]+)([^<>\(\)]+?)\)/$1<bt><i>$2<\/i><\/bt>$3<edn>$4<\/edn>$5 $6$7\($8$9<edrg>$10<\/edrg>\)/gs;
  $$TextBody=~s/$InPrefix<i>([^<>]+?)<\/i>([\.\, ]+)$regx{edn}([\.]?) $regx{ednSuffix}([\.\, ]+)\($regx{editorSuffix}([\:\. ]+)([^<>\(\)]+?)\)/$1<bt><i>$2<\/i><\/bt>$3<edn>$4<\/edn>$5 $6$7\($8$9<edrg>$10<\/edrg>\)/gs;

  # In: encyclopedia of Research Design (edited by Neil Salkind). <pbl>
  $$TextBody=~s/$InPrefix([^<>]+?)([\.\, ]+)\($editedBy([\:\. ]+)([^<>\(\)]+?)\)([\,\. ]+)<(cny|pbl|yr)>/$1<bt>$2<\/bt>$3\($4$5<edrg>$6<\/edrg>\)$7<$8>/g; 
  $$TextBody=~s/$InPrefix([^<>]+?)([\.\, ]+)\($editedBy([\:\. ]+)([^<>\(\)]+?)\)([\,\. ]+)$regx{pagePrefix}$regx{optionalSpace}<(pg)>/$1<bt>$2<\/bt>$3\($4$5<edrg>$6<\/edrg>\)$7$8$9<$10>/g; 
  $$TextBody=~s/$InPrefix([^<>]+?)([\.\, ]+)\($editedBy([\:\. ]+)([^<>\(\)]+?)\)([\,\. ]+)<(pg)>/$1<bt>$2<\/bt>$3\($4$5<edrg>$6<\/edrg>\)$7<$8>/g;
  $$TextBody=~s/$InPrefix([^<>]+?)([\.\, ]+)\($editedBy([\:\. ]+)([^<>\(\)]+?)\)([\,\. ]+)$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{pagePunc}<(pbl|cny)>/$1<bt>$2<\/bt>$3\($4$5<edrg>$6<\/edrg>\)$7$8$9<pg>$10<\/pg>$11<$12>/g; 
  $$TextBody=~s/$InPrefix([^<>]+?)([\.\, ]+)\($editedBy([\:\. ]+)([^<>\(\)]+?)\)([\,\. ]+)$regx{page}$regx{pagePunc}<(pbl|cny)>/$1<bt>$2<\/bt>$3\($4$5<edrg>$6<\/edrg>\)$7<pg>$8<\/pg>$9<$10>/g; 

  #. In Cities (ed. S. American, pp. 156-174). <cny>
  $$TextBody=~s/$InPrefix([^<>]+?)([\.\, ]+)\($regx{editorSuffix}([\:\. ]+)([^<>\(\)]+?)([\,\. ]+)$regx{pagePrefix}$regx{optionalSpace}$regx{page}([\.]?)\)([\,\. ]+)<(cny|pbl|yr)>/$1<bt>$2<\/bt>$3\($4$5<edrg>$6<\/edrg>$7$8$9<pg>$10<\/pg>$11\)$12<$13>/g; 
  $$TextBody=~s/$InPrefix([^<>]+?)([\.\, ]+)\($regx{editorSuffix}([\:\. ]+)([^<>\(\)]+?)([\,\. ]+)$regx{pageRange}([\.]?)\)([\,\. ]+)<(cny|pbl|yr)>/$1<bt>$2<\/bt>$3\($4$5<edrg>$6<\/edrg>$7<pg>$8<\/pg>$9\)$10<$11>/g; 
  $$TextBody=~s/$InPrefix<i>([^<>]+?)<\/i>([\.\, ]*)\($regx{editorSuffix}([\,\. ]+)([^<>\(\)]+?)([\,\. ]+)$regx{pagePrefix}$regx{optionalSpace}$regx{page}([\.]?)\)/$1<bt><i>$2<\/i><\/bt>$3\($4$5<edrg>$6<\/edrg>$7$8$9<pg>$10<\/pg>$11\)/gs;
  $$TextBody=~s/$InPrefix<i>([^<>]+?)<\/i>([\.\, ]+)\($regx{editorSuffix}([\:\. ]+)([^<>\(\)]+?)([\,\. ]+)$regx{pageRange}([\.]?)\)/$1<bt><i>$2<\/i><\/bt>$3\($4$5<edrg>$6<\/edrg>$7<pg>$8<\/pg>$9\)/g; 

  #. In: Structural and functional aspects of transport in roots (Eds: Loughman, B.C., Gašparparíková, O., Kolek, J.,), <pbl>Kluwer</pbl>
  $$TextBody=~s/$InPrefix([^<>]+?)([\.\, ]+)\($regx{editorSuffix}([\:\. ]+)([^<>\(\)]+?)\)([\,\. ]+)<(cny|pbl|yr)>/$1<bt>$2<\/bt>$3\($4$5<edrg>$6<\/edrg>\)$7<$8>/g; 
  $$TextBody=~s/$InPrefix([^<>]+?)([\.\, ]+)\($regx{editorSuffix}([\:\. ]+)([^<>\(\)]+?)\)([\,\. ]+)$regx{pagePrefix}$regx{optionalSpace}<(pg)>/$1<bt>$2<\/bt>$3\($4$5<edrg>$6<\/edrg>\)$7$8$9<$10>/g; 
  $$TextBody=~s/$InPrefix([^<>]+?)([\.\, ]+)\($regx{editorSuffix}([\:\. ]+)([^<>\(\)]+?)\)([\,\. ]+)<(pg)>/$1<bt>$2<\/bt>$3\($4$5<edrg>$6<\/edrg>\)$7<$8>/g;
  $$TextBody=~s/$InPrefix([^<>]+?)([\.\, ]+)\($regx{editorSuffix}([\:\. ]+)([^<>\(\)]+?)\)([\,\. ]+)$regx{pagePrefix}$regx{optionalSpace}$regx{page}$regx{pagePunc}<(pbl|cny)>/$1<bt>$2<\/bt>$3\($4$5<edrg>$6<\/edrg>\)$7$8$9<pg>$10<\/pg>$11<$12>/g; 
  $$TextBody=~s/$InPrefix([^<>]+?)([\.\, ]+)\($regx{editorSuffix}([\:\. ]+)([^<>\(\)]+?)\)([\,\. ]+)$regx{page}$regx{pagePunc}<(pbl|cny)>/$1<bt>$2<\/bt>$3\($4$5<edrg>$6<\/edrg>\)$7<pg>$8<\/pg>$9<$10>/g; 

  $$TextBody=~s/$InPrefix<i>([^<>]+?)<\/i>([\.\, ]+)\($regx{editorSuffix}([\:\. ]+)([^<>\(\)]+?)\)/$1<bt><i>$2<\/i><\/bt>$3\($4$5<edrg>$6<\/edrg>\)/g; 


  return $$TextBody;
}




return 1;


