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
<script type="text/javascript" src="<c:url value='/js/jquery.form.js' />"></script>
<script type="text/javascript" src='<c:url value="/js/common/commFileUtil.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/common/outProcessUtil.js"></c:url>'></script>

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
	var purcContInspId = "${params.purcContInspId}";
	
$(function(){
	purcContInspInit();
	purcContInspEventHandler();
	
	fnResizeForm();
	setTimeout(function(){$(".pop_sign_wrap").height($("body").height());}, 100);
});

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

function purcContInspEventHandler(){
	$("#attachFile").bind({
		change : function(){
			fnTpfAttachFileUpload($(this));
		}
	});
	$("#purcContInsp input").bind({
		change : function(){
			updatePurcContInsp();
		}
	});
	$("#btnApproval").bind({
		click : function(){
			purcContInspApproval();
		}
	});
}

function purcContInspInit(){
	var parentEle = $('#purcContInsp');
	fnTpfDatepickerInit("inspDate");
	fnTpfDatepickerInit("deliveryDate");
	fnTpfComboBoxInit("PURC_INSP_OPINION1", "inspOpinion1", parentEle);
	fnTpfComboBoxInit("PURC_INSP_OPINION2", "inspOpinion2", parentEle);
	fnTpfComboBoxInit("PURC_INSP_OPINION3", "inspOpinion3", parentEle);
	fnTpfComboBoxInit("PURC_INSP_OPINION4", "inspOpinion4", parentEle);
	fnTpfComboBoxInit("PURC_INSP_OPINION5", "inspOpinion5", parentEle);
	fnTpfGetContInsp();
}

function fnTpfGetContInsp(){
	var data = getContInsp();
	var contInsp = data.contInsp;
	var contInspT1 = data.contInspT1;
	var contInspT2 = data.contInspT2;
	var contInspAttachFile = data.contInspAttachFile;
	fnTpfSetContInsp(contInsp);
	fnTpfSetContInspT1(contInspT1);
	fnTpfSetContInspT2(contInspT2);
	fnTpfSetContInspAttachFile(contInspAttachFile);
}

function getContInsp(){
	var result = {};
	var params = {};
	params.purcContInspId = $("#purcContInspId").val();
    var opt = {
    		url     : _g_contextPath_ + "/Ac/G20/Ex/getContInsp.do",
            async   : false,
            data    : params,
            successFn : function(data){
            	result = data;
            }
    };
    acUtil.ajax.call(opt);
    return result;
}

function fnTpfSetContInsp(contInsp){
	$("#txtPurcReqType").val(contInsp.purcReqType).attr("code", contInsp.purcReqTypeCodeId);
	$("#txtPurcReqNo").val(contInsp.purcReqNo);
	$("#txtContTitle").val(contInsp.contTitle);
	
	$("#inspOrder").val(contInsp.inspOrder);
	$("#deliveryFrDate").val(contInsp.contStartDate);
	$("#deliveryToDate").val(contInsp.contEndDate);
	$("#inspPlace").val(contInsp.inspPlace);
	$("#remark").val(contInsp.remark);
	$("#trNm").val(contInsp.trNm);
	
	if(contInsp.inspDate){
		$("#inspDate").data("kendoDatePicker").value(contInsp.inspDate);
	}
	if(contInsp.deliveryDate){
		$("#deliveryDate").data("kendoDatePicker").value(contInsp.deliveryDate);
	}
	if(contInsp.inspOpinion1){
		$("#inspOpinion1").data("kendoComboBox").value(contInsp.inspOpinion1);
	}
	if(contInsp.inspOpinion2){
		$("#inspOpinion2").data("kendoComboBox").value(contInsp.inspOpinion2);
	}
	if(contInsp.inspOpinion3){
		$("#inspOpinion3").data("kendoComboBox").value(contInsp.inspOpinion3);
	}
	if(contInsp.inspOpinion4){
		$("#inspOpinion4").data("kendoComboBox").value(contInsp.inspOpinion4);
	}
	if(contInsp.inspOpinion5){
		$("#inspOpinion5").data("kendoComboBox").value(contInsp.inspOpinion5);
	}
	if(contInsp.purcReqTypeCodeId == "3" || contInsp.purcReqTypeCodeId == "4"){
		$("#trOpRow2").hide();
		$(".op3").hide();
		$(".optxt2").html("과업지시서와 내용은 일치 하는가?");
		$("#trOpRow1").append($(".op5"));
	}
	if(contInsp.purcReqTypeCodeId == "3"){
		$(".optxt2").html("공사 내역서 및 시방서와 내용은 일치 하는가?");
		$("#thContNm").html("공사명");
		$("#thContContents").html("공사내용");
	}
}

function fnTpfSetContInspT1(contInspT){
	if(contInspT.length > 0){
		$("#purcContInspT1").show();
	}else{
		$("#purcContInspT1").hide();
	}
	$.each(contInspT, function(){
		var tr = $("#purcContInspT1-tablesample tr").clone();
		tr.attr("id", this.purcContInspTId);
		$(".contItemNm", tr).val(this.contItemNm);
		$(".contContents", tr).val(this.contContents);
		$(".contUnitAm", tr).val(this.contUnitAm.toString().toMoney());
		$(".contSupAm", tr).val(this.contSupAm.toString().toMoney());
		$(".contVatAm", tr).val(this.contVatAm.toString().toMoney());
		$(".unitAm", tr).val(this.unitAm.toString().toMoney()).attr("orgAm", this.orgAm.toString().toMoney());
		$(".supAm", tr).val(this.supAm.toString().toMoney());
		$(".vatAm", tr).val(this.vatAm.toString().toMoney());
		
		$(tr).attr("vatFg", this.vatFg);
		
		$(".unitAm", tr).bind({
			keyup : function(){
				var obj = $(this);
				obj.val(obj.val().toString().toMoney());
				var unitAm = parseInt(obj.val().toString().toMoney2());
				var orgAm = parseInt(obj.attr("orgAm").toString().toMoney2());
				if(orgAm < unitAm){
					alert("남은 검수 금액을 초과 할 수 없습니다.")
					obj.val(orgAm.toString().toMoney());
				}
				unitAm = parseInt(obj.val().toString().toMoney2());
				var supAm = unitAm;
				if($(tr).attr("vatFg") == "1"){
					supAm = Math.round(Math.round(unitAm / 1.1 * 10) / 10);
				}
				var vatAm = unitAm - supAm
				$(".unitAm", tr).val(unitAm.toString().toMoney());
				$(".supAm", tr).val(supAm.toString().toMoney());
				$(".vatAm", tr).val(vatAm.toString().toMoney());
			}
		});
		$(".unitAm", tr).bind({
			focusout : function(){
				fnUpdateInspT($(this));
			}
		});
		$("#purcContInspT1 tbody").append(tr);
	});
}

function fnTpfSetContInspT2(contInspT){
	if(contInspT.length > 0){
		$("#purcContInspT2").show();
	}else{
		$("#purcContInspT2").hide();
	}
	if($("#txtPurcReqType").attr("code") == "2"){
		$(".colspanTh").attr("colspan", 7);
		$(".opHidden").show();
	}else{
		$(".colspanTh").attr("colspan", 6);
		$(".opHidden").hide();
	}
	$.each(contInspT, function(){
		var tr = $("#purcContInspT2-tablesample tr").clone();
		tr.attr("id", this.purcContInspTId);
		$(".contItemType", tr).val(this.contItemType);
		$(".contItemNm", tr).val(this.contItemNm);
		$(".contItemCnt", tr).val(this.contItemCnt);
		$(".contStandard", tr).val(this.contStandard);
		$(".contItemAm", tr).val(this.contItemAm.toString().toMoney());
		$(".contUnitAm", tr).val(this.contUnitAm.toString().toMoney());
		$(".contSupAm", tr).val(this.contSupAm.toString().toMoney());
		$(".contVatAm", tr).val(this.contVatAm.toString().toMoney());
		if(this.contPpsFees){
			$(".contPpsFees", tr).val(this.contPpsFees.toString().toMoney());
		}
		$(".itemCnt", tr).val(this.itemCnt).attr("orgCnt", this.orgCnt);
		$(".standard", tr).val(this.standard);
		$(".itemAm", tr).val(this.itemAm.toString().toMoney());
		$(".unitAm", tr).val(this.unitAm.toString().toMoney());
		$(".supAm", tr).val(this.supAm.toString().toMoney());
		$(".vatAm", tr).val(this.vatAm.toString().toMoney());
		if(this.ppsFees){
			$(".ppsFees", tr).val(this.ppsFees.toString().toMoney());
		}
		
		$(tr).attr("vatFg", this.vatFg);
		
		$(".itemCnt", tr).bind({
			keyup : function(){
				var obj = $(this);
				obj.val(obj.val().toString().toMoney2());
				var orgCnt = parseInt(obj.attr("orgCnt").toString().toMoney2());
				var itemCnt = parseInt(obj.val().toString().toMoney2());
				if(orgCnt < itemCnt){
					alert("수량은 최초 수량을 초과할 수 없습니다.")
					obj.val(orgCnt);
				}
				itemCnt = parseInt($(".itemCnt", tr).val().toMoney2());
				var itemAm = parseInt($(".itemAm", tr).val().toMoney2());
				var unitAm = itemCnt * itemAm;
				var supAm = unitAm;
				if($(tr).attr("vatFg") == "1"){
					supAm = Math.round(Math.round(unitAm / 1.1 * 10) / 10);
				}
				var vatAm = unitAm - supAm
				if($("#txtPurcReqType").attr("code") == "2"){
					var ppsFees = Math.floor(unitAm * 0.0054);
					unitAm += ppsFees;
					$(".ppsFees", tr).val(ppsFees.toString().toMoney());
				}
				$(".unitAm", tr).val(unitAm.toString().toMoney());
				$(".supAm", tr).val(supAm.toString().toMoney());
				$(".vatAm", tr).val(vatAm.toString().toMoney());
			}
		});
		$(".itemCnt, .standard", tr).bind({
			focusout : function(){
				fnUpdateInspT($(this));
			}
		});
		$("#purcContInspT2 tbody").append(tr);
	});
}

function fnUpdateInspT(obj){
	var tr = obj.closest("tr");
	var params = {};
	if(obj.hasClass("unitAm")){
		var unitAm = parseInt(obj.val().toString().toMoney2());
		var orgAm = parseInt(obj.attr("orgAm").toString().toMoney2());
		if(orgAm < unitAm){
			obj.val(orgAm.toString().toMoney());
		}
	}else{
		var orgCnt = parseInt($(".itemCnt", tr).attr("orgCnt").toString().toMoney2());
		var itemCnt = parseInt($(".itemCnt", tr).val().toString().toMoney2());
		if(orgCnt < itemCnt){
			$(".itemCnt", tr).val(orgCnt);
			return;
		}
		params.itemCnt = $(".itemCnt", tr).val().toMoney2();
		params.standard = $(".standard", tr).val();
		params.itemAm = $(".itemAm", tr).val().toMoney2();
	}
	params.purcContInspTId = tr.attr("id");
	params.unitAm = $(".unitAm", tr).val().toMoney2();
	params.supAm = $(".supAm", tr).val().toMoney2();
	params.vatAm = $(".vatAm", tr).val().toMoney2();
	if($(".ppsFees", tr).val()){
		params.ppsFees = $(".ppsFees", tr).val().toMoney2();
	}
    var opt = {
    		url     : _g_contextPath_ + "/Ac/G20/Ex/updatePurcContInspT.do",
            async   : false,
            data    : params,
            successFn : function(data){
            	
            }
    };
    acUtil.ajax.call(opt);
}

function fnTpfSetContInspAttachFile(attachFileList){
	$.each(attachFileList, function(){
		var span = $('#fileSample div').clone();
		$('.file_name', span).html(this.real_file_name + '.' + this.file_extension);
		$('.attachFileId', span).val(this.attach_file_id);
		$('.fileSeq', span).val(this.file_seq);
		$('.filePath', span).val(this.file_path);
		$('.fileNm', span).val(this.real_file_name + '.' + this.file_extension);
		$('#fileArea').append(span);
	});
}

function fnTpfDatepickerInit(id){
	var eventEle = $("#" + id);
	eventEle.kendoDatePicker( {
    	format : "yyyy-MM-dd",
    	culture : "ko-KR",
    });
	$("#" + id).attr("disabled", true);
}

/**
 * 콤보박스 초기화
 */
function fnTpfComboBoxInit(groupCode, id, parentEle){
	var commCodeList = fnTpfGetCommCodeList(groupCode);
	var itemType = $("#" + id, parentEle).kendoComboBox({
		dataSource : commCodeList,
		dataTextField: "code_kr",
		dataValueField: "code",
		index: 0
    });
	$('.' + id, parentEle).attr('disabled', true);
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

/**
 * 첨부파일 선택창 오픈
 * */
function fnFileOpen(){
	$('#attachFile').click();
}

/**
 * 첨부파일 업로드
 * */
function fnTpfAttachFileUpload(obj){
	var targetId = purcContInspId;
	var targetTableName = 'tpf_purc_cont_insp';
	var path = 'tpf_purc_insp';
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
		$('#fileArea').append(span);
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

function updatePurcContInsp(){
	var params = {};
	params.purcContInspId = $("#purcContInspId").val();
	params.inspDate = $("#inspDate").val();
	params.deliveryDate = $("#deliveryDate").val();
	params.inspPlace = $("#inspPlace").val();
	params.remark = $("#remark").val();
	params.inspOpinion1 = $("#inspOpinion1").data("kendoComboBox").value();
	params.inspOpinionText1 = $("#inspOpinion1").data("kendoComboBox").text();
	params.inspOpinion2 = $("#inspOpinion2").data("kendoComboBox").value();
	params.inspOpinionText2 = $("#inspOpinion2").data("kendoComboBox").text();
	params.inspOpinion3 = $("#inspOpinion3").data("kendoComboBox").value();
	params.inspOpinionText3 = $("#inspOpinion3").data("kendoComboBox").text();
	params.inspOpinion4 = $("#inspOpinion4").data("kendoComboBox").value();
	params.inspOpinionText4 = $("#inspOpinion4").data("kendoComboBox").text();
	params.inspOpinion5 = $("#inspOpinion5").data("kendoComboBox").value();
	params.inspOpinionText5 = $("#inspOpinion5").data("kendoComboBox").text();
    var opt = {
    		url     : _g_contextPath_ + "/Ac/G20/Ex/updatePurcContInsp.do",
            async   : false,
            data    : params,
            successFn : function(data){
            	result = data;
            }
    };
    acUtil.ajax.call(opt);
}

function purcContInspApproval(){
// 	if(!$("#inspPlace").val()){
// 		alert("검수장소를 입력하세요.");
// 		return;
// 	}
	if($('#fileArea span').length < 1){
		alert('필수첨부파일을 등록하세요.')
		return false;
	}
	if(confirm('검수보고를 작성합니다.')){
		updatePurcContInsp();
		var params = {};
	    params.compSeq =$('#compSeq').val();
	    params.outProcessCode = "tpfInsp";
	    if(location.host.indexOf("127.0.0.1") > -1 || location.host.indexOf("localhost") > -1){
	    	params.outProcessCode = "tpfInsp";
	    }else{
	    	params.outProcessCode = "tpfInsp";
	    }
	    var purcReqType = $("#txtPurcReqType").attr("code");
	    if(purcReqType == "3"){
	    	params.outProcessCode = "tpfInsp3";
	    }else if(purcReqType == "4"){
	    	params.outProcessCode = "tpfInsp4";
	    }
	    
	    params.approKey = params.outProcessCode + purcContInspId;
	    params.empSeq = $('#empSeq').val();
	    params.mod = 'W';
	    params.fileKey = makeFileKey();
	    var result = getContInsp();
	    params.contentsStr = makeContentsStr(result);
	    params.prev_url = location.href;
	    params.prev_name = "정보수정";
	    window.resizeTo(1000, 900);
	    outProcessLogOn2(params);
	    //window.close();
	}
}

/**
 * 파일키 생성
 */
function makeFileKey(){
	var fileKey = "";
	var saveObj = {};
	saveObj.targetId = purcContInspId;
	saveObj.targetTableName = "tpf_purc_cont_insp";
	var opt = {
    		url : _g_contextPath_ + "/Ac/G20/Ex/makeFileKey.do",
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

 function makeContentsStr(data){
	var resultData = getErpTrade(data.contInsp.trCd, data.contInsp.trNm);
	if(resultData.length > 0){
		data.contInsp.addr = resultData[0].ADDR;
	}
	var purcReqType = $("#txtPurcReqType").attr("code");
	var contentsStr = "";
	if(purcReqType == "1"){	// 물품
		contentsStr = makeContents1(data);
	}else if(purcReqType == "2"){	// 물품(조달청)
		contentsStr = makeContents1(data);
	}else if(purcReqType == "3"){	// 공사
		contentsStr = makeContents3(data);
	}else if(purcReqType == "4"){	// 용역
		contentsStr = makeContents4(data);
	}
	makeContentsStrSave(contentsStr);
	return contentsStr;
 }
 
 function makeContents1(data){
	 var contInsp = data.contInsp;
	 var contentsStr = "";
	 contentsStr += "<TABLE border='1' cellspacing='0' cellpadding='0' style='border-collapse:collapse;border:none;margin:0px;'>";
	 contentsStr += "<TR>";
	 contentsStr += "	<TD valign='middle' bgcolor='#d6d6d6'  width='140' height='43' style='border-left:none;border-right:solid #000000 0.4pt;border-top:none;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:left;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:160%'>계　약　건　명</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "	<TD valign='middle' width='540' height='43' style='border-left:solid #000000 0.4pt;border-right:solid #000000 1.4pt;border-top:none;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:200%;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:200%'>" + contInsp.contTitle + "</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "</TR>";
	 contentsStr += "<TR>";
	 contentsStr += "	<TD valign='middle' bgcolor='#d6d6d6'  width='127' height='56' style='border-left:none;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:left;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:160%'>납 품 자</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "	<TD valign='middle' width='550' height='56' style='border-left:solid #000000 0.4pt;border-right:solid #000000 1.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:160%'>&nbsp;주&nbsp; 소 : " + contInsp.addr + "</SPAN></P>";
	 contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:160%'>&nbsp;업체명 :&nbsp;" + contInsp.trNm + "&nbsp; 대표자 : " + contInsp.ceoNm + "</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "</TR>";
	 contentsStr += "<TR>";
	 contentsStr += "	<TD valign='middle' bgcolor='#d6d6d6'  width='127' height='43' style='border-left:none;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:left;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:160%'>계 약 금 액</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "	<TD valign='middle' width='550' height='43' style='border-left:solid #000000 0.4pt;border-right:solid #000000 1.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:200%;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';letter-spacing:-8%;line-height:200%'>금" + contInsp.contAm.toString().toMoney() + "원</SPAN><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:200%'>(금" + numToKOR(contInsp.contAm.toString()) + "원)</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "</TR>";
	 contentsStr += "<TR>";
	 contentsStr += "	<TD valign='middle' bgcolor='#d6d6d6'  width='127' height='43' style='border-left:none;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:left;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';letter-spacing:-14%;line-height:160%'>계약체결년월일</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "	<TD valign='middle' width='550' height='43' style='border-left:solid #000000 0.4pt;border-right:solid #000000 1.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:160%'>" + moment(contInsp.contDate).format("YYYY년 MM월 DD일") + "</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "</TR>";
	 contentsStr += "<TR>";
	 contentsStr += "	<TD valign='middle' bgcolor='#d6d6d6'  width='127' height='43' style='border-left:none;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:left;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:160%'>납 품 기 한</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "	<TD valign='middle' width='550' height='43' style='border-left:solid #000000 0.4pt;border-right:solid #000000 1.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:160%'>" + moment(contInsp.contEndDate).format("YYYY년 MM월 DD일") + "까지</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "</TR>";
	 contentsStr += "<TR>";
	 contentsStr += "	<TD valign='middle' bgcolor='#d6d6d6'  width='127' height='43' style='border-left:none;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:left;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:160%'>납품 년월일</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "	<TD valign='middle' width='550' height='43' style='border-left:solid #000000 0.4pt;border-right:solid #000000 1.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:110%;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:110%'>" + moment(contInsp.deliveryDate).format("YYYY년 MM월 DD일") + "</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "</TR>";
	 contentsStr += "<TR>";
	 contentsStr += "	<TD valign='middle' bgcolor='#d6d6d6'  width='127' height='43' style='border-left:none;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:left;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';letter-spacing:-12%;line-height:160%'>검사(수)년월일</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "	<TD valign='middle' width='550' height='43' style='border-left:solid #000000 0.4pt;border-right:solid #000000 1.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:160%'>" + moment(contInsp.inspDate).format("YYYY년 MM월 DD일") + "</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "</TR>";
	 contentsStr += "<TR>";
	 contentsStr += "	<TD valign='middle' bgcolor='#d6d6d6'  width='127' height='43' style='border-left:none;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:left;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:160%'>검사(수)장소</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "	<TD valign='middle' width='550' height='43' style='border-left:solid #000000 0.4pt;border-right:solid #000000 1.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:160%'>&nbsp;" + contInsp.inspPlace + "</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "</TR>";
	 contentsStr += "<TR>";
	 contentsStr += "	<TD valign='middle' bgcolor='#d6d6d6'  width='127' height='43' style='border-left:none;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:left;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:160%'>물품검사내역</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "	<TD valign='middle' width='550' height='43' style='border-left:solid #000000 0.4pt;border-right:solid #000000 1.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:160%'>별첨 내역과 같음</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "</TR>";
	 contentsStr += "<TR>";
	 contentsStr += "	<TD colspan='2' valign='middle' width='676' height='169' style='border-left:none;border-right:solid #000000 1.4pt;border-top:solid #000000 0.4pt;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:160%'>　위와 같이 물품 검사(수)하였음.</SPAN></P>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:160%'>　</SPAN></P>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:160%'>" + moment().format("YYYY년　　MM월　　DD일") + "</SPAN></P>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:160%'>&nbsp;</SPAN></P>";
	 contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:160%'>&nbsp;</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "</TR>";
	 contentsStr += "</TABLE>";
	 
// 	 contentsStr += "<TABLE border='1' cellspacing='0' cellpadding='0' style='border-collapse:collapse;border:none;'>";
// 	 contentsStr += "<TR>";
// 	 contentsStr += "	<TD colspan='8' valign='middle' width='635' height='51' style='border-left:none;border-right:none;border-top:none;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
// 	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';font-weight:bold;line-height:160%'>물 품 검 사 (수) 내 역 서</SPAN></P>";
// 	 contentsStr += "	</TD>";
// 	 contentsStr += "</TR>";
// 	 contentsStr += "<TR>";
// 	 contentsStr += "	<TD rowspan='2' valign='middle' width='76' height='77' style='border-left:none;border-right:none;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
// 	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'휴먼명조';line-height:160%'>물품목록</SPAN></P>";
// 	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'휴먼명조';line-height:160%'>번&nbsp;&nbsp;&nbsp; 호 </SPAN></P>";
// 	 contentsStr += "	</TD>";
// 	 contentsStr += "	<TD valign='middle' width='125' height='38' style='border-left:none;border-right:none;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
// 	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'휴먼명조';line-height:160%'>물품명</SPAN></P>";
// 	 contentsStr += "	</TD>";
// 	 contentsStr += "	<TD rowspan='2' valign='middle' width='42' height='77' style='border-left:none;border-right:none;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
// 	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'휴먼명조';line-height:160%'>단위</SPAN></P>";
// 	 contentsStr += "	</TD>";
// 	 contentsStr += "	<TD rowspan='2' valign='middle' width='83' height='77' style='border-left:none;border-right:none;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
// 	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'휴먼명조';line-height:160%'>단가(원)</SPAN></P>";
// 	 contentsStr += "	</TD>";
// 	 contentsStr += "	<TD rowspan='2' valign='middle' width='76' height='77' style='border-left:none;border-right:none;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
// 	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'휴먼명조';line-height:160%'>계약상의 수&nbsp;&nbsp;&nbsp; 량</SPAN></P>";
// 	 contentsStr += "	</TD>";
// 	 contentsStr += "	<TD rowspan='2' valign='middle' width='79' height='77' style='border-left:none;border-right:none;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
// 	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'휴먼명조';letter-spacing:-17%;line-height:160%'>전회까지의 </SPAN><SPAN STYLE='font-size:13.0pt;font-family:'휴먼명조';line-height:160%'>납품수량</SPAN></P>";
// 	 contentsStr += "	</TD>";
// 	 contentsStr += "	<TD rowspan='2' valign='middle' width='79' height='77' style='border-left:none;border-right:none;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
// 	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'휴먼명조';line-height:160%'>금&nbsp;&nbsp;&nbsp; 회</SPAN></P>";
// 	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'휴먼명조';letter-spacing:-11%;line-height:160%'>검사(수량)</SPAN></P>";
// 	 contentsStr += "	</TD>";
// 	 contentsStr += "	<TD rowspan='2' valign='middle' width='76' height='77' style='border-left:none;border-right:none;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
// 	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'휴먼명조';line-height:160%'>사용부서</SPAN></P>";
// 	 contentsStr += "	</TD>";
// 	 contentsStr += "</TR>";
// 	 contentsStr += "<TR>";
// 	 contentsStr += "	<TD valign='middle' width='125' height='38' style='border-left:none;border-right:none;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
// 	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'휴먼명조';line-height:160%'>규격명</SPAN></P>";
// 	 contentsStr += "	</TD>";
// 	 contentsStr += "</TR>";
// 	 var contInspT2 = data.contInspT2;
// 	 var borderWidth = "0.4pt";
// 	 $.each(contInspT2, function(inx){
// 		 if((inx + 1) == contInspT2.length){
// 			 borderWidth = "1.1pt";
// 		 }
// 		 contentsStr += "<TR>";
// 		 contentsStr += "	<TD rowspan='2' valign='middle' width='76' height='61' style='border-left:none;border-right:none;border-top:solid #000000 0.4pt;border-bottom:solid #000000 " + borderWidth + ";padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
// 		 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'휴먼명조';line-height:160%'>&nbsp;" + (inx + 1) + "</SPAN></P>";
// 		 contentsStr += "	</TD>";
// 		 contentsStr += "	<TD valign='middle' width='125' height='31' style='border-left:none;border-right:none;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
// 		 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'휴먼명조';line-height:160%'>&nbsp;" + this.contItemNm + "</SPAN></P>";
// 		 contentsStr += "	</TD>";
// 		 contentsStr += "	<TD rowspan='2' valign='middle' width='42' height='61' style='border-left:none;border-right:none;border-top:solid #000000 0.4pt;border-bottom:solid #000000 " + borderWidth + ";padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
// 		 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'휴먼명조';line-height:160%'>&nbsp;" + this.contItemNm + "</SPAN></P>";
// 		 contentsStr += "	</TD>";
// 		 contentsStr += "	<TD rowspan='2' valign='middle' width='83' height='61' style='border-left:none;border-right:none;border-top:solid #000000 0.4pt;border-bottom:solid #000000 " + borderWidth + ";padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
// 		 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'휴먼명조';line-height:160%'>&nbsp;" + this.contItemAm + "</SPAN></P>";
// 		 contentsStr += "	</TD>";
// 		 contentsStr += "	<TD rowspan='2' valign='middle' width='76' height='61' style='border-left:none;border-right:none;border-top:solid #000000 0.4pt;border-bottom:solid #000000 " + borderWidth + ";padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
// 		 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'휴먼명조';line-height:160%'>&nbsp;" + this.contItemCnt + "</SPAN></P>";
// 		 contentsStr += "	</TD>";
// 		 contentsStr += "	<TD rowspan='2' valign='middle' width='79' height='61' style='border-left:none;border-right:none;border-top:solid #000000 0.4pt;border-bottom:solid #000000 " + borderWidth + ";padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
// 		 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'휴먼명조';line-height:160%'>&nbsp;" + "0" + "</SPAN></P>";
// 		 contentsStr += "	</TD>";
// 		 contentsStr += "	<TD rowspan='2' valign='middle' width='79' height='61' style='border-left:none;border-right:none;border-top:solid #000000 0.4pt;border-bottom:solid #000000 " + borderWidth + ";padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
// 		 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'휴먼명조';line-height:160%'>&nbsp;" + this.itemCnt + "</SPAN></P>";
// 		 contentsStr += "	</TD>";
// 		 contentsStr += "	<TD rowspan='2' valign='middle' width='76' height='61' style='border-left:none;border-right:none;border-top:solid #000000 0.4pt;border-bottom:solid #000000 " + borderWidth + ";padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
// 		 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'휴먼명조';line-height:160%'>&nbsp;" + "" + "</SPAN></P>";
// 		 contentsStr += "	</TD>";
// 		 contentsStr += "</TR>";
// 		 contentsStr += "<TR>";
// 		 contentsStr += "	<TD valign='middle' width='125' height='31' style='border-left:none;border-right:none;border-top:solid #000000 0.4pt;border-bottom:solid #000000 " + borderWidth + ";padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
// 		 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'휴먼명조';line-height:160%'>&nbsp;" + this.contStandard + "</SPAN></P>";
// 		 contentsStr += "	</TD>";
// 		 contentsStr += "</TR>";
// 	 });
// 	 contentsStr += "</TABLE></P>";
	 return contentsStr;
 }
 
 function makeContents2(data){
	 var contInsp = data.contInsp;
	 var contentsStr = "";
	 return contentsStr;
 }
 
 function makeContents3(data){
	 var contInsp = data.contInsp;
	 var contentsStr = "";
	 contentsStr += "<TABLE border='1' cellspacing='0' cellpadding='0' style='border-collapse:collapse;border:none;'>";
	 contentsStr += "<TR>";
	 contentsStr += "	<TD valign='middle' bgcolor='#d8d8d8'  width='135' height='50' style='border-left:none;border-right:solid #000000 0.4pt;border-top:none;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';letter-spacing:37%;line-height:160%'>공 사 명</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "	<TD colspan='3' valign='middle' width='541' height='50' style='border-left:solid #000000 0.4pt;border-right:none;border-top:none;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:200%;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:200%'>&nbsp;" + contInsp.contTitle + "</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "</TR>";
	 contentsStr += "<TR>";
	 contentsStr += "	<TD valign='middle' bgcolor='#d8d8d8'  width='135' height='50' style='border-left:none;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';letter-spacing:36%;line-height:160%'>도 급 자</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "	<TD colspan='3' valign='middle' width='541' height='50' style='border-left:solid #000000 0.4pt;border-right:none;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='line-height:130%;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:130%'>&nbsp;주&nbsp; 소 : " + contInsp.addr + "</SPAN></P>";
	 contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:160%'>&nbsp;업체명 :&nbsp;" + contInsp.trNm + " 대표자 : " + contInsp.ceoNm + "</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "</TR>";
	 contentsStr += "<TR>";
	 contentsStr += "	<TD valign='middle' bgcolor='#d8d8d8'  width='135' height='50' style='border-left:none;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';letter-spacing:40%;line-height:160%'>계약금액</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "	<TD colspan='3' valign='middle' width='541' height='50' style='border-left:solid #000000 0.4pt;border-right:none;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:200%;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';letter-spacing:-8%;line-height:200%'>&nbsp;금" + contInsp.contAm.toString().toMoney() + "원</SPAN><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:200%'>(금" + numToKOR(contInsp.contAm.toString()) + "원)</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "</TR>";
	 contentsStr += "<TR>";
	 contentsStr += "	<TD valign='middle' bgcolor='#d8d8d8'  width='135' height='50' style='border-left:none;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';letter-spacing:3%;line-height:160%'>계약년월일</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "	<TD valign='middle' width='203' height='50' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:200%;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:200%'>" + moment(contInsp.contDate).format("YYYY년 MM월 DD일") + "</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "	<TD valign='middle' bgcolor='#d8d8d8'  width='135' height='50' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';letter-spacing:31%;line-height:160%'>준공기한</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "	<TD valign='middle' width='203' height='50' style='border-left:solid #000000 0.4pt;border-right:none;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:200%;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:200%'>" + moment(contInsp.contEndDate).format("YYYY년 MM월 DD일") + "</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "</TR>";
	 contentsStr += "<TR>";
	 contentsStr += "	<TD valign='middle' bgcolor='#d8d8d8'  width='135' height='50' style='border-left:none;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';letter-spacing:2%;line-height:160%'>착공년월일</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "	<TD valign='middle' width='203' height='50' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:200%;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:200%'>" + moment(contInsp.contStartDate).format("YYYY년 MM월 DD일") + "</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "	<TD valign='middle' bgcolor='#d8d8d8'  width='135' height='50' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:160%'>준공년월일</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "	<TD valign='middle' width='203' height='50' style='border-left:solid #000000 0.4pt;border-right:none;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:200%;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:200%'>" + moment(contInsp.deliveryDate).format("YYYY년 MM월 DD일") + "</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "</TR>";
	 contentsStr += "<TR>";
	 contentsStr += "	<TD valign='middle' bgcolor='#d8d8d8'  width='135' height='50' style='border-left:none;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';letter-spacing:33%;line-height:160%'>준공검사</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "	<TD valign='middle' width='203' height='50' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:110%;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:110%'>" + moment(contInsp.inspDate).format("YYYY년 MM월 DD일") + "</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "	<TD valign='middle' bgcolor='#d8d8d8'  width='135' height='50' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:160%'>&nbsp;</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "	<TD valign='middle' width='203' height='50' style='border-left:solid #000000 0.4pt;border-right:none;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:160%'>&nbsp;</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "</TR>";
	 contentsStr += "<TR>";
	 contentsStr += "	<TD valign='middle' bgcolor='#d8d8d8'  width='135' height='50' style='border-left:none;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';letter-spacing:35%;line-height:160%'>참고사항</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "	<TD colspan='3' valign='middle' width='541' height='50' style='border-left:solid #000000 0.4pt;border-right:none;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:160%'>&nbsp;" + contInsp.remark + "</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "</TR>";
	 contentsStr += "<TR>";
	 contentsStr += "	<TD colspan='4' valign='middle' width='676' height='233' style='border-left:none;border-right:none;border-top:solid #000000 0.4pt;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='line-height:200%;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:200%'>&nbsp;</SPAN></P>";
	 contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:160%'>&nbsp;&nbsp;&nbsp;위와 같이 준공검사를 필하였음.</SPAN></P>";
	 contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:160%'>　</SPAN></P>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:160%'>" + moment().format("YYYY년　　MM월　　DD일") + "</SPAN></P>";
	 contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:160%'>&nbsp;</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "</TR>";
	 contentsStr += "</TABLE>";
	 return contentsStr;
 }
 
 function makeContents4(data){
	 var contInsp = data.contInsp;
	 var contentsStr = "";
	 contentsStr += "<TABLE border='1' cellspacing='0' cellpadding='0' style='border-collapse:collapse;border:none;margin:0px;'>";
	 contentsStr += "<TR style='margin:0px;'>";
	 contentsStr += "	<TD valign='middle' bgcolor='#d8d8d8'  width='135' height='50' style='border-left:none;border-right:solid #000000 0.4pt;border-top:none;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt;margin:0px;'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';letter-spacing:37%;line-height:160%'>용 역 명</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "	<TD colspan='3' valign='middle' width='541' height='50' style='border-left:solid #000000 0.4pt;border-right:none;border-top:none;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:200%;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:200%'>&nbsp;" + contInsp.contTitle + "</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "</TR>";
	 contentsStr += "<TR>";
	 contentsStr += "	<TD valign='middle' bgcolor='#d8d8d8'  width='135' height='50' style='border-left:none;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';letter-spacing:36%;line-height:160%'>도 급 자</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "	<TD colspan='3' valign='middle' width='541' height='50' style='border-left:solid #000000 0.4pt;border-right:none;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='line-height:130%;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:130%'>&nbsp;주&nbsp; 소 : " + contInsp.addr + "</SPAN></P>";
	 contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:160%'>&nbsp;업체명 :&nbsp;" + contInsp.trNm + " 대표자 : " + contInsp.ceoNm + "</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "</TR>";
	 contentsStr += "<TR>";
	 contentsStr += "	<TD valign='middle' bgcolor='#d8d8d8'  width='135' height='50' style='border-left:none;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';letter-spacing:40%;line-height:160%'>계약금액</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "	<TD colspan='3' valign='middle' width='541' height='50' style='border-left:solid #000000 0.4pt;border-right:none;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:200%;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';letter-spacing:-8%;line-height:200%'>&nbsp;금" + contInsp.contAm.toString().toMoney() + "원</SPAN><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:200%'>(금" + numToKOR(contInsp.contAm.toString()) + "원)</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "</TR>";
	 contentsStr += "<TR>";
	 contentsStr += "	<TD valign='middle' bgcolor='#d8d8d8'  width='135' height='50' style='border-left:none;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';letter-spacing:3%;line-height:160%'>계약년월일</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "	<TD valign='middle' width='203' height='50' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:200%;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:200%'>" + moment(contInsp.contDate).format("YYYY년 MM월 DD일") + "</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "	<TD valign='middle' bgcolor='#d8d8d8'  width='135' height='50' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';letter-spacing:31%;line-height:160%'>완료기한</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "	<TD valign='middle' width='203' height='50' style='border-left:solid #000000 0.4pt;border-right:none;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:200%;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:200%'>" + moment(contInsp.contEndDate).format("YYYY년 MM월 DD일") + "</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "</TR>";
	 contentsStr += "<TR>";
	 contentsStr += "	<TD valign='middle' bgcolor='#d8d8d8'  width='135' height='50' style='border-left:none;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';letter-spacing:2%;line-height:160%'>착수년월일</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "	<TD valign='middle' width='203' height='50' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:200%;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:200%'>" + moment(contInsp.contStartDate).format("YYYY년 MM월 DD일") + "</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "	<TD valign='middle' bgcolor='#d8d8d8'  width='135' height='50' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:160%'>완료년월일</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "	<TD valign='middle' width='203' height='50' style='border-left:solid #000000 0.4pt;border-right:none;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:200%;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:200%'>" + moment(contInsp.deliveryDate).format("YYYY년 MM월 DD일") + "</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "</TR>";
	 contentsStr += "<TR>";
	 contentsStr += "	<TD valign='middle' bgcolor='#d8d8d8'  width='135' height='50' style='border-left:none;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';letter-spacing:33%;line-height:160%'>완료검사</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "	<TD valign='middle' width='203' height='50' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:110%;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:110%'>" + moment(contInsp.inspDate).format("YYYY년 MM월 DD일") + "</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "	<TD valign='middle' bgcolor='#d8d8d8'  width='135' height='50' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:160%'>&nbsp;</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "	<TD valign='middle' width='203' height='50' style='border-left:solid #000000 0.4pt;border-right:none;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:160%'>&nbsp;</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "</TR>";
	 contentsStr += "<TR>";
	 contentsStr += "	<TD valign='middle' bgcolor='#d8d8d8'  width='135' height='50' style='border-left:none;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';letter-spacing:35%;line-height:160%'>참고사항</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "	<TD colspan='3' valign='middle' width='541' height='50' style='border-left:solid #000000 0.4pt;border-right:none;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:160%'>&nbsp;" + contInsp.remark + "</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "</TR>";
	 contentsStr += "<TR>";
	 contentsStr += "	<TD colspan='4' valign='middle' width='676' height='233' style='border-left:none;border-right:none;border-top:solid #000000 0.4pt;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='line-height:200%;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:200%'>&nbsp;</SPAN></P>";
	 contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:160%'>&nbsp;&nbsp;&nbsp;위와 같이 완료검사를 필하였음.</SPAN></P>";
	 contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:160%'>　</SPAN></P>";
	 contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:160%'>" + moment().format("YYYY년　　MM월　　DD일") + "</SPAN></P>";
	 contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:15.0pt;font-family:'휴먼명조';line-height:160%'>&nbsp;</SPAN></P>";
	 contentsStr += "	</TD>";
	 contentsStr += "</TR>";
	 contentsStr += "</TABLE>";
	 return contentsStr;
 }
 
 /**
  * 거래처
  */
 function getErpTrade(tr_cd, tr_nm){
 	var obj = {};
 	obj.CO_CD = $("#erpCoCd").val();
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
 }

	function makeContentsStrSave(contentsStr){
		var saveObj = {purcContInspId : $("#purcContInspId").val(), contentsStr : contentsStr};
		var opt = {
	    		url : _g_contextPath_ + "/Ac/G20/Ex/updatePurcContInspContent.do",
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
	
</script>
<form id="outProcessFormData" action="http://211.192.144.104/gw/outProcessLogOn.do"></form>
<!-- <form id="formData" action="/gw/outProcessLogOn.do" target="outProcessLogOn"></form> -->
<input type="hidden" id="compSeq" value="${loginVO.compSeq }"/>
<input type="hidden" id="empSeq" value="${loginVO.uniqId }"/>
<input type="hidden" id="loginId" value="${loginVO.id }"/>
<input type="hidden" id="erpCoCd" value="${loginVO.erpCoCd }"/>
<div class="pop_sign_wrap" style="width:1200px;">
    <div class="pop_sign_head">
        <h1><span class="title_NM">계약검수</span></h1>
		<div class="psh_btnbox">
			<div class="psh_right">
				<div class="btn_cen mt8">
					<input type="button" class="psh_btn" id="btnApproval" value="검사/검수 기안" />
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
					<input type="hidden" id=purcContInspId value="${params.purcContInspId }"/>
				</dd>
<!-- 				<dt class="ar" style="width: 100px">구매의뢰번호</dt> -->
<!-- 				<dd> -->
<!-- 					<input type="text" id="txtPurcReqNo" class="" readonly="readonly" disabled="disabled" style="width: 170px;"/> -->
<!-- 				</dd> -->
				<dt class="ar" style="width: 70px">계약명</dt>
				<dd>
					<input type="text" id="txtContTitle" class="" readonly="readonly" disabled="disabled" style="width: 250px;"/>
				</dd>
			</dl>
		</div>
		<div id="purcContInsp">
			<div  class="com_ta2 hover_no mt10">
				<table>
					<colgroup>
						<col width="90"/>
						<col width="230"/>
						<col width="80"/>
						<col width="130"/>
						<col width="80"/>
						<col width=""/>
						<col width="80"/>
					</colgroup>
					<tbody>
						<tr>
							<th>검수차수</th>
							<td class="le" colspan="1">
								<input type="text" id="inspOrder" value="" readonly="readonly" disabled="disabled" style="width: 20%;"/>
							</td>
							<th>검수일</th>
							<td class="le">
								<input type="text"id="inspDate" style="width: 90%;"/>
							</td>
							<th>비고</th>
							<td class="le" colspan="2">
								<input type="text"id="remark" style="width: 90%;"/>
							</td>
						</tr>
						<tr>
							<th>납품기한</th>
							<td class="le" colspan="1">
								<input type="text" id="deliveryFrDate" readonly="readonly" disabled="disabled" style="width: 43%;"/> ~ 
								<input type="text" id="deliveryToDate" readonly="readonly" disabled="disabled" style="width: 43%;"/>
							</td>
							<th>납품일</th>
							<td class="le">
								<input type="text"id="deliveryDate" style="width: 90%;"/>
							</td>
							<th>계약상대자</th>
							<td class="le" colspan="2">
								<input type="text"id="trNm" readonly="readonly" disabled="disabled" style="width: 90%;"/>
							</td>
						</tr>
						<tr style="display: none;">
							<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> 검수장소</th>
							<td class="le" colspan="3">
								<input type="text" id="inspPlace" style="width: 90%;"/>
							</td>
						</tr>
						<tr>
							<th>필수첨부파일</th>
							<td class="" colspan="3">준공계 or 납품서 or 완료계</td>
							<td class="le" id="fileArea" colspan="2"></td>
							<td class="">
								<input type="button" onclick="fnFileOpen()" 	value="업로드" class="file_input_button ml4 normal_btn2" /> 
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
				</form>
			</div>
			<div class="com_ta2 hover_no" style="display: none;">
		    	<table style="border-top: 0px;">
					<colgroup>
						<col width="80"/>
						<col width=""/>
						<col width="90"/>
						<col width=""/>
						<col width="90"/>
						<col width=""/>
						<col width="90"/>
					</colgroup>
					<tr  id="trOpRow1">
						<th rowspan="2">검수의견</th>
						<td class="le op1" id="" colspan="1">
							<span>수량은 일치 하는가?</span>
						</td>
						<td style="border-left: 0px;" class="op1">
							<input type="text" id="inspOpinion1" class="inspOpinion1" style="width: 80px;">
						</td>
						<td class="le op2" id="" colspan="1">
							<span class="optxt2">계약규격과 외형은 일치 하는가?</span>
						</td>
						<td style="border-left: 0px;" class="op2">
							<input type="text" id="inspOpinion2" class="inspOpinion2" style="width: 80px;">
						</td>
						<td class="le op3" id="" colspan="1">
							<span>특허 등 특수기능은 있는가?</span>
						</td>
						<td style="border-left: 0px;" class="op3">
							<input type="text" id="inspOpinion3" class="inspOpinion3" style="width: 80px;">
						</td>
					</tr>
					<tr  id="trOpRow2">
						<td class="le op4" id="" colspan="1" style="border-left: solid #dcdcdc 1px;">
							<span>구성품은 부착되어있는가?</span>
						</td>
						<td style="border-left: 0px;" class="op4">
							<input type="text" id="inspOpinion4" class="inspOpinion4" style="width: 80px;">
						</td>
						<td class="le op5" id="" colspan="1">
							<span>검수결과</span>
						</td>
						<td style="border-left: 0px;" class="op5">
							<input type="text" id="inspOpinion5" class="inspOpinion5" style="width: 80px;">
						</td>
						<td class="le" id="" colspan="2">
						</td>
					</tr>
				</table>
			</div>
		</div>
		
		<div class="com_ta2 mt10">
			<table  id="purcContInspT1">
				<thead>
					<tr>
						<th rowspan="2" style="border-right: solid #eaeaea 1px;" id="thContNm">용역명</th>
						<th rowspan="2" style="border-right: solid #eaeaea 1px;" id="thContContents">용역내용</th>
						<th colspan="3">계약내용</th>
						<th colspan="3">검수내용</th>
					</tr>
					<tr>
						<th>금액</th>
						<th>공급가액</th>
						<th>부가세</th>
						<th>금액</th>
						<th>공급가액</th>
						<th>부가세</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
			<table id="purcContInspT1-tablesample" style="display:none">
			    <tr class="">
			    	<td>
			    		<input type="text" class="contItemNm" id="" style="width: 90%;" disabled="disabled">
			    	</td>
			    	<td>
			    		<input type="text" class="contContents" id="" style="width: 90%;" disabled="disabled">
			    	</td>
			    	<td>
			    		<input type="text" class="contUnitAm ri" id="" style="width: 80%;" disabled="disabled">
			    	</td>
			    	<td>
			    		<input type="text" class="contSupAm ri" id="" style="width: 80%;" disabled="disabled">
			    	</td>
			    	<td>
			    		<input type="text" class="contVatAm ri" id="" style="width: 80%;" disabled="disabled">
			    	</td>
			    	<td>
			    		<input type="text" class="unitAm ri" id="" style="width: 80%;" />
			    	</td>
			    	<td>
			    		<input type="text" class="supAm ri" id="" style="width: 80%;" disabled="disabled">
			    	</td>
			    	<td>
			    		<input type="text" class="vatAm ri" id="" style="width: 80%;" disabled="disabled">
			    	</td>
			    </tr>
			</table>
		</div>
		
		<div class="com_ta2 mt10">
			<table  id="purcContInspT2">
				<thead>
					<tr>
						<th rowspan="2">품목구분</th>
						<th rowspan="2" style="border-right: solid #eaeaea 1px;">품명</th>
						<th colspan="7" class="colspanTh">계약내용</th>
						<th colspan="7" class="colspanTh">검수내용</th>
					</tr>
					<tr>
						<th>수량</th>
						<th>규격</th>
						<th>단가</th>
						<th>금액</th>
						<th>공급가액</th>
						<th>부가세</th>
						<th class="opHidden">조달수수료</th>
						<th>수량</th>
						<th>규격</th>
						<th>단가</th>
						<th>금액</th>
						<th>공급가액</th>
						<th>부가세</th>
						<th class="opHidden">조달수수료</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
			<table id="purcContInspT2-tablesample" style="display:none">
			    <tr class="">
			    	<td>
			    		<input type="text" class="contItemType" id="" style="width: 90%;" disabled="disabled">
			    	</td>
			    	<td>
			    		<input type="text" class="contItemNm" id="" style="width: 90%;" disabled="disabled">
			    	</td>
			    	<td>
			    		<input type="text" class="contItemCnt" id="" style="width: 90%;" disabled="disabled">
			    	</td>
			    	<td>
			    		<input type="text" class="contStandard" id="" style="width: 90%;" disabled="disabled">
			    	</td>
			    	<td>
			    		<input type="text" class="contItemAm ri" id="" style="width: 80%;" disabled="disabled">
			    	</td>
			    	<td>
			    		<input type="text" class="contUnitAm ri" id="" style="width: 80%;" disabled="disabled">
			    	</td>
			    	<td>
			    		<input type="text" class="contSupAm ri" id="" style="width: 80%;" disabled="disabled">
			    	</td>
			    	<td>
			    		<input type="text" class="contVatAm ri" id="" style="width: 80%;" disabled="disabled">
			    	</td>
			    	<td class="opHidden">
			    		<input type="text" class="contPpsFees ri" id="" style="width: 80%;" disabled="disabled">
			    	</td>
			    	<td>
			    		<input type="text" class="itemCnt" id="" style="width: 90%;">
			    	</td>
			    	<td>
			    		<input type="text" class="standard" id="" style="width: 90%;">
			    	</td>
			    	<td>
			    		<input type="text" class="itemAm ri" id="" style="width: 80%;" disabled="disabled">
			    	</td>
			    	<td>
			    		<input type="text" class="unitAm ri" id="" style="width: 80%;" disabled="disabled">
			    	</td>
			    	<td>
			    		<input type="text" class="supAm ri" id="" style="width: 80%;" disabled="disabled">
			    	</td>
			    	<td>
			    		<input type="text" class="vatAm ri" id="" style="width: 80%;" disabled="disabled">
			    	</td>
			    	<td class="opHidden">
			    		<input type="text" class="ppsFees ri" id="" style="width: 80%;" disabled="disabled">
			    	</td>
			    </tr>
			</table>
		</div>
    </div><!-- //pop_con -->
</div>
