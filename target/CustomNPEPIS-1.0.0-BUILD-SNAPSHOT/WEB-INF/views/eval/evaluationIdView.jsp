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

<div class="iframe_wrap" style="min-width:1400px">
	<div class="sub_title_wrap">
		<div class="title_div">
			<h4>제안평가 접수</h4>
		</div>
	</div>
	
	<div class="sub_contents_wrap">
		<p class="tit_p mt5 mt10">사업개요</p>
		
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
		<div class="left_div" style="float: left;">
			<p class="tit_p mt5 mt10">평가위원</p>
		</div>
		
		<div class="right_div" style="float: right;">
			<div class="controll_btn p20">
<%--				<button type="button" onclick="idCrtBtn();">ID 확정</button>--%>
<%--				<button type="button" onclick="idCrtModBtn();">ID 수정</button>--%>
				<button type="button" onclick="idPintBtn(1);">담당자 다운로드</button>
				<button type="button" onclick="idPintBtn(2);">개인 다운로드</button>
			</div>
		</div>	

		<div class="com_ta" style="min-width: 1400px;"> 

			
			<table style="width: 100%;">
					<tr>
						<th style="width: 50px;">정렬순서</th>
						<th style="width: 100px;">이름</th>
<%--						<th style="width: 150px;">배정ID</th>--%>
						<th>전문분야</th>
						<th>생년월일</th>
						<th>소속</th>
						<th>직급</th>
						<th style="width: 150px;">유선전화</th>
						<th style="width: 150px;">휴대폰</th>
						<th>이메일</th>
					</tr>
					
					<tbody id="commTable">
						
						<c:forEach items="${commUserList }" var="list" varStatus="st">
							<tr>
								<input type="hidden" id="commissioner_seq" value="${list.commissioner_seq }">
								<td>${st.count }</td>
								<td>${list.name }</td>
<%--								<td class="id_select_td" >--%>
<%--									<select class="id_select" style="width: 120px;" ${list.eval_id != null ? "disabled='disabled'" : "" }>--%>
<%--										<option value="C">선택</option>--%>
<%--										<c:forEach items="${evalIdList }" var="idList">--%>
<%--											<option value="${idList.EVAL_ID_SEQ }" ${idList.EVAL_ID_SEQ eq list.eval_id ? "selected='selected'" : ""} >${idList.EVAL_USER_ID }</option>--%>
<%--										</c:forEach>--%>
<%--									</select>--%>
<%--								</td>--%>
								<td>${list.BIZ_TXT }</td>
								<td>${fn:substring(list.birth_date,0,6)}</td>
								<td>${list.org_name }</td>
								<td>${list.org_grade }</td>
								<td>${list.tel }</td>
								<td>${list.mobile }</td>
								<td>${list.email }</td>
							</tr>
						
						</c:forEach>
					
					</tbody>
					
				
				</table>

		</div>
		
		
	</div>

</div>

<form id="evalPrintView" target="evalPrintView" action="<c:url value='/eval/evalPrintView' />" method="post">
	<input type="hidden" id="committee_seq" name="code" value="${commDetail.committee_seq }">
	<input type="hidden" id="print_code" name="print_code" value="">
</form>

<script>
var committee_seq = '${commDetail.committee_seq }';
$(function(){
	
	$('#create_date').val(moment().format('YYYY-MM-DD'));
	
	$('.id_select').kendoDropDownList();
	
});

<%--function idCrtBtn(){--%>
<%--	--%>
<%--	var selectBox = $('.id_select_td');--%>
<%--	var selectArray = new Array();--%>
<%--	var dataArray = new Array();--%>
<%--	--%>
<%--	for (var i = 0; i < selectBox.length; i++) {--%>

<%--		var temp = $(selectBox[i]).find('select option:selected').text();--%>
<%--		if(temp == '선택'){--%>
<%--			alert('ID를 배정해 주세요.');			--%>
<%--			return;--%>
<%--		}else if(selectArray.indexOf(temp) > -1){--%>
<%--			alert('중복 ID입니다.');			--%>
<%--			return;--%>
<%--		}--%>
<%--		--%>
<%--		selectArray.push(temp);--%>

<%--		dataArray.push({--%>
<%--			commissioner_seq : $(selectBox[i]).closest('tr').find('#commissioner_seq').val(),--%>
<%--			eval_id_seq : $(selectBox[i]).find('select option:selected').val(),--%>
<%--		});--%>
<%--		--%>
<%--		--%>
<%--	}	--%>
<%--	--%>
<%--	var data = {--%>
<%--			committee_seq : committee_seq,--%>
<%--			list : JSON.stringify(dataArray),--%>
<%--	}--%>
<%--	--%>
<%--	$.ajax({--%>
<%--		url: "<c:url value='/eval/setevalIdSave' />",--%>
<%--		data : data,--%>
<%--		type : 'POST',--%>
<%--		success: function(result){--%>
<%--			alert('저장하였습니다.');--%>
<%--			location.reload();--%>
<%--			--%>
<%--		}--%>
<%--	});--%>
<%--	--%>
<%--}--%>

function idPintBtn(v){
	$('#print_code').val(v);
	window.open("", "evalPrintView", 'toolbar=no, scrollbar=yes, width=800px, height=900px, resizable=no, status=no');
	$('#evalPrintView').submit();
}

// function idCrtModBtn(){
//
// 	$.each($('select.id_select'), function(i, v){
//
// 		$(v).data("kendoDropDownList").enable(true);
//
// 	});
//
// }


</script>