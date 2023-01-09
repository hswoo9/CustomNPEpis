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
<script type="text/javascript" src='<c:url value="/js/ac/g20/purcReqForm.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/ac/g20/purcReqFormSmall.js"></c:url>'></script>
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
	var template_key = "${params.form_id}" || "";
	var c_dikeycode = "${params.diKeyCode}" || "";
	var mode = "${params.mode}" || "0";
	var abdocu_no = "${params.abdocu_no}" || "0";
	var purcReqId = "${params.purcReqId}" || "0";
	var purcReqHId = "${params.purcReqHId}" || "0";
	var purcReqType = "${params.purcReqType}" || "0";
	var processId = "${params.form_tp}" || "";
	var eaType = "${params.eaType}" || "";
	
	var abdocu_no_reffer = "${params.abdocu_no_reffer}" || "";
	var focus = "${params.focus}" || "";
	var requestUrl = "${params.requestUrl}" || "";
	var docu_mode = "0";
	var consDocSeq = "${params.consDocSeq}" || "0";
	
$(function(){
  	
    //품의/결의일자 컨트롤 초기화
    abdocu.setDatepicker("txtGisuDate");
    $(".controll_btn button").kendoButton();

    /*결재작성*/
	$("#btnApprovalOpen").click(function(){
		abdocu.approvalOpen();
	});
	
	fnTpfComboBoxInit('PURC_CONT_PAY_CON', 'payCon', $('#purcReqInfo'));
	fnTpfComboBoxInit('PURC_CONT_PAY_TYPE', 'payType', $('#purcReqInfo'));
	fnTpfComboBoxInit('PURC_CONT_TYPE', 'contType', $('#purcReqInfo'));
	$("#contType").data("kendoComboBox").value("004");
	$("#contType").data("kendoComboBox").readonly(true);
	abdocu.setDatepicker('contDate');
	
	$('#payType').bind({
		change : function(){
			fnPayTypeChange();
		}
	})
	$('#payCnt').bind({
		keyup : function(){
			$(this).val($(this).val().toMoney2());
		}
	})
	
	if(purcReqType == "3" || purcReqType == "4"){
		$('#purcReqTitle').bind({
			change : function(){
				$("#txt_ITEM_NM").val($(this).val());
				$(".txt_ITEM_NM").val($(this).val());
			}
		})
		$('#purcPurpose').bind({
			change : function(){
				$("#contents").val($(this).val());
				$(".contents").val($(this).val());
			}
		})
    }

	abdocu.init();
	
	/*행 변경 함수지정*/
	acUtil.focusNextRow = abdocu.focusNextRow;
	
    /*구매의뢰 초기화*/
    purcReq.init();
    
   	fnPurcReqInfo();
    
	$("#btnReset").click(function(){
		
		if(!confirm('<%=BizboxAMessage.getMessage("TX000019433","초기화 하시겠습니까?")%>')) return false;
		var abdocu_no = "0";
		var obj = acUtil.util.getParamObj();
		obj["abdocu_no"] = 0;
		obj["purcReqId"] = 0;
		obj["purcReqHId"] = 0;
		obj["template_key"] = template_key;
		obj["consDocSeq"] = 0;
		fnReLoad(obj);
	});
	
	if(!ncCom_Empty(c_dikeycode)){
		$("#btnReset").hide();
	}
	
	if(purcReqType == '2'){
		var td = $("#purc-trade-td");
		td.attr("colspan",3).attr("disabled", true);
		$("a", td).remove();
		$("#txt_TR_NM_cont").unbind();
		$('#purcTrTh').show().after(td);
		$('.purcReqType2hide').hide();
	}else{
		$('.purcReqType2show').hide();
// 		$('.purcReqType2hide').show();
	}
	
	fnPayTypeChange();
	fnResizeForm();
	setTimeout(function(){$(".pop_sign_wrap").height($("body").height());}, 100);
	//$('.title_NM').html($('#purcReqType').val().replace('의뢰서','계약보고'));
	
	$("#contDate").val(moment().format("YYYY-MM-DD"));
	
	targetType = 'purcReqId';
	targetSeq = purcReqId;
	resAlphaG20Util.init();
	
	$.ajax({
		type : 'POST',
		async: false,
		url : _g_contextPath_  + '/Ac/G20/Ex/selectFormInfo.do',
		data: {purcReqType : processId},
		dataType : 'json',
		success : function(data) {
			$('.title_NM').html(data.result.c_tiname);
			$('#purcReqType').val(data.result.c_tiname);
		}
	});
});

function fnPayTypeChange(){
	var payType = $('#payType').val();
	if(payType == "002"){
		$("span.payType").css("width", "100px");
		$(".payCnt").show();
	}else{
		$("span.payType").css("width", "95%");
		$("#payCnt").val("1");
		$(".payCnt").hide();
	}
}

/**
 * 예산영역 생성
 */
function fnBudgetTableSet(){

    if(erpOption.BizGovUseYn !="1"){
    	ctlBudgetHide(6);
    }

	if(abdocuInfo.docu_mode == 0){
		ctlBudgetHide(2);
		ctlBudgetHide(4);
	}
	
	if(purcReqType == "1" || purcReqType == "2"){
		ctlBudgetHide(10);
	}
	ctlBudgetHide(10);
	ctlBudgetHide(7);

}

</script>
<!-- <form id="formData" action="/gw/outProcessLogOn.do" target="outProcessLogOn"></form> -->
<form id="outProcessFormData" action="http://211.192.144.104/gw/outProcessLogOn.do" target="outProcessLogOn"></form>
<input type="hidden" id="compSeq" value="${loginVO.compSeq }"/>
<input type="hidden" id="empSeq" value="${loginVO.uniqId }"/>
<input type="hidden" id="loginId" value="${loginVO.id }"/>
<div class="pop_sign_wrap" style="width:999px;">
    <div class="pop_sign_head">
        <h1><span class="title_NM"><%=BizboxAMessage.getMessage("TX000002958","결의서")%> </span> <%=BizboxAMessage.getMessage("TX000006808","작성")%></h1>
		<div class="psh_btnbox">
			<!-- 양식팝업 오른쪽 버튼그룹
			<div class="psh_left"></div>
			 -->
			<!-- 양식팝업 오른쪽 버튼그룹 -->
			<div class="psh_right">
				<div class="btn_cen mt8">
				    <input type="button" class="psh_btn" id="btnReset" value="<%=BizboxAMessage.getMessage("TX000002960","초기화")%>" />
					<input type="button" class="psh_btn" id="btnApprovalOpen" value="<%=BizboxAMessage.getMessage("TX000003154","결재작성")%>" />
				</div>
			</div>
		</div>        
    </div>
    <div class="pop_sign_con scroll_on" style="padding:62px 16px 20px 16px;">  
        <div class="h2_btn3 mt20">
            <p class="tit_p mt20" id="coInfo"></p>
        </div> 

        <div class="top_box mt10" style="overflow:hidden;" id="erpUserInfo">
        <div id="erpUserInfo-table">
            <dl class="dl2">
                <dt><%=BizboxAMessage.getMessage("TX000006717","의뢰부서/작성자")%></dt>
                <dd><input type="text"  style="width:150px;" id="txtDEPT_NM" readonly="readonly" disabled="disabled"  class="requirement" tabindex="102" />
                    <input type="text"  style="width:80px;" id="txtKOR_NM" readonly="readonly"  disabled="disabled" class="requirement">
                    <%-- <input type="button" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" class="search-Event-H"/> --%><!-- 구매의뢰서에서 주석처리 -->
                </dd>
            </dl>
            <dl class="dl2">
                <dt><%=BizboxAMessage.getMessage("TX000004251","의뢰일자")%></dt>
                <dd><input style="width:119px;" id="txtGisuDate" class="non-requirement" tabindex="103"  part="user" disabled="disabled"/></dd><!-- 구매의뢰서에서 수정불가 -->
            </dl>
            
        </div>           
        <input type="hidden" id="erpGisu"/>
        <input type="hidden" id="erpGisuFromDt"/>
        <input type="hidden" id="erpGisuToDt"/>          
        </div>        
        <div class="btn_div" id="djOnnara">
		</div>
		<div id="purcReqInfo">
			<div  class="com_ta2 hover_no mt10">
				<table>
					<colgroup>
						<col width="100"/>
						<col width=""/>
						<col width="100"/>
						<col width=""/>
						<col width="100"/>
						<col width="190"/>
						<col width="100"/>
						<col width=""/>
					</colgroup>
					<tbody>
						<tr>
							<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> 계약명</th>
							<td colspan="3" class="le">
								<input type="text" id="purcReqTitle" style="width:97%"/>
							</td>
							<th class="purcReqType2show" id="purcTrTh">거래처</th>
							<td class="le purcReqType2hide" style="display: none;">
								<input type="text" id="payCon" class="payCon" style="width: 100px;"/>
							</td>
							<td class="le purcReqType2hide" style="display: none;">
								<input type="text" id="payType" class="payType" style="width: 95%;"/>
								<input type="text" id="payCnt" style="width: 30px;" value="1" class="payCnt"/><span class="payCnt"> 회</span>
							</td>
							<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> 사업기간</th>
							<td colspan="3" class="le">
								<span>(계약일로 부터</span>
								<input type="text" id="purcReqDate"/>
								<input type="text" id="term" style="width: 50px;"/>
								<span>일 까지)</span>
							</td>
						</tr>
						<tr>
							<th>목적</th>
							<td colspan="3" class="le">
								<input type="text" id="purcPurpose" style="width:97%"/>
							</td>
							<th class="purcReqType2hide" style="display: none;">계약방법</th>
							<td class="le purcReqType2hide" colspan="1" style="display: none;">
								<input type="text" id="contType" class="contType" style="width: 100px;"/>
							</td>
							<td class="purcReqType2show" colspan="2" style="border-left-width: 0px;"></td>
							<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> 거래처</th>
							<td id="purc-trade-td" class="le">
								<input type="text" style="width:70%" id="txt_TR_NM"  class="txt_TR_NM non-requirement" tabindex="20001" readonly="readonly"/> 
								<input type="hidden" class="non-requirement txt_TR_FG" id="txt_TR_FG" />                                                                  
								<input type="hidden" class="non-requirement txt_TR_FG_NM" id="txt_TR_FG_NM"/>                                                                  
								<input type="hidden" class="non-requirement txt_ATTR_NM" id="txt_ATTR_NM"/>                                                                  
								<input type="hidden" class="non-requirement txt_PPL_NB" id="txt_PPL_NB"/>                                                                  
								<input type="hidden" class="non-requirement txt_ADDR" id="txt_ADDR"/>                                                                  
								<input type="hidden" class="non-requirement txt_TRCHARGE_EMP" id="txt_TRCHARGE_EMP" />                                                                  
								<input type="hidden" class="non-requirement txt_JIRO_CD" id="txt_JIRO_CD"  />                                                                                        
								<input type="hidden" class="non-requirement txt_JIRO_NM" id="txt_JIRO_NM"  />
								<input type="hidden" class="non-requirement txt_NDEP_AM" id="txt_NDEP_AM"/>                                                                                               
								<input type="hidden" class="non-requirement txt_INAD_AM" id="txt_INAD_AM"/>                                                                                               
								<input type="hidden" class="non-requirement txt_INTX_AM" id="txt_INTX_AM"/>                                                                                               
								<input type="hidden" class="non-requirement txt_RSTX_AM" id="txt_RSTX_AM"/>                                                                                               
								<input type="hidden" class="non-requirement txt_WD_AM" id="txt_WD_AM" />
								<input type="hidden" class="non-requirement txt_ETCRVRS_YM" id="txt_ETCRVRS_YM" />
								<input type="hidden" class="non-requirement txt_ETCDUMMY1" id="txt_ETCDUMMY1" />                                                                                               
								<input type="hidden" class="non-requirement txt_DATA_CD" id="txt_DATA_CD"  />                                                                                               
								<input type="hidden" class="non-requirement txt_ET_YN" id="txt_ET_YN"/> 
								<input type="hidden" class="non-requirement txt_CTR_NM" id="txt_CTR_NM" />
								<input type="hidden" class="non-requirement txt_CTR_CD" id="txt_CTR_CD" />
								<input type="hidden" class="non-requirement txt_CTR_CARD_NUM" id="txt_CTR_CARD_NUM" />
								<input type="hidden" class="non-requirement txt_BA_NB_H" id="txt_BA_NB_H" />
								<input type="hidden" class="non-requirement txt_DEPOSITOR_H" id="txt_DEPOSITOR_H" />
								<input type="hidden" class="non-requirement txt_BTR_NM_H" id="txt_BTR_NM_H" />
								<input type="hidden" class="non-requirement txt_BTR_CD_H" id="txt_BTR_CD_H" />
								<a href="javascript:;" class="search-Event-T"><img src="<c:url value='/Images/ico/ico_explain.png' />" alt="검색" title="검색" /></a>
							</td>
							<th style="display: none;">사업자번호</th>
							<td class="le" style="display: none;">
								<input type="text" id="txt_REG_NB" value="" style="width: 90%;" disabled="disabled"/>
							</td>
							<th style="display: none;">대표자</th>
							<td class="le" style="display: none;">
								<input type="text" id="txt_CEO_NM" value="" style="width: 90%;" disabled="disabled"/>
							</td>
							<th>계약금액</th>
							<td class="le">
								<input type="text" id="contAm" class="ri" style="width:83%" disabled="disabled"/>
							</td>
						</tr>
						<tr style="display: none;">
							<th>기초금액</th>
							<td>
								<input type="text" id="basicAm" class="ri"/>
							</td>
							
							<th style="display: none;">계약예정일</th>
							<td class="le" colspan="3" style="display: none;">
								<input type="text" id="contDate"/>
							</td>
							<th>낙찰률</th>
							<td>
								<input type="text" id="rate" disabled="disabled"/>
							</td>
						</tr>
						<tr class="hidden">
							<th>구분</th>
							<td class="le">
								<input type="text" id="purcReqType" value="물품구매의뢰서" readonly="readonly" disabled="disabled" code="1" style="width: 50%;"/>
								<input type="hidden" id="selectDocu" value="구매품의서" code="1"/>
								<input type="hidden" id="purcReqId"/>
							</td>
<!-- 							<th>구매의뢰번호</th> -->
<!-- 							<td class="le"> -->
<!-- 								<input type="text" readonly="readonly" disabled="disabled" style="width: 60%;" id="purcReqNo"/> -->
<!-- 							</td> -->
						</tr>
					</tbody>
				</table>
			</div>
		</div>
		<div class="com_ta2 hover_no">
	    	<table style="border-top: 0px;">
				<colgroup>
					<col width="100"/>
					<col width="351"/>
					<col width=""/>
					<col width="80"/>
				</colgroup>
				<tr  id="attach1">
					<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> 필수첨부파일</th>
					<td>견적서</td>
					<td class="le" id="fileArea1"></td>
					<td>
						<input type="button" onclick="fnFileOpen(1)" 	value="업로드" class="file_input_button ml4 normal_btn2" />					
					</td>
				</tr>
			</table>
	    </div>
	    <div class="com_ta2 hover_no">
	    	<table style="border-top: 0px;">
				<colgroup>
					<col width="100"/>
					<col width="351"/>
					<col width=""/>
					<col width="80"/>
				</colgroup>
				<tr  id="">
					<th>기타첨부파일</th>
					<td>기타첨부파일</td>
					<td class="le" id="fileArea0"></td>
					<td class="">
						<input type="button" onclick="fnFileOpen(0)" 	value="업로드" class="file_input_button ml4 normal_btn2" /> 
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
			</table>
			<form id="fileForm" method="post" enctype="multipart/form-data">
				<input type="file" id="attachFile" name="file_name" value="" class="hidden" />
				<input type="hidden" id="fileType" name="fileType" value="" class="hidden" />
			</form>
		</div>
		<div class="com_ta2 mt10">
			<table  id="">
				<thead>
                    <tr>
                        <th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000009913","예산회계단위")%></th>
                        <th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" />
                        <!-- 곽경훈 수정
                        프로젝트 -> 사업 --> 
                        <spna id="PjtTypeText">사업</spna></th>
                        <%-- <spna id="PjtTypeText"><%=BizboxAMessage.getMessage("TX000000519","프로젝트")%></spna></th> --%>
                        <th style="display: none;" class="BottomTd"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000005362","하위사업")%></th>
                        <th style="display: none;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000000604","적요")%></th>
                        <!-- <th width="147"></th> -->
                        <th width="117"></th>
                    </tr>
                </thead>
			</table>
		</div>
		
        <div class="com_ta2 ova_sc cursor_p" id="erpProjectInfo" style="overflow-y:scroll; height:75px;">
            <table border="0" id="erpProjectInfo-table">
                <tbody>
                </tbody>
                <tfoot>
                	<tr id="pjtTrLast">
                    	<td>
							<div class="controll_btn al p0"><button class="erpappend" type="button" id="addRowHBtn">추가</button></div>
                    	</td>
                    	<td class="BottomTd"></td>
                    	<td></td>
                    	<td></td>
                    </tr>
                </tfoot>
            </table>        
            <table>
				<tr id="erpProjectInfo-trsample" style="display: none;">            
	                <td>
	                	<a href="#n" class="search-Event-H"><img src="<c:url value='/Images/ico/ico_explain.png'/>" alt="" /></a>
	                 <input type="text"  style="width:85%;" id="txtDIV_NM" name="txtDIV_NM" readonly="readonly" class="requirement txtDIV_NM" tabindex="201"/>
	            	</td>
	                <td><a href="#n" class="search-Event-H"><img src="<c:url value='/Images/ico/ico_explain.png'/>" alt="" /></a> 
	                    <input type="text" style="width:85%;" id="txt_ProjectName" name="txt_ProjectName" readonly="readonly" class="requirement txt_ProjectName" tabindex="202" part="project"/>
	                    <input type="hidden" id="txt_IT_BUSINESSLINK" name="txt_IT_BUSINESSLINK"/>
	                    <input type="hidden" id="txt_BankTrade" class="non-requirement txt_BankTrade" name="txt_BankTrade"/>
                        <input type="hidden" id="txt_BankTrade_NB" class="non-requirement txt_BankTrade_NB" name="txt_BankTrade_NB"/>
	                </td>
	                <td style="display: none;" class="BottomTd">
	                    <a href="#n" class="search-Event-H"><img src="<c:url value='/Images/ico/ico_explain.png'/>" alt="" /></a> 
	                    <input type="text" style="width:85%;" id="txtBottom_cd" name="txtBottom_cd" tabindex="203" readonly="readonly" class="requirement txtBottom_cd" part="project"/>
	                </td>
	                <td style="display: none;">
	                    <input type="text" style="width:87%;" id="txt_Memo" name="txt_Memo" CODE="empty"/>
	                </td>
	                <td width="100">
	                	<div class="controll_btn ac p0">
                        	<button type="button" class="btndeleteRow"><%=BizboxAMessage.getMessage("TX000000424","삭제")%></button>
                   		</div>
	                </td>
            	</tr>
            </table>


		<input type="hidden" id="txt_GisuDt" class="non-requirement" /> 
		</div>
        <div id="budgetInfo">  		        		
	        <div class="com_ta2 hover_no mt10">
	            <table>
	                <tbody>
	                    <tr>
	                        <th><%=BizboxAMessage.getMessage("TX000003625","관")%></th>
	                        <td id="td_veiw_BGT01_NM"></td>
	                        <th><%=BizboxAMessage.getMessage("TX000003626","항")%></th>
	                        <td id="td_veiw_BGT02_NM"></td>
	                        <th class="en_w140" ><%=BizboxAMessage.getMessage("TX000003627","목")%></th>
	                        <td id="td_veiw_BGT03_NM"></td>
	                        <th><%=BizboxAMessage.getMessage("TX000003628","세")%></th>
	                        <td id="td_veiw_BGT04_NM"></td>
	                    </tr>
	                </tbody>
	            </table>
	        </div>  
	        
	        <div class="com_ta2 hover_no mt5">
	            <table id="budgetInfoAm">
	                <tbody>
	                    <tr>
	                        <th><%=BizboxAMessage.getMessage("TX000003618","예산액")%></th>
	                        <td id="td_veiw_OPEN_AM" style="color: blue; font-weight: bold;"></td>                    
	                        <th><%=BizboxAMessage.getMessage("TX000011177","배정액")%></th>
	                        <td id="td_veiw_ACCEPT_AM" style="color: blue; font-weight: bold;"></td>
	                        <th><%=BizboxAMessage.getMessage("TX000005056","집행액")%></th>
	                        <td id="td_veiw_APPLY_AM" style="color: blue; font-weight: bold;"></td>
	                        <th class="en_w140" ><%=BizboxAMessage.getMessage("TX000009911","요청액")%></th>
	                        <td id="td_veiw_REFER_AM" style="color: blue; font-weight: bold;"></td>
	                        <th><%=BizboxAMessage.getMessage("TX000004247","예산잔액")%></th>
	                        <td id="td_veiw_LEFT_AM" style="color: blue; font-weight: bold;"></td>
	                    </tr>
	                </tbody>
	            </table>
	        </div>  
        </div>
        
		<div class="com_ta2 mt10">
			<table  id="erpBudgetInfo">
				<thead>
					<tr>
						<th width="270"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000003622","예산과목")%></th>
						<th width="80"><%=BizboxAMessage.getMessage("TX000011180","결제수단")%></th>
						<th width="80"><%=BizboxAMessage.getMessage("TX000003635","과세구분")%></th>
						<th width=""><%=BizboxAMessage.getMessage("TX000004257","채주유형")%></th>
						<th width="170" style="display: none;"><%=BizboxAMessage.getMessage("TX000005318","예산사업장")%></th>
						<th width=""><%=BizboxAMessage.getMessage("TX000009910","문광부사용방법")%></th>
						<th width="100">환원가능여부</th>
						<th width=""><%=BizboxAMessage.getMessage("TX000000644","비고")%></th>
						<th width="130"><%=BizboxAMessage.getMessage("TX000000552","금액")%></th>
						<th width="130">내년예산</th>
						<th width="147"></th>
					</tr>
				</thead>
			</table>
		</div>
		
		<div class="com_ta2 ova_sc cursor_p" style="overflow-y:scroll; height:75px;">
			<table id="erpBudgetInfo-table">
				<tbody>
                </tbody>
			</table>
        </div>  
        
        <table id="erpBudgetInfo-tablesample" style="display:none">
		    <tr class="">         
		        <td width="270" id="budget-td">
		            <a href="#n" class="search-Event-B"><img src="<c:url value='/Images/ico/ico_explain.png' />" alt="" /></a> 
		            <input type="text" style="width:40%;" id="txt_BGTNM_REF" class="non-requirement" readonly="readonly" />
		            <input type="text" style="width:40%;" id="txt_BUDGET_LIST"  class="requirement" tabindex="10001" readonly="readonly" />
		            <input type="hidden" class="non-requirement" id="BGT01_NM"  />
		            <input type="hidden" class="non-requirement" id="BGT02_NM" />
		            <input type="hidden" class="non-requirement" id="BGT03_NM" />
		            <input type="hidden" class="non-requirement" id="BGT04_NM" />
		            <input type="hidden" class="non-requirement" id="ACCT_AM"  />
		            <input type="hidden" class="non-requirement" id="DELAY_AM"  />
		            <input type="hidden" class="non-requirement" id="APPLY_AM"  />
		            <input type="hidden" class="non-requirement" id="LEFT_AM"  />
		            <input type="hidden" class="non-requirement" id="CTL_FG"  />
		            <input type="hidden" class="non-requirement" id="LEVEL01_NM"  />
		            <input type="hidden" class="non-requirement" id="LEVEL02_NM" />
		            <input type="hidden" class="non-requirement" id="LEVEL03_NM" />
		            <input type="hidden" class="non-requirement" id="LEVEL04_NM" />
		            <input type="hidden" class="non-requirement" id="LEVEL05_NM" />
		            <input type="hidden" class="non-requirement" id="LEVEL06_NM" />
		            <input type="hidden" class="non-requirement" id="IT_SBGTCDLINK"/>
		        </td>
		        <td width="80"><input style="width:95%;" id="selectSet_Fg"   tabindex="10002" class="non-requirement"/><input type="hidden" class="non-requirement"  id="tempSet_Fg"  value="1"/></td>
		        <td width="80"><input style="width:95%;" id="selectVat_Fg"   tabindex="10003" class="non-requirement"/><input type="hidden" class="non-requirement" id="tempVat_Fg"  value="3"/></td>
		        <td width=""><input style="width:95%;" id="selectTr_Fg"   tabindex="10004" class="non-requirement"/><input type="hidden" class="non-requirement" id="tempTr_Fg"  value="1"/></td>
		        <td width="170" style="display: none;"><a href="#n" class="search-Event-B"><img src="<c:url value='/Images/ico/ico_explain.png' />" alt="" /></a> 
		            <input type="text" style="width:78%;" id="txt_BUDGET_DIV_NM"  class="requirement" tabindex="10005" readonly="readonly" />
		        </td>
		        <td width=""><select style="width:65px;" id="selectIT_USE_WAY"  tabindex="10007" class="non-requirement">
		            <option value="01"><%=BizboxAMessage.getMessage("TX000009432","계좌이체")%></option>
                    <option value="02"><%=BizboxAMessage.getMessage("TX000004704","현금")%></option>
                    <option value="03"><%=BizboxAMessage.getMessage("TX000003254","법인카드")%></option>
                    <option value=""></option>
                    </select>
		        </td>
		        <td width="100">
		        	<input type="checkbox" id="returnYn" class="non-requirement" checked="checked"/>
		        </td>
		        <td width=""><input type="text" style="width:82%;" id="RMK_DC" CODE="empty" tabindex="10006" class="non-requirement" part="budget"/></td>
		        <td width="130"><span id="totalAM" class="totalAM"></span></td>
		        <td width="130"><span id="nextAm" class="nextAm"></span></td>
		        <td width="130">
                    <div class="controll_btn ac p0">
                        <button type="button" class="erpsave" ><%=BizboxAMessage.getMessage("TX000001256","저장")%></button>
                        <button type="button" class="btndeleteRow"><%=BizboxAMessage.getMessage("TX000000424","삭제")%></button>
                    </div>
		        </td>
		    </tr>
		</table>
		
		
		<table id="erpBudgetInfo-tablesample-empty" style="display:none">
		    <tr class="blank">
		        <td width="270"></td>
		        <td width="80"></td>
		        <td width="80"></td>
		        <td width=""></td>
		        <td width="170" style="display: none;"></td>
		        <td width=""></td>
		        <td width="100"></td>
		        <td width=""></td>
		        <td width="130"></td>
		        <td width="130"></td>
		        <td width="130"></td>
		    </tr>
		</table>
		<!-- 버튼 -->
		<div class="btn_div mt10 mb0 cl">
			<div class="left_div">
				<div class="controll_btn p0 com_ta2 hover_no">
					<table id="tableTab">
						<tr>
							<td class="tdTab" id="001">공사</td>
							<td class="tdTab" id="002">물품</td>
						</tr>
					</table>
				</div>
			</div>
			<div class="right_div mb10">
				<div class="controll_btn p0">
		            <button type="button" id="excelDownBtn" onclick=";">Excel 양식 Down</button>
		            <button type="button" id="excelUploadBtn" onclick=";">Excel Upload</button>
				</div>
			</div>
		</div>
        <div class="com_ta2 scroll_on" >
			<table style="width:966px;" id="erpTradeInfo">
				<thead>
					<tr>
					    <th width="150" id="thTradeTrNm"><%=BizboxAMessage.getMessage("TX000000313","거래처명")%></th>    <!-- 1, 2 , 3(사원명), 4(기타소득자)-->
			            <th width="80"><%=BizboxAMessage.getMessage("TX000000026","대표자명")%></th>   <!-- 2 -->
			            <th width="100"><%=BizboxAMessage.getMessage("TX000003619","금융기관")%></th>    <!-- 2, 3, 4 -->
			            <th width="120"><%=BizboxAMessage.getMessage("TX000003620","계좌번호")%></th>    <!-- 2, 3, 4 -->
			            <th width="80"><%=BizboxAMessage.getMessage("TX000003621","예금주")%></th>    <!-- 2, 3, 4 -->                                                                                                       
			            <th width="120"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> 조달청물품식별번호</th>      <!-- 1 -->                                                                                                     
			            <th width="120">거래처</th>      <!-- 1 -->                                                                                                     
			            <th width="120">사업자번호</th>      <!-- 1 -->                                                                                                     
			            <th width="120">대표자명</th>      <!-- 1 -->                                                                                                     
			            <th width="100">품목구분</th>      <!-- 1 -->                                                                                                     
			            <th width="100"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <sapn id="thItemNm"><%=BizboxAMessage.getMessage("TX000005413","품명")%></sapn></th>      <!-- 1 -->                                                                                                     
			            <th width="80"><%=BizboxAMessage.getMessage("TX000004231","수량")%></th>      <!-- 1 -->
			            <th width="100">규격</th>      <!-- 1 -->                                                                                                                                    
			            <th width="100" id="thContents">공사내용</th>      <!-- 1 -->                                                                                                                                    
			            <th width="110" id="thStratDate">공사시작일</th>      <!-- 1 -->                                                                                                                                    
			            <th width="110" id="thEndDate">공사종료일</th>      <!-- 1 -->                                                                                                                                    
			            <th width="100"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000000468","단가")%></th>      <!-- 1 -->                                                                                                          
			            <th width="100" id="thTradeTrNm"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000000552","금액")%></th>      <!-- 1, 2, 3 , 4(지급총액)-->                                                                                                          
			            <th width="100" id="thTradeTrNm"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000000516","공급가액")%></th>    <!-- 1, 2, 3 , 4(실수령액)-->                                                                                                            
			            <th width="100" id="thTradeTrNm"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000004701","부가세")%></th>     <!-- 1, 2, 3, 4(원천징수액) --> 
			            <th width="100"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> 조달수수료</th>      <!-- 1 -->
			            <th width="100">내년예산</th>      <!-- 1 -->
			            <th width="130"><%=BizboxAMessage.getMessage("TX000000644","비고")%></th>     <!--  1, 2, 3 , 4   -->                                                                                                        
			            <th width="130"></th> 		  <!-- 1, 2, 3 , 4-->				
					</tr>
				</thead>
				<tbody id="erpTradeInfo-table">
				</tbody>
			</table>
        </div>  
    
		<table id="erpTradeInfo-tablesample" style="display:none">
		    <tr class="">
		        <td width="150" id="trade-td">
				    <a href="javascript:;" class="search-Event-T"><img src="<c:url value='/Images/ico/ico_explain.png' />" alt="검색" title="검색" /></a>                                      
					<input type="text" style="width:70%" id="txt_TR_NM"  class="non-requirement" tabindex="20001"/> 
					<input type="hidden" class="non-requirement" id="txt_TR_FG" />                                                                  
					<input type="hidden" class="non-requirement" id="txt_TR_FG_NM"/>                                                                  
					<input type="hidden" class="non-requirement" id="txt_ATTR_NM"/>                                                                  
					<input type="hidden" class="non-requirement" id="txt_PPL_NB"/>                                                                  
					<input type="hidden" class="non-requirement" id="txt_ADDR"/>                                                                  
					<input type="hidden" class="non-requirement" id="txt_TRCHARGE_EMP" />                                                                  
					<input type="hidden" class="non-requirement" id="txt_JIRO_CD"  />                                                                                        
					<input type="hidden" class="non-requirement" id="txt_JIRO_NM"  />
					<input type="hidden" class="non-requirement" id="txt_REG_NB"/>                        		
					<input type="hidden" class="non-requirement" id="txt_NDEP_AM"/>                                                                                               
					<input type="hidden" class="non-requirement" id="txt_INAD_AM"/>                                                                                               
					<input type="hidden" class="non-requirement" id="txt_INTX_AM"/>                                                                                               
					<input type="hidden" class="non-requirement" id="txt_RSTX_AM"/>                                                                                               
					<input type="hidden" class="non-requirement" id="txt_WD_AM" />
					<input type="hidden" class="non-requirement" id="txt_ETCRVRS_YM" />                                                                                               
					<input type="hidden" class="non-requirement" id="txt_ETCDUMMY1" />                                                                                               
					<input type="hidden" class="non-requirement" id="txt_DATA_CD"  />                                                                                               
					<input type="hidden" class="non-requirement" id="txt_ET_YN"/> 
					<input type="hidden" class="non-requirement" id="txt_CTR_NM" />
					<input type="hidden" class="non-requirement" id="txt_CTR_CD" />
					<input type="hidden" class="non-requirement" id="txt_CTR_CARD_NUM" />
					<input type="hidden" class="non-requirement" id="txt_BA_NB_H" />
					<input type="hidden" class="non-requirement" id="txt_DEPOSITOR_H" />
					<input type="hidden" class="non-requirement" id="txt_BTR_NM_H" />
					<input type="hidden" class="non-requirement" id="txt_BTR_CD_H" />
				</td>
				<td width="80"><input type="text" style="width:93%;" id="txt_CEO_NM"  class="non-requirement" tabindex="20002" /></td>
				<td width="100"><a href="javascript:;" class="search-Event-T"><img src="<c:url value='/Images/ico/ico_explain.png' />" alt="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" title="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" /></a> 
				    <input type="text" style="width:73%;" id="txt_BTR_NM"  class="non-requirement" tabindex="20005" />
				</td>                                                     
				<td width="120"><input type="text" style="width:93%;" id="txt_BA_NB"  class="non-requirement" tabindex="20006" /></td>                                                      
				<td width="80"><input type="text" style="width:93%;" id="txt_DEPOSITOR"  class="non-requirement" tabindex="20007" /></td> 
				
				<td width="120"><input type="text" style="width:93%;" id="ppsIdNo"  class="requirement" tabindex="20002" code="0"/></td>
				<td width="120"><input type="text" style="width:93%;" id="trNm"  class="non-requirement" tabindex="20002" code="0"/></td>
				<td width="120"><input type="text" style="width:93%;" id="regNb"  class="non-requirement" tabindex="20002" code="0"/></td>
				<td width="120"><input type="text" style="width:93%;" id="ceoNm"  class="non-requirement" tabindex="20002" code="0"/></td>
				
				<td width="100"><input type="text" style="width:93%;" id="itemType"  class="non-requirement" tabindex="20002" /></td>
				<td width="100"><input type="text" id="txt_ITEM_NM"  style="width:85%;padding-right:7px;" class="ri requirement" CODE="empty" tabindex="20002" /></td>
				<td width="80"><input type="text" id="txt_ITEM_CNT"  style="width:85%;padding-right:7px;" class="ri non-requirement" tabindex="20003" /></td>                                                                           
				<td width="100"><input type="text" style="width:93%;" id="standard"  class="non-requirement" tabindex="20002" /></td>
				<td width="100"><input type="text" style="width:93%;" id="contents"  class="non-requirement" tabindex="20002" /></td>
				<td width="110"><input type="text" style="width:93%;" id="startDate"  class="non-requirement" tabindex="20002" /></td>
				<td width="110"><input type="text" style="width:93%;" id="endDate"  class="non-requirement" tabindex="20002" /></td>
				<td width="100"><input type="text" id="txt_ITEM_AM" code="empty" style="width:85%;padding-right:7px;" class="ri requirement" tabindex="20004" /></td>                                                                           
				<td width="100"><input type="text" id="txt_UNIT_AM"  style="width:85%;padding-right:7px;" class="ri requirement" CODE="empty" tabindex="20002" /></td>
				<td width="100"><input type="text" id="txt_SUP_AM"  style="width:85%;padding-right:7px;" class="ri non-requirement" tabindex="20003" /></td>                                                                           
				<td width="100"><input type="text" id="txt_VAT_AM" code="empty" style="width:85%;padding-right:7px;" class="ri requirement" tabindex="20004" /></td>                                                                           
				<td width="100"><input type="text" style="width:85%;" id="ppsFees"  class="ri requirement" tabindex="20002" code="0" readonly="readonly"/></td>
				<td width="100"><input type="text" style="width:85%;" id="nextAm"  class="ri non-requirement" tabindex="20002" code="0"/></td>
				<td width="130"><input type="text" style="width:93%;" id="txt_RMK_DC"  class="non-requirement" tabindex="20008" part="trade"/></td>
				<td width="130">
				    <div class="controll_btn ac p0">                         
					    <button type="button" class="erpsave"><%=BizboxAMessage.getMessage("TX000001256","저장")%></button>                         
						<button type="button" class="btndeleteRow"><%=BizboxAMessage.getMessage("TX000000424","삭제")%></button>                         
					</div>                        		
				</td>
			</tr>
		</table>
		
		<table id="erpTradeInfo-tablesample-empty" style="display:none">
		    <tr class="blank">
		        <td width="150"></td>
		        <td width="80"></td>
		        <td width="100"></td>
		        <td width="120"></td>
		        <td width="80"></td>
		        <td width="120"></td>
		        <td width="120"></td>
		        <td width="120"></td>
		        <td width="120"></td>
		        <td width="100"></td>
		        <td width="100"></td>
		        <td width="80"></td>
		        <td width="100"></td>
		        <td width="100"></td>
		        <td width="110"></td>
		        <td width="110"></td>
		        <td width="100"></td>
		        <td width="100"></td>
		        <td width="100"></td>
		        <td width="100"></td>
		        <td width="100"></td>
		        <td width="100"></td>
		        <td width="130"></td>
		        <td width="130"></td>
		    </tr>
		</table>    
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
        <div class="com_ta2 mt10 ova_sc_all cursor_p"  style="height:340px;" id="dialog-form-standard-bind">
        </div>
        

    </div><!-- //pop_con -->
</div><!-- //pop_wrap -->
</div>

<div id="excelUploadPop" style="position: absolute; top: 300px; left: 230px; width: 540px; display: none;">
	<form class="pop_wrap_dir" id="excelUploadForm" name="excelUploadForm" enctype="multipart/form-data" method="post" action= "<c:url value="/Ac/G20/Ex/excelUploadSave.do"/>">
		<div class="pop_head">
			<h1>업로드</h1>
		</div>
		<div class="pop_con">
			<p class="mb10">
				<span class="text_red">10MB</span>이하의 파일만 등록 할 수 있습니다. 
				<span class="text_red"></span>엑셀 파일만 업로드 가능합니다.
			</p>
			<div class="com_ta">
				<table>
					<colgroup>
						<col width="120" />
						<col width="" />
					</colgroup>
					<tr>
						<th>파일첨부</th>
						<td class="le">
							<div class="clear">
								<input type="text" id="excelFileName" class="file_input_textbox clear" readonly="readonly" style="width: 280px;" />
								<div class="file_input_div">
									<input type="button" onclick="purcReq.excelUploadOpen();" value="업로드" class="file_input_button ml4 normal_btn2">
									<input type="file" id="excelFile" name="fileNm" class="hidden" onchange="purcReq.excelFileChange(this);" />
								</div>
							</div>
							<input type="hidden" name="abdocu_no" value="" />
							<input type="hidden" name="abdocu_b_no" value="" />
						</td>
					</tr>
				</table>
			</div>
		</div>
		<!-- //pop_con -->
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" id="uploadSave" value="저장" /> 
				<input type="button" class="gray_btn" id="uploadCancle" value="취소" />
			</div>
		</div>
	</form>
</div>
</form>

<div id="dialog-form-background" class="modal" style="display:none;">
<div id="window" style="display: none;"></div>
<div id="recvDetail"  style="z-index:800000; display:none;background-color: #FFFFFF;position:absolute;  top:120px; margin-left:100px;" ></div>