#!/usr/bin/perl
# Program:
#       This module is used for Chinese Word WS.
#		Parsing text from sinica web service.
#		Url: http://ckipsvr.iis.sinica.edu.tw/
# History:
# 2010/1/24	dongogo	First release

package Jperl::Text::WS::SinicaWS ;
use LWP::UserAgent ;
use Text::Iconv ;
use LWP;
use JSON;
#use Smart::Comments ;
use strict ;
use warnings ;


sub SimpleWS{
		my $query = shift ;
		
		# UTF8->BIG5
		my $converter = Text::Iconv->new("UTF-8", "BIG5");
		my $query_big5 = $converter->convert($query);

		# POST to sinica ws 
		my $ua = new LWP::UserAgent;
		my $response = $ua->post('http://mt.iis.sinica.edu.tw/cgi-bin/text.cgi' ,
				{ query=>$query_big5 });

		# get tag url
		my ($page) = ($response->content) =~ /\/(\d*?)\.html/ ;
		my $tag_url = "http://mt.iis.sinica.edu.tw/uwextract/pool/$page.tag.txt" ;

		# download url
		my $tag_text = $ua->get( $tag_url ) ;

		# BIG5->UTF8
		$converter = Text::Iconv->new("BIG5", "UTF-8");
		my $tags = $converter->convert($tag_text->content);

		### $tags

		# extract locations
		my %loc ;
		my @result ;
		while( $tags =~ /　([^　]*?)\(.*?\)/s ){
			$tags = $' ;
			push @result , $1 ;
		}

		return @result ;
}

1;
