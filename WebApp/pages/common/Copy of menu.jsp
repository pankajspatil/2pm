<%@page import="com.org.twopm.generic.Constants"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
</head>
<body>
<div id='cssmenu'>
<ul>
   <li><a href='<%=request.getContextPath()%>/pages/home/home.jsp'><span>Home</span></a></li>
   <li>
   		<a href='#'><span>Masters</span></a>
	 	<ul>
	 	<li class='first-child'><a href='<%=request.getContextPath()%>/pages/plans/addPlan.jsp'><span>User</span></a></li>
         <li class='has-sub'><a href='#'><span>Reports</span></a>
            <ul>
   			<li class='first-child'><a href='<%=request.getContextPath()%>/pages/reports/psdfReport.jsp'><span>PSDF Report</span></a></li>
            <li class='last-child'><a href='<%=request.getContextPath()%>/pages/reports/baseData.jsp'><span>BaseData</span></a></li>
            <!-- <li><a href='<%=request.getContextPath()%>/pages/reports/displayReports.jsp'><span>Resource Report</span></a></li> -->
                        
        </ul>
   		</li>
	</ul>
	</li>
	<li style="float: right;padding-right: 10px;">
		<a href='#'><span>Order</span></a>
		<ul>
			<li><a href='<%=request.getContextPath()%>/pages/login/changePassword.jsp'>Change Password</a></li>
			<%if(session.getAttribute(Constants.USER_ID) != null){
		%><li onclick="logout()">
			<a href='#'><span>Logout</span></a>
			</li><%}%>
		</ul>
	</li>
	</ul>
</div>
</body>
</html>