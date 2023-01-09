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

$(function() {
	mainGrid();
});
function mainGrid(){
	//캔도 그리드 기본
	var kukgohCommCodeGrid = $("#kukgohCommCodeGrid").kendoGrid({
		dataSource : kukgohCommCodeDataSource,
		dataBound : gridDataBound,
		height : 450,
		sortable : true,
				pageable : {
			refresh : true,
			pageSizes : true,
			buttonCount : 10
		}, 
		persistSelection : true,
		selectable : "multiple",
        columns: [
			{
				field : "COUNSEL_DATE",
				title : "상담신청 일자",
				width : 200
			},
			{
				field : "COUNSEL_TITLE",
				title : "제목",
				width : 300
			},
			{
				field : "COUNSEL_CONTENTS",
				title : "상담 내용",
			},
			{
				template: '<input type="button" id="" class="text_blue" onclick="fileRow(this);" value="첨부파일">',
				title : "붙임자료",
				width : 100
			},
			{
				title : "상세",
				template : function(){
					html = '<input style="display: block; margin: 0 auto; width: 50px;" type="button"  class="btnModifyView" name="" value="조회" onclick="openPopup(this);"/>' ;
					return html;
				},
				width : 100
			}],
        change: function (e){
        	sexualViolenceGridClick(e)
        }
    }).data("kendoGrid");
	var childDutyMainGrid = $("#childDutyMainGrid").kendoGrid({
		dataSource : kukgohCommCodeDataSource,
		dataBound : gridDataBound,
		height : 450,
		sortable : true,
				pageable : {
			refresh : true,
			pageSizes : true,
			buttonCount : 10
		}, 
		persistSelection : true,
		selectable : "multiple",
        columns: [
			{
				field : "COUNSEL_DATE",
				title : "상담신청 일자",
				width : 200
			},
			{
				field : "COUNSEL_TITLE",
				title : "제목",
				width : 300
			},
			{
				field : "COUNSEL_CONTENTS",
				title : "상담 내용",
			},
			{
				template: '<input type="button" id="" class="text_blue" onclick="fileRow(this);" value="첨부파일">',
				title : "붙임자료",
				width : 100
			},
			{
				title : "상세",
				template : function(){
					html = '<input style="display: block; margin: 0 auto; width: 50px;" type="button"  class="btnModifyView" name="" value="조회" onclick="openPopup(this);"/>' ;
					return html;
				},
				width : 100
			}],
        change: function (e){
        	sexualViolenceGridClick(e)
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
	function sexualViolenceGridClick(){
		
	}
}
var kukgohCommCodeDataSource = new kendo.data.DataSource({
	serverPaging : true,
	pageSize : 10,
	transport : {
		read : {
			url : _g_contextPath_+"/sexualViolence/getMainList",
			dataType : "json",
			type : 'post'
		},
		parameterMap : function(data, operation) {
			//data.year = $('#applyMonth').val().replace(/\-/g,''); //특정문자 제거; 
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
};
function getCommonCode(){
	var data = {
			test: "test"
	}
	 $.ajax({
			url: _g_contextPath_+"/kukgoh/test",
			dataType : 'json',
			data : data,
			type : 'POST',
			success: function(result){
								
			}
		});	
}
</script>

</head>
<body>
<div class="iframe_wrap" style="min-width: 1100px">
	 <form id="viewerForm" name="viewerForm" method="post" action="http://gw.okchf.or.kr/gw/outProcessLogOn.do" target="viewer"> 
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

		</div>
		<!-- 버튼 -->
		<div class="btn_div mt10 cl">
			<div class="right_div">
				<div class="controll_btn p0">
					<button id="btnReject" onclick="getCommonCode();">데이터 가져오기</button>
					<button id="btnReject">저장</button>
					<button type="button" id="" onclick="searchBtn();">조회</button>
				</div>
			</div>
		</div>
		<div class="com_ta2 mt15" >
			<p class="tit_p mt5 mb0">공통코드 정보</p>
			<div style="float: left; width: 48%;" id="kukgohCommCodeGrid">
			</div>
			<p class="tit_p mt5 mb0">공통코드 상세코드 정보</p>
			<div style="float: right; width: 48%;" id="kukgohCommCodeDetailGrid">
			</div>
				<!-- <div id="childDutyMainGrid"></div> -->
		</div>
		<div class="btn_div mt10 cl">
		</div>
	</div>
	<!-- //sub_contents_wrap -->
</div>
<!-- iframe wrap -->
	
	
</body>
</html>
