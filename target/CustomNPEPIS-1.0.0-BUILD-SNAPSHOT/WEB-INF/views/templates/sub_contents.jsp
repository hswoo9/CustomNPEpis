<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="c"       uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring"  uri="http://www.springframework.org/tags"  %>

<%-- <%String langCode = (session.getAttribute("langCode") == null ? "KR" : (String)session.getAttribute("langCode")).toUpperCase();%> --%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="Cache-control" content="no-cache">	
    <title>Bizbox Alpha</title>
    <script>
<%--     	var langCode = "<%=langCode%>"; --%>
	</script>

	<!--Kendo ui css-->

    <!-- Theme -->
	
 	<!--css-->
	<link rel="stylesheet" type="text/css" href="<c:url value='/js/Scripts/jqueryui/jquery-ui.css' />"> 
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/common.css' />"> 
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/animate.css' />"> 

	<!--js-->
 	<script type="text/javascript" src="<c:url value='/js/Scripts/jquery-1.9.1.min.js'/>"></script>
	<script type="text/javascript" src="<c:url value='/js/Scripts/jqueryui/jquery.min.js'/>"></script>
 	<script type="text/javascript" src="<c:url value='/js/Scripts/jqueryui/jquery-ui.min.js' />"></script>
 	<script type="text/javascript" src="<c:url value='/js/Scripts/common.js' />"></script>
 	<script type="text/javascript" src="<c:url value='/js/neos/NeosUtil.js' />"></script>
<%--     <script type="text/javascript" src="<c:url value='/js/jquery.form.js'/>"></script> --%>
<%--     <script type="text/javascript" src="<c:url value='/js/neos/common.js' />"></script> --%>

<%--     <script type="text/javascript" src="<c:url value='/js/neos/NeosUtil.js' />"></script> --%>
<%--     <script type="text/javascript" src="<c:url value='/js/neos/NeosCodeUtil.js' />"></script> --%>
   
   
 	<!-- 메인 js -->
<%--     <script type="text/javascript" src="<c:url value='/js/Scripts/jquery.alsEN-1.0.min.js' />"></script> --%>
<%-- 	<script type="text/javascript" src="<c:url value='/js/Scripts/jquery.bxslider.min.js' />"></script> --%>
	
    <!--js-->
<%--     <script type="text/javascript" src='${pageContext.request.contextPath}/js/Controls.js' ></script> --%>

	<!--Kendo ui css-->
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.common-custom.min.css' />">
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.dataviz.min.css' />">
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.mobile.all.min.css' />">
    
    <!-- Theme -->
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.silver.min.css' />" />
	
	<!--Kendo UI customize css-->
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/reKendo.css' />">
    
    <script type="text/javascript" src="<c:url value='/js/kendoui/kendo.all.min.js'/>"></script>
	<script type="text/javascript" src="<c:url value='/js/kendoui/cultures/kendo.culture.ko-KR.min.js'/>"></script>

    <script>
    
        function init(){}
        
        _g_contextPath_ = "${pageContext.request.contextPath}";
        $(document).ready(function(){
			$("#menuHistory li:last-child").addClass("on");
// 			dalResize(); 
        });
        
    </script>


</head>

<!-- <body> -->
	<!-- iframe wrap -->
	<div class="iframe_wrap">

		<!-- 컨텐츠타이틀영역 -->
<!-- 		<div class="sub_title_wrap"> -->
			<div class="location_info">
				 <ul id="menuHistory"></ul> 
			</div>
			<div class="title_div">
				<h4></h4>
			</div>
			
			<script>
				try {
					
					var topMenu = parent.getTopMenu();
					
					var hstHtml = '<li><a href="#n"><img src="'+_g_contextPath_+'/Images/ico/ico_home01.png" alt="홈">&nbsp;</a></li>';
					hstHtml += '<li><a href="#n">'+topMenu.name+'&nbsp;</a></li>';  
					 
					var leftList = parent.getLeftMenuList();
					 
					if (leftList != null && leftList.length > 0) {
						for(var i = leftList.length-1; i >= 0; i--) {
							hstHtml += '<li><a href="#n">'+leftList[i].name+'&nbsp;</a></li>';
						}
						
						$(".title_div").html('<h4>'+leftList[0].name+'&nbsp;</h4>');
					} else {
						$(".title_div").html('<h4>'+topMenu.name+'&nbsp;</h4>');							
					}
					
					$("#menuHistory").html(hstHtml);
					
				} catch (exception) {
				}
				
			   
			</script>
			
			
<!-- 		</div> -->
		
		<tiles:insertAttribute name="body" />
	
	</div><!-- //iframe wrap -->

<!-- </body> -->
</html>