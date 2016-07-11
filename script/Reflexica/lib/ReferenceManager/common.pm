#Author: Neyaz Ahmad
package ReferenceManager::common;
use TeX2XML::handleCurlyDoller;
use strict;
# use base qw(Exporter);
#=============================================================================================================================================
# our @EXPORT = (
#   	       qw(openBIBfile getFileInfo openFile grabBibMacros replaceMacrosInRestFile defaultMacros getFieldValue printHashOfHasValue replaceTag tagInBBL helpAndExit bblCleanUp)
# 	      );
#=============================================================================================================================================
my $boolValue = "True";
#=============================================================================================================================================
sub main {
  my @arguments = @ARGV;
  if (not @arguments) {
    $boolValue = &helpAndExit("Uses:\ntagBBLwithBIB.exe <full file Name>")
  }
  goto End if ($boolValue eq "False");
  my $dir = shift @arguments;
  my $fileName = "";
  ($dir, $fileName, $boolValue) = &getFileInfo($dir);
  goto End if ($boolValue eq "False");
  my $bblData = &openFile("$dir$fileName");
  $bblData = &bblCleanUp($bblData);
  (my $bibData, $boolValue) = &openBIBfile($dir, $fileName);
  goto End if ($boolValue eq "False");
  (my $expandMacrosInBibHashRef, $bibData) = &grabBibMacros($bibData);
  $bibData = &replaceMacrosInRestFile($expandMacrosInBibHashRef, $bibData);
  #Start From getting all entry values;
  my $fieldValueHashRef = &getFieldValue($bibData);
  # &printHashOfHasValue($fieldValueHashRef);exit;
  $bblData = &tagInBBL($bblData, $fieldValueHashRef);
  $bblData = &replaceTag($bblData);
 End:
  return ($bblData, $boolValue);
}
#=============================================================================================================================================
sub openBIBfile {
  my ($dir, $fileName) = @_;
  $fileName =~ s/bbl$/bib/;
  if (!-e "$dir$fileName") {
    $boolValue = &helpAndExit("Bib File not found.\n\nUses:\ntagBBLwithBIB.exe <full BBL file Name>.")
  }
  goto End if ($boolValue eq "False");
  my $bblData = &openFile("$dir$fileName");
 End:
  return ($bblData, $boolValue);
}
#=============================================================================================================================================
sub getFileInfo {
  my $dir = shift;
  my $fileName = undef;
  chomp ($dir);
  $dir =~ s!\\!\/!g;
  $dir =~ s!\/$!! if ($dir !~ /\/$/);
  if ($dir =~ /^(.*\/)(.*\.[a-z]{2,4})$/) {
    ($dir, $fileName) = ($1, $2);
  }
  if (!-d $dir) {
    $boolValue = &helpAndExit("\($dir\) Directory not exists.\n\nUses:\ntagBBLwithBIB.exe <full BBL file Name>")
  }
  if ($fileName !~ /\.bbl$/ || $dir eq "" || ! -e "$dir$fileName") {
    $boolValue = &helpAndExit("Please provide valid BBL file name.\n\nUses:\ntagBBLwithBIB.exe <full BBL file Name>\n\n");
  }
  return ($dir, $fileName, $boolValue);
}
#=============================================================================================================================================
sub openFile{
  my $fullFilePath = shift;
  open (IN, "< $fullFilePath") || die "Error with opening file." if (-e $fullFilePath);
  undef $/;
  my $data = <IN>;
  close (IN);
  return \$data;
}
#=============================================================================================================================================
sub bblCleanUp {
  my $bblData = shift;
  ${$bblData} =~ s/\n{2,}/<enterMark>/g;
  ${$bblData} =~ s/\n/ /g;
  ${$bblData} =~ s/<enterMark>/\n/g;
  ${$bblData} =~ s/[ 	]{2,}/ /g;
  ${$bblData} =~ s/([^\\])\~/$1 /g;
  return $bblData;
}
#=============================================================================================================================================
sub replaceMacrosInRestFile {
  my ($expandMacrosInBibHashRef, $bibData) = @_;
  foreach my $keys (keys %$expandMacrosInBibHashRef) {
    $keys =~ s/\s*$//;
    ${$bibData} =~ s/([\b\=]\s*)${keys}(\s*[\b\,])/$1$$expandMacrosInBibHashRef{$keys}$2/g if ($keys ne "" && $keys ne "	" && $$expandMacrosInBibHashRef{$keys});
  }
  # print "$_\n" for (values %$expandMacrosInBibHashRef);exit;
  return $bibData;
}
#=============================================================================================================================================
sub grabBibMacros {
  my $bibData = shift;
  $bibData=&TeX2XML::handleCurlyDoller::matchCurly($bibData);
  my %expandMacrosInBibHash = ();
  while (${$bibData} =~ /\@[Ss][Tt][Rr][Ii][Nn][Gg]\s*<cur(\d+)>([^ \=]+)\s*\=\s*((?:(?!<\/cur\1>).)*)<\/cur\1>/s) {
    $expandMacrosInBibHash{$2} = $3;
    ${$bibData} =~ s/\@[Ss][Tt][Rr][Ii][Nn][Gg]\s*<cur(\d+)>(?:(?!<\/cur\1>).)*<\/cur\1>//s;
  }
  $bibData=&TeX2XML::handleCurlyDoller::rearrangeCurly($bibData);
  my $defaultMacrosRef = &defaultMacros();
  foreach my $keys (keys %$defaultMacrosRef) {
    $expandMacrosInBibHash{$keys} = $$defaultMacrosRef{$keys} if (not exists $expandMacrosInBibHash{$keys});
  }
  my $expandMacrosInBibHashRef = &cleanValues(\%expandMacrosInBibHash);
  ${$bibData} =~ s/^\n{2,}$/\n/g;
  return ($expandMacrosInBibHashRef, $bibData);
}
#=============================================================================================================================================
sub cleanValues {
  my $expandMacrosInBibHashRef = shift;
  for (keys %$expandMacrosInBibHashRef) {
    $$expandMacrosInBibHashRef{$_} =~ s/(?:^["\s]|["\s]$)//g;
    $$expandMacrosInBibHashRef{$_} =~ s/^<cur(\d+)>((?!<\/cur\1>).*)<\/cur\1>$/$2/g;
    $$expandMacrosInBibHashRef{$_} =~ s/\n{2,}/\n/g;
    $$expandMacrosInBibHashRef{$_} =~ s/[ ]{2,}/ /g;
    $$expandMacrosInBibHashRef{$_} =~ s/<cur(\d+)>([A-Z]+)<\/cur\1>/$2/g;
    $$expandMacrosInBibHashRef{$_} =~ s/<cur(\d+)>\s*<\/cur\1>//g;
    my $refData = &TeX2XML::handleCurlyDoller::rearrangeCurly(\$$expandMacrosInBibHashRef{$_});
    $$expandMacrosInBibHashRef{$_} = ${$refData};
  }
  return $expandMacrosInBibHashRef;
}
#=============================================================================================================================================
sub defaultMacros {
  my %defaultMacros = (
		       "jan" => "January",
		       "feb" => "February",
		       "mar" => "March",
		       "apr" => "April",
		       "may" => "May",
		       "jun" => "June",
		       "jul" => "July",
		       "aug" => "August",
		       "sep" => "September",
		       "oct" => "October",
		       "nov" => "November",
		       "dec" => "December",
		       "acmcs" => "ACM Computing Surveys",
		       "acta" => "Acta Informatica",
		       "cacm" => "Communications of the ACM",
		       "ibmjrd" => "IBM Journal of Research and Development",
		       "ibmsj" => "IBM Systems Journal",
		       "ieeese" => "IEEE Transactions on Software Engineering",
		       "ieeetc" => "IEEE Transactions on Computers",
		       "ieeetcad" => "IEEE Transactions on Computer-Aided Design of Integrated Circuits",
		       "ipl" => "Information Processing Letters",
		       "jacm" => "Journal of the ACM",
		       "jcss" => "Journal of Computer and System Sciences",
		       "scp" => "Science of Computer Programming",
		       "sicomp" => "SIAM Journal on Computing",
		       "tocs" => "ACM Transactions on Computer Systems",
		       "tods" => "ACM Transactions on Database Systems",
		       "tog" => "ACM Transactions on Graphics",
		       "toms" => "ACM Transactions on Mathematical Software",
		       "toois" => "ACM Transactions on Office Information Systems",
		       "toplas" => "ACM Transactions on Programming Languages and Systems",
		       "tcs" => "Theoretical Computer Science");
  return \%defaultMacros;
}
#=============================================================================================================================================
sub getFieldValue {
  my $bibData = shift;
  my %fieldValueHash = ();
  my @ENTRY = qw(article book conference proceedings inproceedings booklet inbook incollection manual mastersthesis misc phdthesis techreport unpublished);
  my @FIELDS = qw(address author booktitle chapter edition editor howpublished institution journal key month note number organization pages publisher school series title type volume year);
  # my @informationFields = qw(URL ISBN ISSN LCCN abstract keywords price copyright language contents);
  $bibData = &TeX2XML::handleCurlyDoller::matchCurly($bibData);
# print  ${$bibData};
  while (${$bibData} =~ m/\@\w+\s*<cur(\d+)>([^\,]+)\,((?:(?!<cur\1>).)*?)<\/cur\1>/gs) {
    my ($ID, $Values) = ($2, $3);
    foreach my $entry (@FIELDS) {
      my $fieldsData = "";
      if ($Values =~ /\b$entry\s*=\s*<cur(\d+)>((?:(?!<\/cur\1>).)*)<\/cur\1>/is) {
	$fieldsData = $2;
      } elsif ($Values =~ /\b$entry\s*=\s*(.*?),\n/i) {
	$fieldsData = $1;
      }
      if ($fieldsData ne "") {
	$fieldsData =~ s/\s+/ /g;
	my $fieldsDataRef=&TeX2XML::handleCurlyDoller::rearrangeCurly(\$fieldsData);
	if ($entry =~ /^author$/i) {
	  $fieldsDataRef = &manageAnd($fieldsDataRef);
	}
	if ($entry =~ /^pages$/i) {
	  ${$fieldsDataRef} =~ s/\b-\b/--/;
	}
	$fieldValueHash{$ID}{$entry} = ${$fieldsDataRef};
      }
    }
  }
  return \%fieldValueHash;
}
#=============================================================================================================================================
sub manageAnd {
  my $fieldsDataRef = shift;
  my $andCount = 1;
  while (${$fieldsDataRef} =~ s/ and /<and$andCount>/s) {
    $andCount++;
  }
  $andCount--;
  my $originalCount = $andCount;
  if ($andCount >= 1) {
    while ($andCount >= 1) {
      if ($andCount < $originalCount) {
	${$fieldsDataRef} =~ s/<and${andCount}>/, /s;
      }
      $andCount--;
    }
    ${$fieldsDataRef} =~ s/<and\d+>/ and /s;
  }
  $andCount = $originalCount = 0;
  return $fieldsDataRef;
}
#=============================================================================================================================================
sub printHashOfHasValue {
  my $fieldValueHashRef = shift;
  # foreach my $ID (keys %$fieldValueHashRef) {
  #   foreach my $k (keys $$fieldValueHashRef{$ID}) {
  #     print "[$ID]=>$k=>", $$fieldValueHashRef{$ID}{$k}, "\n";
  #   }
  # }
}
#=============================================================================================================================================
sub replaceTag {
  my $bblData = shift;
  my %BibFIELDSwithTeXCode = (
			      'address' => 'cny',
			      'author' => 'au',
			      'booktitle' => 'bt',
			      'chapter' => 'ct',
			      'edition' => 'edn',
			      'editor' => 'edr',
			      'howpublished' => '',
			      'institution' => 'ins',
			      'journal' => 'pt',
			      'key' => '',
			      'month' => '',
			      'note' => '',
			      'number' => 'iss',
			      'organization' => '',
			      'pages' => 'pg',
			      'publisher' => 'pbl',
			      'school' => '',
			      'series' => '',
			      'title' => 'ct',
			      'type' => '',
			      'volume' => 'v',
			      'year' => 'yr');

  # my @informationFields = qw(URL ISBN ISSN LCCN abstract keywords price copyright language contents);
  foreach my $AbbrFild (keys %BibFIELDSwithTeXCode) {
    if ($BibFIELDSwithTeXCode{$AbbrFild} eq "") {
      ${$bblData} =~ s/<([\/]?)$AbbrFild>//g;
    } else {
      ${$bblData} =~ s/<([\/]?)$AbbrFild>/<$1$BibFIELDSwithTeXCode{$AbbrFild}>/g;
    }
  }
  return $bblData;
}
#=============================================================================================================================================
sub tagInBBL {
  my ($bblData, $fieldValueHashRef) = @_;
  $bblData = &TeX2XML::handleCurlyDoller::matchCurly($bblData);
  foreach my $ID (keys %$fieldValueHashRef) {
    foreach my $k (keys $$fieldValueHashRef{$ID}) {
      if (${$bblData} =~ /\\bibitem<cur1>${ID}<\/cur1>\s*(.*?)\n/) {
	my $bib = $1;
	my $bibRef = &TeX2XML::handleCurlyDoller::rearrangeCurly(\$bib);
	$bib = ${$bibRef};
	### For testing purpose ###
	# if ($ID eq "UTS" && $k eq "journal") {
	#   print "xx", $$fieldValueHashRef{$ID}{$k}, "\n";
	# }
	$bib =~ s/(\Q$$fieldValueHashRef{$ID}{$k}\E)/<$k>$1<\/$k>/i;
	${$bblData} =~ s/\\bibitem<cur1>${ID}<\/cur1>\s*(.*?)\n/\\bibitem<cur1>${ID}<\/cur1>$bib\n/;
      }
    }
  }
  $bblData=&TeX2XML::handleCurlyDoller::rearrangeCurly($bblData);
  return $bblData;
}
#=============================================================================================================================================
sub helpAndExit {
  my $msg = shift;
  #use Win32;
  # Win32::MsgBox("$msg", 16, "Uses Help");
  $boolValue = "False";
}
#=============================================================================================================================================
1;
