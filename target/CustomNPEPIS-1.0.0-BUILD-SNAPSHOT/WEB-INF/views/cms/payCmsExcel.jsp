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
			<th>은행</td>
			<th>계좌번호</td>
			<th>금액</td>
			<th>성명</td>
			<th>비고</td>
		</tr>
		
	<c:forEach var="mainList" items="${mainList}" varStatus="mainStatus">
		<tr>
			<td>${mainList.PYTB_NM}</td>
			<td>${mainList.ACCT_NO}</td>
			<td>${mainList.PAY_AMT}</td>
			<td>${mainList.EMPLOYEENM}</td>
			<td>${mainList.REMARK}</td>
		</tr>
	</c:forEach>
      </table>
</body>
</html>