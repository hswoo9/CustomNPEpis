<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>

<body>

<div class="iframe_wrap" style="min-width:1100px">
	<input type="hidden" id="comp_seq" value="${userInfo.compSeq }"/>
	<!-- 컨텐츠타이틀영역 -->
	<div class="sub_title_wrap">
		
		<div class="title_div">
			<h4>출장 여비 설정</h4>
		</div>
	</div>
	
	<div class="sub_contents_wrap">
	<p class="tit_p mt5 mt20">출장 여비 설정</p>

	<div class="com_ta">

				<div class="btn_div">	
					<div class="right_div">
						<div class="controll_btn p0">										
							<button type="button" onclick="gridSearch();">조회</button>
							<button type="button" onclick="newPopupBtn();">입력</button>
							<button type="button" onclick="delBtn();">삭제</button>
						</div>
					</div>
				</div>
				
				<div class="com_ta2 mt15">
				    <div id="gridList"></div>
				</div>
			</div>

	</div><!-- //sub_contents_wrap -->
	<div class="sub_contents_wrap">
	<p class="tit_p mt5 mt20"></p>

	<div class="com_ta">

				<div class="btn_div">	
					<div class="right_div">
						<div class="controll_btn p0">										
							<button type="button" onclick="gridSearch2();">조회</button>
							<button type="button" onclick="newPopupBtn2();">입력</button>
							<button type="button" onclick="delBtn2();">삭제</button>
						</div>
					</div>
				</div>
				
				<div class="com_ta2 mt15">
				    <div id="gridList2"></div>
				</div>
			</div>

	</div><!-- //sub_contents_wrap -->
</div><!-- iframe wrap -->


<div class="pop_wrap_dir" id="newPopUp" style="width: 1300px; display: none;">
	<div class="pop_con">
		<div class="com_ta2">
			<form id="popupform">
			<input type="hidden" name="oil_cost_master_seq" id="oil_cost_master_seq" class="dataInput" >
			<table id="topTable">
				<colgroup>
				<tr>
					<th>정렬순서</th>								
					<td>
						<input type="text" id="order_no" class="dataInput inputNumber" style="width: 30px;">
					</td>
					<th>유종</th>								
					<td>
						<input type="text" id="oil_type" class="dataInput" style="width: 100px;">
					</td>
					<th>연비</th>								
					<td>
						<input type="text" id="fuel_cost" class="dataInput" style="width: 80px;">
					</td>
					<th>적용기간 시작일</th>								
					<td>
						<input type="text" id="apply_sdate" class="dataInput" style="width: 100px;">
					</td>
					<th>적용기간 종료일</th>								
					<td>
						<input type="text" id="apply_edate" class="dataInput" style="width: 100px;">
					</td>
				</tr>
				
				<tr>
					<th>비고</th>
					<td colspan="9">
						<input type="text" name="remark" id="remark" class="dataInput" style="width: 97%;">
					</td>
				</tr>
			</table>
			</form>
		</div>
	</div>
	<!-- //pop_con -->

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" id="saveBtn" onclick="fn_saveBtn();" value="입력" />
			<input type="button" onclick="fn_closeBtn();" value="닫기" />
		</div>
	</div>
	<!-- //pop_foot -->
</div>
<div class="pop_wrap_dir" id="newPopUp2" style="width: 1300px; display: none;">
	<div class="pop_con">
		<div class="com_ta2">
			<form id="popupform">
			<input type="hidden" name="city_cost_master_seq" id="city_cost_master_seq" class="dataInput" >
			<table id="topTable">
				<colgroup>
				<tr>
					<th>정렬순서</th>								
					<td>
						<input type="text" id="order_no2" class="dataInput inputNumber" style="width: 30px;">
					</td>
					<th>교통수단</th>								
					<td>
						<input type="text" id="type" class="dataInput" style="width: 100px;">
					</td>
					<th>출장시간</th>								
					<td>
						<input type="text" id="biz_time" class="dataInput" style="width: 100px;">
					</td>
					<th>정산금액</th>								
					<td>
						<input type="text" id="accurate_amt" class="dataInputNumber dataInput" style="width: 100px;">
					</td>
					<th>적용기간 시작일</th>								
					<td>
						<input type="text" id="apply_sdate2" class="dataInput" style="width: 100px;">
					</td>
					<th>적용기간 종료일</th>								
					<td>
						<input type="text" id="apply_edate2" class="dataInput" style="width: 100px;">
					</td>
				</tr>
				
				<tr>
					<th>비고</th>
					<td colspan="11">
						<input type="text" name="remark2" id="remark2" class="dataInput" style="width: 97%;">
					</td>
				</tr>
			</table>
			</form>
		</div>
	</div>
	<!-- //pop_con -->

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" id="saveBtn2" onclick="fn_saveBtn2();" value="입력" />
			<input type="button" onclick="fn_closeBtn();" value="닫기" />
		</div>
	</div>
	<!-- //pop_foot -->
</div>



<script>

var oilDataSource = new kendo.data.DataSource({
	  transport: {
	    read: {
	      url: "<c:url value='/busTrip/getOilTypeList' />",
	      dataType: "json",
	      type : 'post'
	    },
	    parameterMap: function(data, operation){
			/* data.bt_sort = $('#bt_sort').val(); */
			return data;
		}
	  },
	  schema: {
			data: function(response){
				return response.list;
			}
		}
	});
var bizTimeDataSource = new kendo.data.DataSource({
	  transport: {
	    read: {
	      url: "<c:url value='/busTrip/getTimeTypeList' />",
	      dataType: "json",
	      type : 'post'
	    },
	    parameterMap: function(data, operation){
			/* data.bt_sort = $('#bt_sort').val(); */
			return data;
		}
	  },
	  schema: {
			data: function(response){
				return response.list;
			}
		}
	});
var carDataSource = new kendo.data.DataSource({
	  transport: {
	    read: {
	      url: "<c:url value='/busTrip/getCarTypeList' />",
	      dataType: "json",
	      type : 'post'
	    },
	    parameterMap: function(data, operation){
			/* data.bt_sort = $('#bt_sort').val(); */
			return data;
		}
	  },
	  schema: {
			data: function(response){
				return response.list;
			}
		}
	});

$('#oil_type').kendoComboBox({
    
    dataSource: oilDataSource,
    placeholder: "선택",
    	dataTextField: "code_kr",
		dataValueField: "code",
		index: 0,
		change:function(e){
			/* kf = $("#bt_sort").val();
			MS.dataSource.read();
			$("#duty_sort").data('kendoComboBox').dataSource.read(); */
		}
});
$('#biz_time').kendoComboBox({
    
    dataSource: bizTimeDataSource,
    placeholder: "선택",
    	dataTextField: "code_kr",
		dataValueField: "code",
		index: 0,
		change:function(e){
			/* kf = $("#bt_sort").val();
			MS.dataSource.read();
			$("#duty_sort").data('kendoComboBox').dataSource.read(); */
		}
});
$('#type').kendoComboBox({
    
    dataSource: carDataSource,
    placeholder: "선택",
    	dataTextField: "code_kr",
		dataValueField: "code",
		index: 0,
		change:function(e){
			/* kf = $("#bt_sort").val();
			MS.dataSource.read();
			$("#duty_sort").data('kendoComboBox').dataSource.read(); */
		}
});


var startDate = $('#apply_sdate').kendoDatePicker({
    culture : "ko-KR",
    format : "yyyy-MM-dd",
    value : moment().add('month').format('YYYY-MM-DD'),
   change: startChange 
    /* min : new Date() */
}).attr("readonly", true).data("kendoDatePicker");

var endDate = $('#apply_edate').kendoDatePicker({
    culture : "ko-KR",
    format : "yyyy-MM-dd",
    value : moment().add('month').format('YYYY-MM-DD'),
    change: endChange
}).attr("readonly", true).data("kendoDatePicker");
var startDate2 = $('#apply_sdate2').kendoDatePicker({
    culture : "ko-KR",
    format : "yyyy-MM-dd",
    value : moment().add('month').format('YYYY-MM-DD'),
   change: startChange 
    /* min : new Date() */
}).attr("readonly", true).data("kendoDatePicker");

var endDate2 = $('#apply_edate2').kendoDatePicker({
    culture : "ko-KR",
    format : "yyyy-MM-dd",
    value : moment().add('month').format('YYYY-MM-DD'),
    change: endChange
}).attr("readonly", true).data("kendoDatePicker");

function startChange(){
	if(startDate.value() > endDate.value()){
		endDate.value('');
	}
}
function endChange(){
	if(startDate.value() > endDate.value()){
		endDate.value('');
	}
}

var dataSource = new kendo.data.DataSource({
	serverPaging: true,
	pageSize: 10,
    transport: { 
        read:  {
            url:  "<c:url value='/busTrip/getOilCostList' />",
            dataType: "json",
            type: 'post'
        },
      	parameterMap: function(data, operation) {
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
var dataSource2 = new kendo.data.DataSource({
	serverPaging: true,
	pageSize: 10,
    transport: { 
        read:  {
            url:  "<c:url value='/busTrip/getCityCostList' />",
            dataType: "json",
            type: 'post'
        },
      	parameterMap: function(data, operation) {
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

var searchType = 'list';
var searchDpSeq;

$('.userSearchBtn').click(function(){
	
	$('#userPopUp').data("kendoWindow").open().center();
	$("#userList").data('kendoGrid').dataSource.read();
	
});

$('.projectSearchBtn').click(function(){
	
	$('#projectPopUp').data("kendoWindow").open().center();
	$("#projectList").data('kendoGrid').dataSource.read();
	
});

$(function(){
	
	$('#newPopUp').kendoWindow({
		width: "1300px",
	    title: '관내 출장 여비설정',
	    visible: false,
	    modal : true,
	    actions: [
	        "Close"
	    ],
	}).data("kendoWindow").center();
	$('#newPopUp2').kendoWindow({
		width: "1300px",
	    title: '관내 출장 여비설정',
	    visible: false,
	    modal : true,
	    actions: [
	        "Close"
	    ],
	}).data("kendoWindow").center();
	

      $("#gridList").kendoGrid({
        dataSource: dataSource,
        height: 320,
        sortable: false,
        pageable: false,
        persistSelection: true,
        selectable: "multiple",
        columns: [
       	{
   			headerTemplate: "<input type='checkbox' id='headerCheckbox' class='k-checkbox header-checkbox headerCheckbox'><label class='k-checkbox-label' for='headerCheckbox'></label>",
   			template: checkBoxTp,
   	    	width: "40px"
       	}, {
            field: "order_no",
            width: "80px",
            title: "정렬순서",
        }, {
            field: "code_kr",
            title: "유종",
            width:"200px",
        }, {
        	field: "fuel_cost",
            title: "연비",
            width:"200px",
        }, {
            template :applyDate,
            title: "적용기간",
            width:"300px",
        }, {
            field: "remark",
            width: "350px",
            title: "비고",
        }],
    }).data("kendoGrid");
      
      $("#gridList2").kendoGrid({
        dataSource: dataSource2,
        height: 320,
        sortable: false,
        pageable: false,
        persistSelection: true,
        selectable: "multiple",
        columns: [
       	{
   			headerTemplate: "<input type='checkbox' id='headerCheckbox2' class='k-checkbox header-checkbox headerCheckbox'><label class='k-checkbox-label' for='headerCheckbox2'></label>",
   			template: checkBoxTp2,
   	    	width: "40px"
       	}, {
            field: "order_no",
            width: "80px",
            title: "정렬순서",
        }, {
            field: "code_car",
            title: "교통수단",
            width:"200px",
        }, {
        	field: "code_time",
            title: "출장시간",
            width:"200px",
        }, {
        	field: "accurate_amt",
        	template:accTemp,
            title: "정산금액",
            width:"300px",
        }, {
        	template:applyDate2,
            title: "적용기간",
            width:"300px",
        },  {
            field: "remark",
            width: "350px",
            title: "비고",
        }],
    }).data("kendoGrid");
	
	
	$(document).on('dblclick', '#gridList .k-grid-content tr', function(){
		var gData = $("#gridList").data('kendoGrid').dataItem(this);
		console.log(gData);
		$('#oil_cost_master_seq').val(gData.oil_cost_master_seq);
		$('#order_no').val(gData.order_no);
		
		$('#oil_type').data('kendoComboBox').value(gData.common_code_id);
		$('#fuel_cost').val(gData.fuel_cost);
		SNum = gData.apply_sdate.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
	 	ENum = gData.apply_edate.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
		$('#apply_sdate').data('kendoDatePicker').value(SNum);
		$('#apply_edate').data('kendoDatePicker').value(ENum);
		$('#remark').val(gData.remark);
		
		searchType = 'mod';
		
		$('#saveBtn').val('수정');
		$('#newPopUp').data("kendoWindow").open().center();
		
	});
	$(document).on('dblclick', '#gridList2 .k-grid-content tr', function(){
		var gData = $("#gridList2").data('kendoGrid').dataItem(this);
		console.log(gData);
		$('#city_cost_master_seq').val(gData.city_cost_master_seq);
		$('#order_no2').val(gData.order_no);
		
		$('#type').data('kendoComboBox').value(gData.type_common_code_id);
		$('#biz_time').data('kendoComboBox').value(gData.time_common_code_id);
		
		$('#accurate_amt').val(numberWithCommas(gData.accurate_amt));
		$('#remark2').val(gData.remark);
		
		SNum = gData.sdate.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
	 	ENum = gData.edate.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
		$('#apply_sdate2').data('kendoDatePicker').value(SNum);
		$('#apply_edate2').data('kendoDatePicker').value(ENum);
		
		searchType = 'mod';
		
		$('#saveBtn2').val('수정');
		$('#newPopUp2').data("kendoWindow").open().center();
		
	});
	
	$(".headerCheckbox").change(function(){
		if($(this).is(":checked")){
			$(this).closest('table').parent().parent().parent().find('.checkbox').prop("checked", "checked");
        }else{
        	$(this).closest('table').parent().parent().parent().find('.checkbox').removeProp("checked");
        }
    
	});
	
	$(".dataInputNumber").bind({
		keyup : function(event){
			$(this).val( numberWithCommas( $(this).val().replace(/[^0-9]/g,"") ) );
		},
		change : function(event){ 
			$(this).val( numberWithCommas( $(this).val().replace(/[^0-9]/g,"") ) );
		}
	});	
	
	$(".inputNumber").bind({
		keyup : function(event){
			$(this).val( $(this).val().replace(/[^0-9]/g,"") );
		},
		change : function(event){ 
			$(this).val( $(this).val().replace(/[^0-9]/g,"") );
		}
	});	

	
});

var accTemp = function(row){
	return numberWithCommas(row.accurate_amt) + '원';
}


var checkBoxTp = function(row) {
	var key = row.oil_cost_master_seq;
	return '<input type="checkbox" id="sts'+key+'" class="k-checkbox checkbox"/><label for="sts'+key+'" class="k-checkbox-label"></label>';
}

var checkBoxTp2 = function(row) {
	var key = row.city_cost_master_seq;
	return '<input type="checkbox" id="sts'+key+'" class="k-checkbox checkbox"/><label for="sts'+key+'" class="k-checkbox-label"></label>';
}
var applyDate = function(row) {
	var Sdate = row.apply_sdate;
	var Edate = row.apply_edate;
	
 	SNum = Sdate.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
 	ENum = Edate.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
	
	
	return SNum+' ~ '+ENum;
}
var applyDate2 = function(row) {
	var Sdate = row.sdate;
	var Edate = row.edate;
	
 	SNum = Sdate.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
 	ENum = Edate.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
	
	
	return SNum+' ~ '+ENum;
}

function newPopupBtn(){
	$("#oil_type").data('kendoComboBox').value("");
	$('#saveBtn').val('입력');
	$('#newPopUp .dataInput').val('');
	/* searchType = 'list'; */
	$('#oil_type').data('kendoComboBox').dataSource.read();
	$('#newPopUp').data("kendoWindow").open().center();
	
}
function newPopupBtn2(){
	 $("#biz_time").data('kendoComboBox').value(""); 
	 $("#type").data('kendoComboBox').value(""); 
	$('#saveBtn2').val('입력');
	$('#newPopUp2 .dataInput').val('');
	/* searchType = 'list'; */
	$('#biz_time').data('kendoComboBox').dataSource.read();
	$('#type').data('kendoComboBox').dataSource.read();
	$('#newPopUp2').data("kendoWindow").open().center();
	
}

function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");

}
function fn_saveBtn(){
	
 if($('#order_no').val() == '' ){
		alert('정렬순서를 입력해 주세요.');
		return
	}

	if($('#oil_type').val() == '' ){
		alert('유종을 입력해 주세요.');
		return
	}
	if($('#fuel_cost').val() == '' ){
		alert('연비를 입력해 주세요.');
		return
	}
	if($('#apply_sdate').val() == '' ){
		alert('적용시작일을 입력해 주세요.');
		return
	}
	if($('#apply_edate').val() == '' ){
		alert('적용종료일을 입력해 주세요.');
		return
	}

	
	
	var data = {
		oil_cost_master_seq				: $('#oil_cost_master_seq').val(),
		order_no							: $('#order_no').val(),
		common_code_id						:  $('#oil_type').data('kendoComboBox').value(),
		oil_type							:  $('#oil_type').data('kendoComboBox').text(),
		fuel_cost							: $('#fuel_cost').val().replace(/,/g,""),
		apply_sdate							: $('#apply_sdate').val().replace(/-/gi,""),
		apply_edate							: $('#apply_edate').val().replace(/-/gi,""),
		remark									: $('#remark').val(),
	}	
	
	if($('#saveBtn').val() == '수정'){
 	 $.ajax({
		url : "<c:url value='/busTrip/modOilCost' />",
		data : 'json',
		type : 'POST',
		data : data,
		success : function(result) {
			
			$('#newPopUp').data("kendoWindow").close();
			gridSearch();
		}
	}); 
	} else {
 	 $.ajax({
		url : "<c:url value='/busTrip/saveOilCost' />",
		data : 'json',
		type : 'POST',
		data : data,
		success : function(result) {
			
			$('#newPopUp').data("kendoWindow").close();
			gridSearch();
		}
	});  
	}
	
	
	
}
function fn_saveBtn2(){
	
	/* if($('#order_no').val() == '' ){
		alert('정렬순서를 입력해 주세요.');
		return
	}

	if($('#title').val() == '' ){
		alert('명칭을 입력해 주세요.');
		return
	}

	if($('#day_cost').val() == '' ){
		alert('현지교통비를 입력해 주세요.');
		return
	}

	if($('#lodgment_cost').val() == '' ){
		alert('숙박비를 입력해 주세요.');
		return
	}
	
	if($('#food_cost').val() == '' ){
		alert('식비를 입력해 주세요.');
		return
	}
	
	if($('#city_cost').val() == '' ){
		alert('관내여비를 입력해 주세요.');
		return
	}

	if($("#positionList").data("kendoMultiSelect").value().length == 0){
		alert('해당직급을 1개 이상 선택해 주세요.');
		return
	} */
	
	
	var data = {
		city_cost_master_seq				: $('#city_cost_master_seq').val(),
		order_no								: $('#order_no2').val(),
		time_common_code_id				:  $('#biz_time').data('kendoComboBox').value(),
		biz_time									:  $('#biz_time').data('kendoComboBox').text(),
		type_common_code_id				:  $('#type').data('kendoComboBox').value(),
		type										:  $('#type').data('kendoComboBox').text(),
		accurate_amt							:$('#accurate_amt').val().replace(/,/g,""),
		remark									: $('#remark2').val(),
		sdate							: $('#apply_sdate2').val().replace(/-/gi,""),
		edate							: $('#apply_edate2').val().replace(/-/gi,"")
	}	
	
	if($('#saveBtn2').val() == '수정'){
 	 $.ajax({
		url : "<c:url value='/busTrip/modCityCost' />",
		data : 'json',
		type : 'POST',
		data : data,
		success : function(result) {
			
			$('#newPopUp2').data("kendoWindow").close();
			gridSearch2();
		}
	}); 
	} else {
 	 $.ajax({
		url : "<c:url value='/busTrip/saveCityCost' />",
		data : 'json',
		type : 'POST',
		data : data,
		success : function(result) {
			
			$('#newPopUp2').data("kendoWindow").close();
			gridSearch2();
		}
	});  
	}
	
	
	
}

function ttttt() {
	 $.ajax({
			url : "<c:url value='/busTrip/ttttt' />",
			data : 'json',
			type : 'POST',
			data : {},
			success : function(result) {
				
			}
		});  
}

function fn_closeBtn(){
	
	$('#newPopUp').data("kendoWindow").close();
	$('#newPopUp2').data("kendoWindow").close();
	
}

function gridSearch(){
	$("#gridList").data('kendoGrid').dataSource.read();
}

function gridSearch2(){
	$("#gridList2").data('kendoGrid').dataSource.read();
}

function delBtn(){
	
	var ch = $('#gridList tbody .checkbox:checked');
	var data = new Array();
	$.each(ch, function(i,v){
		data.push( $("#gridList").data("kendoGrid").dataItem($(v).closest("tr")).oil_cost_master_seq );
	});
	
	if(data.length == 0){
		alert('삭제 할 항목을 선택해 주세요.');
		return 
	}
	
	if(!confirm('삭제 하시겠습니까?')){
		return
	}
	var a = data.join();
	console.log("삭제데이터조인" +a);
	$.ajax({
		url: "<c:url value='/busTrip/delOilCost' />",
		data : {oil_cost_master_seq : data.join()},
		type : 'POST',
		success: function(result){
			gridSearch();
		}
	});  
	
}
function delBtn2(){
	
	var ch = $('#gridList2 tbody .checkbox:checked');
	var data = new Array();
	$.each(ch, function(i,v){
		data.push( $("#gridList2").data("kendoGrid").dataItem($(v).closest("tr")).city_cost_master_seq );
	});
	
	if(data.length == 0){
		alert('삭제 할 항목을 선택해 주세요.');
		return 
	}
	
	if(!confirm('삭제 하시겠습니까?')){
		return
	}
	var a = data.join();
	console.log("삭제데이터조인" +a);
	$.ajax({
		url: "<c:url value='/busTrip/delCityCost' />",
		data : {city_cost_master_seq : data.join()},
		type : 'POST',
		success: function(result){
			gridSearch2();
		}
	});  
	
}


</script>
</body>

