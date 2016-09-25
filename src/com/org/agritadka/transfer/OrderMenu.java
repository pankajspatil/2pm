package com.org.agritadka.transfer;

public class OrderMenu {

	private Integer orderMenuMapId;
	
	private Integer mainSubMenuMapId;
	
	private Integer quantity;
	
	private Float unitPrice;
	
	private Float finalPrice;
	
	private String notes;
	
	private String subMenuName;

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

	@Override
	public String toString() {
		return "OrderMenu [orderMenuMapId=" + orderMenuMapId
				+ ", mainSubMenuMapId=" + mainSubMenuMapId + ", quantity="
				+ quantity + ", unitPrice=" + unitPrice + ", finalPrice="
				+ finalPrice + ", notes=" + notes + ", subMenuName="
				+ subMenuName + "]";
	}
}