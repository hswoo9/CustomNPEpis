<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<jsp:useBean id="year" class="java.util.Date" />
<jsp:useBean id="mm" class="java.util.Date" />
<jsp:useBean id="dd" class="java.util.Date" />
<jsp:useBean id="weekDay" class="java.util.Date" />
<jsp:useBean id="nowDate" class="java.util.Date" />
<fmt:formatDate value="${nowDate}" var="nowDate" pattern="yyyy-MM-dd" />
<fmt:formatDate value="${year}" var="year" pattern="yyyy" />
<fmt:formatDate value="${mm}" var="mm" pattern="MM" />
<fmt:formatDate value="${dd}" var="dd" pattern="dd" />
<fmt:formatDate value="${weekDay}" var="weekDay" pattern="E" type="date" />
<script type="text/javascript" src='<c:url value="/js/ac/acUtil.js"></c:url>'></script>
<script type="text/javascript" src="<c:url value='/js/jquery.form.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/jszip.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/shieldui-all.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/budget/budgetUtil.js' />"></script>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title></title>
</head>

<script type="text/javascript">

var nowDate = new Date();
var minus7days = new Date();
minus7days.setDate(nowDate.getDate() - 7);

var selRow = '';
var gubun = ''; // self / adjust

$(function() {
	Init.kendoFunction();
	Init.kendoGrid();
	Init.eventListener();
})
	
var Init = {
		kendoGrid : function() {
			var mainGrid = $("#mainGrid").kendoGrid({
				dataSource : new kendo.data.DataSource({
					transport : {
						read : {
							url : _g_contextPath_ + '/resAlphaG20/getMoniteringEtaxList',
							dataType : "json",
							type : 'post'
						},
						parameterMap : function(data, operation) {
							data.fromDate 	= $("#fromDate").val().replace(/-/g, '');
							data.toDate 		= $("#toDate").val().replace(/-/g, '');
							data.trName 		= $("#partnerName").val().trim();
							data.issNo 			= $("#authNum").val().trim();
							data.trRegNb		= $("#mercSaupNo").val().trim();
							return data;
						}
					},
					schema : {
						data : function(response) {
							return searchFilter(response.list);
						},
						total : function(response) {
							return searchFilter(response.list).length;
						},
					},
					pageSize: 20
				}),
				dataBound : mainGridDataBound,
				sortable : true,
				pageable: {
					pageSize: 10
		        }, 
				selectable : "multiple",
		        columns: [
					{
						field : "ISS_DT"
						,title : "승인일시",
						width : 70
					},
					{
						field : "ISS_NO"
						,title : "승인번호",
						width : 70
					},
					{
						field : "TR_NM"
						,title : "공급자",
						width : 70
					},
					{
						template : function(dataItem) {
							var trregNb = dataItem.TRREG_NB
							return trregNb.substring(0, 3) + "-" + trregNb.substring(3, 5) + "-" + trregNb.substring(5);
						},
						title : "사업자등록번호",
						width : 70
					},
					{
						template : function(dataItem) {
							return Budget.fn_formatMoney(Number(dataItem.SUM_AM));
						},
						title : "청구금액",
						width : 70
					},
					{
						template : function(dataItem) {
							return Budget.fn_formatMoney(Number(dataItem.totalAmt));
						},
						title : "결의정산금액",
						width : 70
					},
					{
						template : function(dataItem) {
							return Budget.fn_formatMoney(Number(dataItem.SUM_AM) - Number(dataItem.totalAmt));
						},
						title : "미정산잔여금액",
						width : 70
					},
					{
						template : function(dataItem) {
							var remainingAmt = Number(dataItem.SUM_AM) - Number(dataItem.totalAmt);
							if (remainingAmt === 0) {
								return '<span style="color: blue;">정산완료</span>';
							} else {
								return '<span style="color: red;">미정산</span>';
							}
						},
						title : "정산여부",
						width : 70
					},
					]
		    }).data("kendoGrid");
		},
		
		kendoFunction : function() {
			
			$("#adjustment").kendoDropDownList({
				dataTextField : 'adjustmentNm' ,
				dataValueField : 'adjustmentCd' ,
				dataSource : [{ adjustmentNm : "전체", adjustmentCd : 0 }, { adjustmentNm : "정산", adjustmentCd : 1 }, { adjustmentNm : "미정산", adjustmentCd : 2 }]
			});
			
			$("#fromDate").kendoDatePicker({
		        start: "month",
		        depth: "month",
		        format: "yyyy-MM-dd",
				parseFormats : ["yyyy-MM-dd"],
		        culture : "ko-KR",
		        dateInput: true,
		        value : minus7days
		    });
			
			$("#toDate").kendoDatePicker({
		        start: "month",
		        depth: "month",
		        format: "yyyy-MM-dd",
				parseFormats : ["yyyy-MM-dd"],
		        culture : "ko-KR",
		        dateInput: true,
		        value : moment().format('YYYY-MM-DD')
		    });
		},
		
		eventListener : function() {
			$("input[searchEnterKey]").on("keyup", function(e) {
				if (e.keyCode == 13) {
					fn_searchBtn();
				}
			});
			
			$(document).on("click", "#mainGrid tbody tr", function(e) {
				row = $(this)
				grid = $('#mainGrid').data("kendoGrid"),
				dataItem = grid.dataItem(row);
				
				console.log(dataItem);	
			});
		}
}
		
function mainGridDataBound(e) {
	var grid = e.sender;
	
	if (grid.dataSource.total() == 0) {
		var colCount = grid.columns.length;
		$(e.sender.wrapper).find('tbody').append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
	}
}

function fn_searchBtn() {
	$('#mainGrid').data('kendoGrid').dataSource.read(1);
}

// param : (필터링할 리스트, 필터링할 Key값, 필터링 데이터)
function filterList(list, column, word) {
	
	return list.filter(function(v, i) {
		return v[column].indexOf(word) > -1;
	})
}

function searchFilter(list) {
	var resultList = list;
	
	var partnerName 	= $("#partnerName").val().trim();
	
	if (adjustment === '1') {
		resultList = resultList.filter(function(v, i) {
			return Number(v.SUM_AM) - Number(v.totalAmt) === 0;
		})
	} else if (adjustment === '2') {
		resultList = resultList.filter(function(v, i) {
			return Number(v.SUM_AM) - Number(v.totalAmt) !== 0;
		})
	}
	
	return resultList;
}

</script>

<body>
<div class="iframe_wrap" style="min-width: 1070px;">
	<div class="sub_title_wrap">
		<div class="title_div">
			<h4>카드사용내역</h4>
		</div>
		<div class="sub_contents_wrap">
			<p class="tit_p mt5 mt20" style="width: 90%">카드사용내역</p>
				<div class="top_box" style="width: 90%">
					<dl>
						<dt  class="ar" style="width:55px;" >승인일자</dt>
						<dd>
							<input type="text" id="fromDate" /> ~
							<input type="text" id="toDate" />
						</dd>
						<dt  class="ar" style="width:50px;" >사용처</dt>
						<dd>
							<input type="text" id="partnerName" searchEnterKey/>        <!--  사용처 -->
						</dd>
						<dt style="width: 66px;">정산 상태</dt>
						<dd style="width: 66px;">
							<input type="text" style="width:100%" id ="adjustment"/>	 <!--  정산 상태 -->
						</dd>
						<dd>
							<dt style="width: 66px;">승인번호</dt>	
						</dd>
						<dd>
							<input type="text" id="authNum" searchEnterKey/>			 <!--  승인 번호 -->
						</dd>
						<dd>
							<dt style="width: 66px;">사업자번호</dt>
						</dd>
						<dd>
							<input type="text" id="mercSaupNo" searchEnterKey/>			 <!--  사업자번호 -->
						</dd>
						<dd>
							<button type="button" class="blue_btn" id="searchBtn" onclick="fn_searchBtn();">조회</button> 
						</dd>
					</dl>
				</div>
				<div class="btn_div" style="width: 90%">	
					<div class="right_div">
						<div class="controll_btn p0">
<!-- 							<button type="button" id="searchBtn" onclick="fn_downExcel();">엑셀다운로드</button> -->
						</div>
					</div>
				</div>
				<div class="com_ta2 mt15" style="width: 90%;">
				    <div id="mainGrid"></div>
				</div>		
		</div>
	</div>
</div>

</body>
</html>