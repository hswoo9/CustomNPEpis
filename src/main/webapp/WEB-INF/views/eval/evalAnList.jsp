<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>

<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>

<%-- <jsp:include page="../commcode/cmmJunctionCodePop.jsp" flush="false" /> --%>

<script type="text/javascript" src='<c:url value="/js/resalphag20/resAlphaG20.js"></c:url>'></script>

<style>
.com_ta table th {text-align: center; padding-right : 0px;}
</style>

<div class="iframe_wrap" style="min-width:1100px">

	<div class="sub_title_wrap">
		
		<div class="title_div">
			<h4>평가 완료 목록</h4>
		</div>
	</div>

	<div class="sub_contents_wrap" style="min-width:1100px; min-height: 0px;">
		<p class="tit_p mt5 mt20">평가 완료 목록</p>
		
		<div class="com_ta">
			<div class="top_box gray_box">
				<table>
					<tr>
						<th style="width: 100px;">사업명</th>		
						<td>
							<input type="text" id="search1" style="width: 150px;"> 
						</td>			
						<th style="width: 100px;">평가위원</th>		
						<td>
							<input type="text" id="search2" style="width: 150px;"> 
						</td>			
						<td>
							<div class="controll_btn p0">
								<button type="button" id="search" onclick="gridSearchBtn();">조회</button>
							</div>
						</td>		
					</tr>				
				</table>
			</div>
		</div>
		
	</div>
	
	<div class="sub_contents_wrap" style="min-width:1100px; min-height: 0px;">
		<p class="tit_p mt5 mt20">결의서 신청</p>
		
		<div class="com_ta">
			<div class="top_box gray_box">
				<table>
					<tr>
						<th style="width: 100px;">
						<img src="../Images/ico/ico_check01.png" alt="checkIcon">프로젝트</th>		
						<td>
							<input type="text" id="erpMgtName" readonly="readonly" style="width: 150px;"> 
							<input type="hidden" id="erpMgtCode">
							<input type="button" id="" value="검색" onclick="getProject();">
						</td>			
						<th style="width: 100px;">
						<img src="../Images/ico/ico_check01.png" alt="checkIcon">예산과목</th>		
						<td>
							<input type="text" id="erpBudgetName" class="budgetInput" readonly="readonly" style="width: 150px;"> 
							<input type="hidden" id="erpBudgetCode" class="budgetInput">
							<input type="hidden" id="BGT01_CD" class="budgetInput">
							<input type="hidden" id="BGT01_NM" class="budgetInput">
							<input type="hidden" id="BGT02_CD" class="budgetInput">
							<input type="hidden" id="BGT02_NM" class="budgetInput">
							<input type="hidden" id="BGT03_CD" class="budgetInput">
							<input type="hidden" id="BGT03_NM" class="budgetInput">
							
							<input type="button" id="" value="검색" onclick="getBudget();">
						</td>			
						<th style="width: 100px;">
						<img src="../Images/ico/ico_check01.png" alt="checkIcon">발의일자</th>		
						<td>
							<input type="text" id="resDate" style="width: 150px;"> 
						</td>	
						<th style="width: 100px;">
						<img src="../Images/ico/ico_check01.png" alt="checkIcon">적요</th>		
						<td>
							<input type="text" id="resNote" style="width: 250px;"> 
						</td>			
						<td>
							<div class="controll_btn p0">
								<button type="button" onclick="evalAnBtn();">결의서 신청</button>
							</div>
						</td>		
					</tr>				
				</table>
			</div>
		</div>
		
		<div class="com_ta2 mt15">
		    <div id="gridList"></div>
		</div>
		
	</div>
</div>

<form id="sendForm" name="sendFormPop" method="post">
	<input type="hidden" name="param" value="" id="param"/>
	<input type="hidden" name="data" value="" id="data"/>
</form>

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
            url: "<c:url value='/eval/evalAnListSearch' />",
            dataType: "json",
            type: "post"
        },
      	parameterMap: function(data, operation) {
      		data.search1 = $('#search1').val();
      		data.search2 = $('#search2').val();
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
	
	$("#gridList").kendoGrid({
	    dataSource: gridDataSource,
	    height: 500,
	    sortable: false,
	    pageable: pageInfo,
	    selectable: "row",
	    columns: [
       	{
   			width: "80px;",		
       		template: function(row){
       			if(row.EVAL_AN_STATUS == null || row.EVAL_AN_STATUS == 100 || row.EVAL_AN_STATUS == 999){
	       			return '<input type="checkbox" class="item_checkbox" style="visibility: hidden;" id="item_'+row.commissioner_seq+'"><label for="item_'+row.commissioner_seq+'"></label>';
       			}else{
       				return '';
       			}
       		},
	       	headerTemplate: function(){
				return '<input type="checkbox" style="visibility: hidden;" id="item_all"><label for="item_all"></label>';
	        },
       	},{
    		field: "eval_doc_num",
	        title: "접수번호",
	        width: "200px;",
    	},{
    		field: "eval_an_status_txt",
	        title: "결재상태",
	        width: "100px;",
    	},{
    		field: "req_dept_name",
	        title: "요구부서",
	        width: "200px;",
    	},{
    		field: "title",
	        title: "사업명",
	        width: "200px;",
    	},{
    		field: "name",
	        title: "평가위원",
	        width: "100px;",
    	},{
    		field: "eval_pay",
	        title: "평가수당",
	        width: "100px;",
    	},{
    		field: "trans_pay",
	        title: "교통비",
	        width: "100px;",
    	},{
    		field: "eval_s_date",
    		template: evalDate,
	        title: "평가일시",
	        width: "100px;",
	    }],
	}).data("kendoGrid");
	
	$('#item_all').on('click', function(e){
		if($(this).prop('checked')){
			$('.item_checkbox').prop('checked', true);
		}else{
			$('.item_checkbox').prop('checked', false);
		}
	});
	
	$('#resDate').kendoDatePicker({
	    culture : "ko-KR",
	    format : "yyyy-MM-dd",
	    value : new Date(),
	}).data("kendoDatePicker");
	
	$("#resDate").attr("readonly", true);
	
// 	getGisu();
	
});

var gisuInfo;
function getGisu(){
	
	var data = {
			 CO_CD : '5000',
			 GISU_DT : moment().format('YYYYMMDD'),
	}

	$.ajax({
		url: "<c:url value='/Ac/G20/State/getErpGisuInfo.do' />",
		data : data,
		type : 'POST',
		success: function(result){
			gisuInfo = result.gisuInfo;
		},
	});
	
}

function evalDate(row){
	return moment(row.eval_s_date).format('YYYY-MM-DD');
}

function evalAnBtn(){
	
	var array = new Array();
	
	if( $('#erpMgtCode').val().length == 0
			|| $('#erpBudgetCode').val().length == 0
			|| $('#resDate').val().length == 0
			|| $('#resNote').val().length == 0 ){
		
		alert('결의서 작성값은 필수 입니다.');
		return
	}
	
	$.each($("#gridList tbody input[type=checkbox]"), function(i, v){

		if($(v).prop('checked')){
			
			var tr = $(v).closest('tr');
			var gData = $('#gridList').data("kendoGrid").dataItem(tr);
			
			array.push(gData.commissioner_seq);
				
		}
		
	});
	
	if(array.length == 0){
		alert('평가위원을 선택해 주세요.');
		return
	}
	
	var setData = {
			erp_mgt_name : $('#erpMgtName').val(),
			erp_mgt_code : $('#erpMgtCode').val(),
			erp_budget_name : $('#erpBudgetName').val(),
			erp_budget_code : $('#erpBudgetCode').val(),
			res_date : $('#resDate').val(),
			res_note : $('#resNote').val(),

			BGT01_CD : $('#BGT01_CD').val(),
			BGT01_NM : $('#BGT01_NM').val(),
			BGT02_CD : $('#BGT02_CD').val(),
			BGT02_NM : $('#BGT02_NM').val(),
			BGT03_CD : $('#BGT03_CD').val(),
			BGT03_NM : $('#BGT03_NM').val(),
			
			commissioner_seq : array.join(),
	}
	
	$.ajax({
		url: "<c:url value='/eval/evalAnTempSave' />",
		data : setData,
		type : 'POST',
		async : false,
		success: function(result){
			
			if(result.code == 'success'){
			 	resAlphaG20.openResPop("eval_an", result.eval_an_no, "");
			}else{
				
				var txt = '';
				$.each(result.errorList, function(i, v){
					txt += v.name + '\n';
				});
					txt += 'erp 데이터가 없습니다.\n제무관리실에 등록요청 하시기 바랍니다.';				
				alert(txt);
			}
		},
	});
	
}

function getProject(){
	fnCommonCodePop('project', '', 'projectCallback');	
}

function projectCallback(e){
	$('#erpMgtCode').val(e.erpMgtSeq);	
	$('#erpMgtName').val(e.erpMgtName);	
	$('.budgetInput').val('');
}

function getBudget(){
	
	if($('#erpMgtCode').val() == ''){
		alert('프로젝트를 선택해 주세요.');
		return
	}{
		var data = {
				code : 'budgetlist',
				erpDivSeq : '${erpDivSeq.DIV_CD}|', /* 회계통제단위 구분값 '|' */
				
				erpGisu : '${gisuInfo.GI_SU}', /* ERP 기수 */
				gisu : '${gisuInfo.GI_SU}', /* ERP 기수 */
				
				erpGisuFromDate : '${gisuInfo.FROM_DT}', /* 기수 시작일 */
				frDate : '${gisuInfo.FROM_DT}', /* 기수 시작일 */
	
				erpGisuToDate : '${gisuInfo.TO_DT}', /* 기수 종료일 */
				toDate : '${gisuInfo.TO_DT}', /* 기수 종료일 */
	
				erpMgtSeq : $('#erpMgtCode').val() + '|', /* 예산통제단위 구분값 '|' */
				opt01 : '2',  /* 1: 모든 예산과목, 2: 당기편성, 3: 프로젝트 기간 예산 */
				opt02 : '1', /* 1: 모두표시, 2: 사용기한결과분 숨김 */
				opt03 : '2', /* 1: 예산그룹 전체, 2: 예산그룹 숨김 */
				grFg : '2', /*지출*/
		}
		
		fnCommonCodePop('budgetlist', data, 'budgetCallback');
	}
}

function budgetCallback(e){
	$('#erpBudgetCode').val(e.BGT_CD);	
	$('#erpBudgetName').val(e.BGT_NM);	
	$('#BGT01_CD').val(e.BGT01_CD);	
	$('#BGT01_NM').val(e.BGT01_NM);	
	$('#BGT02_CD').val(e.BGT02_CD);	
	$('#BGT02_NM').val(e.BGT02_NM);	
	$('#BGT03_CD').val(e.BGT03_CD);	
	$('#BGT03_NM').val(e.BGT03_NM);	
}

/* ## 공통코드 - 팝업호출 ## */
function fnCommonCodePop(code, obj, callback, data) {
	/* [ parameter ] */
	/*   - obj : 전송할 파라미터 */
	obj = (obj || {});
	/*   - callback : 코백 호출할 함수 명 */
	callback = (callback || '');
	/*   - data : 더미 */
	data = (data || {});

	/* 팝업 호출 */
	obj.widthSize = code === 'project' ? 993 : 780; // dj 커스텀
	obj.heightSize = 582;

	fnCallCommonCodePop({
		code : code,
		popupType : 2,
		param : JSON.stringify(obj),
		callbackFunction : callback,
		dummy : JSON.stringify(data)
	});
}

function gridSearchBtn(){
	$("#gridList").data("kendoGrid").dataSource.page(1);	
}
</script>




<script>
	/* 공통코드 url 설정 */
	var url = "/custExp/expend/np/user/NpCommonCodePop.do";
	var popupWidth = 600;
	var popupHeight = 400;
	var basicPopupType = "";
	/* 공통 팝업 호출 */
	function fnCallCommonCodePop(param, data){
		if(param.code != undefined){
			param.code = param.code.toLowerCase();	
		}
		data = (data || []);
		fnDirectSearchCommonCode(param, data);
	}
	
	/* 기본 팝업 오픈 */
	function fnOpenCommonCodeBasicPop (params, data){
		$("#param").val(JSON.stringify(params));
		$("#data").val(JSON.stringify(data));
		if(data.length == 1){
			/* 윈도우 팝업 콜백 */
			data[0].code = params.code;
			data[0].dummy = params.dummy;
    		var callbackFunc = window[params.callbackFunction];
    		if( typeof(callbackFunc) == "function" ){
    			callbackFunc(data[0]);
    		}else{
    			alert("콜백함수를 정의하여 주세요.");
    		}
		}else {
			var winHeight = document.body.clientHeight; // 현재창의 높이
			var winWidth = document.body.clientWidth; // 현재창의 너비
			var winX = window.screenX || window.screenLeft || 0;// 현재창의 x좌표
			var winY = window.screenY || window.screenTop || 0; // 현재창의 y좌표 
	
			var popX = winX + (winWidth - popupWidth)/2;
			var popY = winY + (winHeight - popupHeight)/2;
			
			var pop = window.open('', "UserCommonCodePop", "width=" + JSON.parse(params.param).widthSize + ", height=" + JSON.parse(params.param).heightSize + ", left=" + popX + ", top=" + popY);
	
			sendForm.target = "UserCommonCodePop";
			sendForm.method = "post";
			sendForm.action = url;
			sendForm.submit();
			sendForm.target = "";
			if(pop != null){
				if(pop.focus){
					pop.focus();
				}else{
					alert('팝업 차단 설정을 확인 하세요.');
				}
			}
		}
	}
	/* 레이어 팝업 오픈 */
	function fnOpenCommonCodeLayerPop (params, data){
		$("#param").val(JSON.stringify(params));
		$("#data").val(JSON.stringify(data));
		var title = '공통코드!';
		var parentId = '';
		var childrenId = '';
		/* 파라미터 설정 */
		var tempParam = [];
		var ajaxParam = {};
		tempParam["param"] = params;
		tempParam["data"] = data;
		ajaxParam.param = JSON.stringify(tempParam["param"]);
		ajaxParam.data = JSON.stringify(tempParam["data"]);
		$.ajax({
    		type:"post",
    		url: url,
    		datatype:"json",
    		data: ajaxParam, 
    		success:function(data){
    			var $parent;		//modal과 레이어가 들어갈 div 
    			var $children;		//레이어 div
    			
    			// 윈도우팝업에서 레이어팝업 띄울 경우
    			$("body").css("overflow", "hidden");
    			
    			if ($(".pop_wrap").size() > 0) {
    				$parent = $(".pop_wrap");
    	    	}
    	    	if ($(".pop_wrap_dir").size() > 0) {
    	    		$parent = $(".pop_wrap_dir");
    	    	}
    	    	$parent.append('<div id="modal" class="modal"></div>');
    	    	$parent.append(data)
    	    	$children = $(".pop_wrap");
    			childrenId = "";
    			
    			if (popupWidth != "") {
    				$children.css("width", "650");
    			}
    			if (popupHeight != "") {
    				$children.css("height", "450");
    			}
    			$children.css("border", "1px solid #adadad");
    			$children.css("z-index", "102");
    			
    			var popWid = $children.outerWidth();
    			var popHei = $children.outerHeight();
    			$children.css("top","50%").css("left","50%").css("marginLeft",-popWid/2).css("marginTop",-popHei/2);
    			$(window).resize(function(){
    				$children.css("top","50%").css("left","50%").css("marginLeft",-popWid/2).css("marginTop",-popHei/2);
    			});
    		}, error : function(data){
    		}
		});
	}
	
	/* 공통코드 호출 */
	function fnDirectSearchCommonCode(params, paramData){
		var tempParam = [];
		var ajaxParam = {};
		basicPopupType = params.popupType;
		tempParam["param"] = params;
		tempParam["param"].popupType = "1";
		tempParam["data"] = paramData;
		ajaxParam.param = JSON.stringify(tempParam["param"]);
		ajaxParam.data = JSON.stringify(tempParam["data"]);
		/* 공통코드 호출 */
		$.ajax({
	        type : 'post',
	        url : url,
	        datatype : 'json',
	        async : true,
	        data : ajaxParam,
	        success : function( data ) {
	        	
	        	if(!!(JSON.parse(params.param).selectedBudgetSeqs)){
	        		var newAaData = [];
	        		for(var i = 0; i < data.result.aaData.length; i++ ){
	        			var item = data.result.aaData[i];
	        			if( (JSON.parse(params.param).selectedBudgetSeqs.indexOf('|' + (item.erpBudgetSeq || item.BGT_CD) + '|') == -1) ){
	        				newAaData.push(item);
	        			}
	        		}
	        		data.result.aaData = newAaData;
	        	}
	        	
	        	if( data != null && data.result != null && data.result.aaData != null && data.result.aaData.length == 1){
	        		fnDirectSearchCallback(params, data);
	        	}else{
	        		params.popupType = basicPopupType;
		        	switch(params.popupType.toString()){
						case "1" :
							/* 공통코드 바로 조회 콜백 */
							fnDirectSearchCallback(params, data.result.aaData);
							break;
						case "2" :
							/* 일반팝업 호출 */
							fnOpenCommonCodeBasicPop(params, data.result.aaData);
							break;
						case "3" :
							/* 레이어팝업 호출 */
							fnOpenCommonCodeLayerPop(params, data.result.aaData);
							break;
						default :
							console.log("코드 조회 방식 미설정");
							break;
					}
	        	}
	        },
	        error : function( data ) {
	            console.log('오류다!확인해봐!이상해~!!악!');
	        }
	    });
	}
	
	/* 공통코드 직접 호출 후 콜백 처리 */
	function fnDirectSearchCallback( params, data ){
		/* 콜백 함수 호출 */
		var returnData = data.result.aaData[0];
		returnData.code = params.code; 
		returnData.dummy = params.dummy;
		var callbackFunc = window[params.callbackFunction];
		
		if(params.code == "card") {
			var cardData = new Array();
			cardData.push(data.result.aaData[0].cardCode + "|" + data.result.aaData[0].cardName);
			returnData = cardData;
		}
		
		if( typeof(callbackFunc) == "function" ){
			callbackFunc(returnData);
		}else{
			alert("콜백함수를 정의하여 주세요.");
		}
	}
	
	/* 레이어 팝업 닫는 함수 */
	function fnCloseLayerPop(){
		$(".pop_wrap").remove();
		$("#modal").hide();
		$("body").css("overflow", "auto");
	}
</script>

