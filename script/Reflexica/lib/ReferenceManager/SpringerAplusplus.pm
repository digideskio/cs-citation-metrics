#version 1.0.4
#Author: Neyaz Ahmad
package ReferenceManager::SpringerAplusplus;
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(SpringerAplusplusXML);
use ReferenceManager::sortTag2XML;

#shortTagtoXml
###################################################################################################################################################
sub SpringerAplusplusXML
    {
	my $TextBody=shift;
	my $XMLtype=shift;

	my $SCRITPATH=$0;
	$SCRITPATH=~s/(.*)([\/\\])(.*?)\.(pl|exe)/$1/g;
	my $XMLTagIniLocation="${SCRITPATH}\/XMLTag\.ini";	#XMLTag.ini
	my $short2Xmltags=&LoadXMLTagIni($XMLTagIniLocation, $XMLtype);

	while($TextBody=~/<bib([^<>]*?)>((?:(?!<\/bib>)(?!<bib[^<>]*?>).)*?)<\/bib>/s)
	  {

	    my $bibattribute="$1";
	    my $BibText="$2";
	    my $PlainBibText="$BibText";
	    # print "IDDD: $bibattribute\nBIBTEXT: $BibText\nPLAINTEXT: $PlainBibText\n";
	    $BibText=~s/<aug>//gs;
	    $BibText=~s/<\/aug>//gs;
	    $BibText=~s/<edrg>//gs;
	    $BibText=~s/<\/edrg>//gs;
	    $BibText=~s/<\!\-\- QAu(.*?)\-\->//gs;
	    $BibText=~s/<url>([^<>]*?)<\/url>//gs;

	    $BibText=~s/<i><bt>((?:(?!<bt>)(?!<\/bt>).)*)<\/bt><\/i><bt>/<bt><i>$1<\/i>/gs;
	    $BibText=~s/<\/(aus|auf|aum|eds|edm|edf|au|aug|edr|edrg|iss|at|pt|cny|cty|pbl|pg|v|yr|url|ia|misc1|issn|isbn|coden|doi|edn|collab|bt|proc|suffix|par|rpt|thesis|pat|org|eml|pco|pbo|st|rol|tel|fax|number|petemp|comment)><\1>/<\/$1><$1>/gs;
	    $BibText=~s/<(aus|auf|aum|eds|edm|edf|au|aug|edr|edrg|iss|at|pt|cny|cty|pbl|pg|v|yr|url|ia|misc1|issn|isbn|coden|doi|edn|collab|bt|proc|suffix|par|rpt|thesis|pat|org|eml|pco|pbo|st|rol|tel|fax|number|petemp|comment)><\/i><\/\1>/<\/i>/gs;
	    $BibText=~s/<(aus|auf|aum|eds|edm|edf|au|aug|edr|edrg|iss|at|pt|cny|cty|pbl|pg|v|yr|url|ia|misc1|issn|isbn|coden|doi|edn|collab|bt|proc|suffix|par|rpt|th
esis|pat|org|eml|pco|pbo|st|rol|tel|fax|number|petemp|comment)><i>((?:(?!<i>)(?!<\/i>).)*)<\/\1>/<i><$1>$2<\/$1>/gs;

	    #</aus></au><aus>&#x00F6;</aus><au><aus>
	    $BibText=~s/<\/(aus|eds|auf|edm)><\/au><\1>\&\#x([a-zA-Z0-9]+)\;<\/\1><au><\1>/\&\#x$2\;/gs;
	    $BibText=~s/<\/(aus|auf|aum|eds|edm|edf|au|aug|edr|edrg|iss|at|pt|cny|cty|pbl|pg|v|yr|url|ia|misc1|issn|isbn|coden|doi|edn|collab|bt|proc|suffix|par|rpt|thesis|pat|org|eml|pco|pbo|st|rol|tel|fax|number|petemp|comment)><\1>\&\#x([a-zA-Z0-9]+)\;<\/\1><\1>/\&\#x$2\;/gs;
	    $BibText=~s/<\/(aus|auf|aum|eds|edm|edf|au|aug|edr|edrg|iss|at|pt|cny|cty|pbl|pg|v|yr|url|ia|misc1|issn|isbn|coden|doi|edn|collab|bt|proc|suffix|par|rpt|thesis|pat|org|eml|pco|pbo|st|rol|tel|fax|number|petemp|comment)><\1>\&\#x([a-zA-Z0-9]+)\;/\&\#x$2\;/gs;

	    $BibText=~s/<\/au><au>([\,\; ]+)/$1/gs;
	    $BibText=~s/<\/edr><edr>([\,\; ]+)/$1/gs;
	    #print "$BibText\n";
	    $BibText=~s/<\/bt><bt>//gs;

	    $bibattribute=~s/id=\"bib/ID=\"CR/gs;
	    $bibattribute=~s/id=\"/ID=\"/gs;

	    $PlainBibText=~s/<(i|b|u|sup|sub|number|url)>/&$1\;/gs;
	    $PlainBibText=~s/<\/(i|b|u|sup|sub|number|url)>/&\/$1\;/gs;
	    $PlainBibText=~s/<([a-zA-Z0-9]+)>//gs;
	    $PlainBibText=~s/<\/([a-zA-Z0-9]+)>//gs;
	    $PlainBibText=~s/\&(i|b|u|sup|sub|number|url)\;/<$1>/gs;
	    $PlainBibText=~s/&\/(i|b|u|sup|sub|number|url)\;/<\/$1>/gs;
	    $PlainBibText=~s/^(.*)$/<BibUnstructured>$1<\/BibUnstructured>/os;

	    $BibText=&shortTagtoXml($BibText, $short2Xmltags);

	    ${BibText}=~s/<i><(BookTitle|ArticleTitle|JournalTitle|VolumeID|IssueID|PublisherLocation|PublisherName)>(.*?)<\/(BookTitle|ArticleTitle|JournalTitle|VolumeID|IssueID|PublisherLocation|PublisherName)><\/i>/<$1>$2<\/$3>/gs;
	    ${BibText}=~s/<b><(BookTitle|ArticleTitle|JournalTitle|VolumeID|IssueID|PublisherLocation|PublisherName)>(.*?)<\/(BookTitle|ArticleTitle|JournalTitle|VolumeID|IssueID|PublisherLocation|PublisherName)><\/b>/<$1>$2<\/$3>/gs;
	    ${BibText}=~s/<(BookTitle|ArticleTitle|JournalTitle|VolumeID|IssueID|PublisherLocation|PublisherName)><i>((?:(?!<i>)(?!<\/i>).)*)<\/i><\/(BookTitle|ArticleTitle|JournalTitle|VolumeID|IssueID|PublisherLocation|PublisherName)>/<$1>$2<\/$3>/gs;
	    ${BibText}=~s/<(BookTitle|ArticleTitle|JournalTitle|VolumeID|IssueID|PublisherLocation|PublisherName)><b>((?:(?!<b>)(?!<\/b>).)*)<\/b><\/(BookTitle|ArticleTitle|JournalTitle|VolumeID|IssueID|PublisherLocation|PublisherName)>/<$1>$2<\/$3>/gs;

	    ${BibText}=~s/([\.\,\; ]+)$//gs;

	    if(${BibText}=~/<Year>/){
	      $BibText=&XMLelementMove($BibText); #movements
	      if(${BibText}=~/<JournalTitle>/){
		  ${BibText}=~s/<([\/]?)BibChapterDOI>/<$1BibArticleDOI>/gs;
		 # ${BibText}=~s/<\/BibChapterDOI>/<\/BibArticleDOI>/os;
		  $TextBody=~s/<bib([^<>]*?)>((?:(?!<\/bib>)(?!<bib[^<>]*?>).)*?)<\/bib>/<Citation${bibattribute}><BibArticle>${BibText}<\/BibArticle>$PlainBibText<\/Citation>/os;
		}elsif(${BibText}=~/<BookTitle>/){
		  if(${BibText}=~/<ChapterTitle>/){
		    $TextBody=~s/<bib([^<>]*?)>((?:(?!<\/bib>)(?!<bib[^<>]*?>).)*?)<\/bib>/<Citation${bibattribute}><BibChapter>${BibText}<\/BibChapter>$PlainBibText<\/Citation>/os;
		  }else{
		    ${BibText}=~s/<([\/]?)BibChapterDOI>/<$1BibBookDOI>/os;
		   # ${BibText}=~s/<\/BibChapterDOI>/<\/BibBookDOI>/os;
		    $TextBody=~s/<bib([^<>]*?)>((?:(?!<\/bib>)(?!<bib[^<>]*?>).)*?)<\/bib>/<Citation${bibattribute}><BibBook>${BibText}<\/BibBook>$PlainBibText<\/Citation>/os;
		  }
		}else{
		  $TextBody=~s/<bib([^<>]*?)>((?:(?!<\/bib>)(?!<bib[^<>]*?>).)*?)<\/bib>/<Citation${bibattribute}>$PlainBibText<\/Citation>/os;
		}
	    }
	    else{
	      $TextBody=~s/<bib([^<>]*?)>((?:(?!<\/bib>)(?!<bib[^<>]*?>).)*?)<\/bib>/<Citation${bibattribute}>$PlainBibText<\/Citation>/os;
	    }
	  }#While End

	#-----------remove punctuation
	$TextBody=~s/<Citation([^<>]*?) number=\"([0-9\.]+)\">/<Citation$1><CitationNumber>$2<\/CitationNumber>/gs;
	$TextBody=&deleteTextBetweenTags($TextBody);
	$TextBody=~s/<BibComments><\/BibComments>//gs;

	#----------formating tags
	$TextBody=~s/<sup>/<Superscript>/gs;
	$TextBody=~s/<\/sup>/<\/Superscript>/gs;
	$TextBody=~s/<sub>/<Subscript>/gs;
	$TextBody=~s/<\/sub>/<\/Subscript>/gs;

	$TextBody=~s/\&\/(i|b|u|sup|sub)\;/<\/$1>/gs;
	$TextBody=~s/\&(i|b|u|sup|sub)\;/<$1>/gs;

	 $TextBody=~s/<i>/<Emphasis Type="Italic">/gs;
	 $TextBody=~s/<b>/<Emphasis Type="Bold">/gs;
	 $TextBody=~s/<\/b>/<\/Emphasis>/gs;
	 $TextBody=~s/<\/i>/<\/Emphasis>/gs;
	$TextBody=~s/<Suffix>(van Bergen en|Vander|Van den|Van Den|Van der|Van Der|van den|van der|De|de|von|van|dos|Van|De|Jac|)([\.]*)<\/Suffix>/<Particle>$1$2<\/Particle>/gs;

	$TextBody=&XMLelementMovePost($TextBody);

	$TextBody=~s/\&amp\;/\&\#x0026\;/gs;
	if($ARGV[3]=~/^(En|De)$/){
	    my $Lang="$ARGV[3]";
	    chomp($Lang);
	    $TextBody=~s/<ArticleTitle>/<ArticleTitle Language=\"$Lang\">/gs;
	    $TextBody=~s/<ChapterTitle>/<ChapterTitle Language=\"$Lang\">/gs;
	    $TextBody=~s/<SeriesTitle>/<SeriesTitle Language=\"$Lang\">/gs;
	  }elsif($ARGV[2]=~/^(En|De)$/)
	  {
	    my $Lang="$ARGV[2]";
	    chomp($Lang);
	    $TextBody=~s/<ArticleTitle>/<ArticleTitle Language=\"$Lang\">/gs;
	    $TextBody=~s/<ChapterTitle>/<ChapterTitle Language=\"$Lang\">/gs;
	    $TextBody=~s/<SeriesTitle>/<SeriesTitle Language=\"$Lang\">/gs;
	  }else{
	    $TextBody=~s/<ArticleTitle>/<ArticleTitle Language=\"En\">/gs;
	    $TextBody=~s/<ChapterTitle>/<ChapterTitle Language=\"En\">/gs;
	    $TextBody=~s/<SeriesTitle>/<SeriesTitle Language=\"En\">/gs;
	  }
	#------arrange tag sequence

	return $TextBody;
    }
#===============================================================================================================================================
sub XMLelementMove(){
  my $BibText=shift;
  ${BibText}=~s/<BibAuthorName>(.*)<\/BibAuthorName>(.*?)<Year>([^<>]*?)<\/Year>/<BibAuthorName>$1<\/BibAuthorName><Year>$3<\/Year>$2/s;
  ${BibText}=~s/<PublisherLocation>(.*?)<\/PublisherLocation><PublisherName>(.*?)<\/PublisherName>/<PublisherName>$2<\/PublisherName><PublisherLocation>$1<\/PublisherLocation>/s;
  return $BibText;
}
#==============================================================================================================================


sub XMLelementMovePost{
  my $TextBody=shift;
  $TextBody=~s/<FamilyName>([^<>]*?)<\/FamilyName><Initials>([^<>]*?)<\/Initials>/<Initials>$2<\/Initials><FamilyName>$1<\/FamilyName>/gs;
  $TextBody=~s/<BibUnstructured>([0-9]+)\.([ ]*)/<BibUnstructured>$1\. /gs;
  $TextBody=~s/<\/Citation>([\s]*)<Citation/<\/Citation>\n<Citation/gs;
  $TextBody=~s/<Particle>([^<>]*?)<\/Particle><Initials>([^<>]*?)<\/Initials><FamilyName>([^<>]*?)<\/FamilyName>/<Initials>$2<\/Initials><FamilyName>$3<\/FamilyName><Particle>$1<\/Particle>/gs;
  $TextBody=~s/<Particle>([^<>]*?)<\/Particle><Initials>([^<>]*?)<\/Initials>/<Initials>$2<\/Initials><Particle>$1<\/Particle>/gs;
  $TextBody=~s/<Particle>([^<>]*?)<\/Particle><FamilyName>([^<>]*?)<\/FamilyName>/<FamilyName>$2<\/FamilyName><Particle>$1<\/Particle>/gs;


  $TextBody=~s/<Particle>([^<>]*?)<\/Particle><Initials>([^<>]*?)<\/Initials><FamilyName>([^<>]*?)<\/FamilyName>/<Initials>$2<\/Initials><FamilyName>$3<\/FamilyName><Particle>$1<\/Particle>/gs;
  $TextBody=~s/<Suffix>([^<>]*?)<\/Suffix><Initials>([^<>]*?)<\/Initials>/<Initials>$2<\/Initials><Suffix>$1<\/Suffix>/gs;
  $TextBody=~s/<Suffix>([^<>]*?)<\/Suffix><FamilyName>([^<>]*?)<\/FamilyName>/<FamilyName>$2<\/FamilyName><Suffix>$1<\/Suffix>/gs;
  $TextBody=~s/<PublisherLocation>([^<>]*?)<\/PublisherLocation><PublisherName>([^<>]*?)<\/PublisherName>/<PublisherName>$2<\/PublisherName><PublisherLocation>$1<\/PublisherLocation>/gs;

  $TextBody=~s/<BibUnstructured><number>([0-9\.]+)<\/number>/<BibUnstructured><CitationNumber>$1<\/CitationNumber>/gs;
  $TextBody=~s/<Citation([^<>]*?)><([A-Za-z\-]+)><CitationNumber>([0-9\.]+)<\/CitationNumber>/<Citation$1><CitationNumber>$3<\/CitationNumber><$2>/gs;
  $TextBody=~s/<\/([a-zA-Z\-\_]+)><BibUnstructured><CitationNumber>([0-9\.]+)<\/CitationNumber>/<\/$1><BibUnstructured>/gs;

  $TextBody=~s/<FirstPage>([^<>]*?)<\/FirstPage><LastPage>([^<>]*?)<\/LastPage><PublisherName>([^<>]*?)<\/PublisherName><PublisherLocation>([^<>]*?)<\/PublisherLocation>/<PublisherName>$3<\/PublisherName><PublisherLocation>$4<\/PublisherLocation><FirstPage>$1<\/FirstPage><LastPage>$2<\/LastPage>/gs;

  return $TextBody;
}

#==============================================================================================================================
sub deleteTextBetweenTags
  {
    my $TextBody=shift;


    $TextBody=~s/<\/([a-zA-Z0-9]+)>\?/\?<\/$1>/gs;
    $TextBody=~s/<\/([a-zA-Z0-9]+)>([\.\,\s]*)(et al\.|et al)([\,\:\s]*)<([a-zA-Z0-9]+)>/<\/$1><Etal\/><$5>/gs;
    $TextBody=~s/<\/([a-zA-Z0-9]+)>([\.\,\s]*)(et al\.|et al)([\,\:\s]*)<([a-zA-Z0-9]+)>/<\/$1><Etal\/><$5>/gs;
    $TextBody=~s/<\/([a-zA-Z0-9]+)>([\.\,\s]*)\(([eE]ditor[s]?[\.]?|[Ee]d[s]?[\.]?|[Hh]rsg[\.]?|[Hh]g[\.]?|red[\.]?)\)([\,\:\s]*)<([a-zA-Z0-9]+)>/<\/$1><Eds\/><$5>/gs;

    $TextBody=~s/<\/(i|b|u|sup|sub)>/\&\/$1\;/gs;
    $TextBody=~s/<(i|b|u|sup|sub)>/\&$1\;/gs;

	while($TextBody=~/<BibChapter>(.*?)<\/BibChapter>/s)
	  {
	    my $Text=$1;
	    $Text=~s/<\/([a-zA-Z0-9]+)>([^<>]*?)<([a-zA-Z0-9]+)>/<\/$1><$3>/gs;
	    $Text=~s/<\/([a-zA-Z0-9]+)>([^<>]*?)<\/([a-zA-Z0-9]+)>/<\/$1><\/$3>/gs;
	    $Text=~s/<\/([a-zA-Z0-9]+)>([^<>]*?)$/<\/$1>/gs;

	    $TextBody=~s/<BibChapter>(.*?)<\/BibChapter>/<XBibChapter>$Text<\/XBibChapter>/os;
	  }
	    $TextBody=~s/<XBibChapter>(.*?)<\/XBibChapter>/<BibChapter>$1<\/BibChapter>/gs;

	while($TextBody=~/<BibArticle>(.*?)<\/BibArticle>/s)
	  {
	    my $Text=$1;
	    $Text=~s/<\/([a-zA-Z0-9]+)>([^<>]*?)<([a-zA-Z0-9]+)>/<\/$1><$3>/gs;
	    $Text=~s/<\/([a-zA-Z0-9]+)>([^<>]*?)<\/([a-zA-Z0-9]+)>/<\/$1><\/$3>/gs;
	    $Text=~s/<\/([a-zA-Z0-9]+)>([^<>]*?)$/<\/$1>/gs;
	    $TextBody=~s/<BibArticle>(.*?)<\/BibArticle>/<XBibArticle>$Text<\/XBibArticle>/os;
	  }
	    $TextBody=~s/<XBibArticle>(.*?)<\/XBibArticle>/<BibArticle>$1<\/BibArticle>/gs;

	while($TextBody=~/<BibBook>(.*?)<\/BibBook>/s)
	  {
	    my $Text=$1;

	    $Text=~s/<\/([a-zA-Z0-9]+)>([^<>]*?)<([a-zA-Z0-9]+)>/<\/$1><$3>/gs;
	    $Text=~s/<\/([a-zA-Z0-9]+)>([^<>]*?)<\/([a-zA-Z0-9]+)>/<\/$1><\/$3>/gs;
	    $Text=~s/<\/([a-zA-Z0-9]+)>([^<>]*?)$/<\/$1>/gs;

	    $TextBody=~s/<BibBook>(.*?)<\/BibBook>/<XBibBook>$Text<\/XBibBook>/os;
	  }
	    $TextBody=~s/<XBibBook>(.*?)<\/XBibBook>/<BibBook>$1<\/BibBook>/gs;
    $TextBody=~s/\&\/(i|b|u|sup|sub)\;/<\/$1>/gs;
    $TextBody=~s/\&(i|b|u|sup|sub)\;/<$1>/gs;

    return $TextBody;
}

#==============================================================================================================================

##########################################

return 1;
