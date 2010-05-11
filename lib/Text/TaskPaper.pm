package Text::TaskPaper;

use Text::TaskPaper::Line;

sub new {
    my $class = shift;
    
    my $self = Text::TaskPaper::Line->new();
    
    return $self;
}

1;
 