/**
 * 
 */

$(document).ready(function() {
   var cookingTable = $('#cookingTable').DataTable({
    	//"bSort" : false,
    	"paging" : true
    });
   
   var cookedTable = $('#cookedTable').DataTable({
   	//"bSort" : false,
   	"paging" : true
   });
} );

function moveRow(buttonObj) {

	var operation = $(buttonObj).val();
	
	var orderedRow = $(buttonObj).closest('tr');
	var orderingRow = orderedRow.clone(true);
	
	var orderMenuMapId = orderedRow.attr("id");
	
	var parameters = {
		"operation" : operation,
		"orderMenuMapId" : orderMenuMapId
	};
	
	var postData = {
			"action" : "updateCookingStatus",
			"data" : JSON.stringify(parameters)
	};
	
	
	$.ajax({
	      type: 'POST',
	      url: "/two_pm/pages/ajax/postAjaxData.jsp",
	      data: postData, 
	      dataType: 'json',
	      success: function(resultData) {
	    	  //alert("Save Complete" + resultData)
	    	  console.log('resultData = ' + resultData);
	    	  
	    	  $(orderedRow).fadeOut(500, function() {
	    		  $(orderedRow).closest('table').DataTable().rows($(orderedRow)).remove().draw();
	    		});
	    		
	    	  if(operation == 'Cook'){
	    		  var btnObj = $(orderingRow).find('input:button').attr("value","Finish");
	    		  btnObj.disabled=true;
	    		  
	    		  $('#cookedTable').DataTable().row.add(
	    				 orderingRow
	  	    		  ).draw();
		    	  $(orderingRow).effect("highlight",{},3000);
	    	  }
	    	 },
	    	 error: function (xhr, status) { 
	    		 console.log('ajax error = ' + xhr.statusText);
	    		 	Lobibox.alert("error",{
	    				msg : 'Something went wrong. Please relogin again.'
	    			});
	            } 
	});
	
}

function callback() {
    setTimeout(function() {
      //$( "#effect:visible" ).removeAttr( "style" ).fadeOut();
    }, 1000 );
  };
  
  var timestamp = '';
  
  function fetchCookingData(fetchType){
	  
	  console.log("Method Called at : " + new Date() + " for " + fetchType);
	  
	  var divId = fetchType == 'INQUEUE' ? "divleft" : "divright";
	  $('#' + divId).LoadingOverlay("show");
	  
	  var parameters = {};
	  parameters.statusCode = fetchType;
	  parameters.timestamp = timestamp;
	  
	  
	  var postData = {
				"action" : "fetchCookingData",
				"data" : JSON.stringify(parameters)
		};
	  
	  $.ajax({
	      type: 'POST',
	      url: "/two_pm/pages/ajax/postAjaxData.jsp",
	      data: postData, 
	      dataType: 'json',
	      success: function(resultData) {
	    	  //alert("Save Complete" + resultData)
	    	  console.log('resultData = ' + resultData);
	    	  
	    	  var tableObj = $('#' + divId).find('table');
	    	  
	    	  //$(tableObj).find("tr:gt(0)").remove();
	    	  
	    	  $(tableObj).DataTable().rows().remove().draw();
	    	  
	    	  var buttonObj = $("<input></input>").attr("type", "button").attr("onClick", "moveRow(this)");
	    	  if(fetchType == 'INQUEUE'){
	    		  buttonObj.attr("value", "Cook");
	    	  }else{
	    		  buttonObj.attr("value", "Finish");
	    	  }
	    	  
	    	  $.each(resultData, function(key, value) {
	    		  
	    		  var rowObj = $("<tr align = 'center' id = '"+value.orderMenuMapId+"'></tr>");
	    		  
	    		  var timeJson = timeDifference(new Date(), new Date(value.createdOn));
	    		  
	    		  /*var timeDiff = timeJson.days != 0 ? timeJson.days : "";
	    		  timeDiff += timeJson.hours != 0 ? "<b>:</b>" + timeJson.hours : "";
	    		  timeDiff += timeJson.minutes != 0 ? "<b>:</b>" +timeJson.minutes : "";*/
	    		  
	    		  var timeDiff = ("0" + timeJson.days).slice(-2) + "<b>:</b>" + ("0" + timeJson.hours).slice(-2) 
	    		  				 + "<b>:</b>" + ("0" + timeJson.minutes).slice(-2);
	    		  
	    		  
	    		  timeDiff = timeDiff.replace(/^\s*<b>:<\/b>\s*/g,'');
	    		  
	    		  rowObj.append($("<td>"+value.orderData.orderId+"</td>"));
	    		  
	    		  var menuStr = "<td>";
	    		  if(value.isVeg){
	    			  menuStr += "<img width='5%' height='1%' alt='Veg' src='/two_pm/resources/images/veg-icon.png'>";
		  			}else{
		  				menuStr += "<img width='5%' height='1%' alt='Non Veg' src='/two_pm/resources/images/nonveg-icon.png'>";
		  			}
	    		  
	    		  menuStr += value.subMenuName + "</td>";
	    		  
	    		  rowObj.append($(menuStr));
	    		  rowObj.append($("<td>"+value.quantity+"</td>"));
	    		  rowObj.append($("<td>"+timeDiff+"</td>"));
	    		  if (value.orderData.tableName==null){
	    			  rowObj.append($("<td> Parcel </td>"));
		    		  
	    		  }else{
	    			  rowObj.append($("<td>"+value.orderData.tableName+"</td>"));
		    		    
	    		  }
	    		  rowObj.append($("<td>"+value.notes+"</td>"));
	    		  
	    		  var btnObj = buttonObj.clone(true);
	    		  rowObj.append($("<td></td>").append(btnObj));
	    		  
	    		  //tableObj.append(rowObj);
				$(tableObj).DataTable().row.add(
					rowObj
	    		  ).draw();
	    	  });
	    	  
	    	  $('#' + divId).LoadingOverlay("hide");
	    	  
	    	 },
	    	 error: function (xhr, status) { 
	    		 $('#' + divId).LoadingOverlay("hide");
	    		 console.log('ajax error = ' + xhr.statusText);
	    		 	Lobibox.alert("error",{
	    				msg : 'Something went wrong. Please relogin again.'
	    			});
	            } 
	});
  }
  
  fetchCookingData("INQUEUE");
  fetchCookingData("COOKING");
  
  setInterval(function(){ 
	    //code goes here that will be run every 5 seconds.
	  //console.log("Inside Interval");
	  fetchCookingData("INQUEUE");
	}, 15000);
  
  
  
  /*var selectedEffect = "bounce";
	 
  // Most effect types need no options passed by default
  var options = {};
  // some effects have required parameters
  if ( selectedEffect === "scale" ) {
    options = { percent: 50 };
  } else if ( selectedEffect === "size" ) {
    options = { to: { width: 280, height: 185 } };
  }

  // Run the effect
  $(orderingRow).show( selectedEffect, options, 500, callback );
  table2.append(orderingRow);*/