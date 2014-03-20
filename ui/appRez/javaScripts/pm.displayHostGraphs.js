function insertService(hostName, serviceName, graphName, interval) {
	var graphAlreadyInTable = 0; 
	
	for (var count = 0; count < top.topFrame.graphHolderArray.length; count++) {
		var graphArray = top.topFrame.graphHolderArray[count];
		if (hostName == graphArray[0] && serviceName == graphArray[1] && graphName == graphArray[2]) {
			graphAlreadyInTable = 1;
			var intervalIndex = -1;
			if (interval == 'hourly')
				intervalIndex = 3;
			else if (interval == 'daily')
				intervalIndex = 4;
			else if (interval == 'weekly')
				intervalIndex = 5;
			else if (interval == 'monthly')
				intervalIndex = 6;
			top.topFrame.graphHolderArray[count][intervalIndex] = 1;
			break;
		}
	}
	
	if (!graphAlreadyInTable) {
		var graphArray = new Array();
		graphArray[0] = hostName;
		graphArray[1] = serviceName;
		graphArray[2] = graphName;
		graphArray[3] = interval == 'hourly' ? 1 : 0;
		graphArray[4] = interval == 'daily' ? 1 : 0;
		graphArray[5] = interval == 'weekly' ? 1 : 0;
		graphArray[6] = interval == 'monthly' ? 1 : 0;
		top.topFrame.graphHolderArray.push(graphArray);
	}
	top.topFrame.displayGraphs();
}