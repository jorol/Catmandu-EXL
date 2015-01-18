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

=head1 NAME
 
Catmandu::Fix::lds38 - custom Fix for PNX element <lds38>
 
=head1 SYNOPSIS
 
    # get subfields in sorted order, join them and store them in tmp variable
    marc_map('PLKanb','tmp.plk.$append', -pluck => 1, -join => '~~~')
    # split string to array
    split_field('tmp.plk.*','~~~')
    # apply fix on given path
    lds38('tmp.plk')
    remove_field('tmp.plk')

=head1 DESCRPTION

The datastructure referenced by 'path' must be an array of arrays ([[$sf_a, $sf_n, $sf_b],...])

Checks if subfield 'a' matches 'SDR' and adds new element to path 'pnx.display.lds38'.

=head1 SEE ALSO
 
L<Catmandu::Fix>, L<Catmandu::EXL>.
 
=cut

1;