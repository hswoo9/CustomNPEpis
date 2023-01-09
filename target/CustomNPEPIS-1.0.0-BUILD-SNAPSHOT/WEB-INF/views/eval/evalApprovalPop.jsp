<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>

<style>

</style>

<script>
</script>

<div class="pop_wrap_dir" id="approvePop">
	<div id="approveDataPop">
		<div id="approvalDataDiv" style="padding: 20px;margin:0 auto; text-align: center;" contenteditable="false">
			<table style="border-spacing: 0;width:100%;" contenteditable="false">
				<colgroup>
					<col width="55%">
					<col width="10%">
					<col width="35%">
				</colgroup>
				<tr>
					<th colspan="4" style="height: 50px; padding: 5px 0; font-size: 18px;">
						<p style="margin: 0;"><strong>평가위원회 구성요청서</strong></p>
					</th>
				</tr>
			</table>

			<table role="grid" style="border-collapse: separate; border-spacing: 0;margin: 10px auto;width: 100%;font-size: 12px;border-width: 2px 2px 2px 2px;border: 2px solid #000000;">
				<tr>
					<th style ="font-size: 14px; box-sizing: border-box;"><p style="margin: 0; text-align: left;">1. 사업개요</p></th>
				</tr>
				<tr>
					<td style="padding-left: 7px; font-size: 12px; box-sizing: border-box;">
						<p style="margin: 0; text-align: left;" class="budget"></p>
					</td>
				</tr>
				<tr>
					<th style ="padding-top: 20px; font-size: 14px; box-sizing: border-box;"><p style="margin: 0; text-align: left;">2. 평가개요</p></th>
				</tr>
				<tr>
					<td style="padding-left: 7px; font-size: 12px; box-sizing: border-box;">
						<p style="margin: 0; text-align: left;" class="evalDate">
							ㅇ 평가일시 : <br>
							ㅇ 평가장소 : <br>
							ㅇ 참여기관(업체) 수 : <br>
							ㅇ 운영요원 <br>
							- 간  사 :
						</p>
					</td>
				</tr>
				<tr>
					<th style ="padding-top: 20px; font-size: 14px; box-sizing: border-box;"><p style="margin: 0; text-align: left;">3. 평가위원 구성</p></th>
				</tr>
				<tr>
					<td style="padding-left: 7px; font-size: 12px; box-sizing: border-box;">
						<p style="margin: 0; text-align: left;" >
							<c:set var="guestDetail" value="${fn:substring(commDetail.COMMITTEE_GUEST, 1, fn:length(commDetail.COMMITTEE_GUEST))}"/>
							<c:set var="guestDetail" value="${fn:split(guestDetail, '<br>')}"/>
							<c:set var="totalCnt" value="0"/>
							<c:forEach var="item" items="${guestDetail}">
								<c:set var="totalCnt" value="${totalCnt + fn:substring(fn:split(item, '(')[1], 0, 1)}"/>
							</c:forEach>

							ㅇ 평가위원 수 : ${totalCnt + commDetail.IN_MB_CNT} 명 <br>
							- 분야별 선정 위원(전문분야) <br>
							ㆍ 외부위원 <br>
							${fn:replace(commDetail.COMMITTEE_GUEST, "-" , "- ")} <br>
							ㆍ 내부위원 (${commDetail.IN_MB_CNT}명)
						</p>
					</td>
				</tr>
				<tr contenteditable="false">
					<th colspan="4" style="font-weight: normal;line-height: 30px;">
						<p id="nowDate" style="margin: 0"></p>

						<p style="margin: 0;text-align: right;">사업담당자 : <span id="draftEmpName" name="draftEmpName"></span> (서명) </p>
						<p style="margin: 0;text-align: right;">요구부서장 : <span id="draftEmpName2" name="draftEmpName"></span> (서명) </p>
					</th>
				</tr>
			</table>
		</div>
	</div>
</div>
<form id="approvalDraftDataFrm" method="post" target="_self">
	<input type="hidden" id="menuCd" name="menuCd" value="${params.menuCd}">
	<input type="hidden" id="type" name="type" value="${params.type}">
	<input type="hidden" id="docId" name="docId" value="${params.docId}">
	<input type="hidden" id="contentId" name="contentId" value="evalReqId">
	<input type="hidden" id="contentValue" name="contentValue" value="${commDetail.committee_seq}">
	<input type="hidden" id="docContent" name="docContent" value="">
</form>
<script>
	$(".budget").html(
		"ㅇ 요구부서 : ${commDetail.req_dept_name}<br>"
		+ "ㅇ 사 업 명 : ${commDetail.title}<br>"
		+ "ㅇ 추정가격 : " + numberWithCommas(${commDetail.budget}) + "원"
	);

	let opr_emp_name = ["${commDetail.opr_emp_name_1}", "${commDetail.opr_emp_name_2}", "${commDetail.opr_emp_name_3}", "${commDetail.opr_emp_name_4}", "${commDetail.opr_emp_name_5}"];
	let opr_emp = '';
	for (let i = 0; i <= 4; i++) {

		let s = opr_emp_name[i];
		if(s != ''){

			if(i > 0){
				opr_emp += ', ';
			}

			opr_emp += s;
		}
	}

	$(".evalDate").html(
		"ㅇ 평가일시 : "+getDateFormatReturn('${commDetail.eval_s_date}')+" ~ "+getDateFormatReturn('${commDetail.eval_e_date}')+"<br>"
		+ "ㅇ 평가장소 : ${commDetail.eval_place}<br>"
		+ "ㅇ 참여기관(업체) 수 : ${commDetail.join_org_cnt}<br>"
		+ "ㅇ 운영요원 : " + opr_emp + "<br>"
		+ "- 간  사 : "
	);

	let loginName = "${loginVO.name}";
	let loingJangName = "${getJangName.EMP_NAME_KR}";

	$("#draftEmpName").text(loginName);
	$("#draftEmpName2").text(loingJangName);

	let today = new Date();

	let year = today.getFullYear(); // 년도
	let month = today.getMonth() + 1;  // 월
	let date = today.getDate();  // 날짜
	let day = today.getDay();  // 요일

	$("#nowDate").text(year + "년 " + month + "월 " + date + "일");

	$("#docContent").val($("#approveDataPop")[0].innerHTML);
	$("#approvalDraftDataFrm").prop("action", "<c:url value='/approval/approvalDraftingPop.do' />");
	$("#approvalDraftDataFrm").submit();

	// opener.docContent = $("#approvePop")[0].innerHTML;
	// setTimeout(() => window.close(), 500);

	function numberWithCommas(num) {
		if (!num) {
			return 0;
		}
		return Math.floor(num).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}

	function getDateFormatReturn(dateVal) {
		return dateVal.substring(0,4) + "-" + dateVal.substring(4,6) + "-" + dateVal.substring(6,8);
	}
</script>