package com.org.twopm.transfer;


public class MenuMapper {

	private Integer mainSubMenuId;
	
	private MainMenu mainMenu;
	
	private SubMenu subMenu;

	public Integer getMainSubMenuId() {
		return mainSubMenuId;
	}

	public void setMainSubMenuId(Integer mainSubMenuId) {
		this.mainSubMenuId = mainSubMenuId;
	}

	public MainMenu getMainMenu() {
		return mainMenu;
	}

	public void setMainMenu(MainMenu mainMenu) {
		this.mainMenu = mainMenu;
	}

	public SubMenu getSubMenu() {
		return subMenu;
	}

	public void setSubMenu(SubMenu subMenu) {
		this.subMenu = subMenu;
	}

	@Override
	public String toString() {
		return "MenuMapper [mainSubMenuId=" + mainSubMenuId + ", mainMenuId="
				+ mainMenu.getMainMenuId() + ", mainMenuName=" + mainMenu.getMainMenuName() + ", subMenuId="
				+ subMenu.getSubMenuId() + "subMenuName=" + subMenu.getSubMenuName() + "]";
	}
	
	
}
