#!/usr/bin/env perl

# The <pages> setting: one <page> element for each page, with a name and a
# description.  Config::Abstraction hands a single <page> over as a hash and
# several as an array, and the old string of names is still accepted.

use strict;
use warnings;

use Test::Most;

use File::Spec;
use FindBin qw($Bin);

BEGIN {
	require lib;
	lib->import(File::Spec->catdir($Bin, File::Spec->updir(), 'lib'));
}

use Web::VWF;

sub pages
{
	return [Web::VWF->_config_pages({ pages => shift })];
}

is_deeply(pages({ page => { name => 'states', description => 'About states' } }),
	[{ name => 'states', description => 'About states' }], 'one page is a hash');

is_deeply(pages({ page => [{ name => 'a', description => 'A' }, { name => 'b' }] }),
	[{ name => 'a', description => 'A' }, { name => 'b', description => '' }],
	'several pages are an array, in order, and a missing description is empty');

is_deeply(pages({ page => [{ name => 'a' }, { name => 'a' }] }),
	[{ name => 'a', description => '' }], 'a repeated page is dropped');

is_deeply(pages({ page => [{ description => 'no name' }, { name => '' }, { name => 'ok' }] }),
	[{ name => 'ok', description => '' }], 'a page without a name is dropped');

is_deeply(pages('index, meta_data'),
	[{ name => 'index', description => '' }, { name => 'meta_data', description => '' }],
	'the old string form still works');

is_deeply(pages(undef), [], 'no setting gives no pages');

is_deeply([Web::VWF->_valid_pages({ pages => { page => [{ name => 'a' }, { name => 'bad name' }] } })],
	['a'], 'only word-character names are valid pages');

is_deeply({ Web::VWF->_page_descriptions({ pages => { page => [{ name => 'a', description => 'A' }, { name => 'b' }] } }) },
	{ a => 'A' }, 'only described pages have a description');

done_testing();
