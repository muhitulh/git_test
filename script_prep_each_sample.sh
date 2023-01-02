#!/bin/bash

cat SraRunTable.csv | sed 1d | awk -F "," '{print "$gatk FastqToSam FASTQ=$readpath/" $1 "_1.fastq" " " "FASTQ2=$readpath/" $1"_2.fastq" " " "OUTPUT=$outpath/" $31"_" $1 ".ubam READ_GROUP_NAME=" $31"_" $1 " " "SAMPLE_NAME=" $31 " " "LIBRARY_NAME=" $31"_" $1 " " "RUN_DATE=" $30}' > commands_all.txt 

rm slurm_job.*
split -1 -d -a3 commands_all.txt slurm_job.
rename 's/\.0+/./' slurm_job.*
mv slurm_job. slurm_job.0


###adding shabang and paths
sed -i -e '1i #!/bin/bash' slurm_job.* 

sed -i -e ' 2i gatk="java -Xmx4G -jar /software/projects/y95/bin/gatk-4.2.6.1/gatk-package-4.2.6.1-local.jar" ' slurm_job.* #gatk path

sed -i -e ' 3i readpath="/scratch/y95/mohitulh/20221107_global_Pnod_pangenome/2020_Richards_Friesen_US_Pnodorum_pangenome/00_input_fastq/" ' slurm_job.* #input data path

sed -i -e ' 4i outpath="/scratch/y95/mohitulh/20221107_global_Pnod_pangenome/2020_Richards_Friesen_US_Pnodorum_pangenome/01_ubam/" ' slurm_job.* #output path


##added this line to test git commit
##adding another line
##another line
