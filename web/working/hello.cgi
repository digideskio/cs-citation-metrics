#!/usr/bin/perl

#perl /etc/EXT/Citation_Metrics/web/hello.cgi cgi

#http://10.113.5.197:8080/hello.cgi

use Mojolicious::Lite;

get '/' => {text => 'I ♥ Mojolicious! Neyaz'};

app->start;
