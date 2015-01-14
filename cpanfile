requires 'perl', 'v5.10.1';
requires 'Catmandu', '>= 0.9103';
requires 'Catmandu::SRU', '>= 0.032';
requires 'Catmandu::MARC', '>= 0.207';
requires 'XML::LibXML::Reader', '>= 2.0';

on test => sub {
    requires 'Test::More', '0.96';
};
