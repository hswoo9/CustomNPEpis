<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<jsp:useBean id="nowDate" class="java.util.Date" />
<fmt:formatDate value="${nowDate}" var="nowDate" pattern="yyyy-" />

<script type="text/javascript" src='<c:url value="/js/ac/acUtil.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/common/outProcessUtil.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/resalphag20/resAlphaG20.js"></c:url>'></script>

<style type="text/css">
.k-header .k-link {
	text-align: center;
}

.k-grid-content>table>tbody>tr {
	text-align: center;
}

.k-grid th.k-header, .k-grid-header {
	background: #F0F6FD;
}

.k-grid tbody tr {
	cursor: default;
}

.left_div .controll_btn #tableTab{border: 1px solid #eaeaea;width: 160px;border-bottom-width: 0px;cursor: pointer;}
.left_div .controll_btn #tableTab .selTab{background: #e6f4ff;}

.blueColor { color : blue; }
</style>

<script type="text/javascript">
	var url = _g_contextPath_ + '/Ac/G20/Ex/purcBiddingData.do';
	var reqState;
	var type = '${params.type}';
	$(document).ready(function() {
		topBoxInit();
		mainGrid();
		var grid = $('#grid').data('kendoGrid');
		eventHandler();
	});
	
	function eventHandler(){
		$(document).on("mouseover", ".docTitle", function() {
			$(this).removeClass("blueColor").addClass("onFont");
		});
		
		$(document).on("mouseout", ".docTitle", function() {
			$(this).removeClass("onFont").addClass("blueColor");
		});
	}
	
	function topBoxInit(){
		var params = {};
		params.purcReqId = $("#purcReqId").val();
		params.purcReqType;
	    var opt = {
	    		url     : _g_contextPath_ + "/Ac/G20/Ex/getPurcReq.do",
	            async   : false,
	            data    : params,
	            successFn : function(data){
	            	console.log(data.purcReqInfo);
	            	$("#txtPurcReqType").val(data.purcReqInfo.purcReqType).attr("code", data.purcReqInfo.purcReqTypeCodeId);
	            	$("#txtContTitle").val(data.purcReqInfo.purcReqTitle);
	            	$("#txtPurpose").val(data.purcReqInfo.purcPurpose);
	            	var purcReqDate = "";
					if(data.purcReqInfo.purcReqDate){
						purcReqDate = "계약일로 부터 " + data.purcReqDate + "일 까지";
					}else if(data.purcReqInfo.term){
						var tempDate = moment(data.purcReqInfo.contDate).add(data.purcReqInfo.term, "d").format("YYYY-MM-DD");
						if(!data.contDate){
							tempDate = moment(data.purcReqInfo.regDate).add(data.purcReqInfo.term, "d").format("YYYY-MM-DD");
						}else{
						}
						purcReqDate = "계약일로 부터 " + tempDate + "일 까지";
					}
	            	$("#txtContDate").val(purcReqDate);
	            	if(data.purcReqInfo.contAm){
		            	$("#txtContAm").val(data.purcReqInfo.contAm.toString().toMoney());
	            	}
	            	$('.controll_btn button').hide()
	            	$('#btnBiddingStop').show();
	            	if(data.purcReqInfo.reqState === '100'){
	            		$('#btnBeforePop').show();
	            	}else if(data.purcReqInfo.reqState === '119'){
	            		$('#btnBiddingPop').show();
	            	}else if(data.purcReqInfo.reqState === '129'){
	            		$('#btnEvaluationPop').show();
	            		$('#btnBiddingCancelPop').show();
	            	}else if(data.purcReqInfo.reqState === '130'){
	            		$('#btnReBiddingPop').show();
	            		$('#btnBiddingReCancelPop').show();
	            	}else if(data.purcReqInfo.reqState === '139'){
	            		$('#btnEvaluationPop').show();
	            		$('#btnBiddingCancelPop2').show();
	            	}else if(data.purcReqInfo.reqState === '140'){
	            		$('#btnEvaluationModPop').show();
	            		$('#btnEvaluationApprovalPop').show();
	            		if(data.purcReqInfo.biddingType === '120'){
	            			$('#btnBiddingCancelPop').show();
	            		}else if(data.purcReqInfo.biddingType === '130'){
	            			$('#btnBiddingCancelPop2').show();
	            		}
	            	}else if(data.purcReqInfo.reqState === '141'){
	            		$('#btnEvaluationCancelPop').show();
	            		$('#btnBiddingStop').hide();
	            	}else if(data.purcReqInfo.reqState > '141' && data.purcReqInfo.reqState < '150'){
	            		$('#btnBiddingStop').hide();
	            	}else if(data.purcReqInfo.reqState === '150'){
	            		$('#btnEvaluationPop2').show();
	            		$('#btnBiddingReCancelPop2').show();
	            	}else if(data.purcReqInfo.reqState === '150-1'){
	            		$('#btnEvaluationModPop2').show();
	            		$('#btnEvaluationApprovalPop2').show();
	            	}else if(data.purcReqInfo.reqState === '151'){
	            		$('#btnEvaluationCancelPop2').show();
	            		$('#btnBiddingStop').hide();
	            	}else if(data.purcReqInfo.reqState === '169'){
	            		$('#btnNegoApproval').show();
// 	            		$('#btnNegoReturn').show();
	            		$('#btnBiddingStop').hide();
	            	}else if(data.purcReqInfo.reqState === '170'){
	            		$('#btnConsultationPop').show();
	            	}else if(data.purcReqInfo.reqState > '151' && data.purcReqInfo.reqState < '160'){
	            		$('#btnBiddingStop').hide();
	            	}else if(data.purcReqInfo.reqState >= '160' && data.purcReqInfo.reqState < '199'){
	            		$('#btnBiddingStop').hide();
	            	}else if(data.purcReqInfo.reqState === '199'){
	            		$('#btnBiddingStop').hide();
	            		$('#btnBiddingStopCancel').show();
	            	}
	            	var codeList = getCommCodeList('PURC_REQ_STATE');
	            	var code = codeList.filter(function(obj){return obj.code == data.purcReqInfo.reqState;})[0];
	            	if(code){
		            	$('#txtReqState').val(code.code_kr);
	            	}
	            	reqState = data.purcReqInfo.reqState;
	            }
	    };
	    acUtil.ajax.call(opt);
	    if(type === 'view'){
	    	$('.right_div .controll_btn button').hide();
	    }
	}
	
	var dataSource = new kendo.data.DataSource({
		serverPaging: true,
		pageSize: 10,
		transport: {
			read: {
				type: 'post',
				dataType: 'json',
				url: url
			},
			parameterMap: function(data, operation) {
	   	    	data.purcReqId = $("#purcReqId").val();
	   	    	return data ;
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
	
	//검색버튼 이벤트
	function searchBtn() {
		//메인그리드 reload 호출
		gridReLoad();
	}
	
	//메인그리드 reload
	function gridReLoad() {
		topBoxInit();
		$('#grid').data('kendoGrid').dataSource.page(1);
		setTimeout(function(){console.log($('#grid').data("kendoGrid")._data);},1);
	}

	 //메인그리드
	function mainGrid() {
		
		//캔도 그리드 기본
		var grid = $("#grid").kendoGrid({
			dataSource : dataSource,
			height : 500,
			sortable : true,
			pageable : {
				refresh : true,
				pageSizes : true,
				buttonCount : 5
			},
			persistSelection : true,
			dataBound: function(e) {
				var gridData = $('#grid').data("kendoGrid")._data;
				$.each(gridData, function(){
					if(this.inspState == "002"){
						$('#grid .k-grid-content tr[data-uid='+this.uid+']').addClass('text_red');
					}
				});
			},
			resizable: true,
			columns : [
						{
							field : "bidding_type_nm",
							title : "종류",
							width : 150,
						},{
							field : "c_diwriteday",
							title : "등록일자",
							width : 150,
							template : function(data){
								return data.c_diwriteday.toDate();
							},
						},{
							field : "title",
							title : "공고명",
							template : function(data){
								if(data.appr_status === '160'){
									return '<a href="javascript:fnNegoApproval2(\''+data.appr_dikey+'\');" style="color: rgb(0, 51, 255);">' + data.title + '</a>';
								}else{
									return '<a href="javascript:fnDocPopOpen(\''+data.appr_dikey+'\');" style="color: rgb(0, 51, 255);">' + data.title + '</a>';
								}
							},
							attributes : {
								style : "text-align: left;text-indent: 5px;"
							},
						},{
							field : "budget_am",
							title : "사업예산",
							template : function(data){
								return data.budget_am.toString().toMoney();
							},
							width : 200,
						},{
							field : "c_ridocfullnum",
							title : "문서번호",
							template : function(data){
								if(data.appr_status === '160'){
									return '<a href="javascript:fnNegoApproval2(\''+data.appr_dikey+'\');" style="color: rgb(0, 51, 255);">' + (data.c_ridocfullnum || '') + '</a>';
								}else{
									return '<a href="javascript:fnDocPopOpen(\''+data.appr_dikey+'\');" style="color: rgb(0, 51, 255);">' + (data.c_ridocfullnum || '') + '</a>';
								}
							},
							width : 150,
						},{
							field : "c_distatus_nm",
							title : "결재상태",
							width : 150,
						}],
						change: function (e) {
				        	gridClick(e);
				        }
					}).data("kendoGrid");
		
		grid.table.on("click", "tr", selectRow);
		
		var checkedIds = {};
		
		function selectRow(){
			return;
			if($(this).hasClass("k-state-selected"))return;
			$('tr', $('#grid')).removeClass("k-state-selected");
			$(this).addClass("k-state-selected");
		}
		
		//mainGrid 클릭이벤트
		function gridClick(){
			var rows = grid.select();
			var record;
		    rows.each(function () {
		        record = grid.dataItem($(this));
		    });
	   }
	}
	 
	var openDialog = function(uri, name, options, closeCallback) {
	    var win = window.open(uri, name, options);
	    var interval = window.setInterval(function() {
	        try {
	            if (win == null || win.closed) {
	                window.clearInterval(interval);
	                closeCallback(win);
	            }
	        }
	        catch (e) {
	        }
	    }, 1000);
	    return win;
	};
	
	function fnDocPopOpen(docId){
		var params = {};
	    params.compSeq =$('#compSeq').val();
	    params.empSeq = $('#empSeq').val();
	    params.docId = docId;
	    params.mod = 'V';
	    outProcessLogOn(params);
	}
	
	function fnBeforePop(){
		if(fnBiddingApprovalCheck() > 0){
			return;
		}
		var url = _g_contextPath_ + '/Ac/G20/Ex/purcBiddingBeforePop.do?focus=txt_BUDGET_LIST&purcReqId=' + $('#purcReqId').val() + '&purcReqType=' + $('#txtPurcReqType').attr('code') + '&form_id=55';
		var pop = "" ;
		var width = "1000";
		var height = "950";
		windowX = Math.ceil( (window.screen.width  - width) / 2 );
		windowY = Math.ceil( (window.screen.height - height) / 2 );
		var strResize = 0 ;
		var popupName = "사전규격공고";
		var options = "width=" + width + ", height=" + height + ", top="+ windowY +", left="+ windowX +", scrollbars=YES, resizable=YES";
		openDialog(url, popupName, options, function(win) {
			gridReLoad();
		});
	}
	
	function fnBiddingPop(){
		if(fnBiddingApprovalCheck() > 0){
			return;
		}
		var url = _g_contextPath_ + '/Ac/G20/Ex/purcBiddingPop.do?focus=txt_BUDGET_LIST&purcReqId=' + $('#purcReqId').val() + '&purcReqType=' + $('#txtPurcReqType').attr('code') + '&form_id=55';
		var pop = "" ;
		var width = "1000";
		var height = "950";
		windowX = Math.ceil( (window.screen.width  - width) / 2 );
		windowY = Math.ceil( (window.screen.height - height) / 2 );
		var strResize = 0 ;
		var popupName = "입찰공고";
		var options = "width=" + width + ", height=" + height + ", top="+ windowY +", left="+ windowX +", scrollbars=YES, resizable=YES";
		openDialog(url, popupName, options, function(win) {
			gridReLoad();
		});
	}
	
	function fnReBiddingPop(){
		if(fnBiddingApprovalCheck() > 0){
			return;
		}
		var url = _g_contextPath_ + '/Ac/G20/Ex/purcBiddingReBiddingPop.do?focus=txt_BUDGET_LIST&purcReqId=' + $('#purcReqId').val() + '&purcReqType=' + $('#txtPurcReqType').attr('code') + '&form_id=55';
		var pop = "" ;
		var width = "1000";
		var height = "950";
		windowX = Math.ceil( (window.screen.width  - width) / 2 );
		windowY = Math.ceil( (window.screen.height - height) / 2 );
		var strResize = 0 ;
		var popupName = "재입찰공고";
		var options = "width=" + width + ", height=" + height + ", top="+ windowY +", left="+ windowX +", scrollbars=YES, resizable=YES";
		openDialog(url, popupName, options, function(win) {
			gridReLoad();
		});
	}
	
	function fnEvaluationPop(type){
		if(fnBiddingApprovalCheck() > 0){
			return;
		}
		var url = _g_contextPath_ + '/Ac/G20/Ex/purcBiddingEvaluationPop.do?focus=txt_BUDGET_LIST&purcReqId=' + $('#purcReqId').val() + '&purcReqType=' + $('#txtPurcReqType').attr('code') + '&form_id=55&evalType=140&type=' + type;
		var pop = "" ;
		var width = "1200";
		var height = "600";
		windowX = Math.ceil( (window.screen.width  - width) / 2 );
		windowY = Math.ceil( (window.screen.height - height) / 2 );
		var strResize = 0 ;
		var popupName = "제안평가 업체등록";
		var options = "width=" + width + ", height=" + height + ", top="+ windowY +", left="+ windowX +", scrollbars=YES, resizable=YES";
		openDialog(url, popupName, options, function(win) {
			gridReLoad();
		});
	}
	
	function fnEvaluationApprovalPop(){
		if(fnBiddingApprovalCheck() > 0){
			return;
		}
		if(confirm('제안평가업체를 확정합니다.')){
			var params = {purcReqId : $('#purcReqId').val(), reqState : '141', evalType : '140'};
		    var opt = {
		    		url     : _g_contextPath_ + "/Ac/G20/Ex/updatePurcBiddingState.do",
		            async   : false,
		            data    : params,
		            successFn : function(data){
		            	alert("제안평가업체를 확정했습니다.");
		            	gridReLoad();
		            }
		    };
		    acUtil.ajax.call(opt);
		}
	}
	
	function fnEvaluationCancelPop(){
		if(fnBiddingApprovalCheck() > 0){
			return;
		}
		if(confirm('제안평가업체를 수정합니다.')){
			var params = {purcReqId : $('#purcReqId').val(), reqState : '140', evalType : ''};
		    var opt = {
		    		url     : _g_contextPath_ + "/Ac/G20/Ex/updatePurcBiddingState.do",
		            async   : false,
		            data    : params,
		            successFn : function(data){
		            	gridReLoad();
		            }
		    };
		    acUtil.ajax.call(opt);
		}
	}
	
	function fnEvaluationPop2(type){
		if(fnBiddingApprovalCheck() > 0){
			return;
		}
		var url = _g_contextPath_ + '/Ac/G20/Ex/purcBiddingEvaluationPop.do?focus=txt_BUDGET_LIST&purcReqId=' + $('#purcReqId').val() + '&purcReqType=' + $('#txtPurcReqType').attr('code') + '&form_id=55&evalType=150-1&type=' + type;
		var pop = "" ;
		var width = "1000";
		var height = "600";
		windowX = Math.ceil( (window.screen.width  - width) / 2 );
		windowY = Math.ceil( (window.screen.height - height) / 2 );
		var strResize = 0 ;
		var popupName = "적격평가 업체등록";
		var options = "width=" + width + ", height=" + height + ", top="+ windowY +", left="+ windowX +", scrollbars=YES, resizable=YES";
		openDialog(url, popupName, options, function(win) {
			gridReLoad();
		});
	}
	
	function fnEvaluationApprovalPop2(){
		if(fnBiddingApprovalCheck() > 0){
			return;
		}
		if(confirm('적격평가업체를 확정합니다.')){
			var params = {purcReqId : $('#purcReqId').val(), reqState : '151', evalType : '150'};
		    var opt = {
		    		url     : _g_contextPath_ + "/Ac/G20/Ex/updatePurcBiddingState.do",
		            async   : false,
		            data    : params,
		            successFn : function(data){
		            	alert("적격평가업체를 확정했습니다.");
		            	gridReLoad();
		            }
		    };
		    acUtil.ajax.call(opt);
		}
	}
	
	function fnEvaluationCancelPop2(){
		if(fnBiddingApprovalCheck() > 0){
			return;
		}
		if(confirm('적격평가업체를 수정합니다.')){
			var params = {purcReqId : $('#purcReqId').val(), reqState : '150', evalType : ''};
		    var opt = {
		    		url     : _g_contextPath_ + "/Ac/G20/Ex/updatePurcBiddingState.do",
		            async   : false,
		            data    : params,
		            successFn : function(data){
		            	gridReLoad();
		            }
		    };
		    acUtil.ajax.call(opt);
		}
	}
	
	function fnBiddingCancelPop(){
		if(fnBiddingApprovalCheck() > 0){
			return;
		}
		if(confirm('입찰을 유찰합니다.')){
			var params = {purcReqId : $('#purcReqId').val(), reqState : '130'};
		    var opt = {
		    		url     : _g_contextPath_ + "/Ac/G20/Ex/updatePurcBiddingState.do",
		            async   : false,
		            data    : params,
		            successFn : function(data){
		            	alert("입찰이 유찰되었습니다.");
		            	gridReLoad();
		            }
		    };
		    acUtil.ajax.call(opt);
		}
	}
	
	function fnBiddingCancelPop2(){
		if(fnBiddingApprovalCheck() > 0){
			return;
		}
		if(confirm('재입찰을 유찰합니다.')){
			var params = {purcReqId : $('#purcReqId').val(), reqState : '150'};
		    var opt = {
		    		url     : _g_contextPath_ + "/Ac/G20/Ex/updatePurcBiddingState.do",
		            async   : false,
		            data    : params,
		            successFn : function(data){
		            	alert("재입찰이 유찰되었습니다.");
		            	gridReLoad();
		            }
		    };
		    acUtil.ajax.call(opt);
		}
	}
	
	function fnBiddingReCancelPop(){
		if(fnBiddingApprovalCheck() > 0){
			return;
		}
		if(confirm('유찰을 취소합니다..')){
			var params = {purcReqId : $('#purcReqId').val(), reqState : '129'};
		    var opt = {
		    		url     : _g_contextPath_ + "/Ac/G20/Ex/updatePurcBiddingState.do",
		            async   : false,
		            data    : params,
		            successFn : function(data){
		            	alert("유찰이 취소되었습니다.");
		            	gridReLoad();
		            }
		    };
		    acUtil.ajax.call(opt);
		}
	}
	
	function fnBiddingReCancelPop2(){
		if(fnBiddingApprovalCheck() > 0){
			return;
		}
		if(confirm('유찰을 취소합니다.')){
			var params = {purcReqId : $('#purcReqId').val(), reqState : '139'};
		    var opt = {
		    		url     : _g_contextPath_ + "/Ac/G20/Ex/updatePurcBiddingState.do",
		            async   : false,
		            data    : params,
		            successFn : function(data){
		            	alert("유찰이 취소되었습니다.");
		            	gridReLoad();
		            }
		    };
		    acUtil.ajax.call(opt);
		}
	}
	
	function fnNegoApproval(){
		if(fnBiddingApprovalCheck() > 0){
			return;
		}
		var url = _g_contextPath_ + '/Ac/G20/Ex/purcBiddingNegoRegPop.do?focus=txt_BUDGET_LIST&purcReqId=' + $('#purcReqId').val() + '&type=app';
		var pop = "" ;
		var width = "1000";
		var height = "400";
		windowX = Math.ceil( (window.screen.width  - width) / 2 );
		windowY = Math.ceil( (window.screen.height - height) / 2 );
		var strResize = 0 ;
		var popupName = "기술협상";
		var options = "width=" + width + ", height=" + height + ", top="+ windowY +", left="+ windowX +", scrollbars=YES, resizable=YES";
		openDialog(url, popupName, options, function(win) {
			gridReLoad();
		});
	}
	
	function fnNegoApproval2(){
		if(fnBiddingApprovalCheck() > 0){
			return;
		}
		var url = _g_contextPath_ + '/Ac/G20/Ex/purcBiddingNegoRegPop.do?focus=txt_BUDGET_LIST&purcReqId=' + $('#purcReqId').val() + '&type=view';
		var pop = "" ;
		var width = "1000";
		var height = "400";
		windowX = Math.ceil( (window.screen.width  - width) / 2 );
		windowY = Math.ceil( (window.screen.height - height) / 2 );
		var strResize = 0 ;
		var popupName = "기술협상";
		var options = "width=" + width + ", height=" + height + ", top="+ windowY +", left="+ windowX +", scrollbars=YES, resizable=YES";
		openDialog(url, popupName, options, function(win) {
			gridReLoad();
		});
	}
	
	function fnNegoReturn(){
		if(fnBiddingApprovalCheck() > 0){
			return;
		}
		alert('반려');
	}
	
	function fnConsultationPop(){
		if(fnBiddingApprovalCheck() > 0){
			return;
		}
		var url = _g_contextPath_ + '/Ac/G20/Ex/purcBiddingConsultationPop.do?focus=txt_BUDGET_LIST&purcReqId=' + $('#purcReqId').val() + '&purcReqType=' + $('#txtPurcReqType').attr('code') + '&form_id=55';
		var pop = "" ;
		var width = "1000";
		var height = "950";
		windowX = Math.ceil( (window.screen.width  - width) / 2 );
		windowY = Math.ceil( (window.screen.height - height) / 2 );
		var strResize = 0 ;
		var popupName = "전자시담";
		var options = "width=" + width + ", height=" + height + ", top="+ windowY +", left="+ windowX +", scrollbars=YES, resizable=YES";
		openDialog(url, popupName, options, function(win) {
			gridReLoad();
		});
	}
	
	function fnBiddingStop(){
		if(fnBiddingApprovalCheck() > 0){
			return;
		}
		if(confirm('입찰을 중단합니다.')){
			var params = {purcReqId : $('#purcReqId').val(), reqState : '199'};
		    var opt = {
		    		url     : _g_contextPath_ + "/Ac/G20/Ex/updatePurcBiddingState.do",
		            async   : false,
		            data    : params,
		            successFn : function(data){
		            	alert("입찰이 중단되었습니다.");
		            	gridReLoad();
		            }
		    };
		    acUtil.ajax.call(opt);
		}
	}
	
	function fnBiddingStopCancel(){
		if(fnBiddingApprovalCheck() > 0){
			return;
		}
		if(confirm('입찰을 중단을 취소합니다.')){
			var params = {purcReqId : $('#purcReqId').val(), reqState : 'can'};
		    var opt = {
		    		url     : _g_contextPath_ + "/Ac/G20/Ex/updatePurcBiddingState.do",
		            async   : false,
		            data    : params,
		            successFn : function(data){
		            	alert("입찰중단이 취소되었습니다.");
		            	gridReLoad();
		            }
		    };
		    acUtil.ajax.call(opt);
		}
	}
	
	function fnBiddingApprovalCheck(){
		var docCnt = 0;
		var params = {purcReqId : $('#purcReqId').val()};
		var opt = {
	    		url     : _g_contextPath_ + "/Ac/G20/Ex/checkPurcBiddingApproval.do",
	            async   : false,
	            data    : params,
	            successFn : function(data){
	            	docCnt = data.docCnt;
	            	if(docCnt > 0){
		            	alert('결재중인 문서가 있습니다.');
	            	}
	            	gridReLoad();
	            }
	    };
	    acUtil.ajax.call(opt);
	    return docCnt;
	}
</script>

<!-- iframe wrap -->
<div class="iframe_wrap" style="min-width: 1100px">
	<form id="outProcessFormData" action="http://211.192.144.104/gw/outProcessLogOn.do" target="outProcessLogOn"></form>
	<input type="hidden" id="compSeq" value="${loginVO.compSeq }"/>
	<input type="hidden" id="empSeq" value="${loginVO.uniqId }"/>
	<input type="hidden" id="loginId" value="${loginVO.id }"/>
	<!-- 컨텐츠타이틀영역 -->
	<div class="sub_title_wrap">

		<div class="title_div">
			<h4></h4>
		</div>
		
	</div>

	<div class="sub_contents_wrap">

		<div class="top_box mt10">
			<dl>
				<dt class="ar" style="width: 50px">구분</dt>
				<dd>
					<input type="text" id="txtPurcReqType" class="txtPurcReqType" readonly="readonly" disabled="disabled" style="width: 156px;"/>
					<input type="hidden" id=purcReqId value="${params.purcReqId }"/>
				</dd>
				<dt class="ar" style="width: 50px">상태</dt>
				<dd>
					<input type="text" id="txtReqState" class="" readonly="readonly" disabled="disabled" style="width: 156px;"/>
				</dd>
				<dt class="ar" style="width: 50px">금액</dt>
				<dd>
					<input type="text" id="txtContAm" class="" readonly="readonly" disabled="disabled" style="width: 156px;"/>
				</dd>
			</dl>
			<dl>
				<dt class="ar" style="width: 50px">제목</dt>
				<dd>
					<input type="text" id="txtContTitle" class="" readonly="readonly" disabled="disabled" style="width: 400px;"/>
				</dd>
				<dt class="ar" style="width: 50px">목적</dt>
				<dd>
					<input type="text" id="txtPurpose" class="" readonly="readonly" disabled="disabled" style="width: 400px;"/>
				</dd>
<!-- 				<dt class="ar" style="width: 70px">사업기간</dt> -->
<!-- 				<dd> -->
<!-- 					<input type="text" id="txtContDate" class="" readonly="readonly" disabled="disabled" style="width: 200px;"/> -->
<!-- 				</dd> -->
			</dl>
		</div>

		<!-- 버튼 -->
		<div class="btn_div mt10 cl">
			<div class="left_div">
				<p class="tit_p mt5 mb0">입찰내역</p>
			</div>
			<div class="right_div">
				<div class="controll_btn p0">
					<button type="button" id="btnBeforePop" onclick="fnBeforePop();" style="display: none;">사전규격공고</button>
					<button type="button" id="btnBiddingPop" onclick="fnBiddingPop();" style="display: none;">입찰공고</button>
					<button type="button" id="btnEvaluationPop" onclick="fnEvaluationPop('add');" style="display: none;">제안평가업체등록</button>
					<button type="button" id="btnEvaluationModPop" onclick="fnEvaluationPop('mod');" style="display: none;">제안평가업체등록</button>
					<button type="button" id="btnEvaluationApprovalPop" onclick="fnEvaluationApprovalPop();" style="display: none;">제안평가업체확정</button>
					<button type="button" id="btnEvaluationCancelPop" onclick="fnEvaluationCancelPop();" style="display: none;">제안평가업체수정</button>
					<button type="button" id="btnEvaluationPop2" onclick="fnEvaluationPop2('add');" style="display: none;">적격평가업체등록</button>
					<button type="button" id="btnEvaluationModPop2" onclick="fnEvaluationPop2('mod');" style="display: none;">적격평가업체등록</button>
					<button type="button" id="btnEvaluationApprovalPop2" onclick="fnEvaluationApprovalPop2();" style="display: none;">적격평가업체확정</button>
					<button type="button" id="btnEvaluationCancelPop2" onclick="fnEvaluationCancelPop2();" style="display: none;">적격평가업체수정</button>
					<button type="button" id="btnReBiddingPop" onclick="fnReBiddingPop();" style="display: none;">재입찰공고</button>
					<button type="button" id="btnBiddingCancelPop" onclick="fnBiddingCancelPop();" style="display: none;">유찰</button>
					<button type="button" id="btnBiddingCancelPop2" onclick="fnBiddingCancelPop2();" style="display: none;">유찰</button>
					<button type="button" id="btnBiddingReCancelPop" onclick="fnBiddingReCancelPop();" style="display: none;">유찰취소</button>
					<button type="button" id="btnBiddingReCancelPop2" onclick="fnBiddingReCancelPop2();" style="display: none;">유찰취소</button>
					<button type="button" id="btnNegoApproval" onclick="fnNegoApproval();" style="display: none;">접수</button>
					<button type="button" id="btnNegoReturn" onclick="fnNegoReturn();" style="display: none;">반려</button>
					<button type="button" id="btnConsultationPop" onclick="fnConsultationPop();" style="display: none;">전자시담</button>
					<button type="button" id="btnBiddingStop" onclick="fnBiddingStop();">입찰중단</button>
					<button type="button" id="btnBiddingStopCancel" onclick="fnBiddingStopCancel();" style="display: none;">입찰중단취소</button>
				</div>
			</div>
		</div>
		
		<div class="com_ta2 mt15">
			<div id="grid"></div>
		</div>
		
	</div>
</div>
	<!-- //sub_contents_wrap -->
<!-- iframe wrap -->
