#-*- tab-width: 4 -*-
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Library General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

package Netcomics::HTML;

use POSIX;
use strict;
use Carp;
use Netcomics::Util;
use Netcomics::Config;

#class attributes
my $inform_maintainer = "Please inform the maintainer of netcomics:\n" .
    "Ben Hochstedler <hochstrb\@cs.rose-hulman.edu>.\n";
my $files_mode = 0644;

sub new {
	my ($class,$init) = @_;

	# Load the templates based off of config data from imported 
	# Netcomics::Config.
	my $i = 1;
	my @body_el_tmpl;
	while (-f "$webpage_templates/body_el$i.html") {
		$body_el_tmpl[$i] = file_read("$webpage_templates/body_el$i.html");
		$i++;
	}
	if ($#body_el_tmpl < 1) {
		die "Could not find the html body template files under the default " .
			"directory:\n$webpage_templates. Please use -t to specify the " .
				"correct location.";
	}

	# Load this information into data held in the object.
	my $self = {
				'body_el_tmpl' => \@body_el_tmpl,
				'head_tmpl' => file_read("$webpage_templates/head.html"),
				'links_tmpl' => file_read("$webpage_templates/links" . 
										  ($webpage_index ? "_index" : "") .
										  ".html"),
				'tail_tmpl' => file_read("$webpage_templates/tail.html"),
				'index_body_el_tmpl_tmpl' => file_read("$webpage_templates/index_body_el.html")
			   };

	#replace comic webpage head template globals
	$self->{'head_tmpl'} =~ s/<LINK_COLOR>/$link_color/g;
	$self->{'head_tmpl'} =~ s/<VLINK_COLOR>/$vlink_color/g;
	$self->{'head_tmpl'} =~ s/<BACKGROUND>/$background/g;

	# Bless object and return it.
	bless $self, $class;

	return $self;
}

sub reset_date_attributes {
	my $self = shift;
	$self->{'num_groups'} = undef;
	$self->{'num_comics'} = undef;
	$self->{'comics_on_last'} = undef;
	$self->{'ctime'} = undef;
}

sub create_webpage {
	my $self = shift();
	my @rli = @_;

	#create a hash into the rli's
	my %rlis = ();

	%rlis = check_rlis(@rli);
	my @comics = keys(%rlis);
	print "comics = @comics\n" if $verbose;
	$self->{'num_comics'} = @comics;
	if ($self->{'num_comics'} == 0) {
		print "\nNot creating a new webpage.\n" if $verbose;
		return;
	}
	print "\n" if $verbose;
	unless ($webpage_on_stdout) {
		print "Deleting old webpages (".$comics_dir . 
				"/<index.html,comic*.html>).\n" if $verbose;
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
	$self->{'datestr'} = strftime("%b %d, %Y",gmtime($time));
	$self->{'ctime'} = ctime($time);

	#create a sorted list of the comics
	my @sorted_comics = sort({libdate_sort($a, $b, $rlis{$a}{'time'},
										   $rlis{$b}{'time'}, $sort_by_date);} 
							 @comics);
	print "sorted comics: @sorted_comics\n" if $extra_verbose;

	#determine number of groups of comics, and number of comics on each page
	$comics_per_page = $self->{'num_comics'}
			unless defined($comics_per_page); 
	$self->{'num_groups'} = $self->{'num_comics'} / $comics_per_page;
	$self->{'num_groups'} =~ s/^(\d+)\.?\d*$/$1/;
	$self->{'comics_on_last'} = $self->{'num_comics'} % $comics_per_page;
	$self->{'num_groups'}++ if $self->{'comics_on_last'} > 0;
	print "number of groups    = $self->{'num_groups'}\n" .
		"comics per page     = $comics_per_page\n" .
			"comics on last page = $self->{'comics_on_last'}\n"
				if $extra_verbose;

	# Load templates from object.
	my $head_tmpl = $self->{'head_tmpl'};
	my $links_tmpl = $self->{'links_tmpl'};
	my $tail_tmpl = $self->{'tail_tmpl'};

	#replace head & tail template globals
	$head_tmpl =~ s/<PAGETITLE>/$webpage_title/g;

	# Process the index.
	my $index;
	if ($webpage_index) {
		#index head global info
		$index = $head_tmpl;
		$index =~ s/<NUM=FIRST>/1/g;
		$index =~ s/<NUM=(LAST|TOTAL)>/$self->{'num_comics'}/g;
		$index =~ s/<PAGETITLE>/$webpage_title/g;
		$links_tmpl =~ s/<FILE=INDEX>/${webpage_index}_filename/g;
	}
	@_ = (\$head_tmpl);
	push(@_,\$index) if $webpage_index;
	foreach (@_) {
		$$_ =~ s/<DATE>/$self->{'datestr'}/g;
		my @ltime = localtime($time);
		while ($$_ =~ /<DATE FORMAT="([^\"]*)">/) {
			my $datestr = strftime($1,@ltime); 
			$$_ =~ s/<DATE FORMAT="([^\"]*)">/$datestr/;
		}
	}

	my $i = -1;
	while (++$i < $self->{'num_groups'}) {
		my $group = $i;
		$group++;
		(my $filename = $webpage_filename_tmpl) =~ s/<NUM>/$group/g;
		my ($page, $index_body) = 
			generate_HTML_page($self, \%rlis, 
							   \@sorted_comics, $i);

		$index .= $index_body;

		unless ($webpage_on_stdout) {
			file_write("$comics_dir/$filename",$files_mode,
					   "$page");
		} else {
			print "$page";
		}
	}
	if ($webpage_index && ! $webpage_on_stdout) {
		file_write("$comics_dir/$webpage_index_filename",
				   $files_mode, "$index$tail_tmpl");
	}
}

sub create_webpage_set {
	my $self = shift();
	my $rli_tmp = shift;
	my @rli = @$rli_tmp;
	my $sel_tmp = shift;
	my @selected_comics = @$sel_tmp;
	my $files_mode = 0644;
	
	foreach my $comic_working (@selected_comics) {
		my %rlis = ();
		my @rli_work = @rli;
		my @current_comic_being_worked_on = ( );
		my $subdir;
		my $comic_title;
		print "\nWorking on: $comic_working\n" if $verbose;
		foreach my $rli_scan (@rli_work) {
			if ($comic_working eq $rli_scan->{'proc'}) {
				push(@current_comic_being_worked_on, $rli_scan);
				$subdir = $rli_scan->{'subdir'} if defined($rli_scan->{'subdir'});
				$comic_title = $rli_scan->{'title'} if defined($rli_scan->{'title'});
			}
		}
		%rlis = check_rlis(@current_comic_being_worked_on);
		my @comics = keys(%rlis);
		print "comics = @comics\n" if $verbose;
		$self->{'num_comics'} = @comics;
		if ($self->{'num_comics'} == 0) {
			print "\nNot creating a new webpage.\n" if $verbose;
			next;
		}
		print "\n" if $verbose;
		unless ($webpage_on_stdout) {
			print "Deleting old webpages (".$comics_dir . $subdir .
			"/<index.html,comic*.html>).\n" if $verbose;
			chdir "$comics_dir/$subdir/";
			unlink <index.html>;
			unlink <comic*.html>;
		}

		if ($verbose) {
			print "Creating the webpage";
			print "s" if defined($comics_per_page);
			print ".\n";
		}

		my $time = time();
		$self->{'datestr'} = strftime("%b %d, %Y",gmtime($time));
		$self->{'ctime'} = ctime($time);

		#create a sorted list of the comics
		my @sorted_comics = sort({libdate_sort($a, $b,
										   $rlis{$a}{'time'}, $rlis{$b}{'time'},
											   $sort_by_date);} 
								 @comics);
		print "sorted comics: @sorted_comics\n" if $extra_verbose;

		#determine number of groups of comics, and number of comics on
		#each page
		$comics_per_page = $self->{'num_comics'} unless 
				defined($comics_per_page); 
		$self->{'num_groups'} = $self->{'num_comics'} / $comics_per_page;
		$self->{'num_groups'} =~ s/^(\d+)\.?\d*$/$1/;
		$self->{'comics_on_last'} = $self->{'num_comics'} % $comics_per_page;
		$self->{'num_groups'}++ if $self->{'comics_on_last'} > 0;
		print "number of groups    = $self->{'num_groups'}\n" .
		"comics per page     = $comics_per_page\n" .
			"comics on last page = $self->{'comics_on_last'}\n"
				if $extra_verbose;

		# Load templates from object.
		my $head_tmpl = $self->{'head_tmpl'};
		my $links_tmpl = $self->{'links_tmpl'};
		my $tail_tmpl = $self->{'tail_tmpl'};

		#replace head & tail template globals
		$head_tmpl =~ s/<PAGETITLE>/$webpage_title/g;

		# Process the index.
		my $index;
		if ($webpage_index) {
			#index head global info
			$index = $head_tmpl;
			$index =~ s/<NUM=FIRST>/1/g;
			$index =~ s/<NUM=(LAST|TOTAL)>/$self->{'num_comics'}/g;
			$index =~ s/<PAGETITLE>/$webpage_title/g;
			$links_tmpl =~ s/<FILE=INDEX>/${webpage_index}_filename/g;
		}
		@_ = (\$head_tmpl);
		push(@_,\$index) if $webpage_index;
		foreach (@_) {
			$$_ =~ s/<DATE>/$self->{'datestr'}/g;
			my @ltime = localtime($time);
			while ($$_ =~ /<DATE FORMAT="([^\"]*)">/) {
				my $datestr = strftime($1,@ltime); 
				$$_ =~ s/<DATE FORMAT="([^\"]*)">/$datestr/;
			}
		}
		
		my $i = -1;
		while (++$i < $self->{'num_groups'}) {
			my $group = $i;
			$group++;
			(my $filename = $webpage_filename_tmpl) =~ s/<NUM>/$group/g;
			my ($page, $index_body) = 
				generate_HTML_page($self, \%rlis, 
								   \@sorted_comics, $i);

			$index .= $index_body;

			unless ($webpage_on_stdout) {
				file_write("$comics_dir/$subdir/$filename",$files_mode,
						   "$page");
			} else {
				print "$page";
			}
		}
		if ($webpage_index && ! $webpage_on_stdout) {
			file_write("$comics_dir/$subdir/$webpage_index_filename",
					   $files_mode, "$index$tail_tmpl");
		}
	}
}

sub generate_HTML_page {
	my ($self, $b, $c, $i) = @_;
	my @body_el_tmpl = @{$self->{'body_el_tmpl'}};
	my %rlis = %$b;
	my @sorted_comics = @$c;

	my $group = $i + 1;
	my $first = $i * $comics_per_page + 1;
	my $last  = $first + $comics_per_page - 1;
	$last = $first + $self->{'comics_on_last'} -1 
		if ($group == $self->{'num_groups'} && $self->{'comics_on_last'} > 0);
	(my $filename = $webpage_filename_tmpl) =~ s/<NUM>/$group/g;
	my ($nextfile,$prevfile) = ($webpage_filename_tmpl) x 2;
	my $nextgroup = ($group == $self->{'num_groups'})? 1 : $group +1;
	my $prevgroup = $group -1;
	if ($group == 1) {
		$prevgroup = $self->{'num_groups'};
	}
	$nextgroup = 1 if $nextfile =~ s/<NUM>/$nextgroup/g;
	$prevfile =~ s/<NUM>/$prevgroup/g;

	print "\nCreating $filename ($first to $last of $self->{'num_comics'})\n" 
		if $extra_verbose && !$webpage_on_stdout;

	#replace group-global info
	my $head = $self->{'head_tmpl'};
	my $links = "";
	my $body ="";
	my $index = "";
	$head =~ s/<NUM=FIRST>/$first/g;
	$head =~ s/<NUM=LAST>/$last/g;
	$head =~ s/<NUM=TOTAL>/$self->{'num_comics'}/g;
	if ($self->{'num_groups'} > 1) {
		$links = $self->{'links_tmpl'};
		$links =~ s/<FILE=PREV>/$prevfile/g;
		$links =~ s/<FILE=NEXT>/$nextfile/g;
		$links =~ s/<NUM>/$comics_per_page/g;
	}

	my $index_body_el_tmpl;
	if ($webpage_index) {
		$index_body_el_tmpl = $self->{'index_body_el_tmpl_tmpl'};
		$index_body_el_tmpl =~ s/<FILE=CURRENT>/$filename/g;
		$index_body_el_tmpl =~ s/<PAGE=CURRENT>/$group/g;
	}

	foreach my $comic (@sorted_comics[($first-1)..($last-1)]) {
		my $rli = $rlis{$comic};
		my @gmtime = gmtime($rli->{'time'});
		my $comic_id = $rli->{'name'};
		my @image = @{$rli->{'file'}};
	    print STDERR "\nComics made up of more than $#body_el_tmpl files" .
			" are not supported.\n$inform_maintainer", next
				if @image > $#body_el_tmpl;
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
			next unless defined $image;
			my $size = undef;
			#get the size from the file (status==1)
			$size = image_size( ($comics_dir . "/$image") ) 
				if $rli->{'status'} == 1;
			if (! defined($size) && defined($rli->{'size'})) {
				my $size = $rli->{'size'};
				if (ref($size) ne "ARRAY") {
					print STDERR "$rli->{'title'}: size is not an array:" .
						"\"$size\".  Please inform the comic maintainer.\n"
							if $verbose;
				} else {
					#get the size from the specified default since this
					#is either a URL or the size couldn't be determined
					$size = "WIDTH=" . $size->[0] .
						" HEIGHT=" . $size->[1];
				}
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
			$image = $comics_dir."/".$image if $webpage_absolute_paths;
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

	# Create the "$page" out of elements and fill common variables.
	my $page = "$head$links$body$links$self->{'tail_tmpl'}";
	$page =~ s/<PAGETITLE>/$webpage_title/g;
	$page =~ s/<CTIME>/$self->{'ctime'}/g;
	$page =~ s/<DATE>/$self->{'datestr'}/g;

	# Do the same for $index.
	$index =~ s/<PAGETITLE>/$webpage_title/g;
	$index =~ s/<CTIME>/$self->{'ctime'}/g;
	$index =~ s/<DATE>/$self->{'datestr'}/g;

	return("$page", $index);
}

=head2 check_rlis(@rli_array)

Use check_rlis to get a hash returned, with only the comics that exist.

=cut

sub check_rlis {
	my @rli = @_;
	my %rlis = ();

	foreach (@rli) {
		my $rli = $_;

		next if (!$remake_webpage && defined($rli->{'reloaded'}));
		my $comic = $rli->{'name'};
		$_ = $rli->{'status'};
		if (! defined($_)) {
			print STDERR "$comic has an undefined status. Skipping.\n" 
				if $verbose;
			next;
		} elsif (/[03]/) {
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
			print "Skipping $comic in operation.\n" if $verbose;
			next;
		}
		$rlis{$comic} = $rli;
	}
	return(%rlis);
}

1;