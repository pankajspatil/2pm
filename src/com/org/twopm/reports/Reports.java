package com.org.twopm.reports;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedHashMap;

import com.org.twopm.generic.ConnectionsUtil;

public class Reports {

	
	public LinkedHashMap<String, LinkedHashMap<String, String>> getOrderStatusData(String fromDate, String toDate, String reportType) throws SQLException{
		
		ConnectionsUtil connectionsUtil = new ConnectionsUtil();
		Connection conn = connectionsUtil.getConnection();
		
		String format = reportType.equalsIgnoreCase("month") ? "%b-%y" : "%d-%b-%y";
		String orderByFormat = reportType.equalsIgnoreCase("month") ? "%Y-%m" : "%Y-%m-%d";
		
		String query = "select s.status_id, status_name, count(*) as orderCount, "
					+ "date_format(o.created_on, '"+ format +"') as reportKey "
					+ "from order_master o inner join status_master s on o.status_id = s.status_id "
					+ "and o.created_on between ? AND ? group by reportKey, s.status_id "
					+ "order by date_format(o.created_on, '"+orderByFormat+"') desc , s.status_id;";
		
		PreparedStatement psmt = conn.prepareStatement(query);
		psmt.setString(1, fromDate + " 00:00:00");
		psmt.setString(2, toDate + " 23:59:59");
		
		ResultSet dataRS = psmt.executeQuery();
		String previousKey = "", currentKey = "";
		LinkedHashMap<String, LinkedHashMap<String, String>> dateMap = new LinkedHashMap<String, LinkedHashMap<String,String>>();
		LinkedHashMap<String, String> statusMap = new LinkedHashMap<String, String>();
		
		while(dataRS.next()){
			currentKey = dataRS.getString("reportKey");
			if(!previousKey.equals("") && !previousKey.equals(currentKey)){
				dateMap.put(previousKey, statusMap);				
				statusMap = new LinkedHashMap<String, String>();
			}
			statusMap.put(dataRS.getString("status_id"), dataRS.getString("orderCount"));			
			previousKey = currentKey;
		}
		dateMap.put(previousKey, statusMap);
		
		connectionsUtil.closeConnection(conn);
		
		return dateMap;
	}
	
public LinkedHashMap<String, String> getRevenueData(String fromDate, String toDate, String reportType) throws SQLException{
		
		ConnectionsUtil connectionsUtil = new ConnectionsUtil();
		Connection conn = connectionsUtil.getConnection();
		
		String format = reportType.equalsIgnoreCase("month") ? "%b-%y" : "%d-%b-%y";
		String orderByFormat = reportType.equalsIgnoreCase("month") ? "%Y-%m" : "%Y-%m-%d";
		
		String query = "select s.status_id, sum(ifnull(order_price,0)) - sum(ifnull(discount_amt,0)) as amount, "
					+ "date_format(o.created_on, '"+ format +"') as reportKey "
					+ "from order_master o inner join status_master s on o.status_id = s.status_id "
					+ "inner join order_menu_map om on om.order_id = o.order_id and om.is_active = 1 "
					+ "and o.created_on between ? AND ? and status_code = 'COMPLETED' group by reportKey "
					+ "order by date_format(o.created_on, '"+orderByFormat+"') desc";
		
		PreparedStatement psmt = conn.prepareStatement(query);
		psmt.setString(1, fromDate + " 00:00:00");
		psmt.setString(2, toDate + " 23:59:59");
		
		ResultSet dataRS = psmt.executeQuery();
		LinkedHashMap<String, String> revenueMap = new LinkedHashMap<String, String>();
		
		while(dataRS.next()){

			revenueMap.put(dataRS.getString("reportKey"), dataRS.getString("amount"));
			
		}

		connectionsUtil.closeConnection(conn);
		return revenueMap;
	}
	
	public LinkedHashMap<String, String> getActiveStatus() throws SQLException{
		
		LinkedHashMap<String, String> statusMap = new LinkedHashMap<String, String>();
		
		ConnectionsUtil connectionsUtil = new ConnectionsUtil();
		Connection conn = connectionsUtil.getConnection();
		
		String query = "select * from status_master where is_active = 1 and status_code not in('COOKING', 'INDELIVERY', 'DELIVERED') order by status_id desc";
		ResultSet dataRS = conn.createStatement().executeQuery(query);
		while(dataRS.next()){
			statusMap.put(dataRS.getString("status_id"), dataRS.getString("status_name"));
		}
		
		connectionsUtil.closeConnection(conn);
		dataRS = null; conn = null; query = null;
		
		return statusMap;
	}
}
