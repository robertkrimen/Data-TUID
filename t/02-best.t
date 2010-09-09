#!/usr/bin/perl -w

use strict;
use warnings;

use Test::Most;

plan qw/no_plan/;

use Data::TUID::BestUUID;

my ( $uuid, $binary_uuid, $result );

$uuid = 'e3f590ee-ecc3-4a1e-a37f-863951f10aaf';

$binary_uuid = Data::TUID::BestUUID->uuid_to_binary( $uuid );
is( length( $binary_uuid ), 16 );

$result = Data::TUID::BestUUID->new_uuid_binary;
is( length( $result ), 16 );

if ( $Data::TUID::BestUUID::loaded{LibUUID} ) {
}

if ( $Data::TUID::BestUUID::loaded{DataUUID} ) {
    is( length( Data::UUID->new->create_bin ), 16 );

    local %Data::TUID::BestUUID::loaded = ( DataUUID => 1 );
    $result = Data::TUID::BestUUID->uuid_to_binary( $uuid );
    is( $binary_uuid, $result );

    $result = Data::TUID::BestUUID->uuid_to_binary( $binary_uuid );
    is( $binary_uuid, $result );
}

