use strict;

my $alignment=shift;
my $PCR=shift;

my $statistic="Sample_Results_V3.txt";
my %sample_total=();
my %sample_mapped=();
my %sample_PCR_mapped=();

my %PCR_ref=();
if($PCR ne ""){
open(PIN,$PCR)or die $!;
while(my $line=<PIN>){
	chomp $line;
	if($line=~/^>(.*)$/){
		$PCR_ref{$1}=1;
	}
}
close(PIN);
}


open(IN, $alignment)or die $!;
open(OUTT,">>$statistic")or die $!;



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
			chomp $nextline;
			@ntemp=split /\s+/, $nextline;
		}
		
		my @temp1=split /:/,$temp[0];
	 
		if(!exists($sample_total{$temp1[-1]})){
			$sample_total{$temp1[-1]}=1;
		}else{
			$sample_total{$temp1[-1]}++;
		}
		

		#if((($temp[1] & 4) or ($temp[4]<10) )&& (($ntemp[1] & 4) or ($ntemp[4]<10) )){
		if((($temp[1] & 4)  ) &&  (($ntemp[1] & 4)  )){
		
		}else{
			if(!exists($sample_mapped{$temp1[-1]})){
				$sample_mapped{$temp1[-1]}=1;
			}else{
				$sample_mapped{$temp1[-1]}++;
			}
			if($PCR ne ""){
				my $ref="";
				if($temp[2] ne "*"){
					$ref=$temp[2];
				}else{
					$ref=$ntemp[2];
				}
				
				if(!exists($sample_PCR_mapped{$temp1[-1]}{$ref})){
					$sample_PCR_mapped{$temp1[-1]}{$ref}=1;
				}else{
					$sample_PCR_mapped{$temp1[-1]}{$ref}++;
				}
			}
			
		}
	}	
}


close(INS);
print OUTT "\n".$alignment."\n";
print OUTT "Sample\tTotal_Map_Rate\t(Mapped_reads\/Total_reads)";
my @PCR_ref_key=();
if($PCR ne ""){
	@PCR_ref_key=sort(keys(%PCR_ref));
	for my $PR(@PCR_ref_key){
		print OUTT "\t".$PR;
	}
}
print OUTT "\n";
my @sample=keys(%sample_total);
for my $SA(@sample){
	print OUTT $SA."\t";
	if(exists($sample_mapped{$SA})){
		print OUTT (($sample_mapped{$SA}/$sample_total{$SA})*100)."%\t($sample_mapped{$SA}\/$sample_total{$SA})";
	}else{
		print OUTT "0.0%\t(0\/$sample_total{$SA})";
	}
	if($PCR ne ""){
		for my $PR(@PCR_ref_key){
			if(exists($sample_PCR_mapped{$SA}{$PR})){
				print OUTT "\t".(($sample_PCR_mapped{$SA}{$PR}/$sample_total{$SA})*100)."%($sample_PCR_mapped{$SA}{$PR}\/$sample_total{$SA})";
			}else{
				print OUTT "\t"."0.0%"."(0\/$sample_total{$SA})";
			}
		}
		
	}
	print OUTT "\n";
}

close(OUTT);

