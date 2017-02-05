package com.org.twopm.order;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.org.twopm.generic.ConnectionsUtil;
import com.org.twopm.transfer.ExpenseItem;
import com.org.twopm.transfer.ExpenseModel;
import com.org.twopm.transfer.Vendor;

public class Expense {
	
	static Connection conn = null;
	static ResultSet dataRS = null;
	static ConnectionsUtil connectionsUtil = null;
	
	public void addExpense(ExpenseModel expenseModel) throws SQLException {

			connectionsUtil = new ConnectionsUtil();
			conn = connectionsUtil.getConnection();

			String query = "INSERT INTO `expenses`(`vendor_id`,`expense_item_id`,`expense_qty`,`expense_amount`,"
						+ "`expense_remark`,`expense_vat`,`created_by`) "+
							"VALUES(?,?,?,?,?,?,?)";

			PreparedStatement psmt = conn.prepareStatement(query);
			
			psmt.setInt(1, expenseModel.getVendor().getVendorId());
			psmt.setInt(2, expenseModel.getExpenseItem().getExpenseItemId());
			psmt.setInt(3, expenseModel.getExpenseQty());
			psmt.setDouble(4, expenseModel.getExpenseAmt());
			psmt.setString(5, expenseModel.getExpenseRemark());
			psmt.setDouble(6, expenseModel.getExpenseVat());			
			psmt.setInt(7, expenseModel.getCreatedBy());

			psmt.executeUpdate();
			
			connectionsUtil.closeConnection(conn);
	}
	
	public List<ExpenseModel> getExpenseList(Integer vendorId, boolean payableOnly) throws SQLException{
			
		
			connectionsUtil = new ConnectionsUtil();
			conn = connectionsUtil.getConnection();

			String query = "SELECT e.expense_id, e.expense_item_id, ei.expense_item_name, v.vendor_id, v.vendor_name, " +
							"e.expense_qty, e.expense_amount, ie.paidAmt, e.expense_remark FROM expenses e "+
							"inner join expense_item_master ei on e.expense_item_id = ei.expense_item_id "+
							"inner join vendor_master v on e.vendor_id = v.vendor_id ";
							if(vendorId != null){
								query += "and v.vendor_id = ? ";
							}
							
							query += "left join (select expense_id, sum(ifnull(amount,0)) as paidAmt from invoice_expense_map ie "+ 
							"where is_active = 1 group by expense_id) ie on e.expense_id = ie.expense_id";
							
							if(payableOnly){
								query += " having (expense_amount - ifnull(ie.paidAmt,0)) > 0";
							}
					
			PreparedStatement preparedStatement = conn.prepareStatement(query);
			if(vendorId != null){
				preparedStatement.setInt(1, vendorId);
			}
			
			dataRS = preparedStatement.executeQuery();

			List<ExpenseModel> expenseList = new ArrayList<ExpenseModel>();
			ExpenseModel expenseModel = null;
			ExpenseItem expenseItem = null;
			Vendor vendor = null;
			
			while (dataRS.next()) {
				
				expenseModel = new ExpenseModel();
				
				expenseItem = new ExpenseItem();
				expenseItem.setExpenseItemName(dataRS.getString("expense_item_name"));
				
				vendor = new Vendor();
				vendor.setVendorName(dataRS.getString("vendor_name"));
				
				expenseModel.setExpenseId(dataRS.getInt("expense_id"));
				expenseModel.setVendor(vendor);
				expenseModel.setExpenseItem(expenseItem);
				expenseModel.setExpenseQty(dataRS.getInt("expense_qty"));
				expenseModel.setExpenseAmt(dataRS.getDouble("expense_amount"));
				expenseModel.setPaidAmt(dataRS.getDouble("paidAmt"));
				expenseModel.setExpenseRemark(dataRS.getString("expense_remark"));
				
				expenseList.add(expenseModel);
			}

			connectionsUtil.closeConnection(conn);
		
		return expenseList;

	}

}
