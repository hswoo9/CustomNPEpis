<%@page import="org.apache.xmlbeans.impl.xb.xsdschema.IncludeDocument.Include"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="main.web.BizboxAMessage"%>
<%
 /**
  * @Class Name : purcContPayPop.jsp
  * @Description : 대금지급
  * @Modification Information
  *
  */ 
%>


<script type="text/javascript" src='<c:url value="/js/ac/acUtil.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/ac/g20/purcContPay.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/ac/g20/acG20Code.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/ac/g20/acMakeTable.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/common/outProcessUtil.js"></c:url>'></script>


<style type="text/css">

.invalid { background-color : #ff6666;}
input:focus{background-color : #ccffff;}
.overBudget{background-color : #ff66dd;}
#project-td .search-Event-H, #budget-td .search-Event-B{display : none;}
#project-td #txt_ProjectName, .txt_BUDGET_LIST{disabled : disabled}

</style>

<script type="text/javascript">

	var template_key = "${params.template_key}" || "";
	var c_dikeycode = "${params.diKeyCode}" || "";
	var mode = "${params.mode}" || "1";
	var abdocu_no = "${params.abdocu_no}" || "0";
	var abdocu_no_reffer = "${params.abdocu_no_reffer}" || "";
	var focus = "${params.focus}" || "";
	var requestUrl = "${params.requestUrl}" || "";
	var docu_mode = "";
	var purcContId = "${params.purcContId}" || "";
	var purcContPayId = "${params.purcContPayId}" || "";
	
$(function(){
		    	
	topBoxInit();
	// 결의구분 
	var docuList = NeosCodeUtil.getCodeList("G20201");
	$("#selectDocu").kendoComboBox({
		dataSource : docuList,
		dataTextField: "CODE_NM",
		dataValueField: "CODE",
		index: 0,
		change : function(e){
			abdocuInfo.docu_fg = this.value();
			abdocuInfo.docu_fg_text = this.text();
			fnTradeTableSet();
			abdocu.BudgetInfo.remove();
		}
	});
	
    $(".controll_btn button").kendoButton();
	
    //품의/결의일자 컨트롤 초기화
    abdocu.setDatepicker("txtGisuDate");
    
    /* 회계 발의일 적용 */
    abdocu.setDatepicker("txtAcisuDate");

    /*결재작성*/
	$("#btnApprovalOpen").click(function(){
		abdocu.approvalOpen();
	});
	
	abdocu.init();
	
	/*행 변경 함수지정*/
	acUtil.focusNextRow = abdocu.focusNextRow;
	
    if(abdocu_no == 0){
    	fnAbdocuInit();	
    }else{
    	fnAbdocuInfo();
    }
    
	$("#btnReset").click(function(){
		if(!confirm('<%=BizboxAMessage.getMessage("TX000019433","초기화 하시겠습니까?")%>')) return false; 
		var abdocu_no = "0";            		
		var obj = acUtil.util.getParamObj();
		obj["abdocu_no"] = 0;
		obj["template_key"] = template_key; 
		obj["focus"] = "";
		obj["purcContId"] = purcContId;
		fnReLoad(obj);
	});

	if(!ncCom_Empty(c_dikeycode)){
		$("#btnReset").hide();
	}
	fnResizeForm();
	$("#selectDocu").data("kendoComboBox").value("1");
	$("#selectDocu").data("kendoComboBox").readonly(true);
	purcContPayInit();
	if($("#contType").val() == "004" && $("#txtPurcReqType").attr("code") == "1"){
		$(".smallPay").show();
		$("#selectDocu").data("kendoComboBox").value("4");
	}else{
		$(".smallPay").hide();
	}
});


</script>
<form id="outProcessFormData" action="http://211.192.144.104/gw/outProcessLogOn.do"></form>
<input type="hidden" id="compSeq" value="${loginVO.compSeq }"/>
<input type="hidden" id="empSeq" value="${loginVO.uniqId }"/>
<input type="hidden" id="loginId" value="${loginVO.id }"/>
<input type="hidden" id="erpCoCd" value="${loginVO.erpCoCd }"/>
<div class="pop_sign_wrap" style="width:999px;">
    <div class="pop_sign_head">
        <h1><span class="title_NM"><%=BizboxAMessage.getMessage("TX000002958","결의서")%></span> <%=BizboxAMessage.getMessage("TX000006808","작성")%></h1>
		<div class="psh_btnbox">
			<!-- 양식팝업 오른쪽 버튼그룹
			<div class="psh_left"></div>
			 -->
			<!-- 양식팝업 오른쪽 버튼그룹 -->
			<div class="psh_right">
				<div class="btn_cen mt8">
				    <input type="button" class="psh_btn" id="btnReset" value="<%=BizboxAMessage.getMessage("TX000002960","초기화")%>" />
				    <input type="button" class="psh_btn" id="btnContPjt" value="프로젝트 선택" />
					<input type="button" class="psh_btn" id="btnApprovalOpen" value="<%=BizboxAMessage.getMessage("TX000003154","결재작성")%>" />
				</div>
			</div>
		</div> 
    </div>
    <div class="pop_sign_con " style="padding:62px 16px 20px 16px;">
        <div class="top_box mt15" style="overflow:hidden;" id="erpUserInfo">
        <div id="erpUserInfo-table">
            <dl class="dl2">
                <dt style="width: 78px"><%=BizboxAMessage.getMessage("TX000009913","예산회계단위")%></dt>
                <dd><input type="text"  style="width:150px;" id="txtDIV_NM" readonly="readonly" disabled="disabled" class="requirement" tabindex="101"/>
                </dd>
            </dl>
            <dl class="dl2">
                <dt style="width: 98px"><%=BizboxAMessage.getMessage("TX000009435","결의부서/작성자")%></dt>
                <dd><input type="text"  style="width:150px;" id="txtDEPT_NM" readonly="readonly" disabled="disabled"  class="requirement" tabindex="102" />
                    <input type="text"  style="width:80px;" id="txtKOR_NM" readonly="readonly"  disabled="disabled" class="requirement">
                </dd>                                                  
            </dl>
            <dl class="dl2">
                <dt class="ar" style="width: 83px"><%=BizboxAMessage.getMessage("TX000009894","결의일자")%></dt>
                <dd><input style="width:119px;" id="txtGisuDate" class="non-requirement" tabindex="103"  part="user" /></dd>
            </dl>
        </div>           
        <input type="hidden" id="erpGisu"/>
        <input type="hidden" id="erpGisuFromDt"/>
        <input type="hidden" id="erpGisuToDt"/>  
        </div>
         
        <div>
        	<div class="com_ta2 hover_no mt15">
	            <table id="purcContPayInfo">
	            	<colgroup>
	            		<col width="100"/>
	            		<col width="437"/>
	            		<col width="100"/>
	            		<col width=""/>
	            	</colgroup>
	                <tbody>
	                    <tr>
	                        <th>구분</th>
	                        <td id="">
	                        	<input type="text" id="txtPurcReqType" class="txtPurcReqType" readonly="readonly" disabled="disabled" style="width: 97%;"/>
								<input type="hidden" id="purcContId" value="${params.purcContId }"/>
								<input type="hidden" id="contType"/>
	                        </td>
<!-- 	                        <th>구매의뢰번호</th> -->
<!-- 	                        <td id=""> -->
<!-- 	                        	<input type="text" id="txtPurcReqNo" class="" readonly="readonly" disabled="disabled" style="width: 90%;"/> -->
<!-- 	                        </td> -->
	                    </tr>
	                    	<th>계약명</th>
	                        <td id="">
	                        	<input type="text" id="txtContTitle" class="" readonly="readonly" disabled="disabled" style="width: 90%;"/>
	                        </td>
	                        <th>대금지급유형</th>
	                        <td id="">
	                        	<input type="text" id="paymentType" class="paymentType" style="width: 90%;"/>
	                        	<span class="paymentCnt">차수<input type="text" id="paymentCnt" class="" style="width: 69px;" value="1"/></span>
	                        </td>
	                    <tr>
	                    </tr>
	                </tbody>
	            </table>
	        </div>  
		</div>
		
        <div class="com_ta2 hover_no mt15" id="erpProjectInfo">
            <table border="0" id="erpProjectInfo-table">
                <thead>
                    <tr>
                        <th><%=BizboxAMessage.getMessage("TX000003616","결의구분")%></th>
                        <th><spna id="PjtTypeText"><%=BizboxAMessage.getMessage("TX000000519","프로젝트")%></spna></th>
                        <th style="display: none;" class="BottomTd"><%=BizboxAMessage.getMessage("TX000005362","하위사업")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000003617","입출금계좌")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000000604","적요")%></th>
                        <th width="70"></th>
                    </tr>
                </thead>
                <tbody>
                    <tr>            
                        <td><input type="text" style="width:87%;" id="selectDocu" tabindex="201" class="non-requirement"/></td>
                        <td>
                            <input type="text" style="width:85%;" id="txt_ProjectName" readonly="readonly" class="requirement" tabindex="202" />
                            <input type="hidden" id="txt_IT_BUSINESSLINK"/>
                            <input type="hidden" id="temp_PjtCd"/>
                        </td>
                        <td style="display: none;" class="BottomTd">
                            <input type="text" style="width:85%;" class="" id="txtBottom_cd" readonly="readonly" tabindex="203"/>
                        </td>
                        <td><a href="#n" class="search-Event-H"><img src="<c:url value='/Images/ico/ico_explain.png'/>" alt="" /></a> 
                            <input type="text" style="width:85%;"  id="txt_BankTrade" class="non-requirement"  tabindex="204" />
                            <input type="hidden" id="txt_BankTrade_NB"/> 
                        </td>
                        <td>
                            <input type="text" style="width:87%;" id="txt_Memo" class="requirement" CODE="empty"  tabindex="205"  part="project"/>
                        </td>
                        <td>
                            <div class="controll_btn ac" style=" padding:0px;">
                                <button type="button"  id="" class="erpsave"><%=BizboxAMessage.getMessage("TX000001256","저장")%></button>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>        


		<input type="hidden" id="txt_GisuDt" class="non-requirement" /> 
		</div>
		
<!-- 		원인행위 사용여부에 따라  -->
        <div class="top_box mt15 dtmr5" style="overflow:hidden;display: none;" id="causeForm">
            <dl class="dl2">
                <dt><%=BizboxAMessage.getMessage("TX000009893","원인행위")%></dt>
                <dd class="mr0"><input style="width:100px;" id="CAUSE_DT" value="" class="requirement dateInput" tabindex="301" /></dd>
            </dl>
            <dl class="dl2">
                <dt><%=BizboxAMessage.getMessage("TX000004254","계약일")%></dt>
                <dd class="mr0"><input style="width:100px;" id="SIGN_DT" value="" class="dateInput" tabindex="302" /></dd>
            </dl>
            <dl class="dl2">
                <dt><%=BizboxAMessage.getMessage("TX000005410","검수일")%></dt>
                <dd class="mr0"><input style="width:100px;" id="INSPECT_DT" value="" class="dateInput" tabindex="303" /></dd>
            </dl>
            <dl class="dl2">
                <dt><%=BizboxAMessage.getMessage("TX000009892","원인행위자")%></dt>
                <dd><input type="text"  style="width:67px;" id="CAUSE_ID"  value=""  class="requirement" tabindex="304" /></dd>
                <dd><input type="text"  style="width:90px" id="CAUSE_NM"  value="" disabled="disabled" class="requirement"  part="cause"/></dd>
                <dd><input type="button" id="search-Event-T-emp" value="검색" class="search-Event-H"/></dd>
                <dd>
                    <div class="controll_btn ac p0">
                        <button type="button" id="btnSave"><%=BizboxAMessage.getMessage("TX000001256","저장")%></button>
                        <button type="button" id="btnReset"><%=BizboxAMessage.getMessage("TX000002960","초기화")%></button>
                    </div>
                </dd>
            </dl>
        </div>      
        <div id="budgetInfo">  		
	        <div class="com_ta2 hover_no mt15">
	            <table>
	                <tbody>
	                    <tr>
	                        <th>관</th>
	                        <td id="td_veiw_BGT01_NM"></td>
	                       <th>항</th>
	                        <td id="td_veiw_BGT02_NM"></td>
	                        <!-- 곽경훈 수정 -->
							<th class="en_w140" >목</th>
	                        <td id="td_veiw_BGT03_NM"></td>
	                        <th>세</th>
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
	                        <th class="en_w140" ><%=BizboxAMessage.getMessage("TX000009911","품의액")%></th>
	                        <td id="td_veiw_REFER_AM" style="color: blue; font-weight: bold;"></td>
	                        <th><%=BizboxAMessage.getMessage("TX000005686","예산잔액")%></th>
	                        <td id="td_veiw_LEFT_AM" style="color: blue; font-weight: bold;"></td>
	                    </tr>
	                </tbody>
	            </table>
	        </div>  
        </div>
		<div class="com_ta2 mt15">
            <table id="erpBudgetInfo">
                <thead>
                    <tr>
						<th width="170"><%=BizboxAMessage.getMessage("TX000003622","예산과목")%></th>
						<th width="80"><%=BizboxAMessage.getMessage("TX000011180","결제수단")%></th>
						<th width="80"><%=BizboxAMessage.getMessage("TX000003635","과세구분")%></th>
						<th width="105"><%=BizboxAMessage.getMessage("TX000004257","채주유형")%></th>
						<th width="170"><%=BizboxAMessage.getMessage("TX000005318","예산사업장")%></th>
						<th width=""><%=BizboxAMessage.getMessage("TX000009910","문광부사용방법")%></th>
						<th width=""><%=BizboxAMessage.getMessage("TX000000644","비고")%></th>
						<th width="130"><%=BizboxAMessage.getMessage("TX000000552","금액")%></th>
						<th width="147"></th>						
                    </tr>
                </thead>
            </table>
        
	        <div class="com_ta2 ova_sc cursor_p" style="overflow-y:scroll; height:148px;">
		        <table id="erpBudgetInfo-table">
		            <tbody>
		            </tbody>
		        </table>
	        </div>            
        </div>  
        
        <table id="erpBudgetInfo-tablesample" style="display:none">
		    <tr class="">         
		        <td width="170" id="budget-td">
		            <a href="#n" class="search-Event-B"><img src="<c:url value='/Images/ico/ico_explain.png' />" alt="" /></a> 
		            <input type="text" style="width:78%;" id="txt_BUDGET_LIST"  class="requirement" tabindex="10001" readonly="readonly" />
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
		        <td width="80"><input style="width:95%;" id="selectVat_Fg"   tabindex="10003" class="non-requirement"/><input type="hidden" class="non-requirement" id="tempVat_Fg"  value="1"/></td>
		        <td width="105"><input style="width:95%;" id="selectTr_Fg"   tabindex="10004" class="non-requirement"/><input type="hidden" class="non-requirement" id="tempTr_Fg"  value="1"/></td>
		        <td width="170"><a href="#n" class="search-Event-B"><img src="<c:url value='/Images/ico/ico_explain.png' />" alt="" /></a> 
		            <input type="text" style="width:78%;" id="txt_BUDGET_DIV_NM"  class="requirement" tabindex="10005" readonly="readonly" />
		        </td>
		        <td width=""><select style="width:65px;" id="selectIT_USE_WAY"  tabindex="10007" class="non-requirement">
		            <option value="01"><%=BizboxAMessage.getMessage("TX000009432","계좌이체")%></option>
                    <option value="02"><%=BizboxAMessage.getMessage("TX000004704","현금")%></option>
                    <option value="03"><%=BizboxAMessage.getMessage("TX000003254","법인카드")%></option>
                    <option value=""></option>
                    </select>
		        </td>
		        <td width=""><input type="text" style="width:82%;" id="RMK_DC" CODE="empty" tabindex="10006" class="non-requirement" part="budget"/></td>
		        <td width="130"><span id="totalAM" class="totalAM"></span></td>
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
		        <td width="170"></td>
		        <td width="80"></td>
		        <td width="80"></td>
		        <td width="105"></td>
		        <td width="170"></td>
		        <td width=""></td>
		        <td width=""></td>
		        <td width="130"></td>
		        <td width="130"></td>
		    </tr>
		</table>
        <div class="controll_btn mt10 p0">
            <button class="cl fl" type="button" id="tradeCardBtn"  style="display:none;" ><%=BizboxAMessage.getMessage("TX000005379","카드거래처")%></button><span class="mL5" id="tradeCardNm" style=""></span>
            <button type="button" id="btnPayData" onclick="fnPayDataPop();" style="display:none"><%=BizboxAMessage.getMessage("TX000016508","급여자료")%></button>
            <button type="button" id="btnACardSungin" onclick="fnACardSunginPop();" style="display:none"><%=BizboxAMessage.getMessage("TX000005278","법인카드 승인내역")%></button>
            <button type="button" id="btnItems" onclick="fnItemsFormPop();"><%=BizboxAMessage.getMessage("TX000009891","명세서 등록")%></button><span id="budgetTotalAm" style="display:none"></span><span class="mL5" id="ItemsTotalAm" style="display:none"></span>
            <span class="cl fr" id="referConfer"></span><br>
        </div>
        
        <div class="com_ta2 mt15 scroll_on" >
			<table style="width:1146px;" id="erpTradeInfo">
				<thead>
					<tr>
					    <th width="150"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <span id="thTradeTrNm"><%=BizboxAMessage.getMessage("TX000000313","거래처명")%></span></th>    <!-- 1, 2(기타소득자) , 3(사원명), 4, 5(사업소득자)-->
			            <th width="80"><%=BizboxAMessage.getMessage("TX000000026","대표자명")%></th>   <!-- 1 -->                                                                                                   
						 <th width="100" class="smallPay" style="display: none;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <span id="thItemNm"><%=BizboxAMessage.getMessage("TX000005413","품명")%></span></th>      <!-- 1 -->                                                                                                     
			            <th width="80" class="smallPay" style="display: none;"><%=BizboxAMessage.getMessage("TX000004231","수량")%></th>      <!-- 1 -->
			            <th width="100"  class="smallPay" style="display: none;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000000468","단가")%></th>      <!-- 1 -->               
			            <th width="100"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <sapn id="thTradeUnitAm"><%=BizboxAMessage.getMessage("TX000000552","금액")%></span></th>      <!-- 1, 2(지급총액), 3(지급총액) , 4-->                                                                                                          
			            <th width="100"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <sapn id="thTradeSupAm"><%=BizboxAMessage.getMessage("TX000000516","공급가액")%></span></th>    <!-- 1, 2(실수령액), 3(실수령액) , 4-->                                                                                                            
			            <th width="100"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <sapn id="thTradeVatAm"><%=BizboxAMessage.getMessage("TX000000517","부가세")%></span></th>     <!-- 1, 2(원천징수액), 3(원천징수액), 4 --> 
			            <th width="100" ><%=BizboxAMessage.getMessage("TX000003619","금융기관")%></th>    <!-- 1, 2, 3, 4 -->
			            <th width="120" ><%=BizboxAMessage.getMessage("TX000003620","계좌번호")%></th>    <!-- 1, 2, 3, 4 -->
			            <th width="80" ><%=BizboxAMessage.getMessage("TX000003621","예금주")%></th>    <!-- 1, 2, 3, 4 -->                                                                                                 
			            <th width="130"><%=BizboxAMessage.getMessage("TX000000644","비고")%></th>      <!-- 1, 2, 3 , 4-->
			            <th width="100"><%=BizboxAMessage.getMessage("TX000000584","신고기준일")%></th>  <!-- 1, 2(신고기준일), 3(신고기준일), 4 -->                                                                                                        
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
				    <a href="javascript:;" class="search-Event-T"><img src="<c:url value='/Images/ico/ico_explain.png' />" alt="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" title="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" /></a>                                      
					<input type="text" style="width:60%" id="txt_TR_NM"  class="requirement" tabindex="20001"/> 
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
					
				</td>
				<td width="80"><input type="text" style="width:93%;" id="txt_CEO_NM"  class="non-requirement" tabindex="20002" /></td>
				<td width="100" class="smallPay" style="display: none;"><input type="text" id="txt_ITEM_NM"  style="width:85%;padding-right:7px;" class="ri requirement" CODE="empty" tabindex="20003" /></td>
				<td width="80" class="smallPay" style="display: none;"><input type="text" id="txt_ITEM_CNT"  style="width:85%;padding-right:7px;" class="ri non-requirement" tabindex="20004" /></td>                                                                           
				<td width="100" class="smallPay" style="display: none;"><input type="text" id="txt_ITEM_AM" code="empty" style="width:85%;padding-right:7px;" class="ri requirement" tabindex="20006" /></td>      
				<td width="100"><input type="text" id="txt_UNIT_AM"  style="width:85%;padding-right:7px;" class="ri requirement" CODE="empty" tabindex="20007" /></td>
				<td width="100"><input type="text" id="txt_SUP_AM"  style="width:85%;padding-right:7px;" class="ri non-requirement" tabindex="20008" /></td>                                                                           
				<td width="100"><input type="text" id="txt_VAT_AM" code="empty" style="width:85%;padding-right:7px;" class="ri requirement" tabindex="20009" /></td>                                                                           
				<td width="100"><a href="javascript:;" class="search-Event-T"><img src="<c:url value='/Images/ico/ico_explain.png' />" alt="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" title="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" /></a> 
				    <input type="text" style="width:73%;" id="txt_BTR_NM"  class="non-requirement" tabindex="20010" />
				</td>                                                     
				<td width="120"><input type="text" style="width:93%;" id="txt_BA_NB"  class="non-requirement" tabindex="20011" /></td>                                                      
				<td width="80"><input type="text" style="width:93%;" id="txt_DEPOSITOR"  class="non-requirement" tabindex="20012" /></td>                                                  
				<td width="130"><input type="text" style="width:93%;" id="txt_RMK_DC"  class="non-requirement" tabindex="20013"/></td>
				<td width="100"><input style="width:93%;" id="txt_TAX_DT"  class="non-requirement enter" tabindex="20014" part="trade" />
				    <input type="hidden" class="non-requirement" id="tempTAX_DT"/>     
				</td>
				<td width="130">
				    <div class="controll_btn ac p0">                         
					    <button type="button" class="erpsave" ><%=BizboxAMessage.getMessage("TX000001256","저장")%></button>                         
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
		        <td width="80" class="smallPay" style="display: none;"></td>
		        <td width="100" class="smallPay" style="display: none;"></td>
		        <td width="100" class="smallPay" style="display: none;"></td>
		        <td width="100"></td>
		        <td width="100"></td>
		        <td width="100"></td>
		        <td width="100"></td>
		        <td width="120"></td>
		        <td width="80"></td>
		        <td width="130"></td>
		        <td width="100"></td>
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
                         <label  for="B_use_YN2_1" class="mR5"><%=BizboxAMessage.getMessage("TX000004252","기준일")%></label>   
                         <input type="text" name="P_STD_DT"  id="P_STD_DT"  value="${basic_dt }"  style="width: 80px;"> 
                         <a href="javascript:;"  id="user_Search2" ><img src=" <c:url value='/Images/btn/search_icon2.png'/>" alt="<%=BizboxAMessage.getMessage("TX000000899","조회")%>" /></a>
                </dt>                
            </dl>
        </div>
        <!-- 입출금계좌 -->
        <div class="top_box" style="overflow:hidden;display:none;" id="BankTrade_Search">
            <dl class="dl2">
                <dt class="mr0">
           <%=BizboxAMessage.getMessage("TX000000028","사용여부")%> : 
                         <input type="radio" name="BankTrade_use_YN"  id="USE_YN_1"  value="1" class="k-radio"  checked="checked" />
                         <label class="k-radio-label"  for="USE_YN_1" style="top:0px;padding:0.2em 0 0 1.5em;"><%=BizboxAMessage.getMessage("TX000000180","사용")%> </label>
                         <input type="radio" name="BankTrade_use_YN"  id="USE_YN_2" value="2" class="k-radio" />
                         <label class="k-radio-label"  for="USE_YN_2" style="top:0px;margin:10px 0 0 10px;padding:0.2em 0 0 1.5em;"><%=BizboxAMessage.getMessage("TX000009908","전체(미사용포함)")%></label>                
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
                        <input type="radio" name="OPT_01" value="2"  id="OPT_01_2" class="k-radio" checked="checked" />
                        <label class="k-radio-label" for="OPT_01_2" style="padding:0.2em 0 0 1.5em;"><%=BizboxAMessage.getMessage("TX000005290","당기 편성된 예산과목만 표시")%></label>
                        <input type="radio" name="OPT_01" value="1" id="OPT_01_1" class="k-radio" />
                        <label class="k-radio-label" for="OPT_01_1" style="padding:0.2em 0 0 1.5em;"><%=BizboxAMessage.getMessage("TX000005112","모든 예산과목 표시")%></label>
                        <input type="radio" name="OPT_01" value="3" id="OPT_01_3" class="k-radio" />
                        <label class="k-radio-label" for="OPT_01_3" style="padding:0.2em 0 0 1.5em;"><%=BizboxAMessage.getMessage("TX000005291","프로젝트 기간 예산 편성된 과목만 표시")%></label>
                </dd>
            </dl>
            <dl class="next2">
                <dt style="width:100px;" class="en_w145">
            <%=BizboxAMessage.getMessage("TX000005486","사용기한")%> : 
                </dt>
                <dd> 
                        <input type="radio" name="OPT_02" value="1" id="OPT_02_1" class="k-radio"  checked="checked" />
                        <label class="k-radio-label"  for="OPT_02_1" style="padding:0.2em 0 0 1.5em;"><%=BizboxAMessage.getMessage("TX000004225","모두표시")%></label>
                        <input type="radio" name="OPT_02" value="2" id="OPT_02_2" class="k-radio" />
                        <label class="k-radio-label"  for="OPT_02_2" style="padding:0.2em 0 0 1.5em;"><%=BizboxAMessage.getMessage("TX000009907","사용기한경과분 숨김")%></label>
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

<div id="dialog-form-background" class="modal" style="display:none;"></div>
