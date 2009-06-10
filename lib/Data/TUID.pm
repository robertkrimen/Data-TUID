package Data::TUID;

use warnings;
use strict;

=head1 NAME

Data::TUID - A smaller and more communicable pseudo-UUID

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

    use Data::TUID

    my $tuid = tuid             # Generate a TUID of (default) length 8
    $tuid = tuid length => 4    # Generate a TUID of length 4
    $tuid = Data::TUID->tuid    # Generate a TUID with the default length

    $tuid = tuid uuid => '1bf4d967-9e4c-4414-9be0-26f31c16fb53' # Generate a TUID based of the give UUID

A sample run (length 4):

rrry
ggf5
m1qb
xczx
pv9y

A sample run (length 8):

5xcfw8nj
2q255fyg
pn3xns4k
1xcamd3y
eczzca9c

A sample run (no length limit):

2kdk8wzjmfapj28cvexj6qndq7
2tmzr1f3k46tr813dtrxx2vhkqkd
1x3608c39mb1n726dhmxedjy72d
pre6tg2dm37zbw9amxg2c8bghn
3ys0kw21rmtpf54gsmnd28r99pj

=head1 DESCRIPTION

Data::TUID is a tool for creating small, communicable pseudo-unique identifiers. Essentially it
will take a UUID, pass the result through L<Encode::Base32::Crockford>, and resize accordingly (via
C<substr>)

Although I've tried to sample the UUID evenly, this technique does not give any guarantee on uniqueness. Caveat emptor.

Finally, the result is more communicable (and smaller) due to the Crockford base 32 encoding. The Crockford technique
uses:

    A case-insensitive mapping
    1 in place of '1','I', 'i', and 'L'
    0 in place of '0', 'O', and 'o'

So, given a TUID (say something a user typed in for a URL), you can translate ambiguous characters (1, I, i, L, 0, 0, and o) into to 1 and 0.

=head1 USAGE

=head1 Data::TUID->tuid( ... )

=head1 Data::TUID::tuid( ... )

=head1 tuid ...

The arguments are:

    uuid    The UUID to use as a basis for the TUID. If none is given, one will be generated for you

    length  The length of the TUID returned. By default 8. A length of -1 will result in the whole
            UUID being used, and a variable length TUID being returned (somewhere between 25 to 28)
            
=head1 SEE ALSO

L<Encode::Base32::Crockford>

L<Data::UUID::LibUUID>

=cut

our $VERSION = '0.01';
use vars qw/@ISA @EXPORT/; @ISA = qw/Exporter/; @EXPORT = qw/tuid/;

use Encode::Base32::Crockford qw/base32_encode/;
use Data::UUID::LibUUID qw/new_uuid_binary uuid_to_binary/;

sub tuid {
    shift if @_ && $_[0] eq __PACKAGE__;
    my %given;
    if ( @_ == 1 ) {
        %given = ( length => shift );
    }
    else {
        %given = @_;
    }

    my $uuid = $given{uuid} || new_uuid_binary;
    $uuid = uuid_to_binary $uuid;

    my @tuid = map { lc base32_encode $_ } unpack 'L*', new_uuid_binary;

    my $all;
    my $size = $given{size};
    my $length = $given{length};
    if ( $length && ( $length == -1 || $length >= 28 ) || $size && $size == -1 ) {
        return join '', @tuid;
    }
    $length = 8 unless $length || $size;
    if ( ! $all && $length ) {
        $size = int( $length / 4 );
        $size += $length % 4;
    }
    $size = $size < 1 ? 1 : $size > 7 ? 7 : $size;

    @tuid = map { substr $_, -$size, $size } @tuid;
    my $tuid = join '', @tuid;
    $tuid = substr $tuid, 0, $length if $length;

    return $tuid;
}

=head1 AUTHOR

Robert Krimen, C<< <rkrimen at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-data-tuid at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Data-TUID>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Data::TUID


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Data-TUID>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Data-TUID>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Data-TUID>

=item * Search CPAN

L<http://search.cpan.org/dist/Data-TUID/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 Robert Krimen, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of Data::TUID
