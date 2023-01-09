
var _ajax;


function ajaxPOST(url, data, callback){
	if(_ajax) clearTimeout(_ajax);
	_ajax = setTimeout(function(){ ajaxPOST_(url, data, callback); },200);
}

function ajaxPOSTTxt(url, data, callback){
	if(_ajax) clearTimeout(_ajax);
	_ajax = setTimeout(function(){ ajaxPOSTTxt_(url, data, callback); },200);
}

function ajaxPOST_(url, data, callback){
	
	$.ajax({
	   type: "POST",
	   url: url,
	   data: $.param(data),
	   success: callback,
	   dataType:"json"
	});
}
function ajaxPOSTTxt_(url, data, callback){
	$.ajax({
	   type: "POST",
	   url: url,
	   data: data,
	   success: callback,
	   dataType:"json"
	});
}

function ajaxGET(url, data, callback){
	$.ajax({
	   type: "GET",
	   url: url,
	   data: $.param(data),
	   success: callback,
	   dataType:"json"
	});
}
/*  ---------------------------------------------  */
/*  Add KOFIA  START */
function ajaxAyncPOST_(url, data, callback){
	ajaxAyncPOSTTxt_(url, $.param(data), callback);
}
function ajaxAyncPOSTTxt_(url, data, callback){
	$.ajax({
	   type: "POST",
	   url: url,
	   async: false,
	   data: data,
	   success: callback,
	   dataType:"json"
	   //contentType: "application/x-www-form-urlencoded; charset=UTF-8", 
	   //dataType: "text"
	});
}
/*  Add KOFIA  END */
/*  ---------------------------------------------  */
