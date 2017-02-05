package com.org.twopm.home;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;

import com.org.twopm.generic.ConnectionsUtil;
import com.org.twopm.transfer.Table;

public class Home {
	
	public LinkedHashMap<String, List<Table>> getTables() throws SQLException{
		
		ConnectionsUtil connectionsUtil = new ConnectionsUtil();
		Connection conn = connectionsUtil.getConnection();
		
		String query = "select ttn.table_type_name_map_id,t.table_id, t.table_name, tm.table_type,tm.is_active,status_code, ttn.price_type"
				+ " from table_type_name_map ttn inner join table_type_master tm on ttn.table_type_id = tm.table_type_id "
				+ "and ttn.is_active = 1 and tm.is_active = 1 inner join table_master t on ttn.table_id = t.table_id "
				+ "and t.is_active = 1 left join (select o.table_id, s.status_code, status_name from order_master o "
				+ "inner join status_master s on o.status_id = s.status_id and s.status_code = 'INQUEUE' "
				+ "and o.table_id is not null) ord on ttn.table_type_name_map_id = ord.table_id "
				+ "order by tm.table_type_id, t.table_id;";
		
		System.out.println("query ==> " + query);
		
		ResultSet dataRS = conn.createStatement().executeQuery(query);
		LinkedHashMap<String, List<Table>> tableMap = new LinkedHashMap<String, List<Table>>();
		String previousTblType = "", currentTblType = "";
		Table table;
		List<Table> tableList = new ArrayList<Table>();
		
		while(dataRS.next()){
			
			currentTblType = dataRS.getString("table_type");
			if(!previousTblType.equals(currentTblType) && !previousTblType.equals("")){
				tableMap.put(previousTblType, tableList);
				tableList = new ArrayList<Table>();
			}
			table = new Table();
			table.setTableId(dataRS.getInt("table_type_name_map_id"));
			table.setTableMasterId(dataRS.getInt("table_id"));
			table.setTableName(dataRS.getString("table_name"));
			table.setTableType(dataRS.getString("table_type"));
			table.setIsActive(dataRS.getInt("is_active"));
			table.setStatusCode(dataRS.getString("status_code"));
			table.setPriceType(dataRS.getString("price_type"));
			tableList.add(table);
			previousTblType = currentTblType;
		}
		
		if(tableList.size() > 0){
			tableMap.put(previousTblType, tableList);
		}
		
		connectionsUtil.closeConnection(conn);
		return tableMap;
	}
	
	
public LinkedHashMap<String, List<Table>> getAllTables() throws SQLException{
		
		ConnectionsUtil connectionsUtil = new ConnectionsUtil();
		Connection conn = connectionsUtil.getConnection();
		
					String query = "SELECT ttn.table_type_name_map_id, tm.table_type_id,     "
							+ "t.table_id,     t.table_name,     tm.table_type,      ttn.is_active "
							+ "FROM     table_type_name_map ttn 	"
							+ "INNER JOIN     "
							+ "table_type_master tm ON ttn.table_type_id = tm.table_type_id 	"
							+ "INNER JOIN     table_master t ON ttn.table_id = t.table_id "
							+ "WHERE     t.is_active = 1 "
							+ "ORDER BY tm.table_type_id , t.table_id";
		
		
		System.out.println("query ==> " + query);
		
		ResultSet dataRS = conn.createStatement().executeQuery(query);
		LinkedHashMap<String, List<Table>> tableMap = new LinkedHashMap<String, List<Table>>();
		String previousTblType = "", currentTblType = "";
		Table table;
		List<Table> tableList = new ArrayList<Table>();
		
		while(dataRS.next()){
			
			currentTblType = dataRS.getString("table_type");
			if(!previousTblType.equals(currentTblType) && !previousTblType.equals("")){
				tableMap.put(previousTblType, tableList);
				tableList = new ArrayList<Table>();
			}
			table = new Table();
			table.setTableId(dataRS.getInt("table_type_name_map_id"));
			table.setTableMasterId(dataRS.getInt("table_id"));
			table.setTableName(dataRS.getString("table_name"));
			table.setTableType(dataRS.getString("table_type"));
			table.setIsActive(dataRS.getInt("is_active"));			
			tableList.add(table);
			previousTblType = currentTblType;
		}
		
		if(tableList.size() > 0){
			tableMap.put(previousTblType, tableList);
		}
		
		connectionsUtil.closeConnection(conn);
		return tableMap;
	}
	
	
	
	public void updateTable(int tableId,String tablename,int active){
		ConnectionsUtil connectionsUtil = new ConnectionsUtil();
		Connection conn = connectionsUtil.getConnection();
		
		
		String query="update table_master set table_name='"+tablename+"',is_active="+active+" where table_id="+tableId;
		PreparedStatement psmt;
		try {
			psmt = conn.prepareStatement(query);
			psmt.execute();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

}
