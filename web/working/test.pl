#perl /etc/EXT/Citation_Metrics/web/working/test.pl
BEGIN{
    my $ScriptLocation=$0;
    if($ScriptLocation!~/[\/\\]/){
	use Cwd;
	my $pwd = getcwd;
	$pwd=~s/\//\//;
	$ScriptLocation="$pwd"."\/"."$ScriptLocation";
    }elsif($ScriptLocation=~/^\.\/([^\/\\]+?)$/){
	use Cwd;
	my $pwd = getcwd;
	$pwd=~s/\//\//;
	$ScriptLocation=~s/^\.\///;
	$ScriptLocation="$pwd"."\/"."$ScriptLocation";
    }
    $ScriptLocation=~s/\/([^\/\\]+?)$//;
    my $ModuleLocation=$ScriptLocation;
    $ModuleLocation=~s/(^.*\/|^)([^\/\\]+?)$/$1Modules/;
    print "$ScriptLocation\n$ModuleLocation\n";
    unshift(@INC, "$ModuleLocation");
}

use File::OpenReturnFileData;


