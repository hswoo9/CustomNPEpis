<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>

<style>
.sub_contents_wrap{min-height:0px;}
.com_ta table th{text-align: center; padding-right: 0px;}
#commTable td{text-align: center;}
#evalItemDD td{text-align: center; padding-right: 0px; padding-left: 0px;}
#joinOrgDD td{text-align: center; padding-right: 0px; padding-left: 0px;}
.com_ta table td {border: 1px solid #eaeaea;}
</style>


<div class="iframe_wrap" style="min-width:1100px;">

	<div class="sub_title_wrap">
		<div class="title_div">
			<h4>제안평가 상세</h4>
		</div>
	</div>
	
	<input type="hidden" name="committee_seq" value="${commDetail.committee_seq }">
	<div class="sub_contents_wrap">
	
		<div class="btn_div mt20">
			<div class="left_div">
				<p class="tit_p fl mt5 mb0">
					사업개요
				</p>
			</div>
			<c:if test="${commDetail.evalViewyn eq 'Y'}">
				<div class="right_div">
					<input type="button" value="평가보기" onclick="evalResultBtn();">
				</div>
			</c:if>
		</div>
		
		<div class="com_ta">
			<div class="top_box gray_box" id="newDate">
			
				<table style="width: 100%">
					<colgroup>
						<col width="80px;">
						<col width="350px;">
						<col width="80px;">
						<col width="350px;">
						<col width="80px;">
						<col width="350px;">
						<col width="80px;">
						<col width="">
					</colgroup>
					<tr>
						<th>요구부서</th>
						<td>	
							<label>${commDetail.req_dept_name}</label>
						</td>
						<th>감사실담당</th>
						<td>	
							<label>${commDetail.major_dept} / ${commDetail.major_emp_name}</label>
						</td>
						<th>작성자</th>
						<td>	
							<label>${commDetail.create_dept_name} / ${commDetail.create_emp_name} / ${commDetail.create_duty_name}</label>
						</td>
						<th>작성일자</th>
						<td>	
							<label>${commDetail.create_date2}</label>
						</td>
					</tr>
				
					<tr>
						<th>사업명</th>
						<td>	
							<label>${commDetail.title}</label>
						</td>
						<th>추정가격</th>
						<td>	
							<label><fmt:formatNumber type="number" maxFractionDigits="3" value="${commDetail.budget}" />원</label>
						</td>
						<th>환산점수</th>
						<td colspan="3">	
							${commDetail.rates}%
						</td>
					</tr>
				</table>
			</div>
		</div>

	</div>


	<div class="sub_contents_wrap">
		<p class="tit_p mt5 mb10">평가개요</p>
	
		<div class="com_ta">
			<div class="top_box gray_box" id="newDate">
				<table style="width: 100%">
					<colgroup>
						<col width="80px;">
						<col width="400px;">
						<col width="80px;">
						<col width="">
					</colgroup>
					<tr>
						<th>평가일시</th>
						<td>
							<label>${commDetail.eval_s_date2} ~ ${commDetail.eval_e_date2}</label>&emsp;&emsp;
							<c:if test="${commDetail.eval_s_time ne '' and commDetail.eval_e_time ne ''}">
								${commDetail.eval_s_time } ~ ${commDetail.eval_e_time}
							</c:if>
						</td>
						<th>평가장소</th>
						<td>
							<label>${commDetail.eval_place }</label>
						</td>
					</tr>		
					
					<tr>
						<th>운영요원</th>
						<td colspan="3">
							<table style="width: 100%;">
								<c:forEach items="${commDetail.orpList}" var="list" varStatus="st">
									<tr>
										<td>${list.opr_dept} / ${list.opr_emp_name}</td>
									</tr>
								</c:forEach>
							</table>
						</td>
					</tr>
						
					<tr>
						<th>참여기관<br>(업체)</th>
						<td colspan="3">
							<table style="width: 300px;">
								<thead>
									<tr>
										<th>기관명</th>
									</tr>
								</thead>
								<tbody id="joinOrgDD">
									<c:forEach items="${company }" var="list" varStatus="st">
										<tr>
											<td>${list.company_name}</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</td>
					</tr>
					<tr>
						<th>평가분야</th>
						<td colspan="3">
							<table style="width: 800px;">
								<thead>
									<tr>
										<th>항목명</th>
										<th>배점</th>
										<th>100%</th>
										<th>90%</th>
										<th>80%</th>
										<th>70%</th>
										<th>60%</th>
									</tr>
								</thead>
								<tbody id="evalItemDD">
									<c:forEach items="${item }" var="list" varStatus="st">
										<tr>
											<td style="text-align: left; padding-left: 25px;">${list.item_name}</td>
											<td>${list.score}점</td>
											<td>${list.score_1}점</td>
											<td>${list.score_2}점</td>
											<td>${list.score_3}점</td>
											<td>${list.score_4}점</td>
											<td>${list.score_5}점</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</td>
					</tr>
					
				</table>
			
			</div>
		</div>
	</div>

	<div class="sub_contents_wrap">
		
		<div class="com_ta" style="min-width: 1100px;"> 
<!-- 			<div class="top_box gray_box" id="newDate"> -->
<!-- 				<dl> -->
<!-- 					<dt style=""> -->
<!-- 						전문분야 -->
<!-- 					</dt> -->
<!-- 					<dd style="line-height: 25px"> -->
<%-- 						<c:forEach items="${commTypeList }" var="list"> --%>
<%-- 							${list.biz_type_array}(${list.commissioner_cnt})명&nbsp;&nbsp; --%>
<%-- 						</c:forEach> --%>
<!-- 					</dd> -->
<!-- 				</dl> -->
<!-- 			</div> -->
			
<!-- 			<div class="left_div" style="float: left;"> -->
<!-- 				<p class="mt25">금액은 KTX 기준 금액이며, 평가일시 기준 +1 일까지만 조회가 가능합니다.</p> -->
<!-- 			</div> -->

			<div class="left_div" style="float: left;">
				<p class="tit_p mt5 mt10">평가위원구성</p>
			</div>
			
			<div class="right_div" style="float: right;">
				<div class="controll_btn p20">
					<button type="button" onclick="paySave();">저장</button>
				</div>
			</div>
				
			<form id="saveForm">	
			<table style="width: 100%;">
					<tr>
						<th>정렬순서</th>
						<th>이름</th>
						<th>소속기관주소</th>
						<th>도착지</th>
						<th>교통비</th>
						<th>평가수당</th>
						<th colspan="2">첨부파일</th>
					</tr>
					
					<tbody id="commTable">
						<c:forEach items="${commUserList }" var="list" varStatus="st">
							<tr>
								<td>${st.count }
									<input type="hidden" id="commissioner_seq" value="${list.commissioner_seq}">
								</td>
								<td><a href="#" style="color: blue;" onclick="userPopup(${list.commissioner_pool_seq});">${list.name }</a></td>
								<td class="start_1" style="width: 200px;">
                                    ${list.addr1}
								</td>
<!-- 								<td class="start_1" style="display: none; width: 100px;"> -->
<%-- 									<select class="nodeSelect" id="nodeSelect_${list.commissioner_seq }" style="width: 100px; "> --%>
<!-- 										<option value="">선택</option> -->
<!-- 									</select> -->
<!-- 								</td> -->
								<!--  
								<td class="start_2" style=" width: 200px;">
									<input type="text" id="start_station" style="width: 80%;" value="${list.start_station }">									
								</td>
								-->
								
								<td>
									농정원
								</td>
								<td>
									<input type="hidden" tabindex="${st.count }" id="pay_${list.commissioner_seq }" class="pay" value="${list.trans_pay}"" style="width:80px; text-align: right; padding-right: 5px;" readonly="readonly">
                                    내부 규정에 따름
                                </td>
								<td>
									<select id="evalPay_${list.commissioner_seq }" class="evalPay" data-evalPay="${list.eval_pay }" onchange="paySelectChange(this);" style="width: 100px;">
										<option value="200000">200,000</option>
										<option value="300000">300,000</option>
										<option value="400000">400,000</option>
										<option value="500000">500,000</option>
                                        <option value="1000000">1,000,000</option>
                                        <option value="1500000">1,500,000</option>
                                        <option value="2000000">2,000,000</option>
										<option value="">직접입력</option>
									</select>
									<input type="text" tabindex="${st.count + commUserList.size()}" class="payInput" style="width: 80px; text-align: right; padding-right: 5px; display: none;">
								</td>
								<td>
									<input type="file" name="transFile_${list.commissioner_seq }">
								</td>
								<td>
									<a href="#" onclick="payFiledown(${list.commissioner_seq });">${list.FILE_NM }</a>
								</td>
							</tr>
						</c:forEach>
					
					</tbody>
				
				</table>
				</form>

		</div>
		
		
	</div>

</div>

<form id="userViewForm" target="userView" action="<c:url value='/eval/evaluationCommitteeDetail' />" method="post">
	<input type="hidden" id="popupUserId" name="code">
</form>


<script>

$(function(){
	
	$('.citySelect').kendoDropDownList({
// 		change: function(e) {
// 			var citycode = nodeData(this.value());
// 			var id = $(e.sender.element).closest('tr').find('#commissioner_seq').val();
// 			var ds = $('#nodeSelect_'+id).data("kendoDropDownList");
// 			$('#pay_'+id).val("0");
// 			var dataSource = new kendo.data.DataSource({
// 				  data: citycode
// 			});

// 			ds.setDataSource(citycode);
// 			ds.select(0);
// 		}		
	});

	var nodeList = nodeData(11);
	$('.nodeSelect').kendoDropDownList({
		dataSource : nodeList,
		dataTextField: "nodename",
		dataValueField: "nodeid",
		change: function(e) {
			var id = $(e.sender.element).closest('tr').find('#commissioner_seq').val();
			
			var m = getTransPay(this.value());
			
			$('#pay_'+id).val(m);
		}
	});
	
	$('.evalPay').kendoDropDownList();

// 	$('input[name^=choiceRadio]').on('click', function(e){
// 		if($(this).val() == '1'){
// 			$(this).closest('tr').find('.start_1').show();
// 			$(this).closest('tr').find('.start_2').hide();
// 		}else{
// 			$(this).closest('tr').find('.start_2').show();
// 			$(this).closest('tr').find('.start_1').hide();
// 		}
		
// 	});
	
	$.each($('select[id^=evalPay]'), function(i, v){
		var pay = Number($(v).attr('data-evalPay'));
		if(pay == 200000 || pay == 300000 || pay == 400000 || pay == 500000 || pay == 1000000 || pay == 1500000 || pay == 2000000){
			$(v).data("kendoDropDownList").value(pay);
		}else{
			$(v).data("kendoDropDownList").select(7);
			$(v).closest('td').find('.payInput').val(getNumtoCom(pay)).show();			
		}
	});
	
	$(document).on('keyup', '.pay, .payInput', function(){
		$(this).val( getNumtoCom( getComtoNum( $(this).val() ) ) );
	});

	$(document).on('onchange', '.pay, .payInput', function(){
		$(this).val( getNumtoCom( getComtoNum( $(this).val() ) ) );
	});
	
});

function getTransPay(v){
	
	var m;
	
	var dd = "${commDetail.eval_date2 }";
	var depPlandTime = dd.replace(/-/gi,"");
	var depPlaceId = v;
	var arrPlaceId = "NAT050044"; //오송 고정
	var trainGradeCode = "00"; //ktx고정
	
	var data = {
			depPlandTime : depPlandTime,
			depPlaceId : depPlaceId,
			arrPlaceId : arrPlaceId,
			trainGradeCode : trainGradeCode,
	};
	
	$.ajax({
		url: "<c:url value='/busTrip/trainApi' />",
		data : data,
		type : 'GET',
		async : false,
		success: function(result){
			m = result.result[0].adultcharge;
		},
	});
	
	return m;
}

function nodeData(v){
	
	var list;
	
	$.ajax({
		url: "<c:url value='/busTrip/getKorailNode' />",
		data : {citycode : v},
		type : 'POST',
		async : false,
		success: function(result){
			result.list.unshift({nodename: '선택', nodeid : ''});
			list = result.list;
		},
	});
	
	return list;
	
	
}

function userPopup(v){
	$('#popupUserId').val(v);
	window.open("", "userView", 'toolbar=no, scrollbar=yes, width=1500px, height=900px, resizable=no, status=no');
	$('#userViewForm').submit();
}

function paySave(){
	
	var array = new Array();
	
	$.each($('#commTable tr'), function(i, v){
		var radio = "choiceRadio_" + $(v).find('#commissioner_seq').val();
		
		if($(v).find('input[name='+radio+']:checked').val() == 1){
			var sel1 = $($(v).find('select[id^=citySelect]')).data("kendoDropDownList").text();
// 			var sel2 = $($(v).find('select[id^=nodeSelect]')).data("kendoDropDownList").text();
			$(v).find('#start_station').val(sel1);
		}
	
		var data = {
			commissioner_seq : $(v).find('#commissioner_seq').val(),
			trans_pay : $(v).find('.pay').val(),
			eval_pay : $(v).find('select[id^=evalPay]').val() != '' ? $(v).find('select[id^=evalPay]').val() : $(v).find('.payInput').val(),
			start_station : $(v).find('#start_station').val(),
		};
		
		array.push(data);
		
	});
	
    var formData = new FormData($('#saveForm')[0]);
    formData.append("list", JSON.stringify(array));

    $.ajax({
		url: "<c:url value='/eval/evalTransPaySave' />",
		data : formData,
		type : 'POST',
		processData: false,
        contentType: false,
		success: function(result){
			alert('저장하였습니다.');
			location.reload();
		},
	});
	
}

function payFiledown(a){
	window.location.assign(_g_contextPath_+'/commFile/commFileDown?targetTableName=dj_eval_commissioner&targetId=' + a);
}

function paySelectChange(e){
	if($(e).val() == ''){
		$(e).closest('td').find('.payInput').val('').show();
	}else{
		$(e).closest('td').find('.payInput').hide();
	}
}

function citySelectChange(e) {
	var commissionerSeq = $(e).attr('id').replace(/[^0-9]/g, '');
	var cost = $(e).val();
	
	$('#pay_'+commissionerSeq).val(getNumtoCom(getComtoNum(cost)));
	
	//실비일 경우 코드값 -1
	if(cost == -1) {
		$('#pay_'+commissionerSeq).val('');
		$('#pay_'+commissionerSeq).attr('readonly', false);
		$('#pay_'+commissionerSeq).attr('placeholder', '금액 입력');
		$('#pay_'+commissionerSeq).focus();
	} else {
		$('#pay_'+commissionerSeq).attr('readonly', true);
	}
}
</script>


