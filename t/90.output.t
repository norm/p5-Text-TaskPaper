use Modern::Perl;
use Test::More tests => 2;

use Text::TaskPaper;

use constant SYMMETRIC_DOCUMENT  => 't/50.query.taskpaper';
use constant ASYMMETRIC_DOCUMENT => 't/90.output.taskpaper';

my( $tp, $handle, $document, $output );



# test that the symmetric document is output identically to the original
{
    $tp = Text::TaskPaper->new( file => SYMMETRIC_DOCUMENT );
    open $handle, '<', SYMMETRIC_DOCUMENT;
    $document = do { local $/; <$handle>; };

    $output = $tp->output();
    ok( $document eq $output )
        or print "Symmetric:\n$output";
}

# test that the asymmetric document is output identically to the reference
# symmetric document
{
    $tp = Text::TaskPaper->new( file => ASYMMETRIC_DOCUMENT );

    $output = $tp->output();
    ok( $document eq $output )
        or print "Asymmetric:\n$output";
}
