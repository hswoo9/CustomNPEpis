<%@page import="org.apache.xmlbeans.impl.xb.xsdschema.IncludeDocument.Include"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="main.web.BizboxAMessage"%>

<%
 /**
  * @Class Name : purcReqFormPop.jsp
  * @Description : 구매의뢰서 작성
  * @Modification Information
  *
  */ 
%>

<script type="text/javascript" src='<c:url value="/js/ac/acUtil.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/ac/g20/purcReqCode.js"></c:url>'></script>
<script type="text/javascript" src="<c:url value='/js/jquery.form.js' />"></script>
<script type="text/javascript" src='<c:url value="/js/common/commFileUtil.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/common/outProcessUtil.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/resalphag20/resAlphaG20Util.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/consDocMng/consDocMng.js"></c:url>'></script>

<style type="text/css">

.invalid { background-color : #ff6666;}
input:focus{background-color : #ccffff;}
.overBudget{background-color : #ff66dd;}
#project-td .search-Event-H, #budget-td .search-Event-B{display : none;}
#project-td #txt_ProjectName, .txt_BUDGET_LIST{disabled : disabled}
.left_div .controll_btn #tableTab{border: 1px solid #eaeaea;width: 160px;border-bottom-width: 0px;cursor: pointer;}
.left_div .controll_btn #tableTab .selTab{background: #e6f4ff;}
</style>

<script type="text/javascript">
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

var purcContId = "${params.purcContId}";
var purcContIdBefore = "";
var consDocSeq = "";
var abdocuInfo = {};
var gwOption = {};
var mng = '${params.mng}';
	
$(function(){
	init();
	eventHandlerMapping();
	fnResizeForm();
	setTimeout(function(){$(".pop_sign_wrap").height($("body").height());}, 100);
});

function eventHandlerMapping(){
	$("#purcContModInfo input").bind({
		change : function(){
			updatePurcContMod();
		}
	});
	
	$('#attachFile').bind({
		change : function(){
			fnTpfAttachFileUpload($(this));
		}
	});
	
	/*거래처명*/
    $("#trNm").bind({
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
         					"id" : "txt_REG_NB" + idx,
                             "text" : "REG_NB",
                             "code" : ""
         				}];
               		
    				return returnObj;

               	})(id, "");
            acUtil.util.dialog.dialogDelegate(acG20Code.getErpTradeList, dblClickparamMap);
        }
    });
	$("#trPopBtn").bind({
		click : function(){
			 $("#trNm").dblclick();
		}
	});
	
    $("#txt_TR_NM_add").bind({
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
         					"id" : "txt_REG_NB" + idx,
                             "text" : "REG_NB",
                             "code" : ""
         				}];
               		
    				return returnObj;

               	})(id, "");
            acUtil.util.dialog.dialogDelegate(acG20Code.getErpTradeList, dblClickparamMap);
        }
    });
    $("#addTradeBtn").bind({
		click : function(){
			 $("#txt_TR_NM_add").dblclick();
		}
	});
    
    $("#btnRequest").bind({
		click : function(){
			requestPurcContMod();
		}
	});
    $("#btnApproval").bind({
		click : function(){
			completePurcContMod();
		}
	});
	$("#btnReturnPop").bind({
		click : function(){
			returnPurcContMod();
		}
	});
	$('#btnReturn').on({
		click: function(){
			fnReturn();
		}
	});
	$("#dialog-form-standard").bind({
		keyup : function(e){
			if(e.which == 27){
				$("#dialog-form-background, #dialog-form-standard").hide();
			}
		}
	});
}

function init(){
	if(mng === 'Y'){
		$('#yes_mng').show();
		$('#no_mng').hide();
	}else{
		$('#yes_mng').hide();
		$('#no_mng').show();
	}
	abdocuInfo.erp_co_cd = $("#erpCoCd").val();
	datePickerInit();
	topBoxInit();
	resAlphaG20Util.init();
	consDocMng.init();
	contModInit();
	$("#returnDiv").kendoWindow({
		width: "500px",
		height: "100px",
		visible: false,
		modal: true,
		title: '반려사유',
		actions: [
			"Close"
		],
		close: function(){
			
		}
	}).data("kendoWindow").center();
}

function datePickerInit(){
	var option = {
			format : "yyyy-MM-dd",
	    	culture : "ko-KR",	
	}
	$('#contDate2').kendoDatePicker(option);
	$('#contDate2').attr("disabled", true);
	$('#contStartDate2').kendoDatePicker(option);
	$('#contStartDate2').attr("disabled", true);
	$('#contEndDate2').kendoDatePicker(option);
	$('#contEndDate2').attr("disabled", true);
}

function topBoxInit(){
	var params = {};
	params.purcContId = $("#purcContId").val();
    var opt = {
    		url     : _g_contextPath_ + "/Ac/G20/Ex/inspTopBoxInit.do",
            async   : false,
            data    : params,
            successFn : function(data){
            	$("#txtPurcReqType").val(data.resultInfo.purcReqType).attr("code", data.resultInfo.purcReqTypeCodeId);
            	$("#txtContTitle").val(data.resultInfo.contTitle);
            	consDocMng.contractYN = 'Y';
            	consDocMng.purcReqTypeCodeId = data.resultInfo.purcReqTypeCodeId;
            }
    };
    acUtil.ajax.call(opt);
}

function contModInit(){
	var params = {};
	params.purcContId = purcContId;
	params.purcContIdOrg = $('#purcContIdOrg').val();
    var opt = {
    		url     : _g_contextPath_ + "/Ac/G20/Ex/getContMod.do",
            async   : false,
            data    : params,
            successFn : function(data){
				var contInfo = data.purcContInfo;
				var attachFileList = data.attachFileList;
				var purcContAddTr = data.purcContAddTr;
				var contInfoOrg = data.purcContInfoOrg;
				var purcContAddTrOrg = data.purcContAddTrOrg;
				var consModifyEndBList = data.consModifyEndBList;
				var consModifyEndTList = data.consModifyEndTList;
				consDocSeq = contInfo.consDocSeq;
				fnSetContInfo(contInfo);
				fnSetAttachFileList(attachFileList);
				fnSetPurcContAddTr(purcContAddTr);
				fnSetContInfoOrg(contInfoOrg);
				fnSetPurcContAddTr2(purcContAddTrOrg);
				fnSetConsModify(consModifyEndBList, consModifyEndTList);
            }
    };
    acUtil.ajax.call(opt);
}

function fnSetContInfo(data){
	fnResetContInfo();
	$("#modReason").val(data.modReason);
	$("#purcReqId").val(data.purcReqId);
	$("#purcContIdOrg").val(data.purcContIdOrg);
	var contAm = data.contAm ? data.contAm : 0;
	$("#contAm").val(contAm.toString().toMoney());
	$("#contTitle").val(data.contTitle);
	$("#contDate2").val(data.contDate2);
	$("#contStartDate2").val(data.contStartDate2);
	$("#contEndDate2").val(data.contEndDate2);
	$("#trNm").val(data.trNm).attr("code", data.trCd);
	$("#txt_CEO_NM").val(data.ceoNm);
	$("#txt_REG_NB").val(data.regNb);
	consDocMng.consModSeq = data.consModSeq;
	consDocMng.purcContId = data.purcContId;
}

function fnSetContInfoOrg(data){
	$("#contTitleOrg").val(data.contTitle);
	$("#contAmOrg").val(data.contAm.toString().toMoney());
	$("#contTitleOrg").val(data.contTitle);
	$("#contDate2Org").val(data.contDate2);
	$("#contStartDate2Org").val(data.contStartDate2);
	$("#contEndDate2Org").val(data.contEndDate2);
	$("#trNmOrg").val(data.trNm);
	$("#purcContModOrg input").attr("disabled", true);
	purcContIdBefore = data.purcContId;
	consDocMng.purcContIdBefore = data.purcContId;
}

function fnResetContInfo(){
	$("#purcContMod input[type=text]").val("");
	$("#purcContMod #fileArea3").html("");
	$("#budgetInfo td").html("");
	$("#erpBudgetInfo-table tr").remove();
	$("#erpTradeInfo-table tr").remove();
}

function fnSetAttachFileList(data){
	$('#fileArea3 span').remove();
	$.each(data, function(){
		var fileType = this.fileType;
		var span = $('#fileSample div').clone();
		$('.file_name', span).html(this.realFileName + '.' + this.fileExtension);
		$('.attachFileId', span).val(this.attachFileId);
		$('.fileSeq', span).val(this.fileSeq);
		$('.filePath', span).val(this.filePath);
		$('.fileNm', span).val(this.realFileName + '.' + this.fileExtension);
		$('#fileArea' + fileType).append(span);
	});
}

function fnSetPurcContAddTr(purcContAddTr){
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

function fnSetPurcContAddTr2(purcContAddTr){
	$.each(purcContAddTr, function(){
		var trCd = this.trCd;
		var trNm = this.trNm;
		var span = $('#addTradeTdSampleOrg span').clone();
    	$(".trNmTxt", span).html(trNm);
    	$(".trCd", span).val(trCd);
    	$(".trNm", span).val(trNm);
		$("#txt_TR_NM_add_spanOrg").append(span);
	});
};

function fnSetConsModify(consModifyEndBList, consModifyEndTList){
	$('#tblBudgetListDataAfter2').html('');
	$.each(consModifyEndBList, function(){
		var modBudgetTemp = this;
		var tr = $('<tr>');
		tr.append($('<td>').text(modBudgetTemp.mgtNameBefore));
		tr.append($('<td>').text(modBudgetTemp.erpBudgetNameBefore));
		tr.append($('<td>').text(modBudgetTemp.budgetAmtBefore.toString().toMoney()));
		tr.append($('<td>').text(modBudgetTemp.mgtName));
		tr.append($('<td>').text(modBudgetTemp.erpBudgetName));
		tr.append($('<td>').text(modBudgetTemp.budgetAmt.toString().toMoney()));
		$('#tblBudgetListDataAfter2').append(tr);
	});
	$.each(consModifyEndBList, function(){
		var consModBSeq = this.consModBSeq;
		this.modTradeList = consModifyEndTList.filter(function(obj){return consModBSeq === obj.consModBSeq;});
	});
	consDocMng.modBudgetListTemp = consModifyEndBList;
}

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
		targetId = fnSetPurcContAttach(targetId, fileType);
		targetTableName = 'tpf_purc_cont_attach';
	}
	var path = 'tpf_purc_cont';
	var fileForm = obj.closest('form');
	var fileInput = obj;
	var fileList = fnCommonFileUpload(targetTableName, targetId, path, fileForm);
	$.each(fileList, function(){
		var span = $('#fileSample td div').clone();
		$('.file_name', span).html(this.fileNm + "." + this.ext);
		$('.attachFileId', span).val(this.attach_file_id);
		$('.fileSeq', span).val(this.fileSeq);
		$('.filePath', span).val(this.filePath);
		$('.fileNm', span).val(this.fileNm + "." + this.ext);
		$('#fileArea'+fileType).append(span);
	});
	fileInput.unbind();
	fileForm.clearForm();
	fileInput.bind({
		change : function(){
			fnTpfAttachFileUpload($(this));
		}
	})
}

function fnSetPurcContAttach(targetId, fileType){
	var saveObj = {};
	var resultData = {};
	saveObj.purcReqId = targetId;
	saveObj.fileType = fileType;
	var opt = {
    		url : _g_contextPath_ + "/Ac/G20/Ex/setPurcContAttach.do",
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
}

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

function fnTradeInfoSave(id){
	updatePurcContMod();
	if(id == "txt_TR_NM_add"){
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
};

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

function updatePurcContMod(){
	// 기초금액 낙찰률 추가 20190827 pjm
	var contAm = parseInt($("#contAm").val().toMoney2());
	var saveObj = {};
	saveObj.purcContId = purcContId;
	saveObj.modReason = $("#modReason").val();
	saveObj.contDate2 = $("#contDate2").val();
	saveObj.contStartDate2 = $("#contStartDate2").val();
	saveObj.contEndDate2 = $("#contEndDate2").val();
	saveObj.trNm = $("#trNm").val();
	saveObj.trCd = $("#trNm").attr("code");
	saveObj.ceoNm = $("#txt_CEO_NM").val();
	saveObj.regNb = $("#txt_REG_NB").val();
	saveObj.consModSeq = consDocMng.consModSeq;
	saveObj.contAm = contAm;
	var opt = {
    		url : _g_contextPath_ + "/Ac/G20/Ex/updatePurcContMod.do",
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
	acUtil.ajax.call(opt);
}

function fnConsDocModPopUp(){
	consDocMng.fnConsDocModPopUp(consDocSeq);
}

function fnConsDocModify(){
	if(consDocMng.fnConsDocModify('N')){
		var contAm = 0;
		$.each(budgetList, function(){
			var budgetSeq = this.budgetSeq;
			var tempModBudgetList = modBudgetList.filter(function(obj){return obj.budgetSeq === budgetSeq;});
			if(tempModBudgetList.length > 0){
				$.each(tempModBudgetList, function(){
					contAm += parseInt(this.modBalanceAmt);
				});
			}else{
				contAm += this.budgetAmt;
			}
			$('#contAm').val(contAm.toString().toMoney());
		});
		updatePurcContMod();
		$('#consDocModPopUp').data('kendoWindow').close();
		contModInit();
	}
}

function requestPurcContMod(){
	if(!$("#modReason").val()){
		alert("변경사유를 입력하세요.");
		return;
	}
// 	if(onnaraDocs.length < 1){
// 		alert('온나리연동문서를 등록하세요.')
// 		return;
// 	}
	if(confirm("변경계약을 요청합니다.")){
		var saveObj = {}
		saveObj.purcContId = purcContId;
		saveObj.purcReqId = $("#purcReqId").val();
		saveObj.purcContIdOrg = $("#purcContIdOrg").val();
	    var opt = {
	            url : _g_contextPath_ + "/Ac/G20/Ex/requestPurcContMod.do",
	            async:false,
	            data : saveObj,
	            successFn : function(data){
	            	if(data.result == "Success"){
	            		alert("변경계약이 요청되었습니다.");
	            	}
	            }
	    };
	    acUtil.ajax.call(opt);
	    targetType = 'PURCMOD';
		targetSeq = $("#purcContId").val();
		saveOnnaraMapping();
        window.close();
	}
}

function completePurcContMod(){
	if(!$("#modReason").val()){
		alert("변경사유를 입력하세요.");
		return;
	}
// 	if(onnaraDocs.length < 1){
// 		alert('온나리연동문서를 등록하세요.')
// 		return;
// 	}
// 	if($('#fileArea2 span').length < 1){
// 		alert('계약서를 등록하세요.')
// 		return;
// 	}
// 	if(!$("#refDocKey").val()){
// 		alert("계약변경 보고문서를 선택하세요.");
// 		return;
// 	}
	if(confirm("변경계약을 접수합니다.")){
		var params = {};
	    params.compSeq = $('#compSeq').val();
	    params.approKey = 'CONTMOD_' + $("#purcReqId").val() + '_' + purcContId + '_' + $("#purcContIdOrg").val();
	    params.outProcessCode = 'CONTMOD';
	    params.empSeq = $('#empSeq').val();
	    params.mod = 'W';
	    params.fileKey = makeDjFileKey();
	    onnaraFileToTemp(params.fileKey);
	    params.contentsStr = makeContentsStr();
	    params.title = $('#contTitleOrg').val() + ' 변경계약';
	    var prev_url = location.href.split('&');
	    params.prev_url = prev_url[0] + '&' + prev_url[1] + '&' + prev_url[2] + '&' + prev_url[3];
	    params.prev_name = "정보수정";
	    outProcessLogOn2(params);
	}
}

function makeContentsStr(){
	var html = '';
	html += '<div style="font-family:맑은 고딕;font-size:11pt;text-align:left;">';
	html += '1. 관련 : ';
	$.each(onnaraDocs, function(i){
		html += (i == 0 ? '' : ', ');
		html += this.AUTHORDEPTNAME + '-' + this.DOCNOSEQ + '(' + moment(this.ENDDT.substr(0,8)).format('YYYY.MM.DD') + ')호';
	});
	html += '.';
	html += '<br/>';
	html += '2. ' + $('#contTitleOrg').val() + '  계약을 변경하고자 합니다.';
	html += '<br/>';
	html += '<br/>';
	html += '&nbsp;&nbsp;가. <span style="letter-spacing:0.1px;">사 업 명</span> : ' + $('#contTitleOrg').val();
	html += '<br/>';
	html += '&nbsp;&nbsp;나. 계약업체 : ' + $('#trNm').val();
	html += '<br/>';
	html += '&nbsp;&nbsp;다. 계약기간 : ' + moment($('#contStartDate2Org').val()).format('YYYY.MM.DD') + ' ~ ' + moment($('#contEndDate2Org').val()).format('YYYY.MM.DD');
	html += '<br/>';
	html += '&nbsp;&nbsp;라. 변경내용 : ' + $('#modReason').val();
	html += '<br/>';
	html += '<div style="text-align: right;">(단위 : 원)</div>';
	html += '<table style="width: 100%;">';
	html += '<colgroup>';
	html += '<col width="15%"/>';
	html += '<col width="30%"/>';
	html += '<col width="30%"/>';
	html += '<col width="25%"/>';
	html += '</colgroup>';
	html += '<tr>';
	html += '<th style="background-color: #f9f9f9;border: 1px solid #eaeaea;padding: 5px;text-align: center;">구분</th>';
	html += '<th style="background-color: #f9f9f9;border: 1px solid #eaeaea;padding: 5px;text-align: center;">당초</th>';
	html += '<th style="background-color: #f9f9f9;border: 1px solid #eaeaea;padding: 5px;text-align: center;">변경</th>';
	html += '<th style="background-color: #f9f9f9;border: 1px solid #eaeaea;padding: 5px;text-align: center;">비고</th>';
	html += '</tr>';
	html += '<tr>';
	html += '<td style="border: 1px solid #eaeaea;padding: 5px;text-align: center;">계약기간</td>';
	html += '<td style="border: 1px solid #eaeaea;padding: 5px;text-align: center;">' + moment($('#contStartDate2Org').val()).format('YYYY.MM.DD') + ' ~ ' + moment($('#contEndDate2Org').val()).format('YYYY.MM.DD') + '</td>';
	html += '<td style="border: 1px solid #eaeaea;padding: 5px;text-align: center;">' + moment($('#contStartDate2').val()).format('YYYY.MM.DD') + ' ~ ' + moment($('#contEndDate2').val()).format('YYYY.MM.DD') + '</td>';
	html += '<td style="border: 1px solid #eaeaea;padding: 5px;text-align: center;"></td>';
	html += '</tr>';
	html += '<tr>';
	html += '<td style="border: 1px solid #eaeaea;padding: 5px;text-align: center;">계약금액</td>';
	html += '<td style="border: 1px solid #eaeaea;padding: 5px;text-align: right;">' + $('#contAmOrg').val() + '</td>';
	html += '<td style="border: 1px solid #eaeaea;padding: 5px;text-align: right;">' + $('#contAm').val() + '</td>';
	html += '<td style="border: 1px solid #eaeaea;padding: 5px;text-align: center;"></td>';
	html += '</tr>';
	html += '</table>';
	html += '<br/>';
	html += '<br/>';
	html += '<br/>';
	html += '<span style="display:inline-block;width:40px;">붙 임 </span>1. 용역변경계약서 1부.';
	html += '<br/>';
	html += '<span style="display:inline-block;width:40px;"></span>2. 변경의뢰서 1부.';
	html += '<br/>';
	html += '<span style="display:inline-block;width:40px;"></span>3. 산출내역서 1부.&nbsp;&nbsp;끝.';
	html += '<br/>';
	html += '<br/>';
	html += '</div>';
	return html;
}

function returnPurcContMod(){
	$("#returnDiv").data("kendoWindow").open();
}

function fnReturn(){
	var returnVal = true;
	
	if(!$('#returnReason').val()){
		alert('반려사유를 입력하세요.');
		returnVal = false;
	}
	
	if(!returnVal){
		return;
	}
	if(!confirm('변경계약요청을 반려합니다.')){
		return;
	}
	
	var data = {};
	data.purcContId = purcContId;
	data.returnReason = $('#returnReason').val();
    var opt = {
    		url     : _g_contextPath_ + "/Ac/G20/Ex/updatePurcContModReturn.do",
            async   : false,
            data    : data,
            successFn : function(data){
            	saveOnnaraMapping();
    			window.close();
            }
    };
    acUtil.ajax.call(opt);
}
</script>
<form id="outProcessFormData" action="http://211.192.144.104/gw/outProcessLogOn.do" target="outProcessLogOn"></form>
<input type="hidden" id="compSeq" value="${loginVO.compSeq }"/>
<input type="hidden" id="empSeq" value="${loginVO.uniqId }"/>
<input type="hidden" id="loginId" value="${loginVO.id }"/>
<input type="hidden" id="erpCoCd" value="${loginVO.erpCoCd }"/>
<input type="hidden" id="deptCd" value="${loginVO.orgnztId }"/>
<div class="pop_sign_wrap scroll_y_fix" style="width:1200px;">
    <div class="pop_sign_head">
        <h1><span class="title_NM">변경계약</span></h1>
		<div class="psh_btnbox">
			<div class="psh_right">
				<div class="btn_cen mt8" id="no_mng">
					<input type="button" class="psh_btn" id="btnRequest" value="변경계약 요청" />
				</div>
				<div class="btn_cen mt8" id="yes_mng">
					<input type="button" class="psh_btn" id="btnApproval" value="접수" />
					<input type="button" class="psh_btn" id="btnReturnPop" value="반려" />
				</div>
			</div>
		</div>        
    </div>
    <div class="pop_sign_con scroll_on" style="padding:62px 16px 20px 16px;">  

        <div class="top_box mt10">
			<dl>
				<dt class="ar" style="width: 50px">구분</dt>
				<dd>
					<input type="text" id="txtPurcReqType" class="txtPurcReqType" readonly="readonly" disabled="disabled" style="width: 170px;"/>
					<input type="hidden" id=purcContId value="${params.purcContId }"/>
				</dd>
				<dt class="ar" style="width: 70px">계약명</dt>
				<dd>
					<input type="text" id="txtContTitle" class="" readonly="readonly" disabled="disabled" style="width: 250px;"/>
				</dd>
			</dl>
		</div>
		
		<div class="com_ta2 mt15">
			<div id="grid"></div>
		</div>
		<div id="djOnnara" style="height: 100px;"></div>
		<div class="btn_div mt10 cl purcContModDetail">
			<div class="left_div">
				<p class="tit_p mt5 mb0">변경 전 계약</p>
			</div>
			<div class="right_div">
				<div class="controll_btn p0">
				</div>
			</div>
		</div>
		
		<div id="purcContModOrg" class="purcContModDetail">
			<div  class="com_ta2 hover_no mt10">
				<table>
					<colgroup>
						<col width="100"/>
						<col width="220"/>
						<col width="100"/>
						<col width=""/>
						<col width="100"/>
						<col width="120"/>
						<col width="100"/>
						<col width="230"/>
					</colgroup>
					<tbody>
						<tr>
							<th>계약명</th>
							<td class="le" colspan="7">
								<input type="text" id="contTitleOrg" style="width: 90%;" readonly="readonly"/>
							</td>
						</tr>
						<tr>
							<th>거래처</th>
							<td class="le" colspan="1">
								<input type="text" id="trNmOrg" style="width: 90%;" readonly="readonly"/>
							</td>
							<th>계약금액</th>
							<td class="le">
								<input type="text" id="contAmOrg" readonly="readonly" style="width: 90%;"/>
							</td>
							<th>계약일</th>
							<td class="le" colspan="1">
								<input type="text" id="contDate2Org" style="width: 90%;" readonly="readonly"/>
							</td>
							<th>계약기간</th>
							<td class="le" colspan="1">
								<input type="text" id="contStartDate2Org" style="width: 43%;" readonly="readonly"/> ~ 
								<input type="text" id="contEndDate2Org" style="width: 43%;" readonly="readonly"/>
							</td>
						</tr>
						<tr>
							<th>부 거래처</th>
							<td colspan="7" id="addTradeTdOrg" class="le">
								<input type="hidden" id="txt_TR_NM_addOrg" class="txt_TR_NM" />
								<span id="txt_TR_NM_add_spanOrg"></span>
							</td>
						</tr>
						<tr id="addTradeTdSampleOrg" style="display: none;">
							<td></td>
							<td>
								<span>
									<span class="trNmTxt mr10"></span>
									<input class="trCd" type="hidden" value="">
									<input class="trNm" type="hidden" value="">
								</span>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
		
		<div class="btn_div mt10 cl purcContModDetail">
			<div class="left_div">
				<p class="tit_p mt5 mb0">변경 후 계약</p>
			</div>
			<div class="right_div">
				<div class="controll_btn p0">
				</div>
			</div>
		</div>
		
		<div id="purcContMod" class="purcContModDetail">
			<div  class="com_ta2 hover_no mt10" id="purcContModInfo">
				<table>
					<colgroup>
						<col width="100"/>
						<col width="220"/>
						<col width="100"/>
						<col width=""/>
						<col width="100"/>
						<col width="120"/>
						<col width="100"/>
						<col width="130"/>
						<col width="100"/>
					</colgroup>
					<tbody>
						<tr>
							<th>변경사유</th>
							<td class="le" colspan="8">
								<input type="text" id="modReason" style="width: 90%;"/>
								<input type="hidden" id="purcReqId"/>
								<input type="hidden" id="purcContIdOrg"/>
							</td>
						</tr>
						<tr>
							<th>거래처</th>
							<td class="le" colspan="1">
								<input type="text" id="trNm" style="width: 85%;" readonly="readonly"/>
								<input type="hidden" id="txt_CEO_NM"/>
								<input type="hidden" id="txt_REG_NB"/>
								<a href="javascript:;" class="search-Event-T" id="trPopBtn"><img src="<c:url value='/Images/ico/ico_explain.png' />" alt="검색" title="검색" /></a>
							</td>
							<th>계약금액</th>
							<td class="le">
								<input type="text" id="contAm" readonly="readonly" style="width: 60%;"/>
								<input type="button" onclick="fnConsDocModPopUp()" 	value="변경" class="ml4 normal_btn2" /> 
							</td>
							<th>계약일</th>
							<td class="le" colspan="1">
								<input type="text" id="contDate2" style="width: 90%;"/>
							</td>
							<th>계약기간</th>
							<td class="le" colspan="2">
								<input type="text" id="contStartDate2" style="width: 43%;"/> ~ 
								<input type="text" id="contEndDate2" style="width: 43%;"/>
							</td>
						</tr>
						<tr>
							<th>부 거래처</th>
							<td colspan="7" id="addTradeTd" class="le">
								<input type="hidden" id="txt_TR_NM_add" class="txt_TR_NM" />
								<span id="txt_TR_NM_add_span"></span>
							</td>
							<td>
								<input type="button" onclick="" id="addTradeBtn" value="추가" class="ml4 normal_btn2" />
							</td>
						</tr>
						<tr id="addTradeTdSample" style="display: none;">
							<td></td>
							<td>
								<span>
									<span class="trNmTxt"></span>
									<a onclick="fnTrDelete(this);" href="#n">
										<img alt="" src="<c:url value='/Images/btn/btn_del_reply.gif' />">
									</a>
									<input class="trCd" type="hidden" value="">
									<input class="trNm" type="hidden" value="">
								</span>
							</td>
						</tr>
						<tr>
							<th>첨부파일</th>
							<td class="le" id="fileArea3" colspan="7"></td>
							<td class="">
								<input type="button" onclick="fnFileOpen(3)" 	value="업로드" class="file_input_button ml4 normal_btn2" /> 
							</td>
						</tr>
						<tr id="fileSample" style="display: none;">
							<td></td>
							<td>
								<div class="mr20" style="">
									<span>
									<img alt="" src="<c:url value='/Images/ico/ico_clip02.png' />">&nbsp;
									<a class="file_name" id="" style="color: rgb(0, 51, 255); line-height: 23px; cursor: pointer;" onclick="fnTpfAttachFileDownload(this);" href="#n"></a>&nbsp;
									<a onclick="fnTpfAttachFileDelete(this);" href="#n">
										<img alt="" src="<c:url value='/Images/btn/btn_del_reply.gif' />">
									</a>
									<input class="attachFileId" type="hidden" value="">
									<input class="fileSeq" type="hidden" value="">
									<input class="filePath" type="hidden" value="">
									<input class="fileNm" type="hidden" value="">
									</span>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
				<form id="fileForm" method="post" enctype="multipart/form-data">
					<input type="file" id="attachFile" name="file_name" value="" class="hidden" />
					<input type="hidden" id="fileType" name="fileType" value="" class="hidden" />
				</form>
			</div>
		</div>
		
   		<div class="btn_div mt10 cl">
			<div class="left_div">
				<p class="tit_p mt5 mb0">예산내역 변경</p>
			</div>
			<div class="right_div">
				<div class="controll_btn p0">
				</div>
			</div>
		</div>
		<div id="" class="com_ta2 sc_head" style="background: #f9f9f9;border-top: 1px solid #eaeaea;">
			<table style="border-top: none;">
				<colgroup>
					<col width="125">
					<col width="125">
					<col width="125">
					<col width="125">
					<col width="125">
					<col width="125">
				</colgroup>
				<thead>
					<tr>
						<th colspan="3">변경 전</th>
						<th colspan="3">변경 후</th>
					</tr>
					<tr>
						<th>프로젝트 </th>
						<th>예산과목 </th>
						<th>잔여금액 </th>
						<th>프로젝트 </th>
						<th>예산과목 </th>
						<th>잔여금액 </th>
					</tr>
				</thead>
			</table>
		</div>
		<div class="com_ta2 ova_sc2 cursor_p bg_lightgray" style="height:200px;">
			<table>
				<colgroup>
					<col width="125">
					<col width="125">
					<col width="125">
					<col width="125">
					<col width="125">
					<col width="125">
				</colgroup>
				<tbody id="tblBudgetListDataAfter2"></tbody>
			</table>
		</div>
    </div><!-- //pop_con -->
</div>

<div id="dialog-form-standard" style="display:none">
<div class="pop_wrap_dir" >
    <div class="pop_head">
        <h1></h1>
        <a href="#n" class="clo popClose"><img src="<c:url value='/Images/btn/btn_pop_clo02.png' />" alt="" /></a>
    </div>
    <div class="pop_con">       
        <!-- 사웝검색 box -->
        <div class="top_box" style="overflow:hidden;display:none;" id="deptEmp_Search" >
            <dl class="dl2">
                <dt class="mr0">
                        <input type="checkbox" name="userAllview" id="userAllview" class="" value="1" >
                        <label class="" for="userAllview" style=""><%=BizboxAMessage.getMessage("TX000009909","모든예산회계단위")%></label>
				</dt>
			</dl>
			<dl class="dl2">
				<dt class="mt2"><%=BizboxAMessage.getMessage("TX000016505","범위")%> : </dt>
				<dd>
						<input type="radio" name="B_use_YN"  id="B_use_YN_2" value="2"  class="">
                        <label class="mt3" for="B_use_YN_2" style=""><%=BizboxAMessage.getMessage("TX000000862","전체")%></label>
				</dd>
				<dd>
						<input type="radio" name="B_use_YN"  id="B_use_YN_1" value="1"  class="" checked="checked">
                        <label class="mt3" for="B_use_YN_1" style="" ><%=BizboxAMessage.getMessage("TX000004252","기준일")%> </label>
				</dd>
				<dd> <input type="text" name="BASIC_DT"  id="BASIC_DT"  value="${basic_dt }"  style="width: 80px;"/></dd>
				<dd><input type="button" id="user_Search" value="<%=BizboxAMessage.getMessage("TX000000899","조회")%>" /></dd>
            </dl>
        </div>
        
        
        <!-- 채주사원 등록  -->
        <div class="top_box" style="overflow:hidden;display:none;" id="EmpTrade_Search">
            <dl class="dl2">
                <dt class="mr0">
                        <%=BizboxAMessage.getMessage("TX000016505","범위")%>   :  
                         <input type="radio" name="B_use_YN2"  id="B_use_YN2_2"  value="2" />
                         <label  for="B_use_YN2_2" class="mR5"><%=BizboxAMessage.getMessage("TX000000862","전체")%></label>
                         <input type="radio" name="B_use_YN2" id="B_use_YN2_1"  value="1" checked="checked" /> 
                         <label  for="B_use_YN2_1" class="mR5"><%=BizboxAMessage.getMessage("TX000004252","기준일")%> </label>   
                         <input type="text" name="P_STD_DT"  id="P_STD_DT"  value="${basic_dt }"  style="width: 80px;"> 
                         <a href="javascript:;"  id="user_Search2" ><img src=" <c:url value='/Images/btn/search_icon2.png'/>" alt="<%=BizboxAMessage.getMessage("TX000000899","조회")%>" /></a>
                </dt>                
            </dl>
        </div>
        
        <!-- 예산검색 -->     
        <div class="top_box" style="overflow:hidden;display:none;" id="Budget_Search">
            <dl class="next">
                <dt style="width:100px;" class="en_w145">
                         <%=BizboxAMessage.getMessage("TX000005289","예산과목표시")%> :
                 </dt>
                 <dd>                         
                        <input type="radio" name="OPT_01" value="2"  id="OPT_01_2" class="k-radio " checked="checked" />
                        <label class="k-radio-label" for="OPT_01_2" style=";"><%=BizboxAMessage.getMessage("TX000005290","당기 편성된 예산과목만 표시")%></label>
                  </dd>
                  <dd>      
                        <input type="radio" name="OPT_01" value="1" id="OPT_01_1" class="k-radio" />
                        <label class="k-radio-label" for="OPT_01_1" style=""><%=BizboxAMessage.getMessage("TX000005112","모든 예산과목 표시")%></label>
                  </dd>
                  <dd class="en_mt3">      
                        <input type="radio" name="OPT_01" value="3" id="OPT_01_3" class="k-radio" />
                        <label class="k-radio-label" for="OPT_01_3" style=""><%=BizboxAMessage.getMessage("TX000005291","프로젝트 기간 예산 편성된 과목만 표시")%></label>
                  </dd>
            </dl>
            <dl class="next2 en_mt0">
                <dt style="width:100px;" class="en_w145">
                         <%=BizboxAMessage.getMessage("TX000005486","사용기한")%> : 
                </dt>
                <dd> 
                        <input type="radio" name="OPT_02" value="1" id="OPT_02_1" class="k-radio"  checked="checked" />
                        <label class="k-radio-label"  for="OPT_02_1" style=""><%=BizboxAMessage.getMessage("TX000004225","모두표시")%></label>
                        <input type="radio" name="OPT_02" value="2" id="OPT_02_2" class="k-radio" />
                        <label class="k-radio-label"  for="OPT_02_2" style=""><%=BizboxAMessage.getMessage("TX000009907","사용기한경과분 숨김")%></label>
                </dt>                
            </dl>
            <div class="mt14 ar text_blue posi_ab" id="deptEmp_SearchHint" style="bottom:10px;right:10px;display:none;" >※ 아래 (  ) 안에 명칭은 ERP 예산단계를 의미합니다.</div>            
        </div>
        
        <div class="top_box" style="overflow:hidden;display:none;" id="Trade_Search">
            <dl class="dl2">
                <dt class="mr0">
                <input type="checkbox" id="tradeAllview"/> <%=BizboxAMessage.getMessage("TX000016507","모든 거래처 보여주기")%> 
                </dt>
            </dl>
        </div>      
        
        <div class="top_box" style="overflow:hidden;display:none;" id="refDoc_Search">
            <dl class="dl2">
                <dt class="mr3">
                	기간 
                </dt>
                <dd>
                <input type="text" id="frDt"/> ~
                <input type="text" id="toDt"/>
                </dd>
            </dl>
        </div>
                                       
        <div class="com_ta2 mt10 ova_sc_all cursor_p"  style="height:340px;" id="dialog-form-standard-bind">
        </div>

    </div><!-- //pop_con -->
</div><!-- //pop_wrap -->
</div>

<div id="dialog-form-background" class="modal" style="display:none;">
<div id="window" style="display: none;"></div>
<div id="recvDetail"  style="z-index:800000; display:none;background-color: #FFFFFF;position:absolute;  top:120px; margin-left:100px;" ></div>

<div id="returnDiv" style="text-align: center;padding: 10px;">
	<input type="text" id="returnReason" style="width: 95%;"/>
	<br/>
	<br/>
	<input type="button" id="btnReturn" value="반려"/>
</div>