#version 1.0.4
#Author: Neyaz Ahmad
package ReferenceManager::TexTagManager;
require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(TeXTagReplacement TeX2Tag);
our $VERSION = '1.0.4';

our %TAGS = (
	     'au' => '\refau',
	     'auf' => '\reffn',
	     'aus' => '\refsn',
	     'ed' => '\refed',
	     'eds' => '\refedsn',
	     'edm' => '\refedfn',
	     'par' => '\refpar',
	     'suffix' => '\refsuffix',
	     'prefix' => '\refprefix',
	     'at' => '\refat',
	     'pt' => '\refjt',
	     'misc1' => '\refct',
	     'bt' => '\refbt',
	     'pbl' => '\refpname',
	     'cny' => '\refploc',
	     'pg' => '\refpg',
	     'iss' => '\refissue',
	     'edn' => '\refen',
	     'v' => '\refvol',
	     'yr' => '\refyr',
	     'ia' => '\refia',
	     'doi' => '\refdoi',
	     'collab' => '\refcollab',
	     'rpt' => '\refrpt',
	     'comment' => '\refcomment',
	     'url' => '\refurl',
	    );
#=======================================================================================================================================
sub TeXTagReplacement{
  my $FileText=shift;

  $FileText=~s/<\!\-\-StartFragment\-\-\>//gs;
  $FileText=~s/<\!\-\-EndFragment\-\-\>//gs;
  $FileText=~s/<[\/]?petemp>//gs;
  $FileText=~s/\&lt\;[\/]?petemp\&gt\;//gs;

  $FileText=~s/\&lt\;bib(.*?)\&gt\;/<bib$1>/gs;
  $FileText=~s/\&lt\;\/bib\&gt\;/<\/bib>/gs;
  $FileText=~s/([ ]*)type\=\&quot\;([A-Za-z ]+)\&quot\;//gs;
  $FileText=~s/ \| ([0-9 a-zA-Z\'\)\(]+)\&quot\;/\($1\)\&quot\;/gs;
  $FileText=~s/\&etal\;/et al/gs;
  $FileText=~s/\&amp\;nbsp\;/\~/gs;
  $FileText=~s/\&nbsp\;/\~/gs;
  $FileText=~s/\&\#150\;/\-\-/gs;
  $FileText=~s/&amp;/\\\&/gs;
  $FileText=~s/\\bibitem\[[\s]*\]/\\bibitem\[\]/gs;


  if($FileText=~/\\bibitem\[([^\[\]]*?)\]/)
    {
      my $TeXlabel=$1;
      if($TeXlabel ne ""){
	  $FileText=~s/\\bibitem\[([^\[\]]*?)\]<bib id=\&quot\;([a-zA-Z0-9\_\-\/\:\'\.\\\(\)]+)\&quot\; label=\&quot\;([^<>\"]*?)\&quot\;>/\\bibitem\[$1\]\{$2\}/gs;
	  $FileText=~s/\\bibitem\[([^\[\]]*?)\]<bib id=\"([^<>\"]*?)\">/\\bibitem\[$2\]\{$2\}/gs;
	  $FileText=~s/\\bibitem\[([^\[\]]*?)\]<bib id=\&quot\;([^<>]+?)\&quot\;>/\\bibitem\[$2\]\{$2\}/gs;
	  $FileText=~s/\\bibitem<bib id=\&quot\;([^<>]+?)\&quot\;>/\\bibitem\{$1\}/gs;
	}else{
	  $FileText=~s/\\bibitem\[\]<bib id=\&quot\;([a-zA-Z0-9\_\-\/\'\:\.\\\(\)]+)\&quot\; label=\&quot\;([^<>\"]*?)\&quot\;>/\\bibitem\[$2\]\{$1\}/gs;
	  $FileText=~s/\\bibitem\[\]<bib id=\"([^<>\"]+?)\" label=\"([^<>\"]*?)\">/\\bibitem\[$2\]\{$1\}/gs;
	  $FileText=~s/\\bibitem\[\]<bib id=\&quot\;([^<>]+?)\&quot\;>/\\bibitem\[\]\{$1\}/gs;
	  $FileText=~s/\\bibitem<bib id=\&quot\;([^<>]+?)\&quot\;>/\\bibitem\{$1\}/gs;
	}
      $FileText=~s/<\/bib>/\n/gs;
    }
  else{
    $FileText=~s/\\bibitem<bib id=\&quot\;([a-zA-Z0-9\_\-\/\:\.\'\\\(\)]+)\&quot\;([^<>]*?)>/\\bibitem\{$1\}/gs;
    $FileText=~s/\\bibitem<bib id=\"([^<>\"]*?)\"([^<>]*?)>/\\bibitem\{$1\}/gs;
    #$FileText=~s/\\bibitem<bib id=\&quot\;([a-zA-Z0-9\_\-\:\.]+)\&quot\; label=\&quot\;(.*?)\&quot\;>/\\bibitem\{$1\}/gs;
    $FileText=~s/\\bibitem<bib id=\&quot\;([^<>]+?)\&quot\;>/\\bibitem\{$1\}/gs;
    $FileText=~s/<\/bib>/\n/gs;
  }


# our %TAGS = (
# 	     'au' => '\refau',
# 	     'auf' => '\reffn',
# 	     'aus' => '\refsn',
# 	     'ed' => '\refed',
# 	     'eds' => '\refedsn',
# 	     'edm' => '\refedfn',
# 	     'par' => '\refpar',
# 	     'suffix' => '\refsuffix',
# 	     'prefix' => '\refprefix',
# 	     'at' => '\refat',
# 	     'pt' => '\refjt',
# 	     'misc1' => '\refct',
# 	     'bt' => '\refbt',
# 	     'pbl' => '\refpname',
# 	     'cny' => '\refploc',
# 	     'pg' => '\refpg',
# 	     'iss' => '\refissue',
# 	     'edn' => '\refen',
# 	     'v' => '\refvol',
# 	     'yr' => '\refyr',
# 	     'ia' => '\refia',
# 	     'doi' => '\refdoi',
# 	     'collab' => '\refcollab',
# 	     'rpt' => '\refrpt',
# 	     'comment' => '\refcomment',
# 	     'url' => '\refurl',
# 	    );

  foreach my $xmltag (keys(%TAGS)){
      $FileText=~s/<$xmltag>(.*?)<\/$xmltag>/$TAGS{$xmltag}\{$1\}/gs;
    }

  $FileText=~s/<i>/\{\\it /gs;
  $FileText=~s/<\/i>/\}/gs;
  $FileText=~s/<b>/\{\\bf /gs;
  $FileText=~s/<\/b>/\}/gs;
  $FileText=~s/<u>/\{\\underline /gs;
  $FileText=~s/<\/u>/\}/gs;
  $FileText=~s/<tt>/\\tt\{/gs;
  $FileText=~s/<\/tt>/\}/gs;

  $FileText=~s/<sub>(.*?)<\/sub>/\$\_\{$1\}\$/gs;
  $FileText=~s/<sup>(.*?)<\/sup>/\$\^\{$1\}\$/gs;

  $FileText=~s/<p ([^<>]*?)>//gs;
  $FileText=~s/<p>//gs;
  $FileText=~s/<\/p>//gs;
  $FileText=~s/<[\/]?NS>//gs;
  $FileText=~s/\&lt\;[\/]?NS\&gt\;//gs;

  return  $FileText;
}

sub TeX2Tag{
  my $FileText=shift;
  use ReferenceManager::handleCurlyDoller;
  my  $FileTextRef=\$FileText;

  $FileTextRef=&ReferenceManager::handleCurlyDoller::matchCurly($FileTextRef); #in and out $TeXData refrence
  while(my( $xmltag,  $tex) = each %TAGS){
      $$FileTextRef=~s/\Q$tex\E<cur([0-9]+)>((?:(?!<[\/]?cur\1>).)*?)<\/cur\1>/<$xmltag>$2<\/$xmltag>/gs;
    }
  %FormatingTag=('\it' => 'i', '\bf' => 'b', '\underline' => 'u', '\tt' => 'tt');
  while(my($formTex, $formXmltag) = each %FormatingTag){
    $$FileTextRef=~s/<cur([0-9]+)>\Q$formTex\E ((?:(?!<[\/]?cur\1>).)*?)<\/cur\1>/<$formXmltag>$2<\/$formXmltag>/gs;
    $$FileTextRef=~s/\Q$formTex\E<cur([0-9]+)>((?:(?!<[\/]?cur\1>).)*?)<\/cur\1>/<$formXmltag>$2<\/$formXmltag>/gs;
  }
  {}while($$FileTextRef=~s/\\bibitem<cur([0-9]+)>((?:(?!<[\/]?cur\1>).)*?)<\/cur\1>(.*?)(\n+\\bibitem|\n*\\bibitem|[\n]*$)/\\bibitem<bib id=\&quot\;$2\&quot\;>$3<\/bib>$4/gs);
  {}while($$FileTextRef=~s/\\bibitem\[([^\[\]]*?)\]<cur([0-9]+)>((?:(?!<[\/]?cur\2>).)*?)<\/cur\2>(.*?)(\n+\\bibitem|\n*\\bibitem|[\n]*$)/\\bibitem\[$1\]<bib id=\&quot\;$3\&quot\;>$4<\/bib>$5/gs);

  $$FileTextRef=~s/<cur([0-9]+)>/\{/gs;
  $$FileTextRef=~s/<([\/]?)cur([0-9]+)>/\}/gs;

  return  $$FileTextRef;
}
#=================================================================================
return 1;

