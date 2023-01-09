<%@page import="org.apache.xmlbeans.impl.xb.xsdschema.IncludeDocument.Include"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="main.web.BizboxAMessage"%>

<head>
<title>title</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%-- <script type="text/javascript" src='<c:url value="/js/neos/erp/ERPG20_CoCard_Util.js"></c:url>'></script> --%>
<%-- <%@ include file="/WEB-INF/jsp/neos/include/IncludeDatepicker.jsp"%> --%>
<script type="text/javascript" src='<c:url value="/js/ac/acUtil.js"></c:url>'></script>
<script type="text/javascript" src="<c:url value='/js/neos/NeosUtil.js' />"></script>
<style type="text/css">
.invalid
{
    background-color : #ff6666;
}
</style>
<script>

var callBack = "${param.callback}" || "";
var abdocu_no = "${param.abdocu_no}" || "";
var abdocu_b_no = "${param.abdocu_b_no}" || "";
var erp_co_cd = "${param.erp_co_cd}" || "";

var erpG20CoCardList = {};
erpG20CoCardList.inValidClass = "invalid";

erpG20CoCardList.abdocu_no = "${aCardVO.abdocu_no}";
erpG20CoCardList.abdocu_b_no = "${aCardVO.abdocu_b_no}";
/* erpG20CoCardList.erp_co_cd = "${erpG20CoCardVO.erp_co_cd}"; */

erpG20CoCardList.state = function(state){
    if(state){      
        $("#dialog-form-background_CoCard").css("top", "1").css("left", "1").show();
        var img = $("<img>").attr("id", "g20-ajax-img").attr("src", _g_contextPath_ + "/Images/ajax-loader2.gif")
        .css("position", "absolute").css("top", "300px").css("left", "420px").css("zIndex", "100000");
        $("body").append(img);  
    }
    else{
        $("#dialog-form-background_CoCard").hide(); 
        $("#g20-ajax-img").remove();
    }
};
$(function(){

    $(".controll_btn button").kendoButton();
    
    //시작날짜
    var start = $("#ISS_DT_FROM").kendoDatePicker({
        format: "yyyy-MM-dd",
        culture : "ko-KR",
        change : startChange
    }).data("kendoDatePicker");
    
    //종료날짜
    var end = $("#ISS_DT_TO").kendoDatePicker({
        format: "yyyy-MM-dd",
        culture : "ko-KR",
        change : endChange
    }).data("kendoDatePicker");
    
    function startChange() {
        var startDate = start.value(),
        endDate = end.value();

        if (startDate) {
            startDate = new Date(startDate);
            startDate.setDate(startDate.getDate());
            end.min(startDate);
        } else if (endDate) {
            start.max(new Date(endDate));
        } else {
            endDate = new Date();
            start.max(endDate);
            end.min(endDate);
        }
    }

    function endChange() {
        var endDate = end.value(),
        startDate = start.value();

        if (endDate) {
            endDate = new Date(endDate);
            endDate.setDate(endDate.getDate());
            start.max(endDate);
        } else if (startDate) {
            end.min(new Date(startDate));
        } else {
            endDate = new Date();
            start.max(endDate);
            end.min(endDate);
        }
    }
     
     $(".search-Event-H").bind({
         click : function(event){

             var parentEle = $(this).parent();
             var eventEle = $(".requirement", parentEle).first();

             eventEle.dblclick();
         }
     });
	
     $("#chkAll, #chkAll_sub").click(function(){
    	 var id = $(this).attr("id");
    	 erpG20CoCardList.CheckAll(id);
     });

     $("#CARD_NB").bind({
         dblclick : function(){
             var id = $(this).attr("id");
             var dblClickparamMap =
                 [{
                     "id" : id,
                     "text" : "CARD_NUM",
                     "code" : "CARD_CD"
                 },
                 {
                     "id" : "CARD_NM",
                     "text" : "CARD_NAME",
                     "code" : "CARD_NAME"
                 }];
             acUtil.util.dialog.dialogDelegate(getACardList, dblClickparamMap);
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

function getACardList(dblClickparamMap){  
	var data = { }; 
	data.erp_co_cd = erp_co_cd;
    /*ajax 호출할 파라미터*/
    var opt = {
            url : _g_contextPath_ + "/Ac/G20/Ex/getACardList.do",
            stateFn: modal,
            async:false,
            data : data,
            successFn : function(){
                /*모달창 가로사이즈 및 타이틀*/
                var dialogParam = {
                        title : "<%=BizboxAMessage.getMessage("TX000005179","법인카드코드")%>",
                        width : "500" ,
                        count : 4
                };
                acUtil.dialogForm = "dialog-form-CoCard";
                acUtil.util.dialog.open(dialogParam);

                /*모달창 컬럼 지정 및 스타일 지정*/
                var mainData = acUtil.modalData;
                var paramMap = {};
                paramMap.loopData =  mainData.selectList;
                paramMap.colNames = ["<%=BizboxAMessage.getMessage("TX000000045","코드")%>", "<%=BizboxAMessage.getMessage("TX000005284","카드명(거래처명)")%>", "<%=BizboxAMessage.getMessage("TX000000526","카드번호")%>", "<%=BizboxAMessage.getMessage("TX000000214","구분")%>"]; 
                paramMap.colModel = [
                                       {code : "", text : "CARD_CD", style : {width : "100px"}},
                                       {code : "", text : "CARD_NAME", style : {width : "100px"}},
                                       {code : "", text : "CARD_NUM", style : {width : "100px"}},
                                       {code : "", text : "CARD_FLAG_NM", style : {width : "100px"}}
                                     ];
                paramMap.dblClickparamMap = dblClickparamMap; 
                acUtil.util.dialog.setData(paramMap);              
            }
    };
    /*결과 데이터 담을 객체*/
    acUtil.modalData = {};
    acUtil.ajax.call(opt, acUtil.modalData );
};
      

erpG20CoCardList.CoCardAList = function(){
    var CARD_NB =  $("#CARD_NB").val();
    var TR_CD =  $("#CARD_NB").attr("code");
    var TR_NM =  $("#CARD_NM").val();
    var ISS_DT_FROM =  $("#ISS_DT_FROM").val().replace(/-/gi,"");
    var ISS_DT_TO =  $("#ISS_DT_TO").val().replace(/-/gi,"");
    
    if(CARD_NB == '') {
    	$("#CARD_NB").addClass(erpG20CoCardList.inValidClass);
    	alert("<%=BizboxAMessage.getMessage("TX000009922","검색조건을 넣어주세요")%>");
    	return;
    }
    else if(TR_CD == '') {
    	$("#CARD_NB").addClass(erpG20CoCardList.inValidClass);
    	alert("<%=BizboxAMessage.getMessage("TX000009922","검색조건을 넣어주세요")%>");
    	return;	
    }
    else if(TR_NM == '') {
    	$("#CARD_NM").addClass(erpG20CoCardList.inValidClass);
    	alert("<%=BizboxAMessage.getMessage("TX000009922","검색조건을 넣어주세요")%>");
    	return;
	}
    else if(ISS_DT_FROM == '') {
    	$("#ISS_DT_FROM").addClass(erpG20CoCardList.inValidClass);
    	alert("<%=BizboxAMessage.getMessage("TX000009922","검색조건을 넣어주세요")%>");
    	return;
	}
	else if(ISS_DT_TO == '') {
		$("#ISS_DT_TO").addClass(erpG20CoCardList.inValidClass);
		alert("<%=BizboxAMessage.getMessage("TX000009922","검색조건을 넣어주세요")%>");
    	return;
	}
    
    // alert(TR_NM);
    var obj = {
            CARD_NB :  CARD_NB, // '4988208001853339', // CARD_NB,
            TR_CD : TR_CD,
            TR_NM : TR_NM,
            ISS_DT_FROM : ISS_DT_FROM ,
            ISS_DT_TO : ISS_DT_TO,
            CO_CD : erp_co_cd // '1000' // erp_co_cd
            };
    var param = NeosUtil.makeParam(obj);
    
    var opt = {  
            type:"post",
            url: '<c:url value="/Ac/G20/Ex/getErpACardSunginList.do"/>' ,
            datatype:"json",        
            data: obj,
            success:function(data){        
                //date.detailList
                var resultData = data.selectList;
                var html = "";
//                     html += '<colgroup>';
//                     html += '<col width="34px" />';
//                     html += '<col width="80px" />';
//                     html += '<col width="30px" />';
//                     html += '<col width="140px" />';
//                     html += '<col width="90px" />';
//                     html += '<col width="90px" />';
//                     html += '<col width="90px" />';
//                     html += '<col width="90px" />';
//                     html += '<col width="70px" />';
//                     html += '<col width="90px" />';
//                     html += '<col width="" />'; 
//                     html += '</colgroup>'; 
                    for(var i=0;i<resultData.length;i++){
                    	/* 현재 선택된 행과 중복체크 */
                    	$('#coCardList_Sub').find('tr').each(function(){
                    		if($(this).attr('id') == resultData[i].PKEY){
                    			resultData[i].GW_STATE = 'Y';
                    		}
                    	});
                    	
                        html += '<tr id="'  +resultData[i].PKEY + '">';
                        if(resultData[i].GW_STATE == null || resultData[i].GW_STATE == ""){
                        	html += '<td> <input id="chk' + resultData[i].PKEY + '" type="checkbox" class="chkNo k-checkbox"/> <label class="k-checkbox-label radioSel" for="chk' + resultData[i].PKEY + '"></label> ';
                        }else{
                        	html += '<td> <input id="chk' + resultData[i].PKEY + '" type="checkbox" disabled="disabled" class="chkNo k-checkbox"/><label class="k-checkbox-label radioSel" for="chk' + resultData[i].PKEY + '"></label>  ';
                        }
                        html += '<input type="hidden" name="strCARD_NB" value = "' + resultData[i].CARD_NB + '" />  ';
                        html += '<input type="hidden" name="strISS_DT" value = "' + ncCom_Date(resultData[i].ISS_DT, '-') + '" />  ';
                        html += '<input type="hidden" name="strISS_SQ" value = "' + resultData[i].ISS_SQ + '" />  ';
                        html += '<input type="hidden" name="strCHAIN_NAME" value = "' + resultData[i].CHAIN_NAME + '" />  ';
                        html += '<input type="hidden" name="strCHAIN_REGNB" value = "' + resultData[i].CHAIN_REGNB + '" />  ';
                        html += '<input type="hidden" name="strSUNGIN_NB" value = "' + resultData[i].SUNGIN_NB + '" />  ';
                        html += '<input type="hidden" name="strSUNGIN_AM" class="strSUNGIN_AM" value = "' + resultData[i].SUNGIN_AM + '" />  ';
                        html += '<input type="hidden" name="strVAT_AM" value = "' + resultData[i].VAT_AM + '" />  ';
                        html += '<input type="hidden" name="strTOT_AM" value = "' + resultData[i].TOT_AM + '" />  ';
                        html += '<input type="hidden" name="strUSER_TYPE" value = "' + resultData[i].USER_TYPE + '" />  ';
                        html += '<input type="hidden" name="strGW_STATE" value = "' + resultData[i].GW_STATE + '" />  ';
                        html += '<input type="hidden" name="strGW_STATE_HAN" value = "' + resultData[i].GW_STATE_HAN + '" />  ';
                        html += '<input type="hidden" name="strPKEY" value = "' + resultData[i].PKEY + '" />  ';
                        html += '<input type="hidden" name="strCTR_CD" value = "' + resultData[i].CARD_CD + '" />  ';
                        html += '<input type="hidden" name="strCTR_NM" value = "' + resultData[i].CARD_NM + '" />  ';
                        html += '<input type="hidden" name="strADMIT_DT" value = "' + ncCom_EmptyToString(resultData[i].ADMIT_DT) + '" />  ';
                        html += '<input type="hidden" name="strCHAIN_BUSINESS" value = "' + ncCom_EmptyToString(resultData[i].CHAIN_BUSINESS) + '" />  ';
                        html += '<input type="hidden" name="strCANCEL_YN" value = "' + ncCom_EmptyToString(resultData[i].CANCEL_YN) + '" />  ';
                        html += '</td>';
                        // html += '<td align="center" class="">' + ncCom_Date(resultData[i].ISS_DT, '-')  + " " + ncCom_Time(resultData[i].ADMIT_DT, ':') +  '</td>';
                        html += '<td align="center" class="">' + ncCom_Date(resultData[i].ISS_DT, '-') + /* + " " + ncCom_Time(resultData[i].ADMIT_DT, ':') + */ '</td>';
                        html += '<td align="center" class="">' + resultData[i].ISS_SQ + '</td>';
                        html += '<td align="center" class="">' + resultData[i].CHAIN_NAME + '</td>';
                        html += '<td align="center" class="">' + resultData[i].SUNGIN_NB + '</td>';
                        html += '<td align="center" class="">' + getToPrice(resultData[i].TOT_AM) + '</td>';
                        html += '<td align="center" class="">' + getToPrice(resultData[i].VAT_AM) + '</td>';
                        html += '<td align="center" class="">' + resultData[i].USER_TYPE + '</td>';
                        html += '<td align="center" class="" code="'+ resultData[i].GW_STATE + '">'+ resultData[i].GW_STATE_HAN +'</td>';
                        html += '<td align="center" class="">'+ ncCom_EmptyToString(resultData[i].CHAIN_BUSINESS) +'</td>';
                        html += '<td align="center" class="">'+ ncCom_EmptyToString(resultData[i].CANCEL_YN) +'</td>';
                        html += '</tr>';
                    }
                $("#coCardList>tbody").html(html);
            }
    };
    $.ajax(opt);    
};


erpG20CoCardList.valid = function(){
    $("." + erpG20CoCardList.inValidClass).removeClass(erpG20CoCardList.inValidClass);
    var isValid = true;
    
    $(".requirement").each(function(){
        var valele = $(this);
        if(!$.trim(valele.val())){
            valele.addClass(erpG20CoCardList.inValidClass);
            isValid = false;
        }
    });
    
    return isValid;
};

erpG20CoCardList.addSubRow = function(){
	var table = $("#coCardList");
	var subtable = $("#coCardList_Sub");
	var chkNo = $(".chkNo", table);
	    for(var i=0;i<chkNo.length;i++) {
	        var $cbox = $(chkNo.get(i));
	        /* if($cbox.attr("checked") == "checked") { */
       		if($($cbox[0]).prop('checked')) {
	            var $td = $cbox.parent();
	            var $tr = $td.parent();
	            
	            /* id및 for attribute 중복 제거 */
	            var forOrId = $tr.find('.chkNo').attr('id');
	            var tdStr =  $tr.html().replace('id="' + forOrId, 'id="' + forOrId + '_sub');
	            tdStr =  tdStr.replace('for="' + forOrId, 'for="' + forOrId + '_sub');
	            
	            var trId =  $tr.attr("id");
                var count = 0;
                var subtrList = $("tr", subtable);

                subtrList.each(function(index){
                    if($(subtrList[index]).attr("id") == trId ){
                        count ++;
                    }
                });
                 
                if(count == 0){
                	var trStr = '<tr id="'  +trId + '">' + tdStr + '</tr>' ;
                    subtable.append(trStr);
                }
                count = 0;
                
                $cbox.prop('disabled', true).prop('checked', false);
	        };
	    };
};


erpG20CoCardList.deleteSubRow = function(){
    var table = $("#coCardList_Sub");
    var chkNo = $(".chkNo", table);
    
    $("#coCardList_Sub").find('.chkNo').each(function (){
    	if($(this).prop("checked")){
    		var $td = $(this).parent();
            var $tr = $td.parent();
			var pkey = $tr.attr('id');
            $('#chk' + pkey).prop('disabled', false)
            $tr.remove();
    	}
    }); 
};

erpG20CoCardList.CheckAll= function(id){
	var table = $("#coCardList");
	if(id == "chkAll_sub"){
		table = $("#coCardList_Sub");	
	}   
//     $("#" +id).each(function(){
//         if(this.checked==true){
//             $(".chkNo", table).each(function(){
//             	alert(this.attr("disabled"));
//             	this.checked=true;
//             });
//         }else{
//             $(".chkNo", table).each(function(){
//                 this.checked=false;
//             });
//         };
//     });
        var chkNo = $(".chkNo", table);
        $("#" +id).each(function(){
        if(this.checked==true){
            for(var i=0;i<chkNo.length;i++) {
                var $cbox = $(chkNo.get(i));
                if($cbox.attr("disabled") != "disabled") {
                	//$cbox.checked=true;
                	$cbox.attr("checked", true);
                	
                };
            };
        }else{
            $(".chkNo", table).each(function(){
                this.checked=false;
            });
        };
    });
        
};

erpG20CoCardList.save= function(resultData){
	
    $.ajax({
        type:"post",
        url:'<c:url value="/Ac/G20/Ex/setACardSungin.do" />',
        contentType: "application/x-www-form-urlencoded; charset=UTF-8",
        datatype:"json",
        //data: data,
         data: $("#subForm").serialize(),
         success:function(data){
        	 if(data.result > 0 ){
        		 alert("선택한리스트가 저장되었습니다.");
        		 var retVal   = new Object();
        		 retVal.apply_am  = data.abdocu_B.apply_am;
        		 retVal.divId  = 'ACardSunginPop';	
//         		 parent.window.returnValue = retVal;
//         		 parent.window.close();
                 retVal.abdocu_b_no = abdocu_b_no;
        		 parent.eval(callBack)(retVal);
        		 acLayerPopClose("ACardSunginPop");
             }else{
            	 alert("<%=BizboxAMessage.getMessage("TX000009919","선택한리스트를 저장 하는중 오류가 발생하였습니다")%>");	 
             }   
         },error:function(e){
             alert("<%=BizboxAMessage.getMessage("TX000009919","선택한리스트를 저장 하는중 오류가 발생하였습니다")%>");
         }
    });
    
};


function btnCancel(){
// 	var retVal   = new Object();
// 	retVal.divId  = divId;	 
	acLayerPopClose("ACardSunginPop");	
}
</script>
</head>
<!-- <body> -->
<div class="pop_wrap_dir" style="width:828px;" id="ACardSunginPop">
    <div class="pop_head">
        <h1><%=BizboxAMessage.getMessage("TX000005278","법인카드 승인내역")%></h1>
        <a href="#n" class="clo" onclick="btnCancel();"><img src="<c:url value='/Images/btn/btn_pop_clo02.png'/>" alt="" /></a>
    </div>    
    <div class="pop_con">      
        <div class="top_box" style="overflow:hidden;">
            
            <dl class="dl2">
                <dt><%=BizboxAMessage.getMessage("TX000000526","카드번호")%></dt>
                <dd class="mr0">
                        <input type="text" class="requirement" id="CARD_NB" style="width:149px;"/>
                        <a href="#n" class="search-Event-H"><img src="<c:url value='/Images/btn/btn_rightgo01.png'/>" alt="" /></a>
                        <input type="text" class=""id="CARD_NM" style="width:134px;"/>
                </dd>
            </dl>
            <dl class="dl2">
                <dt><%=BizboxAMessage.getMessage("TX000005457","승인일자")%></dt>
                <dd><input id="ISS_DT_FROM" value="${aCardVO.ISS_DT_FROM }" style="width:121px;" class="requirement"/> ~ <input id="ISS_DT_TO" value="${aCardVO.ISS_DT_TO }" style="width:121px;" class="requirement"/></dd>
                <dd><input type="button" onclick="javascript:erpG20CoCardList.CoCardAList();" id="searchButton" value="검색" /></dd>
            </dl>
        </div>
        
        <div class="h2_btn2">
            <h2><%=BizboxAMessage.getMessage("TX000009918","승인내역 조회리스트")%></h2>
            <div class="controll_btn">
                <button id=""  type="button" onclick="javascript:erpG20CoCardList.addSubRow();"><%=BizboxAMessage.getMessage("TX000000446","추가")%></button>
            </div>
        </div>        
<!--         <div class="erpPopCon mT5" style="border-bottom:none;"> -->
        <div class="com_ta2">
            <table>
			<colgroup>
				<col width="40">
				<col width="95">
				<col width="60">
				<col width="130">
				<col width="77">
				<col width="77">
				<col width="75">
				<col width="87">
				<col width="77">
				<col width="62">
				<col width="">
			</colgroup>
				<thead>
					<tr>
						<th></th>
						<th>승인일시</th>
						<th>번호</th>
						<th>가맹점명</th>
						<th>승인번호</th>
						<th>승인금액</th>
						<th>부가세</th>
						<th>할부개월수</th>
						<th>연동상태</th>
						<th>업종</th>
						<th>취소여부</th>
					</tr>
				</thead>
			</table>
        </div>  
        <div class="com_ta2 ova_sc cursor_p bg_lightgray" style="height: 111px;">
            <table id="coCardList">
	         	<colgroup>
					<col width="40">
					<col width="95">
					<col width="60">
					<col width="130">
					<col width="77">
					<col width="77">
					<col width="75">
					<col width="87">
					<col width="77">
					<col width="62">
					<col width="">
				</colgroup>
                <tbody>
                </tbody>
            </table>
        </div>
                        
        <div class="h2_btn2">
            <h2><%=BizboxAMessage.getMessage("TX000009916","승인내역 선택리스트")%></h2>
            <div class="controll_btn">
                <button id="" type="button" onclick="javascript:erpG20CoCardList.deleteSubRow();"><%=BizboxAMessage.getMessage("TX000000424","삭제")%></button>
            </div>
        </div>        
        <div class="com_ta2">
            <table>
                <colgroup>
                    <col width="40"/>
                    <col width="95" />
                    <col width="60" />
                    <col width="130"/>
                    <col width="77"/>
                    <col width="77"/>
                    <col width="75"/>
                    <col width="87"/>
                    <col width="77"/>
                    <col width="62"/>
                    <col width=""/>
                </colgroup>
                <thead>
                    <tr>
                        <th></th>
                        <th><%=BizboxAMessage.getMessage("TX000007536","승인일시")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000000603","번호")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000005309","가맹점명")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000005311","승인번호")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000005459","승인금액")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000000517","부가세")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000005460","할부개월수")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000005461","연동상태")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000005782","업종")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000009917","취소여부")%></th>
                    </tr>
                </thead>
            </table>
        </div>          
        <div class="com_ta2 ova_sc cursor_p bg_lightgray" style="height: 111px;">
            <form id="subForm" name="subForm" method="post" action="<c:url value='/Ac/G20/Ex/setACardSungin.do'/>">
            <input type="hidden" name="abdocu_no" value = "${aCardVO.abdocu_no}"/>
             <input type="hidden" name="abdocu_b_no" value ="${aCardVO.abdocu_b_no}"/>            
            <table id="coCardList_Sub">
                <colgroup>
                    <col width="40"/>
                    <col width="95" />
                    <col width="60" />
                    <col width="130"/>
                    <col width="77"/>
                    <col width="77"/>
                    <col width="75"/>
                    <col width="87"/>
                    <col width="77"/>
                    <col width="62"/>
                    <col width=""/>
                </colgroup>    
                <c:forEach var="result" items="${selectList}" varStatus="status">
                     <tr id="${result.PKEY}">
                        <td> <input type="checkbox" class="chkNo"/>
                                 <input type="hidden" name="strCARD_NB" value = "${result.CARD_NB}" />
                                 <input type="hidden" name="strISS_DT" value = "${result.ISS_DT}" />
                                 <input type="hidden" name="strISS_SQ" value = "${result.ISS_SQ}" />
                                 <input type="hidden" name="strCHAIN_NAME"  value = "${result.CHAIN_NAME}" />
                                 <input type="hidden" name="strCHAIN_REGNB"  value = "${result.CHAIN_REGNB}" />
                                 <input type="hidden" name="strSUNGIN_NB"  value = "${result.SUNGIN_NB}" />
                                 <input type="hidden" name="strSUNGIN_AM"  class="strSUNGIN_AM" value = "${result.SUNGIN_AM}" />
                                 <input type="hidden" name="strTOT_AM"  value = "${result.TOT_AM}" />
                                 <input type="hidden" name="strVAT_AM"  value = "${result.VAT_AM}" />
                                 <input type="hidden" name="strUSER_TYPE"  value = "${result.USER_TYPE}" />
                                 <input type="hidden" name="strGW_STATE"  value = "${result.GW_STATE}" />
                                 <input type="hidden" name="strGW_STATE_HAN"  value = "${result.GW_STATE_HAN}" />
                                 <input type="hidden" name="strPKEY"  value = "${result.PKEY}" />
                                 <input type="hidden" name="strCTR_CD"  value = "${result.CTR_CD}" />
                                 <input type="hidden" name="strCTR_NM"  value = "${result.CTR_NM}" />
                                 <input type="hidden" name="strADMIT_DT"  value = "${result.ADMIT_DT}" />
                                 <input type="hidden" name="strCHAIN_BUSINESS"  value = "${result.CHAIN_BUSINESS}" />
                                 <input type="hidden" name="strCANCEL_YN"  value = "${result.CANCEL_YN}" />
                        </td>
                        <td align="center" class="">${result.ISS_DT}</td>
                        <td align="center" class="">${result.ISS_SQ}</td>
                        <td align="center" class="">${result.CHAIN_NAME}</td>
                        <td align="center" class="">${result.SUNGIN_NB}</td>
                        <td align="center" class=""><fmt:formatNumber type="currency"  value="${result.TOT_AM}" currencySymbol="" /></td>
                        <td align="center" class=""><fmt:formatNumber type="currency"  value="${result.VAT_AM}" currencySymbol="" /></td>
                        <td align="center" class="">${result.USER_TYPE}</td>
                        <td align="center" class="" >${result.GW_STATE_HAN}</td>
                        <td align="center" class="" >${result.CHAIN_BUSINESS}</td>
                        <td align="center" class="" >${result.CANCEL_YN}</td>
                        </tr>
                   </c:forEach>                        
                        
            </table>
            </form>
        </div>    
        
    </div><!-- //pop_con -->

    <div class="pop_foot">
        <div class="btn_cen pt12">
            <input type="button" onclick="javascript:erpG20CoCardList.save();"   value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" />
            <input type="button" id="btnCancel" onclick="btnCancel()" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" />
        </div>
    </div><!-- //pop_foot -->
    
    </div><!-- //pop_wrap -->
<!-- </body> -->

<div id="dialog-form-CoCard" class="parent" style="display:none">
<div class="pop_wrap_dir" >
    <div class="pop_head">
        <h1></h1>
        <a href="#n" class="clo popClose"><img src="<c:url value='/Images/btn/btn_pop_clo02.png' />" alt="" /></a>
    </div>

    <div class="pop_con">   
        <div class="com_ta2 mt10 ova_sc_all cursor_p" style="height:340px;" id="dialog-form-CoCard-bind">
        </div>  
    </div><!-- //pop_con -->
</div><!-- //pop_wrap -->
</div>

<div id="dialog-form-background_CoCard" style="display:none; " class="erp-dialog-form-background"></div>
<!-- </html> -->
