<%@ page import="org.apache.xmlbeans.impl.xb.xsdschema.IncludeDocument.Include"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="main.web.BizboxAMessage"%>
<head>
<title><%=BizboxAMessage.getMessage("TX000009906","참조 품의서")%> </title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript">

var callBack = "${param.callback}" || "";
var CO_CD = "${param.CO_CD}" || "";
var divId = "${param.divId}" || "";
var GISU_DT = "${param.GISU_DT}" || "";
var FROM_DT = "${param.FROM_DT}" || "";
var TO_DT = "${param.TO_DT}" || "";
var GR_FG = "${param.GR_FG}" || "";
var docu_fg = "${param.docu_fg}" || "";

$(function(){

// 	$(".controll_btn button").kendoButton();
	
	var GR_FG_TEXT = "<%=BizboxAMessage.getMessage("TX000009905","지출 품의서 리스트")%>";
	if(GR_FG == "1"){
		GR_FG_TEXT = "<%=BizboxAMessage.getMessage("TX000009904","수입 품의서 리스트")%>";
	}

    //시작날짜
    var start = $("#sGisuDt").kendoDatePicker({
        format: "yyyy-MM-dd",
        culture : "ko-KR",
        change : function(e){}
    }).data("kendoDatePicker");
    
    //종료날짜
    var end = $("#eGisuDt").kendoDatePicker({
        format: "yyyy-MM-dd",
        culture : "ko-KR",
        change : function(e){}
    }).data("kendoDatePicker");	
	
	$("#isAllView").kendoComboBox({
        dataSource : {
			data : [ { name: "<%=BizboxAMessage.getMessage("TX000000862","전체")%>", id:"" },     
			         { name: "<%=BizboxAMessage.getMessage("TX000006807","있음")%>", id:"001" },     
			         { name: "<%=BizboxAMessage.getMessage("TX000001232","없음")%>", id:"002" } 
			        ]
        },
		dataTextField: "name",
		dataValueField: "id",
		index: 1,
		change : function(e){
		}
	});
	
	$("#ReferConferPop .pop_head h1").html(GR_FG_TEXT);
	fnGetReferConferList();
	
});

/*  [공통함수] 통화 코드 적용 
일천 단위에 통화코드 ','적용.
Params /
valeu      : 통화 코드 적용 밸류
-----------------------------------------------------*/
function cmFnc_GetCurrencyCode(value, defaultVal) {
    value = '' + value || '';
    value = '' + value.split('.')[0];
    value = value.replace(/[^0-9\-]/g, '') || (defaultVal != undefined ? defaultVal : '0');
    var returnVal = value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    return returnVal;
}


function fnGetReferConferList() {
	
	var isAllDocView =  $(":input[name=isAllDocView]:checked").val() || "0"; // 전체문서보기
	var fromDt = ( $('#sGisuDt').val() || '').replace(/-/g, '');
	var toDt = ( $('#eGisuDt').val() || '').replace(/-/g, '');
	
    var tblParam = {};
    tblParam.isAllDocView = isAllDocView;
    tblParam.GISU_DT      = GISU_DT; 
    tblParam.FROM_DT      = fromDt; 
    tblParam.TO_DT        = toDt; 
    tblParam.GR_FG        = GR_FG	;
    tblParam.sGisuDt      = $("#sGisuDt").val()	;
    tblParam.eGisuDt      = $("#eGisuDt").val()	;
    tblParam.isAllView    = $("#isAllView").val();
    tblParam.searchText   = $("#searchText").val();
    tblParam.CO_CD        = CO_CD;
    var resultData = {};
	var opt = {
            url     : _g_contextPath_ + "/Ac/G20/Ex/getReferConfer.do",
            stateFn : modal,
            async   : true,
            data    : tblParam,
            successFn : function(data){
            	var selectList = data.selectList;

            	var html = "";
            	if(selectList.length == 0){
            		html += "<tr><td colspan='10'><%=BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다")%></td></tr>";
            	}else{
            		for(var i = 0, max = selectList.length; max != null && i< max ; i++){
            			html += "<tr id='"+ selectList[i].ABDOCU_B_NO +"' abdocu_no='"+ selectList[i].ABDOCU_NO +"'>";
            			html += "<td>" + selectList[i].DOCU_FG_TEXT + "</td>";
            			html += "<td>" + selectList[i].DOCNUMBER + "</td>";
            			html += "<td>" + selectList[i].ERP_GISU_DT + "</td>";
            			html += "<td>" + selectList[i].USERNAME + "</td>";
            			html += "<td>" + selectList[i].MGT_NM + "</td>";
            			html += "<td>" + selectList[i].ABGT_NM + "</td>";
            			html += "<td>" + cmFnc_GetCurrencyCode(selectList[i].OPEN_AM) + "</td>";
            			html += "<td>" + cmFnc_GetCurrencyCode(selectList[i].APPLY_AM) + "</td>";
            			html += "<td>" + cmFnc_GetCurrencyCode(selectList[i].LEFT_AM) + "</td>";
            			if(selectList[i].BUTTON == "rollBack"){
            				html += "<td><input type='button' onclick='returnConferBudgetRollBack(this);' value='<%=BizboxAMessage.getMessage("TX000009903","환원취소")%>'/> </td>";	
            			}else{
            				html += "<td><input type='button' onclick='returnConferBudget(this);' value='<%=BizboxAMessage.getMessage("TX000009902","환원")%>'/> </td>";	
            			}
            			
            			html += "</tr>";
                	}	
            	}
            	
            	var table = $("#ReferConfer-table");
//             	alert(html);
            	table.html(html);
            	listLoadComplete();
            },
            error: function (request,status,error) {
    	    	alert("<%=BizboxAMessage.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요")%>.\n errorCode :"+request.responseText+"\n");
        	}
    }; 
    acUtil.ajax.call(opt, resultData);

}

function listLoadComplete(){
	if($("#ReferConfer-table tr").length && $("#ReferConfer-table tr").eq(0).attr('id')){
		$("#ReferConfer-table tr").on({
			 dblclick: function(){
				 var abdocu_no = $(this).attr("abdocu_no");
				 fnReferConferSet(abdocu_no);
			 }
		});
	}
}


/**
 * 참조 품의 결의서 저장
 */
function fnReferConferSet(abdocu_no_reffer){

	var tblParam = {}
	tblParam.abdocu_no_reffer = abdocu_no_reffer ;
	tblParam.docu_fg          = docu_fg ;
	tblParam.docu_fg_text     = abdocuInfo.docu_fg_text ;
	tblParam.erp_gisu_dt      = GISU_DT ;
	tblParam.erp_dept_cd      = $("#txtDEPT_NM").attr("CODE");
	tblParam.erp_dept_nm      = $("#txtDEPT_NM").val();
	tblParam.erp_emp_cd       = $("#txtKOR_NM").attr("CODE");
	tblParam.erp_emp_nm       = $("#txtKOR_NM").val();
	
	var resultData = {};
	/*ajax 호출할 파라미터*/
    var opt = {
            url     : _g_contextPath_ + "/Ac/G20/Ex/insertReferConfer.do",
            stateFn : modal,
            async   : false,
            data    : tblParam,
            successFn : function(data){
            	if(data.result){
            		var abdocu_no = data.result.abdocu_no;
            		var obj = {};
            		obj.abdocu_no = abdocu_no;
            		obj.mode      = "1";
            		obj.focus     = "txt_BUDGET_LIST";
            		obj.template_key = template_key;
            		obj.abdocu_no_reffer = abdocu_no_reffer;
					fnReLoad(obj);
            	}else{
            		alert("<%=BizboxAMessage.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요")%>");
            	}
            },
    	    error: function (request,status,error) {
    	    	
        	}
    };

    acUtil.ajax.call(opt, resultData);
}

/**
 * 
 *  예산환원 
 *  
 */
function returnConferBudget(e){
	
	var eventEle = $(e);
	var abdocu_b_no = eventEle.parents("tr").attr("id");
	var isAllDocView = $("#isAllDocView").attr("checked") ? "1" : "0";  // 전체문서보기
	
    var tblParam = {};
    tblParam.isAllDocView = isAllDocView;
    tblParam.GISU_DT      = GISU_DT;
    tblParam.FROM_DT      = FROM_DT;
    tblParam.TO_DT        = TO_DT;
    tblParam.GR_FG        = GR_FG	;
    tblParam.CO_CD        = CO_CD;
    tblParam.ABDOCU_B_NO  = abdocu_b_no;
    tblParam.isAllView    = $("#isAllView").val();
	if(confirm("<%=BizboxAMessage.getMessage("TX000011196","예산환원 하시겠습니까?")%>")){
		var opt = {
	            url : _g_contextPath_ + "/Ac/G20/Ex/returnConferBudget.do",
	            stateFn : modal,
	            async : false,
	            data : tblParam,
	            successFn : function(result){
	            	if(result){
	            		if(result.result =="OK"){
	            			fnGetReferConferList();	
	            		}
	            		else if(result.result =="ING"){
	                		alert("<%=BizboxAMessage.getMessage("TX000009900","결재중인 참조품의결의서가 존재합니다. 결재완료 후 환원처리해야합니다")%>");
	                	}
	            		else{
	            			alert("<%=BizboxAMessage.getMessage("TX000008904","삭제 처리중 오류가 발생하였습니다")%>");
	            		}
	            	}else{
	            		alert("<%=BizboxAMessage.getMessage("TX000008904","삭제 처리중 오류가 발생하였습니다")%>");
	            	}
	            },
	            failFn: function (request,status,error) {
	    	    	alert("<%=BizboxAMessage.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요")%> .\n errorCode :"+error+"\n");	    	    
	        	}
	    };
		
	    acUtil.ajax.call(opt);
	}
    
};

/**
 * 
 *  예산환원 취소 
 *  
 */
function returnConferBudgetRollBack(e){
	var eventEle = $(e);
	var abdocu_b_no = eventEle.parents("tr").attr("id");

    var tblParam = {};
    tblParam.ABDOCU_B_NO  = abdocu_b_no;
    
	if(confirm("<%=BizboxAMessage.getMessage("TX000011195","예산환원취소 하시겠습니까?")%>")){
    var opt = {
            url : _g_contextPath_ + "/Ac/G20/Ex/returnConferBudgetRollBack.do",
            stateFn : modal,
            async : false,
            data : tblParam,
            successFn : function(result){
            	if(result){
            		if(result.result =="OK"){
            			fnGetReferConferList();	
            		}
            		else{
            			alert("<%=BizboxAMessage.getMessage("TX000009899","처리중 오류가 발생하였습니다")%>.");
            		}
            	}else{
            		alert("<%=BizboxAMessage.getMessage("TX000009899","처리중 오류가 발생하였습니다")%>.");
            	}
            },
            failFn: function (request,status,error) {
    	    	alert("<%=BizboxAMessage.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요")%> .\n errorCode :"+error+"\n");	    	    
        	}
    };
	
    acUtil.ajax.call(opt);
	}
};

function btnCancel(){
	acLayerPopClose(divId);	
}

function btnOk(){
	parent.eval(callBack)();
	acLayerPopClose(divId);	
}
</script>

</head>
<body>

<div class="pop_wrap_dir" style="width:970px;" id="ReferConferPop" >
    <div class="pop_head">
        <h1><%=BizboxAMessage.getMessage("TX000009898","참조 품의서 리스트")%></h1>
        <a href="#n" class="clo"><img src="<c:url value='/Images/btn/btn_pop_clo02.png' />" alt="" onclick="btnCancel();" /></a>
    </div>
    <div class="pop_con">   
    
        <div class="top_box">
            <dl class="">
                <dt><%=BizboxAMessage.getMessage("TX000000696","기간")%></dt>
                <dd><input style="width:100px;" id="sGisuDt" /> ~ <input style="width:100px;" id="eGisuDt" /></dd>
                <dt><%=BizboxAMessage.getMessage("TX000000399","검색어")%></dt>
                <dd><input type="text" style="width:120px;" id="searchText" /></dd>
                <dt><%=BizboxAMessage.getMessage("TX000009897","잔액여부")%></dt>
                <dd><input style="width:120px;" id="isAllView" /></dd>
                <dd><input type="button" id="searchButton" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" onclick="fnGetReferConferList();"/></dd>
<!--                 <dt class=""> -->
<%--                         <c:if test= '${spendAuth ==true}'> --%>
<!--                         <input type="checkbox" onclick="abdocu.getReferConferReBind()" name="isAllDocView"  id="isAllDocView"  class="k-checkbox"  value="1" style="margin-left: 20px;"/>  -->
<!--                         <label class="k-checkbox-label radioSel" for="isAllDocView" style="top: 0px;margin:0 25px 0 10px;">전체문서보기</label> -->
<%--                         </c:if> --%>
<!--                 </dt> -->
            </dl>
        </div>        

        <div class="com_ta2 mt14 scroll_y_on bg_lightgray" style="height:300px;" >
            <table border="0">
                <colgroup>
                    <col width="80" />
                    <col width="100" />
                    <col width="80" />
                    <col width="60" />
                    <col width="100" />
                    <col width="100" />
                    <col width="100" />
                    <col width="100" />
                    <col width="100" />
                    <col width="100" />
                </colgroup>
                <thead>
                    <tr>
                        <th><%=BizboxAMessage.getMessage("TX000000214","구분")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000000491","품의번호")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000004251","품의일자")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000000499","기안자")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000000519","프로젝트")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000003622","예산과목")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000005220","품의금액")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000003874","사용금액")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000005469","잔액")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000011194","예산환원")%></th>
                    </tr>
                </thead>                  
                <tbody id="ReferConfer-table">
                </tbody>  
            </table>
        </div>  
    </div><!-- //pop_con -->

<!--     <div class="pop_foot">
        <div class="btn_cen pt12">
            <input type="button" onclick="btnOk();" value="확인" />
        </div>
    </div>//pop_foot -->

</div><!-- //pop_wrap -->   
<div id="dialog-form-background_dir" style="display:none;"></div>	
</body>
