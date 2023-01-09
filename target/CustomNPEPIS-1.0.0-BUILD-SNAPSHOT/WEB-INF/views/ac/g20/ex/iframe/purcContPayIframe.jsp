<%@page import="org.apache.xmlbeans.impl.xb.xsdschema.IncludeDocument.Include"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="main.web.BizboxAMessage"%>
<%
 /**
  * @Class Name : purcContPayIframe.jsp
  * @Description : 대금지급
  * @Modification Information
  *
  */ 
%>

<style type="text/css">
</style>

<script type="text/javascript">
$(function(){
	init();
});

function init(){
	$('.iframe_wrap').css('padding', '0');
	if(outProcessInterfaceMId){
		purcContPayInit();
	}
	var payTypeArr = getCommCodeList('PURC_PAYMENT_TYPE');
	payTypeArr.unshift({'code_kr': '선택', 'code': ''});
	$('#payType').kendoDropDownList({
		dataSource: payTypeArr,
    	dataTextField: 'code_kr',
    	dataValueField: 'code',
    	change: function(){
    		fnResHeadNoteUpdate();
    	}
	});
	$('#trSave').on({
		click: function(){
			fnPurcContPayTSave();
		}
	});
	$('#ckBoxAll').on({
		click: function(){
			$('.ckBox').prop('checked', $(this).prop('checked'));
		}
	});
}

var trDetailArr = new Array();

function purcContPayInit(){
   	var params = {};
   	params.purcReqId = '';
   	params.purcContId = outProcessInterfaceMId;
   	params.trDetail = 'Y';
   	
   	$.ajax({
        type: "POST"
	    , dataType: "json"
	    , url: getContextPath()+ "/Ac/G20/Ex/getPurcCont.do"
        , data: params
        , async: false
	    , success: function (obj) {
	    	$("#txtPurcReqType").val(obj.purcContInfo.purcReqType);
	    	$("#txtContTitle").val(obj.purcContInfo.contTitle);
	    	$("#txtContAm").val(obj.purcContInfo.contAm.toString().toMoney());
	    	$("#txtContDate").val(obj.purcContInfo.contDate2);
	    	$("#txtContStartDate2").val(obj.purcContInfo.contStartDate2);
	    	$("#txtContEndDate2").val(obj.purcContInfo.contEndDate2);
	    	parent.fnConfferInit(obj.purcContInfo.consDocSeq);
	    	var html = '<tr>';
	    	html += '<td><input type="checkbox" class="ckBox" /></td>';
	    	html += '<td class="trType"></td>';
	    	html += '<td class="trNm"></td>';
	    	html += '<td class="regNb"></td>';
	    	html += '<td class="ceoNm"></td>';
	    	html += '<td class=""><input type="text" class="payAm" style="width:90%;text-align:right;padding-right:5px;"/></td>';
	    	html += '</tr>';
	    	var tempTr = $(html);
	    	var tr = tempTr.clone();
	    	$('.ckBox', tr).val(0);
	    	$('.trType', tr).html('주거래처');
	    	$('.trNm', tr).html(obj.purcContInfo.trNm);
	    	$('.regNb', tr).html(obj.purcContInfo.regNb);
	    	$('.ceoNm', tr).html(obj.purcContInfo.ceoNm);
	    	$('#purcContPayTInfo tbody').append(tr);
	    	trDetailArr.push(obj.purcContInfo.trDetail);
	    	$.each(obj.purcContAddTr, function(inx){
	    		tr = tempTr.clone();
	    		$('.ckBox', tr).val(inx + 1);
	    		$('.trType', tr).html('부거래처');
		    	$('.trNm', tr).html(this.trNm);
		    	$('.regNb', tr).html(this.trDetail.REG_NB);
		    	$('.ceoNm', tr).html(this.trDetail.CEO_NM);
		    	$('#purcContPayTInfo tbody').append(tr);
		    	trDetailArr.push(this.trDetail);
	    	});
	    	$('.payAm').on({
	    		keyup: function(){
	    			$(this).val($(this).val().toMoney())
	    		}
	    	});
	    }
    });
}

function fnPurcContPayTSave(){
	var ckArr = $('.ckBox:checked');
	if(ckArr.length === 0){
		alert('선택된 거래처가 없습니다.');
		return;
	}
	var leftAm = parseInt(parent.document.getElementById("lbGwBalanceAmt").innerHTML.toMoney2());
	var sumAm = 0;
	var tempTrArr = new Array();
	$.each(ckArr, function(){
		var tempInx = $(this).val();
		var tr = $(this).closest('tr');
		var trDetail = trDetailArr[tempInx];
		var payAm = parseInt(($('.payAm', tr).val() || '0').toMoney2());
		trDetail.payAm = payAm;
		sumAm += payAm;
		tempTrArr.push(trDetail);
	});
	if(leftAm < sumAm){
		alert('결제금액은 품의잔액을 초과 할 수 없습니다.');
		return;
	}
	
	var budget = parent.fnDztGetValue('budgetTbl');
	
	$.each(tempTrArr, function(){
		var params = this;
		params.resDocSeq = budget.resDocSeq;
		params.resSeq = budget.resSeq;
		params.budgetSeq = budget.budgetSeq;
		$.ajax({
	        type: "POST"
		    , dataType: "json"
		    , url: getContextPath()+ "/Ac/G20/Ex/insertResTrade.do"
	        , data: params
	        , async: false
		    , success: function (obj) {
		    	console.log(obj);
		    }
	    });
	});
	parent.preBudgetSeq = null;
	parent.fnTradeSelect(budget.resDocSeq, budget.resSeq, budget.budgetSeq, '');
	$('.ckBox, #ckBoxAll').prop('checked', false);
	$('.payAm').val('');
}

// 결재작성 시 호출
function djCustApproval(){
	console.log("djCustApproval");
	var returnVal = false;
	
	if(!$('#payType').val()){
		alert('지급유형을 선택하세요.')
		returnVal = true;
		var dropdownlist = $("#payType").data("kendoDropDownList");
		dropdownlist.focus();
		return returnVal;
	}
	
	var params = {};
	params.resDocSeq = parent.resDocSeq;
	params.purcContId = outProcessInterfaceMId;
	params.paymentType = $('#payType').data('kendoDropDownList').text();
	params.paymentTypeId = $('#payType').data('kendoDropDownList').value();
	$.ajax({
        type: "POST"
	    , dataType: "json"
	    , url: getContextPath()+ "/Ac/G20/Ex/insertPurcContPay2.do"
        , data: params
        , async: false
	    , success: function (obj) {
	    	console.log(obj);
	    }
    });
	
	return returnVal;
}

function fnResHeadNoteUpdate(){
	var resNote = $('#txtContTitle').val() + ' ' + $('#payType').data('kendoDropDownList').text() + ' 지급';
	$.each(parent.fnDztGetResUid('resTbl'), function(){
		parent.fnDztSetFocus('resTbl', this, 'docuFgName');
		parent.fnDztSetValue('resTbl', {resNote : resNote});
	});
	$.each(parent.fnDztGetResUid("budgetTbl"), function(){
		parent.fnDztSetFocus('budgetTbl', this, 'docuFgName');
		parent.fnDztSetValue('budgetTbl', {budgetNote : resNote});
	});
	$.ajax({
        type: "POST"
	    , dataType: "json"
	    , url: getContextPath()+ "/Ac/G20/Ex/updateResHeadNote.do"
        , data: {resDocSeq : parent.resDocSeq, resNote : resNote}
        , async: false
	    , success: function (obj) {
	    }
    });
}
</script>

<div>
	<div class="btn_div mt20">
		<div class="left_div">
			<p class="tit_p fl mt5 mb0">
				계약정보
			</p>
		</div>
		<div class="right_div">
			<div class="controll_btn p0 fr ml10">
			</div>
		</div>
	</div>
   	<div class="com_ta2 hover_no mt15">
    	<table id="purcContPayInfo">
        	<colgroup>
        		<col width="100"/>
        		<col width="250"/>
        		<col width="100"/>
        		<col width="200"/>
        		<col width="100"/>
        		<col width=""/>
        		<col width="100"/>
        		<col width="150"/>
        	</colgroup>
            <tbody>
            	<tr>
                    <th>구분</th>
                    <td id="">
                    	<input type="text" id="txtPurcReqType" class="txtPurcReqType" readonly="readonly" disabled="disabled" style="width: 90%;"/>
						<input type="hidden" id="purcContId" value="${params.purcContId }"/>
						<input type="hidden" id="contType"/>
                    </td>
                	<th>계약명</th>
                    <td colspan="5" id="">
                    	<input type="text" id="txtContTitle" class="" readonly="readonly" disabled="disabled" style="width: 90%;"/>
                    </td>
                </tr>
                <tr>
                	<th>계약금액</th>
                	<td>
                		<input type="text" id="txtContAm" style="width: 90%;" disabled="disabled"/>
                	</td>
                	<th>계약일</th>
                    <td id="">
                    	<input type="text" id="txtContDate" class="" readonly="readonly" disabled="disabled" style="width: 90%;"/>
                    </td>
                	<th>계약기간</th>
                    <td id="">
                    	<input type="text" id="txtContStartDate2" class="" readonly="readonly" disabled="disabled" style="width: 40%;"/>
                    	~
                    	<input type="text" id="txtContEndDate2" class="" readonly="readonly" disabled="disabled" style="width: 40%;"/>
                    </td>
                	<th>지급유형</th>
                	<td>
                		<select id="payType" style="width: 90%;">
                		</select>
                	</td>
                </tr>
            </tbody>
        </table>
    </div>  
    <div class="btn_div mt20">
		<div class="left_div">
			<p class="tit_p fl mt5 mb0">
				거래처
			</p>
		</div>
		<div class="right_div">
			<div class="controll_btn p0 fr ml10">
			</div>
		</div>
	</div>
	<div class="com_ta2 hover_no mt15">
    	<table id="purcContPayTInfo">
        	<colgroup>
        		<col width="50"/>
        		<col width="100"/>
        		<col width=""/>
        		<col width=""/>
        		<col width=""/>
        		<col width=""/>
        	</colgroup>
        	<thead>
                <tr>
                	<th><input type="checkbox" id="ckBoxAll"/></th>
                	<th>거래처타입</th>
                	<th>거래처명</th>
                	<th>사업자번호</th>
                	<th>대표자</th>
                	<th>금회지급액</th>
                </tr>
        	</thead>
            <tbody>
            </tbody>
        </table>
    </div>
    <div class="btn_div mt20 mb0">
		<div class="left_div">
			<p class="tit_p fl mt5 mb0">
			</p>
		</div>
		<div class="right_div">
			<div class="controll_btn p0 fr ml10">
				<button id="trSave" style="margin-right: 10px; border: 2px solid blue !important;">결제내역반영</button>
			</div>
		</div>
	</div>
	<div id="result"></div>
</div>