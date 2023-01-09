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
<script type="text/javascript" src="<c:url value='/js/jquery.number.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/jszip.min.js' />"></script>
<style>
dt {	text-align : left; 	width : 10%; }
dd {	width: 11.5%; } 
dd input { 	width : 80%; }
.k-grid-toolbar { float : right; }
#resolutionGrid { height: 100%; }
</style> 

<script type="text/javascript">

var GISU_SQ;
var GISU_DT;
var flag;
var voucherRowData;

$(function() {
	
	// GISU_DT -> ISU_DT
	GISU_SQ = window.opener.$GISU_SQ;
	GISU_DT = window.opener.$GISU_DT;
	flag = window.opener.$flag;
	
	if (flag == "expenditure") {
		voucherRowData = window.opener.$voucherRowData;
		GISU_DT = voucherRowData.GISU_DT;
		GISU_SQ = voucherRowData.GISU_SQ;
	}
	
	resolutionInfo();
	resolutionGrid();
	
	$("#resolutionPopupClose").on("click", function() {
		
		self.close();
	});
});

function resolutionInfo() {
	
	$("#EMP_NM").val("");
	$("#GISU_DT").val("");
	$("#GISU_SQ").val("");
	$("#DFG_NM").val("");
	$("#DIV_NM").val("");
	$("#PJT_NM").val("");
	$("#AMT").val("");
	$("#RMK_DC").val("");
	$("#ACC_NB").val("");
	
	$.ajax({
		url : '<c:url value="/budget/getResolutionAdocm" />',
		data : { 
				"ISU_DT" : GISU_DT,
				"ISU_SQ" : GISU_SQ
			},
		dataType : "json",
		type : "POST",
		success : function(result) {
			
			var data = result.list;
			
			if (data !== null) {
				$("#EMP_NM").val(data.EMP_NM);
				$("#GISU_DT").val(data.GISU_DT);
				$("#GISU_SQ").val(data.GISU_SQ);
				$("#DFG_NM").val(data.DFG_NM);
				$("#DIV_NM").val(data.DIV_NM);
				$("#PJT_NM").val(data.PJT_NM);
				$("#AMT").val(fn_formatMoney(data.AMT));
				$("#RMK_DC").val(data.RMK_DC);
				$("#ACC_NB").val(data.ACC_NB);
			}
			
		}
	});
}

function resolutionGrid(e) {
	
	var resolutionGrid =  $("#resolutionGrid").kendoGrid({
		dataSource: new kendo.data.DataSource({		//그리드데이터소스
			serverPaging : true,
			pageSize : 1000,
			transport : {
				read : {
					url : '<c:url value="/budget/getResolutionAdocb"/>',
					dataType : "json",
					type : "post"
				},
				parameterMap: function(data, operation) {
					
					data.ISU_DT = GISU_DT, // 발생 일자
					data.ISU_SQ = GISU_SQ // 발생 순번
					
			     	return data;
			     }
			},
			schema : {
				data : function(response){
					
					if (response.list.length == 0) {
						$("#resolutionSubGrid").empty();
					}
					
					return response.list;
				},
			    model : {
			    	fields : {

			    	}
			    }
			}
		}),
		dataBound : resolutionGridDataBound,
		selectable : "row",
		sortable : true,
		persistSelection : true,
		columns : [
			{
				width : 20,
				field : "BGT_NM",
				title : "계정코드"
			},
			{
				template : function(dataItem) {
					return fn_formatMoney(dataItem.AMT); 
				},
				width : 20,
				title : "금액"
			},
			{
				width : 20,
				field : "DIV_NM1",
				title : "결제수단"
			},
			{
				width : 20,
				field : "DIV_NM2",
				title : "과세구분"
			},
			{
				width : 20,
				field : "DIV_NM3",
				title : "채주유형"
			},
			{
				width : 20,
				field : "RMK_DC",
				title : "비고"
			}
		],
		change : selectRow

	}).data("kendoGrid");
	
	function resolutionGridDataBound(e) {
		
		$gridIndex = 0;
		var grid = e.sender;
		
		if (grid.dataSource._data.length==0) {
			
			var colCount = grid.columns.length;
			$(e.sender.wrapper)
				.find('tbody')
				.append('<tr class="kendo-data-row">' + 
						'<td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
		} else {
			
			resolutionSubGrid({"BG_SQ":e.sender.dataSource._data[0].BG_SQ}); // 첫 번째 자료 바인딩
		}
	}
	
	function selectRow(e){		//row클릭시 data 전역변수 처리

		row = e.sender.select();
		grid = $('#resolutionGrid').data("kendoGrid");
		data = grid.dataItem(row);
		
		console.log(data);
		
		resolutionSubGrid(data);
	}
}

function resolutionSubGrid(row) {
	
	var resolutionSubGrid =  $("#resolutionSubGrid").kendoGrid({
		dataSource: new kendo.data.DataSource({		//그리드데이터소스
			serverPaging : true,
			pageSize : 1000,
			transport : {
				read : {
					url : '<c:url value="/budget/getResolutionAdoct"/>',
					dataType : "json",
					type : "post"
				},
				parameterMap: function(data, operation) {
					
					data.ISU_DT = GISU_DT, // 발생 일자
					data.ISU_SQ = GISU_SQ // 발생 순번
					data.BG_SQ = row.BG_SQ // 발생 순번
					
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
		dataBound : dataBound,
		selectable : "row",
		sortable : true,
		persistSelection : true,
		columns : [
			{
				width : 15,
				field : "TR_CD",
				title : "코드"
			},
			{
				width : 15,
				field : "TR_NM",
				title : "거래처명"
			},
			{
				width : 15,
				field : "CEO_NM",
				title : "대표자명"
			},
			{
				template : function(dataItem) {
					return fn_formatMoney(dataItem.UNIT_AM);
				},
				width : 15,
				title : "금액"
			},
			{
				template : function(dataItem) {
					return fn_formatMoney(dataItem.SUP_AM);
				},
				width : 15,
				title : "공급가액"
			},
			{
				template : function(dataItem) {
					return fn_formatMoney(dataItem.VAT_AM);
				},
				width : 15,
				title : "부가세"
			},
			{
				width : 15,
				field : "BNM",
				title : "금융기관"
			},
			{
				width : 15,
				field : "BA_NB",
				title : "계좌번호"
			},
			{
				width : 15,
				field : "DEPOSITOR",
				title : "예금주"
			},
			{
				width : 15,
				field : "RMK_DC",
				title : "비고"
			},
			{
				width : 15,
				field : "CARD_NB",
				title : "카드번호"
			},
			{
				width : 15,
				field : "SUNG_NB",
				title : "승인번호"
			},
			{
				width : 15,
				field : "TDT",
				title : "신고기준일"
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

function fn_formatDate(str){
	return str.substring(0,4) + "-" + str.substring(4,6) + "-" + str.substring(6,8) ;
}

function fn_formatMoney(str){
        str = String(str);
        return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
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

</script>
   
 <body>   
 	<input type="hidden" id="jsonStr" />
 	
	<!-- 지출결의 조회화면 -->
	<div class="pop_wrap_dir" id="resolutionPopup" style="width:100%; margin-top: 25px;">
		<div class="com_ta">
			<div class="top_box gray_box" id = "dataBox">
				<dl>
					<dt style="width:5%; margin-left:8.4%;">발의자</dt>
					<dd style="width:4%">
						<input type="text"  style="width: 100%" id ="EMP_NM" disabled />
					</dd>
					<dt style="width:5%">발의일자</dt>
					<dd style="width:7%">
						<input type="text"  style="width: 100%" id ="GISU_DT" disabled />
					</dd>
					<dt style="width:5%">발의번호</dt>
					<dd style="width:4%">
						<input type="text"  style="width: 100%" id ="GISU_SQ" disabled />
					</dd>
					<dt style="width:5%">결의구분</dt>
					<dd style="width:4%">
						<input type="text"  style="width: 100%" id ="DFG_NM" disabled />
					</dd>
				</dl>
				<dl class="next2" style="margin-left:7%;">
					<dt style="width:5%;">회계단위</dt>
					<dd style="width:18%">
						<input type="text" style="width:100%" id="DIV_NM" value="" disabled>
					</dd>
					<dt style="width:5%;">프로젝트</dt>
					<dd style="width:20%">
						<input type="text" style="width:100%" id="PJT_NM" value="" disabled>
					</dd>
					<dt style="width:6%;">금액</dt>
					<dd style="width:31%">
						<input type="text" style="width:100%" id="AMT" value="" disabled>
					</dd>
				</dl>
				<dl class="next2" style="margin-left:7%;">
					<dt style="width:5%;">적요</dt>
					<dd style="width:46%">
						<input type="text" style="width:100%" id="RMK_DC" value="" disabled>
					</dd>
					<dt style="width:6%;">입출금계좌</dt>
					<dd style="width:31%">
						<input type="text" style="width:100%" id="ACC_NB" value="" disabled>
					</dd>
				</dl>
			</div>
		</div>
		<div class="pop_con">
			<div class="com_ta mt15">
				<div  id = "resolutionGrid">
				</div>
			</div>
			<div class="com_ta mt15">
				<div  id = "resolutionSubGrid">
				</div>
			</div>
		</div>
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" class="gray_btn" id="resolutionPopupClose" value="닫기">
			</div>
		</div>
	</div>
</body>