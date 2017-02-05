<%@page import="com.org.twopm.transfer.OrderMenu"%>
<%@page import="com.org.twopm.transfer.OrderData"%>
<%@page import="com.org.twopm.order.Order"%>
<%@page import="com.org.twopm.generic.Utils"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%
	String contextPath = (request == null || request.getContextPath() == null) ? ""
						: request.getContextPath();

	//System.out.println("contextPath" + contextPath);
%>
<script>
var contextPath = '<%=contextPath%>'; 
</script>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<%-- <link rel="stylesheet" type="text/css" href="<%=contextPath%>/resources/css/print.css" media="print"> --%>
<style type="text/css" media="print">
@page {
    size: auto;   /* auto is the initial value */
    margin: 0;  /* this affects the margin in the printer settings */
}
</style>

</head>
<body>
<%
Integer orderId = Utils.getInt(request.getParameter("orderId"));
//out.println("orderId" + orderId);

if(orderId != 0){
	Order order = new Order();
	OrderData orderData = order.getPrintOrderData(null, null, orderId);
%>

<table width="100%">
	<tr>
		<td align="center"><h1>2 PM</h1></td>
	</tr>
	<tr style="font-weight: bold;">
		<td>
			Sathi Shelter,Shop no 1, Ground floor, Near St. Peter College,<br> Diwanmaan, Dongari Road, Vasai(W)
			<div style="float: right;">Mobile : 9145698382</div>
		</td> 
	</tr>
	<tr><td><hr width="100%"></td></tr>
</table>
<table width="100%">
	<tr>
		<td width="60%"><b>Order No : </b><%=orderData.getOrderId()%></td>
		<td><b>Date : </b><%=orderData.getDateTime()%></td>
	</tr>
		<%
			if (orderData.getCustName() != null) {
		%><tr>
			<td width="60%"><b>Cust. Name : </b><%=orderData.getCustName()%></td>
			<td><b>Cust. Mobile : </b><%=orderData.getMobileNumber()%></td>
		</tr>
		<tr>
			<td colspan=2><b>Address : </b><%=orderData.getCustAddress()%>
			</td>
		</tr>
		<%
			}
		%>

	</table>
<%if(orderData.getSelectedMenus()!= null && orderData.getSelectedMenus().size() > 0){
	
	float subTotal = 0, finalTotal = 0;
	Float tax = orderData.getTaxRate() == null ? 0 : orderData.getTaxRate(); 	
%>

<table width="100%" border="0" style="border-collapse: collapse;" cellpadding="0" cellspacing="">
	<tr style="background-color: #D3D3D3; -webkit-print-color-adjust: exact;">
		<td width="55%"><b>Item</b></td>
		<td width="15%"><b>Qty.</b></td>
		<td width="15%"><b>Unit Price</b></td>
		<td width="15%"><b>Amount</b></td>
	</tr>
	<%for(OrderMenu orderMenu : orderData.getSelectedMenus()){
		subTotal += orderMenu.getFinalPrice();
		%><tr>
			<td><%=orderMenu.getSubMenuName() %>&nbsp<%=orderMenu.getNotes() %></td>
			<td><%=orderMenu.getQuantity()%></td>
			<td><%=orderMenu.getUnitPrice()%></td>
			<td><%=orderMenu.getFinalPrice() %></td>
		</tr><%
	}

	float advTotal = orderData.getAdvanceAmt();
	float discTotal = orderData.getDiscountAmt();
	
	float balTotal = subTotal- advTotal - discTotal ;
	
	finalTotal = (balTotal * tax) + balTotal;
	
	%>
	
	<!-- <tr>
		<td>Chicken Biryani Hydrabadi Kabab</td>
		<td>100</td>
		<td>9999.99</td>
		<td>9999.99</td>
	</tr> -->
	<tr>
		<td colspan="2" valign="top">
			<hr/>
		</td>
		<td width="30%" colspan="2" valign="top"><hr/>
			<table width="100%" style="background: #D3D3D3; -webkit-print-color-adjust: exact;">
<!-- 				<tr> -->
<%-- 					<td><b>Sub Total : </b><%=subTotal %></td> --%>
<!-- 				</tr> -->
<!-- 				<tr> -->
<%-- 					<td><b>Advance  : </b><%=advTotal %></td> --%>
<!-- 				</tr> -->
<!-- 				<tr> -->
<%-- 					<td><b>Discount  : </b><%=discTotal %></td> --%>
<!-- 				</tr> -->
<!-- 				<tr> -->
<%-- 					<td><b>Balance  : </b><%=balTotal %></td> --%>
<!-- 				</tr> -->
<!-- 				<tr> -->
<%-- 					<td><b>Tax Rate : </b><%=tax %></td> --%>
<!-- 				</tr> -->
<!-- 				<tr> -->
					<td><b>Final Total : </b><%=finalTotal %></td>
				</tr>
			</table>
		</td>
	</tr>
	<%}%>
<!-- 		<tr> -->
<!-- 			<td colspan="4" align="center"><h4>We do not use msg -->
<!-- 					(aginomotto).Veg and Non-Veg are prepared Separately.</h4></td> -->
<!-- 		</tr> -->
<!-- 		<tr> -->
<!-- 			<td colspan="4" align="center"><h4>Please guive us atleast -->
<!-- 					45 min to deliver order at home. It takes tima & efforts to make -->
<!-- 					good food so bare with us.</h4></td> -->
<!-- 		</tr> -->

		<tr>
			<td colspan="4" align="center"><h3>**** Visit Again ****</h3></td>
		</tr>
	</table>
<script type="text/javascript">
var w = window.print();
//debugger;
//this.close();

window.onbeforeprint = function() {
    alert('This will be called before the user prints.');
};
window.onafterprint = function() {
	alert('This will be called after the user prints');   
};
</script>
<% } %>
</body>
</html>