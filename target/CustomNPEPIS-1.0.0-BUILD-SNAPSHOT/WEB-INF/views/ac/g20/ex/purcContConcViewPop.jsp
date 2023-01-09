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
<script type="text/javascript" src='<c:url value="/js/ac/g20/purcContForm.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/ac/g20/purcReqCode.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/ac/g20/purcReqMakeTable.js"></c:url>'></script>
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
	var template_key = "${params.form_id}" || "";
	var c_dikeycode = "${params.diKeyCode}" || "";
	var mode = "${params.mode}" || "0";
	var abdocu_no = "${params.abdocu_no}" || "0";
	
	var purcReqId = "${params.purcReqId}" || "0";
	var purcReqHId = "${params.purcReqHId}" || "0";
	var purcReqType = "${params.purcReqType}" || "0";
	var processId = "${params.form_tp}" || "";
	var eaType = "${params.eaType}" || "";
	
	var purcContId = "${params.purcContId}" || "0";
	
	var abdocu_no_reffer = "${params.abdocu_no_reffer}" || "";
	var focus = "${params.focus}" || "";
	var requestUrl = "${params.requestUrl}" || "";
	var docu_mode = "";
	
$(function(){
	$('input').not($('#purcContInfo2 input')).prop('disabled', true);
    //품의/결의일자 컨트롤 초기화
    abdocu.setDatepicker("txtGisuDate");
    $(".controll_btn button").kendoButton();

	abdocu.init();
	
	/*행 변경 함수지정*/
	acUtil.focusNextRow = abdocu.focusNextRow;
	
    /*구매의뢰 초기화*/
    purcReq.init();
    
   	fnPurcReqInfo();
   	
   	if(purcReqType == '2'){
// 		var td = $("#cont-trade-td");
// 		td.attr("colspan",5).attr("disabled", true);
// 		$('.purcReqType2show').show().after(td);
// 		$('.purcReqType2hide').hide();
	}else{
// 		$('.purcReqType2show').hide();
// 		$('.purcReqType2hide').show();
	}
   	
   	if($("#payType").attr("code") != "002"){
   		$(".payCnt").hide();
   		$("#payType").css("width", "90%");
   	}

	fnResizeForm();
	setTimeout(function(){$(".pop_sign_wrap").height($("body").height());}, 100);
	$('#btnConc').prop('disabled', false);
	$('.title_NM').html($('#purcReqType').val().replace('의뢰서','계약'));
	ctlBudgetHide(12);
	ctlBudgetHide(10);
});

</script>
<!-- <form id="formData" action="/gw/outProcessLogOn.do" target="outProcessLogOn"></form> -->
<form id="outProcessFormData" action="http://211.192.144.104/gw/outProcessLogOn.do" ></form>
<input type="hidden" id="compSeq" value="${loginVO.compSeq }"/>
<input type="hidden" id="empSeq" value="${loginVO.uniqId }"/>
<input type="hidden" id="loginId" value="${loginVO.id }"/>
<div class="pop_sign_wrap" style="width:999px;">
    <div class="pop_sign_head">
        <h1><span class="title_NM"><%=BizboxAMessage.getMessage("TX000002958","결의서")%> </span></h1>
		<div class="psh_btnbox">
			<!-- 양식팝업 오른쪽 버튼그룹
			<div class="psh_left"></div>
			 -->
			<!-- 양식팝업 오른쪽 버튼그룹 -->
			<div class="psh_right">
				<!-- <div class="btn_cen mt8">
					<input type="button" class="psh_btn" id="btnConc" value="계약체결" />
				</div> -->
			</div>
		</div>        
    </div>
    <div class="pop_sign_con scroll_on" style="padding:62px 16px 20px 16px;">  

        <div class="top_box mt10" style="overflow:hidden; display: none;" id="erpUserInfo">
        <div id="erpUserInfo-table">
            <dl class="dl2">
                <dt><%=BizboxAMessage.getMessage("TX000006717","의뢰부서/작성자")%></dt>
                <dd><input type="text"  style="width:150px;" id="txtDEPT_NM" readonly="readonly" disabled="disabled"  class="requirement" tabindex="102" />
                    <input type="text"  style="width:80px;" id="txtKOR_NM" readonly="readonly"  disabled="disabled" class="requirement">
                </dd>                                                    
            </dl>
            <dl class="dl2">
                <dt><%=BizboxAMessage.getMessage("TX000004251","의뢰일자")%></dt>
                <dd><input style="width:119px;" type="text" id="txtGisuDate" class="non-requirement" tabindex="103"  part="user" /></dd>
            </dl>
            
        </div>           
        <input type="hidden" id="erpGisu"/>
        <input type="hidden" id="erpGisuFromDt"/>
        <input type="hidden" id="erpGisuToDt"/>          
        </div>        
        <div class="h2_btn3 mt10">
            <p class="tit_p mt10" id="">구매의뢰</p>
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
						<col width=""/>
						<col width="100"/>
						<col width=""/>
					</colgroup>
					<tbody>
						<tr>
							<th>구분</th>
							<td class="le" colspan="3">
								<input type="text" id="purcReqType" value="물품구매의뢰서" readonly="readonly" disabled="disabled" code="1" style="width: 97%;"/>
								<input type="hidden" id="selectDocu" value="구매품의서" code="1"/>
							</td>
<!-- 							<th>구매의뢰번호</th> -->
<!-- 							<td class="le"> -->
<!-- 								<input type="text" readonly="readonly" disabled="disabled" style="width: 90%;" id="purcReqNo"/> -->
<!-- 								<input type="hidden" id="purcReqId"/> -->
<!-- 							</td> -->
							<th>의뢰자</th>
							<td class="le">
								<input type="text" id="requester" value="" readonly="readonly" disabled="disabled" style="width: 90%;"/>
							</td>
							<th>의뢰일자</th>
							<td class="le">
								<input type="text" readonly="readonly" disabled="disabled" style="width: 90%;" id="regDate"/>
							</td>
						</tr>
						<tr>
							<th>제목</th>
							<td class="le" colspan="3">
								<input type="text" id="purcReqTitle" style="width:97%"/>
							</td>
							<th>사업기간</th>
							<td class="le" colspan="3">
								<span>(계약일로 부터</span>
								<input type="text" id="purcReqDate"/>
								<input type="text" id="term" style="width: 50px;"/>
								<span>일)</span>
							</td>
						</tr>
						<tr>
							<th>목적</th>
							<td class="le" colspan="3">
								<input type="text" id="purcPurpose" style="width:97%"/>
							</td>
							<th>거래처</th>
							<td id="purc-trade-td" class="le" colspan="3">
								<input type="text" style="width:70%" id="txt_TR_NM"  class="txt_TR_NM non-requirement" tabindex="20001"/> 
								<input type="hidden" class="non-requirement txt_CEO_NM" id="txt_CEO_NM" />                                                                  
								<input type="hidden" class="non-requirement txt_TR_FG" id="txt_TR_FG" />                                                                  
								<input type="hidden" class="non-requirement txt_TR_FG_NM" id="txt_TR_FG_NM"/>                                                                  
								<input type="hidden" class="non-requirement txt_ATTR_NM" id="txt_ATTR_NM"/>                                                                  
								<input type="hidden" class="non-requirement txt_PPL_NB" id="txt_PPL_NB"/>                                                                  
								<input type="hidden" class="non-requirement txt_ADDR" id="txt_ADDR"/>                                                                  
								<input type="hidden" class="non-requirement txt_TRCHARGE_EMP" id="txt_TRCHARGE_EMP" />                                                                  
								<input type="hidden" class="non-requirement txt_JIRO_CD" id="txt_JIRO_CD"  />                                                                                        
								<input type="hidden" class="non-requirement txt_JIRO_NM" id="txt_JIRO_NM"  />
								<input type="hidden" class="non-requirement txt_REG_NB" id="txt_REG_NB"/>                        		
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
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
		
		<div class="com_ta2 hover_no">
	    	<table style="border-top: 0px;">
				<colgroup>
					<col width="100"/>
					<col width=""/>
					<col width="80"/>
				</colgroup>
				<tr  id="">
					<th>첨부파일</th>
					<td class="le" id="fileArea0" colspan="2"></td>
				</tr>
				<tr id="fileSample" style="display: none;">
					<td></td>
					<td>
						<div class="mr20" style="">
							<span>
								<img alt="" src="<c:url value='/Images/ico/ico_clip02.png' />">&nbsp;
								<a class="file_name" id="" style="color: rgb(0, 51, 255); line-height: 23px; cursor: pointer;" onclick="fnTpfAttachFileDownload(this);" href="#n"></a>&nbsp;
								<input class="attachFileId" type="hidden" value="">
								<input class="fileSeq" type="hidden" value="">
								<input class="filePath" type="hidden" value="">
								<input class="fileNm" type="hidden" value="">
							</span>
						</div>
					</td>
				</tr>
			</table>
		</div>
		<div class="com_ta2 hover_no" style="display: none;">
	    	<table style="border-top: 0px;">
				<colgroup>
					<col width="100"/>
					<col width="80"/>
					<col width=""/>
					<col width="80"/>
					<col width="80"/>
					<col width=""/>
					<col width="80"/>
				</colgroup>
				<tr  id="attach1">
					<th rowspan="4">필수첨부파일</th>
					<td class="le">
						<span style="width: 60px;display: inline-block;">기본계획서</span>
					</td>
					<td class="le" id="fileArea1" colspan="2"></td>
					<c:choose>
						<c:when test="${params.purcReqType ne '2' }">
					<td class="le">
						<span style="width: 60px;display: inline-block;">견적서</span>
					</td>
					<td class="le" id="fileArea2" colspan="2"></td>
				</tr>
				<tr  id="attach2">
					<td class="le" style="border: solid #dcdcdc;border-width: 0 0 1px 1px;">
						<span style="width: 60px;display: inline-block;">구매사양서</span>
					</td>
					<td class="le" id="fileArea3" colspan="2"></td>
					<td colspan="3"></td>
				</tr>
						</c:when>
						<c:otherwise>
					<td class="le">
						<span style="width: 60px;display: inline-block;">구매사양서</span>
					</td>
					<td class="le" id="fileArea3" colspan="2"></td>
				</tr>
						</c:otherwise>
					</c:choose>
				<tr  id="attach3">
					<td class="le" style="border: solid #dcdcdc;border-width: 0 0 1px 1px;">
						<span style="width: 60px;display: inline-block;">시방서</span>
					</td>
					<td class="le" id="fileArea4" colspan="2"></td>
					<td class="le">
						<span style="width: 60px;display: inline-block;">도면</span>
					</td>
					<td class="le" id="fileArea5" colspan="2"></td>
				</tr>
				<tr  id="attach4">
					<td class="le" style="border: solid #dcdcdc;border-width: 0 0 1px 1px;">
						<span style="width: 60px;display: inline-block;">과업지시서</span>
					</td>
					<td class="le" id="fileArea6" colspan="2"></td>
					<td colspan="3"></td>
				</tr>
			</table>
	    </div>
	    
	    <div class="h2_btn3 mt10">
            <p class="tit_p mt10" id="">계약보고</p>
        </div> 
	    <div id="purcContInfo">
			<div  class="com_ta2 hover_no mt10">
				<table>
					<colgroup>
						<col width="100"/>
						<col width=""/>
						<col width="80"/>
						<col width=""/>
						<col width="80"/>
						<col width=""/>
						<col width="80"/>
						<col width=""/>
						<col width="80"/>
						<col width=""/>
					</colgroup>
					<tbody>
						<tr>
							<th>계약명</th>
							<td class="le" colspan="5">
								<input type="text" id="contTitle" style="width: 90%;"/>
							</td>
							<th>거래처</th>
							<td id="cont-trade-td" class="le" colspan="3">
								<input type="text" style="width:90%" id="txt_TR_NM_cont"  class="txt_TR_NM non-requirement" tabindex="20001"/>
								<input type="hidden" class="non-requirement txt_CEO_NM" id="txt_REG_NB_cont" />                                                                  
								<input type="hidden" class="non-requirement txt_CEO_NM" id="txt_CEO_NM_cont" />       
							</td>
							<th class="purcReqType2hide" style="display: none;">기초금액</th>
							<td class="le" style="display: none;">
								<input type="text" id="basicAm" class="ri" disabled="disabled" style="width: 80%;"/>
							</td>
							<th class="purcReqType2hide" style="display: none;">예정가격</th>
							<td class="le" style="display: none;">
								<input type="text" id="expectedAm" class="ri" disabled="disabled" style="width: 80%;"/>
							</td>
							<th class="purcReqType2hide" style="display: none;">낙찰률</th>
							<td class="le" style="display: none;">
								<input type="text" id="rate" class="ri" disabled="disabled" style="width: 80%;"/>
							</td>
							<td class="le purcReqType2hide" style="display: none;">
								<input type="text" id="contType" class="contType" style="width: 90%;"/>
								<input type="text" id="contTypeCode" class="contTypeCode" style="width: 90%;"/>
							</td>
							<td class="le purcReqType2hide" style="display: none;">
								<input type="text" id="payCon" class="payCon" style="width: 90%;"/>
							</td>
							<td class="le purcReqType2hide" style="display: none;">
								<input type="text" id="payType" class="payType" style="width: 45%;"/>
								<input type="text" id="payCnt" style="width: 20%;" class="payCnt"/><span class="payCnt"> 회</span>
							</td>
						</tr>
						<tr class="purcReqType2hide">
							<th>계약금액</th>
							<td class="le" colspan="3">
								<input type="text" id="contAm" class="ri" style="width:80%" disabled="disabled"/>
							</td>
							<th>사업기간</th>
							<td class="le" colspan="3">
								<span>(계약일로 부터</span>
								<input type="text" id="contEndDate" style="width: 40%;"/>
								<input type="text" id="contTerm" style="width: 15%;"/>
								<span>일)</span>
							</td>
							<th>계약예정일</th>
							<td class="le">
								<input type="text" id="contDate" style="width: 90%;"/>
							</td>
						</tr>
						<tr>
							<th>부 거래처</th>
							<td colspan="9" id="addTradeTd" class="le">
								<input type="hidden" id="txt_TR_NM_add" class="txt_TR_NM" />
								<span id="txt_TR_NM_add_span"></span>
							</td>
						</tr>
						<tr id="addTradeTdSample" style="display: none;">
							<td></td>
							<td>
								<span>
									<span class="trNmTxt"></span>
									<input class="trCd" type="hidden" value="">
									<input class="trNm" type="hidden" value="">
								</span>
							</td>
						</tr>
						<tr>
							<th>첨부파일</th>
							<td colspan="9" id="fileArea_cont" class="le">
							</td>
						</tr>
						<tr id="fileSample2" style="display: none;">
							<td></td>
							<td>
								<div class="mr20" style="">
									<span>
										<img alt="" src="<c:url value='/Images/ico/ico_clip02.png' />">&nbsp;
										<a class="file_name" id="" style="color: rgb(0, 51, 255); line-height: 23px; cursor: pointer;" onclick="fnTpfAttachFileDownload(this);" href="#n"></a>&nbsp;
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
			</div>
		</div>
		
		<div class="com_ta2 mt10" style="display: none;">
			<table  id="">
				<thead>
                    <tr>
                        <th><%=BizboxAMessage.getMessage("TX000009913","예산회계단위")%></th>
                        <th><spna id="PjtTypeText"><%=BizboxAMessage.getMessage("TX000000519","프로젝트")%></spna></th>
                        <th style="display: none;" class="BottomTd"><%=BizboxAMessage.getMessage("TX000005362","하위사업")%></th>
                        <th style="display: none;"><%=BizboxAMessage.getMessage("TX000000604","적요")%></th>
                        <!-- <th width="147"></th> -->
                        <th width="17"></th>
                    </tr>
                </thead>
			</table>
		</div>
		
        <div class="com_ta2 ova_sc cursor_p" id="erpProjectInfo" style="overflow-y:scroll; height:75px; display: none;">
            <table border="0" id="erpProjectInfo-table">
                <tbody>
                </tbody>
            </table>        
            <table>
				<tr id="erpProjectInfo-trsample" style="display: none;">            
	                <td>
						<input type="text"  style="width:85%;" id="txtDIV_NM" name="txtDIV_NM" readonly="readonly" class="requirement txtDIV_NM" tabindex="201"/>
	            	</td>
	                <td> 
	                    <input type="text" style="width:85%;" id="txt_ProjectName" name="txt_ProjectName" readonly="readonly" class="requirement txt_ProjectName" tabindex="202" part="project"/>
	                    <input type="hidden" id="txt_IT_BUSINESSLINK" name="txt_IT_BUSINESSLINK"/>
	                </td>
	                <td style="display: none;" class="BottomTd">
	                    <input type="text" style="width:85%;" id="txtBottom_cd" name="txtBottom_cd" tabindex="203" readonly="readonly" class="requirement txtBottom_cd" part="project"/>
	                </td>
	                <td style="display: none;">
	                    <input type="text" style="width:87%;" id="txt_Memo" name="txt_Memo" CODE="empty"/>
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
						<th width="150">예산회계단위</th>
						<th width="150">프로젝트</th>
						<th width="100" style="display: none;">하위사업</th>
						<th width="200"><%=BizboxAMessage.getMessage("TX000003622","예산과목")%></th>
						<th width="80"><%=BizboxAMessage.getMessage("TX000011180","결제수단")%></th>
						<th width="60"><%=BizboxAMessage.getMessage("TX000003635","과세구분")%></th>
						<th width=""><%=BizboxAMessage.getMessage("TX000004257","채주유형")%></th>
						<th width="170" style="display: none;"><%=BizboxAMessage.getMessage("TX000005318","예산사업장")%></th>
						<th width=""><%=BizboxAMessage.getMessage("TX000009910","문광부사용방법")%></th>
						<th width="80">환원가능여부</th>
						<th width="90"><%=BizboxAMessage.getMessage("TX000000552","금액")%></th>
						<th width="90">내년예산</th>
						<th width=""><%=BizboxAMessage.getMessage("TX000000644","비고")%></th>
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
		    	<td width="150">
		    		<!-- <span class="divNm" ></span> -->
		    		<input type="text" class="non-requirement" id="divNm" style="width: 90%;">
		    	</td>
		    	<td width="150">
		    		<!-- <span class="mgtNm" ></span> -->
		    		<input type="text" class="non-requirement" id="mgtNm" style="width: 90%;">
		    	</td>
		    	<td width="100" style="display: none;">
		    		<!-- <span class="bottomNm" ></span> -->
		    		<input type="text" class="non-requirement" id="bottomNm" style="width: 90%;">
		    	</td>
		        <td width="200" id="budget-td">
		            <input type="text" style="width:85%;" id="txt_BGTNMCD" class="non-requirement" readonly="readonly" />
		            <input type="text" style="width:45%;display: none;" id="txt_BGTNM_REF" class="non-requirement" readonly="readonly" />
		            <input type="text" style="width:45%;display: none;" id="txt_BUDGET_LIST"  class="requirement" tabindex="10001" readonly="readonly" />
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
		        <td width="60"><input style="width:95%;" id="selectVat_Fg"   tabindex="10003" class="non-requirement"/><input type="hidden" class="non-requirement" id="tempVat_Fg"  value="1"/></td>
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
		        <td width="80">
		        	<input type="checkbox" id="returnYn" class="non-requirement" checked="checked"/>
		        </td>
		        <td width="90"><span id="totalAM" class="totalAM"></span></td>
		        <td width="90"><span id="nextAm" class="nextAm"></span></td>
		        <td width=""><input type="text" style="width:82%;" id="RMK_DC" CODE="empty" tabindex="10006" class="non-requirement" part="budget"/></td>
		    </tr>
		</table>
		
		
		<table id="erpBudgetInfo-tablesample-empty" style="display:none">
		    <tr class="blank">
		        <td width="110"></td>
		        <td width="110"></td>
		        <td width="110"></td>
		        <td width="230"></td>
		        <td width="80"></td>
		        <td width="80"></td>
		        <td width=""></td>
		        <td width="170" style="display: none;"></td>
		        <td width=""></td>
		        <td width="100"></td>
		        <td width="130"></td>
		        <td width=""></td>
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
				<div class="controll_btn p0 com_ta2 hover_no">
					<span class="cl fr hidden" id="referConfer"></span>
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
			            <th width="120">조달청물품식별번호</th>      <!-- 1 -->                                                                                                     
			            <th width="120">거래처</th>      <!-- 1 -->                                                                                                     
			            <th width="120">사업자번호</th>      <!-- 1 -->                                                                                                     
			            <th width="120">대표자명</th>      <!-- 1 -->         
			            <th width="100">품목구분</th>      <!-- 1 -->                                                                                                     
			            <th width="100" id="thItemNm"><%=BizboxAMessage.getMessage("TX000005413","품명")%></th>      <!-- 1 -->                                                                                                     
			            <th width="80"><%=BizboxAMessage.getMessage("TX000004231","수량")%></th>      <!-- 1 -->
			            <th width="100">규격</th>      <!-- 1 -->                                                                                                                                    
			            <th width="100" id="thContents">공사내용</th>      <!-- 1 -->                                                                                                                                    
			            <th width="110" id="thStratDate">공사시작일</th>      <!-- 1 -->                                                                                                                                    
			            <th width="110" id="thEndDate">공사종료일</th>      <!-- 1 -->                                                                                                                                    
			            <th width="80"><%=BizboxAMessage.getMessage("TX000000468","단가")%></th>      <!-- 1 -->                                                                                                          
			            <th width="100" id="thTradeTrNm"><%=BizboxAMessage.getMessage("TX000000552","금액")%></th>      <!-- 1, 2, 3 , 4(지급총액)-->                                                                                                          
			            <th width="100" id="thTradeTrNm"><%=BizboxAMessage.getMessage("TX000000516","공급가액")%></th>    <!-- 1, 2, 3 , 4(실수령액)-->                                                                                                            
			            <th width="100" id="thTradeTrNm"><%=BizboxAMessage.getMessage("TX000004701","부가세")%></th>     <!-- 1, 2, 3, 4(원천징수액) --> 
			            <th width="100">조달수수료</th>      <!-- 1 -->
			            <th width="100">내년예산</th>      <!-- 1 -->
			            <th width="130"><%=BizboxAMessage.getMessage("TX000000644","비고")%></th>     <!--  1, 2, 3 , 4   -->                                                                                                        
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
				<td width="100"><input type="text" style="width:85%;" id="ppsFees"  class="ri requirement" tabindex="20002" code="0"/></td>
				<td width="100"><input type="text" style="width:85%;" id="nextAm"  class="ri non-requirement" tabindex="20002" code="0"/></td>
				<td width="130"><input type="text" style="width:93%;" id="txt_RMK_DC"  class="non-requirement" tabindex="20008" part="trade"/></td>
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
		        <td width="130"></td>
		    </tr>
		</table>    
		<div id="purcContInfo2" class="purcReqType2hide" style="display: none;">
			<div  class="com_ta2 hover_no mt10">
				<table>
					<colgroup>
						<col width="100"/>
						<col width="150"/>
						<col width="100"/>
						<col width=""/>
						<col width="100"/>
					</colgroup>
					<tbody>
						<tr>
							<th>계약일</th>
							<td class="le">
								<input type="text" id="contDate2" style="width: 100px;" disabled="disabled"/>
							</td>
							<th>계약기간</th>
							<td class="le" colspan="2">
								<input type="text" id="contStartDate2" style="width: 100px;" disabled="disabled"/> ~
								<input type="text" id="contEndDate2" style="width: 100px;" disabled="disabled"/>
							</td>
						</tr>
						<tr>
							<th>표준계약서</th>
							<td id="fileArea_cont2" class="le" colspan="4">
							</td>
						</tr>
						<tr>
							<th>첨부파일</th>
							<td id="fileArea_cont3" class="le" colspan="4">
							</td>
						</tr>
						<tr id="fileSample3" style="display: none;">
							<td></td>
							<td>
								<div class="mr20" style="">
									<span>
										<img alt="" src="<c:url value='/Images/ico/ico_clip02.png' />">&nbsp;
										<a class="file_name" id="" style="color: rgb(0, 51, 255); line-height: 23px; cursor: pointer;" onclick="fnTpfAttachFileDownload(this);" href="#n"></a>&nbsp;
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

<div id="dialog-form-background" class="modal" style="display:none;">
<div id="window" style="display: none;"></div>
<div id="recvDetail"  style="z-index:800000; display:none;background-color: #FFFFFF;position:absolute;  top:120px; margin-left:100px;" ></div>
