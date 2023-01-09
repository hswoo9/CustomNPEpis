<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${title}</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript">
	/* tiles : contents_tiles.jsp */
</script>

<!--Kendo ui css-->
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.common.min.css' />">
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.dataviz.min.css' />">
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.mobile.all.min.css' />">
    
    <!-- Theme -->
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.silver.min.css' />" />
	
	<!--Kendo UI customize css-->
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/reKendo.css' />">
    

    <script type="text/javascript" src="<c:url value='/js/neos/neos_common.js' />"></script>

	<link rel="stylesheet" type="text/css" href="<c:url value='/js/Scripts/jqueryui/jquery-ui.css' />"/>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/common.css' />"/>
	
	<!--jsTree css-->
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/jstree/style.min.css' />">

    <!--js-->
	<script type="text/javascript" src="<c:url value='/js/Scripts/jquery-1.9.1.min.js' />"></script>
	<script type="text/javascript" src="<c:url value='/js/Scripts/jqueryui/jquery-ui.min.js' />"></script> 
	<script type="text/javascript" src="<c:url value='/js/Scripts/common.js' />"></script>
	<script type="text/javascript" src="<c:url value='/js/neos/NeosUtil.js' />"></script>

	<!--jsTree js-->
	<script type="text/javascript" src="<c:url value='/js/Scripts/jstree/jstree.min.js' />"></script>
	<script type="text/javascript" src="<c:url value='/js/kendoui/jquery.min.js' />"></script>
	<script type="text/javascript" src="<c:url value='/js/kendoui/kendo.all.min.js' />"></script>
	<script type="text/javascript" src="<c:url value='/js/kendoui/cultures/kendo.culture.ko-KR.min.js' />"></script>


<script>
	_g_contextPath_ = "${pageContext.request.contextPath}";
</script>

</head>

<body>
	<tiles:insertAttribute name="body" />
</body>
</html>