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
 var delFiles = [];
 var savedFiles = [];
 
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
		   	      				data.month = $("#standardDate").val().replace(/-/gi, '');
		    	      			data.projectCd = $("#pjtFromCd").val();
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
	    				{
			        		template : function(dataItem) {
			        			return '<input type="button" class="text_blue" style="width: 30px;" onclick="conFirmFileRow(this);" value="확인">';
			        		},
			        		title : '첨부',
			        		width : 30
			        	},
	    				
    				]
			    }).data("kendoGrid");
				/* 상단 예산현황 그리드 */
				
				/* 하단 그리드 */
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
		  	      				data.deptSeq = $('#erpDeptSeq').val();
		  	      				data.pjtCd = $('#pjtFromCd').val();
		    	     			return data;
		    	     		}
						},
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
			        	},
			        	{
			        		template : function(data) {
			        			return data.MODIFY_DTT;
			        		},
			        		title : '신청일시',
			        		width : 30
			        	},
 			        	{
			        		template : function(data) {
			        			return data.empName;
			        		},
			        		title : '신청직원',
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
				$(document).on("click", "#upperGrid tbody tr", function(e) {
					row = $(this)
					grid = $('#upperGrid').data("kendoGrid"),
					dataItem = grid.dataItem(row);
					
					$('#pjtFileId').val(dataItem.FILE_ID2);
				});
				$('#bgtSearchBtn').on('click', function() {
					$('#bgtPopup').data('kendoWindow').open();
				});
				
				$('#applyBtn').on('click', function() {
					applySingle();
				});
				$('#applySaveButton').on('click', function() {
					applySingleB('apply');
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
		first = false;
		$('#mainGrid').data('kendoGrid').dataSource.transport.options.read.url = $mainGridURL;
		
		if ($('#pjtFromCd').val().length < 1) {
			alert('프로젝트를 선택해 주세요.');
			return;
		}
		
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
		
		if ($('#pjtFromCd').val().length < 1) {
			alert('프로젝트를 선택해 주세요.');
			return;
		}
		
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
		param.bgtAmt = $('#app_bgtAmt').val().replace(/,/gi,'');;
		
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
			paramMap.bgtAmt = $('#app_bgtAmt').val().replace(/\,/gi,'');
		} else if (flag === 'multi') {
			paramMap.bgtAmt = row.BGT_AMT;
		}
		
		return paramMap;
	}
	
	//////////////////////////////////////////////////////////////////////여기서부터 첨부
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
	function makeConvertDataB(row, flag, bgtStat) {
		
		if (flag === 'single' && bgtStat !== 'change') { // 단건제출
			var form = new FormData($("#fileForm")[0]);
			
			var bgtStat = (bgtStat === 'apply') ? '1' : '0';
			
			form.append('coCd', compSeq);
			form.append('delFiles', JSON.stringify(delFiles));
			form.append('deptCd', '1281');
			form.append('pjtCd', $('#pjtFromCd').val());
			form.append('bgtMonth', $("#standardDate").val().replace(/-/gi,''));
			//form.append('bgtAmt', $('#pjtBgtAmt').val());
			//form.append('fileId', $('#FileId').val());
			//form.append('orderSq', $('#pjtOrderSq').val() + $("#standardDate").val().replace(/-/gi,'').substring(4, 6));
			//form.append('bgtStat', bgtStat);
			//form.append('bgtFlag', '1');
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
		}  else { // 일괄제출
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
function filepopClose(){
	$('#filePop').data('kendoWindow').close();
}
	//첨부컬럼 확인 버튼
function conFirmFileRow(targetId) {
		
		$("#orgFile").empty();
	 		
		$('#fileDiv').empty();
		var row = $("#upperGrid").data("kendoGrid").dataItem($(targetId).closest("tr"));
		var fileList = [];		
		savedFiles = [];
		
		  if (row.FILE_ID2 !== '') {
			  
			  $.ajax({
			 		url: _g_contextPath_+"/budget/getFileList",
			 		dataType : 'json',
			 		data : {targetId : row.FILE_ID2},
			 		type : 'POST',
			 		success: function(result){
			 			if (result.list.length > 0) {
			 				result.list.forEach(function(v, i) {
				 				savedFiles.push({fileSeq : v.file_seq, realFileName : v.real_file_name, targetId : row.FILE_ID2});
			 				})
			 			} else {
			 			}
			 		}
			 	});
			
		 	 $.ajax({
		 		url: _g_contextPath_+"/budget/getBudgetAttach",
		 		dataType : 'json',
		 		data : { targetId :row.FILE_ID2 },
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
	 			result += fileRowTemplate(v.file_name, v.file_seq, '', row.FILE_ID2);
	 		})
	 		
	 		$('#fileDiv').append(result);
	 	} else {
		 	$('#fileDiv').append(
				fileRowTemplate('첨부파일을 등록해주세요.', 0,'confirm')
			);
	 	}
	 	
	 	$('#insertFileBtn').css('display', 'block');
	 	$('#filePop').data("kendoWindow").open();
	}
	//단일 전송
		function applySingleB(bgtStat) {
			
			// 빈 파일 검사
			$('#orgFile').children().each(function(i, v){
				if (v.files.length === 0){
					$(v).remove();
				}
			});
			
			var flag = false;
			
			if ($("#orgFile").children().length === 0 && savedFiles.length === 0 && delFiles.length === 0 ) {
				alert('첨부파일이 없습니다.');
				return;
			}
			
			$.ajax({
				url : _g_contextPath_+ "/budget/saveBgtPlanDept",
				data : makeConvertDataB(selRow, 'single', bgtStat),
				async : false,
				type : "POST",
				processData : false,
				contentType : false,
				success : function(result){				
					if (result.OUT_YN === 'Y') {
						alert('신청하였습니다.');
						$("#filePop").data("kendoWindow").close();
						mainGridReload();
					} else {
						alert(result.OUT_MSG);
					}
				}
			});
		}
	
		
</script>
<body>
<div class="iframe_wrap">
	<div class="sub_title_wrap">
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
						<input type="text" style="" id = "standardDate" style = "" value=""/>
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
						<input type="hidden" id ="pjtFileId"/>
						<input type="hidden" id ="pjtBgtAmt"/>
						<input type="hidden" id ="pjtBgtStat"/>
						<input type="hidden" id ="pjtCoCd"/>
						<input type="hidden" id ="pjtDeptCd"/>
						<input type="hidden" id ="pjtOrderSq"/>
						<button type="button" id ="pjtFromSearch" value="검색">
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
		
		<div class="com_ta2" style="height: 700px;">
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
					<input type="text" class="amountUnit" id="app_bgtAmt" style="width: 120px" numberOnly/>
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
				<input type="button" class="gray_btn" value="저장" id="applySaveButton"/>
				<input type="button" class="gray_btn" value="닫기" onclick="filepopClose();"/>
			</div>
		</div><!-- //pop_foot -->
	</div>	
<!-- 첨부파일 팝업 -->
</body>

