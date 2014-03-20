//maintain state for other frames
var hostGraphHolderArray = new Array();
var hgGraphHolderArray = new Array();
var contentLinkChosen = "";
//highlight the link currently in use
function setLinkChosen(linkID)
{
	anchors = document.getElementsByTagName("A");
	for(i=0; i<anchors.length; i++) {
		if(anchors[i].id != linkID) {	
			anchors[i].style.color = "";
		} else {
			anchors[i].style.color = "#D86E12"; //orange
		}
	}
}
function displayHostGraphs() {
	// strip out graphs that have no interval or type selected
	var errorMessage = "";
	if (hostGraphHolderArray.length == 0) {
		errorMessage = "Error: no graphs selected";
	}
	if (errorMessage.length == 0) {
		for (var count = 0; count < hostGraphHolderArray.length; count++) {
			var graphArray = hostGraphHolderArray[count];
			if (graphArray[5] == 0 && graphArray[6] == 0 && graphArray[7] == 0 && graphArray[8] == 0) {
				errorMessage = "Error: no interval selected for " + graphArray[0] + ": " + graphArray[2] + ": " + graphArray[4];
				break;
			}
      if (graphArray[9] == 0 && graphArray[10] == 0 && graphArray[11] == 0) {
				errorMessage = "Error: no graph type selected for " + graphArray[0] + ": " + graphArray[2] + ": " + graphArray[3];
				break;
			}
		}
	}
  if(top.bottomFrame.content.document.forms.outputHostGraphs.graphSize.selectedIndex == 0) {
    var customSize =  top.bottomFrame.content.document.forms.outputHostGraphs.customSize.value;
    if ( customSize < 50 || customSize > 300) {
      errorMessage = "Error: custom graph size must be between 50 and 300";
    }
  }
 
	if (errorMessage.length != 0) {
		alert(errorMessage);
	} else {
    top.bottomFrame.document.getElementById('perfmonFrameset').cols="0%,100%";
		top.bottomFrame.content.document.forms.outputHostGraphs.hostGraphHolderArray.value = serializeGraphHolderArray(hostGraphHolderArray);
		top.bottomFrame.content.document.forms.outputHostGraphs.submit();
	}
}
function displayHostGroupGraphs() {
	// strip out graphs that have no interval or type selected
	var errorMessage = "";
	if (hgGraphHolderArray.length == 0) {
		errorMessage = "Error: no graphs selected";
	}
	if (errorMessage.length == 0) {
		for (var count = 0; count < hgGraphHolderArray.length; count++) {
			var graphArray = hgGraphHolderArray[count];
			if (graphArray[3] == 0 && graphArray[4] == 0 && graphArray[5] == 0 && graphArray[6] == 0) {
				errorMessage = "Error: no interval selected for " + graphArray[0] + ": " + graphArray[1] + ": " + graphArray[2];
				break;
			}
      if (graphArray[7] == 0 && graphArray[8] == 0) {
				errorMessage = "Error: no graph type selected for " + graphArray[0] + ": " + graphArray[1] + ": " + graphArray[2];
				break;
			}
		}
	}
  if(top.bottomFrame.content.document.forms.outputHostGroupGraphs.graphSize.selectedIndex == 0) {
    var customSize =  top.bottomFrame.content.document.forms.outputHostGroupGraphs.customSize.value;
    if ( customSize < 50 || customSize > 300) {
      errorMessage = "Error: custom graph size must be between 50 and 300";
    }
  }
	if (errorMessage.length != 0) {
		alert(errorMessage);
	} else {
    top.bottomFrame.document.getElementById('perfmonFrameset').cols="0%,100%";
		top.bottomFrame.content.document.forms.outputHostGroupGraphs.hgGraphHolderArray.value = serializeGraphHolderArray(hgGraphHolderArray);
		top.bottomFrame.content.document.forms.outputHostGroupGraphs.submit();
	}
}
function serializeGraphHolderArray(graphHolderArray) {
	var serializedGraphHolderArray = "";
	for (var count1 = 0; count1 < graphHolderArray.length; count1++) {
		var graphArray = graphHolderArray[count1];
		var serializedGraphArray = "";
		for (var count2 = 0; count2 < graphArray.length; count2++) {
			var graphElement = graphArray[count2];
			serializedGraphArray = serializedGraphArray + graphElement + "^";
		}
		serializedGraphArray = serializedGraphArray + ";";
		serializedGraphHolderArray = serializedGraphHolderArray + serializedGraphArray;
	}
	return serializedGraphHolderArray;
}
