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
<%--     <script type="text/javascript" src="<c:url value='/js/jquery.form.js'/>"></script> --%>
<%--     <script type="text/javascript" src="<c:url value='/js/neos/common.js' />"></script> --%>

    <script type="text/javascript" src="<c:url value='/js/neos/NeosUtil.js' />"></script>
<%--     <script type="text/javascript" src="<c:url value='/js/neos/NeosCodeUtil.js' />"></script> --%>
   
   
 	<!-- 메인 js -->
<%--     <script type="text/javascript" src="<c:url value='/js/Scripts/jquery.alsEN-1.0.min.js' />"></script> --%>
<%-- 	<script type="text/javascript" src="<c:url value='/js/Scripts/jquery.bxslider.min.js' />"></script> --%>
	
    <!--js-->
<%--     <script type="text/javascript" src='${pageContext.request.contextPath}/js/Controls.js' ></script> --%>

    <script>
    
        function init(){}
        
        _g_contextPath_ = "${pageContext.request.contextPath}";

        
    </script>


</head>

<body>
	<tiles:insertAttribute name="body" />
</body>
</html>