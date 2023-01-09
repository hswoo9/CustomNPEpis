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
	.k-grid-header th.k-header { white-space : normal !important; }
	.font-underline { text-decoration : underline; }
</style>
<script type="text/javascript">

	$(function() {
		
		Init.ajax();
		
		Init.kendoFunction();
		Init.kendoGrid();
		Init.eventListener();
	})
	
	var Init = {
			ajax : function() {},
			kendoFunction : function() {
				$("#fromDate").kendoDatePicker({
				    depth: "month",
				    start: "month",
				    culture : "ko-KR",
					format : "yyyy-MM-dd",
					value : moment().format('YYYY') + "-" + moment().format('MM') + "-01"
				});
				
				$("#toDate").kendoDatePicker({
				    depth: "month",
				    start: "month",
				    culture : "ko-KR",
					format : "yyyy-MM-dd",
					value : moment().format('YYYY') + "-" + moment().format('MM') + "-" + moment().format('DD')
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
								async: false,
								url : _g_contextPath_ + '/resAlphaG20/selectPdfErrorDocs',
								dataType : "json",
								type : 'post'
							},
							parameterMap: function(data, operation) {
								data.fromDate = $('#fromDate').val();
								data.toDate = $('#toDate').val() + ' 23:59:59';
								data.searchWord = $('#searchWord').val();
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
					sortable : true,
			        columns: [
			        	{
							template : function(dataItem) {
								return "<span class='grdCol' style='color: blue;' onclick='fn_docViewPop(" + dataItem.rep_id + ")'>" + dataItem.c_dititle + "</span>";	
			        		},
			        		title : '문서제목', width: 400
			        	},
			        	{
			        		template : function(dataItem) {
			        			var errorFileName = '';
			        			var excepPrefix = dataItem.ERROR_MSG.split('_');
			        			
			        			excepPrefix.forEach(function(v, i) {
			        				errorFileName += (i !== 0) ? v : '';
			        			})
			        			
			        			return errorFileName.substring(0, errorFileName.length - 2);
			        		},
			        		title : 'ISSUE 파일', width: 400
			        	},
			        	{
			        		template : function(dataItem) {
			        			return "<span class='grdCol' style='color: blue;' onclick='fn_docViewPop(" + dataItem.rep_id + ")'>" + dataItem.doc_no + "</span>";
			        		},
			        		title : '문서번호', width: 100
			        	},
			        	{
			        		title : '기안자',	field : 'emp_name',width: 100
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
				
				$('#searchWord').on('keyup', function(e) {
					if (e.keyCode == '13') {
						searchMainGrid();
					}
				});
				
				$(document).on({
		    		mouseenter : function() {
		    			$(this).addClass("font-underline");
		    		},
		    		mouseleave : function() {
		    			$(this).removeClass("font-underline");
		    		}
		    	}, '.grdCol')
			}
	}
	
	function mainGridDataBound(e) {
		var grid = e.sender;

		if (grid.dataSource.total() == 0) {
			var colCount = grid.columns.length
			$(e.sender.wrapper).find('tbody').append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
		}
	}
	
	function searchMainGrid() {
		$('#mainGrid').data('kendoGrid').dataSource.read(0);
	}
	
</script>
<body>
<div class="iframe_wrap">
	<div class="sub_title_wrap" style='height: 15px;'>
		<div class="title_div">
		</div>
	</div>
	
	<div class="sub_contents_wrap">
		<div class="com_ta">
			<div class="top_box gray_box" id = "dataBox">
				<dl>
					<dt>발의기간</dt>
					<dd style="width:400px;">
						<input type="text" style="" id="fromDate" value="" />
												&nbsp;~&nbsp;
						<input type="text" style="" id="toDate" value="" />
					</dd>
					<dt>문서번호</dt>
					<dd style="width:500px;">
						<input type="text" style="width: 300px;" id="searchWord" value="" />
					</dd>
				</dl>
			</div>
		</div>
				
		<div class="btn_div mt10 cl">
			<div class="left_div">
			</div>
			<div class="right_div">
				<div class="controll_btn p0">
<!-- 					<button type="button" id="" onclick = "excel()">엑셀</button> -->
					<button type="button" id="" onclick = "searchMainGrid()">조회</button>
				</div>
			</div>
		</div>
		
		<div class="com_ta2" style="">
			<div  id = "mainGrid">
			</div>
		</div>
	</div>
</div>
	
	
</body>

