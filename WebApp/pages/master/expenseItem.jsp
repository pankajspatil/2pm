<%@page import="com.org.twopm.transfer.ExpenseItem"%>
<%@page import="com.org.twopm.transfer.ItemCategory"%>
<%@page import="com.org.twopm.master.Master"%>
<%@page import="java.util.Date"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="com.google.gson.JsonParser"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="/pages/common/header.jsp"%>
<%@ include file="/pages/common/validateSession.jsp"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link href="<%=contextPath%>/resources/css/order.css" rel="stylesheet" type="text/css">
<style>
  #feedback { font-size: 1.4em; }
  .selectable .ui-selecting { background: #FECA40; }
  .selectable .ui-selected { background: #F39814; color: white; }
  .selectable, .subMenuList { list-style-type: none; margin: 0; padding: 0; width: 99%; }
  .selectable li { margin: 3px; padding: 0.4em; font-size: 1.4em; height: 18px; }
  .subMenuList h3 { margin: 3px; padding: 0.4em; font-size: 1.4em; height: 18px; }
 
  </style>
</head>
<body>
<h1 align="center">Expense Item Master</h1>
<%
	Master master = new Master();
	List<ItemCategory> itemCategoryList = master.getAllItemCategories(false, 0);
	List<ExpenseItem> expenseItemList = master.getAllExpenseItems(false, 0);
	
	String priceType = Utils.getString(request.getParameter("priceType")).equals("") ? "non_ac" 
			: Utils.getString(request.getParameter("priceType"));
%>

<div style="float: right; margin-right: 1%;">
	Add : 
	<button class="btn btn-main btn-2g" name="itemCategoryBtn" id="itemCategoryBtn" onclick="openItemFancyBox(0, 'itemCategory', this);">Category</button>
	<button class="btn btn-main btn-2g" name="expenseItemBtn" id="expenseItemBtn" onclick="openItemFancyBox(0, 'expenseItem', this);">Item</button>&nbsp;&nbsp;
</div><br/><br/><br/>
	<div id="item-container" class="tab-container">
		<ul class='etabs'>
			<li class='tab' id="itemCategoryTab"><a href="#itemCategoryMaster">Item Categories</a></li>
			<li class='tab' id="expenseItmeTab"><a href="#expenseItemMaster">Expense Items</a></li>
		</ul>
		<div id="itemCategoryMaster">
			<table id="itemCategoryTable" border="0" width="100%">
				<thead>
					<tr class="headerTR">
						<th width="20%">Category Name</th>
						<th width="40%">Description</th>
						<th width="10%">Active</th>
						<th width="10%">Action</th>
					</tr>
				</thead>
				<tbody>
					<%
						for(ItemCategory itemCategory : itemCategoryList){
							%><tr style="font-size: 15px;">
								<td><%=itemCategory.getItemCategoryName() %></td>
								<td><%=itemCategory.getItemCategoryDescription() %></td>
								<td align="center"><%=itemCategory.getIsActive() ? "True" : "False" %></td>
								<td>
									<img style="margin-left: 40%" height="22%" src="<%=contextPath%>/resources/images/edit.png" 
									id="itemCategory_<%=itemCategory.getItemCategoryId()%>" name="editItem" onclick="updateItem(this)">
								</td>		
							</tr><%
						}
					%>
					
				</tbody>	
			</table>
		</div>
		<div id="expenseItemMaster">
			<table id="expenseItemTable" border="0" width="100%">
				<thead>
					<tr class="headerTR">
						<!-- <td width="15%">Category</td> -->
						<td width="20%">Item Name</td>
						<td width="40%">Description</td>
						<td width="20%">Category</td>
						<td width="10%">Active</td>
						<td width="10%">Action</td>
					</tr>
				</thead>
				<tbody>
					<%
						for(ExpenseItem expenseItem : expenseItemList){
							%><tr style="font-size: 15px;">
								<td><%=expenseItem.getExpenseItemName() %></td>
								<td><%=expenseItem.getExpenseItemDescription() %></td>
								<td><%=expenseItem.getItemCategory().getItemCategoryName() %></td>
								<td align="center"><%=expenseItem.getIsActive() ? "True" : "False" %></td>
								<td>
									<img style="margin-left: 40%" height="22%" src="<%=contextPath%>/resources/images/edit.png" 
									id="expenseItem_<%=expenseItem.getExpenseItemId() %>" name="editItem" onclick="updateItem(this)">
								</td>		
							</tr><%
						}
					%>
					
				</tbody>	
			</table>
		</div>
	</div>
	
	
<script src="<%=contextPath%>/resources/js/masters.js" type="text/javascript"></script>
<script type="text/javascript" src="<%=contextPath%>/resources/js/order.js"></script>

</body>
</html>