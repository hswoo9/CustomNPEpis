<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>

<body>

	<input type="hidden" id="comp_seq" value="${userInfo.compSeq }"/>
	<!-- 컨텐츠타이틀영역 -->
	
	<div class="pop_wrap_dir" style="width:1050px;">
	<p class="tit_p mt5 mt20">출장 조회</p>

	<div class="com_ta">
				<div class="top_box gray_box">
					<dl>
						<dt style="width: 55px;">
							날짜
						</dt>
						<dd style="line-height: 25px">
							<input type="text" id="startDt" > ~ <input type="text" id="endDt">
						</dd>
						<dt  style="width: 55px; padding-left:20px; " >
							이름
						</dt>
						<dd style="line-height: 25px">
							<input type="text" id="topUserName">
						</dd>
						<dt  style="width: 55px; padding-left:20px; " >
							부서
						</dt>
						<dd style="line-height: 25px">
							<input type="text" id="topTitle" style="width: 250px">
						</dd>
					</dl>
				</div>
				<div class="btn_div">	
					<div class="right_div">
						<div class="controll_btn p0">		
															
							<button type="button" onclick="gridSearch();">조회</button>
							<button type="button" onclick="selectBtData();">선택</button>
						</div>
					</div>
				</div>
				
				<div class="com_ta2 mt15">
				    <div id="gridList"></div>
				</div>
			</div>

	</div><!-- //sub_contents_wrap -->




<script>

$(function(){
	
	
	var startDate = $('#startDt').kendoDatePicker({
	    culture : "ko-KR",
	    format : "yyyy-MM-dd",
	    value : moment().add('month', -1).format('YYYY-MM-DD'),
	    change: startChange
	    /* min : new Date() */
	}).attr("readonly", true).data("kendoDatePicker");

	var endDate = $('#endDt').kendoDatePicker({
	    culture : "ko-KR",
	    format : "yyyy-MM-dd",
	    value : moment().add('month').format('YYYY-MM-DD'),
	}).attr("readonly", true).data("kendoDatePicker");

	function startChange(){
		if(startDate.value() > endDate.value()){
			endDate.value('');
		}
		endDate.min(startDate.value());
	}

     
	
	
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

var checkBoxTp = function(row) {
	var key = row.EP_NO+row.TRIP_NO;
	return '<input type="checkbox" id="sts'+key+'" class="k-checkbox checkbox"/><label for="sts'+key+'" class="k-checkbox-label"></label>';
}
var tripTimeTp = function(row) {
	var key = row.TRIP_TIME_FR+'~'+row.TRIP_TIME_TO;
	return key;
}
var tripDayTp = function(row) {
	var key = row.TRIP_DAY_FR+'~'+row.TRIP_DAY_TO;
	return key;
}


function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");

}

function selectBtData() {
	
	var ch = $('#gridList tbody .checkbox:checked');
	
	 if(ch.length >1 ){
		alert('하나의 출장 정보를 선택해주세요');
		return;
	} 
	if(ch.length == 0 ){
		alert('출장 정보를 선택해주세요');
		return;
	}
	
	
	var data = new Array();
	$.each(ch, function(i,v){
        var totalData =$("#gridList").data("kendoGrid").dataItem($(v).closest("tr"))
        
        
        // 1.  ep_no로  v_user_info 검색후 totalData에 추가
       $.ajax({
		url : "<c:url value='/busTrip/addUserInfo' />",
		data : { "erp_emp_num" : totalData.EP_NO },
		type : 'POST',
		async: false,
		success : function(result) {
			
			totalData.dept_name=result.result.dept_name;
			totalData.dept_seq=result.result.dept_seq;
	        
	        totalData.dept_position_code=result.result.dept_position_code;
	        totalData.dept_duty_code=result.result.dept_duty_code;
	        
		}	
	}); 
        
      //---------------관내출장에서는 직급별 여비에서 제공해주는 값이 없어 나중에 관외할때쓰자-----------------------  
        //2. dept_position_code 로 dj_hr_biz_grade_cost_master 에서 값 가져오기
      /*  $.ajax({
		url : "<c:url value='/busTrip/getGradeCost' />",
		data : { "apply_grade_array_seqs" : totalData.dept_position_code },
		type : 'POST',
		success : function(result) {
			
	        totalData.city_cost=result.city_cost;
	        totalData.day_cost=result.day_cost;
	        totalData.lodgment_cost=result.lodgment_cost;
	        totalData.food_cost=result.food_cost;
	        
		}	
	}); */
		//---------------------------------------------------------------------------------------

        
       
        data.push(totalData);
		
	});
	
       
window.opener.testvalue(JSON.stringify(data));
self.close(); 
	
	
}


function fn_saveBtn(){
	
	
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


$('#topUserName').on('keydown', function(key){
	 if (key.keyCode == 13) {
		 gridSearch();
 }
});
$('#topTitle').on('keydown', function(key){
	 if (key.keyCode == 13) {
		 gridSearch();
 }
});

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


</script>
</body>

