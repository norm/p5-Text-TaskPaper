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
    
    my $self = {};
    bless $self, $class;
    
    if ( defined $args{'string'} ) {
        $self->add_children_from_string( $args{'string'} );
    }
    elsif ( defined $args{'file'} ) {
        $self->add_children_from_file( $args{'file'} )
            or return;
    }
    
    return $self;
}

sub add_children_from_string {
    my $self   = shift;
    my $string = shift;
}

sub add_children_from_file {
    my $self = shift;
    my $file = shift;
    
    my $handle = io $file;
    return unless $handle->exists;
    
    my $content = $handle->all;
    return unless defined $content;
    
    # all files contain at least a newline (empty files are acceptable)
    return "$content\n";
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
        
        if ( $parsed ) {
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
        when( 'Task' )    { $object = Text::TaskPaper::Task->new(); }
        when( 'Project' ) { $object = Text::TaskPaper::Project->new(); }
        when( 'Note' )    { $object = Text::TaskPaper::Note->new(); }
    }
    
    return $object;
}

sub type {
    # return the type of this line
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
