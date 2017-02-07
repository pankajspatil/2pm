<%@page import="com.org.twopm.transfer.ItemCategory"%>
<%@page import="com.org.twopm.master.Master"%>
<%@page import="java.util.List"%>
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

Master master = new Master();
Integer itemCategoryId = Utils.getInt(request.getParameter("itemCategoryId"));
String page1 = Utils.getString(request.getParameter("page1"));
String userId = session.getAttribute(Constants.USER_ID).toString();

ItemCategory itemCategory = null;
String itemCategoryName = "", descritpion = "";
Boolean active = false;
String submitText = itemCategoryId == 0 ? "ADD" : "UPDATE";

if(page1.equals("") && itemCategoryId != 0){
	
	List<ItemCategory> itemCategoryList = master.getAllItemCategories(false, itemCategoryId);
	
	if(itemCategoryList.size() > 0){
		
		itemCategory = itemCategoryList.get(0);
		
		itemCategoryName = Utils.getString(itemCategory.getItemCategoryName());
		descritpion = Utils.getString(itemCategory.getItemCategoryDescription());
		active = itemCategory.getIsActive();
	}
	
	//System.out.println("Active iN Update===>" + mainMenu.isActive());
	
}else{
	
	String message = "Record Added Successfully.";
	
	itemCategoryName = Utils.getString(request.getParameter("itemCategoryName"));
	descritpion = Utils.getString(request.getParameter("description"));
	active = Boolean.parseBoolean(Utils.getString(request.getParameter("active")));
	
	//System.out.println("Active==>" + Utils.getString(request.getParameter("active")));
	
	itemCategory = new ItemCategory();
	itemCategory.setItemCategoryName(itemCategoryName);
	itemCategory.setItemCategoryDescription(descritpion);
	itemCategory.setIsActive(active);
	itemCategory.setItemCategoryId(itemCategoryId);
	
	if(page1.equals("ADD")){
		master.insertItemCategory(itemCategory, userId);
	}else if(page1.equals("UPDATE")){
		master.updateItemCategory(itemCategory, userId);
		message = "Record Updated Successfully.";
	}
	if(!page1.equals("")){
		
	%>
	<script type="text/javascript">
	Lobibox.alert("success",{
		msg : '<%=message%>',
		beforeClose: function(lobibox){
        	parent.location.reload();
        }
	});
	</script>
	<%
	}
}

%>
<center>
<h1> New Item Category</h1>
<form name="itemCategoryForm" id="itemCategoryform" method="post" action="">
	<table border="1" width="50%" style="border: 0px solid;">
		<tr>
			<th class="headerTR">Category Name</th>
			<td align="center"><input type="text" name="itemCategoryName" id="itemCategoryName" value="<%=itemCategoryName%>" class="fullRowElement"> </td>
		</tr>
		<tr>
			<th class="headerTR">Description</th>
			<td><textarea rows="4" cols="" name="description" id="description" style="width: 98%;"><%=descritpion %></textarea> </td>
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
			<th colspan="2" align="center"><input type="submit" name="page1" value="<%=submitText %>" class="btn btn-main btn-2g" onclick="return validateItemCategoryForm()"></th>
		</tr>
	</table>
	<input type="hidden" name="itemCategoryId" id="itemCategoryId" value="<%=itemCategoryId%>">
</form>
</center>
<script type="text/javascript">
var oldItemCategoryName = '<%=itemCategoryName.equals("") ? "" :  itemCategoryName%>';
</script>
<script src="<%=contextPath%>/resources/js/masters.js" type="text/javascript"></script>
</body>
</html>