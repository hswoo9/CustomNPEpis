<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>



<div class="iframe_wrap" style="min-width:1100px">

	<div class="sub_title_wrap">
		
		<div class="title_div">
			<h4>평가위원 아이디생성</h4>
		</div>
	</div>

	<div class="sub_contents_wrap" style="min-height:0px;">
		<p class="tit_p mt5 mt10">평가위원 아이디생성</p>
		
		<form id="dataForm" action="">
		<div class="com_ta">
			<div class="top_box gray_box">
				<input type="hidden" id="eval_id_seq" name="eval_id_seq">
				<input type="hidden" id="active" name="active">
				<dl>
					<dt style="">
						생성자
					</dt>
					<dd style="line-height: 25px">
						<input type="text" name="create_dept" id="create_dept" readonly="readonly" value="${userInfo.orgnztNm}">
						<input type="hidden" name="create_dept_seq" id="create_dept_seq" style="width: 70px;" value="${userInfo.dept_seq}">
						<input type="text" name="create_emp_name" id="create_emp_name" style="width: 70px;" readonly="readonly" value="${userInfo.name}">
						<input type="hidden" name="create_emp_seq" id="create_emp_seq" style="width: 70px;" value="${userInfo.uniqId}">
					</dd>
	
					<dt style="margin-left:70px;">
						생성일시
					</dt>
					<dd style="line-height: 25px">
						<input type="text" style="width: 100px;" class="date_yyyymmdd" name="create_date" id="create_date">
					</dd>
	
					<dt style="margin-left:70px;">
						ID
					</dt>
					<dd style="line-height: 25px">
						<input type="text" name="eval_user_id" id="eval_user_id" onkeydown="idChkFlagBtn();" >
						<input type="button" onclick="chkIdBtn();" value="중복확인">
					</dd>

					<dt style="margin-left:70px;">
						PW
					</dt>
					<dd style="line-height: 25px">
						<input type="text" name="eval_user_pw" id="eval_user_pw">
					</dd>

					<dt style="margin-left:70px;">
						정렬순서
					</dt>
					<dd style="line-height: 25px">
						<input type="text" name="order_no" id="order_no" style="width: 50px;">
					</dd>
					
					<dt style="margin-left:50px;">
						<input type="checkbox" checked="checked" id="active_chk"><label for="active_chk">활성</label>
					</dt>
					
				</dl>
				
			</div>

		</div>
		</form>
		
		
	</div>
	
	<div class="sub_contents_wrap">
		
		<div class="right_div">
			<div class="controll_btn p0">
				<button type="button" onclick="resetInput();">신규</button>
				<button type="button" id="saveBtn" onclick="newSaveBtn();">저장</button>
				<button type="button" onclick="delDataBtn();">삭제</button>
			</div>
		</div>	
		
		<div class="com_ta">
			
			<div class="com_ta2 mt15">
			    <div id="gridList"></div>
			</div>
			
		</div>
	
		
	</div>

</div>

<script>
var saveBtnTxt = '저장';
var idChkFlag = false;
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
            url: "<c:url value='/eval/evaluationIdListSearch' />",
            dataType: "json",
            type: "post"
        },
      	parameterMap: function(data, operation) {
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
	$('#saveBtn').text(saveBtnTxt);
	
	$('.date_yyyymmdd').kendoDatePicker({
     	culture : "ko-KR",
	    format : "yyyy-MM-dd",
	    value : new Date(),
	});
	
	$(".date_yyyymmdd").attr("readonly", true);
	
	$("#gridList").kendoGrid({
	    dataSource: gridDataSource,
	    height: 600,
	    sortable: false,
	    pageable: pageInfo,
	    selectable: "multiple, row",
	    change : clickRow,
	    columns: [
    	{
	    	field: "order_no",
	        title: "정렬순서",
    	},{
    		field: "eval_user_id",
	        title: "ID",
    	},{
    		field: "create_emp_name",
	        title: "생성자",
    	},{
    		field: "create_date",
	        title: "생성일",
    	},{
    		field: "active",
    		 template: actvieTemp,
	        title: "활성",
	    }],
	}).data("kendoGrid");
	
});

var actvieTemp = function(row){
	return row.active == 'Y' ? '활성' : '비활성';
}

function clickRow(e){
	
	var row = $('#gridList').data("kendoGrid").dataItem(this.select());
	
	$.each(row, function(i, v){
		
		if(i != 'eval_user_pw'){
			$('#dataForm #' + i).val(v);
		}
		
	});
	
	if(row.active == 'Y'){
		$('#dataForm  input[type="checkbox"]').prop('checked', true)
	}else{
		$('#dataForm  input[type="checkbox"]').prop('checked', false)
	}
	
	saveBtnTxt = '수정';
	$('#saveBtn').text(saveBtnTxt);
	$('#eval_user_id').attr('readonly', true);
	
}

function resetInput(){
	$('#dataForm #order_no').val('');
	$('#dataForm #eval_id_seq').val('');
	$('#dataForm #eval_user_id').val('');
	$('#dataForm #eval_user_pw').val('');
	$('#dataForm input[type=checkbox]').prop('checked', 'checked');
	saveBtnTxt = '저장';
	$('#saveBtn').text(saveBtnTxt);
	$('#eval_user_id').attr('readonly', false);
}

function newSaveBtn(){
	
	if(saveBtnTxt == '저장' && !idChkFlag){
		alert('ID 중복 확인을 해주세요.');
		return
	}
	
	if(confirm(saveBtnTxt + '하시겠습니까?')){
		
		$('#active').val($('#dataForm input[type=checkbox]').prop('checked') ? 'Y' : 'N');
		
		
		$.ajax({
			url: "<c:url value='/eval/evaluationIdViewSave' />",
			data : $('#dataForm').serialize(),
			type : 'POST',
			success: function(result){
				if(result.CODE == 'SUCCESS'){
					alert(saveBtnTxt + '하였습니다.');
					$("#gridList").data("kendoGrid").dataSource.page(1);
					resetInput();
				}else{
					alert(saveBtnTxt + '실패 했습니다.');
				}
			}
		});
		
		
	}
}



function userSearchPopup(code){
	window.open( _g_contextPath_ +'/common/userPopup?code='+code, '조직도', 'scrollbars=yes, resizeble=yes, menubar=no, toolbar=no, location=no, directories=yes, status=yes, width=875, height=700');
}

function userPopupClose(row, code){
	$('#major_dept').val(row.dept_name);
	$('#major_dept_seq').val(row.dept_seq);
	$('#major_emp_name').val(row.emp_name);
	$('#major_emp_seq').val(row.emp_seq);
}

function delDataBtn(){
	
	if(confirm('삭제 하시겠습니까?')){
		
		$.ajax({
			url: "<c:url value='/eval/evaluationIdViewDel' />",
			data : {eval_id_seq : $('#eval_id_seq').val()},
			type : 'POST',
			success: function(result){
				alert('삭제 하였습니다.');
				$("#gridList").data("kendoGrid").dataSource.page(1);
				resetInput();
			}
		});
		
	}
	
}

function chkIdBtn(){

	var temp = getChkId();

	if(temp == 'B'){
		alert('사용가능한 ID 입니다.');
	}else if(temp == 'C'){
		alert('중복 ID 입니다.');
	}
	
}

function getChkId(){

	var flag = 'A';
	idChkFlag = false;
	
	if($('#eval_user_id').val().length == 0){
		alert('ID를 입력해 주세요.');
	}else{
	
		$.ajax({
			url: "<c:url value='/eval/getEvalUserIdChk' />",
			data : {eval_user_id : $('#eval_user_id').val()},
			type : 'POST',
			async : false,
			success: function(result){
				if(result == ''){
					flag = 'B';
					idChkFlag = true;
				}else{
					flag = 'C';				
				}
			}
		});

	}
	
	return flag;
	
}

function idChkFlagBtn(){
	idChkFlag = false;
}

</script>