#!/usr/bin/perl

use WWW::Wikipedia;
use Data::Dumper;


my $term = shift;
my $wiki = WWW::Wikipedia->new();
my $result = $wiki->search($term);
$text;
if($result){
	$text = $result->text();
}
else {
	print $wiki->error();
}

open(my $wikitxt, '>', "wiki.txt")
 or die "Could not open file '$file2' $!";
 
 $fart = "$text\n";
$fart =~s/\n/ /g;
#$fart =~s/{{.*}}//g;
print $fart;
	

