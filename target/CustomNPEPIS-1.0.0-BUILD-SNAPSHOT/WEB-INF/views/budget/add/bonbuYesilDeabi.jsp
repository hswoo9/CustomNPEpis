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
</style>
<script type="text/javascript">
 var selData = '';
 var $parentData = '';
 var $upperGridURL = _g_contextPath_ + "/budget/getYesilDaebi";
 var $lowerGridURL = _g_contextPath_ + "/budget/getBonbuYesilDaebi";
 
	$(function() {
		Init.kendoFunction();
		Init.kendoGrid();
		Init.eventListener();
	})
	
	var Init = {
			kendoFunction : function() {
				$("#standardDate").kendoDatePicker({
				    depth: "month",
				    start: "month",
				    culture : "ko-KR",
					format : "yyyy-MM-dd",
					value : new Date()
				});
			},
			
			kendoGrid : function() {
				/* 상단 그리드 */
				var upperGrid = $("#upperGrid").kendoGrid({
					dataSource : new kendo.data.DataSource({
						transport : {
							read : {
								url : _g_contextPath_+"/budget/initGrid",
								dataType : "json",
								type : 'post'
							},
							parameterMap: function(data, operation) {
		  	      				data.month = $("#standardDate").val().replace(/-/gi,'');
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
					dataBound : upperGridDataBound,
			        columns: [
						{
							template : function(data) {
								return Budget.fn_formatMoney(data.AMT1);
							},
							title : "예산금액",
							width : 60
						},
						{
							template : function(data) {
								return Budget.fn_formatMoney(data.AMT2);
							},
							title : "결의금액",
							width : 60
						},
						{
							template : function(data) {
								return Budget.fn_formatMoney(data.AMT3);
							},
							title : "전표금액",
							width : 60
						},
						{
							title : '결의기준',
							columns : [
								{
									template : function(data) {
										return Budget.fn_formatMoney(data.AMT4);
									},
									title : '잔액',
									width : 40
								},
								{
									template : function(data) {
										return "<div class='upperProgress' data-flag='1' style='width : 80px'></div>";
									},
									title : '집행률(%)',
									width : 40
								}
							]
						},
						{
							title : '전표기준',
							columns : [
								{
									template : function(data) {
										return Budget.fn_formatMoney(data.AMT6);
									},
									title : '잔액',
									width : 40
								},
								{
									template : function(data) {
										return "<div class='upperProgress' data-flag='2' style='width : 80px'></div>";
									},
									title : '집행률(%)',
									width : 40
								}
							]
						}]
			    }).data("kendoGrid");
				/* 상단 그리드 */
				
				/* 하단 그리드 */
				var lowerGrid = $("#lowerGrid").kendoGrid({
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
		   	      				data.month = $("#standardDate").val().replace(/-/gi,'');
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
					dataBound : lowerGridDataBound,
					height : 650,
					sortable : true,
					persistSelection : true,
					selectable : "multiple",
			        columns: [
						{
							field : "HDEPT_NM",
							title : "본부",
							width : 40
						},
						{
							template : function(data) {
								return Budget.fn_formatMoney(data.AMT1);
							},
							title : "예산금액",
							width : 60
						},
						{
							template : function(data) {
								return Budget.fn_formatMoney(data.AMT2);
							},
							title : "결의금액",
							width : 60
						},
						{
							template : function(data) {
								return Budget.fn_formatMoney(data.AMT3);
							},
							title : "전표금액",
							width : 60
						},
						{
							title : '결의기준',
							columns : [
								{
									template : function(data) {
										return Budget.fn_formatMoney(data.AMT4);
									},
									title : '잔액',
									width : 40
								},
								{
									template : function(data) {
										return "<div class='lowerProgress' data-flag='1' style='width : 80px'></div>";
									},
									title : '집행률(%)',
									width : 40
								}
							]
						},
						{
							title : '전표기준',
							columns : [
								{
									template : function(data) {
										return Budget.fn_formatMoney(data.AMT6);
									},
									title : '잔액',
									width : 40
								},
								{
									template : function(data) {
										return "<div class='lowerProgress' data-flag='2' style='width : 80px'></div>";
									},
									title : '집행률(%)',
									width : 40
								}
							]
						},
						{
							template : function(data) {
								if (data.HDEPT_CD === '') {
									return '';
								} else {
									return '<input type="button" class="blue_btn" value="보기" onclick = "viewDetail(this)">';
								}
							},
							title : '부서별 상세',
							width : 27
						}]
			    }).data("kendoGrid");
				/* 하단 그리드 */
			},
			eventListener : function() {
			}
	}
	
	function viewDetail(param) {
		var dataItem = $('#lowerGrid').data('kendoGrid').dataItem($(param).closest('tr'));
		
		$parentData = JSON.stringify(dataItem);
		
		var url = _g_contextPath_ + "/budget/bonbuDeptYesilDaebiPopup";
		
		window.name = "parentForm";
		var openWin = window.open(url,"childForm","width=1400, height=580, resizable=yes , scrollbars=yes, status=no, top=200, left=350","newWindow");
	}
	
	function lowerGridDataBound(e) {
		var grid = e.sender;

		if (grid.dataSource.total() == 0) {
			var colCount = grid.columns.length + 2;
			$(e.sender.wrapper).find('tbody').append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
		}
		
		$(".lowerProgress").each(function(){
            var row = $(this).closest("tr");
            var model = grid.dataItem(row);
            var bgColor = '';
            var percent = "";
			
            /* progress bar color */
       	    bgColor = "#86E57F";
            
            $(this).kendoProgressBar({
            	type : "percent",
            	change: function(e) {
                    this.progressWrapper.css({
                      "background-color": bgColor,
                      "border-color": bgColor
                    });
                  },
              max: 100,
              width : 80
            });
            
            if ($(this).data("flag") === 1) {
            	percent = model.AMT5;           	
            } else if ($(this).data("flag") === 2) {
            	percent = model.AMT7;
            } 
            
            $(this).data("kendoProgressBar").value(percent);
          });
		
		  $(".k-progress-status").css("color", "black");
	}
	
	function upperGridDataBound(e) {
		var grid = e.sender;

		if (grid.dataSource.total() == 0) {
			var colCount = grid.columns.length + 2;
			$(e.sender.wrapper).find('tbody').append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
		}
		
		$(".upperProgress").each(function(){
            var row = $(this).closest("tr");
            var model = grid.dataItem(row);
            var bgColor = '';
            var percent = "";
			
            /* progress bar color */
       	    bgColor = "#86E57F";
            
            $(this).kendoProgressBar({
            	type : "percent",
            	change: function(e) {
                    this.progressWrapper.css({
                      "background-color": bgColor,
                      "border-color": bgColor
                    });
                  },
              max: 100,
              width : 80
            });
            
            if ($(this).data("flag") === 1) {
            	percent = model.AMT5;           	
            } else if ($(this).data("flag") === 2) {
            	percent = model.AMT7;
            } 
            
            $(this).data("kendoProgressBar").value(percent);
          });
		
		  $(".k-progress-status").css("color", "black");
	}
	
	function searchMainGrid() {
		$('#upperGrid').data('kendoGrid').dataSource.transport.options.read.url = $upperGridURL;
		$('#lowerGrid').data('kendoGrid').dataSource.transport.options.read.url = $lowerGridURL;
		$('#upperGrid').data('kendoGrid').dataSource.read(0);
		$('#lowerGrid').data('kendoGrid').dataSource.read(0);
	}
	
	function excel() {
		
		var upperList = $('#upperGrid').data('kendoGrid')._data;
		var lowerList = $('#lowerGrid').data('kendoGrid')._data;
		var title = '본부별 예실 대비 현황';
		
		$.ajax({
	 		url: _g_contextPath_+"/budget/budgetExcel",
	 		dataType : 'json',
	 		data : { upperParam : JSON.stringify(upperList), lowerParam : JSON.stringify(lowerList), title : title },
	 		type : 'POST',
	 		async : false,
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
			<h4>본부별 예실 대비 현황</h4>
		</div>
	</div>
	
	<div class="sub_contents_wrap">
		<div class="com_ta">
			<div class="top_box gray_box" id = "dataBox">
				<dl>
					<dt>기준일자</dt>
					<dd style="width:35%">
						<input type="text" style="width:40%" id = "standardDate" style = "" value=""/>
					</dd>
				</dl>
			</div>
		</div>
				
		<div class="btn_div mt10 cl">
			<div class="left_div">
				<p class="tit_p mt5 mb0">※ 본부별 예실 대비 현황</p>
			</div>
			<div class="right_div">
				<div class="controll_btn p0">
					<button type="button" id="" onclick = "excel()">엑셀</button>
					<button type="button" id="" onclick = "searchMainGrid()">조회</button>
				</div>
			</div>
		</div>
		
		<div class="com_ta2" style="height: 140px;">
			<div  id = "upperGrid">
			</div>
		</div>
		
		<div class="btn_div mt10 cl">
			<div class="left_div">
				<!-- <p class="tit_p mt5 mb0">상세 집행 내용</p> -->
			</div>
			<div class="right_div">
				<div class="controll_btn p0">
				</div>
			</div>
		</div>
		
		<div class="com_ta2">
			<div  id = "lowerGrid">
			</div>
		</div>
	</div>
</div>
</body>

