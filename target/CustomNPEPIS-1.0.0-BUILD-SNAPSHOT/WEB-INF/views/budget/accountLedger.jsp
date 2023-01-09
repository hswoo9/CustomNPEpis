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
var $GISU_DT = "";
var $GISU_SQ = "";

// 전표 전역 변수
var C_DIKEYCODE;


var $dataSource = new kendo.data.DataSource({		//그리드데이터소스
	serverPaging : true,
	pageSize : 1000,
	transport : {
		read : {
			url : _g_contextPath_+ "/budget/accountLedgerList",
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
			console.log(response.list);
			return response.list;
		},
	    model : {
	    	fields : {

	    	}
	    }
	}
});

$popDataSource = new kendo.data.DataSource({
	serverPaging: true,
	pageSize: 20,
	schema: {
		data: function(){
			
			var index = 0;
			var min = ($popDataSource.page()-1)*$popDataSource.pageSize();
			var max = $popDataSource.page()*$popDataSource.pageSize();
			var list = $customer_temp.filter(function(i){
				index++;
				return min <= index && index < max;
			})
			
			return list;
			
		},
		total: function(){
			
			var list = $customerList.filter(function(i){
				return i.TR_NM.indexOf($("#pop_client_name").val()) != -1
			})
			
			$customer_temp = list;
			
			var index = 0;
			$.each($customer_temp, function(i,v){
				index++;
			})
			
			return index;
		}
	}
}),

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
		empListPop(); // 거래처 팝업
		acctListPop(); // 계정과목 팝업
		
	});
	
	function makeComboList(){
		$.ajax({
			url : _g_contextPath_+ "/budget/ledgerComboList2",
			data : {},
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
	//			pageable : {
	//				refresh : true,
	//				pageSizes : true,
	//				buttonCount : 5
	//			},
			persistSelection : true,
			columns : [
				{
					width : width*15/100,
					field : "DIV_NM",
					title : "회계단위"
				},
				{
					width : width*22/100,
					field : "TR_NM",
					title : "거래처"
				},
				
				{
					width : width*7/100,
					field : "BASE_DT",
					title : "기표일자"
				},
				{
					width : width*30/100,
					field : "RMK_DC",
					title : "적요"
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
				},
				{
					width : width*6/100,
					title : "전표보기",
					template : function(e) {
						
						if (e.DIV == "1") {
							return '<input type="button" class="blue_btn" value="전표보기" onclick = "watchVoucher(this)">';
						} else {
							return '';
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
	
	//거래처 팝업
	function empListPop(){
	
	var 	myWindow = $("#clientListPop"),
			undo = $("#customerPopBtn");
	
	undo.click(function(){
		myWindow.data("kendoWindow").open();
		undo.fadeOut();
		empGrid();
	});
	
	$("#clientListPopClose").click(function(){
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
			$("#pop_client_name").val("");
		}
	}).data("kendoWindow").center();
	
	function empGridReload(){
		$popDataSource.page(1);
		$("#gridClientList"/* popUpGrid */).data("kendoGrid").dataSource.read();
	}
	$("#popClientSearchBtn").click(function(){
		empGridReload();
	});
	$("#customer_name").keyup(function(event){
		if(event.keyCode===13){//enterkey
			myWindow.data("kendoWindow").open();
			undo.fadeOut();
			$("#pop_client_name").val($("#customer_name").val());
			empGrid();
			$("#customer_code").val("");
		}
	});
	
	
	$("#pop_client_name").keyup(function(event){
		if(event.keyCode===13){//enterkey
			empGridReload();
			$("#customer_code").val("");
		}
	});
	
	
	var empGrid = function(){
		var grid = $("#gridClientList"/* popUpGrid */).kendoGrid({
			dataSource : $popDataSource,
			height: 460,
			dataBound: dataBound,
			sortable: true,
			pageable: {
				refresh: true,
				pageSizes: true,
				buttonCount: 5
			},
			persistSelection: true,
			selectable: "row",
			columns: [
				{
					width : "15%",
					field: "TR_CD",
					title: "거래처코드"
				},
				{
					width : "15%",
					field: "TR_NM",
					title: "거래처명"
				},
				{
					width : "15%",
					field: "DIV",
					title: "구분"
				},
				{
					width : "15%",
					field: "REG_NB",
					title: "사업자 번호"
				},
				{
					width : "40%",
					field: "BA_NB",
					title: "계좌번호"
				}
			],
			change: selectRow
		}).data("kendoGrid");
		
			function selectRow(e){	
				
				row = e.sender.select();
				$(row).dblclick(function(){
					grid = $('#gridClientList').data("kendoGrid");
					data = grid.dataItem(row);
					$("#customer_name").val(data.TR_NM);
					$("#customer_code").val(data.TR_CD);
					myWindow.data("kendoWindow").close();
					$rowData = {};
				});
			}
		}
	}	
	//거래처팝업 끝
	
	function watchVoucher(e) {
		
		$("#voucherPopup").css("display", "block");
		
		var row = $("#grid").data("kendoGrid").dataItem($(e).closest("tr"));
		var myWindow = $("#voucherPopup");
		
		$voucherRowData = row;
		
		$("#voucherPopupClose").click(function(){
			myWindow.data("kendoWindow").close();
		});
		
		myWindow.kendoWindow({
			width: "1500px",
			height: "600px",
			visible: false,
			actions: [
				"Close"
			],
			close: function(){
			}
		}).data("kendoWindow").center();
		
		renderVoucherContent(row); // 입력일자 ~ 내용 가져오기
		renderVoucherGrid(row);	   // 전표디테일 가져오기
		
		myWindow.data("kendoWindow").open();
	}
	
	// 전표 입력일자 ~ 내용
	function renderVoucherContent(row) {
		
		console.log(row);
		
		$.ajax({
			url : _g_contextPath_ + "/budget/getVoucher",
			data : { "data" : JSON.stringify(row)},
			dataType : "json",
			type : "POST",
			success : function(result) {
				
				var data = result.list;
				console.log(data);
				
				$("#FILL_DT").val(data.FILL_DT);
				$("#FILL_NB").val(data.FILL_NB);
				$("#TY_NM").val(data.TY_NM);
				$("#ST_NM").val(data.ST_NM);
				$("#ISU_DT").val(data.ISU_DT);
				$("#ISU_SQ").val(data.ISU_SQ);
				$("#ISU_DOC").val(data.ISU_DOC);
				$("#DOC_NUMBER").val(data.DOC_NUMBER);
				$GISU_DT = data.GISU_DT;
				$GISU_SQ = data.GISU_SQ;
				
				C_DIKEYCODE = data.C_DIKEYCODE;
			}
		});
	}
	
	// 전표(팝업) 그리드
	function renderVoucherGrid(row) {
		
		var voucherGrid =  $("#voucherGrid").kendoGrid({
			dataSource: new kendo.data.DataSource({		//그리드데이터소스
				serverPaging : true,
				pageSize : 1000,
				transport : {
					read : {
						url : _g_contextPath_+ "/budget/getVoucherDetail",
						dataType : "json",
						type : "post"
					},
					parameterMap: function(data, operation) {
						
						data.ISU_DT = row.ISU_DT, // 발생 일자
						data.ISU_SQ = row.ISU_SQ // 발생 순번
						
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
			}),
			height : 400,
			dataBound : dataBound,
			selectable : "row",
			sortable : true,
			persistSelection : true,
			columns : [
				{
					width : 10,
					field : "ACCT_CD",
					title : "계정코드"
				},
				{
					width : 10,
					field : "ACCT_NM",
					title : "계정명"
				},
				{
					width : 10,
					field : "TR_CD",
					title : "거래처코드"
				},
				{
					width : 10,
					field : "TR_NM",
					title : "거래처명"
				},
				{
					width : 10,
					field : "RNB",
					title : "사업자번호"
				},
				{
					template : function(dataItem) {
						if(dataItem.AMT1 == null || dataItem.AMT1 == ""|| dataItem.AMT1 == "0"){
							return '';
						}else{
							return fn_formatMoney(dataItem.AMT1);
						}
					},					
					width : 10,
					title : "차변"
				},
				{
					template : function(dataItem) {
						if (dataItem.AMT2 == null || dataItem.AMT2 == ""|| dataItem.AMT2 == "0") {
							return '';
						} else {
							return fn_formatMoney(dataItem.AMT2);
						}
					},
					width : 10,
					title : "대변"
				},
				{
					width : 10,
					field : "TAXDIV1",
					title : "세무구분"
				},
				{
					width : 10,
					field : "FROM_DT",
					title : "신고기준일"
				},
				{
					width : 10,
					field : "TAXDIV2",
					title : "사유구분"
				},
				{
					template : function(dataItem) {
						if (dataItem.VATAM1 == null || dataItem.VATAM1 == ""|| dataItem.VATAM1 == "0") {
							return '';
						} else {
							return fn_formatMoney(dataItem.VATAM1);
						}
					},
					width : 10,
					title : "부가세공급가"
				},
				{
					template : function(dataItem) {
						if (dataItem.VATAM2 == null || dataItem.VATAM2 == ""|| dataItem.VATAM2 == "0") {
							return '';
						} else {
							return fn_formatMoney(dataItem.VATAM2);
						}
					},
					width : 10,
					title : "부가세 세액"
				},
				{
					width : 10,
					field : "PJT_NM",
					title : "프로젝트"
				},
				{
					width : 10,
					field : "BCD_NM",
					title : "예산과목"
				}
			],
			change : selectRow
	
		}).data("kendoGrid");
		
		function selectRow(e){		//row클릭시 data 전역변수 처리
	
			row = e.sender.select();
			grid = $('#grid').data("kendoGrid");
			data = grid.dataItem(row);
			
			console.log(data);
		}
	}
	
	function voucherViewDoc() {
		
		if (C_DIKEYCODE !== null) {
			fn_docViewPop(C_DIKEYCODE);			
		} else {
			alert("문서가 없습니다.");
		}
	}
	
	function resolutionViewOpen() {
		
		var url = _g_contextPath_ + "/budget/resolutionPopup";
		
		if ($GISU_DT == null || $GISU_SQ == null) {
			alert("지출결의가 없습니다.");
			return;
		}
		
		window.name = "parentForm";
		var openWin = window.open(url,"childForm","width=1400, height=580, resizable=yes , scrollbars=yes, status=no, top=200, left=350","newWindow");
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
					<button type="button" id="" onclick = "gridReload()">조회</button>
<!-- 					<button type="button" id="" onclick = "mainGridExcel()">엑셀</button> -->
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

<!-- 거래처 검색 팝업  -->
<div class="pop_wrap_dir" id="clientListPop" style="width:800px;">
	<div class="pop_head">
		<h1>거래처리스트</h1>
	</div>
	<div class="pop_con">
		<div class="top_box">
			<dl>
				<dt class="ar" style="width:70px;">거 래 처 명</dt>
				<dd style="width:300px;">
					<input type="text" id="pop_client_name" class="grid_reload" style="width:120px;">
					<input type="button" id="popClientSearchBtn" value="검색" style="width:30px;">
				</dd>
			</dl>
		</div>
		<div class="com_ta mt15">
			<div id="gridClientList" style="text-align:center;"></div>
		</div>
	</div>
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" class="gray_btn" id="clientListPopClose" value="닫기">
		</div>
	</div>
</div>
<!-- 거래처 검색 팝업 끝  -->

<!-- 전표 조회 팝업 화면 -->
<div class="pop_wrap_dir" id="voucherPopup" style="width:100%; display:none;">
	<div class="com_ta">
		<div class="top_box gray_box" id = "dataBox">
			<dl>
				<dt style="width:4%; margin-left:8%;">입력일자</dt>
				<dd style="width:10%">
					<input type="text"  style="width: 100%" id ="FILL_DT" disabled />
				</dd>
				<dt style="width:4%">입력번호</dt>
				<dd style="width:4%">
					<input type="text"  style="width: 100%" id ="FILL_NB" disabled />
				</dd>
				<dt style="width:4%">전표유형</dt>
				<dd style="width:6%">
					<input type="text"  style="width: 100%" id ="TY_NM" disabled />
				</dd>
				<dt style="width:4%">전표상태</dt>
				<dd style="width:6%">
					<input type="text"  style="width: 100%" id ="ST_NM" disabled />
				</dd>
				<dt style="width:4%">기표일자</dt>
				<dd style="width:10%">
					<input type="text" style="width: 100%" id ="ISU_DT" disabled />
				</dd>
				<dt style="width:4%">기표번호</dt>
				<dd style="width:4%">
					<input type="text" style="width: 100%"  id ="ISU_SQ" disabled />
				</dd>
			</dl>
			<dl class="next2" style="margin-left:7%;">
				<dt style="width:4%;">내용</dt>
				<dd style="width:35.1%">
					<input type="text" style="width:100%" id="ISU_DOC" value="" disabled>
				</dd>
				<dt style="width:7%;">결의서 문서번호</dt>
				<dd style="width:12%">
					<input type="text" style="width:100%" id="DOC_NUMBER" value="" disabled>
				</dd>
				<dd>
					<input type="button" style="width:55%; margin-left:24%;" value="지출결의 보기" onclick="resolutionViewOpen();"/>
				</dd>
				<dd>
					<input type="button" style="width:55%;" value="문서 보기" onclick="voucherViewDoc();"/>
				</dd>
			</dl>
		</div>
	</div>
	<div class="pop_con">
		<div class="com_ta mt15">
			<div  id = "voucherGrid">
			</div>
		</div>
	</div>
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" class="gray_btn" id="voucherPopupClose" value="닫기">
		</div>
	</div>
</div>
<!-- 전표 조회 펍업 화면 끝 -->

</body>

