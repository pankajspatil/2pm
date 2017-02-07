<%@page import="com.org.twopm.transfer.ItemCategory"%>
<%@page import="com.org.twopm.transfer.ExpenseItem"%>
<%@page import="com.org.twopm.master.Master"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page import="java.util.List"%>
<%@ include file="/pages/common/header.jsp"%>
<%@ include file="/pages/common/validateSession.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
</head>
<body>
	<%

	Master master = new Master();
	Integer expenseItemId = Utils.getInt(request.getParameter("expenseItemId"));
	
	String page1 = Utils.getString(request.getParameter("page1"));
	String userId = session.getAttribute(Constants.USER_ID).toString();
	ExpenseItem expenseItem = null;
	String expenseItemName = "", descritpion = "";
	Boolean active = false;
	String submitText = expenseItemId == 0 ? "ADD" : "UPDATE";
	Integer itemCategoryId = 0;
	
	List<ItemCategory> categoryList = master.getAllItemCategories(true, 0);

	if(page1.equals("") && expenseItemId != 0){
		
		List<ExpenseItem> itemList = master.getAllExpenseItems(false, expenseItemId);
		
		if(itemList.size() > 0){
			expenseItem = itemList.get(0);

			expenseItemName = Utils.getString(expenseItem.getExpenseItemName());
			descritpion = Utils.getString(expenseItem.getExpenseItemDescription());
			active = expenseItem.getIsActive();
			itemCategoryId = expenseItem.getItemCategory().getItemCategoryId();
		}
		
		
		
	}else{
		String message = "Record Added Successfully.";
		
		expenseItemName = Utils.getString(request.getParameter("expenseItemName"));
		descritpion = Utils.getString(request.getParameter("description"));
		active = Boolean.parseBoolean(Utils.getString(request.getParameter("active")).toString());
		itemCategoryId = Utils.getInt(request.getParameter("itemCategoryId"));
		
		expenseItem = new ExpenseItem();
		ItemCategory itemCategory = new ItemCategory();
		
		itemCategory.setItemCategoryId(itemCategoryId);
		
		expenseItem.setItemCategory(itemCategory);
		expenseItem.setExpenseItemName(expenseItemName);
		expenseItem.setExpenseItemDescription(descritpion);
		expenseItem.setIsActive(active);
		expenseItem.setExpenseItemId(expenseItemId); 
		
		if(page1.equals("ADD")){
			master.insertExpenseItem(expenseItem, userId);			
		}else if(page1.equals("UPDATE")){
			master.updateExpenseItem(expenseItem, userId);
			message = "Record Updated Successfully.";
		}
		if(!page1.equals("")){
	%>
	<script type="text/javascript">
	Lobibox.alert("success",{
		msg : '<%=message %>',
			beforeClose : function(lobibox) {
				parent.location.reload();
			}
		});
	</script>
	<%
		}
		}
	%>
	<center>
<h1>New Expense Item</h1>
<form name="expenseItemForm" id="expenseItemform" method="post" action="">
	<table border="1" width="50%" style="border: 0px solid">
		<tr>
			<th class="headerTR">Item Name</th>
			<td align="center"><input class="fullRowElement" type="text" name="expenseItemName" id="expenseItemName" value="<%=expenseItemName%>"> </td>
		</tr>
		<tr>
			<th class="headerTR">Description</th>
			<td><textarea rows="4" cols="" name="description" id="description" style="width: 98%;"><%=descritpion %></textarea> </td>
		</tr>
		<tr>
			<th class="headerTR">Category</th>
			<td>
				<select name="itemCategoryId" id="itemCategoryId" class="fullRowElement">
					<option value="-1">Please Select</option>
					<%String selected = "";
					System.out.println("itemCategoryId==>" + itemCategoryId);
					for(ItemCategory itemCategory : categoryList){
						selected = "";
						if(itemCategory.getItemCategoryId().equals(itemCategoryId)){
							selected = "selected=selected";
						}
						
						%><option <%=selected %> value="<%=itemCategory.getItemCategoryId()%>"><%=itemCategory.getItemCategoryName() %></option><%
					}
					%>
				</select>
			</td>
		</tr>
		<tr>
			<th class="headerTR">Active</th>
			<td>
			<%String activeSelected = "";
				
			if(active){
				activeSelected = "checked=checked";
			}
				
			%>
			<input class="fullRowElement" style="width: 10%" type="checkbox" value="true" name="active" id="active" <%=activeSelected %>></td>
		</tr>
		<tr>
			<th colspan="2" align="center"><input type="submit" name="page1" value="<%=submitText %>" class="btn btn-main btn-2g" onclick="return validateExpenseItemForm()"></th>
		</tr>
	</table>
	<input type="hidden" name="expenseItemId" id="expenseItemId" value="<%=expenseItemId%>">
</form>
</center>
<script type="text/javascript">
var oldExpenseItemName = '<%=expenseItemName%>';
</script>
<script src="<%=contextPath%>/resources/js/masters.js" type="text/javascript"></script>
</body>
</html>