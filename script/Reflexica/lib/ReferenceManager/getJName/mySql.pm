package getJName::mySql;
# perl d:/SanjeevRai/PerlTest/dbiExample.pl
use strict;
use DBI;
use Win32;
#############################################
sub main{
  # my ($hashValRef, $colName)=@_;
  my $dbh=&localConnection();
  my $JTFull=getFullName($dbh);
  &disconnect($dbh);
  return $JTFull;
}
#############################################
sub Fget{
  my @arry=(118, 119, 123, 132);
  my $abc;
  my $counter=4;
  foreach my $values (@arry){
    $values=$values-$counter;
    $abc=$abc.chr($values);
    $counter+=4;
  }
  return $abc;
}
#############################################
sub getFullName{
  my $dbh=shift;
  my ($sql, $sth, $searchCol);
  my $JTFull;
  $sql = "select process\_status from dbxml2tex\.tblprocessingdetails where processid=\'2000\'";
  $sth = $dbh->prepare($sql);
  #Execute the statement
  $sth->execute();
  # Bind the results to the local variables
  $sth->bind_columns(undef, \$JTFull);
  #Retrieve values from the result set
  if($sth->fetch()){
    $JTFull;
    # print $hashVal, "\t\t<=xxx=>\t\t", $$hashValRef{$hashVal}, "\n";
  }
  $sth->finish();
  close OUT;
  return $JTFull;
}
#############################################
sub localConnection{
  my $dsn = 'DBI:mysql';
  my $host = '192.168.84.8:3306';
  my $database = 'dbproduction';
  # Connect via DBD::ODBC by specifying the DSN dynamically.
  my $dbh = DBI->connect("$dsn:$database:$host",Fget,Fget) || die "Database connection not made: $DBI::errstr";
  return $dbh;
}
#############################################
sub disconnect{
  my $dbh=shift;
  #Close the connection
  $dbh->disconnect();
}
#############################################
return 1;