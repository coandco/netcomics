#!/usr/bin/perl -w

=head1 NAME

netcomics - retrieve comics from the Internet

=head1 SYNOPSIS

B<netcomics> [B<-bBDhiIlLosuvv>] [B<-c,-C> I<"comic ids">] [B<-p> I<proxy>] [B<-S,-T,-E> I<date>]
                 [B<-n,-N> I<days>] [B<-d,-m,-t> I<dir>] [B<-f> I<date_fmt>] [B<-g> [I<program>]] [B<-nD>]
                 [B<-r> I<rc_file>] [B<-W,-w>[=I<n>]] [B<-nw>]

=head1 DESCRIPTION

The I<netcomics> program will download today's comic strips from
the Web, and place them in a spool directory where they can be
retrieved for display.  Because each website that carries comic
strips chooses how old of strips to show, the comic strips downloaded
will actually be from different dates.  Most common will be comic
strips that are 1 week, 2 weeks, and 3 weeks old. Also, each website
is not updated at the same time, nor are any of them updated at a
consistent time during the day.  Therefore, when running netcomics
as a cron job in the early morning, you may need to rerun it by hand
a little later in the day to get the comics that it couldn't find.
The exact command to run is given at the end of I<netcomics> output
if any failures occurred.

I<netcomics> also supports retrieving specific dates of comics.  A
"Starting Date" may be specified with B<-S>.  An "Ending Date" may be
specified with B<-E>.  And a specific date may be specified with
B<-T>.  All dates are given in the M-D-[YY]YY format.  If a start date
is given without an end date, B<-n> may be used to specify the number
of days of comics to retrieve starting at the specified start date.
If an end date is given without a start date, B<-n> will specify the
number of days of comics to retrieve counting backwards from the end
date.  If a start date is given without B<-n> or B<-E>, then the end
date is assumed to be today's date.  If the option given to B<-E>,
B<-S>, or B<-T> is just an integer, that integer is interpreted as
the number of days prior to the current day (specify specific dates
relatively).

Another way to specify the dates to download comics, is to use B<-N>
in conjunction with B<-n>.  The argument to B<-N> is the number of
days prior to the current day to retrieve comics.  Note that this does
not specify an actual date.  It rather indicates the number of days
ago a comic was made available, rather than the actual date of the
comic.  To see how far behind the date of each comic is from the date
it actually gets released, use B<-l>.  So if today is Wednesday, and you
specify B<-N 2>, I<netcomics> will download the comics that were made
available on Monday.  This is useful for running netcomics in a
timezone that is way ahead of the timezones the comics' websites are
located.

I<netcomics> was created for the purpose of giving your weary mind a 
little relief from your hectic workday, so another script
called I<show_comics> has been provided to periodically popup the 
retrieved comic strips throughout the workday.  Another script called
I<display_comics> has also been provided, but it is only an example
script of what can be done for displaying comics on many users
computers on a network.

B<Important:>  The further east your timezone is from the US, the later 
in the day you'll have to run I<netcomics>.  As a reference, I suggest
those whose timezone in GMT to wait to run the script at 12:30pm if
they want to get all the comics at a time that's pretty likely to have
had all of the websites updated.  Use B<-N> if you want to run the
script early in the morning and are having problems getting comics to
download. Also, just because a comic failed to download doesn't mean
that the module for that comic is broken--it most likely the website
just hasn't been updated yet.

I<netcomics> can also create an HTML file, "index.html", in the
directory you have the comics placed.   If a number is given with
B<-W> or B<-w>, it will be used to determine the number of comics to
be placed in each html file.  Subsequent files are named "comic#.html".

B<Disclaimer:> Do not put the comics up on the Internet!  You should
only use them for your own use.  Also, do not redistribute the comics
downloaded by I<netcomics> in any other way unless you receive written
authorization from each publisher.

=head1 OPTIONS

=over 4

=item B<-b>

Get black & white comics if their is a choice between that and color.

=item B<-B>

Don't get black & white comics if their is a choice between that and color.
Use this option to override the setting in the rc file.

=item B<-c> I<'comic_ids'>

Get the supplied comics (ids are separated by white spaces).
This option may be repeated, and may not be used in conjunction with B<-C>.

=item B<-C> I<'comic_ids'>

Don't get the supplied comics (ids are separated by white spaces).
This option may be repeated, and may not be used in conjunction with B<-c>.

=item B<-d> I<dir>

Put comics into directory. Default is /var/spool/netcomics.

=item B<-D>

Delete files in directory before retrieving.

=item B<-E> [I<date> | I<days>]

Specify an ending date, or the date that is the specified number of
days prior to today, with which to define the range of days of comics
to retrieve.  Must be used in combination with one of B<-S> or B<-n>.
The date is of the form: M-D-Y.

=item B<-f> I<date_fmt>

Specify the date format used when naming files.  Default is C<'%y%m%d'>.

=item B<-g> [I<program>]

Specify a program to use to perform HTTP requests.  The URL to retrieve 
is attached to the end of the provided text without a space. The 
program must write the retrieved content of the URL on its stdout.
The default command is:

   'wget -q -O - '.

=item B<-h>

Show usage. Comics will not be downloaded.

=item B<-i>
Don't create an index for the webpages.

=item B<-I>
Create an index for the webpages. Specify this to override the setting 
in the rc file if need be.

=item B<-l>

List supported comics & their identifiers, sorted by name alphabetically.
Comics will not be downloaded.

=item B<-L>

Sort comics in webpages by date and when using B<-l>, by days behind.

=item B<-m> I<dir>

Add dir to the locations of comic modules. Default is /usr/share/netcomics.
This option may be repeated to add multiple directories.

=item B<-M> I<dir>

Use only the list of locations of comic modules specified on the command line.

=item B<-n> I<days>

Retrieve this number of days of comics, going backwards. Default is 1.
This option may be used in conjunction with B<-N>.

=item B<-N> I<days>

Start retrieving comics this many days before the currently available date.
If you use B<-l> to show the comic id's, the 3rd column indicates the number
of days behind a comic is available.  By default, if B<-E> or B<-S> are
not specified, then netcomics will retrieve each comic, understanding that
the latest available is that many days ago (according to the number shown
in the 3rd column).  Use this option to push the number of days ago back 
even further.  Default is 0. This option may be used in conjunction with 
B<-n>, but not with B<-S> or B<-E>.

=item B<-o>

Write the webpage on standard out. Cannot specify the number of comics
per page for B<-W> or B<-w> if you use this option.

=item B<-p> I<url>

Specify a URL to use as a proxy.  Both HTTP and FTP are supported.

=item B<-r> I<rc filename>

Specify an alternate name for the user-specific rc file

=item B<-s>

Don't skip bad comics when creating the web page.  This will potentially
cause the web page to be loaded into a browser more slowly, but it will
make it evident exactly which websites don't return proper HTTP errors.

=item B<-S> [I<date> | I<days>]

Specify a starting date, or the date that is the specified number of
days prior to today, with which to define the range of days of
comics to retrieve.  May be used in combination with of B<-E> or
B<-n>. The date is of the form: M-D-Y.

=item B<-t> I<dir>

Specify the location of html template files. Default is 
/usr/share/netcomics/html_tmpl.

=item B<-T> [I<date> | I<days>]

Specify a specific date, or the date that is the specified number of
days prior to today, of comics to retrieve.  This option my be
repeated. The date is of the form: M-D-Y.

=item B<-u>

Don't download comics, but print URLs on stdout, or if creating a
webpage, make the images be implementing using the URLs.

=item B<-v>

Be a little verbose.

=item B<-vv>

Be extra verbose

=item B<-w>[=n]

Create an html file, index.html, for the comics downloaded. Optionally,
n specifies the number of comics to have in each page, where subsequent
html files are named comic#.html.

=item B<-nw>

Don't create a webpage. Use this option to override the rc file setting
if need be.

=item B<-wt> I<title>

Specify a title for the web page rather than the default
("Today's Comics From the Web on E<lt>DATEE<gt>").  This is useful
for when you download specific comics, and want the title of the
web page to reflect the actual contents.

=item B<-W>[=n]

Recreate the html file, index.html, from the comics that are in the
directory, as well as any new comics downloaded.  Optionally,
n specifies the number of comics to have in each page, where subsequent
html files are named comic#.html.

=back

=head1 EXAMPLES

=over 3

=item 1.
Run as a cron job at 7:30am, Monday through Friday, removing
the previous day's comics beforehand, and creating a web page.
And for Monday, also retrieve Saturday & Sunday's comics.

   30 07  *  *  2-5  /usr/bin/netcomics -D -w
   30 07  *  *  1    /usr/bin/netcomics -n 3 -D -w


=item 2.
Same as before, except, for Monday, get Saturday's & Sunday's
comics, and for Tuesday, get Monday & Tuesday's.  This is so there
isn't such an overload of comics on Monday.

   30 07  *  *  1    /usr/bin/netcomics -N 1 -n 2 -D -w
   30 07  *  *  2    /usr/bin/netcomics -n 2 -D -w
   30 07  *  *  3-5  /usr/bin/netcomics -D -w

=item 3.
Grab Dilbert & Foxtrot comics from the past 30 days, place them in /tmp,
and create a web page with a specific title (<DATE> gets replaced with the
name of the month).

   netcomics -c "dilbert ft" -n 30 -d /tmp -w -wt 'Dilbert & \
   Foxtrot Comics From the Month of <DATE FORMAT="%b">'

=item 4.
Specify the date range of comics to retrieve to be from Feb 3, 1999
to Feb 6, 1999, and also get comics on March 3, 1998.

   netcomics -S 2-3-99 -E 2-6-99 -T 3-3-98

=item 5.
Specify the date range of comics to retrieve to be from Jan 6, 1999
and the 5 days before it.  Get all the comics except Jerkcity and Doodie

   netcomics -E 1-6-99 -n 6 -C jc -C doodie

=item 6.
Specify the date range of comics to retrieve to be all those that came
available three, four, and five days ago.

   netcomics -N 3 -n 3

=item 7.
Specify the date range of comics to retrieve to be all those that are
dated three, four, and five days ago.  This example is given to show
the difference between -E & -S  (when given a number) and -N. All
comics downloaded will have the same 3 dates, while in the previous 
example, the comics will have varying dates that are determined by
the 3rd column in the output of -l. Note that since many comics aren't
available until 2 weeks have past, many of them will not download
with this example.

   netcomics -E 3 -n 3

            or

   netcomics -E 3 -S 5

=item 8.
Use wget instead of libwww-perl (makes it so you don't have to install
libwww-perl).

   netcomics -g

=item 9.
Do not actually download the comics, and output the webpage to stdout.

   netcomics -uwo

=back

=head1 FILES

=over 29

=item /usr/share/netcomics

Directory containing the modules that return RLIs.

=item /usr/share/netcomics/html_tmpl

Directory containing the HTML template files used to create the
web page.

=item /var/spool/netcomics

Default directory where comics and the web page are placed.

=item /usr/bin/display_comics

Example script that should be modified to be used to display the
downloaded comics.

=back

=head1 BUGS

=over 4

=item
Some of the comics depend on having the LANG and/or LC_CTYPE set so that
the abbreviated month names are of only a certain locale.   Therefore,
these comics will not download for certain locals.

=back

=head1 SEE ALSO

show_comics(1)

=head1 AUTHOR

Ben Hochstedler <hochstrb@cs.rose-hulman.edu>
ICQ: B<15469308> AIM: B<hochstrb>

=cut

#This script requires the following CPAN packages:
#libwww-perl, HTML-Parser, Image-Size
#
#To add your own comic lib modules, first visit the comic strip resource at:
#http://comics.kurle.com/resource/
#to find the comic you want.
				 
$0 =~ s,.*/,,;  # use basename only

use POSIX;
use strict;

#global vars
my $script_name = "netcomics";
my $files_mode = 0644;
use vars('@lof'); @lof = ();    #list of functions which return an rli hash
use vars('%hof'); %hof = ();    #hash of functions which return an rli hash
use vars('@rli'); @rli = (); #resource locator information
use vars('$date_fmt'); $date_fmt = "%Y%m%d"; #date format in filenames

my $inform_maintainer = "Please inform the maintainer of netcomics:\n" .
    "Ben Hochstedler <hochstrb\@cs.rose-hulman.edu>.\n";
#default options values
use vars ('@libdirs'); @libdirs = ("/usr/share/netcomics");
use vars ('$html_tmpl_dir'); $html_tmpl_dir = "$libdirs[0]/html_tmpl";
use vars ('$comics_dir'); $comics_dir = "/var/spool/netcomics";
use vars ('$system_rc'); $system_rc = "/etc/netcomicsrc";
use vars ('$verbose'); $verbose = 0; #default to not verbose
use vars ('$extra_verbose'); $extra_verbose = 0; #default to not extra verbose
use vars ('$delete_files'); $delete_files = 0;
use vars ('@selected_comics'); @selected_comics = ();
use vars ('$do_list_comics'); $do_list_comics = 0;
use vars ('$make_webpage'); $make_webpage = 0; #def to not create the webpage
use vars ('$remake_webpage'); $remake_webpage = 0;
use vars ('$proxy_url'); $proxy_url = undef;
#number of days of comics to get, going backwards.
use vars ('$days_of_comics'); $days_of_comics = undef; 
use vars ('$days_prior'); $days_prior = undef; #number of days prior to start at
use vars ('@dates'); @dates = (); #dates of comics to get
use vars qw($start_date $end_date); ($start_date,$end_date) = (undef,undef);
#used in case there were any failures to help reconstruct the command line 
#options to use.
use vars ('$given_options'); $given_options = ""; 
use vars ('$user_specified_comics'); $user_specified_comics = 0;
use vars ('$user_unspecified_comics'); $user_unspecified_comics = 0;
use vars ('$external_cmd'); $external_cmd = undef;
use vars ('$dont_download'); $dont_download = 0;
use vars ('$use_filecmd'); $use_filecmd = 0;
use vars ('$prefer_color'); $prefer_color = 1;
use vars ('$reset_libdir'); $reset_libdir = 0;

#Options set through an rc file
use vars ('$rc_file'); $rc_file = "$ENV{'HOME'}/.netcomicsrc";
use vars qw(%comics %groups);

#Webpage options
use vars ('$webpage_on_stdout'); $webpage_on_stdout = 0;
use vars ('$skip_bad_comics'); $skip_bad_comics = 0;
use vars ('$sort_by_date'); $sort_by_date = 0;
use vars ('$webpage_title'); 
$webpage_title = "Today's Comics From The Web on <DATE>";
use vars ('$webpage_index_title'); 
$webpage_index_title = "Index for " . $webpage_title;
use vars ('$comics_per_page'); $comics_per_page = undef;
use vars ('$link_color'); $link_color = "LINK=#9999FF";
use vars ('$vlink_color'); $vlink_color = "VLINK=#FF99FF";
use vars ('$index_link_color'); $index_link_color = "";
use vars ('$index_vlink_color'); $index_vlink_color = "";
use vars ('$background'); $background = "";
use vars ('$webpage_index'); $webpage_index = 1;
use vars ('$webpage_filename_tmpl'); 
$webpage_filename_tmpl = "comics<NUM>.html";
use vars ('$webpage_index_filename'); $webpage_index_filename = "index.html";

#mkgmtime var (taken from Time::Local)
my $tz;
{
    my(@epoch) = localtime(0);
    my($tzmin) = $epoch[2] * 60 + $epoch[1];    # minutes east of GMT
    if ($tzmin > 0) {
	$tzmin = 24 * 60 - $tzmin;              # minutes west of GMT
	$tzmin -= 24 * 60 if $epoch[5] == 70;   # account for the date line
    }
    $tz = (0 - $tzmin/60);
}


$| = 1; #autoflush on STDERR & STDOUT

my $smushopt = 0;

#TODO: preload options that specify the rc file names & verbosity here
my $i = 0;
foreach (@ARGV) {
    last if ++$i == @ARGV;
    #rc filename
    if (/^-\w*r$/) {
	if (@ARGV > 0) {
	    $rc_file = $ARGV[$i]
	} else {
	    print STDERR "Need a filename for an argument to -r. " .
		"Use -h for usage.\n";
	    exit 1;
	}
	if (! -f $rc_file) {
	    print STDERR "Specified rc file doesn't exist: '$rc_file'\n";
	    exit 1;
	} elsif (! -r $rc_file) {
	    print STDERR "Can't read specified rc file: '$rc_file'\n";
	    exit 1;
	}
	last;
    }
}


#First load the system rc file, then the user rc file
load_rcfile($system_rc,$rc_file);

my @newlibdirs = ();

#parse command line options
while (@ARGV) 
{
    $_ = shift(@ARGV);

    #Get specific comics or don't get a specific comics
    if (/-(c)$/i) {
	if (@ARGV > 0) {
	    my @ids = split(' ',shift(@ARGV));
	    if ($1 eq 'c') {
                $user_specified_comics = 1;
                push(@selected_comics,@ids);
            } else {
                $user_unspecified_comics = 1;
                push(@selected_comics,@ids);
	    }
	} else {
	    print STDERR "Need a space-delimitted list of comic id's.";
	    print STDERR "  Use -h for usage.\n";
	    exit 1;
	}
	if ($user_unspecified_comics && $user_specified_comics) {
	    print STDERR "Can only use one of -c and -C. Use -h for usage.\n";
	    exit 1;
	}
    }
    
    #List supported comics
    elsif (/-l/) {
	$do_list_comics++;
	$smushopt = 1;
    }
    
    #set the directory
    elsif (/-d$/) {
	if (@ARGV > 0) {
	    $comics_dir = shift(@ARGV);
	    $given_options .= " -d $comics_dir"
	} else {
	    print STDERR "Need a directory name. Use -h for usage.\n";
	    exit 1;
	}
    }
    
    #verbosity
    elsif (/-v/) {
	if ($verbose) {
	    $extra_verbose = 1;
	    if ($given_options =~ /^(.*)-v([^v].*)$/) {
		$given_options = $1 . $2;
	    }
	    $given_options .= " -vv";
	} else {
	    $verbose = 1;
	    $given_options .= " -v";
	}
	$smushopt = 1;
    }
    
    #Delete the files
    elsif (/-D/) {
	$delete_files = 1;
	$smushopt = 1;
    }

    #Don't delete the files
    elsif (/-nD/) {
	$delete_files = 0;
	$given_options .= " -nD";
    }

    #webpage title
    elsif (/-wt$/) {
	if (@ARGV > 0) {
	    $webpage_title = shift(@ARGV);
	    $given_options .= " -wt '$webpage_title'";
	} else {
	    print STDERR "Need a string for an argument to -wt. " .
		"Use -h for usage.\n";
	    exit 1;
	}
    }

    #webpage on standard out
    elsif (/-o/) {
	$webpage_on_stdout = 1;
	$given_options .= " -o";
	$smushopt = 1;
    }

    #don't create a webpage
    elsif (/-nw$/) {
 	$make_webpage = 0;	
	$remake_webpage = 0;
	$given_options .= " -nw";
    }

    #Create webpage?
    elsif (/-(w)(=.+)?/i) {
	if (defined($2)) {
	    if ($2 =~ /^=(\d+)$/) {
		$comics_per_page = $1;
	    } else {
		print STDERR "Number of comics per page for -W & -w must be " .
		    "a positive integer.\n";
		exit 1;
	    }
	} else {
	    $smushopt = 1;
	}
 	$make_webpage = 1;
	$remake_webpage = ($1 =~ /W/)? 1 : 0;
    }

    #Use a Proxy?
    elsif (/-p$/) {
	if (@ARGV > 0) {
	    $proxy_url = shift(@ARGV);
	    $given_options .= " -p $proxy_url";
	} else {
	    print STDERR "Need a URL to use as the proxy. " .
		"Use -h for usage.\n";
	    exit 1;
	}
    }

    #Number of days of comics to get, going backwards
    elsif (/-n$/) {
	if (@ARGV > 0) {
	    $days_of_comics = shift(@ARGV);
	} else {
	    print STDERR "Need a number for an argument to -n. " .
		"Use -h for usage.\n";
	    exit 1;
	}
    }

    #HTML Template Directory
    elsif (/-t$/) {
	if (@ARGV > 0) {
	    $html_tmpl_dir = shift(@ARGV);
	    $given_options .= " -t $html_tmpl_dir";
	} else {
	    print STDERR "Need a directory for an argument to -t. " .
		"Use -h for usage.\n";
	    exit 1;
	}
    }

    #Comic Module Directory
    elsif (/-m$/) {
	if (@ARGV > 0) {
	    my $dir = shift(@ARGV);
	    unshift(@newlibdirs,$dir);
	    $given_options .= " -m $dir";
	} else {
	    print STDERR "Need a directory for an argument to -m. " .
		"Use -h for usage.\n";
	    exit 1;
	}
    }

    #clear out libdirs
    elsif (/-M$/) {
	@libdirs = ();
	$given_options .= " -M";
	$smushopt = 1;
    }

    #Specified date
    elsif (/-([STE])$/) {
	my $type = $1;
	my $good = 0;
	if (@ARGV > 0) {
	    my $ds = shift(@ARGV);
	    my $ts = undef;
	    if ($ds =~ /([0-1]?[0-9])-([0-3]?[0-9])-(19|20)?([0-9][0-9])/) {
		my $year = defined($4) ? $4 : $3;
		$year += 100 if $year < 70;
		$ts = mkgmtime(0,0,12,$2,$1-1,$year);
	    } elsif ($ds =~ /^([+-]?\d+)$/) {
		$ts = time - ($1 * 24*3600);
	    }
	    if (defined($ts)) {
		$given_options .= " -$type $ds";
		$good = 1;
		$_ = $type;
		if (/T/) {
		    push(@dates,$ts);
		} elsif (/S/) {
		    $start_date = $ts;
		} elsif (/E/) {
		    $end_date = $ts;
		}
	    }
	}
	
	unless ($good) {
	    print STDERR "Need a date for an argument to -$type. ";
	    print STDERR "It has the form: MM-DD-[YY]YY\nOr it is the number ";
	    print STDERR "of days prior to day to specify the date.\n";
	    exit 1;
	}
    }

    #skip bad comics
    elsif (/-s/) {
	$skip_bad_comics = 1;
	$given_options .= " -s";
	$smushopt = 1;
    }

    #date format used when naming files
    elsif (/-f$/) {
	if (@ARGV > 0) {
	    $date_fmt = shift(@ARGV);
	    $given_options .= " -f '$date_fmt'";
	} else {
	    print STDERR "Need a date format for an argument to -f. " .
		"Use -h for usage.\n";
	    exit 1;
	}
    }

    #Number of days of comics to get, going backwards
    elsif (/-N$/) {
	if (@ARGV > 0) {
	    $days_prior = shift(@ARGV);
	    $given_options .= " -N $days_prior";
	} else {
	    print STDERR "Need a number for an argument to -N. " .
		"Use -h for usage.\n";
	    exit 1;
	}
    }

    #external program to use instead of LWP
    elsif (/-g(=(.+))?([^=]+)?$/) {
	$given_options .= " -g";
	if (defined($2)) {
	    $external_cmd = $2;
	} elsif (! defined($3) && @ARGV > 0 && $ARGV[0] !~ /^-/) {
	    $external_cmd = shift(@ARGV);
	} else {
	    $smushopt = 1;
	}
	$given_options .= " '$external_cmd'" if defined $external_cmd;
    }

    #print URLs or put them in the webpage?
    elsif (/-u/) {
	$dont_download = 1;
	$given_options .= " -u";
	$smushopt = 1;
    }

    #get b/w if possible
    elsif (/-(b)/i) {
	$prefer_color = ($1 =~ /B/)? 1 : 0;
	$given_options .= " -$1";
	$smushopt = 1;
    }

    #sort by date
    elsif (/-L/) {
	$sort_by_date = 1;
	$smushopt = 1;
	$given_options .= " -L";
    }

    #no index for webpaegs
    elsif (/-(i)/i) {
	$webpage_index = ($1 =~ /I/)? 1 : 0;
	$smushopt = 1;
	$given_options .= " -$1";
    }

    #rc filename
    elsif (/-r$/) {
	#already did the work of checking to make sure its good
	shift(@ARGV);
	$given_options .= " -r '$rc_file'";
    }

    #Usage
    else {
	print STDERR "Unknown option: $_.\n" unless /-h/;
	usage();
    }

    #Allow for smushed-together options
    if ($smushopt) {
	$smushopt = 0;
	if (/-.(.+)/) {
	    unshift(@ARGV,"-$1");
	    print "Pushing -$1 onto command line arguments.\n" 
		if $extra_verbose;
	}
    }
}

#tack on user-given directories.
unshift(@libdirs,@newlibdirs);

#check to make sure proper sets of options were provided
if (defined($end_date)) {
    if ($start_date > $end_date) {
	print STDERR "The starting date must be before the ending date. ";
	print STDERR "Use -h for usage.\n";
	exit 1;
    } elsif (defined($days_of_comics)) {
	print STDERR "The number of days of comics to retrieve may not be ";
	print STDERR "specified when the starting and\nending dates are. ";
	print STDERR "Use -h for usage.\n";
	exit 1;
    }
}
if (defined($days_prior) && (defined($end_date) || defined($start_date))) {
    print STDERR "-N may not be specified with -S or -E.  Use -h for usage.\n";
    exit 1;
} elsif (! defined($days_prior)) {
    $days_prior = 0;
}
if ($remake_webpage && $dont_download) {
    print STDERR "-u may not be specified with -W.  Use -h for usage.\n";
    exit 1;
}
if (defined($comics_per_page) && $webpage_on_stdout) {
    print STDERR "-o may not be specified with -W= or -w=.  Use -h for usage.\n";
    exit 1;
}

#only load the modules if needed
unless ($user_specified_comics && @selected_comics == 0 && !$do_list_comics) {
    load_modules(@libdirs); 
    
    #check to make sure there was some comics defined
    if (keys(%hof) == 0 && @lof == 0) {
	print STDERR "\nThere were no comic modules succesfully loaded.  ";
	print STDERR "Please check the setting\nof \@libdirs in the system ";
	print STDERR "and user rc file and on the command line:\n";
	print STDERR "\@libdirs = @libdirs\n";
	print STDERR "Also, check the installation of netcomics.\n";
	exit 1;
    }
}

#kludge @lof into a hash of functions for backwards compatibility
my %lofhash = ();
foreach (@lof) {
    $lofhash{$_} = "?";
}

list_comics(%hof,%lofhash) if ($do_list_comics);

#make sure user specified existing functions
#and set the @lof & %hof to those the user specified
if ($user_specified_comics || $user_unspecified_comics) {
    my @new_lof = ();
    my %new_hof = ();
    my @bad_lof = ();
    my @hof_keys = keys(%hof);
    @hof_keys = () unless defined(@hof_keys);
    my $fun;
    foreach $fun (@selected_comics) {
	$fun = quotemeta($fun);
	my @hres = grep(/^$fun$/,@hof_keys);
	if (@hres > 0) {
	    $new_hof{$fun} = $hof{$fun};
	} else {
	    my @lres = grep(/^$fun$/,@lof);
	    if (@lres > 0) {
		push(@new_lof,$fun);
	    } else {
		push(@bad_lof,$fun);
	    }
	}
    }
    if (@bad_lof > 0) {
	print STDERR "No such comics: \"@bad_lof\". ";
	print STDERR "Use -l to see the list of comics.\n";
	exit 1;
    }
    if ($user_specified_comics) {
	@lof = @new_lof;
	%hof = %new_hof;
    } else {
	#intersection
	my @new = ();
	foreach (@lof) {
	    if (grep(/^${_}$/,@new_lof) > 0) {
		push(@new,$_);
	    }
	}
	@lof = @new;
	foreach (keys %new_hof) {
	    delete $hof{$_};
	}
    }
}

#Make sure the temp dir exists
unless (-d $comics_dir) {
    mkdir($comics_dir,0777) || die "could not create $comics_dir: $!"; 
} elsif ($delete_files) {
    chdir $comics_dir || die "could not cd to $comics_dir: $!";
    unlink <*.*>;
}


#
#Do the work.
#

my $get_current = build_date_array();
if ($extra_verbose) {
    print "dates: ";
    my $date;
    foreach $date (@dates) {
	print strftime("%m-%d-%y",gmtime($date));
	print " ";
    }
    print "\n";
}
build_rli_array($get_current);

#get_comics returns a list of comics, but when creating the webpage,
#only the rli are used.
my @comics = get_comics();
    
if ($remake_webpage)
{
    print "Reading $comics_dir to get list of current comics\n" 
	if $extra_verbose;
    opendir(DIR,$comics_dir) || die "could not open $comics_dir: $!";
    my @files = readdir(DIR);
    closedir(DIR);
    @files = sort(grep(/(xpm|gif|jpe?g|tiff?|png)$/,@files));
    #add files to the rli so that create_webpage can use them, too
    my $i = $[ - 1;
    while ($i++ < $#files) {
	my $rli = {'name' => $files[$i],
		   'time' => date_from_filename($files[$i]),
		   'status' => 1,
		   'file' => [$files[$i]]};
	my ($title,$type) = parse_name($files[$i]);
	$rli->{'title'} = $title;
	$rli->{'type'} = $type;
	($rli->{'proc'} = $title) =~ s/\s/_/g;
	if ($files[$i] =~ /^(.*\d+)-(\d+)\.(\w+)$/) {
	    #this is part of a multi-file comic
	    my ($name,$num,$ext) = ($1,$2 + 1,$3);
	    if (grep(/$name\.$ext/,@comics)) {
		next; #was just downloaded
	    } else {
		$rli->{'name'} = "$name.$ext";
		while ($i < $#files && $files[$i+1] =~ /^$name-$num\.$ext$/) {
		    #tack on this file to the $rli
		    $rli->{'file'}->[$num++ - 1] = $files[++$i];
		}
	    }
	} elsif (grep(/^$files[$i]$/,@comics)) {
	    next; #was just downloaded
	}
	push(@rli,$rli);
    }
}

#check to see if any comics were downloaded or are downloadable
{
    my $good = 0;
    foreach (@rli) {
	$good = 1, last if $_->{'status'};
    }
    unless ($good) {
	if ($verbose) {
	    my $m = $dont_download ? "are downloadable" : "were downloaded";
	    print "\nNo comics $m.\n";
	}
    }
}

if ($make_webpage) {
    create_webpage();
} elsif ($dont_download) {
    print "\nURLs for images:\n\n" if $verbose;
    foreach (@rli) {
	if ($_->{'status'} == 2) {
	    print join("\n",@{$_->{'url'}});
	    print "\n";
	}
    }
}

#END of main

sub load_rcfile {
    foreach (@_) {
	my $file = $_;
	if (-f $file && -r $file) {
	    $@=0;
	    eval {require $file;};
	    if ($@) {
		print STDERR "Error loading rcfile: '$file':\n$@.\n";
		exit 1;
	    }
	}
    }
}

#Build the array of dates of comics to get
sub build_date_array {
    $days_of_comics = undef 
	if defined($days_of_comics) && $days_of_comics == 0;
    if (defined($days_of_comics)) {
	#incase user specified it with a minus sign.
	$days_of_comics = abs($days_of_comics);
	$days_of_comics--; #adjust for 0-base
    }

    my $get_current = 0; #use hof & lof or just hof
    #Determine the start & end dates
    if (! defined($end_date) && ! defined($days_of_comics) &&
	defined($start_date)) {
	#-S, no -E, no -n
	$end_date = time;
    } elsif (defined($end_date) && defined($days_of_comics) &&
	     ! defined($start_date)) {
	#no -S, -E, -n
	$start_date = $end_date - ($days_of_comics * 24*3600);
    } elsif (! defined($end_date) && defined($days_of_comics) &&
	     defined($start_date)) {
	#-S, no -E, -n
	$end_date = $start_date + ($days_of_comics * 24*3600);
    } elsif (! defined($end_date) && defined($days_of_comics) && 
	     ! defined($start_date)) {
	#no -S, no -E, -n
	$get_current = 1;
	$end_date = time - ($days_prior * 24*3600);
	$start_date = $end_date - ($days_of_comics * 24*3600);
    } elsif (! defined($end_date) && ! defined($days_of_comics) && 
	     ! defined($start_date)) {
	#no -S, no -E, no -n
	#we don't need to do anything special
	#add today's date (minus days prior) to the date array, and return.
	if (@dates == 0) {
	    push(@dates,(time - ($days_prior * 24*3600)));
	    $get_current = 1;
	}
	return $get_current;
    }

    {   #Build up the date array
	my $time_c = $start_date;
	my @e_day = gmtime($end_date);
	my @c_day = gmtime($time_c);
	my $e_day = strftime("%Y%m%d",@e_day);
	my $c_day = strftime("%Y%m%d",@c_day);
	while ($c_day <= $e_day) {
	    push(@dates,$time_c);
	    $time_c += 24*3600;
	    @c_day = gmtime($time_c);
	    $c_day = strftime("%Y%m%d",@c_day);
	}
    }
    return $get_current;
}

#Build up the list of resource locators
sub build_rli_array {
    my $get_current = shift; #accomodate the time for the rli hash function?
    if ($get_current) {
	build_rli_array_helper(\%lofhash,0,"Adding lof & get_current RLI's");
	#accomodate the time for the rli hash functions
	build_rli_array_helper(\%hof,1,"Adding hof & get_current RLI's");
    } else {
	build_rli_array_helper(\%hof,0,"Adding hof & !get_current RLI's");
    }
    print "\n" if $extra_verbose;
}

sub build_rli_array_helper {
    my ($hof,$usedays,$msg) = @_;
    print "\n$msg: " if $extra_verbose;
    my ($days, $fun, $time);
    while (($fun,$days) = each %$hof) {
	next if $usedays && ! defined $days;
	print "$fun " if $extra_verbose;
	foreach $time (@dates) {
	    if ($usedays) {
		$_ = run_rli_func($fun,$time,$fun,$days);
	    } else {
		$_ = run_rli_func($fun,$time,$fun);
	    }
	    $rli[@rli] = $_ if defined $_;
	}
    }
}

sub run_rli_func {
    my ($fun,$time,$fun_name,$days) = @_;
    $time -= $days * 24*3600 if defined $days;
    #get the info from the RLI
    if (ref($fun) =~ /(SUB|CODE)/) {
	$_ = &$fun($time,$prefer_color);
    } else {
	$_ = eval "$fun($time,$prefer_color)";
    }
    #remember which RLI that was & save the time
    if (defined($_)) {
	if (ref($_) eq "HASH") {
	    $_->{'time'} = $time;
	    $_->{'proc'} = $fun_name;
	    if (defined($comics{$fun})) {
		#copy in user-defined keys
		my $field;
		foreach $field (keys(%{$comics{$fun}})) {
		    $_->{$field} = $comics{$fun}{$field};
		}
	    }
	} else {
	    print STDERR "$fun: returned unsupported reference type: " .
		ref($fun) . ".\n";
	    $_ = undef;
	}
    }
    return $_;
}


#Engine for getting the comics.  
#Go through the list of RLI's and get the comic at each one.
sub get_comics {
    return () if @rli == 0;

    #use polymorphism to make it so that the user doesn't have to have 
    #libwww-perl installed, but can use a program like wget instead
    my $ua;
    if (defined($external_cmd)) {
	$@ = 1;
    } else {
	$@ = 0;
	eval {
	    require LWP;
	    require URI::URL;
	    require LWP::UserAgent;
	    require HTTP::Request;
	    require HTTP::Response;
	    require HTTP::Request::Common;
	  HTTP::Request::Common->import('GET');
	    $ua = LWP::UserAgent->new;
#	    $ua->redirect(0);
	};
    }
    if ($@) {
	*GET = sub {['GET',@_]};
	$ua = ExternalUserAgent->new;
	$ua->setVerbosity(($extra_verbose) ? 2 : $verbose);
	unless (defined($external_cmd)) {
	    print "\nlibwww-perl and/or URI are not installed.\n" .
		" Trying to download comics with wget instead.\n"
		    if $verbose;
	} else {
	    print "\nUsing '$external_cmd' to download comics.\n" 
		if $extra_verbose;
	    $ua->setCmd($external_cmd);
	}
    }

    if (defined $proxy_url) {
	print "using proxy, $proxy_url ...\n" if $verbose;
	$ua->proxy(['http', 'ftp'], $proxy_url);
    }
    my $response = undef;
    my @images = (); #list of comics successfully downloaded
    my @bad_images = (); #list of comic ids that had problems
    my @rli_queue = @rli;
  RLI: while (@rli_queue) {
	my $rli = pop(@rli_queue);
	next if ! defined $rli;
	my $proc = $rli->{'proc'};
	my $time = $rli->{'time'};
	my ($title,$name,$base,$page,$expr,$exprs,$func,$back,$mfeh)=(undef)x9;
	$name = $rli->{'name'} if defined $rli->{'name'};
	$base = $rli->{'base'} if defined $rli->{'base'};
	$page = $rli->{'page'} if defined $rli->{'page'};
	$expr = $rli->{'expr'} if defined $rli->{'expr'};
	$exprs=$rli->{'exprs'} if defined $rli->{'exprs'};
	$func = $rli->{'func'} if defined $rli->{'func'};
	$back = $rli->{'back'} if defined $rli->{'back'};
	$title = $rli->{'title'} if defined $rli->{'title'};

	$rli->{'status'} = 0;

	unless (defined($base)) {
	    print STDERR "Error: No base URL provided for the comic " .
		"identified by $proc. Not using $proc.\n";
	    next;
	}
      CONFIGNAME:
	if (defined($title) && !defined($name)) {
	    #todo: stick in here, using options to determine how to
	    #name the file.
	    $name = strftime("${title}-${date_fmt}",gmtime($time));
	} elsif (defined($name)) {
	    print "Warning for the comic identified by $proc:\n use of the " .
		"field 'name' has been depricated.\n" if $verbose;
	    #handle backwards compatibility and possibility of
	    #name being used with type or title
	    my $type = defined($rli->{'type'}) ? $rli->{'type'} : 'gif';
	    my ($title2,$type2) = parse_name($name);
	    $rli->{'title'} = $title2, $title = $title2 
		if defined $title2 && !defined $title;
	    $rli->{'type'} = $type, $type = $type2
		if defined $type2 && !defined $type;
	    if ($name !~ /[\.\d]/) {
		#assume name was mistakenly used instead of title
		print STDERR "Error: No type information provided for the " .
		    "comic identified by $proc. Not using $proc\n", next
			if ! defined $type && defined $title;
		#I know these goto statements aren't good programming, but
		#I'm trying to handle all possible error conditions here.
		$name = undef, goto CONFIGNAME 
		    if defined $title && defined $type;
	    }
	    #if no title or type could be extracted, trust that the
	    #name given was what they wanted
	} else { 
	    print STDERR "Error: No name or title provided for the " .
		"comic identified by $proc. Not using $proc\n";
	    next;
	}
	$name =~ s/\s/_/g;
	print "$comics_dir/$name\n"
	    if $verbose && ! $extra_verbose && ! $dont_download; 
	
        #handle backwards compatibility
	if (defined($exprs) && defined($expr)) {
	    print STDERR "Both exprs & expr are defined in the rli returned";
	    print STDERR " by $proc.  Please use only one. Skipping\n";
	    next;
	}
	if (defined($page) || defined($exprs)) {
	    #build up the exprs array
	    $exprs = [$expr] if defined($expr) && defined($page);
	    #make sure page is defined
	    $page = "" if defined($exprs) && ! defined($page);
	    #handle the multi-field expression hash or regular array of exprs
	    if (defined($exprs)) {
		$_ = ref($exprs);
		if (/HASH/) {
		    #advanced multi-field expression hash
		    $mfeh = $exprs;
		    if (defined($exprs = $mfeh->{'comic'})) {
			print "$name: Using comic in mfeh as exprs\n" 
			    if $extra_verbose;
			delete($mfeh->{'comic'});
			undef $mfeh if keys(%$mfeh) == 0;
		    } else {
			print STDERR "$name: must provide field 'comic' in " .
			    "'exprs' hash. Skipping $proc\n";
			next;
		    }
		} elsif (/ARRAY/) {
		    #good
		} else {
		    print STDERR "$name: exprs must either be an array or " .
			"a hash. Skipping $proc\n";
		    next;
		}
	    }

	} elsif (defined($expr)) {
	    #set page to $expr
	    $page = $expr;
	} elsif (defined($func)) {
	    #good.
	} else {
	    print STDERR "func, exprs, page, nor expr are defined in the rli ";
	    print STDERR "returned by $proc. Please use at least one of them.";
	    print STDERR " Skipping\n";
	    next;
	}

	#set the download status:
	#0: didn't download--can't even use URL
	#1: successfully downloaded
	#2: didn't download, but URL is available
	#3: didn't download--using backup

	my $request;
	my $i = 0; #number of the URL gotten
	if (defined($page)) {
	    my $url = "$base$page";
	    print "$name($i): $url\n" if $extra_verbose;
	    #don't download if this is the last URL & $dont_download is set
	    if (!defined($func) && !defined($exprs) && $dont_download) {
		$rli->{'status'} = 2;
	    } else {
		$request = GET($url);
		$response = $ua->request($request);
		unless ($response->is_success) {
		    if (defined($back) && 
			add_back($back,$time,$proc,$rli,\@rli_queue,\@rli,
				 "$name($i): fetching '$url' failed.")) {
			next RLI;
		    }
		    push(@bad_images,$proc) 
			unless grep {/^$proc$/} @bad_images;
		    if (!$skip_bad_comics && !defined($func) && 
			!defined($exprs)) {
			#use the URL instead
			print "using the URL instead for $name ($i).\n"
			    if $verbose;
			$rli->{'status'} = 2;
		    } else {
			next RLI;
		    }
		}
	    }
	    $i++;

	    my $exp = "";
	    my $j = 0;
	    foreach $exp (@$exprs) {
		#get the location of the image in the html page just returned.
		my $text = $response->content;
		#match on the content as if it were a single line (/$exp/s)
		$_ = $text;
		unless (eval(/$exp/s)) {
		    if (defined($back) && 
			add_back($back,$time,$proc,$rli,\@rli_queue,\@rli,
				 "$name($i): match for '$exp' in $url failed")){
			next RLI;
		    }
		    print STDERR "failed to match against '$exp' ($i) for ";
		    print STDERR "$name in $url.\n";
		    push(@bad_images,$proc) 
			unless grep {/^$proc$/} @bad_images;
		    next RLI;
		}
		$url = "$base$1";
		
		#handle the multi-field expression hash
		foreach (keys(%$mfeh)) {
		    my $field = $_;
		    my $expr;
		    next unless defined ($expr = $mfeh->{$field}[$j]);
		    $_ = $text;
		    if (eval(/$expr/s)) {
			$rli->{$field} = $1;
			print "$name($i).$field: expr = '$expr'; success.\n"
			    if $extra_verbose;
		    } else {
			print "$name($i).$field: search with /$expr/ failed.\n"
			    if $verbose;
		    }
		}


		#get the next URL
		print "$name($i): expr = '$exp'; URL = $url\n" 
		    if $extra_verbose;
		#don't download if this is the last URL & $dont_download is set
		if (++$j == @$exprs && !defined($func) && $dont_download) {
		    $rli->{'status'} = 2;
		} else {
		    $request = GET($url);
		    $response = $ua->request($request);
		    unless ($response->is_success) {
			if (defined($back) && 
			    add_back($back,$time,$proc,$rli,\@rli_queue,\@rli,
				     "$name($i): fetching '$url' failed.")) {
			    next RLI;
			}
			print STDERR 
			    "failure fetching '$url' for $name ($i).\n";
			push(@bad_images,$proc) 
			    unless grep {/^$proc$/} @bad_images;
			if (!$skip_bad_comics && !defined($func) && 
			    $j == @$exprs) {
			    #use the URL instead
			    print "using the URL instead for $name ($i).\n"
				if $verbose;
			    $rli->{'status'} = 2;
			} else {
			    next RLI;
			}
		    }
		    $i++; #simply keep track for debugging purposes
		}
	    }
	    $rli->{'url'}=[$url] unless defined $func || defined $rli->{'url'};
	}

	#handle function returning relative URLs
	if (defined($func)) {
	    print "$name: applying function\n" if $extra_verbose;

	    #run the function, giving it the last response downloaded if any
	    my @relurls;
	    if (defined($page)) {
		@relurls = &$func($response->content);
	    } else {
		@relurls = &$func();
	    }		
	    
	    if (@relurls == 0) {
		if (defined($back) && 
		    add_back($back,$time,$proc,$rli,\@rli_queue,\@rli,
			     "$name($i): function returned no relative urls.")){
		    next RLI;
		}
		print "$name($i): function returned no relative urls.\n" 
		    if $extra_verbose;
		push(@bad_images,$proc) 
		    unless grep {/^$proc$/} @bad_images;
		next RLI;
	    }
 
	    my $j = 0;
RELURL:	    foreach (@relurls) {
		my $litem = $_;
		$_ = ref($litem);
		if (/HASH/) {
		    #special rli fields to be added (like with mfeh)
		    #instead of relative URLs.
		    my $key;
		    foreach $key (keys(%$litem)) {
			print "$name($i): adding field '$key' => " .
			    "'$litem->{$key}'\n" if $extra_verbose;
			$rli->{$key} = $litem->{$key};
		    }
		    next RELURL;
		} elsif (! /^$/) {
		    print STDERR "$name($i): list element of type $_ " .
			"returned by function is not yet supported.\n";
		    next RELURL;
		}

		my $url = "$base$litem";
		$j++; #used to append to the file name
		
		my $mname = $name;
		$mname ="${name}-$j" if @relurls > 1;

		print "$mname: $url\n" if $extra_verbose;
		if ($dont_download) {
		    $rli->{'status'} = 2;
		} else {
		    $request = GET($url);
		    $response = $ua->request($request);
		    unless ($response->is_success) {
			if (defined($back) && 
			    add_back($back,$time,$proc,$rli,\@rli_queue,\@rli,
				     "$name($i): fetching '$url' failed.")) {
			    next RLI;
			}
			print STDERR 
			    "failure fetching '$url' for $mname ($i).\n";
			push(@bad_images,$proc) 
			    unless grep {/^$proc$/} @bad_images;
			if (!$skip_bad_comics) {
			    #use the URL instead
			    print "using the URL instead for $name ($i).\n"
				if $verbose;
			    $rli->{'status'} = 2;
			} else {
			    next RLI;
			}
		    } else {
			$mname .= ".$rli->{'type'}";
			file_write("$comics_dir/$mname",$files_mode,
				   $response->content);
			push(@images,$mname);
			$rli->{'file'} = [] unless defined $rli->{'file'};
			$rli->{'file'}->[@{$rli->{'file'}}] = $mname;
		    }
		}
		$rli->{'url'} = [] unless defined $rli->{'url'};
		$rli->{'url'}->[@{$rli->{'url'}}] = $url;
		$i++; #simply keep track for debugging purposes
	    }
	} else  {
	    #complete the fields for the rli.
	    #first tack on the file type (it may have been changed thru 'exprs')
	    $name .= "." . $rli->{'type'};
	    $rli->{'name'} = $name;
	    push(@images,$name);
	    $rli->{'file'} = [$name];

	    #save the image to its file if it was successfully downloaded.
	    file_write("$comics_dir/$name", $files_mode, $response->content)
		unless $dont_download || $rli->{'status'} == 2;
	}
	#Eliminate the need to put mulitple status sets to 1 in the code
	#by assuming that if it was bad, next RLI or status set to 2 was
	#done.  If another status state is added, this may have to change.
	$rli->{'status'} = 1 if $rli->{'status'} == 0;
    }
    
    print "\nImages retrieved and placed in $comics_dir:\n@images\n" 
	if $extra_verbose && !$dont_download;
    if (@bad_images > 0) {
	print "To try retrieving the images that failed, run this command:\n";
	print "$script_name -c \"@bad_images\"";
	print " -n $days_of_comics" if ++$days_of_comics > 1;
	print " -W" if $make_webpage;
	print "=$comics_per_page" if defined $comics_per_page && $make_webpage;
	print $given_options;
	print "\n";
	print "Please, before sending in a bug report on a comic that doesn't";
	print " download,\ntry over a period of several days (or weeks, ";
	print "depending on the problem) to\nsee if it just happened to be ";
	print "that the website maintainer for that comic\n";
	print "didn't update the comic promptly.\n";
    }
    return @images;
}

#helper function for the engine get_comics()
sub add_back {
    my ($back,$time,$proc,$rli,$rli_queue,$rli_list,$errmsg) = @_;
    if (defined($_ = run_rli_func($back,$time,$proc))) {
	print $errmsg . ", using backup.\n" if $verbose;
	$rli->{'status'} = 3;
	push(@$rli_queue,$_);
	push(@$rli_list,$_);
	return 1;
    }
    return 0;
}


sub image_size {
    my $file = shift;
    return html_imgsize($file) unless $use_filecmd;

    $_ = `file $file`;
    if ($? == 0 && /(\d+) x (\d+)/) {
	return "WIDTH=$1 HEIGHT=$2";
    } else {
	return undef;
    }
}

sub create_webpage {
    #create a hash into the rli's
    my %rlis = ();
    foreach (@rli) {
	my $rli = $_;
	my $comic = $rli->{'name'};
	$_ = $rli->{'status'};
	if (/[03]/) {
	    #didn't download (if a backup was tried (3), there's another
	    #rli for the backup).
	    next;
	} elsif (/1/) {
	    print "No file for $comic. $inform_maintainer",next
		unless defined $rli->{'file'};
	    $rli->{'stat'} = "local";
	} elsif (/2/) {
	    print "No url for $comic. $inform_maintainer",next
		unless defined $rli->{'url'};
	    $rli->{'file'} = $rli->{'url'};
	    $rli->{'stat'} = "remote";
	} else {
	    print STDERR "Unsupported status ($_) for $comic. " .
		$inform_maintainer;
	    print "Skipping $comic in webpage.\n" if $verbose;
	    next;
	}
	$rlis{$comic} = $rli;
    }
    my @comics = keys(%rlis);
    print "comics = @comics\n" if $verbose;
    my $num_comics = @comics;
    if ($num_comics == 0) {
	print "\nNot creating a new webpage.\n" if $verbose;
	return;
    }
    unless ($dont_download && !$remake_webpage) {
	$@ = 0;
	eval {
	    require Image::Size;
	  Image::Size->import('html_imgsize');
	};
	if ($@) {
	    print "\nWarning: Image::Size not installed. Using the file " .
		"command instead.\n\n" if $verbose;
	    $use_filecmd = 1;
	}
    }
    print "\n" if $verbose;
    unless ($webpage_on_stdout) {
	print "Deleting old webpages ($comics_dir/<index.html,comic*.html>).\n" 
	    if $verbose;
	chdir $comics_dir;
	unlink <index.html>;
	unlink <comic*.html>;
    }

    if ($verbose) {
	print "Creating the webpage";
	print "s" if defined($comics_per_page);
	print ".\n";
    }

    my $time = time();
    my $datestr = strftime("%b %d, %Y",gmtime($time));
    my $ctime = ctime($time);

    #create a sorted list of the comics
    my @sorted_comics;
    if ($sort_by_date) {
	@sorted_comics = 
	    sort({libdate_sort($a,$b,$rlis{$a}{'time'},$rlis{$b}{'time'});} 
		 @comics);
    } else {
	@sorted_comics = sort(library_sort @comics);
    }
    print "sorted comics: @sorted_comics\n" if $extra_verbose;

    #determine number of groups of comics, and number of comics on each page
    $comics_per_page = $num_comics unless defined($comics_per_page); 
    my $num_groups = $num_comics / $comics_per_page;
    $num_groups =~ s/^(\d+)\.?\d*$/$1/;
    my $comics_on_last = $num_comics % $comics_per_page;
    $num_groups++ if $comics_on_last > 0;
    print "number of groups    = $num_groups\n" .
	"comics per page     = $comics_per_page\n" .
	"comics on last page = $comics_on_last\n"
	if $extra_verbose;

    #Load in the templates & do some initial filling in of info
    my @body_el_tmpl = ("");
    my $i = 1;
    while (-f "$html_tmpl_dir/body_el$i.html") {
	$body_el_tmpl[$i] = file_read("$html_tmpl_dir/body_el$i.html");
	$i++;
    }
    if ($#body_el_tmpl < 1) {
	die "Could not find the html body template files under the default " .
	    "directory:\n$html_tmpl_dir. Please use -t to specify the " .
		"correct location.";
    }
    my $head_tmpl=file_read("$html_tmpl_dir/head.html");
    my $links_tmpl=file_read("$html_tmpl_dir/links" . 
			     ($webpage_index? "_index" : "") . ".html");
    my $tail_tmpl=file_read("$html_tmpl_dir/tail.html");
    my $index_body_el_tmpl_tmpl=file_read("$html_tmpl_dir/index_body_el.html")
	if $webpage_index;

    my $index;
    if ($webpage_index) {
	#index head global info
	$index = $head_tmpl;
	$index =~ s/<NUM=FIRST>/1/g;
	$index =~ s/<NUM=(LAST|TOTAL)>/$num_comics/g;
	$index =~ s/<PAGETITLE>/$webpage_title/g;
	$links_tmpl =~ s/<FILE=INDEX>/$webpage_index_filename/g;
    }
    #replace head & tail template globals
    $head_tmpl =~ s/<PAGETITLE>/$webpage_title/g;
    $tail_tmpl =~ s/<CTIME>/$ctime/g;

    @_ = (\$head_tmpl);
    push(@_,\$index) if $webpage_index;
    foreach (@_) {
	$$_ =~ s/<DATE>/$datestr/g;
	my @ltime = localtime($time);
	while ($$_ =~ /<DATE FORMAT="([^\"]*)">/) {
	    my $datestr = strftime($1,@ltime); 
	    $$_ =~ s/<DATE FORMAT="([^\"]*)">/$datestr/;
	}
    }
    #replace comic webpage head template globals
    $head_tmpl =~ s/<LINK_COLOR>/$link_color/g;
    $head_tmpl =~ s/<VLINK_COLOR>/$vlink_color/g;
    $head_tmpl =~ s/<BACKGROUND>/$background/g;

    if ($webpage_index) {
	#replace index head globals
	$index =~ s/<LINK_COLOR>/$index_link_color/g;
	$index =~ s/<VLINK_COLOR>/$index_vlink_color/g;
	$index =~ s/<BACKGROUND>/$background/g;
    }

    $i = -1;
    my $first_file;
    while (++$i < $num_groups) {
	my $group = $i + 1;
	my $first = $i * $comics_per_page + 1;
	my $last  = $first + $comics_per_page - 1;
	$last = $first + $comics_on_last -1 
	    if ($group == $num_groups && $comics_on_last > 0);
	(my $filename = $webpage_filename_tmpl) =~ s/<NUM>/$group/g;
	my ($nextfile,$prevfile) = ($webpage_filename_tmpl) x 2;
	my $nextgroup = ($group == $num_groups)? 1 : $group +1;
	my $prevgroup = $group -1;
	if ($group == 1) {
	    $prevgroup = $num_groups;
	    $first_file = $filename;
	}
	$nextgroup = 1 if 
	$nextfile =~ s/<NUM>/$nextgroup/g;
	$prevfile =~ s/<NUM>/$prevgroup/g;

	print "\nCreating $filename ($first to $last of $num_comics)\n" 
	    if $extra_verbose && !$webpage_on_stdout;

	#replace group-global info
	my $head = $head_tmpl;
	my $links = "";
	my $body ="";
	my $tail = $tail_tmpl;
	$head =~ s/<NUM=FIRST>/$first/g;
	$head =~ s/<NUM=LAST>/$last/g;
	$head =~ s/<NUM=TOTAL>/$num_comics/g;
	if ($num_groups > 1) {
	    $links = $links_tmpl;
	    $links =~ s/<FILE=PREV>/$prevfile/g;
	    $links =~ s/<FILE=NEXT>/$nextfile/g;
	    $links =~ s/<NUM>/$comics_per_page/g;
	}
	my $index_body_el_tmpl;
	if ($webpage_index) {
	    $index_body_el_tmpl = $index_body_el_tmpl_tmpl;
	    $index_body_el_tmpl =~ s/<FILE=CURRENT>/$filename/g;
	    $index_body_el_tmpl =~ s/<PAGE=CURRENT>/$group/g;
	}

	my $comic;
	foreach $comic (@sorted_comics[($first-1)..($last-1)]) {
	    my $rli = $rlis{$comic};
	    my @gmtime = gmtime($rli->{'time'});
	    my $comic_id = $rli->{'proc'} . strftime("%Y%m%d",@gmtime);
	    my @image = @{$rli->{'file'}};
	    die "\nComics made up of more than $#body_el_tmpl files are not" .
		" supported.\n$inform_maintainer" if @image > $#body_el_tmpl;
	    my $body_el = $body_el_tmpl[@image];
	    
	    my $title;
	    if (defined($_ = $rli->{'main'})) {
		#link to the base URL of the site
		$title = "<A HREF=\"$_\">$rli->{'title'}</A>";
	    } else {
		$title = $rli->{'title'};
	    }
	    $title .= " by " . $rli->{'author'} if defined $rli->{'author'};
	    my $date = strftime("%a, %h %d, %Y",@gmtime);
	    if (defined($_ = $rli->{'url'}[0])) {
		#link to the comic at the site
		$title .= " <A HREF=\"$_\">($date)</A>";
	    } else {
		$title .= " ($date)";
	    }
	    if (defined($_ = $rli->{'archives'})) {
		#link to the site's archives
		$title .= " <A HREF=\"$_\"><FONT FACE=\"times\">" .
		    "<I>(archives)</I></FONT></A>";
	    }
	    print "$rli->{'title'} ($date)" if $extra_verbose;
	    my $caption = "";
	    $caption = "<TR><TD><CENTER>" . $rli->{'caption'} . 
		"</CENTER></TD></TR>" if defined $rli->{'caption'};

	    #global body element fields
	    $body_el =~ s/<COMIC_NAME>/$title/g;
	    $body_el =~ s/<CAPTION>/$caption/; 
	    $body_el =~ s/<COMIC_ID>/$comic_id/g;

	    for ($[..$#image) {
		my $num = $_ + 1;
		my $image = $image[$_];
		my $size = undef;
		#get the size from the file (status==1)
		$size = image_size("$comics_dir/$image") 
		    if $rli->{'status'} == 1;
		if (! defined($size) && defined($rli->{'size'})) {
		    #get the size from the specified default since this
		    #is either a URL or the size couldn't be determined
		    $size = "WIDTH=" . $rli->{'size'}->[0] .
			" HEIGHT=" . $rli->{'size'}->[1];
		}
		my $width = (defined($size) && $size =~ /(WIDTH=\d+)/) ? 
		    $1 : "";
		#catch all for size
		unless (defined($size)) {
		    if ($skip_bad_comics && $rli->{'status'} == 1) {
			next;
		    } else {
			$size = "";
		    }
		}
		print " $num: $image" if $extra_verbose;
		$body_el =~ s/<COMIC_FILE$num>/$image/g;
		#width should be global, but oh well.
		$body_el =~ s/<WIDTH>/$width/; 
                #not global so multiimage sizes don't override each other
		$body_el =~ s/<SIZE>/$size/; 
	    }
	    $body .= $body_el;

	    if ($webpage_index) {
		my $author = defined($rli->{'author'})? $rli->{'author'} : 
		    "(author unknown)";
		$_ = $index_body_el_tmpl;
		s/<COMIC_DATE>/$date/g;
		s/<COMIC_NAME>/$rli->{'title'}/g;
		s/<COMIC_AUTHOR>/$author/g;
		s/<COMIC_STATUS>/$rli->{'stat'}/g;
		s/<FILE=CURRENT>/$filename/g;
		s/<PAGE=CURRENT>/$group/g;
		s/<COMIC_ID>/$comic_id/g;
		$index .= $_;
	    }

	    print "\n" if $extra_verbose;
	}
	unless ($webpage_on_stdout) {
	    file_write("$comics_dir/$filename",$files_mode,
		       "$head$links$body$links$tail");
	    file_write("$comics_dir/$webpage_index_filename",$files_mode,
		       "$index$tail");
	} else {
	    print "$head$links$body$links$tail";
	}
    }

}

sub syscmd {
    my $cmd = shift(@_);
    print "$cmd\n";
    return system($cmd);
}

sub file_write {
    my $file = shift(@_);
    my $mode = shift(@_);
    my $exists = -f $file;
    open(F, ">$file") || die "Could not open \"$file\". $!";
    binmode(F);
    print(F @_);
    close(F);
    unless ($exists) {
	chmod($mode, $file) || die "Could not set \"$file\"'s permissions. $!";
    }
}

sub file_read {
    local $/;
    my $file = shift;
    open(F, "<$file") || die "Could not open \"$file\". $!";
    binmode(F);
    $/ = undef; #input record separator
    my $text = <F>;
    close(F);
    return $text;
}

sub date_from_filename {
    $_ = shift;
    if (/.*-(\d?\d?\d\d)(\d\d)(\d\d)(-\d+)?\.\w+/) {
	my ($year,$month,$day) = ($1,$2,$3);
	if ($year > 1900) {
	    $year -= 1900;
	} elsif ($year < 38) {
	    $year += 100;
	}
	return mkgmtime(0,0,0,$day,--$month,$year);
    } else {
	return undef;
    }
}

sub parse_name {
    $_ = shift();
    $_ =~ s/_/ /g; #remove underscores
    if (/(.*)-\d+(-\d+)?\.(\w+)/) {
	return($1,$3);
    } elsif (/^([^\.\d]+)$/) {
	#apparently no date or file type in the name (lack of period or digit)
	return($1,undef);
    } else {
	return (undef,undef);
    }
}

sub list_comics {
    my %hof = @_;
    my $today = time;
    my %names; #indexed by the comic name (not function) to make sorting easy
    my ($max_flen,$max_nlen) = (0,0,0);
    my $make_webpage = ($do_list_comics > 1)? 1 : 0;
    my ($f,$d);
    while (($f,$d) = each %hof) {
	my $i = -1;
	my $rh = undef;
	my $days = (defined $d) ? $d : 0;
	while ($i++ <= 21) {
	    #try to get a real name from the rli function 21 times
	    my $time = $today - (($days + $i) * 24*3600);
	    last if defined($rh = run_rli_func($f,$time,$f));
	}
	my $name;
	unless (defined($name = $rh->{'title'})) {
	    ($name,$_) = parse_name($rh->{'name'}) if defined($rh->{'name'});
	    $name = $f unless defined $name;
	}
	$names{$name} = [$f,(defined $d ? $d : -1)];
	my $len = length($f);
	$max_flen = $len +2 if $len > $max_flen;
	$len = length($name);
	$max_nlen = $len +1 if $len > $max_nlen;
    }
    my @names;
    if ($sort_by_date) {
	@names = sort({libdate_sort($a,$b,$names{$b}[1],$names{$a}[1]);}
		      keys(%names));
    } else {
	@names = sort(library_sort keys(%names));
    }
    my $title = 'Comic Name';
    my $lines = '----------';
    $names{$title} = ["id","days behind"];
    $names{$lines} = ["--","-----------"];

    print "<HTML><TITLE>Supported Comics</TITLE>\n</HEAD>\n<BODY>\n<TABLE>\n" 
	if $make_webpage;

    my $name;
    foreach $name ($title,$lines,@names) {
	my ($f,$d) = @{$names{$name}};
	print "<TR><TD>" if $make_webpage;
	print "$f";
	my $len = $max_flen - length($f);
	if ($make_webpage) {
	    print "</TD><TD>";
	} else {
	    print " " x $len;
	}
	print "$name";
	$len = $max_nlen - length($name);
	if ($make_webpage) {
	    print "</TD><TD>";
	} else {
	    print " " x $len;
	}
	if ($d eq "-1") {
	    print "N/A\n";
	} else {
	    print "$d\n";
	}
	print "</TD></TR>\n" if $make_webpage;
    }
    print "</TABLE>\n</BODY>\n<HTML>\n" if $make_webpage;
    exit 0;
}

sub load_modules {
    my @libdirs = @_;
    push(@INC,@libdirs);
    my $libdir;
    foreach $libdir (@libdirs) {
	if (opendir(DIR, $libdir)) {
	    my @modules = grep { /[^~]$/ && -f "$libdir/$_" } readdir(DIR);
	    closedir DIR;
	    print "Loading modules in $libdir: " if $extra_verbose;

	    my $module;
	    foreach $module (@modules) {
		next if $module =~ /\.pm$/;
		print "$module " if $extra_verbose;
		require "$libdir/$module" if (-r "$libdir/$module");
	    }
	    print "\n" if $extra_verbose;
	} else {
	    print STDERR "$libdir is not accessible. Skipping it.\n";
	}
    }
}

sub library_sort {
    (my $thea = $a) =~ s/^\s*(a|an|the)[\s_]+//i;
    (my $theb = $b) =~ s/^\s*(a|an|the)[\s_]+//i;
    return $thea cmp $theb;
}

sub libdate_sort {
    my ($a,$b,$ad,$bd) = @_;
    if ($ad == $bd) {
	(my $thea = $a) =~ s/^\s*(a|an|the)[\s_]+//i;
	(my $theb = $b) =~ s/^\s*(a|an|the)[\s_]+//i;
	return $thea cmp $theb;
    } else {
	return $bd <=> $ad;
    }
}

sub mkgmtime {
    return mktime(@_) + (3600*$tz);
}

{
    package MyResponse;

    sub new
    {
	my ($class,$success,$content) = @_;
	my $self = bless {
	    'content' => $content,
	    'success' => $success
	    }, $class;
	$self;
    }

    sub is_success
    {
	my $self = shift;
	$self->{'success'};
    }

    sub content
    {
	my $self = shift;
	$self->{'content'};
    }
}

{
    package ExternalUserAgent;

    sub new 
    {
	my ($class,$init) = @_;
	if (ref $init) {
	    die "Error!  handling references unimplmemented.\n";
	}
	my $self = bless {
	    'cmd' => "wget -q -O - ",
	    'verbose' => 0,
	    'extra_verbose' => 0
	    }, $class;
	$self;
    }


    sub setCmd
    {
	my ($self,$cmd) = @_;
	die "Error: External command must be a scalar.\n"
	    if (! defined($cmd) || ref($cmd));
	my $old = $self->{'cmd'};
	$self->{'cmd'} = $cmd;
	return $old;
    }

    sub setVerbosity
    {
	my ($self,$verbosity) = @_;
	die "Error: verbosity must be a scalar.\n"
	    if (! defined($verbosity) || ref($verbosity));
	$self->{'verbose'} = ($verbosity > 0) ? 1 : 0;
	$self->{'extra_verbose'} = ($verbosity > 1) ? 1 : 0;
    }

    sub proxy
    {
	die "Error: External Program proxy specification not supported.\n" .
	    "Specify it in the argument to -g instead.\n";
    }

    sub request 
    {
	my ($self,$type,$url) = @_;
	if (defined($type) && ref($type)) {
	    $url = $type->[1];
	    $type = $type->[0];
	}
	die "Error: HTTP request type $type uknown or unimplemented.\n"
	    unless ($type =~ /^GET$/);
	my $cmdline = $self->{'cmd'} . $url;
	print "Running: '$cmdline'." if $self->{'extra_verbose'};
	my $content = `$cmdline`;
	my $retval = $?;
	print " ret=$retval\n" if $self->{'extra_verbose'};
	return MyResponse->new(($retval) ? 0 : 1, $content);
    }
}


sub usage
{
    print "$script_name : download comics from the Web.\n";
    print << "END";
(c)1999 Ben Hochstedler <hochstrb\@cs.rose-hulman.edu>
usage: netcomics [-bBDhiIlLosuvv] [-c,-C "comic ids"] [-p proxy] [-S,-T,-E date]
                 [-n,-N days] [-d,-m,-t dir] [-f date_fmt] [-g [program]] [-nD]
                 [-r rc_file] [-W,-w[=n]] [-nw]
   -b: specify that you prefer the comics to be in black & white--not color
   -B: specify that you prefer the comics color (override rc file setting)
   -c: get the listed comics (ids are seperated by white spaces)
   -C: don't get the listed comics (ids are seperated by white spaces)
   -d: put comics into directory (default /var/spool/netcomics)
   -D: delete files in directory before retreiving
   -nD:don't delete files in directory (override rc file setting)
   -E: specify the ending date of a range of days of comics to retrieve
   -f: specify the date format used when naming files. default: '%y%m%d'
   -g: specify an external program to use instead of libwww-perl
   -h: show usage (doesn't download comics)
   -i: don't create an index for the webpages
   -I: create an index for the webpages (override rc file setting)
   -l: list supported comics & their identifiers (doesn't download comics)
   -L: sort comics by date in webpage, days behind when listing them
   -m: add dir to locations of comic modules (default /usr/share/netcomics)
   -M: only use directories for comics modules specified on the command line
   -n: retrieve this number of days of comics, going backwards. default is 1
   -N: retrieve this number of days prior to the currently available date
   -o: write the webpage on standard out
   -p: use the given url as the proxy
   -r: specify the rc filename (default ~/.netcomicsrc)
   -s: skip bad comics when creating the webpage
   -S: specify a starting date of a range of days of comics to retrieve
   -t: location of html tmpl files (default /usr/share/netcomics/html_tmpl)
   -T: specify a specific date of comics to retrieve
   -u: don't download comics. print URLs on stdout, or if creating a
       webpage, have the images be implemented using the URLs.
   -v: be a little verbose
   -vv:be extra verbose
   -w: create an html file, index.html, n comics per page
   -nw:don't create a webpage (override setting in rc file)
   -wt:specify a title for the webpage rather than the default
   -W: recreate webpage from all files in directory, n comics per page
END
    exit 0;
}
