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
$(document).ready(function() {
	 $("#editor").kendoEditor();
	var editor = $("#editor").data("kendoEditor");
    editorBody = $(editor.body);
	editorBody.removeAttr("contenteditable").find("a").on("click.readonly", false);
	//editorBody.attr("contenteditable", true).find("a").off("click.readonly");
	
});
//---------------------------------------End ready
</script>
<script type="text/javascript">
$(function() {
	mainGrid();
});

function mainGrid(){
	//캔도 그리드 기본
	var kukgohInterfaceGrid = $("#kukgohInterfaceGrid").kendoGrid({
		dataSource : kukgohInterfaceGridDataSource,
		dataBound : gridDataBound,
		height : 350,
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
				field : "code",
				title : "인터페이스 ID",
			},
			{
				field : "code_kr",
				title : "인터페이스 명",
			},
			{
				field : "code_val",
				title : "배치 시간",
				template:  function(dataItem){
					if(dataItem.code_val == 0){
						return "실시간";	
					}else{
						return "매일 " +dataItem.code_val + "시";
					}
					
			},
			},
			{
				template:  function(dataItem){
						html = '<input style="display: block; margin: 0 auto; width: 50px;" type="button"  class="btnFilePop" name="" value="다운받기" onclick="fn_saveInterface(this);"/>' ;
						return html;
				},
				title : "다운받기",
				width : 100
			}],
        change: function (e){
        	kukgohInterfaceGridClick(e)
        }
    }).data("kendoGrid");
	
	kukgohInterfaceGrid.table.on("click", ".checkbox", selectRow);
	
	var checkedIds = {};
	
	// on click of the checkbox:
	function selectRow(){
		var checked = this.checked,
		row = $(this).closest("tr"),
		grid = $('#kukgohInterfaceGrid').data("kendoGrid"),
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
	function kukgohInterfaceGridClick(){
		
	}
}

function getManageValue(custManage){
	if(custManage == 'undefined' || custManage == null || custManage == 'null'){
		return "";
	}else{
		return custManage;
	}
}

var kukgohInterfaceGridDataSource = new kendo.data.DataSource({
	//serverPaging : true,
	//pageSize : 10,
	transport : {
		read : {
			url : _g_contextPath_+"/kukgoh/getInterfaceGrid",
			dataType : "json",
			type : 'post'
		},
		parameterMap : function(data, operation) {
			data.groupCode = 'ENARA_INTRFC'
			return data;
		}
	},
	schema : {
		data : function(response) {
			return response.list;
		},
		total : function(response) {
			return response.list.length;
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
 
function searchBtn(){
	$("#kukgohInterfaceGrid").data("kendoGrid").dataSource.read();
}

function initPopup(dataItem){

}

function fn_saveInterface(e){
	var editor = $("#editor").data("kendoEditor");
	var row = $("#kukgohInterfaceGrid").data("kendoGrid").dataItem($(e).closest("tr"));
	editor.value(editor.value() + " <br>");
	editor.value(editor.value() + row.code+"("+ row.code_kr +")"+" 호출");
	fn_callInterface(row);
}

function fn_callInterface(row){
	var data = {
		code : row.code,
		CODE_VAL : row.code_val,
	}
	$.ajax({
		url : "<c:url value='/kukgoh/callInterface' />",
		data : data,
		type : 'POST',
		success : function(result) {
			var editor = $("#editor").data("kendoEditor");
			editor.value(editor.value() + " <br>");
			editor.value(editor.value() + result.logs);
			editor.value(editor.value() + " <br>");
			editor.value(editor.value() + row.code+"("+ row.code_kr +")"+" 호출 완료");
			editor.value(editor.value() + " <br>");
			editor.value(editor.value() + " <br>");
			editor.value(editor.value() + " ===================================");

		}	
	});	
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
	<p class="tit_p mt5 mt20">인터페이스 저장</p>
		<div class="com_ta2 mt15" >
			<div id="kukgohInterfaceGrid">
			</div>
		</div>
		<div style="margin-top:10px;">
			  <textarea id="editor" rows="10" cols="30"></textarea>
		</div>
		<div class="btn_div mt10 cl">
		</div>
	</div>
	<!-- //sub_contents_wrap -->
</div>
<!-- iframe wrap -->

</body>
</html>
