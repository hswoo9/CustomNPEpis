<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ page import="main.web.BizboxAMessage"%>
<script type="text/javascript" src='<c:url value="/js/jszip.min.js"></c:url>'></script>
<body>

<div class="iframe_wrap" style="min-width:1100px">

<input type="hidden" id="empSeq" value="${userInfo.uniqId}"/>
<input type="hidden" id="erpCoCd" value="${userInfo.erpCoCd}"/>
<input type="hidden" id="erpEmpCd" value="${userInfo.erpEmpCd}"/>
<input type="hidden" id="mylist" value="${param.mylist}"/>
<input type="hidden" id="mng" value="${param.mng}"/>
	<!-- 컨텐츠타이틀영역 -->
	<div class="sub_title_wrap">
		
		<div class="title_div">
			<h4>출장내역서</h4>
		</div>
	</div>
	
	<div class="sub_contents_wrap">
	<p class="tit_p mt5 mt20">출장내역서</p>

	<div class="com_ta">
				<div class="top_box gray_box">
					<dl>
						<dt style="width: 60px;">회계년도</dt>
						<dd style="width: 80px;">
							<input type="text" id="topSearchYear" style="width: 70px;"/>
						</dd>
						<dt style="width: 50px;">출장지</dt>
						<dd style="width: 100px;">
							<input type="text" id="topSearchPlace" style="width: 90px;"/>
						</dd>
						<dt style="width: 60px;">예산과목</dt>
						<dd style="width: 150px;">
							<input type="text" id="topSearchBudget1" ondblclick="getBudget('topSearchBudget1');" readonly="readonly"/><a class="btn_search" onclick="getBudget('topSearchBudget1');" style="margin-top: 1px;"></a>
						</dd>
						<dt style="width: 60px;">출장부서</dt>
						<dd style="width: 150px;">
							<input type="text" id="topSearchDept" ondblclick="getDept('topSearchDept');" readonly="readonly"/><a class="btn_search" onclick="getDept('topSearchDept');" style="margin-top: 1px;"></a>
						</dd>
					</dl>
					<dl>
						<dt style="width: 60px;">출장구분</dt>
						<dd style="width: 265px;">
							<select id="topSearchType1" style="width: 120px;">
								<option value="2">국내출장</option>
							</select>
							~
							<select id="topSearchType2" style="width: 120px;">
								<option value="2">국내출장</option>
							</select>
						</dd>
						<dt style="width: 60px;">목명</dt>
						<dd style="width: 150px;">
							<input type="text" id="topSearchBudget2" ondblclick="getBudget2('topSearchBudget2');" readonly="readonly"/><a class="btn_search" onclick="getBudget2('topSearchBudget2');" style="margin-top: 1px;"></a>
						</dd>
						<dt style="width: 60px;">출장자</dt>
						<dd style="width: 150px;">
							<input type="text" id="topSearchEmp" ondblclick="getUser('topSearchEmp');" readonly="readonly"/><a class="btn_search" onclick="getUser('topSearchEmp');" style="margin-top: 1px;"></a>
						</dd>
					</dl>
					<dl>
						<dt style="width: 60px;">
							출장기간
						</dt>
						<dd style="width: 265px;">
							<input type="text" id="startDt" style="width: 120px;"> ~ <input type="text" id="endDt" style="width: 120px;">
						</dd>
						<dt style="width: 60px;">승인구분</dt>
						<dd style="width: 150px;">
							<select id="topSearchState" style="width: 128px;">
								<option value="">전체</option>
								<option value="90">승인</option>
								<option value="20">미승인</option>
							</select>
						</dd>
						<dt style="width: 60px;">
							프로젝트
						</dt style="width: 150px;">
						<dd style="line-height: 25px">
							<input type="text" id="topSearchProject" ondblclick="getProject('topSearchProject');" readonly="readonly"/><a class="btn_search" onclick="getProject('topSearchProject');" style="margin-top: 1px;"></a>
						</dd>
					</dl>
				</div>
				
				<div class="btn_div">	
					<div class="right_div">
						<div class="controll_btn p0">										
							<button type="button" onclick="paymentDtSave();" id="paymentDtBtn" style="display: none;">지급일 저장</button>
<!-- 							<button type="button" onclick="excelDownload();">엑셀</button> -->
							<button type="button" id="" onclick="excelDown();">엑셀</button>
							<button type="button" onclick="gridSearch();">조회</button>
						</div>
					</div>
				</div>
				
				<div class="com_ta2 mt15">
				    <div id="gridList"></div>
				</div>
			</div>

	</div><!-- //sub_contents_wrap -->
</div><!-- iframe wrap -->

<div class="pop_wrap_dir" id="projectPopUp" style="width: 500px; display: none;">
	<div class="pop_con">
		<div class="com_ta2">
			<div id="projectList"></div>
		</div>
	</div>
	<!-- //pop_con -->
</div>

<div class="pop_wrap_dir" id="userPopUp" style="width: 600px; display: none;">
	<div class="pop_con">
		<div class="com_ta2">
			<div id="userList"></div>
		</div>
	</div>
	<!-- //pop_con -->
</div>

<div class="pop_wrap_dir" id="deptPopUp" style="width: 600px; display: none;">
	<div class="pop_con">
		<div class="com_ta2">
			<div id="deptList"></div>
		</div>
	</div>
	<!-- //pop_con -->
</div>

<div class="pop_wrap_dir" id="budgetPopUp" style="width: 600px; display: none;">
	<div class="pop_con">
		<div class="com_ta2">
			<div id="budgetList"></div>
		</div>
	</div>
	<!-- //pop_con -->
</div>

<div class="pop_wrap_dir" id="budgetPopUp2" style="width: 400px; display: none;">
	<div class="pop_con">
		<div class="com_ta2">
			<div id="budgetList2"></div>
		</div>
	</div>
	<!-- //pop_con -->
</div>

<script>
var erpOption = {BgtMngType: "2", CauseUseYn: "1", BizGovUseYn: "0", BgtAllocatUseYn: "0", BottomUseYn: "0"};
var popupId = '';
var pjtCds = "";
var changePaymentDts = {};

$(function(){
	init();
	gridInit();
	popUpInit();
	
});

function init(){
	var year = $('#topSearchYear').kendoDatePicker({
	    culture : "ko-KR",
	    format : "yyyy",
	    value : moment().format('YYYY'),
	    depth: "decade",
	    start: "decade"
	}).attr("readonly", true).data("kendoDatePicker");
	
	var startDate = $('#startDt').kendoDatePicker({
	    culture : "ko-KR",
	    format : "yyyy-MM-dd",
	    value : moment().add('month', -1).format('YYYY-MM-DD'),
	    change: startChange
	}).attr("readonly", true).data("kendoDatePicker");

	var endDate = $('#endDt').kendoDatePicker({
	    culture : "ko-KR",
	    format : "yyyy-MM-dd",
	    value : moment().add('month', 0).format('YYYY-MM-DD'),
	}).attr("readonly", true).data("kendoDatePicker");

	function startChange(){
		if(startDate.value() > endDate.value()){
			endDate.value('');
		}
		endDate.min(startDate.value());
	}
	if($("#mng").val() != "Y"){
		$("#paymentDtBtn").hide();
		fnGetErpMgtList();
	}else{
		$("#paymentDtBtn").show();
	}
}

var dataSource = new kendo.data.DataSource({
	type: "odata",
	serverPaging: true,
	serverSorting: true,
	pageSize: 20,
    transport: { 
        read:  {
            url:  "<c:url value='/bsrp/bsrpStatementListSerch' />",
            dataType: "json",
            type: 'post'
        },
      	parameterMap: function(data, operation) {
      		data.startDt = $('#startDt').val();
      		data.endDt = $('#endDt').val();
      		data.topSearchYear = $('#topSearchYear').val();
      		data.topSearchPlace = $('#topSearchPlace').val();
      		data.topSearchEmp = $('#topSearchEmp').attr('code');
      		data.topSearchDept = $('#topSearchDept').attr('code');
      		data.topSearchProject = $('#topSearchProject').attr('code');
      		data.topSearchState = $('#topSearchState').val();
      		
      		data.topSearchType1 = $('#topSearchType1').val();
      		data.topSearchType2 = $('#topSearchType2').val();
      		data.topSearchBudget1 = $('#topSearchBudget1').attr('code');
      		data.topSearchBudget2 = $('#topSearchBudget2').val();
      		
      		if($("#mng").val() != "Y"){
      			data.pjtCds = pjtCds;
      		}
      		data.statYN = "Y";
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
});

function gridInit(){
	$("#gridList").kendoGrid({
        dataSource: dataSource,
        height: 460,
        selectable: "multiple",
        scrollable: {
            virtual: true
        },
        dataBound: function(){
        	$(".datePickerInit").kendoDatePicker({
        		culture : "ko-KR",
        	    format : "yyyy-MM-dd",
        	});
        	$(".datePickerInit").removeClass("datePickerInit");
        },
        excel: {
            fileName: "출장내역서.xlsx",
			allPages: true
        },
        columns: [
            {
                field: "row_num",
                title: "No",
                width: 40,
            }, {
                field: "rqstdt",
                title: "출장기간",
                columns: [
                	{
                		field: "bs_start",
                		title: "From",
                		width: 80,
                	},
                	{
                		field: "bs_start",
                		title: "To",
                		width: 80,
                	}
                ],
            }, {
                field: "applcnt_dept",
                title: "부서명",
                width: 120,
            }, {
                field: "applcnt_nm",
                title: "출장자",
                width: 80,
            }, {
                field: "bs_des",
                title: "출장지",
                width: 70,
            }, {
                field: "rm",
                title: "출장목적",
                width: 150,
            }, {
                field: "daily",
                title: "일비",
                width: 70,
                template : function(data){
                	return numberWithCommas(data.daily);
                },
            }, {
                field: "fare",
                title: "교통비",
                width: 70,
                template : function(data){
                	return numberWithCommas(data.fare);
                },
            }, {
                field: "food",
                title: "식비",
                width: 70,
                template : function(data){
                	return numberWithCommas(data.food);
                },
            }, {
                field: "room",
                title: "숙박비",
                width: 70,
                template : function(data){
                	return numberWithCommas(data.room);
                },
            }, {
                field: "",
                title: "기타경비",
                width: 70,
            }, {
                field: "total",
                template : function(data){
                	return numberWithCommas(data.total);
                },
                title: "지급액",
                width: 70,
            }, {
                field: "end_dt",
                title: "승인일자",
                width: 80,
            }, {
                field: "payment_dt",
                title: "지급일",
                width: 100,
                template : function(data){
                	if($("#mng").val() == "Y"){
	                	var payment_dt = data.payment_dt || "";
	                	var temp = "<input class='datePickerInit' value='" + payment_dt + "' bs_seq='" + data.bs_seq + "' style='width:95px;' onchange='paymentDtChange(this)'/>";
	                	return temp;
                	}else{
                		return data.payment_dt || "";
                	}
                },
            }, {
                field: "pjt_nm",
                title: "프로젝트명",
                width: 200,
            }, {
                field: "abgt_nm",
                title: "예산과목",
                width: 150,
            }
		],
    }).data("kendoGrid");
}

function popUpInit(){
	if($("#mng").val() == "Y"){
		projectPopUpInit();
	}else{
		projectPopUp2Init();
	}
	userPopUpInit();
	deptPopUpInit();
	budgetPopUpInit();
	budgetPopUp2Init();
}

var projectDataSource = new kendo.data.DataSource({
	serverPaging: true,
	pageSize: 10,
    transport: { 
        read:  {
            url:  "<c:url value='/common/getProjectList' />",
            dataType: "json",
            type: 'post'
        },
      	parameterMap: function(data, operation) {
      		data.search_pNm = $('#searchPjNm').val();
      		data.search_pCd = $('#searchPjCd').val();
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
});

function projectPopUpInit(){
	$('#projectPopUp').kendoWindow({
		width: "500px",
	    title: '프로젝트 조회',
	    visible: false,
	    modal : true,
	    actions: [
	        "Close"
	    ],
	}).data("kendoWindow").center();
	
	$("#projectList").kendoGrid({
        dataSource: projectDataSource,
        height: 460,
        sortable: false,
        pageable: false,
        persistSelection: true,
        selectable: "multiple",
        columns: [
       	 {
            title: "프로젝트코드",
            columns: [{
                field: "pjt_cd",
             	width: "140px",
                headerTemplate: function(){
    				return '<input type="text" style="width:90%;" id="searchPjCd" class="projectHeaderInput">';
    	        },
     		}]
        }, {
            title: "프로젝트명",
            columns: [{
                field: "pjt_nm",
                headerTemplate: function(){
    				return '<input type="text" style="width:90%;" id="searchPjNm" class="projectHeaderInput">';
    	        },
     		}]
        }],
    }).data("kendoGrid");
	
	$('.projectHeaderInput').on('keydown', function(key){
		if (key.keyCode == 13) {
			 $("#projectList").data('kendoGrid').dataSource.read();
        }
	});
	
	$(document).on('dblclick', '#projectList .k-grid-content tr', function(){
		var gData = $("#projectList").data('kendoGrid').dataItem(this);
		$('#' + popupId).val(gData.pjt_nm).attr('code', gData.pjt_cd);
		$('#projectPopUp').data("kendoWindow").close();
	});
}

var projectDataSource2 = new kendo.data.DataSource({
	serverPaging: true,
	pageSize: 10,
    transport: { 
        read:  {
            url:  "<c:url value='/Ac/G20/Code/getErpMgtList.do' />",
            dataType: "json",
            type: 'post'
        },
      	parameterMap: function(data, operation) {
      		data.EMP_CD = $("#erpEmpCd").val();
      		data.FG_TY = "2";
      		data.CO_CD = $("#erpCoCd").val();
      		return data;
     	}
    },
    schema: {
		data: function(response) {
			return response.selectList;
		},
		total: function(response) {
			return response.totalCount;
		}
	}
});

function projectPopUp2Init(){
	$('#projectPopUp').kendoWindow({
		width: "500px",
	    title: '프로젝트 조회',
	    visible: false,
	    modal : true,
	    actions: [
	        "Close"
	    ],
	}).data("kendoWindow").center();
	
	$("#projectList").kendoGrid({
        dataSource: projectDataSource2,
        height: 460,
        sortable: false,
        pageable: false,
        persistSelection: true,
        selectable: "multiple",
        dataBound: function(){
        	var e = jQuery.Event("keydown");
        	e.keyCode = 13;
        	$('.projectHeaderInput').trigger(e);
        },
        columns: [
       	 {
            title: "프로젝트코드",
            columns: [{
                field: "PJT_CD",
             	width: "140px",
                headerTemplate: function(){
    				return '<input type="text" style="width:90%;" id="searchPjCd" class="projectHeaderInput">';
    	        },
    	        template: function(data){
    	        	return "<span class='pjt_cd' code='" +data.PJT_CD+ "'>" + data.PJT_CD + "</span>";
    	        },
     		}]
        }, {
            title: "프로젝트명",
            columns: [{
                field: "PJT_NM",
                headerTemplate: function(){
    				return '<input type="text" style="width:90%;" id="searchPjNm" class="projectHeaderInput">';
    	        },
    	        template: function(data){
    	        	return "<span class='pjt_nm' code='" +data.PJT_NM+ "'>" + data.PJT_NM + "</span>";
    	        },
     		}]
        }],
    }).data("kendoGrid");
	
	$('.projectHeaderInput').on('keydown', function(key){
		if (key.keyCode == 13) {
			$("#projectList tbody tr").show();
			$("#projectList tbody tr .pjt_cd").each(function(data){
				if($(this).attr("code").indexOf($("#searchPjCd").val()) == -1){
					$(this).closest("tr").hide();
				}
			});
			$("#projectList tbody tr .pjt_nm").each(function(data){
				if($(this).attr("code").indexOf($("#searchPjNm").val()) == -1){
					$(this).closest("tr").hide();
				}
			});
		}
	});
	
	$(document).on('dblclick', '#projectList .k-grid-content tr', function(){
		var gData = $("#projectList").data('kendoGrid').dataItem(this);
		$('#' + popupId).val(gData.PJT_NM).attr('code', gData.PJT_CD);
		$('#projectPopUp').data("kendoWindow").close();
	});
}

var userDataSource = new kendo.data.DataSource({
	serverPaging: true,
	pageSize: 10,
    transport: { 
        read:  {
            url:  "<c:url value='/common/getUserList' />",
            dataType: "json",
            type: 'post'
        },
      	parameterMap: function(data, operation) {
      		data.search_name = $('#searchNm').val();
      		data.search_dept = $('#searchDp').val();
      		data.search_num = $('#searchNum').val();
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
});

function userPopUpInit(){
	$('#userPopUp').kendoWindow({
		width: "600px",
	    title: '사용자 조회',
	    visible: false,
	    modal : true,
	    actions: [
	        "Close"
	    ],
	}).data("kendoWindow").center();
	
	$("#userList").kendoGrid({
        dataSource: userDataSource,
        height: 460,
        sortable: false,
        pageable: false,
        persistSelection: true,
        selectable: "multiple",
        columns: [
       	 {
            title: "직원번호",
            columns: [{
                field: "erp_emp_num",
                headerTemplate: function(){
    				return '<input type="text" style="width:90%;" id="searchNum" class="userHeaderInput">';
    	        },
     		}]
        }, {
            title: "이름",
            columns: [{
                field: "emp_name",
                headerTemplate: function(){
    				return '<input type="text" style="width:90%;" id="searchNm" class="userHeaderInput">';
    	        },
     		}]
        }, {
            title: "부서",
            columns: [{
                field: "dept_name",
                headerTemplate: function(){
    				return '<input type="text" style="width:90%;" id="searchDp" class="userHeaderInput">';
    	        },
     		}]
        }],
    }).data("kendoGrid");
	
	$(document).on('dblclick', '#userList .k-grid-content tr', function(){
		var gData = $("#userList").data('kendoGrid').dataItem(this);
		$('#' + popupId).val(gData.emp_name).attr('code', gData.emp_seq);
		$('#userPopUp').data("kendoWindow").close();
	});

	$('.userHeaderInput').on('keydown', function(key){
		 if (key.keyCode == 13) {
			 $("#userList").data('kendoGrid').dataSource.read();
         }
	});
}

var deptDataSource = new kendo.data.DataSource({
	serverPaging: true,
	pageSize: 10,
    transport: { 
        read:  {
            url:  "<c:url value='/common/getDeptList2' />",
            dataType: "json",
            type: 'post'
        },
      	parameterMap: function(data, operation) {
      		data.search_dept = $('#searchDeptNm').val();
      		data.search_num = $('#searchDeptCd').val();
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
});

function deptPopUpInit(){
	$('#deptPopUp').kendoWindow({
		width: "600px",
	    title: '부서 조회',
	    visible: false,
	    modal : true,
	    actions: [
	        "Close"
	    ],
	}).data("kendoWindow").center();
	
	$("#deptList").kendoGrid({
        dataSource: deptDataSource,
        height: 460,
        sortable: false,
        pageable: false,
        persistSelection: true,
        selectable: "multiple",
        columns: [
       	 {
            title: "부서코드",
            columns: [{
                field: "dept_seq",
                headerTemplate: function(){
    				return '<input type="text" style="width:90%;" id="searchDeptCd" class="deptHeaderInput">';
    	        },
     		}]
        }, {
            title: "부서명",
            columns: [{
                field: "dept_name",
                headerTemplate: function(){
    				return '<input type="text" style="width:90%;" id="searchDeptNm" class="deptHeaderInput">';
    	        },
     		}]
        }],
    }).data("kendoGrid");
	
	$(document).on('dblclick', '#deptList .k-grid-content tr', function(){
		var gData = $("#deptList").data('kendoGrid').dataItem(this);
		$('#' + popupId).val(gData.dept_name).attr('code', gData.dept_seq);
		$('#deptPopUp').data("kendoWindow").close();
	});

	$('.deptHeaderInput').on('keydown', function(key){
		 if (key.keyCode == 13) {
			 $("#deptList").data('kendoGrid').dataSource.read();
         }
	});

}

var budgetDataSource = new kendo.data.DataSource({
	serverPaging: true,
	pageSize: 10,
    transport: { 
        read:  {
            url:  "<c:url value='/common/getBudgetList' />",
            dataType: "json",
            type: 'post'
        },
      	parameterMap: function(data, operation) {
      		data.search_bCd = $('#searchBudgetCd').val();
      		data.search_bNm = $('#searchBudgetNm').val();
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
});

function budgetPopUpInit(){
	$('#budgetPopUp').kendoWindow({
		width: "600px",
	    title: '예산과목 조회',
	    visible: false,
	    modal : true,
	    actions: [
	        "Close"
	    ],
	}).data("kendoWindow").center();
	
	$("#budgetList").kendoGrid({
        dataSource: budgetDataSource,
        height: 460,
        sortable: false,
        pageable: false,
        persistSelection: true,
        selectable: "multiple",
        columns: [
       	 {
            title: "코드",
            columns: [{
                field: "BGT_CD",
                headerTemplate: function(){
    				return '<input type="text" style="width:90%;" id="searchBudgetCd" class="budgetHeaderInput">';
    	        },
     		}]
        }, {
            title: "예산과목명",
            columns: [{
                field: "BGT_NM",
                headerTemplate: function(){
    				return '<input type="text" style="width:90%;" id="searchBudgetNm" class="budgetHeaderInput">';
    	        },
     		}]
        }],
    }).data("kendoGrid");
	
	$(document).on('dblclick', '#budgetList .k-grid-content tr', function(){
		var gData = $("#budgetList").data('kendoGrid').dataItem(this);
		$('#' + popupId).val(gData.BGT_NM).attr('code', gData.BGT_CD);
		$('#budgetPopUp').data("kendoWindow").close();
	});

	$('.budgetHeaderInput').on('keydown', function(key){
		 if (key.keyCode == 13) {
			 $("#budgetList").data('kendoGrid').dataSource.read();
         }
	});
}

var budget2DataSource = new kendo.data.DataSource({
	serverPaging: true,
	pageSize: 10,
    transport: { 
        read:  {
            url:  "<c:url value='/common/getBudgetList2' />",
            dataType: "json",
            type: 'post'
        },
      	parameterMap: function(data, operation) {
      		data.search_bNm = $('#searchBudget2Nm').val();
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
});

function budgetPopUp2Init(){
	$('#budgetPopUp2').kendoWindow({
		width: "400px",
	    title: '목명 조회',
	    visible: false,
	    modal : true,
	    actions: [
	        "Close"
	    ],
	}).data("kendoWindow").center();
	
	$("#budgetList2").kendoGrid({
        dataSource: budget2DataSource,
        height: 460,
        sortable: false,
        pageable: false,
        persistSelection: true,
        selectable: "multiple",
        columns: [
        {
            title: "목명",
            columns: [{
                field: "bgt_nm",
                headerTemplate: function(){
    				return '<input type="text" style="width:90%;" id="searchBudget2Nm" class="budget2HeaderInput">';
    	        },
     		}]
        }
        ],
    }).data("kendoGrid");
	
	$(document).on('dblclick', '#budgetList2 .k-grid-content tr', function(){
		var gData = $("#budgetList2").data('kendoGrid').dataItem(this);
		$('#' + popupId).val(gData.bgt_nm);
		$('#budgetPopUp2').data("kendoWindow").close();
	});

	$('.budget2HeaderInput').on('keydown', function(key){
		 if (key.keyCode == 13) {
			 $("#budgetList2").data('kendoGrid').dataSource.read();
         }
	});
}

var carTemp = function(row){
	return row.car_yn == 'Y' ? '사용' : '미사용';
}
var stTemp = function(row){
	var returnVal = "";
	switch (row.abdocu_st) {
	case 10:
		returnVal = "임시보관";
		break;
	case 20:
		returnVal = "상신";
		break;
	case 90:
		returnVal = "결재완료";
		break;
	case 100:
		returnVal = "반려";
		break;
	case 999:
		returnVal = "삭제";
		break;
	default:
		returnVal = "";
		break;
	}
	return returnVal;
}
var reportTemp = function(row){
	var returnVal = "";
	if(row.abdocu_st == 90){
		if(row.report_st == 10){
			returnVal = "임시저장";
		}else if(row.report_st == 20){
			returnVal = "상신";
		}else if(row.report_st == 90){
			returnVal = "결재완료";
		}else{
			returnVal = '<div class="controll_btn" style="padding:0px;"><button type="button" id="" onclick="fnMoveReport(\''+row.bs_seq+'\');">결과보고</button><div>';
		}
	}
	return returnVal;
}

//프로젝트 호출
function getProject(id){
	popupId = id;
	$('#projectPopUp').data("kendoWindow").open().center();
	$("#projectList").data('kendoGrid').dataSource.read();
}

function getUser(id){
	popupId = id;
	$('#userPopUp').data("kendoWindow").open().center();
	$("#userList").data('kendoGrid').dataSource.read();
}

function getDept(id){
	popupId = id;
	$('#deptPopUp').data("kendoWindow").open().center();
	$("#deptList").data('kendoGrid').dataSource.read();
}

function getBudget(id){
	popupId = id;
	$('#budgetPopUp').data("kendoWindow").open().center();
	$("#budgetList").data('kendoGrid').dataSource.read();
}

function getBudget2(id){
	popupId = id;
	$('#budgetPopUp2').data("kendoWindow").open().center();
	$("#budgetList2").data('kendoGrid').dataSource.read();
}

function gridSearch(){
	$("#gridList").data('kendoGrid').dataSource.page(1);
}

function userPosition(emp_seq){
	var data = {};

	$.ajax({
		url: "<c:url value='/bsrp/getUserPosition' />",
		data : {emp_seq : emp_seq},
		async : false,
		type : 'POST',
		success: function(result){
			data = result;
		}
	});
	
	return data;
	
}

function fnMoveReport(bs_seq){
	window.location = "<c:url value='/bsrp/bsrpReportView?bs_seq=" + bs_seq + "' />";
}

function excelDown(){
	$("#gridList").getKendoGrid().saveAsExcel();
}

function excelDownload(){
	var excelUrl = "<c:url value='/bsrp/bsrpStatementListExcel' />";
	excelUrl += "?startDt=" + $('#startDt').val();
	excelUrl += "&endDt=" + $('#endDt').val();
	excelUrl += "&topSearchYear=" + $('#topSearchYear').val();
	excelUrl += "&topSearchPlace=" + encodeURI(encodeURIComponent($('#topSearchPlace').val()));
	excelUrl += "&topSearchEmp=" + ($('#topSearchEmp').attr('code') || "");
	excelUrl += "&topSearchDept=" + ($('#topSearchDept').attr('code') || "");
	excelUrl += "&topSearchProject=" + ($('#topSearchProject').attr('code') || "");
	excelUrl += "&topSearchState=" + $('#topSearchState').val();
	
	excelUrl += "&topSearchType1=" + $('#topSearchType1').val();
	excelUrl += "&topSearchType2=" + $('#topSearchType2').val();
	excelUrl += "&topSearchBudget1=" + ($('#topSearchBudget1').attr('code') || "");
	excelUrl += "&topSearchBudget2=" + encodeURI(encodeURIComponent($('#topSearchBudget2').val()));
	
	excelUrl += "&skip=" + 0;
	excelUrl += "&pageSize=" + 999999999;
	excelUrl += "&filename=" + encodeURI(encodeURIComponent("출장내역서"));
	excelUrl += "&templateFile=" + "bsrpStatementList.xlsx";
	
	if($("#mng").val() != "Y"){
		excelUrl += "&pjtCds=" + pjtCds;
	}
    window.location = excelUrl;
}

function paymentDtChange(obj){
	$(obj).val($(obj).val().toMoney2().toDate())
	changePaymentDts[$(obj).attr("bs_seq")] = $(obj).val();
}

function paymentDtSave(){
	if(confirm("지급일 변경내역을 저장합니다.")){
		$.ajax({
			url: "<c:url value='/bsrp/paymentDtSave' />",
			data : changePaymentDts,
			dataType : 'json',
			async : false,
			type : 'POST',
			success: function(result){
				gridSearch();
			}
		});
	}
}

function fnGetErpMgtList(){
	var data = {};
	data.EMP_CD = $("#erpEmpCd").val();
	data.FG_TY = "2";
	data.CO_CD = $("#erpCoCd").val();
	$.ajax({
		url: "<c:url value='/Ac/G20/Code/getErpMgtList.do' />",
		data : data,
		async : false,
		type : 'POST',
		success: function(result){
			pjtCds = "";
			$.each(result.selectList, function(inx){
				if(inx == 0){
					pjtCds += "'" + this.PJT_CD + "'";
				}else{
					pjtCds += ",'" + this.PJT_CD + "'";
				}
			});
		}
	});
}
</script>
</body>

