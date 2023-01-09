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
dt {
	text-align : left;
	width : 10%;
}
dd{
	width: 11.5%;
} 
dd input{ 
  	width : 80%;
}
.k-grid-toolbar{
	float : right;
}

</style>
<body>

<script type="text/javascript">

var $accounting_unit_list;
var $mokTempList;
var $rowData = {};					//그리드한줄정보
var $gridIndex = 0;					//그리드인덱스번호
var $lease_id = "";							//임대계약id
var $gridFlag = false;
var selectedBudgetPop;
var selectedMokPop;
var $mainGridURL = _g_contextPath_ + "/budget/caseActList";
var $mainGrid2URL = _g_contextPath_ + "/budget/caseActDetailList";

var $dataSource = new kendo.data.DataSource({		//그리드데이터소스
	serverPaging : true,
	pageSize : 1000,
	transport : {
		read : {
			url : _g_contextPath_+ "/budget/initGrid",
			dataType : "json",
			type : "post"
		},
		parameterMap: function(data, operation) {

			if($gridFlag){
				data.fiscal_year = $("#fiscal_year").val();
				data.totalCount = 1;
			}else{
				data.fiscal_year = ($("#fiscal_year").val())*1 +1;
				data.totalCount = 0;
			}
			
			data.accounting_unit = $("#accounting_unit").data("kendoDropDownList").value();
			data.from_project = $("#from_project_cd").val();
			data.to_project = $("#from_project_cd").val();
			data.from_budget_name = $("#from_budget_cd").val();
			data.to_budget_name = $("#to_budget_cd").val();
			data.from_mok_name = $("#from_mok_cd").val();
			data.to_mok_name = $("#to_mok_cd").val();
			data.from_standard_period = $("#from_standard_period").val().replace(/-/gi,"");
			data.to_standard_period = $("#to_standard_period").val().replace(/-/gi,"");
	     	return data;
	     }
	},
	schema : {
		data : function(response){
			return response.list;
		},
	    model : {
	    	fields : {

	    	}
	    }
	}
});

var $dataSource2 = new kendo.data.DataSource({		//그리드데이터소스
	serverPaging : true,
	pageSize : 1000,
	transport : {
		read : {
			url : _g_contextPath_+ "/budget/initGrid",
			dataType : "json",
			type : "post"
		},
		parameterMap: function(data, operation) {
			
			data.from_standard_period = $("#from_standard_period").val().replace(/-/gi,"");
			data.to_standard_period = $("#to_standard_period").val().replace(/-/gi,"");
			
			if($rowData.DIV_CD!=undefined){
				data.div_cd = $rowData.DIV_CD;
				data.pjt_cd = $rowData.PJT_CD;
				data.bgt_cd = $rowData.BGT_CD;
			}else{
				data.div_cd = '';
				data.pjt_cd = '';
				data.bgt_cd = '';
			}
	     	return data;
	     }
	},
	schema : {
		data : function(response){
			return response.list;
		},
		total : function(response) {
	        return response.totalCount;
	    },
	    model : {
	    	fields : {

	    	}
	    }
	}
});

	$(function(){
		
		$("#fiscal_year").kendoDatePicker({
		    depth: "decade",
		    start: "decade",
		    culture : "ko-KR",
			format : "yyyy",
			value : new Date(),
			change : changeCombo
		});
		
		makeComboList();
		
		$("#accounting_unit").kendoDropDownList({
			dataTextField : 'DIV_NM' ,
			dataValueField : 'DIV_CD' ,
			dataSource : $accounting_unit_list
		});
		
		projectGrid();
		
		$("#projectFromSearch").on("click", function() {
			
			 $('#projectName').val("");
			
			 $("#projectPopup").data("kendoWindow").open();
			 projectGridReload();
		});
		
		$("#projectName").on("keyup", function(e){
			if (e.keyCode === 13) {
				projectGridReload();
			}
		});
		
		budgetGrid();
		
		$("#budgetFromSearch, #budgetToSearch").on("click", function() {
			
			var selected = $(this).attr("id");
			
			$('#budgetName').val("");
			
			if (selected === "budgetToSearch") {
				$("to_budget_name").val("");
				selectedBudgetPop = "to";
			} else {
				$("to_budget_name").val("");
				selectedBudgetPop = "from";
			}
			
			 $("#budgetPopup").data("kendoWindow").open();
			 budgetGridReload();
		});
		
		$("#budgetName").on("keyup", function(e){
			if (e.keyCode === 13) {
				budgetGridReload();
			}
		});
		
		mokGrid();
		
		$("#mokFromSearch, #mokToSearch").on("click", function() {
			
			var selected = $(this).attr("id");
			
			$('#mokName').val("");
			
			if (selected === "mokToSearch") {
				$("to_mok_name").val("");
				selectedMokPop = "to";
			} else {
				$("from_mok_name").val("");
				selectedBudgetPop = "from";
			}
			
			 $("#mokPopup").data("kendoWindow").open();
			 mokGridReload();
		});
		
		$("#mokName").on("keyup", function(e){
			if (e.keyCode === 13) {
				mokGridReload();
			}
		});
		
		$("#projectPopup").kendoWindow({
			    width: "600px",
			   height: "750px",
			    visible: false,
			    actions: ["Close"]
			}).data("kendoWindow").center();
		
		$("#budgetPopup").kendoWindow({
		    width: "600px",
		   height: "750px",
		    visible: false,
		    actions: ["Close"]
		}).data("kendoWindow").center();
		
		$("#mokPopup").kendoWindow({
		    width: "650px",
		   height: "750px",
		    visible: false,
		    actions: ["Close"]
		}).data("kendoWindow").center();
		
		
		$("#from_standard_period").kendoDatePicker({
		    depth: "month",
		    start: "month",
		    culture : "ko-KR",
			format : "yyyy-MM-dd",
			value : new Date("${year}",0,1),
			change : makeToDateMin
		});
		
		$("#to_standard_period").kendoDatePicker({
		    depth: "month",
		    start: "month",
		    min : $("#from_standard_period").data("kendoDatePicker").value(),
		    culture : "ko-KR",
			format : "yyyy-MM-dd",
			value : new Date()
		});
		
		$("#projectPopupCancel").on("click", function() {
			projectPopupClose();
		});
		
		$("#budgetPopupCancel").on("click", function() {
			budgetPopupClose();
		});
		
		$("#mokPopupCancel").on("click", function() {
			mokPopupCancel();
		});
		
		mainGrid();
		mainGrid2();
		
	});
	
	function searchMainGrid() {
		$dataSource.transport.options.read.url = $mainGridURL;
		$dataSource2.transport.options.read.url = $mainGrid2URL;
		$('#grid').data('kendoGrid').dataSource.read(0);
	}
	
	function makeComboList(){
		
		var data = {
				fiscal_year : $("#fiscal_year").val(),
				project : $("#from_project").val()
		}
		
		
		$.ajax({
			url : _g_contextPath_+ "/budget/accountingComboList",
			data : data,
			async : false,
			type : "POST",
			success : function(result){				
				$accounting_unit_list = result.accountingUnitList;
			}
		});
	}
	
	function changeCombo(){
		makeComboList();
	}
	
	function makeToDateMin(){
		
		if($("#from_standard_period").val()>$("#to_standard_period").val()){
			$("#from_standard_period").data("kendoDatePicker").value(new Date());
			return;
		}
		
		$("#to_standard_period").data("kendoDatePicker").setOptions({
		    min: $("#from_standard_period").data("kendoDatePicker").value()
		});
	}
	
	function mainGrid(){
		
		var width = $(".sub_contents_wrap").width();
		
		var grid =  $("#grid").kendoGrid({
			toolbar : [
				{
					name : "excel",
					text : "Excel"
				}
				],
			excel : {
				fileName : '원인행위부.xlsx'
			},
			dataSource: $dataSource,
			height : 300,
			dataBound : dataBound,
			selectable : "row",
			sortable : true,
			persistSelection : true,
			columns : [
				{
					width : width*15/100,
					field : "DIV_NM",
					title : "회계단위"
				},
				{
					width : width*15/100,
					field : "PJT_NM",
					title : "프로젝트"
				},
				
				{
					width : width*15/100,
					field : "BGT_NM1",
					title : "예산"
				},
				{
					width : width*25/100,
					field : "BGT_NM2",
					title : "목"
				},
				{
					width : width*10/100,
					title : "예산액",
					field : "AMT1",
					template : function(e){
						if(e.AMT1 == null || e.AMT1 == ""){
							return '';
						}else{
							return e.AMT1.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
						}
						
					}
				},
				{
					width : width*10/100,
					title : "원인액",
					field : "AMT2",
					template : function(e){
						if(e.AMT2 == null || e.AMT2 == ""){
							return '';
						}else{
							return e.AMT2.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
						}
						
					}
				},
				{
					width : width*10/100,
					title : "잔액",
					field : "AMT3",
					template : function(e){
						if(e.AMT3 == null || e.AMT3 == ""){
							return '';
						}else{
							return e.AMT3.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
						}
						
					}
				}
				
			],
			change : selectRow
	
		}).data("kendoGrid");
		
		function selectRow(e){		//row클릭시 data 전역변수 처리
	
			row = e.sender.select();
			grid = $('#grid').data("kendoGrid");
			data = grid.dataItem(row);
			$rowData = data;
			$('#grid2').data('kendoGrid').dataSource.read(0);
			
		}
		
		$gridFlag = true;
		$rowData = {};
	};
	
	function mainGrid2(){
		
		var width = $(".sub_contents_wrap").width();
		
		var grid =  $("#grid2").kendoGrid({
			toolbar : [
				{
					name : "excel",
					text : "Excel"
				}
				],
			excel : {
				fileName : '원인행위부상세.xlsx'
			},
			dataSource: $dataSource2,
			height : 300,
			dataBound : dataBound,
			sortable : true,
			persistSelection : true,
			selectable : "row",
			columns : [
				
				{
					width : width*10/100,
					field : "ISU_DT",
					title : "수납(지출)일자"
				},
				{
					width : width*10/100,
					field : "GISU_DT",
					title : "결의일자"
				},
				
				{
					width : width*34/100,
					field : "RMK_DC",
					title : "적요"
				},
				{
					width : width*14/100,
					title : "예산액",
					field : "BUDGET_AM",
					template : function(e){
						if(e.BUDGET_AM == null || e.BUDGET_AM == ""){
							return '';
						}else{
							return e.BUDGET_AM.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
						}
						
					}
				},
				{
					width : width*14/100,
					title : "징수(지출)액",
					field : "UNIT_AM",
					template : function(e){
						if(e.UNIT_AM == null || e.UNIT_AM == ""){
							return '';
						}else{
							return e.UNIT_AM.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
						}
						
					}
				},
				{
					width : width*14/100,
					title : "잔액",
					field : "JAN_AM",
					template : function(e){
						if(e.JAN_AM == null || e.JAN_AM == ""){
							return '';
						}else{
							return e.JAN_AM.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
						}
						
					}
				},
				{
					width : width*4/100,
					title : "문서보기",
					template : function(e){
						if(e.DIV == 1){
							return '<input type="button" class="blue_btn" value="보기" onclick = "watchDoc('+e.GISU_SQ+','+e.GISU_DT2+')">';
						}else{
							return '';
						}
					}
				}
			],
			change : selectRow
	
		}).data("kendoGrid");
		
		function selectRow(e){		//row클릭시 data 전역변수 처리
	
			row = e.sender.select();
			grid = $('#grid2').data("kendoGrid");
			data = grid.dataItem(row);
			
		}
		
	};
	
	function watchDoc(gisu_sq, gisu_dt){

		$.ajax({
			url : _g_contextPath_+ "/budget/causeActDocSearch",
			data : {
				co_cd : "${userInfo.erpCompSeq}",
				gisu_dt : gisu_dt,
				gisu_sq : gisu_sq
			},
			async : false,
			type : "POST",
			success : function(result){				
				if(result[0].V_OUT_YN == 'N'){
					alert(result[0].V_OUT_MSG);
				}else{
					var dikeycode = result[0].V_OUT_C_DIKEYCODE;
					
					fn_docViewPop(dikeycode);
				}
			}
		});
		
	}
	
	function gridReload(){
	
		$gridIndex = 0;
		$('#grid').data('kendoGrid').dataSource.read();
		$rowData = {};
		
	}
	
	function gridReload2(){
		
		$gridIndex = 0;
		$('#grid2').data('kendoGrid').dataSource.read();
		
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
	
	function popDataBound(e) {
		
		for (var i = 0; i < this.columns.length; i++) {
           	this.autoFitColumn(i);
        }
		
		$gridIndex = 0;
		var grid = e.sender;
		if(grid.dataSource._data.length==0){
			var colCount = grid.columns.length;
			$(e.sender.wrapper)
				.find('tbody')
				.append('<tr class="kendo-data-row">' + 
						'<td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
		}
	}
	
/* 프로젝트 팝업 */
function projectGrid() {
	
	var grid = $("#projectGrid").kendoGrid({
        dataSource: new kendo.data.DataSource({
    	    transport: { 
    	        read:  {
    	            url: _g_contextPath_+'/budget/projectList',
    	            dataType: "json",
    	            type: 'post'
    	        },
    	      	parameterMap: function(data, operation) {
  	      				data.fiscal_year = $("#fiscal_year").val();
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
        					width : 20
        				},
        				{
        					title : "프로젝트 명",
        					field : "PJT_NM",
        					width : 45
        				},
        				{
        					title : "선택",
        					width : 15,
					    	template : '<input type="button" id="" class="text_blue" onclick="projectSelect(this);" value="선택">'
       		    	    }]
    }).data("kendoGrid");
}

//선택 클릭이벤트
function projectSelect(e){		
	var row = $("#projectGrid").data("kendoGrid").dataItem($(e).closest("tr"));
	
	$("#from_project").val(row.PJT_NM);
	$("#from_project_cd").val(row.PJT_CD);
	
	$("#projectPopup").data("kendoWindow").close();
}

function projectPopupClose(){
	 $("#projectPopup").data("kendoWindow").close();
}

function projectGridReload() {
	$("#projectGrid").data("kendoGrid").dataSource.read();
}
/* 프로젝트 팝업 */

/* 예산 팝업 */
function budgetGrid() {
	
	var grid = $("#budgetGrid").kendoGrid({
        dataSource: new kendo.data.DataSource({
    	    transport: { 
    	        read:  {
    	            url: _g_contextPath_+'/budget/budgetListAjax',
    	            dataType: "json",
    	            type: 'post'
    	        },
    	      	parameterMap: function(data, operation) {
 	      			data.fiscal_year = $("#fiscal_year").val();
    	      		data.to_project 		= $("#budgetName").val();
    	      		data.from_project = "";
    	     		return data;
    	     	}
    	    },
    	    dataBound : popDataBound,
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
        					title : "예산상위명",
        					field : "BUDGR_NM",
        					width : 20
        				},
        				{
        					title : "예산코드",
        					field : "BGT_CD",
        					width : 20
        				},
        				{
        					title : "예산명",
        					field : "BGT_NM",
        					width : 20
        				},
        				{
        					title : "선택",
        					width : 10,
					    	template : '<input type="button" id="" class="text_blue" onclick="budgetSelect(this);" value="선택">'
       		    	    }]
    }).data("kendoGrid");
}

//선택 클릭이벤트
function budgetSelect(e){		
	var row = $("#budgetGrid").data("kendoGrid").dataItem($(e).closest("tr"));
	
	if (selectedBudgetPop === "from") {
		$("#from_budget_name").val(row.BGT_NM);
		$("#from_budget_cd").val(row.BGT_CD);
	} else {
		$("#to_budget_name").val(row.BGT_NM);
		$("#to_budget_cd").val(row.BGT_CD);
	}
	
	$("#budgetPopup").data("kendoWindow").close();
}

function budgetPopupClose(){
	 $("#budgetPopup").data("kendoWindow").close();
}

function budgetGridReload() {
	$("#budgetGrid").data("kendoGrid").dataSource.read();
}
/* 예산 팝업 */

/* 목명 팝업 */

function mokGrid() {
	
	var grid = $("#mokGrid").kendoGrid({
        dataSource: new kendo.data.DataSource({
    	    transport: { 
    	        read:  {
    	            url: _g_contextPath_+'/budget/mokListAjax',
    	            dataType: "json",
    	            type: 'post'
    	        },
    	      	parameterMap: function(data, operation) {
 	      			data.fiscal_year 		= $("#fiscal_year").val();
    	      		data.project 		= $("#mokName").val();
    	     		return data;
    	     	}
    	    },
    	    dataBound : popDataBound,
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
        					title : "예산상위명",
        					field : "BUDGR_NM",
        					width : 17
        				},
        				{
        					title : "예산코드",
        					field : "BGT_CD",
        					width : 17
        				},
        				{
        					title : "예산명",
        					field : "BGT_NM",
        					width : 20
        				},
        				{
        					title : "목명",
        					field : "HBGT_NM",
        					width : 20
        				},
        				{
        					title : "선택",
        					width : 10,
					    	template : '<input type="button" id="" class="text_blue" onclick="budgetSelect(this);" value="선택">'
       		    	    }]
    }).data("kendoGrid");
}

//선택 클릭이벤트
function mokSelect(e){		
	var row = $("#mokGrid").data("kendoGrid").dataItem($(e).closest("tr"));
	
	if (selectedMokPop === "from") {
		$("#from_mok_name").val(row.BGT_NM);
		$("#from_mok_cd").val(row.BGT_CD);
	} else {
		$("#to_mok_name").val(row.BGT_NM);
		$("#to_mok_cd").val(row.BGT_CD);
	}
	
	$("#mokPopup").data("kendoWindow").close();
}

function mokPopupCancel(){
	 $("#mokPopup").data("kendoWindow").close();
}

function mokGridReload() {
	$("#mokGrid").data("kendoGrid").dataSource.read();
}

/* 목명 팝업 */
</script>
<div class="iframe_wrap">
	<div class="sub_title_wrap">
		<div class="title_div">
			<h4>원인행위부</h4>
		</div>
	</div>
	
	<div class="sub_contents_wrap">
	
		<div class="com_ta">
			<div class="top_box gray_box" id = "dataBox">
				<dl>
					<dt>회계년도</dt>
					<dd style="width:35%">
						<input type="text" style="width:40%" id = "fiscal_year" style = "" value=""/>
					</dd>
					<dt>프로젝트</dt>
					<dd style="width:33%">
						<input type="text" style="width:40%" id="from_project" name="project" value="" />
						<input type="hidden" id="from_project_cd" />
						<button type="button" id ="projectFromSearch" value="검색">
						<img style="position:inherit;" src="<c:url value='/Images/btn/search_icon2.png'/>"></button>
					</dd>
				</dl>
				
				<dl class="next2">
					<dt>회계단위</dt>
					<dd style="width:35%">
						<input type="text" style="width:40%" id ="accounting_unit"/>
					</dd>
					<dt>예 산 명</dt>
					<dd style="width:33%">
						<input type="text" style="width:40%" id="from_budget_name" name="budget_name" value="" >
						<input type="hidden" id="from_budget_cd" />
						<button type="button" id ="budgetFromSearch" value="검색">
						<img style="position:inherit;" src="<c:url value='/Images/btn/search_icon2.png'/>"></button>
						&nbsp;~&nbsp;
						<input type="text" style="width:40%" id="to_budget_name" name="budget_name" value="" >
						<input type="hidden" id="to_budget_cd" />
						<button type="button" id ="budgetToSearch" value="검색">
						<img style="position:inherit;" src="<c:url value='/Images/btn/search_icon2.png'/>"></button>
						
					</dd>
				</dl>
				<dl class="next2">
					
					<dt>기준기간</dt>
					<dd style="width:35%">
						<input type="text" style="width:40%" id="from_standard_period" value="" >
						&nbsp;~&nbsp;
						<input type="text" style="width:40%" id="to_standard_period" value="" >
					</dd>

					<dt>목 명</dt>
					<dd style="width:33%">
						<input type="text" style="width:40%" id="from_mok_name" name="mok" value="" >
						<input type="hidden" id="from_mok_cd" />
						<button type="button" id ="mokFromSearch" value="검색">
						<img style="position:inherit;" src="<c:url value='/Images/btn/search_icon2.png'/>"></button>
						&nbsp;~&nbsp;
						<input type="text" style="width:40%" id="to_mok_name" name="mok" value="" >
						<input type="hidden" id="to_mok_cd" />
						<button type="button" id ="mokToSearch" value="검색">
						<img style="position:inherit;" src="<c:url value='/Images/btn/search_icon2.png'/>"></button>
					</dd>
				</dl>
			</div>
		</div>
				
		<div class="btn_div mt10 cl">
			<div class="left_div">
				<p class="tit_p mt5 mb0">※ 클릭하면 하단에서 상세 집행 내용이 조회됩니다.</p>
			</div>
			<div class="right_div">
				<div class="controll_btn p0">
					<button type="button" id="" onclick = "searchMainGrid()">조회</button>
<!-- 					<button type="button" id="" onclick = "mainGridExcel()">엑셀</button> -->
				</div>
			</div>
		</div>
		
		<div class="com_ta2">
			<div  id = "grid">
			</div>
		</div>
		
		<div class="btn_div mt10 cl">
			<div class="left_div">
				<p class="tit_p mt5 mb0">상세 집행 내용</p>
			</div>
			<div class="right_div">
				<div class="controll_btn p0">
<!-- 					<button type="button" id="" onclick = "mainGrid2Excel()">엑셀</button> -->
				</div>
			</div>
		</div>
		
		<div class="com_ta2">
			<div  id = "grid2">
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
				<dd style="margin-right : 70px;">
					<input type="text" id="projectName" style="width: 120px" />
					<input type="hidden" id="projectCd" />
				</dd>
				<dd>
					<input type="button" onclick="projectGridReload();" id="searchButton"	value="검색" />
				</dd>
			</dl>
		</div>
		<div class="com_ta mt15" style="height: 500px;">
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

<!-- 예산 검색 팝업 -->
<div class="pop_wrap_dir" id="budgetPopup" style="width:600px;">
	<div class="pop_head">
		<h1>예산명 선택</h1>
	</div>
	<div class="pop_con">
		<div class="top_box">
			<dl>
				<dt class="ar" style="width: 80px;">예산명</dt>
				<dd style="margin-right : 70px;">
					<input type="text" id="budgetName" style="width: 120px" />
				</dd>
				<dd>
					<input type="button" onclick="budgetGridReload();" id="searchButton"	value="검색" />
				</dd>
			</dl>
		</div>
		<div class="com_ta mt15" style="height: 500px;">
			<div id="budgetGrid"></div>
		</div>			
	</div>

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" class="gray_btn" id="budgetPopupCancel" value="닫기" />
		</div>
	</div>
</div>	
<!-- 예산 검색 팝업 -->

<!--목명 검색 팝업 -->
<div class="pop_wrap_dir" id="mokPopup" style="width:650px;">
	<div class="pop_head">
		<h1>목명 선택</h1>
	</div>
	<div class="pop_con">
		<div class="top_box">
			<dl>
				<dt class="ar" style="width: 80px;">목명</dt>
				<dd style="margin-right : 70px;">
					<input type="text" id="mokName" style="width: 120px" />
				</dd>
				<dd>
					<input type="button" onclick="mokGridReload();" id="searchButton"	value="검색" />
				</dd>
			</dl>
		</div>
		<div class="com_ta mt15" style="height: 500px;">
			<div id="mokGrid"></div>
		</div>			
	</div>

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" class="gray_btn" id="mokPopupCancel" value="닫기" />
		</div>
	</div>
</div>	
<!-- 목명 검색 팝업 -->

</body>

