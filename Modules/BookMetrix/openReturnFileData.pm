#Author: Neyaz Ahmad

package BookMetrix::openReturnFileData;
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(openFile writeFileData);
my $boolValue = "True";
#==================================================================================================================================
sub errorFunction{
  $boolValue = "False";
  my $fileData = "";
  return(\$fileData, $boolValue);
}
#==================================================================================================================================
sub openFile{
  my $filePath = shift;
  my $fileData = "";
  open(INFILE, "< $filePath") || &errorFunction;
  undef $/;
  $fileData = <INFILE>;
  close(INFILE);
  return(\$fileData, $boolValue);
}
#==================================================================================================================================
sub writeFileData{
  my $filePath=shift;
  my $writeData=shift;
  open(OUTFILE, "> $filePath") || return "False";
  # binmode(OUTFILE, ":utf8");
  print OUTFILE ${$writeData};
  close(OUTFILE);
  return $boolValue;
}
#==================================================================================================================================
return 1;
