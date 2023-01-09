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
var cnt = 0;
var timeIn;
var img = new Array();
function dataPrintBtn(){
	cnt = 0;
	timeIn = setInterval(pdfCon, 1000);
}

function dataPrintAllBtn(){
	cnt = 0;
	img = new Array();
	timeIn = setInterval(pdfAllCon, 1000);
}

function pdfCon(){
	
	var name = $($('.printDiv')[cnt]).find('#name').text();
	console.log(name);
	
	//pdf_wrap을 canvas객체로 변환
	html2canvas($('.printDiv')[cnt]).then(function(canvas) {
		var doc = new jsPDF('p', 'mm', 'a4'); //jspdf객체 생성
	    var imgData = canvas.toDataURL('image/png'); //캔버스를 이미지로 변환
	    doc.addImage(imgData, 'PNG', 5, 5); //이미지를 기반으로 pdf생성
	    doc.save( title + '-' + name + '.pdf'); //pdf저장
	});
	
	if(cnt == $('.printDiv').length-1){
		clearInterval(timeIn);
	}else{
		cnt++;
	}
	
}

function pdfAllCon(){
	if(cnt == $('.printDiv').length){
		clearInterval(timeIn);

		var doc = new jsPDF('p', 'mm', 'a4'); //jspdf객체 생성
		for (var i = 0; i < img.length; i++) {
			 doc.addImage(img[i], 'PNG', 5, 5); //이미지를 기반으로 pdf생성
			 
			 if(i < img.length-1){
				 doc.addPage();
			 }
			 
		}

		doc.save( title + '-평가위원 목록.pdf'); //pdf저장
		
	}else{

		html2canvas($('.printDiv')[cnt]).then(function(canvas) {
		    var imgData = canvas.toDataURL('image/png'); //캔버스를 이미지로 변환
		    img.push(imgData);
		});
		
		cnt++;
	}
	
}

</script>

<div class="iframe_wrap" id="printDiv">
	
	<div class="right_div" id="paintBtn" style="float: right;">
		<div class="controll_btn p30">
			<button type="button" onclick="dataPrintBtn();">개인 다운로드</button>
<!-- 			<button type="button" onclick="dataPrintAllBtn();">전체 다운로드</button> -->
		</div>
	</div>	

</div>

	
<c:forEach items="${commUserList}" var="list">

	<div class="com_ta printDiv" style="width:750px; padding-top:30px;">
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
				<th>평가일시</th>
				<td colspan="2">${commDetail.eval_s_date2} ~ ${commDetail.eval_e_date2},  ${commDetail.eval_s_time} ~ ${commDetail.eval_e_time}</td>
			</tr>
			
			<tr>
				<th colspan="3">평가위원</th>
			</tr>
			
			<tr>
				<th>아이디</th>
				<th>비밀번호</th>
				<th>생년월일</th>
			</tr>
				<tr>
					<td style="text-align: center;" id="name">${list.eval_id}</td>
					<td style="text-align: center;">${list.USER_PASS}</td>
					<td style="text-align: center;">${list.eval_birth}</td>
				</tr>
		</table>
	
	</div>

</c:forEach>
