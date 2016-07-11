#version 1.0
#Author: Neyaz Ahmad
package ReferenceManager::PublisherLocationDB;
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(SortedPublisherLocationDB);

our $PublisherLocationText=qq(<PublisherLocation>Institute for Operations Research and the Management Sciences (INFORMS), Linthicum, Maryland, USA</PublisherLocation>
<PublisherLocation>Berlin/Heidelberg/New York/London/Paris/Tokyo/Hong Kong/Barcelona/Budapest</PublisherLocation>
<PublisherLocation>Berlin/Heidelberg/New York/London/Paris/Tokyo/Hong Kong/Barcelona</PublisherLocation>
<PublisherLocation>Schlo√ü Birlinghoven, Postfach 1240, D-5205 St. Augustin 1</PublisherLocation>
<PublisherLocation>Berlin/Heidelberg/New York/London/Paris/Tokyo/Hong Kong</PublisherLocation>
<PublisherLocation>IBM Deutschland GmbH, Heidelberg Scientific Center</PublisherLocation>
<PublisherLocation>Campus de Beaulieu, F-35042 Rennes Cedex, France</PublisherLocation>
<PublisherLocation>Postfach 3049, D-6750 Kaiserslautern 1, Germany</PublisherLocation>
<PublisherLocation>Alexanderstra√üe 10, D-64283 Darmstadt, Germany</PublisherLocation>
<PublisherLocation>Berlin/Heidelberg/New York/London/Paris/Tokyo</PublisherLocation>
<PublisherLocation>G.I.A., Parc Scientifique et Technologique de</PublisherLocation>
<PublisherLocation>Am R√§merhof 35, 6000 FrankfurtKrakow Pologne</PublisherLocation>
<PublisherLocation>South Georgia and the South Sandwich Islands</PublisherLocation>
<PublisherLocation>Geneva, SWITZERLAND</PublisherLocation>
<PublisherLocation>Am R‰merhof 35, 6000 FrankfurtKrakow Pologne</PublisherLocation>
<PublisherLocation>Universit√§t Karlsruhe, Institut f√ºr Logik</PublisherLocation>
<PublisherLocation>Amsterdam, The Netherlands, The Netherlands</PublisherLocation>
<PublisherLocation>46, Avenue FÈlix Viallet, F-38031 Grenoble</PublisherLocation>
<PublisherLocation>New York, NY, USACambridge, Massachusetts</PublisherLocation>
<PublisherLocation>Universit‰t Karlsruhe, Institut f¸r Logik</PublisherLocation>
<PublisherLocation>The Former Yugoslav Republic of Macedonia</PublisherLocation>
<PublisherLocation>Lanham/Boulder/New York/Toronto/Plymouth</PublisherLocation>
<PublisherLocation>New Jersey-London-Singapore-Hong Kong</PublisherLocation>
<PublisherLocation>Democratic People's Republic of Korea</PublisherLocation>
<PublisherLocation>Democratic Peopleís Republic of Korea</PublisherLocation>
<PublisherLocation>The Democratic Republic of the Zaire</PublisherLocation>
<PublisherLocation>United States Minor Outlying Islands</PublisherLocation>
<PublisherLocation>The Democratic Republic of the Congo</PublisherLocation>
<PublisherLocation>Cambridge, MA, USANew York, NY, USA</PublisherLocation>
<PublisherLocation>New York, NY, USABerlin, Heidelberg</PublisherLocation>
<PublisherLocation>Cambridge, Massachusetts, & London</PublisherLocation>
<PublisherLocation>New York, NY, USAMontrÈalDordrecht</PublisherLocation>
<PublisherLocation>Charleston, South Carolina (2009)</PublisherLocation>
<PublisherLocation>New yorkNew YorkNew York, NY, USA</PublisherLocation>
<PublisherLocation>Postfach 6380, D-7500 Karlsruhe 1</PublisherLocation>
<PublisherLocation>Universit√§t Z√ºrich, Switzerland</PublisherLocation>
<PublisherLocation>Ein Handbuch, Reinbek bei Hamburg</PublisherLocation>
<PublisherLocation>Heard Island and McDonald Islands</PublisherLocation>
<PublisherLocation>University of Gottingen, Germany</PublisherLocation>
<PublisherLocation>Lao Peopleís Democratic Republic</PublisherLocation>
<PublisherLocation>Houndmills Basingstoke Hampshire</PublisherLocation>
<PublisherLocation>Saint Vincent and the Grenadines</PublisherLocation>
<PublisherLocation>Lao People's Democratic Republic</PublisherLocation>
<PublisherLocation>Universit‰t Z¸rich, Switzerland</PublisherLocation>
<PublisherLocation>University of Roskilde, Denmark</PublisherLocation>
<PublisherLocation>New York, NY, USAUnited Kingdom</PublisherLocation>
<PublisherLocation>DK-2800 Kongens Lyngby, Denmark</PublisherLocation>
<PublisherLocation>British Indian Ocean Territory</PublisherLocation>
<PublisherLocation>Federated States of Micronesia</PublisherLocation>
<PublisherLocation>Frankfurt a.M./ New York/ Bern</PublisherLocation>
<PublisherLocation>American Marketing Association</PublisherLocation>
<PublisherLocation>Technische Universit√§t Berlin</PublisherLocation>
<PublisherLocation>M√°laga, SpainLos Angeles, USA</PublisherLocation>
<PublisherLocation>M·laga, SpainLos Angeles, USA</PublisherLocation>
<PublisherLocation>Sunderland, Massachusetts, USA</PublisherLocation>
<PublisherLocation>Frankfurt am Main und New York</PublisherLocation>
<PublisherLocation>Technische Universit‰t Berlin</PublisherLocation>
<PublisherLocation>Vancouver, BC, Canada V6T 1W5</PublisherLocation>
<PublisherLocation>Singapore--New Jersey--London</PublisherLocation>
<PublisherLocation>Frankfurt a. M. und New York</PublisherLocation>
<PublisherLocation>Opladen und Farmington Hills</PublisherLocation>
<PublisherLocation>M√ºnchen, Wien und Baltimore</PublisherLocation>
<PublisherLocation>Dordrecht, Boston and London</PublisherLocation>
<PublisherLocation>Helmholtzstr. 16, D-7900 Ulm</PublisherLocation>
<PublisherLocation>Sivananda Ashram, Rishikesh</PublisherLocation>
<PublisherLocation>Theorie, Methode, Anwendung</PublisherLocation>
<PublisherLocation>French Southern Territories</PublisherLocation>
<PublisherLocation>Falkland (Malvinas) Islands</PublisherLocation>
<PublisherLocation>New York and Washington, DC</PublisherLocation>
<PublisherLocation>M¸nchen, Wien und Baltimore</PublisherLocation>
<PublisherLocation>Norwell, Massachusetts, USA</PublisherLocation>
<PublisherLocation>Washington D.C/ Bloomington</PublisherLocation>
<PublisherLocation>Neuwied und Frankfurt a. M.</PublisherLocation>
<PublisherLocation>United Republic of Tanzania</PublisherLocation>
<PublisherLocation>Opladen und Farmington Hill</PublisherLocation>
<PublisherLocation>Newbury Parc and California</PublisherLocation>
<PublisherLocation>Heidelberg New York London</PublisherLocation>
<PublisherLocation>Thousands Oaks, California</PublisherLocation>
<PublisherLocation>Dortmund und Gelsenkirchen</PublisherLocation>
<PublisherLocation>Landesinstitut f√ºr Schule</PublisherLocation>
<PublisherLocation>Berlin/Heidelberg/New York</PublisherLocation>
<PublisherLocation>San Diego, California, USA</PublisherLocation>
<PublisherLocation>Friedrich-Ebert-Foundation</PublisherLocation>
<PublisherLocation>Dordrecht/Providence, R.I.</PublisherLocation>
<PublisherLocation>Algorithmic Solutions GmbH</PublisherLocation>
<PublisherLocation>Cheltenham and Northampton</PublisherLocation>
<PublisherLocation>Heidelberg, Berlin, Oxford</PublisherLocation>
<PublisherLocation>Berlin Heidelberg New York</PublisherLocation>
<PublisherLocation>Eine Einf√ºhrung, Opladen</PublisherLocation>
<PublisherLocation>Cambridge, United Kingdom</PublisherLocation>
<PublisherLocation>Landesinstitut f¸r Schule</PublisherLocation>
<PublisherLocation>Saint Pierre and Miquelon</PublisherLocation>
<PublisherLocation>Moscow Aviation Institute</PublisherLocation>
<PublisherLocation>Frankf√ºrt a.M., New York</PublisherLocation>
<PublisherLocation>Opladen, Farmington Hills</PublisherLocation>
<PublisherLocation>Waterloo, Ontario, Canada</PublisherLocation>
<PublisherLocation>Edmonton, Alberta, Canada</PublisherLocation>
<PublisherLocation>Enschede; the Netherlands</PublisherLocation>
<PublisherLocation>Weinheim ; Basel ; Berlin</PublisherLocation>
<PublisherLocation>Enschede, the Netherlands</PublisherLocation>
<PublisherLocation>Bloomington/Indianapolis</PublisherLocation>
<PublisherLocation>Boca Raton, Florida, USA</PublisherLocation>
<PublisherLocation>United States, Wisconsin</PublisherLocation>
<PublisherLocation>Central African Republic</PublisherLocation>
<PublisherLocation>Frankfurt a.M., New York</PublisherLocation>
<PublisherLocation>Virgin Islands (British)</PublisherLocation>
<PublisherLocation>New Brunswick, NJ/London</PublisherLocation>
<PublisherLocation>Cambridge, Massachusetts</PublisherLocation>
<PublisherLocation>Turks and Caicos Islands</PublisherLocation>
<PublisherLocation>Islamic Republic of Iran</PublisherLocation>
<PublisherLocation>United States of America</PublisherLocation>
<PublisherLocation>Eine Einf¸hrung, Opladen</PublisherLocation>
<PublisherLocation>Northern Mariana Islands</PublisherLocation>
<PublisherLocation>Cocos (Keeling) Islands</PublisherLocation>
<PublisherLocation>Boston - Basel - Berlin</PublisherLocation>
<PublisherLocation>Kyoto, Japan. Amsterdam</PublisherLocation>
<PublisherLocation>Cambridge Massachusetts</PublisherLocation>
<PublisherLocation>Heidelberg and New York</PublisherLocation>
<PublisherLocation>Cold Spring Harbor, N.Y</PublisherLocation>
<PublisherLocation>United State of America</PublisherLocation>
<PublisherLocation>Frankfurt a.M./New York</PublisherLocation>
<PublisherLocation>New Mexico</PublisherLocation>
<PublisherLocation>Maidenhead, UK, England</PublisherLocation>
<PublisherLocation>London and Philadelphia</PublisherLocation>
<PublisherLocation>01062 Dresden</PublisherLocation>
<PublisherLocation>Basingstoke, Hampshire</PublisherLocation>
<PublisherLocation>Amsterdam/Philadelphia</PublisherLocation>
<PublisherLocation>Cambridge and New York</PublisherLocation>
<PublisherLocation>Menlo Park, California</PublisherLocation>
<PublisherLocation>San Jose, CADenver, CO</PublisherLocation>
<PublisherLocation>Universit√§t Karlsruhe</PublisherLocation>
<PublisherLocation>Vysok‡ Tatry, Slovakia</PublisherLocation>
<PublisherLocation>Svalbard and Jan Mayen</PublisherLocation>
<PublisherLocation>Braunschweig/Wiesbaden</PublisherLocation>
<PublisherLocation>Englewood Cliff,s N.J.</PublisherLocation>
<PublisherLocation>San Francisco, CA, USA</PublisherLocation>
<PublisherLocation>Bosnia and Herzegovina</PublisherLocation>
<PublisherLocation>Bern, Stuttgart & Wien</PublisherLocation>
<PublisherLocation>The Hague, Netherlands</PublisherLocation>
<PublisherLocation>Libyan Arab Jamahiriya</PublisherLocation>
<PublisherLocation>Neuwied/Kriftel/Berlin</PublisherLocation>
<PublisherLocation>Berling and Heidelberg</PublisherLocation>
<PublisherLocation>G√∂ttingen und Z√ºrich</PublisherLocation>
<PublisherLocation>College Station, Tex.</PublisherLocation>
<PublisherLocation>Vandenhoek & Ruprecht</PublisherLocation>
<PublisherLocation>D√ºsseldorf, M√ºnchen</PublisherLocation>
<PublisherLocation>Ithaca, New York, USA</PublisherLocation>
<PublisherLocation>Palo Alto, California</PublisherLocation>
<PublisherLocation>Universit√§t Mannheim</PublisherLocation>
<PublisherLocation>Oxford and Nueva York</PublisherLocation>
<PublisherLocation>Weinheim und M√ºnchen</PublisherLocation>
<PublisherLocation>San Diego, CA, U.S.A.</PublisherLocation>
<PublisherLocation>Serbia and Montenegro</PublisherLocation>
<PublisherLocation>Frankfurt am Main u.a</PublisherLocation>
<PublisherLocation>Bern, Stuttgart, Wien</PublisherLocation>
<PublisherLocation>Freiburg und M√ºnchen</PublisherLocation>
<PublisherLocation>Saint Kitts and Nevis</PublisherLocation>
<PublisherLocation>San Juan, Puerto Rico</PublisherLocation>
<PublisherLocation>Newbury Park, CA, USA</PublisherLocation>
<PublisherLocation>Dordrecht Netherlands</PublisherLocation>
<PublisherLocation>Washington and London</PublisherLocation>
<PublisherLocation>Doubleday Garden City</PublisherLocation>
<PublisherLocation>Washington, DC/Oxford</PublisherLocation>
<PublisherLocation>Sao Tome and Principe</PublisherLocation>
<PublisherLocation>Denver, Colorado, USA</PublisherLocation>
<PublisherLocation>Washington, DC, U.S.A</PublisherLocation>
<PublisherLocation>Singapore--New Jersey</PublisherLocation>
<PublisherLocation>Philadelphia, PA, USA</PublisherLocation>
<PublisherLocation>Princeton and Oxford</PublisherLocation>
<PublisherLocation>Weinheim u. M√ºnchen</PublisherLocation>
<PublisherLocation>Ludwigshafen (Rhein)</PublisherLocation>
<PublisherLocation>Clausthal-Zellerfeld</PublisherLocation>
<PublisherLocation>Farmington Hills, MI</PublisherLocation>
<PublisherLocation>Syrian Arab Republic</PublisherLocation>
<PublisherLocation>Berkeley/Los Angeles</PublisherLocation>
<PublisherLocation>Berlin u. Heidelberg</PublisherLocation>
<PublisherLocation>Netherlands Antilles</PublisherLocation>
<PublisherLocation>Cambridge and London</PublisherLocation>
<PublisherLocation>Weinheim und M¸nchen</PublisherLocation>
<PublisherLocation>Swansea, Wales, U.K.</PublisherLocation>
<PublisherLocation>Regionalverband Ruhr</PublisherLocation>
<PublisherLocation>United Arab Emirates</PublisherLocation>
<PublisherLocation>Reinbeck bei Hamburg</PublisherLocation>
<PublisherLocation>Tulsa, Oklahoma, USA</PublisherLocation>
<PublisherLocation>Freiburg im Breisgau</PublisherLocation>
<PublisherLocation>Stanford, California</PublisherLocation>
<PublisherLocation>Universit‰t Mannheim</PublisherLocation>
<PublisherLocation>Gˆttingen und Z¸rich</PublisherLocation>
<PublisherLocation>Freiburg und M¸nchen</PublisherLocation>
<PublisherLocation>Baltimore, MD/London</PublisherLocation>
<PublisherLocation>White River Junction</PublisherLocation>
<PublisherLocation>London; New York, NY</PublisherLocation>
<PublisherLocation>Woodbridge/Rochester</PublisherLocation>
<PublisherLocation>London/New York, NY</PublisherLocation>
<PublisherLocation>London and New York</PublisherLocation>
<PublisherLocation>Los Angeles, London</PublisherLocation>
<PublisherLocation>Bochum und Dortmund</PublisherLocation>
<PublisherLocation>Berlin / Heidelberg</PublisherLocation>
<PublisherLocation>Atlanta - GA, U.S.A</PublisherLocation>
<PublisherLocation>Cambridge; New York</PublisherLocation>
<PublisherLocation>Weinheim & M√ºnchen</PublisherLocation>
<PublisherLocation>Menlo Park, CA, USA</PublisherLocation>
<PublisherLocation>New York and London</PublisherLocation>
<PublisherLocation>New York and Geneva</PublisherLocation>
<PublisherLocation>Trinidad and Tobago</PublisherLocation>
<PublisherLocation>University of Texas</PublisherLocation>
<PublisherLocation>Washington, DC, USA</PublisherLocation>
<PublisherLocation>St. Paul, Minnesota</PublisherLocation>
<PublisherLocation>Bonn, Bad Godesberg</PublisherLocation>
<PublisherLocation>Heidelberg New York</PublisherLocation>
<PublisherLocation>Anwendung Wiesbaden</PublisherLocation>
<PublisherLocation>Frankf√ºrt/New York</PublisherLocation>
<PublisherLocation>London und New York</PublisherLocation>
<PublisherLocation>Montreal & Kingston</PublisherLocation>
<PublisherLocation>Antigua and Barbuda</PublisherLocation>
<PublisherLocation>Neuwied und Kriftel</PublisherLocation>
<PublisherLocation>Virgin Islands (US)</PublisherLocation>
<PublisherLocation>Oxford and New York</PublisherLocation>
<PublisherLocation>Republic of Moldova</PublisherLocation>
<PublisherLocation>D¸sseldorf, M¸nchen</PublisherLocation>
<PublisherLocation>Heidelberg & Berlin</PublisherLocation>
<PublisherLocation>Reinbek bei Hamburg</PublisherLocation>
<PublisherLocation>Weinheim u. M¸nchen</PublisherLocation>
<PublisherLocation>Alexandria, VA, USA</PublisherLocation>
<PublisherLocation>Thousand Oaks (CA)</PublisherLocation>
<PublisherLocation>T√ºbingen, Germany</PublisherLocation>
<PublisherLocation>Seattle and London</PublisherLocation>
<PublisherLocation>Weinheim und Basel</PublisherLocation>
<PublisherLocation>The Hague/Brussels</PublisherLocation>
<PublisherLocation>Urbana and Chicago</PublisherLocation>
<PublisherLocation>Russian Federation</PublisherLocation>
<PublisherLocation>Frankf√ºrt am Main</PublisherLocation>
<PublisherLocation>Dominican Republic</PublisherLocation>
<PublisherLocation>Anchorage</PublisherLocation>
<PublisherLocation>M¸nchen, Don Mills</PublisherLocation>
<PublisherLocation>Washington, DC, US</PublisherLocation>
<PublisherLocation>New York, New York</PublisherLocation>
<PublisherLocation>Weinheim & M¸nchen</PublisherLocation>
<PublisherLocation>Berlin, Heidelberg</PublisherLocation>
<PublisherLocation>Cornell University</PublisherLocation>
<PublisherLocation>Cambridge, MA, USA</PublisherLocation>
<PublisherLocation>San Diego, CA, USA</PublisherLocation>
<PublisherLocation>M√ºnchen und Basel</PublisherLocation>
<PublisherLocation>Weinheim, M√ºnchen</PublisherLocation>
<PublisherLocation>Neuwied/ Darmstadt</PublisherLocation>
<PublisherLocation>New York u. London</PublisherLocation>
<PublisherLocation>Chicago und London</PublisherLocation>
<PublisherLocation>Weinheim. M√ºnchen</PublisherLocation>
<PublisherLocation>London - Amsterdam</PublisherLocation>
<PublisherLocation>Tarrytown, NY, USA</PublisherLocation>
<PublisherLocation>Weinheim/ M√ºnchen</PublisherLocation>
<PublisherLocation>Cold Spring Harbor</PublisherLocation>
<PublisherLocation>Upper Saddle River</PublisherLocation>
<PublisherLocation>Schwalbach, Taunus</PublisherLocation>
<PublisherLocation>Manhattan, KS, USA</PublisherLocation>
<PublisherLocation>Vatican City State</PublisherLocation>
<PublisherLocation>Chicago and London</PublisherLocation>
<PublisherLocation>Republic of Korea</PublisherLocation>
<PublisherLocation>Weinheim. M¸nchen</PublisherLocation>
<PublisherLocation>Saint-Malo France</PublisherLocation>
<PublisherLocation>Republic of China</PublisherLocation>
<PublisherLocation>Erlangen und Jena</PublisherLocation>
<PublisherLocation>Santiago de Chile</PublisherLocation>
<PublisherLocation>London & New York</PublisherLocation>
<PublisherLocation>Berlin/Heidelberg</PublisherLocation>
<PublisherLocation>Wien (÷sterreich)</PublisherLocation>
<PublisherLocation>Weinheim/M√ºnchen</PublisherLocation>
<PublisherLocation>Brunei Darussalam</PublisherLocation>
<PublisherLocation>Wallis and Futuna</PublisherLocation>
<PublisherLocation>Newbury Park (CA)</PublisherLocation>
<PublisherLocation>Windsor, Bershire</PublisherLocation>
<PublisherLocation>Neuwied/Darmstadt</PublisherLocation>
<PublisherLocation>Frankfurt am Main</PublisherLocation>
<PublisherLocation>M√ºnchen, Z√ºrich</PublisherLocation>
<PublisherLocation>Equatorial Guinea</PublisherLocation>
<PublisherLocation>Berlin-Heidelberg</PublisherLocation>
<PublisherLocation>Durham and London</PublisherLocation>
<PublisherLocation>New Haven/ London</PublisherLocation>
<PublisherLocation>Berlin Heidelberg</PublisherLocation>
<PublisherLocation>Neuwied & Kriftel</PublisherLocation>
<PublisherLocation>Secaucus, NJ, USA</PublisherLocation>
<PublisherLocation>Lengerich/ Berlin</PublisherLocation>
<PublisherLocation>Bryan, Texas, USA</PublisherLocation>
<PublisherLocation>Evanston, IL, USA</PublisherLocation>
<PublisherLocation>Province of China</PublisherLocation>
<PublisherLocation>Landsberg am Lech</PublisherLocation>
<PublisherLocation>Montr√®al, Canada</PublisherLocation>
<PublisherLocation>T¸bingen, Germany</PublisherLocation>
<PublisherLocation>Neuilly-sur-Seine</PublisherLocation>
<PublisherLocation>Oxford/Burlington</PublisherLocation>
<PublisherLocation>Stanford, CA, USA</PublisherLocation>
<PublisherLocation>New York, NY, USA</PublisherLocation>
<PublisherLocation>Weinheim/ M¸nchen</PublisherLocation>
<PublisherLocation>Urbana and London</PublisherLocation>
<PublisherLocation>M¸nchen und Basel</PublisherLocation>
<PublisherLocation>Frankfurt a. Main</PublisherLocation>
<PublisherLocation>Tennessee, U.S.A.</PublisherLocation>
<PublisherLocation>Weinheim, M¸nchen</PublisherLocation>
<PublisherLocation>M√ºnchen, Germany</PublisherLocation>
<PublisherLocation>Cheshire, CT, USA</PublisherLocation>
<PublisherLocation>Albermarle Street</PublisherLocation>
<PublisherLocation>Bern und M√ºnchen</PublisherLocation>
<PublisherLocation>Unterschlei√üheim</PublisherLocation>
<PublisherLocation>Santa Margherita</PublisherLocation>
<PublisherLocation>Breckenridge, CO</PublisherLocation>
<PublisherLocation>Norwell, MA, USA</PublisherLocation>
<PublisherLocation>French Polynesia</PublisherLocation>
<PublisherLocation>Washington, D. C</PublisherLocation>
<PublisherLocation>Tennessee, U.S.A</PublisherLocation>
<PublisherLocation>New York, NY USA</PublisherLocation>
<PublisherLocation>Seattle, WA, USA</PublisherLocation>
<PublisherLocation>Newbury Park. CA</PublisherLocation>
<PublisherLocation>Weinheim & Basel</PublisherLocation>
<PublisherLocation>New York/ London</PublisherLocation>
<PublisherLocation>Weinheim/M¸nchen</PublisherLocation>
<PublisherLocation>Frankf√ºrt a. M.</PublisherLocation>
<PublisherLocation>New York, U.S.A.</PublisherLocation>
<PublisherLocation>Urbana-Champaign</PublisherLocation>
<PublisherLocation>Washington, D.C.</PublisherLocation>
<PublisherLocation>Lengerich/Berlin</PublisherLocation>
<PublisherLocation>Tallinn, Estonia</PublisherLocation>
<PublisherLocation>British Columbia</PublisherLocation>
<PublisherLocation>New YorkNew York</PublisherLocation>
<PublisherLocation>Christmas Island</PublisherLocation>
<PublisherLocation>New Haven/London</PublisherLocation>
<PublisherLocation>Papua New Guinea</PublisherLocation>
<PublisherLocation>Lincolnwood, Ill</PublisherLocation>
<PublisherLocation>Englewood Cliffs</PublisherLocation>
<PublisherLocation>Albany/ New York</PublisherLocation>
<PublisherLocation>MontrËal, Canada</PublisherLocation>
<PublisherLocation>Cambridge, Mass.</PublisherLocation>
<PublisherLocation>Dresden, Germany</PublisherLocation>
<PublisherLocation>Orlando, FL, USA</PublisherLocation>
<PublisherLocation>Bern und M¸nchen</PublisherLocation>
<PublisherLocation>K√∂ln und Berlin</PublisherLocation>
<PublisherLocation>Washingtong D.C.</PublisherLocation>
<PublisherLocation>Stuttgart-Berlin</PublisherLocation>
<PublisherLocation>Houston, TX, USA</PublisherLocation>
<PublisherLocation>Eagelwood Cliffs</PublisherLocation>
<PublisherLocation>London; New York</PublisherLocation>
<PublisherLocation>Wavre (Belgique)</PublisherLocation>
<PublisherLocation>Mainz/ Wiesbaden</PublisherLocation>
<PublisherLocation>Weinheim ; Basel</PublisherLocation>
<PublisherLocation>Prospect Heights</PublisherLocation>
<PublisherLocation>Waterloo, ON, CA</PublisherLocation>
<PublisherLocation>Rishikesh, India</PublisherLocation>
<PublisherLocation>K√∂ln-Marienburg</PublisherLocation>
<PublisherLocation>Redmond, WA, USA</PublisherLocation>
<PublisherLocation>Hingham, MA, USA</PublisherLocation>
<PublisherLocation>Neukirchen-Vluyn</PublisherLocation>
<PublisherLocation>M¸nchen, Germany</PublisherLocation>
<PublisherLocation>Washington D. C.</PublisherLocation>
<PublisherLocation>New York, Oxford</PublisherLocation>
<PublisherLocation>Saint Petersburg</PublisherLocation>
<PublisherLocation>Marshall Islands</PublisherLocation>
<PublisherLocation>New York, NY US</PublisherLocation>
<PublisherLocation>Solomon Islands</PublisherLocation>
<PublisherLocation>London, England</PublisherLocation>
<PublisherLocation>Walnut Creek CA</PublisherLocation>
<PublisherLocation>Baltmannsweilre</PublisherLocation>
<PublisherLocation>Frankf√ºrt a. M</PublisherLocation>
<PublisherLocation>Catalina Island</PublisherLocation>
<PublisherLocation>London/New York</PublisherLocation>
<PublisherLocation>Minneapolis, MN</PublisherLocation>
<PublisherLocation>Cambridge, Mass</PublisherLocation>
<PublisherLocation>Lincolnwood, IL</PublisherLocation>
<PublisherLocation>Wallingford, CT</PublisherLocation>
<PublisherLocation>the Philippines</PublisherLocation>
<PublisherLocation>Washington, D.C</PublisherLocation>
<PublisherLocation>Newbury Park CA</PublisherLocation>
<PublisherLocation>Berlin, Leipzig</PublisherLocation>
<PublisherLocation>Kˆln-Marienburg</PublisherLocation>
<PublisherLocation>Chicester, U.K.</PublisherLocation>
<PublisherLocation>M√ºnchen / Wien</PublisherLocation>
<PublisherLocation>New York/Geneva</PublisherLocation>
<PublisherLocation>Westport, Conn.</PublisherLocation>
<PublisherLocation>Neuwied/Kriftel</PublisherLocation>
<PublisherLocation>Weinheim, Basel</PublisherLocation>
<PublisherLocation>G√∂ttingen u.a.</PublisherLocation>
<PublisherLocation>Cincinnati (OH)</PublisherLocation>
<PublisherLocation>Berlin/New York</PublisherLocation>
<PublisherLocation>Eine Einf¸hrung</PublisherLocation>
<PublisherLocation>Frankfurt a. M.</PublisherLocation>
<PublisherLocation>the Netherlands</PublisherLocation>
<PublisherLocation>Kˆln und Berlin</PublisherLocation>
<PublisherLocation>Warrendale, USA</PublisherLocation>
<PublisherLocation>Peoples R China</PublisherLocation>
<PublisherLocation>Frankf√ºrt/Main</PublisherLocation>
<PublisherLocation>Oxford-New York</PublisherLocation>
<PublisherLocation>San Rafael (CA)</PublisherLocation>
<PublisherLocation>Berlin/M√ºnchen</PublisherLocation>
<PublisherLocation>Washington (DC)</PublisherLocation>
<PublisherLocation>Duluth</PublisherLocation>
<PublisherLocation>Ergebnisbericht</PublisherLocation>
<PublisherLocation>Warrendale, Pa.</PublisherLocation>
<PublisherLocation>Leningrad, USSR</PublisherLocation>
<PublisherLocation>London New York</PublisherLocation>
<PublisherLocation>Washington D.C.</PublisherLocation>
<PublisherLocation>Oxford, England</PublisherLocation>
<PublisherLocation>Boston, MA, USA</PublisherLocation>
<PublisherLocation>Baltmannsweiler</PublisherLocation>
<PublisherLocation>Z√ºrich/ Berlin</PublisherLocation>
<PublisherLocation>College Station</PublisherLocation>
<PublisherLocation>Cambridge, U.K.</PublisherLocation>
<PublisherLocation>Fort Lauderdale</PublisherLocation>
<PublisherLocation>Teamentwicklung</PublisherLocation>
<PublisherLocation>The Netherlands</PublisherLocation>
<PublisherLocation>M¸nchen, Z¸rich</PublisherLocation>
<PublisherLocation>South Australia</PublisherLocation>
<PublisherLocation>Mainz/Wiesbaden</PublisherLocation>
<PublisherLocation>Frankf√ºrt/Wien</PublisherLocation>
<PublisherLocation>University Park</PublisherLocation>
<PublisherLocation>Berkeley CA USA</PublisherLocation>
<PublisherLocation>Valladolid. DC</PublisherLocation>
<PublisherLocation>Landsberg/Lech</PublisherLocation>
<PublisherLocation>Miami, FL, USA</PublisherLocation>
<PublisherLocation>Bern Stuttgart</PublisherLocation>
<PublisherLocation>Woodland Hills</PublisherLocation>
<PublisherLocation>K√∂ln und Wien</PublisherLocation>
<PublisherLocation>Stoke-on-Trent</PublisherLocation>
<PublisherLocation>Schwalbach/Ts.</PublisherLocation>
<PublisherLocation>Frankfurt/Wien</PublisherLocation>
<PublisherLocation>M¸nchen / Wien</PublisherLocation>
<PublisherLocation>Gˆttingen u.a.</PublisherLocation>
<PublisherLocation>Baltimore (MD)</PublisherLocation>
<PublisherLocation>Frankfurt a. M</PublisherLocation>
<PublisherLocation>K√∂nigstein/Ts</PublisherLocation>
<PublisherLocation>Wayne, PA, USA</PublisherLocation>
<PublisherLocation>River Junction</PublisherLocation>
<PublisherLocation>Turku, Finland</PublisherLocation>
<PublisherLocation>St. Petersburg</PublisherLocation>
<PublisherLocation>London, UK, UK</PublisherLocation>
<PublisherLocation>M√ºnchen/Basel</PublisherLocation>
<PublisherLocation>Reading, Mass.</PublisherLocation>
<PublisherLocation>Norfolk Island</PublisherLocation>
<PublisherLocation>Cambridge (MA)</PublisherLocation>
<PublisherLocation>Cambridge u.a.</PublisherLocation>
<PublisherLocation>Madrid (Spain)</PublisherLocation>
<PublisherLocation>American Samoa</PublisherLocation>
<PublisherLocation>Rio de Janeiro</PublisherLocation>
<PublisherLocation>Cayman Islands</PublisherLocation>
<PublisherLocation>Dessau-Rosslau</PublisherLocation>
<PublisherLocation>Louisiana, USA</PublisherLocation>
<PublisherLocation>Wallingford CT</PublisherLocation>
<PublisherLocation>Oxford, UK, UK</PublisherLocation>
<PublisherLocation>Greenwich (CT)</PublisherLocation>
<PublisherLocation>Nairobi, Kenya</PublisherLocation>
<PublisherLocation>Frankf√ºrt a.M</PublisherLocation>
<PublisherLocation>Frankfurt/Main</PublisherLocation>
<PublisherLocation>M√ºnchen, Wien</PublisherLocation>
<PublisherLocation>Bonn-Oedekoven</PublisherLocation>
<PublisherLocation>Bloomington MN</PublisherLocation>
<PublisherLocation>California USA</PublisherLocation>
<PublisherLocation>Berlin/M¸nchen</PublisherLocation>
<PublisherLocation>Pacific Groove</PublisherLocation>
<PublisherLocation>Virgin Islands</PublisherLocation>
<PublisherLocation>Neuwieg-Berlin</PublisherLocation>
<PublisherLocation>New York u. a.</PublisherLocation>
<PublisherLocation>Neuwied/Berlin</PublisherLocation>
<PublisherLocation>Thousands Oaks</PublisherLocation>
<PublisherLocation>Warrendale USA</PublisherLocation>
<PublisherLocation>Thorofare (NJ)</PublisherLocation>
<PublisherLocation>Sankt Augustin</PublisherLocation>
<PublisherLocation>Czech Republic</PublisherLocation>
<PublisherLocation>Hillsdale (NJ)</PublisherLocation>
<PublisherLocation>Frankfurt a.M.</PublisherLocation>
<PublisherLocation>Z√ºrich/Berlin</PublisherLocation>
<PublisherLocation>United Kingdom</PublisherLocation>
<PublisherLocation>Western Sahara</PublisherLocation>
<PublisherLocation>Salt Lake City</PublisherLocation>
<PublisherLocation>Palo Alto (CA)</PublisherLocation>
<PublisherLocation>Gleneden Beach</PublisherLocation>
<PublisherLocation>Edinburgh Gate</PublisherLocation>
<PublisherLocation>Washington D.C</PublisherLocation>
<PublisherLocation>Weinheim Basel</PublisherLocation>
<PublisherLocation>Z¸rich/ Berlin</PublisherLocation>
<PublisherLocation>Princeton (NJ)</PublisherLocation>
<PublisherLocation>Freiburg i. B.</PublisherLocation>
<PublisherLocation>Rehburg-Loccum</PublisherLocation>
<PublisherLocation>Calverton</PublisherLocation>
<PublisherLocation>Sonoma County</PublisherLocation>
<PublisherLocation>North-Holland</PublisherLocation>
<PublisherLocation>Berlin et al.</PublisherLocation>
<PublisherLocation>Seelze-Velber</PublisherLocation>
<PublisherLocation>Faroe Islands</PublisherLocation>
<PublisherLocation>Bad Heilbronn</PublisherLocation>
<PublisherLocation>Cambridge, UK</PublisherLocation>
<PublisherLocation>Kˆln und Wien</PublisherLocation>
<PublisherLocation>Washington DC</PublisherLocation>
<PublisherLocation>Niagara Falls</PublisherLocation>
<PublisherLocation>Pfaffenweiler</PublisherLocation>
<PublisherLocation>New York City</PublisherLocation>
<PublisherLocation>Stanford (CA)</PublisherLocation>
<PublisherLocation>French Guiana</PublisherLocation>
<PublisherLocation>Burlington VT</PublisherLocation>
<PublisherLocation>M¸nchen, Wien</PublisherLocation>
<PublisherLocation>Austin, Texas</PublisherLocation>
<PublisherLocation>M√ºnchen/Wien</PublisherLocation>
<PublisherLocation>Boulder, Col.</PublisherLocation>
<PublisherLocation>Vi√±a del Mar</PublisherLocation>
<PublisherLocation>ViÒa del Mar</PublisherLocation>
<PublisherLocation>western India</PublisherLocation>
<PublisherLocation>Milton Keynes</PublisherLocation>
<PublisherLocation>San Sebastian</PublisherLocation>
<PublisherLocation>Cambridge, MA</PublisherLocation>
<PublisherLocation>Angers France</PublisherLocation>
<PublisherLocation>St Lucia, Qld</PublisherLocation>
<PublisherLocation>North Holland</PublisherLocation>
<PublisherLocation>Weinheim u.a.</PublisherLocation>
<PublisherLocation>New Brunswick</PublisherLocation>
<PublisherLocation>Frankf√ºrt/M.</PublisherLocation>
<PublisherLocation>Saint Etienne</PublisherLocation>
<PublisherLocation>Massachusetts</PublisherLocation>
<PublisherLocation>United States</PublisherLocation>
<PublisherLocation>Aschaffenburg</PublisherLocation>
<PublisherLocation>Kˆnigstein/Ts</PublisherLocation>
<PublisherLocation>Chicago, Ill.</PublisherLocation>
<PublisherLocation>Vysok√© Tatry</PublisherLocation>
<PublisherLocation>Thousand Oaks</PublisherLocation>
<PublisherLocation>Malden, Mass.</PublisherLocation>
<PublisherLocation>Bad Heilbrunn</PublisherLocation>
<PublisherLocation>Chestnut Hill</PublisherLocation>
<PublisherLocation>Z¸rich/Berlin</PublisherLocation>
<PublisherLocation>Newsbury Park</PublisherLocation>
<PublisherLocation>M¸nchen/Basel</PublisherLocation>
<PublisherLocation>Stamford (CT)</PublisherLocation>
<PublisherLocation>Frankfurt a.M</PublisherLocation>
<PublisherLocation>Essen-Kettwig</PublisherLocation>
<PublisherLocation>Berkeley (CA)</PublisherLocation>
<PublisherLocation>Halle (Saale)</PublisherLocation>
<PublisherLocation>Liechtenstein</PublisherLocation>
<PublisherLocation>Bouvet Island</PublisherLocation>
<PublisherLocation>Westport (CT)</PublisherLocation>
<PublisherLocation>Newburry Park</PublisherLocation>
<PublisherLocation>Seattle u. a.</PublisherLocation>
<PublisherLocation>Ann Abor (MI)</PublisherLocation>
<PublisherLocation>Freiburg i.Br</PublisherLocation>
<PublisherLocation>M√ºnster u.a.</PublisherLocation>
<PublisherLocation>Guinea-Bissau</PublisherLocation>
<PublisherLocation>Cambr., Mass.</PublisherLocation>
<PublisherLocation>Beverly Hills</PublisherLocation>
<PublisherLocation>New York (NY)</PublisherLocation>
<PublisherLocation>Gelsenkirchen</PublisherLocation>
<PublisherLocation>Baltimore, Md</PublisherLocation>
<PublisherLocation>New Caledonia</PublisherLocation>
<PublisherLocation>San Francisco</PublisherLocation>
<PublisherLocation>Lake District</PublisherLocation>
<PublisherLocation>Diplomarbeit</PublisherLocation>
<PublisherLocation>Cambridge MA</PublisherLocation>
<PublisherLocation>Florham Park</PublisherLocation>
<PublisherLocation>New York, NY</PublisherLocation>
<PublisherLocation>Grand Rapids</PublisherLocation>
<PublisherLocation>Puerto Varas</PublisherLocation>
<PublisherLocation>London u. a.</PublisherLocation>
<PublisherLocation>Thessaloniki</PublisherLocation>
<PublisherLocation>Burkina Faso</PublisherLocation>
<PublisherLocation>Chicago (IL)</PublisherLocation>
<PublisherLocation>Cambridge UK</PublisherLocation>
<PublisherLocation>South Africa</PublisherLocation>
<PublisherLocation>K√∂ln/Berlin</PublisherLocation>
<PublisherLocation>Weinheim u.a</PublisherLocation>
<PublisherLocation>Sierra Leone</PublisherLocation>
<PublisherLocation>Ekaterinburg</PublisherLocation>
<PublisherLocation>Porto Alegre</PublisherLocation>
<PublisherLocation>Braunschweig</PublisherLocation>
<PublisherLocation>Rheinstetten</PublisherLocation>
<PublisherLocation>Malabar (FL)</PublisherLocation>
<PublisherLocation>Northhampton</PublisherLocation>
<PublisherLocation>Princeton NJ</PublisherLocation>
<PublisherLocation>Shiraz</PublisherLocation>
<PublisherLocation>Redwood City</PublisherLocation>
<PublisherLocation>Hoboken (NJ)</PublisherLocation>
<PublisherLocation>Boulder (CO)</PublisherLocation>
<PublisherLocation>Los Alamitos</PublisherLocation>
<PublisherLocation>Orakei Marae</PublisherLocation>
<PublisherLocation>Dresden (DE)</PublisherLocation>
<PublisherLocation>Reading, Ma.</PublisherLocation>
<PublisherLocation>Cambridge/Ma</PublisherLocation>
<PublisherLocation>Frankf√ºrt/M</PublisherLocation>
<PublisherLocation>Bad Harzburg</PublisherLocation>
<PublisherLocation>Heusenstramm</PublisherLocation>
<PublisherLocation>Edward Elgar</PublisherLocation>
<PublisherLocation>Champaign IL</PublisherLocation>
<PublisherLocation>Turkmenistan</PublisherLocation>
<PublisherLocation>Xi'an, China</PublisherLocation>
<PublisherLocation>Cte Díivoire</PublisherLocation>
<PublisherLocation>Neuburgweier</PublisherLocation>
<PublisherLocation>M¸nster u.a.</PublisherLocation>
<PublisherLocation>M¸nchen/Wien</PublisherLocation>
<PublisherLocation>Saint Helena</PublisherLocation>
<PublisherLocation>Philadelphia</PublisherLocation>
<PublisherLocation>Gaithersburg</PublisherLocation>
<PublisherLocation>Saudi Arabia</PublisherLocation>
<PublisherLocation>Christchurch</PublisherLocation>
<PublisherLocation>Frankfurt/M.</PublisherLocation>
<PublisherLocation>Saarbr√ºcken</PublisherLocation>
<PublisherLocation>Beaconsfield</PublisherLocation>
<PublisherLocation>Mohr Siebeck</PublisherLocation>
<PublisherLocation>Xiían, China</PublisherLocation>
<PublisherLocation>Rhode Island</PublisherLocation>
<PublisherLocation>Hartland, Vt</PublisherLocation>
<PublisherLocation>Walnut Creek</PublisherLocation>
<PublisherLocation>Ulm, Germany</PublisherLocation>
<PublisherLocation>Cambr. Mass.</PublisherLocation>
<PublisherLocation>Cte D'ivoire</PublisherLocation>
<PublisherLocation>Indianapolis</PublisherLocation>
<PublisherLocation>Newbury Park</PublisherLocation>
<PublisherLocation>Vysok‡ Tatry</PublisherLocation>
<PublisherLocation>Pennsylvania</PublisherLocation>
<PublisherLocation>St. Augustin</PublisherLocation>
<PublisherLocation>Neuwied u.a.</PublisherLocation>
<PublisherLocation>Cook Islands</PublisherLocation>
<PublisherLocation>Falls-Church</PublisherLocation>
<PublisherLocation>Santa Monica</PublisherLocation>
<PublisherLocation>Lancaster PA</PublisherLocation>
<PublisherLocation>K√∂nigsstein</PublisherLocation>
<PublisherLocation>Baden- Baden</PublisherLocation>
<PublisherLocation>Ludwigshafen</PublisherLocation>
<PublisherLocation>Ort: Opladen</PublisherLocation>
<PublisherLocation>Addis Ababa</PublisherLocation>
<PublisherLocation>Bihar, Pusa</PublisherLocation>
<PublisherLocation>St. Ingbert</PublisherLocation>
<PublisherLocation>San Antonio</PublisherLocation>
<PublisherLocation>Baden Baden</PublisherLocation>
<PublisherLocation>London (NY)</PublisherLocation>
<PublisherLocation>Jahrhundert</PublisherLocation>
<PublisherLocation>Newbury</PublisherLocation>
<PublisherLocation>Lincolnwood</PublisherLocation>
<PublisherLocation>Netherlands</PublisherLocation>
<PublisherLocation>Palm Harbor</PublisherLocation>
<PublisherLocation>New Zealand</PublisherLocation>
<PublisherLocation>Boston (MA)</PublisherLocation>
<PublisherLocation>Sternenfels</PublisherLocation>
<PublisherLocation>Houndsmills</PublisherLocation>
<PublisherLocation>Hohengehren</PublisherLocation>
<PublisherLocation>Switzerland</PublisherLocation>
<PublisherLocation>Krebsm√ºhle</PublisherLocation>
<PublisherLocation>Milton Park</PublisherLocation>
<PublisherLocation>Ostfieldern</PublisherLocation>
<PublisherLocation>Chelyabinsk</PublisherLocation>
<PublisherLocation>Montpellier</PublisherLocation>
<PublisherLocation>Ivory Coast</PublisherLocation>
<PublisherLocation>Garden City</PublisherLocation>
<PublisherLocation>Mawson, ACT</PublisherLocation>
<PublisherLocation>Little Rock</PublisherLocation>
<PublisherLocation>Bremerhaven</PublisherLocation>
<PublisherLocation>Babson Park</PublisherLocation>
<PublisherLocation>Wiebelsheim</PublisherLocation>
<PublisherLocation>Frankfurt/M</PublisherLocation>
<PublisherLocation>Los Angeles</PublisherLocation>
<PublisherLocation>St. Andrews</PublisherLocation>
<PublisherLocation>Saint Lucia</PublisherLocation>
<PublisherLocation>D√ºsseldorf</PublisherLocation>
<PublisherLocation>Chapel Hill</PublisherLocation>
<PublisherLocation>East Sussex</PublisherLocation>
<PublisherLocation>Springfield</PublisherLocation>
<PublisherLocation>Boulder, CO</PublisherLocation>
<PublisherLocation>El Salvador</PublisherLocation>
<PublisherLocation>Itasca (IL)</PublisherLocation>
<PublisherLocation>New Orleans</PublisherLocation>
<PublisherLocation>Basingstoke</PublisherLocation>
<PublisherLocation>Albuquerque</PublisherLocation>
<PublisherLocation>Mahwah (NJ)</PublisherLocation>
<PublisherLocation>Timor-Leste</PublisherLocation>
<PublisherLocation>Auburn, Ala</PublisherLocation>
<PublisherLocation>Seibersdorf</PublisherLocation>
<PublisherLocation>Kˆln/Berlin</PublisherLocation>
<PublisherLocation>Philippines</PublisherLocation>
<PublisherLocation>Gainesville</PublisherLocation>
<PublisherLocation>Kˆnigsstein</PublisherLocation>
<PublisherLocation>West Sussex</PublisherLocation>
<PublisherLocation>West Berlin</PublisherLocation>
<PublisherLocation>Bensenville</PublisherLocation>
<PublisherLocation>Baden-Baden</PublisherLocation>
<PublisherLocation>Norderstedt</PublisherLocation>
<PublisherLocation>Queenscliff</PublisherLocation>
<PublisherLocation>Westchester</PublisherLocation>
<PublisherLocation>K√∂nigstein</PublisherLocation>
<PublisherLocation>Birmensdorf</PublisherLocation>
<PublisherLocation>Weilerswist</PublisherLocation>
<PublisherLocation>Bloomington</PublisherLocation>
<PublisherLocation>Mexico City</PublisherLocation>
<PublisherLocation>Saarbr¸cken</PublisherLocation>
<PublisherLocation>Stroudsburg</PublisherLocation>
<PublisherLocation>New York NY</PublisherLocation>
<PublisherLocation>Lanham (MD)</PublisherLocation>
<PublisherLocation>Afghanistan</PublisherLocation>
<PublisherLocation>Puerto Rico</PublisherLocation>
<PublisherLocation>Strassbourg</PublisherLocation>
<PublisherLocation>Minneapolis</PublisherLocation>
<PublisherLocation>Novosibirsk</PublisherLocation>
<PublisherLocation>San Marino</PublisherLocation>
<PublisherLocation>Piscataway</PublisherLocation>
<PublisherLocation>Burlington</PublisherLocation>
<PublisherLocation>Memphis Tn</PublisherLocation>
<PublisherLocation>Warrendale</PublisherLocation>
<PublisherLocation>Akron (OH)</PublisherLocation>
<PublisherLocation>Guadeloupe</PublisherLocation>
<PublisherLocation>G√Øttingen</PublisherLocation>
<PublisherLocation>Atlanta GA</PublisherLocation>
<PublisherLocation>Krebsm¸hle</PublisherLocation>
<PublisherLocation>River Edge</PublisherLocation>
<PublisherLocation>Maidenhead</PublisherLocation>
<PublisherLocation>Menlo Park</PublisherLocation>
<PublisherLocation>Middleburg</PublisherLocation>
<PublisherLocation>Eichst√§tt</PublisherLocation>
<PublisherLocation>Cincinnati</PublisherLocation>
<PublisherLocation>St. Gallen</PublisherLocation>
<PublisherLocation>Santa Cruz</PublisherLocation>
<PublisherLocation>Luxembourg</PublisherLocation>
<PublisherLocation>Regensburg</PublisherLocation>
<PublisherLocation>Sunderland</PublisherLocation>
<PublisherLocation>Costa Rica</PublisherLocation>
<PublisherLocation>Hackensack</PublisherLocation>
<PublisherLocation>Wageningen</PublisherLocation>
<PublisherLocation>Montserrat</PublisherLocation>
<PublisherLocation>Stahleisen</PublisherLocation>
<PublisherLocation>Colchester</PublisherLocation>
<PublisherLocation>Birmingham</PublisherLocation>
<PublisherLocation>BadenBaden</PublisherLocation>
<PublisherLocation>Frankf√ºrt</PublisherLocation>
<PublisherLocation>Washington</PublisherLocation>
<PublisherLocation>Sverdlovsk</PublisherLocation>
<PublisherLocation>Neuch√¢tel</PublisherLocation>
<PublisherLocation>Freiburg/B</PublisherLocation>
<PublisherLocation>Townsville</PublisherLocation>
<PublisherLocation>Eibelstadt</PublisherLocation>
<PublisherLocation>Buckingham</PublisherLocation>
<PublisherLocation>Osnabr√ºck</PublisherLocation>
<PublisherLocation>Leverkusen</PublisherLocation>
<PublisherLocation>Bratislava</PublisherLocation>
<PublisherLocation>Oxford, UK</PublisherLocation>
<PublisherLocation>Carbondale</PublisherLocation>
<PublisherLocation>Greifswald</PublisherLocation>
<PublisherLocation>Los Alamos</PublisherLocation>
<PublisherLocation>Martinique</PublisherLocation>
<PublisherLocation>Uzbekistan</PublisherLocation>
<PublisherLocation>Beograd AD</PublisherLocation>
<PublisherLocation>San Rafael</PublisherLocation>
<PublisherLocation>Azerbaijan</PublisherLocation>
<PublisherLocation>Mauritania</PublisherLocation>
<PublisherLocation>S√£o Paulo</PublisherLocation>
<PublisherLocation>Fort Worth</PublisherLocation>
<PublisherLocation>Nueva York</PublisherLocation>
<PublisherLocation>Strasbourg</PublisherLocation>
<PublisherLocation>Mozambique</PublisherLocation>
<PublisherLocation>Emeryville</PublisherLocation>
<PublisherLocation>Manchester</PublisherLocation>
<PublisherLocation>Nottingham</PublisherLocation>
<PublisherLocation>New Jersey</PublisherLocation>
<PublisherLocation>Houndmills</PublisherLocation>
<PublisherLocation>Long Grove</PublisherLocation>
<PublisherLocation>Reutlingen</PublisherLocation>
<PublisherLocation>Providence</PublisherLocation>
<PublisherLocation>Pittsburgh</PublisherLocation>
<PublisherLocation>Maastricht</PublisherLocation>
<PublisherLocation>Wilmington</PublisherLocation>
<PublisherLocation>Brookfield</PublisherLocation>
<PublisherLocation>D¸sseldorf</PublisherLocation>
<PublisherLocation>Bad Honnef</PublisherLocation>
<PublisherLocation>Deutchland</PublisherLocation>
<PublisherLocation>Kyrgyzstan</PublisherLocation>
<PublisherLocation>Heidelberg</PublisherLocation>
<PublisherLocation>Greensboro</PublisherLocation>
<PublisherLocation>California</PublisherLocation>
<PublisherLocation>Schorndorf</PublisherLocation>
<PublisherLocation>Marshfield</PublisherLocation>
<PublisherLocation>Kˆnigstein</PublisherLocation>
<PublisherLocation>Hoboken NJ</PublisherLocation>
<PublisherLocation>Mason (OH)</PublisherLocation>
<PublisherLocation>Madrid. DC</PublisherLocation>
<PublisherLocation>Seychelles</PublisherLocation>
<PublisherLocation>Bangladesh</PublisherLocation>
<PublisherLocation>Winterthur</PublisherLocation>
<PublisherLocation>Amityville</PublisherLocation>
<PublisherLocation>Wellington</PublisherLocation>
<PublisherLocation>Oxford/USA</PublisherLocation>
<PublisherLocation>G√ºtersloh</PublisherLocation>
<PublisherLocation>Copenhagen</PublisherLocation>
<PublisherLocation>Miami, Fla</PublisherLocation>
<PublisherLocation>Alexandria</PublisherLocation>
<PublisherLocation>Notre Dame</PublisherLocation>
<PublisherLocation>Mass. u.a.</PublisherLocation>
<PublisherLocation>Chesapeake</PublisherLocation>
<PublisherLocation>Santa Rosa</PublisherLocation>
<PublisherLocation>Montevideo</PublisherLocation>
<PublisherLocation>Antarctica</PublisherLocation>
<PublisherLocation>Manchaster</PublisherLocation>
<PublisherLocation>Madagascar</PublisherLocation>
<PublisherLocation>Tajikistan</PublisherLocation>
<PublisherLocation>Cape Verde</PublisherLocation>
<PublisherLocation>Kazakhstan</PublisherLocation>
<PublisherLocation>Schwalbach</PublisherLocation>
<PublisherLocation>Klagenfurt</PublisherLocation>
<PublisherLocation>Chichester</PublisherLocation>
<PublisherLocation>Neum¸nster</PublisherLocation>
<PublisherLocation>Ostfildern</PublisherLocation>
<PublisherLocation>Boca Raton</PublisherLocation>
<PublisherLocation>Magglingen</PublisherLocation>
<PublisherLocation>Lanham, Md</PublisherLocation>
<PublisherLocation>Valladolid</PublisherLocation>
<PublisherLocation>Austin, Tx</PublisherLocation>
<PublisherLocation>Chippenham</PublisherLocation>
<PublisherLocation>Camberwell</PublisherLocation>
<PublisherLocation>G√∂ttingen</PublisherLocation>
<PublisherLocation>Cheltenham</PublisherLocation>
<PublisherLocation>Sebastopol</PublisherLocation>
<PublisherLocation>Lengerich</PublisherLocation>
<PublisherLocation>Sri Lanka</PublisherLocation>
<PublisherLocation>Shrub Oak</PublisherLocation>
<PublisherLocation>Guangzhou</PublisherLocation>
<PublisherLocation>Greenwich</PublisherLocation>
<PublisherLocation>Guatemala</PublisherLocation>
<PublisherLocation>Bangalore</PublisherLocation>
<PublisherLocation>Lanham Md</PublisherLocation>
<PublisherLocation>Osnabr¸ck</PublisherLocation>
<PublisherLocation>Oberursel</PublisherLocation>
<PublisherLocation>Vancouver</PublisherLocation>
<PublisherLocation>Argentina</PublisherLocation>
<PublisherLocation>N√ºrnberg</PublisherLocation>
<PublisherLocation>Mauritius</PublisherLocation>
<PublisherLocation>Rotterdam</PublisherLocation>
<PublisherLocation>Greenland</PublisherLocation>
<PublisherLocation>Manhattan</PublisherLocation>
<PublisherLocation>Lithuania</PublisherLocation>
<PublisherLocation>Las Vegas</PublisherLocation>
<PublisherLocation>San Diego</PublisherLocation>
<PublisherLocation>Landsberg</PublisherLocation>
<PublisherLocation>Leningrad</PublisherLocation>
<PublisherLocation>Stockholm</PublisherLocation>
<PublisherLocation>Livermore</PublisherLocation>
<PublisherLocation>Ettlingen</PublisherLocation>
<PublisherLocation>Schwangau</PublisherLocation>
<PublisherLocation>Gˆttingen</PublisherLocation>
<PublisherLocation>Singapore</PublisherLocation>
<PublisherLocation>Princeton</PublisherLocation>
<PublisherLocation>New Haven</PublisherLocation>
<PublisherLocation>Dordrecht</PublisherLocation>
<PublisherLocation>Nicaragua</PublisherLocation>
<PublisherLocation>Bielefeld</PublisherLocation>
<PublisherLocation>Noordwijk</PublisherLocation>
<PublisherLocation>Wiesbaden</PublisherLocation>
<PublisherLocation>Magdeburg</PublisherLocation>
<PublisherLocation>Baltimore</PublisherLocation>
<PublisherLocation>New Paltz</PublisherLocation>
<PublisherLocation>Karlsruhe</PublisherLocation>
<PublisherLocation>Oldenburg</PublisherLocation>
<PublisherLocation>Barcelona</PublisherLocation>
<PublisherLocation>Venezuela</PublisherLocation>
<PublisherLocation>Groningen</PublisherLocation>
<PublisherLocation>Kalamazoo</PublisherLocation>
<PublisherLocation>Chicester</PublisherLocation>
<PublisherLocation>Charlotte</PublisherLocation>
<PublisherLocation>New Delhi</PublisherLocation>
<PublisherLocation>Changchun</PublisherLocation>
<PublisherLocation>Trondheim</PublisherLocation>
<PublisherLocation>Gibraltar</PublisherLocation>
<PublisherLocation>St. Louis</PublisherLocation>
<PublisherLocation>The Hague</PublisherLocation>
<PublisherLocation>Lancaster</PublisherLocation>
<PublisherLocation>Melbourne</PublisherLocation>
<PublisherLocation>Fremantle</PublisherLocation>
<PublisherLocation>Amsterdam</PublisherLocation>
<PublisherLocation>Werkstatt</PublisherLocation>
<PublisherLocation>Bruxelles</PublisherLocation>
<PublisherLocation>Luxemburg</PublisherLocation>
<PublisherLocation>Thorofare</PublisherLocation>
<PublisherLocation>Troisdorf</PublisherLocation>
<PublisherLocation>Indonesia</PublisherLocation>
<PublisherLocation>San Mateo</PublisherLocation>
<PublisherLocation>Hillsdale</PublisherLocation>
<PublisherLocation>Champaign</PublisherLocation>
<PublisherLocation>New Yorck</PublisherLocation>
<PublisherLocation>Minnesota</PublisherLocation>
<PublisherLocation>Paderborn</PublisherLocation>
<PublisherLocation>Sao Paulo</PublisherLocation>
<PublisherLocation>L√ºneburg</PublisherLocation>
<PublisherLocation>Swaziland</PublisherLocation>
<PublisherLocation>Australia</PublisherLocation>
<PublisherLocation>Cape Town</PublisherLocation>
<PublisherLocation>Sausalito</PublisherLocation>
<PublisherLocation>San Deigo</PublisherLocation>
<PublisherLocation>Rockville</PublisherLocation>
<PublisherLocation>Starnberg</PublisherLocation>
<PublisherLocation>Eichst‰tt</PublisherLocation>
<PublisherLocation>Corvallis</PublisherLocation>
<PublisherLocation>Cary (NC)</PublisherLocation>
<PublisherLocation>Darmstadt</PublisherLocation>
<PublisherLocation>G√∂teborg</PublisherLocation>
<PublisherLocation>Eindhoven</PublisherLocation>
<PublisherLocation>Berkshire</PublisherLocation>
<PublisherLocation>Hyderabad</PublisherLocation>
<PublisherLocation>Cambridge</PublisherLocation>
<PublisherLocation>Oxford UK</PublisherLocation>
<PublisherLocation>Rochester</PublisherLocation>
<PublisherLocation>G¸tersloh</PublisherLocation>
<PublisherLocation>Stuttgart</PublisherLocation>
<PublisherLocation>Volgograd</PublisherLocation>
<PublisherLocation>Leicester</PublisherLocation>
<PublisherLocation>Heinsberg</PublisherLocation>
<PublisherLocation>Syktyvkar</PublisherLocation>
<PublisherLocation>Hauppauge</PublisherLocation>
<PublisherLocation>Wuppertal</PublisherLocation>
<PublisherLocation>Marseille</PublisherLocation>
<PublisherLocation>Cresskill</PublisherLocation>
<PublisherLocation>Nashville</PublisherLocation>
<PublisherLocation>Guildford</PublisherLocation>
<PublisherLocation>T√ºbingen</PublisherLocation>
<PublisherLocation>Don Mills</PublisherLocation>
<PublisherLocation>Ann Arbor</PublisherLocation>
<PublisherLocation>Aldershot</PublisherLocation>
<PublisherLocation>Innsbruck</PublisherLocation>
<PublisherLocation>Palo Alto</PublisherLocation>
<PublisherLocation>W√ºrzburg</PublisherLocation>
<PublisherLocation>Nuremberg</PublisherLocation>
<PublisherLocation>Vallendar</PublisherLocation>
<PublisherLocation>Offenbach</PublisherLocation>
<PublisherLocation>Ypsilanti</PublisherLocation>
<PublisherLocation>S„o Paulo</PublisherLocation>
<PublisherLocation>Frankfurt</PublisherLocation>
<PublisherLocation>Stuttgatt</PublisherLocation>
<PublisherLocation>Edinburgh</PublisherLocation>
<PublisherLocation>Lexington</PublisherLocation>
<PublisherLocation>Hong Kong</PublisherLocation>
<PublisherLocation>Slovenia</PublisherLocation>
<PublisherLocation>Scotland</PublisherLocation>
<PublisherLocation>Allerton</PublisherLocation>
<PublisherLocation>Monterey</PublisherLocation>
<PublisherLocation>Budapest</PublisherLocation>
<PublisherLocation>Westport</PublisherLocation>
<PublisherLocation>Columbia</PublisherLocation>
<PublisherLocation>Hannover</PublisherLocation>
<PublisherLocation>Ann Abor</PublisherLocation>
<PublisherLocation>Nanterre</PublisherLocation>
<PublisherLocation>Toulouse</PublisherLocation>
<PublisherLocation>M√ºlheim</PublisherLocation>
<PublisherLocation>Helsinki</PublisherLocation>
<PublisherLocation>Malaysia</PublisherLocation>
<PublisherLocation>Botswana</PublisherLocation>
<PublisherLocation>Muenchen</PublisherLocation>
<PublisherLocation>Hartland</PublisherLocation>
<PublisherLocation>Maldives</PublisherLocation>
<PublisherLocation>Carlisle</PublisherLocation>
<PublisherLocation>Victoria</PublisherLocation>
<PublisherLocation>Zimbabwe</PublisherLocation>
<PublisherLocation>Waterloo</PublisherLocation>
<PublisherLocation>Santa Fe</PublisherLocation>
<PublisherLocation>Edinburg</PublisherLocation>
<PublisherLocation>Dordrech</PublisherLocation>
<PublisherLocation>Cheshire</PublisherLocation>
<PublisherLocation>Brooklyn</PublisherLocation>
<PublisherLocation>Plymouth</PublisherLocation>
<PublisherLocation>Montreal</PublisherLocation>
<PublisherLocation>Chemnitz</PublisherLocation>
<PublisherLocation>Delaware</PublisherLocation>
<PublisherLocation>Santiago</PublisherLocation>
<PublisherLocation>Houghton</PublisherLocation>
<PublisherLocation>W¸rzburg</PublisherLocation>
<PublisherLocation>Honduras</PublisherLocation>
<PublisherLocation>Illinois</PublisherLocation>
<PublisherLocation>Evanston</PublisherLocation>
<PublisherLocation>Abington</PublisherLocation>
<PublisherLocation>Oplanden</PublisherLocation>
<PublisherLocation>Colombia</PublisherLocation>
<PublisherLocation>Slovakia</PublisherLocation>
<PublisherLocation>Homewood</PublisherLocation>
<PublisherLocation>Pakistan</PublisherLocation>
<PublisherLocation>Whistler</PublisherLocation>
<PublisherLocation>C√°ceres</PublisherLocation>
<PublisherLocation>C·ceres</PublisherLocation>
<PublisherLocation>Pasadena</PublisherLocation>
<PublisherLocation>Maring√°</PublisherLocation>
<PublisherLocation>Maring·</PublisherLocation>
<PublisherLocation>Pitcairn</PublisherLocation>
<PublisherLocation>Yokohama</PublisherLocation>
<PublisherLocation>Thailand</PublisherLocation>
<PublisherLocation>Berkeley</PublisherLocation>
<PublisherLocation>Acapulco</PublisherLocation>
<PublisherLocation>Konstanz</PublisherLocation>
<PublisherLocation>Salzburg</PublisherLocation>
<PublisherLocation>Warszawa</PublisherLocation>
<PublisherLocation>Stafford</PublisherLocation>
<PublisherLocation>Den Haag</PublisherLocation>
<PublisherLocation>Varanasi</PublisherLocation>
<PublisherLocation>M√ºnchen</PublisherLocation>
<PublisherLocation>Munichen</PublisherLocation>
<PublisherLocation>Duisburg</PublisherLocation>
<PublisherLocation>Holy See</PublisherLocation>
<PublisherLocation>New York</PublisherLocation>
<PublisherLocation>Akron OH</PublisherLocation>
<PublisherLocation>Provo UT</PublisherLocation>
<PublisherLocation>Ethiopia</PublisherLocation>
<PublisherLocation>Herzliya</PublisherLocation>
<PublisherLocation>Valencia</PublisherLocation>
<PublisherLocation>Donostia</PublisherLocation>
<PublisherLocation>Br√ºssel</PublisherLocation>
<PublisherLocation>Cameroon</PublisherLocation>
<PublisherLocation>Mongolia</PublisherLocation>
<PublisherLocation>Erlangen</PublisherLocation>
<PublisherLocation>Dortmund</PublisherLocation>
<PublisherLocation>Michigan</PublisherLocation>
<PublisherLocation>Bulgaria</PublisherLocation>
<PublisherLocation>Oklahoma</PublisherLocation>
<PublisherLocation>Djibouti</PublisherLocation>
<PublisherLocation>Chestnut</PublisherLocation>
<PublisherLocation>L¸neburg</PublisherLocation>
<PublisherLocation>Canberra</PublisherLocation>
<PublisherLocation>Weinheim</PublisherLocation>
<PublisherLocation>Glenview</PublisherLocation>
<PublisherLocation>T¸bingen</PublisherLocation>
<PublisherLocation>Portugal</PublisherLocation>
<PublisherLocation>Auckland</PublisherLocation>
<PublisherLocation>Dietikon</PublisherLocation>
<PublisherLocation>Suriname</PublisherLocation>
<PublisherLocation>M√ºnster</PublisherLocation>
<PublisherLocation>La Salle</PublisherLocation>
<PublisherLocation>Enschede</PublisherLocation>
<PublisherLocation>Hamilton</PublisherLocation>
<PublisherLocation>Anguilla</PublisherLocation>
<PublisherLocation>Kiribati</PublisherLocation>
<PublisherLocation>Columbus</PublisherLocation>
<PublisherLocation>Hohenems</PublisherLocation>
<PublisherLocation>Mannheim</PublisherLocation>
<PublisherLocation>Virginia</PublisherLocation>
<PublisherLocation>Voorburg</PublisherLocation>
<PublisherLocation>New-York</PublisherLocation>
<PublisherLocation>Hangzhou</PublisherLocation>
<PublisherLocation>Sante Fe</PublisherLocation>
<PublisherLocation>Stanford</PublisherLocation>
<PublisherLocation>Barbados</PublisherLocation>
<PublisherLocation>Honolulu</PublisherLocation>
<PublisherLocation>Cambodia</PublisherLocation>
<PublisherLocation>San Jose</PublisherLocation>
<PublisherLocation>Hemsbach</PublisherLocation>
<PublisherLocation>Brussels</PublisherLocation>
<PublisherLocation>Bethesda</PublisherLocation>
<PublisherLocation>Augsburg</PublisherLocation>
<PublisherLocation>Abingdon</PublisherLocation>
<PublisherLocation>Viet Nam</PublisherLocation>
<PublisherLocation>Paraguay</PublisherLocation>
<PublisherLocation>Gˆteborg</PublisherLocation>
<PublisherLocation>Konzepte</PublisherLocation>
<PublisherLocation>Stamford</PublisherLocation>
<PublisherLocation>N¸rnberg</PublisherLocation>
<PublisherLocation>Portland</PublisherLocation>
<PublisherLocation>Freiburg</PublisherLocation>
<PublisherLocation>Edmonton</PublisherLocation>
<PublisherLocation>NW China</PublisherLocation>
<PublisherLocation>Adelaide</PublisherLocation>
<PublisherLocation>Dominica</PublisherLocation>
<PublisherLocation>Ontario</PublisherLocation>
<PublisherLocation>Belarus</PublisherLocation>
<PublisherLocation>Albania</PublisherLocation>
<PublisherLocation>Kempten</PublisherLocation>
<PublisherLocation>Morelia</PublisherLocation>
<PublisherLocation>Opladen</PublisherLocation>
<PublisherLocation>Amherst</PublisherLocation>
<PublisherLocation>Fairfax</PublisherLocation>
<PublisherLocation>Waxmann</PublisherLocation>
<PublisherLocation>Uppsala</PublisherLocation>
<PublisherLocation>Maywood</PublisherLocation>
<PublisherLocation>Somalia</PublisherLocation>
<PublisherLocation>Seattle</PublisherLocation>
<PublisherLocation>Bristol</PublisherLocation>
<PublisherLocation>Tilburg</PublisherLocation>
<PublisherLocation>Denmark</PublisherLocation>
<PublisherLocation>Vietnam</PublisherLocation>
<PublisherLocation>Hungary</PublisherLocation>
<PublisherLocation>Beijing</PublisherLocation>
<PublisherLocation>Mehring</PublisherLocation>
<PublisherLocation>Anaheim</PublisherLocation>
<PublisherLocation>Eritrea</PublisherLocation>
<PublisherLocation>Coimbra</PublisherLocation>
<PublisherLocation>Hoboken</PublisherLocation>
<PublisherLocation>Armenia</PublisherLocation>
<PublisherLocation>Jamaica</PublisherLocation>
<PublisherLocation>Algeria</PublisherLocation>
<PublisherLocation>Seville</PublisherLocation>
<PublisherLocation>Florida</PublisherLocation>
<PublisherLocation>Liberia</PublisherLocation>
<PublisherLocation>Maxwell</PublisherLocation>
<PublisherLocation>Aalborg</PublisherLocation>
<PublisherLocation>Bingley</PublisherLocation>
<PublisherLocation>Chester</PublisherLocation>
<PublisherLocation>Germany</PublisherLocation>
<PublisherLocation>Hamburg</PublisherLocation>
<PublisherLocation>CA, USA</PublisherLocation>
<PublisherLocation>Potsdam</PublisherLocation>
<PublisherLocation>Chicago</PublisherLocation>
<PublisherLocation>Comoros</PublisherLocation>
<PublisherLocation>Vanuatu</PublisherLocation>
<PublisherLocation>Myanmar</PublisherLocation>
<PublisherLocation>Finland</PublisherLocation>
<PublisherLocation>C‡ceres</PublisherLocation>
<PublisherLocation>Uruguay</PublisherLocation>
<PublisherLocation>Bryansk</PublisherLocation>
<PublisherLocation>Florenz</PublisherLocation>
<PublisherLocation>Reading</PublisherLocation>
<PublisherLocation>Grenada</PublisherLocation>
<PublisherLocation>Hayward</PublisherLocation>
<PublisherLocation>Belmont</PublisherLocation>
<PublisherLocation>VA, USA</PublisherLocation>
<PublisherLocation>Belknap</PublisherLocation>
<PublisherLocation>Z√ºrich</PublisherLocation>
<PublisherLocation>Tunisia</PublisherLocation>
<PublisherLocation>Herford</PublisherLocation>
<PublisherLocation>Kinsale</PublisherLocation>
<PublisherLocation>Malabar</PublisherLocation>
<PublisherLocation>Schweiz</PublisherLocation>
<PublisherLocation>Senegal</PublisherLocation>
<PublisherLocation>Georgia</PublisherLocation>
<PublisherLocation>Atlanta</PublisherLocation>
<PublisherLocation>Conches</PublisherLocation>
<PublisherLocation>M¸nchen</PublisherLocation>
<PublisherLocation>Cottbus</PublisherLocation>
<PublisherLocation>Memphis</PublisherLocation>
<PublisherLocation>Bahrain</PublisherLocation>
<PublisherLocation>Munchen</PublisherLocation>
<PublisherLocation>Ferrara</PublisherLocation>
<PublisherLocation>M¸nster</PublisherLocation>
<PublisherLocation>Lon-don</PublisherLocation>
<PublisherLocation>Estonia</PublisherLocation>
<PublisherLocation>St Paul</PublisherLocation>
<PublisherLocation>Kettwig</PublisherLocation>
<PublisherLocation>Teaneck</PublisherLocation>
<PublisherLocation>Boulder</PublisherLocation>
<PublisherLocation>Leipzig</PublisherLocation>
<PublisherLocation>Lesotho</PublisherLocation>
<PublisherLocation>Orlando</PublisherLocation>
<PublisherLocation>Avebury</PublisherLocation>
<PublisherLocation>Farnham</PublisherLocation>
<PublisherLocation>Bologna</PublisherLocation>
<PublisherLocation>Belgrad</PublisherLocation>
<PublisherLocation>Oakland</PublisherLocation>
<PublisherLocation>Glasgow</PublisherLocation>
<PublisherLocation>Garbsen</PublisherLocation>
<PublisherLocation>Pullman</PublisherLocation>
<PublisherLocation>Glencoe</PublisherLocation>
<PublisherLocation>Tokelau</PublisherLocation>
<PublisherLocation>Harvard</PublisherLocation>
<PublisherLocation>Maring·</PublisherLocation>
<PublisherLocation>Gie√üen</PublisherLocation>
<PublisherLocation>Cosenza</PublisherLocation>
<PublisherLocation>Norwell</PublisherLocation>
<PublisherLocation>Dubuque</PublisherLocation>
<PublisherLocation>Deutsch</PublisherLocation>
<PublisherLocation>Dresden</PublisherLocation>
<PublisherLocation>Houston</PublisherLocation>
<PublisherLocation>M‹nchen</PublisherLocation>
<PublisherLocation>Mayotte</PublisherLocation>
<PublisherLocation>Laramie</PublisherLocation>
<PublisherLocation>Phoenix</PublisherLocation>
<PublisherLocation>Buffalo</PublisherLocation>
<PublisherLocation>Berkley</PublisherLocation>
<PublisherLocation>Mailand</PublisherLocation>
<PublisherLocation>Namibia</PublisherLocation>
<PublisherLocation>Lincoln</PublisherLocation>
<PublisherLocation>Holland</PublisherLocation>
<PublisherLocation>Bolivia</PublisherLocation>
<PublisherLocation>Madison</PublisherLocation>
<PublisherLocation>Bogot√°</PublisherLocation>
<PublisherLocation>Perugia</PublisherLocation>
<PublisherLocation>Belgium</PublisherLocation>
<PublisherLocation>England</PublisherLocation>
<PublisherLocation>Enfield</PublisherLocation>
<PublisherLocation>Toronto</PublisherLocation>
<PublisherLocation>LaSalle</PublisherLocation>
<PublisherLocation>Hsinchu</PublisherLocation>
<PublisherLocation>Izhevsk</PublisherLocation>
<PublisherLocation>Halifax</PublisherLocation>
<PublisherLocation>Z√Ørich</PublisherLocation>
<PublisherLocation>NY, USA</PublisherLocation>
<PublisherLocation>Ecuador</PublisherLocation>
<PublisherLocation>Utrecht</PublisherLocation>
<PublisherLocation>Bahamas</PublisherLocation>
<PublisherLocation>Ukraine</PublisherLocation>
<PublisherLocation>Reinbek</PublisherLocation>
<PublisherLocation>V√§xj√∂</PublisherLocation>
<PublisherLocation>Ansbach</PublisherLocation>
<PublisherLocation>Burundi</PublisherLocation>
<PublisherLocation>Croatia</PublisherLocation>
<PublisherLocation>Iceland</PublisherLocation>
<PublisherLocation>Neuwied</PublisherLocation>
<PublisherLocation>Br¸ssel</PublisherLocation>
<PublisherLocation>Bamberg</PublisherLocation>
<PublisherLocation>Heredia</PublisherLocation>
<PublisherLocation>Ilmenau</PublisherLocation>
<PublisherLocation>Morocco</PublisherLocation>
<PublisherLocation>Hershey</PublisherLocation>
<PublisherLocation>Neuried</PublisherLocation>
<PublisherLocation>Ireland</PublisherLocation>
<PublisherLocation>Bermuda</PublisherLocation>
<PublisherLocation>Alabama</PublisherLocation>
<PublisherLocation>Alberta</PublisherLocation>
<PublisherLocation>Anahein</PublisherLocation>
<PublisherLocation>Romania</PublisherLocation>
<PublisherLocation>Neu-Ulm</PublisherLocation>
<PublisherLocation>Detroit</PublisherLocation>
<PublisherLocation>Nigeria</PublisherLocation>
<PublisherLocation>Nanning</PublisherLocation>
<PublisherLocation>Marburg</PublisherLocation>
<PublisherLocation>Andorra</PublisherLocation>
<PublisherLocation>M¸lheim</PublisherLocation>
<PublisherLocation>Mumchen</PublisherLocation>
<PublisherLocation>Granada</PublisherLocation>
<PublisherLocation>Lebanon</PublisherLocation>
<PublisherLocation>Taskent</PublisherLocation>
<PublisherLocation>Austria</PublisherLocation>
<PublisherLocation>Malawi</PublisherLocation>
<PublisherLocation>Athens</PublisherLocation>
<PublisherLocation>Moscow</PublisherLocation>
<PublisherLocation>Kassel</PublisherLocation>
<PublisherLocation>Harlow</PublisherLocation>
<PublisherLocation>Boston</PublisherLocation>
<PublisherLocation>Aarhus</PublisherLocation>
<PublisherLocation>Oregon</PublisherLocation>
<PublisherLocation>Lanham</PublisherLocation>
<PublisherLocation>Aachen</PublisherLocation>
<PublisherLocation>Latvia</PublisherLocation>
<PublisherLocation>Poland</PublisherLocation>
<PublisherLocation>Nevada</PublisherLocation>
<PublisherLocation>Odessa</PublisherLocation>
<PublisherLocation>Turkey</PublisherLocation>
<PublisherLocation>Zagreb</PublisherLocation>
<PublisherLocation>Zurich</PublisherLocation>
<PublisherLocation>Dublin</PublisherLocation>
<PublisherLocation>Vienna</PublisherLocation>
<PublisherLocation>Newark</PublisherLocation>
<PublisherLocation>Lisbon</PublisherLocation>
<PublisherLocation>Zambia</PublisherLocation>
<PublisherLocation>Munich</PublisherLocation>
<PublisherLocation>Durham</PublisherLocation>
<PublisherLocation>Havana</PublisherLocation>
<PublisherLocation>Aurora</PublisherLocation>
<PublisherLocation>Tuvalu</PublisherLocation>
<PublisherLocation>Warsaw</PublisherLocation>
<PublisherLocation>Nagoya</PublisherLocation>
<PublisherLocation>Guyana</PublisherLocation>
<PublisherLocation>Nantes</PublisherLocation>
<PublisherLocation>Bombay</PublisherLocation>
<PublisherLocation>Gambia</PublisherLocation>
<PublisherLocation>Lohmar</PublisherLocation>
<PublisherLocation>Weimar</PublisherLocation>
<PublisherLocation>Tolowa</PublisherLocation>
<PublisherLocation>Leiden</PublisherLocation>
<PublisherLocation>Cardif</PublisherLocation>
<PublisherLocation>Taipei</PublisherLocation>
<PublisherLocation>Auburn</PublisherLocation>
<PublisherLocation>Taunus</PublisherLocation>
<PublisherLocation>Paphos</PublisherLocation>
<PublisherLocation>Bhutan</PublisherLocation>
<PublisherLocation>Luzern</PublisherLocation>
<PublisherLocation>Malden</PublisherLocation>
<PublisherLocation>Mexico</PublisherLocation>
<PublisherLocation>Guinea</PublisherLocation>
<PublisherLocation>Trento</PublisherLocation>
<PublisherLocation>Mahway</PublisherLocation>
<PublisherLocation>Totowa</PublisherLocation>
<PublisherLocation>Berlin</PublisherLocation>
<PublisherLocation>Armonk</PublisherLocation>
<PublisherLocation>Leuven</PublisherLocation>
<PublisherLocation>Brazil</PublisherLocation>
<PublisherLocation>Temuco</PublisherLocation>
<PublisherLocation>Austin</PublisherLocation>
<PublisherLocation>Erfurt</PublisherLocation>
<PublisherLocation>Ithaca</PublisherLocation>
<PublisherLocation>Taiwan</PublisherLocation>
<PublisherLocation>Manila</PublisherLocation>
<PublisherLocation>Belize</PublisherLocation>
<PublisherLocation>Seelze</PublisherLocation>
<PublisherLocation>Bochum</PublisherLocation>
<PublisherLocation>Reward</PublisherLocation>
<PublisherLocation>Angola</PublisherLocation>
<PublisherLocation>Bremen</PublisherLocation>
<PublisherLocation>Z¸rich</PublisherLocation>
<PublisherLocation>Albany</PublisherLocation>
<PublisherLocation>Bostom</PublisherLocation>
<PublisherLocation>Madras</PublisherLocation>
<PublisherLocation>Uganda</PublisherLocation>
<PublisherLocation>Kuwait</PublisherLocation>
<PublisherLocation>Speyer</PublisherLocation>
<PublisherLocation>Monaco</PublisherLocation>
<PublisherLocation>Madrid</PublisherLocation>
<PublisherLocation>Mahwah</PublisherLocation>
<PublisherLocation>Milano</PublisherLocation>
<PublisherLocation>SANDEC</PublisherLocation>
<PublisherLocation>Gieﬂen</PublisherLocation>
<PublisherLocation>Passau</PublisherLocation>
<PublisherLocation>Rwanda</PublisherLocation>
<PublisherLocation>Venice</PublisherLocation>
<PublisherLocation>Sussex</PublisherLocation>
<PublisherLocation>Loccum</PublisherLocation>
<PublisherLocation>Mering</PublisherLocation>
<PublisherLocation>Kansas</PublisherLocation>
<PublisherLocation>Runion</PublisherLocation>
<PublisherLocation>Sydney</PublisherLocation>
<PublisherLocation>Golden</PublisherLocation>
<PublisherLocation>Dessau</PublisherLocation>
<PublisherLocation>Geneva</PublisherLocation>
<PublisherLocation>Rieden</PublisherLocation>
<PublisherLocation>Siegen</PublisherLocation>
<PublisherLocation>London</PublisherLocation>
<PublisherLocation>Harare</PublisherLocation>
<PublisherLocation>Sitges</PublisherLocation>
<PublisherLocation>Oaxaca</PublisherLocation>
<PublisherLocation>Tucson</PublisherLocation>
<PublisherLocation>Torino</PublisherLocation>
<PublisherLocation>Panama</PublisherLocation>
<PublisherLocation>Leiria</PublisherLocation>
<PublisherLocation>Oxford</PublisherLocation>
<PublisherLocation>France</PublisherLocation>
<PublisherLocation>Dallas</PublisherLocation>
<PublisherLocation>Ankara</PublisherLocation>
<PublisherLocation>Encino</PublisherLocation>
<PublisherLocation>Rowley</PublisherLocation>
<PublisherLocation>Reston</PublisherLocation>
<PublisherLocation>Greece</PublisherLocation>
<PublisherLocation>Denver</PublisherLocation>
<PublisherLocation>Prague</PublisherLocation>
<PublisherLocation>Israel</PublisherLocation>
<PublisherLocation>Mumbai</PublisherLocation>
<PublisherLocation>Norway</PublisherLocation>
<PublisherLocation>Bergen</PublisherLocation>
<PublisherLocation>Malaga</PublisherLocation>
<PublisherLocation>Poznan</PublisherLocation>
<PublisherLocation>Landau</PublisherLocation>
<PublisherLocation>Norman</PublisherLocation>
<PublisherLocation>Jordan</PublisherLocation>
<PublisherLocation>Itasca</PublisherLocation>
<PublisherLocation>Sweden</PublisherLocation>
<PublisherLocation>Urbana</PublisherLocation>
<PublisherLocation>Canada</PublisherLocation>
<PublisherLocation>Moskau</PublisherLocation>
<PublisherLocation>Ottawa</PublisherLocation>
<PublisherLocation>Cyprus</PublisherLocation>
<PublisherLocation>Samara</PublisherLocation>
<PublisherLocation>Essen</PublisherLocation>
<PublisherLocation>Essex</PublisherLocation>
<PublisherLocation>Korea</PublisherLocation>
<PublisherLocation>Niger</PublisherLocation>
<PublisherLocation>Turin</PublisherLocation>
<PublisherLocation>Irwin</PublisherLocation>
<PublisherLocation>Provo</PublisherLocation>
<PublisherLocation>Wayne</PublisherLocation>
<PublisherLocation>Perth</PublisherLocation>
<PublisherLocation>Orsay</PublisherLocation>
<PublisherLocation>Tonga</PublisherLocation>
<PublisherLocation>Tokyo</PublisherLocation>
<PublisherLocation>Cairo</PublisherLocation>
<PublisherLocation>Udine</PublisherLocation>
<PublisherLocation>U. K.</PublisherLocation>
<PublisherLocation>Miami</PublisherLocation>
<PublisherLocation>Basel</PublisherLocation>
<PublisherLocation>Delhi</PublisherLocation>
<PublisherLocation>Seoul</PublisherLocation>
<PublisherLocation>Mason</PublisherLocation>
<PublisherLocation>Ogden</PublisherLocation>
<PublisherLocation>U.S.A</PublisherLocation>
<PublisherLocation>Nyack</PublisherLocation>
<PublisherLocation>Busan</PublisherLocation>
<PublisherLocation>Tulsa</PublisherLocation>
<PublisherLocation>Borup</PublisherLocation>
<PublisherLocation>Benin</PublisherLocation>
<PublisherLocation>India</PublisherLocation>
<PublisherLocation>Egypt</PublisherLocation>
<PublisherLocation>Italy</PublisherLocation>
<PublisherLocation>Congo</PublisherLocation>
<PublisherLocation>Paris</PublisherLocation>
<PublisherLocation>Soest</PublisherLocation>
<PublisherLocation>Kenya</PublisherLocation>
<PublisherLocation>Delft</PublisherLocation>
<PublisherLocation>Haiti</PublisherLocation>
<PublisherLocation>Patna</PublisherLocation>
<PublisherLocation>Dhaka</PublisherLocation>
<PublisherLocation>Norge</PublisherLocation>
<PublisherLocation>Herne</PublisherLocation>
<PublisherLocation>Yemen</PublisherLocation>
<PublisherLocation>Aruba</PublisherLocation>
<PublisherLocation>Nepal</PublisherLocation>
<PublisherLocation>Japan</PublisherLocation>
<PublisherLocation>Spain</PublisherLocation>
<PublisherLocation>Texel</PublisherLocation>
<PublisherLocation>Qatar</PublisherLocation>
<PublisherLocation>Samoa</PublisherLocation>
<PublisherLocation>Mainz</PublisherLocation>
<PublisherLocation>Halle</PublisherLocation>
<PublisherLocation>Gabon</PublisherLocation>
<PublisherLocation>China</PublisherLocation>
<PublisherLocation>Wells</PublisherLocation>
<PublisherLocation>Siena</PublisherLocation>
<PublisherLocation>Nauru</PublisherLocation>
<PublisherLocation>Malta</PublisherLocation>
<PublisherLocation>Palau</PublisherLocation>
<PublisherLocation>Macao</PublisherLocation>
<PublisherLocation>Texas</PublisherLocation>
<PublisherLocation>Mass.</PublisherLocation>
<PublisherLocation>Rugby</PublisherLocation>
<PublisherLocation>Quito</PublisherLocation>
<PublisherLocation>K√∂ln</PublisherLocation>
<PublisherLocation>Crete</PublisherLocation>
<PublisherLocation>Kazan</PublisherLocation>
<PublisherLocation>Chile</PublisherLocation>
<PublisherLocation>Dijon</PublisherLocation>
<PublisherLocation>Ghana</PublisherLocation>
<PublisherLocation>Sudan</PublisherLocation>
<PublisherLocation>Guam</PublisherLocation>
<PublisherLocation>Oslo</PublisherLocation>
<PublisherLocation>Kiel</PublisherLocation>
<PublisherLocation>Oman</PublisherLocation>
<PublisherLocation>Iowa</PublisherLocation>
<PublisherLocation>Lutz</PublisherLocation>
<PublisherLocation>Hove</PublisherLocation>
<PublisherLocation>Togo</PublisherLocation>
<PublisherLocation>Bern</PublisherLocation>
<PublisherLocation>Iver</PublisherLocation>
<PublisherLocation>Cuba</PublisherLocation>
<PublisherLocation>Rome</PublisherLocation>
<PublisherLocation>Cary</PublisherLocation>
<PublisherLocation>Mass</PublisherLocation>
<PublisherLocation>Linz</PublisherLocation>
<PublisherLocation>Kiev</PublisherLocation>
<PublisherLocation>Niue</PublisherLocation>
<PublisherLocation>Kˆln</PublisherLocation>
<PublisherLocation>Genf</PublisherLocation>
<PublisherLocation>U.K.</PublisherLocation>
<PublisherLocation>Pusa</PublisherLocation>
<PublisherLocation>Jena</PublisherLocation>
<PublisherLocation>Wien</PublisherLocation>
<PublisherLocation>York</PublisherLocation>
<PublisherLocation>Bonn</PublisherLocation>
<PublisherLocation>Bari</PublisherLocation>
<PublisherLocation>Iraq</PublisherLocation>
<PublisherLocation>Mohr</PublisherLocation>
<PublisherLocation>Soul</PublisherLocation>
<PublisherLocation>Vail</PublisherLocation>
<PublisherLocation>Peru</PublisherLocation>
<PublisherLocation>Lund</PublisherLocation>
<PublisherLocation>Graz</PublisherLocation>
<PublisherLocation>Pisa</PublisherLocation>
<PublisherLocation>Mali</PublisherLocation>
<PublisherLocation>Chad</PublisherLocation>
<PublisherLocation>Fiji</PublisherLocation>
<PublisherLocation>LLC</PublisherLocation>
<PublisherLocation>HIS</PublisherLocation>
<PublisherLocation>MIT</PublisherLocation>
<PublisherLocation>USA</PublisherLocation>
<PublisherLocation>U S A</PublisherLocation>
<PublisherLocation>U. S. A.</PublisherLocation>
<PublisherLocation>U. S. A</PublisherLocation>
<PublisherLocation>Ufa</PublisherLocation>
<PublisherLocation>MA</PublisherLocation>
<PublisherLocation>NY</PublisherLocation>
<PublisherLocation>IN</PublisherLocation>
<PublisherLocation>NJ</PublisherLocation>
<PublisherLocation>PA</PublisherLocation>
<PublisherLocation>UK</PublisherLocation>
<PublisherLocation>Tokio</PublisherLocation>
<PublisherLocation>Memphis Tn.</PublisherLocation>
<PublisherLocation>Shiga, Japan</PublisherLocation>
<PublisherLocation>Cardiff</PublisherLocation>
<PublisherLocation>Shanghai</PublisherLocation>
<PublisherLocation>Harmondsworth</PublisherLocation>
<PublisherLocation>Hemstead</PublisherLocation>
<PublisherLocation>Detroit</PublisherLocation>
<PublisherLocation>Berkely</PublisherLocation>
<PublisherLocation>Shaftesbury</PublisherLocation>
<PublisherLocation>Culver City</PublisherLocation>
<PublisherLocation>Danville</PublisherLocation>
<PublisherLocation>Oviedo</PublisherLocation>
<PublisherLocation>Waco</PublisherLocation>
<PublisherLocation>Ohio</PublisherLocation>
<PublisherLocation>Pacific Grove</PublisherLocation>
<PublisherLocation>Jerusalem</PublisherLocation>
<PublisherLocation>Macarthur</PublisherLocation>
<PublisherLocation>NSW Australia</PublisherLocation>
<PublisherLocation>Middletown</PublisherLocation>
<PublisherLocation>Iowa City</PublisherLocation>
<PublisherLocation>Lyon</PublisherLocation>
<PublisherLocation>Milan</PublisherLocation>
<PublisherLocation>Wallingford</PublisherLocation>
<PublisherLocation>Eighth Circuit</PublisherLocation>
<PublisherLocation>Texcoco</PublisherLocation>
<PublisherLocation>Tiruchirappalli</PublisherLocation>
<PublisherLocation>Tamilnadu</PublisherLocation>
<PublisherLocation>Coimbatore</PublisherLocation>
<PublisherLocation>Surry</PublisherLocation>
<PublisherLocation>Surry County</PublisherLocation>
<PublisherLocation>Wilmslow</PublisherLocation>
<PublisherLocation>Alappuzha</PublisherLocation>
<PublisherLocation>Daejeon</PublisherLocation>
<PublisherLocation>Taejon</PublisherLocation>
<PublisherLocation>North Carolina</PublisherLocation>
<PublisherLocation>Kielce</PublisherLocation>
<PublisherLocation>Hoboken, NJ</PublisherLocation>
<PublisherLocation>Ambleside</PublisherLocation>
<PublisherLocation>Rochelle Park</PublisherLocation>
<PublisherLocation>Grenoble</PublisherLocation>
<PublisherLocation>Syracuse</PublisherLocation>
<PublisherLocation>Mineola</PublisherLocation>
<PublisherLocation>Colorado</PublisherLocation>
<PublisherLocation>Deerfield Beach</PublisherLocation>
<PublisherLocation>Frankfurt-am-Main</PublisherLocation>
<PublisherLocation>Annandale</PublisherLocation>
<PublisherLocation>Pamplona</PublisherLocation>
<PublisherLocation>Norwood</PublisherLocation>
<PublisherLocation>Clevedon</PublisherLocation>
<PublisherLocation>Cambridge and London</PublisherLocation>
<PublisherLocation>Cham</PublisherLocation>
<PublisherLocation>Lawrence</PublisherLocation>
<PublisherLocation>Hissar</PublisherLocation>
<PublisherLocation>Loughborough</PublisherLocation>
<PublisherLocation>Lanham</PublisherLocation>
<PublisherLocation>Roma</PublisherLocation>
<PublisherLocation>Lisse</PublisherLocation>
<PublisherLocation>Logro√±o</PublisherLocation>
<PublisherLocation>LogroÒo</PublisherLocation>
<PublisherLocation>Murcia</PublisherLocation>
<PublisherLocation>Zaragoza</PublisherLocation>
<PublisherLocation>Laingsburg</PublisherLocation>
<PublisherLocation>Bucure≈üti</PublisherLocation>
<PublisherLocation>Morgantown</PublisherLocation>
<PublisherLocation>Peterborough</PublisherLocation>
<PublisherLocation>Bucure»ôti</PublisherLocation>
<PublisherLocation>Bucharest</PublisherLocation>
<PublisherLocation>Craiova</PublisherLocation>
<PublisherLocation>Gold Coast</PublisherLocation>
<PublisherLocation>Madison</PublisherLocation>
<PublisherLocation>Wisconsin</PublisherLocation>
<PublisherLocation>Tallin</PublisherLocation>
<PublisherLocation>Durban</PublisherLocation>
<PublisherLocation>Rome (Italy)</PublisherLocation>
<PublisherLocation>Duluth</PublisherLocation>
<PublisherLocation>Kingston</PublisherLocation>
<PublisherLocation>Sacramento</PublisherLocation>
<PublisherLocation>Madeira Park</PublisherLocation>
<PublisherLocation>Briarcliff Manor</PublisherLocation>
<PublisherLocation>Guelph</PublisherLocation>
<PublisherLocation>St. Paul, MN</PublisherLocation>
<PublisherLocation>St. Paul MN</PublisherLocation>
<PublisherLocation>St. Paul (MN)</PublisherLocation>
<PublisherLocation>Winnipeg</PublisherLocation>
<PublisherLocation>Jackson, MS</PublisherLocation>
<PublisherLocation>Jackson, (MS)</PublisherLocation>
<PublisherLocation>Jackson MS</PublisherLocation>
<PublisherLocation>Jackson, Mississippi</PublisherLocation>
<PublisherLocation>Tielt</PublisherLocation>
<PublisherLocation>Cothen</PublisherLocation>
<PublisherLocation>Nijmegen</PublisherLocation>
<PublisherLocation>Brussel</PublisherLocation>
<PublisherLocation>Zwolle</PublisherLocation>
<PublisherLocation>Vermillion</PublisherLocation>
<PublisherLocation>Canberra</PublisherLocation>
<PublisherLocation>Hartford</PublisherLocation>
<PublisherLocation>Northampton</PublisherLocation>
<PublisherLocation>Temecula</PublisherLocation>
<PublisherLocation>Hanover</PublisherLocation>
<PublisherLocation>Bethesda, Md</PublisherLocation>
<PublisherLocation>D√ºsseldorf</PublisherLocation>
<PublisherLocation>D¸sseldorf</PublisherLocation>
<PublisherLocation>Tucuman</PublisherLocation>
<PublisherLocation>Pensacola</PublisherLocation>
<PublisherLocation>Layton</PublisherLocation>
<PublisherLocation>Redmond</PublisherLocation>
<PublisherLocation>Katmai</PublisherLocation>
<PublisherLocation>Caldwell New Jersey</PublisherLocation>
<PublisherLocation>Norwich</PublisherLocation>
<PublisherLocation>Arlington</PublisherLocation>
<PublisherLocation>Dreieich</PublisherLocation>
<PublisherLocation>Castries</PublisherLocation>
<PublisherLocation>New york</PublisherLocation>
<PublisherLocation>Fredericton</PublisherLocation>
<PublisherLocation>Manitoba</PublisherLocation>
<PublisherLocation>Winnipeg</PublisherLocation>
<PublisherLocation>St Leonards</PublisherLocation>
<PublisherLocation>Richmond</PublisherLocation>
<PublisherLocation>Connecticut</PublisherLocation>
<PublisherLocation>M√ºnchen und Wien</PublisherLocation>
<PublisherLocation>M¸nchen und Wien</PublisherLocation>
<PublisherLocation>Meezen</PublisherLocation>
<PublisherLocation>Hawthorne</PublisherLocation>
<PublisherLocation>Dahlem bei Berlin</PublisherLocation>
<PublisherLocation>Elkhart</PublisherLocation>
<PublisherLocation>Indiana</PublisherLocation>
<PublisherLocation>Uberlandia</PublisherLocation>
<PublisherLocation>Stockholm</PublisherLocation>
<PublisherLocation>Link√∂ping</PublisherLocation>
<PublisherLocation>Linkˆping</PublisherLocation>
<PublisherLocation>Middle Village</PublisherLocation>
<PublisherLocation>TU Graz</PublisherLocation>
<PublisherLocation>klin</PublisherLocation>
<PublisherLocation>Klin</PublisherLocation>
<PublisherLocation>Wuxi</PublisherLocation>
<PublisherLocation>Corvallis</PublisherLocation>
<PublisherLocation>Middlesex</PublisherLocation>
<PublisherLocation>Harmondsworth, Middx</PublisherLocation>
<PublisherLocation>Belfast</PublisherLocation>
<PublisherLocation>Dallas, TX</PublisherLocation>
<PublisherLocation>Hyattsville</PublisherLocation>
<PublisherLocation>Poona</PublisherLocation>
<PublisherLocation>Pretoria</PublisherLocation>
<PublisherLocation>Lille</PublisherLocation>
<PublisherLocation>Dalian</PublisherLocation>
<PublisherLocation>Raleigh</PublisherLocation>
<PublisherLocation>Jakarta</PublisherLocation>
<PublisherLocation>College Park, MD</PublisherLocation>
<PublisherLocation>H√§meenlinna</PublisherLocation>
<PublisherLocation>H‰meenlinna</PublisherLocation>
<PublisherLocation>Washington, D.C.</PublisherLocation>
<PublisherLocation>M√©xico</PublisherLocation>
<PublisherLocation>Whitefish</PublisherLocation>
<PublisherLocation>Englewood Cliffs (NJ)</PublisherLocation>
<PublisherLocation>Chicago, Ill</PublisherLocation>
<PublisherLocation>Reinbek</PublisherLocation>
<PublisherLocation>Blackburg</PublisherLocation>
<PublisherLocation>Blackburg, Va</PublisherLocation>
<PublisherLocation>Harrisburg</PublisherLocation>
<PublisherLocation>Upper Saddle River (NJ)</PublisherLocation>
<PublisherLocation>Homebush</PublisherLocation>
<PublisherLocation>Gloucestershire</PublisherLocation>
<PublisherLocation>Gen√®ve</PublisherLocation>
<PublisherLocation>Elmsford</PublisherLocation>
<PublisherLocation>Brisbane</PublisherLocation>
<PublisherLocation>Lisboa</PublisherLocation>
<PublisherLocation>Brookfield, Vt.</PublisherLocation>
<PublisherLocation>San Francisco, Calif</PublisherLocation>
<PublisherLocation>Maryland</PublisherLocation>
<PublisherLocation>Massachussetts</PublisherLocation>
<PublisherLocation>Ueberlingen</PublisherLocation>
<PublisherLocation>Waltham</PublisherLocation>
<PublisherLocation>Urbana</PublisherLocation>
<PublisherLocation>AnnArbor</PublisherLocation>
<PublisherLocation>Pullheim</PublisherLocation>
<PublisherLocation>Pune</PublisherLocation>
<PublisherLocation>K√∂nigsberg</PublisherLocation>
<PublisherLocation>Kˆnigsberg</PublisherLocation>
<PublisherLocation>Berlin Heidelberg NewYork Tokio</PublisherLocation>
<PublisherLocation>Hillside</PublisherLocation>
<PublisherLocation>Gorki</PublisherLocation>
<PublisherLocation>Sherwood Park, AB</PublisherLocation>
<PublisherLocation>Johannesburg</PublisherLocation>
<PublisherLocation>Oxford/New York</PublisherLocation>
<PublisherLocation>Geelong</PublisherLocation>
<PublisherLocation>Fayetteville</PublisherLocation>
<PublisherLocation>Bangkok</PublisherLocation>
<PublisherLocation>Plymbridge</PublisherLocation>
<PublisherLocation>Piracicaba</PublisherLocation>
<PublisherLocation>Setauket</PublisherLocation>
<PublisherLocation>Lima</PublisherLocation>
<PublisherLocation>Ivanovo</PublisherLocation>
<PublisherLocation>Freiburg i. Br.</PublisherLocation>
<PublisherLocation>Fellbach-Oeffingen</PublisherLocation>
<PublisherLocation>Dushanbe</PublisherLocation>
<PublisherLocation>Cambridge (Mass.)</PublisherLocation>
<PublisherLocation>Knoxville</PublisherLocation>
<PublisherLocation>Tenn</PublisherLocation>
<PublisherLocation>Cayuga</PublisherLocation>
<PublisherLocation>St. Paul, Minn</PublisherLocation>
<PublisherLocation>Boppard</PublisherLocation>
<PublisherLocation>Irvine</PublisherLocation>
<PublisherLocation>Waltham, MA</PublisherLocation>
<PublisherLocation>Hampshire</PublisherLocation>
<PublisherLocation>Deerfield Beach (Florida)</PublisherLocation>
<PublisherLocation>New York, NY</PublisherLocation>
<PublisherLocation>Cheshire, Connecticut</PublisherLocation>
<PublisherLocation>Cheshire, Conn</PublisherLocation>
<PublisherLocation>Vit√≥ria</PublisherLocation>
<PublisherLocation>Western Australia</PublisherLocation>
<PublisherLocation>Arlington</PublisherLocation>
<PublisherLocation>Bogot·</PublisherLocation>
<PublisherLocation>Albertson (N.Y.)</PublisherLocation>
<PublisherLocation>Albertson</PublisherLocation>
<PublisherLocation>Crowthorne</PublisherLocation>
<PublisherLocation>Lexington, MA</PublisherLocation>
<PublisherLocation>Glencoe (IL)</PublisherLocation>
<PublisherLocation>Northampton</PublisherLocation>
<PublisherLocation>Cheltenham</PublisherLocation>
<PublisherLocation>Lulea</PublisherLocation>
<PublisherLocation>West Sussex</PublisherLocation>
<PublisherLocation>Cold Spring Harbor, N.Y.</PublisherLocation>
<PublisherLocation>Cold Spring Harbor</PublisherLocation>
<PublisherLocation>D√ºseldorf</PublisherLocation>
<PublisherLocation>D¸seldorf</PublisherLocation>
<PublisherLocation>Colombo</PublisherLocation>
<PublisherLocation>New York ‚àô London</PublisherLocation>
<PublisherLocation>Wayne, Pa</PublisherLocation>
<PublisherLocation>wayne, PA</PublisherLocation>
<PublisherLocation>wayne, USA</PublisherLocation>
<PublisherLocation>Ann Ar</PublisherLocation>
<PublisherLocation>Morristown</PublisherLocation>
<PublisherLocation>Edwardsville</PublisherLocation>
<PublisherLocation>Baltmannweiler</PublisherLocation>
<PublisherLocation>Chur</PublisherLocation>
<PublisherLocation>Washington, D.C.</PublisherLocation>
<PublisherLocation>Recklinghausen</PublisherLocation>
<PublisherLocation>Palo Alto, CA</PublisherLocation>
<PublisherLocation>Ljubljana</PublisherLocation>
<PublisherLocation>Kassel</PublisherLocation>
<PublisherLocation>Highlands Ranch</PublisherLocation>
<PublisherLocation>Galveston</PublisherLocation>
<PublisherLocation>Mich</PublisherLocation>
<PublisherLocation>Karpacz</PublisherLocation>
<PublisherLocation>Muenster</PublisherLocation>
<PublisherLocation>√ÅfricadoSul</PublisherLocation>
<PublisherLocation>Koblenz</PublisherLocation>
<PublisherLocation>Lissabon</PublisherLocation>
<PublisherLocation>St. P√∂lten</PublisherLocation>
<PublisherLocation>Cambridge [MA] and London</PublisherLocation>
<PublisherLocation>Reinbek bei Hamburg</PublisherLocation>
<PublisherLocation>Moers</PublisherLocation>
<PublisherLocation>Gro√üsch√∂nau</PublisherLocation>
<PublisherLocation>Wymondham</PublisherLocation>
<PublisherLocation>Warley</PublisherLocation>
<PublisherLocation>Warley (UK)</PublisherLocation>
<PublisherLocation>Greenwich, CT</PublisherLocation>);


sub SortedPublisherLocationDB{
 
  my @PublisherLocationIni=();
  while($PublisherLocationText=~m/<PublisherLocation>(.*?)<\/PublisherLocation>/g){
    #    $PublisherLocationIni{$1}="";
    push (@PublisherLocationIni, $1);
  }
  my @SortedPublisherLocationIni =  map { $_->[0] } sort { $b->[1] <=> $a->[1] } map { [ $_, length($_) ] } @PublisherLocationIni;

  #print "@SortedPublisherLocationIni";
  return \@SortedPublisherLocationIni;
}


return 1;