#Author: Neyaz Ahmad
package MyApp;
use Mojo::Base "Mojolicious";
 
sub startup {
  my $app = shift;
  #$app->plugin(Swagger2 => {url => "/etc/EXT/Citation_Metrics/Modules/petstore.json"});
  $app->plugin(Swagger2 => {url => "data://MyApp/petstore.json"});
}
 
_DATA__
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

1;
