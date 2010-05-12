use Modern::Perl;
use Test::More tests => 16;

use Text::TaskPaper;
use Data::Dumper::Concise;

my( $tp, @children, @structure );



# adding new tasks works
{
    push @structure, Text::TaskPaper::Task->new( text => 'new task' );
    push @structure, Text::TaskPaper::Task->new( text => 'second new task' );
    $tp = Text::TaskPaper->new();
    $tp->add_child( type => 'Task', text => 'new task' );
    $tp->add_child( type => 'Task', text => 'second new task' );
    
    @children = $tp->get_items();
    ok( scalar @children == 2 );
    is_deeply( \@children, \@structure )
        or print Dumper \@children;
    
    $tp = Text::TaskPaper->new();
    $tp->add_task( text => 'new task' );
    $tp->add_task( text => 'second new task' );
    
    @children = $tp->get_items();
    ok( scalar @children == 2 );
    is_deeply( \@children, \@structure )
        or print Dumper \@children;
}

# adding new projects works
{
    undef @structure;
    push @structure, Text::TaskPaper::Project->new( text => 'Big Project' );
    push @structure, Text::TaskPaper::Project->new( text => 'Bigger Project' );
    $tp = Text::TaskPaper->new();
    $tp->add_child( type => 'Project', text => 'Big Project' );
    $tp->add_child( type => 'Project', text => 'Bigger Project' );
    
    @children = $tp->get_items();
    ok( scalar @children == 2 );
    is_deeply( \@children, \@structure )
        or print Dumper \@children;
    
    $tp = Text::TaskPaper->new();
    $tp->add_project( text => 'Big Project' );
    $tp->add_project( text => 'Bigger Project' );
    
    @children = $tp->get_items();
    ok( scalar @children == 2 );
    is_deeply( \@children, \@structure )
        or print Dumper \@children;
}

# adding new notes works
{
    undef @structure;
    push @structure, Text::TaskPaper::Note->new( text => 'something of note' );
    push @structure, Text::TaskPaper::Note->new( text => 'b#' );
    $tp = Text::TaskPaper->new();
    $tp->add_child( type => 'Note', text => 'something of note' );
    $tp->add_child( type => 'Note', text => 'b#' );

    @children = $tp->get_items();
    ok( scalar @children == 2 );
    is_deeply( \@children, \@structure )
        or print Dumper \@children;

    $tp = Text::TaskPaper->new();
    $tp->add_note( text => 'something of note' );
    $tp->add_note( text => 'b#' );

    @children = $tp->get_items();
    ok( scalar @children == 2 );
    is_deeply( \@children, \@structure )
        or print Dumper \@children;
}

# adding all three types works
{
    undef @structure;
    push @structure, Text::TaskPaper::Project->new( text => 'Big Project' );
    push @structure, Text::TaskPaper::Task->new( text => 'new task' );
    push @structure, Text::TaskPaper::Note->new( text => 'something of note' );
    $tp = Text::TaskPaper->new();
    $tp->add_child( type => 'Project', text => 'Big Project' );
    $tp->add_child( type => 'Task', text => 'new task' );
    $tp->add_child( type => 'Note', text => 'something of note' );

    @children = $tp->get_items();
    ok( scalar @children == 3 );
    is_deeply( \@children, \@structure )
        or print Dumper \@children;

    $tp = Text::TaskPaper->new();
    $tp->add_project( text => 'Big Project' );
    $tp->add_task( text => 'new task' );
    $tp->add_note( text => 'something of note' );

    @children = $tp->get_items();
    ok( scalar @children == 3 );
    is_deeply( \@children, \@structure )
        or print Dumper \@children;
}

