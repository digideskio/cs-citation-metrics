#version 1.0
#Author: Neyaz Ahmad
package ReferenceManager::AuthorEditorGrouping;
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(AuthorGroup EditorGroup);
use ReferenceManager::ReferenceRegex;
my %regx = ReferenceManager::ReferenceRegex::new();


###################################################################################################################################################
sub AuthorGroup
{
    my $TextBody="";
    my $aug="";
    my $au="";
    $TextBody=shift;
    $aug=shift;
    $au=shift;
    my $aus=shift;
    my $auf=shift;
    # my $AuthorString="A-Za-z√ü√ò√ÉÔ¨Ç¬°√Ω√ø√æ√ú√õ√ö√ô√ò√ñ√ï√î√ì√í√ë√ê√è√é√ç√å√ã√ä√à√â√á√Ü≈í≈ì≈°≈†√Ö√Ñ√Ç√Å√Ä√±√Ø√Ø√Æ√≠√≠√™√ß√¶√•√£√¢√°√µ√¥√≥√≤√π√∫√ª√©√®√†√§ƒá√≠√É√º√∂ƒ∞ƒ±‚Ä¶√¢‚Ç¨‚Ñ¢√É¬¶√É¬≥√É¬±√ÉÀú√É¬§√É¬ß√É¬Æ√É¬®√É≈∏√É¬º√É¬∂√É¬©√É¬•√É¬∏`‚Äô\\\-√É‚Ä°√É‚Äì\\\"‚Äì\\\-\\\'";
    my $AuthorString="\^<>\.\,\;\:\/";

   $TextBody = &AuthorGroupCleanup(\$TextBody, $aug);


    while($TextBody=~/<$aug>(.*?)<\/$aug>/)
    {
	my $AuthorGroup=$1;

	 if($AuthorGroup=~/ [a-z][\w\-]+ [a-z][\w\-]+ [a-z][\w\-]+ /)
	    {
	     goto IALabel;
	    }
	elsif($AuthorGroup!~/(^|\>| |\-)$regx{instName}( |\<|[\,\.\;]|$)/)
	  {
	    if($AuthorGroup=~/^([$AuthorString]+)\, (Th[\.]?M[\.]?|[A-Zû¿¡¬√ƒ≈«»… òÿ“Œ”‘÷‘Ÿÿ⁄€‹›ﬂ‚Äì‚Äê\-\. ]+[vdhtj\.]*?)([\,\;])/)
	      {
		$AuthorGroup=&authorstyle1($AuthorGroup, $au, $aus, $auf, $AuthorString);
	      }
	    elsif($AuthorGroup=~/^([$AuthorString]+)\, (Th[\.]?M[\.]?|[A-Zû¿¡¬√ƒ≈«»… òÿ“Œ”‘÷‘Ÿÿ⁄€‹›ﬂ‚Äì‚Äê\-\. ]+[vdhtj\.]*?) $regx{particleSuffix}([\,\;]?)/)
	      {
		$AuthorGroup=&authorstyle1($AuthorGroup, $au, $aus, $auf, $AuthorString);
	      }
	    elsif($AuthorGroup=~/^([$AuthorString]+) $regx{particleSuffix}\, (Th[\.]?M[\.]?|[A-Zû¿¡¬√ƒ≈«»… òÿ“Œ”‘÷‘Ÿÿ⁄€‹›ﬂ‚Äì‚Äê\-\. ]+[vdhtj\.]*?)([\,\;]?)/)
	      {
		$AuthorGroup=&authorstyle1($AuthorGroup, $au, $aus, $auf, $AuthorString);
	      }
	    elsif($AuthorGroup=~/^([$AuthorString]+)\, (Th[\.]?M[\.]?|[A-Zû¿¡¬√ƒ≈«»… òÿ“Œ”‘÷‘Ÿÿ⁄€‹›ﬂ‚Äì‚Äê\-\. ]+[vdhtj\.]*?) $regx{and} /)
	      {
		$AuthorGroup=&authorstyle1($AuthorGroup, $au, $aus, $auf, $AuthorString);
	      }
	    elsif($AuthorGroup=~/^([$AuthorString]+)\, (Th[\.]?M[\.]?|[A-Zû¿¡¬√ƒ≈«»… òÿ“Œ”‘÷‘Ÿÿ⁄€‹›ﬂ‚Äì‚Äê\-\. ]+[vdhtj\.]*?)$/)
	      {
		$AuthorGroup=&authorstyle1($AuthorGroup, $au, $aus, $auf, $AuthorString);
	      }
	    elsif($AuthorGroup=~/^(v\.[$AuthorString]+)\, (Th[\.]?M[\.]?|[A-Zû¿¡¬√ƒ≈«»… òÿ“Œ”‘÷‘Ÿÿ⁄€‹›ﬂ‚Äì‚Äê\-\. ]+[vdhtj\.]*?)$/)
	      {
		$AuthorGroup=&authorstyle1($AuthorGroup, $au, $aus, $auf, $AuthorString);
	      }
	    elsif($AuthorGroup=~/^([$AuthorString]+) ([û…A-Z‚Äì\-\. ]+[vdhtj\.]*?)([^A-Za-z√ü√ò√ÉÔ¨Ç¬°√Ω√ø√æ√ú√õ√ö√ô√ò√ñ√ï√î√ì√í√ë√ê√è√é√ç√å√ã√ä√à√â√á√Ü≈í≈ì≈°≈†√Ö√Ñ√Ç√Å√Ä√±√Ø√Ø√Æ√≠√≠√™√ß√¶√•√£√¢√°√µ√¥√≥√≤√π√∫√ª√©√®√†√§ƒá√≠√É√º√∂ƒ∞ƒ±‚Ä¶√¢‚Ç¨‚Ñ¢√É¬¶√É¬≥√É¬±√ÉÀú√É¬§√É¬ß√É¬Æ√É¬®√É≈∏√É¬º√É¬∂√É¬©√É¬•√É])/)
	      {
		$AuthorGroup=&authorstyle2($AuthorGroup, $au, $aus, $auf, $AuthorString);
	      }
	    elsif($AuthorGroup=~/^([$AuthorString ]+) ([…A-Z‚Äì\-\. ]+[vdhtj\.]*?) ([$AuthorString ]+) ([…A-Z‚Äì\-\. ]+[vdhtj\.]*?)/)
	      {
		$AuthorGroup=&authorstyle2($AuthorGroup, $au, $aus, $auf, $AuthorString);
	      }
	    elsif($AuthorGroup=~/^(Th[\.]?M[\.]?|[A-Zû¿¡¬√ƒ≈«»… òÿ“Œ”‘÷‘Ÿÿ⁄€‹›ﬂ‚Äì‚Äê\-\. ]+[vdht\.]*?) ([$AuthorString ]+)/)
	      {
		$AuthorGroup=&authorstyle3($AuthorGroup, $au, $aus, $auf, $AuthorString);
	      }
	    elsif($AuthorGroup=~/^([$AuthorString]+)\, ([^a-z][$AuthorString]+[A-Z¿¡¬√ƒ≈«»… òÿ“Œ”‘÷‘Ÿÿ⁄€‹›ﬂ‚Äì‚Äê\-\. ]*)\, (.*?)\, ([$AuthorString]+[A-Z‚Äì\-\. ]*) ([$AuthorString ]+)[\,]? $regx{and}/)
	      {
		$AuthorGroup=&authorstyle5($AuthorGroup, $au, $aus, $auf, $AuthorString);
	      }
	    elsif($AuthorGroup=~/^([$AuthorString]+)\, ([^a-z][$AuthorString]+[A-Zû¿¡¬√ƒ≈«»… òÿ“Œ”‘÷‘Ÿÿ⁄€‹›ﬂ‚Äì‚Äê\-\. ]*)\, ([$AuthorString]+[A-Z‚Äì\-\. ]*) ([$AuthorString ]+)[\,]? $regx{and}/)
	      {
		$AuthorGroup=&authorstyle5($AuthorGroup, $au, $aus, $auf, $AuthorString);
	      }
	    elsif($AuthorGroup=~/^([$AuthorString]+)\, ([^a-z][$AuthorString]+[A-Zû¿¡¬√ƒ≈«»… òÿ“Œ”‘÷‘Ÿÿ⁄€‹›ﬂ‚Äì‚Äê\-\. ]*)[\,]? $regx{and} ([$AuthorString]+[A-Z‚Äì\-\. ]*) ([$AuthorString]+)/)
	      {
		$AuthorGroup=&authorstyle5($AuthorGroup, $au, $aus, $auf, $AuthorString);
	      }
	    elsif($AuthorGroup=~/^$regx{mAuthorString}([\,]*) $regx{sAuthorString}/)
	      {
		$AuthorGroup=&authorstyle4($AuthorGroup, $au, $aus, $auf, $AuthorString);
	      }
	    elsif($AuthorGroup=~/^$regx{mAuthorString} $regx{sAuthorString} $regx{and} $regx{mAuthorString} $regx{sAuthorString}/)
	      {
		$AuthorGroup=&authorstyle4($AuthorGroup, $au, $aus, $auf, $AuthorString);
	      }
	    elsif($AuthorGroup=~/^([$AuthorString]+)\; $regx{firstName} $regx{particleSuffix}([\,]?)/)
	      {
		$AuthorGroup=&authorstyle6($AuthorGroup, $au, $aus, $auf, $AuthorString);
	      }
	    elsif($AuthorGroup=~/^([$AuthorString]+)\; $regx{firstName}([\,]?)/)
	      {
		$AuthorGroup=&authorstyle6($AuthorGroup, $au, $aus, $auf, $AuthorString);
	      }elsif($AuthorGroup=~/^([$AuthorString]+)\; $regx{mAuthorFullSirName} $regx{particleSuffix}([\,]?)/)
	      {
		$AuthorGroup=&authorstyle6($AuthorGroup, $au, $aus, $auf, $AuthorString);
	      }
	    elsif($AuthorGroup=~/^([$AuthorString]+)\; $regx{mAuthorFullSirName}([\,]?)/)
	      {
		$AuthorGroup=&authorstyle6($AuthorGroup, $au, $aus, $auf, $AuthorString);
	      }


	  }

	  IALabel:
	$TextBody=~s/<$aug>(.*?)<\/$aug>/<${aug}x>$AuthorGroup<\/${aug}x>/o;
    }

    $TextBody=~s/<${aug}x>(.*?)<\/${aug}x>/<$aug>$1<\/$aug>/g;
    $TextBody=~s/\&lt\;([\/]?)augx\&gt\;/<$1aug>/gs;
    $TextBody=~s/<([\/]?)augx>/<$1aug>/gs;


    $TextBody=~s/<\/${aug}>([\.\,\; ]+)<(i|b)>$regx{etal}<\/\2>([\,\.\;\: ]+)/$1<etal><$2>$3<\/$2><\/etal><\/${aug}>$4/gs;
    $TextBody=~s/<\/${aug}>([\.\,\; ]+)$regx{etal}([\,\.\;\: ]+)/$1<etal>$2<\/etal><\/${aug}>$3/gs;
    $TextBody=~s/<\/${aug}>([\.\,\; ]+)$regx{and} $regx{etal}([\,\.\;\: ]+)/$1$2 <etal>$3<\/etal><\/${aug}>$4/gs;

    $TextBody=~s/<\/au>\, ([$AuthorString ]+)\.\, ([A-Z\-\.]+)<\/aug>/<\/au>\, <au><aus>$1<\/aus>\.\, <auf>$2<\/auf><\/au><\/aug>/gs;
    $TextBody=~s/<\/au>\, ([$AuthorString ]+)\, ([$AuthorString ]+)<\/aug>/<\/au>\, <au><aus>$1<\/aus>\, <auf>$2<\/auf><\/au><\/aug>/gs;

    $TextBody=~s/ ([A-Z\- \.]+)<\/aug>\. \(/ $1\.<\/aug> \(/gs;
    $TextBody=~s/ (Jr|Sr)<\/aug>\. \(/ $1\.<\/aug> \(/gs;
    $TextBody=~s/<ia>([A-Z][a-z]+)\, ([A-Z\-\.]+)<\/ia>/<aug><au><aus>$1<\/aus>\, <auf>$2<\/auf><\/au><\/aug>/gs;
    $TextBody=~s/<ia>([A-Z][a-z]+)\, ([A-Z\-\.]+) ([A-Z][a-z]+)<\/ia>/<aug><au><aus>$1<\/aus>\, <auf>$2 $3<\/auf><\/au><\/aug>/gs;
    $TextBody=~s/<aug>$regx{firstName}\, ([$AuthorString ]+)([,]?) $regx{and} $regx{firstName}\, ([$AuthorString ]+)<\/aug>/<aug><au><auf>$1<\/auf>\, <aus>$2<\/aus><\/au>$3 $4 <au><auf>$5<\/auf>\, <aus>$6<\/aus><\/au><\/aug>/gs;

    $TextBody=~s/<aug>([$AuthorString ]+)\, ([A-Z\. \-]+\.) ([$AuthorString ]+)\, ([A-Z\. \-]+\.)<\/aug>/<aug><au><aus>$1<\/aus>\, <auf>$2<\/auf><\/au> <au><aus>$3<\/aus>\, <auf>$4<\/auf><\/au><\/aug>/gs;

    $TextBody=~s/<aug>De ([$AuthorString ]+)\, ([$AuthorString ]+)<\/aug>/<aug><au><aus>De $1<\/aus>\, <auf>$2<\/auf><\/au><\/aug>/gs;
    $TextBody=~s/<au><aus>([$AuthorString ]+[a-z]) ([$AuthorString ]+[a-z])<\/aus>\, <auf>([$AuthorString ]+[a-z]) ([$AuthorString ]+[a-z])<\/auf><\/au>\, <au><auf>/<au><auf>$1<\/auf> <aus>$2<\/aus><\/au>\, <au><auf>$3<\/auf> <aus>$4<\/aus><\/au>\, <au><auf>/gs;

    $TextBody=~s/<aug>([$AuthorString]+)\. $regx{firstName}\. $regx{and} ([$AuthorString]+)\. $regx{firstName}\.<\/aug>/<aug><au><aus>$1<\/aus>\. <auf>$2\.<\/auf><\/au> $3 <au><aus>$4<\/aus>\. <auf>$5\.<\/auf><\/au> <\/aug>/gs;

       while($TextBody=~/<$aug>(.*?)<\/$aug>/)
      {
	my $Text=$1;

	if($Text!~/<au>|<edr>/)
	  {
	    $TextBody=~s/<$aug>(.*?)<\/$aug>/<ia>$Text<\/ia>/o;
	  }else
	    {
	      $TextBody=~s/<$aug>(.*?)<\/$aug>/<X$aug>$Text<\/X$aug>/o;
	    }
      }

    $TextBody=~s/<ia>([hH][tT][tT][pP][sd]?|[fF][tT][pP])<\/ia>/$1/gs;
    $TextBody=~s/<ia>([a-zA-Z]+)<\/ia>\:([a-zA-Z]+) ([(]?<yr>)/<ia>$1\:$2<\/ia> $3/gs;
    $TextBody=~s/<$au><$auf>([^<>]*?)<\/$auf> <$aus>([A-Z‚Äì\-\. ]+)<\/$aus><\/$au>/<$au><$aus>$1<\/$aus> <$auf>$2<\/$auf><\/$au>/gs;
    $TextBody=~s/([A-Z])<\/auf>\. <(aus|suffix|par)>/$1\.<\/auf> <$2>/gs;


    $TextBody=~s/<X$aug>/<$aug>/gs;
    $TextBody=~s/<\/X$aug>/<\/$aug>/gs;

    return $TextBody;
}

#=========================================================================
sub EditorGroup
{
    my $TextBody="";
    my $aug="";
    my $au="";

    $TextBody=shift;
    $aug=shift;
    $au=shift;
    my $aus=shift;
    my $auf=shift;

    #my $AuthorString="A-Za-z√ü√ò√ÉÔ¨Ç¬°√Ω√ø√æ√ú√õ√ö√ô√ò√ñ√ï√î√ì√í√ë√ê√è√é√ç√å√ã√ä√à√â√á√Ü≈í≈ì≈°≈†√Ö√Ñ√Ç√Å√Ä√±√Ø√Ø√Æ√≠√≠√™√ß√¶√•√£√¢√°√µ√¥√≥√≤√π√∫√ª√©√®√†√§ƒá√≠√É√º√∂ƒ∞ƒ±‚Ä¶√¢‚Ç¨‚Ñ¢√É¬¶√É¬≥√É¬±√ÉÀú√É¬§√É¬ß√É¬Æ√É¬®√É≈∏√É¬º√É¬∂√É¬©√É¬•√É¬∏`‚Äô\\\-√É‚Ä°√É‚Äì\\\"‚Äì\\\-\\\'";
    my $AuthorString="\^<>\.\,\;\/";


   $TextBody = &AuthorGroupCleanup(\$TextBody, $aug);

    while($TextBody=~/<$aug>(.*?)<\/$aug>/)
    {
	my $AuthorGroup=$1;

	 if($AuthorGroup=~/ [a-z][\w\-]+ [a-z][\w\-]+ [a-z][\w\-]+ /)
	    {
	     goto IALabel;
	    }
	elsif($AuthorGroup!~/(^|\>| |\-)$regx{instName}( |\<|[\,\.\;]|$)/)
	  {
	    # <aug>Harris, M., Karper, E., Stacks, G., Hoffman, D., DeNiro, R., Cruz, P.,</aug>	  
	    if($AuthorGroup=~/^([$AuthorString]+)\, (Th[\.]?M[\.]?|[A-Z‚Äì\-\. ]+[vdhtj\. ]*?)\,/)
	      {
		$AuthorGroup=&authorstyle1($AuthorGroup, $au, $aus, $auf, $AuthorString);
	      }
	    elsif($AuthorGroup=~/^([$AuthorString]+)\, (Th[\.]?M[\.]?|[A-Z‚Äì\-\. ]+[vdhtj\. ]*?) $regx{and} /)
	      {
		$AuthorGroup=&authorstyle1($AuthorGroup, $au, $aus, $auf, $AuthorString);
	      }
	    elsif($AuthorGroup=~/^([$AuthorString]+)\, (Th[\.]?M[\.]?|[A-Z‚Äì\-\. ]+[vdhtj\. ]*?)$/)
	      {
		$AuthorGroup=&authorstyle1($AuthorGroup, $au, $aus, $auf, $AuthorString);

	      }
	    elsif($AuthorGroup=~/^([$AuthorString]+) (Th[\.]?M[\.]?|[A-Zû¿¡¬√ƒ≈«»… òÿ“Œ”‘÷‘Ÿÿ⁄€‹›ﬂ‚Äì‚Äê\-\. ]+[vdhtj\. ]*?)([^A-Za-z√ü√ò√ÉÔ¨Ç¬°√Ω√ø√æ√ú√õ√ö√ô√ò√ñ√ï√î√ì√í√ë√ê√è√é√ç√å√ã√ä√à√â√á√Ü≈í≈ì≈°≈†√Ö√Ñ√Ç√Å√Ä√±√Ø√Ø√Æ√≠√≠√™√ß√¶√•√£√¢√°√µ√¥√≥√≤√π√∫√ª√©√®√†√§ƒá√≠√É√º√∂ƒ∞ƒ±‚Ä¶√¢‚Ç¨‚Ñ¢√É¬¶√É¬≥√É¬±√ÉÀú√É¬§√É¬ß√É¬Æ√É¬®√É≈∏√É¬º√É¬∂√É¬©√É¬•√É])/)
	      {
		$AuthorGroup=&authorstyle2($AuthorGroup, $au, $aus, $auf, $AuthorString);
	      }
	    elsif($AuthorGroup=~/^(Th[\.]?M[\.]?|[A-Zû¿¡¬√ƒ≈«»… òÿ“Œ”‘÷‘Ÿÿ⁄€‹›ﬂ‚Äì‚Äê\-\. ]+[vdhtj\. ]*?) ([$AuthorString ]+)/)
	      {

		$AuthorGroup=&authorstyle3($AuthorGroup, $au, $aus, $auf, $AuthorString);
	      }
	    elsif($AuthorGroup=~/^([$AuthorString]+)\, ([^a-z][$AuthorString]+[A-Zû¿¡¬√ƒ≈«»… òÿ“Œ”‘÷‘Ÿÿ⁄€‹›ﬂ‚Äì‚Äê\-\. ]*)\, (.*?)\, ([$AuthorString]+[A-Z‚Äì\-\. ]*) ([$AuthorString ]+)[\,]? $regx{and}/)
	      {
		$AuthorGroup=&authorstyle5($AuthorGroup, $au, $aus, $auf, $AuthorString);
	      }
	    elsif($AuthorGroup=~/^([$AuthorString]+)\, ([^a-z][$AuthorString]+[A-Zû¿¡¬√ƒ≈«»… òÿ“Œ”‘÷‘Ÿÿ⁄€‹›ﬂ‚Äì‚Äê\-\. ]*)\, ([$AuthorString]+[A-Z‚Äì\-\. ]*) ([$AuthorString ]+)[\,]? $regx{and}/)
	      {
		$AuthorGroup=&authorstyle5($AuthorGroup, $au, $aus, $auf, $AuthorString);
	      }
	    elsif($AuthorGroup=~/^([$AuthorString]+)\, ([^a-z][$AuthorString]+[A-Zû¿¡¬√ƒ≈«»… òÿ“Œ”‘÷‘Ÿÿ⁄€‹›ﬂ‚Äì‚Äê\-\. ]*)[\,]? $regx{and} ([$AuthorString]+[A-Zû¿¡¬√ƒ≈«»… òÿ“Œ”‘÷‘Ÿÿ⁄€‹›ﬂ‚Äì‚Äê\-\. ]*) ([$AuthorString]+)/)
	      {
		$AuthorGroup=&authorstyle5($AuthorGroup, $au, $aus, $auf, $AuthorString);
	      }
	    elsif($AuthorGroup=~/^([A-Z][^A-Z]+) ([A-Z][^A-Z]+)/)
	      {
		$AuthorGroup=&authorstyle4($AuthorGroup, $au, $aus, $auf, $AuthorString);
	      }
	    elsif($AuthorGroup=~/^$regx{mAuthorString}([\,]*) $regx{sAuthorString}/)
	      {
		$AuthorGroup=&authorstyle4($AuthorGroup, $au, $aus, $auf, $AuthorString);
	      }
	    elsif($AuthorGroup=~/^$regx{mAuthorString} $regx{sAuthorString} $regx{and} $regx{mAuthorString} $regx{sAuthorString}/)
	      {
		$AuthorGroup=&authorstyle4($AuthorGroup, $au, $aus, $auf, $AuthorString);
	      }
	  }
	  IALabel:

	$TextBody=~s/<$aug>(.*?)<\/$aug>/<${aug}x>$AuthorGroup<\/${aug}x>/o;
    }
    $TextBody=~s/<${aug}x>(.*?)<\/${aug}x>/<$aug>$1<\/$aug>/g;
    $TextBody=~s/&lt;([\/]?)Xedrg&gt;/<$1edrg>/gs;


    $TextBody=~s/<\/$aug>([\.\,\; ]+)<(i|b)>$regx{etal}<\/\2>([\,\.\;\: ]+)/$1<etal><$2>$3<\/$2><\/etal><\/$aug>$4/gs;
    $TextBody=~s/<\/$aug>([\.\,\; ]+)$regx{etal}([\,\.\;\: ]+)/$1<etal>$2<\/etal><\/$aug>$3/gs;
    $TextBody=~s/<\/$aug>([\,\. ]+)([\(\[])$regx{editorSuffix}([\)\]])/$1$2$3$4<\/$aug>/gs;
    $TextBody=~s/<\/$aug>([\,\. ]+)$regx{editorSuffix} /$1$2<\/$aug> /gs;
    $TextBody=~s/<\/$aug>([\.\,\; ]+)<(i|b)>$regx{etal}<\/\2>([\,\.\;\: ]+)/$1<etal><$2>$3<\/$2><\/etal><\/$aug>$4/gs;
    $TextBody=~s/<\/$aug>([\.\,\; ]+)$regx{etal}([\,\.\;\: ]+)/$1<etal>$2<\/etal><\/$aug>$3/gs;
    $TextBody=~s/<\/${aug}>([\.\,\; ]+)$regx{and} $regx{etal}([\,\.\;\: ]+)/$1$2 <etal>$3<\/etal><\/${aug}>$4/gs;

    $TextBody=~s/([\,\.\?]?) ([iI]n)([\:\.\,]?) <edrg>/$1 <edrg>$2$3 /gs;
    $TextBody=~s/<i>([iI]n)([\:\.\,]?)<\/i>([\:\.\,]?) <edrg>/<edrg><i>$1$2<\/i>$3 /gs;
    $TextBody=~s/<edrg>([iI]n)([\:\.\,]?)(\s*)([A-Z]+)([^A-Z ]+)(\s*)\($regx{editorSuffix}\)<\/edrg>/<edrg>$1$2$3<edr><eds>$4$5<\/eds><\/edr>$6\($7\)<\/edrg>/gs;
    $TextBody=~s/<edrg>([$AuthorString ]+)\, ([A-Z\. \-]+\.) ([$AuthorString ]+)\, ([A-Z\. \-]+\.)<\/edrg>/<edrg><edr><eds>$1<\/eds>\, <edm>$2<\/edm><\/edr> <edr><eds>$3<\/eds>\, <edm>$4<\/edm><\/edr><\/edrg>/gs;


    while($TextBody=~/<$aug>(.*?)<\/$aug>/)
      {
	my $Text=$1;

	if($Text!~/<au>|<edr>/)
	  {
	    $TextBody=~s/<$aug>(.*?)<\/$aug>/<ia>$Text<\/ia>/o;
	  }else
	    {
	      $TextBody=~s/<$aug>(.*?)<\/$aug>/<X$aug>$Text<\/X$aug>/o;
	    }
      }
    $TextBody=~s/<\/edr>\, ([A-Z][a-z]+) ([A-Z‚Äì\-\. ]+)\, $regx{editorSuffix}<\/Xedrg>/<\/edr>\, <edr><eds>$1<\/eds> <edm>$2<\/edm><\/edr>\, $3<\/Xedrg>/gs;

    # <ia>Statistisches Bundesamt. Hrsg.</ia>
    $TextBody=~s/<ia>([^<>]+?)([\.\,\;\:]?) $regx{editorSuffix}([\.]?)<\/ia>/<ia>$1<\/ia>$2 $3$4/gs;

    $TextBody=~s/<ia>([hH][tT][tT][pP][sd]?|[fF][tT][pP])<\/ia>/$1/gs;
    $TextBody=~s/<ia>([a-zA-Z]+)<\/ia>\:([a-zA-Z]+) ([(]?<yr>)/<ia>$1\:$2<\/ia> $3/gs;
    $TextBody=~s/<ia>([A-Z][a-z]+)\, ([A-Z\-\.]+) ([A-Z][a-z]+)<\/ia>/<edrg><edr><eds>$1<\/eds>\, <edm>$2 $3<\/edm><\/edr><\/edrg>/gs;
    $TextBody=~s/<([\/]?)X$aug>/<$1$aug>/gs;
    $TextBody=~s/<$au><$auf>([^<>]*?)<\/$auf> <$aus>([A-Z‚Äì\-\. ]+)<\/$aus><\/$au>/<$au><$aus>$1<\/$aus> <$auf>$2<\/$auf><\/$au>/gs;
    $TextBody=~s/([A-Z])<\/edm>\. <(eds|suffix|par)>/$1\.<\/edm> <$2>/gs;



    return $TextBody;
}
#============================================================================================================
sub authorstyle1
{
    my $AuthorGroup="";
    my $au="";
    $AuthorGroup=shift;
    $au=shift;
    my $aus=shift;
    my $auf=shift;
    my $AuthorString=shift;


    #print "Style1: $AuthorGroup\n";

    $AuthorGroup=~s/^$regx{mAuthorString}\, $regx{firstName}\, $regx{firstName}\, $regx{mAuthorString}$/<$au><$aus>$1<\/$aus>\, <$auf>$2<\/$auf><\/$au>\, <$au><$auf>$3<\/$auf>\, <$aus>$4<\/$aus><\/$au>/gs;
    $AuthorGroup=~s/^$regx{mAuthorString}\, $regx{firstName}\, $regx{firstName}\, $regx{mAuthorString}([\,]?) $regx{and} $regx{firstName}([\,]?) $regx{mAuthorString}$/<$au><$aus>$1<\/$aus>\, <$auf>$2<\/$auf><\/$au>\, <$au><$auf>$3<\/$auf>\, <$aus>$4<\/$aus><\/$au>$5 $6 <$au><$auf>$7<\/$auf>$8 <$aus>$9<\/$aus><\/$au>/gs;
    $AuthorGroup=~s/(^|\, )$regx{mAuthorFullSirName}\, $regx{firstName}\, $regx{suffix}([\,]?) $regx{and} $regx{mAuthorFullSirName}\, $regx{firstName}$/$1<$au><$aus>$2<\/$aus>\, <$auf>$3<\/$auf>, <suffix>$4<\/suffix><\/$au>$5 $6 <$au><$aus>$7<\/$aus>\, <$auf>$8<\/$auf><\/$au>/gs;

    #Feng, X. L., Jr., Zhu, L., Zhang, L., Song, D., Hipgrave,
    $AuthorGroup=~s/^$regx{mAuthorFullSirName}, $regx{firstName}, $regx{suffix}\; $regx{mAuthorFullSirName}, $regx{firstName}$/<$au><$aus>$1<\/aus>, <$auf>$2<\/$auf>, <suffix>$3<\/suffix><\/$au>\; <$au><$aus>$4<\/$aus>, <$auf>$5<\/$auf><\/$au>/gs;

   # print "$AuthorGroup\n";


     if($AuthorGroup=~/^$regx{mAuthorString}\, $regx{firstName}\, $regx{firstName}\, $regx{mAuthorString}\, $regx{firstName}/)
       {
	$AuthorGroup=&authorstyle3($AuthorGroup, $au, $aus, $auf, $AuthorString);
       }

    $AuthorGroup=~s/^$regx{particle} $regx{mAuthorString} $regx{firstName}$/<$au><par>$1<\/par> <$aus>$2<\/$aus> <$auf>$3<\/$auf><\/$au>/g;
    $AuthorGroup=~s/^$regx{particle} $regx{mAuthorString}\, $regx{firstName}$/<$au><par>$1<\/par> <$aus>$2<\/$aus>\, <$auf>$3<\/$auf><\/$au>/g;
    $AuthorGroup=~s/^$regx{mAuthorString}([\,]?) ([A-Z‚Äì\.\- ]+[vdhtj\. ]*?)([\,]*) (et[\.]? al[\.]?|<i>et[\.]? al[\.]?<\/i>[\.]?)$/<$au><$aus>$1<\/$aus>$2 <$auf>$3<\/$auf>$4 $5<\/$au>/o;
 
    $AuthorGroup=~s/^$regx{mAuthorString} $regx{mAuthorString} $regx{firstName}$/<$au><$aus>$1 $2<\/$aus> <$auf>$3<\/$auf><\/$au>/o;
    $AuthorGroup=~s/^$regx{mAuthorString} $regx{mAuthorString}\, $regx{firstName}$/<$au><$aus>$1 $2<\/$aus>\, <$auf>$3<\/$auf><\/$au>/o;

    $AuthorGroup=~s/^$regx{mAuthorString} $regx{firstName} $regx{suffix}$/<$au><$aus>$1<\/$aus> <$auf>$2<\/$auf> <suffix>$3<\/suffix><\/$au>/g;

    $AuthorGroup=~s/^$regx{mAuthorString} $regx{suffix} $regx{firstName}$/<$au><$aus>$1<\/$aus> <par>$2<\/par> <suffix>$3<\/suffix><\/$au>/g;
    $AuthorGroup=~s/^$regx{mAuthorString}\, $regx{firstName} $regx{suffix}$/<$au><$aus>$1<\/$aus>\, <$auf>$2<\/$auf> <suffix>$3<\/suffix><\/$au>/g;

    $AuthorGroup=~s/^$regx{mAuthorString} $regx{firstName} $regx{particle}$/<$au><$aus>$1<\/$aus> <$auf>$2<\/$auf> <par>$3<\/par><\/$au>/g;
    $AuthorGroup=~s/^$regx{mAuthorString} $regx{particle} $regx{firstName}$/<$au><$aus>$1<\/$aus> <par>$2<\/par> <$auf>$3<\/$auf><\/$au>/g;
    $AuthorGroup=~s/^$regx{firstName} $regx{particle} $regx{mAuthorString}$/<$au><$auf>$1<\/$auf> <par>$2<\/par> <$aus>$3<\/$aus><\/$au>/g;
    $AuthorGroup=~s/^$regx{mAuthorString}\, $regx{firstName} $regx{particle}$/<$au><$aus>$1<\/$aus>\, <$auf>$2<\/$auf> <par>$3<\/par><\/$au>/g;


     $AuthorGroup=~s/\, $regx{mAuthorString}\, $regx{firstName}([\,]?[ ]?¬Ö[ ]?|[\,]?[ ]?‚Ä¶[ ]?|[\,]?[ ]?\.\.\.[ ]?|[\,]?[ ]?[¬Ö¶]+[ ]?)$regx{mAuthorString}\, $regx{firstName}$/\, <$au><$aus>$1<\/$aus>\, <$auf>$2<\/$auf><\/$au>$3<$au><$aus>$4<\/$aus>\, <$auf>$5<\/$auf><\/$au>/gs;

    $AuthorGroup=~s/^(v\.[$AuthorString ]+)\, $regx{firstName}$/<$au><$aus>$1<\/$aus>, <$auf>$2<\/$auf><\/$au>/o;
    $AuthorGroup=~s/^$regx{mAuthorString}\, $regx{firstName}$/<$au><$aus>$1<\/$aus>, <$auf>$2<\/$auf><\/$au>/o;

    $AuthorGroup=~s/^$regx{sAuthorString}([\,]*) $regx{firstName}([\,]*) ([Jj]r[\.]?|[Ss]r[\.]?|1st[\.]?|2nd[\.]?|3rd[\.]?|4th[\.]?|II|III|von|van|dos|Van|De|Jac|Yu|MD|PhD|MHA|MS|PhD\, MHA|MHA\, PhD|MD\, MS|MS\, MD)$/<$au><$aus>$1<\/$aus>$2 <$auf>$3<\/$auf>$4 <suffix>$5<\/suffix><\/$au>/o;

    $AuthorGroup=~s/([\s]*)$regx{sAuthorString}([\,]*) $regx{firstName}([\,]*) $regx{and} $regx{sAuthorString}([\,]*) $regx{firstName}\, ([Jj]r[\.]?|[Ss]r[\.]?|1st[\.]?|2nd[\.]?|3rd[\.]?|4th[\.]?|II[\.]?|III[\.]?|von|van|dos|Van|De|Jac|Yu|MD|PhD|MHA|MS|PhD\, MHA|MHA\, PhD|MD\, MS|MS\, MD)$/$1<$au><$aus>$2<\/$aus>$3 <$auf>$4<\/$auf><\/$au>$5 $6 <$au><$aus>$7<\/$aus>$8 <$auf>$9<\/$auf>\, <suffix>$10<\/suffix><\/$au>/o;
    $AuthorGroup=~s/([\,]*) $regx{sAuthorString}([\,]*) $regx{firstName}\, ([Jj]r[\.]?|[Ss]r[\.]?|1st[\.]?|2nd[\.]?|3rd[\.]?|4th[\.]?|II[\.]?|III[\.]?|von|van|dos|Van|De|Jac|Yu|MD|PhD|MHA|MS|PhD\, MHA|MHA\, PhD|MD\, MS|MS\, MD)$/$1 <au><$aus>$2<\/$aus> <$auf>$3<\/$auf>$4 <suffix>$5<\/suffix><\/au>/o;


    #Eemeren, F. H. van, and R. Grootendorst
    $AuthorGroup=~s/(^|\, )$regx{mAuthorString}([\,]?) $regx{firstName} $regx{particle}([\,]?) $regx{and} $regx{mAuthorString}([\,]?) $regx{firstName}$/$1<$au><$aus>$2<\/$aus>$3 <$auf>$4<\/$auf> <par>$5<\/par><\/$au>$6 $7 <$au><$aus>$8<\/$aus>$9 <$auf>$10<\/$auf><\/$au>/o;
    $AuthorGroup=~s/(^|\, )$regx{mAuthorString}([\,]?) $regx{firstName} $regx{particle}([\,]?) $regx{and} $regx{firstName}([\,]?) $regx{mAuthorString}$/$1<$au><$aus>$2<\/$aus>$3 <$auf>$4<\/$auf> <par>$5<\/par><\/$au>$6 $7 <$au><$auf>$8<\/$auf>$9 <$aus>$10<\/$aus><\/$au>/o;


    #Schufle, J.A. D‚ÄôAgostino, Jr., C.
    $AuthorGroup=~s/(^|\, )$regx{mAuthorString}([\,]?) $regx{firstName}([\,]?) $regx{and} $regx{mAuthorString}([\,]?) $regx{suffix}([\,]?) $regx{firstName}$/$1<$au><$aus>$2<\/$aus>$3 <$auf>$4<\/$auf><\/$au>$5 $6 <$au><$aus>$7<\/$aus>$8 <suffix>$9<\/suffix>$10 <$auf>$11<\/$auf><\/$au>/o;
    #, Shull, Jr., C.M. and Grant, D.M.
    $AuthorGroup=~s/(^|\, )$regx{mAuthorString}([\,]?) $regx{suffix}([\,]?) $regx{firstName}([\,]?) $regx{and} $regx{mAuthorString}([\,]?) $regx{firstName}$/$1<$au><$aus>$2<\/$aus>$3 <suffix>$4<\/suffix>$5 <$auf>$6<\/$auf><\/$au>$7 $8 <$au><$aus>$9<\/$aus>$10 <$auf>$11<\/$auf><\/$au>/o;
    $AuthorGroup=~s/(^|\, )$regx{mAuthorString}([\,]?) $regx{suffix}([\,]?) $regx{firstName}([\,]?) $regx{and} $regx{mAuthorString}([\,]?) $regx{suffix}([\,]?) $regx{firstName}$/$1<$au><$aus>$2<\/$aus>$3 <suffix>$4<\/suffix>$5 <$auf>$6<\/$auf><\/$au>$7 $8 <$au><$aus>$9<\/$aus>$10 <suffix>$11<\/suffix>$12 <$auf>$13<\/$auf><\/$au>/o;

    #Bopp, J. & Lane, P. Jr. 
    $AuthorGroup=~s/(^|\, )$regx{mAuthorString}([\,]?) $regx{firstName}([\,]?) $regx{and} $regx{mAuthorString}([\,]?) $regx{firstName} $regx{suffix}$/$1<$au><$aus>$2<\/$aus>$3 <$auf>$4<\/$auf><\/$au>$5 $6 <$au><$aus>$7<\/$aus>$8 <$auf>$9<\/$auf> <suffix>$10<\/suffix><\/$au>/o;
    $AuthorGroup=~s/(^|\, )$regx{mAuthorString}([\,]?) $regx{firstName} $regx{suffix}([\,]?) $regx{and} $regx{mAuthorString}([\,]?) $regx{firstName}$/$1<$au><$aus>$2<\/$aus>$3 <$auf>$4<\/$auf> <suffix>$5<\/suffix><\/$au>$6 $7 <$au><$aus>$8<\/$aus>$9 <$auf>$10<\/$auf><\/$au>/o;

    $AuthorGroup=~s/^\b$regx{particle}([\s]*)$regx{sAuthorString}([\,]?) $regx{firstName}([\,]*) $regx{etal}$/<$au><par>$1<\/par>$2<$aus>$3<\/$aus>$4 <$auf>$5<\/$auf>$6 $7<\/$au>/o;

#van Nunen, et al.
    $AuthorGroup=~s/^$regx{mAuthorString}([\,]?) $regx{firstName}([\,]*) $regx{etal}$/<$au><$aus>$1<\/$aus>$2 <$auf>$3<\/$auf>$4 $5<\/$au>/o;

    $AuthorGroup=~s/([\s]*)\b$regx{particle}([\s]*)$regx{sAuthorString}([\,]?) $regx{firstName}([\,]*) $regx{etal}$/$1<$au><par>$2<\/par>$3<$aus>$4<\/$aus>$5 <$auf>$6<\/$auf>$7 $8<\/$au>/o;

    $AuthorGroup=~s/([\.\,\s]*)$regx{mAuthorString}([\,]?) $regx{firstName}([\,]*) $regx{etal}$/$1<$au><$aus>$2<\/$aus>$3 <$auf>$4<\/$auf>$5 $6<\/$au>/o;
    $AuthorGroup=~s/^$regx{firstName} $regx{mAuthorString}([\,]?) $regx{etal}$/<$au><$aus>$1<\/$aus> <$auf>$2<\/$auf>$3 $4<\/$au>/o;
    $AuthorGroup=~s/\, $regx{firstName} $regx{mAuthorString}([\,]?) $regx{etal}$/\, <$au><$aus>$1<\/$aus> <$auf>$2<\/$auf>$3 $4<\/$au>/o;

    $AuthorGroup=~s/(^|[\,\;] )$regx{firstName}([\,]?) $regx{particle} $regx{mAuthorString}([\,]?) $regx{and} $regx{firstName}([\,]?) $regx{mAuthorString}$/$1<$au><$auf>$2<\/$auf>$3 <par>$4<\/par> <$aus>$5<\/$aus><\/$au>$6 $7 <$au><$auf>$8<\/$auf>$9 <$aus>$10<\/$aus><\/$au>/o;
    $AuthorGroup=~s/(^|[\,\;] )$regx{firstName}([\,]?) $regx{particle} $regx{mAuthorString}([\,]?) $regx{and} $regx{mAuthorString}([\,]?) $regx{firstName}$/$1<$au><$auf>$2<\/$auf>$3 <par>$4<\/par> <$aus>$5<\/$aus><\/$au>$6 $7 <$au><$aus>$8<\/$aus>$9 <$auf>$10<\/$auf><\/$au>/o;
    $AuthorGroup=~s/(^|[\,\;] )$regx{firstName}([\,]?) $regx{particle} $regx{mAuthorString}([\,]?) $regx{and} $regx{firstName}([\,]?) $regx{mAuthorString}$/$1<$au><$auf>$2<\/$auf>$3 <par>$4<\/par> <$aus>$5<\/$aus><\/$au>$6 $7 <$au><$auf>$8<\/$auf>$9 <$aus>$10<\/$aus><\/$au>/o;

    $AuthorGroup=~s/^$regx{mAuthorString}([\,]?) $regx{firstName}([\,]?) $regx{and} $regx{firstName} $regx{mAuthorString} $regx{suffix}$/<$au><$aus>$1<\/$aus>$2 <$auf>$3<\/$auf><\/$au>$4 $5 <$au><$auf>$6<\/$auf> <$aus>$7<\/$aus> <suffix>$8<\/suffix><\/$au>/o;

    $AuthorGroup=~s/^$regx{mAuthorString}([\,]) $regx{firstName}([\,]?) $regx{and} $regx{mAuthorString}([\,]) $regx{firstName} $regx{suffix}$/<$au><$aus>$1<\/$aus>$2 <$auf>$3<\/$auf><\/$au>$4 $5 <$au><$aus>$6<\/$aus>$7 <$auf>$8<\/$auf> <suffix>$9<\/suffix><\/$au>/o;
    $AuthorGroup=~s/^$regx{mAuthorString}([\,]?) $regx{firstName} $regx{suffix}([\,]?) $regx{and} $regx{mAuthorString}([\,]?) $regx{firstName}$/<$au><$aus>$1<\/$aus>$2 <$auf>$3<\/$auf> <suffix>$4<\/suffix><\/$au>$5 $6 <$au><$aus>$7<\/$aus>$8 <$auf>$9<\/$auf><\/$au>/o;
    $AuthorGroup=~s/^$regx{mAuthorString}([\,]?) $regx{firstName} $regx{suffix}([\,]?) $regx{and} $regx{mAuthorString}([\,]?) $regx{firstName} $regx{suffix}$/<$au><$aus>$1<\/$aus>$2 <$auf>$3<\/$auf> <suffix>$4<\/suffix><\/$au>$5 $6 <$au><$aus>$7<\/$aus>$8 <$auf>$9<\/$auf> <suffix>$10<\/suffix><\/$au>/o;

    #Badaruddoza, A. J. S., Bhanwer, M., Rambani, R., Singh, K. Matharoo, and R. N. K. Bamezai
    $AuthorGroup=~s/^$regx{mAuthorString}\, $regx{firstName}\, ([^<>]+?)\, $regx{mAuthorString}\, $regx{firstName} $regx{sAuthorString}([\,]?) $regx{and}([\,]?) $regx{firstName}([\,]?) $regx{mAuthorString}$/$1\, $2\, $3\, <$au><$aus>$4<\/$aus>\, <$auf>$5 $6<\/$auf><\/$au>$7 $8$9 <$au><$auf>$10<\/$auf>$11 <$aus>$12<\/$aus><\/$au>/gs;
    $AuthorGroup=~s/^$regx{mAuthorString}\, $regx{firstName}\, ([^<>]+?)\, $regx{mAuthorString}\, $regx{firstName} $regx{sAuthorString}([\,]?) $regx{and}([\,]?) $regx{firstName}([\,]?) $regx{mAuthorString} $regx{suffix}$/$1\, $2\, $3\, <$au><$aus>$4<\/$aus>\, <$auf>$5 $6<\/$auf><\/$au>$7 $8$9 <$au><$auf>$10<\/$auf>$11 <$aus>$12<\/$aus> <suffix>$13<\/suffix><\/$au>/gs;

    $AuthorGroup=~s/^$regx{mAuthorString}\, $regx{firstName}\, $regx{mAuthorString}\, $regx{firstName} $regx{sAuthorString}([\,]?) $regx{and}([\,]?) $regx{firstName}([\,]?) $regx{mAuthorString}$/$1\, $2\, <$au><$aus>$3<\/$aus>\, <$auf>$4 $5<\/$auf><\/$au>$6 $7$8 <$au><$auf>$9<\/$auf>$10 <$aus>$11<\/$aus><\/$au>/gs;
    $AuthorGroup=~s/^$regx{mAuthorString}\, $regx{firstName}\, $regx{mAuthorString}\, $regx{firstName} $regx{sAuthorString}([\,]?) $regx{and}([\,]?) $regx{firstName}([\,]?) $regx{mAuthorString}  $regx{suffix}$/$1\, $2\, <$au><$aus>$3<\/$aus>\, <$auf>$4 $5<\/$auf><\/$au>$6 $7$8 <$au><$auf>$9<\/$auf>$10 <$aus>$11<\/$aus> <suffix>$13<\/suffix><\/$au>/gs;


    $AuthorGroup=~s/^$regx{particle} $regx{mAuthorString}([\,]?) $regx{firstName}([\,]?) $regx{and} $regx{firstName}([\,]?) $regx{mAuthorString}$/<$au><par>$1<\/par> <$aus>$2<\/$aus>$3 <$auf>$4<\/$auf><\/$au>$5 $6 <$au><$auf>$7<\/$auf>$8 <$aus>$9<\/$aus><\/$au>/o;
    $AuthorGroup=~s/^$regx{particle} $regx{mAuthorString}([\,]?) $regx{firstName}([\,]?) $regx{and} $regx{mAuthorString}([\,]?) $regx{firstName}$/<$au><par>$1<\/par> <$aus>$2<\/$aus>$3 <$auf>$4<\/$auf><\/$au>$5 $6 <$au><$aus>$7<\/$aus>$8 <$auf>$9<\/$auf><\/$au>/;

    $AuthorGroup=~s/^$regx{sAuthorString}\, $regx{firstName}([\,]?) $regx{and} $regx{sAuthorString} $regx{suffix}([\,]?) $regx{firstName}$/<$au><$aus>$1<\/$aus>, <$auf>$2<\/$auf><\/$au>$3 $4 <$au><$aus>$5<\/$aus> <suffix>$6<\/suffix>$7 <$auf>$8<\/$auf><\/$au>/;
    $AuthorGroup=~s/^$regx{sAuthorString} $regx{suffix}([\,]?) $regx{firstName}([\,]?) $regx{and} $regx{sAuthorString} $regx{suffix}([\,]?) $regx{firstName}$/<$au><$aus>$1<\/$aus> <suffix>$2<\/suffix>$3 <$auf>$4<\/$auf><\/$au>$5 $6 <$au><$aus>$7<\/$aus> <suffix>$8<\/suffix>$9 <$auf>$10<\/$auf><\/$au>/o;

    #, Carpenter, G. S., & Sherry Jr., J. F

    $AuthorGroup=~s/^$regx{mAuthorString}([\,]?) $regx{firstName}([\,]?) $regx{and} $regx{firstName}([\,]?) $regx{mAuthorString}$/<$au><$aus>$1<\/$aus>$2 <$auf>$3<\/$auf><\/$au>$4 $5 <$au><$auf>$6<\/$auf>$7 <$aus>$8<\/$aus><\/$au>/o;

    $AuthorGroup=~s/^$regx{mAuthorString}([\,]?) $regx{firstName}([\,]?) $regx{and} $regx{sAuthorString}([\,]?) $regx{firstName}$/<$au><$aus>$1<\/$aus>$2 <$auf>$3<\/$auf><\/$au>$4 $5 <$au><$aus>$6<\/$aus>$7 <$auf>$8<\/$auf><\/$au>/o;

    $AuthorGroup=~s/^$regx{sAuthorString}\, $regx{firstName}([\,]?) $regx{and} $regx{firstName} $regx{sAuthorString}([\,]?) $regx{firstName}$/<$au><$aus>$1<\/$aus>, <$auf>$2<\/$auf><\/$au>$3 $4 <$au><$aus>$5 $6<\/$aus>$7 <$auf>$8<\/$auf><\/$au>/o;

    $AuthorGroup=~s/\, $regx{firstName} $regx{sAuthorString}([\,]?) $regx{and} $regx{sAuthorString} $regx{firstName}$/\, <$au><$auf>$1<\/$auf>, <$aus>$2<\/$aus><\/$au>$3 $4 <$au><$aus>$5<\/$aus> <$auf>$6<\/$auf><\/$au>/o;

   # Sloane, N.J.A. and A.D. Wyner, A.D.
    $AuthorGroup=~s/^$regx{sAuthorString}\, $regx{firstName}([\,]?) $regx{and} $regx{sAuthorString}([\,]?) $regx{firstName} $regx{suffix}$/<$au><$aus>$1<\/$aus>, <$auf>$2<\/$auf><\/$au>$3 $4 <$au><$aus>$5<\/$aus>$6 <$auf>$7<\/$auf> <suffix>$8<\/suffix><\/$au>/o;

    $AuthorGroup=~s/([\s]+)$regx{particle} $regx{mAuthorString}([\,]?) $regx{firstName}([\,]?) $regx{and} $regx{firstName}([\,]?) $regx{mAuthorString}$/$1<$au><par>$2<\/par> <$aus>$3<\/$aus>$4 <$auf>$5<\/$auf><\/$au>$6 $7 <$au><$auf>$8<\/$auf>$9 <$aus>$10<\/$aus><\/$au>/o;
    $AuthorGroup=~s/([\s]+)$regx{particle} $regx{mAuthorString}([\,]?) $regx{firstName}([\,]?) $regx{and} $regx{mAuthorString}([\,]?) $regx{firstName}$/$1<$au><par>$2<\/par> <$aus>$3<\/$aus>$4 <$auf>$5<\/$auf><\/$au>$6 $7 <$au><$aus>$8<\/$aus>$9 <$auf>$10<\/$auf><\/$au>/o;
    $AuthorGroup=~s/([\s]+)$regx{mAuthorString}([\,]?) $regx{firstName} $regx{particle}([\,]?) $regx{and} $regx{mAuthorString}([\,]?) $regx{firstName}$/$1<$au><$aus>$2<\/$aus>$3 <$auf>$4<\/$auf> <par>$5<\/par><\/$au>$6 $7 <$au><$aus>$8<\/$aus>$9 <$auf>$10<\/$auf><\/$au>/o;
    $AuthorGroup=~s/([\s]+)$regx{mAuthorString}([\,]?) $regx{firstName} $regx{particle}([\,]?) $regx{and} $regx{firstName}([\,]?) $regx{mAuthorString}$/$1<$au><$aus>$2<\/$aus>$3 <$auf>$4<\/$auf> <par>$5<\/par><\/$au>$6 $7 <$au><$auf>$8<\/$auf>$9 <$aus>$10<\/$aus><\/$au>/o;


#Rissanen, J.J. and Langdon, G.G. Jr
    $AuthorGroup=~s/([\s]*)$regx{mAuthorString}([\,]?) $regx{firstName}([\,]?) $regx{and} $regx{mAuthorString}([\,]?) $regx{firstName}$/$1<$au><$aus>$2<\/$aus>$3 <$auf>$4<\/$auf><\/$au>$5 $6 <$au><$aus>$7<\/$aus>$8 <$auf>$9<\/$auf><\/$au>/o;

    $AuthorGroup=~s/([\s]*)$regx{sAuthorString}([\,]?) $regx{firstName}([\,]?) $regx{and} $regx{firstName} $regx{mAuthorString}([\.]?)$/$1<$au><$aus>$2<\/$aus>$3 <$auf>$4<\/$auf><\/$au>$5 $6 <$au><$auf>$7<\/$auf> <$aus>$8<\/$aus>$9<\/$au>/o;
    $AuthorGroup=~s/ $regx{firstName} $regx{sAuthorString}([\,]?) $regx{and} $regx{firstName} $regx{mAuthorString}$/ <$au><$auf>$1<\/$auf> <$aus>$2<\/$aus><\/$au>$3 $4 <$au><$auf>$5<\/$auf> <$aus>$6<\/$aus><\/$au>/o;
    $AuthorGroup=~s/ $regx{sAuthorString}([\,]?) $regx{firstName}([\,]?) $regx{and} $regx{firstName} $regx{mAuthorString}$/ <$au><$aus>$1<\/$aus>$2 <$auf>$3<\/$auf><\/$au>$4 $5 <$au><$auf>$6<\/$auf> <$aus>$7<\/$aus><\/$au>/o;
    $AuthorGroup=~s/([\s]*)$regx{sAuthorString}([\.\,]?) $regx{firstName}([\,]?) $regx{and} $regx{sAuthorString}([\.\,]?) $regx{firstName}$/$1<$au><$aus>$2<\/$aus>$3 <$auf>$4<\/$auf><\/$au>$5 $6 <$au><$aus>$7<\/$aus>$8 <$auf>$9<\/$auf><\/$au>/o;

    $AuthorGroup=~s/ $regx{sAuthorString}\, $regx{firstName}([\,]?) $regx{and} $regx{sAuthorString} $regx{suffix}([\,]?) $regx{firstName}$/ <$au><$aus>$1<\/$aus>, <$auf>$2<\/$auf><\/$au>$3 $4 <$au><$aus>$5<\/$aus> <suffix>$6<\/suffix>$7 <$auf>$8<\/$auf><\/$au>/;
    $AuthorGroup=~s/ $regx{sAuthorString} $regx{suffix}([\,]?) $regx{firstName}([\,]?) $regx{and} $regx{sAuthorString} $regx{suffix}([\,]?) $regx{firstName}$/ <$au><$aus>$1<\/$aus> <suffix>$2<\/suffix>$3 <$auf>$4<\/$auf><\/$au>$5 $6 <$au><$aus>$7<\/$aus> <suffix>$8<\/suffix>$9 <$auf>$10<\/$auf><\/$au>/o;


    #Schulz, M. & [VV]An Dorland, R.
    $AuthorGroup=~s/([\s]*)$regx{sAuthorString}([\.\,]?) $regx{firstName}([\,]?) $regx{and} $regx{mAuthorString}([\.\,]?) $regx{firstName}$/$1<$au><$aus>$2<\/$aus>$3 <$auf>$4<\/$auf><\/$au>$5 $6 <$au><$aus>$7<\/$aus>$8 <$auf>$9<\/$auf><\/$au>/o;

    $AuthorGroup=~s/ $regx{sAuthorString}\, $regx{firstName}([\,]?) $regx{and} $regx{firstName} $regx{sAuthorString}([\,]?) $regx{firstName}$/ <$au><$aus>$1<\/$aus>, <$auf>$2<\/$auf><\/$au>$3 $4 <$au><$aus>$5 $6<\/$aus>$7 <$auf>$8<\/$auf><\/$au>/o;

    #Dulta, P.C. and B.S. Rana, 
    $AuthorGroup=~s/^$regx{sAuthorString}\, $regx{firstName}([\,]?) $regx{and} $regx{firstName} $regx{sAuthorString}\, / <$au><$aus>$1<\/$aus>, <$auf>$2<\/$auf><\/$au>$3 $4 <$au><$auf>$5<\/$auf> <$aus>$6<\/$aus><\/$au>\, /o;

    #Kanasewich, E.R. and Phadke
    $AuthorGroup=~s/([\s]*)$regx{sAuthorString}([\.\,]?) $regx{firstName}([\,]?) $regx{and} $regx{mAuthorString}$/$1<$au><$aus>$2<\/$aus>$3 <$auf>$4<\/$auf><\/$au>$5 $6 <$au><$aus>$7<\/$aus><\/$au>/o;

   $AuthorGroup=~s/([\,]*) $regx{sAuthorString} $regx{firstName}\, <au>/$1 <au><$aus>$2<\/$aus> <$auf>$3<\/$auf><\/au>\, <au>/o;
   $AuthorGroup=~s/([\,]*) $regx{sAuthorString}\, $regx{firstName}\, ([Jj]r[\.]?|[Ss]r[\.]?|1st[\.]?|2nd[\.]?|3rd[\.]?|4th[\.]?|II[\.]?|III[\.]?|von|van|dos|Van|De|Jac|Yu|MD|PhD|MHA|MS|PhD\, MHA|MHA\, PhD|MD\, MS|MS\, MD)\, <au>/$1 <au><$aus>$2<\/$aus> <$auf>$3<\/$auf>\, <suffix>$4<\/suffix><\/au>\, <au>/o;

    $AuthorGroup=~s/\, \b$regx{particle}([\s]*)$regx{sAuthorString}([\,]?) $regx{etal}$/\, <$au><par>$1<\/par>$2<$aus>$3<\/$aus>$4 $5<\/$au>/o;

    $AuthorGroup=~s/^$regx{sAuthorString} ([A-Zvd\-\. ]+)$/<$au><$aus>$1<\/$aus> <$auf>$2<\/$auf><\/$au>/gs;
    $AuthorGroup=~s/^$regx{sAuthorString}\, ([A-Zvd\-\. ]+)$/<$au><$aus>$1<\/$aus>\, <$auf>$2<\/$auf><\/$au>/gs;

    $AuthorGroup=~s/ $regx{sAuthorString}([\,]?) $regx{firstName} <au>/ $1$2 $3\, <au>/gs;

    $AuthorGroup=~s/^$regx{sAuthorString}\, ([A-Zvd\-\. ]+)([\,]?) $regx{and} $regx{sAuthorString} $regx{sAuthorString}$/<$au><$aus>$1<\/$aus>\, <$auf>$2<\/$auf><\/$au>$3 $4 <$au><$auf>$5<\/$auf> <$aus>$6<\/$aus><\/$au>/gs;

    $AuthorGroup=~s/\, $regx{firstName}\. $regx{mAuthorString} $regx{firstName}\. $regx{mAuthorString}$/\, <$au><$auf>$1<\/$auf>\. <$aus>$2<\/$aus><\/$au> <$au><$auf>$3<\/$auf>\. <$aus>$4<\/$aus><\/$au>/o;
    $AuthorGroup=~s/(^|[\,\;] )$regx{mAuthorFullSirName}\, $regx{firstName} $regx{and} $regx{mAuthorFullSirName}\, $regx{mAuthorFullFirstName}$/$1<$au><$aus>$2<\/$aus>\, <$auf>$3<\/$auf><\/$au> $4 <$au><$aus>$5<\/$aus>\, <$auf>$6<\/$auf><\/$au>/gs;


    # Eemeren, F. H. van,
     if($AuthorGroup=~/$regx{firstName} $regx{sAuthorString}\, <au>(.*)<\/au>/)
      {
    	my $TempAuthorGroup="<au>$3<\/au>";
    	$AuthorGroup=~s/$regx{firstName} $regx{sAuthorString}\, <au>(.*)<\/au>/$1 $2/s;
    	$AuthorGroup=~s/$regx{sAuthorString}\, $regx{firstName}\, $regx{sAuthorString}\, $regx{firstName} $regx{particle}/$1<comma> $2<AU> $3<comma> $4 $5/g;
    	$AuthorGroup=~s/^$regx{sAuthorString}\, $regx{firstName} $regx{particle}/$1<comma> $2 $3/g;
    	$AuthorGroup=~s/$regx{sAuthorString}\, $regx{firstName} $regx{particle}\, $regx{sAuthorString}\, $regx{firstName} $regx{particle}/$1<comma> $2 $3<AU> $4<comma> $5 $6/g;
    	$AuthorGroup=~s/$regx{sAuthorString}\, $regx{firstName} $regx{particle}\, $regx{sAuthorString}\, $regx{firstName}/$1<comma> $2 $3<AU> $4<comma> $5/g;
    	$AuthorGroup=~s/$regx{sAuthorString}\, $regx{firstName}\, /$1<comma> $2<AU>/g;
    	$AuthorGroup=~s/\,/<AU>/g;

	#print "TEST1: $AuthorGroup\n";

    	my @Authors=split(/<AU>/, $AuthorGroup);
    	my $Authors="";
    	foreach my $Author(@Authors)
    	{
	  $Author=&SplitedAuthorsMark($AuthorString, $Author, $au, $aus, $auf);

	  $Authors="$Authors".", $Author";
    	}
    	$Authors=~s/^\,//g;
    	$Authors=~s/^ //g;
    	$Authors=~s/<$aus> /<$aus>/g;
    	$Authors=~s/<$auf> /<$auf>/g;
    	$AuthorGroup="$Authors"."\, $TempAuthorGroup";
	$AuthorGroup=~s/<comma>/\,/gs;
    }
    elsif($AuthorGroup=~/$regx{sAuthorString}\, $regx{firstName} $regx{particle}\, <au>(.*)<\/au>/)
      {
    	my $TempAuthorGroup="<au>$4<\/au>";
    	$AuthorGroup=~s/$regx{sAuthorString}\, $regx{firstName} $regx{particle}\, <au>(.*)<\/au>/$1\, $2 $3/s;
    	$AuthorGroup=~s/$regx{sAuthorString}\, $regx{firstName}\, $regx{sAuthorString}\, $regx{firstName} $regx{particle}/$1\, $2<AU> $3\, $4 $5/g;
    	$AuthorGroup=~s/$regx{sAuthorString}\, $regx{firstName} $regx{particle}\, $regx{sAuthorString}\, $regx{firstName} $regx{particle}/$1\, $2 $3<AU> $4\, $5 $6/g;
    	$AuthorGroup=~s/$regx{sAuthorString}\, $regx{firstName} $regx{particle}\, $regx{sAuthorString}\, $regx{firstName}/$1\, $2 $3<AU> $4\, $5/g;
    	$AuthorGroup=~s/$regx{sAuthorString}\, $regx{firstName}\, $regx{sAuthorString}\, $regx{firstName}/$1\, $2<AU> $3\, $4/g;
    	$AuthorGroup=~s/$regx{sAuthorString}\, $regx{firstName}\, $regx{sAuthorString}\, $regx{firstName}/$1\, $2<AU> $3\, $4/g;
    	$AuthorGroup=~s/$regx{sAuthorString} $regx{firstName}\, $regx{sAuthorString}\, $regx{firstName}<AU>/$1\, $2<AU> $3\, $4<AU>/g;
	$AuthorGroup=~s/$regx{mAuthorFullSirName}\, $regx{firstName}\, $regx{mAuthorFullSirName}\, $regx{firstName}/$1\, $2<AU> $3\, $4/gs;

	#print "TEST2: $AuthorGroup\n";

    	$AuthorGroup=~s/\.\,/\.<AU>/g;

    	my @Authors=split(/<AU>/, $AuthorGroup);
    	my $Authors="";
    	foreach my $Author(@Authors)
    	{
	  $Author=&SplitedAuthorsMark($AuthorString, $Author, $au, $aus, $auf);
	  $Authors="$Authors".", $Author";

    	}
    	$Authors=~s/^\,//g;
    	$Authors=~s/^ //g;
    	$Authors=~s/<$aus> /<$aus>/g;
    	$Authors=~s/<$auf> /<$auf>/g;
    	$AuthorGroup="$Authors"."\, $TempAuthorGroup";
    }
    elsif($AuthorGroup=~/$regx{sAuthorString}\, $regx{firstName}\, <au>(.*)<\/au>/)
      {
    	my $TempAuthorGroup="<au>$3<\/au>";
    	$AuthorGroup=~s/$regx{sAuthorString}\, $regx{firstName}\, <au>(.*)<\/au>/$1\, $2/s;
    	$AuthorGroup=~s/\.\,/\.<AU>/g;
    	$AuthorGroup=~s/$regx{sAuthorString}\, $regx{firstName}\, $regx{sAuthorString}\, $regx{firstName}/$1\, $2<AU> $3\, $4/g;
    	$AuthorGroup=~s/$regx{sAuthorString}\, $regx{firstName}\, $regx{sAuthorString}\, $regx{firstName}/$1\, $2<AU> $3\, $4/g;
    	$AuthorGroup=~s/$regx{sAuthorString} $regx{firstName}\, $regx{sAuthorString}\, $regx{firstName}<AU>/$1\, $2<AU> $3\, $4<AU>/g;
	$AuthorGroup=~s/$regx{mAuthorFullSirName}\, $regx{firstName}\, $regx{mAuthorFullSirName}\, $regx{firstName}/$1\, $2<AU> $3\, $4/gs;
	$AuthorGroup=~s/$regx{mAuthorFullSirName}\, $regx{firstName}\; $regx{mAuthorFullSirName}\, $regx{firstName}/$1\, $2<AU> $3\, $4/gs;

	#print "TEST3: $AuthorGroup\n";

    	my @Authors=split(/<AU>/, $AuthorGroup);
    	my $Authors="";
    	foreach my $Author(@Authors)
    	{
	  $Author=&SplitedAuthorsMark($AuthorString, $Author, $au, $aus, $auf);
	  $Authors="$Authors".", $Author";

    	}
    	$Authors=~s/^\,//g;
    	$Authors=~s/^ //g;
    	$Authors=~s/<$aus> /<$aus>/g;
    	$Authors=~s/<$auf> /<$auf>/g;
    	$AuthorGroup="$Authors"."\, $TempAuthorGroup";
    }
    elsif($AuthorGroup=~/$regx{sAuthorString}\, $regx{firstName}\; <au>(.*)<\/au>/)
      {
    	my $TempAuthorGroup="<au>$3<\/au>";

    	$AuthorGroup=~s/$regx{sAuthorString}\, $regx{firstName}\; <au>(.*)<\/au>/$1\, $2/s;

    	$AuthorGroup=~s/\;/<AU>/g;
    	$AuthorGroup=~s/$regx{sAuthorString} $regx{firstName}\; $regx{sAuthorString}\, $regx{firstName}<AU>/$1\, $2<AU> $3\, $4<AU>/g;
    	$AuthorGroup=~s/$regx{sAuthorString} $regx{firstName}\, $regx{sAuthorString}\, $regx{firstName}<AU>/$1\, $2<AU> $3\, $4<AU>/g;
	$AuthorGroup=~s/$regx{mAuthorFullSirName}\, $regx{firstName}\, $regx{mAuthorFullSirName}\, $regx{firstName}/$1\, $2<AU> $3\, $4/gs;
	$AuthorGroup=~s/$regx{mAuthorFullSirName}\, $regx{firstName}\; $regx{mAuthorFullSirName}\, $regx{firstName}/$1\, $2<AU> $3\, $4/gs;

	#print "TEST4: $AuthorGroup\n";
    	my @Authors=split(/<AU>/, $AuthorGroup);
    	my $Authors="";
    	foreach my $Author(@Authors)
    	{
	  $Author=&SplitedAuthorsMark($AuthorString, $Author, $au, $aus, $auf);
	  $Authors="$Authors"."\; $Author";

    	}
    	$Authors=~s/^\;//g;
    	$Authors=~s/^ //g;
    	$Authors=~s/<$aus> /<$aus>/g;
    	$Authors=~s/<$auf> /<$auf>/g;
    	$AuthorGroup="$Authors"."\; $TempAuthorGroup";

    }
    elsif($AuthorGroup=~/<au>(.*)<\/au>\, $regx{firstName} $regx{sAuthorString}/)
      {
    	my $TempAuthorGroup="<au>$1<\/au>";
    	$AuthorGroup=~s/<au>(.*)<\/au>\, $regx{firstName} $regx{sAuthorString}/$2 $3/s;

	#print "TEST5: $AuthorGroup\n";

    	$AuthorGroup=~s/\.\,/\.<AU>/g;
    	$AuthorGroup=~s/\,/<AU>/g;

    	my @Authors=split(/<AU>/, $AuthorGroup);
    	my $Authors="";
    	foreach my $Author(@Authors)
    	{
	  $Author=&SplitedAuthorsMark($AuthorString, $Author, $au, $aus, $auf);
	  $Authors="$Authors".", $Author";

    	}
    	$Authors=~s/^\,//g;
    	$Authors=~s/^ //g;
    	$Authors=~s/<$aus> /<$aus>/g;
    	$Authors=~s/<$auf> /<$auf>/g;
    	$AuthorGroup="$TempAuthorGroup\, "."$Authors";

    }
    elsif($AuthorGroup=~/([$AuthorString]+)\, $regx{firstName}\.\, $regx{firstName} ([$AuthorString]+)/)
      {
	$AuthorGroup=~s/([$AuthorString]+)\, $regx{firstName}\.\, /$1<comma> $2\.<AU>/g;
	#print "TEST6: $AuthorGroup\n";
    	$AuthorGroup=~s/\, /<AU>/g;

    	my @Authors=split(/<AU>/, $AuthorGroup);

    	my $Authors="";
    	 foreach my $Author(@Authors)
    	 {
	  $Author=&SplitedAuthorsMark($AuthorString, $Author, $au, $aus, $auf);
    	    $Authors="$Authors".", $Author";
    	 }
    	 $Authors=~s/^\,//g;
    	 $Authors=~s/^ //g;
    	 $Authors=~s/<$aus> /<$aus>/g;
    	 $Authors=~s/<$auf> /<$auf>/g;
    	 $AuthorGroup="$Authors";

    }
    elsif($AuthorGroup=~/$regx{sAuthorString}\, $regx{firstName}\;/)
    {
      $AuthorGroup=~s/$regx{sAuthorString} $regx{firstName}\; $regx{sAuthorString}\, $regx{firstName}<AU>/$1\, $2<AU> $3\, $4<AU>/g;
      $AuthorGroup=~s/$regx{sAuthorString} $regx{firstName}\, $regx{sAuthorString}\, $regx{firstName}<AU>/$1\, $2<AU> $3\, $4<AU>/g;
      $AuthorGroup=~s/$regx{mAuthorFullSirName}\, $regx{firstName}\, $regx{mAuthorFullSirName}\, $regx{firstName}/$1\, $2<AU> $3\, $4/gs;
      $AuthorGroup=~s/$regx{mAuthorFullSirName}\, $regx{firstName}\; $regx{mAuthorFullSirName}\, $regx{firstName}/$1\, $2<AU> $3\, $4/gs;
      {}while($AuthorGroup=~s/(^|\, |<AU> )$regx{mAuthorFullSirName}, $regx{firstName}\, $regx{mAuthorFullSirName}, $regx{firstName}([\,\;])/$1$2, $3<AU> $4, $5$6/gs);
      while($AuthorGroup=~s/([\;] |<AU> )$regx{mAuthorFullSirName} $regx{firstName}\, $regx{mAuthorFullSirName} $regx{firstName}([\,\;]|$)/$1$2 $3<AU> $4 $5$6/gs){};

      #print "TEST7: $AuthorGroup\n";

      $AuthorGroup=~s/\;/<AU>/g;
      my @Authors=split(/<AU>/, $AuthorGroup);
    	my $Authors="";
    	foreach my $Author(@Authors)
    	{
	  $Author=&SplitedAuthorsMark($AuthorString, $Author, $au, $aus, $auf);
	  $Authors="$Authors"."\; $Author";

    	}
      $Authors=~s/^\;//g;
      $Authors=~s/^ //g;
      $Authors=~s/<$aus> /<$aus>/g;
      $Authors=~s/<$auf> /<$auf>/g;
      $AuthorGroup="$Authors";
    }
    elsif($AuthorGroup=~/$regx{sAuthorString} $regx{suffix}\, $regx{firstName}\;/)
    {
      $AuthorGroup=~s/$regx{sAuthorString} $regx{firstName}\; $regx{sAuthorString}\, $regx{firstName}<AU>/$1\, $2<AU> $3\, $4<AU>/g;
      $AuthorGroup=~s/$regx{sAuthorString} $regx{firstName}\, $regx{sAuthorString}\, $regx{firstName}<AU>/$1\, $2<AU> $3\, $4<AU>/g;
      $AuthorGroup=~s/$regx{mAuthorFullSirName}\, $regx{firstName}\, $regx{mAuthorFullSirName}\, $regx{firstName}/$1\, $2<AU> $3\, $4/gs;
      $AuthorGroup=~s/$regx{mAuthorFullSirName}\, $regx{firstName}\; $regx{mAuthorFullSirName}\, $regx{firstName}/$1\, $2<AU> $3\, $4/gs;
      $AuthorGroup=~s/<AU>$regx{mAuthorFullSirName}\, $regx{firstName}\. $regx{mAuthorFullSirName}<comma> $regx{firstName}\.<AU>/<AU>$1\, $2\.<AU> $3<comma> $4\.<AU>/gs;
      {}while($AuthorGroup=~s/(^|\, |<AU> )$regx{mAuthorFullSirName}, $regx{firstName}\, $regx{mAuthorFullSirName}, $regx{firstName}([\,\;])/$1$2, $3<AU> $4, $5$6/gs);

      #print "TEST8: $AuthorGroup\n";

      $AuthorGroup=~s/\;/<AU>/g;
      my @Authors=split(/<AU>/, $AuthorGroup);
    	my $Authors="";
    	foreach my $Author(@Authors)
    	{
	  $Author=&SplitedAuthorsMark($AuthorString, $Author, $au, $aus, $auf);
	  $Authors="$Authors"."\; $Author";

    	}
      $Authors=~s/^\;//g;
      $Authors=~s/^ //g;
      $Authors=~s/<$aus> /<$aus>/g;
      $Authors=~s/<$auf> /<$auf>/g;
      $AuthorGroup="$Authors";
    }
    elsif($AuthorGroup=~/\, $regx{sAuthorString} $regx{firstName}\, <au>(.*)<\/au>/)
      {
    	my $TempAuthorGroup="<au>$3<\/au>";
    	$AuthorGroup=~s/$regx{mAuthorString}\, $regx{firstName}\.\, /$1<comma> $2\.<AU>/g;
    	$AuthorGroup=~s/\, $regx{sAuthorString} $regx{firstName}\, <au>(.*)<\/au>/\, $1 $2/s;
	$AuthorGroup=~s/$regx{mAuthorFullSirName}\, $regx{firstName}\, $regx{mAuthorFullSirName}\, $regx{firstName}/$1\, $2<AU> $3\, $4/gs;
	$AuthorGroup=~s/$regx{mAuthorFullSirName}\, $regx{firstName}\; $regx{mAuthorFullSirName}\, $regx{firstName}/$1\, $2<AU> $3\, $4/gs;
	#print "TEST9: $AuthorGroup\n";

    	$AuthorGroup=~s/\,/<AU>/g;
    	my @Authors=split(/<AU>/, $AuthorGroup);
    	my $Authors="";
    	foreach my $Author(@Authors)
    	{
	  $Author=&SplitedAuthorsMark($AuthorString, $Author, $au, $aus, $auf);
	  $Authors="$Authors"."\, $Author";

    	}
    	$Authors=~s/^\;//g;
    	$Authors=~s/^ //g;
    	$Authors=~s/<$aus> /<$aus>/g;
    	$Authors=~s/<$auf> /<$auf>/g;
    	$AuthorGroup="$Authors"."\, $TempAuthorGroup";
    }
    elsif($AuthorGroup=~/^$regx{mAuthorString}\, $regx{firstName}\.\, $regx{mAuthorString} $regx{firstName}\, $regx{mAuthorString} $regx{firstName}/)
      {
    	$AuthorGroup=~s/$regx{mAuthorString}\, $regx{firstName}\.\, /$1<comma> $2\.<AU>/g;
	$AuthorGroup=~s/$regx{mAuthorFullSirName}\, $regx{firstName}\, $regx{mAuthorFullSirName}\, $regx{firstName}/$1\, $2<AU> $3\, $4/gs;
	$AuthorGroup=~s/$regx{mAuthorFullSirName}\, $regx{firstName}\; $regx{mAuthorFullSirName}\, $regx{firstName}/$1\, $2<AU> $3\, $4/gs;
	#print "TEST10: $AuthorGroup\n";

	$AuthorGroup=~s/\, /<AU>/g;
	my @Authors=split(/<AU>/, $AuthorGroup);
	my $Authors="";
	foreach my $Author(@Authors)
	{
	  $Author=&SplitedAuthorsMark($AuthorString, $Author, $au, $aus, $auf);
	  $Authors="$Authors".", $Author";
	}
	$Authors=~s/^\,//g;
	$Authors=~s/^ //g;
	$Authors=~s/<$aus> /<$aus>/g;
	$Authors=~s/<$auf> /<$auf>/g;
	$AuthorGroup="$Authors";
    }
     elsif($AuthorGroup=~/([$AuthorString]+)\, $regx{firstName}\.\,/)
    {
    	$AuthorGroup=~s/$regx{sAuthorString}\, $regx{firstName}\. $regx{sAuthorString}\, $regx{firstName}\.$/$1<comma> $2\.<AU>$3<comma> $4\./g;
    	$AuthorGroup=~s/$regx{sAuthorString}\, $regx{firstName}\. $regx{sAuthorString}\, $regx{firstName}\. /$1<comma> $2\.<AU>$3<comma> $4\.<AU>/g;
	$AuthorGroup=~s/$regx{sAuthorString}\, $regx{firstName}\, /$1<comma> $2<AU>/g;
    	$AuthorGroup=~s/$regx{sAuthorString}\, $regx{firstName}$/$1<comma> $2/g;
    	$AuthorGroup=~s/$regx{sAuthorString} $regx{firstName}\. $regx{sAuthorString} $regx{firstName}\, /$1 $2\.<AU>$3 $4<AU>/g;
    	$AuthorGroup=~s/$regx{sAuthorString}\, $regx{firstName}\, $regx{sAuthorString} $regx{firstName}$/$1<comma> $2<AU>$3 $4<AU>/g;
	$AuthorGroup=~s/$regx{sAuthorString} $regx{firstName}\. $regx{sAuthorString} $regx{firstName}$/$1 $2\.<AU>$3 $4/g;
	$AuthorGroup=~s/$regx{mAuthorFullSirName}\, $regx{firstName}\, $regx{mAuthorFullSirName}\, $regx{firstName}/$1\, $2<AU> $3\, $4/gs;
	$AuthorGroup=~s/$regx{mAuthorFullSirName}\, $regx{firstName}\; $regx{mAuthorFullSirName}\, $regx{firstName}/$1\, $2<AU> $3\, $4/gs;
	$AuthorGroup=~s/<AU>$regx{mAuthorFullSirName}\, $regx{firstName}\. $regx{mAuthorFullSirName}<comma> $regx{firstName}\.<AU>/<AU>$1\, $2\.<AU> $3<comma> $4\.<AU>/gs;
	$AuthorGroup=~s/\. $regx{mAuthorFullSirName}\, $regx{firstName}\. $regx{mAuthorFullSirName}<comma> $regx{firstName}\.<AU>/\. $1\, $2\.<AU> $3<comma> $4\.<AU>/gs;

	#print "TEST11: $AuthorGroup\n";

	$AuthorGroup=~s/$regx{sAuthorString} $regx{suffix}\., $regx{firstName}\, /$1 $2\.<comma> $3<AU>/g;
    	$AuthorGroup=~s/\.\,/\.<AU>/g;


	#Sekulic, D. Massey, G.
    	my @Authors=split(/<AU>/, $AuthorGroup);
    	my $Authors="";
    	foreach my $Author(@Authors)
    	{
	  $Author=&SplitedAuthorsMark($AuthorString, $Author, $au, $aus, $auf);
	  $Authors="$Authors".", $Author";

    	}
    	$Authors=~s/^\,//g;
    	$Authors=~s/^ //g;
    	$Authors=~s/<$aus> /<$aus>/g;
    	$Authors=~s/<$auf> /<$auf>/g;
    	$AuthorGroup="$Authors";
    }

     elsif($AuthorGroup=~/([$AuthorString]+)\, $regx{firstName}\,/)
    {
    	$AuthorGroup=~s/$regx{sAuthorString}\, $regx{firstName}\, $regx{sAuthorString}\, $regx{firstName}/$1<comma> $2<AU> $3<comma> $4/g;
    	$AuthorGroup=~s/$regx{sAuthorString}\, $regx{firstName}\, $regx{sAuthorString}\, $regx{firstName}/$1<comma> $2<AU> $3<comma> $4/g;
    	$AuthorGroup=~s/$regx{sAuthorString}\, $regx{firstName}\, /$1<comma> $2<AU>/g;
    	$AuthorGroup=~s/$regx{sAuthorString}\, $regx{firstName}$/$1<comma> $2/g;
    	$AuthorGroup=~s/$regx{sAuthorString} $regx{firstName}\. $regx{sAuthorString} $regx{firstName}\, /$1 $2\.<AU>$3 $4<AU>/g;
    	$AuthorGroup=~s/$regx{sAuthorString}\, $regx{firstName}\, $regx{sAuthorString} $regx{firstName}$/$1<comma> $2<AU>$3 $4<AU>/g;
	$AuthorGroup=~s/$regx{sAuthorString} $regx{firstName}\. $regx{sAuthorString} $regx{firstName}$/$1 $2\.<AU>$3 $4/g;
	$AuthorGroup=~s/$regx{mAuthorFullSirName}\, $regx{firstName}\, $regx{mAuthorFullSirName}\, $regx{firstName}/$1\, $2<AU> $3\, $4/gs;
	$AuthorGroup=~s/$regx{mAuthorFullSirName}\, $regx{firstName}\; $regx{mAuthorFullSirName}\, $regx{firstName}/$1\, $2<AU> $3\, $4/gs;
	#print "TEST12: $AuthorGroup\n";

    	$AuthorGroup=~s/\,/<AU>/g;

    	my @Authors=split(/<AU>/, $AuthorGroup);
    	my $Authors="";
    	foreach my $Author(@Authors)
    	{
	  $Author=&SplitedAuthorsMark($AuthorString, $Author, $au, $aus, $auf);
	  $Authors="$Authors".", $Author";

    	}
    	$Authors=~s/^\,//g;
    	$Authors=~s/^ //g;
    	$Authors=~s/<$aus> /<$aus>/g;
    	$Authors=~s/<$auf> /<$auf>/g;
    	$AuthorGroup="$Authors";
    }
    elsif($AuthorGroup=~/([$AuthorString]+) $regx{firstName}\,/)
    {
    	$AuthorGroup=~s/([$AuthorString ]+)\, $regx{firstName}\, /$1<comma> $2<AU>/g;
    	$AuthorGroup=~s/([$AuthorString ]+)\, $regx{firstName}$/$1<comma> $2/g;
    	$AuthorGroup=~s/([$AuthorString ]+) $regx{firstName}\. ([$AuthorString ]+) $regx{firstName}\, /$1 $2\.<AU>$3 $4<AU>/g;
    	$AuthorGroup=~s/([$AuthorString ]+)\, $regx{firstName}\, ([$AuthorString ]+) $regx{firstName}$/$1<comma> $2<AU>$3 $4<AU>/g;
	$AuthorGroup=~s/([$AuthorString ]+) $regx{firstName}\. ([$AuthorString ]+) $regx{firstName}$/$1 $2\.<AU>$3 $4/g;
	$AuthorGroup=~s/$regx{mAuthorFullSirName}\, $regx{firstName}\, $regx{mAuthorFullSirName}\, $regx{firstName}/$1\, $2<AU> $3\, $4/gs;
	$AuthorGroup=~s/$regx{mAuthorFullSirName}\, $regx{firstName}\; $regx{mAuthorFullSirName}\, $regx{firstName}/$1\, $2<AU> $3\, $4/gs;

	#print "TEST13: $AuthorGroup\n";

	$AuthorGroup=~s/\, /<AU>/g;
    	my @Authors=split(/<AU>/, $AuthorGroup);
    	my $Authors="";
    	foreach my $Author(@Authors)
    	{
	  $Author=&SplitedAuthorsMark($AuthorString, $Author, $au, $aus, $auf);
	  $Authors="$Authors".", $Author";

    	}

    	$Authors=~s/^\,//g;
    	$Authors=~s/^ //g;
    	$Authors=~s/<$aus> /<$aus>/g;
    	$Authors=~s/<$auf> /<$auf>/g;
    	$AuthorGroup="$Authors";
    }

    $AuthorGroup=~s/<\/$au>\, ([A-Z\.\- ]+) ([$AuthorString]+)\, <$au>/<\/$au>\, <$auf>$1<\/$auf> <$aus>$2<\/$aus>\, <$au>/gs;
    $AuthorGroup=~s/([\,]*) $regx{etal}<\/$au>/<\/$au>$1 $2/gs;
    $AuthorGroup=~s/([\, ]+)<\/au>/<\/au>$1/gs;
    $AuthorGroup=~s/<comma><\/$aus>/<\/$aus>\,/gs;
    $AuthorGroup=~s/<comma>/\,/gs;
    $AuthorGroup=~s/<$aus>$regx{firstName}<\/$aus> <$auf>([^<>]*?)<\/$auf>/<$auf>$1<\/$auf> <$aus>$2<\/$aus>/gs;
    $AuthorGroup=~s/<$au><$aus>& ([A-Za-z]+)/& <$au><$aus>$1/gs;
    $AuthorGroup=~s/<\/$auf><\/$au>, ([jJ]r[.]?)\,/<\/$auf>, <suffix>$1<\/suffix><\/$au>\,/gs;



    #$AuthorGroup=&VancoverAuthorStyle(\$AuthorGroup, $au, $aus, $auf, \$AuthorString);


    return $AuthorGroup;
}


#=========================================================================
sub authorstyle2
{
    my $AuthorGroup="";
    my $au="";
    $AuthorGroup=shift;
    $au=shift;
    my $aus=shift;
    my $auf=shift;
    my $AuthorString=shift;

    #print "Style2: $AuthorGroup\n";

    if($AuthorGroup=~/^([$AuthorString]+)\, ([^a-z][$AuthorString]+[A-Z‚Äì\.\- ]*)\, (.*?)\, ([$AuthorString]+[A-Z‚Äì\.\- ]*) ([$AuthorString ]+)[\,]? $regx{and}/)
      {
	if($AuthorGroup=~/^([$AuthorString]+ [A-Z\- ]+)\,/)
	  {
	    goto StyleNext;
	  }
	$AuthorGroup=&authorstyle5($AuthorGroup, $au, $aus, $auf, $AuthorString);

      }
    elsif($AuthorGroup=~/^([$AuthorString]+)\, ([^a-z][$AuthorString]+[A-Z‚Äì\.\- ]*)\, ([$AuthorString]+[A-Z‚Äì\.\- ]*) ([$AuthorString ]+)[\,]? $regx{and}/)
      {
	if($AuthorGroup=~/^([$AuthorString]+ [A-Z\- ]+)\,/)
	  {
	    goto StyleNext;
	  }
	$AuthorGroup=&authorstyle5($AuthorGroup, $au, $aus, $auf, $AuthorString);
      }
    elsif($AuthorGroup=~/^([$AuthorString]+ [$AuthorString]+)\, ([^a-z][$AuthorString]+[A-Z‚Äì\.\- ]*)[\,]? $regx{and} ([$AuthorString]+[A-Z‚Äì\.\- ]*) ([$AuthorString]+)/)
      {
	if($AuthorGroup=~/^([$AuthorString]+ [A-Z\- ]+)\,/)
	  {
	    goto StyleNext;
	  }
	$AuthorGroup=&authorstyle5($AuthorGroup, $au, $aus, $auf, $AuthorString);
      }


    StyleNext:


    $AuthorGroup=~s/^$regx{sAuthorString}([\,]?) $regx{firstName}([\,]*) (<i>et[\.]? al[\.]?<\/i>[\.]?)$/<$au><$aus>$1<\/$aus>$2 <$auf>$3<\/$auf>$4 $5<\/$au>/o;
    $AuthorGroup=~s/^$regx{sAuthorString} $regx{firstName} $regx{suffix}$/<$au><$aus>$1<\/$aus> <$auf>$2<\/$auf> <suffix>$3<\/suffix><\/$au>/g;
    $AuthorGroup=~s/^$regx{sAuthorString} $regx{suffix} $regx{firstName}$/<$au><$aus>$1<\/$aus> <par>$2<\/par> <suffix>$3<\/suffix><\/$au>/g;
    $AuthorGroup=~s/^$regx{sAuthorString}\, $regx{firstName} $regx{suffix}$/<$au><$aus>$1<\/$aus>\, <$auf>$2<\/$auf> <suffix>$3<\/suffix><\/$au>/g;
    $AuthorGroup=~s/^$regx{sAuthorString} $regx{firstName} $regx{particle}$/<$au><$aus>$1<\/$aus> <$auf>$2<\/$auf> <par>$3<\/par><\/$au>/g;
    $AuthorGroup=~s/^$regx{sAuthorString} $regx{particle} $regx{firstName}$/<$au><$aus>$1<\/$aus> <par>$2<\/par> <$auf>$3<\/$auf><\/$au>/g;
    $Author=~s/^$regx{firstName} $regx{particle} $regx{mAuthorString}$/<$au><$auf>$1<\/$auf> <par>$2<\/par> <$aus>$3<\/$aus><\/$au>/g;
    $AuthorGroup=~s/^$regx{sAuthorString}\, $regx{firstName} $regx{particle}$/<$au><$aus>$1<\/$aus>\, <$auf>$2<\/$auf> <par>$3<\/par><\/$au>/g;

    $AuthorGroup=~s/^$regx{particle} $regx{sAuthorString}\, $regx{mAuthorString}$/<$au><par>$1<\/par> <$aus>$2<\/$aus>\, <$auf>$3<\/$auf><\/$au>/o;

    $AuthorGroup=~s/^([$AuthorString]+[A-Z‚Äì\.\- ]*) $regx{sAuthorString}\, ([$AuthorString]+[A-Z‚Äì\.\- ]*) $regx{sAuthorString} $regx{and} ([$AuthorString]+[A-Z‚Äì\.\- ]*) $regx{mAuthorString}$/<$au><$auf>$1<\/$auf> <$aus>$2<\/$aus><\/$au>\, <$au><$auf>$3<\/$auf> <$aus>$4<\/$aus><\/$au> $5 <$au><$auf>$6<\/$auf> <$aus>$7<\/$aus><\/$au>/o;
   $AuthorGroup=~s/^([$AuthorString]+[A-Z‚Äì\.\- ]*) $regx{sAuthorString} $regx{and} ([$AuthorString]+[A-Z‚Äì\.\- ]*) $regx{mAuthorString}$/<$au><$auf>$1<\/$auf> <$aus>$2<\/$aus><\/$au> $3 <$au><$auf>$4<\/$auf> <$aus>$5<\/$aus><\/$au>/o;

   # , Johnson FH, Jr and Hiller FC
    $AuthorGroup=~s/(^|[\,\;] |\/)$regx{sAuthorString} $regx{firstName}([\,]?) $regx{suffix} $regx{and} $regx{mAuthorString} $regx{firstName}$/$1<$au><$aus>$2<\/$aus> <$auf>$3<\/$auf>$4 <suffix>$5<\/suffix><\/$au> $6 <$au><$aus>$7<\/$aus> <$auf>$8<\/$auf><\/$au>/o;
    #, JC Lanier and DJ Guidry
    $AuthorGroup=~s/(^|[\,\;] |\/)$regx{firstName} $regx{mAuthorString}([\,]?) $regx{and} $regx{firstName} $regx{mAuthorString}$/$1<$au><$auf>$2<\/$auf> <$aus>$3<\/$aus><\/$au>$4 $5 <$au><$auf>$6<\/$auf> <$aus>$7<\/$aus><\/$au>/o;
    $AuthorGroup=~s/(^|[\,\;] |\/)$regx{sAuthorString}\, $regx{firstName}([\,]?) $regx{and} $regx{firstName} $regx{mAuthorString}$/$1<$au><$aus>$2<\/$aus>\, <$auf>$3<\/$auf><\/$au>$4 $5 <$au><$auf>$6<\/$auf> <$aus>$7<\/$aus><\/$au>/o;
    $AuthorGroup=~s/(^|[\,\;] |\/)$regx{sAuthorString} $regx{firstName}([\,]?) $regx{and} $regx{firstName} $regx{mAuthorString}$/$1<$au><$aus>$2<\/$aus> <$auf>$3<\/$auf><\/$au>$4 $5 <$au><$auf>$6<\/$auf> <$aus>$7<\/$aus><\/$au>/o;


    #\, Clark B.,¬ÖZotz K
     $AuthorGroup=~s/\, $regx{mAuthorString} $regx{firstName}([\,]?[ ]?¬Ö[ ]?|[\,]?[ ]?‚Ä¶[ ]?|[\,]?[ ]?\.\.\.[ ]?|[\,]?[ ]?[¬Ö¶]+[ ]?)$regx{mAuthorString} $regx{firstName}$/\, <$au><$aus>$1<\/$aus> <$auf>$2<\/$auf><\/$au>$3<$au><$aus>$4<\/$aus> <$auf>$5<\/$auf><\/$au>/gs;

    #, Hills A et al.
    $AuthorGroup=~s/\, $regx{mAuthorString}([\,]?) $regx{firstName}([\,]?) (et[\.]? al[\.]?)$/\, <$au><$aus>$1<\/$aus>$2 <$auf>$3<\/$auf>$4 $5<\/$au>/o;

    $AuthorGroup=~s/^$regx{mAuthorString} $regx{firstName} $regx{mAuthorString} $regx{firstName}$/<$au><$aus>$1<\/$aus> <$auf>$2<\/$auf><\/$au> <$au><$aus>$3<\/$aus> <$auf>$4<\/$auf><\/$au>/gs;

    $AuthorGroup=~s/([\s]*)([$AuthorString ]+ [$AuthorString ]+) $regx{firstName}([\,]?) $regx{and} $regx{mAuthorString} $regx{firstName}$/$1<$au><$aus>$2<\/$aus> <$auf>$3<\/$auf><\/$au>$4 $5 <$au><$aus>$6<\/$aus> <$auf>$7<\/$auf><\/$au>/o;

    $AuthorGroup=~s/([\s]*)$regx{sAuthorString} $regx{firstName}([\,]?) $regx{and} $regx{mAuthorString} $regx{firstName}$/$1<$au><$aus>$2<\/$aus> <$auf>$3<\/$auf><\/$au>$4 $5 <$au><$aus>$6<\/$aus> <$auf>$7<\/$auf><\/$au>/o;

    $AuthorGroup=~s/([\s]*)$regx{sAuthorString} $regx{firstName}([\,]?) $regx{and} $regx{sAuthorString}([\,]?) $regx{firstName}$/$1<$au><$aus>$2<\/$aus> <$auf>$3<\/$auf><\/$au>$4 $5 <$au><$aus>$6<\/$aus>$7 <$auf>$8<\/$auf><\/$au>/o;

    $AuthorGroup=~s/([\s]*)$regx{sAuthorString}\, $regx{firstName}([\,]?) $regx{and} $regx{sAuthorString}([\,]?) $regx{firstName}$/$1<$au><$aus>$2<\/$aus>, <$auf>$3<\/$auf><\/$au>$4 $5 <$au><$aus>$6<\/$aus>$7 <$auf>$8<\/$auf><\/$au>/o;

    $AuthorGroup=~s/^$regx{sAuthorString} $regx{firstName} $regx{sAuthorString}([\,]?) $regx{firstName}$/<$au><$aus>$1<\/$aus> <$auf>$2<\/$auf><\/$au> <$au><$aus>$3<\/$aus>$4 <$auf>$5<\/$auf><\/$au>/o;
    $AuthorGroup=~s/^$regx{sAuthorString} ([A-Z‚Äì\.\- ]+) $regx{sAuthorString} ([A-Z‚Äì\.\- ]+) $regx{sAuthorString}([\,]?) ([A-Z‚Äì\.\- ]+)$/<$au><$aus>$1<\/$aus> <$auf>$2<\/$auf><\/$au> <$au><$aus>$3<\/$aus> <$auf>$4<\/$auf><\/$au> <$au><$aus>$5<\/$aus>$6 <$auf>$7<\/$auf><\/$au>/o;

    $AuthorGroup=~s/^$regx{sAuthorString} $regx{firstName}\. $regx{sAuthorString} $regx{firstName}\.$/<$au><$aus>$1<\/$aus> <$auf>$2\.<\/$auf><\/$au> <$au><$aus>$3<\/$aus> <$auf>$4\.<\/$auf><\/$au>/gs;

    $AuthorGroup=~s/^([$AuthorString]+ [A-Z‚Äì\.\- ]*) $regx{sAuthorString}$/<$au><$auf>$1<\/$auf> <$aus>$2<\/$aus><\/$au>/o;


    $AuthorGroup=~s/^$regx{sAuthorString}([\,]?) ([A-Zvd\-\. ]+)$/<$au><$aus>$1<\/$aus>$2 <$auf>$3<\/$auf><\/$au>/gs;
    $AuthorGroup=~s/^([$AuthorString ]+ [$AuthorString ]+)([\,]?) ([A-Zvd\-\. ]+)$/<$au><$aus>$1<\/$aus>$2 <$auf>$3<\/$auf><\/$au>/gs;

    $AuthorGroup=~s/^([A-Z\.\- ]+) $regx{sAuthorString}$/<$au><$auf>$1<\/$auf> <$aus>$2<\/$aus><\/$au>/gs;
    $AuthorGroup=~s/^([A-Z\.\- ]+) ([$AuthorString ]+ [$AuthorString ]+)$/<$au><$auf>$1<\/$auf> <$aus>$2<\/$aus><\/$au>/gs;

    $AuthorGroup=~s/^$regx{sAuthorString} $regx{sAuthorString} $regx{firstName}$/<$au><$aus>$1 $2<\/$aus> <$auf>$3<\/$auf><\/$au>/o;
    $AuthorGroup=~s/^$regx{sAuthorString}([\,]?) $regx{firstName}([\,]*) $regx{etal}$/<$au><$aus>$1<\/$aus>$2 <$auf>$3<\/$auf>$4 $5<\/$au>/o;

    $AuthorGroup=~s/^([$AuthorString ]+ [$AuthorString ]+)([\,]?) $regx{firstName}([\,]*) $regx{etal}$/<$au><$aus>$1<\/$aus>$2 <$auf>$3<\/$auf>$4 $5<\/$au>/o;

    $AuthorGroup=~s/([\s]*)$regx{sAuthorString}([\,]?) $regx{firstName}([\,]*) $regx{etal}$/$1<$au><$aus>$2<\/$aus>$3 <$auf>$4<\/$auf>$5 $6<\/$au>/o;

    $AuthorGroup=~s/([\s]*)([$AuthorString ]+ [$AuthorString ]+)([\,]?) $regx{firstName}([\,]*) $regx{etal}$/$1<$au><$aus>$2<\/$aus>$3 <$auf>$4<\/$auf>$5 $6<\/$au>/o;
    $AuthorGroup=~s/([\,\;\/]) $regx{sAuthorString} $regx{firstName}$/$1 <$au><$aus>$2<\/$aus> <$auf>$3<\/$auf><\/$au>/o;
    $AuthorGroup=~s/([\,\;\/]) $regx{mAuthorString} $regx{firstName}$/$1 <$au><$aus>$2<\/$aus> <$auf>$3<\/$auf><\/$au>/o;

    $AuthorGroup=~s/^$regx{sAuthorString} $regx{sAuthorString} $regx{and} $regx{sAuthorString} $regx{sAuthorString} $regx{firstName}$/<$au><$aus>$1<\/$aus> <$auf>$2<\/$auf> $3 <$aus>$4<\/$aus> <$auf>$5 $6<\/$auf><\/$au>/gs;

    $AuthorGroup=~s/\, $regx{firstName}\. $regx{mAuthorString} $regx{firstName}([\.]?) $regx{mAuthorString}$/\, <$au><$auf>$1<\/$auf>\. <$aus>$2<\/$aus><\/$au> <$au><$auf>$3<\/$auf>$4 <$aus>$5<\/$aus><\/$au>/o;

    $AuthorGroup=~s/ ([A-Z \.\-]+) <edr><eds>([A-Z \.\-]+)\; ([^<>]+?)<\/eds>/ $1 $2\; <edr><eds>$3<\/eds>/gs;

    #Rhodes OEJ, and Michael H. Smith
    $AuthorGroup=~s/([\,\;\/ ]+|>|^)$regx{mAuthorFullSirName}([\,]?) $regx{firstName}([\,]?) $regx{and} $regx{mAuthorFullFirstName} $regx{firstName} $regx{mAuthorFullSirName}$/$1<$au><$aus>$2<\/$aus>$3 <$auf>$4<\/$auf><\/$au>$5 $6 <$au><$auf>$7 $8<\/$auf> <$aus>$9<\/$aus><\/$au>/s;


    {}while($AuthorGroup=~s/(^|[\,\;] )$regx{mAuthorString} $regx{firstName} $regx{particle}\, <$au>/$1<$au><$aus>$2<\/$aus> <$auf>$3<\/$auf> <par>$4<\/par><\/$au>\, <$au>/gs);


    #<au><aus>Garc√≠a Ayala A Garc√≠a Hern√°ndez MP Quesada</aus> <auf>JA</auf></au> <au><aus>Agulleiro</aus> <auf>B</auf></au>
    if($AuthorGroup=~/<$au><$aus>$regx{mAuthorString} $regx{firstName} $regx{mAuthorString}<\/$aus> <$auf>$regx{firstName}<\/$auf><\/$au> <$au><$aus>$regx{mAuthorString}<\/$aus> <$auf>$regx{firstName}<\/$auf><\/$au>/)
	{
	  $AuthorGroup=~s/<$au><$aus>$regx{mAuthorString} $regx{firstName} $regx{mAuthorString}<\/$aus> <$auf>$regx{firstName}<\/$auf><\/$au> <$au><$aus>$regx{mAuthorString}<\/$aus> <$auf>$regx{firstName}<\/$auf><\/$au>/$1 $2 $3 $4 $5 $6/gs;
	  my $seperater=" ";
	  {}while($AuthorGroup=~s/$regx{mAuthorString} $regx{firstName} $regx{mAuthorString} $regx{firstName}/$1 $2<AU> $3 $4/g);
	  $AuthorGroup=~s/\, $regx{mAuthorFullSirName}\, $regx{firstName}\, $regx{mAuthorFullSirName}\, $regx{firstName}/<AU> $1\, $2<AU> $3\, $4/gs;

	  my @Authors=split(/<AU>/, $AuthorGroup);
	  my $Authors="";
	  foreach my $Author(@Authors)
	    {
	      $Author=&SplitedAuthorsMark($AuthorString, $Author, $au, $aus, $auf);
	      $Authors="$Authors"."${seperater}${Author}";
	    }
	  $Authors=~s/^ //g;
	  $Authors=~s/^(\,|\/|\;)//g;
	  $Authors=~s/^ //g;
	  $Authors=~s/<$aus> /<$aus>/g;
	  $Authors=~s/<$auf> /<$auf>/g;
	  $AuthorGroup="$Authors";
	}

    if($AuthorGroup=~/<$au><$aus>$regx{mAuthorString}<\/$aus> <$auf>$regx{firstName}<\/$auf><\/$au> <$au><$aus>$regx{mAuthorString} $regx{firstName} $regx{mAuthorString}<\/$aus> <$auf>$regx{firstName}<\/$auf><\/$au>/)
      {
	$AuthorGroup=~s/<$au><$aus>$regx{mAuthorString}<\/$aus> <$auf>$regx{firstName}<\/$auf><\/$au> <$au><$aus>$regx{mAuthorString} $regx{firstName} $regx{mAuthorString}<\/$aus> <$auf>$regx{firstName}<\/$auf><\/$au>/$1 $2 $3 $4 $5 $6/gs;
	my $seperater=" ";
	{}while($AuthorGroup=~s/$regx{mAuthorString} $regx{firstName} $regx{mAuthorString} $regx{firstName}/$1 $2<AU> $3 $4/g);
	$AuthorGroup=~s/\, $regx{mAuthorFullSirName}\, $regx{firstName}\, $regx{mAuthorFullSirName}\, $regx{firstName}/<AU> $1\, $2<AU> $3\, $4/gs;

	my @Authors=split(/<AU>/, $AuthorGroup);
	my $Authors="";
	foreach my $Author(@Authors)
	  {
	    $Author=&SplitedAuthorsMark($AuthorString, $Author, $au, $aus, $auf);
	    $Authors="$Authors"."${seperater}${Author}";
	  }
	$Authors=~s/^ //g;
	$Authors=~s/^(\,|\/|\;)//g;
	$Authors=~s/^ //g;
	$Authors=~s/<$aus> /<$aus>/g;
	$Authors=~s/<$auf> /<$auf>/g;
	$AuthorGroup="$Authors";
      }

    if($AuthorGroup=~/$regx{mAuthorString} $regx{firstName}\, <$au>(.*)<\/$au>/)
    {
	my $TempAuthorGroup="<$au>$3<\/$au>";
	$AuthorGroup=~s/$regx{mAuthorString} $regx{firstName}\, <$au>(.*)<\/$au>/$1 $2/s;
    	$AuthorGroup=~s/$regx{sAuthorString} $regx{firstName}\. $regx{sAuthorString} $regx{firstName}\, /$1 $2\.<AU>$3 $4<AU>/g;
	$AuthorGroup=~s/$regx{sAuthorString} $regx{firstName}\. $regx{sAuthorString} $regx{firstName}$/$1 $2\.<AU>$3 $4/g;
	$AuthorGroup=~s/\, $regx{mAuthorFullSirName}\, $regx{firstName}\, $regx{mAuthorFullSirName}\, $regx{firstName}/<AU> $1\, $2<AU> $3\, $4/gs;
	$AuthorGroup=~s/$regx{mAuthorFullSirName}\, $regx{firstName}\, $regx{mAuthorFullSirName}\, $regx{firstName}/$1\, $2<AU> $3\, $4/gs;
	$AuthorGroup=~s/(\, |^)$regx{sAuthorString}\, $regx{firstName}\, $regx{sAuthorString} $regx{firstName}\, /$1$2<comma> $3\, $4 $5\, /gs;
	$AuthorGroup=~s/\, /<AU>/g;

	my @Authors=split(/<AU>/, $AuthorGroup);
	my $Authors="";
	foreach my $Author(@Authors)
	{
	  $Author=&SplitedAuthorsMark($AuthorString, $Author, $au, $aus, $auf);
	  $Authors="$Authors".", $Author";
	}

	$Authors=~s/^\,//g;
	$Authors=~s/^ //g;
	$Authors=~s/<$aus> /<$aus>/g;
	$Authors=~s/<$auf> /<$auf>/g;
	$AuthorGroup="$Authors"."\, $TempAuthorGroup";

      }elsif($AuthorGroup=~/$regx{sAuthorString}([\,]?) $regx{firstName}([ ]?[\/\;][ ]?)<$au>(.*)<\/$au>/)
	{
	  my $TempAuthorGroup="<$au>$5<\/$au>";
	  my $seperater="$4";
	  $AuthorGroup=~s/$regx{sAuthorString}([\,]?) $regx{firstName}([ ]?[\/\;][ ]?)<$au>(.*)<\/$au>/$1$2 $3/s;
	  $AuthorGroup=~s/\, $regx{mAuthorFullSirName}\, $regx{firstName}\, $regx{mAuthorFullSirName}\, $regx{firstName}/<AU> $1\, $2<AU> $3\, $4/gs;
	  {}while($AuthorGroup=~s/$regx{mAuthorFullSirName}\, $regx{firstName}\, $regx{mAuthorFullSirName}\, $regx{firstName}/$1\, $2<AU> $3\, $4/gs);
	  $AuthorGroup=~s/\,/<AU>/g;

	  $AuthorGroup=~s/\;/<AU>/g;
	  if($AuthorGroup=~/[^><]\//){
	    $AuthorGroup=~s/([^><])\//$1<AU>/g;
	  }

	  my @Authors=split(/<AU>/, $AuthorGroup);
	  my $Authors="";
	  foreach my $Author(@Authors)
	    {
	      $Author=&SplitedAuthorsMark($AuthorString, $Author, $au, $aus, $auf);
	      $Authors="$Authors"."${seperater}${Author}";
	    }
	  $Authors=~s/^ //g;
	  $Authors=~s/^(\,|\/|\;)//g;
	  $Authors=~s/^ //g;
	  $Authors=~s/<$aus> /<$aus>/g;
	  $Authors=~s/<$auf> /<$auf>/g;
	  $AuthorGroup="$Authors"."$seperater$TempAuthorGroup";
	}elsif($AuthorGroup=~/$regx{sAuthorString}([\,]?) $regx{firstName}([ ]?[\/\;])/)
	{
	  my $seperater="$4";
	  $AuthorGroup=~s/\;/<AU>/g;
	  $AuthorGroup=~s/\,/<AU>/g;
	  if($AuthorGroup=~/[^><]\//){
	    $AuthorGroup=~s/([^><])\//$1<AU>/g;
	  }

	  $AuthorGroup=~s/\, $regx{mAuthorFullSirName}\, $regx{firstName}\, $regx{mAuthorFullSirName}\, $regx{firstName}/<AU> $1\, $2<AU> $3\, $4/gs;
	  $AuthorGroup=~s/([\,\;]) <au>/<AU> <$au>/gs;

	  # $AuthorGroup=~s/[\/\;]/<AU>/g;
	  my @Authors=split(/<AU>/, $AuthorGroup);
	  my $Authors="";
	  foreach my $Author(@Authors)
	    {
	      $Author=&SplitedAuthorsMark($AuthorString, $Author, $au, $aus, $auf);
	      $Authors="$Authors"."${seperater}${Author}";
	     }
	  $Authors=~s/^ //g;
	  $Authors=~s/^(\,|\/|\;)//g;
	  $Authors=~s/^ //g;
	  $Authors=~s/<$aus> /<$aus>/g;
	  $Authors=~s/<$auf> /<$auf>/g;
	  $AuthorGroup="$Authors";
	}elsif($AuthorGroup=~/$regx{mAuthorString} $regx{firstName}\,/)
	  {
    	$AuthorGroup=~s/$regx{sAuthorString}\, $regx{firstName}\, /$1<comma> $2<AU>/g;
    	$AuthorGroup=~s/$regx{sAuthorString}\, $regx{firstName}$/$1<comma> $2/g;
    	$AuthorGroup=~s/$regx{sAuthorString} $regx{firstName}\. $regx{sAuthorString} $regx{firstName}\, /$1 $2\.<AU>$3 $4<AU>/g;
	$AuthorGroup=~s/$regx{sAuthorString} $regx{firstName}\. $regx{sAuthorString} $regx{firstName}$/$1 $2\.<AU>$3 $4/g;
	$AuthorGroup=~s/\, $regx{mAuthorFullSirName}\, $regx{firstName}\, $regx{mAuthorFullSirName}\, $regx{firstName}/<AU> $1\, $2<AU> $3\, $4/gs;

	$AuthorGroup=~s/(\, |^)$regx{sAuthorString}\, $regx{firstName}\, $regx{sAuthorString} $regx{firstName}\, /$1$2<comma> $3\, $4 $5\, /gs;
	$AuthorGroup=~s/\, /<AU>/g;

	my @Authors=split(/<AU>/, $AuthorGroup);
	my $Authors="";
	foreach my $Author(@Authors)
	{
	  $Author=&SplitedAuthorsMark($AuthorString, $Author, $au, $aus, $auf);
	  $Authors="$Authors".", $Author";
	}
	$Authors=~s/^\,//g;
	$Authors=~s/^ //g;
	$Authors=~s/<$aus> /<$aus>/g;
	$Authors=~s/<$auf> /<$auf>/g;
	$AuthorGroup="$Authors";

    }elsif($AuthorGroup=~/$regx{mAuthorString} ([A-Z‚Äì\.\- ]+[a-z]?)\,/)
    {
    	$AuthorGroup=~s/$regx{sAuthorString}\, $regx{firstName}\, /$1<comma> $2<AU>/g;
    	$AuthorGroup=~s/$regx{sAuthorString}\, $regx{firstName}$/$1<comma> $2/g;
    	$AuthorGroup=~s/$regx{sAuthorString} $regx{firstName}\. $regx{sAuthorString} $regx{firstName}\, /$1 $2\.<AU>$3 $4<AU>/g;
	$AuthorGroup=~s/$regx{sAuthorString} $regx{firstName}\. $regx{sAuthorString} $regx{firstName}$/$1 $2\.<AU>$3 $4/g;
	$AuthorGroup=~s/\, /<AU>/g;

	my @Authors=split(/<AU>/, $AuthorGroup);
	my $Authors="";
	foreach my $Author(@Authors)
	{
	  $Author=&SplitedAuthorsMark($AuthorString, $Author, $au, $aus, $auf);
	  $Authors="$Authors".", $Author";
	}
	$Authors=~s/^\,//g;
	$Authors=~s/^ //g;
	$Authors=~s/<$aus> /<$aus>/g;
	$Authors=~s/<$auf> /<$auf>/g;
	$AuthorGroup="$Authors";
      }elsif($AuthorGroup=~/$regx{sAuthorString} $regx{firstName}\. $regx{sAuthorString} $regx{firstName}\./)
	{
	  my $seperater=" ";
	  $AuthorGroup=~s/\. /\.<AU>/g;
	  my @Authors=split(/<AU>/, $AuthorGroup);
	  my $Authors="";
	foreach my $Author(@Authors){
			$Author=&SplitedAuthorsMark($AuthorString, $Author, $au, $aus, $auf);
			$Authors="$Authors"."${seperater}${Author}";
		}
		$Authors=~s/^ //g;
		$Authors=~s/^(\,|\/|\;)//g;
		$Authors=~s/^ //g;
		$Authors=~s/<$aus> /<$aus>/g;
		$Authors=~s/<$auf> /<$auf>/g;
		$AuthorGroup="$Authors";
	}elsif($AuthorGroup=~/$regx{sAuthorString} $regx{firstName}/){
		my $seperater=" ";
		$AuthorGroup=~s/(.*)/$1<AU>/g;
		my @Authors=split(/<AU>/, $AuthorGroup);
		my $Authors="";
	  foreach my $Author(@Authors)
	    {
	      $Author=&SplitedAuthorsMark($AuthorString, $Author, $au, $aus, $auf);
	      $Authors="$Authors"."${seperater}${Author}";
	    }
	  $Authors=~s/^ //g;
	  $Authors=~s/^(\,|\/|\;)//g;
	  $Authors=~s/^ //g;
	  $Authors=~s/<$aus> /<$aus>/g;
	  $Authors=~s/<$auf> /<$auf>/g;
	  $AuthorGroup="$Authors";
	} 


    $AuthorGroup=~s/<\/$auf>([\.\,]?) $regx{etal}<\/$au>/<\/$auf><\/$au>$1 $2/gs;
    $AuthorGroup=~s/<$au><$auf>$regx{mAuthorString} ([A-Z\-]+)<\/$auf> <$aus>([A-Z\-]+)<\/$aus><\/$au>/<$au><$auf>$1<\/$auf> <$aus>$2 $3<\/$aus><\/$au>/gs;
    $AuthorGroup=~s/<$au><$auf>$regx{mAuthorString} ([A-Z\- ]+)<\/$auf> <$aus>$regx{suffix}<\/$aus><\/$au>/<$au><$aus>$1<\/$aus> <$auf>$2<\/$auf> <suffix>$3<\/suffix><\/$au>/gs;
    return $AuthorGroup;
  }

#=====================================================================================================================================
sub authorstyle3
{
    my $AuthorGroup="";
    my $au="";
    $AuthorGroup=shift;
    $au=shift;
    my $aus=shift;
    my $auf=shift;
    my $AuthorString=shift;

    #print "Style3: $AuthorGroup\n";

    $AuthorGroup=~s/(^|\, )$regx{mAuthorString}\, $regx{firstName}\, $regx{suffix}([\,]?) $regx{and} $regx{mAuthorString}\, $regx{firstName}$/$1<$au><$aus>$2<\/$aus>\, <$auf>$3<\/$auf>, <suffix>$4<\/suffix><\/$au>$5 $6 <$au><$aus>$7<\/$aus>\, <$auf>$8<\/$auf><\/$au>/gs;
    $AuthorGroup=~s/^$regx{mAuthorString}\, $regx{firstName}\, $regx{firstName}\, $regx{mAuthorString}\, $regx{firstName}/<$au><$aus>$1<\/$aus>\, <$auf>$2<\/$auf><\/$au>\, $3\, $4\, $5/gs;

    $AuthorGroup=~s/^$regx{sAuthorString} $regx{sAuthorString} $regx{firstName}$/<$au><$aus>$1 $2<\/$aus> <$auf>$3<\/$auf><\/$au>/s;
    $AuthorGroup=~s/^$regx{firstName} $regx{sAuthorString}$/<$au><$auf>$1<\/$auf> <$aus>$2<\/$aus><\/$au>/s;
    $AuthorGroup=~s/^$regx{firstName} ([$AuthorString ]+ [$AuthorString ]+)$/<$au><$auf>$1<\/$auf> <$aus>$2<\/$aus><\/$au>/s;
    $AuthorGroup=~s/^$regx{firstName} $regx{mAuthorString} $regx{suffix}([\,]) $regx{firstName} $regx{mAuthorString}$/<$au><$auf>$1<\/$auf> <$aus>$2<\/$aus> <suffix>$3<\/suffix><\/$au>$4 <$au><$auf>$5<\/$auf> <$aus>$6<\/$aus><\/$au>/s;
 

    $AuthorGroup=~s/^$regx{firstName}\. $regx{mAuthorString} $regx{and} $regx{firstName}([\.]?) $regx{mAuthorString}([\,]?) $regx{and} $regx{firstName}([\,]?) $regx{mAuthorString}$/<$au><$auf>$1<\/$auf>\. <$aus>$2<\/$aus><\/$au> $3 <$au><$auf>$4<\/$auf>$5 <$aus>$6<\/$aus><\/$au>$7 $8 <$au><$auf>$9<\/$auf>$10 <$aus>$11<\/$aus><\/$au>/o;


    $AuthorGroup=~s/^$regx{firstName}\. $regx{mAuthorString} $regx{firstName}([\.]?) $regx{mAuthorString}([\,]?) $regx{and} $regx{firstName}([\,]?) $regx{mAuthorString}$/<$au><$auf>$1\.<\/$auf> <$aus>$2<\/$aus><\/$au> <$au><$auf>$3<\/$auf>$4 <$aus>$5<\/$aus><\/$au>$6 $7 <$au><$auf>$8<\/$auf>$9 <$aus>$10<\/$aus><\/$au>/o;
    $AuthorGroup=~s/\, $regx{firstName}\. $regx{mAuthorString} $regx{firstName}([\.]?) $regx{mAuthorString}([\,]?) $regx{and} $regx{firstName}([\,]?) $regx{mAuthorString}$/\, <$au><$auf>$1\.<\/$auf> <$aus>$2<\/$aus><\/$au> <$au><$auf>$3<\/$auf>$4 <$aus>$5<\/$aus><\/$au>$6 $7 <$au><$auf>$8<\/$auf>$9 <$aus>$10<\/$aus><\/$au>/o;

    $AuthorGroup=~s/$regx{firstName}([\,]?) $regx{particle} $regx{mAuthorString}([\,]?) $regx{and} $regx{firstName}([\,]?) $regx{mAuthorString}$/<$au><$auf>$1<\/$auf>$2 <par>$3<\/par> <$aus>$4<\/$aus><\/$au>$5 $6 <$au><$auf>$7<\/$auf>$8 <$aus>$9<\/$aus><\/$au>/s;
    $AuthorGroup=~s/$regx{firstName}([\,]?) $regx{particle} $regx{mAuthorString}([\,]?) $regx{and} $regx{mAuthorString}([\,]?) $regx{firstName}$/<$au><$auf>$1<\/$auf>$2 <par>$3<\/par> <$aus>$4<\/$aus><\/$au>$5 $6 <$au><$aus>$7<\/$aus>$8 <$auf>$9<\/$auf><\/$au>/s;


    $AuthorGroup=~s/([\,\;\/ ]+|>|^)$regx{firstName}([\,]?) $regx{mAuthorString}([\,]?) $regx{and} $regx{firstName}([\,]?) $regx{mAuthorString}([\,]?) $regx{suffix}$/$1<$au><$auf>$2<\/$auf>$3 <$aus>$4<\/$aus><\/$au>$5 $6 <$au><$auf>$7<\/$auf>$8 <$aus>$9<\/$aus>$10 <suffix>$11<\/suffix><\/$au>/s;

    $AuthorGroup=~s/([\,\;\/ ]+|>|^)([A-Z‚Äì\.\- ]+[\.]?) $regx{sAuthorString}([\,]?) $regx{and} $regx{firstName} $regx{mAuthorString}([\.\,]?)$/$1<$au><$auf>$2<\/$auf> <$aus>$3<\/$aus><\/$au>$4 $5 <$au><$auf>$6<\/$auf> <$aus>$7<\/$aus><\/$au>$8/s;

    $AuthorGroup=~s/([\,\;\/ ]+|>|^)([A-Z‚Äì\.\- ]+[\.]?) $regx{sAuthorString} $regx{suffix}([\,]?) $regx{and} $regx{firstName} $regx{mAuthorString} $regx{suffix}([\.\,]?)$/$1<$au><$auf>$2<\/$auf> <$aus>$3<\/$aus> <suffix>$4<\/suffix><\/$au>$5 $6 <$au><$auf>$7<\/$auf> <$aus>$8<\/$aus> <suffix>$9<\/suffix><\/$au>$10/s;
    $AuthorGroup=~s/([\,\;\/ ]+|>)([A-Z‚Äì\.\- ]+[\.]?) $regx{sAuthorString} $regx{suffix}([\,]?) $regx{and} $regx{firstName} $regx{mAuthorString}([\.\,]?)$/$1<$au><$auf>$2<\/$auf> <$aus>$3<\/$aus> <suffix>$4<\/suffix><\/$au>$5 $6 <$au><$auf>$7<\/$auf> <$aus>$8<\/$aus><\/$au>$9/s;
    $AuthorGroup=~s/([\,\;\/ ]+|>|^)([A-Z‚Äì\.\- ]+[\.]?) $regx{sAuthorString}([\,]?) $regx{and} $regx{firstName} $regx{mAuthorString} $regx{suffix}([\.\,]?)$/$1<$au><$auf>$2<\/$auf> <$aus>$3<\/$aus><\/$au>$4 $5 <$au><$auf>$6<\/$auf> <$aus>$7<\/$aus> <suffix>$8<\/suffix><\/$au>$9/s;


    #, Y., Guo, & Q., Yang
    $AuthorGroup=~s/([\,\;\/ ]+|>|^)$regx{firstName}\, $regx{sAuthorString}([\,]?) $regx{and} $regx{firstName}\, $regx{mAuthorString}$/$1<$au><$auf>$2<\/$auf>\, <$aus>$3<\/$aus><\/$au>$4 $5 <$au><$auf>$6<\/$auf>\, <$aus>$7<\/$aus><\/$au>/s;

    $AuthorGroup=~s/\,<au><auf> /\, <au><auf>/gs;
    #   H. L. Roediger III & F. I. M. Craik
    $AuthorGroup=~s/^([A-Z‚Äì\.\- ]+[\.]?) $regx{sAuthorString} $regx{suffix}([\,]?) $regx{and} $regx{firstName} $regx{mAuthorString}$/$1<$au><$auf>$2<\/$auf> <$aus>$3<\/$aus> <suffix>$4<\/suffix><\/$au>$5 $6 <$au><$auf>$7<\/$auf> <$aus>$8<\/$aus><\/$au>/s;
    $AuthorGroup=~s/([\,\;\/ ]+|>|^)([A-Z‚Äì\.\- ]+[\.]?) ([$AuthorString ]+ [$AuthorString ]+)([\,]?) $regx{and} $regx{firstName} $regx{mAuthorString}([\.\,]?)$/$1<$au><$auf>$2<\/$auf> <$aus>$3<\/$aus><\/$au>$4 $5 <$au><$auf>$6<\/$auf> <$aus>$7<\/$aus><\/$au>$8/s;


    $AuthorGroup=~s/([\,\;\/ ]+|>|^)([A-Z‚Äì\.\- ]+[\.]?) $regx{mAuthorString} $regx{sAuthorString}([\,]?) $regx{and} $regx{mAuthorString} $regx{firstName} $regx{mAuthorString}([\.\,]?)$/$1<$au><$auf>$2 $3<\/$auf> <$aus>$4<\/$aus><\/$au>$5 $6 <$au><$auf>$7 $8<\/$auf> <$aus>$9<\/$aus><\/$au>$10/o;

    $AuthorGroup=~s/([\,\;\/ ]+|>|^)([A-Z‚Äì\.\- ]+[ a-z]?[\.]?) $regx{sAuthorString}([\,]?) $regx{and} $regx{firstName} $regx{mAuthorString}([\.\,]?)$/$1<$au><$auf>$2<\/$auf> <$aus>$3<\/$aus><\/$au>$4 $5 <$au><$auf>$6<\/$auf> <$aus>$7<\/$aus><\/$au>$8/o;
    $AuthorGroup=~s/([\,\;\/ ]+|>|^)([A-Z‚Äì\.\- ]+[ a-z]?[\.]?) ([$AuthorString ]+ [$AuthorString ]+)([\,]?) $regx{and} $regx{firstName} $regx{mAuthorString}([\.\,]?)$/$1<$au><$auf>$2<\/$auf> <$aus>$3<\/$aus><\/$au>$4 $5 <$au><$auf>$6<\/$auf> <$aus>$7<\/$aus><\/$au>$8/o;

    #Md. Durn, and Reguera, Md.       #E. Burdick and Brodbeck A.J.
    $AuthorGroup=~s/([\,\;\/ ]+|>|^)$regx{firstName} $regx{mAuthorString}([\,]?) $regx{and} $regx{mAuthorString}([\,]?) $regx{firstName}([\.\,]?)$/$1<$au><$auf>$2<\/$auf> <$aus>$3<\/$aus><\/$au>$4 $5 <$au><$aus>$6<\/$aus>$7 <$auf>$8<\/$auf><\/$au>$9/o;

    $AuthorGroup=~s/^$regx{firstName}([\,]?) $regx{sAuthorString}([\,]*) $regx{etal}$/<$au><$auf>$1<\/$auf>$2 <$aus>$3<\/$aus>$4 $5<\/$au>/o;
    $AuthorGroup=~s/^$regx{firstName}([\,]?) ([$AuthorString ]+ [$AuthorString ]+)([\,]*) $regx{etal}$/<$au><$auf>$1<\/$auf>$2 <$aus>$3<\/$aus>$4 $5<\/$au>/o;
    $AuthorGroup=~s/([\,\;\/ ]+|>|^)$regx{firstName}([\,]?) $regx{sAuthorString}([\,]*) $regx{etal}$/$1<$au><$auf>$2<\/$auf>$3 <$aus>$4<\/$aus>$5 $6<\/$au>/o;
    $AuthorGroup=~s/([\,\;\/ ]+|>|^)$regx{firstName}([\,]?) ([$AuthorString ]+ [$AuthorString ]+)([\,]*) $regx{etal}$/$1<$au><$auf>$2<\/$auf>$3 <$aus>$4<\/$aus>$5 $6<\/$au>/o;

    $AuthorGroup=~s/^$regx{sAuthorString}([\,]?) ([A-Zvd\-\. ]+)$/<$au><$aus>$1<\/$aus>$2 <$auf>$3<\/$auf><\/$au>/gs;
    $AuthorGroup=~s/^([$AuthorString ]+ [$AuthorString ]+)([\,]?) ([A-Zvd\-\. ]+)$/<$au><$aus>$1<\/$aus>$2 <$auf>$3<\/$auf><\/$au>/gs;

    $AuthorGroup=~s/^$regx{firstName} $regx{sAuthorString}\, $regx{firstName}$/<$au><$aus>$1 $2<\/$aus>\, <$auf>$3<\/$auf><\/$au>/o;
    $AuthorGroup=~s/\, $regx{firstName} $regx{sAuthorString}\, $regx{firstName}$/\, <$au><$aus>$1 $2<\/$aus>\, <$auf>$3<\/$auf><\/$au>/o;
    $AuthorGroup=~s/\,<edr><edm> /\, <edr><edm>/gs;
    $AuthorGroup=~s/\,<au><auf> /\, <au><auf>/gs;


    $AuthorGroup=~s/^$regx{firstName}\. $regx{mAuthorString} $regx{firstName}([\.]?) $regx{mAuthorString}$/<$au><$auf>$1<\/$auf>\. <$aus>$2<\/$aus><\/$au> <$au><$auf>$3<\/$auf>$4 <$aus>$5<\/$aus><\/$au>/o;
    $AuthorGroup=~s/\, $regx{firstName}\. $regx{mAuthorString} $regx{firstName}([\.]?) $regx{mAuthorString}$/\, <$au><$auf>$1<\/$auf>\. <$aus>$2<\/$aus><\/$au> <$au><$auf>$3<\/$auf>$4 <$aus>$5<\/$aus><\/$au>/o;


    #<au><aus>Feng</aus>, <auf>X. L.</auf></au>, J., Zhu, L., Zhang, L., Song, D., Hipgrave, S., Guo, C., Ronsmans, <au><auf>Y.</auf>, <aus>Guo</aus></au>, & <au><auf>Q.</auf>, <aus>Yang</aus></au>
    $AuthorGroup=~s/<$au>(.*?)<\/$au>([\,\;]) $regx{firstName}\, $regx{mAuthorString}([\,\;]) <$au>(.*?)<\/$au>/<$au>$1<\/$au>$2 <$au><$auf>$3<\/$auf>\, <$aus>$4<\/$aus><\/$au>$5 <$au>$6<\/$au>/gs;

    #F.K. Lester, Jr.
    $AuthorGroup=~s/^$regx{firstName} $regx{mAuthorString}\, $regx{suffix}$/<$au><$auf>$1<\/$auf> <$aus>$2<\/$aus>\, <suffix>$3<\/suffix><\/$au>/gs;
 
    #O. E. J. Rhodes, and Michael H. Smith
    $AuthorGroup=~s/([\,\;\/ ]+|>|^)$regx{firstName}([\,]?) $regx{mAuthorString}([\,]?) $regx{and} $regx{mAuthorFullFirstName}([\,]?) $regx{mAuthorFullSirName}$/$1<$au><$auf>$2<\/$auf>$3 <$aus>$4<\/$aus><\/$au>$5 $6 <$au><$auf>$7<\/$auf>$8 <$aus>$9<\/$aus><\/$au>/s;


    if($AuthorGroup=~/<$au>(.*)<\/$au>([\,\;]) $regx{firstName}\, $regx{mAuthorString}([\,\;]) ([^<>]+?)([\,\;]) <$au>(.*)<\/$au>([\.]?)/)
      {
      my $TempAuthorGroup1="<$au>$1<\/$au>$2";
      my $TempAuthorGroup2="<$au>$8<\/$au>$9";
      $AuthorGroup=~s/<$au>(.*)<\/$au>([\,\;]) $regx{firstName}\, $regx{mAuthorString}([\,\;]) ([^<>]+?)([\,\;]) <$au>(.*)<\/$au>([\.]?)/$3\, $4$5 $6/s;
      my $seperater=$7;
      $AuthorGroup=~s/$regx{firstName}\, $regx{mAuthorString}\, /$1<comma> $2<AU> /g;
      $AuthorGroup=~s/$regx{firstName}\, $regx{mAuthorString}$/$1<comma> $2/g;
      $AuthorGroup=~s/([\,\;])/<AU>/g;
      my @Authors=split(/<AU>/, $AuthorGroup);
      my $Authors="";
      foreach my $Author(@Authors)
	{
	  $Author=&SplitedAuthorsMark($AuthorString, $Author, $au, $aus, $auf);
	  $Authors="$Authors"."$seperater $Author";
	}
	$Authors=~s/^\,//g;
	$Authors=~s/^ //g;
	$Authors=~s/<$aus> /<$aus>/g;
	$Authors=~s/<$auf> /<$auf>/g;
	$AuthorGroup="$TempAuthorGroup1 "."$Authors"."$seperater $TempAuthorGroup2";
    }elsif($AuthorGroup=~/<$au>(.*)<\/$au>([\,\;]) $regx{firstName}\, $regx{mAuthorString}([\,\;])/)
      {
	my $TempAuthorGroup="<$au>$1<\/$au>$2";
	$AuthorGroup=~s/<$au>(.*)<\/$au>([\,\;]) $regx{firstName}\, $regx{mAuthorString}([\,\;])/$3\, $4$5/s;
	my $seperater=$5;
	$AuthorGroup=~s/$regx{firstName}\, $regx{mAuthorString}\, /$1<comma> $2<AU> /g;
	$AuthorGroup=~s/$regx{firstName}\, $regx{mAuthorString}$/$1<comma> $2/g;
	$AuthorGroup=~s/([\,\;])/<AU>/g;
	my @Authors=split(/<AU>/, $AuthorGroup);
	my $Authors="";
	foreach my $Author(@Authors)
	  {
	    $Author=&SplitedAuthorsMark($AuthorString, $Author, $au, $aus, $auf);
	    $Authors="$Authors"."$seperater $Author";
	  }
	$Authors=~s/^\,//g;
	$Authors=~s/^ //g;
	$Authors=~s/<$aus> /<$aus>/g;
	$Authors=~s/<$auf> /<$auf>/g;
	$AuthorGroup="$TempAuthorGroup "."$Authors";
      }
    elsif($AuthorGroup=~/$regx{firstName} $regx{mAuthorString}([\,\;]) <$au>(.*)<\/$au>([\.]?)/)
      {
	my $TempAuthorGroup="<$au>$4<\/$au>$5";
	#	$AuthorGroup=~s/$regx{firstName}\, $regx{mAuthorString}\, /$1<comma> $2\.<AU>/g;
	$AuthorGroup=~s/$regx{firstName} $regx{mAuthorString}([\,\;]) <$au>(.*)<\/$au>([\.]?)/$1 $2/s;
	my $seperater=$3;
	$AuthorGroup=~s/([\,\;])/<AU>/g;
	my @Authors=split(/<AU>/, $AuthorGroup);
	my $Authors="";
	foreach my $Author(@Authors)
	  {
	    $Author=&SplitedAuthorsMark($AuthorString, $Author, $au, $aus, $auf);
	    $Authors="$Authors"."$seperater $Author";
	  }
	$Authors=~s/^\,//g;
	$Authors=~s/^ //g;
	$Authors=~s/<$aus> /<$aus>/g;
	$Authors=~s/<$auf> /<$auf>/g;
	$AuthorGroup="$Authors"."$seperater $TempAuthorGroup";
      }
    elsif($AuthorGroup=~/$regx{firstName} $regx{mAuthorString}([\,\;])/)
      {
	$AuthorGroup=~s/[\,\;]/<AU>/g;
	my @Authors=split(/<AU>/, $AuthorGroup);
	my $Authors="";
	foreach my $Author(@Authors)
	  {
	    $Author=&SplitedAuthorsMark($AuthorString, $Author, $au, $aus, $auf);
	    $Authors="$Authors".", $Author";
	  }
	$Authors=~s/^\,//g;
	$Authors=~s/^ //g;
	$Authors=~s/<$aus> /<$aus>/g;
	$Authors=~s/<$auf> /<$auf>/g;
	$AuthorGroup="$Authors";
      }


    #$AuthorGroup=&VancoverAuthorStyle(\$AuthorGroup, $au, $aus, $auf, \$AuthorString);

    $AuthorGroup=~s/([\,]*) $regx{etal}<\/$au>/<\/$au>$1 $2/gs;
    return $AuthorGroup;
  }

#=======================================================================================================================================

sub authorstyle4
{
    my $AuthorGroup="";
    my $au="";
    $AuthorGroup=shift;
    $au=shift;
    my $aus=shift;
    my $auf=shift;
    my $AuthorString=shift;

    #print "Style4: $AuthorGroup\n";

    $AuthorGroup=~s/(^|\; )$regx{mAuthorFullSirName} $regx{mAuthorFullFirstName} $regx{and} $regx{mAuthorFullSirName} $regx{mAuthorFullFirstName}$/$1<$au><$auf>$2<\/$auf> <$aus>$3<\/$aus><\/$au> $4 <$au><$auf>$5<\/$auf>\, <$aus>$6<\/$aus><\/$au>/gs;

    $AuthorGroup=~s/(^|[\,\;] )$regx{mAuthorString}\, $regx{firstName}([\,]?) $regx{and} $regx{mAuthorString}\, $regx{firstName}$/$1<$au><$aus>$2<\/$aus>\, <$auf>$3<\/$auf><\/$au>$4 $5 <$au><$aus>$6<\/$aus>\, <$auf>$7<\/$auf><\/$au>/g;
    #Von, der M., & George, E.
    $AuthorGroup=~s/^$regx{mAuthorString}\, $regx{particle} $regx{firstName}\, $regx{and} $regx{mAuthorString}\, $regx{firstName}$/<$au><$aus>$1<\/$aus>\, <par>$2<\/par> <$auf>$3<\/$auf><\/$au>\, $4 <$au><$aus>$5<\/$aus>\, <$auf>$6<\/$auf><\/$au>/g;
    #Steinfeld, H. Mooney, H.A. Schneider, F and Neville, L.E.
    $AuthorGroup=~s/^$regx{mAuthorString}\, $regx{firstName}\. $regx{mAuthorString}\, $regx{firstName}\. $regx{mAuthorString}\, $regx{firstName}([\.]?) $regx{and} $regx{mAuthorString}\, $regx{firstName}\.$/<$au><$aus>$1<\/$aus>\, <$auf>$2<\/$auf><\/$au>\. <$au><$aus>$3<\/$aus>\, <$auf>$4<\/$auf><\/$au>\. <$au><$aus>$5<\/$aus>\, <$auf>$6<\/$auf><\/$au>$7 $8 <$au><$aus>$9<\/$aus>\, <$auf>$10<\/$auf><\/$au>/g;
    $AuthorGroup=~s/^$regx{mAuthorString}\, $regx{firstName}\. $regx{mAuthorString}\, $regx{firstName}([\.]?) $regx{and} $regx{mAuthorString}\, $regx{firstName}\.$/<$au><$aus>$1<\/$aus>\, <$auf>$2<\/$auf><\/$au>\. <$au><$aus>$3<\/$aus>\, <$auf>$4<\/$auf><\/$au>$5 $6 <$au><$aus>$7<\/$aus>\, <$auf>$8<\/$auf><\/$au>/g;
    $AuthorGroup=~s/^$regx{mAuthorString}\, $regx{firstName}([\.]?) $regx{and} $regx{mAuthorString}\, $regx{firstName}\.$/<$au><$aus>$1<\/$aus>\, <$auf>$2<\/$auf><\/$au>$3 $4 <$au><$aus>$5<\/$aus>\, <$auf>$6<\/$auf><\/$au>/g;
    $AuthorGroup=~s/^$regx{mAuthorString}\, $regx{firstName}([\.]?) $regx{mAuthorString}\, $regx{firstName}\.$/<$au><$aus>$1<\/$aus>\, <$auf>$2<\/$auf><\/$au>$3 <$au><$aus>$4<\/$aus>\, <$auf>$5<\/$auf><\/$au>/g;
    $AuthorGroup=~s/^$regx{mAuthorString}\, $regx{firstName}$/<$au><$aus>$1<\/$aus>\, <$auf>$2<\/$auf><\/$au>/g;
    #Saravanan, V., & Hoon, J. N. L.

    #Eemeren, F. H. van, and R. Grootendorst
    $AuthorGroup=~s/^$regx{mAuthorString}\, $regx{firstName} $regx{particle}([\,]?) $regx{and} $regx{firstName} $regx{mAuthorString}$/<$au><$aus>$1<\/$aus>\, <$auf>$2<\/$auf> <par>$3<\/par><\/$au>$4 $5 <$au><$aus>$6<\/$aus> <$auf>$7<\/$auf><\/$au>/g;
    #Rhodes, Olin E. Jr., and Michael H., Smith
    #$AuthorGroup=~s/(^|[\,\;] )$regx{mAuthorString}
    $AuthorGroup=~s/(^|[\,\;] )$regx{mAuthorFullSirName}\, $regx{mAuthorFullFirstName} $regx{firstName} $regx{suffix}([\,]?) $regx{and} $regx{mAuthorFullFirstName} $regx{firstName}\, $regx{mAuthorFullSirName}$/$1<$au><$aus>$2<\/$aus>\, <$auf>$3 $4<\/$auf> <suffix>$5<\/suffix><\/$au>$6 $7 <$au><$auf>$8 $9<\/$auf>\, <$aus>$10<\/$aus><\/$au>/g;
    #Perry, Jr., E.C. and Montgomery, C.W
    $AuthorGroup=~s/^$regx{sAuthorString}\, $regx{suffix}\, $regx{firstName} $regx{and} $regx{sAuthorString}\, $regx{firstName}$/<$au><$aus>$1<\/$aus>\, <suffix>$2<\/suffix>\, <$auf>$3<\/$auf><\/$au> $4 <$au><$aus>$5<\/$aus>\, <$auf>$6<\/$auf><\/$au>/g;

    $AuthorGroup=~s/^$regx{particle} $regx{mAuthorString} $regx{firstName}\, $regx{mAuthorString}\, $regx{firstName}$/<$au><par>$1<\/par> <$aus>$2<\/$aus> <$auf>$3<\/$auf><\/$au>\, <$au><$aus>$4<\/$aus>\, <$auf>$5<\/$auf><\/$au>/g;

    $AuthorGroup=~s/^$regx{sAuthorString}([\,]?) $regx{firstName} $regx{particle}$/<$au><$aus>$1<\/$aus>$2 <$auf>$3<\/$auf> <par>$4<\/par><\/$au>/g;
    $AuthorGroup=~s/^$regx{particle} $regx{mAuthorString} $regx{firstName}$/<$au><par>$1<\/par> <$aus>$2<\/$aus> <$auf>$3<\/$auf><\/$au>/g;
    $AuthorGroup=~s/^([$AuthorString ]+ [$AuthorString ]+)([\,]?) $regx{firstName} $regx{particle}$/<$au><$aus>$1<\/$aus>$2 <$auf>$3<\/$auf> <par>$4<\/par><\/$au>/g;

    $AuthorGroup=~s/^$regx{sAuthorString}([\,]?) $regx{firstName}([\,]*) $regx{etal}$/<$au><$aus>$1<\/$aus>$2 <$auf>$3<\/$auf>$4 $5<\/$au>/o;

    $AuthorGroup=~s/^([$AuthorString ]+ [$AuthorString ]+)([\,]?) $regx{firstName}([\,]*) $regx{etal}$/<$au><$aus>$1<\/$aus>$2 <$auf>$3<\/$auf>$4 $5<\/$au>/o;
    $AuthorGroup=~s/^$regx{sAuthorString}([\,]?) $regx{mAuthorString} et al\.$/<$au><$aus>$1<\/$aus>$2 <$auf>$3<\/$auf> et al\.<\/$au>/o;

    $AuthorGroup=~s/([\s]*)$regx{sAuthorString}([\,]?) $regx{firstName}([\,]*) $regx{etal}$/$1<$au><$aus>$2<\/$aus>$3 <$auf>$4<\/$auf>$5 $6<\/$au>/o;
    $AuthorGroup=~s/([\s]*)([$AuthorString ]+ [$AuthorString ]+)([\,]?) $regx{firstName}([\,]*) $regx{etal}$/$1<$au><$aus>$2<\/$aus>$3 <$auf>$4<\/$auf>$5 $6<\/$au>/o;

    $AuthorGroup=~s/^$regx{sAuthorString} $regx{sAuthorString} $regx{firstName}$/<$au><$aus>$1 $2<\/$aus> <$auf>$3<\/$auf><\/$au>/o;
    $AuthorGroup=~s/^$regx{sAuthorString}\, $regx{sAuthorString} (Th[\.]?)$/<$au><$aus>$1<\/$aus>\, <$auf>$2 $3<\/$auf><\/$au>/o;
    $AuthorGroup=~s/^$regx{sAuthorString}\, $regx{mAuthorString}$/<$au><$aus>$1<\/$aus>\, <$auf>$2<\/$auf><\/$au>/o;
    #Hall, Robert A. Jr
    $AuthorGroup=~s/^$regx{sAuthorString}\, $regx{mAuthorString} $regx{firstName} $regx{suffix}$/<$au><$aus>$1<\/$aus>\, <$auf>$2 $3<\/$auf> <suffix>$4<\/suffix><\/$au>/o;


   # O¬íNeil, J. M. Jr., and J. Egan
    $AuthorGroup=~s/^$regx{mAuthorString}([\,]?) $regx{firstName} $regx{suffix}([\,]?) $regx{and}([\,]?) $regx{firstName} $regx{mAuthorString}$/<$au><$aus>$1<\/$aus>$2 <$auf>$3<\/$auf> <suffix>$4<\/suffix><\/$au>$5 $6$7 <$au><$auf>$8<\/$auf> <$aus>$9<\/$aus><\/$au>/o;

    $AuthorGroup=~s/^$regx{mAuthorString} $regx{suffix}([\,]?) $regx{firstName}([\,]?) $regx{and}([\,]?) $regx{firstName} $regx{mAuthorString}$/<$au><$aus>$1<\/$aus> <suffix>$2<\/suffix>$3 <$auf>$4<\/$auf><\/$au>$5 $6$7 <$au><$auf>$8<\/$auf> <$aus>$9<\/$aus><\/$au>/o;
    $AuthorGroup=~s/^$regx{mAuthorString} $regx{suffix}([\,]?) $regx{firstName}\; $regx{firstName} $regx{mAuthorString}$/<$au><$aus>$1<\/$aus> <suffix>$2<\/suffix>$3 <$auf>$4<\/$auf><\/$au>\; <$au><$auf>$5<\/$auf> <$aus>$6<\/$aus><\/$au>/o;
    $AuthorGroup=~s/^$regx{mAuthorString} $regx{suffix}([\,]?) $regx{firstName}\; $regx{mAuthorString}([\,]?) $regx{firstName}$/<$au><$aus>$1<\/$aus> <suffix>$2<\/suffix>$3 <$auf>$4<\/$auf><\/$au>\; <$au><$aus>$5<\/$aus>$6 <$auf>$7<\/$auf><\/$au>/o;

    #O‚ÄôNeil, J.M. Jr., Egan, J. 
    $AuthorGroup=~s/^$regx{mAuthorString}([\,]?) $regx{firstName} $regx{suffix}([\,]) $regx{firstName} $regx{mAuthorString}(\s?)$/<$au><$aus>$1<\/$aus>$2 <$auf>$3<\/$auf> <suffix>$4<\/suffix><\/$au>$5 <$au><$auf>$6<\/$auf> <$aus>$7<\/$aus><\/$au>$8/o;
    $AuthorGroup=~s/^$regx{mAuthorString}([\,]) $regx{firstName} $regx{suffix}([\,]) $regx{mAuthorString}([\,]) $regx{firstName}(\s?)$/<$au><$aus>$1<\/$aus>$2 <$auf>$3<\/$auf> <suffix>$4<\/suffix><\/$au>$5 <$au><$aus>$6<\/$aus>$7 <$auf>$8<\/$auf><\/$au>$9/o;


    $AuthorGroup=~s/$regx{sAuthorString} $regx{firstName} $regx{mAuthorString}([\,]?) $regx{and}([\,]?) $regx{sAuthorString} $regx{firstName} $regx{mAuthorString}$/<$au><$aus>$1<\/$aus> <$auf>$2 $3<\/$auf><\/$au>$4 $5$6 <$au><$aus>$7<\/$aus> <$auf>$8 $9<\/$auf><\/$au>/o;


    $AuthorGroup=~s/$regx{sAuthorString} $regx{mAuthorString}([\,]?) $regx{and}([\,]?) $regx{sAuthorString} $regx{firstName} $regx{mAuthorString}$/<$au><$aus>$1<\/$aus> <$auf>$2<\/$auf><\/$au>$3 $4$5 <$au><$aus>$6<\/$aus> <$auf>$7 $8<\/$auf><\/$au>/o;
    $AuthorGroup=~s/(^|\, )$regx{mAuthorString} $regx{sAuthorString}([\,]?) $regx{and}([\,]?) $regx{mAuthorString} $regx{sAuthorString}$/$1<$au><$auf>$2<\/$auf> <$aus>$3<\/$aus><\/$au>$4 $5$6 <$au><$auf>$7<\/$auf> <$aus>$8<\/$aus><\/$au>/o;
    $AuthorGroup=~s/(^|\, )$regx{mAuthorString} $regx{sAuthorString}([\,]?) $regx{and}([\,]?) $regx{sAuthorString} $regx{mAuthorString} $regx{firstName}$/$1<$au><$auf>$2<\/$auf> <$aus>$3<\/$aus><\/$au>$4 $5$6 <$au><$aus>$7<\/$aus> <$auf>$8<\/$auf><\/$au>/o;

    $AuthorGroup=~s/^$regx{mAuthorFullSirName}\, $regx{mAuthorFullFirstName}\, $regx{mAuthorFullFirstName} $regx{mAuthorFullSirName}$/<$au><$aus>$1<\/$aus>\, <$auf>$2<\/$auf><\/$au>\, <$au><$auf>$3<\/$auf> <$aus>$4<\/$aus><\/$au>/o;

    $AuthorGroup=~s/^$regx{sAuthorString} $regx{mAuthorFullSirName}\, $regx{sAuthorString} $regx{mAuthorFullSirName}$/<$au><$auf>$1<\/$auf> <$aus>$2<\/$aus><\/$au>\, <$au><$auf>$3<\/$auf> <$aus>$4<\/$aus><\/$au>/o;
    $AuthorGroup=~s/^$regx{mAuthorFullFirstName} $regx{mAuthorFullSirName}$/<$au><$auf>$1<\/$auf> <$aus>$2<\/$aus><\/$au>/o;
    $AuthorGroup=~s/^$regx{mAuthorFullFirstName} $regx{mAuthorFullSirName}$/<$au><$auf>$1<\/$auf> <$aus>$2<\/$aus><\/$au>/o;

    $AuthorGroup=~s/$regx{sAuthorString}\, $regx{mAuthorString} $regx{and} $regx{sAuthorString}\, $regx{mAuthorString}$/<$au><$aus>$1<\/$aus>\, <$auf>$2<\/$auf><\/$au> $3 <$au><$aus>$4<\/$aus>\, <$auf>$5<\/$auf><\/$au>/o;

    #Atkinson, J. Maxwell and Paul Drew
    $AuthorGroup=~s/^$regx{sAuthorString}([\,]?) $regx{firstName} $regx{sAuthorString}([\,]?) $regx{and}([\,]?) $regx{sAuthorString} $regx{mAuthorString}$/<$au><$aus>$1<\/$aus>$2 <$auf>$3 $4<\/$auf><\/$au>$5 $6$7 <$au><$aus>$8<\/$aus> <$auf>$9<\/$auf><\/$au>/o;


    $AuthorGroup=~s/^([$AuthorString ]+ [$AuthorString ]+)\, $regx{mAuthorString}$/<$au><$aus>$1<\/$aus>\, <$auf>$2<\/$auf><\/$au>/o;
    $AuthorGroup=~s/^$regx{sAuthorString} $regx{mAuthorString}$/<$au><$aus>$1<\/$aus> <$auf>$2<\/$auf><\/$au>/o;
    $AuthorGroup=~s/^$regx{particle} $regx{sAuthorString}\, $regx{mAuthorString}$/<$au><par>$1<\/par> <$aus>$2<\/$aus>\, <$auf>$3<\/$auf><\/$au>/o;
    $AuthorGroup=~s/^$regx{sAuthorString}([\,]?) ([A-Zvd\-\. ]+)$/<$au><$aus>$1<\/$aus>$2 <$auf>$3<\/$auf><\/$au>/gs;
    $AuthorGroup=~s/^([$AuthorString ]+ [$AuthorString ]+)([\,]?) ([A-Zvd\-\. ]+)$/<$au><$aus>$1<\/$aus>$2 <$auf>$3<\/$auf><\/$au>/gs;
    $AuthorGroup=~s/^$regx{sAuthorString}\, $regx{sAuthorString} ([A-Zvd\-\. ]+)$/<$au><$aus>$1<\/$aus>\, <$auf>$2 $3<\/$auf><\/$au>/gs;


    $AuthorGroup=~s/^$regx{mAuthorString}\, ([$AuthorString]+[A-Z‚Äì\.\- ]*)([\,]?) $regx{and}([\,]?) ([$AuthorString]+[A-Z‚Äì\.\- ]*) $regx{sAuthorString}$/<$au><$aus>$1<\/$aus>\, <$auf>$2<\/$auf><\/$au>$3 $4$5 <$au><$auf>$6<\/$auf> <$aus>$7<\/$aus><\/$au>/o;

    #Henderson, J. Neil and J. W. Traphagan
    $AuthorGroup=~s/^$regx{mAuthorString}\, $regx{firstName} $regx{mAuthorString} $regx{and} $regx{firstName} $regx{mAuthorString}$/<$au><$aus>$1<\/$aus>\, <$auf>$2 $3<\/$auf><\/$au> $4 <$au><$auf>$5<\/$auf> <$aus>$6<\/$aus><\/$au>/gs;

    $AuthorGroup=~s/^$regx{sAuthorString} $regx{etal}$/<$au><$aus>$1<\/$aus> $2<\/$au>/gs;
    $AuthorGroup=~s/\, $regx{firstName}\. $regx{mAuthorString} $regx{firstName}([\.]?) $regx{mAuthorString}$/\, <$au><$auf>$1<\/$auf>\. <$aus>$2<\/$aus><\/$au> <$au><$auf>$3<\/$auf>$4 <$aus>$5<\/$aus><\/$au>/o;
    $AuthorGroup=~s/^$regx{sAuthorString}\, $regx{mAuthorString} $regx{firstName}\, <$au>/<$au><$aus>$1<\/$aus>\, <$auf>$2 $3<\/$auf><\/$au>\, <$au>/gs;
    $AuthorGroup=~s/^$regx{sAuthorString}\, $regx{mAuthorString}\, <$au>/<$au><$aus>$1<\/$aus>\, <$auf>$2<\/$auf><\/$au>\, <$au>/gs;

    $AuthorGroup=~s/^$regx{mAuthorFullSirName}\, $regx{firstName}\. $regx{mAuthorFullSirName}\, $regx{firstName}$/<$au><$aus>$1<\/$aus>\, <$auf>$2\.<\/$auf><\/$au>\, <$au><$aus>$3<\/$aus>\, <$auf>$4<\/$auf><\/$au>/gs;
 
    $AuthorGroup=&VancoverAuthorStyle(\$AuthorGroup, $au, $aus, $auf, \$AuthorString);

    #Balzer, R. James, G. LaPrairie, L. Olson, T.
    if($AuthorGroup=~/^$regx{mAuthorString}\, $regx{firstName}\. $regx{mAuthorString}\, $regx{firstName}\. $regx{mAuthorString}\, $regx{firstName}\.($| )/)
    {
	$AuthorGroup=~s/$regx{mAuthorString}\, $regx{firstName}\. /$1\, $2\.<AU>/gs;
	$AuthorGroup=~s/\, $regx{firstName}\.<AU>$regx{firstName}\.$/\, $1\.$2\./gs;
	my @Authors=split(/<AU>/, $AuthorGroup);
	my $Authors="";
	foreach my $Author(@Authors)
	  {
	    $Author=&SplitedAuthorsMark($AuthorString, $Author, $au, $aus, $auf);
	    $Authors="$Authors"."$seperater $Author";
	  }
	$Authors=~s/^\,//g;
	$Authors=~s/^ //g;
	$Authors=~s/<$aus> /<$aus>/g;
	$Authors=~s/<$auf> /<$auf>/g;
	$AuthorGroup=$Authors;

      }


    if($AuthorGroup=~/$regx{mAuthorString}\, $regx{sAuthorString}([\;]) <$au>(.*)<\/$au>/)
    {
	my $TempAuthorGroup="<$au>$4<\/$au>";
	$AuthorGroup=~s/$regx{mAuthorString}\, $regx{sAuthorString}([\;]) <$au>(.*)<\/$au>/$1\, $2/s;
	my $seperater=$3;
	$AuthorGroup=~s/\;/<AU>/g;
	my @Authors=split(/<AU>/, $AuthorGroup);
	my $Authors="";
	foreach my $Author(@Authors)
	  {
	    $Author=&SplitedAuthorsMark($AuthorString, $Author, $au, $aus, $auf);
	    $Authors="$Authors"."$seperater $Author";
	  }
	$Authors=~s/^\,//g;
	$Authors=~s/^ //g;
	$Authors=~s/<$aus> /<$aus>/g;
	$Authors=~s/<$auf> /<$auf>/g;
	$AuthorGroup="$Authors"."$seperater $TempAuthorGroup";
      }elsif($AuthorGroup=~/$regx{mAuthorString}\, $regx{sAuthorString}([\/])[ ]?<$au>(.*)<\/$au>/)
	{
	my $TempAuthorGroup="<$au>$4<\/$au>";
	$AuthorGroup=~s/$regx{mAuthorString}\, $regx{sAuthorString}([\/])[ ]?<$au>(.*)<\/$au>/$1\, $2/s;
	my $seperater=$3;
	$AuthorGroup=~s/([^><])\//$1<AU>/g;
	my @Authors=split(/<AU>/, $AuthorGroup);
	my $Authors="";
	foreach my $Author(@Authors)
	  {
	    $Author=&SplitedAuthorsMark($AuthorString, $Author, $au, $aus, $auf);
	    $Authors="$Authors"."$seperater $Author";
	  }
	$Authors=~s/^ //g;
	$Authors=~s/^(\,|\/|\;)//g;
	$Authors=~s/^ //g;
	$Authors=~s/<$aus> /<$aus>/g;
	$Authors=~s/<$auf> /<$auf>/g;
	$AuthorGroup="$Authors"."${seperater}$TempAuthorGroup";
      }
    elsif($AuthorGroup=~/$regx{mAuthorString} $regx{sAuthorString}([\,\;]) <$au>(.*)<\/$au>/)
      {
	my $TempAuthorGroup="<$au>$4<\/$au>";
	$AuthorGroup=~s/$regx{mAuthorString} $regx{sAuthorString}([\,\;]) <$au>(.*)<\/$au>/$1 $2/s;
	my $seperater=$3;
	$AuthorGroup=~s/([\;\,])/<AU>/g;
	my @Authors=split(/<AU>/, $AuthorGroup);
	my $Authors="";
	foreach my $Author(@Authors)
	  {
	    $Author=&SplitedAuthorsMark($AuthorString, $Author, $au, $aus, $auf);
	    $Authors="$Authors"."$seperater $Author";
	  }
	$Authors=~s/^ //g;
	$Authors=~s/^(\,|\/|\;)//g;
	$Authors=~s/^ //g;
	$Authors=~s/<$aus> /<$aus>/g;
	$Authors=~s/<$auf> /<$auf>/g;
	$AuthorGroup="$Authors"."${seperater} $TempAuthorGroup";
      }elsif($AuthorGroup=~/$regx{sAuthorString} $regx{mAuthorString}([\/])[ ]?<$au>(.*)<\/$au>/)
	{
	  my $TempAuthorGroup="<$au>$4<\/$au>";
	  $AuthorGroup=~s/$regx{sAuthorString} $regx{mAuthorString}([\/])[ ]?<$au>(.*)<\/$au>/$1 $2/s;
	  my $seperater=$3;
	  $AuthorGroup=~s/([^><])\//$1<AU>/g;
	  my @Authors=split(/<AU>/, $AuthorGroup);
	  my $Authors="";
	  foreach my $Author(@Authors)
	    {
	      $Author=&SplitedAuthorsMark($AuthorString, $Author, $au, $aus, $auf);
	      $Authors="$Authors"."$seperater $Author";
	    }
	  $Authors=~s/^ //g;
	  $Authors=~s/^(\,|\/|\;)//g;
	  $Authors=~s/^ //g;
	  $Authors=~s/<$aus> /<$aus>/g;
	  $Authors=~s/<$auf> /<$auf>/g;
	  $AuthorGroup="$Authors"."${seperater}$TempAuthorGroup";
	}elsif($AuthorGroup=~/$regx{sAuthorString}\, $regx{mAuthorString}([ ]?[\/\;])/)
	  {
	    my $seperater="$3";
	    $AuthorGroup=~s/\;/<AU>/g;
	    if($AuthorGroup=~/[^><]\//){
	      $AuthorGroup=~s/([^><])\//$1<AU>/g;
	    }
	    my @Authors=split(/<AU>/, $AuthorGroup);
	    my $Authors="";
	    foreach my $Author(@Authors)
	      {
		$Author=&SplitedAuthorsMark($AuthorString, $Author, $au, $aus, $auf);
		$Authors="$Authors"."$seperater $Author";
	    }
	    $Authors=~s/^ //g;
	    $Authors=~s/^(\,|\/|\;)//g;
	    $Authors=~s/^ //g;
	    $Authors=~s/<$aus> /<$aus>/g;
	    $Authors=~s/<$auf> /<$auf>/g;
	    $AuthorGroup="$Authors";
	  }elsif($AuthorGroup=~/$regx{sAuthorString} $regx{mAuthorString}([ ]?[\/\;])/)
	    {
	      my $seperater="$3";
	      $AuthorGroup=~s/\;/<AU>/g;
	      if($AuthorGroup=~/[^><]\//){
		$AuthorGroup=~s/([^><])\//$1<AU>/g;
	      }
	      my @Authors=split(/<AU>/, $AuthorGroup);
	      my $Authors="";
	      foreach my $Author(@Authors)
		{
		  $Author=&SplitedAuthorsMark($AuthorString, $Author, $au, $aus, $auf);
		  $Authors="$Authors"."$seperater $Author";
		}
	      $Authors=~s/^ //g;
	      $Authors=~s/^(\,|\/|\;)//g;
	      $Authors=~s/^ //g;
	      $Authors=~s/<$aus> /<$aus>/g;
	      $Authors=~s/<$auf> /<$auf>/g;
	      $AuthorGroup="$Authors";
	    }elsif($AuthorGroup=~/$regx{mAuthorString}\, $regx{firstName}([ ]?[\/\;])/)
	      {
		my $seperater="$3";
		$AuthorGroup=~s/\;/<AU>/g;
		if($AuthorGroup=~/[^><]\//){
		  $AuthorGroup=~s/([^><])\//$1<AU>/g;
		}
		my @Authors=split(/<AU>/, $AuthorGroup);
		my $Authors="";
		foreach my $Author(@Authors)
		  {
		    $Author=&SplitedAuthorsMark($AuthorString, $Author, $au, $aus, $auf);
		    $Authors="$Authors"."$seperater $Author";
		  }
		$Authors=~s/^ //g;
		$Authors=~s/^(\,|\/|\;)//g;
		$Authors=~s/^ //g;
		$Authors=~s/<$aus> /<$aus>/g;
		$Authors=~s/<$auf> /<$auf>/g;
		$AuthorGroup="$Authors";
	      }elsif($AuthorGroup=~/$regx{sAuthorString}\, ([$AuthorString]+ [A-Zvd\-\. ]+)([ ]?[\/\;])/)
		{
		  my $seperater="$3";
		  $AuthorGroup=~s/\;/<AU>/g;
		  if($AuthorGroup=~/[^><]\//){
		    $AuthorGroup=~s/([^><])\//$1<AU>/g;
		  }
		  my @Authors=split(/<AU>/, $AuthorGroup);
		  my $Authors="";
		  foreach my $Author(@Authors)
		    {
		      $Author=&SplitedAuthorsMark($AuthorString, $Author, $au, $aus, $auf);
		      $Authors="$Authors"."$seperater $Author";
		    }
		  $Authors=~s/^ //g;
		  $Authors=~s/^(\,|\/|\;)//g;
		  $Authors=~s/^ //g;
		  $Authors=~s/<$aus> /<$aus>/g;
		  $Authors=~s/<$auf> /<$auf>/g;
		  $AuthorGroup="$Authors";
		}elsif($AuthorGroup=~/$regx{sAuthorString} $regx{mAuthorString}\,/)
		  {
		    my $seperater="\,";
		    $AuthorGroup=~s/\,/<AU>/g;
		    my @Authors=split(/<AU>/, $AuthorGroup);
		    my $Authors="";
		    foreach my $Author(@Authors)
		      {
			$Author=&SplitedAuthorsMark($AuthorString, $Author, $au, $aus, $auf);
			$Authors="$Authors"."$seperater $Author";
		      }
		    $Authors=~s/^\,//g;
		    $Authors=~s/^(\,|\/|\;)//g;
		    $Authors=~s/^ //g;
		    $Authors=~s/<$aus> /<$aus>/g;
		    $Authors=~s/<$auf> /<$auf>/g;
		    $AuthorGroup="$Authors";
		}elsif($AuthorGroup=~/^$regx{mAuthorString}([\,\;]) $regx{firstName} $regx{mAuthorString}/){
			$AuthorGroup=~s/[\,\;]/<AU>/g;
			$AuthorGroup=~s/( \(([eE]ditor[s]?|[eE]d[s]?|[Hh]rsg|[hH]g)[\.]?\))/<AU>$1/g;
			my @Authors=split(/<AU>/, $AuthorGroup);
			my $Authors="";
			foreach my $Author(@Authors){
				$Author=&SplitedAuthorsMark($AuthorString, $Author, $au, $aus, $auf);
				$Authors="$Authors".", $Author";
			}
			$Authors=~s/^\,//g;
			$Authors=~s/^ //g;
			$Authors=~s/<$aus> /<$aus>/g;
			$Authors=~s/<$auf> /<$auf>/g;
			$AuthorGroup="$Authors";
		}


    $AuthorGroup=~s/([\,]*) $regx{etal}<\/$au>/<\/$au>$1 $2/gs;
    return $AuthorGroup;
  }
#==================================================================================================================================
sub authorstyle5
{
    my $AuthorGroup="";
    my $au="";
    $AuthorGroup=shift;
    $au=shift;
    my $aus=shift;
    my $auf=shift;
    my $AuthorString=shift;

    $AuthorGroup=~s/([\,\;] |^)$regx{mAuthorString} $regx{firstName}([\,]?) $regx{and} $regx{mAuthorString} $regx{firstName}$/$1<$au><$aus>$2<\/$aus> <$auf>$3<\/$auf><\/$au>$4 $5 <$au><$aus>$6<\/$aus> <$auf>$7<\/$auf><\/$au>/gs; #****best goto another function call

    $AuthorGroup=~s/^$regx{sAuthorString}\, ([$AuthorString]+[A-Z‚Äì\.\- ]*)([\,]?) $regx{and}([\,]?) ([$AuthorString ]+[A-Z‚Äì\.\- ]*) $regx{particle} $regx{sAuthorString}$/<$au><$aus>$1<\/$aus>\, <$auf>$2<\/$auf><\/$au>$3 $4$5 <$au><$auf>$6<\/$auf> <par>$7<\/par> <$aus>$8<\/$aus><\/$au>/o;
    $AuthorGroup=~s/^$regx{sAuthorString}\, ([$AuthorString]+[A-Z‚Äì\.\- ]*)([\,]?) $regx{and}([\,]?) ([$AuthorString]+[A-Z‚Äì\.\- ]*) $regx{particle} $regx{sAuthorString}$/<$au><$aus>$1<\/$aus>\, <$auf>$2<\/$auf><\/$au>$3 $4$5 <$au><$auf>$6<\/$auf> <par>$7<\/par> <$aus>$8<\/$aus><\/$au>/o;

    $AuthorGroup=~s/^$regx{particle} $regx{sAuthorString}\, ([$AuthorString]+[A-Z‚Äì\.\- ]*)([\,]?) $regx{and}([\,]?) ([$AuthorString]+[A-Z‚Äì\.\- ]*) $regx{sAuthorString}$/<$au><par>$1<\/par> <$aus>$2<\/$aus>\, <$auf>$3<\/$auf><\/$au>$4 $5$6 <$au><$auf>$7<\/$auf> <$aus>$8<\/$aus><\/$au>/o;
    $AuthorGroup=~s/^$regx{particle} $regx{sAuthorString}\, ([$AuthorString]+[A-Z‚Äì\.\- ]*)([\,]?) $regx{and}([\,]?) ([$AuthorString]+[A-Z‚Äì\.\- ]*) $regx{particle} $regx{sAuthorString}$/<$au><par>$1<\/par> <$aus>$2<\/$aus>\, <$auf>$3<\/$auf><\/$au>$4 $5$6 <$au><$auf>$7<\/$auf> <par>$8<\/par> <$aus>$9<\/$aus><\/$au>/o;

   # Brown, Beverly Louise, and Diana E. E. Kleiner    # Lawrence, Arnold Walter, and Richard Allan Tomlinson    #Montaiglon, Anatole de, and Jules Guiffrey
    $AuthorGroup=~s/^$regx{sAuthorString}\, $regx{sAuthorString} $regx{particle}([\,]?) $regx{and}([\,]?) ([$AuthorString]+[A-Z‚Äì\.\- ]*) $regx{sAuthorString}$/<$au><$aus>$1<\/$aus>\, <$auf>$2<\/$auf> <par>$3<\/par><\/$au>$4 $5$6 <$au><$auf>$7<\/$auf> <$aus>$8<\/$aus><\/$au>/o;
    $AuthorGroup=~s/^$regx{sAuthorString}\, $regx{mAuthorString}([\,]?) $regx{and}([\,]?) ([$AuthorString]+[A-Z‚Äì\.\- ]*) $regx{sAuthorString}$/<$au><$aus>$1<\/$aus>\, <$auf>$2<\/$auf><\/$au>$3 $4$5 <$au><$auf>$6<\/$auf> <$aus>$7<\/$aus><\/$au>/o;


    $AuthorGroup=~s/^$regx{sAuthorString} $regx{mAuthorString}\, $regx{sAuthorString} $regx{mAuthorString}([\,]?) $regx{and} $regx{firstName} $regx{mAuthorString}$/<$au><$auf>$1<\/$auf> <$aus>$2<\/$aus><\/$au>\, <$au><$auf>$3<\/$auf> <$aus>$4<\/$aus><\/$au>$5 $6 <$au><$auf>$7<\/$auf> <$aus>$8<\/$aus><\/$au>/gs;
    $AuthorGroup=~s/^$regx{sAuthorString} $regx{mAuthorString}\, $regx{sAuthorString} $regx{mAuthorString}([\,]?) $regx{and} $regx{sAuthorString} $regx{mAuthorString}$/<$au><$auf>$1<\/$auf> <$aus>$2<\/$aus><\/$au>\, <$au><$auf>$3<\/$auf> <$aus>$4<\/$aus><\/$au>$5 $6 <$au><$auf>$7<\/$auf> <$aus>$8<\/$aus><\/$au>/gs;
  $AuthorGroup=~s/\, $regx{sAuthorString} $regx{mAuthorString}([\,]?) $regx{and} $regx{firstName} $regx{mAuthorString}$/\, <$au><$auf>$1<\/$auf> <$aus>$2<\/$aus><\/$au>$3 $4 <$au><$auf>$5<\/$auf> <$aus>$6<\/$aus><\/$au>/gs;
    $AuthorGroup=~s/\, $regx{sAuthorString} $regx{mAuthorString}([\,]?) $regx{and} $regx{mAuthorString} $regx{mAuthorString}$/\, <$au><$auf>$1<\/$auf> <$aus>$2<\/$aus><\/$au>$3 $4 <$au><$auf>$5<\/$auf> <$aus>$6<\/$aus><\/$au>/gs;

    $AuthorGroup=~s/^$regx{sAuthorString}\, ([$AuthorString]+[A-Z‚Äì\.\- ]*)([\,]?) $regx{and}([\,]?) ([$AuthorString]+[A-Z‚Äì\.\- ]*) $regx{sAuthorString}$/<$au><$aus>$1<\/$aus>\, <$auf>$2<\/$auf><\/$au>$3 $4$5 <$au><$auf>$6<\/$auf> <$aus>$7<\/$aus><\/$au>/o;
    $AuthorGroup=~s/^([$AuthorString ]+ [$AuthorString ]+)\, ([$AuthorString]+[A-Z‚Äì\.\- ]*)([\,]?) $regx{and}([\,]?) ([$AuthorString]+[A-Z‚Äì\.\- ]*) $regx{sAuthorString}$/<$au><$aus>$1<\/$aus>\, <$auf>$2<\/$auf><\/$au>$3 $4$5 <$au><$auf>$6<\/$auf> <$aus>$7<\/$aus><\/$au>/o;

    $AuthorGroup=~s/\, $regx{sAuthorString}\, ([$AuthorString]+[A-Z‚Äì\.\- ]*)([\,]?) $regx{and}([\,]?) ([$AuthorString ]+[A-Z‚Äì\.\- ]*) $regx{particle} $regx{sAuthorString}$/\, <$au><$aus>$1<\/$aus>\, <$auf>$2<\/$auf><\/$au>$3 $4$5 <$au><$auf>$6<\/$auf> <par>$7<\/par> <$aus>$8<\/$aus><\/$au>/o;
    $AuthorGroup=~s/\, $regx{sAuthorString}\, ([$AuthorString]+[A-Z‚Äì\.\- ]*)([\,]?) $regx{and}([\,]?) ([$AuthorString]+[A-Z‚Äì\.\- ]*) $regx{particle} $regx{sAuthorString}$/\, <$au><$aus>$1<\/$aus>\, <$auf>$2<\/$auf><\/$au>$3 $4$5 <$au><$auf>$6<\/$auf> <par>$7<\/par> <$aus>$8<\/$aus><\/$au>/o;
   $AuthorGroup=~s/\, ([$AuthorString ]+[A-Z‚Äì\.\- ]*) $regx{particle} $regx{sAuthorString}([\,]?) $regx{and}([\,]?) ([$AuthorString]+[A-Z‚Äì\.\- ]*) $regx{sAuthorString}$/\, <$au><$auf>$1<\/$auf> <par>$2<\/par> <$aus>$3<\/$aus><\/$au>$4 $5$6 <$au><$auf>$7<\/$auf> <$aus>$8<\/$aus><\/$au>/o;
   $AuthorGroup=~s/\, ([$AuthorString]+[A-Z‚Äì\.\- ]*) $regx{particle} $regx{sAuthorString}([\,]?) $regx{and}([\,]?) ([$AuthorString]+[A-Z‚Äì\.\- ]*) $regx{sAuthorString}$/\, <$au><$auf>$1<\/$auf> <par>$2<\/par> <$aus>$3<\/$aus><\/$au>$4 $5$6 <$au><$auf>$7<\/$auf> <$aus>$8<\/$aus><\/$au>/o;

    $AuthorGroup=~s/\, ([$AuthorString]+[A-Z‚Äì\.\- ]*) $regx{particle} $regx{sAuthorString}([\,]?) $regx{and}([\,]?) ([$AuthorString]+[A-Z‚Äì\.\- ]*) $regx{particle} $regx{sAuthorString}$/\, <$au><$auf>$1<\/$auf> <par>$2<\/par> <$aus>$3<\/$aus><\/$au>$4 $5$6 <$au><$auf>$7<\/$auf> <par>$8<\/par> <$aus>$9<\/$aus><\/$au>/o;
 
    $AuthorGroup=~s/\, ([$AuthorString]+[A-Z‚Äì\.\- ]*) $regx{sAuthorString}([\,]?) $regx{and}([\,]?) ([$AuthorString]+[A-Z‚Äì\.\- ]*) $regx{sAuthorString}$/\, <$au><$auf>$1<\/$auf> <$aus>$2<\/$aus><\/$au>$3 $4$5 <$au><$auf>$6<\/$auf>  <$aus>$7<\/$aus><\/$au>/o;

    $AuthorGroup=~s/\, ([$AuthorString]+[A-Z‚Äì\.\- ]*) $regx{sAuthorString}([\,]?) $regx{and}([\,]?) ([$AuthorString]+[A-Z‚Äì\.\- ]*) $regx{sAuthorString}$/\, <$au><$auf>$1<\/$auf> <$aus>$2<\/$aus><\/$au>$3 $4$5 <$au><$auf>$6<\/$auf> <$aus>$7<\/$aus><\/$au>/o;

    #M. Sch√ºrz und Wagner K.
    $AuthorGroup=~s/\, ([$AuthorString]+[A-Z‚Äì\.\- ]*) $regx{sAuthorString}([\,]?) $regx{and}([\,]?) $regx{sAuthorString} ([$AuthorString]+[A-Z‚Äì\.\- ]*)$/\, <$au><$auf>$1<\/$auf> <$aus>$2<\/$aus><\/$au>$3 $4$5 <$au><$aus>$6<\/$aus> <$auf>$7<\/$auf><\/$au>/o;

    #$regx{particle}
    $AuthorGroup=~s/^$regx{particle} $regx{sAuthorString}\, $regx{mAuthorString}$/<$au><par>$1<\/par> <$aus>$2<\/$aus>\, <$auf>$3<\/$auf><\/$au>/o;
    $AuthorGroup=~s/^$regx{particle} $regx{sAuthorString}\, $regx{mAuthorString}\, <$au>/<$au><par>$1<\/par> <$aus>$2<\/$aus>\, <$auf>$3<\/$auf><\/$au>\, <$au>/o;

    $AuthorGroup=~s/^$regx{sAuthorString}\, $regx{mAuthorString}$/<$au><$aus>$1<\/$aus>\, <$auf>$2<\/$auf><\/$au>/o;
    $AuthorGroup=~s/^$regx{sAuthorString}\, $regx{mAuthorString}\, <$au>/<$au><$aus>$1<\/$aus>\, <$auf>$2<\/$auf><\/$au>\, <$au>/o;
    $AuthorGroup=~s/^([$AuthorString ]+ [$AuthorString ]+)\, $regx{mAuthorString}$/<$au><$aus>$1<\/$aus>\, <$auf>$2<\/$auf><\/$au>/o;
    $AuthorGroup=~s/^([$AuthorString ]+ [$AuthorString ]+)\, $regx{mAuthorString}\, <$au>/<$au><$aus>$1<\/$aus>\, <$auf>$2<\/$auf><\/$au>\, <$au>/o;
    $AuthorGroup=~s/^$regx{sAuthorString} $regx{mAuthorString}$/<$au><$aus>$1<\/$aus> <$auf>$2<\/$auf><\/$au>/o;
    $AuthorGroup=~s/^$regx{sAuthorString}([\,]?) ([A-Zvd\-\. ]+)$/<$au><$aus>$1<\/$aus>$2 <$auf>$3<\/$auf><\/$au>/gs;
    $AuthorGroup=~s/^([$AuthorString ]+ [$AuthorString ]+)([\,]?) ([A-Zvd\-\. ]+)$/<$au><$aus>$1<\/$aus>$2 <$auf>$3<\/$auf><\/$au>/gs;
    $AuthorGroup=~s/^$regx{sAuthorString}\, $regx{sAuthorString} ([A-Zvd\-\. ]+)$/<$au><$aus>$1<\/$aus>\, <$auf>$2 $3<\/$auf><\/$au>/gs;
    $AuthorGroup=~s/^$regx{sAuthorString}\, ([$AuthorString]+[A-Z‚Äì\.\- ]*)\, /<$au><$aus>$1<\/$aus>\, <$auf>$2<\/$auf><\/$au>\, /o;

    $AuthorGroup=~s/<\/$au>\, $regx{sAuthorString}\, ([$AuthorString]+[A-Z‚Äì\.\- ]*)\, <$au>/<\/$au>\, <$au><$auf>$1<\/$auf>\, <$aus>$2<\/$aus><\/$au>\, <$au>/gs;

    $AuthorGroup=&VancoverAuthorStyle(\$AuthorGroup, $au, $aus, $auf, \$AuthorString);


    if($AuthorGroup=~/(^|\, )$regx{mAuthorString} $regx{firstName}\, <au>(.*)<\/au>/)
      {
    	my $TempAuthorGroup="<au>$4<\/au>";
    	$AuthorGroup=~s/(^|\, )$regx{mAuthorString} $regx{firstName}\, <au>(.*)<\/au>/$1$2 $3/s;
    	$AuthorGroup=~s/\,/<AU>/g;
    	my @Authors=split(/<AU>/, $AuthorGroup);
    	my $Authors="";
    	foreach my $Author(@Authors)
    	{
	  $Author=&SplitedAuthorsMark($AuthorString, $Author, $au, $aus, $auf);
	  $Authors="$Authors"."\, $Author";
    	}
    	$Authors=~s/^\,//g;
    	$Authors=~s/^ //g;
    	$Authors=~s/<$aus> /<$aus>/g;
    	$Authors=~s/<$auf> /<$auf>/g;
    	$AuthorGroup="$Authors"."\, $TempAuthorGroup";
    }elsif($AuthorGroup=~/^$regx{mAuthorString} $regx{firstName}\, /)
      {
    	$AuthorGroup=~s/\,/<AU>/g;
    	my @Authors=split(/<AU>/, $AuthorGroup);
    	my $Authors="";
    	foreach my $Author(@Authors)
    	{
	  $Author=&SplitedAuthorsMark($AuthorString, $Author, $au, $aus, $auf);
	  $Authors="$Authors"."\, $Author";
    	}
    	$Authors=~s/^\,//g;
    	$Authors=~s/^ //g;
    	$Authors=~s/<$aus> /<$aus>/g;
    	$Authors=~s/<$auf> /<$auf>/g;
    	$AuthorGroup=$Authors;
    }elsif($AuthorGroup=~/^<$au>(.*?)<\/$au>(.*?)\, ([^a-z0-9][$AuthorString]+[A-Z‚Äì\.\- ]*) $regx{sAuthorString}\, <$au>(.*)<\/$au>/)
      {
	my $FirstAuthor="<$au>$1<\/$au>";
	my $TempAuthorGroup="<$au>$5<\/$au>";
	$AuthorGroup=~s/^<$au>(.*?)<\/$au>(.*?)\, ([^a-z0-9][$AuthorString]+[A-Z‚Äì\.\- ]*) $regx{sAuthorString}\, <$au>(.*)<\/$au>/$2\, $3 $4/s;
	$AuthorGroup=~s/^\, //g;
	$AuthorGroup=~s/\,/<AU>/g;
	my @Authors=split(/<AU>/, $AuthorGroup);
	my $Authors="";
	foreach my $Author(@Authors)
	  {
	    $Author=~s/([$AuthorString]+[A-Z‚Äì\.\- ]*) $regx{sAuthorString}/$1<AS>$2/g;
	    my ($firstname, $surname)=split(/<AS>/, $Author);
	    $Authors="$Authors".", <$au><$auf>$firstname<\/$auf> <$aus>$surname<\/$aus><\/$au>";
	  }
	$Authors=~s/^\,//g;
	$Authors=~s/^ //g;
	$Authors=~s/<$aus> /<$aus>/g;
	$Authors=~s/<$auf> /<$auf>/g;
	$AuthorGroup="$FirstAuthor\, "."$Authors"."\, $TempAuthorGroup";

      }elsif($AuthorGroup=~/\, ([^a-z0-9][$AuthorString]+[A-Z‚Äì\.\- ]*) $regx{mAuthorString}\, <$au>(.*)<\/$au>/)
	{

	my $TempAuthorGroup="<$au>$3<\/$au>";
	$AuthorGroup=~s/\, $regx{mAuthorString} $regx{mAuthorString}\, <$au>(.*)<\/$au>/\, $1 $2/s;
	$AuthorGroup=~s/^\, //g;
	$AuthorGroup=~s/\,/<AU>/g;
	my @Authors=split(/<AU>/, $AuthorGroup);

	my $Authors="";
	foreach my $Author(@Authors)
	  {
	    $Author=~s/([$AuthorString]+[A-Z‚Äì\.\- ]*) $regx{sAuthorString}$/$1<AS>$2/g;
	    my ($firstname, $surname)=split(/<AS>/, $Author);
	    $Authors="$Authors".", <$au><$auf>$firstname<\/$auf> <$aus>$surname<\/$aus><\/$au>";
	  }
	$Authors=~s/^\,//g;
	$Authors=~s/^ //g;
	$Authors=~s/<$aus> /<$aus>/g;
	$Authors=~s/<$auf> /<$auf>/g;
	$AuthorGroup="$Authors"."\, $TempAuthorGroup";
      }

    $AuthorGroup=~s/([\,]*) $regx{etal}<\/$au>/<\/$au>$1 $2/gs;
    return $AuthorGroup;
}

#=============================================================================================================

sub authorstyle6
{
    my $AuthorGroup="";
    my $au="";
    $AuthorGroup=shift;
    $au=shift;
    my $aus=shift;
    my $auf=shift;
    my $AuthorString=shift;

    #print "Style6 $AuthorGroup\n";

    $AuthorGroup=~s/^$regx{mAuthorFullSirName}\; $regx{firstName}([\,]?) $regx{and} $regx{mAuthorFullSirName}\; $regx{firstName}$/<$au><$aus>$1<\/$aus>\; <$auf>$2<\/$auf><\/$au>$3 $4 <$au><$aus>$5<\/$aus>\; <$auf>$6<\/$auf><\/$au>/gs;
    $AuthorGroup=~s/^$regx{mAuthorFullSirName}\; $regx{firstName}$/<$au><$aus>$1<\/$aus>\; <$auf>$2<\/$auf><\/$au>/gs;
    $AuthorGroup=~s/^$regx{sAuthorString}\; $regx{firstName}([\,]?) $regx{and} $regx{sAuthorString}\; $regx{firstName}$/<$au><$aus>$1<\/$aus>\; <$auf>$2<\/$auf><\/$au>$3 $4 <$au><$aus>$5<\/$aus>\; <$auf>$6<\/$auf><\/$au>/gs;


    if($AuthorGroup=~/^$regx{mAuthorString}\; $regx{firstName}\, /)
      {
	$AuthorGroup=~s/\, $regx{mAuthorString}\; $regx{firstName} $regx{and} $regx{mAuthorString}\; $regx{firstName}$/\, $1\; $2<AU> $3 $4\; $5/gs;
	my $beforeAndComma="F";
	$beforeAndComma="T" if($AuthorGroup=~/\, $regx{and} /);

    	$AuthorGroup=~s/\,/<AU>/g;
    	my @Authors=split(/<AU>/, $AuthorGroup);
    	my $Authors="";
    	foreach my $Author(@Authors)
    	{
	  $Author=&SplitedAuthorsMark($AuthorString, $Author, $au, $aus, $auf);
	  $Authors="$Authors"."\, $Author";
    	}
    	$Authors=~s/^\,//g;
    	$Authors=~s/^ //g;
    	$Authors=~s/<$aus> /<$aus>/g;
    	$Authors=~s/<$auf> /<$auf>/g;
    	$AuthorGroup=$Authors;
	if ($beforeAndComma eq "F"){
	  $AuthorGroup=~s/\, $regx{and}/ $1/gs;
	}

    }elsif($AuthorGroup=~/^$regx{mAuthorString}\; $regx{mAuthorFullFirstName}\, /)
      {
	$AuthorGroup=~s/\, $regx{mAuthorString}\; $regx{mAuthorFullFirstName} $regx{and} $regx{mAuthorString}\; $regx{mAuthorFullFirstName}$/\, $1\; $2<AU> $3 $4\; $5/gs;
	my $beforeAndComma="F";
	$beforeAndComma="T" if($AuthorGroup=~/\, $regx{and} /);

    	$AuthorGroup=~s/\,/<AU>/g;
    	my @Authors=split(/<AU>/, $AuthorGroup);
    	my $Authors="";

    	foreach my $Author(@Authors)
    	{
	  $Author=&SplitedAuthorsMark($AuthorString, $Author, $au, $aus, $auf);
	  $Authors="$Authors"."\, $Author";

    	}
    	$Authors=~s/^\,//g;
    	$Authors=~s/^ //g;
    	$Authors=~s/<$aus> /<$aus>/g;
    	$Authors=~s/<$auf> /<$auf>/g;
    	$AuthorGroup=$Authors;
	if ($beforeAndComma eq "F"){
	  $AuthorGroup=~s/\, $regx{and}/ $1/gs;
	}
    }

    $AuthorGroup=~s/([\,]*) $regx{etal}<\/$au>/<\/$au>$1 $2/gs;
    return $AuthorGroup;
}


#==================================================================================================================================
sub SplitedAuthorsMark{
  my $AuthorString=shift;
  my $Author=shift;
  my $au=shift;
  my $aus=shift;
  my $auf=shift;
  $Author=~s/^ //gs;

  my $andPre="$1$2" if($Author=~s/^$regx{and}([\,\;]? )//s);
  my $andPost="$1$2" if($Author=~s/([\,\;]? )$regx{and}$//s);
  my $postPunc="$1" if($Author=~s/([\,\;\:])$//s);

  $Author=~s/$regx{sAuthorString}\;/$1<semi>/gs;


  $Author=~s/^$regx{and}([\,]?) $regx{firstName} $regx{sAuthorString}$/$1$2 <$au><$auf>$3<\/$auf> <$aus>$4<\/$aus><\/$au>/gs;
  $Author=~s/^$regx{and}([\,]?) $regx{firstName} $regx{mAuthorString}$/$1$2 <$au><$auf>$3<\/$auf> <$aus>$4<\/$aus><\/$au>/gs;


  $Author=~s/^$regx{sAuthorString} $regx{particle}([\,]?) $regx{firstName} $regx{and}([\,]?) $regx{sAuthorString}([\,]?) $regx{firstName}$/<$au><$aus>$1<\/$aus> <par>$2<\/par>$3 <$auf>$4<\/$auf><\/$au> $5$6 <$au><$aus>$7<\/$aus>$8 <$auf>$9<\/$auf><\/$au>/gs;
  $Author=~s/^$regx{sAuthorString}([\,]?) $regx{firstName} $regx{and}([\,]?) $regx{sAuthorString}([\,]?) $regx{particle}([\,]?) $regx{firstName}$/<$au><$aus>$1<\/$aus>$2 <$auf>$3<\/$auf><\/$au> $4$5 <$au><$aus>$6<\/$aus>$7 <par>$8<\/par>$9 <$auf>$10<\/$auf><\/$au>/gs;

  $Author=~s/^$regx{sAuthorString}\, $regx{firstName} $regx{and}([\,]?) $regx{sAuthorString} $regx{firstName}$/<$au><$aus>$1<\/$aus>\, <$auf>$2<\/$auf><\/$au> $3$4 <$au><$aus>$5<\/$aus>\, <$auf>$6<\/$auf><\/$au>/gs;

  $Author=~s/^$regx{sAuthorString}-$regx{particle} $regx{mAuthorString} $regx{firstName}/<$au><$aus>$1\-$2 $3<\/$aus> <$auf>$4<\/$auf><\/$au>/gs;
  $Author=~s/^$regx{sAuthorString} $regx{particle} $regx{mAuthorString} $regx{firstName}/<$au><$aus>$1 $2 $3<\/$aus> <$auf>$4<\/$auf><\/$au>/gs;
  $Author=~s/^$regx{mAuthorString} $regx{firstName} $regx{particle}$/<$au><$aus>$1<\/$aus> <$auf>$2<\/$auf> <par>$3<\/par><\/$au>/g;
  $Author=~s/^$regx{mAuthorString} $regx{particle} $regx{firstName}$/<$au><$aus>$1<\/$aus> <par>$2<\/par> <$auf>$3<\/$auf><\/$au>/g;
  $Author=~s/^$regx{firstName} $regx{particle} $regx{mAuthorString}$/<$au><$auf>$1<\/$auf> <par>$2<\/par> <$aus>$3<\/$aus><\/$au>/g;
  $Author=~s/^$regx{mAuthorString}(\,|<comma>|<semi>) $regx{firstName} $regx{particle}$/<$au><$aus>$1<\/$aus>$2 <$auf>$3<\/$auf> <par>$4<\/par><\/$au>/g;
  #ckles<comma> II R.S.
  $Author=~s/^$regx{mAuthorString}(\,|<comma>|<semi>) $regx{suffix} $regx{firstName}\.$/<$au><$aus>$1<\/$aus>$2 <suffix>$3<\/suffix> <$auf>$4\.<\/$auf><\/$au>/g;


  $Author=~s/^\b$regx{particle} $regx{sAuthorString} $regx{mAuthorString}$/<$au><par>$1<\/par> <$aus>$2<\/$aus> <$auf>$3<\/$auf><\/$au>/gs;
  $Author=~s/^\b$regx{particle} $regx{mAuthorString}(\,|<comma>|<semi>) $regx{mAuthorString}$/<$au><par>$1<\/par> <$aus>$2<\/$aus>$3 <$auf>$4<\/$auf><\/$au>/gs;
  $Author=~s/^\b$regx{particle} $regx{mAuthorString}(\,|<comma>|<semi>) $regx{firstName}$/<$au><par>$1<\/par> <$aus>$2<\/$aus>$3 <$auf>$4<\/$auf><\/$au>/gs;
  $Author=~s/^\b$regx{particle} $regx{mAuthorString} $regx{firstName}$/<$au><par>$1<\/par> <$aus>$2<\/$aus> <$auf>$3<\/$auf><\/$au>/gs;
  #Jr. Ferraris CJ
  $Author=~s/^\b$regx{particleSuffix} $regx{mAuthorString} $regx{firstName}$/<$au><par>$1<\/par> <$aus>$2<\/$aus> <$auf>$3<\/$auf><\/$au>/gs;

  $Author=~s/^\b$regx{particle} $regx{firstName}$/<$au><$aus>$1<\/$aus> <$auf>$2<\/$auf><\/$au>/gs;
  $Author=~s/^\b$regx{firstName} $regx{particle}$/<$au><$auf>$1<\/$auf> <$aus>$2<\/$aus><\/$au>/gs;
  $Author=~s/^\b$regx{particle} $regx{mAuthorString}$/<$au><par>$1<\/par> <$aus>$2<\/$aus><\/$au>/gs;
  $Author=~s/^$regx{mAuthorString} $regx{firstName} $regx{suffix}$/<$au><$aus>$1<\/$aus> <$auf>$2<\/$auf> <suffix>$3<\/suffix><\/$au>/g;
  $Author=~s/^$regx{mAuthorString} $regx{suffix} $regx{firstName}$/<$au><$aus>$1<\/$aus> <suffix>$2<\/suffix> <$auf>$3<\/$auf><\/$au>/g;
  $Author=~s/^$regx{mAuthorString} $regx{suffix}(\,|<comma>|<semi>)$regx{firstName}$/<$au><$aus>$1<\/$aus> <suffix>$2<\/suffix>$3 <$auf>$4<\/$auf><\/$au>/g;

  $Author=~s/^$regx{mAuthorString}(\,|<comma>|<semi>) $regx{firstName} $regx{suffix}$/<$au><$aus>$1<\/$aus>$2 <$auf>$3<\/$auf> <suffix>$4<\/suffix><\/$au>/g;
  $Author=~s/^$regx{mAuthorString} $regx{firstName}([\s]?)$regx{suffix}$/<$au><$aus>$1<\/$aus> <$auf>$2<\/$auf> <suffix>$4<\/suffix><\/$au>/g;
  #Ekdahl Jr.<comma> C. A.
  $Author=~s/^$regx{sAuthorString}(\,|<comma>|<semi>) $regx{firstName}$/<$au><$aus>$1<\/$aus>$2 <$auf>$3<\/$auf><\/$au>/gs;
  $Author=~s/^(De|Van) $regx{mAuthorString} $regx{firstName}$/<$au><$aus>$1 $2<\/$aus> <$auf>$3<\/$auf><\/$au>/o;
  #III

  
  $Author=~s/^\b$regx{sAuthorString} $regx{sAuthorString} $regx{firstName}$/<$au><$aus>$1 $2<\/$aus> <$auf>$3<\/$auf><\/$au>/gs;

  $Author=~s/^$regx{firstName} $regx{mAuthorString} $regx{suffix}$/<$au><$auf>$1<\/$auf> <$aus>$2<\/$aus> <suffix>$3<\/suffix><\/$au>/gs;
  $Author=~s/^$regx{firstName} $regx{mAuthorString} $regx{mAuthorString}$/<$au><$auf>$1<\/$auf> <$aus>$2 $3<\/$aus><\/$au>/gs;
  $Author=~s/^$regx{firstName} $regx{sAuthorString}$/<$au><$auf>$1<\/$auf> <$aus>$2<\/$aus><\/$au>/gs;
  $Author=~s/^$regx{firstName}<comma> $regx{sAuthorString}$/<$au><$auf>$1<\/$auf>\, <$aus>$2<\/$aus><\/$au>/gs;
  $Author=~s/^$regx{firstName} $regx{mAuthorString}\, $regx{firstName}$/<$au><$aus>$1 $2<\/$aus>\, <$auf>$3<\/$auf><\/$au>/o;
  $Author=~s/^$regx{sAuthorString}\, $regx{firstName}$/<$au><$aus>$1<\/$aus>\, <$auf>$2<\/$auf><\/$au>/gs;
  $Author=~s/^$regx{sAuthorString} $regx{firstName}$/<$au><$aus>$1<\/$aus> <$auf>$2<\/$auf><\/$au>/gs;
  $Author=~s/^$regx{sAuthorString}\. $regx{firstName}$/<$au><$aus>$1<\/$aus>\. <$auf>$2<\/$auf><\/$au>/gs;
  $Author=~s/^$regx{mAuthorString} $regx{particle} $regx{sAuthorString}$/<$au><$aus>$1<\/$aus> <par>$2<\/par> <$auf>$3<\/$auf><\/$au>/gs;
  $Author=~s/^$regx{mAuthorString} ([a-z]+) $regx{mAuthorString}\, $regx{firstName}$/<$au><$aus>$1 $2 $3<\/$aus>\, <$auf>$4<\/$auf><\/$au>/gs;

  $Author=~s/^$regx{sAuthorString} $regx{sAuthorString}(\,|<comma>|<semi>) $regx{firstName}$/<$au><$aus>$1 $2<\/$aus>$3 <$auf>$4<\/$auf><\/$au>/gs;

  $Author=~s/^$regx{sAuthorString}(\,|<comma>|<semi>) $regx{firstName}$/<$au><$aus>$1<\/$aus>$2 <$auf>$3<\/$auf><\/$au>/gs;
  $Author=~s/^$regx{sAuthorString} $regx{firstName}$/<$au><$aus>$1<\/$aus> <$auf>$2<\/$auf><\/$au>/gs;
  $Author=~s/^$regx{sAuthorString} $regx{firstName}\. $/<$au><$aus>$1<\/$aus> <$auf>$2\.<\/$auf><\/$au>/gs;

  $Author=~s/^$regx{sAuthorString} $regx{mAuthorString}(\,|<comma>|<semi>) $regx{sAuthorString} $regx{mAuthorString}$/<$au><$aus>$1<\/$aus> <$auf>$2<\/$auf><\/$au>$3 <$au><$aus>$4<\/$aus> <$auf>$5<\/$auf><\/$au>/gs;
  #Crutchfield, Richard S.
  $Author=~s/^$regx{sAuthorString}(\,|<comma>|<semi>) $regx{mAuthorString} $regx{firstName}$/<$au><$aus>$1<\/$aus>$2 <$auf>$3 $4<\/$auf><\/$au>/gs;
  #Pfadenhauer, Michaela
  $Author=~s/^$regx{mAuthorString}(\,|<comma>|<semi>) $regx{mAuthorString}$/<$au><$aus>$1<\/$aus>$2 <$auf>$3<\/$auf><\/$au>/gs;
  $Author=~s/^$regx{mAuthorString}(\,|<comma>|<semi>) $regx{firstName} $regxp{particle}$/<$au><$aus>$1<\/$aus>$2 <$auf>$3<\/$auf> <par>$4<\/par><\/$au>/g;
#  $Author=~s/^$regx{mAuthorString}(\,|<comma>|<semi>) $regx{firstName} ([A-Z][a-z])$/<$au><$aus>$1<\/$aus>$2 <$auf>$3 $4<\/$auf><\/$au>/g;
  $Author=~s/^$regx{mAuthorString}([\,]? )$regx{firstName}([\,]? )$regx{particle}$/<$au><$aus>$1<\/$aus>$2<$auf>$3<\/$auf>$4<par>$5<\/par><\/$au>/gs;
  $Author=~s/^$regx{mAuthorString}([\,]? )$regx{firstName}([\,]? )$regx{suffix}$/<$au><$aus>$1<\/$aus>$2<$auf>$3<\/$auf>$4<suffix>$5<\/suffix><\/$au>/gs;

  $Author=~s/^$regx{mAuthorString} $regx{mAuthorString} $regx{firstName}$/<$au><$aus>$1 $2<\/$aus> <$auf>$3<\/$auf><\/$au>/gs;
  $Author=~s/^([^\W]+?) (\w*[^\w\s]+?\w*)$/<$au><$aus>$1<\/$aus> <$auf>$2<\/$auf><\/$au>/gs;

  $Author=~s/^$regx{sAuthorString} $regx{sAuthorString}$/<$au><$auf>$1<\/$auf> <$aus>$2<\/$aus><\/$au>/gs;
  $Author=~s/^$regx{mAuthorString} $regx{sAuthorString}$/<$au><$auf>$1<\/$auf> <$aus>$2<\/$aus><\/$au>/gs;

  $Author=~s/^$regx{sAuthorString} $regx{mAuthorString}$/<$au><$aus>$1<\/$aus> <$auf>$2<\/$auf><\/$au>/gs;
  $Author=~s/^$regx{sAuthorString} <au><aus>([^<>]*?)<\/aus>/<au><aus>$1 $2<\/aus>/gs;
  $Author=~s/^$regx{mAuthorString}$/<$au><$aus>$1<\/$aus><\/$au>/gs;
  $Author=~s/^$regx{sAuthorString}\, $regx{firstName} $regx{sAuthorString}$/<$au><$aus>$1<\/$aus>\, <$auf>$2 $3<\/$auf><\/$au>/gs;
  $Author=~s/^$regx{sAuthorString} $regx{firstName}\. $regx{sAuthorString} $regx{firstName}\.$/<$au><$aus>$1<\/$aus> <$auf>$2\.<\/$auf><\/$au> <$au><$aus>$3<\/$aus> <$auf>$4\.<\/$auf><\/$au>/gs;
  $Author=~s/^$regx{sAuthorString} $regx{firstName}\. $regx{sAuthorString} $regx{firstName}$/<$au><$aus>$1<\/$aus> <$auf>$2<\/$auf><\/$au>\. <$au><$aus>$3<\/$aus> <$auf>$4<\/$auf><\/$au>/gs;
  $Author=~s/^$regx{sAuthorString}\, $regx{mAuthorFullFirstName} $regx{particle}$/<$au><$aus>$1<\/$aus>\, <$auf>$2<\/$auf> <par>$3<\/par><\/$au>/gs;
  $Author=~s/^$regx{sAuthorString}\, $regx{mAuthorFullFirstName} $regx{suffix}$/<$au><$aus>$1<\/$aus>\, <$auf>$2<\/$auf> <suffix>$3<\/suffix><\/$au>/gs;

  $Author=~s/<comma>/\,/gs;
  $Author=~s/<semi>/\;/gs;

  $Author=~s/<au><$aus>$regx{and}([\,]?) ([^<>]+?)<\/$aus>/$1$2 <au><$aus>$3<\/$aus>/gs;
  $Author=~s/<au><$auf>$regx{and}([\,]?) ([^<>]+?)<\/$auf>/$1$2 <au><$auf>$3<\/$auf>/gs;

  if (defined $andPre){
    $Author="$andPre"."$Author";
  }
  if (defined $andPost){
    $Author="$Author"."$andPost";
  }

  if (defined $postPunc){
    $Author="$Author"."$postPunc";
  }


  return $Author;
}


#===========================================================================================================================================
sub VancoverAuthorStyle{
  my $AuthorGroup=shift;
  my $au=shift;
  my $aus=shift;
  my $auf=shift;
  my $AuthorString=shift;

  $$AuthorGroup=~s/(^|\, )$regx{mAuthorFullSirName}\, $regx{mAuthorFullFirstName}([\,]?) $regx{and}([\,]?) $regx{mAuthorFullSirName}\, $regx{mAuthorFullFirstName}$/$1<$au><$aus>$2<\/$aus>\, <$auf>$3<\/$auf><\/$au>$4 $5$6 <$au><$aus>$7<\/$aus>\, <$auf>$8<\/$auf><\/$au>/gs;
  $$AuthorGroup=~s/(^|\, )$regx{mAuthorFullSirName}\, $regx{mAuthorFullFirstName} $regx{particle}([,]?) $regx{and}([\,]?) $regx{mAuthorFullSirName}\, $regx{mAuthorFullFirstName}$/$1<$au><$aus>$2<\/$aus>\, <$auf>$3<\/$auf> <$auf>$4<\/$auf><\/$au>$5 $6$7 <$au><$aus>$8<\/$aus>\, <$auf>$9<\/$auf><\/$au>/gs;
  $$AuthorGroup=~s/(^|\, )$regx{mAuthorFullSirName}\, $regx{mAuthorFullFirstName} $regx{particle}([,]?) $regx{and}([\,]?) $regx{mAuthorFullSirName}\, $regx{mAuthorFullFirstName} $regx{particle}$/$1<$au><$aus>$2<\/$aus>\, <$auf>$3<\/$auf> <par>$4<\/par><\/$au>$5 $6$7 <$au><$aus>$8<\/$aus>\, <$auf>$9<\/$auf> <par>$10<\/par><\/$au>/gs;

 $$AuthorGroup=~s/(^|\, )$regx{mAuthorFullSirName}\, $regx{mAuthorFullFirstName}([\,]?) $regx{and}([\,]?) $regx{mAuthorFullSirName}\, $regx{firstName}$/$1<$au><$aus>$2<\/$aus>\, <$auf>$3<\/$auf><\/$au>$4 $5$6 <$au><$aus>$7<\/$aus>\, <$auf>$8<\/$auf><\/$au>/gs;
 $$AuthorGroup=~s/(^|\, )$regx{mAuthorFullSirName}\, $regx{firstName}([\,]?) $regx{and}([\,]?) $regx{mAuthorFullSirName}\, $regx{mAuthorFullFirstName}$/$1<$au><$aus>$2<\/$aus>\, <$auf>$3<\/$auf><\/$au>$4 $5$6 <$au><$aus>$7<\/$aus>\, <$auf>$8<\/$auf><\/$au>/gs;
 $$AuthorGroup=~s/(^|\, )$regx{mAuthorFullSirName}\, $regx{firstName}([\,]?) $regx{and}([\,]?) $regx{mAuthorFullSirName}\, $regx{firstName}$/$1<$au><$aus>$2<\/$aus>\, <$auf>$3<\/$auf><\/$au>$4 $5$6 <$au><$aus>$7<\/$aus>\, <$auf>$8<\/$auf><\/$au>/gs;


#  $$AuthorGroup=~s/^$regx{mAuthorFullSirName}\, $regx{mAuthorFullFirstName}([\,]?) $regx{and}([\,]?) $regx{mAuthorFullSirName}([\,]?) $regx{firstName}$/<$au><$aus>$1<\/$aus>\, <$auf>$2<\/$auf><\/$au>$3 $4$5 <$au><$aus>$6<\/$aus>$7 <$auf>$8<\/$auf><\/$au>/gs;

#  $$AuthorGroup=~s/\, $regx{mAuthorFullSirName}\, $regx{mAuthorFullFirstName}([\,]?) $regx{and}([\,]?) $regx{mAuthorFullSirName}([\,]?) $regx{firstName}$/\, <$au><$aus>$1<\/$aus>\, <$auf>$2<\/$auf><\/$au>$3 $4$5 <$au><$aus>$6<\/$aus>$7 <$auf>$8<\/$auf><\/$au>/gs;




  if($$AuthorGroup=~/$regx{mAuthorFullSirName}\, $regx{mAuthorFullFirstName}\, <$au>(.*)<\/$au>$/ || $$AuthorGroup=~/^$regx{mAuthorFullSirName}\, $regx{mAuthorFullFirstName} $regx{particleSuffix}\, <$au>(.*)<\/$au>$/ || $$AuthorGroup=~/^$regx{mAuthorFullSirName}\, $regx{firstName}\, <$au>(.*)<\/$au>$/ || $$AuthorGroup=~/^$regx{mAuthorFullSirName}\, $regx{firstName} $regx{particleSuffix}\, <$au>(.*)<\/$au>$/)
    {
      my $seperater=",";
      my $TempAuthorGroup="<$au>$1<\/$au>" if($$AuthorGroup=~s/\, <$au>(.*)<\/$au>//s);

      if ($$AuthorGroup=~/[^><]\//){
	$seperater="\/";
	$$AuthorGroup=~s/([^><])\/([ ]?)/$1<AU>$2/gs;
      }

      my $commawithand="\," if ($$AuthorGroup=~/\, $regx{and} /);

      $$AuthorGroup=~s/\, $regx{mAuthorFullSirName}\, $regx{mAuthorFullFirstName}$/<AU>$1\, $2/gs;
      $$AuthorGroup=~s/\, $regx{mAuthorFullSirName}\, $regx{mAuthorFullFirstName} $regx{particleSuffix}$/<AU> $1\, $2 $3/gs;
      $$AuthorGroup=~s/\, $regx{mAuthorFullSirName}\, $regx{firstName}$/<AU>$1\, $2/gs;
      $$AuthorGroup=~s/\, $regx{mAuthorFullSirName}\, $regx{firstName} $regx{particleSuffix}$/<AU> $1\, $2 $3/gs;
      {}while($$AuthorGroup=~s/(^|<AU> )$regx{mAuthorFullSirName}\, $regx{mAuthorFullFirstName}\, /$1$2\, $3<AU> /gs);
      {}while($$AuthorGroup=~s/(^|<AU> )$regx{mAuthorFullSirName}\, $regx{mAuthorFullFirstName} $regx{particleSuffix}\, /$1$2\, $3 $4<AU> /gs);
      {}while($$AuthorGroup=~s/(^|<AU> )$regx{mAuthorFullSirName}\, $regx{firstName}\, /$1$2\, $3<AU> /gs);
      {}while($$AuthorGroup=~s/(^|<AU> )$regx{mAuthorFullSirName}\, $regx{firstName} $regx{particleSuffix}\, /$1$2\, $3 $4<AU> /gs);

      my @Authors=split(/<AU>/, $$AuthorGroup);
      my $Authors="";
      foreach my $Author(@Authors)
	{
	  $Author=&SplitedAuthorsMark($$AuthorString, $Author, $au, $aus, $auf);
	  $Authors="$Authors"."$seperater $Author";
	    }
	  $Authors=~s/^\,//g;
	  $Authors=~s/^ //g;
	  $Authors=~s/<$aus> /<$aus>/g;
	  $Authors=~s/<$auf> /<$auf>/g;
      if (defined $TempAuthorGroup){
	$$AuthorGroup="$Authors"."$seperater $TempAuthorGroup";
      }else{
	$$AuthorGroup="$Authors";
      }
      if($commawithand ne "\,"){
	$$AuthorGroup=~s/\, $regx{and} / $1 /gs;
      }

    }

  if($$AuthorGroup=~/^$regx{mAuthorFullSirName}\, $regx{mAuthorFullFirstName}\, / || $$AuthorGroup=~/^$regx{mAuthorFullSirName}\, $regx{mAuthorFullFirstName} $regx{particleSuffix}\, / || $$AuthorGroup=~/^$regx{mAuthorFullSirName}\, $regx{mAuthorFullFirstName}\,$/ || $$AuthorGroup=~/^$regx{mAuthorFullSirName}\, $regx{mAuthorFullFirstName} $regx{particleSuffix}\,$/)
    {
      my $seperater=",";
      my $TempAuthorGroup="<$au>$1<\/$au>" if($$AuthorGroup=~s/\, <$au>(.*)<\/$au>//s);

      if ($$AuthorGroup=~/[^><]\//){
	$seperater="\/";
	$$AuthorGroup=~s/([^><])\/([ ]?)/$1<AU>$2/gs;
      }
      my $commawithand="\," if ($$AuthorGroup=~/\, $regx{and} /);

      $$AuthorGroup=~s/\, $regx{mAuthorFullSirName}\, $regx{mAuthorFullFirstName}$/<AU>$1\, $2/gs;
      $$AuthorGroup=~s/\, $regx{mAuthorFullSirName}\, $regx{mAuthorFullFirstName} $regx{particleSuffix}$/<AU> $1\, $2 $3/gs;
      $$AuthorGroup=~s/\, $regx{mAuthorFullSirName}\, $regx{firstName}$/<AU>$1\, $2/gs;
      $$AuthorGroup=~s/\, $regx{mAuthorFullSirName}\, $regx{firstName} $regx{particleSuffix}$/<AU> $1\, $2 $3/gs;
      {}while($$AuthorGroup=~s/(^|<AU> )$regx{mAuthorFullSirName}\, $regx{mAuthorFullFirstName}\, /$1$2\, $3<AU> /gs);
      {}while($$AuthorGroup=~s/(^|<AU> )$regx{mAuthorFullSirName}\, $regx{mAuthorFullFirstName} $regx{particleSuffix}\, /$1$2\, $3 $4<AU> /gs);
      {}while($$AuthorGroup=~s/(^|<AU> )$regx{mAuthorFullSirName}\, $regx{firstName}\, /$1$2\, $3<AU> /gs);
      {}while($$AuthorGroup=~s/(^|<AU> )$regx{mAuthorFullSirName}\, $regx{firstName} $regx{particleSuffix}\, /$1$2\, $3 $4<AU> /gs);

      my $seperater="\,";
      my @Authors=split(/<AU>/, $$AuthorGroup);
      my $Authors="";
      foreach my $Author(@Authors)
	{
	  $Author=&SplitedAuthorsMark($$AuthorString, $Author, $au, $aus, $auf);
	  $Authors="$Authors"."$seperater $Author";
	}
      $Authors=~s/^\,//g;
      $Authors=~s/^ //g;
      $Authors=~s/<$aus> /<$aus>/g;
      $Authors=~s/<$auf> /<$auf>/g;

      if (defined $TempAuthorGroup){
	$$AuthorGroup="$Authors"."$seperater $TempAuthorGroup";
      }else{
	$$AuthorGroup="$Authors";
      }

      if($commawithand ne "\,"){
	$$AuthorGroup=~s/\, $regx{and} / $1 /gs;
      }

    }

  return $$AuthorGroup;
}


#===========================================================================================
sub AuthorGroupCleanup{
  my ($TextBody, $aug)=@_;

  while($$TextBody=~s/<comment>((?:(?!<[\/]?comment>)(?!<bib)(?!<\/bib>).)+?)<ia>([^<>]*?)<\/ia>((?:(?!<[\/]?comment>)(?!<bib)(?!<\/bib>).)*?)<\/comment>/<comment>$1$2$3<\/comment>/gs){}
  while($$TextBody=~s/<comment>((?:(?!<[\/]?comment>)(?!<bib)(?!<\/bib>).)+?)<edrg>([^<>]*?)<\/edrg>((?:(?!<[\/]?comment>)(?!<bib)(?!<\/bib>).)*?)<\/comment>/<comment>$1$2$3<\/comment>/gs){}


  $$TextBody=~s/ ([A-Z\- \.]+)<\/aug>\. \(/ $1\.<\/aug> \(/gs;
  $$TextBody=~s/ (Jr|Sr)<\/aug>\. \(/ $1\.<\/aug> \(/gs;
  $$TextBody=~s/([A-Z\- \.]+) $regx{mAuthorFullFirstName}\.<\/aug>/$1 $2<\/aug>\./gs;
  $$TextBody=~s/([A-Z\- \.]+) $regx{mAuthorFullSirName}\.<\/aug>/$1 $2<\/aug>\./gs;
  $$TextBody=~s/( [auAU]nd | \& |\,\;\/ |<aug>)$regx{mAuthorFullSirName}\, ([A-Z \.]+\. [A-Z][a-z])<\/aug>\.([\,\;\: ]+)/$1$2\, $3\.<\/aug>$4/gs;

  $$TextBody=~s/\, ([A-Z \.]+)\. ([A-Z])<\/aug>\./\, $1\. $2\.<\/aug>/gs;
  $$TextBody=~s/ et\. al<\/aug>\./ et\. al\.<\/aug>/gs;

  $$TextBody=~s/([A-Z][A-Za-z]+)\, ([A-Z\. ]+\.[ ]?[A-Z])\, ([A-Z][A-Za-z]+)\, ([A-Z\. ]+\.[ ]?[A-Z]\.)\,/$1\, $2\., $3\, $4\,/gs;
  $$TextBody=~s/([A-Z][A-Za-z]+)\, ([A-Z\. ]+\.[ ]?[A-Z]\.) ([A-Z][A-Za-z]+)\, ([A-Z\. ]+\.[ ]?[A-Z]\.)\,/$1\, $2\., $3\, $4\,/gs;
	if($$TextBody=~ /\, ([A-Z‚Äì\-\. ]+) ([A-Z][A-Za-z]+)\, ([A-Z‚Äì\-\. ]+)\, ([A-Z‚Äì\-\. ]+) ([A-Z][A-Za-z]+)\,/){
		my $val = $1;
		my $val2 = $3;
		my @count = $val =~ /\./g;
		my @count1 = $val2=~ /\./g;
		my $con = scalar @count;
		my $con2 = scalar @count1;

		$$TextBody=~s/\, ([A-Z‚Äì\-\. ]+) ([A-Z][A-Za-z]+)\, ([A-Z‚Äì\-\. ]+)\, ([A-Z‚Äì\-\. ]+) ([A-Z][A-Za-z]+)\,/\, $1 $2<comma> $3\, $4 $5\,/gs if ($con eq $con2);
	}
  $$TextBody=~s/([A-Z][A-Za-z]+)\, ([A-Z]\.) ([A-Z][A-Za-z]+)\, ([A-Z\. ]+[\. ]?[A-Z]?\.)\,/$1\, $2, $3\, $4\,/gs;
  $$TextBody=~s/>([A-Z][A-Za-z]+)\, ([A-Z\- ]+)\, ([A-Z][A-Za-z]+)\, ([A-Z\. ]+[\. ]?[A-Z]?\.)\,/>$1\, $2\.\, $3\, $4\,/gs;
  $$TextBody=~s/ ([A-Z\- ]\.)\, (III|II)\.<\/aug>/ $1\, $2<\/aug>\./gs;
  $$TextBody=~s/ ([A-Z \.])<\/aug>\.([\,\;\/])/ $1\.<\/aug>$2/gs;


  #$$TextBody=~s/([\.\,\:\; ]+)et al.</aug>
  $$TextBody=~s/([\.\,\; ]+)<(i|b)>$regx{etal}<\/\2>([\.\,\;]?)<\/$aug>/<\/$aug>$1<$2>$3<\/$2>$4/gs;
  $$TextBody=~s/([\.\,\; ]+)$regx{etal}([\.\,\;]?)<\/$aug>/<\/$aug>$1$2$3/gs;
  $$TextBody=~s/([\.\,\; ]+)(u\.[ ]?a)<\/aug>\./<\/aug>$1$2\./gs;


  $$TextBody=~s/([A-Z\- \.]+) $regx{mAuthorFullFirstName}\.<\/edrg>/$1 $2<\/edrg>\./gs;
  $$TextBody=~s/([A-Z\- \.]+) $regx{mAuthorFullSirName}\.<\/edrg>/$1 $2<\/edrg>\./gs;
  $$TextBody=~s/(>|[\,\;] )$regx{mAuthorFullSirName}([\,]?) $regx{mAuthorFullFirstName}\.<\/edrg>/$1$2$3 $4<\/edrg>\./gs;
  $$TextBody=~s/$regx{and} $regx{mAuthorFullSirName}([\,]?) $regx{mAuthorFullFirstName}\.<\/edrg>/$1 $2$3 $4<\/edrg>\./gs;

  $$TextBody=~s/( [auAU]nd | \& |\,\;\/ |<edrg>)$regx{mAuthorFullSirName}\, ([A-Z \.]+\. [A-Z][a-z])<\/edrg>\.([\,\;\: ]+)/$1$2\, $3\.<\/edrg>$4/gs;

  $$TextBody=~s/([\s]*)([\(\[])$regx{editorSuffix}([\)\]])<\/$aug>/<\/$aug>$1$2$3$4/gs;
  $$TextBody=~s/([\s]*)\b$regx{editorSuffix}<\/$aug>/<\/$aug>$1$2/gs;

  $$TextBody=~s/([\.\,\; ]+)<(i|b)>$regx{etal}<\/\2>([\.\,\;]?)<\/$aug>/<\/$aug>$1<$2>$3<\/$2>$4/gs;

  $$TextBody=~s/([\.\,\; ]+)$regx{etal}([\.\,\;]?)<\/$aug>/<\/$aug>$1$2$3/gs;

  $$TextBody=~s/([\.\,\; ]+) $regx{and}<\/$aug> $regx{etal}([\.\,\; ])/<\/$aug>$1 $2 $3$4/gs;

  $$TextBody=~s/([\.\,\; ]+)(u\.[ ]?a)<\/(edrg|aug)>\./<\/$3>$1$2\./gs;
  $$TextBody=~s/([\,\;] |[>\/])$regx{mAuthorFullSirName}([\,]?) $regx{firstName}<\/$aug>\.\,/$1$2$3 $4\.<\/$aug>\,/gs;


  return $$TextBody;
}

##########################################

return 1;