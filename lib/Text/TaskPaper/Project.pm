package Text::TaskPaper::Project;

use Modern::Perl;
use base 'Text::TaskPaper::Line';



sub initialise {
    my $self = shift;
    $self->{'type'} = 'Project';
}

sub test_type {
    my $text = shift;
    
    if ( $text =~ s{ : $}{}x ) {
        return $text;
    }
    
    return;
}

1;
