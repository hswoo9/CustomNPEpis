<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ page import="main.web.BizboxAMessage"%>

<body>

<div class="iframe_wrap" style="min-width:1100px">

<input type="hidden" id="empSeq" value="${userInfo.uniqId}"/>
<input type="hidden" id="erpCoCd" value="${userInfo.erpCoCd}"/>
<input type="hidden" id="erpEmpCd" value="${userInfo.erpEmpCd}"/>
<input type="hidden" id="mylist" value="${param.mylist}"/>
	<!-- 컨텐츠타이틀영역 -->
	<div class="sub_title_wrap">
		
		<div class="title_div">
			<h4>출장신청 리스트</h4>
		</div>
	</div>
	
	<div class="sub_contents_wrap">
	<p class="tit_p mt5 mt20">관외여비 사용자</p>

	<div class="com_ta">
				<div class="top_box gray_box">
					<dl>
						<dt style="width: 55px;">
							출장기간
						</dt>
						<dd style="line-height: 25px">
							<input type="text" id="startDt"> ~ <input type="text" id="endDt">
						</dd>

						<dt style="width: 55px; padding-left:40px;">
							프로젝트
						</dt>
						<dd style="line-height: 25px">
							<input type="text" id="topSearchProject" ondblclick="getProject('topSearchProject');"><a class="btn_search" onclick="getProject('topSearchProject');" style="margin-top: 1px;"></a>
						</dd>
						<dt style="width: 55px; padding-left:40px;">
							이름
						</dt>
						<dd style="line-height: 25px">
							<input type="text" id="topSearchUser" ondblclick="getUser('topSearchUser');"><a class="btn_search" onclick="getUser('topSearchUser');" style="margin-top: 1px;"></a>
						</dd>
					</dl>
				</div>
				
				<div class="btn_div">	
					<div class="right_div">
						<div class="controll_btn p0">										
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

<script>
var erpOption = {BgtMngType: "2", CauseUseYn: "1", BizGovUseYn: "0", BgtAllocatUseYn: "0", BottomUseYn: "0"};
var popupId = '';
var pjtCds = "";
var dataSource = new kendo.data.DataSource({
	serverPaging: true,
	pageSize: 10,
    transport: { 
        read:  {
            url:  "<c:url value='/bsrp/bsrpReqstListSerch' />",
            dataType: "json",
            type: 'post'
        },
      	parameterMap: function(data, operation) {
      		data.startDt = $('#startDt').val();
      		data.endDt = $('#endDt').val();
      		data.topSearchDept = 'all';
      		data.topSearchAbdocuSt = 'all';
      		data.topSearchProject = $('#topSearchProject').attr('code');
      		data.topSearchUser = $('#topSearchUser').attr('code');
      		data.pjtCds = pjtCds;
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

$(function(){
	fnGetErpMgtList();
	
	var startDate = $('#startDt').kendoDatePicker({
	    culture : "ko-KR",
	    format : "yyyy-MM-dd",
	    value : moment().add('month', -1).format('YYYY-MM-DD'),
	    change: startChange
	}).attr("readonly", true).data("kendoDatePicker");

	var endDate = $('#endDt').kendoDatePicker({
	    culture : "ko-KR",
	    format : "yyyy-MM-dd",
	    value : moment().add('month', 1).format('YYYY-MM-DD'),
	}).attr("readonly", true).data("kendoDatePicker");

	function startChange(){
		if(startDate.value() > endDate.value()){
			endDate.value('');
		}
		endDate.min(startDate.value());
	}
	
	$('#projectPopUp').kendoWindow({
		width: "500px",
	    title: '프로젝트 조회',
	    visible: false,
	    modal : true,
	    actions: [
	        "Close"
	    ],
	}).data("kendoWindow").center();
	
	$("#gridList").kendoGrid({
        dataSource: dataSource,
        height: 460,
        sortable: true,
        pageable: {
            refresh: true,
            pageSizes : [10,20,30,50,100],
            buttonCount: 5
        },
        persistSelection: true,
        selectable: "multiple",
        columns: [
           	{
                field: "rqstdt",
                template : dtTemp,
                title: "출장기간",
            }, {
                field: "abdocu_st",
                template : stTemp,
                title: "결재상태",
            }, {
                field: "fsse",
                template : fsseTemp,
                title: "회계구분명",
            }, {
                field: "pjt_nm",
                title: "프로젝트명",
            }, {
                field: "abgt_nm",
                title: "예산과목명",
            }, {
                field: "applcnt_dept",
                title: "부서명",
            }, {
                field: "applcnt_nm",
                title: "성명",
            }, {
                field: "car_yn",
                template : carTemp,
                title: "업무차량사용여부",
            }, {
                field: "rm",
                title: "목적",
            }, {
                field: "total",
                template : totalTemp,
                title: "비용",
            }, {
                field: "",
                template : reportTemp,
                title: "결과보고",
            }, {
                field: "return_reason",
                title: "반송사유",
            }
    	],
    }).data("kendoGrid");
	
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
	
	$(".headerCheckbox").change(function(){
		if($(this).is(":checked")){
			$(this).closest('table').parent().parent().parent().find('.checkbox').prop("checked", "checked");
        }else{
        	$(this).closest('table').parent().parent().parent().find('.checkbox').removeProp("checked");
        }
    
	});
	
	userPopUpInit();
});

var totalTemp = function(row){
	return numberWithCommas(row.total) + '원';
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
var fsseTemp = function(row){
	return row.fsse == 10 ? '일반회계' : '특별회계';
}
var reportTemp = function(row){
	var returnVal = "";
	if(row.abdocu_st == 90){
		if(row.report_st == 10){
			returnVal = "임시저장";
		}else if(row.report_st == 20){
			returnVal = "상신";
		}else if(row.report_st == 90){
			returnVal = '<div class="controll_btn" style="padding:0px;"><button type="button" id="" onclick="fnMoveReport2(\''+row.bs_seq+'\');">결재완료</button><div>';
		}else if(row.confer_return > 0){
			returnVal = "예산환원";
		}else{
			returnVal = '<div class="controll_btn" style="padding:0px;"><button type="button" id="" onclick="fnMoveReport(\''+row.bs_seq+'\');">결과보고</button><div>';
		}
	}
	return returnVal;
}
var dtTemp = function(row){
	return row.bs_start + "~" + row.bs_end;
}
//프로젝트 호출
function getProject(id){
	popupId = id;
	$('#projectPopUp').data("kendoWindow").open().center();
	$("#projectList").data('kendoGrid').dataSource.read();
	
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

function fnMoveReport2(bs_seq){
	window.location = "<c:url value='/bsrp/bsrpReportView2?bs_seq=" + bs_seq + "' />";
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
			console.log(result);
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

function getUser(id){
	popupId = id;
	$('#userPopUp').data("kendoWindow").open().center();
	$("#userList").data('kendoGrid').dataSource.read();
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
</script>
</body>

