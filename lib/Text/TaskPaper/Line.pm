package Text::TaskPaper::Line;

use Modern::Perl;

use IO::All     -utf8;



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

sub extract_tags_from_line {
    my $self = shift;
    my $line = shift;
    
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
    
    # remove any leading/trailing whitespace
    $line =~ s{^ \s* (.*?) \s* $}{$1}x;
    
    return( $line, \%tags );
}

1;
