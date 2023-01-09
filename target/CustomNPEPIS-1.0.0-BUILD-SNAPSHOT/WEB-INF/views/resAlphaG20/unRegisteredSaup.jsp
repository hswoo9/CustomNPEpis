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

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title></title>
</head>

<script type="text/javascript">
var CO_CD = '<c:url value="${CO_CD}" />';

$(function() {
	Init.kendoFunction();
	Init.kendoGrid();
})
	
var Init = {
		kendoGrid : function() {
			var mainGrid = $("#mainGrid").kendoGrid({
				dataSource : new kendo.data.DataSource({
					serverPaging : true,
					pageSize : 10,
					transport : {
						read : {
							url : _g_contextPath_+"/resAlphaG20/getRegisteredSaupList",
							dataType : "json",
							type : 'post'
						},
						parameterMap : function(data, operation) {
							data.fromDate = $('#fromDate').val().replace(/\-/g,'');
							data.toDate = $('#toDate').val().replace(/\-/g,'');
							data.CO_CD = CO_CD;
							return data;
						}
					},
					schema : {
						data : function(response) {
							return response.list;
						},
						total : function(response) {
							return response.total;
						},
					}
				}),
				dataBound : mainGridDataBound,
				height : 650,
				sortable : true,
				persistSelection : true,
				selectable : "multiple",
		        columns: [
					{
						field : "CHAIN_NM",
						title : "거래처 이름",
						width : 60
					},
					{
						template : function(data) {
							return saupTemplate(data.CHAIN_ID);
						},
						field : 'CHAIN_ID',
						title : "사업자등록번호",
						width : 80
					},
					{
						template : function(data) {
							return data.CHAIN_ADDR1 + "<br>" + data.CHAIN_ADDR2;
						},
						title : "주소",
						width : 80
					},
					{
						field : 'CHAIN_TEL',
						title : "전화번호",
						width : 80
					},
					{
						field : 'CHAIN_CEO',
						title : "대표자명",
						width : 80
					}]
		    }).data("kendoGrid");
		},
		
		
		kendoFunction : function() {
			
			$("#fromDate").kendoDatePicker({
		        start: "month",
		        depth: "month",
		        format: "yyyy-MM-dd",
				parseFormats : ["yyyy-MM-dd"],
		        culture : "ko-KR",
		        dateInput: true,
		        value : new Date(moment().subtract(7, 'days').format('YYYY-MM-DD'))
		    });
			
			$("#toDate").kendoDatePicker({
		        start: "month",
		        depth: "month",
		        format: "yyyy-MM-dd",
				parseFormats : ["yyyy-MM-dd"],
		        culture : "ko-KR",
		        dateInput: true,
		        value : new Date(moment().format('YYYY-MM-DD'))
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
	$('#mainGrid').data('kendoGrid').dataSource.read(0);
}

function saupTemplate(saupNo) {
	return saupNo.substring(0, 3) + ' - ' + saupNo.substring(3, 5) + ' - ' + saupNo.substring(5);
}

</script>

<body>
<div class="iframe_wrap" style="min-width: 1070px;">
	<div class="sub_title_wrap">
		<div class="title_div">
			<h4>G20 미등록 거래처 조회</h4>
		</div>
		<div class="sub_contents_wrap">
			<p class="tit_p mt5 mt20" style="width: 90%">미등록 거래처</p>
				<div class="top_box" style="width: 90%">
					<dl>
						<dt  class="ar" style="width:30px;" >기간</dt>
						<dd>
							<input type="text" id="fromDate" />
							<span>~</span>
							<input type="text" id="toDate" />
						</dd>	
					</dl>
				</div>
				<div class="btn_div" style="width: 90%">	
					<div class="right_div">
						<div class="controll_btn p0">
							<button type="button" id="searchBtn" onclick="fn_searchBtn();">조회</button>
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