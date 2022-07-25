#!/bin/bash

INPUT=$1
OUTPUT=$2
PARTITIONS=$3
 
hadoop jar ./gila-core-0.8-jar-with-dependencies.jar  org.apache.giraph.GiraphRunner -libjars gila-core-0.8-jar-with-dependencies.jar \
	  unipg.gila.partitioning.ConnectedComponentsComputation \
	  -mc unipg.gila.partitioning.Spinner\$PartitionerMasterCompute \
	  -vif unipg.gila.io.PartitioningInputFormat \
	  -vip ${INPUT} \
	  -vof unipg.gila.io.PartitioningOutputFormat \
	  -op ${OUTPUT} \
	  -w ${PARTITIONS} \
	  -ca giraph.outEdgesClass=unipg.gila.partitioning.OpenHashMapEdges \
	  -ca spinner.numberOfPartitions=${PARTITIONS} \
	  -ca giraph.SplitMasterWorker=false \
  	  -ca spinner.doRandomizeCoordinates=true \
	  -ca spinner.bBox.X=1200 \
	  -ca spinner.additionalCapacity=0.1 \
	  -ca spinner.maxIterations=250

