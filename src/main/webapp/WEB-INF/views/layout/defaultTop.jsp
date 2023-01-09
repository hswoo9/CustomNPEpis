<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>

<!-- header_top_wrap -->
		<div class="header_top_wrap">
			<div class="header_top">
				<!-- logo -->
				<h1 class="logo">
					<a href="#n" title="더존 Bizbox">
						<img src="<c:url value='/resources/Images/temp/logo.png'/>" alt="" />
					</a>
				</h1>  
				<!-- global nav -->
				<ul class="nav"> 
					<li><a href="#n" class="nav1" onclick="" title="관리">관리</a></li> 
				</ul>
			</div>
		</div> 
 
<!-- header_sub_wrap -->
		<div class="header_sub_wrap">
			<div class="header_sub">
				<!-- user misc -->
				<div class="misc">
					<!-- 프로필 -->
					<div class="profile_wrap">
						<div class="bg_pic"></div> 
						<span class="divi_img">
							<!-- <img src="../../Images/temp/temp_pic.png" alt="" /> -->
							<!-- <img src="../../Images/bg/pic_Noimg.png" alt="" /> -->
						</span>
						<a href="#n" class="divi_txt">김서현 대리</a>
					</div>
				</div>
			</div> 
		</div>
	<!-- //End of Header -->