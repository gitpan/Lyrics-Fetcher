#
# lyricsnet - www.lyrics.net.ua implementation 
#
# Original Version (Ruby):
# Copyright (C) 2003 Zachary P. Landau <kapheine@hypa.net>
# Perl Conversion:
# Copyright (C) 2003 Sir Reflog <reflog@mail15.com>
# All rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#

package Lyrics::Fetcher::LyricsNet;
use LWP::Simple qw(&get $ua);

use strict;

our    $url = 'http://www.lyrics.net.ua';

sub fetch($$$){
    my($self,$artist, $title) = @_; 
    $ua->agent('Mozilla/5.0');
    my($song_url) = get_song_url($title,$artist);
    return unless $song_url;
    my($page) = get $song_url;
    return ($page =~ /<p class=text>(.*?)<\/p>/s)
}

sub get_artist_list_url{
    my($artist) = @_; 
    my($char) = split //,$artist;
    $char = lc $char;
    if ((ord($char) eq ord("0")) || (ord($char) >= ord("1") && ord($char) <= ord("9"))){
      $char = '0'
    }
    return "$url/$char";
}
  
sub get_artist_url{
	my($artist) = @_; 
	my($artist_url) = get_artist_list_url($artist);
	return if !$artist_url;
	my($page) = get  $artist_url;
	my(@res) = $page =~ /<a href=\/group\/(\d+?)>(.*?)<\/a>/sg;
	for(my $i=0;$i<$#res;$i+=2){
		my($aurl, $aname) =  ($res[$i], $res[$i+1]);
		return "$url/group/$aurl" if lc($artist) eq lc($aname);
	}
	if($artist =~ /^The /i){
		$artist =~ s/^The //i;
		$page = get  get_artist_list_url($artist);
		my(@res) = $page =~ /<a href=\/group\/(\d+?)>(.*?)<\/a>/sg;
		for(my $i=0;$i<$#res;$i+=2){
			my($aurl, $aname) =  ($res[$i], $res[$i+1]);
			return "$url/group/$aurl" if lc($artist) eq lc($aname);
		}
	}   
	print "get_artist_url: could not find $artist";
	return 

}

sub get_song_url{
    my($title,$artist) = @_; 
    my($artist_url) = get_artist_url($artist);
    return if !$artist_url;
    my($page) = get $artist_url;
    return if !$page;
    my(@res) = $page =~ /<a href=\/song\/(\d+)>(.*?)<\/a>/sg;
    for(my $i=0;$i<$#res;$i+=2){
     my($aurl, $aname) =  ($res[$i], $res[$i+1]);
     return "$url/song/$aurl" if lc($title) eq lc($aname);
    }
    print "get_song_url could not find $title"
}

1;