<%@page import="com.org.agritadka.transfer.Waiter"%>
<%@page import="com.org.agritadka.transfer.OrderMenu"%>
<%@page import="com.org.agritadka.transfer.OrderData"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.org.agritadka.transfer.MenuMapper"%>
<%@page import="java.util.List"%>
<%@page import="com.org.agritadka.transfer.MainMenu"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="com.org.agritadka.order.Order"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="/pages/common/header.jsp"%>
    <%@ include file="/pages/common/validateSession.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link href="/AgriTadka/resources/css/order.css" rel="stylesheet" type="text/css">
<!-- <link href="/AgriTadka/resources/css/demo.css" rel="stylesheet" type="text/css"> -->
<style>
  .custom-combobox {
    position: relative;
    display: inline-block;
  }
  .custom-combobox-toggle {
    position: absolute;
    top: 0;
    bottom: 0;
    margin-left: -1px;
    padding: 0;
  }
  .custom-combobox-input {
    margin: 0;
    padding: 5px 10px;
  }
  </style>
</head>
<body>
<%
try{
//System.out.println("OrderId" + request.getParameter("orderId"));

Integer tableId = request.getParameter("tableId") == null ? null :  Integer.parseInt(request.getParameter("tableId"));
Integer orderId = request.getParameter("orderId") == null ? null :  Integer.parseInt(request.getParameter("orderId"));

String tableName = Utils.getString(request.getParameter("tableName"));
String priceType = Utils.getString(request.getParameter("priceType")).equals("") ? "non_ac" 
					: Utils.getString(request.getParameter("priceType"));
String userId = Utils.getString(session.getAttribute(Constants.USER_ID));

Float subTotal = new Float(0);
Order order = new Order();

OrderData orderData = order.getOrderData(tableId, userId, orderId);
String statusCode = orderData.getStatusCode() == null ? "INQUEUE" : orderData.getStatusCode();

LinkedHashMap<MainMenu, List<MenuMapper>> menuMap = order.getMenus(priceType);

List<Waiter> waiterList = order.getWaiterList();

//System.out.println("waiter Id ==> "+ orderData.getWaiterName());

%>


<table width="99.5%" border="0" align="center">
	<tr>
		<td align="left" colspan="2">
			<table width="100%" border="1">
				<tr align="center" class="orderInfoRow">
					<td width="35%" style="border-right: thick;">
						Order No : <span id="orderNumber"><%=orderData.getOrderId() == null ? "": orderData.getOrderId()%></span>
						<input type="hidden" id="orderId" value="<%=orderData.getOrderId() == null ? 0: orderData.getOrderId()%>">
					</td>
					<td width="32%">
						Table : <%=tableName %>
						<input type="hidden" id="tableId" value="<%=tableId == null ? 0 : tableId%>">
					</td>
					<td width="33%">
						Waiter : 
						<select id="waiterName" style="width: 20%">
							<option value="-1"></option>
							<%for(Waiter waiter : waiterList){
								
								if(waiter.getWaiterId().toString().equals(orderData.getWaiterName())){
									%><option selected="selected" value="<%=waiter.getWaiterId()%>"><%=waiter.getWaiterName() %></option> <%
								}else{
									%><option value="<%=waiter.getWaiterId()%>"><%=waiter.getWaiterName() %></option> <%
								}
							}%>
						</select>						
					</td>
				</tr>
			</table>
			
		</td>	
	</tr>
	<tr align="left">
		<td width="50%" align="left" valign="top">
			<div class="bwl_acc_container scroll accordionDiv" id="accordion_1" style="width: 98%; /* border:1px solid black; */">
    			<div class="accordion_search_container">
        				<input type="text" class="accordion_search_input_box search_icon" value="" placeholder="Search ..."/>
        		</div>

			<div class="search_result_container"></div>
		<%
			//out.println(menuMap.size());
			if(menuMap.size() > 0){
				List<MenuMapper> mappers = new ArrayList();
				for(MainMenu mainMenu : menuMap.keySet()){
					mappers = menuMap.get(mainMenu);
					
					
					%>
					<section>
					<h2 class="acc_title_bar">
						<a href="#"><%=mainMenu.getMainMenuName() %></a>
					</h2>
					<div class="acc_container">
						<div class="block" style="overflow: auto;">
						<%if(mappers.size() > 0){
							%><table width="100%" border="0">
							<%for(MenuMapper mapper : mappers){ %>
								<tr id="<%=mapper.getMainSubMenuId()%>" align="center">
									<td width="80%" align="left" style="">
									<%if(mapper.getSubMenu().isVeg()){
										%><img width="2%" height="1%" alt="Veg" src="/AgriTadka/resources/images/veg-icon.png"> <%
									}else{
										%><img width="2%" height="1%" alt="Non Veg" src="/AgriTadka/resources/images/nonveg-icon.png"><%
									}
									%>
									
										<%=mapper.getSubMenu().getSubMenuName() %></td>
										<td width="20%"><input type="text" title="Please enter text" id="note<%=mapper.getMainSubMenuId()%>"/></td>
										<% if (mapper.getSubMenu().getUnitPrice()!=0) {%>
									<td width="20%"><%=mapper.getSubMenu().getUnitPrice() %></td>
									<% } else {
										%><td width="20%"><input type="text" size="4" id="input<%=mapper.getMainSubMenuId()%>"> </td>
									<% }%>
									<td width="10%">
										<!-- <button type="button" class="btnPlus btn-success">
					                  		<span class="glyphicon glyphicon-plus"><b>+</b></span>
					              		</button> -->
										<input type="button" value="ADD" onclick="addMenuToOrder(this)">
									</td>
								</tr>
								<%} %>
							</table><%
						}%>
							
						</div>
					</div>
					</section>
					<%
						}
						}
					%>

			
		</div>
			
		</td>
		<td width="50%" style="position: relative;" id="rightCell">
		<div id="divTop" class="orderedDiv scroll">
			<table width="98%;" height="100%" border="0" align="center" id="orderedTable">
				<tr class="headerTR">
					<td>Menu</td>
					<td>Note</td>
					<td width="10%" style="border-right: thin;">Quantity</td>
					<td width="15%">Unit Price</td>
					<td width="15%">Total Price</td>
					<td width="5%">Del</td>
				</tr>
				<%if(orderData.getSelectedMenus() != null && orderData.getSelectedMenus().size() > 0){
					for(OrderMenu orderMenu : orderData.getSelectedMenus()){
					%>
					<tr align="center">
						<td align="left">
							<input type="hidden" id="<%=orderMenu.getOrderMenuMapId()%>">
							<%if(orderMenu.isVeg()){
										%><img width="2%" height="1%" alt="Veg" src="/AgriTadka/resources/images/veg-icon.png"> <%
									}else{
										%><img width="2%" height="1%" alt="Non Veg" src="/AgriTadka/resources/images/nonveg-icon.png"><%
									}
									%>
							<%=orderMenu.getSubMenuName() %></td>
						<td><%=orderMenu.getNotes() %></td>
						<td><select onChange='updatePrice(this)' onClick='setOldValue(this)'>
							<%for(int i=1; i<=30; i++){
								if(i == orderMenu.getQuantity()){
									%><option value="<%=i%>" selected="selected"><%=i%></option><%
								}else{
								%><option value="<%=i%>"><%=i%></option><%
								}
							}%></select>
						</td>
						<td><%=orderMenu.getUnitPrice() %></td>
						<td><%=orderMenu.getFinalPrice() %></td>
						<td><img class="deleteIcon" src="/AgriTadka/resources/images/Delete.png" onclick="deleteRecord(this)"></td>						
					</tr>
					<%
					subTotal += orderMenu.getFinalPrice();
					}
				}
				
				Float advanceAmt = orderData.getAdvanceAmt() == null ? 0 : orderData.getAdvanceAmt();
				Float discountAmt = orderData.getDiscountAmt() == null ? 0 : orderData.getDiscountAmt();
				
				Float finalAmt = subTotal - discountAmt;
				Float balanceAmt = finalAmt - advanceAmt;
				
				%>
				<tr>
					<td>
						<!-- <input type="text" style="background:rgba(0,0,0,0); border: none;" readonly="readonly"> -->
						
					</td>
				</tr>
			</table>
			</div>
			<div id="divBottom">
					<table width="100%">

						<%
							if (statusCode.equals("INQUEUE")) {
						%>
						<tr>
							<td colspan=6><b>Advc : <input type="text"
									name="advance" value="<%=advanceAmt%>" id="advance" size="5">
									&nbsp; <b>Discount : </b><input type="text" name="discount"
									value="<%=discountAmt%>" id="discount" size="5">&nbsp;
							</td>
						</tr>

						<%
							} else if (statusCode.equals("COMPLETED")) {
						%><tr>
							<td><button class="btn btn-main btn-2g" name="page4"
									id="printOrder">Print</button></td>
						</tr>
						<%
							}
						%>
						<tr>
							<td width="15%"><div style="font-size: 20px;">Sub
									total :</div></td>
							<td width="20%"><div id="priceTotal"
									style="font-size: 50px;"><%=String.format("%.2f", subTotal)%></div></td>

							<!-- </tr>
					<tr> -->
							<td width="15%"><div style="font-size: 20px;">Final
									total :</div></td>
							<td width="20%"><div id="priceFinal"
									style="font-size: 50px;"><%=String.format("%.2f", finalAmt)%></div></td>
							<!-- </tr>
					<tr> -->
							<td width="13%"><div style="font-size: 20px;">Balance
									:</div></td>
							<td width="20%"><div id="priceBalance"
									style="font-size: 50px;"><%=String.format("%.2f", balanceAmt)%></div></td>
						</tr>
						<tr>
							<br>
							<td width="100%" colspan="6">

								<button class="btn btn-main btn-2g" name="page1" id="saveOrder">Save</button>
								<button class="btn btn-main btn-2g" name="page2"
									id="cancelOrder">Cancel</button>
								<button class="btn btn-main btn-2g" name="page3"
									id="checkoutOrder">Checkout</button>
								<button class="btn btn-main btn-2g" name="page4"
									id="addCustomer">Customer</button>
							</td>
						</tr>


					</table>
				</div>	
		</td>
	</tr>
</table>

<script type="text/javascript" src="<%=contextPath%>/resources/js/order.js"></script>
<script>
    <%
    if(orderData.getWaiterName() != null){
  	  %>
  	  $("#waiterName").parent().find("input.ui-autocomplete-input").autocomplete("option", "disabled", true).prop("disabled",true);
  	  $("#waiterName").parent().find("a.ui-button").button("disable");
  	  <%
    }
    %>
</script>
<!-- <div style="border: 1px solid black; width: 50%; height: 200px;display: inline-block;">Div1</div>
<div style="border: 1px solid black;;margin-left: 52%; height: 200px;display: inline-block;">Div2</div> -->
<% }catch (Exception e) {
	e.printStackTrace();
}
%>
</body>
</html>