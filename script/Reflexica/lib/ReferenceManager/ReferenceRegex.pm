#Author: Neyaz Ahmad
package ReferenceManager::ReferenceRegex;
use strict;
our $VERSION = '0.1';

sub new {

  my %regx=(
	    'issuePrefix' => '([Ii]ssue[\.]?|[Nn][Oo][\.]?|[Ss]uppl[\.]*?)',
	    'issuePrefix1' => '([Ii]ssue[\.]?|[Nn][Oo][\.]?|[Nn]\.|[Hh]eft[.]?)',
	    'tabchar' => '([\t]+)',
	    'issue' => '([0-9]+)',
	    'issuePunc' => '([\:\,\;\s]+)',
	    'volumePrefix' => '([Vv]olume[s]?|[vV]ol)',
	    'volume' => '([0-9]+)',
	    'volumeNoAlpha' => '([0-9]+[\-IVXL]+)',
	    'volumePunc' => '([\:\,\;\s]+)',
	    'pagePrefix' => '([pP]age[s]?\s*|[pPS\.]+\s*)',
	    'pagePrefixPunc' => '([\.\s]+)',
	    'page' => '([ei]?\d+[\-–‐­]+[\-]?[ei\s]?\d+|[0-9\-]+)',
	    'pageRange' => '([0-9\-]+)',
	    'pagePunc' => '([\,\s\.]+)',
	    'optionalPunc' => '([\.\,\;\:\/\)\(]*?)',
	    'optionalSpace' => '([\s]*)',
	    'optionalFullstop' => '([\.]?)',
	    'allLeftQuote' => '(‘|\`\`|\")',
	    'allRightQuote' => '(�|\"|\'\')',
	    'noQoute' => '([^\"\`\`\'\']+)',
	    'leftRightSingleQuote' => '([]+)',
	    'mandatorySpace' => '([\s]+)',
	    'puncSpace' => '([\s\,\:\;\.\/]+)',
	    'optionalPuncSpace' => '([\.\,\;\:\/\)\s]*?)',
	    'year' => '(\d\d\d\d[a-z]?|\bin press)',
	    'yearPunc' => '([\;\:\,\s\[]+)',
	    'optionaEndPunc' => '([\.\,\;\s]*?)',
	    'ndash' => '([\-–‐]+)',
	    'mdash' => '(—)',
	    'mdash1' => '(�)',
	    'wordPuncPrefix' => '([a-zA-Z>\}\']+[\)\]\.\,\:\;\?\! ]+)',
	    'wordPuncParenPrefix' => '([a-zA-Z>\}\']+[\)\]\.\,\:\;\?\! ]+|[\)\]][\.\,\:\;\?\! ]+)',
	    'particle' => '([vV]an [dD]er|[Vv]on [dD]er|[vV]an [dD]e|[vV]an [dD]en|[vV]on [zZ]ur|dela|du|[dD]e la|[dD]er|[dD]e|da|ten|[vV]on|[vV]an|[dD]os|[tT]hoe|[tT]ot|[Aa]w|Ll|del)',
	    'and' => '([aA]nd|[uU]nd|\&|\\&|\&amp\;)',
	    'suffix' => '([Jj]r[\.]?|[Ss]r[\.]?|1st[\.]?|1<sup>st<\/sup>[\.]?|2nd[\.]?|2<sup>nd<\/sup>[\.]?|3rd[\.]?|3<sup>rd<\/sup>[\.]?|4th[\.]?|II[\.]?|III[\.]?)',
	    'particleSuffix' => '([vV]an [dD]er|[Vv]on [dD]er|[vV]an de|[vV]an [dD]en|[vV]on [zZ]ur|dela|[dD]u|[dD]e la|[dD]er|[dD]e|da|ten|[vV]on|[vV]an|[dD]os|[tT]hoe|[tT]ot|[Aa]w|del|[Jj]r[\.]?|[Ss]r[\.]?|1st[\.]?|2nd[\.]?|3rd[\.]?|4th[\.]?|II[\.]?|III[\.]?|1<sup>st<\/sup>[\.]?|2<sup>nd<\/sup>[\.]?|3<sup>rd<\/sup>[\.]?)',
	    'firstName' => '([A-Z0-9\-\.Ş���������ʘ��������������–‐ ]+[vdht\. ]*?|\bTh[\. ]*?[A-Z][\.]?|[A-Z0-9\.]?\-Chr\b[\.]?|[CY][hu][\.]? [A-Z\.]|[A-Z0-9\. ]+Aa|[A-Z][a-qs-z0-9][\.]?|[A-Z0-9]\.[\-]?[a-z0-9][\.]?|\b[CPY][hu]\.|[A-Z][a-z0-9]\.[ ]?[A-Z\.]+[\.]?|[A-Z\. ]+[ ]?[A-Z]?[a-z0-9]\.?)',
	    'editorString' => '([^<>4-90\(\)\:\?\+\=\[\]]+)',
	    'sAuthorString' => '([^<>\(\)\[\]\:\?\%\+\!\.\,\;\/ ]+?)',
	    'mAuthorString' => '([^<>\(\)\[\]\:\?\%\+\!\.\,\;\/]+?)',
	    'mAuthorFullFirstName' => '([A-Z][^<>A-Z05-9\/\;\.\:\,]+?|[A-Z][^<>A-Z05-9\/\;\.\:\,]+?[\- ][A-Z][^<>A-Z\/\;\.\:\,]+?|[A-Z][^<>A-Z05-9\/\;\.\:\,]+?[\- ][A-Z][^<>A-Z\/\;\.\:\,]+? [A-Z\.]+|[A-Z][^<>A-Z05-9\/\;\.\:\,]+? [A-Z\.]+)',
	    'mAuthorFullSirName' => '([A-Z][^<>A-Z05-9\/\;\.\:\,]+?\-[A-Z][^<>A-Z05-9\/\;\.\:\,]+?|[A-Z][^<>A-Z05-9\/\;\.\:\,]+?|[a-z][a-z ]+ [A-Z][^<>A-Z05-9\;\/\.\:\,]+?|[A-Z][^<>A-Z05-9\/\;\.\:\,]+? [a-z][a-z ]+)',
	    'etal' => '(et al[\.\,]?|et\. al[\.\,]?)',
	    'edn' => '([0-9]+)',
	    'ednPrifix' => '\b([Ee]d[n]?[\.]?|[Ee]dition|[Aa]uflage|[Aa]ufl[\.]?)',
	    'ednSuffix' => '\b([Ee]d[n]?[\.]?|[Ee]dition|[Aa]uflage|[Aa]ufl[\.]?)',
	    'editorSuffix' => '\b([eE]ditor[s]?[\.]?|[Hh]erausgeber[\.]?|[Ee]d[s]?[\.]?|[Hh]rsg[\.]?)',
	    'INwithSpace' => '([\,\;\.”\"]+ [Ii]n[\.:]? |[\,\.\; ]+[Ii]n[:.] |<\/i>[\.\,]? [Ii]n[\.:]? )',
	    'ordinalNumber' => '([fF]irst|[sS]econd|[tT]hird|[fF]ourth|[fF]ifth|[sS]ixth|[sS]eventh|[eE]ighth|[nN]inth|[tT]enth)',
	    'numberSuffix' => '([nr]d|th|st)',
	    'noTagAnystring' => '([^<>]+?)',
	    'noTagOpString' => '([^<>]*?)',
	    'augString' => '((?:(?!<[\/]?aug>).)*?)',
	    'monthPrefix' => '([Jj]an|[Ff]eb|[Mm]ar|[Aa]pr|[Mm]ay|[Jj]un|[Jj]ul|[Aa]ug|[Ss]ep[t]?|[Oo]ct|[Nn]ov|[Dd]ec|[Jj]anuary|[Ff]ebruary|[Mm]arch|[Aa]pril|[Mm]ay|[Jj]une|[Jj]uly|[Aa]ugust|[Ss]eptember|[Oo]ctober|[Nn]ovember|[Dd]ecember)',
	    'monthVolumePrefix' => '([Jj]an[\.]?|[Ff]eb[\.]?|[Mm]ar[\.]?|[Aa]pr[\.]?|[Mm]ay|[Jj]un|[Jj]ul|[Aa]ug[\.]?|[Ss]ep[t]?[\.]?|[Oo]ct[\.]?|[Nn]ov[\.]?|[Dd]ec[\.]?|[Jj]anuary|[Ff]ebruary|[Mm]arch|[Aa]pril|[Mm]ay|[Jj]une|[Jj]uly|[Aa]ugust|[Ss]eptember|[Oo]ctober|[Nn]ovember|[Dd]ecember|[Vv]olume[s]?[\.]?|[Vv]ol[s]?[\.]?|VOL[\.]?)',
	    'journalKeyWords' => '(The [A-Z][a-zA-Z ]+ [Jj]ournal[s]? [oO]f|The [Jj]ournal[s]? [oO]f|[Jj]ournal[s]? [oO]f|J[\.]? Biol[\.]?|Am[\.]? [A-Z][a-z]+[\.]?|Appl[.]? [A-Z][a-z]+[\.]?)',
	    'journalKeyWordsWithJ' => '(The [A-Z][a-zA-Z ]+ [Jj]ournal[s]? [oO]f|The [Jj]ournal[s]? [oO]f|[Jj]ournal[s]? [oO]f|J[\.]? Biol[\.]?|Am[\.]? [A-Z][a-z]+[\.]?|Appl[.]? [A-Z][a-z]+[\.]?|Can J[\.]?|Jour[n]?[\.]? of|Jour[n]?[\.]? [A-Z][a-z]+[.]?|Jour[n]?[\.]? R[.]?|J[\.]? of|J[\.]? Appl[\.]?|J[\.]? Phys[\.]?|J[\.]? Chem[\.]?|J[\.]? Biol[\.]?|Am[\.]? [A-Z][a-z]+[\.]?|Ann[\.]? [A-Z][a-z]+[\.]?|Applied|European|American|International|The|J|J\.)',
	    'month' => '([0-9]+[\-]?[0-9]*?)',
	    'dateMonth' => '([01][0-9])',
	    'dateDay' => '([0-3]?[0-9])',
	    'accessed' => '([Zz]ugegrif[f]?[e]?[n]?|[Aa]ccessed|[Zz]ugrif[f]?|[Ee]rinnern|[Ee]inziehen|[Gg]edenken|[Gg]esehen|[Aa]brufen|[Rr]eferred)',
	    'doi' => '([\w\d\.\/\\\_\~\@\$–â€“\&\-–\/\(\)\[\]\;\:]+)',
	    'doig' => '([\w\d\.\/\\\_\~\@\$–â€“\&\-–\/\(\)\[\]\;\:]+)',
	    'titlesPubNamLoc' => '(misc1|bt|collab|pbl|cny|pt|at)',
	    'bookTitlesCollab' => '(misc1|bt|collab|pbl|cny|pt)',
	    'chapterBookCollabTitle' => '(misc1|bt|collab)',
	    'isbn' => '([\d]+\-[\d\-]+)',
	    'bookLastElemnt' => '([\.]?<\/bib>|[ \.\,\;]+<comment>|[\.\,\)\(\; ]+<yr>[^<>]+?<\/yr>[\)\.]*?<\/bib>|[\.\, ]+<pg>|[\,\.\; ]+[pPS][a-z]*?[\. ]+<pg>|[ \.\,]+<isbn>|[ \;\.\,\(]+<doig>)',
	    'extraInfo' => '(<\/bib|[\(\[]?[sS]pecial [iI]ssue[\)\] ]*|[\(\[]?[Pp]ub[Mm]ed|[<[ui]>\(\[]?[Dd][Oo][Ii]|[\(\[]?[Dd][Oo][Ii]|[\(\[]?dx\.doi\.org|[\(\[]?db\/journals|[\(\[]?WOS\:|[\(\[]?[eE]pub|[\(\[]?[dD]iscussion|[\(\[]?[Rr]etrieved|[\(\[ *]?Retriev[e]?|[\(\[]?[Aa]vailable|[\(\[]?[Pp]ublished|[\(\[]?[aA]ccepted|[\(\[]?[Oo]nline|[\(\[]?Business Source|[\(\[]?[Aa]ccessed|[\(\[]?[cC]ited|[\[\( ]*?<doig>|[\(\[]?http\:|URL[\:]?|[\(\[]?www|\([A-Za-z]+[^\(\)<>]+\)[\.]?<\/bib|[\.\,\;\: ]+?[^0-9<>]+?<\/bib>|[ ]?[\(\[]|[\[\( ]*?<comment>|[Rr]eview[\.\,] [Ee]rratum in|[Ee]rratum in|Review[\.\,]? [Pp]ub[Mm]ed|discussion [0-9]+)',
	    'extraInfoNoComment' => '(<\/bib|[\(\[]?[sS]pecial [iI]ssue[\)\] ]*|[\(\[]?[Pp]ub[Mm]ed)',
	    'comment' => '([Aa]ccessed [oO]n [A-Z][a-z]+[\.\,]? [1-2][0987][0-9][0-9]|[Aa]ccessed [A-Z][a-z]+[\.\,]? [0-9\-]+[\.\,]? [1-2][0987][0-9][0-9]|[uU]pdated [1-2][0987][0-9][0-9] [A-Z][a-z]+[\.]? [0-9]+|[Aa]vailable [A-Za-z]+\:)',
	    'instName' => '([Dd]epartment[s]?|[Rr]esearch[s]?|[Uu]nit[s]?|of|[cC]ommunity|[mM]ember[s]?|NASA|[Nn]aturschutz|[Dd]eutschen|[Cc]onvention|[Vv]isitor[s]?|[Ee]uropäischen|[Ee]urop�ischen|back|für|f�r|[Pp]olicy|[Ii]nstitute[s]?|[Hh]ealth|[Ss]ervice[s]?|[Uu]nited|[sS]tate[s]?|[Cc]hinese|[Pp]atient[s]?|[Nn]ational|--|[Aa]rbeitszeitmanagement|[Cc]orporate|[C]ouncil|[Vv]erlag|[Cc]rossculture|[Mm]anagement[s]?|Co\.|[wW]estern [A-Z][a-z]+|[Gg]roup[s]?|[Bb]ioscience[s]?|[Tt]eam|[Dd]evelopment[s]?|[Pp]roduct[s]?|[Tt]raining|[Mm]odule[s]?|[Rr]esource[s]?|[Ii]nitiative|[Mm]ediengruppe|[Pp]resserat|[Ii]nstituto|[Ww]eekly|[Uu]pdate|[Ee]nvironment|[Ss]tatistic[s]?|Inc| [Bb]erlin \w+  |[Rr]aumordnung|[Vv]erkehrslenkung|[Pp]lanung|[Ii]nstrumente|[Rr]aumentwicklung|[Ll]eitbilder|[Rr]aumordnungspolitik|[Ll]eipzig|[Ii]nternational[e]?|[Cc]entre|ISSN|[dD]ictionary|[mM]edical|[aA]ngiogenesis|[Aa]nonymous|[Cc]ontrol[s]?|[Mm]odule|WHO|IPCC|ICSU|[Cc]ancer|[Ee]arly|[Bb]reast|[iI]nnovation|[Ss]tatistische[s]?|[Bb]undesamt|[Ff]inal[s]?|[Pp]ress|[Ss]urvey|[Rr]elease|[Nn]ews|[Ff]oundation|[Ss]ocial|[Ww]orld|[Oo]rganization[s]?|[Gg]eneric|[Mm]oney|[eE]xample[s]?|[tt]ypes|[Ww]ebsite|[Ll]atin|PSIM|[Ff]unctionalized|[Nn]anocomposite|[Cc]ollaboration|[Cc]ollege|[Cc]hemical|[Ss]erver|[Bb]ook|[Cc]hloramine[s]?|[dD]atabase|FAOSTAT|[Aa]ustralia|[^<>\-]+?[Cc]ompany|[Tt]echnologie[s]?|[Tt]echnology|FGG|[KkcC]ommission|[Mm]edicines|3D|FCS|[R]obotic[s]?|[Aa]lignment|NCSA|[Ee]lektronik|[Aa]pplication[s]?|C\+\+|ILOG|[mM]anual|[pP]rogramming[s]?|[CC]orporation[s]?|NVIDIA|[Aa]lgorithm|ZIB|DIMACS|[aA]nalysis|[dD]ata|[Dd]eutschland[s]?|[Ee]uropean[s]?|[Ii]nformatic[s]?|[nN]orth [A-Z][a-z]+|[Ff]ederation|[Ww]omen[\'s]*?|[Ee]ducation[s]?|[Oo]ffice|[Pp]opulation|[Gg]ruppe|Schweizerischen|OSCAR|Consulting|ETH Zürich|Bauindustrie|[Gg]overnment|[Cc]redit|Canada|[Ii]mmigration|Canadian|Medizinischer Dienst|[Aa]rchaeology|[Aa]ssociation[s]?)'
	 );

    return %regx;
}

#========================================================================================================================================
return 1;
#(|�|“|‘|�|[��]+)([^<>]+?)(|�|”|’||[�]+)
