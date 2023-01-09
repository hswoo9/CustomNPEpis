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
	.pop_con dl {height: 48px !important;}
	.pop_con .ft {height: 33px !important;}
	.dec { color : blue !important; }
	.inc { color : red !important; }
</style>
<script type="text/javascript">
 var first = true;
 var deptSeq = '<c:out value="${deptSeq}"/>';
 var deptName = '<c:out value="${deptName}"/>';
 var compSeq = '<c:out value="${compSeq}"/>';
 var $deptComboList = ''; 
 var $mainGridURL = _g_contextPath_ + "/budget/getDeptPjtBgt2";
 
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
			 			$deptComboList = result;
			 		}
			 	});
			},
			kendoFunction : function() {
				$("#dept").kendoComboBox({
				      dataSource: $deptComboList.resolutionDeptList,
				      dataTextField: "DEPT_NM",
					  dataValueField: "DEPT_CD",
					  height : 500,
					  index : 0
				});
				
				$("#standardDate").kendoDatePicker({
				    depth: "decade",
				    start: "decade",
				    culture : "ko-KR",
					format : "yyyy",
					value : new Date(),
					change : changeStandardDate
				});
				
				$("#projectPopup").kendoWindow({
				    width: "600px",
				    visible: false,
				    actions: ["Close"],
				}).data("kendoWindow").center();
			},
			kendoGrid : function() {
				/* 상단 그리드 */
				var mainGrid = $("#mainGrid").kendoGrid({
					dataSource : new kendo.data.DataSource({
						transport : {
							read : {
								url : _g_contextPath_+"/budget/initGrid",
								dataType : "json",
								type : 'post'
							},
							parameterMap: function(data, operation) {
		  	      				data.year = $("#standardDate").val();
		  	      				data.deptSeq = $('#dept').data('kendoComboBox').value();
		  	      				data.pjtCd = $('#pjtFromCd').val();
		    	     			return data;
		    	     		}
						},
						schema : {
							data : function(response) {
								return first ? [] : response.list;
							},
							total : function(response) {
								return first ? 0 : response.total;
							},
						}
					}),
					height : 600,
					dataBound : mainGridDataBound,
			        columns: [
			        	{	title : '본부',	field : 'HDEPT_NM', width : 90, locked : true, headerAttributes : { "class" : 'custom-rowspan' } },
			        	{	title : '부서',	field : 'DEPT_NM', width : 90, locked : true, headerAttributes : { "class" : 'custom-rowspan' }  },
			        	{	title : '코드',	field : 'PJT_CD', width : 100, locked : true  },
			        	{	title : '프로젝트명',	field : 'PJT_NM', width : 100, locked : true  },
			        	{	title : '세부사업명',	field : 'PJT_ENM', width : 100, locked : true  },
			        	{	title : '사업내용',	field : 'PJT_INFO', width : 100  },
			        	{	title : '수행기간',	field : 'PJT_TERM', width : 100  },
			        	{	title : '예산액',	template : function(data) { return Budget.fn_formatMoney(data.BGT_AMT1) }, width : 85 },
			        	{	title : '전기이월분(A)',	 template : function(data) { return Budget.fn_formatMoney(data.BGT_AMT2) }, width : 105, headerAttributes : { style : 'color: blue;' }},
			        	{	title : '수입실적',	template : function(data) { return Budget.fn_formatMoney(data.BGT_AMT3) }, width : 85},
			        	{
			        		title : '증가(B)',
			        		columns : [
			        			{
			        				title : '교부.지급',
			        				columns : [
			        					{	title : '자기부담금',	template : function(data) { return Budget.fn_formatMoney(data.BGT_AMT4) }, width : 80},
			        					{	title : '지자체부담금',	template : function(data) { return Budget.fn_formatMoney(data.BGT_AMT5) }, width : 90},
			        					{	title : '국고보조금',	template : function(data) { return Budget.fn_formatMoney(data.BGT_AMT6) }, width : 80}
			        				]
			        				, width : 350
			        			},
			        			{
			        				title : '발생이자',
			        				columns : [
			        					{	title : '자기부담금',	template : function(data) { return Budget.fn_formatMoney(data.BGT_AMT7) }, width : 110},
			        					{	title : '지자체부담금',	template : function(data) { return Budget.fn_formatMoney(data.BGT_AMT8) }, width : 120},
			        					{	title : '국고보조금',	template : function(data) { return Budget.fn_formatMoney(data.BGT_AMT9) }, width : 110}
			        				]
			        				, width : 350
			        			}
			        		]
		        			, width : 700
		        			, headerAttributes : { style : 'color: blue;' }
			        	},
			        	{	title : '지출실적',	template : function(data) { return Budget.fn_formatMoney(data.BGT_AMT10) }, width : 85},
			        	{
			        		title : '감소(C)',
			        		columns : [
			        			{
			        				title : '교부.지급',
			        				columns : [
			        					{	title : '자기부담금',	template : function(data) { return Budget.fn_formatMoney(data.BGT_AMT11) }, width : 110},
			        					{	title : '지자체부담금',	template : function(data) { return Budget.fn_formatMoney(data.BGT_AMT12) }, width : 120},
			        					{	title : '국고보조금',	template : function(data) { return Budget.fn_formatMoney(data.BGT_AMT13) }, width : 110}
			        				]
			        				, width : 350
			        			},
			        			{
			        				title : '발생이자',
			        				columns : [
			        					{	title : '자기부담금',	template : function(data) { return Budget.fn_formatMoney(data.BGT_AMT14) }, width : 110},
			        					{	title : '지자체부담금',	template : function(data) { return Budget.fn_formatMoney(data.BGT_AMT15) }, width : 120},
			        					{	title : '국고보조금',	template : function(data) { return Budget.fn_formatMoney(data.BGT_AMT16) }, width : 110}
			        				]
			        				, width : 350
			        			}
			        		]
			        		,width : 700
			        		,headerAttributes : { style : 'color: blue;' }
			        	},
			        	{	title : '기타(D)',	template : function(data) { return Budget.fn_formatMoney(data.BGT_AMT17) }, width : 65, headerAttributes : { style : 'color: blue;' }},
			        	{	title : '<p>자기이월분</p> (E=A+B+D-C)',
			        		encoded: false,
			        		template : function(data) {
			        			return Budget.fn_formatMoney(data.BGT_AMT18)
		        			}, width : 130
	        			},
	        			{
			        		title : '상태 메시지',
			        		field : 'CHK_MSG',
			        		width : 130
			        	}
			        ]
			    }).data("kendoGrid");
				/* 상단 그리드 */
				
				/* 프로젝트 팝업 그리드 */
				var projectGrid = $("#projectGrid").kendoGrid({
			        dataSource: new kendo.data.DataSource({
			    	    transport: { 
			    	        read:  {
			    	            url: _g_contextPath_+'/budget/projectList2',
			    	            dataType: "json",
			    	            type: 'post'
			    	        },
			    	      	parameterMap: function(data, operation) {
		   	      				data.fiscal_year = $("#standardDate").val().substring(0, 4);
		    	      			data.project = $("#projectName").val();
		    	      			data.deptCd = $('#erpDeptSeq').val();
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
				$(document).on("click", "#mainGrid tbody tr", function(e) {
					row = $(this)
					grid = $('#mainGrid').data("kendoGrid"),
					dataItem = grid.dataItem(row);
					
					console.log(dataItem);	
				})
				
				$("#pjtFromSearch").on("click", function() {
					
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
	
	function fn_calAmt(row) {
		
		var A = 0;
		var B = 0;
		var C = 0; 
		var D = 0;
		var E = 0;
		
		for ( var key in row ) {
			if (row.hasOwnProperty(key)) {
				if ($('#' + key).length > 0) {
					if (key.startsWith('BGT_AMT')) {
						if (key.endsWith('2')) {
							A += Number(row[key].replace(/,/gi, ''));
						} else if (key.endsWith('4') || key.endsWith('5') || key.endsWith('6') || key.endsWith('7') || key.endsWith('8') || key.endsWith('9')) {
							B += Number(row[key].replace(/,/gi, ''));
						} else if (key.endsWith('11') || key.endsWith('12') || key.endsWith('13') || key.endsWith('14') || key.endsWith('15') || key.endsWith('16')) {
							C += Number(row[key].replace(/,/gi, ''));
						} else if (key.endsWith('17')) {
							D += Number(row[key].replace(/,/gi, ''));
						}
					}
				}
			}	
		}
		
		E = (A + B + D) - C;
		
		return E;
	}
	
	function mainGridDataBound(e) {
		var grid = e.sender;
		
		/* for (var i = 0; i < this.columns.length; i++) {
			
            this.autoFitColumn(i);
          } */

		if (grid.dataSource.total() == 0) {
			var colCount = grid.columns.length + 3;
			$(e.sender.wrapper).find('.k-grid-content tbody').append('<tr class="kendo-data-row" style="height: 37px;"><td colspan="9" class="no-data">데이터가 없습니다.</td></tr>');
			$(e.sender.wrapper).find('.k-grid-content-locked tbody').append('<tr class="kendo-data-row" style="height: 37px;"><td colspan="5" class="no-data"></td></tr>');
		}
	}
	
	function searchMainGrid() {
		first = false;
		$('#mainGrid').data('kendoGrid').dataSource.transport.options.read.url = $mainGridURL;
		$('#mainGrid').data('kendoGrid').dataSource.read();
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
	
	function excel() {
		
		var mainList = $('#mainGrid').data('kendoGrid')._data;
		var templateName = 'viewDeptBgtTemplate';
		var title = '사업별 예산실적 현황(관리자)';
		
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
			<h4>사업별 예산실적 현황(관리자)</h4>
		</div>
	</div>
	
	<div class="sub_contents_wrap">
		<div class="com_ta">
			<div class="top_box gray_box" id = "dataBox">
				<dl>
					<dt>기준년도</dt>
					<dd style="width:15%">
						<input type="text" style="" id = "standardDate" style = "" value=""/>
					</dd>
					<dt>부서</dt>
					<dd style="width:15%">
						<input type="text" style="" id = "dept" value="" />
					</dd>
					<dt style="">프로젝트</dt>
					<dd style="width:20%">
						<input type="text" style="width:60%" id ="pjtFrom" disabled/>
						<input type="hidden" id ="pjtFromCd"/>
						<button type="button" id ="pjtFromSearch" value="검색">
						<img style="position:inherit;" src="<c:url value='/Images/btn/search_icon2.png'/>"></button>
					</dd>
				</dl>
			</div>
		</div>
				
		<div class="btn_div mt10 cl">
			<div class="left_div">
				<p class="tit_p mt5 mb0">사업별 예산실적 현황(관리자)</p>
			</div>
			<div class="right_div">
				<div class="controll_btn p0">
					<button type="button" id="" onclick = "excel()">엑셀</button>
					<button type="button" id="" onclick = "searchMainGrid()">조회</button>
				</div>
			</div>
		</div>
		
		<div class="com_ta2" style="height: 600px;">
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
		<div class="com_ta mt15">
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

