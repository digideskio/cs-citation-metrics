#!/usr/bin/perl

#/etc/EXT/Citation_Metrics/web/working/sw.pl

use Mojolicious::Lite;

my $route = app->routes->under->to(
    cb => sub {
	my $c = shift;
	return 1 if $c->param('secret');
	return $c->render(json => {error => "Not authenticated"}, status => 401);
    }
    );

plugin Swagger2 => {
    route => $route,
    url   => "data://api.json",
};

__DATA__
@@ api.json
{"swagger":"2.0", ...}
