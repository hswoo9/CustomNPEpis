<%@page import="org.apache.xmlbeans.impl.xb.xsdschema.IncludeDocument.Include"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="main.web.BizboxAMessage"%>
<%
 /**
  * @Class Name : defaultUrl.jsp
  * @Description : 기본
  * @Modification Information
  *
  */ 
%>

 <!-- 지출결의서 2.0 연동 -->
<script type="text/javascript" src='<c:url value="/js/resalphag20/resAlphaG20.js"></c:url>'></script>

<style type="text/css">
</style>

<script type="text/javascript">

$(function(){
	init();
});

function init(){
	$.ajax({
        type: "POST"
	    , dataType: "json"
	    , url: getContextPath()+ "/resAlphaG20/getInterfaceIds"
        , data: {}
	    , success: function (obj) {
	    	$.each(obj.interfaceIds, function(){
		    	$("#btnArea").append('<button onclick="popOpen(\'' + this.interface_id + '\');">' + this.interface_id + '</button>');
	    	});
	    }
	    , error: function(obj){
	    }
    });
}

function popOpen(interfaceId){
	resAlphaG20.openResPop(interfaceId, "", "");
}

</script>
<div>
	<div class="btn_div mt20">
		<div class="left_div">
			<p class="tit_p fl mt5 mb0">
				지결 2.0 연동 테스트
			</p>
		</div>
	</div>
   	<div class="com_ta2 hover_no mt15" >
		<div class="left_div">
			<div class="controll_btn p0 ml10 btn_left" id="btnArea" style="text-align: left">
			</div>
		</div>
   		
    </div>  
</div>
