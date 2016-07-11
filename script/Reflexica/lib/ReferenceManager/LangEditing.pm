#version 1.0.4
#Author: Neyaz Ahmad
package ReferenceManager::LangEditing;
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(GermanEnglishQuote MdashToNdash SpecialPrefixTermEditing EditMonthName);

#=======================================================================================================================================
sub GermanEnglishQuote{
  my ($FileText, $language)=@_;

  $$FileText=~s/\&lt\;([\/]?)(pg|misc1|bt|srt|cny|pbl|edn)\&gt\;/<$1$2>/g;
  if ($language eq "En"){
    $$FileText=~s/‚Äû((?:(?!‚Äû)(?!‚Äú)(?!<[\/]?bib>)(?!<[\/]?yrg>)(?!<[\/]?edrg>)(?!<[\/]?aug>).)*?)‚Äú/‚Äú$1‚Äù/gs;
    $$FileText=~s/([\.\:\;\,<>\)\]\?\!\s])Ñ((?:(?![\.\:\;\,<> ]ì[^à])(?![\.\:\;\,<> ]î[\w\d \.\,\;\:\)\]\&\s])(?![\.\:\;\,<> ]Ñ)(?!<[\/]?bib>)(?!<[\/]?yrg>)(?!<[\/]?edrg>)(?!<[\/]?aug>).)*?)([\w\d<>\?\!\%\#\@\^\*\-\+\=\/\~\.\,\;\:\(\[\&\s]+)ì([\.\:\;\,\?\!\-\&<>\)\]\s])/$1‚Äú$2$3‚Äù$4/gs;
  }

  if ($language eq "De"){
    $$FileText=~s/‚Äú((?:(?!‚Äù)(?!\")(?!‚Äú)(?!<[\/]?bib>)(?!<[\/]?yrg>)(?!<[\/]?edrg>)(?!<[\/]?aug>).)*?)‚Äù/‚Äû$1‚Äú/gs;
    $$FileText=~s/([\.\:\;\,<>\)\]\?\!\s]+)\"((?:(?!‚Äù)(?!\")(?!‚Äú)(?!<[\/]?bib>)(?!<[\/]?yrg>)(?!<[\/]?edrg>)(?!<[\/]?aug>).)*?)\"/$1‚Äû$2‚Äú/gs;

    $$FileText=~s/([\.\:\;\,<>\)\]\?\!\s]+)ì([\w\d\&\?\!\%\#\@\^\*\-\+\=\/\~<>\.\,\;\:\(\[\s])((?:(?![\.\:\;\, ]ì[^à])(?![\.\:\;\, ]î)(?![\.\:\;\, ]Ñ)(?!<[\/]?bib>)(?!<[\/]?yrg>)(?!<[\/]?edrg>)(?!<[\/]?aug>).)*?)([\w\d<>\?\!\%\#\@\^\*\-\+\=\/\~\.\,\;\:\(\[\&\s]+)î([\.\:\;\,\?\!\-\&<>\)\]\s])/$1‚Äû$2$3$4‚Äú$5/gs;
    $$FileText=~s/([\.\:\;\,<>\)\]\?\!\s]+)ì([^à])((?:(?![\.\:\;\, ]ì[^à])(?![\.\:\;\, ]î)(?![\.\:\;\, ]Ñ)(?!<[\/]?bib>)(?!<[\/]?yrg>)(?!<[\/]?edrg>)(?!<[\/]?aug>).)*?)([\w\d<>\?\!\%\#\@\^\*\-\+\=\/\~\.\,\;\:\(\[\&\s]+)î([\.\:\;\,\?\!\-\&<>\)\]\s])/$1‚Äû$2$3$4‚Äú$5/gs;
    $$FileText=~s/([\.\:\;\,<>\)\]\?\!\s]+)ì([^à])((?:(?![\.\:\;\, ]ì[^à])(?![\.\:\;\, ]î)(?![\.\:\;\, ]Ñ)(?!<[\/]?bib>)(?!<[\/]?yrg>)(?!<[\/]?edrg>)(?!<[\/]?aug>).)*?)([^œŒ√ƒ≈«–—Ÿ⁄€ …÷◊∆»À])î([\.\:\;\,\?\!\-\&<>\)\]\s])/$1‚Äû$2$3$4‚Äú$5/gs;
  }

  $$FileText=~s/<([\/]?)(pg|misc1|bt|srt|cny|pbl|edn|pg)>/\&lt\;$1$2\&gt\;/g;
  return $FileText;
}

#=================================================================================
sub MdashToNdash{
  my ($FileText, $language)=@_;

  if ($language eq "De"){
    $$FileText=~s/[\s]?‚Äî[\s]?/ ‚Äì /gs;
  }
  return $FileText;
}

#=================================================================================
sub SpecialPrefixTermEditing{
  my ($FileText, $language, $regx)=@_;

  if ($language eq "De"){
    $$FileText=~s/$$regx{accessed}([\:\.\,\s]+[oOaA][nmt] |[\:\.\,\s]+)$$regx{dateDay}([\.\,\s]*)$$regx{monthPrefix}([\.\,\;\s]+)$$regx{year}/Zugegriffen: $3\. \u$5\E\. $7/gs;
    $$FileText=~s/$$regx{accessed}([\:\.\,\s]+[oOaA][nmt] |[\:\.\,\s]+)$$regx{year}([\.\,\s]*)$$regx{monthPrefix}([\.\,\;\s]+) $$regx{dateDay}/Zugegriffen: $7\. \u$5\E\. $3/gs;
    $$FileText=~s/$$regx{accessed}([\:\.\,\s]+[oOaA][nmt] |[\:\.\,\s]+)$$regx{monthPrefix}([\.\,\s]*)$$regx{dateDay}([\.\,\;\s]+)$$regx{year}/Zugegriffen: $5\. \u$3\E\. $7/gs;
    $$FileText=~s/$$regx{accessed}([\:\.\,\s]+[oOaA][nmt] |[\:\.\,\s]+)$$regx{monthPrefix}([\.\,\s]*)$$regx{year}/Zugegriffen: \u$3\E\. $5/gs;
    $$FileText=~s/$$regx{accessed}([\:\.\,\s]+[oOaA][nmt] |[\:\.\,\s]+)$$regx{year}([\.\,\s]*)$$regx{monthPrefix}/Zugegriffen: \u$5\E\. $3/gs;
    #Zugriffen 30.10.2014
    $$FileText=~s/$$regx{accessed}([\:\.\,\s]+[oOaA][nmt] |[\:\.\,\s]+)$$regx{dateDay}([\.\, \/]+)$$regx{dateMonth}([\.\, \/]+)$$regx{year}/Zugegriffen: $3$4$5$6$7/gs;
    $$FileText=~s/$$regx{accessed}([\:\.\,\s]+[oOaA][nmt] |[\:\.\,\s]+)$$regx{dateMonth}([\.\, \/]+)$$regx{dateDay}([\.\, \/]+)$$regx{year}/Zugegriffen: $3$4$5$6$7/gs;

  }
  if ($language eq "En"){
    $$FileText=~s/$$regx{accessed}([\:\.\,\s]+[oOaA][nmt] |[\:\.\,\s]+)$$regx{dateDay}([\.\,\s]*)$$regx{monthPrefix}([\.\,\;\s]+)$$regx{year}/Accessed $3 \u$5\E $7/gs;
    $$FileText=~s/$$regx{accessed}([\:\.\,\s]+[oOaA][nmt] |[\:\.\,\s]+)$$regx{year}([\.\,\s]*)$$regx{monthPrefix}([\.\,\;\s]+) $$regx{dateDay}/Accessed $7 \u$5\E $3/gs;
    $$FileText=~s/$$regx{accessed}([\:\.\,\s]+[oOaA][nmt] |[\:\.\,\s]+)$$regx{monthPrefix}([\.\,\s]*)$$regx{dateDay}([\.\,\;\s]+)$$regx{year}/Accessed $5 \u$3\E $7/gs;
    $$FileText=~s/$$regx{accessed}([\:\.\,\s]+[oOaA][nmt] |[\:\.\,\s]+)$$regx{monthPrefix}([\.\,\s]*)$$regx{year}/Accessed \u$3\E $5/gs;
    $$FileText=~s/$$regx{accessed}([\:\.\,\s]+[oOaA][nmt] |[\:\.\,\s]+)$$regx{year}([\.\,\s]*)$$regx{monthPrefix}/Accessed \u$5\E $3/gs;

    $$FileText=~s/$$regx{accessed}([\:\.\,\s]+[oOaA][nmt] |[\:\.\,\s]+)$$regx{dateDay}([\.\, \/]+)$$regx{dateMonth}([\.\, \/]+)$$regx{year}/Accessed $3$4$5$6$7/gs;
    $$FileText=~s/$$regx{accessed}([\:\.\,\s]+[oOaA][nmt] |[\:\.\,\s]+)$$regx{dateMonth}([\.\, \/]+)$$regx{dateDay}([\.\, \/]+)$$regx{year}/Accessed $3$4$5$6$7/gs;
  }
  return $FileText;
}

sub EditMonthName{
  my ($FileText, $language, $regx)=@_;

  #March, April, May, June, July
  # M√§rz, April, Mai, Juni, and Juli
  #Januar: Jan., Februar: Feb., August: Aug., September: Sept., Oktober: Oct., November: Nov., December: Dec.
  #January: Jan, February: Feb, August: Aug, September: Sept, October: Oct, November: Nov, December: Dec.


  my %monthAbbr = (
		       En=> {
			     January=>'Jan', 'Januar'=>'Jan', 'Jan'=>'Jan', 'February'=>'Feb', 'Februar'=>'Feb', 'Febr'=>'Feb', 'Feb'=>'Feb', 'Mar'=>'March', 'March'=>'March', 'M√§rz'=>'March', 'M√§r'=>'March', 'M‰r'=>'March', 'M‰rz'=>'March', 'April'=>'April', 'Aprl'=>'April', 'Apr'=>'April', 'May'=>'May', 'Mai'=>'May', 'Jun'=>'June', 'June'=>'June', 'Juni'=>'June', 'Jul'=>'July', 'July'=>'July', 'Juli'=>'July', 'August'=>'Aug', 'Augs'=>'Aug', 'Aug'=>'Aug', 'September'=>'Sept', 'Sept'=>'Sept', 'Sep'=>'Sept', 'October'=>'Oct', 'Oktober'=>'Oct', 'Okt'=>'Oct', 'Oct'=>'Oct', 'November'=>'Nov', 'Nov'=>'Nov', 'December'=>'Dec', 'Dezember'=>'Dec', 'Dez'=>'Dec', 'Dec'=>'Dec', 
			    },
		       De=> {
			     'Januar'=>'Jan.', 'January'=>'Jan.', 'Jan'=>'Jan.', 'Februar'=>'Feb.', 'February'=>'Feb.', 'Febr'=>'Feb.', 'Feb'=>'Feb.', 'M√§rz'=>'M√§rz', 'M√§r'=>'M√§rz', 'M‰r'=>'M√§rz', 'Mar'=>'M√§rz', 'March'=>'M√§rz', April=>'April', 'Aprl'=>'April', 'Apr'=>'April', Mai=>'Mai', May=>'Mai', 'June'=>'Juni', 'Juni'=>'Juni', 'Jun'=>'Juni', 'Jul'=>'Juli', Juli=>'Juli', 'July'=>'Juli', 'August'=>'Aug.', 'Augs'=>'Aug.', 'Aug'=>'Aug.', 'September'=>'Sept.', 'Sept'=>'Sept.', 'Sep'=>'Sept.', 'October'=>'Okt.', 'Oktober'=>'Okt.', 'Okt'=>'Okt.', 'Oct'=>'Okt.', 'November'=>'Nov.', 'Nov'=>'Nov.', 'Dezember'=>'Dez.', 'December'=>'Dez.', 'Dez'=>'Dez.', 'Dec'=>'Dez.'
			    }
		  );    #print $monthAbbr{De}->{February};


  my %monthLang = (
		       En=> {
			     January=>'January', 'Januar'=>'January', 'February'=>'February', 'Februar'=>'February', 'March'=>'March', 'M√§rz'=>'March', 'M‰rz'=>'March', 'April'=>'April', 'May'=>'May', 'Mai'=>'May', 'June'=>'June', 'July'=>'July', 'Juli'=>'July', 'August'=>'August', 'September'=>'Septembert', 'October'=>'October', 'Oktober'=>'October', 'November'=>'November', 'December'=>'December', 'Dezember'=>'December', 
			    },
		       De=> {
			     January=>'Januar', 'Januar'=>'Januar', 'February'=>'Februar', 'Februar'=>'Februar', 'March'=>'M√§rz', 'M√§rz'=>'M√§rz', 'M‰rz'=>'M√§rz', 'April'=>'April', 'May'=>'Mai', 'Mai'=>'Mai', 'June'=>'June', 'July'=>'Juli', 'Juli'=>'Juli', 'August'=>'August', 'September'=>'Septembert', 'October'=>'Oktober', 'Oktober'=>'Oktober', 'November'=>'November', 'December'=>'Dezember', 'Dezember'=>'Dezember', 

			    }
		  );    #print $monthLang{De}->{February};


  my $months='([Jj]anuar[y]?|[Jj]an|[Ff]ebruary|[Ff]ebruar|[Ff]eb[r]?|[Mm]ar[c]?[h]?|M√§r[z]?|M‰r[z]?|[Aa]pril|[Aa]pr[l]?|[Mm]a[yi]|[Jj]un[ei]?|[Jj]ul[yi]?|[Aa]ugust|[Aa]ug[s]?|[Ss]eptember|[Ss]ep[t]?|[Oo][ck]tober|[Oo][ck]t|[Nn]ovember|[Nn]ov[m]?|[Dd]e[cz]ember|[Dd]e[zc])'; 


  while($$FileText=~/<bib([^<>]*?)>((?:(?!<bib [^<>]+?>)(?!<[\/]?bib).)*?)<\/bib>/s)
    {
      my $refText=$2;
      #Dissertation|Unpublished|conference
      if($refText=~/$$regx{accessed}([\:\.\,\s]+[oOaA][nmt] |[\:\.\,\s]+)$$regx{dateDay}([\.\,\s]*)$months([\.\,\;\s]+)$$regx{year}/){
	my $month="\u$5";
	if($refText!~/([Dd]issertation|[Uu]npublish[e]?[d]?|[Cc]onference|[Pp]roceeding[s]?)/){
	  if(exists $monthAbbr{$language}->{$month}){
	    $refText=~s/$$regx{accessed}([\:\.\,\s]+[oOaA][nmt] |[\:\.\,\s]+)$$regx{dateDay}([\.\,\s]*)$months([\.\,\;\s]+)$$regx{year}/$1$2$3$4$monthAbbr{$language}->{$month} $7/igs;
	  }
	}
      }
	if($refText=~/$$regx{accessed}([\:\.\,\s]+[oOaA][nmt] |[\:\.\,\s]+)$months([\.\,\;\s]+)$$regx{year}/){
	  my $month="\u$3";
	  if($refText!~/([Dd]issertation|[Uu]npublish[e]?[d]?|[Cc]onference|[Pp]roceeding[s]?)/){
	    if(exists $monthAbbr{$language}->{$month}){
	      $refText=~s/$$regx{accessed}([\:\.\,\s]+[oOaA][nmt] |[\:\.\,\s]+)$months([\.\,\;\s]+)$$regx{year}/$1$2$monthAbbr{$language}->{$month} $5/igs;
	    }
	  }
	}
	# else{
	#   if(exists $monthLang{$language}->{$month}){
	#     $refText=~s/$$regx{accessed}([\:\.\,\s]+[oOaA][nmt] |[\:\.\,\s]+)$$regx{dateDay}([\.\,\s]*)$months([\.\,\;\s]+)$$regx{year}/$1$2$3$4$monthLang{$language}->{$month} $7/igs;
	#   }
	# }
      
      $$FileText=~s/<bib([^<>]*?)>((?:(?!<bib [^<>]+?>)(?!<[\/]?bib).)*?)<\/bib>/<Xbib$1>$refText<\/Xbib>/s;
    }
  $$FileText=~s/<([\/]?)Xbib([^<>]*?)>/<$1bib$2>/gs;

  return $FileText;
}


#=================================================================================
return 1;
