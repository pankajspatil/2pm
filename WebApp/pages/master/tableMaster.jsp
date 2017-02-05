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
<link rel="stylesheet" type="text/css"
	href="<%=contextPath%>/resources/css/home.css">
<script type="text/javascript"
	src="<%=contextPath%>/resources/js/search.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		$('#tableData').DataTable({
			"aoColumnDefs" : [ {
				"bSortable" : false,
				"aTargets" : [ 0 ]
			} ],
			"order" : [ [ 1, "asc" ] ]
		});
	});
</script>


<script type="text/javascript">
var tableArray =[];


function changeReadOnly(rowid){


	var el = document.getElementById("tableType"+rowid);
	el.disabled =false;
	tableArray[rowid]=rowid;

}

function updateTables(){
	
	document.getElementById("tableRows").value = tableArray.toString();
	document.getElementById("myForm").submit();	

}
</script>
<script language="javascript" type="text/javascript">

function popitup() {
	newwindow=window.open("AddTable.html",'name','height=500,width=500');
	if (window.focus) {newwindow.focus()}
	return false;
}

</script>

</head>

<body>
<form id="myForm" action="tableModify.jsp" method="get">
<br><br>
<input type="button" value="Add New" onClick="popitup()">
<input type="button" value="update" onclick="updateTables()">
<input type="text" id="tableRows" name="tableRows" value="">
		<table align="center" border="1" cellpadding="20" cellspacing="20"
			id="tableData" class="display">
			<thead>
				<tr class="mainTR">
					<th>Table No</th>
					<th>Table Name</th>
					<th>Table Section</th>
					<th>Status</th>
					<th>Edit</th>
				</tr>
			</thead>
			<%
				Home home = new Home();
				LinkedHashMap<String, List<Table>> tableMap = home.getAllTables();

				for (String tableType : tableMap.keySet()) {
					List<Table> tableList = tableMap.get(tableType);
					if (tableList.size() > 0) {
						for (Table table : tableList) {
			%><tr>
				<td><%=table.getTableId()%></td>
				<td><%=table.getTableName()%></td>
				<td><%=table.getTableType()%></td>
				<td><select id="tableType<%=table.getTableId()%>" name="tableType<%=table.getTableId()%>"
					disabled="true">
						<option value="1" <%=(table.getIsActive() == 1) ? "selected" : ""%>>Active</option>
						<option value="0" <%=(table.getIsActive() == 0) ? "selected" : ""%>>In
							Active</option>
				</select></td>
				<td><input type="checkbox" name="checkbox<%=table.getTableId()%>" value="EDIT"
					onClick="changeReadOnly('<%=table.getTableId()%>')" title="Click to Edit" />
			</tr>
			<%
				}
					}// end of if
				}// end of for
			%>
		</table>

	</form>
</body>
</html>