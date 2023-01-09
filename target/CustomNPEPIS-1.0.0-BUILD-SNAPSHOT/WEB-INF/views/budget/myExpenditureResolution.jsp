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
<script type="text/javascript" src="<c:url value='/js/jquery.number.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/jszip.min.js' />"></script>
<style>
dt {	text-align : left; 	width : 10%; }
dd {	width: 11.5%; } 
dd input { 	width : 80%; }
.k-grid-toolbar { float : right; }
.blueColor { color : blue; }
.onFont { font-weight : bold; color : green; }
</style>
<body>

<script type="text/javascript">

var $voucherRowData;
var $flag;
var $dataSource = new kendo.data.DataSource({		//그리드데이터소스
	serverPaging : true,
	pageSize : 1000,
	transport : {
		read : {
			url : _g_contextPath_+ "/budget/IndividualExpenditureResolutionList",
			dataType : "json",
			type : "post"
		},
		parameterMap: function(data, operation) {
			
			data.fromMonth = $("#from_period").val().replace(/-/gi,"");
			data.toMonth = $("#to_period").val().replace(/-/gi,"");
			data.erpEmpSeq = $("#erpEmpSeq").val();
	     	return data;
	     }
	},
	schema : {
		data : function(response){
			console.log(response.list);
			return response.list;
		},
	    model : {
	    	fields : {

	    	}
	    }
	}
});

	$(function(){
		
		$(document).on("mouseover", ".docTitle", function() {
			$(this).removeClass("blueColor").addClass("onFont");
		});
		
		$(document).on("mouseout", ".docTitle", function() {
			$(this).removeClass("onFont").addClass("blueColor");
		});
		
		$("#from_period").kendoDatePicker({
		    depth: "month",
		    start: "month",
		    culture : "ko-KR",
			format : "yyyy-MM-dd",
			value : new Date('${year}',${mm}-1,1),
			change : makeToDateMin
		});
		
		$("#to_period").kendoDatePicker({
		    depth: "month",
		    start: "month",
		    min : $("#from_period").data("kendoDatePicker").value(),
		    culture : "ko-KR",
			format : "yyyy-MM-dd",
			value : new Date()
		});
		
		mainGrid();
		
	});
	
	
	function mainGrid(){
		
		var grid =  $("#grid").kendoGrid({
			toolbar : [	{	name : "excel", 	text : "Excel" 	}],
			excel : { fileName : '지출결의서 현황.xlsx'	 },
			dataSource: $dataSource,
			height : 700,
			dataBound : dataBound,
			selectable : "row",
			sortable : true,
			persistSelection : true,
			columns : [
				{
					template : function(dataItem) {
						return fn_formatDate(dataItem.GISU_DT);
					},
					width : 15,
					title : "발의일자"
				},
				{
					width : 15,
					field : "GISU_SQ",
					title : "결의번호"
				},
				{
					template : function(dataItem) {
						return "<span class='blueColor docTitle' onclick='fn_docViewPop(" + dataItem.C_DIKEYCODE + ")'>" + dataItem.DOC_NUMBER + "</span>";
					},
					width : 25,
					title : "문서번호"
				},
				{
					template : function(dataItem) {
						return fn_formatDate(dataItem.DOC_REGDATE);
					},
					width : 12,
					title : "결재일자"
				},
				{
					template : function(dataItem) {
						return "<span class='blueColor docTitle' onclick='fn_docViewPop(" + dataItem.C_DIKEYCODE + ")'>" + dataItem.DOC_TITLE + "</span>";
					},
					width : 23,
					title : "제목"
				},
				{
					width : 15,
					field : "DIV_NM",
					title : "회계단위"
				},
				{
					width : 15,
					field : "PJT_NM",
					title : "프로젝트"
				},
				{
					width : 15,
					field : "ABGT_NM",
					title : "예산과목"
				},
				{
					template : function(dataItem) {
						return fn_formatMoney(dataItem.UNIT_AM);
					},
					width : 15,
					title : "금액"
				},
				{
					width : 15,
					field : "SET_FG_NM",
					title : "결제수단"
				},
				{
					width : 12,
					field : "VAT_FG_NM",
					title : "과세구분"
				},
				{
					width : 15,
					field : "STATE_NM",
					title : "상태"
				},
				{
					template : function(dataItem) {
						return '<input type="button" class="blue_btn" value="보기" onclick = "resolutionViewOpen(this)">';
					},
					width : 13,
					title : "지출결의"
				},
				{
					field : 'ENARA_STATUS',
					width : 20,
					title : "E나라 전송상태"
				},
				],
			change : selectRow
	
		}).data("kendoGrid");
		
		function selectRow(e){		//row클릭시 data 전역변수 처리
	
			row = e.sender.select();
			grid = $('#grid').data("kendoGrid");
			data = grid.dataItem(row);
			console.log(data);
			$rowData = data;
			
		}
		
		$gridFlag = true;
		$rowData = {};
	};
	
	function gridReload(){
	
		$gridIndex = 0;
		$('#grid').data('kendoGrid').dataSource.read();
		$rowData = {};
		
	}
	
	function dataBound(e){
		
		$gridIndex = 0;
		var grid = e.sender;
		if(grid.dataSource._data.length==0){
			var colCount = grid.columns.length;
			$(e.sender.wrapper)
				.find('tbody')
				.append('<tr class="kendo-data-row">' + 
						'<td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
		}
	};
	
	
	function fn_formatDate(str){
		return str.substring(0,4) + "-" + str.substring(4,6) + "-" + str.substring(6,8) ;
	}

	function fn_formatMoney(str){
	        str = String(str);
	        return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
	}
	
	function makeToDateMin(){
		
		if($("#from_period").val()>$("#to_period").val()){
			$("#from_period").data("kendoDatePicker").value(new Date());
			return;
		}
		
		$("#to_period").data("kendoDatePicker").setOptions({
		    min: $("#from_period").data("kendoDatePicker").value()
		});
	}
	
	function resolutionViewOpen(e) {
		
		$voucherRowData = $("#grid").data("kendoGrid").dataItem($(e).closest("tr"));
		$flag = "expenditure";
		
		var url = _g_contextPath_ + "/budget/resolutionPopup";
		
		window.name = "parentForm";
		var openWin = window.open(url,"childForm","width=1400, height=580, resizable=yes , scrollbars=yes, status=no, top=200, left=350","newWindow");
	}
	
</script>
<div class="iframe_wrap">
	<div class="sub_title_wrap">
		<div class="title_div">
			<h4>거래처원장</h4>
		</div>
	</div>
	
	<div class="sub_contents_wrap">
		<div class="com_ta">
			<div class="top_box gray_box" id = "dataBox">
				<dl>
					<dt style="width:5%">발의기간</dt>
					<dd style="width:33%">
						<input type="text" style="width:40%" id="from_period" name="period" value="" >
												&nbsp;~&nbsp;
						<input type="text" style="width:40%" id="to_period" name="period" value="" >
					</dd>
					<dt style="width:5%">발의부서</dt>
					<dd style="width:15%">
						<input type="text" style="width:100%" id ="deptNm" value="${deptNm }" disabled/>
						<input type="hidden" style="width:100%" id ="deptSeq" value="${deptSeq }"/>
					</dd>
					<dt style="width:5%">발의자</dt>
					<dd style="width:15%">
						<input type="text" style="width:100%" id ="empName" value="${userName }" disabled/>
						<input type="hidden" style="width:100%" id ="erpEmpSeq" value="${erpEmpSeq }"/>
					</dd>
				</dl>
			</div>
		</div>
				
		<div class="btn_div mt10 cl">
			<div class="right_div">
				<div class="controll_btn p0">
					<button type="button" id="" onclick = "gridReload()">조회</button>
				</div>
			</div>
		</div>
		
		<div class="com_ta2">
			<div  id = "grid">
			</div>
		</div>
		
	</div>
</div>


</body>

