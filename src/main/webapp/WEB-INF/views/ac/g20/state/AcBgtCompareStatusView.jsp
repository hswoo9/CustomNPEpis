<%@page import="org.apache.xmlbeans.impl.xb.xsdschema.IncludeDocument.Include"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="main.web.BizboxAMessage"%>

<%
 /**
  * @Class Name : AcBgtCompareStatusView.jsp
  * @Description : 예실대비현황
  * @Modification Information
  */
%>
<script type="text/javascript" src='<c:url value="/js/ac/acUtil.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/ac/g20/acG20State.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/ac/g20/acG20Code.js"></c:url>'></script>


<script type="text/javascript">
var BudgetConStatus = {};



	$(document).ready(function(){
	
		$("#DIV_CD").data("kendoComboBox");
		$("#DIV_FG").data("kendoComboBox");
	
			/*조회버튼*/
	    $(".btnSearch").click(function(){
	    	if("${link_yn}" =="N"){
	    		alert("<%=BizboxAMessage.getMessage("TX000016531","ERP 연동되어 있지 않습니다. 관리자에게 문의 바랍니다")%>");
	    	    return;       
	    	}
	        $("#searchYN").val("Y" );
	        $("#EXCEL_YN").val("N" );
	        //$("form#searchForm").submit();
	        BudgetConStatus.seachList();
	    });
	    
	    $("#btnExcel").click(function(){
	//     	if("${link_yn}" =="N"){
	//             alert("ERP 연동되어 있지 않습니다. 관리자에게 문의 바랍니다. ");
	//             return;       
	//         }
	//     	$("#searchYN").val("N" );
	//     	$("#EXCEL_YN").val("Y" );
	//     	BudgetConStatus.seachListExcel();
	    	 $("#grid").data("kendoGrid").saveAsExcel();
	
		});
	    
	    
	    $('input[name=BGT_CNT]').keypress(function(e){ numOnly(e); });
	    
		acG20State.init();
		acG20State.fnStateInit();	
	    BudgetConStatus.seachList();
	});


BudgetConStatus.seachList = function(){
	
	modal(true);
	var tblParam = {};
	tblParam.CO_CD       = $("#CO_CD").val();
	tblParam.GISU        = $("#GISU").val();
	tblParam.DIV_CDS     = $("#DIV_CD").val() + "|";
	tblParam.MGT_CDS     = $("#MGT_CDS").val();
	tblParam.ZEROLINE_FG = $("#ZEROLINE_FG").val();
	tblParam.GR_FG       = $("#GR_FG").val();
	tblParam.BGT_CNT     = $("#BGT_CNT").val();
	tblParam.DIV_FG      = $("#DIV_FG").val();
	tblParam.BGT_CD_FROM = $("#BGT_CD_FROM").val();
	tblParam.BGT_CD_TO   = $("#BGT_CD_TO").val();
	tblParam.OPT12       = $("#OPT12").val();
	tblParam.OPT13       = $("#OPT13").val();
	tblParam.OPT14       = $("#OPT14").val();
	tblParam.DATE_FROM   = $("#DATE_FROM").val();
	tblParam.DATE_TO     = $("#DATE_TO").val();
	tblParam.FR_DT       = $("#FR_DT").val();
	tblParam.TO_DT       = $("#TO_DT").val();
	tblParam.EMP_CD      = $("#EMP_CD").val();
	tblParam.BOTTOM_CDS   = $("#BOTTOM_CD").val() + "|";
        
    var opt = {  
            type:"post",
            url: '<c:url value="/Ac/G20/State/getErpBgtCompareStatus.do" />' ,
            datatype:"json",
            data: tblParam,
            success:function(data){        
                //grid table
                $("#grid").kendoGrid({ 
//                     excel: {
//                     	filterable:true,
//                     	allPages: true,
//                         fileName: "예실대비현황.xlsx"
//                     },
                    excelExport: function(e) {
                        e.workbook.fileName = "Grid.xlsx";
                      }
                    ,
                    columns: [                    
                        {
                            field:"BGT_CD", 
                            title:"<%=BizboxAMessage.getMessage("TX000004243","예산코드")%>", 
                            width:132,
                            headerAttributes: {style: "text-align:center;"}, 
                            attributes: {style: "text-align:left;"},
                        },
                        {
                            field:"DIV_FG_NM", 
                            title:"<%=BizboxAMessage.getMessage("TX000000214","구분")%>",
                            width:54,
                            headerAttributes: {style: "text-align:center;"}, 
                            attributes: {style: "text-align:center;"},
                        },
                        {
                            field:"BGT_NM",
                            title : "<%=BizboxAMessage.getMessage("TX000003629","예산과목명")%>", 
                            headerAttributes: {style: "text-align:center;"}, 
                            attributes: {style: "text-align:left;"},
                            template: function(dataItem){
                            	
                            	var dispTxt = '';
                            	var cnt = parseInt( dataItem.DIV_FG || '0' );
                            	for(var i=0; i< cnt; i++){
                            		dispTxt += '&nbsp;&nbsp;&nbsp;';
                            	}
                            	dispTxt += (dataItem.BGT_NM || '-');
                            	return "<a href=javascript:acG20State.datailPop('"+dataItem.BGT_CD + "');>"+ dispTxt +"</a>"; 
                            }
                        },
                        {
                            field:"CARR_AM",
                            title : "<%=BizboxAMessage.getMessage("TX000005060","이월예산")%>", 
                            width:132, 
                            headerAttributes: {style: "text-align:center;"}, 
                            attributes: {style: "text-align:right;"},
                            template: function(dataItem){
                            	return kendo.toString(dataItem.CARR_AM, "n0");
                            }
                        },
                        {
                            field:"CF_AM", 
                            title : "<%=BizboxAMessage.getMessage("TX000003814","승인예산")%>", 
                            width:132,
                            headerAttributes: {style: "text-align:center;"}, 
                            attributes: {style: "text-align:right;"},
                            template: function(dataItem){
                            	return kendo.toString(dataItem.CF_AM, "n0");
                            }
                        },
                        {
                            field:"ADD_AM0", 
                            title : "<%=BizboxAMessage.getMessage("TX000005061","추경예산")%>", 
                            width:132,
                            headerAttributes: {style: "text-align:center;"}, 
                            attributes: {style: "text-align:right;"},
                            template: function(dataItem){
                            	return kendo.toString(dataItem.ADD_AM0, "n0");
                            }
                        },
                        {
                            field:"ADD_AM1", 
                            title : "<%=BizboxAMessage.getMessage("TX000005062","전용액")%>", 
                            width:132,
                            headerAttributes: {style: "text-align:center;"}, 
                            attributes: {style: "text-align:right;"},
                            template: function(dataItem){
                            	return kendo.toString(dataItem.ADD_AM1, "n0");
                            }
                        },
                        {
                            field:"CALC_AM", 
                            title : "<%=BizboxAMessage.getMessage("TX000005063","예산합계")%>", 
                            width:132,
                            headerAttributes: {style: "text-align:center;"}, 
                            attributes: {style: "text-align:right;"},
                            template: function(dataItem){
                            	return kendo.toString(dataItem.CALC_AM, "n0");
                            }
                        },
                        {
                            field:"ACCT_AM", 
                            title : "<%=BizboxAMessage.getMessage("TX000005056","집행액")%>", 
                            width:132,
                            headerAttributes: {style: "text-align:center;"}, 
                            attributes: {style: "text-align:right;"},
                            template: function(dataItem){
                            	return kendo.toString(dataItem.ACCT_AM, "n0");
                            }
                        },
                        {
                            field:"SUB_AM", 
                            title : "<%=BizboxAMessage.getMessage("TX000009126","예산대비예산잔액")%>", 
                            width:132,
                            headerAttributes: {style: "text-align:center;"}, 
                            attributes: {style: "text-align:right;"},
                            template: function(dataItem){
                            	return kendo.toString(dataItem.SUB_AM, "n0");
                            }
                        },
                        {
                            field:"SUB_RATE",
                            title : "<%=BizboxAMessage.getMessage("TX000005065","대비(%)")%>", 
                            width:132, 
                            headerAttributes: {style: "text-align:center;"}, 
                            attributes: {style: "text-align:right;"},
                            template: function(dataItem){
                            	return kendo.toString(dataItem.SUB_RATE, "n4");
                            }
                        }
                    ],
                    dataSource: data.selectList,
                    selectable: "single",
                    groupable: false,
                    columnMenu:false,
                    editable: false,
                    sortable: true,
                    pageable: false,
                    dataBound: function(e) {
                    	var dataItems = e.sender.dataSource.view();
                    	for (var j = 0; j < dataItems.length; j++) {
                    		var dataItem = dataItems[j];
                    		var row = e.sender.tbody.find("[data-uid='" + dataItems[j].uid + "']");
                    		dataItem.DIV_FG = !dataItem.BGT_NM ? '6' : dataItem.DIV_FG; 
	                   		var classId = 'grid_bg_green' + (parseInt(dataItem.DIV_FG || '6') + 1);
                    		row.addClass(classId);
                    	}
					}
        		}).data("kendoGrid");
                
//                 var totalList = data.totalList;             
//                 for(var i=0;i<totalList.length;i++){
//                 	$("#CARR_AM_1"+totalList[i].SUMMARY_YN).html(getToPrice(totalList[i].CARR_AM));
//                 	$("#CF_AM_"+totalList[i].SUMMARY_YN).html(getToPrice(totalList[i].CF_AM));
//                 	$("#ADD_AM0_"+totalList[i].SUMMARY_YN).html(getToPrice(totalList[i].ADD_AM0));
//                 	$("#ADD_AM1_"+totalList[i].SUMMARY_YN).html(getToPrice(totalList[i].ADD_AM1));
//                 	$("#CALC_AM_"+totalList[i].SUMMARY_YN).html(getToPrice(totalList[i].CALC_AM));
//                 	$("#ACCT_AM_"+totalList[i].SUMMARY_YN).html(getToPrice(totalList[i].ACCT_AM));
//                 	$("#SUB_AM_"+totalList[i].SUMMARY_YN).html(getToPrice(totalList[i].SUB_AM));
//                 	$("#SUB_RATE_"+totalList[i].SUMMARY_YN).html(totalList[i].SUB_RATE.toFixed(3));
//                 }
                
                modal(false);
            },
    	    error: function (request,status,error) {
    	    	alert("<%=BizboxAMessage.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요")%>\n<%=BizboxAMessage.getMessage("TX000009711","오류 메시지 : {0}")%>".replace("{0}",error)+"\n");
    	    	modal(false);
        	}
    };
    
    $.ajax(opt);    
};

// BudgetConStatus.seachListExcel = function(){
//     document.searchForm.action = "<c:url value='/Ac/G20/State/getErpBgtCompareStatus' />";
//     document.searchForm.submit();
// };
</script>

<!-- <body> -->
            <input type="hidden" id="CO_CD" name="CO_CD"  class="formData" />
            <input type="hidden" id="EMP_CD" name="EMP_CD"  class="formData"  />
            <input type="hidden" id="FR_DT" name="FR_DT"  class="formData"  />
            <input type="hidden" id="TO_DT" name="TO_DT"  class="formData"  />
            <input type="hidden" id="DIV_CDS" name="DIV_CDS"  class="formData" />
            <input type="hidden" id="MGT_CDS" name="MGT_CDS"  class="formData" />
            <input type="hidden" id="BOTTOM_CDS" name="BOTTOM_CDS"  class="formData" /> 
                    <!-- 컨텐츠내용영역 -->
                    <div class="sub_contents_wrap">
                        <!-- contents -->  
                        <div class="top_box">
                            <dl>
                                <dt><%=BizboxAMessage.getMessage("TX000000017","회사코드")%></dt>
<!--                                 <dd><input id="CO_CD"  name="CO_CD" style="width:160px;" class="formData" /></dd> -->
                                <dd><span id="coInfo"/></dd>
                                <dt><%=BizboxAMessage.getMessage("TX000009174","기수기준일")%></dt>
                                <dd><input id="GISU_DT"  name="GISU_DT" class="dpWid formData"/></dd>
                                <dt><%=BizboxAMessage.getMessage("TX000003640","기수")%></dt>
                                <dd><input type="text"name="GISU"  id="GISU"  style="width:40px;" class="formData" readonly="readonly"> <%=BizboxAMessage.getMessage("TX000009914","기")%></dd>
                            </dl>
                        </div>
                        <!-- 컨트롤버튼 -->                      
                        <div>
                            <div id="" class="controll_btn">
                                <button type="button" id="btnExcel"><%=BizboxAMessage.getMessage("TX000016598","Excel 다운로드")%></button>
                            </div>
                        </div>
                        
<%--                         <input type="hidden" id=FG_TY name="FG_TY" value="${ErpBudgetVO.FG_TY}"/> --%>
                        <input type="hidden" id="searchYN" name="searchYN" value=""/>
                        <input type="hidden" id="EXCEL_YN" name="EXCEL_YN" value=""/>
                        <!-- 조회조건 -->
                        <div class="com_ta">
                            <table id="searchTable">
                                <colgroup>
                                    <col width="93" class="en_w130"/>
                                    <col width=""/>
                                    <col width="93" class="en_w130"/>
                                    <col width=""/>
                                </colgroup>
                                <tr>
                                    <th><%=BizboxAMessage.getMessage("TX000000811","사업장")%></th>
                                    <td><input id="DIV_CD" name="DIV_CD" class="formData"  style="width:160px;"/> <!-- <select style='width:180px;' id='DIV_CD' name='DIV_CD' class="formData"> --></td>
                                    <th><%=BizboxAMessage.getMessage("TX000000861","조회기간")%></th>
                                    <td>
                                        <input id="DATE_FROM"  name="DATE_FROM" class="dpWid formData"/>
                                        ~
                                        <input id="DATE_TO"  name="DATE_TO" class="dpWid formData"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th class="FG_TYSpan"><%=BizboxAMessage.getMessage("TX000000519","프로젝트")%></th>
                                    <td>
                                        <input type="text" style="width:135px;" id="MGT_CD_NM"  name="MGT_CD_NM"  readonly="readonly" class="requirement formData" />
                                        <input type="text" style="width:100px;" id="MGT_CD"  name="MGT_CD" class="requirement formData" />
                                        <a href="javascript:;" class="search-Event-H btn_search"></a>
<!--                                      <span class="bottonSpan" style="display:none;">  -->
<!--                                         <input type="text" style="width:135px;" id="BOTTOM_NM" name="BOTTOM_NM" readonly="readonly" class="requirement formData" /> -->
<!--                                         <input type="text" style="width:100px;" id="BOTTOM_CD"  name="BOTTOM_CD" class="formData"/> -->
<!--                                         <a href="javascript:;" class="search-Event-H btn_search"></a> -->
<!--                                      </span> -->
                                    </td>
                                    <th><%=BizboxAMessage.getMessage("TX000005362","하위사업")%></th>
                                    <td>
                                        <input type="text" style="width:135px;" id="BOTTOM_NM" name="BOTTOM_NM" readonly="readonly" class="requirement formData" />
                                        <input type="text" style="width:100px;" id="BOTTOM_CD"  name="BOTTOM_CD" class="formData"/>
                                        <a href="javascript:;" class="search-Event-H btn_search"></a>
                                     </span>
                                    </td>                                    
                                </tr>
                                <tr>
                                    <th><%=BizboxAMessage.getMessage("TX000003622","예산과목")%></th>
                                    <td colspan="3">
                                        <div class="dp_ib" style="width:270px;">
                                            <input type="text" style="width:135px;" id="BGT_NM_FROM" name="BGT_NM_FROM" readonly="readonly" class="requirement BGT_CD"  target="FROM"/>
                                            <input type="text" style="width:100px;" id="BGT_CD_FROM" name="BGT_CD_FROM" readonly="readonly" class="requirement BGT_CD" target="FROM"/>
                                            <input type="hidden"  name="SYS_CD_FROM"  id="SYS_CD_FROM"  class="formData"  target="FROM"/>
<!--                                             <input class="k-textbox input_search" id="" type="text" value="" style="width:100px;" placeholder=""> -->
                                            <a href="#" class="btn_search search-Event-H"></a>
                                        </div>
                                        ~
                                        <div class="dp_ib" style="width:270px;">
                                            <input type="text" style="width:135px;" id="BGT_NM_TO" name="BGT_NM_TO" readonly="readonly"  value="${ErpBudgetVO.BGT_NM_TO}" class="requirement BGT_CD" target="TO"/> 
                                            <input type="text" style="width:100px;" id="BGT_CD_TO" name="BGT_CD_TO" value="${ErpBudgetVO.BGT_CD_TO}" readonly="readonly" class="requirement BGT_CD" target="TO"/>
                                            <input type="hidden"  name="SYS_CD_TO"  id="SYS_CD_TO"  class="formData" target="TO"/>
                                            <a href="javascript:;" class="btn_search search-Event-H"></a>
                                        </div>                               
                                    </td>
                                </tr>                                
                                <tr>
                                    <th><%=BizboxAMessage.getMessage("TX000007052","과목구분")%></th>
                                    <td>
                                        <input id="DIV_FG" name="DIV_FG" style="width:100px;"/>
                                        <%=BizboxAMessage.getMessage("TX000007051","차수")%>
                                        <input type="text" name="BGT_CNT"  id="BGT_CNT"  value="1" style="width:40px;">
                                    </td>
                                    <th><%=BizboxAMessage.getMessage("TX000005055","입출구분")%></th>
                                    <td><input id="GR_FG" name="GR_FG" style="width:100px;"/></td>                                    
                                    
                                </tr>
                                <tr>
                                    <th><%=BizboxAMessage.getMessage("TX000005056","집행액")%></th>
                                    <td colspan="">
                                        <input name="OPT12" id="OPT12"  style="width:100px;"/>
                                        <%=BizboxAMessage.getMessage("TX000005057","집계일자")%>
                                        <input name="OPT13" id="OPT13"  style="width:100px;"/>
                                    </td>
                                    <th><%=BizboxAMessage.getMessage("TX000005058","예산현액")%></th>
                                    <td>
                                        <input name="OPT14" id="OPT14"  style="width:100px;"/>
                                        <%=BizboxAMessage.getMessage("TX000009124","금액없는 라인")%>
                                        <input name="ZEROLINE_FG" id="ZEROLINE_FG"  style="width:62px;"/>
                                    </td>                                    
                                </tr>
                            </table>
                        </div>
                        
                        <!-- 조회버튼 -->
                        <div class="btn_cen pt12">
                            <input type="button" class="btnSearch" value="<%=BizboxAMessage.getMessage("TX000000899","조회")%>">
                        </div>
                                                

                        </form>
        
                        <div class="g20_date_grid">        
                        
                            <!-- 테이블 -->
                            <div id="grid" class="data_grid" style="border-width:1px 0 0 0;"></div> 
                                                    
                            <!-- 고정테이블 -->
<!--                             <div class="com_ta"  style="min-width:1360px;"> -->
<!--                                 <table> -->
<%--                                     <colgroup> --%>
<%--                                         <col width="132"/> --%>
<%--                                         <col width="54"/> --%>
<%--                                         <col width=""/> --%>
<%--                                         <col width="132"/> --%>
<%--                                         <col width="132"/> --%>
<%--                                         <col width="132"/> --%>
<%--                                         <col width="132"/> --%>
<%--                                         <col width="132"/> --%>
<%--                                         <col width="132"/> --%>
<%--                                         <col width="132"/> --%>
<%--                                         <col width="149"/> --%>
<%--                                     </colgroup> --%>
<!--                                     <tr> -->
<!--                                         <th colspan="3">수익합계</th> -->
<!--                                         <td class="ri" style="padding:0 .6em;"><span id="CARR_AM_1">0</span></td> -->
<!--                                         <td class="ri" style="padding:0 .6em;"><span id="CF_AM_1">0</span></td> -->
<!--                                         <td class="ri" style="padding:0 .6em;"><span id="ADD_AM0_1">0</span></td> -->
<!--                                         <td class="ri" style="padding:0 .6em;"><span id="ADD_AM1_1">0</span></td> -->
<!--                                         <td class="ri" style="padding:0 .6em;"><span id="CALC_AM_1">0</span></td> -->
<!--                                         <td class="ri" style="padding:0 .6em;"><span id="ACCT_AM_1">0</span></td> -->
<!--                                         <td class="ri" style="padding:0 .6em;"><span id="SUB_AM_1">0</span></td> -->
<!--                                         <td class="ri" style="padding:0 2em;"><span id="SUB_RATE_1">0</span></td> -->
<!--                                     </tr> -->
<!--                                     <tr> -->
<!--                                         <th colspan="3">지출합계</th> -->
<!--                                        <td class="ri" style="padding:0 .6em;"><span id="CARR_AM_2">0</span></td> -->
<!--                                         <td class="ri" style="padding:0 .6em;"><span id="CF_AM_2">0</span></td> -->
<!--                                         <td class="ri" style="padding:0 .6em;"><span id="ADD_AM0_2">0</span></td> -->
<!--                                         <td class="ri" style="padding:0 .6em;"><span id="ADD_AM1_2">0</span></td> -->
<!--                                         <td class="ri" style="padding:0 .6em;"><span id="CALC_AM_2">0</span></td> -->
<!--                                         <td class="ri" style="padding:0 .6em;"><span id="ACCT_AM_2">0</span></td> -->
<!--                                         <td class="ri" style="padding:0 .6em;"><span id="SUB_AM_2">0</span></td> -->
<!--                                         <td class="ri" style="padding:0 2em;"><span id="SUB_RATE_2">0</span></td> -->
<!--                                     </tr> -->
<!--                                     <tr> -->
<!--                                         <th colspan="3">잔액</th> -->
<!--                                        <td class="ri" style="padding:0 .6em;"><span id="CARR_AM_3">0</span></td> -->
<!--                                         <td class="ri" style="padding:0 .6em;"><span id="CF_AM_3">0</span></td> -->
<!--                                         <td class="ri" style="padding:0 .6em;"><span id="ADD_AM0_3">0</span></td> -->
<!--                                         <td class="ri" style="padding:0 .6em;"><span id="ADD_AM1_3">0</span></td> -->
<!--                                         <td class="ri" style="padding:0 .6em;"><span id="CALC_AM_3">0</span></td> -->
<!--                                         <td class="ri" style="padding:0 .6em;"><span id="ACCT_AM_3">0</span></td> -->
<!--                                         <td class="ri" style="padding:0 .6em;"><span id="SUB_AM_3">0</span></td> -->
<!--                                         <td class="ri" style="padding:0 2em;"><span id="SUB_RATE_3">0</span></td> -->
<!--                                     </tr> -->
<!--                                 </table> -->
<!--                             </div>                                       -->

                        </div>
<!-- //contents -->                                
                    </div><!-- //sub_contents_wrap -->
                    
                    
<div id="dialog-form-standard" style="display:none">
<div class="pop_wrap_dir" >
    <div class="pop_head">
        <h1></h1>
        <a href="#n" class="clo popClose"><img src="<c:url value='/Images/btn/btn_pop_clo02.png' />" alt="" /></a>
    </div>
    <div class="pop_con">       
        <!-- 예산검색 -->     
        <div class="top_box" style="overflow:hidden;display:none;" id="Budget_Search">
            <dl class="">
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
            <dl class="">
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
        </div>
                                        
        <div class="com_ta2 mt10 ova_sc_all cursor_p"  style="height:340px;" id="dialog-form-standard-bind">
        </div>
        

    </div><!-- //pop_con -->
</div><!-- //pop_wrap -->
</div>

<div id="dialog-form-background_dir" style="display:none;"></div>	
