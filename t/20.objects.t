use Modern::Perl;
use Test::More tests => 3;

use Text::TaskPaper;
use Data::Dumper::Concise;

my $tp = Text::TaskPaper::Line->new();
my( $content, $object );


# task objects for tasks
{
    $content = "- do this";
    $object  = $tp->get_object_for_line( $content );
    isa_ok( $object, 'Text::TaskPaper::Task' );
}

# project objects for projects
{
    $content = "Do stuff:";
    $object  = $tp->get_object_for_line( $content );
    isa_ok( $object, 'Text::TaskPaper::Project' );
}

# note objects for notes
{
    $content = "My word.";
    $object  = $tp->get_object_for_line( $content );
    isa_ok( $object, 'Text::TaskPaper::Note' );
}
