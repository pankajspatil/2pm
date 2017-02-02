<%@page import="com.org.agritadka.generic.Utils"%>
<%@page import="com.org.agritadka.generic.Constants"%>
<%@page import="com.org.agritadka.generic.ConnectionsUtil"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="/pages/general/variables.jsp"%>
<%@ page errorPage="/pages/common/error.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>2 PM</title>

<link rel="stylesheet" type="text/css" href="<%=contextPath%>/resources/css/jquery-ui.css">
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/resources/css/generic.css">
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/resources/css/menu.css">
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/resources/css/search.css">
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/resources/css/lobibox.css">
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/resources/css/jquery-ui.structure.css"></link>
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/resources/css/jquery.dataTables.min.css"></link>
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/resources/css/jquery.fancybox.css?v=2.1.5"></link>
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/resources/css/font-awesome.min.css"></link>
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/resources/css/buttons.dataTables.min.css"></link>
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/resources/css/multiple-select.css">

<!-- Accordion CSS -->
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/resources/css/animate.min.css">
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/resources/css/accordion-demo.css">
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/resources/css/accordion-theme.css">
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/resources/css/accordion-styles.css">



<script type="text/javascript" src="<%=contextPath%>/resources/js/jquery-latest.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/resources/js/jquery.js"></script>
<script type="text/javascript" src="<%=contextPath%>/resources/js/jquery-ui.js"></script>

<script type="text/javascript" src="<%=contextPath%>/resources/js/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/resources/js/dataTables.buttons.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/resources/js/buttons.flash.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/resources/js/jszip.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/resources/js/pdfmake.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/resources/js/vfs_fonts.js"></script>
<script type="text/javascript" src="<%=contextPath%>/resources/js/buttons.html5.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/resources/js/buttons.print.min.js"></script>
 
<script type="text/javascript" src="<%=contextPath%>/resources/js/Map.js"></script>
<script type="text/javascript" src="<%=contextPath%>/resources/js/constants.js"></script>
<script type="text/javascript" src="<%=contextPath%>/resources/js/general.js"></script>
<script type="text/javascript" src="<%=contextPath%>/resources/js/lobibox.js"></script>
<script type="text/javascript" src="<%=contextPath%>/resources/js/menu.js"></script>
<script type="text/javascript" src="<%=contextPath%>/resources/js/jquery.fancybox.pack.js?v=2.1.5"></script>
<script type="text/javascript" src="<%=contextPath%>/resources/js/multiple-select.js"></script>

<!-- Accordion JS -->
<script type="text/javascript" src="<%=contextPath%>/resources/js/accordion-theme.js"></script>
<script type="text/javascript" src="<%=contextPath%>/resources/js/jquery.bwlaccordion.min.js"></script>

<!-- OverLay JS-->

<script src="<%=contextPath%>/resources/js/loadingoverlay.js" type="text/javascript"></script>

<!-- Easy Tabs -->
<script src="<%=contextPath%>/resources/js/jquery.easytabs.min.js" type="text/javascript"></script>
<!-- <script src="<%=contextPath%>/resources/js/jquery.hashchange.min.js" type="text/javascript"></script> -->

<!-- Charts -->
<script src="<%=contextPath%>/resources/js/fusioncharts.js" type="text/javascript"></script>
<script src="<%=contextPath%>/resources/js/fusioncharts.charts.js" type="text/javascript"></script>
<script src="<%=contextPath%>/resources/js/fusioncharts.theme.fint.js" type="text/javascript"></script>

<!-- List Js -->
<script type="text/javascript" src="<%=contextPath%>/resources/js/list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/resources/js/list.pagination.min.js"></script>


</head>

<body>
	<table class="headerTable">
		<tr>
			<td class="headercol">
				<div id="header">
					<!-- <h1>Project Resource Management</h1> -->
					<img src="<%=contextPath %>/resources/images/header/banner.jpg" width="100%" height="95px" />
				</div>
			</td>
		</tr>
	</table>



	<%
		//out.println("==>" + session.getAttribute(Constants.USER_ID) + "==>" + Utils.getString(request.getParameter("menuRequired")));
		//out.println("==" + Utils.getString(request.getParameter("menuRequired")).equals("false"));
		if (session.getAttribute(Constants.USER_ID) != null
				&& !Utils.getString(request.getParameter("menuRequired"))
						.equals("false")) {
	%><%@ include file="/pages/common/menu.jsp"%>
	<%-- <%@ include file="/pages/common/menu1.jsp"%> --%>
	<%
		}
	%>
	<%
		ConnectionsUtil connectionsUtil = new ConnectionsUtil();
	%>



</body>

</html>