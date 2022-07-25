#
#	!/bin/bash
#

FILEARG=${1}
OUTPUTARG=${2}
WORKERS=${3}

hadoop jar ./gila-core-0.8-jar-with-dependencies.jar unipg.gila.GilaRunner -libjars gila-core-0.8-jar-with-dependencies.jar \
	unipg.gila.layout.FloodingMaster\$DrawingBoundariesExplorer\$DrawingBoundariesExplorerWithComponentsNo \
	 -mc unipg.gila.layout.FloodingMaster \
	 -vif unipg.gila.io.LayoutInputFormat \
	 -vip ${FILEARG} \
	 -vof unipg.gila.io.LayoutOutputFormat \
	 -op ${OUTPUTARG} \
	 -ca layout.accuracy=0.01 \
	 -ca layout.flooding.ttlMax=3 \
	 -ca giraph.SplitMasterWorker=false \
	  -w $WORKERS

