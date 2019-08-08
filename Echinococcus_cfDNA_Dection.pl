use strict;
#for trim-galore cleaned data
#Suppose all the reference index have been built
#my @command=("./bowtie2-build uscs.hg19.fasta hg19");
#`@command`;
#my @command=("./bowtie2-build PCR_panelMX.fa PCR");
#`@command`;
#my @command=("./bowtie2-build Eg_Em_repeats.fasta Eg_Em_repeat");
#`@command`;
#@command=("./bowtie2-build GCA_000469725.3_EMULTI002_genomic.fna EMULTI");
#`@command`;
#my @command=("./bowtie2-build GCA_000524195.1_ASM52419v1_genomic.fna ASM");
#`@command`;


my $fastqlist=shift; #format: each line contains the pair of reads file
open(IN,$fastqlist)or die $!;
while(my $line=<IN>){
	chomp $line;
	my @temp=split /\s+/,$line;
	my $fastq1=$temp[0];
	my $fastq2=$temp[1];
	$temp[0]=~/^(.*)(\.fq|\.fastq)/;
	my $sam=$1.".sam";
	my $hg19_sam="hg19_".$sam;
	my @command=("./bowtie2 -x hg19 -1 $fastq1 -2 $fastq2 -S $hg19_sam");#align to human genome
	`@command`;
	my @command=("perl Extract_unmapped_reads.pl $fastq1 $fastq2 $hg19_sam hg19");#Extract unmapped reads
	`@command`;
	my $hg19_fastq1="hg19_".$fastq1;
	my $hg19_fastq2="hg19_".$fastq2;
	my $PCR_sam="PCR_".$sam;
	@command=("./bowtie2 -x PCR -1 $hg19_fastq1 -2 $hg19_fastq2 -S $PCR_sam");#align to intended PCR template
	`@command`;
	my $Eg_Em_repeat_sam="Eg_Em_repeat_".$sam;
	@command=("./bowtie2 -x Eg_Em_repeat -1 $hg19_fastq1 -2 $hg19_fastq2 -S $Eg_Em_repeat_sam");#align to repeat sequences we identified
	`@command`;
	@command=("perl Extract_unmapped_reads.pl $hg19_fastq1 $hg19_fastq2 $Eg_Em_repeat_sam Eg_Em_repeat");#Extract unmapped reads
	`@command`;
	my $Eg_Em_repeat_unmapped_fastq1="Eg_Em_repeat_".$hg19_fastq1;
	my $Eg_Em_repeat_unmapped_fastq2="Eg_Em_repeat_".$hg19_fastq2;
	my $EMULTI_sam="EMULTI_".$sam;
	@command=("./bowtie2 -x EMULTI -1 $Eg_Em_repeat_unmapped_fastq1 -2 $Eg_Em_repeat_unmapped_fastq2 -S $EMULTI_sam");#align to E.multilocularis genome
	`@command`;
	my $ASM_sam="ASM_".$sam;
	@command=("./bowtie2 -x ASM -1 $Eg_Em_repeat_unmapped_fastq1 -2 $Eg_Em_repeat_unmapped_fastq2 -S $ASM_sam");#align to E.granulosus genome
	`@command`;
	@command=("perl Statistic_samples_mappings.pl $PCR_sam PCR_panelMX.fa");#calculate mapping ratio
	`@command`;
	@command=("perl Statistic_samples_mappings.pl $Eg_Em_repeat_sam");
	`@command`;
	@command=("perl Statistic_samples_mappings.pl $EMULTI_sam");
	`@command`;
	@command=("perl Statistic_samples_mappings.pl $ASM_sam");
	`@command`;

}
close(IN);
