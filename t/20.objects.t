use Modern::Perl;
use Test::More tests => 6;

use Text::TaskPaper;
use Data::Dumper::Concise;

my $tp = Text::TaskPaper::Line->new();
my( $content, $object );


# task objects for tasks
{
    $content = "- do this";
    $object  = $tp->get_object_for_line( $content );
    isa_ok( $object, 'Text::TaskPaper::Task' );
    ok( 'Task' eq $object->get_type() );
}

# project objects for projects
{
    $content = "Do stuff:";
    $object  = $tp->get_object_for_line( $content );
    isa_ok( $object, 'Text::TaskPaper::Project' );
    ok( 'Project' eq $object->get_type() );
}

# note objects for notes
{
    $content = "My word.";
    $object  = $tp->get_object_for_line( $content );
    isa_ok( $object, 'Text::TaskPaper::Note' );
    ok( 'Note' eq $object->get_type() );
}
