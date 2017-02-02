<%@page import="com.org.agritadka.transfer.Customer"%>
<%@page import="java.util.List"%>
<%@page import="com.org.agritadka.order.Order"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/pages/common/header.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<script>
$(".headerTable").hide();
</script>
<script type="text/javascript" src="<%=contextPath%>/resources/js/order.js"></script>
</head>
<body>
<center>
<table width="100%">
	<tr valign="top">
		<td><b>Cust. Name : </b></td>
		<td align="left"><input type="text" name="custName" id="custName"> </td>
		<td><b>Mobile : </b></td>
		<td align="left"><input type="text" name="mobile" id="mobile"> </td>
		<td><b>Address : </b></td>
		<td align="left"><textarea cols="40" rows="4" name="custAddress" id="custAddress"></textarea></td>
	</tr>
	<tr>
		<td align="center" colspan="6"><input type="button" value="Add" id="addNewCustomer"></td>
	</tr>
</table>
<%
	Order order = new Order();
	List<Customer> customerList = order.getCustomerData();
	String orderId = Utils.getString(request.getParameter("orderId"));
%>
<input type="hidden" id="orderId" value="<%=orderId%>">
<table width="100%" id="custTable" border="1">
	<thead>
		<tr class="headerTR">
			<td>Cust. Name</td>
			<td>Mobile</td>
			<td>Address</td>
			<td colspan=1>Attach</td>
			<td colspan=1>Update</td>
		</tr>
	</thead>
	<tbody>
		<%for(Customer customer : customerList){
			%><tr align="center">
				<td width="30%"><%=customer.getCustName() %></td>
				<td width="10%"><%=customer.getMobile() %></td>
				<td><%=customer.getCustAddress() %></td>
				<td width="10%"><img alt="Add Customer" class="updateExistingCustomer" src="<%=contextPath%>/resources/images/Add.png" width="25%"> </td>
				<td width="10%"><img alt="Edit Customer" class="editExistingCustomer" src="<%=contextPath%>/resources/images/edit.png" width="25%"> </td>
				
			</tr>
			<%
		}
		%>
	</tbody>

</table>

</center>

</body>
</html>