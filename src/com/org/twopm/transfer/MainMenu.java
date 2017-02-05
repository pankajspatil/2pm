package com.org.twopm.transfer;

public class MainMenu {
	
	private Integer mainMenuId;

	private String mainMenuName;
	
	private String menuDescription;
	
	private boolean isVeg;
	
	private boolean isActive;

	public Integer getMainMenuId() {
		return mainMenuId;
	}

	public void setMainMenuId(Integer mainMenuId) {
		this.mainMenuId = mainMenuId;
	}

	public String getMainMenuName() {
		return mainMenuName;
	}

	public void setMainMenuName(String mainMenuName) {
		this.mainMenuName = mainMenuName;
	}

	public String getMenuDescription() {
		return menuDescription;
	}

	public void setMenuDescription(String menuDescription) {
		this.menuDescription = menuDescription;
	}

	public boolean isVeg() {
		return isVeg;
	}

	public void setVeg(boolean isVeg) {
		this.isVeg = isVeg;
	}

	public boolean isActive() {
		return isActive;
	}

	public void setActive(boolean isActive) {
		this.isActive = isActive;
	}

	@Override
	public String toString() {
		return "MainMenu [mainMenuId=" + mainMenuId + ", mainMenuName="
				+ mainMenuName + ", menuDescription=" + menuDescription
				+ ", isVeg=" + isVeg + ", isActive=" + isActive + "]";
	}
}