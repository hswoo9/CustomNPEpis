<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>

<body>

	<div class="iframe_wrap" style="min-width: 1100px">
		<input type="hidden" id="comp_seq" value="${userInfo.compSeq }" />
		<!-- 컨텐츠타이틀영역 -->
		<div class="sub_title_wrap">

			<div class="title_div">
				<h4>직급별 출장여비관리</h4>
			</div>
		</div>

		<div class="sub_contents_wrap">
			<p class="tit_p mt5 mt20">직급별 출장여비관리</p>

			<div class="com_ta">

				<div class="btn_div">
					<div class="right_div">
						<div class="controll_btn p0">
							<!-- <button type="button" onclick="testSMS();">문자테스트</button> -->
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

		</div>
		<!-- //sub_contents_wrap -->
	</div>
	<!-- iframe wrap -->


	<div class="pop_wrap_dir" id="newPopUp" style="width: 1300px; display: none;">
		<div class="pop_con">
			<div class="com_ta2">
				<form id="popupform">
					<input type="hidden" name="grade_cost_master_seq" id="grade_cost_master_seq" class="dataInput">
					<table id="topTable">
						<colgroup>
						<tr>
							<th>정렬순서</th>
							<td>
								<input type="text" id="order_no" class="dataInput inputNumber" style="width: 50px;">
							</td>
							<th>명칭</th>
							<td colspan="2">
								<input type="text" id="title" class="dataInput" style="width: 185px;">
							</td>
							<th>일비</th>
							<td style="width: 100px;" >
								<input type="text" id="day_cost" class="dataInput dataInputNumber" style="width: 80px;">
								원
							</td>
							<th>숙박비</th>
							<td style="width: 100px;">
								<input type="text" id="lodgment_cost" class="dataInput dataInputNumber" style="width: 80px;">
								원
							</td>
							<th>식비</th>
							<td style="width: 100px;">
								<input type="text" id="food_cost" class="dataInput dataInputNumber" style="width: 80px;">
								원
							</td>
							<th>친지숙박</th>								
							<td style="width: 100px;">
								<input type="text" id="city_cost" class="dataInput dataInputNumber" style="width: 80px;" >원
							</td> 
						</tr>

						<tr>
							<th>해당직급</th>
							<td colspan="12" style="padding-left: 15px;">
								<select id="positionList" multiple="multiple" data-placeholder="직급을 선택해 주세요." style="width: 98%;">

								</select>
							</td>
						</tr>
						<tr>
						<th>적용기간 시작일</th>
							<td colspan="2" style="padding-left: 15px;">
								<input id="apply_sdate" style="width: 98%;">
							</td>
							<th>적용기간 종료일</th>
							<td colspan="2" style="padding-left: 15px;">
								<input id="apply_edate"  style="width: 98%;">
							</td>
							<th>비고</th>
							<td colspan="6">
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



	<script>

var dataSource = new kendo.data.DataSource({
	serverPaging: true,
	pageSize: 10,
    transport: { 
        read:  {
            url:  "<c:url value='/busTrip/getGradeCostList' />",
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
var positionDataSource = new kendo.data.DataSource({
	serverPaging: true,
	pageSize: 10,
    transport: { 
        read:  {
        	async: false,
            url:  "<c:url value='/busTrip/getPositionList' />",
            dataType: "json",
            type: 'post'
        },
      	parameterMap: function(data, operation) {
      		data.searchType = searchType;
      		if(searchDpSeq){
	      		data.dp_seq = "'" + searchDpSeq.replace(/,/gi,"','") + "'";
      		}
      		data.comp_seq = $("#comp_seq").val();
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

$('.userSearchBtn').click(function(){
	
	$('#userPopUp').data("kendoWindow").open().center();
	$("#userList").data('kendoGrid').dataSource.read();
	
});

$('.projectSearchBtn').click(function(){
	
	$('#projectPopUp').data("kendoWindow").open().center();
	$("#projectList").data('kendoGrid').dataSource.read();
	
});

$(function(){
	
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
	
	$('#newPopUp').kendoWindow({
		width: "1300px",
	    title: '직급별 출장 여비 등록',
	    visible: false,
	    modal : true,
	    actions: [
	        "Close"
	    ],
	}).data("kendoWindow").center();
	
    $("#positionList").kendoMultiSelect({
    	dataSource: positionDataSource,
   	    dataTextField: "dp_name",
   	    dataValueField: "dp_seq",
    	autoClose: false
    }).data("kendoMultiSelect");
      

      $("#gridList").kendoGrid({
        dataSource: dataSource,
        height: 460,
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
            field: "title",
            title: "명칭",
        }, {
        	field: "day_cost",
            template : trafficTemp,
            title: "일비",
        }, {
        	field: "loadgment_cost",
            template : roomTemp,
            title: "숙박비",
        }, {
        	field: "food_cost",
            template : foodTemp,
            title: "식비",
        },  {
        	field: "city_cost",
            template : travelTemp,
            title: "친지숙박",
        },  {
        	field: "apply_grade_array",
        	width: "350px",
            title: "해당직급",
        },  {
        	width: "200px",
            title: "적용기간",
            template :applyDate,
        }, {
            field: "remark",
            width: "350px",
            title: "비고",
        }],
    }).data("kendoGrid");
	
	
	$(document).on('dblclick', '#gridList .k-grid-content tr', function(){
		var gData = $("#gridList").data('kendoGrid').dataItem(this);
		console.log(gData);
		$('#grade_cost_master_seq').val(gData.grade_cost_master_seq);
		$('#order_no').val(gData.order_no);
		$('#title').val(gData.title);
		$('#day_cost').val(numberWithCommas(gData.day_cost));
		$('#lodgment_cost').val(numberWithCommas(gData.lodgment_cost));
		$('#food_cost').val(numberWithCommas(gData.food_cost));
		$('#city_cost').val(numberWithCommas(gData.city_cost));
	 	var SNum = gData.sdate.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
	 	var ENum = gData.edate.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
			$('#apply_sdate').data('kendoDatePicker').value(SNum);
			$('#apply_edate').data('kendoDatePicker').value(ENum);
		$('#remark').val(gData.remark);
		
		searchType = 'mod';
		searchDpSeq = gData.dp_seq;
		
		$('#positionList').data('kendoMultiSelect').dataSource.read();
		$("#positionList").data("kendoMultiSelect").value(gData.apply_grade_array_seqs.split(','));
		
		$('#saveBtn').val('수정');
		$('#newPopUp').data("kendoWindow").open().center();
		
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

var applyDate = function(row) {
	var Sdate = row.sdate;
	var Edate = row.edate;
	
 	SNum = Sdate.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
 	ENum = Edate.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
	
	
	return SNum+' ~ '+ENum;
}

var trafficTemp = function(row){
	return numberWithCommas(row.day_cost) + '원';
}
var roomTemp = function(row){
	return numberWithCommas(row.lodgment_cost) + '원';
}
var foodTemp = function(row){
	return numberWithCommas(row.food_cost) + '원';
}
var travelTemp = function(row){
	return numberWithCommas(row.city_cost) + '원';
}

var checkBoxTp = function(row) {
	var key = row.grade_cost_master_seq;
	return '<input type="checkbox" id="sts'+key+'" class="k-checkbox checkbox"/><label for="sts'+key+'" class="k-checkbox-label"></label>';
}

function newPopupBtn(){
	$('#saveBtn').val('입력');
	$('#newPopUp .dataInput').val('');
	searchType = 'list';
	$("#positionList").data("kendoMultiSelect").value('');
	$('#positionList').data('kendoMultiSelect').dataSource.read();
	$('#newPopUp').data("kendoWindow").open().center();
	
}

function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");

}
function fn_saveBtn(){
	
	 if($('#order_no').val() == '' ){
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
		alert('친지숙박비를 입력해 주세요.');
		return
	}

	if($("#positionList").data("kendoMultiSelect").value().length == 0){
		alert('해당직급을 1개 이상 선택해 주세요.');
		return
	} 
	
	
	
// kendo textFiled 값은 어떻게 가져오는지 몰라서 dataItems() 로 객체가져와서 for문 작업으로 join()을 대체함	
var asd =  $("#positionList").data("kendoMultiSelect").dataItems();
	
	var lastIndex = asd.length-1; // 마지막 index 값
	
	var p_name=""; // position(직급) 이름을 join 할 변수선언
	

	asd.forEach(function(e,i){ // for문으로 구분자 "," 기준으로 join 시켜주기
		if(lastIndex == i){
			 p_name += e.dp_name
			
		}else{
            p_name += e.dp_name+",";
			
		}
		
	});
// text filed 값 join 끝
	
	var data = {
		grade_cost_master_seq		: $('#grade_cost_master_seq').val(),
		order_no							: $('#order_no').val(),
		title									: $('#title').val().replace(/,/g,""),
		day_cost							: $('#day_cost').val().replace(/,/g,""),
		lodgment_cost					: $('#lodgment_cost').val().replace(/,/g,""),
		food_cost							: $('#food_cost').val().replace(/,/g,""),
		city_cost							: $('#city_cost').val().replace(/,/g,""),
		position_name					: p_name,
		position_seq						: $("#positionList").data("kendoMultiSelect").value().join(),
		remark								: $('#remark').val(),
		sdate								: $('#apply_sdate').val().replace(/-/gi,""),
		edate								: $('#apply_edate').val().replace(/-/gi,""),
	}	
	
	if($('#saveBtn').val() == '수정'){
		console.log("수우정~"+data.position_name);
 	 $.ajax({
		url : "<c:url value='/busTrip/modGradeCost' />",
		data : 'json',
		type : 'POST',
		data : data,
		success : function(result) {
			
			$('#newPopUp').data("kendoWindow").close();
			gridSearch();
		}
	}); 
	} else {
	console.log("인설트"+data.position_name)
 	 $.ajax({
		url : "<c:url value='/busTrip/saveGradeCost' />",
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

function fn_closeBtn(){
	
	$('#newPopUp').data("kendoWindow").close();
	
}

function gridSearch(){
	$("#gridList").data('kendoGrid').dataSource.read();
}

function delBtn(){
	
	var ch = $('#gridList tbody .checkbox:checked');
	var data = new Array();
	$.each(ch, function(i,v){
		data.push( $("#gridList").data("kendoGrid").dataItem($(v).closest("tr")).grade_cost_master_seq );
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
		url: "<c:url value='/busTrip/delGradeCost' />",
		data : {grade_cost_master_seq : data.join()},
		type : 'POST',
		success: function(result){
			gridSearch();
		}
	}); 
	
}

/* function testSMS() {
	
	data = {
			title : "api web test",
			content : "TEst 글자수 + 특문 + 12345 ",
			numArr : JSON.stringify(['01024724495','01085521725'])
			
	}
	
	$.ajax({
		url: "<c:url value='/busTrip/sendSmsByBizTongAgent' />",
		data : data,
		type : 'POST',
		success: function(result){
			alert(result.massage);
		}
	}); 
	
} */
</script>
</body>

