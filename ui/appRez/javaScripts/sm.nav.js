function createImageArray() {
	imgs = new Array();
	imgs[0] = "../../appRez/images/common/spacer.gif";
	imgs[1] = "../../appRez/images/navigation/icon_statusMonitor1.gif";
	imgs[2] = "../../appRez/images/navigation/icon_statusMonitor2.gif";
	imgs[3] = "../../appRez/images/navigation/icon_statusMonitor3.gif";
	imgs[4] = "../../appRez/images/navigation/icon_plusNavBar.gif";
}

function ImagePreloader(images, callBack) {
   // store the call-back
   this.callBack = callBack;
   // initialize internal state.
   this.nLoaded = 0;
   this.nProcessed = 0;
   this.aImages = new Array;
 
   // record the number of images.
   this.nImages = images.length;

   // for each image, call preload()
   for ( var i = 0; i < images.length; i++ ) {
	   this.preload(images[i]);
   }
}

ImagePreloader.prototype.preload = function(image) {
   // create new Image object and add to array
   var oImage = new Image;
   this.aImages.push(oImage);
   // set up event handlers for the Image object
   oImage.onload = ImagePreloader.prototype.OnLoad;

   // assign pointer back to this.
   oImage.oImagePreloader = this;
   oImage.bLoaded = false;

   // assign the .src property of the Image object
   oImage.src = image;
}

ImagePreloader.prototype.OnLoad = function()
{
   this.bLoaded = true;
   this.oImagePreloader.nLoaded++;
   this.oImagePreloader.OnComplete();
}

ImagePreloader.prototype.OnComplete = function()
{
   this.nProcessed++;
   if ( this.nProcessed == this.nImages )
   {
      this.callBack(this.aImages, this.nLoaded);
   }
}

function renderMenuTree(aImages, nImages) {
	if ( nImages != imgs.length ) {
		alert("Images did not load properly");
      return;
   }

	var treeNodeRoot = document.getElementById("navContainer");
	
	for(i=0; i < hostGroupArray.length; i++)  { // start HostGroupLoop
		var hostGroupDescHash = hostGroupArray[i];
		var hasHosts = hostGroupDescHash.hasHosts;
		var hgOwner = hostGroupDescHash.hostGroupOwner;
		var hostGroupID = hostGroupDescHash.hostGroupID;
		var hgTable = document.createElement("TABLE");
		var lastRow = hgTable.rows.length;
		var row = hgTable.insertRow(lastRow);
		var cell = row.insertCell(0);
		if (hasHosts == 0) {
			var image = document.createElement("IMG");
			image.setAttribute("src", aImages[0].src);
			image.setAttribute("border", "0");
			image.setAttribute("width", "9");
			image.setAttribute("height", "9");
			cell.appendChild(image);
		} else {
			var a = document.createElement("A");
			a.setAttribute("href", 'javascript:Toggle(\'' + hostGroupID + '\');');
			var image = document.createElement("IMG");
			image.setAttribute("src", aImages[4].src);
			image.setAttribute("id", 'x' + hostGroupID);
			image.setAttribute("border", "0");
			a.appendChild(image);
			cell.appendChild(a);
		}
		
		cell = row.insertCell(1);
		var image = aImages[1];
		cell.appendChild(image);
		
		cell = row.insertCell(2);
		
		if (hasHosts == 0) {
			tn = document.createTextNode(hostGroupID);
			cell.appendChild(tn);
		} else {
			var a = document.createElement("A");
			a.setAttribute("target", "content");
			a.setAttribute("href", '../clientStatus/level2/index.pl?hgOwner=' + hgOwner + '&hostGroupID=' + hostGroupID);
			a.setAttribute("onClick", 'Toggle(\'' + hostGroupID + '\');');
			tn = document.createTextNode(hostGroupID);
			a.appendChild(tn);
			cell.appendChild(a);
		}
		treeNodeRoot.appendChild(hgTable);
		
		if (hasHosts != 0) { // start hasHosts != 0
			var hostDiv = document.createElement("DIV");                    
			hostDiv.setAttribute("id", hostGroupID);
			hostDiv.style.display = "none";
			hostDiv.style.marginLeft = "1em";
			treeNodeRoot.appendChild(hostDiv);
			var hostGroupMemberHash = hostGroupDescHash.hostGroupMemberHash;
			//sort keys of object
			var properties = new Array(); 
  			for (var p in hostGroupMemberHash) { properties[properties.length] = p;} 
  			properties.sort(); 
  			for (var j = 0; j < properties.length; j++)  { // start hostGroupMember in hostGroupMemberHash
				var hostGroupMember = properties[j];
				var hostDescHash = hostGroupMemberHash[hostGroupMember];
				var hasServices = hostDescHash.hasServices;
				var hostTable = document.createElement("TABLE");
				var lastRow = hostTable.rows.length;
				var row = hostTable.insertRow(lastRow);
				
				var cell = row.insertCell(0);
				if (hasServices == 0) {
					var image = document.createElement("IMG");
					image.setAttribute("src", aImages[0].src);
					image.setAttribute("border", "0");
					image.setAttribute("width", "9");
					image.setAttribute("height", "9");
					cell.appendChild(image);
				} else {
					var a = document.createElement("A");
					a.setAttribute("href", 'javascript:Toggle(\'' + hostGroupID + '^' + hostGroupMember + '\');');
					var image = document.createElement("IMG");
					image.setAttribute("src", aImages[4].src);
					image.setAttribute("id", 'x' + hostGroupID + '^' + hostGroupMember);
					image.setAttribute("border", "0");
					a.appendChild(image);
					cell.appendChild(a);
				}
				
  				cell = row.insertCell(1);
				var image = document.createElement("IMG");
				image.setAttribute("src", aImages[2].src);
				image.setAttribute("border", "0");
				cell.appendChild(image);
				
				cell = row.insertCell(2);
				if (hasServices == 0) {
					tn = document.createTextNode(hostGroupMember);
					cell.appendChild(tn);
				} else {
					var a = document.createElement("A");
					a.setAttribute("target", "content");
					a.setAttribute("href", '../clientStatus/level3/index.pl?hostGroupID=' + hostGroupID + '&hostName=' + hostGroupMember);
					a.setAttribute("onClick", 'Toggle(\'' + hostGroupID + '^' + hostGroupMember + '\');');
					tn = document.createTextNode(hostGroupMember);
					a.appendChild(tn);
					cell.appendChild(a);
				}
				hostDiv.appendChild(hostTable);
				
				if (hasServices != 0) { // start hasServices != 0
					var serviceDiv = document.createElement("DIV"); 
					var serviceTable;
					var serviceID = hostGroupID + "^" + hostGroupMember;
					serviceDiv.setAttribute("id", serviceID);
					serviceDiv.style.display = "none";
					serviceDiv.style.marginLeft = "12px";
					var serviceHashRefined = hostDescHash.serviceHash;
					for (var serviceHashRefinedKey in serviceHashRefined) {
						var serviceDescHash = serviceHashRefined[serviceHashRefinedKey];
						if (serviceDescHash.hasSubService != 1) {
							serviceTable = document.createElement("TABLE");
							var lastRow = serviceTable.rows.length;
							var row = serviceTable.insertRow(lastRow);
							var cell = row.insertCell(0);
							var image = document.createElement("IMG");
							image.setAttribute("src", aImages[0].src);
							image.setAttribute("border", "0");
							image.setAttribute("width", "9");
							image.setAttribute("height", "9");
							cell.appendChild(image);
							
							var cell = row.insertCell(1);
							var image = document.createElement("IMG");
							image.setAttribute("src", aImages[3].src);
							image.setAttribute("border", "0");
							cell.appendChild(image);
							
							var cell = row.insertCell(2);
							var a = document.createElement("A");
							a.setAttribute("target", "content");
							a.setAttribute("href", '../clientStatus/level3/index.pl?hostGroupID=' + hostGroupID + '&hostName=' + hostGroupMember + '&serviceName=' + serviceHashRefinedKey);
							tn = document.createTextNode(serviceHashRefinedKey);
							a.appendChild(tn);
							cell.appendChild(a);
							
							hostDiv.appendChild(serviceDiv);
							serviceDiv.appendChild(serviceTable);
						} else {
							var subServiceHash = serviceDescHash.subServiceHash;
							var list = new Array(  ); 
							for (var key in subServiceHash) { list.push(key);}
							
							serviceTable = document.createElement("TABLE");
							var lastRow = serviceTable.rows.length;
							var row = serviceTable.insertRow(lastRow);
							
							var cell = row.insertCell(0);
							var a = document.createElement("A");
							a.setAttribute("href", 'javascript:Toggle(\'' + hostGroupID + '^' + hostGroupMember + '^' + serviceHashRefinedKey + '\');');
							var image = document.createElement("IMG");
							image.setAttribute("src", aImages[4].src);
							image.setAttribute("id", 'x' + hostGroupID + '^' + hostGroupMember + '^' + serviceHashRefinedKey);
							image.setAttribute("border", 0);
							a.appendChild(image);
							cell.appendChild(a);
							
							var cell = row.insertCell(1);
							var image = document.createElement("IMG");
							image.setAttribute("src", aImages[3].src);
							image.setAttribute("border", 0);
							cell.appendChild(image);
							
							var cell = row.insertCell(2);
							var a = document.createElement("A");
							a.setAttribute("target", "content");
							a.setAttribute("href", '../clientStatus/level3/index.pl?hostGroupID=' + hostGroupID + '&hostName=' + hostGroupMember + '&serviceName=' + serviceHashRefinedKey + '.' + list[0]);
							a.setAttribute("onClick", 'Toggle(\'' + hostGroupID + '^' + hostGroupMember + '^' + serviceHashRefinedKey + '\');');
							tn = document.createTextNode(serviceHashRefinedKey);
							a.appendChild(tn);
							cell.appendChild(a);
							
							hostDiv.appendChild(serviceDiv);
							serviceDiv.appendChild(serviceTable);

							var subServiceDiv = document.createElement("DIV");
							var subServiceID = hostGroupID + "^" + hostGroupMember + "^" + serviceHashRefinedKey;
							subServiceDiv.setAttribute("id", subServiceID);
							subServiceDiv.style.display = "none";
							subServiceDiv.style.marginLeft = "12px";
							for (var subServiceHashKey in subServiceHash) {
								subServiceTable = document.createElement("TABLE");
								var lastRow = subServiceTable.rows.length;
								var row = subServiceTable.insertRow(lastRow);
								
								var cell = row.insertCell(0);
								var image = document.createElement("IMG");
								image.setAttribute("src", aImages[0].src);
								image.setAttribute("border", "0");
								image.setAttribute("width", "9");
								image.setAttribute("height", "9");
								cell.appendChild(image);
							
								var cell = row.insertCell(1);
								var image = document.createElement("IMG");
								image.setAttribute("src", aImages[3].src);
								image.setAttribute("border", 0);
								cell.appendChild(image);
								
								var cell = row.insertCell(2);
								var a = document.createElement("A");
								a.setAttribute("target", "content");
								a.setAttribute("href", '../clientStatus/level3/index.pl?hostGroupID=' + hostGroupID + '&hostName=' + hostGroupMember + '&serviceName=' + serviceHashRefinedKey + '.' + subServiceHashKey);
								tn = document.createTextNode(subServiceHashKey);
								a.appendChild(tn);
								cell.appendChild(a);
																
								serviceDiv.appendChild(subServiceDiv);
								subServiceDiv.appendChild(subServiceTable);
								
							}
						} // end serviceDescHash.hasSubService != 1
					} // end serviceHashRefinedKey in serviceHashRefined
				} // end hasServices != 0
			} // end hostGroupMember in hostGroupMemberHash
		} // end hasHosts != 0
	} // end HostGroupLoop
} // end function
