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
<script type="text/javascript" src='<c:url value="/js/consDocMng/consDocMng.js"></c:url>'></script>

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
	var url = _g_contextPath_ + '/Ac/G20/Ex/purcContModListData.do';
	
	$(document).ready(function() {
		topBoxInit();
		mainGrid();
		var grid = $('#grid').data('kendoGrid');
		if($('#mng').val() === 'Y'){
			$('#btnMod').show();
			$('#btnModReq').hide();
		}else{
			grid.hideColumn(8);
			$('#btnMod').hide();
			$('#btnModReq').show();
		}
		$('#btnModReq').on({
			click: function(){
				consDocMng.fnPurcContModReq($('#purcContId').val());
			}
		});
		consDocMng.mng = $('#mng').val();
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
							field : "writeDate",
							title : "요청일자",
						},{
							field : "contDate2",
							title : "계약일자",
						},{
							field : "",
							title : "계약기간",
							template : function(data){
								return data.contStartDate2 + " ~ " + data.contEndDate2;
							}
						},{
							field : "contAm",
							title : "계약금액",
							template : function(data){
								return data.contAm.toString().toMoney();
							}
						},{
							field : "modReason",
							title : "변경사유",
						},{
							field : "modReturnReason",
							title : "반려사유",
						},{
							field : "cDistatusNm",
							title : "결재상태",
						},{
							field : "cRidocfullnum",
							title : "문서번호",
							template : function(data){
								if(data.cRidocfullnum){
									return '<a style="color: rgb(0, 51, 255);" href="javascript:fnDocPopOpen(\'' + data.docId + '\');">' + data.cRidocfullnum + '</a>';
								}else{
									return '';
								}
							},
						},{
							field : "",
							title : "",
							template : function(data){
								if(data.modComDate || data.modReturnReason || data.cDistatusNm){
									return '';
								}else{
									return '<div class="controll_btn p0" style="text-align:center"><button type="button" id="" onclick="consDocMng.fnPurcContModCom(this);">변경계약 접수</button></div>';
								}
							},
						}],
						change: function (e) {
				        	gridClick(e);
				        }
					}).data("kendoGrid");
		
	}
	 
	function fnPurcContMod(){
		if(confirm("변경계약을 등록합니다.")){
			var params = {};
			params.purcContId = $("#purcContId").val();
		    var opt = {
		    		url     : _g_contextPath_ + "/Ac/G20/Ex/makeContModInfo.do",
		            async   : false,
		            data    : params,
		            successFn : function(data){
		            	var purcContId = data.result;
						var url = _g_contextPath_ + '/Ac/G20/Ex/purcContMod.do?purcContId='+purcContId;
						var pop = "";
						var width = "1000";
						var height = "950";
						windowX = Math.ceil( (window.screen.width  - width) / 2 );
						windowY = Math.ceil( (window.screen.height - height) / 2 );
						var strResize = 0 ;
						var popupName = "계약변경";
						var options = "width=" + width + ", height=" + height + ", top="+ windowY +", left="+ windowX +", scrollbars=YES, resizable=YES";
						
						openDialog(url, popupName, options, function(win) {
							gridReLoad();
						});
		            }
		    };
		    acUtil.ajax.call(opt);
		}
	}
	
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
					<input type="hidden" id=mng value="${params.mng}"/>
				</dd>
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
				<p class="tit_p mt5 mb0">변경계약 리스트</p>
			</div>
			<div class="right_div">
				<div class="controll_btn p0">
					<button type="button" id="btnModReq" onclick="">변경계약 요청</button>
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
