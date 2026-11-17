#!/usr/bin/env perl

# The release checks that are easy to forget: every module carries the same
# $VERSION as the distribution, the topmost entry of Changes is that version
# and has a date, and the README and the POD VERSION sections say the same.

use strict;
use warnings;

use Test::Most;

use File::Spec;
use FindBin qw($Bin);

my $root = File::Spec->catdir($Bin, File::Spec->updir());
my $lib = File::Spec->catdir($root, 'lib');

require "$lib/Web/VWF.pm";
my $version = "$Web::VWF::VERSION";

my @modules = glob("$lib/Web/VWF/*.pm $lib/Web/VWF/*/*.pm");
push @modules, "$lib/Web/VWF.pm";
ok(scalar(@modules) > 10, 'found the modules');

sub slurp
{
	my $path = shift;

	open(my $fh, '<', $path) or die "Cannot read $path: $!";
	local $/;
	return scalar <$fh>;
}

foreach my $file (@modules) {
	my $source = slurp($file);
	(my $name = $file) =~ s/^\Q$lib\E.//;

	if($source =~ /our \$VERSION = version->declare\('([^']+)'\)/) {
		is($1, $version, "$name has the distribution's version");
	} else {
		fail("$name declares \$VERSION with version->declare");
	}

	if($source =~ /^=head1 VERSION\s+Version (\S+)/m) {
		is($1, $version, "${name}'s VERSION section agrees");
	}
}

# The first version line, whether or not it has a date: an entry that has not
# been dated yet is the one about to be released, and must not be skipped in
# favour of the previous release's, which would make this test pass at the one
# moment it matters.
my $changes = slurp(File::Spec->catfile($root, 'Changes'));
if($changes =~ /^(\d+\.\d+\.\d+)(?:\t(\S.*))?$/m) {
	is($1, $version, 'the topmost Changes entry is the current version');
	like($2 // '', qr/\b20\d\d\b/, 'and it has a date');
} else {
	fail('Changes has a top entry with a version');
}

# Every module that ships, the example site's too
my @example = glob("$root/example/lib/Web/VWF/*/*.pm");
foreach my $file (@example) {
	my $source = slurp($file);
	(my $name = $file) =~ s/^\Q$root\E.//;
	if($source =~ /our \$VERSION = version->declare\('([^']+)'\)/) {
		is($1, $version, "$name has the distribution's version");
	} else {
		fail("$name declares \$VERSION with version->declare");
	}
}

like(slurp(File::Spec->catfile($root, 'README.md')), qr/^Version \Q$version\E$/m, 'README.md has the current version');

done_testing();
