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

use Netcomics::HTML::Theme;

package Netcomics::HTML::Themes::CleanRound;
use vars '@ISA'; @ISA = ("Netcomics::HTML::Theme");
use strict;

my (%html,%imgs);

$html{'head'} = <<END_HEAD;
<HTML>

<HEAD>
  <TITLE><PAGETITLE> (<NUM=FIRST>-<NUM=LAST> of <NUM=TOTAL>)</TITLE>
</HEAD>

<BODY <LINK_COLOR> <VLINK_COLOR> <BACKGROUND>>
<CENTER>
  <H1><PAGETITLE> (<NUM=FIRST>-<NUM=LAST> of <NUM=TOTAL>)</H1>
</CENTER>

END_HEAD

$html{'links'} = <<END_LINKS;
<TABLE WIDTH=100%>
  <TR>
    <TD ALIGN=left><A HREF="<FILE=PREV>"><img border=0 src="<THEME_DIR>/prev.gif"></A></TD>
    <TD ALIGN=right><A HREF="<FILE=NEXT>"><img border=0 src="<THEME_DIR>/next.gif"></A></TD>
  </TR>
</TABLE>
END_LINKS
$html{'pre_body'} = <<END_PRE_BODY;
<TABLE WIDTH=100%>
END_PRE_BODY

$html{'body'} = <<END_BODY;
  <tr><td>
      <table cellspacing=0 cellpadding=0 border=0>
	<tr>
	  <td><img width=20 height=20 src="<THEME_DIR>/top_l.gif"></td>
	  <td><img <WIDTH> height=20 src="<THEME_DIR>/top.gif"></td>
	  <td><img width=20 height=20 src="<THEME_DIR>/top_r.gif"></td>
	</tr>
	<tr>
	  <td><img width=20 height=48 src="<THEME_DIR>/left.gif"></td>
	  <td <WIDTH> bgcolor=black align=center><font face="Arial,Helvetica" size=+1 color=white><b><a name="<COMIC_ID>"><COMIC_NAME></a></b></font></td>
	  <td><img width=20 height=48 src="<THEME_DIR>/right.gif"></td>
	</tr>
	<tr>
	  <td><img width=20 <HEIGHT> src="<THEME_DIR>/left.gif"></td>
	  <td><ELEMENT></td>
	  <td><img width=20 <HEIGHT> src="<THEME_DIR>/right.gif"></td>
	</tr>
	<tr>
	  <td><img width=20 height=20 src="<THEME_DIR>/bot_l.gif"></td>
	  <td><img <WIDTH> height=20 src="<THEME_DIR>/bot.gif"></td>
	  <td><img width=20 height=20 src="<THEME_DIR>/bot_r.gif"></td>
	</tr>
      </table>
      <CAPTION>
  </td></tr>
END_BODY

$html{'body_el'} = <<END_BODY_ELEMENT;
<A HREF="<COMIC_FILE>"><IMG BORDER=0 SRC="<COMIC_FILE>" <SIZE>></A>
END_BODY_ELEMENT

$html{'caption'} = <<END_CAPTION;
<TR><TD><CENTER><CAPTION_DATA></CENTER></TD></TR>
END_CAPTION

$html{'post_body'} = <<END_POST_BODY;
</TABLE>
END_POST_BODY

$html{'tail'} = <<END_TAIL;

<HR>
<FONT SIZE=-1><CENTER>This page was created by the CleanRound theme on <CTIME>.</CENTER></FONT>
</BODY>
</HTML>
END_TAIL

$html{'links_index'} = <<END_LINKS_INDEX;
<TR><TD>
  <TABLE WIDTH=100%>
    <TR>
      <TD ALIGN=left><A HREF="<FILE=PREV>"><img border=0 src="<THEME_DIR>/prev.gif"></A></TD>
      <TD ALIGN=center><A HREF="<FILE=INDEX>"><img border=0 src="<THEME_DIR>/index.gif"></A></TD>
      <TD ALIGN=right><A HREF="<FILE=NEXT>"><img border=0 src="<THEME_DIR>/next.gif"></A></TD>
    </TR>
  </TABLE>
</TD></TR>
END_LINKS_INDEX

$html{'index_element'} = <<END_INDEX_ELEMENT;
  <TR>
    <TD><A HREF="<FILE=CURRENT>#<COMIC_ID>"><COMIC_NAME></A></TD>
    <TD ALIGN=right><COMIC_DATE></TD>
    <TD><COMIC_AUTHOR></TD>
    <TD><COMIC_STATUS></TD>
    <TD ALIGN=right><A HREF="<FILE=CURRENT>"><PAGE=CURRENT></A></TD>
  </TR>
END_INDEX_ELEMENT

$imgs{'bot.gif'} = <<END_MIME;
R0lGODlhFAAUAKEAAAAAAL+/v/f39////yH+G05ldGNvbWljcyBjbGVhbiByb3VuZCB0aGVt
ZQAh+QQBCgADACwAAAAAFAAUAAACHpSPqcvtD6OctNqLXdi8ez+E4kiW5omm6sq27gubBQA7
END_MIME

$imgs{'bot_l.gif'} = <<END_MIME;
R0lGODlhFAAUAKEAAAAAAL+/v/f39////yH+G05ldGNvbWljcyBjbGVhbiByb3VuZCB0aGVt
ZQAh+QQBCgADACwAAAAAFAAUAAACLZxvIcstiJRz8MjJasJNj8t5ICaOlMgt3mdma9A+K2vO
FowH9s73/g8MCoeQAgA7
END_MIME

$imgs{'bot_r.gif'} = <<END_MIME;
R0lGODlhFAAUAKEAAAAAAL+/v/f39////yH+G05ldGNvbWljcyBjbGVhbiByb3VuZCB0aGVt
ZQAh+QQBCgADACwAAAAAFAAUAAACLpSPEsPNCZdrMMk5KrpTH+54Bkh5AfmYWFmdaxqh7Oe+
zInX9s73/g8MCodEYQEAOw==
END_MIME

$imgs{'index.gif'} = <<END_MIME;
R0lGODlhFAAUAKEAAL+/v/f39////////yH+G05ldGNvbWljcyBjbGVhbiByb3VuZCB0aGVt
ZQAh+QQBCgACACwAAAAAFAAUAAACOJR/AMhtEMJyDkZJmb04i811VRhOGkmaD4qaIMstyqyk
tNK8YqarVO9ZlYKfFBEYRHqUPGPSiSgAADs=
END_MIME

$imgs{'left.gif'} = <<END_MIME;
R0lGODlhFAAUAKEAAAAAAL+/v/f39////yH+G05ldGNvbWljcyBjbGVhbiByb3VuZCB0aGVt
CgAh+QQBCgADACwAAAAAFAAUAAACLZxvIcstiJRz8MjJasJNj8t5ICZymTZOpfmgbFullMuu
ph3St57HL07iBX2sAgA7
END_MIME

$imgs{'next.gif'} = <<END_MIME;
R0lGODlhHgAUAKEAAL+/v/f39////////yH+G05ldGNvbWljcyBjbGVhbiByb3VuZCB0aGVt
ZQAh+QQBCgACACwAAAAAHgAUAAACRJSPmaDtDtibMEiKDQg2581dXsV1R4Sm6gqWVwnH8hwa
9I13+S63PO/74RjCnYSFXMVEI4SP2Ty5oiQoVWO6KiJayKMAADs=
END_MIME

$imgs{'prev.gif'} = <<END_MIME;
R0lGODlhHgAUAKEAAL+/v/f39////////yH+G05ldGNvbWljcyBjbGVhbiByb3VuZCB0aGVt
ZQAh+QQBCgACACwAAAAAHgAUAAACR5R/gMvNoJyUIMSJU7C51311zgeK1IZC6sq2EYnG8jwL
MI3nd87Lew+0AYcow49YM/pcTBYCFjI9UtLJJ1pdVLDZJ7ebABcAADs=
END_MIME

$imgs{'right.gif'} = <<END_MIME;
R0lGODlhFAAUAKEAAAAAAL+/v/f39////yH+HE5ldGNvbWljcyBjbGVhbiByb3VuZCB0aGVt
ZQoAIfkEAQoAAwAsAAAAABQAFAAAAi6UjxLDzQmXazDJOSq6Ux/ueAZIieRjYqh3ZqkqKqrL
znF72y+Ww3v3CwVLNVUBADs=
END_MIME

$imgs{'top.gif'} = <<END_MIME;
R0lGODlhFAAUAKEAAAAAAL+/v/f39////yH+G05ldGNvbWljcyBjbGVhbiByb3VuZCB0aGVt
CgAh+QQBCgADACwAAAAAFAAUAAACHpyPqcvtD6OctK6As95b+A+G4kiW5omm6sq27gubBQA7
END_MIME

$imgs{'top_l.gif'} = <<END_MIME;
R0lGODlhFAAUAKEAAAAAAL+/v/f39////yH+G05ldGNvbWljcyBjbGVhbiByb3VuZCB0aGVt
ZQAh+QQBCgADACwAAAAAFAAUAAACK5yPqcvtD6OctFoTsg5Piw86GUgKzViGTJCSK9t+a6wq
MD3T5nLHOc7TCQoAOw==
END_MIME

$imgs{'top_r.gif'} = <<END_MIME;
R0lGODlhFAAUAKEAAAAAAL+/v/f39////yH+G05ldGNvbWljcyBjbGVhbiByb3VuZCB0aGVt
ZQAh+QQBCgADACwAAAAAFAAUAAACK5yPqcvtD6OctK6Ac4ii+/x4ooA5o1gyJ9qs37a4nyqT
tAwrtR3XebL7IQoAOw==
END_MIME

sub new {
	my ($class, $name, $r_imgs, $r_html) = @_;
	$name = "CleanRound" unless defined $name;
	my %html_c = %html;
	my %imgs_c = %imgs;
	if (defined($r_html)) {
		#only copy the html templates that get used
		foreach (@Netcomics::HTML::Theme::html_keys) {
			$html_c{$_} = $r_html->{$_} if defined $r_html->{$_};
		}
	}
	if (defined($r_imgs)) {
		foreach (keys(%$r_imgs)) { #copy all images
			$imgs_c{$_} = $r_imgs->{$_};
		}
	}
    return $class->SUPER::new($name, \%imgs_c, \%html_c);
}

1;