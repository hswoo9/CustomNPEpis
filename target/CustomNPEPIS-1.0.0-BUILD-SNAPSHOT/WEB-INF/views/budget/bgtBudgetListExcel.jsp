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
            	   <th colspan="3" rowspan="2">예산과목</td>
            	   <th colspan="3" rowspan="2">합계</td>
		<c:forEach var="pjtInfoList" items="${pjtInfoList}" varStatus="pjtInfoStatus">
			<th colspan="${pjtInfoList.totCnt * 3}">${pjtInfoList.pjtNm}</td>
		</c:forEach>
            </tr>
            <tr>
		<c:forEach var="pjtList" items="${pjtBtmList}" varStatus="pjtStatus">
			<th colspan="3">${pjtList.btmNm}</td>
		</c:forEach>
            </tr>
            <tr>
            	   <th>코드</th>
            	   <th>관</th>
            	   <th>항</th>
		<th>편성금액</th>
		<th>조정금액</th>
		<th>합계</th>
		<c:forEach var="pjtList" items="${pjtBtmList}" varStatus="pjtStatus">
			<th>편성금액</th>
			<th>조정금액</th>
			<th>합계</th>
		</c:forEach>
            </tr>
<c:forEach var="mainList" items="${mainList}" varStatus="mainStatus">
	<c:if test="${mainList.bgtCd == '000000'}">
             <tr>
             	   <td colspan="3"><b>${mainList.hBgtNm} 소계</b></td>
			<c:set var="fnamet1" value="${mainList.hBgtCd}_1" />
			<c:set var="fnamet2" value="${mainList.hBgtCd}_2" />
			<c:set var="fnamet3" value="${mainList.hBgtCd}_3" />
             	   
                 <td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList[fnamet1]}" /></td>
             	   <td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList[fnamet2]}" /></td>
             	   <td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList[fnamet3]}" /></td>
             	   
			<c:forEach var="pjtList" items="${pjtBtmList}" varStatus="pjtStatus">
				<c:set var="fname1" value="${pjtList.pjtCd}_${pjtList.btmCd}_${mainList.hBgtCd}_1" />
				<c:set var="fname2" value="${pjtList.pjtCd}_${pjtList.btmCd}_${mainList.hBgtCd}_2" />
				<c:set var="fname3" value="${pjtList.pjtCd}_${pjtList.btmCd}_${mainList.hBgtCd}_3" />
				
				<td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList[fname1]}" /></td>
				<td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList[fname2]}" /></td>
				<td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList[fname3]}" /></td>
			</c:forEach>
             </tr>
          </c:if>
          <c:if test="${mainList.bgtCd != '000000' && mainList.bgtCd != '999999'}">
             <tr>
             	   <td class="text1">${mainList.bgtCd}</td>
             	   <td class="text1">${mainList.hBgtNm}</td>
             	   <td class="text2">${mainList.bgtNm}</td>
             	   
                 <td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList.totAmt1}" /></td>
             	   <td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList.totAmt2}" /></td>
             	   <td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList.totAmt3}" /></td>
             	   
			<c:forEach var="pjtList" items="${pjtBtmList}" varStatus="pjtStatus">
				<c:set var="fname1" value="${pjtList.pjtCd}_${pjtList.btmCd}_${mainList.bgtCd}_1" />
				<c:set var="fname2" value="${pjtList.pjtCd}_${pjtList.btmCd}_${mainList.bgtCd}_2" />
				<c:set var="fname3" value="${pjtList.pjtCd}_${pjtList.btmCd}_${mainList.bgtCd}_3" />
				
				<td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList[fname1]}" /></td>
				<td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList[fname2]}" /></td>
				<td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList[fname3]}" /></td>
			</c:forEach>
             </tr>
          </c:if>
	<c:if test="${mainList.bgtCd == '999999'}">
             <tr>
             	   <td colspan="3"><b>합계</b></td>
                 <td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList.totAmt1}" /></td>
             	   <td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList.totAmt2}" /></td>
             	   <td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList.totAmt3}" /></td>
             	   
			<c:forEach var="pjtList" items="${pjtBtmList}" varStatus="pjtStatus">
				<c:set var="fname1" value="${pjtList.pjtCd}_${pjtList.btmCd}_1" />
				<c:set var="fname2" value="${pjtList.pjtCd}_${pjtList.btmCd}_2" />
				<c:set var="fname3" value="${pjtList.pjtCd}_${pjtList.btmCd}_3" />
				
				<td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList[fname1]}" /></td>
				<td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList[fname2]}" /></td>
				<td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList[fname3]}" /></td>
			</c:forEach>
             </tr>
          </c:if>
</c:forEach>
     </table>
</body>
</html>