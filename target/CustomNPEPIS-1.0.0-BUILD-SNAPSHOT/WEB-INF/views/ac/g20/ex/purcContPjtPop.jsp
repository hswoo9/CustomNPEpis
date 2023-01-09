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

var divId = "${param.divId}" || "";
var GISU_DT = "${param.GISU_DT}" || "";
var docu_fg = "${param.docu_fg}" || "";

$(function(){

	fnGetPurcContPjtList();
	
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


function fnGetPurcContPjtList() {
	
    var tblParam = {};
    tblParam.GISU_DT      = GISU_DT;
    tblParam.purcContId = purcContId;
    var resultData = {};
	var opt = {
            url     : _g_contextPath_ + "/Ac/G20/Ex/getPurcContPjtList.do",
            stateFn : modal,
            async   : true,
            data    : tblParam,
            successFn : function(data){
            	var selectList = data.selectList;

            	var html = "";
            	if(selectList.length == 0){
            		html += "<tr><td colspan='3'><%=BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다")%></td></tr>";
            	}else{
            		for(var i = 0, max = selectList.length; max != null && i< max ; i++){
            			html += "<tr id='"+ selectList[i].purc_req_h_id +"' abdocu_no='"+ selectList[i].abdocu_no +"'>";
            			html += "<td>" + selectList[i].erp_div_nm + "</td>";
            			html += "<td>" + selectList[i].mgt_nm + "</td>";
            			html += "</tr>";
                	}
            	}
            	
            	var table = $("#ReferConfer-table");
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
				 var purc_req_h_id = $(this).attr("id");
				 var abdocu_no = $(this).attr("abdocu_no");
				 fnPurcContPaySet(purc_req_h_id, abdocu_no);
			 }
		});
	}
}


/**
 * 대금지급 결의서 저장
 */
function fnPurcContPaySet(purc_req_h_id, abdocu_no_reffer){

	var tblParam = {}
	tblParam.purc_cont_id = purcContId ;
	tblParam.purc_req_h_id = purc_req_h_id ;
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
            url     : _g_contextPath_ + "/Ac/G20/Ex/insertPurcContPay.do",
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
            		obj.purcContId = purcContId;
            		obj.purcContPayId = data.purcContPayId;
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

function btnCancel(){
	acLayerPopClose(divId);
}

</script>

</head>
<body>

<div class="pop_wrap_dir" style="width:500px;" id="purcContPjtPop" >
    <div class="pop_head">
        <h1>구매계약 프로젝트 리스트</h1>
        <a href="#n" class="clo"><img src="<c:url value='/Images/btn/btn_pop_clo02.png' />" alt="" onclick="btnCancel();" /></a>
    </div>
    <div class="pop_con">   
    
        <div class="com_ta2 mt14 scroll_y_on bg_lightgray" style="height:300px;" >
            <table border="0">
                <colgroup>
                    <col width="200" />
                    <col width="200" />
                </colgroup>
                <thead>
                    <tr>
                        <th>예산회계단위</th>
                        <th>프로젝트</th>
                    </tr>
                </thead>                  
                <tbody id="ReferConfer-table">
                </tbody>  
            </table>
        </div>  
    </div><!-- //pop_con -->

</div><!-- //pop_wrap -->   
<div id="dialog-form-background_dir" style="display:none;"></div>	
</body>
