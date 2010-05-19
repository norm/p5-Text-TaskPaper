use Modern::Perl;
use Test::More tests => 8;

use_ok( 'Text::TaskPaper' );

my $tp = Text::TaskPaper->new();
isa_ok( $tp, 'Text::TaskPaper::Line' );

my $task = Text::TaskPaper::Task->new();
isa_ok( $task, 'Text::TaskPaper::Line' );
isa_ok( $task, 'Text::TaskPaper::Task' );

my $note = Text::TaskPaper::Note->new();
isa_ok( $note, 'Text::TaskPaper::Line' );
isa_ok( $note, 'Text::TaskPaper::Note' );

my $project = Text::TaskPaper::Project->new();
isa_ok( $project, 'Text::TaskPaper::Line' );
isa_ok( $project, 'Text::TaskPaper::Project' );
