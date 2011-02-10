use ExtUtils::MakeMaker::Dist::Zilla::Develop;
use ExtUtils::Depends;

# NOTE:
# This is a very simple Makefile.PL I only use to build the distribution
# locally while working on it.  The real Makefile.PL, with all required
# information like dependencies, is generated later by Dist::Zilla

WriteMakefile(
    NAME => 'bareword::filehandles',
    ExtUtils::Depends->new('bareword::filehandles',
                           'B::Hooks::OP::Check')->get_makefile_vars,
);
