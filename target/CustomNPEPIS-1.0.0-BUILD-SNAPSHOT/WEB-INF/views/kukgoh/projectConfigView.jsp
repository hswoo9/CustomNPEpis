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
$(document).ready(function() {
	
    $("#applyYear").kendoDatePicker({
        start: "decade",
        depth: "decade",
        format: "yyyy",
		parseFormats : ["yyyy"],
        culture : "ko-KR",
        dateInput: true
    });
    
    $("#applyYear").val('${year}');
	var popUp = $('#popUp');
	
	popUp.kendoWindow({
		width : "600px",
		height : "700px",
		visible : false,
		modal: true,
		actions : [ "Close" ],
		close : onClose2
	}).data("kendoWindow").center();
	
	function onClose2(){
		popUp.fadeIn();
	}
    
});
//---------------------------------------End ready

$(function() {
	mainGrid();
});

function mainGrid(){
	
	//캔도 그리드 기본
	var kukgohPjtConfigGrid = $("#kukgohPjtConfigGrid").kendoGrid({
		dataSource : kukgohPjtConfigGridDataSource,
		dataBound : gridDataBound,
		height : 450,
		sortable : true,
		persistSelection : true,
		selectable : "multiple",
        columns: [
			{	
				template : function(dataItem){
					/* html = '<input style="display: block; margin: 0 auto; width: 90%;" type="text"  class="txtCustManage1" id="'+$('#commCode').val()+dataItem.CMMN_DETAIL_CODE+"M1"+ '"name="" value="'+manageValue+' "/>' ; */
/* 					var html = "<div style='display: inline-block; '>";
					html += "<div style='float: left; width: 48%; hight: 26px;'>";
					html += "<p>"+blackCheck(dataItem.BGT_CD)+'</p>';
					html += "</div>"
					html += "<div style='float: right; width: 48%;'>"
					html += '<input style="display: block; margin: 0 auto; width: 20px;" type="button"  class="btnChoice" name="" value="선택" onclick="btnBgtChoice(this);"/>';
					html += "</div>"
					html += '</div>' ; */
					var html =  '<input style="display: block; margin: 0 auto; width: 70px;" type="button"  class="btnChoice" name="" value="'+blackCheck(dataItem.PJT_CD)+'" onclick="btnPjtChoice(this);"/>';
					return html;
				},
				field : "PJT_CD",
				title : "프로젝트코드",
				width : 100
			},
			{
				field : "PJT_NM",
				title : "프로젝트명",
				width : 100
			},
			{
				field : "UPPER_BSNS_ID",
				title : "상위사업ID",
				width : 100
			},
			{
				field : "UPPER_BSNS_NM",
				title : "상위사업명",
				width : 90
			},
			{
				field : "DDTLBZ_ID",
				title : "상세사업ID",
				width : 90
			},
			{
				field : "DDTLBZ_NM",
				title : "상세사업명",
				width : 90
			},
			{
				field : "REQST_DE",
				title : "신청일자",
				width : 90
			},
			{
				field : "REQST_MAN_NM",
				title : "신청자",
				width : 90
			},
			{
				template:  function(dataItem){
					if(dataItem.FILE_ID == '' || dataItem.FILE_ID == null ){
						return "-";
					}else{
						html = '<input style="display: block; margin: 0 auto; width: 50px;" type="button"  class="btnFilePop" name="" value="조회" onclick="btnFilePop(this);"/>' ;
						return html;
					}
				},
				title : "첨부파일",
				width : 70
			}],
        change: function (e){
        	kukgohPjtConfigGridClick(e)
        }
    }).data("kendoGrid");
	
	kukgohPjtConfigGrid.table.on("click", ".checkbox", selectRow);
	
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
	function kukgohPjtConfigGridClick(){
		
	}
}

var kukgohPjtConfigGridDataSource = new kendo.data.DataSource({
	transport : {
		read : {
			url : _g_contextPath_+"/kukgoh/getProjectMainGrid",
			dataType : "json",
			type : 'post'
		},
		parameterMap : function(data, operation) {
			data.BSNSYEAR = $('#applyYear').val();
			return data;
		}
	},
	schema : {
		data : function(response) {
			console.log("prohectList : " + response.list);
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

var selDataItem;

function btnPjtChoice(e){
	 selDataItem = $("#kukgohPjtConfigGrid").data("kendoGrid").dataItem($(e).closest("tr"));
	 $('#popUp').data("kendoWindow").open();
	 pjtCdGridReload();
}

function popCancel(){
 	$('#filePop').data("kendoWindow").close();
 }
 
function save(e){
	
}

function searchBtn(){
	$("#kukgohPjtConfigGrid").data("kendoGrid").dataSource.read();
}

function btnFilePop(e){
	 $('#fileDiv').empty();

	 var dataItem = $("#kukgohPjtConfigGrid").data("kendoGrid").dataItem($(e).closest("tr"));
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
$(function() {
	subGrid();
});
function subGrid(){

	var pjtCdGrid = $("#pjtCdGrid").kendoGrid({
		dataSource : pjtCdGridDataSource,
		dataBound :  pjtCdGridDataBound,
		height : 550,
		sortable : true,
		persistSelection : true,
		selectable : "multiple",
        columns: [
			{
				field : "PJT_CD",
				title : "프로젝트 코드",
				width : 100
			},
			{
				field : "PJT_NM",
				title : "프로젝트 명",
				width : 150
			}],
        change: function (e){
        	pjtCdGridClick(e)
        }
    }).data("kendoGrid");
	
	pjtCdGrid.table.on("click", ".checkbox", selectRow);
	
	var checkedIds = {};
	
	// on click of the checkbox:
	function selectRow(){
		var checked = this.checked,
		row = $(this).closest("tr"),
		grid = $('#pjtCdGrid').data("kendoGrid"),
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
	function pjtCdGridDataBound(e) {
	}
	function pjtCdGridClick(){
		
	}
	$("#pjtCdGrid").on("dblclick", "tr.k-state-selected", function (e) {
		var dataItem = pjtCdGrid.dataItem(this);
		var sDataItem = selDataItem;

		 $.ajax({
				url: _g_contextPath_+"/kukgoh/saveProjectConfig",
				dataType : 'json',
				data : {
						BSNSYEAR : sDataItem.BSNSYEAR,
						DDTLBZ_ID : sDataItem.DDTLBZ_ID,
						PJT_CD : dataItem.PJT_CD
				},
				type : 'POST',
				success: function(result){
					if(result.result == true){
						alert("저장하였습니다.");
					}else{
						alert("저장에 실패하였습니다.");
					}	
					searchBtn();
				},
				error : function(result){
					
				}
			});
		 selDataItem.set("PJT_CD", dataItem.PJT_CD);
		 selDataItem.set("PJT_NM", dataItem.PJT_NM);

		$('#popUp').data("kendoWindow").close();
		pjtCdGridReload();
	});	
}

var pjtCdGridDataSource = new kendo.data.DataSource({
	transport : {
		read : {
			url : _g_contextPath_+"/kukgoh/getProjectCdGridPop",
			dataType : "json",
			type : 'post'
		},
		parameterMap : function(data, operation) {
			data.FSYR = $('#applyYear').val();
			data.NAME = $('#pjtCodeNm').val();
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

function pjtCdGridReload(){
	$("#pjtCdGrid").data("kendoGrid").dataSource.read();
}
function blackCheck(str){
	if(str == '' || str == null){
		return "선택";
	}else{
		return str;
	}
}
</script>
<body>
<div class="iframe_wrap" style="min-width: 1100px">
	<input type="hidden" id="request_seq"  value="" />
	<input type="hidden" id="loginSeq"  value="${loginSeq }" />
	<input type="hidden" id="bgtCd"  value="" />
	<input type="hidden" id="bgtNm"  value="" />
	<input type="hidden" id="hbgtCd"  value="" />
	<input type="hidden" id="hbgtNm"  value="" />
	<input type="hidden" id="selectedGridCd"  value="" />
	
	<!-- 컨텐츠타이틀영역 -->
	<div class="sub_title_wrap">

		<div class="title_div">
			<h4>사업 프로젝트 설정</h4>
		</div>
	</div>

	<div class="sub_contents_wrap">
		<div class="top_box">
			<dl>
				<dt  class="ar" style="width:65px" >사업년도</dt>
				<dd>
					<div class="controll_btn p0">
						<input type="text" id="applyYear" style="width: ;height:24px ;margin-top:0px;margin-left:"/>
						
						<!-- TODO 
							kendoDate 입력
						-->
					</div>	
				</dd>
			</dl>
		</div>
		<!-- 버튼 -->
		<div class="btn_div mt10 cl">
			<div class="right_div">
				<div class="controll_btn p0">
					<button type="button" id="" onclick="searchBtn();">조회</button>
				</div>
			</div>
		</div>
		<div class="com_ta2 mt15" >
			<div id="kukgohPjtConfigGrid">
			</div>
		</div>
		<div class="btn_div mt10 cl">
		</div>
	</div>
	<!-- //sub_contents_wrap -->
</div>
<!-- iframe wrap -->


<!-- PopUp-->
<div class="pop_wrap_dir" id="popUp" style='width: 600px; display : none;'>
		<div class="pop_head">
			<h1>예산과목 선택</h1>
		</div>
		<div class="pop_con">
			<div class="com_ta" style="">
					<div class="top_box">
						<dl>
							<!-- <dt  class="ar" style="width:50px" >&nbsp; </dt> -->
							<dt>프로젝트 명</dt>
							<dd>
								<input type="text" id="pjtCodeNm" style="width: 150px"  onkeyup="pjtCdGridReload();" style="width:150px;text-align: " placeholder="세목명 입력"/> 
							</dd>
						</dl>
					</div>
					<div class="com_ta2 mt15" >
						<div id="pjtCdGrid"></div>
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
