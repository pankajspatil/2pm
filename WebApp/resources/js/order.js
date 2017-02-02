/**
 * 
 */
var menuList = {};
var oldSelectVal = 0;

function addMenuToOrder(buttonObj){	
	var menuRow = $(buttonObj).closest('tr');
	var clonedRow = menuRow.clone(true);
	
	var menuId = menuRow.attr('id');
	var quantity = 1;
	var unitPrice = $(menuRow).find('td:nth-child(3)').text();
	if (unitPrice.trim() == ''){
		unitPrice = document.getElementById('input'+menuId).value;
	}
	
	
	if(unitPrice.trim() == ''){
		var paramMap = new Map();
		paramMap.put(MSG, 'Please Enter Qantity.');
		displayNotification(paramMap);
		
		$(menuRow).effect("highlight",{},3000);
		return false;
	}
	
	
	var finalPrice = parseFloat(quantity * unitPrice);
	
	var menu = {};
	menu.menuId = menuId;
	menu.quantity = quantity;
	menu.unitPrice = unitPrice;
	menu.finalPrice = finalPrice;
	var  notes = document.getElementById('note'+menuId).value;
	if (notes.trim() === ''){
		notes = '-';
	}
	
	menu.notes = notes;
	menu.orderId = $('#orderId').val();
	
	 	
	var randomNumber = (Math.floor(1000 + Math.random() * 9000)).toString();
	randomNumber = randomNumber.substring(-2);
	
	menuList[randomNumber] = menu;

	var combo = $("<select onClick='setOldValue(this)' onChange='updatePrice(this)'></select>").attr("id", randomNumber).attr("name", randomNumber);

    for(var i=1; i <= 30; i++){
    	combo.append("<option value='" + i + "'>" + i + "</option>");
    }
    
    var quantityCell = $("<td></td>");
    quantityCell.append(combo);
    
    var notesCell = $("<td></td>");
    notesCell.append(notes);
    
    var newRow = $("<tr id='"+randomNumber+"' title='random' align='center'></tr>");    
    newRow.append($(clonedRow).find('td:nth-child(1)').removeAttr('width').attr("align","left"));
    
    newRow.append(notesCell);
    newRow.append(quantityCell);
    newRow.append("<td>"+unitPrice+"</td>");
    newRow.append("<td>"+finalPrice+"</td>");
    newRow.append($("<img class='deleteIcon' src='"+contextPath+"/resources/images/Delete.png' onclick='deleteRecord(this,"+randomNumber+")'>"));
   
    //console.log(newRow);
	
	var table2 = $('#orderedTable');
	table2.append(newRow);
	
	$(newRow).effect("highlight",{},3000);
	
	var subTotal = parseFloat($('#priceTotal').text()) + parseFloat(finalPrice);
	
	/*var discountAmt = $('#discount').val();
	var advanceAmt = $('#advance').val();
	
	var totalAmount = subTotal - discountAmt;	
	var balance = totalAmount - advanceAmt;
	
	$('#priceTotal').text(subTotal.toFixed(2));
	$('#priceFinal').text(totalAmount.toFixed(2));
	$('#priceBalance').text(balance.toFixed(2));
	
	//console.log($('#priceTotal').is(':animated'));
	if(!$('#priceTotal').is(':animated')){
		$('#priceTotal').effect("bounce",{},3000);
	}
	if(!$('#priceFinal').is(':animated')){
		$('#priceFinal').effect("bounce",{},3000);
	}
	if(!$('#priceBalance').is(':animated')){
		$('#priceBalance').effect("bounce",{},3000);
	}*/
	
	updateAllPrices(subTotal);
	
	//console.log(menuList);
}

function updatePrice(selectObj){
	//alert("Pankaj");
	var rowObj = $(selectObj).closest('tr');
	var id = $(rowObj).attr("id");	
	var orderMenuMapId = rowObj.find("input:hidden").attr("id");
	
	var status = orderMenuMapId === undefined ? 0 : checkIfProcessed(orderMenuMapId);
	
	if(status == 0){
		if(id === undefined){
			id = (Math.floor(1000 + Math.random() * 9000)).toString();
			id = id.substring(-2);
			
			$(rowObj).attr("id", id);
		}
		
		var quantity = $(selectObj).find("option:selected").val();
		
		var menu = menuList[id] === undefined ? {} : menuList[id];
		var unitPrice = $(rowObj).find('td:nth-child(4)').text();	
		var finalPrice = parseFloat(quantity * unitPrice);
		
		var existingFinalPrice = parseFloat($(rowObj).find('td:nth-child(5)').text());
		var subTotal = parseFloat($('#priceTotal').text());
		
		subTotal = (subTotal - existingFinalPrice) + finalPrice;
		
		updateAllPrices(subTotal);
		
		/*$('#priceTotal').text(subTotal.toFixed(2));
		$('#priceTotal').effect("bounce",{},3000);*/
		
		menu.quantity = quantity;
		menu.finalPrice = finalPrice;
		menu.orderMenuMapId = orderMenuMapId;
		menu.notes = menu.notes === undefined ? '' : menu.notes;
		menuList[id] = menu;
		
		var cellObj = $(rowObj).find('td:nth-child(5)').text(finalPrice.toFixed(1));
		$(cellObj).effect("highlight",{},3000);
	}else if(status == 2){
		Lobibox.alert("error",{
			msg : 'Can not update quantity. Menu is in progress.'
		});
		$(selectObj).val(oldSelectVal);
	}else{
		Lobibox.alert("error",{
			msg : 'Something went wrong.'
		});
		$(selectObj).val(oldSelectVal);
	}
	
}

function checkIfProcessed(orderMenuMapId){
	
	var data = {
			"orderMenuMapId" : orderMenuMapId
	};
	
	var postData = {
			"action" : "checkIfMenuProcessed",
			"data" : JSON.stringify(data)
	};
	
	var status = 1;
	
	$.ajax({
	      type: 'POST',
	      url: contextPath + "/pages/ajax/postAjaxData.jsp",
	      data: postData, 
	      dataType: 'json',
	      async : false,
	      success: function(resultData) {
	    	  //alert("Save Complete" + resultData)
	    	  status =  resultData;
	    	 },
	    	 error: function (xhr, status) { 
	    		 console.log('ajax error = ' + xhr.statusText);
	            } 
	});
	
	return status;
}

function saveOrder(){
	
	var waiterId = $('#waiterName').val();
	
	/*if($(menuList).length > 0){
		if(waiterId != '-1'){
			var key = Object.keys($(menuList)[0])[0];
			$(menuList)[0][key].waiterId = waiterId;
		}
	}*/
	
	var count = 0; 
	$.each(menuList, function(key, value) {
		  count++;
	});
	
	if(count == 0){
		if($('#orderId').val() == 0 ){
			Lobibox.alert("warning",{
				msg : 'Please add item before saving the order.'
			});
			$('#rightCell').LoadingOverlay("hide");
			return false;
		}
	}
	
	if(waiterId != '-1'){
		$(menuList)[0].waiterId = waiterId;		
	}
	
	$(menuList)[0].orderId = $('#orderId').val();
	$(menuList)[0].tableId = $('#tableId').val();
	$(menuList)[0].discount = $('#discount').val() == '' ? 0 : $('#discount').val();
	$(menuList)[0].advance = $('#advance').val() == '' ? 0 : $('#advance').val();
	
	var postData = {
			"action" : "saveOrder",
			"data" : JSON.stringify(menuList)
	};
	
	$.ajax({
	      type: 'POST',
	      url: contextPath + "/pages/ajax/postAjaxData.jsp",
	      data: postData, 
	      dataType: 'json',
	      success: function(resultData) {
	    	  //alert("Save Complete" + resultData)
	    	  
	    	  menuList = resultData;
	    	  
	    	  if(resultData.orderId){
	    		  $('#orderNumber').text(resultData.orderId);
	    		  $('#orderId').val(resultData.orderId);
	    	  }
	    	  
	    	  $.each(resultData, function(key, value) {
	    		  
	    		  var trRow = ('#'+key);
	    		  var inputObj = $(trRow).find('input:hidden');
	    		  
	    		  if(inputObj === undefined || inputObj.length === 0){
	    			  $(trRow).find('td:nth-child(1)').append($("<input></input>").attr("type","hidden").attr("id",value.orderMenuMapId));
	    		  }
	    		  delete menuList[key];
	    		  
	    		  });
	    	  
	    	  if(menuList["waiterId"]){
	    		  delete menuList["waiterId"];
	    	  }
	    	  if(menuList["tableId"]){
	    		  delete menuList["tableId"];
	    	  }
	    	  
	    	  if(waiterId != '-1'){
	    		  $("#waiterName").parent().find("input.ui-autocomplete-input").autocomplete("option", "disabled", true).prop("disabled",true);
	    		  $("#waiterName").parent().find("a.ui-button").button("disable");
	    	  }
	    	  
	    	  $('#rightCell').LoadingOverlay("hide");
	    	    Lobibox.alert("success",{
	    				msg : 'Record saved successfully!!'
	    			});
	    	 },
	    	 error: function (xhr, status) { 
	    		 console.log('ajax error = ' + xhr.statusText);
	    		 $('#rightCell').LoadingOverlay("hide");	    		 
	    		 	Lobibox.alert("error",{
	    				msg : 'Something went wrong.'
	    			});
	            } 
	});
	
}

function checkoutOrder(){
	
	if($('#orderId').val() == 0){
		Lobibox.alert("warning",{
			msg : 'Order without order ID cannot be checked out.'
		});
		$('#rightCell').LoadingOverlay("hide");
		return false;
	}
	
	var count = 0; 
	$.each(menuList, function(key, value) {
		  count++;
		  });
	
	if( count > 0){
		Lobibox.alert("warning",{
			msg : 'Some data from the order is not saved. Please save or delete using the respective buttons.'
		});
		$('#rightCell').LoadingOverlay("hide");
		return false;		
	}
	
	var data = {
			"orderId" : $('#orderId').val()
	};
	
	var postData = {
			"action" : "checkoutOrder",
			"data" : JSON.stringify(data)
	};
	
	$.ajax({
	      type: 'POST',
	      url: contextPath + "/pages/ajax/postAjaxData.jsp",
	      data: postData, 
	      dataType: 'json',
	      success: function(resultData) {
	    	  //alert("Save Complete" + resultData)
	    	  
	    	  $('#rightCell').LoadingOverlay("hide");
	    	  if(resultData == 0){
	    		  
	    		  var rtRow = $('#divBottom').find('table').find('tr:gt(0)');
	    		  $(rtRow).append("<td></td>").append($('<input type="button" value="Print" name="page4" id="printOrder"></input>'));
	    		  
	    		  Lobibox.alert("success",{
	    				msg : 'Order cheked out successfully!!',
	    				beforeClose: function(lobibox){
	    					//window.open(contextPath + '/pages/order/printReceipt.jsp', '_blank');
	    					//wait(2000);
	    					printOrder($('#orderId').val());
	    					window.location.href = contextPath;
	    		        }
	    			});
	    	  }else if(resultData == 2){
	    		  Lobibox.alert("error",{
	    				msg : 'Order is still in progress!!'
	    			});
	    	  }
	    	 },
	    	 error: function (xhr, status) { 
	    		 console.log('ajax error = ' + xhr.statusText);
	    		 $('#rightCell').LoadingOverlay("hide");	    		 
	    		 	Lobibox.alert("error",{
	    				msg : 'Something went wrong.'
	    			});
	            } 
	});
	
}

function wait(ms){
	   var start = new Date().getTime();
	   var end = start;
	   while(end < start + ms) {
	     end = new Date().getTime();
	  }
	}

function printOrder(orderId){
	
	var paramsMap = new Map();
	var dataMap = new Map();

	dataMap.put("orderId", orderId);
	paramsMap.put(WIN_URL, contextPath + '/pages/order/printReceipt.jsp');
	paramsMap.put(DATA, dataMap);
	
	openWindow(paramsMap);
}

function openOrderPage(tableId, tableName, priceType, orderId){
	
	var form = $("<form></form>").attr('id', 'tableTransferForm')
				.attr("name", "tableTransferForm")
				.attr("action", contextPath + "/pages/order/orderPlacement.jsp")
				.attr("method","post");
	
	if(tableId !== undefined && tableId != null){
		var tableIdObj = $("<input></input>")
		.attr("name","tableId")
		.attr("id","tableId")
		.attr("value", tableId);
		
		form.append(tableIdObj);
	}
	if(tableName !== undefined && tableName != null){
		var tableNameObj = $("<input></input>")
		.attr("name","tableName")
		.attr("id","tableName")
		.attr("value", tableName);
		
		form.append(tableNameObj);
	}
	
	if(priceType !== undefined && priceType != null){
		var tablePriceTypeObj = $("<input></input>")
		.attr("name","priceType")
		.attr("id","priceType")
		.attr("value", priceType);
		
		form.append(tablePriceTypeObj);
	}
	
	if(orderId != null){
		var orderIdObj = $("<input></input>")
		.attr("name","orderId")
		.attr("id","orderId")
		.attr("value", orderId);
		
		form.append(orderIdObj);
	}
	
	form.appendTo('body');
	
	form.submit();	
}

function setOldValue(selectObj){
	oldSelectVal = $(selectObj).val();
}

function deleteRecord(imgObj,randomnumber){
	var lobibox = Lobibox.confirm({
		msg: "Are you sure you want to delete this record?",
		callback: function ($this, type) {
            if (type === 'yes') {
            	
            	$('#rightCell').LoadingOverlay("show");
            	
            	var rowObj = $(imgObj).closest('tr');
            	var id = $(rowObj).attr("id");	
            	var orderMenuMapId = rowObj.find("input:hidden").attr("id");            	
            	
            	if(orderMenuMapId === undefined){
            		
            		var finalPrice = parseFloat($(rowObj).find('td:nth-child(5)').text());
            		var subTotal = parseFloat($('#priceTotal').text());
            		
            		subTotal = (subTotal - finalPrice);
            		
            		/*var discountAmt = $('#discount').val();
            		var advanceAmt = $('#advance').val();
            		
            		var totalAmount = subTotal - discountAmt;	
            		var balance = totalAmount - advanceAmt;
            		
            		$('#priceTotal').text(subTotal.toFixed(2));
            		$('#priceFinal').text(totalAmount.toFixed(2));
            		$('#priceBalance').text(balance.toFixed(2));
            		
            		$('#priceTotal').effect("bounce",{},3000);
            		$('#priceFinal').effect("bounce",{},3000);
            		$('#priceBalance').effect("bounce",{},3000);*/
            		
            		delete menuList[randomnumber]
            		updateAllPrices(subTotal);
            		
            		$(rowObj).find('td').fadeOut(500, function() {
            			$(this).parents('tr:first').remove();
            		});
            		
            		Lobibox.alert("success",{
	    				msg : 'Record deleted successfully!!'
	    			});
            		$('#rightCell').LoadingOverlay("hide");
            		
            	}else {
            		var data = {
            				"orderMenuMapId" : orderMenuMapId
            		};
            		
            		var postData = {
            				"action" : "deleteRecord",
            				"data" : JSON.stringify(data)
            		};
            		
            		$.ajax({
            		      type: 'POST',
            		      url: contextPath + "/pages/ajax/postAjaxData.jsp",
            		      data: postData, 
            		      dataType: 'json',
            		      async : false,
            		      success: function(resultData) {
            		    	  
            		    	  if(resultData == 0){
            		    		  
            		    		  var finalPrice = parseFloat($(rowObj).find('td:nth-child(5)').text());
            	            		var subTotal = parseFloat($('#priceTotal').text());
            	            		
            	            		subTotal = (subTotal - finalPrice);
            	            		updateAllPrices(subTotal);
            	            		/*$('#priceTotal').text(subTotal.toFixed(2));
            	            		$('#priceTotal').effect("bounce",{},3000);*/
            		    		  
            		    		  $(rowObj).find('td').fadeOut(500, function() {
            	            			$(this).parents('tr:first').remove();
            	            		});
            	            		
            	            		Lobibox.alert("success",{
            		    				msg : 'Record deleted successfully!!'
            		    			});
            		    		  
            		    	  }else if(resultData == 2){
            		    		  Lobibox.alert("error",{
            		    				msg : 'Can not delete record. Menu is in progress.'
            		    			});
            		    	  }
            		    	  $('#rightCell').LoadingOverlay("hide");
            		    	 },
            		    	 error: function (xhr, status) { 
            		    		 console.log('ajax error = ' + xhr.statusText);
            		    		 Lobibox.alert("error",{
            		    				msg : 'Something went wrong.'
            		    			});
            		    		 
            		    		 $('#rightCell').LoadingOverlay("hide");
            		            } 
            		});
            	}
            	
            } else if (type === 'no') {
                return false;
            }
        }
		});
	
}

function updateAllPrices(subTotal){
	
	var discountAmt = $('#discount').val();
	var advanceAmt = $('#advance').val();
	
	var totalAmount = subTotal - discountAmt;	
	var balance = totalAmount - advanceAmt;
	
	$('#priceTotal').text(subTotal.toFixed(2));
	$('#priceFinal').text(totalAmount.toFixed(2));
	$('#priceBalance').text(balance.toFixed(2));
	
	if(!$('#priceTotal').is(':animated')){
		$('#priceTotal').effect("bounce",{},300);
	}
	if(!$('#priceFinal').is(':animated')){
		$('#priceFinal').effect("bounce",{},300);
	}
	if(!$('#priceBalance').is(':animated')){
		$('#priceBalance').effect("bounce",{},300);
	}
}

function cancelOrder(buttonObj){
	var lobibox = Lobibox.confirm({
		msg: "Are you sure you want to cancel this order?",
		callback: function ($this, type) {
            if (type === 'yes') {
            	
            	$('#rightCell').LoadingOverlay("show");
            	
            	if($('#orderId').val() === 0){
            		Lobibox.alert("warning",{
            			msg : 'Order without order ID cannot be cancelled.'
            		});
            		$('#rightCell').LoadingOverlay("hide");
            		return false;
            	}
            	
            	var data = {
            			"orderId" : $('#orderId').val()
            	};
            		
            		var postData = {
            				"action" : "cancelOrder",
            				"data" : JSON.stringify(data)
            		};
            		
            		$.ajax({
            		      type: 'POST',
            		      url: contextPath + "/pages/ajax/postAjaxData.jsp",
            		      data: postData, 
            		      dataType: 'json',
            		      async : false,
            		      success: function(resultData) {
            		    	  
            		    	  if(resultData == 0){
            		    		  
            		    		  Lobibox.alert("success",{
            		    				msg : 'Order cancelled successfully!!',
            		    				beforeClose: function(lobibox){
            		    		        	location.href = contextPath;
            		    		        }
            		    			});
            		    		  
            		    	  }else if(resultData == 2){
            		    		  Lobibox.alert("error",{
            		    				msg : 'Can not cancel order. Menu is in progress.'
            		    			});
            		    	  }
            		    	  $('#rightCell').LoadingOverlay("hide");
            		    	 },
            		    	 error: function (xhr, status) { 
            		    		 console.log('ajax error = ' + xhr.statusText);
            		    		 Lobibox.alert("error",{
            		    				msg : 'Something went wrong.'
            		    			});
            		    		 $('#rightCell').LoadingOverlay("hide");
            		            } 
            		});
            	
            } else if (type === 'no') {
                return false;
            }
        }
		});
	
}

function updateCustomer(orderId, custName, mobile, custAddress){
	$('body').LoadingOverlay("show");
	
	var data = {
			"orderId" : orderId,
			"custName" : custName,
			"mobile" : mobile,
			"custAddress" : custAddress
			
	};
		
		var postData = {
				"action" : "updateCustomer",
				"data" : JSON.stringify(data)
		};
		
		$.ajax({
		      type: 'POST',
		      url: contextPath + "/pages/ajax/postAjaxData.jsp",
		      data: postData, 
		      dataType: 'json',
		      async : false,
		      success: function(resultData) {
		    	  
		    	  if(resultData == 0){
		    		  
		    		  Lobibox.alert("success",{
		    				msg : 'Customer added successfully!!',
		    				beforeClose: function(lobibox){
		    					if(parent.$.fancybox){
		    						parent.$.fancybox.close();
		    		        	}
		    		        }
		    			});
		    		  
		    	  }
		    	  $('body').LoadingOverlay("hide");
		    	 },
		    	 error: function (xhr, status) { 
		    		 console.log('ajax error = ' + xhr.statusText);
		    		 Lobibox.alert("error",{
		    				msg : 'Something went wrong.'
		    			});
		    		 $('body').LoadingOverlay("hide");
		            } 
		});
}


jQuery(function ($) {
	  var target = $('#rightCell');

	  $('#saveOrder').click(function () {
		target.LoadingOverlay("show");
		saveOrder();	    
	  });
	  
	  $('#checkoutOrder').click(function () {
			target.LoadingOverlay("show");
			checkoutOrder();	    
		});
	  
	  $('#cancelOrder').click(function () {
			cancelOrder(this);	    
		});
	  
	  if($('#addCustomer') && $("#addCustomer").length > 0){
			$('#addCustomer').click(function(){
				var paramMap = new Map();
				
				paramMap.put(URL, contextPath + '/pages/order/addCustomer.jsp?menuRequired=false&orderId=' + $("#orderId").val());
				paramMap.put(WIDTH, '70%');
				paramMap.put(HEIGHT, '80%');
				
				openFancyBox($("#addCustomer"), paramMap);
			});
		}
	  
	  $('.updateExistingCustomer').click(function () {
			var rowObj = this.closest('tr');
			var orderId = $('#orderId').val();
			
			var custName = $(rowObj).find('td').eq(0).text();
			var mobile = $(rowObj).find('td').eq(1).text();
			var custAddress = $(rowObj).find('td').eq(2).text();
			
			updateCustomer(orderId, custName, mobile, custAddress);
		});
	  $('#addNewCustomer').click(function () {
		  
		  var orderId = $('#orderId').val();
		  var custName = $('#custName').val();
		  var mobile = $('#mobile').val();
		  var custAddress = $('#custAddress').val();
		  
		  var paramMap = new Map();
		  if(custName == ''){
			  paramMap.put(MSG, 'Please Enter Customer Name.');
				displayNotification(paramMap);
			  return false;
		  }else if(mobile == ''){
			  paramMap.put(MSG, 'Please Enter Customer Mobile Number.');
				displayNotification(paramMap);
			  return false;
		  }
		  
		  updateCustomer(orderId, custName, mobile, custAddress);
		  
	  });
	  
	  $('.editExistingCustomer').click(function () {
		  		 
			var rowObj = this.closest('tr');
			var orderId = $('#orderId').val();
			
			var custName = $(rowObj).find('td').eq(0).text();
			var mobile = $(rowObj).find('td').eq(1).text();
			var custAddress = $(rowObj).find('td').eq(2).text();
	
			$('#custName').val(custName);
			$('#mobile').val(mobile);
			$('#custAddress').val(custAddress);
			
		});
	  
	});

$(document).ready(function() {
	   var orderDashboard = $('#orderDashboard').DataTable({
	    	"bSort" : true,
	    	"paging" : true,
	    	"order": [[ 1, "desc" ]]/*,
	    	"pageLength": 15,
	    	"aLengthMenu": [[10, 15, 25, 35, 50, 100], [10, 15, 25, 35, 50, 100]]*/	
	    });
	   
	   var orderDashboard = $('#custTable').DataTable({
	    	"bSort" : true,
	    	"paging" : true/*,
	    	"pageLength": 15,
	    	"aLengthMenu": [[10, 15, 25, 35, 50, 100], [10, 15, 25, 35, 50, 100]]*/	
	    });
	   
	   $("#discount").keydown(function (event) {
		   var inputCode = event.which;
		   var currentValue = $(this).val();
		   if(inputCode === 8 || inputCode == 46){
			   var discountAmt = currentValue.substr(0, getCursorPosition(this) - 1) + currentValue.substr(getCursorPosition(this), currentValue.length);
			   if(inputCode == 46){
				   discountAmt = currentValue.substr(0, getCursorPosition(this)) + currentValue.substr(getCursorPosition(this) + 1, currentValue.length);
			   }
			    var finalAmt = $("#priceTotal").text();
			    
			    finalAmt = finalAmt - discountAmt;
			    
			    if(finalAmt < 0){
			    	
			    	var paramMap = new Map();
					paramMap.put(MSG, 'Discount Can not be greater than sub total.');
					displayNotification(paramMap);
					
			    	return false;
			    }
			    $("#priceFinal").text(finalAmt.toFixed(2));
			    
			    if(!$('#priceFinal').is(':animated')){
					$('#priceFinal').effect("bounce",{},300);
				}
		   }
	   });
	   
	   $("#discount").keypress(function (event) {
			    var inputCode = event.which;
			    var currentValue = $(this).val();
			    if (inputCode > 0 && (inputCode < 48 || inputCode > 57)) {
			        if (inputCode == 46) {
			        	
			        	if (getCursorPosition(this) == 0 && currentValue.charAt(0) == '-') return false;
			            if (currentValue.match(/[.]/)) return false;
			        } 
			        else if (inputCode == 45) {
			            if (currentValue.charAt(0) == '-') return false;
			            if (getCursorPosition(this) != 0) return false;
			        } 
			        else if (inputCode == 8){
			        	return true;
			        }
			        else return false;
			
			    } 
			    else if (inputCode > 0 && (inputCode >= 48 && inputCode <= 57)) {
			        if (currentValue.charAt(0) == '-' && getCursorPosition(this) == 0) return false;
			    }
			    
		    	var discountAmt = currentValue + event.key;
			    var finalAmt = $("#priceTotal").text();
			    
			    finalAmt = finalAmt - discountAmt;
			    
			    if(finalAmt < 0){
			    	
			    	var paramMap = new Map();
					paramMap.put(MSG, 'Discount Can not be greater than sub total.');
					displayNotification(paramMap);
					
			    	return false;
			    }
			    
			    $("#priceFinal").text(finalAmt.toFixed(2));
			    
			    if(!$('#priceFinal').is(':animated')){
					$('#priceFinal').effect("bounce",{},300);
				}
		});
	   
	   $("#advance").keydown(function (event) {
		   var inputCode = event.which;
		   var currentValue = $(this).val();
		   if(inputCode === 8 || inputCode == 46){
			   var advanceAmt = currentValue.substr(0, getCursorPosition(this) - 1) + currentValue.substr(getCursorPosition(this), currentValue.length);
			   if(inputCode == 46){
				   advanceAmt = currentValue.substr(0, getCursorPosition(this)) + currentValue.substr(getCursorPosition(this) + 1, currentValue.length);
			   }
			   
			   var balanceAmt = $("#priceFinal").text();
			   balanceAmt = balanceAmt - advanceAmt;
			    if(balanceAmt < 0){
			    	
			    	var paramMap = new Map();
					paramMap.put(MSG, 'Advance can not be greater than sub total.');
					displayNotification(paramMap);
					
			    	return false;
			    }
			    
			    $("#priceBalance").text(balanceAmt.toFixed(2));
			    
			    if(!$('#priceBalance').is(':animated')){
					$('#priceBalance').effect("bounce",{},300);
				}
		   }
	   });
	   
	   $("#advance").keypress(function (event) {
			    var inputCode = event.which;
			    var currentValue = $(this).val();
			    if (inputCode > 0 && (inputCode < 48 || inputCode > 57)) {
			        if (inputCode == 46) {
			            if (getCursorPosition(this) == 0 && currentValue.charAt(0) == '-') return false;
			            if (currentValue.match(/[.]/)) return false;
			        } 
			        else if (inputCode == 45) {
			            if (currentValue.charAt(0) == '-') return false;
			            if (getCursorPosition(this) != 0) return false;
			        } 
			        else if (inputCode == 8) return true;
			        else return false;
			
			    } 
			    else if (inputCode > 0 && (inputCode >= 48 && inputCode <= 57)) {
			        if (currentValue.charAt(0) == '-' && getCursorPosition(this) == 0) return false;
			    }
			    
			    var advanceAmt = currentValue + event.key;
			    var balanceAmt = $("#priceFinal").text();
			    
			    balanceAmt = balanceAmt - advanceAmt;
			    
			    if(balanceAmt < 0){
			    	
			    	var paramMap = new Map();
					paramMap.put(MSG, 'Advance can not be greater than sub total.');
					displayNotification(paramMap);
					
			    	return false;
			    }
			    
			    $("#priceBalance").text(balanceAmt.toFixed(2));
			    
			    if(!$('#priceBalance').is(':animated')){
					$('#priceBalance').effect("bounce",{},300);
				}
		});
	} );

$("#accordion_1").bwlAccordion({
	theme:'theme-blue',
	pagination: true,
	limit: 6,
	toggle: true
});

$( function() {
    $.widget( "custom.combobox", {
      _create: function() {
        this.wrapper = $( "<span>" )
          .addClass( "custom-combobox" )
          .insertAfter( this.element );
 
        this.element.hide();
        this._createAutocomplete();
        this._createShowAllButton();
      },
 
      _createAutocomplete: function() {
        var selected = this.element.children( ":selected" ),
          value = selected.val() ? selected.text() : "";
 
        this.input = $( "<input>" )
          .appendTo( this.wrapper )
          .val( value )
          .attr( "title", "" )
          .addClass( "custom-combobox-input ui-widget-content ui-state-default ui-corner-left" )
          .autocomplete({
            delay: 0,
            minLength: 0,
            source: $.proxy( this, "_source" )
          })
          .tooltip({
            classes: {
              "ui-tooltip": "ui-state-highlight"
            }
          });
 
        this._on( this.input, {
          autocompleteselect: function( event, ui ) {
            ui.item.option.selected = true;
            this._trigger( "select", event, {
              item: ui.item.option
            });
          },
 
          autocompletechange: "_removeIfInvalid"
        });
      },
 
      _createShowAllButton: function() {
        var input = this.input,
          wasOpen = false;
 
        $( "<a>" )
          .attr( "tabIndex", -1 )
          .attr( "title", "Show All Items" )
          .tooltip()
          .appendTo( this.wrapper )
          .button({
            icons: {
              primary: "ui-icon-triangle-1-s"
            },
            text: false
          })
          .removeClass( "ui-corner-all" )
          //.removeClass( "ui-button-icon-only" )
          .addClass( "custom-combobox-toggle ui-corner-right" )
          .on( "mousedown", function() {
            wasOpen = input.autocomplete( "widget" ).is( ":visible" );
          })
          .on( "click", function() {
            input.trigger( "focus" );
 
            // Close if already visible
            if ( wasOpen ) {
              return;
            }
 
            // Pass empty string as value to search for, displaying all results
            input.autocomplete( "search", "" );
          });
      },
 
      _source: function( request, response ) {
        var matcher = new RegExp( $.ui.autocomplete.escapeRegex(request.term), "i" );
        response( this.element.children( "option" ).map(function() {
          var text = $( this ).text();
          if ( this.value && ( !request.term || matcher.test(text) ) )
            return {
              label: text,
              value: text,
              option: this
            };
        }) );
      },
 
      _removeIfInvalid: function( event, ui ) {
 
        // Selected an item, nothing to do
        if ( ui.item ) {
          return;
        }
 
        // Search for a match (case-insensitive)
        var value = this.input.val(),
          valueLowerCase = value.toLowerCase(),
          valid = false;
        this.element.children( "option" ).each(function() {
          if ( $( this ).text().toLowerCase() === valueLowerCase ) {
            this.selected = valid = true;
            return false;
          }
        });
 
        // Found a match, nothing to do
        if ( valid ) {
          return;
        }
 
        // Remove invalid value
        this.input
          .val( "" )
          .attr( "title", value + " didn't match any item" )
          .tooltip( "open" );
        this.element.val( "" );
        this._delay(function() {
          this.input.tooltip( "close" ).attr( "title", "" );
        }, 2500 );
        this.input.autocomplete( "instance" ).term = "";
      },
 
      _destroy: function() {
        this.wrapper.remove();
        this.element.show();
      }
    });
 
    $( "#waiterName" ).combobox();
    if($('#waiterName').val() != -1){
    	$("#waiterName").parent().find("input.ui-autocomplete-input").autocomplete("option", "disabled", true).prop("disabled",true);
    	$("#waiterName").parent().find("a.ui-button").button("disable");
    }
} );

