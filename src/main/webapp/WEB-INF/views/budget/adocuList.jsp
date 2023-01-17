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
<script type="text/javascript" src="<c:url value='/js/common/outProcessUtil.js' />"></script>
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
	transport : {
		read : {
			url : _g_contextPath_+ "/budget/getAdocuList",
			dataType : "json",
			type : "post"
		},
		parameterMap: function(data, operation) {
			
			data.page = 1;
			data.pageSize = 1000;
			data.frDt = $("#from_period").val().replace(/-/gi,"");
			data.toDt = $("#to_period").val().replace(/-/gi,"");
			data.coCd = $("#erpCoCd").val();
			data.empCd = $("#erpEmpSeq").val();
			data.deptCd = $("#deptCombo").val();
			data.title = $("#docTitle").val();
			data.submitYn = $("#submitYn").val();
			data.dateType = $("#dateType").val();
	     	return data;
	     }
	},
	height : 800,
	schema : {
		data : function(response){
			if($('#approSts').val() === ''){
				return response.list;
			}else if($('#approSts').val() === 'N'){
				return response.list.filter(function(obj){return !obj.c_distatus;});
			}else if($('#approSts').val() === '002'){
				return response.list.filter(function(obj){return (obj.c_distatus === '001' || obj.c_distatus === '002' || obj.c_distatus === '003');});
			}else if($('#approSts').val() === '001'){
				return response.list.filter(function(obj){return (obj.c_distatus === '001');});
			}else{
				return response.list.filter(function(obj){return obj.c_distatus === $('#approSts').val();});
			}
		},
		total: function(response) {
			if(response.list.length > 0){
				
				var result;
				
				if($('#approSts').val() === ''){
					result = response.list;
				}else if($('#approSts').val() === 'N'){
					result =  response.list.filter(function(obj){return !obj.c_distatus;});
				}else if($('#approSts').val() === '002'){
					result = response.list.filter(function(obj){return (obj.c_distatus === '001' || obj.c_distatus === '002' || obj.c_distatus === '003');});
				}else if($('#approSts').val() === '001'){
					return response.list.filter(function(obj){return (obj.c_distatus === '001');});
				}else{
					result = response.list.filter(function(obj){return obj.c_distatus === $('#approSts').val();});
				}
		        
				return result.length;
				
			}else{
				return 0;
			}
        }
	}
});

	$(function(){
		init();
		eventHandler();
		mainGrid();
		empGrid();
	});
	
	function init(){
		comboboxInit();
		datePickerInit();
		popupInit();
	}
	
	function datePickerInit(){
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
			value : moment().format('YYYY-MM-DD')
		});
	}
	
	function comboboxInit(){
// 		$("#submitYn").kendoDropDownList();
		
// 		$("#titleType").kendoDropDownList();

		$("#dateType").kendoDropDownList();
		
		allDept.unshift({dept_name : "전체", dept_seq : ""});
		
		$("#deptCombo").kendoDropDownList({
		      dataSource: allDept,
		      dataTextField: "dept_name",
			  dataValueField: "dept_seq",
			  index: 0,
		});
		
		$("#approSts").kendoDropDownList();
	}
	
	function popupInit(){
		$("#empPopUp").kendoWindow({
		    width: "600px",
		    height: "750px",
		    visible: false,
		    actions: ["Close"]
		}).data("kendoWindow").center();
	}
	
	function eventHandler(){
		$(document).on("mouseover", ".docTitle", function() {
			$(this).removeClass("blueColor").addClass("onFont");
		});
		
		$(document).on("mouseout", ".docTitle", function() {
			$(this).removeClass("onFont").addClass("blueColor");
		});
		
		$("#docTitle").on("keyup", function(e) {
			if (e.keyCode === 13) {
				gridReload();	
			}
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
				var tempData = e.data;
				$.each(e.workbook.sheets[0].rows, function(i){
					if(this.type != 'header'){
						if(tempData[i-1].ISU_DT){
							var lpad = '';
							for(j = tempData[i-1].ISU_SQ.toString().length; j < 5; j++){
								lpad += '0';
							}
							this.cells[0].value =  moment(tempData[i-1].ISU_DT).format('YYYY .MM .DD') + ' - ' + lpad + tempData[i-1].ISU_SQ;
						}
						if(this.cells[2].value == '95'){
							this.cells[2].value = '결의서';
						}else{
							this.cells[2].value = '일반';
						}
						if(tempData[i-1].FILL_DT){
							var lpad = '';
							for(j = tempData[i-1].FILL_NB.toString().length; j < 5; j++){
								lpad += '0';
							}
							this.cells[3].value =  moment(tempData[i-1].FILL_DT).format('YYYY .MM .DD') + ' - ' + lpad + tempData[i-1].FILL_NB;
						}
						if(this.cells[4].value == '1'){
							this.cells[4].value = '승인';
						}else{
							this.cells[4].value = '미결';
						}
						if(this.cells[7].value){
							var returnVal = '';
							var kyuljaeuser = '';
							if(tempData[i-1].kyuljaeuser){
								kyuljaeuser = '(' + tempData[i-1].kyuljaeuser + ')';
							}
							if(!this.cells[7].value){
								returnVal = '';
							}else if(this.cells[7].value === '008'){
								returnVal = tempData[i-1].c_distatus_nm + kyuljaeuser;
							}else{
								returnVal = tempData[i-1].c_distatus_nm + kyuljaeuser;
							}
							this.cells[7].value = returnVal;
						}
					}
				});
			    e.workbook.fileName = "회계전표현황.xlsx";
			},
			dataSource: $dataSource,
			dataBound : dataBound,
			selectable : "row",
			sortable : true,
			columns : [
				{
					template : function(dataItem){
						if(dataItem.c_distatus_nm){
							return "";
						}else{
							return "<input type='checkbox' class='rowCheckbox' onclick='fnClickCheckbox(this);' isu_dt='" + dataItem.ISU_DT + "' isu_sq='" + dataItem.ISU_SQ + "' />";
						}
					},
					width : 5,
				},
				{
					field : "isu_seq",
					width : 15,
					title : "전표번호",
					template : function(dataItem){
						var lpad = '';
						for(i = dataItem.ISU_SQ.toString().length; i < 5; i++){
							lpad += '0';
						}
						return moment(dataItem.ISU_DT).format('YYYY .MM .DD') + ' - ' + lpad + dataItem.ISU_SQ;
					}
				},
				{
					field : "ISU_DOC",
					width : 100,
					title : "품의내역(적요)",
					template : function(dataItem){
						return'<span class="docTitle blueColor" onclick="fn_viewPop(\'' + dataItem.ISU_DT + '\',\'' + dataItem.ISU_SQ + '\')">' + dataItem.ISU_DOC + '</span>';
					},
					attributes : {
						style : "text-align: left;text-indent: 5px;"
					}
				},
				{
					field : "GET_FG",
					width : 10,
					title : "유형",
					template : function(dataItem){
						return dataItem.GET_FG == '95' ? '결의서' : '일반'
					}
				},
				{
					field : "fill_seq",
					width : 15,
					title : "기표번호",
					template : function(dataItem){
						if(dataItem.FILL_NB){
							var lpad = '';
							for(i = dataItem.FILL_NB.toString().length; i < 5; i++){
								lpad += '0';
							}
							return moment(dataItem.FILL_DT).format('YYYY .MM .DD') + '-' + lpad + dataItem.FILL_NB;
						}else{
							return '';
						}
					}
				},
				{
					width : 10,
					field : "DOCU_ST",
					title : "상태",
					template : function(dataItem){
						return dataItem.DOCU_ST == '1' ? '승인' : '미결';
					}
				},
				{
					field : "ADMIT_NAME",
					width : 15,
					title : "승인자"
				},
				{
					width : 15,
					field : "c_ridocfullnum",
					title : "문서번호",
					template : function(dataItem){
						if(dataItem.c_ridocfullnum){
							return'<span class="docTitle blueColor" onclick="fn_docViewPop(\'' + dataItem.appr_dikey + '\')">' + dataItem.c_ridocfullnum + '</span>';
						}else{
							return '';
						}
					}
				},
				{
					width : 15,
					field : "c_distatus",
					title : "결재상태",
					template : function(dataItem){
						var returnVal = '';
						var kyuljaeuser = '';
						if(dataItem.kyuljaeuser){
							kyuljaeuser = '(' + dataItem.kyuljaeuser + ')';
						}
						if(!dataItem.c_distatus){
							returnVal = '';
						}else if(dataItem.c_distatus === '008'){
							returnVal = dataItem.c_distatus_nm + kyuljaeuser;
						}else{
							returnVal = dataItem.c_distatus_nm + kyuljaeuser;
						}
						return returnVal;
					}
				},
				{
					width : 12,
					field : "",
					title : "결재선보기",
					template : function(dataItem){
						if(!dataItem.c_distatus){
							return '';
						}else{
							return '<span class="ico-blank" onclick="fnApprovalLinePop(\'' + dataItem.appr_dikey +'\');"></span>';
						}
					}
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
	
	//사원팝업 ajax
	var empDataSource = new kendo.data.DataSource({
		serverPaging: true,
		pageSize: 10,
	    transport: { 
	        read:  {
	            url: _g_contextPath_+'/budget/getErpEmpList',
	            dataType: "json",
	            type: 'post'
	        },
	      	parameterMap: function(data, operation){
	      		data.erpCompSeq = $("#erpCoCd").val();
	        	data.erpDeptSeq = $("#deptCombo").val();
	        	data.erpEmpSeq = $("#erpEmpSeq").val();
	        	data.erpDivSeq = $("#erpDivSeq").val();
	        	data.toDate = $("#toDate").val();
	        	data.baseDate = $("#baseDate").val();
	        	data.empName = $("#emp_name").val();
	        	data.notIn = '';
	     		return data;
	     	}
	    },
	    schema: {
	      data: function(response) {
	        return response.list;
	      },
	      total: function(response) {
	        return response.list[0].cnt;
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
// 	        pageable: {
// 	            refresh: true,
// 	            pageSizes: true,
// 	            buttonCount: 5
// 	        },
	        persistSelection: true,
	        selectable: "multiple",
	        columns:[ {field: "korName",
				            title: "이름",
					    },{field: "erpDeptName",
				            title: "부서",
	        		    }, {title : "선택",
						    template : '<input type="button" id="" class="text_blue" onclick="empSelect(this);" value="선택">'
	        		    }]
	    }).data("kendoGrid");
	}
	
	//선택 클릭이벤트
	function empSelect(e){		
		var row = $("#empGrid").data("kendoGrid").dataItem($(e).closest("tr"));
		
		$('#selectedEmpName').val(row.korName);
		$("#erpEmpSeq").val(row.erpEmpSeq);
		
		$("#empPopUp").data("kendoWindow").close();
	}
	
	function empPopUpClose(){
		 $("#empPopUp").data("kendoWindow").close();
	}
	
	function fnClickCheckbox(obj){
		$('.rowCheckbox').prop('checked', false);
		$(obj).prop('checked', true);
	}
	
	function fn_viewPop(isu_dt, isu_sq){
		var url = _g_contextPath_+ "/budget/pop/adocuViewPop?isu_dt=" + isu_dt + "&isu_sq=" + isu_sq;
		window.open(url,"adocuViewer","width=800, height=900, resizable=yes , scrollbars=no, status=no, top=50, left=50","newWindow");	
	}
	
	function fn_docViewPop(dikeyCode){
		var params = {};
	    var url = "/ea/edoc/eapproval/docCommonDraftView.do?multiViewYN=Y&diSeqNum=undefined&miSeqNum=undefined&diKeyCode="+dikeyCode;
		if(g_hostName === '127.0.0.1' || g_hostName === 'localhost'){
		    var url = "http://10.10.10.199/ea/edoc/eapproval/docCommonDraftView.do?multiViewYN=Y&diSeqNum=undefined&miSeqNum=undefined&diKeyCode="+dikeyCode;
		}
		window.open(url,"viewer","width=965, height=950, resizable=yes , scrollbars=no, status=no, top=50, left=50","newWindow");						
	}
	
	function resDocSubmit(){
		if($('.rowCheckbox:checked').length === 0){
			alert('선택된 전표가 없습니다.');
			return;
		}
		var dataItem = $('#grid').data('kendoGrid').dataItem($('.rowCheckbox:checked').closest('tr'));
		var url = _g_contextPath_+ "/budget/pop/adocuViewPop?isu_dt=" + dataItem.ISU_DT + "&isu_sq=" + dataItem.ISU_SQ + "&approval=Y";
		var options = "width=800, height=900, top=50, left=50, scrollbars=YES, resizable=YES";
		
		openDialog(url, 'viewer', options, function(win) {
			gridReload();
		});
// 		window.open(url,"viewer","width=800, height=900, resizable=yes , scrollbars=no, status=no, top=50, left=50","newWindow");
	}
	
	var openDialog = function(uri, name, options, closeCallback) {
	    var win = window.open(uri, name, options);
	    var interval = window.setInterval(function() {
	        try {
	            if (win == null || win.closed) {
	                window.clearInterval(interval);
	                closeCallback(win);
	            }
	        }
	        catch (e) {
	        }
	    }, 1000);
	    return win;
	};
	
	function fnApprovalLinePop(diKeyCode){
		var url = "/ea/edoc/eapproval/workflow/approvalLineViewPopup.do?diKeyCode=" + diKeyCode;
		window.open(url,"viewer","width=824, height=320, resizable=yes , scrollbars=no, status=no, top=50, left=50","newWindow");	
	}
</script>
<div class="iframe_wrap">
	<div class="sub_title_wrap">
		<div class="title_div">
			<h4>지출결의서 제출</h4>
		</div>
	</div>
	<input type="hidden" id="compSeq" value="${userInfo.compSeq }">
	<input type="hidden" id="erpCoCd" value="${userInfo.erpCoCd }">
	<input type="hidden" id="empSeq" value="${userInfo.uniqId }">
	<input type="hidden" id="deptSeq" value="${userInfo.orgnztId }">
	
	<div class="sub_contents_wrap">
		<div class="com_ta">
			<div class="top_box gray_box" id = "dataBox">
				<dl>
					<dt style="width:85px;">
						<select id="dateType" style="width: 100%;">
							<option value="1">전표일자</option>
							<option value="2">기표일자</option>
						</select>
					</dt>
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
						<input type="text" style="width:100%" id ="selectedEmpName" value="" disabled="disabled"/>
						<input type="hidden" style="width:100%" id ="erpEmpSeq" value=""/>
					</dt>
					<dd style="width:10px;">
						<button type="button" id ="empSearch" value="검색">
						<img style="position:inherit;" src="<c:url value='/Images/btn/search_icon2.png'/>"></button>
					</dd>
					<dt style="width:55px;">품의내역
<!-- 						<select id="titleType" style="width: 100%;"> -->
<!-- 							<option value="1">제목</option> -->
<!-- 							<option value="2">문서번호</option> -->
<!-- 						</select> -->
					</dt>
					<dd style="width:200px;">
						<input type="text" id="docTitle" value="">
					</dd>
					<dt style="width:55px;">결제상태 </dt>
					<dd style="width:80px;">
						<select id="approSts" style="width: 100%;">
							<option value="">전체</option>
							<option value="001">기안중</option>
							<option value="002">결재중</option>
							<option value="004">결재보류</option>
							<option value="008">결재완료</option>
							<option value="N">미결재</option>
						</select>
					</dd>
				</dl>
			</div>
		</div>
				
		<div class="btn_div mt10 cl">
			<div class="right_div">
				<div class="controll_btn p0">
					<button type="button" id="" onclick = "resDocSubmit()">기안하기</button>
					<button type="button" id="" onclick = "gridReload()">조회</button>
				</div>
			</div>
		</div>
		
		<div class="com_ta2">
			<div  id = "grid" style="height: 800px;">
			</div>
		</div>
		
	</div>
</div>

<div id="loadContentsArea" style=""></div>

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
<form id="outProcessFormData" action="/gw/outProcessLogOn.do" target="outProcessLogOn"></form>
</body>

