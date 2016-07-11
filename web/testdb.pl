#!/usr/bin/perl

use lib("/etc/EXT/Citation_Metrics/Modules");
use strict;
use warnings;
use DBI;
use DBConnection; 
#use GetConfig;
use Config::Simple;
use Data::Dumper;


    


my $dbh = dbConnect();


my $sth = $dbh->prepare("SELECT DOI FROM CitationData");
$sth->execute() or die $DBI::errstr;
my $rc = $sth->rows;
print "\n Number of rows found  $rc";
while (my @row = $sth->fetchrow_array()) {
   my ($doi) = @row;
   print "\n doi is = $doi\n";
}

$sth->finish();

