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
 