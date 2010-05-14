use Modern::Perl;
use Test::More tests => 2;

use Text::TaskPaper;
use Data::Dumper::Concise;

use constant DOCUMENT => 't/40.notes.taskpaper';

my( $tp, $document, @document, @structure, $child );



# read in the test file to be used as "string" source
open my $handle, '<', DOCUMENT;
$document = do { local $/; <$handle>; };

# construct the same document manually for structure checking
my $note = Text::TaskPaper::Note->new( text => 'First note.' );
$note->add_note( text => 'Subordinate note.' );
push @structure, $note;
$note = Text::TaskPaper::Note->new( text => '' );
push @structure, $note;
$note = Text::TaskPaper::Note->new( text => 'Second note.' );
push @structure, $note;


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
