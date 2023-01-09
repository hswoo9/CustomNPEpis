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
<script type="text/javascript" src="<c:url value='/js/jquery.number.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/jszip.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/budget/budgetUtil.js' />"></script>
<style>
	.green_btn {background:#0e7806 !important; height:24px; padding:0 11px; color:#fff !important;border:none; font-weight:bold; border:0px !important;}
</style>
<script type="text/javascript">
 
	$(function() {
		Init.kendoFunction();
		Init.kendoGrid();
		Init.eventListener();
		
		Init.ajax();
	})
	
	var Init = {
			ajax : function() {
				statusAjax();
			},
			kendoFunction : function() {
				$("#standardDate").kendoDatePicker({
				    depth: "year",
				    start: "year",
				    culture : "ko-KR",
					format : "yyyy-MM",
					value : new Date(),
					change : changeDate
				});
			},
			kendoGrid : function() {
				
			},
			eventListener : function() {
				
			}
	}
	
	function changeDate() {
		statusAjax();
	}
	
	function statusAjax() {
		$.ajax({
	 		url: _g_contextPath_+"/budget/selectBgtFinish",
	 		dataType : 'json',
	 		data : { coCd : '5000', bgtMonth : $("#standardDate").val().replace(/-/gi,'') },
	 		type : 'POST',
	 		async : false,
	 		success: function(result){
	 			$('#sts').html(result.status);
	 		}
	 	});
	}
	
	function finish() {
		$.ajax({
	 		url: _g_contextPath_+"/budget/saveBgtFinish",
	 		dataType : 'json',
	 		data : { coCd : '5000', bgtMonth : $("#standardDate").val().replace(/-/gi,'') },
	 		type : 'POST',
	 		async : false,
	 		success: function(result){
	 			if (result.OUT_YN == 'Y') {
	 				alert('마감 신청되었습니다.');
	 				statusAjax();
	 			}
	 		}
	 	});
	}
	
	function cancelFinish() {
		$.ajax({
	 		url: _g_contextPath_+"/budget/cancelBgtFinish",
	 		dataType : 'json',
	 		data : { coCd : '5000', bgtMonth : $("#standardDate").val().replace(/-/gi,'') },
	 		type : 'POST',
	 		async : false,
	 		success: function(result){
	 			if (result.OUT_YN == 'Y') {
	 				alert('취소되었습니다.')
	 				statusAjax();
	 			}
	 		}
	 	});
	}
</script>
<body>
<div class="iframe_wrap">
	<div class="pop_wrap_dir" id="filePop" style="width: 600px;">
		<div class="pop_con" style="padding: 16px 16px 0px 16px">
			<div class="top_box" style="padding: 20px;">
				<!-- 타이틀/버튼 -->
				<div class="btn_div mt0" style="height: 100%;">
					<div class="left_div"  style="width: 120px;">
						<h5><span id="popupTitle"></span>  예산신청마감</h5>
					</div>
				</div>
				<div style="margin-top : 20px;">
					<span style="margin-right: 20px; font-weight: bold;">예산신청 마감년월</span>
					<input type="text" style="width:30%" id = "standardDate" style = "" value=""/>
					<span style="margin-left: 30px; font-weight: bold;">상태 : <span id="sts" style="color:blue;"></span></span>
				</div>
			</div>
		</div>
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" class="blue_btn" value="마감" onclick="finish();"/>
				<input type="button" class="blue_btn" value="마감취소" onclick="cancelFinish();"/>
			</div>
		</div><!-- //pop_foot -->
	</div>	
</div>

</body>

