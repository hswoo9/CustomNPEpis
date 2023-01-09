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
<style type="text/css">
</style>

<script type="text/javascript">

var c_dikeycode = "${c_dikeycode}";

$(function(){
	init();
});

function init(){
	$.ajax({
        type: "POST"
	    , dataType: "json"
	    , url: getContextPath()+ "/resAlphaG20/saveToAttachInfoAjax"
        , data: { c_dikeycode : c_dikeycode }
	    , success: function (obj) {
	    	
	    }
	    , error: function(obj){
	    }
    });
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
