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
<script type="text/javascript" src='<c:url value="/js/ac/g20/purcReqView.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/ac/g20/purcReqCode.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/ac/g20/purcReqMakeTable.js"></c:url>'></script>
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
	var type = '${params.type}' || '';
	var evalName = '기술협상';
	var purcReqId = '${params.purcReqId}';
	var evalType = '140';
	
$(function(){
	fnBiddingInit();
	fnBiddingEventHandler();
	resAlphaG20Util.init();
	if(type === 'view'){
		$('.notView').hide();
		$('#defaultInputBox').off();
	}else if(type === 'app'){
		$('.notView').hide();
		$('#btnApprovalOpen2').show();
		$('#btnReturnPop').show();
	}
});

function fnBiddingInit(){
	$('input').not('#btnApprovalOpen, #btnApprovalOpen2, #btnReturn, #btnReturnPop, #biddingInfo input, #returnReason').prop('disabled', true);
	$('.title_NM').html(evalName);
	$('#evalName').html(evalName);
	targetType = 'purcReqBiddingNegoId';
	targetSeq = purcReqId;
	var data = {purc_req_id: purcReqId, targetTableName: 'purc_req_bidding_nego', targetId: purcReqId};
	$.ajax({
		type : 'POST',
		async: false,
		url : _g_contextPath_  + '/Ac/G20/Ex/selectPurcReqBiddingNego.do',
		data:data,
		dataType : 'json',
		success : function(data) {
			fnBiddingAttachFileInit('0', data.attachFileList);
		}
	});
	
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
	
	var params = {};
	params.purcReqId = purcReqId;
	params.purcReqType;
    var opt = {
    		url     : _g_contextPath_ + "/Ac/G20/Ex/getPurcReq.do",
            async   : false,
            data    : params,
            successFn : function(data){
            	if(data.purcReqInfo.evalType){
	            	evalType = data.purcReqInfo.evalType;
            	}
            }
    };
    acUtil.ajax.call(opt);
}

function fnBiddingAttachFileInit(fileType, attachFileList){
	$.each(attachFileList, function(){
		var span = $('#fileSample div').clone();
		$('.file_name', span).html(this.real_file_name + '.' + this.file_extension);
		$('.attachFileId', span).val(this.attach_file_id);
		$('.fileSeq', span).val(this.file_seq);
		$('.filePath', span).val(this.file_path);
		$('.fileNm', span).val(this.real_file_name + '.' + this.file_extension);
		$('#fileArea' + fileType).append(span);
	});
}

function fnBiddingEventHandler(){
	$('#btnApprovalOpen').on({
		click: function(){
			fnApproval();
		}
	});
	$('#btnApprovalOpen2').on({
		click: function(){
			fnApproval2();
		}
	});
	$('#btnReturnPop').on({
		click: function(){
			fnReturnPop();
		}
	});
	$('#btnReturn').on({
		click: function(){
			fnReturn();
		}
	});
	$('#attachFile').on({
		change : function(){
			fnAttachFileUpload($(this));
		}
	})
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
function fnAttachFileUpload(obj){
	var targetId = purcReqId;
	var targetTableName = 'purc_req_bidding_nego';
	var fileType = $('#fileType').val();
	if(fileType == '0'){
	}
	var path = 'purc_req_bidding_nego';
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
			fnAttachFileUpload($(this));
		}
	})
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
	var fileType = $('#fileType').val();
	if(fileType != '0'){
		
	}
	span.remove();
}

function fnApproval(){
	var returnVal = true;
	
	if(!returnVal){
		return;
	}
	if(!confirm(evalName + '을 등록합니다.')){
		return;
	}
	var data = {};
	data.purcReqId = purcReqId;
	data.type = type;
	data.reqState = '161';
	
    var opt = {
    		url     : _g_contextPath_ + "/Ac/G20/Ex/updatePurcBiddingState.do",
            async   : false,
            data    : data,
            successFn : function(data){
            	saveOnnaraMapping();
    			window.close();
            }
    };
    acUtil.ajax.call(opt);
}

function fnApproval2(){
	var returnVal = true;
	
	if(!returnVal){
		return;
	}
	if(!confirm(evalName + '을 접수합니다.')){
		return;
	}
	var data = {};
	data.purcReqId = purcReqId;
	data.type = type;
	data.reqState = '004';
	if(evalType === '150'){
		data.reqState = '170';
	}
	
    var opt = {
    		url     : _g_contextPath_ + "/Ac/G20/Ex/updatePurcBiddingState.do",
            async   : false,
            data    : data,
            successFn : function(data){
            	saveOnnaraMapping();
    			window.close();
            }
    };
    acUtil.ajax.call(opt);
}

function fnReturnPop(){
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
	if(!confirm(evalName + '을 반려합니다.')){
		return;
	}
	var data = {};
	data.purcReqId = purcReqId;
	data.type = type;
	data.reqState = '162';
	data.returnReason = $('#returnReason').val();
	
    var opt = {
    		url     : _g_contextPath_ + "/Ac/G20/Ex/updatePurcBiddingState.do",
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
<!-- <form id="formData" action="/gw/outProcessLogOn.do" target="outProcessLogOn"></form> -->
<div class="pop_sign_wrap" style="width:999px;">
	<input type="hidden" id="compSeq" value="${loginVO.compSeq }">
	<input type="hidden" id="erpCoCd" value="${loginVO.erpCoCd }">
	<input type="hidden" id="empSeq" value="${loginVO.uniqId }">
	<input type="hidden" id="deptSeq" value="${loginVO.orgnztId }">
    <div class="pop_sign_head">
        <h1><span class="title_NM"><%=BizboxAMessage.getMessage("TX000002958","결의서")%> </span></h1>
		<div class="psh_btnbox">
			<div class="psh_left">
			</div>
			<div class="psh_right">
				<div class="btn_cen mt8">
					<input type="button" class="psh_btn notView" id="btnApprovalOpen" value="등록" />
					<input type="button" class="psh_btn" id="btnApprovalOpen2" value="접수" style="display: none;"/>
					<input type="button" class="psh_btn" id="btnReturnPop" value="반려" style="display: none;"/>
				</div>
			</div>
		</div>        
    </div>
    <div class="pop_sign_con scroll_on" style="padding:62px 16px 20px 16px;">  
    	<div id="djOnnara"></div>
        <div id="biddingInfo">
        	<div class="com_ta2 hover_no">
        		<table>
        			<colgroup>
        				<col width="100"/>
        				<col width=""/>
        				<col width="110"/>
        				<col width="70" class="notView"/>
       				</colgroup>
       				<tbody>
						<tr>
							<th>첨부파일</th>
       						<td colspan="2" style="text-align: left;padding-left: 5px;" id="fileArea0">
       						</td>
       						<td class="notView">
       							<input type="button" onclick="fnFileOpen(0)" value="추가" class="ml4 normal_btn2" />
       						</td>
						</tr>
						<tr id="fileSample" style="display: none;">
							<td></td>
							<td>
								<div class="mr20" style="">
									<span>
										<span>
										<img alt="" src="<c:url value='/Images/ico/ico_clip02.png' />">&nbsp;
										<a class="file_name" id="" style="color: rgb(0, 51, 255); line-height: 23px; cursor: pointer;" onclick="fnTpfAttachFileDownload(this);" href="#n"></a>&nbsp;
										<a onclick="fnTpfAttachFileDelete(this);" href="#n" class="notView">
											<img alt="" src="<c:url value='/Images/btn/btn_del_reply.gif' />">
										</a>
										<input class="attachFileId" type="hidden" value="">
										<input class="fileSeq" type="hidden" value="">
										<input class="filePath" type="hidden" value="">
										<input class="fileNm" type="hidden" value="">
										</span>
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
    </div><!-- //pop_con -->
</div>

<div id="returnDiv" style="text-align: center;padding: 10px;">
	<input type="text" id="returnReason" style="width: 95%;"/>
	<br/>
	<br/>
	<input type="button" id="btnReturn" value="반려"/>
</div>
