function drawGraphTable() {
	// Clear the current graphTable
	var graphTable = document.getElementById("graphTable");
	var tBody = graphTable.tBodies[0];
	var tBodyChildren = tBody.childNodes;
  	var tBodyChildrenLen = tBodyChildren.length;
  	for (var count = 0; count < tBodyChildrenLen; count++)
  	{
		tBody.removeChild(tBody.firstChild);
	}
	// Draw graphTable based on hostGraphHolderArray
	if (top.topFrame.hostGraphHolderArray.length == 0) {
		var graphTable = document.getElementById('graphTable');
		var newRow = document.createElement('TR');
		var newCell = document.createElement('TD');
		newCell.innerHTML =  '<b>No Graphs Currently Selected</b>';
		newCell.setAttribute("colSpan", 11);
		newCell.setAttribute("style", "text-align: center");
		newRow.appendChild(newCell);
		graphTable.tBodies[0].appendChild(newRow);
	} else {
		for (var count = 0; count < top.topFrame.hostGraphHolderArray.length; count++) {
			var graphArray = top.topFrame.hostGraphHolderArray[count];
			createGraphRow(count, graphArray);
		}
	}
}
function insertGraph(os, graphIndex, hostName, serviceName, graphName) {
	var graphAlreadyInTable = 0; 
	for (var count = 0; count < top.topFrame.hostGraphHolderArray.length; count++) {
		var graphArray = top.topFrame.hostGraphHolderArray[count];
		if (os == graphArray[0] && graphIndex == graphArray[1] && hostName == graphArray[2] && serviceName == graphArray[3] && graphName == graphArray[4]) {
			graphAlreadyInTable = 1;
			break;
		}
	}
	
	if (graphAlreadyInTable) {
		alert("Error: This graph is already selected");
	} else {
		var graphArray = new Array();
    graphArray[0] = os;
    graphArray[1] = graphIndex;
		graphArray[2] = hostName;
		graphArray[3] = serviceName;
		graphArray[4] = graphName;
		graphArray[5] = 1;
		graphArray[6] = 0;
		graphArray[7] = 0;
		graphArray[8] = 0;
    graphArray[9] = 1;
		graphArray[10] = 0;
		graphArray[11] = 0;
		top.topFrame.hostGraphHolderArray.push(graphArray);
		drawGraphTable();
	}
}
function insertService(os, graphIndex, hostName, serviceName, graphName) {
	var graphAlreadyInTable = 0; 
	
	for (var count = 0; count < top.topFrame.hostGraphHolderArray.length; count++) {
		var graphArray = top.topFrame.hostGraphHolderArray[count];
		if (os == graphArray[0] && graphIndex == graphArray[1] && hostName == graphArray[2] && serviceName == graphArray[3] && graphName == graphArray[4]) {
			graphAlreadyInTable = 1;
			break;
		}
	}
	
	if (!graphAlreadyInTable) {
		var graphArray = new Array();
    graphArray[0] = os;
    graphArray[1] = graphIndex;
		graphArray[2] = hostName;
		graphArray[3] = serviceName;
		graphArray[4] = graphName;
    graphArray[5] = 1;
		graphArray[6] = 0;
		graphArray[7] = 0;
		graphArray[8] = 0;
    graphArray[9] = 1;
		graphArray[10] = 0;
		graphArray[11] = 0;
		top.topFrame.hostGraphHolderArray.push(graphArray);
	}
	drawGraphTable();
}
function createGraphRow(count, graphArray) {
	var graphTable = document.getElementById('graphTable');
	//new row
	var newRow = document.createElement('TR');
	//navCell
	var navCell = document.createElement('TD');
	var cellContent = createAnchor(count);
	navCell.appendChild(cellContent);
	newRow.appendChild(navCell);
	//cell0
	var cell0 = document.createElement('TD');
	var cellContent = document.createTextNode(graphArray[2]);
	cell0.appendChild(cellContent);
	newRow.appendChild(cell0);
	//cell1
	var cell1 = document.createElement('TD');
	var cellContent = document.createTextNode(graphArray[3]);
	cell1.appendChild(cellContent);
	newRow.appendChild(cell1);
	//cell2
	var cell2 = document.createElement('TD');
	var cellContent = document.createTextNode(graphArray[4]);
	cell2.appendChild(cellContent);
	newRow.appendChild(cell2);
	//cell3
	var cell3 = document.createElement('TD');
	var cellContent = '<input type="checkbox"' + ((graphArray[5] == 1) ? 'checked' : '')  + ' onClick="toggleCheckBox(' + count + ', 5);">';
	cell3.innerHTML = cellContent;
	newRow.appendChild(cell3);
	//cell4
	var cell4 = document.createElement('TD');
	var cellContent = '<input type="checkbox"' + ((graphArray[6] == 1) ? 'checked' : '')  + ' onClick="toggleCheckBox(' + count + ', 6);">';
	cell4.innerHTML = cellContent;
	newRow.appendChild(cell4);
	//cell5
	var cell5 = document.createElement('TD');
	var cellContent = '<input type="checkbox"' + ((graphArray[7] == 1) ? 'checked' : '')  + ' onClick="toggleCheckBox(' + count + ', 7);">';
	cell5.innerHTML = cellContent;
	newRow.appendChild(cell5);
	//cell6
	var cell6 = document.createElement('TD');
	var cellContent = '<input type="checkbox"' + ((graphArray[8] == 1) ? 'checked' : '')  + ' onClick="toggleCheckBox(' + count + ', 8);">';
	cell6.innerHTML = cellContent;
	newRow.appendChild(cell6);
  //cell7
	var cell7 = document.createElement('TD');
	var cellContent = '<input type="checkbox"' + ((graphArray[9] == 1) ? 'checked' : '')  + ' onClick="toggleCheckBox(' + count + ', 9);">';
	cell7.innerHTML = cellContent;
	newRow.appendChild(cell7);
	//cell8
	var cell8 = document.createElement('TD');
	var cellContent = '<input type="checkbox"' + ((graphArray[10] == 1) ? 'checked' : '')  + ' onClick="toggleCheckBox(' + count + ', 10);">';
	cell8.innerHTML = cellContent;
	newRow.appendChild(cell8);
	//cell9
	var cell9 = document.createElement('TD');
	var cellContent = '<input type="checkbox"' + ((graphArray[11] == 1) ? 'checked' : '')  + ' onClick="toggleCheckBox(' + count + ', 11);">';
	cell9.innerHTML = cellContent;
	newRow.appendChild(cell9)
	graphTable.tBodies[0].appendChild(newRow);
}
function deleteGraphRow(rowID) {
	top.topFrame.hostGraphHolderArray.splice(rowID, 1);
	drawGraphTable();
}
function createAnchor(graphID) {
	var newAnchor = document.createElement('A');
	var textNode = document.createTextNode('del');
	newAnchor.appendChild(textNode);
	var href = "javascript: deleteGraphRow('" + graphID + "');";
	newAnchor.setAttribute('href' , href);
	return newAnchor;
}
function toggleCheckBox(graphID, checkboxID) {
	if (top.topFrame.hostGraphHolderArray[graphID][checkboxID] == 0) {
		top.topFrame.hostGraphHolderArray[graphID][checkboxID] = 1;
	} else {
		top.topFrame.hostGraphHolderArray[graphID][checkboxID] = 0;
	}
}
function selectAll() {
	var insertHrefArray = getElementbyClass("insertHREF");
	for (i=0; i < insertHrefArray.length; i++) {
		var ID = insertHrefArray[i].id;
		var idComponentsArray = ID.split("^");
		
		var graphAlreadyInTable = 0;
		for (var count = 0; count < top.topFrame.hostGraphHolderArray.length; count++) {
			if (	idComponentsArray[0] == top.topFrame.hostGraphHolderArray[count][0] &&
				  idComponentsArray[1] ==  top.topFrame.hostGraphHolderArray[count][1] &&
				  idComponentsArray[2] ==  top.topFrame.hostGraphHolderArray[count][2] &&
				  idComponentsArray[3] ==  top.topFrame.hostGraphHolderArray[count][3] &&
				  idComponentsArray[4] ==  top.topFrame.hostGraphHolderArray[count][3])
      {
				// graph is already in table
				top.topFrame.hostGraphHolderArray[count][5] = 1;
				top.topFrame.hostGraphHolderArray[count][6] = 1;
				top.topFrame.hostGraphHolderArray[count][7] = 1;
				top.topFrame.hostGraphHolderArray[count][8] = 1
        top.topFrame.hostGraphHolderArray[count][9] = 1
        top.topFrame.hostGraphHolderArray[count][10] = 1
        top.topFrame.hostGraphHolderArray[count][11] = 1;
				graphAlreadyInTable = 1;
				break;
			}
		}
		if (graphAlreadyInTable) {
			// dont do anything its been updated above
		} else {
			var graphArray = new Array();
      graphArray[0] = idComponentsArray[0]
			graphArray[1] = idComponentsArray[1];
			graphArray[2] = idComponentsArray[2];
			graphArray[3] = idComponentsArray[3];
      graphArray[4] = idComponentsArray[4];
			graphArray[5] = 1;
			graphArray[6] = 1;
			graphArray[7] = 1;
			graphArray[8] = 1;
      graphArray[9] = 1;
			graphArray[10] = 1;
			graphArray[11] = 1;
			top.topFrame.hostGraphHolderArray.push(graphArray);
		}
	}
	drawGraphTable();
}
function removeAll() {
	var arrayLength = top.topFrame.hostGraphHolderArray.length;
	top.topFrame.hostGraphHolderArray.splice(0, arrayLength);
	drawGraphTable();
}
function selectColumn(interval) {
	var intervalIndex = -1;
	if (interval == 'day')
		intervalIndex = 5;
	else if (interval == 'week')
		intervalIndex = 6;
	else if (interval == 'month')
		intervalIndex = 7;
	else if (interval == 'year')
		intervalIndex = 8;
  else if (interval == 'line')
		intervalIndex = 9;
  else if (interval == 'bar')
		intervalIndex = 10;
  else if (interval == 'pie')
		intervalIndex = 11;
	for (var count = 0; count < top.topFrame.hostGraphHolderArray.length; count++) {
		top.topFrame.hostGraphHolderArray[count][intervalIndex] = 1;
	}
	drawGraphTable();
}
function deSelectColumn(interval) {
	var intervalIndex = -1;
	if (interval == 'day')
		intervalIndex = 5;
	else if (interval == 'week')
		intervalIndex = 6;
	else if (interval == 'month')
		intervalIndex = 7;
	else if (interval == 'year')
		intervalIndex = 8;
  else if (interval == 'line')
		intervalIndex = 9;
  else if (interval == 'bar')
		intervalIndex = 10;
  else if (interval == 'pie')
		intervalIndex = 11;
	for (var count = 0; count < top.topFrame.hostGraphHolderArray.length; count++) {
		top.topFrame.hostGraphHolderArray[count][intervalIndex] = 0;
	}
	drawGraphTable();
}
function getElementbyClass(className) {
	var selectedClassArray = new Array();
	var inc = 0;
	var allPageTagsArray = document.getElementsByTagName("*");
	for (i = 0; i < allPageTagsArray.length; i++) {
		if (allPageTagsArray[i].className == className) {
			selectedClassArray[inc++] = allPageTagsArray[i];
		}
	}
	return  selectedClassArray;
}
