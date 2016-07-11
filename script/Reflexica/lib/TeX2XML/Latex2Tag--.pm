# TeX2XML::latex2tag
#
# Author: Neyaz Ahmad 2013.
# Version: 0.1

package TeX2XML::Latex2Tag;

use strict;
require Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw( name2numbered name2utf8 normalizeLatex2Tag);
our $VERSION = '0.1';

our %TAGS = (
	     '\chapter' => 'chaptertitle',
	     '\title' => 'chaptertitle',
	     '\secondtitle' => 'chapterSecondTitle',
	     '\subtitle' => 'chaptersubtitle',
	     '\selectlanguage' => 'chapterlanguage',
	     '\author' => 'author',
	     '\institute' => 'address',
	     '\abstract' => 'abstract',
	     '\gabstract' => 'gabstract',
	     '\abstract*' => 'abstract-online',
	     '\gabstract*' => 'gabstract-online',
	     '\keywords' => 'keywords',
	     '\gkeywords' => 'gkeywords',
	     '\keywords*' => 'keywords-online',
	     '\gkeywords*' => 'gkeywords-online',
	     '\jel' => 'jel',
	     '\subclassname' => 'jel',
	     '\jclass' => 'jel',
	     '\doi' => 'doi',
	     '\slname' => 'slname',
	     '\sltitle' => 'sltitle',
	     '\sltitcont' => 'sltitcont',
	     '\scpline' => 'scpline',
	     '\cpline' => 'scpline',
	     '\cpyear' => 'cpyear',
	     '\received' => 'received',
	     '\accepted' => 'accepted',
	     '\published' => 'published',
	     '\sluginfo' => 'sluginfo',
	     '\section' => 'section',
	     '\AQsection' => 'AQsection',
	     '\subsection' => 'section2',
	     '\subsubsection' => 'section3',
	     '\subsubsubsection' => 'section4',
	     '\csection' => 'section',
	     '\csubsection' => 'section2',
	     '\csubsubsection' => 'section3',
	     '\csubsubsubsection' => 'section4',
	     '\section*' => 'section-unnumber',
	     '\subsection*' => 'section2-unnumber',
	     '\subsubsection*' => 'section3-unnumber',
	     '\subsubsubsection*' => 'section4-unnumber',
	     '\paragraph' => 'section5',
	     '\subparagraph' => 'section6',
	     '\subsubparagraph' => 'section7',
	     '\footnote' => 'footnote',
	     '\endnote' => 'endnote',
	     '\runningtitle' => 'runninghead',
	     '\titlerunning' => 'runninghead',
	     '\markboth' => 'runninghead',
	     '\index' => 'index-term',
	     '\label' => 'label',
	     '\ref' => 'ref',
	     '\xref' => 'xref',
	     '\href' => 'href',
	     '\cite'=> 'cite',
	     '\cathead'=> 'cathead',
	     '\citeyear'=> 'citeyear',
	     '\citealp'=> 'citealp',
	     '\citeyearpar'=> 'citeyearpar',
	     '\citep'=> 'citep',
	     '\caption'=> 'caption',
	     '\tbl'=> 'caption',
	     '\epsfbox'=> 'imageobject',
	     '\figurebox'=> 'imageobject',
	     '\showtiff'=> 'imageobject',
	     '\marginnote'=> 'marginnote',
	     '\marginpar'=> 'marginpar',
	     '\articlenote' => 'articleNote',
	     '\refsubheading' => 'bibSubSection',
	     '\enunhead' => 'enunhead',
	     # '\org' => 'orgdivision',
	     # '\inst' => 'orgname',
	     # '\street' => 'street',
	     # '\postbox' => 'postbox',
	     # '\postcode' => 'postcode',
	     # '\city' => 'city',
	     # '\state' => 'state',
	     # '\country' => 'country',
	     # '\email' => 'email',

	    );
#==============================================================================


#Here { barce replace to <cur1>
		     # '\begin<cur1>abstract</cur1>' => 'abstract',
		     # '\begin<cur1>abstract*</cur1>' => 'abstract-online',
		     # '\begin<cur1>gabstract</cur1>' => 'gabstract',
		     # '\begin<cur1>gabstract*</cur1>' => 'gabstract-online',
		     # '\begin<cur1>noabstract</cur1>' => 'abstract-online',
		     # '\begin<cur1>keywords</cur1>' => 'keywords',
		     # '\begin<cur1>keywords*</cur1>' => 'keywords-online',
		     # '\begin<cur1>gkeywords</cur1>' => 'gkeywords',
		     # '\begin<cur1>nokeywords</cur1>' => 'keywords-online',

our %beginEndTags = (
		     '\begin<cur1>subclassname</cur1>' => 'jel',
		     '\begin<cur1>tippwh</cur1>' => 'tippwh',
		     '\begin<cur1>table</cur1>' => 'table',
		     '\begin<cur1>table*</cur1>' => 'table-textwidth',
		     '\begin<cur1>tabnote</cur1>' => 'tfooter',
		     '\begin<cur1>sidewaystable</cur1>' => 'table',
		     '\begin<cur1>tabular</cur1>' => 'tabular',
		     '\begin<cur1>tabular*</cur1>' => 'tabular-textwidth',
		     '\begin<cur1>figure</cur1>' => 'figure',
		     '\begin<cur1>sidewaysfigure</cur1>' => 'figure',
		     '\begin<cur1>equation</cur1>' => 'equation',
		     '\begin<cur1>equation*</cur1>' => 'equation-unnumber',
		     '\begin<cur1>eqnarray</cur1>' => 'equation-eqnarray',
		     '\begin<cur1>eqnarray*</cur1>' => 'equation-eqnarray-unnumber',
		     '\begin<cur1>array</cur1>' => 'equation-array',
		     '\begin<cur1>array*</cur1>' => 'equation-array-unnumber',
		     '\begin<cur1>displaymath</cur1>' => 'equation-align',
		     '\begin<cur1>displaymath*</cur1>' => 'equation-align-unnumber',
		     '\begin<cur1>align</cur1>' => 'equation-align',
		     '\begin<cur1>align*</cur1>' => 'equation-align-unnumber',
		     '\begin<cur1>aligned</cur1>' => 'equation-aligned',
		     '\begin<cur1>aligned*</cur1>' => 'equation-aligned-unnumber',
		     '\begin<cur1>center</cur1>' => 'equation-center-unnumber',
		     '\begin<cur1>gather</cur1>' => 'equation-gather',
		     '\begin<cur1>gather*</cur1>' => 'equation-gather-unnumber',
		     '\begin<cur1>algorithm</cur1>' => 'equation-algorithm',
		     '\begin<cur1>subequations</cur1>' => 'equation-sub',
		     '\begin<cur1>indentation</cur1>' => 'lists-bullet',
		     '\begin<cur1>itemize</cur1>' => 'lists-bullet',
		     '\begin<cur1>bulletlist</cur1>' => 'lists-bullet',
		     '\begin<cur1>enumerate</cur1>' => 'lists-numbered',
		     '\begin<cur1>arabiclist</cur1>' => 'lists-numbered',
		     '\begin<cur1>description</cur1>' => 'lists-unnumbered',
		     '\begin<cur1>unnumlist</cur1>' => 'lists-bullet',
		     '\begin<cur1>quotation</cur1>' => 'blockquote',
		     '\begin<cur1>quote</cur1>' => 'blockquote',
		     '\begin<cur1>extract</cur1>' => 'blockquote',
		     '\begin<cur1>overviewwh</cur1>' => 'overviewwh',
		     '\begin<cur1>backgroundwh</cur1>' => 'backgroundwh',
		     '\begin<cur1>legaltext</cur1>' => 'legaltext',
		     '\begin<cur1>programcode</cur1>' => 'programcode',
		     '\begin<cur1>petit</cur1>' => 'blockquote',
		     '\begin<cur1>motto</cur1>' => 'motto',
		     '\begin<cur1>moto</cur1>' => 'motto',
		     '\begin<cur1>acknowledgement</cur1>' => 'acknowledgement',
		     '\begin<cur1>acknowledgements</cur1>' => 'acknowledgements',
		     '\begin<cur1>acknowledgment</cur1>' => 'acknowledgment',
		     '\begin<cur1>acknowledgments</cur1>' => 'acknowledgments',
		     '\begin<cur1>thebibliography</cur1>' => 'bibliography',
		     '\begin<cur1>bibliography</cur1>' => 'bibliography',
		     '\begin<cur1>lemma</cur1>' => 'lemma',
		     '\begin<cur1>remark</cur1>' => 'remark',
		     '\begin<cur1>proof</cur1>' => 'proof',
		     '\begin<cur1>theorem</cur1>' => 'theorem',
		     '\begin<cur1>note</cur1>' => 'note',
		     '\begin<cur1>example</cur1>' => 'example',
		     '\begin<cur1>conclusion</cur1>' => 'conclusion',
		     '\begin<cur1>boxhead</cur1>' => 'boxhead',
		     '\begin<cur1>defwh</cur1>' => 'defwh',
		     '\begin<cur1>graybox</cur1>' => 'overview',
		     '\begin<cur1>overview</cur1>' => 'overview',
		     '\begin<cur1>background</cur1>' => 'background',
		     '\begin<cur1>definition</cur1>' => 'definition',
		     '\begin<cur1>claim</cur1>' => 'claim',
		     '\begin<cur1>case</cur1>' => 'case',
		     '\begin<cur1>corollary</cur1>' => 'corollary',
		     '\begin<cur1>proposition</cur1>' => 'proposition',
		     '\begin<cur1>observation</cur1>' => 'observation',
		     '\begin<cur1>prob</cur1>' => 'prob',
		     '\begin<cur1>exercises</cur1>' => 'exercises',
		     '\begin<cur1>korollar</cur1>' => 'korollar',
		     '\begin<cur1>property</cur1>' => 'property',
		     '\begin<cur1>bemerkungen</cur1>' => 'bemerkungen',
		     '\begin<cur1>aufgabe</cur1>' => 'aufgabe',
		     '\begin<cur1>assumption</cur1>' => 'assumption',
		     '\begin<cur1>conjecture</cur1>' => 'conjecture',
		     '\begin<cur1>resultat</cur1>' => 'resultat',
		     '\begin<cur1>beispiele</cur1>' => 'beispiele',
		     '\begin<cur1>beweis</cur1>' => 'beweis',
		     '\begin<cur1>notation</cur1>' => 'notation',
		     '\begin<cur1>beispiel</cur1>' => 'beispiel',
		     '\begin<cur1>Beispiel</cur1>' => 'Beispiel',
		     '\begin<cur1>tipp</cur1>' => 'tipp',
		     '\begin<cur1>multiconclusion</cur1>' => 'multiconclusion',
		     '\begin<cur1>satz</cur1>' => 'satz',
		     '\begin<cur1>definitionenv</cur1>' => 'definitionenv',
		    );

#\\begin(table|equation|center|subequations|quote|align|array|eqnarray|sidewaysfigure|description|enumerate|itemize)



#====================================================================================


our %formatingsTAGS = (
		       '\it' => 'i',
		       '\em' => 'i',
		       '\emph' => 'i',
		       '\textit' => 'i',
		       '\mathit' => 'i',
		       '\itshape'=> 'i',
		       '\bf' => 'b',
		       '\textbf' => 'b',
		       '\mathbf' => 'b',
		       '\bm' => 'bi',
		       '\bi' => 'bi',
		       '\textsc' => 'sc',
		       '\sc' => 'sc',
		       '\tt' => 'tt',
		       '\sf' => 'sf',
		       '\underline' => 'u',
		       '\rm' => 'rm' 
	     );
#==============================================================================
sub new {
    my $class = shift;
    my $self = bless {}, $class;

    my %args = @_;
    $self->{TeXData} = $args{TeXData};

    bless $self, $class;
    return $self;
}
#===============================================================================

sub normalizeLatex2Tag{
    my $self = shift;
    my $TeXData= $self->{TeXData};                              #  print  ${$self->{TeXData}};

    foreach my $latextag (keys(%TAGS)){
      my $templatextag=$latextag;
      $templatextag=~s/\\/\\\\/gs;
      $templatextag=~s/\*/\\\*/gs;
      ${$TeXData}=~s/$templatextag([ ]*)<cur([0-9]+)>(.*?)<\/cur\2>/<$TAGS{$latextag}>$3<\/$TAGS{$latextag}>/gs;
    }
    ${$TeXData}=~s/\\begin([\s]*)<cur1>/\\begin<cur1>/gs;
    ${$TeXData}=~s/\\end([\s]*)<cur1>/\\end<cur1>/gs;
    ${$TeXData}=~s/<dispEquation>(.*?)<\/dispEquation>/<equation-unnumber>$1<\/equation-unnumber>/gs;
    foreach my $latextag (keys(%beginEndTags)){
      my $beginlatextag=$latextag;
      $beginlatextag=~s/\\/\\\\/gs;
      $beginlatextag=~s/\*/\\\*/gs;
      $beginlatextag=~s/\//\\\//gs;
      my $endlatextag=$beginlatextag;
      $endlatextag=~s/\\begin/\\end/gs;
      #${$TeXData}=~s/${beginlatextag}(.*?)${endlatextag}/<$beginEndTags{$latextag}>$1<\/$beginEndTags{$latextag}>/gs; #***********
      ${$TeXData}=~s/${beginlatextag}((?:(?!${beginlatextag})(?!${endlatextag}).)+?)${endlatextag}/<$beginEndTags{$latextag}>$1<\/$beginEndTags{$latextag}>/gs;
      ${$TeXData}=~s/${beginlatextag}((?:(?!${beginlatextag})(?!${endlatextag}).)+?)${endlatextag}/<$beginEndTags{$latextag}>$1<\/$beginEndTags{$latextag}>/gs;
      ${$TeXData}=~s/${beginlatextag}((?:(?!${beginlatextag})(?!${endlatextag}).)*?)${endlatextag}/<$beginEndTags{$latextag}>$1<\/$beginEndTags{$latextag}>/gs;

#((?:(?!<index>)(?!<\/index>).)*)
      #print "$beginlatextag$1$endlatextag => <$beginEndTags{$latextag}>$1<\/$beginEndTags{$latextag}>\n";
    }
    #------------------------------------------

    ${$TeXData}=~s/\\(begin|end)<cur1>X(aligned[\*]?|align[\*]?|array[\*]?)<\/cur1>/\\$1<cur1>$2<\/cur1>/gs;  #Xarray =>array
    #Bibitem normlise #\\bibitem to <bib></bib>

    ${$TeXData}=~s/\\bibitem(.*?)\n/<bib>$1<\/bib>\n/gs;

     $TeXData=convertTeXToXMLEntity($TeXData);

    use TeX2XML::manageEquations;
     ($TeXData, my $EquationTable)=&TeX2XML::manageEquations::equationsHide($TeXData);

    $TeXData=convertTextTeXToXMLEntity($TeXData);

    $TeXData=&FormatingsTagNormalize($TeXData);

    $TeXData=&TeX2XML::manageEquations::equationsRevert($TeXData, $EquationTable);

    return $TeXData;
  }
#=========================================================================================================


#    my ($TextBody, $Symboltable)=&SymbolFonts($TextBody);  #Store Symbal in Hash Ref 

# sub EquationsHide{
#   my $TeXData = shift;
#   my $ID=0;
#   my %EqTable=();
#   my $EqTableref="";

#   #<equation></equation>
#   #<inlineEquation>c</inlineEquation>

#     while(${$TeXData}=~/<equation([\-a-z]*)>(.*?)<\/equation\1>/s)
#       {
#     	my $equation="<equation$1>$2<\/equation$1>";
#     	${$TeXData}=~s/<equation([\-a-z]*)>(.*?)<\/equation\1>/&\#X$ID;/os;
#     	$EqTable{$ID}="$equation";
#     	$ID++;
#       }

#   while(${$TeXData}=~/<inlineEquation>(.*?)<\/inlineEquation>/s)
#     {
#       my $equation="<inlineEquation>$1<\/inlineEquation>";
#       ${$TeXData}=~s/<inlineEquation>(.*?)<\/inlineEquation>/&\#X$ID;/os;
#       $EqTable{$ID}="$equation";
#     	$ID++;
#     }


#     $EqTableref=\%EqTable;

#   return ($TeXData, $EqTableref);
# }
#==================================================================================================================================


sub FormatingsTagNormalize
  {
    my $TeXData = shift;
    ${$TeXData}=~s/\\\/<\/cur([0-9]+)>/<\/cur$1>/gs;
    ${$TeXData}=~s/\\(em|emph|it|textit|sc|rm|bf|mathbf|mathit|mbox|hbox|underbar|itshape|textbf|tt|sf)([\s]*)<cur([0-9]+)>/\\$1<cur$3>/gs;
    ${$TeXData}=~s/<cur([0-9]+)>([\s]*)\\(em|emph|it|textit|sc|rm|bf|mathbf|mathit|mbox|hbox|underbar|itshape|textbf|tt|sf) /\\$3<cur$1>/gs;
    ${$TeXData}=~s/([ >][\w\.\,\;]+[ ]?)<cur(\d)>((?:(?!<cur\2>)(?!<\/cur\2>).)*)<\/cur\2>/$1$3/gs;  ####check

    foreach my $latextag (keys(%formatingsTAGS))
      {
	my $templatextag=$latextag;
	$templatextag=~s/\\/\\\\/gs;
	${$TeXData}=~s/$templatextag<cur1>(.*?)<\/cur1>/<$formatingsTAGS{$latextag}>$1<\/$formatingsTAGS{$latextag}>/gs;
	${$TeXData}=~s/$templatextag<cur2>(.*?)<\/cur2>/<$formatingsTAGS{$latextag}>$1<\/$formatingsTAGS{$latextag}>/gs;
	${$TeXData}=~s/$templatextag<cur([0-9]+)>(.*?)<\/cur\1>/<$formatingsTAGS{$latextag}>$2<\/$formatingsTAGS{$latextag}>/gs;
      }

    $TeXData=&checkFormatingsTag($TeXData); #check formating tag inside tag

    return $TeXData;
  }

#==================================================================================================================================

sub convertTeXToXMLEntity{
  my $TeXData=shift;

  ${$TeXData}=~s/<inlineEquation>\\backslash<\/inlineEquation>/\//gs;
  ${$TeXData}=~s/<inlineEquation>\-([0-9\.]+)<\/inlineEquation>/\&\#x2212\;$1/gs;
  ${$TeXData}=~s/<inlineEquation>\+([0-9\.]+)<\/inlineEquation>/\&\#x002B\;$1/gs;
  ${$TeXData}=~s/<inlineEquation>([a-zA-Z])\-([0-9\.]+)<\/inlineEquation>/<i>$1<\/i>\&\#x2009\;\&\#x2212\;\&\#x2009\;$2/gs;
  ${$TeXData}=~s/<inlineEquation>([a-zA-Z])\+([0-9\.]+)<\/inlineEquation>/<i>$1<\/i>\&\#x2009\;\&\#x002B\;\&\#x2009\;$2/gs;
  ${$TeXData}=~s/<inlineEquation>\s*\\ilambda\s*<\/inlineEquation>/<i>\&\#x03BB\;<\/i>/gs;
  ${$TeXData}=~s/<inlineEquation>\s*\\ilambda\s*\\\,\s*\=\s*\\\,\s*<\/inlineEquation>/<i>\&\#x03BB\;<\/i>\&\#x2009\;\&\#x003D\;\&\#x2009\;/gs;
  ${$TeXData}=~s/<inlineEquation>\s*\\ilambda\s*\\\,\s*\+\s*\\\,\s*<\/inlineEquation>/<i>\&\#x03BB\;<\/i>\&\#x2009\;\&\#x002B\;\&\#x2009\;/gs;
  ${$TeXData}=~s/<inlineEquation>\s*\\ilambda\s*\\\,\s*\-\s*\\\,\s*<\/inlineEquation>/<i>\&\#x03BB\;<\/i>\&\#x2009\;\&\#x2212\;\&\#x2009\;/gs;
  ${$TeXData}=~s/<inlineEquation>\s*\\ilambda\s*\\\,\s*\\times\s*\\\,\s*<\/inlineEquation>/<i>\&\#x03BB\;<\/i>\&\#x2009\;\&\#x00D7\;\&\#x2009\;/gs;
  ${$TeXData}=~s/<inlineEquation>\^\\prime\s*\\\,\s*\=\\\,\s*<\/inlineEquation>/\&\#x2032\;\&\#x2009\;\&\#x003D\;\&\#x2009\;/gs;
  ${$TeXData}=~s/<inlineEquation>\^\\prime\s*\\\,\s*\+\\\,\s*<\/inlineEquation>/\&\#x2032\;\&\#x2009\;\&\#x002B\;\&\#x2009\;/gs;
  ${$TeXData}=~s/<inlineEquation>\^\\prime\s*\\\,\s*\-\\\,\s*<\/inlineEquation>/\&\#x2032\;\&\#x2009\;\&\#x2212\;\&\#x2009\;/gs;
  ${$TeXData}=~s/<inlineEquation>\^\\prime\s*\\\,\s*\\times\\,\s*<\/inlineEquation>/\&\#x2032\;\&\#x2009\;\&\#x00D7\;\&\#x2009\;/gs;
  $$TeXData=~s/<inlineEquation>\s*\\\,\s*\=\s*\\\,\s*<\/inlineEquation>/\&\#x2009\;\&\#x003D\;\&\#x2009\;/gs;
  $$TeXData=~s/<inlineEquation>\s*\\\;\s*\=\s*\\\;\s*<\/inlineEquation>/\&\#x2009\;\&\#x003D\;\&\#x2009\;/gs;
  $$TeXData=~s/<inlineEquation>\s+=\s+<\/inlineEquation>/\&\#x2009\;\&\#x003D\;\&\#x2009\;/gs;
  $$TeXData=~s/<inlineEquation>\=<\/inlineEquation>/\&\#x003D\;/gs;

  $$TeXData=~s/<inlineEquation>\s*\\\,\s*\+\s*\\\,\s*<\/inlineEquation>/\&\#x2009\;\&\#x002B\;\&\#x2009\;/gs;
  $$TeXData=~s/<inlineEquation>\s*\\\;\s*\+\s*\\\;\s*<\/inlineEquation>/\&\#x2009\;\&\#x002B\;\&\#x2009\;/gs;
  $$TeXData=~s/<inlineEquation>\s+\+\s+<\/inlineEquation>/\&\#x2009\;\&\#x002B\;\&\#x2009\;/gs;
  $$TeXData=~s/<inlineEquation>\+<\/inlineEquation>/\&\#x002B\;/gs;

  $$TeXData=~s/<inlineEquation>\s*\\\,\s*\-\s*\\\,\s*<\/inlineEquation>/\&\#x2009\;\&\#x2212\;\&\#x2009\;/gs;
  $$TeXData=~s/<inlineEquation>\s*\\\;\s*\-\s*\\\;\s*<\/inlineEquation>/\&\#x2009\;\&\#x2212\;\&\#x2009\;/gs;
  $$TeXData=~s/<inlineEquation>\s+\-\s+<\/inlineEquation>/\&\#x2009\;\&\#x2212\;\&\#x2009\;/gs;
  $$TeXData=~s/<inlineEquation>\-<\/inlineEquation>/\&\#x2212\;/gs;

  $$TeXData=~s/<inlineEquation>\s*\\\,\s*\\times\s*\\\,\s*<\/inlineEquation>/&#x2009;&#x00D7;&#x2009;/gs;
  $$TeXData=~s/<inlineEquation>\s*\\\;\s*\\times\s*\\\;\s*<\/inlineEquation>/&#x2009;&#x00D7;&#x2009;/gs;
  $$TeXData=~s/<inlineEquation>\s+\\times\s+<\/inlineEquation>/&#x2009;&#x00D7;&#x2009;/gs;
  $$TeXData=~s/<inlineEquation>\\times<\/inlineEquation>/&#x00D7;/gs;

  $$TeXData=~s/<inlineEquation>\s*\\\,\s*\<\s*\\\,\s*<\/inlineEquation>/\&\#x2009\;\&\#x003C\;\&\#x2009\;/gs;
  $$TeXData=~s/<inlineEquation>\s*\\\;\s*\<\s*\\\;\s*<\/inlineEquation>/\&\#x2009\;\&\#x003C\;\&\#x2009\;/gs;
  $$TeXData=~s/<inlineEquation>\s+\<\s+<\/inlineEquation>/\&\#x2009\;\&\#x003C\;\&\#x2009\;/gs;
  $$TeXData=~s/<inlineEquation>\<<\/inlineEquation>/\&\#x003C\;/gs;

  $$TeXData=~s/<inlineEquation>\s*\\\,\s*\>\s*\\\,\s*<\/inlineEquation>/\&\#x2009\;\&\#x003E\;\&\#x2009\;/gs;
  $$TeXData=~s/<inlineEquation>\s*\\\;\s*\>\s*\\\;\s*<\/inlineEquation>/\&\#x2009\;\&\#x003E\;\&\#x2009\;/gs;
  $$TeXData=~s/<inlineEquation>\s+\>\s+<\/inlineEquation>/\&\#x2009\;\&\#x003E\;\&\#x2009\;/gs;
  $$TeXData=~s/<inlineEquation>\><\/inlineEquation>/\&\#x003E\;/gs;

  ${$TeXData}=~s/<inlineEquation>\_(\\rm)*\s*([0-9\-\.]+)\\\,<cur1>\\\%<\/cur1><\/inlineEquation>/<sub><rm>$2\&\#x2009\;\&\#x0025\;<\/rm><\/sub>/gs;
  ${$TeXData}=~s/<inlineEquation>\^(\\rm)*\s*([0-9\-\.]+)\\\,<cur1>\\\%<\/cur1><\/inlineEquation>/<sup><rm>$2\&\#x2009\;\&\#x0025\;<\/rm><\/sup>/gs;
  ${$TeXData}=~s/<inlineEquation>\_\\rm\s+([a-zA-Z\.0-9\-]+)\s*<\/inlineEquation>/<sub><rm>$1<\/rm><\/sub>/gs;
  ${$TeXData}=~s/<inlineEquation>\^\\rm\s+([a-zA-Z\.0-9\-]+)\s*<\/inlineEquation>/<sup><rm>$1<\/rm><\/sup>/gs;


  ${$TeXData}=~s/<inlineEquation>\_<cur1>\\it\s+([a-zA-Z\.0-9\-]+)<\/cur1><\/inlineEquation>/<sub><i>$1<\/i><\/sub>/gs;
  ${$TeXData}=~s/<inlineEquation>\^<cur1>\\it\s+([a-zA-Z\.0-9\-]+)<\/cur1><\/inlineEquation>/<sup><i>$1<\/i><\/sup>/gs;
  ${$TeXData}=~s/<inlineEquation>\_<cur1>\s+([\-\.0-9]+)<\/cur1><\/inlineEquation>/<sub>$1<\/sub>/gs;
  ${$TeXData}=~s/<inlineEquation>\^<cur1>\s+(\-\.0-9]+)<\/cur1><\/inlineEquation>/<sup>$1<\/sup>/gs;
  ${$TeXData}=~s/<inlineEquation>\_<cur1>\s+([a-zA-Z\.\-]+)<\/cur1><\/inlineEquation>/<sub><i>$1<\/i><\/sub>/gs;
  ${$TeXData}=~s/<inlineEquation>\^<cur1>\s+([a-zA-Z\.\-]+)<\/cur1><\/inlineEquation>/<sup><i>$1<\/i><\/sup>/gs;
  ${$TeXData}=~s/<inlineEquation><cur1>([A-Za-z]+)<\/cur1><\/inlineEquation>/<i>$1<\/i>/gs;
  ${$TeXData}=~s/<inlineEquation>([a-zA-Z]+)\_<cur1>\\rm ([A-Za-z0-9\.\-]+)<\/cur1><\/inlineEquation>/<i>$1<\/i><sub>$2<\/sub>/gs;
  ${$TeXData}=~s/<inlineEquation>([a-zA-Z]+)\^<cur1>\\rm ([A-Za-z0-9\.\-]+)<\/cur1><\/inlineEquation>/<i>$1<\/i><sup>$2<\/sup>/gs;

  ${$TeXData}=~s/<inlineEquation>([a-zA-Z]+)\_<cur2>\\rm\s*<cur1>([A-Za-z0-9\.\-]+)<\/cur1><\/cur2><\/inlineEquation>/<i>$1<\/i><sub>$2<\/sub>/gs;
  ${$TeXData}=~s/<inlineEquation>([a-zA-Z]+)\^<cur2>\\rm\s*<cur1>([A-Za-z0-9\.\-]+)<\/cur1><\/cur2><\/inlineEquation>/<i>$1<\/i><sup>$2<\/sup>/gs;

  ${$TeXData}=~s/<inlineEquation><cur2>([a-zA-Z]+)\_<cur1>\\rm ([A-Za-z0-9\.\-]+)<\/cur1><\/cur2><\/inlineEquation>/<i>$1<\/i><sub>$2<\/sub>/gs;
  ${$TeXData}=~s/<inlineEquation><cur2>([a-zA-Z]+)\^<cur1>\\rm ([A-Za-z0-9\.\-]+)<\/cur1><\/cur2><\/inlineEquation>/<i>$1<\/i><sup>$2<\/sup>/gs;
  ${$TeXData}=~s/<inlineEquation><cur1>([a-zA-Z]+)<\/cur1>\_([A-Za-z]+)<\/inlineEquation>/<i>$1<\/i><sub><i>$2<\/i><\/sub>/gs;
  ${$TeXData}=~s/<inlineEquation><cur1>([a-zA-Z]+)<\/cur1>\^([A-Za-z]+)<\/inlineEquation>/<i>$1<\/i><sup><i>$2<\/i><\/sup>/gs;
  ${$TeXData}=~s/<inlineEquation><cur1>\\rm ([A-Za-z0-9\.\-]+)<\/cur1><\/inlineEquation>/$1/gs;

  $$TeXData=~s/<inlineEquation>\^<cur2>\\mbox<cur1>([0-9\.\,\-]+)<\/cur1><\/cur2><\/inlineEquation>/<sup>$1<\/sup>/gs;
  $$TeXData=~s/<inlineEquation>\\([a-zA-Z]+)\s*\_([a-zA-Z\,]+)<\/inlineEquation>/<inlineEquation>\\$1<\/inlineEquation><sub><i>$2<\/i><\/sub>/gs;
  $$TeXData=~s/<inlineEquation>\\([a-zA-Z]+)\s*\_([0-9\-\.\,]+)<\/inlineEquation>/<inlineEquation>\\$1<\/inlineEquation><sub>$2<\/sub>/gs;
  $$TeXData=~s/<inlineEquation>\\([a-zA-Z]+)\s*\^([a-zA-Z\,]+)<\/inlineEquation>/<inlineEquation>\\$1<\/inlineEquation><sup><i>$2<\/i><\/sup>/gs;
  $$TeXData=~s/<inlineEquation>\\([a-zA-Z]+)\s*\^([0-9\-\.\,]+)<\/inlineEquation>/<inlineEquation>\\$1<\/inlineEquation><sup>$2<\/sup>/gs;
  $$TeXData=~s/<inlineEquation>\s*\^<cur1>([0-9\-\.\,]+)<\/cur1><\/inlineEquation>/<sup>$1<\/sup>/gs;
  $$TeXData=~s/<inlineEquation>\s*\_<cur1>([0-9\-\.\,]+)<\/cur1><\/inlineEquation>/<sub>$1<\/sub>/gs;
  $$TeXData=~s/<inlineEquation>\s*\^([0-9\-\.\,]+)<\/inlineEquation>/<sup>$1<\/sup>/gs;
  $$TeXData=~s/<inlineEquation>\s*\_([0-9\-\.\,]+)<\/inlineEquation>/<sub>$1<\/sub>/gs;

  $$TeXData=~s/<inlineEquation>\s*\^<cur1>\\rm ([a-zA-Z0-9\-\.\,]+)<\/cur1><\/inlineEquation>/<sup>$1<\/sup>/gs;
  $$TeXData=~s/<inlineEquation>\s*\_<cur1>\\rm ([a-zA-Z0-9\-\.\,]+)<\/cur1><\/inlineEquation>/<sub>$1<\/sub>/gs;

  $$TeXData=~s/<inlineEquation>\s*\^<cur1>\\ast<\/cur1><\/inlineEquation>/\*/gs;
  $$TeXData=~s/<inlineEquation>\s*\^<cur2>\\textit<cur1>([a-zA-Z0-9\.\-]+)<\/cur1><\/cur2><\/inlineEquation>/<sup><i>$1<\/i><\/sup>/gs;
  $$TeXData=~s/<inlineEquation>\s*\_<cur2>\\textit<cur1>([a-zA-Z0-9\.\-]+)<\/cur1><\/cur2><\/inlineEquation>/<sub><i>$1<\/i><\/sub>/gs;

  $$TeXData=~s/<inlineEquation>\s*\^<cur2>\\(textit|textbf)<cur1>\\copyright<\/cur1><\/cur2><\/inlineEquation>/\&\#x00A9\;/gs;
  $$TeXData=~s/<inlineEquation>\s*\\boldsymbol\s*<cur1>\s*\\S<\/cur1><\/inlineEquation>/<b>\&\#x00A7\;<\/b>/gs;
  $$TeXData=~s/<inlineEquation><cur2>\s*\\boldsymbol\s*<cur1>\s*\\S<\/cur1><\/cur2><\/inlineEquation>/<b>\&\#x00A7\;<\/b>/gs;
  $$TeXData=~s/<inlineEquation>\\S<\/inlineEquation>/\&\#x00A7\;/gs;
  $$TeXData=~s/<inlineEquation>\_<cur1>\s*([A-Za-z\-\.]+)<\/cur1><\/inlineEquation>/<sub><i>$1<\/i><\/sub>/gs;
  $$TeXData=~s/<inlineEquation>\^<cur1>\s*([A-Za-z\-\.]+)<\/cur1><\/inlineEquation>/<sup><i>$1<\/i><\/sup>/gs;
  $$TeXData=~s/<inlineEquation>\_<cur1>\s*([0-9\-\.]+)<\/cur1><\/inlineEquation>/<sub>$1<\/sub>/gs;
  $$TeXData=~s/<inlineEquation>\^<cur1>\s*([0-9\-\.]+)<\/cur1><\/inlineEquation>/<sup>$1<\/sup>/gs;
  $$TeXData=~s/<inlineEquation>\s*([\(\[]?)\s*([A-Za-z\-\.]+)\_<cur1>([A-Za-z\-\.]+)\s*<\/cur1>\s*([\)\]]?)\s*<\/inlineEquation>/$1<i>$2<\/i><sub><i>$3<\/i><\/sub>$4/gs;
  $$TeXData=~s/<inlineEquation>\s*([\(\[]?)\s*([A-Za-z\-\.]+)\^<cur1>([A-Za-z\-\.]+)\s*<\/cur1>\s*([\)\]]?)\s*<\/inlineEquation>/$1<i>$2<\/i><sup><i>$3<\/i><\/sup>$4/gs;
  $$TeXData=~s/<inlineEquation>\s*([\(\[]?)\s*([A-Za-z\-\.]+)\_<cur1>([0-9\-\.]+)\s*<\/cur1>\s*([\)\]]?)\s*<\/inlineEquation>/$1<i>$2<\/i><sub>$3<\/sub>$4/gs;
  $$TeXData=~s/<inlineEquation>\s*([\(\[]?)\s*([A-Za-z\-\.]+)\^<cur1>([0-9\-\.]+)\s*<\/cur1>\s*([\)\]]?)\s*<\/inlineEquation>/$1<i>$2<\/i><sup>$3<\/sup>$4/gs;



  $$TeXData=~s/<inlineEquation>\s*([\(\[]?)\s*([A-Za-z\-\.]+)\_([A-Za-z\-\.]+)\s*([\)\]]?)\s*<\/inlineEquation>/$1<i>$2<\/i><sub><i>$3<\/i><\/sub>$4/gs;
  $$TeXData=~s/<inlineEquation>\s*([\(\[]?)\s*([A-Za-z\-\.]+)\^([A-Za-z\-\.]+)\s*([\)\]]?)\s*<\/inlineEquation>/$1<i>$2<\/i><sup><i>$3<\/i><\/sup>$4/gs;
  $$TeXData=~s/<inlineEquation>\s*([\(\[]?)\s*([A-Za-z\-\.]+)\_([0-9\-\.]+)\s*([\)\]]?)\s*<\/inlineEquation>/$1<i>$2<\/i><sub>$3<\/sub>$4/gs;
  $$TeXData=~s/<inlineEquation>\s*([\(\[]?)\s*([A-Za-z\-\.]+)\^([0-9\-\.]+)\s*([\)\]]?)\s*<\/inlineEquation>/$1<i>$2<\/i><sup>$3<\/sup>$4/gs;

  $$TeXData=~s/<inlineEquation>\s*([0-9\-\.]+)\^([0-9\-\.]+)\s*<\/inlineEquation>/$1<sup>$2<\/sup>/gs;
  $$TeXData=~s/<inlineEquation>\s*([0-9\-\.]+)\_([0-9\-\.]+)\s*<\/inlineEquation>/$1<sub>$2<\/sub>/gs;

  $$TeXData=~s/<inlineEquation>([0-9\,\-\.\]\[\(\) ]+)\~([A-Za-z]+)<\/inlineEquation>/$1\~<i>$2<\/i>/gs;

  $$TeXData=~s/<inlineEquation>([A-Za-z\-\.]+)\=([A-Za-z\-\.]+)<\/inlineEquation>/<i>$1\&\#x2009\;\&\#x003D\;\&\#x2009\;$2<\/i>/gs;
  $$TeXData=~s/<inlineEquation>([A-Za-z\-\.]+)\=([0-9\-\.]+)<\/inlineEquation>/<i>$1<\/i>\&\#x2009\;\&\#x003D\;\&\#x2009\;$2/gs;
  $$TeXData=~s/<inlineEquation>([A-Za-z\-\.]+)\<([A-Za-z\-\.]+)<\/inlineEquation>/<i>$1\&\#x2009\;\&\#x003C\;\&\#x2009\;$2<\/i>/gs;
  $$TeXData=~s/<inlineEquation>([A-Za-z\-\.]+)\>([A-Za-z\-\.]+)<\/inlineEquation>/<i>$1\&\#x2009\;\&\#x003E\;\&\#x2009\;$2<\/i>/gs;

  $$TeXData=~s/<inlineEquation>([0-9\.]+)\\\,\s*\-\s*\\\,([0-9\.]+)<\/inlineEquation>/$1\&\#x2009\;\&\#x2212\;\&\#x2009\;$2/gs;
  $$TeXData=~s/<inlineEquation>([0-9\.]+)\\\,\s*\+\s*\\\,([0-9\.]+)<\/inlineEquation>/$1\&\#x2009\;\&\#x002B\;\&\#x2009\;$2/gs;
  $$TeXData=~s/<inlineEquation>([0-9\.]+)\\\,\s*\\times\s*\\\,([0-9\.]+)<\/inlineEquation>/$1\&\#x2009\;&#x00D7;\&\#x2009\;$2/gs;
  $$TeXData=~s/<inlineEquation>([0-9\.]+)\s*\\times\s*([0-9\.]+)<\/inlineEquation>/$1\&\#x2009\;&#x00D7;\&\#x2009\;$2/gs;
  #print $$TeXData;exit;


  $$TeXData=~s/<sup>\-<\/sup>/<sup>\&\#x2212\;<\/sup>/gs;
  $$TeXData=~s/<sub>\-<\/sub>/<sub>\&\#x2212\;<\/sub>/gs;
  $$TeXData=~s/<inlineEquation>\\i(Phi|Theta|Delta|Pi|Psi|Omega)<\/inlineEquation>/<i>\\$1<\/i>/gs;
  $$TeXData=~s/<inlineEquation>\\is(Phi|Theta|Delta|Pi|Psi|Omega)<\/inlineEquation>/<i>\\$1<\/i>/gs;
  $$TeXData=~s/\\i(Phi|Theta|Delta|Pi|Psi|Omega)([^a-zA-Z])/\\mathit\{\\$1\}$2/gs;
  $$TeXData=~s/\\i(Phi|Theta|Delta|Pi|Psi|Omega)([^a-zA-Z])/\\mathit\{\\$1\}$2/gs;
  $$TeXData=~s/\\is(Phi|Theta|Delta|Pi|Psi|Omega)([^a-zA-Z])/\\mathit\{\\$1\}$2/gs;
  $$TeXData=~s/\\is(Phi|Theta|Delta|Pi|Psi|Omega)([^a-zA-Z])/\\mathit\{\\$1\}$2/gs;

  use TeX2XML::Entities;
  $TeXData=equationEntity($TeXData);

  return $TeXData;
}
#==================================================================================================================================

sub convertTextTeXToXMLEntity{
  my $TeXData=shift;

  $$TeXData=~s/\\hspace[\*]?<cur1>([\d\w\.\-]+)<\/cur1>//gs;
  $$TeXData=~s/([\dA-Za-z])\\\-<cur1>\\break<\/cur1>([\dA-Za-z])/$1$2/gs;
  $$TeXData=~s/([\dA-Za-z])\\\-\\break([\dA-Za-z])/$1$2/gs;
  $$TeXData=~s/([\dA-Za-z])\-<cur1>\\break<\/cur1>([\dA-Za-z])/$1$2/gs;
  $$TeXData=~s/([\dA-Za-z])\-\\break([\dA-Za-z])/$1$2/gs;
  $$TeXData=~s/([\dA-Za-z])<cur1>\\break<\/cur1>([\dA-Za-z])/$1 $2/gs;
  $$TeXData=~s/\\break\b//gs;
  $$TeXData=~s/([^\\])\-<cur1>([A-Z])<\/cur1>/$1\-$2/gs;
  $$TeXData=~s/\\setlength\b//gs;

  $$TeXData=~s/<hashSign>/\&\#x0023\;/gs;
  $$TeXData=~s/<cur1>\\\"([a-zA-Z])<\/cur1>/\\\"<cur1>$1<\/cur1>/gs;
  $$TeXData=~s/<cur1>\\\'([a-zA-Z])<\/cur1>/\\\'<cur1>$1<\/cur1>/gs;
  $$TeXData=~s/<cur1>\\\`([a-zA-Z])<\/cur1>/\\\`<cur1>$1<\/cur1>/gs;
  $$TeXData=~s/\\\!//gs;
  $$TeXData=~s/\\\"([a-zA-Z])/\\\"<cur1>$1<\/cur1>/gs;
  $$TeXData=~s/\\\'([a-zA-Z])/\\\'<cur1>$1<\/cur1>/gs;
  $$TeXData=~s/\\\`([a-zA-Z])/\\\`<cur1>$1<\/cur1>/gs;
  $$TeXData=~s/ \\\, / /gs;
  $$TeXData=~s/\\\, / /gs;
  $$TeXData=~s/([^\\])\\ /$1 /gs;
  $$TeXData=~s/([0-9]+)\\\,([a-zA-Z]+)/$1\&\#x2009\;$2/gs;
  $$TeXData=~s/\\\\/<LINEBRK>/gs;  #*****Take Care

  $$TeXData=~s/\\text<cur1>(\\[a-zA-Z]+)<\/cur1>/$1/gs;
  $$TeXData=~s/\\texttt<cur1>([^<>]*?)<\/cur1>/\\tt<cur1>$1<\/cur1>/gs;
  $$TeXData=~s/\\rm<cur1>([^<>]*?)<\/cur1>/$1/gs;
  $$TeXData=~s/([^>])\\rm ([^<])/$1$2/gs;
  $$TeXData=~s/<sltitcont>\\rm /<sltitcont>/gs;


#  \text<cur1>\euro</cur1>
  use TeX2XML::Entities;
  $TeXData=textEntity($TeXData);

  $$TeXData=~s/<cur1>\\ss<\/cur1>/\&\#x00DF\;/gs;
  $$TeXData=~s/<cur1>\\i<\/cur1>/\&\#x0131\;/gs;
  $$TeXData=~s/\\i<\/cur([\d])>/\&\#x0131\;<\/cur$1>/gs;
  $$TeXData=~s/\\i([^a-zA-Z])/\&\#x0131\;$1/gs;
  $$TeXData=~s/\\ss/\&\#x00DF\;/gs;

  $$TeXData=~s/ \,([^\n\,\`]*?)\`/ \&\#x201A\;$1\&\#x201B\;/gs;

  $$TeXData=~s/\\\~/\&\#x02DC\;/gs;
  $$TeXData=~s/\~/\&\#x00A0\;/gs;
  $$TeXData=~s/\'\'/\&\#x201D\;/gs;
  $$TeXData=~s/\`\`/\&\#x201C\;/gs;
  $$TeXData=~s/\'([ \.\,\;\)\]\<\?\:])/\&\#x2019\;$1/gs;

  # $$TeXData=~s/\'([st])/\&\#x2019\;$1/gs;
  $$TeXData=~s/\`/\&\#x2018\;/gs;

 # $$TeXData=~s/\'([a-z])/\&\#x0027\;$1/gs;
  $$TeXData=~s/\'([a-z])/\&\#x2019\;$1/gs;  #wrong but A++ required by chinna raju
  $$TeXData=~s/<openCurly>/\&\#x007B\;/gs;
  $$TeXData=~s/<closeCurly>/\&\#x007D\;/gs;


return $TeXData;
}

#==================================================================================================================================


sub checkFormatingsTag{
  my $TeXData=shift;
  my @checkinsidetag=("i", "b");

  foreach my $tag (@checkinsidetag)
    {
      my $counter=1;
      while(${$TeXData}=~m/<$tag>((?:(?!<$tag>)(?!<\/$tag>).)*)<\/$tag>/)
	{
	  ${$TeXData}=~s/<$tag>((?:(?!<$tag>)(?!<\/$tag>).)*)<\/$tag>/<${tag}$counter>$1<\/${tag}$counter>/gs;
	  $counter++;
	}
    }

  foreach my $tag (@checkinsidetag)
    {
      my $counter=5;
	while($counter>1){
	  while(${$TeXData}=~/<${tag}$counter>((?:(?!<${tag}$counter>)(?!<\/${tag}$counter>).)*)<\/${tag}$counter>/s){
	    my $tagtext=$1;
	    $tagtext=~s/\\ref(bt|at|misc1|pt)<i1>(.*?)<\/i1>$/\\ref$1<cur1>$2<\/cur1>/gs;
	    $tagtext=~s/\\ref(bt|at|misc1|pt)<i2>(.*?)<\/i2>$/\\ref$1<cur2>$2<\/cur2>/gs;
	    $tagtext=~s/<[\/]?${tag}([0-9])>//gs;
	    ${$TeXData}=~s/<${tag}$counter>((?:(?!<${tag}$counter>)(?!<\/${tag}$counter>).)*?)<\/${tag}$counter>/<${tag}>$tagtext<\/${tag}>/s;
	  }
	  $counter--;
	}

      ${$TeXData}=~s/<([\/]?)${tag}1>/<$1${tag}>/gs;
    }
  ${$TeXData}=~s/<i>\.<\/i>/\./gs;

  return $TeXData;
}



1;
