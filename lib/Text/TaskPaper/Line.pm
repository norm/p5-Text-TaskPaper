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
1;
