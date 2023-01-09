<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="c"       uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring"  uri="http://www.springframework.org/tags"  %>

<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title>농림수산식품교육문화정보원</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <script type="text/javascript">
    /* tiles : contents_tiles.jsp */ 
    </script>

	<style type="text/css">
	.k-header .k-link {
	   text-align: center;
	}
	
	.k-grid-content>table>tbody>tr {
	   text-align: center;
	}
	
	.k-grid th.k-header, .k-grid-header {
	   background: #F0F6FD;
	}
	</style>

	<!--Kendo ui css-->
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.common-custom.min.css' />">
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.dataviz.min.css' />">
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.mobile.all.min.css' />">
    
    <!-- Theme -->
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.silver.min.css' />" />
	
	<!-- 파비콘 -->
<%--     <link rel="icon" href="<c:url value='/Images/ico/favicon.ico'/>" type="image/x-ico" /> --%>
<%--     <link rel="shortcut icon" href="<c:url value='/Images/ico/favicon.ico'/>" type="image/x-ico" /> --%>
	
	<!--css-->
<%--     <link rel="stylesheet" type="text/css" href="<c:url value='/css/common.css' />">  --%>
	
	<!--Kendo UI customize css-->
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/reKendo.css' />">
    
    <!--css-->
<!--     <link rel="stylesheet" type="text/css" href="/js/Scripts/jqueryui/jquery-ui.css"/> -->
    
    <!--jsTree css-->
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/jstree/style.min.css' />">
    
   
<%--     <script type="text/javascript" src="<c:url value='/js/Scripts/jquery-1.9.1.min.js'/>"></script>      --%>
<%--     <script type="text/javascript" src="<c:url value='/js/jquery.form.js'/>"></script><!-- 요청 --> --%>
    
<%--     <script type="text/javascript" src="<c:url value='/js/neos/common.js' />"></script> --%>
<%--     <script type="text/javascript" src="<c:url value='/js/neos/common.kendo.js' />"></script> --%>

    <script type="text/javascript" src="<c:url value='/js/neos/neos_common.js' />"></script>
    <script type="text/javascript" src="<c:url value='/js/neos/NeosUtil.js' />"></script>
<%--     <script type="text/javascript" src="<c:url value='/js/neos/NeosCodeUtil.js' />"></script><!-- 요청 --> --%>

    
    <!-- 메인 js -->
<%--     <script type="text/javascript" src="<c:url value='/js/Scripts/jquery.alsEN-1.0.min.js' />"></script> --%>
<%-- 	<script type="text/javascript" src="<c:url value='/js/Scripts/jquery.bxslider.min.js' />"></script> --%>
	
    <!--js-->
<%--     <script type="text/javascript" src="<c:url value='/js/Scripts/common.js' />"></script> --%>
    
    <!--js-->
<!-- 	<script type="text/javascript" src="/js/Scripts/jqueryui/jquery-ui.min.js"></script>  -->
	
	<!--jsTree js-->
<!-- 	<script type="text/javascript" src="/js/Scripts/jstree/jstree.min.js"></script> -->

	<link rel="stylesheet" type="text/css" href="<c:url value='/js/Scripts/jqueryui/jquery-ui.css'/>"/>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/common.css'/>"/>
	
	<!--jsTree css-->
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/jstree/style.min.css'/>">

    <!--js-->
	<script type="text/javascript" src="<c:url value='/js/Scripts/jquery-1.9.1.min.js'/>"></script>
	<script type="text/javascript" src="<c:url value='/js/Scripts/jqueryui/jquery-ui.min.js'/>"></script> 
	<script type="text/javascript" src="<c:url value='/js/Scripts/common.js'/>"></script>
	<script type="text/javascript" src="<c:url value='/js/moment.min.js'/>"></script>

	<!--jsTree js-->
	<script type="text/javascript" src="<c:url value='/js/Scripts/jstree/jstree.min.js'/>"></script>
	<script type="text/javascript" src="<c:url value='/js/kendoui/jquery.min.js'/>"></script>
	<script type="text/javascript" src="<c:url value='/js/kendoui/kendo.all.min.js'/>"></script>
	<script type="text/javascript" src="<c:url value='/js/kendoui/cultures/kendo.culture.ko-KR.min.js'/>"></script>
	<script type="text/javascript" src='<c:url value="/js/common/commUtil.js"></c:url>'></script>
	<script type="text/javascript" src='<c:url value="/js/common/organChart.js"></c:url>'></script>
    <script>
    
    var g_hostName = window.location.hostname;
    
    function fn_docViewPop(dikeyCode){
		var params = {};
	    var url = "http://10.10.10.82/ea/edoc/eapproval/docCommonDraftView.do?multiViewYN=Y&diSeqNum=undefined&miSeqNum=undefined&diKeyCode="+dikeyCode;
		window.open(url,"viewer","width=965, height=950, resizable=yes , scrollbars=no, status=no, top=50, left=50","newWindow");						
	}
    
    moment.lang('ko', {
	    weekdays: ["일요일","월요일","화요일","수요일","목요일","금요일","토요일"],
	    weekdaysShort: ["일","월","화","수","목","금","토"],
	});
    
	// Prevent the backspace key from navigating back.
	$(document).unbind('keydown').bind('keydown', function (event) {
	    if (event.keyCode === 8) {
	        var doPrevent = true;
	        var types = ["text", "password", "file", "search", "email", "number", "date", "color", "datetime", "datetime-local", "month", "range", "search", "tel", "time", "url", "week"];
	        var d = $(event.srcElement || event.target);
	        var disabled = d.prop("readonly") || d.prop("disabled");
	        if (!disabled) {
	            if (d[0].isContentEditable) {
	                doPrevent = false;
	            } else if (d.is("input")) {
	                var type = d.attr("type");
	                if (type) {
	                    type = type.toLowerCase();
	                }
	                if (types.indexOf(type) > -1) {
	                    doPrevent = false;
	                }
	            } else if (d.is("textarea")) {
	                doPrevent = false;
	            }
	        }
	        if (doPrevent) {
	            event.preventDefault();
	            return false;
	        }
	    }
	});
    
    $(document).ready(function(){
    	$(".k-combobox .k-input").addClass('kendoComboBox');
		$("#menuHistory li:last-child").addClass("on");
		
		// redirect msg 처리
		<c:if test="${not empty msg}">
			alert('${msg}');
		</c:if>
		
		$('.datePickerInput').kendoDatePicker({
		    culture : "ko-KR",
		    format : "yyyy-MM-dd",
		});
		
		$(".datePickerInput").attr("readonly", true);
				
		$('.inputNumber').bind({
			keydown : function(event) {
				var keycode = event.keyCode;

				if (validMoneyKeyCode(keycode)) {
					return true;
				} else {
					return false;
				}
				event.preventDefault();
			},
			
			keyup : function(event) {
				var keycode = event.keyCode;

				if (validMoneyKeyCode(keycode)) {
					$(this).val( getNumtoCom( getComtoNum( $(this).val() ) ) );
					return true;
				} else {
					return false;
				}
				event.preventDefault();
			}
			
		})
    	
    });
    
        function init(){}
        
        _g_contextPath_ = "${pageContext.request.contextPath}";
        _local_Url_ = "${pageContext.request.scheme}"+"://"+"${pageContext.request.serverName}"+":"+"${pageContext.request.serverPort}";
        
        validMoneyKeyCode = function(keycode){
            // 숫자패드 마이너스키 추가 keycode == 109 2013.724
        	if(keycode == 8 || keycode == 13 || keycode == 9 | keycode == 16
        	|| (keycode >= 48 && keycode <= 57) || (keycode >= 96 && keycode <= 105)
        	|| keycode == 189 || keycode == 109){
        		return true;
        	} 
        	else {
        		return false;
        	}
        };
        
        
        <%--hwp 데이터 매핑 s--%>
        function inputAllData(){
         	var jsonParam = JSON.parse(allParam);

         	for (var key in jsonParam) {
         		if(typeof jsonParam[key] == 'string'){
         			console.log(key + " : " + jsonParam[key]);
         			_hwpPutText(key, jsonParam[key], _pHwpCtrl );
         		}
         	}
         }
         
        function _hwpPutText(fieldName, val) {
         	if(_pHwpCtrl.FieldExist(fieldName )) {
         		_pHwpCtrl.MoveToField(fieldName, true, true, false);
         		_pHwpCtrl.InsertBackgroundPicture("SelectedCellDelete", 0, 0, 0, 0, 0, 0, 0);
         		_pHwpCtrl.PutFieldText(fieldName, ncCom_EmptyToString(val, ""));
         	}	
        }
        
        function _hwpPutImage(fieldName, val) {
         	if(_pHwpCtrl.FieldExist(fieldName)) {
         		_pHwpCtrl.MoveToField(fieldName, true, true, false);
         		_pHwpCtrl.Run("SelectAll");
         		_pHwpCtrl.Run("Delete");
        		_pHwpCtrl.PutFieldText(fieldName, " ");
        		_pHwpCtrl.InsertBackgroundPicture("SelectedCell", val, 1, 6, 0, 0, 0, 0);
         	}	
        }
        
         function ncCom_EmptyToString(argStr,conString){
         	if ( conString == undefined )  conString = "" ;
         	if(ncCom_Empty(argStr+"") || argStr == "null" || argStr == null ) {

         	}else{
         		conString = argStr ;
         	}
         	return conString ;
         }
         /**
          *이름 : ncCom_Empty()
          *설명 : 공백여부체크한다
          *인자 : 체크할 문자
          *리턴 : true ,false
         */
        function ncCom_Empty(argStr){
        	if (!argStr) return true;
        	if (argStr.length == 0) return true;
        	if(typeof(argStr) == "undefined")  return true ;
        	if(argStr == "undefined")  return true ;	
        	if(argStr == "null") return true ;
        	
        	for (var i = 0; i<argStr.length; i++) {
         		if ( (" " == argStr.charAt(i)) || ("　" == argStr.charAt(i)) )  {	}
        		else return false;
        	}
        	return true;
        }
          <%--hwp 데이터 매핑 e--%>
        
        function getNumtoCom(str){
        	
        	return Number(str).toLocaleString().split(".")[0];
        }
        
		function getComtoNum(str){
        	
        	return Number(str != null ? str.replace(/,/gi, '') : '');
        }
        
        
    </script>


</head>

<body>
<div class="sub_wrap">
<div class="sub_contents">
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
					
					var top = parent.getTopMenu();
					
					var hstHtml = '<li><a href="#n"><img src="'+_g_contextPath_+'/Images/ico/ico_home01.png" alt="홈">&nbsp;</a></li>';
					hstHtml += '<li><a href="#n">'+top.name+'&nbsp;</a></li>';  
					 
					var leftList = parent.getLeftMenuList();
					 
					if (leftList != null && leftList.length > 0) {
						for(var i = leftList.length-1; i >= 0; i--) {
							hstHtml += '<li><a href="#n">'+leftList[i].name+'&nbsp;</a></li>';
						} 
						
						$(".title_div").html('<h4>'+leftList[0].name+'&nbsp;</h4>');
					} else {
						$(".title_div").html('<h4>'+top.name+'&nbsp;</h4>');
					}
					
					$("#menuHistory").html(hstHtml);
					
				} catch (exception) {
				}
				
			   
			</script>
<!-- 		</div> -->
		
		<tiles:insertAttribute name="body" />
	
	</div><!-- //iframe wrap -->
</div>
</div>

</body>
</html>