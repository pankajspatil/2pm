<%@page import="java.util.Date"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="com.google.gson.JsonParser"%>
<%@page import="com.org.twopm.order.Order"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="com.org.twopm.transfer.MenuMapper"%>
<%@page import="com.org.twopm.transfer.SubMenu"%>
<%@page import="com.org.twopm.master.Master"%>
<%@page import="com.org.twopm.transfer.MainMenu"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="/pages/common/header.jsp"%>
<%@ include file="/pages/common/validateSession.jsp"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link href="<%=contextPath%>/resources/css/order.css" rel="stylesheet" type="text/css">
<style>
  #feedback { font-size: 1.4em; }
  .selectable .ui-selecting { background: #FECA40; }
  .selectable .ui-selected { background: #F39814; color: white; }
  .selectable, .subMenuList { list-style-type: none; margin: 0; padding: 0; width: 99%; }
  .selectable li { margin: 3px; padding: 0.4em; font-size: 1.4em; height: 18px; }
  .subMenuList h3 { margin: 3px; padding: 0.4em; font-size: 1.4em; height: 18px; }
 
  </style>
</head>
<body>
<h1 align="center">Food Menu Master</h1>
<%
	Master master = new Master();
	List<MainMenu> mainMenuList = master.getAllMainMenus(false);
	List<SubMenu> subMenuList = master.getAllSubMenus(false);
	
	String priceType = Utils.getString(request.getParameter("priceType")).equals("") ? "non_ac" 
			: Utils.getString(request.getParameter("priceType"));
	
	Order order = new Order();
	LinkedHashMap<MainMenu, List<MenuMapper>> menuMap = master.getMenus(priceType);
	//List<MenuMapper> menuMapperList = master.getAllSubMenus(false);
%>

<div style="float: right; margin-right: 1%;">
	Add : 
	<button class="btn btn-main btn-2g" name="mainMenuBtn" id="mainMenuBtn" onclick="openMenuFancyBox(0, 'mainMenu', this);">Main Menu</button>
	<button class="btn btn-main btn-2g" name="subMenuBtn" id="subMenuBtn" onclick="openMenuFancyBox(0, 'subMenu', this);">Sub Menu</button>&nbsp;&nbsp;
</div><br/><br/><br/>
	<div id="foodMenu-container" class="tab-container">
		<ul class='etabs'>
			<li class='tab' id="mainMenuTab"><a href="#mainMenuMaster">Food Menu Categories</a></li>
			<li class='tab' id="subMenuTab"><a href="#subMenuMaster">Food Dishes</a></li>
			<li class='tab' id="menuMappingTab"><a href="#menuMapping">Menu Mapping</a></li>
			
		</ul>
		<div id="mainMenuMaster">
			<table id="mainMenuTable" border="0" width="100%">
				<thead>
					<tr class="headerTR">
						<th width="25%">Menu Name</th>
						<th width="40%">Description</th>
						<th width="15%">V/NV</th>
						<th width="10%">Active</th>
						<th width="10%">Action</th>
					</tr>
				</thead>
				<tbody>
					<%
						for(MainMenu mainMenu : mainMenuList){
							%><tr style="font-size: 15px;">
								<td><%=mainMenu.getMainMenuName() %></td>
								<td><%=mainMenu.getMenuDescription() %></td>
								<td align="center"><%=mainMenu.isVeg() ? "Veg" : "Non Veg" %></td>
								<td align="center"><%=mainMenu.isActive() ? "True" : "False" %></td>
								<td>
									<img style="margin-left: 40%" height="22%" src="<%=contextPath%>/resources/images/edit.png" 
									id="mainMenu_<%=mainMenu.getMainMenuId()%>" name="editMenu" onclick="updateMenuRecord(this)">
									<%-- <img class="deleteIcon" src="<%=contextPath%>/resources/images/Delete.png" 
									id="mainMenu_<%=mainMenu.getMainMenuId()%>" name="deleteMenu" onclick="deleteMenuRecord(this)"> --%>
								</td>		
							</tr><%
						}
					%>
					
				</tbody>	
			</table>
		</div>
		<div id="subMenuMaster">
			<table id="subMenuTable" border="0" width="100%">
				<thead>
					<tr class="headerTR">
						<!-- <td width="15%">Category</td> -->
						<td width="15%">Menu Name</td>
						<td width="25%">Description</td>
						<td width="10%">Veg/Non Veg</td>
						<td width="10%">AC</td>
						<td width="10%">Non AC</td>
						<td width="5%">Cookable</td>
						<td width="5%">Active</td>
						<td width="10%">Action</td>
					</tr>
				</thead>
				<tbody>
					<%
						for(SubMenu subMenu : subMenuList){
							%><tr style="font-size: 15px;">
								<%-- <td><%=menuMapper.getMainMenu().getMainMenuName() %></td> --%>
								<td><%=subMenu.getSubMenuName() %></td>
								<td><%=subMenu.getMenuDescription() %></td>
								<td align="center"><%=subMenu.isVeg() ? "Veg" : "Non Veg" %></td>
								<td align="center"><%=subMenu.getAcUnitPrice() %></td>
								<td align="center"><%=subMenu.getNonAcUnitPrice() %></td>
								<td align="center"><%=subMenu.isCookable() ? "True" : "False" %></td>
								<td align="center"><%=subMenu.isActive() ? "True" : "False" %></td>								
								<td>
									<img style="margin-left: 40%" height="22%" src="<%=contextPath%>/resources/images/edit.png" 
									id="subMenu_<%=subMenu.getSubMenuId()%>" name="editMenu" onclick="updateMenuRecord(this)">
									<%-- <img class="deleteIcon" src="<%=contextPath%>/resources/images/Delete.png" 
									id="subMenu_<%=subMenu.getSubMenuId()%>" name="deleteMenu" onclick="deleteMenuRecord(this)"> --%>
								</td>		
							</tr><%
						}
					%>
					
				</tbody>	
			</table>
		</div>
		<div id="menuMapping">
		<table width="100%">
			<tr>
				<td width="50%" valign="top">
					<div class="bwl_acc_container scroll" id="accordion_1" style="width: 98%; /* border:1px solid black; */ height: 600px; max-height: 600px; overflow: auto;">
		    			<div class="accordion_search_container">
		        				<input type="text" class="accordion_search_input_box search_icon" value="" placeholder="Search ..."/>
		        		</div>

						<div class="search_result_container"></div>
					<%
						//out.println(menuMap.size());
						if(menuMap.size() > 0){
							List<MenuMapper> mappers = new ArrayList<MenuMapper>();
							for(MainMenu mainMenu : menuMap.keySet()){
								mappers = menuMap.get(mainMenu);
								%><section>
								<h2 class="acc_title_bar" onclick="updateSubMenus(this)" id="header_<%=mainMenu.getMainMenuId()%>">
									<a href="#"><%=mainMenu.getMainMenuName() %></a>
								</h2>
								<div class="acc_container">
									<div class="block" style="overflow: auto;">
									<%if(mappers.size() > 0){
										%><ul class="selectable" id="content_<%=mainMenu.getMainMenuId()%>">
										<%for(MenuMapper mapper : mappers){ 
											if(mapper.getSubMenu().getSubMenuId() != 0){
											%>
											<li class="ui-widget-content" id='<%=mapper.getMainSubMenuId() %>_<%=mapper.getSubMenu().getSubMenuId() %>' is_veg='<%=mapper.getSubMenu().isVeg()%>'>
												<%if(mapper.getSubMenu().isVeg()){
													%><img class="onePaddingRight onePaddingLeft" width="2%" height="85%" alt="Veg" src="<%=contextPath%>/resources/images/veg-icon.png"> <%
												}else{
													%><img class="onePaddingRight onePaddingLeft" width="2%" height="85%" alt="Non Veg" src="<%=contextPath%>/resources/images/nonveg-icon.png"><%
												}
												%><%=mapper.getSubMenu().getSubMenuName() %>
												<img class="menuRightIcon" alt="Remove Sub Menu" src="<%=contextPath%>/resources/images/right.jpg" 
												height="85%" width="2%" onclick="inactiveMenuMapping(this)">
												</li>
											<%}} %>
										</ul><%
									}%>
										
									</div>
								</div></section>
								<%
									}
							Gson gson = new Gson();
							%><script type="text/javascript">
								var subMenuList = <%=gson.toJson(subMenuList)%>;
								var menuMap = <%=gson.toJson(menuMap)%>;
							</script>
							<%
									}
								%>
					</div>
				</td>
				<td width="50%" valign="top">
				<%-- <div class="bwl_acc_container scroll" id="accordion_2" style="width: 98%; /* border:1px solid black; */ height: 600px; max-height: 600px; overflow: auto;">
		    			<div class="accordion_search_container">
		        				<input type="text" class="accordion_search_input_box search_icon" value="" placeholder="Search ..."/>
		        		</div>

						<div class="search_result_container"></div>
					<%
						//out.println(menuMap.size());
								%><section>
								<h2 class="acc_title_bar">
									<a href="#">Sub Menus</a>
								</h2>
								<div class="acc_container">
									<div id="allSubMenu" class="ui-widget-content ui-state-default scroll">
									</div>
								</div></section>
											
					</div>
				 --%>
				 
				 <div id="allSubMenu" class="scroll" style="height: 600px; max-height: 600px; overflow: auto;">
				 
				 <!-- <div class="accordion_search_container">
		        				<input class="search accordion_search_input_box search_icon" value="" placeholder="Search"/>
		        		</div> -->
				 <input class="search search_icon" placeholder="Search" style="width: 98%; padding:9px 5px;background-color: white" />
				 <ul class="list subMenuList" style="border : 1px solid #aed0ea; color: #2779aa">
				    		    
				  </ul>
				  <ul class="pagination"></ul>
				  
				</div>
				 	
				</td>
			</tr>
		</table>
		</div>
	</div>
	
	
<script src="<%=contextPath%>/resources/js/masters.js" type="text/javascript"></script>
<script type="text/javascript" src="<%=contextPath%>/resources/js/order.js"></script>

</body>
</html>