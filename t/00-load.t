#!perl

use Test::More tests => 1;

BEGIN {
	use_ok( 'Data::TUID' );
}

diag( "Testing Data::TUID $Data::TUID::VERSION, Perl $], $^X" );
