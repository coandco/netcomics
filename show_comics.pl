#!/usr/bin/perl -w

=head1 NAME

show_comics - Show comics, distributed over a time interval

=head1 SYNOPSIS

B<show_netcomics> [B<-c> I<cmd>] [B<-d> I<dir>] [B<-f> I<rcfile>] [B<-l>|B<-t> I<hh:mm>] [B<-p> [cmd]] [B<-k> I<lockfile>|B<-K>] [B<-s> <hh:mm>]

=head1 DESCRIPTION

show_comics is used to display comics downloaded by netcomics.  It
first pops up a window to ask you what time you plan on leaving (in 24
hour time).  Using the time you entered, it will evenly distribute the
comics to be displayed from the time the script is run to the time you
specified you will leave.

Specify the comics you want to have displayed in a file called
~/.comics.  You may specify an alternate file on the command line.  If no
file exists, all comics will be displayed (all files that end 
with .gif, .jpg, or .jpeg in the directory).

If you don't have perlTk installed, use B<-l> to specify the time and to make
show_comics not try to pop up a window.

In a UNIX environment, you can utilize the lockfile mechanism to run
show_comics from many different places an not have to worry about
checking to make sure it is already running. For example, you can run
show_comics from your .xinitrc or .xsession as well as from a
crontab. If netcomics is run in the morning, say at 7:00 by a crontab,
then you could run show_comics from a cron job at 7:30, assuming
netcomics will take no more than 1/2 hour. Then, in your .xinitrc
file, you could also run show_comics if the time is greater than 7:30
(see B<-s>). Therefore, if you have logged into your computer before
7:30, show_comics won't run from your .xinitrc file, but once 7:30 has
come around, it will be run by your cron job. If you log into your
computer after 7:30, then show_comics will fail to run at 7:30
(assuming the program show_comics uses to check to see if the display
is available failed), and then show_comics will be run by your
.xinitrc file. 

=head1 OPTIONS

=over 4

=item B<-c> I<command>

Use the specified command to display each comic instead of the default: 
"nice -19 xv".

=item B<-d> I<dir>

Use the specified location of the comics to be displayed instead of using
the default directory: /var/spool/netcomics.

=item B<-f> I<filename>

Use the specified file instead of ~/.comics for the list of comics to
be displayed

=item B<-k> I<filename>

Specify the lock file's name.  Default is ~/.show_comics_lock.

=item B<-l> I<hh:mm>

Don't pop up a window and use the specified time as the time to leave.

=item B<-p> [I<cmd>]

Check to make sure the display is available and if not, quit. Optional
argument is the name of the program to use.  A non-zero return code
from this program indicates a failure to open the display. The default
program used is xdpyinfo.

=item B<-s> I<hh:mm>

Specify a time that if show_comics is run before during the day, it will just 
exit.

=item B<-t> I<hh:mm>

Specify the default time to be put in the pop-up window.

=item B<-v>
 
Output verbose messages.

=head1 FILES

=over 29

=item ~/.comics

Contains the a list of comics you want displayed, one per line.

=item /var/spool/netcomics

Default directory where comics and the web page are placed by netcomics.

=item ~/.show_comics_lock

Default lock file used to make sure only one instance of show_comics is run

=back

=head1 SEE ALSO

netcomics(1)

=head1 AUTHOR

Ben Hochstedler <hochstrb@cs.rose-hulman.edu>
ICQ: B<15469308> AIM: B<hochstrb>

=cut

use strict;
use POSIX;
#Tk loading is delayed until needed so that this script is usable  w/out 
#PerlTk can still use this script

$| = 1;

my $progname = "show_comics";
my @def_time = ("17","00");
my $dont_ask = 0;    
my $tmpdir = "/var/spool/netcomics";
my $cmd = "nice -19 xv";
my $check_display_cmd = "xdpyinfo";
my $rcfile = $ENV{'HOME'} . "/.comics";
my $lockfile = $ENV{'HOME'} . "/.show_comics_lock";
my $check_lock = 1;
my $created_lock = 0;
my $verbose = 0;
my $extra_verbose = 0;
my @start_time = ();

my $smushopt = 0;
while (@ARGV)
{
    $_ = shift(@ARGV);

    #set the display command
    if (/^-c$/) {
	if (@ARGV > 0) {
	    $cmd = shift(@ARGV);
	} else {
	    errmsg("Need a command. Use -h for usage.\n");
	    exit 1;
	}
    }
    
    #set the directory
    elsif (/^-d$/) {
	if (@ARGV > 0) {
	    $tmpdir = shift(@ARGV);
	} else {
	    errmsg("Need a directory name. Use -h for usage.\n");
	    exit 1;
	}
    }
    
    #verbosity
    elsif (/^-v/) {
	if ($verbose) {
	    $extra_verbose = 1;
	} else {
	    $verbose = 1;
	}
	$smushopt = 1;
    }
    
    #Specified default time or the leaving time
    elsif (/^-([lt])$/) {
	my $type = $1;
	my $good = 0;
	if (@ARGV > 0) {
	    my $time = shift(@ARGV);
	    if ($time =~ /^(\d\d?):(\d\d?)$/) {
		@def_time = ($1,$2);
		$good = 1;
	    }
	}
	$dont_ask = 1 if $type eq "l";
	unless ($good) {
	    errmsg("Need a time for an argument to -$type. It has the " .
		"form: hh:mm\n. Use -h for usage.\n");
	    exit 1;
	}
    }

    #rc file
    elsif (/^-f$/) {
	if (@ARGV > 0) {
	    $rcfile = shift(@ARGV);
	} else {
	    errmsg("Need a filename for an argument to -f. " .
		"Use -h for usage.\n");
	    exit 1;
	}
    }

    #don't use lock file
    elsif (/^-K/) {
	$check_lock = 0;
	$smushopt = 1;
    }
    
    #specify lock file
    elsif (/^-k$/) {
	if (@ARGV > 0) {
	    $lockfile = shift(@ARGV);
	} else {
	    errmsg("Need a filename for an argument to -k. " .
		"Use -h for usage.\n");
	    exit 1;
	}
    }

    elsif (/^-p(=(.*))?/) {
	#make sure the display is accessible
	my $override_dash = 0;
	my $override_next_opt = 0;
	if (defined($1)) {
	    unshift(@ARGV,$2);
	    infomsg("Pushing $2 onto command line arguments.\n")
		if $extra_verbose;
	    $override_dash = 1 if $2 =~ /^-/;
	} else {
	    $override_next_opt = 1 if /^-p.+/;
	}
	if (@ARGV > 0 && ! $override_next_opt && 
	    ($ARGV[0] !~ /^-/ || $override_dash)) {
	    $check_display_cmd = shift(@ARGV);
	} else {
	    $smushopt = 1;
	}
	infomsg("Running $check_display_cmd to see if display can be " .
		"openned.\n") if $extra_verbose;
	if (system("$check_display_cmd 2>&1 > /dev/null")/256 != 0) {
	    infomsg("$progname: unable to open display.\n");
	    exit 1;
	}
    }
    
    #Specified default time or the leaving time
    elsif (/^-s$/) {
	my $good = 0;
	if (@ARGV > 0) {
	    my $time = shift(@ARGV);
	    if ($time =~ /^(\d\d?):(\d\d?)$/) {
		@start_time = ($1,$2);
		$good = 1;
	    }
	}
	unless ($good) {
	    errmsg("Need a time for an argument to -s. It has the " .
		"form: hh:mm\n. Use -h for usage.\n");
	    exit 1;
	}
    }

    #Usage
    else {
	errmsg("Unknown option: $_.\n");
	usage();
    }
    
    #Allow for smushed-together options
    if ($smushopt) {
	$smushopt = 0;
	if (/^-.(.+)/) {
	    unshift(@ARGV,"-$1");
	    infomsg("Pushing -$1 onto command line arguments.\n") 
		if $extra_verbose;
	}
    }
}

lock_file();

#Create a list of files to display
opendir(DIR,$tmpdir) || die "Could not open the directory to $tmpdir: $!";
my @files = grep(/\.(gif|jpg|jpeg)$/,readdir(DIR));
closedir(DIR);
if (-f $rcfile && -r $rcfile) {
    open(FILE,"<$rcfile") || die "Could not open the file $rcfile: $!";
    my @comics = <FILE>;
    close(FILE);
    my @newfiles = ();
    my $comic;
    foreach $comic (grep(/^[^\#]/,@comics)) {
	chomp($comic);
	next if $comic =~ /^$/;
	my @l = grep(/^$comic/,@files);
	my $num = @l;
	push(@newfiles,@l) if @l > 0;
    }
    @files = @newfiles;
}
if (@files == 0) {
    infomsg("No comics to be displayed. Exiting.\n") if $verbose;
    exit(0);
}
infomsg("Comics to be displayed: @files\n") if $extra_verbose;

#check the time
my $time = time;
my @ltime = localtime($time);
if (@start_time > 0) {
    infomsg("Checking current time against start time.\n") if $extra_verbose;
    if (($ltime[2] == $start_time[0] && $ltime[1] < $start_time[1]) ||
	($ltime[2] < $start_time[0])) {
	infomsg("Exiting because the time ($ltime[2]:$ltime[1]) is before " .
	    "the allowed start time ($start_time[0]:$start_time[1]).\n")
		if $verbose;
	exit(0);
    }
}

#distribute the comics from now until when leaving
my ($hour,$minute) = @def_time;
($hour,$minute) = when_leaving_dialog(@def_time) unless $dont_ask;
infomsg("Time leaving: $hour:$minute\n") if $extra_verbose;
my $stop_time = mktime(0,$minute,$hour,@ltime[3..6]);
my $delaytime = (($stop_time - $time)/@files); 
$delaytime =~ s/(\d+).?\d*/$1/;  #make it a whole number

my $num = @files;
infomsg("Displaying $num comics from now until $hour:$minute, one every " .
    "$delaytime seconds\n") if $verbose;

#display the comics!
if (@files > 0) {
    foreach (@files) {
	my $syscmd = "$cmd $tmpdir/$_";
	infomsg("Running '$syscmd'\n") if $verbose;
	if ($delaytime > 0) {
	    system("$syscmd &");
	    infomsg("Sleeping for $delaytime seconds.\n") if $extra_verbose;
	    sleep $delaytime; 
	} else {
	    system("$syscmd");
	}
    }
}

sub when_leaving_dialog {
    my ($hour,$minute) = ("","");
    ($hour,$minute) = @_ if @_ == 2;

    eval {
	require Tk;
    };
    if ($@) {
	$_ = <<END;
WARNING! You don't have Tk installed.  Either install perlTk, or use the -l 
option next time.  Not querying for the end of the time interval.
END
	errmsg("$_\nDefaulting the time you're leaving to $hour:$minute.\n");
	return ($hour,$minute);
    }
    require Tk::Entry;
    require Tk::Label;

    my $top = MainWindow->new();
    $top->title ("Comics Display Distribution");
    my $label = $top->Label(-text => "When are you leaving?");
    my $entry_hour = $top->Entry(-width => 2);
    my $colon = $top->Label(-text => ":");
    my $entry_minute = $top->Entry(-width => 2);

    my $ok_cb = sub {
	$hour = $entry_hour->get();
	$minute = $entry_minute->get();
	if ($hour =~ /^\d\d?$/ && $hour < 24) {
	    if ($minute =~ /^\d\d?$/ && $minute < 60) {
		$top->destroy();
	    } else {
		errmsg("\nRange Error: Minutes must be from 0 to 59!\n")
		    if $verbose;
		$entry_minute->delete('0.0','end');
	    }
	} else {
	    errmsg("\nRange Error: Hourss must be from 0 to 59!\n")
		if $verbose;
	    $entry_hour->delete('0.0','end');
	}
    };

    my $button = $top->Button(-text => 'OK',-command => [$ok_cb]);
    
    $entry_hour->bind('<Return>' => [$ok_cb]);
    $entry_minute->bind('<Return>' => [$ok_cb]);
    
    $entry_hour->insert('end',$hour);
    $entry_minute->insert('end',$minute);
    
    $label->pack(-side => 'left');
    $entry_hour->pack(-side => 'left');
    $colon->pack(-side => 'left');
    $entry_minute->pack(-side => 'left');
    $button->pack(-side => 'bottom');

    my $x = int(($top->screenwidth - $top->reqwidth)/2 - $top->vrootx);
    my $y = int(($top->screenheight - $top->reqheight)/2 - $top->vrooty);
    $top->geometry("+$x+$y");

    Tk::MainLoop();
    
    $hour = "0$hour" if $hour =~ /^\d$/;
    $minute = "0$minute" if $minute =~ /^\d$/;
    return ($hour,$minute);
}

sub lock_file {
    return unless $check_lock;
    if (@_ == 0) {
	infomsg("Checking for lockfile.\n") if $extra_verbose;
	if (-e $lockfile) {
	    infomsg("Lockfile exists: $lockfile.\nCheck to make sure " .
		"another show_comics isn't running or use -K.\n") if $verbose;
	    exit(0);
	}
	if (open(FILE,">$lockfile")) {
	    print FILE "$$\n";
	    close(FILE);
	    $created_lock = 1;
	    $SIG{'INT'} = \&lock_file;
	    $SIG{'QUIT'} = \&lock_file;
	    $SIG{'KILL'} = \&lock_file;
	    $SIG{'TERM'} = \&lock_file;
	} else {
	    errmsg("Error: could not create lockfile $lockfile.\n" .
		"Either specify a different lockfile with -k or use -K.\n");
	    exit(1);
	}
    } elsif ($created_lock) { #don't remove a lock on END if didn't create it
	$_ = shift;
	infomsg("Received $_. Removing lockfile.\n") if $extra_verbose;
	#any other signal, we delete it & exit
	if (-f $lockfile) {
	    if (unlink($lockfile)) {
		$check_lock = 0;
	    } else {
		errmsg("Could not delete $lockfile.\n") if $verbose;
	    }
	} else {
	    errmsg("Warning: no lockfile ($lockfile).\n") if $verbose;
	}
	exit(0);
    }
}
sub END {
    lock_file("END");
}

sub infomsg {
    print "show_comics: " . $_[0];
}

sub errmsg {
    print STDERR "show_comics: " . $_[0];
}

sub usage {
    print <<END;
$progname:  Show comics downloaded with netcomics, distributed over time
(c)1999 Ben Hochstedler <hochstrb\@cs.rose-hulman.edu>
usage: show_comics [-h] [-c cmd] [-d dir] [-f rcfile] [-l|-t hh:mm] [-p [cmd]]
                   [-k lockfile|-K] [-s hh:mm]
  -c: specify the command used to display each comic strip (def: "nice -19 xv")
  -d: specify the directory where the comics reside (def: /var/spool/netcomics)
  -f: specify the file containing the list of comics to display (def: ~/.comics)
  -h: display usage
  -k: specify the name of the lock file (def: ~/.show_comics_lock)
  -K: don't use a lock file
  -l: specify the time you're going to leave instead of poping up a dialog box
  -p: check to make sure the display is available and if not, quit. optional
      argument is the name of the program to use.  a non-zero return code
      from this program indicates a failure to open the display.
  -s: don't run if the current time is before the specified time.
  -t: specify the default time to be placed in the dialog box
  -v: be verbose

Be sure to set the DISPLAY variable.
END
    exit 1;
}
