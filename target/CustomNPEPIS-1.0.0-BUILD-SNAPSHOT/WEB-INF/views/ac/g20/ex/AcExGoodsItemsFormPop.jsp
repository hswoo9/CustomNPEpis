<%@page import="org.apache.xmlbeans.impl.xb.xsdschema.IncludeDocument.Include"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="main.web.BizboxAMessage"%>
<head>
<title><%=BizboxAMessage.getMessage("TX000009890","일반명세서 등록")%></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src='<c:url value="/js/ac/g20/acG20Items.js"></c:url>'></script>
<script type="text/javascript">

var callBack = "${param.callback}" || "";
var abdocu_no = "${param.abdocu_no}" || "";
var erp_co_cd = "${param.erp_co_cd}" || "";
var divId = "${param.divId}" || "";

$(function(){
	$(".controll_btn button").kendoButton();
	fnGetAbdocuD_List('txt_ITEM_NM' + "1");
});

function btnCancel(){
	acLayerPopClose(divId);	
}

function btnOk(){
// 	var obj = abdocu_d.Validation();
	parent.eval(callBack)();
	acLayerPopClose(divId);	
}
</script>

</head>
<body>
<div class="pop_wrap_dir" style="width:828px;" id="ItemsFormPop" >
    <div class="pop_head">
        <h1><%=BizboxAMessage.getMessage("TX000009889","물품명세 등록")%></h1>
        <a href="#n" class="clo"><img src="<c:url value='/Images/btn/btn_pop_clo02.png' />" alt="" onclick="btnCancel();" /></a>
    </div>
    <div class="pop_con">   
        
        <div class="com_ta2">
            <table border="0">
                <colgroup>                    
                    <col width="150" />
                    <col width="98" />
                    <col width="70"/>
                    <col width="70"/>
                    <col width="85"/>
                    <col width="85"/>
                    <col width="106"/>
                    <col width=""/>
                </colgroup>
                <thead>
                    <tr>
                        <th><%=BizboxAMessage.getMessage("TX000000152","명칭")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000000467","규격")%>/<%=BizboxAMessage.getMessage("TX000001067","용량")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000000466","단위")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000004231","수량")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000000468","단가")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000000552","금액")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000000644","비고")%></th>
                        <th></th>
                    </tr>
                </thead>
            </table>
        </div>  

        <div class="com_ta2 ova_sc hover_no" style="height:250px;" id="goodsItems">
            <table border="0" id="goodsItems-Table">
                <colgroup>
                    <col width="150" />
                    <col width="98" />
                    <col width="70"/>
                    <col width="70"/>
                    <col width="85"/>
                    <col width="85"/>
                    <col width="106"/>
                    <col width=""/>
                </colgroup>
                <tbody>
                </tbody>
            </table>
        </div>  

        <div class="top_box mt15" style="overflow:hidden;">
            <dl class="dl2">
                <dt><%=BizboxAMessage.getMessage("TX000000518","합계")%> : </dt>
                <dd class="mt20"><%=BizboxAMessage.getMessage("TX000004231","수량")%> <span class="colB" id="TOTAL_COUNT">0</span></dd>
                <dd class="text_gray mt20">|</dd>
                <dd class="mt20"><%=BizboxAMessage.getMessage("TX000000552","금액")%> <span class="colB" id="TOTAL_AM" >0</span></dd>
            </dl>
        </div>

    </div><!-- //pop_con -->

    <div class="pop_foot">
        <div class="btn_cen pt12">
            <input type="button" onclick="btnOk();" value="<%=BizboxAMessage.getMessage("TX000000078","확인")%>" />
<!--             <input type="button" onclick="btnCancel();" class="gray_btn" value="취소" /> -->
        </div>
    </div><!-- //pop_foot -->

    </div><!-- //pop_wrap -->   
    
    
    <table id="goodsItems-Table-sample" style="display:none" >
            <tr class="on">
<%--                 <td><a href="javascript:;" id="btndeleteRow"><img src="<c:url value='/images/erp/ico_del.gif'/>" width="14" height="16" alt="" title="삭제" /></a></td> --%>
                <td><input type="text" style="width:96%;" class="requirement"  tabindex="10001" id="txt_ITEM_NM" CODE="empty"/></td>
                <td><input type="text" style="width:93%;" class="cen non-requirement"  tabindex="10002" id="txt_ITEM_DC"/></td>
                <td><input type="text" style="width:90%;" class="cen non-requirement"  tabindex="10003" id="txt_UNIT_DC"/></td>
                <td><input type="text" style="width:90%;" class="pr5 ri non-requirement"  tabindex="10004" id="txt_CT_QT"/></td>
                <td><input type="text" style="width:85%;" class="pr5 ri non-requirement" tabindex="10005" id="txt_UNIT_AM"/></td>
                <td><input type="text" style="width:85%;" class="pr5 ri non-requirement" tabindex="10006" id="txt_CT_AM" readonly="readonly" /></td>
                <td><input type="text" style="width:94%" class="non-requirement" tabindex="10007" id="txt_RMK_DC"  part="state_d"/></td>
                <td>    
                    <div class="controll_btn ac" style=" padding:0px;">
                        <button class="btnSaveRow"><%=BizboxAMessage.getMessage("TX000001256","저장")%></button>
                        <button class="btnDeleteRow"><%=BizboxAMessage.getMessage("TX000000424","삭제")%></button>
                    </div><%-- <img src="<c:url value='/images/erp/erpsave.gif'/>"  alt="저장" title="저장" class="erpsave"/> --%>
                </td>
            </tr>
	</table>	
	<table id="goodsItems-Table-sample-empty" style="display:none">
	            <tr class="blank">
	<!--                 <td></td> -->
	                <td></td>
	                <td></td>
	                <td></td>
	                <td></td>
	                <td></td>
	                <td></td>
	                <td></td>
	                <td></td>
	            </tr>
	</table>
<div id="dialog-form-background_dir" style="display:none;"></div>	
</body>
