package com.org.agritadka.master;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;

import com.google.gson.JsonObject;
import com.org.agritadka.generic.ConnectionsUtil;
import com.org.agritadka.generic.Utils;
import com.org.agritadka.transfer.MainMenu;
import com.org.agritadka.transfer.MenuMapper;
import com.org.agritadka.transfer.SubMenu;

public class Master {
	
	public List<MainMenu> getAllMainMenus(boolean onlyActive) throws SQLException{
		
		ConnectionsUtil connectionsUtil = new ConnectionsUtil();
		Connection conn = connectionsUtil.getConnection();
		
		String query = "select * from main_menu_master ";
		if(onlyActive){
			query += "where is_active = 1";
		}
		
		ResultSet dataRS = conn.createStatement().executeQuery(query);
		List<MainMenu> mainMenuList = new ArrayList<MainMenu>();
		MainMenu mainMenu = null;
		
		while(dataRS.next()){
			mainMenu = new MainMenu();
			
			mainMenu.setMainMenuId(dataRS.getInt("main_menu_id"));
			mainMenu.setMainMenuName(dataRS.getString("menu_name"));
			mainMenu.setVeg(dataRS.getBoolean("is_veg"));
			mainMenu.setMenuDescription(Utils.getString(dataRS.getString("menu_description")));
			mainMenu.setActive(dataRS.getBoolean("is_active"));
			
			
			mainMenuList.add(mainMenu);
		}
		
		return mainMenuList;
	}
	
	public MainMenu getMainMenu(Integer mainMenuId) throws SQLException{
		ConnectionsUtil connectionsUtil = new ConnectionsUtil();
		Connection conn = connectionsUtil.getConnection();
		
		String query = "select * from main_menu_master where main_menu_id = ?";
		
		PreparedStatement psmt = conn.prepareStatement(query);
		psmt.setInt(1, mainMenuId);
				
		ResultSet dataRS = psmt.executeQuery();
		MainMenu mainMenu = null;
		
		while(dataRS.next()){
			mainMenu = new MainMenu();
			
			mainMenu.setMainMenuId(dataRS.getInt("main_menu_id"));
			mainMenu.setMainMenuName(dataRS.getString("menu_name"));
			mainMenu.setVeg(dataRS.getBoolean("is_veg"));
			mainMenu.setMenuDescription(Utils.getString(dataRS.getString("menu_description")));
			mainMenu.setActive(dataRS.getBoolean("is_active"));
			
		}
		
		connectionsUtil.closeConnection(dataRS);
		return mainMenu;
	}
	
	public SubMenu getSubMenu(Integer subMenuId) throws SQLException{
		ConnectionsUtil connectionsUtil = new ConnectionsUtil();
		Connection conn = connectionsUtil.getConnection();
		
		String query = "select * from sub_menu_master where sub_menu_id = ?";
		
		PreparedStatement psmt = conn.prepareStatement(query);
		psmt.setInt(1, subMenuId);
				
		ResultSet dataRS = psmt.executeQuery();
		SubMenu subMenu = null;
		
		while(dataRS.next()){
			subMenu = new SubMenu();
			
			subMenu.setSubMenuId(dataRS.getInt("sub_menu_id"));
			subMenu.setSubMenuName(dataRS.getString("menu_name"));
			subMenu.setAcUnitPrice(dataRS.getFloat("ac_unit_price"));
			subMenu.setNonAcUnitPrice(dataRS.getFloat("non_ac_unit_price"));
			subMenu.setVeg(dataRS.getBoolean("is_veg"));
			subMenu.setMenuDescription(Utils.getString(dataRS.getString("menu_description")));
			subMenu.setActive(dataRS.getBoolean("is_active"));
			
		}
		
		connectionsUtil.closeConnection(dataRS);
		return subMenu;
	}
	
	public MainMenu insertMainMenu(MainMenu mainMenu, String userId) throws SQLException{
		ConnectionsUtil connectionsUtil = new ConnectionsUtil();
		Connection conn = connectionsUtil.getConnection();
		
		String query = "insert into main_menu_master(menu_name, menu_description, is_veg, is_active, created_by) values(?,?,?,?,?)";
		
		PreparedStatement psmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
		
		
		psmt.setString(1, mainMenu.getMainMenuName());
		psmt.setString(2, mainMenu.getMenuDescription());
		psmt.setBoolean(3, mainMenu.isVeg());
		psmt.setBoolean(4, mainMenu.isActive());
		psmt.setString(5, userId);
		
		psmt.executeUpdate();
		
		ResultSet dataRS = psmt.getGeneratedKeys();
		if(dataRS.next()){
			mainMenu.setMainMenuId(dataRS.getInt(1));
		}
		
		connectionsUtil.closeConnection(dataRS);
		
		return mainMenu;
	}
	
	public SubMenu insertSubMenu(SubMenu subMenu, String userId) throws SQLException{
		ConnectionsUtil connectionsUtil = new ConnectionsUtil();
		Connection conn = connectionsUtil.getConnection();
		
		String query = "insert into sub_menu_master(menu_name, menu_description, is_veg,non_ac_unit_price,ac_unit_price, is_active, created_by) values(?,?,?,?,?,?,?)";
		
		PreparedStatement psmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
		
		
		psmt.setString(1, subMenu.getSubMenuName());
		psmt.setString(2, subMenu.getMenuDescription());
		psmt.setBoolean(3, subMenu.isVeg());
		psmt.setFloat(4, subMenu.getNonAcUnitPrice());
		psmt.setFloat(5,subMenu.getAcUnitPrice());
		psmt.setBoolean(6, subMenu.isActive());
		psmt.setString(7, userId);
		
		psmt.executeUpdate();
		
		ResultSet dataRS = psmt.getGeneratedKeys();
		if(dataRS.next()){
			subMenu.setSubMenuId(dataRS.getInt(1));
		}
		
		connectionsUtil.closeConnection(dataRS);
		
		return subMenu;
	}
	
	public MainMenu updateMainMenu(MainMenu mainMenu, String userId) throws SQLException{
		ConnectionsUtil connectionsUtil = new ConnectionsUtil();
		Connection conn = connectionsUtil.getConnection();
		
		String query = "update main_menu_master set menu_name = ?, menu_description = ?, is_veg =  ?, is_active = ?, created_by = ? where main_menu_id = ?";
		
		PreparedStatement psmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
		
		
		psmt.setString(1, mainMenu.getMainMenuName());
		psmt.setString(2, mainMenu.getMenuDescription());
		psmt.setBoolean(3, mainMenu.isVeg());
		psmt.setBoolean(4, mainMenu.isActive());
		psmt.setString(5, userId);
		psmt.setInt(6, mainMenu.getMainMenuId());
		
		psmt.executeUpdate();
		
		connectionsUtil.closeConnection(conn);
		
		return mainMenu;
	}
	
	
	public SubMenu updateSubMenu(SubMenu subMenu, String userId) throws SQLException{
		ConnectionsUtil connectionsUtil = new ConnectionsUtil();
		Connection conn = connectionsUtil.getConnection();
		
		String query = "update sub_menu_master set menu_name = ?, menu_description = ?, is_veg =  ?,non_ac_unit_price=?,ac_unit_price=?, is_active = ?, created_by = ? where sub_menu_id = ?";
		
		PreparedStatement psmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
		
		
		psmt.setString(1, subMenu.getSubMenuName());
		psmt.setString(2, subMenu.getMenuDescription());
		psmt.setBoolean(3, subMenu.isVeg());
		psmt.setFloat(4, subMenu.getNonAcUnitPrice());
		psmt.setFloat(5, subMenu.getAcUnitPrice());
		psmt.setBoolean(6, subMenu.isActive());
		psmt.setString(7, userId);
		psmt.setInt(8, subMenu.getSubMenuId());
		
		psmt.executeUpdate();
		connectionsUtil.closeConnection(conn);
		
		return subMenu;
	}
	
	
public List<SubMenu> getAllSubMenus(boolean onlyActive) throws SQLException{
		
		ConnectionsUtil connectionsUtil = new ConnectionsUtil();
		Connection conn = connectionsUtil.getConnection();
		
		String query = "select * from sub_menu_master ";
		if(onlyActive){
			query += "where is_active = 1";
		}
		
		query += "order by menu_name";
		
		ResultSet dataRS = conn.createStatement().executeQuery(query);
		List<SubMenu> subMenuList = new ArrayList<SubMenu>();
		SubMenu subMenu = null;
		
		while(dataRS.next()){
			subMenu = new SubMenu();
			
			subMenu.setSubMenuId(dataRS.getInt("sub_menu_id"));
			subMenu.setSubMenuName(dataRS.getString("menu_name"));
			subMenu.setVeg(dataRS.getBoolean("is_veg"));
			subMenu.setMenuDescription(Utils.getString(dataRS.getString("menu_description")));
			subMenu.setActive(dataRS.getBoolean("is_active"));
			subMenu.setAcUnitPrice(dataRS.getFloat("ac_unit_price"));
			subMenu.setNonAcUnitPrice(dataRS.getFloat("non_ac_unit_price"));
			
			subMenuList.add(subMenu);
		}
		
		return subMenuList;
	}
	
public List<MenuMapper> getMenuMappings(boolean onlyActive) throws SQLException{
		
		ConnectionsUtil connectionsUtil = new ConnectionsUtil();
		Connection conn = connectionsUtil.getConnection();
		
		String query = "SELECT ms.main_sub_menu_map_id, m.main_menu_id, s.sub_menu_id, s.menu_description, " +
				"m.menu_name as main_menu, s.menu_name as sub_menu, s.ac_unit_price, s.non_ac_unit_price, s.is_veg, s.is_active "+
				"FROM main_sub_menu_map ms "+
				"inner join main_menu_master m on m.main_menu_id = ms.main_menu_id and ms.is_active = 1 and m.is_active = 1 "+
				"inner join sub_menu_master s on s.sub_menu_id = ms.sub_menu_id ";
				if(onlyActive){
					query += " and s.is_active = 1 ";
				}
				query += " order by m.menu_name, s.menu_name";
		ResultSet dataRS = conn.createStatement().executeQuery(query);
		List<MenuMapper> menuMapperList = new ArrayList<MenuMapper>();
		MenuMapper menuMapper = null;
		MainMenu mainMenu = null;
		SubMenu subMenu = null;
		
		while(dataRS.next()){
			menuMapper = new MenuMapper();
			mainMenu = new MainMenu();
			subMenu = new SubMenu();
			
			menuMapper.setMainSubMenuId(dataRS.getInt("main_sub_menu_map_id"));
			
			mainMenu.setMainMenuId(dataRS.getInt("main_menu_id"));
			mainMenu.setMainMenuName(dataRS.getString("main_menu"));
			
			subMenu.setSubMenuId(dataRS.getInt("sub_menu_id"));
			subMenu.setSubMenuName(dataRS.getString("sub_menu"));
			subMenu.setVeg(dataRS.getBoolean("is_veg"));
			subMenu.setMenuDescription(Utils.getString(dataRS.getString("menu_description")));
			subMenu.setActive(dataRS.getBoolean("is_active"));
			subMenu.setAcUnitPrice(dataRS.getFloat("ac_unit_price"));
			subMenu.setNonAcUnitPrice(dataRS.getFloat("non_ac_unit_price"));
			
			menuMapper.setMainMenu(mainMenu);
			menuMapper.setSubMenu(subMenu);
			
			menuMapperList.add(menuMapper);
		}
		
		connectionsUtil.closeConnection(dataRS);		
		return menuMapperList;
	}

public List<MenuMapper> getAllSubMenus1(boolean onlyActive) throws SQLException{
	
	ConnectionsUtil connectionsUtil = new ConnectionsUtil();
	Connection conn = connectionsUtil.getConnection();
	
	String query = "SELECT ms.main_sub_menu_map_id, m.main_menu_id, s.sub_menu_id, s.menu_description, " +
			"m.menu_name as main_menu, s.menu_name as sub_menu, s.ac_unit_price, s.non_ac_unit_price, s.is_veg, s.is_active "+
			"FROM main_sub_menu_map ms "+
			"inner join main_menu_master m on m.main_menu_id = ms.main_menu_id and ms.is_active = 1 and m.is_active = 1 "+
			"inner join sub_menu_master s on s.sub_menu_id = ms.sub_menu_id ";
			if(onlyActive){
				query += " and s.is_active = 1 ";
			}
			query += " order by m.menu_name, s.menu_name";
	ResultSet dataRS = conn.createStatement().executeQuery(query);
	List<MenuMapper> menuMapperList = new ArrayList<MenuMapper>();
	MenuMapper menuMapper = null;
	MainMenu mainMenu = null;
	SubMenu subMenu = null;
	
	while(dataRS.next()){
		menuMapper = new MenuMapper();
		mainMenu = new MainMenu();
		subMenu = new SubMenu();
		
		menuMapper.setMainSubMenuId(dataRS.getInt("main_sub_menu_map_id"));
		
		mainMenu.setMainMenuId(dataRS.getInt("main_menu_id"));
		mainMenu.setMainMenuName(dataRS.getString("main_menu"));
		
		subMenu.setSubMenuId(dataRS.getInt("sub_menu_id"));
		subMenu.setSubMenuName(dataRS.getString("sub_menu"));
		subMenu.setVeg(dataRS.getBoolean("is_veg"));
		subMenu.setMenuDescription(Utils.getString(dataRS.getString("menu_description")));
		subMenu.setActive(dataRS.getBoolean("is_active"));
		subMenu.setAcUnitPrice(dataRS.getFloat("ac_unit_price"));
		subMenu.setNonAcUnitPrice(dataRS.getFloat("non_ac_unit_price"));
		
		menuMapper.setMainMenu(mainMenu);
		menuMapper.setSubMenu(subMenu);
		
		menuMapperList.add(menuMapper);
	}
	
	connectionsUtil.closeConnection(dataRS);		
	return menuMapperList;
}


public Integer inactiveMenuMapping(String data, String userId) throws SQLException {

	ConnectionsUtil connectionsUtil = new ConnectionsUtil();
	Connection conn = connectionsUtil.getConnection();

	Integer returnVal = 0;
	JsonObject jsonObject = Utils.getJSONObjectFromString(data);

	Integer mainSubMenuId = jsonObject.get("mainSubMenuId").getAsInt();
	
	String query = "update main_sub_menu_map o set is_active = ?, created_by = ?"+
					"where o.main_sub_menu_map_id = ?";

	PreparedStatement psmt = conn.prepareStatement(query);
	psmt.setInt(1, 0);
	psmt.setString(2, userId);
	psmt.setInt(3, mainSubMenuId);
	
	psmt.executeUpdate();
	
	connectionsUtil.closeConnection(conn);
	
	return returnVal;
}

public Integer addSubMenu(String data, String userId) throws SQLException {

	ConnectionsUtil connectionsUtil = new ConnectionsUtil();
	Connection conn = connectionsUtil.getConnection();

	Integer mainSubMenuId = 0;
	JsonObject jsonObject = Utils.getJSONObjectFromString(data);

	Integer mainMenuId = jsonObject.get("mainMenuId").getAsInt();
	Integer subMenuId = jsonObject.get("subMenuId").getAsInt();
	
	String query = "select * from main_sub_menu_map where main_menu_id = ? and sub_menu_id = ?";
	PreparedStatement psmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);	
	psmt.setInt(1, mainMenuId);
	psmt.setInt(2, subMenuId);
	
	ResultSet dataRS = psmt.executeQuery();
	
	if(dataRS.next()){
		mainSubMenuId = dataRS.getInt("main_sub_menu_map_id");
		
		query = "update main_sub_menu_map o set is_active = ?, created_by = ?"+
				"where main_sub_menu_map_id = ?";

		psmt = conn.prepareStatement(query);
		
		psmt.setInt(1, 1);
		psmt.setString(2, userId);
		psmt.setInt(3, mainSubMenuId);
		
		psmt.executeUpdate();
		
	}else{
		
		query = "insert into main_sub_menu_map(main_menu_id, sub_menu_id, created_by) values(?,?,?)";
		
		psmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
		
		psmt.setInt(1, mainMenuId);
		psmt.setInt(2, subMenuId);
		psmt.setString(3, userId);
		
		psmt.executeUpdate();
		
		dataRS = psmt.getGeneratedKeys();

		if (dataRS.next()) {
			mainSubMenuId = dataRS.getInt(1);
		}
	}
	
	connectionsUtil.closeConnection(conn);
	
	return mainSubMenuId;
}

public LinkedHashMap<MainMenu, List<MenuMapper>> getMenus(String priceType) throws SQLException{
	
	ConnectionsUtil connectionsUtil = new ConnectionsUtil();
	Connection conn = connectionsUtil.getConnection();
	
	String query = "SELECT ms.main_sub_menu_map_id, m.main_menu_id, s.sub_menu_id, " +
					"m.menu_name as main_menu, s.menu_name as sub_menu, s."+ priceType +"_unit_price as unit_price, s.is_veg "+
					"FROM main_menu_master m "+
					"inner join (select * from main_menu_master mm where is_active = 1) mm on m.main_menu_id = mm.main_menu_id "+
					"left join main_sub_menu_map ms on m.main_menu_id = ms.main_menu_id and ms.is_active = 1 "+
					"left join (select * from sub_menu_master where is_active = 1) s on s.sub_menu_id = ms.sub_menu_id order by m.menu_name, s.menu_name";
	System.out.println("query==>" + query);
	
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


}
