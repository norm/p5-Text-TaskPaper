package Text::TaskPaper::Line;

use Modern::Perl;

use IO::All     -utf8;

use Text::TaskPaper::Note;
use Text::TaskPaper::Project;
use Text::TaskPaper::Task;

# This is sorted according to precedence.
use constant TYPES => qw( Task Project Note );



sub new {
    my $class = shift;
    my %args  = @_;
    
    my $self = {
            children => [],
            tags     => {},
        };
    bless $self, $class;
    
    $self->initialise();
    
    if ( defined $args{'type'} || defined $self->{'type'} ) {
        # append arguments, not overwrite
        %$self = ( %$self, %args );
    }
    else {
        if ( defined $args{'string'} ) {
            $self->add_children_from_string( $args{'string'} );
        }
        elsif ( defined $args{'file'} ) {
            $self->add_children_from_file( $args{'file'} )
                or return;
        }
    }
    
    return $self;
}

sub initialise {
    # this space intentionally left blank
}

sub add_children_from_string {
    my $self   = shift;
    my $string = shift;
    
    my @lines           = split m{\n}, $string;
    my $previous_indent = -1;
    
    my @objects;
    my $add_child_to_parent = sub {
            my $item   = pop @objects;
            my $parent = pop @objects;
            
            $parent->add_child( object => $item );
            push @objects, $parent;
        };
    
    push @objects, $self;
    
    foreach my $text ( @lines ) {
        my $tabs = '';
        
        # extract the tab indentation
        $tabs = $1
            if $text =~ s{^ ( \t+ ) }{}gx;
        
        my $indent = length $tabs;
        my $object = $self->get_object_for_line( $text );
        
        # if the indentation has stayed the same or decreased,
        # add previous item(s) on the stack to their previous
        # object on the stack (which will be their parent)
        foreach ( 0 .. 0 - ( $indent - $previous_indent ) ) {
            &$add_child_to_parent;
        }
        
        push @objects, $object;
        $previous_indent = $indent;
    }
    
    # add any remaining items on the stack to their previous
    # object on the stack (which will be their parent, or
    # $self at the end)
    foreach ( 0 .. $previous_indent ) {
        &$add_child_to_parent;
    }
}

sub add_children_from_file {
    my $self = shift;
    my $file = shift;
    
    my $handle = io $file;
    return unless $handle->exists;
    
    my $content = $handle->all;
    return unless defined $content;
    
    # all files contain at least a newline (empty files are acceptable)
    $self->add_children_from_string( "$content\n" );
    return 1;
}

sub parse_line {
    my $self = shift;
    my $line = shift;
    
    my( $text, $tags ) = $self->extract_tags_from_line( $line );
    
    TYPE:
    foreach my $type ( TYPES ) {
        no strict 'refs';
        my $try    = "Text::TaskPaper::${type}::test_type";
        my $parsed = &$try( $text );
        
        if ( defined $parsed ) {
            return {
                    type => $type,
                    text => $parsed,
                    tags => $tags,
                };
        }
    }
    
    return;
}

sub extract_tags_from_line {
    my $self = shift;
    my $line = shift;
    
    # preserve leading and trailing whitespace
    $line =~ s{^ (\s*) (.*?) (\s*) $}{$2}x;
    my $leading  = $1 // '';
    my $trailing = $3 // '';
    
    my %tags;
    my $find_tag = qr{
            (?: ^ | \s )                # @ must be at the start of the word
            @
            (?|                         # must be followed by one of:
                    ( \w+ )                     # $1: the tag
                    (?: \( ( [^\)]+ ) \) )      # $2: parameter
                |
                    ( \w+ )                     # $1: the tag
                |
                    ()                          # $1: empty
                    (?: \( ( [^\)]+ ) \) )      # $2: parameter
            )
            \s?
        }x;
    
    while ( $line =~ s{$find_tag}{ }x ) {
        $tags{ $1 } = []
            unless defined $tags{ $1 };
        push( @{$tags{ $1 }}, $2 )
            if defined $2;
    }
    
    # remove any replacement-induced extra whitespace
    $line =~ s{^ \s* (.*?) \s* $}{$1}x;
    
    # restore original whitespace
    $line = "${leading}${line}${trailing}";
    
    return( $line, \%tags );
}

sub get_object_for_line {
    my $self = shift;
    my $line = shift;
    
    my $parsed = $self->parse_line( $line );
    my $type   = $parsed->{'type'};
    my $object;
    
    given ( $parsed->{'type'} ) {
        when( 'Task' ) {
            $object = Text::TaskPaper::Task->new( %$parsed );
        }
        when( 'Project' ) {
            $object = Text::TaskPaper::Project->new( %$parsed );
        }
        default {
            $object = Text::TaskPaper::Note->new( %$parsed );
        }
    }
    
    return $object;
}

sub get_type {
    my $self = shift;
    return $self->{'type'};
}

sub get_items {
    my $self = shift;
    return @{$self->{'children'}};
}

sub add_child {
    my $self = shift;
    my %args = @_;
    
    my $object;
    if ( defined $args{'object'} ) {
        $object = $args{'object'};
    }
    else {
        given ( $args{'type'} ) {
            when( 'Task' ) {
                $object = Text::TaskPaper::Task->new( %args );
            }
            when( 'Project' ) {
                $object = Text::TaskPaper::Project->new( %args );
            }
            default {
                $object = Text::TaskPaper::Note->new( %args );
            }
        }
    }
    
    push @{$self->{'children'}}, $object;
}

sub add_task {
    my $self = shift;
    my %args = @_;
    
    $self->add_child( %args, type => 'Task' );
}

sub add_note {
    my $self = shift;
    my %args = @_;
    
    $self->add_child( %args, type => 'Note' );
}

sub add_project {
    my $self = shift;
    my %args = @_;
    
    $self->add_child( %args, type => 'Project' );
}

sub text {
    # return the text of this line
}

sub output {
    # return this line, and all of its children, as text
}

sub output_line {
    # return this line as text
}

sub items {
    # list all items that are first-generation children of this line
}

sub projects {
    # return the projects that are first-generation children of this line
}

sub tasks {
    # return the tasks that are first-generation children of this line
}

sub notes {
    # return the notes that are first-generation children of this line
}

sub tags {
    # return the tags that are children of this line
}

sub items_for_tag {
    # return the items that the current tag/tags apply to
}

1;
