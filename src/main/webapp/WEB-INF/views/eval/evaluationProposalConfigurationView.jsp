<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>

<input type="hidden" id="menuCd" name="menuCd" value="eval">
<div class="iframe_wrap" style="min-width:1100px">

	<div class="sub_title_wrap">
		<div class="title_div">
			<h4>제안평가 등록</h4>
		</div>
	</div>

	<div class="sub_contents_wrap" style="min-width:1400px; min-height: 0px;">
		<div class="left_div">
			<p class="tit_p mt5 mb10">제안평가 등록</p>
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
		<div class="right_div">
			<div class="controll_btn p0">
				<button type="button" id="search" onclick="newSaveBtn(2);">등록</button>
				<button type="button" id="search" onclick="searchBtn();">조회</button>
			</div>
		</div>	
		
		<div class="com_ta2 mt15">
		    <div id="gridList"></div>
		</div>
		
	</div>

</div>

<script>
var emp_seq = "${loginVO.uniqId}";
if (String(emp_seq) == "1"
    || String(emp_seq) == "1252"
    || String(emp_seq) == "1282"
    || String(emp_seq) == "1258"
    || String(emp_seq) == "1314"
    || String(emp_seq) == "1397"
    || String(emp_seq) == "1299"
    || String(emp_seq) == "1385"
    || String(emp_seq) == "1246"
    || String(emp_seq) == "1266") {

} else {
	$("#req_dept_name").val("${loginVO.orgnztNm}");
	$("#req_dept_seq").val("${loginVO.dept_seq}");
}

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
			url: "<c:url value='/eval/evaluationProposalConfigurationListSearch' />",
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
	for (var i = 6; i <= 7; i++) {
		var s = row["opr_emp_name_" + i];
		if(s != null && s != ''){

			if(i > 6){
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
	
	if(row.final_approval_active == 'Y'){
		return row.step == 'S' ? '평가종료' : '최종승인';
	}else{
		return row.step == 'I' ? '임시저장' : row.step == 'A' ? '등록' : row.step == 'S' ? '평가종료' : row.step == 'C' ? '구성요청서<br>등록' : row.step == 'K' ? '구성요청서<br>결재완료' : '';
	}
	
}

var reqDateTemp = function(row){
	return moment(row.req_date).format('YYYY-MM-DD');
}

var evalDateTemp = function(row){
	return moment(row.eval_s_date).format('YYYY-MM-DD');
}

var gridModBtn = function(row){
	//console.log("${loginVO.uniqId}");
	//console.log("row : " + row.create_emp_seq);
	var login_seq = "${loginVO.uniqId}";
	var row_seq = row.create_emp_seq;
	//alert (Number(login_seq) == Number(row_seq));

	if(row.step == 'C') {
		if(row.STATUS == "0"){
			if (Number(login_seq) == Number(row_seq)){
				return "<input type='button' value='상신' onclick=\"evalDrafting("+row.committee_seq+", 'drafting')\"> "
						+ " <input type='button' value='삭제' onclick=\"gridDel(this);\">";
			}else {
				return "상신중";
			}
		} else if(row.STATUS == "30" || row.STATUS == "40"){
			if (Number(login_seq) == Number(row_seq)){
				return "<input type='button' value='재상신' onclick=\"evalDrafting("+row.committee_seq+", 'drafting')\"> "
						+ " <input type='button' value='삭제' onclick=\"gridDel(this);\">";
			}else {
				return "회수 혹은 반려됨";
			}
		} else if(row.STATUS == "10" || row.STATUS == "20" || row.STATUS == "50"){
			if (Number(login_seq) == Number(row_seq)){
				return "<input type='button' value='회수' onclick=\"evalApprovalRetrieve("+row.DOC_ID+", "+row.committee_seq+", 'retrieve')\"> "
						+ "<input type='button' value='결재' onclick=\"approveDocView("+row.DOC_ID+", "+row.committee_seq+")\"> "
						+ " <input type='button' value='삭제' onclick=\"gridDel(this);\">";
			}else {
				return "<input type='button' value='결재' onclick=\"approveDocView("+row.DOC_ID+", "+row.committee_seq+")\"> ";
			}
		} else if(row.STATUS == "100"){
		} else {
			if (Number(login_seq) == Number(row_seq)){
				return "<input type='button' value='상신' onclick=\"evalDrafting("+row.committee_seq+", 'drafting')\"> "
						+ " <input type='button' value='삭제' onclick=\"gridDel(this);\">";
			}else {
				return "상신중";
			}
		}

	}else {
		if (Number(login_seq) == Number(row_seq)){
			return "<input type='button' value='결재완료' onclick=\"approveDocView("+row.DOC_ID+", "+row.committee_seq+")\"> "
					+ " <input type='button' value='상세' onclick='gridDetail(this);'> "
					+ " <input type='button' value='삭제' onclick='gridDel(this);'> ";
		}else {
			return "<input type='button' value='결재완료' onclick=\"approveDocView("+row.DOC_ID+", "+row.committee_seq+")\"> ";
		}
	}
}
// var gridModBtn = function(row){
// 	return '<input type="button" value="평가위원생성" onclick="commCrtBtn(this);"> <input type="button" value="ID 발급" onclick="gridIdCrtBtn(this);"> <input type="button" value="평가수당" onclick="gridTransExpBtn(this);"> <input type="button" value="상세" onclick="gridDetail(this);"> <input type="button" value="삭제" onclick="gridDel(this);"> <input type="button" value="최종승인" onclick="gridConfirm(this);">';
// }

function newSaveBtn(v){
// 	location.href = "<c:url value='/eval/evaluationProposalView?pageCode=' />"+$('input[name=pageType]:checked').val();
	location.href = "<c:url value='/eval/evaluationProposalConfiguration' />";
}

let popWin = "";
let popWin2 = "";
let menuCd = $("#menuCd").val();

function evalDrafting(evalReqId, type){
	popWin = window.open(getContextPath()+"/eval/evalApprovalPop?menuCd="+ menuCd +"&type="+ type +"&evalReqId="+evalReqId, "evalApprovalPop", "width=1030, height=930, scrollbars=no, top=100, left=200, resizable=no, toolbars=no, menubar=no");

	//popWin = window.open(getContextPath()+"/eval/evaluationProposalConfigurationView");
}

function evalReferDrafting(docId, evalReqId, type){
	popWin = window.open(getContextPath()+"/eval/evalApprovalPop?menuCd="+ menuCd + "&docId=" + docId + "&type=" + type + "&vacUseHistId="+evalReqId, "holidayApprovalPop", "width=1030, height=930, scrollbars=no, top=100, left=200, resizable=no, toolbars=no, menubar=no");
}

function evalApprovalRetrieve(docId, evalReqId, type){
	if(confirm("문서를 회수하시겠습니까?")){
		$.ajax({
			url : getContextPath()+"/approval/setApproveRetrieve.do",
			data : {
				empSeq : $("#empSeq").val(),
				docId : docId,
				evalReqId : evalReqId,
				approveEmpSeq : $("#empSeq").val(),
				cmCodeNm : type
			},
			type : 'POST',
			dataType : "json",
			async : false,
			success : function (){
				alert("문서가 회수되었습니다.");
				gridReload();
			},
			error : function(){
				alert("문서가 회수 중 에러가 발생했습니다.");
			}
		})
	}
}


function approveDocView(docId, evalReqId){
	$("#secondCard").empty();

	var html = '<div class="card">' +
			'<div class="col-lg-11" style="margin:0 auto;">' +
			'<div class="table-responsive" id="iframeDiv" style="padding-top: 20px;padding-bottom: 20px; height: 700px;">' +
			'   <iframe src="/approval/approvalDocView.do?docId='+docId+'&menuCd=${menuCd}&id='+evalReqId+'" style="width:100%;height: 100%" id="docIframe" name="docIframe" scrolling="no"></iframe>' +
			'</div>' +
			'</div>' +
			'</div>';
	//$("#secondCard").append(html);

	var pop = "" ;
	var url = getContextPath() + '/approval/approvalDocView.do?docId='+docId+'&menuCd=${menuCd}&id='+evalReqId;
	var width = "1000";
	var height = "950";
	windowX = Math.ceil( (window.screen.width  - width) / 2 );
	windowY = Math.ceil( (window.screen.height - height) / 2 );
	pop = window.open(url, '결재 문서', "width=" + width + ", height=" + height + ", top="+ windowY +", left="+ windowX +", resizable=NO, scrollbars=NO");
	//pop.focus();
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

function gridDel(e){
	
	if(confirm('삭제하시겠습니까?')){
		var tr = $(e).closest("tr");
		var row = $('#gridList').data("kendoGrid").dataItem(tr);
		
		$.ajax({
			url: "<c:url value='/eval/evaluationProposalListDel' />",
			data : {code : row.committee_seq, purc_req_id : row.purc_req_id},
			type : 'POST',
			success: function(result){
				alert("삭제하였습니다.");
				searchBtn();
			}
		});
	}
}

function gridDetail(e){
	var tr = $(e).closest("tr");
	var row = $('#gridList').data("kendoGrid").dataItem(tr);
	location.href = "<c:url value='/eval/evaluationProposalMod?code='/>" + row.committee_seq;
}

function gridReload(){
	$("#gridList").data("kendoGrid").dataSource.read();
}
window.gridReload = gridReload;

</script>








