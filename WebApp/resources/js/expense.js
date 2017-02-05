/**
 *@author : Kiran
 * This JS contains JavaScripts methods required on expense and invoices pages.
 * 
 */

$(document).ready(function() {
	   var orderDashboard = $('#expenseTable').DataTable({
	    	"bSort" : true,
	    	"paging" : true,
	    	"order": [[ 1, "desc" ]]/*,
	    	"pageLength": 15,
	    	"aLengthMenu": [[10, 15, 25, 35, 50, 100], [10, 15, 25, 35, 50, 100]]*/	
	    });
	   
	   $('#newExpense').click(function(){
		   openExpenseFancyBox(0, 'newExpense', this);
		});
	   
	   $("#expenseAmount").keydown(function (event) {
		   return validateFloatKeyDown(event);
	   });
	   
	   $("#expenseAmount").keypress(function (event) {
		   return validateFloatKeyPress(event)
	   });
	   
	   $("#expenseVat").keydown(function (event) {
		   return validateFloatKeyDown(event);
	   });
	   
	   $("#expenseVat").keypress(function (event) {
		   return validateFloatKeyPress(event)
	   });
	   
	} );

function openExpenseFancyBox(expenseId, menuType, obj){
	
	var paramMap = new Map();
	
	var url, btnObj;
	
	url = contextPath + '/pages/order/createExpense.jsp?menuRequired=false&expenseId=' + expenseId;
	
	paramMap.put(URL, url);
	paramMap.put(WIDTH, '70%');
	paramMap.put(HEIGHT, '80%');
	
	openFancyBox(obj, paramMap);
}


function validateCreateExpense(){
	
	var vendorId = $('#vendorId').val();
	var expenseItem = $('#expenseItem').val();
	var expenseQty = $('#expenseQty').val();
	var expenseAmount = $('#expenseAmount').val();
	var expenseVat = $('#expenseVat').val();

	
	var paramMap = new Map();
	  if(vendorId == -1){
		  paramMap.put(MSG, 'Please select vendor.');
			displayNotification(paramMap);
		  return false;
	  }else if(expenseItem == -1){
		  paramMap.put(MSG, 'Please select item.');
			displayNotification(paramMap);
		  return false;
	  }else if(expenseQty == ''){
		  paramMap.put(MSG, 'Expense quantity can not be blank.');
		  displayNotification(paramMap);
		  return false;
	  }else if(expenseAmount == ''){
		  paramMap.put(MSG, 'Expense amount can not be blank.');
		  displayNotification(paramMap);
		  return false;
	  }
	
}