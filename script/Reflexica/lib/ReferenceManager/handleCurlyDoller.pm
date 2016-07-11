#  Author: Sanjeev Kumar Rai
package ReferenceManager::handleCurlyDoller;
#====================================================================================================================================================
sub matchCurly{
  my $TeXData=shift;
  ${$TeXData}=~s/\\{/<openCurly>/g;
  ${$TeXData}=~s/\\}/<closeCurly>/g;
  ${$TeXData}=~s/\{\}/<dummyCurly>/g;
  ${$TeXData}=~s/\\\[/<openBracket>/g;
  ${$TeXData}=~s/\\\]/<closeBracket>/g;
  ${$TeXData}=~s/\\\$/<dollarSign>/g;
  ${$TeXData}=~s/\\\#/<hashSign>/g;
  ${$TeXData}=~s/([^\\][A-Za-z0-9\-\_\=]+)\{(\?|\\\%|\%)\}([A-Za-z0-9\-\=\_]+)/$1$2$3/gs;
  ${$TeXData}=~s/([^\\][A-Za-z0-9\-\_\=]+)\{(\?|\\\%|\%)\}([A-Za-z0-9\-\=\_]+)/$1$2$3/gs;

  $TeXData=&matchEqualDoller($TeXData);
  $TeXData=&equationHandeling($TeXData);
  my $counter=1;
  while(${$TeXData}=~m/\{([^\{\}]+)\}/g){
    ${$TeXData}=~s/\{([^\{\}]+)\}/<cur${counter}>$1<\/cur${counter}>/g;
    $counter++;
  }
  return $TeXData;
}
#====================================================================================================================================================
sub matchEqualDoller{
  my $TeXData=shift;
  my $cunt=0;
  $cunt++ while (${$TeXData}=~m/\$/g);
  my $rem=$cunt%2;
  if ($rem != 0){
    #use Win32;
    #Win32::MsgBox('Extra doller for Equation found in file. Please check.',16,'Mismatch doller for Equation');
    print "False";
    exit;
  }
  return $TeXData;
}
#====================================================================================================================================================
sub rearrangeCurly{
  my $TeXData=shift;

  ${$TeXData}=~s/<cur[0-9]+>/\{/g;
  ${$TeXData}=~s/<\/cur[0-9]+>/\}/g;
  ${$TeXData}=~s/<dummyCurly>/\{\}/g;
  ${$TeXData}=~s/<openCurly>/\\{/g;
  ${$TeXData}=~s/<closeCurly>/\\}/g;
  ${$TeXData}=~s/<openBracket>/\\\[/g;
  ${$TeXData}=~s/<closeBracket>/\\\]/g;
  ${$TeXData}=~s/<dollarSign>/\\\$/g;
  ${$TeXData}=~s/<hashSign>/\\\#/g;
  ${$TeXData}=~s/<dispEquation>(.*?)<\/dispEquation>/\$\$$1\$\$/gs;
  ${$TeXData}=~s/<inlineEquation>(.*?)<\/inlineEquation>/\$$1\$/gs;
  return $TeXData;
}
#====================================================================================================================================================
sub deleteExtraCurly{
  my $TeXData=shift;
  # ${$TeXData}=~s/<cur([0-9]+)>\s*<cur([0-9]+)>(?!\\(?:it|bt))([^<>]*?)<\/cur\2>\s*<\/cur\1>/<cur$2>$3<\/cur$2>/g;
  # ${$TeXData}=~s/<cur([0-9]+)>\s*<cur([0-9]+)>([^<>]*?)<\/cur\2>\s*<\/cur\1>/<cur$2>$3<\/cur$2>/g;
  ${$TeXData}=~s/<cur([0-9]+)>\s*<cur([0-9]+)>((?:(?!<cur\2>)(?!<\/cur\2>).)*)<\/cur\2>\s*<\/cur\1>/<cur$2>$3<\/cur$2>/g;
  return $TeXData;
}
#====================================================================================================================================================
sub equationHandeling{
  my $TeXData=shift;
  ${$TeXData}=~s/\$\$/<dDoller>/gs;
  ${$TeXData}=~s/\$(.*?)\$/<inlineEquation>$1<\/inlineEquation>/gs;
  while (${$TeXData}=~m/<inlineEquation>(.*?)<\/inlineEquation>/gs){
    my $tempInlineData=$1;
    if ($tempInlineData=~/<dDoller>/){
      $tempInlineData=~s/<dDoller>//g;
    }
    ${$TeXData}=~s/<inlineEquation>(.*?)<\/inlineEquation>/<123inlineEquation>$tempInlineData<\/inlineEquation123>/s;
  }
  ${$TeXData}=~s/<123inlineEquation>(.*?)<\/inlineEquation123>/<inlineEquation>$1<\/inlineEquation>/gs;
  ${$TeXData}=~s/<dDoller>(.*?)<dDoller>/<dispEquation>$1<\/dispEquation>/gs;
  return $TeXData;
}
#====================================================================================================================================================
return 1;
