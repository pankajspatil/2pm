<%@page import="com.org.twopm.transfer.Table"%>
<%@page import="java.util.List"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="com.org.twopm.home.Home"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ include file="/pages/common/header.jsp"%>
    <%@ include file="/pages/common/validateSession.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/resources/css/home.css">
<%-- <link rel="stylesheet" type="text/css" href="<%=contextPath%>/resources/css/materialize.css">  --%>
</head>
<body>
<form method="post" >
	<table width="99%" align="center">
		<tr>
			<td width="33.33%">&nbsp;</td>
			<td width="33.33%" align="center"><h1>Table Status</h1></td>
			<td width="33.33%" align="right">
			<input type="button" style="vertical-align: bottom;" class="btn btn-main btn-2g" name="parcel" id="parcel" value="Parcel" onclick="openOrderPage();" />
				<div
					style="border: 2px solid black; width: 30%; text-align: center; display: inline-block;">
					<div class="reactanleDiv avlblFill">Vacant</div>
					<!-- <div>Reserved</div> -->
					<div class="reactanleDiv occpdFill">Occupied</div>
				</div>
			</td>
		</tr>
	</table>
	<%
int tablesPerRow = 5;
Home home = new Home();
LinkedHashMap<String, List<Table>> tableMap = home.getTables();
//out.println(tableMap.toString());

if(tableMap.size() > 0){
	for(String tableType : tableMap.keySet()){
		%>
		<table width="99%" align="center">
			<tr>
				<td width="33.33%">&nbsp;</td>
				<td width="33.33%" align="center"><h3><%=tableType %></h3></td>
				<td width="33.33%" align="right"></td>
			</tr>
		</table>
		<%
		List<Table> tableList = tableMap.get(tableType);
		if(tableList.size() > 0){
			%><table align="center" width="<%=tablesPerRow * 10 %>%" border="1" cellpadding="20"
			cellspacing="20">
			<tr>
			<%
			int count = tablesPerRow;
			for(Table table : tableList){
				%><td align="center" class='waves-effect <%=Utils.getString(table.getStatusCode()).equals("INQUEUE")
						? "homeTableOccpd" : "homeTableAvlble"%>' 
						onclick="openOrderPage(<%=table.getTableId()%>,'<%=table.getTableName()%>','<%=table.getPriceType()%>')">
						<b><%=table.getTableName()%></b>
					</td><%
				count --;
				if(count == 0){
					%></tr><tr class="homeTable"><%
					count = tablesPerRow;
				}
			}
			%>
		</tr>
<!-- 		<tr><td><a class="waves-effect waves-red btn">button</a></td></tr>
 -->
	</table>

	<%
		}
	}
}

%>

<!-- <h1 align="center">Table Status<div style="float: right;border: 1px;">Text</div></h1> -->
<script src="<%=contextPath%>/resources/js/materialize.js" type="text/javascript"></script>
<script src="<%=contextPath%>//resources/js/order.js" type="text/javascript"></script>
</form>
</body>
<%@ include file="/pages/common/footer.jsp" %>
</html>
