<%@page import="com.org.agritadka.transfer.Cooking"%>
<%@page import="java.util.List"%>
<%@page import="com.org.agritadka.generic.Constants"%>
<%@page import="com.org.agritadka.order.Order"%>
<%@page import="com.org.agritadka.generic.Utils"%>
<%@page import="com.google.gson.JsonParser"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="com.google.gson.Gson"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@page import="java.util.LinkedHashMap"%>

<%

try{
	
	response.setCharacterEncoding("UTF-8");
	
	String action = Utils.getString(request.getParameter("action"));
	String userId = Utils.getString(session.getAttribute(Constants.USER_ID));
	String data = Utils.getString(request.getParameter("data"));
	
	Order order = new Order();
	Integer returnValue = new Integer(0);
	
	if(action.equals("saveOrder")){
		String returnStr = order.saveOrder(data, userId);
		out.println(returnStr);
	}else if(action.equals("fetchCookingData")){
		List<Cooking> returnList = order.getOrderedMenus(data);
		Gson gson = new Gson();
		
		String returnStr = gson.toJson(returnList);
		out.println(returnStr);
	}
	else if(action.equals("updateCookingStatus")){
			returnValue = order.updateCookingStatus(data);
			out.println(returnValue);
	}else if(action.equals("checkoutOrder")){
			returnValue = order.checkoutOrder(data);
			out.println(returnValue);
	}else if(action.equals("checkIfMenuProcessed")){
			returnValue = order.checkIfMenuProcessed(data);
			out.println(returnValue);
	}else if(action.equals("deleteRecord")){
			returnValue = order.deleteRecord(data);
			out.println(returnValue);
	}else if(action.equals("cancelOrder")){
			returnValue = order.cancelRecord(data);
			out.println(returnValue);
	}else if(action.equals("updateCustomer")){
			returnValue = order.updateCustomerInOrder(data);
			out.println(returnValue);
	}
}catch (Exception ex){
	ex.printStackTrace();
	response.setStatus(503);
}

%>