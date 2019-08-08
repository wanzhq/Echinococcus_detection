Analysis the mapping ratio of repeat region targeting sequencing data for Echinococcus DNA detetion. Code to support manuscript.
Note: Bowtie2 (an alignment tool, available on https://sourceforge.net/projects/bowtie-bio/files/bowtie2/) should be installed, which will be called by the scripts.

List of scripts:
Echinococcus_cfDNA_Dection.pl:  the main function for the analysis the mapping ratio of repeat region targeting sequencing data for Echinococcus DNA detetion. 
Extract_unmapped_reads.pl: a subfunction called by the mainfunction for extracting the unmapped reads.
Statistic_samples_mappings.pl: a subfunction called by the mainfunction forcalculating mapping ratio of each steps.

Usage:
	perl Echinococcus_cfDNA_Dection.pl fastq_list
	Fastq_list is a filename, in which each line contains the paired sequencing files of a sample.
	The format of a Fastq_list file is as follows:
	sample1.R1.fastq	sample1.R2.fastq
	sample2.R1.fastq	sample2.R2.fastq
	sample3.R1.fastq	sample3.R2.fastq