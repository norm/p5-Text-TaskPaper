package Text::TaskPaper::Line;

use Modern::Perl;
sub new {
    my $class = shift;
    
    my $self = {};
    bless $self, $class;
    
    return $self;
}

1;
