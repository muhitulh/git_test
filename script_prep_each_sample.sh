#!/bin/bash

#create text file, includes "GATK FastqToSam" code for each isolate ID [retrive from metadata - SraRunTable.csv]  
cat SraRunTable.csv | sed 1d | awk -F "," '{print "$gatk FastqToSam FASTQ=$readpath/" $1 "_1.fastq" " " "FASTQ2=$readpath/" $1"_2.fastq" " " "OUTPUT=$outpath/" $31"_" $1 ".ubam READ_GROUP_NAME=" $31"_" $1 " " "SAMPLE_NAME=" $31 " " "LIBRARY_NAME=" $31"_" $1 " " "RUN_DATE=" $30}' > commands_all.txt 

#clean up previous attempts
rm slurm_job.*

#split up a list of isolate IDs into separate job script files, works for <1000 isolates, change to a4 if >1000
split -1 -d -a3 commands_all.txt slurm_job.

#remove leading zeroes (i.e. slurm_job.001) so that this will work with SLURM batch job numbering; need this we work with more than 100 isolates
rename 's/\.0+/./' slurm_job.*
mv slurm_job. slurm_job.0


###adding shabang and paths
sed -i -e '1i #!/bin/bash' slurm_job.* 

sed -i -e ' 2i gatk="java -Xmx4G -jar /software/projects/y95/bin/gatk-4.2.6.1/gatk-package-4.2.6.1-local.jar" ' slurm_job.* #gatk path

sed -i -e ' 3i readpath="/scratch/y95/mohitulh/20221107_global_Pnod_pangenome/2020_Richards_Friesen_US_Pnodorum_pangenome/00_input_fastq/" ' slurm_job.* #input data path

sed -i -e ' 4i outpath="/scratch/y95/mohitulh/20221107_global_Pnod_pangenome/2020_Richards_Friesen_US_Pnodorum_pangenome/01_ubam/" ' slurm_job.* #output path

