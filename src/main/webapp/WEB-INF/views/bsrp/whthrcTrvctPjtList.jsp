<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ page import="main.web.BizboxAMessage"%>

<body>
<script src="http://kendo.cdn.telerik.com/2019.2.619/js/jszip.min.js"></script>
<div class="iframe_wrap" style="min-width:1100px">

<input type="hidden" id="empSeq" value="${userInfo.uniqId}"/>
<input type="hidden" id="erpCoCd" value="${userInfo.erpCoCd}"/>
<input type="hidden" id="erpEmpCd" value="${userInfo.erpEmpCd}"/>
	<!-- 컨텐츠타이틀영역 -->
	<div class="sub_title_wrap">
		
		<div class="title_div">
			<h4>관내출장 리스트</h4>
		</div>
	</div>
	
	<div class="sub_contents_wrap">
	<p class="tit_p mt5 mt20">관내출장 리스트</p>

	<div class="com_ta">
				<div class="top_box gray_box">
					<dl>
						<dt style="width: 55px;">
							출장기간
						</dt>
						<dd style="line-height: 25px">
							<input type="text" id="startDt" style="width: 120px;"> ~ <input type="text" id="endDt" style="width: 120px;">
						</dd>

						<dt style="width: 30px; padding-left:30px;display: none;">
							부서
						</dt>
						<dd style="line-height: 25px;display: none;">
							<select id="topSearchDept" style="width: 100px;">
								<option value="all">전체</option>
								<option>부서1</option>
								<option>부서2</option>
							</select>
						</dd>
						
						<dt style="width: 30px; padding-left:30px;">
							단계
						</dt>
						<dd style="line-height: 25px">
							<select id="topSearchAbdocuSt" style="width: 80px;">
								<option value="all">전체</option>
								<option value="20">승인대기</option>
								<option value="90">승인</option>
							</select>
						</dd>
						
						<dt style="width: 55px; padding-left:30px;">
							프로젝트
						</dt>
						<dd style="line-height: 25px">
							<input type="text" id="topSearchProject" ondblclick="getProject('topSearchProject');"><a class="btn_search" onclick="getProject('topSearchProject');" style="margin-top: 1px;"></a>
						</dd>
						<dt style="width: 55px;padding-left:30px;"">
							출장자
						</dt>
						<dd style="line-height: 25px">
							<input type="text" id="topSearchUser" ondblclick="getUserInfo('topSearchUser');"><a class="btn_search" onclick="getUserInfo('topSearchUser');" style="margin-top: 1px;"></a>
						</dd>
					</dl>
				</div>
				
				<div class="btn_div">	
					<div class="right_div">
						<div class="controll_btn p0">										
							<button type="button" onclick="gridSearch();">조회</button>
							<button type="button" onclick="gridExcelBtn();">엑셀</button>
						</div>
					</div>
				</div>
				
				<div class="com_ta2 mt15">
				    <div id="gridList"></div>
				</div>
			</div>

	</div><!-- //sub_contents_wrap -->
</div><!-- iframe wrap -->

<div class="pop_wrap_dir" id="userPopUp" style="width: 600px; display: none;">
	<div class="pop_con">
		<div class="com_ta2">
			<div id="userList"></div>
		</div>
	</div>
	<!-- //pop_con -->
</div>

<div class="pop_wrap_dir" id="projectPopUp" style="width: 500px; display: none;">
	<div class="pop_con">
		<div class="com_ta2">
			<div id="projectList"></div>
		</div>
	</div>
	<!-- //pop_con -->
</div>


<script>
var popupId = '';
var dataSource = new kendo.data.DataSource({
	serverPaging: true,
	pageSize: 10,
    transport: { 
        read:  {
            url:  "<c:url value='/bsrp/whthrcTrvctListSerch' />",
            dataType: "json",
            type: 'post'
        },
      	parameterMap: function(data, operation) {
      		data.startDt = $('#startDt').val();
      		data.endDt = $('#endDt').val();
      		data.topSearchDept = $('#topSearchDept').val();
      		data.topSearchAbdocuSt = $('#topSearchAbdocuSt').val();
      		data.topSearchProject = $('#topSearchProject').attr('code');
      		data.topSearchUser = $('#topSearchUser').attr('code');
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

var projectDataSource = new kendo.data.DataSource({
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
			console.log(response.selectList);
        	return response.selectList;
      },
      total: function(response) {
	        return response.totalCount;
	      }
    }
});

$(function(){
	
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
	
	$('#userPopUp').kendoWindow({
		width: "600px",
	    title: '사용자 조회',
	    visible: false,
	    modal : true,
	    actions: [
	        "Close"
	    ],
	}).data("kendoWindow").center();
	
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
		autoBind: false,
        dataSource: dataSource,
        height: 460,
        sortable: true,
        pageable: {
            refresh: true,
            pageSizes : [10,20,30,50,100],
            buttonCount: 5
        },
        excel:{
      	    fileName:"관내 출장 리스트.xlsx",
      	    allPages:true, 
      	},
      	excelExport: function(e) {
      		
      		//커스텀 템플릿 데이터 가공
      		var data = e.workbook.sheets[0].rows;
      		for (var i = 1; i < data.length; i++) {
				var cell = data[i];
				var dataIndex = i-1 ;
      			cell.cells[2].value = stTemp(e.data[dataIndex]);
      			cell.cells[3].value = fsseTemp(e.data[dataIndex]);
      			cell.cells[7].value = carTemp(e.data[dataIndex]);
      			cell.cells[9].value = totalTemp(e.data[dataIndex]);
			}
      		
      	},
        persistSelection: true,
        selectable: "multiple",
        columns: [
       	 {
       	    field: "rqstdt",
            title: "출장일",
            width: "70px"
       	}, {
            field: "bs_des_txt",
            title: "출장지",
            width: "55px"
        }, {
       	 	field: "abdocu_st",
            template : stTemp,
            title: "단계",
            width: "60px"
        }, {
        	field: "fsse",
            template : fsseTemp,
            title: "회계구분",
            width: "65px"
        }, {
            field: "pjt_nm",
            title: "프로젝트명",
            width: "200px"
        }, {
            field: "applcnt_dept",
            title: "부서명",
            width: "80px"
        }, {
            field: "applcnt_nm",
            title: "성명",
            width: "60px"
        }, {
        	field: "car_yn",
            template : carTemp,
            title: "업무차량",
            width: "65px"
        }, {
            field: "rm",
            title: "목적",
            width: "310px"
        }, {
        	field: "total",
            template : totalTemp,
            title: "비용",
            width: "70px"
        }],
    }).data("kendoGrid");
	
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
	
	$(document).on('dblclick', '#userList .k-grid-content tr', function(){
		var gData = $("#userList").data('kendoGrid').dataItem(this);
		if(popupId == 'topSearchUser'){
			$('#' + popupId).val(gData.emp_name).attr('code', gData.emp_seq);
		}else if(popupId == 'userName'){
			$('#' + popupId).val(gData.emp_name).attr('code', gData.emp_seq);
			$('#userDept').val(gData.dept_name);
		}else{
			$('#' + popupId).val(gData.emp_name).attr('code', gData.emp_seq);
		}
		
		$('#userPopUp').data("kendoWindow").close();
		
	});

	$('.userHeaderInput').on('keydown', function(key){
		 if (key.keyCode == 13) {
			 $("#userList").data('kendoGrid').dataSource.read();
         }
	});

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
	
	
});

var totalTemp = function(row){
	return numberWithCommas(row.total) + '원';
}
var carTemp = function(row){
	return row.car_yn == 'Y' ? '사용' : '미사용';
}
var stTemp = function(row){
	return row.abdocu_st == 20 ? '승인대기' : row.abdocu_st == 90 ? '승인' : '';
}
var fsseTemp = function(row){
	return row.fsse == 1 ? '일반회계' : '특별회계';
}

function gridExcelBtn(){
	if(!$("#topSearchProject").attr("code")){
		alert("프로젝트를 선택하세요.");
		return;
	}
	$("#gridList").getKendoGrid().saveAsExcel();
	
}

function getUserInfo(id){
	popupId = id;
	$('#userPopUp').data("kendoWindow").open().center();
	$("#userList").data('kendoGrid').dataSource.read();
}


//프로젝트 호출
function getProject(id){
	popupId = id;
	$('#projectPopUp').data("kendoWindow").open().center();
	$("#projectList").data('kendoGrid').dataSource.read();
	
}

function gridSearch(){
	if(!$("#topSearchProject").attr("code")){
		alert("프로젝트를 선택하세요.");
		return;
	}
	$("#gridList").data('kendoGrid').dataSource.page(1);
}


</script>
</body>

