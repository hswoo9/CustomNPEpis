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
 var first = true; // 최초 조회 구분 값
 var deptSeq = '<c:out value="${deptSeq}"/>';
 var deptName = '<c:out value="${deptName}"/>';
 var compSeq = '<c:out value="${compSeq}"/>';
 var selRow = '';
 var $mainGridURL = _g_contextPath_ + "/budget/getDeptBgt";
 var parentData = '';
 
	$(function() {
		parentData = JSON.parse(window.opener.$parentData);
		
		$('#deptName').val(parentData.DEPT_NM);
		$('#pjtFrom').val(parentData.PJT_NM);
		$('#standardDate').val(parentData.standardDate.substring(0, 4) + "-" + parentData.standardDate.substring(4));
		
		Init.ajax();
		
		Init.kendoFunction();
		Init.kendoGrid();
		Init.eventListener();
	})
	
	var Init = {
			ajax : function() {
			},
			kendoFunction : function() {
				$("#bgtPopup").kendoWindow({
				    width: "600px",
				    visible: false,
				    actions: ["Close"]
				}).data("kendoWindow").center();
				
				$("#projectPopup").kendoWindow({
				    width: "600px",
				    visible: false,
				    actions: ["Close"],
				}).data("kendoWindow").center();
				
				$("#applyPopup").kendoWindow({
				    width: "600px",
				   height: "350px",
				    visible: false,
				    actions: ["Close"],
					close : function() {
						$('#upperGrid').data('kendoGrid').dataSource.read(0);
					}
				}).data("kendoWindow").center();
				
// 				$("#standardDate").kendoDatePicker({
// 				    depth: "year",
// 				    start: "year",
// 				    culture : "ko-KR",
// 					format : "yyyy-MM",
// 					value : new Date(),
// 					change : changeStandardDate
// 				});
			},
			
			kendoGrid : function() {
				
				/* 상단 예산현황 그리드 */
				var upperGrid = $("#upperGrid").kendoGrid({
			        dataSource: new kendo.data.DataSource({
			    	    transport: { 
			    	        read:  {
			    	            url: _g_contextPath_+'/budget/selectBgtStatus',
			    	            dataType: "json",
			    	            type: 'post'
			    	        },
			    	      	parameterMap: function(data, operation) {
		   	      				data.month = parentData.standardDate;
		    	      			data.projectCd = parentData.PJT_CD;
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
			    	    },
			    	    pageSize : 10
			    	}),
			        persistSelection: true,
			        selectable: "multiple",
			        dataBound : mainGridDataBound,
			        columns:[
			        	{
			        		template : function(dataItem) {
			        			return Budget.fn_formatMoney(dataItem.AMT1);	
			        		},
			        		title : "예산금액",	width : 30
    					},
	    				{
							template : function(dataItem) {
								return Budget.fn_formatMoney(dataItem.AMT2);
			        		},
	    					title : "신청금액",		width : 30
	    				},
	    				{
							template : function(dataItem) {
								return Budget.fn_formatMoney(dataItem.AMT3);
			        		},
	    					title : "잔여금액",		width : 30
	    				},
    				]
			    }).data("kendoGrid");
				/* 상단 예산현황 그리드 */
				
				/* 하단 그리드 */
				var mainGrid = $("#mainGrid").kendoGrid({
					dataSource : new kendo.data.DataSource({
						transport : {
							read : {
								url : $mainGridURL,
								dataType : "json",
								type : 'post'
							},
							parameterMap: function(data, operation) {
		  	      				data.month = parentData.standardDate;
		  	      				data.deptSeq = parentData.DEPT_CD;
		  	      				data.pjtCd = parentData.PJT_CD;
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
			        columns: [
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
							template : function(data) {
								return Budget.fn_formatMoney(data.BGT_AMT);
							},
							title : "예산금액",
							width : 40
			        	},
			        	{	field : "BGT_STAT_NM",				title : "상태",	width : 40 },
//  			        	{
// 			        		template : function(e) {
// 			        			if (e.BGT_STAT == 0) {
// 				        			return '<input type="button" class="text_blue" style="width: 80px;" onclick="apply(this);" value="신청">';
// 			        			} else {
// 			        				return '';
// 			        			}
// 			        		},
// 			        		title : '신청',
// 			        		width : 40
// 			        	},
 			        	{
			        		template : function(e) {
			        			if (e.BGT_STAT == 1) {
			        				return '<input type="button" class="text_blue" style="width: 80px;" onclick="cancel(this);" value="신청취소">';
			        			} else {
			        				return '';
			        			}
			        		},
			        		title : '신청취소',
			        		width : 40
			        	}]
			    }).data("kendoGrid");
				/* 하단 그리드 */
				
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
				
				/* 예산 팝업 그리드 */
				var bgtGrid = $("#bgtGrid").kendoGrid({
			        dataSource: new kendo.data.DataSource({
			    	    transport: { 
			    	        read:  {
			    	            url: _g_contextPath_+'/budget/selectBudgetList',
			    	            dataType: "json",
			    	            type: 'post'
			    	        },
			    	      	parameterMap: function(data, operation) {
		   	      				data.gb = '2';
		    	      			data.bgtName = $("#bgtName").val();
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
			    	    },
			    	    pageSize : 10
			    	}),
			    	pageable: true,
			        sortable: true,
			        scrollable: true,
			        persistSelection: true,
			        selectable: "multiple",
			        columns:[{
    					title : "예산상위명",
    					field : "HBGT_NM",
    					width : 20
    				},
    				{
    					title : "예산코드",
    					field : "BGT_CD",
    					width : 20
    				},
    				{
    					title : "예산명",
    					field : "BGT_NM",
    					width : 20
    				},
    				{
    					title : "선택",
    					width : 10,
				    	template : '<input type="button" id="" class="text_blue" onclick="bgtSelect(this);" value="선택">'
   		    	    }]
			    }).data("kendoGrid");
				/* 예산 팝업 그리드 */
			},
			eventListener : function() {
				$('#bgtSearchBtn').on('click', function() {
					$('#bgtPopup').data('kendoWindow').open();
				});
				
				$('#applyBtn').on('click', function() {
					applySingle();
				});
				
				$('#applyPopupCancel').on('click', function() {
					$('#upperGrid').data('kendoGrid').dataSource.read(0);
					$("#applyPopup").data("kendoWindow").close();
				});
				
				$('#bgtPopupCancel').on('click', function() {
					$("#bgtPopup").data("kendoWindow").close();
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
				
				$("#bgtSearch").on("click", function() {
					
					 $('#bgtName').val("");
					 $("#bgtPopup").data("kendoWindow").open();
					 projectGridReload();
				});
				
				$("#bgtName").on("keyup", function(e){
					if (e.keyCode === 13) {
						bgtGridReload();
					}
				});
				
				$('#bgtPopupCancel').on('click', function() {
					bgtPopupClose();
				});
			}
	}
	
	function projectSelect(e){		
		var row = $("#projectGrid").data("kendoGrid").dataItem($(e).closest("tr"));
		
		$("#pjtFrom").val(row.PJT_NM);
		$("#pjtFromCd").val(row.PJT_CD);
		$('#upperGrid').data('kendoGrid').dataSource.read(0);
		
		$("#projectPopup").data("kendoWindow").close();
	}
	
	function bgtSelect(e){		
		var row = $("#bgtGrid").data("kendoGrid").dataItem($(e).closest("tr"));
		
		$('#app_bgtCd').val(row.BGT_CD);
		$('#app_bgtNm').val(row.BGT_NM);
		$('#app_hgbtNm').val(row.HBGT_NM);
		
		$("#bgtPopup").data("kendoWindow").close();
	}
	
	function projectPopupClose(){
		 $("#projectPopup").data("kendoWindow").close();
	}
	
	function projectGridReload() {
		$("#projectGrid").data("kendoGrid").dataSource.read();
	}
	
	function bgtPopupClose(){
		 $("#bgtPopup").data("kendoWindow").close();
	}
	
	function bgtGridReload() {
		$("#bgtGrid").data("kendoGrid").dataSource.read();
	}
	
	function mainGridDataBound(e) {
		var grid = e.sender;

		if (grid.dataSource.total() == 0) {
			var colCount = grid.columns.length + 3;
			$(e.sender.wrapper).find('tbody').append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
		}
	}
	
	function searchMainGrid() {
		
		$('#mainGrid').data('kendoGrid').dataSource.read(0);
		$('#upperGrid').data('kendoGrid').dataSource.read(0);
	}
	
	function cancel(param) {
		var row = $("#mainGrid").data("kendoGrid").dataItem($(param).closest("tr"));
		
		$.ajax({
			url : _g_contextPath_+ "/budget/cancelDeptBgt",
			data : makeConvertData(row, 'cancel'),
			async : false,
			type : "POST",
			success : function(result){				
				if (result.OUT_YN === 'Y') {
					alert('취소하였습니다.');
					mainGridReload();
				} else {
					alert(result.OUT_MSG);
				}
			}
		});
	}
	
	function apply(param) {
		
		$('#applyPopup input').not('[type=button]').val('');
		
		$('#app_projectName').val($('#pjtFrom').val());
		
		$("#applyPopup").data("kendoWindow").open();
	}
	
	// 단일 전송
	function applySingle() {
		
		var list = [];
		
		if ($('#app_bgtAmt').val() == '0') {
			alert('예산금액이 0원일 경우 신청할 수 없습니다.');
			return;
		}
		
		var param = {};
		param.coCd = compSeq;
		param.deptSeq = $('#erpDeptSeq').val();
		param.pjtCd = $("#pjtFromCd").val();
		param.bgtCd = $('#app_bgtCd').val();
		param.bgtMonth = $("#standardDate").val().replace(/-/gi,'');
		param.bgtNm = $('#app_bgtNm').val();
		param.parentBgtNm = $('#app_hgbtNm').val();
		param.bgtAmt = $('#app_bgtAmt').val();
		
		list.push(param);
		
		$.ajax({
			url : _g_contextPath_+ "/budget/saveDeptBgt",
			data : { param : JSON.stringify(list) },
			async : false,
			type : "POST",
			success : function(result){				
				if (result.OUT_YN === 'Y') {
// 					selRow.set('BGT_AMT', result.bgtAmt);
// 					selRow.set('BGT_STAT_NM', '저장');
// 					selRow.set('BGT_STAT', '1');
					$('#upperGrid').data('kendoGrid').dataSource.read(0);
					$('#mainGrid').data('kendoGrid').dataSource.read(0);
					$("#applyPopup").data("kendoWindow").close();
					alert('신청하였습니다.');
				} else {
					if (typeof result.OUT_MSG === 'undefined') {
						alert('데이터를 확인해주세요.');
					} else {
						alert(result.OUT_MSG);
					}
				}
			}
		});
	}
	
	function mainGridReload() {
		$('#mainGrid').data('kendoGrid').dataSource.read();
	}
	
	function changeStandardDate() {
		$('#upperGrid').data('kendoGrid').dataSource.read(0);
	}
	
	function makeConvertData(row, flag) {
		
		var paramMap = {};
		
		paramMap.coCd = compSeq;
		paramMap.deptSeq = $('#erpDeptSeq').val();
		paramMap.pjtCd = row.PJT_CD;
		paramMap.bgtCd = row.BGT_CD;
		paramMap.bgtNm = row.BGT_NM;
		paramMap.parentBgtNm = row.HBGT_NM;
		paramMap.bgtMonth = $("#standardDate").val().replace(/-/gi,'');
		
		if (flag === 'single') {
			paramMap.bgtAmt = $('#app_bgtAmt').val();
		} else if (flag === 'multi') {
			paramMap.bgtAmt = row.BGT_AMT;
		}
		
		return paramMap;
	}
	
</script>
<body>
<div class="iframe_wrap">
	<div class="sub_title_wrap" style='height: 15px;'>
		<div class="title_div">
			<h4>예산 세부 내역 신청</h4>
		</div>
	</div>
	
	<div class="sub_contents_wrap">
		<div class="com_ta">
			<div class="top_box gray_box" id = "dataBox">
				<dl>
					<dt>기준년월</dt>
					<dd style="width:20%">
						<input type="text" style="" id = "standardDate" style = "" value="" disabled/>
					</dd>
					<dt>부서</dt>
					<dd style="width:20%">
						<input type="text" style="" id = "deptName" style = "" value="" disabled/>
						<input type="hidden" style="" id = "erpDeptSeq" style = "" value=""/>
					</dd>
					<dt style="">프로젝트</dt>
					<dd style="width:20%">
						<input type="text" style="width:60%" id ="pjtFrom" disabled/>
						<input type="hidden" id ="pjtFromCd"/>
						<button type="button" id ="pjtFromSearch" value="검색" disabled>
						<img style="position:inherit;" src="<c:url value='/Images/btn/search_icon2.png'/>"></button>
					</dd>
				</dl>
			</div>
		</div>
				
		<div class="btn_div mt10 cl">
			<div class="left_div">
				<p class="tit_p mt5 mb0">예산 세부 내역 신청</p>
			</div>
			<div class="right_div">
				<div class="controll_btn p0">
					<button type="button" id="" onclick = "apply()">신청</button>
					<button type="button" id="" onclick = "searchMainGrid()">조회</button>
				</div>
			</div>
		</div>
		
		<div class="com_ta2" style="height: 100px;">
			<div  id = "upperGrid">
			</div>
		</div>
		
		<div class="com_ta2" style="height: 300px;">
			<div  id = "mainGrid">
			</div>
		</div>
	</div>
</div>

<!-- 부서 예산 신청 팝업 -->
<div class="pop_wrap_dir" id="applyPopup" style="width:600px;">
	<div class="pop_head">
		<h1>예산 세부 내역 신청</h1>
	</div>
	<div class="pop_con">
		<div class="top_box">
			<dl>
				<dt class="ar" style="width: 80px;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> 프로젝트</dt>
				<dd style="">
					<input type="text" id="app_projectName" style="width: 245px" disabled/>
				</dd>
			</dl>
			<dl>
				<dt class="ar" style="width: 80px;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> 예산과목</dt>
				<dd style="">
					<button type="button" id ="bgtSearchBtn" value="검색">
					<img style="position:inherit;" src="<c:url value='/Images/btn/search_icon2.png'/>"></button>
					<input type="text" id="app_bgtCd" style="width: 120px" disabled/>
					<input type="text" id="app_bgtNm" style="width: 120px" disabled/>
					<input type="text" id="app_hgbtNm" style="width: 120px" disabled/>
				</dd>
			</dl>
			<dl>
				<dt class="ar" style="width: 80px;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> 예산금액</dt>
				<dd style="">
					<input type="text" id="app_bgtAmt" class="amountUnit" style="width: 120px" numberOnly/>
				</dd>
			</dl>
		</div>
	</div>

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" class="text_btn" id="applyBtn" value="신청" />
			<input type="button" class="text_btn" id="applyPopupCancel" value="닫기" />
		</div>
	</div>
</div>	
<!-- 부서 예산 신청 팝업 -->	

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

<!-- 예산검색팝업 -->
<div class="pop_wrap_dir" id="bgtPopup" style="width:600px;">
	<div class="pop_head">
		<h1>예산 선택</h1>
	</div>
	<div class="pop_con">
		<div class="top_box">
			<dl>
				<dt class="ar" style="width: 80px;">예산 명</dt>
				<dd style="">
					<input type="text" id="bgtName" style="width: 120px" />
				</dd>
				<dd>
					<input type="button" onclick="bgtGridReload();" id="searchButton"	value="검색" />
				</dd>
			</dl>
		</div>
		<div class="com_ta mt15">
			<div id="bgtGrid"></div>
		</div>			
	</div>

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" class="gray_btn" id="bgtPopupCancel" value="닫기" />
		</div>
	</div>
</div>	
<!-- 예산검색팝업 -->

</body>

