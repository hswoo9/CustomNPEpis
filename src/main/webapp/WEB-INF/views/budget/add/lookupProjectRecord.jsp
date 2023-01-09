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
 var $mainGridURL = _g_contextPath_ + "/budget/selectBgtPlanRecord";
 
	$(function() {
		Init.ajax();
		
		Init.kendoFunction();
		Init.kendoGrid();
		Init.eventListener();
	})
	
	var Init = {
			ajax : function() {
			},
			kendoFunction : function() {
				
				$("#standardDate").kendoDatePicker({
				    depth: "year",
				    start: "year",
				    culture : "ko-KR",
					format : "yyyy",
					value : moment().format('YYYY')
				});
				
				$("#projectPopup").kendoWindow({
				    width: "600px",
				   height: "650px",
				    visible: false,
				    actions: ["Close"]
				}).data("kendoWindow").center();
				
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
				
				/* 메인 그리드 */
				var mainGrid = $("#mainGrid").kendoGrid({
					dataSource : new kendo.data.DataSource({
						serverPaging : true,
						pageSize : 10,
						transport : {
							read : {
								url : _g_contextPath_+"/budget/initGrid",
								dataType : "json",
								type : 'post'
							},
							parameterMap: function(data, operation) {
		   	      				data.projectCd = $('#pjtFromCd').val()
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
								}
							}
						}
					}),
					dataBound : mainGridDataBound,
					height : 650,
					sortable : true,
					persistSelection : true,
					selectable : "multiple",
			        columns: [
						{
							template : function(dataItem) {
								return  Budget.fn_formatDate(dataItem.BGT_MONTH);
							},
							title : "기준년월",		width : 80
						},
						{
							field : 'DEPT_NM',	title : "부서",	width : 80
						},
						{
							template : function(dataItem) {
								return Budget.fn_formatMoney(dataItem.BGT_AMT)
							},
							title : "예산금액",	width : 80
						},
						{
							field : 'BGT_STAT_NM',	title : "상태",	width : 80
						},
						{
							field : 'BGT_FLAG_NM',	title : "신청유형",	width : 80
						},
						{
							template : function(dataItem) {
								return '<input type="button" class="text_blue" style="width: 80px;" onclick="conFirmFileRow(this);" value="확인">';
							},
							title : "첨부",	width : 80
						},
						{
							template : function(dataItem) {
								return Budget.fn_formatMoney(dataItem.BF_AMT)
							},
							title : "이월금액",	width : 80
						},
						{
							template : function(dataItem) {
								return Budget.fn_formatMoney(dataItem.RE_AMT)
							},
							title : "반납금액",	width : 80
						},
					]
			    }).data("kendoGrid");
				/* 하단 그리드 */
				
				/* 프로젝트 팝업 그리드 */
				var projectGrid = $("#projectGrid").kendoGrid({
			        dataSource: new kendo.data.DataSource({
			    	    transport: { 
			    	        read:  {
			    	            url: _g_contextPath_+'/budget/projectList',
			    	            dataType: "json",
			    	            type: 'post'
			    	        },
			    	      	parameterMap: function(data, operation) {
		   	      				data.fiscal_year = $("#standardDate").val().substring(0, 4);
			    	      		data.project 		= $("#projectName").val();
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
				
				$(document).on("click", "#mainGrid tbody tr", function(e) {
					row = $(this)
					grid = $('#mainGrid').data("kendoGrid"),
					dataItem = grid.dataItem(row);
					
					console.log(dataItem);	
				})
			}
	}
	
	function filepopClose(){
		$('#filePop').data('kendoWindow').close();
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
	 			result += fileRowTemplate(v.file_name, v.file_seq, 'confirm');
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
	
	function fileRowTemplate(fileNm, idx, flag) {
		var result = '';
		var color = (idx == '0') ? '#808080' : '#0033FF'; // idx가 0일 경우 첨부파일 없음 상태
		
		result += '<tr class="fileBoxTr" data-flag="' + idx + '" style="height: 30px;">'
		result += '<td class="fileBoxTd" style="width:250px;">';
		result +=	'<span class="mr20">'	;
		result += '<img src="<c:url value="/Images/ico/ico_clip02.png"/>" alt="" />';
		result +=	'<a href="#n" style="color:' + color + ';" id="fileText' + idx + '" class="">&nbsp;' + fileNm;
		result +=	'</a>';
		if (idx != '0' && flag !== 'confirm') {
  			result += '<a href="javascript:delFile(' + idx + ')" style="margin-left: 11px;"><img src="<c:url value="/Images/btn/btn_del_reply.gif"/>" /></a>';			
		}
		result +=	'</span>';
		result +=  '</td>';
		result +=  '</tr>';
		
		return result;
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
	
	/* 프로젝트 관련 */
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
	/* 프로젝트 관련 */
	
	function mainGridDataBound(e) {
		var grid = e.sender;

		if (grid.dataSource.total() == 0) {
			var colCount = grid.columns.length;
			$(e.sender.wrapper).find('tbody').append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
		}
	}
	
	function searchMainGrid() {
		first = false;
		$('#mainGrid').data('kendoGrid').dataSource.transport.options.read.url = $mainGridURL;
		$('#mainGrid').data('kendoGrid').dataSource.read();
	}
	
	function excel() {
		
		var mainList = $('#mainGrid').data('kendoGrid')._data;
		var templateName = 'lookupProjectRecordExcelTemplate';
		var title = '프로젝트 이력';
		
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
					<dt>기준일자</dt>
					<dd style="width:13%">
						<input type="text" style="" id = "standardDate" style = "" value=""/>
					</dd>
					<dt style="width:7%">프로젝트</dt>
					<dd style="width:35%">
						<input type="text" style="width:40%" id ="pjtFrom" disabled/>
						<input type="hidden" id ="pjtFromCd"/>
						<button type="button" id ="pjtFromSearch" value="검색">
						<img style="position:inherit;" src="<c:url value='/Images/btn/search_icon2.png'/>"></button>
					</dd>
				</dl>
			</div>
		</div>
				
		<div class="btn_div mt10 cl">
			<div class="left_div">
				<p class="tit_p mt5 mb0">프로젝트 이력조회</p>
			</div>
			<div class="right_div">
				<div class="controll_btn p0">
					<button type="button" id="" onclick = "excel()">엑셀</button>
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
		<div class="com_ta mt15" style="height: 450px;">
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

