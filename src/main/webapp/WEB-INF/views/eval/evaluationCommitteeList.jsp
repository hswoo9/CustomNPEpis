<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<style>
.upload-hidden{
	display:none;
}
.controll_btn label {
    background: #fff;
    border-radius: 0px;
    box-shadow: none;
    padding: 5px 12px;
    height: 24px;
    line-height: 24px;
    border: 1px solid #c9cac9;
    outline: 0;
    color: #4a4a4a !important;
}
.controll_btn label:hover {
	border:1px solid #1088e3;background:#fff;
}
.controll_btn label:active {
	border:1px solid #1088e3;background:#f4f9fe;
}
.controll_btn label:focus {
	box-shadow:none;
}
input, select, button, img, label {
    vertical-align: middle;
}
.wrap-loading{ /*화면 전체를 어둡게 합니다.*/
	z-index:999;
    position: fixed;
    left:0;
    right:0;
    top:0;
    bottom:0;
    background: rgba(0,0,0,0.2); /*not in ie */
    filter: progid:DXImageTransform.Microsoft.Gradient(startColorstr='#20000000', endColorstr='#20000000');    /* ie */
}

.wrap-loading div{ /*로딩 이미지*/
    position: fixed;
    top:50%;
    left:50%;
    margin-left: -21px;
    margin-top: -21px;
}

.display-none{ /*감추기*/
    display:none;
}
</style>

<div class="wrap-loading display-none">
    <div><img src="../Images/ajax-loader.gif"></div>
</div> 

<div class="iframe_wrap" style="min-width:1100px">

	<!-- 컨텐츠타이틀영역 -->
	<div class="sub_title_wrap">
		
		<div class="title_div">
			<h4>평가위원 목록</h4>
		</div>
	</div>
	
	<div class="sub_contents_wrap" style="min-width:1400px; min-height: 0px;">
		<p class="tit_p mt5 mb10">평가위원 목록</p>
	
		<div class="com_ta">
			<div class="top_box gray_box">
				<dl>
					<dt style="">
						성명
					</dt>
					<dd style="line-height: 25px">
						<input type="text" id="searchNm" class="searchInput">
					</dd>
					<dt style="margin-left:100px;">
						기관명
					</dt>
					<dd style="line-height: 25px">
						<input type="text" id="searchOrgNm" class="searchInput">
					</dd>
					<dt style="margin-left:100px;">
						등록기간
					</dt>
					<dd style="line-height: 25px">
						<input type="text" class="date_yyyymmdd" id="searchSt">~
						<input type="text" class="date_yyyymmdd" id="searchEt">
					</dd>
					<dt style="margin-left:100px;">
						전문분야
					</dt>
					<dd style="line-height: 25px">
						<select class="selectMenu" id="searchSelect" style="width: 200px;">
							<option value="all">전체</option>
							<c:forEach items="${btcList }" var="list">
								<option value="${list.code }">${list.code_kr }</option>
							</c:forEach>
						</select>
					</dd>
				</dl>
				
			</div>
	
		</div><!-- //sub_contents_wrap -->
		
	</div>
	
	<div class="sub_contents_wrap">
		<div class="right_div">
			<div class="controll_btn p0">
				<button type="button" id="search" onclick="searchBtn();">조회</button>
				<button type="button" id="search" onclick="newEvalBtn();">신청</button>
				<button type="button" onclick="excelSample();">엑셀샘플 다운로드</button>
				<label for="excelUpload" id="excelUploadBtn"> 엑셀 업로드 </label> 
				<input type="file" id="excelUpload" name="excelUpload" class="upload-hidden" onchange="excelUpload(this)">
			</div>
		</div>
		
		<div class="com_ta2 mt15">
		    <div id="gridList"></div>
		</div>
		
		
	</div>
	
</div><!-- iframe wrap -->

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
            url: "<c:url value='/eval/evaluationCommitteeListSearch' />",
            dataType: "json",
            type: "post"
        },
      	parameterMap: function(data, operation) {
      		data.searchNm = $('#searchNm').val();
      		data.searchOrgNm = $('#searchOrgNm').val();
      		data.searchSt = $('#searchSt').val();
      		data.searchEt = $('#searchEt').val();
      		data.searchSelect = $('#searchSelect').val();
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
	
	$('.date_yyyymmdd').kendoDatePicker({
     	culture : "ko-KR",
	    format : "yyyy-MM-dd",
	});
	
	$(".date_yyyymmdd").attr("readonly", true);
	
	$('#searchSelect').kendoDropDownList();
	
	
	$("#gridList").kendoGrid({
	    dataSource: gridDataSource,
	    height: 600,
	    sortable: false,
	    pageable: pageInfo,
	    columns: [
    	{
	    	field: "NAME",
	        title: "성명",
    	},{
    		field: "ORG_NAME",
	        title: "기관명",
    	},{
    		field: "BIZ_TYPE_ARRAY",
	        title: "전문분야",
    	},{
    		field: "CREATE_DATE",
	        title: "등록일",
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
	return '<input type="button" value="상세" onclick="gridMod(this);"> <input type="button" value="삭제" onclick="gridDel(this);">';
}

function gridMod(e){
	
	var tr = $(e).closest("tr");
	var row = $('#gridList').data("kendoGrid").dataItem(tr);
	location.href = "<c:url value='/eval/evaluationCommitteeMod?code='/>" + row.COMMISSIONER_POOL_SEQ;
	
}

function gridDel(e){
	
	if(confirm('삭제하시겠습니까?')){
		var tr = $(e).closest("tr");
		var row = $('#gridList').data("kendoGrid").dataItem(tr);
		
		$.ajax({
			url: "<c:url value='/eval/evaluationCommitteeDel' />",
			data : {code : row.COMMISSIONER_POOL_SEQ},
			type : 'POST',
			success: function(result){
				alert("삭제하였습니다.");
				searchBtn();
			}
		});
	}
}

function newEvalBtn(){
	location.href = "<c:url value='/eval/evaluationCommitteeViwe'/>";
}

function searchBtn(){
	$("#gridList").data("kendoGrid").dataSource.page(1);
}

function excelSample(){
	var what = "평가위원_등록_샘플.xlsx"
	var downWin = window.open('','_self');
	downWin.location.href = "<c:url value='/eval/evaluationCommitteeListExcelSampleDownload' />";
	//window.location.assign("<c:url value='/eval/evaluationCommitteeListExcelSampleDownload' />");
}

function excelUpload(file){

	var formData = new FormData();
	formData.append("excelfile", $(file)[0].files[0]); //배열로 되어있음 / formData는 Map과 같은 형태
	var fileName = formData.get('excelfile').name;
	
	if(confirm("엑셀을 업로드 하시겠습니까?")){
		$.ajax({
			url : "<c:url value='/eval/evaluationCommitteeListUploadExcel' />",
			type : 'POST',
			contentType: false,
			processData: false,  
			data : formData,
			beforeSend:function(){
				$('.wrap-loading').removeClass('display-none');
			},
			success: function(){
				alert("엑셀 업로드를 완료하였습니다.");
				$('.wrap-loading').addClass('display-none');
				location.reload();
				//$("#gridList").data("kendoGrid").dataSource.read();
			},
			error:function(request,status,error){
				alert("엑셀 업로드에 실패하였습니다. 샘플을 확인후 다시 진행해주세요")
				console.log("code = "+ request.status + " message = " + request.responseText + " error = " + error); // 실패 시 처리
				location.reload();
				//$("#gridList").data("kendoGrid").dataSource.read();
			}
		});
	}
}

</script>