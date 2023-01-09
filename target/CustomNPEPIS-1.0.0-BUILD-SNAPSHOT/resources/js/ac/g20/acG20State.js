var acG20State = {};
acG20State.ProjectInfo = {}; /* 프로젝트 정보 */
acG20State.BudgetInfo = {}; /* 예산 정보*/

//var gwOption = {};
var erpOption = {};
var abdocuInfo = {};

//작성 기초데이터를  가져온다.
acG20State.fnStateInit = function(){
    var tblParam = {};
    /*ajax 호출할 파라미터*/
    modal_bg(true);
    $.ajax
    ({
        type: "POST"
	    , dataType: "json"
	    , url: getContextPath()+ "/Ac/G20/State/AcStateInit.do"
        , data: tblParam
        , async: false
        , global: false
	    , success: function (res) {
	        // 성공
	    	if (res.resultValue =="empty") {
	        	alert(NeosUtil.getMessage("TX000017813", "ERP사원정보가 없습니다. 관리자에게 문의 바랍니다"));
	        }else if (res.resultValue =="notExist") {
	        	alert(NeosUtil.getMessage("TX000017814", "ERP사원정보가 올바르지 않습니다. 관리자에게 문의 바랍니다"));
	        }else{
				if(res.erpConfig){
	        		fnSetErpConfig(res.erpConfig);
	        	}
	        	if(res){
	        		fnSetInit(res);
                }
	        }
	    	modal_bg(false);
	        
	    },
	    error: function (request,status,error) {
	    	alert(NeosUtil.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요")+"\n"+NeosUtil.getMessage("TX000009711","오류 메시지 : {0}").replace("{0}",error)+"\n");
	    	modal_bg(false);
    	}
    });
}

/**
 * 옵션 셋팅
 */
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
		$(".FG_TYSpan").text("부서");
	}
	// 하위사업사용여부
	if(erpOption.BottomUseYn == 1){
		$("#searchTable tr:nth-child(2) td:nth-child(2)").attr("colspan", "1");
		$("#searchTable tr:nth-child(2) th:nth-child(3)").show();
		$("#searchTable tr:nth-child(2) td:nth-child(4)").show();
	}else{
		$("#searchTable tr:nth-child(2) td:nth-child(2)").attr("colspan", "3");
		$("#searchTable tr:nth-child(2) th:nth-child(3)").hide();
		$("#searchTable tr:nth-child(2) td:nth-child(4)").hide();
	}	
}

function fnSetInit(res){	
	var sbgtLevel = res.sbgtLevel;
    var stateVO = {}; 
    if(res.stateVO){
    	stateVO = res.stateVO;
    }
    
    $("#coInfo").html(res.stateVO.CO_NM + "(" + res.stateVO.CO_CD +")");
	abdocuInfo.erp_co_cd = res.stateVO.CO_CD;
	var DIV_CD_List = {};
	if(res.div_List){
		$("#DIV_CD").kendoComboBox({
	        dataTextField: "DIV_NM",
	        dataValueField: "DIV_CD",
	        dataSource: res.div_List,
	        value: res.stateVO.DIV_CD,
	        change: function(e) {
	            var value = this.value();
//	            $("#DIV_CDS").val(value+"|");
	          }
	    });		
	}
	
	var divFgitems = [{ DISP_NM: NeosUtil.getMessage("TX000003625","관2"), ID_NO: "1" }, { DISP_NM: NeosUtil.getMessage("TX000003626","항"), ID_NO: "2" }, { DISP_NM: NeosUtil.getMessage("TX000003627","목"), ID_NO: "3" }, { DISP_NM: NeosUtil.getMessage("TX000003628","세"), ID_NO: "4" }];
	if(res.sbgtLevel && erpOption.BgtStep7UseYn == 1){
		 divFgitems = res.sbgtLevel;
    }
	$("#DIV_FG").kendoComboBox({
	    dataTextField: "DISP_NM",
	    dataValueField: "ID_NO",		
		dataSource : divFgitems,
		value:"4"
	});
	$("#CO_CD").val(res.stateVO.CO_CD);
	$("#EMP_CD").val(res.stateVO.EMP_CD);
    $("#GISU_DT").data("kendoDatePicker").value(ncCom_Date(res.stateVO.GISU_DT, '-'));
    $("#DATE_FROM").data("kendoDatePicker").value(ncCom_Date(res.stateVO.DATE_FROM, '-'));
    $("#DATE_TO").data("kendoDatePicker").value(ncCom_Date(res.stateVO.DATE_TO, '-'));
    $("#GISU").val(res.stateVO.GISU);
    $("#FR_DT").val(res.stateVO.FR_DT);
    $("#TO_DT").val(res.stateVO.TO_DT);
//    $("#DIV_CDS").val(res.stateVO.DIV_CD+"|");
//    $("#MGT_CDS").val(res.budgetVO.MGT_CDS+"|");
//    $("#BOTTOM_CDS").val(res.budgetVO.BOTTOM_CDS);
    
	
}
acG20State.init = function(){
	$(".search-Event-H").bind({
		click : function(event){

			var parentEle = $(this).parent();
			var eventEle = $(".non-requirement, .requirement", parentEle).first();

			eventEle.dblclick();
		}
	});
	
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
	
	$("#GR_FG").kendoComboBox({
	    dataTextField: "text",
	    dataValueField: "value",
	    dataSource: [
	        { text: NeosUtil.getMessage("TX000000862","전체"), value: "" },
	        { text: NeosUtil.getMessage("TX000005295","수입"), value: "1" },
	        { text: NeosUtil.getMessage("TX000003515","지출"), value: "2" }
	    ]	,
	    index: 0
	});
	

	// 집행액
	$("#OPT12").kendoComboBox({
	    dataTextField: "text",
	    dataValueField: "value",
	    dataSource: [
	        { text: NeosUtil.getMessage("TX000009204","결의집행"), value: "1" },
	        { text: NeosUtil.getMessage("TX000009203","승인집행"), value: "2" },
	        { text: NeosUtil.getMessage("TX000009202","현금집행"), value: "3" }
	    ]	,
	    index: 0		
	});

	// 집계일자
	$("#OPT13").kendoComboBox({
	    dataTextField: "text",
	    dataValueField: "value",
	    dataSource: [
	        { text: NeosUtil.getMessage("TX000009201","결의서일자"), value: "1" },
	        { text: NeosUtil.getMessage("TX000005457","승인일자"), value: "2" },
	        { text: NeosUtil.getMessage("TX000009200","입출일자"), value: "3" }
	    ]	,
	    index: 0		
	});
	
    // 예산현액
	$("#OPT14").kendoComboBox({
	    dataTextField: "text",
	    dataValueField: "value",
	    dataSource: [
	        { text: NeosUtil.getMessage("TX000003814","승인예산"), value: "1" },
	        { text: NeosUtil.getMessage("TX000009449","신청예산"), value: "2" }
	    ]	,
	    index: 0	
	});
	
    // 금액없는라인표시여부
	$("#ZEROLINE_FG").kendoComboBox({
	    dataTextField: "text",
	    dataValueField: "value",
	    dataSource: [
	        { text: NeosUtil.getMessage("TX000003801","표시"), value: "1" },
	        { text: NeosUtil.getMessage("TX000009199","감춤"), value: "2" }
	    ]	,
	    index: 1	
	});	
	
	$("#BGT_DIFF_S").kendoComboBox({
	    dataTextField: "text",
	    dataValueField: "value",
	    dataSource: [
		     	        { text: "1. "+NeosUtil.getMessage("TX000005102","당초예산"), value: "1" },
		    	        { text: "2. "+NeosUtil.getMessage("TX000005103","최종예산"), value: "2" },
		    	        { text: "3. "+NeosUtil.getMessage("TX000005104","품의결의금액"), value: "3" },
		    	        { text: "4. "+NeosUtil.getMessage("TX000005105","품의승인금액"), value: "4" },
		    	        { text: "5. "+NeosUtil.getMessage("TX000005106","집행결의금액"), value: "5" },
		    	        { text: "6. "+NeosUtil.getMessage("TX000005107","집행승인금액"), value: "6" }
	    ]	,
	    index: 1	
	});	
	
	$("#BGT_DIFF_D").kendoComboBox({
	    dataTextField: "text",
	    dataValueField: "value",
	    dataSource: [
	     	        { text: "1. "+NeosUtil.getMessage("TX000005102","당초예산"), value: "1" },
	    	        { text: "2. "+NeosUtil.getMessage("TX000005103","최종예산"), value: "2" },
	    	        { text: "3. "+NeosUtil.getMessage("TX000005104","품의결의금액"), value: "3" },
	    	        { text: "4. "+NeosUtil.getMessage("TX000005105","품의승인금액"), value: "4" },
	    	        { text: "5. "+NeosUtil.getMessage("TX000005106","집행결의금액"), value: "5" },
	    	        { text: "6. "+NeosUtil.getMessage("TX000005107","집행승인금액"), value: "6" }
	    ]	,
	    index: 6	
	});	

	
	
	//기수기준일
    $("#GISU_DT").kendoDatePicker({
    	format: "yyyy-MM-dd",
    	culture : "ko-KR",
    	change : fnSetGisuDt
    });
    
	//시작날짜
    $("#DATE_FROM").kendoDatePicker({
    	format: "yyyy-MM-dd",
        culture : "ko-KR",
        change : function() {
        	var value = this.value();
			$("#DATE_FROMS"+temp).val(eventEle.val()+ "|");
        }
    });
    
    //종료날짜
    $("#DATE_TO").kendoDatePicker({
    	format: "yyyy-MM-dd",
    	culture : "ko-KR"
    });
    
    $("#DOCU_MODE").kendoComboBox({
	    dataTextField: "text",
	    dataValueField: "value",
	    dataSource: [
	        { text: NeosUtil.getMessage("TX000000862","전체"), value: "" },
	        { text: NeosUtil.getMessage("TX000003031","품의서"), value: "0" },
	        { text: NeosUtil.getMessage("TX000002958","결의서"), value: "1" }
	    ]	,
	    index: 0
	});
    
    $("#SET_FG").kendoComboBox({
	    dataTextField: "text",
	    dataValueField: "value",
	    dataSource: [
	        { text: NeosUtil.getMessage("TX000000862","전체"), value: "" },
	        { text: NeosUtil.getMessage("TX000011181","예금"), value: "1" },
	        { text: NeosUtil.getMessage("TX000004704","현금"), value: "2" },
	        { text: NeosUtil.getMessage("TX000009192","외상"), value: "3" },
	        { text: NeosUtil.getMessage("TX000005795","카드"), value: "4" },
	    ]	,
	    index: 0
	});    
	    
    fnEventHandlerMapping();
};

/**
 * 
 * erp 회사코드 선택할수있게 select box 추가
 * */
 
//acG20State.setCompany = function(){
//	var opt = {
//			url :  _g_contextPath_ +  '/neos/erp/g20/getErpMappingInfo.do',
//			async:false,
//			data : {},
//			successFn : function(result){
//				
//				var erp_co_cd  = result.erp_co_cd;
//				
//                $("#CO_CD").kendoDropDownList({
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
//            			acG20State.resetErpInfo(data);
//                    }
//                });
//                
//                var dropdownlist = $("#CO_CD").data("kendoDropDownList");
//                dropdownlist.value(erp_co_cd);
//                
//			}
//	};	
//	acUtil.ajax.call(opt);
//};
	
// 프로젝크, 하위사업, 예산 초기화
acG20State.resetForm = function(){
	$("#DIV_CD").val("");
	$("#DIV_CDS").val("");
    $("#MGT_CD").val("");
    $("#MGT_CDS").val("");
    $("#MGT_CD_NM").val("");
    $("#BOTTOM_CD").val("");
    $("#BOTTOM_CDS").val("");
    $("#BOTTOM_NM").val("");
    $("#BGT_CD_FROM").val("");
    $("#BGT_NM_FROM").val("");
    $("#BGT_CD_TO").val("");
    $("#BGT_NM_TO").val("");
};


/** 변경된 회사코드로 erp연동 정보 리셋 **/
//acG20State.resetErpInfo = function(data){
//	var erp_co_cd = data.erp_co_cd;
//
//    var opt = {
//            url :  _g_contextPath_ + '/neos/erp/g20/changeErpInfo.do', 
//            async: false,
//            data : data,
//            successFn : function(result){
//                if(result.erp_co_cd ==erp_co_cd){
//				    fnSetGisuDt();
//					acG20State.resetForm();
////					docList.searchList();
//                    $("form#searchForm").submit();
//                }
//            } 
//    };
//    
//    acUtil.ajax.call(opt); 
//};


/** 변경된 회사코드로 erp연동 정보 리셋 **/
//acG20State.resetErpInfo2 = function(data){
//	var erp_co_cd = data.erp_co_cd;
//    var opt = {
//            url :  _g_contextPath_ + '/neos/erp/g20/changeErpInfo.do', 
//            async:true,
//            data : data,
//            successFn : function(result){
//            	$("form#searchForm").submit();
//            } 
//    };
//    
//    acUtil.ajax.call(opt); 
//};

/** 회사코드 에 따른 사업장 가져오기 **/
//acG20State.setDIV_CD = function(){


//    
//    $.ajax({
//        type:"post",
//        url: _g_contextPath_ + '/Ac/G20/Code/getErpDIVList.do',
//        datatype:"json",
//        data: {},
//        success:function(data){     
//        	
//
//            
//        },error:function(e){
//
//        }           
//    });
    
//};

/** 기준 날짜 기수, 기수시작일 , 종료일 가져오기  **/
function fnSetGisuDt(){
	
	var tblParam = {};
	tblParam.GISU_DT = $("#GISU_DT").val().replace(/-/gi,"");
	tblParam.CO_CD = $("#CO_CD").val();
	var resultData = {};
	/*ajax 호출할 파라미터*/
    var opt = {
            url     : _g_contextPath_ + "/Ac/G20/State/getErpGisuInfo.do",
            stateFn : modal,
            async   : true,
            data    : tblParam,
            successFn : function(data){
                if(data.gisuInfo){
                	if($("#GISU").val() != data.gisuInfo.GI_SU){
                		$("#GISU").val(data.gisuInfo.GI_SU);
                		$("#DATE_FROM").data("kendoDatePicker").value(ncCom_Date(data.gisuInfo.FROM_DT, '-'));
                	    $("#DATE_TO").data("kendoDatePicker").value(ncCom_Date(data.gisuInfo.TO_DT, '-'));
                    	$("#FR_DT").val(data.gisuInfo.FROM_DT);
                    	$("#TO_DT").val(data.gisuInfo.TO_DT);
                	}
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

/** fromdata **/
acG20State.getFormData = function(){
    var formData = {};
    $(".formData").each(function(){
        var name = $(this).attr("name");
        var val = $(this).val();
        formData[name] = val;
    });

    return formData;
};

/** 예산 집행 내역 조회 **/
acG20State.datailPop = function(BGT_CD){
	var formData = acG20State.getFormData();
	formData["BGT_CD"] = BGT_CD;
	var param = NeosUtil.makeParam(formData);
    var url = _g_contextPath_ + '/Ac/G20/State/AcBgtExDetailPop.do?' + param;
    var popup = window.open(url, "userSelect", 'toolbar=no, scrollbar=no, width=1198px, height=550px, resizable=no, status=no');
    popup.focus();
};

/**
 * 
 * erp 회사코드 선택할수있게 select box 추가
 * */
// 
//acG20State.setCompany2 = function(){
//	var opt = {
//			url :  _g_contextPath_ +  '/neos/erp/g20/getErpMappingInfo.do',
//			async:true,
//			data : {},
//			successFn : function(result){
//				
//				var erp_co_cd  = result.erp_co_cd;
//				
//                $("#CO_CD").kendoDropDownList({
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
//            			acG20State.resetErpInfo(data);
//                    }
//                });
//                var dropdownlist = $("#CO_CD").data("kendoDropDownList");
//                dropdownlist.value(erp_co_cd);
//			}
//	};	
//	acUtil.ajax.call(opt);
//};

//
//acG20State.setCompany3 = function(){
//	var opt = {
//			url :  _g_contextPath_ +  '/neos/erp/g20/getErpMappingInfo.do',
//			async:true,
//			data : {},
//			successFn : function(result){
//				
//				var erp_co_cd  = result.erp_co_cd;
//				
//                $("#CO_CD").kendoDropDownList({
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
//            			acG20State.resetErpInfo2(data);
//                    }
//                });
//                
//                var dropdownlist = $("#CO_CD").data("kendoDropDownList");
//                dropdownlist.value(erp_co_cd);
//			}
//	};	
//	acUtil.ajax.call(opt);
//};

function fnEventHandlerMapping(){

    /*프로젝트명*/
    $("#MGT_CD_NM, #MGT_CD").bind({
        dblclick : function(){
            var id = $(this).attr("id");
            var dblClickparamMap =
                [{
                    "id" : "MGT_CD_NM",
                    "text" : "PJT_NM",
                    "code" : ""
                },
                {
                    "id" : "MGT_CD",
                    "text" : "PJT_CD",
                    "code" : ""
                }];
            
            var tblParam = { };
            tblParam.FG_TY = erpOption.BgtMngType;
            tblParam.CO_CD = $("CO_CD").val();
            tblParam.EMP_CD = $("#EMP_CD").val() || '';
            
            acUtil.util.dialog.dialogDelegate(getErpMgtList, dblClickparamMap, null, fnMgtCdSet, tblParam);
        }
    });

    /*하위사업*/
    $("#BOTTOM_NM, #BOTTOM_CD").bind({
    	dblclick : function(){

    		if(ncCom_Empty($("#MGT_CD").val())){
    	    	alert(NeosUtil.getMessage("TX000005402","프로젝트를 선택해주세요."));
    	    	$("#MGT_NM").focus();
    	    	return;
    	    }

    		// 하위사업은 "|" 안붙임.
    	    var tblParam = {};
    	    tblParam.MGT_CD = $("#MGT_CD").val();
    	    tblParam.CO_CD = $("#CO_CD").val();
    	    
    		var dblClickparamMap =
    			[{
    				"id" : "BOTTOM_NM",
    				"text" : "BOTTOM_NM",
    				"code" : ""
    			},{
    				"id" : "BOTTOM_CD",
    				"text" : "BOTTOM_CD",
    				"code" : ""
    			},{
    				"id" : "BOTTOM_CDS",
    				"text" : "BOTTOM_CD"+"|",
    				"code" : ""
    			}];
    		
    		//fnBottomCdSet
    		acUtil.util.dialog.dialogDelegate(acG20Code.getErpAbgtBottomList, dblClickparamMap, null, null, tblParam);
    	}
    });
    
    /**
     * 예산조회
     */
    $(".BGT_CD").bind({
        dblclick : function(){
            if(ncCom_Empty($("#DIV_CD").val())) {
            	alert(NeosUtil.getMessage("TX000011151","사업장을 선택해주세요"));
            	return;
            }
            
			var id = $(this).attr("id");
            var target = $(this).attr("target");

            var tblParam = {};
            tblParam.CO_CD = $("#CO_CD").val();
            tblParam.GISU_DT = ncCom_Replace($("#GISU_DT").val(), '-','');
            tblParam.DIV_CDS = $("#DIV_CD").val() + "|";
            tblParam.MGT_CDS = $("#MGT_CDS").val();
            tblParam.BOTTOM_CDS = $("#BOTTOM_CDS").val();
            //if(BOTTOM_CDS !=""){ BOTTOM_CDS + '|';   }; 
            tblParam.OPT_01 = $(":input[name=OPT_01]:checked").val() || "2";//예산과목표시( 1, 2, 3 )
            tblParam.OPT_02 = $(":input[name=OPT_02]:checked").val() || "1";//사용기한( 1, 2 )
            tblParam.OPT_03 = "2";//상위과목표시( 1, 2 )
            tblParam.GISU = $("#GISU").val();
            tblParam.FR_DT  = $("#FR_DT").val();
            tblParam.TO_DT  = $("#TO_DT").val();         	
            tblParam.ID  = id;
            tblParam.TARGET  = target;
            tblParam.BgtStep7UseYn = erpOption.BgtStep7UseYn;

            var dblClickparamMap =
                        [{
                            "id" : "BGT_CD_" + target,
                            "text" : "BGT_CD",
                            "code" : ""
                        },{
                            "id" : "BGT_NM_" + target,
                            "text" : "BGT_NM",
                            "code" : ""
                        },{
                        	"id" : "SYS_CD_" + target,
                            "text" : "SYS_CD",
                            "code" : ""
                        }
                        ];

            acUtil.util.dialog.dialogDelegate(acG20Code.getErpBudgetList, dblClickparamMap, null, fnBgetCdSet, tblParam);
        }
    });    /*예산사업장명*/
};



function fnMgtCdSet(sel){
	var pjt_cd = sel.PJT_CD;
	$("#MGT_CDS").val(pjt_cd +"|");
    // 하위사업, 예산 초기화
    $("#BGT_CD_FROM").val("");
    $("#BGT_NM_FROM").val("");
    $("#BGT_CD_TO").val("");
    $("#BGT_NM_TO").val("");
    $("#SYS_CD_FROM").val("");
    $("#SYS_CD_TO").val("");
    $("#BOTTOM_CD").val("");
    $("#BOTTOM_CDS").val("");
    $("#BOTTOM_NM").val("");	
}

function fnBottomCdSet(sel){
//	$("#BOTTOM_CD").val(sel.BOTTOM_CD +"|");
//	$("#BOTTOM_CDS").val(sel.BOTTOM_CD +"|");
}

function fnBgetCdSet(sel, dblClickparamMap){
	
	var id = dblClickparamMap[0].id;
		
	if(id=="BGT_CD_FROM" && ( $("#SYS_CD_FROM").val() >  $("#SYS_CD_TO").val())){
		$("#SYS_CD_TO").val(sel.SYS_CD);
		$("#BGT_CD_TO").val(sel.BGT_CD);
		$("#BGT_NM_TO").val(sel.BGT_NM);
	}
	
	if(id=="BGT_CD_TO" && ( $("#SYS_CD_TO").val() <  $("#SYS_CD_FROM").val())){
		$("#SYS_CD_FROM").val(sel.SYS_CD);
		$("#BGT_CD_FROM").val(sel.BGT_CD);
		$("#BGT_NM_FROM").val(sel.BGT_NM);
	}
}

function numOnly(e){
	if (e.which && (e.which  > 47 && e.which  < 58 || e.which == 8)) {
	} else {
		e.preventDefault();
	}
}


/**
 * 
 *  예산환원 
 *  
 */
 function returnConferBudget(abdocu_b_no){
//    var eventEle = $(e);
//    var abdocu_b_no = eventEle.parents("tr").attr("abdocu_b_no");
    
    var isAllDocView = 1;
    var data = {
            abdocu_b_no : abdocu_b_no ,
            isAllDocView : isAllDocView
        };
    if(confirm(NeosUtil.getMessage("TX000011196","예산환원 하시겠습니까?"))){
        var opt = {
                url : _g_contextPath_ + "/neos/erp/g20/returnConferBudget.do",
                stateFn:modal_bg,
                async:true,
                data : data,
                successFn : function(result){
                    if(result && result.result =="OK"){
                    	docList.searchList();
                    }               
                }
        };
        
        acUtil.ajax.call(opt);
    }
    
};

/**
 * 
 *  예산환원 취소 
 *  
 */
function returnConferBudgetRollBack(abdocu_b_no){
//    var eventEle = $(e);
//    var abdocu_b_no = eventEle.parents("tr").attr("abdocu_b_no");
    
    var data = {
            abdocu_b_no : abdocu_b_no
        };
    if(confirm(NeosUtil.getMessage("TX000011195","예산환원취소 하시겠습니까?"))){
    var opt = {
            url : _g_contextPath_ + "/neos/erp/g20/returnConferBudgetRollBack.do",
            stateFn:modal_bg,
            async:true,
            data : data,
            successFn : function(result){
                if(result && result.result =="OK"){
                	docList.searchList();
                }
            }
    };
    
    acUtil.ajax.call(opt);
    }
};