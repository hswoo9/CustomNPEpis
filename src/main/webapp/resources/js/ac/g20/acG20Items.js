/**
 *
 * 지출결의서/지출품의서 js 파일
 *
 */

var abdocu_d = {};

abdocu_d.stateMent = {}; 

function ItemsValidationCheck(context, eventEle){
	$("." + acUtil.invalidClass).removeClass(acUtil.invalidClass);
	//var context = $("body");
	if(!context){
		context = $("body");
	}

	if(eventEle){
		if($('#ItemsFormPop').css('display') != undefined && $('#ItemsFormPop').css('display') != 'none'){
			context = $('#ItemsFormPop').find('#' + eventEle.attr('id')).parents('tr');
		}
		else {
			context = eventEle.parents("tr");
		}
	}
	var requirement = $(".requirement", context);

	var requiredInput = $.map(requirement, function(n,i){
		return $(n).attr("id");
	});
	
	var isValid = true;
	var inValidList = [];
	
	for(var i = 0, max = requiredInput.length; i< max; i++){
		var ele;
		if($('#ItemsFormPop').css('display') != undefined && $('#ItemsFormPop').css('display') != 'none'){
			ele = $('#ItemsFormPop').find("#" + requiredInput[i]);
		}
		else {
			ele = $("#" + requiredInput[i]);
		}
		var val = ele.val();
		if(!$.trim(val)){
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

function init(context){
	var body = $("body");
	if(!context){
		context =  body;	
	}
	
	$(".non-requirement, .requirement", context).bind({
		keyup : function(event){
			var eventEle = $(this);
			var code = event.keyCode;
			nextTabIndex(eventEle, code);
		},
		focus : function(){ 
			$(this).select();	
		}
	});	
};

/*기본 단축키 설정들 끝*/
function nextTabIndex(eventEle, code){
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
					focusNextRow(focusEle);
					break;
					return;
				}
				focusEle =$("[tabindex="+(tempIndex + 1 + i) +"]", parentEle); 
			}
		}
		else{
			if(isRequirement){/*필수값일때*/
				if(eventEle.val()){
					if(!focusEle.length){/*값이 있고, 다음 열(컬럼)이 없을땐 다음 행으로 이동함*/
						focusNextRow(eventEle);
					}
					else{
						focusEle.focus();
					}
				}
			}
			else{
				if(!focusEle.length && eventEle.attr("part")){/*다음 행으로 이동*/
					focusNextRow(eventEle);
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
function focusNextRow(eventEle){
	var part = eventEle.attr("part");
	var ActionMap = {
			state_d : fnSetAbdocuD,
			state_th : fnSetAbdocuTH,
			state_td : fnSetAbdocuTD,
			state_td2 : fnSetAbdocuTD2
	};

	if(ActionMap[part]){
		ActionMap[part](eventEle);
	}
}; 



function fnSaveClick(tr){
	$(".btnSaveRow", tr).css("cursor", "pointer").click(function(){
		var eventEle = $("input[part]", tr);
		focusNextRow(eventEle);
	});	
};



function fnRowCheck(type){
	var temptr = $("#travelTD-Table tr:not(.blank)");
	var sample = $("#travelTD-table-sample-empty");	
	if(type == "td2"){
		temptr = $("#travelTD2-Table tr:not(.blank)");
		sample = $("#travelTD2-table-sample-empty");			
	}else if(type == "d"){
		temptr = $("#goodsItems-Table tr:not(.blank)");
		sample = $("#goodsItems-table-sample-empty");	
	}
	
	var removetr = null;
	var isAddRow = true; 
	temptr.each(function(){
		if(!$(this).attr("id")){
			removetr = $(this);
		}else{
			isAddRow = false;
		}
	});  
	
	/* 정상입력된 예산정보가 하나라도 있으면 empty 없으면 빈라인 생성 */
    if(isAddRow){
    	if(type == "td"){ 				
			fnAbdocuTD_AddRow();
		}
		else if(type == "td2"){
			fnAbdocuTD2_AddRow();
		}else if(type == "d"){
			fnAbdocD_AddRow();
		}
    }else{
		var tr = $("tr", sample).clone(false);
		if(removetr){
			removetr.replaceWith(tr);
		}
		fnRowAppend(type);     	
    }
	
	
}
/* + 버튼 클릭시 한줄 추가 */
function fnRowAppend(type){
	
	var table = $("#travelTD-Table");
	var sample = $("#travelTD-Table-sample");			
	if(type == "td2"){
		table = $("#travelTD2-Table");
		sample = $("#travelTD2-Table-sample");			
	}else if(type == "d"){
		table = $("#goodsItems-Table");
		sample = $("#goodsItems-Table-sample");	
	}
	var tr_blank =   $("tr.blank", table);
	if(!tr_blank.length){
		var tr = $("tr", sample).clone(false);
		table.append(tr);
	}
	var imgTr = tr_blank.first();
	var erpappend = $('<div class="controll_btn al" style=" padding:0px;"><button type="button" class="erpappend">추가</button></div>');
	
	var temptd = $("td", imgTr).first();
	if(!$(".erpappend", temptd).length){
		temptd.append(erpappend);
		 
			erpappend.click(function(){
				var target = $(this);
				var table = target.parents("table");
				var id = table.attr("id");
				
				if(!ItemsValidationCheck(table)){
					return false;
				}
				
				if(id == "travelTD-Table"){ /* 예산 */					
					fnAbdocuTD_AddRow();
				}
				else if(id == "travelTD2-Table"){
					fnAbdocuTD2_AddRow();
				}else if(id == "goodsItems-Table"){
					fnAbdocD_AddRow();
				}
			
				
		});
	}
};

/* 등록된 명세서 데이터 가져오기 */
function fnGetAbdocuTDList(){
	fnAbdocuTD_Remove();
	/*ajax 호출할 파라미터*/
	var resultData = {};
	var tblParam = {};
	tblParam.abdocu_no = abdocu_no;
    var opt = {
            url     : _g_contextPath_ + "/Ac/G20/Ex/getAbdocuTD_List.do",
            stateFn : modal,
            async   : true,
            data    : tblParam,
            successFn : function(data){
            	var selectList = data.selectList;

            	for(var i = 0, max = selectList.length; max != null && i< max ; i++){
            		var result = selectList[i];
            		var parentEle = fnAbdocuTD_AddRow();
            		parentEle.attr("id", result.abdocu_td_no);
            		$(".txt_JONG_NM", parentEle).val(result.jong_nm);   //품명, 명칭
            		$(".txt_JKM_CNT", parentEle).val(result.jkm_cnt);     //규격
        			$(".txt_JGRADE", parentEle).val(result.jgrade);      //단위
        			$(".txt_JUNIT_AM", parentEle).val(result.junit_am.toMoney());             //수량
        			$(".txt_JTOT_AM", parentEle).val(result.jtot_am.toMoney());      //단가
            	}

            	fnRowCheck("td");
                
              	$(".txt_JONG_NM").focus();
            },
            error: function (request,status,error) {
    	    	alert(NeosUtil.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요")+"\n"+NeosUtil.getMessage("TX000009711","오류 메시지 : {0}").replace("{0}",request.responseText)+"\n");
        	}
    }; 
    acUtil.ajax.call(opt, resultData);
};


function fnGetAbdocuTD2List(){

	fnAbdocuTD2_Remove();
	/*ajax 호출할 파라미터*/
	var resultData = {};
	var tblParam = {};
	tblParam.abdocu_no = abdocu_no;
    var opt = {
            url     : _g_contextPath_ + "/Ac/G20/Ex/getAbdocuTD2_List.do",
            stateFn : modal,
            async   : true,
            data    : tblParam,
            successFn : function(data){
            	var selectList = data.selectList;

            	for(var i = 0, max = selectList.length; max != null &&  i< max ; i++){
            		var result = selectList[i];
            		var parentEle = fnAbdocuTD2_AddRow();
            		parentEle.attr("id", result.abdocu_td2_no);
            		$(".th2_DEPT_NM", parentEle).val(result.dept_nm);   // 부서
            		$(".th2_HCLS_NM", parentEle).val(result.hcls_nm);     // 직급
        			$(".th2_EMP_NM", parentEle).val(result.emp_nm);      // 출장자
        			th_TripDt.data("kendoDatePicker").value(ncCom_Date(result.trip_dt, '-'));//출장 시작일
        			$(".temp_th2_TRIP_DT", parentEle).val(result.trip_dt); //출장 시작일
        			$(".th2_NT_CNT", parentEle).val(result.nt_cnt);     // 야수
        			$(".th2_DAY_CNT", parentEle).val(result.day_cnt);   //일수
        			$(".th2_START_NM", parentEle).val(result.start_nm);   //출발지
        			$(".th2_CROSS_NM", parentEle).val(result.cross_nm);  //경유지
        			$(".th2_ARR_NM", parentEle).val(result.arr_nm);   // 도착지
        			$(".th2_JONG_NM", parentEle).val(result.jong_nm);  //종별
        			$(".th2_KM_AM", parentEle).val(result.km_am);      //거리
        			$(".th2_FAIR_AM", parentEle).val(result.fair_am.toMoney());      // 요금
        			$(".th2_DAY_AM", parentEle).val(result.day_am.toMoney());      // 일비
        			$(".th2_FOOD_AM", parentEle).val(result.food_am.toMoney());      // 식비
        			$(".th2_ROOM_AM", parentEle).val(result.room_am.toMoney());      // 숙박비
        			$(".th2_OTHER_AM", parentEle).val(result.other_am.toMoney());            // 기타
        			$(".th2_TOTAL_AM", parentEle).val(result.total_am.toMoney());            // 합계
        			$(".th2_TRMK_DC", parentEle).val(result.trmk_dc);                       //비고
            	}

            	fnRowCheck("td2");
                
            },
            error: function (request,status,error) {
            	alert(NeosUtil.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요")+"\n"+NeosUtil.getMessage("TX000009711","오류 메시지 : {0}").replace("{0}",request.responseText)+"\n");
        	}
    }; 
    acUtil.ajax.call(opt, resultData);
};

function fnAbdocuTD_AddRow(){
	var table = $("#travelTD-Table");
	var trList = $("tr", table).not(".blank");
	trList.each(function(index){
		if(!$(trList[index]).attr("id")){
			$(trList[index]).remove();
		}
	});
	
	var sample = $("#travelTD-Table-sample");

	var tr = $("tr", sample).clone(false);
    var addId = $("tr", table).not(".blank").length + 1;
	var addTabIndex = parseInt(addId, 10) * 1000;

	$(".requirement, .non-requirement",tr).each(function(idx, vlaue){
		var id = $(this).attr("id");
		if($(this).attr("disabled")!="disabled"){
			$(this).addClass(id).attr("name", id).attr("id", id + addId).attr("tabindex", addTabIndex + idx);
		}
//		var tabIndex = $(this).attr("tabindex");
		/*name 은 id 와 같게, tabindex 는 (x)번째 행 * 100 */
		
	});

	var blank = $(".blank", table);
	if(blank.length){
		if( $("tr", table).not(".blank").length < 3){
			blank.first().replaceWith(tr);
		}else{
			blank.remove();
			var empty = $("#travelTD-tablesample-empty");
			var blank_tr = $("tr", empty).clone(false);
			table.append(blank_tr);
			tr.insertBefore($("tr.blank:first", table));
		}
	}else{
		table.append(tr);
	}
	
	init(tr);
	$("input[type=text]", tr).first().focus();
	
	/*운임거리*/
	$(".txt_JKM_CNT", tr).bind({
		keydown : function(event){
			var keycode =event.keyCode;

			if(acUtil.util.validMoneyKeyCode(keycode)){

				return true;
			}
			else{
				return false;
			}
			event.preventDefault();
		}
	});
	
	/*단가*/
	$(".txt_JUNIT_AM", tr).bind({
		keydown : function(event){
			var keycode =event.keyCode;

			if(acUtil.util.validMoneyKeyCode(keycode)){
				return true;
			}
			else{
				return false;
			}
			event.preventDefault();
		},
		keyup : function(event){
			var input = $(event.target);
			var count = input.val();
			input.val(count.toString().toMoney());
		}
	});
	
	/*총액*/
	$(".txt_JTOT_AM", tr).bind({
		keydown : function(event){
			var keycode =event.keyCode;

			if(acUtil.util.validMoneyKeyCode(keycode)){
				return true;
			}
			else{
				return false;
			}
			event.preventDefault();
		},
		keyup : function(event){
			var input = $(event.target);
			var count = input.val();
			input.val(count.toString().toMoney());
		}
	});
	
	/* 저장 버튼 클릭시*/
	fnSaveClick(tr);
	
	$(".btnDeleteRow", tr).bind({
		click : function(event){
			var id = $(event.target).parents("tr").attr("id");
			if(id){
				fnDelAbdocuTD(id);
			}
			else{
				fnGetAbdocuTDList(); 
			}
		}
	});	
	return tr;
};

var th_TripDt;
function fnAbdocuTD2_AddRow(){
	
	var table = $("#travelTD2-Table");
	var trList = $("tr", table).not(".blank");
	trList.each(function(index){
		if(!$(trList[index]).attr("id")){
			$(trList[index]).remove();
		}
	});

	var sample = $("#travelTD2-Table-sample");
	var tr = $("tr", sample).clone(false); 
	var addId = $("tr", table).not(".blank").length;
	var addTabIndex = parseInt(addId, 10) * 10000;
	$(".requirement, .non-requirement",tr).each(function(idx, vlaue){
		var id = $(this).attr("id");
		if($(this).attr("disabled")!="disabled"){
			$(this).addClass(id).attr("name", id).attr("id", id + addId).attr("tabindex", addTabIndex + idx);
		}
	});
	
 
	var blank = $(".blank", table);
	if(blank.length){
		if( $("tr", table).not(".blank").length < 3){
			blank.first().replaceWith(tr);
		}else{
			blank.remove();
			var empty = $("#travelTD2-tablesample-empty");
			var blank_tr = $("tr", empty).clone(false);
			table.append(blank_tr);
			tr.insertBefore($("tr.blank:first", table));
		}
	}else{
		table.append(tr);
	}
	
//	abdocu_d.travelTD2.eventHandlerMapping(tr);
	init(tr);
	$("input[type=text]", tr).first().focus();
	
	/*야수, 일수, 거리*/
	$(".th2_NT_CNT, .th2_DAY_CNT, .th2_KM_AM", tr).bind({
		keydown : function(event){
			var keycode =event.keyCode;
			if(acUtil.util.validMoneyKeyCode(keycode)){
				return true;
			}
			else{
				return false;
			}
			event.preventDefault();
		}
	});

	/*요금, 일비, 식비, 숙박비, 기타*/
	$(".th2_FAIR_AM, .th2_DAY_AM, .th2_FOOD_AM, .th2_ROOM_AM, .th2_OTHER_AM", tr).bind({
		keydown : function(event){
			var keycode =event.keyCode;

			if(acUtil.util.validMoneyKeyCode(keycode)){

				return true;
			}
			else{
				return false;
			}
			event.preventDefault();
		},
		keyup : function(event){
			var input = $(event.target);
			var count = input.val();
			input.val(count.toString().toMoney());
			
			var parentEle = $(input).parents("tr");
			var fairAmt = $(".th2_FAIR_AM", parentEle).val();
			var dayAmt = $(".th2_DAY_AM", parentEle).val();
			var foodAmt = $(".th2_FOOD_AM", parentEle).val();
			var roomAmt = $(".th2_ROOM_AM", parentEle).val();
			var otherAmt = $(".th2_OTHER_AM", parentEle).val();
			
			fairAmt = parseInt(fairAmt.valueOf().toString().toMoney2(), 10) || 0;
			dayAmt = parseInt(dayAmt.valueOf().toString().toMoney2(), 10) || 0;
			foodAmt = parseInt(foodAmt.valueOf().toString().toMoney2(), 10) || 0;
			roomAmt = parseInt(roomAmt.valueOf().toString().toMoney2(), 10) || 0;
			otherAmt = parseInt(otherAmt.valueOf().toString().toMoney2(), 10) || 0;
			
			$(".th2_TOTAL_AM", parentEle).val((fairAmt + dayAmt + foodAmt + roomAmt + otherAmt).toString().toMoney());
		}
	});
	
	/* 부가세신고일, 신고기준일 달력지정 */
	th_TripDt = $(".th2_TRIP_DT" , tr).attr("id");
	var temp_th2_TRIP_DT = $(".temp_th2_TRIP_DT" , tr).attr("id");
	
	abdocu.setDatepicker(th_TripDt, temp_th2_TRIP_DT)

	/* 저장 버튼 클릭시*/
    fnSaveClick(tr);
    $(".btnDeleteRow", tr).bind({
		click : function(event){
			var id = $(event.target).parents("tr").attr("id");
			if(id){
				fnDelAbdocuTD2(id);
			}
			else{
				fnGetAbdocuTD2List(); 

			}
		}
	});    
	return tr;
};

function fnAbdocuTD_Remove(){

	var sample = $("#travelTD-Table-sample-empty");

	var table = $("#travelTD-Table");
	$("tr", table).remove();
	for(var i = 0; i< 4 ; i++){
		var tr = $("tr", sample).clone(false);
		table.append(tr);
	}
};

function fnAbdocuTD2_Remove(){

	var sample = $("#travelTD2-Table-sample-empty");

	var table = $("#travelTD2-Table");
	$("tr", table).remove();
	for(var i = 0; i< 5 ; i++){
		var tr = $("tr", sample).clone(false);
		table.append(tr);
	}
};

/**
 * 헤더 저장
 */
function fnSetAbdocuTH(){
	
	var resultData = {};
	
	var table = $("#travelTH-Table");
	if(!ItemsValidationCheck(table)){
		return false;
	}
	var tblParam = {};
	tblParam.abdocu_no    = parseInt(abdocu_no) || "0";
	tblParam.erp_co_cd    = erp_co_cd;
	tblParam.abdocu_th_no = $("#abdocu_th_no").val() || "0";
	tblParam.ts_dt        = $("#txt_TS_DT").val().replace(/-/gi, "");
	tblParam.te_dt        = $("#txt_TE_DT").val().replace(/-/gi, "");
	tblParam.tday_cnt     = $("#txt_TDAY_CNT").val();
	tblParam.site_nm      = $("#txt_SITE_NM").val();
	tblParam.ontrip_nm    = $("#txt_ONTRIP_NM").val();
	tblParam.req_nm       = $("#txt_REQ_NM").val();
	tblParam.rsv_nm       = $("#txt_RSV_NM").val();
	tblParam.rcost_am     = ($("#txt_RCOST_AM").val() || "").valueOf().toString().toMoney2() || "0";
	tblParam.scost_am     = ($("#txt_SCOST_AM").val() || "").valueOf().toString().toMoney2() || "0";
	
	/*ajax 호출할 파라미터*/
    var opt = {
            url     : _g_contextPath_ + "/Ac/G20/Ex/setAbdocuTH.do",
            stateFn : modal,
            async   : true,
            data    : tblParam,
            successFn : function(data){
                if(data.result && data.result > 0){
                	$("#abdocu_th_no").val(data.result);
                	alert(NeosUtil.getMessage("TX000010779","정상적으로 저장 되었습니다"));
                }else{
                	alert(NeosUtil.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요"));
//                 	fnResetAbdocuTH();
                }
            },
    	    error: function (request,status,error) {
    	    	alert(NeosUtil.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요")+"\n"+NeosUtil.getMessage("TX000009711","오류 메시지 : {0}").replace("{0}",request.responseText)+"\n");
//     	    	fnResetAbdocuTH();
        	}
    };

    acUtil.ajax.call(opt, resultData);
};

/** 
 * 출장 상세 저장 g20_abdocu_td
 * @param eventEle
 * @param resultData
 * @returns {Boolean}
 */
function fnSetAbdocuTD(eventEle, resultData){

	var table = $("#travelTD-Table");
	if(!ItemsValidationCheck(table, eventEle)){
		return false;
	}

	var parentEle = eventEle.parents("tr");
	var abdocu_td_no = parentEle.attr("id") || "0";
	var tblParam = {};
    tblParam.abdocu_no    = parseInt(abdocu_no) || "0";
	tblParam.abdocu_td_no = abdocu_td_no;
	tblParam.jong_nm      = $(".txt_JONG_NM", parentEle).val();
	tblParam.jkm_cnt      = $(".txt_JKM_CNT", parentEle).val();
	tblParam.jgrade       = $(".txt_JGRADE", parentEle).val();
	tblParam.junit_am     = ($(".txt_JUNIT_AM", parentEle).val() || "").valueOf().toString().toMoney2() || "0";
	tblParam.jtot_am      = ($(".txt_JTOT_AM", parentEle).val() || "").valueOf().toString().toMoney2() || "0";
	tblParam.erp_co_cd    = erp_co_cd;

	/*ajax 호출할 파라미터*/
    var opt = {
    		url     : _g_contextPath_ + "/Ac/G20/Ex/setAbdocuTD.do",
            stateFn : modal,
            async   : true,
            data    : tblParam,
            successFn : function(resultData){
                if(resultData.result && resultData.result > 0){
                	parentEle.attr("id", resultData.result);
                	fnAbdocuTD_AddRow();
                }else{
                	alert("오류가 발생하였습니다. 관리자에게 문의하세요.");
                }
            },
            error: function (request,status,error) {
            	alert(NeosUtil.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요")+"\n"+NeosUtil.getMessage("TX000009711","오류 메시지 : {0}").replace("{0}",request.responseText)+"\n");
        	}
    };

    acUtil.ajax.call(opt, resultData);
};

/**
 * g20_abdocu_td2
 */
function fnSetAbdocuTD2(eventEle, resultData){

	var table = $("#travelTD2-Table");
	if(!ItemsValidationCheck(table, eventEle)){
		return false;
	}
	var resultData = {};

	var parentEle = eventEle.parents("tr");
	var abdocu_td2_no = parentEle.attr("id") || "0";

	var tblParam = {};
    tblParam.abdocu_no     = parseInt(abdocu_no) || "0";
	tblParam.abdocu_td2_no = abdocu_td2_no;
	tblParam.dept_nm       = $(".th2_DEPT_NM", parentEle).val();
	tblParam.hcls_nm       = $(".th2_HCLS_NM", parentEle).val();
	tblParam.emp_nm        = $(".th2_EMP_NM", parentEle).val();
	tblParam.trip_dt       = $("input[name=temp_th2_TRIP_DT]", parentEle).val().replace(/-/gi, "");
	tblParam.nt_cnt        = $(".th2_NT_CNT", parentEle).val();
	tblParam.day_cnt       = $(".th2_DAY_CNT", parentEle).val();
	tblParam.start_nm      = $(".th2_START_NM", parentEle).val();
	tblParam.cross_nm      = $(".th2_CROSS_NM", parentEle).val();
	tblParam.arr_nm        = $(".th2_ARR_NM", parentEle).val();
	tblParam.jong_nm       = $(".th2_JONG_NM", parentEle).val();
	tblParam.km_am         = ($(".th2_KM_AM", parentEle).val() || "").valueOf().toString().toMoney2() || "0";
	tblParam.fair_am       = ($(".th2_FAIR_AM", parentEle).val() || "").valueOf().toString().toMoney2() || "0";
	tblParam.day_am        = ($(".th2_DAY_AM", parentEle).val() || "").valueOf().toString().toMoney2() || "0";
	tblParam.food_am       = ($(".th2_FOOD_AM", parentEle).val() || "").valueOf().toString().toMoney2() || "0";
	tblParam.room_am       = ($(".th2_ROOM_AM", parentEle).val() || "").valueOf().toString().toMoney2() || "0";
	tblParam.other_am      = ($(".th2_OTHER_AM", parentEle).val() || "").valueOf().toString().toMoney2() || "0";
	tblParam.total_am      = ($(".th2_TOTAL_AM", parentEle).val() || "").valueOf().toString().toMoney2() || "0";
	tblParam.trmk_dc       = $(".th2_TRMK_DC", parentEle).val();
	tblParam.erp_co_cd     = erp_co_cd;

	/*ajax 호출할 파라미터*/
    var opt = {
            url     : _g_contextPath_ + "/Ac/G20/Ex/setAbdocuTD2.do",
            stateFn : modal,
            async   : true,
            data    : tblParam,
            successFn : function(resultData){
                if(resultData.result && resultData.result > 0){
                	var table = $("#travelTD2-Table");
                	parentEle.attr("id", resultData.result);
                	fnAbdocuTD2_AddRow();
                }else{
                	alert(NeosUtil.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요"));
                }
            },
            error: function (request,status,error) {
    	    	alert("오류가 발생하였습니다. 관리자에게 문의하세요.\n오류메시지 :"+request.responseText+"\n");
        	}
    };

    acUtil.ajax.call(opt, resultData);
};

/**
 * 헤더 삭제 
 */
function fnDelAbdocuTH(){
	var resultData = {};
	if (confirm(NeosUtil.getMessage("TX000001981","삭제 하시겠습니까?"))) {  
		
		var abdocu_th_no = $("#abdocu_th_no").val();
		
		if(abdocu_th_no == ""){
			fnResetAbdocuTH();
			return;
		}
		
		var tblParam = {};
		tblParam.abdocu_th_no = abdocu_th_no;
		tblParam.abdocu_no = abdocu_no;
		
	    var opt = {
	            url     : _g_contextPath_ + "/Ac/G20/Ex/delAbdocuTH.do",
	            stateFn : modal,
	            async   : true,
	            data    : tblParam,
	            successFn : function(resultData){
	                if(resultData.result && resultData.result > 0){
	                	fnResetAbdocuTH();
	                }else{
	                	alert(NeosUtil.getMessage("TX000009415","삭제 도중 오류가 발생하였습니다. 관리자에게 문의하세요"));
	                }            	
	            },
	            error: function (request,status,error) {
	            	alert(NeosUtil.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요")+"\n"+NeosUtil.getMessage("TX000009711","오류 메시지 : {0}").replace("{0}",request.responseText)+"\n");
	        	}
	    };

	    acUtil.ajax.call(opt, resultData);
	}

};
function fnDelAbdocuTD(id){
	var resultData = {};
	var tblParam = {}
	tblParam.abdocu_td_no = id;
	tblParam.abdocu_no    = abdocu_no;

    var opt = {
            url     : _g_contextPath_ + "/Ac/G20/Ex/delAbdocuTD.do",
            stateFn : modal,
            async   : true,
            data    : tblParam,
			successFn : function(data){
                if(data.result && data.result > 0){
                	fnGetAbdocuTDList();
                }else{
                	alert(NeosUtil.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요"));
                }
            },
    	    error: function (request,status,error) {
    	    	alert(NeosUtil.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요")+"\n"+NeosUtil.getMessage("TX000009711","오류 메시지 : {0}").replace("{0}",request.responseText)+"\n");
        	}
    };

    acUtil.ajax.call(opt, resultData);
};

function fnDelAbdocuTD2(id){
	var resultData = {};
	var tblParam = {};
	tblParam.abdocu_td2_no = id;
	tblParam.abdocu_no     = abdocu_no;
    var opt = {
            url     : _g_contextPath_ + "/Ac/G20/Ex/delAbdocuTD2.do",
            stateFn : modal,
            async   : true,
            data    : tblParam,
            successFn : function(data){
                if(data.result && data.result > 0){
                	fnGetAbdocuTD2List();
                }else{
                	alert(NeosUtil.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요"));
                }
            },
    	    error: function (request,status,error) {
    	    	alert(NeosUtil.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요")+"\n"+NeosUtil.getMessage("TX000009711","오류 메시지 : {0}").replace("{0}",request.responseText)+"\n");
        	}
    };

    acUtil.ajax.call(opt, resultData);
};
//abdocu_d.travelTD.eventHandlerMapping = function(context, index){
//	var table = $("#travelTD-Table");
//	if(!context){
//		context = table;
//	}
//};
//
//abdocu_d.travelTD2.eventHandlerMapping = function(context, index){
//	var table = $("#travelTD2-Table");
//	if(!context){
//		context = table;
//	}
//};

abdocu_d.DateValidate = function(dateStr){
	var isValid = false;
	var date = new Date();
	var dateStrArr = [];
	if(dateStr){
		dateStrArr = dateStr.split("-");
	}
	
	if(dateStrArr.length!=3){
		isValid = false;
	}
	else{
		if(parseInt(dateStrArr[0], 10) && parseInt(dateStrArr[1], 10) && parseInt(dateStrArr[2], 10) 
			&& dateStrArr[0].length==4 && dateStrArr[1].length==2 && dateStrArr[2].length==2){
			date.setFullYear(parseInt(dateStrArr[0]), parseInt(dateStrArr[1]), parseInt(dateStrArr[2]));
			if(date){
				isValid = true;
			}
		}
		else{
			isValid = false;
		}
	}
	
	return isValid;
};



abdocu_d.Validation = function(){
	var isSuccess = true;
	$("." + acUtil.invalidClass).removeClass(acUtil.invalidClass);
	var msg = NeosUtil.getMessage("TX000011209","입력되지 않은 값이 있습니다. 확인해주세요.");
	var table = $("#travelTH-Table");
	var table1 = $("#travelTD-Table");
	var table2 = $("#travelTD2-Table");
	
	var obj = {
			isSuccess : isSuccess,
			msg : msg
	};
	$(".requirement", table).each(function(){
		if(!$(this).val()){
			$(this).addClass(acUtil.invalidClass);
			obj.msg = NeosUtil.getMessage("TX000011209","입력되지 않은 값이 있습니다. 확인해주세요.");
			obj.isSuccess = false;
		}
	});

	if(!obj.isSuccess){
		return obj;
	}

	$(".requirement", table1).each(function(){
		if(!$(this).val()){
			$(this).addClass(acUtil.invalidClass);
			obj.msg = NeosUtil.getMessage("TX000011209","입력되지 않은 값이 있습니다. 확인해주세요.");
			obj.isSuccess = false;
		}
	});

	if(!obj.isSuccess){
		return obj;
	}
	
	var len = [];
	$.map($("tr", table2), function(val, i){
		var id = $(val).attr("id");
		if(id){
			len[len.length] = id;
		}
	});
	if(!len.length){
		obj.msg = NeosUtil.getMessage("TX000011208","상세정보를 입력해 주세요");
		obj.isSuccess = false;
	}
	if(!obj.isSuccess){
		return obj;
	}

	$("tr", table2).each(function(){
		var tr = $(this);
		if(tr.attr("id")){
			$(".requirement", tr).each(function(){
				if(!$(this).val()){
					$(this).addClass(acUtil.invalidClass);
					obj.msg = NeosUtil.getMessage("TX000011209","입력되지 않은 값이 있습니다. 확인해주세요.");
					obj.isSuccess = false;
				}
			});
		}
	});  
		
	return obj;
};

//abdocu_d.setStateTotalAM  = function(arg){
//	
//	var obj = abdocu_d.Validation();
////	if(!obj.isSuccess){
////		alert(obj.msg);  
////		return false; 
////	}
//	var retVal   = new Object();
//	retVal.type = arg;
//	parent.window.returnValue = retVal;
//	parent.window.close();
//};


/*
 * 물품명세 관련
 */

/* 등록된 명세서 데이터 가져오기 */


function fnGetAbdocuD_List(focus){

// 	modalMent.remove();
	fnAbdocD_RemoveRow();
	/*ajax 호출할 파라미터*/
	var resultData = {};
	var tblParam = {};
	tblParam.abdocu_no = abdocu_no;
    var opt = {
            url     : _g_contextPath_ + "/Ac/G20/Ex/getAbdocuD_List.do",
            stateFn : modal,
            async   : true,
            data    : tblParam,
            successFn : function(data){
            	var selectList = data.selectList;

            	for(var i = 0, max = selectList.length; i< max ; i++){
            		var result = selectList[i];
            		var parentEle = fnAbdocD_AddRow();
            		parentEle.attr("id", result.abdocu_d_no);
            		$(".txt_ITEM_NM", parentEle).val(result.item_nm);   //품명, 명칭
            		$(".txt_ITEM_DC", parentEle).val(result.item_dc);     //규격
        			$(".txt_UNIT_DC", parentEle).val(result.unit_dc);      //단위
        			$(".txt_CT_QT", parentEle).val(result.ct_qt);             //수량
        			$(".txt_UNIT_AM", parentEle).val(result.unit_am.toMoney());      //단가
        			$(".txt_CT_AM", parentEle).val(result.ct_am.toMoney());            //금액
        			$(".txt_RMK_DC", parentEle).val(result.rmk_dc);                       //비고
            	}

                var temptr = $("#goodsItems-Table tr:not(.blank)");
            	var removetr = null;
            	var isAddRow = true; 
            	temptr.each(function(){
            		if(!$(this).attr("id")){
            			removetr = $(this);
            		}else{
            			isAddRow = false;
            		}
            	});  
            	
//            	fnAbdocD_AddRow();
            	/* 정상입력된 예산정보가 하나라도 있으면 empty 없으면 빈라인 생성 */
                if(isAddRow){
                	fnAbdocD_AddRow();
                }else{
            		var sample = $("#goodsItems-table-sample-empty");
            		var tr = $("tr", sample).clone(false);
            		if(removetr){
            			removetr.replaceWith(tr);
            		}
            		fnRowAppend("d");     	
                }
                
                var table = $("#goodsItems-Table");
            	abdocu_d.totalCount(table);
            	abdocu_d.totalAm(table);

            },
            error: function (request,status,error) {
            	alert(NeosUtil.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요")+"\n"+NeosUtil.getMessage("TX000009711","오류 메시지 : {0}").replace("{0}",request.responseText)+"\n");
        	}
    }; 
    acUtil.ajax.call(opt, resultData);
};

/**
 * 물품명세 저장
 */
function fnSetAbdocuD(eventEle){
	
	var resultData = {};
	
	var table = $("#goodsItems-Table");
	if(!ItemsValidationCheck(table, eventEle)){
		return false;
	}
	
	var parentEle = eventEle.parents("tr");
	var abdocu_d_no = parentEle.attr("id") || "0";
	var tblParam = {};
	tblParam.abdocu_no   = parseInt(abdocu_no) || "0",
    tblParam.abdocu_d_no = abdocu_d_no,
    tblParam.item_nm     = $(".txt_ITEM_NM", parentEle).val(),
    tblParam.item_dc     = $(".txt_ITEM_DC", parentEle).val(),
    tblParam.unit_dc     = $(".txt_UNIT_DC", parentEle).val(),
    tblParam.ct_qt       = ($(".txt_CT_QT", parentEle).val() || "").valueOf().toString().toMoney2() || "0",
    tblParam.unit_am     = ($(".txt_UNIT_AM", parentEle).val() || "").valueOf().toString().toMoney2() || "0",
    tblParam.ct_am       = ($(".txt_CT_AM", parentEle).val() || "").valueOf().toString().toMoney2() || "0",
    tblParam.rmk_dc      = $(".txt_RMK_DC", parentEle).val(),
    tblParam.erp_co_cd   = erp_co_cd;
	/*ajax 호출할 파라미터*/
    var opt = {
            url     : _g_contextPath_ + "/Ac/G20/Ex/setAbdocuD.do",
            stateFn : modal,
            async   : true,
            data    : tblParam,
            successFn : function(resultData){
            	if(resultData.result && resultData.result > 0){
//            		alert("정상적으로 저장 되었습니다.");
            		parentEle.attr("id", resultData.result);
            		fnAbdocD_AddRow();
            	}else{
            		alert(NeosUtil.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요"));
            	}
            },
            error: function (request,status,error) {
            	alert(NeosUtil.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요")+"\n"+NeosUtil.getMessage("TX000009711","오류 메시지 : {0}").replace("{0}",request.responseText)+"\n");
            }    
    };

    acUtil.ajax.call(opt, resultData);
};

/**
 * 물품명세 삭제
 */
function fnDelAbdocuD(id){
	var resultData = {};
	var tblParam = {};
	tblParam.abdocu_d_no = id ;
	tblParam.abdocu_no = abdocu_no ;
    var opt = {
            url     : _g_contextPath_ + "/Ac/G20/Ex/delAbdocuD.do",
            stateFn : modal,
            async   : true,
            data    : tblParam,
            successFn : function(resultData){
                if(resultData.result && resultData.result > 0){
                	fnGetAbdocuD_List();
                }else{
                	alert(NeosUtil.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요"));
                }                 
            },
            error: function (request,status,error) {
            	alert(NeosUtil.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요")+"\n"+NeosUtil.getMessage("TX000009711","오류 메시지 : {0}").replace("{0}",request.responseText)+"\n");
        	}
    };

    acUtil.ajax.call(opt, resultData);

};


function fnAbdocD_AddRow(){
	
	var table = $("#goodsItems-Table");
	var trList = $("tr", table).not(".blank");
	trList.each(function(index){
		if(!$(trList[index]).attr("id")){
			$(trList[index]).remove();
		}
	});
	
	var sample = $("#goodsItems-Table-sample");

	var tr = $("tr", sample).clone(false);

	var addId = $("tr", table).not(".blank").length + 1;
	var addTabIndex = parseInt(addId, 10) * 100;

	$(".requirement, .non-requirement",tr).each(function(idx, vlaue){
		var id = $(this).attr("id");
		var tabIndex = $(this).attr("tabindex");
		/*name 은 id 와 같게, tabindex 는 (x)번째 행 * 100 */
		$(this).addClass(id).attr("name", id).attr("id", id + addId).attr("tabindex", addTabIndex + idx);
	});

	var blank = $(".blank", table);
	if(blank.length){
		if( $("tr", table).not(".blank").length < 3){
			blank.first().replaceWith(tr);
		}else{
			blank.remove();
			var empty = $("#goodsItems-tablesample-empty");
			var blank_tr = $("tr", empty).clone(false);
			table.append(blank_tr);
			tr.insertBefore($("tr.blank:first", table));
		}
	}else{
		table.append(tr);
	}		

	init(tr);
	$("input[type=text]", tr).first().focus();
	/*수량*/
	$(".txt_CT_QT", tr).bind({
		keydown : function(event){
			var keycode =event.keyCode;

			if(acUtil.util.validMoneyKeyCode(keycode)){
				return true;
			}
			else{
				return false;
			}
			event.preventDefault();
		},
		keyup : function(event){
			var input = $(event.target);
			var parentEle = $(input).parents("tr");
			
			var count = input.val()|| 0;;
			input.val(count.toString().toMoney());
			count = count.valueOf().toString().toMoney2();
			count = parseInt(count, 10) || 0;
			
			var unitAm = $(".txt_UNIT_AM", parentEle).val();
			unitAm = unitAm.valueOf().toString().toMoney2();
			unitAm = parseInt(unitAm, 10) || 0;
			
			$(".txt_CT_AM", parentEle).val((count * unitAm).toString().toMoney());
			abdocu_d.totalCount(table);
			abdocu_d.totalAm(table);
		}
	});
	
	/*단가*/
	$(".txt_UNIT_AM", tr).bind({
		keydown : function(event){
			var keycode =event.keyCode;

			if(acUtil.util.validMoneyKeyCode(keycode)){

				return true;
			}
			else{
				return false;
			}
			event.preventDefault();
		},
		keyup : function(event){
			var input = $(event.target);
			var parentEle = $(input).parents("tr");
			
			var count = input.val() || 0;
			input.val(count.toString().toMoney());
			count = count.valueOf().toString().toMoney2();
			count = parseInt(count, 10) || 0;
			
			var qtcount = $(".txt_CT_QT", parentEle).val();
			qtcount = qtcount.valueOf().toString().toMoney2();
			qtcount = parseInt(qtcount, 10) || 0;
			
			$(".txt_CT_AM", parentEle).val((count * qtcount).toString().toMoney());
			abdocu_d.totalAm(table);
		}
	});
	
	/* 저장 버튼 클릭시*/
	fnSaveClick(tr);
	
	/* 삭제버튼 */
	$(".btnDeleteRow", tr).bind({
		click : function(event){
			var id = $(event.target).parents("tr").attr("id");
			if(id){
				fnDelAbdocuD(id);
			}
			else{
				fnGetAbdocuD_List(); 
			}
		}
	});

	return tr;
};


function fnAbdocD_RemoveRow(){

	var sample = $("#goodsItems-Table-sample-empty");
	var table = $("#goodsItems-Table");
	$("tr", table).remove();
	for(var i = 0; i< 6 ; i++){
		var tr = $("tr", sample).clone(false);
		table.append(tr);
	}
};


abdocu_d.totalCount = function(table){
	var ct_qt = $(".txt_CT_QT", table);
	var ct_qt_sum = 0;
	for(var i = 0, max = ct_qt.length; i< max ; i++){
		ct_qt_sum = parseInt(ct_qt_sum, 10) + parseInt($(ct_qt[i]).val() || "0", 10) || "0" ;
	}
	$("#TOTAL_COUNT").html(ct_qt_sum);
};

abdocu_d.totalAm= function(table){
	var ct_am = $(".txt_CT_AM", table);
	var ct_am_sum = 0;
	for(var i = 0, max = ct_am.length; i< max ; i++){
		ct_am_sum = parseInt(ct_am_sum, 10) + parseInt($(ct_am[i]).val().valueOf().toString().toMoney2() || "0", 10)  || "0";
	}
	$("#TOTAL_AM").html(ct_am_sum.toString().toMoney());
	$("#TOTAL_AM").attr("code", ct_am_sum.toString().toMoney());
};




//// 커스텀  ////////

//abdocu_d.getBizTripReqListReBind = function(){
//	acUtil.util.dialog.dialogClose();
//	abdocu_d.getBizTripReqDocList();
//};

//abdocu_d.getBizTripReqDocList = function(){
//
//	var isAllDocView = $("#isAllDocView").attr("checked") ? "1" : "0";  // 전체문서보기
//	var data = { 
//			  isAllDocView : isAllDocView
//	};             
//	/*ajax 호출할 파라미터*/
//    var opt = {
//            url : _g_contextPath_ + "/neos/erp/g20/getBizTripReqDocList.do",
//            stateFn:modal,
//            async:false,
//            data : data,
//            successFn : function(){
//                var dblClickparamMap = [];
//
//            	/*모달창 가로사이즈 및 타이틀*/
//            	var dialogParam = {
//            			title : "출장신청내역",
//            			width : "700"
//            				,count : 7
//            	};
//            	acUtil.dialogForm = "dialog-form-BizTripList";
//            	acUtil.util.dialog.open(dialogParam);
//
//                /*모달창 컬럼 지정 및 스타일 지정*/
//            	var mainData = acUtil.modalData;
//            	var paramMap = {};
//            	paramMap.loopData =  mainData.selectList;
//            	paramMap.colNames = ["구분", "문서번호", "문서제목", "기안자","출장시작일", "출장종료일", "출장사유", "출장지"]; 
//            	paramMap.colModel = [
//            	                       {code : "", text : "NM_TRIP", style : {width : "80px"}},
//            	                       {code : "", text : "DOCNUMBER", style : {width : "100px"}},
//            	                       {code : "", text : "DOCTITLE", style : {width : "160px"}},
//            	                       {code : "", text : "WRITENM", style : {width : "100px"}},
//            	                       {code : "", text : "DT_FROM", style : {width : "80px"}},
//            	                       {code : "", text : "DT_TO", style : {width : "80px"}},
//            	                       {code : "", text : "DC_REG", style : {width : "100px"}},
//            	                       {code : "", text : "TRIP_AREA", style : {width : "150px"}}
//            	                     ];
//            	paramMap.dblClickparamMap = dblClickparamMap; 
//
//            	/*모달창 값 선택시(더블클릭) 실행될 함수*/
//            	paramMap.trDblClickHandler_UserDefine = function(index, dblClickparamMap){
//            		var APPL_ID  = acUtil.modalData.selectList[index].APPL_ID;
//    
//            		abdocu_d.insertStateTravel_Biztrip(APPL_ID);
//            		
//            	};
//            	//var selectList = acUtil.modalData.selectList;
//            	acUtil.util.dialog.setData(paramMap);            	
//            }
//    };
//    
//    /*결과 데이터 담을 객체*/
//    acUtil.modalData = {};
//    acUtil.ajax.call(opt, acUtil.modalData );
//
//};
//
//abdocu_d.getBizTripReqUserList = function(){
//
//	var isAllDocView = $("#isAllDocView").attr("checked") ? "1" : "0";  // 전체문서보기
////	var isAllDocView = 1;  // 전체문서보기
//	var data = { 
//			  isAllDocView : isAllDocView,
//			  abdocu_no : parseInt(abdocu_no) || "0",
//	};             
//	/*ajax 호출할 파라미터*/
//    var opt = {
//            url : _g_contextPath_ + "/neos/erp/g20/getBizTripReqUserList.do",
//            stateFn:modal,
//            async:false,
//            data : data,
//            successFn : function(){
//                var dblClickparamMap = [];
//
//            	/*모달창 가로사이즈 및 타이틀*/
//            	var dialogParam = {
//            			title : "출장신청내역",
//            			width : "1300" ,
//            		    count : 7
//            	};
//            	acUtil.dialogForm = "dialog-form-BizTripList";
//            	acUtil.util.dialog.open(dialogParam);
//
//                /*모달창 컬럼 지정 및 스타일 지정*/
//            	var mainData = acUtil.modalData;
//            	var paramMap = {};
//            	paramMap.tb_width = "1300px";
//            	paramMap.loopData =  mainData.selectList;
//            	paramMap.colNames = ["출장구분", "문서번호", "문서제목", "기안자", "출장자", "출장시작일", "출장종료일", "출장사유", "출장지"]; 
//            	paramMap.colWidths = ["70px", "120px", "250px", "90px", "90px", "70px", "70px", "220px", "150px"]; 
//            	paramMap.colModel = [
//            	                       {code : "", text : "NM_TRIP", style : {width : "70px"}},
//            	                       {code : "", text : "DOCNUMBER", style : {width : "120px"}},
//            	                       {code : "", text : "DOCTITLE", style : {width : "220px"}},
//            	                       {code : "", text : "WRITENM", style : {width : "90px"}},
//            	                       {code : "", text : "REQUESTNM", style : {width : "90px"}},
//            	                       {code : "", text : "DT_FROM", style : {width : "70px"}},
//            	                       {code : "", text : "DT_TO", style : {width : "70px"}},
//            	                       {code : "", text : "DC_REG", style : {width : "200px"}},
//            	                       {code : "", text : "TRIP_AREA", style : {width : "150px"}}
//            	                     ];
//            	paramMap.dblClickparamMap = dblClickparamMap; 
//            	/*모달창 값 선택시(더블클릭) 실행될 함수*/
//            	paramMap.btnClickHandler_Insert = function(index, dblClickparamMap){
//            		var data  = acUtil.modalData.selectList[index];
//            		abdocu_d.insertStateTravelUser(data);
//            		
//            	};            	
//            	acUtil.util.dialog.setData_Biztrip(paramMap);            	
//            }
//    };
//    
//    /*결과 데이터 담을 객체*/
//    acUtil.modalData = {};
//    acUtil.ajax.call(opt, acUtil.modalData );
//
//};
//
//
//abdocu_d.insertStateTravel_Biztrip = function(APPL_ID){
//	var data = { 
//			APPL_ID : APPL_ID 
//		,   abdocu_no : abdocu_no
//	};
//	var resultData = {};
//	/*ajax 호출할 파라미터*/
//	var opt = {
//			url : _g_contextPath_ + "/neos/erp/g20/insertStateTravel_Biztrip.do",
//			stateFn:modal,
//			async:true,
//			data : data,
//			successFn : function(data){
//				acUtil.util.dialog.dialogClose();
//				abdocu_d.view();
//			}
//	};
//	acUtil.ajax.call(opt, resultData);
//};
//
//abdocu_d.insertStateTravelUser = function(obj){
//	var resultData = {};
//	var data = {
//		abdocu_no : parseInt(abdocu_no) || "0",
//		dept_nm : obj.DEPT_NM || "",   //부서명
//		hcls_nm : obj.DEPT_NM || "",   // 직급
//		emp_nm : obj.REQUESTNM || "",   // 출장자
//		trip_dt : (obj.DT_FROM || "").replace(/-/gi, ""),   // 출장일자
//		//nt_cnt : obj.DT_FROM,   // 야수
//		day_cnt : obj.DAYS || "",   // 일수
//		//start_nm : obj.DT_FROM,   //출발지
//		//cross_nm : obj.DT_FROM,   // 경유지
//		arr_nm : obj.TRIP_AREA || "",   // 도착지 
//		jong_nm : obj.TRANSPORT|| "",  // 종별
//		//km_am : obj.DT_FROM,   // 거리
//		fair_am : (obj.AM_FARE || "").valueOf().toString().toMoney2() || "0", //교통비
//		day_am : (obj.AM_DAY || "").valueOf().toString().toMoney2() || "0", //일비
//		food_am : (obj.AM_EAT || "").valueOf().toString().toMoney2() || "0", //식비
//		room_am : (obj.AM_LODGE || "").valueOf().toString().toMoney2() || "0", //숙박비
//		other_am : (obj.AM_ETC || "").valueOf().toString().toMoney2() || "0", //기타
//		total_am : (obj.AM_TOTAL || "").valueOf().toString().toMoney2() || "0", // 총액
//		trmk_dc : obj.DC_REG || "",   // 비고
//		biztrip_appl_id : obj.APPL_ID ,
//		biztrip_no_seq :  obj.NO_SEQ ,
//	}; 
//
//	/*ajax 호출할 파라미터*/
//    var opt = {
//            url : _g_contextPath_ + "/neos/erp/g20/setStateTravelTD2.do",
//    		
//            stateFn:modal,
//            async:false,
//            data : data,
//            successFn : function(data){
//                if(resultData.result && resultData.result > 0){
//                	
//                }
//                else{
//                	alert("저장중 오류가 발생하였습니다. ");
//                }
//            }
//    };
//    acUtil.ajax.call(opt, resultData);
//    
//};
