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
	Master masters = new Master();
	
	List<Vendor> vendorList = masters.getAllVendors(true,0);
	List<ExpenseItem> itemList = masters.getAllExpenseItems(true, 0);
	
		Integer userId = Integer.parseInt(session.getAttribute(Constants.USER_ID).toString());
		String page1 = Utils.getString(request.getParameter("page1"));
		Integer vendorId = Utils.getInt(request.getParameter("vendorId"));
		Integer itemId = Utils.getInt(request.getParameter("expenseItem"));
		Integer expQuantity = Utils.getInt(request.getParameter("expenseQty"));
		Double expAmount = Utils.getDouble(request.getParameter("expenseAmount"));
		Double expenseVat = Utils.getDouble(request.getParameter("expenseVat"));
		String expenseDesc = Utils.getString(request.getParameter("expenseDesc"));
		
		if(!page1.equals("")){
			
			
			ExpenseModel expenseModel = new ExpenseModel();
			
			Vendor vendor = new Vendor();
			vendor.setVendorId(vendorId);
			expenseModel.setVendor(vendor);

			ExpenseItem expenseItem = new ExpenseItem();
			expenseItem.setExpenseItemId(itemId);
			expenseModel.setExpenseItem(expenseItem);
			
			expenseModel.setExpenseQty(expQuantity);
			expenseModel.setExpenseAmt(expAmount);
			expenseModel.setExpenseVat(expenseVat);
			expenseModel.setExpenseRemark(expenseDesc);
			expenseModel.setCreatedBy(userId);
			
			Expense expense = new Expense();
			
			expense.addExpense(expenseModel);
			
			%>
			<script type="text/javascript">
			Lobibox.alert("success",{
				msg : 'Expense added successfully.',
				beforeClose: function(lobibox){
		        	parent.location.reload();
		        }
			});
			</script>
			<%
			
		}
	%>

<form method="post" action="#" style="text-align: center;">
<h1 align="center">New Expense</h1>

<table class="mainTable" align="center" width="50%" id="expenseDetails" border="1" style="border: 0px solid">
	<tr>
		<th class="headerTR">Vendor</th>
		<td>
			<select id="vendorId" name="vendorId" class="fullRowElement">
				<option value="-1">Please Select</option>
				<%
				for(Vendor vendor : vendorList){
					%><option value="<%=vendor.getVendorId()%>"><%=vendor.getVendorName() %></option><%
				}%>
			</select>
	</tr>
	<tr>
		<th class="headerTR">Item</th>
		<td>
			<select id="expenseItem" name="expenseItem" class="fullRowElement">
				<option value="-1">Please Select</option>
				<%
				for(ExpenseItem item : itemList){
					%><option value="<%=item.getExpenseItemId()%>"><%=item.getExpenseItemName() %></option><%
				}%>
			</select>
		</td>
	</tr>
	<tr>
		<th class="headerTR">Qty</th>
		<td><input type="text" id="expenseQty" name="expenseQty" class="fullRowElement" title="Numbers only" onkeyup="validateNumbersKeyPress(this)"></td>
	</tr>
	<tr>
		<th class="headerTR">Amount</th>
		<td><input type="text" id="expenseAmount" name="expenseAmount" class="fullRowElement"></td>
	</tr>
	<tr>
		<th class="headerTR">Vat</th>
		<td><input type="text" id="expenseVat" name="expenseVat" class="fullRowElement"></td>
	</tr>
	<tr>
		<th class="headerTR">Expense description</th>
		<td>
			<textarea rows="4" cols="" name="expenseDesc" id="expenseDesc" class="fullRowElement"></textarea>
		</td>
	</tr>
	<tr>
		<td colspan=2 align="center"><input class="btn btn-main btn-2g" type="Submit" id="page1" name="page1" value="Submit" onclick="return validateCreateExpense()"></td>
	</tr>
	
</table>
<div id="dialog-confirm"></div>
<script type="text/javascript" src="<%=contextPath%>/resources/js/expense.js"></script>
</form>
</body>
</html>