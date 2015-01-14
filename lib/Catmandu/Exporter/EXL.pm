package Catmandu::Exporter::EXL;
use Catmandu::Sane;
use Moo;

has type           => (is => 'ro' , default => sub { 'PNX' });
has _exporter      => (is => 'ro' , lazy => 1 , builder => '_build_exporter' , handles => 'Catmandu::Exporter');
has _exporter_args => (is => 'rwp', writer => '_set_exporter_args');

sub _build_exporter {
    my ($self) = @_;
    my $type = $self->type;
    
    my $pkg = Catmandu::Util::require_package($type,'Catmandu::Exporter::EXL');

    $pkg->new($self->_exporter_args);
}

sub BUILD {
    my ($self,$args) = @_;
    $self->_set_exporter_args($args);
}

1;
__END__

=encoding UTF-8

=head1 NAME

Catmandu::Exporter::EXL - Exporter for EXL records

=head1 SYNOPSIS

    # From the command line
    $ catmandu convert MARC --type ALEPHXML --fix ./t/pnx.fix to EXL --type PNX < ./t/aleph.xml

    # From Perl
    use Catmandu;

    my $importer = Catmandu->importer('MARC', file => "./t/aleph.xml" , type => 'ALEPHXML');
    my $fixer    = Catmandu->fixer("./t/pnx.fix");
    my $exporter = Catmandu->exporter('EXL', file => "pnx.xml", type => "PNX" );

    $exporter->add_many($fixer->fix($importer);
    $exporter->commit;

=head1 METHODS

=head2 new(file => $file, type => $type)

Create a new L<Catmandu::Exporter> which serializes PNX records into a $file. 
Type describes the EXL serializer to be used. Currently we support: 

=over 2

=item  PNX    L<Catmandu::Exporter::EXL::PNX>

=back

Read the documentation of the parser modules for extra configuration options.

=head1 SEE ALSO

L<Catmandu::Exporter>

=cut