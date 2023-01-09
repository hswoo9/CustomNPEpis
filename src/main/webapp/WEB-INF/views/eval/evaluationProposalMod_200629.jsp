<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>

<style>
.sub_contents_wrap{min-height:0px;}

</style>


<div class="iframe_wrap" style="min-width:1100px">

	<div class="sub_title_wrap">
		<div class="title_div">
			<h4>제안평가 상세</h4>
		</div>
	</div>

	<form id="evalDataForm">
	<input type="hidden" name="committee_seq" value="${commDetail.committee_seq }">
	<div class="sub_contents_wrap">
		<p class="tit_p mt5 mb10">사업개요</p>
		
		<div class="com_ta">
			<div class="top_box gray_box" id="newDate">
				<dl>
					<dt style="">
						요구부서
					</dt>
					<dd style="line-height: 25px">
						<input type="text" name="req_dept_name" id="req_dept_name" readonly="readonly" value="${commDetail.req_dept_name}">			
						<input type="hidden" name="req_dept_seq" id="req_dept_seq" value="${commDetail.req_dept_seq}">	
						<img alt="" src="../Images/btn/search_icon2.png" style="cursor: pointer;" onclick="deptSearchPopup();">		
					</dd>
	
					<dt style="margin-left:100px;">
						사업담당자
					</dt>
					<dd style="line-height: 25px">
						<input type="text" name="major_dept" id="major_dept" readonly="readonly" value="${commDetail.major_dept}">
						<input type="hidden" name="major_dept_seq" id="major_dept_seq" style="width: 70px;" value="${commDetail.major_dept_seq}">
						<input type="text" name="major_emp_name" id="major_emp_name" style="width: 70px;" readonly="readonly" value="${commDetail.major_emp_name}">
						<input type="hidden" name="major_emp_seq" id="major_emp_seq" style="width: 70px;" value="${commDetail.major_emp_seq}">
						<img alt="" src="../Images/btn/search_icon2.png" style="cursor: pointer;" onclick="userSearchPopup(1);">
					</dd>

					<dt style="margin-left:80px;">
						작성자
					</dt>
					<dd style="line-height: 25px">
						<input type="text" readonly="readonly" value="${commDetail.create_dept_name}">
						<input type="text" style="width: 70px;" readonly="readonly" value="${commDetail.create_emp_name}">
						<input type="text" style="width: 70px;" readonly="readonly" value="${commDetail.create_duty_name}">
					</dd>
					
					<dt style="margin-left:50px;">
						작성일자
					</dt>
					<dd style="line-height: 25px">
						<input type="text" readonly="readonly" value="${commDetail.create_date2}">
					</dd>
				</dl>
				
				<dl>
					<dt style="">
						사업구분
					</dt>
					<dd style="line-height: 25px">
						<input type="hidden" name="biz_type_array" id="biz_type_array">
						<input type="hidden" name="biz_type_code_id" id="biz_type_code_id">
						<select id="biz_type_array_select" class="select_biz_type" style="width: 200px;">
							<c:forEach items="${btcList }" var="list">
								<option value="${list.code }" ${list.code eq commDetail.biz_type_code_id ? "selected='selected'" : ""}  >${list.code_kr }</option>
							</c:forEach>
						</select>					
					</dd>
	
					<dt style="margin-left:75px;">
						사업명
					</dt>
					<dd style="line-height: 25px">
						<input type="text" name="title" style="width: 250px;" value="${commDetail.title}">
					</dd>

					<dt style="margin-left:38px;">
						사업예산
					</dt>
					<dd style="line-height: 25px">
						<input type="text" name="budget" value="${commDetail.budget}">
					</dd>
				</dl>
			</div>
		</div>

	</div>


	<div class="sub_contents_wrap">
		<p class="tit_p mt5 mb10">평가개요</p>
	
		<div class="com_ta">
			<div class="top_box gray_box" id="newDate">
				<dl>
					<dt style="">
						평가일시
					</dt>
					<dd style="line-height: 25px">
						<input type="text" name="eval_date" class="date_yyyymmdd" style="width: 120px;" value="${commDetail.eval_date2 }">
						<input type="text" name="eval_s_time" class="eval_time" style="width: 80px;" value="${commDetail.eval_s_time }">
						~<input type="text" name="eval_e_time" class="eval_time" style="width: 80px;" value="${commDetail.eval_e_time }">
					</dd>
	
					<dt style="margin-left:50px;">
						평가장소
					</dt>
					<dd style="line-height: 25px">
						<input type="text" name="eval_place" style="width: 200px;" value="${commDetail.eval_place }">
					</dd>

					<dt style="margin-left:50px;">
						운영요원
					</dt>
					<dd style="line-height: 25px">
						<input type="text" name="opr_dept" id="opr_dept" readonly="readonly" value="${commDetail.opr_dept}">
						<input type="hidden" name="opr_dept_seq" id="opr_dept_seq" value="${commDetail.opr_dept_seq}">
						<input type="text" name="opr_emp_name" id="opr_emp_name" style="width: 70px;" readonly="readonly" value="${commDetail.opr_emp_name}">
						<input type="hidden" name="opr_emp_seq" id="opr_emp_seq" value="${commDetail.opr_emp_seq}">
						<img alt="" src="../Images/btn/search_icon2.png" style="cursor: pointer;" onclick="userSearchPopup(2);">
					</dd>

					<dt style="margin-left:50px;">
						참여기관(업체) 수
					</dt>
					<dd style="line-height: 25px">
						<input type="text" name="join_org_cnt" style="width: 50px;" value="${commDetail.join_org_cnt}">
					</dd>
				</dl>
				
				<dl>
					<dt style="width: 70px;">
						평가분야
					</dt>
					<input type="hidden" name="evalItemList" id="evalItemList">
					<div id="evalItemDD" >
					</div>
				</dl>
				
			</div>
		</div>
	</div>

	</form>
	
<!-- 	<div class="sub_contents_wrap"> -->
<!-- 		<div class="com_ta"> -->
<!-- 			<div class="top_box gray_box"> -->
<!-- 				<dl> -->
<!-- 					<dd style="width: 45%;"></dd> -->
<!-- 					<dd> -->
<!-- 						<input type="button" style="margin-bottom: 15px;" id="applyBtn" onclick="vcApply();" value="수정하기"> -->
<!-- 					</dd> -->
<!-- 				</dl> -->
<!-- 			</div> -->
<!-- 		</div> -->
<!-- 	</div> -->
</div>

<script>
var itemList = JSON.parse('${commItem}');
$(function(){
	
	$('#biz_type_array_select').kendoDropDownList();
	
	$('.date_yyyymmdd').kendoDatePicker({
     	culture : "ko-KR",
	    format : "yyyy-MM-dd",
	});
	
	$('.eval_time').kendoTimePicker({
		format: "HH:mm",
		interval : 60,
		min:'06:00',
		max:'23:00',
	});
	
	$(".date_yyyymmdd").attr("readonly", true);
	$(".eval_time").attr("readonly", true);
	
	getEvalItem();
});


function deptSearchPopup(){
	window.open( _g_contextPath_ +'/common/deptPopup', '조직도', 'scrollbars=yes, resizeble=yes, menubar=no, toolbar=no, location=no, directories=yes, status=yes, width=355, height=700');
}

function deptPopupClose(deptSeq, deptName){
	$('#req_dept_name').val(deptName);
	$('#req_dept_seq').val(deptSeq);
}

function userSearchPopup(code){
	window.open( _g_contextPath_ +'/common/userPopup?code='+code, '조직도', 'scrollbars=yes, resizeble=yes, menubar=no, toolbar=no, location=no, directories=yes, status=yes, width=875, height=700');
}

function userPopupClose(row, code){
	if(code == 1){
		$('#major_dept').val(row.dept_name);
		$('#major_dept_seq').val(row.dept_seq);
		$('#major_emp_name').val(row.emp_name);
		$('#major_emp_seq').val(row.emp_seq);
	
	}else if(code = 2){
		$('#opr_dept').val(row.dept_name);
		$('#opr_dept_seq').val(row.dept_seq);
		$('#opr_emp_name').val(row.emp_name);
		$('#opr_emp_seq').val(row.emp_seq);
	}
	
}

function vcApply(){

	if(confirm('수정 하시겠습니까?')){
		
		$('#biz_type_array').val($('#biz_type_array_select option:selected').text());
		$('#biz_type_code_id').val($('#biz_type_array_select').val());
		
		var itemArray = new Array()
		
		$.each($('#evalItemDD input[type=checkbox]'), function(i, v){
			if($(v).prop('checked')){
				itemArray.push($(v).val());
			}
		});
		
		$('#evalItemList').val(itemArray.join());
		
		$.ajax({
				url: "<c:url value='/eval/evaluationProposalViewSave' />",
				data : $('#evalDataForm').serialize(),
				type : 'POST',
				success: function(result){
					alert('수정 하였습니다.');
					location.href = "<c:url value='/eval/evaluationProposalList'/>";
					
				}
		});
		
	}
	
}


function getEvalItem(e){
	
	$('#evalItemDD').empty();
	$.ajax({
		url: "<c:url value='/eval/getEvalItemList' />",
		type : 'POST',
		success: function(result){

			$.each(result, function(i, v){
				var tem = false;
				
				$.each(itemList, function(ii, vv){
					if(v.eval_item_seq == vv.eval_item_seq){
						tem = true;
					}
				});
				
				var html = '<dd style="line-height: 25px; padding-left: 15px;">';
				if(tem){
					html += '<input style="visibility: hidden;" type="checkbox" checked="checked" id="evalItem_'+v.eval_item_seq+'" value="'+v.eval_item_seq+'"><label for="evalItem_'+v.eval_item_seq+'">'+v.item_name+'</label>';
				}else{
					html += '<input style="visibility: hidden;" type="checkbox" id="evalItem_'+v.eval_item_seq+'" value="'+v.eval_item_seq+'"><label for="evalItem_'+v.eval_item_seq+'">'+v.item_name+'</label>';
				}
					html += '</dd>';
				
				$('#evalItemDD').append(html);
					
			});
			
		}
});
}



</script>


