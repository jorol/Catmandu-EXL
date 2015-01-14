use strict;
use warnings;
use Test::More;

use Catmandu;
use Catmandu::Exporter::EXL;

my $record = {
    pnx => {
        control => {
            recordid     => '0001',
            sourceformat => 'MAB'
        },
        display => {
            title   => 'Title',
            creator => 'Creator',
        },
        addData => { issn => [ '0000-1111', '2222-3333' ] }
    }
};

my $record_xml = '<record><addData><issn>0000-1111</issn><issn>2222-3333</issn></addData><control><recordid>0001</recordid><sourceformat>MAB</sourceformat></control><display><creator>Creator</creator><title>Title</title></display></record>';
my $export_xml = "";

my $exporter = Catmandu::Exporter::EXL->new( file => \$export_xml, type => "PNX" );
ok($exporter, "create exporter PNX");
isa_ok( $exporter, 'Catmandu::Exporter::EXL');
$exporter->add($record);
$exporter->commit;
is($export_xml, $record_xml, 'created PNX XML');

done_testing();