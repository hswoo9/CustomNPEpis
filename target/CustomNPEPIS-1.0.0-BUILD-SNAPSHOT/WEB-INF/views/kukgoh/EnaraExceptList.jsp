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
 var deptComboList = '';
 var statusComboList = '';
 var selRow = '';
 
	$(function() {
		Init.ajax();
		
		Init.kendoFunction();
		Init.kendoGrid();
		Init.eventListener();
	})
	
	var Init = {
			ajax : function() {
				
			},
			kendoFunction : function() {
				
				var now = new Date();
				
				now.setDate(now.getDate() - 7);
				
				$("#fromDate").kendoDatePicker({
				    depth: "month",
				    start: "month",
				    culture : "ko-KR",
					format : "yyyy-MM-dd",
					value : moment(now).format("YYYY-MM-DD"),
				});
				
				$("#toDate").kendoDatePicker({
				    depth: "month",
				    start: "month",
				    culture : "ko-KR",
					format : "yyyy-MM-dd",
					value : moment(new Date()).format("YYYY-MM-DD"),
				});
			},
			
			kendoGrid : function() {
				/* 상단 그리드 */
				var mainGrid = $("#mainGrid").kendoGrid({
					dataSource : new kendo.data.DataSource({
						transport : {
							read : {
								url : _g_contextPath_+"/kukgoh/selectEnaraExceptList",
								dataType : "json",
								type : 'post'
							},
							parameterMap: function(data, operation) {
		  	      				data.fromDate = $("#fromDate").val().replace(/-/gi,'');
			  	      			data.toDate = $("#toDate").val().replace(/-/gi,'');
		    	     			return data;
		    	     		}
						},
						schema : {
							data : function(response) {
								
								var resultList;
								var rmk = $("#rmk").val();
								
								if (rmk !== "") {
									resultList = response.list.filter(function(v) {
										return v.RMK_DC.indexOf(rmk) > -1;										
									});
								} else {
									resultList = response.list;
								}
								
								return resultList;
							},
							total : function(response) {
								return response.total;
							},
						}
					}),
					height : 700,
					dataBound : mainGridDataBound,
			        columns: [
			        	{
			        		headerTemplate : function(e){
			                   return '<input type="checkbox" id = "checkboxAll">';
			                },
			                template : function(e) {
			                	return '<input type="checkbox" class = "mainCheckBox">';
			                },
			                width : 25
			        	},
			        	{	field : "GISU_DT",				title : "결의일자",				width : 40 },
			        	{	field : "RMK_DC",				title : "적요",						width : 160 },
			        	{	field : "GISU_SQ",				title : "결의번호",				width : 40 },
			        	{	field : "BG_SQ",				title : "예산순번",				width : 40 },
			        	{	field : "LN_SQ",				title : "거래처순번",				width : 40 },
			        	{	
			        		template : function(data) {
								return Budget.fn_formatMoney(data.SUM_AMOUNT);
							},
							title : "금액",
							width : 40
			        	}
		        	]
			    }).data("kendoGrid");
				/* 상단 그리드 */
				
			},
			eventListener : function() {
				
				// 체크박스 전체선택
				$("#checkboxAll").click(function(e) {
			         if ($("#checkboxAll").is(":checked")) {
			        	 $(".mainCheckBox").prop("checked", true);
			         } else {
			            $(".mainCheckBox").prop("checked", false);
			         }
		      	});
				
				$(document).on("click", "#mainGrid tbody tr", function(e) {
					row = $(this)
					grid = $('#mainGrid').data("kendoGrid"),
					dataItem = grid.dataItem(row);
					
					console.log(dataItem);	
				})
				
				$("#rmk").on("keyup", function(e) {
					if (e.keyCode == 13) {
						mainGridReload();
					}
				});
				
				$("#searchBtn").on("click", function() {
					mainGridReload();
				});
			}
	}
	
	function mainGridDataBound(e) {
		var grid = e.sender;

		if (grid.dataSource.total() == 0) {
			var colCount = grid.columns.length + 3;
			$(e.sender.wrapper).find('tbody').append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
		}
	}
	
	function searchMainGrid() {
		$('#mainGrid').data('kendoGrid').dataSource.read(0);
	}
	
	function mainGridReload() {
		$('#mainGrid').data('kendoGrid').dataSource.read();
	}
	
	function reloadExceptDocs() {
		
		var resolutionList = [];
		
		$(".mainCheckBox:checked").each(function(i, v) {
			
			var rows = $("#mainGrid").data("kendoGrid").dataItem($(v).closest("tr"));
			
			rows.CO_CD = '5000';
			
			resolutionList.push(rows);
		});
		
		$.ajax({
			url : _g_contextPath_ + "/kukgoh/reloadEnaraExceptDoc",
			data : { "param" : JSON.stringify(resolutionList) },
			dataType : "json",
			type : "POST",
			success : function(result) {
				mainGridReload();
			}
		}) 
	}
	
</script>
<body>
<div class="iframe_wrap">
	<div class="sub_title_wrap">
		<div class="title_div">
			<h4>예산 기본계획 제출</h4>
		</div>
	</div>
	
	<div class="sub_contents_wrap">
		<div class="com_ta">
			<div class="top_box gray_box" id = "dataBox">
				<dl>
					<dt>발의기간</dt>
					<dd style="width:23%">
						<input type="text" style="" id = "fromDate" style = "" value=""/>
						~
						<input type="text" style="" id = "toDate" style = "" value=""/>
					</dd>
					<dt>적요</dt>
					<dd style="width:30%">
						<input type="text" id ="rmk" style="width:250px;"/>
						<button type="button" class="blue_btn" id = "searchBtn">검색</button>
					</dd>
				</dl>
			</div>
		</div>
				
		<div class="btn_div mt10 cl">
			<div class="left_div">
				<p class="tit_p mt5 mb0">전송 제외 리스트</p>
			</div>
			<div class="right_div">
				<div class="controll_btn p0">
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

