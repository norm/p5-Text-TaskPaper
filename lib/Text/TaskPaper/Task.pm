package Text::TaskPaper::Task;

use Modern::Perl;
use base 'Text::TaskPaper::Line';



sub initialise {
    my $self = shift;
    $self->{'type'} = 'Task';
}

sub test_type {
    my $text = shift;
    
    if ( $text =~ s{^ -[ ] }{}x ) {
        return $text;
    }
    
    return;
}

1;
