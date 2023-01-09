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
<script type="text/javascript" src='<c:url value="/js/resalphag20/resAlphaG20Util.js"></c:url>'></script>

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
	
	$("#purcContInspT1, #purcContInspT2").hide();
	resAlphaG20Util.init();
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
	params.inspState = "003";
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
    targetType = 'PURCINSP';
	targetSeq = $("#purcContInspId").val();
	saveOnnaraMapping();
}

function purcContInspApproval(){
	if(!($('#fileArea span').length > 0 || onnaraDocs.length > 0)){
		alert('첨부파일이나 온나라연동문서 중 하나는 필수로 등록해야합니다.')
		return false;
	}
	if(confirm('검수를 진행합니다.')){
		updatePurcContInsp();
		window.close();
	}
}

</script>
<form id="outProcessFormData" action="http://211.192.144.104/gw/outProcessLogOn.do"></form>
<!-- <form id="formData" action="/gw/outProcessLogOn.do" target="outProcessLogOn"></form> -->
<input type="hidden" id="compSeq" value="${loginVO.compSeq }"/>
<input type="hidden" id="empSeq" value="${loginVO.uniqId }"/>
<input type="hidden" id="loginId" value="${loginVO.id }"/>
<input type="hidden" id="erpCoCd" value="${loginVO.erpCoCd }"/>
<div class="pop_sign_wrap" style="width:600px;">
    <div class="pop_sign_head">
        <h1><span class="title_NM">계약검수</span></h1>
		<div class="psh_btnbox">
			<div class="psh_right">
				<div class="btn_cen mt8">
					<input type="button" class="psh_btn" id="btnApproval" value="검사/검수 저장" />
				</div>
			</div>
		</div>        
    </div>
    <div class="pop_sign_con scroll_on" style="padding:62px 16px 20px 16px;">  
        <div class="top_box mt10">
			<dl>
				<dt class="ar" style="width: 30px">구분</dt>
				<dd>
					<input type="text" id="txtPurcReqType" class="txtPurcReqType" readonly="readonly" disabled="disabled" style="width: 100px;"/>
					<input type="hidden" id=purcContInspId value="${params.purcContInspId }"/>
				</dd>
<!-- 				<dt class="ar" style="width: 70px">구매의뢰번호</dt> -->
<!-- 				<dd> -->
<!-- 					<input type="text" id="txtPurcReqNo" class="" readonly="readonly" disabled="disabled" style="width: 170px;"/> -->
<!-- 				</dd> -->
				<dt class="ar" style="width: 50px">계약명</dt>
				<dd>
					<input type="text" id="txtContTitle" class="" readonly="readonly" disabled="disabled" style="width: 150px;"/>
				</dd>
			</dl>
		</div>
		<div id="purcContInsp">
			<div  class="com_ta2 hover_no mt10">
				<table>
					<colgroup>
						<col width="100"/>
						<col width=""/>
						<col width="100"/>
						<col width=""/>
					</colgroup>
					<tbody>
						<tr>
							<th>검수요청일</th>
							<td class="le">
								<input type="text"id="deliveryDate" style="width: 90%;"/>
							</td>
							<th>검수완료일</th>
							<td class="le">
								<input type="text"id="inspDate" style="width: 90%;"/>
							</td>
						</tr>
						<tr>
							<th>계약상대자</th>
							<td class="le" colspan="3">
								<input type="text" id="trNm" readonly="readonly" disabled="disabled" style="width: 90%;"/>
							</td>
						</tr>
					</tbody>
				</table>
				<table style="border-top: 0px;">
					<colgroup>
						<col width="100"/>
						<col width="100"/>
						<col width=""/>
						<col width="70"/>
					</colgroup>
					<tbody>
						<tr>
							<th>첨부파일</th>
							<td colspan="2" class="le" id="fileArea"></td>
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
				<div id="djOnnara" style="height: 100px;"></div>
				<table style="display: none;">
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
						</tr>
						<tr style="display: none;">
							<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> 검수장소</th>
							<td class="le" colspan="3">
								<input type="text" id="inspPlace" style="width: 90%;"/>
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
