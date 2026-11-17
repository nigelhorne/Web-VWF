package Web::VWF::Data::states;

# The database associated with the states page: states.csv in the database
# directory, one row for each of the 50 U.S. states.
#
# The file is a standard comma-separated file with a header line, which is
# not what Database::Abstraction assumes (it defaults to "!" as the separator
# and to a key column called "entry"), so both are set here.  The key column
# is "state", the two letter code, so a single state can be fetched with
#	$states->fetchrow_hashref(state => 'NY')

use strict;
use warnings;

use Database::Abstraction;

use version; our $VERSION = version->declare('0.002.0');

our @ISA = ('Database::Abstraction');

sub new {
	my $class = shift;
	my %args = (ref($_[0]) eq 'HASH') ? %{$_[0]} : @_;

	# Caller's arguments come last so a site can still override either setting
	return $class->SUPER::new(id => 'state', sep_char => ',', %args);
}

1;
