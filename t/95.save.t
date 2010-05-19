use Modern::Perl;
use Test::More tests => 9;

use Text::TaskPaper;

use File::Temp;

use constant SYMMETRIC_DOCUMENT  => 't/50.query.taskpaper';
use constant ASYMMETRIC_DOCUMENT => 't/90.output.taskpaper';

my( $tp, $handle, $document, $output, $temp_file, $content );


# test that the symmetric document is saved identically to the original
{
    $tp = Text::TaskPaper->new( file => SYMMETRIC_DOCUMENT );
    open $handle, '<', SYMMETRIC_DOCUMENT;
    $document = do { local $/; <$handle>; };
    
    $temp_file = tmpnam();
    ok( $tp->save_as( $temp_file ) );
    open $handle, '<', $temp_file;
    $output = do { local $/; <$handle>; };
    
    ok( $document eq $output )
        or print "Symmetric:\n$output";
}

# test that the asymmetric document is saved identically to the reference
# symmetric document
{
    $tp = Text::TaskPaper->new( file => ASYMMETRIC_DOCUMENT );

    $temp_file = tmpnam();
    ok( $tp->save_as( $temp_file ) );
    open $handle, '<', $temp_file;
    $output = do { local $/; <$handle>; };
    
    ok( $document eq $output )
        or print "Asymmetric:\n$output";
}

# test that documents save back to the same place
{
    $content = "- First task.\n";
    
    $temp_file = tmpnam();
    open $handle, '>', $temp_file;
    print {$handle} $content;
    close $handle;
    
    $tp = Text::TaskPaper->new( file => $temp_file );
    ok( scalar $tp->get_lines() == 1 );
    ok( $tp->output() eq $content );
    $tp->add_task( text => 'Second task.' );
    ok( $tp->save() );
    
    open $handle, '<', $temp_file;
    $document = do { local $/; <$handle>; };
    $content .= "- Second task.\n";
    
    ok( $content eq $document );
}

# invalid save attempts report false
{ 
    $tp = Text::TaskPaper->new( string => $content );
    $temp_file = tmpnam();
    mkdir $temp_file;
    
    $tp->set_filename( $temp_file );
    ok( ! $tp->save() );
}
