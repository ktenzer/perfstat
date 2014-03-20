function popWindow(sourcePath, windowTarget, windowParams)
{
	newWindow = window.open(sourcePath, windowTarget, 'width=800, height=400, status, resizable, scrollbars');
	setTimeout('newWindow.focus();',250);
}

function warnOnClickAnchor( message ) {
	return window.confirm(message);
}

function toggle(item1, item2) {
	//toggle item1
	obj = document.getElementById(item1);
	visible = (obj.style.display != "none");
	key = "x" + item1;
	if (visible) {
		obj.style.display = "none";
		document.images[key].src =  "../../../perfStatResources/images/navigation/icon_minusNavBar.gif";
	} else {
		obj.style.display = "block";
		document.images[key].src = "../../../perfStatResources/images/navigation/icon_plusNavBar.gif";		
	}

	//toggle item2
	obj = document.getElementById(item2);
	visible = (obj.style.display != "none");
	if (visible) {
		obj.style.display = "none";
	} else {
		obj.style.display = "block";
	}
}

function toggle2(item1, item2) {
	//toggle item1
	obj = document.getElementById(item1);
	visible = (obj.style.display != "none");
	if (visible) {
		obj.style.display = "none";
	} else {
		obj.style.display = "block";
	}

	//toggle item2
	obj = document.getElementById(item2);
	visible = (obj.style.display != "none");
	if (visible) {
		obj.style.display = "none";
	} else {
		obj.style.display = "block";
	}
  //close everything else
  divs = document.getElementsByTagName("DIV");
	offPattern = /-less$/;
	for (i=0; i < divs.length; i++) {
		var item = divs[i].id;
    if (item.length != 0) {
      if (divs[i].id != item1 &&  divs[i].id != item2) {
        if (offPattern.test(divs[i].id)){
          divs[i].style.display ="block";
        } else {
          divs[i].style.display ="none";
        }
      }
		}
	}
}

function openAll() {
	divs = document.getElementsByTagName("DIV");
	onPattern = /-on$/;
	for (i=0; i < divs.length; i++) {
		var item = divs[i].id;
    if (item.length != 0) {
		  if(onPattern.test(item)) {
        divs[i].style.display ="block";
	 		  key = "x" + item;
        document.images[key].src =  "../../../perfStatResources/images/navigation/icon_minusNavBar.gif";
      } else {
        divs[i].style.display ="none";
        key = "x" + item;
        document.images[key].src =  "../../../perfStatResources/images/navigation/icon_plusNavBar.gif";
      }
    }
	}
}

function closeAll() {
	divs = document.getElementsByTagName("DIV");
	offPattern = /-off$/;
	for (i=0; i < divs.length; i++) {
		var item = divs[i].id;
    if (item.length != 0) {
      if(offPattern.test(divs[i].id)){
        divs[i].style.display ="block";
        key = "x" + item;
        document.images[key].src =  "../../../perfStatResources/images/navigation/icon_plusNavBar.gif";
      } else {
        divs[i].style.display ="none";
        key = "x" + item;
        document.images[key].src =  "../../../perfStatResources/images/navigation/icon_plusNavBar.gif";
      }
		}
	}
}
