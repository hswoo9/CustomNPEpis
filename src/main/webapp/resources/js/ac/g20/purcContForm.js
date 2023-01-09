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
	
	var strWidth = $('.pop_sign_wrap').outerWidth() + (window.outerWidth - window.innerWidth) + 20;
	var strHeight = $('.pop_sign_wrap').outerHeight() + (window.outerHeight - window.innerHeight);
	
//	$('.pop_sign_wrap').css("overflow","auto");
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
	}

	// 예산관리구분
	if(erpOption.BgtMngType == 1){
		$("#PjtTypeText").html(NeosUtil.getMessage("TX000000098","부서"));
	}
	
	// 하위사업사용여부
	if(erpOption.BottomUseYn == 1){
		$(".txt_ProjectName").attr("part", "");
		$(".txtBottom_cd").addClass("requirement");
		$(".BottomTd").show();
	}else{
		// 구매의뢰서 추가
		$(".txt_ProjectName").attr("part", "project");
		$(".txtBottom_cd").removeClass("requirement");
		$(".BottomTd").hide();
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
	var tr = $('#erpProjectInfo-trsample');
	$(".txtDIV_NM", tr).val(abdocuInfo.erp_div_nm);
	$(".txtDIV_NM", tr).attr("code", abdocuInfo.erp_div_cd);
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
    
    /*구매요청서 사용안함 주석처리*/
    /*if(abdocuInfo.abdocu_no != 0){ 
    	abdocu_no = abdocuInfo.abdocu_no; 
    	$("#txtDIV_NM").val(abdocuInfo.erp_div_nm);
    	$("#txtDIV_NM").attr("code", abdocuInfo.erp_div_cd);
		$("#txt_ProjectName").val(textToHtmlConvert(abdocuInfo.mgt_nm));
		$("#txt_ProjectName").attr("code", abdocuInfo.mgt_cd);
		$("#temp_PjtCd").val(abdocuInfo.mgt_cd);
		$("#txt_IT_BUSINESSLINK").val(abdocuInfo.it_businessLink);
		$("#txtBottom_cd").val(abdocuInfo.bottom_nm);
		$("#txtBottom_cd").attr("code", abdocuInfo.bottom_cd);

		$("#txt_Memo").val(abdocuInfo.rmk_dc.replace(/&apos;/g, "'").replace(/&quot;/g, '"').replace(/&amp;/, '&').replace(/&lt;/, '<').replace('&gt;',">"));		

		$("#causeForm").remove();
		var datepicker = $("#txtGisuDate").data("kendoDatePicker").enable(false); 
		if($("#txtAcisuDate").length){
			var datepicker = $("#txtAcisuDate").data("kendoDatePicker").enable(false);
		}
		
    }*/

    fnBudgetInfoSet();
    fnBudgetTableSet();
    fnTradeTableSet(1, 1);
    
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
		$("#project-td .txt_ProjectName, .txt_BUDGET_LIST").attr("disabled", false);
	}

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
	
	var tr = $("#erpProjectInfo-table tr:eq(1)").first(); 
	abdocu.saveImageClick(tr);
	
	BudgetComboxInit();
	
	acUtil.init();
	abdocu.eventHandlerMapping();

};

abdocu.focusSet = function(){
	if(focus){
		if("txt_BUDGET_LIST" == focus){
			$("#txtGisuYear, #txtGisuMonth, #txtGisuDay").attr("disabled", "disabled");
			$("#txtGisuDate").attr("disabled", "disabled");
			
			abdocu.BudgetInfo.init(null, focus + "1");
			
		}
	}
	else{
//		$("#txt_ProjectName").focus();
		$(".txtDIV_NM").focus();
		abdocu.BudgetInfo.remove();
		abdocu.TradeInfo.remove();
	}	
	
};

abdocu.eventHandlerMapping = function(){
	abdocu.UserInfo.eventHandlerMapping();
	//abdocu.ProjectInfo.eventHandlerMapping();
};

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

//	$("#txt_ProjectName").focus();
	$(".txtDIV_NM").focus();

};

/*사용자정보 지정하는 이벤트 매핑*/
abdocu.UserInfo.eventHandlerMapping = function(){
	
};


/* 01. ERP 사용자 정보 끝*/

/* 02. 프로젝트 정보 시작*/

abdocu.ProjectInfo.init = function(){
};


abdocu.ProjectInfo.focusNextRow = function(eventEle){
	var table =$("#erpUserInfo-table");
	if(!acUtil.util.validationCheck(table)){
		return false;
	}
	
	var table =$("#erpProjectInfo-table");
//	if(!acUtil.util.validationCheck(table)){  // 구매의뢰 수정
	if(!acUtil.util.validationCheck(table, eventEle)){
		return false;
	}
	var tr = eventEle.closest('tr');
};

abdocu.ProjectInfo.eventHandlerMapping = function(tr){
	$(tr).bind({
		click : function(){
			fnSelMgtTr(tr);
		}
	});
};

function fnMgtCdSet(sel, dblClickparamMap){
	console.log('Call fnMgtCdSet / callback project layer');
	var PJT_CD = sel.PJT_CD;
	if(PJT_CD != $("#temp_PjtCd").val()){
		$("#temp_PjtCd").val(PJT_CD);
		var id = dblClickparamMap[0].id;
		var tr = $('#' + id).closest('tr');
		if(tr.attr('id') && tr.attr('id') != 0){
			var data = {abdocu_no : tr.attr('id'), purc_req_h_id : purcReqHId};
			/*ajax 호출할 파라미터*/
			var opt = {
					url : _g_contextPath_ + "/Ac/G20/Ex/delPurcReqH.do",
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

	/*ajax 호출할 파라미터*/
	var resultData = {};
	var data = { purcContId : purcContId};
    var opt = {
            url : _g_contextPath_ + "/Ac/G20/Ex/getPurcContB.do",            
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
            		/*구매의뢰서*/
            		parentEle.attr("purcReqBId", result.purc_req_b_id);
            		parentEle.attr("purcContBId", result.purc_cont_b_id);
            		var returnYn = result.return_yn == 'Y' ? true : false;
            		$(".returnYn", parentEle).prop('checked', returnYn);
            		/*구매의뢰서*/
            		
            		$(".txt_BUDGET_LIST", parentEle).val(result.abgt_nm).attr("CODE", result.abgt_cd);
            		selectSet_Fg.data("kendoComboBox").value(result.set_fg);
            		$(".tempSet_Fg", parentEle).val(result.set_fg);
            		selectVat_Fg.data("kendoComboBox").value(result.vat_fg);
            		$(".tempVat_Fg", parentEle).val(result.vat_fg);
            		selectTr_Fg.data("kendoComboBox").value(result.tr_fg);
            		$(".tempTr_Fg", parentEle).val(result.tr_fg);
            		$(".txt_BUDGET_DIV_NM", parentEle).val(result.div_nm2).attr("CODE", result.div_cd2);
            		$(".BGT01_NM", parentEle).val(result.erp_bgt_nm1);
            		$(".BGT02_NM", parentEle).val(result.erp_bgt_nm2);
//            		$(".BGT03_NM", parentEle).val(result.abgt_nm).attr("CODE", result.abgt_cd);
            		$(".BGT03_NM", parentEle).val(result.erp_bgt_nm3).attr("CODE", result.erp_bgt_cd3);
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
        			$(".nextAm", parentEle).html(result.next_am.toString().toMoney());

            		/*구매요청서 추가*/
                	if(result.BGT04_CD){
                		$(".txt_BGTNM_REF", parentEle).val(result.erp_bgt_nm3).attr("CODE", result.erp_bgt_cd3);
                	}else if(result.BGT03_CD){
                		$(".txt_BGTNM_REF", parentEle).val(result.erp_bgt_nm2).attr("CODE", result.erp_bgt_cd2);
                	}else{
                		$(".txt_BGTNM_REF", parentEle).val(result.erp_bgt_nm1).attr("CODE", result.erp_bgt_cd1);
                	}
                	
                	var abdocuNo = result.abdocu_no;
                	var pjtTr = $('#erpProjectInfo-table #'+abdocuNo);
                	
                	/*$('.divNm', parentEle).html($('.txtDIV_NM', pjtTr).val());
                	$('.mgtNm', parentEle).html($('.txt_ProjectName', pjtTr).val());
                	$('.bottomNm', parentEle).html($('.txtBottom_cd', pjtTr).val());*/
                	$('.divNm', parentEle).val($('.txtDIV_NM', pjtTr).val()).attr('code', $('.txtDIV_NM', pjtTr).attr('code'));
                	$('.mgtNm', parentEle).val($('.txt_ProjectName', pjtTr).val()).attr('code', $('.txt_ProjectName', pjtTr).attr('code'));
                	$('.bottomNm', parentEle).val($('.txtBottom_cd', pjtTr).val()).attr('code', $('.txtBottom_cd', pjtTr).attr('code'));
                	/*구매요청서 추가*/
                	
                	 if(result.vat_fg == 3){
                     	selectTr_Fg.data("kendoComboBox").enable();
                     }
                     
             		if(i == 0 && !noInitSet){
             			var taxType = result.vat_fg; //$("#selectG20TAX_TP1").val();
             			fnTradeTableSet(result.tr_fg, taxType);
             			abdocu.TradeInfo.remove();
             			abdocu.BudgetInfo.rowSelect(result.abdocu_b_no);
             		}

					$(".txt_BGTNMCD", parentEle).val('(' + result.abgt_cd + ') ' + result.abgt_nm);
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
                $('#erpBudgetInfo-table .blank').remove();
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
//	return $(".on").attr("id"); /*선택되어있는 ROW ID*/
	return $("#erpBudgetInfo-table .on").attr("id"); /*선택되어있는 ROW ID*/
};

var selectSet_Fg ;
var selectVat_Fg ;
var selectTr_Fg ;
var selectTr_Fg_value ;

/**
 * 예산 row 추가 
 */
abdocu.BudgetInfo.addRow = function(){
	
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
               
     		var modeType = $(".tempTr_Fg", tr).val();
     		
     		fnTradeTableSet(modeType, taxType);
     		var table = $("#erpBudgetInfo-table");
     		var id = $(".on", table).first().attr("id");
     		var select = $(".selectVat_Fg", tr);
     		if(id){
     			abdocu.BudgetInfo.focusNextRow(select);
     			this.focus();
     		}else{
     			abdocu.TradeInfo.remove();
     			this.focus();
     		}
     	}    
    });
	
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
	data.purc_req_h_id = purcReqHId;
    var opt = {
            url : _g_contextPath_ + "/Ac/G20/Ex/delPurcReqB.do",
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

	if(id=="txtDIV_NM"){
		fn(id);
	}
	
	if(id=="txtDEPT_NM"){
		fn(id);
	}
	
	return false;
};

/*예산액, 예산잔액, 집행액 구하기
 *
 parameter
 id : 예산과목 textbox  id
 */
abdocu.BudgetInfo.getBudgetInfo = function(id){
	var txt_BUDGET_LIST = $("#" + id);
	var obj =  {};
	var pjtTr = $('#'+id).closest('tr');
	if($(".divNm", pjtTr).attr("CODE")){
		obj.DIV_CD    = $(".divNm", pjtTr).attr("CODE");
		obj.MGT_CD    = $(".mgtNm", pjtTr).attr("CODE");
		obj.BOTTOM_CD = $(".bottomNm", pjtTr).attr("CODE") || "";
	}else{
		pjtTr = $('#' + abdocuInfo.abdocu_no, $('#erpProjectInfo-table'));
	    obj.DIV_CD    = $(".txtDIV_NM", pjtTr).attr("CODE");
	    obj.MGT_CD    = $(".txt_ProjectName", pjtTr).attr("CODE");
	    obj.BOTTOM_CD = $(".txtBottom_cd", pjtTr).attr("CODE") || "";
	}
    
	obj.BGT_CD    = txt_BUDGET_LIST.attr("CODE");
    obj.SUM_CT_AM = 0;
    obj.GISU_DT   = abdocuInfo.erp_gisu_dt;
    obj.DOCU_MODE = abdocuInfo.docu_mode;
    obj.CO_CD     = abdocuInfo.erp_co_cd;
    obj.FROM_DT     = abdocuInfo.erp_gisu_from_dt;
    obj.TO_DT     = abdocuInfo.erp_gisu_to_dt;
    obj.GISU      = abdocuInfo.erp_gisu;
    
    /* G20 2.0 파라미터 추가 */
    obj.consDocSeq   = consDocSeq;
    obj.mgtSeq       = $(".mgtNm", pjtTr).attr("CODE");
    obj.budgetSeq    = txt_BUDGET_LIST.closest("tr").attr("id");
    obj.erpBudgetSeq = txt_BUDGET_LIST.attr("CODE");
    obj.gisu         = abdocuInfo.erp_gisu;
    obj.bottomSeq    = $(".txtBottom_cd", pjtTr).attr("CODE") || "";

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
            	var eventEle = $("#" + id);
            	var parentEle = eventEle.parents("tr");
            	$(".BGT01_NM", parentEle).val(result.BGT01_NM);
            	$(".BGT02_NM", parentEle).val(result.BGT02_NM);
            	$(".BGT03_NM", parentEle).val(result.BGT03_NM).attr("CODE", result.BGT03_CD);
            	$(".BGT04_NM", parentEle).val(result.BGT04_NM);
            	
            	$(".LEVEL01_NM", parentEle).val(result.LEVEL01_NM);
            	$(".LEVEL02_NM", parentEle).val(result.LEVEL02_NM);
            	$(".LEVEL03_NM", parentEle).val(result.LEVEL03_NM);
            	$(".LEVEL04_NM", parentEle).val(result.LEVEL04_NM);
            	$(".LEVEL05_NM", parentEle).val(result.LEVEL05_NM);
            	$(".LEVEL06_NM", parentEle).val(result.LEVEL06_NM);
            	            	
            	$(".OPEN_AM", parentEle).val(result.OPEN_AM);
            	$(".ACCT_AM", parentEle).val(result.ACCT_AM);
            	$(".DELAY_AM", parentEle).val(result.DELAY_AM);
            	$(".APPLY_AM", parentEle).val(result.APPLY_AM);
            	$(".LEFT_AM", parentEle).val(result.LEFT_AM);
            	$(".CTL_FG", parentEle).val(result.CTL_FG);

            	$("#td_veiw_BGT01_NM").html(result.BGT01_NM || "");
            	$("#td_veiw_BGT02_NM").html(result.BGT02_NM || "");
            	$("#td_veiw_BGT03_NM").html(result.BGT03_NM || "");
            	$("#td_veiw_BGT04_NM").html(result.BGT04_NM || "");
            	$("#td_veiw_OPEN_AM").html((result.OPEN_AM || "0").toString().toMoney());
            	$("#td_veiw_ACCEPT_AM").html((result.ACCEPT_AM || "0").toString().toMoney());
            	$("#td_veiw_APPLY_AM").html((result.APPLY_AM || "0").toString().toMoney());
            	$("#td_veiw_REFER_AM").html((result.REFER_AM || "0").toString().toMoney());
            	$("#td_veiw_LEFT_AM").html((result.LEFT_AM || ")").toString().toMoney());
            	
            	/*구매요청서 추가*/
            	if(result.BGT04_CD){
            		$(".txt_BGTNM_REF", parentEle).val(result.BGT03_NM);
            		$(".txt_BGTNM_REF", parentEle).attr("CODE", result.BGT03_CD);
            		$(".txt_BUDGET_LIST", parentEle).val(result.BGT04_NM);
            		$(".txt_BUDGET_LIST", parentEle).attr("CODE", result.BGT04_CD);
            	}else if(result.BGT03_CD){
            		$(".txt_BGTNM_REF", parentEle).val(result.BGT02_NM);
            		$(".txt_BGTNM_REF", parentEle).attr("CODE", result.BGT02_CD);
            		$(".txt_BUDGET_LIST", parentEle).val(result.BGT03_NM);
            		$(".txt_BUDGET_LIST", parentEle).attr("CODE", result.BGT03_CD);
            	}else{
            		$(".txt_BGTNM_REF", parentEle).val(result.BGT01_NM);
            		$(".txt_BGTNM_REF", parentEle).attr("CODE", result.BGT01_CD);
            		$(".txt_BUDGET_LIST", parentEle).val(result.BGT02_NM);
            		$(".txt_BUDGET_LIST", parentEle).attr("CODE", result.BGT02_CD);
            	}
            	/*구매요청서 추가*/
				$(".txt_BGTNMCD", parentEle).val('(' + result.BGT_CD + ') ' + result.BGT_NM);
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

	var modeType = $(".tempTr_Fg", trEle).val();
	var taxType = $(".tempVat_Fg", trEle).val();
	if(modeType && abdocuInfo.docu_mode == "1"){
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
	
	/*if(abdocu_no_reffer){ //참조품의 결의서일경우 
		fnGetConferBalance(id);  //품의 잔액 표시
	}*/
	
	// 계약보고 요청잔액 표시
	fnGetPurcReqLeftAm(id);
	
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
};



abdocu.BudgetInfo.addRowImg = function(){
	abdocu.append("b");
};
/* 03. 예산정보 끝*/


/* 04. 거래처 정보 시작*/
abdocu.TradeInfo.init = function(){
	abdocu.TradeInfo.remove();
};

/*
	 - 호출되는 경우
	1. 예산정보(중간) 에 따른 하위 거래처정보 목록 조회
	2. 예산정보에서 다른 row(행)을 선택했을경우 거래처 다시 binding(DB조회)
*/
abdocu.TradeInfo.select = function(rowSelectID, eventid){

	var abdocu_b_no = eventid;

	/*ajax 호출할 파라미터*/
	var resultData = {};
	var purc_tr_type = $('#tableTab .selTab').attr('id');
	var data = { abdocu_b_no : abdocu_b_no, purc_tr_type : purc_tr_type, purc_cont_id : purcContId};
    var opt = {
            url : _g_contextPath_ + "/Ac/G20/Ex/getPurcContT.do",
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
		// 구매계약시 주석
		/*if(!result.tr_cd){
			tr_cd = "empty";
		}else{
			tr_cd = result.tr_cd;
		}*/
		tr_cd = result.tr_cd;
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
		
		$(".txt_ITEM_NM", parentEle).val(result.item_nm);/*품명*/
        $(".txt_ITEM_CNT", parentEle).val((result.item_cnt === undefined || !result.item_cnt ? '0' : result.item_cnt).toString().toMoney()); /*수량*/
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
		
		/*구매의뢰서 추가*/
		$('.ppsIdNo', parentEle).val(result.pps_id_no);
		$("input[name=itemType]", parentEle).data("kendoComboBox").value(result.item_type_code_id);
		$('.standard', parentEle).val(result.standard);
		$('.contents', parentEle).val(result.contents);
		$('.startDate', parentEle).val(result.start_date);
		$('.endDate', parentEle).val(result.end_date);
		$('.ppsFees', parentEle).val(result.pps_fees.toString().toMoney());
		$('.nextAm', parentEle).val(result.next_am.toString().toMoney());
		$('.trNm', parentEle).val(result.tr_nm);
		$('.ceoNm', parentEle).val(result.ceo_nm);
		$('.regNb', parentEle).val(result.reg_nb);
		
		parentEle.attr("purcContTId", result.purc_cont_t_id);
		
		if(purcReqType == "2"){
			if($('.txt_TR_NM', parentEle).val()){
				var result = purcReq.getErpTrade($('.txt_TR_NM', parentEle).attr('code'), $('.txt_TR_NM', parentEle).val());
				if(result.length == 1){
					$('.txt_TR_NM', parentEle).val(result[0].TR_NM).attr("code", result[0].TR_CD);
					$('.txt_REG_NB', parentEle).val(result[0].REG_NB);
					$('.txt_CEO_NM', parentEle).val(result[0].CEO_NM);
					var resultData = {};
					if(processId != "view"){
						abdocu.TradeInfo.RowSave($('.txt_TR_NM', parentEle), resultData);
					}
				}
			}
		}
		/*구매의뢰서 추가*/
		
		tradeListIndexForUI++ ;
		setTimeout(fnAddTradeList, 2);
	}
	$('#erpTradeInfo .blank').remove();
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
    
    /*구매의뢰서 추가*/
    saveObj.purc_req_b_id = $('#erpBudgetInfo-table>tbody>.on').attr('purcReqBId');
    saveObj.pps_id_no = $('.ppsIdNo', parentEle).val();
    saveObj.item_type_code_id = $('input[name=itemType]', parentEle).val();
    saveObj.item_type = $('input[name=itemType_input]', parentEle).val();
    saveObj.standard = $('.standard', parentEle).val();
    saveObj.contents = $('.contents', parentEle).val();
    saveObj.start_date = $('input[name=startDate]', parentEle).val();
    saveObj.end_date = $('input[name=endDate]', parentEle).val();
    saveObj.pps_fees = $('.ppsFees', parentEle).val().toString().toMoney2();
    saveObj.next_am = $('.nextAm', parentEle).val().toString().toMoney2();
    saveObj.purc_tr_type = $('#tableTab .selTab').attr('id');
    // 계약보고시 불필요?
    /*if(purcReqType != "2"){
    	saveObj.tr_nm = $('.trNm', parentEle).val();
    	saveObj.ceo_nm = $('.ceoNm', parentEle).val();
    	saveObj.reg_nb = $('.regNb', parentEle).val();
    }*/
    
    saveObj.purc_cont_id = purcContId;
    saveObj.purc_cont_b_id = $('#erpBudgetInfo-table>tbody>.on').attr('purcContBId');
    saveObj.purc_cont_t_id = parentEle.attr("purcContTId") || "0";
    /*구매의뢰서 추가*/
   
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
    	  url     : _g_contextPath_ + "/Ac/G20/Ex/setPurcContT.do"
    	, stateFn : abdocu.state
    	, async   : false
    	, data    : saveObj
    	, successFn : function(data){
    		if(data.result == 'Excess'){
    			alert('요청액을 초과 할 수 없습니다.');
    			return;
    		}
    		var table = $("#erpBudgetInfo-table");
    		var parentEle = $(".on", table);
    		var id = $(".txt_BUDGET_LIST", parentEle).attr("id");
    		// 물품구매계약보고 주석처리
    		//abdocu.BudgetInfo.rowSelect(abdocu_b_no);
    		
    		if(resultData.result && resultData.result > 0){
    			$("#" + abdocu_b_no + " .totalAM", "#erpBudgetInfo-table").html("");
    			$("#" + abdocu_b_no + " .nextAm", "#erpBudgetInfo-table").html("");
    		}
    		
    		if(resultData.abdocu_B && resultData.abdocu_B.apply_am){
    			/* 상배 vatIgnore */
    			$("#" + abdocu_b_no + " .totalAM", "#erpBudgetInfo-table").html( resultData.abdocu_B.apply_am.toString().toMoney());
    			$("#" + abdocu_b_no + " .totalAM", "#erpBudgetInfo-table").attr("code" ,resultData.abdocu_B.apply_am.toString().toMoney());
    			$("#" + abdocu_b_no + " .nextAm", "#erpBudgetInfo-table").html( resultData.abdocu_B.next_am.toString().toMoney());
    			abdocu.showItemsBtn();
    		}
    		
    		if(resultData.purcContInfo && resultData.purcContInfo.contAm){
    			$('#contAm').val(resultData.purcContInfo.contAm.toString().toMoney());
    		}
    		
    		purcReq.purcReqInfoSave();
    		//abdocu.TradeInfo.addRow();
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
//	$(".show",tr).each(function(idx, vlaue){
	$(".non-requirement, .requirement",tr).each(function(idx, vlaue){
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
			blank.first().replaceWith(tr);
		}
		else{
			blank.remove();
			var empty = $("#erpTradeInfo-tablesample-empty");
			var blank_tr = $("tr", empty).clone(false);
			table.append(blank_tr);
			tr.insertBefore($("tr.blank:first", table));
			
		}
	}else{
		table.append(tr);
	}
	abdocu.TradeInfo.eventHandlerMapping(tr, addId);
	acUtil.init_trade(tr);

//	$("input[type=text]", tr).first().focus();
	$("input[type=text].requirement", tr).first().focus(); // 구매의뢰서 수정

	//금액
	tempparentEle = null;
	$(".txt_UNIT_AM", tr).bind({
		focusout : function(event){
			var resultData = {};
			abdocu.TradeInfo.RowSave($(this), resultData);
		}, 
		keydown : function(event){
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
			
			var table = $("#erpBudgetInfo-table");
			var parentEle_temp = $("tr.on", table);
			var modeType = $(".tempTr_Fg", parentEle_temp).val();
			var taxType = $(".tempVat_Fg", parentEle_temp).val();			
			
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
			var taxType = $(".tempVat_Fg", parentEle_temp).val();
			if(taxType == "1"){
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
						
			var supAmt = input.val();
			supAmt = supAmt.valueOf().toString().toMoney2();
			input.val(supAmt.toString().toMoney());
			
			var unitAm = ((  Math.round(       parseInt(supAmt,10) * 1.1 / 10   )   ) * 10);
			
			var taxType = $(".tempVat_Fg", parentEle_temp).val();
			if(taxType =="2"){
				var money = $(".txt_VAT_AM", parentEle).val() || 0;
				money = money.valueOf().toString().toMoney2(); 
				$(".txt_UNIT_AM", parentEle).val((parseInt(money,10) + parseInt(supAmt,10)).toString().toMoney() || 0 );
			}else if(taxType == "3"){
				var money = $(".txt_VAT_AM", parentEle).val() || 0;
				money = money.valueOf().toString().toMoney2(); 
				$(".txt_UNIT_AM", parentEle).val((parseInt(money,10) + parseInt(supAmt,10)).toString().toMoney() || 0 );
			}else{
				$(".txt_UNIT_AM", parentEle).val(parseInt(unitAm,10).toString().toMoney() || 0 );
				$(".txt_VAT_AM", parentEle).val((parseInt(unitAm,10) - parseInt(supAmt,10)).toString().toMoney() || 0 );				
			}
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
			
			var taxType = $(".tempVat_Fg", parentEle_temp).val();
			if(taxType == "1"){
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
			
		}
	}).css("cursor","pointer");	
	
	/* 저장 버튼 클릭시*/
	abdocu.saveImageClick(tr);
	
	/*구매의뢰서 품목구분*/
	fnTpfComboBoxInit('PURC_REQ_ITEM_TYPE', 'itemType', tr);
	abdocu.setDatepicker($('.startDate', tr).attr('id'));
	abdocu.setDatepicker($('.endDate', tr).attr('id'));
	$('.startDate', tr).attr('disabled', true);
	$('.endDate', tr).attr('disabled', true);
	if($('#purcReqType').attr('code') == '2'){
		$('.txt_ITEM_CNT, .txt_ITEM_AM, .txt_UNIT_AM, .txt_SUP_AM, .txt_VAT_AM', tr).bind({
			blur : function(){
				/*var unitAm = parseInt($('.txt_UNIT_AM', tr).val().toMoney2());
				var supAm = parseInt($('.txt_SUP_AM', tr).val().toMoney2());
				var vatAm = parseInt($('.txt_VAT_AM', tr).val().toMoney2());
				var ppsFees = Math.floor((supAm + vatAm) * 0.0054);
				unitAm = supAm + vatAm + ppsFees;
				$('.txt_UNIT_AM', tr).val(unitAm.toString().toMoney());*/
			},
			keyup : function(){
				var unitAm = parseInt($('.txt_UNIT_AM', tr).val().toMoney2());
				var supAm = parseInt($('.txt_SUP_AM', tr).val().toMoney2());
				var vatAm = parseInt($('.txt_VAT_AM', tr).val().toMoney2());
				var ppsFees = Math.floor(unitAm * 0.0054);
				unitAm = supAm + vatAm + ppsFees;
				$('.ppsFees', tr).val(ppsFees.toString().toMoney());
				$('.txt_UNIT_AM', tr).val(unitAm.toString().toMoney());
			},
			keydown : function(){
				var unitAm = parseInt($('.txt_UNIT_AM', tr).val().toMoney2());
				var supAm = parseInt($('.txt_SUP_AM', tr).val().toMoney2());
				var vatAm = parseInt($('.txt_VAT_AM', tr).val().toMoney2());
				var ppsFees = Math.floor(unitAm * 0.0054);
				unitAm = supAm + vatAm;
				$('.txt_UNIT_AM', tr).val(unitAm.toString().toMoney());
			}
		});
		$('.ppsFees', tr).bind({
			keyup : function(){
				var supAm = parseInt($('.txt_SUP_AM', tr).val().toMoney2());
				var vatAm = parseInt($('.txt_VAT_AM', tr).val().toMoney2());
				var ppsFees = parseInt($('.ppsFees', tr).val().toMoney2());
				var unitAm = supAm + vatAm + ppsFees;
				$('.txt_UNIT_AM', tr).val(unitAm.toString().toMoney());
			},
			focusout : function(){
				var resultData = {};
				abdocu.TradeInfo.RowSave($(this), resultData);
			}
		});
	}
	$('.txt_ITEM_CNT, .txt_ITEM_AM, .txt_SUP_AM, .txt_VAT_AM, .nextAm', tr).bind({
		focusout : function(event){
			var resultData = {};
			abdocu.TradeInfo.RowSave($(this), resultData);
		}
	});
	$(".nextAm", tr).bind({
		keyup : function(){
			$(this).val($(this).val().toString().toMoney());
		}
	});
	
	/*상하이동*/
	$("input", tr).bind({
		keydown : function(event){
			if($(this).attr("tabindex")){
				var keycode =event.keyCode;
				if(keycode == 38){
					var tabindex = parseInt($(this).attr("tabindex").toMoney2()) - 1000
					$("input[tabindex=" + tabindex + "]").focus();
				}else if(keycode == 40){
					var tabindex = parseInt($(this).attr("tabindex").toMoney2()) + 1000
					$("input[tabindex=" + tabindex + "]").focus();
				}
			}
		}
	});
	/*구매의뢰서 품목구분*/
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
	var percent = $("#etc_percent").val();
	percent = percent.valueOf().toString().toMoney2();
	percent = parseInt(percent, 10) || 0;
	
	var popID = $("#" + acUtil.divEtcPop).attr("opener");
	var input = $("#" + popID);
	var parentEle = input.parents("tr");
	
	var UNIT_AM = $(".txt_UNIT_AM", parentEle).val();
	
	UNIT_AM = UNIT_AM.valueOf().toString().toMoney2();
	UNIT_AM = parseInt(UNIT_AM, 10) || 0;
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
	var purc_cont_t_id = $('#erpTradeInfo-table #'+id).attr('purcContTId')
	var purc_cont_b_id = parentEle.attr("purcContBId");
	var data = {
		  abdocu_t_no : id
		, abdocu_b_no : abdocu_b_no
		, purc_cont_t_id : purc_cont_t_id
		, purc_cont_b_id : purc_cont_b_id
		, purc_cont_id : purcContId
	};
    var opt = {
            url : _g_contextPath_ + "/Ac/G20/Ex/delPurcContT.do",
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
                    
                    if(resultData.purcContInfo && resultData.purcContInfo.contAm){
            			$('#contAm').val(resultData.purcContInfo.contAm.toString().toMoney());
            		}else{
            			$('#contAm').val('');
            		}
                    if(!resultData.abdocu_B){
                    	abdocu.focusSet();
                    }else{
                    	abdocu.BudgetInfo.rowSelect(abdocu_b_no);
                    }
                    purcReq.purcReqInfoSave();
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
	
};


/* 04. 거래처 정보 끝*/
abdocu.showItemsBtn = function(){
	if(gwOption.ItemsUseYn == "Y"){
		var table = $("#erpBudgetInfo-table");
		var total_am = $(".totalAM", table);
		var totalSum = 0;
		for(var i = 0, max = total_am.length; i< max ; i++){
			totalSum = parseInt(totalSum, 10) + parseInt($(total_am[i]).attr("code").valueOf().toString().toMoney2(), 10)  || "0" ;	
		}
		$("#budgetTotalAm").attr("code", totalSum);
		$("#btnItems").show();
	}
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
			var txt_TR_CD = $(".txt_TR_NM", $(this)).attr("code");
			var txt_RVRS_YM = $(".txt_ETCRVRS_YM", $(this)).val();
			var txt_ETCDUMMY1 = $(".txt_ETCDUMMY1", $(this)).val();
			
			if(txt_TR_CD == EMP_CD && txt_RVRS_YM ==RVRS_YM &&  txt_ETCDUMMY1 == SQ){
				result = false ;
			}
		}
	});  
    return result ;
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

/*구매의뢰서 시작*/

var purcReq = {};

var purcReqAbdocuHList = {};
/**
 * 구매의뢰 초기화
 */
purcReq.init = function(){
	fnTpfCommInit();
	$('#purcReqDate').attr('disabled', true);
	if(processId == 'tpfContRep'){
		fnTpfComboBoxInit('PURC_CONT_PAY_CON', 'payCon', $('#purcContInfo'));
		fnTpfComboBoxInit('PURC_CONT_PAY_TYPE', 'payType', $('#purcContInfo'));
		fnTpfComboBoxInit('PURC_CONT_TYPE', 'contType', $('#purcContInfo'));
		abdocu.setDatepicker('contEndDate');
		abdocu.setDatepicker('contDate');
	}else if(processId == 'tpfContConc'){
		abdocu.setDatepicker('contDate2');
		abdocu.setDatepicker('contStartDate2');
		abdocu.setDatepicker('contEndDate2');
		$('#contDate2').attr('disabled', true);
		$('#contStartDate2').attr('disabled', true);
		$('#contEndDate2').attr('disabled', true);
	}
	$('#contEndDate').attr('disabled', true);
	$('#contDate').attr('disabled', true);
	$('.payCon').attr('readonly', true);
	$('.payType').attr('readonly', true);
	$('.contType').attr('readonly', true);
	abdocu.TradeInfo.eventHandlerMapping($('#cont-trade-td'), '_cont');
	fnTpfPurcReqAttachFileInit();
	purcReq.eventHandlerMapping();
	fnTabInit();
};

function fnTabInit(){
	var code = $('#purcReqType').attr('code');
	if(code == '1' || code == '2'){
		$('#tableTab').hide();
		$('#tableTab #002').addClass('selTab');
		return;
	}else if(code == '3'){
		$('#tableTab #001').html('공사');
	}else if(code == '4'){
		$('#tableTab #001').html('용역');
	}
	$('#tableTab').hide();
	$('#tableTab #001').addClass('selTab');
}

/**
 * 구매의뢰 필수첨부파일 영역 초기화
 */
function fnTpfPurcReqAttachFileInit(){
	var purcReqType = $('#purcReqType').attr('code');
	if(purcReqType == '1'){
		$('#attach3, #attach4').hide().addClass('notUsed');
	}else if(purcReqType == '2'){
		$('#attach2, #attach3, #attach4').hide().addClass('notUsed');
	}else if(purcReqType == '3'){
		$('#attach2, #attach4').hide().addClass('notUsed');
	}else if(purcReqType == '4'){
		$('#attach2, #attach3').hide().addClass('notUsed');
	}
}

/**
 * 구매의뢰 이벤트 매핑
 */
purcReq.eventHandlerMapping = function(){
	/*거래처영역 이미지 검색 클릭 이벤트*/
	$(".search-Event-T", $('#cont-trade-td')).bind({
		click : function(event){
			var parentEle = $(this).parent();
			var eventEle = $(".non-requirement, .requirement", parentEle).first();
			eventEle.dblclick();
		}
	});
	$('#btnApproval').bind({
		click : function(){
			fnPurcReqApproval();
		}
	});
	$('#btnConc').bind({
		click : function(){
			fnPurcContConc();
		}
	});
	$('.tdTab').bind({
		click : function(){
			fnSelTab($(this))
		}
	});
	$('#contTerm, #contEndDate').bind({
		change : function(){
			fnTpfDateChange($(this));
		}
	});
	$('#purcContInfo input').bind({
		change : function(){
			purcReq.purcReqInfoSave();
		}
	});
	$('#purcContInfo2 input').bind({
		change : function(){
			if($(this).attr("id") == "contDate2"){
				fnContDate2Change();
			}
			purcReq.purcContInfoSave();
		}
	});
	$('#attachFile').bind({
		change : function(){
			fnTpfAttachFileUpload($(this));
		}
	});
	$('#payType').bind({
		change : function(){
			fnPayTypeChange();
		}
	});
	$('#payCnt').bind({
		keyup : function(){
			$(this).val($(this).val().toMoney2());
		}
	});
	$('#contDate, #contEndDate').bind({
		change : function(){
			var contDate = $("#contDate").val();
			var contEndDate = $("#contEndDate").val();
			if(contDate && contEndDate && contDate > contEndDate){
				alert("계약예정일은 사업기간 이내로 선택해야 합니다.");
			}
		}
	});
};

function fnContDate2Change(){
	$("#contStartDate2").data("kendoDatePicker").value($("#contDate2").val());
	if($("#contEndDate").val()){
		$("#contEndDate2").data("kendoDatePicker").value($("#contEndDate").val());
	}else{
		var date = new Date($("#contDate2").val());
		date.setDate(date.getDate() + parseInt($("#contTerm").val()));
		var contEndDate = date.getFullYear() + '-' + (date.getMonth() + 1) + '-' + date.getDate();
		$("#contEndDate2").data("kendoDatePicker").value(contEndDate);
	}
}

function fnPayTypeChange(){
	var payType = $('#payType').val();
	if(payType == "002"){
		$(".payCnt").show();
		$("span.payType").css("width", "100px");
	}else{
		$("#payCnt").val("1");
		$(".payCnt").hide();
		$("span.payType").css("width", "95%");
	}
}

function fnSelTab(selTab){
	if(selTab.hasClass('selTab'))return;
	$('.tdTab').removeClass('selTab');
	selTab.addClass('selTab');
	var id = $('#erpBudgetInfo-table .on').attr('id');
	ctlTradeReset();
	fnConsTradeTableSet();
	abdocu.BudgetInfo.rowSelect(id);
}

function purcContRepFormPop(purcReqId, purcReqType, formId){
	var url = _g_contextPath_ + '/Ac/G20/Ex/purcContRepForm.do?focus=txt_BUDGET_LIST&purcReqId=' + purcReqId + '&purcReqType=' + purcReqType + '&form_id=' + formId;
	var pop = "" ;
	var width = "1000";
	var height = "950";
	windowX = Math.ceil( (window.screen.width  - width) / 2 );
	windowY = Math.ceil( (window.screen.height - height) / 2 );
	var strResize = 0 ;
	pop = window.open(url, '구매계약보고', "width=" + width + ", height=" + height + ", top="+ windowY +", left="+ windowX +", resizable="+ strResize);
	try {pop.focus(); } catch(e){}
}

/**
 * 구매의뢰 공통코드(구매의뢰서 구분) 초기화
 */

function fnTpfCommInit(){
	var commCodeList = fnTpfGetCommCodeList('PURC_REQ_TYPE');
	var commCdoe = commCodeList.filter(function(obj){return obj.code == purcReqType;})[0];
	$('#purcReqType').val(commCdoe.code_kr);
	$('#purcReqType').attr('CODE',commCdoe.code);
}

/**
 * 콤보박스 초기화
 */
function fnTpfComboBoxInit(groupCode, id, parentEle){
	var commCodeList = fnTpfGetCommCodeList(groupCode);
	var itemType = $("." + id, parentEle).kendoComboBox({
		dataSource : commCodeList,
		dataTextField: "code_kr",
		dataValueField: "code",
		index: 0
    });
	$('.' + id, parentEle).attr('readonly', true);
}

commCode = {};
/**
 * 공통코드리스트 조회
 */
function fnTpfGetCommCodeList(groupCode){
	if(commCode[groupCode]){
		return commCode[groupCode];
	}
	var result = {};
	var params = {};
	params.group_code = groupCode;
    var opt = {
    		url     : _g_contextPath_ + "/commcode/getCommCodeList",
            async   : false,
            data    : params,
            successFn : function(data){
            	result = data;
            	commCode[groupCode] = data;
            }
    };
    acUtil.ajax.call(opt);
	return result;
}

var consDocSeq = "";

/**
 * 구매의뢰 데이터 조회
 */
function fnPurcReqInfo(){
	if(purcReqId == 0){
    	fnAbdocuInit();
    	purcReq.purcReqHAddRow(1);
    }else{
    	var params = {};
    	params.purcReqId = purcReqId;
    	params.targetTableName = 'tpf_purc_req';
    	params.targetId = purcReqId;
    	params.purcContId = purcContId;
    	var opt = {
    			url     : _g_contextPath_ + "/Ac/G20/Ex/getPurcCont.do",
    			async   : false,
    			data    : params,
    			successFn : function(data){
    				// G20 2.0
    				consDocSeq = data.purcContInfo.consDocSeq;
    				
    				var purcContInfo = data.purcContInfo;
    				var purcReqInfo = data.purcReqInfo;
    				var purcReqHList = data.purcReqHList;
    				var purcReqAttachFileList = data.purcReqAttachFileList;
    				var purcReqAttachFileList2 = data.purcReqAttachFileList2;
    				var purcReqAttachFileListCont = data.purcReqAttachFileListCont;
    				var purcReqAttachFileListCont2 = data.purcReqAttachFileListCont2;
    				var purcContAddTr = data.purcContAddTr;
    				purcReq.setPurcContInfo(purcContInfo);
    				purcReq.setPurcReq(purcReqInfo);
    				if(purcReqHList.length > 0){
    					purcReq.setPurcReqHList(purcReqHList);
    				}
    				if(purcReqAttachFileList.length > 0){
    					purcReq.setPurcReqAttachFileList(purcReqAttachFileList);
    				}
    				if(purcReqAttachFileList2.length > 0){
    					purcReq.setPurcReqAttachFileList2(purcReqAttachFileList2);
    				}
    				if(purcReqAttachFileListCont.length > 0){
    					purcReq.setPurcReqAttachFileListCont(purcReqAttachFileListCont);
    				}
    				if(purcReqAttachFileListCont2.length > 0){
    					purcReq.setPurcReqAttachFileListCont2(purcReqAttachFileListCont2);
    				}
    				if(purcContAddTr.length > 0){
    					purcReq.setPurcContAddTr(purcContAddTr);
    				}
    				fnAbdocuInfo();
    			}
    	};
    	acUtil.ajax.call(opt);
    }
	abdocuInfo.docu_fg = '1';
	abdocuInfo.docu_fg_text = '지출품의서';
}

purcReq.setPurcContInfo = function(purcContInfo){
	$('#contTitle').val(purcContInfo.contTitle);
	if(purcContInfo.payConCodeId){
		if($("#payCon").data("kendoComboBox")){
			$("#payCon").data("kendoComboBox").value(purcContInfo.payConCodeId);
		}else{
			$("#payCon").val(purcContInfo.payCon).attr('code', purcContInfo.payConCodeId);
		}
	}
	if(purcContInfo.payTypeCodeId){
		if($("#payType").data("kendoComboBox")){
			$("#payType").data("kendoComboBox").value(purcContInfo.payTypeCodeId);
		}else{
			$("#payType").val(purcContInfo.payType).attr('code', purcContInfo.payTypeCodeId);
		}
	}
	$('#payCnt').val(purcContInfo.payCnt);
	if(purcContInfo.contAm){
		$('#contAm').val(purcContInfo.contAm.toString().toMoney());
	}
	if(purcContInfo.contTypeCodeId){
		if($("#contType").data("kendoComboBox")){
			$("#contType").data("kendoComboBox").value(purcContInfo.contTypeCodeId);
		}else{
			$("#contType").val(purcContInfo.contType).attr('code', purcContInfo.contTypeCodeId);
		}
	}
	if($("#contEndDate").data("kendoDatePicker")){
		$("#contEndDate").data("kendoDatePicker").value(ncCom_Date(purcContInfo.contEndDate, '-'));
	}else{
		$("#contEndDate").val(ncCom_Date(purcContInfo.contEndDate, '-'));
	}
	$('#contTerm').val(purcContInfo.contTerm);
	if($("#contDate").data("kendoDatePicker")){
		$("#contDate").data("kendoDatePicker").value(ncCom_Date(purcContInfo.contDate, '-'));
	}else{
		$("#contDate").val(ncCom_Date(purcContInfo.contDate, '-'));
	}
	$('#txt_TR_NM_cont').val(purcContInfo.trNm).attr('code', purcContInfo.trCd);
	$('#txt_REG_NB_cont').val(purcContInfo.regNb);
	$('#txt_CEO_NM_cont').val(purcContInfo.ceoNm);
	
	var result = purcReq.getErpTrade($('#txt_TR_NM_cont').attr('code'), $('#txt_TR_NM_cont').val());
	if(result.length == 1){
		result = result[0];
		$('#txt_TR_NM_cont').val(result.TR_NM).attr('code',result.TR_CD);
		$('#txt_REG_NB_cont').val(result.REG_NB);
		$('#txt_CEO_NM_cont').val(result.CEO_NM);
	}else if(result.length > 1) {
		$('#txt_TR_NM_cont').val($('#txt_TR_NM').val());
	}else {
		$('#txt_TR_NM_cont').val($('#txt_TR_NM').val());
	}
	if(purcContInfo.contStep == '003'){
		$('#btnConc').show();
	}else{
		$('#btnConc').hide();
	}
	if(processId == 'tpfContConc'){
		if(purcContInfo.contDate){
			$("#contDate2").data("kendoDatePicker").value(ncCom_Date(purcContInfo.contDate, '-'));
			$("#contStartDate2").data("kendoDatePicker").value(ncCom_Date(purcContInfo.contDate, '-'));
		}
		if(purcContInfo.contEndDate){
			$("#contEndDate2").data("kendoDatePicker").value(ncCom_Date(purcContInfo.contEndDate, '-'));
		}
		if(purcContInfo.contDate2){
			$("#contDate2").data("kendoDatePicker").value(ncCom_Date(purcContInfo.contDate2, '-'));
		}
		if(purcContInfo.contTerm && $("#contDate2").val()){
			var date = new Date(purcContInfo.contDate);
			date.setDate(date.getDate() + parseInt(purcContInfo.contTerm));
			var contEndDate = date.getFullYear() + '-' + (date.getMonth() + 1) + '-' + date.getDate();
			$("#contEndDate2").data("kendoDatePicker").value(contEndDate);
		}
		if(purcContInfo.contStartDate2){
			$("#contStartDate2").data("kendoDatePicker").value(ncCom_Date(purcContInfo.contStartDate2, '-'));
		}
		if(purcContInfo.contEndDate2){
			$("#contEndDate2").data("kendoDatePicker").value(ncCom_Date(purcContInfo.contEndDate2, '-'));
		}
	}else if(processId == "view"){
		$("#contDate2").val(ncCom_Date(purcContInfo.contDate2, '-'));
		$("#contStartDate2").val(ncCom_Date(purcContInfo.contStartDate2, '-'));
		$("#contEndDate2").val(ncCom_Date(purcContInfo.contEndDate2, '-'));
	}
	
	if(purcContInfo.expectedAm){
		$("#expectedAm").val(purcContInfo.expectedAm.toString().toMoney());
	}
	
	/*소재지 추가*/
	if(purcContInfo.trPlace){
		if($("#trPlace").data("kendoComboBox")){
			$("#trPlace").data("kendoComboBox").value(purcContInfo.trPlace);
		}else{
			$("#trPlace").val(purcContInfo.trPlace);
		}
	}
	/*소재지 추가*/
};

/**
 * 구매의뢰 데이터 입력
 */
purcReq.setPurcReq = function(purcReqInfo){
	$('#purcReqId').val(purcReqInfo.purcReqId);
	$('#purcReqNo').val(purcReqInfo.purcReqNo2);
	$('#purcReqTitle').val(purcReqInfo.purcReqTitle);
	$('#purcReqDate').val(purcReqInfo.purcReqDate);
	$('#term').val(purcReqInfo.term);
	$('#purcPurpose').val(purcReqInfo.purcPurpose);
	$('#txt_TR_NM').val(purcReqInfo.trNm).attr('code', purcReqInfo.trCd);
	if(purcReqInfo.reqState == '004'){
		$('.psh_btnbox .psh_right btnApproval').show();
	}else{
		$('.psh_btnbox .psh_right btnApproval').hide();
	}
	$('#regDate').val(purcReqInfo.regDate);
	$('#requester').val(purcReqInfo.requesterDeptName +' '+ purcReqInfo.requesterEmpName +' '+ purcReqInfo.requesterPosition);
	$("#requester_emp_seq").val(purcReqInfo.requesterEmpSeq);
	$("#requester_dept_name").val(purcReqInfo.requesterDeptName);
	$("#requester_position").val(purcReqInfo.requesterPosition);
	$("#requester_duty").val(purcReqInfo.requesterDuty);
	
	if(purcReqInfo.basicAm){
		$("#basicAm").val(purcReqInfo.basicAm.toString().toMoney());
	}
	if($("#contAm").val() && $("#basicAm").val() && $("#basicAm").val().toMoney2() > 0 && $("#contAm").val().toMoney2() > 0){
		var contAm = parseInt($("#contAm").val().toMoney2());
		var basicAm = parseInt($("#basicAm").val().toMoney2());
		var rate = Math.round(contAm/basicAm*100*1000)/1000;
		$("#rate").val(rate + "%");
	}else{
		$("#rate").val("");
	}
//	$("#rate").val(purcReqInfo.rate);
};

purcReq.setPurcReqHList = function(purcReqHList){
	$.each(purcReqHList, function(idx){
		var tr = purcReq.purcReqHAddRow(idx+1);
		if(abdocu_no == '0' && idx == 0){
			abdocu_no = this.abdocu_no;
		}
		if(idx == 0 || abdocu_no == this.abdocu_no){
			$('#erpProjectInfo-table tr').removeClass('on');
			tr.addClass('on');
			abdocuInfo = this;
			purcReqHId = this.purc_req_h_id;
		}
		tr.attr('id', this.abdocu_no);
		tr.attr('purcReqHId', this.purc_req_h_id);
		$(".txtDIV_NM", tr).val(this.erp_div_nm);
		$(".txtDIV_NM", tr).attr("code", this.erp_div_cd);
		$(".txt_ProjectName", tr).val(textToHtmlConvert(this.mgt_nm));
		$(".txt_ProjectName", tr).attr("code", this.mgt_cd);
		$(".temp_PjtCd", tr).val(this.mgt_cd);
		$(".txt_IT_BUSINESSLINK", tr).val(this.it_businessLink);
		$(".txtBottom_cd", tr).val(this.bottom_nm);
		$(".txtBottom_cd", tr).attr("code", this.bottom_cd);
		$('.totalAM_h', tr).html((this.totalAmt + '').toMoney());
		
		$("#txt_Memo").val(this.rmk_dc.replace(/&apos;/g, "'").replace(/&quot;/g, '"').replace(/&amp;/, '&').replace(/&lt;/, '<').replace('&gt;',">"));		
		
		$("#causeForm").remove();
		var datepicker = $("#txtGisuDate").data("kendoDatePicker").enable(false); 
		if($("#txtAcisuDate").length){
			var datepicker = $("#txtAcisuDate").data("kendoDatePicker").enable(false);
		}
		purcReqAbdocuHList[this.abdocu_no] = this;
	});
}

purcReq.setPurcReqAttachFileList = function(purcReqAttachFileList){
	$.each(purcReqAttachFileList, function(){
		var span = $('#fileSample div').clone();
		$('.file_name', span).html(this.real_file_name + '.' + this.file_extension);
		$('.attachFileId', span).val(this.attach_file_id);
		$('.fileSeq', span).val(this.file_seq);
		$('#fileArea0').append(span);
	});
};

purcReq.setPurcReqAttachFileList2 = function(purcReqAttachFileList2){
	$.each(purcReqAttachFileList2, function(){
		var fileType = this.fileType;
		var span = $('#fileSample div').clone();
		$('.file_name', span).html(this.realFileName + '.' + this.fileExtension);
		$('.attachFileId', span).val(this.attachFileId);
		$('.fileSeq', span).val(this.fileSeq);
		$('.filePath', span).val(this.filePath);
		$('.fileNm', span).val(this.realFileName + '.' + this.fileExtension);
		$('#fileArea' + fileType).append(span);
	});
};

purcReq.setPurcReqAttachFileListCont = function(purcReqAttachFileList){
	$.each(purcReqAttachFileList, function(){
		var span = $('#fileSample2 div').clone();
		$('.file_name', span).html(this.real_file_name + '.' + this.file_extension);
		$('.attachFileId', span).val(this.attach_file_id);
		$('.fileSeq', span).val(this.file_seq);
		$('#fileArea_cont').append(span);
	});
};

purcReq.setPurcReqAttachFileListCont2 = function(purcReqAttachFileList){
	$.each(purcReqAttachFileList, function(){
		var fileType = this.fileType;
		var span = $('#fileSample3 div').clone();
		$('.file_name', span).html(this.realFileName + '.' + this.fileExtension);
		$('.attachFileId', span).val(this.attachFileId);
		$('.fileSeq', span).val(this.fileSeq);
		$('.filePath', span).val(this.filePath);
		$('.fileNm', span).val(this.realFileName + '.' + this.fileExtension);
		$('#fileArea_cont' + fileType).append(span);
	});
};

purcReq.setPurcContAddTr = function(purcContAddTr){
	$.each(purcContAddTr, function(){
		var trCd = this.trCd;
		var trNm = this.trNm;
		var span = $('#addTradeTdSample span').clone();
    	$(".trNmTxt", span).html(trNm);
    	$(".trCd", span).val(trCd);
    	$(".trNm", span).val(trNm);
		$("#txt_TR_NM_add_span").append(span);
	});
};

purcReq.purcReqHAddRow = function(rowno){
	var tr = $('#erpProjectInfo-trsample').clone().show();
	tr.attr('id', '');
	var table = $("#erpProjectInfo-table");  
	$('tbody', table).append(tr);
	$(".requirement, .non-requirement", tr).each(function(idx, vlaue){
		var addTabIndex = parseInt(rowno + '00');
		$(this).attr('id', this.name + rowno);
		$(this).attr("tabindex", addTabIndex + idx);
	});
	abdocu.ProjectInfo.eventHandlerMapping(tr);
	/*프로젝트영역 이미지(검색) 클릭이벤트*/
	$(".search-Event-H", tr).bind({
		click : function(event){
			var parentEle = $(this).parent();
			var eventEle = $(".non-requirement, .requirement", parentEle).first();
			eventEle.dblclick();
		}
	});
	return tr;
};

/**
 * 구매의뢰 프로젝트 row선택 이벤트
 */
function fnSelMgtTr(tr){
	if(tr.attr('id') == abdocu_no)return;
	tradeListForUI = null;
	$('#erpProjectInfo-table tr').removeClass('on');
	tr.addClass('on');
	abdocu_no = tr.attr('id') || '0';
	purcReqHId = tr.attr('purcReqHId');
	if(!tr.attr('id')){
		abdocu.BudgetInfo.remove();
		abdocu.TradeInfo.remove();
		return;
	}
	abdocuInfo = purcReqAbdocuHList[tr.attr('id')];
	abdocu.focusSet();
}

/**
 * 거래처
 */
purcReq.getErpTrade = function(tr_cd, tr_nm){
	var obj = {};
	obj.CO_CD = abdocuInfo.erp_co_cd;
	obj.TR_CD = tr_cd;
	obj.TR_NM = tr_nm;
		
	var resultData = {};
    var opt = {
			url     : _g_contextPath_ + "/Ac/G20/Ex/getErpTrade.do",
			async   : false,
			data    : obj,
			successFn : function(data){
				resultData = data.selectList;
			}
	};
    acUtil.ajax.call(opt);
    return resultData;
};

/**
 * 구매보고 사업기간 변경 이벤트
 */
function fnTpfDateChange(obj){
	if('contEndDate' === obj.attr('id')){
		$('#contTerm').val('');
	}else{
		$("#contEndDate").data("kendoDatePicker").value('');
		obj.val(obj.val() ? obj.val().toMoney2() : '');
	}
}

purcReq.purcReqInfoSave = function(){
	// 기초금액 낙찰률 추가 20190827 pjm
	if($("#contAm").val() && $("#basicAm").val() && $("#basicAm").val().toMoney2() > 0 && $("#contAm").val().toMoney2() > 0){
		var contAm = parseInt($("#contAm").val().toMoney2());
		var basicAm = parseInt($("#basicAm").val().toMoney2());
		var rate = Math.round(contAm/basicAm*100*1000)/1000;
		$("#rate").val(rate + "%");
	}else{
		$("#rate").val("");
	}
	var obj = {};
	obj.purcContId = purcContId;
	obj.contTitle = $('#contTitle').val();
	obj.payCon = $('#payCon').data('kendoComboBox').text();
	obj.payConCodeId = $('#payCon').val();
	obj.payType = $('#payType').data('kendoComboBox').text();
	obj.payTypeCodeId = $('#payType').val();
	obj.payCnt = $('#payCnt').val();
	obj.contAm = $('#contAm').val();
	obj.contType = $('#contType').data('kendoComboBox').text();
	obj.contTypeCodeId = $('#contType').val();
	obj.contEndDate = $('#contEndDate').val();
	obj.contTerm = $('#contTerm').val();
	obj.contDate = $('#contDate').val();
	obj.trNm = $('#txt_TR_NM_cont').val();
	obj.trCd = $('#txt_TR_NM_cont').attr('code');
	obj.regNb = $('#txt_REG_NB_cont').val();
	obj.ceoNm = $('#txt_CEO_NM_cont').val();
	obj.expectedAm = $('#expectedAm').val();
	obj.rate = $('#rate').val();
	
	obj.purcReqId = purcReqId;
	obj.requester_emp_seq = $("#requester_emp_seq").val();
	obj.requester_dept_name = $("#requester_dept_name").val();
	obj.requester_position = $("#requester_position").val();
	obj.requester_duty = $("#requester_duty").val();
	obj.tr_place = $("#trPlace").val();
	
    var opt = {
			url     : _g_contextPath_ + "/Ac/G20/Ex/updatePurcCont.do",
			async   : false,
			data    : obj,
			successFn : function(data){
				
			}
	};
    acUtil.ajax.call(opt);
};

/**
 * 첨부파일 선택창 오픈
 * */
function fnFileOpen(fileType){
	$('#fileType').val(fileType);
	$('#attachFile').click();
}

/**
 * 첨부파일 업로드
 * */
function fnTpfAttachFileUpload(obj){
	var targetId = purcContId;
	var targetTableName = 'tpf_purc_cont';
	var fileType = $('#fileType').val();
	if(fileType == '2' || fileType == '3'){
		targetId = purcReq.setPurcContAttach(targetId, fileType);
		targetTableName = 'tpf_purc_cont_attach';
	}
	var path = 'tpf_purc_cont';
	var fileForm = obj.closest('form');
	var fileInput = obj;
	var fileList = fnCommonFileUpload(targetTableName, targetId, path, fileForm);
	$.each(fileList, function(){
		var span = $('#fileSample2 td div').clone();
		if(fileType == '2' || fileType == '3'){
			span = $('#fileSample3 td div').clone();
		}
		$('.file_name', span).html(this.fileNm + "." + this.ext);
		$('.attachFileId', span).val(this.attach_file_id);
		$('.fileSeq', span).val(this.fileSeq);
		$('.filePath', span).val(this.filePath);
		$('.fileNm', span).val(this.fileNm + "." + this.ext);
		$('#fileArea_cont'+fileType).append(span);
	});
	fileInput.unbind();
	fileForm.clearForm();
	fileInput.bind({
		change : function(){
			fnTpfAttachFileUpload($(this));
		}
	})
	//fnResizeForm();
}

purcReq.setPurcContAttach = function(targetId, fileType){
	var saveObj = {};
	var resultData = {};
	saveObj.purcReqId = targetId;
	saveObj.fileType = fileType;
	var opt = {
    		url : _g_contextPath_ + "/Ac/G20/Ex/setPurcContAttach.do",
    		stateFn : abdocu.state,
            async: false,
            data : saveObj,
            successFn : function(data){
            	if(data){
                	targetId = data.purcContAttachId;
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
	return targetId;
};

/**
 * 첨부파일 삭제
 * */
function fnTpfAttachFileDelete(obj){
	if(!confirm('첨부파일을 삭제하시겠습니까?')){
		return;
	}
	var span = $(obj).closest('div');
	var attach_file_id = $('.attachFileId', span).val();
	fnCommonFileDelete(attach_file_id);
	var fileType = $('#fileType').val();
	if(fileType != '0'){
		
	}
	span.remove();
	//fnResizeForm();
}

/**
 * 첨부파일 다운로드
 * */
function fnTpfAttachFileDownload(obj){
	var span = $(obj).closest('div');
	var attach_file_id = $('.attachFileId', span).val();
	var downWin = window.open('','_self');
	downWin.location.href = _g_contextPath_ + '/common/fileDown?attach_file_id='+attach_file_id;
}

function fnPurcReqApproval(){
	if(!$('#contTitle').val()){
		alert('계약명을 입력하세요.');
		return false;
	}
//	if(!$('#contDate').val()){
//		alert('계약예정일을 입력하세요.');
//		return false;
//	}
	if(!$('#txt_TR_NM_cont').val()){
		alert('거래처를 선택하세요.');
		return false;
	}
//	if(!$('#txt_REG_NB_cont').val()){
//		alert('거래처를 선택하세요.');
//		return false;
//	}
//	if(!$('#txt_CEO_NM_cont').val()){
//		alert('거래처를 선택하세요.');
//		return false;
//	}
//	if(!$('#txt_TR_NM_cont').attr("code")){
//		alert('거래처를 선택하세요.');
//		return false;
//	}
	
	var isSuccess = true;
	$("." + acUtil.invalidClass).removeClass(acUtil.invalidClass);
	var msg = NeosUtil.getMessage("TX000011209","입력되지 않은 값이 있습니다. 확인해주세요.");
	var table3 = $("#erpTradeInfo-table");
	var obj = {
			isSuccess : isSuccess,
			msg : msg
	};
	
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
		alert(obj.msg);
		return obj;
	}
	
	if(confirm('계약보고를 작성합니다.')){
		purcReq.purcReqInfoSave();
		approvalOpen();
	}
}

/**
 * 결재작성
 */
function approvalOpen(){
	var params = {};
    params.compSeq =$('#compSeq').val();
    params.approKey = 'tpfContRep' + purcContId;
    if(location.host.indexOf("127.0.0.1") > -1 || location.host.indexOf("localhost") > -1){
    	params.outProcessCode = "tpfContRep";
    }else{
    	params.outProcessCode = "tpfContRep";
    }
    params.empSeq = $('#empSeq').val();
    params.mod = 'W';
    params.contentsEnc = 'O';
    params.fileKey = makeFileKey();
    var result = getPurcContDocInfo();
    params.contentsStr = makeContentsStr(result);
	if($('#contType').val() === '001'){
	    params.title = $("#contTitle").val() + ' 계약 체결';
	}else{
	    params.title = $("#contTitle").val() + ' 계약';
	}
    params.prev_url = location.href;
    params.prev_name = "정보수정";
    outProcessLogOn2(params);
    //window.close();
}


/**
 * 계약보고 예산별 요청잔액 조회
 */
function fnGetPurcReqLeftAm(id){
	var obj = {};
	var tr = $('#'+id);
	obj.purc_req_b_id = tr.attr('purcReqBId');
	var opt = {
			url     : _g_contextPath_ + "/Ac/G20/Ex/getPurcReqLeftAm.do",
			async   : false,
			data    : obj,
			successFn : function(data){
				if(data.purcReqLeftAm){
					$('#referConfer').html('예산별 요청잔액 :'+data.purcReqLeftAm.toString().toMoney());
				}
			}
	};
    acUtil.ajax.call(opt);
}

/**
 * 계약체결
 */
function fnPurcContConc(){
	if(!$('#contDate2').val()){
		alert('계약일을 입력하세요.');
		return;
	}
	if($("#contType").attr("code") == "001"){
		if($('#fileArea_cont2 span').length < 1){
			alert('표준계약서를 등록하세요.')
			return false;
		}
	}
	if(confirm('계약을 체결합니다.')){
		if(!purcReq.purcContInfoSave())return;
		var obj = {};
		obj.purcContId = purcContId;
		obj.purcReqId = purcReqId;
		obj.docState = '004';
		var opt = {
				//url     : _g_contextPath_ + "/Ac/G20/Ex/updateContDocSts.do",
				url     : _g_contextPath_ + "/Ac/G20/Ex/purcContracted.do",
				async   : false,
				data    : obj,
				successFn : function(data){
					if(data.result == 'Success'){
						alert('계약이 체결되었습니다.');
						window.close();
					}
				}
		};
		acUtil.ajax.call(opt);
	}
}

purcReq.purcContInfoSave = function(){
	var result = true;
	var obj = {};
	obj.purcContId = purcContId;
	obj.contTitle = $('#contTitle').val();
	obj.payCon = $('#payCon').val();
	obj.payConCodeId = $('#payCon').attr('code');
	obj.payType = $('#payType').val();
	obj.payTypeCodeId = $('#payType').attr('code');
	obj.payCnt = $('#payCnt').val();
	obj.contAm = $('#contAm').val();
	obj.contType = $('#contType').val();
	obj.contTypeCodeId = $('#contType').attr('code');
	obj.contEndDate = $('#contEndDate').val();
	obj.contTerm = $('#contTerm').val();
	obj.contDate = $('#contDate').val();
	obj.trNm = $('#txt_TR_NM_cont').val();
	obj.trCd = $('#txt_TR_NM_cont').attr('code');
	obj.regNb = $('#txt_REG_NB_cont').val();
	obj.ceoNm = $('#txt_CEO_NM_cont').val();
	obj.contDate2 = $('#contDate2').val();
	obj.contStartDate2 = $('#contStartDate2').val();
	obj.contEndDate2 = $('#contEndDate2').val();
    var opt = {
			url     : _g_contextPath_ + "/Ac/G20/Ex/updatePurcCont.do",
			async   : false,
			data    : obj,
			successFn : function(data){
				if(data.result != 'Success'){
					alert('계약정보 저장에 실패했습니다.');
					result = false;
				}
			}
	};
    acUtil.ajax.call(opt);
    return result;
};

/**
 * 파일키 생성
 */
function makeFileKey(){
	var fileKey = "";
	var saveObj = {};
	saveObj.targetId = purcContId;
	saveObj.targetTableName = "tpf_purc_cont";
	var opt = {
    		url : _g_contextPath_ + "/Ac/G20/Ex/makeFileKey.do",
    		stateFn : abdocu.state,
            async: false,
            data : saveObj,
            successFn : function(data){
            	if(data){
            		fileKey = data.fileKey;
            	}else{
					alert(NeosUtil.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요"));
            	}
            }
            ,
            failFn : function (request,status,error) {
    	    	alert(NeosUtil.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요")+".\n errorCode :"+request.responseText+"\n");
        	}
    };
	acUtil.ajax.call(opt);
	return fileKey;
}

function getPurcContDocInfo(){
	var result = {};
	var saveObj = {};
	saveObj.purcContId = purcContId;
	var opt = {
    		url : _g_contextPath_ + "/Ac/G20/Ex/getPurcContDocInfo.do",
    		stateFn : abdocu.state,
            async: false,
            data : saveObj,
            successFn : function(data){
            	result = data;
            }
            ,
            failFn : function (request,status,error) {
    	    	alert(NeosUtil.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요")+".\n errorCode :"+request.responseText+"\n");
        	}
    };
	acUtil.ajax.call(opt);
	return result;
}

/**
 * 문서본문 생성
 */
function makeContentsStr(result){
	var purcContInfo = result.purcContInfo;
	var purcContBList = result.purcContBList;
	var html = "";
	if($('#contType').val() === '001'){
		html += '<div style="font-family:맑은 고딕;font-size:11pt;text-align:left;height:500px;">';
		html += '1. 관련 : ';
		$.each(onnaraDocs, function(i){
			html += (i == 0 ? '' : ', ');
			html += this.AUTHORDEPTNAME + '-' + this.DOCNOSEQ + '(' + moment(this.ENDDT.substr(0,8)).format('YYYY.MM.DD') + ')호';
		});
		html += '.';
		html += '<br/>';
		if(purcContInfo.evalType === '150'){
			html += '2. ' + $('#contTitle').val() + '의 전자시담을 실시하고, 그 결과에 따른 계약을 체결하고자 합니다.';
		}else{
			html += '2. ' + $('#contTitle').val() + '의 기술협상을 실시하고, 그 결과에 따른 계약을 체결하고자 합니다.';
		}
		html += '<br/>';
		html += '<br/>';
		html += '&nbsp;&nbsp;가. 계 약 명: ' + $('#contTitle').val();
		html += '<br/>';
		html += '&nbsp;&nbsp;나. 계약방법 : 일반경쟁(협상에 의한 계약)';
		html += '<br/>';
		html += '&nbsp;&nbsp;다. 우선협상대상자 : ' + $('#txt_TR_NM_cont').val();
		html += '<br/>';
		html += '&nbsp;&nbsp;&nbsp;&nbsp;○ 가격협상 : 비예가(입찰가로 확정)';
		html += '<br/>';
		html += '&nbsp;&nbsp;&nbsp;&nbsp;○ 기술협상 : 모두 수용';
		html += '<br/>';
		var contEndDate = $('#contEndDate').val();
		if(!contEndDate){
			contEndDate = $('#contTerm').val();
		}
		html += '&nbsp;&nbsp;라. 계약업체 : ' + $('#txt_TR_NM_cont').val();
		html += '<br/>';
		html += '&nbsp;&nbsp;마. 계약기간 : 계약일로부터 ~ ' + contEndDate + '일 까지';
		html += '<br/>';
		html += '&nbsp;&nbsp;바. 계약금액 : 금' + $('#contAm').val() + '원(금' + numToKOR($('#contAm').val().toMoney2()) + '원), 부가세 포함';
		html += '<br/>';
		html += '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span style="font-size:9pt;"> 향후 조달계약 진행으로 인한 수수료 별도 집행</span>';
		html += '<br/>';
		html += '<br/>';
		html += '<span style="display:inline-block;width:40px;">붙 임 </span>1. 용역계약서 1부.';
		html += '<br/>';
		html += '<span style="display:inline-block;width:40px;"></span>2. 용역계약일반조건 1부.';
		html += '<br/>';
		html += '<span style="display:inline-block;width:40px;"></span>3. 일반과업지시서 1부.';
		html += '<br/>';
		html += '<span style="display:inline-block;width:40px;"></span>4. 업체제안서 1부.';
		html += '<br/>';
		html += '<span style="display:inline-block;width:40px;"></span>5. 산출내역서 1부.';
		html += '<br/>';
		html += '<span style="display:inline-block;width:40px;"></span>6. 기술협상서 1부.';
		html += '<br/>';
		if(purcContInfo.evalType === '150'){
			html += '<span style="display:inline-block;width:40px;"></span>7. 부당계약체크리스트와 서약서 각 1부.';
			html += '<br/>';
			html += '<span style="display:inline-block;width:40px;"></span>8. 예정가격조서  1부.  끝.';
		}else{
			html += '<span style="display:inline-block;width:40px;"></span>7. 부당계약체크리스트와 서약서 각 1부.  끝.';
		}
		html += '<br/>';
		html += '<br/>';
		html += '</div>';
	}else if($('#contType').val() === '002'){
		html += '<div style="font-family:맑은 고딕;font-size:11pt;text-align:left;height:500px;">';
		html += '1. 관련 : ';
		$.each(onnaraDocs, function(i){
			html += (i == 0 ? '' : ', ');
			html += this.AUTHORDEPTNAME + '-' + this.DOCNOSEQ + '(' + moment(this.ENDDT.substr(0,8)).format('YYYY.MM.DD') + ')호';
		});
		html += '.';
		html += '<br/>';
		html += '2. 위 호에 따라 \'' + $('#contTitle').val() + '\' 에 대하여 계약을 체결하고자 합니다.';
		html += '<br/>';
		html += '<br/>';
		html += '&nbsp;&nbsp;가. 물품(용역)명 : ' + $('#contTitle').val();
		html += '<br/>';
		html += '&nbsp;&nbsp;나. 주요내용 : ' + $('#purcPurpose').val();
		html += '<br/>';
		var regNb = $('#txt_REG_NB_cont').val();
		if(regNb){
			regNb = regNb.substr(0, 3) + '-' + regNb.substr(3, 2) + '-' + regNb.substr(5, 5)
		}
		html += '&nbsp;&nbsp;다. 계약대상 : ' + $('#txt_TR_NM_cont').val() + ' / ' + $('#txt_CEO_NM_cont').val() + ' / ' + regNb;
		html += '<br/>';
		var contEndDate = $('#contEndDate').val();
		if(!contEndDate){
			contEndDate = $('#contTerm').val() + '일 까지';
		}
		html += '&nbsp;&nbsp;라. 계약기간 : ' + $('#contDate').val() + ' ~ ' + contEndDate;
		html += '<br/>';
		html += '&nbsp;&nbsp;마. 계약금액 : 금' + $('#contAm').val() + '원(금' + numToKOR($('#contAm').val().toMoney2()) + '원, VAT 포함)';
		html += '<br/>';
		html += '&nbsp;&nbsp;바. 집행과목 : ' + purcContBList[0].mgt_nm + ' ' + purcContBList[0].erp_bgt_nm1 + '/' + purcContBList[0].erp_bgt_nm2 + '/' + purcContBList[0].erp_bgt_nm3;
		html += '<br/>';
		html += '&nbsp;&nbsp;사. 조달구분 : 수의계약 (국계령 제26조 제1항 제5호와 제30조 제1항)';
		html += '<br/>';
		html += '&nbsp;&nbsp;아. 상생기업구분 : ';
		html += '<br/>';
		html += '<br/>';
		html += '<span style="display:inline-block;width:40px;">붙 임 </span>1. 용역계약서 1부.';
		html += '<br/>';
		html += '<span style="display:inline-block;width:40px;"></span>2. 용역계약일반조건 1부.';
		html += '<br/>';
		html += '<span style="display:inline-block;width:40px;"></span>3. 과업지시서 1부.';
		html += '<br/>';
		html += '<span style="display:inline-block;width:40px;"></span>4. 산출내역서 1부.';
		html += '<br/>';
		html += '<span style="display:inline-block;width:40px;"></span>5. 업체별 견적서 1부.';
		html += '<br/>';
		html += '<span style="display:inline-block;width:40px;"></span>6. 업체증빙자료 1부.  끝.';
		html += '<br/>';
		html += '<br/>';
		html += '</div>';
	}
	makeContentsStrSave(html);
	return html;
}

function makeContentsStrSave(contentsStr){
	var saveObj = {purcContId : purcContId, contentsStr : contentsStr};
	var opt = {
    		url : _g_contextPath_ + "/Ac/G20/Ex/updatePurcContContent.do",
    		stateFn : abdocu.state,
            async: false,
            data : saveObj,
            successFn : function(data){
            	
            }
            ,
            failFn : function (request,status,error) {
    	    	alert(NeosUtil.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요")+".\n errorCode :"+request.responseText+"\n");
        	}
    };
	acUtil.ajax.call(opt);
}

function fnTradeInfoSave(id){
	purcReq.purcReqInfoSave();
	if(id == "txt_TR_NM_cont"){
		var trNm = $("#txt_TR_NM_cont").val();
		var trCd = $("#txt_TR_NM_cont").attr("code");
		var regNb = $("#txt_REG_NB_cont").val();
		var ceoNm = $("#txt_CEO_NM_cont").val();
		
		$("#erpTradeInfo-table .txt_TR_NM").val(trNm);
		$("#erpTradeInfo-table .txt_TR_NM").attr("code", trCd);
		$("#erpTradeInfo-table .txt_REG_NB").val(regNb);
		$("#erpTradeInfo-table .txt_CEO_NM").val(ceoNm);
		
		$.ajax({
	        type: "POST"
		    , dataType: "json"
		    , url: getContextPath()+ "/Ac/G20/Ex/updateContTrInfo.do"
	        , data: {
	        	trNm : trNm,
	        	trCd : trCd,
	        	regNb : regNb,
	        	ceoNm : ceoNm,
	        	purcContId : purcContId
	        }
	        , async: false
		    , success: function (obj) {
		        
		    }
	    });
	}else if(id == "txt_TR_NM_add"){
		var trNm = $("#txt_TR_NM_add").val();
		var trCd = $("#txt_TR_NM_add").attr("code");
		if($("#addTr" + trCd).length == 0){
			$.ajax({
		        type: "POST"
			    , dataType: "json"
			    , url: getContextPath()+ "/Ac/G20/Ex/insertAddTr.do"
		        , data: {
		        	trNm : trNm,
		        	trCd : trCd,
		        	purcContId : purcContId
		        }
		        , async: false
			    , success: function (obj) {
			    	var span = $('#addTradeTdSample span').clone();
			    	$(".trNmTxt", span).html(trNm);
			    	$(".trCd", span).val(trCd);
			    	$(".trNm", span).val(trNm);
		    		$("#txt_TR_NM_add_span").append(span);
			    }
		    });
		}
		
	}
}

function fnTrDelete(obj){
	if(confirm("거래처를 삭제하시겠습니까?")){
		var span = $(obj).closest("span");
		$.ajax({
			type: "POST"
			, dataType: "json"
			, url: getContextPath()+ "/Ac/G20/Ex/deleteAddTr.do"
			, data: {
				trCd : $(".trCd", span).val(),
				purcContId : purcContId
			}
			, async: false
			, success: function (obj) {
				span.remove();
			}
		});
	}
}
/*구매의뢰서 끝*/