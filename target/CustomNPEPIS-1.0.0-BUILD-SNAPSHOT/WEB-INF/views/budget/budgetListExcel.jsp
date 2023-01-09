<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>

<%
 /** 
  * @Class Name : budgetList.jsp
  * @Description : 예실대비
  * @Modification Information
  * @
  * @  수정일                 수정자             수정내용
  * @ ----------      --------    ---------------------------
  * @ 2018.05.24      이철중             최초 생성
  *
  * @author 이철중
  * @since 2018.05.24
  * @version 1.0
  * @see
  *
  */
%>

<html>
<head>
</head>
<body>
	<table>
		<tr>
			<th colspan="2">회계단위</td>
			<th colspan="2">프로젝트</td>
			<th colspan="2">하위사업</td>
			<th colspan="3">예산과목</td>
			<th>부서</td>
			<th rowspan="2">편성금액</td>
			<th rowspan="2">조정금액</td>
			<th rowspan="2">합계</td>
		</tr>
		<tr>
			<th>코드</td>
			<th>명</td>
			<th>코드</td>
			<th>명</td>
			<th>코드</td>
			<th>명</td>
			<th>코드</td>
			<th>관</td>
			<th>항</td>
		</tr>
	<c:forEach var="mainList" items="${mainList}" varStatus="mainStatus">
		<tr>
			<td>${mainList.DIV_CD}</td>
			<td>${mainList.DIV_NM}</td>
			<td>${mainList.MGT_CD}</td>
			<td>${mainList.MGT_NM}</td>
			<td>${mainList.BOTTOM_CD}</td>
			<td>${mainList.BOTTOM_NM}</td>
			<td>${mainList.BGT_CD}</td>
			<td>${mainList.BGT_NM1}</td>
			<td>${mainList.BGT_NM}</td>
			<td>${mainList.deptNm}</td>
			<td><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList.BGT_AM1}" /></td>
			<td><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList.BGT_AM2}" /></td>
			<td><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList.BGT_AM1 + mainList.BGT_AM2}" /></td>
		</tr>
	</c:forEach>
      </table>
</body>
</html>