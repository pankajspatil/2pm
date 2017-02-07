<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="com.org.twopm.reports.Reports"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="/pages/common/header.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html5/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<script src="<%=contextPath%>/resources/js/reports.js" type="text/javascript"></script>
</head>
<body>
<%
String fromDate = Utils.getString(request.getParameter("fromDate"));
String toDate = Utils.getString(request.getParameter("toDate"));
String reportType = Utils.getString(request.getParameter("reportType"));

String page1 = Utils.getString(request.getParameter("page1"));
if (fromDate.equals("") && page1.equals("")){
	 String pattern = "yyyy-MM-dd"; 
	 SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern); 
	 String date = simpleDateFormat.format(new Date());
	 fromDate = date;
	 toDate = date;
	}
%>

<h2 align="center">Order Status Report</h2>
<form action="" method="post">
	<table align="center" border="0" width="30%">
		<tr align="center">
			<td>
				<b>From Date</b> &nbsp; <input size="12" type="text" name="fromDate" id="fromDate" value="<%=fromDate %>" 
				placeholder="From date" style="padding: 4px;" readonly="readonly">
			</td>
			
			<td>
				<b>To Date</b> &nbsp;<input size="12" type="text" name="toDate" id="toDate" value="<%=toDate %>" 
				placeholder="To Date" style="padding: 4px;" readonly="readonly">
			</td>
		</tr>
		<tr align="center">
			<td colspan="2">
				<input type="radio" name="reportType" id="day" value="day" 
				<%=reportType.equals("day") ? "checked = checked" : "" %>> Day Wise
				&nbsp;
				<input type="radio" name="reportType" id="day" value="month"
				<%=reportType.equals("month") ? "checked = checked" : "" %>> Month Wise				
			</td>
		</tr>
		<tr align="center">
			<td colspan="2">
				<input class="btn btn-main btn-2g" type="submit" name="page1" id="page1" value="Submit" onclick="return validateStatusForm()">
			</td>
		</tr>
	</table>
</form>
<%
if(!page1.equals("")){
	
	Reports reports = new Reports();
	LinkedHashMap<String, LinkedHashMap<String, String>> dateMap = reports.getOrderStatusData(fromDate, toDate, reportType);
	LinkedHashMap<String, String> orderCountMap = new LinkedHashMap<String, String>();
	LinkedHashMap<String, String> statusMap = reports.getActiveStatus();
	
	if(dateMap.size() > 0){
		
		LinkedHashMap<String, LinkedHashMap<String, String>> chartMap = new LinkedHashMap<String, LinkedHashMap<String, String>>();
		LinkedHashMap<String, String> dtMap = new LinkedHashMap<String, String>();
		
		String chartString = "<chart palette='2' caption='Product Comparison' showlabels='1' showvalues='0'  "+
							"showsum='1' decimals='0' useroundedges='1' legendborderalpha='0' showborder='0'><categories>";
		
		%><br/>
		<div id="orderStatus-container" class="tab-container">
			<ul class='etabs'>
				<li class='tab' id="chartTab"><a href="#orderStatusChart">Chart</a></li>
				<li class='tab' id="dataTab"><a href="#orderStatusData">Data</a></li>
			</ul>
			
			<div id="orderStatusChart">
				<center>
					<div id="chartContainer">
					<img alt="" src="<%=contextPath%>/resources/images/loading.gif" align="middle">
					
						<!-- <script type="text/javascript">
							$('#chartContainer').LoadingOverlay("show");
						</script> -->
					</div>
				</center>
			</div>
			
			<div id="orderStatusData">
				<table width="100%" id="orderStatusCountTable" border="1" class="display" cellspacing="0" >
				<thead>
					<tr class="headerTR">
						<td>Date</td>
						<%
						for(String key : statusMap.keySet()){
							%><td><%=statusMap.get(key)%></td><%
						}
						
						%>
					</tr>
				</thead>
				<tbody>
				
					<%
						for(String key : dateMap.keySet()){
							
							chartString += "<category label='" + key + "' labeltooltext='' />";
							orderCountMap = dateMap.get(key);
							%>
								<tr align="center">
									<td><%=key %></td>
									<%
									for(String statusKey : statusMap.keySet()){
										if(!chartMap.containsKey(statusKey)){
											dtMap = new LinkedHashMap<String, String>();
										}else{
											dtMap = chartMap.get(statusKey);
										}
										
										dtMap.put(key, (orderCountMap.containsKey(statusKey) ? orderCountMap.get(statusKey) : "0"));
										chartMap.put(statusKey, dtMap);
										
										%><td><%=orderCountMap.containsKey(statusKey) ? orderCountMap.get(statusKey) : "&nbsp;"%></td><%
									}
									%>
								</tr>
							<%
						}
					chartString += "</categories>";
					
					for(String sKey : statusMap.keySet()){
						chartString += "<dataset seriesname='" + statusMap.get(sKey) + "' showvalues='0'>";
						dtMap = chartMap.get(sKey);
						for(String dtKey : dtMap.keySet()){
							chartString += "<set value='"+(dtMap.get(dtKey))+"' />";
						}
						chartString += "</dataset>";
					}
					
					//chartString += "<dataset seriesname='" + key + "' showvalues='0'>";
					//chartString += "<set value='"+(orderCountMap.containsKey(statusKey) ? orderCountMap.get(statusKey) : 0)+"' />";
					//chartString += "</dataset>";
					
					//out.println(chartMap);
					
					%>
				</tbody>
				</table>
			</div>
		</div>
		<script type="text/javascript">
		$('#orderStatus-container').easytabs({
			uiTabs: true, 
			 collapsible: true ,
			 defaultTab: 'li#dataTab'
			 });
		
		$(document).ready(function() {
			   var orderCounts = $('#orderStatusCountTable').DataTable({
			    	"bSort" : true,
			    	"paging" : true/*,
			    	"pageLength": 15,
			    	"aLengthMenu": [[10, 15, 25, 35, 50, 100], [10, 15, 25, 35, 50, 100]]*/	
			    });
		});
		
		FusionCharts.ready(function () {
		    var myChart = new FusionCharts({
		      "type": "stackedcolumn2d",
		      "renderAt": "chartContainer",
		      "width": "100%",
		      "height": "450",
		      "dataFormat": "xml",
		      "dataSource": "<%=chartString%>"
		    });

		  myChart.render();
		});
		
		/* $('#chartContainer').LoadingOverlay("hide"); */
		
		</script>
	<%
	chartString += "</chart>";
	}	
}
%>


	
	<script>
	$( "#fromDate" ).datepicker({
		changeMonth: true,
	    changeYear: true,
	    dateFormat:'yy-mm-dd',
	    onSelect: function (date) {
	    	$( "#toDate" ).datepicker( "option", "minDate", date );
        }
	});

	$( "#toDate" ).datepicker({
		changeMonth: true,
	    changeYear: true,
	    dateFormat:'yy-mm-dd',
	    onSelect: function (date) {
	    	$( "#fromDate" ).datepicker( "option", "maxDate", date );
        }
	});
	</script>
</body>
</html>