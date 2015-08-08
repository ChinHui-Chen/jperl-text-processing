package Jperl::Tool::GoogleDict ;

use strict ;
use utf8 ;
use JSON ;
use LWP::UserAgent;
use HTTP::Headers;
use Data::Dumper;
use Encode;
use Smart::Comments ;

sub gdict{
	my $query = shift ;
	my $top_one = shift ;
	my $q0 = $query ;

	# url encode
	$query =~ s/([^A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg;

	if(length $query > 50){
		return ; 
	}

	my $google_url = "http://64.233.183.102/complete/search?ds=d&hl=zh-TW&q=$query" ;
	#my $google_url = "http://www.google.com/dictionary/json?callback=dict_api.callbacks.id100&q=$query&sl=en&tl=zh-tw&restrict=pr,de&client=te";
	#$google_url

	my $agent_name='myagent';
	my $ua=LWP::UserAgent->new($agent_name);
	my $request=HTTP::Request->new( GET=>$google_url );
	my $response=$ua->request($request);
	my $content = $response->decoded_content ;

	# $content

	$content =~ /window\.google\.ac\.h\((.*)\)/s ;
	#$content =~ s/\\x//g;
	#$content =~ /dict_api\.callbacks\.id100\((.*),200,null\)/s ;

	my $json_scalar = from_json($1) ;
	my $pair = $json_scalar->[1][0][1] ;

	$pair = "" if( lc($json_scalar->[1][0][0]) ne lc($q0) ) ;
	
	# split
	my @trans = split /;/ , $pair ;


	#dirty work
	
	# remove ,~
	map $_=~s/, /\t/gs , @trans ;
	map $_=~s/,/\t/gs , @trans ;

	# remove =
	map $_=~s/=//gs , @trans ;
	map $_=~s/-//gs , @trans ;
	
	# remove ()
	map $_=~s/\(.*?\)//gs , @trans ;

	# remove 【】
	map $_=~s/【.*?】//gs , @trans ;

	# remove ...
	map $_=~s/\.\.\.//gs , @trans ;

	# output
	return @trans ;
}

1;
