use Modern::Perl;
use Test::More tests => 18;

use Text::TaskPaper;
use Data::Dumper::Concise;

my( $note, @structure, %tags );



# create new task objects
{
    $note = Text::TaskPaper::Note->new( text => 'Some notes.' );
    
    ok( 'Note' eq $note->get_type() );
    ok( 'Some notes.' eq $note->get_text() );
    %tags = $note->get_tags();
    is_deeply( {}, \%tags )
        or print Dumper \%tags;
}

# shorthand for just text
{
    $note = Text::TaskPaper::Note->new( 'Some notes.' );
    
    ok( 'Note' eq $note->get_type() );
    ok( 'Some notes.' eq $note->get_text() );
    %tags = $note->get_tags();
    is_deeply( {}, \%tags )
        or print Dumper \%tags;
}

# tags in the shorthand text accepted
{
    $note = Text::TaskPaper::Note->new( 'Some notes. @dull' );
    
    ok( 'Note' eq $note->get_type() );
    ok( 'Some notes.' eq $note->get_text() );
    %tags = $note->get_tags();
    is_deeply( { dull => [], }, \%tags )
        or print Dumper \%tags;
}

# tags as structure accepted
{
    $note = Text::TaskPaper::Note->new( 
            text => 'Some notes.',
            tags => { dull => [], },
        );
    
    ok( 'Note' eq $note->get_type() );
    ok( 'Some notes.' eq $note->get_text() );
    %tags = $note->get_tags();
    is_deeply( { dull => [], }, \%tags )
        or print Dumper \%tags;
}

# tags as text accepted
{
    $note = Text::TaskPaper::Note->new( 
            text => 'Some notes.',
            tags => '@dull',
        );
    
    ok( 'Note' eq $note->get_type() );
    ok( 'Some notes.' eq $note->get_text() );
    %tags = $note->get_tags();
    is_deeply( { dull => [], }, \%tags )
        or print Dumper \%tags;
}

# tags in the text accepted
{
    $note = Text::TaskPaper::Note->new( 
            text => 'Some notes. @dull',
        );
    
    ok( 'Note' eq $note->get_type() );
    ok( 'Some notes.' eq $note->get_text() );
    %tags = $note->get_tags();
    is_deeply( { dull => [], }, \%tags )
        or print Dumper \%tags;
}
