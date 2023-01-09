<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>


<div class="iframe_wrap" style="min-width:1100px">

	<div class="sub_title_wrap">
		
		<div class="title_div">
			<h4>업체 목록</h4>
		</div>
	</div>
	
	
	<div class="sub_contents_wrap" style="min-width:1400px; min-height: 0px;">
		<p class="tit_p mt5 mb10">업체 목록</p>

		<div class="com_ta">
			<div class="top_box gray_box">
				<dl>
					<dt style="">
						업체명
					</dt>
					<dd style="line-height: 25px">
						<input type="text" id="search_title" class="searchInput" style="width: 250px;">
					</dd>
					<dt style="margin-left:50px;">
						사업자등록번호
					</dt>
					<dd style="line-height: 25px">
						<input type="text" id="search_biz_reg_no" class="searchInput" style="width: 250px;">
					</dd>

				</dl>
				
			</div>
	
		</div><!-- //sub_contents_wrap -->
		
		<div class="sub_contents_wrap">
			<div class="right_div">
				<div class="controll_btn p5">
					<button type="button" id="search" onclick="searchBtn();">조회</button>
					<button type="button" id="search" onclick="evalNewCompanyBtn();">신청</button>
				</div>
			</div>
		
			<div class="com_ta2 mt15">
			    <div id="gridList"></div>
			</div>
		</div>
	
	</div><!-- iframe wrap -->
		
</div>


<div class="pop_wrap" id="evalNewCompanyPopup" style="min-width:1200px; display:none;">
	<div class="pop_con">	
		<!-- 컨트롤박스 -->
		<div class="com_ta2">
			<div class="top_box gray_box">
			<input type="hidden" id="company_seq">
			<table>
				<tr>
					<th><img src="../Images/ico/ico_check01.png" alt="checkIcon">회사명</th>
					<td>
					<input type="text" id="title"></td>
					<th><img src="../Images/ico/ico_check01.png" alt="checkIcon">사업자등록번호</th>
					<td><input type="text" id="biz_reg_no"></td>
					<th>사회적기업여부</th>
					<td><input type="radio" name="social_company_yn" id="social_company_y" value="Y"><label for="social_company_y">사용</label>&emsp;
						<input type="radio" name="social_company_yn" id="social_company_n" checked="checked" value="N"><label for="social_company_n">미사용</label> </td>
				</tr>
				<tr>
					<th>협동조합여부</th>
					<td><input type="radio" name="union_yn" id="union_y" value="Y"><label for="union_y">사용</label>&emsp;
						<input type="radio" name="union_yn" id="union_n" checked="checked" value="N"><label for="union_n">미사용</label> </td>
					<th>여성기업여부</th>
					<td><input type="radio" name="women_company_yn" id="women_company_y" value="Y"><label for="women_company_y">사용</label>&emsp;
						<input type="radio" name="women_company_yn" id="women_company_n" checked="checked" value="N"><label for="women_company_n">미사용</label> </td>
					<th>장애인기업여부</th>
					<td><input type="radio" name="handicap_company_yn" id="handicap_company_y" value="Y"><label for="handicap_company_y">사용</label>&emsp;
						<input type="radio" name="handicap_company_yn" id="handicap_company_n" checked="checked" value="N"><label for="handicap_company_n">미사용</label> </td>
				</tr>
				<tr>
					<th>중증장애인시설여부</th>
					<td><input type="radio" name="handicap_facility_yn" id="handicap_facility_y" value="Y"><label for="handicap_facility_y">사용</label>&emsp;
						<input type="radio" name="handicap_facility_yn" id="handicap_facility_n" checked="checked" value="N"><label for="handicap_facility_n">미사용</label> </td>
					<th>국가유공자자활용사촌여부</th>
					<td><input type="radio" name="merit_use_yn" id="merit_use_y" value="Y"><label for="merit_use_y">사용</label>&emsp;
						<input type="radio" name="merit_use_yn" id="merit_use_n" checked="checked" value="N"><label for="merit_use_n">미사용</label> </td>
					<th>3년미만신생기업여부</th>
					<td><input type="radio" name="new_company_yn" id="new_company_y" value="Y"><label for="new_company_y">사용</label>&emsp;
						<input type="radio" name="new_company_yn" id="new_company_n" checked="checked" value="N"><label for="new_company_n">미사용</label> </td>
				</tr>
				<tr>
					<th>벤처기업여부</th>
					<td><input type="radio" name="venture_company_yn" id="venture_company_y" value="Y"><label for="venture_company_y">사용</label>&emsp;
						<input type="radio" name="venture_company_yn" id="venture_company_n" checked="checked" value="N"><label for="venture_company_n">미사용</label> </td>
					<th></th>
					<td></td>
					<th></th>
					<td></td>
				</tr>
			</table>
			
			<div class="top_box gray_box">
				<dl>
					<dd style="width: 45%;"></dd>
					<dd>
						<input type="button" style="margin-bottom: 15px;" id="saveBtn" onclick="companySave();" value="등록하기">
					</dd>
				</dl>
			</div>
		</div>
		
	</div><!-- //pop_con -->
</div><!-- //pop_wrap -->

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
            url: "<c:url value='/eval/evalCompanyListSearch' />",
            dataType: "json",
            type: "post"
        },
      	parameterMap: function(data, operation) {
      		data.search_title = $('#search_title').val();
      		data.search_biz_reg_no = $('#search_biz_reg_no').val();
      		data.pageType = 'page';
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
	
	$('#evalNewCompanyPopup').kendoWindow({
	    width: "1200px;",
	    title: '업체관리',
	    visible: false,
	    modal : true,
	    actions: [
	        "Close"
	    ],
	}).data("kendoWindow");
	
	$("#gridList").kendoGrid({
	    dataSource: gridDataSource,
	    height: 600,
	    sortable: false,
	    pageable: pageInfo,
	    columns: [
    	{
	    	field: "title",
	        title: "업체명",
    	},{
    		field: "biz_reg_no",
	        title: "사업자등록번호",
    	},{
    		field: "social_company_yn",
    		template: function(row){
    			return dataYn(row.social_company_yn);
    		},
	        title: "사회적기업여부",
    	},{
    		field: "union_yn",
    		template: function(row){
    			return dataYn(row.union_yn);
    		},
	        title: "협동조합여부",
    	},{
    		field: "women_company_yn",
    		template: function(row){
    			return dataYn(row.women_company_yn);
    		},
	        title: "여성기업여부",
    	},{
    		field: "handicap_company_yn",
    		template: function(row){
    			return dataYn(row.handicap_company_yn);
    		},
	        title: "장애인기업여부",
    	},{
    		field: "handicap_facility_yn",
    		template: function(row){
    			return dataYn(row.handicap_facility_yn);
    		},
	        title: "중증장애인시설여부",
    	},{
    		field: "merit_use_yn",
    		template: function(row){
    			return dataYn(row.merit_use_yn);
    		},
	        title: "국가유공자자활용사촌여부",
    	},{
    		field: "new_company_yn",
    		template: function(row){
    			return dataYn(row.new_company_yn);
    		},
	        title: "3년미만신생기업여부",
    	},{
    		field: "venture_company_yn",
    		template: function(row){
    			return dataYn(row.venture_company_yn);
    		},
	        title: "벤처기업여부",
    	},{
			width:"150px;",
    		template: gridModBtn,
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

function dataYn(v){
	return v == 'Y' ? '사용' : '미사용';
}
function evalNewCompanyBtn(){
	$('#saveBtn').val('등록하기');
	
	$('#company_seq').val('');
	$('#title').val('');
	$('#biz_reg_no').val('');
	
	$.each($('#evalNewCompanyPopup input[type=radio]'), function(i, v){

		if($(v).attr('id').indexOf('_n') > -1){
			$(v).prop('checked', true);
		}
			
	});
	
	$('#evalNewCompanyPopup').data("kendoWindow").center().open();
}

function companySave(){
	
	if($('#title').val().length == 0){
		alert('회사명을 입력해 주세요.');
		return
	}

	if($('#biz_reg_no').val().length == 0){
		alert('사업자등록번호를 입력해 주세요.');
		return
	}
	
	var data = {
		company_seq : $('#company_seq').val(),			
		title : $('#title').val(),
		biz_reg_no : $('#biz_reg_no').val(),
		social_company_yn : $('input[name=social_company_yn]:checked').val(),
		union_yn : $('input[name=union_yn]:checked').val(),
		women_company_yn : $('input[name=women_company_yn]:checked').val(),
		handicap_company_yn : $('input[name=handicap_company_yn]:checked').val(),
		handicap_facility_yn :$('input[name=handicap_facility_yn]:checked').val(),
		merit_use_yn : $('input[name=merit_use_yn]:checked').val(),
		new_company_yn : $('input[name=new_company_yn]:checked').val(),
		venture_company_yn : $('input[name=venture_company_yn]:checked').val(),
	}
	
	$.ajax({
		url: "<c:url value='/eval/evalCompanySave' />",
		data : data,
		type : 'POST',
		success: function(result){
			alert('등록되었습니다.');
			$('#evalNewCompanyPopup').data("kendoWindow").close();
			$("#gridList").data("kendoGrid").dataSource.read();
		}
	
   	});

}

function searchBtn(){
	$("#gridList").data("kendoGrid").dataSource.page(1);
}

function gridMod(e){
	var tr = $(e).closest("tr");
	var row = $('#gridList').data("kendoGrid").dataItem(tr);
	$('#saveBtn').val('수정하기');
	
	$.each(row, function(i, v){

		$('#evalNewCompanyPopup #' + i).val(v);
		
	
		if(i.indexOf('_yn') > -1){
			var tem = i.substr(0, i.indexOf('_yn')) + '_' ;
			if(v == 'Y'){
				tem += 'y';
			}else{
				tem += 'n';
			}

			$('#'+tem).prop('checked', true)
		}
			
	});
	
	$('#evalNewCompanyPopup').data("kendoWindow").center().open();
	
}

function gridDel(e){
	
	var tr = $(e).closest("tr");
	var row = $('#gridList').data("kendoGrid").dataItem(tr);
	
	$.ajax({
		url: "<c:url value='/eval/evalCompanyDel' />",
		data : {company_seq : row.company_seq},
		type : 'POST',
		success: function(result){
			alert('삭제되었습니다.');
			$("#gridList").data("kendoGrid").dataSource.read();
		}
	
   	});
	
}

</script>