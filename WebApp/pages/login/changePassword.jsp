<%@page import="com.org.agritadka.login.Login"%>
<%@page import="com.org.agritadka.generic.Utils"%>
<%@page import="java.util.LinkedHashMap"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<%@ include file="/pages/common/header.jsp"%>
<script type="text/javascript" src="<%=contextPath%>/resources/js/login.js"></script>
</head>
<body>
<%
String page1 = request.getParameter("page1");
String redirectPage = Utils.getString(request.getParameter("rd"));
String userId = Utils.getString(request.getParameter(Constants.USER_ID));

Integer returnValue = 0;

if(page1 != null){
	
	String currentPassword = Utils.getString(request.getParameter("currentPassword"));
	String newPassword = Utils.getString(request.getParameter("newPassword"));
	userId = userId.equals("") ? Utils.getString(session.getAttribute(Constants.USER_ID)) : userId;

	LinkedHashMap<String, String> paramMap = new LinkedHashMap<String, String>();
	
	paramMap.put(Constants.USER_ID, userId);
	paramMap.put(Constants.PASSWORD, currentPassword);
	paramMap.put(Constants.CHANGED_PASSWORD, newPassword);
	
	Login login = new Login();
	returnValue = login.changePassword(paramMap);
	
	
	if(returnValue == 0){
		%><script>infoMessage('Current password is not valid.');</script><%
	}else if(returnValue == -1){
		%><script>somethingWentWrong();</script><%
	}else{
		%><script>
		Lobibox.alert("info",{
			msg : 'Password has been updated successfully!!',
			beforeClose: function(lobibox){
	        	callHomePage();
	        }
		});</script><%
	}
}
if(returnValue != 1){
	
%>
<form method="post" name="changePasswordForm" id="changePasswordForm">
<h1 align="center">Change Password</h1>
<table align="center">
<%if(redirectPage.equals("")){
	%><tr>
		<td><b>Enter Current Password : </b></td>
		<td>
			<input type="password" name="currentPassword" id="currentPassword" value="">
		</td>
	</tr><%
}%>
	
	<tr>
		<td><b>Enter New Password : </b></td>
		<td>
			<input type="password" name="newPassword" id="newPassword" value="">
		</td>
	</tr>
	<tr>
		<td><b>Re-Enter Current Password : </b></td>
		<td>
			<input type="password" name="reEnterPassword" id="reEnterPassword" value="">
		</td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td colspan="2" align="center">
			<input type="submit"
			value="Update" class="wrapper-dropdown"
			style="background-color: #2d97af; color: white;" name="page1" id="changePasswordbutton">
		</td>
	</tr>
</table>
<input type="hidden" name="<%=Constants.USER_ID%>" id="<%=Constants.USER_ID%>" value="<%=userId%>">
<input type="hidden" name="rd" id="rd" value="<%=redirectPage%>">
</form>
<script type="text/javascript" src="<%=contextPath%>/resources/js/changePassword.js"></script>
<%} %>
</body>
</html>