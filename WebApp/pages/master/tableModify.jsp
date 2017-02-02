<%@ include file="/pages/general/variables.jsp"%>
<%@ page errorPage="/pages/common/error.jsp" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page import="com.org.agritadka.home.Home"%>
<%@page import="java.sql.PreparedStatement,java.sql.ResultSet" %>
<%@page import="com.org.agritadka.generic.ConnectionsUtil,java.sql.Connection,java.sql.Statement"%>
    
	<%
    		PreparedStatement psmt = null;
    		//http://localhost:8080/AgriTadka/pages/master/tableModify.jsp?tableRows=%2C%2C2%2C3&tableData_length=10&tableName2=Table+2&tableType2=1&checkbox2=EDIT&tableName3=Table+3&tableType3=1&checkbox3=EDIT&tableName4=Table+4&tableType4=1&tableName5=Table+5&tableType5=1&tableName6=Table+6&tableType6=1&tableName7=Table+7&tableType7=1&tableName8=Table+8&tableType8=1&tableName10=Table+10&tableType10=1&tableName2=Table+2&tableType2=1&tableName2=Table+2&tableType2=1
    		ConnectionsUtil connectionsUtil = new ConnectionsUtil();
    		Connection conn = connectionsUtil.getConnection();

    		if (request.getParameter("tableName") != null) {

    			String tableName = request.getParameter("tableName");
    			int tableType = Integer.parseInt(request
    					.getParameter("tableType"));
    			int tableStatus = Integer.parseInt(request
    					.getParameter("tableStatus"));
    			int tableId=0;
    			String query = "INSERT INTO table_master (table_name,is_active,created_by) values(?,?,?)";
    			psmt = conn.prepareStatement(query,
    					Statement.RETURN_GENERATED_KEYS);
    			psmt.setString(1, tableName);
    			psmt.setInt(2, 1);
    			psmt.setInt(3, 1);
    			psmt.executeUpdate();

    			ResultSet dataRS = psmt.getGeneratedKeys();

    			if (dataRS.next()) {
    				tableId = dataRS.getInt(1);
    			}

    			int activestatus = 0;
    			if (tableStatus == 1) {
    				activestatus = 1;
    			}

    			query = "INSERT INTO table_type_name_map (table_type_id,table_id,price_type,is_active,created_by) values(?,?,?,?,?)";
    			psmt = conn.prepareStatement(query,
    					Statement.RETURN_GENERATED_KEYS);
    			psmt.setInt(1, 1);
    			psmt.setInt(2, tableId);
    			psmt.setString(3, "ac");
    			psmt.setInt(4, activestatus);
    			psmt.setInt(5, 1);
    			psmt.addBatch();

    			activestatus = 0;
    			if (tableStatus == 0) {
    				activestatus = 1;
    			}
    			psmt.setInt(1, 2);
    			psmt.setInt(2, tableId);
    			psmt.setString(3, "non-ac");
    			psmt.setInt(4, activestatus);
    			psmt.setInt(5, 1);
    			psmt.addBatch();

    			psmt.executeBatch();
    		} else {
    			String[] operation = request.getParameter("tableRows").split(
    					",");

    			for (int i = 0; i < operation.length; i++) {

    				String rowidStr = operation[i];
    				if (rowidStr == null && rowidStr.trim().length() == 0) {
    					continue;
    				}
    				
    				String tableType = request.getParameter("tableType"
    						+ rowidStr);
    				String query = "UPDATE table_type_name_map SET is_active =" + tableType
    						+ " WHERE table_type_name_map_id =" + rowidStr;
    				psmt = conn.prepareStatement(query,
    						Statement.RETURN_GENERATED_KEYS);
    				psmt.addBatch();
    			}// end of for
    			psmt.executeUpdate();
    			response.sendRedirect(contextPath + "/pages/master/tableMaster.jsp?tableOperation=edit");
    		}
    		
    	%>

<script>
window.close();
</script>