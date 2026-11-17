package Web::VWF::Display::states;

# Display the states page: every row of states.csv, as a table.
# The rows come from the states data handle, which the framework passes to
# every page under the last part of the data module's name.

use strict;
use warnings;

use version; our $VERSION = version->declare('0.002.0');

use Carp;
use Web::VWF::Display;

our @ISA = ('Web::VWF::Display');

sub html {
	my $self = shift;
	my %args = (ref($_[0]) eq 'HASH') ? %{$_[0]} : @_;

	my $states = $args{'states'};
	croak("Missing 'states' handle") unless($states);

	# Sorted by name, as people look states up by name; the CSV is in the
	# order of the codes.  An empty database gives an empty list rather than
	# undef so the template can always loop over it.
	my $rows = $states->selectall_arrayref(sort_by => 'name') || [];

	return $self->SUPER::html(states => $rows);
}

1;
