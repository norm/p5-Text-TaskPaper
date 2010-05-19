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
    
    my $self = {
            children => [],
            tags     => {},
        };
    bless $self, $class;
    $self->initialise();
    
    # no empty types, unless it is the placeholder type "Line"
    return if $self->{'type'} && 0 == scalar @_;
    
    my %args;
    if ( 1 == scalar @_ ) {
        $args{'text'} = shift;
    }
    else {
        %args = @_;
    }
    
    if ( defined $args{'type'} || defined $self->{'type'} ) {
        # append arguments, not overwrite
        %$self = ( %$self, %args );
        
        # check text for tags
        my( $text, $tags ) = $self->extract_tags_from_line( $self->{'text'} );
        if ( scalar %$tags ) {
            $self->{'text'} = $text;
            $self->{'tags'} = $tags;
        }
        
        # accept tags as a string
        if ( 'HASH' ne ref $self->{'tags'} ) {
            ( undef, $self->{'tags'} )
                = $self->extract_tags_from_line( $self->{'tags'} );
        }
    }
    else {
        if ( defined $args{'string'} ) {
            $self->add_children_from_string( $args{'string'} );
        }
        elsif ( defined $args{'file'} ) {
            $self->add_children_from_file( $args{'file'} )
                or return;
            $self->set_filename( $args{'file'} );
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
            
            $parent->add_child( $item );
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
    my $line = shift // '';
    
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

sub get_text {
    my $self = shift;
    return $self->{'text'};
}

sub get_type {
    my $self = shift;
    return $self->{'type'};
}

sub get_tags {
    my $self = shift;
    return %{$self->{'tags'}};
}

sub get_lines {
    my $self = shift;
    return @{$self->{'children'}};
}

sub add_child {
    my $self = shift;
    
    my $object;
    if ( 1 == scalar @_ ) {
        $object = shift;
    }
    else {
        my %args = @_;

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

sub output {
    my $self = shift;
    
    my $output = $self->output_line();
    my $type   = $self->get_type();
    my $indent = defined $type ? "\t" : '';
    
    my @children = $self->get_lines();
    foreach my $child ( @children ) {
        my $child_output = $child->output();
        $child_output =~ s{^}{$indent}gm;
        
        $output .= $child_output;
    }
    
    return $output;
}

sub output_line {
    my $self = shift;
    
    my $type = $self->get_type();
    return unless $type;
    
    my $text = $self->as_text() // '';
    my $tags = $self->tags_as_text() // '';
    
    return "${text}${tags}\n";
}

sub as_text {
    # 'Line' type is a placeholder for the start
    # of the document, and so has no text.
    return;
}

sub tags_as_text {
    my $self = shift;
    
    my $tags = $self->{'tags'};
    my $text;
    
    foreach my $tag ( sort keys %$tags ) {
        # if there are parameters to this tag
        if ( scalar @{$tags->{ $tag }} ) {
            foreach my $param ( @{$tags->{ $tag }} ) {
                $text .= " \@${tag}(${param})";
            }
        }
        else {
            $text .= " \@$tag";
        }
    }
    
    return $text;
}

sub get_projects {
    my $self = shift;
    
    my @children = $self->get_lines();
    my @projects;
    
    foreach my $child ( @children ) {
        push @projects, $child
            if $child->get_type() eq 'Project';
    }
    
    return @projects;
}

sub get_all_projects {
    my $self = shift;
    
    my @children = $self->get_lines();
    my @projects;
    
    foreach my $child ( @children ) {
        push @projects, $child->get_all_projects();
        push @projects, $child
            if $child->get_type() eq 'Project';
    }
    
    return @projects;
}

sub get_tasks {
    my $self = shift;
    
    my @children = $self->get_lines();
    my @tasks;
    
    foreach my $child ( @children ) {
        push @tasks, $child
            if $child->get_type() eq 'Task';
    }
    
    return @tasks;
}

sub get_all_tasks {
    my $self = shift;
    
    my @children = $self->get_lines();
    my @tasks;
    
    foreach my $child ( @children ) {
        push @tasks, $child->get_all_tasks();
        push @tasks, $child
            if $child->get_type() eq 'Task';
    }
    
    return @tasks;
}

sub get_notes {
    my $self = shift;
    
    my @children = $self->get_lines();
    my @notes;
    
    foreach my $child ( @children ) {
        push @notes, $child
            if $child->get_type() eq 'Note';
    }
    
    return @notes;
}

sub get_all_notes {
    my $self = shift;
    
    my @children = $self->get_lines();
    my @notes;
    
    foreach my $child ( @children ) {
        push @notes, $child->get_all_notes();
        push @notes, $child
            if $child->get_type() eq 'Note';
    }
    
    return @notes;
}

sub is_tagged {
    my $self  = shift;
    my $tag   = shift;
    my $param = shift;
    
    my $tags = $self->{'tags'};
    
    if ( defined $tags->{ $tag } ) {
        if ( defined $param ) {
            foreach my $check ( @{$tags->{ $tag }} ) {
                return 1
                    if $check eq $param;
            }
        }
        else {
            return 1;
        }
    }
    
    return 0;
}

sub get_tagged {
    my $self  = shift;
    my $tag   = shift;
    my $param = shift;
    
    my @children = $self->get_lines();
    my @tagged;
    
    foreach my $child ( @children ) {
        push @tagged, $child
            if $child->is_tagged( $tag, $param );
    }
    
    return @tagged;
}

sub get_all_tagged {
    my $self  = shift;
    my $tag   = shift;
    my $param = shift;
    
    my @children = $self->get_lines();
    my @tagged;
    
    foreach my $child ( @children ) {
        push @tagged, $child->get_all_tagged( $tag, $param );
        push @tagged, $child
            if $child->is_tagged( $tag, $param );
    }
    
    return @tagged;
}

sub get_filename {
    my $self = shift;
    return $self->{'filename'};
}
sub set_filename {
    my $self = shift;
    my $file = shift;
    $self->{'filename'} = $file;
}

sub save {
    my $self = shift;
    
    # return error on undef
    $self->save_as( $self->get_filename() );
}

sub save_as {
    my $self     = shift;
    my $filename = shift;
    
    return 0 unless defined $filename;
    
    my $error  = 0;
    my $errors =  sub {
            my $text = shift;
            say STDERR $text;
            $error++;
        };
    
    my $handle = io->file( $filename );
    $handle->errors( $errors );
    
    my $output = $self->output();
    $handle->print( $output );
    
    return 0 if $error;
    return 1;
}

1;
