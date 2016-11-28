<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page import="com.org.agritadka.master.Master"%>
<%@page import="com.org.agritadka.transfer.SubMenu"%>
<%@page import="java.util.List"%>
<%@ include file="/pages/common/header.jsp"%>
<%@ include file="/pages/common/validateSession.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<%
		System.out.println("Food Dish Page");

	Master master = new Master();
	Integer subMenuId = Utils.getInt(request.getParameter("menuMapperId"));
	String page1 = Utils.getString(request.getParameter("page1"));
	String userId = session.getAttribute(Constants.USER_ID).toString();
	Float nonAcUnitPrice,acUnitPrice;
	SubMenu subMenu = null;
	String subName = "", descritpion = "";
	Boolean foodType, active;
	String submitText = subMenuId == 0 ? "ADD" : "UPDATE";

	if(page1.equals("") && subMenuId != 0){
		subMenu = master.getSubMenu(subMenuId);
		
		subName = Utils.getString(subMenu.getSubMenuName());
		descritpion = Utils.getString(subMenu.getMenuDescription());
		foodType = subMenu.isVeg();
		active = subMenu.isActive();
		acUnitPrice=subMenu.getAcUnitPrice();
		nonAcUnitPrice=subMenu.getNonAcUnitPrice();
		
	}else{
		String message = "Record Added Successfully.";
		
		subName = Utils.getString(request.getParameter("subName"));
		descritpion = Utils.getString(request.getParameter("description"));
		foodType = Boolean.parseBoolean(Utils.getString(request.getParameter("foodType")));
		active = Boolean.parseBoolean(Utils.getString(request.getParameter("active")));
		
		System.out.print("foodType " +Utils.getString(request.getParameter("foodType")));
		System.out.print("active " +request.getParameter("active"));
		
		acUnitPrice = Float.parseFloat(Utils.getString(request.getParameter("acUnitPrice")));
		nonAcUnitPrice = Float.parseFloat(Utils.getString(request.getParameter("nonAcUnitPrice")));
		
		subMenu = new SubMenu();
		subMenu.setSubMenuName(subName);
		subMenu.setMenuDescription(descritpion);
		subMenu.setVeg(foodType);
		subMenu.setAcUnitPrice(acUnitPrice);
		subMenu.setNonAcUnitPrice(nonAcUnitPrice);
		subMenu.setActive(active);
		subMenu.setSubMenuId(subMenuId); 
		
		if(page1.equals("ADD")){
			//master.insertSubMenu(subMenu, userId);
		}else if(page1.equals("UPDATE")){
			master.updateSubMenu(subMenu, userId);
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
<h1> New Dish</h1>
<form name="mainMenuForm" id="mainMenuform" method="post" action="">
	<table border="1" width="50%">
		<tr>
			<td class="headerTR">Dish Name</td>
			<td align="center"><input type="text" name="subName" id="subName" value="<%=subName%>" style="width: 98%; height: 100%"> </td>
		</tr>
		<tr>
			<td class="headerTR">Description</td>
			<td><textarea rows="4" cols="" name="description" id="description" style="width: 98%;"><%=descritpion %></textarea> </td>
		</tr>
		<tr>
			<td class="headerTR">Ac Unit Price</td>
			<td><input type="text" name="acUnitPrice" id="acUnitPrice" value="<%=acUnitPrice %>"/> </td>
		</tr>
		<tr>
			<td class="headerTR">Non Ac UnitPrice</td>
			<td><input type="text" name="nonAcUnitPrice" id="nonAcUnitPrice" value="<%=nonAcUnitPrice %>"/> </td>
		</tr>
		<tr>
			<td class="headerTR">Food Type</td>
			<td>
			<%if(foodType){
				%>
				<input type="radio" name="foodType" id="foodTypeVeg" value="1" checked="checked"> Veg
				<input type="radio" name="foodType" id="foodTypeNonVeg" value="0"> Non Veg
				<%
			}else{
				%>
				<input type="radio" name="foodType" id="foodTypeVeg" value="1"> Veg
				<input type="radio" name="foodType" id="foodTypeNonVeg" value="0" checked="checked"> Non Veg
				<%
			}
			
			%>
			
				
			</td>
		</tr>
		<tr>
			<td class="headerTR">Active</td>
			<td>
			<%String activeSelected = "";
			String activeValue="0";
				
			if(active){
				activeSelected = "checked=checked";
				activeValue ="1";
			}
				
			%>
			<input type="checkbox" value="<%=activeValue %>" name="active" id="active" <%=activeSelected %>></td>
		</tr>
		<tr>
			<td colspan="2" align="center"><input type="submit" name="page1" value="<%=submitText %>" class="btn btn-main btn-2g"></td>
		</tr>
	</table>
	<input type="hidden" name="mainMenuId" id="menuMapperId" value="<%=subMenuId%>">
</form>
</center>
</body>
</html>