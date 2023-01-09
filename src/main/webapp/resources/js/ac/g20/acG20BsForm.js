/**
 *
 * 지출결의서/지출품의서 js 파일
 *
 */

var abdocu = {};

acUtil.invalidClass = "invalid"; /*validation 통과 못하면 지정되는 클래스 이름*/
abdocu.UserInfo = {}; /*ERP 사용자 정보*/
abdocu.ProjectInfo = {}; /* 프로젝트 정보 */
abdocu.BudgetInfo = {}; /* 예산 정보*/
abdocu.TradeInfo = {}; /* 거래처 정보*/

acUtil.dialogForm = "dialog-form-standard";/*dialog 띄울 div 아이디*/
acUtil.dialogSelect ="on"; /*dialog 에서 선택된 행*/
acUtil.divEtcPop = "divEtcPop"; /*기타소득자 팝업 관련 div */
abdocu.overBudget = "overBudget";

var comboxSel = {};
comboxSel.selTr_Fg = {};
comboxSel.selSet_Fg = {};
comboxSel.selVat_Fg = {};

var userSearchId = ""; 

var gwOption = {};
var erpOption = {};
var abdocuInfo = {};

//팝업 리사이즈
function fnResizeForm() {
	
	var strWidth = $('.pop_sign_wrap').outerWidth() + (window.outerWidth - window.innerWidth);
	var strHeight = $('.pop_sign_wrap').outerHeight() + (window.outerHeight - window.innerHeight);
	
	$('.pop_sign_wrap').css("overflow","auto");
	try{
		var childWindow = window.parent;
		childWindow.resizeTo(strWidth, strHeight);	
	}catch(exception){
		console.log('window resizing cat not run dev mode.');
	}
}

abdocu.state = function(state){
	if(state){		
		$("#dialog-form-background").show();
		var img = $("<img>").attr("id", "g20-ajax-img").attr("src", _g_contextPath_ + "/Images/ico/loading.gif")
		.css("position", "absolute").css("top", "50%").css("left", "50%").css("margin-top", "-5").css("margin-left", "-5").css("zIndex", "100000");
		$("body").append(img);  
	}
	else{
		$("#dialog-form-background").hide(); 
		$("#g20-ajax-img").remove();
	}
};

function fnReLoad(obj){
	var param = NeosUtil.makeParam(obj);
	var url = requestUrl + '?' + param;
	document.location.href = url;
}

//작성 기초데이터를  가져온다.
function fnAbdocuInit(){
    var tblParam = {};

    tblParam.template_key = template_key;
    tblParam.mode = mode;
    tblParam.abdocu_no = 0;
    $.ajax
    ({
        type: "POST"
	    , dataType: "json"
	    , url: getContextPath()+ "/Ac/G20/Ex/AcExDocInit.do"
        , data: tblParam
        , async: false
        , global: false
	    , success: function (res) {
	    	
	        // 성공
	        if (res.resultValue =="empty") {
	        	alert(NeosUtil.getMessage("TX000017813", "ERP사원정보가 없습니다. 관리자에게 문의 바랍니다"));
	            self.close();
	        }else if (res.resultValue =="notExist") {
	        	alert(NeosUtil.getMessage("TX000017814","ERP사원정보가 올바르지 않습니다. 관리자에게 문의 바랍니다."));
	            self.close();
	        }else if(res.resultValue =="notTempKey"){
	        	alert(NeosUtil.getMessage("TX000009430","등록되지 않은 양식입니다. 관리자에게 문의 바랍니다"));
	            self.close();
	        }else{
				if(res.C_TINAME){
					$(".title_NM").html(res.C_TINAME);
				}
	        	if(res.erpConfig){
	        		fnSetErpConfig(res.erpConfig);
	        	}
	        	if(res.gwConfig){
	        		fnSetGwConfig(res.gwConfig);
	        	}
				if(res.abdocu){
					abdocuInfo =  res.abdocu;
//	        	    fnInputInit();
                }
//				abdocu.eventHandlerMapping();
	        }
	        
	    },
	    error: function (request,status,error) {
	    	alert(NeosUtil.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요")+"\n errorCode :"+error+"\n");	    	    
    	}
    });
    
}


function fnAbdocuInfo(){
    var tblParam = {};
    tblParam.abdocu_no = abdocu_no;
    tblParam.template_key = template_key;
    tblParam.mode = mode;
    
    $.ajax
    ({
        type: "POST"
	    , dataType: "json"
	    , url: getContextPath()+ "/Ac/G20/Ex/AcExDocInfo.do"
        , data: tblParam
        , async: false
        , global: false
	    , success: function (res) {
	    	/* 부산항 예외처리 */
	    	if(res.groupSeq == 'BPFMC' || res.groupSeq == 'demo'){
	    		$('#divCustomBusan').show();
	    	}else{
	    		$('#divCustomBusan').remove();
	    	}
	    	
	        // 성공
	        if (res.resultValue =="empty") {
	        	alert(NeosUtil.getMessage("TX000017813", "ERP사원정보가 없습니다. 관리자에게 문의 바랍니다"));
	            self.close();
	        }else if (res.resultValue =="notExist") {
	        	alert(NeosUtil.getMessage("TX000017814","ERP사원정보가 올바르지 않습니다. 관리자에게 문의 바랍니다."));
	            self.close();
	        }else if(res.resultValue =="notTempKey"){
	        	alert(NeosUtil.getMessage("TX000009430","등록되지 않은 양식입니다. 관리자에게 문의 바랍니다"));
	            self.close();
	        }else{
				if(res.C_TINAME){
					$(".title_NM").html(res.C_TINAME);
				}
	        	if(res.erpConfig){
	        		fnSetErpConfig(res.erpConfig);
	        	}
	        	if(res.gwConfig){
	        		fnSetGwConfig(res.gwConfig);
	        	}
				if(res.abdocu){
					abdocuInfo =  res.abdocu;
	        	    fnInputInit();
                }
				//기타소득 과세율 정보 등
				if(res.taxRate){
					abdocu.etc_percent =parseFloat( res.taxRate.NDEP_RT, 10); /*필요경비율*/
					abdocu.sta_rt =parseFloat( res.taxRate.STA_RT, 10); /*기타소득율*/
					abdocu.jta_rt =parseFloat( res.taxRate.JTA_RT, 10); /*주민세율*/
					abdocu.mtax_am=parseFloat( res.taxRate.MTAX_AM, 10); /*과세최저한*/
                }
				
	        }
	    },
	    error: function (request,status,error) {
	    	alert(NeosUtil.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요")+"\n errorCode :"+request.responseText+"\n");	    	    
    	}
    });	
}

function fnSetErpConfig(erpConfig){
	
	for (var i = 0; i < erpConfig.length; i++) {
		// 예산관리구분  ,  FG_TY = 1.부서예산 2.프로젝트예산
		if (erpConfig[i].MODULE_CD == "4" && erpConfig[i].CTR_CD == "01") { 
			erpOption.BgtMngType = erpConfig[i].FG_TY;
		}
		// 프로젝트/부서별 하위사업 관리여부 , USE_YN = 0.미사용 1.적용
		if (erpConfig[i].MODULE_CD == "4" && erpConfig[i].CTR_CD == "14") { 
			erpOption.BottomUseYn = erpConfig[i].USE_YN;
		}
        // 원인행위부사용, USE_YN  = 0.미사용 1.적용
		if (erpConfig[i].MODULE_CD == "4" && erpConfig[i].CTR_CD == "05") { 
			erpOption.CauseUseYn = erpConfig[i].USE_YN;
		}
        // 예산배정사용여부, USE_YN = 0.미사용 1.적용
		if (erpConfig[i].MODULE_CD == "4" && erpConfig[i].CTR_CD == "10") { 
			erpOption.BgtAllocatUseYn = erpConfig[i].USE_YN;
		}
        // 사업비 지원부처간 연동 , USE_YN = 0.연동안함 1.연동함
		if (erpConfig[i].MODULE_CD == "4" && erpConfig[i].CTR_CD == "08") { 
			erpOption.BizGovUseYn = erpConfig[i].USE_YN;
		}
		
        // 예산7단계 사용 유무 확인 , USE_YN = 0.사용안함 1.사용함.
		if (erpConfig[i].MODULE_CD == "4" && erpConfig[i].CTR_CD == "63") { 
			erpOption.BgtStep7UseYn = erpConfig[i].USE_YN;
		}
//        String bonAccYn = G20SysConfigUtil.getUseYN("S", "01"); // 본지점회계여부
//		/** 끝전 단수처리 유형 0.반올림, 1.절사, 2 절상 **/
//		map.put("S10_TY", ICubeConfigUtil.getUseYN("S", "10"));
	}

	// 예산관리구분
	if(erpOption.BgtMngType == 1){
		$("#PjtTypeText").html(NeosUtil.getMessage("TX000000098","부서"));
	}
	
	// 하위사업사용여부
	if(erpOption.BottomUseYn == 1){
		$("#txtBottom_cd").addClass("requirement");
		$(".BottomTd").show();
	}
	
}

function fnSetGwConfig(gwConfig){
	gwOption = gwConfig;
}

function fnInputInit(res){	
	
	if(abdocuInfo.erp_co_nm ){
		$("#coInfo").html( abdocuInfo.erp_co_nm  + "(" + abdocuInfo.erp_co_cd +")");
	}else {
		$("#coInfo").html( "");
	}
	$("#txtDIV_NM").val(abdocuInfo.erp_div_nm);
	$("#txtDIV_NM").attr("code", abdocuInfo.erp_div_cd);
	$("#txtDEPT_NM").val(abdocuInfo.erp_dept_nm);
	$("#txtDEPT_NM").attr("code", abdocuInfo.erp_dept_cd);
	$("#txtKOR_NM").val(abdocuInfo.erp_emp_nm);
	$("#txtKOR_NM").attr("code", abdocuInfo.erp_emp_cd);
	$("#txtGisuDate").data("kendoDatePicker").value(ncCom_Date(abdocuInfo.erp_gisu_dt, '-'));
	if($("#txtAcisuDate").length){
		$("#txtAcisuDate").data("kendoDatePicker").value(ncCom_Date(abdocuInfo.erp_gisu_dt, '-'));
	}
    $("#txt_GisuDt").val(abdocuInfo.erp_gisu_dt.replace(/-/gi,""));
    $("#erpGisu").val(abdocuInfo.erp_gisu);
    $("#erpGisuFromDt").val(abdocuInfo.erp_gisu_from_dt);
    $("#erpGisuToDt").val(abdocuInfo.erp_gisu_to_dt);
    
//    $("#selectDocu").val(abdocuInfo.docu_fg_text);
//	$("#selectDocu").attr("code", abdocuInfo.docu_fg);
//    $("#selectDocu").data("kendoComboBox").value(abdocuInfo.docu_fg);
//	$("#selectDocu").val(abdocuInfo.docu_fg);
	
    if(abdocuInfo.abdocu_no != 0){ 
    	$("#selectDocu").data("kendoComboBox").enable(false);
    	abdocu_no = abdocuInfo.abdocu_no; 
//		$("#txt_ProjectName").val(textToHtmlConvert(abdocuInfo.mgt_nm));
		$("#txt_ProjectName").attr("code", abdocuInfo.mgt_cd);
		$("#temp_PjtCd").val(abdocuInfo.mgt_cd);
		$("#txt_IT_BUSINESSLINK").val(abdocuInfo.it_businessLink);
		$("#txtBottom_cd").val(abdocuInfo.bottom_nm);
		$("#txtBottom_cd").attr("code", abdocuInfo.bottom_cd);

    	$("#txt_BankTrade").val(abdocuInfo.btr_nm);
		$("#txt_BankTrade").attr("code", abdocuInfo.btr_cd);
		$("#txt_BankTrade_NB").val(abdocuInfo.btr_nb);
		$("#txt_Memo").val(abdocuInfo.rmk_dc.replace(/&apos;/g, "'").replace(/&quot;/g, '"').replace(/&amp;/, '&').replace(/&lt;/, '<').replace('&gt;',">"));		

		// 원인행위 등록 옵션 
		// 원인행위 옵션 사용인 경우 / 결의서 구분인경우 / 수입결의서가 아닌경우
		var selectDocuType = $('#selectDocu').val()!= 5;
    	if(erpOption.CauseUseYn == "1" && abdocuInfo.docu_mode == "1" && selectDocuType){
    		$("#causeForm").show();
			abdocu.CauseForminit();

    	    if(abdocuInfo.cause_dt){ 
    	    	 $("#CAUSE_DT").data("kendoDatePicker").value(ncCom_Date(abdocuInfo.cause_dt, '-'));
    	    }else{
    	    	$("#CAUSE_DT").attr("CODE", "empty");
    	    } 
			if(abdocuInfo.cause_dt){ 
				$("#SIGN_DT").data("kendoDatePicker").value(ncCom_Date(abdocuInfo.sign_dt, '-'));
    	    }
			if(abdocuInfo.cause_dt){ 
    	    	 $("#INSPECT_DT").data("kendoDatePicker").value(ncCom_Date(abdocuInfo.inspect_dt, '-'));
    	    }
    	    if(!abdocuInfo.cause_id){ $("#CAUSE_ID").attr("CODE", "empty"); } else{$("#CAUSE_ID").val(abdocuInfo.cause_id);}  
    	    if(!abdocuInfo.cause_nm){ $("#CAUSE_NM").attr("CODE", "empty"); } else{$("#CAUSE_NM").val(abdocuInfo.cause_nm);}
		}else{
			$("#causeForm").remove();
		}
		var datepicker = $("#txtGisuDate").data("kendoDatePicker").enable(false); 
		if($("#txtAcisuDate").length){
			var datepicker = $("#txtAcisuDate").data("kendoDatePicker").enable(false);
		}
		
    }


//    MakeTradeTable.mode.create(abdocuInfo.docu_fg, abdocuInfo.docu_mode);
    fnBudgetInfoSet();
    fnBudgetTableSet();
    fnTradeTableSet(1, 1);
    
//    erpOption.BgtAllocatUseYn
    
    //법인카드 사용내역(결의서 이고)
	if(abdocuInfo.docu_mode == "1" && (abdocuInfo.docu_fg !='5' && abdocuInfo.docu_fg !='6' &&  abdocuInfo.docu_fg !='7')){
		// $("#btnACardSungin").show();   
	} 
	
	abdocu.focusSet();
};
 

/**
 * 현재 문서가 참조품의 가져오기 한 결의서 인지?
 */ 
abdocu.isReffer = function(){
	return mode && abdocu_no_reffer;  
};


/* + 버튼 클릭시 한줄 추가 */
abdocu.append = function(type){
	var table;
	var sample;
	if(type == "b"){
		table = $("#erpBudgetInfo-table");
		sample = $("#erpBudgetInfo-tablesample");		
	}
	else {
		table = $("#erpTradeInfo-table");
		sample = $("#erpTradeInfo-tablesample");		
	}
	
	var tr_blank =   $("tr.blank", table);
	if(!tr_blank.length){
		var tr = $("tr", sample).clone(false);
		table.append(tr);
	}
	var imgTr = tr_blank.first();
	var erpappend = $('<div class="controll_btn al p0"><button type="button" id="" class="erpappend">추가</button></div>');
	
	var temptd = $("td", imgTr).first();
	if(!$(".erpappend", temptd).length){
		temptd.append(erpappend);
		
		erpappend.click(function(){
			var target = $(this);
			var table = target.parents("table");
			var id = table.attr("id");
	
			if(!acUtil.util.validationCheck(table)){
				return false;
			}
			
			if(id == "erpBudgetInfo-table"){ /* 예산 */
				if(abdocu_no){
					abdocu.TradeCardInit();
					var parentEle = abdocu.BudgetInfo.addRow();
                    if(abdocuInfo.docu_mode == "0"){
                    	if(abdocuInfo.docu_fg == "5"){
                			selectVat_Fg.data("kendoComboBox").value("3");
                			$(".tempVat_Fg", parentEle).val("3");
                			selectTr_Fg.data("kendoComboBox").value("2");
                			$(".tempTr_Fg", parentEle).val("2");
                		}
                		if(abdocuInfo.docu_fg == "6"){
                			selectVat_Fg.data("kendoComboBox").value("3");
                			$(".tempVat_Fg", parentEle).val("3");
                			selectTr_Fg.data("kendoComboBox").value("4");
                			$(".tempTr_Fg", parentEle).val("4");
                		}
                    }     
				}else{
					abdocu.ProjectInfo.focusNextRow();
					
				}
			}else if((id == "erpTradeInfo")){
				abdocu.TradeInfo.addRow(); /* 거래처 정보 */
			}
		});
	}
};



/*페이지 로드시 초기 데이터 셋팅*/
abdocu.init = function(){	
	/**
	 *  참조품의가져오기 한 지출결의서가 아닐경우(일반적인경우)
	 *  프로젝트 선택 가능하게~
	 */
	if(!abdocu.isReffer()){
		$("#project-td .search-Event-H, #budget-td .search-Event-B").show();
		$("#project-td #txt_ProjectName, .txt_BUDGET_LIST").attr("disabled", false);
	}

	/* 닫기*/
//	$("#btn_close").click(function(){
//		NeosUtil.close();
//	});
	
	abdocu.UserInfo.init();
	abdocu.ProjectInfo.init();

	/*상단부분 이미지 검색 클릭 이벤트*/
	$(".search-Event-H").bind({
		click : function(event){
			var parentEle = $(this).parent();
			var eventEle = $(".non-requirement, .requirement", parentEle).first();
			eventEle.dblclick();
		}
	});
//
//	$("#search-Event-T-etc").bind({
//		click : function(event){
//			$("#pop_CTD_CD").dblclick();
//		}
//	});
	
	/*참조품의 가져오기*/
	$("#btnReferConfer").bind({
		click : function(){
			abdocu.checkBClose(fnReferConferPop);
		}
	});
	
	var tr = $("#erpProjectInfo-table tr:eq(1)").first(); 
	abdocu.saveImageClick(tr);
//	abdocu.setCompany();
	
	BudgetComboxInit();
	
	acUtil.init();
	abdocu.eventHandlerMapping();

};

abdocu.checkCoCd = function(){
//	if(ncCom_Empty(abdocu.erp_co_cd)){
//		var eventEle = $("#spanCompany");
//		var dropdownlist = $("#spanCompany").data("kendoDropDownList");
//		var option = $(":selected", eventEle);
//		var erp_co_cd = dropdownlist.value();

//		$.ajax({
//			type: "POST",
//			dataType: "json",
//			url : _g_contextPath_ + "/neos/erp/g20/checkCoCd.do",
//			data : {erp_co_cd : abdocuInfo.erp_co_cd},		
//			success: function(result){
//
//	        	if(result.CO_CD != erp_co_cd){
//	        		alert("회사코드가 변경되었습니다( " + erp_co_cd + " ==> " + result.CO_CD + "). 사용자정보를 초기화 합니다. ");
//	    			var data = {
//	    						erp_co_cd : result.CO_CD,
//	    						erp_emp_cd : result.EMP_CD
//	    					};
//	    			abdocu.resetErpInfo(data);
//	        	}else{
//	        		abdocu.checkBClose(abdocu.ProjectInfo.RowSave_Process);
//	        	};
//			}
//		});
//	}else{
		abdocu.checkBClose(abdocu.ProjectInfo.RowSave_Process);
//	}	
};

// 마감체크 
abdocu.checkBClose = function(fn){

	var DIV_CD = $("#txtDIV_NM").attr("CODE");
	//var GISU_DT = $("#txtGisuYear").val() +$("#txtGisuMonth").val() + $("#txtGisuDay").val();
	
	var GISU_DT = $("#txtGisuDate").val().replace(/-/gi,"");
	if(GISU_DT.length!=8){
		GISU_DT = acUtil.util.getUniqueTime().substring(0,8);
	}
	
	var data = {
			DIV_CD : DIV_CD,
			GISU_DT : GISU_DT,
			CO_CD : abdocuInfo.erp_co_cd
		};
    var opt = {
            url : _g_contextPath_ + "/Ac/G20/Ex/chkErpBgtClose.do",
            stateFn : abdocu.state,
            async:false,
            data : data,
            successFn : function(date){
            	var result = date.selectList;
            	if(result != null){
            		if(result.CLOSE_YN == "1"){
            			alert(NeosUtil.getMessage("TX000009427","{0}일자로 결의서 입력이 마감되었습니다").replace("{0}",result.CLOSE_DT));
            		}else{
                		if(result.CLOSE_DT > GISU_DT){
                			alert(NeosUtil.getMessage("TX000011197","{0}일자로 결의서 입력이 마감되었습니다. 마감일자 이후에 작성하세요").replace("{0}",result.CLOSE_DT));
                		}else{
                			fn();
                		}
            		}
            	}else{
            		fn();
            	};
            }
    };
    acUtil.ajax.call(opt);
};

abdocu.focusSet = function(){
	if(focus){
		if("txt_BUDGET_LIST" == focus){
			$("#txtGisuYear, #txtGisuMonth, #txtGisuDay").attr("disabled", "disabled");
			$("#txtGisuDate").attr("disabled", "disabled");
			
			abdocu.BudgetInfo.init(null, focus + "1");
			
		}
//		$("#selectDocu").attr("disabled", "disabled");
	}
	else{
		$("#txt_ProjectName").focus();
		abdocu.BudgetInfo.remove();
		abdocu.TradeInfo.remove();
//		abdocu.append("b");
	}	
	
};

/**
 * 
 * erp 회사코드 선택할수있게 select box 추가
 * */
//abdocu.setCompany = function(){
//    var opt = {
//            url : _g_contextPath_ + "/neos/erp/g20/getErpMappingInfo.do",
//            stateFn:abdocu.state,
//            async:true,
//            data : {},
//            successFn : function(result){
//            	
//            	var erp_co_cd  = result.erp_co_cd;
//            	
//                $("#spanCompany").kendoDropDownList({
//                	template: '<span class="order-id" erp_emp_cd="#= ERP_EMP_CD #">#= ERP_CO_CD #</span> #= ERP_CO_NM #',
//                    dataTextField: "ERP_CO_NM",
//                    dataValueField: "ERP_CO_CD",
//                    dataSource: result.selectList,
//                    index: 0,
//                    select : function(e){
//                    	var item = e.item;
//                    	var index = item.index();
//                        var text = item.text();
//            			var data = {
//            				 erp_co_cd : result.selectList[index].ERP_CO_CD
//            				, erp_emp_cd : result.selectList[index].ERP_EMP_CD
//            					};
//            			abdocu.resetErpInfo(data);
//                    }
//                });
//                
//                var dropdownlist = $("#spanCompany").data("kendoDropDownList");
//                dropdownlist.value(erp_co_cd);
//                
//            	abdocu.focusSet();
//            }
//    };
//	
//    acUtil.ajax.call(opt);
//};
//abdocu.resetErpInfo = function(data){
//
//    var erp_co_cd = data.erp_co_cd;
//    var opt = {
//            url : _g_contextPath_ + "/neos/erp/g20/changeErpInfo.do",
//            stateFn:abdocu.state,
//            async:true,
//            data : data,
//            successFn : function(result){
//            	if(result.erp_co_cd ==erp_co_cd){
//            		var obj = {
//            				template_key : abdocu.template_key,
//            				mode : abdocu.docu_mode
//            		};
//            		
//            		$("#pop_contents").hide();
//            		$("#pop_loading").show();  
//            		 
//            		var param = NeosUtil.makeParam(obj);
//            		document.location.href = _g_contextPath_ + "/erp/g20/abdocu.do?" + param;
//            	}
//            }
//    };
//	
//    acUtil.ajax.call(opt);	
//};



abdocu.eventHandlerMapping = function(){
	abdocu.UserInfo.eventHandlerMapping();
	abdocu.ProjectInfo.eventHandlerMapping();
};

///*dialog 띄우기 전 띄워도 되는지 체크*/
//abdocu.dialogPreProcessing = function(param){
//	var returnBool = false;
//	if(!param || !$.isArray(param)){
//		returnBool = false;
//	}
//	else{
//		returnBool = true;
//	}
//	return returnBool;
//	//param
//};

abdocu.focusNextRow = function(eventEle){
	var part = eventEle.attr("part");
	var ActionMap = {
			user : abdocu.UserInfo.focusNextRow,
			project : abdocu.ProjectInfo.focusNextRow,
			budget : abdocu.BudgetInfo.focusNextRow,
			trade : abdocu.TradeInfo.focusNextRow,
			etcpop : abdocu.TradeInfo.focusNextRow_etcpop,
			paypop : abdocu.TradeInfo.focusNextRow_paypop
	};
	
	if(ActionMap[part]){
		ActionMap[part](eventEle);
	}
}; 

/* 01. ERP 사용자 정보 시작*/
abdocu.UserInfo.init = function(){

};
abdocu.UserInfo.focusNextRow = function(){
	var table =$("#erpUserInfo-table");
	if(!acUtil.util.validationCheck(table)){
		return false;
	}
	$("#txtGisuYear, #txtGisuMonth, #txtGisuDay").attr("disabled", "disabled");
	//$("#txtGisuDate").attr("disabled", "disabled");

//	$("#selectDocu").focus();
	$("#txt_ProjectName").focus();

	//neosdatepicker.datepicker("txtGisuDate", "disable");
	/*
	if($("#selectDocu").attr("disabled") == "disabled"){
		$("#txt_ProjectName").focus();
	}
	else{
		$("#selectDocu").focus();
	}
	*/

};

/*사용자정보 지정하는 이벤트 매핑*/
abdocu.UserInfo.eventHandlerMapping = function(){
//	var abdocu_no = abdocu_no || "0";
//	$(".search-Event-H", $("#txtDIV_NM").parent()).hide();
	var DIV_NM_event = function(id){

//		$(".search-Event-H", $("#" + id).parent()).show();
		$("#" + id).attr("disabled", false);
		/*회계단위*/
		$("#" + id).bind({
			dblclick : function(){
	            var id = $(this).attr("id");
	            var dblClickparamMap =
	                [{
	    				"id" : id,
	                    "text" : "DIV_NM",
	                    "code" : "DIV_CD"
	    			}];
				acUtil.util.dialog.dialogDelegate(acG20Code.getErpDIVList, dblClickparamMap);
			}
		});
	};
	
//	$(".search-Event-H", $("#txtDEPT_NM").parent()).hide();
	var DEPT_NM_event = function(id){
		userSearchID = id;
//		$(".search-Event-H", $("#" + id).parent()).show();
		$("#" + id).attr("disabled", false);
		$("#txtKOR_NM").attr("disabled", false);
		
	    $(":radio[name=B_use_YN]").bind({
    		change : function(event){
			    $("#" + id).dblclick();
	    	}
     	});
	    
	    $("#user_Search").bind({
    		click : function(event){
			    $("#" + id).dblclick();
	    	}
     	});
	    
		$("#userAllview").bind({
	    	click : function(event){
			    $("#" + userSearchID).dblclick();
	    	}
     	});	
		
	    /*결의부서/작업자*/
	    $("#" + id).bind({
	        dblclick : function(){
	            var id = $(this).attr("id");
	            var dblClickparamMap =
	                [{
	    				"id" : id,
	                    "text" : "DEPT_NM",
	                    "code" : "DEPT_CD"
	    			},
	    			{
	    				"id" : "txtKOR_NM",
	    				"text" : "KOR_NM",
	    				"code" : "EMP_CD"
	    			}];
	            acUtil.util.dialog.dialogDelegate(acG20Code.getErpDeptUserList, dblClickparamMap);
	        }
	    });
	};
	
	if(abdocu_no == "0"){
		DIV_NM_event("txtDIV_NM");	
		DEPT_NM_event("txtDEPT_NM");	
	}
};


/* 01. ERP 사용자 정보 끝*/

/* 02. 프로젝트 정보 시작*/

abdocu.ProjectInfo.init = function(){
};


abdocu.ProjectInfo.focusNextRow = function(){
	
	var table =$("#erpUserInfo-table");
	if(!acUtil.util.validationCheck(table)){
		return false;
	}
	
	var table =$("#erpProjectInfo-table");
	if(!acUtil.util.validationCheck(table)){
		return false;
	}
	abdocu.ProjectInfo.RowSave();
};
abdocu.ProjectInfo.eventHandlerMapping = function(){

	$(":radio[name=BankTrade_use_YN]").bind({
		change : function(event){
			$("#txt_BankTrade").dblclick();
		}
	});
	
    /*입출금 계좌*/
    $("#txt_BankTrade").bind({
        dblclick : function(){
            var id = $(this).attr("id");
            var dblClickparamMap =
				[{
                    "id" : id,
                    "text" : "ATTR_NM",
                    "code" : "TR_CD"
				},
    			{
    				"id" : "txt_BankTrade_NB",
    				"text" : "BA_NB",
    				"code" : ""
    			}];
            acUtil.util.dialog.dialogDelegate(getErpBTRList, dblClickparamMap);
        }
    });	
	
	if(abdocu.isReffer()){
		return;
	}
    /*프로젝트명*/
    $("#txt_ProjectName").bind({
        dblclick : function(){
            var id = $(this).attr("id");
            var dblClickparamMap =
                [{
					"id" : id,
                    "text" : "PJT_NM",
                    "code" : "PJT_CD"
				},
				{
					"id" : "txt_PJT_FR_DT",
					"text" : "PJT_FR_DT",
					"code" : "PJT_FR_DT"
				},
				{
					"id" : "txt_PJT_TO_DT",
					"text" : "PJT_TO_DT",
					"code" : "PJT_TO_DT"
				},
				{
					"id" : "txt_IT_BUSINESSLINK",
					"text" : "IT_BUSINESSLINK",
					"code" : "IT_BUSINESSLINK"
				}];

        	var erp_dept_cd= $("#txtDEPT_NM").attr("CODE");
        	var erp_emp_cd = $("#txtKOR_NM").attr("CODE");
        	
            if(erp_dept_cd == "" || erp_emp_cd == ""){
                alert(NeosUtil.getMessage("TX000009431","작성자정보를 선택해 주세요"));
        	}
            var tblParam = { };
            tblParam.EMP_CD = erp_emp_cd;
            tblParam.FG_TY = erpOption.BgtMngType;
            tblParam.CO_CD = abdocuInfo.erp_co_cd;
            
            acUtil.util.dialog.dialogDelegate(getErpMgtList, dblClickparamMap, null, fnMgtCdSet, tblParam);
        }
    });

    /*하위사업*/
    $("#txtBottom_cd").bind({
    	dblclick : function(){
    		
    		var MGT_CD = $("#txt_ProjectName").attr("CODE");
    	    if(!MGT_CD){
    	    	alert(NeosUtil.getMessage("TX000005402","프로젝트를 선택해주세요."));
    	    	$("#txt_ProjectName").focus();
    	    	return;
    	    }
    	   
    	    var tblParam = {};
    	    tblParam.MGT_CD = MGT_CD;
    	    tblParam.CO_CD = abdocuInfo.erp_co_cd;
    	    
    		var id = $(this).attr("id");
    		var dblClickparamMap =
    			[{
    				"id" : id,
    				"text" : "BOTTOM_NM",
    				"code" : "BOTTOM_CD"
    			}];
//    		acUtil.util.dialog.dialogDelegate(acG20Code.getErpAbgtBottomList, dblClickparamMap);
    		acUtil.util.dialog.dialogDelegate(acG20Code.getErpAbgtBottomList, dblClickparamMap, null, null, tblParam);
    	}
    });

    var table = $("#erpProjectInfo-table");  
	$(".requirement, .non-requirement", table).each(function(idx, vlaue){
		var addTabIndex = 200;
		$(this).attr("tabindex", addTabIndex + idx);
	});
};

function fnMgtCdSet(sel){
	console.log('Call fnMgtCdSet / callback project layer');
	var PJT_CD = sel.PJT_CD;
	if(PJT_CD != $("#temp_PjtCd").val()){
		$("#temp_PjtCd").val(PJT_CD);

		// 프로젝트에 연동된 거래처 있는경우 바로적용 
		if(sel.TR_CD && sel.ATTR_NM && sel.BA_NB){
			$("#txt_BankTrade").attr("CODE" ,sel.TR_CD);
			$("#txt_BankTrade").val(sel.ATTR_NM);
			$("#txt_BankTrade_NB").val(sel.BA_NB);
		}else { 
			$("#txt_BankTrade").attr("CODE" ,'');
			$("#txt_BankTrade").val('');
			$("#txt_BankTrade_NB").val('');
		}
		if(abdocu_no && abdocu_no != 0){
			var data = {abdocu_no : abdocu_no};
			/*ajax 호출할 파라미터*/
			var opt = {
					url : _g_contextPath_ + "/Ac/G20/Ex/delAbdocuH.do",
					stateFn : modal_bg,
					async : false,
					data  : data,
					successFn : function(result){
						abdocu.BudgetInfo.remove();
						$(".totalAM", "#erpBudgetInfo-table").html("");
						abdocu.TradeInfo.remove();
					}
			};
			acUtil.ajax.call(opt, null);
		}
	}
}

abdocu.ProjectInfo.RowSave = function(){
	abdocu.checkCoCd();
	//abdocu.checkBClose(abdocu.ProjectInfo.RowSave_Process);
	//abdocu.ProjectInfo.RowSave_Process();
};


abdocu.ProjectInfo.RowSave_Process = function(){

	var erp_year = acUtil.util.getUniqueTime().substring(0, 4);

	var erp_gisu_dt = $("#txtGisuDate").val().replace(/-/gi,"");
	
	var erp_acisu_dt = null;
	if($("#txtAcisuDate").length > 0){
		erp_acisu_dt = $("#txtAcisuDate").val().replace(/-/gi,"");
	}
	
	$("#txt_GisuDt").val(erp_gisu_dt.replace(/-/gi,""));

	if(erp_gisu_dt.length!=8){
		erp_gisu_dt = acUtil.util.getUniqueTime().substring(0,8);
	}
	var saveObj = {};
	
	saveObj.abdocu_no       = abdocuInfo.abdocu_no;
	saveObj.docu_mode       = abdocuInfo.docu_mode;
	saveObj.docu_fg         = abdocuInfo.docu_fg;
	saveObj.docu_fg_text    = abdocuInfo.docu_fg_text;
    saveObj.erp_co_cd       = abdocuInfo.erp_co_cd;
    saveObj.erp_co_nm       = abdocuInfo.erp_co_nm;
    saveObj.erp_div_cd      = $("#txtDIV_NM").attr("CODE");
    saveObj.erp_div_nm      = $("#txtDIV_NM").val();
    saveObj.erp_dept_cd     = $("#txtDEPT_NM").attr("CODE");
    saveObj.erp_dept_nm     = $("#txtDEPT_NM").val();
    saveObj.erp_emp_cd      = $("#txtKOR_NM").attr("CODE");
    saveObj.erp_emp_nm      = $("#txtKOR_NM").val();
    saveObj.mgt_cd          = $("#txt_ProjectName").attr("CODE");
	saveObj.mgt_nm_encoding = $("#txt_ProjectName").val();
	saveObj.bottom_nm       = $("#txtBottom_cd").val() || "";
	saveObj.bottom_cd       = $("#txtBottom_cd").attr("CODE") || "";
    saveObj.btr_cd          = $("#txt_BankTrade").attr("CODE");
    saveObj.btr_nm          = $("#txt_BankTrade").val();
    saveObj.btr_nb          = $("#txt_BankTrade_NB").val();
	saveObj.rmk_dc          = $("#txt_Memo").val();
    saveObj.erp_gisu_dt     = erp_gisu_dt;
    if(erp_acisu_dt){
    	saveObj.erp_acisu_dt     = erp_acisu_dt;
    }
    saveObj.erp_gisu_from_dt= "";
    saveObj.erp_gisu_to_dt  = "";
    saveObj.erp_gisu        = "0";
    saveObj.erp_year        = erp_year;
    saveObj.it_businessLink = $("#txt_IT_BUSINESSLINK").val();

	var resultData = {};
	/*ajax 호출할 파라미터*/
    var opt = {
    		url : _g_contextPath_ + "/Ac/G20/Ex/setAbdocuH.do",
    		stateFn : abdocu.state,
            async: true,
            data : saveObj,
            successFn : function(data){
            	
            	if(data){
                	var abdocu_no = data.result?data.result : "0";    
            		var obj = acUtil.util.getParamObj();
            		obj["abdocu_no"] = abdocu_no;
            		obj["focus"] = "txt_BUDGET_LIST";
            		obj["template_key"] = template_key;  
            		fnReLoad(obj);
            	}else{
					alert(NeosUtil.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요"));
            	}

            }
            ,
            failFn : function (request,status,error) {
    	    	alert(NeosUtil.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요")+".\n errorCode :"+request.responseText+"\n");
        	}
    };

    acUtil.ajax.call(opt, resultData);
};
/* 02. 프로젝트 정보 끝*/


/* 03. 예산정보 시작  abdocu_no가 존재할경우 하위 예산정보 목록 불러와서 화면에 보여준다.
 noInitSet : 첫번째 row 의 거래처정보 셋팅 할껀지 여부
 true : select 하지 않음
 false : 0 번째 로우에 select
 */
abdocu.BudgetInfo.init = function(noInitSet, focus){

	$(":radio[name=OPT_01]").bind({
		change : function(event){
			$("#" + $.eventEle).dblclick();
		}
	});
	$(":radio[name=OPT_02]").bind({
		change : function(event){
			$("#" + $.eventEle).dblclick();
		}
	});
	abdocu.BudgetInfo.remove();

	$("#erpBudget").show();
//	abdocu.BudgetInfo.selectInit();

	/*ajax 호출할 파라미터*/
	var resultData = {};
	var data = { abdocu_no : abdocuInfo.abdocu_no};
    var opt = {
            url : _g_contextPath_ + "/Ac/G20/Ex/getAbdocuB_List.do",            
            stateFn:abdocu.state,
            async:false,
            data : data,
            successFn : function(data){
            	var selectList = data.selectList;

            	for(var i = 0, max = selectList.length; i< max ; i++){
            		var result = selectList[i];
            		var parentEle = abdocu.BudgetInfo.addRow();

            		parentEle.attr("id", result.abdocu_b_no);
            		parentEle.attr("reffer_b_no", result.abdocu_b_no_reffer);

            		$(".txt_BUDGET_LIST", parentEle).val(result.abgt_nm).attr("CODE", result.abgt_cd);
//            		$(".selectNA_G20RESOL_WAY", parentEle).select(result.set_fg);
            		selectSet_Fg.data("kendoComboBox").value(result.set_fg);
            		$(".tempSet_Fg", parentEle).val(result.set_fg);
//            		$(".selectG20TAX_TP", parentEle).select(result.vat_fg);
            		selectVat_Fg.data("kendoComboBox").value(result.vat_fg);
            		$(".tempVat_Fg", parentEle).val(result.vat_fg);
//            		$(".selectG2TR_TP", parentEle).select(result.tr_fg);
            		selectTr_Fg.data("kendoComboBox").value(result.tr_fg);
            		$(".tempTr_Fg", parentEle).val(result.tr_fg);
            		$(".txt_BUDGET_DIV_NM", parentEle).val(result.div_nm2).attr("CODE", result.div_cd2);
            		$(".BGT01_NM", parentEle).val(result.erp_bgt_nm1);
            		$(".BGT02_NM", parentEle).val(result.erp_bgt_nm2);
            		$(".BGT03_NM", parentEle).val(result.abgt_nm).attr("CODE", result.abgt_cd);
            		$(".BGT04_NM", parentEle).val(result.erp_bgt_nm4);
            		$(".OPEN_AM", parentEle).val(result.erp_open_am);
            		$(".ACCT_AM", parentEle).val(result.erp_acct_am);
            		$(".DELAY_AM", parentEle).val(result.erp_delay_am);
            		$(".APPLY_AM", parentEle).val(result.erp_term_am);
            		$(".LEFT_AM", parentEle).val(result.erp_left_am);
            		$(".CTL_FG", parentEle).val(result.ctl_fg);
            		$(".RMK_DC", parentEle).val(result.rmk_dc);
        			$(".totalAM", parentEle).html(result.apply_am.toString().toMoney());
        			$(".totalAM", parentEle).attr("code" ,result.apply_am.toString().toMoney());

                    if(result.vat_fg == 3){
                    	selectTr_Fg.data("kendoComboBox").enable();
                    }
                    
            		//MakeTradeTable.mode.create(abdocu.docu_fg, abdocu.docu_mode);
            		if(i == 0 && !noInitSet){
            			var taxType = result.vat_fg; //$("#selectG20TAX_TP1").val();
            			fnTradeTableSet(result.tr_fg, taxType);
            			abdocu.TradeInfo.remove();
            			abdocu.BudgetInfo.rowSelect(result.abdocu_b_no);
            		}
            	}
            	if(!selectList.length){
            		abdocu.TradeInfo.remove();
            		$("#budgetInfo td").html("");
            	}
            	
            	abdocu.showItemsBtn();
            	
                var temptr = $("#erpBudgetInfo-table tr:not(.blank)");
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
//                	abdocu.BudgetInfo.addRow();
            		var parentEle = abdocu.BudgetInfo.addRow();
                    if(abdocuInfo.docu_mode == "0"){
                    	if(abdocuInfo.docu_fg == "5"){
                			selectVat_Fg.data("kendoComboBox").value("3");
                			$(".tempVat_Fg", parentEle).val("3");
                			selectTr_Fg.data("kendoComboBox").value("2");
                			$(".tempTr_Fg", parentEle).val("2");
                		}
                		if(abdocuInfo.docu_fg == "6"){
                			selectVat_Fg.data("kendoComboBox").value("3");
                			$(".tempVat_Fg", parentEle).val("3");
                			selectTr_Fg.data("kendoComboBox").value("4");
                			$(".tempTr_Fg", parentEle).val("4");
                		}
                    }            		
            		
                }else{
                	
            		var sample = $("#erpBudgetInfo-tablesample-empty");
            		var tr = $("tr", sample).clone(false);
            		if(removetr){
            			removetr.replaceWith(tr);
            		}
            		if(!abdocu_no_reffer){
            			abdocu.append("b");
            		}
            		     	
                }
                
                if(focus){
                	try{
                		$("#"+ focus).focus();
                	}catch(e){}
                }

            },
    	    error: function (request,status,error) {
    	    	alert(NeosUtil.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요")+".\n errorCode :"+request.responseText+"\n");
        	}
    }; 

    acUtil.ajax.call(opt, resultData);
};

abdocu.BudgetInfo.remove = function(){

	var sample = $("#erpBudgetInfo-tablesample-empty");

	var table = $("#erpBudgetInfo-table");
	$("tr", table).remove();
	for(var i = 0; i< 4 ; i++){
		var tr = $("tr", sample).clone(false);
		table.append(tr);
	}
	abdocu.TradeCardInit();
	abdocu.ItemsInit();
};

/* 선택되어있는 예산 ID */
abdocu.BudgetInfo.getSelectBudget = function(){
	return $(".on").attr("id"); /*선택되어있는 ROW ID*/
};

var selectSet_Fg ;
var selectVat_Fg ;
var selectTr_Fg ;
var selectTr_Fg_value ;

/**
 * 예산 row 추가 
 */
abdocu.BudgetInfo.addRow = function(){
	
//	abdocu.TradeCardInit();
	var table = $("#erpBudgetInfo-table");
	var trList = $("tr", table).not(".blank");
	trList.each(function(index){
		if(!$(trList[index]).attr("id")){
			$(trList[index]).remove();
		}
	});
	
	var sample = $("#erpBudgetInfo-tablesample");

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
			var empty = $("#erpBudgetInfo-tablesample-empty");
			var blank_tr = $("tr", empty).clone(false);
			table.append(blank_tr);
			tr.insertBefore($("tr.blank:first", table));
		}
		
	}else{
		table.append(tr);
	}

	/* 예산 삭제버튼  row */ 
	$(".btndeleteRow", tr).bind({
		click : function(event){
			var id = $(event.target).parents("tr").attr("id");
			if(id){
				abdocu.BudgetInfo.deleteRow(id);
			}
			else{
				abdocu.BudgetInfo.init(); 

			}
		}
	});
	
	/*예산영역 이미지(검색) 클릭이벤트*/
	$(".search-Event-B", tr).bind({
		click : function(event){

			var parentEle = $(this).parent();
			var eventEle = $(".non-requirement, .requirement", parentEle).first();

			eventEle.dblclick();

		}
	});

	var selTr_Fg_ID = $(".selectTr_Fg", tr).attr("id");
	var selVat_Fg_ID = $(".selectVat_Fg", tr).attr("id");
	var selSet_Fg_ID = $(".selectSet_Fg", tr).attr("id");
	
    selectTr_Fg = $("#"+selTr_Fg_ID).kendoComboBox({
    	dataSource : comboxSel.selTr_Fg,
    	dataTextField: "CODE_NM",
    	dataValueField: "CODE",
    	index: 0,
    	change: function(e) {
    		
    		var value = this.value();
    		selectTr_Fg_value = value;
    		var modeType = value;
    		if(abdocuInfo.docu_mode == "1"){ /*결의서*/
    			//        				var select = $("#" + id);
    			//        				var modeType = select.val();
    			
//        		var taxType = $("#"+selVat_Fg_ID).data("kendoComboBox").value();  //과세구분 
        		var taxType = $(".tempVat_Fg", tr).val();
        		var tempTr_Fg = $(".tempTr_Fg", tr).val();
        		

        		if(tempTr_Fg != modeType){
        			// 등록된 거래처가 있는지 체크 
            		var tableTrade = $("#erpTradeInfo-table");
            		var trList = $("tr:gt(0)", tableTrade).not(".blank");
            		var len = 0;
            		trList.each(function(index){
            			if($(trList[index]).attr("id")){
            				len ++;
            			}
            		});
            		
            		if(len > 0 ){
            			//    this.value(tempG2TR_TP);
            			//    alert("채주값이 등록되어 변경할수 없습니다. 채주값을 삭제후 변경바랍니다. ");
            			//    return;
            			var selModeTypeVal = MakeTradeTable.getTrType(modeType);
            			var tempModetypeVal = MakeTradeTable.getTrType(tempTr_Fg);
            			if(selModeTypeVal != tempModetypeVal){
            				this.value(tempTr_Fg);
            				alert(NeosUtil.getMessage("TX000009426","채주값이 등록되어 성격이 다른 채주유형으로 변경이 불가능합니다. 채주값을 삭제후 변경바랍니다"));
            				return;
            			}
            		}
        		}
        		$(".tempTr_Fg", tr).val(modeType);
//        		MakeTradeTable.mode.create(modeType, abdocuInfo.docu_mode, taxType);
				fnTradeTableSet(modeType, taxType);
        		var table = $("#erpBudgetInfo-table");
        		var id = $(".on", table).first().attr("id");
        		var select = $(".selectTr_Fg", tr);
        		
        		if(id){
        			abdocu.BudgetInfo.focusNextRow(select);
        			$(this).focus();
        		}else{
        			abdocu.TradeInfo.remove();
        			$(this).focus();
        		}
        	};
        }
    });
    selectTr_Fg.data("kendoComboBox").enable(false);
    
    selectVat_Fg = $("#"+selVat_Fg_ID).kendoComboBox({
    	dataSource : comboxSel.selVat_Fg,
    	dataTextField: "CODE_NM",
    	dataValueField: "CODE",
    	index: 0,
    	dataBound: function(e) {
    		if(this.value() =="3"){
     			$("#"+selTr_Fg_ID).data("kendoComboBox").enable(true);
     		}
    	} ,
    	change: function(e) {
    		
    		var value = this.value();
    		var taxType = value;
         	    
     		var tempVat_Fg = $(".tempVat_Fg", tr).val();
     		var tempTr_Fg = $(".tempTr_Fg", tr).val();
     		var tempModetypeVal = MakeTradeTable.getTrType(tempTr_Fg);

     		var tableTrade = $("#erpTradeInfo-table");
     		var trList = $("tr:gt(0)", tableTrade).not(".blank");
     		var len = 0;
     		trList.each(function(index){
     			if($(trList[index]).attr("id")){
     				len ++;
     			}
     		});
     		
     		if(len > 0 ){
     			if(tempModetypeVal == "1"){
     				alert(NeosUtil.getMessage("TX000009425","과세구분 변경시 채주의 공급가액부가세 데이터는 변경되지 않음으로 반드시 확인 바랍니다"));
     			}else{
     				this.value(tempVat_Fg);
     				alert(NeosUtil.getMessage("TX000011175","채주값이 등록되어 변경할수 없습니다. 채주값을 삭제후 변경바랍니다."));
					return;	
				}
     		}
             
     		$(".tempVat_Fg", tr).val(taxType);
     		if(abdocuInfo.docu_mode=="1"){
     			if(taxType =="3"){
         			$("#"+selTr_Fg_ID).data("kendoComboBox").enable(true);
         			//            		$(".selectG2TR_TP", tr).attr("disabled", false);
         		}else{
         			$("#"+selTr_Fg_ID).data("kendoComboBox").select(0);
         			$(".tempTr_Fg", tr).val("1");
         			$("#"+selTr_Fg_ID).data("kendoComboBox").enable(false);
         		}
     		}
     		
     		
     		var selectDocu = $("#selectDocu").val();
               
//               if(abdocu.docu_mode=="0" && MakeTradeTable.getModeType(abdocu.docu_mode, selectDocu) == "2"){				
////            	   MakeTradeTable.mode.create(selectDocu, abdocu.docu_mode, taxType);
//				   fnTradeTableSet();
//            	}
//               

     		var modeType = $(".tempTr_Fg", tr).val();
//   			   if(abdocu.docu_mode=="1" && MakeTradeTable.getModeType(abdocu.docu_mode, modeType) == "1"){
//   				   if(modeType){
//   					   //MakeTradeTable.mode.create(modeType, abdocu.docu_mode, taxType);
//					   fnTradeTableSet(modeType, taxType);
//   				   }
//   				}
     		
     		fnTradeTableSet(modeType, taxType);
     		var table = $("#erpBudgetInfo-table");
     		var id = $(".on", table).first().attr("id");
     		var select = $(".selectVat_Fg", tr);
//     		$(".tempVat_Fg", tr).val(value);
     		if(id){
     			abdocu.BudgetInfo.focusNextRow(select);
     			this.focus();
     		}else{
     			abdocu.TradeInfo.remove();
     			this.focus();
     		}
     	}    
    });
    
//	$(".selectG20TAX_TP", tr).bind({
//		change : function(){
//			var id = $(this).attr("id");
//			
//			var select = $("#" + id);
//			var taxType = select.val();
//			
//			var tempG20TAX_TP = $(".tempG20TAX_TP", tr).val();
//
//            var tableTrade = $("#erpTradeInfo-table");
//			var trList = $("tr:gt(0)", tableTrade).not(".blank");
//			var len = 0;
//			trList.each(function(index){
//				if($(trList[index]).attr("id")){
//					len ++;	
//				}	
//			});
//			    
//			if(len > 0 ){
//				select.val(tempG20TAX_TP);
//				alert("채주값이 등록되어 변경할수 없습니다. 채주값을 삭제후 변경바랍니다. ");
//				return;	
//			}
//
//			$(".tempG20TAX_TP", tr).val(taxType);
//			if(taxType =="3"){
//				selectG2TR_TP.data("kendoComboBox").enable();
////         		$(".selectG2TR_TP", tr).attr("disabled", false);
//         	}else{
//         		selectG2TR_TP.data("kendoComboBox").enable(false);
////       			$(".selectG2TR_TP", tr).attr("disabled", true);
////       			$(".selectG2TR_TP", tr).val("1");
//       			selectG2TR_TP.data("kendoComboBox").value(1);
//       		}
//			//var selectDocu = $("#selectDocu").val();
//			var selectDocu= $("#selectDocu").attr("CODE");
//			if(abdocu.docu_mode=="0" && MakeTradeTable.getModeType(abdocu.docu_mode, selectDocu) == "2"){				
//				MakeTradeTable.mode.create(selectDocu, abdocu.docu_mode, taxType);
//			}
//			
//			var modeType = $(".selectG2TR_TP", tr).val();
//			selectG2TR_TP.data("kendoComboBox").value();
//			if(abdocu.docu_mode=="1" && MakeTradeTable.getModeType(abdocu.docu_mode, modeType) == "1"){
//        		if(modeType){
//            		MakeTradeTable.mode.create(modeType, abdocu.docu_mode, taxType);
//        		}            				
//			}
//			
//     		var table = $("#erpBudgetInfo-table");
//			var id = $("." + abdocu.BudgetInfo.BudgetInfoSelectClass, table).first().attr("id");
//			if(id){
//			    abdocu.BudgetInfo.focusNextRow(select);
//				select.focus();
//		    }else{
//		    	abdocu.TradeInfo.remove();
//		    	select.focus();
//		    }
//		}
//	});
	
    // 결재수단
	selectSet_Fg = $(".selectSet_Fg", tr).kendoComboBox({
		dataSource : comboxSel.selSet_Fg,
		dataTextField: "CODE_NM",
		dataValueField: "CODE",
		index: 0,
		change: function(e) {
			var value = this.value();
			var table = $("#erpBudgetInfo-table");
			var id = $(".on", table).first().attr("id");
			var select = $(".selectSet_Fg", tr);

			$(".tempSet_Fg", tr).val(value);
			
			var IT_SBGTCDLINK = $(".IT_SBGTCDLINK", tr).val();
			
		    if( erpOption.BizGovUseYn != "1" || $("#txt_IT_BUSINESSLINK").val() != "1" || IT_SBGTCDLINK != "1" || select.val() == 4){
		    	$(".selectIT_USE_WAY", tr).val("");
	            $(".selectIT_USE_WAY", tr).attr("disabled", true);
	        }else{
	        	$(".selectIT_USE_WAY", tr).attr("disabled", false);
	        	$(".selectIT_USE_WAY", tr).val("01");
	        }
			
			if(id){
				abdocu.BudgetInfo.focusNextRow(select);
				this.focus();
			}else{
				abdocu.TradeInfo.remove();
				this.focus();
			}
		}   
    });	
	
	/*예산사업장은 예산회계단위와 동일하게*/
	(function(tr_){
		var text = $("#txtDIV_NM").val();
		var code = $("#txtDIV_NM").attr("CODE");
		$(".txt_BUDGET_DIV_NM", tr_).val(text).attr("CODE", code);
		$(".RMK_DC", tr_).val($("#txt_Memo").val());
		
		if(abdocuInfo.docu_mode == "0"){
			
			if(abdocuInfo.docu_fg == "5"){
				$("#"+selVat_Fg_ID).data("kendoComboBox").enable(false);
				$(".tempTr_Fg", tr_).val("2");
				$(".tempVat_Fg", tr_).val("3");
			}else if(abdocuInfo.docu_fg == "6"){
				$("#"+selVat_Fg_ID).data("kendoComboBox").enable(false);
				$(".tempTr_Fg", tr).val("4");
				$(".tempVat_Fg", tr).val("3");
			}
		}
		
	})(tr);
	
	
	abdocu.BudgetInfo.eventHandlerMapping(tr);
	acUtil.init(tr);
	
	/* 저장 버튼 클릭시*/
	abdocu.saveImageClick(tr);
	
	tr.bind({
		click : function(event){
			var rowSelectID = abdocu.BudgetInfo.getSelectBudget(); /*선택되어있는 ROW ID*/
			var eventid = $(this).attr("id"); /*event 발생한 row ID*/

			/*예산정보에서 다른 row(행)을 선택했을경우 거래처 다시 binding(DB조회)*/
			if(rowSelectID != eventid){
				if(eventid){
					abdocu.BudgetInfo.rowSelect(eventid);
					$(event.target).focus();
				}else{
					$("#p-card-div").remove();
					abdocu.TradeInfo.remove();
					$("#budgetInfo td").html("");
					var table = $("#erpBudgetInfo-table");
					$(".on", table).removeClass("on");
					$(this).addClass("on");
				}
			}
		}
	}).css("cursor","pointer");
	
	return tr;
};

abdocu.BudgetInfo.deleteRow = function(id){
	var resultData = {};
	var data = {};
	data.abdocu_no   = abdocuInfo.abdocu_no;
	data.abdocu_b_no = id;
    var opt = {
            url : _g_contextPath_ + "/Ac/G20/Ex/delAbdocuB.do",
            stateFn : abdocu.state,
            async : false,
            data : data,
            successFn : function(res){
                if(res.result && res.result =="delete"){
                	abdocu.BudgetInfo.init();
                }else{
                	alert(NeosUtil.getMessage("TX000008120","오류가 발생하였습니다"));
                }            	
            },
            error: function (request,status,error) {
            	alert(NeosUtil.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요")+".\n errorCode :"+request.responseText+"\n");
        	}
    };

    acUtil.ajax.call(opt, resultData);


};

abdocu.BudgetInfo.eventHandlerMapping = function(context, index){
	var table = $("#erpBudgetInfo-table");
	if(!context){
		context = table;
	}
	
	if(!abdocu.isReffer()){
	    /*예산과목명*/
	    $(".txt_BUDGET_LIST", context).bind({
	        dblclick : function(){
	        	
	        	/*ajax 호출할 파라미터*/
	            var GISU_DT = $("#txt_GisuDt").val();
	            var GR_FG = "2"; /*예산과목의 수입/지출구분*/
	            if(abdocuInfo.docu_mode=="1" &&  (abdocuInfo.docu_fg == "5" || abdocuInfo.docu_fg == "7") ){
	            	GR_FG = "1";
	            }
	            
	            if(abdocuInfo.docu_mode=="0" && abdocuInfo.docu_fg == "8"){
	            	GR_FG = "1";
	            }
	            
	            var DIV_CDS = $("#txtDIV_NM").attr("CODE") + "|";
	            var MGT_CDS = $("#txt_ProjectName").attr("CODE") + "|";
	            var BOTTOM_CDS = $("#txtBottom_cd").attr("CODE") || "";
	            //    if(BOTTOM_CDS !=""){ BOTTOM_CDS + '|';   }; 
	            if(!ncCom_Empty(BOTTOM_CDS)){ 
	                BOTTOM_CDS = BOTTOM_CDS + "|";   
	            };
	           
	            /* OPT_01(예산과목표시)   2 : 당기편성, 1 : 모든예산, 3 : 프로젝트기간 */
	            var OPT_01 = $(":input[name=OPT_01]:checked").val() || "2";
	            /* OPT_02(사용기한)   1 : 모두표시, 2 : 사용기한경과분 숨김 */
	            var OPT_02 = $(":input[name=OPT_02]:checked").val() || "1";
	            /* 상위과목표시( 1, 2 ) */
	            var OPT_03 = "2";

	            var tblParam = {}
	            tblParam.GISU_DT = GISU_DT;
	            tblParam.GR_FG = GR_FG;
	            tblParam.DIV_CDS = DIV_CDS;
	            tblParam.MGT_CDS = MGT_CDS;
	            tblParam.BOTTOM_CDS = BOTTOM_CDS;
	            tblParam.OPT_01 = OPT_01;
	            tblParam.OPT_02 = OPT_02;
	            tblParam.OPT_03 = OPT_03;
	            tblParam.CO_CD  = abdocuInfo.erp_co_cd;
	            tblParam.FR_DT  = abdocuInfo.erp_gisu_from_dt;
	            tblParam.TO_DT  = abdocuInfo.erp_gisu_to_dt;
	            tblParam.GISU   = abdocuInfo.erp_gisu;
	            tblParam.BgtStep7UseYn = erpOption.BgtStep7UseYn;
	            
	            var id = $(this).attr("id");
	            $.eventEle = id;
	            var dblClickparamMap =
	            	(function(ID, idx){
	            		var returnObj =
		                    [{
		    					"id" : id,
		                        "text" : "BGT_NM",
		                        "code" : "BGT_CD"
		    				},
		    				{
		    					"id" : "IT_SBGTCDLINK" + idx,
		                        "text" : "IT_SBGTCDLINK",
		                        "code" : "IT_SBGTCDLINK"
		    				}];
						return returnObj;
	
	            	})(id, index);
	            acUtil.util.dialog.dialogDelegate(acG20Code.getErpBudgetList, dblClickparamMap, null, fnBgtCdSet, tblParam);
	        }
	    });
	}
    /*예산사업장명*/
    $(".txt_BUDGET_DIV_NM", context).bind({
        dblclick : function(){
            var id = $(this).attr("id");
            var dblClickparamMap =
                [{
    				"id" : id,
                    "text" : "DIV_NM",
                    "code" : "DIV_CD"
    			}];

            acUtil.util.dialog.dialogDelegate(acG20Code.getErpDIVList, dblClickparamMap);
        }
    });
};

function fnBgtCdSet(sel, dblClickparamMap){
	/*event 발생한 txt_BUDGET_LIST(예산과목명) */
	abdocu.BudgetInfo.getBudgetInfo(dblClickparamMap[0].id);
	
	var eventEle = $("#" + dblClickparamMap[0].id);
	var parentEle = eventEle.parents("tr");

	var set_fg = $(".selectNA_G20RESOL_WAY", parentEle).val();
	var IT_SBGTCDLINK = $(".IT_SBGTCDLINK", parentEle).val();
	
    if( erpOption.BizGovUseYn != "1" || $("#txt_IT_BUSINESSLINK").val() != "1" || IT_SBGTCDLINK != "1" || set_fg == 4){
    	$(".selectIT_USE_WAY", parentEle).val("");
    	$(".selectIT_USE_WAY", parentEle).attr("disabled", true);
    }else{
    	$(".selectIT_USE_WAY", parentEle).val("01");
    	$(".selectIT_USE_WAY", parentEle).attr("disabled", false);
    }
}
abdocu.isHeaderChange = function(fn, id){

	//본지점회계여부
	//var use_yn = abdocu.permissionResult["USE_YN"];
//	var use_yn = abdocu.bonAccYn;
//	if(use_yn == "1"){
		if(id=="txtDIV_NM"){
			fn(id);
		}
//	}
	
	if(id=="txtDEPT_NM"){
		fn(id);
	}
	
//	if(abdocu.docu_mode == "0"){ /* 품의서 */
//		var sec_fg = abdocu.permissionResult["ANA0003"];
//		if(sec_fg == "1"){
////			if(id=="txtDIV_NM"){
////				fn(id);
////			}else 
//			if(id=="txtDEPT_NM"){
//				fn(id);
//			}
//		}
//		if(sec_fg == "2"){
//			if(id=="txtDEPT_NM"){
//				fn(id);
//			}
//		}
//		if(sec_fg == "3"){
//			if(id=="txtDEPT_NM"){
//				abdocu.sec_fg = sec_fg;
//				fn(id);
//			}
//			return true;
//		}
//		if(sec_fg == "4"){
//			return true;
//		}
//	} else{ /* 결의서 */
//		var sec_fg = abdocu.permissionResult["ANA0005"];
//		var sec_fg2 = abdocu.permissionResult["ANA0006"];
//		if(sec_fg == "1" || sec_fg2 == "1"){
////			if(id=="txtDIV_NM"){
////				fn(id);
////			}else 
//		    if(id=="txtDEPT_NM"){
//				fn(id);
//			}
//		}
//		else if(sec_fg == "2" || sec_fg2 == "2"){
//			if(id=="txtDEPT_NM"){
//				fn(id);
//			}
//		}
//		else if(sec_fg == "3" || sec_fg2 == "3"){
//			if(id=="txtDEPT_NM"){
//				abdocu.sec_fg = sec_fg;
//				fn(id);
//			}
//		}
//		else if(sec_fg == "4" || sec_fg2 == "4"){
//			
//		}
//	}
	return false;
};

/*예산액, 예산잔액, 집행액 구하기
 *
 parameter
 id : 예산과목 textbox  id
 */
abdocu.BudgetInfo.getBudgetInfo = function(id){
	if(id == null){
		id="txt_BUDGET_LIST";
	}
	
	var txt_BUDGET_LIST = $("#" + id);
	var obj =  {};
    obj.DIV_CD    = $("#txtDIV_NM").attr("CODE");
    obj.BGT_CD    = $("#txt_BUDGET_LIST").attr("CODE");
    obj.MGT_CD    = $("#txt_ProjectName").attr("CODE");
    obj.SUM_CT_AM = 0;
    obj.GISU_DT   = $('#txtGisuDate').val().replace(/-/gi,"");
    obj.BOTTOM_CD = $("#txtBottom_cd").attr("CODE") || "";
    obj.DOCU_MODE = 0;
    obj.CO_CD     = abdocuInfo.erp_co_cd;
    obj.FROM_DT     = abdocuInfo.erp_gisu_from_dt;
    obj.TO_DT     = abdocuInfo.erp_gisu_to_dt;
    obj.GISU      = abdocuInfo.erp_gisu;

	/*ajax 호출할 파라미터*/
    var opt = {
            url : _g_contextPath_ + "/Ac/G20/Ex/getBudgetInfo.do",
            stateFn:abdocu.state,
            async:false,
            data : obj,
            type:"post",
            successFn : function(data){
            	
            	/* TODO 상배: 예산단위 래밸에 따른 출력 포멧 변경이 필요함. 
            	 * 예산단위 확인할 방법이 필요 
            	 * */
            	
            	/*$.txt_BUDGET_LIST1, $.txt_BUDGET_LIS2  데이터 저장 */
            	var result = data.result;
            	$("#BGT01_NM").val(result.BGT01_NM);
            	$("#BGT02_NM").val(result.BGT02_NM);
            	$("#BGT03_NM").val(result.BGT03_NM).attr("CODE", result.BGT03_CD);
            	$("#BGT04_NM").val(result.BGT04_NM);
            	
            	$("#LEVEL01_NM").val(result.LEVEL01_NM);
            	$("#LEVEL02_NM").val(result.LEVEL02_NM);
            	$("#LEVEL03_NM").val(result.LEVEL03_NM);
            	$("#LEVEL04_NM").val(result.LEVEL04_NM);
            	$("#LEVEL05_NM").val(result.LEVEL05_NM);
            	$("#LEVEL06_NM").val(result.LEVEL06_NM);
            	            	
            	$("#OPEN_AM").val(result.OPEN_AM);
            	$("#ACCT_AM").val(result.ACCT_AM);
            	$("#DELAY_AM").val(result.DELAY_AM);
            	$("#APPLY_AM").val(result.APPLY_AM);
            	$("#LEFT_AM").val(result.LEFT_AM);
            	$("#CTL_FG").val(result.CTL_FG);

            	$("#td_veiw_BGT01_NM").html(result.BGT01_NM || "");
            	$("#td_veiw_BGT02_NM").html(result.BGT02_NM || "");
            	$("#td_veiw_BGT03_NM").html(result.BGT03_NM || "");
            	$("#td_veiw_BGT04_NM").html(result.BGT04_NM || "");
            	$("#td_veiw_OPEN_AM").html((result.OPEN_AM || "0").toString().toMoney());
            	$("#td_veiw_ACCEPT_AM").html((result.ACCEPT_AM || "0").toString().toMoney());
            	$("#td_veiw_APPLY_AM").html((result.ERP_APPLY_AM || "0").toString().toMoney());
            	$("#td_veiw_REFER_AM").html((result.REFER_AM || "0").toString().toMoney());
            	$("#td_veiw_LEFT_AM").html((result.LEFT_AM || ")").toString().toMoney());
            }
    };

    /*결과 데이터 담을 객체*/
    acUtil.resultData = {};
    acUtil.ajax.call(opt, acUtil.resultData );
};

function BudgetComboxInit(){
	
	comboxSel.selTr_Fg = NeosCodeUtil.getCodeList("G20_TR");
	comboxSel.selSet_Fg = NeosCodeUtil.getCodeList("G20SET");
	comboxSel.selVat_Fg = NeosCodeUtil.getCodeList("G20VAT");
};

abdocu.BudgetInfo.rowSelect = function(id){
	abdocu.TradeCardInit();
	if(!id){
		return;
	}
	var table = $("#erpBudgetInfo-table");
	var trEle = $("#" + id, table);

	$(".on", table).removeClass("on");
	trEle.addClass("on");

//	var modeType = selectG2TR_TP.data("kendoComboBox").value();
//	var taxType = selectG20TAX_TP.data("kendoComboBox").value();
	var modeType = $(".tempTr_Fg", trEle).val();
	var taxType = $(".tempVat_Fg", trEle).val();
	if(modeType && abdocuInfo.docu_mode == "1"){
//		MakeTradeTable.mode.create(modeType, abdocu.docu_mode, taxType);
		fnTradeTableSet(modeType, taxType);
		abdocu.TradeInfo.remove();                			
	}
	
	if($(".tempSet_Fg", trEle).val() == "4"){
    	$("#tradeCardBtn").show();
    	$('#btnACardSungin').show();
    }else{
    	$("#tradeCardBtn").hide();
    	$('#btnACardSungin').hide();
    }
	abdocu.TradeInfo.init();
	abdocu.TradeInfo.select(0, id);

	var txt_BUDGET_LIST = $(".txt_BUDGET_LIST", trEle).attr("id");
	abdocu.BudgetInfo.getBudgetInfo(txt_BUDGET_LIST);
	
	if(abdocu_no_reffer){ //참조품의 결의서일경우 
		fnGetConferBalance(id);  //품의 잔액 표시
	}
	
    if($(".tempTr_Fg", trEle).val() =="8" && gwOption.payAuth == "true"){
//    if($(".tempTr_Fg", trEle).val() =="8"){
    	$("#btnPayData").show();
    }else{
    	$("#btnPayData").hide();	
    }
	
};
abdocu.BudgetInfo.focusNextRow = function(eventEle){

	var table = $("#erpBudgetInfo-table");
	if(!acUtil.util.validationCheck(table, eventEle)){
		return false;
	}
	var resultData = {};
	abdocu.BudgetInfo.RowSave(eventEle, resultData);
};



abdocu.BudgetInfo.addRowImg = function(){
	abdocu.append("b");
};
/*예산정보 로우 저장하기*/
abdocu.BudgetInfo.RowSave = function(eventEle, resultData){
	
	var parentEle = eventEle.parents("tr");
	var abdocu_b_no = parentEle.attr("id") || "0";
	
	var saveObj = {
		 
//		,set_fg : $(".selectNA_G20RESOL_WAY", parentEle).val()
//		,vat_fg : $(".selectG20TAX_TP", parentEle).val()
//		,tr_fg : $(".selectG2TR_TP", parentEle).val()
         set_fg : $(".tempSet_Fg", parentEle).val()
		,vat_fg : $(".tempVat_Fg", parentEle).val()
		,tr_fg : $(".tempTr_Fg", parentEle).val()		
		,div_nm2 : $(".txt_BUDGET_DIV_NM", parentEle).val()
		,div_cd2 : $(".txt_BUDGET_DIV_NM", parentEle).attr("CODE")
		,erp_gisu_dt : $("#txt_GisuDt").val()
		,erp_gisu_sq : "0"
		,erp_bq_sq : "0"
		,erp_bgt_nm1 : $(".BGT01_NM", parentEle).val()
		,erp_bgt_nm2 : $(".BGT02_NM", parentEle).val()
		,erp_bgt_nm3 : $(".BGT03_NM", parentEle).val()
		,erp_bgt_nm4 : $(".BGT04_NM", parentEle).val()
		,erp_open_am : $(".OPEN_AM", parentEle).val()
		,erp_acct_am : $(".ACCT_AM", parentEle).val()
		,erp_delay_am : $(".DELAY_AM", parentEle).val()
		,erp_term_am : $(".APPLY_AM", parentEle).val()
		,erp_left_am : $(".LEFT_AM", parentEle).val()
		,ctl_fg : $(".CTL_FG", parentEle).val()
		,rmk_dc : $(".RMK_DC", parentEle).val()
		,it_use_way : ""
	}; 

	saveObj.abdocu_no = abdocuInfo.abdocu_no;
	saveObj.abdocu_b_no = abdocu_b_no;
	saveObj.docu_mode = abdocuInfo.docu_mode;
    saveObj.erp_co_cd = abdocuInfo.erp_co_cd;
	saveObj.abgt_cd   = $(".txt_BUDGET_LIST", parentEle).attr("CODE");
	saveObj.abgt_nm   = $(".txt_BUDGET_LIST", parentEle).val();
    saveObj.it_sbgtcdLink = $("IT_SBGTCDLINK").val();

	/*ajax 호출할 파라미터*/
    var opt = {
            url : _g_contextPath_ + "/Ac/G20/Ex/setAbdocuB.do",
            stateFn:abdocu.state,
            async:false,
            data : saveObj,
            successFn : function(data){
                if(data.result && data.result > 0){
                	var table = $("#erpBudgetInfo-table");
                	parentEle.attr("id", resultData.result);
            		abdocu.BudgetInfo.rowSelect(resultData.result);
            		if(!$("#erpBudgetInfo-tablesample-tr", table).length){
            			abdocu.BudgetInfo.addRowImg();
            		}                	
                }else{
                	alert(NeosUtil.getMessage("TX000008120","오류가 발생하였습니다"));
                }
            },
    	    error: function (request,status,error) {
    	    	alert(NeosUtil.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요")+".\n errorCode :"+request.responseText+"\n");
        	}
    };

    acUtil.ajax.call(opt, resultData);

};
/* 03. 예산정보 끝*/


/* 04. 거래처 정보 시작*/
abdocu.TradeInfo.init = function(){
	abdocu.TradeInfo.remove();
	//abdocu.TradeInfo.addRow(); 
};

/*
	 - 호출되는 경우
	1. 예산정보(중간) 에 따른 하위 거래처정보 목록 조회
	2. 예산정보에서 다른 row(행)을 선택했을경우 거래처 다시 binding(DB조회)
*/
abdocu.TradeInfo.select = function(rowSelectID, eventid){

	//abdocu.BudgetInfo.rowSelect(eventid);
	var abdocu_b_no = eventid;

	if(!abdocu_b_no){
		//return false;
	}

	//abdocu.TradeInfo.remove();
	/*ajax 호출할 파라미터*/
	var resultData = {};
	var data = { abdocu_b_no : abdocu_b_no};
    var opt = {
            url : _g_contextPath_ + "/Ac/G20/Ex/getAbdocuT_List.do",
            stateFn:abdocu.state,
            async:false,
            data : data,
            successFn : function(data){
            	tradeListForUI = data.selectList;
            	tradeListIndexForUI = 0;
            	fnAddTradeList();
            }
    };
    acUtil.ajax.call(opt, resultData);    
};

var tradeListForUI = null;
var tradeListIndexForUI = 0;
/*	[채주] 채주유형 UI갱신 범용성 추가
------------------------------------------------------ */
function fnAddTradeList(){
	var selectList = tradeListForUI;
	if(tradeListIndexForUI < tradeListForUI.length){
		var i = tradeListIndexForUI;
		
		var result = selectList[i];
		var parentEle = abdocu.TradeInfo.addRow();
		parentEle.attr("id", result.abdocu_t_no);
		var tr_cd = "";
		if(!result.tr_cd){
			tr_cd = "empty";
		}else{
		    tr_cd = result.tr_cd;
		}
		/* 카드 사용내역 TR_CD - > empty 들어감. */
		$(".txt_TR_NM", parentEle).attr("CODE", tr_cd);/*거래처코드*/
		$(".txt_TR_NM", parentEle).val(result.tr_nm);/*거래처명*/
		$(".txt_CEO_NM", parentEle).val(result.ceo_nm);/*대표자명*/
		$(".txt_UNIT_AM", parentEle).val(result.unit_am.toMoney());/*금액*/
		$(".txt_SUP_AM", parentEle).val(result.sup_am.toMoney());/*공급가액*/
		$(".txt_VAT_AM", parentEle).val(result.vat_am.toMoney());/*부가세*/
		$(".txt_BTR_NM", parentEle).val(result.btr_nm);/*금융기관*/
		$(".txt_BTR_NM", parentEle).attr("CODE", result.btr_cd);/*금융기관*/
		$(".txt_JIRO_NM", parentEle).val(result.jiro_nm);/*금융기관*/
		$(".txt_JIRO_CD", parentEle).attr("CODE", result.jiro_cd);/*금융기관*/
		$(".txt_DEPOSITOR", parentEle).val(result.depositor);/*예금주*/
		$(".txt_BA_NB", parentEle).val(result.ba_nb);/*계좌번호*/
		$(".txt_RMK_DC", parentEle).val(result.rmk_dc);/*비고*/
		$(".txt_REG_NB", parentEle).val(result.reg_nb);/*사업자코드*/
		$(".txt_TEL", parentEle).val(result.tel);/*전화번호*/
		if(taxDt_Id){
			$("#"+taxDt_Id).data("kendoDatePicker").value(ncCom_Date(result.tax_dt, '-')); /*신고기준일*/	
		}
		$(".tempTAX_DT", parentEle).val(result.tax_dt); /*신고기준일*/
		if(taxDt_Id2){
			$("#"+taxDt_Id2).data("kendoDatePicker").value(ncCom_Date(result.tax_dt2, '-')); /*회계발의일*/	
			$(".tempTAX_DT2", parentEle).val(result.tax_dt2); /*회계발의일*/
		}
		
		$(".txt_ITEM_NM", parentEle).val(result.item_nm);/*품명*/
		// $(".txt_ITEM_CNT", parentEle).val(result.item_cnt.toMoney());/*수량*/
        $(".txt_ITEM_CNT", parentEle).val((result.item_cnt === undefined || !result.item_cnt ? '0' : result.item_cnt).toString().toMoney()); /*수량*/
		// $(".txt_ITEM_AM", parentEle).val(result.item_am.toMoney());/* 단가*/
        $(".txt_ITEM_AM", parentEle).val((result.item_am === undefined || !result.item_am ? '0' : result.item_am).toString().toMoney()); /* 단가 */
		$(".txt_EMP_NM", parentEle).val(result.emp_nm);/*사원명*/
		$(".txt_TR_FG", parentEle).val(result.tr_fg);/*erp data*/
		$(".txt_TR_FG_NM", parentEle).val(result.tr_fg_nm);/*erp data*/
		$(".txt_ATTR_NM", parentEle).val(result.attr_nm);/*erp data*/
		$(".txt_PPL_NB", parentEle).val(result.ppl_nb);/*erp data*/
		$(".txt_ADDR", parentEle).val(result.addr);/*erp data*/
		$(".txt_TRCHARGE_EMP", parentEle).val(result.trcharge_emp);/*erp data*/
		$(".txt_JIRO_CD", parentEle).val(result.jiro_cd);/*erp data*/
		$(".txt_JIRO_NM", parentEle).val(result.jiro_nm);/*erp data*/
		$(".txt_CTR_NM", parentEle).val(result.ctr_nm);/*erp data*/
		$(".txt_CTR_CD", parentEle).val(result.ctr_cd);/*erp data*/
		$(".txt_CTR_CARD_NUM", parentEle).val(result.ctr_card_num);/*erp data*/
		$(".txt_ETCDUMMY1", parentEle).val(result.etcdummy1);/*erp data*/
		$(".txt_DATA_CD", parentEle).val(result.etcdata_cd);/*erp data*/
		$(".txt_ET_YN", parentEle).val(result.et_yn);/*erp data*/
		$(".txt_ETCRVRS_YM", parentEle).val(result.etcrvrs_ym);/*erp data*/
		$(".txt_NDEP_AM", parentEle).val(result.ndep_am);/*erp data*/
		$(".txt_INAD_AM", parentEle).val(result.inad_am);/*erp data*/
		$(".txt_INTX_AM", parentEle).val(result.intx_am);/*erp data*/
		$(".txt_RSTX_AM", parentEle).val(result.rstx_am);/*erp data*/
		$(".txt_WD_AM", parentEle).val(result.wd_am);/*erp data*/
		$(".txt_ETCRATE", parentEle).val(result.etcrate);/*erp data*/
		
		$(".txt_BA_NB_H", parentEle).val(result.ba_nb);/*erp data*/
		$(".txt_DEPOSITOR_H", parentEle).val(result.depositor);/*erp data*/
		$(".txt_BTR_NM_H", parentEle).val(result.jiro_nm);/*erp data*/
		$(".txt_BTR_CD_H", parentEle).val(result.jiro_cd);/*erp data*/
		
		/* CMS연동체주 금액 변경 불가 */
		if(result.cms_YN == 'Y'){
			$(".txt_UNIT_AM", parentEle).prop( "disabled", true );
			$(".txt_SUP_AM", parentEle).prop( "disabled", true );
			
			/* 과세 구분 기타가 아닌경우 비활성화 처리 */
			var selectBudgetTr = $("#erpBudgetInfo-table .on");
			if($(".tempVat_Fg", selectBudgetTr).val() != 3){
				$(".txt_VAT_AM", parentEle).prop( "disabled", true );
			}
		}
		
		tradeListIndexForUI++ ;
		setTimeout(fnAddTradeList, 5);
	}else{
	    var temptr = $("#erpTradeInfo-table tr:not(.blank)");
		var removetr = null;
		var isAddRow = true; 
		temptr.each(function(){
			if(!$(this).attr("id")){
				removetr = $(this);
			}else{
				isAddRow = false;
			}
		});
		 
		/* 상배 채주유형 4개 */
		/* 정상입력된 거래처정보가 하나라도 있으면 empty 없으면 빈라인 생성 */
	    if(true){
	    	abdocu.TradeInfo.addRow();
	    }else{
	    	
			var sample = $("#erpTradeInfo-tablesample-empty");
			var tr = $("tr", sample).clone(false);
			if(removetr){
				removetr.replaceWith(tr);
			}
			abdocu.append("t");
	    }
	}
}





/*거래처정보 저장*/
/**
 * 
 */
var savedLog = {};
abdocu.TradeInfo.RowSave = function(eventEle, resultData){
	tmpEventEle = eventEle;
	var parentEle = eventEle.parents("tr");
	var abdocu_t_no = parentEle.attr("id") || "0";
	var abdocu_b_no = abdocu.BudgetInfo.getSelectBudget();
	if(!abdocu_b_no){
		return false;
	}	
	 
	var tr_cd  = $(".txt_TR_NM", parentEle).attr("CODE") || "";/*거래처코드*/
	if("empty" == tr_cd){
		tr_cd = "";
	}
	
	var tax_dt = $(".tempTAX_DT", parentEle).val()|| "";
	tax_dt = tax_dt.replace(/-/gi,"");
	if(tax_dt !="" &&  tax_dt.length !=  8 ){
		alert(NeosUtil.getMessage("TX000011168","부가세신고일을 8자리로 입력하세요(예 20161111 또는 20161112)"));
		return;
	}
    var saveObj = {};    
    saveObj.abdocu_no   = abdocuInfo.abdocu_no;  /*프로젝트정보 키코드*/
    saveObj.abdocu_b_no = abdocu_b_no || ""; /*예산정보 키코드*/
    saveObj.abdocu_t_no = abdocu_t_no || ""; /*거래처정보 키코드*/
    saveObj.erp_co_cd   = abdocuInfo.erp_co_cd;
    saveObj.docu_mode   = abdocuInfo.docu_mode || "";
    saveObj.tr_cd       = tr_cd; /*거래처코드*/
    saveObj.tr_nm       = $(".txt_TR_NM", parentEle).val().replace('\\', '') || ""; /*거래처명*/
    saveObj.ceo_nm      = $(".txt_CEO_NM", parentEle).val() || ""; /*대표자명*/
    saveObj.unit_am     = ($(".txt_UNIT_AM", parentEle).val() || "").valueOf().toString().toMoney2() || "0"; /*금액*/
    saveObj.sup_am      = ($(".txt_SUP_AM", parentEle).val() || "").valueOf().toString().toMoney2() || "0"; /*공급가액*/
    saveObj.vat_am      = ($(".txt_VAT_AM", parentEle).val() || "").valueOf().toString().toMoney2() || "0"; /*부가세*/
    saveObj.btr_nm      = $(".txt_BTR_NM", parentEle).val() || $(".txt_BTR_NM_H", parentEle).val() ||""; /*금융기관*/
    saveObj.btr_cd      = $(".txt_BTR_NM", parentEle).attr("CODE") || $(".txt_BTR_CD_H", parentEle).val() ||"";/*금융기관*/
    saveObj.jiro_nm     = $(".txt_JIRO_NM", parentEle).val() || ""; /*금융기관*/
    saveObj.jiro_cd     = $(".txt_JIRO_CD", parentEle).attr("CODE") || $(".txt_JIRO_CD", parentEle).val() ||""; /*금융기관*/
    saveObj.depositor   = $(".txt_DEPOSITOR", parentEle).val() || $(".txt_DEPOSITOR_H", parentEle).val() || ""; /*예금주*/
    saveObj.item_nm     = $(".txt_ITEM_NM", parentEle).val() || ""; /*품명*/
    saveObj.item_cnt    = ($(".txt_ITEM_CNT", parentEle).val() || "").valueOf().toString().toMoney2() || "0" || ""; /*수량*/
    saveObj.item_am     = ($(".txt_ITEM_AM", parentEle).val() || "").valueOf().toString().toMoney2() || "0" || ""; /*단가*/
    saveObj.emp_nm      = $(".txt_EMP_NM", parentEle).val() || ""; /*사원명*/
    saveObj.ba_nb       = $(".txt_BA_NB", parentEle).val() || $(".txt_BA_NB_H", parentEle).val() ||""; /*계좌번호*/
    saveObj.rmk_dc      = $(".txt_RMK_DC", parentEle).val() || ""; /*비고*/
    saveObj.ctr_cd      = $(".txt_CTR_CD", parentEle).val() || ""; /*카드거래처 코드*/
    saveObj.ctr_card_num = $(".txt_CTR_CARD_NUM", parentEle).val() || ""; /*카드거래처 코드*/
    saveObj.ctr_nm      = $(".txt_CTR_NM", parentEle).val() || ""; /*카드거래처 이름*/    
    saveObj.reg_nb      = $(".txt_REG_NB", parentEle).val() || ""; /*사업자코드*/
    saveObj.tel         = $(".txt_TEL", parentEle).val() || ""; /*전화번호*/
    saveObj.ndep_am     = ($(".txt_NDEP_AM", parentEle).val() || "").valueOf().toString().toMoney2() || "0"; /*기타소득필요경비*/
    saveObj.inad_am     = ($(".txt_INAD_AM", parentEle).val() || "").valueOf().toString().toMoney2() || "0";  /*소득금액*/
    saveObj.intx_am     = ($(".txt_INTX_AM", parentEle).val() || "").valueOf().toString().toMoney2() || "0";  /*소득세액*/
    saveObj.rstx_am     = ($(".txt_RSTX_AM", parentEle).val() || "").valueOf().toString().toMoney2() || "0";  /*주민세액*/
    saveObj.wd_am       = ($(".txt_WD_AM", parentEle).val() || "").valueOf().toString().toMoney2() || "0"; 
    saveObj.etcrvrs_ym  = $(".txt_ETCRVRS_YM", parentEle).val() ||""; /*기타소득귀속년월*/
    saveObj.etcdummy1   = $(".txt_ETCDUMMY1", parentEle).val() ||""; /*소득구분*/
    saveObj.etcdata_cd  = $(".txt_DATA_CD", parentEle).val() ||""; /*소득구분*/
    saveObj.tax_dt      = tax_dt; /*신고기준일*/
    saveObj.it_use_dt   = ""; 
    saveObj.it_use_no   = ""; 
    saveObj.it_card_no  = ""; 
    saveObj.et_yn       = $(".txt_ET_YN", parentEle).val() || ""; /*erp data*/
    saveObj.tr_fg       = $("#erpBudgetInfo-table>tbody>.on").find('input[name="selectTr_Fg"]').val(); // $(".txt_TR_FG", parentEle).val() || "";  /*erp data*/
    saveObj.tr_fg_nm    = $("#erpBudgetInfo-table>tbody>.on").find('input[name="selectTr_Fg_input"]').val(); // $(".txt_TR_FG_NM", parentEle).val() || ""; /*erp data*/
    saveObj.attr_nm     = $(".txt_ATTR_NM", parentEle).val() || ""; /*erp data*/
    saveObj.ppl_nb      = $(".txt_PPL_NB", parentEle).val() || ""; /*erp data*/
    saveObj.addr        = $(".txt_ADDR", parentEle).val() || ""; /*erp data*/
    saveObj.trcharge_emp = $(".txt_TRCHARGE_EMP", parentEle).val() || ""; /*erp data*/
    saveObj.etcrate     = $(".txt_ETCRATE", parentEle).val() || ""; /*erp data*/
   
    if($(".tempTAX_DT2", parentEle)){
    	var tax_dt2 = $(".tempTAX_DT2", parentEle).val()|| "";
    	tax_dt2 = tax_dt2.replace(/-/gi,"");
    	if(tax_dt2 !="" &&  tax_dt2.length !=  8 ){
    		alert(NeosUtil.getMessage("","회계발의일을 8자리로 입력하세요(예 20161111 또는 20161112)"));
    		return;
    	}
    	saveObj.tax_dt2 = tax_dt2
    }
    
    /*ajax 호출할 파라미터*/
    var opt = {
    	  url     : _g_contextPath_ + "/Ac/G20/Ex/setAbdocuT.do"
    	, stateFn : abdocu.state
    	, async   : false
    	, data    : saveObj
    	, successFn : function(data){
    		var table = $("#erpBudgetInfo-table");
    		var parentEle = $(".on", table);
    		var id = $(".txt_BUDGET_LIST", parentEle).attr("id");
    		abdocu.BudgetInfo.rowSelect(abdocu_b_no);
    		
    		if(resultData.result && resultData.result > 0){
    			$("#" + abdocu_b_no + " .totalAM", "#erpBudgetInfo-table").html("");
    		}
    		
    		if(resultData.abdocu_B && resultData.abdocu_B.apply_am){
    			/* 상배 vatIgnore */
    			$("#" + abdocu_b_no + " .totalAM", "#erpBudgetInfo-table").html( resultData.abdocu_B.apply_am.toString().toMoney());
    			$("#" + abdocu_b_no + " .totalAM", "#erpBudgetInfo-table").attr("code" ,resultData.abdocu_B.apply_am.toString().toMoney());
    			abdocu.showItemsBtn();
    		}
    		
    		abdocu.TradeInfo.addRow();
    	},
    	error: function (request,status,error) {
    		alert(NeosUtil.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요")+".\n errorCode :"+request.responseText+"\n");
        }
    };

    
    acUtil.ajax.call(opt, resultData);


};

var taxDt_Id;
abdocu.TradeInfo.addRow = function(){
	
	var table = $("#erpTradeInfo-table");
	var trList = $("tr:gt(0)", table).not(".blank");
	trList.each(function(index){
		if(!$(trList[index]).attr("id")){
			$(trList[index]).remove();
		}
	});

	var sample = $("#erpTradeInfo-tablesample");

	var tr = $("tr", sample).clone(false);
	$(".on", table).removeClass("on");
	$(tr).addClass("on");

	var addId = $("tr", table).not(".blank").length + 1;
	var addTabIndex = parseInt(addId, 10) * 1000;
	var i = 1;	
	$(".show",tr).each(function(idx, vlaue){
		var id = $(this).attr("id");
		var tabIndex = $(this).attr("tabindex");
		/*name 은 id 와 같게, tabindex 는 (x)번째 행 * 100 */
		$(this).addClass(id).attr("name", id).attr("id", id + addId);
		var type = $(this).attr("type");
		if(type!= "hidden"){/*hidden 에는 tabindex 안준다.*/
			$(this).attr("tabindex", addTabIndex + i);
			i++;
		}
	});
	
	$(".btndeleteRow", tr).bind({
		click : function(event){
			var id = $(event.target).parents("tr").attr("id");
			if(id){
				abdocu.TradeInfo.deleteRow(id);
			}else{
				
				var rowSelectID = abdocu.BudgetInfo.getSelectBudget(); /*선택되어있는 ROW ID*/
				abdocu.BudgetInfo.rowSelect(rowSelectID);
			}
			
		}
	});

	var blank = $(".blank", table);
	if(blank.length){
		if($("tr", table).length < 5){
//			tr.insertBefore($("tr.blank:first", table));
			blank.first().replaceWith(tr);
		}
		else{
			blank.remove();
			var empty = $("#erpTradeInfo-tablesample-empty");
			var blank_tr = $("tr", empty).clone(false);
			table.append(blank_tr);
			tr.insertBefore($("tr.blank:first", table));
			
//			blank.first().replaceWith(tr);
		}
	}else{
		table.append(tr);
	}
	abdocu.TradeInfo.eventHandlerMapping(tr, addId);
	acUtil.init_trade(tr);

	$("input[type=text]", tr).first().focus();

	//금액
	tempparentEle = null;
	$(".txt_UNIT_AM", tr).bind({
		focusout : function(event){
			tempparentEle = $(this).closest('tr');
			var parentEle = $(this).closest('tr');
			var abdocu_t_no = parentEle.attr("id") || "0";
			var abdocu_b_no = abdocu.BudgetInfo.getSelectBudget();
			if(!abdocu_b_no){
				return false;
			}	
			 
			var tr_cd  = $(".txt_TR_NM", parentEle).attr("CODE") || "";/*거래처코드*/
			if("empty" == tr_cd){
				tr_cd = "";
			}
			
			var tax_dt = $(".tempTAX_DT", parentEle).val()|| "";
			tax_dt = tax_dt.replace(/-/gi,"");
			if(tax_dt !="" &&  tax_dt.length !=  8 ){
				alert(NeosUtil.getMessage("TX000011168","부가세신고일을 8자리로 입력하세요(예 20161111 또는 20161112)"));
				return;
			}
		    var saveObj = {};    
		    saveObj.abdocu_no   = abdocuInfo.abdocu_no;  /*프로젝트정보 키코드*/
		    saveObj.abdocu_b_no = abdocu_b_no || ""; /*예산정보 키코드*/
		    saveObj.abdocu_t_no = abdocu_t_no || ""; /*거래처정보 키코드*/
		    saveObj.erp_co_cd   = abdocuInfo.erp_co_cd;
		    saveObj.docu_mode   = abdocuInfo.docu_mode || "";
		    saveObj.tr_cd       = tr_cd; /*거래처코드*/
		    saveObj.tr_nm       = $(".txt_TR_NM", parentEle).val().replace('\\', '') || ""; /*거래처명*/
		    saveObj.ceo_nm      = $(".txt_CEO_NM", parentEle).val() || ""; /*대표자명*/
		    saveObj.unit_am     = ($(".txt_UNIT_AM", parentEle).val() || "").valueOf().toString().toMoney2() || "0"; /*금액*/
		    saveObj.sup_am      = ($(".txt_SUP_AM", parentEle).val() || "").valueOf().toString().toMoney2() || "0"; /*공급가액*/
		    saveObj.vat_am      = ($(".txt_VAT_AM", parentEle).val() || "").valueOf().toString().toMoney2() || "0"; /*부가세*/
		    saveObj.btr_nm      = $(".txt_BTR_NM", parentEle).val() || $(".txt_BTR_NM_H", parentEle).val() || ""; /*금융기관*/
		    saveObj.btr_cd      = $(".txt_BTR_NM", parentEle).attr("CODE")|| $(".txt_BTR_CD_H", parentEle).val() || "";/*금융기관*/
		    saveObj.jiro_nm     = $(".txt_JIRO_NM", parentEle).val() || ""; /*금융기관*/
		    saveObj.jiro_cd     = $(".txt_JIRO_CD", parentEle).val() || ""; /*금융기관*/
		    saveObj.depositor   = $(".txt_DEPOSITOR", parentEle).val() || $(".txt_DEPOSITOR_H", parentEle).val() ||""; /*예금주*/
		    saveObj.item_nm     = $(".txt_ITEM_NM", parentEle).val() || ""; /*품명*/
		    saveObj.item_cnt    = ($(".txt_ITEM_CNT", parentEle).val() || "").valueOf().toString().toMoney2() || "0" || ""; /*수량*/
		    saveObj.item_am     = ($(".txt_ITEM_AM", parentEle).val() || "").valueOf().toString().toMoney2() || "0" || ""; /*단가*/
		    saveObj.emp_nm      = $(".txt_EMP_NM", parentEle).val() || ""; /*사원명*/
		    saveObj.ba_nb       = $(".txt_BA_NB", parentEle).val() || $(".txt_BA_NB_H", parentEle).val() ||""; /*계좌번호*/
		    saveObj.rmk_dc      = $(".txt_RMK_DC", parentEle).val() || ""; /*비고*/
		    saveObj.ctr_cd      = $(".txt_CTR_CD", parentEle).val() || ""; /*카드거래처 코드*/
		    saveObj.ctr_card_num = $(".txt_CTR_CARD_NUM", parentEle).val() || ""; /*카드거래처 코드*/
		    saveObj.ctr_nm      = $(".txt_CTR_NM", parentEle).val() || ""; /*카드거래처 이름*/    
		    saveObj.reg_nb      = $(".txt_REG_NB", parentEle).val() || ""; /*사업자코드*/
		    saveObj.tel         = $(".txt_TEL", parentEle).val() || ""; /*전화번호*/
		    saveObj.ndep_am     = ($(".txt_NDEP_AM", parentEle).val() || "").valueOf().toString().toMoney2() || "0"; /*기타소득필요경비*/
		    saveObj.inad_am     = ($(".txt_INAD_AM", parentEle).val() || "").valueOf().toString().toMoney2() || "0";  /*소득금액*/
		    saveObj.intx_am     = ($(".txt_INTX_AM", parentEle).val() || "").valueOf().toString().toMoney2() || "0";  /*소득세액*/
		    saveObj.rstx_am     = ($(".txt_RSTX_AM", parentEle).val() || "").valueOf().toString().toMoney2() || "0";  /*주민세액*/
		    saveObj.wd_am       = ($(".txt_WD_AM", parentEle).val() || "").valueOf().toString().toMoney2() || "0"; 
		    saveObj.etcrvrs_ym  = $(".txt_ETCRVRS_YM", parentEle).val() ||""; /*기타소득귀속년월*/
		    saveObj.etcdummy1   = $(".txt_ETCDUMMY1", parentEle).val() ||""; /*소득구분*/
		    saveObj.etcdata_cd  = $(".txt_DATA_CD", parentEle).val() ||""; /*소득구분*/
		    saveObj.tax_dt      = tax_dt; /*신고기준일*/
		    saveObj.it_use_dt   = ""; 
		    saveObj.it_use_no   = ""; 
		    saveObj.it_card_no  = ""; 
		    saveObj.et_yn       = $(".txt_ET_YN", parentEle).val() || ""; /*erp data*/
		    saveObj.tr_fg       = $("#erpBudgetInfo-table>tbody>.on").find('input[name="selectTr_Fg"]').val(); // $(".txt_TR_FG", parentEle).val() || "";  /*erp data*/
		    saveObj.tr_fg_nm    = $("#erpBudgetInfo-table>tbody>.on").find('input[name="selectTr_Fg_input"]').val(); // $(".txt_TR_FG_NM", parentEle).val() || ""; /*erp data*/
		    saveObj.attr_nm     = $(".txt_ATTR_NM", parentEle).val() || ""; /*erp data*/
		    saveObj.ppl_nb      = $(".txt_PPL_NB", parentEle).val() || ""; /*erp data*/
		    saveObj.addr        = $(".txt_ADDR", parentEle).val() || ""; /*erp data*/
		    saveObj.trcharge_emp = $(".txt_TRCHARGE_EMP", parentEle).val() || ""; /*erp data*/
		    saveObj.etcrate     = $(".txt_ETCRATE", parentEle).val() || ""; /*erp data*/
		    
		    if($(".tempTAX_DT2", parentEle)){
		    	var tax_dt2 = $(".tempTAX_DT2", parentEle).val()|| "";
		    	tax_dt2 = tax_dt2.replace(/-/gi,"");
		    	if(tax_dt2 !="" &&  tax_dt2.length !=  8 ){
		    		alert(NeosUtil.getMessage("","회계발의일을 8자리로 입력하세요(예 20161111 또는 20161112)"));
		    		return;
		    	}
		    	saveObj.tax_dt2 = tax_dt2
		    }
		    
		    
		   var resultData = {};
		   
		    /*ajax 호출할 파라미터*/
		    var opt = {
		    	  url     : _g_contextPath_ + "/Ac/G20/Ex/setAbdocuT.do"
		    	, stateFn : abdocu.state
		    	, async   : false
		    	, data    : saveObj
		    	, successFn : function(data){
		    		console.log(data);
		    		tempparentEle.attr("id", data.abdocu_T.abdocu_t_no);
		    		
		    		var table = $("#erpBudgetInfo-table");
		    		var parentEle = $(".on", table);
		    		var id = $(".txt_BUDGET_LIST", parentEle).attr("id");
		    		// abdocu.BudgetInfo.rowSelect(abdocu_b_no);
		    		
		    		if(resultData.result && resultData.result > 0){
		    			$("#" + abdocu_b_no + " .totalAM", "#erpBudgetInfo-table").html("");
		    		}
		    		
		    		if(resultData.abdocu_B && resultData.abdocu_B.apply_am){
	    				$("#" + abdocu_b_no + " .totalAM", "#erpBudgetInfo-table").html(resultData.abdocu_B.apply_am.toString().toMoney());
	    				$("#" + abdocu_b_no + " .totalAM", "#erpBudgetInfo-table").attr("code" ,resultData.abdocu_B.apply_am.toString().toMoney());
		    			abdocu.showItemsBtn();
		    		}
		    	},
		    	error: function (request,status,error) {
		    		alert(NeosUtil.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요")+".\n errorCode :"+request.responseText+"\n");
		        }
		    };

		    acUtil.ajax.call(opt, resultData);
		}, 
		keydown : function(event){
			//var input = $(event.target);
			var keycode =event.keyCode;

			if(acUtil.util.validMoneyKeyCode(keycode)){
				return true;
			}else{
				return false;
			}
			event.preventDefault();
		},
		keyup : function(event){
			var input = $(event.target);
			var parentEle = $(input).parents("tr");
			
		    var money = input.val();
		   
			input.val(money.toString().toMoney());
			
//			if($(".txt_ITEM_CNT",parentEle).length){
//				return;
//			}
			
			var table = $("#erpBudgetInfo-table");
			var parentEle_temp = $("tr.on", table);
//			var modeType = $(".selectG2TR_TP", parentEle_temp).val();
//			var taxType = $(".selectG20TAX_TP", parentEle_temp).val();
			var modeType = $(".tempTr_Fg", parentEle_temp).val();
			var taxType = $(".tempVat_Fg", parentEle_temp).val();			
			//품의서 기타 소득자 일때는 작동 안함
			//var selectDocu = $("#selectDocu").val();
			var selectDocu= $("#selectDocu").attr("CODE");
			if(abdocuInfo.docu_mode == "0" && MakeTradeTable.getModeType(abdocuInfo.docu_mode, selectDocu) == "4"){
				return;
			}
			
			if(abdocuInfo.docu_mode =="0"){
//				if(taxType == "1"){
//					money = money.valueOf().toString().toMoney2();
//					var supAmt = ((Math.round(parseInt(money,10) / 1.1 * 10)) / 10);
//					supAmt = Math.round(supAmt, 1);
//					$(".txt_SUP_AM", parentEle).val(supAmt.toString().toMoney()  || 0);
//					$(".txt_VAT_AM", parentEle).val((parseInt(money,10) - supAmt).toString().toMoney() || 0 );
//						
//					return;
//				}
			}
			
			//결의서 채주유형이 기타소득 입력형태면 작동 안함
			
			if(abdocuInfo.docu_mode =="1" && modeType == "9"){
				money = money.valueOf().toString().toMoney2(); 
				var intxAM = (parseInt(money,10) * 0.03);
				if(intxAM < 1000){
					$(".txt_SUP_AM", parentEle).val(parseInt(money,10).toString().toMoney() || 0 );
					$(".txt_VAT_AM", parentEle).val("");
					$(".txt_INTX_AM", parentEle).val("");
					$(".txt_RSTX_AM", parentEle).val("");
				}else{
					// 원천 징수액 (VAT) : 총금액 * 0.033 - 원단위 절삭 intxAm
					// 실수령액 (SUP)    : 지급총액 - 원천 징수액
					// 지급 총액         : 사용자 입력 money					
					
					intxAM = parseInt(parseInt(intxAM)/10) * 10 ;
					var rstxAM = parseInt(parseInt(intxAM,10) * 0.1);
					var vatAm =intxAM + rstxAM;
					vatAm = parseInt(vatAm / 10) * 10;
					
					$(".txt_INTX_AM", parentEle).val(intxAM.toString().toMoney() || 0);
					$(".txt_RSTX_AM", parentEle).val(rstxAM.toString().toMoney() || 0);
					$(".txt_SUP_AM", parentEle).val((parseInt(money,10) - vatAm).toString().toMoney() || 0 );
					$(".txt_VAT_AM", parentEle).val(vatAm.toString().toMoney() || 0 );
				}
				return;
			}
			
			if(taxType == "1"){
				money = money.valueOf().toString().toMoney2(); 
				var supAmt = ((Math.round(parseInt(money,10) / 1.1 * 10)) / 10);
				supAmt = Math.round(supAmt, 10);
				$(".txt_SUP_AM", parentEle).val(supAmt.toString().toMoney()  || 0);
				$(".txt_VAT_AM", parentEle).val((parseInt(money,10) - supAmt).toString().toMoney() || 0 );
			}else if(taxType == "2"){
				$(".txt_SUP_AM", parentEle).val(money.toString().toMoney()  || 0);
				$(".txt_VAT_AM", parentEle).val( 0 );
			}else{
				$(".txt_SUP_AM", parentEle).val(money.toString().toMoney()  || 0);
				$(".txt_VAT_AM", parentEle).val( 0 );
			}
		}

	});

	/*수량*/
	$(".txt_ITEM_CNT", tr).bind({
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
			
			var count = input.val();
			input.val(count.toString().toMoney());
			count = count.valueOf().toString().toMoney2();
			count = parseInt(count, 10) || 0;
			
			var itemAmt = $(".txt_ITEM_AM", parentEle).val();
			itemAmt = itemAmt.valueOf().toString().toMoney2();
			itemAmt = parseInt(itemAmt, 10) || 0;
			
			var unitAmt = count * itemAmt;
			$(".txt_UNIT_AM", parentEle).val(unitAmt.toString().toMoney());

			var table = $("#erpBudgetInfo-table");
			var parentEle_temp = $("tr.on", table);
//			var taxType = $(".selectG20TAX_TP", parentEle_temp).val();
			var taxType = $(".tempVat_Fg", parentEle_temp).val();
			if(taxType == "1"){
				//money = money.valueOf().toString().toMoney2(); 
				var supAmt = ((Math.round(parseInt(unitAmt,10) / 1.1 * 10)) / 10);
				supAmt = Math.round(supAmt, 10);
				$(".txt_SUP_AM", parentEle).val(supAmt.toString().toMoney()  || 0);
				$(".txt_VAT_AM", parentEle).val((parseInt(unitAmt,10) - supAmt).toString().toMoney() || 0 );
			}else{
				$(".txt_SUP_AM", parentEle).val(unitAmt.toString().toMoney()  || 0);
				$(".txt_VAT_AM", parentEle).val('0');
			}
		}
	});
	/*부가세*/
	$(".txt_VAT_AM", tr).bind({
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
			
			var money = input.val();
			input.val(money.toString().toMoney());
			
			money = money.valueOf().toString().toMoney2() || 0; 
			var supAmt = $(".txt_SUP_AM", parentEle).val();
			supAmt = supAmt.valueOf().toString().toMoney2() || 0; 
			
//			var taxType = $(".selectG20TAX_TP", parentEle_temp).val();

			//var selectDocu = $("#selectDocu").val();
			var selectDocu= $("#selectDocu").attr("CODE");
			var table = $("#erpBudgetInfo-table");
			var parentEle_temp = $("tr.on", table);
			var modeType = $(".selectTr_Fg", parentEle_temp).val();
			var modeTypeVal = ""; 
			if(abdocuInfo.docu_mode == "0"){
				modeTypeVal = MakeTradeTable.getModeType(abdocuInfo.docu_mode, selectDocu);
			}
			
			if(abdocuInfo.docu_mode == "0" && (modeTypeVal == "1" || modeTypeVal =="4")){
				return;
			}
			
			if(abdocuInfo.docu_mode == "1" && (modeType == "4" || modeType =="8")){
				return;
			}

			$(".txt_UNIT_AM", parentEle).val((parseInt(money,10) + parseInt(supAmt,10)).toString().toMoney() || 0 );

		}
	});	
	
	/*단가, 공급가액*/
	$(".txt_SUP_AM", tr).bind({
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
			
			//var selectDocu = $("#selectDocu").val();
			var selectDocu= $("#selectDocu").attr("CODE");
			
			var table = $("#erpBudgetInfo-table");
			var parentEle_temp = $("tr.on", table);
			var modeType = $(".selectTr_Fg", parentEle_temp).val();
			
			var modeTypeVal = ""; 
			if(abdocuInfo.docu_mode == "0"){
				modeTypeVal = MakeTradeTable.getModeType(abdocuInfo.docu_mode, selectDocu);
			}else{
				modeTypeVal = MakeTradeTable.getModeType(abdocuInfo.docu_mode, modeType);
			}
			/*품의서 기타 소득자 일때는 작동 안함*/
			if(abdocuInfo.docu_mode == "0" && modeTypeVal == "4"){
				return;
			}
			
			/*결의서 기타 소득자, 사업소득자, 급여 일때는 작동 안함*/
			if(abdocuInfo.docu_mode == "1" && (modeType == "4" || modeType == "9")){
				return;
			}
			//var selectDocu = $("#selectDocu").val();
//			var selectDocu= $("#selectDocu").attr("CODE");
		    if(abdocuInfo.docu_mode == "0" && MakeTradeTable.getModeType(abdocuInfo.docu_mode, selectDocu) == "1"){
//		    	if(!$(".txt_ITEM_CNT", parentEle).length){
//		    		return;
//		    	}
//			    var supAmt = input.val();
//			    supAmt = supAmt.valueOf().toString().toMoney2();
//			    input.val(supAmt.toString().toMoney());
//			    supAmt = parseInt(supAmt, 10) || 0;
//			
//				var count = $(".txt_ITEM_CNT", parentEle).val();
//				count = count.valueOf().toString().toMoney2();
//				count = parseInt(count, 10) || 0;
//				$(".txt_UNIT_AM", parentEle).val((count * supAmt).toString().toMoney());
//				
//				return;
			}
						
			var supAmt = input.val();
			supAmt = supAmt.valueOf().toString().toMoney2();
			input.val(supAmt.toString().toMoney());
			
			var unitAm = ((  Math.round(       parseInt(supAmt,10) * 1.1 / 10   )   ) * 10);
			
			//var vatAmt = Math.round(parseInt(supAmt,10) / 10) ;
			//var vatAmt = Math.floor(parseInt(supAmt,10) / 10) ;

//			var taxType = $(".selectG20TAX_TP", parentEle_temp).val();
			var taxType = $(".tempVat_Fg", parentEle_temp).val();
			if(taxType =="2"){
				//$(".txt_VAT_AM", parentEle).val("");
				var money = $(".txt_VAT_AM", parentEle).val() || 0;
				money = money.valueOf().toString().toMoney2(); 
				//$(".txt_UNIT_AM", parentEle).val(supAmt.toString().toMoney());
				$(".txt_UNIT_AM", parentEle).val((parseInt(money,10) + parseInt(supAmt,10)).toString().toMoney() || 0 );
			}else if(taxType == "3"){
				var money = $(".txt_VAT_AM", parentEle).val() || 0;
				money = money.valueOf().toString().toMoney2(); 
				$(".txt_UNIT_AM", parentEle).val((parseInt(money,10) + parseInt(supAmt,10)).toString().toMoney() || 0 );
			}else{
				//var money = $(".txt_VAT_AM", parentEle).val() || 0;
				//money = money.valueOf().toString().toMoney2(); 
				//$(".txt_VAT_AM", parentEle).val(vatAmt.toString().toMoney()  || 0);
				//$(".txt_UNIT_AM", parentEle).val((parseInt(vatAmt,10) + parseInt(supAmt,10)).toString().toMoney() || 0 );
				$(".txt_UNIT_AM", parentEle).val(parseInt(unitAm,10).toString().toMoney() || 0 );
				$(".txt_VAT_AM", parentEle).val((parseInt(unitAm,10) - parseInt(supAmt,10)).toString().toMoney() || 0 );				
			}

		},
		focus : function(event){/*공급가액(실수령액(SUP_AM)) 포커스시 이벤트 - layer(div) 띄워줌*/
		
			//var selectDocu = $("#selectDocu").val();
			var selectDocu= $("#selectDocu").attr("CODE");
			/*품의서 기타 소득자 일때만 작동*/
			var divMode = "0";

			if((abdocuInfo.docu_mode == "0" && MakeTradeTable.getModeType(abdocuInfo.docu_mode, selectDocu) != "4")){
				return;
			}
			
			/*결의서 채주유형이 기타소득 입력형태만 작동*/
			var table = $("#erpBudgetInfo-table");
			var parentEle_temp = $("tr.on", table);
			var modeType = $(".tempTr_Fg", parentEle_temp).val();
//			var modeTypeVal = MakeTradeTable.getModeType(abdocuInfo.docu_mode, modeType);
			if(abdocuInfo.docu_mode == "1" && !(modeType == "4" || modeType == "8")){
					return;
			}	
			
			var tabIndex = $(this).attr("tabindex");
			var id = $(this).attr("id");
			var offsetEle = $(".txt_SUP_AM", parentEle); 
			var offset = offsetEle.offset();
			var top = offset.top - 150;
			var left = offset.left;
			var div = $("<div>").attr("id", acUtil.divEtcPop).attr("opener", id);
			if(abdocuInfo.docu_mode == "1"){
				if(modeType == "8"){
					divMode = "1";
				}else{
					divMode = "2";
				}	
			}

			var div_child =$(MakeTradeTable.mode.confer.getMiniPopHtml(divMode)); 
			div.css("position", "absolute").css("top", top).css("left",left).css("zIndex", "8000");
			
			div.attr("eventid", id);/*divEtcPop 띄워주는 input id 저장*/
			div.append(div_child);
			$("body").append(div);
			
			if($("#" + acUtil.divEtcPop).length){
				$("[tabindex=101]", $("#" + acUtil.divEtcPop)).focus();
//				return;
			}
			var _date = new Date();
			var year = _date.getFullYear();
			var month = _date.getMonth() + 1;
			
			$("#pop_ETCRVRS_YM_YYYY").val(acUtil.util.setNumTwo(year));
			$("#pop_ETCRVRS_YM_MM").val(acUtil.util.setNumTwo(month));
			//$("#etc_percent").val(abdocu.etc_percent * 100);
			
			var parentEle = $(this).parents("tr");
			var UNIT_AM = $(".txt_UNIT_AM", parentEle).val();
			
			UNIT_AM = UNIT_AM.valueOf().toString().toMoney2();
			UNIT_AM = parseInt(UNIT_AM, 10) || 0;

			if(divMode == 0){
				var NDEP_AM = UNIT_AM * abdocu.etc_percent;
				NDEP_AM = Math.round(NDEP_AM);
				var INAD_AM = UNIT_AM - NDEP_AM;
				var INTX_AM = Math.round(INAD_AM * abdocu.sta_rt);
				var RSTX_AM = Math.floor((INTX_AM * abdocu.jta_rt)/10) *10;
				// 상배 절삭
				$("#pop_NDEP_AM").val(NDEP_AM.toString().toMoney()).focus(); /*필요경비금액*/
				$("#pop_INAD_AM").val(INAD_AM.toString().toMoney()); 

            	if(INAD_AM > abdocu.mtax_am){
    				$("#pop_INTX_AM").val(INTX_AM.toString().toMoney());  /*소득세액*/
    				$("#pop_RSTX_AM").val(RSTX_AM.toString().toMoney());  /*주민세액*/
            	}
            	
			}else if(divMode == 1){
				$("#pop_UNIT_AM").val(UNIT_AM.toString().toMoney());
				if(parentEle.attr("id") > 0){
					$("#pop_INTX_AM").val($(".txt_INTX_AM", parentEle).val().toString().toMoney());
					$("#pop_RSTX_AM").val($(".txt_RSTX_AM", parentEle).val().toString().toMoney());
					$("#pop_WD_AM").val($(".txt_WD_AM", parentEle).val().toString().toMoney());
					$("#pop_ETCRVRS_YM_YYYY").val($(".txt_ETCRVRS_YM", parentEle).val().substr(0,4));
					$("#pop_ETCRVRS_YM_MM").val($(".txt_ETCRVRS_YM", parentEle).val().substr(4,2));
				}
				$("#pop_INTX_AM").focus();
			}else{
				abdocu.TradeInfo.getETCDUMMY1(parentEle);
			}

			/*결의서 기타소득자*/

			if(abdocuInfo.docu_mode == "1" && modeType == "4"){
				$("#pop_CTD_CD, #pop_CTD_NM").bind({
					dblclick :function(event){
			            var dblClickparamMap =
			                [{
			    				"id" : "pop_CTD_CD",
			                    "text" : "CTD_CD",
			                    "code" : ""
			    			},
			    			{
			    				"id" : "pop_CTD_NM",
			    				"text" : "CTD_NM",
			    				"code" : ""
			    			}];
			            acUtil.util.dialog.dialogDelegate(getErpEtcIncomeList, dblClickparamMap);						
					},
					keyup : function(event){
						var eventEle = $(event.target);
						if(event.keyCode == 113){
							eventEle.dblclick();
						}
						if(event.keyCode == 13){
     						if(eventEle.val() == "") {
          						eventEle.dblclick();
							}else{
							    //직접입력 추가
							    abdocu.TradeInfo.getETCDUMMY1Info();
							}

							var tabIndex = eventEle.attr("tabIndex");
							$("[tabindex="+(parseInt(tabIndex) + 1)+"]", $("#" + acUtil.divEtcPop)).focus();
						}
					}
				});
				
				
				$("#search-Event-T-etc").bind({
					click : function(event){
						$("#pop_CTD_CD").dblclick();
					}
				});
				
				$("#etc_percent").bind({
					focusout : function(event){
						var CTD_CD = $("#pop_CTD_CD").val();
						var percent = $(this).val();
						percent = percent.valueOf().toString().toMoney2();
						percent = parseInt(percent, 10) || 0;
						
						var popID = $("#" + acUtil.divEtcPop).attr("opener");
						var input = $("#" + popID);
						var parentEle = input.parents("tr");
						
						var _UNIT_AM = $(".txt_UNIT_AM", parentEle).val();
						_UNIT_AM = _UNIT_AM.valueOf().toString().toMoney2();
						_UNIT_AM = parseInt(_UNIT_AM, 10) || 0;
						
						
						var _NDEP_AM = percent / 100 *  _UNIT_AM;
						_NDEP_AM = Math.floor(_NDEP_AM);
						
						var _INAD_AM = _UNIT_AM - _NDEP_AM;
												
						// 상배 절삭
						$("#pop_NDEP_AM").val(_NDEP_AM.toString().toMoney()); /*필요경비금액*/
						$("#pop_INAD_AM").val(_INAD_AM.toString().toMoney()); /*소득금액*/
						
					}
				});
				
				$("#pop_NDEP_AM").bind({
					focusout : function(event){
						var CTD_CD = $("#pop_CTD_CD").val();
						//var input = $(event.target);
						var _NDEP_AM = $(event.target).val();
						_NDEP_AM = _NDEP_AM.valueOf().toString().toMoney2();
						
						var popID = $("#" + acUtil.divEtcPop).attr("opener");
						var input = $("#" + popID);
						var parentEle = input.parents("tr");
						
						var _UNIT_AM = $(".txt_UNIT_AM", parentEle).val();
						_UNIT_AM = _UNIT_AM.valueOf().toString().toMoney2();
						_UNIT_AM = parseInt(_UNIT_AM, 10) || 0;

						var _INAD_AM = _UNIT_AM - _NDEP_AM;
						
						$("#pop_INAD_AM").val(_INAD_AM.toString().toMoney()); /*소득금액*/

						var _INTX_AM = "";
						var _RSTX_AM = "";
						
						if(_INAD_AM > abdocu.mtax_am){
							if(!(CTD_CD == "68" || CTD_CD == "61")){
								if(CTD_CD == "40" || CTD_CD == "41"){
									_INTX_AM = Math.round(_INAD_AM * abdocu.sta_rt * 0.1);
									_RSTX_AM = Math.floor((_INTX_AM * abdocu.jta_rt)/10) *10;
								}else{
									//_INTX_AM = Math.round(_INAD_AM * abdocu.sta_rt);
									_INTX_AM = Math.floor((_INAD_AM * abdocu.sta_rt)/10) *10;
									_RSTX_AM = Math.floor((_INTX_AM * abdocu.jta_rt)/10) *10;
								}
							}
						}

						$("#pop_INTX_AM").val(_INTX_AM.toString().toMoney());
						$("#pop_RSTX_AM").val(_RSTX_AM.toString().toMoney());
						
					}
				});
				
				$("#pop_INTX_AM").bind({
					focusout : function(event){
						var CTD_CD = $("#pop_CTD_CD").val();
						var _INTX_AM = $(event.target).val();
						_INTX_AM = _INTX_AM.valueOf().toString().toMoney2();

						var _INAD_AM = $("#pop_INAD_AM").val();
						_INAD_AM =  _INAD_AM.valueOf().toString().toMoney2();
						if(_INAD_AM > abdocu.mtax_am){
							if(!(CTD_CD == "68" || CTD_CD == "61")){
									var _RSTX_AM = Math.floor((_INTX_AM * abdocu.jta_rt)/10) *10; 
									$("#pop_RSTX_AM").val(_RSTX_AM.toString().toMoney());
							}
						}
					}
				});

			}
			
			$(".etc_pop", div).bind({
				keyup : function(event){
					var tabIndex = $(this).attr("tabIndex");
					
					var parentEle = $("#" + acUtil.divEtcPop);
					
					if(event.keyCode == 13){
						var focusEle = $("[tabindex="+(parseInt(tabIndex) + 1) +"]", parentEle);
						if(focusEle.length){
							focusEle.focus();
						}
						else{
							acUtil.focusNextRow($(this));
						}
					}
					else{
						var _tVal = $(this).val();
						var id = $(this).attr("id");
						if(id != "pop_ETCRVRS_YM_YYYY" && id != "pop_ETCRVRS_YM_MM"){
							$(this).val(_tVal.toString().toMoney());
						}
					}
				},
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
			$("#btnPopCancel").click(function(){
				$("#" + acUtil.divEtcPop).remove();
			});			
		}
	});

	/*단가, 공급가액*/
	$(".txt_ITEM_AM", tr).bind({
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
			
			var table = $("#erpBudgetInfo-table");
			var parentEle_temp = $("tr.on", table);
			
			var itemAmt = input.val();
			itemAmt = itemAmt.valueOf().toString().toMoney2();
			input.val(itemAmt.toString().toMoney());
			itemAmt = parseInt(itemAmt, 10) || 0;
			
			var count = $(".txt_ITEM_CNT", parentEle).val();
			count = count.valueOf().toString().toMoney2();
			count = parseInt(count, 10) || 0;
			
			var unitAmt = count * itemAmt;
			$(".txt_UNIT_AM", parentEle).val((unitAmt).toString().toMoney());
			
//			var taxType = $(".selectG20TAX_TP", parentEle_temp).val();
			var taxType = $(".tempVat_Fg", parentEle_temp).val();
			if(taxType == "1"){
				//money = money.valueOf().toString().toMoney2(); 
				var supAmt = ((Math.round(parseInt(unitAmt,10) / 1.1 * 10)) / 10);
				supAmt = Math.round(supAmt, 10);
				$(".txt_SUP_AM", parentEle).val(supAmt.toString().toMoney()  || 0);
				$(".txt_VAT_AM", parentEle).val((parseInt(unitAmt,10) - supAmt).toString().toMoney() || 0 );
			}else{
				$(".txt_SUP_AM", parentEle).val(unitAmt.toString().toMoney()  || 0);
				$(".txt_VAT_AM", parentEle).val('0');
			}
			
		}
	});	
	(function(tr_){
		$(".txt_TR_NM", tr_).bind({
			focus : function(event){
				var selectBudgetTr = $("#erpBudgetInfo-table .on");
//				var selectG20TAX_TP = $(".selectG20TAX_TP", selectBudgetTr).val();
				var selectVat_Fg = $(".tempVat_Fg", selectBudgetTr).val();
				var selectTr_Fg = $('.selectTr_Fg', selectBudgetTr).val();
				if(selectVat_Fg ==3){ /*과세구분이 기타이면 거래처목록에서 선택 안해도됨*/
				    if(!$(event.target).attr("CODE")){
				    	$(event.target).attr("CODE", "empty");
				    }
				}
				
				// 품의서이면서 과세가 아닌 경우.
				/* 거래처명 / 기타 소득자 / 사업소득자 */
				// docu_mode = 0
				// vatFg != 1
				$(".txt_TR_NM", tr_).unbind('keydown');
				if( (( abdocuInfo.docu_mode == '1' ) || ( selectVat_Fg == '1' ))
						&& (selectTr_Fg_value != '3')
						&& (selectTr_Fg_value != '4') 
						&& (selectTr_Fg_value != '9') ){
					$(".txt_TR_NM", tr_).keydown(function(e) {			   
						   e.preventDefault();
						   return false;
					});
				}
			}
		});
	})(tr);
	
	/* 상배 */
	/* 품의서 - 면세/기타, 결의서 - 거래처명 인 경우 거래처 수기 입력 가능. */
	/* 거래처명 / 기타 소득자 / 사업 소득자*/
	var selectBudgetTr = $("#erpBudgetInfo-table .on");
	if( ( ( abdocuInfo.docu_mode == '1' ) 
			|| ( $(".tempVat_Fg", selectBudgetTr).val() == '1' ) ) 
			&& (selectTr_Fg_value != '3')
			&& (selectTr_Fg_value != '4')
			&& (selectTr_Fg_value != '9')
	){
		$(".txt_TR_NM").keydown(function(e) {			   
			   e.preventDefault();
			   return false;
		});
	}
	
	/*거래처영역 이미지 검색 클릭 이벤트*/
	$(".search-Event-T", tr).bind({
		click : function(event){

			var parentEle = $(this).parent();
			var eventEle = $(".non-requirement, .requirement", parentEle).first();

			eventEle.dblclick();

		}
	});
	
	tr.bind({
		click : function(event){
			
			var table = $("#erpTradeInfo-table");
	    	$(".on" , table).removeClass("on");
			$(this).addClass("on");
			
			var ctr_cd = $(".txt_CTR_CD", tr).val();
			var ctr_nm = $(".txt_CTR_NM", tr).val();
			var ctr_card_num = $(".txt_CTR_CARD_NUM", tr).val();
			var html = "";
			if(ctr_nm){
				html = "[" + ctr_cd + "]" + ctr_nm + " ("+ctr_card_num+")";
			};
			$("#tradeCardNm").html(html);
		}
	}).css("cursor","pointer");	
	
	/* 부가세신고일, 신고기준일 달력지정 */
	taxDt_Id = $(".txt_TAX_DT" , tr).attr("id");
	var tempTAX_DT = $(".tempTAX_DT" , tr).attr("id");
	abdocu.setDatepicker(taxDt_Id, tempTAX_DT);
	
	if($(".txt_TAX_DT2" , tr)){
		taxDt_Id2 = $(".txt_TAX_DT2" , tr).attr("id");
		var tempTAX_DT2 = $(".tempTAX_DT2" , tr).attr("id");
		abdocu.setDatepicker(taxDt_Id2, tempTAX_DT2);
	}
	
	/* 저장 버튼 클릭시*/
	abdocu.saveImageClick(tr);
	
	$(":radio[name=B_use_YN2]").bind({
		click : function(event){
			$(".txt_TR_NM", tr).dblclick();
		}
	});
	
	$("#user_Search2").bind({
		click : function(event){
			$(".txt_TR_NM", tr).dblclick();
	  	}
	});

	return tr;	

};


abdocu.TradeInfo.getETCPopSet = function(parentEle){

	$("#etc_percent").attr("disabled", "disabled").removeClass("input_blue"); ;

	var CTD_CD = $("#pop_CTD_CD").val();
	if(CTD_CD > "70"){
		$("#etc_percent").val(abdocu.etc_percent * 100);
	}else if(CTD_CD == "62"){
		if($(".txt_DATA_CD", parentEle).val() == "G" || (!$('#etc_percent').val()) ){
			$("#etc_percent").removeAttr("disabled").removeClass("input_gray");
			$("#etc_percent").val( ( $(".txt_ETCRATE", parentEle).val() || '80' ) );
		}
	}else{
		$("#etc_percent").val("");
	}
	//$("#etc_percent").val(abdocu.etc_percent * 100);
	
	//var parentEle = $(this).parents("tr");
	var percent = $("#etc_percent").val();
	percent = percent.valueOf().toString().toMoney2();
	percent = parseInt(percent, 10) || 0;
	
	var popID = $("#" + acUtil.divEtcPop).attr("opener");
	var input = $("#" + popID);
	var parentEle = input.parents("tr");
	
	var UNIT_AM = $(".txt_UNIT_AM", parentEle).val();
	
	UNIT_AM = UNIT_AM.valueOf().toString().toMoney2();
	UNIT_AM = parseInt(UNIT_AM, 10) || 0;
	//NDEP_AM = UNIT_AM * abdocu.etc_percent;
	var NDEP_AM = "";
	if(percent > 0){
		NDEP_AM = percent / 100 * UNIT_AM;
		NDEP_AM = Math.floor(NDEP_AM);
	}

	var INAD_AM = UNIT_AM - NDEP_AM;
	
	// 상배 절삭
	$("#pop_NDEP_AM").val(NDEP_AM.toString().toMoney()); /*필요경비금액*/
	$("#pop_INAD_AM").val(INAD_AM.toString().toMoney()); /*필요경비금액*/
	
	
	var INTX_AM = "";
	var RSTX_AM = "";
	
	if(INAD_AM > abdocu.mtax_am){
		if(!(CTD_CD == "68" || CTD_CD == "61" || CTD_CD == "")){
			if(CTD_CD == "40" || CTD_CD == "41"){
				INTX_AM = Math.round(INAD_AM * abdocu.sta_rt * 0.1);
				RSTX_AM = Math.floor((INTX_AM * abdocu.jta_rt)/10)*10;
			}else{
				INTX_AM = Math.floor((INAD_AM * abdocu.sta_rt)/10)*10;
				RSTX_AM = Math.floor((INTX_AM * abdocu.jta_rt)/10)*10;
			}
		}
	}

	$("#pop_INTX_AM").val(INTX_AM.toString().toMoney()); /*필요경비금액*/
	$("#pop_RSTX_AM").val(RSTX_AM.toString().toMoney()); /*필요경비금액*/
	
};

abdocu.saveImageClick = function(tr){
	/*  */
	$(".erpsave", tr).css("cursor", "pointer").click(function(){
		
		//var eventtr = $(this).parents("tr"); 
		var eventEle = $("input[part]", tr);
		if(typeof(acUtil.focusNextRow) == 'undefined'){
			acUtil.focusNextRow = abdocu.focusNextRow;
		}
		acUtil.focusNextRow(eventEle);
	});
};
abdocu.DateValidate = function(dateStr){
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

abdocu.TradeInfo.popOK = function(){
	var popID = $("#" + acUtil.divEtcPop).attr("opener");
	var input = $("#" + popID);
	var parentEle = input.parents("tr");
	
	var _UNIT_AM = $(".txt_UNIT_AM", parentEle).val();
	_UNIT_AM = _UNIT_AM.valueOf().toString().toMoney2();
	var _NDEP_AM = $("#pop_NDEP_AM").val();
	_NDEP_AM = _NDEP_AM.valueOf().toString().toMoney2();
	var _INAD_AM = $("#pop_INAD_AM").val();
	_INAD_AM = _INAD_AM.valueOf().toString().toMoney2();
	var _INTX_AM = $("#pop_INTX_AM").val();
	_INTX_AM = _INTX_AM.valueOf().toString().toMoney2();
	var _RSTX_AM = $("#pop_RSTX_AM").val();
	_RSTX_AM = _RSTX_AM.valueOf().toString().toMoney2();
	
	var _ETCRVRS_YM = $("#pop_ETCRVRS_YM_YYYY").val() + $("#pop_ETCRVRS_YM_MM").val();
	var _ETCDUMMY1 = $("#pop_CTD_CD").val();
	
	$(".txt_NDEP_AM", parentEle).val(_NDEP_AM.toString().toMoney());
	$(".txt_INAD_AM", parentEle).val(_INAD_AM.toString().toMoney());
	$(".txt_INTX_AM", parentEle).val(_INTX_AM.toString().toMoney());
	$(".txt_RSTX_AM", parentEle).val(_RSTX_AM.toString().toMoney());
	
	$(".txt_ETCRVRS_YM", parentEle).val(_ETCRVRS_YM);
	$(".txt_ETCDUMMY1", parentEle).val(_ETCDUMMY1);
	
	var _VAT_AM = (parseInt(_INTX_AM, 10) || 0) + (parseInt(_RSTX_AM, 10) || 0);
	$(".txt_VAT_AM", parentEle).val(_VAT_AM.toString().toMoney());
	
	var _SUP_AM = (parseInt(_UNIT_AM, 10 ) || 0) -  (parseInt(_VAT_AM, 10) || 0) ;
	$(".txt_SUP_AM", parentEle).val(_SUP_AM.toString().toMoney());
	
	var _ETCRATE = $("#etc_percent").val();
	$(".txt_ETCRATE", parentEle).val(_ETCRATE);
	
	var eventid = $("#" + acUtil.divEtcPop).attr("eventid");

	$("#" + acUtil.divEtcPop).remove();
	
	var eventEle = $("#" + eventid);
	var parentEle = eventEle.parents("tr");
	var tabIndex = eventEle.attr("tabIndex");
	var focusEle = $("[tabindex="+(tabIndex + 1) +"]", parentEle);
	focusEle.focus();		
};


abdocu.TradeInfo.payPopSet = function(){
	var popID = $("#" + acUtil.divEtcPop).attr("opener");
	var input = $("#" + popID);
	var parentEle = input.parents("tr");
	
	var _UNIT_AM = $(".txt_UNIT_AM", parentEle).val();
	_UNIT_AM = _UNIT_AM.valueOf().toString().toMoney2();
	var _INTX_AM = $("#pop_INTX_AM").val();
	_INTX_AM = _INTX_AM.valueOf().toString().toMoney2();
	var _RSTX_AM = $("#pop_RSTX_AM").val();
	_RSTX_AM = _RSTX_AM.valueOf().toString().toMoney2();
	var _WD_AM = $("#pop_WD_AM").val();
	_WD_AM = _WD_AM.valueOf().toString().toMoney2();
	
	var _ETCRVRS_YM = $("#pop_ETCRVRS_YM_YYYY").val() + $("#pop_ETCRVRS_YM_MM").val();
	var _ETCDUMMY1 = "";
	
	$(".txt_INTX_AM", parentEle).val(_INTX_AM.toString().toMoney());
	$(".txt_RSTX_AM", parentEle).val(_RSTX_AM.toString().toMoney());
	$(".txt_WD_AM", parentEle).val(_WD_AM.toString().toMoney());
	
	$(".txt_ETCRVRS_YM", parentEle).val(_ETCRVRS_YM);
	$(".txt_ETCDUMMY1", parentEle).val(_ETCDUMMY1);
	
	var _VAT_AM = (parseInt(_INTX_AM, 10) || 0) + (parseInt(_RSTX_AM, 10) || 0) + (parseInt(_WD_AM, 10) || 0);
	$(".txt_VAT_AM", parentEle).val(_VAT_AM.toString().toMoney());
	
	var _SUP_AM = (parseInt(_UNIT_AM, 10 ) || 0) - _VAT_AM;
	$(".txt_SUP_AM", parentEle).val(_SUP_AM.toString().toMoney());
	
	var eventid = $("#" + acUtil.divEtcPop).attr("eventid");
	
	$("#" + acUtil.divEtcPop).remove();
	
	var eventEle = $("#" + eventid);
	var parentEle = eventEle.parents("tr");
	var tabIndex = eventEle.attr("tabIndex");
	var focusEle = $("[tabindex="+(tabIndex + 1) +"]", parentEle);
	focusEle.focus();		
};
abdocu.TradeInfo.remove = function(){
	var sample = $("#erpTradeInfo-tablesample-empty");

	var table = $("#erpTradeInfo-table");
	$("tr", table).remove();
	for(var i = 0; i< 4 ; i++){
		var tr = $("tr", sample).clone(false);
		table.append(tr);
	}
};



abdocu.TradeInfo.deleteRow = function(id){
	var table = $("#erpBudgetInfo-table");
	var parentEle = $(".on", table);
	var abdocu_b_no = parentEle.attr("id");
	var resultData = {};
	var data = {
		  abdocu_t_no : id
		, abdocu_b_no : abdocu_b_no
	};
    var opt = {
            url : _g_contextPath_ + "/Ac/G20/Ex/delAbdocuT.do",
            stateFn:abdocu.state,
            async:false,
            data : data,
            successFn : function(){
                if(resultData.result){
                	//abdocu.BudgetInfo.init(true);
                    if(resultData.result && resultData.result > 0){
                    	$("#" + abdocu_b_no + " .totalAM", "#erpBudgetInfo-table").html("");
                    }

                    if(resultData.abdocu_B && resultData.abdocu_B.apply_am){
                    	$("#" + abdocu_b_no + " .totalAM", "#erpBudgetInfo-table").html(resultData.abdocu_B.apply_am.toString().toMoney());
                    	$("#" + abdocu_b_no + " .totalAM", "#erpBudgetInfo-table").attr("code" ,resultData.abdocu_B.apply_am.toString().toMoney());
                    	abdocu.showItemsBtn();
                    }
                	abdocu.BudgetInfo.rowSelect(abdocu_b_no);
                }
            }
    };

    acUtil.ajax.call(opt, resultData);


};

abdocu.TradeInfo.focusNextRow = function(eventEle){
	var table = $("#erpTradeInfo-table");	
	if(!acUtil.util.validationCheck(table, eventEle)){
		return false;
	}
	
	var resultData = {};
	abdocu.TradeInfo.RowSave(eventEle, resultData);
	if(resultData.result > 0){
		//abdocu.TradeInfo.addRow(); 
	}
};
/* + 이미지 추가 */
abdocu.TradeInfo.addRowImg = function(){
	
};
abdocu.TradeInfo.eventHandlerMapping = function(context, index){
	var table = $("#erpTradeInfo-table");
	if(!context){
		context = table;
	}
    /*거래처명*/
    $(".txt_TR_NM", context).bind({
        dblclick : function(){
            var id = $(this).attr("id");
            var dblClickparamMap =
            	(function(ID, idx){
            		var returnObj =
	                    [{
	    					"id" : ID,
	                        "text" : "TR_NM",
	                        "code" : "TR_CD"
	    				},
	                     {
	     					"id" : "txt_CEO_NM" + idx,
	                         "text" : "CEO_NM",
	                         "code" : ""
	     				},
	                     {
	     					"id" : "txt_BTR_NM" + idx,
	                         "text" : "JIRO_NM",
	                         "code" : "JIRO_CD"
	     				},
	                     {
	     					"id" : "txt_JIRO_NM" + idx,
	                         "text" : "JIRO_NM",
	                         "code" : "JIRO_CD"
	     				},
	                     {
	     					"id" : "txt_DEPOSITOR" + idx,
	                         "text" : "DEPOSITOR",
	                         "code" : ""
	     				},
	                     {
	     					"id" : "txt_BA_NB" + idx,
	                         "text" : "BA_NB",
	                         "code" : ""
	     				},
	                     {
	     					"id" : "txt_TEL" + idx,
	                         "text" : "TEL",
	                         "code" : ""
	     				},
	                     {
	     					"id" : "txt_REG_NB" + idx,
	                         "text" : "REG_NB",
	                         "code" : ""
	     				},
	                     {
	     					"id" : "txt_TR_FG" + idx,
	                         "text" : "TR_FG",
	                         "code" : ""
	     				},
	                     {
	     					"id" : "txt_TR_FG_NM" + idx,
	                         "text" : "TR_FG_NM",
	                         "code" : ""
	     				},

	                     {
	     					"id" : "txt_ATTR_NM" + idx,
	                         "text" : "ATTR_NM",
	                         "code" : ""
	     				},
	                     {
	     					"id" : "txt_PPL_NB" + idx,
	                         "text" : "PPL_NB",
	                         "code" : ""
	     				},
	                     {
	     					"id" : "txt_ADDR" + idx,
	                         "text" : "ADDR",
	                         "code" : ""
	     				},
	                     {
	     					"id" : "txt_TRCHARGE_EMP" + idx,
	                         "text" : "TRCHARGE_EMP",
	                         "code" : ""
	     				},
	                     {
	     					"id" : "txt_JIRO_CD" + idx,
	                         "text" : "JIRO_CD",
	                         "code" : ""
	     				},
	                     {
	     					"id" : "txt_JIRO_NM" + idx,
	                         "text" : "JIRO_NM",
	                         "code" : ""
	     				},
	                     {
	     					"id" : "txt_DATA_CD" + idx,
	                         "text" : "DATA_CD",
	                         "code" : ""
	     				},
	                     {
	     					"id" : "txt_DEPOSITOR_H" + idx,
	                         "text" : "DEPOSITOR",
	                         "code" : ""
	     				},
	                     {
	     					"id" : "txt_BTR_NM_H" + idx,
	                         "text" : "JIRO_NM",
	                         "code" : ""
	     				},
	                     {
	     					"id" : "txt_BTR_CD_H" + idx,
	                         "text" : "JIRO_CD",
	                         "code" : ""
	     				},
	                     {
	     					"id" : "txt_BA_NB_H" + idx,
	                         "text" : "BA_NB",
	                         "code" : ""
	     				}];
            		
					return returnObj;

            	})(id, index);
            
            (function(idx){
            	if(abdocuInfo.docu_mode=="0"){ /*품의서*/
            		var selectDocu = $("#selectDocu").val();
//                	var ModeType =  MakeTradeTable.getModeType(abdocu.docu_mode, selectDocu);
                	if(selectDocu == "5"){ /*내부직원용*/
                		acUtil.util.dialog.dialogDelegate(getErpEmpList, dblClickparamMap, idx);
                	}else if(selectDocu == "6"){ /*기타소득자*/
                		acUtil.util.dialog.dialogDelegate(getErpHpmeticList, dblClickparamMap, idx);
                	}else{
                		acUtil.util.dialog.dialogDelegate(acG20Code.getErpTradeList, dblClickparamMap);
                	}
                	
                }
                else{/*결의서*/
        			var table = $("#erpBudgetInfo-table");
        			var parentEle_temp = $("tr.on", table);
        			var modeType = $(".tempTr_Fg", parentEle_temp).val();
                	if(modeType == "2" || modeType == "8"){ /*사원, 급여*/
                		acUtil.util.dialog.dialogDelegate(getErpEmpList, dblClickparamMap, idx);
                	}else if(modeType == "4"){/*기타소득자*/
                		acUtil.util.dialog.dialogDelegate(getErpHpmeticList, dblClickparamMap, idx);
                	}
//                	else if(modeType == "5" || modeType == "7"){   /*기급, 결연자*/
//                		acUtil.util.dialog.dialogDelegate(abdocu.TradeInfo.TR_NM_dialogInit_ETC, dblClickparamMap, idx);
//                	}
                	else if(modeType == "9"){/*사업소득자*/
                		acUtil.util.dialog.dialogDelegate(getErpHincomeList, dblClickparamMap, idx);
                	}else{
                		acUtil.util.dialog.dialogDelegate(acG20Code.getErpTradeList, dblClickparamMap);
                	}
                }            	
            })(index);

        }
    

    });

    /*금융기관*/
    $(".txt_BTR_NM", context).bind({
        dblclick : function(){
            var id = $(this).attr("id");
            var dblClickparamMap =
            	(function(ID, idx){
            		var returnObj =
	                    [{
	     					"id" : ID,
	                         "text" : "BANK_NM",
	                         "code" : "BANK_CD"
	     				}];
					return returnObj;
            	})(id, index);
            acUtil.util.dialog.dialogDelegate(getErpBankList, dblClickparamMap);
        }
    });
    
    $("#tradeCardBtn").bind({
        click : function(){
			var table = $("#erpTradeInfo-table");
	    	var tr = $(".on", table);
	    	
            var txt_CTR_NM = $(".txt_CTR_NM" ,tr).attr("id");
            var txt_CTR_CD = $(".txt_CTR_CD" ,tr).attr("id");
            var txt_CTR_CARD_NUM = $(".txt_CTR_CARD_NUM" ,tr).attr("id");
            var id = $(this).attr("id");
            var dblClickparamMap =
            	(function(ID, idx){
            		var returnObj =
	                    [{
	     					"id" : txt_CTR_NM,
	                         "text" : "TR_NM",
	                         "code" : ""
	     				},
	     				{
	     					"id" : txt_CTR_CD,
	                         "text" : "TR_CD",
	                         "code" : ""
	     				},
	     				{
	     					"id" : txt_CTR_CARD_NUM,
	                         "text" : "BA_NB",
	                         "code" : ""
	     				}];
					return returnObj;
            	})(id, index);
            acUtil.util.dialog.dialogDelegate(acG20Code.getErpCardTradeList, dblClickparamMap);
        }
    });
};



abdocu.TradeInfo.focusNextRow_etcpop = function(eventEle){
	abdocu.TradeInfo.popOK();
};

abdocu.TradeInfo.focusNextRow_paypop = function(eventEle){
	abdocu.TradeInfo.payPopSet();
};

abdocu.approvalValidation = function(){
	var isSuccess = true;
	$("." + acUtil.invalidClass).removeClass(acUtil.invalidClass);
	var msg = NeosUtil.getMessage("TX000011209","입력되지 않은 값이 있습니다. 확인해주세요.");
	var table = $("#erpUserInfo");
	var table1 = $("#erpProjectInfo-table");
	var table2 = $("#erpBudgetInfo-table");
	var table3 = $("#erpTradeInfo-table");
	
	var obj = {
			isSuccess : isSuccess,
			msg : msg
	};
	$(".requirement", table).each(function(){
		if(!$(this).val() || !$(this).attr("CODE")){
			$(this).addClass(acUtil.invalidClass);
			obj.msg = NeosUtil.getMessage("TX000011209","입력되지 않은 값이 있습니다. 확인해주세요.");
			obj.isSuccess = false;
		}
	});

	if(!obj.isSuccess){
		return obj;
	}

	$(".requirement", table1).each(function(){
		if(!$(this).val() || !$(this).attr("CODE")){
			$(this).addClass(acUtil.invalidClass);
			obj.msg = NeosUtil.getMessage("TX000011209","입력되지 않은 값이 있습니다. 확인해주세요.");
			obj.isSuccess = false;
		}
	});

	
	/* 원인행위부 노출인 경우  */
	if($('#causeForm:visible').length){
		$('#causeForm').find('input').filter('.requirement').each(function(){
			if(!$(this).val()){
				$(this).addClass(acUtil.invalidClass);
				obj.msg = NeosUtil.getMessage("TX000011209","입력되지 않은 값이 있습니다. 확인해주세요.");
				obj.isSuccess = false;
			}
		});
	}
	
	
	if(!obj.isSuccess){
		return obj;
	}
	
	if(abdocu.docu_mode =="1"){
		
		if(erpOption.CauseUseYn =="1" && abdocu.cause_require =="Y"){
			var causeDiv = $("#causeForm");
			
			$(".requirement", causeDiv).each(function(){
				if(!$(this).val() || !$(this).attr("CODE")){
					$(this).addClass(acUtil.invalidClass);
					obj.msg = NeosUtil.getMessage("TX000011209","입력되지 않은 값이 있습니다. 확인해주세요.");
					obj.isSuccess = false;
				}
			});

			if(!obj.isSuccess){
				return obj;
			}
		}
	}	
	
	var len = [];
	$.map($("tr", table2), function(val, i){
		var id = $(val).attr("id");
		if(id){
			len[len.length] = id;
		}
	});
	if(!len.length){
		obj.msg = NeosUtil.getMessage("TX000009421","예산 정보를 입력해주세요");
		obj.isSuccess = false;
	}
	if(!obj.isSuccess){
		return obj;
	}

	$("tr", table2).each(function(){
		var tr = $(this);
		if(tr.attr("id")){
			$(".requirement", tr).each(function(){
				if(!$(this).val() || !$(this).attr("CODE")){
					$(this).addClass(acUtil.invalidClass);
					obj.msg = NeosUtil.getMessage("TX000011209","입력되지 않은 값이 있습니다. 확인해주세요.");
					obj.isSuccess = false;
				}
			});
			
			$(".totalAM", tr).each(function(){
				if(!$(this).attr("CODE")){
					$(this).addClass(acUtil.invalidClass);
					obj.msg = NeosUtil.getMessage("TX000009420","금액이 없는 예산이 있습니다. 확인해주세요");
					obj.isSuccess = false;
					abdocu.BudgetInfo.rowSelect(tr.attr("id"));
				}
			});
		}
	});  
	
	if(!obj.isSuccess){
		return obj;
	}
	
	var len = [];
	$.map($("tr", table3), function(val, i){
		var id = $(val).attr("id");
		if(id){
			len[len.length] = id;
		}
	});
	if(!len.length){
		obj.msg = NeosUtil.getMessage("TX000009419","거래처 정보를 입력해주세요");
		obj.isSuccess = false;
	}
	if(!obj.isSuccess){
		return obj;
	}
	/* 상배 금액 체크 */
	$("tr", table3).each(function(){
		var tr = $(this);
		if(tr.attr("id")){
			$(".requirement", tr).each(function(){
				if(!$(this).val() || !$(this).attr("CODE")){
					$(this).addClass(acUtil.invalidClass);
					obj.msg = NeosUtil.getMessage("TX000011209","입력되지 않은 값이 있습니다. 확인해주세요.");
					obj.isSuccess = false;
				}
			});
		}
	});
	
	if(!obj.isSuccess){
		return obj;
	}
	if(gwOption.ItemsUseYn =="Y")	{
		var ItemsTotalAm =  $("#ItemsTotalAm").attr("code");
		var budgetTotalAm =  $("#budgetTotalAm").attr("code");
		
		if(ItemsTotalAm != "" && budgetTotalAm != ItemsTotalAm){
			obj.msg = NeosUtil.getMessage("TX000009418","결의금액과 명세서금액이 다릅니다");
			obj.isSuccess = false;
		}
	}
	
	return obj;
};

abdocu.approvalOpen = function(){

	var obj = abdocu.approvalValidation();
	if(!obj.isSuccess){
		alert(obj.msg);  
		return false; 
	}
	
	var table = $("#erpBudgetInfo-table");
	var tr = $("tr", table);
	var ids = []; /*예산 목록*/
	$.map(tr, function(val, i){
		var id = $(val).attr("id");
		if(id && id != "0"){
			ids[ids.length] = id;
		}
	});

	var overBudget = [];
	var validationResult =  '';
	for ( var i = 0, max = ids.length; i < max; i++) {
		var tempTr = $("#" + ids[i], table);
		var txt_BUDGET_LIST = $(".txt_BUDGET_LIST", tempTr).attr("CODE");
		var reffer_b_no = $("#"+ids[i]).attr("reffer_b_no");
		var data = {
			  abdocu_no : abdocuInfo.abdocu_no
			, abdocu_b_no : ids[i]
			, abdocu_no_reffer : abdocuInfo.abdocu_no_reffer
			, docu_mode :abdocuInfo.docu_mode 
			, abgt_cd : txt_BUDGET_LIST
			, abdocu_b_no_reffer : reffer_b_no
			, erp_co_cd :  abdocuInfo.erp_co_cd
		};

		/*ajax 호출할 파라미터*/
		var opt = {
	            url : _g_contextPath_ + "/Ac/G20/Ex/approvalValidation.do",
	            stateFn:abdocu.state,
	            async:false,
	            data : data,
	            successFn : function(data){
	            	var result = parseInt(data.result, 10);
	            	
	            	/* 상배 예산 통제 세부 옵션 확인 */
	            	if(data.ctlFg < 5){
	            		return;
	            	}
	            	if(isNaN(result)){
	            		result = -1;
	            	}
	            	
	            	/* 참조 품의액 검증 */
	            	if(isNaN(result)){
	            		validationResult = 'NaN';
	            	}else if( (result < 0 ) && ( data.ctlFg == 10  )){
	            		validationResult = 'CONFER';
	            	}else if((result < 0 ) && ( data.ctlFg != 10  ) /*&& 예산옵션트루*/ ){
            			validationResult = 'BGT';
	            	}
	            	
	            	/* 수입품의서 제외 */
	            	if(abdocuInfo.docu_mode =="0" && overBudget.length || abdocuInfo.docu_fg == "8"){
	            		// TODO : 예산 확인 필요. 
	            		// validationResult == 'BGT';
	            		validationResult = '';
	            	}
	            	// 여입결의서, 수입결의서 제외
	            	if(abdocuInfo.docu_mode =="1"){
		            	if(abdocuInfo.docu_fg == "5" || abdocuInfo.docu_fg == "6" || abdocuInfo.docu_fg == "7"){
		            		// TODO : 예산 확인 필요. 
		            		//validationResult = 'BGT';
		            		validationResult = '';
		            	}
	            	}
	            }
	    };	
	    /*결과 데이터 담을 객체*/
		acUtil.resultData = {};
	    acUtil.ajax.call(opt, acUtil.resultData );
	}

	if(validationResult == 'NaN'){
		alert('금액 검증도중 오류가 발생하였습니다.');
		return;
	}if(validationResult == 'CONFER'){
		alert('품의액을 초과 하였습니다. 확인해주세요.');
		return;
	}else if(validationResult == 'BGT'){
		alert(NeosUtil.getMessage("TX000011163","예산을 초과 하였습니다. 확인해주세요."));
		return;
	}
	
	$("." + abdocu.overBudget).removeClass(abdocu.overBudget);
	for ( var i = 0, max = overBudget.length; i < max; i++) {
		$("#" + overBudget[i] + " .totalAM", table).parents("td").addClass(abdocu.overBudget);
	}
	
	// 여입결의서, 수입결의서 제외
	if(abdocu.docu_mode =="1" && overBudget.length && (abdocu.docu_fg != "5" && abdocu.docu_fg != "6" && abdocu.docu_fg != "7")){
		alert(NeosUtil.getMessage("TX000011163","예산을 초과 하였습니다. 확인해주세요."));
		return;
	}
	
	// 수입품의서 제외
	if(abdocu.docu_mode =="0" && overBudget.length && abdocu.docu_fg != "8"){
		alert(NeosUtil.getMessage("TX000011163","예산을 초과 하였습니다. 확인해주세요."));
		return;
	}
	
	
	var obj ={  approKey : abdocuInfo.abdocu_no,
				abDocuNo : abdocuInfo.abdocu_no,
				mode : abdocuInfo.docu_mode,
				template_key : template_key,
				diKeyCode : c_dikeycode
    		};
    var param = NeosUtil.makeParam(obj);
    if($.trim(c_dikeycode)){
    	neosPopup('POP_DOCEDIT' , param);
    }else{
    	neosPopup('POP_DOCWRITE', param );
    }
    
    NeosUtil.close();

};

abdocu.setDatepicker = function(id, temp){
	var eventEle = $("#" + id); 
	eventEle.kendoDatePicker( {
    	format : "yyyy-MM-dd",
    	culture : "ko-KR",
    	change: function (){

			if(temp){				
				var value = this.value();
				$("#"+temp).val(eventEle.val());
			}    		
			var part = eventEle.attr("part");
			if(part){				 
				abdocu.focusNextRow(eventEle);
			}
			else{
				var tabIndex = eventEle.attr("tabIndex");
				$("[tabindex="+(tabIndex + 1)+"]").focus();
			}
    	},
    	click: function() {
    		alert("aaa");
    	},
    	open : function (){
    		
    	}
    });
	
	
//	var pickerOpts = { 
//			changeMonth : true,
//			changeYear : true,
//			duration : "normal",
//			
//            showOn : 'button',
//            buttonImage :  _g_contextPath_ + '/images/common/btn_callender.gif',
//            buttonImageOnly : false,
//            buttonText : "<spring:message code='search.dateSelect' />",
//            altFormat : "000000",
//			onSelect : function(dateText, inst) {
//				
//				var id = $(inst).attr("id");  
//				var eventEle = $("#" + id); 
//				var part = eventEle.attr("part");
//				if(part){
//					 
//					abdocu.focusNextRow(eventEle);
//				}
//				else{
//					var tabIndex = eventEle.attr("tabIndex");
//					$("[tabindex="+(tabIndex + 1)+"]").focus();
//				}
//			}
//		};
//	  
//	neosdatepicker.datepicker(id, pickerOpts);
};


/* 04. 거래처 정보 끝*/
abdocu.showItemsBtn = function(){
	if(gwOption.ItemsUseYn == "Y"){
//		if(abdocuInfo.docu_fg <= '4' || abdocuInfo.docu_fg == '8'){
			var table = $("#erpBudgetInfo-table");
			var total_am = $(".totalAM", table);
			var totalSum = 0;
			for(var i = 0, max = total_am.length; i< max ; i++){
				totalSum = parseInt(totalSum, 10) + parseInt($(total_am[i]).attr("code").valueOf().toString().toMoney2(), 10)  || "0" ;	
			}
			$("#budgetTotalAm").attr("code", totalSum);
			$("#btnItems").show();
			abdocu.setItemsTotalAm();
//		}
	}
};



abdocu.TradeInfo.getETCDUMMY1 = function(parentEle){
	var TR_CD  = $(".txt_TR_NM", parentEle).attr("code");
	var DATA_CD  = $(".txt_DATA_CD", parentEle).val();
	var ETCDUMMY1  = $(".txt_ETCDUMMY1", parentEle).val(); 
    var data = {
    		TR_CD : TR_CD,
    		DATA_CD :  DATA_CD,
    		ETCDUMMY1 : ETCDUMMY1,
    		CO_CD : abdocuInfo.erp_co_cd
    };
    
    var opt = {
    		url : _g_contextPath_ + "/Ac/G20/Ex/getETCDUMMY1.do",
    		stateFn:abdocu.state,
    		async:false,
    		data : data,
    		successFn : function(result){
    			if(result.selectList != null){
    				$("#pop_CTD_CD").val(result.selectList.CTD_CD);
    				$("#pop_CTD_NM").val(result.selectList.CTD_NM);
    				$(".txt_ETCDUMMY1", parentEle).val(result.selectList.CTD_CD);	
    			}
    			abdocu.TradeInfo.getETCPopSet(parentEle);	
    		}
	};
	acUtil.ajax.call(opt, null);
	
};

abdocu.TradeInfo.getETCDUMMY1Info = function(parentEle){
	var ETCDUMMY1  = $("#pop_CTD_CD").val();
	
	var DATA_CD  = $(".txt_DATA_CD", parentEle).val();
    var data = {
    		DATA_CD :  DATA_CD,
    		ETCDUMMY1 : ETCDUMMY1,
    		CO_CD : abdocuInfo.erp_co_cd
    };
    
    var opt = {
    		url : _g_contextPath_ + "/Ac/G20/Ex/getErpETCDUMMY1_Info.do",
    		stateFn:abdocu.state,
    		async:false,
    		data : data,
    		successFn : function(result){
    			if(result.selectList != null){
    				$("#pop_CTD_NM").val(result.selectList.CTD_NM);
    				$(".txt_ETCDUMMY1", parentEle).val(result.selectList.CTD_CD);	
        			abdocu.TradeInfo.getETCPopSet(parentEle);	
    			}else{
    				alert(NeosUtil.getMessage("TX000011162","존재하지 않는 코드입니다"));
					eventEle.dblclick();
    			}

    		}
	};
	acUtil.ajax.call(opt, null);
};

abdocu.TradeCardInit = function(){
	$("#tradeCardBtn").hide();
	$("#tradeCardNm").html("");	
};

abdocu.ItemsInit = function(){
	$("#btnItems").hide();
	$("#ItemsTotalAm").html("");	
};

abdocu.chkDuple = function(EMP_CD, RVRS_YM, SQ) {
    var result = true ;
    var temptr = $("#erpTradeInfo-table tr:not(.blank)");
    
	temptr.each(function(){
		if($(this).attr("id")){
			//var id = $(this).attr("id");
			var txt_TR_CD = $(".txt_TR_NM", $(this)).attr("code");
			var txt_RVRS_YM = $(".txt_ETCRVRS_YM", $(this)).val();
			var txt_ETCDUMMY1 = $(".txt_ETCDUMMY1", $(this)).val();
			//alert(txt_TR_CD +  txt_RVRS_YM +txt_ETCDUMMY1 + " : "+ EMP_CD +  RVRS_YM +SQ);
			
			if(txt_TR_CD == EMP_CD && txt_RVRS_YM ==RVRS_YM &&  txt_ETCDUMMY1 == SQ){
				result = false ;
			}
		}
	});  
    return result ;
};
abdocu.CauseForminit = function(){

	var temDir = $("#causeForm");

    $(":radio[name=B_use_YN]").bind({
		change : function(event){
		    $("#CAUSE_ID").dblclick();
    	}
 	});
//    
//	$("#userAllview").bind({
//    	click : function(event){
//    		$("#CAUSE_ID").dblclick();
//    	}
// 	});	
    
    $("#user_Search").bind({
		click : function(event){
		    $("#CAUSE_ID").dblclick();
    	}
 	});
    
	$("#CAUSE_ID, #CAUSE_NM").bind({
		dblclick :function(event){
			userSearchID = CAUSE_ID;
			var dblClickparamMap =
				[{
					"id" : "CAUSE_ID",
					"text" : "EMP_CD",
					"code" : ""		
				},
				{
					"id" : "CAUSE_NM",
					"text" : "KOR_NM",
					"code" : ""
				}];
			acUtil.util.dialog.dialogDelegate(acG20Code.getErpDeptUserList, dblClickparamMap);	
		}
	});
	
	$("#search-Event-T-emp").bind({
		click : function(event){
			$("#CAUSE_ID").dblclick();	
		}
	});

	$("#btnReset", temDir).click(function(){
		if(!abdocuInfo.abdocu_no){
			alert(NeosUtil.getMessage("TX000011161","프로젝트를 저장하세요"));
			return;	
		}

		var saveObj =
		{
			abdocu_no : abdocu_no || "0"
			,cause_dt : ""
			,sign_dt : ""
			,inspect_dt : ""
			,cause_id : ""
			,cause_nm : ""
		};
		
		abdocu.CauseSave("reset", saveObj);
	});	

    var temptr = $(".dateInput", temDir);
    
	temptr.each(function(){
		var id = $(this).attr("id");
		abdocu.setDatepicker(id);
	}); 
	
	$("#btnSave", temDir).click(function(type){
		if(!abdocu_no){
			alert(NeosUtil.getMessage("TX000011160","프로젝트를 먼저 저장하세요"));
			return;	
		}
		
		var saveObj =
		{
			abdocu_no : abdocu_no || "0"
			,cause_dt : $("#CAUSE_DT").val().replace(/-/gi,"")
			,sign_dt : $("#SIGN_DT").val().replace(/-/gi,"")
			,inspect_dt : $("#INSPECT_DT").val().replace(/-/gi,"")
			,cause_id : $("#CAUSE_ID").val()
			,cause_nm : $("#CAUSE_NM").val()
		};
		
		abdocu.CauseSave("save", saveObj);
	});
};

abdocu.CauseSave = function(type, saveObj){
	
	var resultData = {};
	/*ajax 호출할 파라미터*/
	var opt = {
			url : _g_contextPath_ + "/Ac/G20/Ex/setAbdocuCause.do",
			stateFn:abdocu.state,
			async:false,
			data : saveObj,
			successFn : function(data){
				if(data){
					if(type=="reset"){
						alert(NeosUtil.getMessage("TX000005771","초기화 되었습니다"));
						$("#CAUSE_DT").val("").attr("CODE", "");
						$("#SIGN_DT").val("").attr("CODE", "");
						$("#INSPECT_DT").val("").attr("CODE", "");
						$("#CAUSE_ID").val("").attr("CODE", "");
						$("#CAUSE_NM").val("").attr("CODE", "");
					}else if(type=="save"){
						if($("#CAUSE_DT").val() !=""){
			                 $("#CAUSE_DT").attr("CODE", "empty");
			            }
			            if($("#CAUSE_ID").val() !=""){
			            	$("#CAUSE_ID").attr("CODE", "empty");
			            }
			            if($("#CAUSE_NM").val() !=""){
			            	$("#CAUSE_NM").attr("CODE", "empty");
			            }
			            alert(NeosUtil.getMessage("TX000002073","저장되었습니다."));
					}else{
						
						if($("#CAUSE_DT").val() !=""){
			                 $("#CAUSE_DT").attr("CODE", "empty");
			            }
			            if($("#CAUSE_ID").val() !=""){
			            	$("#CAUSE_ID").attr("CODE", "empty");
			            }
			            if($("#CAUSE_NM").val() !=""){
			            	$("#CAUSE_NM").attr("CODE", "empty");
			            }
					}

				}
			}
	};
	acUtil.ajax.call(opt, resultData);
};


/**
 * 품의문서 가져오기 팝업
 */
function fnReferConferPop() {
	
	var tblParam = {};
    var GR_FG = "2"; /*예산과목의 수입/지출구분*/
    if(abdocuInfo.docu_mode=="1" &&  (abdocuInfo.docu_fg == "5" || abdocuInfo.docu_fg == "7") ){
    	GR_FG = "1";
    }
	tblParam.docu_fg   = abdocuInfo.docu_fg;
	tblParam.CO_CD     = abdocuInfo.erp_co_cd;
	tblParam.GISU_DT   = $("#txtGisuDate").val().replace(/-/gi,"");
	tblParam.GR_FG     = GR_FG;
	tblParam.callback  = "fnReferConferSet";
	tblParam.divId     = "ReferConferPop";
	var url = _g_contextPath_ + "/Ac/G20/Ex/ReferConferPop.do";
	acLayerPopOpen(url, tblParam, "970", "","ReferConferPop");

};

/**
 * 품의 잔액 표시 
 */

function fnGetConferBalance(id){
	
	var reffer_b_no = $("#"+id).attr("reffer_b_no");
       
	var opt = {
			url : _g_contextPath_ + "/Ac/G20/Ex/getConferBalance.do",
			stateFn : abdocu.state,
			async : false,
			data : {abdocu_b_no_reffer : reffer_b_no},
			successFn : function(result){
				var html = NeosUtil.getMessage("TX000009417","예산별 품의잔액 :") + result.LEFT_AM || "0";
				$("#referConfer").html(html);
				$("#referConfer").show();
			}
	};
	acUtil.ajax.call(opt);
};

/**
 * 법인카드승인내역 팝업
 */
function fnACardSunginPop() {
	var table = $("#erpBudgetInfo-table");
    var abdocu_b_no = $(".on", table).first().attr("id");
    if(!abdocu_b_no){
    	alert(NeosUtil.getMessage("TX000009416","예산을 선택하세요"));
    	return;
    }
    
	var tblParam = {};

	tblParam.abdocu_no = abdocuInfo.abdocu_no;
	tblParam.abdocu_b_no = abdocu_b_no;
	tblParam.erp_co_cd = abdocuInfo.erp_co_cd;
	tblParam.callback = "fnSetACardCallback";
	tblParam.divId = "ACardSunginPop";
	var url = _g_contextPath_ + "/Ac/G20/Ex/ACardSunginPop.do";
    acLayerPopOpen(url, tblParam, "900", "","ACardSunginPop");
	   
};

/**
 * 법인카드 승인내역  선택 callback
 */
function fnSetACardCallback(retVal){
	console.log(retVal);
	if(retVal) {
		if(!retVal.apply_am){
			retVal.apply_am = 0;
		}
		$("#" + retVal.abdocu_b_no + " .totalAM", "#erpBudgetInfo-table").html(retVal.apply_am.toString().toMoney());
		$("#" + retVal.abdocu_b_no + " .totalAM", "#erpBudgetInfo-table").attr("code" ,retVal.apply_am.toString().toMoney());
		abdocu.showItemsBtn();
		abdocu.BudgetInfo.rowSelect(retVal.abdocu_b_no);
	};
}

/**
 * 명세서 등록 팝업
 */
function fnItemsFormPop() {
	
	var tblParam = {};

	tblParam.abdocu_no = abdocuInfo.abdocu_no;
	tblParam.docu_fg   = abdocuInfo.docu_fg;
	tblParam.erp_co_cd = abdocuInfo.erp_co_cd;
	tblParam.callback  = "fnSetItemsCallback";
	tblParam.divId     = "ItemsFormPop";
	var url = _g_contextPath_ + "/Ac/G20/Ex/ItemsFormPop.do";
	acLayerPopOpen(url, tblParam, "828", "","ItemsFormPop");

};

/**
 * 명세서 등록 callback
 */
function fnSetItemsCallback(){
	abdocu.setItemsTotalAm();
}

/**
 * 명세서 등록 금액 표시
 */
abdocu.setItemsTotalAm = function(){
	
	if(abdocuInfo.abdocu_no){
		var tblParam = {};
		tblParam.abdocu_no = abdocuInfo.abdocu_no;
		tblParam.docu_fg   = abdocuInfo.docu_fg;
	    var opt = {
	            url     : _g_contextPath_ + "/Ac/G20/Ex/getItemsTotalAm.do",
	            stateFn : abdocu.state,
	            async   : false,
	            data    : tblParam,
	            successFn : function(data){
	            	if(data.result!=null && data.result.TOTAL_AM != null){
	            		var html = "<strong>"+NeosUtil.getMessage("TX000017824","명세서등록 금액")+" : <span style='color:#f26522;'>" + data.result.TOTAL_AM.toString().toMoney() + "</span></strong>";
	            		$("#ItemsTotalAm").attr("code" ,data.result.TOTAL_AM).html(html);
	            		$("#ItemsTotalAm").show();
	            	}else{
	            		$("#ItemsTotalAm").attr("code" ,"").html("");
	            		$("#ItemsTotalAm").hide();
	            	};
	            }
	    };
	    acUtil.ajax.call(opt);
	};

};

/**
 * 급여내역 조회 팝업
 */
function fnPayDataPop() {
	
    var table = $("#erpBudgetInfo-table");
    var id = $(".on", table).first().attr("id");
    if(!id){
    	alert(NeosUtil.getMessage("TX000009416","예산을 선택하세요"));
    	return;
    }
    
	var tblParam = {};

	tblParam.DIV_NM = $("#txtDIV_NM").val();
	tblParam.DIV_CD = $("#txtDIV_NM").attr("CODE");
	tblParam.MGT_NM = $("#txt_ProjectName").val();
	tblParam.MGT_CD = $("#txt_ProjectName").attr("CODE");
	tblParam.abdocu_no = abdocuInfo.abdocu_no;
	tblParam.abdocu_b_no = id;
	tblParam.erp_co_cd = abdocuInfo.erp_co_cd;
    
	tblParam.callback  = "fnPayDataCallback";
	tblParam.divId     = "PayDataPop";
	var url = _g_contextPath_ + "/Ac/G20/Ex/PayDataPop.do";
	acLayerPopOpen(url, tblParam, "970", "","PayDataPop");

};

/**
 * 급여내역 선택 callback
 */
function fnPayDataCallback(retVal){
	
	if(retVal) {
		$("#" + retVal.abdocu_b_no + " .totalAM", "#erpBudgetInfo-table").html(retVal.apply_am.toString().toMoney());
		$("#" + retVal.abdocu_b_no + " .totalAM", "#erpBudgetInfo-table").attr("code" ,retVal.apply_am.toString().toMoney());
		abdocu.showItemsBtn();
		abdocu.BudgetInfo.rowSelect(retVal.abdocu_b_no);
	};

}