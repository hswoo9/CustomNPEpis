<%@page import="org.apache.xmlbeans.impl.xb.xsdschema.IncludeDocument.Include"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="main.web.BizboxAMessage"%>

<%
 /**
  * @Class Name : purcReqFormPop.jsp
  * @Description : 구매의뢰서 작성
  * @Modification Information
  *
  */ 
%>

<script type="text/javascript" src='<c:url value="/js/ac/acUtil.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/ac/g20/purcReqCode.js"></c:url>'></script>
<script type="text/javascript" src="<c:url value='/js/jquery.form.js' />"></script>
<script type="text/javascript" src='<c:url value="/js/common/commFileUtil.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/common/outProcessUtil.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/resalphag20/resAlphaG20Util.js"></c:url>'></script>

<style type="text/css">

.invalid { background-color : #ff6666;}
input:focus{background-color : #ccffff;}
.overBudget{background-color : #ff66dd;}
#project-td .search-Event-H, #budget-td .search-Event-B{display : none;}
#project-td #txt_ProjectName, .txt_BUDGET_LIST{disabled : disabled}
.left_div .controll_btn #tableTab{border: 1px solid #eaeaea;width: 160px;border-bottom-width: 0px;cursor: pointer;}
.left_div .controll_btn #tableTab .selTab{background: #e6f4ff;}
</style>

<script type="text/javascript">
	var purcContId = "${params.purcContId}";
	var gwOption = {};
	var abdocuInfo = {};
	var consDocSeq = "";
	
$(function(){
	purcContModInit();
	purcContModEventHandler();
	
	if($("#txtPurcReqType").attr("code") == "2"){
		$("#trNm").unbind().attr("disabled", true);
		$("#trPopBtn").unbind().hide();
	}
	targetType = 'PURCMOD';
	targetSeq = $("#purcContId").val();
	resAlphaG20Util.init();
	$('.notView').hide();
	fnResizeForm();
	setTimeout(function(){$(".pop_sign_wrap").height($("body").height());}, 100);
});

//팝업 리사이즈
function fnResizeForm() {
	
	var strWidth = $('.pop_sign_wrap').outerWidth() + (window.outerWidth - window.innerWidth);
	var strHeight = $('.pop_sign_wrap').outerHeight() + (window.outerHeight - window.innerHeight);
	
	$('.pop_sign_wrap').css("overflow","auto");
	try{
		var childWindow = window.parent;
		childWindow.resizeTo(strWidth, strHeight);	
	}catch(exception){
		console.log('window resizing cat not run dev mode.');
	}
}

function purcContModEventHandler(){
	// 기초금액, 낙찰률 추가 20190827
	$("#expectedAm").bind({
		change : function(){
			$(this).val($(this).val().toMoney());
		}
	});
	$('.tdTab').bind({
		click : function(){
			fnSelTab($(this))
		}
	})
	$("#payType").bind({
		change : function(){
			fnPayTypeChange();
		}
	});
	$('#attachFile').bind({
		change : function(){
			fnTpfAttachFileUpload($(this));
		}
	});
	/*거래처명*/
    $("#trNm").bind({
        dblclick : function(){
            var id = $(this).attr("id");
            var dblClickparamMap =
            	(function(ID, idx){
            		var returnObj =
	                    [{
	    					"id" : ID,
	                        "text" : "TR_NM",
	                        "code" : "TR_CD"
	    				},
	                     {
	     					"id" : "txt_CEO_NM" + idx,
	                         "text" : "CEO_NM",
	                         "code" : ""
	     				},
	                     {
	     					"id" : "txt_REG_NB" + idx,
	                         "text" : "REG_NB",
	                         "code" : ""
	     				}];
            		
					return returnObj;

            	})(id, "");
            
            acUtil.util.dialog.dialogDelegate(acG20Code.getErpTradeList, dblClickparamMap);

        }
    
    });
	$("#trPopBtn").bind({
		click : function(){
			 $("#trNm").dblclick();
		}
	});
	$("#btnApproval").bind({
		click : function(){
			completePurcContMod();
		}
	});
	$("#btnReturnPop").bind({
		click : function(){
			returnPurcContMod();
		}
	});
	$("#purcContModInfo input").bind({
		change : function(){
			updatePurcContMod();
		}
	});
	$("#payCnt").bind({
		keyup : function(){
			$(this).val($(this).val().toString().toMoney2());
		}
	});
	$("#refDocBtn").bind({
		click : function(){
			var id = $(this).attr("id");
            var dblClickparamMap =
            	(function(ID, idx){
            		var returnObj =
	                    [{
	    					"id" : "refDoc",
	                        "text" : "refDoc",
	                        "code" : ""
	    				}];
            		
					return returnObj;

            	})(id, "");
            
            acUtil.util.dialog.dialogDelegate(acG20Code.getRefDoc, dblClickparamMap);
		}
	});
	$("#dialog-form-standard").bind({
		keyup : function(e){
			if(e.which == 27){
				$("#dialog-form-background, #dialog-form-standard").hide();
			}
		}
	});
	
	/*거래처명*/
    $("#txt_TR_NM_add").bind({
        dblclick : function(){
            var id = $(this).attr("id");
            var dblClickparamMap =
            	(function(ID, idx){
            		var returnObj =
	                    [{
	    					"id" : ID,
	                        "text" : "TR_NM",
	                        "code" : "TR_CD"
	    				},
	                     {
	     					"id" : "txt_CEO_NM" + idx,
	                         "text" : "CEO_NM",
	                         "code" : ""
	     				},
	                     {
	     					"id" : "txt_REG_NB" + idx,
	                         "text" : "REG_NB",
	                         "code" : ""
	     				}];
            		
					return returnObj;

            	})(id, "");
            
            acUtil.util.dialog.dialogDelegate(acG20Code.getErpTradeList, dblClickparamMap);

        }
    
    });
    $("#addTradeBtn").bind({
		click : function(){
			 $("#txt_TR_NM_add").dblclick();
		}
	});
    
    $('#btnReturn').on({
		click: function(){
			fnReturn();
		}
	});
}

function fnSelTab(selTab){
	if(selTab.hasClass('selTab'))return;
	$('.tdTab').removeClass('selTab');
	selTab.addClass('selTab');
	fnTradeTableInit();
	var tr = $('#erpBudgetInfo-table .on');
	fnContBSelect(tr);
}

function purcContModInit(){
	abdocuInfo.erp_co_cd = $("#erpCoCd").val();
	var parentEle = $('#purcContMod');
	fnTpfDatepickerInit("contDate2");
	fnTpfDatepickerInit("contStartDate2");
	fnTpfDatepickerInit("contEndDate2");
	fnTpfComboBoxInit("PURC_CONT_TYPE", "contType", parentEle);
	fnTpfComboBoxInit("PURC_CONT_PAY_CON", "payCon", parentEle);
	fnTpfComboBoxInit("PURC_CONT_PAY_TYPE", "payType", parentEle);
	topBoxInit();
	fnBudgetTableInit();
	fnTabInit();
	fnTradeTableInit();
	fnTpfGetContMod();
	refDocPopupInit();
	
	$("#returnDiv").kendoWindow({
		width: "500px",
		height: "100px",
		visible: false,
		modal: true,
		title: '반려사유',
		actions: [
			"Close"
		],
		close: function(){
			
		}
	}).data("kendoWindow").center();
}

function fnBudgetTableInit(){
	var code = $('#txtPurcReqType').attr('code');
	var selTab = $('#tableTab .selTab').attr('id');
	var th = $("#erpBudgetInfo thead th");
	var td = $("#erpBudgetInfo-tablesample td");
	if(code == "1" || code == "2"){
		th.eq(6).hide();
		td.eq(6).hide();
	}
	th.eq(6).hide();
	td.eq(6).hide();
}

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
            }
    };
    acUtil.ajax.call(opt);
}

function fnTabInit(){
	var code = $('#txtPurcReqType').attr('code');
	if(code == '1' || code == '2'){
		$('#tableTab').hide();
		$('#tableTab #002').addClass('selTab');
		return;
	}else if(code == '3'){
		$('#tableTab #001').html('공사');
	}else if(code == '4'){
		$('#tableTab #001').html('용역');
	}
	$('#tableTab').show();
	$('#tableTab #001').addClass('selTab');
}

function fnTradeTableInit(){
	var code = $('#txtPurcReqType').attr('code');
	var selTab = $('#tableTab .selTab').attr('id');
	var th = $("#erpTradeInfo thead th");
	var td = $("#erpTradeInfo-tablesample tbody td");
	th.show();
	td.show();
	if(code == "2"){
		th.eq(5).hide();
		td.eq(5).hide();
		th.eq(11).hide();
		td.eq(11).hide();
		th.eq(2).html("품명");
	}else if(code == "3" && selTab == "001"){
		th.eq(0).hide();
		td.eq(0).hide();
		th.eq(1).hide();
		td.eq(1).hide();
		th.eq(3).hide();
		td.eq(3).hide();
		th.eq(4).hide();
		td.eq(4).hide();
		th.eq(6).hide();
		td.eq(6).hide();
		th.eq(10).hide();
		td.eq(10).hide();
		th.eq(2).html("공사명");
		th.eq(5).html("공사내용");
	}else if(code == "4" && selTab == "001"){
		th.eq(0).hide();
		td.eq(0).hide();
		th.eq(1).hide();
		td.eq(1).hide();
		th.eq(3).hide();
		td.eq(3).hide();
		th.eq(4).hide();
		td.eq(4).hide();
		th.eq(6).hide();
		td.eq(6).hide();
		th.eq(10).hide();
		td.eq(10).hide();
		th.eq(2).html("용역명");
		th.eq(5).html("용역내용");
	}else{
		th.eq(0).hide();
		td.eq(0).hide();
		th.eq(5).hide();
		td.eq(5).hide();
		th.eq(10).hide();
		td.eq(10).hide();
		th.eq(11).hide();
		td.eq(11).hide();
		th.eq(2).html("품명");
	}
	th.eq(11).hide();
	td.eq(11).hide();
}

function fnTpfGetContMod(){
	var data = getContMod($("#purcContId").val());
	var contInfo = data.purcContInfo;
	var contBList = data.purcContBList;
	var attachFileList = data.attachFileList;
	var purcContAddTr = data.purcContAddTr;
	data = getContMod(contInfo.purcContIdOrg);
	var contInfoOrg = data.purcContInfo;
	var attachFileListOrg = data.attachFileList;
	var purcContAddTrOrg = data.purcContAddTr;
	consDocSeq = contInfoOrg.consDocSeq;
	fnSetContInfo(contInfo);
	fnSetAttachFileList(attachFileList);
	fnSetContInfoOrg(contInfoOrg);
	fnSetAttachFileList2(attachFileListOrg);
	if(contBList){
		fnSetContBList(contBList);
	}
	fnSetPurcContAddTr(purcContAddTr);
	fnSetPurcContAddTr2(purcContAddTr);
}

function getContMod(purcContId){
	var result = {};
	var params = {};
	params.purcContId = purcContId;
    var opt = {
    		url     : _g_contextPath_ + "/Ac/G20/Ex/getContMod.do",
            async   : false,
            data    : params,
            successFn : function(data){
            	result = data;
            }
    };
    acUtil.ajax.call(opt);
    return result;
}

function fnSetContInfo(data){
	fnResetContInfo();
	$("#modReason").val(data.modReason);
	$("#purcReqId").val(data.purcReqId);
	$("#purcContIdOrg").val(data.purcContIdOrg);
	var contAm = data.contAm ? data.contAm : 0;
	$("#contAm").val(contAm.toString().toMoney());
	$("#contTitle").val(data.contTitle);
	$("#contDate2").val(data.contDate2);
	$("#contStartDate2").val(data.contStartDate2);
	$("#contEndDate2").val(data.contEndDate2);
	$("#trNm").val(data.trNm).attr("code", data.trCd);
	$("#txt_CEO_NM").val(data.ceoNm);
	$("#txt_REG_NB").val(data.regNb);
	$("#contType").data("kendoComboBox").value(data.contTypeCodeId);
	$("#payCon").data("kendoComboBox").value(data.payConCodeId);
	$("#payType").data("kendoComboBox").value(data.payTypeCodeId);
	$("#payCnt").val(data.payCnt);
	if(data.payTypeCodeId == "002"){
		$("#spanPayCnt").show();
	}else{
		$("#spanPayCnt").hide();
	}
	var refDocKey = data.refDocKey || "";
	var refDocTitle = data.refDocTitle || "";
	var html = "<a href='#n' style='color:rgb(0, 51, 255)' onclick='refDocView()'>"+refDocTitle+"</a>";
	$("#refDoc span").html(html);
	$("#refDocKey").val(refDocKey);
	$("#refDocTitle").val(refDocTitle);
	if(data.basicAm){
		$("#basicAm").val(data.basicAm.toString().toMoney());
	}
	if(data.expectedAm){
		$("#expectedAm").val(data.expectedAm.toString().toMoney());
	}
	$("#rate").val(data.rate);
}

function fnSetContInfoOrg(data){
	$("#contTitleOrg").val(data.contTitle);
	$("#contAmOrg").val(data.contAm.toString().toMoney());
	$("#contTitleOrg").val(data.contTitle);
	$("#contDate2Org").val(data.contDate2);
	$("#contStartDate2Org").val(data.contStartDate2);
	$("#contEndDate2Org").val(data.contEndDate2);
	$("#trNmOrg").val(data.trNm);
	$("#contTypeOrg").val(data.contType);
	$("#payConOrg").val(data.payCon);
	$("#payTypeOrg").val(data.payType);
	$("#payCntOrg").val(data.payCnt);
	if(data.payTypeCodeId == "002"){
		$("#spanPayCntOrg").show();
	}else{
		$("#spanPayCntOrg").hide();
	}
	$("#purcContModOrg input").attr("disabled", true);
	if(data.basicAm){
		$("#basicAmOrg").val(data.basicAm.toString().toMoney());
	}
	if(data.expectedAm){
		$("#expectedAmOrg").val(data.expectedAm.toString().toMoney());
	}
	$("#rateOrg").val(data.rate);
}

function fnResetContInfo(){
	$("#purcContMod input[type=text]").val("");
	$("#purcContMod #fileArea2").html("");
	$("#purcContMod #fileArea3").html("");
	$("#budgetInfo td").html("");
	$("#erpBudgetInfo-table tr").remove();
	$("#erpTradeInfo-table tr").remove();
}

function fnSetAttachFileList(data){
	$('#fileArea2 span').remove();
	$('#fileArea3 span').remove();
	$.each(data, function(){
		var fileType = this.fileType;
		var span = $('#fileSample div').clone();
		$('.file_name', span).html(this.realFileName + '.' + this.fileExtension);
		$('.attachFileId', span).val(this.attachFileId);
		$('.fileSeq', span).val(this.fileSeq);
		$('.filePath', span).val(this.filePath);
		$('.fileNm', span).val(this.realFileName + '.' + this.fileExtension);
		$('#fileArea' + fileType).append(span);
	});
}

function fnSetAttachFileList2(data){
	$('#fileAreaOrg2 span').remove();
	$('#fileAreaOrg3 span').remove();
	$.each(data, function(){
		var fileType = this.fileType;
		var span = $('#fileSampleOrg div').clone();
		$('.file_name', span).html(this.realFileName + '.' + this.fileExtension);
		$('.attachFileId', span).val(this.attachFileId);
		$('.fileSeq', span).val(this.fileSeq);
		$('.filePath', span).val(this.filePath);
		$('.fileNm', span).val(this.realFileName + '.' + this.fileExtension);
		$('#fileAreaOrg' + fileType).append(span);
	});
}

function fnSetContBList(data){
	$.each(data, function(inx){
		var tr = $("#erpBudgetInfo-tablesample tr").clone();
		tr.attr("abdocu_b_no", this.abdocu_b_no);
		tr.attr("abdocu_no", this.abdocu_no);
		tr.attr("purc_cont_b_id", this.purc_cont_b_id);
		tr.attr("purc_cont_id", this.purc_cont_id);
		tr.attr("purc_req_b_id", this.purc_req_b_id);
		tr.attr("purc_req_h_id", this.purc_req_h_id);
		tr.attr("purc_req_id", this.purc_req_id);
		tr.attr("co_cd", this.erp_co_cd);
		tr.attr("gisu_dt", this.erp_gisu_dt);
		tr.attr("docu_mode", this.docu_mode);
		tr.attr("from_dt", this.erp_gisu_from_dt);
		tr.attr("to_dt", this.erp_gisu_to_dt);
		tr.attr("gisu", this.erp_gisu);
		$(".divNm", tr).val(this.div_nm2);
		$(".divNm", tr).attr("code", this.div_cd2);
		$(".mgtNm", tr).val(this.mgt_nm);
		$(".mgtNm", tr).attr("code", this.mgt_cd);
		$(".bottomNm", tr).val(this.bottom_nm);
		$(".bottomNm", tr).attr("code", this.bottom_cd);
		$(".bgtNm1", tr).val(this.erp_bgt_nm1);
		$(".bgtNm2", tr).val(this.abgt_nm);
		$(".bgtNm2", tr).attr("code", this.abgt_cd);
		var vatNm = "과세";
		if(this.vat_fg == "2"){
			vatNm = "면세";
		}else if(this.vat_fg == "3"){
			vatNm = "기타";
		}
		$(".vatFg", tr).val(vatNm).attr("code", this.vat_fg);
		if(this.return_yn == "N"){
			$(".returnYn", tr).prop("checked", false);
		}
		$(".rmkDc", tr).val(this.rmk_dc);
		$(".totalAM", tr).html(this.apply_am.toString().toMoney());
		$(".nextAm", tr).html(this.next_am.toString().toMoney());
		$("#erpBudgetInfo-table").append(tr);
		$(tr).bind({
			click : function(){
				if(tr.hasClass("on"))return;
				fnContBSelect(tr);
				$("#erpBudgetInfo-table tr").removeClass("on");
				tr.addClass("on");
			}
		});
		if(inx == 0){
			tr.click();
		}
	});
}

function fnSetPurcContAddTr(purcContAddTr){
	$.each(purcContAddTr, function(){
		var trCd = this.trCd;
		var trNm = this.trNm;
		var span = $('#addTradeTdSample span').clone();
    	$(".trNmTxt", span).html(trNm);
    	$(".trCd", span).val(trCd);
    	$(".trNm", span).val(trNm);
		$("#txt_TR_NM_add_span").append(span);
	});
};

function fnSetPurcContAddTr2(purcContAddTr){
	$.each(purcContAddTr, function(){
		var trCd = this.trCd;
		var trNm = this.trNm;
		var span = $('#addTradeTdSampleOrg span').clone();
    	$(".trNmTxt", span).html(trNm);
    	$(".trCd", span).val(trCd);
    	$(".trNm", span).val(trNm);
		$("#txt_TR_NM_add_spanOrg").append(span);
	});
};

function fnContBSelect(tr){
	fnGetBudgetInfo(tr);
	fnGetApplyAm(tr);
	fnGetPurcContT(tr);
}

function fnGetBudgetInfo(tr){
	var obj =  {};
    obj.DIV_CD    = $(".divNm", tr).attr("CODE");
    obj.MGT_CD    = $(".mgtNm", tr).attr("CODE");
    obj.BOTTOM_CD = $(".bottomNm", tr).attr("CODE") || "";
    
	obj.BGT_CD    = $(".bgtNm2", tr).attr("code");
    obj.SUM_CT_AM = 0;
    obj.GISU_DT   = tr.attr("GISU_DT");
    obj.DOCU_MODE = tr.attr("DOCU_MODE");
    obj.CO_CD     = tr.attr("CO_CD");
    obj.FROM_DT     = tr.attr("FROM_DT");
    obj.TO_DT     = tr.attr("TO_DT");
    obj.GISU      = tr.attr("GISU");
    
    /* G20 2.0 파라미터 추가 */
    obj.consDocSeq   = consDocSeq;
    obj.mgtSeq       = $(".mgtNm", tr).attr("CODE");
    obj.budgetSeq    = tr.attr("ABDOCU_B_NO");
    obj.erpBudgetSeq = $(".bgtNm2", tr).attr("code");
    obj.gisu         = tr.attr("GISU");
    obj.bottomSeq    = $(".bottomNm", tr).attr("CODE") || "";

	/*ajax 호출할 파라미터*/
    var opt = {
            url : _g_contextPath_ + "/Ac/G20/Ex/getBudgetInfo.do",
            async:false,
            data : obj,
            type:"post",
            successFn : function(data){
            	var result = data.result;
            	$("#td_veiw_BGT01_NM").html(result.BGT01_NM || "");
            	$("#td_veiw_BGT02_NM").html(result.BGT02_NM || "");
            	$("#td_veiw_BGT03_NM").html(result.BGT03_NM || "");
            	$("#td_veiw_BGT04_NM").html(result.BGT04_NM || "");
            	$("#td_veiw_OPEN_AM").html((result.OPEN_AM || "0").toString().toMoney());
            	$("#td_veiw_APPLY_AM").html((result.ERP_APPLY_AM || "0").toString().toMoney());
            	$("#td_veiw_REFER_AM").html((result.REFER_AM || "0").toString().toMoney());
            	$("#td_veiw_LEFT_AM").html((result.LEFT_AM || ")").toString().toMoney());
            }
    };

    /*결과 데이터 담을 객체*/
    acUtil.resultData = {};
    acUtil.ajax.call(opt, acUtil.resultData );
    return acUtil.resultData;
}

function fnGetApplyAm(tr){
	var result = {};
	var obj = {};
	obj.purcContIdOrg = $("#purcContIdOrg").val();
	obj.abdocuBNo = tr.attr('abdocu_b_no');
	var opt = {
			url     : _g_contextPath_ + "/Ac/G20/Ex/getApplyAm.do",
			async   : false,
			data    : obj,
			successFn : function(data){
				if(data.applyAmInfo){
					var applyAm = data.applyAmInfo.applyAm;
					var aceptAm = data.applyAmInfo.aceptAm;
					var html = "";
					html += '예산별 계약금액 : ' + applyAm.toString().toMoney();
					//html += "<br/> 예산별 집행금액 : " + aceptAm.toString().toMoney();
					$('#referConfer').html(html);
					result = data.applyAmInfo;
				}
			}
	};
    acUtil.ajax.call(opt);
    return result;
}

function fnGetPurcContT(tr){
	var params = {};
	params.abdocu_b_no = tr.attr("abdocu_b_no");
	params.purc_cont_id = tr.attr("purc_cont_id");
	params.purc_tr_type = $("#tableTab .selTab").attr("id");
    var opt = {
    		url     : _g_contextPath_ + "/Ac/G20/Ex/getPurcContT.do",
            async   : false,
            data    : params,
            successFn : function(data){
            	var contTList = data.selectList;
            	fnSetContTList(contTList);
            }
    };
    acUtil.ajax.call(opt);
}

function fnSetContTList(data){
	$("#erpTradeInfo-table tr").remove();
	$.each(data, function(){
		var tr = $("#erpTradeInfo-tablesample tr").clone();
		tr.attr("purcContId", this.purc_cont_id);
		tr.attr("purcContBId", this.purc_cont_b_id);
		tr.attr("purcContTId", this.purc_cont_t_id);
		tr.attr("purcReqId", this.purc_req_id);
		tr.attr("purcReqBId", this.purc_req_b_id);
		tr.attr("purcReqTId", this.purc_req_t_id);
		$(".ppsIdNo", tr).val(this.pps_id_no);
		var itemType = $(".itemType", tr);
		fnTpfComboBoxInit2("PURC_REQ_ITEM_TYPE", "itemType", tr);
		itemType.data("kendoComboBox").value(this.item_type_code_id);
		$(".itemNm", tr).val(this.item_nm);
		$(".itemCnt", tr).val(this.item_cnt);
		$(".standard", tr).val(this.standard);
		$(".contents", tr).val(this.contents);
		$(".itemAm", tr).val(this.item_am.toString().toMoney());
		$(".unitAm", tr).val(this.unit_am.toString().toMoney());
		$(".supAm", tr).val(this.sup_am.toString().toMoney());
		$(".vatAm", tr).val(this.vat_am.toString().toMoney());
		$(".ppsFees", tr).val(this.pps_fees.toString().toMoney());
		$(".nextAm", tr).val(this.next_am.toString().toMoney());
		$(".rmkDc", tr).val(this.rmk_dc);
		$("#erpTradeInfo-table").append(tr);
		$(".saveBnt", tr).bind({
			click : function(){
				updatePurcContModT($(this));
			}
		});
		$(".delBnt", tr).bind({
			click : function(){
				delPurcContModT($(this));
			}
		});
		$(".itemCnt, .itemAm, .unitAm, .supAm, .vatAm", tr).bind({
			keyup : function(){
				$(this).val($(this).val().toString().toMoney());
				if($(this).hasClass("itemCnt")){
					$(this).val($(this).val().toString().toMoney2());
				}
				var itemCnt = 0;
				var itemAm = 0;
				var unitAm = 0;
				var supAm = 0;
				var vatAm = 0;
				if($(this).hasClass("itemCnt") || $(this).hasClass("itemAm")){
					itemCnt = parseInt($(".itemCnt", tr).val().toString().toMoney2());
					itemAm = parseInt($(".itemAm", tr).val().toString().toMoney2());
					unitAm = itemCnt * itemAm;
					supAm = ((Math.round(parseInt(unitAm,10) / 1.1 * 10)) / 10);
					supAm = Math.round(supAm, 10);
					vatAm = unitAm - supAm;
				}else if($(this).hasClass("unitAm")){
					unitAm = parseInt($(".unitAm", tr).val().toString().toMoney2());
					supAm = ((Math.round(parseInt(unitAm,10) / 1.1 * 10)) / 10);
					supAm = Math.round(supAm, 10);
					vatAm = unitAm - supAm;
				}else if($(this).hasClass("supAm")){
					if($("#erpBudgetInfo-table tr.on input.vatFg").attr("code") == "1"){
						supAm = parseInt($(".supAm", tr).val().toString().toMoney2());
						unitAm = ((Math.round(parseInt(supAm,10) * 1.1 / 10)) * 10);
						vatAm = unitAm - supAm;
					}else{
						unitAm = parseInt($(".supAm", tr).val().toString().toMoney2());
					}
				}else if($(this).hasClass("vatAm")){
					unitAm = parseInt($(".unitAm", tr).val().toString().toMoney2());
					supAm = parseInt($(".supAm", tr).val().toString().toMoney2());
					vatAm = parseInt($(".vatAm", tr).val().toString().toMoney2());
				}
				if($("#erpBudgetInfo-table tr.on input.vatFg").attr("code") != "1"){
					supAm = unitAm;
					vatAm = 0;
				}
				if($("#txtPurcReqType").attr("code") == "2"){
					var ppsFees = Math.floor(unitAm * 0.0054);
					unitAm += ppsFees;
					$(".ppsFees", tr).val(ppsFees.toString().toMoney());
				}
				
				$(".unitAm", tr).val(unitAm.toString().toMoney());
				$(".supAm", tr).val(supAm.toString().toMoney());
				$(".vatAm", tr).val(vatAm.toString().toMoney());
			},
			blur : function(){
				updatePurcContModT($(this));
			}
		});
		$(".itemType, .itemNm, .standard, .rmkDc", tr).bind({
			change : function(){
				updatePurcContModT($(this));
			}
		});
		$(".nextAm", tr).bind({
			keyup : function(){
				$(this).val($(this).val().toString().toMoney());
			},
			blur : function(){
				updatePurcContModT($(this));
			}
		})
	});
}

function fnTpfDatepickerInit(id){
	var eventEle = $("#" + id);
	eventEle.kendoDatePicker( {
    	format : "yyyy-MM-dd",
    	culture : "ko-KR",
    });
	$("#" + id).attr("disabled", true);
}

/**
 * 콤보박스 초기화
 */
function fnTpfComboBoxInit(groupCode, id, parentEle){
	var commCodeList = fnTpfGetCommCodeList(groupCode);
	var itemType = $("#" + id, parentEle).kendoComboBox({
		dataSource : commCodeList,
		dataTextField: "code_kr",
		dataValueField: "code",
		index: 0
    });
	$('.' + id, parentEle).attr('disabled', true);
}

function fnTpfComboBoxInit2(groupCode, id, parentEle){
	var commCodeList = fnTpfGetCommCodeList(groupCode);
	var itemType = $("." + id, parentEle).kendoComboBox({
		dataSource : commCodeList,
		dataTextField: "code_kr",
		dataValueField: "code",
		index: 0
    });
	$('.' + id, parentEle).attr('disabled', true);
}

commCode = {};
/**
 * 공통코드리스트 조회
 */
function fnTpfGetCommCodeList(groupCode){
	if(commCode[groupCode]){
		return commCode[groupCode];
	}
	var result = {};
	var params = {};
	params.group_code = groupCode;
    var opt = {
    		url     : _g_contextPath_ + "/commcode/getCommCodeList",
            async   : false,
            data    : params,
            successFn : function(data){
            	result = data;
            	commCode[groupCode] = data;
            }
    };
    acUtil.ajax.call(opt);
	return result;
}

function fnPayTypeChange(){
	var payType = $('#payType').val();
	if(payType == "002"){
		$("#spanPayCnt").show();
	}else{
		$("#payCnt").val("1");
		$("#spanPayCnt").hide();
	}
}

/**
 * 첨부파일 선택창 오픈
 * */
function fnFileOpen(fileType){
	$('#fileType').val(fileType);
	$('#attachFile').click();
}

/**
 * 첨부파일 업로드
 * */
function fnTpfAttachFileUpload(obj){
	var targetId = purcContId;
	var targetTableName = 'tpf_purc_cont';
	var fileType = $('#fileType').val();
	if(fileType == '2' || fileType == '3'){
		targetId = fnSetPurcContAttach(targetId, fileType);
		targetTableName = 'tpf_purc_cont_attach';
	}
	var path = 'tpf_purc_cont';
	var fileForm = obj.closest('form');
	var fileInput = obj;
	var fileList = fnCommonFileUpload(targetTableName, targetId, path, fileForm);
	$.each(fileList, function(){
		var span = $('#fileSample td div').clone();
		$('.file_name', span).html(this.fileNm + "." + this.ext);
		$('.attachFileId', span).val(this.attach_file_id);
		$('.fileSeq', span).val(this.fileSeq);
		$('.filePath', span).val(this.filePath);
		$('.fileNm', span).val(this.fileNm + "." + this.ext);
		$('#fileArea'+fileType).append(span);
	});
	fileInput.unbind();
	fileForm.clearForm();
	fileInput.bind({
		change : function(){
			fnTpfAttachFileUpload($(this));
		}
	})
	//fnResizeForm();
}

function fnSetPurcContAttach(targetId, fileType){
	var saveObj = {};
	var resultData = {};
	saveObj.purcReqId = targetId;
	saveObj.fileType = fileType;
	var opt = {
    		url : _g_contextPath_ + "/Ac/G20/Ex/setPurcContAttach.do",
            async: false,
            data : saveObj,
            successFn : function(data){
            	if(data){
                	targetId = data.purcContAttachId;
            	}else{
					alert(NeosUtil.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요"));
            	}
            }
            ,
            failFn : function (request,status,error) {
    	    	alert(NeosUtil.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요")+".\n errorCode :"+request.responseText+"\n");
        	}
    };
	acUtil.ajax.call(opt, resultData);
	return targetId;
}

/**
 * 첨부파일 삭제
 * */
function fnTpfAttachFileDelete(obj){
	if(!confirm('첨부파일을 삭제하시겠습니까?')){
		return;
	}
	var span = $(obj).closest('div');
	var attach_file_id = $('.attachFileId', span).val();
	fnCommonFileDelete(attach_file_id);
	span.remove();
	//fnResizeForm();
}

/**
 * 첨부파일 다운로드
 * */
function fnTpfAttachFileDownload(obj){
	var span = $(obj).closest('div');
	var attach_file_id = $('.attachFileId', span).val();
	var downWin = window.open('','_self');
	downWin.location.href = _g_contextPath_ + '/common/fileDown?attach_file_id='+attach_file_id;
}

function fnTradeInfoSave(id){
	updatePurcContMod();
	if(id == "txt_TR_NM_add"){
		var trNm = $("#txt_TR_NM_add").val();
		var trCd = $("#txt_TR_NM_add").attr("code");
		if($("#addTr" + trCd).length == 0){
			$.ajax({
		        type: "POST"
			    , dataType: "json"
			    , url: getContextPath()+ "/Ac/G20/Ex/insertAddTr.do"
		        , data: {
		        	trNm : trNm,
		        	trCd : trCd,
		        	purcContId : purcContId
		        }
		        , async: false
			    , success: function (obj) {
			    	var span = $('#addTradeTdSample span').clone();
			    	$(".trNmTxt", span).html(trNm);
			    	$(".trCd", span).val(trCd);
			    	$(".trNm", span).val(trNm);
		    		$("#txt_TR_NM_add_span").append(span);
			    }
		    });
		}
		
	}
};

function fnTrDelete(obj){
	if(confirm("거래처를 삭제하시겠습니까?")){
		var span = $(obj).closest("span");
		$.ajax({
			type: "POST"
			, dataType: "json"
			, url: getContextPath()+ "/Ac/G20/Ex/deleteAddTr.do"
			, data: {
				trCd : $(".trCd", span).val(),
				purcContId : purcContId
			}
			, async: false
			, success: function (obj) {
				span.remove();
			}
		});
	}
}

function updatePurcContMod(){
	// 기초금액 낙찰률 추가 20190827 pjm
	if($("#contAm").val() && $("#expectedAm").val()){
		var contAm = parseInt($("#contAm").val().toMoney2());
		var expectedAm = parseInt($("#expectedAm").val().toMoney2());
		var rate = Math.round(contAm/expectedAm*100*1000)/1000;
		$("#rate").val(rate + "%");
	}
	var saveObj = {};
	saveObj.purcContId = purcContId;
	saveObj.modReason = $("#modReason").val();
	saveObj.contDate2 = $("#contDate2").val();
	saveObj.contStartDate2 = $("#contStartDate2").val();
	saveObj.contEndDate2 = $("#contEndDate2").val();
	saveObj.trNm = $("#trNm").val();
	saveObj.trCd = $("#trNm").attr("code");
	saveObj.ceoNm = $("#txt_CEO_NM").val();
	saveObj.regNb = $("#txt_REG_NB").val();
	saveObj.contType = $("#contType").data("kendoComboBox").text();
	saveObj.contTypeCodeId = $("#contType").data("kendoComboBox").value();
	saveObj.payCon = $("#payCon").data("kendoComboBox").text();
	saveObj.payConCodeId = $("#payCon").data("kendoComboBox").value();
	saveObj.payType = $("#payType").data("kendoComboBox").text();
	saveObj.payTypeCodeId = $("#payType").data("kendoComboBox").value();
	saveObj.payCnt = $("#payCnt").val();
	saveObj.refDocKey = $("#refDocKey").val();
	saveObj.refDocTitle = $("#refDocTitle").val();
	saveObj.expectedAm = $("#expectedAm").val();
	saveObj.rate = $("#rate").val();
	var opt = {
    		url : _g_contextPath_ + "/Ac/G20/Ex/updatePurcContMod.do",
            async: false,
            data : saveObj,
            successFn : function(data){
            	if(data){
                	targetId = data.purcContAttachId;
            	}else{
					alert(NeosUtil.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요"));
            	}
            }
            ,
            failFn : function (request,status,error) {
    	    	alert(NeosUtil.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요")+".\n errorCode :"+request.responseText+"\n");
        	}
    };
	acUtil.ajax.call(opt);
}

function updatePurcContModT(eventEle){
	if(!updatePurcContModTVal()){
		return;
	}
	var resultData = {};
	var parentEle = $(eventEle).closest("tr");
    var saveObj = {};    
    saveObj.purc_cont_id = parentEle.attr("purcContId") || "0";
    saveObj.purc_cont_b_id = parentEle.attr("purcContBId") || "0";
    saveObj.purc_cont_t_id = parentEle.attr("purcContTId") || "0";
    saveObj.purc_req_id = parentEle.attr("purcReqId") || "0";
    saveObj.purc_req_b_id = parentEle.attr("purcReqBId") || "0";
    saveObj.purc_req_t_id = parentEle.attr("purcReqTId") || "0";
    saveObj.pps_id_no = $(".ppsIdNo", parentEle).val();
    saveObj.item_type = $("input.itemType", parentEle).not(".k-input").data("kendoComboBox").text();
    saveObj.item_type_code_id = $("input.itemType", parentEle).not(".k-input").data("kendoComboBox").value();
    saveObj.standard = $(".standard", parentEle).val();
    saveObj.contents = $(".contents", parentEle).val();
    saveObj.start_date = $(".startDate", parentEle).val();
    saveObj.end_date = $(".endDate", parentEle).val();
    saveObj.pps_fees = $(".ppsFees", parentEle).val().toString().toMoney2();
    saveObj.purc_tr_type = $("#tableTab .selTab").attr("id");
    /* saveObj.tr_cd = $(".trCd", parentEle).val();
    saveObj.tr_nm = $(".trNm", parentEle).val();
    saveObj.reg_nb = $("", parentEle).val();
    saveObj.ceo_nm = $("ppsIdNo", parentEle).val(); */
    saveObj.item_nm = $(".itemNm", parentEle).val();
    saveObj.item_cnt = $(".itemCnt", parentEle).val();
    saveObj.item_am = $(".itemAm", parentEle).val().toString().toMoney2();
    saveObj.unit_am = $(".unitAm", parentEle).val().toString().toMoney2();
    saveObj.sup_am = $(".supAm", parentEle).val().toString().toMoney2();
    saveObj.vat_am = $(".vatAm", parentEle).val().toString().toMoney2();
    saveObj.rmk_dc = $(".rmkDc", parentEle).val();
    saveObj.next_am = $(".nextAm", parentEle).val().toString().toMoney2();
    /*ajax 호출할 파라미터*/
    var opt = {
    	  url     : _g_contextPath_ + "/Ac/G20/Ex/updatePurcContModT.do"
    	, async   : false
    	, data    : saveObj
    	, successFn : function(data){
    		if(data.result == 'Excess'){
    			alert('요청액을 초과 할 수 없습니다.');
    			return;
    		}
    		var purcContInfo = data.purcContInfo;
    		var abdocuB = data.abdocu_B;
    		var tr = $("#erpBudgetInfo-table tr[abdocu_b_no="+abdocuB.abdocu_b_no+"]");
    		$("#purcContModInfo #contAm").val(purcContInfo.contAm.toString().toMoney());
    		$(".totalAM", tr).html(abdocuB.apply_am.toString().toMoney());
    		$(".nextAm", tr).html(abdocuB.next_am.toString().toMoney());
    		updatePurcContMod();
    	},
    	error: function (request,status,error) {
    		alert(NeosUtil.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요")+".\n errorCode :"+request.responseText+"\n");
        }
    };
    acUtil.ajax.call(opt, resultData);
}

function updatePurcContModTVal(){
	var result = true;
	var tr = $("#erpBudgetInfo-table tr.on");
	var budgetInfo = fnGetBudgetInfo(tr);
	var applyAmInfo = fnGetApplyAm(tr);
	var leftAm = parseInt(budgetInfo.result.LEFT_AM);
	var applyAm = parseInt(applyAmInfo.applyAm);
	var aceptAm = parseInt(applyAmInfo.aceptAm);
	// G20 2.0 수정
	var codeList = getCommCodeList("ERP_TYPE");
	var code = "";
	if(codeList.length > 0 && codeList[0].code){
		code = codeList[0].code;
	}
	if(code == "G20_2.0"){
		var totalUnitAm = 0;
		$.each($("#erpTradeInfo-table .unitAm"), function(){
			totalUnitAm += parseInt($(this).val().toString().toMoney2());
		});
		
		if(leftAm < totalUnitAm){
			alert("총 금액은 예산잔액을 \n초과 할 수 없습니다.");
			return false;
		}
	}else{
		leftAm = leftAm + applyAm;
		var totalUnitAm = 0;
		$.each($("#erpTradeInfo-table .unitAm"), function(){
			totalUnitAm += parseInt($(this).val().toString().toMoney2());
		});
		
		if(leftAm < totalUnitAm){
			alert("총 금액은 예산잔액과 계약금액을 합("+leftAm.toString().toMoney()+"원)을 \n초과 할 수 없습니다.");
			return false;
		}
		/* if(aceptAm > totalUnitAm){
			alert("총 금액은 집행금액 보다 적을 수 없습니다..");
			return false;
		} */
	}
	return result;
}

function delPurcContModT(eventEle){
	var resultData = {};
	var parentEle = $(eventEle).closest("tr");
	var saveObj = {};
	saveObj.purc_cont_id = parentEle.attr("purcContId") || "0";
    saveObj.purc_cont_b_id = parentEle.attr("purcContBId") || "0";
    saveObj.purc_cont_t_id = parentEle.attr("purcContTId") || "0";
    var opt = {
            url : _g_contextPath_ + "/Ac/G20/Ex/delPurcContT.do",
            async:false,
            data : saveObj,
            successFn : function(data){
            	var purcContInfo = data.purcContInfo;
        		var abdocuB = data.abdocu_B;
        		if(!abdocuB){
        			fnTpfGetContMod();
        			return;
        		}
        		var tr = $("#erpBudgetInfo-table tr[abdocu_b_no="+abdocuB.abdocu_b_no+"]");
        		$("#purcContModInfo #contAm").val(purcContInfo.contAm.toString().toMoney());
        		$(".totalAM", tr).html(abdocuB.apply_am.toString().toMoney());
        		fnContBSelect(tr);
        		updatePurcContMod();
            }
    };
    acUtil.ajax.call(opt, resultData);
}

function completePurcContMod(){
	if(!$("#modReason").val()){
		alert("변경사유를 입력하세요.");
		return;
	}
// 	if(onnaraDocs.length < 1){
// 		alert('온나리연동문서를 등록하세요.')
// 		return;
// 	}
// 	if($('#fileArea2 span').length < 1){
// 		alert('계약서를 등록하세요.')
// 		return;
// 	}
// 	if(!$("#refDocKey").val()){
// 		alert("계약변경 보고문서를 선택하세요.");
// 		return;
// 	}
	if(confirm("변경계약을 접수합니다.")){
		var params = {};
	    params.compSeq = $('#compSeq').val();
	    params.approKey = 'CONTMOD_' + $("#purcReqId").val() + '_' + purcContId + '_' + $("#purcContIdOrg").val();
	    params.outProcessCode = 'CONTMOD';
	    params.empSeq = $('#empSeq').val();
	    params.mod = 'W';
	    params.fileKey = makeDjFileKey();
	    onnaraFileToTemp(params.fileKey);
	    params.contentsStr = makeContentsStr();
	    params.title = $('#contTitleOrg').val() + ' 변경계약';
	    var prev_url = location.href.split('&');
	    params.prev_url = prev_url[0] + '&' + prev_url[1] + '&' + prev_url[2] + '&' + prev_url[3];
	    params.prev_name = "정보수정";
	    outProcessLogOn2(params);
	}
}

function makeContentsStr(){
	var html = '';
	html += '<div style="font-family:맑은 고딕;font-size:11pt;text-align:left;">';
	html += '1. 관련 : ';
	$.each(onnaraDocs, function(i){
		html += (i == 0 ? '' : ', ');
		html += this.AUTHORDEPTNAME + '-' + this.DOCNOSEQ + '(' + moment(this.ENDDT.substr(0,8)).format('YYYY.MM.DD') + ')호';
	});
	html += '.';
	html += '<br/>';
	html += '2. ' + $('#contTitleOrg').val() + '  계약을 변경하고자 합니다.';
	html += '<br/>';
	html += '<br/>';
	html += '&nbsp;&nbsp;가. <span style="letter-spacing:0.1px;">사 업 명</span> : ' + $('#contTitleOrg').val();
	html += '<br/>';
	html += '&nbsp;&nbsp;나. 계약업체 : ' + $('#trNm').val();
	html += '<br/>';
	html += '&nbsp;&nbsp;다. 계약기간 : ' + moment($('#contStartDate2Org').val()).format('YYYY.MM.DD') + ' ~ ' + moment($('#contEndDate2Org').val()).format('YYYY.MM.DD');
	html += '<br/>';
	html += '&nbsp;&nbsp;라. 변경내용 : ' + $('#modReason').val();
	html += '<br/>';
	html += '<div style="text-align: right;">(단위 : 원)</div>';
	html += '<table style="width: 100%;">';
	html += '<colgroup>';
	html += '<col width="15%"/>';
	html += '<col width="30%"/>';
	html += '<col width="30%"/>';
	html += '<col width="25%"/>';
	html += '</colgroup>';
	html += '<tr>';
	html += '<th style="background-color: #f9f9f9;border: 1px solid #eaeaea;padding: 5px;text-align: center;">구분</th>';
	html += '<th style="background-color: #f9f9f9;border: 1px solid #eaeaea;padding: 5px;text-align: center;">당초</th>';
	html += '<th style="background-color: #f9f9f9;border: 1px solid #eaeaea;padding: 5px;text-align: center;">변경</th>';
	html += '<th style="background-color: #f9f9f9;border: 1px solid #eaeaea;padding: 5px;text-align: center;">비고</th>';
	html += '</tr>';
	html += '<tr>';
	html += '<td style="border: 1px solid #eaeaea;padding: 5px;text-align: center;">계약기간</td>';
	html += '<td style="border: 1px solid #eaeaea;padding: 5px;text-align: center;">' + moment($('#contStartDate2Org').val()).format('YYYY.MM.DD') + ' ~ ' + moment($('#contEndDate2Org').val()).format('YYYY.MM.DD') + '</td>';
	html += '<td style="border: 1px solid #eaeaea;padding: 5px;text-align: center;">' + moment($('#contStartDate2').val()).format('YYYY.MM.DD') + ' ~ ' + moment($('#contEndDate2').val()).format('YYYY.MM.DD') + '</td>';
	html += '<td style="border: 1px solid #eaeaea;padding: 5px;text-align: center;"></td>';
	html += '</tr>';
	html += '<tr>';
	html += '<td style="border: 1px solid #eaeaea;padding: 5px;text-align: center;">계약금액</td>';
	html += '<td style="border: 1px solid #eaeaea;padding: 5px;text-align: right;">' + $('#contAmOrg').val() + '</td>';
	html += '<td style="border: 1px solid #eaeaea;padding: 5px;text-align: right;">' + $('#contAm').val() + '</td>';
	html += '<td style="border: 1px solid #eaeaea;padding: 5px;text-align: center;"></td>';
	html += '</tr>';
	html += '</table>';
	html += '<br/>';
	html += '<br/>';
	html += '<br/>';
	html += '<span style="display:inline-block;width:40px;">붙 임 </span>1. 용역변경계약서 1부.';
	html += '<br/>';
	html += '<span style="display:inline-block;width:40px;"></span>2. 변경의뢰서 1부.';
	html += '<br/>';
	html += '<span style="display:inline-block;width:40px;"></span>3. 산출내역서 1부.&nbsp;&nbsp;끝.';
	html += '<br/>';
	html += '<br/>';
	html += '</div>';
	return html;
}

function returnPurcContMod(){
	$("#returnDiv").data("kendoWindow").open();
}

function fnReturn(){
	var returnVal = true;
	
	if(!$('#returnReason').val()){
		alert('반려사유를 입력하세요.');
		returnVal = false;
	}
	
	if(!returnVal){
		return;
	}
	if(!confirm('변경계약요청을 반려합니다.')){
		return;
	}
	
	var data = {};
	data.purcContId = purcContId;
	data.returnReason = $('#returnReason').val();
    var opt = {
    		url     : _g_contextPath_ + "/Ac/G20/Ex/updatePurcContModReturn.do",
            async   : false,
            data    : data,
            successFn : function(data){
            	saveOnnaraMapping();
    			window.close();
            }
    };
    acUtil.ajax.call(opt);
}

/**
 * 참조문서 팝업
 */
acG20Code.getRefDoc = function(dblClickparamMap){
	var obj = {};
	obj.deptCd = $("#deptCd").val();
	obj.frDt = $("#frDt").val().replace(/-/gi,"");
	obj.toDt = $("#toDt").val().replace(/-/gi,"");
	
	/*ajax 호출할 파라미터*/
    var opt = {
			url : _g_contextPath_ + "/Ac/G20/Ex/getRefDoc.do",
            stateFn:modal_bg,
            async:true,
            data : obj,
            successFn : function(){
            	/*모달창 가로사이즈 및 타이틀*/
            	var dialogParam = {
            			title : "참조문서",
            			width : "500",
            			count : 4,
						showDiv : "refDoc_Search"
            	};
            	acUtil.dialogForm = "dialog-form-standard";            	
            	acUtil.util.dialog.open(dialogParam);
            	
            	/*모달창 컬럼 지정 및 스타일 지정*/
            	var mainData = acUtil.modalData;
            	var paramMap = {};
            	paramMap.loopData =  mainData.selectList;
            	paramMap.colNames = ["문서번호", "제목", "담당자", "등록일자"];

            	paramMap.colModel = [
            	                       {code : "", text : "cDocnumber", style : {width : "150px"}},
            	                       {code : "", text : "cDititle", style : {width : "150px"}},
            	                       {code : "", text : "userNm", style : {width : "150px"}},
            	                       {code : "", text : "cRiregymd", style : {width : "150px"}}
            	                     ];
            	paramMap.trDblClickHandler_UserDefine = function(index, dblClickparamMap){
            		fnSelectRefDoc(mainData.selectList[index]);
            	};
            	paramMap.dblClickparamMap = dblClickparamMap;
                acUtil.util.dialog.setData(paramMap);
            }
    };
    /*결과 데이터 담을 객체*/
    acUtil.modalData = {};
    acUtil.ajax.call(opt, acUtil.modalData );
};

function fnSelectRefDoc(obj){
	var html = "<a href='#n' style='color:rgb(0, 51, 255)' onclick='refDocView()'>"+obj.cDititle+"</a>";
	$("#refDoc span").html(html);
	$("#refDocKey").val(obj.cDikeycode);
	$("#refDocTitle").val(obj.cDititle);
	updatePurcContMod();
}

function refDocView(){
	var params = {};
    params.compSeq =$('#compSeq').val();
    params.empSeq = $('#empSeq').val();
    params.docId = $("#refDocKey").val();
    params.mod = 'V';
    outProcessLogOn(params);
}

function refDocPopupInit(){
	fnTpfDatepickerInit2("frDt");
	fnTpfDatepickerInit2("toDt");
	
	var today = new Date();
	var frDt = today.getFullYear() + "-" + (today.getMonth() == 0 ? 12 : today.getMonth()) + "-" + today.getDate();
	var toDt = today.getFullYear() + "-" + (today.getMonth()+1) + "-" + today.getDate();
	$("#frDt").data("kendoDatePicker").value(frDt);
	$("#toDt").data("kendoDatePicker").value(toDt);
}

function fnTpfDatepickerInit2(id){
	var eventEle = $("#" + id);
	eventEle.kendoDatePicker( {
    	format : "yyyy-MM-dd",
    	culture : "ko-KR",
    	change : function(){
    		$("#refDocBtn").click();
    	}
    });
	$("#" + id).attr("disabled", true);
}
</script>
<form id="outProcessFormData" action="http://211.192.144.104/gw/outProcessLogOn.do" target="outProcessLogOn"></form>
<input type="hidden" id="compSeq" value="${loginVO.compSeq }"/>
<input type="hidden" id="empSeq" value="${loginVO.uniqId }"/>
<input type="hidden" id="loginId" value="${loginVO.id }"/>
<input type="hidden" id="erpCoCd" value="${loginVO.erpCoCd }"/>
<input type="hidden" id="deptCd" value="${loginVO.orgnztId }"/>
<div class="pop_sign_wrap scroll_y_fix" style="width:1200px;">
    <div class="pop_sign_head">
        <h1><span class="title_NM">변경계약</span></h1>
		<div class="psh_btnbox">
			<div class="psh_right">
				<div class="btn_cen mt8">
					<input type="button" class="psh_btn" id="btnApproval" value="접수" />
					<input type="button" class="psh_btn" id="btnReturnPop" value="반려" />
				</div>
			</div>
		</div>        
    </div>
    <div class="pop_sign_con scroll_on" style="padding:62px 16px 20px 16px;">  

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
					<input type="text" id="txtContTitle" class="" readonly="readonly" disabled="disabled" style="width: 250px;"/>
				</dd>
			</dl>
		</div>
		
		<div class="com_ta2 mt15">
			<div id="grid"></div>
		</div>
		
		<div id="djOnnara" style="height: 100px;"></div>
		<div class="btn_div mt10 cl purcContModDetail">
			<div class="left_div">
				<p class="tit_p mt5 mb0">변경 전 계약</p>
			</div>
			<div class="right_div">
				<div class="controll_btn p0">
				</div>
			</div>
		</div>
		
		<div id="purcContModOrg" class="purcContModDetail">
			<div  class="com_ta2 hover_no mt10">
				<table>
					<colgroup>
						<col width="90"/>
						<col width="300"/>
						<col width="90"/>
						<col width=""/>
						<col width="90"/>
						<col width=""/>
						<col width="90"/>
						<col width="250"/>
					</colgroup>
					<tbody>
						<tr>
							<th>계약명</th>
							<td class="le" colspan="7">
								<input type="text" id="contTitleOrg" style="width: 90%;"/>
							</td>
							
						</tr>
						<tr>
							<th>거래처</th>
							<td class="le" colspan="1">
								<input type="text" id="trNmOrg" style="width: 90%;"/>
							</td>
							<th>계약금액</th>
							<td class="le">
								<input type="text" id="contAmOrg" readonly="readonly" disabled="disabled" style="width: 90%;"/>
							</td>
							<th>계약일</th>
							<td class="le" colspan="1">
								<input type="text" id="contDate2Org" style="width: 90%;"/>
							</td>
							<th>계약기간</th>
							<td class="le" colspan="1">
								<input type="text" id="contStartDate2Org" style="width: 43%;"/> ~ 
								<input type="text" id="contEndDate2Org" style="width: 43%;"/>
							</td>
							<th class="" style="display: none;">기초금액</th>
							<td class="le" style="display: none;">
								<input type="text" id="basicAmOrg" class="" disabled="disabled" style="width: 90%;"/>
							</td>
							<th class="" style="display: none;">예정가격</th>
							<td class="le" style="display: none;">
								<input type="text" id="expectedAmOrg" class="" disabled="disabled" style="width: 90%;"/>
							</td>
							<th class="" style="display: none;">낙찰률</th>
							<td class="le" style="display: none;">
								<input type="text" id="rateOrg" class="" disabled="disabled" style="width: 40%;"/>
							</td>
							<td class="le" style="display: none;">
								<input type="text" id="contTypeOrg" readonly="readonly" style="width: 90%;"/>
							</td>
							<td class="le" colspan="1" style="display: none;">
								<input type="text" id="payConOrg" readonly="readonly" style="width: 90%;"/>
							</td>
							<td class="le" colspan="1" style="display: none;">
								<input type="text" id="payTypeOrg" readonly="readonly" style="width: 60%;"/> 
								<span id="spanPayCntOrg"><input type="text" id="payCntOrg" style="width: 20%;"/> 회</span>
							</td>
						</tr>
						<tr>
							<th>부 거래처</th>
							<td colspan="7" id="addTradeTdOrg" class="le">
								<input type="hidden" id="txt_TR_NM_addOrg" class="txt_TR_NM" />
								<span id="txt_TR_NM_add_spanOrg"></span>
							</td>
						</tr>
						<tr id="addTradeTdSampleOrg" style="display: none;">
							<td></td>
							<td>
								<span>
									<span class="trNmTxt mr10"></span>
									<input class="trCd" type="hidden" value="">
									<input class="trNm" type="hidden" value="">
								</span>
							</td>
						</tr>
						<tr>
							<th>첨부파일</th>
							<td class="le" id="fileAreaOrg3" colspan="7"></td>
						</tr>
						<tr style="display: none;">
							<th>계약서</th>
							<td class="le" id="fileAreaOrg2" colspan="7"></td>
						</tr>
						<tr id="fileSampleOrg" style="display: none;">
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
			</div>
		</div>
		
		<div class="btn_div mt10 cl purcContModDetail">
			<div class="left_div">
				<p class="tit_p mt5 mb0">변경 후 계약</p>
			</div>
			<div class="right_div">
				<div class="controll_btn p0">
				</div>
			</div>
		</div>
		
		<div id="purcContMod" class="purcContModDetail">
			<div  class="com_ta2 hover_no mt10" id="purcContModInfo">
				<table>
					<colgroup>
						<col width="90"/>
						<col width="300"/>
						<col width="90"/>
						<col width=""/>
						<col width="90"/>
						<col width=""/>
						<col width="90"/>
						<col width="150"/>
						<col width="100"/>
					</colgroup>
					<tbody>
						<tr>
							<th>변경사유</th>
							<td class="le" colspan="8">
								<input type="text" id="modReason" style="width: 90%;"/>
								<input type="hidden" id="purcReqId"/>
								<input type="hidden" id="purcContIdOrg"/>
							</td>
						</tr>
						<tr>
							<th>거래처</th>
							<td class="le" colspan="1">
								<input type="text" id="trNm" style="width: 90%;"/>
								<input type="hidden" id="txt_CEO_NM"/>
								<input type="hidden" id="txt_REG_NB"/>
								<a href="javascript:;" class="search-Event-T" id="trPopBtn"><img src="<c:url value='/Images/ico/ico_explain.png' />" alt="검색" title="검색" /></a>
							</td>
							<th>계약금액</th>
							<td class="le">
								<input type="text" id="contAm" readonly="readonly" disabled="disabled" style="width: 90%;"/>
							</td>
							<th>계약일</th>
							<td class="le" colspan="1">
								<input type="text" id="contDate2" style="width: 90%;"/>
							</td>
							<th>계약기간</th>
							<td class="le" colspan="2">
								<input type="text" id="contStartDate2" style="width: 43%;"/> ~ 
								<input type="text" id="contEndDate2" style="width: 43%;"/>
							</td>
							<th class="" style="display: none;">기초금액</th>
							<td class="le" style="display: none;">
								<input type="text" id="basicAm" class="" disabled="disabled" style="width: 90%;"/>
							</td>
							<th class="" style="display: none;">예정가격</th>
							<td class="le" style="display: none;">
								<input type="text" id="expectedAm" class="" style="width: 90%;"/>
							</td>
							<th class="" style="display: none;">낙찰률</th>
							<td class="le" colspan="2" style="display: none;">
								<input type="text" id="rate" class="" disabled="disabled" style="width: 40%;"/>
							</td>
							<td class="le" style="display: none;">
								<input type="text"id="contType" style="width: 90%;"/>
							</td>
							<td class="le" colspan="1" style="display: none;">
								<input type="text"id="payCon" style="width: 90%;"/>
							</td>
							<td class="le" colspan="2" style="display: none;">
								<input type="text" id="payType" style="width: 60%;"/> 
								<span id="spanPayCnt"><input type="text" id="payCnt" style="width: 20%;"/> 회</span>
							</td>
						</tr>
						<tr>
							<th>부 거래처</th>
							<td colspan="7" id="addTradeTd" class="le">
								<input type="hidden" id="txt_TR_NM_add" class="txt_TR_NM" />
								<span id="txt_TR_NM_add_span"></span>
							</td>
							<td>
								<input type="button" onclick="" id="addTradeBtn" value="추가" class="ml4 normal_btn2" />
							</td>
						</tr>
						<tr id="addTradeTdSample" style="display: none;">
							<td></td>
							<td>
								<span>
									<span class="trNmTxt"></span>
									<a onclick="fnTrDelete(this);" href="#n">
										<img alt="" src="<c:url value='/Images/btn/btn_del_reply.gif' />">
									</a>
									<input class="trCd" type="hidden" value="">
									<input class="trNm" type="hidden" value="">
								</span>
							</td>
						</tr>
						<tr>
							<th>첨부파일</th>
							<td class="le" id="fileArea3" colspan="7"></td>
							<td class="">
								<input type="button" onclick="fnFileOpen(3)" 	value="업로드" class="file_input_button ml4 normal_btn2" /> 
							</td>
						</tr>
						<tr style="display: none;">
							<th>계약서</th>
							<td class="le" id="fileArea2" colspan="7"></td>
							<td class="">
								<input type="button" onclick="fnFileOpen(2)" 	value="업로드" class="file_input_button ml4 normal_btn2" /> 
							</td>
						</tr>
						<tr id="fileSample" style="display: none;">
							<td></td>
							<td>
								<div class="mr20" style="">
									<span>
									<img alt="" src="<c:url value='/Images/ico/ico_clip02.png' />">&nbsp;
									<a class="file_name" id="" style="color: rgb(0, 51, 255); line-height: 23px; cursor: pointer;" onclick="fnTpfAttachFileDownload(this);" href="#n"></a>&nbsp;
									<a onclick="fnTpfAttachFileDelete(this);" href="#n">
										<img alt="" src="<c:url value='/Images/btn/btn_del_reply.gif' />">
									</a>
									<input class="attachFileId" type="hidden" value="">
									<input class="fileSeq" type="hidden" value="">
									<input class="filePath" type="hidden" value="">
									<input class="fileNm" type="hidden" value="">
									</span>
								</div>
							</td>
						</tr>
						<tr style="display: none;">
							<th>계약변경<br/>보고문서</th>
							<td class="le" id="refDoc" colspan="7">
								<input type="hidden" id="refDocKey">
								<input type="hidden" id="refDocTitle">
								<span></span>
							</td>
							<td class="">
								<input type="button" id="refDocBtn" value="선택" class="file_input_button ml4 normal_btn2" /> 
							</td>
						</tr>
					</tbody>
				</table>
				<form id="fileForm" method="post" enctype="multipart/form-data">
					<input type="file" id="attachFile" name="file_name" value="" class="hidden" />
					<input type="hidden" id="fileType" name="fileType" value="" class="hidden" />
				</form>
			</div>
			<div class="com_ta2 hover_no mt10">
		    	<table id="budgetInfo">
					<colgroup>
						<col width="90"/>
						<col width=""/>
						<col width="90"/>
						<col width=""/>
						<col width="90"/>
						<col width=""/>
						<col width="90"/>
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
						<td id="td_veiw_OPEN_AM" style="color: blue; font-weight: bold;"></td>
						<th>집행액</th>
						<td id="td_veiw_APPLY_AM" style="color: blue; font-weight: bold;"></td>
						<th>요청액</th>
						<td id="td_veiw_REFER_AM" style="color: blue; font-weight: bold;"></td>
						<th>예산잔액</th>
						<td id="td_veiw_LEFT_AM" style="color: blue; font-weight: bold;"></td>
					</tr>
				</table>
			</div>
			
			<div class="com_ta2 mt10">
				<table  id="erpBudgetInfo" style="width: auto;">
					<colgroup>
						<col width="12%">
						<col width="12%">
						<col width="20%">
						<col width="8%">
						<col width="8%">
						<col width="9%">
						<col width="9%">
						<col width="10%">
					</colgroup>
					<thead>
						<tr>
							<th width="">예산회계단위</th>
							<th width="">프로젝트</th>
							<th width="">예산과목</th>
							<th width="">과세구분</th>
							<th width="" style="display: none;">환원가능여부</th>
							<th width="">금액</th>
							<th width="">내년예산</th>
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
			    		<input type="text" class="non-requirement divNm" id="" style="width: 90%;" disabled="disabled">
			    	</td>
			    	<td width="">
			    		<input type="text" class="non-requirement mgtNm" id="" style="width: 90%;" disabled="disabled">
			    		<input type="hidden" class="non-requirement bottomNm" id="" style="width: 90%;" disabled="disabled">
			    	</td>
			        <td width="" id="budget-td">
			            <input type="text" style="width:45%;" id="" class="non-requirement bgtNm1" readonly="readonly"  disabled="disabled"/>
			            <input type="text" style="width:45%;" id=""  class="requirement bgtNm2" tabindex="10001" readonly="readonly"  disabled="disabled"/>
			        </td>
			        <td width=""><input type="text" style="width:95%;" id=""   tabindex="10003" class="non-requirement vatFg" disabled="disabled"/></td>
			        <td width="" style="display: none;">
			        	<input type="checkbox" id="" class="non-requirement returnYn" checked="checked" disabled="disabled"/>
			        </td>
			        <td width="">
			        	<span id="" class="totalAM"></span>
			        </td>
			        <td width="">
			        	<span id="" class="nextAm"></span>
			        </td>
			        <td width="">
			        	<input type="text" style="width:82%;" id="" CODE="empty" tabindex="10006" class="non-requirement rmkDc" part="budget" disabled="disabled"/>
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
					<div class="p0 com_ta2 hover_no">
						<span class="cl fr" id="referConfer"></span>
					</div>
				</div>
			</div> 
		
			<div class="com_ta2">
				<table  id="erpTradeInfo" style="width: auto;">
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
							<th width="">내년예산</th>
							<th width="">비고</th>
							<th width=""></th>
						</tr>
					</thead>
					<tbody id="erpTradeInfo-table">
	                </tbody>
				</table>
			</div>
			
			<table id="erpTradeInfo-tablesample" style="display:none">
				<tr>
					<td>
						<input type="text" class="ppsIdNo" style="width: 90%"/>
					</td>
					<td>
						<input type="text" class="itemType" style="width: 90%" name="itemType"/>
					</td>
					<td>
						<input type="text" class="itemNm" style="width: 90%"/>
					</td>
					<td>
						<input type="text" class="itemCnt" style="width: 90%"/>
					</td>
					<td>
						<input type="text" class="standard" style="width: 90%"/>
					</td>
					<td>
						<input type="text" class="contents" style="width: 90%"/>
					</td>
					<td>
						<input type="text" class="itemAm ri" style="width: 85%"/>
					</td>
					<td>
						<input type="text" class="unitAm ri" style="width: 85%"/>
					</td>
					<td>
						<input type="text" class="supAm ri" style="width: 85%"/>
					</td>
					<td>
						<input type="text" class="vatAm ri" style="width: 85%"/>
					</td>
					<td>
						<input type="text" class="ppsFees ri" style="width: 85%"/>
					</td>
					<td>
						<input type="text" class="nextAm ri" style="width: 85%"/>
					</td>
					<td>
						<input type="text" class="rmkDc" style="width: 90%"/>
					</td>
					<td class="">
						<input type="button" onclick="" 	value="저장" class="ml4 normal_btn2 saveBnt" /> 
						<input type="button" onclick="" 	value="삭제" class="ml4 normal_btn2 delBnt" /> 
					</td>
				</tr>
    		</table>
		</div>
    </div><!-- //pop_con -->
</div>

<div id="dialog-form-standard" style="display:none">
<div class="pop_wrap_dir" >
    <div class="pop_head">
        <h1></h1>
        <a href="#n" class="clo popClose"><img src="<c:url value='/Images/btn/btn_pop_clo02.png' />" alt="" /></a>
    </div>
    <div class="pop_con">       
        <!-- 사웝검색 box -->
        <div class="top_box" style="overflow:hidden;display:none;" id="deptEmp_Search" >
            <dl class="dl2">
                <dt class="mr0">
                        <input type="checkbox" name="userAllview" id="userAllview" class="" value="1" >
                        <label class="" for="userAllview" style=""><%=BizboxAMessage.getMessage("TX000009909","모든예산회계단위")%></label>
				</dt>
			</dl>
			<dl class="dl2">
				<dt class="mt2"><%=BizboxAMessage.getMessage("TX000016505","범위")%> : </dt>
				<dd>
						<input type="radio" name="B_use_YN"  id="B_use_YN_2" value="2"  class="">
                        <label class="mt3" for="B_use_YN_2" style=""><%=BizboxAMessage.getMessage("TX000000862","전체")%></label>
				</dd>
				<dd>
						<input type="radio" name="B_use_YN"  id="B_use_YN_1" value="1"  class="" checked="checked">
                        <label class="mt3" for="B_use_YN_1" style="" ><%=BizboxAMessage.getMessage("TX000004252","기준일")%> </label>
				</dd>
				<dd> <input type="text" name="BASIC_DT"  id="BASIC_DT"  value="${basic_dt }"  style="width: 80px;"/></dd>
				<dd><input type="button" id="user_Search" value="<%=BizboxAMessage.getMessage("TX000000899","조회")%>" /></dd>
            </dl>
        </div>
        
        
        <!-- 채주사원 등록  -->
        <div class="top_box" style="overflow:hidden;display:none;" id="EmpTrade_Search">
            <dl class="dl2">
                <dt class="mr0">
                        <%=BizboxAMessage.getMessage("TX000016505","범위")%>   :  
                         <input type="radio" name="B_use_YN2"  id="B_use_YN2_2"  value="2" />
                         <label  for="B_use_YN2_2" class="mR5"><%=BizboxAMessage.getMessage("TX000000862","전체")%></label>
                         <input type="radio" name="B_use_YN2" id="B_use_YN2_1"  value="1" checked="checked" /> 
                         <label  for="B_use_YN2_1" class="mR5"><%=BizboxAMessage.getMessage("TX000004252","기준일")%> </label>   
                         <input type="text" name="P_STD_DT"  id="P_STD_DT"  value="${basic_dt }"  style="width: 80px;"> 
                         <a href="javascript:;"  id="user_Search2" ><img src=" <c:url value='/Images/btn/search_icon2.png'/>" alt="<%=BizboxAMessage.getMessage("TX000000899","조회")%>" /></a>
                </dt>                
            </dl>
        </div>
        
        <!-- 예산검색 -->     
        <div class="top_box" style="overflow:hidden;display:none;" id="Budget_Search">
            <dl class="next">
                <dt style="width:100px;" class="en_w145">
                         <%=BizboxAMessage.getMessage("TX000005289","예산과목표시")%> :
                 </dt>
                 <dd>                         
                        <input type="radio" name="OPT_01" value="2"  id="OPT_01_2" class="k-radio " checked="checked" />
                        <label class="k-radio-label" for="OPT_01_2" style=";"><%=BizboxAMessage.getMessage("TX000005290","당기 편성된 예산과목만 표시")%></label>
                  </dd>
                  <dd>      
                        <input type="radio" name="OPT_01" value="1" id="OPT_01_1" class="k-radio" />
                        <label class="k-radio-label" for="OPT_01_1" style=""><%=BizboxAMessage.getMessage("TX000005112","모든 예산과목 표시")%></label>
                  </dd>
                  <dd class="en_mt3">      
                        <input type="radio" name="OPT_01" value="3" id="OPT_01_3" class="k-radio" />
                        <label class="k-radio-label" for="OPT_01_3" style=""><%=BizboxAMessage.getMessage("TX000005291","프로젝트 기간 예산 편성된 과목만 표시")%></label>
                  </dd>
            </dl>
            <dl class="next2 en_mt0">
                <dt style="width:100px;" class="en_w145">
                         <%=BizboxAMessage.getMessage("TX000005486","사용기한")%> : 
                </dt>
                <dd> 
                        <input type="radio" name="OPT_02" value="1" id="OPT_02_1" class="k-radio"  checked="checked" />
                        <label class="k-radio-label"  for="OPT_02_1" style=""><%=BizboxAMessage.getMessage("TX000004225","모두표시")%></label>
                        <input type="radio" name="OPT_02" value="2" id="OPT_02_2" class="k-radio" />
                        <label class="k-radio-label"  for="OPT_02_2" style=""><%=BizboxAMessage.getMessage("TX000009907","사용기한경과분 숨김")%></label>
                </dt>                
            </dl>
            <div class="mt14 ar text_blue posi_ab" id="deptEmp_SearchHint" style="bottom:10px;right:10px;display:none;" >※ 아래 (  ) 안에 명칭은 ERP 예산단계를 의미합니다.</div>            
        </div>
        
        <div class="top_box" style="overflow:hidden;display:none;" id="Trade_Search">
            <dl class="dl2">
                <dt class="mr0">
                <input type="checkbox" id="tradeAllview"/> <%=BizboxAMessage.getMessage("TX000016507","모든 거래처 보여주기")%> 
                </dt>
            </dl>
        </div>      
        
        <div class="top_box" style="overflow:hidden;display:none;" id="refDoc_Search">
            <dl class="dl2">
                <dt class="mr3">
                	기간 
                </dt>
                <dd>
                <input type="text" id="frDt"/> ~
                <input type="text" id="toDt"/>
                </dd>
            </dl>
        </div>
                                       
        <div class="com_ta2 mt10 ova_sc_all cursor_p"  style="height:340px;" id="dialog-form-standard-bind">
        </div>

    </div><!-- //pop_con -->
</div><!-- //pop_wrap -->
</div>

<div id="dialog-form-background" class="modal" style="display:none;">
<div id="window" style="display: none;"></div>
<div id="recvDetail"  style="z-index:800000; display:none;background-color: #FFFFFF;position:absolute;  top:120px; margin-left:100px;" ></div>

<div id="returnDiv" style="text-align: center;padding: 10px;">
	<input type="text" id="returnReason" style="width: 95%;"/>
	<br/>
	<br/>
	<input type="button" id="btnReturn" value="반려"/>
</div>
