package ReferenceManager::AuthorName_Regex;

use strict;
sub new{
	my %auth_name_regex = (
		'1' => '([A-Z][a-z]+(,\s*|\s*)[A-Z]\.?((\.\s*|\-\s*|\s*)[A-Z](\.\s*|\-\s*|\s*))?)',
		'2' => '([A-Z][a-z]+\-[A-Za-z]+(,\s*|\s*)[A-Z]\.?((\.\s*|\-\s*|\s*)[A-Z](\.\s*|\-\s*|\s*))?)',
		'3' => '([A-Z]([a-z]+)?\'[A-Za-z]+(,\s*|\s*)[A-Z]\.?((\.\s*|\-\s*|\s*)[A-Z](\.\s*|\-\s*|\s*))?)',
		'4' => '([A-Z](\.\s*|\-\s*|\s+)[A-Z](\.\s*|\-\s*|\s+)[A-Z][a-z]+)',
		'5' => '([A-Z]{2}(\.\s*|\,\s*|\s+)[A-Z][a-z]+)'
	);
return %auth_name_regex;
}
1;

=head
Cunningham R. K.,
Cunningham, R. K.,
Cunningham, R.K.,
J. S. Bough, 
Netherley, P., 
D. Cicchetti, 
Alley RB, 
J.S. Bough, 
JS Bough, 
J S Bough, 
Alley, R B, 
Alley R B,
Alley R-B,
Alley, R-B,
Alley, R-B.,
Alley-Bough, R-B,
Alley-Bough, R B,
Alley-Bough, R. B.,
Alley-Bough, R-B.,
Alley-Bough, R.B.,
Alley-Bough, RB,

Alley-Bough R-B,
Alley-Bough R B,
Alley-Bough R. B.,
Alley-Bough R-B.,
Alley-Bough R.B.,
Alley-Bough RB,

D'Souza  R-B,
D'Souza  R B,
D'Souza  R. B.,
D'Souza  R-B.,
D'Souza  R.B.,
D'Souza  RB,

D'Souza,  R-B,
D'Souza,  R B,
D'Souza,  R. B.,
D'Souza,  R-B.,
D'Souza,  R.B.,
D'Souza,  RB,

=cut
