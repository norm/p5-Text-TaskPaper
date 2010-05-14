use Modern::Perl;
use Test::More tests => 2;

use Text::TaskPaper;
use Data::Dumper::Concise;

use constant DOCUMENT => 't/40.tasks.taskpaper';

my( $tp, $document, @document, @structure, $child );



# read in the test file to be used as "string" source
open my $handle, '<', DOCUMENT;
$document = do { local $/; <$handle>; };

# construct the same document manually for structure checking
my $task = Text::TaskPaper::Task->new( text => 'First Task' );
$task->add_task( text => 'Subordinate Task' );
push @structure, $task;
$task = Text::TaskPaper::Task->new( text => 'Second Task' );
push @structure, $task;


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
