package ReferenceManager::Label;

#package Label;
#package ReferenceManager::Label;

sub ReferenceLabel
  {
    local($Text) = shift;
    $Text=&RefColorToTag($Text);

    my $RetText="";
    $MyText="";
    $Text=~s/&lt;/</g;
    $Text=~s/&gt;/>/g;
    $Text=~s/&quot;/"/g;

    #Generate refLabel
    while($Text=~/(<p\sclass=Bibentry[^>]*?>.*?<\/p>)/s)
      {
	$Para=$1;
	$Para=~s/<edr>.*?<\/edr>//gs;

	if($Para=~/(<bib[^>]*?>)/s)
	  {
	    $BibTag=$1;
	    $BibTag=~s/\n/ /gs;
	    $RetText.="$BibTag<eql>";
	    if($BibTag=~/\slabel="[^"]*?"/s)
	      {
		$BibTag=~s/\slabel="[^"]*?"//s;
		$Para=~s/<bib[^>]*?>/$BibTag/s;
	      }
	    $c=0;
	    $c=$Para=~s/<s>/<s>/g;
	    $MyText="";
	    $EtalCnt=$ARGV[2];
	    $EtalCnt=3 if($ARGV[2]=="");

	    if($c>=$EtalCnt)
	      {
		#if($Para=~/<s>(.*?)<\/s>/s)
		if($Para=~/<s>(.*?)<\/s>/s)
		  {
		    $MyText.="$1 &etal; | ";
		    if($Para=~/<yr>(.*?)<\/yr>/)
		      {
			$MyText.="$1";
		      }
		  }
	      }
	    else
	      {
		$MyText="";
		if($c==0)
		  {
		    if($Para=~/<collab>(.*?)<\/collab>/s)
		      {
			while($Para=~/<collab>(.*?)<\/collab>/s)
			  {
			    $MyText.="$1, ";
			    $Para=~s/<collab>(.*?)<\/collab>//s;
			  }
			$MyText=~s/, $//;
			if($Para=~/<yr>(.*?)<\/yr>/s)
			  {
			    $MyText.=" | $1";
			  }
			else
			  {
			    $MyText.=" | ?";
			  }
		      }
		    else
		      {
			$MyText.="?";
			if($Para=~/<yr>(.*?)<\/yr>/s)
			  {
			    $MyText.=" | $1";
			  }
			else
			  {
			    $MyText.=" | ?";
			  }
		      }
		  }
		else
		  {
		    while($Para=~/<s>(.*?)<\/s>/s)
		      {
			$MyText.="$1, ";
			$Para=~s/<s>(.*?)<\/s>//s;
		      }
		    $MyText=~s/, $//;
		    if($Para=~/<yr>(.*?)<\/yr>/s)
		      {
			$MyText.=" | $1";
		      }
		    else
		      {
			$MyText.=" | ?";
		      }
		  }
	      }
	  }
	$BibTag=~s/\s+/ /gs;
	if($BibTag=~/\stype="/)
		{
		  $BibTag=~s/\stype="/ label="$MyText" type="/s;
		}
	else
	  {
	    $BibTag=~s/>/ label="$MyText">/s;
	  }
	$BibTag=~s/\s+/ /gs;
	$RetText.=$BibTag ."\n";


	$Text=~s/<p\sclass=Bibentry[^>]*?>.*?<\/p>//s;
      }
    $RetText=~s/<span[^>]*?>|<\/span>//gs;  #Has been removed temporarily. Shall see the solution later
 

    return($RetText);
  }


#=======================================================================================================================================
sub RefColorToTag
{
    my $Text = shift;

     $Text=~s/<span([\s]*)style=\'border:([\s]*)dotted([\s]*)([a-zA-Z]+)([\s]*)1\.0pt\;([\s]*)padding:([\s]*)0pt\;([\s]*)background:\#([^\']*?)\'>([^<>]*?)<\/span>/<span style=\'border:dotted $4 1\.0pt\;padding:0pt\'><span style=\'background:\#$9\'>$10<\/span><\/span>/gs;

    $Text=~s/<span([\s]*)style='background:#[^']*?'>(\s+)<\/span>/$2/gs;
    $Text=~s/<span([\s]*)style=\'color\:\#FF6600\'>(.*?)<\/span>/$2/gs;


    $Text=&AuthorGroupBoundary($Text);

 #   print "Author grouping Done\n";

    my ($Colour2TagRef, $Tag2ColourRef)=&ColorAndTag;

    print "Color tag conf done\n";

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
    #######

    $Text=~s/<\/[0-9]+span/<\/span/gs;
    $Text=~s/<[0-9]+span/<span/gs;
    $Text=~s/<X[0-9]+span/<span/gs;
    $Text=~s/<Xspan/<span/gs;

    $Text=~s/<span([\s]*)style=\'border:([^\'<>]*?)padding:([0-9a-z]+)\'>(.*?)<\/span>/&lt;au&gt;$4&lt;\/au&gt;/gs;

    $Text=~s/\&lt\;\/([a-z]+)\&gt\;\&lt\;\1\&gt\;//gs;
    $Text=~s/\&lt\;\/at\&gt\;<\/span>\&lt\;at\&gt\;(.*?)\&lt\;\/at\&gt\;/$1\&lt\;\/at\&gt\;<\/span>/gs;
    $Text=~s/<\/span><span lang=EN-US>//gs;


    return($Text);
}

#============================================================================================================================================

sub AuthorGroupBoundary
{
  my  $Text = shift;
  my  $Sequence=1;


    while($Text=~/<span\s*([^<>]*?)>((?:(?!<span\s*([^<>]*?)>)(?!<\/span>).)*)<\/span>/s)
    {
	$Text=~s/<span\s*([^<>]*?)>((?:(?!<span\s*([^<>]*?)>)(?!<\/span>).)*)<\/span>/<${Sequence}span $1>$2<\/${Sequence}span>/gs;
	#print "<${Sequence}span $1>$2<\/${Sequence}span>\n";
	    $Sequence++;
    }

    return($Text);
}


#======================================================================================================
sub ColorAndTag
{
    my $Colour2TagRef=();
    my $Tag2ColourRef=();
    my %Tag2Colour=();


    my %Colour2Tag=(
	'#00A5E0' => 'cny',
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
	'#E5D007' => 'thesis',
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
	);


    $Colour2TagRef=\%Colour2Tag;

    foreach my $Keyes(keys %Colour2Tag)
    {
	$Tag2Colour{$Colour2Tag{$Keyes}}=$Keyes;
    }

    $Tag2ColourRef=\%Tag2Colour;


    return ($Colour2TagRef, $Tag2ColourRef);
}


#========================================================================================================================================


return 1;