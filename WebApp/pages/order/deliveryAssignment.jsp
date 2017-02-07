<%@page import="com.org.twopm.transfer.DeliveryTracker"%>
<%@page import="com.org.twopm.order.Order"%>
<%@page import="com.org.twopm.transfer.User"%>
<%@page import="com.org.twopm.order.Expense"%>
<%@page import="com.org.twopm.transfer.ExpenseModel"%>
<%@page import="com.org.twopm.master.Master"%>
<%@page import="com.org.twopm.transfer.ExpenseItem"%>
<%@page import="com.org.twopm.transfer.Vendor"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.Iterator"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
 <%@ include file="/pages/common/validateSession.jsp"%>
 <%@ include file="/pages/common/header.jsp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
</head>
<body>
	<% 

Order order = new Order();
	
List<User> deliveryPersonList = order.getDeliveryPersonList(true);
String personName = "";

Integer deliveryTrackerId = Utils.getInt(request.getParameter("deliveryTrackerId"));
Integer orderId = Utils.getInt(request.getParameter("orderId"));
String callingType = Utils.getString(request.getParameter("callingType"));

List<DeliveryTracker> trackersList = order.getDeliveryTrackers(deliveryTrackerId);
DeliveryTracker deliveryTracker = new DeliveryTracker();
Integer deliveryPersonId =  0;
String statusCode = "";

if(trackersList.size() > 0){
	deliveryTracker = trackersList.get(0);
	
	deliveryPersonId = Utils.getInt(deliveryTracker.getDelieveryPerson().getId());
	statusCode = Utils.getString(deliveryTracker.getDeliveryStatus().getStatusCode());
}

%>
<a href="#" id="deliveryLink"></a>
<div id="delivery">
<table width="99%" align="center">
	<tr align="center">
		<th>
			<h3>Select Person</h3>
		</th>
	</tr>
	<tr>
		<td>
			<select id="deliveryPerson" name="deliveryPerson" class="fullRowElement"
				<%=statusCode.equals("DELIVERED") ? "disabled=disabled" : "" %>>
				<option value="-1">Please Select</option>
				<%
					String selected = "";
					for(User deliveryPerson : deliveryPersonList){
					
					selected = "";
						
					personName = deliveryPerson.getFirstName() + " ";
					personName += deliveryPerson.getMiddleName() + " ";
					personName += deliveryPerson.getLastName();
					
					personName = personName.trim();
					if(deliveryPersonId.equals(deliveryPerson.getId())){
						selected = "selected=selected";
					}
					%><option <%=selected %> value="<%=deliveryPerson.getId()%>"><%=personName %></option><%
				}%>
			</select>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr align="center">
		<td>
			<%if(statusCode.equals("DELIVERED")){
				%><h3 style="color: green"><%=statusCode %></h3><%
			}else{
			%><input class="btn btn-main btn-2g" type="button" value="Assign" name="deliveryAssign" 
			id="deliveryAssign" onclick="assignDelivery(<%=orderId %>, <%=deliveryTrackerId %>, '<%=callingType %>')"/>
			<%} %>
		</td>
	</tr>
</table>
</div>
<script type="text/javascript" src="<%=contextPath%>/resources/js/order.js"></script>
</body>
</html>