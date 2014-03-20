//update select Lists
function updateNavigation(updateNavCode, adminName, userName) {
	if (updateNavCode == 1) {
		parent.navigation.setLinkChosen('userConfig');
	} else if (updateNavCode == 2) {
		//Update Select Lists
		top.topFrame.contentLinkChosen = 'usersUpdate';
		var myURL = "../../navigation/index.pl?adminName=" + adminName + "&userName=" + userName;
		parent.navigation.location = myURL;
	}
}