#version 1.0
#Author: Neyaz Ahmad
package ReferenceManager::TagValidation;
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(MakeOtherRef renameSpringerUnstrElement revertRenameTags);


###################################################################################################################################################
###################################################################################################################################################
sub MakeOtherRef
  {
    my $TextBody=shift;
    my $Client=shift;

    $Client=~s/$Client/\L$Client/gs;
    if($Client eq "springerlncs"){
      $TextBody=&GeneralValidation($TextBody);
      #$TextBody=&OtherRefValidation($TextBody);
    }if($Client eq "elsevier"){
      $TextBody=&GeneralValidation($TextBody);
      $TextBody=&ElsevierOtherRefValidation($TextBody);
      #$TextBody=&ElsevierTagValidation($TextBody);
    }elsif($Client eq "springer"){
      $TextBody=&GeneralValidation($TextBody);

      $TextBody=&SpringerOtherRefValidation($TextBody);
      #$TextBody=&SpringerTagValidation($TextBody); ####OFF 
    }else{
      $TextBody=&GeneralValidation($TextBody);
      $TextBody=&ElsevierOtherRefValidation($TextBody);

      #$TextBody=&OtherRefValidation($TextBody);
      #$TextBody=&SpringerTagValidation($TextBody);
    }
    return $TextBody;
  }
#====================================================================================================================================

sub SpringerTagValidation
{
  my $TextBody=shift;

  while($TextBody=~/<bib([^<>]*?)>(.*?)<\/bib>/s)
    {
      my $bibText=$2;
      $bibText=&validateSpringerMandatoryBibText($bibText);
      $TextBody=~s/<bib([^<>]*?)>(.*?)<\/bib>/<Xbib$1>$bibText<\/Xbib>/os;
    }
  $TextBody=~s/<Xbib([^<>]*?)>(.*?)<\/Xbib>/<bib$1>$2<\/bib>/gs;
  return $TextBody;
}

#======================================================================================================================================
sub ElsevierTagValidation
{
  my $TextBody=shift;

  while($TextBody=~/<bib([^<>]*?)>(.*?)<\/bib>/s)
    {
      my $bibText=$2;
      $bibText=&validateElsevierMandatoryBibText($bibText);
      $TextBody=~s/<bib([^<>]*?)>(.*?)<\/bib>/<Xbib$1>$bibText<\/Xbib>/os;
    }
  $TextBody=~s/<Xbib([^<>]*?)>(.*?)<\/Xbib>/<bib$1>$2<\/bib>/gs;
  return $TextBody;
}

#=========================================
sub validateSpringerMandatoryBibText
    {
	my $BibText=shift;
	my $tempBibText=$BibText;
	my $returnBibtext=$BibText;
	my %texttagsexist=();
	my %validtags=();

	while($tempBibText=~/<([a-zA-Z0-9]+)>/)
	    {
		my $temptags=$1;
		$texttagsexist{$temptags}="$temptags";
		$tempBibText=~s/<([a-zA-Z0-9]+)>/<#$1#>/os;
	    }
	        #print "---------$BibText=> ", keys(%texttagsexist), "---------\n";
	        #print "*****[$validtags{ArticelTags}]****";
		#print "$tempBibText\n";
	$validtags{ArticelTagsAu}=["aus", "yr", "pt", "v", "pg"];
	$validtags{ArticelTagsEds}=["eds", "yr", "pt", "v", "pg"];
	$validtags{ArticelTagsMis}=["ia", "yr",  "pt", "v", "pg"];

	$validtags{ArticelTagsAuDoi}=["aus", "yr", "pt", "doi"];
	$validtags{ArticelTagsEdsDoi}=["eds", "yr", "pt", "doi"];
	$validtags{ArticelTagsMisDoi}=["ia", "yr", "pt", "doi"];

	# $validtags{IssueTagsau}=["aus", "at", "pt", "yr", "v"];
	# $validtags{IssueTagsau}=["ia", "at", "pt", "yr", "v"];

	$validtags{ChapterTagsAu}=["aus", "eds", "yr", "misc1", "bt", "pbl", "cny"];
	$validtags{ChapterTagsEds}=["eds", "yr", "misc1", "bt", "pbl", "cny"];
	$validtags{ChapterTagsMis}=["ia", "yr", "misc1", "bt", "pbl", "cny"];

	$validtags{BookTagseds}=["eds", "yr", "bt", "pbl", "cny"];
	$validtags{BookTagsAu}=["aus", "yr", "bt", "pbl", "cny"];
	$validtags{BookTagsMis}=["ia", "yr", "bt", "pbl", "cny"];

	  exitIF: foreach my $tagtype (keys(%validtags))
	     {
	       my $arraytagref=$validtags{$tagtype};
	       #print "---$tagtype=>@$arraytagref--\n";
	       my $test="1";
	       foreach my $tag(@$arraytagref)
		 {
		   if(exists($texttagsexist{$tag})){
		     #print "Nothing: $tag\n";
		   }else{
		     $test="0";
		   }
		 }
	       if($test eq "1"){
		 $returnBibtext=$BibText;
		   last exitIF;
	       }
	       else{
		 my $temptext=$BibText;
		 $temptext=removeTags($temptext);
		 $returnBibtext=$temptext;
	       }
	     }
	return $returnBibtext;
    }
#==========================================================================================================================
sub validateElsevierMandatoryBibText
    {
	my $BibText=shift;
	my $tempBibText=$BibText;
	my $returnBibtext=$BibText;
	my %texttagsexist=();
	my %validtags=();

	while($tempBibText=~/<([a-zA-Z0-9]+)>/)
	    {
		my $temptags=$1;
		$texttagsexist{$temptags}="$temptags";
		$tempBibText=~s/<([a-zA-Z0-9]+)>/<#$1#>/os;
	    }
	        # print "---------$BibText=> ", keys(%texttagsexist), "---------\n";
	        # print "*****[$validtags{ArticelTags}]****";
		# print "$tempBibText\n";

	$validtags{ArticelTagsAuPg}=["aus", "yr", "pt", "v", "pg"];
	$validtags{ArticelTagsAuDoi}=["aus", "yr", "pt", "doi"];
	$validtags{ArticelTagsEdsPg}=["eds", "yr", "pt", "v", "pg"];
	$validtags{ArticelTagsEdsDoi}=["eds", "yr", "pt", "doi"];
	$validtags{ArticelTagsMisPg}=["ia", "yr", "pt", "v", "pg"];
	$validtags{ArticelTagsMisDoi}=["ia", "yr", "pt", "doi"];

	$validtags{ArticelTagsAuPgCollab}=["aus", "yr", "collab", "v", "pg"];
	$validtags{ArticelTagsAuDoiCollab}=["aus", "yr", "collab", "doi"];
	$validtags{ArticelTagsEdsPgCollab}=["eds", "yr", "collab", "v", "pg"];
	$validtags{ArticelTagsEdsDoiCollab}=["eds", "yr", "collab", "doi"];
	$validtags{ArticelTagsMisPgCollab}=["ia", "yr", "collab", "v", "pg"];
	$validtags{ArticelTagsMisDoiCollab}=["ia", "yr", "collab", "doi"];

	$validtags{ChapterTagsAuPbl}=["aus", "eds", "yr", "misc1", "bt", "pbl"];
	$validtags{ChapterTagsEdsPbl}=["eds", "yr", "misc1", "bt", "pbl"];
	$validtags{ChapterTagsMisPbl}=["ia", "yr", "misc1", "bt", "pbl"];

	$validtags{ChapterTagsAuCollab}=["aus", "eds", "yr", "misc1", "collab", "pbl"];
	$validtags{ChapterTagsEdsCollab}=["eds", "yr", "misc1", "collab", "pbl"];
	$validtags{ChapterTagsMisCollab}=["ia", "yr", "misc1", "collab", "pbl"];

	$validtags{ChapterTagsAuCny}=["aus", "eds", "yr", "misc1", "bt", "cny"];
	$validtags{ChapterTagsEdsCny}=["eds", "yr", "misc1", "bt", "cny"];
	$validtags{ChapterTagsMisCny}=["ia", "yr", "misc1", "bt", "cny"];

	$validtags{ChapterTagsAuCollabCny}=["aus", "eds", "yr", "misc1", "collab", "cny"];
	$validtags{ChapterTagsEdsCollabCny}=["eds", "yr", "misc1", "collab", "cny"];
	$validtags{ChapterTagsMisCollabCny}=["ia", "yr", "misc1", "collab", "cny"];

	$validtags{BookTagsEdsPbl}=["eds", "yr", "bt", "pbl"];
	$validtags{BookTagsAuPbl}=["aus", "yr", "bt", "pbl"];
	$validtags{BookTagsMisPbl}=["ia", "yr", "bt", "pbl"];
	$validtags{BookTagsEdsCny}=["eds", "yr", "bt", "cny"];
	$validtags{BookTagsAuCny}=["aus", "yr", "bt", "cny"];
	$validtags{BookTagsMisCny}=["ia", "yr", "bt", "cny"];

	$validtags{BookTagsEdsCollabPbl}=["eds", "yr", "collab", "pbl"];
	$validtags{BookTagsAuCollabPbl}=["aus", "yr", "collab", "pbl"];
	$validtags{BookTagsMisCollabPbl}=["ia", "yr", "collab", "pbl"];
	$validtags{BookTagsEdsCollabCny}=["eds", "yr", "collab", "cny"];
	$validtags{BookTagsAuCollabCny}=["aus", "yr", "collab", "cny"];
	$validtags{BookTagsMisCollabCny}=["ia", "yr", "collab", "cny"];

	$validtags{BookTagsEdsUrl}=["eds", "yr", "bt", "url"];
	$validtags{BookTagsAuUrl}=["aus", "yr", "bt", "url"];
	$validtags{BookTagsMisUrl}=["ia", "yr", "bt", "url"];

	$validtags{BookTagsEdsDoi}=["eds", "yr", "bt", "doi"];
	$validtags{BookTagsAuDoi}=["aus", "yr", "bt", "doi"];
	$validtags{BookTagsMisDoi}=["ia", "yr", "bt", "doi"];

	$validtags{BookTagsEdsCollabUrl}=["eds", "yr", "collab", "url"];
	$validtags{BookTagsAuCollabUrl}=["aus", "yr", "collab", "url"];
	$validtags{BookTagsMisCollabUrl}=["ia", "yr", "collab", "url"];

	$validtags{BookTagsEdsCollabDoi}=["eds", "yr", "collab", "doi"];
	$validtags{BookTagsAuCollabDoi}=["aus", "yr", "collab", "doi"];
	$validtags{BookTagsMisCollabDoi}=["ia", "yr", "collab", "doi"];

	$validtags{BookTagsPblCny}=["yr", "bt", "pbl", "cny"];

	$validtags{NewspaperTagsAu}=["aus", "yr", "at", "pt"];
	$validtags{NewspaperTagsEds}=["eds", "yr", "at", "pt"];
	$validtags{NewspaperTagsMis}=["ia", "yr", "at", "pt"];


	  exitIF: foreach my $tagtype (keys(%validtags))
	     {
	       my $arraytagref=$validtags{$tagtype};
	       #print "---$tagtype=>@$arraytagref--\n";
	       my $test="1";
	       foreach my $tag(@$arraytagref)
		 {
		   if(exists($texttagsexist{$tag})){
		     #print "Nothing: $tag\n";
		   }else{
		     $test="0";
		   }
		 }
	       if($test eq "1"){
		 $returnBibtext=$BibText;
		   last exitIF;
	       }
	       else{
		 my $temptext=$BibText;
		 $temptext=removeTags($temptext);
		 $returnBibtext=$temptext;
	       }
	     }
	return $returnBibtext;
    }
#==========================================================================================================================


sub GeneralValidation{
	my $TextBody=shift;
	#---------------Case 1 check <bt> ----------------------------------
	while($TextBody=~/<bib([^<>]*?)>(.*?)<\/bib>/s) {
		my $bibText=$2;
		my @checkEditorInTags=qw(bt pt at cny pbl misc1);
		foreach my $elemnt (@checkEditorInTags)	{
			$bibText=&checkEditorInTags($bibText, $elemnt);
		}
		my @checkMultipleElements=qw(yr pt at v iss pg bt cny pbl iss doi edn misc1 ia);
		foreach my $elemnt (@checkMultipleElements) {
			$bibText=&checkMultipleElements($bibText, $elemnt);
		}
	    # ######By Suman Copyeditor ignore in journal and article title
		# ($bibText, my $titalTableRef)=hideAtJt($bibText, '(at|pt)');
	
		# if($bibText=~/(Conference|Symposium|Unpublished|Proceedings|http:\/\/|https:\/\/|www\.|WWW\.)/)
		# 	{
		# 	  $bibText=&removeTags($bibText);
		# 	}
		# $bibText=&revertElements($bibText, $titalTableRef);
	
		#print "$bibText\n";
		while($bibText=~m/<aus>((?:(?!<aus>).)*)<\/aus>/g){
			my $authorgroup=$1;
			if($authorgroup=~/( and | And | und | Und | \& | with | in | du | of | at | on | or | im | am | mit | her | his | it | an | a | is | are | this | that | they | was | were | have | has | had)/){
				$bibText=&removeAllTags($bibText);
			}
			if($authorgroup=~/^\&$|^$/ || $authorgroup=~/\d/){
				$bibText=&removeAllTags($bibText);
			}
		}
		while($bibText=~m/<auf>((?:(?!<auf>).)*)<\/auf>/g){
			my $authorgroup=$1;
			if($authorgroup=~/( and | And | und | Und | \& | with | in | du | of | at | on | or | im | am | mit | her | his | it | an | a | is | are | this | that | they | was | were | have | has | had)/){
				$bibText=&removeAllTags($bibText);
			}
			if($authorgroup=~/^\&$|^$/ || $authorgroup=~/\d/){
				$bibText=&removeAllTags($bibText);
			}
		}
		while($bibText=~m/<edm>((?:(?!<edm>).)*)<\/edm>/g){
			my $authorgroup=$1;
			if($authorgroup=~/( and | And | und | Und | \& | with | in | du | of | at | on | or | im | am | mit | her | his | it | an | a | is | are | this | that | they | was | were | have | has | had)/){
				$bibText=&removeAllTags($bibText);
			}
			if($authorgroup=~/^\&$|^$/ || $authorgroup=~/\d/){
				$bibText=&removeAllTags($bibText);
			}
		}
		while($bibText=~m/<eds>((?:(?!<eds>).)*)<\/eds>/g){
			my $authorgroup=$1;
			if($authorgroup=~/( and | And | und | Und | \& | with | in | du | of | at | on | or | im | am | mit | her | his | it | an | a | is | are | this | that | they | was | were | have | has | had)/){
				$bibText=&removeAllTags($bibText);
     	    }
			if($authorgroup=~/^\&$|^$/ || $authorgroup=~/\d/) {
				$bibText=&removeAllTags($bibText);
     	    }
      	}
		##Change by Biswajit
		#if($bibText=~/<yr>/g){
		#	$bibText=&removeAllTags($bibText);
     	#}
		##END
		
		$TextBody=~s/<bib([^<>]*?)>(.*?)<\/bib>/<Xbib$1>$bibText<\/Xbib>/os;
	}
	$TextBody=~s/<Xbib([^<>]*?)>(.*?)<\/Xbib>/<bib$1>$2<\/bib>/gs;

  return $TextBody;
}


#======================================================================================================================
sub checkEditorInTags
{
  my $bibText=shift;
  my $Tag=shift;
  if ($bibText=~/<$Tag>((?:(?!<$Tag>).)*)<\/$Tag>/)
    {
      my $CheckText=$1;
      if($CheckText=~/In([\:\.\, ]*?)(.*?)\(([Ee]d[s]?[\.]?|Hg[\.]?|[Hh]rsg[.]?|[eE]ditor[s]?)\)/)
	{
	  $bibText=&removeTags($bibText);
	}
      elsif($CheckText=~/ [iI]n([\:\.]+ )(.*?)\(([Ee]d[s]?[\.]?|Hg[\.]?|[Hh]rsg[.]?|[eE]ditor[s]?)\)/)
	{
	  $bibText=&removeTags($bibText);
	}
      elsif($CheckText=~/\bIn\b([\:\.\, ]*?)(.*?)\b([Ee]d[s]?[\.]?|Hg[\.]?|[Hh]rsg[.]?|[eE]ditor[s]?)\b/)
	{
	  $bibText=&removeTags($bibText);
	}
    }
  return $bibText; 
}


#======================================================================================================================
sub checkMultipleElements
{
  my $bibText=shift;
  my $Tag=shift;
  $checkbibText=$bibText;
  my $count=$checkbibText=~s/<$Tag>//gs;
  if($count>1)
    {
      $bibText=&removeTags($bibText);
    }
  return $bibText; 
}

#======================================================================================================================
sub removeTags
     {
	 my $bibText=shift;
	 $bibText=~s/<(i|b|u|sup|sub|sb|sp)>/&$1\;/gs; 
	 $bibText=~s/<\/(i|b|u|sup|sub|sb|sp)>/&\/$1\;/gs; 
	 # $bibText=~s/<([a-zA-Z0-9]+)>//gs; 
	 # $bibText=~s/<\/([a-zA-Z0-9]+)>//gs; 
	 if($bibText=~/<aug>/)
	   {
	     $bibText=~s/<par>([^<>]*?)<\/par>([\.\,\; ]+)<(eds|edm)>/$1$2<$3>/gs;
	     $bibText=~s/<suffix>([^<>]*?)<\/suffix>([\.\,\; ]+)<(eds|edm)>/$1$2<$3>/gs;
	     $bibText=~s/<(eds|edm)>([\.\,\; ]+)<par>([^<>]*?)<\/par>/<$1>$2$3/gs;
	     $bibText=~s/<\/(eds|edm)>([\.\,\; ]+)<par>([^<>]*?)<\/par>/<$1>$2$3/gs;
	     $bibText=~s/<(eds|edm)>([\.\,\; ]+)<suffix>([^<>]*?)<\/suffix>/<$1>$2$3/gs;
	     $bibText=~s/<\/(eds|edm)>([\.\,\; ]+)<suffix>([^<>]*?)<\/suffix>/<$1>$2$3/gs;

	     $bibText=~s/<ia>([^<>]+?)<\/ia><\/aug>/\&ia\;$1\&\/ia\;<\/aug>/gs;
	     $bibText=~s/<(at|pt|bt|misc1|cny|pbl|edrg|edr|eds|edm|edn|ia|pg|v|iss|collab|url|doi|doig|comment)>//gs;
	     $bibText=~s/<\/(at|pt|bt|misc1|cny|pbl|edrg|edr|eds|edm|edn|ia|pg|v|iss|collab|url|doi|doig|comment)>//gs;
	   }else
	     {
	       $bibText=~s/<(at|pt|bt|misc1|cny|pbl|edn|pg|v|iss|url|doi|doig|collab|comment)>//gs; 
	       $bibText=~s/<\/(at|pt|bt|misc1|cny|pbl|edn|pg|v|iss|url|doi|doig|collab|comment)>//gs; 
	     }

	 $bibText=~s/\&(i|b|u|sup|sub|sb|sp|ia)\;/<$1>/gs;
	 $bibText=~s/&\/(i|b|u|sup|sub|sb|sp|ia)\;/<\/$1>/gs;

	 return $bibText;
     }
#======================================================================================================================

sub removeAllTags
     {
	 my $bibText=shift;

	 $bibText=~s/<(i|b|u|sup|sub|sb|sp)>/&$1\;/gs; 
	 $bibText=~s/<\/(i|b|u|sup|sub|sb|sp)>/&\/$1\;/gs; 
	 # $bibText=~s/<([a-zA-Z0-9]+)>//gs; 
	 # $bibText=~s/<\/([a-zA-Z0-9]+)>//gs; 
	 $bibText=~s/<(at|pt|bt|misc1|cny|pbl|aug|par|yr|yrg|au|aus|auf|edrg|edr|eds|edm|edn|pg|v|iss|doi)>//gs; 
	 $bibText=~s/<\/(at|pt|bt|misc1|cny|pbl|aug|par|yr|yrg|au|aus|auf|edrg|edr|eds|edm|edn|pg|v|iss|doi)>//gs; 
	 $bibText=~s/\&(i|b|u|sup|sub|sb|sp)\;/<$1>/gs; 
	 $bibText=~s/&\/(i|b|u|sup|sub|sb|sp)\;/<\/$1>/gs;

	 return $bibText;
     }



sub hideElements{
  my $bibText = shift;
  my $Elements=shift;
  my $ID=0;
  my %titalTable=();
  my $titalTableRef="";

  while($bibText=~/<($Elements)>((?:(?!<\1>)(?!<\/\1>).)*)<\/\1>/s)
    {
      my $title="<$1>$2<\/$1>";
      $bibText=~s/<($Elements)>((?:(?!<\1>)(?!<\/\1>).)*)<\/\1>/\&\#Z$ID\;/s;
      $titalTable{$ID}="$title";
      $ID++;
    }
  $titalTableRef=\%titalTable;
  return ($bibText, $titalTableRef);
}

sub revertElements{
  my $bibText = shift;
  my $titalTableRef = shift;
  foreach my $KEY(keys %$titalTableRef) #%$Symboltableref
    {
      my $titleKEY="\&\#Z$KEY\;";
      $bibText=~s/$titleKEY/$$titalTableRef{$KEY}/s;
    }
  return $bibText;
}


#=============================================================================================================================

sub SpringerOtherRefValidation{
  my $TextBody=shift;
	    #---------------Case 1 check <bt> ----------------------------------
  while($TextBody=~/<bib([^<>]*?)>(.*?)<\/bib>/s)
    {
      my $bibText=$2;
      ######By Suman Copyeditor ignore in journal and article title
      ($bibText, my $titalTableRef)=hideElements($bibText, 'at|pt');
      #print "$bibText\n";
      if($bibText!~/((?=.*<v>)(?=.*<pg>)(?=.*\&\#Z[0-9]+\;)(?=.*<url>)|(?=.*<v>)(?=.*<pg>)(?=.*\&\#Z[0-9]+\;)(?=.*<comment>))/)
	{
	  if($bibText!~/(?=.*<bt>)(?=.*<cny>)(?=.*<pbl>)/)
	    {
	      if($bibText=~/(http:\/\/|https:\/\/|www\.|WWW\.)/)
		{
		  $bibText=&removeTags($bibText);
		}
	    }
	}

      #</bt>. <cny>Camberwell, Australia</cny>: <pbl>Australian Council for Educational Research Ltd</pbl>. Retrieved from <url>

	  #if($bibText!~/(?=.*<bt>)(?=.*<yr>)(?=.*<edrg>)(?=.*<cny>)(?=.*<pbl>)/)
	  if($bibText!~/(?=.*<bt>)(?=.*<yr>)(?=.*<cny>)(?=.*<pbl>)/)
	    {
	      if($bibText=~/(Conference|Symposium|Proceedings)/)
		{
		  $bibText=&removeTags($bibText);
		}
	    }

      if($bibText=~/(Unpublished)/)
   	{
   	  $bibText=&removeTags($bibText);
   	}

      $bibText=&revertElements($bibText, $titalTableRef);
      $TextBody=~s/<bib([^<>]*?)>(.*?)<\/bib>/<Xbib$1>$bibText<\/Xbib>/os;
    }
  $TextBody=~s/<Xbib([^<>]*?)>(.*?)<\/Xbib>/<bib$1>$2<\/bib>/gs;

  return $TextBody;
}


#=============================================================================================================================
sub ElsevierOtherRefValidation{
  my $TextBody=shift;
	    #---------------Case 1 check <bt> ----------------------------------
  while($TextBody=~/<bib([^<>]*?)>(.*?)<\/bib>/s)
    {
      my $bibText=$2;
      ######By Suman Copyeditor ignore in journal and article title
      ($bibText, my $titalTableRef)=hideElements($bibText, 'at|pt');

      if($bibText=~/([Uu]npublished|[Ii]n [PP]reparation|[fF]or [PP]ublication|[Ii]n [Tt]his [iI]ssue|[sS]ubmitted [fF]or [pP]ublication|Patent|Ph[\.]?[ ]?D[.]? [Tt]hesis|Ph[\.]?D[.]? [Dd]issertation|CD-ROM)/)
   	{
   	  $bibText=&removeTags($bibText);
   	}
      $bibText=&revertElements($bibText, $titalTableRef);
      $TextBody=~s/<bib([^<>]*?)>(.*?)<\/bib>/<Xbib$1>$bibText<\/Xbib>/os;
    }
  $TextBody=~s/<Xbib([^<>]*?)>(.*?)<\/Xbib>/<bib$1>$2<\/bib>/gs;

  return $TextBody;
}


#=============================================================================================================================
sub renameSpringerUnstrElement{
  my $FileText=shift;

  #use ReferenceManager::ElementGrouping;
  use ReferenceManager::HtmlTagEntityManage;

  #$$FileText=~s/<([\/]?)(b|i|u)>/\&lt\;$1$2X\&gt\;>/gs;

  $$FileText = HtmlEntitytoTag($FileText);
  #$$FileText = TagGruopings($$FileText);

 # print "TEST1: $$FileText\n";
  while($$FileText=~/<bib([^<>]*?)>(.*?)<\/bib>/s)
    {
      my $bibText=$2;
      $bibText=&renameSpringerMandatoryBibText(\$bibText);
      $$FileText=~s/<bib([^<>]*?)>(.*?)<\/bib>/<Xbib$1>$bibText<\/Xbib>/os;
    }
  $$FileText=~s/<Xbib([^<>]*?)>(.*?)<\/Xbib>/<bib$1>$2<\/bib>/gs;

  $$FileText = HtmlTagToEntity($FileText);

  return $$FileText;
}
#=============================================================================================================================

sub renameSpringerMandatoryBibText
  {
    my $BibText=shift;

    my $tempBibText=$$BibText;
    my $returnBibtext=$$BibText;
    my %texttagsexist=();
    my %validtags=();

    while($tempBibText=~/<([a-zA-Z0-9]+)>/)
      {
	my $temptags=$1;
	$texttagsexist{$temptags}="$temptags";
	$tempBibText=~s/<([a-zA-Z0-9]+)>/<#$1#>/os;
      }
    #print "---------$$BibText=> ", keys(%texttagsexist), "---------\n";
    #print "*****[$validtags{ArticelTags}]****";
    #print "$tempBibText\n";
    $validtags{ArticelTagsAu}=["aug", "yr", "pt", "v", "pg"];
    $validtags{ArticelTagsEds}=["edrg", "yr", "pt", "v", "pg"];
    $validtags{ArticelTagsMis}=["ia", "yr",  "pt", "v", "pg"];

    $validtags{ArticelTagsAuDoi}=["aug", "yr", "pt", "doi"];
    $validtags{ArticelTagsEdsDoi}=["edrg", "yr", "pt", "doi"];
    $validtags{ArticelTagsMisDoi}=["ia", "yr", "pt", "doi"];

    $validtags{ChapterTagsAuEds}=["aug", "edrg", "yr", "misc1", "bt", "pbl", "cny"];
    $validtags{ChapterTagsAu}=["aug", "ia", "yr", "misc1", "bt", "pbl", "cny"];
    $validtags{ChapterTagsEds}=["edrg", "yr", "misc1", "bt", "pbl", "cny"];
    $validtags{ChapterTagsMis}=["ia", "yr", "misc1", "bt", "pbl", "cny"];

    $validtags{BookTagsEds}=["edrg", "yr", "bt", "pbl", "cny"];
    $validtags{BookTagsAu}=["aug", "yr", "bt", "pbl", "cny"];
    $validtags{BookTagsMis}=["ia", "yr", "bt", "pbl", "cny"];

  exitIF: foreach my $tagtype (keys(%validtags))
      {
	my $arraytagref=$validtags{$tagtype};
	#print "---$tagtype=>@$arraytagref--\n";
	my $test="1";
	foreach my $tag(@$arraytagref)
	  {
	    if(exists($texttagsexist{$tag})){
	      #print "Nothing: $tag\n";
	    }else{
	      $test="0";
	    }
	  }
	if($test eq "1"){
	  $returnBibtext=$$BibText;
	  last exitIF;
	}else{
	  my $temptext=$$BibText;
	  $temptext=renameTags(\$temptext);
	  $returnBibtext=$temptext;
	  #print "$returnBibtext\n";
	}
      }

    return $returnBibtext;
 }

  #============================================================================================================================
  sub renameTags{
    my $bibText=shift;
    #$$bibText=~s/<([\/]?)(vg|issg|pgg|edng|doig|atg|ptg|btg|cnyg|pblg|misc1g|urlg|collabg)>/<$1$2Z>/gs;
    $$bibText=~s/\&lt\;([\/]?)(v|iss|pg|edn|doi|at|pt|bt|cny|pbl|misc1|url|collab)\&gt\;/\&lt\;$1$2Z\&gt\;/gs;
    $$bibText=~s/<([\/]?)(v|iss|pg|edn|doi|at|pt|bt|cny|pbl|misc1|url|collab)>/<$1$2Z>/gs;
    $$bibText=~s/<\/([a-z0-1]+Z|yr|aug)>([^<>]+?)<ia>([^<>]+)<\/ia>/<\/$1>$2<iaZ>$3<\/iaZ>/gs;
    return $$bibText;
  }
  sub revertRenameTags{
    my $bibText=shift;
    #print $$bibText;
    # $$bibText=~s/<([\/]?)(vg|issg|pgg|edng|doig|atg|ptg|btg|cnyg|pblg|misc1g|urlg|collabg|i|u|b)Z>/<$1$2>/gs;
    $$bibText=~s/\&lt\;([\/]?)(v|iss|pg|edn|doi|at|pt|bt|cny|pbl|misc1|url|collab|i|u|b|ia)Z\&gt\;/\&lt\;$1$2\&gt\;/gs;
    $$bibText=~s/<([\/]?)(v|iss|pg|edn|doi|at|pt|bt|cny|pbl|misc1|url|collab|i|u|b|ia)Z>/\&lt\;$1$2\&gt\;/gs;

    return $$bibText;
  }
  #================================================================================

  return 1;

