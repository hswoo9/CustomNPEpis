<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>

<body>

<div class="iframe_wrap" style="min-width:1100px">

	<!-- 컨텐츠타이틀영역 -->
	<div class="sub_title_wrap">
		
		<div class="title_div">
			<h4>출장관리</h4>
		</div>
	</div>
	
	<div class="sub_contents_wrap">
	<p class="tit_p mt5 mt20">출장관리</p>

	<div class="com_ta">
				<div class="top_box gray_box">
					<dl>
						<dt style="width: 60px;">
							교통수단
						</dt>
						<dd style="line-height: 25px">
							<select class="selectMenu" id="topSearchTfcmn" style="min-width: 150px;">
								<option value="all">전체</option>
								<c:forEach var="list" items="${bsrp_tfcmn }">
									<option value="${list.code }">${list.code_desc }</option>
								</c:forEach>
							</select>
						</dd>

						<dt style="width: 50px;">
							출발지
						</dt>
						<dd style="line-height: 25px">
							<select class="selectMenu" id="topSearchStrtpnt" style="min-width: 150px;">
								<option value="all">전체</option>
								<c:forEach var="list" items="${bsrp_area }">
									<option value="${list.code }">${list.code_desc }</option>
								</c:forEach>
							</select>
						</dd>

						<dt style="width: 50px;">
							도착지
						</dt>
						<dd style="line-height: 25px">
							<select class="selectMenu" id="topSearchAloc" style="min-width: 150px;">
								<option value="all">전체</option>
								<c:forEach var="list" items="${bsrp_area }">
									<option value="${list.code }">${list.code_desc }</option>
								</c:forEach>
							</select>
						</dd>

						<dt style="width: 60px;">
							요금종류
						</dt>
						<dd style="line-height: 25px">
							<select class="selectMenu" id="topSearchTrff" style="min-width: 150px;">
								<option value="all">전체</option>
								<c:forEach var="list" items="${bsrp_trff }">
									<option value="${list.code }">${list.code_desc }</option>
								</c:forEach>
							</select>
						</dd>
					</dl>
					
				</div>
				
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


<div class="pop_wrap_dir" id="newPopUp" style="width: 1000px; display: none;">
	<div class="pop_con">
		<div class="com_ta2">
			<form id="popupform">
			<input type="hidden" name="ba_seq" id="ba_seq" class="dataInput" >
			<table id="topTable">
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
					<th>교통수단</th>								
					<td>
						<select name="tfcmn" id="tfcmn" style="width: 80px;">
							<c:forEach var="list" items="${bsrp_tfcmn }">
								<option value="${list.code }">${list.code_desc }</option>
							</c:forEach>
						</select>
					</td>
					<th>요금종류</th>								
					<td>
						<select name="trff" id="trff" style="width: 80px;">
							<c:forEach var="list" items="${bsrp_trff }">
								<option value="${list.code }">${list.code_desc }</option>
							</c:forEach>
						</select>
					</td>
					<th>출발지</th>								
					<td>
						<select name="strtpnt" id="strtpnt" style="width: 80px;">
							<c:forEach var="list" items="${bsrp_area }">
								<option value="${list.code }">${list.code_desc }</option>
							</c:forEach>
						</select>
					</td>
					<th>도착지</th>								
					<td>
						<select name="aloc" id="aloc" style="width: 80px;">
							<c:forEach var="list" items="${bsrp_area }">
								<option value="${list.code }">${list.code_desc }</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				
				<tr>
					<th>지급액</th>
					<td colspan="7" style="text-align: left; padding-left: 13px;">
						<input type="text" id="pymntamtTemp" class="dataInput" onkeyup="numberChk(this);" onchange="numberChk(this);" style="text-align: right;">원
						<input type="hidden" name="pymntamt" id="pymntamt">
					</td>
				</tr>
				
				<tr>
					<th>비고</th>
					<td colspan="7">
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
            url:  "<c:url value='/bsrp/bsrpAdminListSerch' />",
            dataType: "json",
            type: 'post'
        },
      	parameterMap: function(data, operation) {
      		data.tfcmn = $('#topSearchTfcmn').val();
      		data.trff = $('#topSearchTrff').val();
      		data.strtpnt = $('#topSearchStrtpnt').val();
      		data.aloc = $('#topSearchAloc').val();
      		data.type = 'page';
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
		width: "1000px",
	    title: '출장관리',
	    visible: false,
	    modal : true,
	    actions: [
	        "Close"
	    ],
	}).data("kendoWindow").center();
	
	$("#gridList").kendoGrid({
        dataSource: dataSource,
        height: 460,
        sortable: false,
        pageable: {
            refresh: true,
            pageSizes : [10,20,30,50,100],
            buttonCount: 5
        },
        persistSelection: true,
        selectable: "multiple",
        columns: [
       	{
   			headerTemplate: "<input type='checkbox' id='headerCheckbox' class='k-checkbox header-checkbox headerCheckbox'><label class='k-checkbox-label' for='headerCheckbox'></label>",
   			template: checkBoxTp,
   	    	width: "40px"
       	}, {
            field: "tfcmn_kr",
            title: "교통수단",
        }, {
            field: "trff_kr",
            title: "요금제",
        }, {
            field: "strtpnt_kr",
            title: "출발지",
        }, {
            field: "aloc_kr",
            title: "도착지",
        }, {
            template : pymnTemp,
            title: "지급액",
        }, {
            field: "rm",
            title: "비고",
        }],
    }).data("kendoGrid");
	
	
	$(document).on('dblclick', '#gridList .k-grid-content tr', function(){
		var gData = $("#gridList").data('kendoGrid').dataItem(this);
	
		$.each(gData, function(i, v){
			$('#popupform #' + i).val(v);
		});
		
		$('#pymntamtTemp').val(numberWithCommas(gData.pymntamt));
		
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

});

var pymnTemp = function(row){
	return numberWithCommas(row.pymntamt) + '원';
}

var checkBoxTp = function(row) {
	var key = row.ba_seq;
	return '<input type="checkbox" id="sts'+key+'" class="k-checkbox checkbox"/><label for="sts'+key+'" class="k-checkbox-label"></label>';
}

function newPopupBtn(){
	
	$('#saveBtn').val('입력');
	$('#newPopUp .dataInput').val('');
	$('#newPopUp').data("kendoWindow").open().center();
	
}

function fn_saveBtn(){

	$('#pymntamt').val($('#pymntamtTemp').val().replace(/[^0-9]/g,""));

	var data = $('#popupform').serialize();
	
	$.ajax({
		url : "<c:url value='/bsrp/bsrpAdminSave' />",
		data : 'json',
		type : 'POST',
		data : data,
		success : function(result) {
			$('#newPopUp').data("kendoWindow").close();
			$("#gridList").data('kendoGrid').dataSource.read();
		}
	});
	
}

function delBtn(){
	
	var ch = $('#gridList tbody .checkbox:checked');
	var data = new Array();
	$.each(ch, function(i,v){
		data.push( $("#gridList").data("kendoGrid").dataItem($(v).closest("tr")).ba_seq );
	});
	
	if(data.length == 0){
		alert('삭제 할 항목을 선택해 주세요.');
		return 
	}
	
	if(!confirm('삭제 하시겠습니까?')){
		return
	}
	
	$.ajax({
		url: "<c:url value='/bsrp/bsrpAdminDel' />",
		data : {ba_seq : data.join()},
		type : 'POST',
		success: function(result){
			$("#gridList").data('kendoGrid').dataSource.read();
		}
	});
	
}

function fn_closeBtn(){
	$('#newPopUp').data("kendoWindow").close();
}

function numberChk(e){
	$('#pymntamtTemp').val(numberWithCommas($(e).val().replace(/[^0-9]/g,"")));
}

function gridSearch(){
	$("#gridList").data('kendoGrid').dataSource.page(1);
}
</script>
</body>

