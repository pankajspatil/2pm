package com.org.twopm.transfer;

import java.util.List;

public class OrderData {

	private Integer orderId;
	
	private String order_sequence;
	
	private Integer tableTypeNameId;
	
	private String tableName;
	
	private List<OrderMenu> selectedMenus;
	
	private String statusCode;
	
	private String statusName;
	
	private String dateTime;
	
	private String custName;
	
	private String mobileNumber;
	
	private String waiterName;
	
	private String custAddress;
	
	private Float taxRate;
	
	private Float advanceAmt;
	
	private Float discountAmt;
	
	private DeliveryTracker deliveryTracker;
	
	public Integer getOrderId() {
		return orderId;
	}

	public String getOrder_sequence() {
		return order_sequence;
	}

	public void setOrder_sequence(String order_sequence) {
		this.order_sequence = order_sequence;
	}

	public void setOrderId(Integer orderId) {
		this.orderId = orderId;
	}

	public Integer getTableTypeNameId() {
		return tableTypeNameId;
	}

	public void setTableTypeNameId(Integer tableTypeNameId) {
		this.tableTypeNameId = tableTypeNameId;
	}

	public String getTableName() {
		return tableName;
	}

	public void setTableName(String tableName) {
		this.tableName = tableName;
	}

	public List<OrderMenu> getSelectedMenus() {
		return selectedMenus;
	}

	public void setSelectedMenus(List<OrderMenu> selectedMenus) {
		this.selectedMenus = selectedMenus;
	}
	
	public String getStatusCode() {
		return statusCode;
	}

	public void setStatusCode(String statusCode) {
		this.statusCode = statusCode;
	}

	public String getStatusName() {
		return statusName;
	}

	public void setStatusName(String statusName) {
		this.statusName = statusName;
	}

	public String getDateTime() {
		return dateTime;
	}

	public void setDateTime(String dateTime) {
		this.dateTime = dateTime;
	}

	public String getCustName() {
		return custName;
	}

	public void setCustName(String custName) {
		this.custName = custName;
	}

	public String getMobileNumber() {
		return mobileNumber;
	}

	public void setMobileNumber(String mobileNumber) {
		this.mobileNumber = mobileNumber;
	}

	public String getWaiterName() {
		return waiterName;
	}

	public void setWaiterName(String waiterName) {
		this.waiterName = waiterName;
	}
	
	public String getCustAddress() {
		return custAddress;
	}

	public void setCustAddress(String custAddress) {
		this.custAddress = custAddress;
	}

	public Float getTaxRate() {
		return taxRate;
	}

	public void setTaxRate(Float taxRate) {
		this.taxRate = taxRate;
	}

	public Float getAdvanceAmt() {
		return advanceAmt;
	}

	public void setAdvanceAmt(Float advanceAmt) {
		this.advanceAmt = advanceAmt;
	}

	public Float getDiscountAmt() {
		return discountAmt;
	}

	public void setDiscountAmt(Float discountAmt) {
		this.discountAmt = discountAmt;
	}

	public DeliveryTracker getDeliveryTracker() {
		return deliveryTracker;
	}

	public void setDeliveryTracker(DeliveryTracker deliveryTracker) {
		this.deliveryTracker = deliveryTracker;
	}

	@Override
	public String toString() {
		return "OrderData [orderId=" + orderId + ", order_sequence="
				+ order_sequence + ", tableTypeNameId=" + tableTypeNameId
				+ ", tableName=" + tableName + ", selectedMenus="
				+ selectedMenus + ", statusCode=" + statusCode
				+ ", statusName=" + statusName + ", dateTime=" + dateTime
				+ ", custName=" + custName + ", mobileNumber=" + mobileNumber
				+ ", waiterName=" + waiterName + ", custAddress=" + custAddress
				+ ", taxRate=" + taxRate + ", advanceAmt=" + advanceAmt
				+ ", discountAmt=" + discountAmt + ", deliveryTracker="
				+ deliveryTracker + "]";
	}
}
