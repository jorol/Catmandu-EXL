package Catmandu::EXL;

use strict;
use 5.008_005;
our $VERSION = '0.01';

1;
__END__

=encoding UTF-8

=head1 NAME

Catmandu::EXL - Tools for ALEPHXML and PNX records

=head1 SYNOPSIS

    # On the command line

    catmandu convert MARC --type ALEPHXML to YAML < ./t/aleph.xml
    catmandu convert MARC --type ALEPHXML --fix ./t/pnx.fix to PNX < ./t/aleph.xml

    # In Perl 

    use EXL::Parser::ALEPHXML;

    my $parser = EXL::Parser::ALEPHXML->new( './t/aleph.xml' );
    my $record = $parser->next();

    # In Perl with Catmandu

    use Catmandu;
    use Catmandu::Importer::MARC;

    my $importer = Catmandu::Importer::MARC->new(file => "./t/aleph.xml", type => "ALEPHXML");
    my $records = $importer->to_array();

=head1 DESCRIPTION

I<Experimental release>

Catmandu::EXL  provides methods, classes, and functions to process ALEPHXML and PNX records in Perl.

ALEPHXML is an export data format of Aleph library systems used in Germany. It is a mix of the Machine Readable Cataloging format (MARC) and the Maschinelles Austauschformat fuer Bibliotheken (MAB), see L<https://wiki1.hbz-nrw.de/pages/viewpage.action?pageId=13238276> for a more detailed description.

Primo Normalized XML (PNX) is a data format for the Primo discovery system.  

Records in Catmandu::EXL are encoded either as as array of arrays, the inner arrays representing record fields, or as an object with two fields, _id and record, the latter holding the record as array of arrays, and the former holding the record identifier, stored in field 001.

=head1 AUTHOR

Johann Rolschewski E<lt>rolschewski@gmail.comE<gt>

=head1 COPYRIGHT

Copyright 2015- Johann Rolschewski

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Catmandu>.

=cut
