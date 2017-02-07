<%@page import="com.org.twopm.transfer.Vendor"%>
<%@page import="com.org.twopm.master.Master"%>
<%@page import="com.org.twopm.transfer.MainMenu"%>
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

Integer vendorId = Utils.getInt(request.getParameter("vendorId"));
String page1 = Utils.getString(request.getParameter("page1"));
String userId = session.getAttribute(Constants.USER_ID).toString();

Vendor vendor = null;
String vendorName = "", contactNo = "", address = "";
Boolean active = false;
String submitText = vendorId == 0 ? "ADD" : "UPDATE";

if(page1.equals("") && vendorId != 0){
	
	List<Vendor> vendorList = master.getAllVendors(false, vendorId);
	
	if(vendorList.size() > 0){
		vendor = vendorList.get(0);
		
		vendorName = Utils.getString(vendor.getVendorName());
		contactNo = Utils.getString(vendor.getContactNo());
		address = Utils.getString(vendor.getVendorAddress());
		active = vendor.getIsActive();
	}
	
	//System.out.println("Active iN Update===>" + mainMenu.isActive());
	
}else{
	
	String message = "Record Added Successfully.";
	
	vendorName = Utils.getString(request.getParameter("vendorName"));
	address = Utils.getString(request.getParameter("address"));
	contactNo = Utils.getString(request.getParameter("contactNo"));
	active = Boolean.parseBoolean(Utils.getString(request.getParameter("active")));
	
	//System.out.println("Active==>" + Utils.getString(request.getParameter("active")));
	
	vendor = new Vendor();
	vendor.setVendorName(vendorName);
	vendor.setContactNo(contactNo);
	vendor.setVendorAddress(address);
	vendor.setIsActive(active);
	vendor.setVendorId(vendorId);
	
	if(page1.equals("ADD")){
		master.insertVendor(vendor, userId);		
	}else if(page1.equals("UPDATE")){
		master.updateVendor(vendor, userId);
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
<h1>New Vendor</h1>
<form name="vendorForm" id="vendorForm" method="post" action="">
	<table border="1" width="50%" style="border: 0px solid;">
		<tr>
			<th class="headerTR">Full Name</th>
			<td align="center"><input type="text" name="vendorName" id="vendorName" value="<%=vendorName%>" class="fullRowElement"> </td>
		</tr>
		<tr>
			<th class="headerTR">Contact No</th>
			<td align="center"><input type="text" name="contactNo" id="contactNo" value="<%=contactNo%>" class="fullRowElement"> </td>
		</tr>
		<tr>
			<th class="headerTR">Address</th>
			<td><textarea rows="4" cols="" name="address" id="address" style="width: 98%;"><%=address %></textarea> </td>
		</tr>
		<tr>
			<th class="headerTR">Active</th>
			<td>
			<%String activeSelected = "";
				
			if(active){
				activeSelected = "checked=checked";
			}
			
				
			%>
			<input type="checkbox" value="true" name="active" id="active" <%=activeSelected %>></td>
		</tr>
		<tr>
			<th colspan="2" align="center"><input type="submit" name="page1" value="<%=submitText %>" class="btn btn-main btn-2g" onclick="return validateVendorForm()"></th>
		</tr>
	</table>
	<input type="hidden" name="vendorId" id="vendorId" value="<%=vendorId%>">
</form>
</center>
<script type="text/javascript">
var oldVendorName = '<%=vendorName.equals("") ? "" :  vendorName%>';
</script>
<script src="<%=contextPath%>/resources/js/masters.js" type="text/javascript"></script>
</body>
</html>