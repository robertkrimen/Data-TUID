package Data::TUID;

use warnings;
use strict;

=head1 NAME

Data::TUID - A smaller and more communicable pseudo-UUID

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

use Encode::Base32::Crockford qw/base32_encode/;
use Data::UUID::LibUUID qw/new_uuid_binary uuid_to_binary/;

sub generate {
    return shift->tuid( @_ );
}

sub tuid {
    my $self = shift;
    my %given = @_;

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
