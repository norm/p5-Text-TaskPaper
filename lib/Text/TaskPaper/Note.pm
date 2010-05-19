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

sub as_text {
    my $self = shift;
    
    return $self->{'text'};
}

1;

__END__

=head1 NAME

B<Text::TaskPaper::Note> - an individual line of a document of TaskPaper
format.

=head1 SEE ALSO

Refer to the documentation of L<Text::TaskPaper>.
