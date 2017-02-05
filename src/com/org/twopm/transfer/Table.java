package com.org.twopm.transfer;

public class Table {

	private Integer tableId;
	private Integer tableMasterId;
	private String tableName;
	private String tableType;
	private String statusCode;
	private Integer isActive;
	private String priceType;

	
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


	public Integer getTableMasterId() {
		return tableMasterId;
	}


	public void setTableMasterId(Integer tableMasterId) {
		this.tableMasterId = tableMasterId;
	}
	

	public String getPriceType() {
		return priceType;
	}


	public void setPriceType(String priceType) {
		this.priceType = priceType;
	}


	@Override
	public String toString() {
		return "Table [tableId=" + tableId + ", tableMasterId=" + tableMasterId
				+ ", tableName=" + tableName + ", tableType=" + tableType
				+ ", statusCode=" + statusCode + ", isActive=" + isActive
				+ ", priceType=" + priceType + "]";
	}
}
