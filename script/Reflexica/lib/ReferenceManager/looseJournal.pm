#version 1.0
package ReferenceManager::looseJournal;
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(looseJournalMark validateWithIni);


BEGIN{
  $SCRITPATH=$0;
  $SCRITPATH=~s/(.*)([\/\\])(.*?)\.(pl|exe)/$1/g;
}
use strict;
sub looseJournalMark{
  my $TextBody=shift;
    use ReferenceManager::ReferenceRegex;
    my %regx = ReferenceManager::ReferenceRegex::new();


   #<i>Neurotoxicol. Teratol</i>. <b><yr>2002</yr></b>, <i><v>
  $TextBody=~s/ <i>([^<>\_0-9]+?)<\/i>([\p{P} ]+)(<i>[ ]?|<b>[ ]?)?<yr>([^<>]+?)<\/yr>(<\/i>|<\/b>)?([\.\,\; ]+)(<i>|<b>)?(<v>|<iss>)/ <pt><i>$1<\/i><\/pt>$2$3<yr>$4<\/yr>$5$6$7$8/gs;

  $TextBody=~s/ <i>([^<>\_0-9]+?)<\/i>([\p{P} ]+)(<i>[ ]?|<b>[ ]?)?<v>/ <pt><i>$1<\/i><\/pt>$2$3<v>/gs;
  $TextBody=~s/ <i>([^<>\_0-9]+?)<\/i>([\p{P} ]+)(<i>|<b>)?([\.\, ]+[vV][Oo][Ll][\.\: ]+)<v>/ <pt><i>$1<\/i><\/pt>$2$3$4<v>/gs;
  $TextBody=~s/ <i>([^<>\_0-9]+?)<\/i>([\p{P} ]+)(<i>|<b>)?([\.\, ])$regx{volumePrefix}([\.\: ]+)<v>((?:(?!<[\/]?cny>)(?!<[\/]?pbl>)(?!<[\/]?pbl>).)*?)<\/bib>/ <pt><i>$1<\/i><\/pt>$2$3$4$5$6<v>$7<\/bib>/gs;


  $TextBody=~s/ <i>([^<>\_0-9]+?)<\/i>([\p{P} ]+)(<i>|<b>)?([\.\, ]+<yr>[0-9]+[a-z]?<\/yr>)([\.\,\; ]+[vV]ol[\:\. ]+)<v>/ <pt><i>$1<\/i><\/pt>$2$3$4$5<v>/gs;
  $TextBody=~s/ <i>([^<>\_0-9]+?)<\/i>([\p{P} ]+)(<i>|<b>)?([\.\, ]+<yr>[0-9]+[a-z]?<\/yr>)([\.\,\; ]+)<v>/ <pt><i>$1<\/i><\/pt>$2$3$4$5<v>/gs;
  $TextBody=~s/ <i>([^<>\_0-9]+?)<\/i>([\p{P} ]+)(<i>|<b>)?([\.\, ]+)$regx{monthPrefix}([\.\,\; ]+)<v>/ <pt><i>$1<\/i><\/pt>$2$3$4$5$6<v>/gs;


  my $editorSuffix='\b[eE]ditor[s]?[\.]?|[Hh]erausgeber[\.]?|\b[Ee]d[s]\b?[\.]?|\b[Hh]rsg\b[\.]?|\b[Hh]g\b\.|\bred\.?';
  $TextBody=~s/ ([iI]n[\.\:]) ((?:(?!<\/bib>)(?!<yr>)(?!<bt>)(?!<pt>)(?!<edrg>)(?!$editorSuffix)(?!<bib[^<>]*?>).)*?)([\.\,\;\? ]+)$regx{volumePrefix}([\s\.\,]+)<v>/ $1 <pt>$2<\/pt>$3$4$5<v>/gs;
  $TextBody=~s/ ([iI]n[\.\:]) ((?:(?!<\/bib>)(?!<yr>)(?!<bt>)(?!<pt>)(?!<edrg>)(?!$editorSuffix)(?!<bib[^<>]*?>).)*?)([\.\,\;\? ]+)(Nr[\.]?)([\s\.\,]+)<v>/ $1 <pt>$2<\/pt>$3$4$5<v>/gs;
  $TextBody=~s/ ([iI]n[\.\:]) ((?:(?!<\/bib>)(?!<yr>)(?!<bt>)(?!<pt>)(?!<edrg>)(?!$editorSuffix)(?!<bib[^<>]*?>).)*?)([\.\,\;\? ]+)\(<iss>$regx{issue}<\/iss>\) <v>/ $1 <pt>$2<\/pt>$3\(<iss>$4<\/iss>\) <v>/gs;

  #. In: Perioperative Medizin</at>. <pt>Vol</pt>. <v>
  $TextBody=~s/([\.\,\?\!]|�||[�]+|”|“||’) ([Ii]n[\:\.]) ((\p{Ll}?\p{Lu}\p{Ll}*[ Ã¤ÃÄÄ\(\)\-iofand\&]*)*)([\.\, ]+)$regx{volumePrefix}([\s\.\,]+)<v>/$1 $2 <pt>$3<\/pt>$4$5$6<v>/g;

  $TextBody=~s/([\.\,\?\!]|�||”|“||’|\\newblock) ((\p{Ll}?\p{Lu}\p{Ll}*[ Ã¤ÃÄÄ\-iofand\&]*)*)([\.\,]?) $regx{volumePrefix}([\s\.\,]+)<v>/$1 <pt>$2<\/pt>$4 $5$6<v>/g;
  $TextBody=~s/([\.\,\?\!]|�||[�]+|”|“||’\\newblock) ((\p{Ll}?\p{Lu}\p{Ll}*[ Ã¤ÃÄÄ\(\)\-iofand\&]*)*)([\.\,]?)$regx{volumePrefix}([\s\.\,]+)<v>/$1 <pt>$2<\/pt>$4$5$6<v>/g;

  $TextBody=~s/\\(textit|it)\{([^\}\{<>]*?)\}([\.\, ]+)$regx{volumePrefix}([\s\.\,]+)<v>/<pt><i>$2<\/i><\/pt>$3$4$5<v>/g;

  $TextBody=~s/([\.\,\?\!]|�||[�]+|”|“||’|\\newblock) ([^\.\,<>]*?)([\.\,]) $regx{volumePrefix}([\s\.\,]+)<v>/$1 <pt>$2<\/pt>$3 $4$5<v>/g;
  $TextBody=~s/([\.\,\?\!]|�||[�]+|”|“||’|\\newblock) ([^\.\,<>]*?)([\.\,]) <b>$regx{volumePrefix}([\s\.\,]+)<v>/$1 <pt>$2<\/pt>$3 <b>$4$5<v>/g;
  $TextBody=~s/<pt><\/pt>//gs;
  $TextBody=~s/([\.\,\?\!]|�||[�]+|”|“||’|\\newblock) ([^\.\,<>]*?)([\.\,]) $regx{volumePrefix}([\s\.\,]+)<v>/$1 <pt>$2<\/pt>$3 $4$5<v>/g;
  $TextBody=~s/([\.\,\?\!]|�||[�]+|”|“||’|\\newblock) ([^\.\,<>]*?)([\.\,]) <b>$regx{volumePrefix}([\s\.\,]+)<v>/$1 <pt>$2<\/pt>$3 $4$5<v>/g;

  #American Academy of Sleep Medicine
  $TextBody=~s/ ([a-z]+) <pt>([^<>]+?)<\/pt>([\.\:\;\, ]+)<yr>([^<>]+?)<\/yr>([\.]?)<\/bib>/ $1 $2$3<yr>$4<\/yr>$5<\/bib>/gs;

  $TextBody=~s/([\.\,\;\?\!]|�||[�]+|”|“||’|\\newblock|[\,\.] [Ii]n[\:\.]|\]|<\/yr>[\.\,]?) $regx{journalKeyWords} ((?:(?!<[\/]?pt>)(?!<[\/]?[a-z]+>)(?![\?0-9]+)(?!<[\/]?bib>).)*?)([\.\,]?) ([\(]?)<(yr|iss|v|doig|doi)>/$1 <pt>$2 $3<\/pt>$4 $5<$6>/gs;


#  $TextBody=~s/([\.\,\;\?\!]|�||[�]+|”|“||’|\\newblock|[\,\.] [Ii]n[\:\.]|\]|<\/yr>[\.\,]?) $regx{journalKeyWords} ((?:(?!<[\/]?pt>)(?!<[\/]?[a-z]+>)(?![\?0-9]+)(?!<[\/]?bib>).)*?)([\.\,]?) $regx{monthVolumePrefix} <(yr|iss|v|doig|doi)>/$1 <pt>$2 $3<\/pt>$4 $5 <$6>/gs;

  #</yr> J Biol Chem. <v>
  $TextBody=~s/([\.\,\;\?\!]|�||[�]+|”|“||’|\\newblock|[\,\.] [Ii]n[\:\.]|\]) Journal([\.\,]?) ([\(]?)<(yr|iss|v|doig|doi)>/$1 <pt>Journal<\/pt>$2 $3<$4>/gs;

  # Computational Intelligence and AI in Games
  $TextBody=~s/([\.\,\?\!]|�||[�]+|”|“||’|\\newblock) (European|American|The|J|J\.) ((?:(?!<[\/]?pt>)(?!<[\/]?[a-z]+>)(?![0-9\:\,\;\(\)\[\]\.]+?)(?!<[\/]?bib>).)*?)([\.\,]?) <(v|doig|doi)>/$1 <pt>$2 $3<\/pt>$4 <$5>/gs;


  $TextBody=~s/ ([A-Za-z]+) in <pt>([A-Za-z]+)<\/pt>\. / $1 in $2\. /gs;


  $TextBody=~s/([\.\,\?\!]|�||[�]+|”|“||’|\\newblock) ((\p{Ll}?\p{Lu}\p{Ll}*[ Ã¤ÃÄÄ\(\)\-iofn\&]*)*)([\.\,]?) <v>/$1 <pt>$2<\/pt>$4 <v>/g;

  $TextBody=~s/([\.\,\?\!]|�||[�]+|”|“||’|\\newblock) (\p{Lu}\p{Ll}+ \p{Lu}\p{Ll}+ \p{Lu})([\.\,]?) <v>/$1 <pt>$2<\/pt>$3 <v>/g;

  $TextBody=~s/([\.\,\?\!]|\\newblock) (\p{Lu}\p{Ll}+) \((\w+)\)([\.\,]?) <v>/$1 <pt>$2 \($3\)<\/pt>$4 <v>/g;


  #1997; 69
  $TextBody=~s/([\.\,\?\!]|�||[�]+|”|“||’|\\newblock) ((\p{Ll}?\p{Lu}\p{Ll}*[\(\)\- iofn\&]*)*)([\.\,]?) $regx{monthPrefix} <yr>$regx{year}<\/yr>([\.\,\; ]+)<v>/$1 <pt>$2<\/pt>$4 $5 <yr>$6<\/yr>$7<v>/g;
  $TextBody=~s/([\.\,\?\!]|�||[�]+|”|“||’|\\newblock|\W) ((\p{Ll}?\p{Lu}\p{Ll}*[\(\)\- iofn\&]*)*)([\.\,]?) <yr>(\d{4}[a-z]?)<\/yr>([\.\,\; ]+)<v>/$1 <pt>$2<\/pt>$4 <yr>$5<\/yr>$6<v>/g;

  $TextBody=~s/([\.\,\?\!]|�||[�]+|”|“||’|\\newblock) ([A-Z][a-z]+ ([a-z]+[ ]?)*)([\.\,]?) $regx{monthPrefix} <yr>(\d{4}[a-z]?)<\/yr>([\.\,\; ]+)<v>/$1 <pt>$2<\/pt>$4 $5 <yr>$6<\/yr>$7<v>/g;
  $TextBody=~s/([\.\,\?\!]|�||[�]+|”|“||’|\\newblock) ([A-Z][a-z]+ ([a-z]+[ ]?)*)([\.\,]?) <yr>(\d{4}[a-z]?)<\/yr>([\.\,\; ]+)<v>/$1 <pt>$2<\/pt>$4 <yr>$5<\/yr>$6<v>/g;
  $TextBody=~s/([\.\,\?\!]|�||[�]+|”|“||’|\\newblock) ([A-Z][a-z]+ ([a-z]+[ ]?)*)([\.\,]?) <v>/$1 <pt>$2<\/pt>$4 <v>/g;

  $TextBody=~s/<pt>$regx{monthPrefix}<\/pt>([\.\, ]+)<yr>/$1$2<yr>/gs;

  $TextBody=~s/( [Ii]n[:\. ]+)([^<>]+?)([\.\:\,\;\( ]+)$regx{editorSuffix}([\.\,\)\:]+)([^<>]+?)<pt>([^<>]+?)<\/pt>([\.\,\:\; ]+)$regx{volumePrefix}/$1$2$3$4$5$6$7$8$9/gs;


  $TextBody=~s/([\.\,\?\!]|�||”|“||’|\\newblock) ([A-Z][a-z]*?\. [A-Z][a-z]*?\. [A-Z][a-z]*?\. [A-Z][a-z]*?\.) <pt>((?:(?!<[\/]?pt>)(?!<[\/]?it>)(?!<[\/]?bib>).)*)<\/pt>/$1 <pt>$2 $3<\/pt>/gs;
  $TextBody=~s/([\.\,\?\!]|�||”|“||’|\\newblock) ([A-Z][a-z]*?\. [A-Z][a-z]+?\. [A-Z][a-z]*?\.) <pt>((?:(?!<[\/]?pt>)(?!<[\/]?it>)(?!<[\/]?bib>).)*)<\/pt>/$1 <pt>$2 $3<\/pt>/gs;


  $TextBody=~s/([\.\,\;\?\!]|�||[�]+|”|“||’|\\newblock|[\,\.] [Ii]n[\:\.]|\]|<\/yr>[\.\,]?) $regx{journalKeyWordsWithJ} <pt>((?:(?!<[\/]?pt>)(?!<[\/]?i[t]?>)(?!<[\/]?bib>).)*)<\/pt>/$1 <pt>$2 $3<\/pt>/gs;


  #. The Journal of the North Carolina Academy of <pt>Science</pt>
  $TextBody=~s/([\.\,\;\?\!]|�||[�]+|”|“||’|\\newblock|[\,\.] [Ii]n[\:\.]|\]) $regx{journalKeyWords} ([^<>]+?) <pt>((?:(?!<[\/]?pt>)(?!<[\/]?i[t]?>)(?!<[\/]?bib>).)*)<\/pt>/$1 <pt>$2 $3 $4<\/pt>/gs;
  $TextBody=~s/<i>$regx{journalKeyWords} ([^<>]+?)<\/i>([\.\, ]+)<(doig|v|yr)>/<pt><i>$1 $2<\/i><\/pt>$3<$4>/gs;

  $TextBody=~s/<pt>([^<>]+?)<\/pt>\: ([^<>]+?)([\.\,]? )<(doig|v|yr)>/<pt>$1\: $2<\/pt>$3<$4>/gs;


 while($TextBody=~s/<comment>((?:(?!<[\/]?comment>)(?!<bib)(?!<\/bib>).)+?)<(pt|cny|pbl)>([^<>]*?)<\/\2>((?:(?!<[\/]?comment>)(?!<bib)(?!<\/bib>).)*?)<\/comment>/<comment>$1$3$4<\/comment>/gs){}


  #. Regulated Rivers Research and <pt>Management</pt>
  $TextBody=~s/([\.\,\;\?\!]|�||[�]+|”|“||’|\\newblock|[\,\.] [Ii]n[\:\.]|\]) ([^<>\.\,\;\:\?\!]+) ([a-z]+) <pt>([^<>]+?)<\/pt>/$1 <pt>$2 $3 <merge>$4<\/pt>/gs;
  $TextBody=~s/<pt>\($regx{year}\)([\.\:]? )([^<>]+?) <merge>([^<>]+?)<\/pt>/\($1\)$2$3 <pt>$4<\/pt>/gs;
  $TextBody=~s/<pt>([^<>]+?)\($regx{year}\)([\.\:]? )([^<>]+?) <merge>([^<>]+?)<\/pt>/$1\($2\)$3$4 <pt>$5<\/pt>/gs;
  $TextBody=~s/(<\/yr>[\. ]+|<\/aug>[\. ]+|[\w\d]\, )<pt>([a-z0-9]+ [^<>]+?)<merge>([^<>]+?)<\/pt>/$1$2<pt>$3<\/pt>/gs;
  $TextBody=~s/(<\/yr>[\. ]+|<\/aug>[\. ]+|[\w\d]\, )<pt>([^<>]+? [a-z][a-z0-9]+)<merge>([^<>]+?)<\/pt>/$1$2<pt>$3<\/pt>/gs;

  $TextBody=~s/<pt>([^<>]+? [a-z]+ [a-z]+ )<merge>([^<>]+?)<\/pt>/$1<pt>$2<\/pt>/gs;
  $TextBody=~s/<merge>//gs;
  $TextBody=~s/<pt>(J[\.]?|European|American) <i>/$1 <pt><i>/gs;
  $TextBody=~s/<pt>([\s]*)<\/pt>//gs;
  $TextBody=~s/  / /gs;
  $TextBody=~s/<\/pt>([\.\,\?\: ]*)<pt>([Vv]ol[\.]?|[J]g[\.]?|Nr[\.]|[Vv]olume[\.]?)<\/pt>/<\/pt>$1$2/gs;
  $TextBody=~s/<\/pt>([\.\,\?\: ]*)<pt>([A-Z][\.]?|[J]g)<\/pt>/<\/pt>$1$2/gs;
  $TextBody=~s/<\/pt>([\.\,\?\: ]*)<pt>/$1/gs;
  $TextBody=~s/<pt>([Vv]ol[\.]?|[Jj]g[\.]?|Nr[\.]?|[Vv]olume[\.]?)<\/pt>([\.\, ]+)<v>/$1$2<v>/gs;
  $TextBody=~s/([\.\, ]+)([Vv]ol[\.]?|[Jj]g[\.]?|Nr[\.]?|[Vv]olume[\.]?)<\/pt>([\.\, ]+)/<\/pt>$1$2$3/gs;
  $TextBody=~s/<pt>$regx{issuePrefix}<\/pt>/$1/gs;
  $TextBody=~s/<pt>$regx{volumePrefix}<\/pt>/$1/gs;
  $TextBody=~s/<pt>$regx{pagePrefix}<\/pt>/$1/gs;
  $TextBody=~s/([\.\,\; ]+)$regx{issuePrefix}<\/p>/<\/p>$1$2/gs;
  $TextBody=~s/([\.\,\; ]+)$regx{volumePrefix}<\/p>/<\/p>$1$2/gs;
  $TextBody=~s/([\.\,\; ]+)$regx{pagePrefix}<\/p>/<\/p>$1$2/gs;

  $TextBody=~s/([a-zA-Z])<\/pt> ([\w\-\s]+)\, ([Vv]ol[\.]?|[Jj]g[\.]?|[Vv]olume[\.]?)/$1 $2<\/pt>\, $3/gs;

  $TextBody=~s/<pt>((?:(?!<[\/]?pt>)(?!<\/bib>)(?!<bib([^<>]*?)>).)*)<\/pt> ((?:(?!<\/bib>)(?!<bib([^<>]*?)>).)*) <pt>((?:(?!<pt>)(?!<\/pt>)(?!<\/bib>)(?!<bib([^<>]*?)>).)*)<\/pt>/$1 $3 <pt>$5<\/pt>/gs; #check and confirm

  $TextBody=~s/<pt><pt>((?:(?!<[\/]?pt>)(?!<bib)(?!<\/bib>).)*)<\/pt><\/pt>/<pt>$1<\/pt>/gs;
  $TextBody=~s/<\/i><\/pt>\.\,/\.<\/i><\/pt>\,/gs;
  $TextBody=~s/<\/pt>\.([\,\;\:])/\.<\/pt>$1/gs;

  $TextBody=~s/([A-Z][a-z]*?)\. ([A-Z][a-z]+)<\/i><\/pt>\. /$1\. $2\.<\/i><\/pt> /gs;
  $TextBody=~s/([A-Z][a-z]*?)\. ([A-Z][a-z]+) ([A-Z][a-z]+)<\/i><\/pt>\. /$1\. $2 $3\.<\/i><\/pt> /gs;
  $TextBody=~s/([A-Z][a-z]*?)\. ([A-Z][a-z]+)<\/pt>\. /$1\. $2\.<\/pt> /gs;
  $TextBody=~s/([A-Z][a-z]*?)\. ([A-Z][a-z]+) ([A-Z][a-z]+)<\/pt>\. /$1\. $2 $3\.<\/pt> /gs;
  $TextBody=~s/<pt>([^<>]*?) \[([^<>\[\]]+?)\]<\/pt>/<pt>$1<\/pt> \[$2\]/gs;

  $TextBody=~s/ ([Ii]n[\.\,]?) <pt><i>([^<>]+?)<\/i><\/pt>([\.\,\;\?\( ]+)$regx{editorSuffix}([.\)])/ $1 <i>$2<\/i>$3$4$5/gs;
  $TextBody=~s/ ([Ii]n[\.\,]?) <pt>([^<>]+?)<\/pt>([\.\,\;\?\( ]+)$regx{editorSuffix}([.\)])/ $1 $2$3$4$5/gs;
  $TextBody=~s/<pt>((?:(?!<[\/]?bib>)(?!<[\/]?pt>).)*?)<\/pt>([^<>]+?) $regx{editorSuffix}([\.\:\,\;])/$1$2 $3$4/gs; 

   return $TextBody;
}
#=============================================================================================================================================
sub validateWithIni{
  my $TextBody=shift;
  my $monthPrefix='([Jj]an|[Ff]eb|[Mm]ar|[Aa]pr|[Mm]ay|[Jj]un|[Jj]ul|[Aa]ug|[Ss]ep[t]?|[Oo]ct|[Nn]ov|[Dd]ec|[Jj]anuary|[Ff]ebruary|[Mm]arch|[Aa]pril|[Mm]ay|[Jj]une|[Jj]uly|[Aa]ugust|[Ss]eptember|[Oo]ctober|[Nn]ovember|[Dd]ecember|[Ww]inter|[Ss]ummer|[Ss]pring|Januar|Februar|Mﾃ､rz|Mai|Juni|Juli|Oktober|Dezember)';

  #<pt>Semin. <pt>Cell Dev. Biol</pt>.</pt>
  $TextBody=~s/<\/i>([\.\,\; ]+)$monthPrefix<\/pt>/<\/i><\/pt>$1$2/gs;
  $TextBody=~s/<pt>((?:(?!<[\/]?pt>)(?!<[\/]?bib>).)*)<pt>((?:(?!<[\/]?pt>)(?!<[\/]?bib>).)*)<\/pt>([\.\,\?]?)<\/pt>/<pt>$1 $2<\/pt>$3/gs;
  $TextBody=~s/<pt>((?:(?!<[\/]?pt>)(?!<[\/]?bib>).)*)<pt>((?:(?!<[\/]?pt>)(?!<[\/]?bib>).)*)<\/pt><\/pt>/<pt>$1 $2<\/pt>/gs;
  $TextBody=~s/<pt><pt>((?:(?!<\/pt>)(?!<bib)(?!<\/bib>)(?!<pt>).)*)<\/pt><\/pt>/<pt>$1<\/pt>/gs;
  $TextBody=~s/<pt><pt>((?:(?!<\/pt>)(?!<bib)(?!<\/bib>)(?!<pt>).)*)<\/pt>([\.\,\?]?)<\/pt>/<pt>$1<\/pt>$2/gs;
  $TextBody=~s/([\.\,]) $monthPrefix<\/pt>/<\/pt>$1 $2/gs;
  $TextBody=~s/ $monthPrefix(<\/i>)?<\/pt>/$2<\/pt> $1/gs;
  #<pt>Evidence-based medicine</pt>: What it is and what it isn t (Editorial). <pt>British Medical Journal</pt>
  $TextBody=~s/<pt>((?:(?!<[\/]?pt>)(?!<[\/]?bib>).)+?)<\/pt>([\.\:\,]) ((?:(?!<[\/]?pt>)(?!<[\/]?bib>).)+?)([\.\,\?]) <pt>((?:(?!<[\/]?pt>)(?!<[\/]?bib>).)+?)<\/pt>/$1$2 $3$4 <pt>$5<\/pt>/gs;
  # , VOL</pt>. <v>
  $TextBody=~s/([\,\.\; ]+)([Vv]olume[s]?[\.]?|[Vv]ol[s]?[\.]?|VOL[\.]?|[Jj]g[\.]?|Bd[\.]?|[vV]\.|H\.)<\/pt>([\,\.\:\; ]+)<v>/<\/pt>$1$2$3<v>/gs;
  $TextBody=~s/ <\/pt>/<\/pt> /gs;
  $TextBody=~s/<bib([^<>]+?)>([\w]+)\, <pt>([\w]+)<\/pt>/<bib$1>$2\, $3/gs;

 return $TextBody;
}
return 1;