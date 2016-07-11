#version 1.0
#Author: Neyaz Ahmad
package ReferenceManager::TagCleanup;
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(AtAndEdrgMarking TagInsideTagClenup tagEditing);


###################################################################################################################################################
sub tagEditing
    {
	my $TextBody=shift;
	my $application="";
	my $application=shift;

	my $AuthorString="A-Za-zßØÃﬂ¡ýÿþÜÛÚÙØÖÕÔÓÒÑÐÏÎÍÌËÊÈÉÇÆŒœšŠÅÄÂÁÀñïïîííêçæåãâáõôóòùúûéèàäćíÃüöİı…â€™Ã¦Ã³Ã±Ã˜Ã¤Ã§Ã®Ã¨ÃŸÃ¼Ã¶Ã©Ã¥Ã¸`’\\\-Ã‡Ã–\\\"–\\\-\\\'";
	use ReferenceManager::ReferenceRegex;
	my %regx = ReferenceManager::ReferenceRegex::new();

	$$TextBody=~s/<comment><\/comment>([\.]?)<\/bib>/$1<\/bib>/gs;
	$$TextBody=~s/([0-9a-zA-Z]+)<\/at> in\?/$1 in\?<\/at>/gs;
	#<aug>Peters, <au><auf>K</auf> <aus>Ryan M</aus></au>
	$$TextBody=~s/>([A-Z][a-z]+)\, <au><auf>$regx{firstName}<\/auf> <aus>([A-Z][a-z]+) $regx{firstName}<\/aus><\/au>/><au><aus>$1<\/aus>\, <auf>$2<\/auf><\/au> <au><aus>$3<\/aus> <auf>$4<\/auf><\/au>/gs;
	$$TextBody=~s/<\/pt>\, <v>V([0-9]+)<\/v>/<\/pt>\, V<v>$1<\/v>/gs;

	#<aug>Peters, <au><aus>K Ryan</aus> <auf>M</auf></au>
	$$TextBody=~s/>([A-Z][a-z]+)\, <au><aus>$regx{firstName} ([A-Z][a-z]+)<\/aus> <auf>$regx{firstName}<\/auf><\/au>/><au><aus>$1<\/aus>\, <auf>$2<\/auf><\/au> <au><aus>$3<\/aus> <auf>$4<\/auf><\/au>/gs;
	$$TextBody=~s/CoRR<\/pt>\, abs\/([\d]+).<v>([\d]+)<\/v>([\.\,\; ]+)<pg>$regx{year}<\/pg>([\.]?)<\/bib>/CoRR<\/pt>\, abs\/$1.$2$3<yr>$4<\/yr>$5<\/bib>/gs;

	$$TextBody=~s/<bib([^<>]+?)><ia>([^<>\.]+?)<\/ia> ([^\.\,\;\:]*?)([\.]?)[\s]?([\(]?<yr>)/<bib$1><ia>$2 $3<\/ia>$4 $5/gs;
	$$TextBody=~s/<bib([^<>]+?)><ia>([^<>\.]+?)<\/ia>\, ([^\.\,\;\:]+?)([\.]?) ([\(]?<yr>[^<>]+?<\/yr>[\)]?[\.]?) (<i>|[A-Z][a-z]+|<bt>|<at>|<misc1>)/<bib$1><ia>$2\, $3<\/ia>$4 $5 $6/gs;
	$$TextBody=~s/<bib([^<>]+?)><ia>([^<>]+?)<\/ia>\, ([^\.\,\;\:]+?)([\.]?) ([\(]?<yr>[^<>]+?<\/yr>[\)]?[\.]?) (<bt>|<at>|<misc1>)/<bib$1><ia>$2\, $3<\/ia>$4 $5 $6/gs;
	$$TextBody=~s/<bib([^<>]+?)><ia>([^<>]+?)<\/ia>\, ([^\.\,\;\:]+?)([\.]?) (\(<yr>[^<>]+?<\/yr>[^\(\)]+?\)[\.]?) (<i>|[A-Z][a-z]+|<bt>|<at>|<misc1>)/<bib$1><ia>$2\, $3<\/ia>$4 $5 $6/gs;
	$$TextBody=~s/<bib([^<>]+?)><ia>([^<>]+?)<\/ia>\, ([^\.\;\:]+?)([\.]?) (\(<yr>[^<>]+?<\/yr>\)[\.]?) (<bt>|<at>|<misc1>)/<bib$1><ia>$2\, $3<\/ia>$4 $5 $6/gs;

	#<ia>Lheidli T窶册nneh First Nation, Carrier Sekani Family Services, Carrier Sekani Tribal Council, Prince George Native Friendship Center</ia>, <pbl>& Prince George Nechako First Nations Employment and Training Association</pbl>. (2006). <i>
	$$TextBody=~s/<bib([^<>]+?)><ia>([^<>]+?)<\/ia>\, <pbl>([^<>]+?)<\/pbl>([\.]?) (\(<yr>[^<>]+?<\/yr>\)[\.]?) <i>/<bib$1><ia>$2\, $3<\/ia>$4 $5 <i>/gs;
	$$TextBody=~s/<bib([^<>]+?)><ia>([^<>]+?)<\/ia>\, <pbl>([^<>]+?)<\/pbl>([\.]?) \($regx{year}\)([\.]?) <i>((?:(?!<[\/]?yr>)(?!<bib)(?!<\/bib>).)*)<\/bib>/<bib$1><ia>$2\, $3<\/ia>$4 \(<yr>$5<\/yr>\)$6 <i>$7<\/bib>/gs;
	$$TextBody=~s/<\/aug>\; <(at|bt)>([^\.\,\:\;<>]+? [^\.<>]+?)\. ([^<>]+?)<\/\1>/\; <ia>$2<\/ia><\/aug>\. <$1>$3<\/$1>/gs;

#	print $$TextBody;exit;

	$$TextBody=~s/<ia>$regx{noTagAnystring}<\/ia>([\.\;\:\,]+) <bt>([^<>]+?)([\.\:\,\;]) \($regx{year}\)([\.\:]?) ((?:(?!<[\/]?bt>)(?!<bib)(?!<\/bib>).)*)<\/bt>([\,\.\:\; ]+)<(pbl|cny)>$regx{noTagAnystring}<\/\9>$regx{puncSpace}<(pbl|cny)>$regx{noTagAnystring}<\/\12>((?:(?!<[\/]?yr>)(?!<bib)(?!<\/bib>).)*)<\/bib>/<ia>$1$2 $3<\/ia>$4 \(<yr>$5<\/yr>\)$6 <bt>$7<\/bt>$8 <$9>$10<\/$9>$11<$12>$13<\/$12>$14<\/bib>/gs;
	$$TextBody=~s/<ia>$regx{noTagAnystring}<\/ia>([\.\;\:\,]+) <bt>([^<>]+?)([\.\:\,\;]) \($regx{year}(\/[0-9]+)\)([\.\:]?) ((?:(?!<[\/]?bt>)(?!<bib)(?!<\/bib>).)+)<\/bt>([\,\.\:\; ]+)<(pbl|cny)>$regx{noTagAnystring}<\/\10>$regx{puncSpace}<(pbl|cny)>$regx{noTagAnystring}<\/\13>((?:(?!<[\/]?yr>)(?!<bib)(?!<\/bib>).)*)<\/bib>/<ia>$1$2 $3<\/ia>$4 \(<yr>$5$6<\/yr>\)$7 <bt>$8<\/bt>$9 <$10>$11<\/$10>$12<$13>$14<\/$13>$15<\/bib>/gs;
	$$TextBody=~s/<ia>$regx{noTagAnystring}<\/ia>([\.\;\:\,]+) <bt>([^<>]+?)([\.\:\,\;]) $regx{year}([\.\:]) ((?:(?!<[\/]?bt>)(?!<bib)(?!<\/bib>).)+)<\/bt>([\,\.\:\; ]+)<(pbl|cny)>$regx{noTagAnystring}<\/\9>$regx{puncSpace}<(pbl|cny)>$regx{noTagAnystring}<\/\12>((?:(?!<[\/]?yr>)(?!<bib)(?!<\/bib>).)*)<\/bib>/<ia>$1$2 $3<\/ia>$4 <yr>$5<\/yr>$6 <bt>$7<\/bt>$8 <$9>$10<\/$9>$11<$12>$13<\/$12>$14<\/bib>/gs;
	$$TextBody=~s/<ia>$regx{noTagAnystring}<\/ia>([\.\;\:\,]+) <bt>([^<>]+?)([\.\:\,\;]) $regx{year}([\/\-][0-9]+)([\.\:]) ((?:(?!<[\/]?bt>)(?!<bib)(?!<\/bib>).)+)<\/bt>([\,\.\:\; ]+)<(pbl|cny)>$regx{noTagAnystring}<\/\10>$regx{puncSpace}<(pbl|cny)>$regx{noTagAnystring}<\/\13>((?:(?!<[\/]?yr>)(?!<bib)(?!<\/bib>).)*)<\/bib>/<ia>$1$2 $3<\/ia>$4 <yr>$5$6<\/yr>$7 <bt>$8<\/bt>$9 <$10>$11<\/$10>$12<$13>$14<\/$13>$15<\/bib>/gs;
	$$TextBody=~s/<ia>$regx{noTagAnystring}<\/ia>([\.\;\:\,]+) <bt>(DIN [^<>\:\.\,]+)([\.\:]) ((?:(?!<[\/]?bt>)(?!<bib)(?!<\/bib>).)+)<\/bt>([\,\.\:\; ]+)<(pbl|cny)>$regx{noTagAnystring}<\/\7>$regx{puncSpace}<(pbl|cny)>$regx{noTagAnystring}<\/\10>((?:(?!<bib)(?!<\/bib>).)*)<\/bib>/<ia>$1$2 $3<\/ia>$4 <bt>$5<\/bt>$6 <$7>$8<\/$7>$9<$10>$11<\/$10>$12<\/bib>/gs;
	$$TextBody=~s/<ia>$regx{noTagAnystring}<\/ia>([\.\;\:\,]+) (DIN [^<>\:\.\,]+)([\.\:]) ((?:(?!<[\/]?bt>)(?!<bib)(?!<\/bib>).)+)([\,\.\:\;]+[ \(]+)<yr>$regx{year}<\/yr>([\)\.\, ]+)<(pbl|cny)>$regx{noTagAnystring}<\/\9>$regx{puncSpace}<(pbl|cny)>$regx{noTagAnystring}<\/\12>((?:(?!<[\/]?yr>)(?!<bib)(?!<\/bib>).)*)<\/bib>/<ia>$1$2 $3<\/ia>$4 <bt>$5<\/bt>$6<yr>$7<\/yr>$8<$9>$10<\/$9>$11<$12>$13<\/$12>$14<\/bib>/gs;

	$$TextBody=~s/<bib$regx{noTagOpString}>((?:(?!<[\/]?bt>)(?!<bib)(?!<\/bib>).)+)<yr>$regx{year}<\/yr>([\)\:\,]* )((?:(?!<[\/]?bt>)(?!<bib)(?!<\/bib>).)+) <v>$regx{noTagAnystring}<\/v>\, <pg>$regx{noTagAnystring}<\/pg>([\,\.]) <(pbl|cny)>$regx{noTagAnystring}<\/\9>, <(cny|pbl)>$regx{noTagAnystring}<\/\11>([\.]?)<\/bib>/<bib$1>$2<yr>$3<\/yr>$4<bt>$5 $6\, $7<\/bt>$8 <$9>$10<\/$9>, <$11>$12<\/$11>$13<\/bib>/gs;
	#<bib id="bib5"><ia>CDC. Communities Putting Prevention to Work: CDC awards $372.8 Million to 44 Communities. 2010; Press Release. Available at:</ia> <url>
	$$TextBody=~s/<bib$regx{noTagOpString}><ia>([^<>\.]+?)\.([^<>]+?)<\/ia>([\.\,\: ]+)<url>/<bib$1><ia>$2<\/ia>\.$3$4<url>/gs;

	$$TextBody=~s/<bib$regx{noTagOpString}>((?:(?!<[\/]?yr>)(?!<[\/]?pt>)(?!<[\/]?pg>)(?!<bib)(?!<\/bib>).)*)\, $regx{year} <comment>([^<>]+?)<\/comment>\.<\/bib>/<bib$1>$2\, <yr>$3<\/yr> <comment>$4<\/comment>\.<\/bib>/gs;

	$$TextBody=~s/<bib$regx{noTagOpString}>((?:(?!<[\/]?yr>)(?!<[\/]?misc1>)(?!<[\/]?bt>)(?!<[\/]?at>)(?!<[\/]?pt>)(?!<[\/]?pg>)(?!<bib)(?!<\/bib>).)*) <(bt|at|misc1)>\[(\d\d\d\d)\]([ ]?)([12][0-9][0-9][0-9][a-z]?|[12][0-9][0-9][0-9]\/[12][0-9][0-9][0-9])([\.] )((?:(?!<[\/]?yr>)(?!<bib)(?!<\/bib>).)*)<\/bib>/<bib$1>$2 \[$4\]$5<yr>$6<\/yr>$7<$3>$8<\/bib>/gs;

	$$TextBody=~s/<bib$regx{noTagOpString}>((?:(?!<[\/]?yr>)(?!<[\/]?misc1>)(?!<[\/]?bt>)(?!<[\/]?at>)(?!<[\/]?pt>)(?!<[\/]?pg>)(?!<bib)(?!<\/bib>).)*) <(bt|at|misc1)>([\(]?)([12][0-9][0-9][0-9][a-z]?|[12][0-9][0-9][0-9]\/[12][0-9][0-9][0-9])([\.\)]* )((?:(?!<[\/]?yr>)(?!<bib)(?!<\/bib>).)*)<\/bib>/<bib$1>$2 $4<yr>$5<\/yr>$6<$3>$7<\/bib>/gs;
	#$$TextBody=~s/<bib$regx{noTagOpString}>((?:(?!<[\/]?yr>)(?!<[\/]?misc1>)(?!<[\/]?bt>)(?!<[\/]?at>)(?!<[\/]?pt>)(?!<[\/]?pg>)(?!<bib)(?!<\/bib>).)*) <(bt|at|misc1)>([\(]?)([12][0-9][0-9][0-9]/[12][0-9][0-9][0-9])([\.\)]* )((?:(?!<[\/]?yr>)(?!<bib)(?!<\/bib>).)*)<\/bib>/<bib$1>$2 $4<yr>$5<\/yr>$6<$3>$7<\/bib>/gs;

	$$TextBody=~s/<edr><eds>([^<>]+?)<\/eds> <edm>$regx{firstName}<\/edm><\/edr> <edr><eds>$regx{and} ([^<>]+?)<\/eds> <edm>$regx{firstName}<\/edm><\/edr>/<edr><eds>$1<\/eds> <edm>$2<\/edm><\/edr> $3 <edr><eds>$4<\/eds> <edm>$5<\/edm><\/edr>/gs;
	$$TextBody=~s/<au><aus>([^<>]+?)<\/aus> <auf>$regx{firstName}<\/auf><\/au> <au><aus>$regx{and} ([^<>]+?)<\/aus> <auf>$regx{firstName}<\/auf><\/au>/<au><aus>$1<\/aus> <auf>$2<\/auf><\/au> $3 <au><aus>$4<\/aus> <auf>$5<\/auf><\/au>/gs;
	$$TextBody=~s/<au><auf>$regx{firstName}\. ([^<>]{2,})<\/auf>([\,\; ]+)<aus>$regx{and}<\/aus><\/au>/<au><auf>$1\.<\/auf> <aus>$2<\/aus><\/au>$3$4/gs;
	$$TextBody=~s/<au><auf>$regx{firstName}<\/auf>([\.]?)([\, ]+)<aus>$regx{and}<\/aus><\/au>/<au><auf>$1$2<\/auf><\/au>$3$4/gs;
	$$TextBody=~s/<edr><edm>$regx{firstName}\. ([^<>]{2,})<\/edm>([\,\; ]+)<eds>$regx{and}<\/eds><\/edr>/<edr><edm>$1\.<\/edm> <eds>$2<\/eds><\/edr>$3$4/gs;
	$$TextBody=~s/<edr><edm>$regx{firstName}<\/edm>([\.]?)([\, ]+)<eds>$regx{and}<\/eds><\/edr>/<edr><edm>$1$2<\/edm><\/edr>$3$4/gs;

	#print $$TextBody;exit;

	$$TextBody=~s/<au><aus>$regx{noTagAnystring}<\/aus> <auf>\,<\/auf>([A-Z\.\- ]+) <suffix>$regx{noTagAnystring}<\/suffix><\/au>/<au><aus>$1<\/aus>\, <auf>$2<\/auf> <suffix>$3<\/suffix><\/au>/gs;
	$$TextBody=~s/<eds>van<\/eds> <edm>der ([A-Z][a-z]+) $regx{noTagAnystring}<\/edm>/<eds>van der $1<\/eds> <edm>$2<\/edm>/gs;
	$$TextBody=~s/<eds>van<\/eds> <edm>der $regx{noTagAnystring}<\/edm>/<eds>van der<\/eds> <edm>$1<\/edm>/gs;
	$$TextBody=~s/<au><aus>$regx{noTagAnystring}<\/aus><\/au>\, <au><auf>$regx{firstName}<\/auf> <par>$regx{particle}<\/par> <aus>$regx{particle}<\/aus><\/au>/<au><aus>$1<\/aus>\, <auf>$2<\/auf> <par>$3 $4<\/par><\/au>/gs;
	$$TextBody=~s/<edr><eds>$regx{noTagAnystring}<\/eds><\/edr>\, <au><edm>$regx{firstName}<\/edm> <par>$regx{particle}<\/par> <eds>$regx{particle}<\/eds><\/edr>/<edr><eds>$1<\/eds>\, <edm>$2<\/edm> <par>$3 $4<\/par><\/edr>/gs;
	$$TextBody=~s/<au><aus>$regx{noTagAnystring}<\/aus> <auf>$regx{firstName}<\/auf><\/au>\, <au><aus>$regx{suffix}<\/aus><\/au>/<au><aus>$1<\/aus> <auf>$2<\/auf>\, <suffix>$3<\/suffix><\/au>/gs;
	$$TextBody=~s/<au><par>$regx{particle}<\/par> <aus>$regx{noTagAnystring}<\/aus> <auf>$regx{firstName}<\/auf><\/au>, <au><aus>$regx{suffix}<\/aus><\/au>/<au><par>$1<\/par> <aus>$2<\/aus> <auf>$3<\/auf>, <suffix>$4<\/suffix><\/au>/gs;
	$$TextBody=~s/<au><par>$regx{particle}<\/par> <aus>$regx{noTagAnystring}<\/aus> <auf>$regx{firstName}<\/auf><\/au>, $regx{suffix}\, /<au><par>$1<\/par> <aus>$2<\/aus> <auf>$3<\/auf>, <suffix>$4<\/suffix><\/au>\, /gs;
	$$TextBody=~s/<au><aus>$regx{particle} $regx{mAuthorFullSirName}<\/aus>/<au><par>$1<\/par> <aus>$2<\/aus>/gs;
	$$TextBody=~s/<edr><eds>$regx{firstName} $regx{mAuthorFullSirName}<\/eds>([\, ]+)<edm>$regx{suffix}<\/edm><\/edr>/<edr><edm>$1<\/edm> <eds>$2<\/eds>$3<suffix>$4<\/suffix><\/edr>/gs;
	#print $$TextBody;exit;

	$$TextBody=~s/<auf>$regx{firstName}<\/auf><\/au>\, <au><aus>$regx{suffix}<\/aus>\, <auf>$regx{and} $regx{mAuthorFullSirName}<\/auf><\/au>\, <au><aus>$regx{firstName}<\/aus>\. <auf>$regx{firstName}\.<\/auf><\/au>/<auf>$1<\/auf>\, <suffix>$2<\/suffix><\/au>\, $3 <au><aus>$4<\/aus>\, <auf>$5\. $6\.<\/auf><\/au>/gs;
	$$TextBody=~s/<au><aus>$regx{mAuthorFullSirName}<\/aus> <auf>$regx{firstName}<\/auf><\/au>\, <au><aus>$regx{mAuthorFullSirName} $regx{and} $regx{mAuthorFullSirName}<\/aus> <auf>$regx{firstName}<\/auf><\/au>/<au><aus>$1<\/aus> <auf>$2<\/auf><\/au>\, <au><aus>$3<\/aus><\/au> $4 <au><aus>$5<\/aus> <auf>$6<\/auf><\/au>/gs;

	$$TextBody=~s/<au><aus>$regx{mAuthorFullFirstName}<\/aus> <par>$regx{particle}<\/par> <auf>$regx{mAuthorFullFirstName}<\/auf><\/au>\, <au><aus>$regx{mAuthorFullSirName}<\/aus><\/au>/<au><aus>$1 $2 $3<\/aus>\, <auf>$4<\/auf><\/au>/gs;

	$$TextBody=~s/<yr>$regx{year}<\/yr> <(bt|misc1)>\[$regx{year}\]\. /<yr>$1<\/yr> \[$3\]\. <$2>/gs;

	{}while($$TextBody=~s/<au><aus>([^<>]+?)<\/aus> <auf>([A-Z \.]+)\.<\/auf><\/au> ([A-Z \-\.]+)\. <au>/<au><aus>$1<\/aus> <auf>$2\. $3\.<\/auf><\/au> <au>/gs);
	{}while($$TextBody=~s/<edr><eds>([^<>]+?)<\/eds> <edm>([A-Z \.]+)\.<\/edm><\/edr> ([A-Z \-\.]+)\. <edr>/<edr><eds>$1<\/eds> <edm>$2\. $3\.<\/edm><\/edr> <edr>/gs);
	{}while($$TextBody=~s/<doi>$regx{noTagAnystring} $regx{noTagAnystring}<\/doi>/<doi>$1$2<\/doi>/s);


	$$TextBody=~s/([\.\,\:])<\/(doi|url)>/<\/$2>$1/gs;
	$$TextBody=~s/<\/cny>\.([\:\;\,])/\.<\/cny>$1/gs;
	$$TextBody=~s/<\/pbl>\.([\:\;\,])/\.<\/pbl>$1/gs;
	$$TextBody=~s/([\,\:\.]?) ([Pp]ublished by)<\/bt> <pbl>/<\/bt>$1 $2 <pbl>/gs;
	$$TextBody=~s/<cny>$regx{monthPrefix}([0-9 ]+)<\/cny>/$1$2/gs;

	$$TextBody=~s/<edr><eds>([A-Z][a-z]+?) ([A-Z\.\- ]+)<\/eds>\, <edm><\/edm><\/edr>/<edr><eds>$1<\/eds>\, <edm>$2<\/edm><\/edr>/gs;
	$$TextBody=~s/<\/pt>\, <yr>$regx{noTagAnystring}<\/yr>\, <pg>$regx{noTagAnystring}<\/pg>$regx{optionalFullstop}<\/bib>/<\/pt>\, <yr>$1<\/yr>\, <v>$2<\/v>$3<\/bib>/gs;

	$$TextBody=~s/([A-Z])<\/auf>\. <aus>/$1\.<\/auf> <aus>/gs;
	$$TextBody=~s/<aus>$regx{noTagOpString} ([A-Z\-\. ]+)<\/aus> <auf>([A-Z\.\- ]+)<\/auf>/<aus>$1<\/aus> <auf>$2 $3<\/auf>/gs;
	$$TextBody=~s/\(<(pbl|cny)>$regx{noTagOpString}\)<\/\1>([\.\,\:])/\(<$1>$2<\/$1>\)$3/gs;
	$$TextBody=~s/<aus>([Vv]an|[Dd]en|[Dd]e)<\/aus> <auf>([Dd]e|[Dd]en|[Vv]an) ([A-Z][a-z]+) ([A-Z\.\- ]+)<\/auf>/<par>$1 $2<\/par> <aus>$3<\/aus> <auf>$4<\/auf>/gs;
	$$TextBody=~s/<\/au>\, ([A-Z][a-z][^<>]+?)\, <au><auf>([A-Z\-\. ]+)<\/auf> <par>(van der|van de|van den|du|de|da|von|van|dos|der)<\/par> <aus>(van der|van de|van den|du|de|da|von|van|dos|der)<\/aus><\/au>/<\/au>\, <au><aus>$1<\/aus>\, <auf>$2<\/auf> <par>$3 $4<\/par><\/au>/gs;
	$$TextBody=~s/<pg>$regx{noTagOpString}<\/pg>([\.\,\: \(\)\[]+)([dD][oO][iI])((?:(?!<[\/]?pg>)(?!<bib)(?!<\/bib>).)*)<pg>$regx{noTagOpString}<\/pg>/<pg>$1<\/pg>$2$3$4$5/gs;


	#-----for newblock-----
	$$TextBody=~s/<bib id=\"<([a-z0-9]+)>$regx{noTagOpString}<\/\1>\">/<bib id=\"$2\">/gs;
	$$TextBody=~s/<\/([a-z]+)>([\.\:\,])\\newblock /<\/$1>$2 \\newblock /gs;
	$$TextBody=~s/<at>\\newblock\s*/<at>/gs;
	$$TextBody=~s/\s*\\newblock<\/at>/<\/at>/gs;
	$$TextBody=~s/<at>$regx{noTagOpString}\\newblock\s*((?:(?!<at>)(?!<\/at>).)*)([\.\;\,\: ]+)\\newblock\s*((?:(?!<at>)(?!<\/at>).)+?)<\/at>([\.\, ]+)<pt>/<at>$1$2<\/at>$3 <pt>$4$5/gs;
	$$TextBody=~s/<at>([A-Za-z]+)((?:(?!<at>)(?!<\/at>).)+)([\.\;\,\: ]+)\\newblock\s*((?:(?!<at>)(?!<\/at>).)+?)<\/at>([\.\, ]+)<pt>/<at>$1$2<\/at>$3 <pt>$4$5/gs;
	$$TextBody=~s/([\.\;\,\: ]+)\\newblock\s*((?:(?!<[\/]?bt>).)*)<\/bt>([\.\;\,\: ]+)<cny>/<\/bt>$1 <pbl>$2<\/pbl>$3<cny>/gs;
	$$TextBody=~s/([\.\;\,\:]+)\s*\\newblock\s*<\/at> <pt>/<\/at>$1 <pt>/gs;
	$$TextBody=~s/([\?]+)\s*\\newblock\s*<\/at> <pt>/$1<\/at> <pt>/gs;
	$$TextBody=~s/<([a-zA+Z]+)>\\newblock\s*/<$1>/gs;
	$$TextBody=~s/\\newblock//gs;
	$$TextBody=~s/  / /gs;
	#--------------
	#$$TextBody=~s/<\/yr>\, <at><month>$regx{noTagOpString}<\/month>\)\. /xxxx/gs;
	$$TextBody=~s/<\/yr>([\.\, ]+?)<at><month>$regx{noTagAnystring}<\/month>\)([\.\,]?) /<\/yr>$1$2\)$3 <at>/gs;
	$$TextBody=~s/<pg>$regx{noTagOpString}<\/pg>([\;\,\.]) ([dD]iscussion) <pg>$regx{noTagOpString}<\/pg>$regx{optionalFullstop}<\/bib>/<pg>$1<\/pg>$2 $3 $4$5<\/bib>/gs;



	#----------------------------
	#$$TextBody=~s/<\/misc1>. <ia>In Gender issues across the life cycle<\/ia>, Hrsg. <bt>B. R. Wainrib, 107--123<\/bt>\. <cny>//gs;
	$$TextBody=~s/<\/misc1>\. <ia>([Ii]n[\.\:]?) $regx{noTagAnystring}<\/ia>\, $regx{editorSuffix} <bt>$regx{firstName} ([A-Z][a-z]+)\, $regx{pageRange}<\/bt>\. <(cny|pbl)>/<\/misc1>\. $1 <bt>$2<\/bt>\, <edrg>$3 <edr><edm>$4<\/edm> <eds>$5<\/eds><\/edr><\/edrg>\, <pg>$6<\/pg>\. <$7>/gs;
	$$TextBody=~s/<\/misc1>\. <ia>([Ii]n[\.\:]?) $regx{noTagAnystring}<\/ia>\, $regx{editorSuffix} <bt>$regx{firstName} ([A-Z][^A-Z\.\,\;\(\)0-9]+) $regx{suffix}\, $regx{pageRange}<\/bt>\. <(cny|pbl)>/<\/misc1>\. $1 <bt>$2<\/bt>\, <edrg>$3 <edr><edm>$4<\/edm> <eds>$5<\/eds> <suffix>$6<\/suffix><\/edr><\/edrg>\, <pg>$7<\/pg>\. <$8>/gs;
	$$TextBody=~s/<\/misc1>\. <ia>([Ii]n[\.\:]?) $regx{noTagAnystring}<\/ia>\, $regx{editorSuffix} <bt>$regx{firstName} ([A-Z][^A-Z\.\,\;\(\)0-9]+) $regx{suffix}([\,]?) $regx{and} $regx{firstName} ([A-Z][^A-Z\.\,\;\(\)0-9]+)\, $regx{pageRange}<\/bt>\. <(cny|pbl)>/<\/misc1>\. $1 <bt>$2<\/bt>\, <edrg>$3 <edr><edm>$4<\/edm> <eds>$5<\/eds> <suffix>$6<\/suffix><\/edr>$7 $8 <edr><edm>$9<\/edm> <eds>$10<\/eds><\/edr><\/edrg>\, <pg>$11<\/pg>\. <$12>/gs;
	$$TextBody=~s/<\/misc1>\. <ia>([Ii]n[\.\:]?) $regx{noTagAnystring}<\/ia>\, $regx{editorSuffix} <bt>$regx{firstName} ([A-Z][^A-Z\.\,\;\(\)0-9]+)([\,]?) $regx{and} $regx{firstName} ([A-Z][^A-Z\.\,\;\(\)0-9]+)\, $regx{pageRange}<\/bt>\. <(cny|pbl)>/<\/misc1>\. $1 <bt>$2<\/bt>\, <edrg>$3 <edr><edm>$4<\/edm> <eds>$5<\/eds><\/edr>$6 $7 <edr><edm>$8<\/edm> <eds>$9<\/eds><\/edr><\/edrg>\, <pg>$10<\/pg>\. <$11>/gs;
	#----------------------------


	$$TextBody=~s/<bt>$regx{noTagAnystring}\. ([Ii]n[\.\:]?) ((?:(?!<bt>)(?!<[\/]?bib).)*), $regx{editorSuffix} $regx{firstName} ([A-Z][^A-Z\.\,\;\(\)0-9]+)\, $regx{volumePrefix} $regx{volume}\, ([0-9])(th|nd|rd|st) $regx{ednPrifix}$regx{optionalFullstop}\, $regx{pageRange}<\/bt>\. <(cny|pbl)>/<misc1>$1<\/misc1>\. $2 <bt>$3<\/bt>\, <edrg>$4 <edr><edm>$5<\/edm> <eds>$6<\/eds><\/edr><\/edrg>\, $7 <v>$8<\/v>\, <edn>$9<\/edn>$10 $11$12\, <pg>$13<\/pg>\. <$14>/gs;

	#</misc1>. <ia>In Socialization, personality, and social development. Handbook of child psychology</ia>, ed. <bt>P. H. Mussen, vol. 4, 4th edn., 1â101</bt>. <cny>
	$$TextBody=~s/<\/misc1>\. <ia>([Ii]n[\.\:]?) $regx{noTagAnystring}<\/ia>\, $regx{editorSuffix} <bt>$regx{firstName} ([A-Z][a-z]+)\, $regx{volumePrefix} $regx{volume}\, ([0-9])(th|nd|rd|st) $regx{ednPrifix}$regx{optionalFullstop}\, $regx{pageRange}<\/bt>\. <(cny|pbl)>/<\/misc1>\. $1 <bt>$2<\/bt>\, <edrg>$3 <edr><edm>$4<\/edm> <eds>$5<\/eds><\/edr><\/edrg>\, $6 <v>$7<\/v>\, <edn>$8<\/edn>$9 $10$11\, <pg>$12<\/pg>\. <$13>/gs;


        #<edr><edm>H. L.</edm> <eds>Roediger III</eds>
	#<edr><edm>H. L.</edm> <eds>Roediger III</eds></edr>
	$$TextBody=~s/<edr><eds>$regx{noTagAnystring}<\/eds> <edm>$regx{suffix} $regx{noTagAnystring}<\/edm><\/edr>/<edr><eds>$1<\/eds> <suffix>$2<\/suffix> <edm>$3<\/edm><\/edr>/gs;
	$$TextBody=~s/<au><aus>$regx{noTagAnystring}<\/aus> <auf>$regx{suffix} $regx{noTagAnystring}<\/auf><\/au>/<au><aus>$1<\/aus> <suffix>$2<\/suffix> <auf>$3<\/auf><\/au>/gs;
	$$TextBody=~s/<edr><eds>$regx{noTagAnystring}<\/eds> <edm>$regx{noTagAnystring} $regx{suffix}<\/edm><\/edr>/<edr><eds>$1<\/eds> <edm>$2<\/edm> <suffix>$3<\/suffix><\/edr>/gs;
	$$TextBody=~s/<edr><eds>$regx{noTagAnystring} $regx{suffix}<\/eds>([\,]?) <edm>$regx{noTagAnystring}<\/edm><\/edr>/<edr><eds>$1<\/eds> <suffix>$2<\/suffix>$3 <edm>$4<\/edm><\/edr>/gs;
	$$TextBody=~s/<au><aus>$regx{noTagAnystring}<\/aus> <auf>$regx{noTagAnystring} $regx{suffix}<\/auf><\/au>/<au><aus>$1<\/aus> <auf>$2<\/auf> <suffix>$3<\/suffix><\/au>/gs;
	$$TextBody=~s/<au><aus>$regx{noTagAnystring} $regx{suffix}<\/aus>([\,]?) <auf>$regx{noTagAnystring}<\/auf><\/au>/<au><aus>$1<\/aus> <suffix>$2<\/suffix>$3 <auf>$4<\/auf><\/au>/gs;
	$$TextBody=~s/<edr><edm>$regx{noTagAnystring}<\/edm> <eds>$regx{noTagAnystring} $regx{suffix}<\/eds><\/edr>/<edr><edm>$1<\/edm> <eds>$2<\/eds> <suffix>$3<\/suffix><\/edr>/gs;
	$$TextBody=~s/<edr><edm>$regx{noTagAnystring}<\/edm> <eds>$regx{suffix} $regx{noTagAnystring}<\/eds><\/edr>/<edr><edm>$1<\/edm> <suffix>$2<\/suffix> <eds>$3<\/eds><\/edr>/gs;
	$$TextBody=~s/<au><auf>$regx{noTagAnystring}<\/auf> <aus>$regx{noTagAnystring} $regx{suffix}<\/aus><\/au>/<au><auf>$1<\/auf> <aus>$2<\/aus> <suffix>$3<\/suffix><\/au>/gs;
	$$TextBody=~s/<au><auf>$regx{noTagAnystring}<\/auf> <aus>$regx{suffix} $regx{noTagAnystring}<\/aus><\/au>/<au><auf>$1<\/auf> <suffix>$2<\/suffix> <aus>$3<\/aus><\/au>/gs;


	$$TextBody=~s/<\/pt>([\.\,\; ]+)([0-9]+[\.]?) <pt>([A-Z][a-z]+)<\/pt>([\.\,]?) <yr>/<\/pt>$1$2 $3$4 <yr>/gs;
	$$TextBody=~s/<cny>Frankfurt a\. M<\/cny>\./<cny>Frankfurt a. M\.<\/cny>/gs;
	$$TextBody=~s/([A-Z])\.([\s]?[A-Z])<\/auf><\/au><\/aug>\. /$1\.$2\.<\/auf><\/au><\/aug> /gs;
	$$TextBody=~s/([A-Z])\.([\s]?[A-Z])<\/edm><\/edr><\/edrg>\. /$1\.$2\.<\/edm><\/edr><\/edrg> /gs;
	$$TextBody=~s/<auf>([A-Z][A-Z]+) ([A-Z][A-Z]+|A)<\/auf><\/au><\/aug> ([A-Z][a-z]+)/<auf>$1<\/auf><\/au><\/aug> $2 $3/gs;

	$$TextBody=~s/<ia>([A-Z][A-Z]+)\. ([^<>]+?)<\/ia> <yr>([^<>]+)<\/yr> to ([0-9]+)\. \($regx{year}\)\. ([Ff]inal [Rr]eport|[A-Z][a-z]+ )/<ia>$1<\/ia>\. $2 $3 to $4\. \(<yr>$5<\/yr>\)\. $6/gs;
	#<p><bib id="bib16"><ia>Meeting of the OECD</ia> <bt>Council at Ministerial Level. (2011, 25-26 May</bt>, <cny>Paris</cny>). <i>Report on the gender initiative: Gende
	$$TextBody=~s/<ia>([^<>]+?)<\/ia> <bt>([^<>]+?)\. \($regx{year}\, ([^<>]+?)<\/bt>\, <cny>([^<>]+?)<\/cny>\)/<ia>$1 $2<\/ia>\. \($3\, $4\, $5\)/gs;


	########****************
	$$TextBody=~s/<bib$regx{noTagOpString}>([^<>]+?)([\.\, ]+[\(]?)$regx{year}([a-z]?)([\)?][\.]? <i>|[\)?][\.]? [A-Z][a-z]+)/<bib$1><ia>$2<\/ia>$3<yr>$4$5<\/yr>$6/gs;
	$$TextBody=~s/<ia>(\&lt\;number\&gt\;\d+[\.]?\&lt\;\/number\&gt\;)/$1<ia>/gs;

	$$TextBody=~s/<\/aug>\, ([^<>]+?) ([\(]?)<(yr|at|bt)>/\, <ia>$1<\/ia><\/aug> $2<$3>/gs;
	$$TextBody=~s/<\/au>([\)\.\,\; ]+)<ia>([iI]n[\:\.]?)<\/ia><\/aug>([\.\,\: ]+)<(bt|at)>/<\/au><\/aug>$1$2$3<$4>/gs;
	$$TextBody=~s/<\/aug>([\,]?) \(([^<>]+?)\)([\. ]+[\(]?)<(yr|at|bt)>/$1 <ia>\($2\)<\/ia><\/aug>$3<$4>/gs;
	$$TextBody=~s/<\/etal>([\.\,\; ]+)<ia>([iI]n[\:\.]?)<\/ia><\/aug>([\.\,\: ]+)<(bt|at)>/<\/etal><\/aug>$1$2$3<$4>/gs;

	$$TextBody=~s/<bib$regx{noTagOpString}><ia>$regx{noTagOpString}<\/ia> <yr>$regx{noTagOpString}<\/yr> \($regx{year}\)/<bib$1><ia>$2 $3<\/ia> \(<yr>$4<\/yr>\)/gs;
	$$TextBody=~s/<bib$regx{noTagOpString}><ia>$regx{noTagOpString}<\/ia> <yr>$regx{noTagOpString}<\/yr>\-([0-9]+) \($regx{year}\)/<bib$1><ia>$2 $3\-$4<\/ia> \(<yr>$5<\/yr>\)/gs;
	$$TextBody=~s/<\/i>$regx{optionalFullstop} $regx{year}<\/bt>\, <pbl>$regx{noTagOpString}<\/pbl>$regx{optionalFullstop}<\/bib>/<\/i><\/bt>$1 <yr>$2<\/yr>\, <pbl>$3<\/pbl>$4<\/bib>/gs;
	$$TextBody=~s/<\/i>$regx{optionalFullstop} $regx{year}<\/bt>\, <pbl>$regx{noTagOpString}<\/pbl>([\s\.\,]+[SPp]+[.]?[\s]?)<pg>$regx{noTagOpString}<\/pg>$regx{optionalFullstop}<\/bib>/<\/i><\/bt>$1 <yr>$2<\/yr>\, <pbl>$3<\/pbl>$4<pg>$5<\/pg>$6<\/bib>/gs;

	$$TextBody=~s/<\/au>\, ([A-Za-z\- ]+) <au><aus>$regx{noTagOpString}<\/aus> <auf>$regx{noTagOpString}<\/auf><\/au>/<\/au>\, <au><aus>$1 $2<\/aus> <auf>$3<\/auf><\/au>/gs;

	$$TextBody=~s/<ia>$regx{noTagOpString}<\/ia>((?:(?!<pg>)(?!<[\/]?bib>).)*)<ia>$regx{noTagOpString}<\/ia>/<ia>$1<\/ia>$2<edrg>$3<\/edrg>/gs;
	$$TextBody=~s/<edrg>([iI]n[\.:]?) $regx{noTagOpString} \($regx{editorSuffix}\)<\/edrg>/<edrg>$1 <edr>$2<\/edr> \($3\)<\/edrg>/gs;

	$$TextBody=~s/<\/aug> <at>\(([0-9]+[.]? [JFMASOND][a-z]+) $regx{year}\)\. ((?:(?!<at>)(?!<\/at>).)*)<\/at>/<\/aug> \($1 <yr>$2<\/yr>\)\. <at>$3<\/at>/gs;

#	$$TextBody=~s/<au><aus>$regx{noTagAnystring}<\/aus> <auf>$regx{noTagAnystring}<\/auf><\/au><\/aug>. <at>([$AuthorString ]+) ([A-Z\. ]+). ([A-Za-z]+)/<au><aus>$1<\/aus> <auf>$2<\/auf><\/au>. <au><aus>$3<\/aus> <auf>$4<\/auf><\/au><\/aug>. <at>$5/gs;
#	print $$TextBody;exit;
	$$TextBody=~s/<pbl>Cambridge<\/pbl>\: <pbl>/<cny>Cambridge<\/cny>\: <pbl>/gs;
	$$TextBody=~s/<pbl>$regx{noTagOpString}<\/pbl>([\, ]+)<cny>$regx{noTagOpString}<\/cny>([\:\, ]+)<pbl>/<cny>$1$2$3<\/cny>$4<pbl>/gs;
	$$TextBody=~s/<\/pbl>\.([\:\;\,]) <cny>/\.<\/pbl>$1 <cny>/gs;
	$$TextBody=~s/<pt>([\s]*)<\/pt>/$1/gs;

	$$TextBody=~s/  / /gs;
	$$TextBody=~s/\s*<([a-z0-9A-Z]+)><\/b>([\:\,\.\; ]+)/<\/b>$2<$1>/gs;
	$$TextBody=~s/<b><bib$regx{noTagOpString}>/<bib$1><b>/gs;

	$$TextBody=~s/<au><auf>([A-Z\-\.]+)<\/auf> <aus>$regx{noTagOpString}<\/aus><\/au>, <au><auf>([A-Z\-\.]+)<\/auf><aus><\/aus><\/au>, <au><auf>$regx{noTagOpString}<\/auf><aus><\/aus><\/au>\,/<au><auf>$1<\/auf> <aus>$2<\/aus><\/au>, <au><auf>$3<\/auf> <aus>$4<\/aus><\/au>\,/gs;

	$$TextBody=~s/\. ([0-9]+)([\.,]+) ([a-z]+[\.]?) und ([a-z]+[\.]?) Aufl<\/bt>([\.]+) <pbl>/<\/bt>\. $1$2 $3 und $4 Aufl$5 <pbl>/gs;
	$$TextBody=~s/\. ([0-9]+)([\.,]+) ([a-z]+[\.]?) ([^A-Z\.\,<>]+[\.]?) und ([a-z]+[\.]?) Aufl<\/bt>([\.]+) <pbl>/<\/bt>\. $1$2 $3 $4 und $5 Aufl$6 <pbl>/gs;
	$$TextBody=~s/\. ([0-9]+)([\.,]+) ([a-z]+[\.]?) Aufl<\/bt>([\.]+) <pbl>/<\/bt>\. $1$2 $3 Aufl$4 <pbl>/gs;

	$$TextBody=~s/\. ([Ii]n)<\/at>([\.\:]) <pt>/<\/at>\. $1$2 <pt>/gs;
	$$TextBody=~s/<\/pt>([\. ]*)<pt>$regx{volumePrefix}<\/pt>([\. ]*)<v>/<\/pt>$1$2$3<v>/gs;
	$$TextBody=~s/<\/pt>([\. ]*)<pt>$regx{volumePrefix}<\/pt>([\. ]*)<v>/<\/pt>$1$2$3<v>/gs;
	$$TextBody=~s/<pt>(S|pp|P)<\/pt>$regx{optionalFullstop} <v>([0-9]+[A-Z]?)\-<\/v>\-<pg>([0-9]+[A-Z]?)<\/pg>/$1$2 <pg>$3\-\-$4<\/pg>/gs;
	$$TextBody=~s/ <aus>et<\/aus> <auf>al<\/auf>/ et al/gs;
	$$TextBody=~s/<auf>([A-Z\-\. ]+)<\/auf><\/au>\, ([A-Z\-\.\, ]+)<\/aug>\.: /<auf>$1\, $2\.<\/auf><\/au> <\/aug>:/gs;



	while($$TextBody=~/<aus>$regx{noTagOpString} $regx{instName} $regx{noTagOpString}<\/aus> <auf>(.*?)<\/auf>/)
	  {
	    $$TextBody=~s/<aus>$regx{noTagOpString} $regx{instName} $regx{noTagOpString}<\/aus> <auf>(.*?)<\/auf>/<ia>$1 $2 $3 $4<\/ia>/os;
	  }

	  $$TextBody=~s/<ia>([Ii]n[\:\.\, ]+)([A-Z][^0-9\.\,\;\&]+?) ([A-Z][^0-9\.\,\;\&]+?) \($regx{editorSuffix}([\.]?)\)<\/ia>/$1<ia>$2 $3<\/ia> \($4$5\)/s;
	  $$TextBody=~s/<ia>([Ii]n[\:\.\, ]+)([A-Z][^0-9\.\,\;\&]+?) ([A-Z][^0-9\.\,\;\&]+?) $regx{editorSuffix}([\.]?)<\/ia>/$1<ia>$2 $3<\/ia> $4$5/s;
	  $$TextBody=~s/<bib([^<>]*?)><ia>([A-Z][^0-9\.\,\;\&]+?) ([A-Z][^0-9\.\,\;\&]+?) \($regx{editorSuffix}([\.]?)\)<\/ia>/<bib$1><ia>$2 $3<\/ia> \($4$5\)/s;
	  $$TextBody=~s/<bib([^<>]*?)><ia>([A-Z][^0-9\.\,\;\&]+?) ([A-Z][^0-9\.\,\;\&]+?) $regx{editorSuffix}([\.]?)<\/ia>/<bib$1><ia>$2 $3<\/ia> $4$5/s;

	  $$TextBody=~s/<ia>([Ii]n[\:\.\, ]+)([A-Z][^0-9\.\,\;\&]+?) ([A-Z][^0-9\.\,\;\&]+?) \($regx{editorSuffix}([\.]?)\)<\/ia>/$1<ia>$2 $3<\/ia> \($4$5\)/s;



	$$TextBody=~s/<aus>([^<>]*)([Aa]merica|[Aa]merican [\w]+|[Aa]ssociation|[Cc]enter[s]?|[Dd]epartment[s]?|[Rr]esearch[s]?|[Uu]nit[s]?|[cC]ommunity|[mM]ember[s]?|NASA|[Nn]aturschutz|[Dd]eutschen|[Cc]onvention|[Vv]isitor[s]?|[Tt]echnologie|[Pp]olicy|[Ii]nstitute[s]?|[Hh]ealth|[Ss]ervice[s]?|[Uu]nited|state[s]|[Cc]hinese|[Pp]atient[s]?|[Nn]ational|--|[Aa]rbeitszeitmanagement|[Cc]orporate|[C]ouncil|[Vv]erlag|[Cc]rossculture|[Mm]anagement[s]?|[Ww]estern [A-Z][a-z]+|[Gg]roup[s]?|[Bb]ioscience[s]?|[Tt]eam|[Dd]evelopment[s]?|[Pp]roduct[s]?|[Tt]raining|[Mm]odule[s]?|[Rr]esource[s]?|[Ii]nitiative|[Mm]ediengruppe|[Pp]resserat|[Ii]nstituto|[Ww]eekly|[Uu]pdate|[Ee]nvironment|[Nn]ational|[Ss]tatistic[s]?|Inc| [Bb]erlin |[Rr]aumordnung|[Vv]erkehrslenkung|[Pp]lanung|[Ii]nstrumente|[Rr]aumentwicklung|[Ll]eitbilder|[Rr]aumordnungspolitik|[Ll]eipzig|[I]nternational|[Cc]entre|ISSN|[dD]ictionary|[mM]edical|[aA]ngiogenesis|[Aa]nonymous|[Cc]ontrol[s]?|[Mm]odule|WHO|IPCC|ICSU|[Cc]ancer|[Ee]arly|[Bb]reast|[iI]nnovation|[Aa]ssociation|[Ss]tatistische[s]?|[Bb]undesamt|[Ff]inal[s]?|[Pp]ress|[Ss]urvey|[Rr]elease|[Nn]ews|[Ff]oundation|[Ss]ocial|[Ww]orld|[Oo]rganization|[Gg]eneric|[Mm]oney|[eE]xample[s]?|[tt]ypes|[Ww]ebsite|[Ll]atin|PSIM|[Ff]unctionalized|[Nn]anocomposite|[Cc]ollaboration|[Cc]ollege|[Cc]hemical|[Ss]erver|[Bb]ook|[Cc]hloramine[s]?|[dD]atabase|FAOSTAT|[Aa]ustralia|[^<>\-]+?[Cc]ompany)\b([^<>]*)<\/aus> <auf>(.*?)<\/auf>/<ia>$1$2$3 $4<\/ia>/s;


	#<auf>J. G. J. van de</auf></au>
	$$TextBody=~s/<auf>([A-Z\.\- ]+) (van der|van de|van den|du|de|da|von|van|dos)<\/auf><\/au>/<auf>$1<\/auf> <par>$2<\/par><\/au>/gs;

	$$TextBody=~s/<au><aus>$regx{noTagOpString}<\/aus> <auf>([A-Z\- \.]+)<\/auf><\/au>\, $regx{suffix}\,/<au><aus>$1<\/aus> <auf>$2<\/auf>\, <suffix>$3<\/suffix><\/au>\,/gs; 

	$$TextBody=~s/<au><aus>$regx{noTagOpString}<\/aus> <auf>([A-Z\- \.]+)<\/auf><\/au>([\,]?) $regx{suffix}<\/aug>/<au><aus>$1<\/aus> <auf>$2<\/auf>$3 <suffix>$4<\/suffix><\/au><\/aug>/gs; 

	$$TextBody=~s/ <au><auf>$regx{and} ([A-Z\- \.]+)<\/auf> <aus>$regx{noTagOpString}<\/aus><\/au>/ $1 <au><auf>$2<\/auf> <aus>$3<\/aus><\/au>/gs;

	$$TextBody=~s/ <au><aus>$regx{and} $regx{noTagOpString}<\/aus>/ $1 <au><aus>$2<\/aus>/gs;
	#*********temp Code

	$$TextBody=~s/\, <au><aus>([A-Z\-\. ]+) ([A-Z][^<>]*?)<\/aus><auf><\/auf><\/au>\, /\, <au><auf>$1<\/auf> <aus>$2<\/aus><\/au>\, /gs;

	$$TextBody=~s/ <au><aus>$regx{and} <au><aus>$regx{noTagOpString}<\/aus> <auf>$regx{noTagOpString}<\/aus> <auf>$regx{noTagOpString}<\/auf><\/au><\/auf><\/au>/ $1 <au><aus>$2<\/aus> <auf>$3 $4<\/auf><\/au>/gs;
	$$TextBody=~s/ <au><aus><au><aus>$regx{noTagOpString}<\/aus> <auf>(van der|van de|van den|du|de|da|von|van|dos)<\/aus> <auf>$regx{noTagOpString}<\/auf><\/au><\/auf><\/au>/ <au><aus>$1 $2<\/aus> <auf>$3<\/auf><\/au>/gs;
	#------

	$$TextBody=~s/<aus>$regx{noTagOpString}<\/aus> <auf>([A-Z\- \.]+)\. $regx{noTagOpString} ([a-z\-\'\, ]+) ([a-z\-\']+)<\/auf>\. <at>((?:(?!<at>)(?!<\/at>).)*)<\/at>/<aus>$1<\/aus> <auf>$2<\/auf>\. <at>$3 $4 $5\. $6<\/at>/gs;
	$$TextBody=~s/<aus>$regx{noTagOpString}<\/aus> <auf>([A-Z\- \.]+)\. $regx{noTagOpString} ([a-z\-\']+)<\/auf>. <at>((?:(?!<at>)(?!<\/at>).)*)<\/at> <pt>([A-Z][a-zA-Z ]+)<\/pt>\./<aus>$1<\/aus> <auf>$2<\/auf>. <at>$3 $4<\/at>\. <pt>$5 $6<\/pt>\./gs;
	$$TextBody=~s/<aus>$regx{noTagOpString}<\/aus> <auf>([A-Z\- \.]+)\. $regx{noTagOpString} ([a-z\-\']+)<\/auf>\. <at>((?:(?!<at>)(?!<\/at>).)*)<\/at>\./<aus>$1<\/aus> <auf>$2<\/auf>\. <at>$3 $4\. $5<\/at>\. /gs;


	$$TextBody=~s/<edrg>([Ii]n[\:\. ]+)<edr><eds>([$AuthorString]+)<\/eds> <edm>$regx{and} ([$AuthorString]+)<\/edm><\/edr> \(/<edrg>$1<edr><eds>$2<\/eds><\/edr> $3 <edr><eds>$4<\/eds><\/edr> \(/gs;
	$$TextBody=~s/<edrg>([Ii]n[\:\. ]+)<edr><eds>([$AuthorString]+)<\/eds> <edm>$regx{and} ([$AuthorString]+)<\/edm><\/edr>([\.\, ]+)$regx{editorSuffix}/<edrg>$1<edr><eds>$2<\/eds><\/edr> $3 <edr><eds>$4<\/eds><\/edr>$5$6/gs;


	$$TextBody=~s/<aus>$regx{noTagOpString}<\/aus> <auf>$regx{noTagOpString}<\/auf>\, <aus>([a-z]+)<\/aus> <auf>([a-z]+)<\/auf>/<ia>$1 $2\, $3 $4<\/ia>/gs;
	$$TextBody=~s/<aus>$regx{noTagOpString} ([a-z]+) ([a-z]+)<\/aus> <auf>([a-z]+)$regx{optionalFullstop} $regx{noTagOpString}<\/auf>/<ia>$1 $2 $3 $4$5 $6<\/ia>/gs;

	$$TextBody=~s/<ia>$regx{noTagOpString}\. $regx{noTagOpString}<\/ia>\, <ia>$regx{noTagOpString}<\/ia> <at>/<ia>$1<\/ia>\. <at>$2\, $3 /gs;
	$$TextBody=~s/\, <ia>$regx{and} /\, $1 <ia>/gs;

	$$TextBody=~s/<aus>et<\/aus> <auf>al\. $regx{noTagOpString}<\/auf>\, <aus>$regx{noTagOpString}<\/aus> <auf>$regx{noTagOpString}<\/auf> <at>$regx{noTagOpString}<\/at>/et al\. <at>$1\, $2 $3 $4<\/at>/gs;
	$$TextBody=~s/<au><aus>([A-Z][^<>]*?) ([A-Z\-\. ]+[a-z]?[A-Z\-\. ]+)<\/aus>\, <auf>([A-Z][^<>]*?) ([A-Z\.\- ]+)<\/auf><\/au>/<au><aus>$1<\/aus> <auf>$2<\/auf><\/au>\, <au><aus>$3<\/aus> <auf>$4<\/auf><\/au>/gs;

	#$$TextBody=~s/Dick JMcP, Dewar ()//gs;

#-----
	$$TextBody=~s/\?<\/at> ([Ii]n)<\/at>/\?<\/at><\/at> $1/gs;
	$$TextBody=~s/<\/at>([\.\, \:\?\;]+)<\/at>/$1<\/at><\/at>/gs;
	$$TextBody=~s/<\/at> ([Ii]n)<\/at>/<\/at><\/at> $1/gs;
	$$TextBody=~s/<pt>((?:(?!<pt>)(?!<\/pt>).)*)<\/pt> <v>([A-Za-z])([^0-9]+)([A-Za-z])<\/v> <iss>([0-9A-Z]+)<\/iss>\:<pg>/<pt>$1 $2$3$4<\/pt> <v>$5<\/v>\:<pg>/gs;
	$$TextBody=~s/<par>$regx{noTagOpString}<\/par>\, <par>$regx{noTagOpString}<\/par>\, /<par>$1, $2<\/par>\, /gs;
	$$TextBody=~s/<par>$regx{noTagOpString}<\/par>\, <par>$regx{noTagOpString}<\/par>\. /<par>$1, $2<\/par>\. /gs;
	$$TextBody=~s/<aus>$regx{noTagOpString}<\/aus>\(<yr>/<aus>$1<\/aus> \($2/gs;
	$$TextBody=~s/<i><pt>$regx{noTagOpString}<\/pt>,<v>$regx{noTagOpString}<\/v><\/i>, <pg>$regx{noTagAnystring}<\/pg>/<i><pt>$1<\/pt>, <v>$2<\/v><\/i>, <pg>$3<\/pg>/gs;
	$$TextBody=~s/<i><pt>$regx{noTagOpString}<\/pt><\/i>\(pp\. <pg>/<i><pt>$1<\/pt><\/i> \(pp\. <pg>/gs; 
	$$TextBody=~s/<i><pt>$regx{noTagOpString}<\/pt>\,<v>$regx{noTagOpString}<\/v><\/i>/<i><pt>$1<\/pt>\, <v>$2<\/v><\/i>/gs;

	$$TextBody=~s/<aus>et<\/aus> <auf>al([\.]*)<\/auf>/et al$1/gs;  #****Exception 
	$$TextBody=~s/<auf>et<\/auf> <aus>al([\.]*)<\/aus>/et al$1/gs;
	$$TextBody=~s/<aus>([A-Z][^<>]*?)<\/aus><aus>([a-z][^<>]*?)<\/aus>/<aus>$1$2<\/aus>/gs;
	$$TextBody=~s/<aus>$regx{noTagAnystring} (van der|van de|van den|du|de|da|von|van|dos)<\/aus> <auf>([A-Z\-\. ]+)<\/auf>/<aus>$1<\/aus> <par>$2<\/par> <auf>$3<\/auf>/gs;
	$$TextBody=~s/<aus>$regx{noTagAnystring} (Jr|Jr\.|Sr|Sr\.|2nd|2nd\.|3rd|3rd\.|4th|4th\.|Mac|II|III|Van|De|Jac|Yu)<\/aus> <auf>([A-Z\-\. ]+)<\/auf>/<aus>$1<\/aus> <suffix>$2<\/suffix> <auf>$3<\/auf>/gs;
	#

	$$TextBody=~s/<aus>$regx{noTagAnystring}<\/aus> <auf>([A-Z\-\.])<\/auf>([A-Z])([\.]*) /<aus>$1<\/aus> <auf>$2$3$4<\/auf>/gs;
	$$TextBody=~s/<auf>$regx{noTagAnystring}<\/auf> <aus>([A-Z\.\-]+)<\/aus>([\.\,]*) \(<yr>$regx{noTagAnystring}<\/yr>\)/<aus>$1<\/aus> <auf>$2<\/auf>$3 (<yr>$4<\/yr>)/gs;
	$$TextBody=~s/<auf>$regx{noTagAnystring}<\/auf> <aus>([A-Z\.\-]+)<\/aus>([\.\,]*) <yr>$regx{noTagAnystring}<\/yr>/<aus>$1<\/aus> <auf>$2<\/auf>$3 <yr>$4<\/yr>/gs;
	$$TextBody=~s/<auf>$regx{noTagAnystring}<\/auf> <aus>([A-Z\.\-]+)<\/aus> et al. \(<yr>$regx{noTagAnystring}<\/yr>\)/<aus>$1<\/aus> <auf>$2<\/auf> et al. (<yr>$3)/gs;

	$$TextBody=~s/<aus>$regx{noTagAnystring} ([A-Z\-\. ]+)<\/aus> <auf>([A-Z\-\.])<\/auf>/<aus>$1<\/aus> <auf>$2 $3<\/auf>/gs;
	$$TextBody=~s/<aus>$regx{noTagAnystring} ([A-Z\-\. ]+)<\/aus> <auf>([a-z])<\/auf>/<aus>$1<\/aus> <auf>$2 $3<\/auf>/gs;


	$$TextBody=~s/<aus>$regx{noTagAnystring}<\/aus> <auf>$regx{noTagAnystring}<\/auf> <prefix>([A-Z])<\/prefix>/<aus>$1 $2<\/aus> <auf>$3<\/auf>/gs;



#	$$TextBody=~s/<aus>(Jr|Jr\.|Sr|Sr\.|2nd|2nd\.|3rd|3rd\.|4th|4th\.|Mac|du|de|II|III|von|van|dos|Van|De|Jac|Yu)<\/aus> <auf>$regx{noTagAnystring}<\/auf> <prefix>([A-Z]+)<\/prefix>/<par>$1<\/par> <aus>$2<\/aus> <auf>$3<\/auf>/gs;
	$$TextBody=~s/<aus>(Jr|Jr\.|Sr|Sr\.|2nd|2nd\.|3rd|3rd\.|4th|4th\.|Mac|du|de|da|II|III|von|van|dos|Van|De|Jac|Yu)<\/aus> <auf>$regx{noTagAnystring}<\/auf> <prefix>([A-Z]+)<\/prefix>/<aus>$1 $2<\/aus> <auf>$3<\/auf>/gs;


	$$TextBody=~s/<par>([A-Z][a-z]+)<\/par><aus>([a-z])$regx{noTagOpString}<\/aus>/<aus>$1$2$3<\/aus>/gs;
	$$TextBody=~s/<prefix>([A-Z][a-z]+)<\/prefix><aus>([a-z])$regx{noTagOpString}<\/aus>/<aus>$1$2$3<\/aus>/gs;

	$$TextBody=~s/<aus>$regx{noTagAnystring}([\,\.]*) ([A-Z\-\.]+)<\/aus>([\,\.]*) <auf>(Jr[\.]?|Sr[\.]?|2nd[\.]?|3rd[\.]?|4th[\.]?|Mac|du|de|da|II|III|von|van|dos|Van|De|Jac|Yu)<\/auf>/<aus>$1<\/aus>$2 <auf>$3<\/auf>$4 <suffix>$5<\/suffix>/gs;  #****Exception 

	$$TextBody=~s/<aus>$regx{noTagAnystring}<\/aus>([\,\.]*) <auf>([A-Z\-\.]+)<\/auf>([\,\.]*) (Jr[\.]?|Sr[\.]?|2nd[\.]?|3rd[\.]?|4th[\.]?|Mac|du|de|da|II|III|von|van|dos|Van|De|Jac|Yu)([\,\;\:\.]*) /<aus>$1<\/aus>$2 <auf>$3<\/auf>$4 <suffix>$5<\/suffix>$6 /gs;  #****Exception 

	$$TextBody=~s/<auf>(Jr[\.]?|Sr[\.]?|2nd[\.]?|3rd[\.]?|4th[\.]?|Mac|du|de|da|II|III|von|van|dos|Van|De|Jac|Yu)<\/auf>([\,\.]*) <aus>([A-Z\-\.]+)([\,\.]*) $regx{noTagAnystring}<\/aus>/<par>$1<\/par>$2 <auf>$3<\/auf>$4 <aus>$5<\/aus>/gs;  #****Exception 

	$$TextBody=~s/(Jr[\.]?|Sr[\.]?|2nd[\.]?|3rd[\.]?|4th[\.]?|Mac|du|de|da|II|III|von|van|dos|Van|De|Jac|Yu)([\,\.]*) <auf>([A-Z\-\.]+)<\/auf>([\,\.]*) <aus>$regx{noTagAnystring}<\/aus>/<par>$1<\/par>$2 <auf>$3<\/auf>$4 <aus>$5<\/aus>/gs;  #****Exception 
	$$TextBody=~s/<aus>$regx{noTagOpString}<\/aus>\, <auf>([Jj]r[\.]?|[Ss]r[\.]?) ([A-Z\.\-]+)<\/auf>/<aus>$1<\/aus>\, <par>$2<\/par> <auf>$3<\/auf>/gs;

	$$TextBody=~s/<aus>$regx{noTagAnystring}<\/aus>([\,\.]*) <auf>$regx{noTagAnystring}<\/auf>([\,\.]*) <suffix>(Jr[\.]?|Sr[\.]?|2nd[\.]?|3rd[\.]?|4th[\.]?|Mac|du|de|da|II|III|von|van|dos|Van|De|Jac|Yu)<\/suffix>/<aus>$1<\/aus>$2 <auf>$3<\/auf>$4 <suffix>$5<\/suffix>/gs;  #****Exception 

	$$TextBody=~s/<aus>$regx{noTagAnystring}<\/aus>([\,\.]*) <auf>$regx{noTagAnystring}<\/auf>([\,\.]*) <par>(Jr[\.]?|Sr[\.]?|2nd[\.]?|3rd[\.]?|4th[\.]?|Mac|du|de|da|II|III|von|van|dos|Van|De|Jac|Yu)<\/par>/<aus>$1<\/aus>$2 <auf>$3<\/auf>$4 <suffix>$5<\/suffix>/gs;  #****Exception 


	$$TextBody=~s/<aus>$regx{noTagAnystring}<\/aus>([\,\.]*) <auf>([A-Z\.\- ]+)<\/auf> <ia>([A-Z\.]+)<\/ia>/<aus>$1<\/aus>$2 <auf>$3 $4<\/auf>/gs;

	#$$TextBody=~s/(<\/aug>|<\/ia>|<\/edrg>)([\)\.\:\;\,]*) ([a-zA-Z]+[^<>]+?)(\. [\(]?)<yr>$regx{noTagAnystring}<\/yr>([\.\,\) ]+)<pt>$regx{noTagAnystring}<\/pt>([\.\, ]+)<v>$regx{noTagAnystring}<\/v>([\.\,\:\; \(]+)<iss>$regx{noTagAnystring}<\/iss>/$1$2 <at>$3<\/at>$4<yr>$5<\/yr>$6<pt>$7<\/pt>$8<v>$9<\/v>$10<iss>$11<\/iss>$12<pg>$13<\/pg>$14<\/bib>/gs;


	$$TextBody=~s/<au><aus>$regx{noTagAnystring}<\/aus>\, <auf>([A-Z\.\- ]+) $regx{and} $regx{noTagAnystring} ([A-Z\.\- ]+)<\/auf><\/au>/<au><aus>$1<\/aus>\, <auf>$2<\/auf><\/au> $3 <au><aus>$4<\/aus> <auf>$5<\/auf><\/au>/gs;
	$$TextBody=~s/<aus>$regx{noTagAnystring}<\/aus>\, <auf>([A-Z\.\- ]+) $regx{and} $regx{noTagAnystring} ([A-Z\.\- ]+)<\/auf>/<aus>$1<\/aus>\, <auf>$2<\/auf> $3 <aus>$4<\/aus> <auf>$5<\/auf>/gs;
	$$TextBody=~s/<au><aus>$regx{noTagAnystring}<\/aus>\, <auf>([A-Z\.\- ]+) $regx{and} ([A-Z\.\- ]+) $regx{noTagAnystring}<\/auf><\/au>/<au><aus>$1<\/aus>\, <auf>$2<\/auf><\/au> $3 <au><auf>$4<\/auf> <aus>$5<\/aus><\/au>/gs;

	$$TextBody=~s/<aus>$regx{noTagAnystring}<\/aus>\, <auf>([A-Z\.\- ]+) $regx{and} ([A-Z\.\- ]+) $regx{noTagAnystring}<\/auf>/<aus>$1<\/aus>\, <auf>$2<\/auf> $3 <auf>$4<\/auf> <aus>$5<\/aus>/gs;

	$$TextBody=~s/<aus>$regx{noTagAnystring}<\/aus>\, <auf>([A-Z\.\- ]+) $regx{and} $regx{noTagAnystring} $regx{noTagAnystring}<\/auf>/<aus>$1<\/aus>\, <auf>$2<\/auf> $3 <aus>$4<\/aus> <auf>$5<\/auf>/gs;

	$$TextBody=~s/<au><aus>$regx{noTagAnystring}<\/aus>([\,]*) <auf>$regx{noTagAnystring} $regx{and} $regx{noTagAnystring} ([A-Z\.r \-I321]+?)<\/auf><\/au>/<au><aus>$1<\/aus>$2 <auf>$3<\/auf> $4 <aus>$5<\/aus> <auf>$6<\/auf><\/au>/gs;

	$$TextBody=~s/ <au><aus>(aun|and|\&|\&amp\;) $regx{noTagAnystring}<\/aus>([\,]*) <auf>$regx{noTagAnystring}<\/auf><\/au>/ $1 <au><aus>$2<\/aus>$3 <auf>$4<\/auf><\/au>/gs;


	$$TextBody=~s/<au><aus>$regx{noTagAnystring}<\/aus>([\,]*) <auf>([A-Z\.\- ]+)([\,]*) et al([\.\,]*)<\/auf><\/au>/<au><aus>$1<\/aus>$2 <auf>$3<\/auf><\/au>$4 et al$5/gs;
	$$TextBody=~s/<aus>$regx{noTagAnystring}<\/aus>([\,]*) <auf>([A-Z\.\- ]+)([\,]*) et al([\.\,]*)<\/auf>/<aus>$1<\/aus>$2 <auf>$3<\/auf>$4 et al$5/gs;
	$$TextBody=~s/<au><aus>et al([\.]*)<\/aus>([\,]*) <auf><\/auf><\/au>/et al$1$2/gs;
	$$TextBody=~s/<au><aus>et al([\.]*)<\/aus><\/au>/et al$1/gs;
	$$TextBody=~s/<aus>et al([\.]*)<\/aus>/et al$1/gs;
	$$TextBody=~s/<au><aus>$regx{noTagAnystring} ([A-Z\.\- ]+)<\/aus>\, <auf><\/auf><\/au>/<au><aus>$1<\/aus> <auf>$2<\/auf><\/au>\,/gs;

	$$TextBody=~s/<au><auf>$regx{noTagAnystring}<\/auf>([\,]*) <aus>$regx{noTagAnystring}([\,]*) et al([\.\,]*)<\/aus><\/au>/<au><auf>$1<\/auf>$2 <aus>$3<\/aus><\/au>$4 et al$5/gs;
	$$TextBody=~s/<auf>$regx{noTagAnystring}<\/auf>([\,]*) <aus>$regx{noTagAnystring}([\,]*) et al([\.\,]*)<\/aus>/<auf>$1<\/auf>$2 <aus>$3<\/aus>$4 et al$5/gs;
	$$TextBody=~s/<au><auf>et al([\.]*)<\/auf>([\,]*) <aus><\/aus><\/au>/et al$1$2/gs;
	$$TextBody=~s/<au><auf>et al([\.]*)<\/auf><\/au>/et al$1/gs;
	$$TextBody=~s/<auf>et al([\.]*)<\/auf>/et al$1/gs;
	$$TextBody=~s/ <aus>$regx{and} $regx{noTagAnystring}<\/aus>([\,]*) <auf>$regx{noTagAnystring}<\/auf>/ $1 <aus>$2<\/aus>$3 <auf>$4<\/auf>/gs;
	$$TextBody=~s/<edr><edm>$regx{noTagAnystring}<\/edm>([\.\,\/\; ]+)<eds>$regx{noTagAnystring} $regx{and}<\/eds><\/edr>/<edr><edm>$1<\/edm>$2<eds>$3<\/eds><\/edr> $4/gs;
	$$TextBody=~s/<edr><eds>$regx{noTagAnystring}<\/eds>([\.\,\/\; ]+)<edm>$regx{noTagAnystring} $regx{and}<\/edm><\/edr>/<edr><eds>$1<\/eds>$2<edm>$3<\/edm><\/edr> $4/gs;

	$$TextBody=~s/<au><auf>$regx{noTagAnystring}<\/auf>([\.\,\/\; ]+)<aus>$regx{noTagAnystring} $regx{and}<\/aus><\/au>/<au><auf>$1<\/auf>$2<aus>$3<\/aus><\/au> $4/gs;
	$$TextBody=~s/<au><aus>$regx{noTagAnystring}<\/aus>([\.\,\/\; ]+)<auf>$regx{noTagAnystring} $regx{and}<\/auf><\/au>/<au><aus>$1<\/aus>$2<auf>$3<\/auf><\/au> $4/gs;

	$$TextBody=~s/<auf>([A-Z\.\- ]+)([A-Z][a-z]+)<\/auf><aus>([a-z]+)<\/aus>/<auf>$1<\/auf> <aus>$2$3<\/aus>/gs;


	$$TextBody=~s/<au><aus>$regx{noTagAnystring}<\/aus> <auf>([A-Z\-]+) ([A-Z][a-z][^<>]+?) ([A-Z]+)<\/auf><\/au>/<au><aus>$1<\/aus> <auf>$2<\/auf><\/au> <au><aus>$3<\/aus> <auf>$4<\/auf><\/au>/gs;

	$$TextBody=~s/<auf>$regx{noTagAnystring} (Jr[\.]?|Sr[\.]?|2nd[\.]?|3rd[\.]?|4th[\.]?|Mac|du|de|da|II|III|von|van|dos|Van|De|Jac|Yu)<\/auf>/<auf>$1<\/auf> <suffix>$2<\/suffix>/gs;
	$$TextBody=~s/<aus>$regx{noTagAnystring} (Jr[\.]?|Sr[\.]?|2nd[\.]?|3rd[\.]?|4th[\.]?|Mac|du|de|da|II|III|von|van|dos|Van|De|Jac|Yu)<\/aus>/<aus>$1<\/aus> <suffix>$2<\/suffix>/gs;


#	$$TextBody=~s/<auf>(Jr[\.]?|Sr[\.]?|2nd[\.]?|3rd[\.]?|4th[\.]?|Mac|du|de|da|II|III|von|van|dos|Van|De|Jac|Yu) $regx{noTagAnystring}<\/auf>/<auf>$1<\/auf> <suffix>$2<\/suffix>/gs;
	$$TextBody=~s/<aus>(van der|van de|van den|du|de|da|von|van|dos)([\,]*) $regx{noTagAnystring}<\/aus>/<par>$1<\/par>$2 <aus>$3<\/aus>/gs;

	$$TextBody=~s/<au><aus>([A-Z\.\- ]+) $regx{noTagAnystring}<\/aus>, <auf>([A-Z\.\- ]+) $regx{noTagAnystring}<\/auf><\/au>/<au><auf>$1<\/auf> <aus>$2<\/aus><\/au>, <au><auf>$3<\/auf> <aus>$4<\/aus><\/au>/gs;

	$$TextBody=~s/ <auf>([A-Z\.\- ]+) $regx{noTagAnystring}<\/auf> <aus>$regx{noTagAnystring}<\/aus>/ <auf>$1<\/auf> <aus>$2 $3<\/aus>/gs;

	$$TextBody=~s/<suffix>(van der|van de|van den|du|de|da|von|van|dos)<\/suffix>/<par>$1<\/par>/gs;
	$$TextBody=~s/<aus>(van der|van de|van den|de|von|van|dos)([\,]*) $regx{noTagAnystring}<\/aus>/<par>$1<\/par> <aus>$2<\/aus>/gs;

	$$TextBody=~s/<auf>([A-Z\.\- ]+)<\/auf> <aus>([A-Z\.\- ]+) $regx{noTagAnystring}<\/aus>/<auf>$1 $2<\/auf> <aus>$3<\/aus>/gs;
	$$TextBody=~s/<aus>$regx{noTagOpString}<\/aus>\, <auf>([A-Z\- \.]+)\. ((?:(?!<auf>)(?!<\/auf>).)*)<\/auf> <at>((?:(?!<at>)(?!<\/at>).)*)<\/at>/<aus>$1<\/aus>\, <auf>$2<\/auf>\. <at>$3 $4<\/at>/gs;
	$$TextBody=~s/<aus>$regx{noTagOpString}<\/aus> <auf>([A-Z\- \.]+)\. ((?:(?!<auf>)(?!<\/auf>).)*)<\/auf> <at>((?:(?!<at>)(?!<\/at>).)*)<\/at>/<aus>$1<\/aus> <auf>$2<\/auf>\. <at>$3 $4<\/at>/gs;
	$$TextBody=~s/<aus>$regx{noTagOpString}<\/aus>\, <auf>([A-Z\- \.]+)\, ((?:(?!<auf>)(?!<\/auf>).)*)<\/auf> <at>((?:(?!<at>)(?!<\/at>).)*)<\/at>/<aus>$1<\/aus>\, <auf>$2<\/auf>\, <at>$3 $4<\/at>/gs;
	$$TextBody=~s/<aus>$regx{noTagOpString}<\/aus> <auf>([A-Z\- \.]+)\, ((?:(?!<auf>)(?!<\/auf>).)*)<\/auf> <at>((?:(?!<at>)(?!<\/at>).)*)<\/at>/<aus>$1<\/aus> <auf>$2<\/auf>\, <at>$3 $4<\/at>/gs;

	$$TextBody=~s/<aus>$regx{noTagOpString}<\/aus>\, <auf>([A-Za-z1234Ã¡àäćíÃ…â€™Ã¦Ã³Ã±Ã˜Ã¤Ã§Ã®Ã¨ÃŸÃ¼Ã¶Ã©Ã¥Ã¸`’\-Ã‡Ã–\-\' ]+)\. ((?:(?!<auf>)(?!<\/auf>).)*)<\/auf> <at>((?:(?!<at>)(?!<\/at>).)*)<\/at>/<aus>$1<\/aus>\, <auf>$2<\/auf>\. <at>$3 $4<\/at>/gs;
	$$TextBody=~s/<aus>$regx{noTagOpString}<\/aus> <auf>([A-Za-z1234Ã¡àäćíÃ…â€™Ã¦Ã³Ã±Ã˜Ã¤Ã§Ã®Ã¨ÃŸÃ¼Ã¶Ã©Ã¥Ã¸`’\-Ã‡Ã–\-\' ]+)\. ((?:(?!<auf>)(?!<\/auf>).)*)<\/auf> <at>((?:(?!<at>)(?!<\/at>).)*)<\/at>/<aus>$1<\/aus> <auf>$2<\/auf>\. <at>$3 $4<\/at>/gs;
	$$TextBody=~s/<aus>$regx{noTagOpString}<\/aus>\, <auf>([A-Za-z1234Ã¡àäćíÃ…â€™Ã¦Ã³Ã±Ã˜Ã¤Ã§Ã®Ã¨ÃŸÃ¼Ã¶Ã©Ã¥Ã¸`’\-Ã‡Ã–\-\' ]+)\, ((?:(?!<auf>)(?!<\/auf>).)*)<\/auf> <at>((?:(?!<at>)(?!<\/at>).)*)<\/at>/<aus>$1<\/aus>\, <auf>$2<\/auf>\, <at>$3 $4<\/at>/gs;
	$$TextBody=~s/<aus>$regx{noTagOpString}<\/aus> <auf>([A-Za-z1234Ã¡àäćíÃ…â€™Ã¦Ã³Ã±Ã˜Ã¤Ã§Ã®Ã¨ÃŸÃ¼Ã¶Ã©Ã¥Ã¸`’\-Ã‡Ã–\-\' ]+)\, ((?:(?!<auf>)(?!<\/auf>).)*)<\/auf> <at>((?:(?!<at>)(?!<\/at>).)*)<\/at>/<aus>$1<\/aus> <auf>$2<\/auf>\, <at>$3 $4<\/at>/gs;
	$$TextBody=~s/<edn>([0-9]+)([a-zA-Z \.]+)<\/edn>/<edn>$1<\/edn>$2/gs;



#	$$TextBody=~s/<aus><\/aus> <auf>([a-z]+)<\/auf>/<ia>$1 $2 $3 $4<\/ia>/gs;

	$$TextBody=~s/<aus>$regx{noTagAnystring} ([A-Z\. \-]+) et<\/aus> <auf>al<\/auf>/<aus>$1<\/aus> <auf>$2<\/auf> et al/gs;
	$$TextBody=~s/<aus>$regx{noTagAnystring} ([A-Za-z\. \-]+) et<\/aus> <auf>al<\/auf>/<aus>$1<\/aus> <auf>$2<\/auf> et al/gs;
	$$TextBody=~s/<auf>$regx{noTagAnystring} ([A-Za-z\. \-]+) et<\/auf> <aus>al<\/aus>/<auf>$1<\/auf> <aus>$2<\/aus> et al/gs;
	$$TextBody=~s/<aus>([A-Z\-\. ]+) (v\. d\.|u\. a\.|v\.\&nbsp\;d.|u\.\&nbsp\;a\.)<\/aus>/<aus>$1<\/aus> $2/gs;
	$$TextBody=~s/<auf>([A-Z\-\. ]+) (v\. d\.|u\. a\.|v\.\&nbsp\;d.|u\.\&nbsp\;a\.)<\/auf>/<auf>$1<\/auf> $2/gs;

	$$TextBody=~s/<auf>([A-Z\-\. ]+) ([A-Z][a-z]+) (v\. d\.|u\. a\.|v\.\&nbsp\;\.|u\.\&nbsp\;a\.)<\/auf>/<auf>$1<\/auf> <aus>$2<\/aus> $3/gs;


	$$TextBody=~s/<eds>([a-z\. ]+)<\/eds> \($regx{editorSuffix}\)/$1 \($2\)/gs;
	$$TextBody=~s/<eds>([a-z\. ]+)<\/eds> $regx{editorSuffix}/$1 $2/gs;

	$$TextBody=~s/<au><auf>([A-Z][^<>]*?)<\/auf> <aus>([A-Z\-\. ]+)<\/aus><\/au>/<au><aus>$1<\/aus> <auf>$2<\/auf><\/au>/gs;
	$$TextBody=~s/<au><aus>$regx{noTagOpString}<\/aus>, <auf>([A-Z\-\. ]+)\; ([A-Z][^<>]*?) ([A-Z\-\. ]+)<\/auf><\/au>/<au><aus>$1<\/aus>, <auf>$2<\/auf>\; <aus>$3<\/aus>, <auf>$4<\/auf><\/au>/gs;

	$$TextBody=~s/<\/(pbl|cny)>([\,\:\,\; ]+)<v>(\d{4})<\/v>([\:\;\, ]+)<pg>/<\/$1>$2<yr>$3<\/yr>$4<pg>/gs;

#-------------------------

	$$TextBody=~s/([0-9]+)<pg>([0-9]+)/<pg>$1$2/gs;
	$$TextBody=~s/<pg>([0-9a-zA-Z]+)--([0-9a-zA-Z]+)<\/pg>/<pg>$1–$2<\/pg>/gs;
	$$TextBody=~s/<pg>([0-9a-zA-Z]+)-([0-9a-zA-Z]+)<\/pg>/<pg>$1–$2<\/pg>/gs;
	$$TextBody=~s/([0-9]+)--([0-9]+)/$1–$2/gs;
	$$TextBody=~s/<iss>([0-9a-zA-Z]+)--([0-9a-zA-Z]+)<\/iss>/<iss>$1–$2<\/iss>/gs;
	$$TextBody=~s/<iss>([0-9a-zA-Z]+)-([0-9a-zA-Z]+)<\/iss>/<iss>$1–$2<\/iss>/gs;


	$$TextBody=~s/([\.\,\?]?) ([A-Z]) <pt>/$1 <pt>$2 /gs;   #. J <pt> =>. <pt>J
	$$TextBody=~s/<pt>$regx{noTagAnystring} \(([A-Za-z\.\- ]+)<\/pt><cny>([A-Za-z\-\,\.]+)<\/cny>\)/<pt>$1<\/pt> \(<cny>$2$3<\/cny>\)/gs;

	$$TextBody=~s/<at>$regx{noTagAnystring}\, ([A-Z][a-z]+\.[\s]?[A-Z][a-z]+)<\/at>\. <pt>([A-Z][a-z]*?)<\/pt>/<at>$1<\/at>\, <pt>$2\. $3<\/pt>/gs;
	$$TextBody=~s/<at>$regx{noTagAnystring}\, ([A-Z][a-z]+\.[\s]?[A-Z][a-z]+\.[\s]?[A-Z][a-z]+)<\/at>\. <pt>([A-Z][a-z]*?)<\/pt>/<at>$1<\/at>\, <pt>$2\. $3<\/pt>/gs;

	$$TextBody=~s/<pbl>New<\/pbl> <cny>York<\/cny>/<cny>New York<\/cny>/gs;
	$$TextBody=~s/(R|S)<pg>([0-9\-]+)(R|S)([0-9]+)<\/pg>/<pg>$1$2$3$4<\/pg>/gs;
	$$TextBody=~s/<pbl>([psS])<\/pbl>/$1/gs;

	$$TextBody=~s/<v>([0-9]+[A-Z]?)<\/v>([\,\.])<pg>([0-9]+)<\/pg>\.(htm[l]?|xml)/$1$2$3\.$4/gs;
	$$TextBody=~s/ ([0-9]+)\.<v>([0-9]+)<\/v>\.<pg>(\d{4})<\/pg><\/bib>/ $1\.$2\.$3<\/bib>/gs;

	$$TextBody=~s/<iss>([Ss]upplement|[Ss]uppl|[Pp]t)([\. ]?)([0-9]+)<\/iss>/$1$2 <iss>$3<\/iss>/gs;
	$$TextBody=~s/\(<iss>([Ss]uppl[\.]?) ([0-9]+)<\/iss>\)/\($1 <iss>$2<\/iss>\)/gs;
	$$TextBody=~s/<pg>S([A-Z])([0-9\-]+)/S<pg>$1$2/gs;
	$$TextBody=~s/<aus>(Jr[\.]?|Sr[\.]?|2nd[\.]?|3rd[\.]?|4th[\.]?|Mac|du|de|da|II|III|von|van|dos|Van|De|Jac|Yu)<\/aus> <auf>$regx{noTagOpString}<\/auf> <suffix>([A-Z]+)<\/suffix>/<par>$1<\/par> <aus>$2<\/aus> <auf>$3<\/auf>/gs;

	$$TextBody=~s/<aus>(Jr[\.]?|Sr[\.]?|2nd[\.]?|3rd[\.]?|4th[\.]?|Mac|du|de|da|II|III|von|van|dos|Van|De|Jac|Yu)<\/aus> <auf>$regx{noTagOpString}<\/auf> <prefix>([A-Z]+)<\/prefix>/<par>$1<\/par> <aus>$2<\/aus> <auf>$3<\/auf>/gs;

	$$TextBody=~s/<\/eds>([\,]? )<edm>$regx{firstName}\. $regx{suffix}<\/edm>/<\/eds>$1<edm>$2\.<\/edm> <suffix>$3<\/suffix>/gs;
	$$TextBody=~s/<eds>$regx{mAuthorFullSirName} $regx{particle}<\/eds>/<eds>$1<\/eds> <par>$2<\/par>/gs;
	$$TextBody=~s/<eds>$regx{particle} $regx{mAuthorFullSirName}<\/eds>/<par>$1<\/par> <eds>$2<\/eds>/gs;
	$$TextBody=~s/<\/aus>([\,]? )<auf>$regx{firstName}\. $regx{suffix}<\/auf>/<\/aus>$1<auf>$2\.<\/auf> <suffix>$3<\/suffix>/gs;
	$$TextBody=~s/<aus>$regx{mAuthorFullSirName} $regx{particle}<\/aus>/<aus>$1<\/aus> <par>$2<\/par>/gs;
	$$TextBody=~s/<aus>$regx{particle} $regx{mAuthorFullSirName}<\/aus>/<par>$1<\/par> <aus>$2<\/aus>/gs;
	$$TextBody=~s/<edr><edm>$regx{sAuthorString}<\/edm> <eds>$regx{and} $regx{sAuthorString}<\/eds><\/edr>/<edr><eds>$1<\/eds><\/edr> $2 <edr><eds>$3<\/eds><\/edr>/gs;
#	print $$TextBody;exit;

	$$TextBody=~s/<au><aus>$regx{noTagOpString}<\/aus> <auf>([A-Z][a-z]+) ([A-Z\.\- ]+)<\/auf><\/au>/<au><aus>$1 $2<\/aus> <auf>$3<\/auf><\/au>/gs;
	$$TextBody=~s/<yr>([0-9A-Z]+)<\/yr>\: <v>([0-9A-Z]+)<\/v>\-<pg>([0-9A-Z]+)<\/pg>\.<\/bib>/<v>$1<\/v>: <pg>$2\-$3<\/pg>\.<\/bib>/gs;
	$$TextBody=~s/<\/aus>\, <auf>$regx{noTagOpString} ([Jj]r[\.]?|[Ss]r[\.]?|2nd[\.]?|3rd[\.]?|4th[\.]?|Mac|du|da|II|III|von|[vV]an|dos|[Dd]e|Jac|Yu)<\/auf>/<\/aus>\, <auf>$1<\/auf> <suffix>$2<\/suffix>/gs;

	$$TextBody=~s/\(<cny>([0-9])\.\, erw\. (ed|ed\.|edn|edn\.|Aufl|Aufl\.|Bd|Bd\.|Auflage)\) ((?:(?!<cny>)(?!<\/cny>).)*)<\/cny>/\($1\.\, erw\. $2\) <cny>$3<\/cny>/gs;
	$$TextBody=~s/<\/yr>([\)\:\. ]*?)<bt>$regx{noTagOpString}\. In: ([^<>\.\,\:]*?) ([A-Z\-]+)\, ([^<>\.\,\:]*?) ([A-Z\-]+)\, ([^<>\.\,\:]*?) ([A-Z\-]+)\. ([A-Z]+[^<>]*?)<\/bt>/<\/yr>$1<misc1>$2<\/misc1>\. <edrg>In: <edr><eds>$3<\/eds> <edm>$4<\/edm><\/edr>\, <edr><eds>$5<\/eds> <edm>$6<\/edm><\/edr>\, <edr><eds>$7<\/eds> <edm>$8<\/edm><\/edr><\/edrg>\. <bt>$9<\/bt>/gs;
	$$TextBody=~s/<\/yr>([\)\:\. ]*?)<bt>$regx{noTagOpString}\. In: ([^<>\.\,\:]*?) ([A-Z\-]+)\, ([^<>\.\,\:]*?) ([A-Z\-]+)\. ([A-Z]+[^<>]*?)<\/bt>/<\/yr>$1<misc1>$2<\/misc1>\. <edrg>In: <edr><eds>$3<\/eds> <edm>$4<\/edm><\/edr>\, <edr><eds>$5<\/eds> <edm>$6<\/edm><\/edr><\/edrg>\. <bt>$7<\/bt>/gs;
	$$TextBody=~s/<\/yr>([\)\:\. ]*?)<bt>$regx{noTagOpString}\. In: ([^<>\.\,\:]*?) ([A-Z\-]+)\. ([A-Z]+[^<>]*?)<\/bt>/<\/yr>$1<misc1>$2<\/misc1>\. <edrg>In: <edr><eds>$3<\/eds> <edm>$4<\/edm><\/edr><\/edrg>\. <bt>$5<\/bt>/gs;

	$$TextBody=~s/<ia>ISO<\/ia> <yr>(\d+)<\/yr> \((\d{4})\)/<ia>ISO $1<\/ia> \(<yr>$2<\/yr>\)/gs;
	$$TextBody=~s/<cny>$regx{noTagOpString}<\/cny>\, ([A-Z][a-z]+) (S\.|pp\.) ([0-9\-]+)$regx{optionalFullstop}<\/bib>/<cny>$1\, $2<\/cny> $3 <pg>$4<\/pg>$5<\/bib>/gs;
	$$TextBody=~s/([\.\,\:\; ]+)Journal of((?:(?!<[\/]?at>)(?!<[\/]?pt>).)*)<\/at>([\:\.\, ]+)<pt>/<\/at>$1<pt>Journal of$2$3/gs;
	#Journal of 
	$$TextBody=~s/([\.\,\:\; ]+)([A-Z][a-z\.]+) Journal of((?:(?!<[\/]?at>)(?!<[\/]?pt>).)*)<\/at>([\:\.\, ]+)<pt>/<\/at>$1<pt>$2Journal of$3$4/gs;

	$$TextBody=~s/<\/(pbl|cny)>\, (\d+)\.<\/bib>/<\/$1>\, <pg>$2<\/pg>\.<\/bib>/gs;
	$$TextBody=~s/<[\/]?month>//gs;
	$$TextBody=~s/<[\/]?unmark>//gs;
	$$TextBody=~s/<[\/]?etal>//gs;
	$$TextBody=~s/<yr>(\d{4}) ([\w ]+)<\/yr>/<yr>$1<\/yr> $2/gs;
	$$TextBody=~s/<cny>((?:(?!<cny>)(?!<\/cny>).)*) http<\/cny>:<pbl>\/\//<cny>$1<\/cny> <pbl>http:\/\//gs;
	$$TextBody=~s/<edn>5<\/edn>\. <pbl>Aufl\, /<edn>5<\/edn>\. Aufl\, <pbl>/gs;
	$$TextBody=~s/<edn>5<\/edn>\. <cny>Aufl\, /<edn>5<\/edn>\. Aufl\, <cny>/gs;
	$$TextBody=~s/<aug>([A-Za-z\-]+)<\/aug>/<au><aus>$1<\/aus><\/au>/gs;

	$$TextBody=~s/: <\/bt><cny>/<\/bt>: <cny>/gs;

	$$TextBody=~s/\,<\/at>\'\'/<\/at>\,\'\'/gs;
	$$TextBody=~s/<at><at>((?:(?!<at>)(?!<\/at>).)*?)<\/at><\/at>/<at>$1<\/at>/gs;

	$$TextBody=~s/<\/([a-z]+)>\? /\?<\/$1> /gs;
	$$TextBody=~s/\;(\s*)<au><aus>$regx{noTagOpString}<\/aus>([ \,\;]+)<auf>$regx{noTagOpString}<\/auf><\/au>\,\;<au>/\;$1<au><aus>$2<\/aus>$3<auf>$4<\/auf><\/au>\;<au>/gs;

	$$TextBody=~s/<edrg>([a-zA-Z\.\:]+?) <edr>([^<>]+?)<\/edr> ([a-zA-Z\.\(\)\[\]]+?)<\/edrg>/$1 $2 $3/gs;

	$$TextBody=~s/<auf>$regx{firstName}<\/auf><\/au>\, $regx{mAuthorFullSirName} $regx{firstName}\. ([^<>\.\,\(\)][^<>]+?)<\/aug>\. <edrg>((?:(?!<[\/]?edrg>)(?!<[\/]?yr>)(?!<bib)(?!<\/bib>).)*)<\/edrg>([^<>]+?)<bt>/<auf>$1<\/auf><\/au>\, <au><aus>$2<\/aus> <auf>$3<\/auf><\/au><\/aug>\. <misc1>$4<\/misc1>\. <edrg>$5<\/edrg>$6<bt>/gs;
	#print $$TextBody;exit;


	$$TextBody=~s/\. <ia>In $regx{sAuthorString} $regx{sAuthorString}\, $regx{editorSuffix}<\/ia> <bt>$regx{sAuthorString} $regx{sAuthorString}<\/bt>\, <pg>$regx{noTagOpString}<\/pg>\. <cny>/\. In <bt>$1 $2<\/bt>\, $3 <edrg><edr><edm>$4<\/edm> <eds>$5<\/eds><\/edr><\/edrg>\, <pg>$6<\/pg>\. <cny>/gs;
	$$TextBody=~s/\. <ia>In $regx{sAuthorString} $regx{sAuthorString}\, $regx{editorSuffix}<\/ia> <bt>$regx{sAuthorString} $regx{sAuthorString}<\/bt>\. <cny>/\. In <bt>$1 $2<\/bt>\, $3 <edrg><edr><edm>$4<\/edm> <eds>$5<\/eds><\/edr><\/edrg>\. <cny>/gs;
	$$TextBody=~s/<bib([^<>]*?)><aug>((?:(?!<[\/]?aug>)(?!<[\/]?yr>)(?!<bib)(?!<\/bib>).)*)<\/aug>([\.\, ]+)<bt>\($regx{year}\/$regx{year}\)([\.]?) ([^<>]+?)<\/bt>((?:(?!<[\/]?yr>)(?!<bib)(?!<\/bib>).)*)<\/bib>/<bib$1><aug>$2<\/aug>$3\(<yr>$4\/$5<\/yr>\)$6 <bt>$7<\/bt>$8<\/bib>/gs;
	$$TextBody=~s/<ia>([^<>]+? [0-9]+)<\/ia>\.([0-9]+) \($regx{year}\)/<ia>$1\.$2<\/ia> \(<yr>$3<\/yr>\)/gs;
	$$TextBody=~s/<ia>([^<>]+?) \($regx{year}\)<\/ia>([\.\, ]+)<(url|urlg)>/<ia>$1<\/ia> \(<yr>$2<\/yr>\)$3<$4>/gs;
	$$TextBody=~s/<bib([^<>]*?)>((?:(?!<[\/]?yr>)(?!<bib)(?!<\/bib>).)*)\(<yr>$regx{year}<\/yr>\)((?:(?!<[\/]?yr>)(?!<bib)(?!<\/bib>).)*) $regx{accessed} ([^<>]+?)<yr>$regx{year}<\/yr>([\.]?)<\/bib>/<bib$1>$2\(<yr>$3<\/yr>\)$4 $5 $6$7$8<\/bib>/gs;
	$$TextBody=~s/<bib([^<>]*?)>((?:(?!<[\/]?yr>)(?!<bib)(?!<\/bib>).)*)\($regx{year}\)((?:(?!<[\/]?yr>)(?!<bib)(?!<\/bib>).)*) $regx{accessed} ([^<>]+?)<yr>$regx{year}<\/yr>([\.]?)<\/bib>/<bib$1>$2\(<yr>$3<\/yr>\)$4 $5 $6$7$8<\/bib>/gs;

	$$TextBody=~s/<(misc1|bt)>([\"])<\1>([^<>]+?)<\/\1>([\,\.\?\"]+)<\/\1>/$2<$1>$3<\/$1>$4/gs;

	#$bibText=&removeAllTags($bibText);
	$$TextBody=~s/<bib([^<>]*?)>([\s]*)\&lt\;number\&gt\;([\[\]\(\)a-zA-Z0-9\.]+)\&lt\;\/number\&gt\;([\s]*)/<bib$1 number=\"$3\">/gs;

	while($$TextBody=~/<bib([^<>]*?)><ia>((?:(?!<bib[^<>]*?>)(?!<[\/]?bib>)(?!<[\/]?ia>).)+?)<\/ia>((?:(?!<bib[^<>]*?>)(?!<[\/]?bib>).)+?)<\/bib>/s){
	  my $bibText="<ia>$2<\/ia>$3";
	  # print $bibText;
	   $bibText=&removeAllTags($bibText) if($bibText=~/<ia>$regx{sAuthorString}([\,]?) $regx{firstName}([\,\;]) ([^<>]+?) $regx{sAuthorString}([\,]?) $regx{firstName}<\/ia>/);
	   $bibText=&removeAllTags($bibText) if($bibText=~/<ia>$regx{sAuthorString}([\,]?) $regx{firstName}([\,\;]) ([^<>]+?) $regx{sAuthorString}([\,]?) $regx{firstName}([\,]?) $regx{particleSuffix}<\/ia>/);
	   $bibText=&removeAllTags($bibText) if($bibText=~/<ia>$regx{sAuthorString}([\,]?) $regx{firstName}([\,]?) $regx{particleSuffix}([\,\;]) ([^<>]+?) $regx{sAuthorString}([\,]?) $regx{firstName}<\/ia>/);

	   $bibText=&removeAllTags($bibText) if($bibText=~/<ia>$regx{particleSuffix} $regx{sAuthorString}([\,]?) $regx{firstName}([\,\;]) ([^<>]+?) $regx{sAuthorString}([\,]?) $regx{firstName}<\/ia>/);
	   $bibText=&removeAllTags($bibText) if($bibText=~/<ia>$regx{sAuthorString}([\,]?) $regx{firstName}([\,\;]) ([^<>]+?) $regx{particleSuffix} $regx{sAuthorString}([\,]?) $regx{firstName}<\/ia>/);

	   $bibText=&removeAllTags($bibText) if($bibText=~/<ia>$regx{sAuthorString}([\,]?) $regx{firstName}([\,\;]) ([^<>]+?) $regx{sAuthorString}([\,]?) $regx{particleSuffix}([\,]?) $regx{firstName}<\/ia>/);
	   $bibText=&removeAllTags($bibText) if($bibText=~/<ia>$regx{sAuthorString}([\,]?) $regx{particleSuffix} [\,]? $regx{firstName}([\,\;]) ([^<>]+?) $regx{sAuthorString}([\,]?) $regx{firstName}<\/ia>/);

	   $bibText=&removeAllTags($bibText) if($bibText=~/<ia>$regx{sAuthorString}([\,]?) $regx{firstName}([\,\;]) ([^<>]+?) $regx{firstName} $regx{sAuthorString}<\/ia>/);

	   $bibText=&removeAllTags($bibText) if($bibText=~/<ia>$regx{firstName}([\,]?) $regx{sAuthorString}([\,\;]) ([^<>]+?) $regx{firstName}([\,]?) $regx{sAuthorString}<\/ia>/);

	   $$TextBody=~s/<bib([^<>]*?)><ia>((?:(?!<bib[^<>]*?>)(?!<[\/]?bib>)(?!<[\/]?ia>).)+?)<\/ia>((?:(?!<bib[^<>]*?>)(?!<[\/]?bib>).)+?)<\/bib>/<Xbib$1>$bibText<\/Xbib>/s;
	}
	$$TextBody=~s/<([\/]?)Xbib([^<>]*?)>/<$1bib$2>/gs;
	$$TextBody=~s/<bib([^<>]*?) number=\"([\[\]\(\)a-zA-Z0-9\.]+)\">/<bib$1>\&lt\;number\&gt\;$2\&lt\;\/number\&gt\;/gs;


	if($application eq "Bookmetrix")
	  {
	    $TextBody=BookMetrixMarking($TextBody);
	  }

	$$TextBody=~s/<\/(misc1|bt)>([\.\,\; ]+)<ia>([Ii]n[\:\.\, ]+)([^<>\.]+?)([\.\,]? )\($regx{editorSuffix}([\.]?)\)<\/ia>/<\/$1>$2$3<ia>$4<\/ia>$5\($6$7\)/gs;
	$$TextBody=~s/\, ([iI]n [pP]ress)<\/pt>/<\/pt>\, $1/gs;
	$$TextBody=~s/<(at|pt|bt|pt|miscq)>$regx{pagePrefix}<\/\1>/$2/gs;
	$$TextBody=~s/<(at|pt|bt|pt|miscq)>$regx{volumePrefix}<\/\1>/$2/gs;
	$$TextBody=~s/<(at|pt|bt|pt|miscq)>$regx{issuePrefix}<\/\1>/$2/gs;
	return 	$$TextBody;
    }


#=====================================================================================================================================


sub TagInsideTagClenup{
  my $TextBody=shift;

  while($$TextBody=~/<yr>(\d{4}[a-z]?)<\/yr>((?:(?!<bib[^<>]*?>)(?!<\/bib>)(?!<aug>).)*)<\/pt>([\.\,]) <yr>(\d{4}[a-z]?)<\/yr>([\,]*?)<v>/)
    {
      my $year=$1;
      my $SecondYear=$4;
      if($year ne $SecondYear)
	{
	  $$TextBody=~s/<yr>(\d{4}[a-z]?)<\/yr>((?:(?!<bib[^<>]*?>)(?!<\/bib>)(?!<aug>).)*)<\/pt>([\.\,]) <yr>(\d{4}[a-z]?)<\/yr>([\,]*?)<v>/<yr>$1<\/yr>$2$3 $4<\/pt>$5<v>/os;
	}else
	  {
	    $$TextBody=~s/<yr>(\d{4}[a-z]?)<\/yr>((?:(?!<bib[^<>]*?>)(?!<\/bib>)(?!<aug>).)*)<\/pt>([\.\,]) <yr>(\d{4}[a-z]?)<\/yr>([\,]*?)<v>/<yr>$1<\/yr>$2<\/pt>$3 <Xyr>$4<\/Xyr>$5<v>/os;
	  }
    }
  $$TextBody=~s/<([\/]?)Xyr>/<$1yr>/gs;

  $$TextBody=~s/<\/(aug|ia|edrg)>([\.\,\;\( ]*)<yr>(\d{4}[a-z]?)<\/yr>((?:(?!<bib[^<>]*?>)(?!<\/bib>)(?!<aug>).)*)<yr>(\d{4}[a-z]?)<\/yr>/<\/$1>$2<yr>$3<\/yr>$4$5/gs;

  while($$TextBody=~/<at>((?:(?!<at>)(?!<\/at>).)*)<\/at>/s)
    {
      my $TagText=$1;
      $TagText=~s/(<pbl>|<cny>)//gs;
      $TagText=~s/(<edrg>|<bt>)//gs;
      $TagText=~s/(<\/edrg>|<\/bt>)//gs;
      $TagText=~s/(<\/pbl>|<\/cny>)//gs;
      $$TextBody=~s/<at>((?:(?!<at>)(?!<\/at>).)*)<\/at>/<Xat>$TagText<\/Xat>/os;
    }
  $$TextBody=~s/<Xat>/<at>/gs;
  $$TextBody=~s/<\/Xat>/<\/at>/gs;

  while($$TextBody=~/<pt>((?:(?!<pt>)(?!<\/pt>).)*)<\/pt>/s)
    {
      my $TagText=$1;
      $TagText=~s/(<pbl>|<cny>)//gs;
      $TagText=~s/(<\/pbl>|<\/cny>)//gs;
      $$TextBody=~s/<pt>((?:(?!<pt>)(?!<\/pt>).)*)<\/pt>/<Xpt>$TagText<\/Xpt>/os;
    }
  $$TextBody=~s/<Xpt>/<pt>/gs;
  $$TextBody=~s/<\/Xpt>/<\/pt>/gs;
  

  while($$TextBody=~/<bt>((?:(?!<bt>)(?!<\/bt>).)*)<\/bt>/s)
    {
      my $TagText=$1;
      $TagText=~s/(<pt>|<at>)//gs;
      $TagText=~s/(<\/pt>|<\/at>)//gs;
      $$TextBody=~s/<bt>((?:(?!<bt>)(?!<\/bt>).)*)<\/bt>/<Xbt>$TagText<\/Xbt>/os;
    }
  $$TextBody=~s/<Xbt>/<bt>/gs;
  $$TextBody=~s/<\/Xbt>/<\/bt>/gs;

#<pbl>W.H. <pbl>Freeman</pbl> and Company</pbl>
  while($$TextBody=~/<pbl>((?:(?!<pbl>)(?!<\/pbl>).)*)<\/pbl>/s)
    {
      my $TagText=$1;
      $TagText=~s/(<pbl>|<cny>)//gs;
      $TagText=~s/(<\/pbl>|<\/cny>)//gs;
      $$TextBody=~s/<pbl>((?:(?!<pbl>)(?!<\/pbl>).)*)<\/pbl>/<Xpbl>$TagText<\/Xpbl>/os;
    }
  $$TextBody=~s/<Xpbl>/<pbl>/gs;
  $$TextBody=~s/<\/Xpbl>/<\/pbl>/gs;
  $$TextBody=~s/<pbl>$regx{noTagOpString}<pbl>((?:(?!<pbl>)(?!<\/pbl>).)*)<\/pbl>$regx{noTagOpString}<\/pbl>/<pbl>$1$2$3<\/pbl>/gs;

  while($$TextBody=~/<misc1>((?:(?!<misc1>)(?!<\/misc1>).)*)<\/misc1>/s)
    {
      my $TagText=$1;
      $TagText=~s/(<at>|<pt>)//gs;
      $TagText=~s/(<\/at>|<\/pt>)//gs;
      $TagText=~s/(<pbl>|<cny>)//gs;
      $TagText=~s/(<edrg>|<bt>)//gs;
      $TagText=~s/(<\/edrg>|<\/bt>)//gs;
      $TagText=~s/(<\/pbl>|<\/cny>)//gs;
      $$TextBody=~s/<misc1>((?:(?!<misc1>)(?!<\/misc1>).)*)<\/misc1>/<Xmisc1>$TagText<\/Xmisc1>/os;
    }
  $$TextBody=~s/<Xmisc1>/<misc1>/gs;
  $$TextBody=~s/<\/Xmisc1>/<\/misc1>/gs;

  #------------------------------------------------------------------------
  $$TextBody=~s/ ([A-Z\-\. ]+\.[\s]?[A-Z])<\/aug>\./ $1\.<\/aug>/g;
  $$TextBody=~s/([\,\.]) \`\`$regx{noTagOpString}<\/aug>/<\/aug>$1 \`\`$2/g;
  $$TextBody=~s/ $regx{and} ([A-Z\. ]+)<\/aug>\. <at>([^<>\`\`]+)([\.\,]) \`\`/ $1 $2\. $3<\/aug>$4 \`\`<at>/g;
  $$TextBody=~s/ $regx{and} ([A-Z\. ]+)<\/aug> ([^<>\`\`]+)\, \\textit\{/ $1 $2 $3<\/aug>\, \\textit\{/g;
  $$TextBody=~s/ $regx{and} ([A-Z\. ]+)<\/aug> ([^<>\`\`]+)\, <i>/ $1 $2 $3<\/aug>\, <i>/g;
  #------------------------------------------------------------------------

  return $$TextBody;
}

#=====================================================================================================================================
sub AtAndEdrgMarking{
  my $TextBody=shift;

  use ReferenceManager::ReferenceRegex;
  my %regx = ReferenceManager::ReferenceRegex::new();

  $$TextBody=~s/<\/(aug|edrg|ia)>([\.\,\(\: ]+)<yr>$regx{noTagOpString}<\/yr>([\.\,\) ]+)((?:(?!<aug>)(?!<edrg>)(?!<pt>)(?!<[\/]?at>)(?!<[\/]?comment>)(?!<[\/]?v>)(?!<[\/]?yr>)(?!<[\/]?month>)(?!<[\/]?bib[^<>]*?>).)*)<pt>(<i>[^<>]+<\/i>|[^<>]+)<\/pt>([\.\, ]+)<yr>$regx{noTagOpString}<\/yr>([\,\: ]+)<pg>/<\/$1>$2<yr>$3<\/yr>$4$5<pt>$6<\/pt>$7<v>$8<\/v>$9<pg>/gs;

  $$TextBody=~s/([a-zA-Z0-9]+[\:\.\,]?) <yr>([0-9]+)<\/yr>$regx{noTagOpString}<pt>/$1 $2$3<pt>/gs;
  $$TextBody=~s/<\/(aug|yr)>([:\;\,\.\)]+)\s*\\newblock\s*<ct>/<\/$1>$2 <ct>/gs;
  $$TextBody=~s/ ([A-Z\-\. ]+\.[\s]?[A-Z])<\/aug>\./ $1\.<\/aug>/gs;
  $$TextBody=~s/<pt>([\s]*)<\/pt>/$1/gs;
  $$TextBody=~s/  / /gs;
  $$TextBody=~s/<ct>((?:(?!<aug>)(?!<edrg>)(?!<pt>)(?!<[\/]?at>)(?!<[\/]?comment>)(?!<[\/]?v>)(?!<[\/]?yr>)(?!<[\/]?month>)(?!<bib[^<>]*?>).)*)<\/ct>([\.\,\;\?Iin: ]+)<pt>/<at>$1<\/at>$2<pt>/gs; #for bib tex modules

  $$TextBody=~s/<\/yr>([\:\;\.\,\) ]+“)((?:(?!<collab)(?!<aug>)(?!<edrg>)(?!<[\/]?comment>)(?!<[\/]?v>)(?!<pt>)(?!<[\/]?at>)(?!<[\/]?yr>)(?!<[\/]?bib[^<>]*?>).)*)(”[ ]?)<pt>/<\/yr>$1<at>$2<\/at>$3<pt>/gs;

  $$TextBody=~s/<\/yr>([\:\;\.\,\) ]+|\\newblock)((?:(?!<collab)(?!<aug>)(?!<edrg>)(?!<[\/]?comment>)(?!<[\/]?v>)(?!<pt>)(?!<[\/]?at>)(?!<[\/]?yr>)(?!<[\/]?bib[^<>]*?>).)*?)([\.\,\? ]+|[\.\,\? ]+[Ii]n[\:\. ]+)<pt>/<\/yr>$1<at>$2<\/at>$3<pt>/gs;
  $$TextBody=~s/<\/aug>([\:\;\.\,\) ]+|\\newblock)((?:(?!<collab)(?!<[\/]?aug>)(?!<[\/]?edrg>)(?!<[\/]?comment>)(?!<[\/]?v>)(?!<[\/]?pt>)(?!<[\/]?at>)(?!<[\/]?yr>)(?!<bib[^<>]*?>).)*?)([\.\,\? ]+)([Ii]n[\:\. ]+)<pt>/<\/aug>$1<at>$2<\/at>$3$4<pt>/gs;
  $$TextBody=~s/<\/aug>([\:\;\.\,\) ]+|\\newblock)((?:(?!<collab)(?!<aug>)(?!<edrg>)(?!<[\/]?comment>)(?!<[\/]?v>)(?!<pt>)(?!<[\/]?at>)(?!<\/yr>)(?!<bib[^<>]*?>).)*?)([\.\,\? ]+|[\.\,\? ]+[Ii]n[\:\. ]+)<pt>/<\/aug>$1<at>$2<\/at>$3<pt>/gs;
  $$TextBody=~s/<\/aug>([\:\;\.\,\)]? |\\newblock )((?:(?!<collab)(?!<[\/]?aug>)(?!<[\/]?edrg>)(?!<[\/]?comment>)(?!<[\/]?v>)(?!<[\/]?pt>)(?!<[\/]?at>)(?!<[\/]?yr>)(?!<bib[^<>]*?>).)+?)([\.\,\? ]+[(]?)<yr>([^<>]+?)<\/yr>([)]?)<at><\/at> <pt>/<\/aug>$1<at>$2<\/at>$3<yr>$4<\/yr>$5 <pt>/gs;
  
	$$TextBody =~ s/<([\/]?(sup|sub))>/\&lt\;$1\&gt\;/gs;
#</yr>). “The Changing Structure of Mass Belief Systems: Fact or Artifact?”<pt>
	$$TextBody=~s/ ([^ <>\/]+?)(<[^<>\/]+?>)/ $2$1/g;
  $$TextBody=~s/<at>(„(?:(?!<[\/]?at>).)*)([\.\,\;\?]?)“([\.\,\;\? ]+)([iI]n[\:\.]?)<\/at>([\.\,\?\; ])<pt>/<at>$1“<\/at>$2$3$4$5<pt>/gs;
  $$TextBody=~s/<at>(„(?:(?!<[\/]?at>).)*)([\.\,\;\?]?)\&quot\;([\.\,\;\? ]+)([iI]n[\:\.]?)<\/at>([\.\,\?\; ])<pt>/<at>$1&quot;<\/at>$2$3$4$5<pt>/gs;
  $$TextBody=~s/<at>(\&quot\;(?:(?!<[\/]?at>).)*?)([\.\,\;\?]?)\&quot\;([\.\,\;\? ]+)([iI]n[\:\.]?)<\/at>([\.\,\?\; ])<pt>/<at>$1&quot;<\/at>$2$3$4$5<pt>/gs;
  $$TextBody=~s/<at>((?:(?!<[\/]?at>).)*?)([\.\,\;\? ]+)([iI]n[\:\.]?)<\/at>/<at>$1<\/at>$2$3/gs;
#Commented By Biswajit
#$$TextBody=~s/<at>„((?:(?!<[\/]?at>).)*)([\.\,\;\?]?)“([\.\,\;\? ]+)([iI]n[\:\.]?)<\/at>([\.\,\?\; ])<pt>/„<at>$1<\/at>$2“$3$4$5<pt>/gs;
#$$TextBody=~s/<at>„((?:(?!<[\/]?at>).)*)([\.\,\;\?]?)\&quot\;([\.\,\;\? ]+)([iI]n[\:\.]?)<\/at>([\.\,\?\; ])<pt>/„<at>$1<\/at>$2&quot;$3$4$5<pt>/gs;
#$$TextBody=~s/<at>\&quot\;((?:(?!<[\/]?at>).)*?)([\.\,\;\?]?)\&quot\;([\.\,\;\? ]+)([iI]n[\:\.]?)<\/at>([\.\,\?\; ])<pt>/\&quot\;<at>$1<\/at>$2&quot;$3$4$5<pt>/gs;
#$$TextBody=~s/<at>((?:(?!<[\/]?at>).)*?)([\.\,\;\? ]+)([iI]n[\:\.]?)<\/at>/<at>$1<\/at>$2$3/gs;
#
  #<at>"Y Chromosomal DNA variation and the peopling of Japan,"</at> 
  #change By Biswajit
 # $$TextBody=~s/<at>�((?:(?!<[\/]?at>).)*?)�<\/at>/�<at>$1<\/at>�/gs;
 # $$TextBody=~s/<at>\"((?:(?!<[\/]?at>).)*?)\"<\/at>/\"<at>$1<\/at>\"/gs;
 # $$TextBody=~s/<at>\`\`((?:(?!\'\')(?!\`\`)(?!<[\/]?at>).)*?)\'\'<\/at>/\`\`<at>$1<\/at>\'\'/gs;
 # $$TextBody=~s/<at>\&quot\;((?:(?!<[\/]?at>).)*?)\&quot\;<\/at>/\&quot\;<at>$1<\/at>\&quot\;/gs;


	$$TextBody =~ s/\&lt\;([\/]?(sup|sub))\&gt\;/<$1>/sg;
	
  $$TextBody=~s/<bib$regx{noTagAnystring}><aug>((?:(?!<[\/]?aug>)(?!<[\/]?bib>).)*)<pbl>(.*?)<\/pbl>((?:(?!<[\/]?aug>)(?!<[\/]?bib>).)*)<\/aug>(.*?)<\/bib>/<bib$1><aug>$2$3$4<\/aug>$5<\/bib>/g;
  $$TextBody=~s/<aug>$regx{noTagOpString}([\,\;\: ]*)\($regx{editorSuffix}\)$regx{optionalFullstop}<\/aug>/<edrg>$1<\/edrg>$2\($3\)$4/gs;
  $$TextBody=~s/<aug>$regx{noTagOpString}([\,\;\: ]*)<i>$regx{editorSuffix}<\/i>$regx{optionalFullstop}<\/aug>/<edrg>$1<\/edrg>$2<i>$3<\/i>$4/gs;
  $$TextBody=~s/<aug>$regx{noTagOpString}([\,\;\: ]+)$regx{editorSuffix}$regx{optionalFullstop}<\/aug>/<edrg>$1<\/edrg>$2$3$4/gs;
  $$TextBody=~s/<aug>$regx{noTagOpString}<\/aug>([\,\;\: ]*)\($regx{editorSuffix}\)$regx{optionalFullstop}/<edrg>$1<\/edrg>$2\($3\)$4/gs;
  $$TextBody=~s/<aug>$regx{noTagOpString}<\/aug>([\,\;\: ]+)$regx{editorSuffix}$regx{optionalFullstop}/<edrg>$1<\/edrg>$2$3$4/gs;

  $$TextBody=~s/<at>((?:(?!<[\/]?at>)(?!<[\/]?bib>).)*?) (\[([^<>\[\]]+?)\][.]?)<\/at>/<at>$1<\/at> $2/gs;
  $$TextBody=~s/<at><url>((?:(?!<[\/]?url>)(?!<[\/]?at>)(?!<[\/]?bib>).)*?)<\/url>([\.\,\;\: ]*?)<\/at>/<url>$1<\/url>$2/gs;
  $$TextBody=~s/<url>\&lt\;((?:(?!<[\/]?url>)(?!<[\/]?at>)(?!<[\/]?bib>).)*?)\&gt\;<\/url>/\&lt\;<url>$1<\/url>\&gt\;/gs;
  $$TextBody=~s/<(aug|ia|edrg)><\/\1>//gs;
  $$TextBody=~s/<bib$regx{noTagOpString}>\&lt\;<url>$regx{noTagOpString}<\/url>\&gt\;<\/bib>/<bib$1>\&lt\;$2\&gt\;<\/bib>/gs;

  $$TextBody=~s/([\,\.\;] [iI]n[\:]?)<\/at> <pt>/<\/at>$1 <pt>/gs;
  $$TextBody=~s/<\/([a-z]+)>\?/\?<\/$1>/gs;

  #. S.<pg>329-348</pg> In:</at> <pt>
  $$TextBody=~s/$regx{puncSpace}([SPp][\. ]+)<pg>(\d+[\–\-0-9]+)<\/pg>(\s*)([Ii]n[\:\.\,]?)<\/at>(\s*)<pt>/<\/at>$1$2<pg>$3<\/pg>$4$5$6<pt>/gs;
  $$TextBody=~s/$regx{puncSpace}([SPp][\. ]+)<pg>(\d+[\–\-0-9]+)<\/pg><\/at>/<\/at>$1$2<pg>$3<\/pg>/gs;

  $$TextBody=~s/([\.\,\; ]+)<i>$regx{noTagOpString}<\/at>$regx{puncSpace}<pt>/<\/at>$1<i><pt>$2$3/gs;

  $$TextBody=~s/<\/yr>([\.\,\; ]+)<at><month>$regx{noTagAnystring}<\/month>([\)\.\,\;\: ]+)/<\/yr>$1<month>$2<\/month>$3<at>/gs;

  $$TextBody=~s/([\.\, ]+)<url>([^<>]+)<\/url><\/at>([\.\,\; ]+)<pt>/<\/at>$1$2$3<pt>/gs;
  $$TextBody=~s/([\.\, ]+)<url>([^<>]+)<\/url><\/at>/<\/at>$1<url>$2<\/url>/gs;
  $$TextBody=~s/(<\/aug>|<\/ia>|<\/edrg>)([\)\.\:\;\,]*) ([a-zA-Z]+[^<>]+?)(\. [\(]?)<yr>$regx{noTagAnystring}<\/yr>([\.\,\) ]+)<pt>$regx{noTagAnystring}<\/pt>([\.\, ]+)<v>$regx{noTagAnystring}<\/v>([\.\,\:\; \(]+)<iss>$regx{noTagAnystring}<\/iss>([\)\.\,\:\; ]+)<pg>$regx{noTagAnystring}<\/pg>([\.]?)<\/bib>/$1$2 <at>$3<\/at>$4<yr>$5<\/yr>$6<pt>$7<\/pt>$8<v>$9<\/v>$10<iss>$11<\/iss>$12<pg>$13<\/pg>$14<\/bib>/gs;
  $$TextBody=~s/<\/(aug|yr|ia)>([\.\,\)\;\: ]+)\&\#X([0-9]+)\;<pt>/<\/$1>$2<at>\&\#X$3\;<\/at><pt>/gs;

  if($ARGV[2]=~/^(ElsAPA5|ElsVancouver|ElsACS)$/)
    {
      $$TextBody=~s/<yr>$regx{noTagAnystring}<\/yr>([\,\.\; ]+)<month>$regx{noTagAnystring}<\/month>/<yr>$1$2$3<\/yr>/gs;
    }

  return $$TextBody;
}

#==================================================================================
sub BookMetrixMarking
  {
    my $TextBody=shift;

    use ReferenceManager::ReferenceRegex;
    my %regx = ReferenceManager::ReferenceRegex::new();

    $$TextBody=~s/\(<yr>$regx{year}<\/yr>--$regx{year}\)/\(<yr>$1--$2<\/yr>\)/gs;

    $$TextBody=~s/<bib([^<>]*?)><(aug|ia|edrg)>((?:(?!<[\/]?yr>)(?!<[\/]?\2>)(?!<bib)(?!<[\/]?p>)(?!<\/bib>).)*)<\/\2>([\.\,\:\)]+ )([^\.<>\(\)\[\] ]+?[^\.<>]+)( \(<yr>|\"\. |\. )((?:(?!<[\/]?at>)(?!<[\/]?p>)(?!<[\/]?pt>)(?!<[\/]?misc1>)(?!<[\/]?bt>)(?!<bib)(?!<\/bib>).)*)<\/bib>/<bib$1><$2>$3<\/$2>$4<bt>$5<\/bt>$6$7<\/bib>/gs;

     $$TextBody=~s/<bib([^<>]*?)><(aug|ia|edrg)>((?:(?!<[\/]?yr>)(?!<[\/]?\2>)(?!<bib)(?!<[\/]?p>)(?!<\/bib>).)*)<\/\2>([\.\,\:\)\( ]+)<yr>([^<>]+?)<\/yr>([\.\,\:\)]* )([^\.<>\(\)\[\] ]+?[^\.<>]+)( \(<yr>|\"\. |\. )((?:(?!<[\/]?at>)(?!<[\/]?p>)(?!<[\/]?pt>)(?!<[\/]?misc1>)(?!<[\/]?bt>)(?!<bib)(?!<\/bib>).)*)<\/bib>/<bib$1><$2>$3<\/$2>$4<yr>$5<\/yr>$6<bt>$7<\/bt> $8$9<\/bib>/gs;

    $$TextBody=~s/<bt><i>([^<>]+?)<\/i>([\.\,]) ([eE]d[s]?|Trans)\. ([^<>]+?)<\/bt>/<bt><i>$1<\/i><\/bt>$2 $3\. $4/gs;

    return $TextBody;
  }


#=============================================================================================================================

sub removeAllTags
     {
       my $bibText=shift;
       $bibText=~s/<(i|b|u|sup|sub|sb|sp)>/&$1\;/gs; 
       $bibText=~s/<\/(i|b|u|sup|sub|sb|sp)>/&\/$1\;/gs; 
       $bibText=~s/<(at|pt|bt|misc1|ia|cny|pbl|aug|par|yr|yrg|au|aus|auf|edrg|edr|eds|edm|edn|pg|v|iss|doi)>//gs; 
       $bibText=~s/<\/(at|pt|bt|misc1|ia|cny|pbl|aug|par|yr|yrg|au|aus|auf|edrg|edr|eds|edm|edn|pg|v|iss|doi)>//gs; 
       $bibText=~s/\&(i|b|u|sup|sub|sb|sp)\;/<$1>/gs; 
       $bibText=~s/&\/(i|b|u|sup|sub|sb|sp)\;/<\/$1>/gs;
       return $bibText;
     }

#=============================================================================================================================
return 1;
