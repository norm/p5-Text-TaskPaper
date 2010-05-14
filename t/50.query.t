use Modern::Perl;
use Test::More tests => 20;

use Text::TaskPaper;

use constant DOCUMENT => 't/50.query.taskpaper';

my $tp = Text::TaskPaper->new( file => DOCUMENT );

# find all tasks, at the current level and in the entire document
{
    my @tasks = $tp->get_tasks();
    ok( 2 == scalar @tasks )
        or say 'Tasks: ' . scalar @tasks;
    my @all_tasks = $tp->get_all_tasks();
    ok( 7 == scalar @all_tasks )
        or say 'All tasks: ' . scalar @all_tasks;
}

# find all notes, at the current level and in the entire document
{
    my @notes = $tp->get_notes();
    ok( 4 == scalar @notes )
        or say 'Notes: ' . scalar @notes;
    my @all_notes = $tp->get_all_notes();
    ok( 8 == scalar @all_notes )
        or say 'All notes: ' . scalar @all_notes;
}

# find all projects, at the current level and in the entire document
{
    my @projects = $tp->get_projects();
    ok( 2 == scalar @projects )
        or say 'Projects: ' . scalar @projects;
    my @all_projects = $tp->get_all_projects();
    ok( 4 == scalar @all_projects )
        or say 'All projects: ' . scalar @all_projects;
}

# find everything tagged @done, at the current level and in the entire doc
{
    my @tagged = $tp->get_tagged( 'done' );
    ok( 1 == scalar @tagged )
        or say 'Tagged: ' . scalar @tagged;
    ok( $tagged[0]->get_text() eq 'Project-less task.' );

    my @all_tagged = $tp->get_all_tagged( 'done' );
    ok( 3 == scalar @all_tagged )
        or say 'Tagged: ' . scalar @all_tagged;
    ok( $all_tagged[0]->get_text() eq 'Project-less task.' );
    ok( $all_tagged[1]->get_text() eq 'First task.' );
    ok( $all_tagged[2]->get_text() eq 'Task one.' );
}

# find everything tagged @due, at the current level and in the entire doc
{
    my @tagged = $tp->get_tagged( 'due' );
    ok( 0 == scalar @tagged )
        or say 'Tagged: ' . scalar @tagged;

    my @all_tagged = $tp->get_all_tagged( 'due' );
    ok( 3 == scalar @all_tagged )
        or say 'Tagged: ' . scalar @all_tagged;
    ok( $all_tagged[0]->get_text() eq 'Second task.' );
    ok( $all_tagged[1]->get_text() eq 'Third task.' );
    ok( $all_tagged[2]->get_text() eq 'Task two.' );
}

# find everything tagged @due with a parameter of 2099-12-31, 
# at the current level and in the entire document
{
    my @tagged = $tp->get_tagged( 'due', '2099-12-31' );
    ok( 0 == scalar @tagged )
        or say 'Tagged: ' . scalar @tagged;

    my @all_tagged = $tp->get_all_tagged( 'due', '2099-12-31' );
    ok( 1 == scalar @all_tagged )
        or say 'Tagged: ' . scalar @all_tagged;
    ok( $all_tagged[0]->get_text() eq 'Third task.' );
}
