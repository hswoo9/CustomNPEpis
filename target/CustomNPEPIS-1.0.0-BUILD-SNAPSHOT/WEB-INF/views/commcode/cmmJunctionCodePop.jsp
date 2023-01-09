<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>

<form id="sendForm" name="sendFormPop" method="post">
	<input type="hidden" name="param" value="" id="param"/>
	<input type="hidden" name="data" value="" id="data"/>
</form>


<script>
	/* 공통코드 url 설정 */
	var url = "/custExp/expend/np/user/NpCommonCodePop.do";
	var popupWidth = 600;
	var popupHeight = 400;
	var basicPopupType = "";
	/* 공통 팝업 호출 */
	function fnCallCommonCodePop(param, data){
		if(param.code != undefined){
			param.code = param.code.toLowerCase();	
		}
		data = (data || []);
		fnDirectSearchCommonCode(param, data);
	}
	
	/* 기본 팝업 오픈 */
	function fnOpenCommonCodeBasicPop (params, data){
		$("#param").val(JSON.stringify(params));
		$("#data").val(JSON.stringify(data));
		if(data.length == 1){
			/* 윈도우 팝업 콜백 */
			data[0].code = params.code;
			data[0].dummy = params.dummy;
    		var callbackFunc = window[params.callbackFunction];
    		if( typeof(callbackFunc) == "function" ){
    			callbackFunc(data[0]);
    		}else{
    			alert("콜백함수를 정의하여 주세요.");
    		}
		}else {
			var winHeight = document.body.clientHeight; // 현재창의 높이
			var winWidth = document.body.clientWidth; // 현재창의 너비
			var winX = window.screenX || window.screenLeft || 0;// 현재창의 x좌표
			var winY = window.screenY || window.screenTop || 0; // 현재창의 y좌표 
	
			var popX = winX + (winWidth - popupWidth)/2;
			var popY = winY + (winHeight - popupHeight)/2;
			
			var pop = window.open('', "UserCommonCodePop", "width=" + JSON.parse(params.param).widthSize + ", height=" + JSON.parse(params.param).heightSize + ", left=" + popX + ", top=" + popY);
	
			sendForm.target = "UserCommonCodePop";
			sendForm.method = "post";
			sendForm.action = url;
			sendForm.submit();
			sendForm.target = "";
			if(pop != null){
				if(pop.focus){
					pop.focus();
				}else{
					alert('팝업 차단 설정을 확인 하세요.');
				}
			}
		}
	}
	/* 레이어 팝업 오픈 */
	function fnOpenCommonCodeLayerPop (params, data){
		$("#param").val(JSON.stringify(params));
		$("#data").val(JSON.stringify(data));
		var title = '공통코드!';
		var parentId = '';
		var childrenId = '';
		/* 파라미터 설정 */
		var tempParam = [];
		var ajaxParam = {};
		tempParam["param"] = params;
		tempParam["data"] = data;
		ajaxParam.param = JSON.stringify(tempParam["param"]);
		ajaxParam.data = JSON.stringify(tempParam["data"]);
		$.ajax({
    		type:"post",
    		url: url,
    		datatype:"json",
    		data: ajaxParam, 
    		success:function(data){
    			var $parent;		//modal과 레이어가 들어갈 div 
    			var $children;		//레이어 div
    			
    			// 윈도우팝업에서 레이어팝업 띄울 경우
    			$("body").css("overflow", "hidden");
    			
    			if ($(".pop_wrap").size() > 0) {
    				$parent = $(".pop_wrap");
    	    	}
    	    	if ($(".pop_wrap_dir").size() > 0) {
    	    		$parent = $(".pop_wrap_dir");
    	    	}
    	    	$parent.append('<div id="modal" class="modal"></div>');
    	    	$parent.append(data)
    	    	$children = $(".pop_wrap");
    			childrenId = "";
    			
    			if (popupWidth != "") {
    				$children.css("width", "650");
    			}
    			if (popupHeight != "") {
    				$children.css("height", "450");
    			}
    			$children.css("border", "1px solid #adadad");
    			$children.css("z-index", "102");
    			
    			var popWid = $children.outerWidth();
    			var popHei = $children.outerHeight();
    			$children.css("top","50%").css("left","50%").css("marginLeft",-popWid/2).css("marginTop",-popHei/2);
    			$(window).resize(function(){
    				$children.css("top","50%").css("left","50%").css("marginLeft",-popWid/2).css("marginTop",-popHei/2);
    			});
    		}, error : function(data){
    		}
		});
	}
	
	/* 공통코드 호출 */
	function fnDirectSearchCommonCode(params, paramData){
		var tempParam = [];
		var ajaxParam = {};
		basicPopupType = params.popupType;
		tempParam["param"] = params;
		tempParam["param"].popupType = "1";
		tempParam["data"] = paramData;
		ajaxParam.param = JSON.stringify(tempParam["param"]);
		ajaxParam.data = JSON.stringify(tempParam["data"]);
		/* 공통코드 호출 */
		$.ajax({
	        type : 'post',
	        url : url,
	        datatype : 'json',
	        async : true,
	        data : ajaxParam,
	        success : function( data ) {
	        	
	        	if(!!(JSON.parse(params.param).selectedBudgetSeqs)){
	        		var newAaData = [];
	        		for(var i = 0; i < data.result.aaData.length; i++ ){
	        			var item = data.result.aaData[i];
	        			if( (JSON.parse(params.param).selectedBudgetSeqs.indexOf('|' + (item.erpBudgetSeq || item.BGT_CD) + '|') == -1) ){
	        				newAaData.push(item);
	        			}
	        		}
	        		data.result.aaData = newAaData;
	        	}
	        	
	        	if( data != null && data.result != null && data.result.aaData != null && data.result.aaData.length == 1){
	        		fnDirectSearchCallback(params, data);
	        	}else{
	        		params.popupType = basicPopupType;
		        	switch(params.popupType.toString()){
						case "1" :
							/* 공통코드 바로 조회 콜백 */
							fnDirectSearchCallback(params, data.result.aaData);
							break;
						case "2" :
							/* 일반팝업 호출 */
							fnOpenCommonCodeBasicPop(params, data.result.aaData);
							break;
						case "3" :
							/* 레이어팝업 호출 */
							fnOpenCommonCodeLayerPop(params, data.result.aaData);
							break;
						default :
							console.log("코드 조회 방식 미설정");
							break;
					}
	        	}
	        },
	        error : function( data ) {
	            console.log('오류다!확인해봐!이상해~!!악!');
	        }
	    });
	}
	
	/* 공통코드 직접 호출 후 콜백 처리 */
	function fnDirectSearchCallback( params, data ){
		/* 콜백 함수 호출 */
		var returnData = data.result.aaData[0];
		returnData.code = params.code; 
		returnData.dummy = params.dummy;
		var callbackFunc = window[params.callbackFunction];
		
		if(params.code == "card") {
			var cardData = new Array();
			cardData.push(data.result.aaData[0].cardCode + "|" + data.result.aaData[0].cardName);
			returnData = cardData;
		}
		
		if( typeof(callbackFunc) == "function" ){
			callbackFunc(returnData);
		}else{
			alert("콜백함수를 정의하여 주세요.");
		}
	}
	
	/* 레이어 팝업 닫는 함수 */
	function fnCloseLayerPop(){
		$(".pop_wrap").remove();
		$("#modal").hide();
		$("body").css("overflow", "auto");
	}
</script>

