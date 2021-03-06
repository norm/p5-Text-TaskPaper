use Modern::Perl;
use Test::More tests => 2;

use Text::TaskPaper;
use Data::Dumper::Concise;

use constant DOCUMENT => 't/40.projects.taskpaper';

my( $tp, $document, @document, @structure, $child );



# read in the test file to be used as "string" source
open my $handle, '<', DOCUMENT;
$document = do { local $/; <$handle>; };

# construct the same document manually for structure checking
my $project = Text::TaskPaper::Project->new( text => 'First Project' );
$project->add_project( text => 'Subordinate Project' );
push @structure, $project;
$project = Text::TaskPaper::Project->new( text => 'Second Project' );
push @structure, $project;


# parse the document as a string
{
    $tp = Text::TaskPaper->new( string => $document );
    
    @document = $tp->get_lines();
    is_deeply( \@structure, \@document )
        or print Dumper \@document;
}

# parse the document as a file
{
    $tp = Text::TaskPaper->new( file => DOCUMENT );
    
    @document = $tp->get_lines();
    is_deeply( \@structure, \@document )
        or print Dumper \@document;
}
