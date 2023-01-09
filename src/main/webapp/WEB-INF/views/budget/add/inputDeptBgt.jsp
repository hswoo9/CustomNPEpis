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
	.pop_con .ft {height: 40px !important;}
	.dec { color : blue !important; }
	.inc { color : red !important; }
	.k-grid-header th.k-header { white-space : normal !important; }
</style>
<script type="text/javascript">
 var first = true;
 var selRow = '';
 var deptSeq = '<c:out value="${deptSeq}"/>';
 var deptName = '<c:out value="${deptName}"/>';
 var compSeq = '<c:out value="${compSeq}"/>';
 var $mainGridURL = _g_contextPath_ + "/budget/getDeptPjtBgt";
 
	$(function() {
		Init.ajax();
		
		Init.kendoFunction();
		Init.kendoGrid();
		Init.eventListener();
	})
	
	var Init = {
			ajax : function() {
				$.ajax({
			 		url: _g_contextPath_+"/kukgoh/getErpDeptNum",
			 		dataType : 'json',
			 		data : { deptSeq : deptSeq },
			 		type : 'POST',
			 		async : false,
			 		success: function(result){
			 			$('#erpDeptSeq').val(result.erpDeptSeq);
			 		}
			 	});
			},
			kendoFunction : function() {
				$("#projectPopup").kendoWindow({
				    width: "600px",
				    visible: false,
				    actions: ["Close"],
				}).data("kendoWindow").center();
				
				$("#inputPopup").kendoWindow({
				    width: "800px",
				   height: "760px",
				    visible: false,
				    actions: ["Close"]
				}).data("kendoWindow").center();
				
				$("#standardDate").kendoDatePicker({
				    depth: "decade",
				    start: "decade",
				    culture : "ko-KR",
					format : "yyyy",
					value : new Date()
				});
				
				$("#PJT_TERM_TO").kendoDatePicker({
				    depth: "year",
				    start: "year",
				    culture : "ko-KR",
					format : "yyyy-MM"
				});
				
				$("#PJT_TERM_FROM").kendoDatePicker({
				    depth: "year",
				    start: "year",
				    culture : "ko-KR",
					format : "yyyy-MM"
				});
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
		  	      				data.deptSeq =  $('#erpDeptSeq').val();
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
			        	{	title : '본부',	field : 'HDEPT_NM', width : 90, locked : true, headerAttributes : { "class" : 'custom-rowspan' }  },
			        	{	title : '부서',	field : 'DEPT_NM', width : 90, locked : true,  headerAttributes : { "class" : 'custom-rowspan' }  },
			        	{	title : '코드',	field : 'PJT_CD', width : 100, locked : true },
			        	{	title : '프로젝트명',	field : 'PJT_NM', width : 100, locked : true },
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
			        					{	title : '자기부담금',	template : function(data) { return Budget.fn_formatMoney(data.BGT_AMT4) }, width : 110},
			        					{	title : '지자체부담금',	template : function(data) { return Budget.fn_formatMoney(data.BGT_AMT5) }, width : 120},
			        					{	title : '국고보조금',	template : function(data) { return Budget.fn_formatMoney(data.BGT_AMT6) }, width : 110}
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
		        			, width : 700
		        			, headerAttributes : { style : 'color: red;' }
			        	},
			        	{	title : '기타(D)',	template : function(data) { return Budget.fn_formatMoney(data.BGT_AMT17) }, width : 65, headerAttributes : { style : 'color: blue;' }},
			        	{	title : '<p>자기이월분</p> (E=A+B+D-C)',
			        		encoded: false,
			        		template : function(data) {
			        			return Budget.fn_formatMoney(data.BGT_AMT18)
		        			}, width : 130},
			        	{	
			        		title : '입력',
			        		template : function(data) { 
			        			return '<input type="button" class="text_blue" style="width: 80px;" onclick="viewInput(this);" value="입력">';
		        			}
			        		, width : 130
			        	},
			        	{	
			        		title : '취소',
			        		template : function(data) {
			        			return '<input type="button" class="text_blue" style="width: 80px;" onclick="cancel(this);" value="취소">';
		        			}
			        		, width : 130
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
				
				$(document).on("click", "#inputPopupCancel", function(e) {
					$("#inputPopup").data("kendoWindow").close();
				})
				
				$(document).on("click", "#inputBtn", function(e) {
					fn_input();
				})
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
						if (key.endsWith('17')) {
							D += typeof row[key] !== 'number' ? Number(row[key].replace(/,/gi, '')) : row[key];
						} else if (key.endsWith('11') || key.endsWith('12') || key.endsWith('13') || key.endsWith('14') || key.endsWith('15') || key.endsWith('16')) {
							C += typeof row[key] !== 'number' ? Number(row[key].replace(/,/gi, '')) : row[key];
						} else if (key.endsWith('4') || key.endsWith('5') || key.endsWith('6') || key.endsWith('7') || key.endsWith('8') || key.endsWith('9')) {
							B += typeof row[key] !== 'number' ? Number(row[key].replace(/,/gi, '')) : row[key];
						} else if (key.endsWith('2')) {
							A += typeof row[key] !== 'number' ? Number(row[key].replace(/,/gi, '')) : row[key];
						} 
						
					}
				}
			}	
		}
		
		E = (A + B + D) - C;
		
		return E;
	}
	
	function cancel(param) {
		var row = $("#mainGrid").data("kendoGrid").dataItem($(param).closest("tr"));
		
		var paramMap = {};
		
		paramMap.coCd = compSeq;
		paramMap.deptSeq = $('#erpDeptSeq').val();;
		paramMap.pjtCd = row.PJT_CD;
		paramMap.bgtYear = $("#standardDate").val();
		
		$.ajax({
	 		url: _g_contextPath_+"/budget/cancelDeptPjtBgt",
	 		dataType : 'json',
	 		data : paramMap,
	 		type : 'POST',
	 		async : false,
	 		success: function(result){
	 			if (result.OUT_YN === 'Y') {
		 			alert('취소 완료되었습니다.');
		 			searchMainGrid();
	 			} else {
	 				alert(result.OUT_MSG);
	 			}
	 		}
	 	});
	}
	
	function fn_input() {
		
		$.ajax({
	 		url: _g_contextPath_+"/budget/saveDeptPjtBgt",
	 		dataType : 'json',
	 		data : makeConvertData(),
	 		type : 'POST',
	 		async : false,
	 		success: function(result){
	 			if (result.OUT_YN === 'Y') {
		 			alert('입력 완료되었습니다.');
		 			inputMainGrid();
		 			$("#inputPopup").data("kendoWindow").close();
	 			} else {
	 				alert(result.OUT_MSG);
	 			}
	 		}
	 	});
	}
	
	function viewInput(param) {
		var row = $("#mainGrid").data("kendoGrid").dataItem($(param).closest("tr"));
		
		selRow = row;
		
		for ( var key in row ) {
			if (row.hasOwnProperty(key)) {
				if ($('#' + key).length > 0) {
					$('#' + key).val(key.startsWith('BGT_AMT') ? Budget.fn_formatMoney(row[key]) : row[key]);
				}
			}	
		}
		
		$.ajax({
	 		url: _g_contextPath_+"/budget/callGetPjtBudget",
	 		dataType : 'json',
	 		data : { div : '1', coCd : row.CO_CD, month : $('#standardDate').val() + '12', pjtCd : row.PJT_CD },
	 		type : 'POST',
	 		success: function(result){
	 			for (var key in result) {
	 				$('#' + key).val(Budget.fn_formatMoney(result[key]));
	 			}
	 		}
	 	});
		
		$('#chkMsg').html(selRow.CHK_MSG);
		
		$("#inputPopup").data("kendoWindow").open();
	}
	
	function makeConvertData() {
		
		var paramMap = {};
		
		paramMap.coCd = compSeq;
		paramMap.deptSeq = $('#erpDeptSeq').val();
		paramMap.pjtCd = $('#PJT_CD').val();
		paramMap.bgtYear = $("#standardDate").val();
		paramMap.pjtInfo = $('#PJT_INFO').val();
		paramMap.fromMonth = $('#PJT_TERM_FROM').val().replace(/-/gi, '');
		paramMap.toMonth = $('#PJT_TERM_TO').val().replace(/-/gi, '');
		paramMap.bgtAtm1 = $('#BGT_AMT1').val().replace(/,/gi, '');
		paramMap.bgtAtm2 = $('#BGT_AMT2').val().replace(/,/gi, '');
		paramMap.bgtAtm3 = $('#BGT_AMT3').val().replace(/,/gi, '');
		paramMap.bgtAtm4 = $('#BGT_AMT4').val().replace(/,/gi, '');
		paramMap.bgtAtm5 = $('#BGT_AMT5').val().replace(/,/gi, '');
		paramMap.bgtAtm6 = $('#BGT_AMT6').val().replace(/,/gi, '');
		paramMap.bgtAtm7 = $('#BGT_AMT7').val().replace(/,/gi, '');
		paramMap.bgtAtm8 = $('#BGT_AMT8').val().replace(/,/gi, '');
		paramMap.bgtAtm9 = $('#BGT_AMT9').val().replace(/,/gi, '');
		paramMap.bgtAtm10 =$('#BGT_AMT10').val().replace(/,/gi, '');
		paramMap.bgtAtm11 =$('#BGT_AMT11').val().replace(/,/gi, ''); 
		paramMap.bgtAtm12 =$('#BGT_AMT12').val().replace(/,/gi, ''); 
		paramMap.bgtAtm13 =$('#BGT_AMT13').val().replace(/,/gi, ''); 
		paramMap.bgtAtm14 =$('#BGT_AMT14').val().replace(/,/gi, ''); 
		paramMap.bgtAtm15 =$('#BGT_AMT15').val().replace(/,/gi, ''); 
		paramMap.bgtAtm16 =$('#BGT_AMT16').val().replace(/,/gi, ''); 
		paramMap.bgtAtm17 =$('#BGT_AMT17').val().replace(/,/gi, ''); 
		
		return paramMap;
	}
	
	function inputMainGrid() {
		
		selRow.set('PJT_INFO', $('#PJT_INFO').val());
		selRow.set('FROM_MONTH', $('#PJT_TERM_FROM').val());
		selRow.set('TO_MONTH', $('#PJT_TERM_TO').val().replace(/-/gi, ''));
		selRow.set('BGT_AMT2',$('#BGT_AMT2').val());
		selRow.set('BGT_AMT4',$('#BGT_AMT4').val());
		selRow.set('BGT_AMT5',$('#BGT_AMT5').val());
		selRow.set('BGT_AMT6',$('#BGT_AMT6').val());
		selRow.set('BGT_AMT7',$('#BGT_AMT7').val());
		selRow.set('BGT_AMT8',$('#BGT_AMT8').val());
		selRow.set('BGT_AMT9',$('#BGT_AMT9').val());
		selRow.set('BGT_AMT11',$('#BGT_AMT11').val()); 
		selRow.set('BGT_AMT12',$('#BGT_AMT12').val()); 
		selRow.set('BGT_AMT13',$('#BGT_AMT13').val()); 
		selRow.set('BGT_AMT14',$('#BGT_AMT14').val()); 
		selRow.set('BGT_AMT15',$('#BGT_AMT15').val()); 
		selRow.set('BGT_AMT16',$('#BGT_AMT16').val()); 
		selRow.set('BGT_AMT17',$('#BGT_AMT17').val());
		
		selRow.set('BGT_AMT18', fn_calAmt(selRow)); 
		
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
	
	function excel() {
		
		var mainList = $('#mainGrid').data('kendoGrid')._data;
		var templateName = 'inputDeptBgtTemplate';
		var title = '사업별 예산실적 현황';
		
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
			<h4>사업별 예산실적 현황</h4>
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
						<input type="text" style="" id = "deptName" value="${deptName }" disabled/>
						<input type="hidden" style="" id = "erpDeptSeq" value="" disabled/>
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
				<p class="tit_p mt5 mb0">사업별 예산실적 현황</p>
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

<!-- 부서 예산현황 입력 팝업 -->
<div class="pop_wrap_dir" id="inputPopup" style="width:800px;">
	<div class="pop_head">
		<h1>사업별 예산실적현황 입력</h1>
	</div>
	<div class="pop_con" style="padding-top: 5px; height:666px;">
		<div class="top_box" style="height: 30px; line-height: 30px;">
			<span id="chkMsg" style="color: blue; margin-left: 20px;"></span>
		</div>
		<div class="top_box">
			<dl>
				<dt class="ar" style="width: 80px;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> 부서</dt>
				<dd style="">
					<input type="hidden" id="DEPT_CD" style="width: 120px" />
					<input type="text" id="DEPT_NM" style="width: 120px" disabled/>
				</dd>
			</dl>
			<dl>
				<dt class="ar" style="width: 80px;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> 프로젝트</dt>
				<dd style="">
					<input type="text" id="PJT_CD" style="width: 120px" disabled/>
					<input type="text" id="PJT_NM" style="width: 120px" disabled/>
					<input type="text" id="PJT_ENM" style="width: 120px" disabled/>
				</dd>
			</dl>
			<dl>
				<dt class="ar" style="width: 80px;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> 사업내용</dt>
				<dd style="">
					<input type="text" id="PJT_INFO" style="width: 600px" />
				</dd>
			</dl>
			<dl>
				<dt class="ar" style="width: 80px;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> 사업기간</dt>
				<dd style="">
					<input type="text" id="PJT_TERM_FROM" style="width: 120px" />
					&nbsp; ~ &nbsp;
				</dd>
				<dd style="">
					<input type="text" id="PJT_TERM_TO" style="width: 120px" />
				</dd>
			</dl>
			<dl>
				<dt class="ar" style="width: 80px;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> 예산금액</dt>
				<dd style="">
					<input type="text" id="BGT_AMT1" style="width: 120px" disabled/>
				</dd>
				<dt class="ar" style="width: 80px;"> 전기이월금액</dt>
				<dd style="">
					<input type="text" id="BGT_AMT2" class="amountUnit" style="width: 120px" numberOnly />
				</dd>
			</dl>
			<dl class="ft">
				<dt class="ar inc" style="">&lt;&lt; 증가_교부.지급 &gt;&gt; </dt>
				<dt class="ar" style="width: 80px;"> 수입금액</dt>
				<dd style="">
					<input type="text" id="BGT_AMT3" style="width: 120px" disabled/>
				</dd>
			</dl>
			<dl>
				<dt class="ar" style="width: 80px;"> 자기부담금</dt>
				<dd style="">
					<input type="text" id="BGT_AMT4" class="amountUnit" style="width: 120px" numberOnly />
				</dd>
				<dt class="ar" style="width: 80px;"> 지자체부담금</dt>
				<dd style="">
					<input type="text" id="BGT_AMT5" class="amountUnit" style="width: 120px" numberOnly />
				</dd>
				<dt class="ar" style="width: 80px;"> 국고보조금</dt>
				<dd style="">
					<input type="text" id="BGT_AMT6" class="amountUnit" style="width: 120px" numberOnly />
				</dd>
			</dl>
			<dl class="ft">
				<dt class="ar inc" style="">&lt;&lt; 증가_발생이자 &gt;&gt; </dt>
			</dl>
			<dl>
				<dt class="ar" style="width: 80px;"> 자기부담금</dt>
				<dd style="">
					<input type="text" id="BGT_AMT7" class="amountUnit" style="width: 120px" numberOnly />
				</dd>
				<dt class="ar" style="width: 80px;"> 지자체부담금</dt>
				<dd style="">
					<input type="text" id="BGT_AMT8" class="amountUnit" style="width: 120px" numberOnly />
				</dd>
				<dt class="ar" style="width: 80px;"> 국고보조금</dt>
				<dd style="">
					<input type="text" id="BGT_AMT9" class="amountUnit" style="width: 120px" numberOnly />
				</dd>
			</dl>
			<dl class="ft">
				<dt class="ar dec" style="">&lt;&lt; 감소_교부.지급 &gt;&gt; </dt>
				<dt class="ar" style="width: 80px;"> 집행금액</dt>
				<dd style="">
					<input type="text" id="BGT_AMT10" style="width: 120px" disabled/>
				</dd>
			</dl>
			<dl>
				<dt class="ar" style="width: 80px;"> 자기부담금</dt>
				<dd style="">
					<input type="text" id="BGT_AMT11" class="amountUnit" style="width: 120px" numberOnly />
				</dd>
				<dt class="ar" style="width: 80px;"> 지자체부담금</dt>
				<dd style="">
					<input type="text" id="BGT_AMT12" class="amountUnit" style="width: 120px" numberOnly />
				</dd>
				<dt class="ar" style="width: 80px;"> 국고보조금</dt>
				<dd style="">
					<input type="text" id="BGT_AMT13" class="amountUnit" style="width: 120px" numberOnly />
				</dd>
			</dl>
			<dl class="ft">
			<dt class="ar dec" style="">&lt;&lt; 감소_발생이자 &gt;&gt; </dt>
			</dl>
			<dl>
				<dt class="ar" style="width: 80px;"> 자기부담금</dt>
				<dd style="">
					<input type="text" id="BGT_AMT14" class="amountUnit" style="width: 120px" numberOnly />
				</dd>
				<dt class="ar" style="width: 80px;"> 지자체부담금</dt>
				<dd style="">
					<input type="text" id="BGT_AMT15" class="amountUnit" style="width: 120px" numberOnly />
				</dd>
				<dt class="ar" style="width: 80px;"> 국고보조금</dt>
				<dd style="">
					<input type="text" id="BGT_AMT16" class="amountUnit" style="width: 120px" numberOnly />
				</dd>
			</dl>
		</div>
		<div class="top_box">
			<dl>
				<dt class="ar" style="width: 80px;"> 기타금액</dt>
				<dd style="">
					<input type="text" id="BGT_AMT17" class="amountUnit" style="width: 120px" numberOnly />
				</dd>
			</dl>
		</div>
	</div>

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" class="text_btn" id="inputBtn" value="입력" />
			<input type="button" class="text_btn" id="inputPopupCancel" value="닫기" />
		</div>
	</div>
</div>	
<!-- 부서 예산현황 입력 팝업 -->

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