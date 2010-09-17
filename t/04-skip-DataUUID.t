#!/usr/bin/perl -w

use strict;
use warnings;

use Test::Most;

plan qw/no_plan/;

BEGIN {
    %Data::TUID::BestUUID::skip = ( DataUUID => 1 );
}

use Data::TUID;

my ( $result );

$result = Data::TUID::BestUUID->new_uuid;
is( length( $result ), 36 );
