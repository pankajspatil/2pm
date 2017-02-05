package com.org.twopm.transfer;

public class ExpenseItem {
	
	private Integer expenseItemId;
	
	private String expenseItemName;
	
	private ItemCategory itemCategory;
	
	private Boolean isActive;

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

	@Override
	public String toString() {
		return "expenseItem [expenseItemId=" + expenseItemId
				+ ", expenseItemName=" + expenseItemName + ", itemCategory="
				+ itemCategory + ", isActive=" + isActive + "]";
	}
}
