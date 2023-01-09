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
 var deptComboList = '';
 var statusComboList = '';
 var selRow = '';
 var $mainGridURL = _g_contextPath_ + "/budget/getBgtConfirmGrid";
 
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
			 		data : { year : moment().format('YYYY'), deptName : '' },
			 		type : 'POST',
			 		async : false,
			 		success: function(result){
			 			deptComboList = result;
			 		}
			 	});
				
				$.ajax({
			 		url: _g_contextPath_+"/budget/getPjtStatus",
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
				
				$("#dept").kendoComboBox({
				      dataSource: deptComboList.resolutionDeptList,
				      dataTextField: "DEPT_NM",
					  dataValueField: "DEPT_CD",
					  height : 500,
					  index : 0,
				});
				
				$("#status").kendoComboBox({
				      dataSource: statusComboList.list,
				      dataTextField: "BGT_STAT_NM",
					  dataValueField: "BGT_STAT",
					  height : 500,
					  index : 0,
				});
				
				$("#standardDate").kendoDatePicker({
				    depth: "year",
				    start: "year",
				    culture : "ko-KR",
					format : "yyyy-MM",
					value : new Date(),
					change: function(e) {
						
						$.ajax({
					 		url: _g_contextPath_+"/budget/searchDeptList3",
					 		dataType : 'json',
					 		data : { year : $("#standardDate").val().substring(0, 4), deptName : '' },
					 		type : 'POST',
					 		async : false,
					 		success: function(result){
					 			deptComboList = result;
					 			
					 			$("#dept").data("kendoComboBox").setDataSource(result.resolutionDeptList);
					 		}
					 	});
				  	}
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
								url : _g_contextPath_+"/budget/initGrid",
								dataType : "json",
								type : 'post'
							},
							parameterMap: function(data, operation) {
		  	      				data.date = $("#standardDate").val().replace(/-/gi,'');
		  	      				data.deptCd =  $('#dept').data('kendoComboBox').value();
		  	      				data.bgtStat = $('#status').data('kendoComboBox').value();
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
			        	{	field : "DEPT_NM",				title : "부서",	width : 40 },
			        	{	field : "PJT_CD",				title : "프로젝트 코드",	width : 40 },
			        	{	field : "PJT_NM2",				title : "프로젝트 명",	width : 40 },
			        	{	
			        		template : function(data) {
								return Budget.fn_formatMoney(data.BGT_AMT);
							},
							title : "예산금액",
							width : 40
			        	},
			        	{	field : "BGT_STAT_NM",				title : "상태",	width : 40 },
			        	{	
			        		template : function(data) {
								return Budget.fn_formatMoney(data.EXE_AMT);
							},
							title : "집행금액",
							width : 40
			        	},
			        	{	
			        		template : function(data) {
								return Budget.fn_formatMoney(data.BF_AMT);
							},
							title : "이월금액",
							width : 40
			        	},
			        	{	
			        		template : function(data) {
								return Budget.fn_formatMoney(data.RE_AMT);
							},
							title : "반납금액",
							width : 40
			        	},
			        	{
			        		template : function(e) {
			        			return '<input type="button" class="text_blue" style="width: 80px;" onclick="conFirmFileRow(this);" value="확인">';
			        		},
			        		title : '첨부',
			        		width : 40
			        	},
			        	{
			        		template : function(e) {
			        			if (e.BGT_STAT == 2) {
			        				return '<input type="button" class="text_blue" style="width: 80px;" onclick="cancelConfirm(this);" value="확정취소">';
			        			} else {
			        				return '';
			        			}
			        		},
			        		title : '확정취소',
			        		width : 40
			        	}]
			    }).data("kendoGrid");
				/* 상단 그리드 */
				
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
				
				$(document).on("click", "#mainGrid tbody tr", function(e) {
					row = $(this)
					grid = $('#mainGrid').data("kendoGrid"),
					dataItem = grid.dataItem(row);
					
					console.log(dataItem);	
				})
			}
	}
	
	function cancelConfirm(param) { // 확정취소
		
		var row = $('#mainGrid').data('kendoGrid').dataItem($(param).closest('tr'));
		
		$.ajax({
			url : _g_contextPath_+ "/budget/cancelConfirmBgtPlan",
			data : makeConvertData(row, 'cancel'),
			async : false,
			type : "POST",
			success : function(result){				
				if (result.OUT_YN === 'Y') {
					alert('종료취소하였습니다.');	
					mainGridReload();
				} else {
					alert(result.OUT_MSG);
				}
			}
		});
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
	
	function searchMainGrid() {
		$('#mainGrid').data('kendoGrid').dataSource.transport.options.read.url = $mainGridURL;
		$('#mainGrid').data('kendoGrid').dataSource.read(0);
	}
	
	// 일괄 확정
	function confirmMultiple() {
		var list = [];
		
		$(".mainCheckBox:checked").each(function(i, v) {
			
			var rows = $("#mainGrid").data("kendoGrid").dataItem($(v).closest("tr"));
			
			list.push(makeConvertData(rows, 'multi'));
		});
		
		if (list.length === 0) return;
		
		$.ajax({
			url : _g_contextPath_+ "/budget/confirmBgtPlan",
			data : { param : JSON.stringify(list) },
			async : false,
			type : "POST",
			success : function(result){				
				if (result.OUT_YN === 'Y') {
					alert('확정하였습니다.');	
					mainGridReload();
				} else {
					alert('확정하였습니다');
					mainGridReload();
				}
			}
		});
	}
	
	function mainGridReload() {
		$('#mainGrid').data('kendoGrid').dataSource.read();
	}
	
	function makeConvertData(row, flag) {
		var param = {};
		
		param.coCd = row.CO_CD;
		param.deptCd = row.DEPT_CD;
		param.pjtCd = row.PJT_CD;
		param.bgtMonth = $('#standardDate').val().replace(/-/gi,'');
		
		if (flag === 'multi') {
			
		} else if (flag === 'cancel') {
			
		}
		
		return param
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
		
		var clone = $(e).clone();
		clone.attr('id', 'file' + ($fileBoxTr.length + 1)).attr('name', 'fileNm' + ($fileBoxTr.length + 1));
		$('#fileForm').append(clone);
		var idx = Number($('.fileBoxTr').eq($fileBoxTr.length - 1).data('flag')) + 1
		$('#fileDiv').append(fileRowTemplate(fileNm, idx));
	}
	
	function fileRowTemplate(fileNm, idx, flag, targetId) {
		
		var $targetId = targetId;
		if (typeof targetId === 'undefined') {
			$targetId = '';
		}
		
		var result = '';
		var color = (idx == '0') ? '#808080' : '#0033FF'; // idx가 0일 경우 첨부파일 없음 상태
		
		result += '<tr class="fileBoxTr" data-flag="' + idx + '" data-targetid="' + $targetId + '"style="height: 30px;">'
		result += '<td class="fileBoxTd" style="width:250px;">';
		result +=	'<span class="mr20">'	;
		result += '<img src="<c:url value="/Images/ico/ico_clip02.png"/>" alt="" />';
		result +=	'<a href="#n" style="color:' + color + ';" id="fileText' + idx + '" class="" onclick="fileDownload(this)">&nbsp;' + fileNm;
		result +=	'</a>';
		if (idx != '0' && flag !== 'confirm') {
  			result += '<a href="javascript:delFile(' + idx + ')" style="margin-left: 11px;"><img src="<c:url value="/Images/btn/btn_del_reply.gif"/>" /></a>';			
		}
		result +=	'</span>';
		result +=  '</td>';
		result +=  '</tr>';
		
		return result;
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
	
	function fn_setFileDivN(result, i){
		$('#fileDiv').append(
				'<tr id="test'+result.list[i].attach_file_id+'">'+
					'<td class="">'+
						'<span style=" display: block;" class="mr20">'+
							'<img src="<c:url value="/Images/ico/ico_clip02.png"/>" alt="" />&nbsp;'+								
							'<a href="#n" style="line-height: 23px; cursor: pointer; color: #0033FF" id="fileText" onclick="kukgohFileDown(this);" class="file_name">'+result.list[i].real_file_name+'.'+result.list[i].file_extension+'</a>&nbsp;'+
							'&nbsp;<a href="javascript:delFile('+result.list[i].attach_file_id+','+result.list[i].file_seq+')"><img src="<c:url value="/Images/btn/btn_del_reply.gif"/>" /></a>' +
							'<input type="hidden" id="fileId" class = "fileId" value="'+result.list[i].attach_file_id+'" />'+
							'<input type="hidden" id="fileSeq" class = "fileSeq" value="'+result.list[i].file_seq+'" />'+
						'</span>'+
					'</td>'+
				'</tr>'
		);
	}
	
	function delFile(idx) {
		
		$('[data-flag=' + idx + ']').remove();
		$('#file' + idx).remove();
		
		if ($("#fileForm")[0].length === 0) {
			$('#fileDiv').append(
				fileRowTemplate('첨부파일을 등록해주세요.', 0)
			);
		}
	}
	
	function upFile() {
		$("#fileID").click();
	}
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
					<dd style="width:20%">
						<input type="text" style="" id = "standardDate" style = "" value=""/>
					</dd>
					<dt>부서</dt>
					<dd style="width:20%">
						<input type="text" style="" id = "dept" style = "" value="" />
					</dd>
					<dt>상태</dt>
					<dd style="width:15%">
						<input type="text" style="" id = "status" style = "" value="" />
					</dd>
				</dl>
			</div>
		</div>
				
		<div class="btn_div mt10 cl">
			<div class="left_div">
				<p class="tit_p mt5 mb0">부서 예산 신청</p>
			</div>
			<div class="right_div">
				<div class="controll_btn p0">
					<button type="button" id="" onclick = "confirmMultiple()">확정</button>
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

<!-- 첨부파일 팝업 -->
	<div class="pop_wrap_dir" id="filePop" style="width:400px; display: none;">
		
		<form id="fileForm" method="post" enctype="multipart/form-data" >
		</form>
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
			<div class="">
				<span id="orgFile">
					<input type="file" id="fileID" name="fileNm" value="" onChange="addFile(this);" class="hidden" />
				</span>			
			</div>
			</div>
											
	</div>
	<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" class="gray_btn" value="닫기" onclick="filepopClose();"/>
			</div>
		</div><!-- //pop_foot -->
	</div>	
<!-- 첨부파일 팝업 -->

</body>

