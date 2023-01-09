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
			<h4>출장관리 직급별 출장여비등록</h4>
		</div>
	</div>
	
	<div class="sub_contents_wrap">
	<p class="tit_p mt5 mt20">출장관리 직급별 출장여비등록</p>

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
</div><!-- iframe wrap -->


<div class="pop_wrap_dir" id="newPopUp" style="width: 1300px; display: none;">
	<div class="pop_con">
		<div class="com_ta2">
			<form id="popupform">
			<input type="hidden" name="bspd_seq" id="bspd_seq" class="dataInput" >
			<table id="topTable">
				<colgroup>
				<tr>
					<th>정렬순서</th>								
					<td>
						<input type="text" id="order_cnt" class="dataInput inputNumber" style="width: 50px;">
					</td>
					<th>명칭</th>								
					<td>
						<input type="text" id="bspd_name" class="dataInput" style="width: 100px;">
					</td>
					<th>현지교통비</th>								
					<td>
						<input type="text" id="traffic_pd" class="dataInput dataInputNumber" style="width: 80px;">원
					</td>
					<th>숙박비</th>								
					<td>
						<input type="text" id="room_pd" class="dataInput dataInputNumber" style="width: 80px;">원
					</td>
					<th>식비</th>								
					<td>
						<input type="text" id="food_pd" class="dataInput dataInputNumber" style="width: 80px;">원
					</td>
					<th>관내여비</th>								
					<td>
						<input type="text" id="travel_pd" class="dataInput dataInputNumber" style="width: 80px;" >원
					</td>
				</tr>
				
				<tr>
					<th>해당직급</th>
					<td colspan="11" style="padding-left: 15px;">
						<select id="positionList" multiple="multiple" data-placeholder="직급을 선택해 주세요." style="width: 98%;">
						
						</select>
					</td>
				</tr>
				
				<tr>
					<th>비고</th>
					<td colspan="11">
						<input type="text" name="rm" id="rm" class="dataInput" style="width: 97%;">
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
            url:  "<c:url value='/bsrp/bsrpAdminPositionListSerch' />",
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
            url:  "<c:url value='/common/getPosition' />",
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
            field: "order_cnt",
            width: "80px",
            title: "정렬순서",
        }, {
            field: "bspd_name",
            title: "명칭",
        }, {
        	field: "traffic_pd",
            template : trafficTemp,
            title: "현지교통비",
        }, {
        	field: "room_pd",
            template : roomTemp,
            title: "숙박비",
        }, {
        	field: "food_pd",
            template : foodTemp,
            title: "식비",
        }, {
        	field: "travel_pd",
            template : travelTemp,
            title: "관내여비",
        }, {
        	field: "dp_name",
        	width: "350px",
            title: "해당직급",
        }, {
            field: "rm",
            width: "350px",
            title: "비고",
        }],
    }).data("kendoGrid");
	
	
	$(document).on('dblclick', '#gridList .k-grid-content tr', function(){
		var gData = $("#gridList").data('kendoGrid').dataItem(this);
	
		$('#bspd_seq').val(gData.bspd_seq);
		$('#order_cnt').val(gData.order_cnt);
		$('#bspd_name').val(gData.bspd_name);
		$('#traffic_pd').val(numberWithCommas(gData.traffic_pd));
		$('#room_pd').val(numberWithCommas(gData.room_pd));
		$('#food_pd').val(numberWithCommas(gData.food_pd));
		$('#travel_pd').val(numberWithCommas(gData.travel_pd));
		$('#rm').val(gData.rm);
		
		searchType = 'mod';
		searchDpSeq = gData.dp_seq;
		
		$('#positionList').data('kendoMultiSelect').dataSource.read();
		$("#positionList").data("kendoMultiSelect").value(gData.dp_seq.split(','));
		
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

var trafficTemp = function(row){
	return numberWithCommas(row.traffic_pd) + '원';
}
var roomTemp = function(row){
	return numberWithCommas(row.room_pd) + '원';
}
var foodTemp = function(row){
	return numberWithCommas(row.food_pd) + '원';
}
var travelTemp = function(row){
	return numberWithCommas(row.travel_pd) + '원';
}

var checkBoxTp = function(row) {
	var key = row.bspd_seq;
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

function fn_saveBtn(){
	
	if($('#order_cnt').val() == '' ){
		alert('정렬순서를 입력해 주세요.');
		return
	}

	if($('#bspd_name').val() == '' ){
		alert('명칭을 입력해 주세요.');
		return
	}

	if($('#traffic_pd').val() == '' ){
		alert('현지교통비를 입력해 주세요.');
		return
	}

	if($('#room_pd').val() == '' ){
		alert('숙박비를 입력해 주세요.');
		return
	}
	
	if($('#food_pd').val() == '' ){
		alert('식비를 입력해 주세요.');
		return
	}
	
	if($('#travel_pd').val() == '' ){
		alert('관내여비를 입력해 주세요.');
		return
	}

	if($("#positionList").data("kendoMultiSelect").value().length == 0){
		alert('해당직급을 1개 이상 선택해 주세요.');
		return
	}
	
	var data = {
		bspd_seq		: $('#bspd_seq').val(),
		order_cnt		: $('#order_cnt').val(),
		bspd_name		: $('#bspd_name').val().replace(/,/g,""),
		traffic_pd		: $('#traffic_pd').val().replace(/,/g,""),
		room_pd			: $('#room_pd').val().replace(/,/g,""),
		food_pd			: $('#food_pd').val().replace(/,/g,""),
		travel_pd		: $('#travel_pd').val().replace(/,/g,""),
		position_seq	: $("#positionList").data("kendoMultiSelect").value().join(),
		rm				: $('#rm').val(),
	}	
	
	$.ajax({
		url : "<c:url value='/bsrp/bsrpAdminPositionSave' />",
		data : 'json',
		type : 'POST',
		data : data,
		success : function(result) {

			$('#newPopUp').data("kendoWindow").close();
			gridSearch();
		}
	});
	
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
		data.push( $("#gridList").data("kendoGrid").dataItem($(v).closest("tr")).bspd_seq );
	});
	
	if(data.length == 0){
		alert('삭제 할 항목을 선택해 주세요.');
		return 
	}
	
	if(!confirm('삭제 하시겠습니까?')){
		return
	}
	
	$.ajax({
		url: "<c:url value='/bsrp/bsrpAdminPositionDel' />",
		data : {bspd_seq : data.join()},
		type : 'POST',
		success: function(result){
			gridSearch();
		}
	});
	
}


</script>
</body>

