<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<jsp:useBean id="year" class="java.util.Date" />
<jsp:useBean id="mm" class="java.util.Date" />
<jsp:useBean id="dd" class="java.util.Date" />
<jsp:useBean id="weekDay" class="java.util.Date" />
<jsp:useBean id="nowDate" class="java.util.Date" />
<jsp:useBean id="yearMonth" class="java.util.Date" />
<jsp:useBean id="nowTime" class="java.util.Date" />
<fmt:formatDate value="${nowDate}" var="nowDate" pattern="yyyy-MM" />
<fmt:formatDate value="${yearMonth}" var="yearMonth" pattern="yyyyMM" />
<fmt:formatDate value="${year}" var="year" pattern="yyyy" />
<fmt:formatDate value="${mm}" var="mm" pattern="MM" />
<fmt:formatDate value="${dd}" var="dd" pattern="dd" />
<fmt:formatDate value="${weekDay}" var="nowDateToServer"
	pattern="yyyyMMdd" />
<fmt:formatDate value="${nowTime}" var="nowTime" pattern="HHmm" />
<script type="text/javascript"
	src="<c:url value='/js/jquery.number.min.js' />"></script>
<script type="text/javascript"
	src='<c:url value="/js/ac/acUtil.js"></c:url>'></script>
<script type="text/javascript"
	src="<c:url value='/js/jquery.form.js' />"></script>
<script type="text/javascript"
	src='<c:url value="/js/jszip.min.js"></c:url>'></script>
<script type="text/javascript"
	src='<c:url value="/js/common/outProcessUtil.js"></c:url>'></script>

<style type="text/css">
.k-header .k-link {
	text-align: center;
}

.k-grid-content>table>tbody>tr {
	text-align: center;
}

.top_box input[type='submit'] {
	background: #1088e3;
	height: 24px;
	padding: 0 11px;
	color: #fff;
	border: none;
	font-weight: bold;
	border-radius: 0px;
	cursor: pointer;
}

.top_box input[type='submit'][disabled='disabled'] {
	background: silver;
}

.com_ta table th {
	text-align: center;
	padding-right: 0;
}

.com_ta table td {
	text-align: center;
	padding-left: 0;
	padding-right: 0;
}
</style>

<script type="text/javascript">
 
$(document).ready(function() {
	/*
		년도별검색
	*/
	$('#searchDt').kendoDatePicker({
    	culture : "ko-KR",
	    format : "yyyy",
	    start: "decade",
	    depth: "decade",
	    value: new Date()
	});
	$(document).on('change', '#searchDt', function(){
		var yearMonth = $(this).val().replace('-', '');
		$('[name="apply_month"]').val(yearMonth);
		//mainGrid();
	});
	
	mainGrid();
	
	$('#popUp3 .top_box input[type=text]').on('keypress', function(e) {
		if (e.key == 'Enter') {
			empGridReload();
		};
	});
	
	$('#popUp3').kendoWindow({
		width : "600px",
		height : "665px",
		visible : false,
		modal : true,
		actions : [ "Close" ],
	}).data("kendoWindow").center();
	
	$('#empPopUpBtn').on('click', function() {
		$('#popUp3').data("kendoWindow").open();
	})
	
	empGrid();
});

function gridReload(){
	$('#grid').data('kendoGrid').dataSource.read();
	/* $("#grid").data("kendoGrid").dataSource.page(1); */
}

/*
	메인그리드 그리기
*/
function mainGrid(){
	var yearMonth = $('#searchDt').val().replace('-', '');
	//캔도 그리드 기본
	var grid = $("#grid").kendoGrid({
        dataSource: new kendo.data.DataSource({
        	//serverPaging: true,
        	pageSize: 10,
        	info: false,
            transport: { 
                read:  {
                    url: _g_contextPath_+'/Ac/G20/Ex/proposalEvalList',
                    dataType: "json",
                    type: 'post'
                },
              	parameterMap: function(data, operation) {
        			data.searchDt = yearMonth;
        			data.userSeq = $("#userSeq").val();
        			data.txtContTitle = $("#txtContTitle").val();
             	return data;
             	}
            },
            schema: {
              data: function(response) {
            	  return response.list;
              },
              total: function(response) {
            	  return response.totalCount;
              }
            } 
        }),
        height: 500,
        /* scrollable:{
            endless: true
        }, */
        sortable: true,
        pageable: {
			refresh: true,
			pageSizes: [10, 50, 100], //true,
			buttonCount: 5
		},
        persistSelection: true,
        selectable: "multiple",
        excel: {
            fileName: yearMonth + "계약현황.xlsx",
			allPages: true
        },
        columns: [
        {
        	field : "tr_cd",
        	title : "거래처코드",
        	width : 50
        },{
        	field: "tr_nm",
        	title: "거래처명",
        	width: 50
        },{
        	field: "reg_nb",
        	title: "사업자번호",
        	width : 50
         },{
        	 field : "social_biz1",
        	 title : "사회적기업1",
        	 width : 50
         },{
        	 field : "social_biz2",
        	 title : "사회적기업2",
        	 width : 50
         },{
        	 field : "social_biz3",
        	 title : "사회적기업3",
        	 width : 50
         },{
        	 field : "reg_dt",
        	 title : "등록일",
        	 width : 50
         },{
        	 field : "es_date",
        	 title : "설립일",
        	 width : 50
         }],
        change: function (e){
        	//gridClick(e)
        }
    }).data("kendoGrid");

}

function searchBtn(){
	//$("#beforeSearch").hide();
	mainGrid();
}

function excelDown(){
	$("#grid").getKendoGrid().saveAsExcel();
}

function fnDocPopOpen(purcContId, docId){
	var params = {};
    params.loginId = $('#loginId').val();
    params.approKey = "tpfContRep" + purcContId;
    params.docId = docId;
    params.mod = 'V';
    outProcessLogOn(params);
}

function fnPurcContViewPop(purcReqId, purcReqType, formId, purcContId){
	var url = _g_contextPath_ + '/Ac/G20/Ex/purcContConcView.do?focus=txt_BUDGET_LIST&form_tp=view&purcReqId=' + purcReqId + '&purcReqType=' + purcReqType + '&form_id=' + formId + '&purcContId=' + purcContId;
	var pop = "" ;
	var popupName = "구매계약체결";
	var width = "1000";
	var height = "950";
	windowX = Math.ceil( (window.screen.width  - width) / 2 );
	windowY = Math.ceil( (window.screen.height - height) / 2 );
	var strResize = "YES" ;
	
	pop = window.open(url, '구매계약보기', "width=" + width + ", height=" + height + ", top="+ windowY +", left="+ windowX +", scrollbars=YES, resizable=YES");
	try {pop.focus(); } catch(e){}
}

/* 사원팝업 kendo 그리드 refresh */
function empGridReload() {
	/* $('#empGrid').data('kendoGrid').dataSource.read(); */
	$("#empGrid").data("kendoGrid").dataSource.page(1);
}

/* 사원팝업 kendo 그리드 */
var empDataSource = new kendo.data.DataSource({
	serverPaging : true,
	pageSize : 10,
	transport : {
		read : {
			url : _g_contextPath_+'/common/empInformation',
			dataType : "json",
			type : 'post'
		},
		parameterMap : function(data, operation) {
			data.deptSeq = $('#deptSeq').val();
			data.emp_name = $('#emp_name').val();
			data.dept_name = $('#dept_name').val();
			data.notIn = '';
			return data;
		}
	},
	schema : {
		data : function(response) {
			return response.list;
		},
		total : function(response) {
			return response.totalCount;
		}
	}
});
/* 사원팝업 kendo 그리드 */
function empGrid() {
	//캔도 그리드 기본
	var empGrid = $("#empGrid")
			.kendoGrid(
					{
						dataSource : empDataSource,
						height : 460,

						pageable : {
							refresh : true,
							pageSizes : [10,20,30,50,100],
							buttonCount : 5
						},
						persistSelection : true,
						selectable : "multiple",
						columns : [
								/* { template: "<input type='checkbox' class='checkbox'/>"
								,width:50,	
								}, */
								{
									field : "emp_name",
									title : "이름",

								},
								{

									field : "dept_name",
									title : "부서",

								},
								{
									field : "position",
									title : "직급",

								},
								{
									field : "duty",
									title : "직책",

								},
								{
									title : "선택",
									template : '<input type="button" id="" class="text_blue" onclick="empSelect(this);" value="선택">'
								} ],
						change : function(e) {
						}
					}).data("kendoGrid");

	empGrid.table.on("click", ".checkbox", selectRow);

	var checkedIds = {};

	// on click of the checkbox:
	function selectRow() {

		var checked = this.checked, row = $(this).closest("tr"), empGrid = $(
				'#empGrid').data("kendoGrid"), dataItem = grid
				.dataItem(row);

		checkedIds[dataItem.emp_seq] = checked;
		if (checked) {
			//-select the row
			row.addClass("k-state-selected");
		} else {
			//-remove selection
			row.removeClass("k-state-selected");
		}
	}
}

/* 사원 선택 기능 */
function empSelect(e) {
	var row = $("#empGrid").data("kendoGrid").dataItem($(e).closest("tr"));
	$('#empName').val(row.emp_name);
	$('#userSeq').val(row.emp_seq);
	$('#deptName2').val(row.dept_name);
	$('#popUp3').data("kendoWindow").close();
}
</script>

<input type="hidden" id="end_date">
<input type="hidden" id="compSeq" value="${empInfo.compSeq }" />
<input type="hidden" id="empSeq" value="${empInfo.uniqId }" />
<input type="hidden" id="loginId" value="${empInfo.id }" />

<!-- iframe wrap -->
<div class="iframe_wrap" style="min-width: 1100px;">
	<!-- 컨텐츠타이틀영역 -->
	<div class="sub_title_wrap">
		<div class="title_div">
			<h4>계약현황</h4>
		</div>
	</div>

	<div class="sub_contents_wrap">
		<form method="post" name="shiftWkReqFrm"
			action="${pageContext.request.contextPath }/shiftWorker/shiftWkReqInsert">
			<div class="btn_div mt10 cl">
				<div class="left_div">
					<p class="tit_p mt5 mb0">계약현황</p>
				</div>
			</div>

			<div class="top_box gray_box">
				<dl>
					<dt style="width: 80px;">계약요청년도</dt>
					<dd>
						<input type="text" id="searchDt"
							style="width: 100px; text-align: center;">
					</dd>
					<dt class="ar" style="width: 50px">계약명</dt>
					<dd>
						<input type="text" name="" id="txtContTitle" class="ri" />
					</dd>
					<dt class="ar" style="width: 50px">요청자</dt>
					<dd>
						<input type="text" id="empName" disabled="disabled" value="" /> <input
							type="hidden" id="userSeq" disabled="disabled" value="" /> <input
							type="hidden" id="deptName2" value="" /> <input type="hidden"
							id="deptSeq" value="" />
					</dd>
					<dd>
						<input type="button" id="empPopUpBtn" value="검색" />
					</dd>
				</dl>
			</div>
			<div class="btn_div">
				<div class="right_div">
					<div class="controll_btn p0">
						<button type="button" id="" onclick="searchBtn();">조회</button>
						<button type="button" id="" onclick="excelDown();">엑셀</button>
					</div>
				</div>
			</div>
			<div class="com_ta">
				<div class="mt10" id="beforeSearch">
					<!-- <table style="width: 100%;">
					<tr>
						<td style="border-right: 1px solid #eaeaea;">조회 조건을 설정후 조회버튼을 눌러주세요</td>
					</tr>
				</table> -->
				</div>
				<div id="grid"></div>
			</div>

			<!-- form의 끝에 값이 적용되지 않고 ajax로 request발생시 ie10/11에서 request parsing에러 발생 -->
			<input type="hidden" name="ieParsing" value="ie">
		</form>
	</div>
</div>

<!-- 사원검색팝업 -->
<div class="pop_wrap_dir" id="popUp3" style="width: 600px;">
	<div class="pop_head">
		<h1>사원 리스트</h1>

	</div>
	<div class="pop_con">
		<div class="top_box">
			<dl>
				<dt class="ar" style="width: 65px;">성명</dt>
				<dd>
					<input type="text" id="emp_name" style="width: 120px" />
				</dd>
				<dt>부서</dt>
				<dd>
					<input type="text" id="dept_name" style="width: 180px" /> <input
						type="button" onclick="empGridReload();" id="searchButton"
						value="검색" />
				</dd>
			</dl>
		</div>
		<div class="com_ta mt15" style="">
			<div id="empGrid"></div>
		</div>
	</div>
	<!-- //pop_con -->

	<div class="pop_foot">
		<div class="btn_cen pt12">

			<input type="button" class="gray_btn" id="cancle2" value="닫기" />
		</div>
	</div>
	<!-- //pop_foot -->
</div>


