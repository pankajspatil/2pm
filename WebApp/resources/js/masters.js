/**
 * 
 * This file contains methods for all the master pages
 */

$(document).ready(function() {
	   
	   $('#mainMenuBtn').click(function(){
		   openMenuFancyBox(0, 'mainMenu', this);
		});
	   
	   $('#subMenuBtn').click(function(){
		   openMenuFancyBox(0, 'subMenu', this);
		});
	   
	   $('img[name=editMenu]').click(function(e){
		   updateMenuRecord(this);
		});
	   
	   $('img[name=deleteMenu]').click(function(e){
		   deleteMenuRecord(this);
		});
	   
	   var mainMenuTable = $('#mainMenuTable').DataTable({
	    	"bSort" : true,
	    	"paging" : true/*,
	    	"pageLength": 15,
	    	"aLengthMenu": [[10, 15, 25, 35, 50, 100], [10, 15, 25, 35, 50, 100]]*/	
	    });
	   
	   var subMenuTable = $('#subMenuTable').DataTable({
	    	"bSort" : true,
	    	"paging" : true/*,
	    	"pageLength": 15,
	    	"aLengthMenu": [[10, 15, 25, 35, 50, 100], [10, 15, 25, 35, 50, 100]]*/	
	    });
	   
	   $('#foodMenu-container').easytabs({
			uiTabs: true, 
			 collapsible: true ,
			 defaultTab: 'li#mainMenuTab'
			 });
	   
	   $('#newVendor').click(function(){
		   openVendorFancyBox(0, 'newVendor', this);
		});
	   
	   var vendorTable = $('#vendorTable').DataTable({
	    	"bSort" : true,
	    	"paging" : true,
	    	"order": [[ 0, "asc" ]]/*,
	    	"pageLength": 15,
	    	"aLengthMenu": [[10, 15, 25, 35, 50, 100], [10, 15, 25, 35, 50, 100]]*/	
	    });
	   
	   $('img[name=editVendor]').click(function(e){
		   updateVendorRecord(this);
		});
});

function openVendorFancyBox(vendorId, menuType, obj){
	
	var paramMap = new Map();
	
	var url, btnObj;
	
	url = contextPath + '/pages/master/createVendor.jsp?menuRequired=false&vendorId=' + vendorId;
	
	paramMap.put(URL, url);
	paramMap.put(WIDTH, '70%');
	paramMap.put(HEIGHT, '80%');
	
	openFancyBox(obj, paramMap);
}

function openMenuFancyBox(menuId, menuType, obj){
	
	var paramMap = new Map();
	
	var url, btnObj;
	if(menuType == 'mainMenu'){
		url = contextPath + '/pages/master/addFoodCategories.jsp?menuRequired=false&mainMenuId=' + menuId;
	}else{
		url = contextPath + '/pages/master/addFoodDishes.jsp?menuRequired=false&menuMapperId=' + menuId;
	}
	
	paramMap.put(URL, url);
	paramMap.put(WIDTH, '70%');
	paramMap.put(HEIGHT, '80%');
	
	openFancyBox(obj, paramMap);
}

function updateMenuRecord(imgObj){
	
	var menuId =  imgObj.id.split('_')[1];
	var menuType = imgObj.id.split('_')[0];
	
	openMenuFancyBox(menuId, menuType, imgObj);
}

function updateVendorRecord(imgObj){
	
	var vendorId =  imgObj.id;
	openVendorFancyBox(vendorId, 'updateVendor', imgObj);
}

function deleteMenuRecord(imgObj){
	var menuId =  imgObj.id.split('_')[1];
	var menuType = imgObj.id.split('_')[0];
	//openMenuFancyBox(menuId, menuType, imgObj);
	
	
}

var options = {
		  valueNames: [ 'name', { data: ['id'] } ],
		  page: 10,
		  plugins: [ ListPagination({}) ],
		  // Since there are no elements in the list, this will be used as template.
		  item: '<li><h3 class="name ui-widget-content" style="font-size:large"></h3></li>'
		};

var userList = new List('allSubMenu', options);

if(userList.size() != 0){
	userList.clear();
}

//Main menu id
var mainMenuId;

function updateSubMenus(divObj){
	//console.log(divObj);
	$('#allSubMenu').LoadingOverlay("show");
	
	/*var allSubMenu = $('#allSubMenu');
	allSubMenu.find('ul').empty();*/
	
	userList.clear();
	
	if(!$(divObj).hasClass('theme-blue-title-active')){
		
	mainMenuId = divObj.id.split('_')[1];
	var addedMenus = new Array();
	
	var listFound = false;
	var liObjs = $('#content_' + mainMenuId).find('li'); 
	
	$.each(liObjs, function(key, value) {
		
		var id = value.id.split('_')[1];		
		addedMenus.push(id);		
	});
	
	$.each(subMenuList, function(key, value) {
		if(!addedMenus.includes(value.subMenuId+"")){
			var isImgText = '';
			
			if(parseBool(value.isVeg)){
				isImgText = '<img class="onePaddingRight onePaddingLeft" width="2%" height="85%" alt="Non Veg" src="'+contextPath+'/resources/images/veg-icon.png">';  
    		  }else{
    			 isImgText = '<img class="onePaddingRight onePaddingLeft" width="2%" height="85%" alt="Non Veg" src="'+contextPath+'/resources/images/nonveg-icon.png">';
    		  }
			
			userList.add({
				  name: '<img alt="Add Sub Menu" src="'+contextPath+'/resources/images/left.jpg" class="menuLeftIcon" onClick="addSubMenu(this)">' +isImgText + value.subMenuName,
				  id: value.subMenuId,
				  is_veg: value.isVeg
				});
		}
	});
	
	//allSubMenu.append(ulObj);
	}
	$('#allSubMenu').LoadingOverlay("hide");
}

function inactiveMenuMapping(imgObj){
	
	console.log(imgObj);
	
	var imgId = imgObj.closest('li').id;
	var isVeg = $(imgObj.closest('li')).attr('is_veg');
	
	var mainSubMenuId = imgId.split('_')[0];
	var subMenuId = imgId.split('_')[1];
	var liObj = $(imgObj).closest('li');
	var subMenuName = liObj.text().trim();
	
	
	var postData = {
			"action" : "inactiveMenuMapping",
			"data" : JSON.stringify({"mainSubMenuId" : mainSubMenuId})
	};
	
	$.ajax({
	      type: 'POST',
	      url: contextPath + "/pages/ajax/postAjaxData.jsp",
	      data: postData, 
	      dataType: 'json',
	      success: function(resultData) {
	    	  //alert("Save Complete" + resultData)
	    	  
	    	  $(liObj).fadeOut(500, function() {
	    		  $(liObj).remove();
	    		  
	    		  var isImgText = '';
	  			
	  			if(parseBool(isVeg)){
	  				isImgText = '<img class="onePaddingRight onePaddingLeft" width="2%" height="85%" alt="Non Veg" src="'+contextPath+'/resources/images/veg-icon.png">';  
	      		  }else{
	      			 isImgText = '<img class="onePaddingRight onePaddingLeft" width="2%" height="85%" alt="Non Veg" src="'+contextPath+'/resources/images/nonveg-icon.png">';
	      		  }
	    		  
	    		  userList.add({
					  name: '<img alt="Add Sub Menu" src="'+contextPath+'/resources/images/left.jpg" class="menuLeftIcon" onClick="addSubMenu(this)">' + isImgText +  subMenuName,
					  id: subMenuId
					});
	    		  userList.update();
	    		});
	    	  
	    	 },
	    	 error: function (xhr, status) { 
	    		 console.log('ajax error = ' + xhr.statusText);
	            } 
	});
	
	/*$.each(menuMap, function(key, value) {
		$.each(value, function(key, value1) {
			mainSubMenuId = value1.mainSubMenuId;
			if(mainSubMenuId == imgObj.id){
				console.log('ID found == >' + mainSubMenuId);
				
				var i1 = value.indexOf(value1);console.log(i1);
			    value.splice(i1,1);
				
				//addedMenus.push(value.subMenu.subMenuId);
				//listFound = true; retur  false;
			}
		}); 
	});*/
	
}

function addSubMenu(imgObj){
	
	var liObj = $(imgObj).closest('li');
	var subMenuId = liObj.attr('data-id');
	var itemObj = userList.get('id', subMenuId)[0];
	var subMenuName = itemObj.values().name !== '' ? itemObj.values().name.replace(/<[^>]+>/g,'').trim() : itemObj.values().name;
	
	var postData = {
			"action" : "addSubMenu",
			"data" : JSON.stringify({"mainMenuId" : mainMenuId, "subMenuId" : subMenuId})
	};
	
	$.ajax({
	      type: 'POST',
	      url: contextPath + "/pages/ajax/postAjaxData.jsp",
	      data: postData, 
	      dataType: 'json',
	      success: function(resultData) {
	    	  //alert("Save Complete" + resultData)
	    	  
	    	  $(liObj).fadeOut(500, function() {
	    		  
	    		  var newLiObj = $('<li class="ui-widget-content" id="'+resultData+'_'+subMenuId+'"></li>');
	    		  
	    		  if(parseBool(itemObj.values().is_veg)){
	    			$(newLiObj).append('<img class="onePaddingRight onePaddingLeft" width="2%" height="85%" alt="Veg" src="'+contextPath+'/resources/images/veg-icon.png">' + subMenuName);  
	    		  }else{
	    			  $(newLiObj).append('<img class="onePaddingRight onePaddingLeft" width="2%" height="85%" alt="Non Veg" src="'+contextPath+'/resources/images/nonveg-icon.png">' + subMenuName);
	    		  }
	    		  
	    		  $(newLiObj).append('<img class="menuRightIcon" alt="Remove Sub Menu" src="'+contextPath+'/resources/images/right.jpg" height="85%" width="2%" onclick="inactiveMenuMapping(this)">');
	    		  
	    		  $('#content_' + mainMenuId).append(newLiObj);
	    		  
	    		  userList.remove('id', subMenuId);
	    		  userList.update();
	    		});
	    	  
	    	 },
	    	 error: function (xhr, status) { 
	    		 console.log('ajax error = ' + xhr.statusText);
	            } 
	});
}

function validateMainMenuForm(){
	
	var menuName = $('#menuName').val();
	
	var paramMap = new Map();
	if(menuName.trim() == ''){
		paramMap.put(MSG, 'Please Enter Menu Name.');
		displayNotification(paramMap);
		
		return false;
	}
	
	if(menuName.toLowerCase() !== oldMenuName.toLowerCase()){
		var mainMenuNameArray = parent.$('#mainMenuTable').DataTable().column(0).data();	
		mainMenuNameArray = convertCaseArray(mainMenuNameArray, LOWER_CASE);
		
		if(mainMenuNameArray.includes(menuName.toLowerCase())){
			paramMap.put(MSG, 'Duplicate Menu Name.');
			displayNotification(paramMap);
			
			return false;
		}
	}
	
}

function validateVendorForm(){
	
	var vendorName = $('#vendorName').val();
	var contactNo = $('#contactNo').val();
	
	var paramMap = new Map();
	if(vendorName.trim() == ''){
		paramMap.put(MSG, 'Please enter vendor name.');
		displayNotification(paramMap);
		
		return false;
	}
	
	if(contactNo.trim() == ''){
		paramMap.put(MSG, 'Please enter contact number.');
		displayNotification(paramMap);
		
		return false;
	}
	
	if(vendorName.toLowerCase() !== oldVendorName.toLowerCase()){
		var vendorNameArray = parent.$('#vendorTable').DataTable().column(0).data();	
		vendorNameArray = convertCaseArray(vendorNameArray, LOWER_CASE);
		
		if(vendorNameArray.includes(vendorName.toLowerCase())){
			paramMap.put(MSG, 'Duplicate vendor name.');
			displayNotification(paramMap);
			return false;
		}
	}
	
}


function validateSubMenuForm(){
	
	var menuName = $('#subName').val();
	var acunitPrice = $('#acUnitPrice').val();
	var nonAcUnitPrice = $('#nonAcUnitPrice').val();
	
	var paramMap = new Map();
	if(menuName.trim() == ''){
		paramMap.put(MSG, 'Please Enter Menu Name.');
		displayNotification(paramMap);
		
		return false;
	}if(acunitPrice.trim() == ''){
		paramMap.put(MSG, 'Please Enter AC Unit Price.');
		displayNotification(paramMap);
		
		return false;
	}if(nonAcUnitPrice.trim() == ''){
		paramMap.put(MSG, 'Please Enter Non AC Unit Price.');
		displayNotification(paramMap);
		
		return false;
	}
	if(isNaN(acunitPrice.trim())){
		paramMap.put(MSG, 'Please Enter valid numbers in Non Ac Unit Price.');
		displayNotification(paramMap);
		
		return false;
	}if(isNaN(nonAcUnitPrice.trim())){
		paramMap.put(MSG, 'Please Enter valid numbers in Non Ac Unit Price.');
		displayNotification(paramMap);
		
		return false;
	}
	
	if(menuName.toLowerCase() !== oldSubMenuName.toLowerCase()){
		var mainMenuNameArray = parent.$('#subMenuTable').DataTable().column(0).data();	
		mainMenuNameArray = convertCaseArray(mainMenuNameArray, LOWER_CASE);
		
		if(mainMenuNameArray.includes(menuName.toLowerCase())){
			paramMap.put(MSG, 'Duplicate Menu Name.');
			displayNotification(paramMap);
			
			return false;
		}
	}
	
}

