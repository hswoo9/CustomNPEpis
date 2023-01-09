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
<script type="text/javascript" src='<c:url value="/js/ac/acUtil.js"></c:url>'></script>
<script type="text/javascript" src="<c:url value='/js/jquery.form.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/jszip.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/shieldui-all.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/budget/budgetUtil.js' />"></script>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title></title>
</head>

<script type="text/javascript">

var nowDate = new Date();
var minus7days = new Date();
minus7days.setDate(nowDate.getDate() - 7);

var selRow = '';
var gubun = ''; // self / adjust

$(function() {
	Init.kendoFunction();
	Init.kendoGrid();
	Init.eventListener();
})
	
var Init = {
		kendoGrid : function() {
			var mainGrid = $("#mainGrid").kendoGrid({
				dataSource : new kendo.data.DataSource({
					serverPaging : true,
					pageSize : 20,
					transport : {
						read : {
							url : _g_contextPath_+"/resAlphaG20/selectCardFullList",
							dataType : "json",
							type : 'post'
						},
						parameterMap : function(data, operation) {
							data.fromDate = $('#fromDate').val().replace(/\-/g,'');
							data.toDate = $('#toDate').val().replace(/\-/g,'');
							data.partnerName = $('#partnerName').val();
							data.adjustment = $('#adjustment').val();
							data.authNum = $('#authNum').val();
							data.mercSaupNo = $('#mercSaupNo').val().replace(/\-/g,'');
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
				sortable : true,
				scrollable: true,
				pageable: {
		            refresh: true,
		            pageSizes: true,
		            buttonCount: 5
		        }, //
				persistSelection : true,
				selectable : "multiple",
		        columns: [
					{
						template: function(dataItem) {
							var date = dataItem.authDate;
							var time = dataItem.authTime;
							
							var result = date.substring(0, 4) + "-" + date.substring(4, 6) + "-" + date.substring(6, 8);
								  result += " " + time.substring(0, 2) + ":" + time.substring(2, 4);
							
							return result;  
						},
						title : "승인일시",
						width : 85
					},
					{
						template: function(dataItem) {
							return "<a href='javascript:viewCardPopup(\"" + dataItem.syncId + "\");' style='color: blue;'>" + dataItem.authNum + "</a>";
						},
						title : "승인번호",
						width : 65
					},
					{
						field : 'partnerName',
						title : "사용처",
						width : 120
					},
					{
						template: function(dataItem) {
							return dataItem.partnerNo.substring(0, 3) + "-" + dataItem.partnerNo.substring(3, 5) + "-" + dataItem.partnerNo.substring(5);
						},
						title : "사업자번호",
						width : 70
					},
					{
						field : 'cardName',
						title : "카드명",
						width : 120
					},
					{
						field : 'cardNum',
						title : "카드번호",
						width : 90
					},
					{
						template : function(dataItem) {
							return Budget.fn_formatMoney(dataItem.reqAmt);
						},
						title : "청구금액",
						width : 70
					},
					{
						template : function(dataItem) {
							return Budget.fn_formatMoney(dataItem.totalAmt);
						},
						title : "결의금액",
						width : 70
					},
					{
						template : function(dataItem) {
							return Budget.fn_formatMoney(dataItem.selfAmt);
						},
						title : "자부담금액",
						width : 70
					},
					{
						template : function(dataItem) {
							return Budget.fn_formatMoney(dataItem.adjustAmt);
						},
						title : "조정금액",
						width : 70
					},
					{
						template : function(dataItem) {
							var remainingAmt = Number(dataItem.reqAmt) - (Number(dataItem.totalAmt) + Number(dataItem.selfAmt))
							return Budget.fn_formatMoney(remainingAmt);
						},
						title : "미정산금액",
						width : 70
					},
					{
						template : function(dataItem) {
							var reqAmt = Number(dataItem.reqAmt);
							var totalAmt = Number(dataItem.totalAmt);
							var selfAmt = Number(dataItem.selfAmt);
							
							if (selfAmt > 0) { // 자부담 금액이 등록되 있을 시
								return '<input type="button" class="blue_btn" onclick="openUpdateSelfAmt(this);" value="수정"">';	
							} else if (totalAmt > 0 && totalAmt != reqAmt) { // 결의 금액이 존재하는데 청구금액과 상이할 시
								return '<input type="button" class="blue_btn" onclick="openApplySelfAmt(this);" value="등록"">';
							} else {
								return '';
							}
						},
						title : "자부담등록",
						width : 70
					},
					{
						template : function(dataItem) {
							var reqAmt = Number(dataItem.reqAmt);
							var totalAmt = Number(dataItem.totalAmt);
							var selfAmt = Number(dataItem.selfAmt);
							var adjustAmt = Number(dataItem.adjustAmt);
							
							if (adjustAmt > 0) { // 자부담 금액이 등록되 있을 시
								return '<input type="button" class="blue_btn" onclick="openUpdateAdjustAmt(this);" value="수정"">';	
							} else if (totalAmt > 0 && totalAmt != reqAmt) { // 결의 금액이 존재하는데 청구금액과 상이할 시
								return '<input type="button" class="blue_btn" onclick="openApplyAdjustAmt(this);" value="등록"">';
							} else {
								return '';
							}
						},
						title : "조정금액<br/>등록",
						width : 70
					},
					{
						template : function(dataItem) {
							var remainingAmt = Number(dataItem.reqAmt) - (Number(dataItem.totalAmt) + Number(dataItem.selfAmt) + Number(dataItem.adjustAmt))
							if (remainingAmt === 0) {
								return '<span style="color: blue;">정산완료</span>';
							} else {
								return '<span style="color: red;">미정산</span>';
							}
						},
						title : "정산여부",
						width : 70
					},
					]
		    }).data("kendoGrid");
			
			var empGrid = $("#empGrid").kendoGrid({
		        dataSource: new kendo.data.DataSource({
		    		serverPaging: true,
		    		pageSize: 20,
		    	    transport: { 
		    	        read:  {
		    	            url: _g_contextPath_+'/common/empInformation',
		    	            dataType: "json",
		    	            type: 'post'
		    	        },
		    	      	parameterMap: function(data, operation){
		    	      		data.emp_name = $("#emp_name").val();
		    	        	data.deptSeq = '';
		    	        	data.notIn = '';
		    	     		return data;
		    	     	}
		    	    },
		    	    schema: {
		    	      data: function(response) {
		    	        return response.list;
		    	      },
		    	      total: function(response) {
		    	        return response.totalCount;
		    	      }
		    	    }
		    	}),
		        height: 500,	        
		        sortable: true,
		        pageable: {
		            refresh: true,
		            pageSizes: true,
		            buttonCount: 5
		        },
		        persistSelection: true,
		        selectable: "multiple",
		        columns:[ {field: "emp_name",
					            title: "이름",
						    },{field: "dept_name",
					            title: "부서",
					        },{field: "position",
					            title: "직급",
		        		    }, {field: "duty",
		            		    title: "직책",
		        		    }, {title : "선택",
							    template : '<input type="button" id="" class="text_blue" onclick="empSelect(this);" value="선택">'
		        		    }]
		    }).data("kendoGrid");
		},
		
		
		kendoFunction : function() {
			
			$("#applyPopup").kendoWindow({
			    width: "600px",
			   height: "300px",
			    visible: false,
			    actions: ["Close"]
			}).data("kendoWindow").center();
			
			$("#adjustAmtApplyPopup").kendoWindow({
			    width: "600px",
			   height: "300px",
			    visible: false,
			    actions: ["Close"]
			}).data("kendoWindow").center();
			
			$("#fromDate").kendoDatePicker({
		        start: "month",
		        depth: "month",
		        format: "yyyy-MM-dd",
				parseFormats : ["yyyy-MM-dd"],
		        culture : "ko-KR",
		        dateInput: true,
		        value : minus7days
		    });
			
			$("#toDate").kendoDatePicker({
		        start: "month",
		        depth: "month",
		        format: "yyyy-MM-dd",
				parseFormats : ["yyyy-MM-dd"],
		        culture : "ko-KR",
		        dateInput: true,
		        value : moment().format('YYYY-MM-DD')
		    });
			
			$("#empPopUp").kendoWindow({
			    width: "600px",
			   height: "750px",
			    visible: false,
			    actions: ["Close"]
			}).data("kendoWindow").center();
			
			$("#adjustment").kendoDropDownList({
				dataTextField : 'adjustmentNm' ,
				dataValueField : 'adjustmentCd' ,
				dataSource : [{ adjustmentNm : "전체", adjustmentCd : 0 }, { adjustmentNm : "정산", adjustmentCd : 1 }, { adjustmentNm : "미정산", adjustmentCd : 2 }]
			});
		},
		
		eventListener : function() {
			$("input[searchEnterKey]").on("keyup", function(e) {
				if (e.keyCode == 13) {
					fn_searchBtn();
				}
			});
			
			$(document).on("click", "#mainGrid tbody tr", function(e) {
				row = $(this)
				grid = $('#mainGrid').data("kendoGrid"),
				dataItem = grid.dataItem(row);
				
				console.log(dataItem);	
			});
			
			$('#applyPopupCancel').on('click', function() {
				$("#applyPopup").data("kendoWindow").close();
			});
			
			$('#ad_applyPopupCancel').on('click', function() {
				$("#adjustAmtApplyPopup").data("kendoWindow").close();
			});
			
			$("#empSearch, #ad_empSearch").click(function(){	
				 $('#emp_name').val("");
				 $('#selectedEmpName').val('');
				 $("#empPopUp").data("kendoWindow").open();
				 empGridReload();
			});
			
			$("#empPopUpCancel").click(function(){
				 $("#empPopUp").data("kendoWindow").close();
			});
			
			$("#emp_name").on("keyup", function(e) {
				if (e.keyCode === 13) {
					empGridReload();	
				}
			});
			
			$('#applyBtn').on('click', function() {
				applySelfAmt();
			});
			
			$("#updateBtn").on("click", function() {
				updateSelfAmt();
			});
			
			$('#ad_applyBtn').on('click', function() {
				applyAdjustAmt();
			});
			
			$("#ad_updateBtn").on("click", function() {
				updateAdjustAmt();
			});
		}
}
		
function empGridReload(){
	$('#empGrid').data('kendoGrid').dataSource.read(0);
}

//선택 클릭이벤트
function empSelect(e){		
	var row = $("#empGrid").data("kendoGrid").dataItem($(e).closest("tr"));
	
	console.log(row);
	
	if (gubun === 'self') {
		$('#selectedEmpName').val(row.emp_name);
		$("#empSeq").val(row.emp_seq);
	} else if (gubun === 'adjust') {
		$('#ad_selectedEmpName').val(row.emp_name);
		$("#ad_empSeq").val(row.emp_seq);
	}
	
	$("#empPopUp").data("kendoWindow").close();
}

function empPopUpClose(){
	 $("#empPopUp").data("kendoWindow").close();
}

function mainGridDataBound(e) {
	var grid = e.sender;
	
	if (grid.dataSource.total() == 0) {
		var colCount = grid.columns.length;
		$(e.sender.wrapper).find('tbody').append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
	}
}

function fn_searchBtn() {
	$('#mainGrid').data('kendoGrid').dataSource.read(0);
}

function openUpdateSelfAmt(thisObj) {
	
	gubun = 'self';
	
	var row = $("#mainGrid").data("kendoGrid").dataItem($(thisObj).closest("tr"));
	
	$("#selfAmt").val(row.selfAmt);
	$("#reason").val(row.reason);
	$("#selectedEmpName").val(row.empName);
	$("#empSeq").val(row.empSeq);
	
	$("#applyBtn").css("display", "none");
	$("#updateBtn").css("display", "inline-block");
	
	var row = $("#mainGrid").data("kendoGrid").dataItem($(thisObj).closest("tr"));
	
	selRow = row;
	
	$("#applyPopup").data("kendoWindow").open();
}

function openApplySelfAmt(thisObj) {
	
	gubun = 'self';
	
	$("#applyBtn").css("display", "inline-block");
	$("#updateBtn").css("display", "none");
	cleanPopup();
	
	var row = $("#mainGrid").data("kendoGrid").dataItem($(thisObj).closest("tr"));
	
	selRow = row;
	
	$("#applyPopup").data("kendoWindow").open();
}

function cleanPopup() {
	$("#selfAmt").val('');
	$("#reason").val('');
	$("#selectedEmpName").val('');
	$("#empSeq").val('');
}

// 자부담 신청 버튼 클릭
function applySelfAmt() {
	
	var remainingAmt = Number(selRow.reqAmt) - (Number(selRow.totalAmt) + Number(selRow.selfAmt) + Number(selRow.adjustAmt))
	
	/* 유효성 체크 */
	if (!checkValid(remainingAmt)) {
		return;
	}
	
	var data = {
			syncId : selRow.syncId,
			reqAmt : selRow.reqAmt,
			selfAmt : $("#selfAmt").val().replace(/\,/g, ''),
			reason : $("#reason").val(),
			empSeq : $("#empSeq").val(),
			empName : $("#selectedEmpName").val(),
	}
	
	$.ajax({
		type : 'post',
		url : '/CustomNPEPIS/resAlphaG20/saveSelfPayCard',
		datatype : 'json',
		data : data,
		success : function(result) {
			alert('성공하였습니다.');
			$("#applyPopup").data("kendoWindow").close();
			$('#mainGrid').data('kendoGrid').dataSource.read(0);
		},
		error : function(data) {
		}
	});
	
}

function updateSelfAmt() {
	
	var remainingAmt = Number(selRow.reqAmt) - (Number(selRow.totalAmt) + Number(selRow.selfAmt) + Number(selRow.adjustAmt)) + Number(selRow.selfAmt);
	
		/* 유효성 체크 */
	if (!checkValid(remainingAmt)) {
		return;
	}
	
	var data = {
			syncId : selRow.syncId,
			reqAmt : selRow.reqAmt,
			selfAmt : $("#selfAmt").val().replace(/\,/g, ''),
			reason : $("#reason").val(),
			empSeq : $("#empSeq").val(),
			empName : $("#selectedEmpName").val(),
	}
	
	$.ajax({
		type : 'post',
		url : '/CustomNPEPIS/resAlphaG20/updateSelfPayCard',
		datatype : 'json',
		data : data,
		success : function(result) {
			alert('성공하였습니다.');
			$("#applyPopup").data("kendoWindow").close();
			$('#mainGrid').data('kendoGrid').dataSource.read(0);
		},
		error : function(data) {
		}
	});
	
}

function checkValid(remainingAmt) {
	
	var flag = true;
	
	/* 유효성 체크 */
	if ($("#selfAmt").val() === "") {
		alert("금액을 입력해주세요.");
		flag = false;
	} else if ($("#reason").val() == "") {
		alert("사유를 입력해주세요.");
		flag = false;
	} else if ($("#selectedEmpName").val() == "") {
		alert("부담자를 선택해주세요.");
		flag = false;
	} else if (Number($("#selfAmt").val().replace(/\,/g, '')) > remainingAmt) {
		alert("자부담 금액이 미정산 금액을 초과할 수 없습니다.");
		flag = false;
	}
	
	return flag;
}

function checkValid2(remainingAmt) {
	
	var flag = true;
	
	/* 유효성 체크 */
	if ($("#adjustAmt").val() === "") {
		alert("금액을 입력해주세요.");
		flag = false;
	} else if ($("#ad_reason").val() == "") {
		alert("사유를 입력해주세요.");
		flag = false;
	} else if ($("#ad_selectedEmpName").val() == "") {
		alert("부담자를 선택해주세요.");
		flag = false;
	} else if (Number($("#adjustAmt").val().replace(/\,/g, '')) > remainingAmt) {
		alert("조정 금액이 미정산 금액을 초과할 수 없습니다.");
		flag = false;
	}
	
	return flag;
}

function openUpdateAdjustAmt(thisObj) {
	
	gubun = 'adjust';
	
	var row = $("#mainGrid").data("kendoGrid").dataItem($(thisObj).closest("tr"));
	
	$("#adjustAmt").val(row.adjustAmt);
	$("#ad_reason").val(row.ad_reason);
	$("#ad_selectedEmpName").val(row.ad_empName);
	$("#ad_empSeq").val(row.ad_empSeq);
	
	$("#ad_applyBtn").css("display", "none");
	$("#ad_updateBtn").css("display", "inline-block");
	
	var row = $("#mainGrid").data("kendoGrid").dataItem($(thisObj).closest("tr"));
	
	selRow = row;
	
	$("#adjustAmtApplyPopup").data("kendoWindow").open();
}

function openApplyAdjustAmt(thisObj) {
	
	gubun = 'adjust';
	
	$("#ad_applyBtn").css("display", "inline-block");
	$("#ad_updateBtn").css("display", "none");
	cleanPopup2();
	
	var row = $("#mainGrid").data("kendoGrid").dataItem($(thisObj).closest("tr"));
	
	selRow = row;
	
	$("#adjustAmtApplyPopup").data("kendoWindow").open();
}

function cleanPopup2() {
	$("#adjustAmt").val('');
	$("#ad_reason").val('');
	$("#ad_selectedEmpName").val('');
	$("#ad_empSeq").val('');
}

//조정 신청 버튼 클릭
function applyAdjustAmt() {
	
	var remainingAmt = Number(selRow.reqAmt) - (Number(selRow.totalAmt) + Number(selRow.selfAmt) + Number(selRow.adjustAmt))
	
	/* 유효성 체크 */
	if (!checkValid2(remainingAmt)) {
		return;
	}
	
	var data = {
			syncId : selRow.syncId,
			reqAmt : selRow.reqAmt,
			selfAmt : $("#adjustAmt").val().replace(/\,/g, ''),
			reason : $("#ad_reason").val(),
			empSeq : $("#ad_empSeq").val(),
			empName : $("#ad_selectedEmpName").val(),
	}
	
	$.ajax({
		type : 'post',
		url : '/CustomNPEPIS/resAlphaG20/saveAdjustPayCard',
		datatype : 'json',
		data : data,
		success : function(result) {
			alert('성공하였습니다.');
			$("#adjustAmtApplyPopup").data("kendoWindow").close();
			$('#mainGrid').data('kendoGrid').dataSource.read(0);
		},
		error : function(data) {
		}
	});
	
}

function updateAdjustAmt() {
	
	var remainingAmt = Number(selRow.reqAmt) - (Number(selRow.totalAmt) + Number(selRow.selfAmt) + Number(selRow.adjustAmt)) + Number(selRow.selfAmt);
	
		/* 유효성 체크 */
	if (!checkValid2(remainingAmt)) {
		return;
	}
	
	var data = {
			syncId : selRow.syncId,
			reqAmt : selRow.reqAmt,
			selfAmt : $("#adjustAmt").val().replace(/\,/g, ''),
			reason : $("#ad_reason").val(),
			empSeq : $("#ad_empSeq").val(),
			empName : $("#ad_selectedEmpName").val(),
	}
	
	$.ajax({
		type : 'post',
		url : '/CustomNPEPIS/resAlphaG20/updateAdjustPayCard',
		datatype : 'json',
		data : data,
		success : function(result) {
			alert('성공하였습니다.');
			$("#adjustAmtApplyPopup").data("kendoWindow").close();
			$('#mainGrid').data('kendoGrid').dataSource.read(0);
		},
		error : function(data) {
		}
	});
	
}

function viewCardPopup(syncId) {
	window.open("http://10.10.10.82/custExp/expend/np/user/UserCardDetailPop.do?syncId=" + syncId, "" , "width=432, height=520")
}

</script>

<body>
<div class="iframe_wrap" style="min-width: 1070px;">
	<div class="sub_title_wrap">
		<div class="title_div">
			<h4>카드사용내역</h4>
		</div>
		<div class="sub_contents_wrap">
			<p class="tit_p mt5 mt20" style="width: 90%">카드사용내역</p>
				<div class="top_box" style="width: 90%">
					<dl>
						<dt  class="ar" style="width:55px;" >승인일자</dt>
						<dd>
							<input type="text" id="fromDate" /> ~
							<input type="text" id="toDate" />
						</dd>
						<dt  class="ar" style="width:50px;" >사용처</dt>
						<dd>
							<input type="text" id="partnerName" searchEnterKey/>        <!--  사용처 -->
						</dd>
						<dt style="width: 66px;">정산 상태</dt>
						<dd style="width: 66px;">
							<input type="text" style="width:100%" id ="adjustment"/>	 <!--  정산 상태 -->
						</dd>
						<dd>
							<dt style="width: 66px;">승인번호</dt>	
						</dd>
						<dd>
							<input type="text" id="authNum" searchEnterKey/>			 <!--  승인 번호 -->
						</dd>
						<dd>
							<dt style="width: 66px;">사업자번호</dt>
						</dd>
						<dd>
							<input type="text" id="mercSaupNo" searchEnterKey/>			 <!--  사업자번호 -->
						</dd>
						<dd>
							<button type="button" class="blue_btn" id="searchBtn" onclick="fn_searchBtn();">조회</button> 
						</dd>
					</dl>
				</div>
				<div class="btn_div" style="width: 90%">	
					<div class="right_div">
						<div class="controll_btn p0">
<!-- 							<button type="button" id="searchBtn" onclick="fn_downExcel();">엑셀다운로드</button> -->
						</div>
					</div>
				</div>
				<div class="com_ta2 mt15" style="width: 90%;">
				    <div id="mainGrid"></div>
				</div>		
		</div>
	</div>
</div>

<!-- 자부담 금액 등록 팝업 -->
<div class="pop_wrap_dir" id="applyPopup" style="width:600px;">
	<div class="pop_head">
		<h1>자부담 금액 등록</h1>
	</div>
	<div class="pop_con">
		<div class="top_box">
			<dl>
				<dt class="ar" style="width: 90px;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> 자부담 금액</dt>
				<dd style="">
					<input type="text" id="selfAmt" class="amountUnit" style="width: 120px" numberOnly/>
				</dd>
			</dl>
			<dl>
				<dt class="ar" style="width: 90px;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> 사유</dt>
				<dd style="">
					<input type="text" id="reason"  style="width: 400px" />
				</dd>
			</dl>
			<dl>
				<dt class="ar" style="width: 90px;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> 부담자</dt>
				<dd style="">
					<input type="text"  id ="selectedEmpName" value="" disabled/>
					<input type="hidden" id ="empSeq" value=""/>
				</dd>
				<dd style="">
					<button type="button" id ="empSearch" value="검색">
					<img style="position:inherit;" src="<c:url value='/Images/btn/search_icon2.png'/>"></button>
				</dd>
			</dl>
		</div>
	</div>

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" class="text_btn" id="applyBtn" value="등록" style="display:none; "/>
			<input type="button" class="text_btn" id="updateBtn" value="수정" style="display:none; " />
			<input type="button" class="text_btn" id="applyPopupCancel" value="닫기" />
		</div>
	</div>
</div>	
<!-- 자부담 금액 등록 팝업 -->

<!-- 조정 금액 등록 팝업 -->
<div class="pop_wrap_dir" id="adjustAmtApplyPopup" style="width:600px;">
	<div class="pop_head">
		<h1>조정 금액 등록</h1>
	</div>
	<div class="pop_con">
		<div class="top_box">
			<dl>
				<dt class="ar" style="width: 90px;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> 조정 금액</dt>
				<dd style="">
					<input type="text" id="adjustAmt" class="amountUnit" style="width: 120px" numberOnly/>
				</dd>
			</dl>
			<dl>
				<dt class="ar" style="width: 90px;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> 사유</dt>
				<dd style="">
					<input type="text" id="ad_reason"  style="width: 400px" />
				</dd>
			</dl>
			<dl>
				<dt class="ar" style="width: 90px;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> 부담자</dt>
				<dd style="">
					<input type="text"  id ="ad_selectedEmpName" value="" disabled/>
					<input type="hidden" id ="ad_empSeq" value=""/>
				</dd>
				<dd style="">
					<button type="button" id ="ad_empSearch" value="검색">
					<img style="position:inherit;" src="<c:url value='/Images/btn/search_icon2.png'/>"></button>
				</dd>
			</dl>
		</div>
	</div>

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" class="text_btn" id="ad_applyBtn" value="등록" style="display:none; "/>
			<input type="button" class="text_btn" id="ad_updateBtn" value="수정" style="display:none; " />
			<input type="button" class="text_btn" id="ad_applyPopupCancel" value="닫기" />
		</div>
	</div>
</div>	
<!-- 조정 금액 등록 팝업 -->


<!-- 사원검색팝업 -->
<div class="pop_wrap_dir" id="empPopUp" style="width:600px;">
	<div class="pop_head">
		<h1>사원 선택</h1>
	</div>
	<div class="pop_con">
		<div class="top_box">
			<dl>
				<dt class="ar" style="width: 65px;">성명</dt>
				<dd style="margin-right : 70px;">
					<input type="text" id="emp_name" style="width: 120px" />
				</dd>
				<dd>
					<input type="button" onclick="empGridReload();" id="searchButton"	value="검색" />
				</dd>
			</dl>
		</div>
		<div class="com_ta mt15" style="">
			<div id="empGrid"></div>
		</div>			
	</div>

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" class="gray_btn" id="empPopUpCancel" value="닫기" />
		</div>
	</div>
</div>	
<!-- 사원검색팝업 -->
	
</body>
</html>