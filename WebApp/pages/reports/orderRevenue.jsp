<%@page import="java.util.LinkedHashMap,java.text.*,java.util.Date"%>
<%@page import="com.org.twopm.reports.Reports"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="/pages/common/header.jsp"%>
<%@ include file="/pages/common/validateSession.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html5/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

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

<h2 align="center">Revenue Report</h2>
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
	LinkedHashMap<String, String> revenueMap = reports.getRevenueData(fromDate, toDate, reportType);
	//out.println(revenueMap);
	
	if(revenueMap.size() > 0){
		
		LinkedHashMap<String, LinkedHashMap<String, String>> chartMap = new LinkedHashMap<String, LinkedHashMap<String, String>>();
		LinkedHashMap<String, String> dtMap = new LinkedHashMap<String, String>();
		
		String chartString = "<chart caption='Revenue Report' subcaption='' xaxisname='Period' yaxisname='Sales' numberprefix='&#8377;' "+
		 		 "showlabels='1' showalternatehgridcolor='1' decimals='2' alternatehgridcolor='ff5904' divlinecolor='ff5904' divlinealpha='20' "+
				"alternatehgridalpha='5' canvasbordercolor='666666' canvasborderthickness='1' basefontcolor='666666' "+
		 		 "linecolor='FF5904' linealpha='85' showvalues='1' rotatevalues='1' valueposition='auto' "+
				"canvaspadding='8' bgcolor='ffffff' valuepadding='5' showborder='0' showValues='1' formatNumberScale='0'>";
		 		 
		%><br/>
		<div id="orderRevenue-container" class="tab-container">
			<ul class='etabs'>
				<li class='tab' id="chartTab"><a href="#orderRevenueChart">Chart</a></li>
				<li class='tab' id="dataTab"><a href="#orderRevenueData">Data</a></li>
			</ul>
			
			<div id="orderRevenueChart">
				<center>
					<div id="chartContainer">
					<img alt="" src="<%=contextPath%>/resources/images/loading.gif" align="middle">
					</div>
				</center>
			</div>
			
			<div id="orderRevenueData">
				<table width="100%" id="orderRevenueTable" border="1" class="display" cellspacing="0" >
				<thead>
					<tr class="headerTR">
						<td>Date</td>
						<td>Revenue</td>
					</tr>
				</thead>
				<tbody>
				
					<%
						//String dataSetString = "<dataset seriesname='Revenue'>";
						for(String key : revenueMap.keySet()){
							
							//chartString += "<category label='" + key + "' labeltooltext='' />";
							chartString += "<set label='"+key+"' value='"+ revenueMap.get(key) +"' />";
							%>
								<tr align="center">
									<td><%=key %></td>
									<td><%=revenueMap.get(key) %></td>
								</tr>
							<%
						}
						chartString += "</chart>";
				//System.out.println(chartString);		
						
					%>
				</tbody>
				</table>
			</div>
		</div>
		<script type="text/javascript">
		$('#orderRevenue-container').easytabs({
			uiTabs: true, 
			 collapsible: true ,
			 defaultTab: 'li#dataTab'
			 });
		
		$(document).ready(function() {
			   var orderCounts = $('#orderRevenueTable').DataTable({
				   "aaSorting": [ [0,'desc'] ],
			    	"bSort" : true,
			    	"paging" : true/*,
			    	"pageLength": 15,
			    	"aLengthMenu": [[10, 15, 25, 35, 50, 100], [10, 15, 25, 35, 50, 100]]*/	
			    });
		});
		
		FusionCharts.ready(function () {
		    var myChart = new FusionCharts({
		      "type": "line",
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
	//chartString += "</chart>";
	}	
}
%>
<script src="<%=contextPath%>/resources/js/reports.js" type="text/javascript"></script></body>
</html>