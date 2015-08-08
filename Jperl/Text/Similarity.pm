use strict ;
use utf8 ;
use Jperl::Text::Ngram ;
package Jperl::Text::Similarity ;

# count dice of 2 string
sub dice_coeff{
	my $s1 = shift ;
	my $s2 = shift ;

	# extract ngram
	my @s1 = Jperl::Text::Ngram::text2ngram($s1 , 2) ;	
	my @s2 = Jperl::Text::Ngram::text2ngram($s2 , 2) ;	

	# count dice coeff
	my $up = intersection(\@s1 , \@s2) ;
	my $dn = (scalar @s1) + (scalar @s2) ;
	
	return $up/$dn ;
}

sub intersection{
	my @s1 = @{$_[0]} ;
	my @s2 = @{$_[1]} ;

	my %map ;
	foreach(@s1){
		$map{$_} = 1;
	}
	
	my $sum = 0 ;

	foreach(@s2){
		if( $map{$_} == 1 ){
			$sum++ ;
		}
	}
	return $sum ;
}

1;
