<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>

<div class="iframe_wrap" style="min-width:1100px">

	<div class="sub_title_wrap">
		
		<div class="title_div">
			<h4>평가부분 등록</h4>
		</div>
	</div>

	<div class="sub_contents_wrap" style="min-width:1400px; min-height: 0px;">
		<p class="tit_p mt5 mt20">평가부분 등록</p>
		
		<div class="com_ta">
			<div class="top_box gray_box" id="newDate">
				<input type="hidden" id="eval_item_seq" value="">
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
					<dt style="">
						평가부문
					</dt>
					<dd style="line-height: 25px">
						<select id="eval_type" style="width: 200px;">
						</select>
					</dd>
	
					<dt style="">
						평가부분
					</dt>
					<dd style="line-height: 25px">
						<input type="text" id="item_name" style="width: 200px;">
					</dd>

					<dt style="margin-left:50px;">
						배점
					</dt>
					<dd style="line-height: 25px">
						<input type="text" id="score" style="width: 50px;">
					</dd>
	
					<dt style="margin-left:50px;">
						정렬순서
					</dt>
					<dd style="line-height: 25px">
						<input type="text" id="order_no" style="width: 50px;">
					</dd>

					<dt style="margin-left:50px;">
						<input type="checkbox" checked="checked" id="active"><label for="active">활성</label>
					</dt>
				</dl>
				
				<dl>
					<dt style="">
						평가기준
					</dt>
					<dd style="line-height: 25px; width: 80%;">
						<textarea rows="3" cols="200" id="standard" ></textarea>
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
            url: "<c:url value='/eval/evalBizTypeItemListSearch' />",
            dataType: "json",
            type: "post"
        },
      	parameterMap: function(data, operation) {
      		data.eval_type_seq = $('#eval_type').val();
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

var selectDataSource = new kendo.data.DataSource({
	serverPaging: true,
	pageSize: 10,
    transport: { 
        read:  {
            url: "<c:url value='/eval/evalTypeSearch' />",
            dataType: "json",
            type: "post",
            async: false,
        },
      	parameterMap: function(data, operation) {
      		data.biz_type = $('#biz_type').val();
      		return data;
     	}
    },
    schema: {
      data: function(response) {
    	  if(response.length == 0){
    		  return [{type_name : '데이터가 없습니다.', eval_type_seq : ''}];
    	  }else{
	    	  return response;
    	  }
      },
    }
});

$(function(){
	
	$('#saveBtn').text(saveBtnTxt);
	
	$('#biz_type').kendoDropDownList({
		change: function(e) {
			var ds = $('#eval_type').data("kendoDropDownList");
			ds.dataSource.read();
			ds.select(0);
		}		
	});

	$('#eval_type').kendoDropDownList({
		dataSource: selectDataSource,
		dataTextField: "type_name",
		dataValueField: "eval_type_seq",
	});

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
	        width: "200px;",
    	},{
    		field: "item_name",
	        title: "평가부분",
	        width: "200px;",
    	},{
    		field: "standard",
	        title: "평가기준",
	        template: standardTemp,
	        width: "200px;",
    	},{
    		field: "score",
	        title: "배점",
	        width: "100px;",
    	},{
    		field: "active",
	        title: "활성",
	        template: activeTemp,
	        width: "100px;",
	    }],
	}).data("kendoGrid");
	
	$('.searchInput').on('keydown', function(key){
		if (key.keyCode == 13) {
			searchBtn();
       }
	});
	
});

var standardTemp = function(row){
	
	return '<pre>'+row.standard+'</pre>'
}

var activeTemp = function(row){
	return row.active == 'Y' ? '활성' : '비활성';
}

function clickRow(e){
	
	var row = $('#gridList').data("kendoGrid").dataItem(this.select());

	$('#biz_type').data("kendoDropDownList").value(row.biz_type_code_id);
	$('#eval_type').data("kendoDropDownList").dataSource.read();
	$('#eval_type').data("kendoDropDownList").value(row.eval_type_seq);
	
	$('#newDate #item_name').val( row.item_name);
	$('#newDate #score').val(row.score);
	$('#newDate #order_no').val(row.order_no);
	$('#newDate #standard').val(row.standard)
	$('#newDate #eval_item_seq').val(row.eval_item_seq);
	
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

function gridDelBtn(e){
	
	if(confirm('삭제하시겠습니까?')){
		
		$.ajax({
			url: "<c:url value='/eval/evalBizTypeItemDel' />",
			data : {code : $('#newDate #eval_item_seq').val()},
			type : 'POST',
			success: function(result){
				alert("삭제하였습니다.");
				resetInput();
				searchBtn();
			}
		});
	}
}

function newSaveBtn(){
	
	if(confirm(saveBtnTxt + '하시겠습니까?')){
		
		var data = {
				item_name : $('#newDate #item_name').val(),
				score : $('#newDate #score').val(),
				order_no : $('#newDate #order_no').val(),
				standard : $('#newDate #standard').val(),
				active : $('#newDate  input[type="checkbox"]').prop('checked') == true ? 'Y' : 'N',
				eval_item_seq : $('#newDate #eval_item_seq').val(),
				eval_type_seq : $('#newDate #eval_type').val(),
			}
		
		$.ajax({
			url: "<c:url value='/eval/evalBizTypeItemSave' />",
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
	$('#newDate textarea').val('');
	$('#eval_item_seq').val('');
	$('#newDate input[type=checkbox]').prop('checked', 'checked');
	saveBtnTxt = '저장';
	$('#saveBtn').text(saveBtnTxt);
}

</script>

