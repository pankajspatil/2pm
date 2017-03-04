package com.org.twopm.order;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.org.twopm.generic.ConnectionsUtil;
import com.org.twopm.generic.Utils;
import com.org.twopm.transfer.Cooking;
import com.org.twopm.transfer.Customer;
import com.org.twopm.transfer.DeliveryTracker;
import com.org.twopm.transfer.MainMenu;
import com.org.twopm.transfer.MenuMapper;
import com.org.twopm.transfer.OrderData;
import com.org.twopm.transfer.OrderMenu;
import com.org.twopm.transfer.Status;
import com.org.twopm.transfer.SubMenu;
import com.org.twopm.transfer.User;
import com.org.twopm.transfer.Waiter;

public class Order {
	
	public static void main(String args[]) throws SQLException {
		Order order = new Order();
		//order.getOrderedMenus("");
	}

	public LinkedHashMap<MainMenu, List<MenuMapper>> getMenus(String priceType) throws SQLException{
		
		ConnectionsUtil connectionsUtil = new ConnectionsUtil();
		Connection conn = connectionsUtil.getConnection();
		
		String query = "SELECT ms.main_sub_menu_map_id, m.main_menu_id, s.sub_menu_id, " +
						"m.menu_name as main_menu, s.menu_name as sub_menu, s."+ priceType +"_unit_price as unit_price, s.is_veg,s.is_cookable "+
						"FROM main_sub_menu_map ms "+
						"inner join main_menu_master m on m.main_menu_id = ms.main_menu_id and ms.is_active = 1 and m.is_active = 1 "+
						"inner join sub_menu_master s on s.sub_menu_id = ms.sub_menu_id and s.is_active = 1 order by m.menu_name, s.menu_name";
		ResultSet dataRS = conn.createStatement().executeQuery(query);
		
		Integer mainMenuId, prevId = 0, mainSubMenuId, subMenuId;
		LinkedHashMap<MainMenu, List<MenuMapper>> mainSubMenuMap = new LinkedHashMap<MainMenu, List<MenuMapper>>();
		
		String mainMenuName, subMenuName;
		Float unitPrice = new Float(0);
		MainMenu mainMenuObj, oldObj = null;
		SubMenu subMenuObj;
		MenuMapper menuMapper;
		List<MenuMapper> menus = new ArrayList<MenuMapper>();
		
		while(dataRS.next()){
			
			mainMenuId = dataRS.getInt("main_menu_id");
			mainMenuName = dataRS.getString("main_menu");
			subMenuName = dataRS.getString("sub_menu");
			subMenuId = dataRS.getInt("sub_menu_id");
			mainSubMenuId = dataRS.getInt("main_sub_menu_map_id");
			unitPrice = dataRS.getFloat("unit_price");
			
			if(mainMenuId != prevId && prevId != 0){
				
				mainSubMenuMap.put(oldObj, menus);
				menus = new ArrayList<MenuMapper>();
			}
			
			mainMenuObj = new MainMenu();
			mainMenuObj.setMainMenuId(mainMenuId);
			mainMenuObj.setMainMenuName(mainMenuName);
			
			subMenuObj = new SubMenu();
			subMenuObj.setSubMenuId(subMenuId);
			subMenuObj.setSubMenuName(subMenuName);
			subMenuObj.setUnitPrice(unitPrice);
			subMenuObj.setVeg(dataRS.getBoolean("is_veg"));
			subMenuObj.setCookable(dataRS.getBoolean("is_cookable"));
			
			menuMapper = new MenuMapper();
			menuMapper.setMainMenu(mainMenuObj);
			menuMapper.setSubMenu(subMenuObj);
			menuMapper.setMainSubMenuId(mainSubMenuId);
					
			menus.add(menuMapper);
			
			oldObj = mainMenuObj;
			prevId = mainMenuId;
			
		}
		mainSubMenuMap.put(oldObj, menus);
		
		//System.out.println("mainSubMenuMap==>" + mainSubMenuMap.toString());
		
		connectionsUtil.closeConnection(conn);
		
		return mainSubMenuMap;
	}
	
	public String saveOrder(String data, String userId) throws SQLException{
		
		boolean isSystemCookable = false;
		String status = "";
		
		ConnectionsUtil connectionsUtil = new ConnectionsUtil();
		Connection conn = connectionsUtil.getConnection();
		
		JsonParser jsonParser = new JsonParser();
		JsonObject jsonObject = (JsonObject)jsonParser.parse(data);
		
		Integer waiterId = null, orderId = null, tableId = null;
		Float advanceAmt = new Float(0), discountAmt = new Float(0);
		
		if(jsonObject.get("waiterId") != null){
			waiterId = jsonObject.get("waiterId").getAsInt();
			jsonObject.remove("waiterId");
		}	
		
		if(jsonObject.get("orderId") != null){
			orderId = jsonObject.get("orderId").getAsInt();
			jsonObject.remove("orderId");
		}
		
		if(jsonObject.get("tableId") != null){
			tableId = jsonObject.get("tableId").getAsInt();
			jsonObject.remove("tableId");
		}
		if(jsonObject.get("advance") != null){
			advanceAmt = jsonObject.get("advance").getAsFloat();
			jsonObject.remove("advance");
		}
		if(jsonObject.get("discount") != null){
			discountAmt = jsonObject.get("discount").getAsFloat();
			jsonObject.remove("discount");
		}

		ResultSet dataRS;
		
		if(orderId == null || orderId == 0){
			
			String query3 = "INSERT INTO `order_master`(`order_sequence`,`table_id`,`status_id`,`created_by`) "+
					"VALUES(getNextCustomSeq(),?, (select status_id from status_master where status_code = 'INQUEUE'), ?);";
			
			PreparedStatement psmt3 = conn.prepareStatement(query3,
					Statement.RETURN_GENERATED_KEYS);

			if (tableId != null) {
				psmt3.setInt(1, tableId);
			} else {
				psmt3.setNull(1, Types.INTEGER);
			}

			psmt3.setString(2, userId);
			psmt3.executeUpdate();

			dataRS = psmt3.getGeneratedKeys();

			if (dataRS.next()) {
				orderId = dataRS.getInt(1);
			}
		}
		
		
		String query = "insert into order_menu_map(order_id, main_sub_menu_map_id, quantity, unit_price, "
				+ "status_id, notes, created_by, order_price)" 
				+ "values(?,?,?,?, (select status_id from status_master where status_code = ?),?,?,?)";
	
		String query1 = "update order_menu_map set quantity = ?, order_price = ?, notes = ? where order_menu_map_id = ? ";

		String query2 = "update order_master set waiter_id = ?, advance_amt = ?, discount_amt = ? where order_id = ?";

		PreparedStatement psmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
		PreparedStatement psmt1 = conn.prepareStatement(query1);
		PreparedStatement psmt2 = conn.prepareStatement(query2);
		
		for (Map.Entry<String,JsonElement> entry : jsonObject.entrySet()) {
		    JsonObject jObject = entry.getValue().getAsJsonObject();
		 
		    if(jObject.get("orderMenuMapId") != null){
		    	psmt1.setInt(1, jObject.get("quantity").getAsInt());
		    	psmt1.setInt(2, jObject.get("finalPrice").getAsInt());
		    	psmt1.setString(3, jObject.get("notes").getAsString());
		    	psmt1.setInt(4, jObject.get("orderMenuMapId").getAsInt());
		    	
		    	psmt1.addBatch();
		    }else{
		    	
		    	//orderId = (jObject.get("orderId") == null ? orderId : jObject.get("orderId").getAsInt();
		    	if (isSystemCookable){
					status ="INQUEUE";
				}else{
					
					if(jObject.get("cookable").getAsBoolean()){
						status ="INQUEUE";
					}else{
						status="COMPLETED";	
					}								
				}
		    	
		    	psmt.setInt(1, orderId);
			    psmt.setInt(2, jObject.get("menuId").getAsInt());
			    psmt.setInt(3, jObject.get("quantity").getAsInt());
			    psmt.setFloat(4, jObject.get("unitPrice").getAsFloat());
			    psmt.setString(5,status );
			    psmt.setString(6, jObject.get("notes").getAsString());
			    psmt.setString(7, userId);
			    psmt.setString(8, jObject.get("finalPrice").getAsString());
			    
			    psmt.executeUpdate();
				
				dataRS = psmt.getGeneratedKeys();
				
				if(dataRS.next()){
					jObject.addProperty("orderMenuMapId", dataRS.getString(1));
				}
			    //psmt.addBatch();
		    }
		}
		
		//psmt.executeBatch();
		psmt1.executeBatch();
		
		psmt2.setNull(1, Types.INTEGER);
		psmt2.setFloat(2, advanceAmt);
		psmt2.setFloat(3, discountAmt);
		psmt2.setInt(4, orderId);
		
		if(waiterId != null){
			psmt2.setInt(1, waiterId);
		}
		psmt2.executeUpdate();
		
		/*
		if(waiterId != null){
	    	psmt2.setInt(1, waiterId);
	    	psmt2.setInt(2, orderId);
	    	
	    	psmt2.executeUpdate();
	    }*/
		
		Gson gson = new Gson();
		jsonObject.addProperty("orderId", orderId);
		
		connectionsUtil.closeConnection(conn);
		
		return gson.toJson(jsonObject);
	}
	
	public OrderData getOrderData(Integer tableId, String userId, Integer orderId) throws SQLException{
		
		ConnectionsUtil connectionsUtil = new ConnectionsUtil();
		Connection conn = connectionsUtil.getConnection();
		
		int count = 0;
		ResultSet dataRS = null;
		String query = "";
		OrderData orderData = new OrderData();
		
		if(tableId != null || orderId != null){
		
		query = "select o.order_id,o.order_sequence, om.order_menu_map_id , msm.main_sub_menu_map_id, om.quantity, om.unit_price, "+
						"om.order_price, sm.menu_name, om.notes, sm.is_cookable,s.status_code, o.waiter_id, "+ 
						"o.customer_name, o.mobile_number, o.customer_address, o.tax, o.advance_amt, o.discount_amt "+
						"from order_master o inner join status_master s on o.status_id = s.status_id ";
		
		if(tableId != null){
			query += "and s.status_code = 'INQUEUE' and o.table_id = "+ tableId +" ";
		}else if(orderId != null){
			query += "and o.order_id = "+ orderId +" ";
		}
						
		query += "left join order_menu_map om on o.order_id = om.order_id and om.is_active = 1 "+
				"left join main_sub_menu_map msm on msm.main_sub_menu_map_id = om.main_sub_menu_map_id "+
				"left join main_menu_master mm on mm.main_menu_id = msm.main_menu_id "+
				"left join sub_menu_master sm on msm.sub_menu_id = sm.sub_menu_id";
		System.out.println("query==>" + query);
		
		dataRS = conn.createStatement().executeQuery(query);
		
		OrderMenu orderMenu;
		List<OrderMenu> orderMenus = new ArrayList<OrderMenu>();
		
		while(dataRS.next()){
			if(count == 0){
				orderData.setOrderId(dataRS.getInt("order_id"));
				orderData.setOrder_sequence(dataRS.getString("order_sequence"));
				orderData.setStatusCode(dataRS.getString("status_code"));
				orderData.setWaiterName(dataRS.getString("waiter_id"));
				orderData.setCustName(dataRS.getString("customer_name"));
				orderData.setMobileNumber(dataRS.getString("mobile_number"));
				orderData.setCustAddress(dataRS.getString("customer_address"));
				orderData.setTaxRate(dataRS.getFloat("tax"));
				orderData.setAdvanceAmt(dataRS.getFloat("advance_amt"));
				orderData.setDiscountAmt(dataRS.getFloat("discount_amt"));
			}
			
			if(dataRS.getString("main_sub_menu_map_id") != null){
				orderMenu = new OrderMenu();
				orderMenu.setMainSubMenuMapId(dataRS.getInt("main_sub_menu_map_id"));
				orderMenu.setOrderMenuMapId(dataRS.getInt("order_menu_map_id"));
				orderMenu.setQuantity(dataRS.getInt("quantity"));
				orderMenu.setUnitPrice(dataRS.getFloat("unit_price"));
				orderMenu.setFinalPrice(dataRS.getFloat("order_price"));
				orderMenu.setNotes(dataRS.getString("notes"));
				orderMenu.setSubMenuName(dataRS.getString("menu_name"));
				orderMenu.setCookable(dataRS.getBoolean("is_cookable"));
				
				orderMenus.add(orderMenu);
				orderData.setSelectedMenus(orderMenus);
			}
			count ++;
		}
		}
		/*if(count == 0){
			
			query = "INSERT INTO `order_master`(`table_id`,`status_id`,`created_by`) "+
					"VALUES(?, (select status_id from status_master where status_code = 'INQUEUE'), ?);";
			
			PreparedStatement psmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
			
			if(tableId != null){
				psmt.setInt(1, tableId);
			}else{
				psmt.setNull(1, Types.INTEGER);
			}
			
			psmt.setString(2, userId);
			psmt.executeUpdate();
			
			dataRS = psmt.getGeneratedKeys();
			
			if(dataRS.next()){
				orderData.setOrderId(dataRS.getInt(1));
				orderData.setStatusCode("INQUEUE");
			}
		}*/
		
		connectionsUtil.closeConnection(conn);
		
		//System.out.println("orderData===>" + orderData.toString());
		
		return orderData;
	}
	
	public OrderData getPrintOrderData(Integer tableId, String userId, Integer orderId) throws SQLException{
		
		ConnectionsUtil connectionsUtil = new ConnectionsUtil();
		Connection conn = connectionsUtil.getConnection();
		
		int count = 0;
		ResultSet dataRS = null;
		String query = "";
		OrderData orderData = new OrderData();
		
		if(tableId != null || orderId != null){
		
		query = "select o.order_id,o.order_sequence, om.order_menu_map_id , msm.main_sub_menu_map_id, sum(om.quantity) quantity, om.unit_price unit_price, "+
						"sum(om.order_price) order_price, sm.menu_name, om.notes, s.status_code, o.waiter_id, "+ 
						"o.customer_name, o.mobile_number, o.customer_address, o.tax, o.advance_amt, o.discount_amt, DATE_FORMAT(o.created_on,'%d %b %Y %T') created_on "+
						"from order_master o inner join status_master s on o.status_id = s.status_id ";
		
		if(tableId != null){
			query += "and s.status_code = 'INQUEUE' and o.table_id = "+ tableId +" ";
		}else if(orderId != null){
			query += "and o.order_id = "+ orderId +" ";
		}
						
		query += "left join order_menu_map om on o.order_id = om.order_id and om.is_active = 1 "+
				"left join main_sub_menu_map msm on msm.main_sub_menu_map_id = om.main_sub_menu_map_id "+
				"left join main_menu_master mm on mm.main_menu_id = msm.main_menu_id "+
				"left join sub_menu_master sm on msm.sub_menu_id = sm.sub_menu_id group by om.main_sub_menu_map_id";
		//System.out.println("query==>" + query);
		
		dataRS = conn.createStatement().executeQuery(query);
		
		OrderMenu orderMenu;
		List<OrderMenu> orderMenus = new ArrayList<OrderMenu>();
		
		while(dataRS.next()){
			if(count == 0){
				orderData.setOrderId(dataRS.getInt("order_id"));
				orderData.setOrder_sequence(dataRS.getString("order_sequence"));
				orderData.setStatusCode(dataRS.getString("status_code"));
				orderData.setWaiterName(dataRS.getString("waiter_id"));
				orderData.setCustName(dataRS.getString("customer_name"));
				orderData.setMobileNumber(dataRS.getString("mobile_number"));
				orderData.setCustAddress(dataRS.getString("customer_address"));
				orderData.setTaxRate(dataRS.getFloat("tax"));
				orderData.setAdvanceAmt(dataRS.getFloat("advance_amt"));
				orderData.setDiscountAmt(dataRS.getFloat("discount_amt"));
				orderData.setDateTime(dataRS.getString("created_on"));
			}
			
			if(dataRS.getString("main_sub_menu_map_id") != null){
				orderMenu = new OrderMenu();
				orderMenu.setMainSubMenuMapId(dataRS.getInt("main_sub_menu_map_id"));
				orderMenu.setOrderMenuMapId(dataRS.getInt("order_menu_map_id"));
				orderMenu.setQuantity(dataRS.getInt("quantity"));
				orderMenu.setUnitPrice(dataRS.getFloat("unit_price"));
				orderMenu.setFinalPrice(dataRS.getFloat("order_price"));
				orderMenu.setNotes(dataRS.getString("notes"));
				orderMenu.setSubMenuName(dataRS.getString("menu_name"));
				
				orderMenus.add(orderMenu);
				orderData.setSelectedMenus(orderMenus);
			}
			count ++;
		}
		}
			
		connectionsUtil.closeConnection(conn);
		
		
		return orderData;
	}
	
	public List<Cooking> getOrderedMenus(String data) throws SQLException{
		
		ConnectionsUtil connectionsUtil = new ConnectionsUtil();
		Connection conn = connectionsUtil.getConnection();
		
		/*JsonParser jsonParser = new JsonParser();
		JsonObject jsonObject = (JsonObject)jsonParser.parse(data);*/
		
		JsonObject jsonObject  = Utils.getJSONObjectFromString(data);
		
		String timestamp = jsonObject.get("timestamp").getAsString();
		String statusCode = jsonObject.get("statusCode").getAsString();
		
		String query = "select o.order_id,o.order_sequence, sm.menu_name, om.quantity, om.order_menu_map_id, om.created_on, "+
				 		"tm.table_name, om.notes, sm.is_veg  from order_master o "+ 
						"inner join order_menu_map om on o.order_id = om.order_id and om.is_active = 1 " ;
		
				 		if(timestamp != null && !timestamp.equals("")){
				 			query += "and om.created_by >= '" + timestamp + "' ";
				 		}
						 
				 		query += "inner join status_master s on om.status_id = s.status_id and status_code = '"+statusCode+"' "+
						"inner join main_sub_menu_map msm on msm.main_sub_menu_map_id = om.main_sub_menu_map_id "+
						"inner join sub_menu_master sm on sm.sub_menu_id = msm.sub_menu_id "+
						"Left Outer JOIN table_type_name_map ttn on ttn.table_type_name_map_id = o.table_id "+
						"Left Outer JOIN table_master tm on tm.table_id = ttn.table_id order by om.created_on asc";
				 		
				 		//System.out.println("query==>" + query);
				 		
				 		ResultSet dataRS = conn.createStatement().executeQuery(query);
				 		Cooking cooking;
				 		OrderData orderData;
				 		
				 		List<Cooking> orderedMenus = new ArrayList<Cooking>();
				 		while(dataRS.next()){
				 			cooking = new Cooking();
				 			orderData = new OrderData();
				 			
				 			orderData.setOrderId(dataRS.getInt("order_id"));
				 			orderData.setTableName(dataRS.getString("table_name"));
				 			
				 			cooking.setOrderMenuMapId(dataRS.getInt("order_menu_map_id"));
				 			cooking.setSubMenuName(dataRS.getString("menu_name"));
				 			cooking.setCreatedOn(dataRS.getString("created_on"));
				 			cooking.setQuantity(dataRS.getInt("quantity"));
				 			cooking.setNotes(dataRS.getString("notes"));
				 			cooking.setVeg(dataRS.getBoolean("is_veg"));
				 			
				 			cooking.setOrderData(orderData);				 			
				 			orderedMenus.add(cooking);
				 		}
				 		
		
		connectionsUtil.closeConnection(conn);
		
		return orderedMenus;
	}

	public Integer updateCookingStatus(String data) throws SQLException{
		
		ConnectionsUtil connectionsUtil = new ConnectionsUtil();
		Connection conn = connectionsUtil.getConnection();
		
		/*JsonParser jsonParser = new JsonParser();
		JsonObject jsonObject = (JsonObject)jsonParser.parse(data);*/
		
		JsonObject jsonObject  = Utils.getJSONObjectFromString(data);
		
		String operation = jsonObject.get("operation").getAsString();
		Integer orderMenuMapId = jsonObject.get("orderMenuMapId").getAsInt();
		
		String statusCode = operation.equals("Cook") ? "COOKING" : "COMPLETED";
		
		String query = "update order_menu_map set status_id = (select status_id from status_master where status_code = ?) "+
					   "where order_menu_map_id = ?";

		PreparedStatement psmt = conn.prepareStatement(query);
		
		psmt.setString(1,statusCode);
		psmt.setInt(2, orderMenuMapId);
		
		psmt.executeUpdate();
		
		connectionsUtil.closeConnection(conn);
		
		return 0;
	}

	public Integer checkoutOrder(String data) throws SQLException{
		
		ConnectionsUtil connectionsUtil = new ConnectionsUtil();
		Connection conn = connectionsUtil.getConnection();
		
		Integer returnVal = 0;
		
		/*JsonParser jsonParser = new JsonParser();
		JsonObject jsonObject = (JsonObject)jsonParser.parse(data);*/
		
		JsonObject jsonObject  = Utils.getJSONObjectFromString(data);
		
		Integer orderId = jsonObject.get("orderId").getAsInt();
		
		String query = "select * from order_menu_map om "+
						"inner join status_master s on om.status_id = s.status_id and status_code in('INQUEUE','COOKING') " +
						"and om.order_id = ?";
		
		PreparedStatement psmt = conn.prepareStatement(query);
		psmt.setInt(1, orderId);
		
		ResultSet dataRS = psmt.executeQuery();
		if(dataRS.next()){
			returnVal = 2;
		}
		
		if(returnVal != 2){
			query = "update order_master set status_id = (select status_id from status_master where status_code = ?) "+
					   "where order_id = ?";
			psmt = conn.prepareStatement(query);
			
			psmt.setString(1,"COMPLETED");
			psmt.setInt(2, orderId);
			
			psmt.executeUpdate();
		}
		
		connectionsUtil.closeConnection(conn);
		return returnVal;
	}
	
	public Integer checkIfMenuProcessed(String data) throws SQLException{
		
		ConnectionsUtil connectionsUtil = new ConnectionsUtil();
		Connection conn = connectionsUtil.getConnection();
		
		Integer returnVal = 0;
		/*JsonParser jsonParser = new JsonParser();
		JsonObject jsonObject = (JsonObject)jsonParser.parse(data);*/
		
		JsonObject jsonObject  = Utils.getJSONObjectFromString(data);
		
		Integer orderMenuMapId = jsonObject.get("orderMenuMapId").getAsInt();
		
		String query = "select * from order_menu_map om "+
						"inner join status_master s on om.status_id = s.status_id and status_code not in('INQUEUE') " +
						"and om.order_menu_map_id = ?";
		
		PreparedStatement psmt = conn.prepareStatement(query);
		psmt.setInt(1, orderMenuMapId);
		
		ResultSet dataRS = psmt.executeQuery();
		if(dataRS.next()){
			returnVal = 2;
		}
		
		connectionsUtil.closeConnection(conn);
		
		return returnVal;
	}
	
	public Integer deleteRecord(String data) throws SQLException {

		ConnectionsUtil connectionsUtil = new ConnectionsUtil();
		Connection conn = connectionsUtil.getConnection();

		boolean isSystemCookable = false;
		String status = "";
		
		Integer returnVal = 0;

		JsonObject jsonObject = Utils.getJSONObjectFromString(data);

		Integer orderMenuMapId = jsonObject.get("orderMenuMapId").getAsInt();

		if (isSystemCookable){
			status ="'COOKING'";
		}else{
			
			if(jsonObject.get("cookable").getAsBoolean()){
				status ="INQUEUE";
			}else{
				status ="COOKING','COMPLETED";
			}								
		}
		
		
		String query = "select * from order_menu_map om "
				+ "inner join status_master s on om.status_id = s.status_id and status_code not in('"+status+"') "
				+ "and om.order_menu_map_id = ?";

		PreparedStatement psmt = conn.prepareStatement(query);
		psmt.setInt(1, orderMenuMapId);

		ResultSet dataRS = psmt.executeQuery();
		if (dataRS.next()) {
			returnVal = 2;
		}
		
		if(returnVal != 2){
			//query = "update order_menu_map set is_active = 0 where order_menu_map_id = ?";
			query = "delete from order_menu_map where order_menu_map_id = ?";
			psmt = conn.prepareStatement(query);
			psmt.setInt(1, orderMenuMapId);
			
			psmt.executeUpdate();
		}

		connectionsUtil.closeConnection(conn);
		return returnVal;
	}
	
	public Integer cancelRecord(String data) throws SQLException {

		ConnectionsUtil connectionsUtil = new ConnectionsUtil();
		Connection conn = connectionsUtil.getConnection();

		Integer returnVal = 0;
		
		boolean isSystemCookable = false;
		String status = "";
		
		/*
		 * JsonParser jsonParser = new JsonParser(); JsonObject jsonObject =
		 * (JsonObject)jsonParser.parse(data);
		 */

		JsonObject jsonObject = Utils.getJSONObjectFromString(data);

		Integer orderId = jsonObject.get("orderId").getAsInt();
		
			
		status ="INQUEUE";
		
		String query = "select * from order_menu_map om "
				+ "inner join status_master s on om.status_id = s.status_id and status_code not in ('"+status+"') "
				+ "and om.order_id = ?";

		PreparedStatement psmt = conn.prepareStatement(query);
		psmt.setInt(1, orderId);

		ResultSet dataRS = psmt.executeQuery();
		if (dataRS.next()) {
			returnVal =  2;
		}
		
		if(returnVal != 2){
			query = "update order_master o "+
					"left join order_menu_map om on o.order_id = om.order_id "+
					"set om.status_id = (select status_id from status_master where status_code = ?) , "+
					"o.status_id = (select status_id from status_master where status_code = ?) where o.order_id = ?";

			psmt = conn.prepareStatement(query);
			
			psmt.setString(1,"CANCELLED");
			psmt.setString(2,"CANCELLED");
			psmt.setInt(3, orderId);
			
			psmt.executeUpdate();
		}
		
		connectionsUtil.closeConnection(conn);
		return returnVal;
	}
	
	public List<OrderData> getAllOrders(String fromDate, String toDate, Integer deliveryPersonId) throws SQLException{
		
		ConnectionsUtil connectionsUtil = new ConnectionsUtil();
		Connection conn = connectionsUtil.getConnection();
		
		String query = "select o.order_id,o.order_sequence, o.created_on, t.table_name, s.status_code, s.status_name, "+
						"customer_name, o.mobile_number,customer_address, concat(wfirst_name, ' ',wmiddle_name, ' ', wlast_name) as waiter_name, "+
						"dt.delivery_tracker_id, dt.delivery_person_id, dt.status_id as deliveryStatus, st.status_name as dStatusName " +
						"from order_master o "+
						"inner join status_master s on o.status_id = s.status_id and o.created_on between ? AND ? "+
						"left join table_type_name_map ttn on o.table_id = ttn.table_type_name_map_id "+
						"left join table_master t on ttn.table_id = t.table_id "+
						"left join waiter_master w on o.waiter_id = w.waiter_id "+
						"left join delivery_tracker dt on o.order_id = dt.order_id "+
						"left join user_master dp on dp.user_id = dt.delivery_person_id "+
						"left join status_master st on st.status_id = dt.status_id ";
						if(deliveryPersonId != null){
							query += " where dt.delivery_person_id = "+ deliveryPersonId + " and st.status_code = 'INDELIVERY' ";
						}
		
						query += " order by o.order_id desc; ";
		
		PreparedStatement psmt = conn.prepareStatement(query);
		psmt.setString(1, fromDate + " 00:00:00");
		psmt.setString(2, toDate + " 23:59:59");
		
		ResultSet dataRS = psmt.executeQuery();
		
		OrderData orderData = new OrderData();
		DeliveryTracker deliveryTracker = null;
		User deliveryPerson = null;
		Status deliveryStatus = null;
		
		List<OrderData> orderList = new ArrayList<OrderData>();
		
		while(dataRS.next()){
			orderData = new OrderData();
			
			deliveryPerson = new User();
			deliveryPerson.setId(dataRS.getInt("delivery_person_id"));
			
			deliveryTracker = new DeliveryTracker();
			deliveryTracker.setDeliveryTrackerId(dataRS.getInt("delivery_tracker_id"));
			
			deliveryStatus = new Status();
			deliveryStatus.setStatusId(dataRS.getInt("deliveryStatus"));
			deliveryStatus.setStatusName(dataRS.getString("dStatusName"));
			
			orderData.setOrderId(dataRS.getInt("order_id"));
			orderData.setOrder_sequence(dataRS.getString("order_sequence"));
			orderData.setStatusCode(dataRS.getString("status_code"));
			orderData.setStatusName(dataRS.getString("status_name"));
			orderData.setCustName(dataRS.getString("customer_name"));
			orderData.setMobileNumber(dataRS.getString("mobile_number"));
			orderData.setDateTime(dataRS.getString("created_on"));
			orderData.setWaiterName(dataRS.getString("waiter_name"));
			orderData.setTableName(dataRS.getString("table_name"));
			
			orderData.setDeliveryTracker(deliveryTracker);
			
			orderList.add(orderData);
		}
		
		connectionsUtil.closeConnection(conn);
		
		return orderList;
	}
	
	public List<Customer> getCustomerData() throws SQLException{
		
		ConnectionsUtil connectionsUtil = new ConnectionsUtil();
		Connection conn = connectionsUtil.getConnection();
		
		String query = "select * from order_master where customer_name is not null and mobile_number is not null "+
						"group by lower(customer_address), mobile_number order by customer_name;";
		
		ResultSet dataRS = conn.createStatement().executeQuery(query);
		
		Customer customer;
		List<Customer> customerList = new ArrayList<Customer>();
		while(dataRS.next()){
			customer = new Customer();
			
			customer.setCustName(dataRS.getString("customer_name"));
			customer.setMobile(dataRS.getString("mobile_number"));
			customer.setCustAddress(dataRS.getString("customer_address"));
			
			customerList.add(customer);
		}
		
		connectionsUtil.closeConnection(conn);
		return customerList;
	}
	
	public Integer updateCustomerInOrder(String data) throws SQLException {

		ConnectionsUtil connectionsUtil = new ConnectionsUtil();
		Connection conn = connectionsUtil.getConnection();

		Integer returnVal = 0;
		JsonObject jsonObject = Utils.getJSONObjectFromString(data);

		Integer orderId = jsonObject.get("orderId").getAsInt();
		String custName = jsonObject.get("custName").getAsString();
		String custAddress = jsonObject.get("custAddress").getAsString();
		String mobile = jsonObject.get("mobile").getAsString();

		String query = "update order_master o set customer_name = ?, mobile_number = ?, customer_address = ? "+
						"where o.order_id = ?";

		PreparedStatement psmt = conn.prepareStatement(query);
		psmt.setString(1, custName);
		psmt.setString(2, mobile);
		psmt.setString(3, custAddress);
		psmt.setInt(4, orderId);
		
		psmt.executeUpdate();
		
		connectionsUtil.closeConnection(conn);
		
		return returnVal;
	}
	
	public List<Waiter> getWaiterList() throws SQLException{
		
		ConnectionsUtil connectionsUtil = new ConnectionsUtil();
		Connection conn = connectionsUtil.getConnection();
		
		String query = "select * from waiter_master where is_active = 1";
		ResultSet dataRS = conn.createStatement().executeQuery(query);
		
		List<Waiter> waiterList = new ArrayList<Waiter>();
		Waiter waiter = null;
		String waiterName ;
		while(dataRS.next()){
			waiter = new Waiter();
			
			waiterName = Utils.getString(dataRS.getString("wfirst_name")) + " ";
			waiterName += Utils.getString(dataRS.getString("wmiddle_name")) + " ";
			waiterName += Utils.getString(dataRS.getString("wlast_name"));
			
			waiterName = waiterName.trim();
			
			waiter.setWaiterName(waiterName);
			waiter.setWaiterId(dataRS.getInt("waiter_id"));
			
			waiterList.add(waiter);
		}
		
		
		return waiterList;
		
	}

	public List<User> getDeliveryPersonList(Boolean isActive) throws SQLException{
		
		ConnectionsUtil connectionsUtil = new ConnectionsUtil();
		Connection conn = connectionsUtil.getConnection();
		
		String query = "select * from user_master ";
		if(isActive){
			query += " where is_active = 1";
		}
		
		ResultSet dataRS = conn.createStatement().executeQuery(query);
		
		List<User> deliveryPersonList = new ArrayList<User>();
		User deliveryPerson = null;

		while(dataRS.next()){
			
			deliveryPerson = new User();
			
			deliveryPerson.setId(dataRS.getInt("user_id"));
			deliveryPerson.setFirstName(Utils.getString(dataRS.getString("first_name")));
			deliveryPerson.setMiddleName(Utils.getString(dataRS.getString("middle_name")));
			deliveryPerson.setLastName(Utils.getString(dataRS.getString("last_name")));
			deliveryPerson.setEmailAddress(dataRS.getString("email"));
			//deliveryPerson.setAddress(dataRS.getString("address"));
			//deliveryPerson.setContactNumber(dataRS.getString("mobile_number"));
			
			deliveryPersonList.add(deliveryPerson);
		}
		return deliveryPersonList;
		
	}
	
	
public List<DeliveryTracker> getDeliveryTrackers(Integer deliveryTrackerId) throws SQLException{
		
		ConnectionsUtil connectionsUtil = new ConnectionsUtil();
		Connection conn = connectionsUtil.getConnection();
		
		String query = "select * from delivery_tracker dt "+
					"inner join user_master dp on dt.delivery_person_id = dp.user_id ";
				
				if(deliveryTrackerId != null){
					query += " and dt.delivery_tracker_id = " + deliveryTrackerId;
				}
					
		query += " inner join status_master s on s.status_id = dt.status_id order by dt.created_on";
		
		ResultSet dataRS = conn.createStatement().executeQuery(query);
		
		List<DeliveryTracker> trackerList = new ArrayList<DeliveryTracker>();
		DeliveryTracker tracker = null;
		User deliveryPerson;
		Status deliveryStatus;

		while(dataRS.next()){
			deliveryPerson = new User();
			tracker = new DeliveryTracker();
			deliveryStatus = new Status();
			
			deliveryPerson.setId(Utils.getInt(dataRS.getInt("delivery_person_id")));
			deliveryPerson.setFirstName(Utils.getString(dataRS.getString("first_name")));
			deliveryPerson.setMiddleName(Utils.getString(dataRS.getString("middle_name")));
			deliveryPerson.setLastName(Utils.getString(dataRS.getString("last_name")));
			
			deliveryStatus.setStatusId(dataRS.getInt("status_id"));
			deliveryStatus.setStatusCode(dataRS.getString("status_code"));
			deliveryStatus.setStatusName(dataRS.getString("status_name"));
			
			tracker.setDeliveryTrackerId(dataRS.getInt("delivery_tracker_id"));
			tracker.setDelieveryPerson(deliveryPerson);
			tracker.setDeliveryStatus(deliveryStatus);
			tracker.setCreatedBy(dataRS.getInt("dt.created_by"));
			tracker.setCreatedOn(dataRS.getString("dt.created_on"));
			tracker.setIsActive(dataRS.getBoolean("dt.is_active"));

			trackerList.add(tracker);
		}
		return trackerList;
	}

public Integer addDeliveryPerson(String data, String userId) throws SQLException{
	
	
	ConnectionsUtil connectionsUtil = new ConnectionsUtil();
	Connection conn = connectionsUtil.getConnection();
	
	JsonObject jsonObject = Utils.getJSONObjectFromString(data);

	Integer orderId = jsonObject.get("orderId").getAsInt();
	Integer deliveryPersonId = jsonObject.get("deliveryPersonId").getAsInt();
	Integer deliveryTrackerId = jsonObject.get("deliveryTrackerId").getAsInt();
	
	String query = "";
	PreparedStatement psmt;
	
	if(deliveryTrackerId == 0){

	query = "insert into delivery_tracker(order_id, delivery_person_id, status_id, created_by) "+
					"values(?, ?, (select status_id from status_master where status_code = 'INDELIVERY'), ?)";
	
	psmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
	
	psmt.setInt(1, orderId);
	psmt.setInt(2, deliveryPersonId);
	psmt.setString(3, userId);
	psmt.executeUpdate();
	
	}else{
		query = "update delivery_tracker set delivery_person_id = ?, created_by = ? where delivery_tracker_id = ?";
		
		psmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
		
		psmt.setInt(1, deliveryPersonId);
		psmt.setString(2, userId);
		psmt.setInt(3, deliveryTrackerId);
		
		psmt.executeUpdate();
	}
	return 0;
}

public Integer updateDeliveryStatus(String data, String userId) throws SQLException{
	
	
	ConnectionsUtil connectionsUtil = new ConnectionsUtil();
	Connection conn = connectionsUtil.getConnection();
	
	JsonObject jsonObject = Utils.getJSONObjectFromString(data);

	Integer deliveryTrackerId = jsonObject.get("deliveryTrackerId").getAsInt();
	
	String query = "update delivery_tracker set status_id = (select status_id from status_master where status_code = 'DELIVERED'),  "+
					"created_by = ? where delivery_tracker_id = ?";
	
	PreparedStatement psmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
	
	psmt.setString(1, userId);
	psmt.setInt(2, deliveryTrackerId);
	
	psmt.executeUpdate();
	
	return 0;
}



}
