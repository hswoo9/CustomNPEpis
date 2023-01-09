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
<script type="text/javascript" src="<c:url value='/js/budget/budgetUtil.js' />"></script>
<style>
	.green_btn {background:#0e7806 !important; height:24px; padding:0 11px; color:#fff !important;border:none; font-weight:bold; border:0px !important;}
</style>
<script type="text/javascript">
 
 var first = true;
 var deptSeq = '<c:out value="${deptSeq}"/>';
 var deptName = '<c:out value="${deptName}"/>';
 var compSeq = '<c:out value="${compSeq}"/>';
 var deptComboList = '';
 var statusComboList = '';
 var $mainGridURL = _g_contextPath_ + "/budget/selectPjtBgtStatus";
 
	$(function() {
		Init.ajax();
		
		Init.kendoFunction();
		Init.kendoGrid();
		Init.eventListener();
	})
	
	var Init = {
			ajax : function() {
				$.ajax({
			 		url: _g_contextPath_+"/budget/searchDeptList3",
			 		dataType : 'json',
			 		data : { year : moment().format('YYYY') },
			 		type : 'POST',
			 		async : false,
			 		success: function(result){
			 			deptComboList = result;
			 		}
			 	});
			},
			kendoFunction : function() {
				
				$("#dept").kendoComboBox({
				      dataSource: deptComboList.resolutionDeptList,
				      dataTextField: "DEPT_NM",
					  dataValueField: "DEPT_CD",
					  height : 500,
					  index : 0
				});
				
				$("#standardDate").kendoDatePicker({
				    depth: "year",
				    start: "year",
				    culture : "ko-KR",
					format : "yyyy",
					value : moment().format('YYYY'),
					change : changeStandardDate
				});
			},
			kendoGrid : function() {
				
				/* 메인 그리드 */
				var mainGrid = $("#mainGrid").kendoGrid({
					dataSource : new kendo.data.DataSource({
						serverPaging : true,
						pageSize : 10,
						transport : {
							read : {
								url : _g_contextPath_+"/budget/initGrid",
								dataType : "json",
								type : 'post'
							},
							parameterMap: function(data, operation) {
		   	      				data.year = $("#standardDate").val();
		   	      				data.deptCd = $('#dept').data('kendoComboBox').value();
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
							model : {
								fields : {
								}
							}
						}
					}),
					dataBound : mainGridDataBound,
					height : 650,
					sortable : true,
					persistSelection : true,
					selectable : "multiple",
			        columns: [
						{
							field : 'PJT_CD',	title : "프로젝트 코드",	width : 80
						},
						{
							field : 'PJT_NM2',	title : "프로젝트 명",	width : 80
						},
						{
							template : function(dataItem) {
								return Budget.fn_formatMoney(dataItem.BGT_AMT)
							},
							title : "예산금액",	width : 80
						},
						{
							template : function(dataItem) {
								return Budget.fn_formatMoney(dataItem.EXE_AMT)
							},
							title : "집행금액",	width : 80
						},
						{
							template : function(dataItem) {
								return Budget.fn_formatMoney(dataItem.RE_AMT)
							},
							title : "반납금액",	width : 80
						},
						{
							template : function(dataItem) {
								return Budget.fn_formatMoney(dataItem.BF_AMT)
							},
							title : "이월금액",	width : 80
						},
						{
							field : 'DEPT_NM',	title : "주관부서",	width : 80
						},
						{
							field : 'BGT_STAT_NM',	title : "상태",	width : 80
						},
						{
							field : 'CHK_MSG',	title : "검증",	width : 80
						},
					]
			    }).data("kendoGrid");
				/* 하단 그리드 */
			},
			eventListener : function() {
				
				$(document).on("click", "#mainGrid tbody tr", function(e) {
					row = $(this)
					grid = $('#mainGrid').data("kendoGrid"),
					dataItem = grid.dataItem(row);
					
					console.log(dataItem);	
				})
			}
	}
	
	function changeStandardDate() {
		
		$.ajax({
	 		url: _g_contextPath_+"/budget/searchDeptList3",
	 		dataType : 'json',
	 		data : { year : $('#standardDate').val().substring(0,4), deptName : '' },
	 		type : 'POST',
	 		async : false,
	 		success: function(result){
	 			$('#dept').data('kendoComboBox').setDataSource(result.resolutionDeptList);
	 		}
	 	});
	}
	
	function mainGridDataBound(e) {
		var grid = e.sender;

		if (grid.dataSource.total() == 0) {
			var colCount = grid.columns.length;
			$(e.sender.wrapper).find('tbody').append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
		}
	}
	
	function searchMainGrid() {
		first = false;
		$('#mainGrid').data('kendoGrid').dataSource.transport.options.read.url = $mainGridURL;
		$('#mainGrid').data('kendoGrid').dataSource.read();
	}
	
	function excel() { 
		
		var mainList = $('#mainGrid').data('kendoGrid')._data;
		var templateName = 'lookupSaupBgtStatusExcelTemplate';
		var title = '사업 예산 현황';
		
		$.ajax({
	 		url: _g_contextPath_+"/budget/budgetExcel2",
	 		dataType : 'json',
	 		data : { param : JSON.stringify(mainList), templateName : templateName, title : title },
	 		type : 'POST',
	 		success: function(result){
	 			var downWin = window.open('','_self');
				downWin.location.href = _g_contextPath_+"/budget/excelDownLoad?fileName="+ escape(encodeURIComponent(result.fileName)) +'&fileFullPath='+escape(encodeURIComponent(result.fileFullPath));
	 		}
	 	});
	}
	
</script>
<body>
<div class="iframe_wrap">
	<div class="sub_title_wrap">
		<div class="title_div">
			<h4>예산 세부내역 확정</h4>
		</div>
	</div>
	
	<div class="sub_contents_wrap">
		<div class="com_ta">
			<div class="top_box gray_box" id = "dataBox">
				<dl>
					<dt>기준일자</dt>
					<dd style="width:13%">
						<input type="text" style="" id = "standardDate" style = "" value=""/>
					</dd>
					<dt>부서</dt>
					<dd style="width:15%">
						<input type="text" style="" id = "dept" value="" />
					</dd>
				</dl>
			</div>
		</div>
				
		<div class="btn_div mt10 cl">
			<div class="left_div">
				<p class="tit_p mt5 mb0">사업예산 현황</p>
			</div>
			<div class="right_div">
				<div class="controll_btn p0">
					<button type="button" id="" onclick = "excel()">엑셀</button>
					<button type="button" id="" onclick = "searchMainGrid()">조회</button>
				</div>
			</div>
		</div>
		
		<div class="com_ta2" style="height: 700px;">
			<div  id = "mainGrid">
			</div>
		</div>
	</div>
</div>


</body>

