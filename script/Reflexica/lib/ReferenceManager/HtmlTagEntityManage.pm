#version 1.0.4)
#Author: Neyaz Ahmad
package ReferenceManager::HtmlTagEntityManage;
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(HtmlEntitytoTag HtmlTagToEntity);

sub HtmlEntitytoTag
{
    my $FileText=shift;


    $$FileText=~s/\&lt\;bib id=\&quot\;([a-zA-Z0-9\-\_\/\:\.\\\(\)]+)\&quot\;\&gt\;([ ]*)/<bib id=\"$1\">/gs;
    $$FileText=~s/\&lt\;bib id=\&quot\;([a-zA-Z0-9\-\_\/\:\.\\\(\)]+)\&quot\; type=\&quot\;([a-zA-Z0-9 \-\_ ]+)\&quot\;\&gt\;\&lt\;number\&gt\;([\(\)\[\]a-zA-Z0-9\.]+)\&lt\;\/number\&gt\;([ ]*)/<bib id=\"$1\" type=\"$2\" number=\"$3\">/gs;
    $$FileText=~s/\&lt\;bib id=\&quot\;([a-zA-Z0-9\-\_\/\:\.\\\(\)]+)\&quot\; type=\&quot\;([a-zA-Z0-9 \-\_ ]+)\&quot\;\&gt\;&lt;number&gt;([\[\]\(\)a-zA-Z0-9\.]+)&lt;\/number&gt;([ ]*)/<bib id=\"$1\" type=\"$2\" number=\"$3\">/gs;


    $$FileText=~s/\&lt\;bib id=\&quot\;([a-zA-Z0-9\-\_\/\:\.\\\(\)]+)\&quot\; type=\&quot\;([a-zA-Z0-9 \-\_ ]+)\&quot\;\&gt\;([ ]*)/<bib id=\"$1\" type="$2">/gs;
    $$FileText=~s/\&lt\;bib id=\&quot\;([a-zA-Z0-9\-\_\/\:\.\\\(\)]+)\&quot\; label=\&quot\;([^\=]*?)\&quot\; type=\&quot\;([a-zA-Z0-9\-\_ ]+)\&quot\;\&gt\;([ ]*)/<bib id=\"$1\" label=\"$2\" type=\"$3\">/gs;
    $$FileText=~s/\&lt\;bib\&gt\;/<bib>/gs;
    $$FileText=~s/\&lt\;\/bib\&gt\;/<\/bib>/gs;

#-------------

    $$FileText=~s/\&lt\;bib id=\"(bib[a-zA-Z0-9\-\_\/\:\.\\\(\)]+)\"\&gt\;/<bib id=\"$1\">/gs;

    $$FileText=~s/\&lt\;bib id=\"([a-zA-Z0-9\-\_\/\:\.\\\(\)]+)\" type=\"([a-zA-Z0-9 \-\_ ]+)\"\&gt\;\&lt\;number\&gt\;([\[\]\(\)a-zA-Z0-9\.]+)\&lt\;\/number\&gt\;([ ]*)/<bib id=\"$1\" type=\"$2\" number=\"$3\">/gs;
    $$FileText=~s/\&lt\;bib id=\"([a-zA-Z0-9\-\_\/\:\.\\\(\)]+)\" label=\"([^\=]*?)\" type=\"([a-zA-Z0-9\-\_ ]+)\"\&gt\;([ ]*)/<bib id=\"$1\" label=\"$2\" type=\"$3\">/gs;
    $$FileText=~s/\&lt\;bib id=\"([a-zA-Z0-9\-\_\/\:\.\\\(\)]+)\" type=\"([a-zA-Z0-9 \-\_ ]+)\"\&gt\;([ ]*)/<bib id=\"$1\" type="$2">/gs;
#--------------

    $$FileText=~s/<span lang=([a-zA-Z\-]+)([\s]*)style=\'font-family\:([\s]*)\"([a-zA-Z0-9 ]+)\";([\s]*)color\:([a-zA-Z0-9\#]+)\'><bib([^\<\>]*?)><\/span>/<bib$7>/gs;
    $$FileText=~s/<span lang=([a-zA-Z\-]+)([\s]*)style=\'color\:([a-zA-Z0-9\#]+)\'><bib([^\<\>]*?)><\/span>/<bib$4>/gs;
    $$FileText=~s/<span style=\'color\:([a-zA-Z0-9\#]+)\'><bib([^\<\>]*?)><\/span>/<bib$2>/gs;
    $$FileText=~s/<span lang=([a-zA-Z\-]+)([\s]*)style=\'font-family\:([\s]*)\"([a-zA-Z0-9 ]+)\";([\s]*)color\:([a-zA-Z0-9\#]+)\'><\/bib><\/span>/<\/bib>/gs;
    $$FileText=~s/<span lang=([a-zA-Z\-]+)([\s]*)style=\'color\:([a-zA-Z0-9\#]+)\'><\/bib><\/span>/<\/bib>/gs;
    $$FileText=~s/<span style=\'color\:([a-zA-Z0-9\#]+)\'><\/bib><\/span>/<\/bib>/gs;
    $$FileText=~s/<span lang=([a-zA-Z\-]+)>((?:(?!<span [^<>]+?>)(?!<\/span>).)*)<\/span>/$2/gs;  #####**** check spans.......
    $$FileText=~s/<span\s+([^<>]+?)><bib([^<>]*?)>((?:(?!<bib[^<>]*?>)(?!<\/bib>).)*)<\/bib><\/span>/<bib$2>$3<\/bib>/gs;
    $$FileText=~s/([\s]+)<\/span>/<\/span>$1/gs;

    $$FileText=~s/&lt;(aug|edrg|iss|at|pt|cny|cty|pbl|pg|st|v|yr|url|ia|misc1|issn|isbn|coden|doi|edn|collab|bt|proc|rpt|thesis|pat|org|eml|pco|pbo|st|rol|tel|fax|comment)&gt;/<$1>/gs;
    $$FileText=~s/&lt;\/(aug|edrg|iss|at|pt|cny|cty|pbl|pg|st|v|yr|url|ia|misc1|issn|isbn|coden|doi|edn|collab|bt|proc|rpt|thesis|pat|org|eml|pco|pbo|st|rol|tel|fax|comment)&gt;/<\/$1>/gs;
    $$FileText=~s/<(b|i|u|sup|sub|sb|sp)>/&lt;$1&gt;/gs;
    $$FileText=~s/<\/(b|i|u|sup|sub|sb|sp)>/&lt;\/$1&gt;/gs;

    return $$FileText;
}
#=======================================================================================================================================
sub HtmlTagToEntity
{
   my $FileText=shift;

   $$FileText=~s/<bib id=\"([a-zA-Z0-9\-\_\/\:\.\\\(\)]+)\" label=\"([^\=\"]*?)\" type=\"([a-zA-Z0-9\-\_ ]+)\">/\&lt\;bib id=\&quot\;$1\&quot\; label=\&quot\;$2\&quot\; type=\&quot\;$3\&quot\;\&gt\;/gs;
   $$FileText=~s/<bib id=\"([a-zA-Z0-9\-\_\/\:\.\\\(\)]+)\" type=\"([a-zA-Z0-9\-\_ ]+)\">/\&lt\;bib id=\&quot\;$1\&quot\; type=\&quot\;$2\&quot\;\&gt\;/gs;
   $$FileText=~s/\&lt\;bib id=\"([a-zA-Z0-9\-\_\/\:\.\\\(\)]+)\" label=\"([^\=\"]*?)\" type=\"([a-zA-Z0-9\-\_ ]+)\"\&gt\;/\&lt\;bib id=\&quot\;$1\&quot\; label=\&quot\;$2\&quot\; type=\&quot\;$3\&quot\;\&gt\;/gs;

   $$FileText=~s/\&lt\;bib id=\"([a-zA-Z0-9\-\_\/\:\.\\\(\)]+)\" type=\"([a-zA-Z0-9\-\_ ]+)\" number=\"([\[\]\(\)a-zA-Z0-9\.]+)\"&gt;/\&lt\;bib id=\&quot\;$1\&quot\; type=\&quot\;$2\&quot\;\&gt\;&lt;number&gt;$3&lt;\/number&gt;/gs;
   $$FileText=~s/\&lt\;bib id=\"([a-zA-Z0-9\-\_\/\:\.\\\(\)]+)\" type=\"([a-zA-Z0-9\-\_ ]+)\"\&gt\;/\&lt\;bib id=\&quot\;$1\&quot\; type=\&quot\;$2\&quot\;\&gt\;/gs;
   $$FileText=~s/\&lt\;bib id=\"bib([a-zA-Z0-9\-\_\/\:\.\\\(\)]+)\"\&gt\;/\&lt\;bib id=\&quot\;bib$1\&quot\;\&gt\;/gs;
   $$FileText=~s/<bib>/\&lt\;bib\&gt\;/gs;
   $$FileText=~s/<\/bib>/\&lt\;\/bib\&gt\;/gs;
   $$FileText=~s/<(au|edr|aug|auf|aus|eds|edf|par|prefix|aum|edm|edrg|iss|at|pt|s|m|f|cny|cty|pbl|pg|st|v|yr|url|ia|misc1|issn|isbn|coden|doi|edn|collab|bt|proc|suffix|rpt|thesis|pat|org|eml|pco|pbo|st|rol|tel|fax)>/&lt;$1&gt;/gs;
   $$FileText=~s/<\/(au|edr|aug|auf|aus|eds|edf|par|prefix|aum|edm|edrg|iss|at|pt|s|m|f|cny|cty|pbl|pg|st|v|yr|url|ia|misc1|issn|isbn|coden|doi|edn|collab|bt|proc|suffix|rpt|thesis|pat|org|eml|pco|pbo|st|rol|tel|fax)>/&lt;\/$1&gt;/gs;

   return $$FileText;
}


return 1;

