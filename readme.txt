Analysis the mapping ratio of repeat region targeting sequencing data for Echinococcus DNA detetion. Code to support manuscript.

Main script: Echinococcus_cfDNA_Dection.pl
	Usage: perl Echinococcus_cfDNA_Dection.pl [fastq_list]
	Fastq_list is a file which each line contains the pair of read files (see fastq_list_example.txt).
Other software or scripts needed:
	Extract_unmapped_reads.pl: for extracting the unmapped reads.
	Statistic_samples_mappings.pl: for calculating mapping ratio of each steps.
	Bowtie2 (available on https://sourceforge.net/projects/bowtie-bio/files/bowtie2/): for building index and align the sequencing data to reference datasets.
