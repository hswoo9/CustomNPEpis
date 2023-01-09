/**
 *
 * 소액구매용 js 파일
 *
 */

/**
 * 구매의뢰 데이터 입력
 */
purcReq.setPurcReq = function(purcReqInfo){
	consDocSeq = purcReqInfo.consDocSeq;
	$('#purcReqId').val(purcReqInfo.purcReqId);
	$('#purcReqTitle').val(purcReqInfo.purcReqTitle);
	$("#purcReqDate").data("kendoDatePicker").value(ncCom_Date(purcReqInfo.purcReqDate, '-'));
	$('#term').val(purcReqInfo.term);
	$('#purcPurpose').val(purcReqInfo.purcPurpose);
	$('#txt_TR_NM').val(purcReqInfo.trNm).attr('code', purcReqInfo.trCd);
	
	/*소액구매 파라미터 추가*/
	if(purcReqInfo.payConCodeId){
		if($("#payCon").data("kendoComboBox")){
			$("#payCon").data("kendoComboBox").value(purcReqInfo.payConCodeId);
		}else{
			$("#payCon").val(purcReqInfo.payCon).attr('code', purcReqInfo.payConCodeId);
		}
	}
	if(purcReqInfo.payTypeCodeId){
		if($("#payType").data("kendoComboBox")){
			$("#payType").data("kendoComboBox").value(purcReqInfo.payTypeCodeId);
		}else{
			$("#payType").val(purcReqInfo.payType).attr('code', purcReqInfo.payTypeCodeId);
		}
	}
	$('#payCnt').val(purcReqInfo.payCnt);
	if(purcReqInfo.contAm){
		$('#contAm').val(purcReqInfo.contAm.toString().toMoney());
	}
	if(purcReqInfo.contTypeCodeId){
		if($("#contType").data("kendoComboBox")){
			$("#contType").data("kendoComboBox").value(purcReqInfo.contTypeCodeId);
		}else{
			$("#contType").val(purcReqInfo.contType).attr('code', purcReqInfo.contTypeCodeId);
		}
	}
	$("#contDate").val(ncCom_Date(purcReqInfo.contDate, '-'));
	$('#txt_REG_NB').val(purcReqInfo.regNb);
	$('#txt_CEO_NM').val(purcReqInfo.ceoNm);
	if(purcReqInfo.basicAm){
		$('#basicAm').val(purcReqInfo.basicAm.toString().toMoney());
	}
	$('#rate').val(purcReqInfo.rate);
	/*소액구매 파라미터 추가*/
	if(purcReqType == "3" || purcReqType == "4"){
		$('#txt_ITEM_NM').val(purcReqInfo.purcReqTitle);
		$('#contents').val(purcReqInfo.purcPurpose);
	}
};

/**
 * 구매의뢰 데이터 저장
 */
purcReq.purcReqInfoSave = function(){
	var saveObj = {};
	/*구매의뢰서 파라미터 추가*/
	saveObj.regDate = $('#txtGisuDate').val();
    saveObj.purcReqType = $('#purcReqType').val();
    saveObj.purcReqTypeCodeId = $('#purcReqType').attr('CODE');
    saveObj.purcReqNo = $('#purcReqNo').val();
    saveObj.purcReqId = $('#purcReqId').val();
    saveObj.purcReqTitle = $('#purcReqTitle').val();
    saveObj.purcReqDate = $('#purcReqDate').val();
    saveObj.term = $('#term').val();
    saveObj.purcPurpose = $('#purcPurpose').val();
    saveObj.trNm = $('#txt_TR_NM').val();
    saveObj.trCd = $('#txt_TR_NM').attr('CODE');
    saveObj.formId = template_key;
    /*구매의뢰서 파라미터 추가*/
    
    /*소액구매 파라미터 추가*/
	saveObj.payCon = $('#payCon').data('kendoComboBox').text();
	saveObj.payConCodeId = $('#payCon').val();
	saveObj.payType = $('#payType').data('kendoComboBox').text();
	saveObj.payTypeCodeId = $('#payType').val();
	saveObj.payCnt = $('#payCnt').val();
	saveObj.contType = $('#contType').data('kendoComboBox').text();
	saveObj.contTypeCodeId = $('#contType').val();
	saveObj.contAm = $('#contAm').val().toString().toMoney2();
	saveObj.contDate = $('#contDate').val();
	saveObj.regNb = $('#txt_REG_NB').val();
	saveObj.ceoNm = $('#txt_CEO_NM').val();
	saveObj.basicAm = $('#basicAm').val().toString().toMoney2();
	saveObj.rate = $('#rate').val();
	/*소액구매 파라미터 추가*/
    
	var resultData = {};
	/*ajax 호출할 파라미터*/
    var opt = {
    		url : _g_contextPath_ + "/Ac/G20/Ex/setPurcReqH.do",
    		stateFn : abdocu.state,
            async: false,
            data : saveObj,
            successFn : function(data){
            	if(data){
                	var purcReqId = data.purcReqId?data.purcReqId : "0";
                	var purcReqHId = data.purcReqHId?data.purcReqHId : "0";
                	$('#purcReqId').val(purcReqId);
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
/*구매의뢰서 끝*/

abdocu.ProjectInfo.RowSave_Process = function(tr){

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
	
	/*G20 2.0 키 추가*/
	saveObj.consDocSeq = consDocSeq;
	
	/*구매의뢰서 파라미터 추가*/
	saveObj.regDate = $('#txtGisuDate').val();
    saveObj.purcReqType = $('#purcReqType').val();
    saveObj.purcReqTypeCodeId = $('#purcReqType').attr('CODE');
    saveObj.purcReqNo = $('#purcReqNo').val();
    saveObj.purcReqId = $('#purcReqId').val();
    saveObj.purcReqTitle = $('#purcReqTitle').val();
    saveObj.purcReqDate = $('#purcReqDate').val();
    saveObj.term = $('#term').val();
    saveObj.purcPurpose = $('#purcPurpose').val();
    saveObj.trNm = $('#txt_TR_NM').val();
    saveObj.trCd = $('#txt_TR_NM').attr('CODE');
    saveObj.formId = template_key;
    /*구매의뢰서 파라미터 추가*/
	
//	saveObj.abdocu_no       = abdocuInfo.abdocu_no;
	saveObj.abdocu_no       = tr.attr('id') || '0';
	saveObj.docu_mode       = abdocuInfo.docu_mode;
	saveObj.docu_fg         = abdocuInfo.docu_fg;
	saveObj.docu_fg_text    = abdocuInfo.docu_fg_text;
    saveObj.erp_co_cd       = abdocuInfo.erp_co_cd;
    saveObj.erp_co_nm       = abdocuInfo.erp_co_nm;
    saveObj.erp_dept_cd     = $("#txtDEPT_NM").attr("CODE");
    saveObj.erp_dept_nm     = $("#txtDEPT_NM").val();
    saveObj.erp_emp_cd      = $("#txtKOR_NM").attr("CODE");
    saveObj.erp_emp_nm      = $("#txtKOR_NM").val();
    saveObj.erp_div_cd      = $(".txtDIV_NM", tr).attr("CODE");
    saveObj.erp_div_nm      = $(".txtDIV_NM", tr).val();
    saveObj.mgt_cd          = $(".txt_ProjectName", tr).attr("CODE");
	saveObj.mgt_nm_encoding = $(".txt_ProjectName", tr).val();
	saveObj.bottom_nm       = $(".txtBottom_cd", tr).val() || "";
	saveObj.bottom_cd       = $(".txtBottom_cd", tr).attr("CODE") || "";
	saveObj.rmk_dc          = $(".txt_Memo", tr).val();
	
    saveObj.erp_gisu_dt     = erp_gisu_dt;
    if(erp_acisu_dt){
    	saveObj.erp_acisu_dt     = erp_acisu_dt;
    }
    saveObj.erp_gisu_from_dt= "";
    saveObj.erp_gisu_to_dt  = "";
    saveObj.erp_gisu        = "0";
    saveObj.erp_year        = erp_year;
    saveObj.it_businessLink = $(".txt_IT_BUSINESSLINK", tr).val();
    
    /*소액구매 파라미터 추가*/
	saveObj.payCon = $('#payCon').data('kendoComboBox').text();
	saveObj.payConCodeId = $('#payCon').val();
	saveObj.payType = $('#payType').data('kendoComboBox').text();
	saveObj.payTypeCodeId = $('#payType').val();
	saveObj.payCnt = $('#payCnt').val();
	saveObj.contType = $('#contType').data('kendoComboBox').text();
	saveObj.contTypeCodeId = $('#contType').val();
	saveObj.contAm = $('#contAm').val().toString().toMoney2();
	saveObj.contDate = $('#contDate').val();
	saveObj.regNb = $('#txt_REG_NB').val();
	saveObj.ceoNm = $('#txt_CEO_NM').val();
	saveObj.basicAm = $('#basicAm').val().toString().toMoney2();
	saveObj.rate = $('#rate').val();
	/*소액구매 파라미터 추가*/
    
	var resultData = {};
	/*ajax 호출할 파라미터*/
    var opt = {
    		url : _g_contextPath_ + "/Ac/G20/Ex/setPurcReqH.do",						// 구매의뢰서 저장
    		stateFn : abdocu.state,
            async: true,
            data : saveObj,
            successFn : function(data){
            	
            	if(data){
                	var abdocu_no = data.result?data.result : "0";
                	var purcReqId = data.purcReqId?data.purcReqId : "0";
                	var purcReqHId = data.purcReqHId?data.purcReqHId : "0";
            		var obj = acUtil.util.getParamObj();
            		obj["abdocu_no"] = abdocu_no;
            		obj["purcReqId"] = purcReqId;
            		obj["purcReqHId"] = purcReqHId;
            		obj["focus"] = "txt_BUDGET_LIST";
            		obj["template_key"] = template_key;
					consDocSeq = data.consDocSeq?data.consDocSeq : "0";
            		obj["consDocSeq"] = consDocSeq;
            		saveOnnaraMapping();
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

abdocu.approvalOpen = function(){
	var contAm = parseInt($("#contAm").val().toString().toMoney2());
	var capAm = parseInt(fnTpfGetCommCodeList("PURC_SMALL_PAYMENT").filter(function(obj){return obj.code == "CAP";})[0].code_val.toString().toMoney2());
	if(capAm <= contAm){
		alert('소액구매는 ' + capAm.toString().toMoney() + "원을 초과 할 수 없습니다.");
		return false;
	}
	if(!$('#purcReqTitle').val()){
		alert('계약명을 입력하세요.');
		return false;
	}
	if(!$('#purcReqDate').val() && (!$('#term').val() || $('#term').val() == '0')){
//	if(!$('#purcReqDate').val()){
		alert('사업기간을 입력하세요.');
		return false;
	}
	if(!$('#txt_TR_NM').val()){
		alert('거래처를 선택하세요.');
		return false;
	}
	/*if(!$('#txt_REG_NB').val()){
		alert('거래처를 선택하세요.');
		return false;
	}
	if(!$('#txt_CEO_NM').val()){
		alert('거래처를 선택하세요.');
		return false;
	}*/
	if(!$('#txt_TR_NM').attr("code")){
		alert('거래처를 선택하세요.');
		return false;
	}
	if($('#fileArea1 span').length < 1){
		alert('필수첨부파일을 등록하세요.')
		return false;
	}
	var obj = abdocu.approvalValidation();
	if(!obj.isSuccess){
		alert(obj.msg);  
		return false; 
	}
	
	/* G20 2.0 수정 start 20200323*/
	var budgetList = [];
	
	var table = $("#erpProjectInfo-table");
	var tr = $("tbody tr", table);
	$.each(tr, function(){
		var resultData = {};
		var data = { abdocu_no : $(this).attr("id")};
		var opt = {
				url : _g_contextPath_ + "/Ac/G20/Ex/getPurcReqB.do",            
				stateFn:abdocu.state,
				async:false,
				data : data,
				successFn : function(data){
				},
				error: function (request,status,error) {
					alert(NeosUtil.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요")+".\n errorCode :"+request.responseText+"\n");
				}
		}; 
		acUtil.ajax.call(opt, resultData);
		budgetList = budgetList.concat(resultData.selectList);
	});
	
	var overBudget = [];
	var validationResult =  '';
	
	$.each(budgetList, function(){
		var data = {
			  abdocu_no : this.abdocu_no
			, abdocu_b_no : this.abdocu_b_no
			, abdocu_no_reffer : this.abdocu_no_reffer
			, docu_mode : docu_mode 
			, abgt_cd : this.abgt_cd
			, abdocu_b_no_reffer : this.abdocu_b_no_reffer
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
	            		/* 구매의뢰서 내년예산 반영 */
	            		validationResult = 'BGT';
	            	}else if(data.trCnt < 1){
	            		validationResult = 'TR';
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
		            		validationResult = '';
		            	}
	            	}
	            }
	    };	
	    /*결과 데이터 담을 객체*/
		acUtil.resultData = {};
		/*한글기안으로 안넘어가게 주석처리*/
	    acUtil.ajax.call(opt, acUtil.resultData );
	});
	/* G20 2.0 수정 end 20200323*/
	
	if(validationResult == 'NaN'){
		alert('금액 검증도중 오류가 발생하였습니다.');
		return;
	}if(validationResult == 'CONFER'){
		alert('품의액을 초과 하였습니다. 확인해주세요.');
		return;
	}else if(validationResult == 'BGT'){
		alert(NeosUtil.getMessage("TX000011163","예산을 초과 하였습니다. 확인해주세요."));
		return;
	}else if(validationResult == 'TR'){
		alert('거래처 정보를 입력해주세요');
		return;
	}
	
	$("." + abdocu.overBudget).removeClass(abdocu.overBudget);
	for ( var i = 0, max = overBudget.length; i < max; i++) {
		$("#" + overBudget[i] + " .totalAM", table).parents("td").addClass(abdocu.overBudget);
	}
	
	// 구매의뢰번호 생성
	var data = {purcReqId : $('#purcReqId').val()};
	var opt = {
    		url : _g_contextPath_ + "/Ac/G20/Ex/makePurcReqNo.do",
    		stateFn:abdocu.state,
    		async:false,
    		data : data,
    		successFn : function(result){
    			approvalOpen(result);
    		}
	};
	acUtil.ajax.call(opt, null);
};

function makeContentsStrS(contentsStr, result){
	if(purcReqType == "1"){
		contentsStr = makeContentsStrS1(contentsStr, result);
	}else if(purcReqType == "3"){
		contentsStr = makeContentsStrS2(contentsStr, result);
	}else if(purcReqType == "4"){
		contentsStr = makeContentsStrS2(contentsStr, result);
	}
	return contentsStr;
}

/**
 * 문서본문 생성
 */
function makeContentsStrS1(contentsStr, result){
	var purcReqInfo = result.purcReqInfo;
	var purcReqHBList = result.purcReqHBList;
	var purcReqTList2 = result.purcReqTList2;
	var contentsStr = "";
	contentsStr += "<TABLE border='1' cellspacing='0' cellpadding='0' style='border-collapse:collapse;border:none;'>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='3' valign='middle' width='92' height='37' style='border-left:solid #000000 1.1pt;border-right:none;border-top:solid #000000 1.1pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:15.0pt;letter-spacing:5%;font-weight:bold;line-height:160%'>&nbsp;건 명 :</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='20' valign='middle' width='619' height='37' style='border-left:none;border-right:solid #000000 1.1pt;border-top:solid #000000 1.1pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:13.0pt;letter-spacing:-5%;font-weight:bold;line-height:160%'>" + purcReqInfo.purcReqTitle + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD valign='middle' width='49' height='52' style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='letter-spacing:5%'>장</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='3' valign='middle' width='56' height='52' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='font-size:9.0pt;letter-spacing:5%;line-height:100%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD valign='middle' width='45' height='52' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='letter-spacing:5%'>관</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='2' valign='middle' width='64' height='52' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='font-size:9.0pt;letter-spacing:5%;line-height:100%'>" + purcReqHBList[0].erp_bgt_nm1 + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='2' valign='middle' width='57' height='52' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='letter-spacing:5%'>세항</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='5' valign='middle' width='98' height='52' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='font-size:9.0pt;letter-spacing:-6%;line-height:100%'>" + purcReqHBList[0].erp_bgt_nm2 + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='3' valign='middle' width='62' height='52' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='line-height:100%;'><SPAN STYLE='letter-spacing:5%'>세세항</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='2' valign='middle' width='98' height='52' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='font-size:9.0pt;line-height:100%'>" + purcReqHBList[0].erp_bgt_nm3 + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD valign='middle' width='69' height='52' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='letter-spacing:5%'>목</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='3' valign='middle' width='113' height='52' style='border-left:solid #000000 0.4pt;border-right:solid #000000 1.1pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='font-size:9.0pt;line-height:100%'>" + purcReqHBList[0].erp_bgt_nm4 + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='6' valign='middle' width='162' height='31' style='border-left:solid #000000 1.1pt;border-right:none;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='letter-spacing:5%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='2' valign='middle' width='55' height='31' style='border-left:none;border-right:none;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='letter-spacing:5%;font-weight:bold'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='6' valign='middle' width='152' height='31' style='border-left:none;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='letter-spacing:5%;font-weight:bold'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD rowspan='2' colspan='5' valign='middle' width='159' height='48' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='letter-spacing:5%'>물품관리관</SPAN></P>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='font-size:12.0pt;letter-spacing:5%;line-height:100%'>(분임물품관리관)</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD rowspan='2' colspan='4' valign='middle' width='182' height='48' style='border-left:solid #000000 0.4pt;border-right:solid #000000 1.1pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='letter-spacing:5%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD rowspan='2' colspan='6' valign='middle' width='162' height='31' style='border-left:solid #000000 1.1pt;border-right:none;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='letter-spacing:5%'>아래와 같이</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD rowspan='2' colspan='2' valign='middle' width='55' height='31' style='border-left:none;border-right:none;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='letter-spacing:5%'>매입</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD rowspan='2' colspan='6' valign='middle' width='152' height='31' style='border-left:none;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='letter-spacing:5%'>코자 합니다.</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD rowspan='2' colspan='5' valign='middle' width='159' height='45' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='letter-spacing:5%'>물품출납원</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD rowspan='2' colspan='4' valign='middle' width='182' height='45' style='border-left:solid #000000 0.4pt;border-right:solid #000000 1.1pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='letter-spacing:5%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='6' valign='middle' width='162' height='31' style='border-left:solid #000000 1.1pt;border-right:none;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='letter-spacing:5%;font-weight:bold'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='2' valign='middle' width='55' height='31' style='border-left:none;border-right:none;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='letter-spacing:5%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='6' valign='middle' width='152' height='31' style='border-left:none;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='letter-spacing:5%;font-weight:bold'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='23' valign='middle' width='711' height='34' style='border-left:solid #000000 1.1pt;border-right:solid #000000 1.1pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='letter-spacing:5%'>물품(매입, 수리, 제조)명세</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='2' valign='middle' width='59' height='41' style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='font-size:9.0pt;letter-spacing:-11%;line-height:100%'>물품분류</SPAN></P>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='font-size:9.0pt;letter-spacing:-11%;line-height:100%'>번　　호</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='5' valign='middle' width='155' height='41' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='letter-spacing:-11%'>품&nbsp;&nbsp; 명</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='4' valign='middle' width='88' height='41' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='letter-spacing:-11%'>규&nbsp; 격</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='2' valign='middle' width='63' height='41' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='letter-spacing:-11%'>단위</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='3' valign='middle' width='51' height='41' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='letter-spacing:5%'>수량</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='2' valign='middle' width='101' height='41' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='letter-spacing:5%'>단 가</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='3' valign='middle' width='106' height='41' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='letter-spacing:5%'>소요경비</SPAN></P>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='letter-spacing:5%'>추 정 액</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='2' valign='middle' width='88' height='41' style='border-left:solid #000000 0.4pt;border-right:solid #000000 1.1pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='letter-spacing:5%'>용&nbsp; 도</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	// 품목 시작
	var totalAm = 0;
	$.each(purcReqTList2, function(){
		contentsStr += "<TR>";
		contentsStr += "	<TD colspan='2' valign='middle' width='59' height='23' style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
		contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:12.0pt;line-height:160%'></SPAN></P>";
		contentsStr += "	</TD>";
		contentsStr += "	<TD colspan='5' valign='middle' width='155' height='23' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
		contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:12.0pt;line-height:160%'>" + this.itemNm + "</SPAN></P>";
		contentsStr += "	</TD>";
		contentsStr += "	<TD colspan='4' valign='middle' width='88' height='23' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
		contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:12.0pt;line-height:160%'>" + this.standard + "</SPAN></P>";
		contentsStr += "	</TD>";
		contentsStr += "	<TD colspan='2' valign='middle' width='63' height='23' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
		contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:12.0pt;line-height:160%'></SPAN></P>";
		contentsStr += "	</TD>";
		contentsStr += "	<TD colspan='3' valign='middle' width='51' height='23' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
		contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:12.0pt;line-height:160%'>" + parseInt(this.itemCnt.toMoney2()) + "</SPAN></P>";
		contentsStr += "	</TD>";
		contentsStr += "	<TD colspan='2' valign='middle' width='101' height='23' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
		contentsStr += "	<P CLASS=HStyle0 STYLE='margin-right:3.8pt;text-align:right;'><SPAN STYLE='font-size:12.0pt;line-height:160%'>" + this.itemAm2.toString().toMoney() + "</SPAN></P>";
		contentsStr += "	</TD>";
		contentsStr += "	<TD colspan='3' valign='middle' width='106' height='23' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
		contentsStr += "	<P CLASS=HStyle0 STYLE='margin-right:3.8pt;text-align:right;'><SPAN STYLE='font-size:12.0pt;line-height:160%'>" + this.unitAm.toString().toMoney() + "</SPAN></P>";
		contentsStr += "	</TD>";
		contentsStr += "	<TD colspan='2' valign='middle' width='88' height='23' style='border-left:solid #000000 0.4pt;border-right:solid #000000 1.1pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
		contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:130%;'><SPAN STYLE='font-size:12.0pt;line-height:130%'>" + this.rmkDc + "</SPAN></P>";
		contentsStr += "	</TD>";
		contentsStr += "</TR>";
		totalAm += this.unitAm;
	});
	for(var i = purcReqTList2.length; i < 9; i++){
		contentsStr += "<TR>";
		contentsStr += "	<TD colspan='2' valign='middle' width='59' height='23' style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
		contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:12.0pt;line-height:160%'>&nbsp;</SPAN></P>";
		contentsStr += "	</TD>";
		contentsStr += "	<TD colspan='5' valign='middle' width='155' height='23' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
		contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:12.0pt;line-height:160%'>&nbsp;</SPAN></P>";
		contentsStr += "	</TD>";
		contentsStr += "	<TD colspan='4' valign='middle' width='88' height='23' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
		contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:12.0pt;line-height:160%'>&nbsp;</SPAN></P>";
		contentsStr += "	</TD>";
		contentsStr += "	<TD colspan='2' valign='middle' width='63' height='23' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
		contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:12.0pt;line-height:160%'>&nbsp;</SPAN></P>";
		contentsStr += "	</TD>";
		contentsStr += "	<TD colspan='3' valign='middle' width='51' height='23' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
		contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:12.0pt;line-height:160%'>&nbsp;</SPAN></P>";
		contentsStr += "	</TD>";
		contentsStr += "	<TD colspan='2' valign='middle' width='101' height='23' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
		contentsStr += "	<P CLASS=HStyle0 STYLE='margin-right:3.8pt;text-align:right;'><SPAN STYLE='font-size:12.0pt;line-height:160%'>&nbsp;</SPAN></P>";
		contentsStr += "	</TD>";
		contentsStr += "	<TD colspan='3' valign='middle' width='106' height='23' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
		contentsStr += "	<P CLASS=HStyle0 STYLE='margin-right:3.8pt;text-align:right;'><SPAN STYLE='font-size:12.0pt;line-height:160%'>&nbsp;</SPAN></P>";
		contentsStr += "	</TD>";
		contentsStr += "	<TD colspan='2' valign='middle' width='88' height='23' style='border-left:solid #000000 0.4pt;border-right:solid #000000 1.1pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
		contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:130%;'><SPAN STYLE='font-size:12.0pt;line-height:130%'>&nbsp;</SPAN></P>";
		contentsStr += "	</TD>";
		contentsStr += "</TR>";
	}
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='2' valign='middle' width='59' height='23' style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:12.0pt;line-height:160%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='5' valign='middle' width='155' height='23' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:12.0pt;line-height:160%'>계</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='4' valign='middle' width='88' height='23' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:12.0pt;line-height:160%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='2' valign='middle' width='63' height='23' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:12.0pt;line-height:160%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='3' valign='middle' width='51' height='23' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:12.0pt;line-height:160%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='2' valign='middle' width='101' height='23' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:12.0pt;line-height:160%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='3' valign='middle' width='106' height='23' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:12.0pt;line-height:160%'>" + totalAm.toString().toMoney() + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='2' valign='middle' width='88' height='23' style='border-left:solid #000000 0.4pt;border-right:solid #000000 1.1pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:12.0pt;line-height:160%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	// 품목 끝
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='23' valign='middle' width='711' height='22' style='border-left:solid #000000 1.1pt;border-right:solid #000000 1.1pt;border-top:solid #000000 0.4pt;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='letter-spacing:5%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='12' valign='middle' width='342' height='22' style='border-left:solid #000000 1.1pt;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='letter-spacing:5%'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='5' valign='middle' width='89' height='22' style='border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='letter-spacing:5%;font-weight:bold'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='6' valign='middle' width='280' height='22' style='border-left:none;border-right:solid #000000 1.1pt;border-top:none;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='letter-spacing:5%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='10' valign='middle' width='294' height='30' style='border-left:solid #000000 1.1pt;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:right;'><SPAN STYLE='letter-spacing:5%'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;위 물품을 </SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD valign='middle' width='8' height='30' style='border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:right;'>&nbsp;</P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='4' valign='middle' width='75' height='30' style='border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:right;'><SPAN STYLE='letter-spacing:5%'>매입</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='8' valign='middle' width='334' height='30' style='border-left:none;border-right:solid #000000 1.1pt;border-top:none;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:left;'><SPAN STYLE='letter-spacing:5%'>하여 주시기 바랍니다.</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='23' valign='middle' width='711' height='26' style='border-left:solid #000000 1.1pt;border-right:solid #000000 1.1pt;border-top:none;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
//	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='letter-spacing:5%'>(" + moment().format("YYYY. MM. DD.") + ")</SPAN></P>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='letter-spacing:5%'></SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='23' valign='middle' width='711' height='22' style='border-left:solid #000000 1.1pt;border-right:solid #000000 1.1pt;border-top:none;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='letter-spacing:5%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='23' valign='middle' width='711' height='22' style='border-left:solid #000000 1.1pt;border-right:solid #000000 1.1pt;border-top:none;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='letter-spacing:5%'>" + $("#txtDEPT_NM").val() + "장</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='22' valign='middle' width='695' height='22' style='border-left:solid #000000 1.1pt;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='letter-spacing:5%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD valign='middle' width='16' height='22' style='border-left:none;border-right:solid #000000 1.1pt;border-top:none;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='letter-spacing:5%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='23' valign='middle' width='711' height='37' style='border-left:solid #000000 1.1pt;border-right:solid #000000 1.1pt;border-top:none;border-bottom:solid #000000 1.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='letter-spacing:5%'>&nbsp;물품관리관 귀하</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "</TABLE>";
	return contentsStr;
}

/**
 * 문서본문 생성
 */
function makeContentsStrS2(contentsStr, result){
	var purcReqInfo = result.purcReqInfo;
	var purcReqHBList = result.purcReqHBList;
	var purcReqTList2 = result.purcReqTList1;
	var contentsStr = "";
	contentsStr += "<TABLE border='1' cellspacing='0' cellpadding='0' style='border-collapse:collapse;border:none;'>";
	contentsStr += "<TR>";
	contentsStr += "	<TD valign='top' width='27' height='27' style='border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:12.0pt;font-family:'굴림체';line-height:160%'>가.</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD valign='top' width='89' height='27' style='border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:12.0pt;font-family:'굴림체';line-height:160%'>건&nbsp;&nbsp;&nbsp; 명 :</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD valign='top' width='520' height='27' style='border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle16 STYLE='line-height:180%;'><SPAN STYLE='font-size:12.0pt;font-family:'굴림체';line-height:180%'>" + purcReqInfo.purcReqTitle + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD valign='top' width='27' height='27' style='border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:12.0pt;font-family:'굴림체';line-height:160%'>나.</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD valign='top' width='89' height='27' style='border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:12.0pt;font-family:'굴림체';line-height:160%'>일&nbsp;&nbsp;&nbsp; 시 :</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD valign='top' width='520' height='27' style='border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle16 STYLE='line-height:180%;'><SPAN STYLE='font-size:12.0pt;font-family:'굴림체';line-height:180%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD valign='top' width='27' height='27' style='border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:12.0pt;font-family:'굴림체';line-height:160%'>다.</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD valign='top' width='89' height='27' style='border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:12.0pt;font-family:'굴림체';line-height:160%'>소요금액 :</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD valign='top' width='520' height='27' style='border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle16 STYLE='line-height:120%;'><SPAN STYLE='font-size:12.0pt;font-family:'굴림';line-height:120%'>금" + purcReqInfo.contAm.toString().toMoney()+ "원";
	contentsStr += "(금" + numToKOR(purcReqInfo.contAm.toString()) + "원)</SPAN></P>";
	contentsStr += "	</P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD valign='top' width='27' height='27' style='border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:12.0pt;font-family:'굴림체';line-height:160%'>라.</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD valign='top' width='89' height='27' style='border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:12.0pt;font-family:'굴림체';line-height:160%'>예산과목 :</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD valign='top' width='520' height='27' style='border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	if(purcReqHBList.length == 1){
		$.each(purcReqHBList, function(inx){
			contentsStr += '	<P CLASS=HStyle0><SPAN STYLE="font-size:12.0pt;font-family:"굴림체";line-height:160%">';
			contentsStr += this.erp_bgt_nm1 + ", ";
			contentsStr += this.erp_bgt_nm2 + ", ";
			contentsStr += this.erp_bgt_nm3 + ", ";
			contentsStr += this.erp_bgt_nm4;
			contentsStr += '	</SPAN></P>';
		});
		contentsStr += "	</TD>";
		contentsStr += "</TR>";
	}else{
		contentsStr += "<TR>";
		contentsStr += "	<TD colspan='3' valign='top' width='27' height='27' style='border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
		$.each(purcReqHBList, function(inx){
			contentsStr += '	<P CLASS=HStyle0><SPAN STYLE="font-size:12.0pt;font-family:"굴림체";line-height:160%"> ';
			contentsStr += (inx + 1) + ") ";
			contentsStr += this.erp_bgt_nm1 + ", ";
			contentsStr += this.erp_bgt_nm2 + ", ";
			contentsStr += this.erp_bgt_nm3 + ", ";
			contentsStr += this.erp_bgt_nm4;
			contentsStr += '	</SPAN></P>';
		});
		contentsStr += "	</TD>";
		contentsStr += "</TR>";
	}
	contentsStr += "</TABLE>";
	return contentsStr;
}

/**
 * 공통코드리스트 조회
 */
function fnTpfGetCommCodeList(groupCode){
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

function fnTradeInfoSave(){
	purcReq.purcReqInfoSave();
}