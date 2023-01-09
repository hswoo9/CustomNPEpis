<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>

<style>
#tabstrip th{text-align: center }
.inputData{width: 90%;}

</style>

<div class="iframe_wrap" style="min-width:1400px">

	<!-- 컨텐츠타이틀영역 -->
	<div class="sub_title_wrap">
		
		<div class="title_div">
			<h4>평가위원 등록</h4>
		</div>
	</div>
	
	<form id="evalDataForm">
	<input type="hidden" name="biz_type_code_id" id="biz_type_code_id">
		<div class="sub_contents_wrap">
		<p class="tit_p mt5 mt20">평가위원 등록</p>

	
		<div class="com_ta">
			<div class="top_box gray_box">
				<dl>
					<dt style="">
					<img src="../Images/ico/ico_check01.png" alt="checkIcon">
						성명
					</dt>
					<dd style="line-height: 25px; padding-left: 13px;">
						<input type="text" name="eval_name" class="chkData">
					</dd>
			
					<dt style="margin-left:170px;">
					<img src="../Images/ico/ico_check01.png" alt="checkIcon">
						주민등록번호
					</dt>
					<dd style="line-height: 25px;">
						<input type="text" name="birth_date" class="chkData" id ="birth_date" style="width: 250px;"  maxlength="13">
					</dd>
	
					<dt style="margin-left: 200px;">
					<img src="../Images/ico/ico_check01.png" alt="checkIcon">
						성별
					</dt>
					<dd style="line-height: 25px; margin-left: 44px;">
						<input type="radio" name="gender" class="chkData" id="genderM" value="남" /><label for="genderM" style="margin-right: 7px;">남</label>
						<input type="radio" name="gender" class="chkData" id="genderF" value="여" /><label for="genderF">여</label>
					</dd>				
				</dl>
				
				<dl>
					<dt style="">
					<img src="../Images/ico/ico_check01.png" alt="checkIcon">
						휴대폰
					</dt>
					<dd style="line-height: 25px">
						<input type="text" name="mobile1" style="width: 60px;" class="chkData" maxlength="3">
						<input type="text" name="mobile2" style="width: 60px;" class="chkData" maxlength="4">
						<input type="text" name="mobile3" style="width: 60px;" class="chkData" maxlength="4">
					</dd>
	
					<dt style="margin-left:105px; margin-right: 23px;">
					<img src="../Images/ico/ico_check01.png" alt="checkIcon">
						이메일
					</dt>
					<dd style="line-height: 25px; padding-left: 25px;">
						<input type="text" name="email" style="width: 250px;" class="chkData">
					</dd>
					
					<dt style="margin-left:200px;">
						<img src="../Images/ico/ico_check01.png" alt="checkIcon">
							분야
						<img alt="" src="../Images/btn/search_icon2.png" style="cursor: pointer; margin-left: 26px;" onclick="jobTypePopupBtn();">
						<input type="text" id="job_type" name="job_type" class="chkData" readonly="readonly" style="width: 300px;">
					</dt>
				</dl>
				
				<dl>
					<dt style="">
						은행 선택
					</dt>
					<dd style="line-height: 25px">
						<select id="bankCode" style="width: 150px;">
							<option value="">선택</option>
							<c:forEach var="list" items="${bankList }">
								<option value="${list.BANK_CD }">${list.BANK_NM }</option>
							</c:forEach>
						</select>
					</dd>
	
					<dt style="margin-left:145px; margin-right: 23px;">
						계좌번호
					</dt>
					<dd style="line-height: 25px; padding-left: 25px;">
						<input type="hidden" name="bank_name" id="bank_name">
						<input type="hidden" name="bank_cd" id="bank_cd">
						<input type="text" name="bank_no" style="width: 250px;">
					</dd>
					
					<dt style="margin-left:200px;">
						<img src="../Images/ico/ico_check01.png" alt="checkIcon">
							전문분야
						<img alt="" src="../Images/btn/search_icon2.png" style="cursor: pointer;" onclick="bizTypePopupBtn();">
						<input type="text" id="bizInput" readonly="readonly" style="width: 300px;">
					</dt>
				</dl>
	
				<dl>
					<dt style="">
						소속
					</dt>
					<dd style="line-height: 25px">
						<div class="com_ta" style="width: 750px;">
							<div class="top_box gray_box">
								<dl>
									<dt style="width: 60px;">
										기관명
									</dt>
									<dd style="line-height: 25px">
										<input type="text" name="org_name" style="">
									</dd>
									<dt style="width: 70px; margin-left:45px;">
										직위(직급)
									</dt>
									<dd style="line-height: 25px">
										<input type="text" name="org_grade" style="">
									</dd>
									<dt style="width: 40px; margin-left:45px;">
										부서
									</dt>
									<dd style="line-height: 25px">
										<input type="text" name="org_dept" style="">
									</dd>
								</dl>
								<dl>
									<dt style="width: 60px;">
										우편번호
									</dt>
									<dd style="line-height: 25px">
										<input type="text" name="org_zip_code1" style="width: 60px;">
									</dd>
									<dt style="width: 70px; margin-left:111px;">
										주소
									</dt>
									<dd style="line-height: 25px">
										<input type="text" name="org_addr1" style="width: 180px;">
										<input type="text" name="org_addr2" style="width: 80px;">
									</dd>
								</dl>
								<dl>
									<dt style="width: 60px;">
										전화번호
									</dt>
									<dd style="line-height: 25px">
										<input type="text" name="org_tel1" style="width: 40px;">
										<input type="text" name="org_tel2" style="width: 50px;">
										<input type="text" name="org_tel3" style="width: 50px;">
									</dd>
									<dt style="width: 70px;">
										팩스번호
									</dt>
									<dd style="line-height: 25px">
										<input type="text" name="org_fax1" style="width: 40px;">
										<input type="text" name="org_fax2" style="width: 50px;">
										<input type="text" name="org_fax3" style="width: 50px;">
									</dd>
								</dl>
							
							</div>
						</div>
					</dd>
					
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
										<input type="text" name="zip_code1" style="width: 60px;">
									</dd>
								</dl>
								<dl>
									<dt style="width: 60px;">
										주소
									</dt>
									<dd style="line-height: 25px">
										<input type="text" name="addr1" style="width: 180px;">
										<input type="text" name="addr2" style="width: 80px;">
									</dd>
								</dl>
								<dl>
									<dt style="width: 60px;">
										전화번호
									</dt>
									<dd style="line-height: 25px">
										<input type="text" name="tel1" style="width: 40px;">
										<input type="text" name="tel2" style="width: 50px;">
										<input type="text" name="tel3" style="width: 50px;">
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
						<input type="text" name="thesis" style="width: 90%;">
					</dd>
				</dl>
				
				<dl>
					<dt style="width: 80px;">
						비고
					</dt>
					<dd style="line-height: 25px; width: 90%;">
						<input type="text" name="remark" style="width: 90%;">
					</dd>
				</dl>				
				
				<dl class="next2">
					<dd style="width: 45%;"></dd>
					<dd>
						<input type="button" style="margin-bottom: 15px;" id="applyBtn" onclick="vcApply();" value="등록하기">
					</dd>
				</dl>
				
			</div>
	
		</div><!-- //sub_contents_wrap -->
		
	</div>
	
	
	<div class="sub_contents_wrap">
	
		<div class="com_ta">
	
			<div id ="tabstrip">
					<ul>
						<li id="sssss">학력사항</li>
						<li>경력사항</li>
						<li>자격증</li>
						<div class="controll_btn p0" style="float:right;">
							<div class="btnTab1">
								<button type="button" onclick = "tabRowAdd()">추가</button>
							</div>
						</div>
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
									<tr>
										<td><input type="text" class="date_yyyymm" name="degreeList[0].de_get_yyyymm"></td>
										<td><input type="text" class="inputData" name="degreeList[0].de_school"></td>
										<td><input type="text" class="inputData" name="degreeList[0].de_degree"></td>
										<td><input type="text" class="inputData" name="degreeList[0].de_major"></td>
									</tr>
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
									<tr>
										<td><input type="text" class="date_yyyymmdd" name="careerList[0].ca_work_sdate"></td>
										<td><input type="text" class="date_yyyymmdd" name="careerList[0].ca_work_edate"></td>
										<td><input type="text" class="inputData" name="careerList[0].ca_work_company"></td>
										<td><input type="text" class="inputData" name="careerList[0].ca_position"></td>
										<td><input type="text" class="inputData" name="careerList[0].ca_major_job"></td>
									</tr>
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
									<tr>
										<td><input type="text" class="date_yyyymm" name="licenseList[0].li_get_yyyymm"></td>
										<td><input type="text" class="inputData" name="licenseList[0].li_license_title"></td>
										<td><input type="text" class="inputData" name="licenseList[0].li_organ"></td>
										<td><input type="text" class="inputData" name="licenseList[0].li_remark"></td>
									</tr>
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
						<th>전문분야(평가대상사업)</th>
					</tr>
				</thead>
				<tbody id="bizTypeBody">
					<c:forEach items="${btcList }" var="list">
						<tr>
							<td>
								<input type="checkbox" id="biz_cd" class="biz_type_list" value="${list.code }">
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

<div class="pop_wrap" id="job_type_popup" style="min-width:400px; display:none;">
	<div class="pop_con">	
		<!-- 컨트롤박스 -->
		<div class="com_ta2">
			<table>
				<thead>
					<tr>
						<th style="width: 80px;"></th>
						<th>분야</th>
					</tr>
				</thead>
				<tbody id="jobTypeBody">
					<c:forEach items="${jobList }" var="list">
						<tr>
							<td>
								<input type="radio" name="job" id="job_cd" class="job_type_list" value="${list.code }">
							</td>
							<td>
								<input type="hidden" id="job_nm" readonly="readonly" value="${list.code_kr }" />${list.code_kr }
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

<div class="pop_wrap_dir" id="loadingPop" style="width: 443px;">
	<div class="pop_con">
		<table class="fwb ac" style="width:100%;">
			<tr>
				<td>
					<span class=""><img src="<c:url value='../Images/ico/loading.gif'/>" alt="" />  &nbsp;&nbsp;&nbsp;등록 중입니다.</span>		
				</td>
			</tr>
		</table>
	</div>
	<!-- //pop_con -->
</div>


<script>
var tabKendo;
var bizTypeArray = new Array();
$(function(){
	
	$('#loadingPop').kendoWindow({
	     width: "443px",
	     visible: false,
	     modal: true,
	     actions: [],
	     close: false,
	     title: false,
	 }).data("kendoWindow").center();
	
	tabKendo = $("#tabstrip").kendoTabStrip({
        animation:  {
            open: {
                effects: "fadeIn"
            }
        },
        select : function(e){
        	
//         	var id = e.contentElement.id;

        }
    }).data("kendoTabStrip").select(0);
	
	$('.date_yyyymm').kendoDatePicker({
     	culture : "ko-KR",
	    format : "yyyy-MM",
	    depth: "year",
	    start: "year"
	});

	$('.date_yyyymmdd').kendoDatePicker({
     	culture : "ko-KR",
	    format : "yyyy-MM-dd",
	});
	
	$(".date_yyyymm").attr("readonly", true);
	$(".date_yyyymmdd").attr("readonly", true);
	
	$('#biz_type_array_select').kendoDropDownList();
	$('#bankCode').kendoDropDownList();
	
	$('#biz_type_popup').kendoWindow({
	    width: "400px;",
	    height: "600px;",
	    title: '전문분야 <input type="button" style="margin-left: 200px;" onclick="addBizTypeBtn();" value="추가">',
	    visible: false,
	    modal : true,
	    actions: [
	        "Close"
	    ],
	}).data("kendoWindow");
	
	$('#job_type_popup').kendoWindow({
	    width: "400px;",
	    height: "600px;",
	    title: '분야 <input type="button" style="margin-left: 200px;" onclick="addJobTypeBtn();" value="추가">',
	    visible: false,
	    modal : true,
	    actions: [
	        "Close"
	    ],
	}).data("kendoWindow");
	
    $("#birth_date").keyup(function(){ 
    	$(this).val($(this).val().replace(/[^0-9]/g,""));
    });
	
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
		
		if($(chkInput[i]).val().length == 0 || !$('input[name=gender]:checked').val()){
			alert('필수 입력값이 누락되었습니다.');
			$(chkInput[i]).focus();
			return
		};
		
	}
	
	//생년월일 체크
// 	if($('#birth_date').val().length == 0){
// 		alert('생년월일을 입력해 주세요.');
// 		$('#birth_date').data("kendoDatePicker").open();
// 		return
// 	}
	
	if(bizTypeArray.length == 0){
		alert('전문분야를 입력해 주세요.');
		bizTypePopupBtn();
		return
	}
	
	if($('#bankCode').val() != ''){
		$('#evalDataForm #bank_name').val($('#bankCode option:selected').text());
		$('#evalDataForm #bank_cd').val($('#bankCode').val());
	}
	
	$('#biz_type_code_id').val(bizTypeArray.join());

	$.ajax({
			url: "<c:url value='/eval/evaluationCommitteeViweSave' />",
			data : $('#evalDataForm').serialize(),
			type : 'POST',
			success: function(result){
				alert('등록하였습니다.');
				location.href = "<c:url value='/eval/evaluationCommitteeList'/>";
				
			},
			beforeSend: function () {
		    	$('#loadingPop').data("kendoWindow").open();
		    },
		    complete: function () {
		    	$('#loadingPop').data("kendoWindow").close();
		    },
	});
	
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

function addJobTypeBtn(){
			
	$('#job_type').val('');
	
	$.each($('#jobTypeBody .job_type_list'), function(i, v){

		if($(v).prop('checked')){
			var nm = $(v).closest('tr').find('#job_nm').val();
			var cd = $(v).closest('tr').find('#job_cd').val();

			$('#job_type').val(nm);
			
			$('#job_type_popup').data("kendoWindow").close();
			
		}

	});
		
} 

function bizTypePopupBtn(){
	$('#biz_type_popup').data("kendoWindow").center().open();
}

function jobTypePopupBtn(){
	$('#job_type_popup').data("kendoWindow").center().open();
}




</script>

