package Text::TaskPaper;

use Modern::Perl;
use Text::TaskPaper::Line;



sub new {
    my $class = shift;
    my %args  = @_;
    
    my $self;
    
    if ( defined $args{'string'} ) {
        $self = Text::TaskPaper::Line->new( string => $args{'string'} );
    }
    elsif ( defined $args{'file'} ) {
        $self = Text::TaskPaper::Line->new( file => $args{'file'} );
    }
    else {
        $self = Text::TaskPaper::Line->new();
    }
    
    return $self;
}

1;

__END__

=head1 NAME

Text::TaskPaper - read, modify and write TaskPaper files

=head1 SYNOPSIS

    use Text::TaskPaper;
    
    my $tp = Text::TaskPaper->new( file => 'todo.txt' );
    $tp->add_task( text => 'Something urgent' );
    $tp->save();
    
    my $task = Text::TaskPaper::Task->new( 'Buy milk @errands' );
    $tp->add_task( $task );
    $tp->save();
    
=head1 DESCRIPTION

TaskPaper is a simple, plain text format for storing and organising tasks
and notes. It is exceptionally readable, and with hierarchy, tagging and
grouping (projects) support it is also incredibly flexible.

B<Text::TaskPaper> understands this format and can read, modify and write
TaskPaper documents.

=head2 TaskPaper format

A basic TaskPaper document will look something like:

    - Pay phone bill @today
    
    Holiday:
        Spain? Italy? Somewhere warm certainly.
        - Get new passport @due(2010-06-01)
        - Book hotel
        - Travel insurance

=head1 OBJECTS

A TaskPaper document is made up of lines. Indentation is done with a literal
tab character, and defines parent/child relationships (this task belongs in
this project; this is a note for this task).

Each line can contain any number of tags (see L<TAGS> below) and will be one
of three types:

=over

=item Task

A task represents an action you need to do. The defining characteristic of
a task is the line (after any indentation) starts with a dash (-) followed
by a space. This is represented by a L<Text::TaskPaper::Task> object.

=item Project

A project represents a grouping of tasks and notes. The defining
characteristic of a project is the text ends with a colon. This is
represented by a L<Text::TaskPaper::Task> object.

=item Note

Any other line (including blank lines) is a note. This is represented
by a L<Text::TaskPaper::Note> object.

=back

=head1 METHODS

When constructing new C<Text::TaskPaper> object, you will actually get a
C<Text::TaskPaper::Line> object. The Task, Project and Note types are all
subclasses of this, so these methods work on any object you might create.

=over

=item B<new>

Creates a new document, or individual line (note, project or task).

Documents accept optional C<string> and C<file> named arguments to use as the
text to initialise the document.

Lines require a either a string (which can contain both text and tags in the
natural format of TaskPaper) or a hash structure with text and tags arguments. The tags argument can either be natural text, or a hash of keys (the text of
the tag) with an array of text (the param(s) of the tag).

    # without arguments, creates a blank document
    $tp = Text::TaskPaper->new();
    
    # create document from string
    $tp = Text::TaskPaper->new( string => $string );
    
    # create document from file
    $tp = Text::TaskPaper->new( file => $filename );
    
    # to create a specific type, you need at least text
    $p = Text::TaskPaper::Project->new( 'World Domination' );
    
    # type with tags
    $n = Text::TaskPaper::Task->new( 'Buy milk @errand' );
    
    # be more explicit
    $n = Text::TaskPaper::Task->new(
        text => 'Buy milk',
        tags => '@errand',
    );
    
    # pass in tags as structured data
    # (represents: "Buy milk @errand @due(today)")
    $n = Text::TaskPaper::Task->new(
        text => 'Buy milk',
        tags => {
            errand => [],
            due => [ 'today', ],
        }
    );

=item B<save>

=item B<save_as>

=item B<set_filename>

Save the current document, either as the file named in the argument or as the
existing stored filename.

    # save document
    $tp->save_as( 'todos.txt' );
    
    # re-use filename that is already stored
    $tp = Text::TaskPaper->new( file => $filename );
    ...
    $tp->save();
    
    # change stored filename
    $tp->set_filename( 'new-todos.txt' );
    $tp->save();

=item B<add_task>

=item B<add_project>

=item B<add_note>

=item B<add_child>

Add a new line to the current document, or a child line to the current line.
Takes the same arguments as the C<new()> constructor for any line.

    # add a new line to a document
    $tp->add_task( 'Buy milk @errand' );
    
    # add a new line more explicitly
    $tp->add_task(
        text => 'Buy milk',
        tags => {
            errand => [],
        }
    );
    
    # anything can be added to anything
    $t = Text::TaskPaper::Task->new( 'Buy milk' );
    $t->add_note( 'Semi-skimmed preferred.' );
    
    # existing objects can be added, as well as new text
    $t = Text::TaskPaper::Task->new( 'Buy milk' );
    $tp->add_child( $t );

=item B<add_children_from_string>

=item B<add_children_from_file>

Adds multiple children, specified in the natural format of TaskPaper to an
existing document or line.

    # bulk adding from existing text
    $p = Text::TaskPaper::Project->new( 'DIY' );
    $p->add_children_from_string(
          "- Paint garden fence\n"
        . "- Repair wobbly shelves\n"
    );
    
    # bulk adding from existing file
    $p->add_children_from_file( 'diy-todos.txt' );

=item B<get_type>

=item B<get_text>

=item B<get_tags>

Fetch the details of the current line.

    $t = Text::TaskPaper::Task->new( 'Buy milk @errand' );
    $type = $t->get_type();     # "Task"
    $text = $t->get_text();     # "Buy milk"
    $tags = $t->get_tags();     # { errand => [] }

=item B<get_lines>

Describes the lines of the current document, or children of the current line.
Is an array of lines, with each line represented as a hash of type, text and
tags.

    $tp = Text::TaskPaper->new();
    $tp->add_task( 'Buy milk @errand' );
    $tp->add_task( 'Walk dog' );
    
    $lines = $tp->get_lines();
    # [
    #   { type => 'Task', text => 'Buy milk',
    #     tags => { errand => [] } },
    #   { type => 'Task', text => 'Walk dog',
    #     tags => {} }
    # ]

=item B<output>

Returns a string that represents the current document, or the line and all of
its children in the natural format of TaskPaper.

    $tp = Text::TaskPaper->new();
    $tp->add_task( 'Buy milk @errand' );
    $tp->add_task( 'Walk dog' );
    
    $text = $tp->output();  # "- Buy milk @errand\n- Walk dog\n";

=item B<get_tasks>

=item B<get_projects>

=item B<get_notes>

    $tp = Text::TaskPaper->new();
    $tp->add_task( 'Buy milk @errand' );
    $tp->add_note( 'Must remember to walk the dog.' );
    $t = $tp->get_tasks();      # contains "Buy milk" hash only
    $n = $tp->get_notes();      # contains "walk dog" hash only
    $p = $tp->get_projects();   # contains nothing

Returns all of the tasks, projects or notes that are top-level children of the current line or document.

=item B<get_all_notes>

=item B<get_all_projects>

=item B<get_all_tasks>

Returns all of the tasks, projects or notes that are children of the current
line or document, regardless of depth.

    $plan = <<TASKPAPER;
    World domination:
        - recruit henchmen
            Try Henchmen Guild first.
        - build evil lair
            - find evil lair
    TASKPAPER
    
    $tp = Text::TaskPaper->new( string => $plan );
    $t1 = $tp->get_tasks();         # contains nothing
    $t2 = $tp->get_all_tasks();     # contains three tasks


=item B<get_tagged>

Returns all of the tasks, notes or projects that are top-level children of
the current line B<and> are tagged appropriately.

The first argument is the tag to look for, the second (optional) argument is
the exact parameter for that tag to look for.

    $chores = <<CHORES;
    - Paint garden fence @paint @outdoors
    - Repair wobbly shelves @hammer @indoors
    - Water flowers @outdoors @due(Fri)
    CHORES
    
    $tp = Text::TaskPaper->new( string => $chores );
    $t1 = $tp->get_tagged( 'outdoors' );        # two tasks
    $t2 = $tp->get_tagged( 'due' );             # one task
    $t3 = $tp->get_tagged( 'due', 'Thu' );      # zero tasks

=item B<get_all_tagged>

Returns all of the tasks, notes or projects that are children of the current
line regardless of depth that are tagged appropriately. Takes the same
arguments as C<get_tagged>.

=back

=head1 OUTPUT FORMATTING CAVEAT

When C<Text::TaskPaper> outputs a line, the tags will B<always> come at the
end of the line, and sorted alphabetically. This means if you were to load,
modify and save an existing TaskPaper document with a line such as:

    - @today Fix printers @paperjam

It would be output as:

    - Fix printers @paperjam @today

=head1 SEE ALSO

    http://www.hogbaysoftware.com/products/taskpaper

=head1 COPYRIGHT

    Copyright (c) 2010, Mark Norman Francis.
    
    This program is free software; you can redistribute it
    and/or modify it under the same terms as Perl itself.
