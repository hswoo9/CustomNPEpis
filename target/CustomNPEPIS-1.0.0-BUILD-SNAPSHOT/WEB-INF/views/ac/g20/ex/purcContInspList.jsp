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
</style>

<script type="text/javascript">
	var url = _g_contextPath_ + '/Ac/G20/Ex/purcContInspListData.do';
	
	$(document).ready(function() {
		$(".purcContInspDetail").hide();
		$("#purcContInsp input, #purcContInspT-tablesample input").attr("disabled", true);
		topBoxInit();
		mainGrid();
		var grid = $('#grid').data('kendoGrid');
	});
	
	function topBoxInit(){
		var params = {};
		params.purcContId = $("#purcContId").val();
	    var opt = {
	    		url     : _g_contextPath_ + "/Ac/G20/Ex/inspTopBoxInit.do",
	            async   : false,
	            data    : params,
	            successFn : function(data){
	            	$("#txtPurcReqType").val(data.resultInfo.purcReqType).attr("code", data.resultInfo.purcReqTypeCodeId);
	            	$("#txtPurcReqNo").val(data.resultInfo.purcReqNo);
	            	$("#txtContTitle").val(data.resultInfo.contTitle);
	            	if(data.resultInfo.contStep == "007"){
		            	$("#contInspBtn").hide();
	            	}
	            	$("#txtTrNm").val(data.resultInfo.trNm);
	            	if(data.resultInfo.contDate){
		            	$("#txtContDate").val(data.resultInfo.contDate.toDate());
	            	}
	            	if(data.resultInfo.contAm){
		            	$("#txtContAm").val(data.resultInfo.contAm.toString().toMoney());
	            	}
	            }
	    };
	    acUtil.ajax.call(opt);
	}
	
	var dataSource = new kendo.data.DataSource({
		serverPaging: true,
		pageSize: 5,
		transport: {
			read: {
				type: 'post',
				dataType: 'json',
				url: url
			},
			parameterMap: function(data, operation) {
	   	    	data.purcContId = $("#purcContId").val();
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
		$('#grid').data('kendoGrid').dataSource.page(1);
		setTimeout(function(){console.log($('#grid').data("kendoGrid")._data);},1);
	}

	 //메인그리드
	function mainGrid() {
		
		//캔도 그리드 기본
		var grid = $("#grid").kendoGrid({
			dataSource : dataSource,
			height : 250,
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
			columns : [
						{
							field : "inspOrder",
							title : "검사차수",
						},{
							field : "inspDate",
							title : "검사일자",
						},{
							field : "contAm",
							title : "계약금액",
							template : function(data){
								return data.contAm.toString().toMoney();
							}
						},{
							field : "paymentAm",
							title : "기지급액",
							template : function(data){
								return data.paymentAm.toString().toMoney();
							}
						},{
							field : "applyAm",
							title : "금회지급액",
							template : function(data){
								return data.applyAm.toString().toMoney();
							}
						},{
							field : "leftAm",
							title : "잔액",
							template : function(data){
								var leftAm = data.contAm - data.paymentAm - data.applyAm;
								if(data.inspState == "002"){
									leftAm = data.contAm - data.paymentAm;
								}
								return leftAm.toString().toMoney();
							}
						},{
							field : "",
							title : "기성율(%)",
							template : function(data){
								var rate = Math.round((data.paymentAm + data.applyAm) / data.contAm * 100);
								if(data.inspState == "002"){
									rate = Math.round((data.paymentAm) / data.contAm * 100);
								}
								return rate;
							}
						},{
							field : "contDocNo",
							title : "검수보고 문서보기",
							template : function(data){
								return '<input type="button" id="" class="gray_btn" onclick="fnDocPopOpen(\''+data.cDikeycode+'\');" value="기안문서 보기">';
							}
						},{
							field : "remark",
							title : "비고",
						},{
							field : "inspStateNm",
							title : "결재상태",
						}],
						change: function (e) {
				        	gridClick(e);
				        }
					}).data("kendoGrid");
		
		grid.table.on("click", "tr", selectRow);
		
		var checkedIds = {};
		
		function selectRow(){
			if($(this).hasClass("k-state-selected"))return;
			$('tr', $('#grid')).removeClass("k-state-selected");
			$(this).addClass("k-state-selected");
			$(".purcContInspDetail").show();
			fnSelectRow();
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
	 
	function fnSelectRow(){
		var selRow = $("#grid").data("kendoGrid").dataItem(".k-state-selected");
		var params = {};
		params.purcContInspId = selRow.purcContInspId;
	    var opt = {
	    		url     : _g_contextPath_ + "/Ac/G20/Ex/getContInsp.do",
	            async   : false,
	            data    : params,
	            successFn : function(data){
	            	var contInsp = data.contInsp;
	            	var contInspT1 = data.contInspT1;
	            	var contInspT2 = data.contInspT2;
	            	var contInspAttachFile = data.contInspAttachFile;
	            	fnTpfSetContInsp(contInsp);
	            	fnTpfSetContInspT1(contInspT1);
	            	fnTpfSetContInspT2(contInspT2);
	            	fnTpfSetContInspAttachFile(contInspAttachFile);
	            }
	    };
	    acUtil.ajax.call(opt);
	}
	
	function fnTpfSetContInsp(contInsp){
		$("#purcContInsp input").val("");
		$("#txtPurcReqType").val(contInsp.purcReqType);
		$("#txtPurcReqNo").val(contInsp.purcReqNo);
		$("#txtContTitle").val(contInsp.contTitle);
		
		$("#inspOrder").val(contInsp.inspOrder);
		$("#deliveryFrDate").val(contInsp.contStartDate);
		$("#deliveryToDate").val(contInsp.contEndDate);
		$("#inspPlace").val(contInsp.inspPlace);
		$("#remark").val(contInsp.remark);
		$("#trNm").val(contInsp.trNm);
		
		$("#inspOpinion1").val(contInsp.inspOpinionText1);
		$("#inspOpinion2").val(contInsp.inspOpinionText2);
		$("#inspOpinion3").val(contInsp.inspOpinionText3);
		$("#inspOpinion4").val(contInsp.inspOpinionText4);
		$("#inspOpinion5").val(contInsp.inspOpinionText5);
		
		$("#inspDate").val(contInsp.inspDate);
		$("#deliveryDate").val(contInsp.deliveryDate);
		
		if(contInsp.purcReqTypeCodeId == "3" || contInsp.purcReqTypeCodeId == "4"){
			$("#trOpRow2").hide();
			$(".op3").hide();
			$(".optxt2").html("과업지시서와 내용은 일치 하는가?");
			$("#trOpRow1").append($(".op5"));
		}
		if(contInsp.purcReqTypeCodeId == "3"){
			$(".optxt2").html("공사 내역서 및 시방서와 내용은 일치 하는가?");
			$("#thContNm").html("공사명");
			$("#thContContents").html("공사내용");
		}
	}
	
	function fnTpfSetContInspT1(contInspT){
		if(contInspT.length > 0){
			$("#purcContInspT1").show();
		}else{
			$("#purcContInspT1").hide();
		}
		$("#purcContInspT1 tbody tr").remove();
		$.each(contInspT, function(){
			var tr = $("#purcContInspT1-tablesample tr").clone();
			tr.attr("id", this.purcContInspTId);
			$(".contItemNm", tr).val(this.contItemNm);
			$(".contContents", tr).val(this.contContents);
			$(".contUnitAm", tr).val(this.contUnitAm.toString().toMoney());
			$(".contSupAm", tr).val(this.contSupAm.toString().toMoney());
			$(".contVatAm", tr).val(this.contVatAm.toString().toMoney());
			$(".unitAm", tr).val(this.unitAm.toString().toMoney()).attr("orgAm", this.orgAm.toString().toMoney());
			$(".supAm", tr).val(this.supAm.toString().toMoney());
			$(".vatAm", tr).val(this.vatAm.toString().toMoney());
			
			$("#purcContInspT1 tbody").append(tr);
		});
	}

	function fnTpfSetContInspT2(contInspT){
		if(contInspT.length > 0){
			$("#purcContInspT2").show();
		}else{
			$("#purcContInspT2").hide();
		}
		if($("#txtPurcReqType").attr("code") == "2"){
			$(".colspanTh").attr("colspan", 7);
			$(".opHidden").show();
		}else{
			$(".colspanTh").attr("colspan", 6);
			$(".opHidden").hide();
		}
		$("#purcContInspT2 tbody tr").remove();
		$.each(contInspT, function(){
			var tr = $("#purcContInspT2-tablesample tr").clone();
			tr.attr("id", this.purcContInspTId);
			$(".contItemType", tr).val(this.contItemType);
			$(".contItemNm", tr).val(this.contItemNm);
			$(".contItemCnt", tr).val(this.contItemCnt);
			$(".contStandard", tr).val(this.contStandard);
			$(".contItemAm", tr).val(this.contItemAm.toString().toMoney());
			$(".contUnitAm", tr).val(this.contUnitAm.toString().toMoney());
			$(".contSupAm", tr).val(this.contSupAm.toString().toMoney());
			$(".contVatAm", tr).val(this.contVatAm.toString().toMoney());
			if(this.contPpsFees){
				$(".contPpsFees", tr).val(this.contPpsFees.toString().toMoney());
			}
			$(".itemCnt", tr).val(this.itemCnt).attr("orgCnt", this.orgCnt);
			$(".standard", tr).val(this.standard);
			$(".itemAm", tr).val(this.itemAm.toString().toMoney());
			$(".unitAm", tr).val(this.unitAm.toString().toMoney());
			$(".supAm", tr).val(this.supAm.toString().toMoney());
			$(".vatAm", tr).val(this.vatAm.toString().toMoney());
			if(this.ppsFees){
				$(".ppsFees", tr).val(this.ppsFees.toString().toMoney());
			}
			
			$("#purcContInspT2 tbody").append(tr);
		});
	}

	function fnTpfSetContInspAttachFile(attachFileList){
		$("#fileArea span").remove();
		$.each(attachFileList, function(){
			var span = $('#fileSample div').clone();
			$('.file_name', span).html(this.real_file_name + '.' + this.file_extension);
			$('.attachFileId', span).val(this.attach_file_id);
			$('.fileSeq', span).val(this.file_seq);
			$('.filePath', span).val(this.file_path);
			$('.fileNm', span).val(this.real_file_name + '.' + this.file_extension);
			$('#fileArea').append(span);
		});
	}
	 
	function fnDeptChange(){
		var obj = $('#selDept').data('kendoComboBox');
		$('#txtDeptCd').val(obj._old);
		$('#txtDeptName').val(obj._prev);
	}
	
	function fnPurcContInspVal(){
		var result = true;
		var params = {};
		params.purcContId = $("#purcContId").val();
	    var opt = {
	    		url     : _g_contextPath_ + "/Ac/G20/Ex/checkInspComplete.do",
	            async   : false,
	            data    : params,
	            successFn : function(data){
	            	if(data.contStep == "007"){
	            		alert("이미 검수완료된 계약입니다.");
		            	result = false;
		            	return;
	            	}
	            	/* if(data.contInspList.length > 0){
	            		var contInsp = data.contInspList[0];
	            		var rate = Math.round((contInsp.paymentAm + contInsp.applyAm) / contInsp.contAm * 100);
						if(contInsp.inspState == "002"){
							rate = Math.round((contInsp.paymentAm) / contInsp.contAm * 100);
						}
						if(rate >= 100){
							alert("모든 품목이 검수 중 입니다.");
							result = false;
							return;
						}
	            	} */
	            }
	    };
	    acUtil.ajax.call(opt);
	    if(!result){
	    	return result;
	    }
	    return result; 
	}
	
	function fnPurcContInsp(){
		if(!fnPurcContInspVal()){
			return;
		}
		if(confirm("검사/검수를 진행합니다.")){
			var params = {};
			params.purcContId = $("#purcContId").val();
		    var opt = {
		    		url     : _g_contextPath_ + "/Ac/G20/Ex/makeContInspInfo.do",
		            async   : false,
		            data    : params,
		            successFn : function(data){
		            	var purcContInspId = data.result;
						var url = _g_contextPath_ + '/Ac/G20/Ex/purcContInsp.do?purcContInspId='+purcContInspId;
						var pop = "" ;
						var width = "1000";
						var height = "950";
						windowX = Math.ceil( (window.screen.width  - width) / 2 );
						windowY = Math.ceil( (window.screen.height - height) / 2 );
						var strResize = 0 ;
						var popupName = "구매계약검수";
						var options = "width=" + width + ", height=" + height + ", top="+ windowY +", left="+ windowX +", scrollbars=YES, resizable=YES";
						
						openDialog(url, popupName, options, function(win) {
							gridReLoad();
						});
		            }
		    };
		    acUtil.ajax.call(opt);
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
	
	function fnTpfAttachFileDownload(obj){
		var span = $(obj).closest('div');
		var attach_file_id = $('.attachFileId', span).val();
		var downWin = window.open('','_self');
		downWin.location.href = _g_contextPath_ + '/common/fileDown?attach_file_id='+attach_file_id;
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
			<h4>근무계획</h4>
		</div>
	</div>

	<div class="sub_contents_wrap">

		<div class="top_box mt10">
			<dl>
				<dt class="ar" style="width: 50px">구분</dt>
				<dd>
					<input type="text" id="txtPurcReqType" class="txtPurcReqType" readonly="readonly" disabled="disabled" style="width: 170px;"/>
					<input type="hidden" id=purcContId value="${params.purcContId }"/>
				</dd>
<!-- 				<dt class="ar" style="width: 100px">구매의뢰번호</dt> -->
<!-- 				<dd> -->
<!-- 					<input type="text" id="txtPurcReqNo" class="" readonly="readonly" disabled="disabled" style="width: 170px;"/> -->
<!-- 				</dd> -->
				<dt class="ar" style="width: 70px">계약명</dt>
				<dd>
					<input type="text" id="txtContTitle" class="" readonly="readonly" disabled="disabled" style="width: 400px;"/>
				</dd>
			</dl>
			<dl>
				<dt class="ar" style="width: 50px">거래처</dt>
				<dd>
					<input type="text" id="txtTrNm" class="txtTrNm" readonly="readonly" disabled="disabled" style="width: 170px;"/>
				</dd>
				<dt class="ar" style="width: 70px">계약일</dt>
				<dd>
					<input type="text" id="txtContDate" class="" readonly="readonly" disabled="disabled" style="width: 170px;"/>
				</dd>
				<dt class="ar" style="width: 50px">금액</dt>
				<dd>
					<input type="text" id="txtContAm" class="" readonly="readonly" disabled="disabled" style="width: 170px;"/>
				</dd>
			</dl>
		</div>

		<!-- 버튼 -->
		<div class="btn_div mt10 cl">
			<div class="left_div">
				<p class="tit_p mt5 mb0">검수 리스트</p>
			</div>
			<c:if test="${params.mng ne 'V' }">
			<div class="right_div">
				<div class="controll_btn p0">
					<button type="button" id="contInspBtn" onclick="fnPurcContInsp();">검사/검수</button>
				</div>
			</div>
			</c:if>
		</div>
		
		<div class="com_ta2 mt15">
			<div id="grid"></div>
		</div>
		
		<div class="btn_div mt10 cl purcContInspDetail">
			<div class="left_div">
				<p class="tit_p mt5 mb0">검수내용 상세</p>
			</div>
			<div class="right_div">
				<div class="controll_btn p0">
				</div>
			</div>
		</div>
		
		<div id="purcContInsp" class="purcContInspDetail">
			<div  class="com_ta2 hover_no mt10">
				<table>
					<colgroup>
						<col width="80"/>
						<col width="230"/>
						<col width="80"/>
						<col width="130"/>
						<col width="80"/>
						<col width=""/>
						<col width="80"/>
					</colgroup>
					<tbody>
						<tr>
							<th>납품기한</th>
							<td class="le" colspan="1">
								<input type="text" id="deliveryFrDate" readonly="readonly" disabled="disabled" style="width: 43%;"/> ~ 
								<input type="text" id="deliveryToDate" readonly="readonly" disabled="disabled" style="width: 43%;"/>
							</td>
							<th>납품일</th>
							<td class="le">
								<input type="text"id="deliveryDate" style="width: 90%;"/>
							</td>
							<th>계약상대자</th>
							<td class="le" colspan="2">
								<input type="text"id="trNm" readonly="readonly" disabled="disabled" style="width: 90%;"/>
							</td>
						</tr>
						<tr style="display: none;">
							<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> 검수장소</th>
							<td class="le" colspan="3">
								<input type="text" id="inspPlace" style="width: 90%;"/>
							</td>
						</tr>
						<tr>
							<th>필수첨부파일</th>
							<td class="" colspan="3">준공계 or 납품서 or 완료계</td>
							<td class="le" id="fileArea" colspan="3"></td>
						</tr>
						<tr id="fileSample" style="display: none;">
							<td></td>
							<td>
								<div class="mr20" style="">
									<span>
										<img alt="" src="<c:url value='/Images/ico/ico_clip02.png' />">&nbsp;
										<a class="file_name" id="" style="color: rgb(0, 51, 255); line-height: 23px; cursor: pointer;" onclick="fnTpfAttachFileDownload(this);" href="#n"></a>&nbsp;
										<input class="attachFileId" type="hidden" value="">
										<input class="fileSeq" type="hidden" value="">
										<input class="filePath" type="hidden" value="">
										<input class="fileNm" type="hidden" value="">
									</span>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
				<form id="fileForm" method="post" enctype="multipart/form-data">
					<input type="file" id="attachFile" name="file_name" value="" class="hidden" />
				</form>
			</div>
			<div class="com_ta2 hover_no" style="display: none;">
		    	<table style="border-top: 0px;">
					<colgroup>
						<col width="80"/>
						<col width=""/>
						<col width="90"/>
						<col width=""/>
						<col width="90"/>
						<col width=""/>
						<col width="90"/>
					</colgroup>
					<tr  id="trOpRow1">
						<th rowspan="2">검수의견</th>
						<td class="le op1" id="" colspan="1">
							<span>수량은 일치 하는가?</span>
						</td>
						<td style="border-left: 0px;" class="op1">
							<input type="text" id="inspOpinion1" class="inspOpinion1" style="width: 80px;">
						</td>
						<td class="le op2" id="" colspan="1">
							<span class="optxt2">계약규격과 외형은 일치 하는가?</span>
						</td>
						<td style="border-left: 0px;" class="op2">
							<input type="text" id="inspOpinion2" class="inspOpinion2" style="width: 80px;">
						</td>
						<td class="le op3" id="" colspan="1">
							<span>특허 등 특수기능은 있는가?</span>
						</td>
						<td style="border-left: 0px;" class="op3">
							<input type="text" id="inspOpinion3" class="inspOpinion3" style="width: 80px;">
						</td>
					</tr>
					<tr  id="trOpRow2">
						<td class="le op4" id="" colspan="1" style="border-left: solid #dcdcdc 1px;">
							<span>구성품은 부착되어있는가?</span>
						</td>
						<td style="border-left: 0px;" class="op4">
							<input type="text" id="inspOpinion4" class="inspOpinion4" style="width: 80px;">
						</td>
						<td class="le op5" id="" colspan="1">
							<span>검수결과</span>
						</td>
						<td style="border-left: 0px;" class="op5">
							<input type="text" id="inspOpinion5" class="inspOpinion5" style="width: 80px;">
						</td>
						<td class="le" id="" colspan="2">
						</td>
					</tr>
				</table>
			</div>
		</div>
		
		<div class="com_ta2 mt10 purcContInspDetail">
			<table  id="purcContInspT1">
				<thead>
					<tr>
						<th rowspan="2" style="border-right: solid #eaeaea 1px;" id="thContNm">용역명</th>
						<th rowspan="2" style="border-right: solid #eaeaea 1px;" id="thContContents">용역내용</th>
						<th colspan="3">계약내용</th>
						<th colspan="3">검수내용</th>
					</tr>
					<tr>
						<th>금액</th>
						<th>공급가액</th>
						<th>부가세</th>
						<th>금액</th>
						<th>공급가액</th>
						<th>부가세</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
			<table id="purcContInspT1-tablesample" style="display:none">
			    <tr class="">
			    	<td>
			    		<input type="text" class="contItemNm" id="" style="width: 90%;" disabled="disabled">
			    	</td>
			    	<td>
			    		<input type="text" class="contContents" id="" style="width: 90%;" disabled="disabled">
			    	</td>
			    	<td>
			    		<input type="text" class="contUnitAm ri" id="" style="width: 80%;" disabled="disabled">
			    	</td>
			    	<td>
			    		<input type="text" class="contSupAm ri" id="" style="width: 80%;" disabled="disabled">
			    	</td>
			    	<td>
			    		<input type="text" class="contVatAm ri" id="" style="width: 80%;" disabled="disabled">
			    	</td>
			    	<td>
			    		<input type="text" class="unitAm ri" id="" style="width: 80%;" disabled="disabled"/>
			    	</td>
			    	<td>
			    		<input type="text" class="supAm ri" id="" style="width: 80%;" disabled="disabled">
			    	</td>
			    	<td>
			    		<input type="text" class="vatAm ri" id="" style="width: 80%;" disabled="disabled">
			    	</td>
			    </tr>
			</table>
		</div>
		
		<div class="com_ta2 mt10 purcContInspDetail">
			<table  id="purcContInspT2">
				<thead>
					<tr>
						<th rowspan="2">품목구분</th>
						<th rowspan="2" style="border-right: solid #eaeaea 1px;">품명</th>
						<th colspan="7" class="colspanTh">계약내용</th>
						<th colspan="7" class="colspanTh">검수내용</th>
					</tr>
					<tr>
						<th>수량</th>
						<th>규격</th>
						<th>단가</th>
						<th>금액</th>
						<th>공급가액</th>
						<th>부가세</th>
						<th class="opHidden">조달수수료</th>
						<th>수량</th>
						<th>규격</th>
						<th>단가</th>
						<th>금액</th>
						<th>공급가액</th>
						<th>부가세</th>
						<th class="opHidden">조달수수료</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
			<table id="purcContInspT2-tablesample" style="display:none">
			    <tr class="">
			    	<td>
			    		<input type="text" class="contItemType" id="" style="width: 90%;" disabled="disabled">
			    	</td>
			    	<td>
			    		<input type="text" class="contItemNm" id="" style="width: 90%;" disabled="disabled">
			    	</td>
			    	<td>
			    		<input type="text" class="contItemCnt" id="" style="width: 90%;" disabled="disabled">
			    	</td>
			    	<td>
			    		<input type="text" class="contStandard" id="" style="width: 90%;" disabled="disabled">
			    	</td>
			    	<td>
			    		<input type="text" class="contItemAm ri" id="" style="width: 80%;" disabled="disabled">
			    	</td>
			    	<td>
			    		<input type="text" class="contUnitAm ri" id="" style="width: 80%;" disabled="disabled">
			    	</td>
			    	<td>
			    		<input type="text" class="contSupAm ri" id="" style="width: 80%;" disabled="disabled">
			    	</td>
			    	<td>
			    		<input type="text" class="contVatAm ri" id="" style="width: 80%;" disabled="disabled">
			    	</td>
			    	<td class="opHidden">
			    		<input type="text" class="contPpsFees ri" id="" style="width: 80%;" disabled="disabled">
			    	</td>
			    	<td>
			    		<input type="text" class="itemCnt" id="" style="width: 90%;" disabled="disabled">
			    	</td>
			    	<td>
			    		<input type="text" class="standard" id="" style="width: 90%;" disabled="disabled">
			    	</td>
			    	<td>
			    		<input type="text" class="itemAm ri" id="" style="width: 80%;" disabled="disabled">
			    	</td>
			    	<td>
			    		<input type="text" class="unitAm ri" id="" style="width: 80%;" disabled="disabled">
			    	</td>
			    	<td>
			    		<input type="text" class="supAm ri" id="" style="width: 80%;" disabled="disabled">
			    	</td>
			    	<td>
			    		<input type="text" class="vatAm ri" id="" style="width: 80%;" disabled="disabled">
			    	</td>
			    	<td class="opHidden">
			    		<input type="text" class="ppsFees ri" id="" style="width: 80%;" disabled="disabled">
			    	</td>
			    </tr>
			</table>
		</div>
	</div>
</div>
	<!-- //sub_contents_wrap -->
<!-- iframe wrap -->
