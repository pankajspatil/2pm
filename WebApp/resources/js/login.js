function callHomePage(){
	var paramsMap = new Map();
	var dataMap = new Map();

	//dataMap.put(MENU_REQUIRED,"false");
	paramsMap.put(URL, contextPath + '/pages/common/home.jsp');
	paramsMap.put(DATA, dataMap);
	
	openURL(paramsMap);
}

function openChangePassword(userId){
	var paramsMap = new Map();
	var dataMap = new Map();

	dataMap.put(MENU_REQUIRED,"false");
	dataMap.put(USER_ID, userId);
	dataMap.put("rd", "fp");
	paramsMap.put(URL, contextPath + '/pages/login/changePassword.jsp');
	paramsMap.put(DATA, dataMap);
	
	openURL(paramsMap);	
}
