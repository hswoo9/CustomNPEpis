<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>


<div class="iframe_wrap" style="min-width:1100px">

	<div class="sub_title_wrap">
		<div class="title_div">
			<h4>제안평가 보기</h4>
		</div>
	</div>

	<div class="sub_contents_wrap" style="min-width:1400px; min-height: 0px;">
		<div class="left_div">
			<p class="tit_p mt5 mb10">제안평가 보기</p>
		</div>
		
		<div class="com_ta">
			<div class="top_box gray_box" id="newDate">
			
				<dl>
					<dt style="">
						요구부서
					</dt>
					<dd style="line-height: 25px">
						<input type="text" name="req_dept_name" id="req_dept_name" readonly="readonly">			
						<input type="hidden" name="req_dept_seq" id="req_dept_seq">	
						<img alt="" src="../Images/btn/search_icon2.png" style="cursor: pointer;" onclick="deptSearchPopup();">		
					</dd>
	
					<dt style="margin-left:50px;">
						사업명
					</dt>
					<dd style="line-height: 25px">
						<input type="text" id="title" class="searchInput" style="width: 250px;">
					</dd>

					<dt style="margin-left:50px;">
						평가일시
					</dt>
					<dd style="line-height: 25px">
						<input type="text" id="eval_date" class="date_yyyymmdd">
					</dd>
	
				</dl>
				
			</div>
			
		</div>

	</div>
	
	<div class="sub_contents_wrap">
<!-- 		<div class="left_div" style="float: left; padding-left: 15px;"> -->
<!-- 			<div class="controll_btn p0"> -->
<!-- 				<input type="radio" name="pageType" id="pageType_1" value="1" checked="checked"><label for="pageType_1">구매사업</label>&emsp;&emsp; -->
<!-- 				<input type="radio" name="pageType" id="pageType_2" value="2"><label for="pageType_2">신규사업</label>&emsp;&emsp; -->
<!-- 			</div> -->
<!-- 		</div>	 -->
		<div class="right_div">
			<div class="controll_btn p0">
<!-- 				<button type="button" id="search" onclick="newSaveBtn(2);">등록</button> -->
				<button type="button" id="search" onclick="searchBtn();">조회</button>
			</div>
		</div>	
		
		<div class="com_ta2 mt15">
		    <div id="gridList"></div>
		</div>
	</div>
</div>

<form id="evalResultForm" target="evalResult" action="<c:url value='/eval/evalResult' />" method="post">
	<input type="hidden" id="committee_seq" name="code" value="">
</form>

<script>
var pageInfo = {
        refresh: true,
        pageSizes: [10, 20, 40],
        buttonCount: 5,
        messages: {
            display: "{0} - {1} of {2}",
            itemsPerPage: "",
            empty: "데이터가 없습니다.",
        }
};

var gridDataSource = new kendo.data.DataSource({
	serverPaging: true,
	pageSize: 10,
    transport: { 
        read:  {
            url: "<c:url value='/eval/evaluationProposalListSearch' />",
            dataType: "json",
            type: "post"
        },
      	parameterMap: function(data, operation) {
      		data.title = $('#title').val();
      		data.req_dept_seq = $('#req_dept_seq').val();
      		data.eval_date = $('#eval_date').val();
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
	var emp_seq = "${loginVO.uniqId}";
	var erpEmpCd = "${loginVO.erpEmpCd}";
	if (String(emp_seq) == "1" || String(erpEmpCd) == "160201001" || String(erpEmpCd) == "180319013" || String(erpEmpCd) == "120917004" || String(erpEmpCd) == "120523007" || String(erpEmpCd) == "120523022") {
	} else {
		$("#req_dept_name").val("${loginVO.orgnztNm}");
		$("#req_dept_seq").val("${loginVO.dept_seq}");
	}
	
	$('#searchSelect').kendoDropDownList();
	
	$('.date_yyyymmdd').kendoDatePicker({
     	culture : "ko-KR",
	    format : "yyyy-MM-dd",
	});
	
	$(".date_yyyymmdd").attr("readonly", true);
	
	$("#gridList").kendoGrid({
	    dataSource: gridDataSource,
	    height: 600,
	    sortable: false,
	    pageable: pageInfo,
	    columns: [
    	{
	    	template: stepTemp,
	        title: "상태",
    	},{
	    	field: "eval_doc_num",
	        title: "접수번호",
    	},{
    		field: "req_date",
    		template: reqDateTemp,
	        title: "요청일자",
    	},{
    		field: "req_dept_name",
	        title: "요구부서",
    	},{
    		template: oprEmpNameTemp,
	        title: "운영요원",
    	},{
    		template: oprEmpNameTempConF,
	        title: "확인자",
    	},{
    		field: "title",
	        title: "사업명",
    	},{
    		field: "budget",
    		template: budgetTemp,
	        title: "사업예산",
    	},{
    		field: "eval_date",
    		template: evalDateTemp,
	        title: "평가일시",
    	},{
    		field: "eval_place",
	        title: "평가장소",
    	},{
    		field: "join_org_cnt",
	        title: "참여기관수",
    	},{
    		field: "commissioner_cnt",
	        title: "평가위원수",
    	},{
			width:"400px;",
    		template: gridModBtn,
	    }],
	}).data("kendoGrid");
	
	$('.searchInput').on('keydown', function(key){
		if (key.keyCode == 13) {
			searchBtn();
       }
	});
	
});

var oprEmpNameTemp = function(row){
	var txt = '';
	for (var i = 1; i <= 5; i++) {
		
		var s = row["opr_emp_name_" + i];
		if(s != ''){

			if(i > 1){
				txt += '<br>';
			}
			
			txt += s;
		}
	}	
	return txt;
}

var oprEmpNameTempConF = function(row){
	var txt = '';
	for (var i = 1; i <= 4; i++) {
		var s = row["opr_emp_name_" + i];
		if(s != null && s != ''){

			if(i >= 2){
				txt += '<br>';
			}
			
			txt += s;
		}
	}	
	return txt;
}

var budgetTemp = function(row){
	return row.budget.toLocaleString() + '원';
}

var stepTemp = function(row){

	var resultList = [];
	var sumPay = 0;

	$.ajax({
		url: "<c:url value='/eval/getEvalCommUserList' />",
		data : {code : row.committee_seq},
		type : 'POST',
		async: false,
		success: function(result){
			resultList = result.list;
		}

	});
	if(row.final_approval_active == 'Y') {
		return row.step == 'S' ? '평가종료' : '최종승인';
	}else if (row.step == 'S') {
		return '평가종료'
	}else if (Number(resultList.length) > Number(0)) {
		for(let i=0; i<resultList.length; i++) {
			sumPay += Number(resultList[i].eval_pay);
		}

		if (sumPay > 0) {
			return '평가수당<br>생성 완료';
		} else {
			return '평가위원<br>생성 완료';
		}

	}else {
		console.log("true or false" + resultList.length > 0);
		return row.step == 'I' ? '임시저장' : row.step == 'A' ? '등록' : row.step == 'S' ? '평가종료' : '';
	}


	sumPay=0;
}

var reqDateTemp = function(row){
	return moment(row.req_date).format('YYYY-MM-DD');
}

var evalDateTemp = function(row){
	return moment(row.eval_s_date).format('YYYY-MM-DD');
}

var gridModBtn = function(row){
	var html = '<input type="button" value="평가보기" onclick="evalResultBtn(this);">';
	if(row.step == 'S') {
		html = '<input type="button" value="평가보기" onclick="evalResultBtn(this);"> <input type="button" value="다운로드" onclick="downloadSPDF(this);">';
	}
	return html;
}

function newSaveBtn(v){
	location.href = "<c:url value='/eval/evaluationProposalView?pageCode=2' />";
}

function deptPopupClose(deptSeq, deptName){
	$('#req_dept_name').val(deptName);
	$('#req_dept_seq').val(deptSeq);
}

function deptSearchPopup(){
	window.open( _g_contextPath_ +'/common/deptPopup', '조직도', 'scrollbars=yes, resizeble=yes, menubar=no, toolbar=no, location=no, directories=yes, status=yes, width=355, height=700');
}

function searchBtn(){
	$("#gridList").data("kendoGrid").dataSource.page(1);
}

function evalResultBtn(e){
	var tr = $(e).closest("tr");
	var row = $('#gridList').data("kendoGrid").dataItem(tr);
	$('#committee_seq').val(row.committee_seq);
	
	window.open("", "evalResult", 'toolbar=no, scrollbar=yes, width=1500px, height=900px, resizable=no, status=no');
	$('#evalResultForm').submit();
}

function downloadSPDF(e) {
	var tr = $(e).closest("tr");
	var row = $('#gridList').data("kendoGrid").dataItem(tr);
	
	window.location.assign("<c:url value='/eval/evalProposalModFileDownload2'/>?committee_seq="+row.committee_seq+"&name="+row.title);
}

</script>








