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
 var selData = '';
 var erpEmpSeq = '${erpEmpSeq}';
 var $mainGridURL = _g_contextPath_ + "/budget/selectMonthSaupBgt";
 
	$(function() {
		Init.kendoFunction();
		Init.kendoGrid();
		Init.eventListener();
	})
	
	var Init = {
			kendoFunction : function() {
				$("#standardDate").kendoDatePicker({
				    depth: "year",
				    start: "year",
				    culture : "ko-KR",
					format : "yyyy",
					value : moment().format('YYYY')
				});
				
				$("#projectPopup").kendoWindow({
				    width: "600px",
				   height: "650px",
				    visible: false,
				    actions: ["Close"]
				}).data("kendoWindow").center();
			},
			
			kendoGrid : function() {
				
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
		   	      				data.pjtCd = $("#pjtFromCd").val();
		   	      				data.year = $('#standardDate').val();
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
					height : 550,
					sortable : true,
					persistSelection : true,
					selectable : "multiple",
			        columns: [
						{
							field : "PJT_CD",	title : "프로젝트 코드",  	width : 40
						},
						{
							field : "PJT_NM2",	title : "프로젝트 명",  	width : 40
						},
						{
							template : function(dataItem) {
								return Budget.fn_formatMoney(dataItem.AMT1);
							},
							title : "1월",
							width : 30
						},
						{
							template : function(dataItem) {
								return Budget.fn_formatMoney(dataItem.AMT2);
							},
							title : "2월",
							width : 30
						},
						{
							template : function(dataItem) {
								return Budget.fn_formatMoney(dataItem.AMT3);
							},
							title : "3월",
							width : 30
						},
						{
							template : function(dataItem) {
								return Budget.fn_formatMoney(dataItem.AMT4);
							},
							title : "4월",
							width : 30
						},
						{
							template : function(dataItem) {
								return Budget.fn_formatMoney(dataItem.AMT5);
							},
							title : "5월",
							width : 30
						},
						{
							template : function(dataItem) {
								return Budget.fn_formatMoney(dataItem.AMT6);
							},
							title : "6월",
							width : 30
						},
						{
							template : function(dataItem) {
								return Budget.fn_formatMoney(dataItem.AMT7);
							},
							title : "7월",
							width : 30
						},
						{
							template : function(dataItem) {
								return Budget.fn_formatMoney(dataItem.AMT8);
							},
							title : "8월",
							width : 30
						},
						{
							template : function(dataItem) {
								return Budget.fn_formatMoney(dataItem.AMT9);
							},
							title : "9월",
							width : 30
						},
						{
							template : function(dataItem) {
								return Budget.fn_formatMoney(dataItem.AMT10);
							},
							title : "10월",
							width : 30
						},
						{
							template : function(dataItem) {
								return Budget.fn_formatMoney(dataItem.AMT11);
							},
							title : "11월",
							width : 30
						},
						{
							template : function(dataItem) {
								return Budget.fn_formatMoney(dataItem.AMT12);
							},
							title : "12월",
							width : 30
						}
						]
			    }).data("kendoGrid");
				
				/* 프로젝트 팝업 그리드 */
				var projectGrid = $("#projectGrid").kendoGrid({
			        dataSource: new kendo.data.DataSource({
			    	    transport: { 
			    	        read:  {
			    	            url: _g_contextPath_+'/budget/projectList',
			    	            dataType: "json",
			    	            type: 'post'
			    	        },
			    	      	parameterMap: function(data, operation) {
		   	      				data.fiscal_year = $("#standardDate").val().substring(0, 4);
			    	      		data.project 		= $("#projectName").val();
			    	     		return data;
			    	     	}
			    	    },
			    	    schema: {
			    	      data: function(response) {
			    	        return response.list;
			    	      },
			    	      total: function(response) {
			    	        return response.total;
			    	      }
			    	    }
			    	}),
			        height: 500,	        
			        sortable: true,
			        persistSelection: true,
			        selectable: "multiple",
			        columns:[{
			        					title : "프로젝트 코드",
			        					field : "PJT_CD",
			        					width : 30
			        				},
			        				{
			        					title : "프로젝트 명",
			        					field : "PJT_NM",
			        					width : 30
			        				},
			        				{
			        					title : "선택",
			        					width : 15,
								    	template : '<input type="button" id="" class="text_blue" onclick="projectSelect(this);" value="선택">'
		        		    	    }]
			    }).data("kendoGrid");
				/* 프로젝트 팝업 그리드 */
			},
			
			eventListener : function() {

				$("#pjtFromSearch, #pjtToSearch").on("click", function() {
					$('#projectName').val("");
					$('#projectFrom').val('');
					 
					$("#projectPopup").data("kendoWindow").open();
					projectGridReload();
				});
				 
				 $("#projectName").on("keyup", function(e){
					if (e.keyCode === 13) {
						projectGridReload();
					}
				});
				 
				 $('#projectPopupCancel').on('click', function() {
						projectPopupClose();
					});
			}
	}
	
	function projectSelect(e){		
		var row = $("#projectGrid").data("kendoGrid").dataItem($(e).closest("tr"));
		
		$("#pjtFrom").val(row.PJT_NM);
		$("#pjtFromCd").val(row.PJT_CD);
		
		$("#projectPopup").data("kendoWindow").close();
	}
	
	function projectPopupClose(){
		 $("#projectPopup").data("kendoWindow").close();
	}
	
	function projectGridReload() {
		$("#projectGrid").data("kendoGrid").dataSource.read();
	}
	
	function mainGridDataBound(e) {
		var grid = e.sender;
		
		if (grid.dataSource.total() == 0) {
			var colCount = grid.columns.length;
			$(e.sender.wrapper).find('tbody').append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
		}
		
		/* 소계 및 합계 색 반전 */
		$('#mainGrid table tbody > tr').each(function() {
			var $this = $(this);
			var row = grid.dataItem($this);
			
			if (typeof row !== 'undefined' && row.PJT_NM === '합계') {
				$this.css("font-weight", "bold");
				$this.css("color", "blue");
	        	
				$this.children("td").each(function(i, f) {
	        		$(this).css("border-bottom", "0.5px solid black");
	        	});
			}
		})
	}
	
	function searchMainGrid() {
		$('#mainGrid').data('kendoGrid').dataSource.transport.options.read.url = $mainGridURL;
		$('#mainGrid').data('kendoGrid').dataSource.read(0);
	}
	
	function excel() {
		
		var mainList = $('#mainGrid').data('kendoGrid')._data;
		var templateName = 'monthSaupBgtTemplate';
		var title = '월별 사업예산';
		
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
				<h4>프로젝트 예산 부서 설정</h4>
			</div>
		</div>
		
	<div class="sub_contents_wrap">
		<div class="com_ta">
			<div class="top_box gray_box" id = "dataBox">
				<dl>
					<dt>사업년도</dt>
					<dd style="width:35%">
						<input type="text" style="width:40%" id = "standardDate" style = "" value=""/>
					</dd>
					<dt style="width:7%">프로젝트</dt>
					<dd style="width:35%">
						<input type="text" style="width:40%" id ="pjtFrom" disabled/>
						<input type="hidden" id ="pjtFromCd"/>
						<button type="button" id ="pjtFromSearch" value="검색">
						<img style="position:inherit;" src="<c:url value='/Images/btn/search_icon2.png'/>"></button>
					</dd>
				</dl>
			</div>
		</div>
				
		<div class="btn_div mt10 cl">
			<div class="left_div">
				<!-- <p class="tit_p mt5 mb0">※ 본부별 예실 대비 현황</p> -->
			</div>
			<div class="right_div">
				<div class="controll_btn p0">
					<button type="button" id="" onclick = "excel()">엑셀</button>
					<button type="button" id="" onclick = "searchMainGrid()">조회</button>
				</div>
			</div>
		</div>
		
		<div class="com_ta2" style="height: 550px;">
			<div  id = "mainGrid">
			</div>
		</div>
	</div>
</div>
	
<!-- 프로젝트검색팝업 -->
<div class="pop_wrap_dir" id="projectPopup" style="width:600px;">
	<div class="pop_head">
		<h1>프로젝트 선택</h1>
	</div>
	<div class="pop_con">
		<div class="top_box">
			<dl>
				<dt class="ar" style="width: 80px;">프로젝트 명</dt>
				<dd style="">
					<input type="text" id="projectName" style="width: 120px" />
				</dd>
				<dd>
					<input type="button" onclick="projectGridReload();" id="searchButton"	value="검색" />
				</dd>
			</dl>
		</div>
		<div class="com_ta mt15" style="height: 450px;">
			<div id="projectGrid"></div>
		</div>			
	</div>

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" class="gray_btn" id="projectPopupCancel" value="닫기" />
		</div>
	</div>
</div>	
<!-- 프로젝트검색팝업 -->

</body>

