#Version: 0.1
#Author: Neyaz Ahmad
package ReferenceManager::utfEntitiesConv;
use strict;
require Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw(unicodeEntitiesConv);
our $VERSION = '0.1';


sub unicodeEntitiesConv
  {
    my $TextBody=shift;
    my $searEntityElement=shift;
    my $replaceEntityElement=shift;
    my $application=shift;

    my ($sleepCounter, $sleep1, $sleep2)=(0, 0, 0);
    if (defined $application){
      if($application eq "AMPP" || $application eq "ampp"){
	# $sleep1=0.5;
	# $sleep2=0.001;
	$sleep1=0;
	$sleep2=0;
      }
    }

    my $SCRITPATH=$0;

    $SCRITPATH=~s/(.*)([\/\\])(.*?)\.(pl|exe)/$1/g;

    open(ENTITYIN, "<$SCRITPATH/entities.ini")||die("\n\n$SCRITPATH/entities.ini File cannot be opened\n\nPlease check the file...\n\n");
    my  $Entities=<ENTITYIN>;
    my $tempEntities=$Entities;
    close(ENTITYIN);
    my %UnicodeEntites=();
    select(undef, undef, undef, $sleep2);

    if($Entities=~/<Series>([0-9]+)<\/Series>([^\n]*?)<$searEntityElement>([^\n]*?)<\/$searEntityElement>([^\n]*?)<$replaceEntityElement>([^\n]*?)<\/$replaceEntityElement>/)
      {
	#print "$searEntityElement\n$replaceEntityElement";
	while($Entities=~/<Series>([0-9]+)<\/Series>([^\n]*?)<$searEntityElement>([^\n]*?)<\/$searEntityElement>([^\n]*?)<$replaceEntityElement>([^\n]*?)<\/$replaceEntityElement>/s)
	  {
	    my $Series=$1;
	    my $searchEntity=$3;
	    my $replaceEntity=$5;
	    $searchEntity=~s/[\s]//gs;
	    if($searchEntity ne ""){
	      if($replaceEntity ne ""){ 
		$UnicodeEntites{$Series}{$searchEntity}="$replaceEntity";
	      }
	    }
	    $Entities=~s/<Series>([0-9]+)<\/Series>([^\n]*?)<$searEntityElement>([^\n]*?)<\/$searEntityElement>([^\n]*?)<$replaceEntityElement>([^\n]*?)<\/$replaceEntityElement>/<XSeries>$1<\/XSeries>$2<X${searEntityElement}>$3<\/X${searEntityElement}>$4<X${replaceEntityElement}>$5<\/X${replaceEntityElement}>/os;
	    select(undef, undef, undef, $sleep2);
	  }
      }elsif($Entities=~/<Series>([0-9]+)<\/Series>([^\n]*?)<$replaceEntityElement>([^\n]*?)<\/$replaceEntityElement>([^\n]*?)<$searEntityElement>([^\n]*?)<\/$searEntityElement>/){
	while($Entities=~/<Series>([0-9]+)<\/Series>([^\n]*?)<$replaceEntityElement>([^\n]*?)<\/$replaceEntityElement>([^\n]*?)<$searEntityElement>([^\n]*?)<\/$searEntityElement>/s)
	  {
	    my $Series=$1;
	    my $searchEntity=$5;
	    my $replaceEntity=$3;
	    $searchEntity=~s/[\s]//gs;
	    if($searchEntity ne ""){
	      if($replaceEntity ne ""){ 
		$UnicodeEntites{$Series}{$searchEntity}="$replaceEntity";
	      }
	    }
	    $Entities=~s/<Series>([0-9]+)<\/Series>([^\n]*?)<$replaceEntityElement>([^\n]*?)<\/$replaceEntityElement>([^\n]*?)<$searEntityElement>([^\n]*?)<\/$searEntityElement>/<XSeries>$1<\/XSeries>$2<X${replaceEntityElement}>$3<\/X${replaceEntityElement}>$4<X${searEntityElement}>$5<\/X${searEntityElement}>/os;
	    select(undef, undef, undef, $sleep2);
	  }
      }else{
	print "Please check entities.ini\n";
      }

    foreach my $Series (sort(keys(%UnicodeEntites)))
      {
	my $SeriesUnicodeEntites=$UnicodeEntites{$Series};
	foreach my $UnicodeKey (keys(%$SeriesUnicodeEntites)){
	    #print "$UnicodeKey=> $$SeriesUnicodeEntites{$UnicodeKey}\n";
	    if($UnicodeKey!~/^(fi| )$/){
		$TextBody=~s/\Q$UnicodeKey\E/$$SeriesUnicodeEntites{$UnicodeKey}/gs;
	      }
	  }
	select(undef, undef, undef, $sleep2);
      }


    $TextBody=&ControlEntities($TextBody);

    # open(ENTITYIN, ">$SCRITPATH/entities.ini")||die("\n\n$SCRITPATH/entities.ini File cannot be opened\n\nPlease check the file...\n\n");
    # print  ENTITYIN $tempEntities;
    # print  ENTITYIN $TextBody;
    # close(ENTITYIN);
    select(undef, undef, undef, 0.01);
    return $TextBody;
  }

#=======================================================================================================================================

sub ControlEntities{

  my $TextBody=shift;

    my %commonDubEnt=(
	'&#128;' => '&#8364;',
	'&#130;' => '&#8218;',
	'&#131;' => '&#402;',
	'&#132;' => '&#8222;',
	'&#133;' => '&#8230;',
	'&#134;' => '&#8224;',
	'&#135;' => '&#8225;',
	'&#136;' => '&#710;',
	'&#137;' => '&#8240;',
	'&#138;' => '&#352;',
	'&#139;' => '&#8249;',
	'&#140;' => '&#338;',
	'&#142;' => '&#381;',
	'&#145;' => '&#8216;',
	'&#146;' => '&#8217;',
	'&#147;' => '&#8220;',
	'&#148;' => '&#8221;',
	'&#149;' => '&#8226;',
	'&#150;' => '&#8211;',
	'&#151;' => '&#8212;',
	'&#152;' => '&#732;',
	'&#153;' => '&#8482;',
	'&#155;' => '&#8250;',
	'&#156;' => '&#339;'
		     );

     foreach my $Keyes(keys %commonDubEnt)
       {
	 $TextBody=~s/$Keyes/$commonDubEnt{$Keyes}/gs;
	 #print "KEY: $Keyes=> $commonDubEnt{$Keyes}";
       }

  $TextBody=~s/<\!\&\#8211\;\s+/<\!--/gs;
  $TextBody=~s/\&\#8211\;>/-->/gs;
  # print  "XX: $TextBody\n";

  return $TextBody;
}

#=======================================================================================================================================


return 1;