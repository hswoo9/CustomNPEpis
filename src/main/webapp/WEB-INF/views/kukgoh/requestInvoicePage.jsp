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
<script type="text/javascript" src='<c:url value="/js/ac/acUtil.js"></c:url>'></script>
<script type="text/javascript" src="<c:url value='/js/jquery.form.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/jszip.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/shieldui-all.min.js' />"></script>
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
$(document).ready(function() {
    $("#FR_DATE").kendoDatePicker({
        start: "month",
        depth: "month",
        format: "yyyy-MM-dd",
		parseFormats : ["yyyy-MM-dd"],
        culture : "ko-KR",
        dateInput: true
    });
    var mm = '${mm}';
    var year = '${year}';    
    var dd = '${dd}';
    $("#TO_DATE").kendoDatePicker({
        start: "month",
        depth: "month",
        format: "yyyy-MM-dd",
		parseFormats : ["yyyy-MM-dd"],
        culture : "ko-KR",
        dateInput: true
    });	
    $("#TO_DATE").val( '${year}' +"-"+ '${mm}'+'-'+'${dd}');    
    if(mm == 01){
    	mm = 12;
    	year = year-1; 
    }else{
    	if(mm < 11){
    		mm = '0'+ (mm-1); 
    	}else{
    		mm = mm-1;
    	}
    }

    $("#FR_DATE").val(year+"-"+mm +'-01');

	$('#popUp').kendoWindow({
		width : "600px",
		height : "300px",
		visible : false,
		modal : true,
		actions : [ "Close" ],
	}).data("kendoWindow").center();
	$('#insertInvoice').on('click', function() {
		$('#popUp').data("kendoWindow").open();
	})	;
	
	$('#popUp').on('keypress', function(e) {
		if (e.key == 'Enter') {
			//empGridReload();
		};
	});
	//TRANSFR_ACNUT_SE_CODE
	$("#btnGetPrufSeNo").on("click", function(){
		var aa = $('#ETXBL_CONFM_NO2').val();
		console.log(aa);
			data = {
					ETXBL_CONFM_NO : $('#ETXBL_CONFM_NO2').val()		
					,OUT_YN : '1'
					,OUT_MSG : '1'
			}
			$.ajax({
				url : "<c:url value='/kukgoh/invoiceValidation' />",
				data : data,
				type : 'POST',
				success : function(result) {
					console.log(result);
					if(result.OUT_YN == 'Y'){
						$('#txtEtxbl').html($('#ETXBL_CONFM_NO2').val());
					}else{
						alert(result.OUT_MSG);
					}
				}	
				});
	});	

});
</script>
<script type="text/javascript">
function fn_invoiceSelect(e){
	var parent = window.opener;
	
	var answer ="test";
	var row = $("#kukgohInvoiceGrid").data("kendoGrid").dataItem($(e).closest("tr"));
	console.log(row);
	if(confirm("전자(세금)계산서를 선택하시겠습니까?")){
		parent.document.getElementById('ETXBL_CONFM_NO').value = row.ETXBL_CONFM_NO;
		parent.document.getElementById('PRUF_SE_NO').value = row.PRUF_SE_NO;
		parent.document.getElementById('SUM_AMOUNT').value = row.PRUF_SUM_AMOUNT;
		parent.document.getElementById('SPLPC').value = row.	PRUF_SPLPC;
		parent.document.getElementById('VAT').value = row.PRUF_VAT;
		parent.document.getElementById('EXCUT_REQUST_DE').value  = row.EXCUT_REQUST_DE;
		parent.document.getElementById('BCNC_RPRSNTV_NM').value  = row.BCNC_RPRSNTV_NM;
		parent.document.getElementById('BCNC_LSFT_NO').value  = row.SUPLER_BIZRNO;
		parent.document.getElementById('BCNC_ADRES').value  = row.BCNC_ADRES;
		parent.document.getElementById('BCNC_BIZCND_NM').value  = row.BCNC_BIZCND_NM;
		parent.document.getElementById('BCNC_INDUTY_NM').value  = row.BCNC_INDUTY_NM;
		parent.document.getElementById('BCNC_CMPNY_NM').value  = row.BCNC_CMPNY_NM;
		parent.document.getElementById('TRANSFR_ACNUT_SE_CODE').value  = row.TRANSFR_ACNUT_SE_CODE;
		parent.document.getElementById('invoice_no').html  = row.ETXBL_CONFM_NO;
		parent.document.getElementById('PRUF_SE_NO').value  = row.ETXBL_CONFM_NO;
		
		window.close();	
	}
			
	
}
function fn_closeWindow(){
	window.close();
}
//TRANSFR_ACNUT_SE_CODE
function fn_requestInvoice(){
	var aa = $('#ETXBL_CONFM_NO').val();
	console.log(aa);
		data = {
				BSNSYEAR : $('#BSNSYEAR').val()
				,FILE_ID : ""
				,DDTLBZ_ID : $('#DDTLBZ_ID').val()
				,EXC_INSTT_ID : $('#EXC_INSTT_ID').val()
				//,ETXBL_CONFM_NO : $('#ETXBL_CONFM_NO').val()		
				,ETXBL_CONFM_NO : $('#txtEtxbl').html()
				,EMP_SEQ : $('#empSeq').val()
		}
		$.ajax({
			url : "<c:url value='/kukgoh/requestInvoice' />",
			data : data,
			type : 'POST',
			success : function(result) {
				console.log("팝업 완료");
				if(result.OUT_YN == 'Y'){
					$('#popUp').data("kendoWindow").close();
				}else{
					alert(result.OUT_MSG);
				}
			}	
			});
}

</script>
<script type="text/javascript">	
	$(function() {
		mainGrid();
	});
	function mainGrid(){
		var kukgohInvoiceGrid = $("#kukgohInvoiceGrid").kendoGrid({
			dataSource : kukgohInvoiceGridDataSource,
			dataBound : gridDataBound,
			height : 450,
			sortable : true,
			persistSelection : true,
			selectable : "multiple",
	        columns: [
				{
					field : "WRITNG_DE",
					title : "작성일자",
					width : 100
				},
				{
					field : "ETXBL_KND_NM",
					title : "증빙구분",
					width : 80
				},
				{
					field : "ETXBL_CONFM_NO",
					title : "승인번호",
				},
				{
					field : "SUPLER_CMPNY_NM",
					title : "공급자 상호",
				},
				{
					field : "SUPLER_BIZRNO",
					title : "공급자 사업자번호",
					width : 90
				},{
					field : "PRUF_SUM_AMOUNT",
					title : "합계액",
					width : 100
				},{
					field : "PRUF_SPLPC",
					title : "공급가액",
					width : 100
				},{
					field : "PRUF_VAT",
					title : "부가세액",
					width : 100
				},{
					field : "EXCUT_SUM_AMOUNT",
					title : "증빙사용액",
					width : 100
				},{
					//field : "EXCUT_SUM_AMOUNT",
					title : "선택",
					template : function(dataItem){
					    return '<input type="button" id="" class="text_blue" onclick="fn_invoiceSelect(this);" value="선택">'
					},
					width : 100
				}
				],
	        change: function (e){
	        	insertResolutionMainGridClick(e)
	        }
	    }).data("kendoGrid");
		
		kukgohInvoiceGrid.table.on("click", ".checkbox", selectRow);
		
		var checkedIds = {};
		
		// on click of the checkbox:
		function selectRow(){
			var checked = this.checked,
			row = $(this).closest("tr"),
			grid = $('#kukgohInvoiceGrid').data("kendoGrid"),
			dataItem = grid.dataItem(row);
			
			checkedIds[dataItem.ANNV_USE_ID] = checked;
			if (checked) {
				//-select the row
				row.addClass("k-state-selected");
			} else {
				//-remove selection
				row.removeClass("k-state-selected");
			}
		}
		function insertResolutionMainGridClick(){
		}
		function gridDataBound(){
			
		}
	}
	var kukgohInvoiceGridDataSource = new kendo.data.DataSource({
		serverPaging : true,
		pageSize : 10,
		transport : {
			read : {
				url : _g_contextPath_+"/kukgoh/kukgohInvoiceGrid",
				dataType : "json",
				type : 'post'
			},
			parameterMap : function(data, operation) {
				data.FR_DATE = $('#FR_DATE').val().replace(/\-/g,''); //특정문자 제거
				data.TO_DATE = $('#TO_DATE').val().replace(/\-/g,''); //특정문자 제거
				//data.erpDeptSeq = $("#erpDeptSeq").val();
				data.ETXBL_CONFM_NO = $("#ETXBL_CONFM_NO").val();
				data.SUPLER_CMPNY_NM = $("#SUPLER_CMPNY_NM").val();
				data.SUPLER_BIZRNO =  $("#SUPLER_BIZRNO").val();
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
			model : {
				fields : {
					ANNV_HOLI_STEP_NAME : {
						type : "string"
					},
					code_kr : {
						type : "string"
					}
				}
			}
		}
	});
	function fn_searchBtn(){
		$('#kukgohInvoiceGrid').data('kendoGrid').dataSource.page(1);
	}	
</script>
<body>
<div id="iForm" class="iframe_wrap" style="min-width: 1100px">
	<input type="hidden" id="request_seq"  value="" />
	<input type="hidden" id="loginSeq"  value="${loginSeq }" />
	<input type="hidden" id="BSNSYEAR"  value="${params.BSNSYEAR} " />
	<input type="hidden" id="FILE_ID"  value="${params.FILE_ID}" />
	<input type="text" id="DDTLBZ_ID"  value="${params.DDTLBZ_ID}"/>
	<input type="hidden" id="EXC_INSTT_ID"  value="${params.EXC_INSTT_ID}" />
	<input type="hidden" id="ETXBL_CONFM_NO"  value="${params.ETXBL_CONFM_NO}" />
	<input type="hidden" id="empSeq"  value="" />
	<!-- 컨텐츠타이틀영역 -->
	<div class="sub_title_wrap">
		<div class="title_div">
			<h4>전자(세금)계산서 조회</h4>
		</div>
	</div>

	<div class="sub_contents_wrap">
		<div class="top_box">
			<dl>
				<dt  class="ar" style="width:128px;" >작성일자</dt>
				<dd>
					<input type="text" id="FR_DATE"  value=""  name = "FR_DATE"/> ~ <input type="text" id="TO_DATE"  value=""  name = "TO_DATE"/> 
				</dd>	
				</dl>
			<dl class="next2">
				<dt  class="ar" style="width:128px" >승인번호</dt>
				<dd>
					<input type="text" style="width:160px" id="ETXBL_CONFM_NO" value=''  name = "ETXBL_CONFM_NO"/>
				</dd>	
			</dl>
			<dl class="next2">
				<dt  class="ar" style="width:128px" >공급자 사업자번호</dt>
				<dd>
					<input type="text" style="width:160px" id="SUPLER_BIZRNO" value=''  name = "SUPLER_BIZRNO"/>('-')없이 입력
				</dd>	
			</dl>
			<dl class="next2">
				<dt  class="ar" style="width:128px" >공급자 상호</dt>
				<dd>
					<input type="text" style="width:160px" id="SUPLER_CMPNY_NM" value=''  name = "SUPLER_CMPNY_NM"/>
				</dd>	
				<dd>
					 <input type="button"style="width:160px" id="" onclick="fn_searchBtn();" name = "" value="조회"> <input type="button" style="width:160px" id="insertInvoice" value='전자(세금)계산서 추가'  name = ""/>
				</dd>				
			</dl>			
		</div>
		<!-- 버튼 -->
<!-- 		<div class="btn_div mt10 cl">
			<div class="right_div">
				<div class="controll_btn p0">
					<button id="btnReject" onclick="">데이터 가져오기</button>
					<button id="btnReject">저장</button>
					<button type="button" id="" onclick="">조회</button>
				</div>
			</div>
		</div> -->
		<div class="com_ta2 mt15" >
			<!-- <p class="tit_p mt5 mb0">전자</p> -->
			<div style="width: 1100px;" id="kukgohInvoiceGrid">
			</div>
				<!-- <div id="childDutyMainGrid"></div> -->
		</div>
		<div class="btn_div mt10 cl">
		</div>
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" id="" onclick="fn_closeWindow();" value="닫기">
			</div>
		</div>												
		
	</div>
	<!-- //sub_contents_wrap -->
</div>
<!-- iframe wrap -->
	
<div class="pop_wrap_dir" id="popUp" style="width: 600px;">
	<div class="pop_head">
		<h1>전자(세금)계산서 승인번호 입력</h1>
	</div>
	<div class="pop_con">
		<div class="top_box">
			<dl>
				<dt class="ar" style="width: 200px;">전자(세금)계산서 승인번호 입력</dt>
				<dt class="ar" style="width: 205px;">
					<input type="text" id="ETXBL_CONFM_NO2" style="width: 200px" />
				</dt>
				<dd>
					 <input type="button" onclick="" id="btnGetPrufSeNo" value="확인" />
				</dd>
			</dl>
		</div>
		<div id="divEtxbl" class = "sub_title_wrap" style="height:50px; margin-top:20px;">
			<h3 id="txtEtxbl"></h3>
		</div>
	</div>
	<!-- //pop_con -->

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" class="" id="" value="증빙요청" onclick="fn_requestInvoice();"/>
			<input type="button" class="gray_btn" id="cancle2" value="닫기" />
		</div>
	</div>
	<!-- //pop_foot -->
</div>	
</body>
</html>