use Modern::Perl;
use Test::More tests => 30;

use Text::TaskPaper;
use Data::Dumper::Concise;

my $tp = Text::TaskPaper::Line->new();
my( $content, $extracted, $found_tags, $expected, %tags );


# single tags are extracted
{
    $content  = "a line with a \@tag";
    $expected = "a line with a";
    %tags     = (
            tag => [],
        );
    
    ( $extracted, $found_tags ) = $tp->extract_tags_from_line( $content );
    ok( $extracted eq $expected )
        or say "Extracted: '$extracted'";
    is_deeply( $found_tags, \%tags )
        or print Dumper $found_tags;
}

# tags from within the line are extracted
{
    $content  = "do something \@today that's useful";
    $expected = "do something that's useful";
    %tags     = (
            today => [],
        );
    
    ( $extracted, $found_tags ) = $tp->extract_tags_from_line( $content );
    ok( $extracted eq $expected )
        or say "Extracted: '$extracted'";
    is_deeply( $found_tags, \%tags )
        or print Dumper $found_tags;
}
{
    $content  = "\@today buy milk";
    $expected = "buy milk";
    %tags     = (
            today => [],
        );
    
    ( $extracted, $found_tags ) = $tp->extract_tags_from_line( $content );
    ok( $extracted eq $expected )
        or say "Extracted: '$extracted'";
    is_deeply( $found_tags, \%tags )
        or print Dumper $found_tags;
}

# tags from within the line are extracted
{
    $content  = "do something \@today that's useful";
    $expected = "do something that's useful";
    %tags     = (
            today => [],
        );
    
    ( $extracted, $found_tags ) = $tp->extract_tags_from_line( $content );
    ok( $extracted eq $expected )
        or print "Extracted: $extracted";
    is_deeply( $found_tags, \%tags )
        or print Dumper $found_tags;
}
{
    $content  = "\@today buy milk";
    $expected = "buy milk";
    %tags     = (
            today => [],
        );
    
    ( $extracted, $found_tags ) = $tp->extract_tags_from_line( $content );
    ok( $extracted eq $expected )
        or print "Extracted: $extracted";
    is_deeply( $found_tags, \%tags )
        or print Dumper $found_tags;
}

# multiple tags are extracted
{
    $content  = "a line with \@some \@tags";
    $expected = "a line with";
    %tags     = (
            some => [],
            tags => [],
        );
    
    ( $extracted, $found_tags ) = $tp->extract_tags_from_line( $content );
    ok( $extracted eq $expected )
        or say "Extracted: '$extracted'";
    is_deeply( $found_tags, \%tags )
        or print Dumper $found_tags;
}

# multiple tags are extracted from anywhere in the line
{
    $content  = "\@today do something \@awesome with \@perl";
    $expected = "do something with";
    %tags     = (
            today   => [],
            awesome => [],
            perl    => [],
        );
    
    ( $extracted, $found_tags ) = $tp->extract_tags_from_line( $content );
    ok( $extracted eq $expected )
        or say "Extracted: '$extracted'";
    is_deeply( $found_tags, \%tags )
        or print Dumper $found_tags;
}

# multiple tags are extracted from anywhere in the line
{
    $content  = "\@today do something \@awesome with \@perl";
    $expected = "do something with";
    %tags     = (
            today   => [],
            awesome => [],
            perl    => [],
        );
    
    ( $extracted, $found_tags ) = $tp->extract_tags_from_line( $content );
    ok( $extracted eq $expected )
        or print "Extracted: $extracted";
    is_deeply( $found_tags, \%tags )
        or print Dumper $found_tags;
}

# single tags with parameters are extracted
{
    $content  = "some task \@due(tomorrow)";
    $expected = "some task";
    %tags     = (
            due => [ 'tomorrow' ],
        );
    
    ( $extracted, $found_tags ) = $tp->extract_tags_from_line( $content );
    ok( $extracted eq $expected )
        or say "Extracted: '$extracted'";
    is_deeply( $found_tags, \%tags )
        or print Dumper $found_tags;
}

# multiple tags with parameters are extracted
{
    $content  = "\@due(today) some \@perl task \@prio(1)";
    $expected = "some task";
    %tags     = (
            due  => [ 'today' ],
            prio => [ '1' ],
            perl => [],
        );
    
    ( $extracted, $found_tags ) = $tp->extract_tags_from_line( $content );
    ok( $extracted eq $expected )
        or say "Extracted: '$extracted'";
    is_deeply( $found_tags, \%tags )
        or print Dumper $found_tags;
}

# single tags with different parameters are extracted
{
    $content  = "some task \@prio(1) \@prio(A)";
    $expected = "some task";
    %tags     = (
            prio => [ '1', 'A' ],
        );
    
    ( $extracted, $found_tags ) = $tp->extract_tags_from_line( $content );
    ok( $extracted eq $expected )
        or say "Extracted: '$extracted'";
    is_deeply( $found_tags, \%tags )
        or print Dumper $found_tags;
}

# @ within a "word" is not a tag
{
    $content  = "email john\@example.com about examples";
    $expected = "email john\@example.com about examples";
    %tags     = ();
    
    ( $extracted, $found_tags ) = $tp->extract_tags_from_line( $content );
    ok( $extracted eq $expected )
        or say "Extracted: '$extracted'";
    is_deeply( $found_tags, \%tags )
        or print Dumper $found_tags;
}

# "empty" tags are treated as part of the text
{
    $content  = "a tag starts with an @ and has some stuff";
    $expected = "a tag starts with an @ and has some stuff";
    %tags     = ();
    
    ( $extracted, $found_tags ) = $tp->extract_tags_from_line( $content );
    ok( $extracted eq $expected )
        or say "Extracted: '$extracted'";
    is_deeply( $found_tags, \%tags )
        or print Dumper $found_tags;
}

# @ within a "word" is not a tag
{
    $content  = "email john\@example.com about examples";
    $expected = "email john\@example.com about examples";
    %tags     = ();
    
    ( $extracted, $found_tags ) = $tp->extract_tags_from_line( $content );
    ok( $extracted eq $expected )
        or print "Extracted: $extracted";
    is_deeply( $found_tags, \%tags )
        or print Dumper $found_tags;
}

# "empty" tags are treated as part of the text
{
    $content  = "a tag starts with an @ and has some stuff";
    $expected = "a tag starts with an @ and has some stuff";
    %tags     = ();
    
    ( $extracted, $found_tags ) = $tp->extract_tags_from_line( $content );
    ok( $extracted eq $expected )
        or print "Extracted: $extracted";
    is_deeply( $found_tags, \%tags )
        or print Dumper $found_tags;
}
