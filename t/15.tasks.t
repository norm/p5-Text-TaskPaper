use Modern::Perl;
use Test::More tests => 4;

use Text::TaskPaper;
use Data::Dumper::Concise;

my $tp = Text::TaskPaper::Line->new();
my( $content, @structure, @parsed );



# tasks start with a dash-space combination
{
    $content = "- easy task";
    @structure = (
        { type => 'Task', text => 'easy task', tags => {} }
    );
    
    @parsed = $tp->parse_line( $content );
    is_deeply( \@structure, \@parsed )
        or print Dumper \@parsed;
}

# tasks can have tags
{
    $content = "- task to do urgently \@today";
    @structure = (
        {
            type => 'Task',
            text => 'task to do urgently',
            tags => { today => [] }
        },
    );
    
    @parsed = $tp->parse_line( $content );
    is_deeply( \@structure, \@parsed )
        or print Dumper \@parsed;
}

# tasks trump projects
{
    $content = "- task with subtasks:";
    @structure = (
        { type => 'Task', text => 'task with subtasks:', tags => {} }
    );
    
    @parsed = $tp->parse_line( $content );
    is_deeply( \@structure, \@parsed )
        or print Dumper \@parsed;
}

# dash-space combination must be the first thing on the line
{
    $content = " - hard task";
    @structure = (
        { type => 'Note', text => ' - hard task', tags => {} }
    );
    
    @parsed = $tp->parse_line( $content );
    is_deeply( \@structure, \@parsed )
        or print Dumper \@parsed;
}
