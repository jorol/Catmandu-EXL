package Catmandu::Fix::lds38;
use Catmandu::Sane;
use Catmandu::Util qw(is_string);

sub new {
    my ($class,$path) = @_;
    return bless { path => $path } , $class;
}

sub fix {
    my ($self,$data) = @_;
    my @path  = split(/\./,$self->{path});
    my $key = eval '$data'.(join '', map "->{$_}", @path ) or die "path ". $self->{path} . " does not exists";
    $data->{pnx}->{display}->{lds38} = [] unless exists $data->{pnx}->{display}->{lds38};
    foreach my $arr_ref (@{$key}) {
        if (is_string($arr_ref->[0]) && $arr_ref->[0] eq 'SRD') {
            my $lds38 = $arr_ref->[1] . ' FUB_ALEPH' . $arr_ref->[2];
            $lds38 =~ s/\^/ /g;
            push @{$data->{pnx}->{display}->{lds38}}, $lds38;
         } 
    }
    $data;
}

1;