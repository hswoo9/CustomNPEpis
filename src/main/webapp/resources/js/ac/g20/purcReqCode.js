
var acG20Code = {};
/**
 * 예산회계단위 조회 
 */
acG20Code.getErpDIVList = function(dblClickparamMap, idex, returnFn){
	var data = {};
	data.CO_CD   = abdocuInfo.erp_co_cd;
	data.BASE_DT = $("#txtGisuDate").val().replace(/-/gi,"");
	
	/*ajax 호출할 파라미터*/
	var opt = {
            url : _g_contextPath_ + "/Ac/G20/Code/getErpDIVList.do",
            stateFn:modal_bg,
            async:true,
            data : data,
            successFn : function(){
            	/*모달창 가로사이즈 및 타이틀*/
            	var dialogParam = {
            			title : NeosUtil.getMessage("TX000005269","예산사업장 코드"),
            			width : "400",
						count : 2
            	};
//            	acUtil.dialogForm = "dialog-form-standard";
            	acUtil.util.dialog.open(dialogParam);
                /*모달창 컬럼 지정 및 스타일 지정*/
            	var mainData = acUtil.modalData;
            	var paramMap = {};
            	paramMap.loopData =  mainData.selectList;
            	paramMap.colNames = [NeosUtil.getMessage("TX000011192","사업장 코드"), NeosUtil.getMessage("TX000011191","사업장 명")];
            	paramMap.colModel = [
            	                       {code : "DIV_CD", text : "DIV_CD", style : {width : "150px"}},
            	                       {code : "", text : "DIV_NM", style : {width : "150px"}}
            	                     ];
            	paramMap.dblClickparamMap = dblClickparamMap;

            	/*모달창 값 선택시(더블클릭) 실행될 함수*/
            	paramMap.trDblClickHandler_UserDefine = function(index){
            		/*구매의뢰서에서 사용안함*/
//					if(dblClickparamMap[0].id == "txtDIV_NM"){
//						/*사용자 정보 초기화*/
//						$("#txtDEPT_NM").val("").attr("code","");
//						$("#txtKOR_NM").val("").attr("code","");
//					}
					/*구매의뢰서에서 사용안함*/
					/*구매의뢰서에서 추가*/
            		returnFn(dblClickparamMap);
					/*구매의뢰서에서 추가*/
            	};

            	acUtil.util.dialog.setData(paramMap);
            },
    	    error: function (request,status,error) {
    	    	alert(NeosUtil.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요")+"\n"+NeosUtil.getMessage("TX000009711","오류 메시지 : {0}").replace("{0}",error)+"\n");
        	}
    }; 
    /*결과 데이터 담을 객체*/
    acUtil.modalData = {};
    acUtil.ajax.call(opt, acUtil.modalData );
};

/**
 * 결의부서/결의자 조회
 */
acG20Code.getErpDeptUserList = function(dblClickparamMap){
	
	var  div_cd =  $("#txtDIV_NM").attr("code");
    var useAllView =  $(":input[name=userAllview]:checked").val() || "0";
	if(useAllView== "1"){
		div_cd = "";
	}
	
	var data = {DIV_CD : div_cd};
	if(abdocu.sec_fg == 3){ /* 자기 부서만 선택 가능 함 */
		data.DEPT_CD = abdocu.erp_dept_cd;
	}
	
    var BASIC_DT = "";
    var USE_YN = $(":input[name=B_use_YN]:checked").val() || "1";
//    var USE_YN = $(":radio[name=B_use_YN][checked=checked]").val() || "1";
    if( $('#B_use_YN_1').prop('checked') ){
    	$("#BASIC_DT").attr("disabled", false);
    	BASIC_DT = $("#BASIC_DT").val();
    }else{
    	$("#BASIC_DT").attr("disabled", true);
    }
    
    Date.prototype.yyyymmdd = function() {
    	  var mm = this.getMonth() + 1; // getMonth() is zero-based
    	  var dd = this.getDate();

    	  return [this.getFullYear(),
    	          (mm>9 ? '' : '0') + mm,
    	          (dd>9 ? '' : '0') + dd
    	         ].join('');
    	};
    var tkdqoDate = new Date();
    if($('#B_use_YN_1').prop('checked')){
    	data.BASE_DT = BASIC_DT || tkdqoDate.yyyymmdd();
    	data.TO_DT = BASIC_DT;
    }
    data.CO_CD = abdocuInfo.erp_co_cd;

	/*ajax 호출할 파라미터*/
    var opt = {
            url : _g_contextPath_ + "/Ac/G20/Code/getErpUserList.do",
            stateFn:modal_bg,
            async:true,
            data : data,
            successFn : function(){
            	/*모달창 가로사이즈 및 타이틀*/
                var dialogParam = {
                		title : NeosUtil.getMessage("TX000005271","사원 코드"),
                        width : "600",
                        count : 4,
                        showDiv : "deptEmp_Search"
                };
                //acUtil.dialogForm = "dialog-form-standard";
                acUtil.util.dialog.open(dialogParam);            	
                /*모달창 컬럼 지정 및 스타일 지정*/
                var mainData = acUtil.modalData;
                var paramMap = {};
                paramMap.loopData =  mainData.selectList;
                paramMap.colNames = [NeosUtil.getMessage("TX000000357","사원코드"), NeosUtil.getMessage("TX000000076","사원명"), NeosUtil.getMessage("TX000000068","부서명"), NeosUtil.getMessage("TX000005301","회계구분명")];
                paramMap.colModel = [
                                       {code : "", text : "EMP_CD", style : { width : "150px", "text-align":"center"}},
                                       {code : "", text : "KOR_NM", style : { width : "150px", "text-align":"center"}},
                                       {code : "", text : "DEPT_NM", style : { width : "150px", "text-align":"center"}},
                                       {code : "", text : "DIV_NM", style : { width : "150px", "text-align":"center"}}
                                     ];
                paramMap.dblClickparamMap = dblClickparamMap;
                acUtil.util.dialog.setData(paramMap);                
            }
    };
    /*결과 데이터 담을 객체*/
    acUtil.modalData = {};
    acUtil.ajax.call(opt, acUtil.modalData );


};

/**
 * 프로젝트 코드
 * @param dblClickparamMap
 */
function getErpMgtList(dblClickparamMap, idex, returnFn, tblParam){
	if(!$("#selProjectStat").data("kendoComboBox")){
		var html = '		<!-- 프로젝트 box -->';
		html += '		<div class="top_box" style="overflow:hidden;display:none;" id="pjt_Search" >';
		html += '            <dl class="dl2">';
		html += '                <dt class="mt2">';
		html += '                    <label class="" for="hiddenSelect" style="">구분</label>';
		html += '				</dt>';
		html += '				<dd>';
		html += '					<select class=" hiddenSelect" style="width:115px" id="selProjectStat">';
		html += '						<option value="1,0" selected="selected">사용</option>';
		html += '						<option value="">전체(미사용포함)</option>';
		html += '						<option value="1">진행</option>';
		html += '						<option value="0">완료</option>';
		html += '					</select>';
		html += '				</dd>';
		html += '				<dt class="mt2">연도</dt>';
		html += '				<dd>';
		html += '					<input type="text" id="pjtFromDate" style="width: 70px; ime-mode: active;">';
		html += '					~';
		html += '				</dd>';
		html += '				<dd>';
		html += '					<input type="text" id="pjtToDate" style="width: 70px; ime-mode: active;">';
		html += '				</dd>';
		html += '				<dd><input type="button" id="pjt_Search_btn" value="조회" /></dd>';
		html += '            </dl>';
		html += '        </div>';
		
		$("#dialog-form-standard .pop_con").prepend(html);
		
    	$("#selProjectStat").kendoComboBox();
    	
    	$("#pjtFromDate").kendoDatePicker({
		    depth: "decade",
		    start: "decade",
		    culture : "ko-KR",
			format : "yyyy",
			value : new Date(),
		});
		
		$("#pjtToDate").kendoDatePicker({
		    depth: "decade",
		    start: "decade",
		    culture : "ko-KR",
			format : "yyyy",
			value : new Date(),
		});
		
		$("#pjt_Search_btn").on({
			click : function(){
				$("#" + dblClickparamMap[0].id).dblclick();
			}
		});
    }
	
	tblParam.erpPjtStatus = $("#selProjectStat").val();
	tblParam.pjtFromDate = $("#pjtFromDate").val() + '0101';;
	tblParam.pjtToDate = $("#pjtToDate").val() + '1231';;

    var opt = {
            url : _g_contextPath_ + "/Ac/G20/Code/getErpMgtList.do",
            stateFn:modal_bg,
            async: false,
            data : tblParam,
            successFn : function(){
                /*모달창 가로사이즈 및 타이틀*/
                var dialogParam = {};
                dialogParam.showDiv = "pjt_Search"
                var paramMap = {};
                
                dialogParam.title = "사업 코드";
                dialogParam.width = "500";
                dialogParam.count = 2;
                
                paramMap.colNames = ["사업 코드", "사업 명"];
                paramMap.colWidth = ["30%", "70%"];
			    if(erpOption.BgtMngType == "1"){
			    	dialogParam.title = NeosUtil.getMessage("TX000005267","부서 코드");
			    	paramMap.colNames = [NeosUtil.getMessage("TX000005267","부서 코드"), NeosUtil.getMessage("TX000015937","부서 명")];
                }
		
                /*모달창 컬럼 지정 및 스타일 지정*/
                var mainData = acUtil.modalData;
                paramMap.loopData =  mainData.selectList;
                
                paramMap.colModel = [
                                       {code : "", text : "PJT_CD", style : {width : "150px"}},
                                       {code : "", text : "PJT_NM", style : {width : "250px"}}
                                     ];
                
                acUtil.dialogForm = "dialog-form-standard";
                acUtil.util.dialog.open(dialogParam); 
                
                /*trDblClickHandler_UserDefine start*/
                paramMap.trDblClickHandler_UserDefine = function(index, dblClickparamMap){ 
                	//returnFn(acUtil.modalData.selectList[index]);
                	/*구매의뢰서 추가*/
                	var id = dblClickparamMap[0].id;
            		var tr = $('#' + id).closest('tr');
            		$('.txtBottom_cd', tr).val('').attr('code','');
//					$('#' + id).val(acUtil.modalData.selectList[index].PJT_CD + acUtil.modalData.selectList[index].PJT_NM);
                	returnFn(acUtil.modalData.selectList[index], dblClickparamMap);
                	/*구매의뢰서 추가*/
                };/*trDblClickHandler_UserDefine end*/
            	paramMap.dblClickparamMap = dblClickparamMap;
                acUtil.util.dialog.setData(paramMap);                
            }
    };
    /*결과 데이터 담을 객체*/
    acUtil.modalData = {};
    acUtil.ajax.call(opt, acUtil.modalData );


};

/*하위사업*/
acG20Code.getErpAbgtBottomList = function (dblClickparamMap, idex, returnFn, tblParam){

    /*ajax 호출할 파라미터*/
    var opt = {
            url     : _g_contextPath_ + "/Ac/G20/Code/getErpAbgtBottomList.do",
            stateFn : modal_bg,
            async   : true,
            data    : tblParam,
            successFn : function(){
           	 /*모달창 가로사이즈 및 타이틀*/
                var dialogParam = {
                        title : NeosUtil.getMessage("TX000005266","하위사업 코드"),
                        width : "700",
						count : 2
                };

                acUtil.dialogForm = "dialog-form-standard";
                acUtil.util.dialog.open(dialogParam);        
                /*모달창 컬럼 지정 및 스타일 지정*/
                var mainData = acUtil.modalData;
                var paramMap = {};
                paramMap.loopData =  mainData.selectList;
                paramMap.loopData.sort(function(a,b){
                	return a.BOTTOM_NM < b.BOTTOM_NM ? -1 : a.BOTTOM_NM > b.BOTTOM_NM ? 1 : 0;
                });
                paramMap.colNames = [NeosUtil.getMessage("TX000005266","하위사업 코드"), "부서명", NeosUtil.getMessage("TX000011188","하위사업 명")];
                paramMap.colWidth = ["20%", "30%", "50%"];
                paramMap.colModel = [
                                       {code : "", text : "BOTTOM_CD", style : {width : "150px"}},
                                       {code : "", text : "DEPT_NAME", style : {width : "200px"}},
                                       {code : "", text : "BOTTOM_NM", style : {width : "350px", "text-align" : "left", "text-indent" : "10px"}}
                                     ];
                /*구매의뢰서 추가*/
                /*trDblClickHandler_UserDefine start*/
                paramMap.trDblClickHandler_UserDefine = function(index, dblClickparamMap){
                	fnMgtCdSet({PJT_CD : ''}, dblClickparamMap);
                };/*trDblClickHandler_UserDefine end*/
                /*구매의뢰서 추가*/
                paramMap.dblClickparamMap = dblClickparamMap;
                acUtil.util.dialog.setData(paramMap);                
            }
    };
    /*결과 데이터 담을 객체*/
    acUtil.modalData = {};
    acUtil.ajax.call(opt, acUtil.modalData );

};


/*입출금 계좌*/
function getErpBTRList(dblClickparamMap){
	
	var USE_YN = "";
    //var BankTrade_use_YN = $(":radio[name=BankTrade_use_YN][checked=checked]").val() || "1";
    var BankTrade_use_YN = $(":input[name=BankTrade_use_YN]:checked").val() || "1";
    if(BankTrade_use_YN == 1){
    	USE_YN = BankTrade_use_YN;
    }
    
    /*ajax 호출할 파라미터*/
    var opt = {
            url : _g_contextPath_ + "/Ac/G20/Code/getErpBTRList.do",
            stateFn:modal_bg,
            async:true,
            data : {USE_YN : USE_YN , CO_CD : abdocuInfo.erp_co_cd},
            successFn : function(){
                /*모달창 가로사이즈 및 타이틀*/
                var dialogParam = {
                        title : NeosUtil.getMessage("TX000005274","입출금계좌 코드"),
                        width : "650",
                        count : 5,
                        showDiv : "BankTrade_Search"
                };            	

                acUtil.dialogForm = "dialog-form-standard";
                acUtil.util.dialog.open(dialogParam);   

                /*모달창 컬럼 지정 및 스타일 지정*/
                var mainData = acUtil.modalData;
                var paramMap = {};
                paramMap.loopData =  mainData.selectList;
                paramMap.colNames = [NeosUtil.getMessage("TX000005270","거래처 코드"), NeosUtil.getMessage("TX000011187","거래처 명"), NeosUtil.getMessage("TX000000024","사업자번호"), NeosUtil.getMessage("TX000003620","계좌번호"), NeosUtil.getMessage("TX000000026","대표자명")];
                paramMap.colModel = [
                                       {code : "", text : "TR_CD", style : {width : "120px", "text-align":"center"}},
                                       {code : "", text : "ATTR_NM", style : {width : "200px", "text-align":"center"}},
                                       {code : "", text : "REG_NB", style : {width : "120px", "text-align":"center"}},
                                       {code : "", text : "BA_NB", style : {width : "120px", "text-align":"center"}},
                                       {code : "", text : "CEO_NM", style : {width : "120px", "text-align":"center"}}
                                     ];

                paramMap.dblClickparamMap = dblClickparamMap;
                acUtil.util.dialog.setData(paramMap);            
            }
    };
    /*결과 데이터 담을 객체*/
    acUtil.modalData = {};
    acUtil.ajax.call(opt, acUtil.modalData );

};

acG20Code.getErpBudgetList = function (dblClickparamMap, idex, returnFn, tblParam){

    var opt = {
            url : _g_contextPath_ + "/Ac/G20/Code/getErpBudgetList.do",
            stateFn : modal_bg,
            async : true,
            data  : tblParam,
            successFn : function(data){
            	/* 
            	 * TODO 상배: 예산단계 레벨에 따른 타이틀 수정 필요
            	 * 
            	 */ 
            	var dialogParam = {};
            	dialogParam.title = NeosUtil.getMessage("TX000004658","예산정보");     
				dialogParam.showDiv = "Budget_Search"
				dialogParam.width = "900";

           		/*모달창 컬럼 지정 및 스타일 지정*/
           		var mainData = acUtil.modalData;
           		var paramMap = {};
           		paramMap.loopData =  mainData.selectList;

            	// step7YN = 1 , 예산 7단계 사용여부 사용
            	if(tblParam.BgtStep7UseYn =="1"){
            		console.log(data);
            		
            		/* 예산 분류및 예산계정 사용되고 있는 레밸 조회 */
            		var colModel = [];
        			var levelUse = [null, null, null, null, null, null, null, null, null, null ];
        			var bgtUse = [null, null, null, null];
            		for(var i=0; i < data.selectList.length ; i++){
            			var item = data.selectList[i];
            			levelUse[0] = levelUse[0] || item.LEVEL01_NM;
            			levelUse[1] = levelUse[1] || item.LEVEL02_NM;
            			levelUse[2] = levelUse[2] || item.LEVEL03_NM;
            			levelUse[3] = levelUse[3] || item.LEVEL04_NM;
            			levelUse[4] = levelUse[4] || item.LEVEL05_NM;
            			levelUse[5] = levelUse[5] || item.LEVEL06_NM;
            			levelUse[6] = levelUse[6] || item.LEVEL07_NM;
            			levelUse[7] = levelUse[7] || item.LEVEL08_NM;
            			levelUse[8] = levelUse[8] || item.LEVEL09_NM;
            			levelUse[9] = levelUse[9] || item.LEVEL10_NM;
            			
            			bgtUse[0] = bgtUse[0] || item.BGT01_CD;
            			bgtUse[1] = bgtUse[1] || item.BGT02_CD;
            			bgtUse[2] = bgtUse[2] || item.BGT03_CD;
            			bgtUse[3] = bgtUse[3] || item.BGT04_CD;
            		}
            		
            		/* 예산 분류 출력준비 */
            		for(var i = 0 ; i < 10; i++){
            			if(levelUse[i]){
            				if(i != 9){
	            				colModel.push({
	            					code : "LEVEL0" + (i + 1) + "_CD"
	            					, text : "LEVEL0" + (i + 1) + "_NM"
	            					, style : {'width' : '130px'}
	            				});
            				}else{
            					colModel.push({
	            					code : "LEVEL10_CD"
	            					, text : "LEVEL10_NM"
	            					, style : {'width' : '130px'}
	            				});
            				}
            			}
            		}
            		/* 예산계정 출력 준비 */
            		var bgtUseCnt = 0;
            		for(var i = 0; i < bgtUse.length; i++){
            			if(bgtUse[i]){
            				bgtUseCnt ++;
            				colModel.push({code : "BGT0"+(i + 1)+"_CD", text : "BGT0"+(i + 1)+"_NM", style : {width : "130px"}});	
            			}
            		}
            		/* 코드 출력준비 */
            		colModel.push({code : "BGT_CD", text : "BGT_CD", style : {width : "130px"}});
            		
            		
            		var colNames = [];
            		var modelCount = colModel.length - 1 ;
            		var erpLevels = ['관', '항', '목', '세'];
            		var erpLevelsCnt = 0;
            		for(var i = 0 ; i < modelCount ; i++){
            			if( ( modelCount - bgtUseCnt ) <= i ){
            				colNames.push(data.nameList[i].USER_NM + '('+ erpLevels[erpLevelsCnt++] +')');
            			}else{
            				colNames.push(data.nameList[i].USER_NM);
            			}
            		}
            		colNames.push(NeosUtil.getMessage("TX000000045","코드"));
            		
            		
            		dialogParam.count = colModel.length;
            		paramMap.colModel = colModel;
            		paramMap.colNames = colNames;
            		
            		/* 예산 7단계 안내문구 출력 */
            		$('#deptEmp_SearchHint').show();
//            		dialogParam.count = 8;            		
//            		paramMap.colNames = [NeosUtil.getMessage("TX000011174","분류1"), NeosUtil.getMessage("TX000011173","분류2"),NeosUtil.getMessage("TX000011172","분류3"),  NeosUtil.getMessage("TX000003625","관"), NeosUtil.getMessage("TX000003626","항"), NeosUtil.getMessage("TX000003627","목"), NeosUtil.getMessage("TX000003628","세"), NeosUtil.getMessage("TX000000045","코드")];
//            		paramMap.colModel = [
//            		                     {code : "LEVEL01_CD", text : "LEVEL01_NM", style : {width : "130px"}},
//            		                     {code : "LEVEL02_CD", text : "LEVEL02_NM", style : {width : "130px"}},
//            		                     {code : "LEVEL03_CD", text : "LEVEL03_NM", style : {width : "130px"}},
//            		                     {code : "BGT01_CD", text : "BGT01_NM", style : {width : "130px"}},
//            		                     {code : "BGT02_CD", text : "BGT02_NM", style : {width : "130px"}},
//            		                     {code : "BGT03_CD", text : "BGT03_NM", style : {width : "130px"}},
//            		                     {code : "BGT04_CD", text : "BGT04_NM", style : {width : "130px"}},
//            		                     {code : "BGT_CD", text : "BGT_CD", style : {width : "130px"}}
//            		                     ];
            	}
            	else{ // step7YN = 0 , 예산 7단계 사용여부 미사용
            		dialogParam.count = 5;
				   	paramMap.colNames = [NeosUtil.getMessage("TX000003625","관"), NeosUtil.getMessage("TX000003626","항"), NeosUtil.getMessage("TX000003627","목"), NeosUtil.getMessage("TX000003628","세"), NeosUtil.getMessage("TX000000045","코드")];
                    paramMap.colModel = [
                                         {code : "BGT01_CD", text : "BGT01_NM", style : {width : "150px"}},
                                         {code : "BGT02_CD", text : "BGT02_NM", style : {width : "150px"}},
                                         {code : "BGT03_CD", text : "BGT03_NM", style : {width : "150px"}},
                                         {code : "BGT04_CD", text : "BGT04_NM", style : {width : "150px"}},
                                         {code : "BGT_CD", text : "BGT_CD", style : {width : "150px"}}
                                         ];
                }                   
            	
            	acUtil.dialogForm = "dialog-form-standard";
            	acUtil.util.dialog.open(dialogParam);
            	
            	/*선택한 예산과목에 대해서 예산이 얼마 남았는지 상세 정보 */
            	paramMap.trDblClickHandler_UserDefine = function(index, dblClickparamMap){
					// 선택 리턴
            		returnFn(acUtil.modalData.selectList[index], dblClickparamMap);
            	};

            	paramMap.dblClickparamMap = dblClickparamMap;
            	acUtil.util.dialog.setData(paramMap);
            }
    };
    /*결과 데이터 담을 객체*/
    acUtil.modalData = {};
    acUtil.ajax.call(opt, acUtil.modalData );

};

/**
 * 거래처(채주명) 선택시 팝업
 */
acG20Code.getErpTradeList = function(dblClickparamMap){

	var tr_nm = "";
	
	if(gwOption.auto_search && abdocu.auto_search =="Y"){
		tr_nm = $("#" + dblClickparamMap[0].id).val();
	}
	
	var obj = {};
	obj.CO_CD = abdocuInfo.erp_co_cd;
	obj.TR_NM = tr_nm;
		
	/*ajax 호출할 파라미터*/
    var opt = {
			url : _g_contextPath_ + "/Ac/G20/Code/getErpTradeList.do",
            stateFn:modal_bg,
            async:true,
            data : obj,
            successFn : function(){
            	/*모달창 가로사이즈 및 타이틀*/
            	var dialogParam = {
            			title : NeosUtil.getMessage("TX000005270","거래처 코드"),
            			width : "950",
            			count : 11,
						showDiv : "Trade_Search"
            	};
            	acUtil.dialogForm = "dialog-form-standard";            	
            	acUtil.util.dialog.open(dialogParam);
            	
                /*모달창 컬럼 지정 및 스타일 지정*/
            	var mainData = acUtil.modalData;
            	var paramMap = {};
            	paramMap.loopData =  mainData.selectList;
            	paramMap.colNames = [NeosUtil.getMessage("TX000000315","거래처코드"), NeosUtil.getMessage("TX000000313","거래처명"), NeosUtil.getMessage("TX000000024","사업자번호"), NeosUtil.getMessage("TX000003621","예금주"), NeosUtil.getMessage("TX000005299","대표자성명"), NeosUtil.getMessage("TX000005280","은행코드"), NeosUtil.getMessage("TX000004610","은행명"), NeosUtil.getMessage("TX000003620","계좌번호"), NeosUtil.getMessage("TX000000375","주소"), NeosUtil.getMessage("TX000000006","전화"), NeosUtil.getMessage("TX000000329","담당자")];

            	paramMap.colModel = [
            	                       {code : "", text : "TR_CD", style : {width : "150px"}},
            	                       {code : "", text : "TR_NM", style : {width : "150px"}},
            	                       {code : "", text : "REG_NB", style : {width : "150px"}},
            	                       {code : "", text : "DEPOSITOR", style : {width : "150px"}},
            	                       {code : "", text : "CEO_NM", style : {width : "150px"}},
            	                       {code : "", text : "JIRO_CD", style : {width : "150px"}},
            	                       {code : "", text : "JIRO_NM", style : {width : "150px"}},
            	                       {code : "", text : "BA_NB", style : {width : "150px"}},
            	                       {code : "", text : "ADDR", style : {width : "150px"}},
            	                       {code : "", text : "TEL", style : {width : "150px"}},
            	                       {code : "", text : "TRCHARGE_EMP", style : {width : "150px"}}
            	                     ];
            	/*구매의뢰서 추가*/
            	paramMap.trDblClickHandler_UserDefine = function(index, dblClickparamMap){
            		fnTradeInfoSave(dblClickparamMap[0].id);
            		if($("#"+dblClickparamMap[0].id).closest("table").attr("id") == "erpTradeInfo"){
            			var resultData = {};
            			abdocu.TradeInfo.RowSave($("#"+dblClickparamMap[0].id), resultData);
            		}
            	};
            	/*구매의뢰서 추가*/
            	paramMap.dblClickparamMap = dblClickparamMap;
            	$('#tradeAllview').prop('checked', false);
            	/* 거래처 건수가 500건 이상일때는 초기에는 안보이게 */
            	if(paramMap.loopData.length > 500){ 
            		paramMap.NoBind = true;
            		$("#acUtil.dialogForm input[type=checkbox]").attr("checked", false);
            	}
            	else{
            		$("#acUtil.dialogForm input[type=checkbox]").attr("checked", true);
            	}
                acUtil.util.dialog.setData_Trade(paramMap);            	
            }
    };
    /*결과 데이터 담을 객체*/
    acUtil.modalData = {};
    acUtil.ajax.call(opt, acUtil.modalData );


};

/**
 * 사원
 */
function getErpEmpList(dblClickparamMap, index){
	
    var P_STD_DT = "";
    var USE_YN = $(":input[name=B_use_YN2]:checked").val() || "1";
    if(USE_YN == 1){
    	$("#P_STD_DT").attr("disabled", false);
    	P_STD_DT = $("#P_STD_DT").val().replace(/-/gi,"");
    }else{
    	$("#P_STD_DT").attr("disabled", true);
    }
	/*ajax 호출할 파라미터*/
    var opt = {
			url : _g_contextPath_ + "/Ac/G20/Code/getErpEmpList.do",
            stateFn:modal_bg,
            async:false,
            data : {P_STD_DT : P_STD_DT, CO_CD :  abdocuInfo.erp_co_cd},
            successFn : function(){
            	/*값 선택시 뿌려주는 대상이 다름.*/
            	for(var i = 0, max = dblClickparamMap.length; i < max; i++){
            		if(dblClickparamMap[i].id == ("txt_TR_NM" + index)){
            			dblClickparamMap[i].text = "KOR_NM";
            			dblClickparamMap[i].code = "EMP_CD";
            		}
            		if(dblClickparamMap[i].id == ("txt_DEPOSITOR" + index)){
            			dblClickparamMap[i].text = "KOR_NM";
            		}	
            	}
            	
            	/*모달창 가로사이즈 및 타이틀*/
            	var dialogParam = {
            			title : NeosUtil.getMessage("TX000011166","사원코드 코드"),
            			width : "400",
            			count : 2,
                        showDiv : "EmpTrade_Search"  
            	};
            	acUtil.dialogForm = "dialog-form-standard";
            	acUtil.util.dialog.open(dialogParam);
            	
                /*모달창 컬럼 지정 및 스타일 지정*/
            	var mainData = acUtil.modalData;
            	var paramMap = {};
            	paramMap.loopData =  mainData.selectList;
            	paramMap.colNames = [NeosUtil.getMessage("TX000000357","사원코드"), NeosUtil.getMessage("TX000000076","사원명")];

            	paramMap.colModel = [
          	                           {code : "", text : "EMP_CD", style : {width : "150px"}},
            	                       {code : "", text : "KOR_NM", style : {width : "150px"}}
            	                     ];
            	paramMap.dblClickparamMap = dblClickparamMap;
            	paramMap.trDblClickHandler_UserDefine = function(idx, dblClickparamMap){ 
                	var EMP_CD = acUtil.modalData.selectList[idx].EMP_CD;
                    var opt = {
                            url : _g_contextPath_ + "/Ac/G20/Code/getErpEmpBankTrade.do",
                            stateFn:modal_bg,
                            async:true,
                            data : { EMP_CD : EMP_CD , CO_CD : abdocuInfo.erp_co_cd },
                            successFn : function(result){      
                            	if(result.isSuccess && result.selectList.length){
                            		var item = result.selectList[0];
                            		$("#txt_BTR_NM" + index).val(item.BANK_NM);
                            		$("#txt_BTR_NM" + index).attr("code", item.BANK_CD);
                            		$("#txt_BA_NB" + index).val(item.ACCT_NO || item.ACCT_NO2);
                            		$("#txt_DEPOSITOR" + index).val(item.DPST_NM);
                            	}else{
                            		alert(result.commonMsg);
                            	}
                            }
                    }; 
                    acUtil.ajax.call(opt, null);
                };
                acUtil.util.dialog.setData(paramMap);            	
            }
    };
    /*결과 데이터 담을 객체*/
    acUtil.modalData = {};
    acUtil.ajax.call(opt, acUtil.modalData );
};

/** 기타소득자 */
function getErpHpmeticList(dblClickparamMap, index){
	/*ajax 호출할 파라미터*/
	var erp_gisu_dt = $("#txtGisuDate").val().replace(/-/gi,"");
	
    var opt = {
    		
            url : _g_contextPath_ + "/Ac/G20/Code/getErpHpmeticList.do",
            stateFn:modal_bg,
            async:false,
            data : {BASE_DT : erp_gisu_dt, CO_CD :  abdocuInfo.erp_co_cd},
            successFn : function(){
            	/*값 선택시 뿌려주는 대상이 다름.*/
            	for(var i = 0, max = dblClickparamMap.length; i < max; i++){
            		if(dblClickparamMap[i].id == ("txt_TR_NM" + index)){
            			dblClickparamMap[i].text = "PER_NM";
            			dblClickparamMap[i].code = "PER_CD";
            		}
            		if(dblClickparamMap[i].id == ("txt_DEPOSITOR" + index)){
            			dblClickparamMap[i].text = "PER_NM";
            		}	
            		if(dblClickparamMap[i].id == ("txt_BA_NB"  + index)){
            			dblClickparamMap[i].text = "ACCT_NO";
            		}
            		if(dblClickparamMap[i].id == ("txt_BTR_NM"  + index)){
            			dblClickparamMap[i].text = "BANK_NM";
            			dblClickparamMap[i].code = "BANK_CD";
            		}
            		if(dblClickparamMap[i].id == ("txt_JIRO_CD"  + index)){
            			dblClickparamMap[i].text = "BANK_CD";
            		}
            	}
            	
            	/*모달창 가로사이즈 및 타이틀*/
            	var dialogParam = {
            			title : NeosUtil.getMessage("TX000005272","기타소득자 코드"),
            			width : "500",
						count : 3
            	};
            	acUtil.dialogForm = "dialog-form-standard";
            	acUtil.util.dialog.open(dialogParam);
            	
                /*모달창 컬럼 지정 및 스타일 지정*/
            	var mainData = acUtil.modalData;
            	var paramMap = {};
            	paramMap.loopData =  mainData.selectList;
            	paramMap.colNames = [NeosUtil.getMessage("TX000000045","코드"), NeosUtil.getMessage("TX000005306","소득자명"), NeosUtil.getMessage("TX000000080","주민번호")];

            	paramMap.colModel = [
            	                       {code : "", text : "PER_CD", style : {width : "100px"}},
            	                       {code : "", text : "PER_NM", style : {width : "100px"}},
            	                       {code : "", text : "REG_NO", style : {width : "100px"}}
            	                     ];
            	paramMap.dblClickparamMap = dblClickparamMap;
                acUtil.util.dialog.setData(paramMap);            	
            }
    };
    /*결과 데이터 담을 객체*/
    acUtil.modalData = {};
    acUtil.ajax.call(opt, acUtil.modalData );
};

/* 사업소득자 */
function getErpHincomeList(dblClickparamMap, index){
	/*ajax 호출할 파라미터*/
    var opt = {
            url : _g_contextPath_ + "/Ac/G20/Code/getErpHincomeList.do",
            stateFn:modal_bg,
            async:false,
            data : {CO_CD :  abdocuInfo.erp_co_cd},
            successFn : function(){
            	/*값 선택시 뿌려주는 대상이 다름.*/
            	for(var i = 0, max = dblClickparamMap.length; i < max; i++){
            		if(dblClickparamMap[i].id == ("txt_TR_NM" + index)){
            			dblClickparamMap[i].text = "PER_NM";
            			dblClickparamMap[i].code = "PER_CD";
            		}
            		if(dblClickparamMap[i].id == ("txt_DEPOSITOR" + index)){
            			dblClickparamMap[i].text = "PER_NM";
            		}
            		if(dblClickparamMap[i].id == ("txt_BA_NB"  + index)){
            			dblClickparamMap[i].text = "ACCT_NO";
            		}
            		if(dblClickparamMap[i].id == ("txt_BTR_NM"  + index)){
            			dblClickparamMap[i].text = "BANK_NM";
            			dblClickparamMap[i].code = "BANK_CD";
            		}
            		if(dblClickparamMap[i].id == ("txt_JIRO_CD"  + index)){
            			dblClickparamMap[i].text = "BANK_CD";
            		}
            	}
            	
            	/*모달창 가로사이즈 및 타이틀*/
            	var dialogParam = {
            			title : NeosUtil.getMessage("TX000011165","사업소득자 코드"),
            			width : "500",
            			count : 3
            	};
            	acUtil.dialogForm = "dialog-form-standard";
            	acUtil.util.dialog.open(dialogParam);
            	
                /*모달창 컬럼 지정 및 스타일 지정*/
            	var mainData = acUtil.modalData;
            	var paramMap = {};
            	paramMap.loopData =  mainData.selectList;
            	paramMap.colNames = [NeosUtil.getMessage("TX000000045","코드"), NeosUtil.getMessage("TX000005306","소득자명"), NeosUtil.getMessage("TX000000080","주민번호")];

            	paramMap.colModel = [
            	                       {code : "", text : "PER_CD", style : {width : "100px"}},
            	                       {code : "", text : "PER_NM", style : {width : "100px"}},
            	                       {code : "", text : "REG_NO", style : {width : "100px"}}
            	                     ];
            	paramMap.dblClickparamMap = dblClickparamMap;
                acUtil.util.dialog.setData(paramMap);            	
            }
    };
    /*결과 데이터 담을 객체*/
    acUtil.modalData = {};
    acUtil.ajax.call(opt, acUtil.modalData );
};

/**
금융기관
**/
function getErpBankList(dblClickparamMap){
	/*ajax 호출할 파라미터*/
    var opt = {
    		url : _g_contextPath_ + "/Ac/G20/Code/getErpBankList.do",
				
            stateFn:modal_bg,
            async:false,
            data : {CO_CD :  abdocuInfo.erp_co_cd},
            successFn : function(){
            	/*모달창 가로사이즈 및 타이틀*/
            	var dialogParam = {
            			title : NeosUtil.getMessage("TX000005273","금융기관 코드"),
            			width : "400",
						count : 2
            	};
            	acUtil.dialogForm = "dialog-form-standard";
            	acUtil.util.dialog.open(dialogParam);
            	
                /*모달창 컬럼 지정 및 스타일 지정*/
            	var mainData = acUtil.modalData;
            	var paramMap = {};
            	paramMap.loopData =  mainData.selectList;
            	paramMap.colNames = [NeosUtil.getMessage("TX000005280","은행코드"), NeosUtil.getMessage("TX000004610","은행명")];

            	paramMap.colModel = [
            	                       {code : "", text : "BANK_CD", style : {width : "150px"}},
            	                       {code : "", text : "BANK_NM", style : {width : "150px"}}
            	                     ];
            	paramMap.dblClickparamMap = dblClickparamMap;
                acUtil.util.dialog.setData(paramMap);            	
            }
    };
    /*결과 데이터 담을 객체*/
    acUtil.modalData = {};
    acUtil.ajax.call(opt, acUtil.modalData );
};


/**
 * 카드 거래처  
 */
acG20Code.getErpCardTradeList =  function(dblClickparamMap){
	
	/*ajax 호출할 파라미터*/
    var opt = {
    		url : _g_contextPath_ + "/Ac/G20/Code/getErpTradeList.do",
            stateFn:modal_bg,
            async:true,
            data : {detail_type : '9', CO_CD :  abdocuInfo.erp_co_cd},
            successFn : function(){
            	/*모달창 가로사이즈 및 타이틀*/
            	var dialogParam = {
            			title : NeosUtil.getMessage("TX000005379","카드거래처"),
            			width : "500",
            		    count : 5
            	};
            	
                acUtil.dialogForm = "dialog-form-standard";
                acUtil.util.dialog.open(dialogParam);
            	
                /*모달창 컬럼 지정 및 스타일 지정*/
            	var mainData = acUtil.modalData;
            	var paramMap = {};
            	paramMap.loopData =  mainData.selectList;
            	paramMap.colNames = [NeosUtil.getMessage("TX000000315","거래처코드"), NeosUtil.getMessage("TX000000313","거래처명"), NeosUtil.getMessage("TX000000024","사업자번호"),NeosUtil.getMessage("TX000005299","대표자성명"), NeosUtil.getMessage("TX000000526","카드번호")];

            	paramMap.colModel = [
            	                       {code : "", text : "TR_CD", style : {width : "100px"}},
            	                       {code : "", text : "TR_NM", style : {width : "100px"}},
            	                       {code : "", text : "REG_NB", style : {width : "100px"}},
            	                       {code : "", text : "CEO_NM", style : {width : "100px"}},
            	                       {code : "", text : "BA_NB", style : {width : "100px"}}
            	                     ];
            	
                /*선택한 예산과목에 대해서 예산이 얼마 남았는지 상세 정보 */
                paramMap.trDblClickHandler_UserDefine = function(index, dblClickparamMap){

                	var ctr_nm = acUtil.modalData.selectList[index].TR_NM;
                	var ctr_cd = acUtil.modalData.selectList[index].TR_CD;
                	var ctr_card_num = acUtil.modalData.selectList[index].BA_NB;
                	var html = "[" + ctr_cd + "]" + ctr_nm + " ("+(ctr_card_num || '-')+")";
                	$("#tradeCardNm").html(html);
                };
            	
            	paramMap.dblClickparamMap = dblClickparamMap;
                acUtil.util.dialog.setData(paramMap);            	
            }
    };
    /*결과 데이터 담을 객체*/
    acUtil.modalData = {};
    acUtil.ajax.call(opt, acUtil.modalData );
};





function getErpEtcIncomeList(dblClickparamMap){
	var eventid = $("#" + acUtil.divEtcPop).attr("eventid");
	
	var parentEle = $("#" + eventid).parents("tr");
	var DATA_CD = $(".txt_DATA_CD", parentEle).val();
	/**/
	var data = {DATA_CD : DATA_CD, CO_CD :  abdocuInfo.erp_co_cd};
	/*ajax 호출할 파라미터*/
    var opt = {
            url : _g_contextPath_ + "/Ac/G20/Code/getErpEtcIncomeList.do",
            stateFn:modal_bg,
            async:true,
            data : data,
            successFn : function(){
            	/*모달창 가로사이즈 및 타이틀*/
            	var dialogParam = {
            			title : NeosUtil.getMessage("TX000011167","관리내역 코드"),
            			width : "500",
            			count : 2
            	};
            	acUtil.dialogForm = "dialog-form-standard";
            	acUtil.util.dialog.open(dialogParam);
            	
                /*모달창 컬럼 지정 및 스타일 지정*/
            	var mainData = acUtil.modalData;
            	var paramMap = {};
            	paramMap.loopData =  mainData.selectList;
            	paramMap.colNames = [NeosUtil.getMessage("TX000000045","코드"), NeosUtil.getMessage("TX000000340","관리내역명")];

            	paramMap.colModel = [
            	                       {code : "", text : "CTD_CD", style : {width : "100px"}},
            	                       {code : "", text : "CTD_NM", style : {width : "250px"}}
            	                     ];
            	paramMap.dblClickparamMap = dblClickparamMap;
            	paramMap.trDblClickHandler_UserDefine = function(idx, dblClickparamMap){ 
            		abdocu.TradeInfo.getETCPopSet(parentEle);
                };
                acUtil.util.dialog.setData(paramMap);
            }
    };
    /*결과 데이터 담을 객체*/
    acUtil.modalData = {};
    acUtil.ajax.call(opt, acUtil.modalData );
};