package com.org.twopm.transfer;

public class ExpenseModel {

	private Integer expenseId;
	
	private Vendor vendor;
	
	private ExpenseItem expenseItem;
	
	private Integer expenseQty;
	
	private String expenseRemark;
	
	private Double expenseVat;
	
	private Boolean isActive;
	
	private Double expenseAmt;
	
	private Double paidAmt;
	
	private Integer createdBy;

	public Integer getExpenseId() {
		return expenseId;
	}

	public void setExpenseId(Integer expenseId) {
		this.expenseId = expenseId;
	}

	public Vendor getVendor() {
		return vendor;
	}

	public void setVendor(Vendor vendor) {
		this.vendor = vendor;
	}

	public ExpenseItem getExpenseItem() {
		return expenseItem;
	}

	public void setExpenseItem(ExpenseItem expenseItem) {
		this.expenseItem = expenseItem;
	}

	public Integer getExpenseQty() {
		return expenseQty;
	}

	public void setExpenseQty(Integer expenseQty) {
		this.expenseQty = expenseQty;
	}

	public String getExpenseRemark() {
		return expenseRemark;
	}

	public void setExpenseRemark(String expenseRemark) {
		this.expenseRemark = expenseRemark;
	}

	public Double getExpenseVat() {
		return expenseVat;
	}

	public void setExpenseVat(Double expenseVat) {
		this.expenseVat = expenseVat;
	}

	public Boolean getIsActive() {
		return isActive;
	}

	public void setIsActive(Boolean isActive) {
		this.isActive = isActive;
	}

	public Double getExpenseAmt() {
		return expenseAmt;
	}

	public void setExpenseAmt(Double expenseAmt) {
		this.expenseAmt = expenseAmt;
	}

	public Double getPaidAmt() {
		return paidAmt;
	}

	public void setPaidAmt(Double paidAmt) {
		this.paidAmt = paidAmt;
	}
	

	public Integer getCreatedBy() {
		return createdBy;
	}

	public void setCreatedBy(Integer createdBy) {
		this.createdBy = createdBy;
	}

	@Override
	public String toString() {
		return "ExpenseModel [expenseId=" + expenseId + ", vendor=" + vendor
				+ ", expenseItem=" + expenseItem + ", expenseQty=" + expenseQty
				+ ", expenseRemark=" + expenseRemark + ", expenseVat="
				+ expenseVat + ", isActive=" + isActive + ", expenseAmt="
				+ expenseAmt + ", paidAmt=" + paidAmt + ", createdBy="
				+ createdBy + "]";
	}
}
