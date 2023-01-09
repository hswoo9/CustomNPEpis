<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>

<style>
.sub_contents_wrap{min-height:0px;}
.com_ta table th{text-align: center; padding-right: 0px;}
.com_ta table td{border-right: 1px solid #eaeaea;}
</style>

<script type="text/javascript" src ="<c:url value='/js/html2canvas.min.js' />"></script>
<script type="text/javascript" src ="<c:url value='/js/es6-promise.auto.js' />"></script>
<script type="text/javascript" src ="<c:url value='/js/jspdf.min.js' />"></script>
<script type="text/javascript" src ="<c:url value='/js/jquery-latest.min.js' />"></script>

<script>
var title = '${commDetail.eval_doc_num}-${commDetail.title}';
function dataPrintBtn(){
	//pdf_wrap을 canvas객체로 변환
	html2canvas($('#printDiv')[0]).then(function(canvas) {
		var doc = new jsPDF('p', 'mm', 'a4'); //jspdf객체 생성
	    var imgData = canvas.toDataURL('image/png'); //캔버스를 이미지로 변환
	    doc.addImage(imgData, 'PNG', 5, 5); //이미지를 기반으로 pdf생성
	    doc.save(title + ' 평가위원 ID발급 리스트.pdf'); //pdf저장
	  });
}

</script>

<div class="iframe_wrap" id="paintBtn">
	<div class="sub_title_wrap">
		<div class="title_div">
			<h4>제안평가 접수</h4>
		</div>
	</div>
	
	<div class="right_div" style="float: right;">
		<div class="controll_btn p20">
			<button type="button" onclick="dataPrintBtn();">다운로드</button>
		</div>
	</div>	

</div>

	
<div class="com_ta" id="printDiv" style="width:750px;">
	<table style="width: 100%;">
		<tr>
			<th style="width: 200px;">접수번호</th>
			<td colspan="2">${commDetail.eval_doc_num}</td>
		</tr>
		<tr>
			<th style="width: 200px;">사 업 명</th>
			<td colspan="2">${commDetail.title}</td>
		</tr>
		<tr>
			<th>평가일시</th>
			<td colspan="2">${commDetail.eval_s_date2} ~ ${commDetail.eval_e_date2},  ${commDetail.eval_s_time} ~ ${commDetail.eval_e_time}</td>
		</tr>
		<tr>
			<th>담당부서</th>
			<td colspan="2">${commDetail.major_dept}</td>
		</tr>
		<tr>
			<th>담당자</th>
			<td colspan="2">${commDetail.major_emp_name}</td>
		</tr>
		
		<tr>
			<th colspan="3">평가위원</th>
		</tr>
		
		<tr>
			<th>아이디</th>
			<th>비밀번호</th>
			<th>생년월일</th>
		</tr>
		
		<c:forEach items="${commUserList}" var="list">
			<tr>
				<td style="text-align: center;">${list.eval_id}</td>
				<td style="text-align: center;">${list.USER_PASS}</td>
				<td style="text-align: center;">${list.eval_birth}</td>
			</tr>
		</c:forEach>
		
	</table>


</div>
