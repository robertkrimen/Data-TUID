#!/usr/bin/perl -w

use strict;
use warnings;

use Test::Most;

plan qw/no_plan/;

use Data::TUID;

is( length Data::TUID->tuid, 8 );
is( length Data::TUID->tuid( size => 1 ), 4 );
is( length Data::TUID->tuid( size => 2 ), 8 );
is( length Data::TUID->tuid( length => 5 ), 5 );
is( length Data::TUID->tuid( length => 20 ), 20 );
is( length Data::TUID->tuid( size => 5 ), 20 );

warn Data::TUID::->tuid( length => -1 );
