<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<script type="text/javascript"	src='<c:url value="/js/common/commFileUtil.js"></c:url>'></script>
<script type="text/javascript" src="/CustomNPEPIS/js/jquery.form.js"></script>
<script type="text/javascript"	src='<c:url value="/js/ac/acUtil.js"></c:url>'></script>

<body>
	<div class="iframe_wrap" style="min-width: 1100px">
		<input type="hidden" id="comp_seq" value="${loginVO.compSeq }" /> 
		<input type="hidden" id="emp_seq" value="${loginVO.uniqId }" /> 
		<input	type="hidden" id="emp_name" value="${loginVO.name }" /> 
		<input type="hidden" id="emp_erp_num" value="${loginVO.erpEmpCd }" /> 
		<input	type="hidden" id="org_code" value="" /> 
		<input type="hidden"	id="dept_seq" value="${loginVO.orgnztId}" /> 
		<input type="hidden"	id="CoCd" value="${loginVO.erpCoCd }" />
		
		<!-- 컨텐츠타이틀영역 -->
		<div class="sub_title_wrap">


			<div class="title_div">
				<h4>시외출장</h4>
			</div>
		</div>

		<div class="sub_contents_wrap">
			<div class="btn_div">
				<span class="tit_p mt5 mb0">시외 출장</span>
				<div class="right_div">
					<div class="controll_btn p0 fr ml10"">
						<button style="margin-right: 10px; border: 2px solid blue !important;"type="button" onclick="getOnNaraBustrip();">출장 선택</button>
					</div>
				</div>
			</div>

			<div class="com_ta4 mt15">
				<div id="gridList">
					<table>
						<thead>
							<tr>
								<th style="text-align: center; width: 7%;">출발일</th>
								<th style="text-align: center; width: 7%;">복귀일</th>
								<th style="text-align: center; width: 10%;">부서</th>
								<th style="text-align: center; width: 8%;">성명</th>
								<th style="text-align: center; width: 15%;">장소</th>
								<th style="text-align: center; width: 30%;">목적</th>
								<th style="text-align: center; width: 3%;">삭제</th>
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
			<br>
			<div class="com_ta">
				<div class="top_box gray_box">
					<dl>
						<!-- BTTripNo : 온나라 출장번호 / BTEmpNo : 출장자 사번 / RowPk : PK로 잡을게 없어서 사번+출장번호로 행마다 ID값 부여 -->
						<input type="hidden" id="BTTripNo" class="dataInputt " />
						<input type="hidden" id="BTEmpNo" class="dataInputt" />
						<input type="hidden" id="RowPK" class="dataInputt" />
						<input type="hidden" id="deptPostionCode" class="dataInputt" />
						<input type="hidden" id="deptseq" class="dataInputt" />
						<dt style="width: 5%; text-align: center;">부서</dt>
						<dd style="line-height: 25px; width: 10%;">
							<input type="text" id="BTDept" class="dataInputt"style="width: 180px;" readonly="readonly">
						</dd>
						<dt style="width: 5%; text-align: center;">출장자</dt>
						<dd style="line-height: 25px; width: 10%;">
							<input type="text" id="BTEmp" style="width: 180px;"	class="dataInputt" readonly="readonly">
						</dd>
						<dt style="width: 5%; text-align: center;">출장일</dt>
						<dd style="line-height: 25px; width: 10%;">
							<input type="text" id="BTDateFR" style="width: 180px;"	readonly="readonly">
						</dd>
						<dt style="width: 2%;">
							<span> ~ </span>
						</dt>
						<dd style="line-height: 25px; width: 10%;">
							<input type="text" id="BTDateTO" style="width: 180px;"	readonly="readonly">
						</dd>
						<dt style="width: 5%; text-align: center;">출장지</dt>
						<dd style="width: 15%">
							<input style="width: 98%" type="text" id='BTLocation' class='dataInputt'>
						</dd>
					</dl>
					<dl>
						<dt style="width: 5%; text-align: center;">목적</dt>
						<dd style="width: 81%;">
							<input type="text" id="rm" style="min-width: 100%;" class="dataInputt" />
						</dd>
					</dl>
				</div>

				<br />
				<div class="com_ta noselect">
					<div class="top_box gray_box testc">
						<dl>
							<dt style="margin-top: 9px; margin-left: 30px;">출장일</dt>
							<dd style="padding: 9px;">
								<input type="text" id="biz_day">
							</dd>
							<dl>
							</dl>
							<dt style="margin-top: 9px;">교통수단</dt>
							<dd style="padding: 9px;">
								<input type="text" id='trafic_way'>
							</dd>

							<span id="trainWay" style="display: none;">
								<dt style="margin-top: 9px;">출발 비용</dt>
								<dd>
									<span class="controll_btn">
										<button type="button" onclick="apiPop('depCost')">선택</button>
									</span>&emsp;&emsp; 
										<input	type="text" class='dataInputt dataInputNumber2' id='depCost'>원
								</dd>
								<dt style="margin-top: 9px;">복귀 비용</dt>
								<dd>
									<span class="controll_btn "><button type="button" onclick="apiPop('arrCost')">선택</button></span>&emsp;&emsp; 
									<input	type="text" class='dataInputt dataInputNumber2' id="arrCost">원
								</dd>
							</span>

							<span id="busWay" style="display: none;">
								<dt style="margin-top: 9px;">출발 비용</dt>
								<dd style="padding: 9px;">
									<input type="text" style="text-align: center;" id='depBusCost' class='dataInputNumber2'> 원
								</dd>
								<dt style="margin-top: 9px;">복귀 비용</dt>
								<dd style="padding: 9px;">
									<input type="text" style="text-align: center;" id='arrBusCost'	class='dataInputNumber2'> 원
								</dd>
							</span>
							<span id="shipWay" style="display: none;">
								<dt style="margin-top: 9px;">출발 비용</dt>
								<dd style="padding: 9px;">
									<input type="text" style="text-align: center;" id='depShipCost'  class='dataInputNumber2'> 원
								</dd>
								<dt style="margin-top: 9px;">복귀 비용</dt>
								<dd style="padding: 9px;">
									<input type="text" style="text-align: center;" id='arrShipCost' class='dataInputNumber2'> 원
								</dd>
							</span>
							<span id="airportWay" style="display: none;">
								<dt style="margin-top: 9px;">출발 비용</dt>
								<dd style="padding: 9px;">
									<input type="text" style="text-align: center;" id='depAirCost' class='dataInputNumber2'> 원
								</dd>
								<dt style="margin-top: 9px;">복귀 비용</dt>
								<dd style="padding: 9px;">
									<input type="text" style="text-align: center;" id='arrAirCost' class='dataInputNumber2'> 원
								</dd>
							</span>

							<span id="carWay" style="display: none;">
								<dt style="margin-top: 9px;">업무차량</dt>
								<dd style="padding: 9px;">
									<input type="radio" name="car" id="car1" value="이용함" onclick="addTransport()"> <label for="car1">사용</label>&emsp;&emsp;
									<input type="radio"	name="car" id="car2" value="이용안함" onclick="addTransport()"> <label for="car2">미사용</label>
								</dd>
							</span>
							<span class='controll_btn' style="float: right; "><input class='mt15 commas' type="text"  id='transportCost'> <button style="margin-top: 15px; margin-right: 20px;"  type="button" onclick="addTransportCost()">추가</button> </span>
							
						</dl>
						
						<dl>
							<span id="carWayNo" style="display: none;">
								<dt style="margin-top: 9px;">이동거리</dt>
								<dd style="padding: 9px;">
									<input type="text" class='dataInputt' id='moveKM'>
									&nbsp;km
								</dd>
								<dt style="margin-top: 9px;">주유일</dt>
								<dd style="padding: 9px;">
									<input type="text" id="UgaDay">
								</dd>
								<dt style="margin-top: 9px;">유류</dt>
								<dd style="padding: 9px;">
									<input id="oilType" type="text">
								</dd>
								<dt style="margin-top: 9px; color: red">연비 :</dt>
								<dd id="dusql" style="color: red; margin-top: 30px;"></dd>
								<dt style="margin-top: 9px;">지역</dt>
								<dd>
									<input type="text" id="sido" style="width: 80px;"> <input type="text" id='Uga' class='dataInputt' readonly="readonly"	style="text-align: center;"> &nbsp;원 
									<span class="controll_btn p1">
										<button style="margin-right: 10px;" type="button" onclick="ugaCal();">유류 계산</button>
									</span>
								</dd>
							</span>
						</dl>
					</div>
					<div class="com_ta4 mt15">
					<div id="gridList3">
					<table>
						<thead>
							<tr>
								<th style="text-align: center; width: 7%;">교통수단</th>
								<th style="text-align: center; width: 7%;">업무차량 사용여부</th>
								<th style="text-align: center; width: 10%;">금액</th>
								<th style="text-align: center; width: 3%;">삭제</th>
							</tr>
						</thead>
						<tbody>
						</tbody>
					</table>
				</div>
				</div>
					<br>
					<div class="top_box gray_box">
						<dl>
							<dt style="margin-top: 9px; margin-left: 30px;">식비</dt>
							<dd style="padding: 9px; margin-left: 25px;">
								<input id="giveFood" type="text"> <input id="foodCost" 	type="text" class='dataInputNumber' disabled="disabled">
								원
							</dd>
							<dt style="margin-top: 9px; margin-left: 30px;">일비</dt>
							<dd style="padding: 9px;">
								<span id="carcarSpan" style="display: none;"><input id="carcar" type="text"></span><input id="reduceDayCost" type="text"> <input id="dayCost" type="text" class='dataInputNumber' disabled="disabled"> 원
							</dd>
						</dl>
						<dl>
							<dt style="margin-top: 9px;">증빙(개인)</dt>
							<dt style="margin-top: 9px; margin-left: 45px;">교통비</dt>
							<dd style="padding: 9px;">
								<input id="traficCost" type="text" class='dataInputNumber' readonly="readonly">
								원
							</dd>
							<dt style="margin-top: 9px;">숙박비</dt>
							<dd style="padding: 9px;">
								<input id="giveRoom" type="text"> <span	style="display: none;" id="areaSort"> <input id="area" type="text">
								</span> <input id="roomCost" type="text" class='dataInputNumber' disabled="disabled"> 원
							</dd>
							<dt style="margin-top: 9px;">기타 (주차비 등)</dt>
							<dd style="padding: 9px;">
								<input id="etcCost" type="text" class='dataInputNumber'>
								원
							</dd>

						</dl>
						<dl>
							<dt style="margin-top: 9px;">증빙(법인카드)</dt>
							<dt style="margin-top: 9px; margin-left: 20px;">교통비</dt>
							<dd style="padding: 9px;">
								<input type="text" id="trafic_cost_card" class='dataInputt'	disabled="disabled"> 원
							</dd>
							<dt style="margin-top: 9px;">숙박비</dt>
							<dd style="padding: 9px;">
								<input type="text" id="room_cost_card" class='dataInputt' disabled="disabled"> 원
							</dd>
							<dt style="margin-top: 9px; margin-left: 20px;">기타 (주차비 등)</dt>
							<dd style="padding: 9px;">
								<input type="text" id="etc_cost_card" class='dataInputt' disabled="disabled"> 원
							</dd>
						</dl>
						<dl>
							<dt style="margin-top: 9px;">증빙(법인카드)</dt>
							<dd style="width: 50%" id="cjaqn2">
								<span class='controll_btn'><button
										class="controll_btn p1" id="btnTradeCard2">선택</button></span>
							</dd>
							<form id="fileForm" method="post" enctype="multipart/form-data"	class="hidden">
								<input type="file" id="attachFile2" name="file_name" multiple="multiple" value="" /> 
								<input type="hidden" id="fileType" name="fileType" value="" />
							</form>
						</dl>
						<dl>
							<dt style="margin-top: 9px; margin-left: 30px;">합계</dt>
							<dd
								style="line-height: 25px; margin-left: 30px; width: 16%; padding: 9px">
								<input type="text" class='dataInputt' id="totalCos" style="width: 200px;" class="requirement dataInputNumber" readonly="readonly"> 원
							</dd>
						</dl>
					</div>
					<br>
					<div class="top_box gray_box" id="cjaqnDiv">
						<span style="color: red;">※ 첨부자료는 최소 한 개 이상 첨부해야 합니다.</span> <br>
						<span style="color: red;">중복 자료는 첨부하지 않도록 유의해주세요..(ex.
							교통수단증빙으로 출장이행확인되는 경우 등)</span>

						<dl>
							<dt style="margin-top: 9px; text-align: center; width: 10.7%;">출장이행확인	첨부</dt>
							<dd style="width: 20%" id="cjaqn1">
								<span class='controll_btn'>
									<button	class="controll_btn p1" onclick="fnFileOpen(1)">선택</button>
								</span>
							</dd>
							<form id="fileForm" method="post" enctype="multipart/form-data"	class="hidden">
								<input type="file" id="attachFile1" name="file_name" multiple="multiple" value="" /> 
								<input type="hidden" id="fileType" name="fileType" value="" />
							</form>
						</dl>
						</dl>
						<dl>
							<dt style="margin-top: 9px; text-align: center; width: 10.7%">교통수단증빙 첨부</dt>
							<dd style="width: 70%" id="cjaqn3">
								<span class='controll_btn'>
									<button class="controll_btn p1" onclick="fnFileOpen(3)">선택</button>
								</span>
							</dd>

							<form id="fileForm" method="post" enctype="multipart/form-data"	class="hidden">
							
								<input type="file" id="attachFile3" name="file_name" multiple="multiple" value="" /> 
								<input type="hidden"	id="fileType" name="fileType" value="" />
							</form>
						</dl>
						<dl>
							<dt style="margin-top: 9px; text-align: center; width: 10.7%;">교통수단(기타)증빙
								첨부</dt>
							<dd style="width: 70%" id="cjaqn4">
								<span class='controll_btn'><button
										class="controll_btn p1" onclick="fnFileOpen(4)">선택</button></span>
							</dd>

							<form id="fileForm" method="post" enctype="multipart/form-data"	class="hidden">
								<input type="file" id="attachFile4" name="file_name" multiple="multiple" value="" />
								 <input type="hidden" id="fileType" name="fileType" value="" />
							</form>
						</dl>
					</div>
					<br>
					<div class="com_ta">
						<div class="top_box gray_box">
							<dl>
								<dt style="margin-top: 9px; width: 7%">
									<img src="<c:url value='/Images/ico/ico_check01.png'/>"	alt="checkIcon" />프로젝트
								</dt>
								<dd>
									<input type="text" disabled="disabled" id='projectSeq' style="width:70px;" >
									<input type="text"	id='projectView'> 
									<span class='controll_btn'>
										<button class="controll_btn p1" id="getProjectPop">선택</button>
									</span>
								</dd>
								<dt style="margin-top: 9px">
									<img src="<c:url value='/Images/ico/ico_check01.png'/>"	alt="checkIcon" />발의일자
								</dt>
								<dd style="margin-top: 23px">
									<input type="text" id='qkfdml'>
								</dd>
								<dt style="margin-top: 9px">
									<img src="<c:url value='/Images/ico/ico_check01.png'/>"	alt="checkIcon" />적요
								</dt>
								<dd style="margin-top: 23px">
									<input type="text" style="width: 500px;" id='wjrdy'>
								</dd>
							</dl>
							<dl>
								<div id="ws" style="display: block;">
									<dt style="margin-top: 9px; width: 7%;">
										<img src="<c:url value='/Images/ico/ico_check01.png'/>"	alt="checkIcon" />예산과목(예금)
									</dt>
									<dd>
										<input type="text" disabled="disabled"  style="width:70px;"  id='yeSanCd'>
										<input type="text" id='yeSanView'>
										 <span class='controll_btn'>
										 	<button	class="controll_btn p1" onclick="getYeSan('1')">선택</button>
										 </span>
									</dd>
								</div>
								<!-- <div id="ed" style="display: none;">
									<dt style="margin-top: 9px;">예산과목(법인카드)</dt>
									<dd>
										<input type="hidden" id='cardYesanCd'><input type="text" id='cardView'> 
										<span class='controll_btn'>
											<button	class="controll_btn p1" onclick="getYeSan('2')">선택</button>
										</span>
									</dd>
								</div> -->
								<div id="modmod" class="btn_div" style="display: block;">
									<div class="right_div">
										<div class="controll_btn p1">
											<button style="margin-right: 10px; border: 2px solid blue !important;" type="button" onclick="bizInsertFoot();">출장내역 반영</button>
										</div>
									</div>
								</div>
							</dl>
						</div>
					</div>
					<br> <br>
					<div class="top_box gray_box"></div>
					<div style="display: none;">
						<span id="temp"> <img alt="" src="<c:url value='/Images/ico/ico_clip02.png' />">&nbsp; 
						<a class="file_name" id="" style="color: rgb(0, 51, 255); line-height: 23px; cursor: pointer;"	onclick="fnTpfAttachFileDownload(this);" href="#n"></a>&nbsp; 
						<a	onclick="fnTpfAttachFileDelete(this);" href="#n"> <img alt="" src="<c:url value='/Images/btn/btn_del_reply.gif' />"></a> 
						<input class="attachFileId" type="hidden" value=""> 
						<input	class="fileSeq" type="hidden" value=""> 
							<input	class="filePath" type="hidden" value=""> 
							<input	class="fileNm" type="hidden" value=""> 
							<input	class="syncId" type="hidden" value=""> 
							<input	class="cardUseWay" type="hidden" value=""> 
							<input	class="tradeAmt" type="hidden" value=""> 
							<input	class="tradeStdAmt" type="hidden" value=""> 
							<input	class="tradeVatAmt" type="hidden" value="">
						</span>
					</div>
				</div>
				<div class="btn_div" style="margin: 0px;">
					<div class="right_div">
						<div class="controll_btn p1">
							<button style="margin-right: 10px;" type="button" onclick="deleteOutSub();">삭제</button>
						</div>
					</div>
				</div>
				<div class="com_ta4">
					<div id="gridList2"></div>
				</div>

			</div>

		</div>
		<div class="btn_div">
			<div class=" right_div">
				<div class="controll_btn p1">
					<button
						style="margin-right: 10px; border: 2px solid red !important;"	type="button" onclick="wjrdyd();">지출결의 반영</button>
				</div>
			</div>
		</div>
		<!-- //sub_contents_wrap -->
	</div>


	<script>
		var onData; /* 온나라 데이터 최초 저장공간 */
		var diffTime; /* 일시분초 차이값 저장공간 */
		var diffTimeCopy; /* 출장집계표에 쓸 일시분초 데이터 저장공간 */
		var clientInfo; /* 사번으로 출장자들의 정보를 가져와 담아둔 공간 */
		var resInfo; /* 결의 정보 */
		var resInfo2; /* 결제 정보 */
		var ch; /* table tr 저장공간 */
		var outbizInfo;
		var syncIdArr=[]; /*카드 정보 저장공간  */
		var notISsyncIdArr; /*카드 정보 저장공간  */
		var apitest;
		var gradeCostData;/* 직급별 금액정보 */

		var lmitCost1;/* 서울시 숙박비 한계금액 */
		var lmitCost2;/* 경기 숙박비 한계금액 */
		var lmitCost3;/* 기타 숙박비 한계금액 */
		
		var lmitCost4;/* 특별자치도 숙박비 한계금액 */
		var chkLimt;
		
		var chk=false;/* gridList3에 회사차량 이용이 있는지 체크 true /false */
		
		var leftCost; /* 법인카드(숙박) 남은돈 */
		
		var yeData1; /* 예산과목(예금) */
		var yeData2;/* 예산과목(법인) */
		
		//직급별 금액
		var gradeDayCost =0;
		
		//직급별 금액 나누기( 1 or 2)
		var gradeDayCost2 =1;
		
		/* 다중교통수단 임시저장 배열 */
		var transportInfoArray = [];
		
		
		$(function() {
			// $('#transportCost').attr("readonly", true);
			firstStart.ajax();

			purcContInspEventHandler();

			var zzdataSource = new kendo.data.DataSource({
				transport : {
					read : {
						url : "<c:url value='/busTrip/getDayByDayInfo' />",
						dataType : "json",
						type : "post"
					},
					parameterMap : function(data, operation) {
						/* data.biz_common_seq = $('#RowPK').val(); */
						 data.res_doc_seq = parent.resDocSeq;
						return data;
					}
				},
				schema : {
					data : function(response) {
						return response.result;
					},
				}
			});

			$("#gridList2").kendoGrid(
			{
				dataSource : zzdataSource,
				width : 900,
				height : 200,
				sortable : false,
				pageable : false,
				persistSelection : true,
				selectable : "multiple",
				columns : [
						{
							headerTemplate : "<input type='checkbox' id='headerCheckbox' class='k-checkbox header-checkbox headerCheckbox'><label class='k-checkbox-label' for='headerCheckbox'></label>",
							template : checkBoxTp,
							width : "40px"
						}, {
							field : "emp_name",
							width : "100px",
							title : "출장자",
						},{
							field : "biz_day",
							width : "100px",
							title : "일자",
						},  {
							field : "trafic_cost",
							width : "100px",
							template: function (e) {
								if(e.trafic_cost == null || e.trafic_cost == 'undefined'){
									
								 return 0;
								 
								}else{
								 return numberWithCommas(e.trafic_cost);
								}
							},
							title : "교통비",
						}, {
							field : "room_cost",
							width : "80px",
							template: function (e) {
								 return numberWithCommas(e.room_cost);
							},
							title : "숙박비",
						}, {
							field : "food_cost",
							width : "80px",
							template: function (e) {
								 return numberWithCommas(e.food_cost);
							},
							title : "식비",
						}, {
							field : "day_cost",
							width : "80px",
							template: function (e) {
								 return numberWithCommas(e.day_cost);
							},
							title : "일비",
						}, {
							field : "etc_cost",
							width : "80px",
							template: function (e) {
								 return numberWithCommas(e.etc_cost);
							},
							title : "기타",
						}, {
							field : "b_car_cost",
							width : "100px",
							template: function (e) {
								if(e.b_car_cost !=null){
								 return numberWithCommas(e.b_car_cost);
								} else{
									return 0;
								}
							},
							title : "교통(법인)",
						},{
							field : "b_room_cost",
							width : "100px",
							template: function (e) {
								if(e.b_room_cost !=null){
									 return numberWithCommas(e.b_room_cost);
									} else{
										return 0;
									}
							},
							title : "숙박(법인)",
						},{
							field : "b_etc_cost",
							width : "100px",
							template: function (e) {
								if(e.b_etc_cost !=null){
									 return numberWithCommas(e.b_etc_cost);
									} else{
										return 0;
									}
							},
							title : "기타(법인)",
						},{
							field : "total_cost",
							width : "100px",
							template: function (e) {
								 return numberWithCommas(e.total_cost);
							},
							title : "합계",
						}, {
							template : function(dataItem) {
								console.log(dataItem)
								if (dataItem.file_seq == '') {
									return "없음";
								} else {
									return '<div class="controll_btn cen p0"><button type="button" class="attachIco3">목록</button></div>';
								}
							},
							width : "120px",
							title : "출장이행확인 첨부",
						},{
							template : function(dataItem) {
								console.log(dataItem)
								if (dataItem.file_seq3 == '') {
									return "없음";
								} else {
									return '<div class="controll_btn cen p0"><button type="button" class="attachIco5">목록</button></div>';
								}
							},
							width : "100px",
							title : "교통증빙 첨부",
						},{
							template : function(dataItem) {
								console.log(dataItem)
								if (dataItem.file_seq4 == '') {
									return "없음";
								} else {
									return '<div class="controll_btn cen p0"><button type="button" class="attachIco6">목록</button></div>';
								}
							},
							width : "120px",
							title : "교통증빙(기타) 첨부",
						}, {
							template : function(dataItem) {
								console.log(dataItem)
								if (dataItem.file_seq2 == '') {
									return "없음";
								} else {
									return '<div class="controll_btn cen p0"><button type="button" class="attachIco4">목록</button></div>';
								}
							},
							width : "80px",
							title : "법인카드",
						} ],
						dataBound : function (e) {
							
							kendoTooltip();
							
							$(".headerCheckbox").change(function(){
								if($(this).is(":checked")){
									$(this).closest('table').parent().parent().parent().find('.checkbox').prop("checked", "checked");
						        }else{
						        	$(this).closest('table').parent().parent().parent().find('.checkbox').removeProp("checked");
						        }
							});
						}
			}).data("kendoGrid");

			var dataSource = new kendo.data.DataSource({
				transport : {
					read : {
						url : "<c:url value='/busTrip/getTraficWay' />",
						dataType : "json",
						type : "post"
					},
					parameterMap : function(data, operation) {

						return data;
					}
				},
				schema : {
					data : function(response) {
						response.list.unshift({
							code_kr : '없음',
							code_desc : "0"
						})
						return response.list;
					},
				}
			});
			var oilDataSource = new kendo.data.DataSource({
				transport : {
					read : {
						url : "<c:url value='/busTrip/getOilTypeList' />",
						dataType : "json",
						type : "post"
					},
					parameterMap : function(data, operation) {

						return data;
					}
				},
				schema : {
					data : function(response) {
						response.list.unshift({
							code_kr : '선택',
							code : "0"
						})
						return response.list;
					},
				}
			});
			var sidoDataSource = new kendo.data.DataSource({
				transport : {
					read : {
						url : "<c:url value='/busTrip/zxcv' />",
						dataType : "json",
						type : "get"
					},
					parameterMap : function(data, operation) {
						data.serviceNm = 'areaCode.do';
						return data;
					}
				},
				schema : {
					data : function(response) {
						var json = JSON.parse(response.result);

						json.RESULT.OIL.unshift({
							AREA_NM : '선택',
							AREA_CD : "0"
						})

						return json.RESULT.OIL;
					},
				}
			});

			$("#sido").kendoDropDownList({
				autoWidth : true,
				dataTextField : "AREA_NM",
				dataValueField : "AREA_CD",
				dataSource : sidoDataSource,
				index : 0,
				change : function(e) {

					if ($('#UgaDay').data('kendoDatePicker').value() == null) {
						alert("주유일을 입력해주세요");
						return;
					}
					if ($('#oilType').val() == '0' && e.sender._old != 0) {
						alert("유류를 먼저 선택해주세요");
						$('#sido').data("kendoDropDownList").value('0');
						return;
					}
					$.ajax({
						url : "<c:url value='/busTrip/getUga' />",
						data : {
							serviceNm : 'avgSidoPrice.do',
							sidocd : e.sender._old,
							prodCd : $('#oilType').val(),
							date : $('#UgaDay').val(),

						},
						type : 'post',
						success : function(data) {

							$('#Uga').val(data.result.PRICE);

						}
					});
				}
			});
			$("#oilType").kendoDropDownList({
				dataTextField : "code_kr",
				dataValueField : "code",
				dataSource : oilDataSource,
				index : 0,
				change : function(e) {
					$('#sido').data("kendoDropDownList").value('0');
					$('#Uga').val('');
					
					$.ajax({
						url : "<c:url value='/busTrip/getOilTypeCost' />",
						data : {
							common_code_id : $('#oilType').val(),
							day 			:$('#UgaDay').val(),

						},
						type : 'POST',
						async : false,
						success : function(data) {
							oilCostData = data;
							$('#dusql').text(oilCostData.result.fuel_cost);
						}
					});

				}
			});
			$("#trafic_way").kendoDropDownList({
				dataTextField : "code_kr",
				dataValueField : "code_desc",
				dataSource : dataSource,
				index : 0,
				change : function(e) {
					console.log(e.sender._old);
					
					
					 if($('#biz_day').val()== ''){
						alert('출장 일자를 선택해 주세요');
						$('#trafic_way').data('kendoDropDownList').value('0');
						return;
					}

					/*else{ 
					
					 	if(e.sender._old != "0"){
							$('#transportCost').attr("readonly", false);
						}else{
							$('#transportCost').attr("readonly", true);
						} */
					showTraficWay(e.sender._old);
					/* $('#dayCost').val(numberWithCommas(gradeDayCost)); */
										
					//교통비 인풋 리셋
					autoCalDataReset();

					//교통비 계산
					autoCalTraficCost();

					// 합계 계산
					autoCalTotalCost();

					/* parent.djIframeResize(); */
					/* } */
				},
				bound : function(e) {
					$('#trafic_way').closest('.k-dropdown').width('60px');
				}
			});

			$("#giveFood").kendoDropDownList({
				dataTextField : "giveFood_NM",
				dataValueField : "giveFood_CD",
				dataSource : [ {
					giveFood_NM : "미제공",
					giveFood_CD : "N"
				}, {
					giveFood_NM : "1끼 제공",
					giveFood_CD : "1"
				}, {
					giveFood_NM : "2끼 제공",
					giveFood_CD : "2"
				}, {
					giveFood_NM : "3끼 제공",
					giveFood_CD : "3"
				} ],
				index : 0,
				change : function(e) {
					if($('#RowPK').val() =='' ||$('#RowPK').val() =='undefined' || $('#RowPK').val() ==null){
						alert('출장 기본정보를 선택해주세요');
						$('#giveFood').data('kendoDropDownList').value('N');
						return;
					} else{


					var costData;
					$.ajax({
						url : "<c:url value='/busTrip/getGradeCost' />",
						data : {
							dept_position_code : $('#deptPostionCode').val(),
							day : $('#biz_day').val().replace(/-/g, ""),
						},
						type : 'POST',
						async : false,
						success : function(data) {

							costData = data;
						}
					});
					var foodcost = costData.result.food_cost;
					var costDivide = foodcost / 3;

					/* 10원단위는 절삭 */
					costDivide = Math.floor(costDivide / 100) * 100;

					if (e.sender._old == 'N') {

						$('#foodCost').val(numberWithCommas(foodcost));
						autoCalTotalCost();
					}
					if (e.sender._old == '1') {

						$('#foodCost').val(numberWithCommas(costDivide * 2));
						autoCalTotalCost();
					}
					if (e.sender._old == '2') {

						$('#foodCost').val(numberWithCommas(costDivide * 1));
						autoCalTotalCost();
					}
					if (e.sender._old == '3') {
						$('#foodCost').val(0);
						autoCalTotalCost();
					}

				}
				},
				dataBound : function(e) {
					$('#giveFood').closest('.k-dropdown').width('80px');
				}
				
			});
			$("#giveRoom").kendoDropDownList({
				dataTextField : "giveRoom_NM",
				dataValueField : "giveRoom_CD",
				dataSource : [ {
					giveRoom_NM : "제공",
					giveRoom_CD : "Y"
				}, {
					giveRoom_NM : "미제공",
					giveRoom_CD : "N"
				} , {
					giveRoom_NM : "친지숙박",
					giveRoom_CD : "C"
				} ],
				index : 0,
				change : function(e) {
					
					if($('#RowPK').val() =='' ||$('#RowPK').val() =='undefined' || $('#RowPK').val() ==null){
						alert('출장 기본정보를 선택해주세요');
						$('#giveRoom').data('kendoDropDownList').value('Y');
						return;
					}

					var chk = $('#giveRoom').val();
					if (chk == 'N') {
						$('#roomCost').prop('disabled', false);
						$('#roomCost').val('');
						$('#areaSort').show();
						autoCalTotalCost();
						
					} else if(chk == 'Y'){
						$('#roomCost').prop('disabled', true);
						$('#roomCost').val('');
						$('#areaSort').hide();
						$('#area').data('kendoDropDownList').value('null');
						autoCalTotalCost();

					} else if (chk == 'C'){
						$('#roomCost').prop('disabled', true);
						$('#roomCost').val('');
						
						
						$.ajax({
							url : "<c:url value='/busTrip/getGradeCost' />",
							data : {
								dept_position_code : $('#deptPostionCode').val(),
								day : $('#biz_day').val().replace(/-/g, ""),
							},
							type : 'POST',
							async : false,
							success : function(data) {
								$('#roomCost').val(numberWithCommas(data.result.city_cost));
								autoCalTotalCost();
						
							}
						});
								$('#areaSort').hide();
								$('#area').data('kendoDropDownList').value('null');
					} 

				},
				dataBound : function(e) {
					$('#giveRoom').closest('.k-dropdown').width('80px');
				}
			});
			$("#reduceDayCost").kendoDropDownList({
				dataTextField : "reduce_NM",
				dataValueField : "reduce_CD",
				dataSource : [ {
					reduce_NM : "감액 없음",
					reduce_CD : "0"
				},{
					reduce_NM : "10% 감액",
					reduce_CD : "10"
				}, {
					reduce_NM : "20% 감액",
					reduce_CD : "20"
				},{
					reduce_NM : "30% 감액",
					reduce_CD : "30"
				},{
					reduce_NM : "100% 감액",
					reduce_CD : "100"
				} ],
				index : 0,
				change : function(e) {
					
					if($('#RowPK').val() =='' ||$('#RowPK').val() =='undefined' || $('#RowPK').val() ==null){
						alert('출장 기본정보를 선택해주세요');
						$('#reduceDayCost').data('kendoDropDownList').value('0');
						$('#carcar').data('kendoDropDownList').value('0');
						autoCalTotalCost();
						return;
					} else{
						autoCalDayCost();
					}


				},
				dataBound : function(e) {
					$('#reduceDayCost').closest('.k-dropdown').width('90px');
				}
			});
			$("#carcar").kendoDropDownList({
				dataTextField : "carcar_NM",
				dataValueField : "carcar_CD",
				dataSource : [ {
					carcar_NM : "선택",
					carcar_CD : "0" 
				},{
					carcar_NM : "편도 사용",
					carcar_CD : "25"
				}, {
					carcar_NM : "왕복 사용",
					carcar_CD : "50"
				}],
				index : 0,
				change : function(e) {
					
					if($('#RowPK').val() =='' ||$('#RowPK').val() =='undefined' || $('#RowPK').val() ==null){
						alert('출장 기본정보를 선택해주세요');
						$('#reduceDayCost').data('kendoDropDownList').value('0');
						$('#carcar').data('kendoDropDownList').value('0');
						autoCalTotalCost();
						return;
					} else{
						
						autoCalDayCost();
						
					}


				},
				dataBound : function(e) {
					$('#carcar').closest('.k-dropdown').width('90px');
				}
			});
			$("#area").kendoDropDownList({
				dataTextField : "area_NM",
				dataValueField : "area_CD",
				dataSource : [ {
					area_NM : "선택",
					area_CD : "null"
				}, {
					area_NM : "서울특별시",
					area_CD : "lmitCost1"
				}, {
					area_NM : "광역시",
					area_CD : "lmitCost2"
				}, {
					area_NM : "기타",
					area_CD : "lmitCost3"
				} , {
					area_NM : "특별자치도",
					area_CD : "lmitCost4"
				} ],
				index : 0,
				change : function(e) {

					$("#roomCost").val('');
					//area_CD를 변수이름으로 해놓고 해당 변수를(값이 담겨있는lmitCost1,lmitCost2,lmitCost3 를 ) 바로 보내버리기?  
					chkLimt = e.sender._old;
				},
				dataBound : function(e) {
					$('#area').closest('.k-dropdown').width('90px');
				}
			});

			Initt.ajax();

			$(document).on('click','#gridList tbody tr',function() {
				
				if($(this).attr('id') == null){
					return;
				}
				// 기본값 교통비 0 / 교통수단 기본값이 교통값(없음)이니까
				$('#traficCost').val('');
				
				
				chogi();
				syncIdArr=[];
				var RowPK = $(this).attr("id");

				// 해당 ROW값 가져오기
				var emp_seq = $('#' + RowPK).children('[name=emp_seq]').val();
				var dept_seq = $('#' + RowPK).children('[name=dept_seq]').val();
				var trip_no_onnara = $('#' + RowPK).children('[name=trip_no_onnara]').val();
				var dept_position_code = $('#' + RowPK).children('[name=dept_position_code]').val();

				var TRIP_DAY_FR = $('#' + RowPK).children('[name=TRIP_DAY_FR]').text();
				var TRIP_DAY_TO = $('#' + RowPK).children('[name=TRIP_DAY_TO]').text();
				var dept_name = $('#' + RowPK).children('[name=dept_name]').text();
				var emp_name = $('#' + RowPK).children('[name=emp_name]').text();
				var location = $('#' + RowPK).children('[name=location]').text();
				var purpose = $('#' + RowPK).children('[name=purpose]').text();
				 $('#wjrdy').val("(국내여비) "+purpose); 
				$('#BTTripNo').val(trip_no_onnara);
				$('#BTEmpNo').val(emp_seq);
				$('#RowPK').val(RowPK);
				$('#deptPostionCode').val(dept_position_code);
				$('#deptseq').val(dept_seq);

				$('#BTDept').val(dept_name);
				$('#BTEmp').val(emp_name);
				$("#BTDateFR").data("kendoDatePicker").value(TRIP_DAY_FR);
				$("#BTDateTO").data("kendoDatePicker").value(TRIP_DAY_TO);
				$('#BTLocation').val(location);
				$('#rm').val(purpose);

				bizDay.min($("#BTDateFR").data("kendoDatePicker").value());
				bizDay.max($("#BTDateTO").data("kendoDatePicker").value());
					
				//기본값을 출장 첫날로
				var a = moment($("#BTDateFR").data("kendoDatePicker").value()).format('YYYY-MM-DD');
				$('#biz_day').val(a);
				
				$.ajax({
							url : "<c:url value='/busTrip/getGradeCost' />",
							data : {
								dept_position_code : $('#deptPostionCode').val(),
								day : $('#biz_day').val().replace(/-/g, ""),
							},
							type : 'POST',
							async : false,
							success : function(data) {
								$('#foodCost').val(numberWithCommas(data.result.food_cost));
								gradeDayCost =data.result.day_cost;
								$('#dayCost').val(numberWithCommas(data.result.day_cost));
								if (data.result.lodgment_cost == 0) {
									$.ajax({
												url : "<c:url value='/busTrip/getAreaCost' />",
												data : {
													dept_position_code : $('#deptPostionCode').val(),
													day : $('#biz_day').val().replace(/-/g, ""),
												},
												type : 'POST',
												async : false,
												success : function(data) {

													lmitCost1 = data.result.value1
													lmitCost2 = data.result.value2
													lmitCost3 = data.result.value3
													lmitCost4 = data.result.value4
												}
											});
								} else {
									lmitCost1 = data.result.lodgment_cost;
									lmitCost2 = data.result.lodgment_cost;
									lmitCost3 = data.result.lodgment_cost;
									lmitCost4 = data.result.lodgment_cost;
								}

							}
						});

						autoCalTotalCost();
								
							});

		});

		var firstStart = {
				
				ajax 	: function() {
					
				
					
					$.ajax({
						url: "<c:url value='/busTrip/getOutBtRow' />",
						data : {res_doc_seq: parent.resDocSeq},
						type : 'POST',
						async :false,
						success: function(result){
							if (result.result.length > 0) {
								 reloadRow(result.result);
							}
					} 

				});
					
					
				}
		}
		
		var Initt = {

			fn_kendo : function() {
			},

			ajax : function() {

				var data = {
					emp_erp_num : $('#emp_erp_num').val()
				};

				$.ajax({
					url : "<c:url value='/busTrip/getOrgCode' />",
					data : data,
					type : 'POST',
					async : false,
					success : function(data) {
						console.log(data.result);
						console.log(data.result[0].ORG_CODE);
						$('#org_code').val(data.result[0].ORG_CODE);

					}
				});
				$.ajax({
					url : "<c:url value='/busTrip/getBizTemp' />",
					data : {res_doc_seq : parent.resDocSeq},
					type : 'POST',
					async : false,
					success : function(data) {
						if(data.result.length !=0 ){
							
						yeData1 = data.result[0];
						$('#yeSanView').val(yeData1.erpBgt2Name);
						$('#yeSanCd').val(yeData1.erpBgt2Seq);
						}
					}
				});
			
						
			var resInfoo = parent.$('#resTbl').dzt('getValue');
			$('#projectView').val(resInfoo.projectName);
			$('#projectSeq').val(resInfoo.projectSeq);
			$('#wjrdy').val(resInfoo.resNote);
			
			
			
			
		}
		}

		function numberWithCommas(x) {
			return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");

		}

		function showTraficWay(id) {
			$('#carWayNo').hide();
			$("#carWay").hide();
			$("#trainWay").hide();
			$("#busWay").hide();
			$("#shipWay").hide();
			$("#airportWay").hide();

			$("#" + id).show();
		}

		// 로우 삭제 기능
		function deleteOnnaraBtRow(rownum) {

			if ($("#gridList tbody tr").size() == '1' && !$(".emptyClass").hasClass("emptyClass")) {
				var noRow = '';

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

			/* parent.djIframeResize(); */

			$.ajax({
				url : "<c:url value='/busTrip/deleteRowData' />",
				data : {
					biz_common_seq : rownum,

				},
				type : 'POST',
				async : false,
				success : function(result) {
					console.log("biz_common_seq : " + result.biz_common_seq	+ '  삭제');

				}

			});

		}

		$(function() {

			$('#btnTradeCard2').click(function() {
				fnEventTradeCard2();
			});

			function fnEventTradeCard2() {

				/* checkTotalAndCard(); */

				var budgetData = parent.$('#budgetTbl').dzt('getValue');
				/* 결제내역 마지막 행 선택 */
				/* $('#tradeTbl').dzt('setDefaultFocus', 'LAST'); */

				var winHeight = document.body.clientHeight; // 현재창의 높이
				var winWidth = document.body.clientWidth; // 현재창의 너비
				var winX = window.screenX || window.screenLeft || 0;// 현재창의 x좌표
				var winY = window.screenY || window.screenTop || 0; // 현재창의 y좌표

				var popX = winX + (winWidth - 908) / 2;
				var popY = winY + (winHeight - 500) / 2;

				/* 결의정보 */
				var resData = parent.$('#resTbl').dzt('getValue');
				/* 예산내역 */
				var budgetData = parent.$('#budgetTbl').dzt('getValue');

				var url = '/custExp/expend/np/user/CardUseHistoryPopCopy.do';
				url += '?resDocSeq=' + resData.resDocSeq;
				url += '&notISsyncIdArr=' + (notISsyncIdArr || 0);
				/*url += '&resSeq=' + budgetData.resSeq;
				url += '&budgetSeq=' + budgetData.budgetSeq;
				url += '&callbackName=fnAddInterfaceHistoryCallback';
				url += '&vatFgCode=' + budgetData.vatFgCode;
				url += '&trFgCode=' + budgetData.trFgCode; */

				var pop = window
						.open(url, "카드 사용내역", "width=960, height=550, left="+ popX + ", top=" + popY);

				return;
			}

		})

		function resetCostData() {
			$('#traficCost').val('');
			$('#roomCost').val('');
			$('#foodCost').val('');
			$('#dayCost').val('');
			$('#etcCost').val('');
			
			$('#roomCost').prop('disabled', true);
			$('#roomCost').val('');
			$('#areaSort').hide();
			$('#area').data('kendoDropDownList').value('null');
		}

		function autoCalTraficCost() {
				
			var costSum =0;
			var tableInfo = $('#gridList3 tbody tr');
			
			tableInfo.each(function(i,v){

				costSum += Number($(v).children('[name=cost]').text().replace(/,/g, ""));
				
			});
				
			$('#traficCost').val(numberWithCommas(costSum));
			autoCalTotalCost();
		}
		
		function autoCalTransport() {
			 //열차 금액
			var e = Number($('#depCost').val().replace(/,/g, ""));
			var f = Number($('#arrCost').val().replace(/,/g, ""));

			//버스금액
			var g = Number($('#depBusCost').val().replace(/,/g, ""));
			var h = Number($('#arrBusCost').val().replace(/,/g, ""));

			//선박 금액
			var a = Number($('#depShipCost').val().replace(/,/g, ""));
			var b = Number($('#arrShipCost').val().replace(/,/g, ""));

			//항공 금액
			var c = Number($('#depAirCost').val().replace(/,/g, ""));
			var d = Number($('#arrAirCost').val().replace(/,/g, ""));

			var data = e + f + g + h + a + b + c + d; 

			 //$('#transportCost').val(numberWithCommas( Math.floor(data / 10) * 10)); 
			 $('#transportCost').val(numberWithCommas(data)); 
		}

		function autoCalTotalCost() {
			//숙박,식비,일비,기타,교통비

			var a = Number($('#roomCost').val().replace(/,/g, ""));
			var b = Number($('#foodCost').val().replace(/,/g, ""));
			var c = Number($('#dayCost').val().replace(/,/g, ""));
			var d = Number($('#etcCost').val().replace(/,/g, ""));
			var i = Number($('#traficCost').val().replace(/,/g, ""));

			var e = Number($('#trafic_cost_card').val().replace(/,/g, ""));
			var f = Number($('#room_cost_card').val().replace(/,/g, ""));
			var g = Number($('#etc_cost_card').val().replace(/,/g, ""));

			var data = a + b + c + d + i 
			var data2 = e + f + g;

			//10원단위 절삭
			/* data = Math.floor(data / 10) * 10; */
			
			$('#totalCos').val(numberWithCommas(data+data2));
			

		}

		/* 온나라 출장정보 조회 팝업창 */
		function getOnNaraBustrip(e) {

			var url = _g_contextPath_ + "/busTrip/onnaraBtPop2" + "?orgCode="+ $('#org_code').val()+"&dept_seq="+$('#dept_seq').val();

			window.name = "parentWindow";
			var openWin = window.open(url,	"childWindow","width=1200, height=700, resizable=no , scrollbars=no, status=no, top=50, left=150","newWindow");
		}
		function apiPop(value) {

			var url = _g_contextPath_ + "/busTrip/apiPop?sort=" + value +"&bizDate="+$('#biz_day').val();

			window.name = "parentWindow2";
			var openWin = window.open(url,"childWindow2","width=1480, height=700, resizable=no , scrollbars=no, status=no, top=50, left=150","newWindow");
		}

		// 온나라  출장팝업에서 실행하는 함수 btn_add에 온나라 출장 row정보를 보내기위해서
		function testvalue(arr) {

			var onnaraBTDATA = JSON.parse(arr);
			console.log(onnaraBTDATA);

			bizInsertHead(onnaraBTDATA);

		}

		var qkfdml = $('#qkfdml').kendoDatePicker({
			culture : "ko-KR",
			value : moment().format('YYYY-MM-DD'),
			format : "yyyy-MM-dd",
		}).attr("readonly", true).data("kendoDatePicker");
		
		var UgaDay = $('#UgaDay').kendoDatePicker({
			culture : "ko-KR",
			format : "yyyy-MM-dd",
		}).attr("readonly", true).data("kendoDatePicker");

		var BTDateFR = $('#BTDateFR').kendoDatePicker({
			culture : "ko-KR",
			format : "yyyy-MM-dd",
		}).attr("readonly", true).data("kendoDatePicker");

		var BTDateTO = $('#BTDateTO').kendoDatePicker({
			culture : "ko-KR",
			format : "yyyy-MM-dd",
		}).attr("readonly", true).data("kendoDatePicker");

		var bizDay = $('#biz_day').kendoDatePicker({
			culture : "ko-KR",
			format : "yyyy-MM-dd",
			change : function() {
				if($('#RowPK').val()==''){
					alert('출장 기본정보를 선택해주세요');
					$('#biz_day').data('kendoDatePicker').value('');
					
				}else {
					var day = $('#biz_day').val().replace(/-/g, "");
					
					$.ajax({
						url : "<c:url value='/busTrip/getGradeCost' />",
						data : {
							dept_position_code : $('#deptPostionCode').val(),
							day : $('#biz_day').val().replace(/-/g, ""),
						},
						type : 'POST',
						async : false,
						success : function(data) {
							$('#foodCost').val(numberWithCommas(data.result.food_cost));
							gradeDayCost =data.result.day_cost;
							$('#dayCost').val(numberWithCommas(data.result.day_cost));
							
							// 숙박비가 0원으로 되어있으면 비고에 적어놓은 값을 trim 으로 가져와서 넣어준다.
							if (data.result.lodgment_cost == 0) {
								$.ajax({
											url : "<c:url value='/busTrip/getAreaCost' />",
											data : {
												dept_position_code : $('#deptPostionCode').val(),
												day : $('#biz_day').val().replace(/-/g, ""),
											},
											type : 'POST',
											async : false,
											success : function(data) {

												lmitCost1 = data.result.value1
												lmitCost2 = data.result.value2
												lmitCost3 = data.result.value3
												lmitCost4 = data.result.value4
											}
										});
							} else {
								lmitCost1 = data.result.lodgment_cost;
								lmitCost2 = data.result.lodgment_cost;
								lmitCost3 = data.result.lodgment_cost;
								lmitCost4 = data.result.lodgment_cost;
							}

						}
					});
					
				};
			}
		}).attr("readonly", true).data("kendoDatePicker");

		//시간차이 구하기
		function timeCalculate() {

			var t1 = moment(BTDateFR.value(), 'YYYY-MM-DD HH:mm');
			var t2 = moment(BTDateTO.value(), 'YYYY-MM-DD HH:mm');

			diffTime = {
				day : moment.duration(t2.diff(t1)).days() + 1,
				hour : moment.duration(t2.diff(t1)).hours(),
				minute : moment.duration(t2.diff(t1)).minutes(),
				second : moment.duration(t2.diff(t1)).seconds()
			}

		}

		//출장정보 마리아db에 일괄반영
		function tripTradeProcess3(resDocSeq, resSeq, budgetSeq, vatFgCode) {

			var resTable = parent.$('#resTbl').dzt('getValue');
			var budgetTable = parent.$('#budgetTbl').dzt('getValue');

			var pkTr = $('#gridList tbody tr');

			$.each(pkTr, function(i, v) {

				console.log($(v).attr('id'));

				var pk = $(v).attr('id');

				//업데이트
				$.ajax({
					url : "<c:url value='/busTrip/updateLastcommon' />",
					data : {
						biz_common_seq : pk,
						project_name : resTable.erpMgtName,
						pjt_cd : resTable.erpMgtSeq,

					},
					type : 'POST',
					async : false,
					success : function(result) {
						console.log('프로젝트정보 업데이트');

					}

				});

				//biz_out table update
				asdqwe(pk, budgetSeq);

				$.ajax({
					url : "<c:url value='/busTrip/getRowdataNow' />",
					data : {
						pk_join : pk,
					},
					type : 'POST',
					async : false,
					success : function(result) {

						console.log('출장정보조회');
						outbizInfo = result.result;

					}

				});

				var data = new Array();
				var costInfo = 0;

				$.each(outbizInfo, function(index, item) {
					
					var outTripCardCost;
					$.ajax({
						url : "<c:url value='/busTrip/getCardCostBySubSeq' />",
						data : {
							out_sub_seq : item.sub_seq /* item.sub_seq */
						},
						type : 'POST',
						async : false,
						success : function(result) {
							//배열로 넘어온 정보 저장
							outTripCardCost = result.result;
							if(outTripCardCost[0] != null){
								
							console.log(outTripCardCost[0].cost);
							costInfo += Number(item.total_cost) - Number(outTripCardCost[0].cost);
							} else{
							costInfo += Number(item.total_cost);
								
							}
						}

					});
					
					
					console.log(costInfo);
					
					data.push(item.emp_seq);

				});

				var a = data.join();

				$.ajax({
					url : "<c:url value='/busTrip/getClientInfo' />",
					data : {
						EMP_NO_JOIN : a
					},
					type : 'POST',
					async : false,
					success : function(result) {
						//배열로 넘어온 정보 저장
						clientInfo = result.result;

					}

				});

				var trade_amt = 0;
				var trade_std_amt = 0;
				var trade_vat_amt = 0;
				var empNo = outbizInfo[0].emp_seq;
				var trSeq = "";
				var trName = "";
				var trAddr = "";
				var ceoName = "";
				var businessNb = "";
				var baNb = "";
				var btrSeq = "";
				var btrName = "";
				var depositor = "";

				if (vatFgCode == 1) {
					trade_amt = costInfo;
					trade_std_amt = Math.round(costInfo / 11 * 10);
					trade_vat_amt = Math.round(costInfo / 11);
				} else {
					trade_amt = costInfo;
					trade_std_amt = costInfo;
				}

				$.each(clientInfo, function(i, v) {

					trSeq = v.TR_CD;
					trName = v.TR_NM;
					trAddr = v.ADDR;
					ceoName = v.CEO_NM;
					businessNb = v.REG_NB;
					baNb = v.BA_NB;
					btrSeq = v.JIRO_CD;
					btrName = v.BANK_NM;
					depositor = v.DEPOSITOR;

					var aaa = {
						resDocSeq : resDocSeq,
						resSeq : resSeq,
						budgetSeq : budgetSeq,
						empSeq : $('#emp_seq').val(),
						empName : $('#emp_name').val(),

						trSeq : trSeq,
						trName : trName,
						trAddr : trAddr,
						ceoName : ceoName,
						businessNb : businessNb,
						baNb : baNb,
						btrSeq : btrSeq,
						btrName : btrName,
						depositor : depositor,

						tradeAmt : trade_amt,
						tradeStdAmt : trade_std_amt,
						tradeVatAmt : trade_vat_amt,

					}

					$.ajax({
						url : "<c:url value='/busTrip/insertResTrade' />",
						data : aaa,
						type : 'POST',
						async : false,
						success : function(result) {
							insertDefaultBojo(result.trade_seq, resDocSeq,resSeq);
							
							updateTradeSeq(result.trade_seq, pk);
							
							yeData1.res_doc_seq = parent.resDocSeq;
							
							insertBizTemp(yeData1);

						}

					});

				});

			});

			//더존 지출결의서 결의정보 불러오는 함수 실행하기
			parent.preBudgetSeq = null;
			parent.fnTradeSelect(resDocSeq, resSeq, budgetSeq);
			/* 
			$('#resTbl_right_content_div_right_content_table td').off('click');
			$('#budgetTbl_right_content_div_right_content_table td').off('click');
			$('#tradeTbl_right_content_div_right_content_table td').off('click'); */
			
		}

		//결재작성 버튼 누르면 실행되는 함수 
		function djCustApproval() {

		}
		
		function insertBizTemp(v) {
			$.ajax({
				url : "<c:url value='/busTrip/insertBizTemp' />",
				data : v,
				type : 'POST',
				async : false,
				success : function(result) {
					console.log("몰라라ㅏㄹㄴ알");
				}

			});
		}

		function asdqwe(pk, budgetSeq) {
			$.ajax({
				url : "<c:url value='/busTrip/updateLastOut' />",
				data : {
					biz_common_seq : pk,
					budget_seq : budgetSeq,
					trade_seq : "",

				},
				type : 'POST',
				async : false,
				success : function(result) {
					console.log('예산seq 업데이트');

				}

			});
		}

		// 출장일괄반영 버튼시  정보 저장하기
		function setLastInfo(a, b) {
			resInfo = a;
			resInfo2 = b;
		}
		
		function fntest(fileKey) {
			
			var data = {
					res_doc_seq : parent.resDocSeq,
					file_key	: fileKey
				};
			
			$.ajax({
				url : "<c:url value='/busTrip/makeExcelByBizTrip' />",
				data : data,
				type : 'POST',
				async : false,
				success : function(result) {
					
				}
					
			});
		}

		// 출장 db 조회해서 엑셀파일에 집계표만들기
		function makeOutTripExcel(fileKey) {
			var arr = [];
			var arr2 = [];

			var resDocSeq = {
				res_doc_seq : parent.resDocSeq,
				file_key	: fileKey
			};

			$.ajax({
				url : "<c:url value='/busTrip/getBtRowData2' />",
				data : resDocSeq,
				type : 'POST',
				async : false,
				
				success : function(result) {
					console.log('성공 : ' + result.result)

					$.each(result.result, function(index, item) {
							
						
						var data = {
							fileKeyy   :fileKey	,					
							resDocSeq : parent.resDocSeq,
							empName : item.emp_name,	
							bizday	: item.biz_day,
							dayc	: item.day_cost,
							foodc	: item.food_cost,
							roomc	: item.room_cost,
							sort	: "개인정산",
							cardsort: "법인",
							etcTrafic: item.etc_cost,
							/* total	: Math.floor((item.day_cost + item.food_cost +item.room_cost + item.trafic_cost + item.etc_cost) / 10) * 10, */
							total	: item.day_cost + item.food_cost +item.room_cost + item.trafic_cost + item.etc_cost,
						}
						
						if(item.trafic_way =='차량'){
							if(item.car_yn =='이용함'){
								data.car2 = item.trafic_cost;
							}else {
								data.carempName = item.emp_name
								data.car1 = item.trafic_cost;
								data.distance	= item.distance;
								data.oilc		= item.oil_cost;
								data.oiltype	= item.oil_sort_kor;
								data.etcc		= item.etc_cost;
								data.dusql		=  item.dusql;
								data.oil_city_kor= item.oil_city_kor;
								data.cartotal	= item.etc_cost + item.trafic_cost;
							}
						}
						if(item.trafic_way =='열차'){
							data.train = item.trafic_cost;
						}
						if(item.trafic_way =='버스'){
							data.bus = item.trafic_cost ;
							
						}
						if(item.trafic_way =='항공'){
							data.air = item.trafic_cost;
							
						}
						if(item.trafic_way =='선박'){
							data.ship = item.trafic_cost;
							
						}
						
						
						
						$.ajax({
							url : "<c:url value='/busTrip/getCardCostBySubSeqDetail' />",
							data : {out_sub_seq : item.sub_seq},
							type : 'POST',
							async : false,
							success : function(result) {
								
								console.log('성공 : ' + result.result)
								var cardTotal =0;
								var sumTraficEtc =0;
								$.each(result.result, function(index, val) {
									
									cardTotal += val.cost;
									
									// 출장명세표 법인카드쪽
									if(val.cardSort =='교통'){
										sumTraficEtc = val.cost;
									}
									if(val.cardSort =='숙박'){
										data.cardroomc = val.cost;
									}
									if(val.cardSort =='기타' ){
										data.cardetcTrafic = val.cost;
									}
									
									
								});
								
								if(item.trafic_way =='차량'){
									if(item.car_yn =='이용함'){
										data.cardcar2 = sumTraficEtc;
									}else {
									data.cradcar1 = sumTraficEtc;
									}
								}
								if(item.trafic_way =='열차'){
									data.cardtrain = sumTraficEtc;
								}
								if(item.trafic_way =='버스'){
									data.cardbus = sumTraficEtc;
									
								}
								if(item.trafic_way =='항공'){
									data.cardair = sumTraficEtc;
									
								}
								if(item.trafic_way =='선박'){
									data.cardship = sumTraficEtc;
									
								}
								
								data.cardtotal = cardTotal;
									
							}
						});
						
						console.log(data);

						arr.push(data);

					});
					console.log(arr);
				
					
				}

			});

			var aaa = JSON.stringify(arr);

			console.log(aaa);
			
			
			
		 	
			$.ajax({
				url : "<c:url value='/busTrip/makeOutTripExcel' />",
				dataType : 'json',
				data : aaa,
				type : 'POST',
				async : false,
				contentType : "application/json; charset=UTF-8",
				success : function(result) {
					cosole.log("엑셀파일 생성완료");
				}

			}); 

		}

		function insertDefaultBojo(trade, resDoc, res) {

			data = {
				resDocSeq : resDoc,
				resSeq : res,
				tradeSeq : trade,
				bojoCode : 2,
				bojoUse : '미사용',
				bojoReasonCode : 0,
				bojoReasonText : '',
			}

			$.ajax({
				url : "<c:url value='/resAlphaG20/saveTradeBojo' />",
				data : data,
				type : 'POST',
				async : false,
				success : function(result) {
					console.log('보조 디폴트 인서트');
				}

			});

		}

		function bizInsertHead(arr) {

			$.each(arr, function(i, v) {

				$.ajax({
					url : "<c:url value='/busTrip/insertBizCommon' />",
					data : {
						writer_emp_seq : $('#emp_seq').val(),
						writer_emp_name : $('#emp_name').val(),
						project_name : "",
						pjt_cd : "",
						status : "",
						order_no : "",
						remark : "",
						res_doc_seq : parent.resDocSeq,
					},
					type : 'post',
					async : false,
					success : function(data) {

						console.log("==========bizInsertHEAD=========");
						bizInsertBody(data.biz_common_seq, v);
					}
				});

			});

		}

		function bizInsertBody(seq, map) {

			console.log(seq);
			console.log(map);

			var t1 = moment(map.TRIP_DAY_FR, 'YYYY-MM-DD HH:mm');
			var t2 = moment(map.TRIP_DAY_TO, 'YYYY-MM-DD HH:mm');

			diffTime = {
				day : moment.duration(t2.diff(t1)).days() + 1,
			/* hour : moment.duration(t2.diff(t1)).hours(),
			minute : moment.duration(t2.diff(t1)).minutes(),
			second : moment.duration(t2.diff(t1)).seconds() */
			}

			var data = {
				biz_common_seq : seq,
				emp_name : map.EP_NAME_KOR,
				emp_seq : map.EP_NO,
				location : map.TRIP_LOCAL,
				sdate : map.TRIP_DAY_FR,
				edate : map.TRIP_DAY_TO,
				term : diffTime.day,
				purpose : map.TITLE,
				dept_seq : map.dept_seq,
				dept_name : map.ORG_NAME,
				bank_name : map.btrName,
				bank_seq : map.btrSeq,
				depositor : map.depositor,
				bank_nb : map.baNb,
				trip_no_onnara : map.TRIP_NO,
				dept_position_code : map.dept_position_code,
			}

			$.ajax({
				url : "<c:url value='/busTrip/bizInsertBody' />",
				data : data,
				type : 'post',
				async : false,
				success : function(data) {

					console.log(data);
					console.log("==========bizInsertBody=========");

					//data 에서 common_seq로 조회해서 뿌려주기
					selectAndAddRow(data.biz_common_seq);

				}
			});

		}

		function selectAndAddRow(pk) {

			if ($(".emptyClass").size() == '1') {
				$("#gridList tbody").empty();
			}

			var data = {
				biz_common_seq : pk
			}

			$.ajax({
						url : "<c:url value='/busTrip/selectOutBizInfo' />",
						data : data,
						type : 'POST',
						async : false,
						success : function(data) {
							console.log("==========selectOutBizInfo=========");
							console.log(data);

							var item = data;

							var html = '';

							html += '<tr id="' + item.biz_common_seq+ '">';
							html += '<input type="hidden" name="emp_seq" value="' + item.emp_seq+ '">';
							html += '<input type="hidden" name="dept_seq" value="' + item.dept_seq+ '">';
							html += '<input type="hidden" name="trip_no_onnara" value="' + item.trip_no_onnara+ '">';
							html += '<input type="hidden" name="dept_position_code" value="' + item.dept_position_code+ '">';

							html += '<td name="TRIP_DAY_FR">' + item.sdate	+ '</td>';
							html += '<td name="TRIP_DAY_TO">' + item.edate	+ '</td>';

							html += '<td name="dept_name">' + item.dept_name+ '</td>';

							html += '<td name="emp_name">' + item.emp_name	+ '</td>';

							html += '<td name="location">' + item.location	+ '</td>';

							html += '<td name="purpose">' + item.purpose+ '</td>';

							html += '<td name="cancelbtn">';
							html += '<span onclick="deleteOnnaraBtRow(\''+ item.biz_common_seq + '\')">';
							html += '<img class="closeIco" style="width:15px; height:15px;" src="<c:url value='/Images/ico/close.png'/>" alt="" />';
							html += '<span></td>';
							html += '</tr>';

							$("#gridList tbody").append(html);
							console.log("==========append clear=========");
						}
					});

		}

		function setRoww(data, id) {

			$('#' + id).val(numberWithCommas(data));
			autoCalTransport();
			
		}

		function autoCalDataReset(z) {

			if(z == false && $('input[name=car]:checked').val() == '이용함'){}
			else
			{
				$('[name=car]').prop('checked', false);
			}
			$('#moveKM').val('');
			$('#UgaDay').data('kendoDatePicker').value('');
			$('#sido').data('kendoDropDownList').value("0");
			$('#oilType').data('kendoDropDownList').value("0");
			$('#Uga').val('');

			$('#depCost').val('');
			$('#arrCost').val('');

			$('#depBusCost').val('');
			$('#arrBusCost').val('');

			$('#depShipCost').val('');
			$('#arrShipCost').val('');

			$('#depAirCost').val('');
			$('#arrAirCost').val('');

			// $('[name=car]').prop('checked', false); 로 작동안되던거 다시 바인드
			$('input[name=car]').bind({
				click : function() {
					var carYn = $('input[name=car]:checked').val();

					if (carYn == '이용함') {
						$('#carWayNo').hide();


						$('#transportCost').attr("readonly", false);

						autoCalTotalCost();
					} else if (carYn == '이용안함') {
						$('#transportCost').val('');
						autoCalTotalCost();
						
						$('#carWayNo').show();
						
						$('#moveKM').val('');
						$('#UgaDay').data('kendoDatePicker').value('');
						$('#sido').data('kendoDropDownList').value("0");
						$('#oilType').data('kendoDropDownList').value("0");
						$('#Uga').val('');
						$('#transportCost').attr("readonly", true);
						
						//uga 출장일로 default
						UgaDay.value($('#biz_day').val());
						
					}
				}
			})

		}

		//초기화
		function chogi() {
			$('.dataInputt').val('');
			
			autoCalDataReset();
			resetCostData();
			hideTraficWay();
			$('#transportCost').attr("readonly", true);
			$('#trafic_way').data('kendoDropDownList').value('0');
			$('#BTDateFR').data('kendoDatePicker').value('');
			$('#BTDateTO').data('kendoDatePicker').value('');
			$('#giveRoom').data('kendoDropDownList').value('Y');
			$('#giveFood').data('kendoDropDownList').value('N');
			
			$('#biz_day').data('kendoDatePicker').value('');
			
			$('#cjaqn1 #temp').remove();
			
			$('#cjaqn2 #temp').remove();
			syncIdArr = [];

			
			$('#cjaqn3 #temp').remove();
			$('#cjaqn4 #temp').remove();
			/* $('#ed').hide(); */
			$('#cardYesanCd').val('');
			$('#cardView').val('');
			
			$('#carWayNo').hide();
			$("#carWay").hide();
			$("#trainWay").hide();
			$("#busWay").hide();
			$("#shipWay").hide();
			$("#airportWay").hide();
			
			$('#gridList3 tbody tr').remove();
			
			$("#carcar").data('kendoDropDownList').value('0');
			$("#carcarSpan").hide();
			
		}

		function hideTraficWay() {
			$('#carWayNo').hide();
			$("#carWay").hide();
			$("#trainWay").hide();
			$("#busWay").hide();
			$("#shipWay").hide();
			$("#airportWay").hide();
		}

		function UgaBatch() {
			$.ajax({
				url : "<c:url value='/busTrip/UgaBatch' />",
				type : 'get',
				success : function(data) {

					console.log("유가 배치파일 수동실행 헤헤헤");
				}
			});
		}

		function updateTradeSeq(tradeSeq, pk) {
			$.ajax({
				url : "<c:url value='/busTrip/updateTradeSeq' />",
				data : {

					biz_common_seq : pk,
					trade_seq : tradeSeq,
				},

				type : 'post',
				async : false,
				success : function(data) {

					console.log("trade_seq 업데이트완료");

				}
			});

		}
		
		var checkBoxTp = function(row) {
			var key = row.sub_seq;
			return '<input type="checkbox" id="sts'+key+'" class="k-checkbox checkbox"/><label for="sts'+key+'" class="k-checkbox-label"></label>';
		}

		
		$(".headerCheckbox").change(function(){
			if($(this).is(":checked")){
				$(this).closest('table').parent().parent().parent().find('.checkbox').prop("checked", "checked");
	        }else{
	        	$(this).closest('table').parent().parent().parent().find('.checkbox').removeProp("checked");
	        }
	    
		});
		
		
		
		/**
		 * 첨부파일 선택창 오픈
		 * */
		function fnFileOpen(a) {
			$('#attachFile' + a).click();
		}

		/**
		 * 첨부파일 업로드
		 * */
		function fnTpfAttachFileUpload(obj, v) {
			
			var fileNm =obj[0].files[0].name;

			var machimpyo = fileNm.lastIndexOf('.');

			var ext =fileNm.substr(machimpyo+1)

			if(ext == 'zip' || ext == 'apk' || ext == 'rar' || ext == '7z' || ext == 'tar' ){
				
				alert('증빙 자료에 압축파일 첨부가 불가능합니다.')
				return;
				
			} else {
				console.log('['+i+']인덱스의 파일확장자는 ['+ext+'] 입니다.')
			}

			//타겟아이디에 RESDOCSEQ 넣기
			var targetId = parent.resDocSeq;
			var targetTableName = 'bus_out_trip';
			var path = 'bus';
			var fileForm = obj.closest('form');
			var fileInput = obj;
			var fileList = fnCommonFileUpload(targetTableName, targetId, path,fileForm);
			$.each(fileList, function() {
				var span = $('#temp').clone();
				console.log(fileList);
				$('.file_name', span).html(this.fileNm + "." + this.ext);
				$('.attachFileId', span).val(this.attach_file_id);
				$('.fileSeq', span).val(this.fileSeq);
				$('.filePath', span).val(this.filePath);
				$('.fileNm', span).val(this.fileNm + "." + this.ext);
				$('#cjaqn' + v).append(span);
				
				
			});
			fileInput.unbind();
			fileForm.clearForm();
			fileInput.bind({
				change : function() {
					fnTpfAttachFileUpload($(this), v);
				}
			})
			//fnResizeForm();
			
		
		}

		/**
		 * 첨부파일 삭제
		 * */
		function fnTpfAttachFileDelete(obj) {
			if (!confirm('첨부파일을 삭제하시겠습니까?')) {
				return;
			}
			var span = $(obj).closest('span');
			var attach_file_id = $('.attachFileId', span).val();
			var syncId = $('.syncId', span).val();
			
			//syncIdArr에 저장된 데이터 삭제
			syncIdArrDelete(syncId);
			
			//(공통)첨부파일 삭제 함수
			fnCommonFileDelete(attach_file_id);
			
			span.remove();

			checkTotalAndCard();

		}

		/**
		 * 첨부파일 다운로드
		 * */
		function fnTpfAttachFileDownload(obj) {
			var span = $(obj).closest('span');
			var attach_file_id = $('.attachFileId', span).val();
			var downWin = window.open('', '_self');
			downWin.location.href = _g_contextPath_
					+ '/common/fileDown?attach_file_id=' + attach_file_id;
		}
		function fnTpfAttachFileDownload2(obj) {
			var attach_file_id = obj;
			var downWin = window.open('', '_self');
			downWin.location.href = _g_contextPath_
					+ '/common/fileDown?attach_file_id=' + attach_file_id;
		}

		function purcContInspEventHandler() {
			$("#attachFile1").bind({
				change : function() {
					fnTpfAttachFileUpload($(this), 1);
				}
			});
			$("#attachFile2").bind({
				change : function() {
					fnTpfAttachFileUpload($(this), 2);
				}
			});
			$("#attachFile3").bind({
				change : function() {
					fnTpfAttachFileUpload($(this), 3);
				}
			});
			$("#attachFile4").bind({
				change : function() {
					fnTpfAttachFileUpload($(this), 4);
				}
			});
		// autoCalDataReset() 에서 바인딩해줘서 여기서 바인딩안해도될듯
		
		/* 	$('input[name=car]').bind({
				click : function() {
					var carYn = $('input[name=car]:checked').val();

					if (carYn == '이용함') {
						$('#carWayNo').hide();
						$('#traficCost').attr("readonly", false);
					} else if (carYn == '이용안함') {
						
						$('#carWayNo').show();

						$('#moveKM').val('');
						$('#UgaDay').data('kendoDatePicker').value('');
						$('#sido').data('kendoDropDownList').value("0");
						$('#oilType').data('kendoDropDownList').value("0");
						$('#Uga').val('');
						
						$('#depCost').val('');
						$('#arrCost').val('');
						
						$('#traficCost').attr("readonly", true);
					}
				}
			}) */
		}
		function getSyncId(data, way) {
			
			console.log(way);
			var qwe = JSON.parse(data);
			
			$.each(qwe, function (i,v) {
				syncIdArr.push(v);
			})
			
			
			var syncIdArrDumy = JSON.parse(data);
			console.log(syncIdArrDumy);

			$.each(syncIdArrDumy, function(i, v) {

				$.ajax({
					url : "<c:url value='/busTrip/makeCardExcel' />",
					data : {
						syncId : v.interfaceSeq,
						targetId : parent.resDocSeq,
						CO_CD : $('#erpCoCd').val(),
					},
					type : 'POST',
					async : false,
					success : function(data) {
						console.log(data);
						var span = $('#temp').clone();

						$('.file_name', span).html(data.fileNm + "." + data.ext);
						$('.attachFileId', span).val(data.attach_file_id);
						$('.fileSeq', span).val(data.fileSeq);
						$('.filePath', span).val(data.filePath);
						$('.fileNm', span).val(data.fileNm + "." + data.ext);
						$('.syncId', span).val(v.interfaceSeq);
						$('.cardUseWay', span).val(way);
						$('.tradeAmt', span).val(v.tradeAmt);
						$('.tradeStdAmt', span).val(v.tradeStdAmt);
						$('.tradeVatAmt', span).val(v.tradeVatAmt);

						$('#cjaqn2').append(span);

						data.cardUseWay = way;

						checkTotalAndCard();
						
					}
				});

			})
			
	/* 		if($('#cjaqn2 #temp').length ==0){
				
				$('#ed').hide();
				$('#cardYesanCd').val('');
				$('#cardView').val('');
				
				if(yeData2.PK == $('#RowPK').val()) {
					yeData2 =null;
					
					console.log('맞음')
					}
				
			}else if($('#cjaqn2 #temp').length >=0){
				$('#ed').show();
			} */

		}
		function checkTotalAndCard() {

			var traficC = 0;
			var roomC = 0;
			var etcC = 0;

			var syncIdArray = new Array();

			var qwe = $('#cjaqn2 #temp')
			$.each(qwe, function(i, v) {

				var cardUseWay = $(v).find('.cardUseWay').val();

				var file_name = $(v).find('.file_name').text(); // 파일view 이름

				var attachFileId = $(v).find('.attachFileId').val(); // 파일명
				var fileSeq = $(v).find('.fileSeq').val(); // 파일번호
				var filePath = $(v).find('.filePath').val(); // 파일주소
				var fileNm = $(v).find('.fileNm').val(); // 파일명

				var syncId = $(v).find('.syncId').val(); //카드 pk

				var tradeAmt = $(v).find('.tradeAmt').val().replace(/,/g, "");//총
				var tradeVatAmt = $(v).find('.tradeVatAmt').val().replace(/,/g,	"");//공급
				var tradeStdAmt = $(v).find('.tradeStdAmt').val().replace(/,/g,	"");//부가

				if (cardUseWay == '교통') {

					traficC += Number(tradeAmt);

				}
				if (cardUseWay == '숙박') {
					
					roomC += Number(tradeAmt);
					
					//법인카드 숙박
					var cardCost = roomC;
					

				}
				if (cardUseWay == '기타') {

					etcC += Number(tradeAmt);
				}

				syncIdArray.push(syncId);

			});

			notISsyncIdArr = syncIdArray.join();

			$('#trafic_cost_card').val(numberWithCommas(traficC));
			$('#room_cost_card').val(numberWithCommas(roomC));
			$('#etc_cost_card').val(numberWithCommas(etcC));
			
			checkLeftCost();
			autoCalTotalCost();
			
		}

		function ugaCal() {

			if ($('#moveKM').val() == '') {
				alert("이동거리를 입력해주세요");
				return;
			}
			if ($('#UgaDay').data('kendoDatePicker').value() == null) {
				alert("주유일을 입력해주세요");
				return;
			}
			if ($('#oilType').val() == '0' && e.sender._old != 0) {
				alert("유류를 선택해주세요");
				return;
			}
			if ($('#sido').data("kendoDropDownList").value() == '0') {
				alert("지역을 선택해주세요");
				return;
			}

			var oilCostData;

			$.ajax({
				url : "<c:url value='/busTrip/getOilTypeCost' />",
				data : {
					common_code_id : $('#oilType').val(),
					day 			:$('#UgaDay').val(),

				},
				type : 'POST',
				async : false,
				success : function(data) {
					oilCostData = data;
				}
			});
			var cst = $('#moveKM').val()/ oilCostData.result.fuel_cost * $('#Uga').val();
			
			/* var cst2 = Math.floor(cst / 10) * 10 */
			var cst2 = cst;
			
			$('#transportCost').val(numberWithCommas(Math.floor((cst2/10))*10));

			/* autoCalTotalCost(); */
		}

		function bizInsertFoot() {
			
			if(confirm("반영하시겠습니까?")){
				
			
			if ($('#RowPK').val() == '') {
				alert('출장 기본정보를 선택하지 않았습니다.')
				return;
			}
			if (bizDay == '' || bizDay == null || bizDay == 'undefined') {
				alert('출장날짜를 선택해주세요.')
				return;
			}
			 if ($('#projectSeq').val()=='') {
				alert('프로젝트를 선택해주세요. \n\n 수기입력시 프로젝트 정보가 반영되지 않으니 \n 반드시 선택(Enter)으로 처리해주시기 바랍니다. ')
				return;
			} 
			 
			 if($('#carcarSpan').css('display') != 'none'){
				 
				 if($('#carcar').val() =='0'){
					 
				 alert('업무차량 [편도] / [왕복] 여부를 선택해주세요.')
				 return;
				 }
			 }
			
			/* if($('#trafic_way').data('kendoDropDownList').text() =='차량'){
				
				var carYn = $('input[name=car]:checked').val();
				
				if(carYn == '' || carYn == "undefined" || carYn == null){
					alert("업무차량 사용여부를 선택해 주세요");
					return;
				}
			}
			var carYn = $('input[name=car]:checked').val();
			if (carYn == '' || carYn == "undefined" || carYn == null) {
				carYn = '이용안함';
			} */
			
			var attach1 = $('#cjaqn1 .attachFileId').length;
			var attach2 = $('#cjaqn2 .attachFileId').length;
			var attach3 = $('#cjaqn3 .attachFileId').length;
			var attach4 = $('#cjaqn4 .attachFileId').length;
			
			if(attach1 + attach2 + attach3 + attach4 <1){
				alert("최소 1개의 첨부파일이 필요합니다.");
				return;
			} 
			
			
			if($('#projectView').val() ==''){
				alert('프로젝트를 선택해주세요');
				return;
				
			}
			if($('#yeSanView').val() ==''){
				alert('예산을 선택해주세요');
				return;
				
			}
			if($('#wjrdy').val() ==''){
				alert('적요를 입력해주세요');
				return;
				
			}
			
			
			
			
			var overLap = false;
			$.ajax({
				url : "<c:url value='/busTrip/deleteOutSubDayData' />",
				data : {
					biz_common_seq : $('#RowPK').val(),
					biz_day :  $('#biz_day').val(),
					},
				type : 'post',
				async : false,
				success : function(data) {
					console.log(data);
						overLap = true;
				}
			});
				
			
			if(!overLap){
				// deleteOutSubDayData 삭제 실패시 리턴시킴
				alert('오류');
				return;
			}  else{
				
				var arr = $('#cjaqn1 .attachFileId');
				var data = new Array();
	
				$.each(arr, function(i, v) {
	
					console.log(v.value)
	
					data.push(v.value);
	
				});
				var file_seq = data.join();
				
				var arr2 = $('#cjaqn2 .attachFileId');
				var data = new Array();
	
				$.each(arr2, function(i, v) {
	
					console.log(v.value)
	
					data.push(v.value);
	
				});
				var file_seq2 = data.join();
				
				
				
				var arr3 = $('#cjaqn3 .attachFileId');
				var data = new Array();
	
				$.each(arr3, function(i, v) {
	
					console.log(v.value)
	
					data.push(v.value);
	
				});
				var file_seq3 = data.join();
				
				
				
				var arr4 = $('#cjaqn4 .attachFileId');
				var data = new Array();
	
				$.each(arr4, function(i, v) {
	
					console.log(v.value)
	
					data.push(v.value);
	
				});
				var file_seq4 = data.join();
	
	
				data = {
	
					biz_day					: 		$('#biz_day').val(),
					trafic_way 				:		 $('#trafic_way').data('kendoDropDownList').text(),
					trafic_cost 			: 		$('#traficCost').val().replace(/,/g, ""),
					room_cost 				: 		$('#roomCost').val().replace(/,/g, ""),
					food_cost				: 		$('#foodCost').val().replace(/,/g, ""),
					day_cost 				:		 $('#dayCost').val().replace(/,/g, ""),
					etc_cost 				:		 $('#etcCost').val().replace(/,/g, ""),
					total_cost				:		 $('#totalCos').val().replace(/,/g, ""),
					file_seq				:		 file_seq,
					file_seq2 				:		 file_seq2,
					file_seq3 				:		 file_seq3,
					file_seq4 				:		 file_seq4,
					biz_common_seq			:		 $('#RowPK').val(),
					yesan_code				:		$('#yeSanCd').val(),
					yesan_name				:		$('#yeSanView').val(),
					yesan_card_code			:		$('#cardYesanCd').val(),
					yesan_card_name			:		$('#cardView').val(),
					
					give_food				:		$('#giveFood').val(),
					carcar					:		$('#carcar').val(),
					reduce_per				:		$('#reduceDayCost').val(),
	
					
				}
	
				$.ajax({
					url : "<c:url value='/busTrip/bizInsertFoot' />",
					data : data,
					type : 'post',
					async : false,
					success : function(data) {
						
						//out_sub 테이블 PK
						var subSeq = data.sub_seq;
						
						//교통수단 저장하기
						addTransportTable(subSeq);
					
						
						//법인첨부카드 내역 가져오기
						var qwe = $('#cjaqn2 #temp')
						
						$.each(qwe, function(i, v) {
	
							var cardUseWay = $(v).find('.cardUseWay').val();
							var file_name = $(v).find('.file_name').text(); // 파일view 이름
							var attachFileId = $(v).find('.attachFileId').val(); // 파일명
							var fileSeq = $(v).find('.fileSeq').val(); // 파일번호
							var filePath = $(v).find('.filePath').val(); // 파일주소
							var fileNm = $(v).find('.fileNm').val(); // 파일명
							var syncId = $(v).find('.syncId').val(); //카드 pk
							var tradeAmt = $(v).find('.tradeAmt').val().replace(/,/g, "");//총
							var tradeVatAmt = $(v).find('.tradeVatAmt').val().replace(/,/g,"");//공급
							var tradeStdAmt = $(v).find('.tradeStdAmt').val().replace(/,/g,"");//부가
	
	
							param = {
									attachId 			:	attachFileId, 
									cardSyncId			:	syncId, 
									out_sub_seq	 		: 	subSeq ,
									cost				:	tradeAmt, 
									cardSort			:	cardUseWay,
									baNb				:   syncIdArr[0].baNb,
									bizIncomCode		:   syncIdArr[0].bizIncomCode,
									btrName				:   syncIdArr[0].btrName,
									btrSeq				:   syncIdArr[0].btrSeq,
									budgetSeq			:   syncIdArr[0].budgetSeq,
									businessNb			:   syncIdArr[0].businessNb,
									cardNum				:   syncIdArr[0].cardNum,
									ceoName				:   syncIdArr[0].ceoName,
									ctrName				:   syncIdArr[0].ctrName,
									ctrSeq				:   syncIdArr[0].ctrSeq,
									depositor			:   syncIdArr[0].depositor,
									empName				:   syncIdArr[0].empName,
									empSeq				:   syncIdArr[0].empSeq,
									etcCode				:   syncIdArr[0].etcCode,
									etcName				:   syncIdArr[0].etcName,
									interfaceSeq		:   syncIdArr[0].interfaceSeq,
									payAmt				:   syncIdArr[0].payAmt,
									payTaxAmt			:   syncIdArr[0].payTaxAmt,
									realPayAmt			:   syncIdArr[0].realPayAmt,
									regDate				:   syncIdArr[0].regDate,
									resDocSeq			:   syncIdArr[0].resDocSeq,
									resSeq				:   syncIdArr[0].resSeq,
									trName				:   syncIdArr[0].trName,
									trSeq				:   syncIdArr[0].trSeq,
									tradeAmt			:   syncIdArr[0].tradeAmt,
									tradeNote			:   syncIdArr[0].tradeNote,
									tradeSeq			:   syncIdArr[0].tradeSeq,
									tradeStdAmt			:   syncIdArr[0].tradeStdAmt,
									tradeVatAmt			:   syncIdArr[0].tradeVatAmt,
								}
							
							
							$.ajax({
								url : "<c:url value='/busTrip/bizInsertOutSubCard' />",
								data : param,
								type : 'post',
								async : false,
								success : function(data) {
									console.log("======법인카드정보 저장==========");
									//array 에서 최초에 0번 인덱스에 정보를 삭제후 자동으로 소팅되서 다음번호가 0번이됌 그래서 0번삭제 고정
									syncIdArrDelete(syncIdArr[0].interfaceSeq);
								}
							});
							
							
							
							
							
							
						});
						
						gridSearch();
						
					}
				});
			}
			
			

				chogi();
					
			}
		}
		$(".dataInputNumber").bind(
				{
					keyup : function(event) {
						$(this).val(numberWithCommas($(this).val().replace(/[^0-9]/g, "").replace(/(^0+)/, "")));
						autoCalTotalCost();

					},
					change : function(event) {
						$(this).val(
								numberWithCommas($(this).val().replace(/[^0-9]/g, "").replace(/(^0+)/, "")));
						autoCalTotalCost();

					}
				});
		$(".dataInputNumber2").bind(
				{
					keyup : function(event) {
						$(this).val(
								numberWithCommas($(this).val().replace(/[^0-9]/g, "").replace(/(^0+)/, "")));
						/* autoCalTraficCost(); */
						autoCalTransport();

					},
					change : function(event) {
						$(this).val(
								numberWithCommas($(this).val().replace(/[^0-9]/g, "").replace(/(^0+)/, "")));
					/* 	autoCalTraficCost(); */
						autoCalTransport();

					}
				});
		$(".commas").bind(
				{
					keyup : function(event) {
						$(this).val(numberWithCommas($(this).val().replace(/[^0-9]/g, "")));

					},
					change : function(event) {
						$(this).val(numberWithCommas($(this).val().replace(/[^0-9]/g, "")));

					}
				});

		$("#roomCost").bind({
			keyup : function(event) {

				if ($('#area').val() == 'null') {
					alert('지역을 선택해주세요');
					$(this).val('');
					autoCalTotalCost();
					return;
				}
				checkLeftCost();
			},
			change : function(event) {

			}
		});
		$("#traficCost").bind({
			keyup : function(event) {
				
				if ($('#trafic_way').data('kendoDropDownList').text() =='선택') {
					alert('교통수단을 선택해주세요.');
					$("#traficCost").val('')
					return;
				}


			}
		});

		function gridSearch() {

			$("#gridList2").data('kendoGrid').dataSource.read();
		}

		$(document).on('click', '#gridList2 .k-grid-content tr', function() {
			var gData = $("#gridList2").data('kendoGrid').dataItem(this);
			console.log(gData);
			
		}); 
		$(document).on('dblclick', '#gridList2 .k-grid-content tr', function() {
			var gData = $("#gridList2").data('kendoGrid').dataItem(this);
			console.log(gData);
			chogi();
			
			var RowPK = gData.biz_common_seq;

			// 해당 ROW값 가져오기
			var emp_seq = gData.emp_seq;
			var dept_seq = gData.dept_seq;
			var trip_no_onnara = gData.trip_no_onnara;
			var dept_position_code = gData.dept_position_code;

			var TRIP_DAY_FR = gData.sdate;
			var TRIP_DAY_TO = gData.edate;
			var dept_name = gData.dept_name;
			var emp_name = gData.emp_name;
			var location = gData.location;
			var purpose = gData.purpose;
			
			$('#BTTripNo').val(trip_no_onnara);
			$('#BTEmpNo').val(emp_seq);
			$('#RowPK').val(RowPK);
			$('#deptPostionCode').val(dept_position_code);
			$('#deptseq').val(dept_seq);

			$('#BTDept').val(dept_name);
			$('#BTEmp').val(emp_name);
			$("#BTDateFR").data("kendoDatePicker").value(TRIP_DAY_FR);
			$("#BTDateTO").data("kendoDatePicker").value(TRIP_DAY_TO);
			$('#BTLocation').val(location);
			$('#rm').val(purpose);

			bizDay.min(gData.biz_day);
			bizDay.max(gData.biz_day);
			
			// yyyy-mm-dd 형태의 text를 date 타입으로 바꿔서 kendo에 value값으로넣어주기
			var year        = gData.biz_day.substring(0,4);
			var month       = gData.biz_day.substring(5,7);
			var day         = gData.biz_day.substring(8,10);
			
			var dateconvert = new Date(year, month-1, day);
			bizDay.value(dateconvert);
			
			
			
			
			
		$('#giveFood').data('kendoDropDownList').value(gData.give_food);
		$('#foodCost').val(gData.food_cost);
		
		$('#dayCost').val(gData.day_cost);
		
		if(gData.carcar != '0'){
			$('#carcarSpan').show();
		}
		
		$('#carcar').data('kendoDropDownList').value(gData.carcar);
		$('#reduceDayCost').data('kendoDropDownList').value(gData.reduce_per);
		
		
		$('#etcCost').val(gData.etc_cost.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
		
		if(gData.room_cost =='0'){
		$('#giveRoom').data('kendoDropDownList').value('Y');
		$('#roomCost').prop('disabled', true);
		$('#roomCost').val('');
		$('#areaSort').hide();
		$('#area').data('kendoDropDownList').value('null');
		}else{
			
		$('#giveRoom').data('kendoDropDownList').value('N');
		$('#roomCost').prop('disabled', false);
		$('#areaSort').show();
		$('#roomCost').val(gData.room_cost.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
		}
		
		
		$('#traficCost').val(gData.trafic_cost.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
		
		
		$.ajax({
			url : "<c:url value='/busTrip/getCardCostBySubSeqDetail' />",
			data : {
				out_sub_seq : gData.sub_seq
			},
			async : false,
			type : 'post',
			success : function(data) {
				console.log(data.result);
				var data = data.result;
				
				$.each(data, function (i,v) {
					
					if(v.cardSort == '기타'){
						$('#etc_cost_card').val(v.cost.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
					}
					if(v.cardSort == '교통'){
						$('#trafic_cost_card').val(v.cost.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
						
					}
					if(v.cardSort == '숙박'){
						$('#room_cost_card').val(v.cost.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
						
					}
				})
				
				
			}
		});
		
		$.ajax({
			url : "<c:url value='/busTrip/getDayTransPortDetail' />",
			data : {
				outsubseq : gData.outsubseq
			},
			async : false,
			type : 'post',
			success : function(data) {
				console.log(data.result);
				var data = data.result;
				
				$.each(data, function (i,v) {
					addTransportTr(v);
				})
				
				
			}
		})
		
			
		
		// 합계 계산
		autoCalTotalCost();
		
		
		if(gData.file_seq != ""){
			
		
			$.ajax({
				url : "<c:url value='/busTrip/getToolTipFile' />",
				data : {
					fileSeqArr : gData.file_seq,
				},
				type : 'post',
				async : false,
				success : function(data) {
					var fileMap = data.result;
					$('#cjaqn1 #temp').remove();
					$.each(fileMap,function(i, v) {
						var span = $('#temp').clone();
						
						$('.file_name', span).html(v.real_file_name + "." + v.file_extension);
						$('.attachFileId', span).val(v.attach_file_id);
						$('.fileSeq', span).val(v.file_seq);
						$('.filePath', span).val(v.file_path);
						$('.fileNm', span).val(v.real_file_name + "." + v.file_extension);
						$('#cjaqn1').append(span);
					});
				}
			});
		}
		
		if(gData.file_seq2 != ""){
			$.ajax({
				url : "<c:url value='/busTrip/getToolTipFile' />",
				data : {
					fileSeqArr : gData.file_seq2,
				},
				type : 'post',
				async : false,
				success : function(data) {
					var fileMap = data.result;
					$('#cjaqn2 #temp').remove();
					$.each(fileMap,function(i, v) {
						var span = $('#temp').clone();
						
						$('.file_name', span).html(v.real_file_name + "." + v.file_extension);
						$('.attachFileId', span).val(v.attach_file_id);
						$('.fileSeq', span).val(v.file_seq);
						$('.filePath', span).val(v.file_path);
						$('.fileNm', span).val(v.real_file_name + "." + v.file_extension);
						
						$.ajax({
							url : "<c:url value='/busTrip/getCardCostByattachId' />",
							data : {
								attach_file_id :v.attach_file_id,
							},
							type : 'post',
							async : false,
							success : function(data) {
								syncIdArr.push(data.result[0]);
								
								$('.syncId', span).val(data.result[0].syncId);
								$('.cardUseWay', span).val(data.result[0].cardSort);
								$('.tradeAmt', span).val(data.result[0].tradeAmt);
								$('.tradeStdAmt', span).val(data.result[0].tradeStdAmt);
								$('.tradeVatAmt', span).val(data.result[0].tradeVatAmt);	
								$('#cjaqn2').append(span);
								
							}
						});
						
					});
				}
			});
		}
		if(gData.file_seq3 != ""){
			$.ajax({
				url : "<c:url value='/busTrip/getToolTipFile' />",
				data : {
					fileSeqArr : gData.file_seq3,
				},
				type : 'post',
				async : false,
				success : function(data) {
					var fileMap = data.result;
					$('#cjaqn3 #temp').remove();
					$.each(fileMap,function(i, v) {
						var span = $('#temp').clone();
						
						$('.file_name', span).html(v.real_file_name + "." + v.file_extension);
						$('.attachFileId', span).val(v.attach_file_id);
						$('.fileSeq', span).val(v.file_seq);
						$('.filePath', span).val(v.file_path);
						$('.fileNm', span).val(v.real_file_name + "." + v.file_extension);
						$('#cjaqn3').append(span);
					});
				}
			});
		}
		if(gData.file_seq4 != ""){
			$.ajax({
				url : "<c:url value='/busTrip/getToolTipFile' />",
				data : {
					fileSeqArr : gData.file_seq4,
				},
				type : 'post',
				async : false,
				success : function(data) {
					var fileMap = data.result;
					$('#cjaqn4 #temp').remove();
					$.each(fileMap,function(i, v) {
						var span = $('#temp').clone();
						
						$('.file_name', span).html(v.real_file_name + "." + v.file_extension);
						$('.attachFileId', span).val(v.attach_file_id);
						$('.fileSeq', span).val(v.file_seq);
						$('.filePath', span).val(v.file_path);
						$('.fileNm', span).val(v.real_file_name + "." + v.file_extension);
						$('#cjaqn4').append(span);
					});
				}
			});
		}
			
	}); 

		function moveMoveTemp(fileKey) {
			$.ajax({/* getFilePk =>getFilePkVer2  * resDocSeq에 해당하는 모든 파일정보를 불러와서 첨부했지만 첨부순서를 바꿔달라고해서  바꿈 */
				url : "<c:url value='/busTrip/getFilePkVer2' />",
				data : {
					res_doc_seq : parent.resDocSeq,
					fileKey : fileKey
				},
				async : false,
				type : 'post',
				success : function(data) {
				
					console.log(data.result.file_seq);
					console.log(data.result.file_seq2);
					console.log(data.result.file_seq3);
					console.log(data.result.file_seq4);
					
					
				}
			});
		}
		
		function deleteOutSub() {
			
			if(confirm('해당 내역을 삭제 하시겠습니까?')){
				
			
			
			var ch =$('#gridList2 tbody tr').find("input[type='checkbox']:checked");
			$.each(ch,function(){
				
			
			var pk = $(this).attr('id').substring(3);
			
			console.log(pk);
			
			
			$.ajax({
				url : "<c:url value='/busTrip/deleteOutSub' />",
				data : {
					sub_seq : pk,
				},
				type : 'post',
				success : function(data) {
					gridSearch();
					$("#gridList2 .headerCheckbox").removeProp('checked');
				}
			});
			
			
			})
			}
			
		}
		
		function kendoTooltip() {
			
			// Tooltip
			$(".attachIco3").kendoTooltip({
				position: "top",
				autoHide : false,
				showOn: "click",
		        content : function(e) {
					var row = $("#gridList2").data("kendoGrid").dataItem($(e.target.context).closest("tr"));
		        	console.log(row)
					return attachTooltipTemplate3(row);
		        },
		     });
			$(".attachIco4").kendoTooltip({
				position: "top",
				autoHide : false,
				showOn: "click",
		        content : function(e) {
					var row = $("#gridList2").data("kendoGrid").dataItem($(e.target.context).closest("tr"));
		        	
					return attachTooltipTemplate4(row);
		        },
		     });
			$(".attachIco5").kendoTooltip({
				position: "top",
				autoHide : false,
				showOn: "click",
		        content : function(e) {
					var row = $("#gridList2").data("kendoGrid").dataItem($(e.target.context).closest("tr"));
		        	
					return attachTooltipTemplate5(row);
		        },
		     });
			$(".attachIco6").kendoTooltip({
				position: "top",
				autoHide : false,
				showOn: "click",
		        content : function(e) {
					var row = $("#gridList2").data("kendoGrid").dataItem($(e.target.context).closest("tr"));
		        	
					return attachTooltipTemplate6(row);
		        },
		     });
		}
		
		function attachTooltipTemplate3(row) {
			console.log(row)
			var html = "";
				
			var fileArr = row.file_seq;
			
			var fileMap = new Array;
			$.ajax({
				url : "<c:url value='/busTrip/getToolTipFile' />",
				data : {
					fileSeqArr : fileArr,
				},
				type : 'post',
				async : false,
				success : function(data) {
					fileMap = data.result;
					
					
				}
			});
			
			$.each(fileMap,function(i, v) {
				html += '<div class="attachTooltip" onclick="fnTpfAttachFileDownload2(\'' + v.attach_file_id + '\');">' + v.real_file_name +"."+v.file_extension + "</div>";
			});
			
			return html;
		}
		function attachTooltipTemplate4(row) {
			console.log(row)
			var html = "";
				
			var fileArr = row.file_seq2;
			
			var fileMap = new Array;
			$.ajax({
				url : "<c:url value='/busTrip/getToolTipFile' />",
				data : {
					fileSeqArr : fileArr,
				},
				type : 'post',
				async : false,
				success : function(data) {
					fileMap = data.result;
				}
			});
			
			$.each(fileMap,function(i, v) {
				html += '<div class="attachTooltip" onclick="fnTpfAttachFileDownload2(\'' + v.attach_file_id + '\');">' + v.real_file_name +"."+v.file_extension + "</div>";
			});
			
			return html;
		}
		function attachTooltipTemplate5(row) {
			console.log(row)
			var html = "";
				
			var fileArr = row.file_seq3;
			
			var fileMap = new Array;
			$.ajax({
				url : "<c:url value='/busTrip/getToolTipFile' />",
				data : {
					fileSeqArr : fileArr,
				},
				type : 'post',
				async : false,
				success : function(data) {
					fileMap = data.result;
				}
			});
			
			$.each(fileMap,function(i, v) {
				html += '<div class="attachTooltip" onclick="fnTpfAttachFileDownload2(\'' + v.attach_file_id + '\');">' + v.real_file_name +"."+v.file_extension + "</div>";
			});
			
			return html;
		}
		function attachTooltipTemplate6(row) {
			console.log(row)
			var html = "";
				
			var fileArr = row.file_seq4;
			
			var fileMap = new Array;
			$.ajax({
				url : "<c:url value='/busTrip/getToolTipFile' />",
				data : {
					fileSeqArr : fileArr,
				},
				type : 'post',
				async : false,
				success : function(data) {
					fileMap = data.result;
				}
			});
			
			$.each(fileMap,function(i, v) {
				html += '<div class="attachTooltip" onclick="fnTpfAttachFileDownload2(\'' + v.attach_file_id + '\');">' + v.real_file_name +"."+v.file_extension + "</div>";
			});
			
			return html;
		}
		
		
		$('#getProjectPop').on('click', function () {
			
			var resData = parent.$('#resTbl').dzt('getValue');
			resData.searchStr = $('#projectView').val();
			parent.fnCommonCode_erpMgtName("erpMgtName", resData );
			
		});
		$('#projectView').on('keydown', function (e) {
			if(e.keyCode ===13 || e.keyCode ===9){
				//keycode 9 (tab) 은 브라우저 기본동작이 다른 input으로 포커싱하는 기능이있어서 기본이벤트를막는다
				e.preventDefault();
				
				var resData = parent.$('#resTbl').dzt('getValue');
				resData.searchStr = $('#projectView').val();
				parent.fnCommonCode_erpMgtName("erpMgtName", resData );
			}
			
		});
		$('#yeSanView').on('keydown', function (e) {
			if(e.keyCode ===13 || e.keyCode ===9){
				
				e.preventDefault();
				
				var resData = parent.$('#resTbl').dzt('getValue');
				resData.searchStr = $('#yeSanView').val();
				// 예금인지 카드인지 구분하려고 넣어줌 //지금은 상관없음. 동일예산으로 카드 예금값을 쓸거야
				resData.YeSort = "1";
				parent.fnCommonCode_erpBudgetName("erpBudgetName", resData );
			}
			
		});
		
		function getYeSan(v) {
			
			var resData = parent.$('#resTbl').dzt('getValue');
			resData.searchStr = $('#yeSanView').val();
			
			// 예금인지 카드인지 구분하려고 넣어줌 //지금은 상관없나
			resData.YeSort = v;
			parent.fnCommonCode_erpBudgetName("erpBudgetName", resData );
			
		}
		
				
		
			
		
		function setProjectView(val) {
			$('#projectView').val(val.erpMgtName);
			$('#projectSeq').val(val.erpMgtSeq);
			$('#yeSanView').val('');
			$('#yeSanCd').val('');
			
			yeData1 = null;
			
		}
		function setYesanView(val) {
			$('#yeSanView').val(val.BGT_NM);
			$('#yeSanCd').val(val.BGT_CD);
			
			console.log(val);
			
			yeData1 = val;
			
		}
	/* 	function setCardView(val) {
			$('#cardView').val(val.BGT_NM);
			$('#cardYesanCd').val(val.BGT_CD);
			
			console.log(val);
			val.PK = $('#RowPK').val();
			yeData2 = val;
		} */

		function wjrdyd() {
			var masterGrid = $('#gridList tbody tr').not('.emptyClass');
			var subGrid = $('#gridList2 tbody tr').length;
			
			if(masterGrid == 0 ){
				alert('출장정보가 없습니다');
				return;
			}
			
			//출장 총 일수중에 빠진날이있는지 체크하는걸거임
			var lengthMasterGrid = 0;
			$.each(masterGrid, function(i,v) {
				var FrDay = $(v).children('[name=TRIP_DAY_FR]').text()
				var ToDay = $(v).children('[name=TRIP_DAY_TO]').text()
				 
				var t1 = moment(FrDay, 'YYYY-MM-DD HH:mm');
				var t2 = moment(ToDay, 'YYYY-MM-DD HH:mm');
								
				var diffDay = 	 moment.duration(t2.diff(t1)).days();

				lengthMasterGrid += diffDay;

				})
			
			var totalCnt = masterGrid.length + lengthMasterGrid;
			
			if(totalCnt == subGrid){
				if(confirm("출장내역을 반영하시겠습니까? ")){
					
					parent.chulJangNaeYeokBanYung();
				} else {
					return;
				};
			
			} else {
					alert('반영하지 않은 출장 정보가 있습니다.');
				return;
			}
			
		}
		
		function getBaseInfo() {
			
			 var values = {
			docuFgName : '지출결의서' , 
			docuFgCode : '1',
			resNote	: $('#wjrdy').val(),
			resDate : $('#qkfdml').val(),
			erpDivSeq : parent.$('#lbErpDivName').attr('seq'),
			} 
			 
			 return values;
		}
	
		function yeSanInfo() {
			
			return yeData1;
		}
		function getCardYeSanInfo() {
			
			var syncData;			
			$.ajax({
				url : "<c:url value='/busTrip/getCardExistYn' />",
				data : {
					res_doc_seq : parent.resDocSeq,
				},
				type : 'post',
				async : false,
				success : function(data) {
					console.log(data);
					
					var subSeqArr = data.result;
					
					console.log(subSeqArr);
					
					if(subSeqArr.length > 0){
						
						var data = new Array();
						
						$.each(subSeqArr, function (i,v) {
							
							data.push(v.sub_seq);
						})
						
						var subArr = data.join(); 
						
						$.ajax({
							url : "<c:url value='/busTrip/getCardsInfo' />",
							data : {
								sub_seq_arr :subArr,
							},
							type : 'post',
							async : false,
							success : function(data) {
								 
								syncData= data.result;
								
							}
						});
					}
					
				}
			});
			
			
				return syncData;
			
				
		}
		
		//안씀
		function getccc() {
			
			var pkTr = $('#gridList tbody tr');

			$.each(pkTr, function(i, v) {

				console.log($(v).attr('id'));

				var pk = $(v).attr('id');
			
			$.ajax({
				url : "<c:url value='/busTrip/getLastInfoByOutTrip' />",
				data : {
					biz_common_seq : pk,
				},
				type : 'post',
				success : function(data) {
					
					console.log(data.result);
					
				}
			});
			
			});
		}
		
		function syncIdArrDelete(syncId) {
			
		/* 	syncIDArr =[];
			
			$.each(syncIdArr,function(item) {
				
				var idx =syncIdArr[item].findIndex(function(item) {
						
					return item.interfaceSeq == syncId
						
					})
				
				if(idx > -1 ) {
				syncIdArr[item].splice(idx,1);
				
			}
				
			}) */
			
			
			//배열안에 검색후 해당 데이터 삭제
			 var idx = syncIdArr.findIndex(function(item) {
				
				return item.interfaceSeq == syncId
				
			})
			
			
			if(idx > -1 ) {
				syncIdArr.splice(idx,1);
				
			} 
		} 
		
		//되돌아왔을때 row정보 뿌려주기 기능
		function reloadRow(data){
			
			if ($(".emptyClass").size() == '1') {
				$("#gridList tbody").empty();
			}
			
			$.each(data, function (index, item) {
			
			var html = '';

			html += '<tr id="' + item.biz_common_seq+ '">';
			html += '<input type="hidden" name="emp_seq" value="' + item.emp_seq+ '">';
			html += '<input type="hidden" name="dept_seq" value="' + item.dept_seq+ '">';
			html += '<input type="hidden" name="trip_no_onnara" value="' + item.trip_no_onnara+ '">';
			html += '<input type="hidden" name="dept_position_code" value="' + item.dept_position_code+ '">';

			html += '<td name="TRIP_DAY_FR">' + item.sdate	+ '</td>';
			html += '<td name="TRIP_DAY_TO">' + item.edate	+ '</td>';

			html += '<td name="dept_name">' + item.dept_name+ '</td>';

			html += '<td name="emp_name">' + item.emp_name	+ '</td>';

			html += '<td name="location">' + item.location	+ '</td>';

			html += '<td name="purpose">' + item.purpose+ '</td>';

			html += '<td name="cancelbtn">';
			html += '<span onclick="deleteOnnaraBtRow(\''+ item.biz_common_seq + '\')">';
			html += '<img class="closeIco" style="width:15px; height:15px;" src="<c:url value='/Images/ico/close.png'/>" alt="" />';
			html += '<span></td>';
			html += '</tr>';

			$("#gridList tbody").append(html);
			
			});
		}
		
		
		
		/* function loadingStart() {
		 	$('#loadingBAR').show();
		 	$( document.body ).css( 'pointer-events', 'none' );
				
			}	
		function loadingEnd() {
			$('#loadingBAR').hide();
			$( document.body ).css( 'pointer-events', 'all' );
			
		} */
		
		$('#rm').on('keyup',function() {
			var headText = "(국내여비) ";
			var bizTitle = $('#rm').val();
			$('#wjrdy').val(headText + bizTitle);
			
		});
		
		
	function chkTraficWay() {
		var way = $('#trafic_way').val();
		
		return way;
	} 
	
	/* input안에 데이터 종합 ->  addTransportTr(param) table 그리기 */
	function addTransport() {
		
		if($('#RowPK').val() =='' ||$('#RowPK').val() =='undefined' || $('#RowPK').val() ==null){
			alert('출장 기본정보를 선택해주세요');
			return;
		}

		$('#gridList3 tbody tr').remove();

		var transportInfo = {
		
		trafic_way_kr		:	$('#trafic_way').data('kendoDropDownList').text() ,
		car_yn				:	$('[name=car]:checked').val() == undefined ?  '이용안함' : $('[name=car]:checked').val(),
		cost				:	$('#transportCost').val().replace(/[^0-9]/g, ""),
		
		trafic_way			:	$('#trafic_way').val(),
		dep_cost			:	$('#depCost').val().replace(/[^0-9]/g, ""),
		arr_cost			:	$('#arrCost').val().replace(/[^0-9]/g, ""),
		dep_bus_cost		:	$('#depBusCost').val().replace(/[^0-9]/g, ""),
		arr_bus_cost		:	$('#arrBusCost').val().replace(/[^0-9]/g, ""),
		dep_ship_cost		:	$('#depShipCost').val().replace(/[^0-9]/g, ""),
		arr_ship_cost		:	$('#arrShipCost').val().replace(/[^0-9]/g, ""),
		dep_air_cost		:	$('#depAirCost').val().replace(/[^0-9]/g, ""),
		arr_air_cost		:	$('#arrAirCost').val().replace(/[^0-9]/g, ""),
		distance			:	$('#moveKM').val(),
		oil_day				:	$('#UgaDay').val(),
		dusql				:	$('#dusql').text(),
		oil_city			:	$('#sido').data('kendoDropDownList').value(),
		oil_city_kor		:	$('#sido').data('kendoDropDownList').text(),
		oil_sort			:	$('#oilType').data('kendoDropDownList').value(),
		oil_sort_kor		:	$('#oilType').data('kendoDropDownList').text(),
		oil_cost			:	$('#Uga').val(),

		};
		
		//열추가
		addTransportTr(transportInfo);

		//차량사용 여부에 따라 selecet box display / 일비계산
		carYnChkToDayCost();

	}

	function addTransportCost() {

		var flag = false;

		$('#gridList3 tbody tr').remove();

		var transportInfo = {
			cost : $('#transportCost').val().replace(/[^0-9]/g, "")
		};

		addTransport(transportInfo);

		//교통비 계산
		autoCalTraficCost();

		//input초기화
		autoCalDataReset(flag);

		//etc
		$('#transportCost').val('');


	}
	

	/* table 그리기 */
	function addTransportTr(transportInfo) {
		
	 	var html ="";

	 	html += '			<tr>';
	 	html += '			<input type="hidden" name="dep_cost" value ="'+transportInfo.dep_cost		    +'">';
	 	html += '			<input type="hidden" name="arr_cost" value ="'+transportInfo.arr_cost		    +'">';
	 	html += '			<input type="hidden" name="dep_bus_cost" value ="'+transportInfo.dep_bus_cost	+'">';
	 	html += '			<input type="hidden" name="arr_bus_cost" value ="'+transportInfo.arr_bus_cost	+'">';
	 	html += '			<input type="hidden" name="dep_ship_cost" value ="'+transportInfo.dep_ship_cost +'">';
	 	html += '			<input type="hidden" name="arr_ship_cost" value ="'+transportInfo.arr_ship_cost +'">';
	 	html += '			<input type="hidden" name="dep_air_cost" value ="'+transportInfo.dep_air_cost	+'">';
	 	html += '			<input type="hidden" name="arr_air_cost" value ="'+transportInfo.arr_air_cost	+'">';
	 	html += '			<input type="hidden" name="distance" value ="'+transportInfo.distance		    +'">';
	 	html += '			<input type="hidden" name="oil_day" value ="'+transportInfo.oil_day		        +'">';
	 	html += '			<input type="hidden" name="dusql" value ="'+transportInfo.dusql		            +'">';
	 	html += '			<input type="hidden" name="oil_city" value ="'+transportInfo.oil_city		    +'">';
	 	html += '			<input type="hidden" name="oil_city_kor" value ="'+transportInfo.oil_city_kor	+'">';
	 	html += '			<input type="hidden" name="oil_sort" value ="'+transportInfo.oil_sort		    +'">';
	 	html += '			<input type="hidden" name="oil_sort_kor" value ="'+transportInfo.oil_sort_kor	+'">';
	 	html += '			<input type="hidden" name="oil_cost" value ="'+transportInfo.oil_cost		    +'">';
	 	html += '			<input type="hidden" name="trafic_way" value ="'+transportInfo.trafic_way       +'">';
		html += '			<td name="trafic_way_kr">'+transportInfo.trafic_way_kr+'</td>';
		html += '			<td name="car_yn">'+transportInfo.car_yn+'</td>';
		html += '			<td class="commas" name="cost">'+transportInfo.cost+'</td>';
		html += '           <td name="cancelbtn">';
		html += '           	<span class="deleteThisRow">';
		html += '           		<img class="closeIco " style="width:15px; height:15px;" src="<c:url value='/Images/ico/close.png'/>" alt="" />';
		html += '           	<span>';
		html += '           </td>';
		html += '			</tr>';


		$('#gridList3 tbody').append(html);
	}
	
	
	
	
	
	/* gridList3 table row 정보 가져오기 */
	function getTransportTableInfo() {
		
		var tableInfo = $('#gridList3 tbody tr');
		
		var arr =[];

		tableInfo.each(function(i, v) {
			var list = {};
				
			//리스트에 값넣어주는 방법이 
			//list.cost = 1000 또는 list[cost] = 1000  이니까  2번째 방법 이용해서  
			//input 가져와서 list안에 값 넣기	
			$(v).children('input').each(function(ii,vv){
		    	
				/* list에 키 값을 해당 input의 name 값으로 넣어줌 */
				list[$(vv).attr('name')] =$(vv).val();
			
			})

			//td 가져와서 list안에 name값 : value값 으로 만들기
			$(v).children('td').each(function(ii,vv){
		    	
				/* list에 키 값을 해당 input의 name 값으로 넣어줌 */
				list[$(vv).attr('name')] =$(vv).text();
			
			})
			
			
			/*배열에 저장  */
			arr.push(list);

			
		})
		
			return arr;
		
	}
	
	
	/* 여기부터안쓸거가틈 */
	
	/* array 임시저장 */
	function addTransportArray(info) {
		
		transportInfoArray.push(info);
		
	}
	
	/* array idx 데이터 삭제 */
	function deleteTransportArray() {
		
		/*  배열안에서 idx를 찾기*/
		 var idx = transportInfoArray.findIndex(function(item) {
				
			/* 	return item.interfaceSeq == syncId */
				
			})
			
			/* 배열안에 해당 인덱스 값 삭제 */
			if(idx > -1 ) {
				transportInfoArray.splice(idx,1);
				
			} 
	}
	/*여기까지 안쓸거가틈 */
	
	
	$(document).on('click','.deleteThisRow', function () {
		$(this).closest('tr').remove();
		autoCalTraficCost();
		carYnChkToDayCost();
		autoCalDataReset();
		$("#carWay").hide();
		$('#carWayNo').hide();
		$('#trafic_way').data('kendoDropDownList').value('0');
	})
	
	
	function addTransportTable(pk) {
		
		//gridList3 테이블 정보가져오기
		var data = getTransportTableInfo();	
		if(data.length=='0'){
			return;
		} 
		
		// 참조할 out_sub 테이블 pk 담아주기
		$.each(data,function (i,v) {
			v.outsubseq = pk;
			v.cost = v.cost.replace(/[^0-9]/g, "");
		}) 
		
		
		$.ajax({
			url : "<c:url value='/busTrip/addTransportTable' />",
			data : JSON.stringify(data),
			contentType : 'application/json',
			type : 'post',
			async : false,
			success : function(data) {
				
				console.log(data.message)
			}
				
			});
		
	}
	
	function carYnChkToDayCost() {

		chk=false;
		
		$('#gridList3 tr [name=car_yn]').each(function(i,v){


		if($(v).text() == '이용함'){
		 chk = true
		}

		})
		if(chk){
			$('#carcarSpan').show();
			autoCalDayCost();
		} else{
			
			$('#carcarSpan').hide();
			$('#carcar').data('kendoDropDownList').value('0');
			autoCalDayCost();
		}
		
	}
	
	function chkRoomCost() {
		var data =	{
			giveRoomYn 	:	$('#giveRoom').val(),
			cost 		:   eval($('#area').val()),
			}
		return data;
		
	}
	
	function checkLeftCost() {
		
		var inputRoomCost = $('#roomCost').val().replace(/[^0-9]/g, "") =='' ? 0 : $('#roomCost').val().replace(/[^0-9]/g, "") ;
		
		
			if (Number(eval(chkLimt)) < Number(inputRoomCost)) {
				alert("지원 한도를 벗어나서 최대값으로 설정되었습니다.");
				// 한도 - 법인카드 해서 남는값을 개인숙박비에 넣어주자 
				
				$('#roomCost').val(numberWithCommas(Number(eval(chkLimt))));

				autoCalTotalCost();
			
			}
		
			
	}
	
	function autoCalDayCost() {
		
		var reducePercent1  = $('#carcar').data('kendoDropDownList').value();
		
		var reducePercent2  = $('#reduceDayCost').data('kendoDropDownList').value();
		
		var resultDayCostFirst = gradeDayCost - gradeDayCost * reducePercent1 / 100; 			
		var resultDayCost = resultDayCostFirst - resultDayCostFirst * reducePercent2 / 100;
		
		$('#dayCost').val(numberWithCommas(resultDayCost));
		autoCalTotalCost();
	}
	</script>


</body>

