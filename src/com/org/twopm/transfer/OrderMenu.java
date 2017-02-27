package com.org.twopm.transfer;

public class OrderMenu {

	private Integer orderMenuMapId;
	
	private Integer mainSubMenuMapId;
	
	private Integer quantity;
	
	private Float unitPrice;
	
	private Float finalPrice;
	
	private String notes;
	
	private String subMenuName;
	
	private String createdOn;
	
	private boolean isVeg;
	
	private boolean isCookable;

	public Integer getOrderMenuMapId() {
		return orderMenuMapId;
	}

	public void setOrderMenuMapId(Integer orderMenuMapId) {
		this.orderMenuMapId = orderMenuMapId;
	}

	public Integer getMainSubMenuMapId() {
		return mainSubMenuMapId;
	}

	public void setMainSubMenuMapId(Integer mainSubMenuMapId) {
		this.mainSubMenuMapId = mainSubMenuMapId;
	}

	public Integer getQuantity() {
		return quantity;
	}

	public void setQuantity(Integer quantity) {
		this.quantity = quantity;
	}

	public Float getUnitPrice() {
		return unitPrice;
	}

	public void setUnitPrice(Float unitPrice) {
		this.unitPrice = unitPrice;
	}

	public Float getFinalPrice() {
		return finalPrice;
	}

	public void setFinalPrice(Float finalPrice) {
		this.finalPrice = finalPrice;
	}

	public String getNotes() {
		return notes;
	}

	public void setNotes(String notes) {
		this.notes = notes;
	}

	public String getSubMenuName() {
		return subMenuName;
	}

	public void setSubMenuName(String subMenuName) {
		this.subMenuName = subMenuName;
	}
	
	public String getCreatedOn() {
		return createdOn;
	}

	public void setCreatedOn(String createdOn) {
		this.createdOn = createdOn;
	}

	public boolean isVeg() {
		return isVeg;
	}

	public void setVeg(boolean isVeg) {
		this.isVeg = isVeg;
	}

	public boolean isCookable() {
		return isCookable;
	}

	public void setCookable(boolean isCookable) {
		this.isCookable = isCookable;
	}

	@Override
	public String toString() {
		return "OrderMenu [orderMenuMapId=" + orderMenuMapId
				+ ", mainSubMenuMapId=" + mainSubMenuMapId + ", quantity="
				+ quantity + ", unitPrice=" + unitPrice + ", finalPrice="
				+ finalPrice + ", notes=" + notes + ", subMenuName="
				+ subMenuName + ", createdOn=" + createdOn + "]";
	}
}
