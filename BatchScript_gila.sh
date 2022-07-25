#!/bin/bash
#SBATCH --nodes=5
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=80
#SBATCH --time=23:59:59
#SBATCH --account=rrg-primath
#SBATCH --job-name=GiLA
#SBATCH --output=jobOutput/GiLA_output_%j.txt
#SBATCH --mail-user=maxjingwei.zhang@ryerson.ca
#SBATCH --mail-type=begin #email when job starts
#SBATCH --mail-type=end #email when job ends
#SBATCH --mail-type=FAIL

cd $SLURM_SUBMIT_DIR
export SPARK_LOG_DIR=$SCRATCH
#import required modules
module load CCEnv
module load nixpkgs/16.09
module load spark/2.4.4
module load scipy-stack
module load python/3.6.3
module load maven


INPUT=$1
OUTPUT=$2
WORKERS=$3
TEMPLOCALFOLDER=gilaTemp/ ##PLEASE GIVE A HDFS LOCATION IN WHICH SAVE TEMP FILES

echo cleaning temp folders
hdfs dfs -rm ${TEMPLOCALFOLDER}/tmp_partitioned.json
hdfs dfs -rmr ${TEMPLOCALFOLDER}/partitioning 
hdfs dfs -rmr ${TEMPLOCALFOLDER}/drawing
hdfs dfs -rm ${OUTPUT}/drawing.json

echo Executing partitioning

sh partitioning.sh ${INPUT} ${TEMPLOCALFOLDER}/partitioning ${WORKERS}

echo Done. Processing result

for i in $(seq -f "%05g" 0 $((WORKERS-1)))
do
	hdfs dfs -cat ${TEMPLOCALFOLDER}/partitioning/part-m-$i | hdfs dfs -appendToFile - ${TEMPLOCALFOLDER}/tmp_partitioned.json
done

echo Drawing partitioned graph

sh drawing.sh ${TEMPLOCALFOLDER}/tmp_partitioned.json ${TEMPLOCALFOLDER}/drawing ${WORKERS}

for i in $(seq -f "%05g" 0 $((WORKERS-1)))
do
	hdfs dfs -cat ${TEMPLOCALFOLDER}/drawing/part-m-$i | hdfs dfs -appendToFile - ${OUTPUT}/drawing.json
done
