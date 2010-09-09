package Data::TUID::BestUUID;

use strict;
use warnings;

our %loaded;

BEGIN {
    eval {
        $loaded{LibUUID} = require Data::UUID::LibUUID;
        1;
    };

    eval {
        $loaded{DataUUID} = require Data::UUID;
        1;
    };
}

sub new_uuid_binary {
    my $self = shift;

    return Data::UUID::LibUUID::new_uuid_binary if $loaded{LibUUID};
    return Data::UUID->new->create_bin if $loaded{DataUUID};

    die "No UUID package loaded";
}

sub uuid_to_binary {
    my $self = shift;
    my ( $uuid ) = @_;

    die "Missing/invalid uuid" unless $uuid;

    my $result;

    if ( $loaded{LibUUID} ) {
        $result = Data::UUID::LibUUID::uuid_to_binary( $uuid );
    }

    if ( $loaded{DataUUID} ) {
        eval {
            # This will die when given a binary string
            $result = Data::UUID->new->from_string( $uuid );
        };
        $result = $uuid if ! $result && 16 == length $uuid;
    };

    die "Invalid uuid ($uuid): Unable to convert" unless $result;

    return $result;
}

1;
