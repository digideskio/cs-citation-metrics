#version 1.0
#Author: Neyaz Ahmad
package ReferenceManager::Cleanup;
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(preCleanup);
# use utf8; # Enable typing Unicode in Perl strings
# use open qw(:std :utf8); # Enable Unicode to STDIN/OUT/ERR and filehandles

#===============================================================================================
sub preCleanup{
  my $TextBody=shift;
  my $application=shift;

  use ReferenceManager::ReferenceRegex;
  my %regx = ReferenceManager::ReferenceRegex::new();


  $$TextBody=~s/<bib([^<>]+?)>﻿/<bib$1>/;
  $$TextBody=~s/<[\/]?ins>//gs;
  $$TextBody=~s/(\.|\;|\,|\:)\,/$1 \,/gs;
  $$TextBody=~s/  / /gs;
  $$TextBody=~s/<b><\/b> <b>/ <b>/gs;
  $$TextBody=~s/<bib([^<>]*?)> <b>/<bib$1><b>/gs;
  while($$TextBody=~/<bib([^<>]*?)><b>([^<>]+)<\/b>([\.\,\;\: ]*?)<b>([^<>]*?)<\/b>/s)
    {
      $$TextBody=~s/<bib([^<>]*?)><b>([^<>]+)<\/b>([\.\,\;\: ]*?)<b>([^<>]*?)<\/b>/<bib$1><b>$2$3$4<\/b>/s;
    }
  $$TextBody=~s/<bib([^<>]*?)><b>([^<>]+)<\/b>/<bib$1>$2/s;
  $$TextBody=~s/([\w]+) \&amp\; ([\w]+)/$1 \& $2/gs;
  $$TextBody=~s/([\w]+) \&amp\;amp\; ([\w]+)/$1 \& $2/gs;
  $$TextBody=~s/([0-9]+)\&amp\;([0-9a-z]+)/$1&$2/gs;

  $$TextBody=~s/<a ([^<>]*?)>//gs;
  $$TextBody=~s/<\/a>//gs;
  $$TextBody=~s/<strong>//gs;
  $$TextBody=~s/<\/strong>//gs;
  $$TextBody=~s/\&lt\;(i|b|u)(sup|sub)\&gt\;([^ ]+?)\&lt\;\/\1\2\&gt\;/<$1><$2>$3<\/$2><\/$1>/gs;

  $$TextBody=~s/<span([\s]+)lang=([A-Z\-]+)>((?:(?!<span[^<>]*?>)(?!<\/span>).)*?)<\/span>/$3/gs;
  $$TextBody=~s/<span([\s]+)style\=\'([^\'<>]*?)\'>((?:(?!<span[^<>]*?>)(?!<\/span>).)*?)<\/span>/$3/gs;
  $$TextBody=~s/<span([\s]+)lang=([A-Z\-]+)([\s]+)style\=\'([^\'<>]*?)\'>((?:(?!<span[^<>]*?>)(?!<\/span>).)*?)<\/span>/$5/gs;
  $$TextBody=~s/([\.\,\?\!]) ([0-9]+)([\.]*)\&nbsp\;(edn|edn\.|ed|Aufl|Aufl\.|Bd|Bd\.|Auflage)([\, ])/$1 $2$3 $4$5/gs;
  $$TextBody=~s/([\.\,\?\!]) ([0-9]+)(st|rd|nd|th)\&nbsp\;(edn|edn\.|ed|Aufl|Aufl\.|Bd|Bd\.|Auflage)([\, ])/$1 $2$3 $4$5/gs;
  $$TextBody=~s/ (pp|p|pp\.|p\.|S|S\.|Vol\.|Vol|vol\.|vol|Bd\.|Bd|Aufl|Aufl\.|Auflage)\&nbsp\;([\(0-9\-ivxIVXSRC]+)/ $1 $2/gs;
  $$TextBody=~s/<span([^<>]*?)>//gs;
  $$TextBody=~s/<\/span>//gs;
  $$TextBody=~s/<i>([\.\,\:\;]*) /$1 <i>/gs;
  $$TextBody=~s/([\.\,\:\;]*)<\/i> /<\/i>$1 /gs;
  $$TextBody=~s/([\.\,\:\;]*)([\s]+)<\/i>/<\/i>$1 /gs;
  $$TextBody=~s/ <\/i> /<\/i> /gs;
  $$TextBody=~s/<i> / <i>/gs;
  $$TextBody=~s/<\/i> <i>/ /gs;
  $$TextBody=~s/([\s]*)<\/p>/<\/p>/gs;
  $$TextBody=~s/a\.\&#8197;M\./a\. M\./gs;
  $$TextBody=~s/ (S[\.]?|[Pp]+[\.]?)\&\#8197\;/ $1 /gs;

  $$TextBody=~s/\. ([A-Za-z ßÉéèÃ¡Ã…â€™Ã¦Ã³Ã±Ã˜Ã¤Ã§Ã®Ã¨ÃŸÃ¼Ã¶Ã©Ã¥Ã\&¸`’–\-Ã‡Ã–\sÎ²\(\)\[\]\/–°´&\;]+) ([0-9][0-9][0-9][0-9]|[0-9][0-9][0-9][0-9a-zA-Z]+)\; ([–\-0-9]+)\:([–\-0-9]+)/\. $1 $2\;$3\:$4/gs;

  $$TextBody=~s/\. ([A-Za-z ßÉéèÃ¡Ã…â€™Ã¦Ã³Ã±Ã˜Ã¤Ã§Ã®Ã¨ÃŸÃ¼Ã¶Ã©Ã¥Ã\&¸`’–\-Ã‡Ã–\sÎ²\(\)\[\]\/–°´&\;]+) ([0-9][0-9][0-9][0-9])\:([–\-0-9]+)\;([–\-0-9]+)/\. $1 $2\;$3\:$4/gs;


  $$TextBody=~s/<bib([^<>]*?)>([\s]+)/<bib$1>/gs;
  $$TextBody=~s/<([^<>]*?)>\&nbsp\;<\/([^<>]*?)>/<$1> <\/$2>/gs;
  $$TextBody=~s/([\s]+)<\/bib>/<\/bib>/gs;
  $$TextBody=~s/<Xbib/<bib/gs;
  $$TextBody=~s/<\/Xbib>/<\/bib>/gs;
  $$TextBody=~s/<b>\. <\/b>/. /gs;
  $$TextBody=~s/\, \,([\s]+)/\, /gs;
  $$TextBody=~s/\,\,([\s]+)/\, /gs;

  $$TextBody=~s/<i>([^<>]*?)\,([\s]*)([0-9]+)\,<\/i>([0-9\-]+)/<i>$1<\/i>\, <i>$3<\/i>\, $4/gs;
  $$TextBody=~s/<i>([^<>]*?)\,([\s]*)([0-9]+)\,<\/i>\(([0-9\-]+)/<i>$1<\/i>\, <i>$3<\/i>\,\($4/gs;
  $$TextBody=~s/<i>([^<>]*?)\,([\s]*)([0-9]+)<\/i>\,([0-9\-]+)/<i>$1<\/i>\, <i>$3<\/i>\, $4/gs;
  $$TextBody=~s/<i>([^<>]*?)\,([\s]*)([0-9]+)<\/i>([0-9\-]+)/<i>$1<\/i>\, <i>$3<\/i> $4/gs;
  $$TextBody=~s/<i>([^<>]*?)\,([\s]*)([0-9]+)<\/i>/<i>$1<\/i>\, <i>$3<\/i>/gs;
  $$TextBody=~s/<i>([^<>]*?)\,([\s]*)([0-9]+)\,<\/i>/<i>$1<\/i>\, <i>$3<\/i>\,/gs;
  $$TextBody=~s/<i>([^<>]*?)\,([\s]*)([0-9]+)<\/i>\,([0-9]+)/<i>$1<\/i>\, <i>$3<\/i>\, $4/gs;
  $$TextBody=~s/<i>([^<>]*?)\,([\s]*)([0-9]+)\(<\/i>/<i>$1\, $3<\/i>\(/gs;
  $$TextBody=~s/\, ([A-Z\.\-]+)\(([0-9][0-9][0-9][0-9])\)/\, $1 \($2\)/gs;

  $$TextBody=~s/\. ([A-Z])<i>([a-z]+)/\. <i>$1$2/gs;
  $$TextBody=~s/<i>([^<>]*?)<\/i>\,([\s]*)<i>([0-9]+)<\/i> \(([0-9A-Z\/\, ]+)\)\,/<i>$1<\/i>\, <i>$3<\/i>\($4\)\,/gs; 
  $$TextBody=~s/\)\, ([0-9]+)([\s]*)([\-])([\s]*)([0-9]+)\./\)\, $1$3$5\./gs;
  $$TextBody=~s/ \(([0-9][0-9][0-9][0-9])\)([A-Z][a-z]+)/ \($1\) $2/gs;
  $$TextBody=~s/([\s]*)\(pp\. ([0-9\-]+)\)\./ \(pp\. $2\)\./gs;
  $$TextBody=~s/<bib([^a<>]*?)>([A-Za-z\-]+)([\,]*) ([A-Z\.\-])\(([0-9][0-9][0-9][0-9])\)/<bib$1>$2$3 $4 \($5\)/gs;
  $$TextBody=~s/<\/i> ([0-9]+)\, ([0-9]+)\-[\s]*([0-9]+)\.<\/bib>/<\/i> $1\, $2\-$3\.<\/bib>/gs;
  $$TextBody=~s/<\/(i|b)>\.([\s]*)/<\/$1>\. /gs;
  $$TextBody=~s/ ([A-Za-z]+)\,([A-Za-z]+)/ $1\, $2/gs; 
  $$TextBody=~s/\([\s]?([A-Za-z ]+)[\s]?\)/\($1\)/gs;


  $$TextBody=~s/ ([0-9]+) ([A-Z])\: ([0-9\-–]+)([\.]?)<\/bib>/ $1$2\: $3$4<\/bib>/gs;
  $$TextBody=~s/−/\-\-/gs;

  $$TextBody=~s/\,([\s]+)([\d]+)<\/i>/<\/i>\, <i>$2<\/i>/gs;
  $$TextBody=~s/ ([\d]+)<\/i>([\.\,\:]) ([0-9A-Z\-\.]+)<\/bib>/<\/i> <i>$1<\/i>$2 $3<\/bib>/gs;
  $$TextBody=~s/ &amp; / \& /gs;
  $$TextBody=~s/([\,\.\;\:]?)\&amp\;/$1 \& /gs;
  $$TextBody=~s/>([A-Z][a-z]+)\, ([A-Z\-\. ]+) ([A-Z][a-z]+)\, ([A-Z\-\. ]+) />$1\, $2\, $3\, $4<TEMP>/gs;
  $$TextBody=~s/>([A-Z][a-z]+)\, ([A-Z\-\. ]+) ([A-Z][a-z]+)\, ([A-Z\-\. ]+) />$1\, $2\, $3\, $4<TEMP>/gs;
  $$TextBody=~s/>([A-Z][a-z]+)\, ([A-Z\-\. ]+)\. ([A-Z][a-z]+) ([A-Z\-\. ]+)\.\, />$1\, $2\.\, $3\, $4\.\, /gs;
#  $$TextBody=~s/>Couzens, D. Cuskelly M.,
  $$TextBody=~s/<TEMP>([\,]?) /\, /gs;
  $$TextBody=~s/<TEMP>\& / \& /gs;
  $$TextBody=~s/<TEMP>/ /gs;###################################
  $$TextBody=~s/<i>\)\. /\)\. <i>/gs;

  #select(undef, undef, undef, $sleep2);

  #$$TextBody=~s/¬//gs;


  #$$TextBody=~s/(\p{L})�(\p{L})/$1$2/gs;

  $$TextBody=~s/([a-zA-Z\,\.]+)\&nbsp\;([a-zA-Z\,\.]+)/$1 $2/gs;

  $$TextBody=~s/  / /gs;
  $$TextBody=~s/ \( / \(/gs;
  $$TextBody=~s/<(b|i|sup|sub|u)><\/\1>//gs;
  $$TextBody=~s/<(b|i|sup|sub|u)>([\s]+)<\/\1>/$2/gs;
  $$TextBody=~s/\s+<\/bib><\/p>/<\/bib><\/p>/gs;

  $$TextBody=~s/([A-Z])\.\. /$1\. /gs;
  $$TextBody=~s/([a-z])\.\.<i>/$1\. <i>/gs;
  $$TextBody=~s/([A-Z\.]+)\,([a-zA-Z])/$1\, $2/gs;
  $$TextBody=~s/([A-Z][A-Za-z]+)\,\. ([A-Z\.]+)\./$1\, $2\./gs;
  $$TextBody=~s/([A-Z])\. ([A-Z][a-z]+)\.([A-Z][a-z]+)\./$1\. $2\. $3\./gs;

  $$TextBody=~s/ \+ / \+ /gs;
  $$TextBody=~s/([A-Z][A-Za-z]+) \, ([A-Z\. ]+)\./$1\, $2\./gs;
  $$TextBody=~s/([0-9]+)([ ]?)\-\-([ ]?)([0-9]+)/$1\-\-$4/gs;
  $$TextBody=~s/<bib([^<>]+?)>([^\(\)<>]+?)et al\. (\d{4})\)/<bib$1>$2et al\. \($3\)/gs;   #(zit. Carr et al. 2014)
  $$TextBody=~s/([a-zA-Z]+) \, /$1\, /gs;
  $$TextBody=~s/<bib([^<>]*?)>(\&nbsp\;)*[\s]?/<bib$1>/gs;

  ###**** check for apos
  $$TextBody=~s/([a-zA-Z]+)’(S|s|t)/$1�$2/gs;
  $$TextBody=~s/([dDLl])’([A-Za-z]+)/$1�$2/gs;
  # $$TextBody=~s/(s|t)’ /$1\' /gs;
  # $$TextBody=~s/([a-zA-Z]+)�(s|t)/$1\'$2/gs;
  #$$TextBody=~s/(s|t)� /$1\' /gs;

  $$TextBody=~s/ [Ii]n\: ([A-Z][^A-Z]+)\. ([A-Z\-\.]+)\./ In\: $1 $2\./gs;
  $$TextBody=~s/<bib([^<>]*?)><i>([^<>]*?)<\/i>([\.\:\,\; ]+)([\(]?\d{4}[a-z]?[\)]?)/<bib$1>$2$3$4/gs;
  $$TextBody=~s/<bib([^<>]*?)><i>([^<>]*?)<\/i>([\.\:\,\; ]+)\(([A-Za-z\.]+)\)/<bib$1>$2$3\($4\)/gs;

  $$TextBody=~s/<bib([^<>]*?)><i>([^<>]+? [\(]?\d{4}[a-z]?[\)]?)<\/i>([\.\,\;]+ )/<bib$1>$2$3/gs; #delete italic from begining.


  $$TextBody=~s/<bib([^<>]*?)><b>([^<>]*?)<\/b>([\.\:\,\; ]+)([\(]?\d{4}[a-z]?[\)]?)/<bib$1>$2$3$4/gs;
  $$TextBody=~s/<bib([^<>]*?)><b>([^<>]*?)<\/b>([\.\:\,\; ]+)\(([A-Za-z\.]+)\)/<bib$1>$2$3\($4\)/gs;

  $$TextBody=~s/<bib([^<>]*?)><b>([A-Z][^<> ]+ [A-Z\-\.\,\;]+) ([^<>]*?)<\/b>/<bib$1>$2 $3/gs;
  $$TextBody=~s/<bib([^<>]*?)><i>([A-Z][^<> ]+ [A-Z\-\.\,\;]+) ([^<>]*?)<\/i>/<bib$1>$2 $3/gs;
  $$TextBody=~s/<bib([^<>]*?)><b>([A-Z\-\.\,\;]+ [A-Z][^<> ]+) ([^<>]*?)<\/b>/<bib$1>$2 $3/gs;
  $$TextBody=~s/<bib([^<>]*?)><i>([A-Z\-\.\,\;]+ [A-Z][^<> ]+) ([^<>]*?)<\/i>/<bib$1>$2 $3/gs;
  $$TextBody=~s/ \& ([A-Za-z\.\, ]+) \& \((\d{4})\)/ \& $1 \($2\)/gs;
  $$TextBody=~s/([Ii]n[\:]?) ([A-Z\-\.]+)\.([A-Za-z]+) \(/$1 $2\. $3 \(/gs;
  $$TextBody=~s/\(([\-0-9]+)\)\.\: ([\-0-9]+)([\.]?)<\/bib>/\($1\)\: $2$3<\/bib>/gs;

  $$TextBody=~s/ ([A-Z\-\.])\, ([A-Za-z]+) ([A-Z])\.([A-Z][a-z]+)/ $1\, $2 $3\. $4/gs;
  $$TextBody=~s/ et al\.([A-Z]+)/ et al\. $1/gs;
  $$TextBody=~s/\& ([A-Z\.\-]+)\.([A-Z][a-z]+)/\& $1\. $2/gs;
  $$TextBody=~s/([\.\,\: ]+)([SPp][\. ]+)(\d+)\-\s(\d+)([\.\,\;\: ]+)/$1$2$3\-$4$5/gs;
  $$TextBody=~s/\.\.<\/bib>/\.<\/bib>/gs;
  $$TextBody=~s/([> ])([A-Z][a-z]+)\,([A-Z\.\-]+)\, /$1$2\, $3\, /gs;
  $$TextBody=~s/\(([Ee]d[s]?\.) \)/\($1\)/gs;
  $$TextBody=~s/\)\.\./\)\./gs;
  $$TextBody=~s/(>| )([A-Z][^0-9\.\n\,\:\;\(\)\[\]]+)\, ([A-Z\-\. ]+)\. ([A-Z][^0-9\.\n\,\:\;\(\)\[\]]+)\, ([A-Z\-\. ]+)\.\, /$1$2\, $3\.\, $4\, $5\.\, /gs;
  $$TextBody=~s/<bib([^<>]*?)><b>((?:(?!<b>)(?!<\/b>)(?!<bib)(?!<\/bib>).)*)<\/b><\/bib>/<bib$1>$2<\/bib>/gs;
  $$TextBody=~s/\((\d+)\)\:(\s*)(\d+)\- (\d+)\./\($1\)\:$2$3\-$4\./gs;
  $$TextBody=~s/(>| )([A-Z][a-z]+)\, ([A-Z\-\. ]+)\. \, /$1$2\, $3\.\, /gs;
  $$TextBody=~s/([a-zA-Z]+)<\/i>([0-9]+) ([p]+[\. ]*)([0-9\-]+)<\/bib>/$1<\/i> $2 $3$4<\/bib>/gs;
  $$TextBody=~s/ (S\.|pp[\.]?)\s*([0-9]+)\s?([\-]+)\s?([0-9]+[\.]?)<\/bib>/ $1 $2$3$4<\/bib>/gs;

  $$TextBody=~s/([0-9]+[\.]?)<\/p>(\n[\s]*)<p([^<>]*?)><bib/$1<\/bib><\/p>$2<p$3><bib/gs;#catalist bug;

  $$TextBody=~s/([ \s]+)<\/bib>/<\/bib>/gs;

  $$TextBody=~s/(\d+)\s*(\-\-|––|—|‒)\s*(\d+)/$1\-\-$3/gs;
  #$$TextBody=~s/([0-9]+)‒([0-9]+)/$1\-\-$2/gs;

  $$TextBody=~s/\n{2,}/\n/g;
  $$TextBody=~s/\&nbsp;/ /g;
  $$TextBody=~s/<b>([\w\d\-]+) <\/b>([\w\d\(\[])/<b>$1<\/b> $2/gs;
  $$TextBody=~s/<\/i><i>//gs;
  $$TextBody=~s/<\/b><b>//gs;
  $$TextBody=~s/\s*<\/bib>/<\/bib>/gs;

 #  $$TextBody=~s/窶�/\-\-/gs;
  $$TextBody=~s/<\/(ct|pt|at|misc1|pbl|cny|v|iss|yr|pg)>([\.\,\?\:\;]*?)\s*\\newblock\s*<(ct|pt|at|misc1|pbl|cny|v|iss|yr|pg)>/<\/$1>$2 <$3>/gs;
  $$TextBody=~s/<\/ct>([\.\,\?\:\;]*?) \\newblock/<\/ct>$1 /gs;
  $$TextBody=~s/<\/ct>([\.\,\:\;]) \\newblock ([Ii]n)/<\/ct>$1 $2/gs;
  $$TextBody=~s/([\.\,\:\;])� /$1 /gs;
  $$TextBody=~s/([0-9]+) \- ([0-9]+)([\.]?)<\/bib>/$1\-$2$3<\/bib>/gs;
  $$TextBody=~s/Vol ([0-9]+)\, N\$\^\\circ\$([0-9]+)/Vol $1\, No$2/gs;
  $$TextBody=~s/<bib([^<>]*?)>([A-Z\-\. ]+)\.([A-Z][a-z]+)\./<bib$1>$2\. $3\./gs;
  $$TextBody=~s/<(i|b)><bib([^<>]*?)>/<bib$2><$1>/gs;
  $$TextBody=~s/<\/bib><\/(i|b)>/<\/$1><\/bib>/gs;
  $$TextBody=~s/\. ([0-9]+) \, ([0-9]+)/\. $1\, $2/gs;
  $$TextBody=~s/\.([0-9]+)\, ([0-9]+)/\. $1\, $2/gs;
  $$TextBody=~s/\. ([0-9]+) \,([0-9]+)/\. $1\, $2/gs;
  $$TextBody=~s/\,([0-9]+)\, ([0-9]+)/\, $1\, $2/gs;
  $$TextBody=~s/\,([0-9]+) \, ([0-9]+)/\, $1\, $2/gs;
  $$TextBody=~s/\. \,([0-9]+)\, ([0-9]+)/\.\, $1\, $2/gs;

  #select(undef, undef, undef, $sleep2);

  $$TextBody=~s/\. \, /\.\, /gs;
  $$TextBody=~s/\. \; /\.\; /gs;
  $$TextBody=~s/ \, /\, /gs;
  $$TextBody=~s/ \; /\; /gs;
  $$TextBody=~s/ ([A-Za-z][a-z]+)\.([A-Z])\. ([A-Z][a-z]+)/ $1\. $2\. $3/gs;
  $$TextBody=~s/ ([a-z]+)\.([A-Z][A-Za-z]+) / $1\. $2 /gs;
  $$TextBody=~s/<(b|i|sup|sub|sp|sb|u)>\&\#X([0-9]+)<\/\1>\;/<$1>\&\#X$2\;<\/$1>/gs;
  $$TextBody=~s/   / /gs;
  $$TextBody=~s/([\t]+| |  |  [ ]+) / /gs;
  $$TextBody=~s/([\t]+| |  |  [ ]+)<\/bib>/<\/bib>/gs;
  $$TextBody=~s/…/\&hellip\;/gs;
  $$TextBody=~s/ \&([ ]?)(…|�)/ \&$1\&hellip\;/gs;
  #print $$TextBody;exit;

  $$TextBody=~s/([A-Z\.]+)‐([A-Z\.]+)/$1\-$2/gs;
  $$TextBody=~s/([A-Z]+)\. \:/$1\.\:/gs;
  $$TextBody=~s/ ([A-Z\-\.]+) \./ $1\./gs;
  $$TextBody=~s/<b>([0-9]+)<\/b>([0-9]+)\(([0-9\/]+)\)\, ([0-9\/]+)/<b>$1$2<\/b>\($3\)\, $4/gs;
  $$TextBody=~s/([A-Za-z][\.]?)([0-9])/$1 $2/gs;
  $$TextBody=~s/([A-Za-z]+)\.([0-9]+)\(([0-9]+)\)([\.\: ]+)([0-9]+)/$1\. $2\($3\)$4$5/gs;
  $$TextBody=~s/ ([A-Z][a-z]+)([0-9]+)\:([0-9\-]+)\.<\/bib>/ $1 $2\:$3\.<\/bib>/gs;

  $$TextBody=~s/([A-Z][a-z][a-z]+ [A-Z\- ]+)\, ([A-Z][a-z][a-z]+)([A-Z][A-Z]+) /$1\, $2 $3 /gs;
  $$TextBody=~s/([0-9]+)\:([0-9]+[SP])(-[-]?)([0-9]+)([SP][\.]?)<\/bib>/$1\:$2$3$4$5<\/bib>/gs;


  $$TextBody=~s/\, ([A-Z\- \.]+) ([A-Z][a-z]+)\. ([A-Z\- \.]+) ([A-Z][a-z]+)\,/\, $1 $2\, $3 $4\,/gs;
  $$TextBody=~s/([A-Aa-z])�([A-Za-z])/$1$2/gs;

  $$TextBody=~s/\, ([A-Z][a-z]+)\.\, ([A-Z\-\ \.]+)\.\, /\, $1\, $2\.\, /gs;

 # $$TextBody=~s/\&quot\;((?:(?!<bib)(?!<\/bib>).)*?)\&quot\;/"$1"/gs;
  $$TextBody=~s/([\:\.\,][\s]?)([0-9]+)S\-([0-9]+) S([\,.\<])/$1$2S\-$3S$4/gs;
  $$TextBody=~s/\, pp\-([0-9]+[\-]+[0-9]+)([\.\,\<])/\, pp $1$2/gs;
  $$TextBody=~s/([a-zA-Z]+)\&\#8201\;\+\&\#8201\;([a-zA-Z]+)/$1 \+ $2/gs;
  $$TextBody=~s/([dD][oO][iI])([\:]?)([^ ]+?)\&\#8201\;(×|×)\&\#8201\;([^ ]+?)/$1$2$3x$5/gs;
  $$TextBody=~s/\&\#8201\;\&lt\;\&\#8201\;/\&lt\;/gs;
  $$TextBody=~s/\&\#8201\;\&gt\;\&\#8201\;/\&gt\;/gs;
  $$TextBody=~s/\&\#8201\;(×|×)\&\#8201\;/x/gs;
  $$TextBody=~s/ <i>([A-Z][a-z][^<>]+?)<\/i> \& <i>([A-Z][a-z][^<>]+?)<\/i>([\,\;])/ <i>$1 \& $2<\/i>$3/gs;
  $$TextBody=~s/\&\#65292\; / /gs;
  $$TextBody=~s/([A-Z][^\,\. \;\:0-9\(\)]+[\,]?) ([A-Z]+\.)and /$1 $2 and /gs;

  $$TextBody=~s/<(u|i|b)>([^<>]*?)<\/bib><\/\1>/<$1>$2<\/$1><\/bib>/gs;
  $$TextBody=~s/ <i>([A-Z]+)<\/i>\. <i>/ <i>$1\. /gs;
  $$TextBody=~s/<i>([^<>]*?)<\/i>([\:\.]) <i>([^<>]*?)<\/i>([\.\,]?) ([0-9]+)/<i>$1$2 $3<\/i>$4 $5/gs;
  $$TextBody=~s/([A-Z]?[0-9]+)[–]([A-Z]?[0-9]+)/$1-$2/gs;
  $$TextBody=~s/<bib([^<>]*?)>\.\s*/<bib$1>/gs;
  $$TextBody=~s/ \\ \& / \& /gs;

  $$TextBody=~s/([\,\>\; ]+)([A-Z][a-z\-A-Z]+)\, ([A-Z\.\-]*?[A-Z])\; ([A-Z][a-z\-A-Z]+)\, ([A-Z\.\-]+)\.\, ([A-Z][a-z\-A-Z]+)\, ([A-Z\.\-]+)\.\, /$1$2\, $3\.\, $4\, $5\.\, $6\, $7\.\, /gs;
  $$TextBody=~s/<bib([^<>]*?)>�([\(A-Za-z0-9]+)/<bib$1>$2/gs;
  $$TextBody=~s/([A-Z][a-z]+)<i>([a-z])<\/i>\./$1$2\./gs;

  $$TextBody=~s/<i>\(<\/i>([0-9]+)<i>\)<\/i>/\($1\)/gs;
  $$TextBody=~s/<i>\&amp<\/i>\;/\&amp\;/gs;
  $$TextBody=~s/<i>\&amp\;<\/i>/\&amp\;/gs;
  $$TextBody=~s/([0-9]+)\&\#8722\;([0-9]+)/$1\-$2/gs;
  $$TextBody=~s/([0-9]+)<i>\-<\/i>([0-9]+)/$1\-$2/gs;
  $$TextBody=~s/\s*<u><\/u><\/bib>/<\/bib>/gs;
  $$TextBody=~s/\s*<i><\/i><\/bib>/<\/bib>/gs;
  $$TextBody=~s/<u><\/u>//gs;
  $$TextBody=~s/<i><\/i>//gs;
  $$TextBody=~s/([A-Z\-a-z\.]+)\, ([0-9]+)\(([0-9]+)\)<\/i>/$1<\/i>\, <i>$2\($3\)<\/i>/gs;
  {}while($$TextBody=~s/(http[s]?\:\/\/www|www)\.([^ ]+?) \& /$1\.$2\&/gs);
  #www.dgzmk.de/ zahnaerzte/
  $$TextBody=~s/(http[s]?\:\/\/www|www)\.([^ ]+?)\/ ([^ <>]+)\//$1\.$2\/$3\//gs;

  $$TextBody=~s/([0-9]+[a-zA-Z]+)[  ]([A-Za-z]+)/$1 $2/gs;
  $$TextBody=~s/\.<i>/\. <i>/gs;
  $$TextBody=~s/ ([A-Z])<i>([a-z]+[\,\.\: ]+)/ <i>$1$2/gs;
  $$TextBody=~s/\/([\/\\\_\.\~\%\#\@\$\&\*\(\)\w\d\-]+) \/([\/\\\_\.\~\%\#\@\$\&\*\(\)\w\d\-]+)/\/$1\/$2/gs;
  $$TextBody=~s/([Dd][Oo][Ii])([\: ]+)([\/\\\_\.\~\%\#\@\$\&\*\(\)\w\d\-]+) \(([0-9]+)\) ([0-9]+)/$1$2$3\($4\)$5/gs;
  $$TextBody=~s/([Dd][Oo][Ii])([\: ]+)([\/\\\_\.\~\%\#\@\$\&\*\(\)\w\d\-]+) \&lt\;([\:a-zA-Z0-9]+)\&gt\; ([0-9]+)/$1$2$3\&lt\;$4\&gt\;$5/gs;

  $$TextBody=~s/<i>([A-Z][a-z]+) ([A-Za-z][a-z]+)\. Journal of/<i>$1 $2<\/i>\. <i>Journal of/gs;
  $$TextBody=~s/ ([A-Z\. ]+)\.([A-Z][a-z]+)/ $1\. $2/gs;
  $$TextBody=~s/(\,|\))/$1 /gs;
  $$TextBody=~s/ / /gs;
  $$TextBody=~s/\;/\;/gs;
  $$TextBody=~s/<\/bib>/<\/bib>/gs;
  $$TextBody=~s/([0-9])$regx{ednSuffix}/$1 $2/gs;
  $$TextBody=~s/([0-9])$regx{pagePrefix}/$1 $2/gs;
  $$TextBody=~s/([0-9])$regx{volumePrefix}/$1 $2/gs;

  $$TextBody=~s/ et\. Al\.\;/ et al\.\;/gs;
  $$TextBody=~s/\, ([A-Z\.]+\.) ([A-Z][a-z]+)\, ([A-Z\.]*[A-Z]+)\, ([A-Z][a-z]+)\,/\, $1 $2\, $3\. $4\,/gs;
  $$TextBody=~s/\bClaredon\b/Clarendon/gs;
  $$TextBody=~s/Proc\. Natl\. Ac\. Sci\./Proc\. Natl\. Acad\. Sci\. U S A/gs;
  $$TextBody=~s/\(pp\.([0-9]+)/\(pp\. $1/gs;

  $$TextBody=~s/Thinking\, \& Literacy/Thinking \& Literacy/gs;
  $$TextBody=~s/([A-Za-z][A-Za-z]+)<b>([0-9\/]+)<\/b>([\,\: ]+)([0-9\-]+)([\.]?)<\/bib>/$1 <b>$2<\/b>$3$4$5<\/bib>/gs;
  $$TextBody=~s/([A-Za-z][A-Za-z]+)([0-9\/]+)([\,\: ]+)([0-9\-]+)([\.]?)<\/bib>/$1 $2$3$4$5<\/bib>/gs;

  $$TextBody=~s/<\/i>\, <b>([A-D]) ([0-9]+)<\/b>\, ([0-9\-]+[\.]?)<\/bib>/<\/i>\, <b>$1$2<\/b>\, $3<\/bib>/gs;
  $$TextBody=~s/([a-z]+)<i>\, ([A-Za-z]+)/$1\, <i>$2/gs;
  $$TextBody=~s/\((\d\d\d\d) \/\/ (\d\d\d\d)\)/\($1\/$2\)/gs;
  $$TextBody=~s/ Suppl([0-9]+)\)/ Suppl $1\)/gs;
  $$TextBody=~s/ Sci\.USA/ Sci\. USA/gs;

  $$TextBody=~s/ $regx{and} ([A-Z][a-z][a-z]+)([A-Z]+) ([\(]?)$regx{year}/ $1 $2 $3 $4$5/gs;
  $$TextBody=~s/(>|\, )([A-Z][a-z][a-z]+)([A-Z]+) ([\(]?)$regx{year}/$1$2 $3 $4$5/gs;

  #select(undef, undef, undef, $sleep2);

  $$TextBody=~s/([a-zA-Z]+[\.]?)�([0-9]+)/$1 $2/gs;

  #Mol Cancer10(1):7.
  $$TextBody=~s/([A-Za-z][A-Za-z])([0-9]+)\($regx{issue}\)$regx{page}/$1 $2\($3\)$4/gs;
  $$TextBody=~s/(et al[\.\,]*?)\($regx{year}\)/$1 \($2\)/gs;
  $$TextBody=~s/ ([A-Z]+)et al([\.\,]*) / $1 et al$2 /gs;
  $$TextBody=~s/([A-Z][a-z]+)\.([0-9]+):$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1\. $2:$3$4$5/gs;
  #. Clin.Cancer Res
  $$TextBody=~s/\. ([A-Z][a-z][a-z]+)\.([A-Z][a-z][a-z]+) ([A-Z][a-z][a-z])/\. $1\. $2 $3/gs;
  #cells.Nat 456:593–598
  $$TextBody=~s/ ([a-z][a-z]+)\.([A-Z][a-z][a-z]+) ([0-9]+)\:$regx{page}/ $1\. $2 $3\:$4/gs;
  $$TextBody=~s/<img ([^<>]+?)><\/bib>/<\/bib>/gs;

 # $$TextBody=~s/\\\\ / /gs;
 # $$TextBody=~s/\\ / /gs;
  $$TextBody=~s/(>|[\,\;] )([A-Z][a-z]+)\, ([A-Z\.]+\.)\:([A-Z][a-z]+)/$1$2\, $3\:$4/gs;
  $$TextBody=~s/(>|[\,] )([A-Z\.]+\.)\, ([A-Z][a-z]+)\, ([A-Z\.]+\.)\:([A-Z][a-z]+)/$1$2\, $3\, $4\: $5/gs;
  $$TextBody=~s/(>|\. )([A-Z][a-z]+),([A-Z- ]+)\. ([A-Z][a-z]+)\, ([A-Z- ]+)\. /$1$2, $3\. $4\, $5\. /gs;
  $$TextBody=~s/(>|[,\;] |and |& )([A-Z][a-z][a-z]+)\.([A-Z]+)\. /$1$2\. $3\. /gs;
  $$TextBody=~s/>([A-Z][^ A-Z\.\,<>\;]+),([A-Z]+)\. \(/>$1, $2\. \(/gs;

  $$TextBody=~s/([A-Za-z\.]+) ([0-9]+)/$1 $2/gs; #nbsp;
  $$TextBody=~s/([\.\;\:\,])\(/$1 \(/gs;
  $$TextBody=~s/([a-zA-Z]+)� ([\w]+)/$1 $2/gs;
  $$TextBody=~s/([\?\.\,\:\;])(�|�[�]+) /$1 /gs;


  $$TextBody=~s/(>|[,\;] |and |& )([A-Z][a-z][a-z]+)([A-Z]+)\. \(/$1$2 $3\. \(/gs;
  $$TextBody=~s/([A-Za-z][\.]?)<i>([\,\.\;]) et al([\.\,\;\:])<\/i>/$1$2 <i>et al$3<\/i>/gs;
  $$TextBody=~s/(>|[\,\;] )([A-Z][a-z][a-z]+)\,\b$regx{firstName}\./$1$2\, $3\./gs;

  $$TextBody=~s/([A-Za-z][\)]?)$regx{year} $regx{monthPrefix} $regx{month}\;$regx{volume}\($regx{issue}\)\:$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1 $2 $3 $4\;$5\($6\)\:$7$8$9/gs;
  $$TextBody=~s/([A-Za-z][\)]?)$regx{year} $regx{monthPrefix}-$regx{monthPrefix}\;$regx{volume}\($regx{issue}\)\:$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1 $2 $3\-$4\;$5\($6\)\:$7$8$9/gs;
  $$TextBody=~s/([A-Za-z][\)]?)$regx{year} $regx{monthPrefix}\;$regx{volume}\($regx{issue}\)\:$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1 $2 $3\;$4\($5\)\:$6$7$8/gs;
  $$TextBody=~s/([A-Za-z][\)]?)$regx{year} $regx{monthPrefix}\;$regx{volume}\($regx{issuePrefix} $regx{issue}\)\:$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1 $2 $3\;$4\($5 $6\)\:$7$8$9/gs;
  $$TextBody=~s/([A-Za-z][\)]?)$regx{year} $regx{monthPrefix}\;$regx{volume}\($regx{issuePrefix} $regx{issue}\)\:/$1 $2 $3\;$4\($5 $6\)\:/gs;
  $$TextBody=~s/([A-Za-z][\)]?)$regx{year}\;$regx{volume}\($regx{issue}\)\:$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1 $2\;$3\($4\)\:$5$6$7/gs;
  $$TextBody=~s/([A-Za-z][\)]?)$regx{year} $regx{monthPrefix} $regx{month}\;$regx{volume}\:$regx{page}$regx{optionaEndPunc}<\/bib>/$1 $2 $3 $4\;$5\:$6$7<\/bib>/gs;
  $$TextBody=~s/([A-Za-z][\)]?)$regx{year} $regx{monthPrefix}\;$regx{volume}\:$regx{page}$regx{optionaEndPunc}<\/bib>/$1 $2 $3\;$4\:$5$6<\/bib>/gs;
  $$TextBody=~s/([A-Za-z][\)]?)$regx{year}\;$regx{volume}\:$regx{page}$regx{optionaEndPunc}<\/bib>/$1 $2\;$3\:$4$5<\/bib>/gs;

  $$TextBody=~s/ \( $regx{year}\)/ \($1\)/gs;
  $$TextBody=~s/ ([A-Z]+)\( $regx{year}\)/ $1\($1\)/gs;
  $$TextBody=~s/\($regx{year} ([a-z])\)/\($1$2\)/gs;

  $$TextBody=~s/<u>,<\/u>/\,/gs;
  #$$TextBody=~s/â¨ï¬/\,/gs;
  $$TextBody=~s/ /\,/gs;
  $$TextBody=~s/ / /gs;
  $$TextBody=~s//\,/gs;
  $$TextBody=~s/ / /gs;
  $$TextBody=~s/ / /gs;
  $$TextBody=~s/ / /gs;
  
  $$TextBody=~s/([dD][oO][iI][\: ]+[0-9\.]+\/[A-Z0-9]+)\- ([0-9\-\(\)]+)<\/bib>/$1\-$2<\/bib>/gs;
  $$TextBody=~s/([\.\,])([Ii]n[\:]?) /$1 $2 /gs;
  #. Connections33(1), 35–42
  $$TextBody=~s/ ([A-Z][a-z][a-z]+)([0-9]+[\(]?)$regx{issue}([\)?][\:\,\. ]+)$regx{issue}/ $1 $2$3$4$5 /gs;
  
  $$TextBody=~s/\&lt\;http\:\/\/((?:(?!<[\/]?[a-z]+>)(?!\&gt\;)(?!\&lt\;).)*?)\&gt\;\:\/\/\1 \&lt\;http:\/\/\1\&gt\;/http\:\/\/$1/gs;
  $$TextBody=~s/(>| )([A-Z][a-z])(\&) ([A-Z][a-z]+)([\,\.\:\; ]+)/$1$2 $3 $4$5/gs;

  $$TextBody=~s/<cite>([^<>]+?)<\/cite>/$1/gs; #**************
  $$TextBody=~s/ <\/(i|b)>/<\/$1> /gs;

  $$TextBody=~s/\, ([0-9\-]+)\.([A-Z][a-z]+)/\, $1\. $2/gs;
  $$TextBody=~s/([A-Za-z])\. \, /$1\.\, /gs;
  $$TextBody=~s/>([A-Z][a-z][a-z]+)\. ([A-Z\-\. ]+)\.\, $regx{and} ([A-Z][a-z][a-z]+)\, ([A-Z\-\. ]+)(\.\,|\,\.) />$1\, $2\.\, $3 $4, $5\.\, /gs;

  $$TextBody=~s/ ([A-Z\-]+)\, ([A-Z][a-z]+) ([A-Z\-]+)\,\: / $1\, $2 $3\: /gs; 
  $$TextBody=~s/ ([A-Z\-\. ]+)\.\:([A-Z][a-z]+)/ $1\.\: $2/gs;
  $$TextBody=~s/(\, |>|\; )([A-Z][a-z]+) ([A-Z\-\. ])\:([A-Z\(\[]+)/$1$2 $3\: $4/gs;
  $$TextBody=~s/([\.\,])([A-Z][a-z]+[\.]?) J\. /$1 $2 J\. /gs;
  $$TextBody=~s/\.J ([A-Z][a-z]+) /\. J $1 /gs; 
  #SciUSA
  $$TextBody=~s/SciUSA(<\/i>|[0-9])/Sci USA $1/gs;
  $$TextBody=~s/Masson et CieEditeurs/Masson et Cie Editeurs/gs;
  $$TextBody=~s/ElectroencephclinNeurophysiol/Electroencephclin Neurophysiol/gs;
  $$TextBody=~s/VerlagEugen/Verlag Eugen/gs;
  #<u>doi &lt;http://dx.doi.org/10.1002/rra.1598&gt;</u> *********
  $$TextBody=~s/<u>doi \&lt\;http\:\/\/dx\.doi\.org\/([^<>]+?)\&gt\;<\/u>/doi $1/gs;
  $$TextBody=~s/\b([dD][oO][iI][\:]?) http\:\/\/dx.doi.org\/([^<> ]+)([\.]? |[\.]?<\/bib>)/$1 $2$3/gs;
  #doi: <u>10.1037/11706-003 &lt;http://psycnet.apa.org/doi/10.1037/11706-003&gt;</u>
  $$TextBody=~s/\b([dD][oO][iI][\:]?) <u>([\.0-9\-\/]+) \&lt\;http\:\/\/([a-z\.]+)\.org\/doi\/\2\&gt\;<\/u>/$1 $2/gs;
  $$TextBody=~s/<u>&lt;http\:\/\/([^<>]+?)\&gt\;<\/u><\/bib><\/bib>/http\:\/\/$1<\/bib>/gs;
  $$TextBody=~s/(<\/sup>|[0-9\.])([eE]dition)/$1 $2/gs;
  $$TextBody=~s/ <u>\&lt\;http:\/\/([^<>]+?)\&gt\;<\/u>/ http:\/\/$1/gs;
  $$TextBody=~s/ \&lt\;http:\/\/([^<>]+?)\&gt\;/ http:\/\/$1/gs;
  $$TextBody=~s/<bib([^<>]*?)>\&lt\;http\:\/\/([^<> ]+?)\&gt\;<\/bib>/<bib$1>http\:\/\/$2<\/bib>/gs;
  $$TextBody=~s/[ ]?\.[ ]?<\/bib>/\.<\/bib>/gs;
  #Springer,593–599.</bib>
  $$TextBody=~s/([A-Za-z])\,([0-9\-]+[\.]?)<\/bib>/$1\, $2<\/bib>/gs;
  $$TextBody=~s/([a-zA-Z]+)([\,\.\?]) $regx{volume}([ ]?)\($regx{issue}\)<\/i>([\:\, ]+)$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1$2<\/i> <i>$3$4\($5\)<\/i>$6$7$8$9/gs;
  $$TextBody=~s/([a-zA-Z]+)([\,\.\?]) $regx{volume}([ ]?)\($regx{issue}\)([\,\:])<\/i>([ ]+)$regx{page}$regx{optionaEndPunc}$regx{extraInfo}/$1$2<\/i> <i>$3$4\($5\)$6<\/i>$7$8$9$10/gs;

  $$TextBody=~s/<bib([^<>]*?)>([^<>]+?)\(<b>$regx{year}\)\. <i>([^<>]+?)<\/i><\/b>/<bib$1>$2\($3\)\. <i>$4<\/i>/gs;
  $$TextBody=~s/\&\#([A-Za-z0-9]+)<\/(i|b|u)>\;/\&\#$1\;<\/$2>/gs;
  $$TextBody=~s/<u>([^<>]+?)<\/u>/$1/gs;#### <u> removed............

  #select(undef, undef, undef, $sleep2);

  $$TextBody=~s/(>|\, )([A-Z\. ]+)\.([A-Z][a-z]+)\, ([A-Z\. ]+)\. ([A-Z][a-z]+)/$1$2\. $3\, $4\. $5/gs;
  $$TextBody=~s/\. ([Ii]n) \: /\. $1\: /gs;

  $$TextBody=~s/\.\.\./<hellip>/gs;
  $$TextBody=~s/ ([A-Z\-\.])\.\. / $1\. /gs;
  $$TextBody=~s/\. \)/\.\)/gs;
  $$TextBody=~s/<hellip>/\.\.\./gs;

  $$TextBody=~s/$regx{pagePrefix}([\. ]+)$regx{page}\.([A-Z][a-z])/$1$2$3\. $4/gs;   #, pp. 34-44.Oxford
  $$TextBody=~s/([\.\,] [Ii]n[\:\.]?)<i>([A-Z][a-z]+)/$1 <i>$2/gs;
  $$TextBody=~s/<bib([^<>]+?)><b>([^<>]+?)<\/b>/<bib$1>$2/gs;
  $$TextBody=~s/, \(<\/i>([A-Za-z]+)/,<\/i> \($1/gs;
  $$TextBody=~s/([\?\.\,])([Ii]n)<i>([A-Za-z]+)/$1 $2<i>$3/gs;
  $$TextBody=~s/ ([\-a-zA-Z]+)\.J / $1\. J /gs;   #insecticide.J 
  $$TextBody=~s/\(([a-zA-Z\. ]+)<i>([\.\,]?\)[\:\.\, ]+)/\($1$2$3<i>/gs;   #(eds<i>.): 
  $$TextBody=~s/ ([A-z][a-z]+)\.([A-Z][a-z]+[\.\,]* )/ $1\. $2/gs;

  #In C. Reyer, B., Medicine, to In C. Reyer, B., Medicine, 
  $$TextBody=~s/(\. [iI]n )$regx{firstName} $regx{sAuthorString}\, $regx{firstName}\, $regx{sAuthorString}(\, | [au]nd | \& |\.)/$1$2 $3\, $4 $5$6/gs;
  $$TextBody=~s/$regx{editorSuffix} ([\.\,\)])/$1$2/gs;
  $$TextBody=~s/\(([0-9]+[a-z]?) \)/\($1\)/gs;
  $$TextBody=~s/([a-zA-Z][a-z]+)([0-9]+) ([0-9]+)\(([0-9]+)\)/$1 $2 $3\($4\)/gs;
  $$TextBody=~s/(S[0-9]+)\s?([\-]+)\s?(S[0-9]+)(\.|<\/bib>)/$1$2$3$4/gs;
  $$TextBody=~s/([sS]uppl)\.([0-9]+)/$1\. $2/gs;
  $$TextBody=~s/ and\. / and /gs;
  $$TextBody=~s/(<bib[^<>]*?>|\, )$regx{mAuthorString} $regx{firstName}\,$regx{mAuthorString} $regx{firstName}(\, |\. )/$1$2 $3\, $4 $5$6/gs;
  #$$TextBody=~s/(<bib[^<>]*?>|\, )Ochs, K., Sahm F, Opitz CA,
  $$TextBody=~s/ ([  \t]+)([Rr]eprint [eE]dn[\,\. ]|[Rr]eprinted [Ii]n |[Rr]etrieve[d]? |[Rr]eprinted\, |[Ss]pecial [Ii]ssue [Ss]ection[s]?[\:]?|[Ss]pecial [Ii]ssue [tT]oward[s]?[\:\;]?)/ $2/gs;
  $$TextBody=~s/ ([  \t]+)([Rr]etriev[e]?[d]?|[Oo]nline|[Aa]vailable|[Oo]riginal [wW]ork [pP]ublished|[Ii]nternet|[Aa]ccessed|[uU]pdated|[cC]ited|[Rr]eprinted|[Ss]pecial [Ii]ssue [Ss]ection[s]?[\:]?|[Ss]pecial [Ii]ssue [tT]oward[s]?[\:\;]?)/ $2/gs;
  $$TextBody=~s/S([0-9]+)([-]+)S ([0-9]+)([\.\,\;\<])/S$1$2S$3$4/gs;


  $$TextBody=~s/<bib([^<>]*?)>$regx{firstName}\.$regx{mAuthorString}\,/<bib$1>$2\. $3\,/gs;

  $$TextBody=~s/<i>([^<>0-9]+?)<\/i>([0-9]+)([\;\:\.\, ]+)<b>([0-9]+)<\/b>([\;\:\.\, ]+)([0-9\-]+)([\.]?)<\/bib>/<i>$1<\/i> $2$3<b>$4<\/b>$5$6$7<\/bib>/gs;
  $$TextBody=~s/([\w])<i>-<\/i>([\w])/$1-$2/gs;

  $$TextBody=~s/  / /gs;
  $$TextBody=~s/<img\s+width=1\s+height=1\s+src=\"([^<>\"]+?)\.gif\">//gs;
  $$TextBody=~s/<img\s+width=1 height=1\s+id="([^<>\"]+?)"\s+src=\"([^<>\"]+?)\.gif\"\s+alt=\"one_pix\">//gs;

  $$TextBody=~s/\($regx{issue}<\/i>\)/\($1\)<\/i>/gs;
  $$TextBody=~s/([a-zA-Z]+) $regx{volume}([\,\: ]*?)\($regx{issue}\)<\/i>([\:\, ]+)$regx{firstName}/$1<\/i> <i>$2$3\($4\)<\/i>$5$6/gs;
  $$TextBody=~s/([\;\,])doi\:/$1 doi\:/igs;
  $$TextBody=~s/ ([iI]n) : ([^<>0-9]+?)\($regx{editorSuffix}\)/ $1: $2\($3\)/gs;
  $$TextBody=~s/CoRR\, abs\/([\d]+)\. ([\d]+)([\,\.\;])/CoRR\, abs\/$1\.$2$3/gs;
  $$TextBody=~s/$regx{year} \)/$1\)/gs;
  $$TextBody=~s/([a-z])\($regx{year}\)([\:])/$1 \($2\)$3/gs; 
  $$TextBody=~s/([0-9]+) \-\- ([0-9]+)([\.]?)<\/bib>/$1\-\-$2$3<\/bib>/gs;

  $$TextBody=~s/$regx{year}\:([dD][Oo][Ii][\: ])/$1\: $2/gs;
  $$TextBody=~s/�/ü/gs;
  $$TextBody=~s/�/ö/gs;
  $$TextBody=~s/�/ß/gs;

  $$TextBody=~s/([\.\,\:\;]?) [\-]+\&lt\;(http[s]?\:\/\/www\.|http[s]?\:\/\/|www\.)((?:(?!<[\/]?bib>)(?!\&lt\;)(?!\&gt\;).)+?)\&gt\;$regx{optionaEndPunc}$regx{extraInfo}/$1 $2$3$4$5/gs;
  $$TextBody=~s/ \($regx{editorSuffix}\)([\,\.\( ]+)$regx{year}([\.\,\:\) ]+)\($regx{editorSuffix}\)([\.\, ]+)/ \($1\)$2$3$4/gs;
  $$TextBody=~s/ \& and / and /gs;
  $$TextBody=~s/<i>([^<>]+?) \(<\/i>([^<>\)\(]+?)\)/<i>$1<\/i> \($2\)/gs;
  $$TextBody=~s/\&lt\;([\/]?)(sup|sub)\&gt\;/<$1$2>/gs;
  $$TextBody=~s/([\s]+)<\/span>/<\/span>$1/gs;

  $$TextBody=~s/([\.\,\;>]) ([vV])\.$regx{volume}\, $regx{pagePrefix}([\. ]+)$regx{page}/$1 $2\. $3\, $4$5$6/gs;

  $$TextBody=~s/<bib([^<>]+?)>((?:(?!<bib[^<>]*?>)(?!<\/bib>).)*?)\(\(([^<>\)\(]+?)\)((?:(?!<bib[^<>]*?>)(?!<\/bib>)(?!<[^\)\(]>).)*?)<\/bib>/<bib$1>$2\($3\)$4<\/bib>/gs;

  $$TextBody=~s/$regx{firstName} $regx{mAuthorFullSirName} \&[ ]?\/$regx{firstName} $regx{mAuthorFullSirName}/$1 $2 \& $3 $4/gs; 

  $$TextBody=~s/$regx{mAuthorFullSirName}\. $regx{firstName}\.\, $regx{mAuthorFullSirName}, $regx{firstName}\./$1\, $2\.\, $3, $4\./gs;

  $$TextBody=~s/ $regx{editorSuffix} \(\1\)/ \($1\)/gs; 
  $$TextBody=~s/ $regx{pagePrefix}([\. ]+)$regx{page} \(\1\2\3\)/ \($1$2$3\)/gs;
  $$TextBody=~s/(doi\:[\: ]*)([\d]+)\. ([\dA-Z]+)/$1$2\.$3/igs;
  $$TextBody=~s/\, $regx{firstName}\, \& \($regx{year}/\, $1 \($2/gs;
  $$TextBody=~s/\b([A-Z][a-z]+?)([0-9]+)([\;\, ]+?)$regx{volume}([\:\, ]+[0-9]+)/$1 $2$3$4$5/gs;
  $$TextBody=~s/(>|[\,\;] )$regx{mAuthorFullSirName}\. $regx{firstName}\. ([\(]?)$regx{editorSuffix}([\)?])/$1$2\, $3\. $4$5$6/gs;
  $$TextBody=~s/(International)[ ]?(Journal)[ ]?(of)[ ]?([A-Za-z])/$1 $2 $3 $4/igs;
  $$TextBody=~s/$regx{mAuthorFullSirName}, $regx{firstName}\; $regx{mAuthorFullSirName} $regx{firstName}\, $regx{mAuthorFullSirName} $regx{firstName}\, /$1, $2\, $3 $4\, $5 $6\, /gs;
  while($$TextBody=~s/(\, |>)$regx{mAuthorFullSirName} $regx{firstName}\, $regx{mAuthorFullSirName} $regx{firstName} $regx{mAuthorFullSirName} $regx{firstName}/$1$2 $3\, $4 $5\, $6 $7/gs){}
  $$TextBody=~s/<bib([^<>]+?)>$regx{mAuthorFullSirName}\;$regx{mAuthorFullFirstName}\,/<bib$1>$2\; $3\,/gs;
  $$TextBody=~s/<bib([^<>]+?)>$regx{mAuthorFullSirName}\; $regx{mAuthorFullFirstName}\, $regx{mAuthorFullSirName}\;$regx{mAuthorFullFirstName}\,/<bib$1>$2\; $3\, $4\; $5\,/gs; 
  $$TextBody=~s/(\, |>)$regx{mAuthorFullSirName}\; $regx{mAuthorFullFirstName}([\,]?) $regx{and} $regx{mAuthorFullSirName}\;$regx{mAuthorFullFirstName}\,/$1$2\; $3$4 $5 $6\; $7\,/gs;
  $$TextBody=~s/\,(“|�)/\, $1/gs;
  $$TextBody=~s/\($regx{editorSuffix}\)([A-Za-z])/\($1\) $2/gs;
  $$TextBody=~s/$regx{pagePrefix}$regx{optionalSpace}([0-9]+)­([0-9]+)/$1$2$3--$4/gs;
  $$TextBody=~s/$regx{pagePrefix}$regx{optionalSpace}([0-9]+) ([\-]+) ([0-9]+)/$1$2$3$4$5/gs;
  $$TextBody=~s/([\w]+)\:([A-Z][a-z]+[\w ]+)\, $regx{year}([\.]?)<\/bib>/$1\: $2\, $3$4<\/bib>/gs;
  $$TextBody=~s/<bib([^<>]+?)>$regx{mAuthorFullSirName}\.\, $regx{firstName}([\,\:\;] )/<bib$1>$2\, $3$4/gs;
  $$TextBody=~s/ etal([\.\,])/ et al$1/gs;
  $$TextBody=~s/$regx{mAuthorFullSirName}\,\,\s?$regx{firstName}([\,\;]|\. )/$1\, $2$3/gs;

  $$TextBody=~s/\b([dD][oO][iI])\s?\: (\d\w)/$1:$2/gs; ####DOI : and space closeup*****

  

 # select(undef, undef, undef, $sleep2);

  #$$TextBody=~s/ \-\<http://www.jedec.org/sites/default/files/docs/JESD5151_1.pdf>\.<\/bib>//gs;

  # print $$TextBody;
  # exit;
 return $$TextBody;
}

##########################################

return 1;