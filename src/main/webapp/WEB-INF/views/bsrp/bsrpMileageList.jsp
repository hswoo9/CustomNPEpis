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
			<h4>항공마일리지 조회</h4>
		</div>
	</div>
	
	<div class="sub_contents_wrap">
	<p class="tit_p mt5 mt20">항공마일리지 조회</p>

	<div class="com_ta">
				<div class="top_box gray_box">
					<dl>
						<dt style="width: 60px;">항공구분</dt>
						<dd>
							<input type="text" id=""/>
						</dd>
						<dt style="width: 60px;">사용부서</dt>
						<dd style="width: 150px;">
							<input type="text" id="topSearchDept" ondblclick="getDept('topSearchDept');"/>
							<a class="btn_search" onclick="getDept('topSearchDept');" style="margin-top: 1px;"></a>
						</dd>
						<dt style="width: 50px;">사용자</dt>
						<dd>
							<input type="text" id="topSearchEmp" ondblclick="getUser('topSearchEmp');"/>
							<a class="btn_search" onclick="getUser('topSearchEmp');" style="margin-top: 1px;"></a>
						</dd>
					</dl>
					<dl>
						<dt style="width: 60px;">
							사용일자
						</dt>
						<dd>
							<input type="text" id="startDt" style="width: 120px;"> ~ <input type="text" id="endDt" style="width: 120px;">
						</dd>
					</dl>
				</div>
				
				<div class="btn_div">	
					<div class="right_div">
						<div class="controll_btn p0">										
							<button type="button" onclick="gridSearch();">조회</button>
							<button type="button" id="" onclick="excelDown();">엑셀</button>
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
var popupId = '';

$(function(){
	init();
	gridInit();
	popUpInit();
	
});

function init(){
	var startDate = $('#startDt').kendoDatePicker({
	    culture : "ko-KR",
	    format : "yyyy-MM-dd",
	    value : '0000-00-00',
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
}

var dataSource = new kendo.data.DataSource({
	type: "odata",
	serverPaging: true,
	serverSorting: true,
	pageSize: 20,
    transport: { 
        read:  {
            url:  "<c:url value='/bsrp/bsrpMileageListSerch' />",
            dataType: "json",
            type: 'post'
        },
      	parameterMap: function(data, operation) {
      		data.startDt = $('#startDt').val();
      		data.endDt = $('#endDt').val();
      		data.topSearchEmp = $('#topSearchEmp').attr('code');
      		data.topSearchDept = $('#topSearchDept').attr('code');
      		data.topSearchAirline = $('#topSearchAirline').val();
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
            fileName: "항공마일리지내역.xlsx",
			allPages: true
        },
        columns: [
            {
                field: "row_num",
                title: "No",
                width: 40,
            }, {
                field: "dept_name",
                title: "부서명",
                width: 120,
            }, {
                field: "position_name",
                title: "직급",
                width: 80,
            }, {
                field: "emp_num",
                title: "사원번호",
                width: 80,
            }, {
                field: "emp_name",
                title: "사원명",
                width: 80,
            }, {
                field: "bs_start",
                title: "출장일자",
                width: 80,
            }, {
                field: "bs_des_txt",
                title: "목적지",
                width: 100,
            }, {
                field: "airline",
                title: "항공사",
                width: 80,
            }, {
                field: "new_mileage",
                title: "적립마일리지",
                width: 80,
            }, {
                field: "use_mileage",
                title: "사용마일리지",
                width: 80,
            }
		],
    }).data("kendoGrid");
}

function popUpInit(){
	userPopUpInit();
	deptPopUpInit();
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

function gridSearch(){
	$("#gridList").data('kendoGrid').dataSource.page(1);
}

function excelDown(){
	$("#gridList").getKendoGrid().saveAsExcel();
}
</script>
</body>

