<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>

<div class="side_wrap ea"> 
				<h2 class="sub_nav_title"></h2> 
				<div class="nav_div">
					<ul id="sub_nav" style="border-width:0">관리</ul>
				</div>
				
				<script>
					$("#sub_nav").kendoTreeView({
						/*전자결재*/
						dataSource:[
							{ 
								id:10,
								name: "소스 패치 관리", 
								items: [
									{id:11,name: "모듈별 소스 정보", urlPath:"../patch/moduleSourceList"},
									{id:12,name: "모듈별 DB Script 정보", urlPath:"../patch/moduleWarList2"}
								]	
							}, 
							{
								id:20,
								name: "고객 패치 관리", 
								items: [
									{id:21,name: "고객사 모듀별 버전 정보", urlPath:"../patch/moduleWarList3"}
								]	
							},
							{
								id:30,
								name: "로그인 관리", 
								items: [
									{id:31,name: "로그인 이력", urlPath:"../patch/moduleWarList4"}
								]	
							}
						],//dataSource
						select:function(e){
							var treeview = $("#sub_nav").data("kendoTreeView");//트리데이터 가져오기
							//선택활성
							treeview.expand(e.node);
							
							//이전선택 초기화
							//$(".k-in").removeClass('k-state-selected');
							
							menu.onSelect(e);
							
							
						},
						dataTextField: ["name"],
				        dataValueField: ["id"]
					});
					var treeview = $("#sub_nav").data("kendoTreeView");//트리데이터 가져오기
					treeview.collapse(".k-item");
				</script>	
			</div>