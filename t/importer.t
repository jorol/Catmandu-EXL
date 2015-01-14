use strict;
use warnings;
use Test::More;

use Catmandu;
use Catmandu::Importer::MARC;

my $importer = Catmandu::Importer::MARC->new(file => "./t/aleph.xml", type => "ALEPHXML");
my $records = $importer->to_array();

ok( @$records == 2, 'got all records' );
ok( $records->[0]->{'_id'} eq 'BV039697287', 'got _id' );
is_deeply($records->[0]->{record}->[0], ['LDR', '', '', '_', '00000pM2.01200024------h'], 'got leader');
is_deeply($records->[0]->{record}->[2], ['001', ' ', '1', 'a', 'BV039697287'], 'got field');
ok( $records->[0]->{'_id'} eq $records->[0]->{'record'}->[2][-1], '_id matches record id' );
ok( $records->[1]->{'_id'} eq 'BV039697288', 'next record' );

done_testing;