<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>

<script type="text/javascript" src='<c:url value="/js/jszip.min.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/eval/addScript.js?v=2"></c:url>'></script>

<style>
.sub_contents_wrap{min-height:0px;}
.com_ta table th{text-align: center; padding-right: 0px;}
#commTable td{text-align: center;}
#evalItemDD td{text-align: center; padding-right: 0px; padding-left: 0px;}
#joinOrgDD td{text-align: center; padding-right: 0px; padding-left: 0px;}
.com_ta table td {border: 1px solid #eaeaea;}
</style>

<script type="text/javascript">
var eval_s_date = '${commDetail.eval_s_date2 }';
var eval_e_date = '${commDetail.eval_e_date2 }';
var resultCommissionerList = JSON.parse('${commUserListJson }');
var addCommissionerList = [];
</script>

<div class="iframe_wrap" style="min-width:1400px">
	<div class="sub_title_wrap">
		<div class="title_div">
			<h4>제안평가 접수</h4>
		</div>
	</div>
	
	<div class="sub_contents_wrap">
		<p class="tit_p mt5 mt10">사업개요</p>
		
		<div class="com_ta">
			<div class="top_box gray_box" id="newDate">
			
				<table style="width: 100%">
					<colgroup>
						<col width="80px;">
						<col width="350px;">
						<col width="80px;">
						<col width="350px;">
						<col width="80px;">
						<col width="350px;">
						<col width="80px;">
						<col width="">
					</colgroup>
					<tr>
						<th>요구부서</th>
						<td>	
							<label>${commDetail.req_dept_name}</label>
						</td>
						<th>감사실담당</th>
						<td>	
							<label>${commDetail.major_dept} / ${commDetail.major_emp_name}</label>
						</td>
						<th>작성자</th>
						<td>	
							<label>${commDetail.create_dept_name} / ${commDetail.create_emp_name} / ${commDetail.create_duty_name}</label>
						</td>
						<th>작성일자</th>
						<td>	
							<label>${commDetail.create_date2}</label>
						</td>
					</tr>
				
					<tr>
						<th>사업명</th>
						<td>	
							<label>${commDetail.title}</label>
						</td>
						<th>추정가격</th>
						<td>	
							<label><fmt:formatNumber type="number" maxFractionDigits="3" value="${commDetail.budget}" />원</label>
						</td>
						</td>
						<th>환산점수</th>
						<td colspan="3">	
							${commDetail.rates}%
						</td>
					</tr>
					<input type="hidden" id="commissioner_cnt" style="width: 30px;" value="${commDetail.commissioner_cnt }" maxlength="2">
				</table>
			</div>
		</div>

	</div>


	<div class="sub_contents_wrap">
		<p class="tit_p mt5 mb10">평가개요</p>
	
		<div class="com_ta">
			<div class="top_box gray_box" id="newDate">
				<table style="width: 100%">
					<colgroup>
						<col width="80px;">
						<col width="400px;">
						<col width="80px;">
						<col width="">
					</colgroup>
					<tr>
						<th>평가일시</th>
						<td>
							<label>${commDetail.eval_s_date2} ~ ${commDetail.eval_e_date2}</label>&emsp;&emsp;
							<c:if test="${commDetail.eval_s_time ne '' and commDetail.eval_e_time ne ''}">
								${commDetail.eval_s_time } ~ ${commDetail.eval_e_time}
							</c:if>
						</td>
						<th>평가장소</th>
						<td>
							<label>${commDetail.eval_place }</label>
						</td>
					</tr>		
					
					<tr>
						<th>운영요원</th>
						<td colspan="3">
							<table style="width: 100%;">
								<c:forEach items="${commDetail.orpList}" var="list" varStatus="st">
									<tr>
										<td>${list.opr_dept} / ${list.opr_emp_name}</td>
									</tr>
								</c:forEach>
							</table>
						</td>
					</tr>
						
					<tr>
						<th>참여기관<br>(업체)</th>
						<td colspan="3">
							<table style="width: 300px;">
								<thead>
									<tr>
										<th>기관명</th>
									</tr>
								</thead>
								<tbody id="joinOrgDD">
									<c:forEach items="${company }" var="list" varStatus="st">
										<tr>
											<td>${list.company_name}</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</td>
					</tr>
					<tr>
						<th>평가분야</th>
						<td colspan="3">
							<table style="width: 800px;">
								<thead>
									<tr>
										<th>항목명</th>
										<th>배점</th>
										<th>100%</th>
										<th>90%</th>
										<th>80%</th>
										<th>70%</th>
										<th>60%</th>
									</tr>
								</thead>
								<tbody id="evalItemDD">
									<c:forEach items="${item }" var="list" varStatus="st">
										<tr>
											<td style="text-align: left; padding-left: 25px;">${list.item_name}</td>
											<td>${list.score}점</td>
											<td>${list.score_1}점</td>
											<td>${list.score_2}점</td>
											<td>${list.score_3}점</td>
											<td>${list.score_4}점</td>
											<td>${list.score_5}점</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</td>
					</tr>
				</table>
			
			</div>
		</div>
	</div>
	
	<div class="sub_contents_wrap">
		<div class="left_div" style="float: left;">
			<div class="btn_div">	
			<p class="tit_p mt5 mt10">평가위원구성</p>
				<div class="right_div">
					<div class="controll_btn p0">
							<button type="button" id="addBtn" onclick="addCommissioner();">평가위원추가</button>							
							<button type="button" id="confirmBtn" onclick="confirmCommissioner();">확정</button>
					</div>
				</div>
			</div>
		</div>
			
			<div style="padding-top: 50px;">
			  <div>
				<div class="com_ta3" style="min-height: 400px;">
					<table style="width: 100%;">
						<tr>
							<th style="width: 50px;"></th>
							<th style="width: 50px;">정렬순서</th>
							<th style="width: 100px;">이름</th>
							<th>생년월일</th>
							<th>전문분야</th>
							<th>소속</th>
							<th>직급</th>
							<th style="width: 150px;">유선전화</th>
							<th style="width: 150px;">휴대폰</th>
							<th>이메일</th>
							<th style="width: 80px;">불참</th>
						</tr>
						
						<tbody id="commTable">
							<c:forEach items="${commUserList }" var="list" varStatus="st">
								<c:choose>
									<c:when test="${list.confirm_yn eq 'Y' and list.attend_yn eq 'N'}">
										<tr style="background-color: lightskyblue;">
									</c:when>
									<c:otherwise>
										<tr>
									</c:otherwise>								
								</c:choose>
							
									<c:choose>
										<c:when test="${list.confirm_yn eq 'Y' and list.attend_yn eq 'Y' }">
											<td></td>
										</c:when>
										<c:when test="${list.confirm_yn eq 'Y' and list.attend_yn eq 'N' }">
											<td></td>
										</c:when>
										<c:otherwise>
											<td></td>
										</c:otherwise>
									</c:choose>
									<td>${st.count }</td>
									<td>${list.name }</td>
									<td>${fn:substring(list.birth_date,0,6)}</td>
									<td>${list.BIZ_TXT }</td>
									<td>${list.org_name }</td>
									<td>${list.org_grade }</td>
									<td>${list.tel }</td>
									<td>${list.mobile }</td>
									<td>${list.email }</td>
									<td>
										<c:choose>
											<c:when test="${list.confirm_yn eq 'Y' and list.attend_yn eq 'Y'}">
												<input type="button" value="불참" onclick="cancelPopupBtn(${list.commissioner_seq });">
											</c:when>
											<c:otherwise>	
												${list.cancel_txt }
											</c:otherwise>
										</c:choose>
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
		</div>
		</div>
		
		
	</div>

</div>

<div class="pop_wrap" id="evalCommCancelPopup" style="min-width:800px; display:none;">
	<div class="pop_con">
		<!-- 컨트롤박스 -->
		<div class="com_ta2">
			<div class="top_box gray_box" id="newDate">
				<dl>
					<dt style="">
						불참사유
					</dt>
					<dd style="line-height: 25px; width: 670px;">
						<input type="hidden" id="cancel_seq">
						<input type="text" id="cancel_txt" style="width: 90%;">
					</dd>
				</dl>
			</div>

			<div class="top_box gray_box">
				<dl>
					<dd style="width: 45%;"></dd>
					<dd>
						<input type="button" style="margin-bottom: 15px;" id="saveBtn" onclick="cancelBtn();" value="등록하기">
					</dd>
				</dl>
			</div>
		</div>
	</div><!-- //pop_con -->
</div><!-- //pop_wrap -->

<!-- 평가위원 검색팝업 -->
<div class="pop_wrap_dir" id="commissionerPopup" style="width:1500px;">
	<div class="pop_con">
		<div class="top_box">
			<dl>
				<dt class="ar" style="width: 80px;">성명</dt>
				<dd style="">
					<input type="text" id="searchNm" style="width: 120px" />
				</dd>
				<dt style="margin-left:90px;">
					전문분야
				</dt>
				<dd style="line-height: 25px">
					<select class="selectMenu" id="searchSelect" style="width: 200px;">
						<option value="all">전체</option>
						<c:forEach items="${btcList }" var="list">
							<option value="${list.code }">${list.code_kr }</option>
						</c:forEach>
					</select>
				</dd>
				<dd>
					<input type="button" onclick="commissionerGridReload();" id="searchButton"	value="검색" />
				</dd>
			</dl>
		</div>
		<div class="com_ta mt15" style="height: 460px;">
			<div id="commissionerGrid"></div>
		</div>			
	</div>

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" class="gray_btn" id="commissionerGridPopupCancel" value="닫기" />
		</div>
	</div>
</div>	
<!-- 평가의원 검색팝업 -->

<script>
var tabNum = 1;
$(function(){
	
	commissionerInitPopEvent();
	commissionerGrid();
	
	$('#create_date').val(moment().format('YYYY-MM-DD'));
	
	$('.selectMenu').kendoDropDownList();
	
	var commTypeList = JSON.parse('${commTypeList}');

	if(commTypeList.length != 0){
		$.each(commTypeList, function(i, v){
			$($('.selectType').get(i)).find('select').data("kendoDropDownList").value(v.biz_type_code_id);
			$($('.selectType').get(i)).find('input').val(v.commissioner_cnt);
		});
	};
	
	$('#evalCommCancelPopup').kendoWindow({
	    width: "800px;",
	    title: '불참사유',
	    visible: false,
	    modal : true,
	    actions: [
	        "Close"
	    ],
	}).data("kendoWindow");

	//평가위원 수 초기 금액별 세팅
	var budget = ${commDetail.budget };
	var commissioner_cnt = 0;
	if('${commDetail.commissioner_cnt }' == ''){
		if(budget < 500000000){
			commissioner_cnt = 5;
		}else if(budget >= 500000000 && budget < 1000000000){
			commissioner_cnt = 7;
		}else if(budget >= 1000000000){
			commissioner_cnt = 9;
		}
		$('#commissioner_cnt').val(commissioner_cnt);
	}
	
});

<%--평가위원 수 유효성 검사 --%>
var evalCommSeq;
var evalSetData;
var saveFlag = true;
var committee_seq = '${commDetail.committee_seq }';
var userCnt = ${commDetail.user_cnt };

function crtCommBtn(){
	
	var array = new Array();
	var temp = new Array();
	var flag = false;
	var cdList = new Array();
	userCnt = $('#userCnt').val();
	
	$.each($('.selectType'), function(i, v){
		
		var num = Number($(v).find('input').val());
		var sel = $(v).find('select').val();
		var selTxt = $(v).find('select option:selected').text();
		
		if( !isNaN(num) && num > 0){
			if(temp.indexOf(sel) > -1){
				flag = true;
			}else{
				temp.push(sel);
			}
		}
		
		if( !isNaN(num) && num > 0){
			
			array.push({
				code :	sel,
				selTxt : selTxt,
				nCnt : num,	
				nn : num*userCnt,	
			});
			
			cdList.push(sel);
		}
		
	});
	
	if(flag){
		alert('전문분야가 중복되었습니다.');
		return
	}
	
	var total = 0;
	$.each($('.evalNum'), function(i, v){
		
		if(isNaN(Number(v.value))){
			total += 0;
		}else{
			total += Number(v.value);
		}
	});
	
	var commCnt = $('#commissioner_cnt').val();
	if(commCnt != total){
		alert('평가위원은 ' + commCnt + '명 이어야 합니다.');
		return
	}
	
	var data = {
		code : JSON.stringify(array),
		committee_seq : committee_seq,
		eval_s_date : '${commDetail.eval_s_date2 }',
		eval_e_date : '${commDetail.eval_e_date2 }',
		cdList : cdList.join(),
		userCnt : userCnt,
		tabNum : tabNum,
		commissioner_cnt : $('#commissioner_cnt').val(),
	}
	
	$.ajax({
		url: "<c:url value='/eval/getEvalCommList' />",
		data : data,
		type : 'POST',
		success: function(result){
			saveFlag = false;
			
			if(result.getList.length != total*userCnt){
				alert('평가위원이 부족합니다.');
			}
			
			$('#commTable_'+tabNum).empty();
			evalCommSeq = result.getList;
			evalSetData = result.data;

			$.each(result.getList, function(i, v){

				var html = '<tr>'; 
				html += '<td><input type="checkbox" disabled="disabled"></td>';
				html += '<td>'+(i+1)+'</td>';
				html += '<td>'+v.name+'</td>';
				if(v.birth_date != null){
					html += '<td>'+moment(v.birth_date).format('YYYY-MM-DD')+'</td>';
				}else{
					html += '<td></td>';
				}
				html += '<td>'+v.biz_type_array+'</td>';
				html += '<td>'+v.org_name+'</td>';
				html += '<td>'+v.org_rank+'</td>';
				html += '<td>'+v.tel+'</td>';
				html += '<td>'+v.mobile+'</td>';
				html += '<td>'+v.email+'</td>';
				html += '<td></td>';
				html += '</tr>';
				
				$('#commTable_'+tabNum).append(html);
				
			});
		}
	});
	
}

function evalCommSave(){
	
	if(saveFlag){
		alert('수정된 내용이 없습니다.');
		return
	}
	
	if(evalCommSeq == null || evalCommSeq.length == 0){
		alert('평가위원생성을 해주세요.');
		return
	}

	var data = {
			code : JSON.stringify(evalCommSeq),
			setData : JSON.stringify(evalSetData),
			committee_seq : committee_seq,
			create_date : $('#create_date').val(),
			create_emp_seq : $('#create_emp_seq').val(),
			create_dept_seq : $('#create_dept_seq').val(),
			userCnt : userCnt,
			tabNum : tabNum,
			commissioner_cnt : $('#commissioner_cnt').val(),
		}
	
	if(confirm('저장하시겠습니까?')){
		
		$.ajax({
			url: "<c:url value='/eval/setEvalCommSave' />",
			data : data,
			type : 'POST',
			success: function(result){
				alert('저장하였습니다.');
				var url = _g_contextPath_ + '/eval/evaluationProposalDetail?code=' + committee_seq + '&tabN=' + tabNum;
				location.href = "<c:url value='"+url+"' />";
			}
		});
		
	}
	
}

function evalCommFix(){
	
	var checkUserList = new Array();
	
	$.each($('.userCheckBox'), function(i, v){
		if($(v).prop('checked')){
			checkUserList.push(v.value);
		}
	});
	
	if(checkUserList.length == 0){
		alert('평가위원을 선택해 주세요.');
		return
	}
	
	if(confirm('확정하시겠습니까?')){
		
		$.ajax({
			url: "<c:url value='/eval/evalCommFix' />",
			data : {commissioner_seq : checkUserList.join(), committee_seq : committee_seq, },
			type : 'POST',
			success: function(result){
				alert('저장하였습니다.');
				var url = _g_contextPath_ + '/eval/evaluationProposalDetail?code=' + committee_seq + '&tabN=' + tabNum;
				location.href = "<c:url value='"+url+"' />";
			}
		});
		
	}
	
}

function cancelBtn(){
	
	$.ajax({
		url: "<c:url value='/eval/evalCommCancel' />",
		data : {committee_seq : committee_seq, commissioner_seq : $('#cancel_seq').val(), cancel_txt : $('#cancel_txt').val()},
		type : 'POST',
		success: function(result){
			alert('저장하였습니다.');
			location.reload();	
		}
	});
	
}

function cancelPopupBtn(e){
	
	$('#cancel_seq').val(e);
	$('#cancel_txt').val('');
	
	$('#evalCommCancelPopup').data("kendoWindow").center().open();
	
}

function excelBtn(){
	
	window.location.assign(_g_contextPath_+'/eval/evalGetUserList?code=' + committee_seq + '&tabNum=' + tabNum);

}


</script>