##############################################################################################################################
# Author     : Neyaz Ahmad
#
#
# Version    : v1.1
#
#############################################################################################################################

package EnrichXML;

use BookMetrix::openReturnFileData;

require Exporter;
our @ISA    = qw(Exporter);
our @EXPORT = qw(Enrich_Springer_XML);

sub Enrich_Springer_XML{
    my ($file, $bistructureRef, $bistructureIDRef)=@_;
    my ($springerXML, $boolValue)=&openFile($file);
    $$bistructureRef{"ValidDOICount"}=0;
    foreach my $bibID (@$bistructureIDRef){
	if(exists $$bistructureRef{"$bibID"}{"DOI"})
	{
	    if(exists $$bistructureRef{"$bibID"}{DOISource}){
		if($$bistructureRef{"$bibID"}{"DOISource"} ne "SpringerLink"){
		    $$bistructureRef{"ValidDOICount"}++;
		    #print $$bistructureRef{"$bibID"}{"DOI"}, "\n";
		    if($$springerXML=~/<Citation ID=\"$bibID\">((?:(?!<[\/]?Citation>).)*?)<\/Citation>/s){
			my $refText=$1;
			if($refText=~/\s*<\/(BibArticle|BibChapter|BibBook)>/s){
			    #$refText=~s/(\s*)<\/(BibArticle|BibChapter|BibBook)>/\n<Occurrence Type=\"DOI\">\n<Handle>$$bistructureRef{"$bibID"}{"DOI"}<\/Handle>\n<\/Occurrence>$1<\/$2>/s;
			    if($refText=~/(\s*)<BibComments>((?:(?!<[\/]?BibComments>).)*?)<\/BibComments>(\s*)<\/(BibArticle|BibChapter|BibBook)>/)
			    {
				$refText=~s/(\s*)<BibComments>((?:(?!<[\/]?BibComments>).)*?)<\/BibComments>(\s*)<\/(BibArticle|BibChapter|BibBook)>/\n<Occurrence Type=\"DOI\">\n<Handle>$$bistructureRef{"$bibID"}{"DOI"}<\/Handle>\n<\/Occurrence>$1<BibComments>$2<\/BibComments>$3<\/$4>/s;
			    }else{
			     	$refText=~s/(\s*)<\/(BibArticle|BibChapter|BibBook)>/\n<Occurrence Type=\"DOI\">\n<Handle>$$bistructureRef{"$bibID"}{"DOI"}<\/Handle>\n<\/Occurrence>$1<\/$2>/s;
			    }
			    
			}else{
			    $refText=~s/[\.]?(\s*<\/BibUnstructured>)/\. doi:<ExternalRef><RefSource>$$bistructureRef{"$bibID"}{"DOI"}<\/RefSource><RefTarget Address=\"$$bistructureRef{"$bibID"}{"DOI"}\" TargetType=\"DOI\"\/><\/ExternalRef>.$1/gs;
			}
			$refText=~s/(\.\s*<\/[^<>]+?>)\s*\. doi:/$1 doi:/gs;
			$refText=~s/([\;]\s*)(in press|im Druck)([\.]?) doi:/\. doi:/gis;
			$$springerXML=~s/<Citation ID=\"$bibID\">((?:(?!<[\/]?Citation>).)*?)<\/Citation>/<Citation ID=\"$bibID\">$refText<\/Citation>/s;
		    }
		    
		}#End Second IF
	    }
	}#End First IF
    }#End Foreach

    #print $$springerXML;

    open(OUTFILE, ">", "$file") || die("$file File cannot be writing\n");
    print OUTFILE $$springerXML;
    close(OUTFILE);

    return $bistructureRef; 
}

1;
