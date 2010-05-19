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

sub as_text {
    my $self = shift;
    
    my $text = $self->{'text'};
    return "- $text";
}

1;

=head1 NAME

B<Text::TaskPaper::Task> - an individual line of a document of TaskPaper
format.

=head1 SEE ALSO

Refer to the documentation of L<Text::TaskPaper>.
