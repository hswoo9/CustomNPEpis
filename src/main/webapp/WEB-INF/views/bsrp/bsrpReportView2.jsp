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
						<input type="text" id="bs_des_txt" style="width: 100px; display: none;" readonly="readonly"/>
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
						<input type="text" id="fare" style="width: 200px;" class="requirement sumData userInput" readonly="readonly">원
					</dd>
					<dt style="width: 8%;">
						일비
					</dt>
					<dd style="line-height: 25px; width:25%;"">
						<input type="text" id="daily" style="width: 200px;" class="requirement sumData userInput" readonly="readonly">원
					</dd>
					<dt style="width: 8%;">
						통행료
					</dt>
					<dd style="line-height: 25px; width:10%;"">
						<input type="text" id="toll" style="width: 80px;" class="requirement sumData" readonly="readonly">원
					</dd>
				</dl>
				<dl>
					<dt style="width: 8%;">
						숙박비
					</dt>
					<dd style="line-height: 25px; width:30%;">
						<input type="text" id="room" style="width: 200px;" class="requirement sumData userInput" readonly="readonly">원
					</dd>
					<dt style="width: 8%;">
						식비
					</dt>
					<dd style="line-height: 25px; width:25%;">
						<input type="text" id="food" style="width: 200px;" class="requirement sumData userInput" readonly="readonly">원
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
		<div class="com_ta" id="report_area" style="display: none;">
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
	
	<div class="pop_foot" style="display: none;">
		<div class="btn_cen pt12">
			<input type="button" onclick="bsrpSave();" value="마일리지 수정" />
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
				$("#car2").prop("disabled", true);
			}else{
				$("#car2").prop("selected", true);
				$("#car1").prop("disabled", true);
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
// 			$("#bs_des").attr("disabled", false);
// 			$("#topSearchTfcmn").attr("disabled", false);
// 			$("#topSearchRoom").attr("disabled", false);
// 			$("#topSearchFood").attr("disabled", false);
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
			
			if($("#topSearchTfcmn").val() == "006"){
				$(".pop_foot").show();
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
	
// 	if(!bsrpSaveVal()){
// 		return;
// 	}

	if(!confirm("마일리지를 수정합니다.")){
		return;
	}
	
	var saveObj = {};
    
    /*마일리지*/
    saveObj.bs_seq = bs_seq;
    saveObj.airline = $("#topSearchAirline").val();
    saveObj.saved_mileage = $("#savedMileage").val().toMoney2();
    saveObj.new_mileage = $("#newMileage").val().toMoney2();
    saveObj.use_mileage = $("#useMileage").val().toMoney2();
    saveObj.applcnt_seq = $('#txtKOR_NM').val();
    saveObj.active = "Y";
    /*마일리지*/
    
	$.ajax({
		url : "<c:url value='/bsrp/bsrpMileageUpdate' />",
		dataType : 'json',
		type : 'POST',
		data : saveObj,
		success : function(result) {
			alert("마일리지가 수정되었습니다.");
		}
	});
	
}

</script>

</body>