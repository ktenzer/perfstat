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
	// Draw graphTable based on hgGraphHolderArray
	if (top.topFrame.hgGraphHolderArray.length == 0) {
		var graphTable = document.getElementById('graphTable');
		var newRow = document.createElement('TR');
		var newCell = document.createElement('TD');
		newCell.innerHTML =  '<b>No Graphs Currently Selected</b>';
		newCell.setAttribute("colSpan", 10);
		newCell.setAttribute("style", "text-align: center");
		newRow.appendChild(newCell);
		graphTable.tBodies[0].appendChild(newRow);
	} else {
		for (var count = 0; count < top.topFrame.hgGraphHolderArray.length; count++) {
			var graphArray = top.topFrame.hgGraphHolderArray[count];
			createGraphRow(count, graphArray);
		}
	}
}
function insertGraph(hgName, serviceName, graphName) {
	var graphAlreadyInTable = 0; 
	for (var count = 0; count < top.topFrame.hgGraphHolderArray.length; count++) {
		var graphArray = top.topFrame.hgGraphHolderArray[count];
		if (hgName == graphArray[0] && serviceName == graphArray[1] && graphName == graphArray[2]) {
			graphAlreadyInTable = 1;
			break;
		}
	}
	
	if (graphAlreadyInTable) {
		alert("Error: This graph is already selected");
	} else {
		var graphArray = new Array();
		graphArray[0] = hgName;
		graphArray[1] = serviceName;
		graphArray[2] = graphName;
		graphArray[3] = 1;
		graphArray[4] = 0;
		graphArray[5] = 0;
		graphArray[6] = 0;
    graphArray[7] = 1;
		graphArray[8] = 0;
		top.topFrame.hgGraphHolderArray.push(graphArray);
		drawGraphTable();
	}
}
function insertService(hgName, serviceName, graphName) {
	var graphAlreadyInTable = 0; 
	
	for (var count = 0; count < top.topFrame.hgGraphHolderArray.length; count++) {
		var graphArray = top.topFrame.hgGraphHolderArray[count];
		if (hgName == graphArray[0] && serviceName == graphArray[1] && graphName == graphArray[2]) {
			graphAlreadyInTable = 1;
			break;
		}
	}
	
	if (!graphAlreadyInTable) {
		var graphArray = new Array();
		graphArray[0] = hgName;
		graphArray[1] = serviceName;
		graphArray[2] = graphName;
		graphArray[3] = 1;
		graphArray[4] = 0;
		graphArray[5] = 0;
		graphArray[6] = 0;
    graphArray[7] = 1;
    graphArray[8] = 0;
		top.topFrame.hgGraphHolderArray.push(graphArray);
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
	var cellContent = document.createTextNode(graphArray[0]);
	cell0.appendChild(cellContent);
	newRow.appendChild(cell0);
	//cell1
	var cell1 = document.createElement('TD');
	var cellContent = document.createTextNode(graphArray[1]);
	cell1.appendChild(cellContent);
	newRow.appendChild(cell1);
	//cell2
	var cell2 = document.createElement('TD');
	var cellContent = document.createTextNode(graphArray[2]);
	cell2.appendChild(cellContent);
	newRow.appendChild(cell2);
	//cell3
	var cell3 = document.createElement('TD');
	var cellContent = '<input type="checkbox"' + ((graphArray[3] == 1) ? 'checked' : '')  + ' onClick="toggleCheckBox(' + count + ', 3);">';
	cell3.innerHTML = cellContent;
	newRow.appendChild(cell3);
	//cell4
	var cell4 = document.createElement('TD');
	var cellContent = '<input type="checkbox"' + ((graphArray[4] == 1) ? 'checked' : '')  + ' onClick="toggleCheckBox(' + count + ', 4);">';
	cell4.innerHTML = cellContent;
	newRow.appendChild(cell4);
	//cell5
	var cell5 = document.createElement('TD');
	var cellContent = '<input type="checkbox"' + ((graphArray[5] == 1) ? 'checked' : '')  + ' onClick="toggleCheckBox(' + count + ', 5);">';
	cell5.innerHTML = cellContent;
	newRow.appendChild(cell5);
	//cell6
	var cell6 = document.createElement('TD');
	var cellContent = '<input type="checkbox"' + ((graphArray[6] == 1) ? 'checked' : '')  + ' onClick="toggleCheckBox(' + count + ', 6);">';
	cell6.innerHTML = cellContent;
	newRow.appendChild(cell6);
  //cell7
	var cell7 = document.createElement('TD');
	var cellContent = '<input type="checkbox"' + ((graphArray[7] == 1) ? 'checked' : '')  + ' onClick="toggleCheckBox(' + count + ', 7);">';
	cell7.innerHTML = cellContent;
	newRow.appendChild(cell7);
	//cell8
	var cell8 = document.createElement('TD');
	var cellContent = '<input type="checkbox"' + ((graphArray[8] == 1) ? 'checked' : '')  + ' onClick="toggleCheckBox(' + count + ', 8);">';
	cell8.innerHTML = cellContent;
	newRow.appendChild(cell8);
	graphTable.tBodies[0].appendChild(newRow);
}
function deleteGraphRow(rowID) {
	top.topFrame.hgGraphHolderArray.splice(rowID, 1);
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
	if (top.topFrame.hgGraphHolderArray[graphID][checkboxID] == 0) {
		top.topFrame.hgGraphHolderArray[graphID][checkboxID] = 1;
	} else {
		top.topFrame.hgGraphHolderArray[graphID][checkboxID] = 0;
	}
}
function selectAll() {
	var insertHrefArray = getElementbyClass("insertHREF");
	for (i=0; i < insertHrefArray.length; i++) {
		var ID = insertHrefArray[i].id;
		var idComponentsArray = ID.split("^");
		
		var graphAlreadyInTable = 0;
		for (var count = 0; count < top.topFrame.hgGraphHolderArray.length; count++) {
			if (	idComponentsArray[0] == top.topFrame.hgGraphHolderArray[count][0] &&
				  idComponentsArray[1] ==  top.topFrame.hgGraphHolderArray[count][1] &&
				  idComponentsArray[2] ==  top.topFrame.hgGraphHolderArray[count][2])
      {
				// graph is already in table
				top.topFrame.hgGraphHolderArray[count][3] = 1;
				top.topFrame.hgGraphHolderArray[count][4] = 1;
				top.topFrame.hgGraphHolderArray[count][5] = 1;
				top.topFrame.hgGraphHolderArray[count][6] = 1
        top.topFrame.hgGraphHolderArray[count][7] = 1
        top.topFrame.hgGraphHolderArray[count][8] = 1
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
			graphArray[3] = 1;
			graphArray[4] = 1;
			graphArray[5] = 1;
			graphArray[6] = 1;
      graphArray[7] = 1;
			graphArray[8] = 1;
			top.topFrame.hgGraphHolderArray.push(graphArray);
		}
	}
	drawGraphTable();
}
function removeAll() {
	var arrayLength = top.topFrame.hgGraphHolderArray.length;
	top.topFrame.hgGraphHolderArray.splice(0, arrayLength);
	drawGraphTable();
}
function selectColumn(interval) {
	var intervalIndex = -1;
	if (interval == 'day')
		intervalIndex = 3;
	else if (interval == 'week')
		intervalIndex = 4;
	else if (interval == 'month')
		intervalIndex = 5;
	else if (interval == 'year')
		intervalIndex = 6;
  else if (interval == 'bar')
		intervalIndex = 7;
  else if (interval == 'pie')
		intervalIndex = 8;
	for (var count = 0; count < top.topFrame.hgGraphHolderArray.length; count++) {
		top.topFrame.hgGraphHolderArray[count][intervalIndex] = 1;
	}
	drawGraphTable();
}
function deSelectColumn(interval) {
	var intervalIndex = -1;
	if (interval == 'day')
		intervalIndex = 3;
	else if (interval == 'week')
		intervalIndex = 4;
	else if (interval == 'month')
		intervalIndex = 5;
	else if (interval == 'year')
		intervalIndex = 6;
  else if (interval == 'bar')
		intervalIndex = 7;
  else if (interval == 'pie')
		intervalIndex = 8;
	for (var count = 0; count < top.topFrame.hgGraphHolderArray.length; count++) {
		top.topFrame.hgGraphHolderArray[count][intervalIndex] = 0;
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
