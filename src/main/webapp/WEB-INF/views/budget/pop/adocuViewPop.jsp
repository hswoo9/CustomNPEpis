<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<jsp:useBean id="year" class="java.util.Date" />
<jsp:useBean id="mm" class="java.util.Date" />
<jsp:useBean id="dd" class="java.util.Date" />
<jsp:useBean id="weekDay" class="java.util.Date" />
<jsp:useBean id="nowDate" class="java.util.Date" />
<script type="text/javascript" src="<c:url value='/js/jquery.number.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/jszip.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/common/outProcessUtil.js' />"></script>
<style>
</style>

<script type="text/javascript">
var isu_dt = '${isu_dt}';
var isu_sq = '${isu_sq}';
var isu_doc = '';
var approval = '${approval}';
var fillSeq = '${fillSeq}';
$(function() {
	init();
});

function init(){
	getAdocuInfo();
	
}

function getAdocuInfo(){
	var params = {isu_dt: isu_dt, isu_sq: isu_sq};
	$.ajax({
		url: _g_contextPath_+'/budget/getAdocuInfo',
        dataType: "json",
        type: 'post',
        async: false,
        data: params,
        success: function(data){
        	setAdocuHInfo(data.adocuInfo.adocuHInfo);
        	setAdocuDInfo(data.adocuInfo.adocuDInfo);
        	if(approval === 'Y'){
        		setTimeout(function(){
        			fnApproval();
        		}, 500);
        	}else{
        		$('#contentsWrap').show();
        	}
        }
	});
}

function setAdocuHInfo(data){
	isu_doc = data.ISU_DOC;
	$('#txtDept').html(data.DEPT_NM);
	$('#txtEmp').html(data.EMP_NM);
	var lpad = '';
	for(i = data.ISU_SQ.toString().length; i < 5; i++){
		lpad += '0';
	}
	$('#txtGisuDt').html(moment(data.ISU_DT).format('YYYY .MM .DD') + ' - ' + lpad + data.ISU_SQ);
	lpad = '';
	for(i = data.FILL_NB.toString().length; i < 5; i++){
		lpad += '0';
	}
	$('#txtFillDt').html(moment(data.FILL_DT).format('YYYY .MM .DD') + ' - ' + lpad + data.FILL_NB);
}

function setAdocuDInfo(data){
	var txtCAmSum = 0;
	var txtDAmSum = 0;
	$.each(data, function(){
		var tr = $('#rowSample tr').clone();
		$('.txtAcctCd', tr).html(this.ACCT_CD);
		$('.txtAcctNm', tr).html(this.ACCT_NM);
		$('.txtTrNm', tr).html(this.TR_NM);
		if(this.PJT_NM){
			$('.txtPjtNm', tr).html('(' + this.PJT_CD + ')' + this.PJT_NM);
		}
		if(this.DRCR_FG === '3'){
			$('.txtCAm', tr).html(this.ACCT_AM.toString().toMoney());
			txtCAmSum += this.ACCT_AM;
		}else if(this.DRCR_FG === '4'){
			$('.txtDAm', tr).html(this.ACCT_AM.toString().toMoney());
			txtDAmSum += this.ACCT_AM;
		}
		$('.txtRmkDc', tr).html(this.RMK_DC);
		$('#adocuDTbody').append(tr);
	});
	$('#txtCAmSum').html(txtCAmSum.toString().toMoney());
	$('#txtDAmSum').html(txtDAmSum.toString().toMoney());
}

function fnApproval(){
	var params = {};
    params.compSeq =$('#compSeq').val();
    params.approKey = 'DJADOCUEA_' + isu_dt + '_' + isu_sq;
    params.outProcessCode = 'DJADOCUEA';
    if(location.host.indexOf("127.0.0.1") > -1 || location.host.indexOf("localhost") > -1){
    	params.outProcessCode = '';
    }
    params.empSeq = $('#empSeq').val();
    params.mod = 'W';
    params.fileKey = makeFileKey();
    params.contentsStr = makeContentsStr();
    params.title = '[회계전표 ' + $('#txtFillDt').html().replace(/ /gi, '') + '] ' + isu_doc.replace("\r\n", "");

	insertBudgetTemp(params);

    outProcessLogOn2(params);
}

function insertBudgetTemp(params){
	params.isuDt = isu_dt;
	params.isuSq = isu_sq;
	params.fillSeq = fillSeq;
	$.ajax({
		url: _g_contextPath_+'/budget/insertBudgetTemp',
		dataType: "json",
		type: 'post',
		async: false,
		data: params,
		success: function(data){
		}
	});
}

function makeContentsStr(){
	return $('#contentsWrap').html();
}

function fnInputSpecialCharacterExcept(str) {
	
    var special_pattern = /[`~!@#$<>%^&*|\\\'\";:\/?]/gi;

    if ( special_pattern.test(str) == true ) {
        str =  str.replace(/[`~!@#$<>%^&*|\\\'\";:\/?]/gi, "");
    }
    
    return str;
}

function makeFileKey(){
	var fileKey = '';
	isu_doc = isu_doc.replace(/\//g,"");
	var params = {isu_dt: isu_dt, isu_sq: isu_sq, isu_doc: fnInputSpecialCharacterExcept(isu_doc)};
	$.ajax({
		url: _g_contextPath_+'/budget/makeFileKey',
        dataType: "json",
        type: 'post',
        async: false,
        data: params,
        success: function(data){
        	fileKey = data.fileKey;
        }
	});
	return fileKey;
}

</script>
   
 <body>
 	<div style="padding: 50px;">
 		<div id="contentsWrap" style="display: none;">
	 		<table style="width: 100%;">
	 			<colgroup>
	 				<col width="61%"/>
	 				<col width="3%"/>
	 				<col width="9%"/>
	 				<col width="9%"/>
	 				<col width="9%"/>
	 			</colgroup>
	 			<tbody>
	 				<tr>
	 					<td rowspan="2" style="font-size: 18pt;text-indent: 50px;font-weight: bold;text-align: left;">
	 						( 대 체 ) 전표
	 						<br/>
	 						<span style="display: inline-block;background-color: gray;width: 155px;height: 2px;margin-left: 50px;"></span>
	 						<br/>
	 						<span style="display: inline-block;background-color: black;width: 157px;height: 2px;margin-left: 49px;"></span>
	 					</td>
	 					<td rowspan="2" style="font-size: 8pt;border-top: 2px solid;border-left: 2px solid;border-bottom: 2px solid;border-right: 1px solid;text-align: center;vertical-align: middle;">결<br/><br/>재<br/></td>
	 					<td style="font-size: 8pt;border-top: 2px solid;border-left: 1px solid;border-bottom: 1px solid;border-right: 1px solid;text-align: center;height: 22px;">출납</td>
	 					<td style="font-size: 8pt;border-top: 2px solid;border-left: 1px solid;border-bottom: 1px solid;border-right: 1px solid;text-align: center;height: 22px;">회계</td>
	 					<td style="font-size: 8pt;border-top: 2px solid;border-left: 1px solid;border-bottom: 1px solid;border-right: 1px solid;text-align: center;height: 22px;">실장</td>
	 				</tr>
	 				<tr>
	 					<td name="approval1" style="font-size: 8pt;border-top: 1px solid;border-left: 1px solid;border-bottom: 2px solid;border-right: 1px solid;text-align: center;height: 50px;"></td>
	 					<td name="approval2" style="font-size: 8pt;border-top: 1px solid;border-left: 1px solid;border-bottom: 2px solid;border-right: 1px solid;text-align: center;height: 50px;"></td>
	 					<td name="approval3" style="font-size: 8pt;border-top: 1px solid;border-left: 1px solid;border-bottom: 2px solid;border-right: 1px solid;text-align: center;height: 50px;"></td>
	 				</tr>
	 			</tbody>
	 		</table>
	 		<table style="width: 100%;">
	 			<colgroup>
	 				<col width="9%"/>
	 				<col width="17%"/>
	 				<col width="9%"/>
	 				<col width="17%"/>
	 				<col width="48%"/>
	 			</colgroup>
	 			<tbody>
	 				<tr>
	 					<td style="padding: 0px;height: 14px;text-align: left;">결의부서 :</td>
	 					<td style="padding: 0px;height: 14px;text-align: left;"><span id="txtDept"></span></td>
	 					<td style="padding: 0px;height: 14px;text-align: left;"><span style="letter-spacing: 6px;">작성</span>자 :</td>
	 					<td style="padding: 0px;height: 14px;text-align: left;"><span id="txtEmp"></span></td>
	 					<td style="padding: 0px;height: 14px;text-align: left;"></td>
	 				</tr>
	 				<tr>
	 					<td style="padding: 0px;height: 14px;text-align: left;">결의일자 :</td>
	 					<td style="padding: 0px;height: 14px;text-align: left;"><span id="txtGisuDt"></span></td>
	 					<td style="padding: 0px;height: 14px;text-align: left;">확정일자 :</td>
	 					<td style="padding: 0px;height: 14px;text-align: left;"><span id="txtFillDt"></span></td>
	 					<td style="padding: 0px;height: 14px;text-align: right;">[&nbsp;&nbsp;&nbsp;1/1&nbsp;&nbsp;&nbsp;]</td>
	 				</tr>
	 			</tbody>
	 		</table>
	 		<table style="width: 100%;">
	 			<colgroup>
	 				<col width="15%"/>
	 				<col width="11%"/>
	 				<col width="33%"/>
	 				<col width="13%"/>
	 				<col width="14%"/>
	 				<col width="14%"/>
	 			</colgroup>
	 			<tbody id="adocuDTbody">
	 				<tr>
		 				<td style="font-size: 10pt;border-top: 2px solid;border-left: 2px solid;border-bottom: 1px solid;border-right: 1px solid;text-align: center;vertical-align: middle;height: 20px;">코&nbsp;&nbsp;&nbsp;&nbsp;드</td>
		 				<td style="font-size: 10pt;border-top: 2px solid;border-left: 2px solid;border-bottom: 1px solid;border-right: 1px solid;text-align: center;vertical-align: middle;height: 20px;">거&nbsp;래&nbsp;처</td>
		 				<td style="font-size: 10pt;border-top: 2px solid;border-left: 2px solid;border-bottom: 1px solid;border-right: 1px solid;text-align: center;vertical-align: middle;height: 20px;">부&nbsp;&nbsp;&nbsp;&nbsp;서&nbsp;&nbsp;프&nbsp;로&nbsp;젝&nbsp;트&nbsp;&nbsp;관리번호</td>
		 				<td style="font-size: 10pt;border-top: 2px solid;border-left: 2px solid;border-bottom: 1px solid;border-right: 1px solid;text-align: center;vertical-align: middle;height: 20px;">처&nbsp;리&nbsp;구&nbsp;분</td>
		 				<td colspan="2" style="font-size: 10pt;border-top: 2px solid;border-left: 2px solid;border-bottom: 1px solid;border-right: 2px solid;text-align: center;vertical-align: middle;height: 20px;">금&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;액</td>
		 			</tr>
		 			<tr>
		 				<td style="font-size: 10pt;border-top: 1px solid;border-left: 2px solid;border-bottom: 2px solid;border-right: 1px solid;text-align: center;vertical-align: middle;height: 20px;">계&nbsp;정&nbsp;과&nbsp;목</td>
		 				<td colspan="3" style="font-size: 10pt;border-top: 1px solid;border-left: 2px solid;border-bottom: 2px solid;border-right: 1px solid;text-align: center;vertical-align: middle;height: 20px;">적&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;요</td>
		 				<td style="font-size: 10pt;border-top: 1px solid;border-left: 2px solid;border-bottom: 2px solid;border-right: 1px solid;text-align: center;vertical-align: middle;height: 20px;">차&nbsp;&nbsp;&nbsp;변</td>
		 				<td style="font-size: 10pt;border-top: 1px solid;border-left: 2px solid;border-bottom: 2px solid;border-right: 2px solid;text-align: center;vertical-align: middle;height: 20px;">대&nbsp;&nbsp;&nbsp;변</td>
		 			</tr>
	 			</tbody>
	 			<tfoot>
	 				<tr>
	 					<td colspan="4" style="font-size: 10pt;border-top: 2px solid;border-left: 2px solid;border-bottom: 2px solid;border-right: 2px solid;text-align: center;vertical-align: middle;height: 20px;">합 계</td>
	 					<td style="font-size: 9pt;border-top: 2px solid;border-left: 2px solid;border-bottom: 2px solid;border-right: 2px solid;text-align: right;vertical-align: middle;height: 20px;"><span id="txtCAmSum"></span><span style="width: 3px;display: inline-block;"></span></td>
	 					<td style="font-size: 9pt;border-top: 2px solid;border-left: 2px solid;border-bottom: 2px solid;border-right: 2px solid;text-align: right;vertical-align: middle;height: 20px;"><span id="txtDAmSum"></span><span style="width: 3px;display: inline-block;"></span></td>
	 				</tr>
	 			</tfoot>
	 		</table>
	 		<div style="text-align: right;padding-top: 20px;font-size: 11pt;">농림수산식품교육문화정보원</div>
 		</div>
 		<div style="display: none;">
 			<table>
 				<tbody id="rowSample">
	 				<tr>
		 				<td style="font-size: 10pt;border-top: 2px solid;border-left: 2px solid;border-bottom: 0px solid;border-right: 1px solid;text-align: center;vertical-align: middle;height: 20px;"><span class="txtAcctCd"></span></td>
		 				<td style="font-size: 7pt;border-top: 2px solid;border-left: 2px solid;border-bottom: 1px solid;border-right: 1px solid;text-align: left;vertical-align: middle;height: 20px;text-indent: 3px;"><span class="txtTrNm"></span></td>
		 				<td style="font-size: 8pt;border-top: 2px solid;border-left: 2px solid;border-bottom: 1px solid;border-right: 1px solid;text-align: center;vertical-align: middle;height: 20px;"><span class="txtPjtNm"></span></td>
		 				<td style="font-size: 10pt;border-top: 2px solid;border-left: 2px solid;border-bottom: 1px solid;border-right: 1px solid;text-align: center;vertical-align: middle;height: 20px;"><span class=""></span></td>
		 				<td rowspan="2" style="font-size: 9pt;border-top: 2px solid;border-left: 2px solid;border-bottom: 1px solid;border-right: 2px solid;text-align: right;vertical-align: middle;height: 20px;"><span class="txtCAm"></span><span style="width: 3px;display: inline-block;"></span></td>
		 				<td rowspan="2" style="font-size: 9pt;border-top: 2px solid;border-left: 2px solid;border-bottom: 1px solid;border-right: 2px solid;text-align: right;vertical-align: middle;height: 20px;"><span class="txtDAm"></span><span style="width: 3px;display: inline-block;"></span></td>
		 			</tr>
		 			<tr>
		 				<td style="font-size: 9pt;border-top: 0px solid;border-left: 2px solid;border-bottom: 2px solid;border-right: 1px solid;text-align: center;vertical-align: middle;height: 20px;text-align: left;text-indent: 3px;"><span class="txtAcctNm"></span></td>
		 				<td colspan="3" style="font-size: 8pt;border-top: 1px solid;border-left: 2px solid;border-bottom: 2px solid;border-right: 1px solid;text-align: left;vertical-align: middle;height: 20px;text-indent: 3px;"><span class="txtRmkDc"></span></td>
		 			</tr>
	 			</tbody>
 			</table>
 		</div>
 	</div>
 	
 	<form id="outProcessFormData" action="/gw/outProcessLogOn.do" method="post"></form>
 	
 	<input type="hidden" id="compSeq" value="${userInfo.compSeq }">
	<input type="hidden" id="erpCoCd" value="${userInfo.erpCoCd }">
	<input type="hidden" id="empSeq" value="${userInfo.uniqId }">
	<input type="hidden" id="deptSeq" value="${userInfo.orgnztId }">
</body>