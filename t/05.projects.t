use Modern::Perl;
use Test::More tests => 19;

use Text::TaskPaper;
use Data::Dumper::Concise;

my( $project, @structure, %tags );



# create new project objects
{
    $project = Text::TaskPaper::Project->new( text => 'World Domination' );
    
    ok( 'Project' eq $project->get_type() );
    ok( 'World Domination' eq $project->get_text() );
    %tags = $project->get_tags();
    is_deeply( {}, \%tags )
        or print Dumper \%tags;
}

# shorthand for just text
{
    $project = Text::TaskPaper::Project->new( 'World Domination' );
    
    ok( 'Project' eq $project->get_type() );
    ok( 'World Domination' eq $project->get_text() );
    %tags = $project->get_tags();
    is_deeply( {}, \%tags )
        or print Dumper \%tags;
}

# tags in the shorthand text accepted
{
    $project = Text::TaskPaper::Project->new( 'World Domination @overdue' );
    
    ok( 'Project' eq $project->get_type() );
    ok( 'World Domination' eq $project->get_text() );
    %tags = $project->get_tags();
    is_deeply( { overdue => [], }, \%tags )
        or print Dumper \%tags;
}

# tags as structure accepted
{
    $project = Text::TaskPaper::Project->new( 
            text => 'World Domination',
            tags => { overdue => [], },
        );
    
    ok( 'Project' eq $project->get_type() );
    ok( 'World Domination' eq $project->get_text() );
    %tags = $project->get_tags();
    is_deeply( { overdue => [], }, \%tags )
        or print Dumper \%tags;
}

# tags as text accepted
{
    $project = Text::TaskPaper::Project->new( 
            text => 'World Domination',
            tags => '@overdue',
        );
    
    ok( 'Project' eq $project->get_type() );
    ok( 'World Domination' eq $project->get_text() );
    %tags = $project->get_tags();
    is_deeply( { overdue => [], }, \%tags )
        or print Dumper \%tags;
}

# tags in the text accepted
{
    $project = Text::TaskPaper::Project->new( 
            text => 'World Domination @overdue',
        );
    
    ok( 'Project' eq $project->get_type() );
    ok( 'World Domination' eq $project->get_text() );
    %tags = $project->get_tags();
    is_deeply( { overdue => [], }, \%tags )
        or print Dumper \%tags;
}

# projects cannot be created without text
{
    $project = Text::TaskPaper::Project->new();
    ok( !defined $project );
}
