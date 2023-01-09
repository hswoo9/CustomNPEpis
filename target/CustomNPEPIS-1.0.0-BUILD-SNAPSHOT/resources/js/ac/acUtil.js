/**
 * 
 * G20 연동 관련 js 파일
 * 주로 ajax call 할때 사용한다..
 * 
 * 1. 최상위 객체 : acUtil
 * 2. ajax handler : acUtil.ajax
 * 3. 외부에서 ajax 호출하는 메서드 : acUtil.ajax.call(opt, extendObj)
 *    - opt : ajax 옵션
 *    - extendObj : 결과 데이터 저장할 Object
 * 
 */
var acUtil = {};

 
/*
 *ajax 호출을 위한 Object
 *  */
acUtil.ajax = {};
/*
 * javascript util 을 위한 Object
 * */
acUtil.util ={};
acUtil.util.dialog = {};
/*dialog 핸들링 하는 객체*/


/*기본 단축키 설정들 시작*/
acUtil.init = function(context){
	var body = $("body");
	if(!context){
		context =  body;	
	}
	
	$(".non-requirement, .requirement", context).bind({
		keyup : function(event){
			var eventEle = $(this);
			var code = event.keyCode;
			acUtil.util.nextTabIndex(eventEle, code);
		},
		focus : function(){ 
			$(this).select();	
		}
	});	
};

/*기본 단축키 설정들 시작*/
acUtil.init_trade = function(context){
	var body = $("body");
	if(!context){
		context =  body;	
	}
	$(".non-requirement, .requirement", context).bind({
		keyup : function(event){
			var eventEle = $(this);
			var code = event.keyCode;			
			if(gwOption.auto_search && gwOption.auto_search =="Y"){
				var isTrNm =  eventEle.hasClass("txt_TR_NM");
				if(isTrNm){
					if(code ==  13){
						eventEle.dblclick();
					}else{
						acUtil.util.nextTabIndex(eventEle, code);
					}
				}else{
					acUtil.util.nextTabIndex(eventEle, code);
				}			
			}else{
				acUtil.util.nextTabIndex(eventEle, code);
			}
		}
	,
		focus : function(){ 
			//$(this).select();	
		}
	});	
};

/*기본 단축키 설정들 끝*/
acUtil.util.nextTabIndex = function(eventEle, code){
	var parentEle = eventEle.parents("tr");
	if(!parentEle.length){
		parentEle = eventEle.parents("ul");
	}
	if(!parentEle.length){
		parentEle = eventEle.parents("div");
	}
	
	var isRequirement =  eventEle.hasClass("requirement");
	
	if(code ==  13){/*Enter*/
		var tabindex = eventEle.attr("tabindex");
		var tempIndex = parseInt(tabindex, 10);
		
		var focusEle =$("[tabindex="+(tempIndex + 1)+"]", parentEle);  
		if(focusEle.attr("disabled")=="disabled"){
			for(var i = 1, max = 100; i<max; i++){
				if(focusEle.attr("part")){
					
					acUtil.focusNextRow(focusEle);
					break;
					return;
				}
				focusEle =$("[tabindex="+(tempIndex + 1 + i) +"]", parentEle); 
			}
		}
		else{
			if(isRequirement){/*필수값일때*/
				if(eventEle.val() && eventEle.attr("code")){
					if(!focusEle.length){/*값이 있고, 다음 열(컬럼)이 없을땐 다음 행으로 이동함*/
						
						acUtil.focusNextRow(eventEle);
					}
					else{
						focusEle.focus();
					}
				}
			}
			else{
				if(!focusEle.length && eventEle.attr("part")){/*다음 행으로 이동*/ 
					
					acUtil.focusNextRow(eventEle);
				}
				else{
					focusEle.focus();
				}
			}
		} 
	}
	else if (code == 113){/*F2*/
		eventEle.dblclick();
	}	
};

/*ajax 를 호출 해주는 함수*/
acUtil.ajax.call = function(opt, extendObj){
	var ajaxcall = new acUtil.ajax.call_process(extendObj);
	acUtil.ajax.set(ajaxcall,opt);
	try{
		ajaxcall.call();
	}catch(e){
		alert(e.message);
	}
};

/*dialog 띄우기 전 실행되는 함수(모든 함수는 이 함수를 통해서 실행된다.)*/
acUtil.util.dialog.dialogDelegate = function(fn, param, index, returnFn, tblParam){
	var eventEle = null;
	acUtil.util.popEle = null;
	if(param && param[0] && param[0].id){
		eventEle = $("#" + param[0].id);
		if(eventEle.length){
			acUtil.util.popEle = eventEle;
		}
	}
	if(!acUtil.util.dialog.preProcessing(param)){
		return;
	}
	//edit mode 인지 체크(보류)
	//$(".editmode:visible").length
	param =  param || {};
	if(typeof fn==="function"){
		fn(param, index, returnFn, tblParam);
	}
};

/*dialog 를 띄워주는 함수*/
acUtil.util.dialog.setData = function(paramMap, searchObj){

	/*더블 클릭시 실행될 함수 시작*/
	var trDblClickHandler =  function(dblClickparamMap, index){
        var data = acUtil.modalData.selectList[index]; 
        
        for(var i = 0, max = dblClickparamMap.length;i<max;i++){
        	var tmpObj = dblClickparamMap[i];

            var text = data[tmpObj.text];
            var code = data[tmpObj.code];        	
        	
        	var ele = $("#" + tmpObj.id);
        	if(!ele.length){
        		ele = $("." + tmpObj.id);
        	}
            ele.val(text || "").attr("CODE", code|| "");
        }

        acUtil.util.dialog.dialogClose();
        try{
        	var eventEle = $("#" + dblClickparamMap[0].id);
        	acUtil.util.nextTabIndex(eventEle, 13);
        }catch(e){}
              
	};
	/*더블 클릭시 실행될 함수 시작 끝*/
	
	var loopData = paramMap.loopData || [];  
	var divID = acUtil.util.dialog.getBindID(acUtil.dialogForm);/*테이블을 감싸는 div*/
	var colNames = paramMap.colNames; /*모달 열 이름들*/
	var colModel = paramMap.colModel;/*열 구성하는 td 구성 하는  정보*/
	var trDblClickHandler_UserDefine = paramMap.trDblClickHandler_UserDefine; /*더블 클릭시 실행될 함수 시작 - 사용자정의*/
	
	var div = $("#" + divID);
	var table = $("#" + divID + "-table", div);
	$("tr:gt(1)", table).remove();
	var trClass = divID + "-table-tr";
	 
	if(!$("tr.searchLine", div).length){ /*검색시에는 제목과, 검색영역을 다시 그려주지 않는다.*/ 
		/*th(제목) 영역 시작*/
		var tr = $("<tr>"); 
//		tr.append('<th scope="col" width="30">&nbsp;</th>');
		for(var i= 0, max=colNames.length;i<max;i++){
			var td = $("<th>").attr("scope", "col").html(colNames[i]);
			if(paramMap.colWidth && paramMap.colWidth[i]){
				td.css("width", paramMap.colWidth[i]);
			}
			tr.append(td);
		}
		table.append(tr);
		/*th(제목) 영역 끝*/
	
		/*td 검색 영역 시작*/
		var tr = $("<tr>").addClass("searchLine");	
//		tr.append('<td><img src="' +_g_contextPath_+ '/images/erp/btn_search01.gif" alt="search" /></td>');
		if(colModel && colModel.length){
			for(var i= 0, max=colNames.length;i<max;i++){
				
				var id = colModel[i].text || "";
				
				var input = $("<input>").attr("type","text").attr("CODE", id).attr("style", "width:90%");
				//var input = $("<input>").attr("type","text").attr("CODE", id);
				(function(input_p, paramMap_p){
					input_p.bind({
						keypress : function(event){
							if(event.keyCode == 13){
								var code = $(this).attr("CODE");
								var text = $(this).val();
								var searchObj = {code : code,
										text : text
										};
								acUtil.util.dialog.setData(paramMap_p, searchObj);
							}
						}
					});				
				})(input, paramMap);
	
				var td = $("<td>").append(input);
				tr.append(td);
			}
			table.append(tr);
		}
		/*td 검색 영역 끝*/
	}


	
	/**
	 *  거래처 정보 등 데이터가 많을 경우에는 grid 에 뿌려주지 않는다. 
	 *  검색시에는 뿌려준다.
	 */
	if(!paramMap.NoBind || searchObj){ 
		/*리스트(본문) 영역 시작*/
		for(var i=0, max = loopData.length; i<max; i++)
		{
			var tr = "<tr class='"+trClass+"' index='"+i+"'>";
			//var tr = $("<tr>").addClass(trClass).attr("index", i);
			//tr.append('<td></td>');
			var isSearch = false;		
			var colData = loopData[i];
			if(searchObj && searchObj.code && searchObj.text){
				if(colData[searchObj.code] == null){
					continue;
				}else{
				var _o = colData[searchObj.code].toLowerCase() || "";
				var _s = searchObj.text.toLowerCase() || "";
				if(_o.toString().indexOf(_s) < 0){
					isSearch = true;
				}
				}
			}
			if(max > 1 && !searchObj ){
				//continue;
			} 
			for(var j=0, jMax = colModel.length; j<jMax; j++)
			{	
				var text = colData[colModel[j].text] || "";
				var code = colData[colModel[j].code] || "";
				
				var style = colModel[j].style || {};
				//var td = $("<td>").addClass(code).html(text);
				var css = "";
				for(var item in style){
					css += item.toString() + ":" + style[item] + ";";
					//td.css(item.toString(), style[item]);
				}
				var td = "<td class='"+code+"' style='"+css+"'>"+text+"</td>";
				//tr.append(td);
				tr += td;
			}
			tr += "</tr>";
			if(!isSearch){
				table.append(tr);
			}
			tr = "";
		} 
		
		$("." +trClass).bind({
			click : function(event){  
			},
			dblclick: function(){
				dblClickparamMap = paramMap.dblClickparamMap;
				var tr = $(this);
				var index = tr.attr("index");
				(function(idx, fn){
					trDblClickHandler(dblClickparamMap, idx);
					if(fn && typeof fn === "function"){
						fn(idx, dblClickparamMap);
					}				
				})(index, trDblClickHandler_UserDefine);			
			}
		});		
		/*리스트(본문) 영역 끝*/	
	}

	acUtil.util.dialog.eventBind(paramMap, searchObj);	
	if(!searchObj){
		$("#" + acUtil.dialogForm).focus();
	}
	
	setTimeout(acUtil.util.dialog.setFocusZero, 30);
	
};

acUtil.util.dialog.setFocusZero = function (){
	/* scrollTop ㄱㄱ */
	try{
	$('#dialog-form-standard-bind').scrollTop(0)
	}catch(e){
		console.log('스크롤 초기화 실패');
	}	
}

/*dialog 를 띄워주는 함수*/
acUtil.util.dialog.setData_Trade = function(paramMap, searchObj){

	/*더블 클릭시 실행될 함수 시작*/
	var trDblClickHandler =  function(dblClickparamMap, index){
        var data = acUtil.modalData.selectList[index]; 
        
        for(var i = 0, max = dblClickparamMap.length;i<max;i++){
        	var tmpObj = dblClickparamMap[i];

            var text = data[tmpObj.text];
            var code = data[tmpObj.code];        	
        	
        	var ele = $("#" + tmpObj.id);
        	if(!ele.length){
        		ele = $("." + tmpObj.id);
        	}
            ele.val(text || "").attr("CODE", code|| "");
        }

        acUtil.util.dialog.dialogClose();
        try{
        	var eventEle = $("#" + dblClickparamMap[0].id);
        	acUtil.util.nextTabIndex(eventEle, 13);
        }catch(e){}
              
	};
	/*더블 클릭시 실행될 함수 시작 끝*/
	
	var loopData = paramMap.loopData || [];  
	var divID = acUtil.util.dialog.getBindID(acUtil.dialogForm);/*테이블을 감싸는 div*/
	var colNames = paramMap.colNames; /*모달 열 이름들*/
	var colModel = paramMap.colModel;/*열 구성하는 td 구성 하는  정보*/
	var trDblClickHandler_UserDefine = paramMap.trDblClickHandler_UserDefine; /*더블 클릭시 실행될 함수 시작 - 사용자정의*/
	
	var div = $("#" + divID);
	var table = $("#" + divID + "-table", div);
//	table.attr("style", "max-width:1220px");
	$("tr:gt(1)", table).remove();
	var trClass = divID + "-table-tr";
	 
	if(!$("tr.searchLine", div).length){ /*검색시에는 제목과, 검색영역을 다시 그려주지 않는다.*/ 
		/*th(제목) 영역 시작*/
		var tr = $("<tr>"); 
		//tr.append('<th scope="col" width="30">&nbsp;</th>');
		for(var i= 0, max=colNames.length;i<max;i++){
			var td = $("<th>").attr("scope", "col").html(colNames[i]);
			tr.append(td);
		}
		table.append(tr);
		/*th(제목) 영역 끝*/
	
		/*td 검색 영역 시작*/
		var tr = $("<tr>").addClass("searchLine");	
//		tr.append('<td><img src="' +_g_contextPath_+ '/images/erp/btn_search01.gif" alt="search" /></td>');
		if(colModel && colModel.length){
			for(var i= 0, max=colNames.length;i<max;i++){
				
				var id = colModel[i].text || "";
				
				var input = $("<input>").attr("type","text").attr("CODE", id).attr("style", "width:90%");
//				var input = $("<input>").attr("type","text").attr("CODE", id);
				(function(input_p, paramMap_p){
					input_p.bind({
						keypress : function(event){
							if(event.keyCode == 13){
								var code = $(this).attr("CODE");
								var text = $(this).val();
								var searchObj = {code : code,
										text : text
										};
								acUtil.util.dialog.setData_Trade(paramMap_p, searchObj);
							}
						}
					});				
				})(input, paramMap);
	
				var td = $("<td>").append(input);
				tr.append(td);
			}
			table.append(tr);
		}
		/*td 검색 영역 끝*/
	}


	
	/**
	 *  거래처 정보 등 데이터가 많을 경우에는 grid 에 뿌려주지 않는다. 
	 *  검색시에는 뿌려준다.
	 */
	if(!paramMap.NoBind || searchObj){ 
		/*리스트(본문) 영역 시작*/
		for(var i=0, max = loopData.length; i<max; i++)
		{
			var tr = "<tr class='"+trClass+"' index='"+i+"'>";
			//var tr = $("<tr>").addClass(trClass).attr("index", i);
			//tr.append('<td></td>');
			var isSearch = false;		
			var colData = loopData[i];
			if(searchObj && searchObj.code && searchObj.text){
				
				if(colData[searchObj.code] == null){
					continue;
				}else{
				    var _o = colData[searchObj.code].toLowerCase() || "";
				    var _s = searchObj.text.toLowerCase() || "";
				    //if(_o.length > 0 && _o.toString().indexOf(_s) < 0){
				    if(_o.toString().indexOf(_s) < 0){
					     isSearch = true;
				    }
				}				
			}
			if(max > 1 && !searchObj ){
				//continue;
			} 
			for(var j=0, jMax = colModel.length; j<jMax; j++)
			{	
				var text = colData[colModel[j].text] || "";
				var code = colData[colModel[j].code] || "";
				
				var style = colModel[j].style || {};
				//var td = $("<td>").addClass(code).html(text);
				var css = "";
				for(var item in style){
					css += item.toString() + ":" + style[item] + ";";
					//td.css(item.toString(), style[item]);
				}
				var td = "<td class='"+code+"' style='"+css+"'>"+text+"</td>";
				//tr.append(td);
				tr += td;
			}
			tr += "</tr>";
			if(!isSearch){
				table.append(tr);
			}
			tr = "";
		} 
		if(gwOption.auto_search && gwOption.auto_search =="Y"){
		/** 조회건이 한건일때 자동선택 **/
			if(loopData.length == 1 ){
				dblClickparamMap = paramMap.dblClickparamMap;
				(function(idx, fn){
					trDblClickHandler(dblClickparamMap, idx);
					if(fn && typeof fn === "function"){
						fn(idx, dblClickparamMap);
					}
				})(0, trDblClickHandler_UserDefine);
			}
		}
		
		$("." +trClass).bind({
			click : function(event){  
			},
			dblclick: function(){
				dblClickparamMap = paramMap.dblClickparamMap;
				var tr = $(this);
				var index = tr.attr("index");
				(function(idx, fn){
					trDblClickHandler(dblClickparamMap, idx);
					if(fn && typeof fn === "function"){
						fn(idx, dblClickparamMap);
					}				
				})(index, trDblClickHandler_UserDefine);			
			}
		});		
		/*리스트(본문) 영역 끝*/	
	}

	
	
	acUtil.util.dialog.eventBind(paramMap, searchObj);	
	if(!searchObj){
		$("#" + acUtil.dialogForm).focus();
	}
	
	setTimeout(acUtil.util.dialog.setFocusZero, 30);
};


/*js 내부적으로 ajax 호출해주는 함수(외부에서 호출 금지)*/
acUtil.ajax.call_process = function(extendObj){
	
	this.url = "";
	this.datatype = "json"; 
	this.data = {};
	this.async = true;
	this.type = "post";
	this.stateFn = function(){};
	this.successFn = function(){};
	this.failFn = function(){};
	
	
	this.call = function(){ 
		var stateFn = this.stateFn;
		stateFn(true);
		var successFn = this.successFn;
		var failFn = this.failFn;
		$.ajax({
			type:this.type,
			url:this.url,
			datatype:this.datatype,
			data:this.data,
			async:this.async,
			success:function(data){
				extendObj = $.extend(extendObj || {} , data);
				stateFn(false);
				successFn(data);
			},
			error:function(e,ee){
				stateFn(false);
				failFn(e); 
			}
		});	
	};
};

/* acUtil.ajax.call_process 객체 인스턴스에
 * option(opt) 값 셋팅
 * */
acUtil.ajax.set = function(ajaxcall,opt){
	if(!ajaxcall || !opt){
		return false;
	}
	
	for(var item in opt){
		if(item){
			if(opt[item.toString()] != null && typeof opt[item.toString()] != "undefined" && opt[item.toString()].toString() != "" ){
				ajaxcall[item.toString()] = opt[item];
			}
		}
	}
};

/*ajax.call_process get/set 메서드 시작*/
/*주소 get/set*/
acUtil.ajax.call_process.prototype.url = function(url){
	if(url){
		this.url = url;
	}
	return this.url;
};
/*datatype get/set*/
acUtil.ajax.call_process.prototype.datatype = function(datatype){
	if(datatype){
		this.datatype = datatype;
	}
	return this.datatype.toString();
};
/*data get/set*/
acUtil.ajax.call_process.prototype.data = function(data){
	if(data){
		this.data = data;
	}
	return this.data;
};
/*async(비동기여부) get/set*/
acUtil.ajax.call_process.prototype.async = function(async){
	if(async){
		this.async = async;
	}
	return this.async;
};
/*method type(get, post) get/set*/
acUtil.ajax.call_process.prototype.type = function(type){
	if(type){
		this.type = type;
	}
	return this.type.toString();
};
/*ajax 호출하는 동안 실행될 메서드*/
acUtil.ajax.call_process.prototype.stateFn = function(stateFn){
	if(stateFn){
		this.stateFn = stateFn;
	}
	return this.stateFn;
};

/*ajax 호출이 성공했을경우*/
acUtil.ajax.call_process.prototype.successFn = function(successFn){
	if(successFn){
		this.successFn = successFn;
	}
	return this.successFn;
};
/*ajax 호출이 실패했을경우*/
acUtil.ajax.call_process.prototype.failFn = function(failFn){
	if(failFn){
		this.failFn = failFn;
	}
	return this.failFn;
};
/*ajax.call_process get/set 메서드 끝*/


/*현재 날짜의 년 월 일 시 초 밀리초(17자리) 리턴*/
acUtil.util.getUniqueTime = function(){
var getdate = new Date();
var year = getdate.getFullYear();
var month = getdate.getMonth() + 1;
var date = getdate.getDate();
var hours = getdate.getHours();
var minute = getdate.getMinutes(); 
var sec = getdate.getSeconds();
var millisec = getdate.getMilliseconds();

var timeUnique = "" + year + acUtil.util.setNumTwo(month) 
				 	+ acUtil.util.setNumTwo(date) 
				 	+ acUtil.util.setNumTwo(hours)
				 	+ acUtil.util.setNumTwo(minute)
				 	+ acUtil.util.setNumTwo(sec)
				 	+ acUtil.util.setNumTwo(millisec, true);
return timeUnique;
};
/*월(2자리), 일(2자리), 시간(2자리), 초(2자리), 밀리초(3자리) 자리수 맞추기*/
acUtil.util.setNumTwo = function(num, isMilli)
{
	var set = 2;
	if(isMilli)set = 3;
	var numStr = "" + num;
	if(numStr.length < set){
		if(!isMilli){
			return "0" + 	numStr;
		}
		else{
			if(("0" + 	numStr).length< set){
				return "00" + 	numStr;
			}else{
				return "0" + 	numStr;
			}
		}
	}
	else return numStr;
};


/*dialog 열기*/
acUtil.util.dialog.open = function(dialogParam){	
	
	
	var dialogForm = $("#" + acUtil.dialogForm);
	var dialogFormBind = $("#" + acUtil.util.dialog.getBindID(acUtil.dialogForm));
	dialogFormBind.html("");

	dialogFormBind.attr("id", acUtil.util.dialog.getBindID(acUtil.dialogForm)).addClass("com_ta2");
	//dialogForm.append(dialogFormBind);
	
	var table = $("<table>").attr("id", acUtil.util.dialog.getBindID(acUtil.dialogForm) + "-table");
	dialogFormBind.append(table);
	
	var title = dialogParam.title;	
	$("body").css("overflow", "hidden");
	if($("#dialog-form-background").size() > 0){
		$("#dialog-form-background").show();
	}else{
		var $parent;
		if ($(".sub_wrap").size() > 0) {
			$parent = $(".sub_wrap");
		}
		else{
			if ($(".sub_contents_wrap").size() > 0) {
				$parent = $(".sub_wrap");
			}
		}		
		$parent.append('<div id="dialog-form-background" class="modal"></div>');
	}
	
	// top 수정 100px -> 50px
	//dialogForm.css("left", "50%").css("width", dialogParam.width).css("marginLeft",-dialogParam.width/2).css("position", "absolute").css("z-Index", "9999").css("top", "100px").show();
	dialogForm.css("left", "50%").css("width", dialogParam.width).css("marginLeft",-dialogParam.width/2).css("position", "absolute").css("z-Index", "9999").css("top", "50px").show();
	
	$(".top_box", dialogForm).hide();
	$(".pop_head h1", dialogForm).html(dialogParam.title);
	$("#"+dialogParam.showDiv , dialogForm).show();
};

acUtil.util.dialog.getBindID = function(dialogForm){
	return dialogForm + "-bind";
};
acUtil.util.dialog.eventBind = function(paramMap, searchObj){
	
	$("#" + acUtil.dialogForm).unbind("keyup");
	$("#" + acUtil.dialogForm).bind({
		keyup : function(event){
			var table = $("#" + acUtil.util.dialog.getBindID(acUtil.dialogForm) + "-table");
			var tr = $("." +acUtil.util.dialog.getBindID(acUtil.dialogForm)+"-table-tr", table);
			
			
			var selectTr = $("." + acUtil.dialogSelect , $("#" + acUtil.dialogForm));
			var index = -1;
			if(selectTr.length){
				index = selectTr.first().attr("index");
			}
			index = parseInt(index, 10 );
			if(isNaN(index)){
				index = -1;
			}
			
			
			//38 : up
			//40 : down
			//27 : esc
			
			if(event.keyCode == 40){
				selectTr.removeClass(acUtil.dialogSelect);
				index = index + 1;
				if(index>= tr.length){
					index = tr.length - 1;
				}
				$(tr[index]).addClass(acUtil.dialogSelect).focus();
			}
			else if(event.keyCode == 38){
				selectTr.removeClass(acUtil.dialogSelect);
				index = index - 1;
				if(index < 0){
					index = 0;
				}
				$(tr[index]).addClass(acUtil.dialogSelect).focus();				
			}
			else if(event.keyCode == 13){
				var selectTr = $("." + acUtil.dialogSelect, $("#" + acUtil.dialogForm)); 
				if(selectTr.length){
					$(tr[index]).dblclick(); 
				}
			}
			else if(event.keyCode == 27){
				
				acUtil.util.dialog.dialogClose();
				/**
				 *이벤트 발생시킨 intut 에 포커스~ 
				 */
				if(acUtil.util.popEle){
					acUtil.util.popEle.focus();
				}
			}
		}
	});	
	
	var table = $("#" + acUtil.util.dialog.getBindID(acUtil.dialogForm) + "-table");
	var tr = $("."+acUtil.util.dialog.getBindID(acUtil.dialogForm)+"-table-tr", table).css("cursor", "pointer");
	tr.bind({
		click : function(evt){
			try{
				var index =$(evt.target).parents("tr").first().attr("index");
				$("." + acUtil.dialogSelect, $("#" + acUtil.dialogForm)).removeClass(acUtil.dialogSelect);
				$(tr[index]).addClass(acUtil.dialogSelect);				
			}catch(e){
				
			}
		}
	});
	
	$(".popClose").click(function(){
		acUtil.util.dialog.dialogClose();
	});
	
	
	/* 거래처 정보 체크박스 클릭 */
	$("#tradeAllview").unbind("click");
	$("#tradeAllview").bind({
		click : function(){
			var checked = this.checked;
			if(checked){
				paramMap.NoBind = false;
				searchObj = searchObj || {}; 
				var c = confirm(NeosUtil.getMessage("TX000011150","거래처 정보를 모두 보여줄 경우 시간이 오래 걸릴 수 있습니다. 계속 하시겠습니까?"));
				if(!c){
					return false;
				}
				else{
					$("tr.searchLine input[type=text").val("");
				}
			}
			else{
				paramMap.NoBind = true;
				searchObj = null;
			}
			acUtil.util.dialog.setData_Trade(paramMap, searchObj);
		}
	});
};

/*NextROW 함수에서 실행될 현재 row 의 validatin check */
acUtil.util.validationCheck = function(context, eventEle){
	$("." + acUtil.invalidClass).removeClass(acUtil.invalidClass);
	//var context = $("body");
	if(!context){
		context = $("body");
	}
	if(eventEle){
		context = eventEle.parents("tr");
	}
	var requirement = $(".requirement", context);

	var requiredInput = $.map(requirement, function(n,i){
		return $(n).attr("id");
	});
	
	var isValid = true;
	var inValidList = [];
	
	for(var i = 0, max = requiredInput.length; i< max; i++){
		var ele = $("#" + requiredInput[i]);
		var val = ele.val();
		var code = ele.attr("CODE");
		
		ele.parent().find("div").html(val);
		
		if(!$.trim(val) || !$.trim(code)){
			isValid = false;
			inValidList[ inValidList.length] = requiredInput[i];
		}
	}
	if(!isValid){
		alert(NeosUtil.getMessage("TX000011209","입력되지 않은 값이 있습니다. 확인해주세요."));
		acUtil.util.markInvalidForm(inValidList);
		$("#" + inValidList[0]).focus();
	}
	else{
		return true;
	}
};

/*Validation 통과 못한 element 들 invalid class  추가*/
acUtil.util.markInvalidForm = function(invalidList){
	
	if(!$.isArray(invalidList)){
		return;
	}
	
	for(var i = 0, max = invalidList.length; i< max; i++){
		$("#" + invalidList[i]).addClass(acUtil.invalidClass);
	}
};

/*dialog 닫기*/
acUtil.util.dialog.dialogClose = function(){
	$("#" + acUtil.dialogForm).hide();
	$("#dialog-form-background").hide();
	$("body").css("overflow", "auto");
    //$( "#" + acUtil.dialogForm ).dialog( "close" );
};

/*dialog 옵션내용 적용(acUtil.util.dialog.open 에서 호출함)*/
acUtil.util.dialog.init = function(paramOpt){
    var opt = {/*항상 동일한 옵션*/
            autoOpen: false,
            //height: 300,
            //width: 750,
            modal: true,
            buttons: {
                Cancel: function() {
                	acUtil.util.dialog.dialogClose();
                }
            }
        };
    /*고정적인 옵션과, 파라미터로넘어온 옵션 객체 합치기*/
	 opt = $.extend(opt, paramOpt);
    $( "#" + acUtil.dialogForm ).dialog(opt); 
};

/*keycode 가 숫자인지 확인*/
acUtil.util.isKeyCodeNum = function(keycode){
	return (keycode >= 48 && keycode <= 57) || (keycode >= 96 && keycode <= 105);
};

/*select box 에 option 추가해줌*/
acUtil.util.makeSelect = function(obj, code, text, selectID){
	
	var select = $("#" + selectID);
	for(var i = 0, max = obj.length; i< max; i++){
		var option = $("<option>").val(obj[i][code]).text(obj[i][text]);
		select.append(option);
	}	
};

acUtil.util.validMoneyKeyCode = function(keycode){
    // 숫자패드 마이너스키 추가 keycode == 109 2013.724
	if(keycode == 8 || keycode == 13 || keycode == 9 | keycode == 16
	|| acUtil.util.isKeyCodeNum(keycode)
	|| keycode == 189 || keycode == 109|| keycode == 190 || keycode == 110
	|| keycode == 37 || keycode == 38 || keycode == 39 || keycode == 40){
		return true;
	} 
	else {
		return false;
	}
};
acUtil.util.getParamObj = function(){
	var obj = {};
	
	var url = document.location.href;
	url = url.split("?")[1] || "";
	var paramList = url.split("&") || [];
	for(var i =0, max= paramList.length; i< max ; i++){
		var _t = paramList[i].split("=");
		obj[_t[0]] = _t[1];
	}
	return obj;
};
String.prototype.toMoney  = function(){
	
	var val = (this.valueOf() || '0');
	var zero = val.charAt(0);

	var money = val.replace(/\D/g,"");
	var index = money.length - 3;
	while(index >0){
		money = money.substr(0,index) + "," + money.substr(index);
		index -=3;
	}
	if(zero == "-"){
		return "-" + money;
	}else{
		return money; 
	}
};
String.prototype.toMoney2  = function(){
	
	var val = (this.valueOf() || '0');
	var zero = val.charAt(0);

	var money = val.replace(/\D/g,"");
	
	if(zero == "-"){
		return "-" + money;
	}else{
		return money; 
	}
};

acUtil.util.numOnly = function(e){
	if (e.which && (e.which  > 47 && e.which  < 58 || e.which == 8)) {
	} else {
		e.preventDefault();
	}
};

/*dialog 띄우기 전 띄워도 되는지 체크*/
acUtil.util.dialog.preProcessing = function(param){
	var returnBool = false;
	if(!param || !$.isArray(param)){
		returnBool = false;
	}
	else{
		returnBool = true;
	}
	return returnBool;
	//param
};

function modal_bg(state){
	if(state){
		if($("#dialog-form-background").size() > 0){
			$("#dialog-form-background").show();
		}else{
			var $parent;
			if ($(".sub_wrap").size() > 0) {
				$parent = $(".sub_wrap");
			}
			else{
				if ($(".sub_contents_wrap").size() > 0) {
					$parent = $(".sub_wrap");
				}
			}
			$parent.append('<div id="dialog-form-background" class="modal"></div>');
		}
		var img = $("<img>").attr("id", "g20-ajax-img").attr("src", _g_contextPath_ + "/Images/ico/loading.gif")
		.css("position", "absolute").css("top", "50%").css("left", "50%").css("margin-top", "-5").css("margin-left", "-5").css("zIndex", "100000");
		$("body").append(img); 
	}
	else{
		$("#dialog-form-background").hide(); 
		$("#g20-ajax-img").remove();
	}
};

function modal(state){
	if(state){		
		$("#dialog-form-background_dir").show();
		var img = $("<img>").attr("id", "g20-ajax-img").attr("src", _g_contextPath_ + "/Images/ico/loading.gif")
		.css("position", "absolute").css("top", "50%").css("left", "50%").css("margin-top", "-5").css("lefmargin-leftt", "-5").css("zIndex", "100000");
		$("body").append(img);  
	}
	else{
		$("#dialog-form-background_dir").hide(); 
		$("#g20-ajax-img").remove();
	}
};

/*레이어팝업***************************************************************************************************/    

//팝업열기 
function acLayerPopOpen(url, param, width, height, childrenId) {
//	$("html, body").scrollTop(0);
							
	$.ajax({
		type:"post",
		url: url,
		datatype:"json",
		data: param, 
		success:function(data){
			var $parent;		//modal과 레이어가 들어갈 div 
			var $children;		//레이어 div
			
			$("body").css("overflow", "hidden");
  		
			if ($(".pop_sign_wrap").size() > 0) {
				$parent = $(".pop_sign_wrap");
			}
			
			if(childrenId){
				$parent.append('<div id="modal_'+childrenId+'" class="modal"></div>');
				$parent.after(data);
				$children = $("#"+childrenId);
			}
	
			if (width != "") {
				$children.css("width", width);
			}
			if (height != "") {
				$children.css("height", height);
			}
			$children.css("border", "1px solid #adadad");
			$children.css("z-index", "20");

			var popWid = $children.outerWidth();
			var popHei = $children.outerHeight();

			$children.css("top","50%").css("left","50%").css("marginLeft",-popWid/2).css("marginTop",-popHei/2);

		},
		error : function(data){
			//alert(data.exMsg);
		}
	 }); 
}

//팝업닫기
function acLayerPopClose(childrenId) {
	if (childrenId) {
		$("#" + childrenId).remove();
		$("#modal_" + childrenId).remove();
	}
	$("body").css("overflow", "auto");
//	acUtil.init();
}