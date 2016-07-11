###Author Pravin Pardeshi
package ReferenceManager::DeleteMultipleLocation;

use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(delete_location);

sub delete_location {
	my ($TextBody,$SCRITPATH) = @_;
	################  Remove multiple locations if single author by Pravin P. ################
	my $state_cd_list;
=head
	#use Spreadsheet::Read;
	my $workbook = ReadData($SCRITPATH.'\StateCodes.xlsx');
	die "Couldn't read Excel file StateCodes.xlsx: $!.\n" unless defined $workbook;
	for my $col("A" .. "H") {
		next if($col !~ m![B|E|H]!);
		for(my $row=1; $row<=70; $row++) {
			my $add = $col.$row;
			next if($workbook->[1]{$add} =~ m!Abbreviation!is || $workbook->[1]{$add} =~ m!^$!is);
			$state_cd_list .= '~' . $workbook->[1]{$add};
		}
	}
=cut
	my (@refs) = $TextBody =~ m!(<bib.*?<\/bib>)!isg;
	foreach my $ref(@refs) {
		#print "REF ",$ref,"\n\n";next;
		my $original = $ref;
		next if($ref =~ m!\Q.*<\/aug>.*(proceedings|conference|paper\s+presentation|paper\s+presented|dissertation)\E!i);
		next if($STYLEvalue eq 'none');
		#print $ref,"\n\n";next;
		next if($ref =~ m!\&lt\;pbl\&gt\;.*\&lt\;pbl!i);	###Escaping for multiple publishers
		my ($city) = $ref =~ m!\&lt\;cny\&gt\;(.*)&lt;\/cny&gt;!is;
		my $original_city = $city;
		$city =~ s!(^.*?,.*?),.*!$1!s;
		my ($state_cd) = $city =~ m!,\s*(.*)!is;
		$state_cd =~ s!\s+!!g;
		next if($state_cd =~ m!D\.?C\.?!s && $city =~ m!Washington!i);
		if($state_cd) {
			my $return = $state_cd_list{$state_cd};
			#print "\nCITY $state_cd => $return";
			if($return) {
				$ref =~ s!\Q$original_city\E!$city!s;
				$TextBody =~ s!\Q$original\E!$ref!s;
			}
			else {
				$city =~ s!,.*!!is;
				$ref =~ s!\Q$original_city\E!$city!s;
				$TextBody =~ s!\Q$original\E!$ref!s;
			}
		#print $ref,"\n\n";
		}
		#print $ref,"\n\n";
	}
	#print "\n\n$TextBody\nIm hrerererer"; exit;
	return $TextBody;
###END
}

	our %state_cd_list = (
		"AL"  =>  "Alabama",
		"AK"  =>  "Alaska",
		"AZ"  =>  "Arizona",
		"AR"  =>  "Arkansas",
		"CA"  =>  "California",
		"CO"  =>  "Colorado",
		"CT"  =>  "Connecticut",
		"DE"  =>  "Delaware",
		"FL"  =>  "Florida",
		"GA"  =>  "Georgia",
		"HI"  =>  "Hawaii",
		"ID"  =>  "Idaho",
		"IL"  =>  "Illinois",
		"IN"  =>  "Indiana",
		"IA"  =>  "Iowa",
		"KS"  =>  "Kansas",
		"KY"  =>  "Kentucky",
		"LA"  =>  "Louisiana",
		"ME"  =>  "Maine",
		"MD"  =>  "Maryland",
		"MA"  =>  "Massachusetts",
		"MI"  =>  "Michigan",
		"MN"  =>  "Minnesota",
		"MS"  =>  "Mississippi",
		"MO"  =>  "Missouri",
		"MT"  =>  "Montana",
		"NE"  =>  "Nebraska",
		"NV"  =>  "Nevada",
		"NH"  =>  "New Hampshire",
		"NJ"  =>  "New Jersey",
		"NM"  =>  "New Mexico",
		"NY"  =>  "New York",
		"NC"  =>  "North Carolina",
		"ND"  =>  "North Dakota",
		"OH"  =>  "Ohio",
		"OK"  =>  "Oklahoma",
		"OR"  =>  "Oregon",
		"PA"  =>  "Pennsylvania",
		"RI"  =>  "Rhode Island",
		"SC"  =>  "South Carolina",
		"SD"  =>  "South Dakota",
		"TN"  =>  "Tennessee",
		"TX"  =>  "Texas",
		"UT"  =>  "Utah",
		"VT"  =>  "Vermont",
		"VA"  =>  "Virginia",
		"WA"  =>  "Washington",
		"WV"  =>  "West Virginia",
		"WI"  =>  "Wisconsin",
		"WY"  =>  "Wyoming",
		"AS"  =>  "American Samoa",
		"DC"  =>  "District of Columbia",
		"FM"  =>  "Federated States of Micronesia",
		"GU"  =>  "Guam",
		"MH"  =>  "Marshall Islands",
		"MP"  =>  "Northern Mariana Islands",
		"PW"  =>  "Palau",
		"PR"  =>  "Puerto Rico",
		"VI"  =>  "Virgin Islands",
		"AE"  =>  "Armed Forces Africa",
		"AA"  =>  "Armed Forces Americas",
		"AE"  =>  "Armed Forces Canada",
		"AE"  =>  "Armed Forces Europe",
		"AE"  =>  "Armed Forces Middle East",
		"AP"  =>  "Armed Forces Pacific",
		"AB"  =>  "Alberta",
		"BC"  =>  "British Columbia",
		"MB"  =>  "Manitoba",
		"NB"  =>  "New Brunswick",
		"NL"  =>  "Newfoundland and Labrador",
		"NT"  =>  "Northwest Territories",
		"NS"  =>  "Nova Scotia",
		"NU"  =>  "Nunavut",
		"ON"  =>  "Ontario",
		"PE"  =>  "Prince Edward Island",
		"QC"  =>  "Quebec",
		"SK"  =>  "Saskatchewan",
		"YT"  =>  "Yukon",
		"ACT"  =>  "Australian Capital Territory",
		"NSW"  =>  "New South Wales",
		"NT"  =>  "Northern Territory",
		"QLD"  =>  "Queensland",
		"SA"  =>  "South Australia",
		"TAS"  =>  "Tasmania",
		"VIC"  =>  "Victoria",
		"WA"  =>  "Western Australia",
	);