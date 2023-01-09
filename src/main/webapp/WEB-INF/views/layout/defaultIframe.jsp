<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
 
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko" style="overflow-y:hidden">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<title>${title}</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	
	<!--Kendo ui css-->
    <link rel="stylesheet" type="text/css" href="<c:url value='/resources/css/kendoui/kendo.common.min.css' />">
    <link rel="stylesheet" type="text/css" href="<c:url value='/resources/css/kendoui/kendo.dataviz.min.css' />">
    <link rel="stylesheet" type="text/css" href="<c:url value='/resources/css/kendoui/kendo.mobile.all.min.css' />">
    
    <!-- Theme -->
	<link rel="stylesheet" type="text/css" href="<c:url value='/resources/css/kendoui/kendo.silver.min.css' />" />

	<!--css-->
    <link rel="stylesheet" type="text/css" href="<c:url value='/resources/css/common.css' />"> 
	
	<!--Kendo UI customize css-->
    <link rel="stylesheet" type="text/css" href="<c:url value='/resources/css/reKendo.css' />">
    
    <link rel="shortcut icon" href="<c:url value='/favicon.ico' />" />
	
    <script type="text/javascript" src="<c:url value='/resources/js/kendoui/jquery.min.js'/>"></script>
    <script type="text/javascript" src="<c:url value='/resources/js/jquery.form.js'/>"></script>
    
    <script type="text/javascript" src="<c:url value='/resources/js/neos/common.js' />"></script>
    <script type="text/javascript" src="<c:url value='/resources/js/neos/common.kendo.js' />"></script>
    <%-- <script type="text/javascript" src="<c:url value='/resources/js/neos/resize_iframe.js' />"></script> --%>
    <script type="text/javascript" src="<c:url value='/resources/js/neos/neos_common.js' />"></script>
    <script type="text/javascript" src="<c:url value='/resources/js/neos/NeosUtil.js' />"></script>
    <script type="text/javascript" src="<c:url value='/resources/js/neos/NeosCodeUtil.js' />"></script>
	<script type="text/javascript" src="<c:url value='/resources/js/kendoui/kendo.core.min.js'/>"></script>
	<script type="text/javascript" src="<c:url value='/resources/js/kendoui/kendo.all.min.js'/>"></script>
	<script type="text/javascript" src="<c:url value='/resources/js/kendoui/cultures/kendo.culture.ko-KR.min.js'/>"></script>
	
    <!--js-->
    <script type="text/javascript" src="<c:url value='/resources/js/Scripts/common.js' />"></script>
    
    <script type="text/javascript" src="<c:url value='/resources/js/neos/systemx/systemx.menu.js' />"></script>
    <script type="text/javascript" src="<c:url value='/resources/js/neos/systemx/systemx.main.js' />"></script>
    
     <!-- top js -->
    <script type="text/javascript" src="<c:url value='/resources/js/Scripts/jquery.alsEN-1.0.min.js' />"></script>
	<script type="text/javascript" src="<c:url value='/resources/js/Scripts/jquery.bxslider.min.js' />"></script>
    
	<script type="text/javascript">
	$(document).ready(function() {
		// iframe
		var no = '${params.no}';
		var name = '${params.name}';
		var url = '${params.url}';
		var urlGubun = '${params.urlGubun}';
		var mainForward = '${params.mainForward}';
		var gnbMenuNo = '${params.gnbMenuNo}';
		var lnbMenuNo = '${params.lnbMenuNo}';
		var portletType = '${params.portletType}';
		
		// GNB 버튼 클릭
		/* if (mainForward == null || mainForward == '') {
			menu.clickTopBtn(no, name, url, urlGubun);
		} 
		// 메인 iframe 에서 페이지 이동을 누른경우
		else {
			menu.forwardFromMain(portletType, gnbMenuNo, lnbMenuNo, url, urlGubun, name);
		} */
		
		menu.getLeftMenuHistory(11);
		setContent("<c:url value='/patch/moduleSourceList' />");
				
	});
	
	function getTopMenu() {
		var topInfo = {};
		topInfo.name = "관리";
		return topInfo;
		//return menu.topMenuInfo;
	}
	
	function getLeftMenuList() {
		return menu.leftMenuList;
	}
	
	function setContent(url) {
		$("#_content").attr("src", url);
	}
	
	</script>
     
</head>


<body class="">
	<!-- Header -->
	<div class="header_wrap">
	 
		<jsp:include page="./defaultTop.jsp" />
		 
	</div> 
	 
	<!-- contents -->
	<div class="contents_wrap">
		<div id="horizontal">
			
			<jsp:include page="./defaultLeft.jsp" />
			
			<div class="sub_wrap">
				<div class="sub_contents">
						<!-- iframe 영역 -->  
						<iframe name="_content" id="_content" class="" src="" frameborder="0" scrolling="yes" width="100%" height="100%"></iframe>
				</div> 
			</div>    
		</div> <!--//# horizontal -->
			

	  	<div class="footer">
			<span class="copy">Copyright Duzon Bizon. All right reserved.</span>
			<ul class="sub_etc">
				<c:if test="${!empty loginVO.eaType}">
				<li><a href="#"><span class="t1">&nbsp;</span>기안작성</a></li>
				<li>|</li>
				</c:if>				<li><a href="javascript:;"><span class="t2">&nbsp;</span>조직도</a></li>
				<li>|</li>
				<!-- <li><a href="javascript:;"><span class="t3">&nbsp;</span>메신져</a></li> -->
				<li><a href="#"><span class="t3">&nbsp;</span>메신져</a></li>
				<li>|</li>
				<li><a href="javascript:;"><span class="t4">&nbsp;</span>업무도우미</a></li>
				<li>|</li>
				<li><a href="#"><span class="t5">&nbsp;</span>앱다운로드</a></li>
			</ul>
			<div class="pop_appdown" style="display:none;">
				<div class="appdown_in">
					<a href="javascript:appdown_clo();" class="clo"><img src="/gw/Images/ico/ico_timeline_close.png" alt="닫기"/></a>
					<p class="txt">QR코드를 스캔하시면 비즈박스모바일을 다운받을 수 있는 스토어로 이동합니다.</p>
					<p class="pic"><img src="/gw/Images/temp/bizboxA_App_QR.png" alt="" width="100" height="100"/></p>
					<p class="tit">IOS / Android</p>
				</div>
			</div>
		</div>
	  	
	</div> 
	
	<script>
	
		function init(){}
		 
		_g_contextPath_ = "${pageContext.request.contextPath}";
		_g_compayCD ="<nptag:commoncode  codeid = 'S_CMP' code='SITE_CODE' />";
	</script>
</body>
</html>
