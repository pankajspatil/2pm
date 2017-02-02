<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.org.agritadka.transfer.OrderData"%>
<%@page import="java.util.List"%>
<%@page import="com.org.agritadka.order.Order"%>
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
Order order = new Order();

String fromDate = Utils.getString(request.getParameter("fromDate"));
String toDate = Utils.getString(request.getParameter("toDate"));
String reportType = Utils.getString(request.getParameter("reportType"));

String page1 = Utils.getString(request.getParameter("page1"));
if (fromDate.equals("") && page1.equals("")){
	 String pattern = "yyyy-MM-dd"; 
	 SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern); 
	 String date = simpleDateFormat.format(new Date());
	 fromDate = date;
	 toDate = date;
	}
List<OrderData> orderList = order.getAllOrders(fromDate, toDate);

%>
<center>
	<h1>Order Dashboard</h1>
	
	<form action="" method="post">
	<table align="center" border="0" width="30%">
		<tr align="center">
			<td>
				<b>From Date</b> &nbsp; <input size="12" type="text" name="fromDate" id="fromDate" value="<%=fromDate %>" 
				placeholder="From date" style="padding: 4px;" readonly="readonly">
			</td>
			
			<td>
				<b>To Date</b> &nbsp;<input size="12" type="text" name="toDate" id="toDate" value="<%=toDate %>" 
				placeholder="To Date" style="padding: 4px;" readonly="readonly">
			</td>
		</tr>
		
		<tr align="center">
			<td colspan="2">
				<input class="btn btn-main btn-2g" type="submit" name="page1" id="page1" value="Submit">
			</td>
		</tr>
	</table>
</form>
	
	<table width="100%" border="1" id="orderDashboard">
	<thead>
		<tr class="headerTR">
			<td>Order No</td>
			<td>Order Sequence</td>
			<td>Date/Time</td>
			<td>Table No</td>
			<td>Status</td>
			<td>Cust. Name</td>
			<td>Mobile</td>
			<td>Action</td>
		</tr>
	</thead>
	<tbody>
		<%for(OrderData orderData : orderList){
			%><tr align="center">
					<td><%=orderData.getOrderId()%></td>
					<td><%=orderData.getOrder_sequence()%></td>
					<td><%=Utils.getString(orderData.getDateTime())%></td>
					<%
						String tableName = Utils.getString(orderData.getTableName());

							if (tableName.equals("")) {
								tableName = "Parcel";
							}
					%>

					<td> <%=tableName %></td>
				<td><%=Utils.getString(orderData.getStatusName()) %></td>
				<td><%=Utils.getString(orderData.getCustName()) %></td>
				<td><%=Utils.getString(orderData.getMobileNumber()) %></td>
				<td align="left">
					<% if(orderData.getStatusCode().equals("INQUEUE")){
						%><img style="margin-left: 40%" height="36%" src="<%=contextPath%>/resources/images/edit.png" 
							onclick="openOrderPage(null,null,null,<%=orderData.getOrderId()%>)">&nbsp;
							<%if(Utils.getString(orderData.getTableName()).equals("")){
								%>
									<img height="31%" src="<%=contextPath%>/resources/images/print.png"
							onclick="printOrder(<%=orderData.getOrderId()%>)">
								<%
							}
					}else{
						%><img height="31%" style="margin-left: 60%" src="<%=contextPath%>/resources/images/print.png"
							onclick="printOrder(<%=orderData.getOrderId()%>)"><%
					}
					%></td>
			</tr><%
		}
		%>
		</tbody>
	</table>

</center>
<script src="<%=contextPath%>/resources/js/order.js" type="text/javascript"></script>
<script src="<%=contextPath%>/resources/js/reports.js" type="text/javascript"></script>
</body>
</html>