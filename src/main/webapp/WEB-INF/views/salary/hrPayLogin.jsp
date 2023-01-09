<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="main.web.BizboxAMessage"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>

<%String langCode = (session.getAttribute("langCode") == null ? "kr" : (String)session.getAttribute("langCode")).toLowerCase();%>

<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<title>Bizbox A</title>
	
	<script>
		var langCode = "<%=langCode%>";
	</script>
	
	<!--Kendo ui css-->
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/kendoui/kendo.common.min.css" />
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/kendoui/kendo.dataviz.min.css" />
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/kendoui/kendo.mobile.all.min.css" />
	
	<!-- Theme -->
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/kendoui/kendo.silver.min.css" />
	
	<!--css-->
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css" />
	
	<!--Kendo UI customize css-->
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/reKendo.css" />

<%--    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jqueryui/jquery-ui.min.js"></script>--%>
	<!--js-->
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/Scripts/jquery-1.9.1.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/Scripts/common.js"></script>
	
	<!--Kendo ui js-->
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/kendoui/jquery.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/kendoui/kendo.all.min.js"></script>
	
	<script type="text/javascript">
		function payLogin() {
			var payPasswd = $("#payPasswd").val();
			
			if (payPasswd == "") {
				alert("<%=BizboxAMessage.getMessage("TX000002641", "비밀번호를 입력해 주세요.", langCode)%>");
				return false;
			}
			
			$.ajax({
				type : 'POST',
				url : '/attend/api/hr/payroll/checkPayPassword',
				dataType : "json",
				data : JSON.stringify({ payPasswd : payPasswd }),
				contentType : 'application/json; charset=utf-8',
				success : function(e) {
					if (!e.result) {
						console.log(e);
						alert("<%=BizboxAMessage.getMessage("TX000007640", "패스워드가 일치하지 않거나 급여패스워드가 설정되어 있지 않습니다.", langCode)%>");
						return;
					}
					
					var link = '/CustomNPEPIS/salary/salaryViewDetail';
					
					location.href = link;
				},
				error : function(result) {
					console.log(result);
					alert("<%=BizboxAMessage.getMessage("TX000005128", "알수없는 오류가 발생하였습니다.", langCode)%>");
				}
			});
			
			return false;
		}
	</script>
</head>
<body>
	<!-- contents -->
	<div class="contents_wrap">
		<div id="horizontal">
			<div class="sub_wrap">
				<div class="sub_contents scroll_y_on">
					<!-- iframe wrap -->
					<div class="iframe_wrap">
						<div class="sub_contents_wrap">
							<div class="password_div">
								<form name="pwcheckForm">
									<table>
										<tr>
											<td><img src="${pageContext.request.contextPath}/resources/Images/ico/ico_cc_rock01.png" alt="" /></td>
											<td class="txt_td">
												<ul>
													<li class="txt"><%=BizboxAMessage.getMessage("TX000002641","비밀번호를 입력해주세요.", langCode)%></li>
													<li>
														<input type="password" id="payPasswd" name="payPasswd" class="fl" style="width:230px;"/>
														<div class="controll_btn p0 fl ml4">
															<button onclick="return payLogin();"><%=BizboxAMessage.getMessage("TX000000078","확인", langCode)%></button>
														</div>
													</li>
												</ul>
											</td>
										</tr>
									</table>
								</form>
							</div>
						</div><!-- //sub_contents_wrap -->
					</div><!-- iframe wrap -->
				</div><!-- //sub_contents -->
			</div><!-- //sub_wrap -->
		</div><!-- //#horizontal -->
	</div>
</body>
</html>