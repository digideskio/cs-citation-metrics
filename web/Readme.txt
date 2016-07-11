
**apache2.conf
  DocumentRoot /etc/EXT/Citation_Metrics/web
  ScriptAlias /cMetrix "/etc/EXT/Citation_Metrics/web/"
  Directory "/etc/EXT/Citation_Metrics/web"


**Project File Structure**

  * /serverDirectory/Citation_Metrics

    /etc/EXT/Citation_Metrics
        |-- Config
	|	`-- web.config
        |-- Modules
        |	`
        |	`-- CMetricsWeb.pm
        |	`-- GetConfig.pm
        |	`-- UuidToken.pm
        |	`-- DateTime.pm
        |	`-- MQ.pm
        |	`-- DBConnection.pm
        |	`-- EnrichXML.pm
	|
        |-- web
        |	`-- CitationMetrics.cgi
	|	`-- Readme.txt
        |	|-- templates
	|		`-- client.html.ep
        |		|-- css
	|			`-- site.css
        |		|-- images
	|			`-- Springer-Nature.jpg
	|
        |-- SQL
        |	|-- *.*
	|	`-- *.*
	|
        |-- INPUT
        |	|-- UUID_Token_Folder
	|		`-- *.xml
	|
        |-- OUTPUT
        |	|-- UUID_Token_Folder
	|		`-- *.xml
	|
        |-- rabbitmq
        |	`-- worker.pl

        |-- Statistics


**Stander Perl Module Requre**
    Mojolicious::Lite
    Data::UUID 
    Cwd
    DBI
    Net::RabbitFoot


**Project Modules**
    GetConfig 
    UuidToken
    CMetricsWeb
    MQ
    DateTime
    DBConnection
    EnrichXML

***Resuqst for Service
URL: 
       http://10.113.5.197:8080/CitationMetrics.cgi/Historical

Params: 
	#Key = IN4mJl11HTB3hvSdjTRGNS6gzychYyk9WvbSBCdfhkI
	Input_Type = xml
	Input_File = Attached xml file



	Postman e.g. 
		#http://10.113.5.197:8080/CitationMetrics.cgi/Historical?Key=IN4mJl11HTB3hvSdjTRGNS6gzychYyk9WvbSBCdfhkI&Input_Type=XML
		http://10.113.5.197:8080/CitationMetrics.cgi/Historical?Input_Type=XML

			Body->form-data->key
				Input_File
			value
			      Choose Files as
  			        bbm-978-1-4612-3756-3%2F1.xml
			choose type as File


***Resuqst for Status 
  URL: 
     http://10.113.5.197:8080/CitationMetrics.cgi/Status

  Params:
    Token = 69771a01-7ce6-ae9b-dfb5-8bbd5168f0d0   

***UI Client for testing

        URL:   http://10.113.5.197:8080/CitationMetrics.cgi      

