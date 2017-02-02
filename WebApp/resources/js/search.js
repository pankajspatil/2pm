/**
 * 
 */
/**
 * This method is calling on change of search parameters.
 * Showing date picker if search by DOB is selected.
 * */

function searchKeySelect(selectObj){
	$("#searchValue").val('');
	if(selectObj.options[selectObj.selectedIndex].value == 3){
		var yrRange = '1900:'+ new Date().getFullYear();
		$( "#searchValue" ).datepicker({
		      changeMonth: true,
		      changeYear: true,
		      dateFormat : 'yy-mm-dd',
		      minDate: '1900-1-1',
		      maxDate: new Date(),
		      yearRange : yrRange,
		      onSelect: function(dateText, inst) {
		    	  $("#searchValue").attr('readonly', true);
		      }
		    });
	}else{
		$( "#searchValue" ).datepicker("destroy");
		$("#searchValue").attr('readonly', false);
	}
}

function openPage(oepration, tableMasterId,tableName,tableType,active){
	
	var formObj = $(document.createElement('form'));
	formObj.attr("method", "post");
	
	var userIdObj = $(document.createElement('input'));
	userIdObj.attr("type", "text");
	userIdObj.attr("value", tableMasterId);
	userIdObj.attr("name", "userId");
	
	formObj.append(userIdObj);
	
	switch (oepration) { 
    case 'edit': 

    	var paramsMap = new Map();
    	var dataMap = new Map();
    	
    	dataMap.put("tableMasterId", tableMasterId);
    	dataMap.put("tableName", tableName);
    	dataMap.put("tableType", tableType);
    	dataMap.put("active", active);    	
    	dataMap.put(MENU_REQUIRED,false);
    	
    	paramsMap.put(WIN_URL, contextPath + '/pages/master/tableModify.jsp');
    	paramsMap.put(DATA, dataMap);
    	
    	openWindow(paramsMap);
        break;
    case 'delete': 
        alert('Delete called');
        break;
    case 'vHistory': 
        //alert('Visit History Called');
    	
    	var paramsMap = new Map();
    	var dataMap = new Map();
    	
    	dataMap.put(PATIENT_ID, patientId);
    	dataMap.put(MENU_REQUIRED,false);
    	
    	paramsMap.put(WIN_URL, './pages/master/tableMaster.jsp');
    	paramsMap.put(DATA, dataMap);
    	
    	openWindow(paramsMap);
    	    	
    	break;      
    case 'vNew': 
    	
    	
        break;
    default:
        alert('Something went wrong!');
}
}
	
/*function openWindow(paramsMap){
	
	var winName='MyWindow';
	  var winURL = paramsMap.get(WIN_URL);
	  var width = paramsMap.hasKey(WIDTH) ? paramsMap.get(WIDTH) : screen.width;
	  var height = paramsMap.hasKey(HEIGHT) ? paramsMap.get(HEIGHT) : screen.height;
	  
	  //alert("width==>" + width + height);
	  
	  var left = (screen.width/2)-(width/2);
	  var top = (screen.height/2)-(height/2);
	  
	  var windowoption='resizable=yes,height='+height+',width='+width+',top='+top+',left='+left+',location=0,menubar=0,scrollbars=1';
	  var dataMap = paramsMap.get(DATA);         
	  var form = document.createElement("form");
	  form.setAttribute("method", "post");
	  form.setAttribute("action", winURL);
	  form.setAttribute("target",winName);
	  
	  if(dataMap && !dataMap.isEmpty()){
		  dataMap.each(function(key, value){
			  var input = document.createElement('input');
		      input.type = 'hidden';
		      input.name = key;
		      input.id = key;
		      input.value = value;
		      form.appendChild(input);
		  });
	  }
	              
	  document.body.appendChild(form);                       
	  window.open('', winName,windowoption);
	  form.target = winName;
	  form.submit();                 
	  document.body.removeChild(form);
	  
	  dataMap = null;paramsMap = null;
}*/

/*	
function openWindowWithPostRequest() {
	  var winName='MyWindow';
	  var winURL='search.action';
	  var windowoption='resizable=yes,height=600,width=800,location=0,menubar=0,scrollbars=1';
	  var params = { 'param1' : '1','param2' :'2'};         
	  var form = document.createElement("form");
	  form.setAttribute("method", "post");
	  form.setAttribute("action", winURL);
	  form.setAttribute("target",winName);  
	  for (var i in params) {
	    if (params.hasOwnProperty(i)) {
	      var input = document.createElement('input');
	      input.type = 'hidden';
	      input.name = i;
	      input.value = params[i];
	      form.appendChild(input);
	    }
	  }              
	  document.body.appendChild(form);                       
	  window.open('', winName,windowoption);
	  form.target = winName;
	  form.submit();                 
	  document.body.removeChild(form);           
	}*/











	
