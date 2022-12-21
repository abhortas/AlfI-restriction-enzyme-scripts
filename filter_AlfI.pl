#! usr/bin/perl

use strict;
use warnings;
use Getopt::Long;

my ($data,$out,$line,$diana,$k,$j,$aux,$dir,$m,$tot,$count,$sec,$name,$elem,$help,$porcent,$nombre,$ext,$w);
my @a;

################### Get options #############################
GetOptions(	"input|d=s"   => \$dir,
			"out|o=s"	  => \$out,
			"wo|w"		  => \$w,
			"help|h"      => \$help,) or die "Try 'perl filter_AlfI.pl --help' for more information.\n"; 	
##############################################################

###### Check the options ##########################
if($help){
	print "Use: perl filter_AlfI.pl [OPTION]...\n";
	print "Script to filter sequences with no AlfI in the correct position.\n";
	print "\n";
	print "Options:\n";
	print "\t-d,   --dir\t\tPath to the file sequences directory (absolute path).\n";
	print "\t-o,   --out\t\tPath for the output files directory (absolute path).\n";
	print "\t-w,   --wo\t\tSave wrong sequences.\n";
	print "\t-h,   --help\t\tShow this help and abort.\n";
	exit;
}


unless($dir){
	print "Error: --dir option is necessary.\n";
	exit;
}

unless(-d $dir){
	print "Error: The --dir directory doesn´t exists.\n";
	exit;
}

unless($out){
	print "Error: --out option is necessary.\n";
	exit;
}

unless(-d $out){
	print "Error: The --out directory doesn´t exists.\n";
	exit;
}

##########################################################################################

chdir $dir;
open(TEXT,">$out/summary.txt");
foreach $elem(<*>){
	print "Filtrando archivo $elem\n";
	
	@a=split(/\./,$elem);
	if($#a == 0){
		$nombre=$elem;
		$ext="";
	}
	else{
		$nombre=join(".",@a[0..$#a-1]);
		$ext=$a[$#a];
	}
	
	$count=0;
	$tot=0;
	$k=0;
	open(FILE,"$elem");
	open(TEXT1,">$out/$elem");
	if($w){
		open(TEXT2,">$out/$nombre\_wo.$ext");
	}
	while($line = <FILE>){
		if($k == 3){
			$k=4;
			chomp($line);
			if($m == 0){
				chomp($line);
				print TEXT1 "$name\n$sec\n+\n$line\n";
			}
			else{
				if($w){
					print TEXT2 "$name\n$sec\n+\n$line\n";
				}
			}
		}
		if($k == 2){
			$k++;
		}
		if($k == 1){
			$j=0;
			chomp($line);
			$sec=$line;
			@a=split(//,$line);
			$aux=join("",@a[12,13,14]);
			unless($aux eq "GCA"){
				$j=1;
			}
			$aux=join("",@a[21,22,23]);
			unless($aux eq "TGC"){
				$j=1;
			}
			if($j == 0){
				$m=0;
				$count++;
				$tot++;
			}
			else{
				$m=1;
				$tot++;
			}
			$k++;
		}
		if($k == 0){
			$k=1;
			chomp($line);
			$name=$line;
		}
		if($k == 4){
			$k=0;
		}
	}	
	$porcent=sprintf("%.2f",100*$count/$tot);
	print TEXT "$elem\t$count ($porcent)\n";
	close(TEXT1);
	if($w){
		close(TEXT2);
	}
}
	
