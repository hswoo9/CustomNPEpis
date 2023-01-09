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

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
</head>
<style type="text/css">
.k-header .k-link {
	text-align: center;
}

.k-grid-content>table>tbody>tr {
	text-align: center;
}

.k-grid th.k-header, .k-grid-header {
	background: #F0F6FD;
}
.customer-photo{
	width : 70px;
	height : auto;
}
</style>

<body>
	<input type="hidden" id="nowMonth" value="${year}${mm}" />
	
	<input type="hidden" id="dayOrTimeGubun" value="0" />
	
<script type="text/javascript">
	$(document).ready(function() {
	    $("#endMonth").kendoDatePicker({
	        start: "year",
	        depth: "year",
	        format: "yyyy-MM",
			parseFormats : ["yyyy-MM"],
	        culture : "ko-KR",
	        dateInput: true
	    });
	    $("#endMonth").val( '${year}' +"-"+ '${mm}');		
		//날짜 초기화----->>
	    $("#fromMonth").kendoDatePicker({
	        start: "year",
	        depth: "year",
	        format: "yyyy-MM",
			parseFormats : ["yyyy-MM"],
	        culture : "ko-KR",
	        dateInput: true
	    });	  
	    var mm = '${mm}';
	    var year = '${year}';
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
	    $("#fromMonth").val(year+"-"+mm);

	  //-----<<날짜 초기화
 	 //사원정보 팝업 초기화----->>
	    $("#empSearch").click(function(){	
	    	 $('#emp_name').val("");
	    	 $("#empPopUp").data("kendoWindow").open();
	    	 empGridReload();
		 });
	    
		 //팝업 초기화
		 $("#empPopUp").kendoWindow({
		     width: "600px",
		    height: "750px",
		     visible: false,
		     actions: ["Close"]
		 }).data("kendoWindow").center();
	     function empPopUpClose(){
	    	 $("#empPopUp").data("kendoWindow").close();
	     }
		 $("#empPopUpCancel").click(function(){
			 $("#empPopUp").data("kendoWindow").close();
		 });
	  //-----<<사원정보 팝업 초기화
	  
		$("#status").kendoComboBox({
			dataSource: [
				{text : "전체", value : "9"}
		      	,{text : "전송", value : "1",}
		    	,{text : "미전송", value : "0"}
		      ],
		      dataTextField: "text",
		      dataValueField: "value",
		      index: 2,
		      select : onSelect
		});
        function onSelect(e) {
    		var dataItem = this.dataItem(e.item.index());
    		//$('#retireeYnVal').val(dataItem.value);
     	}		

    	$('#popUp').kendoWindow({
    		width : "1000px",
    		height : "450px",
    		visible : false,
    		modal : true,
    		actions : [ "Close" ],
    	}).data("kendoWindow").center();
    	$('#popUp').on('keypress', function(e) {
    		if (e.key == 'Enter') {
    			//empGridReload();
    		};
    	}); 
    	
    	$("#btnGetPrufSeNo").on("click", function(){
    		var aa = $('#ETXBL_CONFM_NO2').val();
    		
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
    	
    	$('#cancle2').on('click', function (){
    		$('#popUp').data('kendoWindow').close();
    	});
	});
</script>

<script type="text/javascript">

function fn_openSubmitPage(e){
	var dataItem = $("#insertResolutionMainGrid").data("kendoGrid").dataItem($(e).closest("tr"));	
	console.log(dataItem);
	window.open("", "pop", "menubar=no,width=1800,height=900,toolbar=no, scrollbars=yes");
	$('#submitData').val(JSON.stringify(dataItem));
	
	document.submitPage.action = _g_contextPath_+"/kukgoh/resolutionSubmitPage";
	document.submitPage.target = "pop";
	document.submitPage.method = "post";
	document.submitPage.submit();
}

function fn_formatDate(str){
	return str.substring(0,4) + "-" + str.substring(4,6) + "-" + str.substring(6,8) ;
}
function fn_formatMoney(str){
        str = String(str);
        return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
}

function fn_requestInvoice(e, LN_SQ){
	
		data = {
				CO_CD : $('#CO_CD').val()
				,GISU_DT : $('#GISU_DT').val()
				,GISU_SQ : $('#GISU_SQ').val()
				,BG_SQ : $('#BG_SQ').val()
				,LN_SQ : LN_SQ
				,BSNSYEAR : $('#BSNSYEAR').val()
				,FILE_ID : ""
				,DDTLBZ_ID : $('#DDTLBZ_ID').val()
				,EXC_INSTT_ID : $('#EXC_INSTT_ID').val()
				//,ETXBL_CONFM_NO : $('#ETXBL_CONFM_NO').val()		
				,ETXBL_CONFM_NO : $('#'+e).val()
				,EMP_SEQ : $('#empSeq').val()
		}
		
		$.ajax({
			url : "<c:url value='/kukgoh/requestInvoice' />",
			data : data,
			type : 'POST',
			success : function(result) {
				//console.log("팝업 완료");
				if(result.OUT_YN == 'Y'){
					//$('#popUp').data("kendoWindow").close();
					alert("전자세금계산서 조회를 요청하였습니다. \n 10 ~ 20분 후 집행전송이 가능합니다.");
					$('#'+e).css('background-color','#c7c5c5');
					$('#popUp').data('kendoWindow').close();
					$('#btn'+LN_SQ).val("설정있음");

				}else{
					alert(result.OUT_MSG);
					$('#btn'+LN_SQ).attr("disabled", false);
				}
				fn_searchBtn();
			}	
			});
		
}

function fn_openInvoicePage(e){
	var row = $(e).closest("tr");
	var grid = $('#insertResolutionMainGrid').data("kendoGrid");
	var data = grid.dataItem(row);
	
	$('#BSNSYEAR').val(data.BSNSYEAR);
	$('#DDTLBZ_ID').val(data.DDTLBZ_ID);
	$('#EXC_INSTT_ID').val(data.EXC_INSTT_ID);
	$('#C_DIKEYCODE').val(data.C_DIKEYCODE);
	$('#GISU_DT').val(data.GISU_DT);
	$('#GISU_SQ').val(data.GISU_SQ);
	$("#BG_SQ").val(data.BG_SQ);
	$('#CO_CD').val(data.CO_CD);
	
	$('#popUp').data('kendoWindow').open();
	invoiceMainGrid();
}

function fn_validInvoice(e){ // 전자(세금) 계산서 전송
	
	$(e).attr("disabled", true);
	var idSeq = e.id.replace("btn", "");
	
	data = {
			ETXBL_CONFM_NO : $('#txtInvoice1').val()	
			,OUT_YN : '1'
			,OUT_MSG : '1'
	}
	
	$.ajax({
		url : "<c:url value='/kukgoh/invoiceValidation' />",
		data : data,
		type : 'POST',
		success : function(result) {
			console.log(result);
			
			if (result.OUT_YN == 'Y'){
				fn_requestInvoice("txtInvoice" + idSeq, idSeq);
			} else {
				alert(result.OUT_MSG);
				$('#btn'+idSeq).attr("disabled", false);
			}
		}	
	});
}
</script>
	<!-- 사원팝업 ajax -->
	
	<!-- emp 그리드 -->
<script type="text/javascript">
$(function() {
	empGrid();
});
	//사원팝업 ajax
	var empDataSource = new kendo.data.DataSource({
		serverPaging: true,
		pageSize: 10,
	    transport: { 
	        read:  {
	            url: _g_contextPath_+'/common/empInformation',
	            dataType: "json",
	            type: 'post'
	        },
	      	parameterMap: function(data, operation){
	        	data.emp_name = $('#emp_name').val();
	        	data.deptSeq = $('#deptSeq').val();
	        	console.log(data.deptSeq + "!!");
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
	});

	function empGridReload(){
		$('#empGrid').data('kendoGrid').dataSource.read();
	}
	
	function empGrid(){		
		//사원 팝업그리드 초기화
		var grid = $("#empGrid").kendoGrid({
	        dataSource: empDataSource,
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
	        		    }],
	        change: function (e){
	        	codeGridClick(e)
	        }
	    }).data("kendoGrid");
		
		grid.table.on("click", ".checkbox", selectRow);
		
		var checkedIds = {};
		
		//on click of the checkbox:
		function selectRow(){
			
			var checked = this.checked,
			row = $(this).closest("tr"),
			grid = $('#empGrid').data("kendoGrid"),
			dataItem = grid.dataItem(row);
			
			checkedIds[dataItem.CODE_CD] = checked;
			if (checked) {
				//-select the row
				row.addClass("k-state-selected");
			} else {
				//-remove selection
				row.removeClass("k-state-selected");
			}
		}
		//사원팝업 grid 클릭이벤트
		function codeGridClick(){			
			var rows = grid.select();
			var record;
			rows.each( function(){
				record = grid.dataItem($(this));
				console.log(record);
			}); 
			subReload(record);
		}
	}

	function subReload(record){
		$('#keyId').val(record.if_info_system_id);
	} 

	//선택 클릭이벤트
	function empSelect(e){		
		var row = $("#empGrid").data("kendoGrid").dataItem($(e).closest("tr"));
		$('#deptNm').val(row.dept_name);
		$('#deptSeq').val(row.dept_seq);
		$('#selectedEmpName').val(row.emp_name);
		$('#loginSeq').val(row.emp_seq);
		$('#erpEmpSeq').val(row.erp_emp_num);
		var empWindow = $("#empPopUp");		
		empWindow.data("kendoWindow").close();
	}
</script>
	<!-- 메인그리드 -->
<script type="text/javascript">	
	$(function() {
		mainGrid();
	});
	function mainGrid(){
		var insertResolutionMainGrid = $("#insertResolutionMainGrid").kendoGrid({
			dataSource : insertResolutionMainGridDataSource,
			dataBound : gridDataBound,
			height : 450,
			sortable : true,
			persistSelection : true,
			selectable : "multiple",
	        columns: [
				{
					field : "KOR_NM",
					title : "발의자",
					width : 60
				},
				{
					//field : "GISU_DT",
					template : function(dataItem){
						return fn_formatDate(dataItem.GISU_DT);
					},					
					title : "발의일자",
					width : 80
				},
				{
					//field : "DOC_NUMBER",
					template : function(dataItem){
						return "<a href='javascript:fn_docViewPop("+dataItem.C_DIKEYCODE+");' style='color: rgb(0, 51, 255);'>"+dataItem.DOC_NUMBER+"</a>";;
						
					},
					title : "문서번호",
					width : 105
				},
				{
					//field : "DOC_REGDATE",
					template : function(dataItem){
						return fn_formatDate(dataItem.DOC_REGDATE);
					},
					title : "결재일자",
					width : 80
				},
				{
					field : "DOC_TITLE",
					title : "제목",
					//width : 90
				},{
					field : "DIV_NM",
					title : "회계단위",
					width : 70
				},{
					field : "PJT_NM",
					title : "프로젝트",
					width : 100
				},{
					field : "ABGT_NM",
					title : "예산과목",
					width : 100
				},{
					//field : "UNIT_AM",
					template : function(dataItem){
						return fn_formatMoney(dataItem.UNIT_AM);
					},					
					title : "금액",
					width : 100
				},{
					field : "SET_FG_NM",
					title : "결제수단",
					width : 70
				},{
					field : "VAT_FG_NM",
					title : "과세구분",
					width : 70
				},{
					template : function(dataItem){
						if((dataItem.SET_FG == '4')){
							return '';
						}else{
							return '<input type="button" id="" class="text_blue" onclick="fn_openInvoicePage(this);"value="'+dataItem.ETXBL_CONFM_NO+'"/>';
						}
					},		
					title : "전자(세금)계산서",
					width : 110
				},{
					field : "KUKGO_STATE",
					title : "상태",
					width : 60
				},{
					template : function(dataItem){
						if(dataItem.KUKGO_STATE_YN == 'Y'){
							return '<input type="button" id="" class="text_blue" onclick="fn_openSubmitPage(this);"value="확인"/>';
						}else{
							return '<input type="button" id="" class="text_blue" onclick="fn_openSubmitPage(this);"value="전송"/>';
						}
							
					},
					title : "전송",
					width : 60
				}],
	        change: function (e){
	        	insertResolutionMainGridClick(e)
	        }
	    }).data("kendoGrid");
		
		insertResolutionMainGrid.table.on("click", ".checkbox", selectRow);
		
		var checkedIds = {};
		
		// 체크박스 전체선택
		$("#checkboxAll").click(function(e) {
			
	         if ($("#checkboxAll").is(":checked")) {
	            $(".checkbox").prop("checked", true);
	         } else {
	            $(".checkbox").prop("checked", false);
	         }
	      });
		
		// on click of the checkbox:
		function selectRow(){
			var checked = this.checked,
			row = $(this).closest("tr"),
			grid = $('#insertResolutionMainGrid').data("kendoGrid"),
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
		
		function insertResolutionMainGridClick(e){
			
			grid = $('#insertResolutionMainGrid').data("kendoGrid"),
			dataItem = grid.dataItem(e.sender.select());
			
			console.log(dataItem);
		}
		
		function gridDataBound(){
			
		}
	}
	
	var insertResolutionMainGridDataSource = new kendo.data.DataSource({
		serverPaging : true,
		pageSize : 10,
		transport : {
			read : {
				url : _g_contextPath_+"/kukgoh/insertResolutionMainGrid",
				dataType : "json",
				type : 'post'
			},
			parameterMap : function(data, operation) {
				data.fromMonth = $('#fromMonth').val().replace(/\-/g,''); //특정문자 제거
				data.endMonth = $('#endMonth').val().replace(/\-/g,''); //특정문자 제거
				data.erpDeptSeq = $("#erpEmpSeq").val() === '1610011068' ? '2100' : $('#g20DeptSeq').val();
				data.erpEmpSeq = $("#erpEmpSeq").val() === '1610011068' ? '' : $("#erpEmpSeq").val();
				data.status = $("#status").data('kendoComboBox').value();
				return data;
			}
		},
		schema : {
			data : function(response) {
				console.log("=== MAIN ===");
				console.log(response);
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
		$('#insertResolutionMainGrid').data('kendoGrid').dataSource.page(1);
	}
	</script>
	
<!-- 전자세금계산서 호출 -->
<script type="text/javascript">
function invoiceMainGrid(){
	var kukgohInvoiceInsertGrid = $("#kukgohInvoiceInsertGrid").kendoGrid({
		dataSource : kukgohInvoiceInsertGridDataSource,
		dataBound : invoiceGridDataBound,
		height : 250,
		sortable : true,
		persistSelection : true,
		selectable : "multiple",
        columns: [
			{
				field : "TR_NM",
				title : "거래처명",
				width : 100
			},{
				field : "BCNC_LSFT_NO",
				title : "사업자번호",
				width : 80
			},{
				template : function(dataItem){
					return fn_formatMoney(dataItem.UNIT_AM)
				},
				title : "합계금액",
				width : 80
			},{
				template : function(dataItem){
					return fn_formatMoney(dataItem.SUP_AM)
				},
				title : "공급가",
				width : 80
			},{
				template : function(dataItem){
					return fn_formatMoney(dataItem.VAT_AM)
				},
				title : "부가세",
				width : 80
			},{
				template : function  (dataItem){
					var 	result 	= '<input type="text" id="';
							result += 'txtInvoice'+dataItem.LN_SQ;
							result += '" class="" style="width:180px;"';
							
					var btnHtml = "";

					 if (dataItem.ETXBL_CONFM_NO == '' || dataItem.ETXBL_CONFM_NO == null) {
						result += ' />';
						btnHtml +=	'<input type="button" id="btn'+dataItem.LN_SQ+'" class="text_blue"  style="width:50px;" onclick="fn_validInvoice(this)" value="전송"/>';
						return result + btnHtml;
					} else {
						result += 'value="' + dataItem.ETXBL_CONFM_NO + '" style="background-color : #c7c5c5;" ';
						
	         			if (dataItem.KUKGO_STATE_YN == "Y") {
	         				result += "disabled  />";
	         				btnHtml +=	'<input type="button" id="btn'+dataItem.LN_SQ+'" class="text_blue"  style="width:50px;" onclick="fn_validInvoice(this)" value="전송완료" disabled/>';
	         			} else {
	         				
	         				if (dataItem.sended === 'Y') {
	         					result += "disabled  />";
	         					btnHtml +=	'<input type="button" id="btn'+dataItem.LN_SQ+'" class="text_blue"  style="width:50px;" onclick="fn_validInvoice(this)" value="전송완료" disabled />';	         					
	         				} else {
	         					result += "/>";
	         					btnHtml +=	'<input type="button" id="btn'+dataItem.LN_SQ+'" class="text_blue"  style="width:50px;" onclick="fn_validInvoice(this)" value="전송" />';	         					
	         				}
	         			}
						
						return result + btnHtml;
					} 
			},
				title : "전자(세금)계산서 번호",
				width : 250
			},
			{
				field : "PROCESS_RESULT_MSSAGE",
				title : "전송결과",
				width : 80
			}
			],
        change: function (e){
        	invoiceGridClick(e)
        }
    }).data("kendoGrid");
	
	kukgohInvoiceInsertGrid.table.on("click", ".checkbox", selectRow);
	
	var checkedIds = {};
	
	// on click of the checkbox:
	function selectRow(){
		var checked = this.checked,
		row = $(this).closest("tr"),
		grid = $('#invoiceGrid').data("kendoGrid"),
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
	function invoiceGridClick(e){
		var dataItem = e.sender;
		console.log(dataItem);
	}
	function invoiceGridDataBound(e) {
		var grid = e.sender;
		if (grid.dataSource.total() == 0) {
			var colCount = grid.columns.length;
			$(e.sender.wrapper).find('tbody').append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
		}
	}
}
var kukgohInvoiceInsertGridDataSource = new kendo.data.DataSource({
	serverPaging : true,
	pageSize : 10,
	transport : {
		read : {
			url : _g_contextPath_+"/kukgoh/kukgohInvoiceInsertGrid",
			dataType : "json",
			type : 'post'
		},
		parameterMap : function(data, operation) {
			data.C_DIKEYCODE = $("#C_DIKEYCODE").val().replace(/\-/g, '');
			data.CO_CD =  $('#CO_CD').val().replace(/\-/g,''); 
			data.GISU_DT = $('#GISU_DT').val().replace(/\-/g,'');
			data.GISU_SQ = $('#GISU_SQ').val().replace(/\-/g,'');
			data.BG_SQ = $("#BG_SQ").val();
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



</script>

<!--  커스텀 function -->
<script type="text/javascript">

	function fn_sendInvoiceBatch() {
		
	}
	
	function fn_sendAccountBatch() {
		
	}
</script>

	<div class="iframe_wrap" style="min-width: 1070px;">
		<div class="sub_title_wrap">
			<div class="title_div">
				<h4>지출결의서 집행전송</h4>
			</div>
			<div class="sub_contents_wrap">
				<p class="tit_p mt5 mt20">지출결의서 집행전송</p>
					<div class="top_box">
						<dl>
							<dt  class="ar" style="width:40px;" >기간</dt>
							<dd>
								<input type="text" id="fromMonth" />
								<span>~</span>
								<input type="text" id="endMonth" />
							</dd>	
							<dt  class="ar" style="width:65px" >발의부서</dt>
							<dd>
								<input type="text" id="deptNm" value='${deptNm}'disabled="disabled"/>
								<input type="hidden" id="deptSeq" value='${requestDeptSeq}'/>
							</dd>					
						    <dt  class="ar" style="width:30px" >성명</dt>
						    <dd  class="ar">
						    	<input type="text" id="selectedEmpName" name="selectedEmpName" value="${empName}" disabled="disabled" style="width:150px;">
						    	<input type="hidden" id="loginSeq" name=""value="${empSeq}"/>
						    	<input type="hidden" id="CO_CD"  />
						    	<input type="hidden" id="erpDeptSeq" name="erpDeptSeq"value="${erpDeptSeq}"/>
						    	<input type="hidden" id="erpEmpSeq" name="erpEmpSeq"value="${erpEmpSeq}"/>
						    </dd>
						    <dd>
								<input type="button" id="empSearch" value="선택" />						
							</dd>
							<dt  class="ar" style="width:65px" >전송상태</dt>
							<dd>
								<input type="text" id="status" />
							</dd>
						</dl>
					</div>
					<div class="btn_div">	
						<div class="right_div">
							<div class="controll_btn p0">
								<!-- <button type="button" id="searchBtn" onclick="fn_sendAcountBatch();">집행정보 일괄전송</button>
								<button type="button" id="searchBtn" onclick="fn_sendInvoiceBatch();">세금계산서 일괄전송</button> -->
								<button type="button" id="searchBtn" onclick="fn_searchBtn();">조회</button>
							</div>
						</div>
					</div>
					<div>
					</div>
					<div class="com_ta2 mt15">
					    <div id="insertResolutionMainGrid"></div>
					</div>		
			</div>
		</div>
	</div>
	
	
	<!-- 사원검색팝업 -->
	<div class="pop_wrap_dir" id="empPopUp" style="width:600px;">
		<div class="pop_head">
			<h1>사원 선택</h1>
		</div>
		<div class="pop_con">
			<div class="top_box">
				<dl>
					<dt class="ar" style="width: 65px;">성명</dt>
					<dd>
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
		</div><!-- //pop_con -->

		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" class="gray_btn" id="empPopUpCancel" value="닫기" />
			</div>
		</div><!-- //pop_foot -->
	</div><!-- //pop_wrap -->	
	<div>
		<form id="submitPage" name="submitPage" action="/CustomNPEPIS/kukgoh/resolutionSubmitPage" method="POST">
			 <input type="hidden" id="submitData" name = "submitData" value=""/> 
		</form>
	</div>	
	
<div class="pop_wrap_dir" id="popUp" style="width: 1000px;">
	<div class="pop_head">
		<h1>전자(세금)계산서 승인번호 입력</h1>
	</div>
	<div class="pop_con">
			<p class="tit_p mt5 mt20">전자(세금)계산서는 승인번호 전송 기준 10분~20분 후 e나라도움 연계 집행전송이 가능합니다</p>
	
			<div class="com_ta mt15" style="">
					<input type="hidden" id="BSNSYEAR"  />
					<input type="hidden" id="DDTLBZ_ID"  />
					<input type="hidden" id="EXC_INSTT_ID"  />
					<input type="hidden" id="C_DIKEYCODE" />				
					<input type="hidden" id="GISU_DT"  />
					<input type="hidden" id="GISU_SQ"  />
					<input type="hidden" id="BG_SQ"  />
				<div id="kukgohInvoiceInsertGrid"></div>
			</div>		
	</div>
	<!-- //pop_con -->

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" class="gray_btn" id="cancle2" value="닫기" />
		</div>
	</div>
	<!-- //pop_foot -->
</div>			
</body>
</html>