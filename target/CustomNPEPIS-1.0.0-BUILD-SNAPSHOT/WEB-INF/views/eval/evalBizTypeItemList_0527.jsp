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
		<div class="left_div">
			<p class="tit_p mt5 mb0">평가부분 등록</p>
		</div>
		
		<div class="com_ta">
			<div class="top_box gray_box" id="newDate">
			
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
	
					<dt style="margin-left:50px;">
						평가부문
					</dt>
					<dd style="line-height: 25px">
						<select id="eval_type" style="width: 200px;">
						</select>
					</dd>

					<dt style="margin-left:50px;">
						평가부분
					</dt>
					<dd style="line-height: 25px">
						<input type="text" id="item_name" style="width: 250px;">
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
				<button type="button" id="search" onclick="newSaveBtn();">신규</button>
				<button type="button" id="search" onclick="newSaveBtn();">저장</button>
				<button type="button" id="search" onclick="newSaveBtn();">삭제</button>
			</div>
		</div>
		
		<div class="com_ta2 mt15">
		    <div id="gridList"></div>
		</div>
		
	</div>
		

</div>

<script>
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
    	  return response;
      },
    }
});

$(function(){
	
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
	    columns: [
    	{
	    	field: "biz_type",
	        title: "사업구분",
	        width: "200px;",
    	},{
    		field: "type_name",
	        title: "평가부문",
	        width: "200px;",
    	},{
    		field: "item_name",
    		template: itemNameTemp,
	        title: "평가항목",
	        width: "200px;",
    	},{
    		field: "standard",
    		template: standardTemp,
	        title: "평가기준",
	        width: "200px;",
    	},{
    		field: "score",
    		template: scoreTemp,
	        title: "배점",
	        width: "100px;",
    	},{
    		field: "order_no",
    		template: orderTemp,
	        title: "정렬순서",
	        width: "100px;",
    	},{
    		field: "active",
    		template: activeTemp,
	        title: "활성",
	        width: "100px;",
	    }],
	}).data("kendoGrid");
	
	$('.searchInput').on('keydown', function(key){
		if (key.keyCode == 13) {
			searchBtn();
       }
	});
	
});

var gridModBtn = function(row){
	return '<input type="button" value="수정" onclick="gridMod(this);"> <input type="button" value="삭제" onclick="gridDel(this);">';
}

var itemNameTemp = function(row){
	return '<input type="text" id="item_name_temp" style="width:90%;" value="'+row.item_name+'">';
}

var scoreTemp = function(row){
	var tem = row.score == null ? '' : row.score;
	return '<input type="text" id="score_temp" style="width:60px;" value="'+tem+'">';
}

var orderTemp = function(row){
	var tem = row.order_no == null ? '' : row.order_no;
	return '<input type="text" id="order_no_temp" style="width:60px;" value="'+tem+'">';
}

var activeTemp = function(row){
	var checked = row.active == 'Y' ? 'checked="checked"' : '';
	return '<input type="checkbox" style="visibility: hidden;" '+checked+' id="active_'+row.eval_item_seq+'"><label for="active_'+row.eval_item_seq+'">활성</label>';
}

var standardTemp = function(row){
	var tem = row.standard == null ? '' : row.standard;
// 	return '<input type="text" id="standard_temp" style="width:90%;" value="'+tem+'">';
	return '<textarea rows="3" cols="40" id="standard_temp" >'+tem+'</textarea>';
}


function searchBtn(){
	$("#gridList").data("kendoGrid").dataSource.page(1);
}

function gridDel(e){
	
	if(confirm('삭제하시겠습니까?')){
		var tr = $(e).closest("tr");
		var row = $('#gridList').data("kendoGrid").dataItem(tr);
		
		$.ajax({
			url: "<c:url value='/eval/evalBizTypeItemDel' />",
			data : {code : row.eval_item_seq},
			type : 'POST',
			success: function(result){
				alert("삭제하였습니다.");
				searchBtn();
			}
		});
	}
}

function newSaveBtn(){
	
	if(confirm('등록하시겠습니까?')){
		
		var data = {
				item_name : $('#newDate #item_name').val(),
				score : $('#newDate #score').val(),
				order_no : $('#newDate #order_no').val(),
				standard : $('#newDate #standard').val(),
				active : $('#newDate  input[type="checkbox"]').prop('checked') == true ? 'Y' : 'N',
				eval_type_seq : $('#newDate #eval_type').val(),
			}
		
		$.ajax({
			url: "<c:url value='/eval/evalBizTypeItemSave' />",
			data : data,
			type : 'POST',
			success: function(result){
				alert("등록하였습니다.");
				searchBtn();
				resetInput();
			}
		});
		
		
	}
	
}

function gridMod(e){
	
	if(confirm('수정하시겠습니까?')){
		
		var tr = $(e).closest("tr");
		var row = $('#gridList').data("kendoGrid").dataItem(tr);

		var data = {
			item_name : $(tr).find('#item_name_temp').val(),
			score : $(tr).find('#score_temp').val(),
			order_no : $(tr).find('#order_no_temp').val(),
			standard : $(tr).find('#standard_temp').val(),
			active : $(tr).find('input[type="checkbox"]').prop('checked') == true ? 'Y' : 'N',
			eval_item_seq : row.eval_item_seq,
		}
		
		$.ajax({
			url: "<c:url value='/eval/evalBizTypeItemUpdate' />",
			data : data,
			type : 'POST',
			success: function(result){
				alert("수정하였습니다.");
				searchBtn();
			}
		});
		
	}
	
}

function resetInput(){
	$('#newDate input[type="text"]').val('');
	$('#newDate textarea').val('');
	$('#newDate input[type=checkbox]').prop('checked', 'checked');
}

</script>

