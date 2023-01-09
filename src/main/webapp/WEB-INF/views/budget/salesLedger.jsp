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
var $resolutionDept;
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
			url : _g_contextPath_+ "/budget/salesLedgerList",
			dataType : "json",
			type : "post"
		},
		parameterMap: function(data, operation) {
			
			data.accounting_unit = $("#accounting_unit").data("kendoDropDownList").value();
			data.resolution_dept = $("#resolution_dept").data("kendoDropDownList").value();
			data.division = $("#division").data("kendoDropDownList").value();
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

	$(function(){
		
		makeComboList();
		
		$("#accounting_unit").kendoDropDownList({
			dataTextField : 'DIV_NM' ,
			dataValueField : 'DIV_CD' ,
			dataSource : $accounting_unit_list
		});
		
		$("#resolution_dept").kendoDropDownList({
			dataTextField : 'DEPT_NM' ,
			dataValueField : 'DEPT_CD' ,
			dataSource : $resolutionDept
		});
		
		$("#division").kendoDropDownList({
			dataTextField : "DIVISION_NM",
			dataValueField : "DIVISION_CD",
			dataSource : [{
				DIVISION_NM : "신고기준일기준",
				DIVISION_CD : "1"
			},{
				DIVISION_NM : "기표일자기준",
				DIVISION_CD : "2"
			}]
		})
		
		$("#from_period").kendoDatePicker({
		    depth: "month",
		    start: "month",
		    culture : "ko-KR",
			format : "yyyy-MM-dd",
			value : new Date('${year}','${mm-1}',1),
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
		
	});
	
	function makeComboList(){
		$.ajax({
			url : _g_contextPath_+ "/budget/accountingComboList",
			data : {

				},
			async : false,
			type : "POST",
			success : function(result){				
				$accounting_unit_list = result.accountingUnitList;
			}
		});
		
		$.ajax({
			url : _g_contextPath_+ "/budget/resolutionDeptComboList",
			data : {
					
				},
			async : false,
			type : "POST",
			success : function(result){				
				$resolutionDept = result.resolutionDeptList;
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
					width : 15,
					field : "DIV_NM",
					title : "회계단위"
				},
				{
					width : 15,
					field : "DEPT_NM",
					title : "결의부서"
				},
				{
					width : 15,
					field : "FROM_DT",
					title : "신고기준일"
				},
				{
					width : 15,
					field : "FILL_DT",
					title : "기표일자"
				},
				{
					width : 15,
					field : "RMK_DC",
					title : "적요"
				},
				{
					width : 15,
					field : "TAXDIV1",
					title : "세무구분"
				},
				{
					width : 15,
					field : "TAXDIV2",
					title : "사유구분"
				},
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
					field : "RNB",
					title : "사업자번호"
				},
				{
					template : function(e) {
						
						if(e.VATAM1 == null || e.VATAM1 == ""|| e.VATAM1 == "0"){
							return '';
						}else{
							return fn_formatMoney(e.VATAM1);
						}
					},
					width : 15,
					title : "공급가액"
				},
				{
					template : function(e) {
						
						if(e.VATAM2 == null || e.VATAM2 == ""|| e.VATAM2 == "0"){
							return '';
						}else{
							return fn_formatMoney(e.VATAM2);
						}
					},
					width : 15,
					title : "세액"
				},
				{
					template : function(e) {
						
						if(e.VATSUM == null || e.VATSUM == ""|| e.VATSUM == "0"){
							return '';
						}else{
							return fn_formatMoney(e.VATSUM);
						}
					},
					width : 15,
					title : "계"
				},
				{
					width : 11,
					title : "전표보기",
					template : function(e) {
						
						if (e.DIV === "1") {
							return '<input type="button" class="blue_btn" value="전표보기" onclick = "watchVoucher(this)">';		
						} else {
							return "";
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
			
			console.log($rowData);
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
	
	function fn_formatDate(str){
		return str.substring(0,4) + "-" + str.substring(4,6) + "-" + str.substring(6,8) ;
	}

	function fn_formatMoney(str){
	        str = String(str);
	        return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
	}
	
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
					<dt style="width:5%">결의부서</dt>
					<dd style="width:10%">
						<input type="text" style="width:100%" id ="resolution_dept"/>
					</dd>
					<dt style="width:3%">구분</dt>
					<dd style="width:10%">
						<input type="text" style="width:100%" id ="division"/>
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
				</div>
			</div>
		</div>
		
		<div class="com_ta2">
			<div  id = "grid">
			</div>
		</div>
		
	</div>
</div>

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

