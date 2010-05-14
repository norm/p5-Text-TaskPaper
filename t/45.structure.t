use Modern::Perl;
use Test::More tests => 2;

use Text::TaskPaper;
use Data::Dumper::Concise;

use constant DOCUMENT => 't/45.structure.taskpaper';

my( $tp, $document, @document, @structure, $child );



# read in the test file to be used as "string" source
open my $handle, '<', DOCUMENT;
$document = do { local $/; <$handle>; };

# construct the same document manually for structure checking
my $task = Text::TaskPaper::Task->new( text => 'Task' );
push @structure, $task;
my $note = Text::TaskPaper::Note->new( text => 'Note.' );
push @structure, $note;
my $project = Text::TaskPaper::Project->new( text => 'Project' );
$project->add_task( text => 'Task' );
$task = Text::TaskPaper::Task->new( text => 'Second task' );
$task->add_note( text => 'Note for the second task.' );
$project->add_child( object => $task );
my $subtasks = Text::TaskPaper::Task->new( text => 'Task with subtasks:' );
$subtasks->add_task( text => 'First' );
$subtasks->add_task( text => 'Second' );
$project->add_child( object => $subtasks );
push @structure, $project;
$note = Text::TaskPaper::Note->new( text => '' );
push @structure, $note;
$project = Text::TaskPaper::Project->new( text => 'Second' );
$project->add_task( text => 'Task' );
push @structure, $project;


# parse the document as a string
{
    $tp = Text::TaskPaper->new( string => $document );
    
    @document = $tp->get_items();
    is_deeply( \@structure, \@document )
        or print Dumper \@document;
}

# parse the document as a file
{
    $tp = Text::TaskPaper->new( file => DOCUMENT );
    
    @document = $tp->get_items();
    is_deeply( \@structure, \@document )
        or print Dumper \@document;
}
