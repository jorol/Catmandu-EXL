package Catmandu::Exporter::EXL::PNX;
use Catmandu::Sane;
use Catmandu::Util qw(xml_escape is_different :array :is);
use Moo;

with 'Catmandu::Exporter';

has record          => ( is => 'ro', default => sub {'record'} );
has xml_declaration => ( is => 'ro', default => sub { 0 } );
has collection      => ( is => 'ro' , default => sub { 0 } );
has _n              => ( is => 'rw', default => sub { 0 } );

# ToDo:
# https://github.com/dtulibrary/finditproxy/blob/master/xsd/primo_nm_bib.xsd
# set namespace
# use LibXML
# define root element

sub add {
    my ( $self, $data ) = @_;

    my $xml = "";

    if ( $self->_n == 0 ) {
        if ( $self->xml_declaration ) {
            $xml .= Catmandu::Util::xml_declaration;
        }
        if ($self->collection) {
            $xml .= '<PrimoNMBib>';
        }
        $self->_n(1);
    }

    $xml .= '<record>';

    my $record = $data->{pnx};

    foreach my $main_entry ( sort keys %{$record} ) {
        $xml .= "<$main_entry>";
        foreach my $sub_entry ( sort keys %{ $record->{$main_entry} } ) {
            my $content = $record->{$main_entry}->{$sub_entry};
            if ( ref $content eq 'ARRAY' ) {
                $xml .= "<$sub_entry>" . xml_escape($_) . "</$sub_entry>" for @{$content};

            }
            else {
                $xml .= "<$sub_entry>" . xml_escape($content) . "</$sub_entry>";
            }
        }
        $xml .= "</$main_entry>";
    }

    $xml .= '</record>';
    $self->fh->print($xml);
}

sub commit {
    my ($self) = @_;

    if($self->collection){
        $self->fh->print('</PrimoNMBib>');
    }

    $self->fh->flush;
}


1;

__END__

=encoding UTF-8

=head1 NAME

Catmandu::Exporter::EXL::PNX - Exporter for PNX records

=head1 SYNOPSIS

    # From the command line 
    $ catmandu convert MARC --type ALEPHXML --fix ./t/pnx.fix to EXL --type PNX < ./t/aleph.xml
    $ catmandu convert MARC --type ALEPHXML --fix ./t/pnx.fix to EXL --type PNX --xml_declaration 1 < ./t/aleph.xml

    # From Perl
    use Catmandu;

    my $importer = Catmandu::Importer::MARC( file => "./t/aleph.xml" , type => 'ALEPHXML');
    my $fixer    = Catmandu->fixer("./t/pnx.fix");
    my $exporter = Catmandu::Exporter::EXL->new( file => "pnx.xml", type => "PNX" );

    $exporter->add_many($fixer->fix($importer));
    $exporter->commit;

=head1 METHODS

=head2 new(file => $file , %opts)

Create a new L<Catmandu::Exporter::EXL::PNX> to serialize PNX records into XML. Provide the path
of a $file to write exported records to. Optionally the following paramters can be
specified:

    xml_declaration : add a xml declaration when true (default: true)

=head1 INHERTED METHODS

=head2 count

=head2 add($hashref)

=head2 add_many($array)

=head2 add_many($iterator)

=head2 add_many(sub {})

=head2 ...

All the L<Catmandu::Exporter> methods are inherited.

=head1 SEE ALSO

L<Catmandu::Exporter>

=cut
