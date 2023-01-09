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
<fmt:formatDate value="${nowDate}" var="nowDate" pattern="yyyy-MM" />
<fmt:formatDate value="${year}" var="year" pattern="yyyy" />
<fmt:formatDate value="${mm}" var="mm" pattern="MM" />
<fmt:formatDate value="${dd}" var="dd" pattern="dd" />
<fmt:formatDate value="${weekDay}" var="weekDay" pattern="E" type="date" />
<script type="text/javascript" src="<c:url value='/js/jquery.form.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/jszip.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/shieldui-all.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/kukgoh/testdata.js' />"></script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
</head>

<style type="text/css">
.k-header .k-link {
	text-align: center;
}

.k-grid th.k-header, .k-grid-header {
	background: #F0F6FD;
}

.k-grid-content>table>tbody>tr {
	text-align: center;
}
</style>

<script type="text/javascript">

$(function() {
	mainGrid();		// 메인 그리드
	subGrid(); 		// 예산과목 선택
	subBudGrid(); 	// 예산그룹 선택
});

$(document).ready(function() {
	
	$("#subName").on("keyup", function(e) {
		if (e.keyCode == '13') {
			asstnGridReload();
		}
	});
	
    $("#FSYR").kendoDatePicker({
        start: "decade",
        depth: "decade",
        format: "yyyy",
		parseFormats : ["yyyy"],
        culture : "ko-KR",
        dateInput: true
    });
    
    $("#FSYR").val('${year}');
    
	var popUp = $('#popUp');
	
	popUp.kendoWindow({
		width : "1100px",
		height : "700px",
		visible : false,
		modal: true,
		actions : [ "Close" ],
		close : onClose2
	}).data("kendoWindow").center();
	
	function onClose2(){
		popUp.fadeIn();
	}

	var popUp1 = $("#popUp1");

	popUp1.kendoWindow({
		width : "600px",
		height : "700px",
		visible : false,
		modal: true,
		actions : [ "Close" ],
		close : onClose3
	}).data("kendoWindow").center();

	function onClose3() {
		popUp.fadeIn();
	}

	$("#popUp1").on("keypress", function(e) {
			
		if (e.keyCode == 13) {
			budGridReload();
		}
	})

});
//---------------------------------------End ready

function mainGrid(){
	// 메인 그리드
	var mainConfigGrid = $("#mainConfigGrid").kendoGrid({
		toolbar : [	{	name : "excel", 	text : "Excel" }],
		excel : { fileName : 'E나라도움 비목세목 코드.xlsx' },
		dataSource : mainConfigGridDataSource,
		dataBound : gridDataBound,
		height : 450,
		sortable : true,
		persistSelection : true,
		selectable : "multiple",
        columns: [
			{	
				template : function(e) {
					return "<span id='BGT_CD'>" + e.BGT_CD + "</span>";
				},
				field : "BGT_CD", 
				title : "예산코드",
				width : 100
			},
			{
				template : function(e) {
					return "<span id='BGT_NM'>" + e.BGT_NM + "</span>";
				},
				field : "BGT_NM",
				title : "예산명",
				width : 100
			},
			{
				template : function(e) {
					return "<span id='HBGT_NM'>" + e.HBGT_NM + "</span>";
				},
				field : "HBGT_NM",
				title : "상위예산명",
				width : 90
			},
			{
				template : function(dataItem) { 
					return "<input type='button' id='ASSTN_EXPITM_TAXITM_CODE' style='width: 45%;' value='" + dataItem.ASSTN_EXPITM_TAXITM_CODE + "' onclick='btnAsstnChoice(this)' class='btnChoice' width='100' />";
				},
				field : "ASSTN_EXPITM_TAXITM_CODE",
				title : "보조비목세목코드",
				width : 150
			},
			{
				template : function(dataItem) {
					return "<input type='button' class='btnChoice' value='설정취소' onclick='cnclSetting(this);'>";
				},
				title : "설정취소",
				width : 90
			},
			{
				template : function(dataItem) {
					return "<span id='ASSTN_EXPITM_NM'>" + dataItem.ASSTN_EXPITM_NM + "</span>";
				},
				field : "ASSTN_EXPITM_NM",
				title : "보조비목명",
				width : 90
			},
			{
				template : function(dataItem) {
					return "<span id='ASSTN_TAXITM_NM'>" + dataItem.ASSTN_TAXITM_NM + "</span>";
				},
				field : "ASSTN_TAXITM_NM",
				title : "보조세목명",
				width : 90
			},
// 			{
// 				template : function(dataItem){
// 					var text = dataItem.ASSTN_TAXITM_CODE_DC;
// 					return '<p id="ASSTN_TAXITM_CODE_DC" style ="margin : 5pt;">'+text+'</p>' ;
// 				},
// 				title : "보조세목코드설명",
// 				field : "ASSTN_TAXITM_CODE_DC",
// 				attributes:{style:"text-align:left; "},
// 				width : 250

// 			},
			{
				template : function(dataItem) {
					return "<span id='FSYR2'>" + dataItem.FSYR + "</span>";
				},
				field : "FSYR",
				title : "회계연도",
				width : 90
			}],
    }).data("kendoGrid");
	
	mainConfigGrid.table.on("click", ".k-state-selected", selectRow);
	
	function selectRow() {
		
		var rowData = $("#mainConfigGrid").data("kendoGrid").dataItem($(this).closest("tr"));
		
		console.log(rowData);
		
	}
}


var mainConfigGridDataSource = new kendo.data.DataSource({
	transport : {
		read : {
			url : _g_contextPath_+"/kukgoh/getBudgetMainGrid",
			dataType : "json",
			type : 'post'
		},
		parameterMap : function(data, operation) {
			data.BUDGCD = $('#budGcd').val();
			return data;
		}
	},
	schema : {
		data : function(response) {
			console.log("========= 메인그리드 response ==========");
			console.log(response);
			console.log("========= 메인그리드 response ==========");

			return response.list;
		},
		total : function(response) {
			return response.total;
		},
		model : {
			fields : {
				emp_name : {
					type : "string"
				},
				code_kr : {
					type : "string"
				}
			}
		}
	}
});

function gridDataBound(e) {
	var grid = e.sender;

	if (grid.dataSource.total() == 0) {
		var colCount = grid.columns.length;
		$(e.sender.wrapper).find('tbody').append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
	}
}

function budGridDataBound(e) {
	var grid = e.sender;
	
	if (grid.dataSource.total() == 0) {
		var colCount = grid.columns.length;
		$(e.sender.wrapper).find('tbody').append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
	}
}

var selDataItem;
var savedRow;
var saveIndex = new Array();

function btnAsstnChoice(thisObj){
	 savedRow = $(thisObj).closest("tr");
	 selDataItem = $("#mainConfigGrid").data("kendoGrid").dataItem($(thisObj).closest("tr"));
	 $('#popUp').data("kendoWindow").open();
	 asstnGridReload();
}

function btnBudChoice(e) {
	$("#popUp1").data("kendoWindow").open();
	budGridReload();
}

function popCancel(){
 	$('#filePop').data("kendoWindow").close();
 }
 
function save(e){

	var rows = $("#mainConfigGrid").data("kendoGrid")._data
	
 $.ajax({
		url: _g_contextPath_ + "/kukgoh/saveAssntInfo",
		dataType : 'json',
		data : { "data" : JSON.stringify(rows) }, 
		type : 'POST',
		success: function(result){
			if(result.result == true){
				alert("저장하였습니다.");
			}else{
				alert("저장에 실패하였습니다.");
			}	
			
			searchBtn();
		},
		error : function(result){
			
		}
	});	
}

function btnFilePop(e){
	 $('#fileDiv').empty();

	 var dataItem = $("#mainConfigGrid").data("kendoGrid").dataItem($(e).closest("tr"));
 	 $.ajax({
			url: _g_contextPath_+"/kukgoh/getFileList",
 			dataType : 'json',
 			data : {
 				INTRFC_ID : dataItem.INTRFC_ID,
 				TRNSC_ID : dataItem.TRNSC_ID,
 				FILE_ID : dataItem.FILE_ID
 			},
 			type : 'POST',
 			success: function(result){
				if (result.list.length > 0) {
 					for (var i = 0 ; i < result.list.length ; i++) {
 						if(i==0) {	
 							$('#fileDiv').append(
 									'<tr id="test">'+
 									'<th>첨부파일 목록</th>'+
 									'<td class="le">'+
 									'<span style=" display: block;" class="mr20">'+
 									'<img src="<c:url value="/Images/ico/ico_clip02.png"/>" alt="" />&nbsp;'+								
 									'<a href="#n" style="line-height: 23px; cursor: pointer; color: #0033FF" id="fileText" onclick="kukgohFileDown(this);" class="file_name">'+result.list[i].real_file_name+'.'+result.list[i].file_extension+'</a>&nbsp;'+
 									'<input type="hidden" id="kukgohFileKey" value="'+result.list[i].attach_file_id+'" />'+
 									'<input type="hidden" id="kukgohFileSeq" value="'+result.list[i].file_seq+'" />'+
 									'</span>'+
 									'</td>'+
 									'</tr>'
 							);		
 						} else {
 							$('#fileDiv').append(
 									'<tr id="test">'+
 									'<th></th>'+
 									'<td class="le">'+
 									'<span style=" display: block;" class="mr20">'+
 									'<img src="<c:url value="/Images/ico/ico_clip02.png"/>" alt="" />&nbsp;'+								
 									'<a href="#n" style="line-height: 23px; cursor: pointer; color: #0033FF" id="fileText" onclick="kukgohFileDown(this);" class="file_name">'+result.list[i].real_file_name+'.'+result.list[i].file_extension+'</a>&nbsp;'+
 									'<input type="hidden" id="kukgohFileKey" value="'+result.list[i].attach_file_id+'" />'+
 									'<input type="hidden" id="kukgohFileSeq" value="'+result.list[i].file_seq+'" />'+
 									'</span>'+
 									'</td>'+
 									'</tr>'
 							);
 						}
 					}
 				}
 			}
 	 });
 	 $('#filePop').data("kendoWindow").open();

}

function kukgohFileDown(e){
	var row = $(e).closest("tr");
	var attach_file_id = row.find('#kukgohFileKey').val();
	var data = {
			fileNm : row.find('#fileText').text(),
			attach_file_id : row.find('#kukgohFileKey').val(),
			file_seq : row.find('#kukgohFileSeq').val()
	}
	$.ajax({
		url : _g_contextPath_+'/common/fileDown',
		type : 'GET',
		data : data,
	}).success(function(data) {
		
		var downWin = window.open('','_self');
		downWin.location.href = _g_contextPath_+'/common/fileDown?attach_file_id='+attach_file_id;
	});
	
}		

function subBudGrid() {

	var budGrid = $("#budGrid").kendoGrid({

		dataSource : function() {
			return new kendo.data.DataSource({
				transport : {
					read : {
						url : _g_contextPath_ + "/kukgoh/getBudgetCdGridPop",
						dataType : "json",
						type : "post"
					},
					parameterMap : function(data, operation) {
						data.BUDGNM = $('#budGnm').val();
						return data;
					}
				},
				schema : {
					data : function(response) {
						console.log("========= 예산그룹 response ==========");
						console.log(response);
						console.log("========= 예산그룹 response ==========");
						return response.list;
					},
					total : function(response) {
						return response.total;
					}
				}
			});
		}(),
		dataBound : budGridDataBound,
		height : 550,
		sortable : true,
		persistSelection : true,
		selectable : "multiple",
		columns : [
			{
				field : "BUDGCD",
				title : "예산그룹코드",
				width : 150
			},
			{
				field : "BUDGNM",
				title : "예산그룹명",
				width : 150
			}
		],
		change : function(e) {
			
		}
	}).data("kendoGrid");

	budGrid.table.on("dblclick", "[role=gridcell]", selectRow);
	
	function selectRow(e) {
		
		var budGcdIndex = $("[data-field=BUDGCD]").data("index");
		var budGnmIndex = $("[data-field=BUDGNM]").data("index");
		
		var budGnm = $(this).closest("tr").children("td").eq(budGnmIndex).text();
		var budGcd = $(this).closest("tr").children("td").eq(budGcdIndex).text();
		
		$("#budGnmInput").val(budGnm);
		$("#budGcd").val(budGcd);
		$('#popUp1').data("kendoWindow").close();
		
		searchBtn();
	}
}

function subGrid(){

	var asstnGrid = $("#asstnGrid").kendoGrid({
		dataSource : new kendo.data.DataSource({
			transport : {
				read : {
					url : _g_contextPath_+"/kukgoh/getAsstnGridPop",
					dataType : "json",
					type : 'post'
				},
				parameterMap : function(data, operation) {
					data.FSYR = $('#FSYR').val();
					data.NAME = $('#subName').val();
					return data;
				}
			},
			schema : {
				data : function(response) {
					console.log("========= 예산과목 response ==========");
					console.log(response);
					console.log("========= 예산과목 response ==========");
					return response.list;
				},
				total : function(response) {
					return response.total;
				},
				model : {
					fields : {
						emp_name : {
							type : "string"
						},
						code_kr : {
							type : "string"
						}
					}
				}
			}
		}),
		dataBound :  function(e) {
			var grid = e.sender;
				if (grid.dataSource.total() == 0) {
				var colCount = grid.columns.length;
				$(e.sender.wrapper).find('tbody').append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
			}
		},
		height : 550,
		sortable : true,
		persistSelection : true,
		selectable : "multiple",
        columns: [
			{
				field : "ASSTN_EXPITM_TAXITM_CODE",
				title : "보조비목세목코드",
				width : 150
			},
			{
				field : "ASSTN_EXPITM_NM",
				title : "보조비목명",
				width : 130
			},
			{
				field : "ASSTN_TAXITM_NM",
				title : "보조세목명",
				width : 100
			},
			{
				field : "ASSTN_TAXITM_CODE_DC",
				title : "보조비목세목설명",
				width : 650
			}]
    }).data("kendoGrid");
	
	$("#asstnGrid").on("dblclick", "tr.k-state-selected", function (e) {
		
		var asstnSelDataItem = $("#asstnGrid").data("kendoGrid").dataItem($(this).closest("tr"));
		
		selDataItem.set('ASSTN_EXPITM_TAXITM_CODE', asstnSelDataItem.ASSTN_EXPITM_TAXITM_CODE);
		selDataItem.set('ASSTN_EXPITM_NM', asstnSelDataItem.ASSTN_EXPITM_NM);
		selDataItem.set('ASSTN_TAXITM_NM', asstnSelDataItem.ASSTN_TAXITM_NM);
		selDataItem.set('ASSTN_TAXITM_CODE_DC', asstnSelDataItem.ASSTN_TAXITM_CODE_DC);
		selDataItem.set('FSYR', asstnSelDataItem.FSYR);
		
		$.ajax({
			url: _g_contextPath_ + "/kukgoh/saveAssntInfo",
			dataType : 'json',
			data : { "data" : JSON.stringify(selDataItem) }, 
			type : 'POST',
			success: function(result){
				if (result.result == true) {
					alert("저장하였습니다.");
				} else {
					alert("저장에 실패하였습니다.");
				}	
				
			},
			error : function(result){
				
			}
		});	
		
		$('#popUp').data("kendoWindow").close();
		asstnGridReload();
	});	
}

function setDataGrid() {
	
}

function asstnGridReload(){
	$("#asstnGrid").data("kendoGrid").dataSource.read();
}

function budGridReload(){
	$("#budGrid").data("kendoGrid").dataSource.read();
}

function searchBtn(){
	$("#mainConfigGrid").data("kendoGrid").dataSource.read();
}

function cnclSetting(inputObj) {
	var row = $(inputObj).closest("tr");
	var selDataItem = $("#mainConfigGrid").data("kendoGrid").dataItem(row);
	
	if (selDataItem.ASSTN_EXPITM_TAXITM_CODE == "") {
		alert("취소할 항목이 없습니다.");
		
		return;
	}
	
	$.ajax({
		url : _g_contextPath_ + "/kukgoh/updateCancelAssntInfo",
		dataType : 'json',
		data : {
			BGT_CD : selDataItem.BGT_CD,
		},
		type : 'POST',
		success : function(result) {
			
			if (result.OUT_YN ===  'Y') {
				selDataItem.set('ASSTN_EXPITM_TAXITM_CODE', '');
				selDataItem.set('ASSTN_EXPITM_NM', '');
				selDataItem.set('ASSTN_TAXITM_NM', '');
				selDataItem.set('FSYR', '');
				alert("취소하였습니다.");
			} else {
				alert("취소에 실패했습니다.");
				alert(result.OUT_MSG);
			}
		}
	}) 
}

</script>
<body>
<div class="iframe_wrap" style="min-width: 1100px">
	<input type="hidden" id="request_seq"  value="" />
	<input type="hidden" id="loginSeq"  value="${loginSeq }" />
	<input type="hidden" id="bgtCd"  value="" />
	<input type="hidden" id="bgtNm"  value="" />
	<input type="hidden" id="hbgtCd"  value="" />
	<input type="hidden" id="hbgtNm"  value="" />
	<input type="hidden" id="selectedGridCd"  value="" />
	
	<!-- 컨텐츠타이틀영역 -->
	<div class="sub_title_wrap">

		<div class="title_div">
			<h4>공통코드 정보</h4>
		</div>
	</div>

	<div class="sub_contents_wrap">
		<div class="top_box">
			<dl>
				<dt  class="ar" style="width:65px" >예산그룹</dt>
				<dd>
					<div class="controll_btn p0">
						<input type="text" onclick="btnBudChoice()" id="budGnmInput"	value="" disabled/>
						<input type="hidden" id="budGcd" /> 
						<input type="button" onclick="btnBudChoice()" id="searchButton"	value="검색" />
					</div>	
				</dd>
			</dl>
		</div>
		<!-- 버튼 -->
		<div class="btn_div mt10 cl">
			<div class="right_div">
				<div class="controll_btn p0">
					<button type="button" id="" onclick="searchBtn();">조회</button>
				</div>
			</div>
		</div>
		<div class="com_ta2 mt15" >
			<div id="mainConfigGrid">
			</div>
		</div>
		<div class="btn_div mt10 cl">
		</div>
	</div>
	<!-- //sub_contents_wrap -->
</div>
<!-- iframe wrap -->


<!-- 보조비목세목코드 PopUp-->
<div class="pop_wrap_dir" id="popUp" style='width: 1100px; display : none;'>
		<div class="pop_head">
				<h1>예산과목 선택</h1>
			</div>
			<div class="pop_con">
				<div class="com_ta" style="">
						<div class="top_box">
							<dl>
								<!-- <dt  class="ar" style="width:50px" >&nbsp; </dt> -->
								<dt>회계연도</dt>
								<dd>
									<input type="text" id="FSYR"/>
								</dd>
								<dt>보조비목세목명</dt>
								<dd>
									<input type="text" id="subName"/>
								</dd>
								<dd style="margin-left: 45%;">
									<div class="controll_btn p0">
										<button type="button" id="asstn" onclick="asstnGridReload();">조회</button>
									</div>
								</dd>
							</dl>
						</div>
						<div class="com_ta2 mt15" >
							<div id="asstnGrid"></div>
						</div>
				</div>
			</div>
	</div>

<!-- 예산그룹 PopUp-->
<div class="pop_wrap_dir" id="popUp1" style='width: 600px; display : none;'>
	<div class="pop_head">
		<h1>예산그룹</h1>
	</div>
	<div class="pop_con">
		<div class="com_ta" style="">
				<div class="top_box">
					<dl>
						<dt>예산그룹명</dt>
						<dd>
							<input type="text" id="budGnm" style="width: 150px"  style="width:150px;" placeholder="예산그룹명""/> 
						</dd>
					</dl>
				</div>
				<div class="com_ta2 mt15" >
					<div id="budGrid"></div>
				</div>
		</div>
	</div>
</div>

	<div class="pop_wrap_dir" id="filePop" style="width:400px; display: none;">
		<div class="pop_con">
			<!-- 타이틀/버튼 -->
			<div class="btn_div mt0">
				<div class="left_div">
					<h5><span id="popupTitle"></span> 첨부파일</h5>
				</div>
				<div class="right_div">
					<div class="controll_btn p0">
					</div>
				</div>
			</div>
	<div class="com_ta" style="" id="">
		<table id="fileDiv"></table>
	</div>
	</div>
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" class="gray_btn" value="닫기" onclick="popCancel();"/>
		</div>
	</div><!-- //pop_foot -->
</div>
</body>
</html>

