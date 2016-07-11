#version 1.0
#Author: Neyaz Ahmad
package ReferenceManager::AuthorGroupBoundry;
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(applyBoundry);

sub applyBoundry
  {
    my $TextBody=shift;
    use ReferenceManager::ReferenceRegex;
    my %regx = ReferenceManager::ReferenceRegex::new();

#    print $TextBody;exit;

    $$TextBody=~s/<au><aus>$regx{noTagAnystring}<\/aus>([\,]*) <auf>$regx{noTagAnystring}<\/auf>([\,]*) $regx{and} <aus>/<au><aus1>$1<\/aus1>$2 <auf1>$3<\/auf1><\/au>$4 $5 <au><aus>/gs;
    $$TextBody=~s/<au><aus>$regx{noTagAnystring}<\/aus>([\,]*) <auf>$regx{noTagAnystring}<\/auf>([\,]*) $regx{and} <auf>/<au><aus1>$1<\/aus1>$2 <auf1>$3<\/auf1><\/au>$4 $5 <au><auf>/gs;
    $$TextBody=~s/<au><auf>$regx{noTagAnystring}<\/auf>([\,]*) <aus>$regx{noTagAnystring}<\/aus>([\,]*) $regx{and} <aus>/<au><auf1>$1<\/auf1>$2 <aus1>$3<\/aus1><\/au>$4 $5 <au><aus1>/gs;
    $$TextBody=~s/<au><auf>$regx{noTagAnystring}<\/auf>([\,]*) <aus>$regx{noTagAnystring}<\/aus>([\,]*) $regx{and} <auf>/<au><auf1>$1<\/auf1>$2 <aus1>$3<\/aus1><\/au>$4 $5 <au><auf1>/gs;

    $$TextBody=~s/<au><aus>$regx{noTagAnystring}<\/aus>/<au><aus1>$1<\/aus1>/gs;
    $$TextBody=~s/<au><auf>$regx{noTagAnystring}<\/auf>/<au><auf1>$1<\/auf1>/gs;
    $$TextBody=~s/<au><par>$regx{noTagAnystring}<\/par>/<au><par1>$1<\/par>/gs;

    $$TextBody=~s/<aus>$regx{noTagAnystring}<\/aus><\/au>/<aus>$1<\/aus1><\/au>/gs;
    $$TextBody=~s/<\/suffix><\/au>/<\/suffix1><\/au>/gs;
    $$TextBody=~s/<auf>$regx{noTagAnystring}<\/auf><\/au>/<auf>$1<\/auf1><\/au>/gs;

    $$TextBody=~s/<aus>$regx{noTagAnystring}<\/aus> <suffix>$regx{noTagAnystring}<\/suffix> <auf>$regx{noTagAnystring}<\/auf>/<au><aus1>$1<\/aus1> <suffix1>$2<\/suffix1> <auf1>$3<\/auf1><\/au>/gs;

    $$TextBody=~s/<auf>$regx{noTagAnystring}<\/auf> <par>$regx{noTagAnystring}<\/par> <aus>$regx{noTagAnystring}<\/aus>/<au><auf1>$1<\/auf1> <par1>$2<\/par1> <aus1>$3<\/aus1><\/au>/gs;
    $$TextBody=~s/<auf>$regx{noTagAnystring}<\/auf> <aus>$regx{noTagAnystring}<\/aus> <suffix>$regx{noTagAnystring}<\/suffix>/<au><auf1>$1<\/auf1> <aus1>$2<\/aus1> <suffix1>$3<\/suffix1><\/au>/gs;
    $$TextBody=~s/<auf>$regx{noTagAnystring}<\/auf> <aus>$regx{noTagAnystring}<\/aus> <par>$regx{noTagAnystring}<\/par>/<au><auf1>$1<\/auf1> <aus1>$2<\/aus1> <par1>$3<\/par1><\/au>/gs;


    $$TextBody=~s/ <par>$regx{noTagAnystring}<\/par> <aus>$regx{noTagAnystring}<\/aus>, <auf>$regx{noTagAnystring}<\/auf>/ <au><par1>$1<\/par> <aus>$2<\/aus>, <auf>$3<\/auf1><\/au>/gs;

    $$TextBody=~s/ <auf>$regx{noTagAnystring}<\/auf> <aus>$regx{noTagAnystring}<\/aus>([\;\, aund\&m]+)<auf>$regx{noTagAnystring}<\/auf> <aus>$regx{noTagAnystring}<\/aus>/ <auf>$1<\/auf> <aus>$2<\/aus>$3<auf>$4<\/auf> <aus>$5<\/aus>/gs;

    $$TextBody=~s/ <auf>$regx{noTagAnystring}<\/auf> <aus>$regx{noTagAnystring}<\/aus>\, <suffix>$regx{noTagAnystring}<\/suffix>\,/ <au><auf1>$1<\/auf> <aus>$2<\/aus>\, <suffix>$3<\/suffix1><\/au>\,/gs;
    $$TextBody=~s/\, <auf>$regx{noTagAnystring}<\/auf> <aus>$regx{noTagAnystring}<\/aus>\, /\, <au><auf1>$1<\/auf> <aus>$2<\/aus1><\/au>\, /gs; 
    $$TextBody=~s/\, <auf>$regx{noTagAnystring}<\/auf> <aus>$regx{noTagAnystring}<\/aus>\, /\, <au><auf1>$1<\/auf> <aus>$2<\/aus1><\/au>\, /gs; 

    $$TextBody=~s/<aus>$regx{noTagAnystring}<\/aus> <auf>$regx{noTagAnystring}<\/auf>\, <par>$regx{noTagAnystring}<\/par>\, /<au><aus1>$1<\/aus> <auf>$2<\/auf>\, <par>$3<\/par1><\/au>\, /gs;
    $$TextBody=~s/<aus>$regx{noTagAnystring}<\/aus> <auf>$regx{noTagAnystring}<\/auf>\, <par>$regx{noTagAnystring}<\/par>\. /<au><aus1>$1<\/aus> <auf>$2<\/auf>\, <par>$3<\/par1><\/au>\. /gs;

    $$TextBody=~s/<aus>$regx{noTagAnystring}<\/aus> <auf>$regx{noTagAnystring}<\/auf>\, <suffix>$regx{noTagAnystring}<\/suffix>\, /<au><aus1>$1<\/aus> <auf>$2<\/auf>\, <suffix>$3<\/suffix1><\/au>\, /gs;
    $$TextBody=~s/<aus>$regx{noTagAnystring}<\/aus> <auf>$regx{noTagAnystring}<\/auf>\, <suffix>$regx{noTagAnystring}<\/suffix>\. /<au><aus1>$1<\/aus> <auf>$2<\/auf>\, <suffix>$3<\/suffix1><\/au>\. /gs;

    $$TextBody=~s/<aus>$regx{noTagAnystring}<\/aus> <auf>$regx{noTagAnystring}<\/auf> <prefix>$regx{noTagAnystring}<\/prefix>/<au><aus1>$1<\/aus> <auf>$2<\/auf> <prefix>$3<\/prefix1><\/au>/gs;

    $$TextBody=~s/<aus>$regx{noTagAnystring}<\/aus> <auf>$regx{noTagAnystring}<\/auf> <suffix>$regx{noTagAnystring}<\/suffix>/<au><aus1>$1<\/aus> <auf>$2<\/auf> <suffix>$3<\/suffix1><\/au>/gs;
    $$TextBody=~s/<aus>$regx{noTagAnystring}<\/aus>, <auf>$regx{noTagAnystring}<\/auf> <suffix>$regx{noTagAnystring}<\/suffix>/<au><aus1>$1<\/aus>, <auf>$2<\/auf> <suffix>$3<\/suffix1><\/au>/gs;

    $$TextBody=~s/<aus>$regx{noTagAnystring}<\/aus>, <auf>$regx{noTagAnystring}<\/auf>, <suffix>$regx{noTagAnystring}<\/suffix>/<au><aus1>$1<\/aus>, <auf>$2<\/auf> <suffix>$3<\/suffix1><\/au>/gs;

    $$TextBody=~s/<aus>$regx{noTagAnystring}<\/aus> <auf>$regx{noTagAnystring}<\/auf> <par>$regx{noTagAnystring}<\/par>/<au><aus1>$1<\/aus> <auf>$2<\/auf> <par>$3<\/par1><\/au>/gs;
    $$TextBody=~s/<aus>$regx{noTagAnystring}<\/aus>, <auf>$regx{noTagAnystring}<\/auf> <par>$regx{noTagAnystring}<\/par>/<au><aus1>$1<\/aus>, <auf>$2<\/auf> <par>$3<\/par1><\/au>/gs;
    $$TextBody=~s/<aus>$regx{noTagAnystring}<\/aus>, <auf>$regx{noTagAnystring}<\/auf>, <par>$regx{noTagAnystring}<\/par>/<au><aus1>$1<\/aus>, <auf>$2<\/auf> <par>$3<\/par1><\/au>/gs;
    $$TextBody=~s/\, <suffix>$regx{noTagAnystring}<\/suffix> <aus>$regx{noTagAnystring}<\/aus> <auf>$regx{noTagAnystring}<\/auf>/\, <au><suffix1>$1<\/suffix> <aus>$2<\/aus> <auf>$3<\/auf1><\/au>/gs;

    $$TextBody=~s/ <auf>$regx{noTagAnystring}<\/auf> <suffix>$regx{noTagAnystring}<\/suffix> <aus>$regx{noTagAnystring}<\/aus>([\,\.\;]*) / <au><auf1>$1<\/auf> <suffix>$2<\/suffix> <aus>$3<\/aus1><\/au>$4 /gs;
    $$TextBody=~s/<auf>$regx{noTagAnystring}<\/auf> <suffix>$regx{noTagAnystring}<\/suffix> <aus>$regx{noTagAnystring}<\/aus>/ <au><auf1>$1<\/auf> <suffix>$2<\/suffix> <aus>$3<\/aus1><\/au>/gs;
    $$TextBody=~s/ <auf>$regx{noTagAnystring}<\/auf> <par>$regx{noTagAnystring}<\/par> <aus>$regx{noTagAnystring}<\/aus>\, / <au><auf1>$1<\/auf> <par>$2<\/par> <aus>$3<\/aus1><\/au>\, /gs;
    $$TextBody=~s/ <auf>$regx{noTagAnystring}<\/auf> <suffix>$regx{noTagAnystring}<\/suffix> <suffix>$regx{noTagAnystring}<\/suffix> <aus>$regx{noTagAnystring}<\/aus>([\,\.\;]*) / <au><auf1>$1<\/auf> <suffix>$2 $3<\/suffix> <aus>$4<\/aus1><\/au>$5 /gs;

#	print $$TextBody;exit;


    if($$TextBody=~/<bib$regx{noTagAnystring}><par>$regx{noTagAnystring}<\/par> <aus>$regx{noTagAnystring}<\/aus>([\,]*) <auf>$regx{noTagAnystring}<\/auf>/)
      {
	$$TextBody=~s/<bib$regx{noTagAnystring}><par>$regx{noTagAnystring}<\/par> <aus>$regx{noTagAnystring}<\/aus>([\,]*) <auf>$regx{noTagAnystring}<\/auf>/<bib$1><au><par1>$2<\/par> <aus>$3<\/aus>$4 <auf>$5<\/auf1><\/au>/gs;
      }
    elsif($$TextBody=~/<bib$regx{noTagAnystring}><prefix>$regx{noTagAnystring}<\/prefix> <aus>$regx{noTagAnystring}<\/aus>([\,]*) <auf>$regx{noTagAnystring}<\/auf>/)
      {
	$$TextBody=~s/<bib$regx{noTagAnystring}><prefix>$regx{noTagAnystring}<\/prefix> <aus>$regx{noTagAnystring}<\/aus>([\,]*) <auf>$regx{noTagAnystring}<\/auf>/<bib$1><au><prefix1>$2<\/prefix> <aus>$3<\/aus>$4 <auf>$5<\/auf1><\/au>/gs;
	$$TextBody=~s/<prefix>$regx{noTagAnystring}<\/prefix> <aus>$regx{noTagAnystring}<\/aus>, <auf>$regx{noTagAnystring}<\/auf>/<au><prefix1>$1<\/prefix> <aus>$1<\/aus>, <auf>$2<\/auf1><\/au>/gs;
      }
    elsif($$TextBody=~/<prefix>$regx{noTagAnystring}<\/prefix> <aus>$regx{noTagAnystring}<\/aus> <auf>$regx{noTagAnystring}<\/auf>([\;\, aund\&m]+)<aus>$regx{noTagAnystring}<\/aus> <auf>$regx{noTagAnystring}<\/auf>/)
      {
	$$TextBody=~s/<prefix>$regx{noTagAnystring}<\/prefix> <aus>$regx{noTagAnystring}<\/aus> <auf>$regx{noTagAnystring}<\/auf>/<au><prefix1>$1<\/prefix> <aus>$1<\/aus> <auf>$2<\/auf1><\/au>/gs;
      }
    elsif($$TextBody=~/<bib$regx{noTagAnystring}><aus>$regx{noTagAnystring}<\/aus> <auf>$regx{noTagAnystring}<\/auf>([\;\, aund\&m]+)<aus>$regx{noTagAnystring}<\/aus> <auf>$regx{noTagAnystring}<\/auf>/)
      {
	$$TextBody=~s/<aus>$regx{noTagAnystring}<\/aus> <auf>$regx{noTagAnystring}<\/auf>/<au><aus1>$1<\/aus> <auf>$2<\/auf1><\/au>/gs;
      }
    elsif($$TextBody=~/<bib$regx{noTagAnystring}><aus>$regx{noTagAnystring}<\/aus>, <auf>$regx{noTagAnystring}<\/auf>([\;\, aund\&m]+)<aus>$regx{noTagAnystring}<\/aus>, <auf>$regx{noTagAnystring}<\/auf>/)
      {
	$$TextBody=~s/<aus>$regx{noTagAnystring}<\/aus>, <auf>$regx{noTagAnystring}<\/auf>/<au><aus1>$1<\/aus>, <auf>$2<\/auf1><\/au>/gs;
      }
    elsif($$TextBody=~/<bib$regx{noTagAnystring}><auf>$regx{noTagAnystring}<\/auf> <aus>$regx{noTagAnystring}<\/aus>([\;\, aund\&m]+)<auf>$regx{noTagAnystring}<\/auf> <aus>$regx{noTagAnystring}<\/aus>/)
      {
	$$TextBody=~s/<auf>$regx{noTagAnystring}<\/auf> <aus>$regx{noTagAnystring}<\/aus>/<au><auf1>$1<\/auf> <aus>$2<\/aus1><\/au>/gs;
      }
    elsif($$TextBody=~/<bib$regx{noTagAnystring}><auf>$regx{noTagAnystring}<\/auf>, <aus>$regx{noTagAnystring}<\/aus>([\;\, aund\&m]+)<auf>$regx{noTagAnystring}<\/auf>, <aus>$regx{noTagAnystring}<\/aus>/)
      {
	$$TextBody=~s/<auf>$regx{noTagAnystring}<\/auf>, <aus>$regx{noTagAnystring}<\/aus>/<au><auf1>$1<\/auf>, <aus>$2<\/aus1><\/au>/gs;
      }

    $$TextBody=~s/<prefix>$regx{noTagAnystring}<\/prefix> <aus>$regx{noTagAnystring}<\/aus> <auf>$regx{noTagAnystring}<\/auf>/<au><prefix1>$1<\/prefix> <aus1>$2<\/aus> <auf>$3<\/auf1><\/au>/gs;
    $$TextBody=~s/<prefix>$regx{noTagAnystring}<\/prefix> <aus>$regx{noTagAnystring}<\/aus>, <auf>$regx{noTagAnystring}<\/auf>/<au><prefix1>$1<\/prefix> <aus1>$2<\/aus>, <auf>$3<\/auf1><\/au>/gs;

    $$TextBody=~s/<par>$regx{noTagAnystring}<\/par> <aus>$regx{noTagAnystring}<\/aus> <auf>$regx{noTagAnystring}<\/auf>/<au><par1>$1<\/par> <aus>$2<\/aus> <auf>$3<\/auf1><\/au>/gs;

    $$TextBody=~s/$regx{and} <auf>$regx{noTagAnystring}<\/auf> <aus>$regx{noTagAnystring}<\/aus>/$1 <au><auf1>$2<\/auf> <aus>$3<\/aus1><\/au>/gs;
    $$TextBody=~s/$regx{and} <auf>$regx{noTagAnystring}<\/auf>, <aus>$regx{noTagAnystring}<\/aus>/$1 <au><auf1>$2<\/auf>, <aus>$3<\/aus1><\/au>/gs;
    $$TextBody=~s/<aus>$regx{noTagAnystring}<\/aus> <auf>$regx{noTagAnystring}<\/auf>/<au><aus1>$1<\/aus> <auf>$2<\/auf1><\/au>/gs;
    $$TextBody=~s/<aus>$regx{noTagAnystring}<\/aus>, <auf>$regx{noTagAnystring}<\/auf>/<au><aus1>$1<\/aus>, <auf>$2<\/auf1><\/au>/gs;
    $$TextBody=~s/<auf>$regx{noTagAnystring}<\/auf> <aus>$regx{noTagAnystring}<\/aus>/<au><auf1>$1<\/auf> <aus>$2<\/aus1><\/au>/gs;
    $$TextBody=~s/<auf>$regx{noTagAnystring}<\/auf>, <aus>$regx{noTagAnystring}<\/aus>/<au><auf1>$1<\/auf>, <aus>$2<\/aus1><\/au>/gs;
    $$TextBody=~s/<\/au>([\, ]+)<aus>$regx{noTagAnystring}<\/aus>/<\/au>$1<au><aus1>$2<\/aus1><\/au>/gs;

    $$TextBody=~s/<auf>([A-Z \.\-])<\/auf>\. <aus>$regx{noTagAnystring}<\/aus>([\.\,\;])/<au><auf1>$1\.<\/auf> <aus>$2<\/aus1><\/au>$3/gs;


    $$TextBody=~s/<edr><edm>$regx{noTagAnystring}<\/edm> <eds>$regx{noTagAnystring}<\/eds>([\,]?) <suffix>$regx{noTagAnystring}<\/suffix><\/edr>/<edr><edm1>$1<\/edm1> <eds1>$2<\/eds1>$3 <suffix1>$4<\/suffix1><\/edr>/gs;
    $$TextBody=~s/<edr><eds>$regx{noTagAnystring}<\/eds>([\,]?) <edm>$regx{noTagAnystring}<\/edm>([\,]?) <suffix>$regx{noTagAnystring}<\/suffix><\/edr>/<edr><eds1>$1<\/eds1>$2 <edm1>$3<\/edm1>$4 <suffix1>$5<\/suffix1><\/edr>/gs;
    $$TextBody=~s/<edr><par>$regx{noTagAnystring}<\/par>([\,]?) <eds>$regx{noTagAnystring}<\/eds>([\,]?) <edm>$regx{noTagAnystring}<\/edm><\/edr>/<edr><par1>$1<\/par1>$2 <eds1>$3<\/eds1>$4 <edm1>$5<\/edm1><\/edr>/gs;
    $$TextBody=~s/<edr><eds>$regx{noTagAnystring}<\/eds>([\,]?) <edm>$regx{noTagAnystring}<\/edm>([\,]?) <par>$regx{noTagAnystring}<\/par><\/edr>/<edr><eds1>$1<\/eds1>$2 <edm1>$3<\/edm1>$4 <par1>$5<\/par1><\/edr>/gs;
    $$TextBody=~s/<edr><edm>$regx{noTagAnystring}<\/edm>([\,]?) <eds>$regx{noTagAnystring}<\/eds>([\,]?) <par>$regx{noTagAnystring}<\/par><\/edr>/<edr><edm1>$1<\/edm1>$2 <eds1>$3<\/eds1>$4 <par1>$5<\/par1><\/edr>/gs;

    $$TextBody=~s/<edr><eds>$regx{noTagAnystring}<\/eds>([\,]?) <edm>$regx{noTagAnystring}<\/edm><\/edr>/<edr><eds1>$1<\/eds>$2 <edm>$3<\/edm1><\/edr>/gs;
    $$TextBody=~s/<edr><edm>$regx{noTagAnystring}<\/edm>([\,]?) <eds>$regx{noTagAnystring}<\/eds><\/edr>/<edr><edm>$1<\/edm1>$2 <eds1>$3<\/eds><\/edr>/gs;

    if($$TextBody=~/In([\:\.]*) <eds>$regx{noTagAnystring}<\/eds> <edm>$regx{noTagAnystring}<\/edm>/)
      {
	$$TextBody=~s/<eds>$regx{noTagAnystring}<\/eds> <edm>$regx{noTagAnystring}<\/edm>/<edr><eds1>$1<\/eds> <edm>$2<\/edm1><\/edr>/gs;
      }
    elsif($$TextBody=~/In([\:\.]*) <eds>$regx{noTagAnystring}<\/eds>, <edm>$regx{noTagAnystring}<\/edm>/)
      {
	$$TextBody=~s/<eds>$regx{noTagAnystring}<\/eds>, <edm>$regx{noTagAnystring}<\/edm>/<edr><eds1>$1<\/eds>, <edm>$2<\/edm1><\/edr>/gs;
      }
    elsif($$TextBody=~/In([\:\.]*) <edm>$regx{noTagAnystring}<\/edm> <eds>$regx{noTagAnystring}<\/eds>/)
      {
	$$TextBody=~s/<edm>$regx{noTagAnystring}<\/edm> <eds>$regx{noTagAnystring}<\/eds>/<edr><edm1>$1<\/edm> <eds>$2<\/eds1><\/edr>/gs;
      }
    elsif($$TextBody=~/In([\:\.]*) <edm>$regx{noTagAnystring}<\/edm>, <eds>$regx{noTagAnystring}<\/eds>/)
      {
	$$TextBody=~s/<edm>$regx{noTagAnystring}<\/edm>, <eds>$regx{noTagAnystring}<\/eds>/<edr><edm1>$1<\/edm>, <eds>$2<\/eds1><\/edr>/gs;
      }
    elsif($$TextBody=~/In([\:\.]*) <edm>$regx{noTagAnystring}<\/edm>\. <eds>$regx{noTagAnystring}<\/eds>/)
      {
	$$TextBody=~s/<edm>$regx{noTagAnystring}<\/edm>\. <eds>$regx{noTagAnystring}<\/eds>/<edr><edm1>$1<\/edm>\. <eds>$2<\/eds1><\/edr>/gs;
      }

    $$TextBody=~s/<eds>$regx{noTagAnystring}<\/eds> <edm>$regx{noTagAnystring}<\/edm>/<edr><eds1>$1<\/eds> <edm>$2<\/edm1><\/edr>/gs;
    $$TextBody=~s/<eds>$regx{noTagAnystring}<\/eds>, <edm>$regx{noTagAnystring}<\/edm>/<edr><eds1>$1<\/eds>, <edm>$2<\/edm1><\/edr>/gs;
    $$TextBody=~s/<edm>$regx{noTagAnystring}<\/edm> <eds>$regx{noTagAnystring}<\/eds>/<edr><edm1>$1<\/edm> <eds>$2<\/eds1><\/edr>/gs;
    $$TextBody=~s/<edm>$regx{noTagAnystring}<\/edm>, <eds>$regx{noTagAnystring}<\/eds>/<edr><edm1>$1<\/edm>, <eds>$2<\/eds1><\/edr>/gs;
    $$TextBody=~s/<edm>$regx{noTagAnystring}<\/edm>\. <eds>$regx{noTagAnystring}<\/eds>/<edr><edm1>$1<\/edm>\. <eds>$2<\/eds1><\/edr>/gs;


    $$TextBody=~s/<aus1>/<aus>/gs;
    $$TextBody=~s/<auf1>/<auf>/gs;
    $$TextBody=~s/<aum1>/<aum>/gs;
    $$TextBody=~s/<edm1>/<edm>/gs;
    $$TextBody=~s/<eds1>/<eds>/gs;
    $$TextBody=~s/<edf1>/<edf>/gs;
    $$TextBody=~s/<par1>/<par>/gs;
    $$TextBody=~s/<prefix1>/<prefix>/gs;
    $$TextBody=~s/<suffix1>/<suffix>/gs;

    $$TextBody=~s/<\/aus1>/<\/aus>/gs;
    $$TextBody=~s/<\/auf1>/<\/auf>/gs;
    $$TextBody=~s/<\/aum1>/<\/aum>/gs;
    $$TextBody=~s/<\/edm1>/<\/edm>/gs;
    $$TextBody=~s/<\/eds1>/<\/eds>/gs;
    $$TextBody=~s/<\/edf1>/<\/edf>/gs;
    $$TextBody=~s/<\/par1>/<\/par>/gs;
    $$TextBody=~s/<\/suffix1>/<\/suffix>/gs;
    $$TextBody=~s/<\/prefix1>/<\/prefix>/gs;

    $$TextBody=~s/<au><au>/<au>/gs;
    $$TextBody=~s/<edr><edr>/<edr>/gs;
    $$TextBody=~s/<\/au><\/au>/<\/au>/gs;
    $$TextBody=~s/<\/edr><\/edr>/<\/edr>/gs;
    $$TextBody=~s/<doi>doi:([a-zA-Z0-9\-\_\/\\\.\@]+)<\/doi>/doi:<doi>$1<\/doi>/gs;
    $$TextBody=~s/<Xbib$regx{noTagAnystring}>(.*?)<\/Xbib>/<bib$1>$2<\/bib>/gs;


    return $$TextBody;
  }


return 1;