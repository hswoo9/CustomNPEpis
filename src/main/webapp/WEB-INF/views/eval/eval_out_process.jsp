<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>

<script>

var anList =  JSON.parse('${anList}');
var anData = JSON.parse('${anData}');
$(function(){
	
	//결재첨부파일 키
	parent.dj_fileKey = anData.file_key;
	
	parent.$("#viewLoading").show();
	
	//버튼 숨기기
	parent.$('.bizTripPage').hide();

	//테스트용 프로젝트 예산과목 코드
// 	anData.erpMgtSeq = '20101';
// 	anData.erpMgtName = '농업농촌교육지원';
// 	anData.erpBudgetSeq = '1021001023';
// 	anData.erpBudgetName = '협의회지원';
	
	//결의정보 등록
	var resTbl_uid = parent.$('#resTbl').dzt('getUID');
	parent.$('#resTbl').dzt('setValue',  resTbl_uid, anData, false);
	
	//결의정보 마지막 이벤트
	lastEvent1();
	parent.fnResUpdate();
	
	//예산내역 등록
	var budgetTbl_uid = parent.$('#budgetTbl').dzt('getUID');
	parent.$('#budgetTbl').dzt('setValue',  budgetTbl_uid, anData, false);
	
	//예산내역 마지막 이벤트
	parent.fnSetBudgetDisplay();
	lastEvent2();
	
	
	//결제내역 등록
	$.each(anList, function(i, v){

		var tradeTblAll = parent.$('#tradeTbl').dzt('getValueAll');
		
		var tradeTbl_uid = tradeTblAll[i].uid
				
		//테스트용 거래처 코드.. 실제 erp 데이터와 조건이 맞는지 확인이 필요한다
		//금액은 부과세 어떻게 강제로 넣어주건가?
		var money = Number(v.eval_pay) + Number(v.trans_pay);
		var tradeData = {
				trSeq : v.TR_CD,		
				trName : v.name,		
				beforeTradeAmt  : Number(money).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","),		
				tradeAmt    : Number(money).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","),		
				tradeStdAmt   : Number(money).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","),		
				tradeVatAmt   : 0,	
				baNb : v.BA_NB, //계좌번호
				btrName : v.BANK_NM, //금융기관명
				btrSeq : v.JIRO_CD, //금융기관 코드
				depositor : v.DEPOSITOR, //예금주
				regDate : '', //신고기준일
		}
		
		parent.$('#tradeTbl').dzt('setValue',  tradeTbl_uid, tradeData, false);
		
		//결제내역 등록 이벤트
		parent.fnEventTradeAdd();

	});
	
	parent.$("#viewLoading").hide();
	
});

//결재작성 시 호출 이벤트가 있으면 여기에 적용
function djCustApproval(){
	console.log("djCustApproval");
}


function lastEvent1(){
	
		/* 현재 행 정보 조회 */
		var resData = parent.$('#resTbl').dzt('getValue');

		/* 필수값 입력 확인 */
		var reqChkRes = parent.fnResChkValue();

		/* 저장될 데이터 사이즈 확인 */
		if (resData.resNote.length > 79) {
			alert('적요는 80자 이내로 작성가능합니다.');
			return;
		}

		if (reqChkRes.sts) {
			/* 데이터 저장여부 확인 */
			if (typeof resData.resSeq === 'undefined' || resData.resSeq === '') {
				parent.fnResInsert();

				/* 정상처리여부 확인 */
				resData = parent.$('#resTbl').dzt('getValue');
				if ((resData.insertStat || '') === 'SUCCESS') {
					parent.$('#resTbl').dzt('setCommit', false); /* commit 처리 */
					parent.$('#resTbl').dzt('setColRemoveSelect'); /* colOn 제거 */

					if (parent.$('#budgetTbl').dzt('getValueAll').length < 1) {
						parent.$('#btnBudgetAdd').click();
					} else {
						parent.$('#resTbl').dzt('setCommit', false);
						parent.$('#resTbl').dzt('setColRemoveSelect'); /* colOn 제거 */
						parent.$('#budgetTbl').dzt('setDefaultFocus', 'LAST'); /* 예산내역 마지막 행 포커스 지정 */
					}
				} else {
					parent.$('#resTbl').dzt('setValue', $('#resTbl').dzt('getUID'), {
						insertStat : '',
						insertMsg : ''
					});
					parent.$('#resTbl').dzt('setCommit', false);

					if ((resData.insertMsg || '') !== '') {
						alert(resData.insertMsg);
					}
				}
			} else {
				/* 저장도 되었으며 마지막 행이므로 결제내역으로 이동 */
				var budgetDataArray = parent.$('#budgetTbl').dzt('getValueAll');
				var budgetSaveCount = parent.$('#budgetTbl').dzt('getValueAll').filter(function(item) {
					return ((item.budgetSeq || '') != '')
				}).length;

				if (budgetDataArray.length !== budgetSaveCount) {
					/* 마지막 행으로 이동 */
					parent.$('#budgetTbl').dzt('setCommit', false);
					parent.$('#budgetTbl').dzt('setColRemoveSelect'); /* colOn 제거 */
					parent.$('#budgetTbl').dzt('setDefaultFocus', 'LAST'); /* 예산내역 마지막 행 포커스 지정 */
				} else {
					/* 신규 행 추가 */
					parent.$('#btnBudgetAdd').click();
				}
			}
		} else {
			/* 미입력 항목 포커스 지정 */
			var uid = parent.$('#budgetTbl').dzt('getUID');
			parent.$('#budgetTbl').dzt('setFocus', uid, reqChkRes.key);

			/* 사용자 알림 처리 */
			alert(reqChkRes.msg);
		}

		/* 포커스 지정이 존재하지 않는 경우에는 현재 포커스 유지처리 */
		if ((parent.$('#budgetTbl').find('.colOn').length + parent.$('#tradeTbl').find('.colOn').length) === 0) {
			parent.$('#resTbl').dzt('setFocus', parent.$('#resTbl').dzt('getUID'), this.column);
		}

		return false;
		
}

function lastEvent2(){
	
	/* 현재 행 정보 조회 */
	var budgetData = parent.$('#budgetTbl').dzt('getValue');

	/* 필수값 입력 확인 */
	var reqChkBudget = parent.fnBudgetChkValue();

	/* 저장될 데이터 사이즈 확인 */
	if (budgetData.budgetNote.length > 79) {
		alert('${CL.ex_note} 는 80자 이내로 작성가능합니다.');/*적요*/
		return;
	}

	if (reqChkBudget.sts) {
		/* 데이터 저장여부 확인 */
		if (typeof budgetData.budgetSeq === 'undefined' || budgetData.budgetSeq === '') {
			parent.fnBudgetInsert();

			/* 정상처리여부 확인 */
			budgetData = parent.$('#budgetTbl').dzt('getValue');
			if ((budgetData.insertStat || '') === 'SUCCESS') {
				parent.$('#budgetTbl').dzt('setCommit', false); /* commit 처리 */
				parent.$('#budgetTbl').dzt('setColRemoveSelect'); /* colOn 제거 */

				if (parent.$('#tradeTbl').dzt('getValueAll').length < 1) {
					parent.$('#btnTradeAdd').click();
				} else {
					parent.$('#budgetTbl').dzt('setCommit', false);
					parent.$('#budgetTbl').dzt('setColRemoveSelect'); /* colOn 제거 */
					parent.$('#tradeTbl').dzt('setDefaultFocus', 'LAST'); /* 예산내역 마지막 행 포커스 지정 */
				}
			} else {
				parent.$('#budgetTbl').dzt('setValue', parent.$('#budgetTbl').dzt('getUID'), {
					insertStat : '',
					insertMsg : ''
				});
				parent.$('#budgetTbl').dzt('setCommit', false);

				if ((budgetData.insertMsg || '') !== '') {
					alert(budgetData.insertMsg);
				}
			}
		} else {
			/* 저장도 되었으며 마지막 행이므로 결제내역으로 이동 */
			var tradeDataArray = parent.$('#tradeTbl').dzt('getValueAll');
			var tradeSaveCount = parent.$('#tradeTbl').dzt('getValueAll').filter(function(item) {
				return ((item.tradeSeq || '') != '')
			}).length;

			if (tradeDataArray.length !== tradeSaveCount) {
				/* 마지막 행으로 이동 */
				parent.$('#tradeTbl').dzt('setCommit', false);
				parent.$('#tradeTbl').dzt('setColRemoveSelect'); /* colOn 제거 */
				parent.$('#tradeTbl').dzt('setDefaultFocus', 'LAST'); /* 예산내역 마지막 행 포커스 지정 */
			} else {
				/* 신규 행 추가 */
				parent.$('#btnTradeAdd').click();
			}
		}
	} else {
		/* 미입력 항목 포커스 지정 */
		var uid = parent.$('#budgetTbl').dzt('getUID');
		parent.$('#budgetTbl').dzt('setFocus', uid, reqChkBudget.key);

		/* 사용자 알림 처리 */
		/* 사용자 알림 처리 */
		if ((reqChkBudget.msg || '') !== '') {
			alert(reqChkBudget.msg);
		}
	}

	return false;
	
}


</script>

