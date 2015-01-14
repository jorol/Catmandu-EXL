package EXL::Parser::ALEPHXML;

our $VERSION = '0.01';

use strict;
use warnings;
use Carp qw<croak>;
use XML::LibXML::Reader;


sub new {
    my $class = shift;
    my $input  = shift;

    my $self = {
        filename   => undef,
        rec_number => 0,
        xml_reader => undef,
    };

    # check for file or filehandle
    my $ishandle = eval { fileno($input); };
    if ( !$@ && defined $ishandle ) {
        binmode $input; # drop all PerlIO layers, as required by libxml2
        my $reader = XML::LibXML::Reader->new( IO => $input )
            or croak "cannot read from filehandle $input\n";
        $self->{filename}   = scalar $input;
        $self->{xml_reader} = $reader;
    }
    elsif ( defined $input && $input !~ /\n/ && -e $input ) {
        my $reader = XML::LibXML::Reader->new( location => $input )
            or croak "cannot read from file $input\n";
        $self->{filename}   = $input;
        $self->{xml_reader} = $reader;
    }
    elsif ( defined $input && length $input > 0 ) {
        my $reader = XML::LibXML::Reader->new( string => $input )
            or croak "cannot read XML string $input\n";
        $self->{xml_reader} = $reader;
    }
    else {
        croak "file, filehande or string $input does not exists";
    }
    return ( bless $self, $class );
}


sub next {
    my $self = shift;

    # get only <record> elements from 'mabxml' namespace
    # skip <record> elements from 'oai' namespace
    if ( $self->{xml_reader}->nextElement('record', 'http://www.ddb.de/professionell/mabxml/mabxml-1.xsd') ) {
        $self->{rec_number}++;
        my $record = _decode( $self->{xml_reader} );
        return $record;
    }
    return;
}


sub _decode {
    my $reader = shift;
    my @record;

    # get all field nodes from record;
    foreach my $field_node (
        $reader->copyCurrentNode(1)->getChildrenByTagName('*') )
    {
        my @field;

        # get field tag number or skip element (e.g. <leader>)
        my $tag = $field_node->getAttribute('tag') or next;

        # get 1. indicator, ignore second
        my $ind1 = $field_node->getAttribute('ind1') // '';
        $ind1 =~ s/-/ /;
        my $ind2 = $field_node->getAttribute('ind2') // '';
        $ind2 =~ s/-/ /;

        # ToDo: textContent ignores </tf> and <ns>

        # Check for data or subfields
        if ( my @subfields = $field_node->getChildrenByTagName('*') ) {
            push( @field, ( $tag, $ind1, $ind2 ) );

            # get all subfield nodes
            foreach my $subfield_node (@subfields) {
                my $subfield_code = $subfield_node->getAttribute('code');
                my $subfield_data = $subfield_node->textContent;
                push( @field, ( $subfield_code, $subfield_data ) );
            }
        }
        else {
            my $data = $field_node->textContent();
            push( @field, ( $tag, $ind1, $ind2, '_', $data ) );
        }

        push( @record, [@field] );
    }
    return \@record;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

EXL::Parser::ALEPHXML - ALEPHXML parser

=head1 SYNOPSIS

EXL::Parser::ALEPHXML is a parser for ALEPHXML records.

    use EXL::Parser::ALEPHXML;

    my $parser = EXL::Parser::ALEPHXML->new( $filename );

    while ( my $record_hash = $parser->next() ) {
        # do something        
    }

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

L<Catmandu::EXL>.

=head1 AUTHOR

Johann Rolschewski <rolschewski@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Johann Rolschewski.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
