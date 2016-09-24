package com.org.agritadka.transfer;

public class Table {

	private Integer tableId;
	private String tableName;
	private String tableType;
	private String statusCode;
	private Integer isActive;

	
	public Integer getTableId() {
		return tableId;
	}


	public void setTableId(Integer tableId) {
		this.tableId = tableId;
	}


	public String getTableName() {
		return tableName;
	}


	public void setTableName(String tableName) {
		this.tableName = tableName;
	}


	public String getTableType() {
		return tableType;
	}


	public void setTableType(String tableType) {
		this.tableType = tableType;
	}


	public String getStatusCode() {
		return statusCode;
	}


	public void setStatusCode(String statusCode) {
		this.statusCode = statusCode;
	}

	public Integer getIsActive() {
		return isActive;
	}


	public void setIsActive(Integer isActive) {
		this.isActive = isActive;
	}


	@Override
	public String toString() {
		return "Table [tableId=" + tableId + ", tableName=" + tableName
				+ ", tableType=" + tableType + ", statusCode=" + statusCode
				+ ", isActive=" + isActive + "]";
	}
}
