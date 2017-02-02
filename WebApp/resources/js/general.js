/**
 * 
 */

/*$("#projects").multipleSelect({
    filter: true,
    single : true
});

$("#project").multipleSelect({
    filter: true,
    width:'96%',
    placeholder : 'Select Project'
});

$( "#fromDate" ).datepicker({
	changeMonth: true,
    changeYear: true,
    dateFormat:'yy-mm-dd'
});

$( "#toDate" ).datepicker({
	changeMonth: true,
    changeYear: true,
    dateFormat:'yy-mm-dd'
});*/


function openURL(paramsMap){
	
	var methodType = paramsMap.hasKey(METHOD_TYPE) ? paramsMap.get(METHOD_TYPE) : 'post';
	var dataMap = paramsMap.get(DATA);
	var winURL = paramsMap.get(URL);
	
	//console.log("dataMap == >" + dataMap + "==>" + winURL);
	
	var formObj = $(document.createElement('form'));
	formObj.attr("method", methodType);
	formObj.attr("action", winURL);
	
	if(dataMap && !dataMap.isEmpty()){
		  dataMap.each(function(key, value){
			  var input = document.createElement('input');
		      input.type = 'hidden';
		      input.name = key;
		      input.id = key;
		      input.value = value;
		      formObj.append(input);
		  });
	  }
	formObj.submit();
}


function openWindow(paramsMap){
	
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
	  
	  return window;
}


function displayNotification(paramMap){
	
	var msg = paramMap.get(MSG);
	
	Lobibox.notify('error', {
        size: 'mini',
        rounded: false,
        delayIndicator: false,
        position: 'center top',
        msg: msg,
        //img:contextPath + '/resources/images/1.png',
        //delay:500,
        iconSource:'fontAwesome'
    });
}

function isValidEmailAddress(emailAddress) {
    var pattern = new RegExp(/^(("[\w-\s]+")|([\w-]+(?:\.[\w-]+)*)|("[\w-\s]+")([\w-]+(?:\.[\w-]+)*))(@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)|(@\[?((25[0-5]\.|2[0-4][0-9]\.|1[0-9]{2}\.|[0-9]{1,2}\.))((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){2}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\]?$)/i);
    return pattern.test(emailAddress);
}

function somethingWentWrong(){
	Lobibox.alert("error",{
		msg : 'Something Went Wrong.'
	});
}

function alredyExist(){
	Lobibox.alert("info",{
		msg : 'Record Alredy Exist.'
	});
}

function infoMessage(msg){
	Lobibox.alert("info",{
		msg : msg
	});
}

function validPassword(str)
{
  // at least one number, one lowercase and one uppercase letter
  // at least six characters
  var re = /(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,}/;
  return re.test(str);
}

function callAjax(paramsMap){
	
	var methodType = paramsMap.hasKey(METHOD_TYPE) ? paramsMap.get(METHOD_TYPE) : 'POST';
	var url = paramsMap.hasKey(URL) ? paramsMap.get(URL) : contextPath + '/pages/ajax/postAjaxData.jsp';
	var postData = paramsMap.hasKey(DATA) ? paramsMap.get(DATA) : {};
	var dataType = paramsMap.hasKey(DATA_TYPE) ? paramsMap.get(DATA_TYPE) : 'json';
	var successHandler = paramsMap.hasKey(SUCCESS_HANDLER) ? paramsMap.get(SUCCESS_HANDLER) : 'defaultSuccessHandler';
	var errorHandler = paramsMap.hasKey(ERROR_HANDLER) ? paramsMap.get(ERROR_HANDLER) : 'defaultErrorHandler';
	
	$.ajax({
	      type: methodType,
	      url: url,
	      data: postData, 
	      dataType: 'json',
	      success: function(resultData) {
	    	  	console.log('resultData = ' + resultData);
	    	  	eval(successHandler + "()");
	    	 },
	    	 error: function (xhr, status) { 
	    		 console.log('ajax error = ' + xhr.statusText);
	    		 eval(errorHandler + "()");
	         } 
	});
}

function defaultSuccessHandler(){
	
}

function defaultErrorHandler(){
	
}

function timeDifference(date1, date2) {

	var difference = date1.getTime() - date2.getTime();

	var daysDifference = Math.floor(difference / 1000 / 60 / 60 / 24);
	difference -= daysDifference * 1000 * 60 * 60 * 24

	var hoursDifference = Math.floor(difference / 1000 / 60 / 60);
	difference -= hoursDifference * 1000 * 60 * 60

	var minutesDifference = Math.floor(difference / 1000 / 60);
	difference -= minutesDifference * 1000 * 60

	var secondsDifference = Math.floor(difference / 1000);

	var timeJson = {
		"days" : daysDifference,
		"hours" : hoursDifference,
		"minutes" : minutesDifference,
		"seconds" : secondsDifference
	}

	return timeJson;
}

function openFancyBox(obj, paramMap){
	
	var url = paramMap.get(URL);
	var width = paramMap.get(WIDTH) ? paramMap.get(WIDTH) : '50%';
	var height = paramMap.get(HEIGHT) ? paramMap.get(HEIGHT) : '50%';
	
	$(obj).fancybox({
		'href' : url,
		'autoSize' : false,
		'autoDimensions': false,
		'padding'       : 10,
		'width'         : width,
		'height'		: height,
		'autoScale'     : false,
		'transitionIn'  : 'none',
		'transitionOut' : 'none',
		 'type'          : 'iframe'
		 });
}


function getCursorPosition(element) {
    if (element.selectionStart) return element.selectionStart;
    else if (document.selection)
    {
        element.focus();
        var r = document.selection.createRange();
        if (r == null) return 0;

        var re = element.createTextRange(),
            rc = re.duplicate();
        re.moveToBookmark(r.getBookmark());
        rc.setEndPoint('EndToStart', re);
        return rc.text.length;
    }
    return 0;
}

var parseBool = function(str) {
    if (typeof str === 'string' && str.toLowerCase() == 'true')
            return true;

    return (parseInt(str) > 0);
}

function convertCaseArray(CapsArray, requiredCase){
    caseArray = [];
    for (var i = 0; i <CapsArray.length; i++) {
    		if(requiredCase === UPPER_CASE){
    			caseArray.push(decodeHTML(CapsArray[i].trim().toUpperCase()));
    		}else{
    			caseArray.push(decodeHTML(CapsArray[i].trim().toLowerCase()));
    		}
            
        }
 return caseArray;
}

function decodeHTML(escapedHtml) {
	  var elem = document.createElement('div');
	  elem.innerHTML = escapedHtml;
	  var result = '';
	  // Chrome splits innerHTML into many child nodes, each one at most 65536.
	  // Whereas FF creates just one single huge child node.
	  for (var i = 0; i < elem.childNodes.length; ++i) {
	    result = result + elem.childNodes[i].nodeValue;
	  }
	  return result;
}

function validateFloatKeyPress(el) {
    var v = parseFloat(el.value);
    el.value = (isNaN(v)) ? '' : v.toFixed(2);
}