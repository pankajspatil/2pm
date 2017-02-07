<%@page import="com.org.twopm.transfer.Vendor"%>
<%@page import="com.org.twopm.master.Master"%>
<%@page import="com.org.twopm.order.Expense"%>
<%@page import="com.org.twopm.transfer.ExpenseModel"%>
<%@page import="java.util.List"%>
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
Master master = new Master();
List<Vendor> vendorList = master.getAllVendors(false, 0);
%>

<h1 align="center">ADD VENDOR</h1>
<div style="float: right;padding-right: 11%; padding-bottom: 0.3%">
	<!-- <input type="button" name="newExpense" id="newExpense" value=""> -->
	<button class="btn btn-main btn-2g" name="newVendor" id="newVendor" onclick="openVendorFancyBox(0, 'newVendor', this);">New Vendor</button>
</div>
<table border="1" class="mainTable" width="100%" id="vendorTable">
<thead>
	<tr class="headerTR">
		<th width="30%">Name</th>
		<th width="10%">Contact</th>
		<th width="10%">Active</th>
		<th width="40%">Address</th>
		<th width="10%">Action</th>
	</tr>
</thead>
<tbody>
	<%for(Vendor vendor : vendorList){%>
		<tr>
			<td align="center"><%=vendor.getVendorName() %></td>
			<td><%=vendor.getContactNo() %></td>
			<td align="center"><%=vendor.getIsActive() %></td>
			<td><%=vendor.getVendorAddress() %></td>
			<td>
				<img style="margin-left: 40%" height="22%" src="<%=contextPath%>/resources/images/edit.png" 
				id="<%=vendor.getVendorId()%>" name="editVendor" onclick="updateVendorRecord(this)">
			</td>
		</tr>
	<%}%>
</tbody>
</table>
<script type="text/javascript" src="<%=contextPath%>/resources/js/masters.js"></script>
</body>
</html>