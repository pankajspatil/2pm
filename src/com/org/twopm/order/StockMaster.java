/**
 * 
 */
package com.org.twopm.order;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Map;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.org.twopm.generic.ConnectionsUtil;

/**
 * @author Patil
 *
 */
public class StockMaster {
	
	public void updateStock(String data, String userId){
		try {

			ConnectionsUtil connectionsUtil = new ConnectionsUtil();
			Connection conn = connectionsUtil.getConnection();

			JsonParser jsonParser = new JsonParser();
			JsonObject jsonObject = (JsonObject) jsonParser.parse(data);
			String query = "update stock_master set quantity = quantity - ? where sub_menu_id = ? ";

			PreparedStatement psmt;
			psmt = conn.prepareStatement(query);

			for (Map.Entry<String, JsonElement> entry : jsonObject.entrySet()) {
				JsonObject jObject = entry.getValue().getAsJsonObject();
				psmt.setInt(1, jObject.get("quantity").getAsInt());
				psmt.setInt(2, jObject.get("menuId").getAsInt());
				psmt.addBatch();
			}// end of for
			
			psmt.executeBatch();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
