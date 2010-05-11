use Modern::Perl;
use Test::More tests => 4;

use Text::TaskPaper;



# no source generates an empty item
{
    my $tp = Text::TaskPaper->new();
    isa_ok( $tp, 'Text::TaskPaper::Line' );
}

# content comes from a string
{
    my $tp = Text::TaskPaper->new( string => "I am a note.\n" );
    isa_ok( $tp, 'Text::TaskPaper::Line' );
}

# content comes from a file
{
    my $tp = Text::TaskPaper->new( file => 't/01.file.taskpaper' );
    isa_ok( $tp, 'Text::TaskPaper::Line' );
}

# non-existing file causes an error
{
    my $tp = Text::TaskPaper->new( file => 't/01.doesnotexist.taskpaper' );
    ok( !defined $tp );
}
