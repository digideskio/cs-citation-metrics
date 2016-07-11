#version 1.0.4
#Author: Neyaz Ahmad
package ReferenceManager::RecorededData;
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(AddOriginalData);

#=======================================================================================================================================
sub AddOriginalData
{
    my $MarkupText = shift;
    my $htmfname=shift;

    $htmfname=~s/\.([a-zA-Z0-9]+)$/\-org\.$1/gs;
    $MarkupText=~s/\&lt\;bib((?:(?!\&lt\;bib)(?!\&lt\;\/bib\&gt\;).)*?)\&gt\;/<bib$1>/gs;
    $MarkupText=~s/\&lt\;\/bib\&gt\;/<\/bib>/gs;

    undef $/;
    open(ORGINFILE, "$htmfname")|| die("${htmfname} File cannot be opened\n");
    my $SourceText=<ORGINFILE>;
    close(ORGINFILE);
    unlink $htmfname;

    $SourceText=~s/\&lt\;bib((?:(?!\&lt\;bib)(?!\&lt\;\/bib\&gt\;).)*?)\&gt\;/<bib$1>/gs;
    $SourceText=~s/\&lt\;\/bib\&gt\;/<\/bib>/gs;
    $SourceText=~s/<i><span\s+([^<>]*?)>((?:(?!<[\/]?i>)(?!<\/bib>)(?!<\/span>).)*?)<\/bib><\/span><\/i>/<span $1><i>$2<\/i><\/bib><\/span>/gs;
    $SourceText=~s/<span\s+style=\'background:([a-z]+)\'>((?:(?!<\/bib>)(?!<\/span>).)*?)<\/bib><\/span>/<span style=\'background:$1\'>$2<\/span><\/bib>/gs;
    $SourceText=~s/<span\s+style=\'color:([a-z]+)\'>((?:(?!<[\/]?bib>)(?!<[\/]?span>).)*?)<\/bib><\/span>/<span style=\'color:$1\'>$2<\/span><\/bib>/gs;
    $SourceText=~s/<span\s+style=\'([a-z]+\:[a-z]+)\'>((?:(?!<[\/]?bib>)(?!<span\s+)(?!<\/span>).)*?)<\/bib><\/span>/<span style=\'$1\'>$2<\/span><\/bib>/gs;
    $SourceText=~s/<span\s+style=\'([^<>\']+?)\'>((?:(?!<[\/]?bib>)(?!<bib >)(?!<span\s+)(?!<\/span>).)*?)<\/bib><\/span>/<span style=\'$1\'>$2<\/span><\/bib>/gs;
    $SourceText=~s/<(i|b|u|sup|sub)>([^<>]+?)<\/bib><\/\1>/<$1>$2<\/$1><\/bib>/gs;

    my @OriginalBib=();
    while($SourceText=~/<bib([^<>]*?)>((?:(?!<[\/]?bib).)*?)<\/bib>/s)
      {
	my $bibtext="\&lt\;bib$1\&gt;$2\&lt\;\/bib\&gt\;";
	push(@OriginalBib, $bibtext);
	$SourceText=~s/<bib([^<>]*?)>((?:(?!<[\/]?bib).)*?)<\/bib>/\&lt\;bib$1\&gt;$2\&lt\;\/bib\&gt\;/s;
      }


    my $count=1;
    while($MarkupText=~/<bib([^<>]*?)>((?:(?!<[\/]?bib).)*?)<\/bib>/s)
      {
	my $mbibtext="\&lt\;bib$1\&gt;$2\&lt\;\/bib\&gt\;";
	my $originallink = qq(<orgbib><span class=MsoCommentReference><a style=\'mso-comment-reference:bib_${count}\'><\/a><\!\[if \!supportAnnotations\]><a class=msocomanchor id=\"_anchor_${count}\" onmouseover=\"msoCommentShow(\'_anchor_${count}\',\'_com_${count}\')\" onmouseout=\"msoCommentHide(\'_com_${count}\')\" href=\"#_msocom_${count}\" language=JavaScript name=\"_msoanchor_${count}\"></a><\!\[endif\]></span><\/orgbib>);
	$MarkupText=~s/<bib([^<>]*?)>((?:(?!<[\/]?bib).)*?)<\/bib>/\&lt\;bib$1\&gt;$2\&lt\;\/bib\&gt\;$originallink/s;
	$count++;
      }

    my $footnote="<orgfootnote>\n".q(<div style='mso-element:comment-list'><![if !supportAnnotations]><hr class=msocomoff align=left size=1 width="33%"><![endif]>);
    my $count=1;
    foreach my $OrgBib (@OriginalBib)
      {
	$footnote=$footnote . qq(<div style=\'mso-element:comment\'><\!\[if \!supportAnnotations\]><div id=\"_com_${count}\" class=msocomtxt language=JavaScript onmouseover=\"msoCommentShow\(\'_anchor_${count}\',\'_com_${count}\'\)\" onmouseout=\"msoCommentHide\(\'_com_${count}\'\)\"><\!\[endif\]><span style=\'mso-comment-author: Neyaz\'><\!\[if \!supportAnnotations\]><a name=\"_msocom_${count}\"><\/a><\!\[endif\]><\/span><p>${OrgBib}<\/p><\!\[if \!supportAnnotations\]><\/div><\!\[endif\]><\/div>). "\n";
      }
    $footnote=$footnote."\n<\/orgfootnote>";
    $MarkupText=~s/<\/body>/${footnote}\n<\/body>/gs;

    return $MarkupText;
  }

#============================================================

return 1;

