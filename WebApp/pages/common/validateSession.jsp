<%@page import="com.org.twopm.generic.Constants"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
</head>
<body>
<%
	//System.out.println("userId===>" + session.getAttribute(Constants.USER_ID));
	if(session.getAttribute(Constants.USER_ID) == null){
		response.sendRedirect(request.getContextPath() + "/pages/login/login.jsp");
	}
%>
</body>
</html>