<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>

<body>

	<input type="hidden" id="comp_seq" value="${loginVo.compSeq }" />
	<input type="hidden" id="dept_seq" value="${dept_seq}" />
	<!-- 컨텐츠타이틀영역 -->

	<div class="pop_wrap_dir" style="width: 1050px;">
		<p class="tit_p mt5 mt20">출장 조회</p>

		<div class="com_ta">
			<div class="top_box gray_box">
				<dl>
					<dt style="width: 30px;">날짜</dt>
					<dd style="line-height: 25px">
						<input type="text" id="startDt"> ~ <input type="text"
							id="endDt">
					</dd>
					<dt style="width: 30px;">부서</dt>
					<dd style="line-height: 25px">
						<input type="text" id="dept_list">
					</dd>
					<dt style="width: 30px;">이름</dt>
					<dd style="line-height: 25px">
						<input type="text" id="topUserName">
					</dd>
					<dt style="width: 30px;">목적</dt>
					<dd style="line-height: 25px">
						<input type="text" id="topTitle" style="width: 180px;">
					</dd>
				</dl>
			</div>
			<div class="btn_div">
				<div class="right_div">
					<div class="controll_btn p0">

						<button type="button" onclick="gridSearch();">조회</button>
					</div>
				</div>
			</div>

			<div class="com_ta2 mt15">
				<div id="gridList"></div>
			</div>
		</div>


<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" class="gray_btn" id="addOnnaraBiz" value="추가" />
		</div>
	</div>

	<div class='com_ta mt15 tb_box'>
		<table id="finalTable" style="width: 100%">
			<colgroup>
				 <col width="85px;"/>
				 <col width="150px;"/>
				 <col width="200px;"/>
				 <col width="125px;"/>
				 <col width="80px;"/>
				 <col width="90px;"/>
				 <col width="50px;"/>
				 <col width="30px;"/>
			</colgroup>
			<thead>
				<tr>
					<th style="background-color: #f0f6fd; text-align: center; padding: .5em .6em .4em .6em;">출장번호</th>
					<th style="background-color: #f0f6fd;text-align: center; padding: .5em .6em .4em .6em;">장소</th>
					<th style="background-color: #f0f6fd; text-align: center; padding: .5em .6em .4em .6em;">목적</th>
					<th style="background-color: #f0f6fd;text-align: center; padding: .5em .6em .4em .6em;">출장일</th>
					<th style="background-color: #f0f6fd; text-align: center; padding: .5em .6em .4em .6em;">출장시간</th>
					<th style="background-color: #f0f6fd; text-align: center; padding: .5em .6em .4em .6em;">부서</th>
					<th style="background-color: #f0f6fd; text-align: center; padding: .5em .6em .4em .6em;">이름</th>
					<th style="background-color: #f0f6fd; text-align: center; padding: .5em .6em .4em .6em;">삭제</th>
				</tr>
			</thead>
			<tbody style="text-align: center;">
			</tbody>
			<tfoot>
				<tr>
					<td colspan="8" style="text-align: center;">문서를 추가해주세요.</td>
				</tr>
			</tfoot>
		</table> 
	</div>
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" class="gray_btn" id="pppp" value="선택" />
		</div>
	</div>


	</div>
	<!-- //sub_contents_wrap -->




	<script>
	var diffTimeH;
	var addRowData=[];
	
var deptDataSource = new kendo.data.DataSource({
	serverPaging: true,
	pageSize: 10,
    transport: { 
        read:  {
            url:  "<c:url value='/busTrip/getAlldeptList' />",
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
      }
    }
});
var dataSource = new kendo.data.DataSource({
	serverPaging: true,
	pageSize: 10,
    transport: { 
        read:  {
            url:  "<c:url value='/busTrip/getonNaraBTList' />",
            dataType: "json",
            type: 'post'
        },
      	parameterMap: function(data, operation) {
      		data.trip_code = 'A1704';
      		data.start_dt = $('#startDt').val();
      		data.end_dt = $('#endDt').val();
      		data.ep_name_kor = $('#topUserName').val();
      		data.title = $('#topTitle').val();
      		/* data.org_code = '${orgCode}';  */
      		var aq;
      		
      	  $.ajax({
      		url : "<c:url value='/busTrip/getErpEmpNumByDept' />",
      		data : { "dept_seq" :$('#dept_seq').val() },
      		type : 'POST',
      		async: false,
      		success : function(result) {
      			var arr = new Array();
      			$.each(result.result, function (i,v) {
					 arr.push(v.erp_emp_num);
      				
				});
      			var a = arr.join();
      			aq = a;
      		}	
      		
      		
      	}); 
      	  
      	  data.empArr = aq;
      		
      		
      		console.log(data);
      		return data;
     	}
    },
    schema: {
      data: function(response) {
        return response.list;
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
	$("#dept_list").kendoDropDownList({
		dataTextField : "dept_name",
		dataValueField : "dept_seq",
		dataSource : deptDataSource,
		change : function(e) {
			console.log(e.sender._old);
			$('#dept_seq').val(e.sender._old);
		} 	
	});
	
	$('#dept_list').data("kendoDropDownList").value('${dept_seq}');
	
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

      $("#gridList").kendoGrid({
        dataSource: dataSource,
        width: 900,
        height: 200,
        sortable: false,
        pageable: false,
        persistSelection: true,
        selectable: "multiple",
        columns: [
       	{
   			headerTemplate: "<input type='checkbox' id='headerCheckbox' class='k-checkbox header-checkbox headerCheckbox'><label class='k-checkbox-label' for='headerCheckbox'></label>",
   			template: checkBoxTp,
   	    	width: "30px"
       	}, {
            field: "TRIP_NO",
            width:"80px",
            title: "출장번호",
        }, {
            field: "TRIP_LOCAL",
            width:"150px",
            title: "장소",
        }, {
            field: "TITLE",
            width:"200px",
            title: "목적",
        }, {
        	template : tripDayTp,
        	width:"120px",
            title: "출장일",
        }, {
        	template : tripTimeTp,
        	width:"80px",
            title: "출장시간",
        },{
            field: "ORG_NAME",
            width:"80px",
            title: "부서",
        },{
            field: "EP_NAME_KOR",
            width:"60px",
            title: "이름",
        }],
    }).data("kendoGrid");
	
	
	$(document).on('dblclick', '#gridList .k-grid-content tr', function(){
		var gData = $("#gridList").data('kendoGrid').dataItem(this);
		console.log(gData);

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



$(document).ready(function() { 
	
	$('#pppp').bind('click', function() { 
	
		selectBtData();
	
	}); 
	
});



function selectBtData() {
	
	if(addRowData.length == 0 ){
		alert('출장 정보를 선택해주세요');
		return;
	}
	
	$('#pppp').unbind('click');
	
	
	var data = new Array();
	$.each(addRowData, function(i,v){
		
        var totalData = v;
        
        
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
        
        
		// 차량 종류 : 자가용, 대중교통, 공용차량 기준으로 값을가져와서 시간값 비교
        $.ajax({
		url : "<c:url value='/busTrip/getCityCostList' />",
		data : { 
				"code_car" : totalData.USE_CAR,
				"day"	:	totalData.TRIP_DAY_FR		
		},
		type : 'POST',
		async: false,
		success : function(result) {
			
			
			$.each(result.list , function (i,v) {
				var a =eval(result.list[i].code_time_val+result.list[i].code_time_math+totalData.TRIP_TIME);
				if(a){
					
				 totalData.accurate_amt=result.list[i].accurate_amt; 
				
				}	
			
			
			})
	       
		}	
	});
	
	
        
       
        data.push(totalData);
		
	});
	
       
	self.close(); 
	window.opener.testvalue(JSON.stringify(data));
	
	
	
	
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

$('#addOnnaraBiz').on("click",function(){

	var ch = $('#gridList tbody .checkbox:checked');
	
	if(ch.length == 0 ){
		alert('출장 정보를 선택해주세요');
		return;
	}
	
	$.each(ch, function(i,v){
        var totalData =$("#gridList").data("kendoGrid").dataItem($(v).closest("tr"))
       
        // 기존 온나라 정보에서 TRIP_TIME 컬럼을 조회해서 값을 계산했는데 자꾸 3시간짜리인데 컬럼에는 4시간으로 표기되어있음
        // 컬럼이 잘못된컬럼인지 온나라 오류인지 몰라서 시간값을 가지고 계산해서 TRIP_TIME 값에 덮어씌운후 값을 보내려고함
        
    	 //TRIP_TIME 구하기 
        var a = totalData.TRIP_TIME_FR; 
        
        var b =totalData.TRIP_TIME_TO;
        
    	var t1 = moment(a, 'HH:mm');
    	var t2 = moment(b, 'HH:mm');
        
    	 diffTimeH = {
    				day : moment.duration(t2.diff(t1)).days(),
    				hour : moment.duration(t2.diff(t1)).hours(),
    				minute : moment.duration(t2.diff(t1)).minutes(),
    				second : moment.duration(t2.diff(t1)).seconds()
    		}
    	
    	 totalData.TRIP_TIME = diffTimeH.hour;
    	 //TRIP_TIME 구하기 끝
    	 
        addRowData.push(totalData);
        
	var html= '';
		
		html += '<tr id="' + totalData.EP_NO+totalData.TRIP_NO+ '">';
		html += '<td name="TRIP_NO">'+totalData.TRIP_NO +'</td>';
		html += '<td name="TRIP_LOCAL">'+totalData.TRIP_LOCAL+'</td>';
		html += '<td name="TITLE">'+totalData.TITLE+'</td>';
		html += '<td name="TRIP_DAY_ALL">'+totalData.TRIP_DAY_FR +"~"+totalData.TRIP_DAY_TO+'</td>';
		html += '<td name="TRIP_TIME_ALL">'+totalData.TRIP_TIME_FR +"~"+totalData.TRIP_TIME_TO+'</td>';
		html += '<td name="ORG_NAME">'+totalData.ORG_NAME+'</td>';
		html += '<td name="EP_NAME_KOR">'+totalData.EP_NAME_KOR+'</td>';
		html += '<td name="cancelbtn">';
		html += '<span onclick="deleteAddOnnaraBtRow(\''+ totalData.EP_NO+totalData.TRIP_NO + '\')">';
		html += '<img class="closeIco" style="width:15px; height:15px;" src="<c:url value='/Images/ico/close.png'/>" alt="" />';
		html += '<span></td>';
		html += '</tr>';
		
		$("#finalTable tbody").append(html);
	})
	checkTfoot();
	
	$('input[type=checkbox]').prop('checked', false);
})

function deleteAddOnnaraBtRow(rownum) {
		
	var idx = addRowData.findIndex(function(item) {
			
			return item.EP_NO+item.TRIP_NO == rownum
			
		})
		
		
		if(idx > -1 ) {
			addRowData.splice(idx,1);
			
		}	
	
			$("#" + rownum).remove();
			checkTfoot();
			
}

function checkTfoot() {
	var length=	$("#finalTable tbody tr").length;
	
	if(length >0){
		$("#finalTable tfoot").hide();
	} else{
		$("#finalTable tfoot").show();
	}
}
</script>
</body>

