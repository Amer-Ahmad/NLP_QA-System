#Kyle Sutherland
#CMSC 416
#4/16/17

#This program runs in the format:
#     perl qa-system.pl mylogfile.txt
# where mylogfile.txt is an output log file

#This is a question answering system.  It uses wikipedia to search for topics
#and answer questions.  Questions should come in the format: 
#    "Who|What|When|Where _____________?"
#It then splits the question into pieces and polls wikipedia to return the 
#answer.  It captures the type of question to find out what to search the 
#wikipedia article for, comes up with an answer based on what the question type 
#and any extra information, then the answer is and then reformats the answer 
#into natural language.  The answer is then printed to STDOUT.  The question, 
#wiki text, and concluded answer are all recorded in the log file.




#usages
use WWW::Wikipedia;
use Data::Dumper;
use open ':std', ':encoding(UTF-8)';

#initialize wiki variable
my $wiki = WWW::Wikipedia->new();
my $result;

#open log file for writing
$file = @ARGV[0];
open(my $logf, '>', $file)
 or die "Could not open file '$file' $!";
 

#prompt user
print "This is a QA system by Kyle Sutherland. It will try to answer questions that start with Who, What, When or Where. Enter 'exit' to leave the program.\n";
#get initial question
$line = <STDIN>;


################################################################################

while ($line ne "exit"){
	#initialize variables
	my $term = $line;
	my $qtype = "default";
	my $extra = "default";
	my $ans;
	my $athe;
	my $tense;
	
	#grab search material and determine question type
	if($line=~m/(Who|What) (was|is|were|are) (the |an? )?(.*)\?/i){
		$qtype = "whowhat";
		$athe = $3;
		$term = $4;
		$tense = $2;
	}
	elsif($line=~m/(When) (was|is|were|are) (the |an? )?(.*)\?/i){
		$qtype = "when";
		$athe = $3;
		$term = $4;
		$tense = $2;
	}
	elsif($line=~m/(where) (was|is|were|are) (the |an? )?(.*)\?/i){
		$qtype = "where";
		$athe = $3;
		$term = $4;
		$tense = $2;
	}
	#capitalize article
	$athe = ucfirst($athe);
	########################################################################

	#grab extra terms like "born", "located"
	
	
	#born
	if (($term =~m/(.*) born/i)|($term =~m/(.*)'s birth/i)){
		$term = $1;
		$extra = "born";
	}


		
	########################################################################
	
	#search for term
	
	
	$result = $wiki->search($term);
	
	
	if($result){
		$text = $result->text();
		$phold = "$text\n";
		#trim newlines and carots
		$phold =~s/\n/ /g;
		$phold=~s/\<.*?\>//g;
		$text = $phold;
	}
	#fail if search doesn't return
	else {
		print "I'm sorry, I don't know.\n";
		$line = <STDIN>;
		chomp $line;
		next;
	}
	
	
	
	########################################################################	
	
	
	#pull answer based on type of question
	
	#who and what questions are the same
	if ($qtype eq "whowhat"){
		@arr=split/\. /,$text;
		for my $i (0..$#arr+1){
			#grab the first sentence with 'is' words
			if (@arr[$i]=~m/ ((was|were|is|are) [a-z].*)/i){
				$ans = $1;
				last;
			}
		}
		if ($ans){
			$printout =  "$athe$term $ans.\n";
		}
	}
	#answer where questions
	elsif ($qtype eq "where"){
		#remove bars from infobox
		$text=~s/\|//g;
		#get location from infobox if available
		if ($text=~m/location *= *(.*?) *[a-z]+(\_[a-z]+)* *=/i){
			
			$ans ="in $1";
		}
		#else look through the text
		else{
			@arr=split/\. |\.(svg|png|jpeg)/,$text;
			for my $i (0..$#arr+1){
				if (@arr[$i]=~m/ in ([a-z].*)/i){
					$ans = "in $1";
					last;
				}
			}
			for my $i (0..$#arr+1){
				if (@arr[$i]=~m/ located ([a-z].*)/i){
					$ans = $1;
					last;
				}
			}
			
			
		}
		#print if answer
		if ($ans){
			$printout = "$athe$term is located $ans.\n";
		}
	}
	#answer when questions
	elsif ($qtype eq "when"){
		#remove bars from infobox
		$text=~s/\|//g;
		#check infobox for date
		if ($text=~m/date = +(.*?) +[a-z]+(\_[a-z]+)* =/i){
			$ans = $1;
		}
		#answer born questions
		if ($extra eq "born"){
			@arr=split/\. /,$text;
			for my $i (0..$#arr+1){
				if (@arr[$i]=~m/}}.*\(.*?([a-z0-9 ,]+).*\)/i){
					$ans = $1;
					#fix tense based on information
					if ($ans =~m/[a-z]/i){
						$ans = "born on$ans";
					}else{
						$ans = "born in$ans";
					}
					$tense = "was";
					last;
				}
			}
		}
		#fix tense based on original question
		if ($ans){
			if ($tense eq ("are"|"is")){
				$printout = "$term is $ans.\n";
			}else{
				$printout = "$term was $ans.\n";
			}
		}
	}
	
	#if no answer was found
	if (!$ans){
		print "I'm sorry, I don't know.\n";
	}
	#if answer is gibberish
	elsif($printout=~m/[{}=]/i){
		print "I'm sorry, I don't know.\n";
	}
	#if answer was found
	else{
		print $printout;
	}
		
	
	########################################################################
	
	#print to log file
	
	print $logf "$line\n$text\n\n$printout\n*********************************************************\n\n"; 
	
	
	
	########################################################################
	#start over
	$line = <STDIN>;
	chomp $line;
}
