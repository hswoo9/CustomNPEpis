<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>

<body>

	<input type="hidden" id="comp_seq" value="${loginVo.compSeq }"/>
	<input type="hidden" id="dept_seq" value="${dept_seq}" />
	<!-- 컨텐츠타이틀영역 -->
	
	<div class="pop_wrap_dir" style="width:1050px;">
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
						<!-- 	<button type="button" onclick="selectBtData();">선택</button> -->
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
				 <col width="90px;"/>
				 <col width="150px;"/>
				 <col width="200px;"/>
				 <col width="125px;"/>
				 <col width="75px;"/>
				 <col width="80px;"/>
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

	</div><!-- //sub_contents_wrap -->




<script>

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
      		data.trip_code = 'A1702';
      		data.start_dt = $('#startDt').val();
      		data.end_dt = $('#endDt').val();
      		data.ep_name_kor = $('#topUserName').val();
      		data.title = $('#topTitle').val();
      		/* data.org_code = '${orgCode}'; */
      		var aq;
      		
      	  $.ajax({
      		url : "<c:url value='/busTrip/getErpEmpNumByDept' />",
      		data : { "dept_seq" :$('#dept_seq').val() },
      		type : 'POST',
      		async: false,
      		success : function(result) {
      			var arr = new Array();
      			$.each(result.result, function (i,v) {
					if(v.erp_emp_num != "" && v.erp_emp_num != null){
						arr.push(v.erp_emp_num);
					}
				});
      			var a = arr.join();
      			aq = a;
      		}	
      		
      		
      	}); 
      	  if(aq ==''){
      		  
      	  }
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
	    value : moment().add('month', -4).format('YYYY-MM-DD'),
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

/* 중복실행방지 */
var click = true;

function selectBtData() {
	
	
	if(addRowData.length == 0 ){
		alert('출장 정보를 선택해주세요');
		return;
	}
	/* 한번 클릭후에는 false로 변경 */
 	if(click){
		  click = !click;
	
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
			if(result.result == null){
					console.log('정보없음');
					click = true;
				
			totalData.dept_name=result.result.dept_name;
			totalData.dept_seq=result.result.dept_seq;
	        
	        totalData.dept_position_code=result.result.dept_position_code;
	        totalData.dept_duty_code=result.result.dept_duty_code;
			}
			totalData.dept_name=result.result.dept_name;
			totalData.dept_seq=result.result.dept_seq;
	        
	        totalData.dept_position_code=result.result.dept_position_code;
	        totalData.dept_duty_code=result.result.dept_duty_code;
	        
		}
	}); 
        
        $.ajax({
        	
			url: "<c:url value='/busTrip/getClientInfo' />",
			data : {EMP_NO_JOIN : totalData.EP_NO},
			type : 'POST',
			async :false,
			success: function(result){
				//배열로 넘어온 정보 저장
				clientInfo = result.result;
				
				totalData.trSeq			= clientInfo[0].TR_CD;
				totalData.trName		= clientInfo[0].TR_NM;
				totalData.trAddr		= clientInfo[0].ADDR;
				totalData.ceoName		= clientInfo[0].CEO_NM;
				totalData.businessNb	= clientInfo[0].REG_NB;
				totalData.baNb			= clientInfo[0].BA_NB;
				totalData.btrSeq		= clientInfo[0].JIRO_CD;
				totalData.btrName		= clientInfo[0].BANK_NM;
				totalData.depositor		= clientInfo[0].DEPOSITOR;
				
				
			}
			
		}); 
        
        data.push(totalData);
		
	});
	
       
 window.opener.testvalue(JSON.stringify(data));
 
 	 } else {
		 return;
	 }
 
self.close();  
	
	
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


function gridSearch(){
	$("#gridList").data('kendoGrid').dataSource.read();
}

$('#addOnnaraBiz').on("click",function(){

	var ch = $('#gridList tbody .checkbox:checked');
	
	if(ch.length == 0 ){
		alert('출장 정보를 선택해주세요');
		return;
	}
	
	$.each(ch, function(i,v){
        var totalData =$("#gridList").data("kendoGrid").dataItem($(v).closest("tr"))
       
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

