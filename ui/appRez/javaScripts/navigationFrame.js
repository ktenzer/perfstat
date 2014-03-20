function onBodyLoad(headerNavChosen)
{
	// Set Chosen Link for header
	top.topFrame.setLinkChosen(headerNavChosen);
	// Set content of Content frame
  if (headerNavChosen == "performance1") {
		parent.content.location = "../content/selectHGGraphs/index.pl";
  } else if (headerNavChosen == "performance2") {
		parent.content.location = "../content/selectHostGraphs/index.pl";
  } else if (headerNavChosen == "report") {
		parent.content.location = "../content/reportList/index.pl";
	} else if (headerNavChosen == "status") {
		parent.content.location = "../clientStatus/level1/index.pl";
  } else if (headerNavChosen == "asset") {
		parent.content.location = "../content/level1/index.pl";
	} else if (headerNavChosen == "appConfigs") {
		if (top.topFrame.contentLinkChosen == "userConfig") {
			parent.content.location = "../userConfig/level1/index.pl";
		} else if (top.topFrame.contentLinkChosen == "usersUpdate") {
			//User or Admin added or deleted
			setLinkChosen('users');
		} else if (top.topFrame.contentLinkChosen == "hostConfig") {
			parent.content.location = "../hostConfig/level1/index.pl";
		} else if (top.topFrame.contentLinkChosen == "hostGroups") {
			parent.content.location = "../hostGroups/level1/index.pl";
    } else if (headerNavChosen == "null") {
		} else {
			parent.content.location = "../userConfig/level1/index.pl";
		}
	}
}
// Set Chosen Link in AppConfigs
function setLinkChosen(linkID) {
	top.topFrame.contentLinkChosen = linkID;
	anchors = document.getElementsByTagName("A");
	for (i=0; i<anchors.length; i++) {
		if (anchors[i].id != linkID) {
			anchors[i].style.color = "";
		} else {
			anchors[i].style.color = "#D86E12"; //orange
		}
	}
}
//################################################Functions for navigation map
function Toggle(item)
{
   obj = document.getElementById(item);
   visible = (obj.style.display != "none");
   key = "x" + item;
   if (visible) {
      obj.style.display ="none";
      document.getElementById(key).src = "../../appRez/images/navigation/icon_plusNavBar.gif";
   } else {
      obj.style.display ="block";
	  document.getElementById(key).src = "../../appRez/images/navigation/icon_minusNavBar.gif";
   }
}
function openAll() {
	divs = document.getElementsByTagName("DIV");
	for (i=0; i < divs.length; i++) {
		var item = divs[i].id;
		if (item != "navContainer")
		{
			divs[i].style.display ="block";
			key = "x" + item;
			document.getElementById(key).src  =  "../../appRez/images/navigation/icon_minusNavBar.gif";
		}
	}
}
function closeAll() {
	divs = document.getElementsByTagName("DIV");
	for (i=0; i < divs.length; i++) {
		var item = divs[i].id;
		if (item != "navContainer") {
			divs[i].style.display ="none";
			key = "x" + item;
			document.getElementById(key).src  =  "../../appRez/images/navigation/icon_plusNavBar.gif";
		}
	}
}
