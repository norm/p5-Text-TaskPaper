use Modern::Perl;
use Test::More tests => 18;

use Text::TaskPaper;
use Data::Dumper::Concise;

my( $task, @structure, %tags );



# create new task objects
{
    $task = Text::TaskPaper::Task->new( text => 'easy task' );
    
    ok( 'Task' eq $task->get_type() );
    ok( 'easy task' eq $task->get_text() );
    %tags = $task->get_tags();
    is_deeply( {}, \%tags )
        or print Dumper \%tags;
}

# shorthand for just text
{
    $task = Text::TaskPaper::Task->new( 'easy task' );
    
    ok( 'Task' eq $task->get_type() );
    ok( 'easy task' eq $task->get_text() );
    %tags = $task->get_tags();
    is_deeply( {}, \%tags )
        or print Dumper \%tags;
}

# tags in the shorthand text accepted
{
    $task = Text::TaskPaper::Task->new( 'easy task @due' );
    
    ok( 'Task' eq $task->get_type() );
    ok( 'easy task' eq $task->get_text() );
    %tags = $task->get_tags();
    is_deeply( { due => [], }, \%tags )
        or print Dumper \%tags;
}

# tags as structure accepted
{
    $task = Text::TaskPaper::Task->new( 
            text => 'easy task',
            tags => { due => [], },
        );
    
    ok( 'Task' eq $task->get_type() );
    ok( 'easy task' eq $task->get_text() );
    %tags = $task->get_tags();
    is_deeply( { due => [], }, \%tags )
        or print Dumper \%tags;
}

# tags as text accepted
{
    $task = Text::TaskPaper::Task->new( 
            text => 'easy task',
            tags => '@due',
        );
    
    ok( 'Task' eq $task->get_type() );
    ok( 'easy task' eq $task->get_text() );
    %tags = $task->get_tags();
    is_deeply( { due => [], }, \%tags )
        or print Dumper \%tags;
}

# tags in the text accepted
{
    $task = Text::TaskPaper::Task->new( 
            text => 'easy task @due',
        );
    
    ok( 'Task' eq $task->get_type() );
    ok( 'easy task' eq $task->get_text() );
    %tags = $task->get_tags();
    is_deeply( { due => [], }, \%tags )
        or print Dumper \%tags;
}
