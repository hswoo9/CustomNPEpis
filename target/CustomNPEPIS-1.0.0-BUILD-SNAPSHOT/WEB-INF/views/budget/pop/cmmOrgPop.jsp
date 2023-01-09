<%@page import="java.net.URLEncoder"%>

<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>

<script src="${pageContext.request.contextPath}/js/kendoui/jquery.min.js"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css"> 

<script>
	$(document).ready(function() {
		$('#form').attr('action', '/gw/systemx/orgChart.do');
		document.form.submit();
	});

	function callbackSelectOrg(data) {
		var callback = data.callback;
		
		try {
			if (callback) {
				eval('opener.' + callback)(data);
			}
			else {
				opener.callbackSelectUser(data);
			}
		}
		catch(exception) {
		}
		
		window.close(); 
	}
	
	function fnResizeForm11() {
		var selectMode = form.selectMode.value;
		alert(selectMode);
		
		if (selectMode.indexOf('o') > -1) {
			$('#div_org_tree_').width(315);
			$('.pop_wrap').width(349);
			$('.jstreeSet').height(390);
		}
		
		var strWidth = $('.pop_wrap').outerWidth() + (window.outerWidth - window.innerWidth);
		var strHeight = $('.pop_wrap').outerHeight() + (window.outerHeight - window.innerHeight);
		
		try {
			var childWindow = window.parent;
			childWindow.resizeTo(strWidth, strHeight);	
		}
		catch(exception) {
			console.log('window resizing cat not run dev mode.');
		}
	}
</script>

<%
	String selectedList     = request.getParameter("selectedList")     + "";
	String selectedAddrList = request.getParameter("selectedAddrList") + "";
	String selectedOrgList  = request.getParameter("selectedOrgList")  + "";
	String duplicateOrgList = request.getParameter("duplicateOrgList") + "";
	
	selectedAddrList        = URLEncoder.encode(selectedAddrList, "UTF-8");
	selectedList            = URLEncoder.encode(selectedList,     "UTF-8");
	selectedOrgList         = URLEncoder.encode(selectedOrgList,  "UTF-8");
	duplicateOrgList        = URLEncoder.encode(duplicateOrgList, "UTF-8");
%>

<form id="form" name="form" target="_content" method="post" action="<%=request.getParameter("popUrlStr")%>">
	<input type="hidden" name="langCode"        width="500" value="<%=request.getParameter("langCode")%>"/>
	<input type="hidden" name="groupSeq"        width="500" value="<%=request.getParameter("groupSeq")%>" id="hid_form_groupSeq"/>
	<input type="hidden" name="compSeq"         width="500" value="<%=request.getParameter("compSeq")%>"/>	
	<input type="hidden" name="deptSeq"         width="500" value="<%=request.getParameter("deptSeq")%>"/>
	<input type="hidden" name="empSeq"          width="500" value="<%=request.getParameter("empSeq")%>"/>
	
	<input type="hidden" name="selectMode"      width="500" value="<%=request.getParameter("selectMode")%>"/>
	<input type="hidden" name="selectItem"      width="500" value="<%=request.getParameter("selectItem")%>"/>
	<input type="hidden" name="selectedItems"   width="500" value="<%=request.getParameter("selectedItems")%>"/>
	<input type="hidden" name="compFilter"      width="500" value="<%=request.getParameter("compFilter")%>"/>
	
	<input type="hidden" name="nodeChangeEvent" width="500" value="<%=request.getParameter("nodeChangeEvent")%>"/>
	<input type="hidden" name="callbackParam"   width="500" value="<%=request.getParameter("callbackParam")%>"/>
	<input type="hidden" name="callback"        width="500" value="<%=request.getParameter("callback")%>"/>
	<input type="hidden" name="callbackUrl"     width="500" value="<%=request.getParameter("callbackUrl")%>" id ="callbackUrl"/>
	<input type="hidden" name="initMode"        width="500" value="<%=request.getParameter("initMode")%>"/>
	
	<input type="hidden" name="noUseDefaultNodeInfo" width="500" value="<%=request.getParameter("noUseDefaultNodeInfo")%>"/>
	<input type="hidden" name="includeDeptCode"      width="500" value="<%=request.getParameter("includeDeptCode")%>"/>
</form>

<iframe id="_content" name="_content" frameborder="0" scrolling="no" width="100%" height="100%"></iframe>

