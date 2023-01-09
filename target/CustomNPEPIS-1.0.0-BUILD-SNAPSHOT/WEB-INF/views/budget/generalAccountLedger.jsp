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
dd {
	width: 11.5%;
} 
dd input { 
  	width : 80%;
}
.k-grid-toolbar {
	float : right;
}
#resolutionGrid { height: 100%; }

</style>
<body>

<script type="text/javascript">

var $accounting_unit_list;
var $accountTitleList;
var $customerList;
var $customerList_temp;
var $mokList;
var $mokTempList;
var $rowData = {};					//그리드한줄정보
var $gridIndex = 0;					//그리드인덱스번호
var $lease_id = "";							//임대계약id
var $gridFlag = false;
var $voucherRowData = ""; 					//전표데이터
var $mainGridURL = _g_contextPath_ + "/budget/generalAccountLedgerList";
// 전표 전역 변수
var C_DIKEYCODE;
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
			
			data.accounting_unit = $("#accounting_unit").data("kendoDropDownList").value();
			data.accounting_title = $("#acct_code").val();
			data.from_period = $("#from_period").val().replace(/-/gi,"");
			data.to_period = $("#to_period").val().replace(/-/gi,"");
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

	$(function(){
		
		makeComboList();
		
		$("#accounting_unit").kendoDropDownList({
			dataTextField : 'DIV_NM' ,
			dataValueField : 'DIV_CD' ,
			dataSource : $accounting_unit_list
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
		acctListPop(); // 계정과목 팝업
		
	});
	
	function searchMainGrid() {
		$dataSource.transport.options.read.url = $mainGridURL;
		mainGrid();
	}
	
	function makeComboList(){
		$.ajax({
			url : _g_contextPath_+ "/budget/ledgerComboList2",
			data : {

				},
			async : false,
			type : "POST",
			success : function(result){				
				$accounting_unit_list = result.accountingUnitList;
				$accountTitleList = result.accountTitleList;
			}
		});
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
				fileName : '거래처원장.xlsx'
			},
			dataSource: $dataSource,
			height : 700,
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
					width : width*7/100,
					field : "BASE_DT",
					title : "날짜"
				},
				{
					width : width*6/100,
					title : "차변",
					field : "AMT1",
					template : function(e){
						if(e.AMT1 == null || e.AMT1 == ""|| e.AMT1 == "0"){
							return '';
						}else{
							return e.AMT1.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
						}
					}
				},
				{
					width : width*6/100,
					title : "대변",
					field : "AMT2",
					template : function(e){
						if(e.AMT2 == null || e.AMT2 == ""|| e.AMT2 == "0"){
							return '';
						}else{
							return e.AMT2.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
						}
						
					}
				},
				{
					width : width*6/100,
					title : "잔액",
					field : "AMT3",
					template : function(e){
						if(e.AMT3 == null || e.AMT3 == ""|| e.AMT3 == "0"){
							return '';
						}else{
							return e.AMT3.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
						}
						
					}
				}],
			change : selectRow
	
		}).data("kendoGrid");
		
		function selectRow(e){		//row클릭시 data 전역변수 처리
	
			row = e.sender.select();
			grid = $('#grid').data("kendoGrid");
			data = grid.dataItem(row);
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
	
	// 계정과목 팝업
	function acctListPop() {
		
		var 	myWindow = $("#acctListPop"),
		undo = $("#acctPopBtn");

		undo.click(function(){
			myWindow.data("kendoWindow").open();
			undo.fadeOut();
			acctGrid();
		});
		
		$("#acctListPopClose").click(function(){
			myWindow.data("kendoWindow").close();
		});
		
		myWindow.kendoWindow({
			width: "800px",
			height: "665px",
			visible: false,
			modal: true,
			actions: [
				"Close"
			],
			close: function(){
				undo.fadeIn();
				$("#pop_acct_name").val("");
			}
		}).data("kendoWindow").center();
		
		function acctGridReload(){
			$("#acctGrid").data("kendoGrid").dataSource.page(1);
			$("#acctGrid").data("kendoGrid").dataSource.read();
		}
		
		$("#acctSearchBtn").click(function(){
			acctGridReload();
		});
		
		$("#accounting_title").keyup(function(event){
			if(event.keyCode===13){//enterkey
				myWindow.data("kendoWindow").open();
				undo.fadeOut();
				$("#pop_acct_name").val($("#accounting_title").val());
				acctGrid();
			}
		});
		
		
		$("#pop_acct_name").keyup(function(event){
			if(event.keyCode===13){//enterkey
				acctGridReload();
			}
		});
		
		var acctGrid = function(){
			var grid = $("#acctGrid").kendoGrid({
				dataSource : new kendo.data.DataSource({		//그리드데이터소스
					pageSize : 20,
					transport : {
						read : {
							url : _g_contextPath_+ "/budget/getAccountTitleList",
							dataType : "json",
							type : "post"
						},
						parameterMap: function(data, operation) {
							
							data.NAME = $("#pop_acct_name").val();
					     	return data;
					     }
					},
					schema : {
						data : function(response) {
							console.log(response.list);
							return response.list;
						},
						total : function(response) {
							console.log(response.total);
							return response.total;
						},
					    model : {
					    	fields : {

					    	}
					    }
					}
				}),
				pageable: {
					refresh: true,
					pageSizes: true,
					buttonCount: 5
				},
				height: 460,
				dataBound: dataBound,
				sortable: true,
				persistSelection: true,
				selectable: "row",
				columns: [
		
					{
						width : "30%",
						field: "ACCT_CD",
						title: "계정과목 코드"
					},
					{
						width : "70%",
						field: "ACCT_NM",
						title: "계정과목 명"
					}
				],
				change: selectRow
			}).data("kendoGrid");
			
			function selectRow(e){	
				
				var row = $('#acctGrid').data("kendoGrid").dataItem(e.sender.select());
				
				$("#accounting_title").val(row.ACCT_NM);
				$("#acct_code").val(row.ACCT_CD);
				
				myWindow.data("kendoWindow").close();
			}
		}
	}
	
	
	
	function fn_formatDate(str){
		return str.substring(0,4) + "-" + str.substring(4,6) + "-" + str.substring(6,8) ;
	}

	function fn_formatMoney(str){
	        str = String(str);
	        return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
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
					<dt style="width:5%">회계단위</dt>
					<dd style="width:15%">
						<input type="text" style="width:100%" id ="accounting_unit"/>
					</dd>
					<dt style="width:5%">계정과목</dt>
					<dd style="width:15%">
						<input type="text" style="width:60%" id ="accounting_title" disabled/>
						<button type="button" id ="acctPopBtn" value="검색">
						<img style="position:inherit;" src="<c:url value='/Images/btn/search_icon2.png'/>"></button>
						<input type="hidden" id = "acct_code"/>
					</dd>
					<dt style="width:5%">기표기간</dt>
					<dd style="width:33%">
						<input type="text" style="width:40%" id="from_period" name="period" value="" >
												&nbsp;~&nbsp;
						<input type="text" style="width:40%" id="to_period" name="period" value="" >
					</dd>
				</dl>
			</div>
		</div>
				
		<div class="btn_div mt10 cl">
			<div class="right_div">
				<div class="controll_btn p0">
					<button type="button" id="" onclick = "searchMainGrid()">조회</button>
				</div>
			</div>
		</div>
		
		<div class="com_ta2">
			<div  id = "grid">
			</div>
		</div>
		
	</div>
</div>

<!-- 계정과목 검색 팝업 -->
<div class="pop_wrap_dir" id="acctListPop" style="width:800px;">
	<div class="pop_head">
		<h1>거래처리스트</h1>
	</div>
	<div class="pop_con">
		<div class="top_box">
			<dl>
				<dt class="ar" style="width:90px;">계정과목명</dt>
				<dd style="width:300px;">
					<input type="text" id="pop_acct_name" class="grid_reload" style="width:120px;">
					<input type="button" id="acctSearchBtn" value="검색" style="width:30px;">
				</dd>
			</dl>
		</div>
		<div class="com_ta mt15">
			<div id="acctGrid" style="text-align:center;"></div>
		</div>
	</div>
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" class="gray_btn" id="acctListPopClose" value="닫기">
		</div>
	</div>
</div>
<!-- 계정과목 검색 팝업 끝 -->

</body>

