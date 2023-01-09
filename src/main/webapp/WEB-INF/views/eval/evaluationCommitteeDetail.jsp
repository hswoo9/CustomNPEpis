<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
#tabstrip th{text-align: center }
.inputData{width: 90%;}
</style>

<div class="iframe_wrap" style="min-width:1400px">

	<!-- 컨텐츠타이틀영역 -->
	<div class="sub_title_wrap">
		
		<div class="title_div">
			<h4>평가위원 수정</h4>
		</div>
	</div>
	
	<form id="evalDataForm">
	<input type="hidden" name="biz_type_code_id" id="biz_type_code_id" value="">
		<div class="sub_contents_wrap">
		<p class="tit_p mt5 mt20">평가위원 수정</p>

	
		<div class="com_ta">
			<div class="top_box gray_box">
				<dl>
					<dt style="">
					<img src="../Images/ico/ico_check01.png" alt="checkIcon">
						성명
					</dt>
					<dd style="line-height: 25px; padding-left: 13px;">
						<input type="text" name="eval_name" class="chkData" value="${pool.name}">
						<input type="hidden" name="commissioner_pool_seq" value="${pool.commissioner_pool_seq}">
					</dd>
	
					<dt style="margin-left:170px;">
					<img src="../Images/ico/ico_check01.png" alt="checkIcon">
						주민등록번호
					</dt>
					<dd style="line-height: 25px">
						<input type="text" class="chkData" id="birth_date" name="birth_date" value="${pool.birth_date}" style="width: 250px;"  maxlength="13">
					</dd>
	
					<dt style="margin-left:200px;">
						<img src="../Images/ico/ico_check01.png" alt="checkIcon">
						전문분야
						<input type="text" id="bizInput" readonly="readonly" style="width: 300px;">
					</dt>
					</dd>
				</dl>
				
				<dl>
					<dt style="">
					<img src="../Images/ico/ico_check01.png" alt="checkIcon">
						휴대폰
					</dt>
					<dd style="line-height: 25px">
						<c:set var="mobile" value="${fn:split(detail.mobile,'-')}" />
						<input type="text" name="mobile1" class="chkData" style="width: 60px;" value="${mobile[0]}">
						<input type="text" name="mobile2" class="chkData" style="width: 60px;" value="${mobile[1]}">
						<input type="text" name="mobile3" class="chkData" style="width: 60px;" value="${mobile[2]}">
					</dd>
	
					<dt style="margin-left:105px; margin-right: 23px;">
					<img src="../Images/ico/ico_check01.png" alt="checkIcon">
						이메일
					</dt>
					<dd style="line-height: 25px;  padding-left: 25px;">
						<input type="text" name="email" class="chkData" value="${detail.email}" style="width: 250px;">
					</dd>
				</dl>
	
				<dl>
					<dt style="">
						자택
					</dt>
					<dd style="line-height: 25px; padding-left: 15px;">
						<div class="com_ta" style="width: 500px;">
							<div class="top_box gray_box">
								<dl>
									<dt style="width: 60px;">
										우편번호
									</dt>
									<dd style="line-height: 25px">
										<input type="text" name="zip_code1" style="width: 60px;" value="${detail.zip_code1 }">
									</dd>
								</dl>
								<dl>
									<dt style="width: 60px;">
										주소
									</dt>
									<dd style="line-height: 25px">
										<input type="text" name="addr1" style="width: 180px;" value="${detail.addr1 }">
										<input type="text" name="addr2" style="width: 80px;" value="${detail.addr2 }">
									</dd>
								</dl>
								<dl>
									<dt style="width: 60px;">
										전화번호
									</dt>
									<dd style="line-height: 25px">
										<c:set var="tel" value="${fn:split(detail.tel,'-')}" />
										<input type="text" name="tel1" style="width: 40px;" value="${tel[0]}">
										<input type="text" name="tel2" style="width: 50px;" value="${tel[1]}">
										<input type="text" name="tel3" style="width: 50px;" value="${tel[2]}">
									</dd>
								</dl>
							
							</div>
						</div>
					</dd>
					
					<dt style="">
						소속
					</dt>
					<dd style="line-height: 25px">
						<div class="com_ta" style="width: 700px;">
							<div class="top_box gray_box">
								<dl>
									<dt style="width: 60px;">
										기관명
									</dt>
									<dd style="line-height: 25px">
										<input type="text" name="org_name" style="" value="${detail.org_name }">
									</dd>
									<dt style="width: 70px; margin-left:45px;">
										직위(직급)
									</dt>
									<dd style="line-height: 25px">
										<input type="text" name="org_grade" style="" value="${detail.org_grade }">
									</dd>
								</dl>
								<dl>
									<dt style="width: 60px;">
										우편번호
									</dt>
									<dd style="line-height: 25px">
										<input type="text" name="org_zip_code1" style="width: 60px;" value="${detail.org_zip_code1 }">
									</dd>
									<dt style="width: 70px; margin-left:111px;">
										주소
									</dt>
									<dd style="line-height: 25px">
										<input type="text" name="org_addr1" style="width: 180px;" value="${detail.org_addr1 }">
										<input type="text" name="org_addr2" style="width: 80px;" value="${detail.org_addr2 }">
									</dd>
								</dl>
								<dl>
									<dt style="width: 60px;">
										전화번호
									</dt>
									<dd style="line-height: 25px">
										<c:set var="org_tel" value="${fn:split(detail.org_tel,'-')}" />
										<input type="text" name="org_tel1" style="width: 40px;" value="${org_tel[0]}">
										<input type="text" name="org_tel2" style="width: 50px;" value="${org_tel[1]}">
										<input type="text" name="org_tel3" style="width: 50px;" value="${org_tel[2]}">
									</dd>
									<dt style="width: 70px;">
										팩스번호
									</dt>
									<dd style="line-height: 25px">
										<c:set var="org_fax" value="${fn:split(detail.org_fax,'-')}" />
										<input type="text" name="org_fax1" style="width: 40px;" value="${org_fax[0]}">
										<input type="text" name="org_fax2" style="width: 50px;" value="${org_fax[1]}">
										<input type="text" name="org_fax3" style="width: 50px;" value="${org_fax[2]}">
									</dd>
								</dl>
							
							</div>
						</div>
					</dd>
					
					
				</dl>
				
				<dl>
					<dt style="width: 80px;">
						저서 및 논문
					</dt>
					<dd style="line-height: 25px; width: 90%;">
						<input type="text" name="thesis" style="width: 90%;" value="${detail.thesis }">
					</dd>
				</dl>
				
				<dl>
					<dt style="width: 80px;">
						비고
					</dt>
					<dd style="line-height: 25px; width: 90%;">
						<input type="text" name="remark" style="width: 90%;" value="${pool.remark }">
					</dd>
				</dl>				
				
			</div>
	
		</div><!-- //sub_contents_wrap -->
		
	</div>
	
	
	<div class="sub_contents_wrap">
	
		<div class="com_ta">
	
			<div id ="tabstrip">
					<ul>
						<li>학력사항</li>
						<li>경력사항</li>
						<li>자격증</li>
					</ul>
	<!-- 				tab1 -->
					<div>
						<div class="com_ta3">
							<table id = "evalTab1" style="width:100%;">
								<thead>
									<tr>
										<th style="width: 15%;">취득년월</th>
										<th style="width: 25%;">학교</th>
										<th style="width: 25%;">학위</th>
										<th style="width: 15%;">전공</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${degree}" var="list" varStatus="st">
										<tr>
											<td>
												<input type="hidden" name="degreeList[${st.index}].degree_seq" value="${list.degree_seq }">
												<input type="text" class="date_yyyymm" name="degreeList[${st.index}].de_get_yyyymm" value="${fn:substring(list.get_yyyymm,0,4)}-${fn:substring(list.get_yyyymm,4,6)}">
											</td>
											<td><input type="text" class="inputData" name="degreeList[${st.index}].de_school" value="${list.school }"></td>
											<td><input type="text" class="inputData" name="degreeList[${st.index}].de_degree" value="${list.degree }"></td>
											<td><input type="text" class="inputData" name="degreeList[${st.index}].de_major" value="${list.major }"></td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
					</div>
	<!-- 				tab2 -->
					<div>
						<div class="com_ta3">
							<table id = "evalTab2" style="width:100%;">
								<thead>
									<tr>
										<th style="width: 15%;">근무시작일</th>
										<th style="width: 15%;">근무종료일</th>
										<th style="width: 25%;">근무처</th>
										<th style="width: 15%;">직위</th>
										<th style="width: 25%;">주요업무</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${career}" var="list" varStatus="st">
										<tr>
											<td>
												<input type="hidden" name="careerList[0].career_seq" value="${list.career_seq}"> 
												<input type="text" class="date_yyyymmdd" name="careerList[${st.index}].ca_work_sdate" value="${fn:substring(list.work_sdate,0,4)}-${fn:substring(list.work_sdate,4,6)}-${fn:substring(list.work_sdate,6,8)}">
											</td>
											<td><input type="text" class="date_yyyymmdd" name="careerList[${st.index}].ca_work_edate" value="${fn:substring(list.work_edate,0,4)}-${fn:substring(list.work_edate,4,6)}-${fn:substring(list.work_edate,6,8)}"></td>
											<td><input type="text" class="inputData" name="careerList[${st.index}].ca_work_company" value="${list.work_company}"></td>
											<td><input type="text" class="inputData" name="careerList[${st.index}].ca_position" value="${list.position}"></td>
											<td><input type="text" class="inputData" name="careerList[${st.index}].ca_major_job" value="${list.major_job}"></td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
					</div>
	<!-- 				tab3 -->
					<div>
						<div class="com_ta3">
							<table id = "evalTab3" style="width:100%;">
								<thead>
									<tr>
										<th style="width: 15%;">취득년월</th>
										<th style="width: 25%;">자격증</th>
										<th style="width: 25%;">인가/관리기관</th>
										<th style="width: 15%;">비고</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${license}" var="list" varStatus="st">
										<tr>
											<td>
												<input type="hidden" name="licenseList[${st.index}].license_seq" value="${list.license_seq }">
												<input type="text" class="date_yyyymm" name="licenseList[${st.index}].li_get_yyyymm" value="${fn:substring(list.get_yyyymm,0,4)}-${fn:substring(list.get_yyyymm,4,6)}">
											</td>
											<td><input type="text" class="inputData" name="licenseList[${st.index}].li_license_title" value="${list.license_title }"></td>
											<td><input type="text" class="inputData" name="licenseList[${st.index}].li_organ" value="${list.organ }"></td>
											<td><input type="text" class="inputData" name="licenseList[${st.index}].li_remark" value="${list.remark }"></td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
					</div>
					
				</div>
		
			</div>
	
		</div>
	</form>
	
</div><!-- iframe wrap -->

<div class="pop_wrap" id="biz_type_popup" style="min-width:400px; display:none;">
	<div class="pop_con">	
		<!-- 컨트롤박스 -->
		<div class="com_ta2">
			<table>
				<thead>
					<tr>
						<th style="width: 80px;"></th>
						<th>순서전문분야(평가대상사업)</th>
					</tr>
				</thead>
				<tbody id="bizTypeBody">
					<c:forEach items="${btcList }" var="list">
					<c:set var="ii" value="0" />
						<tr>
							<td>
								<c:forEach items="${bizTypeList}" var="bizList">
									<c:if test="${list.code eq bizList.biz_type_code_id }">
										<c:set var="ii" value="${ii+1}" />
									</c:if>
								</c:forEach>
								
								<input type="checkbox" id="biz_cd" class="biz_type_list" ${ii > 0 ? "checked='checked'" : "" } value="${list.code }">
							</td>
							<td>
								<input type="hidden" id="biz_nm" readonly="readonly" value="${list.code_kr }" />${list.code_kr }
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		
	</div><!-- //pop_con -->
</div><!-- //pop_wrap -->

<div id="tab1Temp" style="display: none;">
	<table>
		<tbody>
			<tr>
				<td><input type="text" class="datePickerTemp" name="degreeList[99].de_get_yyyymm"></td>
				<td><input type="text" class="inputData" name="degreeList[99].de_school"></td>
				<td><input type="text" class="inputData" name="degreeList[99].de_degree"></td>
				<td><input type="text" class="inputData" name="degreeList[99].de_major"></td>
			</tr>
		</tbody>
	</table> 
</div>

<div id="tab2Temp" style="display: none;">
	<table>
		<tbody>
			<tr>
				<td><input type="text" class="datePickerTemp" name="careerList[99].ca_work_sdate"></td>
				<td><input type="text" class="datePickerTemp" name="careerList[99].ca_work_edate"></td>
				<td><input type="text" class="inputData" name="careerList[99].ca_work_company"></td>
				<td><input type="text" class="inputData" name="careerList[99].ca_position"></td>
				<td><input type="text" class="inputData" name="careerList[99].ca_major_job"></td>
			</tr>
		</tbody>
	</table>
</div>


<div id="tab3Temp" style="display: none;">
	<table>
		<tbody>
			<tr>
				<td><input type="text" class="datePickerTemp" name="licenseList[99].li_get_yyyymm"></td>
				<td><input type="text" class="inputData" name="licenseList[99].li_license_title"></td>
				<td><input type="text" class="inputData" name="licenseList[99].li_organ"></td>
				<td><input type="text" class="inputData" name="licenseList[99].li_remark"></td>
			</tr>
		</tbody>
	
	</table>
</div>


<script>
var tabKendo;
var bizTypeArray = new Array();
$(function(){
	
	$("#birth_date").keyup(function(){ 
    	$(this).val($(this).val().replace(/[^0-9]/g,""));
    });
	
	tabKendo = $("#tabstrip").kendoTabStrip({
        animation:  {
            open: {
                effects: "fadeIn"
            }
        },
        select : function(e){
        	
        	var id = e.contentElement.id;

        }
    }).data("kendoTabStrip").select(0);
	
	
	addBizTypeBtn();
	
	$('input').attr('readonly', true);
	
});


function tabRowAdd(){

	if(tabKendo.select().index() == 0){
		
		$('#evalTab1 tbody').append($('#tab1Temp table tbody').clone().html());
		
		datePickerTemp('evalTab1', 'yyyymm');
		
		indexSet('evalTab1');
		
	}else if(tabKendo.select().index() == 1){
		
		$('#evalTab2 tbody').append($('#tab2Temp table tbody').clone().html());
		
		datePickerTemp('evalTab2', 'yyyymmdd');
		
		indexSet('evalTab2');
		
	}else if(tabKendo.select().index() == 2){
		
		$('#evalTab3 tbody').append($('#tab3Temp table tbody').clone().html());
		
		datePickerTemp('evalTab3', 'yyyymm');
		
		indexSet('evalTab3');
		
	}
	
}

function datePickerTemp(id, ymd){
	
	if(ymd == 'yyyymm'){
		
		$('#'+id+ ' .datePickerTemp').kendoDatePicker({
	     	culture : "ko-KR",
		    format : "yyyy-MM",
		    depth: "year",
		    start: "year"
		});
		
	}else{
		
		$('#'+id+ ' .datePickerTemp').kendoDatePicker({
	     	culture : "ko-KR",
		    format : "yyyy-MM-dd",
		});
		
	}
	
	$('#'+id+ ' .datePickerTemp').attr("readonly", true);
	
	$('#'+id+ ' .datePickerTemp').removeClass('datePickerTemp');
	
}

function indexSet(id){
	
	$.each($('#'+id+' tbody tr'), function(i, v){
		
		$.each($(v).find('input'), function(ii, vv){
			var vvName = $(vv).attr('name');			
			var sName = vvName.substr(0,$(vv).attr('name').indexOf('[')+1);
			var eName = vvName.substr($(vv).attr('name').lastIndexOf(']') ,vvName.length);
			$(vv).attr('name', sName + i + eName);
			
		});

	});
	
}

function vcApply(){
	
	var chkInput = $('.chkData');
	
	//상단 input 체크
	for (var i = 0; i < $('.chkData').length; i++) {
		
		if($(chkInput[i]).val().length == 0){
			alert('필수 입력값이 누락되었습니다.');
			$(chkInput[i]).focus();
			return
		};
		
	}
	
	//생년월일 체크
	if($('#birth_date').val().length == 0){
		$('#birth_date').next().click();
		return
	}
	
	if(bizTypeArray.length == 0){
		alert('전문분야를 입력해 주세요.');
		bizTypePopupBtn();
		return
	}
	
	if(confirm('수정하시겠습니까?')){
		
		$('#biz_type_code_id').val(bizTypeArray.join());
		
		$.ajax({
				url: "<c:url value='/eval/evaluationCommitteeViweUpdate' />",
				data : $('#evalDataForm').serialize(),
				type : 'POST',
				success: function(result){
					alert('수정하였습니다.');
					location.href = "<c:url value='/eval/evaluationCommitteeList'/>";
				}
		});
	
	}
	
}

function addBizTypeBtn(){
	
	bizTypeArray = new Array();
	
	$('#bizInput').val('');
	
	var cnt = 0;
	var txt = '';
	
	$.each($('#bizTypeBody .biz_type_list'), function(i, v){

		if($(v).prop('checked')){
			var nm = $(v).closest('tr').find('#biz_nm').val();
			var cd = $(v).closest('tr').find('#biz_cd').val();
			
			bizTypeArray.push(cd);
			
			if(cnt == 0){
				txt += nm;
			}else{
				txt += ', ' + nm;
			}
			
			cnt++;
		}

	});
	
	$('#bizInput').val(txt);
	
	$('#biz_type_popup').data("kendoWindow").close();
	
} 

function bizTypePopupBtn(){
	$('#biz_type_popup').data("kendoWindow").center().open();
}




</script>

