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
</style>

<script type="text/javascript">
	var url = _g_contextPath_ + '/Ac/G20/Ex/purcContPayListData.do';
	
	$(document).ready(function() {
		$(".purcContModDetail").hide();
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
		            	$(".purcContPayBtn").hide();
		            	$(".purcContPayRollBackBtn").show();
	            	}else{
		            	$(".purcContPayRollBackBtn").hide();
	            	}
	            	$("#consDocSeq").val(data.resultInfo.consDocSeq);
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
		pageSize: 10,
		transport: {
			read: {
				type: 'post',
				dataType: 'json',
				url: url
			},
			parameterMap: function(data, operation) {
	   	    	data.purcContId = $("#purcContId").val();
	   	    	data.consDocSeq = $("#consDocSeq").val();
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
							field : "regDt",
							title : "등록일자",
						},{
							field : "docNo",
							title : "문서번호",
						},{
							field : "title",
							title : "문서제목",
						},{
							field : "paymentType",
							title : "대금지급유형",
						},{
							field : "applyAm",
							title : "지급금액",
							template : function(data){
								return data.applyAm.toString().toMoney();
							}
						},{
							field : "docNo",
							title : "문서보기",
							template : function(data){
								return '<input type="button" id="" class="gray_btn" onclick="fnDocPopOpen(\''+data.cDikeycode+'\');" value="기안문서 보기">';
							}
						},{
							field : "docStateNm",
							title : "결재상태",
						}],
						change: function (e) {
				        	gridClick(e);
				        }
					}).data("kendoGrid");
	}
	 
	function fnPurcContPay(){
		if(!confirm(" 대금지급 하시겠습니까?"))return;
		var codeList = getCommCodeList("ERP_TYPE");
		var code = "";
		if(codeList.length > 0 && codeList[0].code){
			code = codeList[0].code;
		}
		if(code == "G20_2.0"){
			resAlphaG20.openResPop("dj_purcContPay", $("#purcContId").val(), "");
		}else{
			var purcContId = $("#purcContId").val();
			var template_key = fnGetTemplateKey();
			var url = _g_contextPath_ + '/Ac/G20/Ex/purcContPay.do?purcContId='+purcContId+'&template_key='+template_key;
			var pop = "";
			var width = "1000";
			var height = "950";
			windowX = Math.ceil( (window.screen.width  - width) / 2 );
			windowY = Math.ceil( (window.screen.height - height) / 2 );
			var strResize = 0 ;
			var popupName = "대금지급";
			var options = "width=" + width + ", height=" + height + ", top="+ windowY +", left="+ windowX +", scrollbars=YES, resizable=YES";
			
			openDialog(url, popupName, options, function(win) {
				gridReLoad();
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
	
	function fnGetTemplateKey(){
		var result = "";
		var params = {};
		if(location.host.indexOf("127.0.0.1") > -1 || location.host.indexOf("localhost") > -1){
			params.processId = "tpfPay";
	    }else{
			params.processId = "tpfPay";
	    }
	    var opt = {
	    		url     : _g_contextPath_ + "/Ac/G20/Ex/getTemplateKey.do",
	            async   : false,
	            data    : params,
	            successFn : function(data){
	            	result = data.result;
	            }
	    };
	    acUtil.ajax.call(opt);
	    return result;
	}
	
	function fnDocPopOpen(docId){
		var params = {};
	    params.compSeq =$('#compSeq').val();
	    params.empSeq = $('#empSeq').val();
	    params.docId = docId;
	    params.mod = 'V';
	    outProcessLogOn(params);
	}
	
	function fnPurcContPayComplete(){
		if(confirm("예산을 환원합니다.")){
			if(confirm("구매의뢰서(소액구매계약)의 예산이 모두 환원됩니다.")){
				var params = {};
				params.purcContId = $("#purcContId").val();
				params.consDocSeq = $("#consDocSeq").val();
				var opt = {
			    		url     : _g_contextPath_ + "/Ac/G20/Ex/purcContPayComplete.do",
			            async   : false,
			            data    : params,
			            successFn : function(data){
			            	if(data.result == "Failed"){
			            		alert("예산환원에 실패하였습니다.");
			            		return;
			            	}
			            	if(data.result == "Approval"){
			            		alert("결재중인 대급지급 건이 있습니다.");
			            		return;
			            	}
			            	if(data.result == "Success"){
			            		alert("예산환원 처리 되었습니다.");
			            		location.reload();
			            	}
			            }
			    };
			    acUtil.ajax.call(opt);
			}
		}
	}
	
	function fnPurcContPayCompleteRollBack(){
		if(confirm("예산환원을 취소합니다.")){
			var params = {};
			params.purcContId = $("#purcContId").val();
			params.consDocSeq = $("#consDocSeq").val();
			var opt = {
		    		url     : _g_contextPath_ + "/Ac/G20/Ex/purcContPayCompleteRollBack.do",
		            async   : false,
		            data    : params,
		            successFn : function(data){
		            	if(data.result == "Failed"){
		            		alert("예산환원 취소에 실패하였습니다.");
		            		return;
		            	}
		            	if(data.result == "Not"){
		            		alert("환원취소할 예산이 없습니다.");
		            		return;
		            	}
		            	if(data.result == "Success"){
		            		alert("예산환원이 취소 처리 되었습니다.");
		            		location.reload();
		            	}
		            }
		    };
		    acUtil.ajax.call(opt);
		}
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
					<input type="text" id="txtPurcReqType" class="txtPurcReqType" readonly="readonly" disabled="disabled" style="width: 170px;"/>
					<input type="hidden" id=purcContId value="${params.purcContId }"/>
					<input type="hidden" id=consDocSeq value=""/>
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
				<p class="tit_p mt5 mb0">대금지급 리스트</p>
			</div>
			<c:if test="${params.mng ne 'V' }">
			<div class="right_div">
				<div class="controll_btn p0 purcContPayBtn">
					<button type="button" id="" onclick="fnPurcContPay();">대금지급</button>
					<button type="button" id="" onclick="fnPurcContPayComplete();">예산환원</button>
				</div>
				<div class="controll_btn p0 purcContPayRollBackBtn">
					<button type="button" id="" onclick="fnPurcContPayCompleteRollBack();">예산환원취소</button>
				</div>
			</div>
			</c:if>
		</div>
		
		<div class="com_ta2 mt15">
			<div id="grid"></div>
		</div>
		
		<div class="btn_div mt10 cl purcContModDetail">
			<div class="left_div">
				<p class="tit_p mt5 mb0">계약내용 상세</p>
			</div>
			<div class="right_div">
				<div class="controll_btn p0">
				</div>
			</div>
		</div>
		
		<div id="purcContInsp" class="purcContModDetail">
			<div  class="com_ta2 hover_no mt10">
				<table>
					<colgroup>
						<col width="100"/>
						<col width=""/>
						<col width="100"/>
						<col width=""/>
						<col width="100"/>
						<col width=""/>
						<col width="100"/>
						<col width=""/>
					</colgroup>
					<tbody>
						<tr>
							<th>계약명</th>
							<td class="le" colspan="1">
								<input type="text"id="contTitle" style="width: 90%;"/>
							</td>
							<th>계약금액</th>
							<td class="le">
								<input type="text"id="contAm" readonly="readonly" disabled="disabled" style="width: 90%;"/>
							</td>
							<th>계약일</th>
							<td class="le" colspan="1">
								<input type="text"id="contDate2" readonly="readonly" disabled="disabled" style="width: 90%;"/>
							</td>
							<th>계약기간</th>
							<td class="le" colspan="1">
								<input type="text" id="contStartDate2" readonly="readonly" disabled="disabled" style="width: 43%;"/> ~ 
								<input type="text" id="contEndDate2" readonly="readonly" disabled="disabled" style="width: 43%;"/>
							</td>
						</tr>
						<tr>
							<th>거래처</th>
							<td class="le" colspan="1">
								<input type="text"id="trNm" style="width: 90%;"/>
							</td>
							<th>계약방법</th>
							<td class="le">
								<input type="text"id="contType" readonly="readonly" disabled="disabled" style="width: 90%;"/>
							</td>
							<th>지급조건</th>
							<td class="le" colspan="1">
								<input type="text"id="payCon" readonly="readonly" disabled="disabled" style="width: 90%;"/>
							</td>
							<th>지급방법</th>
							<td class="le" colspan="1">
								<input type="text" id="payType" readonly="readonly" disabled="disabled" style="width: 50%;"/> 
								<span id="spanPayCnt"><input type="text" id="payCnt" readonly="readonly" disabled="disabled" style="width: 20%;"/> 회</span>
							</td>
						</tr>
						<tr>
							<th>첨부파일</th>
							<td class="le" id="fileArea3" colspan="7"></td>
						</tr>
						<tr>
							<th>계약서</th>
							<td class="le" id="fileArea2" colspan="7"></td>
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
			<div class="com_ta2 hover_no mt10">
		    	<table id="budgetInfo">
					<colgroup>
						<col width="100"/>
						<col width=""/>
						<col width="100"/>
						<col width=""/>
						<col width="100"/>
						<col width=""/>
						<col width="100"/>
						<col width=""/>
					</colgroup>
					<tr  id="">
						<th>관</th>
						<td id="td_veiw_BGT01_NM"></td>
						<th>항</th>
						<td id="td_veiw_BGT02_NM"></td>
						<th>목</th>
						<td id="td_veiw_BGT03_NM"></td>
						<th>세</th>
						<td id="td_veiw_BGT04_NM"></td>
					</tr>
					<tr  id="">
						<th>예산액</th>
						<td id="td_veiw_OPEN_AM"></td>
						<th>집행액</th>
						<td id="td_veiw_APPLY_AM"></td>
						<th>요청액</th>
						<td id="td_veiw_REFER_AM"></td>
						<th>예산잔액</th>
						<td id="td_veiw_LEFT_AM"></td>
					</tr>
				</table>
			</div>
			
			<div class="com_ta2 mt10">
				<table  id="erpBudgetInfo">
					<colgroup>
						<col width="13%">
						<col width="13%">
						<col width="13%">
						<col width="22%">
						<col width="8%">
						<col width="8%">
						<col width="10%">
						<col width="13%">
					</colgroup>
					<thead>
						<tr>
							<th width="">예산회계단위</th>
							<th width="">프로젝트</th>
							<th width="">하위사업</th>
							<th width="">예산과목</th>
							<th width="">과세구분</th>
							<th width="">환원가능여부</th>
							<th width="">금액</th>
							<th width="">비고</th>
						</tr>
					</thead>
					<tbody  id="erpBudgetInfo-table">
	                </tbody>
				</table>
			</div>
	        <table id="erpBudgetInfo-tablesample" style="display:none">
			    <tr class="">
			    	<td width="">
			    		<input type="text" class="non-requirement divNm" id="" style="width: 90%;">
			    	</td>
			    	<td width="">
			    		<input type="text" class="non-requirement mgtNm" id="" style="width: 90%;">
			    	</td>
			    	<td width="">
			    		<input type="text" class="non-requirement bottomNm" id="" style="width: 90%;">
			    	</td>
			        <td width="" id="budget-td">
			            <input type="text" style="width:45%;" id="" class="non-requirement bgtNm1" readonly="readonly" />
			            <input type="text" style="width:45%;" id=""  class="requirement bgtNm2" tabindex="10001" readonly="readonly" />
			        </td>
			        <td width=""><input type="text" style="width:95%;" id=""   tabindex="10003" class="non-requirement vatFg"/></td>
			        <td width="">
			        	<input type="checkbox" id="" class="non-requirement returnYn" checked="checked"/>
			        </td>
			        <td width="">
			        	<span id="" class="totalAM"></span>
			        </td>
			        <td width="">
			        	<input type="text" style="width:82%;" id="" CODE="empty" tabindex="10006" class="non-requirement rmkDc" part="budget"/>
			        </td>
			    </tr>
			</table>
			
			<!-- 버튼 -->
			<div class="btn_div mt10 mb0 cl">
				<div class="left_div">
					<div class="controll_btn p0 com_ta2 hover_no">
						<table id="tableTab">
							<tr>
								<td class="tdTab" id="001">공사</td>
								<td class="tdTab" id="002">물품</td>
							</tr>
						</table>
					</div>
				</div>
				<div class="right_div mb10">
					<div class="controll_btn p0 com_ta2 hover_no">
						<span class="cl fr hidden" id="referConfer"></span>
					</div>
				</div>
			</div> 
		
			<div class="com_ta2">
				<table  id="erpTradeInfo">
					<colgroup>
						<col width="">
						<col width="">
						<col width="">
						<col width="">
						<col width="">
						<col width="">
						<col width="">
						<col width="">
						<col width="">
						<col width="">
						<col width="">
						<col width="">
					</colgroup>
					<thead>
						<tr>
							<th width="">조달청 물품식별번호</th>
							<th width="">품목구분</th>
							<th width="">품명</th>
							<th width="">수량</th>
							<th width="">규격</th>
							<th width="">공사내용</th>
							<th width="">단가</th>
							<th width="">금액</th>
							<th width="">공급가액</th>
							<th width="">부가세</th>
							<th width="">조달수수료</th>
							<th width="">비고</th>
						</tr>
					</thead>
					<tbody id="erpTradeInfo-table">
	                </tbody>
				</table>
			</div>
			
			<table id="erpTradeInfo-tablesample" style="display:none">
				<tr>
					<td>
						<input type="text" class="ppsIdNo"/>
					</td>
					<td>
						<input type="text" class="itemType"/>
					</td>
					<td>
						<input type="text" class="itemNm"/>
					</td>
					<td>
						<input type="text" class="itemCnt"/>
					</td>
					<td>
						<input type="text" class="standard"/>
					</td>
					<td>
						<input type="text" class="contents"/>
					</td>
					<td>
						<input type="text" class="itemAm ri"/>
					</td>
					<td>
						<input type="text" class="unitAm ri"/>
					</td>
					<td>
						<input type="text" class="supAm ri"/>
					</td>
					<td>
						<input type="text" class="vatAm ri"/>
					</td>
					<td>
						<input type="text" class="ppsFees ri"/>
					</td>
					<td>
						<input type="text" class="rmkDc"/>
					</td>
				</tr>
    		</table>
		</div>
	</div>
</div>
	<!-- //sub_contents_wrap -->
<!-- iframe wrap -->
