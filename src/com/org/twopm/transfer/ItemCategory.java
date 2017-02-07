package com.org.twopm.transfer;

public class ItemCategory {

	private Integer itemCategoryId;
	
	private String itemCategoryName;
	
	private String itemCategoryDescription;
	
	private String itemCategoryType;
	
	private String itemCatTypeFormatted;
	
	private Boolean isActive;
	
	private Integer createdBy;
	
	private String createdOn;

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

	public String getItemCategoryDescription() {
		return itemCategoryDescription;
	}

	public void setItemCategoryDescription(String itemCategoryDescription) {
		this.itemCategoryDescription = itemCategoryDescription;
	}

	@Override
	public String toString() {
		return "ItemCategory [itemCategoryId=" + itemCategoryId
				+ ", itemCategoryName=" + itemCategoryName
				+ ", itemCategoryDescription=" + itemCategoryDescription
				+ ", itemCategoryType=" + itemCategoryType
				+ ", itemCatTypeFormatted=" + itemCatTypeFormatted
				+ ", isActive=" + isActive + ", createdBy=" + createdBy
				+ ", createdOn=" + createdOn + "]";
	}
	
}
