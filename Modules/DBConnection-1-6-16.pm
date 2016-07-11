############################################################################################################################################################
# Author     : Rahul Wagh
#
# Desciption : This Module will contain the Subroutines to process the Database Related Transactions   
#
# Version    :  v 1.1
#
############################################################################################################################################################


package DBConnection;

BEGIN{
	$VERSION   = '1.1';
	require Exporter;
	@ISA = qw(Exporter);
	@EXPORT = qw( dbConnect 
                  insert_citation_data 
                  check_DOI_exists 
                  Get_DOI_from_DB
                );
}


use DBI;
use GetConfig;
use Data::Dumper;
use DBI qw(:sql_types);

my $CONFIG = get_config();

## This Subroutine will create the connection with database and return the database handler 
sub dbConnect {
	my $dsn          = "DBI".":"."$CONFIG->{'Database.dbtype'}".":"."$CONFIG->{'Database.dbname'}";
	my $db_user_name = "$CONFIG->{'Database.user_name'}";
	my $db_password  = "$CONFIG->{'Database.password'}";

	$dbh = DBI->connect
	    ($dsn, $db_user_name, $db_password, {RaiseError => 1}) || 
	    die("cannot connect to DB: ".DBI::errstr."\n",$dbh);
	
}

## Thsi Subroutin will insert the Data in to the database table "CitationData"
sub insert_citation_data {
	
	#my ($bistructureRef, $DOI, $bibID) = @_;
	
    my ($bistructureRef, $bistructureIDRef) = @_;

#    print Dumper $bistructureRef;

#    print Dumper $bistructureIDRef;

    my $dbh = dbConnect();
    
    print "Database enrich is in proses...\n";
    foreach my $bibID (@$bistructureIDRef){ 
    
        my $bibstructure = $bistructureRef->{$bibID};

        
#        print Dumper $bibstructure;

        if (defined $bibstructure->{'DOI'}) {        
        
            my $id = "";
            
            $id = check_DOI_exists($bibstructure->{'DOI'}); ## Check if DOI already exists in table CitationData
            print "\nDOI exits in Database id = $id , $bibstructure->{'DOI'}\n";
            
            ############## Add  new DOI to database Table  CitationData   ###################
            if (!$id) {
            

                my $time = do {
                                my ($s, $m, $h, $D, $M, $Y)=localtime;
                                $Y+=1900;
                                $M++;
                                "$Y-$M-$D $h:$m:$s" 
                              };

                print "\n $time \n";

            #	bibType, ReceivedDate, DOI, JournalTitle, ArticleTitle, BookTitle, ChapterTitle,  VolumeID,  IssueID , PublisherName , 
            #   PublisherLocation , Pages "FirstPage", Issn ,  Isbn ,  Years "Year",  BibUnstructured ,  Url , out_id

                my $bibType           =  $bibstructure->{'Bibtype'}           if defined $bibstructure->{'Bibtype'}           || "";	
                my $ReceivedDate      =  $time                                if defined $time                                || "";
                my $bibDOI            =  $bibstructure->{'DOI'}               if defined $bibstructure->{'DOI'}               || "";
                my $DOISource         =  $bibstructure->{'DOISource'}         if defined $bibstructure->{'DOISource'}         || "";
                my $JournalTitle      =  $bibstructure->{'JournalTitle'}      if defined $bibstructure->{'JournalTitle'}      || "";
                my $ArticleTitle      =  $bibstructure->{'ArticleTitle'}      if defined $bibstructure->{'ArticleTitle'}      || "";
                my $BookTitle         =  $bibstructure->{'BookTitle'}         if defined $bibstructure->{'BookTitle'}         || "";
                my $ChapterTitle      =  $bibstructure->{'ChapterTitle'}      if defined $bibstructure->{'ChapterTitle'}      || "";
                my $VolumeID          =  $bibstructure->{'VolumeID'}          if defined $bibstructure->{'VolumeID'}          || "";
                my $IssueID           =  $bibstructure->{'IssueID'}           if defined $bibstructure->{'IssueIDs'}          || "";
                my $PublisherName     =  $bibstructure->{'PublisherName'}     if defined $bibstructure->{'PublisherName'}     || "";
                my $PublisherLocation =  $bibstructure->{'PublisherLocation'} if defined $bibstructure->{'PublisherLocation'} || "";
                my $Pages             =  $bibstructure->{'FirstPage'}         if defined $bibstructure->{'FirstPage'}         || "";
                my $Issn              =  $bibstructure->{'Issn'}              if defined $bibstructure->{'Issn'}              || "";
                my $Isbn              =  $bibstructure->{'Isbn'}              if defined $bibstructure->{'Isbn'}              || "";
                my $Year              =  $bibstructure->{'Year'}              if defined $bibstructure->{'Year'}              || "";
                my $BibUnstructured   =  $bibstructure->{'BibUnstructured'}   if defined $bibstructure->{'BibUnstructured'}   || "";
                my $Url               =  $bibstructure->{'Url'}               if defined $bibstructure->{'Url'}               || "";
                my $out_id;
                    

                print "\n \n bibType = $bibType , ReceivedDate = $ReceivedDate, DOI = $bibDOI , DOISource = $DOISource, JournalTitle = $JournalTitle , ArticleTitle = $ArticleTitle, BookTitle= $BookTitle\n\n";
                print "\n \n ChapterTitle = $ChapterTitle , VolumeID = $VolumeID, IssueID = $IssueID , PublisherName = $PublisherName , Pages = $Pages, Issn= $Issn\n\n"; 
                print "\n \n Isbn = $Isbn , Year = $Year, BibUnstructured = $BibUnstructured , Url = $Url \n\n";
                
                        
                
    #            my $dbh = dbConnect();


                my $sth = $dbh->prepare("call Insert_New_Citation_Record(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, \@out_id)") ||
                        die "Can't prepare SQL statement: $DBI::errstr\n";
                $sth->bind_param("1",  $bibType);
                $sth->bind_param("2",  $ReceivedDate);
                $sth->bind_param("3",  $bibDOI);
                $sth->bind_param("4",  $DOISource);
                $sth->bind_param("5",  $JournalTitle);
                $sth->bind_param("6",  $ArticleTitle);
                $sth->bind_param("7",  $BookTitle);
                $sth->bind_param("8",  $ChapterTitle);
                $sth->bind_param("9",  $VolumeID);
                $sth->bind_param("10",  $IssueID);
                $sth->bind_param("11", $PublisherName);
                $sth->bind_param("12", $PublisherLocation);
                $sth->bind_param("13", $Pages);
                $sth->bind_param("14", $Issn);
                $sth->bind_param("15", $Isbn);
                $sth->bind_param("16", $Year);
                $sth->bind_param("17", $BibUnstructured);
                $sth->bind_param("18", $Url);
                #$sth->bind_param_inout("18",\$out_id,25, {TYPE=>SQL_INTEGER}) or die $sth->errstr;

                $sth->execute() or die "Can't execute SQL statement: $DBI::errstr\n";
                
                my $record_id = $dbh->selectrow_array('SELECT @out_id');
                print "\n New DOI $bibDOI ,  Citation data record added RecID = $record_id\n";

                
                ############## Add  Related Authors to table AutherDetails   ###################
                if (defined $bibstructure->{'Author_FamilyName_1'}) {	
                
                    my @authores = grep(/Author_FamilyName/,keys{%$bibstructure});
                    #print "\n\n -------\n\n";
                    #print Dumper sort(@authores);
                    
                    my $i = 1;
                    foreach my $auth (sort @authores) {				

                        my $Author_Initials   = $bibstructure->{"Author_Initials_"."$i"}    if defined $bibstructure->{"Author_Initials_"."$i"} || "";
                        my $Author_FamilyName = $bibstructure->{"Author_FamilyName_"."$i"}  if defined $bibstructure->{"Author_Initials_"."$i"} || "";
                        my $AuthorFullName    = "$Author_FamilyName"." "."$Author_Initials";
                        
                        $Author_Initials   =~ s/^\s+|\s+$//g;
                        $Author_FamilyName =~ s/^\s+|\s+$//g;
                        $AuthorFullName    =~ s/^\s+|\s+$//g;
                        
                        print "\n Author_Initials_$i = $bibstructure->{Author_Initials_.\"$i\"}";
                        print "\n\n $Author_Initials ,  $Author_FamilyName,   $AuthorFullName\n\n";
                        
                        $i++;

                        my $sth = $dbh->prepare("call Insert_Author_for_Citation_Record(?, ?, ?, ?,\@out_id)");
                        $sth->bind_param("1",  $record_id);
                        $sth->bind_param("2",  $Author_Initials);
                        $sth->bind_param("3",  $Author_FamilyName);
                        $sth->bind_param("4",  $AuthorFullName);
                        
                        $sth->execute();

                        my $rec_id = $dbh->selectrow_array('SELECT @out_id');
                        print "Author data record added for citation record = $record_id , Auth RecID = $rec_id\n";

                    }
                }      
           
            }
        }
    } 
    $dbh->disconnect or warn "Failed to disconnect: ", $dbh->errstr(), "\n";
}


sub Get_DOI_from_DB {

    my ($bistructureRef, $bibID) = @_;

    #print Dumper $bistructureRef->{"$bibID"};
   
    my $search_condition;

    if(exists $bistructureRef->{"$bibID"}{"Author_FamilyName_1"}){
       $search_condition = "and b.authorfullname like \"%$bistructureRef->{\"$bibID\"}{'Author_FamilyName_1'}%\"";
    }

    if(exists $bistructureRef->{"$bibID"}{"JournalTitle"}){
        $search_condition .= "and a.JournalTitle = \"$bistructureRef->{\"$bibID\"}{'JournalTitle'}\"";
    }

    if(exists $bistructureRef->{"$bibID"}{"BookTitle"}){
        $search_condition .= " and a.BookTitle = \"$bistructureRef->{\"$bibID\"}{'BookTitle'}\"";
    }

    if(exists $bistructureRef->{"$bibID"}{"ArticleTitle"}){
        $search_condition .= " and a.ArticleTitle = \"$bistructureRef->{\"$bibID\"}{'ArticleTitle'}\"";
    }

    if(exists $bistructureRef->{"$bibID"}{"ChapterTitle"}){
        $search_condition .= " and a.ChapterTitle = \"$bistructureRef->{\"$bibID\"}{'ChapterTitle'}\"";
    }

#    print "\n search_condition=  $search_condition \n";

    my $sql = "SELECT a.id, a.doi, a.doisource FROM CitationData a, AutherDetails b WHERE a.id = b.CitationDataID $search_condition";

#    print "\n\n SQL query = $sql \n\n ";

    my $dbh = dbConnect();
    
	my $sth = $dbh->prepare($sql) or die "Can't prepare SQL statement: ", $dbh->errstr(), "\n";
	
    $sth->execute() or die "Can't execute SQL statement: ", $sth->errstr(), "\n";
	
    my $rows_found = $sth->rows;
    print "\nNumber of rows found In Database : $rows_found \n"; 

    my ($id, $doi );
    if ($rows_found == 1){ 
        while (my @row = $sth->fetchrow()) {
           ($id, $doi, $doisource ) = @row;
           print "id = $id, DOI = $doi, doisource = $doisource\n";
        }
        print "\n\n DOI found in Database  : $doi \n";
        $bistructureRef->{"$bibID"}{"DOI"}       = $doi;
        $bistructureRef->{"$bibID"}{"DOISource"} = $doisource;
    }
    
    $sth->finish;	
	$dbh->disconnect  or warn "Failed to disconnect: ", $dbh->errstr(), "\n";

    return ($bistructureRef, $doi);

#elsif(exists $$bistructureRef{"$bibID"}{"BookTitle"}){
#        $search_type="books";
#        $BookJournalTitle=$$bistructureRef{"$bibID"}{"BookTitle"};
#    }
#    if(exists $$bistructureRef{"$bibID"}{"ArticleTitle"}){
#        $search_type="journal";
#        $articleChapterTitle=$$bistructureRef{"$bibID"}{"ArticleTitle"};
#    }elsif(exists $$bistructureRef{"$bibID"}{"chaptertitle"}){
#        $search_type="books";
#        $articleChapterTitle=$$bistructureRef{"$bibID"}{"ChapterTitle"};
#    }
#    if(exists $$bistructureRef{"$bibID"}{"Author_FamilyName_1"}){
#        $Author=$$bistructureRef{"$bibID"}{"Author_FamilyName_1"};
#    }elsif(exists $$bistructureRef{"$bibID"}{"Editor_FamilyName_1"}){
#        $Author=$$bistructureRef{"$bibID"}{"Editor_FamilyName_1"};
#    }
#    if(exists $$bistructureRef{"$bibID"}{"Editor_FamilyName_1"}){
#        $Editor=$$bistructureRef{"$bibID"}{"Editor_FamilyName_1"};
#    }


}

## Thsi Subroutin will check if DOI already exists in table "CitationData" before adding new DOI
sub check_DOI_exists {
	
	my ($DOI) = @_;
	
	my $dbh = dbConnect();

	my $sql = 'CALL Check_DOI_Exists(?, @id)';
	my $sth = $dbh->prepare($sql) or die "Can't prepare SQL statement: ", $dbh->errstr(), "\n";
	$sth->execute($DOI) or die "Can't execute SQL statement: ", $sth->errstr(), "\n";
	$sth->finish;
	
	my $id = "";
	$id = $dbh->selectrow_array('SELECT @id');
	$dbh->disconnect  or warn "Failed to disconnect: ", $dbh->errstr(), "\n";

return $id;
}

1;
