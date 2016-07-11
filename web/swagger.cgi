#!/usr/bin/perl

#perl /etc/EXT/Citation_Metrics/web/swagger.cgi get -v -M GET /

#perl /etc/EXT/Citation_Metrics/web/swagger.cgi cgi

#http://10.113.5.197:8080/working/swagger.cgi

package MyApp;
use Mojo::Base "Mojolicious";
 
sub startup {
  my $app = shift;
  $app->plugin(Swagger2 => {url => "data://MyApp/petstore.json"});
}
 
__DATA__
@@ petstore.json
{
  "swagger": "2.0",
  "info": {...},
  "host": "petstore.swagger.wordnik.com",
  "basePath": "/api",
  "paths": {
    "/pets": {
      "get": {...}
    }
  }
}
