#!/usr/bin/perl

#/etc/EXT/Citation_Metrics/web/working/swagger.pl

#http://10.113.5.197:8080/working/swagger.pl cgi

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
