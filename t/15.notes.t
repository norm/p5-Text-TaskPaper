use Modern::Perl;
use Test::More tests => 1;

use Text::TaskPaper;
use Data::Dumper::Concise;

my $tp = Text::TaskPaper::Line->new();
my( $content, @structure, @parsed );



# anything not a task or project is a note
{
    $content = "My word.";
    @structure = (
        { type => 'Note', text => 'My word.', tags => {} }
    );
    
    @parsed = $tp->parse_line( $content );
    is_deeply( \@structure, \@parsed )
        or print Dumper \@parsed;
}
