#version 1.0.4
#Author: Neyaz Ahmad
package ReferenceManager::RefPage;
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(AbriviatePageRange ExpandPagerange);

#=======================================================================================================================================
sub AbriviatePageRange
  {
    my $FileText=shift;
    $FileText=~s/\&lt\;pg\&gt\;/<pg>/gs;
    $FileText=~s/\&lt\;\/pg\&gt\;/<\/pg>/gs;
    while($FileText=~/<pg>((?:(?!<pg>)(?!<\/pg>).)*)<\/pg>/s)
      {
	my $PageText=$1;
	($FPage, $LPage)=split(/\-/, $PageText);
	($FPage, $LPage)=split(/\Q–\E/, $PageText);
	$TempFPage=$FPage;
	$LPage=$LPage;
	$TempFPage=~s/^([A-Zie])//o;
	$LPage=~s/^([A-Zie])//o;

	if($TempFPage <= $LPage)
	  {
	    $length=$FPage=~s/([0-9])/$1/g;
	    for(my $count=1; $count<=$length; $count++)
	      {
		$TempFPage=~s/^(.*)([0-9])$/$1/o;   		#print "$count=> $TempFPage\n";
		if($LPage=~/^$TempFPage/)
		  {
		    $LPage=~s/^$TempFPage//gs;
		    goto PageLabel;
		  }
	      }
	  PageLabel:
	    if($FPage=~/^([A-Zie])/)
	      {
		my $Roman=$1;
		if($LPage ne "")
		  {
		    $LPage="$Roman$LPage";
		  }
	      }
	    if($LPage ne "")
	      {
		$PageText="$FPage–$LPage";
	      }
	  } #First If end 

	$FileText=~s/<pg>((?:(?!<pg>)(?!<\/pg>).)*)<\/pg>/\&lt\;pg\&gt\;$PageText\&lt\;\/pg\&gt\;/os;
      } #While End
    $FileText=~s/<pg>/\&lt\;pg\&gt\;/gs;
    $FileText=~s/<\/pg>/\&lt\;\/pg\&gt\;/gs;
    return $FileText;
  }
#=================================================================================
sub ExpandPagerange
  {
    my $FileText=shift;
    $FileText=~s/\&lt\;pg\&gt\;/<pg>/gs;
    $FileText=~s/\&lt\;\/pg\&gt\;/<\/pg>/gs;
    while($FileText=~/<pg>((?:(?!<pg>)(?!<\/pg>).)*)<\/pg>/s)
      {
	my $PageText=$1;
	if($PageText=~/[0-9]/){
	  ($FPage, $LPage)=split(/\-/, $PageText);
	  ($FPage, $LPage)=split(/\Q–\E/, $PageText);
	  $TempFPage=$FPage;
	  $LPage=$LPage;
	  $TempFPage=~s/^([A-Zie])//o;
	  $LPage=~s/^([A-Zie])//o;
	  if($TempFPage >= $LPage){
	    $fpLength=$FPage=~s/([0-9])/$1/g;
	    $lpLength=$LPage=~s/([0-9])/$1/g;
	    if($LPage ne ""){
	      if($fpLength > $lpLength){
		my $addpage=$TempFPage;
		foreach(1..$lpLength){
		  $addpage=~s/^(.*)([0-9])$/$1/o;
		}
		$LPage="$addpage"."$LPage";
	      }
	    }
	  }

	  if($FPage=~/^([A-Zie])/){
	  my $Roman=$1;
	  if($LPage ne ""){
	    $LPage="$Roman$LPage";
	  }
	}
	  if($LPage ne ""){
	    $PageText="$FPage–$LPage";
	  }
	}
	$FileText=~s/<pg>((?:(?!<pg>)(?!<\/pg>).)*)<\/pg>/\&lt\;pg\&gt\;$PageText\&lt\;\/pg\&gt\;/os;
      } #end While

    $FileText=~s/<pg>/\&lt\;pg\&gt\;/gs;
    $FileText=~s/<\/pg>/\&lt\;\/pg\&gt\;/gs;

    return $FileText;
  }

#=================================================================================
return 1;
