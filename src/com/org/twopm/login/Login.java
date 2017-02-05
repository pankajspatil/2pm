package com.org.twopm.login;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.UUID;

import com.org.twopm.generic.ConnectionsUtil;
import com.org.twopm.generic.Constants;
import com.org.twopm.generic.SendEmail;
import com.org.twopm.generic.Utils;

public class Login {

	Connection conn = null;
	ResultSet rs = null;
	ConnectionsUtil connectionsUtil = null;

	public Integer verifyUser(String userName, String password) {

		try {
			connectionsUtil = new ConnectionsUtil();
			conn = connectionsUtil.getConnection();

			String query = "select * from user_master where user_name = ? and password = ?";

			PreparedStatement psm = conn.prepareStatement(query);
			psm.setString(1, userName);
			psm.setString(2, password);

			rs = psm.executeQuery();
			if (rs.next()) {
				return rs.getInt("user_id");
			}

		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			try {
				if (conn != null) {
					conn.close();
				}

			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		rs = null;
		conn = null;

		return 0;
	}

	public Boolean verifyUser(String userName) {

		try {
			connectionsUtil = new ConnectionsUtil();
			conn = connectionsUtil.getConnection();

			String query = "select * from user_master where user_name = ?";

			PreparedStatement psm = conn.prepareStatement(query);
			psm.setString(1, userName);

			rs = psm.executeQuery();
			if (rs.next()) {
				return true;
			}

			connectionsUtil.closeConnection(rs);

		} catch (Exception ex) {
			ex.printStackTrace();
		}

		rs = null;
		conn = null;

		return false;
	}

	public Boolean createNewUser(LinkedHashMap<String, String> paramMap) {

		boolean userCreated = false;
		connectionsUtil = new ConnectionsUtil();
		conn = connectionsUtil.getConnection();

		try {

			String userName = Utils
					.getString(paramMap.get(Constants.USER_NAME));
			String firstName = Utils.getString(paramMap
					.get(Constants.FIRST_NAME));
			String middleName = Utils.getString(paramMap
					.get(Constants.MIDDLE_NAME));
			String lastName = Utils
					.getString(paramMap.get(Constants.LAST_NAME));
			String password = Utils.getString(paramMap.get(Constants.PASSWORD));
			String email = Utils.getString(paramMap.get(Constants.ENT_EMAIL));

			String query = "insert into user_Master(user_name, first_name, middle_name, last_name, password, email) values(?,?,?,?,?,?)";

			PreparedStatement psm = conn.prepareStatement(query);
			psm.setString(1, userName);
			psm.setString(2, firstName);
			psm.setString(3, middleName);
			psm.setString(4, lastName);
			psm.setString(5, password);
			psm.setString(6, email);

			psm.executeUpdate();

			userCreated = true;

			String message = "Hi " + userName + ",<br/><br/>"
					+ "Please note your login details:<br/><br/>"
					+ "<table><tr><td><b>User Name :</b> </td><td>" + userName
					+ "</td></tr>" + "<tr><td><b>Password :</b> </td><td>"
					+ password + "</td></tr>"
					+ "<tr><td><b>Email :</b> </td><td>" + email
					+ "</td></tr> </table><br />"
					+ "You can use these login details to access your account.";
			paramMap = new LinkedHashMap<String, String>();

			paramMap.put(Constants.TO, email);
			paramMap.put(Constants.SUBJECT,
					"Login Details of Project Resource Management");
			paramMap.put(Constants.MESSAGE, message);

			SendEmail sendEmail = new SendEmail();
			try {
				sendEmail.send(paramMap);
			} catch (Exception ex) {
				ex.printStackTrace();
			}

		} catch (Exception ex) {
			ex.printStackTrace();
		}

		rs = null;
		conn = null;

		return userCreated;
	}

	public LinkedHashMap<String, String> getTeams(Integer userId) {
		LinkedHashMap<String, String> userTeamMap = new LinkedHashMap<String, String>();

		try {

			connectionsUtil = new ConnectionsUtil();
			conn = connectionsUtil.getConnection();

			String query = "select tum.team_user_map_id, tm.team_id, tm.team_name from team_user_map tum "
					+ "inner join team_master tm on tm.team_id = tum.team_id "
					+ "where user_id = ?";
			PreparedStatement psmt = conn.prepareStatement(query);
			psmt.setInt(1, userId);

			rs = psmt.executeQuery();
			String teamDetails = "";
			while (rs.next()) {
				teamDetails = rs.getString("team_id") + "##"
						+ rs.getString("team_name");
				userTeamMap.put(rs.getString("team_user_map_id"), teamDetails);
			}

		} catch (Exception ex) {
			ex.printStackTrace();
		}

		connectionsUtil.closeConnection(rs);

		return userTeamMap;
	}

	public void resetPassword(LinkedHashMap<String, String> paramMap) {
		connectionsUtil = new ConnectionsUtil();
		conn = connectionsUtil.getConnection();

		try {

			String userName = paramMap.get(Constants.USER_NAME);
			String query = "select * from user_master where user_name = ?";
			PreparedStatement psmt = conn.prepareStatement(query);

			psmt.setString(1, userName);

			rs = psmt.executeQuery();
			if (rs.next()) {

				String password = (UUID.randomUUID().toString())
						.substring(0, 8);

				query = "update user_master set password = ? where user_id = ?";
				psmt = conn.prepareStatement(query);

				psmt.setString(1, password);
				psmt.setString(2, rs.getString("user_id"));

				psmt.executeUpdate();
				paramMap = new LinkedHashMap<String, String>();

				paramMap.put(Constants.SUBJECT, "abc");

			}

		} catch (Exception ex) {
			ex.printStackTrace();
		}
		connectionsUtil.closeConnection(conn);
	}

	public Integer changePassword(LinkedHashMap<String, String> paramMap) {

		connectionsUtil = new ConnectionsUtil();
		conn = connectionsUtil.getConnection();
		try {

			String currentPassword = paramMap.get(Constants.PASSWORD);
			String newPassword = paramMap.get(Constants.CHANGED_PASSWORD);
			String userId = paramMap.get(Constants.USER_ID);

			String query = "";
			PreparedStatement psmt = null;

			if (!currentPassword.equals("")) {
				query = "select * from user_master where password = ? and user_Id = ?";
				psmt = conn.prepareStatement(query);

				psmt.setString(1, currentPassword);
				psmt.setString(2, userId);

				rs = psmt.executeQuery();

				if (!rs.next()) {
					return 0;
				}
			}
			query = "update user_master set password = ? where user_id = ?";
			psmt = conn.prepareStatement(query);

			psmt.setString(1, newPassword);
			psmt.setString(2, userId);
			// psmt.setString(3, userId);

			psmt.executeUpdate();

			return 1;

		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			connectionsUtil.closeConnection(conn);
		}
		return -1;
	}

	public LinkedHashMap<String, String> sendAuthCode(
			LinkedHashMap<String, String> paramMap) {

		String userName = paramMap.get(Constants.USER_NAME);
		LinkedHashMap<String, String> userDataMap = getEmailAddress(userName);
		String authCode = null;

		if (userDataMap != null) {

			SendEmail sendEmail = new SendEmail();
			authCode = (UUID.randomUUID().toString()).substring(0, 5);

			System.out.println("authCode==>" + authCode);

			String emailAddress = userDataMap.get(Constants.ENT_EMAIL);
			userDataMap.put(Constants.AUTH_CODE, authCode);

			paramMap = new LinkedHashMap<String, String>();
			paramMap.put(Constants.TO, emailAddress);
			paramMap.put(Constants.SUBJECT,
					"Login password generation alert from project resource management");

			String message = "Dear User,<br/>For generating password for project resource management, you will need a unique number.<br/>";
			message += "<b>NEVER SHARE IT WITH ANYONE.</b><br/>";
			message += "The Unique number is : " + authCode;

			paramMap.put(Constants.MESSAGE, message);

			// sendEmail.send(paramMap);

		}
		return userDataMap;
	}

	public LinkedHashMap<String, String> getEmailAddress(String userName) {

		connectionsUtil = new ConnectionsUtil();
		conn = connectionsUtil.getConnection();

		try {

			String query = "select * from user_master where user_name = ?";

			PreparedStatement psm = conn.prepareStatement(query);
			psm.setString(1, userName);

			rs = psm.executeQuery();
			if (rs.next()) {
				LinkedHashMap<String, String> returnMap = new LinkedHashMap<String, String>();
				returnMap.put(Constants.USER_ID, rs.getString("user_id"));
				returnMap.put(Constants.ENT_EMAIL, rs.getString("email"));

				return returnMap;
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			connectionsUtil.closeConnection(conn);
		}

		return null;
	}

	public Boolean isValidUserPassword(LinkedHashMap<String, String> paramMap) {
		connectionsUtil = new ConnectionsUtil();
		conn = connectionsUtil.getConnection();

		try {

			String userId = paramMap.get(Constants.USER_ID);
			String password = paramMap.get(Constants.PASSWORD);

			String query = "select * from user_master where user_id = ? and password = ?";

			PreparedStatement psm = conn.prepareStatement(query);
			psm.setString(1, userId);
			psm.setString(2, password);

			rs = psm.executeQuery();
			if (rs.next()) {
				return true;
			}

		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {

		}

		return false;
	}

	public List<String> getUserMenu(String username) {

		PreparedStatement psm = null;
		List<String> menuList = new ArrayList<String>();
		try {
			connectionsUtil = new ConnectionsUtil();
			conn = connectionsUtil.getConnection();

			String query = "select mm.menu_description from role_master rm,"
					+ "role_menu_map rmm,user_menu_master mm,user_master um 	where 	 "
					+ "rm.role_id = rmm.role_id and 	 um.Role_Id = rm.role_id and 	 "
					+ "mm.menu_id = rmm.menu_id and "
					+ " ucase(um.user_name)=ucase(?)";

			System.out.println(query);
			psm = conn.prepareStatement(query);
			psm.setString(1, username);

			rs = psm.executeQuery();
			while (rs.next()) {
				menuList.add(rs.getString(1));
			}

		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			connectionsUtil.closeConnection(psm);
		}

		return menuList;
	}

	public void sendSms() {

		//SMS smsClient = new SMS();
		//smsClient.send(Username, Password, Number, Message, Proxy);

	}

}
