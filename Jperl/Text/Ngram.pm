#!/usr/bin/perl -w
#
package Jperl::Text::Ngram ;

use strict ;
use utf8 ;

# segment text to ngram
# by default utf8
sub text2ngram {
	my $text = shift ;
	my $n = shift ;

	# decode text
	utf8::decode($text) ;

	# seprate eng/chi
	my @bi_text = &to_bi_text($text) ;

	# create vocab
	my @vocab ;
	for(@bi_text){
		my @bingram = substr_bilang($_ , 1);
		# combine ngram
		@vocab = (@vocab , @bingram) ;
	}
	
	my @ngram ;
	
	# extract n gram
	for(my $i=0 ; $i<@vocab ; $i++){
		if( $i+$n-1 < @vocab ){
			
			# find n length word
			my $tmp ;
			for( my $k=$i ; $k<$n+$i ; $k++ ){
				$tmp .= $vocab[$k] ;

				if( ord($vocab[$k])<160 && ord($vocab[$k+1]) < 160){
					$tmp .= " " ;
				}
			}
			# push
			push(@ngram , $tmp) ;
		}
	}
	if(@vocab == 1){
		push(@ngram , $vocab[0]) ;
	}

	return @ngram ;
}

sub substr_bilang{
	my $text = shift ;
	my $n = shift ;

	my @bilang ;	
	
	# extract n gram  from chinese , english
	if( (&detect_language($text)) == 1  ){ # chinese
		# extract n gram
		for(my $i=0 ; $i<length($text) ; $i++){
			if( $i+$n-1 < length($text) ){
				# push
				push(@bilang , substr( $text , $i , $n )) ;
			}
		}
	} 
	elsif((&detect_language($text)) == 0 ) { # english
		my @text_splited = split(/\s/, $text);
	
		# extract n gram
		for(my $i=0 ; $i<@text_splited ; $i++){
			if( $i+$n-1 < @text_splited ){
				# find n length word
				my $tmp ;
				for( my $k=$i ; $k<$n+$i ; $k++ ){
					#$tmp .= $text_splited[$k] . " " ;
					$tmp .= $text_splited[$k] ;
				}
				# push
				push(@bilang , $tmp) ;
			}
		}
	}
	
	return @bilang ;
}

sub to_bi_text{
	my $text = shift ;
	my @bi_text ;

	my $flag_pre = -1 ;
	my $buffer = "" ;
	
	for(my $i=0 ; $i<length($text) ; $i++){

		my $char = substr($text , $i , 1) ;		

# set cur flag
		my $flag_cur = &detect_language( $char ) ;

		if( $flag_cur == $flag_pre ) { 
# push into buffer
			$buffer .= $char
		}else{
# clear buffer
			push(@bi_text , $buffer) ;	
# new buffer
			$buffer = $char ;
		}	

		$flag_pre = $flag_cur ;
	}
	push(@bi_text , $buffer) ;	

	return @bi_text ;
}

sub detect_language{
	my $str = shift ;

	if(ord($str) > 160){
		return 1 ; # is chinese
	}else{
		return 0 ; # is english
	}
}
1;
