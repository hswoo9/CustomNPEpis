<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>

<body>

<div class="iframe_wrap" style="min-width:1100px">
	<input type="hidden" id="comp_seq" value="${loginVO.compSeq }"/>
	<input type="hidden" id="emp_seq" value="${loginVO.uniqId }"/>
	<input type="hidden" id="emp_name" value="${loginVO.name }"/>
	<input type="hidden" id="emp_erp_num" value="${loginVO.erpEmpCd }"/>
	<input type="hidden" id="org_code" value=""/>
	<input type="hidden" id="dept_seq" value="${loginVO.orgnztId}"/>
	<!-- 컨텐츠타이틀영역 -->
	<div class="sub_title_wrap">
		
		<div class="title_div">
			<h4>시내 출장</h4>
		</div>
	</div>
	
	<div class="sub_contents_wrap">
	<p class="tit_p mt5 mt20">시내 출장</p>

	<div class="com_ta">
				<div class="top_box gray_box">
				<dl>
				<!-- BTTripNo : 온나라 출장번호 / BTEmpNo : 출장자 사번 / RowPk : PK로 잡을게 없어서 사번+출장번호로 행마다 ID값 부여 -->
				<input type="hidden" id="BTTripNo" class="dataInputt"/>
				<input type="hidden" id="BTEmpNo" class="dataInputt"/>
				<input type="hidden" id="RowPK" class="dataInputt"/>
					<dt style="width: 5%; text-align: center;">
						부서
					</dt>
					<dd style="line-height: 25px; width: 10%;">
						<input type="text" id="BTDept"  class="dataInputt" style="width: 180px;" readonly="readonly">		
					</dd>
					<dt style="width: 5%; text-align: center;">
						출장자
					</dt>
					<dd style="line-height: 25px; width: 10%;">
						<input type="text" id="BTEmp" style="width: 180px;"  class="dataInputt"  readonly="readonly"><!-- <a class="btn_search" onclick="getUser();" style="margin-top: 1px;"></a> --> 
					</dd>
					<dt style="width: 5%; text-align: center;">
						출장일
					</dt>
					<dd style="line-height: 25px; width: 10%; ">
						<input type="text" id="BTDateFR" style="width: 180px;" >
					</dd>
					<dt style="width: 5%;  text-align: center; padding-left: 60px;">
						시간
					</dt>
					<dd style="line-height: 25px; width: 25%;">
						<input type="text" id="BTTimeFR" style="width: 100px;" class="dataInputt" > <input type="text" id="BTTimeEND" style="width: 100px;"  class="dataInputt" > (<span id="timeHour">0</span>시간 <span id="timeMinute">0</span>분)
					</dd>
					<div class="btn_div">	
					<div class="right_div">
						<div class="controll_btn p1">										
							<button style="margin-right: 10px;" type="button"  onclick="getOnNaraBustrip();">선택</button>
							<!-- <button style="margin-right: 10px;" type="button"  onclick="testt();">asd</button> -->
						</div>
					</div>
				</div>
				</dl>	
				
				<dl>
					<dt style="width: 5%; text-align: center;">
						업무차량
					</dt>
					<dd style="line-height: 25px;width:10%; text-align: center;">
						<input type="radio" name="car" id="car1" value="이용함"  ><label for="car1">사용</label>&emsp;&emsp;
						<input type="radio" name="car" id="car2" value="이용안함"   ><label for="car2">미사용</label>
					</dd>
					<dt  style="width: 4%; text-align: center;">
						목적
					</dt>
					<dd style="width:30%;">
						<input type="text" id="rm" style="min-width: 100%;" class="dataInputt" />
					</dd>
					<dt style="width: 5%; text-align: center;">
						비용
					</dt>
					<dd style="line-height: 25px; width: 15%;">
						<input style="width: 180px;" type="text" id="BTCityCost"  class="dataInputt" readonly="readonly"> 원
						
					</dd>
					<div id="modmod" class="btn_div" style="display: none;">	
					<div class="right_div">
						<div class="controll_btn p1">										
							<button style="margin-right: 10px;" type="button"  onclick="modSave();">수정</button>
							<button style="margin-right: 10px;" type="button"  onclick="cancelMod();">취소</button>
						</div>
					</div>
				</div>
				</dl>	
				
			</div>
				<!-- <div class="btn_div">	
					<div>
							<span style="padding-left:30px; color: red; font-size: 13px; font-weight: bold;">총 금액 </span>: <input id="totalSum" style="width: 148px;" type="text"
								style="text-align: center;" readonly="readonly"  class="dataInputNumber" value="">
						</div>
				</div> -->
				<div class="com_ta4 mt15">
						<div id="gridList">
							<table>
								<thead>
									<tr>
										</th> 
										<th style="text-align: center; width: 13%;">출장일</th>
										<th style="text-align: center;width: 20%; ">부서명</th>
										<th style="text-align: center; width: 12%;">성명</th>
										<th style="text-align: center;width: 8%;">업무차량 사용여부</th>
										<th style="text-align: center;width: 30%;">목적</th>
										<th style="text-align: center;width: 7%;">비용</th>
										<th style="text-align: center;width: 3%;">삭제</th>
									</tr>
								</thead>
								<tbody>
									<tr class="emptyClass">
									<td></td>
									<td></td>
									<td></td>
									<td></td>
									<td></td>
									<td></td>
									<td></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
			</div>

	</div><!-- //sub_contents_wrap -->



</div><!-- iframe wrap -->


<script>

 var onData; /* 온나라 데이터 최초 저장공간 */
 var diffTime; /* 일시분초 차이값 저장공간 */
 var diffTimeCopy; /* 출장집계표에 쓸 일시분초 데이터 저장공간 */
 var clientInfo; /* 사번으로 출장자들의 정보를 가져와 담아둔 공간 */
 var resInfo; /* 결의 정보 */
 var resInfoBudget; /* 예산 정보 */
 var resInfo2; /* 결재 정보 */
 var ch; /* table tr 저장공간 */
 
 
 var resdocseq;
 var budgetseq;
 var resseq;
 var vatfgcode;
 
 var overCost = true;
 
 
$(function(){

	Initt.ajax();

$('input:radio[name=car]').on('click', function(){
		
	costCalculate();
		
	});
	
	
$(document).on('dblclick', '#gridList tbody tr', function(){
		
		if(confirm('출장 정보 수정 시 결재 내역이 초기화 됩니다.')){
			var budgetList = parent.$('#budgetTbl').dzt('getValueAll');

				$.each(budgetList, function (i,v) {
						
					 $.ajax({
							url: "<c:url value='/busTrip/deleteResTrade' />",
							data : {
								
								resDocSeq 		: 	v.resDocSeq, 
								resSeq 			:	 v.resSeq, 
								budgetSeq 		:	 v.budgetSeq
								
							},
							type : 'POST',
							async :false,
							success: function(result){
								console.log("모든 결재내역 초기화");
								parent.preBudgetSeq = null;
								parent.fnTradeSelect(resdocseq, resseq, budgetseq);
								
								var ch =$('#gridList tbody tr').not('.emptyClass');
								
								$.each(ch, function (i,v) {
									
								$(this).attr('trade_seq',''); 
							    $(this).removeClass('used');
								})
							}
							
						}); 
				})
				
			
			
	
	
		var RowPK = $(this).attr("id");
		
		// 해당 ROW값 가져오기
		var BTDateFR = $('#'+RowPK).children('[name=TRIP_DAY_FR]').text();
		var BTDept = $('#'+RowPK).children('[name=dept_name]').text();
		var BTEmp = $('#'+RowPK).children('[name=EP_NAME_KOR]').text();
		var UseYn = $('#'+RowPK).children('[name=USE_CAR]').text();
		
		var rm = $('#'+RowPK).children('[name=TITLE]').text();
		var BTCityCost = $('#'+RowPK).children('[name=accurate_amt]').text();
		
		var BTEmpNo = $('#'+RowPK).children('[name=BTEmpNo]').val();
		var BTTripNo = $('#'+RowPK).children('[name=BTTripNo]').val();
		var BTTimeFR = $('#'+RowPK).children('[name=BTTimeFR]').val();
		var BTTimeEND = $('#'+RowPK).children('[name=BTTimeEND]').val();
		
		
		//hidden input 값 변경해주기
		$("#BTEmpNo").val(BTEmpNo);
		$("#BTTripNo").val(BTTripNo);
		$("#RowPK").val(RowPK);
		
		
		//UI 상 row에 보여지는 값 변경해주기
		$("#BTDept").val(BTDept); //부서
		$("#BTEmp").val(BTEmp); //출장자
		
		$("#BTDateFR").data("kendoDatePicker").value(BTDateFR); //출장일
		$("#BTTimeFR").data("kendoTimePicker").value(BTTimeFR);//출장시작시간
		$("#BTTimeEND").data("kendoTimePicker").value(BTTimeEND);//출장종료시간
		timeCalculate();
		setTime();
		
		
		if(UseYn == '이용함'){ // 차량 유무
			$('#car1').prop('checked',true);
		} else {
			$('#car2').prop('checked',true);
		}

		$("#rm").val(rm); // 목적
		
		$("#BTCityCost").val(BTCityCost); //비용
	
	
	$('#modmod').css('display','block');
	parent.djIframeResize(); 
	
	}
	});
	
});


var Initt = {
		
		fn_kendo 	: function() {},
		
		ajax 			: function() {
			
		
			var data ={emp_erp_num : $('#emp_erp_num').val()};

			
			$.ajax({
				url : "<c:url value='/busTrip/getOrgCode' />",
				data : data,
				type : 'POST',
				async :false,
				success : function(data) {
					console.log(data.result);
					console.log(data.result[0].ORG_CODE);
					$('#org_code').val(data.result[0].ORG_CODE);
					
					}
			});
			
			
			
			$.ajax({
				url: "<c:url value='/busTrip/getBtRowData' />",
				data : {res_doc_seq: parent.resDocSeq},
				type : 'POST',
				async :false,
				success: function(result){
					if (result.result.length > 0) {
						 rowAdd(result.result);
					}
			} 

		});
			
			
		}
}

function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");

}

// 결재 작성중 수정버튼으로 되돌아왔을때 row를 다시 그려주는기능
function rowAdd(a) {
	
	if($(".emptyClass").size() =='1'){
		$("#gridList tbody").empty();
	}
	
	
	$.each(a, function (index, item) {
		
		var data ={erp_emp_num : item.emp_seq }
		
		var deptName ='';
		
		$.ajax({
			url : "<c:url value='/busTrip/addUserInfo' />",
			data : data,
			type : 'POST',
			async :false,
			success : function(data) {
				
				deptName = data.result.dept_name
				
			}	
		});
		
		var html= '';
		
		html += '<tr id="' + item.emp_seq+item.biz_trip_no+ '">';
		html += '<input type="hidden" name="BTEmpNo" value="' + item.emp_seq+ '">';
		html += '<input type="hidden" name="BTTripNo" value="' + item.biz_trip_no+ '">';
		html += '<input type="hidden" name="BTTimeFR" value="' + item.stime+ '">';
		html += '<input type="hidden" name="BTTimeEND" value="' + item.etime+ '">';
		html += '<input type="hidden" name="BTLocation" value="' + item.location+ '">';
		html += '<td name="TRIP_DAY_FR">'+item.date+'</td>';
		html += '<td name="dept_name">'+deptName+'</td>';
		html += '<td name="EP_NAME_KOR">'+item.emp_name+'</td>';
		html += '<td name="USE_CAR">'+item.biz_car_yn+'</td>';
		html += '<td name="TITLE">'+item.purpose+'</td>';
		html += '<td name="accurate_amt">'+item.amt_pay+'</td>';
		html += '<td name="cancelbtn">';
		html += '<span onclick="deleteOnnaraBtRow(\''+ item.emp_seq+item.biz_trip_no + '\')">';
		html += '<img class="closeIco" style="width:15px; height:15px;" src="<c:url value='/Images/ico/close.png'/>" alt="" />';
		html += '<span></td>';
		html += '</tr>';
		
		$("#gridList tbody").append(html);
	
	});
}

//온나라 출장정보 선택시 row 그려주는 기능
function btn_add(sort){
	// 지금은 수정기능이 아니라 sort가 필요없다
	var sort = sort; 
			
	if(sort =='new'){
		
		if($(".emptyClass").size() =='1'){
			$("#gridList tbody").empty();
		}
					
		$.each(onData, function (index, item) {
			
			
			var ch =$('#gridList tbody tr').not('.emptyClass');
			$.each(ch, function (i, v) {
			var empNo= $(v).children('[name=BTEmpNo]').val();
			var dayFr= $(v).children('[name=TRIP_DAY_FR]').text();
			var tripNo= $(v).children('[name=BTTripNo]').val();
			var cost= $(v).children('[name=accurate_amt]').text();
			
				if(item.TRIP_NO !=tripNo && item.EP_NO ==empNo && item.TRIP_DAY_FR == dayFr){
					
					if((Number(item.accurate_amt) + Number(cost)) >20000){
						 alert('당일 기준 여비금액 제한은 20000원입니다.\n출장정보를 수정해주시기 바랍니다.');
					 overCost = false;
						return false;
					} else{
						overCost = true;
					}
					
				}
				
			})
			
			var FrDay = item.TRIP_DAY_FR
			var ToDay = item.TRIP_DAY_TO
			
			if(FrDay == ToDay){
				
			
			var html= '';
			
			html += '<tr id="' + item.EP_NO+item.TRIP_NO+ '">';
			html += '<input type="hidden" name="BTEmpNo" value="' + item.EP_NO+ '">';
			html += '<input type="hidden" name="BTTripNo" value="' + item.TRIP_NO+ '">';
			html += '<input type="hidden" name="BTTimeFR" value="' + item.TRIP_TIME_FR+ '">';
			html += '<input type="hidden" name="BTTimeEND" value="' + item.TRIP_TIME_TO+ '">';
			html += '<input type="hidden" name="BTLocation" value="' + item.TRIP_LOCAL+ '">';
			html += '<td name="TRIP_DAY_FR">'+item.TRIP_DAY_FR+'</td>';
			html += '<td name="dept_name">'+item.dept_name+'</td>';
			html += '<td name="EP_NAME_KOR">'+item.EP_NAME_KOR+'</td>';
			html += '<td name="USE_CAR">'+item.USE_CAR+'</td>';
			html += '<td name="TITLE">'+item.TITLE+'</td>';
			html += '<td name="accurate_amt">'+item.accurate_amt+'</td>';
			html += '<td name="cancelbtn">';
			html += '<span onclick="deleteOnnaraBtRow(\''+ item.EP_NO+item.TRIP_NO + '\')">';
			html += '<img class="closeIco" style="width:15px; height:15px;" src="<c:url value='/Images/ico/close.png'/>" alt="" />';
			html += '<span></td>';
			html += '</tr>';
			
			$("#gridList tbody").append(html);
			
			}
			
			else{
				var t1 = moment(FrDay, 'YYYY-MM-DD HH:mm');
				var t2 = moment(ToDay, 'YYYY-MM-DD HH:mm');
				
				var diffDay = 	 moment.duration(t2.diff(t1)).days();
				
				var value =1;
				var plusDay =0;
				while (value < diffDay+2){
					
					var FrArray = FrDay.split('-');
					
					var day = Number(FrArray[2])+plusDay;
					
					var fullDay = FrArray[0]+'-'+FrArray[1]+'-'+day;
					
				var html= '';
				
				html += '<tr id="' + item.EP_NO+item.TRIP_NO+'_'+value+ '">';
				html += '<input type="hidden" name="BTEmpNo" value="' + item.EP_NO+ '">';
				html += '<input type="hidden" name="BTTripNo" value="' + item.TRIP_NO+ '">';
				html += '<input type="hidden" name="BTTimeFR" value="' + item.TRIP_TIME_FR+ '">';
				html += '<input type="hidden" name="BTTimeEND" value="' + item.TRIP_TIME_TO+ '">';
				html += '<input type="hidden" name="BTLocation" value="' + item.TRIP_LOCAL+ '">';
				html += '<td name="TRIP_DAY_FR">'+fullDay+'</td>';
				html += '<td name="dept_name">'+item.dept_name+'</td>';
				html += '<td name="EP_NAME_KOR">'+item.EP_NAME_KOR+'</td>';
				html += '<td name="USE_CAR">'+item.USE_CAR+'</td>';
				html += '<td name="TITLE">'+item.TITLE+'</td>';
				html += '<td name="accurate_amt">'+item.accurate_amt+'</td>';
				html += '<td name="cancelbtn">';
				html += '<span onclick="deleteOnnaraBtRow(\''+ item.EP_NO+item.TRIP_NO+'_'+value + '\')">';
				html += '<img class="closeIco" style="width:15px; height:15px;" src="<c:url value='/Images/ico/close.png'/>" alt="" />';
				html += '<span></td>';
				html += '</tr>';
				
				$("#gridList tbody").append(html);
				
				value++;
				plusDay++;
				}
			}
		
		});
	
		
	}

}

// 로우 삭제 기능
function deleteOnnaraBtRow(rownum) {
	
	
	
	if($("#gridList tbody tr").size() =='1' && !$(".emptyClass").hasClass("emptyClass")){
		var noRow ='';
		
		noRow += '<tr class="emptyClass"> ';
		noRow += '<td></td>               ';
		noRow += '<td></td>               ';
		noRow += '<td></td>               ';
		noRow += '<td></td>               ';
		noRow += '<td></td>               ';
		noRow += '<td></td>               ';
		noRow += '<td></td>               ';
		noRow += '</tr>                   ';
		
		$("#gridList tbody").append(noRow);
		
	}
		$("#" + rownum).remove();
		
		//onData에서 삭제한 행과 같은 정보를 지우는 기능인데 onData를 계속 사용할게아니라 주석처리함
		
		/* var idx = onData.findIndex(function(item) {
			
			return item.EP_NO+item.TRIP_NO == rownum
			
		})
		
		
		if(idx > -1 ) {
			onData.splice(idx,1);
			
		} */
		
		parent.djIframeResize(); 
	
}


/* 온나라 출장정보 조회 팝업창 */
function getOnNaraBustrip(e) {
	
	var url = _g_contextPath_ + "/busTrip/onnaraBtPop"+"?orgCode="+$('#org_code').val()+"&dept_seq="+$('#dept_seq').val();
	
	window.name = "parentWindow";
	var openWin = window.open(url,"childWindow","width=1100, height=700, resizable=no , scrollbars=no, status=no, top=50, left=150","newWindow");
}


// 온나라  출장팝업에서 실행하는 함수 btn_add에 온나라 출장 row정보를 보내기위해서
function testvalue(arr) {

	 onData = JSON.parse(arr); 
	 btn_add('new'); 
	/* parent.djIframeResize();  */
	
	
}


	var startTime = $('#BTTimeFR').kendoTimePicker({
		culture: "kr-KR",
		format: "HH:mm",
		interval: 30,
		min : (new Date(2000, 0, 1, 0, 30, 0)),
		max :(new Date(2099, 0, 1, 23, 30, 0)),
	    change: startChange
	}).attr("readonly", true).data("kendoTimePicker");

	var endTime = $('#BTTimeEND').kendoTimePicker({
		culture: "kr-KR",
		format: "HH:mm",
		interval: 30,
		// 연, 월(0~11), 일, 시 , 분 , 초
		min : (new Date(2000, 0, 1, 0, 30, 0)),
		max :(new Date(2099, 0, 31, 23,30, 0)),
	    change: endChange
	}).attr("readonly", true).data("kendoTimePicker");

	function startChange(){
		if(startTime.value() > endTime.value()){
			endTime.value('');
		}
		var sTime = new Date(startTime.value());
		endTime.min(sTime);
		
		if(endTime.value() == null){
			 $('#timeHour').text('0');
			 $('#timeMinute').text('0');
		}else{
			timeCalculate();
			setTime();
			costCalculate();
		}
	}
	function endChange(){
		
		if(startTime.value() == null){
			 $('#timeHour').text('0');
			 $('#timeMinute').text('0');
		}else{
			timeCalculate();
			setTime();
			costCalculate();
		}
	}
	
	var btDate = $('#BTDateFR').kendoDatePicker({
	    culture : "ko-KR",
	    format : "yyyy-MM-dd",
	}).attr("readonly", true).data("kendoDatePicker");

	
	//비용계산 로직
	function costCalculate() {
		
		// 차량유무와 시간값 가져와서 비용 계산하기
		var carYn = $('input[name=car]:checked').val();
		
		 $.ajax({
				url : "<c:url value='/busTrip/getCityCostList' />",
				data : { 
					"code_car" : carYn,
					"day"		:$('#BTDateFR').val()
					},
				type : 'POST',
				async: false,
				success : function(result) {
					
					
					$.each(result.list , function (i,v) {
						var a =eval(result.list[i].code_time_val+result.list[i].code_time_math+diffTime.hour);
						if(a){
							
							$('#BTCityCost').val(result.list[i].accurate_amt); 
						
						}	
					
					
					})
			       
				}	
			});
		
		
		
	}
	
	// 집계표에 들어갈 시간값 구하는거 귀찮아서 복붙해서씀 diffTimeCopy에 저장함
	function timeCalculateCopy(a,b) {
		
		var t1 = moment(a, 'HH:mm');
		var t2 = moment(b, 'HH:mm');
		
		 diffTimeCopy = {
					hour : moment.duration(t2.diff(t1)).hours(),
					minute : moment.duration(t2.diff(t1)).minutes(),
					second : moment.duration(t2.diff(t1)).seconds()
			}
	}
	
	function TotalCalculate() {
		
	}
	
	//시간차이 구하기
	function timeCalculate() {
		
		var t1 = moment(startTime.value(), 'YYYY-MM-DD HH:mm');
		var t2 = moment(endTime.value(), 'YYYY-MM-DD HH:mm');
		
			
		 diffTime = {
				day : moment.duration(t2.diff(t1)).days(),
				hour : moment.duration(t2.diff(t1)).hours(),
				minute : moment.duration(t2.diff(t1)).minutes(),
				second : moment.duration(t2.diff(t1)).seconds()
		}
		 
	}
	
	function setTime() {
		if(diffTime )
		 $('#timeHour').text(diffTime.hour);
		 $('#timeMinute').text(diffTime.minute);
	}
	
	//수정 취소시 값 비우기
	function cancelMod() {
		$('#modmod').css('display','none');
		$('.dataInputt').val('');
		
		$("#BTDateFR").data("kendoDatePicker").value('');
		
		$('#car1').prop('checked',false);
		$('#car2').prop('checked',false);
		startTime.value('');
		endTime.value('');
		$('#timeHour').text('0');
		$('#timeMinute').text('0');
		
		diffTime =null;
		
		/* parent.djIframeResize();  */
		
		
	}
	
	//값 수정
	function modSave() {
		
		var BTEmpNo = $('#BTEmpNo').val(); //출장자 emp번호
		var BTTripNo = $('#BTTripNo').val();// 온나라 출장번호
		var BTTimeFR = $('#BTTimeFR').val(); // 출장시작 시간
		var BTTimeEnd = $('#BTTimeEND').val();// 출장 종료시간
		
		var BTDept = $('#BTDept').val(); // 출장자 부서
		var BTEmp = $('#BTEmp').val(); // 출장자 이름
		var RowPK = $('#RowPK').val(); // row/ ondata안에 있는 pk (출장자번호+출장번호로 되어있음)
		var BTDateFR = $('#BTDateFR').val();  // 출장일
		var rm = $('#rm').val(); // 타이틀 (목적)
		var BTCityCost = $('#BTCityCost').val(); // 비용
		var CarYn = $('input[name=car]:checked').val(); // 차량유무
		
		
		//UI 상 row에 보여지는 값 변경해주기
		
		$('#'+RowPK).children('[name=TRIP_DAY_FR]').text(BTDateFR);
		$('#'+RowPK).children('[name=dept_name]').text(BTDept);
		$('#'+RowPK).children('[name=EP_NAME_KOR]').text(BTEmp);
		$('#'+RowPK).children('[name=USE_CAR]').text(CarYn);
		$('#'+RowPK).children('[name=TITLE]').text(rm);
		$('#'+RowPK).children('[name=accurate_amt]').text(BTCityCost);
		
		//hidden input 값 변경해주기
		$('#'+RowPK).children('[name=BTEmpNo]').val(BTEmpNo);
		$('#'+RowPK).children('[name=BTTripNo]').val(BTTripNo);
		$('#'+RowPK).children('[name=BTTimeFR]').val(BTTimeFR);
		$('#'+RowPK).children('[name=BTTimeEND]').val(BTTimeEnd);
		
		//온클릭 이벤트 변경
		$('#'+RowPK).children('[name=cancelbtn]').children('span').attr('onclick',"deleteOnnaraBtRow('"+BTEmpNo+BTTripNo+"')");
		
		// RowPK 변경
		$('#'+RowPK).attr('id', BTEmpNo+BTTripNo);
		
		//UI에 보여지는 값 초기화
		cancelMod();
		
		checkOverCost();
		
	}
	
	//출장정보 일괄반영
	function tripTradeProcess(resDocSeq, resSeq, budgetSeq, vatFgCode) {
		
		checkOverCost();
		
		if(!overCost){
			return;
		}
		
		resdocseq =resDocSeq;
		resseq = resSeq;
		budgetseq = budgetSeq;
		vatfgcode = vatFgCode;
		
		var url = _g_contextPath_ + "/busTrip/ban0Pop";

		var rowHeight = $('#gridList').height()+ 150;
		
		window.name = "parentWindow3";
		var openWin = window.open(url,"childWindow3","width=1480, height="+rowHeight+", resizable=no , scrollbars=no, status=no, top=150, left=150","newWindow");
		
			
	}
	
	function tripTradeProcess2(arr) {
		
		var ch = arr;
		
		if(ch.length == 0){
			alert("출장정보를 입력하세요");
		} else{
			
			var data = new Array();
			var data2 = new Array();
			
			$.each(ch, function(i,v){
				var amtInfo= {
						emp_no : $(v).children('[name=BTEmpNo]').val(),
						amt		: $(v).children('[name=accurate_amt]').text()
				};
				
				data.push($(v).children('[name=BTEmpNo]').val());
				data2.push(amtInfo);
			});
			
			var a = data.join();
			
			$.ajax({
				url: "<c:url value='/busTrip/getClientInfo' />",
				data : {EMP_NO_JOIN : a},
				type : 'POST',
				async :false,
				success: function(result){
					//배열로 넘어온 정보 저장
					clientInfo = result.result;
					
				}
				
			}); 
			  $.ajax({
				url: "<c:url value='/busTrip/deleteResTrade' />",
				data : {
					
					resDocSeq 		: 	resdocseq, 
					resSeq 			:	 resseq, 
					budgetSeq 		:	 budgetseq
					
				},
				type : 'POST',
				async :false,
				success: function(result){
					console.log("restrade data 딜리트");
					
				}
				
			});   
			
		}
		
			 $.each(data2, function(i,v){
				 
				var trade_amt =0 ;
				var trade_std_amt =0;
				var trade_vat_amt =0;
				
				 if(vatfgcode == 1){
						trade_amt = v.amt;
						trade_std_amt= Math.round(v.amt/11*10);
						trade_vat_amt = Math.round(v.amt/11);
					}  else {
						trade_amt = v.amt;
						trade_std_amt= v.amt;
					}
				 
				var empNo = v.emp_no;
				var trSeq		="";	
				var trName		="";	
				var trAddr		="";	
				var ceoName		="";	
				var businessNb	="";	
				var baNb		="";	
				var btrSeq		="";	
				var btrName		="";	
				var depositor	="";
				
				$.each(clientInfo, function(i,v){
					if(v.EMP_CD == empNo){
						
						
						trSeq		= v.TR_CD;
						trName		= v.TR_NM;
						trAddr		= v.ADDR;
						ceoName		= v.CEO_NM;
						businessNb	= v.REG_NB;
						baNb		= v.BA_NB;
						btrSeq		= v.JIRO_CD;
						btrName		= v.BANK_NM;
						depositor	= v.DEPOSITOR;
						

				
				var aaa ={
					resDocSeq	 	: 	resdocseq,
					resSeq	 		:	resseq,
					budgetSeq 		:	budgetseq,
					empSeq			:	$('#emp_seq').val(),
					empName			:	$('#emp_name').val(),
					
					trSeq			:	trSeq,
					trName			:	trName,
					trAddr			:	trAddr,
					ceoName			:	ceoName,
					businessNb		:	businessNb,
					baNb			:	baNb,
					btrSeq			:	btrSeq,
					btrName			:	btrName,
					depositor		:	depositor,
					
					tradeAmt 		:	trade_amt,
					tradeStdAmt		:	trade_std_amt,
					tradeVatAmt		:	trade_vat_amt,
						
				}
				
				$.ajax({
					url: "<c:url value='/busTrip/insertResTrade' />",
					data : aaa,
					type : 'POST',
					async :false,
					success: function(result){
						insertDefaultBojo(result.trade_seq, resdocseq, resseq); 
					}
					
				}); 
				
			}; 
			
			 });
			
			
		});
			
			//더존 지출결의서 결의정보 불러오는 함수 실행하기
			parent.preBudgetSeq = null;
			parent.fnTradeSelect(resdocseq, resseq, budgetseq);
			beforeDeleteBiz(resdocseq);
			insertBizData(ch);
			
			
	}
	
	
	//결재작성 버튼 누르면 실행되는 함수 
	function djCustApproval() {
		
		
	}
	function beforeDeleteBiz(resdocseq) {
		

		data = {res_doc_seq : resdocseq};
		
		$.ajax({
			url: "<c:url value='/busTrip/beforeDeleteBiz' />",
			data : data,
			type : 'POST',
			async :false,
			success: function(result){
				console.log('출장data 삭제성공');
		} 
	});
	}
		
	
	function insertBizSubData(pk,sub) {
		
		sub.biz_common_seq = pk;
		
		$.ajax({
			url: "<c:url value='/busTrip/insertBizSub' />",
			data : sub,
			type : 'POST',
			async :false,
			success: function(result){
				console.log('sub 인서트 성공');
				/* $('#'+sub.emp_seq+sub.biz_trip_no).append("<input type='hidden' name='trade_seq' value='"+sub.trade_seq+"'>"); */
				/*  $('#'+sub.PK).attr("trade_seq",sub.trade_seq); 
				 $('#'+sub.PK).addClass("used");  */
				
				
		} 

	
		
	});
		
	}
	
	// 출장일괄반영 버튼시  정보 저장하기
	function setLastInfo(a,b) {
		resInfo = a;
		resInfo2 = b;
		resInfoBudget =parent.$('#budgetTbl').dzt('getValueAll');
	}
	
	// 출장 db 조회해서 엑셀파일에 집계표만들기
	function makeExcel(fileKey) {
		console.log("1");
		var arr =[];
		
		var resDocSeq = {res_doc_seq : parent.resDocSeq};
		
		$.ajax({
			url: "<c:url value='/busTrip/getBtRowData' />",
			data : resDocSeq,
			type : 'POST',
			async :false,
			success: function(result){
				console.log("2");
				console.log('성공 : ' + result.result )
				
				$.each( result.result , function (index, item) {
					
					timeCalculateCopy(item.stime, item.etime);
					
					var data = {
							file_key	: 	fileKey,/* 파일키는 저장경로에 폴더명으로 쓰이는 값이라 그냥 여기 담아서보냄 1개만있어도되는데 ㅎㅎ  */							
							orderNb 	:	index +1,	/* 컨트롤러단에서 분기처리 비교할때 계좌번호랑 같이 쓰려고 order 넘버를 넣었음  */						
							depositor 	:	item.depositor,
							bankNb 		:	item.bank_nb,
							date 		: 	item.date,
							stime		: 	item.stime,
							etime		: 	item.etime,
							hour		: 	diffTimeCopy.hour,
							purpose		: 	item.purpose,
							location	:	item.location,
							carYn		: 	item.biz_car_yn,
							amt			: 	item.amt_pay,
							useYn		: 	'N', /* 엑셀만들때 한번 쓰인 값인지 아닌지 확인하려고 */
							
						}
					console.log(data);
						
						arr.push(data);

				});
					console.log(arr);

		} 

	});
		
		console.log("3");
		
		
		var aaa = JSON.stringify(arr);
		
	$.ajax({
			url: "<c:url value='/busTrip/makeExcel' />",
			dataType:'json',
			data : aaa,
			type : 'POST',
			async :false,
			contentType : "application/json; charset=UTF-8",
			success: function(result){
				console.log("4");
				cosole.log("엑셀파일 생성완료");
		} 


	});  



	
	
	}
	
	function insertDefaultBojo(trade, resDoc, res) {
			
		data ={
				resDocSeq		:		resDoc		,
				resSeq			:		res			,
				tradeSeq 		: 		trade 		,
				bojoCode 		: 		2			,
				bojoUse			: 		'미사용'	,
				bojoReasonCode 	: 		0			,
				bojoReasonText	: 		''			,
		}
				
			
			$.ajax({
				url: "<c:url value='/resAlphaG20/saveTradeBojo' />",
				data : data,
				type : 'POST',
				async :false,
				success: function(result){
					console.log('보조 디폴트 인서트');
			} 
	
		
			
		});
			
		}
	
	

	
	function insertBizData(ch) {
		
		resInfo = parent.$('#resTbl').dzt('getValue');
		resInfo2 =parent.$('#tradeTbl').dzt('getValueAll');
		resInfoBudget =parent.$('#budgetTbl').dzt('getValueAll');
		
			var masterData = new Array();
			var subData = new Array();
			
			/* ch = $('#gridList tbody tr').not(".emptyClass"); */
			
			$.each(ch, function(i,v){
				  data ={
						
						writer_emp_seq				:		$('#emp_seq').val(),
						writer_emp_name				:		$('#emp_name').val(),
						project_name				:		resInfo.erpMgtName ,
						pjt_cd						:		resInfo.erpMgtSeq ,
						status						:		"",
						order_no					:		"",
						remark						:		"",
						res_doc_seq 				:		 resInfo.resDocSeq ,
						trade_seq 					:		 resInfo2[i].tradeSeq ,
						budget_seq 					:		 resInfo2[i].budgetSeq ,
					
					}
				  
				  subData = {
						PK						:    	$(v).find("input[type='checkbox']").attr('id'),
						emp_name				:		$(v).children('[name=EP_NAME_KOR]').text(),
						emp_seq					:		$(v).children('[name=BTEmpNo]').val(),
						date					:		$(v).children('[name=TRIP_DAY_FR]').text(),
						stime 					:		$(v).children('[name=BTTimeFR]').val(),
						etime 					:		$(v).children('[name=BTTimeEND]').val(),
						location 				:		$(v).children('[name=BTLocation]').val(),
						biz_car_yn 				:		$(v).children('[name=USE_CAR]').text(),
						purpose 				:		$(v).children('[name=TITLE]').text(),
						
						bank_name 				:		resInfo2[i].btrName ,
						bank_seq 				:		resInfo2[i].btrSeq,
						bank_nb 				:		resInfo2[i].baNb ,
						depositor 				:		resInfo2[i].depositor ,
						biz_trip_no 			:		$(v).children('[name=BTTripNo]').val(),
						trade_seq 				:		 resInfo2[i].tradeSeq ,
						amt_pay					:		resInfo2[i].tradeAmt.toMoney2() ,
				  }
				
				  // 자바단에서 이미 있으면 update문 타게 처리하자
				$.ajax({
					url: "<c:url value='/busTrip/insertBizCommon' />",
					data : data,
					type : 'POST',
					async :false,
					success: function(result){
						console.log('common 인서트 성공');
						console.log(result);
						console.log(result.biz_common_seq);
						
						insertBizSubData(result.biz_common_seq, subData); 
				} 
		
			
				
			});
			
		
		});
			
		 	
	}
	
	function checkOverCost() {
		overCost =true;
		
		var ch =$('#gridList tbody tr').not('.emptyClass');
		
		$.each(ch, function (index,item) {
		
			$.each(ch, function (i, v) {
			var empNo= $(v).children('[name=BTEmpNo]').val();
			var dayFr= $(v).children('[name=TRIP_DAY_FR]').text();
			var tripNo= $(v).children('[name=BTTripNo]').val();
			var cost= $(v).children('[name=accurate_amt]').text();
			
				if($(item).children('[name=BTTripNo]').val() !=tripNo && $(item).children('[name=BTEmpNo]').val() ==empNo && $(item).children('[name=TRIP_DAY_FR]').text() == dayFr){
					
						console.log("asd"+(Number($(item).children('[name=accurate_amt]').text()) + Number(cost)));
					if((Number($(item).children('[name=accurate_amt]').text()) + Number(cost)) >20000){
						console.log((Number($(item).children('[name=accurate_amt]').text()) + Number(cost)));
						 alert('당일 기준 여비금액 제한은 20000원입니다.\n출장정보를 수정해주시기 바랍니다.');
					 overCost = false;
					 return;
						
					} else{
						overCost = true;
					}
					
				} 
				
			})
		
		})
	}
	
/* 	function removeUsed(tradeSeq) {
		
		var qw = $('.used').closest('tr');

		$.each(qw, function(i,v){

		console.log( $(v).attr('trade_seq')) 

		if($(v).attr('trade_seq') == tradeSeq){
		    $(this).attr('trade_seq',''); 
		    $(this).removeClass('used');
		}


		});
	} */
</script>
</body>

