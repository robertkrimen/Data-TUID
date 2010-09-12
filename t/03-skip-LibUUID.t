#!/usr/bin/perl -w

use strict;
use warnings;

use Test::Most;

plan qw/no_plan/;

BEGIN {
    %Data::TUID::BestUUID::skip = ( LibUUID => 1 );
}

use Data::TUID;

ok( 1 );
