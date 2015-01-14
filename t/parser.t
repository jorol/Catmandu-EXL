use strict;
use warnings;
use Test::More;
use utf8;

use EXL::Parser::ALEPHXML;

my $parser = EXL::Parser::ALEPHXML->new( './t/aleph.xml' );

isa_ok( $parser, 'EXL::Parser::ALEPHXML' );

my $record = $parser->next();

is_deeply($record->[0], ['LDR', '', '', '_', '00000pM2.01200024------h'], 'got leader');
is_deeply($record->[2], ['001', ' ', '1', 'a', 'BV039697287'], 'got field');
$record = $parser->next();
is_deeply($record->[2], ['001', ' ', '1', 'a', 'BV039697288'], 'got next record');

done_testing;