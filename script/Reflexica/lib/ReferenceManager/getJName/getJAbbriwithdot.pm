#version 1.0
package ReferenceManager::getJName::getJAbbriwithdot;

# perl d:/SanjeevRai/PerlTest/dbiExample.pl
use strict;
#use Win32;
#############################################
sub main{
  my $colName=shift;
  my $filePath=$0;
  $filePath=~s/\\/\//g;
  $filePath=~s/(.*)([\/\\])(.*?)\.(pl|exe)/$1$2\/JAbbriwithdot\.ini/;
  open (INFile, "<$filePath") || die "Error in open Journal DataBase ini file.";
  undef $/;
  my $iniDatabase=<INFile>;
  close (INFile);
  my $hashValRef=JAbbriwithdot($colName, $iniDatabase);
  return $hashValRef;
}
#############################################

sub JAbbriwithdot{
  my ($colName, $iniDatabase)=@_;
  my %hashValRef=();
  if ($colName eq "dot"){
    while($iniDatabase=~m/<sortJName>([^<>]+?)<\/sortJName><with><sortJNameDot>([^<>]+?)<\/sortJNameDot>/gs){
      $hashValRef{$1}=$2;
    }
  }
  else{
    while($iniDatabase=~m/<sortJName>([^<>]+?)<\/sortJName><with><sortJNameDot>([^<>]+?)<\/sortJNameDot>/gs){
      $hashValRef{$2}=$1;
    }
  }

return \%hashValRef;
}
#############################################
return 1;


