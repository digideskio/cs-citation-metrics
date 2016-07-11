#!/usr/bin/perl

use lib '/etc/EXT/Citation_Metrics/Modules';

#perl /etc/EXT/Citation_Metrics/web/sw1.cgi
use Swagger2;
#$url="http://10.113.5.197:8080/param.json";
#my $swagger = Swagger2->new->load($url);
# plugin Swagger2 => {swagger => $swagger2};
# app->defaults(swagger_spec => $swagger->api_spec);


require Mojolicious::Commands;
Mojolicious::Commands->start_app('MyApp');
