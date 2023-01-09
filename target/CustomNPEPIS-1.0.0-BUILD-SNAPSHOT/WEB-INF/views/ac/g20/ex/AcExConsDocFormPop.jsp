<%@page import="org.apache.xmlbeans.impl.xb.xsdschema.IncludeDocument.Include"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="main.web.BizboxAMessage"%>

<%
 /**
  * @Class Name : AcExConsDocFormPopup.jsp
  * @Description : icube 품의서 작성 
  * @Modification Information
  *
  */ 
%>


<script type="text/javascript" src='<c:url value="/js/ac/acUtil.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/ac/g20/acG20ExForm.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/ac/g20/acG20Code.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/ac/g20/acMakeTable.js"></c:url>'></script>

<%-- <script type="text/javascript" src='<c:url value="/js/neos/erp/abdocu.js"></c:url>'></script> --%>

<style type="text/css">

.invalid { background-color : #ff6666;}
input:focus{background-color : #ccffff;}
.overBudget{background-color : #ff66dd;}
#project-td .search-Event-H, #budget-td .search-Event-B{display : none;}
#project-td #txt_ProjectName, .txt_BUDGET_LIST{disabled : disabled}

</style>

<script type="text/javascript">
// var docu = $.parseJSON('${docu}'); /* 지출결의서 종류*/
// abdocu.docu_fg = docu.code; /* 지출결의서 종류 코드 */
// abdocu.docu_mode = "${mode}";  /* 1 : 결의서, 0 : 품의서 */
// abdocu.FG_TY = "${FG_TY}"; /* 1 : 부서예산, 2 : 프로젝트예산 */
// abdocu.abdocu_no_reffer = "${abdocu_no_reffer}"; /* 참조품의 결의서일경우 참조하는 abdocu_no */
// abdocu.abdocu_no = "${abdocu.abdocu_no}"; /* abdocu_no */
// // var erpgisuArray = $.parseJSON('${erpgisu}'); /* 기수번호 */
// abdocu.focus = "${focus}";
// abdocu.template_key = "${template_key}";
// abdocu.c_dikeycode = "${c_dikeycode}";
// abdocu.permissionResult =  $.parseJSON('${permissionResult}'|| '{}');
// abdocu.erp_dept_cd = "${abdocu.erp_dept_cd }";
// abdocu.erp_co_cd = "${abdocu.erp_co_cd }";

// abdocu.tax = $.parseJSON('${tax}') || 0;
// abdocu.etc_percent =parseFloat( abdocu.tax.NDEP_RT, 10); /*필요경비율*/
// abdocu.sta_rt =parseFloat( abdocu.tax.STA_RT, 10); /*기타소득율*/
// abdocu.jta_rt =parseFloat( abdocu.tax.JTA_RT, 10); /*주민세율*/
// abdocu.mtax_am=parseFloat( abdocu.tax.MTAX_AM, 10); /*과세최저한*/
// abdocu.state_use = "${state_use}";
// abdocu.cocard_use = "${cocard_use}";
// abdocu.payAuth = "${payAuth}";     // 급여결의 권한
// abdocu.spendAuth = "${spendAuth}"; // 지출결의 권한(품의리스트 전체보기권한)
// abdocu.bonAccYn = "${bonAccYn}"; // 본지점회계여부 
// abdocu.causeYn = "${causeYn}"; // 원인행위부사용여부
// abdocu.step7YN  = "${step7YN}";
// abdocu.hcnum_use  = NeosCodeUtil.getCodeName("G20301" , "HC_USE") ;   //  회차 사용여부
// abdocu.cause_require  = NeosCodeUtil.getCodeName("G20301" , "CAUSE_REQUIRE") ;   //  원인행위필수체크


	var template_key = "${params.template_key}" || "";
	var c_dikeycode = "${params.diKeyCode}" || "";
	var mode = "${params.mode}" || "0";
	var abdocu_no = "${params.abdocu_no}" || "0";
	
	var abdocu_no_reffer = "${params.abdocu_no_reffer}" || "";
	var focus = "${params.focus}" || "";
	var requestUrl = "${params.requestUrl}" || "";
	var docu_mode = "";
	
$(function(){

  	
	// 품의구분 
	var docuList = NeosCodeUtil.getCodeList("G20101");
	$("#selectDocu").kendoComboBox({
		dataSource : docuList,
		dataTextField: "CODE_NM",
		dataValueField: "CODE",
		index: 0,
		change : function(e){
			abdocuInfo.docu_fg = this.value();
			abdocuInfo.docu_fg_text = this.text();
			abdocu.BudgetInfo.remove();
			fnTradeTableSet();
		}
	});
	    
    //품의/결의일자 컨트롤 초기화
    abdocu.setDatepicker("txtGisuDate");
    $(".controll_btn button").kendoButton();

    /*결재작성*/
	$("#btnApprovalOpen").click(function(){
		abdocu.approvalOpen();
	});
	

	abdocu.init();
	
	/*행 변경 함수지정*/
	acUtil.focusNextRow = abdocu.focusNextRow;
	/*dialog 띄우기 전 실행될 함수*/
// 	acUtil.util.dialog.preProcessing = abdocu.dialogPreProcessing;
	
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
		fnReLoad(obj);
	});

	if(!ncCom_Empty(c_dikeycode)){
		$("#btnReset").hide();
	}
	fnResizeForm();
});

// abdocu.BudgetInfo.changeG2TR_TP = function(id){
// 	var select = $("#" + id);
// 	var modeType = select.val();

    
//     MakeTradeTable.mode.create(modeType, abdocu.docu_mode);
    
//     var table = $("#erpBudgetInfo-table");
//     var id = $("." + abdocu.BudgetInfo.BudgetInfoSelectClass, table).first().attr("id");
//     if(id){
//     	abdocu.BudgetInfo.rowSelect(id);
//     	select.focus();
//     }else{
//     	abdocu.TradeInfo.remove();
//     	select.focus();
//     }
// };

// function checkLength(maxlen, obj) {
//     var temp;
//     var msglen = maxlen*2;
//     var value  = obj.value;

//     var len =  obj.value.length;
//     var txt = "" ;

//     if (len == 0) {
//         value = maxlen*2;
//     } else  {
//         for(var k=0; k<len; k++) {
//             temp = value.charAt(k);
//             msglen -= 2;
            
//             if(msglen < 0) {
//                alert("최대 " + maxlen + "자 까지 입력할 수 있습니다.");
//                 obj.value = txt;
//                 break;
//             } else {
//                 txt += temp;
//             };
//         };
//     };
// }

</script>

<div class="pop_sign_wrap scroll_on" style="width:999px;">
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

        <div class="top_box mt15" style="overflow:hidden;" id="erpUserInfo">
        <div id="erpUserInfo-table">
            <dl class="dl2">
                <dt><%=BizboxAMessage.getMessage("TX000009913","예산회계단위")%></dt>
                <dd><input type="text"  style="width:150px;" id="txtDIV_NM" readonly="readonly" disabled="disabled" class="requirement" tabindex="101"/>
                    <input type="button" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" class="search-Event-H"/> 
                </dd>
            </dl>
            <dl class="dl2">
                <dt><%=BizboxAMessage.getMessage("TX000006717","품의부서/작성자")%></dt>
                <dd><input type="text"  style="width:150px;" id="txtDEPT_NM" readonly="readonly" disabled="disabled"  class="requirement" tabindex="102" />
                    <input type="text"  style="width:80px;" id="txtKOR_NM" readonly="readonly"  disabled="disabled" class="requirement">
                    <input type="button" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" class="search-Event-H"/>
                </dd>                                                    
            </dl>
            <dl class="dl2">
                <dt><%=BizboxAMessage.getMessage("TX000004251","품의일자")%></dt>
                <dd><input style="width:119px;" id="txtGisuDate" class="non-requirement" tabindex="103"  part="user" /></dd>
            </dl>
            
        </div>           
        <input type="hidden" id="erpGisu"/>
        <input type="hidden" id="erpGisuFromDt"/>
        <input type="hidden" id="erpGisuToDt"/>          
        </div>        

        <div class="com_ta2 hover_no mt15" id="erpProjectInfo">

            <table border="0" id="erpProjectInfo-table">
                <thead>
                    <tr>
                        <th><%=BizboxAMessage.getMessage("TX000004239","품의구분")%></th>
                        <th><spna id="PjtTypeText"><%=BizboxAMessage.getMessage("TX000000519","프로젝트")%></spna></th>
                        <th style="display: none;" class="BottomTd"><%=BizboxAMessage.getMessage("TX000005362","하위사업")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000003617","입출금계좌")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000000604","적요")%></th>
                        <th width="70"></th>
                    </tr>
                </thead>
                <tbody>
                    <tr>            
                        <td><input type="text" style="width:87%;" id="selectDocu" tabindex="201" class="non-requirement" /></td>
                        <td><a href="#n" class="search-Event-H"><img src="<c:url value='/Images/ico/ico_explain.png'/>" alt="" /></a> 
                            <input type="text" style="width:85%;" id="txt_ProjectName" readonly="readonly" class="requirement" tabindex="202" />
<!--                                <input type="hidden" id="txt_PJT_FR_DT" /> -->
<!--                                <input type="hidden" id="txt_PJT_TO_DT" /> -->
                            <input type="hidden" id="txt_IT_BUSINESSLINK"/>
                        </td>
                        <td style="display: none;" class="BottomTd">
                            <a href="#n" class="search-Event-H"><img src="<c:url value='/Images/ico/ico_explain.png'/>" alt="" /></a> 
                            <input type="text" style="width:85%;" class="" id="txtBottom_cd" tabindex="203"/>
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
        <div id="budgetInfo">  		        		
	        <div class="com_ta2 hover_no mt15">
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
	                        <td id="td_veiw_OPEN_AM"></td>                    
	                        <th><%=BizboxAMessage.getMessage("TX000011177","배정액")%></th>
	                        <td id="td_veiw_ACCEPT_AM"></td>
	                        <th><%=BizboxAMessage.getMessage("TX000005056","집행액")%></th>
	                        <td id="td_veiw_APPLY_AM"></td>
	                        <th class="en_w140" ><%=BizboxAMessage.getMessage("TX000009911","품의액")%></th>
	                        <td id="td_veiw_REFER_AM"></td>
	                        <th><%=BizboxAMessage.getMessage("TX000004247","예산잔액")%></th>
	                        <td id="td_veiw_LEFT_AM"></td>
	                    </tr>
	                </tbody>
	            </table>
	        </div>  
        </div>
        
		<div class="com_ta2 mt15">
			<table  id="erpBudgetInfo">
				<thead>
					<tr>
						<th width="170"><%=BizboxAMessage.getMessage("TX000003622","예산과목")%></th>
						<th width="80"><%=BizboxAMessage.getMessage("TX000011180","결제수단")%></th>
						<th width="80"><%=BizboxAMessage.getMessage("TX000003635","과세구분")%></th>
						<th width=""><%=BizboxAMessage.getMessage("TX000004257","채주유형")%></th>
						<th width="170"><%=BizboxAMessage.getMessage("TX000005318","예산사업장")%></th>
						<th width=""><%=BizboxAMessage.getMessage("TX000009910","문광부사용방법")%></th>
						<th width=""><%=BizboxAMessage.getMessage("TX000000644","비고")%></th>
						<th width="130"><%=BizboxAMessage.getMessage("TX000000552","금액")%></th>
						<th width="147"></th>
					</tr>
				</thead>
			</table>
		</div>
		
		<div class="com_ta2 ova_sc cursor_p" style="overflow-y:scroll; height:148px;">
			<table id="erpBudgetInfo-table">
				<tbody>
                </tbody>
			</table>
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
		        <td width=""><input style="width:95%;" id="selectTr_Fg"   tabindex="10004" class="non-requirement"/><input type="hidden" class="non-requirement" id="tempTr_Fg"  value="1"/></td>
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
		        <td width=""></td>
		        <td width="170"></td>
		        <td width=""></td>
		        <td width=""></td>
		        <td width="130"></td>
		        <td width="130"></td>
		    </tr>
		</table>        
<!--         <div class="controll_btn mt25 p0"> -->
<!--         </div> -->
        <div class="com_ta2 mt15 scroll_on" style="height:200px;">
			<table style="width:966px;" id="erpTradeInfo">
				<thead>
					<tr>
					    <th width="150" id="thTradeTrNm"><%=BizboxAMessage.getMessage("TX000000313","거래처명")%></th>    <!-- 1, 2 , 3(사원명), 4(기타소득자)-->
			            <th width="80"><%=BizboxAMessage.getMessage("TX000000026","대표자명")%></th>   <!-- 2 -->
			            <th width="100"><%=BizboxAMessage.getMessage("TX000005413","품명")%></th>      <!-- 1 -->                                                                                                     
			            <th width="80"><%=BizboxAMessage.getMessage("TX000004231","수량")%></th>      <!-- 1 -->                                                                                                          
			            <th width="80"><%=BizboxAMessage.getMessage("TX000000468","단가")%></th>      <!-- 1 -->                                                                                                          
			            <th width="100" id="thTradeTrNm"><%=BizboxAMessage.getMessage("TX000000552","금액")%></th>      <!-- 1, 2, 3 , 4(지급총액)-->                                                                                                          
			            <th width="100" id="thTradeTrNm"><%=BizboxAMessage.getMessage("TX000000516","공급가액")%></th>    <!-- 1, 2, 3 , 4(실수령액)-->                                                                                                            
			            <th width="100" id="thTradeTrNm"><%=BizboxAMessage.getMessage("TX000004701","부가세")%></th>     <!-- 1, 2, 3, 4(원천징수액) --> 
			            <th width="100"><%=BizboxAMessage.getMessage("TX000003619","금융기관")%></th>    <!-- 2, 3, 4 -->
			            <th width="120"><%=BizboxAMessage.getMessage("TX000003620","계좌번호")%></th>    <!-- 2, 3, 4 -->
			            <th width="80"><%=BizboxAMessage.getMessage("TX000003621","예금주")%></th>    <!-- 2, 3, 4 -->                                                                                                       
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
					<input type="text" style="width:70%" id="txt_TR_NM"  class="requirement" tabindex="20001"/> 
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
				<td width="100"><input type="text" id="txt_ITEM_NM"  style="width:85%;padding-right:7px;" class="ri requirement" CODE="empty" tabindex="20002" /></td>
				<td width="80"><input type="text" id="txt_ITEM_CNT"  style="width:85%;padding-right:7px;" class="ri non-requirement" tabindex="20003" /></td>                                                                           
				<td width="100"><input type="text" id="txt_ITEM_AM" code="empty" style="width:85%;padding-right:7px;" class="ri requirement" tabindex="20004" /></td>                                                                           
				<td width="100"><input type="text" id="txt_UNIT_AM"  style="width:85%;padding-right:7px;" class="ri requirement" CODE="empty" tabindex="20002" /></td>
				<td width="100"><input type="text" id="txt_SUP_AM"  style="width:85%;padding-right:7px;" class="ri non-requirement" tabindex="20003" /></td>                                                                           
				<td width="100"><input type="text" id="txt_VAT_AM" code="empty" style="width:85%;padding-right:7px;" class="ri requirement" tabindex="20004" /></td>                                                                           
				<td width="100"><a href="javascript:;" class="search-Event-T"><img src="<c:url value='/Images/ico/ico_explain.png' />" alt="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" title="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" /></a> 
				    <input type="text" style="width:73%;" id="txt_BTR_NM"  class="non-requirement" tabindex="20005" />
				</td>                                                     
				<td width="120"><input type="text" style="width:93%;" id="txt_BA_NB"  class="non-requirement" tabindex="20006" /></td>                                                      
				<td width="80"><input type="text" style="width:93%;" id="txt_DEPOSITOR"  class="non-requirement" tabindex="20007" /></td>                                                  
				<td width="130"><input type="text" style="width:93%;" id="txt_RMK_DC"  class="non-requirement" tabindex="20008" part="trade"/></td>
<!-- 				<td><input style="width:93%;" id="txt_TAX_DT"  class="non-requirement enter" tabindex="20011" part="trade" /> -->
<!-- 				    <input type="hidden" class="non-requirement" id="tempTAX_DT"/>      -->
<!-- 				</td> -->
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
		        <td width="80"></td>
		        <td width="100"></td>
		        <td width="100"></td>
		        <td width="100"></td>
		        <td width="100"></td>
		        <td width="100"></td>
		        <td width="120"></td>
		        <td width="80"></td>
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
        <!-- 입출금계좌 -->
        <div class="top_box" style="overflow:hidden;display:none;" id="BankTrade_Search">
            <dl class="dl2">
                <dt class="mr0">
                         <%=BizboxAMessage.getMessage("TX000000028","사용여부")%> : 
                         <input type="radio" name="BankTrade_use_YN"  id="USE_YN_1"  value="1" class="k-radio"  checked="checked" />
                         <label class="k-radio-label"  for="USE_YN_1" style="top:0px;padding:0.2em 0 0 1.5em;"><%=BizboxAMessage.getMessage("TX000000180","사용")%>  </label>
                         <input type="radio" name="BankTrade_use_YN"  id="USE_YN_2" value="2" class="k-radio" />
                         <label class="k-radio-label"  for="USE_YN_2" style="top:0px;margin:10px 0 0 10px;padding:0.2em 0 0 1.5em;"><%=BizboxAMessage.getMessage("TX000009647","전체(미사용포함)")%></label>                
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
