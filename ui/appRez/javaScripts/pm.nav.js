function insertGraph(hostName, serviceName, graphName, interval) {
	var graphAlreadyInTable = 0; 
	for (var count = 0; count < top.topFrame.graphHolderArray.length; count++) {
		graphArray = top.topFrame.graphHolderArray[count];
		if (hostName == graphArray[0] && serviceName == graphArray[1] && graphName == graphArray[2]) {
			graphAlreadyInTable = 1;
			if (interval == 'hourly') {
				top.topFrame.graphHolderArray[count][3] = 1;
			} else if (interval == 'daily') {
				top.topFrame.graphHolderArray[count][4] = 1;
			} else if (interval == 'weekly') {
				top.topFrame.graphHolderArray[count][5] = 1;
			} else if (interval == 'monthly') {
				top.topFrame.graphHolderArray[count][6] = 1;
			}
			break;
		}
	}
	
	if (graphAlreadyInTable == 0) {
		var graphArray = new Array();
		graphArray[0] = hostName;
		graphArray[1] = serviceName;
		graphArray[2] = graphName;
		if (interval == 'hourly') {
			graphArray[3] = 1;
			graphArray[4] = 0;
			graphArray[5] = 0;
			graphArray[6] = 0;
		} else if (interval == 'daily') {
			graphArray[3] = 0;
			graphArray[4] = 1;
			graphArray[5] = 0;
			graphArray[6] = 0;
		} else if (interval == 'weekly') {
			graphArray[3] = 0;
			graphArray[4] = 0;
			graphArray[5] = 1;
			graphArray[6] = 0;
		} else if (interval == 'monthly') {
			graphArray[3] = 0;
			graphArray[4] = 0;
			graphArray[5] = 0;
			graphArray[6] = 1; 
		}
		top.topFrame.graphHolderArray.push(graphArray);
	}
	parent.content.displayGraphs();
}