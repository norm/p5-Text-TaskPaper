package Text::TaskPaper::Project;

use Modern::Perl;



sub test_type {
    my $text = shift;
    
    if ( $text =~ s{ : $}{}x ) {
        return $text;
    }
    
    return;
}

1;