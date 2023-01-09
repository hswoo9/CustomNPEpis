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
<script type="text/javascript" src="<c:url value='/js/budget/budgetUtil.js' />"></script>
<style>
	.green_btn {background:#0e7806 !important; height:24px; padding:0 11px; color:#fff !important;border:none; font-weight:bold; border:0px !important;}
</style>
<script type="text/javascript">
 
 var first = true;
 var deptSeq = '<c:out value="${deptSeq}"/>';
 var deptName = '<c:out value="${deptName}"/>';
 var compSeq = '<c:out value="${compSeq}"/>';
 var deptComboList = '';
 var statusComboList = '';
 var $mainGridURL = _g_contextPath_ + "/budget/getDeptBgtStatus";
 var $parentData = '';
 
	$(function() {
		Init.ajax();
		
		Init.kendoFunction();
		Init.kendoGrid();
		Init.eventListener();
	})
	
	var Init = {
			ajax : function() {
				$.ajax({
			 		url: _g_contextPath_+"/budget/searchDeptList3",
			 		dataType : 'json',
			 		data : { year : moment().format('YYYY') },
			 		type : 'POST',
			 		async : false,
			 		success: function(result){
			 			deptComboList = result;
			 		}
			 	});
				
				$.ajax({
			 		url: _g_contextPath_+"/budget/getApplyStatus",
			 		dataType : 'json',
			 		data : {},
			 		type : 'POST',
			 		async : false,
			 		success: function(result){
			 			statusComboList = result;
			 		}
			 	});
			},
			kendoFunction : function() {
				
				$("#projectPopup").kendoWindow({
				    width: "600px",
				    visible: false,
				    actions: ["Close"],
				}).data("kendoWindow").center();
				
				$("#dept").kendoComboBox({
				      dataSource: deptComboList.resolutionDeptList,
				      dataTextField: "DEPT_NM",
					  dataValueField: "DEPT_CD",
					  height : 500,
					  index : 0
				});
				
				$("#status").kendoComboBox({
				      dataSource: statusComboList.list,
				      dataTextField: "BGT_STAT_NM",
					  dataValueField: "BGT_STAT",
					  index : 0
				});
				
				$("#standardDate").kendoDatePicker({
				    depth: "year",
				    start: "year",
				    culture : "ko-KR",
					format : "yyyy-MM",
					value : new Date(),
					change : changeStandardDate
				});
			},
			kendoGrid : function() {
				/* 상단 그리드 */
				var mainGrid = $("#mainGrid").kendoGrid({
					dataSource : new kendo.data.DataSource({
						transport : {
							read : {
								url : _g_contextPath_+"/budget/initGrid",
								dataType : "json",
								type : 'post'
							},
							parameterMap: function(data, operation) {
		  	      				data.month = $("#standardDate").val().replace(/-/gi,'');
		  	      				data.deptSeq = $('#dept').data('kendoComboBox').value();
		  	      				data.bgtStatus = $('#status').data('kendoComboBox').value();
		  	      				data.pjtCd = $('#pjtFromCd').val();
		    	     			return data;
		    	     		}
						},
						height : 700,
						schema : {
							data : function(response) {
								return first ? [] : response.list;
							},
							total : function(response) {
								return first ? 0 : response.total;
							},
						}
					}),
					dataBound : mainGridDataBound,
			        columns: [
			        	{
			        		headerTemplate : function(e){
			                   return '<input type="checkbox" id = "checkboxAll">';
			                },
			                template : function(e) {
			                	if (e.BGT_STAT == 1) {
				                	return '<input type="checkbox" class = "mainCheckBox">';
			                	} else {
			                		return '';
			                	}
			                },
			                width : 25
			        	},
			        	{	field : "DEPT_NM",				title : "부서",	width : 25 },
			        	{	field : "PJT_CD",				title : "프로젝트 코드",	width : 40 },
			        	{	field : "PJT_NM2",				title : "프로젝트 명",	width : 40 },
			        	{
			        		template : function(dataItem) {
			        			return '<input type="button" class="blue_btn" value="신청확인" onclick="viewApplyDeptBgt(this)">'
			        		},
			        		title : '신청확인',
			        		width : 20
			        	},
			        	{
			        		title : '예산과목',
			        		columns : [
			        			{
			        				title : '코드',
			        				field : 'BGT_CD',
			        				width : 30
			        			},
			        			{
			        				title : '관-항',
			        				field : 'HBGT_NM',
			        				width : 30
			        			},
			        			{
			        				title : '목-세목',
			        				field : 'BGT_NM',
			        				width : 30
			        			}
			        		]
			        	},
			        	{	
			        		template : function(e) {
			        			return Budget.fn_formatMoney(e.BGT_AMT);
			        		},
			        		title : "예산금액",	
			        		width : 40 
		        		},
			        	{	field : "BGT_STAT_NM",				title : "상태",	width : 40 },
			        	{
			        		template : function(e) {
			        			if (e.BGT_STAT == 2) {
			        				return '<input type="button" class="text_blue" style="width: 80px;" onclick="cancel(this);" value="승인취소">';
			        			} else {
			        				return '';
			        			}
			        		},
			        		title : '승인취소',
			        		width : 40
			        	}]
			    }).data("kendoGrid");
				/* 상단 그리드 */
				
				/* 프로젝트 팝업 그리드 */
				var projectGrid = $("#projectGrid").kendoGrid({
			        dataSource: new kendo.data.DataSource({
			    	    transport: { 
			    	        read:  {
			    	            url: _g_contextPath_+'/budget/projectList2',
			    	            dataType: "json",
			    	            type: 'post'
			    	        },
			    	      	parameterMap: function(data, operation) {
		   	      				data.fiscal_year = $("#standardDate").val().substring(0, 4);
		    	      			data.project = $("#projectName").val();
		    	      			data.deptCd = $('#erpDeptSeq').val();
			    	     		return data;
			    	     	}
			    	    },
			    	    schema: {
			    	      data: function(response) {
			    	        return response.list;
			    	      },
			    	      total: function(response) {
			    	        return response.total;
			    	      }
			    	    }
			    	}),
			        height: 500,	        
			        sortable: true,
			        persistSelection: true,
			        selectable: "multiple",
			        columns:[{
			        					title : "프로젝트 코드",
			        					field : "PJT_CD",
			        					width : 30
			        				},
			        				{
			        					title : "프로젝트 명",
			        					field : "PJT_NM",
			        					width : 30
			        				},
			        				{
			        					title : "선택",
			        					width : 15,
								    	template : '<input type="button" id="" class="text_blue" onclick="projectSelect(this);" value="선택">'
		        		    	    }]
			    }).data("kendoGrid");
				/* 프로젝트 팝업 그리드 */
				
			},
			eventListener : function() {
				
				// 체크박스 전체선택
				$("#checkboxAll").click(function(e) {
			         if ($("#checkboxAll").is(":checked")) {
			        	 $(".mainCheckBox").prop("checked", true);
			         } else {
			            $(".mainCheckBox").prop("checked", false);
			         }
		      	});
				
				$("#pjtFromSearch").on("click", function() {
					
					 $('#projectName').val("");
					 $('#projectFrom').val('');
					 $("#projectPopup").data("kendoWindow").open();
					 projectGridReload();
				});
				
				$("#projectName").on("keyup", function(e){
					if (e.keyCode === 13) {
						projectGridReload();
					}
				});
				
				$('#projectPopupCancel').on('click', function() {
					projectPopupClose();
				});
			}
	}
	
	function viewApplyDeptBgt(param) {
		var dataItem = $('#mainGrid').data('kendoGrid').dataItem($(param).closest('tr'));
		
		dataItem.standardDate = $("#standardDate").val().replace(/-/gi,'');
		
		$parentData = JSON.stringify(dataItem);
		
		var url = _g_contextPath_ + "/budget/applyDeptBgtPopup";
		
		window.name = "parentForm";
		var openWin = window.open(url,"childForm","width=1400, height=480,  status=no, top=200, left=350","newWindow");
	}
	
	function projectSelect(e){		
		var row = $("#projectGrid").data("kendoGrid").dataItem($(e).closest("tr"));
		
		$("#pjtFrom").val(row.PJT_NM);
		$("#pjtFromCd").val(row.PJT_CD);
		
		$("#projectPopup").data("kendoWindow").close();
	}
	
	function projectPopupClose(){
		 $("#projectPopup").data("kendoWindow").close();
	}
	
	function projectGridReload() {
		$("#projectGrid").data("kendoGrid").dataSource.read();
	}
	
	function cancel(param) {
		var row = $("#mainGrid").data("kendoGrid").dataItem($(param).closest("tr"));
		
		$.ajax({
			url : _g_contextPath_+ "/budget/cancelDeptBgt2",
			data : makeConvertData(row),
			async : false,
			type : "POST",
			success : function(result){				
				if (result.OUT_YN === 'Y') {
					alert('취소하였습니다.');
					searchMainGrid();
				} else {
					alert(result.OUT_MSG);
				}
			}
		});
	}
	
	function approve() {
		var list = [];
		
		$(".mainCheckBox:checked").each(function(i, v) {
			
			var rows = $("#mainGrid").data("kendoGrid").dataItem($(v).closest("tr"));
			
			list.push(makeConvertData(rows));
		});
		
		if (list.length === 0 ) return;
		
		$.ajax({
			url : _g_contextPath_+ "/budget/saveDeptBgt3",
			data : { param : JSON.stringify(list) },
			async : false,
			type : "POST",
			success : function(result){				
				if (result.OUT_YN === 'Y') {
					alert('승인 신청되었습니다.');	
					searchMainGrid();
				} else {
					alert(result.OUT_MSG);
				}
			}
		});
	}
	
	function makeConvertData(row) {
		
		var paramMap = {};
		
		paramMap.coCd = compSeq;
		paramMap.deptSeq = row.DEPT_CD;
		paramMap.pjtCd = row.PJT_CD;
		paramMap.bgtCd = row.BGT_CD;
		paramMap.bgtMonth = $("#standardDate").val().replace(/-/gi,'');
		
		return paramMap;
		
	}
	
	function mainGridDataBound(e) {
		var grid = e.sender;

		if (grid.dataSource.total() == 0) {
			var colCount = grid.columns.length + 3;
			$(e.sender.wrapper).find('tbody').append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
		}
	}
	
	function searchMainGrid() {
		first = false;
		$('#mainGrid').data('kendoGrid').dataSource.transport.options.read.url = $mainGridURL;
		$('#mainGrid').data('kendoGrid').dataSource.read();
	}
	
	function pjtSearchCancel() { //선택취소버튼 
		first = true;
		$('#pjtFrom').val('');
		$('#pjtFromCd').val('');
		$('#mainGrid').data('kendoGrid').dataSource.transport.options.read.url = $mainGridURL;
		$('#mainGrid').data('kendoGrid').dataSource.read();
	}
	
	function changeStandardDate() {
		
		$.ajax({
	 		url: _g_contextPath_+"/budget/searchDeptList3",
	 		dataType : 'json',
	 		data : { year : $('#standardDate').val().substring(0,4), deptName : '' },
	 		type : 'POST',
	 		async : false,
	 		success: function(result){
	 			$('#dept').data('kendoComboBox').setDataSource(result.resolutionDeptList);
	 		}
	 	});
	}
	
	function excel() {
		
		var mainList = $('#mainGrid').data('kendoGrid')._data;
		var templateName = 'deptBgtStatusTemplate';
		var title = '예산 세부내역';
		
		$.ajax({
	 		url: _g_contextPath_+"/budget/budgetExcel2",
	 		dataType : 'json',
	 		data : { param : JSON.stringify(mainList), templateName : templateName, title : title },
	 		type : 'POST',
	 		success: function(result){
	 			var downWin = window.open('','_self');
				downWin.location.href = _g_contextPath_+"/budget/excelDownLoad?fileName="+ escape(encodeURIComponent(result.fileName)) +'&fileFullPath='+escape(encodeURIComponent(result.fileFullPath));
	 		}
	 	});
	}
	
</script>
<body>
<div class="iframe_wrap">
	<div class="sub_title_wrap">
		<div class="title_div">
			<h4>예산 세부내역 확정</h4>
		</div>
	</div>
	
	<div class="sub_contents_wrap">
		<div class="com_ta">
			<div class="top_box gray_box" id = "dataBox">
				<dl>
					<dt>기준년월</dt>
					<dd style="width:15%">
						<input type="text" style="" id = "standardDate" style = "" value=""/>
					</dd>
					<dt>부서</dt>
					<dd style="width:15%">
						<input type="text" style="" id = "dept" value="" />
					</dd>
					<dt>신청상태</dt>
					<dd style="width:15%">
						<input type="text" style="" id = "status" value="" />
					</dd>
					<dt style="">프로젝트</dt>
					<dd style="width:20%">
						<input type="text" style="width:60%" id ="pjtFrom" disabled/>
						<input type="hidden" id ="pjtFromCd"/>
						<button type="button" id ="pjtFromSearch" value="검색">
						<img style="position:inherit;" src="<c:url value='/Images/btn/search_icon2.png'/>"></button>
						<button type="button" id ="" class="blue_btn" onclick = "pjtSearchCancel()">선택취소</button>
					</dd>
				</dl>
			</div>
		</div>
				
		<div class="btn_div mt10 cl">
			<div class="left_div">
				<p class="tit_p mt5 mb0">예산 세부내역 확정</p>
			</div>
			<div class="right_div">
				<div class="controll_btn p0">
					<button type="button" id="" onclick = "excel()">엑셀</button>
					<button type="button" id="" onclick = "approve()">승인</button>
					<button type="button" id="" onclick = "searchMainGrid()">조회</button>
				</div>
			</div>
		</div>
		
		<div class="com_ta2" style="height: 400px;">
			<div  id = "mainGrid">
			</div>
		</div>
	</div>
</div>

<!-- 프로젝트검색팝업 -->
<div class="pop_wrap_dir" id="projectPopup" style="width:600px;">
	<div class="pop_head">
		<h1>프로젝트 선택</h1>
	</div>
	<div class="pop_con">
		<div class="top_box">
			<dl>
				<dt class="ar" style="width: 80px;">프로젝트 명</dt>
				<dd style="">
					<input type="text" id="projectName" style="width: 120px" />
				</dd>
				<dd>
					<input type="button" onclick="projectGridReload();" id="searchButton"	value="검색" />
				</dd>
			</dl>
		</div>
		<div class="com_ta mt15">
			<div id="projectGrid"></div>
		</div>			
	</div>

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" class="gray_btn" id="projectPopupCancel" value="닫기" />
		</div>
	</div>
</div>	
<!-- 프로젝트검색팝업 -->

</body>

