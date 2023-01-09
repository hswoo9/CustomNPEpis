<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<jsp:useBean id="nowDate" class="java.util.Date" />
<fmt:formatDate value="${nowDate}" var="nowDate" pattern="yyyy-" />
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>농림수산식품교육문화정보원</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script type="text/javascript" src="/js/Scripts/jquery-1.9.1.min.js"></script>
<style>
@page {
    size: auto;  /* auto is the initial value */
    margin: 0;  /* this affects the margin in the printer settings */
}

td {
    height: 30px;
}
</style>
</head>
<body>
<div id="abc"></div>
<div class="pop_foot" style="width:630px">
	<div class="btn_cen pt12">
		<input type="button" class="printButton" value="인쇄" onclick="javascript:fnPrint();" />
		<input type="button" class="closeButton gray_btn" value="닫기" onclick="javascript:window.close();" />
	</div>
</div>
<script>

//console.log("${userInfo}");

//console.log("${result.erpCompName}");
//console.log("${result.erpType}");
//console.log("${result.payrpta}");
//console.log("${result.payrptb}");
//console.log("${result.payrptc}");
//console.log("${result.payrptd}");

var payment = new Array();
<c:forEach items="${result.payrptb}" var="payrptb">
payment.push({CO_CD: "${payrptb.CO_CD}"
	, PAY_AM: "${payrptb.PAY_AM}"
	, EMP_CD: "${payrptb.EMP_CD}"
	, PRIT_NM: "${payrptb.PRIT_NM}"
	, SQ: "${payrptb.SQ}"
});
</c:forEach>

var deduction = new Array();
<c:forEach items="${result.payrptc}" var="payrptc">
deduction.push({CO_CD: "${payrptc.CO_CD}"
	, DDCT_AM: "${payrptc.DDCT_AM}"
	, EMP_CD: "${payrptc.EMP_CD}"
	, PRIT_NM: "${payrptc.PRIT_NM}"
	, SQ: "${payrptc.SQ}"
});
</c:forEach>

//console.log(payment);
//console.log(deduction);
//console.log("${param}");


//console.log("workingDays");
//console.log("${workingDays}");
//console.log("yetWorkingDays");
//console.log("${yetWorkingDays}");
//console.log("annualDays");
//console.log("${annualDays}");
//console.log("OverWork");
//console.log("${OverWork}");
//console.log("selectDalmMonthList");
//console.log("${selectDalmMonthList}");

var ATT_TIME1 = "${selectDalmMonthList[0].ATT_TIME1}" - 0;
var ATT_TIME2 = "${selectDalmMonthList[0].ATT_TIME2}" - 0;
var ATT_TIME3 = "${selectDalmMonthList[0].ATT_TIME3}" - 0;
var ATT_TIME4 = "${selectDalmMonthList[0].ATT_TIME4}" - 0;
var ATT_TIME5 = "${selectDalmMonthList[0].ATT_TIME5}" - 0;

var ATT_TIME_SUM = 0;
ATT_TIME_SUM = ATT_TIME1 + ATT_TIME2 + ATT_TIME3 + ATT_TIME4 + ATT_TIME5;
ATT_TIME_SUM = Math.round(ATT_TIME_SUM*1000)/1000;
var ATT_TIME_AVG = 0;
ATT_TIME_AVG = ATT_TIME_SUM / 5;
ATT_TIME_AVG = Math.round(ATT_TIME_AVG*1000)/1000;

var mList = new Array();
<c:forEach items="${OverWork}" var="mList">
mList.push({W_TIME_TUE_01: "${mList.W_TIME_TUE_01}" - 0
	, OT_TYPE_CODE: "${mList.OT_TYPE_CODE}"
	, SANCTION: "${mList.SANCTION}"
});
</c:forEach>

//console.log("mList");
//console.log(mList);

var contWorkTime = 0; //연장
var vacWorkTime = 0; //휴일
var dinWorkTime = 0; //야간

for (var i = 0; i < mList.length; i++) {
	if (mList[i].OT_TYPE_CODE == "A1501") {
		contWorkTime += mList[i].W_TIME_TUE_01;
	}else if (mList[i].OT_TYPE_CODE == "A1502" || mList[i].OT_TYPE_CODE == "A1504") {
		vacWorkTime += mList[i].W_TIME_TUE_01;
	}else if (mList[i].OT_TYPE_CODE == "A1503") {
		dinWorkTime += mList[i].W_TIME_TUE_01;
	}
}



$(document).ready(function() {
	dataSet();
});

function dataSet() {
	var payment_sum = 0;
	var deduction_sum = 0;
	var net_annual_salary = 0;
	
	for (var i = 0; i < payment.length; i++) {
		$("#payment"+(i+1)+"Nm").text(payment[i].PRIT_NM);
		if(Number(payment[i].PAY_AM == 0)) {
			$("#payment"+(i+1)+"Val").text("");
		}else {
			$("#payment"+(i+1)+"Val").text(numberWithCommas(payment[i].PAY_AM));
		}
		payment_sum += Number(payment[i].PAY_AM);
	}
	for (var j = 0; j < deduction.length; j++) {
		$("#deduction"+(j+1)+"Nm").text(deduction[j].PRIT_NM);
		if(Number(deduction[j].DDCT_AM == 0)) {
			$("#deduction"+(j+1)+"Val").text("");
		}else {
			$("#deduction"+(j+1)+"Val").text(numberWithCommas(deduction[j].DDCT_AM));
		}
		deduction_sum += Number(deduction[j].DDCT_AM);
	}
	
	//console.log(payment_sum);
	//console.log(deduction_sum);
	
	$("#payment_sum").text(numberWithCommas(payment_sum));
	$("#deduction_sum").text(numberWithCommas(deduction_sum));
	$("#net_annual_salary").text(numberWithCommas(payment_sum - deduction_sum));
}

var html = '';
html = '<div style="page-break-before:always; display:block;">'
    + '<table style="page-break-inside:avoid;display:block; border: 1px solid #eaeaea; width:630px;">'
	+ ' <tr>';
	var YM = "${param.YM}";
	var year = YM.substr(0, 4);
	var month = YM.substr(4, 2);
	
	//var Dday = new Date(year, month, 0);
	
	//month = month -1;
	//if(month == 0) {
	//	year = year - 1;
	//	month = 12;
	//}
	//var Yday = new Date(year, month, 0);
	
	//var Dcount = Dday.getDate();
	//var Ycount = Yday.getDate();
	
	html	+= '     <th colspan="10" style="width:630px; height: 50px; padding: 5px 0; color: #4a4a4a; border-bottom: 1px solid #eaeaea; border-width: 0 0 1px 1px; background: #f9fafc; font-weight: normal; text-align: center; margin-bottom: 10px; margin-top:20px;"><h3 style="font-size: 16px;"><b>'+year+'년 '+month+'월 급여(상여)명세서</b></h3></th>'
	+ ' </tr>'
	+ ' <tr>'
	+ '     <td colspan="10" style="width:630px; height:30px; font-size:13px; text-align:right; border-bottom: 1px solid #eaeaea;"><pre>지급일: '+getDateFormatReturnHi('2', '${param.DT_PAY}', '')+'('+dayOfWeek(getDateFormatReturnHi('2', '${param.DT_PAY}', ''))+')</pre></td>'
	+ ' </tr>'
	+ '	<tr>'
	+ '		<th colspan="2" style="width:126px; height: 20px; text-align:center;padding: 5px 0; color: #4a4a4a; border-bottom: 1px solid #eaeaea; border-width: 0 0 1px 1px; background: #f9fafc; font-weight: normal;">사번</th>'
	+ '		<th colspan="1" style="width:63px; height: 20px; text-align:center;padding: 5px 0; color: #4a4a4a; border: 1px solid #eaeaea; border-width: 0 0 1px 1px; background: #f9fafc; font-weight: normal;">성명</th>'
	+ '		<th colspan="2" style="width:126px; height: 20px; text-align:center;padding: 5px 0; color: #4a4a4a; border: 1px solid #eaeaea; border-width: 0 0 1px 1px; background: #f9fafc; font-weight: normal;">부서</th>'
	+ '		<th colspan="1" style="width:63px; height: 20px; text-align:center;padding: 5px 0; color: #4a4a4a; border: 1px solid #eaeaea; border-width: 0 0 1px 1px; background: #f9fafc; font-weight: normal;">직급</th>'
	+ '		<th colspan="1" style="width:63px; height: 20px; text-align:center;padding: 5px 0; color: #4a4a4a; border: 1px solid #eaeaea; border-width: 0 0 1px 1px; background: #f9fafc; font-weight: normal;">직책</th>'
	+ '		<th colspan="2" style="width:126px; height: 20px;text-align:center; padding: 5px 0; color: #4a4a4a; border: 1px solid #eaeaea; border-width: 0 0 1px 1px; background: #f9fafc; font-weight: normal;">입사일자</th>'
          + '		<th colspan="1" style="width:63px; height: 20px;text-align:center; padding: 5px 0; color: #4a4a4a; border: 1px solid #eaeaea; border-width: 0 0 1px 1px; background: #f9fafc; font-weight: normal;">직무</th>'
	+ '	</tr>'
	+ '	<tr>'
	+ '		<td colspan="2" style="width:126px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;">${userInfo.erpEmpCd}</td>'
	+ '		<td colspan="1" style="width:63px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;">${userInfo.name}</td>'
	+ '		<td colspan="2" style="width:126px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;">${userInfo.orgnztNm}</td>'
	+ '		<td colspan="1" style="width:63px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;">${userInfo.positionNm}</td>'
	+ '		<td colspan="1" style="width:63px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea; border-bottom: 1px solid #eaeaea;">${userInfo.classNm}</td>'
          + '		<td colspan="2" style="width:126px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea; border-bottom: 1px solid #eaeaea;">${joinDay.join_day}</td>'
          + '		<td colspan="1" style="width:63px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea; border-right: 1px solid #eaeaea; border-bottom: 1px solid #eaeaea;"> </td>'
	+ '	</tr>'
    //      + '	<tr>'
	//+ '		<th colspan="10" style="width:630px; height: 20px; text-align:center;padding: 5px 0; color: #4a4a4a; border-bottom: 1px solid #eaeaea; border-width: 0 0 1px 1px; background: #f9fafc; font-weight: normal;">근무일수 및 근무시간 상세내역</th>'
	//+ '	</tr>'
    //      + '	<tr>'
	//+ '		<th colspan="2" style="width:126px; height: 20px; text-align:center;padding: 5px 0; color: #4a4a4a; border-bottom: 1px solid #eaeaea; border-width: 0 0 1px 1px; background: #f9fafc; font-weight: normal;">당월 근무 내역</th>'
	//+ '		<th colspan="2" style="width:126px; height: 20px; text-align:center;padding: 5px 0; color: #4a4a4a; border: 1px solid #eaeaea; border-width: 0 0 1px 1px; background: #f9fafc; font-weight: normal;">전월 근무 내역</th>'
	//+ '		<th colspan="1" rowspan="2" style="width:63px; height: 20px; text-align:center;padding: 5px 0; color: #4a4a4a; border: 1px solid #eaeaea; border-width: 0 0 1px 1px; background: #f9fafc; font-weight: normal;">연차일수</th>'
	//+ '		<th colspan="2" rowspan="2" style="width:126px; height: 20px; text-align:center;padding: 5px 0; color: #4a4a4a; border: 1px solid #eaeaea; border-width: 0 0 1px 1px; background: #f9fafc; font-weight: normal;">주당근무시간</th>'
	//+ '		<th colspan="3" style="width:189px; height: 20px; text-align:center;padding: 5px 0; color: #4a4a4a; border: 1px solid #eaeaea; border-width: 0 0 1px 1px; background: #f9fafc; font-weight: normal;">시간외 근무시간</th>'
	//+ '	</tr>'
    //      + '	<tr>'
	//+ '		<th colspan="1" style="width:63px; height: 20px; text-align:center;padding: 5px 0; color: #4a4a4a; border-bottom: 1px solid #eaeaea; border-width: 0 0 1px 1px; background: #f9fafc; font-weight: normal;">일수</th>'
	//+ '		<th colspan="1" style="width:63px; height: 20px; text-align:center;padding: 5px 0; color: #4a4a4a; border: 1px solid #eaeaea; border-width: 0 0 1px 1px; background: #f9fafc; font-weight: normal;">근무일수</th>'
	//+ '		<th colspan="1" style="width:63px; height: 20px; text-align:center;padding: 5px 0; color: #4a4a4a; border: 1px solid #eaeaea; border-width: 0 0 1px 1px; background: #f9fafc; font-weight: normal;">일수</th>'
	//+ '		<th colspan="1" style="width:63px; height: 20px; text-align:center;padding: 5px 0; color: #4a4a4a; border: 1px solid #eaeaea; border-width: 0 0 1px 1px; background: #f9fafc; font-weight: normal;">근무일수</th>'
	//+ '		<th colspan="1" style="width:63px; height: 20px; text-align:center;padding: 5px 0; color: #4a4a4a; border: 1px solid #eaeaea; border-width: 0 0 1px 1px; background: #f9fafc; font-weight: normal;">연장근로</th>'
    //      + '		<th colspan="1" style="width:63px; height: 20px; text-align:center;padding: 5px 0; color: #4a4a4a; border: 1px solid #eaeaea; border-width: 0 0 1px 1px; background: #f9fafc; font-weight: normal;">휴일근로</th>'
    //      + '		<th colspan="1" style="width:63px; height: 20px; text-align:center;padding: 5px 0; color: #4a4a4a; border: 1px solid #eaeaea; border-width: 0 0 1px 1px; background: #f9fafc; font-weight: normal;">야간근로</th>'
	//+ '	</tr>'
    //      + '	<tr>'
	//+ '		<td colspan="1" style="width:63px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;">'+Dcount+'</td>'
	//+ '		<td colspan="1" style="width:63px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;">${workingDays.DAYS}</td>'
	//+ '		<td colspan="1" style="width:63px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;">'+Ycount+'</td>'
    //      + '		<td colspan="1" style="width:63px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;">${yetWorkingDays.DAYS}</td>'
	//+ '		<td colspan="1" style="width:63px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;">${annualDays.DAYS}</td>'
	//+ '		<td colspan="1" style="width:63px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;">'+ATT_TIME_SUM+'</td>'
	//+ '		<td colspan="1" style="width:63px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;">'+ATT_TIME_AVG+'</td>'
	//+ '		<td colspan="1" style="width:63px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;">'+contWorkTime+'</td>'
	//+ '		<td colspan="1" style="width:63px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;">'+vacWorkTime+'</td>'
    //      + '		<td colspan="1" style="width:63px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea; border-right: 1px solid #eaeaea; border-bottom: 1px solid #eaeaea;">'+dinWorkTime+'</td>'
	//+ '	</tr>'
          + '	<tr>'
	+ '		<th colspan="10" style="width:630px; height: 20px; text-align:center;padding: 5px 0; color: #4a4a4a; border-bottom: 1px solid #eaeaea; border-width: 0 0 1px 1px; background: #f9fafc; font-weight: normal;">세부내역</th>'
	+ '	</tr>'
          + '	<tr>'
	+ '		<th colspan="5" style="width:315px; height: 20px; text-align:center;padding: 5px 0; color: #4a4a4a; border-bottom: 1px solid #eaeaea; border-width: 0 0 1px 1px; background: #f9fafc; font-weight: normal;">지급내역</th>'
	+ '		<th colspan="5" style="width:315px; height: 20px; text-align:center;padding: 5px 0; color: #4a4a4a; border: 1px solid #eaeaea; border-width: 0 0 1px 1px; background: #f9fafc; font-weight: normal;">공제내역</th>'
	+ '	</tr>'
          + '	<tr>'
	+ '		<th colspan="3" style="width:189px; height: 20px; text-align:center;padding: 5px 0; color: #4a4a4a; border-bottom: 1px solid #eaeaea; border-width: 0 0 1px 1px; background: #f9fafc; font-weight: normal;">항목</th>'
	+ '		<th colspan="2" style="width:126px; height: 20px; text-align:center;padding: 5px 0; color: #4a4a4a; border: 1px solid #eaeaea; border-width: 0 0 1px 1px; background: #f9fafc; font-weight: normal;">금액(원)</th>'
	+ '		<th colspan="3" style="width:189px; height: 20px; text-align:center;padding: 5px 0; color: #4a4a4a; border: 1px solid #eaeaea; border-width: 0 0 1px 1px; background: #f9fafc; font-weight: normal;">항목</th>'
	+ '		<th colspan="2" style="width:126px; height: 20px; text-align:center;padding: 5px 0; color: #4a4a4a; border: 1px solid #eaeaea; border-width: 0 0 1px 1px; background: #f9fafc; font-weight: normal;">금액(원)</th>'
	+ '	</tr>'
          + '	<tr>'
	+ '		<td colspan="3" style="width:189px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="payment1Nm"></td>'
	+ '		<td colspan="2" style="width:126px; text-align:right;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="payment1Val"></td>'
	+ '		<td colspan="3" style="width:189px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="deduction1Nm"></td>'
    + '		<td colspan="2" style="width:126px; text-align:right;color: #4a4a4a; border-left: 1px solid #eaeaea; border-right: 1px solid #eaeaea; border-bottom: 1px solid #eaeaea;" id="deduction1Val"></td>'
	+ '	</tr>'
          + '	<tr>'
	+ '		<td colspan="3" style="width:189px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="payment2Nm"></td>'
	+ '		<td colspan="2" style="width:126px; text-align:right;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="payment2Val"></td>'
	+ '		<td colspan="3" style="width:189px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="deduction2Nm"></td>'
    + '		<td colspan="2" style="width:126px; text-align:right;color: #4a4a4a; border-left: 1px solid #eaeaea; border-right: 1px solid #eaeaea; border-bottom: 1px solid #eaeaea;" id="deduction2Val"></td>'
	+ '	</tr>'
          + '	<tr>'
	+ '		<td colspan="3" style="width:189px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="payment3Nm"></td>'
	+ '		<td colspan="2" style="width:126px; text-align:right;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="payment3Val"></td>'
	+ '		<td colspan="3" style="width:189px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="deduction3Nm"></td>'
    + '		<td colspan="2" style="width:126px; text-align:right;color: #4a4a4a; border-left: 1px solid #eaeaea; border-right: 1px solid #eaeaea; border-bottom: 1px solid #eaeaea;" id="deduction3Val"></td>'
	+ '	</tr>'
          + '	<tr>'
	+ '		<td colspan="3" style="width:189px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="payment4Nm"></td>'
	+ '		<td colspan="2" style="width:126px; text-align:right;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="payment4Val"></td>'
	+ '		<td colspan="3" style="width:189px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="deduction4Nm"></td>'
    + '		<td colspan="2" style="width:126px; text-align:right;color: #4a4a4a; border-left: 1px solid #eaeaea; border-right: 1px solid #eaeaea; border-bottom: 1px solid #eaeaea;" id="deduction4Val"></td>'
	+ '	</tr>'
          + '	<tr>'
	+ '		<td colspan="3" style="width:189px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="payment5Nm"></td>'
	+ '		<td colspan="2" style="width:126px; text-align:right;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="payment5Val"></td>'
	+ '		<td colspan="3" style="width:189px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="deduction5Nm"></td>'
    + '		<td colspan="2" style="width:126px; text-align:right;color: #4a4a4a; border-left: 1px solid #eaeaea; border-right: 1px solid #eaeaea; border-bottom: 1px solid #eaeaea;" id="deduction5Val"></td>'
	+ '	</tr>'
          + '	<tr>'
	+ '		<td colspan="3" style="width:189px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="payment6Nm"></td>'
	+ '		<td colspan="2" style="width:126px; text-align:right;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="payment6Val"></td>'
	+ '		<td colspan="3" style="width:189px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="deduction6Nm"></td>'
    + '		<td colspan="2" style="width:126px; text-align:right;color: #4a4a4a; border-left: 1px solid #eaeaea; border-right: 1px solid #eaeaea; border-bottom: 1px solid #eaeaea;" id="deduction6Val"></td>'
	+ '	</tr>'
          + '	<tr>'
	+ '		<td colspan="3" style="width:189px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="payment7Nm"></td>'
	+ '		<td colspan="2" style="width:126px; text-align:right;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="payment7Val"></td>'
	+ '		<td colspan="3" style="width:189px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="deduction7Nm"></td>'
    + '		<td colspan="2" style="width:126px; text-align:right;color: #4a4a4a; border-left: 1px solid #eaeaea; border-right: 1px solid #eaeaea; border-bottom: 1px solid #eaeaea;" id="deduction7Val"></td>'
	+ '	</tr>'
          + '	<tr>'
	+ '		<td colspan="3" style="width:189px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="payment8Nm"></td>'
	+ '		<td colspan="2" style="width:126px; text-align:right;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="payment8Val"></td>'
	+ '		<td colspan="3" style="width:189px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="deduction8Nm"></td>'
    + '		<td colspan="2" style="width:126px; text-align:right;color: #4a4a4a; border-left: 1px solid #eaeaea; border-right: 1px solid #eaeaea; border-bottom: 1px solid #eaeaea;" id="deduction8Val"></td>'
	+ '	</tr>'
          + '	<tr>'
	+ '		<td colspan="3" style="width:189px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="payment9Nm"></td>'
	+ '		<td colspan="2" style="width:126px; text-align:right;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="payment9Val"></td>'
	+ '		<td colspan="3" style="width:189px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="deduction9Nm"></td>'
    + '		<td colspan="2" style="width:126px; text-align:right;color: #4a4a4a; border-left: 1px solid #eaeaea; border-right: 1px solid #eaeaea; border-bottom: 1px solid #eaeaea;" id="deduction9Val"></td>'
	+ '	</tr>'
          + '	<tr>'
	+ '		<td colspan="3" style="width:189px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="payment10Nm"></td>'
	+ '		<td colspan="2" style="width:126px; text-align:right;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="payment10Val"></td>'
	+ '		<td colspan="3" style="width:189px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="deduction10Nm"></td>'
    + '		<td colspan="2" style="width:126px; text-align:right;color: #4a4a4a; border-left: 1px solid #eaeaea; border-right: 1px solid #eaeaea; border-bottom: 1px solid #eaeaea;" id="deduction10Val"></td>'
	+ '	</tr>'
          + '	<tr>'
	+ '		<td colspan="3" style="width:189px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="payment11Nm"></td>'
	+ '		<td colspan="2" style="width:126px; text-align:right;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="payment11Val"></td>'
	+ '		<td colspan="3" style="width:189px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="deduction11Nm"></td>'
    + '		<td colspan="2" style="width:126px; text-align:right;color: #4a4a4a; border-left: 1px solid #eaeaea; border-right: 1px solid #eaeaea; border-bottom: 1px solid #eaeaea;" id="deduction11Val"></td>'
	+ '	</tr>'
          + '	<tr>'
	+ '		<td colspan="3" style="width:189px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="payment12Nm"></td>'
	+ '		<td colspan="2" style="width:126px; text-align:right;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="payment12Val"></td>'
	+ '		<td colspan="3" style="width:189px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="deduction12Nm"></td>'
    + '		<td colspan="2" style="width:126px; text-align:right;color: #4a4a4a; border-left: 1px solid #eaeaea; border-right: 1px solid #eaeaea; border-bottom: 1px solid #eaeaea;" id="deduction12Val"></td>'
	+ '	</tr>'
          + '	<tr>'
	+ '		<td colspan="3" style="width:189px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="payment13Nm"></td>'
	+ '		<td colspan="2" style="width:126px; text-align:right;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="payment13Val"></td>'
	+ '		<td colspan="3" style="width:189px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="deduction13Nm"></td>'
    + '		<td colspan="2" style="width:126px; text-align:right;color: #4a4a4a; border-left: 1px solid #eaeaea; border-right: 1px solid #eaeaea; border-bottom: 1px solid #eaeaea;" id="deduction13Val"></td>'
	+ '	</tr>'
          + '	<tr>'
	+ '		<td colspan="3" style="width:189px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="payment14Nm"></td>'
	+ '		<td colspan="2" style="width:126px; text-align:right;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="payment14Val"></td>'
	+ '		<td colspan="3" style="width:189px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="deduction14Nm"></td>'
    + '		<td colspan="2" style="width:126px; text-align:right;color: #4a4a4a; border-left: 1px solid #eaeaea; border-right: 1px solid #eaeaea; border-bottom: 1px solid #eaeaea;" id="deduction14Val"></td>'
	+ '	</tr>'
          + '	<tr>'
	+ '		<td colspan="3" style="width:189px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="payment15Nm"></td>'
	+ '		<td colspan="2" style="width:126px; text-align:right;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="payment15Val"></td>'
	+ '		<td colspan="3" style="width:189px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="deduction15Nm"></td>'
    + '		<td colspan="2" style="width:126px; text-align:right;color: #4a4a4a; border-left: 1px solid #eaeaea; border-right: 1px solid #eaeaea; border-bottom: 1px solid #eaeaea;" id="deduction15Val"></td>'
	+ '	</tr>'
          + '	<tr>'
	+ '		<td colspan="3" style="width:189px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="payment16Nm"></td>'
	+ '		<td colspan="2" style="width:126px; text-align:right;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="payment16Val"></td>'
	+ '		<td colspan="3" style="width:189px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="deduction16Nm"></td>'
    + '		<td colspan="2" style="width:126px; text-align:right;color: #4a4a4a; border-left: 1px solid #eaeaea; border-right: 1px solid #eaeaea; border-bottom: 1px solid #eaeaea;" id="deduction16Val"></td>'
	+ '	</tr>'
          + '	<tr>'
	+ '		<td colspan="3" style="width:189px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea; background: #f9fafc;">지급합계</td>'
	+ '		<td colspan="2" style="width:126px; text-align:right;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;" id="payment_sum"></td>'
	+ '		<td colspan="3" style="width:189px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea; background: #f9fafc;">공제합계</td>'
          + '		<td colspan="2" style="width:126px; text-align:right;color: #4a4a4a; border-left: 1px solid #eaeaea; border-right: 1px solid #eaeaea; border-bottom: 1px solid #eaeaea;" id="deduction_sum"></td>'
	+ '	</tr>'
          + '	<tr>'
	+ '		<td colspan="8" style="width:504px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea; background: #f9fafc;">실 수 령 액(원)</td>'
          + '		<td colspan="2" style="width:126px; text-align:right;color: #4a4a4a; border-left: 1px solid #eaeaea; border-right: 1px solid #eaeaea; border-bottom: 1px solid #eaeaea;" id="net_annual_salary"></td>'
	+ '	</tr>'
          + '	<tr>'
	+ '		<th colspan="2" style="width:126px; height: 20px; text-align:center;padding: 5px 0; color: #4a4a4a; border-bottom: 1px solid #eaeaea; border-width: 0 0 1px 1px; background: #f9fafc; font-weight: normal;">구분</th>'
	+ '		<th colspan="8" style="width:504px; height: 20px; text-align:center;padding: 5px 0; color: #4a4a4a; border: 1px solid #eaeaea; border-width: 0 0 1px 1px; background: #f9fafc; font-weight: normal;">지급항목  산출식 및 산출방법</th>'
	+ '	</tr>'
          + '	<tr>'
	+ '		<td colspan="2" style="width:126px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;">연봉월액</td>'
	+ '		<td colspan="8" style="width:504px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;">연봉 / 12개월 / 당월일수 *  당월 근무일수</td>'
	+ '	</tr>'
          + '	<tr>'
	+ '		<td colspan="2" style="width:126px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;">급여소급분</td>'
	+ '		<td colspan="8" style="width:504px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;">계약연봉 대비 차액, 전월 복직자 및 퇴사자 기본급 미반영분</td>'
	+ '	</tr>'
          + '	<tr>'
	+ '		<td colspan="2" style="width:126px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;">직무급</td>'
	+ '		<td colspan="8" style="width:504px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;">농정원 보수규정 및 보수시행규칙 규정에 따름 </td>'
	+ '	</tr>'
          + '	<tr>'
	+ '		<td colspan="2" style="width:126px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;">가족수당</td>'
	+ '		<td colspan="8" style="width:504px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea; font-size: 11px;">배우자 4만원, 첫째자녀 2만원, 둘째자녀 6만원, 셋째자녀 10만원, 그 외 직계가족 1인당 2만원</td>'
	+ '	</tr>'
          + '	<tr>'
          + '		<td colspan="1" rowspan="3" style="width:50px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;">시간 외 근무수당</td>'
	+ '		<td colspan="1" style="width:63px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;">연장근로</td>'
	+ '		<td colspan="8" rowspan="3" style="width:504px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;">근로기준법 및 농정원 보수시행규칙 규정에 따름</td>'
	+ '	</tr>'
          + '	<tr>'
	+ '		<td colspan="1" style="width:63px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;">휴일근로</td>'
	+ '	</tr>'
          + '	<tr>'
	+ '		<td colspan="1" style="width:63px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;">야간근로</td>'
	+ '	</tr>'
          + '	<tr>'
	+ '		<td colspan="2" style="width:126px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;">연차수당</td>'
	+ '		<td colspan="8" style="width:504px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;">통상임금 * 1 / 209 * 8시간 * 해당일수</td>'
	+ '	</tr>'
          + '	<tr>'
	+ '		<td colspan="2" style="width:126px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;">직무성과급</td>'
	+ '		<td colspan="8" style="width:504px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;">농정원 보수규정 및 보수시행규칙 규정에 따름</td>'
	+ '	</tr>'
          + '	<tr>'
	+ '		<td colspan="2" style="width:126px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;">경영평가성과급</td>'
	+ '		<td colspan="8" style="width:504px; text-align:center;color: #4a4a4a; border-left: 1px solid #eaeaea;border-bottom: 1px solid #eaeaea;">농정원 보수규정 및 보수시행규칙 규정에 따름</td>'
	+ '	</tr>'
	+ '</table>';
$("#abc").append(html);

function numberWithCommas(num) {
	if (!num) {
		return 0;
	}
	
	return Math.floor(num).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

//인쇄하기
function fnPrint() {
	$("#pop_foot").hide();
	$(".printButton").hide();
	$(".closeButton").hide();
	$('td').css('height', '15px');
	//브라우저별분기처리
	if (getInternetExplorerVersion() > -1) {
		//IE6,IE7,IE8,IE9,IE10,IE11
		try {
			if (mode == "P") {
				window.print();
			} else {
				var webBrowser = '<OBJECT ID="previewWeb" WIDTH=0 HEIGHT=0 CLASSID="CLSID:8856F961-340A-11D0-A96B-00C04FD705A2"></OBJECT>';
				document.body.insertAdjacentHTML('beforeEnd', webBrowser);
				
				//(6:인쇄/7:미리보기/8:페이지 설정)
				previewWeb.ExecWB(7, 1);
				previewWeb.outerHTML = "";
			}
			
			self.close();
		} catch (e) {
		}
	} else {
		//Edge,크롬,사파리,파이어폭스,오페라
		window.print();
		self.close();
	}
}

//브라우저체크 (-1이상이면 IE이다)
function getInternetExplorerVersion() {
	var rv = -1;
	
	if (navigator.appName == 'Microsoft Internet Explorer') {
		var ua = navigator.userAgent;
		var re = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");
		
		if (re.exec(ua) != null) {
			rv = parseFloat(RegExp.$1);
		}
	} else if (navigator.appName == 'Netscape') {
		var ua = navigator.userAgent;
		var re = new RegExp("Trident/.*rv:([0-9]{1,}[\.0-9]{0,})");
		
		if (re.exec(ua) != null) {
			rv = parseFloat(RegExp.$1);
		}
	}
	
	return rv;
}

function getDateFormatReturnHi(dateDiv, val, subStr) {	
	return val.substring(0,4) + "-" + val.substring(4,6) + "-" + val.substring(6,8);
}

function dayOfWeek(val) {	
	var week = ['일', '월', '화', '수', '목', '금', '토'];
	return dayOfWeek = week[new Date(val).getDay()];
}
</script>
</body>
</html>