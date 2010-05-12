package Text::TaskPaper::Note;

use Modern::Perl;
use base 'Text::TaskPaper::Line';



sub initialise {
    my $self = shift;
    $self->{'type'} = 'Note';
}

sub test_type {
    my $text = shift;
    
    # if it is no other type of line, it is always at least a note
    return $text;
}

1;
