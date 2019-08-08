use strict;
if(@ARGV<2){
			print "Usage: perl Extract_unmapped_reads.pl [read1.fq][read2.fq][alignment]\n";
			die "too less or too much parameter!\n";
		}
	
my $fasta_1=shift;
my $fasta_2=shift;	
my $alignment=shift;
my $ref=shift;
#if($ref==""){$ref="unmapped"};

my @temp1=split /\//,$fasta_1;
my $new_unmapped_fq=$ref."_".$temp1[-1];
my @temp1=split /\//,$fasta_2;
my $new_unmapped_fq2=$ref."_".$temp1[-1];



open(IN, $alignment)or die $!;
open(INS,$fasta_1)or die $!;   #global definition
open(INS2,$fasta_2)or die $!;

open(OUTT,">$new_unmapped_fq")or die $!;
open(OUTT2,">$new_unmapped_fq2")or die $!;
my $total=0;
my $mapped=0;
my $unmapped=0;

while(my $line=<IN>){
	if($line=~/^@/){
	}else{
		chomp $line;
		#print $line;
		my @temp=split /\s+/, $line;
		my $nextline=<IN>;
		chomp $nextline;
		my @ntemp=split /\s+/, $nextline;
		
		while($temp[0] ne $ntemp[0]){
			print $temp[0]."\t".$ntemp[0]."\n";
			$line=$nextline;
			@temp=@ntemp;
			$nextline=<IN>;
			@ntemp=split /\s+/, $nextline;
		}
		
	 
		my $slenghth;
		my $start;
		my $end;
		
		$total++;

		#if((($temp[1] & 4) or ($temp[4]<10) )&& (($ntemp[1] & 4) or ($ntemp[4]<10) )){
		if((($temp[1] & 4)  )&& (($ntemp[1] & 4)  )){
			$unmapped++;
			my $flag=0;
			while(my $sline=<INS>){
				
					chomp $sline;
				
					if($sline=~/$temp[0]/){
						$flag=1;
						print OUTT  $sline."\n";
						$sline=<INS>;
						print OUTT $sline;
						$sline=<INS>;
						print OUTT $sline;
						$sline=<INS>;
						print OUTT $sline;
						last;
					
					}else{
						$sline=<INS>;
						$sline=<INS>;
						$sline=<INS>;
				
					}
				
				
			}
			if($flag==0){
				open(INS,$fasta_1)or die $!; 
				while(my $sline=<INS>){
				
					chomp $sline;
				
					if($sline=~/$temp[0]/){
						
						print OUTT  $sline."\n";
						$sline=<INS>;
						print OUTT $sline;
						$sline=<INS>;
						print OUTT $sline;
						$sline=<INS>;
						print OUTT $sline;
						last;
					
					}else{
						$sline=<INS>;
						$sline=<INS>;
						$sline=<INS>;
				
					}
				
				
				}
			}
			$flag=0;
			while(my $sline=<INS2>){

					chomp $sline;
				
					if($sline=~/$temp[0]/){					
						$flag=1;
					
						print OUTT2  $sline."\n";
						
						$sline=<INS2>;
						
						print OUTT2 $sline;
						$sline=<INS2>;
						print OUTT2 $sline;
						$sline=<INS2>;
						print OUTT2 $sline;
						
						last;
					
					}else{
						$sline=<INS2>;
						$sline=<INS2>;
						$sline=<INS2>;
				
					}
				
			}
			if($flag==0){
				open(INS2,$fasta_2)or die $!; 
				while(my $sline=<INS2>){

					chomp $sline;
				
					if($sline=~/$temp[0]/){					
						
						print OUTT2  $sline."\n";
						
						$sline=<INS2>;
						
						print OUTT2 $sline;
						$sline=<INS2>;
						print OUTT2 $sline;
						$sline=<INS2>;
						print OUTT2 $sline;
						
						last;
					
					}else{
						$sline=<INS2>;
						$sline=<INS2>;
						$sline=<INS2>;
				
					}
				
				}
			
			}
		}else{
			$mapped++;
			
		}
		
		
	}	
}


close(INS);
close(INS2);
close(IN);
close(OUTT);
close(OUTT2);	
my $statistic="Map_statistic";
open(ST,">>$statistic")or die $!;
print ST $fasta_1."\t".$fasta_2."\n";
print ST $total."\t".$mapped."(".($mapped/$total).")\t".$unmapped."\t(".($unmapped/$total).")\n";
close(ST);
