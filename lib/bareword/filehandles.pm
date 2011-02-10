package bareword::filehandles;
# ABSTRACT: disables bareword filehandles

{ use 5.008; }
use strict;
use warnings;

use Lexical::SealRequireHints;
use B::Hooks::OP::Check;
use XSLoader;

XSLoader::load(
    __PACKAGE__,
    # we need to be careful not to touch $VERSION at compile time, otherwise
    # DynaLoader will assume it's set and check against it, which will cause
    # fail when being run in the checkout without dzil having set the actual
    # $VERSION
    exists $bareword::filehandles::{VERSION} ? ${ $bareword::filehandles::{VERSION} } : (),
);

=head1 SYNOPSIS

    no bareword::filehandles;

    open FH, $file            # dies
    open my $fh, $file;       # doesn't die

    print FH $string          # dies
    print STDERR $string      # doesn't die

=head1 DESCRIPTION

This module disables the use of bareword filehandles in a lexical scope.

=method unimport

Disables bareword filehandles for the remainder of the scope being
compiled.

=cut

sub unimport { $^H |= 0x20000; $^H{+(__PACKAGE__)} = 1 }

=method import

Enables bareword filehandles for the remainder of the scope being
compiled;

=cut

sub import { delete $^H{+(__PACKAGE__)} }

=head1 SEE ALSO

L<perlfunc>,
L<B::Hooks::OP::Check>.

=cut

1;
