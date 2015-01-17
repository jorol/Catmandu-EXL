package Catmandu::Importer::MARC::ALEPHXML;

our $VERSION = '0.02';

use strict;
use warnings;
use Carp qw<croak>;

use Catmandu::Sane;
use Moo;
use EXL::Parser::ALEPHXML;

with 'Catmandu::Importer';

has id => (is => 'ro' , default => sub { '001' });

sub generator {
    my $self = shift;
    my $parser = EXL::Parser::ALEPHXML->new($self->fh);
    sub {
        my $record = $parser->next();

        return undef unless defined $record;

        my $id;
        for my $field (@$record) {
            my ($field,$ind1,$ind2,$p,$data,@q) = @$field;
            if ($field eq $self->id) {
                $id = $data;
                last;
            }
        }

        +{ _id => $id , record => $record };
    };
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

EXL::Parser::ALEPHXML - ALEPHXML parser

=head1 SYNOPSIS

L<EXL::Parser::ALEPHXML> is a parser for ALEPHXML records.

    # On the command line
    catmandu convert MARC --type ALEPHXML to YAML < ./t/aleph.xml
    catmandu convert MARC --type ALEPHXML --fix ./t/pnx.fix < ./t/aleph.xml

    # In Perl
    use Catmandu;
    use Catmandu::Importer::MARC;

    my $importer = Catmandu::Importer::MARC->new(file => "./t/aleph.xml", type => "ALEPHXML");
    my $records = $importer->to_array();

=head1 Arguments

=over

=item C<file>

Path to file with ALEPHXML records.

=item C<fh>

Open filehandle for file with ALEPHXML records.

=item C<string>

XML string with ALEPHXML records.

=back

=head1 METHODS

=head2 new($filename | $filehandle | $string)

=head2 next()

Reads the next record from ALEPHXML input stream. Returns a Perl hash.

=head2 _decode($record)

Deserialize a ALEPHXML record to an an ARRAY of ARRAYs.

=head1 SEEALSO

L<Catmandu::EXL> and L<Catmandu::Importer::MARC>.

=head1 AUTHOR

Johann Rolschewski <rolschewski@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Johann Rolschewski.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
