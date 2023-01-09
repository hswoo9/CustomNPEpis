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

<!-- 일반 Fn -->
<script type="text/javascript">

	var selectedStatusValue = "2";

	function fn_submitInvoice() {
			
		startLoading();
		
		var paramArray = [];
		
		$(".checkbox:checked").each(function(i, e) {
		    var dataItems = $("#invoiceMainGrid").data("kendoGrid").dataItem($(e).closest("tr"));
		    
			paramArray.push(dataItems);			
		});
		
		if (paramArray.length > 0) {
			
			$.ajax({
				url : "<c:url value='/kukgoh/saveSendingInvoice' />",
				data : { param : JSON.stringify(paramArray) },
				type : 'POST',
				success : function(result) {
					
					$('html').css("cursor", "auto");
			    	$('#loadingPop').data("kendoWindow").close();
					
					if (result.OUT_YN != 'N') {
						alert("전자세금계산서 조회를 요청하였습니다. \n 10 ~ 20분 후 집행전송이 가능합니다.");
					} else {
						alert("비정상 처리");
						alert(result.OUT_YN);
					}
					
					invoiceMainGridReload();
				}	
			});
		} else {
			alert("전송할 데이터가 없습니다.");
		}
	}

	function fn_formatDate(str) {
		return str.substring(0,4) + "-" + str.substring(4,6) + "-" + str.substring(6,8) ;
	}
	
	function fn_formatMoney(str) {
	    str = String(str);
	    return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
	}
	
	function startLoading() {
		
		$('html').css("cursor", "wait");
	   	$('#loadingPop').data("kendoWindow").open();
	   	
	}
</script>

<!-- page Init -->
<script type="text/javascript">
	$(document).ready(function() {
		
		$('#loadingPop').parent().find('.k-window-action').css("visibility", "hidden");
		$('#loadingPop').kendoWindow({
		     width: "443px",
		     visible: false,
		     modal: true,
		     actions: [],
		     close: false
		 }).data("kendoWindow").center();
		
	    $("#endMonth").kendoDatePicker({
	        start: "date",
	        depth: "date",
	        format: "yyyy-MM-dd",
			parseFormats : ["yyyy-MM-dd"],
	        culture : "ko-KR",
	        dateInput: true
	    });
		
	    $("#endMonth").val( '${year}' +"-"+ '${mm}');		
		//날짜 초기화----->>
	    $("#fromMonth").kendoDatePicker({
	        start: "date",
	        depth: "date",
	        format: "yyyy-MM-dd",
			parseFormats : ["yyyy-MM-dd"],
	        culture : "ko-KR",
	        dateInput: true
	    });	  
	    
	    var dd = '${dd}';
	    var mm = '${mm}';
	    var year = '${year}';
	    
	    var nowDate = new Date(year, mm, dd);
	    var preDate = new Date();
	    preDate.setDate(nowDate.getDate() - 7);
	    
	    $("#endMonth").val( year + '-' + mm + '-' + dd );
	    $("#fromMonth").val( preDate.getFullYear() + '-' + ("0" + (preDate.getMonth() + 1)).slice(-2) + '-' + ("0" + preDate.getDate()).slice(-2) );
	    
	    $("#status").kendoComboBox({
			dataSource: [
				{text : "전체", value : "9"}
				,{text : "전송진행중", value : "2"}
		      	,{text : "전송완료", value : "1",}
		    	,{text : "미전송", value : "0"}
		      ],
		      dataTextField: "text",
		      dataValueField: "value",
		      index: 2,
		      select : onSelect
		});
	    
	    $(document).on("click", "#invoiceMainGrid tbody tr", function(e) {
			row = $(this)
			grid = $('#invoiceMainGrid').data("kendoGrid"),
			dataItem = grid.dataItem(row);
			
			console.log(dataItem);	
		})
	    
        function onSelect(e) {
    		var dataItem = this.dataItem(e.item.index());
    		
     	}
	    
	    /* -------------------- 이벤트 모음 -------------------- */
	    
	 	// 체크박스 전체선택
	 	$(document).on("click", "#checkboxAll", function(e) {
	 		
	 		e.stopImmediatePropagation();
	 		
	 		if ($("#checkboxAll").is(":checked")) {
	            $(".yBox").prop("checked", true);
	         } else {
	            $(".checkbox").prop("checked", false);
	         }	 		
	 	});
	    
	    // 체크박스 선택
	    $(document).on("click", ".checkbox", function(e) {
	    	
	    	var rowData = $('#invoiceMainGrid').data("kendoGrid").dataItem($(this).closest("tr"));
	    	
	    	if (rowData.STATE_NM === "전송완료") {
	    		alert("이미 전송완료된 건 입니다.");
	    		$(this).prop("checked", false);
	    		return;
	    	} else if (rowData.ET_STATE === "N") {
	    		alert("전송 불가한 데이터 입니다.");
	    		$(this).prop("checked", false);
	    	}
	    });
	});
</script>

<!-- 메인그리드 -->
<script type="text/javascript">	
	$(function() {
		mainGrid();
	});
	
	function mainGrid(){
		
		var invoiceMainGrid = $("#invoiceMainGrid").kendoGrid({
			dataSource : invoiceMainGridDataSource,
			dataBound : gridDataBound,
			height : 450,
			sortable : true,
			persistSelection : true,
			selectable : "multiple",
	        columns: [
	        	{
	                width : "30px",
	                headerTemplate : function(e){
	                   return '<input type="checkbox" id = "checkboxAll">';
	                },
	                template : function(dataItem){
						if (dataItem.STATE_NM === "전송완료" || dataItem.STATE_NM === "전송진행중" || dataItem.ET_STATE === 'N') {
							return '';							
						} else {
							return '<input type="checkbox" class = "checkbox yBox">';
						}                	
	                }
	             },
	             {
	            	field : "STATE_NM",
					title : "상태",
					width : 60 
	             },
				{
					field : "EMP_NM",
					title : "발의자",
					width : 60
				},
				{
					template : function(dataItem){
						return fn_formatDate(dataItem.GISU_DT);
					},					
					title : "발의일자",
					width : 80
				},	{
					field : "GISU_SQ",
					title : "결의번호",
					width : 60
				},
				{
					field : "BG_SQ",
					title : "예산번호",
					width : 60
				},
				{
					field : "LN_SQ",
					title : "거래처순번",
					width : 60
				},
				{
					field : "RMK_DC",
					title : "제목",
					width : 80
				},
				{
					field : "DIV_NM",
					title : "회계단위",
					width : 80
				},{
					field : "PJT_NM",
					title : "프로젝트",
					width : 90
				},{
					template : function(dataItem) {
						return fn_formatMoney(dataItem.AMT);
					},
					//field : "AMT",
					title : "금액",
					width : 70
				},
				{
					field : "CUST_NM",
					title : "거래처",
					width : 60
				},
				{
					field : "ETXBL_CONFM_NO",
					title : "전자세금계산서 승인번호",
					width : 130
				},{
					field : "DDTLBZ_ID",
					title : "E나라도움 연계 사업ID",
					width : 100
				},{
					field : "ET_STATE",
					title : "전송 가능 여부",
					width : 70
				}],
	        change: function (e){
	        	invoiceMainGridClick(e)
	        }
	    }).data("kendoGrid");
		
		invoiceMainGrid.table.on("click", ".checkbox", selectRow);
		
		var checkedIds = {};
		
		// on click of the checkbox:
		function selectRow(){
			var checked = this.checked;
			row = $(this).closest("tr");
			grid = $('#invoiceMainGrid').data("kendoGrid");
			var dataItem = grid.dataItem(row);
			
			console.log(dataItem);
			
			checkedIds[dataItem.ANNV_USE_ID] = checked;
			if (checked) {
				//-select the row
				row.addClass("k-state-selected");
			} else {
				//-remove selection
				row.removeClass("k-state-selected");
			}
		}
		
		function invoiceMainGridClick(e){
			var row = e.sender.select();
			var grid = $('#invoiceMainGrid').data("kendoGrid");
			var rowData = grid.dataItem(row);
			console.log(rowData);
		}
		
		function gridDataBound(e) {
			var grid = e.sender;
			
			if (grid.dataSource.total() == 0) {
				var colCount = grid.columns.length;
				$(e.sender.wrapper).find('tbody').append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
			}
		}
	}
	function invoiceMainGridReload(){
		$("#invoiceMainGrid").data("kendoGrid").dataSource.read();
	}
	
	var invoiceMainGridDataSource = new kendo.data.DataSource({
		serverPaging : true,
		pageSize : 10,
		transport : {
			read : {
				url : _g_contextPath_+"/kukgoh/sendInvoiceMainGrid",
				dataType : "json",
				type : 'post'
			},
			parameterMap : function(data, operation) {
				data.fromMonth = $('#fromMonth').val().replace(/\-/g,''); //특정문자 제거
				data.endMonth = $('#endMonth').val().replace(/\-/g,''); //특정문자 제거
				return data;
			}
		},
		schema : {
			data : function(response) {
				
				var result = [];
				
				var num = $("#status").data("kendoComboBox").value();
				
				switch (num) {
				
				case "9":
					response.list.forEach(function(v, i) {
						
						result.push(v);
					});
					break;
					
				case "1":
					response.list.forEach(function(v, i) {
						
						if (v.STATE_NM === '전송완료') {
							result.push(v);
						}
					});
					break;
					
				case "2":
					response.list.forEach(function(v, i) {
						
						if (v.STATE_NM === '전송진행중') {
							result.push(v);
						}
					});
					break;
				case "0":
					response.list.forEach(function(v, i) {
						
						if (v.STATE_NM === '전송실패' || v.STATE_NM === '미전송') {
							result.push(v);
						}
					});
					break;
				}
				
				return result;
			},
			total : function(response) {
				return response.total;
			},
			model : {
				fields : {
				}
			}
		}
	});
	
	function fn_searchBtn(){
		$('#invoiceMainGrid').data('kendoGrid').dataSource.page(1);
	}
	
	</script>

	<div class="iframe_wrap" style="min-width: 1070px;">
		<div class="sub_title_wrap">
			<div class="title_div">
				<h4>지출결의서 집행전송</h4>
			</div>
			<div class="sub_contents_wrap">
				<p class="tit_p mt5 mt20">전자세금계산서 일괄 전송</p>
					<div class="top_box">
						<dl>
							<dt  class="ar" style="width:70px;" >발의 기간</dt>
							<dd>
								<input type="text" id="fromMonth" />
								<span>~</span>
								<input type="text" id="endMonth" />
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
								<button type="button" id="searchBtn" onclick="fn_submitInvoice();">전송</button>
								<button type="button" id="searchBtn" onclick="fn_searchBtn();">조회</button>
							</div>
						</div>
					</div>
					<div>
					</div>
					<div class="com_ta2 mt15" >
					    <div id="invoiceMainGrid"></div>
					</div>		
			</div>
		</div>
	</div>
	<div class="pop_wrap_dir" id="loadingPop" style="width: 443px;">
	<div class="pop_con">
		<table class="fwb ac" style="width:100%;">
			<tr>
				<td>
					<span class=""><img src="<c:url value='/Images/ico/loading.gif'/>" alt="" />  &nbsp;&nbsp;&nbsp;세금계산서 전송 진행 중입니다.  </span>		
				</td>
			</tr>
		</table>
	</div>
</div>
	
</body>
</html>