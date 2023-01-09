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
</style>
<body>

<script type="text/javascript">

var allDept = JSON.parse('${allDept}'); // 부서 목록
var $voucherRowData;
var $flag;
var $dataSource = new kendo.data.DataSource({		//그리드데이터소스
	serverPaging : true,
	pageSize : 1000,
	transport : {
		read : {
			url : _g_contextPath_+ "/budget/getResDocSubmitAdminList",
			dataType : "json",
			type : "post"
		},
		parameterMap: function(data, operation) {
			data.frDt = $("#from_period").val().replace(/-/gi,"");
			data.toDt = $("#to_period").val().replace(/-/gi,"");
			data.compSeq = $("#compSeq").val();
			data.deptSeq = $("#deptCombo").val();
			data.empSeq = $("#emp_seq_txt").val();
			if($('#titleType').val() === '1'){
				data.docTitle = $("#docTitle").val();
			}else if($('#titleType').val() === '2'){
				data.docNo = $("#docTitle").val();
			}
			data.submitYn = $("#submitYn").val();
			data.biddingYn = $("#biddingYn").val();
			data.returnYn = $("#returnYn").val();
			data.order = 'reg_date desc, reg_no desc';
			data.submitType = '1';
	     	return data;
	     }
	},
	schema : {
		data : function(response){
			if($('#biddingYn').val() === 'D'){
				return response.list.filter(function(obj){return obj.useName === '처리제외';});
			}
			return response.list;
		},
	    model : {
	    	fields : {

	    	}
	    }
	}
});

	$(function(){

		$(document).on("mouseover", ".docTitle", function() {
			$(this).removeClass("blueColor").addClass("onFont");
		});
		
		$(document).on("mouseout", ".docTitle", function() {
			$(this).removeClass("onFont").addClass("blueColor");
		});
		
		$("#from_period").kendoDatePicker({
		    depth: "month",
		    start: "month",
		    culture : "ko-KR",
			format : "yyyy-MM-dd",
			value : new Date('${year}','${mm-1}','1'),
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
		
		allDept.unshift({dept_name : "전체", dept_seq : ""});
		
		$("#deptCombo").kendoComboBox({
		      dataSource: allDept,
		      dataTextField: "dept_name",
			  dataValueField: "dept_seq",
			  select : onDeptSeqSelect,
			  index: 0,
		});
		
		$("#empSearch").click(function(){	
			 $('#emp_name').val("");
			 $('#selectedEmpName').val('');
			 $('#erpEmpSeq').val('');
			 $('#emp_seq_txt').val('');
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
		
		$("#empPopUp").kendoWindow({
			    width: "600px",
			   height: "750px",
			    visible: false,
			    actions: ["Close"]
		}).data("kendoWindow").center();
		
		$("#docTitle").on("keyup", function(e) {
			if (e.keyCode === 13) {
				gridReload();	
			}
		});
		
		$("#biddingYn").kendoDropDownList();
		
		$("#returnYn").kendoDropDownList();
		
		$("#titleType").kendoDropDownList();
		
		mainGrid();
		empGrid();
		returnPopUpInit();

	});

	function getData(){
		setTimeout(function(){

			var cnt = $("#grid").data("kendoGrid").dataSource.data().length;

			$("#docCnt").text(cnt);
		},500)
	}
	
	
	function mainGrid(){

		var grid =  $("#grid").kendoGrid({
			toolbar : [
				{
					name : "excel",
					text : "Excel"
				}
				],
			excelExport: function(e) {
				$.each(e.workbook.sheets[0].columns, function(i){
					this.autoWidth = true;
				});
				$.each(e.workbook.sheets[0].rows, function(){
					if(this.type != 'header'){
						if(this.cells[5].value){
							this.cells[5].value = this.cells[5].value.toDate();
						}
						if(this.cells[6].value){
							this.cells[6].value = this.cells[6].value.toDate();
						}
						if(this.cells[12].value){
							this.cells[12].value = this.cells[12].value.toString().toMoney();
						}
					}
				});
			    e.workbook.fileName = "지출결의서 제출현황(고지서).xlsx";
			},
			dataSource: $dataSource,
			height : 700,
			dataBound : dataBound,
			selectable : "row",
			sortable : true,
			persistSelection : true,
			columns : [
				{
					field : "",
					width : 5,
					template : function(dataItem){
						if(dataItem.fill_dt){
							return '';
						}else{
							return '<input type="checkbox" class="useCheck" value="' + dataItem.consDocSeq + '"/>';
						}
					},
				},
				{
					field : "regNo",
					width : 15,
					title : "접수번호"
				},
				{
					field : "deadline",
					width : 15,
					title : "처리기한"
				},
				{
					field : "docNo",
					template : function(dataItem) {
						return "<span class='blueColor docTitle' onclick='fn_docViewPop(" + dataItem.docSeq + ")'>" + dataItem.docNo + "</span>";
					},
					width : 15,
					title : "문서번호"
				},
				{
					width : 35,
					field : "docTitle",
					title : "제목",
					template : function(dataItem) {
						return "<span class='blueColor docTitle' onclick='fn_docViewPop(" + dataItem.docSeq + ")'>" + dataItem.docTitle + "</span>";
					},
				},
				{
					field : "docDate",
					width : 15,
					title : "승인일자"
				},
				{
					field : "isu_dt",
					template : function(dataItem) {
						if(dataItem.isu_dt){
							return dataItem.isu_dt.toDate();
						}else{
							return '';
						}
					},
					width : 15,
					title : "승인일자(전표)"
				},
				{
					field : "fill_dt",
					template : function(dataItem) {
						if(dataItem.fill_dt){
							return dataItem.fill_dt.toDate();
						}else{
							return '';
						}
					},
					width : 15,
					title : "확정일자(전표)"
				},
				{
					field : "fill_num",
					width : 15,
					title : "기표번호",
				},
				{
					width : 15,
					field : "deptName",
					title : "기안부서"
				},
				{
					width : 15,
					field : "empName",
					title : "기안자"
				},
				{
					width : 15,
					field : "mgtName",
					title : "프로젝트"
				},
				{
					width : 15,
					field : "repBudgetName",
					title : "예산과목"
				},
				{
					field : "resDocAmt",
					template : function(dataItem) {
						return dataItem.resDocAmt.toString().toMoney();
					},
					width : 20,
					title : "결의금액"
				},
				{
					field : "useName",
					width : 15,
					title : "확정여부",
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

		getData();
	};
	
	
	function fn_formatDate(str){
		return str.substring(0,4) + "-" + str.substring(4,6) + "-" + str.substring(6,8) ;
	}

	function fn_formatMoney(str){
	        str = String(str);
	        return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
	}
	
	function makeToDateMin(){
		
		if($("#from_period").val()>$("#to_period").val()){
			$("#to_period").data("kendoDatePicker").value($("#from_period").val());
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
	
	function fn_checkAll(obj){
		if($(obj).prop("checked")){
			$(".rowCheckbox").prop("checked", true);
		}else{
			$(".rowCheckbox").prop("checked", false);
		}
	}
	
	function resDocSubmit(){
		var checkBoxArr = $(".rowCheckbox:checked");
		if(checkBoxArr.length == 0){
			alert("선택된 결의서가 없습니다.");
			return;
		}
		if(confirm("선택된 결의서를 제출합니다.")){
			var resDocSeqArr = "";
			$.each(checkBoxArr, function(inx){
				if(inx != 0){
					resDocSeqArr += ",";
				}
				resDocSeqArr += $(this).attr("resDocSeq");
			});
			$.ajax({
				url : _g_contextPath_+ "/budget/resDocSubmit",
				data : {resDocSeqArr: resDocSeqArr, empSeq: $("#empSeq").val()},
				type : "POST",
				async : false,
				success : function(result){
					$(".headerCheckbox").prop("checked", false);
					gridReload();
				}
			});
		}
	}
	
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
	
	function onDeptSeqSelect(e){
		var dataItem = this.dataItem(e.item.index());
		//$('#deptSeq').val(dataItem.dept_seq);
		$('#selectedEmpName').val('');
		empGridReload();
	}
	
	//선택 클릭이벤트
	function empSelect(e){		
		var row = $("#empGrid").data("kendoGrid").dataItem($(e).closest("tr"));
		
		console.log(row);
		
		$('#selectedEmpName').val(row.emp_name);
		$("#erpEmpSeq").val(row.erp_emp_num);
		$("#emp_seq_txt").val(row.emp_seq);
		
		$("#empPopUp").data("kendoWindow").close();
	}
	
	function empPopUpClose(){
		 $("#empPopUp").data("kendoWindow").close();
	}
	
	function fnUseYN(useYn, msg){
		var checkBoxArr = $('.useCheck:checked');
		if(checkBoxArr.length === 0){
			alert('선택된 결의서가 없습니다.');
			return;
		}
		if(confirm('선택된 결의서를 ' + msg + '합니다.')){
			var resDocSeqArr = "";
			$.each(checkBoxArr, function(inx){
				if(inx != 0){
					resDocSeqArr += ",";
				}
				resDocSeqArr += $(this).val();
			});
			$.ajax({
				url : _g_contextPath_+ "/budget/updateUseYn",
				data : {resDocSeqArr: resDocSeqArr, useYn: useYn},
				type : "POST",
				async : false,
				success : function(result){
					$(".headerCheckbox").prop("checked", false);
					gridReload();
				}
			});
		}
	}
	
	function fnReturnPop(){
		var checkBoxArr = $('.useCheck:checked');
		if(checkBoxArr.length === 0){
			alert('선택된 결의서가 없습니다.');
			return;
		}
		if(checkBoxArr.length > 1){
			alert('하나의 결의서만 선택하세요.');
			return;
		}
		$('#returnReason').val('');
		var returnPop = $('#returnPop');
		returnPop.data("kendoWindow").open();
	}
	
	function fnReturn(){
		if(!$('#returnReason').val()){
			alert('반송사유를 입력하세요.');
			return;
		}
		var checkBoxArr = $('.useCheck:checked');
		if(confirm('선택된 결의서를 반송합니다.')){
			var resDocSeqArr = "";
			$.each(checkBoxArr, function(inx){
				if(inx != 0){
					resDocSeqArr += ",";
				}
				resDocSeqArr += $(this).val();
			});
			$.ajax({
				url : _g_contextPath_+ "/budget/updateReturn",
				data : {resDocSeqArr: resDocSeqArr, returnReason: $('#returnReason').val()},
				type : "POST",
				async : false,
				success : function(result){
					$(".headerCheckbox").prop("checked", false);
					var returnPop = $('#returnPop');
					returnPop.data("kendoWindow").close();
					gridReload();
				}
			});
		}
	}
	
	function returnPopUpInit(){
		//팝업 초기화
		var returnPop = $('#returnPop');
		returnPop.kendoWindow({
			width: "600px",
		    height: "95px",
			visible: false,
			modal: true,
			actions: [
				"Close"
			],
			close: function(){
				
			}
		}).data("kendoWindow").center();
	}
</script>
<div class="iframe_wrap">
	<div class="sub_title_wrap">
		<div class="title_div">
			<h4>지출결의서 제출현황</h4>
		</div>
	</div>
	<input type="hidden" id="compSeq" value="${userInfo.compSeq }">
	<input type="hidden" id="empSeq" value="${userInfo.uniqId }">
	
	<div class="sub_contents_wrap" style="min-width: 1400px;">
		<div class="com_ta">
			<div class="top_box gray_box" id = "dataBox">
				<dl>
					<dt style="width:55px;">접수일자</dt>
					<dd style="width:300px;">
						<input type="text" style="width:40%" id="from_period" name="period" value="" >
												&nbsp;~&nbsp;
						<input type="text" style="width:40%" id="to_period" name="period" value="" >
					</dd>
					<dt style="width:55px;">발의부서</dt>
					<dd style="width:150px;">
						<input type="text" style="width:100%" id ="deptCombo" value="" />
					</dd>
					<dt style="width:40px;">발의자</dt>
					<dt style="width:100px;">
						<input type="text" style="width:100%" id ="selectedEmpName" value="" disabled/>
						<input type="hidden" style="width:100%" id ="erpEmpSeq" value=""/>
						<input type="hidden" style="width:100%" id ="emp_seq_txt" value=""/>
					</dt>
					<dd style="width:10px;">
						<button type="button" id ="empSearch" value="검색">
						<img style="position:inherit;" src="<c:url value='/Images/btn/search_icon2.png'/>"></button>
					</dd>
					<dt style="width:90px;">
						<select id="titleType" style="width: 100%;">
							<option value="1">제목</option>
							<option value="2">문서번호</option>
						</select>
					</dt>
					<dd style="width:200px;">
						<input type="text" id="docTitle" value="">
						<input type="hidden" id="submitYn" value="Y">
					</dd>
					<dt style="width:55px;">확정여부</dt>
					<dd style="width:80px;">
						<select id="biddingYn" style="width: 100%;">
							<option value="">전체</option>
							<option value="Y">확정</option>
							<option value="N">미확정</option>
							<option value="D">처리제외</option>
						</select>
					</dd>
					<dt style="width:55px;">반송여부</dt>
					<dd style="width:80px;">
						<select id="returnYn" style="width: 100%;">
							<option value="">전체</option>
							<option value="Y">반송</option>
							<option value="N" selected="selected">미반송</option>
						</select>
					</dd>
				</dl>
			</div>
		</div>
				
		<div class="btn_div mt10 cl">

			<div class="left_div fwb mt5">
				<span><strong>총</strong></span>
				<strong><span id="docCnt">-</span></strong>
				<span><strong>건</strong></span>
			</div>

			<div class="right_div">
				<div class="controll_btn p0">
					<button type="button" id="" onclick = "fnReturnPop()">반송</button>
					<button type="button" id="" onclick = "fnUseYN('N','처리제외')">처리제외</button>
					<button type="button" id="" onclick = "fnUseYN('Y','처리제외취소')">처리제외취소</button>
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
<div class="pop_wrap_dir" id="returnPop" style="width:600px;">
	<div class="pop_con">
		<div class="top_box">
			<dl>
				<dt class="ar" style="width: 65px;">반송사유</dt>
				<dd style="width: 320px;">
					<input type="text" id="returnReason" style="width: 320px;" />
				</dd>
				<dd>
					<input type="button" onclick="fnReturn();" id=""	value="반송" />
				</dd>
			</dl>
		</div>
	</div><!-- //pop_con -->

</div><!-- //pop_wrap -->	
</body>

