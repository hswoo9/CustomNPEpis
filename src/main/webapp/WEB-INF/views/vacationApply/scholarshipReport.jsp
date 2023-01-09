<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<jsp:useBean id="year" class="java.util.Date" />
<jsp:useBean id="mm" class="java.util.Date" />
<jsp:useBean id="dd" class="java.util.Date" />
<jsp:useBean id="weekDay" class="java.util.Date" />
<jsp:useBean id="nowDate" class="java.util.Date" />
<fmt:formatDate value="${nowDate}" var="nowDate" pattern="yyyy-MM-dd" />
<fmt:formatDate value="${year}" var="year" pattern="yyyy" />
<fmt:formatDate value="${mm}" var="mm" pattern="MM" />
<fmt:formatDate value="${dd}" var="dd" pattern="dd" />
<fmt:formatDate value="${weekDay}" var="weekDay" pattern="E" type="date" />
<script type="text/javascript"
	src="<c:url value='/js/jquery.number.min.js' />"></script>
<!-- <script type = "text/javascript" src = "http://code.jquery.com/jquery-latest.min.js"></script> -->
<script type="text/javascript"
	src="https://cdnjs.cloudflare.com/ajax/libs/bluebird/3.3.5/bluebird.min.js"></script>
<script type="text/javascript"
	src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/1.5.3/jspdf.min.js"></script>
<script type="text/javascript"
	src="https://html2canvas.hertzen.com/dist/html2canvas.min.js"></script>
<style>
h1, h2, h3, h4, h5, dl, dt, dd, ul, li, ol, th, td, p, blockquote, form,
	fieldset, legend, div, body {
	-webkit-print-color-adjust: exact;
}

table {
	border-style: solid;
	border-width: 1px;
	border-color: rgb(0, 0, 0);
	font-size: 17px;
}

table tr {
	min-height: 35px;
	height: 35px;
}

table th {
	background-color: #F0F6FD !important;
	background: #F0F6FD !important;
	color: rgb(0, 0, 0) !important;
	/* 	height : 50px; */
}

.sub_contents_wrap {
	min-height: 50px;
}

.print table {
	border-style: solid;
	border-width: 1px;
	border-color: rgb(0, 0, 0);
	font-size: 13px;
}

.print table tr {
	min-height: 25px;
	height: 25px;
}

.print table th {
	background-color: #F0F6FD !important;
	background: #F0F6FD !important;
	color: rgb(0, 0, 0) !important;
	height: 50px;
}

.k-grid tbody tr {
	height: 38px;
}
</style>


<body>

	<script type="text/javascript">

var $family_code = JSON.parse('${family_code}');
var $education_expense_id = '${education_expense_id}';
var $rowData = {};					//그리드한줄정보
var $gridIndex = 0;					//그리드인덱스번호
var $insertChk = true;				//신청화면 insert/update 구분
var $addIndex = 0;					//팝업그리드 인덱스
var $empRowData = [];			//신청자사원정보
var $access_type = '${access_type}';
var $appro_status = '${appro_status}';
	$(function(){
		
		defaultSet();
		
		if($access_type == 'admin' && $appro_status == '1'){
			$("#apply").hide();
			$("#approval").show();
		}else if($access_type == 'admin' && $appro_status == '2'){
			$("#apply").hide();
			$("#approval").hide();
		}else if($access_type == 'user' && $appro_status == '4'){
			$("#approval").hide();
			$("#print").hide();
			//$("#fileDown").hide();
			$("#apply").show();
		}else if($access_type == 'user' && $appro_status == '2'){
			$("#approval").hide();
			$("#print").show();
			//$("#fileDown").hide();
			$("#apply").hide();
		}else if($access_type == 'user' && $appro_status == '1'){
			$("#approval").hide();
			$("#print").hide();
			//$("#fileDown").hide();
			$("#apply").hide();
		}
		
		$("[name='close']").click(function(){
			$("#applyPreviewPop").data("kendoWindow").close();
		});
		
		$(".file_input_button").on("click", function(){
			$(this).next().click();
		});
		
		$(document).on('change', "[name='file']", function(){
			var fileNm = '';
			$.each($("#fileID").get(0).files, function(i,v){
				fileNm += v.name + ', '
			})			
			fileNm = fileNm.substring(0, fileNm.length-2);
			var row = $(this).closest('dd');
			row.find('#fileID1').val(fileNm).css({'color':'#0033FF'});
		});

		preView();
		console.log("${userInfo}");

	});
	
	function defaultSet(){
		
		$("#empName").val("${userInfo.empName}");
		empRowDataSet();
		
		var empSeq = "${userInfo.empSeq}";
		$("#empNo").val($empRowData.erp_emp_num);
		$("#empSeq").val($empRowData.emp_seq);
		$("#empName").val($empRowData.emp_name);
		$("#empDept").val($empRowData.dept_name);
	}

	function empRowDataSet(){
		if($empRowData.length<1){
			
			$.ajax({
					url : _g_contextPath_+'/common/selectEmp',
					data : {empSeq : '${userInfo.empSeq}', skip:0, pageSize:1},
					type : "POST",
					async : false,
					success : function(result){
						
						$.ajax({
							url : _g_contextPath_+'/common/empInformation',
							data : {emp_name : result.list[0].emp_name, skip:0, pageSize:1},
							type : "POST",
							async : false,
							success : function(result){
								
								if(result.list.length >0){
									$empRowData = result.list[0];
								}
							}
						});
					}
				});
		}
	}
	
	function preView(){
		
		dataItem = [];
		detailData = [];
		empRowDataSet();
		$.ajax({
			url : _g_contextPath_+"/vacationApply/scholarApplyList",
			data : {
				education_expense_id : '${education_expense_id}',
				apply_from_date : '${apply_from_date}',
				apply_to_date : '${apply_to_date}',
				skip : 0,
				pageSize : 1
			},
			type : "POST",
			async: false,
			success : function(result){
				dataItem = result.list[0];
				$rowData = result.list[0];
			}
		});
		
		$("#test").html(makeContentsStr(dataItem, detailData));
		$.each($("#1 td"), function(i,v){
			$(v).text($(v).text().replace(/undefined/gi,''));
		})
		$.each($("#2 td"), function(i,v){
			$(v).text($(v).text().replace(/undefined/gi,''));
		})
		
	}
	
	function fileDown(){
		
		$(".sub_contents_wrap").hide();

	  /*  var elHtml = $('.iframe_wrap').html();
// 	  if (htmllinereplace) elHtml = elHtml.replace(/\<br\>/gi,'\n');
	  var link = document.createElement('a');
	  
	  var type = '';
	  var name = $rowData.request_emp_name;
	  if('${report_type}' == 1){
		  type = '부양가족 신고서';
	  }else{
		  type = '복지포인트 신고서';
	  }
	  
	  link.setAttribute('download', type + '(' + name +').html');
	  link.setAttribute('href', 'data:' + 'html'  +  ';charset=utf-8,' + encodeURIComponent(elHtml));
	  link.click();  */
	  
		/* 	 html2canvas($('body').get(0)).then(function(canvas) {
		html2canvas($('#test')[0]).then(function(canvas) {
		    var doc = new jsPDF('p', 'mm', 'a4'); //jspdf객체 생성
		    var imgData = canvas.toDataURL('image/png'); //캔버스를 이미지로 변환
		    var imgWidth = 210; // 이미지 가로 길이(mm) A4 기준
		    var pageHeight = imgWidth * 1.414;  // 출력 페이지 세로 길이 계산 A4 기준
		    var imgHeight = canvas.height * imgWidth / canvas.width;
		    var heightLeft = imgHeight;
		    var position = 0;
		    doc.addImage(imgData, 'PNG', 0, 0); //이미지를 기반으로 pdf생성
		doc.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight);
       	heightLeft -= pageHeight;
		    debugger
		    return false
		    doc.save('sample-file.pdf'); //pdf저장
		  });  */

	  html2canvas($('#test')[0]).then(function(canvas) { //저장 영역 div id
			
		    // 캔버스를 이미지로 변환
		    var imgData = canvas.toDataURL('image/png');
			     
		    var imgWidth = 190; // 이미지 가로 길이(mm) / A4 기준 210mm
		    var pageHeight = imgWidth * 1.414;  // 출력 페이지 세로 길이 계산 A4 기준
		    var imgHeight = canvas.height * imgWidth / canvas.width;
		    var heightLeft = imgHeight;
		    var margin = 10; // 출력 페이지 여백설정
		    var doc = new jsPDF('p', 'mm');
		    var position = 0;
		       
		    // 첫 페이지 출력
		    doc.addImage(imgData, 'PNG', margin, position, imgWidth, imgHeight);
		    heightLeft -= pageHeight;
		         
		    // 한 페이지 이상일 경우 루프 돌면서 출력
		    while (heightLeft >= 20) {
		        position = heightLeft - imgHeight;
		        doc.addPage();
		        doc.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight);
		        heightLeft -= pageHeight;
		    }
		    
		    var type = '';
			var name = $rowData.request_emp_name;
			if('${report_type}' == 1){
				type = '부양가족 신고서';
			}else{
				type = '복지포인트 신고서';
			}
		 
		    // 파일 저장
		    doc.save(type + '(' + name +').pdf');
	  });

		$(".sub_contents_wrap").show();

	}
	
	function approval(){
		
		var text = prompt('지급액', $("#account").text().replace(/\,/gi,''));
		
		if(text == null || text == ""){
			alert('지금액 입력이 필요합니다.');
			return false;
		}
		
		var param = {};
		var approData = [];

		var list = {};
		list.education_expense_id = $education_expense_id;
		list.update_emp_seq = '${userInfo.empSeq}';
		list.scholarship_account = text;
		
		approData.push(list);
		param.approData = JSON.stringify(approData);
		
		$.ajax({
			url: _g_contextPath_ + '/vacationApply/scholarApprovalUpdate',
			type: 'post',
			dataType: 'json',
			data: param,
			async : false,
			success: function(json){
				
				var url = window.location.href;
				url = url.replace(/appro_status=1/gi,'appro_status=2');
				location.replace(url);
				alert("승인 완료");
			}
		});
	}
	

	function save(sep, status){
		
		var param = {
				education_expense_id : $education_expense_id,
				appro_status : status,
				create_emp_seq : "${userInfo.empSeq}"
		}
		param.status = "update";
		var data = [];
		param.data = JSON.stringify(data);
		$.ajax({
			url : _g_contextPath_+'/vacationApply/scholarApplySave',
			data : param,
			type : "POST",
			async : false,
			success : function(result){
				alert("신청완료되었습니다.");
				var url = window.location.href;
				url = url.replace(/appro_status=4/gi,'appro_status=1');
				location.replace(url);
			}
		});
	}
	
	function makeContentsStr(mainData, familyData){
		
		var contentsStr = "";
		contentsStr += '<table class="com_ta" width="55%" height="42px" marginheight="0px" cellspacing="0" cellpadding="0" style="margin:auto;border:3px;text-align: center;border-top-style:hidden;border-bottom-style:double;border-right-style:hidden;border-left-style:hidden">';
		contentsStr += '<colgroup>';
		contentsStr += '<col width=""/>';
		contentsStr += '</colgroup>';
		contentsStr += '<tbody>';
		contentsStr += '<tr>';
		contentsStr += '<td class="pt30" style="text-align:center;font-size:30px;">자녀학비보조비 지급신청서</td>';
		
		contentsStr += '</tr></table>';
		
		contentsStr += '<table class="com_ta" width="90%" height="42px" marginheight="0px" cellspacing="0" cellpadding="0" style="text-align: left;margin:auto;margin-top:60px;border-top-style:hidden;border-bottom-style:hidden;border-right-style:hidden;border-left-style:hidden">';
		contentsStr += '<colgroup>';
		contentsStr += '<col width=""/>';
		contentsStr += '</colgroup>';
		contentsStr += '<tbody>';
		contentsStr += '<tr>';
		contentsStr += '<td class="" style="text-align:left;font-size:25px;">1. 지급 대상자</td>';
		contentsStr += '</tr></table>';
		

		contentsStr += '<table id = "1" class="com_ta" width="90%" height="42px" marginheight="0px" border="1px solid #b1b1b1" cellspacing="0" cellpadding="0" style="margin:auto;margin-top:20px;text-align: center;">';
		contentsStr += '<colgroup>';
		contentsStr += '<col width="150px"/>';
		contentsStr += '<col width="150px"/>';
		contentsStr += '<col width="150px"/>';
		contentsStr += '<col width="150px"/>';
		contentsStr += '<col width="150px"/>';
		contentsStr += '</colgroup>';
		contentsStr += '<tbody>';
		
		contentsStr += '<tr>';
		contentsStr += '<th colspan = "1" >소 속</th>';
		contentsStr += '<th colspan = "1" >직 급</th>';
		contentsStr += '<th colspan = "1" >성 명</td>';
		contentsStr += '<th colspan = "1" >사 번</th>';
		contentsStr += '<th colspan = "1" >입 사 일</td>';
		
		contentsStr += '</tr>';
		contentsStr += '<tr>';
		contentsStr += '<td colspan = "1" >'+mainData.request_dept_name+'</td>';
		contentsStr += '<td colspan = "1" >'+mainData.request_duty+'</td>';
		contentsStr += '<td colspan = "1" >'+mainData.request_emp_name+'</td>';
		contentsStr += '<td colspan = "1" >'+mainData.request_emp_no+'</td>';
		contentsStr += '<td colspan = "1" >'+$empRowData.join_day+'</td>';
		contentsStr += '</tr>';
	
		contentsStr += '</tbody>';
		contentsStr += '</table>';
		
		contentsStr += '<table class="com_ta" width="90%" height="42px" marginheight="0px" cellspacing="0" cellpadding="0" style="text-align: left;margin:auto;margin-top:60px;border-top-style:hidden;border-bottom-style:hidden;border-right-style:hidden;border-left-style:hidden">';
		contentsStr += '<colgroup>';
		contentsStr += '<col width=""/>';
		contentsStr += '</colgroup>';
		contentsStr += '<tbody>';
		contentsStr += '<tr>';
		contentsStr += '<td class="" style="text-align:left;font-size:25px;">2. 취학자녀</td>';
		contentsStr += '</tr></table>';
		
		contentsStr += '<table id = "2" class="com_ta" width="90%" height="42px" marginheight="0px" border="1px solid #b1b1b1" cellspacing="0" cellpadding="0" style="margin:auto;margin-top:20px;text-align: center;">';
		contentsStr += '<colgroup>';
		contentsStr += '<col width="130px"/>';
		contentsStr += '<col width="130px"/>';
		contentsStr += '<col width="130px"/>';
		contentsStr += '<col width="130px"/>';
		contentsStr += '<col width="130px"/>';
		contentsStr += '<col width="250px"/>';
		contentsStr += '</colgroup>';
		contentsStr += '<tbody>';
		
		contentsStr += '<tr>';
		contentsStr += '<th colspan = "1" >성 명</th>';
		contentsStr += '<th colspan = "1" >생년월일</th>';
		contentsStr += '<th colspan = "1" >학 교 명</td>';
		contentsStr += '<th colspan = "1" >학 년</th>';
		contentsStr += '<th colspan = "1" >신청금액</td>';
		contentsStr += '<th colspan = "1" >취학자녀변경여부</td>';
		
		contentsStr += '</tr>';
		contentsStr += '<tr>';
		contentsStr += '<td colspan = "1" >'+mainData.target_name+'</td>';
		contentsStr += '<td colspan = "1" >'+mainData.target_birth_format+'</td>';
		contentsStr += '<td colspan = "1" >'+mainData.education_institution+'</td>';
		contentsStr += '<td colspan = "1" >'+mainData.education_grade+'</td>';
		contentsStr += '<td colspan = "1" id="account">'+mainData.education_sum_money_format+'</td>';
		contentsStr += '<td colspan = "1" >'+mainData.remark+'</td>';
		contentsStr += '</tr>';
	
		contentsStr += '</tbody>';
		contentsStr += '</table>';
		
		contentsStr += '<table class="com_ta" width="90%" height="42px" marginheight="0px" cellspacing="0" cellpadding="0" style="margin:auto;padding-left:20px;text-align: left;border-top-style:hidden;border-bottom-style:hidden;border-right-style:hidden;border-left-style:hidden">';
		contentsStr += '<colgroup>';
		contentsStr += '<col width=""/>';
		contentsStr += '</colgroup>';
		contentsStr += '<tbody><tr><td style="font-size:20px;"></br></br></br>첨 부 : 납입금 영수증(고지서) 사본 1부.</br></td></tr>';
		contentsStr += '<tr>';
		contentsStr += '<td style="padding-left:30px;font-size:20px;"></br></br>위와 같이 학자보조금 지급을 신청합니다.</br></br></br></br></br></br></td>';
	
		if($appro_status == '2'){
			
			var ud = new Date(mainData.update_date);
			contentsStr += '<tr style="text-align : right;font-size:20px;"><td colspan="2">'+(ud.getYear()+1900)+'&nbsp;년  &nbsp;&nbsp;&nbsp;'+(ud.getMonth()+1)+'&nbsp;월  &nbsp;&nbsp;&nbsp;'+ud.getDate()+'&nbsp;일</br></br></br></br></br></br></td></tr>';
		}else{
			contentsStr += '<tr style="text-align : right;font-size:20px;"><td colspan="2">    &nbsp;년  &nbsp;&nbsp;&nbsp;&nbsp;월  &nbsp;&nbsp;&nbsp;&nbsp;일</br></br></br></br></br></br></td></tr>';
		}
		
		
		// 서명이미지파일 잇을때
		contentsStr += '<tr style="text-align : right;font-size:20px;"><td>신청인  &nbsp;&nbsp:&nbsp;&nbsp;&nbsp;&nbsp;'+mainData.request_emp_name+'</td><td style="text-align:center;background-image:url(/CustomNPEPIS/Images/customImg.png);background-position:center center;background-repeat:no-repeat;background-size:90px 30px;width:180px">(인  &nbsp;또는  &nbsp;서명)</td></tr>';
		// 서명 이미지파일 없을때
		contentsStr += '<tr style="text-align : right;font-size:20px;"><td>신청인  &nbsp;&nbsp:&nbsp;&nbsp;&nbsp;&nbsp;'+mainData.request_emp_name+'</td><td style="text-align:center;position:relative">(인  &nbsp;또는  &nbsp;서명)<div style="position:absolute;top:5px;left:35px;font: bold 1.5em/1em Georgia, serif">'+mainData.request_emp_name+'</div></td></tr>';
// 		contentsStr += '<tr><td style="padding-left:20px;padding-bottom:20px;font-size:20px;">농림수산식품교육문화정보원장  &nbsp;&nbsp;귀하</br></td></tr>';
		contentsStr += '</table>';

		return contentsStr;
	}

	function printView(){
		
		$(".sub_contents_wrap").hide();
		if( navigator.userAgent.indexOf("Trident") > 0 ){
	        $("#test").addClass("print");
			window.preview_print();
	        
	    } else if( navigator.userAgent.indexOf("Chrome") > 0){
	        window.print();
	    }else{
	    	preview_print();
	    }
		$(".sub_contents_wrap").show();
		$("#test").removeClass("print");
	}

	function preview_print(){
		try{
			   var OLECMDID = 7;
			   var PROMPT = 1;
			   var WebBrowser = '<OBJECT ID="WebBrowser1" WIDTH=0 HEIGHT=0 CLASSID="CLSID:8856F961-340A-11D0-A96B-00C04FD705A2"></OBJECT>';
			   document.body.insertAdjacentHTML('beforeEnd', WebBrowser);
			   WebBrowser1.ExecWB( OLECMDID, PROMPT);
			   WebBrowser1.outerHTML = '';
		}catch(e){
			alert("- 도구 > 인터넷 옵션 > 보안 탭 > 신뢰할 수 있는 사이트 선택\n   1. 사이트 버튼 클릭 > 사이트 추가\n   2. 사용자 지정 수준 클릭 > 스크립팅하기 안전하지 않은 것으로 표시된 ActiveX 컨트롤 (사용)으로 체크\n\n※ 위 설정은 프린트 기능을 사용하기 위함임");
		}
	}

</script>

	<div class="iframe_wrap">
		<div class="sub_contents_wrap">
			<div class="btn_div mt10 cl">
				<div class="right_div">
					<div class="controll_btn p0">
						<!-- 					<button type="button" id="approvalChk" onclick = "approvalChk()">결재보기</button> -->
						<input type="button" class="gray_btn" id="print"
							onclick="printView()" value="출력">
						<button type="button" id="fileDown" onclick="fileDown()">파일</button>
						<button type="button" id="approval" onclick="approval()">승인</button>
						<button type="button" id="apply" onclick="save('click',1)">신청</button>
					</div>
				</div>
			</div>
		</div>
		<div id="test"></div>
	</div>

</body>
