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
dt {	text-align : left; 	width : 10%; }
dd {	width: 11.5%; } 
dd input { 	width : 80%; }
.k-grid-toolbar { float : right; }
.blueColor { color : blue; }
.onFont { font-weight : bold; color : green; }
.cursor-pointer { cursor : pointer }
</style>
<body>

<script type="text/javascript">

var init = {
		eventListener : function() { // 이벤트 리스너
			
			$(document).on('keyup', '#rmkDc', function(e) {
				if (e.keyCode === 13) {
					mainGrid();
				}
			});
			
			$(document).on("mouseover", ".docTitle", function() {
				$(this).removeClass("blueColor").addClass("onFont");
			});
			
			$(document).on("mouseout", ".docTitle", function() {
				$(this).removeClass("onFont").addClass("blueColor");
			});
			
			$("#empSearch").click(function(){	
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
			})
		},
		
		gridEvent : function() {
			
			allDept.unshift({dept_name : "전체", dept_seq : ""});
			
			$("#deptCombo").kendoComboBox({
			      dataSource: allDept,
			      dataTextField: "dept_name",
				  dataValueField: "dept_seq",
				  select : onDeptSeqSelect,
				  index: 0,
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
			
			$("#empPopUp").kendoWindow({
			    width: "600px",
			   height: "750px",
			    visible: false,
			    actions: ["Close"]
			}).data("kendoWindow").center();
		}
	}

</script>

<script type="text/javascript">

$(function(){
	
	init.eventListener();
	init.gridEvent();
	
	//mainGrid();
	empGrid();
	
});

var allDept = JSON.parse('${allDept}'); // 부서 목록
var $voucherRowData;
var $flag;
var $dataSource = new kendo.data.DataSource({		//그리드데이터소스
	serverPaging : true,
	pageSize : 1000,
	transport : {
		read : {
			url : _g_contextPath_+ "/budget/expenditureResolutionStatusList",
			dataType : "json",
			type : "post"
		},
		parameterMap: function(data, operation) {
			
			data.fromMonth 	= $("#from_period").val().replace(/-/gi,"");
			data.toMonth 		= $("#to_period").val().replace(/-/gi,"");
			data.erpEmpSeq 	= $("#erpEmpSeq").val();
			data.deptSeq 		= $("#deptCombo").data("kendoComboBox").value();
			data.rmkDc 			= $("#rmkDc").val();
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

	function mainGrid(){
		
		var grid =  $("#grid").kendoGrid({
			toolbar : [	{	name : "excel", 	text : "Excel" 	}],
			excel : { fileName : '지출결의서 현황.xlsx'	 },
			dataSource: $dataSource,
			height : 700,
			dataBound : dataBound,
			selectable : "row",
			sortable : true,
			persistSelection : true,
			columns : [
				{
					width : 15,
					field : "KOR_NM",
					title : "발의자"
				},
				{
					template : function(dataItem) {
						return fn_formatDate(dataItem.GISU_DT);
					},
					width : 15,
					title : "발의일자"
				},
				{
					width : 10,
					field : "GISU_SQ",
					title : "결의번호"
				},
				{
					template : function(dataItem) {
						return "<span class='blueColor docTitle' onclick='fn_docViewPop(" + dataItem.C_DIKEYCODE + ")'>" + dataItem.DOC_NUMBER + "</span>";
					},
					width : 25,
					title : "문서번호"
				},
				{
					template : function(dataItem) {
						return fn_formatDate(dataItem.DOC_REGDATE);
					},
					width : 12,
					title : "결재일자"
				},
				{
					template : function(dataItem) {
						return "<span class='blueColor docTitle' onclick='fn_docViewPop(" + dataItem.C_DIKEYCODE + ")'>" + dataItem.DOC_TITLE + "</span>";
					},
					width : 23,
					title : "제목"
				},
				{
					width : 15,
					field : "DIV_NM",
					title : "회계단위"
				},
				{
					width : 18,
					field : "PJT_NM",
					title : "프로젝트"
				},
				{
					width : 20,
					field : "ABGT_NM",
					title : "예산과목"
				},
				{
					template : function(dataItem) {
						return fn_formatMoney(dataItem.UNIT_AM);
					},
					width : 15,
					title : "금액"
				},
				{
					width : 15,
					field : "SET_FG_NM",
					title : "결제수단"
				},
				{
					width : 12,
					field : "VAT_FG_NM",
					title : "과세구분"
				},
				{
					width : 15,
					field : "STATE_NM",
					title : "상태"
				},
				{
					template : function(dataItem) {
						return '<input type="button" class="blue_btn" value="보기" onclick = "resolutionViewOpen(this)">';
					},
					width : 12,
					title : "지출결의"
				},
				{
					field : 'ENARA_STATUS',
					width : 17,
					title : "E나라 전송상태"
				},
				],
			change : selectRow
	
		}).data("kendoGrid");
		
		function selectRow(e){		//row클릭시 data 전역변수 처리
	
			row = e.sender.select();
			grid = $('#grid').data("kendoGrid");
			data = grid.dataItem(row);
			$rowData = data;
			
		}
		
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
	      		data.emp_name = $("#emp_name").val();
	        	data.deptSeq = $("#deptCombo").data("kendoComboBox").value();
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
		$('#empGrid').data('kendoGrid').dataSource.read(0);
	}
	
	function empGrid(){		
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
	        		    }]
	    }).data("kendoGrid");
	}

	//선택 클릭이벤트
	function empSelect(e){		
		var row = $("#empGrid").data("kendoGrid").dataItem($(e).closest("tr"));
		
		console.log(row);
		
		$('#selectedEmpName').val(row.emp_name);
		$("#erpEmpSeq").val(row.erp_emp_num);
		
		$("#empPopUp").data("kendoWindow").close();
	}
	
	function empPopUpClose(){
		 $("#empPopUp").data("kendoWindow").close();
	}
	
	
	function fn_formatDate(str){
		return str.substring(0,4) + "-" + str.substring(4,6) + "-" + str.substring(6,8) ;
	}

	function fn_formatMoney(str){
	        str = String(str);
	        return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
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
	
	function resolutionViewOpen(e) {
		
		$voucherRowData = $("#grid").data("kendoGrid").dataItem($(e).closest("tr"));
		$flag = "expenditure";
		
		var url = _g_contextPath_ + "/budget/resolutionPopup";
		
		window.name = "parentForm";
		var openWin = window.open(url,"childForm","width=1400, height=580, resizable=yes , scrollbars=yes, status=no, top=200, left=350","newWindow");
	}
	
	function onDeptSeqSelect(e){
		var dataItem = this.dataItem(e.item.index());
		//$('#deptSeq').val(dataItem.dept_seq);
		$('#selectedEmpName').val('');
		$('#erpEmpSeq').val('');
		empGridReload();
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
					<dt style="width:4%">발의기간</dt>
					<dd style="width:18%">
						<input type="text" style="width:40%" id="from_period" name="period" value="" >
												&nbsp;~&nbsp;
						<input type="text" style="width:40%" id="to_period" name="period" value="" >
					</dd>
					<dt style="width:4%">발의부서</dt>
					<dd style="width:8%">
						<input type="text" style="width:100%" id ="deptCombo" value="" />
					</dd>
					<dt style="width:3%">발의자</dt>
					<dt style="width:9%">
						<input type="text" style="width:100%" id ="selectedEmpName" value="" disabled/>
						<input type="hidden" style="width:100%" id ="erpEmpSeq" value=""/>
					</dt>
					<dd style="width:5%">
						<button type="button" id ="empSearch" value="검색">
						<img style="position:inherit;" src="<c:url value='/Images/btn/search_icon2.png'/>"></button>
					</dd>
					<dt style="width:2%">적요</dt>
					<dd style="width:25%">
						<input type="text" style="width:100%" id ="rmkDc" value="" />
					</dd>
				</dl>
			</div>
		</div>
				
		<div class="btn_div mt10 cl">
			<div class="right_div">
				<div class="controll_btn p0">
					<button type="button" id="" onclick = "mainGrid()">조회</button>
				</div>
			</div>
		</div>
		
		<div class="com_ta2">
			<div  id = "grid">
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

