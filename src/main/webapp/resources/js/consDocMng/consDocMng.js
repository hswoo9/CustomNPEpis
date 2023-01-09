var consDocMng = {};
var budgetList;
var budgetTemp;
var erpProjectListTemp;
var erpBudgetListTemp;
var budgetAmtInfo;
var modBudgetList;
var budgetTrTemp;

// 예산관리 초기화
consDocMng.init = function(){
	consDocMng.htmlInit();
	consDocMng.popUpInit();
	consDocMng.datePickerInit();
	consDocMng.eventHandlerMapping();
};

consDocMng.htmlInit = function(){
	var html = '';
	html += '<!-- 예산내역 변경 팝업 -->';
	html += '<div class="pop_wrap_dir" id="consDocModPopUp">';
	html += '	<div class="pop_con">';
	html += '		<p class="tit_p mt5 mb0">변경 전 예산</p>';
	html += '		<input type="hidden" id="consDocSeq"/>';
	html += '		<div id="" class="com_ta2 sc_head" style="background: #f9f9f9;border-top: 1px solid #eaeaea;">';
	html += '			<table style="border-top:none;">';
	html += '				<colgroup>';
	html += '					<col width="30">';
	html += '					<col width="30">';
	html += '					<col width="80">';
	html += '					<col width="120">';
	html += '					<col width="100">';
	html += '					<col width="100">';
	html += '					<col width="80">';
	html += '					<col width="80">';
	html += '					<col width="80">';
	html += '					<col width="110">';
	html += '				</colgroup>';
	html += '				<thead>';
	html += '					<tr>';
	html += '						<th>NO</th>';
	html += '						<th>변경횟수 </th>';
	html += '						<th>품의일자 </th>';
	html += '						<th>프로젝트 </th>';
	html += '						<th>예산과목 </th>';
	html += '						<th>회계단위 </th>';
	html += '						<th>품의금액 </th>';
	html += '						<th>지출금액 </th>';
	html += '						<th>잔여금액 </th>';
	html += '						<th>변경여부 </th>';
	html += '					</tr>';
	html += '				</thead>';
	html += '			</table>';
	html += '		</div>';
	html += '		<div class="com_ta2 ova_sc2 cursor_p bg_lightgray" style="height:200px;">';
	html += '			<table>';
	html += '				<colgroup>';
	html += '					<col width="30">';
	html += '					<col width="30">';
	html += '					<col width="80">';
	html += '					<col width="120">';
	html += '					<col width="100">';
	html += '					<col width="100">';
	html += '					<col width="80">';
	html += '					<col width="80">';
	html += '					<col width="80">';
	html += '					<col width="110">';
	html += '				</colgroup>';
	html += '				<tbody id="tblBudgetListDataBefore"></tbody>';
	html += '			</table>';
	html += '		</div>';
	html += '	</div>';
	html += '	<div class="pop_con">	';
	html += '		<p class="tit_p mt5 mb0">변경 후 예산</p>';
	html += '		<div id="" class="com_ta2 sc_head" style="background: #f9f9f9;border-top: 1px solid #eaeaea;">';
	html += '			<table style="border-top: none;">';
	html += '				<colgroup>';
	html += '					<col width="30">';
	html += '					<col width="125">';
	html += '					<col width="125">';
	html += '					<col width="125">';
	html += '					<col width="125">';
	html += '					<col width="125">';
	html += '					<col width="125">';
	html += '					<col width="90">';
	html += '				</colgroup>';
	html += '				<thead>';
	html += '					<tr>';
	html += '						<th rowspan="2">NO</th>';
	html += '						<th colspan="3">변경 전</th>';
	html += '						<th colspan="3">변경 후</th>';
	html += '						<th rowspan="2"></th>';
	html += '					</tr>';
	html += '					<tr>';
	html += '						<th>프로젝트 </th>';
	html += '						<th>예산과목 </th>';
	html += '						<th>잔여금액 </th>';
	html += '						<th>프로젝트 </th>';
	html += '						<th>예산과목 </th>';
	html += '						<th>잔여금액 </th>';
	html += '					</tr>';
	html += '				</thead>';
	html += '			</table>';
	html += '		</div>';
	html += '		<div class="com_ta2 ova_sc2 cursor_p bg_lightgray" style="height:200px;">';
	html += '			<table>';
	html += '				<colgroup>';
	html += '					<col width="30">';
	html += '					<col width="125">';
	html += '					<col width="125">';
	html += '					<col width="125">';
	html += '					<col width="125">';
	html += '					<col width="125">';
	html += '					<col width="125">';
	html += '					<col width="90">';
	html += '				</colgroup>';
	html += '				<tbody id="tblBudgetListDataAfter"></tbody>';
	html += '			</table>';
	html += '		</div>';
	html += '	</div>';
	html += '	<div class="pop_foot">';
	html += '		<div class="btn_cen pt12">';
	html += '			<input type="button" class="" id="consDocModifyBtn" value="저장" />';
	html += '		</div>';
	html += '	</div>';
	html += '</div>	';
	html += '<!-- 예산내역 변경 팝업 -->';
	html += '';
	html += '<!-- 예산변경 팝업 -->';
	html += '<div class="pop_wrap_dir" id="consBudgetModPopUp">';
	html += '	<div class="pop_con">';
	html += '		<div class="btn_div mb0 mt0">';
	html += '			<div class="left_div p0">';
	html += '				<p class="tit_p fl mt5 mb0">예산내역</p>';
	html += '			</div>';
	html += '			<div class="right_div controll_btn p0">';
	html += '				<button type="button" id="budgetAddBtn" onclick=";" class="k-button">추가</button>';
	html += '			</div>';
	html += '		</div>';
	html += '		<div id="" class="com_ta2 sc_head" style="background: #f9f9f9;border-top: 1px solid #eaeaea;">';
	html += '			<table>';
	html += '				<colgroup>';
	html += '					<col width="">';
	html += '					<col width="">';
	html += '					<col width="200">';
	html += '					<col width="70">';
	html += '				</colgroup>';
	html += '				<thead>';
	html += '					<tr>';
	html += '						<th>프로젝트 </th>';
	html += '						<th>예산과목 </th>';
	html += '						<th>잔여금액 </th>';
	html += '						<th></th>';
	html += '					</tr>';
	html += '				</thead>';
	html += '			</table>';
	html += '		</div>';
	html += '		<div id="" class="com_ta2 ova_sc2 cursor_p bg_lightgray" style="height:100px;">';
	html += '			<table>';
	html += '				<colgroup>';
	html += '					<col width="">';
	html += '					<col width="">';
	html += '					<col width="200">';
	html += '					<col width="70">';
	html += '				</colgroup>';
	html += '				<tbody id="tblBudgetListData">';
	html += '				</tbody>';
	html += '			</table>';
	html += '		</div>';
	html += '		<div id="" class="com_ta2">';
	html += '			<table>';
	html += '				<colgroup>';
	html += '					<col width="70">';
	html += '					<col width="">';
	html += '					<col width="70">';
	html += '					<col width="">';
	html += '					<col width="70">';
	html += '					<col width="">';
	html += '					<col width="70">';
	html += '					<col width="">';
	html += '				</colgroup>';
	html += '				<thead>';
	html += '					<tr>';
	html += '						<th>예산금액 </th>';
	html += '						<td><span id="txtOpenAmt"></span></td>';
	html += '						<th>품의잔액 </th>';
	html += '						<td><span id="txtConsBalanceAmt"></span></td>';
	html += '						<th>집행금액 </th>';
	html += '						<td><span id="txtResApplyAmt"></span></td>';
	html += '						<th>예산잔액 </th>';
	html += '						<td><span id="txtBalanceAmt"></span></td>';
	html += '					</tr>';
	html += '				</thead>';
	html += '			</table>';
	html += '		</div>';
	
	if(consDocMng.contractYN === 'Y'){
		html += '		<div class="btn_div mb0">';
		html += '			<div class="left_div p0">';
		html += '				<p class="tit_p fl mt5 mb0">결제내역</p>';
		html += '			</div>';
		html += '			<div class="right_div controll_btn p0">';
		html += '				<button type="button" id="tradeAddBtn" onclick=";" class="k-button">추가</button>'
		html += '			</div>';
		html += '		</div>';
		var colgroupStr = '';
		var theadStr = '';
		if(consDocMng.purcReqTypeCodeId === '3'){
			colgroupStr += '					<col width="">';
			colgroupStr += '					<col width="">';
			colgroupStr += '					<col width="">';
			colgroupStr += '					<col width="">';
			colgroupStr += '					<col width="70">';
			theadStr += '						<th>공사명 </th>';
			theadStr += '						<th>공사내용 </th>';
			theadStr += '						<th>금액 </th>';
			theadStr += '						<th>비고 </th>';
			theadStr += '						<th> </th>';
		}else if(consDocMng.purcReqTypeCodeId === '4'){
			colgroupStr += '					<col width="">';
			colgroupStr += '					<col width="">';
			colgroupStr += '					<col width="">';
			colgroupStr += '					<col width="">';
			colgroupStr += '					<col width="70">';
			theadStr += '						<th>용역명 </th>';
			theadStr += '						<th>용역내용 </th>';
			theadStr += '						<th>금액 </th>';
			theadStr += '						<th>비고 </th>';
			theadStr += '						<th> </th>';
		}else{
			colgroupStr += '					<col width="">';
			colgroupStr += '					<col width="">';
			colgroupStr += '					<col width="">';
			colgroupStr += '					<col width="">';
			colgroupStr += '					<col width="">';
			colgroupStr += '					<col width="">';
			colgroupStr += '					<col width="70">';
			theadStr += '						<th>품명 </th>';
			theadStr += '						<th>수량 </th>';
			theadStr += '						<th>규격 </th>';
			theadStr += '						<th>단가 </th>';
			theadStr += '						<th>금액 </th>';
			theadStr += '						<th>비고 </th>';
			theadStr += '						<th> </th>';
		}
		html += '		<div id="" class="com_ta2 sc_head" style="background: #f9f9f9;border-top: 1px solid #eaeaea;">';
		html += '			<table style="border-top: none;">';
		html += '				<colgroup>';
		html += colgroupStr;
		html += '				</colgroup>';
		html += '				<thead>';
		html += '					<tr>';
		html += theadStr;
		html += '					</tr>';
		html += '				</thead>';
		html += '			</table>';
		html += '		</div>';
		html += '		<div class="com_ta2 ova_sc2 cursor_p bg_lightgray" style="height:200px;">';
		html += '			<table>';
		html += '				<colgroup>';
		html += colgroupStr;
		html += '				</colgroup>';
		html += '				<tbody id="tblTradeListData"></tbody>';
		html += '			</table>';
		html += '		</div>';
	}
	
	html += '	</div>';
	html += '	<div class="pop_foot">';
	html += '		<div class="btn_cen pt12">';
	html += '			<input type="button" class="" id="consBudgetModifyBtn" value="반영" />';
	html += '		</div>';
	html += '	</div>';
	html += '</div>	';
	html += '<!-- 예산변경 팝업 -->';
	html += '<!-- 프로젝트 팝업 -->';
	html += '<div class="pop_wrap_dir" id="projectPopUp">';
	html += '	<div class="pop_con">';
	html += '		<div class="top_box" style="overflow: hidden;">';
	html += '			<dl class="dl2">';
	html += '				<dt class="mt2">구분</dt>';
	html += '				<dd>';
	html += '					<select id="selProjectStat" style="width: 115px;">';
	html += '						<option value="1,0">사용</option>';
	html += '						<option value="">전체(미사용포함)</option>';
	html += '						<option value="1">진행</option>';
	html += '						<option value="0">완료</option>';
	html += '					</select>';
	html += '				</dd>';
	html += '				<dt class="mt2">연도</dt>';
	html += '				<dd>';
	html += '					<input type="text" id="pjtFromDate" style="width: 70px;"/>~';
	html += '				</dd>';
	html += '				<dd>';
	html += '					<input type="text" id="pjtToDate" style="width: 70px;"/>';
	html += '				</dd>';
	html += '				<dd>';
	html += '					<input type="button" id="pjt_Search_btn" value="조회">';
	html += '				</dd>';
	html += '		</div>';
	html += '		<div id="" class="com_ta2 mt10 ova_sc_all" style="height: 340px;">';
	html += '			<table id="projectTable">';
	html += '				<colgroup>';
	html += '					<col width="30%">';
	html += '					<col width="70%">';
	html += '				</colgroup>';
	html += '				<thead>';
	html += '					<tr>';
	html += '						<th>프로젝트 코드</th>';
	html += '						<th>프로젝트 명</th>';
	html += '					</tr>';
	html += '					<tr>';
	html += '						<td><input type="text" id="schPjtSeq" style="width: 90%;"/></td>';
	html += '						<td><input type="text" id="schPjtName" style="width: 90%;"/></td>';
	html += '					</tr>';
	html += '				</thead>';
	html += '				<tbody></tbody>';
	html += '			</table>';
	html += '		</div>';
	html += '	</div>';
	html += '</div>	';
	html += '<!-- 프로젝트 팝업 -->';
	html += '<!-- 예산 팝업 -->';
	html += '<div class="pop_wrap_dir" id="budgetPopUp">';
	html += '	<div class="pop_con">';
	html += '		<div class="top_box" style="overflow: hidden;" id="Budget_Search">';
	html += '            <dl class="next">';
	html += '                <dt style="width:100px;" class="en_w145">';
	html += '                         예산과목표시 :';
	html += '                 </dt>';
	html += '                 <dd>                         ';
	html += '                        <input type="radio" name="OPT_01" value="2" id="OPT_01_2" class="k-radio " checked="checked" style="visibility: hidden;">';
	html += '                        <label class="k-radio-label" for="OPT_01_2" style=";">당기 편성된 예산과목만 표시</label>';
	html += '                  </dd>';
	html += '                  <dd>      ';
	html += '                        <input type="radio" name="OPT_01" value="1" id="OPT_01_1" class="k-radio" style="visibility: hidden;">';
	html += '                        <label class="k-radio-label" for="OPT_01_1" style="">모든 예산과목 표시</label>';
	html += '                  </dd>';
	html += '                  <dd class="en_mt3">      ';
	html += '                        <input type="radio" name="OPT_01" value="3" id="OPT_01_3" class="k-radio" style="visibility: hidden;">';
	html += '                        <label class="k-radio-label" for="OPT_01_3" style="">프로젝트 기간 예산 편성된 과목만 표시</label>';
	html += '                  </dd>';
	html += '            </dl>';
	html += '            <dl class="next2 en_mt0">';
	html += '                <dt style="width:100px;" class="en_w145">';
	html += '                         사용기한 : ';
	html += '                </dt>';
	html += '                <dd> ';
	html += '                        <input type="radio" name="OPT_02" value="1" id="OPT_02_1" class="k-radio" checked="checked" style="visibility: hidden;">';
	html += '                        <label class="k-radio-label" for="OPT_02_1" style="">모두표시</label>';
	html += '                        <input type="radio" name="OPT_02" value="2" id="OPT_02_2" class="k-radio" style="visibility: hidden;">';
	html += '                        <label class="k-radio-label" for="OPT_02_2" style="">사용기한경과분 숨김</label>';
	html += '                                ';
	html += '            </dd></dl>';
	html += '            <div class="mt14 ar text_blue posi_ab" id="deptEmp_SearchHint" style="bottom:10px;right:10px;display:none;">※ 아래 (  ) 안에 명칭은 ERP 예산단계를 의미합니다.</div>            ';
	html += '        </div>';
	html += '		<div id="" class="com_ta2 mt10 ova_sc_all" style="height: 340px;">';
	html += '			<table id="budgetTable">';
	html += '				<colgroup>';
	html += '					<col width=""/>';
	html += '					<col width=""/>';
	html += '					<col width=""/>';
	html += '					<col width=""/>';
	html += '					<col width=""/>';
	html += '				</colgroup>';
	html += '				<thead>';
	html += '					<tr>';
	html += '						<th>관</th>';
	html += '						<th>항</th>';
	html += '						<th>목</th>';
	html += '						<th>세</th>';
	html += '						<th>코드</th>';
	html += '					</tr>';
	html += '					<tr>';
	html += '						<td><input type="text" id="schBgt1Seq" style="width: 90%;"/></td>';
	html += '						<td><input type="text" id="schBgt2Seq" style="width: 90%;"/></td>';
	html += '						<td><input type="text" id="schBgt3Seq" style="width: 90%;"/></td>';
	html += '						<td><input type="text" id="schBgt4Seq" style="width: 90%;"/></td>';
	html += '						<td><input type="text" id="schBudgetSeq" style="width: 90%;"/></td>';
	html += '					</tr>';
	html += '				</thead>';
	html += '				<tbody></tbody>';
	html += '			</table>';
	html += '		</div>';
	html += '	</div>';
	html += '</div>	';
	html += '<!-- 예산 팝업 -->';

	$('body').append(html);
};

consDocMng.popUpInit = function(){
	$("#consDocModPopUp").kendoWindow({
		title: "예산내역 변경",
	    width: "1000px",
	    visible: false,
	    actions: ["Close"],
	    draggable: false,
	    resizable: false,
	    modal: true,
	    animation: false,
	}).data("kendoWindow").center();
	$("#consBudgetModPopUp").kendoWindow({
		title: "예산변경",
	    width: "800px",
	    visible: false,
	    actions: ["Close"],
	    draggable: false,
	    resizable: false,
	    modal: true,
	    animation: false,
	}).data("kendoWindow").center();
	$("#projectPopUp").kendoWindow({
		title: "프로젝트",
	    width: "500px",
	    visible: false,
	    actions: ["Close"],
	    draggable: false,
	    resizable: false,
	    modal: true,
	    animation: false,
	}).data("kendoWindow").center();
	$("#budgetPopUp").kendoWindow({
		title: "예산정보",
	    width: "900px",
	    visible: false,
	    actions: ["Close"],
	    draggable: false,
	    resizable: false,
	    modal: true,
	    animation: false,
	}).data("kendoWindow").center();
	$('#selProjectStat').kendoDropDownList();
};

consDocMng.datePickerInit = function(){
	datePickerOpt = {
			depth: "decade",
		    start: "decade",
		    culture : "ko-KR",
			format : "yyyy",
			value : new Date(),
		};
	$('#pjtFromDate').kendoDatePicker(datePickerOpt);
	$('#pjtToDate').kendoDatePicker(datePickerOpt);
};

consDocMng.eventHandlerMapping = function(){
	
	$('#pjt_Search_btn').on({
		click: consDocMng.fnGetProjectList,
	});
	$('#schPjtSeq, #schPjtName').on({
		keyup: function(e){
			if(e.keyCode === 13){
				consDocMng.fnSetProcjectList();
			}
		}
	});
	
	$('input:radio[name=OPT_01], input:radio[name=OPT_02]').on({
		change: consDocMng.fnGetBudgetList,
	});
	$('#schBgt1Seq, #schBgt2Seq, #schBgt3Seq, #schBgt4Seq, #schBudgetSeq').on({
		keyup: function(e){
			if(e.keyCode === 13){
				consDocMng.fnSetBudgetList();
			}
		}
	});
	
	$('#consBudgetModifyBtn').on({
		click: consDocMng.fnConsBudgetModify,
	})
	$('#consDocModifyBtn').on({
		click: fnConsDocModify,
	})
	
	$('#budgetAddBtn').on({
		click: function(){
			consDocMng.fnAddBudgetTr();
		}
	});
	$('#tradeAddBtn').on({
		click: function(){
			consDocMng.fnAddTradeTr();
		}
	});
};

// 계약체크
consDocMng.fnContractCheck = function(consDocSeq){
	$.ajax({
		url : _g_contextPath_+ "/consDocMng/checkContract",
		data : {consDocSeq: consDocSeq},
		type : "POST",
		async : false,
		success : function(result){
			if(result.result){
				consDocMng.fnPurcContModReq(result.result);
			}else{
				consDocMng.fnConsDocModPopUp(consDocSeq);
			}
		}
	});
}

// 예산내역 변경 팝업
consDocMng.fnConsDocModPopUp = function(consDocSeq){
	$.ajax({
		url : _g_contextPath_+ "/consDocMng/selectConsDocMngDList",
		data : {consDocSeq: consDocSeq},
		type : "POST",
		async : false,
		success : function(result){
			$('#tblBudgetListDataBefore').html('');
			$('#tblBudgetListDataAfter').html('');
			modBudgetList = new Array();
			$('#consDocSeq').val(consDocSeq);
			budgetList = result.list;
			$.each(budgetList, function(idx){
				this.index = idx+1;
				var tr = $('<tr>').attr('index', this.index);
				tr.append($('<td>').text(this.index));
				tr.append($('<td>').text(this.modCnt));
				tr.append($('<td>').text(this.consDate.toDate()));
				tr.append($('<td>').text(this.mgtName));
				tr.append($('<td>').text(this.erpBudgetName));
				tr.append($('<td>').text(this.erpDivName));
				tr.append($('<td>').text(this.budgetAmt.toString().toMoney()));
				tr.append($('<td>').text(this.resBudgetAmt.toString().toMoney()));
				tr.append($('<td>').text(this.balanceAmt.toString().toMoney()));
				if(this.modYN === 'Y'){
					tr.append($('<td>').text('변경'));
				}else if(this.leftYN === 'Y'){
					tr.append($('<td>').text('잔액조정'));
				}else if(this.confferBudgetReturnYN === 'Y'){
					tr.append($('<td>').text('반환'));
				}else{
					tr.append($('<td>').html('<span class="modBtn">아니오 <input type="button" value="변경" onclick="javascript:consDocMng.fnConsBudgetModPopUp(\'' + this.budgetSeq + '\')"></span><span class="modifing" style="display:none;">변경중</span'));
				}
				$('#tblBudgetListDataBefore').append(tr);
				
				if(consDocMng.consModSeq){
					var budgetSeq = this.budgetSeq;
					var modBudgetListTemp = consDocMng.modBudgetListTemp.filter(function(obj){return obj.budgetSeqBefore === budgetSeq;});
					if(modBudgetListTemp.length > 0){
						var modBudgetTemp = Object.assign({}, this);
						$.each(modBudgetListTemp, function(){
							var modBudgetTemp2 = this;
							modBudgetTemp.modMgtName = modBudgetTemp2.mgtName;
							modBudgetTemp.modMgtSeq = modBudgetTemp2.mgtSeq;
							modBudgetTemp.modErpBudgetName = modBudgetTemp2.erpBudgetName;
							modBudgetTemp.modErpBudgetSeq = modBudgetTemp2.erpBudgetSeq;
							modBudgetTemp.modErpBgt1Seq = modBudgetTemp2.erpBgt1Seq;
							modBudgetTemp.modErpBgt1Name = modBudgetTemp2.erpBgt1Name;
							modBudgetTemp.modErpBgt2Seq = modBudgetTemp2.erpBgt2Seq;
							modBudgetTemp.modErpBgt2Name = modBudgetTemp2.erpBgt2Name;
							modBudgetTemp.modErpBgt3Seq = modBudgetTemp2.erpBgt3Seq;
							modBudgetTemp.modErpBgt3Name = modBudgetTemp2.erpBgt3Name;
							modBudgetTemp.modErpBgt4Seq = modBudgetTemp2.erpBgt4Seq;
							modBudgetTemp.modErpBgt4Name = modBudgetTemp2.erpBgt4Name;
							modBudgetTemp.modBalanceAmt = modBudgetTemp2.budgetAmt;
							modBudgetTemp.modTradeList = modBudgetTemp2.modTradeList;
							consDocMng.fnSetConsBudgetModify(modBudgetTemp);
						});
					}
				}
			});
			$("#consDocModPopUp").data('kendoWindow').open();
		}
	});
};

// 예산변경 가능여부 체크
consDocMng.fnCheckConsBudgetModify = function(){
	var returnVal = true;
	
	// 결재중인 결의서 체크
	if(returnVal){
		$.ajax({
			url : _g_contextPath_+ "/consDocMng/checkConsBudgetModify",
			data : {consDocSeq: $('#consDocSeq').val()},
			type : "POST",
			async : false,
			success : function(result){
				if(result.cnt > 0){
					alert('결재중(임시저장)인 결의서가 있습니다.\n결재완료(반려/회수) 후 예산을 변경하세요.');
					returnVal = false;
				}
			}
		});
	}
	return returnVal;
};

// 예산변경 팝업
consDocMng.fnConsBudgetModPopUp = function(budgetSeq){
	if(!consDocMng.fnCheckConsBudgetModify()){
		return;
	}
	var budget = budgetList.filter(function(data){
		return data.budgetSeq == budgetSeq;
	});
	if(budget){
		$('#tblBudgetListData tr').remove();
		var tr = consDocMng.fnAddBudgetTr();
		budgetTemp = budget[0];
		$('.txtProject', tr).val(budgetTemp.mgtName);
		$('.txtErpBudget', tr).val(budgetTemp.erpBudgetName);
		$('.txtAmt', tr).val(budgetTemp.balanceAmt.toString().toMoney());
		$('.mgtName', tr).val(budgetTemp.mgtName);
		$('.mgtSeq', tr).val(budgetTemp.mgtSeq);
		if(modBudgetList.filter(function(obj){console.log(obj); return obj.modMgtSeq == $('.mgtSeq', tr).val() && obj.modErpBudgetSeq == budgetTemp.erpBudgetSeq}).length === 0){
			$('.erpBudgetName', tr).val(budgetTemp.erpBudgetName);
			$('.erpBudgetSeq', tr).val(budgetTemp.erpBudgetSeq);
			$('.erpBgt1Name', tr).val(budgetTemp.erpBgt1Name);
			$('.erpBgt1Seq', tr).val(budgetTemp.erpBgt1Seq);
			$('.erpBgt2Name', tr).val(budgetTemp.erpBgt2Name);
			$('.erpBgt2Seq', tr).val(budgetTemp.erpBgt2Seq);
			$('.erpBgt3Name', tr).val(budgetTemp.erpBgt3Name);
			$('.erpBgt3Seq', tr).val(budgetTemp.erpBgt3Seq);
			$('.erpBgt4Name', tr).val(budgetTemp.erpBgt4Name);
			$('.erpBgt4Seq', tr).val(budgetTemp.erpBgt4Seq);
		}else{
			$('.txtErpBudget', tr).val('');
			$('.erpBudgetName', tr).val('');
			$('.erpBudgetSeq', tr).val('');
			$('.erpBgt1Name', tr).val('');
			$('.erpBgt1Seq', tr).val('');
			$('.erpBgt2Name', tr).val('');
			$('.erpBgt2Seq', tr).val('');
			$('.erpBgt3Name', tr).val('');
			$('.erpBgt3Seq', tr).val('');
			$('.erpBgt4Name', tr).val('');
			$('.erpBgt4Seq', tr).val('');
		}
		tr.click();
		if(consDocMng.contractYN === 'Y'){
			consDocMng.fnGetTradeList();
		}
		$("#consBudgetModPopUp").data('kendoWindow').open();
	}
};

// 예산잔액 조회
consDocMng.fnGetBudgetInfo = function(params){
	var obj = {};
	
	obj.DIV_CD    = budgetTemp.erpDivSeq;
    obj.BGT_CD    = $('.erpBudgetSeq', budgetTrTemp).val();
    obj.MGT_CD    = $('.mgtSeq', budgetTrTemp).val();
    obj.SUM_CT_AM = 0;
    obj.GISU_DT   = budgetTemp.consDate;
    obj.BOTTOM_CD = budgetTemp.bottomSeq;
    obj.DOCU_MODE = 0;
    obj.CO_CD     = budgetTemp.erpCompSeq;
    obj.FROM_DT   = budgetTemp.erpGisuFromDate;
    obj.TO_DT     = budgetTemp.erpGisuToDate;
    obj.GISU      = budgetTemp.erpGisu;
    
    /* G20 2.0 파라미터 추가 */
    obj.consDocSeq   = $('#consDocSeq').val();
    obj.mgtSeq       = $('.mgtSeq', budgetTrTemp).val();
    obj.budgetSeq    = budgetTemp.budgetSeq
    obj.erpBudgetSeq = $('.erpBudgetSeq', budgetTrTemp).val();
    obj.gisu         = budgetTemp.erpGisu;
    obj.bottomSeq    = budgetTemp.bottomSeq;

    /* G20 2.0 파라미터 추가 */

	if(params){
		obj.BGT_CD = params.erpBudgetSeq;
		obj.MGT_CD = params.mgtSeq;
		obj.mgtSeq = params.mgtSeq;
		obj.erpBudgetSeq = params.erpBudgetSeq;
	}
	
	$.ajax({
		url : _g_contextPath_+ "/Ac/G20/Ex/getBudgetInfo.do",
		data : obj,
		type : "POST",
		async : false,
		success : function(returnObj){
			var result = returnObj.result;
			$("#txtOpenAmt").html((result.OPEN_AM || "0").toString().toMoney());
        	$("#txtResApplyAmt").html((result.APPLY_AM || "0").toString().toMoney());
        	$("#txtConsBalanceAmt").html((result.REFER_AM || "0").toString().toMoney());
        	$("#txtBalanceAmt").html((result.LEFT_AM || ")").toString().toMoney());
			budgetAmtInfo = result;
		}
	});
};

// 예산 추가
consDocMng.fnAddBudgetTr = function(){
	var tr = $('<tr>');
	tr.attr('index', (moment().format('YYYYMMDDhhmmss') + Math.random()).replace('.', ''));
	var html = '';
	html += '						<td>';
	html += '							<input type="text" class="txtProject" style="width: 85%;" readonly="readonly"/>';
	html += '							<a href="javascript:;" class=""><img src="' + _g_contextPath_ + '/Images/ico/ico_explain.png" alt="검색" title="검색"></a>';
	html += '							<input type="hidden" class="mgtName"/>';
	html += '							<input type="hidden" class="mgtSeq"/>';
	html += '						</td>';
	html += '						<td>';
	html += '							<input type="text" class="txtErpBudget" style="width: 85%;" readonly="readonly"/>';
	html += '							<a href="javascript:;" class=""><img src="' + _g_contextPath_ + '/Images/ico/ico_explain.png" alt="검색" title="검색"></a>';
	html += '							<input type="hidden" class="erpBudgetName"/>';
	html += '							<input type="hidden" class="erpBudgetSeq"/>';
	html += '							<input type="hidden" class="erpBgt1Name"/>';
	html += '							<input type="hidden" class="erpBgt1Seq"/>';
	html += '							<input type="hidden" class="erpBgt2Name"/>';
	html += '							<input type="hidden" class="erpBgt2Seq"/>';
	html += '							<input type="hidden" class="erpBgt3Name"/>';
	html += '							<input type="hidden" class="erpBgt3Seq"/>';
	html += '							<input type="hidden" class="erpBgt4Name"/>';
	html += '							<input type="hidden" class="erpBgt4Seq"/>';
	html += '						</td>';
	html += '						<td>';
	html += '							<input type="text" class="txtAmt" style="width: 90%;text-align: right;padding-right: 5px;"/>';
	html += '						</td>';
	html += '						<td>';
	html += '							<span class="controll_btn"><button class="k-button budgetDelBtn">삭제</button><span>';
	html += '						</td>';
	tr.append(html);
	consDocMng.fnBudgetTrEventHandlerMapping(tr);
	$('#tblBudgetListData').append(tr);
	if(consDocMng.contractYN === 'Y'){
		$('.txtAmt', tr).attr('readonly', true);
	}
	return tr;
};

consDocMng.fnBudgetTrEventHandlerMapping = function(tr){
	$(tr).on({
		click: function(){
			consDocMng.fnSelBudgetTr(tr);
		}
	});
	$('.txtProject', tr).on({
		dblclick: function(){
			consDocMng.fnGetProjectList(tr);
			$("#projectPopUp").data('kendoWindow').open();
		}
	}).next('a').on({
		click: function(){
			$('.txtProject', tr).dblclick();
		}
	});
	$('.txtErpBudget', tr).on({
		dblclick: function(){
			consDocMng.fnGetBudgetList(tr);
			$("#budgetPopUp").data('kendoWindow').open();
		}
	}).next('a').on({
		click: function(){
			$('.txtErpBudget', tr).dblclick();
		}
	});
	$('.txtAmt', tr).on({
		change: function(){
			$(this).val($(this).val().toMoney());
		}
	});
	$('.budgetDelBtn', tr).on({
		click: function(){
			$('#tblTradeListData tr[index=' + $(tr).attr('index') + ']').remove();
			tr.remove();
		}
	});
}

// 예산내역 행 선택
consDocMng.fnSelBudgetTr = function(tr){
	if($(tr).hasClass('on')){
		return;
	}
	budgetTrTemp = tr;
	$('#tblBudgetListData tr').removeClass('on');
	$(tr).addClass('on');
	consDocMng.fnGetBudgetInfo();
	$('#tblTradeListData tr').hide();
	$('#tblTradeListData tr[index=' + $(tr).attr('index') + ']').show();
};

// 채주목록 조회
consDocMng.fnGetTradeList = function(){
	var params = {};
	params.budgetSeq = budgetTemp.budgetSeq;
	params.purcContId = consDocMng.purcContId;
	$.ajax({
		url : _g_contextPath_+ "/consDocMng/getTreadList",
		data: JSON.stringify(params),
		dataType : 'json',
		contentType : 'application/json',
		type : "POST",
		async : false,
		success : function(returnObj){
			$('#tblTradeListData').html('');
			$.each(returnObj.result, function(){
				var tr = consDocMng.fnAddTradeTr();
				if(this.standard){
					$('.standard', tr).val(this.standard);
				}
				if(this.contents){
					$('.contents', tr).val(this.contents);
				}
				if(this.itemNm){
					$('.itemNm', tr).val(this.itemNm);
				}
				if(this.itemCnt){
					$('.itemCnt', tr).val(this.itemCnt.toString().toMoney());
				}
				if(this.itemAm){
					$('.itemAm', tr).val(this.itemAm.toString().toMoney());
				}
				if(this.unitAm){
					$('.unitAm', tr).val(this.unitAm.toString().toMoney());
				}
				if(this.tradeNote){
					$('.tradeNote', tr).val(this.tradeNote);
				}
			});
		}
	});
};

// 채주 추가
consDocMng.fnAddTradeTr = function(){
	var tr = $('<tr>');
	tr.attr('index', $('#tblBudgetListData tr.on').attr('index'));
	if(consDocMng.purcReqTypeCodeId === '3' || consDocMng.purcReqTypeCodeId === '4'){
		tr.append($('<td>').append($('<input type="text" class="itemNm">').css('width', '90%')));
		tr.append($('<td>').append($('<input type="text" class="contents">').css('width', '90%')));
		tr.append($('<td>').append($('<input type="text" class="unitAm number ri">').css('width', '80%')));
		tr.append($('<td>').append($('<input type="text" class="tradeNote">').css('width', '90%')));
		tr.append($('<td>').append($('<span class="controll_btn">').append($('<button class="k-button tradeDelBtn">삭제</button>'))));
		$('td:first', tr).append($('<input type="hidden" class="purcTrType" value="001">'));
	}else{
		tr.append($('<td>').append($('<input type="text" class="itemNm">').css('width', '90%')));
		tr.append($('<td>').append($('<input type="text" class="itemCnt number ri">').css('width', '80%')));
		tr.append($('<td>').append($('<input type="text" class="standard">').css('width', '90%')));
		tr.append($('<td>').append($('<input type="text" class="itemAm number ri">').css('width', '80%')));
		tr.append($('<td>').append($('<input type="text" class="unitAm number ri">').css('width', '80%')));
		tr.append($('<td>').append($('<input type="text" class="tradeNote">').css('width', '90%')));
		tr.append($('<td>').append($('<span class="controll_btn">').append($('<button class="k-button tradeDelBtn">삭제</button>'))));
		$('td:first', tr).append($('<input type="hidden" class="purcTrType" value="002">'));
	}
	consDocMng.fnTradeTrEventHandlerMapping(tr);
	$('#tblTradeListData').append(tr);
	return tr;
};

consDocMng.fnTradeTrEventHandlerMapping = function(tr){
	$('.number', tr).on({
		change: function(){
			$(this).val($(this).val().toMoney());
		}
	});
	$('.itemCnt, .itemAm', tr).on({
		change: function(){
			var itemCnt = parseInt($('.itemCnt', tr).val().toMoney2());
			var itemAm = parseInt($('.itemAm', tr).val().toMoney2());
			var unitAm = itemCnt * itemAm;
			$('.unitAm', tr).val(unitAm.toString().toMoney()).change();
		}
	});
	$('.unitAm', tr).on({
		change: function(){
			var index = $(tr).attr('index');
			var totalAm = 0;
			$.each($('.unitAm', $('#tblTradeListData tr[index= ' + index+ ' ]')), function(){
				totalAm += parseInt($(this).val().toMoney2());
			})
			$('.txtAmt', $('#tblBudgetListData tr[index=' + index + ']')).val(totalAm.toString().toMoney());
		}
	});
	$('.tradeDelBtn', tr).on({
		click: function(){
			$('.unitAm', tr).val('0').change();
			tr.remove();
		}
	});
}

// 프로젝트 리스트 조회
consDocMng.fnGetProjectList = function(tr){
	if(tr){
		budgetTrTemp = tr;
	}
	var params = {
			CO_CD: budgetTemp.erpCompSeq,
			EMP_CD: budgetTemp.erpEmpSeq,
			FG_TY: "2",
			erpPjtStatus: $('#selProjectStat').val(),
			pjtFromDate: $('#pjtFromDate').val() + "0101",
			pjtToDate: $('#pjtToDate').val() + "1231",
	};
	$.ajax({
		url : _g_contextPath_+ "/Ac/G20/Code/getErpMgtList.do",
		data : params,
		type : "POST",
		async : false,
		success : function(returnObj){
			erpProjectListTemp = returnObj.selectList;
			consDocMng.fnSetProcjectList(budgetTrTemp);
		}
	});
}

consDocMng.fnSetProcjectList = function(budgetTrTemp){
	$('#projectTable tbody').html('');
	$.each(erpProjectListTemp, function(idx){
		var PJT_CD = this.PJT_CD || '';
		var PJT_NM = this.PJT_NM || '';
		if(PJT_CD.indexOf($('#schPjtSeq').val()) > -1 && PJT_NM.indexOf($('#schPjtName').val()) > -1){
			var tr = $('<tr>').attr('index', idx).css('cursor', 'pointer');
			tr.append($('<td>').html(PJT_CD));
			tr.append($('<td>').html(PJT_NM));
			$('#projectTable tbody').append(tr);
		}
	});
	$('#projectTable tbody tr').on({
		dblclick: function(){
			var erpProjectTemp = erpProjectListTemp[$(this).attr("index")];
			if($('.mgtSeq', budgetTrTemp).val() !== erpProjectTemp.PJT_CD){
				$('.txtProject', budgetTrTemp).val(erpProjectTemp.PJT_NM);
				$('.mgtName', budgetTrTemp).val(erpProjectTemp.PJT_NM);
				$('.mgtSeq', budgetTrTemp).val(erpProjectTemp.PJT_CD);
				$('.txtErpBudget', budgetTrTemp).val('');
				$('.erpBudgetName', budgetTrTemp).val('');
				$('.erpBudgetSeq', budgetTrTemp).val('');
				$('.erpBgt1Name', budgetTrTemp).val('');
				$('.erpBgt1Seq', budgetTrTemp).val('');
				$('.erpBgt2Name', budgetTrTemp).val('');
				$('.erpBgt2Seq', budgetTrTemp).val('');
				$('.erpBgt3Name', budgetTrTemp).val('');
				$('.erpBgt3Seq', budgetTrTemp).val('');
				$('.erpBgt4Name', budgetTrTemp).val('');
				$('.erpBgt4Seq', budgetTrTemp).val('');
				$('.txtOpenAmt', budgetTrTemp).html('');
				$('.txtConsBalanceAmt', budgetTrTemp).html('');
				$('.txtResApplyAmt', budgetTrTemp).html('');
				$('.txtBalanceAmt', budgetTrTemp).html('');
			}
			$("#projectPopUp").data('kendoWindow').close();
		},
		click: function(){
			$('#projectTable tbody tr').removeClass('on');
			$(this).addClass('on');
		}
	});
};

// 예산정보 리스트 조회
consDocMng.fnGetBudgetList = function(tr){
	if(tr){
		budgetTrTemp = tr;
	}
	var params = {
			BOTTOM_CDS: "",
			BgtStep7UseYn: undefined,
			CO_CD: budgetTemp.erpCompSeq,
			DIV_CDS: budgetTemp.erpDivSeq + "|",
			FR_DT: budgetTemp.erpGisuFromDate,
			GISU: budgetTemp.erpGisu,
			GISU_DT: budgetTemp.consDate,
			GR_FG: "2",
			MGT_CDS: $('.mgtSeq', budgetTrTemp).val() + "|",
			OPT_01: $('input:radio[name=OPT_01]:checked').val(),
			OPT_02: $('input:radio[name=OPT_02]:checked').val(),
			OPT_03: "2",
			TO_DT: budgetTemp.erpGisuToDate,
	};
	$.ajax({
		url : _g_contextPath_+ "/Ac/G20/Code/getErpBudgetList.do",
		data : params,
		type : "POST",
		async : false,
		success : function(returnObj){
			erpBudgetListTemp = returnObj.selectList;
			consDocMng.fnSetBudgetList(budgetTrTemp);
		}
	});
}

consDocMng.fnSetBudgetList = function(budgetTrTemp){
	$('#budgetTable tbody').html('');
	$.each(erpBudgetListTemp, function(idx){
		var BGT01_NM = this.BGT01_NM || '';
		var BGT02_NM = this.BGT02_NM || '';
		var BGT03_NM = this.BGT03_NM || '';
		var BGT04_NM = this.BGT04_NM || '';
		var BGT_CD = this.BGT_CD || '';
		if(BGT01_NM.indexOf($('#schBgt1Seq').val()) > -1 && BGT02_NM.indexOf($('#schBgt2Seq').val()) > -1 && BGT03_NM.indexOf($('#schBgt3Seq').val()) > -1 && BGT04_NM.indexOf($('#schBgt4Seq').val()) > -1 && BGT_CD.indexOf($('#schBudgetSeq').val()) > -1){
			if(modBudgetList.filter(function(obj){console.log(obj); return obj.modMgtSeq == $('#mgtSeq').val() && obj.modErpBudgetSeq == BGT_CD}).length === 0){
				var tr = $('<tr>').attr('index', idx).css('cursor', 'pointer');
				tr.append($('<td>').html(BGT01_NM));
				tr.append($('<td>').html(BGT02_NM));
				tr.append($('<td>').html(BGT03_NM));
				tr.append($('<td>').html(BGT04_NM));
				tr.append($('<td>').html(BGT_CD));
				$('#budgetTable tbody').append(tr);
			}
		}
	});
	$('#budgetTable tbody tr').on({
		dblclick: function(){
			var erpBudgetTemp = erpBudgetListTemp[$(this).attr("index")];
			if($('.erpBudgetSeq', budgetTrTemp).val() !== erpBudgetTemp.BGT_CD){
				$('.txtErpBudget', budgetTrTemp).val(erpBudgetTemp.BGT_NM);
				$('.erpBudgetName', budgetTrTemp).val(erpBudgetTemp.BGT_NM);
				$('.erpBudgetSeq', budgetTrTemp).val(erpBudgetTemp.BGT_CD);
				$('.erpBgt1Name', budgetTrTemp).val(erpBudgetTemp.BGT01_NM);
				$('.erpBgt1Seq', budgetTrTemp).val(erpBudgetTemp.BGT01_CD);
				$('.erpBgt2Name', budgetTrTemp).val(erpBudgetTemp.BGT02_NM);
				$('.erpBgt2Seq', budgetTrTemp).val(erpBudgetTemp.BGT02_CD);
				$('.erpBgt3Name', budgetTrTemp).val(erpBudgetTemp.BGT03_NM);
				$('.erpBgt3Seq', budgetTrTemp).val(erpBudgetTemp.BGT03_CD);
				$('.erpBgt4Name', budgetTrTemp).val(erpBudgetTemp.BGT04_NM);
				$('.erpBgt4Seq', budgetTrTemp).val(erpBudgetTemp.BGT04_CD);
				consDocMng.fnGetBudgetInfo();
			}
			$("#budgetPopUp").data('kendoWindow').close();
		},
		click: function(){
			$('#budgetTable tbody tr').removeClass('on');
			$(this).addClass('on');
		}
	});
};

// 예산잔액 초과 체크
consDocMng.checkLeftAmt = function(params){
	var returnVal = true;
	consDocMng.fnGetBudgetInfo(params);
	var leftAmt = parseInt(budgetAmtInfo.LEFT_AM.toMoney2());
	var applyAmt = parseInt(params.amt.toMoney2());
	if(leftAmt >= applyAmt){
	}else{
		alert('예산을 초과 하였습니다. 확인해주세요.')
		returnVal = false;
	}
	return returnVal;
}

// 예산변경 유효성검사
consDocMng.fnConsBudgetModifyVal = function(){
	var returnVal = true;
	
	if(consDocMng.contractYN === 'Y'){
		if(returnVal){
			if($('#tblTradeListData tr').length === 0){
				alert('결제내역이 없습니다.');
				returnVal = false;
			}
		}
		if(returnVal){
			$.each($('#tblBudgetListData tr'), function(){
				if($('#tblTradeListData tr[index= ' + $(this).attr('index') + ' ]').length === 0){
					alert('결제내역이 없습니다.');
					returnVal = false;
					$(this).click();
					return returnVal;
				}
			});
		}
		if(returnVal){
			$.each($('.itemNm, .unitAm'), function(){
				if(!$(this).val()){
					alert('입력되지 않은 값이 있습니다.');
					returnVal = false;
					$(this).focus();
					$('#tblBudgetListData tr[index = ' + $(this).closest('tr').attr('index') + ' ]').click();
					return returnVal;
				}
			});
		}
	}
	
	// 포로젝트 체크
	if(returnVal){
		$.each($('.txtProject'), function(){
			if(!this.value){
				alert('프로젝트를 선택하세요.');
				returnVal = false;
				return returnVal;
			}
		});
	}
	
	// 예산과목 체크
	if(returnVal){
		$.each($('.erpBudgetSeq'), function(){
			if(!this.value){
				alert('예산과목을 선택하세요.');
				returnVal = false;
				return returnVal;
			}
		});
	}
	
	// 잔여금액 체크
	if(returnVal){
		$.each($('.txtAmt'), function(){
			if(!this.value){
				alert('잔여금액을 입력하세요.');
				returnVal = false;
				return returnVal;
			}
		});
	}
	
	// 변경사항 체크
	if(returnVal){
		var trArrTemp = $('#tblBudgetListData tr');
		if(trArrTemp.length === 1){
			var balanceAmt = parseInt(budgetTemp.balanceAmt.toMoney2());
			var applyAmt = parseInt(($('.txtAmt', trArrTemp).val() || 0).toMoney2());
			if(budgetTemp.mgtSeq === $('.mgtSeq', trArrTemp).val() && budgetTemp.erpBudgetSeq === $('.erpBudgetSeq', trArrTemp).val() && balanceAmt === applyAmt){
				alert('변경된 내역이 없습니다.');
				returnVal = false;
			}
		}
		// 예산잔액 초과 확인
		$.each(trArrTemp, function(){
			if(returnVal){
				var params = {};
				params.amt = $('.txtAmt', this).val().toString().toMoney();
				params.mgtSeq = $('.mgtSeq', this).val();
				params.erpBudgetSeq = $('.erpBudgetSeq', this).val();
				returnVal = consDocMng.checkLeftAmt(params);
				return returnVal;
			}
		});
	}
	
	return returnVal;
};

// 예산변경 반영
consDocMng.fnConsBudgetModify = function(){
	if(!consDocMng.fnConsBudgetModifyVal()){
		return;
	}
	$.each($('#tblBudgetListData tr'), function(){
		var modBudgetTemp = Object.assign({}, budgetTemp);
		modBudgetTemp.modMgtName = $('.mgtName', this).val();
		modBudgetTemp.modMgtSeq = $('.mgtSeq', this).val();
		modBudgetTemp.modErpBudgetName = $('.erpBudgetName', this).val();
		modBudgetTemp.modErpBudgetSeq = $('.erpBudgetSeq', this).val();
		modBudgetTemp.modErpBgt1Seq = $('.erpBgt1Seq', this).val();
		modBudgetTemp.modErpBgt1Name = $('.erpBgt1Name', this).val();
		modBudgetTemp.modErpBgt2Seq = $('.erpBgt2Seq', this).val();
		modBudgetTemp.modErpBgt2Name = $('.erpBgt2Name', this).val();
		modBudgetTemp.modErpBgt3Seq = $('.erpBgt3Seq', this).val();
		modBudgetTemp.modErpBgt3Name = $('.erpBgt3Name', this).val();
		modBudgetTemp.modErpBgt4Seq = $('.erpBgt4Seq', this).val();
		modBudgetTemp.modErpBgt4Name = $('.erpBgt4Name', this).val();
		modBudgetTemp.modBalanceAmt = $('.txtAmt', this).val().toMoney2();
		
		if(consDocMng.contractYN === 'Y'){
			var modTradeListTemp = new Array();
			$.each($('#tblTradeListData tr[index= ' + $(this).attr('index') + ' ]'), function(){
				var modTradeTemp = {};
				if($('.standard', this).val()){
					modTradeTemp.standard = $('.standard', this).val();
				}
				if($('.contents', this).val()){
					modTradeTemp.contents = $('.contents', this).val();
				}
				if($('.itemNm', this).val()){
					modTradeTemp.itemNm = $('.itemNm', this).val();
				}
				if($('.itemCnt', this).val()){
					modTradeTemp.itemCnt = $('.itemCnt', this).val().toMoney2();
				}
				if($('.itemAm', this).val()){
					modTradeTemp.itemAm = $('.itemAm', this).val().toMoney2();
				}
				if($('.unitAm', this).val()){
					modTradeTemp.unitAm = $('.unitAm', this).val().toMoney2();
				}
				if($('.tradeNote', this).val()){
					modTradeTemp.tradeNote = $('.tradeNote', this).val();
				}
				if($('.purcTrType', this).val()){
					modTradeTemp.purcTrType = $('.purcTrType', this).val();
				}
				modTradeListTemp.push(modTradeTemp);
			});
			modBudgetTemp.modTradeList = modTradeListTemp;
		}
		
		consDocMng.fnSetConsBudgetModify(modBudgetTemp);
	});
	$('#consBudgetModPopUp').data('kendoWindow').close();
}

consDocMng.fnSetConsBudgetModify = function(modBudgetTemp){
	var tr = $('<tr>').attr('index', modBudgetTemp.index);
	tr.append($('<td>').text(modBudgetTemp.index));
	tr.append($('<td>').text(modBudgetTemp.mgtName));
	tr.append($('<td>').text(modBudgetTemp.erpBudgetName));
	tr.append($('<td>').text(modBudgetTemp.balanceAmt.toString().toMoney()));
	tr.append($('<td>').text(modBudgetTemp.modMgtName));
	tr.append($('<td>').text(modBudgetTemp.modErpBudgetName));
	tr.append($('<td>').text(modBudgetTemp.modBalanceAmt.toString().toMoney()));
	tr.append($('<td>').html('<input type="button" value="삭제" onclick="javascript:consDocMng.fnConsBudgetModDel(this)">'));
	$('#tblBudgetListDataAfter').append(tr);
	
	modBudgetTemp.returnAmt = -parseInt(modBudgetTemp.balanceAmt);
	modBudgetList.push(modBudgetTemp);
	
	$('#tblBudgetListDataBefore tr[index=' + modBudgetTemp.index + '] .modBtn').hide();
	$('#tblBudgetListDataBefore tr[index=' + modBudgetTemp.index + '] .modifing').show();
};

// 변경 후 예산 삭제
consDocMng.fnConsBudgetModDel = function(obj){
	var delTr = $(obj).closest('tr');
	var index = delTr.attr('index');
	$('#tblBudgetListDataBefore tr[index=' + index + '] .modBtn').show();
	$('#tblBudgetListDataBefore tr[index=' + index + '] .modifing').hide();
	modBudgetList = modBudgetList.filter(function(obj){return index != obj.index});
	$('#tblBudgetListDataAfter tr[index=' + index + ']').remove();
}

// 예산내역 변경 유효성검사
consDocMng.fnConsDocModifyVal = function(){
	var returnVal = true;
	
	if(returnVal){
		returnVal = consDocMng.fnCheckConsBudgetModify();
	}
	
	// 변경사항 체크
	if(returnVal){
		if($('#tblBudgetListDataAfter tr').length === 0){
			alert('변경 내역이 없습니다.');
			returnVal = false;
		}
	}
	
	// 예산잔액 초과 확인
	if(returnVal){
		$.each(modBudgetList, function(){
			budgetTemp = this;
			var params = {};
			params.amt = this.modBalanceAmt.toString().toMoney();
			params.mgtSeq = this.modMgtSeq;
			params.erpBudgetSeq = this.modErpBudgetSeq;
			returnVal = consDocMng.checkLeftAmt(params);
			return false;
		});
	}
	
	return returnVal;
};

// 예산내역 변경 저장
consDocMng.fnConsDocModify = function(active){
	var returnVal = true;
	if(!consDocMng.fnConsDocModifyVal()){
		return false;
	}
	if(!confirm('예산내역 변경을 저장합니다.')){
		return false;
	}
	var params = {};
	params.modBudgetList = modBudgetList;
	params.consDocSeq = $('#consDocSeq').val();
	params.active = active;
//	params.active = 'Y';
	params.purcContId = consDocMng.purcContId;
	$.ajax({
		url : _g_contextPath_+ "/consDocMng/consDocModify",
		data: JSON.stringify(params),
		dataType : 'json',
		contentType : 'application/json',
		type : "POST",
		async : false,
		success : function(result){
			consDocMng.consModSeq = result.result.consModSeq;
		}
	});
	return returnVal;
};

consDocMng.fnPurcContModReqCheck = function(purcContId){
	var returnVal = true;
	var params = {};
	params.purcContId = purcContId;
	$.ajax({
		url : _g_contextPath_+ "/Ac/G20/Ex/purcContModReqCheck.do",
		data: params,
		dataType : 'json',
		type : "POST",
		async : false,
		success : function(result){
			if(result.result > 0){
				returnVal = false;
			}
		}
	});
	return returnVal;
};

consDocMng.fnPurcContModReq = function(purcContId){
	if(!consDocMng.fnPurcContModReqCheck(purcContId)){
		alert('요청중인 변경계약이 있습니다.');
		return;
	}
	if(confirm("변경계약을 요청합니다.")){
		var params = {};
		params.purcContId = purcContId;
	    $.ajax({
	    		url     : _g_contextPath_ + "/Ac/G20/Ex/makeContModInfo.do",
	            data    : params,
				dataType: 'json',
				type 	: "POST",
	            async   : false,
	            success : function(data){
					consDocMng.fnPurcContModReqPop(data.result);
	            }
	    });
	}
};

consDocMng.fnPurcContModReqPop = function(purcContId){
	var url = _g_contextPath_ + '/Ac/G20/Ex/purcContModReq.do?purcContId=' + purcContId + '&mng=' + consDocMng.mng;
	var pop = "";
	var width = "1200";
	var height = "950";
	windowX = Math.ceil( (window.screen.width  - width) / 2 );
	windowY = Math.ceil( (window.screen.height - height) / 2 );
	var popupName = "계약변경";
	var options = "width=" + width + ", height=" + height + ", top="+ windowY +", left="+ windowX +", scrollbars=YES, resizable=YES";
	
	consDocMng.openDialog(url, popupName, options, function(win) {
		gridReLoad();
	});
};

consDocMng.fnPurcContModCom = function(obj){
	var tr = $(obj).closest("tr");
	var selRow = $("#grid").data("kendoGrid").dataItem(tr);
	consDocMng.fnPurcContModReqPop(selRow.purcContId);
};

consDocMng.openDialog = function(uri, name, options, closeCallback) {
    var win = window.open(uri, name, options);
    var interval = window.setInterval(function() {
        try {
            if (win == null || win.closed) {
                window.clearInterval(interval);
                closeCallback(win);
            }
        }
        catch (e) {
        }
    }, 1000);
    return win;
};