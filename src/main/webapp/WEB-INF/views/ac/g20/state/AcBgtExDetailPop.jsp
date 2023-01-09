<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="main.web.BizboxAMessage"%>

<%
 /**
  * @Class Name : AcBgtExDetailPop.jsp
  * @Description : 예산집행조회
  * @Modification Information
  *
  */
%>
<script type="text/javascript">
var BudgetObj = {};

var DATE_FROM = '${param.DATE_FROM}' ;
var DATE_TO = '${param.DATE_TO}' ;
$(function(){
// 	budgetUtils.setDatepicke();
// 	        
    $("#btnExcel").click(function(){
//         $("#EXCEL_YN").val("Y" );
//         BudgetObj.seachListExcel();
        $("#grid").data("kendoGrid").saveAsExcel();
    });
    
    $("#searchButton").click(function(){
        BudgetObj.search();
    });
    
    //시작날짜
    $("#DATE_FROM").kendoDatePicker({
        format: "yyyy-MM-dd",
        culture : "ko-KR"           
    });
    
    //종료날짜
    $("#DATE_TO").kendoDatePicker({
        format: "yyyy-MM-dd",
        culture : "ko-KR"
    });
    
    $("#DATE_FROM").data("kendoDatePicker").value(DATE_FROM);
    $("#DATE_TO").data("kendoDatePicker").value(DATE_TO);
    BudgetObj.search();
    
//     BudgetObj.init();  
});

// BudgetObj.search = function(){
// 	$("#EXCEL_YN").val("N" );
//     $("form#searchForm").submit();
// };



BudgetObj.search = function(){
	
	modal(true);
// 	var formData = acG20State.getFormData();
    var opt = {  
            type:"post",
            url: '<c:url value="/Ac/G20/State/getErpBgtExDetailList.do" />' ,
            datatype:"json",        
//             data: tblParam,
            async   : false,
            data: $("#searchForm").serialize(),
            success:function(data){     
            	if(data.selectList){
            		//grid table
                    $("#grid").kendoGrid({ 
                    	dataSource: data.selectList,
                    	excel: {
                    		filterable:true,
                    		allPages: true,
                    		fileName: "<%=BizboxAMessage.getMessage("TX000017828","예산상세리스트")%>.xlsx"
                    		},                	
                        columns: [                    
                            {
                                field:"GISU_DT", title:"<%=BizboxAMessage.getMessage("TX000000506","결의일자")%>", 
                                width:60,
                                headerAttributes: {style: "text-align:center;"}, 
                                attributes: {style: "text-align:left;"},
                            },
                            {
                                field:"GISU_SQ", 
                                title:"<%=BizboxAMessage.getMessage("TX000005100","결의번호")%>",
                                width:54,
                                headerAttributes: {style: "text-align:center;"}, 
                                attributes: {style: "text-align:center;"},
                            },
                            {
                                field:"MGT_NM",
                                title : "<%=BizboxAMessage.getMessage("TX000000519","프로젝트")%>", 
                                width:110,
                                headerAttributes: {style: "text-align:center;"}, 
                                attributes: {style: "text-align:left;"},
                            },
                            {
                            	field:"DOCU_FG_TEXT",
                            	title : "<%=BizboxAMessage.getMessage("TX000003616","결의구분")%>", 
                            	width:90, 
                            	headerAttributes: {style: "text-align:center;"}, 
                            	attributes: {style: "text-align:left;"},
                            },
                            {
                            	template : function(data){
                            		return fnGetCurrencyCode(data.UNIT_AM);
                            	},
                            	field:"UNIT_AM",
                            	title : "<%=BizboxAMessage.getMessage("TX000000552","금액")%>", 
                            	width:100, 
                            	headerAttributes: {style: "text-align:center;"}, 
                            	attributes: {style: "text-align:right;"},
                            },
                            {
                            	field:"RMK_DC",
                            	title : "<%=BizboxAMessage.getMessage("TX000000604","적요")%>", 
                            	width:132, 
                            	headerAttributes: {style: "text-align:center;"}, 
                            	attributes: {style: "text-align:left;"},
                            },
                            {
                            	field:"ISU_NUM",
                            	title : "<%=BizboxAMessage.getMessage("TX000000565","전표번호")%>", 
                            	width:100, 
                            	headerAttributes: {style: "text-align:center;"}, 
                            	attributes: {style: "text-align:center;"},
                            },
                            {
                                field:"DOC_NUMBER", 
                                title : "<%=BizboxAMessage.getMessage("TX000000663","문서번호")%>", 
                                width:132,
                                headerAttributes: {style: "text-align:center;"}, 
                                attributes: {style: "text-align:left;"},
                            },
                            {
                                field:"DOC_DRAFTER", 
                                title : "<%=BizboxAMessage.getMessage("TX000000499","기안자")%>", 
                                width:70,
                                headerAttributes: {style: "text-align:center;"}, 
                                attributes: {style: "text-align:left;"},
                            },
                            {
                                field:"DOC_TITLE", 
                                title : "<%=BizboxAMessage.getMessage("TX000003457","문서제목")%>", 
                                width:132,
                                headerAttributes: {style: "text-align:center;"}, 
                                attributes: {style: "text-align:left;"},
                            },
                            {
                                field:"DOC_STATUS_NM", 
                                title : "<%=BizboxAMessage.getMessage("TX000000490","결재상태")%>", 
                                width:70,
                                headerAttributes: {style: "text-align:center;"}, 
                                attributes: {style: "text-align:left;"},
                            }
                        ],
                        selectable: "single",
                        groupable: false,
                        columnMenu:false,
                        editable: false,
                        sortable: true,
                        pageable: false,
                        height:353,
                    });
            	}else{
            		alert("<%=BizboxAMessage.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요")%>");
            	}

                modal(false);
            },
    	    error: function (request,status,error) {
    	    	alert("<%=BizboxAMessage.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요")%>"+"\n"+"<%=BizboxAMessage.getMessage("TX000009711","오류 메시지 : {0}")%>".replace("{0}",error)+"\n");
    	    	modal(false);
        	}
    };
    $.ajax(opt);    
//     modal_bg(false);
};

function fnGetCurrencyCode(value, defaultVal) {
    value = '' + value || '';
    value = '' + value.split('.')[0];
    value = value.replace(/[^0-9\-]/g, '') || (defaultVal != undefined ? defaultVal : '0');
    var returnVal = value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    return returnVal;
}

BudgetObj.init = function(){	
	//팝업 리사이즈
	var strWidth = $('.pop_wrap').outerWidth() + (window.outerWidth - window.innerWidth);
	var strHeight = $('.pop_wrap').outerHeight() + (window.outerHeight - window.innerHeight);
	
	$('.pop_wrap').css("overflow","auto");
	try{
		var childWindow = window.parent;
		childWindow.resizeTo(strWidth, strHeight);	
	}catch(exception){
		console.log('window resizing cat not run dev mode.');
	}
};

function modal(state){
	if(state){		
		$("#dialog-form-background_dir").show();
		var img = $("<img>").attr("id", "g20-ajax-img").attr("src", _g_contextPath_ + "/Images/ico/loading.gif")
		.css("position", "absolute").css("top", "50%").css("left", "50%").css("margin-top", "-5").css("lefmargin-leftt", "-5").css("zIndex", "100000");
		$("body").append(img);  
	}
	else{
		$("#dialog-form-background_dir").hide(); 
		$("#g20-ajax-img").remove();
	}
};
// BudgetObj.seachListExcel = function(){
//     document.searchForm.action = "<c:url value="/erp/g20/budget/ErpG20BudgetDetail.do" />";
//     document.searchForm.submit();
// };


</script>
<form action='<c:url value="/Ac/G20/State/AcBgtExDetailPop.do"/>'  method="post" id="searchForm" name="searchForm">
    <input type="hidden" id="CO_CD" name="CO_CD" value="${param.CO_CD }"/>
    <input type="hidden" id="DIV_CD" name="DIV_CD" value="${param.DIV_CD }">
    <input type="hidden" id="DIV_CDS" name="DIV_CDS" value="${param.DIV_CDS }">
    <input type="hidden" id="MGT_CD" name="MGT_CD" value="${param.MGT_CD }">
    <input type="hidden" id="MGT_CDS" name="MGT_CDS" value="${param.MGT_CDS }">
    <input type="hidden" id="BGT_CD" name="BGT_CD" value="${param.BGT_CD }">
    <input type="hidden" id="BGT_NM" name="BGT_NM" value="${param.BGT_NM }">
    <input type="hidden" id="BOTTOM_CD" name="BOTTOM_CD" value="${param.BOTTOM_CD }">
    <input type="hidden" id="BOTTOM_CDS" name="BOTTOM_CDS" value="${param.BOTTOM_CDS }">
    <input type="hidden" id="FR_DT" name="FR_DT" value="${param.FR_DT }">
    <input type="hidden" id="TO_DT" name="TO_DT" value="${param.TO_DT }">
    <input type="hidden" id="GISU" name="GISU" value="${param.GISU }"/>
    <input type="hidden" id="EMP_CD" name="EMP_CD" value="${param.EMP_CD }"/>
    <input type="hidden" id="searchYN" name="searchYN" value=""/>
    <input type="hidden" id="EXCEL_YN" name="EXCEL_YN" value=""/>

<div class="pop_wrap">
    <div class="pop_head">
        <h1><%=BizboxAMessage.getMessage("TX000005099","예산집행조회")%></h1>
        <a href="javascript:window.close();" class="clo"><img src="<c:url value='/Images/btn/btn_pop_clo01.png' />" alt="" /></a>
    </div>      
    
<!--     <div class="btn_top"> -->
<!--         <div class="controll_btn" style="padding:0px; float:right;">             -->
<!--                 <button type="button" id="btnExcel" >Excel 다운로드</button> -->
<!--         </div> -->
<!--     </div>     -->
    
    <div class="pop_con">   
        <div class="top_box" style="overflow:hidden;">
            <dl class="dl2">
                <dt class="mr0">
                     <input id="DATE_FROM"  name="DATE_FROM" class="dpWid"/>  ~ <input id="DATE_TO"   name="DATE_TO" class="dpWid"/>                          
                     <input type="button" id="searchButton" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" />
                </dt>
            </dl>
        </div>
                        <!-- 컨트롤버튼 -->                      
                        <div>
                            <div id="" class="controll_btn">
                                <button type="button" id="btnExcel" ><%=BizboxAMessage.getMessage("TX000016598","Excel 다운로드")%></button>
                            </div>
                        </div>     
<!--         <div class="com_ta2 mt15 ova_sc_all cursor_p" style="height:370px;"> -->
        <div class="g20_date_grid">
                   <div id="grid" class="data_grid" style="border-width:1px 0 0 0;"></div>  
<!--                    <table style="min-width:1500px;" > -->
<%--                       <col width="70" /> --%>
<%--                       <col width="60" /> --%>
<%--                       <col width="110" /> --%>
<%--                       <col width="120" /> --%>
<%--                       <col width="100" /> --%>
<%--                       <col width="" /> --%>
<%--                       <col width="120" /> --%>
<%--                       <col width="110" /> --%>
<%--                       <col width="70" /> --%>
<%--                       <col width="80" /> --%>
<%--                       <col width="350" /> --%>
<%--                       <col width="60" /> --%>
<!--                       <tr class="signTable_th"> -->
<!--                          <td>결의일자</td> -->
<!--                          <td>결의번호</td> -->
<!--                          <td>프로젝트</td> -->
<!--                          <td>결의구분</td> -->
<!--                          <td>금액</td> -->
<!--                          <td>적요</td> -->
<!--                          <td>전표번호</td> -->
<!--                          <td>문서번호</td> -->
<!--                          <td>기안자</td> -->
<!--                          <td>기안일</td> -->
<!--                          <td>문서제목</td> -->
<!--                          <td>결재상태</td> -->
<!--                       </tr> -->
<%--                       <c:if test="${fn:length(selectList) == 0}"> --%>
<!--                       <tr> -->
<!--                           <td align="center" colspan="12">검색결과가 없습니다.</td> -->
<!--                       </tr> -->
<%--                 </c:if> --%>
<%--                        <c:forEach var="list" items="${selectList }"> --%>
<%--                        <tr class="signTable_td" id="${list.CO_CD }${list.GISU_DT }${list.GISU_SQ }${list.BG_SQ}"> --%>
<%--                               <td><span>${list.GISU_DT }&nbsp;</span></td> --%>
<%--                               <td><fmt:formatNumber value="${list.GISU_SQ }" pattern="00000"/>&nbsp;</td> --%>
<%--                               <td class="left">${list.MGT_NM }</td> --%>
<%--                               <td class="left">${list.DOCU_FG_TEXT }</td> --%>
<%--                               <td class="right"><fmt:formatNumber type="currency"  value="${list.UNIT_AM}" currencySymbol="" />&nbsp;</td> --%>
<%--                               <td class="ar pr5">${list.UNIT_AM}&nbsp;</td> --%>
<%--                               <td class="left">${list.RMK_DC }</td> --%>
<%--                               <td>${list.ISU_DT } - <fmt:formatNumber value="${list.ISU_SQ }" pattern="00000"/>&nbsp;</td> --%>
<%--                               <td class="left ">${list.DOC_NUMBER }</td> --%>
<%--                               <td class="">${list.DOC_DRAFTER }</td> --%>
<%--                               <td class="">${list.DOC_WRITE }</td> --%>
<%--                               <td class="left ">${list.DOC_TITLE }</td> --%>
<%--                               <td class="">${list.DOC_STATUS }</td> --%>
               
<!--                        </tr> -->
<%--                        </c:forEach> --%>
<!--                     </table> -->
<!--                     <table> -->
<%--                       <col width="70" /> --%>
<%--                       <col width="60" /> --%>
<%--                       <col width="110" /> --%>
<%--                       <col width="120" /> --%>
<%--                       <col width="100" /> --%>
<%--                       <col width="" /> --%>
<%--                       <col width="120" /> --%>
<%--                       <col width="110" /> --%>
<%--                       <col width="70" /> --%>
<%--                       <col width="80" /> --%>
<%--                       <col width="350" /> --%>
<%--                       <col width="60" /> --%>
<!--                       <tr> -->
<!--                           <th colspan="4">합계</th> -->
<%--                           <td class="ri" style="padding:0 .6em;"><span id="TOTAL_UNIT_AM">${total_UNIT_AM }</span></td> --%>
<!--                           <td></td> -->
<!--                           <td></td> -->
<!--                           <td></td> -->
<!--                           <td></td> -->
<!--                           <td></td> -->
<!--                           <td></td> -->
<!--                           <td></td> -->
<!--                       </tr> -->
<!--                   </table> -->
        </div>           
<!--         <div class="com_ta"  style="min-width:1500px;"> -->

<!--         </div>                                                    -->
    </div>             
</div><!-- //pop_con -->    
<div id="dialog-form-background_dir" style="display:none;"></div>        
</form>