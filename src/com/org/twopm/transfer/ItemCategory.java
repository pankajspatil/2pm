package com.org.twopm.transfer;

public class ItemCategory {

	private Integer itemCategoryId;
	
	private String itemCategoryName;
	
	private String itemCategoryType;
	
	private String itemCatTypeFormatted;
	
	private Boolean isActive;

	public Integer getItemCategoryId() {
		return itemCategoryId;
	}

	public void setItemCategoryId(Integer itemCategoryId) {
		this.itemCategoryId = itemCategoryId;
	}

	public String getItemCategoryName() {
		return itemCategoryName;
	}

	public void setItemCategoryName(String itemCategoryName) {
		this.itemCategoryName = itemCategoryName;
	}

	public String getItemCategoryType() {
		return itemCategoryType;
	}

	public void setItemCategoryType(String itemCategoryType) {
		this.itemCategoryType = itemCategoryType;
	}

	public String getItemCatTypeFormatted() {
		return itemCatTypeFormatted;
	}

	public void setItemCatTypeFormatted(String itemCatTypeFormatted) {
		this.itemCatTypeFormatted = itemCatTypeFormatted;
	}

	public Boolean getIsActive() {
		return isActive;
	}

	public void setIsActive(Boolean isActive) {
		this.isActive = isActive;
	}

	@Override
	public String toString() {
		return "ItemCategory [itemCategoryId=" + itemCategoryId
				+ ", itemCategoryName=" + itemCategoryName
				+ ", itemCategoryType=" + itemCategoryType
				+ ", itemCatTypeFormatted=" + itemCatTypeFormatted
				+ ", isActive=" + isActive + "]";
	}
	
}
