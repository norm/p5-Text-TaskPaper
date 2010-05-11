use Modern::Perl;
use Test::More tests => 3;

use Text::TaskPaper;
use Data::Dumper::Concise;

my $tp = Text::TaskPaper::Line->new();
my( $content, @structure, @parsed );



# projects end with a colon
{
    $content = "Big Project:";
    @structure = (
        { type => 'Project', text => 'Big Project', tags => {} }
    );
    
    @parsed = $tp->parse_line( $content );
    is_deeply( \@structure, \@parsed )
        or print Dumper \@parsed;
}

# whitespace after the colon breaks it being a project
{
    $content = "Big Project: ";
    @structure = (
        { type => 'Note', text => 'Big Project: ', tags => {} }
    );
    
    @parsed = $tp->parse_line( $content );
    is_deeply( \@structure, \@parsed )
        or print Dumper \@parsed;
}

# projects can have tags
{
    $content = "Big Project: \@important";
    @structure = (
        {
            type => 'Project',
            text => 'Big Project',
            tags => { important => [] },
        }
    );
    
    @parsed = $tp->parse_line( $content );
    is_deeply( \@structure, \@parsed )
        or print Dumper \@parsed;
}
