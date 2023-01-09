<%@ page import="org.apache.xmlbeans.impl.xb.xsdschema.IncludeDocument.Include"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="main.web.BizboxAMessage"%>

<head>
<title>title</title>
<script type="text/javascript" src='<c:url value="/js/neos/erp/ERPG20_CoCard_Util.js"></c:url>'></script>
<script>

var erpG20PayData = {};
erpG20PayData.inValidClass = "invalid";


erpG20PayData.PAY_DT_FROM = "${PAY_DT_FROM}";
erpG20PayData.PAY_DT_TO = "${PAY_DT_TO}";

var callBack = "${param.callback}" || "";
var abdocu_no = "${param.abdocu_no}" || "";
var abdocu_b_no = "${param.abdocu_b_no}" || "";
var erp_co_cd = "${param.erp_co_cd}" || "";
var divId = "${param.divId}" || "";
var PAY_DT_FROM = "${PAY_DT_FROM}" || "";
var PAY_DT_TO = "${PAY_DT_TO}" || "";
var DIV_NM = "${param.DIV_NM}" || ""; 
var DIV_CD = "${param.DIV_CD}" || ""; 
var MGT_NM = "${param.MGT_NM}" || "";
var MGT_CD = "${param.MGT_CD}" || ""; 

$(function(){
    
//     $("#payDIV_NM").val(decodeURI("${DIV_NM }"));
//     id="payDIV_NM" value="${DIV_NM }" 
    
    setDatepickerRVRS("RVRS_YM_FROM");
    setDatepickerRVRS("RVRS_YM_TO");
    setDatepicker("PAY_DT_FROM");
    setDatepicker("PAY_DT_TO");
    
 	$("#RVRS_YM_FROM").data("kendoDatePicker").value(PAY_DT_FROM.substr(0, 7));
	$("#RVRS_YM_TO").data("kendoDatePicker").value(PAY_DT_TO.substr(0, 7));
	$("#PAY_DT_FROM").data("kendoDatePicker").value(PAY_DT_FROM);
	$("#PAY_DT_TO").data("kendoDatePicker").value(PAY_DT_TO);
	

//      $(".search-Event-H").bind({
//          click : function(event){

//              var parentEle = $(this).parent();
//              var eventEle = $(".requirement", parentEle).first();

//              eventEle.dblclick();
//          }
//      });
     
    /* 닫기*/
     $("#defaultBtnPay").click(function(){
         if(confirm("<%=BizboxAMessage.getMessage("TX000009135","저장하지 않고 닫겠습니까?")%>")) {
             parent.window.close();
         }
    });
    
     $("#chkAll, #chkAll_sub").click(function(){
         var id = $(this).attr("id");
         erpG20PayData.CheckAll(id);
     });

	$("#payDIV_NM").bind({
		dblclick : function(){
			var id = $(this).attr("id");
			var dblClickparamMap =
				[{
					"id" : id,
					"text" : "DIV_NM",
					"code" : "DIV_CD"	
				}];
			acUtil.util.dialog.dialogDelegate(getErpDIVList, dblClickparamMap);
		}
	});
    
});


setDatepicker = function(id){
    var eventEle = $("#" + id); 
    eventEle.kendoDatePicker( {
        format : "yyyy-MM-dd",
        culture : "ko-KR",
        change: function (){
            
        }
    });
};

setDatepickerRVRS = function(id){
    var eventEle = $("#" + id); 
    eventEle.kendoDatePicker( {
    	option : 'monthSelectorOptions',
    	start: "year",
    	depth: "year",
    	format: "yyyy-MM",
    	culture : "ko-KR",
    	change: function (){
    		
        }
    });
};

// erpG20PayData.eventHandlerMapping = function(){

// };


// erpG20PayData.getDIV_CD = function(dblClickparamMap){  
	
// 	var opt = {
//             url : _g_contextPath_ + "/neos/erp/g20/getErpDIVList.do",
//             stateFn : modal,
//             async:true,
//             data : {},
//             successFn : function(){
//                 /*모달창 가로사이즈 및 타이틀*/
//                 var dialogParam = {
//                         title : "예산사업장 코드",
//                         width : "300"
//                             ,count : 2
//                 };
//                 ERPG20_Util.dialogForm = "dialog-form-CoCard";
//                 ERPG20_Util.util.dialog.open(dialogParam);
//                 /*모달창 컬럼 지정 및 스타일 지정*/
//                 var mainData = ERPG20_Util.modalData;
//                 var paramMap = {};
//                 paramMap.loopData =  mainData.selectList;
//                 paramMap.colNames = ["사업장 코드", "사업장 명"];
//                 paramMap.colModel = [
//                                        {code : "DIV_CD", text : "DIV_CD", style : {width : "150px"}},
//                                        {code : "", text : "DIV_NM", style : {width : "150px"}}
//                                      ];
//                 paramMap.dblClickparamMap = dblClickparamMap;

//                 /*모달창 값 선택시(더블클릭) 실행될 함수*/
//                 paramMap.trDblClickHandler_UserDefine = function(index){
//                     $("#payMGT_CD").val("").attr("code","");
//                 };

//                 ERPG20_Util.util.dialog.setData(paramMap);
//             }
//     }; 
//     /*결과 데이터 담을 객체*/
//     ERPG20_Util.modalData = {};
//     ERPG20_Util.ajax.call(opt, ERPG20_Util.modalData );
   
// };
    
/*dialog 띄우기 전 띄워도 되는지 체크*/
erpG20PayData.dialogPreProcessing = function(param){
    var returnBool = false;
    if(!param || !$.isArray(param)){
        returnBool = false;
    }
    else{
        returnBool = true;
    }
    return returnBool;
    //param
};    

function fnGetErpPayData(){
    var div_cd = $("#payDIV_NM").attr("CODE");
    
    $("#payDIV_NM").removeClass("invalid");
    if(!$.trim(div_cd)){
    	$("#payDIV_NM").addClass("invalid");
    	alert("<%=BizboxAMessage.getMessage("TX000009922","검색조건을 넣어주세요")%>");
        return; 
    }
    
    var tblParam = {};
    tblParam.CO_CD = erp_co_cd;
    tblParam.DIV_CD = DIV_CD;
    tblParam.MGT_CDS = $("#payMGT_CD").attr("CODE");
    tblParam.RVRS_YM_FROM = $("#RVRS_YM_FROM").val().replace(/-/gi,"");
    tblParam.RVRS_YM_TO = $("#RVRS_YM_TO").val().replace(/-/gi,"");
    tblParam.PAY_DT_FROM = $("#PAY_DT_FROM").val().replace(/-/gi,"");
    tblParam.PAY_DT_TO = $("#PAY_DT_TO").val().replace(/-/gi,"");
    
    var opt = {  
            type:"post",
            url: '<c:url value="/Ac/G20/Ex/getErpPayData.do"/>',                       		
            datatype:"json",        
            data: tblParam,
            success:function(data){
                var resultData = data.selectList;
                var html = "";
                    html += '<colgroup>';
                    html += '<col width="25px" />';
                    html += '<col width="70px" />';
                    html += '<col width="100px" />';
                    html += '<col width="100px" />';
                    html += '<col width="70px" />';
                    html += '<col width="60px" />';
                    html += '<col width="70px" />';
                    html += '<col width="80px" />';
                    html += '<col width="80px" />';
                    html += '<col width="80px" />';
                    html += '<col width="80px" />';
                    html += '<col width="" />'; 
                    html += '</colgroup>'; 
                    for(var i=0;i<resultData.length;i++){
                    	var pkey = ncCom_EmptyToString(resultData[i].EMP_CD) + '_' + ncCom_EmptyToString(resultData[i].RVRS_YM) + '_' + ncCom_EmptyToString(resultData[i].SQ);
                        html += '<tr id="'  + pkey+ '"><td> ';
                        if(resultData[i].GISU_DT.length > 0){
                        	html += '<input type="checkbox" class="chkSel2" disabled=disabled/>  ';
                        }else{
                            html += '<input type="checkbox" name="chkNo" class="k-checkbox chkNo" id="erp_'+ pkey +'">';
                            html += '<label class="k-checkbox-label chkSel2" for="erp_'+ pkey +'"></label>';
                        }
                        
                        html += '<input type="hidden" name="strKOR_NM" value = "' + ncCom_EmptyToString(resultData[i].KOR_NM) + '" />  ';
                        html += '<input type="hidden" name="strDEPT_NM" value = "' + ncCom_EmptyToString(resultData[i].DEPT_NM) + '" />  ';
                        html += '<input type="hidden" name="strEMP_TR_CD" value = "' + ncCom_EmptyToString(resultData[i].EMP_CD) + '" />  ';
                        html += '<input type="hidden" name="strTPAY_AM" value = "' + ncCom_EmptyToString(resultData[i].TPAY_AM) + '" />  ';
                        html += '<input type="hidden" name="strSUP_AM" value = "' + ncCom_EmptyToString(resultData[i].SUP_AM) + '" />  ';
                        html += '<input type="hidden" name="strVAT_AM" value = "' + ncCom_EmptyToString(resultData[i].VAT_AM) + '" />  ';
                        html += '<input type="hidden" name="strINTX_AM" value = "' + ncCom_EmptyToString(resultData[i].INTX_AM) + '" />  ';
                        html += '<input type="hidden" name="strRSTX_AM" value = "' + ncCom_EmptyToString(resultData[i].RSTX_AM) + '" />  ';
                        html += '<input type="hidden" name="strETC_AM" value = "' + ncCom_EmptyToString(resultData[i].ETC_AM) + '" />  ';
                        html += '<input type="hidden" name="strGISU_DT" class="GISU_DT" value = "' + ncCom_EmptyToString(resultData[i].GISU_DT) + '" />  ';
                        html += '<input type="hidden" name="strPAY_DT" value = "' + ncCom_EmptyToString(resultData[i].PAY_DT) + '" />  ';
                        html += '<input type="hidden" name="strRVRS_YM" value = "' + ncCom_EmptyToString(resultData[i].RVRS_YM) + '" />  ';
                        html += '<input type="hidden" name="strSQ" value = "' + ncCom_EmptyToString(resultData[i].SQ) + '" />  ';
                        html += '<input type="hidden" name="strACCT_NO" value = "' + ncCom_EmptyToString(resultData[i].ACCT_NO) + '" />  ';
                        html += '<input type="hidden" name="strPYTB_CD" value = "' + ncCom_EmptyToString(resultData[i].PYTB_CD) + '" />  ';
                        html += '<input type="hidden" name="strDPST_NM" value = "' + ncCom_EmptyToString(resultData[i].DPST_NM) + '" />  ';
                        html += '<input type="hidden" name="strBANK_NM" value = "' + ncCom_EmptyToString(resultData[i].BANK_NM) + '" />  ';
                        html += '<input type="hidden" name="strRSRG_NO" value = "' + ncCom_EmptyToString(resultData[i].RSRG_NO) + '" />  ';
                        html += '<input type="hidden" name="strPJT_NM" value = "' + ncCom_EmptyToString(resultData[i].PJT_NM) + '" />  ';
                        html += '<input type="hidden" name="strPKEY" value = "' + pkey + '" />  ';
                        html += '</td>';
                        html += '<td align="center">' + ncCom_EmptyToString(resultData[i].EMP_CD) + '</td>';
                        html += '<td align="center">' + ncCom_EmptyToString(resultData[i].KOR_NM) + '</td>';
                        html += '<td align="center">' + ncCom_EmptyToString(resultData[i].RSRG_NO) + '</td>';
                        html += '<td align="center">' + ncCom_EmptyToString(resultData[i].GISU_DT) + '</td>';
                        html += '<td align="center">' + ncCom_EmptyToString(resultData[i].RVRS_YM) + '</td>';
                        html += '<td align="center">' + ncCom_EmptyToString(resultData[i].PAY_DT) + '</td>';
                        html += '<td align="center">' + getToPrice(resultData[i].TPAY_AM) + '</td>';
                        html += '<td align="center">' + getToPrice(resultData[i].INTX_AM) + '</td>';
                        html += '<td align="center">' + getToPrice(resultData[i].RSTX_AM) + '</td>';
                        html += '<td align="center">' + getToPrice(resultData[i].ETC_AM) + '</td>';
                        html += '<td align="center">' + ncCom_EmptyToString(resultData[i].PJT_NM) + '</td>';
                        html += '</tr>';
                        
                    }
                    if(resultData.length == 0){
                    	html += "<tr><td colspan='12'><%=BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다")%></td></tr>";
                    }
                $("#coCardList").html(html);
            }
    };
    $.ajax(opt);    
};


erpG20PayData.addSubRow = function(){
	
    var table = $("#coCardList");
    var subtable = $("#coCardList_Sub");
    var chkNo = $(".chkNo", table);
    for(var i=0;i<chkNo.length;i++) {
//     	var chked = checkBoxSelected(chkNo.get(i));

    	var cbox = chkNo.get(i);

    	if(cbox.checked == true) {
    		var $tr = $(cbox).parents("tr");
    		var tdStr =  $tr.html();
    		var trId =  $tr.attr("id");
    		var count = 0;

    		
    		var subtrList = $("tr", subtable);
    		
    		for(var j=0;j<subtrList.length;j++) {
    			if($(subtrList[j]).attr("id") == trId ){
    				count ++;
    		    }
    		}
//                 subtrList.each(function(index){
                    
//                 });
            
            if(count == 0){
            	if($(".GISU_DT", $tr).val().trim().length < 1){
            		var trStr = '<tr id="'  +trId + '">' + tdStr + '</tr>' ;
            		subtable.append(trStr);
            	}
                	/* else{
                		alert("이미 처리된 데이터는 중복처리할수 없습니다.");
                	} */
                }
                count = 0;
/*                 var totalAM = 0;
                $(".strSUNGIN_AM", subtrList).each(function(index){
                    totalAM += parseInt($(this).val(), 10) || "0" ; 
                });
                
                $("#totalNum").html(getToPrice(totalAM));             */
            };
        };
};


erpG20PayData.deleteSubRow = function(){
    var table = $("#coCardList_Sub");
    var chkNo = $(".chkNo", table);
     for(var i=0;i<chkNo.length;i++) {
    	 
         var cbox = chkNo.get(i);

         if(cbox.checked == true) {
        	 var $tr = $(cbox).parents("tr");
//              var $td = $cbox.parent();
//              var $tr = $td.parent();
             $tr.remove();
         };
     };
};

erpG20PayData.CheckAll= function(id){
    var table = $("#coCardList");
    if(id == "chkAll_sub"){
        table = $("#coCardList_Sub");   
    }   
    $("#" +id).each(function(){
        if(this.checked==true){
            $(".chkNo", table).each(function(){
            	if($(this).attr("disabled") != "disabled" ){
            		this.checked=true;	
            	}
                
            });
        }else{
            $(".chkNo", table).each(function(){
                this.checked=false;
            });
        };
    });
};

function btnOk(){
	modal(true);
    $.ajax({
        type:"post",
        url:'<c:url value="/Ac/G20/Ex/setPayData.do" />',
        datatype:"json",
        data: $("#subForm").serialize(),
        success:function(data){
        	if(data.result > 0 ){
        		alert("<%=BizboxAMessage.getMessage("TX000009921","선택한리스트가 저장되었습니다")%>");
                var retVal   = new Object();
                retVal.apply_am  = data.abdocu_B.apply_am;
                retVal.abdocu_b_no  = abdocu_b_no;
                
        		parent.eval(callBack)(retVal);
        		acLayerPopClose(divId);
        	}else{
        		alert("<%=BizboxAMessage.getMessage("TX000009920","선택한리스트가 저장 하는중 오류가 발생하였습니다")%>");
        		modal(false);
        	}  
        },error:function(e){
        	alert("<%=BizboxAMessage.getMessage("TX000016497","선택한리스트를 등록중 오류가 발생하였습니다")%>");
        	modal(false);
        }
    });
    modal(false);
};

function btnCancel(){
	acLayerPopClose(divId);	
}


</script>
</head>
<!-- <body> -->
<div class="pop_wrap_dir" style="width:970px;" id="PayDataPop" >
    <div class="pop_head">
        <h1><%=BizboxAMessage.getMessage("TX000006532","급여자료선택")%></h1>
        <a href="#n" class="clo"><img src="<c:url value='/Images/btn/btn_pop_clo02.png' />" alt="" onclick="btnCancel();" /></a>        
    </div>    
    <div class="pop_con expense">      
        <div class="top_box" style="overflow:hidden;">
            <dl>
                <dt><%=BizboxAMessage.getMessage("TX000000811","사업장")%></dt>
                <dd>
                        <input type="text" class="requirement" id="payDIV_NM" style="width:300px;" readonly="readonly" value="${param.DIV_NM}" code="${param.DIV_CD}" />
                        <a href="#n" class="search-Event-H"><img src="<c:url value='/Images/btn/btn_rightgo01.png'/>" alt="" /></a>
                </dd>
                <dt><%=BizboxAMessage.getMessage("TX000000519","프로젝트")%></dt>
                <dd>
                        <input type="text" class="non-requirement" id="payMGT_CD" style="width:300px;" readonly="readonly" value="${param.MGT_NM}" code="${param.MGT_CD}"/>
                        <a href="#n" class="search-Event-H"><img src="<c:url value='/Images/btn/btn_rightgo01.png'/>" alt="" /></a>
                </dd>                
                
            </dl>
            <dl>
                <dt><%=BizboxAMessage.getMessage("TX000006516","귀속기간")%></dt>
                <dd><input id="RVRS_YM_FROM" style="width:151px;" class="non-requirement"/> ~ <input id="RVRS_YM_TO"  style="width:151px;" class="non-requirement"/></dd>
                <dt><%=BizboxAMessage.getMessage("TX000006517","지급기간")%></dt>
                <dd><input id="PAY_DT_FROM" style="width:151px;" class="non-requirement" /> ~ <input id="PAY_DT_TO" style="width:151px;" class="non-requirement"/></dd>
                <dd><input type="button" onclick="fnGetErpPayData();" id="searchButton" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" /></dd>
            </dl>            
        </div>
        
        <div class="h2_btn2">
            <h2><%=BizboxAMessage.getMessage("TX000017840","조회리스트")%></h2>
            <div class="controll_btn">
                <button type="button" onclick="javascript:erpG20PayData.addSubRow();"><%=BizboxAMessage.getMessage("TX000000446","추가")%></button>
            </div>
        </div>
                
        <div class="com_ta2">
        <table border="0" >
                <colgroup>
                    <col width="25" />
                    <col width="70" />
                    <col width="100" />
                    <col width="100" />
                    <col width="70" />
                    <col width="60" />
                    <col width="70" />
                    <col width="80" />
                    <col width="80" />
                    <col width="80" />
                    <col width="80" />
                    <col width="" />
                </colgroup>
               <tr>
                    <th scope="col">
<!--                     <input type="checkbox" id="chkAll" name="chkAll" class="chkSel2"/> -->
                    <input type="checkbox" id="chkAll" name="chkAll" class="k-checkbox"><label class="k-checkbox-label chkSel2" for="chkAll"></label>
                    </th>
                    <th scope="col"><%=BizboxAMessage.getMessage("TX000000357","사원코드")%></th>
                    <th scope="col"><%=BizboxAMessage.getMessage("TX000000076","사원명")%></th>
                    <th scope="col"><%=BizboxAMessage.getMessage("TX000000080","주민번호")%></th>
                    <th scope="col"><%=BizboxAMessage.getMessage("TX000005163","처리일자")%></th>
                    <th scope="col"><%=BizboxAMessage.getMessage("TX000003537","귀속년월")%></th>
                    <th scope="col"><%=BizboxAMessage.getMessage("TX000003544","지급일자")%></th>
                    <th scope="col"><%=BizboxAMessage.getMessage("TX000005533","총지급액")%></th>
                    <th scope="col"><%=BizboxAMessage.getMessage("TX000004265","소득세액")%></th>
                    <th scope="col"><%=BizboxAMessage.getMessage("TX000004267","주민세액")%></th>
                    <th scope="col"><%=BizboxAMessage.getMessage("TX000017822","기타공급액")%></th>
                    <th scope="col"><%=BizboxAMessage.getMessage("TX000000519","프로젝트")%></th>
                </tr>
        </table>
        </div>
        
        <div class="com_ta2 ova_sc" style="height:112px;">
             <table border="0" id="coCardList"> <tr><td colspan='12'><%=BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다")%></td></tr></table>
        </div>
        
        <div class="h2_btn2">
            <h2><%=BizboxAMessage.getMessage("TX000005462","선택리스트")%></h2>
            <div class="controll_btn">
                <button type="button" onclick="javascript:erpG20PayData.deleteSubRow();"><%=BizboxAMessage.getMessage("TX000000424","삭제")%></button>
            </div>
        </div>
        
        <div class="com_ta2">
        <table border="0" >
                <colgroup>
                    <col width="25" />
                    <col width="70" />
                    <col width="100" />
                    <col width="100" />
                    <col width="70" />
                    <col width="60" />
                    <col width="70" />
                    <col width="80" />
                    <col width="80" />
                    <col width="80" />
                    <col width="80" />
                    <col width="" />
                </colgroup>
                <tr>
                    <th scope="col">
                    <input type="checkbox" id="chkAll_sub" name="chkAll_sub" class="k-checkbox"><label class="k-checkbox-label chkSel2" for="chkAll_sub"></label>
<!--                     <input type="checkbox" id="chkAll_sub" name="chkAll_sub" class="chkSel2" /></th> -->
                    <th scope="col"><%=BizboxAMessage.getMessage("TX000000357","사원코드")%></th>
                    <th scope="col"><%=BizboxAMessage.getMessage("TX000000076","사원명")%></th>
                    <th scope="col"><%=BizboxAMessage.getMessage("TX000000080","주민번호")%></th>
                    <th scope="col"><%=BizboxAMessage.getMessage("TX000005163","처리일자")%></th>
                    <th scope="col"><%=BizboxAMessage.getMessage("TX000003537","귀속년월")%></th>
                    <th scope="col"><%=BizboxAMessage.getMessage("TX000003544","지급일자")%></th>
                    <th scope="col"><%=BizboxAMessage.getMessage("TX000005533","총지급액")%></th>
                    <th scope="col"><%=BizboxAMessage.getMessage("TX000004265","소득세액")%></th>
                    <th scope="col"><%=BizboxAMessage.getMessage("TX000004267","주민세액")%></th>
                    <th scope="col"><%=BizboxAMessage.getMessage("TX000017822","기타공급액")%></th>
                    <th scope="col"><%=BizboxAMessage.getMessage("TX000000519","프로젝트")%></th>
                </tr>
                
        </table>
        </div>
        <div class="com_ta2 ova_sc" style="height:120px;">
        <form id="subForm" name="subForm" method="post" action="<c:url value='/Ac/G20/Ex/setPayData.do'/>">
             <input type="hidden" name="abdocu_no" value = "${param.abdocu_no}"/>
             <input type="hidden" name="abdocu_b_no" value ="${param.abdocu_b_no}"/>
             <input type="hidden" name="erp_co_cd" value ="${param.erp_co_cd}"/>
            <table border="0" id="coCardList_Sub">
                <colgroup>
                    <col width="25" />
                    <col width="70" />
                    <col width="100" />
                    <col width="100" />
                    <col width="70" />
                    <col width="60" />
                    <col width="70" />
                    <col width="80" />
                    <col width="80" />
                    <col width="80" />
                    <col width="80" />
                    <col width="" />
                </colgroup>
<%--                 <c:if test="${fn:length(selectList) == 0}"> --%>
<!--                 <tr> -->
<!--                     <td align="center" class="first" colspan="12">데이터가 존재하지 않습니다.</td> -->
<!--                 </tr> -->
<%--                 </c:if> --%>
                <c:forEach var="result" items="${selectList}" varStatus="status">
                     <tr id="${result.PKEY}">
                        <td> <!-- <input type="checkbox" name="chkNo" class="chkSel2 chkNo"> -->
                             <input type="checkbox" name="chkNo" class="k-checkbox chkNo" id="gw_${result.PKEY}"><label class="k-checkbox-label chkSel2" for="gw_${result.PKEY}"></label>
<!--                         <input type="checkbox" class="chkNo"/> -->
                                 <input type="hidden" name="strKOR_NM" value = "${result.KOR_NM}" />
                                 <input type="hidden" name="strDEPT_NM" value = "${result.DEPT_NM}" />
                                 <input type="hidden" name="strEMP_TR_CD" value = "${result.EMP_TR_CD}" />
                                 <input type="hidden" name="strTPAY_AM"  value = "${result.TPAY_AM}" />
                                 <input type="hidden" name="strSUP_AM"  value = "${result.SUP_AM}" />
                                 <input type="hidden" name="strVAT_AM"  value = "${result.VAT_AM}" />
                                 <input type="hidden" name="strINTX_AM"  value = "${result.INTX_AM}" />
                                 <input type="hidden" name="strRSTX_AM"  value = "${result.RSTX_AM}" />
                                 <input type="hidden" name="strETC_AM"  value = "${result.ETC_AM}" />
                                 <input type="hidden" name="strGISU_DT"  class="GISU_DT" value = "${result.GISU_DT}" />
                                 <input type="hidden" name="strPAY_DT"  value = "${result.PAY_DT}" />
                                 <input type="hidden" name="strRVRS_YM"  value = "${result.RVRS_YM}" />
                                 <input type="hidden" name="strSQ"  value = "${result.SQ}" />
                                 <input type="hidden" name="strACCT_NO"  value = "${result.ACCT_NO}" />
                                 <input type="hidden" name="strPYTB_CD"  value = "${result.PYTB_CD}" />
                                 <input type="hidden" name="strDPST_NM"  value = "${result.DPST_NM}" />
                                 <input type="hidden" name="strBANK_NM"  value = "${result.BANK_NM}" />
                                 <input type="hidden" name="strRSRG_NO"  value = "${result.RSRG_NO}" />
                                 <input type="hidden" name="strPJT_NM"  value = "${result.PJT_NM}" />
                                 <input type="hidden" name="strPKEY"  value = "${result.PKEY}" />
                        </td>
                        <td align="center">${result.EMP_TR_CD}</td>
                        <td align="center">${result.KOR_NM}</td>
                        <td align="center">${result.RSRG_NO}</td>
                        <td align="center">${result.GISU_DT}</td>
                        <td align="center">${result.RVRS_YM}</td>
                        <td align="center">${result.PAY_DT}</td>
                        <td align="center"><fmt:formatNumber type="currency"  value="${result.TPAY_AM}" currencySymbol="" /></td>
                        <td align="center"><fmt:formatNumber type="currency"  value="${result.INTX_AM}" currencySymbol="" /></td>
                        <td align="center"><fmt:formatNumber type="currency"  value="${result.RSTX_AM}" currencySymbol="" /></td>
                        <td align="center"><fmt:formatNumber type="currency"  value="${result.ETC_AM}" currencySymbol="" /></td>
                        <td align="center">${result.PJT_NM}</td>
                        </tr>
                   </c:forEach>                        
            </table>
        </form>
        </div>
        
    </div><!-- //pop_con -->

    <div class="pop_foot">
        <div class="btn_cen pt12">
            <input type="button" onclick="btnOk();" value="<%=BizboxAMessage.getMessage("TX000000078","확인")%>" />
            <input type="button" class="gray_btn" onclick="btnCancel();" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" />
        </div>
    </div><!-- //pop_foot -->
    </div><!-- //pop_wrap -->
<!-- </body> -->

<div id="dialog-form-CoCard" class="parent" style="display:none">
<div class="pop_wrap" >
    <div class="pop_head">
        <h1></h1>
        <a href="#n" class="clo popCloseCard"><img src="<c:url value='/Images/btn/btn_pop_clo01.png' />" alt="" /></a>
    </div>

    <div class="pop_con">   
        <div class="com_ta2 mt10 ova_sc_all cursor_p" style="height:340px;" id="dialog-form-CoCard-bind">
        </div>  
    </div><!-- //pop_con -->
</div><!-- //pop_wrap -->
</div>

<div id="dialog-form-background_dir" style="display:none;"></div>	

