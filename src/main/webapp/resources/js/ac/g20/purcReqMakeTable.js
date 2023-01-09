/**
 * 
 * 조건에 따른 거래처 테이블 생성한다.
 * 
 */


function fnBudgetInfoSet(){
	if(erpOption.BgtAllocatUseYn == "1"){
		$("#budgetInfoAm tr th:nth-child(3)").show();
		$("#budgetInfoAm tr td:nth-child(4)").show();
	}else{
		$("#budgetInfoAm tr th:nth-child(3)").hide();
		$("#budgetInfoAm tr td:nth-child(4)").hide();
	}
}


function fnBudgetTableSet(){

    if(erpOption.BizGovUseYn !="1"){
//    	ctlBudgetHide(6);
    	ctlBudgetHide(9);
    }

	if(abdocuInfo.docu_mode == 0){
//		ctlBudgetHide(2);
//		ctlBudgetHide(4);
		ctlBudgetHide(5);
		ctlBudgetHide(7);
	}
	
	if(purcReqType == "1" || purcReqType == "2"){
		ctlBudgetHide(12);
	}
}

//입력한 컬럼 숨김
function ctlBudgetHide(n){
	var Num = n;
	$("#erpBudgetInfo tr th:nth-child("+Num+")").hide();
	$("#erpBudgetInfo-table tr td:nth-child("+Num+")").hide();
	$("#erpBudgetInfo-tablesample tr td:nth-child("+Num+")").hide();
	$("#erpBudgetInfo-tablesample-empty tr td:nth-child("+Num+")").hide();
}


function fnTradeTableSet(modeType, taxType){
    ctlTradeReset();

	if(abdocuInfo.docu_mode == 0){
		fnConsTradeTableSet();
	}
	else{
		fnResTradeTableSet(modeType, taxType);
	}
}

//컬럼 리셋
function ctlTradeReset(){
	$("#erpTradeInfo tr th").show();
	$("#erpTradeInfo-table tr td").show();
	$("#erpTradeInfo-tablesample tr td").show();
	$("#erpTradeInfo-tablesample-empty tr td").show();
		
	$("#thTradeTrNm").html(NeosUtil.getMessage("TX000000313","거래처명"));
	$("#thTradeUnitAm").html(NeosUtil.getMessage("TX000000552","금액"));
	$("#thTradeSupAm").html(NeosUtil.getMessage("TX000000516","공급가액"));
	$("#thTradeVatAm").html(NeosUtil.getMessage("TX000000517","부가세"));
	$("#erpTradeInfo-tablesample input").addClass("show");
}

//입력한 컬럼 숨김
function ctlTradeHide(n){
	var Num = n;
	$("#erpTradeInfo tr th:nth-child("+Num+")").hide();
	$("#erpTradeInfo-table tr td:nth-child("+Num+")").hide();
	$("#erpTradeInfo-tablesample tr td:nth-child("+Num+")").hide();
	$("#erpTradeInfo-tablesample-empty tr td:nth-child("+Num+")").hide();
	$("#erpTradeInfo-tablesample tr td:nth-child("+Num+") input").removeClass("requirement");	
	$("#erpTradeInfo-tablesample tr td:nth-child("+Num+") input").addClass("non-requirement");
	$("#erpTradeInfo-tablesample tr td:nth-child("+Num+") input").removeClass("show");
	
}

//입력한 컬럼 숨김
function ctlTradeShow(n, classNm){
	var Num = n;
//	$("#erpTradeInfo tr th:nth-child("+Num+")").show();
//	$("#erpTradeInfo-table tr td:nth-child("+Num+")").show();
//	$("#erpTradeInfo-tablesample tr td:nth-child("+Num+")").show();
//	$("#erpTradeInfo-tablesample-empty tr td:nth-child("+Num+")").show();
	$("#erpTradeInfo-tablesample tr td:nth-child("+Num+") input").removeClass("non-requirement");
	$("#erpTradeInfo-tablesample tr td:nth-child("+Num+") input").addClass("requirement");
}

function fnConsTradeTableSet(){
	var purcReqType = $('#purcReqType').attr('CODE');
	var purcTrType = $('#tableTab .selTab').attr('id');
	if(purcReqType == '1' || (purcReqType != '2' && purcTrType == '002')){
		$('#thItemNm').html('품명')
		ctlTradeHide(1);
		ctlTradeHide(2);
		ctlTradeHide(3);
		ctlTradeHide(4);
		ctlTradeHide(5);
		ctlTradeHide(6);
		ctlTradeHide(7);
		ctlTradeHide(8);
		ctlTradeHide(9);
		ctlTradeHide(10);
		
		ctlTradeHide(14);
		ctlTradeHide(15);
		ctlTradeHide(16);
		ctlTradeHide(21);
		ctlTradeHide(22);
	}
	if(purcReqType == '2'){
		ctlTradeHide(1);
		ctlTradeHide(2);
		ctlTradeHide(3);
		ctlTradeHide(4);
		ctlTradeHide(5);
		
		ctlTradeHide(14);
		ctlTradeHide(15);
		ctlTradeHide(16);
		ctlTradeHide(22);
	}
	if(purcReqType == '3' && purcTrType == '001'){
		$('#thItemNm').html('공사명')
		$('#thContents').html('공사내용')
		$('#thStratDate').html('공사시작일')
		$('#thEndDate').html('공사종료일')
		ctlTradeHide(1);
		ctlTradeHide(2);
		ctlTradeHide(3);
		ctlTradeHide(4);
		ctlTradeHide(5);
		ctlTradeHide(6);
		ctlTradeHide(7);
		ctlTradeHide(8);
		ctlTradeHide(9);
		
		ctlTradeHide(10);
		ctlTradeHide(12);
		ctlTradeHide(13);
		ctlTradeHide(15);
		ctlTradeHide(16);
		ctlTradeHide(17);
		ctlTradeHide(21);
		ctlTradeHide(22);
	}
	if(purcReqType == '4' && purcTrType == '001'){
		$('#thItemNm').html('용역명')
		$('#thContents').html('용역내용')
		$('#thStratDate').html('용역시작일')
		$('#thEndDate').html('용역종료일')
		ctlTradeHide(1);
		ctlTradeHide(2);
		ctlTradeHide(3);
		ctlTradeHide(4);
		ctlTradeHide(5);
		ctlTradeHide(6);
		ctlTradeHide(7);
		ctlTradeHide(8);
		ctlTradeHide(9);
		
		ctlTradeHide(10);
		ctlTradeHide(12);
		ctlTradeHide(13);
		ctlTradeHide(15);
		ctlTradeHide(16);
		ctlTradeHide(17);
		ctlTradeHide(21);
		ctlTradeHide(22);
	}
}

function fnResTradeTableSet(modeType, taxType){
	
	// 채주유형 : 1(거래처) , 3(거래처명),  5(기금), 6(운영비)
	if(modeType == "1" || modeType == "3" || modeType == "5" || modeType =="6" || modeType =="7"){
		
		if(taxType =="1"){
			
		}
		if(taxType =="2"){
			
		}
		
		if(taxType =="3"){
			
		}
	}
	
	if(modeType == "2"){
		$("#thTradeTrNm").html(NeosUtil.getMessage("TX000000076","사원명"));
	}
	
	if(modeType == "4"){
		$("#thTradeTrNm").html(NeosUtil.getMessage("TX000004274","기타소득자"));
		$("#thTradeUnitAm").html(NeosUtil.getMessage("TX000003541","지급총액"));
		$("#thTradeSupAm").html(NeosUtil.getMessage("TX000004275","실수령액"));
		$("#thTradeVatAm").html(NeosUtil.getMessage("TX000004276","원천징수액"));
	
	}
	
	if(modeType == "8"){
		$("#thTradeTrNm").html(NeosUtil.getMessage("TX000000076","사원명"));
		$("#thTradeUnitAm").html(NeosUtil.getMessage("TX000003541","지급총액"));
		$("#thTradeSupAm").html(NeosUtil.getMessage("TX000004275","실수령액"));
		$("#thTradeVatAm").html(NeosUtil.getMessage("TX000004276","원천징수액"));
	}
	
	if(modeType == "9"){
		$("#thTradeTrNm").html(NeosUtil.getMessage("TX000004277","사업소득자"));
		$("#thTradeUnitAm").html(NeosUtil.getMessage("TX000003541","지급총액"));
		$("#thTradeSupAm").html(NeosUtil.getMessage("TX000004275","실수령액"));
		$("#thTradeVatAm").html(NeosUtil.getMessage("TX000004276","원천징수액"));
	}
}





var MakeTradeTable = {};
MakeTradeTable.mode = {};
MakeTradeTable.mode.tableList = ["erpTradeInfo-table", "erpTradeInfo-tablesample" , "erpTradeInfo-tablesample-empty"];
MakeTradeTable.mode.confer = {};
MakeTradeTable.mode.spend = {};

MakeTradeTable.mode.create = function(modeType, mode, taxType){
	
	if(mode == "0"){

		var modeTypeVal = MakeTradeTable.getModeType(mode, modeType);		
	    if(modeTypeVal == "2"){
	    	//if(taxType !="1"){
	    	//	modeTypeVal ="5";
	    	//} 
	    }
		MakeTradeTable.mode.confer.create(modeTypeVal);
	}
	else
	{
	    var modeTypeVal = MakeTradeTable.getModeType(mode, modeType);

	    if(modeTypeVal == "1"){ //채주유형 : 거래처명
	    	if(taxType =="2"){  // 과세구분 : 면세
	    		modeTypeVal ="6";
	    	}else if(taxType =="3"){ // 과세구분 : 기타
	    		modeTypeVal ="4";  
	    	} 
	    }
		MakeTradeTable.mode.spend.create(modeTypeVal, modeType);
	}
};

MakeTradeTable.getModeType = function(mode, modeType){
	if(mode == "0"){
		/*품의서*/
		var obj = {
				"1": "1",
				"2": "1",
				"3": "1",
				"4": "2",
				"5": "3",
				"6": "4",
				"7": "2",
				"8": "2"
			};

	    var modeTypeVal = obj[modeType];	
	    return modeTypeVal;
	}
	else{
		/*결의서*/
		var obj = {
				"1": "1",
				"2": "1",
				"3": "1",
				"4": "2",
				"5": "1",
				"6": "1",
				"7": "1",
				"8": "3",
				"9": "5"
			};

	    var modeTypeVal = obj[modeType];		
	    return modeTypeVal;;
	}};

	
MakeTradeTable.getTrType = function(modeType){
	/*결의서*/
	var obj = {
			"1": "1",
			"2": "2",
			"3": "1",
			"4": "4",
			"5": "5",
			"6": "1",
			"7": "5",
			"8": "8",
			"9": "9"
		};

    var modeTypeVal = obj[modeType];		
    return modeTypeVal;;
};



/*품의서*/
MakeTradeTable.mode.confer.create = function(modeTypeVal){
	var tableList = MakeTradeTable.mode.tableList;
	var obj = MakeTradeTable.mode.confer.getHtml(modeTypeVal);
	var table1 = obj[tableList[0]];
	$("#" + tableList[0]).remove();
	$("#erpTradeInfo").append(table1);

	var table2 = obj[tableList[1]];
	$("#" + tableList[1]).remove();
	$("#erpTradeInfo").append(table2);
	
	var table3 = obj[tableList[2]];
	$("#" + tableList[2]).remove();
	$("#erpTradeInfo").append(table3);	
	
};




/*결의서*/
MakeTradeTable.mode.spend.create = function(modeTypeVal, modeType){
	var tableList = MakeTradeTable.mode.tableList;
	var obj = MakeTradeTable.mode.spend.getHtml(modeTypeVal, modeType);
	var table1 = obj[tableList[0]];
	$("#" + tableList[0]).remove();
	$("#erpTradeInfo").append(table1);

	var table2 = obj[tableList[1]];
	$("#" + tableList[1]).remove();
	$("#erpTradeInfo").append(table2);
	
	var table3 = obj[tableList[2]];
	$("#" + tableList[2]).remove();
	$("#erpTradeInfo").append(table3);	
	
};

MakeTradeTable.mode.confer.getHtml = function(modeTypeVal){};  

MakeTradeTable.mode.spend.getHtml = function(modeTypeVal, modeType){};

MakeTradeTable.mode.confer.getMiniPopHtml = function(mode){
	var html = "";	
	if(mode =="0"){
		
		html +='<!-- layer0 -->                                                                                                                                  ';
		html+= '<div class="pop_wrap layer_pop_etc">                                                                                                                               ';
		html+= '	<a href="javascript:;" class="clo" id="btnPopCancel"></a>           ';
		html+= '	<div class="pop_con mt10">                                                                                                                                     ';
		html+= '        <div class="com_ta">                                                                                                                               ';
		html+= '            <table>                                                                                                                               ';
		html+= '               <colgroup>                                                                                                                               ';
		html+= '                   <col width="120"/>                                                                                                                               ';
		html+= '                   <col width=""/>                                                                                                                               ';
		html+= '               </colgroup>                                                                                                                               ';
		html+= '               <tr>                                                                                                                               ';
		html+= '                  <th>'+NeosUtil.getMessage("TX000004264","필요경비금액")+'</th>                                                                                                                               ';
		html+= '                  <td><input type="text" style="width:210px;" id="pop_NDEP_AM" class="etc_pop" tabIndex="101" /> '+NeosUtil.getMessage("TX000000626","원")+'</td>                                             ';
		html+= '               </tr>                                                                                                                              ';
		html+= '               <tr>                                                                                                                               ';
		html+= '                  <th>'+NeosUtil.getMessage("TX000004266","소득금액")+'</th>                                                                                                                               ';
		html+= '                  <td><input type="text" style="width:210px;" id="pop_INAD_AM" class="etc_pop" tabIndex="102" /> '+NeosUtil.getMessage("TX000000626","원")+'</td>                                             ';
		html+= '               </tr>                                                                                                                              ';
		html+= '               <tr>                                                                                                                               ';
		html+= '                  <th>'+NeosUtil.getMessage("TX000004265","소득세액")+'</th>                                                                                                                               ';
		html+= '                  <td><input type="text" style="width:210px;" id="pop_INTX_AM" class="etc_pop" tabIndex="103" /> '+NeosUtil.getMessage("TX000000626","원")+'</td>                                             ';
		html+= '               </tr>                                                                                                                              ';
		html+= '               <tr>                                                                                                                               ';
		html+= '                  <th>'+NeosUtil.getMessage("TX000004267","주민세액")+'</th>                                                                                                                               ';
		html+= '                  <td><input type="text" style="width:210px;" id="pop_RSTX_AM" class="etc_pop" tabIndex="104" /> '+NeosUtil.getMessage("TX000000626","원")+'</td>                                             ';
		html+= '               </tr>                                                                                                                              ';
		html+= '               <tr>                                                                                                                               ';
		html+= '                  <th>'+NeosUtil.getMessage("TX000003537","귀속년월")+'</th>                                                                                                                               ';
		html+= '                  <td><input type="text" value="" style="width:63px;" id="pop_ETCRVRS_YM_YYYY" maxlength="4" class="etc_pop"  tabIndex="104"/> '+NeosUtil.getMessage("TX000000435","년")+' <input type="text" value="" style="width:30px;" id="pop_ETCRVRS_YM_MM" maxlength="2" class="etc_pop"  tabIndex="105"  part="etcpop"/> '+NeosUtil.getMessage("TX000000436","월")+'</td>                                                                                                                               ';
		html+= '               </tr>                                                                                                                              ';		
		html+= '            </table>                                                                                                                               ';
		html+= '        </div>                                                                                                                                                       ';
		html+= '    </div>                                                                                                                                                       ';
//		html+= '	<a href="javascript:;" class="btnClose"><img src="'+_g_contextPath_+'/images/erp/btn_erp_close.gif" width="13" height="13" alt="닫기" id="btnPopCancel"  /></a>           ';
		html+= '</div>                                                                                                                                                          ';
		
//		html +='<div class="erp_layaer ">                                                                                                                  ';
//		html +='	<ul class="erpInputList">                                                                                                                       ';
//		html +='    	                                                                                                                                            ';
//		html +='        <li><span>필요경비금액</span> <input type="text" style="width:135px;" class="etc_pop" id="pop_NDEP_AM" tabIndex="101" readonly="readonly" /> 원</li>                                                              ';
//		html +='        <li><span>소득금액</span> <input type="text" class="input_blue etc_pop " style="width:135px;" id="pop_INAD_AM"  tabIndex="102" readonly="readonly" /> 원</li>                                           ';
//		html +='        <li><span>소득세액</span> <input type="text" style="width:135px;" id="pop_INTX_AM" class="etc_pop"  tabIndex="102" readonly="readonly"  /> 원</li>                                                              ';
//		html +='        <li><span>주민세액</span> <input type="text" style="width:135px;" id="pop_RSTX_AM" class="etc_pop"  tabIndex="103" readonly="readonly" /> 원</li>                                                          ';
//		html +='        <li><span>귀속년월</span> <input type="text" style="width:35px" id="pop_ETCRVRS_YM_YYYY" maxlength="4" class="etc_pop"  tabIndex="104"readonly="readonly" /> 년       ';
//		html +='								<input type="text" style="width:20px;" maxlength="2" id="pop_ETCRVRS_YM_MM" class="etc_pop"  tabIndex="105" part="etcpop" readonly="readonly" /> 월</li>                  														 ';
//		html +='    </ul>                                                                                                                                         ';
//		html +='	<a href="javascript:;" class="btnClose"><img src="'+_g_contextPath_+'/images/erp/btn_erp_close.gif" width="13" height="13" alt="닫기" id="btnPopCancel" /></a>                             ';
//		html +='</div>                                                                                                                                            ';
		html +='                                                                                                                                                  ';
		html +='<!-- //layer0 -->                                                                                                             ';	 
	}else if(mode =="1"){
		
		html +='<!-- layer01 -->                                                                                                                                  ';
		html+= '<div class="pop_wrap layer_pop_etc">                                                                                                                               ';
		html+= '	<a href="javascript:;" class="clo" id="btnPopCancel"></a>           ';
		html+= '	<div class="pop_con mt10">                                                                                                                                     ';
		html+= '        <div class="com_ta">                                                                                                                               ';
		html+= '            <table>                                                                                                                               ';
		html+= '               <colgroup>                                                                                                                               ';
		html+= '                   <col width="120"/>                                                                                                                               ';
		html+= '                   <col width=""/>                                                                                                                               ';
		html+= '               </colgroup>                                                                                                                               ';
		html+= '               <tr>                                                                                                                               ';
		html+= '                  <th>'+NeosUtil.getMessage("TX000003541","지급총액")+'</th>                                                                                                                               ';
		html+= '                  <td><input type="text" style="width:210px;" id="pop_UNIT_AM" disabled="disabled"/> '+NeosUtil.getMessage("TX000000626","원")+'</td>                                             ';
		html+= '               </tr>                                                                                                                              ';
		html+= '               <tr>                                                                                                                               ';
		html+= '                  <th>'+NeosUtil.getMessage("TX000004265","소득세액")+'</th>                                                                                                                               ';
		html+= '                  <td><input type="text" style="width:210px;" id="pop_INTX_AM" class="etc_pop"  tabIndex="101"/> '+NeosUtil.getMessage("TX000000626","원")+'</td>                                             ';
		html+= '               </tr>                                                                                                                              ';
		html+= '               <tr>                                                                                                                               ';
		html+= '                  <th>'+NeosUtil.getMessage("TX000004267","주민세액")+'</th>                                                                                                                               ';
		html+= '                  <td><input type="text" style="width:210px;" id="pop_RSTX_AM" class="etc_pop"  tabIndex="102"/> '+NeosUtil.getMessage("TX000000626","원")+'</td>                                             ';
		html+= '               </tr>                                                                                                                              ';
		html+= '               <tr>                                                                                                                               ';
		html+= '                  <th>'+NeosUtil.getMessage("TX000005531","기타공제액")+'</th>                                                                                                                               ';
		html+= '                  <td><input type="text" style="width:210px;" id="pop_WD_AM" class="etc_pop"  tabIndex="103"/> '+NeosUtil.getMessage("TX000000626","원")+'</td>                                             ';
		html+= '               </tr>                                                                                                                              ';
		html+= '               <tr>                                                                                                                               ';
		html+= '                  <th>'+NeosUtil.getMessage("TX000003537","귀속년월")+'</th>                                                                                                                               ';
		html+= '                  <td><input type="text" value="" style="width:63px;" id="pop_ETCRVRS_YM_YYYY" maxlength="4" class="etc_pop"  tabIndex="104"/> '+NeosUtil.getMessage("TX000000435","년")+' <input type="text" value="" style="width:30px;" id="pop_ETCRVRS_YM_MM" maxlength="2" class="etc_pop"  tabIndex="105"  part="paypop"/> '+NeosUtil.getMessage("TX000000436","월")+'</td>                                                                                                                               ';
		html+= '               </tr>                                                                                                                              ';		
		html+= '            </table>                                                                                                                               ';
		html+= '        </div>                                                                                                                                                       ';
		html+= '    </div>                                                                                                                                                       ';
//		html+= '	<a href="javascript:;" class="btnClose"><img src="'+_g_contextPath_+'/images/erp/btn_erp_close.gif" width="13" height="13" alt="닫기" id="btnPopCancel"  /></a>           ';
		html+= '</div>                                                                                                                                                          ';
		
		
//		
//		html +='<div class="erp_layaer ">                                                                                                                  ';
//		html +='	<ul class="erpInputList">                                                                                                                       ';
//		html +='        <li><span>지급총액</span> <input type="text" style="width:135px;" class="input_blue" id="pop_UNIT_AM" disabled="disabled"/> 원</li>                                                              ';
//		html +='        <li><span>소득세액</span> <input type="text" style="width:135px;" id="pop_INTX_AM" class="etc_pop"  tabIndex="101" /> 원</li>                                                              ';
//		html +='        <li><span>주민세액</span> <input type="text" style="width:135px;" id="pop_RSTX_AM" class="etc_pop"  tabIndex="102" /> 원</li>                                                          ';
//		html +='        <li><span>기타공제액</span> <input type="text" style="width:135px;" id="pop_WD_AM"  class="etc_pop" tabIndex="103" /> 원</li>                                           ';
//		html +='        <li><span>귀속년월</span> <input type="text" style="width:35px" id="pop_ETCRVRS_YM_YYYY" maxlength="4" class="etc_pop"  tabIndex="104"/> 년       ';
//		html +='								<input type="text" style="width:20px;" maxlength="2" id="pop_ETCRVRS_YM_MM" class="etc_pop"  tabIndex="105" part="paypop" /> 월</li>                  														 ';
//		html +='    </ul>                                                                                                                                         ';
//		html +='	<a href="javascript:;" class="btnClose"><img src="'+_g_contextPath_+'/images/erp/btn_erp_close.gif" width="13" height="13" alt="닫기" id="btnPopCancel" /></a>                             ';
//		html +='</div>                                                                                                                                            ';
		html +='                                                                                                                                                  ';
		html +='<!-- //layer01 -->                                                                                                             ';	 
	}
	else{
		html+= '<!-- layer02 -->                                                                                                                                                ';
		html+= '<div class="pop_wrap layer_pop_etc">                                                                                                                               ';
		html+= '	<a href="javascript:;" class="clo" id="btnPopCancel"></a>           ';
		html+= '	<div class="pop_con mt10">                                                                                                                                     ';
		html+= '        <div class="com_ta">                                                                                                                               ';
		html+= '            <table>                                                                                                                               ';
		html+= '               <colgroup>                                                                                                                               ';
		html+= '                   <col width="120"/>                                                                                                                               ';
		html+= '                   <col width=""/>                                                                                                                               ';
		html+= '               </colgroup>                                                                                                                               ';
		html+= '               <tr>                                                                                                                               ';
		html+= '                  <th>'+NeosUtil.getMessage("TX000005330","소득구분")+'</th>                                                                                                                               ';
		html+= '                  <td><input class="k-textbox input_search fl etc_pop" type="text" value="" style="width:100px;" placeholder="" id="pop_CTD_CD" tabIndex="101"/>';
		html+=' <a href="#" class="btn_search fl" style="margin-left:-1px;" id="search-Event-T-etc"></a><input class="fl ml30 etc_pop" type="text" value="" style="width:95px;"  id="pop_CTD_NM" tabIndex="102"/></td>                                                                                                                               ';
		html+= '               </tr>                                                                                                                              ';
		html+= '               <tr>                                                                                                                               ';
		html+= '                  <th>'+NeosUtil.getMessage("TX000009413","필요경비율")+'</th>                                                                                                                               ';
		html+= '                  <td><input type="text" style="width:63px;" class="etc_pop" tabIndex="102" id="etc_percent" disabled="disabled"/> %</td>                                                                                                                               ';
		html+= '               </tr>                                                                                                                              ';
		html+= '               <tr>                                                                                                                               ';
		html+= '                  <th>'+NeosUtil.getMessage("TX000004264","필요경비금액")+'</th>                                                                                                                               ';
		html+= '                  <td><input type="text" style="width:210px;"  id="pop_NDEP_AM" class="etc_pop" tabIndex="103"/> '+NeosUtil.getMessage("TX000000626","원")+'</td>                                                                                                                               ';
		html+= '               </tr>                                                                                                                              ';
		html+= '               <tr>                                                                                                                               ';
		html+= '                  <th>'+NeosUtil.getMessage("TX000004266","소득금액")+'</th>                                                                                                                               ';
		html+= '                  <td><input type="text" style="width:210px;" id="pop_INAD_AM" /> '+NeosUtil.getMessage("TX000000626","원")+'</td>                                                                                                                               ';
		html+= '               </tr>                                                                                                                              ';
		html+= '               <tr>                                                                                                                               ';
		html+= '                  <th>'+NeosUtil.getMessage("TX000004265","소득세액")+'</th>                                                                                                                               ';
		html+= '                  <td><input type="text" style="width:210px;" id="pop_INTX_AM" class="etc_pop"  tabIndex="104"  /> '+NeosUtil.getMessage("TX000000626","원")+'</td>                                                                                                                               ';
		html+= '               </tr>                                                                                                                              ';
		html+= '               <tr>                                                                                                                               ';
		html+= '                  <th>'+NeosUtil.getMessage("TX000004267","주민세액")+'</th>                                                                                                                               ';
		html+= '                  <td><input type="text" style="width:210px;"  id="pop_RSTX_AM" class="etc_pop"  tabIndex="105" /> '+NeosUtil.getMessage("TX000000626","원")+'</td>                                                                                                                               ';
		html+= '               </tr>                                                                                                                              ';
		html+= '               <tr>                                                                                                                               ';
		html+= '                  <th>'+NeosUtil.getMessage("TX000003537","귀속년월")+'</th>                                                                                                                               ';
		html+= '                  <td><input type="text" value="" style="width:63px;" id="pop_ETCRVRS_YM_YYYY" maxlength="4" class="etc_pop"  tabIndex="106"/> '+NeosUtil.getMessage("TX000000435","년")+' <input type="text" value="" style="width:30px;" id="pop_ETCRVRS_YM_MM" maxlength="2" class="etc_pop"  tabIndex="107"  part="etcpop"/> '+NeosUtil.getMessage("TX000000436","월")+'</td>                                                                                                                               ';
		html+= '               </tr>                                                                                                                              ';
//		html+= '    	<li><span>소득구분</span> <input type="text" style="width:30px;" id="pop_CTD_CD" tabIndex="101" /> <a href="javascript:;" id="search-Event-T-etc"><img src="'+_g_contextPath_+'/Images/ico/ico_explain.png"   alt="검색" /></a>             ';
//		html+= '    														<input type="text" class="input_blue etc_pop" style="width:95px;" id="pop_CTD_NM" tabIndex="102"/></li>                                   ';
//		html+= '        <li><span>필요경비율</span> <input type="text" style="width:40px;" class="input_gray etc_pop" tabIndex="102" id="etc_percent" disabled="disabled"/> %</li>                                                        ';
//		html+= '        <li><span>필요경비금액</span> <input type="text" style="width:135px;"  id="pop_NDEP_AM" class="etc_pop" tabIndex="103"/> 원</li>                                                                        ';
//		html+= '        <li><span>소득금액</span> <input type="text" style="width:135px;" id="pop_INAD_AM" class="input_blue" /> 원</li>                                                         ';
//		html+= '        <li><span>소득세액</span> <input type="text" style="width:135px;" id="pop_INTX_AM" class="etc_pop"  tabIndex="104"  /> 원</li>                                                                            ';
//		html+= '        <li><span>주민세액</span> <input type="text" style="width:135px;"  id="pop_RSTX_AM" class="etc_pop"  tabIndex="105" /> 원</li>                                                                            ';
//		html+= '        <li><span>귀속년월</span> <input type="text" style="width:35px" id="pop_ETCRVRS_YM_YYYY" maxlength="4" class="etc_pop"  tabIndex="106"/> 년             ';
//		html+= '        							<input type="text" style="width:20px;" maxlength="2" id="pop_ETCRVRS_YM_MM" class="etc_pop"  tabIndex="107" part="etcpop" /> 월</li>      ';
		html+= '            </table>                                                                                                                               ';
		html+= '        </div>                                                                                                                                                       ';
		html+= '    </div>                                                                                                                                                       ';
//		html+= '	<a href="javascript:;" class="btnClose"><img src="'+_g_contextPath_+'/images/erp/btn_erp_close.gif" width="13" height="13" alt="닫기" id="btnPopCancel"  /></a>           ';
		html+= '</div>                                                                                                                                                          ';
//		html+= '                                                                                                                                                                ';
		html+= '<!-- //layer01 -->                                                                                                                                              ';
	}

	return html;
};

  

