#
# !/bin/sh 
#

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
