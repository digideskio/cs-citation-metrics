#!/usr/bin/perl

#/etc/EXT/Citation_Metrics/web/key.pl
 
my $userReuest="user1";
use Digest::SHA qw(hmac_sha256_base64);
my $digest = hmac_sha256_base64 ($userReuest, $self->{SecretKey});

print "$digest\n";

#user1: IN4mJl11HTB3hvSdjTRGNS6gzychYyk9WvbSBCdfhkI
