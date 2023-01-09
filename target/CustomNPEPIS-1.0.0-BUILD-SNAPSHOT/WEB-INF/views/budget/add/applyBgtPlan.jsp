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
 var deptSeq = '<c:out value="${deptSeq}"/>';
 var deptName = '<c:out value="${deptName}"/>';
 var compSeq = '<c:out value="${compSeq}"/>';
 var selRow = {};
 var projectSelRow = '';
 var $mainGridURL = _g_contextPath_ + "/budget/getBgtPlanGrid";
 var savedFiles = [];
 var delFiles = [];
 
	$(function() {
		Init.ajax();
		
		Init.kendoFunction();
		Init.kendoGrid();
		Init.eventListener();
	})
	
	var Init = {
			ajax : function() {
				$.ajax({
			 		url: _g_contextPath_+"/kukgoh/getErpDeptNum",
			 		dataType : 'json',
			 		data : { deptSeq : deptSeq },
			 		type : 'POST',
			 		async : false,
			 		success: function(result){
			 			$('#erpDeptSeq').val(result.erpDeptSeq);
			 			$('#deptName').val(deptName);
			 		}
			 	});
			},
			kendoFunction : function() {
				/* 프로젝트 팝업 */
				$("#projectPopup").kendoWindow({
				    width: "600px",
				   height: "750px",
				    visible: false,
				    actions: ["Close"]
				}).data("kendoWindow").center();
				/* 프로젝트 팝업 */
				
				$("#applyPopup2").kendoWindow({
				    width: "600px",
				   height: "350px",
				    visible: false,
				    actions: ["Close"]
				}).data("kendoWindow").center();
				
				$("#applyPopup").kendoWindow({
				    width: "600px",
				   height: "350px",
				    visible: false,
				    actions: ["Close"]
				}).data("kendoWindow").center();
				
				$("#endPopup").kendoWindow({
				    width: "600px",
				   height: "500px",
				    visible: false,
				    actions: ["Close"]
				}).data("kendoWindow").center();
				
				$("#standardDate").kendoDatePicker({
				    depth: "year",
				    start: "year",
				    culture : "ko-KR",
					format : "yyyy-MM",
					value : new Date(),
					change : changeStandardDate
				});
				
				$('#filePop').kendoWindow({
				    width: "400px",
				    title: '첨부파일 확인',
				    visible: false,
				    modal : true,
				    actions: [
				        "Close"
				    ],
				}).data("kendoWindow").center();
			},
			
			kendoGrid : function() {
				/* 상단 그리드 */
				var mainGrid = $("#mainGrid").kendoGrid({
					dataSource : new kendo.data.DataSource({
						transport : {
							read : {
								url : $mainGridURL,
								dataType : "json",
								type : 'post'
							},
							parameterMap: function(data, operation) {
		  	      				data.date = $("#standardDate").val().replace(/-/gi,'');
		  	      				data.deptCd = $('#erpDeptSeq').val(); 
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
					height : 700,
					dataBound : mainGridDataBound,
			        columns: [
			        	{ 
			        		headerTemplate : ' ',
			                template : function(dataItem){
			                  if (dataItem.BGT_STAT == 5) { 
			                	  return '<input type="checkbox" class = "mainCheckBox" id="'+dataItem.ORDER_SQ+'">';	                	  
			                  } else {
			                	  return '';
			                  }
			                },
			                width : "15px"
			             },
			        	{	field : "PJT_CD",			title : "프로젝트 코드",	width : 40 },
			        	{	field : "PJT_NM2",			title : "프로젝트 명",	width : 40 },
			        	{	
			        		template : function(data) {
								return Budget.fn_formatMoney(data.BGT_AMT);
							},
							title : "예산금액",
							width : 40
			        	},
		        		{	field : "BGT_STAT_NM",		title : "상태",	width : 40 },
			        	{	field : "BGT_FLAG_NM",		title : "신청유형",	width : 40 },
			        	{
			        		template : function(e) {
			        			return '<input type="button" class="text_blue" style="width: 80px;" onclick="conFirmFileRow(this);" value="확인">';
			        		},
			        		title : '첨부',
			        		width : 40
			        	},
			        	{
			        		template : function(e) {
			        			if (e.BGT_STAT == 0) {
			        				return '<input type="button" class="text_blue" style="width: 80px;" onclick="apply(this);" value="제출">';
			        			} else {
			        				return '';
			        			}
			        		},
			        		title : '제출',
			        		width : 40
			        	},
			        	{
			        		template : function(e) {
			        			if (e.BGT_STAT == 1) {
			        				return '<input type="button" class="text_blue" style="width: 80px;" onclick="cancelApply(this);" value="제출취소">';
			        			} else {
			        				return '';
			        			}
			        		},
			        		title : '제출취소',
			        		width : 40
			        	},
			        	{
			        		template : function(e) {
			        			if (e.BGT_STAT == 2 || e.BGT_STAT == 9) {
			        				return '<input type="button" class="text_blue" style="width: 80px;" onclick="end(this);" value="종료">';
			        			} else {
			        				return '';
			        			}
			        		},
			        		title : '종료',
			        		width : 40
			        	},
			        	{
			        		template : function(e) {
			        			if (e.BGT_STAT == 9) {
			        				return '<input type="button" class="text_blue" style="width: 80px;" onclick="cancelEnd(this);" value="종료취소">';
			        			} else {
			        				return '';
			        			}
			        		},
			        		title : '종료취소',
			        		width : 40
			        	}]
			    }).data("kendoGrid");
				/* 상단 그리드 */
				
				/* 프로젝트 그리드 */
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
		    	      			data.projectNm = $("#projectName").val();
			    	      		data.deptCd = $("#erpDeptSeq").val();
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
			    	dataBound : projectGridDataBound,
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
				/* 프로젝트 그리드 */
				
			},
			eventListener : function() {
				
				$(document).on("click", "#mainGrid tbody tr", function(e) {
					row = $(this)
					grid = $('#mainGrid').data("kendoGrid"),
					dataItem = grid.dataItem(row);
					
					console.log(dataItem);	
				})
				
				// 프로젝트 팝업 관련
				$("#projectFromSearch").on("click", function() {
					
					$('#projectName').val('');
					$('#projectFrom').val('');
						
					$("#projectPopup").data("kendoWindow").open();
				 	$("#projectGrid").data("kendoGrid").dataSource.read();
				 	
				});
				
				$("#projectName").on("keyup", function(e){
					if (e.keyCode === 13) {
						projectGridReload();
					}
				});
				
				$('#projectPopupCancel').on('click', function() {
					$("#projectPopup").data("kendoWindow").close();
				});
				
				// 최종 제출 버튼
				$('#applyBtn').on('click', function() {
					applySingle('apply');
				});
				
				// 변경 신청 제출 버튼
				$('#applyBtn2').on('click', function() {
					applySingle('change');
				});
				
				// 임시저장
				$('#applyTmp').on('click', function() {
					applySingle('tmp');
				});
				
				// 종료 처리 버튼
				$('#endProcess').on('click', function() {
					endProcess();
				});				
				
				// 제출 팝업 닫기
				$('#applyPopupCancel').on('click', function() {
					$("#applyPopup").data("kendoWindow").close();
				});
				
				// 제출 팝업 닫기
				$('#applyPopupCancel2').on('click', function() {
					$("#applyPopup2").data("kendoWindow").close();
				});
				
				// 종료 팝업 닫기
				$('#endPopupCancel').on('click', function() {
					$("#endPopup").data("kendoWindow").close();
				});
				
				// 체크박스 전체선택
				$("#checkboxAll").click(function(e) {
			         if ($("#checkboxAll").is(":checked")) {
			        	 $(".mainCheckBox").prop("checked", true);
			         } else {
			            $(".mainCheckBox").prop("checked", false);
			         }
		      	});
				// 체크박스 단일선택
				$(document).on("click", "#mainGrid tbody tr, #mainGrid tbody tr .mainCheckBox", function(e) {
					
					var clickType = $(this).attr('class');
					if(clickType == 'mainCheckBox'){
						//체크박스 클릭
							
							if($(this).prop("checked")){
								$(".mainCheckBox").prop("checked",false);
								$(this).prop("checked",true);
							
								row = $(this).closest('tr');
								grid = $('#mainGrid').data("kendoGrid");
								dataItem = grid.dataItem(row);

								$('#app_projectName2').val(dataItem.PJT_NM2).attr("readonly",true).removeAttr("disabled");
								$('#app_projectCd2').val(dataItem.PJT_CD);
								$('#app_bgtAmt2').val(dataItem.BGT_AMT).attr("readonly",true).removeAttr("disabled");
								console.log(dataItem.ORDER_SQ);	

							}else{
								$(this).prop("checked",false);
							}
						
					}else{
						//tr클릭
						

						if($(this).prop("checked")){
							$(".mainCheckBox").prop("checked",false);
							$(this).prop("checked",true);
						

						}else{
							$(this).prop("checked",false);
						}
					
					
					}
					
				})
			}
	}
	
	function filepopClose(){
		$('#filePop').data('kendoWindow').close();
	}
	
	function mainGridDataBound(e) {
		var grid = e.sender;

		if (grid.dataSource.total() == 0) {
			var colCount = grid.columns.length + 3;
			$(e.sender.wrapper).find('tbody').append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
		}
	}
	
	function projectGridDataBound(e) {
		var grid = e.sender;

		if (grid.dataSource.total() == 0) {
			var colCount = grid.columns.length + 3;
			$(e.sender.wrapper).find('tbody').append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
		}
	}
	
	function searchMainGrid() {
		$('#applyChangeBtn').css('display', 'inline-block');
		$('#mainGrid').data('kendoGrid').dataSource.transport.options.read.url = $mainGridURL;
		$('#mainGrid').data('kendoGrid').dataSource.read(0);
	}
	
	function changeStandardDate() {
		$('#applyChangeBtn').css('display', 'none');
	}
	
	// 제출 취소
	function cancelApply(param) {
		var row = $("#mainGrid").data("kendoGrid").dataItem($(param).closest("tr"));
		
		$.ajax({
			url : _g_contextPath_+ "/budget/cancelBgtPlan",
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
	
	// 종로 취소
	function cancelEnd(param) {
		var row = $("#mainGrid").data("kendoGrid").dataItem($(param).closest("tr"));
		
		$.ajax({
			url : _g_contextPath_+ "/budget/cancelEndProcess",
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
	
	// 제출 화면 호출
	function apply(param) {
		var row = $("#mainGrid").data("kendoGrid").dataItem($(param).closest("tr"));
		
		$('#app_projectName').val(row.PJT_NM);
		$('#app_bgtAmt').val(Budget.fn_formatMoney(row.BGT_AMT));
		
		$('#fileDiv').empty();
		$('#orgFile').empty();
		savedFiles = [];
		delFiles = [];
		
		$.ajax({
	 		url: _g_contextPath_+"/budget/getFileList",
	 		dataType : 'json',
	 		data : {targetId : row.FILE_ID},
	 		type : 'POST',
	 		success: function(result){
	 			if (result.list.length > 0) {
	 				result.list.forEach(function(v, i) {
		 				$('#fileDiv').append(fileRowTemplate(v.file_name, v.file_seq, 'attach', row.FILE_ID));
		 				savedFiles.push({fileSeq : v.file_seq, realFileName : v.real_file_name, targetId : row.FILE_ID});
	 				})
	 			} else {
	 				$('#fileDiv').append(
 						fileRowTemplate('첨부파일을 등록해주세요.', 0)
 					);
	 			}
	 		}
	 	});
		
// 		if (row.FILE_ID !== '') {
			
// 			$.ajax({
// 		 		url: _g_contextPath_+"/budget/getBudgetAttach",
// 		 		dataType : 'json',
// 		 		data : { targetId : row.FILE_ID },
// 		 		type : 'POST',
// 		 		async : false,
// 		 		success: function(result){
// 		 			if (result.isSucc == 'SUCC') {
// 		 				fileList = result.list;
// 		 			}
// 		 		}
// 		 	});
			
// 			var result = '';
	 		
// 	 		fileList.forEach(function(v, i) {
// 	 			result += fileRowTemplate(v.file_name, v.file_seq, 'confirm', row.FILE_ID);
// 	 		})
	 		
// 	 		$('#fileDiv').append(result);
// 		}
		
		selRow = row;
		
		$("#applyPopup").data("kendoWindow").open();
	}
	
	// 종료	
	function end(param) {
		var row = $("#mainGrid").data("kendoGrid").dataItem($(param).closest("tr"));
		
		$('#end_projectName').val(row.PJT_NM); //프로젝트
		$('#end_bgtAmt').val(Budget.fn_formatMoney(row.BGT_AMT));//예산금액
		$('#end_reAmt').val(Budget.fn_formatMoney(row.RE_AMT));  //반납금액
		$('#end_bfAmt').val(Budget.fn_formatMoney(row.BF_AMT));  //이월금액
		var bgtAmt = $('#end_bgtAmt').val();
		var reAmt = $('#end_reAmt').val();
		var bfAmt =$('#end_bfAmt').val();
		selRow = row;
		
		$.ajax({
			url : _g_contextPath_+ "/budget/callGetPjtBudget",
			data : makeConvertData(selRow, 'call'),
			async : false,
			type : "POST",
			success : function(result){	
				$('#end_amt').val(Budget.fn_formatMoney(result.endAmt));//집행금액
				$('#end_AmtHidden').val(result.endAmt);//집행금액넣어주기 
				var end_amt = result.endAmt;
				var ee= Number(bgtAmt)- Number(end_amt)-Number(bfAmt)-Number(reAmt); //잔액 계산식
				if(isNaN(ee) ){ee = 0;};
				$('#end_laAmt').val(Budget.fn_formatMoney(ee));//잔액
				$('#end_laAmtHidden').val(row.BGT_AMT);//예산Hidden태그 
			}
		});
		
		$("#endPopup").data("kendoWindow").open();
	}
	
	// 종료 처리	
	function endProcess(param) {
		
		$.ajax({
			url : _g_contextPath_+ "/budget/saveEndProcess",
			data : makeConvertData(selRow, 'end'),
			async : false,
			type : "POST",
			success : function(result){				
				if (result.OUT_YN === 'Y') {
					selRow.set('BF_AMT', $('#end_bfAmt').val());
					selRow.set('RE_AMT', $('#end_reAmt').val());
					$("#endPopup").data("kendoWindow").close();
					alert('종료처리하였습니다.');
					mainGridReload();
				} else {
					alert(result.OUT_MSG);
				}
			}
		});
	}
	
	// 단일 전송
	function applySingle(bgtStat) {
		
		// 빈 파일 검사
		$('#orgFile').children().each(function(i, v){
			if (v.files.length === 0){
				$(v).remove();
			}
		});
		
		var flag = false;
		
		if ($('#app_bgtAmt').val() == '0' && bgtStat != 'change') {
			alert('예산금액이 0원일 경우 신청할 수 없습니다.');
			return;
		} else if ($('#app_bgtAmt2').val() == '0' && bgtStat == 'change') {
			alert('예산금액이 0원일 경우 신청할 수 없습니다.');
			return;
		}
		
		if ($("#orgFile").children().length === 0 && savedFiles.length === 0) {
			alert('첨부파일이 없습니다.');
			return;
		}
		
		$.ajax({
			url : _g_contextPath_+ "/budget/saveBgtPlan",
			data : makeConvertData(selRow, 'single', bgtStat),
			async : false,
			type : "POST",
			processData : false,
			contentType : false,
			success : function(result){				
				if (result.OUT_YN === 'Y') {
					$("#applyPopup").data("kendoWindow").close();
					$("#applyPopup2").data("kendoWindow").close();
					alert('신청하였습니다.');
					mainGridReload();
				} else {
					alert(result.OUT_MSG);
				}
			}
		});
	}
	
	function mainGridReload() {
		$('#mainGrid').data('kendoGrid').dataSource.read();
	}
	
	function makeConvertData(row, flag, bgtStat) {
		
		if (flag === 'single' && bgtStat !== 'change') { // 단건제출
			var form = new FormData($("#fileForm")[0]);
			
			var bgtStat = (bgtStat === 'apply') ? '1' : '0';
			
			form.append('coCd', row.CO_CD);
			form.append('delFiles', JSON.stringify(delFiles));
			form.append('deptCd', row.DEPT_CD);
			form.append('pjtCd', row.PJT_CD);
			form.append('bgtMonth', $("#standardDate").val().replace(/-/gi,''));
			form.append('bgtAmt', $('#app_bgtAmt').val().replace(/\,/gi,''));
			form.append('fileId', row.FILE_ID);
			form.append('orderSq', row.ORDER_SQ + $("#standardDate").val().replace(/-/gi,'').substring(4, 6));
			form.append('bgtStat', bgtStat);
			form.append('bgtFlag', '1');
			form.append('flag', flag);
			
			return form;
		} else if (flag === 'single' && bgtStat == 'change') {
			var form = new FormData($("#fileForm")[0]);
			
			var bgtStat = (bgtStat === 'change') ? '1' : '0';
			
			form.append('coCd', '5000');
			form.append('delFiles', JSON.stringify(delFiles));
			form.append('deptCd', $('#erpDeptSeq').val());
			form.append('pjtCd', $('#app_projectCd2').val());
			form.append('bgtMonth', $("#standardDate").val().replace(/-/gi,''));
			form.append('bgtAmt', $('#app_bgtAmt2').val().replace(/\,/gi,''));
			form.append('fileId', selRow.ORDER_SQ + $("#standardDate").val().replace(/-/gi,'').substring(4, 6));
			form.append('orderSq', selRow.ORDER_SQ + $("#standardDate").val().replace(/-/gi,'').substring(4, 6));
			form.append('bgtStat', bgtStat);
			form.append('bgtFlag', '2');
			form.append('flag', flag);
			
			return form;
		} else if (flag === 'cancel') { // 제출취소
			var param = {};
			
			param.coCd = row.CO_CD;
			param.deptCd = row.DEPT_CD;
			param.pjtCd = row.PJT_CD;
			param.bgtMonth = $("#standardDate").val().replace(/-/gi,'');
			
			return param;
		} else if (flag === 'end') { // 종료
			var param = {};
			
			param.coCd = row.CO_CD;
			param.deptCd = row.DEPT_CD;
			param.pjtCd = row.PJT_CD;
			param.bgtMonth = $("#standardDate").val().replace(/-/gi,'');
			param.bfAmt = $('#end_bfAmt').val().replace(/\,/gi,'') === "" ? 0 : $('#end_bfAmt').val().replace(/\,/gi,'');
			param.reAmt = $('#end_reAmt').val().replace(/\,/gi,'') === "" ? 0 : $('#end_reAmt').val().replace(/\,/gi,'');
			
			return param;
		} else if (flag === 'call') { // 집행금액 함수 호출
			var param = {};
			
			param.coCd = row.CO_CD;
			param.pjtCd = row.PJT_CD;
			param.month = $("#standardDate").val().replace(/-/gi,'').substring(0,4) + '12';
			param.div = '3';
			
			return param;
		} else { // 일괄제출
			var param = {};
			
			param.coCd = row.CO_CD;
			param.deptCd = row.DEPT_CD;
			param.pjtCd = row.PJT_CD;
			param.bgtMonth = $("#standardDate").val().replace(/-/gi,'');
			param.bgtAmt = $('#app_bgtAmt').val().replace(/\./gi,'');
			param.fileId = row.FILE_ID;
			param.orderSq = row.ORDER_SQ + $("#standardDate").val().replace(/-/gi,'').substring(4, 6);
			param.bgtStat = bgtStat === 'apply' ? '1' : '0';
			param.flag = flag;
			
			return param;
		} 
	}
	
	function fileRow(targetId) {
		
		if ($("#fileForm")[0].length === 0 && $('#fileDiv tr').length === 0) {
		 	$('#fileDiv').append(
				fileRowTemplate('첨부파일을 등록해주세요.', 0)
			);
	 	}
		
	 	$('#insertFileBtn').css('display', 'block');
	 	$('#filePop').data("kendoWindow").open();
	}
	
	function conFirmFileRow(targetId) {
		
		$('#fileDiv').empty();
		
		var row = $("#mainGrid").data("kendoGrid").dataItem($(targetId).closest("tr"));
		var fileList = [];		
		
		if (row.FILE_ID !== '') {
			
		 	/* ajax로 파일 리스트 불러오기*/
		 	$.ajax({
		 		url: _g_contextPath_+"/budget/getBudgetAttach",
		 		dataType : 'json',
		 		data : { targetId : row.FILE_ID },
		 		type : 'POST',
		 		async : false,
		 		success: function(result){
		 			if (result.isSucc == 'SUCC') {
		 				fileList = result.list;
		 			}
		 		}
		 	});
		}		
	 	
	 	if (fileList.length > 0) { // 파일 존재
	 		
	 		var result = '';
	 		
	 		fileList.forEach(function(v, i) {
	 			result += fileRowTemplate(v.file_name, v.file_seq, 'confirm', row.FILE_ID);
	 		})
	 		
	 		$('#fileDiv').append(result);
	 	} else {
		 	$('#fileDiv').append(
				fileRowTemplate('첨부파일을 등록해주세요.', 0)
			);
	 	}
	 	
	 	$('#insertFileBtn').css('display', 'none');
	 	$('#filePop').data("kendoWindow").open();
	}
	
	function addFile(e) {
		if ($('.fileBoxTr:eq(0)').data('flag') == '0') {
			$('#fileDiv').empty();
		}
		
		var $this = $(e);
		var $fileBoxTr = $('.fileBoxTr');
		var fileNm = $this.val().substr($this.val().lastIndexOf('\\') + 1, $this.val().length);
		var idx = Number($('.fileBoxTr').eq($fileBoxTr.length - 1).data('flag')) + 1
		
		$('#fileDiv').append(fileRowTemplate(fileNm, idx));
		
		var agent = navigator.userAgent.toLowerCase();

		if ( (navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1) ) {
			$("#fileID").replaceWith( $("#fileID").clone(true) );
		} else {
			$("#fileID").val('');
		}
	}
	
	function fileRowTemplate(fileNm, idx, flag, targetId) {
		
		var $targetId = targetId;
		if (typeof targetId === 'undefined') {
			$targetId = '';
		}
		
		var result = '';
		var color = (idx == '0') ? '#808080' : '#0033FF'; // idx가 0일 경우 첨부파일 없음 상태
		
		result += '<tr class="fileBoxTr" data-flag="' + idx + '" data-targetid="' + $targetId + '" style="height: 30px;">'
		result += '<td class="fileBoxTd" style="width:250px;">';
		result +=	'<span class="mr20">'	;
		result += '<img src="<c:url value="/Images/ico/ico_clip02.png"/>" alt="" />';
		result +=	'<a href="#n" style="color:' + color + ';" id="fileText' + idx + '" onclick="fileDownload(this)">&nbsp;' + fileNm;
		result +=	'</a>';
		if (flag !== 'confirm') {
			result += '<a href="javascript:delFile(\'' + idx + '\')" style="margin-left: 11px;"><img src="<c:url value="/Images/btn/btn_del_reply.gif"/>" /></a>';			
		}
		result +=	'</span>';
		result +=  '</td>';
		result +=  '</tr>';
		
		return result;
	}
	
	function delFile(idx) {
		
		$('[data-flag=' + idx + ']').remove();
		$('#fileID' + idx).remove();
		
		savedFiles = savedFiles.filter(function(v) { // 기존 파일중 delete 된 파일들 선별
			if (v.fileSeq == idx) {
				delFiles.push(v);
				return false;
			} else {
				return true;
			}
		});
	}
	
	function upFile() {
		
		var idx = 0;
		
		if ($('#orgFile').children().length > 0) {
			idx = Number($('#orgFile').children().last().attr('name').split('fileNm')[1]) + 1;	
		} else {
			savedFiles.forEach(function(v, i){
				idx = idx < v.fileSeq ? v.fileSeq : idx;
			});
		}
		
		/* 파일 창만 열고 파일을 선택하지 않고 닫을 경우 생성되는 input 처리 */
		if ($('#orgFile').children().length !== 0 && $('#fileID' + (idx - 1))[0].files.length < 1) { // 기존 file 태그 다시 클릭
			idx--;
		} else { // 새로 file 태그 생성
			var html = '<input type="file" id="fileID' + idx + '" name="fileNm' + idx +'" value="" onChange="addFile(this);" class="hidden" />';
			$('#orgFile').append(html);
		}
		
		$("#fileID" + idx).click();
	}
	
	function fileDownload(param) {
		var data = {};
		var $this = $(param);
		
		data.fileSeq = $this.attr('id').substring(8);
		data.targetId = $this.closest('tr').data('targetid');
		
		$.ajax({
			url : _g_contextPath_+'/budget/fileDownLoad',
			type : 'get',
			data : data,
		}).success(function(result) {
			var downWin = window.open('','_self');
			downWin.location.href = _g_contextPath_+"/budget/fileDownLoad?targetId="+data.targetId+'&fileSeq='+data.fileSeq;
		});
	}
	
	function applyChange() {
		
		if($('input:checkbox[class=mainCheckBox]').is(":checked") == true){
			
 		/* $('#app_projectName2').val(''); //텍스트
		$('#app_projectCd2').val('');   //히든
		$('#app_bgtAmt2').val('');      //예산금액  */
		//$('#fileDiv').empty();          //첨부
		$("#applyPopup2").data("kendoWindow").open();
		
		}else{
			
			alert("선택된 프로젝트가 없습니다.");
		}
	}
	
	function projectGridReload() {
		$("#projectGrid").data("kendoGrid").dataSource.read();
	}
	
	function projectSelect(e){
		var row = $("#projectGrid").data("kendoGrid").dataItem($(e).closest("tr"));
		
		$('#fileDiv').empty();
		$('#orgFile').empty();
		savedFiles = [];
		delFiles = [];
		
		selRow.PJT_CD = row.PJT_CD;
		selRow.ORDER_SQ = $('#erpDeptSeq').val() + row.PJT_CD;
		
		$("#app_projectName2").val(row.PJT_NM);
		$("#app_projectCd2").val(row.PJT_CD);
		
		$.ajax({
	 		url: _g_contextPath_+"/budget/getFileList",
	 		dataType : 'json',
	 		data : {targetId : selRow.ORDER_SQ + $("#standardDate").val().replace(/-/gi,'').substring(4, 6)},
	 		type : 'POST',
	 		success: function(result){
	 			if (result.list.length > 0) {
	 				result.list.forEach(function(v, i) {
		 				$('#fileDiv').append(fileRowTemplate(v.file_name, v.file_seq, 'attach', selRow.ORDER_SQ + $("#standardDate").val().replace(/-/gi,'').substring(4, 6)));
		 				savedFiles.push({fileSeq : v.file_seq, realFileName : v.real_file_name, targetId : selRow.ORDER_SQ + $("#standardDate").val().replace(/-/gi,'').substring(4, 6)});
	 				})
	 			} else {
	 				$('#fileDiv').append(
 						fileRowTemplate('첨부파일을 등록해주세요.', 0)
 					);
	 			}
	 		}
	 	});
		
		$("#projectPopup").data("kendoWindow").close();
	}
	
	//이월 금액 , 반납금액 바뀔시 잔액인풋에 반영
	
	 $(function(){

		$('input.num_only').on('keyup',function(){  
		          var cnt = $(".top_box input.num_only").length;     

		          for( var i=1; i< cnt; i++){
				     var sum = parseInt($(this).val() || 0 );
				     sum++
				  } 
		            var sum1 = parseInt($("#end_reAmt").val() || 0 ); 
		            var sum2 = parseInt($("#end_bfAmt").val() || 0);
		            var sum3 = parseInt($("#end_AmtHidden").val() || 0);

		            var sum = Number($('#end_laAmtHidden').val())-(sum1 + sum2 + sum3) ;
		            
		            if(isNaN(sum)){ sum = 0;}
		            $('#end_laAmt').val(Budget.fn_formatMoney(sum));
		        });


		 
	});
	

</script>
<body>
<div class="iframe_wrap">
	<div class="sub_title_wrap">
		<div class="title_div">
			<h4>예산 기본계획 제출</h4>
		</div>
	</div>
	
	<div class="sub_contents_wrap">
		<div class="com_ta">
			<div class="top_box gray_box" id = "dataBox">
				<dl>
					<dt>기준년월</dt>
					<dd style="width:35%">
						<input type="text" style="width:40%" id = "standardDate" style = "" value=""/>
					</dd>
					<dt>부서</dt>
					<dd style="width:35%">
						<input type="text" style="" id = "deptName" style = "" value="" disabled/>
						<input type="hidden" style="" id = "erpDeptSeq" style = "" value=""/>
					</dd>
				</dl>
			</div>
		</div>
				
		<div class="btn_div mt10 cl">
			<div class="left_div">
				<p class="tit_p mt5 mb0">예산 기본계획 신청</p>
			</div>
			<div class="right_div">
				<div class="controll_btn p0">
					<button type="button" id="applyChangeBtn" onclick = "applyChange()">변경신청</button>
					<button type="button" id="" onclick = "searchMainGrid()">조회</button>
				</div>
			</div>
		</div>
		
		<div class="com_ta2" style="height: 700px;">
			<div  id = "mainGrid">
			</div>
		</div>
	</div>
</div>

<!-- 제출 팝업 -->
<div class="pop_wrap_dir" id="applyPopup" style="width:600px;">
	<div class="pop_head">
		<h1>예산 기본계획 신청</h1>
	</div>
	<div class="pop_con">
		<div class="top_box">
			<dl>
				<dt class="ar" style="width: 80px;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> 프로젝트</dt>
				<dd style="">
					<input type="text" id="app_projectName" style="width: 400px" disabled/>
				</dd>
			</dl>
			<dl>
				<dt class="ar" style="width: 80px;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> 예산금액</dt>
				<dd style="">
					<input type="text" id="app_bgtAmt" class="amountUnit" style="width: 120px" numberOnly/>
				</dd>
			</dl>
			<dl>
				<dt class="ar" style="width: 80px;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> 첨부</dt>
				<dd style="">
					<input type="button"  class=""   style="width:80px; background: #ebebe4;color: #474242; border:;"name="attachFile" id="attachFile"  onclick="fileRow(this);" value="첨부">
					<img id="attachFileYn" src ="<c:url value="/Images/ico/ico_clip02.png"/>"/>
				</dd>
			</dl>
		</div>
	</div>

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" class="text_btn" id="applyTmp" value="임시저장" />
			<input type="button" class="text_btn" id="applyBtn" value="제출" />
			<input type="button" class="text_btn" id="applyPopupCancel" value="닫기" />
		</div>
	</div>
</div>	
<!-- 제출 팝업 -->

<!-- 종료 팝업 -->
<div class="pop_wrap_dir" id="endPopup" style="width:600px;">
	<div class="pop_head">
		<h1>예산 기본계획 종료</h1>
	</div>
	<div class="pop_con">
		<div class="top_box">
			<dl>
				<dt class="ar" style="width: 80px;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> 프로젝트</dt>
				<dd style="">
					<input type="text" id="end_projectName" style="width: 400px" disabled/>
				</dd>
			</dl>
			<dl>
				<dt class="ar" style="width: 80px;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> 예산금액</dt>
				<dd style="">
					<input type="text" id="end_bgtAmt" style="width: 120px" disabled/>
				</dd>
			</dl>
			<dl>
				<dt class="ar" style="width: 80px;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> 집행금액</dt>
				<dd style="">
					<input type="text" id="end_amt" style="width: 120px" disabled/>
				</dd>
			</dl>
			<dl>
				<dt class="ar" style="width: 80px;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> 이월금액</dt>
				<dd style="">
					<input type="text" class="amountUnit num_only" id="end_bfAmt" style="width: 120px" numberOnly/>
				</dd>
			</dl>
			<dl>
				<dt class="ar" style="width: 80px;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> 반납금액</dt>
				<dd style="">
					<input type="text" class="amountUnit num_only" id="end_reAmt" style="width: 120px" numberOnly/>
				</dd>
			</dl>
			<dl>
				<dt class="ar" style="width: 80px;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> 잔액</dt>
				<dd style="">
					<input type="text" class="amountUnit num_only" id="end_laAmt" style="width: 120px" numberOnly disabled/>
					<input type="hidden" class="amountUnit num_only" id="end_laAmtHidden" style="width: 120px" numberOnly/>
					<input type="hidden" class="amountUnit num_only" id="end_AmtHidden" style="width: 120px" numberOnly/>
				</dd>
			</dl>
		</div>
	</div>

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" class="text_btn" id="endProcess" value="종료처리" />
			<input type="button" class="text_btn" id="endPopupCancel" value="닫기" />
		</div>
	</div>
</div>	
<!-- 종료 팝업 -->		

<!-- 첨부파일 팝업 -->
	<div class="pop_wrap_dir" id="filePop" style="width:400px; display: none;">
		<div class="pop_con">
			<!-- 타이틀/버튼 -->
			<div class="btn_div mt0">
				<div class="right_div">
					<input type="button" id = "insertFileBtn" onclick="upFile();" value="첨부파일 등록"/>
				</div>
			</div>
			<div class="btn_div mt0" style="height: 100%;">
				<div class="left_div"  style="width: 120px;">
					<h5><span id="popupTitle"></span> 첨부파일</h5>
				</div>
			<div style="height: 100%;">
				<table id="fileDiv"></table>
				<div class="le" id="addfileID">
				</div>	
			</div>
			<form id="fileForm" method="post" enctype="multipart/form-data" >
			<div class="">
				<span id="orgFile">
				</span>			
			</div>
			</form>
		</div>
	</div>
	<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" class="gray_btn" value="닫기" onclick="filepopClose();"/>
			</div>
		</div><!-- //pop_foot -->
	</div>	
<!-- 첨부파일 팝업 -->

<!-- 변경 신청 팝업 -->
<div class="pop_wrap_dir" id="applyPopup2" style="width:600px;">
	<div class="pop_head">
		<h1>예산 기본계획 신청</h1>
	</div>
	<div class="pop_con">
		<div class="top_box">
			<dl>
				<dt class="ar" style="width: 80px;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> 프로젝트</dt>
				<dd style="">
					<input type="text" id="app_projectName2" style="width: 250px" disabled/>
					<input type="hidden" id="app_projectCd2" style="width: 250px" disabled/>
					<input type="button" class="blue_btn" id="projectFromSearch" value="검색"/>
				</dd>
			</dl>
			<dl>
				<dt class="ar" style="width: 80px;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> 예산금액</dt>
				<dd style="">
					<input type="text" id="app_bgtAmt2" class="amountUnit" style="width: 120px" numberOnly/>
				</dd>
			</dl>
			<dl>
				<dt class="ar" style="width: 80px;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> 첨부</dt>
				<dd style="">
					<input type="button"  class=""   style="width:80px; background: #ebebe4;color: #474242; border:;"name="attachFile" id="attachFile"  onclick="fileRow(this);" value="첨부">
					<img id="attachFileYn" src ="<c:url value="/Images/ico/ico_clip02.png"/>"/>
				</dd>
			</dl>
		</div>
	</div>

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" class="text_btn" id="applyBtn2" value="제출" />
			<input type="button" class="text_btn" id="applyPopupCancel2" value="닫기" />
		</div>
	</div>
</div>	
<!-- 변경 신청 팝업 -->

<!-- 프로젝트검색팝업 -->
<div class="pop_wrap_dir" id="projectPopup" style="width:600px;">
	<div class="pop_head">
		<h1>프로젝트 선택</h1>
	</div>
	<div class="pop_con">
		<div class="top_box">
			<dl>
				<dt class="ar" style="width: 80px;">프로젝트 명</dt>
				<dd style="margin-right : 70px;">
					<input type="text" id="projectName" style="width: 120px" />
				</dd>
				<dd>
					<input type="button" onclick="projectGridReload();" id="searchButton"	value="검색" />
				</dd>
			</dl>
		</div>
		<div class="com_ta mt15" style="height: 500px;">
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

