<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<html>
<head>
<title>Home</title>
<link rel="stylesheet"
	href="https://kendo.cdn.telerik.com/2018.1.117/styles/kendo.common-material.min.css" />
<link rel="stylesheet"
	href="https://kendo.cdn.telerik.com/2018.1.117/styles/kendo.material.min.css" />
<link rel="stylesheet"
	href="https://kendo.cdn.telerik.com/2018.1.117/styles/kendo.material.mobile.min.css" />
	<link rel='stylesheet prefetch' href='https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css'>
      <link rel="stylesheet" type="text/css" href="<c:url value='/css/style.css' />">
</head>
<style>
table {
	width: 1000px;
	border: 1px;
	border-style: solid;
}

table tr td {
	border: 1px;
	border-style: solid;
	height: 40px;
}

.k-header .k-link {
	text-align: center;
}

.k-grid-content>table>tbody>tr {
	text-align: center;
}
</style>
<body>
	<h1>농림수산식품교육문화정보원</h1>
	<p>화면 url</p>
	<table>
		<tr>
			<th>화면경로</th>
			<th>url(xxxx.jsp)</th>
		</tr>
        <tr>
            <td>시내출장 지출결의서 현황</td>
            <td><a href="${pageContext.request.contextPath}/bustrip/bustripInResDocView">bustripInResDocView</a></td>
        </tr>
        <tr>
            <td>시외출장 지출결의서 현황</td>
            <td><a href="${pageContext.request.contextPath}/bustrip/bustripOutResDocView">bustripOutResDocView</a></td>
        </tr>
		<tr>
			<td>리스트 조회 및 SMS 전송 </td>
			<td><a href="${pageContext.request.contextPath }/resAlphaG20/sendSmsMessage">sendSmsMessage.jsp</a></td>
		</tr>
		<tr>
			<td>카드 사용 내역 알람 설정</td>
			<td><a href="${pageContext.request.contextPath }/resAlphaG20/cardNotionSettingView">cardNotionSettingView.jsp</a></td>
		</tr>
		<tr>
			<td>세금계산서 사용 내역 현황</td>
			<td><a href="${pageContext.request.contextPath }/resAlphaG20/customEtaxList">customEtaxList.jsp</a></td>
		</tr>
		<tr>
			<td>커스텀 카드 사용 내역 현황</td>
			<td><a href="${pageContext.request.contextPath }/resAlphaG20/customCardList">customCardList.jsp</a></td>
		</tr>
		<tr>
			<td>증빙 다운로드 페이지</td>
			<td><a href="${pageContext.request.contextPath }/resAlphaG20/downloadFinalDocsView">downloadFinalDocsView.jsp</a></td>
		</tr>
		<tr>
			<td>PDF 솔루션 에러 조회 리스트</td>
			<td><a href="${pageContext.request.contextPath }/resAlphaG20/viewPdfErrorDocs">viewPdfErrorDocs.jsp</a></td>
		</tr>
		<tr>
			<td>사업예산 월별현황</td>
			<td><a href="${pageContext.request.contextPath }/budget/monthSaupBgt">monthSaupBgt.jsp</a></td>
		</tr>
		<tr>
			<td>예산마감신청</td>
			<td><a href="${pageContext.request.contextPath }/budget/finishApplyBgt">finishApplyBgt.jsp</a></td>
		</tr>
		<tr>
			<td>사업 예산 현황</td>
			<td><a href="${pageContext.request.contextPath }/budget/lookupSaupBgtStatus">lookupSaupBgtStatus.jsp</a></td>
		</tr>
		<tr>
			<td>프로젝트 이력조회</td>
			<td><a href="${pageContext.request.contextPath }/budget/lookupProjectRecord">lookupProjectRecord.jsp</a></td>
		</tr>
		<tr>
			<td>일계표</td>
			<td><a href="${pageContext.request.contextPath }/budget/dailySchedule">dailySchedule.jsp</a></td>
		</tr>
		<tr>
			<td>예산 기본계획 확정</td>
			<td><a href="${pageContext.request.contextPath }/budget/confirmBgtPlanPage">confirmBgtPlan.jsp</a></td>
		</tr>
		<tr>
			<td>예산 기본계획 신청</td>
			<td><a href="${pageContext.request.contextPath }/budget/applyBgtPlan">applyBgtPlan.jsp</a></td>
		</tr>
		<tr>
			<td>프로젝트별 예실대비 현황</td>
			<td><a href="${pageContext.request.contextPath }/budget/projectYesilDaebi">projectYesilDaebi.jsp</a></td>
		</tr>
		<tr>
			<td>신용카드 사용여부 롤백</td>
			<td><a href="/custExp/expend/np/admin/NpAdminCardReport2.do">NpAdminCardReport2.jsp</a></td>
		</tr>
		<tr>
			<td>사업별 예산실적 현황 (관리자)</td>
			<td><a href="${pageContext.request.contextPath }/budget/viewDeptBgt">viewDeptBgt.jsp</a></td>
		</tr>
		<tr>
			<td>사업별 예산실적 현황</td>
			<td><a href="${pageContext.request.contextPath }/budget/inputDeptBgt">inputDeptBgt.jsp</a></td>
		</tr>
		<tr>
			<td>예산 세부 내역 현황</td>
			<td><a href="${pageContext.request.contextPath }/budget/deptBgtStatus">deptBgtStatus.jsp</a></td>
		</tr>
		<tr>
			<td>예산 세부 내역 신청</td>
			<td><a href="${pageContext.request.contextPath }/budget/applyDeptBgt">applyDeptBgt.jsp</a></td>
		</tr>
		<tr>
			<td>상위 부서 설정</td>
			<td><a href="${pageContext.request.contextPath }/budget/highDeptSetting">highDeptSetting.jsp</a></td>
		</tr>
		<tr>
			<td>본부별 예실대비현황</td>
			<td><a href="${pageContext.request.contextPath }/budget/bonbuYesilDeabi">bonbuYesilDeabi.jsp</a></td>
		</tr>
		<tr>
			<td>본부 부서별 예실대비현황</td>
			<td><a href="${pageContext.request.contextPath }/budget/bonbuDeptYesilDaebiPopup">bonbuDeptYesilDaebiPopup.jsp</a></td>
		</tr>
		<tr>
			<td>부서 프로젝트별 예실대비현황</td>
			<td><a href="${pageContext.request.contextPath }/budget/bonbuProjectYesilDaebiPopup">bonbuProjectYesilDaebiPopup.jsp</a></td>
		</tr>
		<tr>
			<td>부서 예산과목별 예실대비현황</td>
			<td><a href="${pageContext.request.contextPath }/budget/bonbuBgtYesilDaebiPopup">bonbuBgtYesilDaebiPopup.jsp</a></td>
		</tr>
		<tr>
			<td>프로젝트 예산별 부서 세팅</td>
			<td><a href="${pageContext.request.contextPath }/budget/projectBgtDeptSetting">projectBgtDeptSetting.jsp</a></td>
		</tr>
		<tr>
			<td>예실대비</td>
			<td><a href="${pageContext.request.contextPath }/budget/projectPreparation">projectPreparation.jsp</a></td>
		</tr>
		<tr>
			<td>나의 지출결의서</td>
			<td><a href="${pageContext.request.contextPath }/budget/myExpenditureResolution">myExpenditureResolution.jsp</a></td>
		</tr>
		<tr>
			<td>지출결의서 현황</td>
			<td><a href="${pageContext.request.contextPath }/budget/expenditureResolutionStatus">expenditureResolutionStatus.jsp</a></td>
		</tr>
		<tr>
			<td>원인행위부</td>
			<td><a href="${pageContext.request.contextPath }/budget/causeActView">causeActView.jsp</a></td>
		</tr>
		<tr>
			<td>거래처원장</td>
			<td><a href="${pageContext.request.contextPath }/budget/customerLedger">customerLedger.jsp</a></td>
		</tr>
		<tr>
			<td>계정별원장</td>
			<td><a href="${pageContext.request.contextPath }/budget/accountLedger">accountLedger.jsp</a></td>
		</tr>
		<tr>
			<td>총계정원장</td>
			<td><a href="${pageContext.request.contextPath }/budget/generalAccountLedger">generalAccountLedger.jsp</a></td>
		</tr>
		<tr>
			<td>매입장</td>
			<td><a href="${pageContext.request.contextPath }/budget/purchaseLedger">purchaseLedger.jsp</a></td>
		</tr>
		<tr>
			<td>매출장</td>
			<td><a href="${pageContext.request.contextPath }/budget/salesLedger">salesLedgerList.jsp</a></td>
		</tr>
		<tr>
			<td>지출결의서 제출</td>
			<td><a href="${pageContext.request.contextPath }/budget/resDocSubmitList">resDocSubmitList.jsp</a></td>
		</tr>
		<tr>
			<td>지출결의서 제출(전체)</td>
			<td><a href="${pageContext.request.contextPath }/budget/resDocSubmitList">resDocSubmitList.jsp</a></td>
		</tr>
		<tr>
			<td>지출결의서 제출현황</td>
			<td><a href="${pageContext.request.contextPath }/budget/resDocSubmitAdminList">resDocSubmitAdminList.jsp</a></td>
		</tr>
		<tr>
			<td>지출결의서 제출현황(고지서)</td>
			<td><a href="${pageContext.request.contextPath }/budget/resDocSubmitAdminList2">resDocSubmitAdminList2.jsp</a></td>
		</tr>
		<tr>
			<td>전표연동</td>
			<td><a href="${pageContext.request.contextPath }/budget/adocuList">adocuList.jsp</a></td>
		</tr>
		<tr><th colspan="2">ENARA</th></tr>
		<tr>
			<td>전송제외 리스트</td>
			<td><a href="${pageContext.request.contextPath }/kukgoh/enaraExceptList">enaraExceptList.jsp</a></td>
		</tr>
		<tr>
			<td>공통코드 설정</td>
			<td><a href="${pageContext.request.contextPath }/commcode/commCodeView">commCodeView.jsp</a></td>
		</tr>
		<tr>
			<td>공통코드 설정(e나라)</td>
			<td><a href="${pageContext.request.contextPath }/kukgoh/commCodeView">kukgohCommCodeView.jsp</a></td>
		</tr>
		<tr>
			<td>인터페이스 수동 저장</td>
			<td><a href="${pageContext.request.contextPath }/kukgoh/saveInterfacePage">saveInterfacePage.jsp</a></td>
		</tr>
		<tr>
			<td>비목세목 예산과정 설정</td>
			<td><a href="${pageContext.request.contextPath }/kukgoh/budgetConfigView">budgetConfigView.jsp</a></td>
		</tr>
		<tr>
			<td>사업 프로젝트 설정</td>
			<td><a href="${pageContext.request.contextPath }/kukgoh/projectConfigView2">projectConfigView.jsp</a></td>
		</tr>
		<tr>
			<td>지출결의서 집행 전송</td>
			<td><a href="${pageContext.request.contextPath }/kukgoh/insertSpendingResolution">insertSpendingResolution.jsp</a></td>
		</tr>
		<tr>
			<td>지출결의서 New 집행 전송 - 일괄</td>
			<td><a href="${pageContext.request.contextPath }/kukgoh/sendResolution">sendResolution.jsp</a></td>
		</tr>
		<tr>
			<td>세금계산서 일괄 전송</td>
			<td><a href="${pageContext.request.contextPath }/kukgoh/submitInvoice">submitInvoice.jsp</a></td>
		</tr>
		<tr>
			<td>지출결의서 전송 현황(관리자)</td>
			<td><a href="${pageContext.request.contextPath }/kukgoh/admResolutionView">admResolutionView.jsp</a></td>
		</tr>
		<tr><th colspan="2">품의내역 변경</th></tr>
		<tr>
			<td>품의내역 변경</td>
			<td><a href="<c:url value="/consDocMng/consDocMng"/>");">consDocMng.jsp</a></td>
		</tr>
		<tr><th colspan="2">지출결의서 연동</th></tr>
		<tr>
			<td>지출결의서 연동 테스트</td>
			<td><a href="<c:url value="/resAlphaG20/resAlphaG20Test"/>");">resAlphaG20Test.jsp</a></td>
		</tr>
		<tr><th colspan="2">구매의뢰</th></tr>
		<tr>
			<td>구매의뢰리스트</td>
			<td><a href="<c:url value="/Ac/G20/Ex/purcReqFormList.do"/>");">purcReqFormList.jsp</a></td>
		</tr>
		<tr>
			<td>구매의뢰조회_임시저장</td>
			<td><a href="<c:url value='/Ac/G20/Ex/purcReqListTemp.do'/>">purcReqList.jsp</a></td>
		</tr>
		<tr>
			<td>구매의뢰조회</td>
			<td><a href="<c:url value='/Ac/G20/Ex/purcReqList.do'/>">purcReqList.jsp</a></td>
		</tr>
		<tr>
			<td>구매의뢰기술협상</td>
			<td><a href="<c:url value='/Ac/G20/Ex/purcBiddingNegoList.do'/>">purcBiddingNegoList.jsp</a></td>
		</tr>
		<tr>
			<td>구매의뢰접수</td>
			<td><a href="<c:url value='/Ac/G20/Ex/purcReqListMng.do'/>">purcReqList.jsp</a></td>
		</tr>
		<tr>
			<td>구매계약입찰</td>
			<td><a href="<c:url value='/Ac/G20/Ex/purcBiddingList.do'/>">purcBiddingList.jsp</a></td>
		</tr>
		<tr>
			<td>구매계약체결보고</td>
			<td><a href="<c:url value='/Ac/G20/Ex/purcContList.do'/>">purcContList.jsp</a></td>
		</tr>
		<tr>
			<td>구매계약체결</td>
			<td><a href="<c:url value='/Ac/G20/Ex/purcContStateList.do'/>">purcContStateList.jsp</a></td>
		</tr>
		<tr>
			<td>계약체결현황_의뢰자</td>
			<td><a href="<c:url value='/Ac/G20/Ex/purcContConcStateList.do'/>">purcContConcStateList.jsp</a></td>
		</tr>
		<tr>
			<td>계약체결현황_구매담당자</td>
			<td><a href="<c:url value='/Ac/G20/Ex/purcContConcStateList.do?mng=Y'/>">purcContConcStateList.jsp</a></td>
		</tr>
		<tr>
			<td>계약체결현황_회계담당자</td>
			<td><a href="<c:url value='/Ac/G20/Ex/purcContConcStateList.do?mng=Y&ac=Y'/>">purcContConcStateList.jsp</a></td>
		</tr>
		<tr>
			<td>구매계약현황</td>
			<td><a href="<c:url value='/Ac/G20/Ex/contractList.do'/>">contractList.jsp</a></td>
		</tr>
		<tr>
			<td>구매물품리스트</td>
			<td><a href="<c:url value='/Ac/G20/Ex/purcItemList.do'/>">purcItemList.jsp</a></td>
		</tr>
		<tr>
			<td>제안평가업체관리</td>
			<td><a href="<c:url value='/Ac/G20/Ex/proposalEvaluationMng.do'/>">proposalEvaluationMng.jsp</a></td>
		</tr>
		<tr><th colspan="2">출장</th></tr>
		<tr>
			<td>출장 데이터 원복</td>
			<td><a href="${pageContext.request.contextPath }/busTrip/returnTrip">returnTrip.jsp</a></td>
		</tr>
		<tr>
			<td>업무추친비 조회(전체)</td>
			<td><a href="${pageContext.request.contextPath }/busTrip/workFeeList">workFeeList.jsp</a></td>
		</tr>
		<tr>
			<td>시외출장 정보 조회(전체)</td>
			<td><a href="${pageContext.request.contextPath }/busTrip/tripList1">tripList1.jsp</a></td>
		</tr>
		<tr>
			<td>시내출장 정보 조회(전체)</td>
			<td><a href="${pageContext.request.contextPath }/busTrip/tripList2">tripList2.jsp</a></td>
		</tr>
		<tr>
			<td>오피넷 조회</td>
			<td><a href="${pageContext.request.contextPath }/busTrip/opnetList">opnetList.jsp</a></td>
		</tr>
		<tr>
			<td>알림테스트</td>
			<td><a href="${pageContext.request.contextPath }/busTrip/almTest">almTest.jsp</a></td>
		</tr>
		<tr>
		<tr>
			<td>직급별 출장 여비 등록</td>
			<td><a href="${pageContext.request.contextPath }/busTrip/gradeCostList">gradeCostList.jsp</a></td>
		</tr>
		<tr>
			<td>관내출장 여비 설정</td>
			<td><a href="${pageContext.request.contextPath }/busTrip/oilAndCityCostList">oilAndCityCostList.jsp</a></td>
		</tr>
		<tr>
			<td>관내출장</td>
			<td><a href="${pageContext.request.contextPath }/busTrip/withinBusTrip">withinBusTrip.jsp</a></td>
		</tr>
		<tr>
			<td>관외출장</td>
			<td><a href="${pageContext.request.contextPath }/busTrip/outSideBusTrip">outSideBusTrip.jsp</a></td>
		</tr>
		<tr>
			<td>출장신청리스트</td>
			<td><a href="${pageContext.request.contextPath }/bsrp/bsrpReqstList">bsrpReqstList.jsp</a></td>
		</tr>
		<tr>
			<td>출장내역서</td>
			<td><a href="${pageContext.request.contextPath }/bsrp/bsrpStatementList">bsrpStatementList.jsp</a></td>
		</tr>
		<tr>
			<td>출장내역서 관리자</td>
			<td><a href="${pageContext.request.contextPath }/bsrp/bsrpStatementList?mng=Y">bsrpStatementList.jsp</a></td>
		</tr>
		<tr>
			<td>출장결과보고 반송</td>
			<td><a href="${pageContext.request.contextPath }/bsrp/bsrpReturnList">bsrpReturnList.jsp</a></td>
		</tr>
		<tr>
			<td>출장신청서 환원</td>
			<td><a href="${pageContext.request.contextPath }/bsrp/bsrpReturnConferList">bsrpReturnConferList.jsp</a></td>
		</tr>
		<tr>
			<td>관외출장신청</td>
			<td><a href="${pageContext.request.contextPath }/bsrp/bsrpReqstView">bsrpReqstView.jsp</a></td>
		</tr>
		<tr>
			<td>해외출장신청</td>
			<td><a href="${pageContext.request.contextPath }/bsrp/bsrpReqstOSView">bsrpReqstOSView.jsp</a></td>
		</tr>
		<tr>
			<td>관내 여비 사용자</td>
			<td><a href="${pageContext.request.contextPath }/bsrp/whthrcTrvctList">whthrcTrvctList.jsp</a></td>
		</tr>
		<tr>
			<td>관내 여비 승인자</td>
			<td><a href="${pageContext.request.contextPath }/bsrp/whthrcTrvctAppList">whthrcTrvctAppList.jsp</a></td>
		</tr>
		<tr>
			<td>관내 여비 관리자</td>
			<td><a href="${pageContext.request.contextPath }/bsrp/whthrcTrvctAdminList">whthrcTrvctAdminList.jsp</a></td>
		</tr>
		<tr>
			<td>관내출장 리스트</td>
			<td><a href="${pageContext.request.contextPath }/bsrp/whthrcTrvctPjtList">whthrcTrvctPjtList.jsp</a></td>
		</tr>
		<tr>
			<td>출장관리 교통비기준정보</td>
			<td><a href="${pageContext.request.contextPath }/bsrp/bsrpAdminList">bsrpAdminList.jsp</a></td>
		</tr>
		<tr>
			<td>출장관리 직급별 출장여비등록</td>
			<td><a href="${pageContext.request.contextPath }/bsrp/bsrpAdminPositionList">bsrpAdminPositionList.jsp</a></td>
		</tr>
		<tr>
			<td>항공마일리지 리스트</td>
			<td><a href="${pageContext.request.contextPath }/bsrp/bsrpMileageList">bsrpMileageList.jsp</a></td>
		</tr>
		
		<tr><th colspan="2">제안평가</th></tr>
		
		<tr>
			<td>제안평가 보기</td>
			<td><a href="${pageContext.request.contextPath }/eval/evaluationProposalViewDetail">evaluationProposalViewDetail.jsp</a></td>
		</tr>
		<tr>
			<td>구성요청서 등록</td>
			<td><a href="${pageContext.request.contextPath }/eval/evaluationProposalConfigurationView">evaluationProposalConfigurationView.jsp</a></td>
		</tr>
		<tr>
			<td>제안평가 등록</td>
			<td><a href="${pageContext.request.contextPath }/eval/evaluationProposalEnroll">evaluationProposalEnroll.jsp</a></td>
		</tr>
		<tr>
			<td>제안평가 목록</td>
			<td><a href="${pageContext.request.contextPath }/eval/evaluationProposalList">evaluationProposalList.jsp</a></td>
		</tr>
		<tr>
			<td>제안평가 평가위원 생성</td>
			<td><a href="${pageContext.request.contextPath }/eval/evaluationProposalCommissioner">evaluationProposalCommissioner.jsp</a></td>
		</tr>
		
		<tr>
			<td>제안평가 ID발급</td>
			<td><a href="${pageContext.request.contextPath }/eval/evaluationProposalIDIssue">evaluationProposalIDIssue.jsp</a></td>
		</tr>
		<tr>
			<td>제안평가 평가수당</td>
			<td><a href="${pageContext.request.contextPath }/eval/evaluationProposalExtraPay">evaluationProposalExtraPay.jsp</a></td>
		</tr>
		<tr>
			<td>제안평가 결의</td>
			<td><a href="${pageContext.request.contextPath }/eval/evalAnList">evalAnList.jsp</a></td>
		</tr>
		
		<tr>
			<td>평가위원 아이디생성</td>
			<td><a href="${pageContext.request.contextPath }/eval/evaluationIdCrtView">evaluationIdCrtView.jsp</a></td>
		</tr>
		<tr>
			<td>평가위원 조회</td>
			<td><a href="${pageContext.request.contextPath }/eval/evaluationCommitteeList">evaluationCommitteeList.jsp</a></td>
		</tr>
		<tr>
			<td>신규업체 등록</td>
			<td><a href="${pageContext.request.contextPath }/eval/evalCompanyList">evalCompanyList.jsp</a></td>
		</tr>
		
		<tr><th colspan="2">제안평가</th></tr>
		
		<tr>
			<td>급여명세서</td>
			<td><a href="${pageContext.request.contextPath }/salary/salaryViewDetail">salaryViewDetail.jsp</a></td>
		</tr>
		
		
	</table>
	
	<form action="${pageContext.request.contextPath }/kukgoh/resolutionSubmitPage" method="post" name="form1">
		<input type="text" name="test" value="test" />
	</form>

	<input type="file" id="fileUp1">
	<input type="text" id="fileNm1">
	<button type="button" onclick="up();">전송</button>
	<button type="button" onclick="down();">다운로드</button>
	

	<script type="text/javascript">
	
		function goResolutionSubmitPage() {
			
			document.form1.submit();
		}
	
	
		//팝업
		function openWindow2(url,  windowName, width, height, strScroll, strResize ){
	
			var pop = "" ;
			windowX = Math.ceil( (window.screen.width  - width) / 2 );
			windowY = Math.ceil( (window.screen.height - height) / 2 );
			if(strResize == undefined || strResize == '') {
				strResize = 0 ;
			}
			pop = window.open(url, windowName, "width=" + width + ", height=" + height + ", top="+ windowY +", left="+ windowX +", scrollbars="+ strScroll+", resizable="+ strResize);
			try {pop.focus(); } catch(e){}
			//return pop;
		}
	
		//파일 업로드
		function up() {
			debugger
			//1.폼 만들기
			//2.파일추가하기
			//3.기타 파라미터 추가하기
			var formData = new FormData();
			formData.append('file1', $('#fileUp1')[0].files[0]);

			$.ajax({
				url : "/CustomNPTpf/common/ctFileUpLoad",
				data : formData,
				type : 'POST',
				async : false,
				processData : false,
				contentType : false,
				success : function(result) {

				}
			});

		}

		//파일 다운로드 
		function down() {

			ctFileDownLoad(
					'2017%2F12%2F11%2FNzUxODcxMTcxMjA4X%2Bq3uOujueybqOyWtCDqsJzrsJzqtIDroKgg7JqU7LKt7IKs7ZWtIOygleumrC5od3A%3D',
					$('#fileNm1').val());

		}
		//전자결재연동 sample
		function ssoCall() {
			debugger
			var ssoTest = "ssoTest";
			var mstKey = "2";
			var key = ssoTest + mstKey;
			/* var ssoTable = $('#ssoTest table')[0].outerHTML; */
			$('#formId').val("114");
			$('#approKey').val(key);
			/* $('#contentsStr').val(ssoTable); */
			$('#mod').val('V');
			openWindow2("", "viewer", 1200, 900, 1);
			var frm = document.getElementById("viewerForm");
			window
					.open(
							"",
							"viewer",
							"width=965, height=650, resizable=no, status=no, top=50, left=50",
							"newWindow");

			frm.action = "http://211.192.144.104/gw/outProcessLogOn.do";
			frm.submit();
		}

		$(document).ready(function() {

			$(".file_input_button").on("click", function() {
				$(this).next().click();
			});

			$('.top_box input[type=text]').on('keypress', function(e) {
				if (e.key == 'Enter') {
					$('#grid').data('kendoGrid').dataSource.read();
				}
				;
			});

			var myWindow = $("#popUp");
			undo = $("#emp");

			undo.click(function() {

				myWindow.data("kendoWindow").open();
				undo.fadeOut();

			});

			function onClose() {
				undo.fadeIn();
			}

			$("#cancle").click(function() {
				myWindow.data("kendoWindow").close();
			});
			myWindow.kendoWindow({
				width : "600px",
				height : "650px",
				visible : false,
				actions : [ "Close" ],
				close : onClose
			}).data("kendoWindow").center();
		});

		var dataSource = new kendo.data.DataSource({
			serverPaging : true,
			pageSize : 10,
			transport : {
				read : {
					url : '/CustomNPTpf/common/empInformation',
					dataType : "json",
					type : 'post'
				},
				parameterMap : function(data, operation) {
					data.emp_name = $('#emp_name').val();
					data.dept_name = $('#dept_name').val();
					data.notIn = '';
					return data;
				}
			},
			schema : {
				data : function(response) {
					return response.list;
				},
				total : function(response) {
					return response.totalCount;
				}
			}
		});

		$(function() {

			mainGrid();
		});

		function gridReload() {
			$('#grid').data('kendoGrid').dataSource.read();
		}

		function mainGrid() {
			//캔도 그리드 기본
			var grid = $("#grid")
					.kendoGrid(
							{
								dataSource : dataSource,
								height : 500,

								sortable : true,
								pageable : {
									refresh : true,
									pageSizes : true,
									buttonCount : 5
								},
								persistSelection : true,
								selectable : "multiple",
								columns : [
										/* { template: "<input type='checkbox' class='checkbox'/>"
										,width:50,	
										}, */
										{
											field : "emp_name",
											title : "이름",

										},
										{

											field : "dept_name",
											title : "부서",

										},
										{
											field : "position",
											title : "직급",

										},
										{
											field : "duty",
											title : "직책",

										},
										{
											title : "선택",
											template : '<input type="button" id="" class="text_blue" onclick="empSelect(this);" value="선택">'
										} ],
								change : function(e) {
									codeGridClick(e)
								}
							}).data("kendoGrid");

			grid.table.on("click", ".checkbox", selectRow);

			var checkedIds = {};

			// on click of the checkbox:
			function selectRow() {

				var checked = this.checked, row = $(this).closest("tr"), grid = $(
						'#grid').data("kendoGrid"), dataItem = grid
						.dataItem(row);

				checkedIds[dataItem.CODE_CD] = checked;
				if (checked) {
					//-select the row
					row.addClass("k-state-selected");
				} else {
					//-remove selection
					row.removeClass("k-state-selected");
				}

			}
			function codeGridClick() {
				var rows = grid.select();
				var record;
				rows.each(function() {
					record = grid.dataItem($(this));
					console.log(record);
				});
				subReload(record);
			}
		}

		function subReload(record) {

			$('#keyId').val(record.if_info_system_id);

		}

		function empSelect(e) {
			debugger
			var row = $("#grid").data("kendoGrid").dataItem($(e).closest("tr"));
			alert('empSeq : ' + row.emp_seq + ' / empName : ' + row.emp_name
					+ ' / deptName : ' + row.dept_name + ' / position : '
					+ row.position + ' / duty : ' + row.duty);
		}

		$(document)
				.ready(
						function() {
							$("#grid1")
									.kendoGrid(
											{
												dataSource : {
													type : "odata",
													transport : {
														read : "https://demos.telerik.com/kendo-ui/service/Northwind.svc/Products"
													},
													schema : {
														model : {
															fields : {
																UnitsInStock : {
																	type : "number"
																},
																ProductName : {
																	type : "string"
																},
																UnitPrice : {
																	type : "number"
																},
																UnitsOnOrder : {
																	type : "number"
																},
																UnitsInStock : {
																	type : "number"
																}
															}
														}
													},
													pageSize : 7,
													group : {
														field : "UnitsInStock",
														aggregates : [
																{
																	field : "ProductName",
																	aggregate : "count"
																},
																{
																	field : "UnitPrice",
																	aggregate : "sum"
																},
																{
																	field : "UnitsOnOrder",
																	aggregate : "average"
																},
																{
																	field : "UnitsInStock",
																	aggregate : "count"
																} ]
													},

													aggregate : [ {
														field : "ProductName",
														aggregate : "count"
													}, {
														field : "UnitPrice",
														aggregate : "sum"
													}, {
														field : "UnitsOnOrder",
														aggregate : "average"
													}, {
														field : "UnitsInStock",
														aggregate : "min"
													}, {
														field : "UnitsInStock",
														aggregate : "max"
													} ]
												},
												sortable : true,
												scrollable : false,
												pageable : true,
												columns : [
														{
															field : "ProductName",
															title : "Product Name",
															aggregates : [ "count" ],
															footerTemplate : "Total Count: #=count#",
															groupFooterTemplate : "Count: #=count#"
														},
														{
															field : "UnitPrice",
															title : "Unit Price",
															aggregates : [ "sum" ],
															groupFooterTemplate : "sum: #=sum#"
														},
														{
															field : "UnitsOnOrder",
															title : "Units On Order",
															aggregates : [ "average" ],
															footerTemplate : "Average: #=average#",
															groupFooterTemplate : "Average: #=average#"
														},
														{
															field : "UnitsInStock",
															title : "Units In Stock",
															aggregates : [
																	"min",
																	"max",
																	"count" ],
															footerTemplate : "<div>Min: #= min #</div><div>Max: #= max #</div>",
															groupHeaderTemplate : "Units In Stock: #= value # (Count: #= count#)"
														} ]
											});
						});
	</script>
	<div class="btn_div">
		<div class="left_div">
			<div class="controll_btn p0">
				<button type="button" onclick="ssoCall();">전자결재연동sample</button>
				<button type="button" id="emp">사원팝업</button>
				<div class='search'>
		    <div class='search_bar'>
		      <input id='searchOne' type='checkbox' style="display: none;">
		      <label for='searchOne'>
		        <i class='icon ion-android-search'></i>
		        <i class='last icon ion-android-close'></i>
		        <p>|</p>
		      </label>
		      <input placeholder='Search...' type='text'>
		    </div>
		  </div>
			</div>
		</div>
	</div>
	<div class="pop_wrap_dir" id="popUp" style="width: 600px;">
		<div class="pop_head">
			<h1>사원 리스트</h1>

		</div>
		<div class="pop_con">
			<div class="top_box">
				<dl>
					<dt class="ar" style="width: 65px;">성명</dt>
					<dd>
						<input type="text" id="emp_name" style="width: 120px" />
					</dd>
					<dt>부서</dt>
					<dd>
						<input type="text" id="dept_name" style="width: 180px" /> <input
							type="button" onclick="gridReload();" id="searchButton"
							value="검색" />
					</dd>
				</dl>
			</div>
			<div class="com_ta mt15" style="">
				<div id="grid"></div>
			</div>
		</div>
		<!-- //pop_con -->

		<div class="pop_foot">
			<div class="btn_cen pt12">

				<input type="button" class="gray_btn" id="cancle" value="닫기" />
			</div>
		</div>
		<!-- //pop_foot -->
	</div>
	<!-- //pop_wrap -->





	<form id="viewerForm" name="viewerForm" method="post"
		action="http:/211.192.144.104/gw/outProcessLogOn.do" target="viewer">
		<!-- <input type="hidden" id="outProcessCode" name="outProcessCode" value="">  -->
		<!-- <input type="hidden" id="formId" name="formId" value=""> -->
		<input type="hidden" id="mod" name="mod" value="W">
		<input type="hidden" id="loginId" name="loginId" value="devjitsu">
		<input type="hidden" id="docId" name="docId" value="114">
		<!-- <input type="hidden" name="contentsEnc" value="O"> --> 
		<!-- <input type="hidden" id="contentsStr" name="contentsStr" value=""> --> 
		<!-- <input type="hidden" id="approKey" name="approKey" value=""> 
			<input	type="hidden" id="fileKey" name="fileKey" value=""> -->
	</form>
	<div id="ssoTest" style="display: none;">
		<P CLASS=HStyle0>
			<BR>
		</P>

		<P CLASS=HStyle0></P>
		<TABLE border="1" cellspacing="0" cellpadding="0"
			style='border-collapse: collapse; border: none;'>
			<TR>
				<TD valign="middle"
					style='width: 559; height: 17; border-left: none; border-right: none; border-top: none; border-bottom: none; padding: 1.4pt 5.1pt 1.4pt 5.1pt'>
					<P CLASS=HStyle0>연동 테스트</P>
				</TD>
			</TR>
		</TABLE>
		<P CLASS=HStyle0></P>

		<P CLASS=HStyle0>
			<BR>
		</P>

	</div>

	<div id="wrapper">
		<button data-cb="1">Add div</button>
		<button data-cb="2">Add img</button>
		<button data-cb="delete">Clear</button>
		아래에 추가<br />
		<div id="appendDiv"></div>
	</div>
	<script>
		(function() {
			var i = 1;
			var appendDiv = document.getElementById("appendDiv"); // #1 
			document.getElementById("wrapper")
					.addEventListener("click", append);
			function append(e) {
				var target = e.target || e.srcElement || event.srcElement;
				var callbackFunction = callback[target.getAttribute("data-cb")];
				appendDiv.appendChild(callbackFunction());

			}
			;
			var callback = {
				
				"1" : (function() {
					var div = document.createElement("div"); // #2

					div.innerHTML = "1번";
					
					return function() {
						return div.cloneNode(true); // #3
						
					}
				}()),
				"2" : (function() {
					var img = document.createElement("img");
					img.src = "http://www.google.co.kr/images/srpr/logo3w.png";
					return function() {
						return img.cloneNode(true);
					}
				}()),
				"delete" : function() {
					appendDiv.innerHTML = "";
					return document.createTextNode("Cleared");
				}
			};

		}());
	</script>
	
	
		  
	

</body>
</html>
