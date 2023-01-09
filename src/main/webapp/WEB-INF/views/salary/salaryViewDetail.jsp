<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<jsp:useBean id="nowDate" class="java.util.Date" />
<fmt:formatDate value="${nowDate}" var="nowDate" pattern="yyyy-" />

<script type="text/javascript" src='<c:url value="/js/ac/acUtil.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/common/outProcessUtil.js"></c:url>'></script>

<style type="text/css">
.k-header .k-link {
	text-align: center;
}

.k-grid-content>table>tbody>tr {
	text-align: center;
}

.k-grid th.k-header, .k-grid-header {
	background: #F0F6FD;
}

.k-grid tbody tr {
	cursor: default;
}
.blueColor { color : blue; }
.onFont { font-weight : bold; color : green; }

html:first-child select {
    height: 24px;
    padding-right: 6px;
}

.com_ta table {
    width: 100%;
}

.top_box input[type="button"]:hover {
    background: #0876c9;
    border: none;
}

.top_box input[type="button"] {
    background: #1088e3;
    height: 24px;
    padding: 0 11px;
    color: #fff;
    border: none;
    font-weight: bold;
    border-radius: 0px;
}

.k-pager-info {
	display: none;
}
</style>

<div class="iframe_wrap" style="min-width: 1100px">
<form id="outProcessFormData" action="http://211.192.144.104/gw/outProcessLogOn.do" target="outProcessLogOn"></form>
<input type="hidden" id="loginId" value="${loginVO.id }" />
	<!-- 컨텐츠타이틀영역 -->
	<div class="sub_title_wrap">
		<div class="title_div">
			<h4>급여명세서</h4>
		</div>
	</div>
	<div class="sub_contents_wrap">
		<div class="top_box">
			<dl>
				<dt class="ar" style="width: 55px">기간</dt>
				<dd>
					<input type="text" value="" name="" id="startDay" placeholder="" />
					&nbsp;~ 
					<input type="text" value="" name="" id="endDay" placeholder="" />
					<input type="button" id="" onclick="gridReload();" value="검색"/>
				</dd>
			</dl>
		</div>
		<form id="hrPayLipPop" name="hrPayLipPop" method="post" action="<c:url value='/salary/hrPayLipPop'/>" target="hrPayLipPop">
			<input name="YM" value="" type="hidden"/>
			<input name="DT_PAY" value="" type="hidden"/>
			<input name="TP_REPORT" value="" type="hidden"/>
			<input name="TP_PAY" value="" type="hidden"/>
			<input name="NO_SEQ" value="" type="hidden"/>
			<input name="hrOption" value="" type="hidden"/>
			<input name="NM_TITLE" value="" type="hidden"/>
		</form>
		<div class="com_ta mt20">
			<table>
				<colgroup>
					<col width="150"/>
					<col width=""/>
					<col width="150"/>
					<col width=""/>
					<col width="150"/>
					<col width=""/>
				</colgroup>
				<tr>
					<th>부서</th>
					<td>${userInfo.orgnztNm}</td>
					<th>사번</th>
					<td>${userInfo.erpEmpCd}</td>
					<th>입사일자</th>
					<td>${joinDay.join_day}</td>
				</tr>
				<tr>
					<th>직책</th>
					<td>${userInfo.classNm}</td>
					<th>직급</th>
					<td>${userInfo.positionNm}</td>
					<th>성명</th>
					<td>${userInfo.name}</td>
				</tr>
				<tr id="paySumArea" style="display: none">
					<th></th>
					<td></td>
					<th>지급총액</th>
					<td><span id="allPaySum">0</span></td>
					<th>차감지급액</th>
					<td><span id="deductPaySum">0</span></td>
				</tr>
			</table>
		</div>
		<p class="lh20 mt20">※ 급여명세서는 목록을 클릭하시면 확인하실 수 있습니다.</p>
		<div class="com_ta2 mt15">
			<div id="grid"></div>
		</div>
	</div>
</div>
<script type="text/javascript">
console.log("${userInfo}");
$(document).ready(function() {
	dataSet();
	mainGrid();
});

var record = 0;

//메인그리드
function mainGrid() {
	//캔도 그리드 기본
	var grid = $("#grid").kendoGrid({
		dataSource : dataSource, 
		height : 500,
		sortable: true,
		pageable: {
			refresh: true,
			pageSize : 10,
			pageSizes: [10, 20, 50, "ALL"],
			buttonCount: 5
		},
		persistSelection : true,
		columns : [
			{
				title : "번호",
				width : 5,
				template: "#= ++record #"
			},
			{
				field : "YM",
				title : "귀속년월",
				width : 20,
				widthUnit : "%",
				template : function(rowData) {
					return getDateFormatReturn('1', rowData.YM, rowData.NO_SEQ);
				}
			},
			{
				field : "DT_PAY",
				title : "지급일자",
				width : 20,
				widthUnit : "%",
				template : function(rowData) {
					return getDateFormatReturnHi('2', rowData.DT_PAY, '');
				}
			},
			{
				field : "NM_TP_PAY",
				title : "급여구분",
				width : 10,
				widthUnit : "%",
				template : function(rowData) {
					return getDiffReturn(rowData.TITLE_NM, rowData.NM_TP_PAY);
				}
			},
			{
				field : "AM_PAY_SUM",
				title : "지급총액",
				width : 15,
				widthUnit : "%",
				attributes : { style : "text-align:right" },
				template : function(rowData) {
					return numberWithCommas(rowData.AM_PAY_SUM);
				}
			},
			{
				field : "AM_DEDUCT_SUM",
				title : "공제총액",
				width : 15,
				widthUnit : "%",
				attributes : { style : "text-align:right" },
				template : function(rowData) {
					return numberWithCommas(rowData.AM_DEDUCT_SUM);
				}
			},
			{
				field : "AM_PAY_DEDUCT",
				title : "차감지급액",
				width : 15,
				widthUnit : "%",
				attributes : { style : "text-align:right" },
				template : function(rowData) {
					return numberWithCommas(rowData.AM_PAY_DEDUCT);
				}
			}
		],
		dataBinding : function() {
			record = 0;
		},
		noDataMessage : {
			message : "데이터가 존재하지 않습니다."
		},
		progressBar : {
			progressType : "loading",
			attributes : {style:"width:70px; height:70px;"},
			strokeColor : "#84c9ff",	// progress 색상
			strokeWidth : "3px",	// progress 두께
			percentText : "loading",	// loading 표시 문자열 설정 - progressType loading 인 경우만
			percentTextColor : "#84c9ff",
			percentTextSize : "12px"
		},
		dataBound: onDataBound
	}).data("kendoGrid");
}

/**
 *  급여명세서 리스트 DataSource
 *  url : /salary/getSalaryViewDetailList.do
 */
var dataSource = new kendo.data.DataSource({
	sort: { field: "YM", dir: "desc" },
	serverPaging: false,
	transport: {
		read : {
			url : "<c:url value='/salary/getSalaryViewDetailList.do'/>",
			dataType : "json",
			type : "post"
		},
		parameterMap: function(data, operation) {
			data.erpCompSeq = "5000";
			data.erpNoEmp = ${userInfo.erpEmpCd};
			data.fromDate = $("#startDay").val().replace('-','');
			data.toDate = $("#endDay").val().replace('-','');

			return data;
		},
	},
	schema : {
		data: function (data) {
			return data.data;
		},
		total: function (data) {
			return data.data.length;
		},
	}
});
 
function dataSet() {
	
	var yetDate = new Date();
	var yearSet = yetDate.getFullYear() - 1;
	var monthSet = yetDate.getMonth() + 1;
	
	if (monthSet >= 10) {
		monthSet = "0" + monthSet;
	}

	yetDate = yearSet +"-"+ monthSet;
	
	//조회기간 시작
	$("#startDay").kendoDatePicker({ culture : "ko-KR",
	    format : "yyyy-MM",
	    start: "year",
	    depth: "year",
	    value: new Date(yetDate) });
	//조회기간 끝
	$("#endDay").kendoDatePicker({ culture : "ko-KR",
	    format : "yyyy-MM",
	    start: "year",
	    depth: "year",
	    value: new Date() });
	//readonly
	$("#startDay, #endDay").attr("readonly", true);
}

function onDataBound(data){
	var grid = this;

	grid.tbody.find("tr").click(function (e) {
		var dataItem = grid.dataItem($(this).closest("tr"));
		var rows = grid.tbody.find("[role='row']");
		console.log(dataItem.YM);
		console.log(dataItem.DT_PAY);
		console.log(dataItem.TP_PAY);
		console.log(dataItem.NO_SEQ);
		console.log(dataItem.TITLE_NM);
		console.log(dataItem.NM_TP_PAY);
		popPaysLipPage(dataItem.YM, dataItem.DT_PAY, dataItem.TP_PAY, dataItem.NO_SEQ, dataItem.TITLE_NM, dataItem.NM_TP_PAY);
	});
	
	if (data === undefined || data === null) {
		return;
	}
	
	var gridData = data.sender.dataSource.view();
	var allPaySum = 0;
	var deductPaySum = 0;
	
	for (var i=0; i < gridData.length; i++) {
		allPaySum += gridData[i].AM_PAY_SUM;
		deductPaySum += gridData[i].AM_PAY_DEDUCT;
	}
	
	$("#allPaySum").html(numberWithCommas(allPaySum));
	$("#deductPaySum").html(numberWithCommas(deductPaySum));
	$("#paySumArea").show();
}

function getDateFormatReturn(dateDiv, val, subStr) {
	if (typeof val != "undefined") {
		for (var i = 0; i < 2; i++) {
			val = val.replace("/", "");
			val = val.replace("-", "");
		}
	}
	
	if (dateDiv == "1") {
		var str = "";
		if (subStr != "") {
			str = "(" + subStr + ")";
		}
		return val.substring(0,4) + "/" + val.substring(4,6) + "" + str;
		
	} else {
		return val.substring(0,4) + "/" + val.substring(4,6) + "/" + val.substring(6,8);
	}
}

function popPaysLipPage(YM, DT_PAY, TP_PAY, NO_SEQ, NM_TITLE, NM_TP_PAY) {
	YM = getDateFormatModify(YM);
	DT_PAY = getDateFormatModify(DT_PAY);
	NM_TITLE = getDiffReturn(NM_TITLE, NM_TP_PAY);
	
	if (typeof TP_PAY == "undefined") {
		TP_PAY = "";
	}
	
	// ERP 구분
	var TP_REPORT = "${erpTypeCode}" == "ERPiU" ? tpReport : "";
	TP_REPORT = "iCUBE";
	
	$('input[name="YM"]').val(YM);
	$('input[name="TP_REPORT"]').val(TP_REPORT);
	
	$('input[name="DT_PAY"]').val(DT_PAY);
	$('input[name="TP_PAY"]').val(TP_PAY);
	$('input[name="NO_SEQ"]').val(NO_SEQ);
	$('input[name="NM_TITLE"]').val(NM_TITLE);
	
	var theOption = "width=700, height=925, resizable=yes, scrollbars=no, status=no, right=100px, top=20px;";
	window.open("", "hrPayLipPop", theOption);
	
	var frmData = document.hrPayLipPop;
	frmData.submit();
}

function getDateFormatReturnHi(dateDiv, val, subStr) {
	if (typeof val != "undefined") {
		for (var i = 0; i < 2; i++) {
			val = val.replace("/", "");
			val = val.replace("-", "");
		}
	}
	
	if (dateDiv == "1") {
		var str = "";
		if (subStr != "") {
			str = "(" + subStr + ")";
		}
		
		return val.substring(0,4) + "-" + val.substring(4,6) + "" + str;
	} else {
		return val.substring(0,4) + "-" + val.substring(4,6) + "-" + val.substring(6,8);
	}
}

function getDiffReturn(val1, val2) {
	var isVal1Empty = isEmpty(val1);
	var isVal2Empty = isEmpty(val2);
	
	if (!isVal1Empty || !isVal2Empty) {
		return !isVal1Empty ? val1 :val2;
	}
	
	return "";
}

function numberWithCommas(num) {
	if (!num) {
		return 0;
	}
	
	return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function getDateFormatModify(val) {
	if (typeof val != "undefined") {
		for (var i = 0; i < 2; i++) {
			val = val.replace("/", "");
			val = val.replace("-", "");
		}
	}
	
	return val;
}

function getDiffReturn(val1, val2) {
	var isVal1Empty = isEmpty(val1);
	var isVal2Empty = isEmpty(val2);
	
	if (!isVal1Empty || !isVal2Empty) {
		return !isVal1Empty ? val1 :val2;
	}
	
	return "";
}

function isEmpty(str) {
	return str == null || str == "";
}

function gridReload(){
	record = 0;
	var fromDate = $("#startDay").val().split('-');
	var toDate = $("#endDay").val().split('-');
	
	if (!vaildDate(fromDate[0], fromDate[1])) {
		alert("시작일과 종료일을 정상적으로 입력바랍니다");
		$("#from_date").focus();
		return;
	}
	
	if (!vaildDate(toDate[0], toDate[1])) {
		alert("시작일과 종료일을 정상적으로 입력바랍니다");
		$("#to_date").focus();
		return;
	}
	
	fromDate = fromDate.join('');
	toDate = toDate.join('');
	
	if (fromDate > toDate) {
		alert("시작일을 종료일보다 작게 넣으세요");
		return;
	}
	
	$("#grid").data("kendoGrid").dataSource.read();
}

function vaildDate(year, month) {
	var y = parseInt(year, 10);
	var m = parseInt(month, 10);
	var d = parseInt("01", 10);
	
	var date = new Date(y, m - 1, d);
	
	return (date.getFullYear() == y && date.getMonth() + 1 == m && date.getDate() == d);
}
</script>