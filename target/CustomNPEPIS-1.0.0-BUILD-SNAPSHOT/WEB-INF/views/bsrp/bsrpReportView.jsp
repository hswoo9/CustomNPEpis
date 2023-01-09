<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ page import="main.web.BizboxAMessage"%>

<body>
<style>
.com_ta table th{text-align: center;}
.com_ta table td{text-align: center;}

</style>
<script type="text/javascript" src='<c:url value="/js/ac/acBsUtil.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/ac/g20/acG20BsCode.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/ac/g20/acG20BsForm.js"></c:url>'></script>

<div class="iframe_wrap" style="min-width:1100px">

	<div class="sub_contents_wrap">
	
		<div class="com_ta">
			<div class="top_box gray_box">
				<dl>
					<dt style="width: 8%;">
						부서/출장자
					</dt>
					<dd style="line-height: 25px; width: 20%;">
						<input type="text" id="txtDEPT_NM" style="width: 180px;" readonly="readonly" value="">	
						<input type="hidden" id="txtKOR_NM">
					</dd>
					<dt style="width: 8%;">
						직무대행
					</dt>
					<dd style="line-height: 25px; width: 20%;">
						<input type="text" id="dty_seq" style="width: 180px;" readonly="readonly">		
					</dd>
					<dt style="width: 8%;">
						신청일자
					</dt>
					<dd style="line-height: 25px; width: 20%;">
						<input type="text" id="txtGisuDate">
					</dd>
				</dl>	
				
				<dl>
					<dt style="width: 8%;">
						출장지
					</dt>
					<dd style="line-height: 25px;width:10%;">
						<select class="selectMenu" id="bs_des" style="min-width: 70px;" disabled="disabled">
							<c:forEach var="list" items="${bsrp_area }">
								<option value="${list.code }">${list.code_desc }</option>
							</c:forEach>
						</select>
						<input type="text" id="bs_des_txt" style="width: 100px; display: none;"/>
					</dd>
					<dt style="width: 8%;">
						출장기간
					</dt>
					<dd style="line-height: 25px;width:30%;">
						<input type="text" id="startDt" style="width: 120px;"> ~ <input type="text" id="endDt" style="width: 120px;"><span id="dayCnt">(1 일간)</span>
						<input type="hidden" id="dayCntTemp" value="1">
					</dd>
					<dt style="width: 8%;">
						업무차량
					</dt>
					<dd style="line-height: 25px;width:20%">
						<input type="radio" name="car" id="car1" value="0"><label for="car1">사용</label>&emsp;&emsp;
						<input type="radio" name="car" id="car2" value="1" checked="checked"><label for="car2">미사용</label>
					</dd>
				</dl>	
				
				<dl>
					<dt style="width: 8%;">
						교통수단
					</dt>
					<dd style="line-height: 25px;width:10%;">
						<select class="selectMenu" id="topSearchTfcmn" style="min-width: 80px;" disabled="disabled" onchange="changeTfcmn();">
							<c:forEach var="list" items="${bsrp_tfcmn }">
								<option value="${list.code }">${list.code_desc }</option>
							</c:forEach>
						</select>
					</dd>
					<dt style="width: 8%;">
						숙박제공
					</dt>
					<dd style="line-height: 25px;width:8%;">
						<select id="topSearchRoom" style="min-width: 70px;" disabled="disabled">
							<option value="1">무제공</option>
							<option value="2">제공</option>
							<option value="3">일부제공</option>
						</select>
					</dd>
					<dt style="width: 8%;">
						식비제공
					</dt>
					<dd style="line-height: 25px;width:8%">
						<select id="topSearchFood" style="min-width: 70px;" disabled="disabled">
							<option value="1">무제공</option>
							<option value="2">제공</option>
							<option value="3">일부제공</option>
						</select>
					</dd>
					<dt style="width: 5%;">
						목적
					</dt>
					<dd style="width:30%;">
						<input type="text" id="rm" style="min-width: 100%;" readonly="readonly"/>
					</dd>
				</dl>			
				<dl style="display: none;" id="mileageArea">
					<dt style="width: 8%;">
						항공사
					</dt>
					<dd style="line-height: 25px;width:10%;">
						<select class="selectMenu" id="topSearchAirline" style="min-width: 80px;" onchange="changeAirline();">
							<c:forEach var="list" items="${biztrip_airline }">
								<option value="${list.code }">${list.code_desc }</option>
							</c:forEach>
						</select>
					</dd>
					<dt style="width: 8%;">
						누적마일리지
					</dt>
					<dd style="line-height: 25px;width:8%;">
						<input type="text" id="savedMileage" value="" style="" readonly="readonly" class="mileage"/>
					</dd>
					<dt style="width: 8%;">
						신규마일리지
					</dt>
					<dd style="line-height: 25px;width:8%;">
						<input type="text" id="newMileage" value="" style="" class="mileage"/>
					</dd>
					<dt style="width: 8%;">
						사용마일리지
					</dt>
					<dd style="line-height: 25px;width:10%;">
						<input type="text" id="useMileage" value="" style="" class="mileage" onchange="checkMileage()"/>
					</dd>
				</dl>
			</div>
		</div>
		<p><br></p>
		<div class="com_ta">
			<div class="top_box gray_box">
				<dl>
					<dt style="width: 8%;">
						운임
					</dt>
					<dd style="line-height: 25px; width:30%;"">
						<input type="text" id="fare" style="width: 200px;" class="requirement sumData userInput">원
					</dd>
					<dt style="width: 8%;">
						일비
					</dt>
					<dd style="line-height: 25px; width:25%;"">
						<input type="text" id="daily" style="width: 200px;" class="requirement sumData userInput">원
					</dd>
					<dt style="width: 8%;">
						통행료
					</dt>
					<dd style="line-height: 25px; width:10%;"">
						<input type="text" id="toll" style="width: 80px;" class="requirement sumData">원
					</dd>
				</dl>
				<dl>
					<dt style="width: 8%;">
						숙박비
					</dt>
					<dd style="line-height: 25px; width:30%;">
						<input type="text" id="room" style="width: 200px;" class="requirement sumData userInput">원
					</dd>
					<dt style="width: 8%;">
						식비
					</dt>
					<dd style="line-height: 25px; width:25%;">
						<input type="text" id="food" style="width: 200px;" class="requirement sumData userInput">원
						<div>
							<span style="color: red;line-height: 100%;position: absolute;">
								<br/>
								※ 출장지 식사 제공시 직접 식비감액 후 지급액 입력 :
								<br/>
								1식감액 6,600원, 2식감액 6,700원, 3식감액 6,700원
							</span>
						</div>
					</dd>
				</dl>
				<dl>
					<dt style="width: 8%;">
						합계
					</dt>
					<dd style="line-height: 25px; width:30%;">
						<input type="text" id="total" style="width: 200px;" class="requirement" readonly="readonly">원
						<input type="hidden" id="totalOrg"/>
					</dd>
				</dl>
			</div>
		</div>
		<br>
		<div class="com_ta">
			<div class="top_box">
				<table id="erpBudgetInfo-tablesample" style="width: 100%">
					<colgroup>
						<col width="40%">
						<col width="40%">
					<tr>
						<th>예산회계단위</th>
						<th>프로젝트</th>
					</tr>
					<tr>
						<td>
							<input type="text" style="width:85%;" id="txtDIV_NM" readonly="readonly" class="requirement txtDIV_NM">
						</td>
						<td>
							<input type="text" style="width:85%;" id="txt_ProjectName" readonly="readonly" class="requirement txt_ProjectName">
						</td>
					</tr>
				</table>
			</div>
		</div>
<!-- 		<br> -->
<!-- 		<input type="button" value="추가"> -->
		<p><br></p>
		<div class="com_ta">
			<div class="top_box">
				<table style="width: 100%;">
				<colgroup>
				<col width="12.5%">
				<col width="12.5%">
				<col width="12.5%">
				<col width="12.5%">
				<col width="12.5%">
				<col width="12.5%">
				<col width="12.5%">
				<col width="12.5%">
				</colgroup>				
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000003625","관")%></th>
                       	<td id="td_veiw_BGT01_NM" class="bbTxt"></td>
                       	<th><%=BizboxAMessage.getMessage("TX000003626","항")%></th>
                       	<td id="td_veiw_BGT02_NM" class="bbTxt"></td>
                       	<th class="en_w140" ><%=BizboxAMessage.getMessage("TX000003627","목")%></th>
                       	<td id="td_veiw_BGT03_NM" class="bbTxt"></td>
                       	<th><%=BizboxAMessage.getMessage("TX000003628","세")%></th>
                       	<td id="td_veiw_BGT04_NM" class="bbTxt"></td>
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000003618","예산액")%></th>
                        <td id="td_veiw_OPEN_AM"  class="bbTxt" style="font-weight: bold;"></td>                    
                        <th><%=BizboxAMessage.getMessage("TX000005056","집행액")%></th>
                        <td id="td_veiw_APPLY_AM"  class="bbTxt" style="font-weight: bold;"></td>
                        <th class="en_w140" ><%=BizboxAMessage.getMessage("TX000009911","품의액")%></th>
                        <td id="td_veiw_REFER_AM"  class="bbTxt" style="font-weight: bold;"></td>
                        <th><%=BizboxAMessage.getMessage("TX000005686","예산잔액")%></th>
                        <td id="td_veiw_LEFT_AM"  class="bbTxt" style="font-weight: bold;"></td>
					</tr>
				
				</table>

			</div>
		</div>
		<br>
		<div class="com_ta">
			<div class="top_box">
				<table style="width: 100%;">
				<colgroup>
					<col width="15%">
					<col width="15%">
					<col width="10%">
					<col width="10%">
					<col width="">
				</colgroup>
					<tr>
						<th colspan="2">예산과목</th>
						<th>과세구분</th>
						<th>금액</th>
						<th>비고</th>
					</tr>
					<tr>
						<td id="budget-td">
							<input type="text" style="width:80%;" id="txt_BUDGET_LIST" readonly="readonly" class="requirement txt_BUDGET_LIST">
				            <input type="hidden" class="non-requirement" id="BGT01_NM"  />
				            <input type="hidden" class="non-requirement" id="BGT02_NM" />
				            <input type="hidden" class="non-requirement" id="BGT03_NM" />
				            <input type="hidden" class="non-requirement" id="BGT04_NM" />
				            <input type="hidden" class="non-requirement" id="ACCT_AM"  />
				            <input type="hidden" class="non-requirement" id="DELAY_AM"  />
				            <input type="hidden" class="non-requirement" id="APPLY_AM"  />
				            <input type="hidden" class="non-requirement" id="LEFT_AM"  />
				            <input type="hidden" class="non-requirement" id="CTL_FG"  />
				            <input type="hidden" class="non-requirement" id="LEVEL01_NM"  />
				            <input type="hidden" class="non-requirement" id="LEVEL02_NM" />
				            <input type="hidden" class="non-requirement" id="LEVEL03_NM" />
				            <input type="hidden" class="non-requirement" id="LEVEL04_NM" />
				            <input type="hidden" class="non-requirement" id="LEVEL05_NM" />
				            <input type="hidden" class="non-requirement" id="LEVEL06_NM" />
				            <input type="hidden" class="non-requirement" id="IT_SBGTCDLINK"/>
						</td>
						<td>
							<input type="text" id="BGT03_Txt" class="requirement" readonly="readonly">
						</td>
						<td>
							<select id="fg" style="width: 60px;" disabled="disabled">
								<option value="1">과세</option>
								<option value="2">면세</option>
								<option value="3">기타</option>
							</select>
						</td>
						<td class=""><span id="txt_total"></span></td>
						<td>
							<input type="text" class="requirement" id="rmk_dc" style="width: 90%" readonly="readonly">
						</td>
					</tr>
				</table>
			</div>
		</div>
		<br/>
		<div class="com_ta" id="report_area">
			<div class="top_box gray_box">
				<dl>
					<dt style="width: 110px;">
						일시
					</dt>
					<dd style="line-height: 25px;width: 85%;">
						<input type="text" id="text_date" style="width:100%"/>
					</dd>
				</dl>
				<dl>
					<dt style="width: 110px;">
						목적
					</dt>
					<dd style="line-height: 25px;width: 85%;">
						<input type="text" id="text_reason" style="width:100%"/>
					</dd>
				</dl>
				<dl>
					<dt style="width: 110px;">
						장소
					</dt>
					<dd style="line-height: 25px;width: 85%;">
						<input type="text" id="text_place" style="width:100%"/>
					</dd>
				</dl>
				<dl>
					<dt style="width: 110px;">
						주요일정
					</dt>
					<dd style="line-height: 25px;width: 85%;">
						<input type="text" id="text_plan" style="width:100%"/>
					</dd>
				</dl>
				<dl>
					<dt style="width: 110px;">
						내용 및 시사점
					</dt>
					<dd style="line-height: 25px;width: 85%;">
						<textarea rows="10" cols="" id="text_contents" style="width:100%;"></textarea>
					</dd>
				</dl>
			</div>
		</div>
	</div>
	
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" onclick="bsrpSave();" value="신청하기" />
		</div>
	</div>

</div>

<form id="viewerForm" name="viewerForm" method="post" action="http://gw.jif.re.kr/gw/outProcessLogOn.do" target="viewer">
<%-- <form id="viewerForm" name="viewerForm" method="post" action="http://121.126.239.223/gw/outProcessLogOn.do" target="viewer"> --%>
<input type="hidden" id="outProcessCode" name="outProcessCode" value="BSRPR">
<input type="hidden" id="mod" name="mod" value="W">
<input type="hidden" id="loginId" name="loginId" value="${userInfo.id}">
<input type="hidden" name="contentsEnc" value="O">
<input type="hidden" id="contentsStr" name="contentsStr">
<input type="hidden" id="subjectStr" name="subjectStr">
<input type="hidden" id="approKey" name="approKey">
</form>

<script>
var erpOption = {BgtMngType: "2", CauseUseYn: "1", BizGovUseYn: "0", BgtAllocatUseYn: "0", BottomUseYn: "0"};
var langCode = 'KR';
var abdocuInfo = {};
var template_key = 52;
var mode = 0;
var trafficArray = {}; //운임비용
var trafficType = 1; //왕복구분
var trafficTypeNm = '편도'; //왕복구분
var erpToEmpInfo = {}; //직급별 여비
var bs_seq = ${bs_seq};
var abdocu_no = "";
var bs_type = "2";

var dataSource = new kendo.data.DataSource({
	serverPaging: true,
	pageSize: 10,
    transport: { 
        read:  {
            url:  "<c:url value='/bsrp/getFareListSearch' />",
            dataType: "json",
            type: 'post'
        },
      	parameterMap: function(data, operation) {
      		data.type = 'all';
      		data.tfcmn = $('#popSearchTfcmn').val();
      		data.trff = $('#popSearchTrff').val();
      		data.alocTxt = $('#popSearchAloc').val();
      		data.strtpnt = 'all';
      		data.aloc = 'all';
      		return data;
     	}
    },
    schema: {
      data: function(response) {
        return response.list;
      },
      total: function(response) {
	        return response.totalCount;
	      }
    }
});

var userDataSource = new kendo.data.DataSource({
	serverPaging: true,
	pageSize: 10,
    transport: { 
        read:  {
            url:  "<c:url value='/common/getUserList' />",
            dataType: "json",
            type: 'post'
        },
      	parameterMap: function(data, operation) {
      		data.search_name = $('#searchNm').val();
      		data.search_dept = $('#searchDp').val();
      		data.search_num = $('#searchNum').val();
      		return data;
     	}
    },
    schema: {
      data: function(response) {
        return response.list;
      },
      total: function(response) {
	        return response.totalCount;
	      }
    }
});

$.fn.noComma = function(){

	return $(this).val().replace(/,/g,"");
}

$(function(){
	
	
	$('#OPT_01_2').prop('checked', true);
	$('#OPT_02_1').prop('checked', true);
	
	$('#txtGisuDate').kendoDatePicker({
	    culture : "ko-KR",
	    format : "yyyy-MM-dd",
	    value : new Date(),
	}).attr("readonly", true);
	
	var startDate = $('#startDt').kendoDatePicker({
	    culture : "ko-KR",
	    format : "yyyy-MM-dd",
	    value : new Date(),
	    change: startChange
	}).attr("readonly", true).data("kendoDatePicker");

	var endDate = $('#endDt').kendoDatePicker({
	    culture : "ko-KR",
	    format : "yyyy-MM-dd",
	    value : new Date(),
	}).attr("readonly", true).data("kendoDatePicker");

	function startChange(){
		if(startDate.value() > endDate.value()){
			endDate.value('');
		}
		endDate.min(startDate.value());
	}
	
	$("#fareList").kendoGrid({
        dataSource: dataSource,
        height: 460,
        sortable: false,
        pageable: false,
        persistSelection: true,
        selectable: "multiple",
        columns: [
      	 {
             field: "strtpnt_kr",
             title: "출발지",
         }, {
             field: "aloc_kr",
             title: "도착지",
         }, {
        	 template : pymnTemp,
             field: "pymntamt",
             title: "금 액",
         }, {
             field: "rm",
             title: "비 고",
         }],
    }).data("kendoGrid");
	
	$("#userList").kendoGrid({
        dataSource: userDataSource,
        height: 460,
        sortable: false,
        pageable: false,
        persistSelection: true,
        selectable: "multiple",
        columns: [
       	 {
            title: "직원번호",
            columns: [{
                field: "erp_emp_num",
                headerTemplate: function(){
    				return '<input type="text" style="width:90%;" id="searchNum" class="userHeaderInput">';
    	        },
     		}]
        }, {
            title: "이름",
            columns: [{
                field: "emp_name",
                headerTemplate: function(){
    				return '<input type="text" style="width:90%;" id="searchNm" class="userHeaderInput">';
    	        },
     		}]
        }, {
            title: "부서",
            columns: [{
                field: "dept_name",
                headerTemplate: function(){
    				return '<input type="text" style="width:90%;" id="searchDp" class="userHeaderInput">';
    	        },
     		}]
        }],
    }).data("kendoGrid");
	
	$(document).on('dblclick', '#userList .k-grid-content tr', function(){
		var gData = $("#userList").data('kendoGrid').dataItem(this);
		
		if(popupId == 'txtDEPT_NM'){
			$('#txtDEPT_NM').val(gData.dept_name + ' / ' + gData.emp_name).attr('code', gData.comp_seq);
			$('#txtKOR_NM').val(gData.emp_seq).attr('code', gData.erp_emp_num).attr('dp_nm', gData.dept_name).attr('ep_nm', gData.emp_name).attr('pt_nm', gData.position_name);
			
			$('#txt_ProjectName').val('').attr('code','');
        	$('.bbTxt').text('');
        	$('.non-requirement').val('').attr('code', '');
        	$('#txt_BUDGET_LIST').val('').attr('code', '');
        	$('#BGT03_Txt').val('').attr('code', '');

		}else{
			$('#dty_seq').val(gData.dept_name + ' / ' + gData.emp_name).attr('emp_seq', gData.emp_seq);
		}
		
		$('#userPopUp').data("kendoWindow").close();
		
	});
	
	$(document).on('dblclick', '#fareList .k-grid-content tr', function(){
		var gData = $("#fareList").data('kendoGrid').dataItem(this);
		
		trafficType = $('#trafficType').val();
		trafficTypeNm = $('#trafficType option:selected').text();
		//단순 운임비용만 필요한 걸까?
		trafficArray = gData;
		
		$('#farePopUp').data("kendoWindow").close();
	});
	
	$('.userHeaderInput').on('keydown', function(key){
		 if (key.keyCode == 13) {
			 $("#userList").data('kendoGrid').dataSource.read();
        }
	});
	
	$('.userInput').on('change', function(){
		$(this).val(numberWithCommas($(this).val().replace(/[^0-9]/g,"")));
		totalSum();
	});

	$('#toll').on('change', function(){
		$(this).val(numberWithCommas($(this).val().replace(/[^0-9]/g,"")));
		totalSum();
	});
	
	changeTfcmn();
	changeAirline();
	$(".mileage").bind("change", function(){
		$(this).val($(this).val().toMoney());
	});
	bsrpInit();
})

function bsrpInit(){
	$.ajax({
		url : "<c:url value='/bsrp/getBsrpInfo' />",
		dataType : 'json',
		type : 'POST',
		data : {bs_seq : bs_seq},
		success : function(result) {
			$("#txtDEPT_NM").val(result.applcnt_dept + " / " + result.applcnt_nm);
			$("#txtKOR_NM").attr("dp_nm", result.applcnt_dept);
			$("#txtKOR_NM").attr("ep_nm", result.applcnt_nm);
			$("#txtKOR_NM").attr("pt_nm", result.applcnt_pt);
			$("#txtKOR_NM").val(result.applcnt_seq);
			$("#dty_seq").val(result.dty_seq);
			$("#txtGisuDate").val(result.rqstdt);
			if(result.bs_type == "2"){
				$("#bs_des").val(result.bs_des);
			}else{
				bs_type = result.bs_type;
				$("#bs_des_txt").show();
				$("#report_area").hide();
				$("#bs_des").remove();
			}
			$("#bs_des_txt").val(result.bs_des_txt);
			$("#startDt").val(result.bs_start);
			$("#endDt").val(result.bs_end);
			
			var s = moment( $('#startDt').val() );
			var e = moment( $('#endDt').val() );
			
			if(s._isValid && e._isValid){
				
				var datCnt = e.diff(s, 'days');
				
				$('#dayCntTemp').val(datCnt + 1);
				
				$('#dayCnt').text('('+(datCnt + 1)+' 일간)');
			}
			
			if(result.car_yn == "0"){
				$("#car1").prop("selected", true);
// 				$("#car2").prop("disabled", true);
			}else{
				$("#car2").prop("selected", true);
// 				$("#car1").prop("disabled", true);
			}
			$("#topSearchTfcmn").val(result.tfcmn);
			$("#topSearchRoom").val(result.room_yn);
			$("#topSearchFood").val(result.food_yn);
			$("#rm").val(result.rm);
			$("#fare").val(result.fare.toString().toMoney());
			$("#daily").val(result.daily.toString().toMoney());
			$("#toll").val(result.toll.toString().toMoney());
			$("#room").val(result.room.toString().toMoney());
			$("#food").val(result.food.toString().toMoney());
			$("#total").val(result.total.toString().toMoney());
			$("#totalOrg").val(result.total.toString().toMoney());
			$("#txt_total").html(result.total.toString().toMoney());
			$("#txtDIV_NM").val(result.erp_div_nm);
			$("#txtDIV_NM").attr("code", result.erp_div_cd);
			$("#txt_ProjectName").val(result.mgt_nm);
			$("#txt_ProjectName").attr("code", result.mgt_cd);
			$("#txt_BUDGET_LIST").val(result.abgt_nm);
			$("#txt_BUDGET_LIST").attr("code", result.abgt_cd);
			$("#BGT03_Txt").val(result.erp_bgt_nm3);
			$("#fg").val(result.fg);
			$("#rmk_dc").val(result.rmk_dc);
			abdocu_no = result.abdocu_no;
			
			$("#txtGisuDate").data("kendoDatePicker").enable(false);
			$("#startDt").data("kendoDatePicker").enable(false);
			$("#endDt").data("kendoDatePicker").enable(false);
			$("#bs_des").attr("disabled", false);
			$("#topSearchTfcmn").attr("disabled", false);
			$("#topSearchRoom").attr("disabled", false);
			$("#topSearchFood").attr("disabled", false);
			abdocu.BudgetInfo.getBudgetInfo();
			
			changeTfcmn();
			if(result.mileage){
				$("#topSearchAirline").val(result.mileage.airline);
				changeAirline();
				$("#newMileage").val(result.mileage.new_mileage);
				$("#useMileage").val(result.mileage.use_mileage);
			}else{
				changeAirline();
			}
			
		}
	});
}

var pymnTemp = function(row){
	return numberWithCommas(row.pymntamt) + '원';
}

function fareTopChange(){
	$("#fareList").data('kendoGrid').dataSource.read();
}

function totalSum(){
	var sum = 0;
	$.each($('.sumData'), function(i, v){
		
		sum += Number($(v).val().replace(/[^0-9]/g,""));
		
	});
	
	$('#total').val(numberWithCommas(sum));
	$('#txt_total').html(numberWithCommas(sum));
}

function foodChange(e){
	$('#food_txt').val($(e).val().replace(/[^0-9]/g,""));
	$('#food').val(numberWithCommas($('#food_txt').val()));
}

function changeTfcmn(){
	if($("#topSearchTfcmn").val() == "006"){
		$("#mileageArea").show();
	}else{
		$("#mileageArea").hide();
	}
}

function changeAirline(){
	var saveObj = {};
	saveObj.applcnt_seq = $('#txtKOR_NM').val();
	saveObj.airline = $('#topSearchAirline').val();
	$.ajax({
		url : "<c:url value='/bsrp/getBsrpMileage' />",
		dataType : 'json',
		type : 'POST',
		data : saveObj,
		async : false,
		success : function(result) {
			$("#savedMileage").val(result.savedMileage.toString().toMoney());
			$("#useMileage").val("0");
			$("#newMileage").val("0");
		}
	});
}

function checkMileage(){
	var savedMileage = parseInt($("#savedMileage").val().toMoney2());
	var useMileage = parseInt($("#useMileage").val().toMoney2());
	if(savedMileage < useMileage){
		alert("사용마일리지는 누적마일리지를 초과 할 수 없습니다.");
		$("#useMileage").val("0");
	}
}

function bsrpSaveVal(){
	if(!$("#fare").val()){
		alert("운임을 입력하세요.")
		return false;
	}
	if(!$("#daily").val()){
		alert("일비를 입력하세요.")
		return false;
	}
	if(!$("#txtDIV_NM").val()){
		alert("예산회계단위를 입력하세요.")
		return false;
	}
	if(!$("#txt_ProjectName").val()){
		alert("프로젝트를 입력하세요.")
		return false;
	}
	if(!$("#txt_BUDGET_LIST").val()){
		alert("예산과목을 입력하세요.")
		return false;
	}
	var total = parseInt($("#total").val().toMoney2());
	var totalOrg = parseInt($("#totalOrg").val().toMoney2());
	var leftAm = parseInt($("#td_veiw_LEFT_AM").text().toMoney2());
	if(total > (leftAm + totalOrg)){
		alert("예산을 초과 하였습니다. 확인해주세요.");
		return false;
	}
	
	return true;
}

function bsrpSave(){
	
	if(!bsrpSaveVal()){
		return;
	}
	
	var saveObj = {
			bs_type			: '2',										//신청종류
			fare			: $('#fare').noComma(),						//운임
			daily			: $('#daily').noComma(),					//일비
			toll			: $('#toll').noComma(),						//통행비
			room			: $('#room').noComma(),						//숙박비
			food			: $('#food').noComma(),						//식비
			total			: $('#total').noComma(),					//합계
			bs_start		: $('#startDt').val(),						//출장시작일
			bs_end			: $('#endDt').val(),						//출장 종료일
			bs_des			: $('#bs_des').val(),						//출장지
			bs_des_txt		:  $('#bs_des option:selected').text(),		//출장지
			car_yn			: $('input[name=car]:checked').val(),		//업무차량유무
			tfcmn			: $('#topSearchTfcmn').val(),				//교통수단
			applcnt_seq		: $('#txtKOR_NM').val(),					//신청자
			rqstdt			: $('#txtGisuDate').val(),					//신청일
			room_yn			: $('#topSearchRoom').val(),				//숙박제공유무
			food_yn			: $('#topSearchFood').val(),				//식비제공유무
			dty_seq			: $('#dty_seq').val(),						//직무대행자
			bs_day			: $('#dayCntTemp').val(),					//출장기간
			app_user_seq	: '',										//승인권자
			fsse			: $('#txtDIV_NM').attr('code'),				//회계구분
			pjt_cd			: $('#txt_ProjectName').attr('code'),		//프로젝트코드
			pjt_nm			: $('#txt_ProjectName').val(),				//프로젝트명
			rm				: $('#rm').val(),							//비고
			budget_cd		: $('#txt_BUDGET_LIST').attr('code'),		//예산과목
			budget_nm		: $('#txt_BUDGET_LIST').val(),				//예산과목
			fg				: $('#fg').val(),							//과세구분
			dp_nm			: $('#txtKOR_NM').attr('dp_nm'),						
			ep_nm			: $('#txtKOR_NM').attr('ep_nm'),						
			pt_nm			: $('#txtKOR_NM').attr('pt_nm'),						
			
	}
	
	/*품의정보입력 프로젝트*/
	saveObj.abdocu_no       = '0';
	saveObj.docu_mode       = "0";
	saveObj.docu_fg         = "1";
	saveObj.docu_fg_text    = "구매품의서";
    saveObj.erp_co_cd       = abdocuInfo.erp_co_cd;
    saveObj.erp_co_nm       = abdocuInfo.erp_co_nm;
    saveObj.erp_dept_cd     = abdocuInfo.erp_dept_cd;
    saveObj.erp_dept_nm     = abdocuInfo.erp_dept_nm;
    saveObj.erp_emp_cd      = abdocuInfo.erp_emp_cd;
    saveObj.erp_emp_nm      = abdocuInfo.erp_emp_nm;
    saveObj.erp_div_cd      = $("#txtDIV_NM").attr("CODE");
    saveObj.erp_div_nm      = $("#txtDIV_NM").val();
    saveObj.mgt_cd          = $("#txt_ProjectName").attr("CODE");
	saveObj.mgt_nm_encoding = $("#txt_ProjectName").val();
	saveObj.rmk_dc          = $('#rmk_dc').val();
    saveObj.erp_gisu_dt     = $("#txtGisuDate").val().replace(/-/gi,"");
    saveObj.erp_gisu_from_dt= abdocuInfo.erp_gisu_from_dt;
    saveObj.erp_gisu_to_dt  = abdocuInfo.erp_gisu_to_dt;
    saveObj.erp_gisu        = abdocuInfo.erp_gisu;
    saveObj.erp_year        = acUtil.util.getUniqueTime().substring(0, 4);
    /*품의정보입력 프로젝트*/
    
    /*품의정보입력 예산*/
    saveObj.set_fg 			= "1";
    saveObj.vat_fg 			= $('#fg').val();
    saveObj.tr_fg 			= "1";
    saveObj.div_nm2			= $("#txtDIV_NM").val();
	saveObj.div_cd2			= $("#txtDIV_NM").attr("CODE");
	saveObj.erp_gisu_sq		= "0";
	saveObj.erp_bq_sq		= "0";
	saveObj.erp_bgt_nm1		= $("#BGT01_NM").val();
	saveObj.erp_bgt_nm2		= $("#BGT02_NM").val();
	saveObj.erp_bgt_nm3		= $("#BGT03_NM").val();
	saveObj.erp_bgt_nm4		= $("#BGT04_NM").val();
	saveObj.erp_open_am		= $("#OPEN_AM").val();
	saveObj.erp_acct_am		= $("#ACCT_AM").val();
	saveObj.erp_delay_am	= $("#DELAY_AM").val();
	saveObj.erp_term_am		= $("#APPLY_AM").val();
	saveObj.erp_left_am		= $("#LEFT_AM").val();
	saveObj.ctl_fg			= "4";
	saveObj.abgt_cd			= $("#txt_BUDGET_LIST").attr("CODE");
	saveObj.abgt_nm			= $("#txt_BUDGET_LIST").val();
	saveObj.apply_am		= $("#total").val().toMoney2() || "0";
    /*품의정보입력 예산*/
    
    /*품의정보입력 채주*/
    var unitAmt = $("#total").val().toMoney2() || "0";
    var supAmt = unitAmt;
    var vatAmt = "0";
    if(saveObj.vat_fg == "1"){
		var supAmt = ((Math.round(parseInt(unitAmt,10) / 1.1 * 10)) / 10);
		supAmt = Math.round(supAmt, 10);
		vatAmt = (parseInt(unitAmt,10) - supAmt).toString().toMoney() || 0;
		supAmt = supAmt.toString();
	}
    saveObj.tr_cd       = ""; /*거래처코드*/
    saveObj.tr_nm       = ""; /*거래처명*/
    saveObj.ceo_nm      = ""; /*대표자명*/
    saveObj.unit_am     = unitAmt; /*금액*/
    saveObj.sup_am      = supAmt; /*공급가액*/
    saveObj.vat_am      = vatAmt; /*부가세*/
    saveObj.btr_nm      = ""; /*금융기관*/
    saveObj.btr_cd      = "";/*금융기관*/
    saveObj.jiro_nm     = ""; /*금융기관*/
    saveObj.jiro_cd     = ""; /*금융기관*/
    saveObj.depositor   = ""; /*예금주*/
    saveObj.item_nm     = ""; /*품명*/
    saveObj.item_cnt    = "0"; /*수량*/
    saveObj.item_am     = "0"; /*단가*/
    saveObj.emp_nm      = ""; /*사원명*/
    saveObj.ba_nb       = ""; /*계좌번호*/
    saveObj.ctr_cd      = ""; /*카드거래처 코드*/
    saveObj.ctr_card_num = ""; /*카드거래처 코드*/
    saveObj.ctr_nm      = ""; /*카드거래처 이름*/    
    saveObj.reg_nb      = ""; /*사업자코드*/
    saveObj.tel         = ""; /*전화번호*/
    saveObj.ndep_am     = "0"; /*기타소득필요경비*/
    saveObj.inad_am     = "0";  /*소득금액*/
    saveObj.intx_am     = "0";  /*소득세액*/
    saveObj.rstx_am     = "0";  /*주민세액*/
    saveObj.wd_am       = "0"; 
    saveObj.etcrvrs_ym  = ""; /*기타소득귀속년월*/
    saveObj.etcdummy1   = ""; /*소득구분*/
    saveObj.etcdata_cd  = ""; /*소득구분*/
    saveObj.tax_dt      = ""; /*신고기준일*/
    saveObj.it_use_dt   = ""; 
    saveObj.it_use_no   = ""; 
    saveObj.it_card_no  = ""; 
    saveObj.et_yn       = ""; /*erp data*/
    saveObj.tr_fg       = "1"; // $(".txt_TR_FG", parentEle).val() || "";  /*erp data*/
    saveObj.tr_fg_nm    = "거래처"; // $(".txt_TR_FG_NM", parentEle).val() || ""; /*erp data*/
    saveObj.attr_nm     = ""; /*erp data*/
    saveObj.ppl_nb      = ""; /*erp data*/
    saveObj.addr        = ""; /*erp data*/
    saveObj.trcharge_emp = ""; /*erp data*/
    saveObj.etcrate     = ""; /*erp data*/
    /*품의정보입력 채주*/
    
    /*마일리지*/
    if($("#topSearchTfcmn").val() == "006"){
	    saveObj.airline = $("#topSearchAirline").val();
	    saveObj.saved_mileage = $("#savedMileage").val().toMoney2();
	    saveObj.new_mileage = $("#newMileage").val().toMoney2();
	    saveObj.use_mileage = $("#useMileage").val().toMoney2();
    }
    /*마일리지*/
    
    saveObj.bs_seq = bs_seq;
    saveObj.report_json = JSON.stringify({
    		fare			: $('#fare').noComma(),						//운임
			daily			: $('#daily').noComma(),					//일비
			toll			: $('#toll').noComma(),						//통행비
			room			: $('#room').noComma(),						//숙박비
			food			: $('#food').noComma(),						//식비
			total			: $('#total').noComma(),					//합계
			unit_am     	: unitAmt,									/*금액*/
		    sup_am      	: supAmt, 									/*공급가액*/
    		vat_am      	: vatAmt,		 							/*부가세*/
			bs_des			: $('#bs_des').val(),						//출장지
			bs_des_txt		:  $('#bs_des option:selected').text(),		//출장지
			car_yn			: $('input[name=car]:checked').val(),		//업무차량유무
			tfcmn			: $('#topSearchTfcmn').val(),				//교통수단
			room_yn			: $('#topSearchRoom').val(),				//숙박제공유무
			food_yn			: $('#topSearchFood').val(),				//식비제공유무
    });
    
	$.ajax({
		url : "<c:url value='/bsrp/bsrpReportSave' />",
		dataType : 'json',
		type : 'POST',
		data : saveObj,
		success : function(result) {
			
			$('#approKey').val(abdocu_no);
// 			$('#approKey').val("bsrpr_" + bs_seq);
			
			approvalOpen(result);
		}
	});
	
}

function approvalOpen(result){
	$('#contentsStr').val(getContentsStr(result));
	var data = {};
	data.processId = $('#outProcessCode').val();
	data.approKey = $('#approKey').val();
	data.title = $("#rm").val();
	data.content = $('#contentsStr').val();
	$.ajax({
		type : 'POST',
		async: false,
		url : _g_contextPath_  + '/outProcess/outProcessTempInsert',
		data:data,
		dataType : 'json',
		success : function(data) {
			if(data.resultCode == "SUCCESS"){
				window.open("",  "viewer", "width=1000px, height=900px, resizable=no, scrollbars = yes, status=no, top=50, left=50", "newWindow");
				$("#viewerForm").submit();
			}
		}
	});
}

function getContentsStr(result){
	var contentsStr = "";
	contentsStr += "<TABLE border='1' cellspacing='0' cellpadding='0' style='border-collapse:collapse;border:none;'>";
	contentsStr += "<TR>";
	contentsStr += "	<TD rowspan='2' colspan='4' valign='middle' width='67' height='47' style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-10%;line-height:160%'>발　　의</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD rowspan='2' colspan='10' valign='middle' width='134' height='47' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>" + moment(result.erp_gisu_dt).format("YYYY.MM.DD") + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD rowspan='2' colspan='2' valign='middle' width='33' height='47' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:100%'>&#56192;&#56619;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='5' valign='middle' width='58' height='37' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>장</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='4' valign='middle' width='130' height='37' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-family:'신명 신문명조,한컴돋움''>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD rowspan='2' colspan='2' valign='middle' width='73' height='47' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='text-align:center;font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>발　　의</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD rowspan='2' colspan='6' valign='middle' width='122' height='47' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD rowspan='2' valign='middle' width='32' height='47' style='border-left:solid #000000 0.4pt;border-right:solid #000000 1.1pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:100%'>&#56192;&#56619;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD rowspan='2' colspan='5' valign='middle' width='50' height='33' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>관</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD rowspan='2' colspan='4' valign='middle' width='133' height='33' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-family:'신명 신문명조,한컴돋움';letter-spacing:-5%'>" + result.erp_bgt_nm1 + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD rowspan='2' colspan='4' valign='middle' width='70' height='48' style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 0pt 1.4pt 0pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:0%;line-height:100%'>원인행위 </SPAN><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-5%;line-height:100%'>부기재</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD rowspan='2' colspan='10' valign='middle' width='136' height='48' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>" + moment().format("YYYY.MM.DD") + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD rowspan='2' colspan='2' valign='middle' width='33' height='48' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:100%'>&#56192;&#56619;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD rowspan='2' colspan='2' valign='middle' width='68' height='48' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-25%;line-height:100%'>지 출 부　기　　재</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD rowspan='2' colspan='6' valign='middle' width='121' height='48' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD rowspan='2' valign='middle' width='32' height='48' style='border-left:solid #000000 0.4pt;border-right:solid #000000 1.1pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:100%'>&#56192;&#56619;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD rowspan='2' colspan='5' valign='middle' width='50' height='33' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>세항</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD rowspan='2' colspan='4' valign='middle' width='133' height='33' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-9%;line-height:160%'>" + result.erp_bgt_nm2 + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD rowspan='2' colspan='4' valign='middle' width='67' height='38' style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-10%;line-height:160%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD rowspan='2' colspan='10' valign='middle' width='139' height='38' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD rowspan='2' colspan='2' valign='middle' width='33' height='38' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD rowspan='2' colspan='2' valign='middle' width='68' height='38' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:130%;'><SPAN STYLE='font-family:'신명 신문명조,한컴돋움';letter-spacing:-10%'>지급명령&nbsp;</SPAN></P>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:130%;'><SPAN STYLE='font-family:'신명 신문명조,한컴돋움';letter-spacing:-10%'>발행부기재</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD rowspan='2' colspan='6' valign='middle' width='121' height='38' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD rowspan='2' valign='middle' width='32' height='38' style='border-left:solid #000000 0.4pt;border-right:solid #000000 1.1pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:100%'>&#56192;&#56619;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD rowspan='2' colspan='5' valign='middle' width='50' height='37' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-19%;line-height:160%'>세세항</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD rowspan='2' colspan='4' valign='middle' width='133' height='37' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>" + result.erp_bgt_nm3 + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD rowspan='2' colspan='4' valign='middle' width='67' height='42' style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-10%;line-height:160%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD rowspan='2' colspan='10' valign='middle' width='139' height='42' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD rowspan='2' colspan='2' valign='middle' width='33' height='42' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD rowspan='2' colspan='2' valign='middle' width='68' height='42' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='font-size:12.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-25%;line-height:100%'>지급명령</SPAN></P>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='font-size:12.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-25%;line-height:100%'>번　　호</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD rowspan='2' colspan='7' valign='middle' width='153' height='42' style='border-left:solid #000000 0.4pt;border-right:solid #000000 1.1pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>제　　　호</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='5' valign='middle' width='50' height='37' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>목</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='4' valign='middle' width='133' height='37' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-15%;line-height:100%'>" + result.erp_bgt_nm4 + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='13' valign='middle' width='171' height='44' style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-25%;line-height:100%'>개산급에대한정산</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='4' valign='middle' width='71' height='44' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-25%;line-height:160%'>계산액</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='8' valign='middle' width='179' height='44' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='line-height:100%;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-25%;line-height:100%'>　　년　월　일</SPAN></P>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='line-height:100%;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-25%;line-height:100%'>　　￦</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='2' valign='middle' width='68' height='44' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:10%;line-height:160%'>정산액</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='7' valign='middle' width='153' height='44' style='border-left:solid #000000 0.4pt;border-right:solid #000000 1.1pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-25%;line-height:160%'>　　￦</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD rowspan='3' valign='middle' width='34' height='123' style='border-left:solid #000000 1.1pt;border-right:none;border-top:solid #000000 0.4pt;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='33' valign='middle' width='608' height='36' style='border-left:none;border-right:solid #000000 1.1pt;border-top:solid #000000 0.4pt;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0>";
	contentsStr += "<TABLE border='1' cellspacing='0' cellpadding='0' style='border-collapse:collapse;border:none;'>";
	contentsStr += "<TR>";
	contentsStr += "	<TD valign='middle' width='89' height='5' style='border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:1.0pt;color:#ffffff;line-height:160%'>주임연구원</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD valign='middle' width='89' height='5' style='border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:1.0pt;color:#ffffff;line-height:160%'>경영지원팀장</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD valign='middle' width='89' height='5' style='border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:1.0pt;color:#ffffff;line-height:160%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD valign='middle' width='89' height='5' style='border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:1.0pt;color:#ffffff;line-height:160%'>연구원</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD valign='middle' width='89' height='5' style='border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:1.0pt;color:#ffffff;line-height:160%'>경영지원팀장</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "</TABLE></P>";
	contentsStr += "<P CLASS=HStyle0></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='4' valign='middle' width='44' height='42' style='border-left:none;border-right:solid #000000 0.4pt;border-top:none;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='4' valign='middle' width='42' height='42' style='border-left:solid #000000 0.4pt;border-right:solid #ffffff 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:right;'><SPAN STYLE='font-size:16.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-10%;font-weight:bold;line-height:160%'>금</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='21' valign='middle' width='435' height='42' style='border-left:solid #ffffff 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:left;'><SPAN STYLE='font-size:20.0pt;font-family:'신명 신문명조,한컴돋움';font-weight:bold;line-height:160%'><A NAME='FieldStart:amountNum'></A></SPAN><SPAN STYLE='font-size:20.0pt;font-family:'신명 신문명조,한컴돋움';font-weight:bold;font-style:italic;color:#ff0000;line-height:160%'>" + result.total.toMoney() + "</SPAN><SPAN STYLE='font-size:20.0pt;font-family:'신명 신문명조,한컴돋움';font-weight:bold;line-height:160%'><A NAME='FieldEnd:amountNum'></A></SPAN><SPAN STYLE='font-size:16.0pt;font-family:'신명 신문명조,한컴돋움';font-weight:bold;line-height:160%'>원</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD valign='middle' width='37' height='42' style='border-left:solid #000000 0.4pt;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD rowspan='2' colspan='3' valign='middle' width='49' height='86' style='border-left:none;border-right:solid #000000 1.1pt;border-top:none;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='4' valign='middle' width='42' height='44' style='border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='13' valign='middle' width='173' height='44' style='border-left:none;border-right:none;border-top:solid #000000 0.4pt;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='2' valign='middle' width='26' height='44' style='border-left:none;border-right:solid #ffffff 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:16.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-20%;font-weight:bold;line-height:160%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='11' valign='middle' width='317' height='44' style='border-left:solid #ffffff 0.4pt;border-right:none;border-top:none;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:16.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-20%;font-weight:bold;line-height:160%'>금" + numToKOR(result.total) + "원</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='11' valign='middle' width='167' height='25' style='border-left:solid #000000 1.1pt;border-right:none;border-top:none;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='4' valign='middle' width='54' height='25' style='border-left:none;border-right:none;border-top:none;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='19' valign='middle' width='421' height='25' style='border-left:none;border-right:solid #000000 1.1pt;border-top:none;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='11' valign='middle' width='167' height='55' style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>년 월 일</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='4' valign='middle' width='54' height='55' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-15%;line-height:100%'>청구자</SPAN></P>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-15%;line-height:100%'>성&nbsp; 명</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='8' valign='middle' width='108' height='55' style='border-left:solid #000000 0.4pt;border-right:solid #ffffff 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:100%'>" +result.ep_nm+ "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD valign='middle' width='46' height='55' style='border-left:solid #ffffff 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:100%'>&#56192;&#56619;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='10' valign='middle' width='267' height='55' style='border-left:solid #000000 0.4pt;border-right:solid #000000 1.1pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='line-height:100%;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-15%;line-height:100%'>&nbsp;&nbsp;위 금액을&nbsp; 20&nbsp; 년&nbsp;&nbsp;&nbsp; 월&nbsp;&nbsp; 일</SPAN></P>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='line-height:100%;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-15%;line-height:100%'>&nbsp;&nbsp;영수하였음.&nbsp; </SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD rowspan='2' colspan='4' valign='middle' width='67' height='68' style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-15%;line-height:100%'>근무처</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD rowspan='2' colspan='8' valign='middle' width='101' height='68' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-15%;line-height:100%'>생물산업</SPAN></P>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-15%;line-height:100%'>진흥원</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='3' valign='middle' width='53' height='36' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-15%;line-height:100%'>봉&nbsp; 급</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='9' valign='middle' width='154' height='36' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='line-height:100%;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-15%;line-height:100%'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;급&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 호</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD rowspan='2' colspan='2' valign='middle' width='80' height='68' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:130%;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-5%;line-height:130%'>영수자</SPAN></P>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:130%;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-5%;line-height:130%'>성&nbsp; 명</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD rowspan='2' colspan='6' valign='middle' width='143' height='68' style='border-left:solid #000000 0.4pt;border-right:solid #ffffff 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>" +result.ep_nm+ "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD rowspan='2' colspan='2' valign='middle' width='44' height='68' style='border-left:solid #ffffff 0.4pt;border-right:solid #000000 1.1pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>&#56192;&#56619;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='3' valign='middle' width='53' height='32' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-15%;line-height:160%'>급&nbsp; 여</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='9' valign='middle' width='154' height='32' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-15%;line-height:160%'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;원</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD rowspan='2' colspan='7' valign='middle' width='90' height='58' style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-15%;line-height:100%'>주관부서</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='5' valign='middle' width='78' height='29' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>부 서 명</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='12' valign='middle' width='207' height='29' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:12.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>" + result.dp_nm + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='2' valign='middle' width='80' height='29' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-15%;line-height:160%'>출 장 지</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='8' valign='middle' width='187' height='29' style='border-left:solid #000000 0.4pt;border-right:solid #000000 1.1pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>" + result.bs_des_txt + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='5' valign='middle' width='78' height='29' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>직&nbsp;&nbsp;&nbsp; 위</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='12' valign='middle' width='207' height='29' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>" + result.pt_nm + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='2' valign='middle' width='80' height='29' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-15%;line-height:160%'>교통수단</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='8' valign='middle' width='187' height='29' style='border-left:solid #000000 0.4pt;border-right:solid #000000 1.1pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>" + $('#topSearchTfcmn option:selected').text() + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD rowspan='5' colspan='2' valign='middle' width='45' height='146' style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 1.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-15%;line-height:160%'>취</SPAN></P>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-15%;line-height:160%'>급</SPAN></P>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-15%;line-height:160%'>자</SPAN></P>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>&#56192;&#56619;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD rowspan='5' colspan='5' valign='middle' width='45' height='146' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 1.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-15%;line-height:160%'>부</SPAN></P>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-15%;line-height:160%'>서</SPAN></P>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-15%;line-height:160%'>장</SPAN></P>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>&#56192;&#56619;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='5' valign='middle' width='78' height='29' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>출장기간</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='22' valign='middle' width='475' height='29' style='border-left:solid #000000 0.4pt;border-right:solid #000000 1.1pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>" + result.bs_start.replace(/-/g, ".") + " ~ " + result.bs_end.replace(/-/g, ".") + " (" + result.bs_day + "일간)</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='5' valign='middle' width='78' height='50' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>출장목적</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='22' valign='middle' width='475' height='29' style='border-left:solid #000000 0.4pt;border-right:solid #000000 1.1pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:12.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>" + result.rm + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='5' valign='middle' width='78' height='29' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 1.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>숙박제공</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='12' valign='middle' width='207' height='29' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 1.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>" + $('#topSearchRoom option:selected').text() + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='2' valign='middle' width='80' height='29' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 1.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-15%;line-height:160%'>식비제공</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='8' valign='middle' width='187' height='29' style='border-left:solid #000000 0.4pt;border-right:solid #000000 1.1pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 1.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>" + $('#topSearchFood option:selected').text() + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='5' valign='middle' width='78' height='29' style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-top:solid #000000 1.1pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>운임요금</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='7' valign='middle' width='95' height='29' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 1.1pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-15%;line-height:160%'>" + result.fare.toMoney() + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='5' valign='middle' width='112' height='29' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 1.1pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-15%;line-height:160%'>일비</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='2' valign='middle' width='80' height='29' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 1.1pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-15%;line-height:160%'>" + result.daily.toMoney() + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='3' valign='middle' width='92' height='29' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 1.1pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-15%;line-height:160%'>식비</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='5' valign='middle' width='95' height='29' style='border-left:solid #000000 0.4pt;border-right:solid #000000 1.1pt;border-top:solid #000000 1.1pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-15%;line-height:160%'>" + result.food.toMoney() + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='5' valign='middle' width='78' height='29' style='border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 1.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';line-height:160%'>숙박료</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='7' valign='middle' width='95' height='29' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 1.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-15%;line-height:160%'>" + result.room.toMoney() + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='5' valign='middle' width='112' height='29' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 1.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-15%;line-height:160%'>통행료</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='2' valign='middle' width='80' height='29' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 1.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-15%;line-height:160%'>" + result.toll.toMoney() + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='3' valign='middle' width='92' height='29' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 1.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-15%;line-height:160%'>기타</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='5' valign='middle' width='95' height='29' style='border-left:solid #000000 0.4pt;border-right:solid #000000 1.1pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 1.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.0pt;font-family:'신명 신문명조,한컴돋움';letter-spacing:-15%;line-height:160%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "</TABLE></P>";
	if(bs_type == "3"){
		return contentsStr;
	}
	contentsStr += "<P CLASS=HStyle0 STYLE='text-align:center;line-height:200%;'></P>";
	contentsStr += "<P CLASS=HStyle0 STYLE='text-align:center;line-height:130%;'><SPAN STYLE='font-size:24.0pt;font-family:'HY헤드라인M';letter-spacing:-13%;font-weight:bold;line-height:130%'>출&nbsp; 장&nbsp; 결&nbsp; 과&nbsp; 보&nbsp; 고&nbsp; 서</SPAN></P>";
	contentsStr += "<TABLE border='1' cellspacing='0' cellpadding='0' style='border-collapse:collapse;border:none;'>";
	contentsStr += "<TR>";
	contentsStr += "	<TD rowspan='2' colspan='2' valign='middle' width='112' height='94' style='border-left:solid #000000 0.9pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.9pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.3pt;font-family:'굴림체';letter-spacing:-5%;font-weight:bold;line-height:160%'>출 장 자</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='3' valign='middle' width='137' height='38' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.9pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.3pt;font-family:'굴림체';letter-spacing:-5%;font-weight:bold;line-height:160%'>부 서 명</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='3' valign='middle' width='122' height='38' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.9pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.3pt;font-family:'굴림체';letter-spacing:-5%;font-weight:bold;line-height:160%'>직 위(직책)</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='2' valign='middle' width='148' height='38' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.9pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.3pt;font-family:'굴림체';letter-spacing:-5%;font-weight:bold;line-height:160%'>성&nbsp; 명</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='2' valign='middle' width='159' height='38' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.9pt;border-top:solid #000000 0.9pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.3pt;font-family:'굴림체';letter-spacing:-5%;font-weight:bold;line-height:160%'>비&nbsp; 고</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='3' valign='middle' width='137' height='56' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.3pt;font-family:'굴림체';letter-spacing:-5%;line-height:160%'>" + result.dp_nm + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='3' valign='middle' width='122' height='56' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.3pt;font-family:'굴림체';letter-spacing:-5%;line-height:160%'>" + result.pt_nm + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='2' valign='middle' width='148' height='56' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.3pt;font-family:'굴림체';letter-spacing:-5%;line-height:160%'>" + result.ep_nm + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='2' valign='middle' width='159' height='56' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.9pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:10.5pt;font-family:'굴림체';letter-spacing:-5%;line-height:160%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='2' valign='middle' width='112' height='46' style='border-left:solid #000000 0.9pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:13.3pt;font-family:'굴림체';letter-spacing:-5%;line-height:160%'>출장기간</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='10' valign='middle' width='566' height='46' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.9pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:13.3pt;font-family:'굴림체';letter-spacing:-5%;line-height:160%'>" + result.bs_start.replace(/-/g, ".") + " ~ " + result.bs_end.replace(/-/g, ".") + " (" + result.bs_day + "일간)</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='2' valign='middle' width='112' height='49' style='border-left:solid #000000 0.9pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='font-size:13.3pt;font-family:'굴림체';letter-spacing:-5%;line-height:100%'>출 장 지</SPAN></P>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:100%;'><SPAN STYLE='font-size:11.4pt;font-family:'굴림체';letter-spacing:-5%;line-height:100%'>(지역, 기관명)</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='10' valign='middle' width='566' height='49' style='border-left:solid #000000 0.4pt;border-right:solid #000000 0.9pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-size:13.3pt;font-family:'굴림체';letter-spacing:-5%;line-height:160%'>" + result.bs_des_txt + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='12' valign='middle' width='678' height='56' style='border-left:solid #000000 0.9pt;border-right:solid #000000 0.9pt;border-top:solid #000000 0.9pt;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='line-height:90%;'><SPAN STYLE='font-size:13.3pt;font-family:'굴림체';letter-spacing:-5%;line-height:90%'>&lt;출장내용&gt;</SPAN></P>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='line-height:90%;'><SPAN STYLE='font-size:13.3pt;font-family:'굴림체';letter-spacing:-5%;line-height:90%'>&nbsp;</SPAN></P>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='line-height:90%;'><SPAN STYLE='font-size:13.3pt;font-family:'굴림체';letter-spacing:-5%;line-height:90%'>&#10065; 일시</SPAN><SPAN STYLE='font-size:13.3pt;font-family:'굴림체';letter-spacing:-5%;line-height:90%'> </SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD valign='middle' width='29' height='31' style='border-left:solid #000000 0.9pt;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='margin-left:24.1pt;text-indent:-24.1pt;line-height:130%;'><SPAN STYLE='font-family:'굴림체';letter-spacing:-5%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='11' valign='middle' width='650' height='31' style='border-left:none;border-right:solid #000000 0.9pt;border-top:none;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='margin-left:24.1pt;text-indent:-24.1pt;line-height:130%;'><SPAN STYLE='font-size:11.4pt;font-family:'굴림체';letter-spacing:-5%;line-height:130%'>" + $("#text_date").val() + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='12' valign='middle' width='678' height='25' style='border-left:solid #000000 0.9pt;border-right:solid #000000 0.9pt;border-top:none;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='line-height:90%;'><SPAN STYLE='font-size:13.3pt;font-family:'굴림체';letter-spacing:-5%;line-height:90%'>&#10065; 목적</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD valign='middle' width='29' height='31' style='border-left:solid #000000 0.9pt;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='margin-left:24.1pt;text-indent:-24.1pt;line-height:130%;'><SPAN STYLE='font-family:'굴림체';letter-spacing:-5%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='11' valign='middle' width='650' height='31' style='border-left:none;border-right:solid #000000 0.9pt;border-top:none;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='margin-left:24.1pt;text-indent:-24.1pt;line-height:130%;'><SPAN STYLE='font-size:11.4pt;font-family:'굴림체';letter-spacing:-5%;line-height:130%'>" + $("#text_reason").val() + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='12' valign='middle' width='678' height='25' style='border-left:solid #000000 0.9pt;border-right:solid #000000 0.9pt;border-top:none;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='line-height:90%;'><SPAN STYLE='font-size:13.3pt;font-family:'굴림체';letter-spacing:-5%;line-height:90%'>&#10065; 장소</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD valign='middle' width='29' height='31' style='border-left:solid #000000 0.9pt;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0><SPAN STYLE='font-family:'굴림체';letter-spacing:-5%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='11' valign='middle' width='650' height='31' style='border-left:none;border-right:solid #000000 0.9pt;border-top:none;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='margin-left:24.1pt;text-indent:-24.1pt;line-height:130%;'><SPAN STYLE='font-size:11.4pt;font-family:'굴림체';letter-spacing:-5%;line-height:130%'>" + $("#text_place").val() + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='12' valign='middle' width='678' height='25' style='border-left:solid #000000 0.9pt;border-right:solid #000000 0.9pt;border-top:none;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='line-height:90%;'><SPAN STYLE='font-size:13.3pt;font-family:'굴림체';letter-spacing:-5%;line-height:90%'>&#10065; 주요일정</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD valign='middle' width='29' height='31' style='border-left:solid #000000 0.9pt;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='line-height:130%;'><SPAN STYLE='font-family:'굴림체';letter-spacing:-5%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='11' valign='middle' width='650' height='31' style='border-left:none;border-right:solid #000000 0.9pt;border-top:none;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='margin-left:24.1pt;text-indent:-24.1pt;line-height:130%;'><SPAN STYLE='font-size:11.4pt;font-family:'굴림체';letter-spacing:-5%;line-height:130%'>" + $("#text_plan").val() + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='12' valign='middle' width='678' height='25' style='border-left:solid #000000 0.9pt;border-right:solid #000000 0.9pt;border-top:none;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='line-height:90%;'><SPAN STYLE='font-size:13.3pt;font-family:'굴림체';letter-spacing:-5%;line-height:90%'>&#10065; 내용 및 시사점</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD valign='top' width='29' height='201' style='border-left:solid #000000 0.9pt;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='line-height:130%;'><SPAN STYLE='font-size:11.4pt;font-family:'굴림체';letter-spacing:-5%;line-height:130%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='11' valign='top' width='650' height='201' style='border-left:none;border-right:solid #000000 0.9pt;border-top:none;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='line-height:130%;'><SPAN STYLE='font-size:11.4pt;font-family:'굴림체';letter-spacing:-5%;line-height:130%'>" + $("#text_contents").val().replace(/ /g, '&nbsp;').replace(/(?:\r\n|\r|\n)/g, '<br/>') + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='12' valign='middle' width='678' height='25' style='border-left:solid #000000 0.9pt;border-right:solid #000000 0.9pt;border-top:none;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='line-height:90%;'><SPAN STYLE='font-size:13.3pt;font-family:'굴림체';letter-spacing:-5%;line-height:90%'>&#10065; 출장비 감액 사유</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD valign='middle' width='29' height='31' style='border-left:solid #000000 0.9pt;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='line-height:130%;'><SPAN STYLE='font-family:'굴림체';letter-spacing:-5%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='11' valign='middle' width='650' height='31' style='border-left:none;border-right:solid #000000 0.9pt;border-top:none;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='margin-left:24.1pt;text-indent:-24.1pt;line-height:130%;'><SPAN STYLE='font-size:11.4pt;font-family:'굴림체';letter-spacing:-5%;font-weight:bold;color:#ff9999;line-height:130%'>식비 제공 등 감액 요인 발생시 관련 사유를 구체적으로 기재(예:교육 참석 1식 감액)</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='12' valign='middle' width='678' height='21' style='border-left:solid #000000 0.9pt;border-right:solid #000000 0.9pt;border-top:none;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:130%;'><SPAN STYLE='font-family:'굴림체';letter-spacing:-5%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='7' valign='middle' width='339' height='25' style='border-left:solid #000000 0.9pt;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:right;line-height:130%;'><SPAN STYLE='font-size:13.3pt;font-family:'굴림체';letter-spacing:-5%;line-height:130%'>출 장 자 :</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='5' valign='middle' width='339' height='25' style='border-left:none;border-right:solid #000000 0.9pt;border-top:none;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:left;line-height:130%;'><SPAN STYLE='font-size:13.3pt;font-family:'굴림체';letter-spacing:-5%;line-height:130%'>" + result.ep_nm + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD colspan='7' valign='middle' width='339' height='21' style='border-left:solid #000000 0.9pt;border-right:none;border-top:none;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:right;line-height:130%;'><SPAN STYLE='font-family:'굴림체';letter-spacing:-5%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='5' valign='middle' width='339' height='21' style='border-left:none;border-right:solid #000000 0.9pt;border-top:none;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:left;line-height:130%;'><SPAN STYLE='font-family:'굴림체';letter-spacing:-5%'>&nbsp;</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD rowspan='2' colspan='3' valign='middle' width='113' height='99' style='border-left:solid #000000 0.9pt;border-right:solid #000000 0.9pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:130%;'><SPAN STYLE='font-family:'굴림체';letter-spacing:-5%'>" + result.pjt_nm + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD valign='middle' width='112' height='36' style='border-left:solid #000000 0.9pt;border-right:solid #000000 0.9pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:130%;'><SPAN STYLE='font-size:12.4pt;font-family:'굴림체';letter-spacing:-5%;font-weight:bold;line-height:130%'>운임요금</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='2' valign='middle' width='112' height='36' style='border-left:solid #000000 0.9pt;border-right:solid #000000 0.9pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:130%;'><SPAN STYLE='font-size:12.4pt;font-family:'굴림체';letter-spacing:-5%;font-weight:bold;line-height:130%'>일 비</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='3' valign='middle' width='112' height='36' style='border-left:solid #000000 0.9pt;border-right:solid #000000 0.9pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:130%;'><SPAN STYLE='font-size:12.4pt;font-family:'굴림체';letter-spacing:-5%;font-weight:bold;line-height:130%'>식 비</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='2' valign='middle' width='112' height='36' style='border-left:solid #000000 0.9pt;border-right:solid #000000 0.9pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:130%;'><SPAN STYLE='font-size:12.4pt;font-family:'굴림체';letter-spacing:-5%;font-weight:bold;line-height:130%'>숙박료</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD valign='middle' width='115' height='36' style='border-left:solid #000000 0.9pt;border-right:solid #000000 0.9pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:130%;'><SPAN STYLE='font-size:12.4pt;font-family:'굴림체';letter-spacing:-5%;font-weight:bold;line-height:130%'>합 계</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "<TR>";
	contentsStr += "	<TD valign='middle' width='112' height='63' style='border-left:solid #000000 0.9pt;border-right:solid #000000 0.9pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:130%;'><SPAN STYLE='font-size:11.4pt;font-family:'굴림체';letter-spacing:-5%;line-height:130%'>" + (parseInt(result.fare) + parseInt(result.toll)).toString().toMoney() + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='2' valign='middle' width='112' height='63' style='border-left:solid #000000 0.9pt;border-right:solid #000000 0.9pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:130%;'><SPAN STYLE='font-size:11.4pt;font-family:'굴림체';letter-spacing:-5%;line-height:130%'>" + result.daily.toMoney() + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='3' valign='middle' width='112' height='63' style='border-left:solid #000000 0.9pt;border-right:solid #000000 0.9pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:130%;'><SPAN STYLE='font-size:11.4pt;font-family:'굴림체';letter-spacing:-5%;line-height:130%'>" + result.food.toMoney() + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD colspan='2' valign='middle' width='112' height='63' style='border-left:solid #000000 0.9pt;border-right:solid #000000 0.9pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:130%;'><SPAN STYLE='font-size:11.4pt;font-family:'굴림체';letter-spacing:-5%;line-height:130%'>" + result.room.toMoney() + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "	<TD valign='middle' width='115' height='63' style='border-left:solid #000000 0.9pt;border-right:solid #000000 0.9pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>";
	contentsStr += "	<P CLASS=HStyle0 STYLE='text-align:center;line-height:130%;'><SPAN STYLE='font-size:11.4pt;font-family:'굴림체';letter-spacing:-5%;line-height:130%'>" + result.total.toMoney() + "</SPAN></P>";
	contentsStr += "	</TD>";
	contentsStr += "</TR>";
	contentsStr += "</TABLE>";
	return contentsStr;
}

</script>

</body>