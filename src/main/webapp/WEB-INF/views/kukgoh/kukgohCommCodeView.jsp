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
<fmt:formatDate value="${nowDate}" var="nowDate" pattern="yyyy-MM" />
<fmt:formatDate value="${year}" var="year" pattern="yyyy" />
<fmt:formatDate value="${mm}" var="mm" pattern="MM" />
<fmt:formatDate value="${dd}" var="dd" pattern="dd" />
<fmt:formatDate value="${weekDay}" var="weekDay" pattern="E" type="date" />
<script type="text/javascript" src='<c:url value="/js/ac/acUtil.js"></c:url>'></script>
<script type="text/javascript" src="<c:url value='/js/jquery.form.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/jszip.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/shieldui-all.min.js' />"></script>


<script type="text/javascript" src="<c:url value='/js/kukgoh/kukgohUtil.js' />"></script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
</head>
<style type="text/css">
	.k-header .k-link {
	text-align: center;
}

.k-grid th.k-header, .k-grid-header {
	background: #F0F6FD;
}

.k-grid-content>table>tbody>tr {
	text-align: center;
}
</style>
<script type="text/javascript">
var commCodeParam = "";

$(document).ready(function() {
 	var undo = $('#bntClassify');
 	
 	mainGrid();
	subGrid();
 	
	undo.click(function() {
			commCodeClassificationGridReload();
			popup.data("kendoWindow").open();
			$('#commCodeNm').val('');
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
	
	var popup = $('#popUp');
	
	popup.kendoWindow({
		width : "350px",
		height : "680px",
		visible : false,
		modal: true,
		actions : [ "Close" ],
		close : onClose2
	}).data("kendoWindow").center();
	
	function onClose2(){
		undo.fadeIn();
	}
});
//---------------------------------------End ready

function mainGridReload() {
	$("#kukgohCommCodeGrid").data("kendoGrid").dataSource.read();
}

function mainGrid(){
	//캔도 그리드 기본
	var kukgohCommCodeGrid = $("#kukgohCommCodeGrid").kendoGrid({
		dataSource : kukgohCommCodeDataSource,
		dataBound : gridDataBound,
		height : 450,
		sortable : true,
/* 	pageable : {
			refresh : true,
			pageSizes : true,
			buttonCount : 10
		},  */
		persistSelection : true,
		selectable : "multiple",
        columns: [
			{
				field : "CMMN_DETAIL_CODE",
				title : "코드",
				width : 100
			},
			{
				field : "CMMN_DETAIL_CODE_NM",
				title : "코드명",
				width : 150
			},
			{
				template:  function(dataItem){
					var manageValue = getManageValue(dataItem.CUSTOM_MANAGE1);
					html = '<input style="display: block; margin: 0 auto; width: 90%;" type="text"  class="txtCustManage1" id="'+$('#commCode').val()+dataItem.CMMN_DETAIL_CODE+"M1"+ '"name="" value="'+manageValue+'"/>' ;
					return html;
				},
				field : "CUSTOM_MANAGE1",
				title : "관리항목1",
			},
			{
				template:  function(dataItem){
					var manageValue = getManageValue(dataItem.CUSTOM_MANAGE2);

					html = '<input style="display: block; margin: 0 auto; width: 90%;" type="text"  class="txtCustManage1" id="'+$('#commCode').val()+dataItem.CMMN_DETAIL_CODE+"M2"+ '"name="" value="'+manageValue+'"/>' ;
					return html;
				},
				field : "CUSTOM_MANAGE2",
				title : "관리항목2",
			},
			{
				field : "CMMN_CODE_DC",
				title : "코드설명",
				width : 180
			},
			{
				field : "MANAGE_IEM_CN_1",
				title : "e나라도움 관리항목1",
			},
			{
				field : "MANAGE_IEM_CN_2",
				title : "e나라도움 관리항목2",
			},
			{
				field : "MANAGE_IEM_CN_3",
				title : "e나라도움 관리항목3",
			},
			{
				field : "MANAGE_IEM_CN_4",
				title : "e나라도움 관리항목4",
			},
			{
				field : "MANAGE_IEM_CN_5",
				title : "e나라도움 관리항목5",
			},
			{
				template:  function(dataItem){
					console.log(dataItem);
					if(dataItem.FILE_ID == '' || dataItem.FILE_ID == null ){
						return "-";
					}else{
						html = '<input style="display: block; margin: 0 auto; width: 50px;" type="button"  class="btnFilePop" name="" value="조회" onclick="btnFilePop(this);"/>' ;
						return html;
					}
									},
				title : "첨부파일",
				width : 100
			}],
        change: function (e){
        	kukgohCommCodeGridClick(e)
        }
    }).data("kendoGrid");
	
	kukgohCommCodeGrid.table.on("click", ".checkbox", selectRow);
	
	var checkedIds = {};
	
	// on click of the checkbox:
	function selectRow(){
		var checked = this.checked,
		row = $(this).closest("tr"),
		grid = $('#kukgohCommCodeGrid').data("kendoGrid"),
		dataItem = grid.dataItem(row);
		
		checkedIds[dataItem.CODE_CD] = checked;
		if (checked) {
			//-select the row
			row.addClass("k-state-selected");
		} else {
			//-remove selection
			row.removeClass("k-state-selected");
		}
	}
	
	function kukgohCommCodeGridClick(){
		
	}
}

function getManageValue(custManage){
	if(custManage == 'undefined' || custManage == null || custManage == 'null'){
		return "";
	}else{
		return custManage;
	}
}

var kukgohCommCodeDataSource = new kendo.data.DataSource({
	//serverPaging : true,
	//pageSize : 10,
	transport : {
		read : {
			url : _g_contextPath_+"/kukgoh/getMainGrid",
			dataType : "json",
			type : 'post'
		},
		parameterMap : function(data, operation) {
			data.CMMN_CODE = commCodeParam;
			
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
				emp_name : {
					type : "string"
				},
				code_kr : {
					type : "string"
				}
			}
		}
	}
});

function gridDataBound(e) {
	var grid = e.sender;
	if (grid.dataSource.total() == 0) {
		var colCount = grid.columns.length;
		$(e.sender.wrapper).find('tbody').append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
	}
}

function popCancel(){
 	$('#filePop').data("kendoWindow").close();
 }
 
function save(e){
	var data = new Array();
	var kukgohCommCodeGrid = $("#kukgohCommCodeGrid").data("kendoGrid");
	var dataSource = kukgohCommCodeGrid.dataSource;
	var recordsOnCurrentView = dataSource.view().length;
	var totalRecords = dataSource.total();
	for(var i= 0; i < totalRecords; i++){
		var dataItem = kukgohCommCodeGrid.dataItem("tbody tr:eq("+i+")");
		var cData = {
				CMMN_CODE : $('#commCode').val(),
				CMMN_DETAIL_CODE : dataItem.CMMN_DETAIL_CODE,
				CUSTOM_MANAGE1 : $('#'+$('#commCode').val()+dataItem.CMMN_DETAIL_CODE+'M1').val(),
				CUSTOM_MANAGE2 : $('#'+$('#commCode').val()+dataItem.CMMN_DETAIL_CODE+'M2').val()
		}
		data.push(cData);
	}
	 $.ajax({
			url: _g_contextPath_+"/kukgoh/commCodeSave",
			dataType : 'json',
			data : {
				"data" : JSON.stringify(data) 
			},
			type : 'POST',
			success: function(result){
					alert("저장되었습니다.");
			},
			error : function(result){
				
			}
		});	
}

function searchBtn(){
	$("#kukgohCommCodeGrid").data("kendoGrid").dataSource.read();
}

function btnFilePop(e){
	 $('#fileDiv').empty();

	 var dataItem = $("#kukgohCommCodeGrid").data("kendoGrid").dataItem($(e).closest("tr"));
	 
 	 $.ajax({
			url: _g_contextPath_+"/kukgoh/getFileList",
 			dataType : 'json',
 			data : {
 				INTRFC_ID : dataItem.INTRFC_ID,
 				TRNSC_ID : dataItem.TRNSC_ID,
 				FILE_ID : dataItem.FILE_ID
 			},
 			type : 'POST',
 			success: function(result){
				if (result.list.length > 0) {
 					for (var i = 0 ; i < result.list.length ; i++) {
 						if(i==0) {	
 							$('#fileDiv').append(
 									'<tr id="test">'+
 									'<th>첨부파일 목록</th>'+
 									'<td class="le">'+
 									'<span style=" display: block;" class="mr20">'+
 									'<img src="<c:url value="/Images/ico/ico_clip02.png"/>" alt="" />&nbsp;'+								
 									'<a href="#n" style="line-height: 23px; cursor: pointer; color: #0033FF" id="fileText" onclick="kukgohFileDown(this);" class="file_name">'+result.list[i].real_file_name+'.'+result.list[i].file_extension+'</a>&nbsp;'+
 									'<input type="hidden" id="kukgohFileKey" value="'+result.list[i].attach_file_id+'" />'+
 									'<input type="hidden" id="kukgohFileSeq" value="'+result.list[i].file_seq+'" />'+
 									'</span>'+
 									'</td>'+
 									'</tr>'
 									//sexualViolenceFileKey
 									//sexualViolenceFileSeq
 							);		
 						} else {
 							$('#fileDiv').append(
 									'<tr id="test">'+
 									'<th></th>'+
 									'<td class="le">'+
 									'<span style=" display: block;" class="mr20">'+
 									'<img src="<c:url value="/Images/ico/ico_clip02.png"/>" alt="" />&nbsp;'+								
 									'<a href="#n" style="line-height: 23px; cursor: pointer; color: #0033FF" id="fileText" onclick="kukgohFileDown(this);" class="file_name">'+result.list[i].real_file_name+'.'+result.list[i].file_extension+'</a>&nbsp;'+
 									'<input type="hidden" id="kukgohFileKey" value="'+result.list[i].attach_file_id+'" />'+
 									'<input type="hidden" id="kukgohFileSeq" value="'+result.list[i].file_seq+'" />'+
 									'</span>'+
 									'</td>'+
 									'</tr>'
 							);
 						}
 					}
 				}
 			}
 	 });
 	 $('#filePop').data("kendoWindow").open();
}

function kukgohFileDown(e){
	var row = $(e).closest("tr");
	var attach_file_id = row.find('#kukgohFileKey').val();
	var data = {
			fileNm : row.find('#fileText').text(),
			attach_file_id : row.find('#kukgohFileKey').val(),
			file_seq : row.find('#kukgohFileSeq').val()
	}
	$.ajax({
		url : _g_contextPath_+'/common/fileDown',
		type : 'GET',
		data : data,
	}).success(function(data) {
		
		var downWin = window.open('','_self');
		downWin.location.href = _g_contextPath_+'/common/fileDown?attach_file_id='+attach_file_id;
	});
	
}		

function initPopup(dataItem){
	
}

function fileRow(e){
 	 var dataItem = $("#kukgohCommCodeGrid").data("kendoGrid").dataItem($(e).closest("tr"));
 	 var key = dataItem.FILE_ID;
 	 //$('#popupTitle').text(dataItem.education_name)
 	 var data = {
 				keyId : key,	
 				fileName : 'kukgoh'
 		}
 	 $('#fileDiv').empty();
 	 $.ajax({
 			url: _g_contextPath_+"/kukgoh/getFileList",
 			dataType : 'json',
 			data : data,
 			type : 'POST',
 			success: function(result){
 				if (result.list.length > 0) {
 					for (var i = 0 ; i < result.list.length ; i++) {
 						if(i==0) {	
 							$('#fileDiv').append(
 									'<tr id="test">'+
 									'<th>첨부파일 목록</th>'+
 									'<td class="le">'+
 									'<span style=" display: block;" class="mr20">'+
 									'<img src="<c:url value="/Images/ico/ico_clip02.png"/>" alt="" />&nbsp;'+								
 									'<a href="#n" style="line-height: 23px; cursor: pointer; color: #0033FF" id="fileText" onclick="sexualViolenceFileDown(this);" class="file_name">'+result.list[i].real_file_name+'.'+result.list[i].file_extension+'</a>&nbsp;'+
 									'<input type="hidden" id="sexualViolenceFileKey" value="'+result.list[i].attach_file_id+'" />'+
 									'<input type="hidden" id="sexualViolenceFileSeq" value="'+result.list[i].file_seq+'" />'+
 									'</span>'+
 									'</td>'+
 									'</tr>'
 							);		
 						} else {
 							$('#fileDiv').append(
 									'<tr id="test">'+
 									'<th></th>'+
 									'<td class="le">'+
 									'<span style=" display: block;" class="mr20">'+
 									'<img src="<c:url value="/Images/ico/ico_clip02.png"/>" alt="" />&nbsp;'+								
 									'<a href="#n" style="line-height: 23px; cursor: pointer; color: #0033FF" id="fileText" onclick="sexualViolenceFileDown(this);" class="file_name">'+result.list[i].real_file_name+'.'+result.list[i].file_extension+'</a>&nbsp;'+
 									'<input type="hidden" id="sexualViolenceFileKey" value="'+result.list[i].attach_file_id+'" />'+
 									'<input type="hidden" id="sexualViolenceFileSeq" value="'+result.list[i].file_seq+'" />'+
 									'</span>'+
 									'</td>'+
 									'</tr>'
 							);
 						}
 					}
 				} else {
 					$('#fileDiv').append(
 						'<tr id="test">'+
 						'<th>첨부파일 목록</th>'+
 						'<td class="le">'+
 						'<span class="mr20">'+	
 						'<img src="<c:url value="/Images/ico/ico_clip02.png"/>" alt="" />'+
 						'<a href="#n" style="color: #808080" id="fileText">&nbsp;첨부파일이	없습니다.'+
 						'</a>'+
 						'</span>'+
 						'</td>'+
 						'</tr>'
 					);
 				}
 				
 			}
 		});
 	}

function subGrid(){

	var commCodeClassificationGrid = $("#commCodeClassificationGrid").kendoGrid({
		dataSource : commCodeClassificationGridDataSource,
		dataBound :  commCodeClassificationGridDataBound,
		height : 450,
		sortable : true,
		persistSelection : true,
		selectable : "multiple",
        columns: [
			{
				field : "CMMN_CODE",
				title : "코드",
				width : 100
			},
			{
				field : "CMMN_CODE_NM",
				title : "코드명",
				width : 150
			}],
        change: function (e){
        	commCodeClassificationGridClick(e)
        }
    }).data("kendoGrid");
	
	commCodeClassificationGrid.table.on("click", ".checkbox", selectRow);
	
	var checkedIds = {};
	
	// on click of the checkbox:
	function selectRow(){
		var checked = this.checked,
		row = $(this).closest("tr"),
		grid = $('#commCodeClassificationGrid').data("kendoGrid"),
		dataItem = grid.dataItem(row);
		
		checkedIds[dataItem.CODE_CD] = checked;
		if (checked) {
			//-select the row
			row.addClass("k-state-selected");
		} else {
			//-remove selection
			row.removeClass("k-state-selected");
		}
	}
	function commCodeClassificationGridDataBound(e) {
	}
	function commCodeClassificationGridClick(){
		
	}
	$("#commCodeClassificationGrid").on("dblclick", "tr.k-state-selected", function (e) {
		var dataItem = commCodeClassificationGrid.dataItem(this);
		$('#commCodeNm').val(dataItem.CMMN_CODE_NM);
		$('#commCodeClassification').val(dataItem.CMMN_CODE_NM);
		$('#commCode').val(dataItem.CMMN_CODE);
		
		commCodeParam = dataItem.CMMN_CODE;

		$('#popUp').data("kendoWindow").close();
		
		mainGridReload();
	});	
}

var commCodeClassificationGridDataSource = new kendo.data.DataSource({
	transport : {
		read : {
			url : _g_contextPath_+"/kukgoh/getCommCodeClassificationMs",
			dataType : "json",
			type : 'post'
		},
		parameterMap : function(data, operation) {
			data.CMMN_CODE_NM = $('#commCodeNm').val(); 
			return data;
		}
	},
	schema : {
		data : function(response) {
			return response.list;
		},
		model : {
			fields : {
				emp_name : {
					type : "string"
				},
				code_kr : {
					type : "string"
				}
			}
		}
	}
});

function searchCode() {
	console.log("서치");
	commCodeClassificationGridReload();
}

function commCodeClassificationGridReload(){
	$("#commCodeClassificationGrid").data("kendoGrid").dataSource.read();
}
</script>

<body>
<div class="iframe_wrap" style="min-width: 1100px">
	 <form id="viewerForm" name="viewerForm" method="post" action="http://10.10.10.82/gw/outProcessLogOn.do" target="viewer"> 
		<input type="hidden" id="outProcessCode" name="outProcessCode" value="">
		<input type="hidden" id="mod" name="mod" value="W">
		<input type="hidden" id="loginId" name="loginId" value="${loginId}">
		<!-- <input type="hidden" id="loginId" name="loginId" value="admin"> -->
		<input type="hidden" name="contentsEnc" value="O">
		<input type="hidden" id="contentsStr" name="contentsStr" value="">
		<input type="hidden" id="approKey" name="approKey" value="">
		<input type="hidden" id="fileKey" name="fileKey" value="">
		
	</form>
	<input type="hidden" id="request_seq"  value="" />
	<input type="hidden" id="loginSeq"  value="${loginSeq }" />
	<!-- 컨텐츠타이틀영역 -->
	<div class="sub_title_wrap">

		<div class="title_div">
			<h4>공통코드 정보</h4>
		</div>
	</div>

	<div class="sub_contents_wrap">
		<div class="top_box">
			<dl>
				<dt  class="ar" style="width:65px" >대분류</dt>
				<dd>
					<div class="controll_btn p0">
						<input type="text" id="commCodeClassification" disabled="disabled" style="width: ;height:24px ;margin-top:0px;margin-left:"/>
						<input type="hidden" id="commCode" value=""/>
						
						<button type="button" id="bntClassify"  >검색</button>
					</div>	
				</dd>
			</dl>
		</div>
		<!-- 버튼 -->
		<div class="btn_div mt10 cl">
			<div class="right_div">
				<div class="controll_btn p0">
					<button id="saveManage" onclick="save()">저장</button>
					<button type="button" id="" onclick="searchBtn();">조회</button>
				</div>
			</div>
		</div>
		<div class="com_ta2 mt15" >
			<div id="kukgohCommCodeGrid">
			</div>
		</div>
		<div class="btn_div mt10 cl">
		</div>
	</div>
	<!-- //sub_contents_wrap -->
</div>
<!-- iframe wrap -->

<!-- PopUp-->
<div class="pop_wrap_dir" id="popUp" style="width: 350px; display : none">
		<div class="pop_head">
			<h1>공통코드 선택</h1>
		</div>
		<div class="pop_con">
			<div class="com_ta" style="">
					<div class="top_box">
						<dl>
							<!-- <dt  class="ar" style="width:50px" >&nbsp; </dt> -->
							<dt>대분류 명</dt>
							<dd>
								<input type="text" id="commCodeNm" style="width: 150px"  onkeyup="searchCode();" style="width:150px;text-align: " placeholder="공통코드명 입력"/> 
							</dd>
						</dl>
					</div>
					<div class="com_ta2 mt15" >
						<div id="commCodeClassificationGrid"></div>
					</div>
			</div>
		</div>
</div>

<div class="pop_wrap_dir" id="filePop" style="width:400px; display: none;">
	<div class="pop_con">
		<!-- 타이틀/버튼 -->
		<div class="btn_div mt0">
			<div class="left_div">
				<h5><span id="popupTitle"></span> 첨부파일</h5>
			</div>
			<div class="right_div">
				<div class="controll_btn p0">
				</div>
			</div>
		</div>
<div class="com_ta" style="" id="">
	<table id="fileDiv"></table>
</div>
</div>
<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" class="gray_btn" value="닫기" onclick="popCancel();"/>
		</div>
	</div><!-- //pop_foot -->
</div>
</body>
</html>
