package com.org.twopm.transfer;

public class SubMenu {

	private Integer subMenuId;
	
	private String subMenuName;
	
	private String menuDescription;
	
	private Float acUnitPrice;
	
	private Float nonAcUnitPrice;
	
	private boolean isVeg;
	
	private boolean isActive;
	
	private Float unitPrice;
	
	private boolean isCookable; 

	public Integer getSubMenuId() {
		return subMenuId;
	}

	public void setSubMenuId(Integer subMenuId) {
		this.subMenuId = subMenuId;
	}

	public String getSubMenuName() {
		return subMenuName;
	}

	public void setSubMenuName(String subMenuName) {
		this.subMenuName = subMenuName;
	}

	public String getMenuDescription() {
		return menuDescription;
	}

	public void setMenuDescription(String menuDescription) {
		this.menuDescription = menuDescription;
	}

	public Float getAcUnitPrice() {
		return acUnitPrice;
	}

	public void setAcUnitPrice(Float acUnitPrice) {
		this.acUnitPrice = acUnitPrice;
	}

	public Float getNonAcUnitPrice() {
		return nonAcUnitPrice;
	}

	public void setNonAcUnitPrice(Float nonAcUnitPrice) {
		this.nonAcUnitPrice = nonAcUnitPrice;
	}

	public boolean isVeg() {
		return isVeg;
	}

	public void setVeg(boolean isVeg) {
		this.isVeg = isVeg;
	}

	public Float getUnitPrice() {
		return unitPrice;
	}

	public void setUnitPrice(Float unitPrice) {
		this.unitPrice = unitPrice;
	}

	public boolean isActive() {
		return isActive;
	}

	public boolean isCookable() {
		return isCookable;
	}

	public void setCookable(boolean isCookable) {
		this.isCookable = isCookable;
	}

	public void setActive(boolean isActive) {
		this.isActive = isActive;
	}

	@Override
	public String toString() {
		return "SubMenu [subMenuId=" + subMenuId + ", subMenuName="
				+ subMenuName + ", menuDescription=" + menuDescription
				+ ", acUnitPrice=" + acUnitPrice + ", nonAcUnitPrice="
				+ nonAcUnitPrice + ", isVeg=" + isVeg + ", isActive="
				+ isActive + ", unitPrice=" + unitPrice + ", Cookable=" + isCookable + "]";
	}
}