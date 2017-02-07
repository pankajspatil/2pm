package com.org.twopm.transfer;

public class ExpenseItem {
	
	private Integer expenseItemId;
	
	private String expenseItemName;
	
	private String expenseItemDescription;
	
	private ItemCategory itemCategory;
	
	private Boolean isActive;
	
	private Integer createdBy;
	
	private String createdOn;

	public Integer getExpenseItemId() {
		return expenseItemId;
	}

	public void setExpenseItemId(Integer expenseItemId) {
		this.expenseItemId = expenseItemId;
	}

	public String getExpenseItemName() {
		return expenseItemName;
	}

	public void setExpenseItemName(String expenseItemName) {
		this.expenseItemName = expenseItemName;
	}

	public ItemCategory getItemCategory() {
		return itemCategory;
	}

	public void setItemCategory(ItemCategory itemCategory) {
		this.itemCategory = itemCategory;
	}

	public Boolean getIsActive() {
		return isActive;
	}

	public void setIsActive(Boolean isActive) {
		this.isActive = isActive;
	}

	public Integer getCreatedBy() {
		return createdBy;
	}

	public void setCreatedBy(Integer createdBy) {
		this.createdBy = createdBy;
	}

	public String getCreatedOn() {
		return createdOn;
	}

	public void setCreatedOn(String createdOn) {
		this.createdOn = createdOn;
	}

	public String getExpenseItemDescription() {
		return expenseItemDescription;
	}

	public void setExpenseItemDescription(String expenseItemDescription) {
		this.expenseItemDescription = expenseItemDescription;
	}

	@Override
	public String toString() {
		return "ExpenseItem [expenseItemId=" + expenseItemId
				+ ", expenseItemName=" + expenseItemName
				+ ", expenseItemDescription=" + expenseItemDescription
				+ ", itemCategory=" + itemCategory + ", isActive=" + isActive
				+ ", createdBy=" + createdBy + ", createdOn=" + createdOn + "]";
	}
}
