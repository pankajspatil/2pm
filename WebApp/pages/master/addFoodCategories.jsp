<%@page import="com.org.twopm.master.Master"%>
<%@page import="com.org.twopm.transfer.MainMenu"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="/pages/common/header.jsp"%>
<%@ include file="/pages/common/validateSession.jsp"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
</head>
<body>
<%

Master master = new Master();
Integer mainMenuId = Utils.getInt(request.getParameter("mainMenuId"));
String page1 = Utils.getString(request.getParameter("page1"));
String userId = session.getAttribute(Constants.USER_ID).toString();

MainMenu mainMenu = null;
String menuName = "", descritpion = "";
Boolean foodType, active;
String submitText = mainMenuId == 0 ? "ADD" : "UPDATE";

if(page1.equals("") && mainMenuId != 0){
	mainMenu = master.getMainMenu(mainMenuId);
	
	menuName = Utils.getString(mainMenu.getMainMenuName());
	descritpion = Utils.getString(mainMenu.getMenuDescription());
	foodType = mainMenu.isVeg();
	active = mainMenu.isActive();
	
	System.out.println("Active iN Update===>" + mainMenu.isActive());
	
}else{
	
	String message = "Record Added Successfully.";
	
	menuName = Utils.getString(request.getParameter("menuName"));
	descritpion = Utils.getString(request.getParameter("description"));
	foodType = Boolean.parseBoolean(Utils.getString(request.getParameter("foodType")));
	active = Boolean.parseBoolean(Utils.getString(request.getParameter("active")));
	
	System.out.println("Active==>" + Utils.getString(request.getParameter("active")));
	
	mainMenu = new MainMenu();
	mainMenu.setMainMenuName(menuName);
	mainMenu.setMenuDescription(descritpion);
	mainMenu.setVeg(foodType);
	mainMenu.setActive(active);
	mainMenu.setMainMenuId(mainMenuId);
	
	if(page1.equals("ADD")){
		master.insertMainMenu(mainMenu, userId);
	}else if(page1.equals("UPDATE")){
		master.updateMainMenu(mainMenu, userId);
		message = "Record Updated Successfully.";
	}
	if(!page1.equals("")){
		
	%>
	<script type="text/javascript">
	Lobibox.alert("success",{
		msg : '<%=message%>',
		beforeClose: function(lobibox){
        	parent.location.reload();
        }
	});
	</script>
	<%
	}
}

%>
<center>
<h1> New Menu Category</h1>
<form name="mainMenuForm" id="mainMenuform" method="post" action="">
	<table border="1" width="50%">
		<tr>
			<td class="headerTR">Menu Name</td>
			<td align="center"><input type="text" name="menuName" id="menuName" value="<%=menuName%>" style="width: 98%; height: 100%"> </td>
		</tr>
		<tr>
			<td class="headerTR">Description</td>
			<td><textarea rows="4" cols="" name="description" id="description" style="width: 98%;"><%=descritpion %></textarea> </td>
		</tr>
		<tr>
			<td class="headerTR">Food Type</td>
			<td>
			<%if(foodType){
				%>
				<input type="radio" name="foodType" id="foodTypeVeg" value="true" checked="checked"> Veg
				<input type="radio" name="foodType" id="foodTypeNonVeg" value="false"> Non Veg
				<%
			}else{
				%>
				<input type="radio" name="foodType" id="foodTypeVeg" value="true"> Veg
				<input type="radio" name="foodType" id="foodTypeNonVeg" value="false" checked="checked"> Non Veg
				<%
			}
			
			%>
			
				
			</td>
		</tr>
		<tr>
			<td class="headerTR">Active</td>
			<td>
			<%String activeSelected = "";
				
			if(active){
				activeSelected = "checked=checked";
			}
				
			%>
			<input type="checkbox" value="true" name="active" id="active" <%=activeSelected %>></td>
		</tr>
		<tr>
			<td colspan="2" align="center"><input type="submit" name="page1" value="<%=submitText %>" class="btn btn-main btn-2g" onclick="return validateMainMenuForm()"></td>
		</tr>
	</table>
	<input type="hidden" name="mainMenuId" id="mainMenuId" value="<%=mainMenuId%>">
</form>
</center>
<script type="text/javascript">
var oldMenuName = '<%=menuName.equals("") ? "" :  menuName%>';
</script>
<script src="<%=contextPath%>/resources/js/masters.js" type="text/javascript"></script>
</body>
</html>