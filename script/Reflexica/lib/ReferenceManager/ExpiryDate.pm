#version 1.0.4
#Author: Neyaz Ahmad
package ReferenceManager::ExpiryDate;
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(CheckExpireDate);

###################################################################################################################################################
###################################################################################################################################################
sub CheckExpireDate{
  use Time::localtime;
  use File::stat;
  my $CreattedDate=ctime( stat($0)->ctime );
  my $LastModifiedDate=ctime( stat($0)->mtime );
  my $LastAccessDate=ctime( stat($0)->atime );
  my $now = ctime();

  $LastModifiedDate=~s/([A-Z][a-z]+ )//s;
  $LastModifiedDate=~s/([0-9]+) ([0-9]+):([0-9]+):([0-9]+) ([0-9][0-9][0-9][0-9]+)$/$1 $5/s;
  $CreattedDate=~s/([A-Z][a-z]+ )//s;
  $CreattedDate=~s/([0-9]+) ([0-9]+):([0-9]+):([0-9]+) ([0-9][0-9][0-9][0-9]+)$/$1 $5/s;
  $now=~s/([A-Z][a-z]+ )//s;
  $now=~s/([0-9]+) ([0-9]+):([0-9]+):([0-9]+) ([0-9][0-9][0-9][0-9]+)$/$1 $5/s;

  my %month=('Jan'=>1, 'Feb'=>2, 'Mar'=>3, 'Apr'=>4, 'May'=>5, 'Jun'=>6, 'Jul'=>7, 'Aug'=>8, 'Sep'=>9, 'Sept'=>9, 'Oct'=>10, 'Nov'=>11, 'Dec'=>12, 'January'=>1, 'February'=>2, 'March'=>3, 'April'=>4, 'May'=>5, 'June'=>6, 'July'=>7, 'August'=>8, 'September'=>9, 'October'=>10, 'November'=>11, 'December'=>12, 'Januar'=>1, 'Februar'=>2, 'März'=>3, 'Mai'=>5, 'Juni'=>6, 'Juli'=>7, 'Oktober'=>10, 'Dezember'=>12);

  my %LastModifiedDates=();
  my %CreattedDates=();
  my %nowDates=();

  my %limitDates=(minMonth=>8, maxMonth=>9, day=>31, year=>2015);
  if($LastModifiedDate=~/^([A-Z][a-z]+) /)
    {
      my $monthChar=$1;
      $LastModifiedDate=~s/^([A-Z][a-z]+) //gs;
      $LastModifiedDates{month}=$month{$monthChar};
    }

  if($CreattedDate=~/^([A-Z][a-z]+) /)
    {
      my $monthChar=$1;
      $CreattedDate=~s/^([A-Z][a-z]+) //gs;
      $CreattedDates{month}=$month{$monthChar};
  }

  if($now=~/^([A-Z][a-z]+) /)
    {
      my $monthChar=$1;
      $now=~s/^([A-Z][a-z]+) //gs;
      $nowDates{month}=$month{$monthChar};
    }

  if($LastModifiedDate=~/([0-9]+) ([0-9][0-9][0-9][0-9])/)
    {
      $LastModifiedDates{day}=$1;
      $LastModifiedDates{year}=$2;
    }

  if($CreattedDate=~/([0-9]+) ([0-9][0-9][0-9][0-9])/)
    {
      $CreattedDates{day}=$1;
      $CreattedDates{year}=$2;
    }

  if($now=~/([0-9]+) ([0-9][0-9][0-9][0-9])/)
    {
      $nowDates{day}=$1;
      $nowDates{year}=$2;
    }

  #my %limitDates=(minMonth=>7, maxMonth=>8, day=>31, year=>2015);
  # $nowDates{year}=2015; #Test
  # $nowDates{month}=8;
  # $nowDates{day}=31;

   # print "\nFile: $0";
   # print "\nLast modify   time:  $LastModifiedDates{month} $LastModifiedDates{day} $LastModifiedDates{year}";
   # print "\nFile creation time: $CreattedDates{month} $CreattedDates{day} $CreattedDates{year}";
   # print "\nToday creation time: $nowDates{month} $nowDates{day} $nowDates{year}";


  if($nowDates{year} ne $limitDates{year})
  {
    print "\nError";
    exit;
  }else{
    if($nowDates{month} < $limitDates{minMonth}){
      print "\nError";
      exit;
    }elsif($nowDates{month} > $limitDates{maxMonth}){
      print "\nError";
      exit;
    }else{
      if($nowDates{month} eq $limitDates{maxMonth}) {
	if($nowDates{day} > $limitDates{day}){
	  print "\nError";
	  exit;
	}
      }
    }
  }


  # if ($CreattedDates{year} ne 2014){
  #   exit;
  # }
  # if ($CreattedDates{month} ne 11){
  #   exit;
  # }

  if ($LastModifiedDates{year} ne 2015){
    exit;
  }

  if ($LastModifiedDates{month}!~/^(8|9)$/){
    exit;
  }

  if($nowDates{year} ne $LastModifiedDates{year})
  {
    print "\nError";
    exit;
  }else{
    if($nowDates{month} < $LastModifiedDates{month}){
      print "\nError";
      exit;
    }
  }

  #print "\nOK";exit;
}
return 1;

