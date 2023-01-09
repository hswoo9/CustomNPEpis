<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<script type="text/javascript" src="<c:url value='/js/jquery.number.min.js' />"></script>
<script type="text/javascript" src='<c:url value="/js/ac/acUtil.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/jszip.min.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/common/organChart.js"></c:url>'></script>
<html>
<head>
</head>
<body>
<script type="text/javascript">

$(function(){
	organPopUp();
});

function organPopUp(){
	var inputParamSet = {
			dept_name : 'dept_test'
			, emp_name : 'emp_test'
	};
	
	var array = {
			btnName : 'test'
			, inputParamSet : inputParamSet
	};
	
	new organChart(array);
}
</script>
<div>
	<input type="button" id = "test" value="ddd">
	<input type="text" id = "dept_test">
	<input type="text" id = "emp_test">
</div>


<!--// pop_wrap -->
	
</body>
</html>

