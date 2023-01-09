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


<div class="iframe_wrap" style="min-width:1100px">

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
<%-- 						<c:forEach items="${commTypeList }" var="list" varStatus="st"> --%>
<%-- 							<c:choose> --%>
<%-- 								<c:when test="${st.index == 0 }"> --%>
<%-- 									${list.biz_type_array}(${list.commissioner_cnt})명 --%>
<%-- 								</c:when> --%>
<%-- 								<c:otherwise> --%>
<%-- 									,&emsp;&emsp;&emsp;${list.biz_type_array}(${list.commissioner_cnt})명 --%>
<%-- 								</c:otherwise> --%>
<%-- 							</c:choose> --%>
<%-- 						</c:forEach> --%>
<!-- 					</dd> -->
<!-- 				</dl> -->
<!-- 			</div> -->
			
			<div class="righr_div" style="float: left;">
				<p class="tit_p mt5 mb10">평가위원구성</p>
			</div>

			<table style="width: 100%;">
					<tr>
						<th style="width: 50px;">순서</th>
						<th style="width: 100px;">이름</th>
						<th>생년월일</th>
						<th>소속</th>
						<th>직급</th>
						<th style="width: 150px;">유선전화</th>
						<th style="width: 150px;">휴대폰</th>
						<th>이메일</th>
						<th>교통비</th>
						<th>평가수당</th>
						<th>서명파일</th>
					</tr>
					
					<tbody id="commTable">
						
						<c:forEach items="${commUserList }" var="list" varStatus="st">
							<tr>
								<td>${st.count }</td>
								<td><a href="#" style="color: blue;" onclick="userPopup(${list.commissioner_pool_seq});">${list.name}</a></td>
								<td>${fn:substring(list.birth_date,0,6)}</td>
								<td>${list.org_name }</td>
								<td>${list.org_grade }</td>
								<td>${list.tel }</td>
								<td>${list.mobile }</td>
								<td>${list.email }</td>
								<td>내부 규정에 따름</td>
								<td><fmt:formatNumber type="number" maxFractionDigits="3" value="${list.eval_pay }" />원</td>
								<td><input type="button" value="다운로드" param1="${list.commissioner_seq}" param2="${list.name}" param3="${commDetail.title}" onclick="downloadSPDF(this);"></td>

							</tr>
						
						</c:forEach>
					
					</tbody>
					
				
				</table>

		</div>
		
		
	</div>

</div>

<form id="userViewForm" target="userView" action="<c:url value='/eval/evaluationCommitteeDetail' />" method="post">
	<input type="hidden" id="popupUserId" name="code">
</form>

<form id="evalResultForm" target="evalResult" action="<c:url value='/eval/evalResult' />" method="post">
	<input type="hidden" id="committee_seq" name="code" value="${commDetail.committee_seq }">
</form>

<script>

function userPopup(v){
	$('#popupUserId').val(v);
	window.open("", "userView", 'toolbar=no, scrollbar=yes, width=1500px, height=900px, resizable=no, status=no');
	$('#userViewForm').submit();
}

function evalResultBtn(){
	window.open("", "evalResult", 'toolbar=no, scrollbar=yes, width=1500px, height=900px, resizable=no, status=no');
	$('#evalResultForm').submit();
}

function downloadSPDF(d){
	var commissioner_seq = $(d).attr("param1");
	var titleToName = $(d).attr("param2");
	var titleToProject = $(d).attr("param3");
	
// 	$.ajax({
// 		url: "<c:url value='/eval/evalProposalModFileDownload'/>",
// 		data: {
// 				"commissioner_seq" : commissioner_seq,
// 				"name" : titleToName,
// 				"project_name" : titleToProject
// 			},
// 		type : "POST",
// 		success : function(result){
// 			console.log(result)
// 		}
// 	});
	
	window.location.assign("<c:url value='/eval/evalProposalModFileDownload'/>?commissioner_seq="+commissioner_seq+"&name="+titleToName);
	
}
</script>


