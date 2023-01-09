<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>

<div class="iframe_wrap" style="min-width:1100px">

	<div class="sub_title_wrap">
		
		<div class="title_div">
			<h4>평가부문 등록</h4>
		</div>
	</div>

	<div class="sub_contents_wrap" style="min-width:1400px; min-height: 0px;">
		<p class="tit_p mt5 mt20">평가부문 등록</p>		
		
		<div class="com_ta">
			<div class="top_box gray_box" id="newDate">
				<input type="hidden" id="eval_type_seq" value="">
				<dl>
					<dt style="">
						사업구분
					</dt>
					<dd style="line-height: 25px">
						<select id="biz_type" style="width: 200px;">
							<c:forEach items="${btcList }" var="list">
								<option value="${list.code }">${list.code_kr }</option>
							</c:forEach>
						</select>					
					</dd>
	
					<dt style="margin-left:100px;">
						평가부문
					</dt>
					<dd style="line-height: 25px">
						<input type="text" id="type_name" style="width: 250px;">
					</dd>
	
					<dt style="margin-left:100px;">
						배점
					</dt>
					<dd style="line-height: 25px">
						<input type="text" id="score" style="width: 50px;">
					</dd>
	
					<dt style="margin-left:100px;">
						정렬순서
					</dt>
					<dd style="line-height: 25px">
						<input type="text" id="order_no" style="width: 50px;">
					</dd>

					<dt style="margin-left:100px;">
						<input type="checkbox" checked="checked" id="active"><label for="active">활성</label>
					</dt>
				</dl>
				
				<dl>
					<dt style="margin-right: 37px;">
						비고
					</dt>
					<dd style="line-height: 25px; width: 80%;">
						<input type="text" id="remark" style="width: 80%;">
					</dd>
				</dl>
				
			</div>
			
		</div>
	
	</div>
		
	<div class="sub_contents_wrap">
		<div class="left_div" style="float: left;">
			<div class="controll_btn p0">
				<button type="button" id="search" onclick="searchBtn();">조회</button>
			</div>
		</div>
		
		<div class="right_div">
			<div class="controll_btn p0">
				<button type="button" id="search" onclick="resetInput();">신규</button>
				<button type="button" id="saveBtn" onclick="newSaveBtn();">저장</button>
				<button type="button" id="search" onclick="gridDelBtn();">삭제</button>
			</div>
		</div>
		
		<div class="com_ta2 mt15">
		    <div id="gridList"></div>
		</div>
		
	</div>

</div>

<script>
var saveBtnTxt = '저장';
var pageInfo = {
        refresh: true,
        pageSizes: [10, 20, 40],
        buttonCount: 5,
        messages: {
            display: "{0} - {1} of {2}",
            itemsPerPage: "",
            empty: "데이터가 없습니다.",
        }
};

var gridDataSource = new kendo.data.DataSource({
	serverPaging: true,
	pageSize: 10,
    transport: { 
        read:  {
            url: "<c:url value='/eval/evalBizTypeListSearch' />",
            dataType: "json",
            type: "post"
        },
      	parameterMap: function(data, operation) {
      		data.biz_type_code_id = $('#biz_type').val();
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

$(function(){
	
	$('#biz_type').kendoDropDownList();
	
	$("#gridList").kendoGrid({
	    dataSource: gridDataSource,
	    height: 600,
	    sortable: false,
	    pageable: pageInfo,
	    selectable: "multiple, row",
	    change : clickRow,
	    columns: [
    	{
    		field: "order_no",
	        title: "정렬순서",
	        width: "100px;",
    	},{
	    	field: "biz_type",
	        title: "사업구분",
	        width: "200px;",
    	},{
    		field: "type_name",
	        title: "평가부문",
	        width: "300px;",
    	},{
    		field: "score",
	        title: "배점",
	        width: "100px;",
    	},{
    		field: "active",
    		template: activeTemp,
	        title: "활성",
	        width: "100px;",
    	},{
    		field: "remark",
	        title: "비고",
	    }],
	}).data("kendoGrid");
	
	$('.searchInput').on('keydown', function(key){
		if (key.keyCode == 13) {
			searchBtn();
       }
	});
	
});

var activeTemp = function(row){
	return row.active == 'Y' ? '활성' : '비활성';
}

function clickRow(e){
	
	var row = $('#gridList').data("kendoGrid").dataItem(this.select());
	
	$('#biz_type').data("kendoDropDownList").value(row.biz_type_code_id);
	
	$('#newDate #score').val(row.score);
	$('#newDate #order_no').val(row.order_no);
	$('#newDate #type_name').val(row.type_name)
	$('#newDate #remark').val(row.remark);
	$('#newDate #eval_type_seq').val(row.eval_type_seq);
	
	if(row.active == 'Y'){
		$('#newDate  input[type="checkbox"]').prop('checked', true)
	}else{
		$('#newDate  input[type="checkbox"]').prop('checked', false)
	}
	
	saveBtnTxt = '수정';
	$('#saveBtn').text(saveBtnTxt);
	
}

function searchBtn(){
	$("#gridList").data("kendoGrid").dataSource.page(1);
}

function newSaveBtn(){
	
	if(confirm(saveBtnTxt + '하시겠습니까?')){
		
		var data = {
				type_name : $('#newDate #type_name').val(),
				score : $('#newDate #score').val(),
				order_no : $('#newDate #order_no').val(),
				remark : $('#newDate #remark').val(),
				active : $('#newDate  input[type="checkbox"]').prop('checked') == true ? 'Y' : 'N',
				biz_type : $('#newDate #biz_type option:selected').text(),
				biz_type_code_id : $('#newDate #biz_type').val(),
				eval_type_seq : $('#newDate #eval_type_seq').val(),
			}
		
		$.ajax({
			url: "<c:url value='/eval/evalBizTypeSave' />",
			data : data,
			type : 'POST',
			success: function(result){
				alert(saveBtnTxt + '하였습니다.');
				searchBtn();
				resetInput();
			}
		});
		
		
	}
	
}

function resetInput(){
	$('#newDate input[type="text"]').val('');
	$('#newDate input[type=checkbox]').prop('checked', 'checked');
}

function resetInput(){
	$('#newDate input[type="text"]').val('');
	$('#eval_type_seq').val('');
	$('#newDate input[type=checkbox]').prop('checked', 'checked');
	saveBtnTxt = '저장';
	$('#saveBtn').text(saveBtnTxt);
}

function gridDelBtn(e){
	
	if(confirm('삭제하시겠습니까?')){
		
		$.ajax({
			url: "<c:url value='/eval/evalBizTypeDel' />",
			data : {code : $('#newDate #eval_type_seq').val()},
			type : 'POST',
			success: function(result){
				alert("삭제하였습니다.");
				resetInput();
				searchBtn();
			}
		});
	}
}

</script>

