use Modern::Perl;
use Test::More tests => 2;

use_ok( 'Text::TaskPaper' );

my $tp = Text::TaskPaper->new();
isa_ok( $tp, 'Text::TaskPaper::Line' );
