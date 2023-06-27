<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<jsp:useBean id="year" class="java.util.Date" />
<jsp:useBean id="mm" class="java.util.Date" />
<jsp:useBean id="dd" class="java.util.Date" />
<jsp:useBean id="weekDay" class="java.util.Date" />
<jsp:useBean id="nowDate" class="java.util.Date" />
<fmt:formatDate value="${nowDate}" var="nowDate" pattern="yyyy-MM-dd" />
<fmt:formatDate value="${year}" var="year" pattern="yyyy" />
<fmt:formatDate value="${mm}" var="mm" pattern="MM" />
<fmt:formatDate value="${dd}" var="dd" pattern="dd" />
<fmt:formatDate value="${weekDay}" var="weekDay" pattern="E" type="date" />
<script type="text/javascript" src='<c:url value="/js/ac/acUtil.js"></c:url>'></script>
<script type="text/javascript" src="<c:url value='/js/jquery.form.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/jszip.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/shieldui-all.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/common/postcode.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/kukgoh/kukgohUtil.js' />"></script>


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
</head>
<style type="text/css">
.next2 dt{
text-align:right;
}
.location_info ul{
margin:0 0 0 0;
}
.k-header .k-link {
	text-align: center;
}
.invoice{
background-color:#fff;
}

.k-grid-content>table>tbody>tr {
	text-align: center;
}

.k-grid th.k-header, .k-grid-header {
	background: #F0F6FD;
}
.customer-photo{
	width : 70px;
	height : auto;
}
            .demo-section.k-content,
            html.k-material .demo-section.k-content {
                overflow: hidden;
                padding: 0;
                border: 0;
                box-shadow: none;
            }
            
            tooltip {
                position: relative;
                width: 692px;
                height: 480px;
                margin: 0 auto;
            }
            tooltip span {
                cursor: pointer;
                position: absolute;
                display: block;
                width: 12px;
                height: 12px;
                background-color: #fff600;
                -moz-border-radius: 30px;
                -webkit-border-radius: 30px;
                border-radius: 30px;
                border: 0;
                -moz-box-shadow: 0 0 0 1px rgba(0,0,0,0.5);
                -webkit-box-shadow: 0 0 0 1px rgba(0,0,0,0.5);
                box-shadow: 0 0 0 1px rgba(0,0,0,0.5);
                -moz-transition:  -moz-box-shadow .3s;
                -webkit-transition:  -webkit-box-shadow .3s;
                transition:  box-shadow .3s;
            }

            tooltip span:hover {
                -moz-box-shadow: 0 0 0 15px rgba(0,0,0,0.5);
                -webkit-box-shadow: 0 0 0 15px rgba(0,0,0,0.5);
                box-shadow: 0 0 0 15px rgba(0,0,0,0.5);
                -moz-transition:  -moz-box-shadow .3s;
                -webkit-transition:  -webkit-box-shadow .3s;
                transition:  box-shadow .3s;
            }

            #docTitle { top: 266px; left: 494px; }
#pjtNm { top: 266px; left: 494px; }
#abgtNm { top: 266px; left: 494px; }
#korNm { top: 266px; left: 494px; }
#gisuDt { top: 266px; left: 494px; }
#gisuSeq { top: 266px; left: 494px; }
#divNm { top: 266px; left: 494px; }
#abgtNm { top: 266px; left: 494px; }
#unitAm { top: 266px; left: 494px; }
#bottomNm { top: 266px; left: 494px; }
#setFgNm { top: 266px; left: 494px; }
#vatFgNm { top: 266px; left: 494px; }
#kukgoPjtNm { top: 266px; left: 494px; }
#docNumber { top: 266px; left: 494px; }
#pjtNm { top: 266px; left: 494px; }
#abgtNm { top: 266px; left: 494px; }
            #docTitle:hover,
            #pjtNm:hover,
            #abgtNm:hover,
#korNm:hover,
#gisuDt:hover,
#gisuSeq:hover,
#divNm:hover,
#abgtNm:hover,
#unitAm:hover,
#bottomNm:hover,
#setFgNm:hover,
#vatFgNm:hover,
#kukgoPjtNm:hover,
#docNumber:hover,
#pjtNm:hover,
#abgtNm:hover                
            { z-index: 10; }
.top_box input[readonly]{
	background-color : #f2f2f2;
}          

</style>
<body>
	<input type="hidden" id="nowMonth" value="${year}${mm}" />
	<input type="hidden" id="dayOrTimeGubun" value="0" />

<!-- Init -->
<script type="text/javascript">

var resultJson = ${resultJsonStr};
var dataJson = ${dataJsonStr};
var dataJsonArr = "";

$(document).ready(function() {
	
	$('#PROCESS_RESULT_MSSAGE').val(resultJson.PROCESS_RESULT_MSSAGE);
	
	$('#popUp').kendoWindow({
		width : "1000px",
		height : "450px",
		visible : false,
		modal : true,
		actions : [ "Close" ],
	}).data("kendoWindow").center();
	
	$('#cancle2').on('click', function (){
		$('#popUp').data('kendoWindow').close();
	});
	
	$('#loadingPop').parent().find('.k-window-action').css("visibility", "hidden");
 		
		$('#loadingPop').kendoWindow({
		     width: "443px",
		     visible: false,
		     modal: true,
		     actions: [
		    	 
			     ],
		     close: false
		 }).data("kendoWindow").center();	 	
		
        var tooltip = $("#tooltip").kendoTooltip({
            filter: "span",
            width: 120,
            position: "top",
            animation: {
            	open: {
            		effects: "zoom",
            		duration: 150
            	}
            }
        }).data("kendoTooltip");
		
        $('#EXCUT_REQUST_DE').kendoDatePicker({
	        start: "month",
	        depth: "month",
	        format: "yyyy-MM-dd",
			parseFormats : ["yyyy-MM-dd"],
	        culture : "ko-KR",
	        dateInput: true
	    });
        
 		$('#filePop').kendoWindow({
		    width: "400px",
		    title: '첨부파일 확인',
		    visible: false,
		    modal : true,
		    actions: [
		        "Close"
		    ],
		}).data("kendoWindow").center(); 
        
        $('#btnClosePage').click(function() {
        	window.close();
        });     
        
        var kukhoStateYN = "${data.KUKGO_STATE == '미전송' ? 'N' : 'Y'}";

        if(kukhoStateYN == 'N'){
			$('#btnReSubmit').css('display','none');
        	$('#btnSubmit').css("disabled", '');
        	$('#insertFileBtn').css("display", '');

        }else if(kukhoStateYN == 'Y'){
        	
        	$('#insertFileBtn').css("display", 'none');
			$('#btnSubmit').css("display", 'none');
        	$('#btnReSubmit').css('display','');
        } 
        
        var evidence = JSON.parse('${resultMap.evidence}'); 
        evidence.unshift({CMMN_DETAIL_CODE_NM : "선택", CMMN_DETAIL_CODE : ""});
		
		$("#PRUF_SE_CODE").kendoComboBox({
		      dataSource: evidence,
		      dataTextField: "CMMN_DETAIL_CODE_NM",
			  dataValueField: "CMMN_DETAIL_CODE",
			  index: 0,
			  select : fn_prufSeCode, // select 하면 발생하는 이벤트
			  change : onChange,
		});	
		
        var customerGb = JSON.parse('${resultMap.customerGb}');
        customerGb.unshift({CMMN_DETAIL_CODE_NM : "선택", CMMN_DETAIL_CODE : ""});
        
		$("#BCNC_SE_CODE").kendoComboBox({
		      dataSource: customerGb,
		      dataTextField: "CMMN_DETAIL_CODE_NM",
			  dataValueField: "CMMN_DETAIL_CODE",
			  index: 0,
			  select : fn_customerGb
		});	
		
        var depositGb = JSON.parse('${resultMap.depositGb}');
        depositGb.unshift({CMMN_DETAIL_CODE_NM : "선택", CMMN_DETAIL_CODE : ""});
        
		$("#TRANSFR_ACNUT_SE_CODE").kendoComboBox({
		      dataSource: depositGb,
		      dataTextField: "CMMN_DETAIL_CODE_NM",
			  dataValueField: "CMMN_DETAIL_CODE",
			  index: 0,
			  select : fn_depositGb
		});	
	
		//사유
        var depositGbCause = JSON.parse('${resultMap.depositGbCause}');
        depositGbCause.unshift({CMMN_DETAIL_CODE_NM : "사유", CMMN_DETAIL_CODE : ""});
		$("#SBSACNT_TRFRSN_CODE").kendoComboBox({
		      dataSource: depositGbCause,
		      dataTextField: "CMMN_DETAIL_CODE_NM",
			  dataValueField: "CMMN_DETAIL_CODE",
			  index: 0,
			  select : fn_depositGbCause
		});
        
		//TRANSFR_ACNUT_SE_CODE
		$("#btnGetPrufSeNo").on("click", function(){
			var aa = $('#ETXBL_CONFM_NO').val();
			console.log(aa);
			if(check(aa)){
				data = {
						BSNSYEAR : $('#BSNSYEAR').val()
						,FILE_ID : $('#BSNSYEAR').val()
						,DDTLBZ_ID : $('#DDTLBZ_ID').val()
						,EXC_INSTT_ID : $('#EXC_INSTT_ID').val()
						,ETXBL_CONFM_NO : $('#ETXBL_CONFM_NO').val()		
						,EMP_SEQ : $('#empSeq').val()
				}
				$.ajax({
					url : "<c:url value='/kukgoh/requestInvoice' />",
					data : data,
					type : 'POST',
					success : function(result) {
					}	
				});
			}
		});
		
		$('#pin_no1').on('keyup', function(){
			if($(this).val().length == 6){
				$('#pin_no2').focus();
			}
		});
		
		//전송
		$('#btnSubmit').on('click', function (){
			fn_btnSubmit();
		});
		
		//재전송
		$('#btnReSubmit').on('click', function (){
			fn_btnCancelSubmit();
		});
		
		$('#docView').on('click', function (){
			var docId = '${data.C_DIKEYCODE}';
			fn_docViewPop2(docId);

		});
		
		$('#gisuDt').val(fn_formatDate($('#gisuDt').val()));
		$('#unitAm').val(fn_formatMoney($('#unitAm').val()));
		
		if($('#stateYn').val() == 'Y'){
			$('#btnRequestResolution').hide();
		}	
		
		$('#BCNC_BANK_CODE_NM').dblclick(function(){
			$('#subPopUp').data("kendoWindow").open();
			$("#bankGrid").data('kendoGrid').dataSource.read();
		});
		
		$('#subPopUp').kendoWindow({
		    width: "400px",
		    height: "550px",
		    title: '금융기관 코드',
		    visible: false,
		    modal : true,
		    actions: [
		        "Close"
		    ],
		    position: {
		        top: "200px", // or "100px"
		        left: "20%"
		      }
		}).data("kendoWindow").center();
		
		$(function() {
			fn_setInit();
			cardGrid();
			cardNoGrid();

			$("#cardNoPopup").kendoWindow({
				width : "700px",
				height : "700px",
				visible : false,
				modal: true,
				actions : [ "Close" ]
			}).data("kendoWindow").center();

			$("#cardPopup").kendoWindow({
				width : "1200px",
				height : "700px",
				visible : false,
				modal: true,
				actions : [ "Close" ]
			}).data("kendoWindow").center();

			$("#prdUseStart").kendoDatePicker({
		        start: "month",
		        depth: "month",
		        format: "yyyy-MM-dd",
				parseFormats : ["yyyy","MM","dd"],
		        culture : "ko-KR",
		        dateInput: true
		    });

			$("#prdUseEnd").kendoDatePicker({
		        start: "month",
		        depth: "month",
		        format: "yyyy-MM-dd",
				parseFormats : ["yyyy","MM","dd"],
		        culture : "ko-KR",
		        dateInput: true
		    });
			
			var date = new Date();
			
			$("#prdUseStart").val((date.getMonth() === 0 ? date.getFullYear() - 1 : date.getFullYear()) + "-" + addZero(date.getMonth()) + "-01");
			$("#prdUseEnd").val(date.getFullYear() + "-" + addZero(date.getMonth() + 1) + "-" + addZero(date.getDate()));

			$("#PRUF_SE_NO").on("click", function() { // #cardPopup 보조금 전용 카드 선택시 승빈번호 조회 팝업
				
				var selectedPrufCode = $('#PRUF_SE_CODE').data("kendoComboBox").select();
			
				if (selectedPrufCode == 1) {
					$('#popUp').data('kendoWindow').open();
					invoiceMainGrid();
					// 세금계산서 전송 팝업 ㄱㄱ
				} else if (selectedPrufCode == 3) {
					$("#cardPopup").data("kendoWindow").open();
				}
			});
		});

			var openWin;
			$(document).on('dblclick', '#bankGrid .k-grid-content tr', function(){
				var subPopUpData = $("#bankGrid").data('kendoGrid').dataItem(this);
					//프로젝트			
					$('#BCNC_BANK_CODE').val(subPopUpData.CMMN_DETAIL_CODE);
					$('#BCNC_BANK_CODE_NM').val(subPopUpData.CMMN_DETAIL_CODE_NM);
					
					$('#subPopUp').data("kendoWindow").close();
			});
			function fn_backClick(){
				$('#subPopUp').data("kendoWindow").open();
				$("#bankGrid").data('kendoGrid').dataSource.read();
			}
	});
	
</script>

<!-- BANK 그리드 -->
<script type="text/javascript">
$(function() {
	bankGrid();
});

function fn_backClick(){
	$('#subPopUp').data("kendoWindow").open();
	$("#bankGrid").data('kendoGrid').dataSource.read();
}

function bankGrid(){
	var bankGrid = $("#bankGrid").kendoGrid({
	    dataSource: bankGridDataSource,
	    height: 450,
 	    filterable: {
            mode: "row"
        },
 	    columns: [
    	{
    		field: "CMMN_DETAIL_CODE",
	        title: "은행코드",
	        width: "50%",
 	        filterable: {
                cell: {
                    operator: "contains",
                   	showOperators: false
                }
            } 
	    },{
	    	field: "CMMN_DETAIL_CODE_NM",
	        title: "은행명",
 	        filterable: {
                cell: {
                    operator: "contains",
                   	showOperators: false
                }
            } 
	    }]
	}).data("kendoGrid");
}

var bankGridDataSource = new kendo.data.DataSource({
	serverPaging: true,
    transport: { 
        read:  {
            url: _g_contextPath_+"/kukgoh/getMainGrid",
            dataType: "json",
            type: 'post'
        },
      	parameterMap: function(data, operation){
        	
        	data.CMMN_CODE = '1070'
        	
     		return data;
     	}
    },
    schema: {
        data: function(response) {
          return response.list;
        },
      }
});	
</script>

<!-- functions -->
<script type="text/javascript">

function makeSendParam() {
	
	var array = [];
	
	dataJson.EXCUT_PRPOS_CN = $('#EXCUT_PRPOS_CN').val()
	dataJson.PRDLST_NM = $('#PRDLST_NM').val()
	dataJson.PRUF_SE_NO = $('#PRUF_SE_NO').val()
	dataJson.EXCUT_REQUST_DE = $('#EXCUT_REQUST_DE').val().replace(/\-/g,'');
	dataJson.BCNC_SE_CODE = $('#BCNC_SE_CODE').val()
	dataJson.PRUF_SE_CODE =  $('#PRUF_SE_CODE').val()
	dataJson.BCNC_CMPNY_NM = $('#BCNC_CMPNY_NM').val()
	dataJson.BCNC_RPRSNTV_NM = $('#BCNC_RPRSNTV_NM').val()
	dataJson.BCNC_TELNO = $('#BCNC_TELNO').val()
	dataJson.BCNC_BIZCND_NM = $('#BCNC_BIZCND_NM').val().replace(/\-/g,'')
	dataJson.BCNC_INDUTY_NM = $('#BCNC_INDUTY_NM').val()
	dataJson.BCNC_ADRES = $('#BCNC_ADRES').val();
	dataJson.BCNC_BANK_CODE = $('#BCNC_BANK_CODE').val()
	dataJson.BCNC_BANK_CODE_NM = $('#BCNC_BANK_CODE_NM').val()
	dataJson.BCNC_ACNUT_NO = $('#BCNC_ACNUT_NO').val().replace(/\-/g,'')
	dataJson.TRANSFR_ACNUT_SE_CODE = $('#TRANSFR_ACNUT_SE_CODE').val()
	dataJson.SBSACNT_TRFRSN_CODE = $('#SBSACNT_TRFRSN_CODE').val()
	dataJson.SBSACNT_TRFRSN_CN = $('#SBSACNT_TRFRSN_CN').val()
	dataJson.SBSIDY_BNKB_INDICT_CN = $('#SBSIDY_BNKB_INDICT_CN').val()
	dataJson.BCNC_BNKB_INDICT_CN = $('#BCNC_BNKB_INDICT_CN').val();
	dataJson.PIN_NO_1 =  $('#PIN_NO_1').val();
	dataJson.PIN_NO_2 =  $('#PIN_NO_2').val();
	dataJson.PIN_NO = $('#PIN_NO_1').val() + "" + $('#PIN_NO_2').val() + "000000";	
	dataJson.APPLY_DIV = '★',
	dataJson.INSERT_IP = '',
	dataJson.INSERT_DT = '',
	dataJson.OUT_TRNSC_ID = '',
	dataJson.OUT_CNTC_SN = '',
	dataJson.OUT_CNTC_CREAT_DT = '',
	dataJson.OUT_YN = '',
	dataJson.OUT_MSG = '',
	dataJson.targetId = "" + $('#gisuDt').val().replace(/\-/g,'') +  pad($('#gisuSeq').val(), 4) + ""+ pad(dataJson.LN_SQ, 2)
	
	array.push(dataJson);
	
	dataJsonArr = array;
}

function addZero(num) {
	num = parseInt(num);
	
	if (num === 0) {
		return '12';
	}
	
	return num > 9 ? num : "0" + num;
}

// 증빙선택 onChange
function onChange(e) {
	var cb = $("#PRUF_SE_CODE").data("kendoComboBox");
	
	if (cb.value() === "999") {
		$('#EXCUT_REQUST_DE').val(fn_formatDate('${data.DOC_REGDATE}'));
	} else {
		$('#EXCUT_REQUST_DE').val('');
	}
}

// 승인번호 조회
function searchBtn() {
	/*
	var selectedPrufCode = $('#PRUF_SE_CODE').data("kendoComboBox").select();
	
	if (selectedPrufCode == 1 || selectedPrufCode == 2) {
		$('#popUp').data('kendoWindow').open();
		invoiceMainGrid();
		// 세금계산서 전송 팝업 ㄱㄱ
	} else if (selectedPrufCode == 3) {
		$("#cardPopup").data("kendoWindow").open();
	}
	*/
	
	var selectedPrufVal = $('#PRUF_SE_CODE').data("kendoComboBox").value();
	var selectedPrufCode = $('#PRUF_SE_CODE').data("kendoComboBox").select();
	
	if (selectedPrufVal == "001" || selectedPrufVal == "002") {
		$('#popUp').data('kendoWindow').open();
		invoiceMainGrid();
		// 세금계산서 전송 팝업 ㄱㄱ
	} else if (selectedPrufVal == "004") {
		$("#cardPopup").data("kendoWindow").open();
	}
}

//초기화
function fn_setInit(){
	
	$('#attachLnSeq').val(pad(dataJson.LN_SQ, 2));
	
	fn_setInfo(dataJson);
	fn_initTextBox(dataJson);
	fileCountChenck();
	fn_selectEffect(dataJson);
	
	if (dataJson.BCNC_SE_CODE === '003') {
		$('#html_div_lsft_no').hide();
		$('#html_div_pin_no').show();
	} else {
		$('#html_div_lsft_no').show();
		$('#html_div_pin_no').hide();
	}
	//$('#TRANSFR_ACNUT_SE_CODE').val();
}

function fn_selectEffect(data) {
	
	var purcSeCode = data.PRUF_SE_CODE;
	
	$('#attachLnSeq').val(pad(data.LN_SQ, 2));
	
	if(purcSeCode == "1" || purcSeCode == "001"){
		fn_selectElecInvoice();
	}else if(purcSeCode =="002" || purcSeCode =="2"){
		fn_selectNomalInvoice();
	}else if(purcSeCode == '004'){
		fn_selectCard();
	}else if(purcSeCode == "999"){
		fn_selectEtc();
	}
}

//증빙선택
function fn_prufSeCode(e){
	var dataItem = this.dataItem(e.item.index());

	if (dataItem.CMMN_DETAIL_CODE == "1" || dataItem.CMMN_DETAIL_CODE =="001" ) {
		fn_selectElecInvoice();
	} else if (dataItem.CMMN_DETAIL_CODE =="2" || dataItem.CMMN_DETAIL_CODE == "002") {
		fn_selectNomalInvoice();
	} else if (dataItem.CMMN_DETAIL_CODE == '004') {
		console.log("보조금전용카드 선택");
		fn_selectCard();
	} else if (dataItem.CMMN_DETAIL_CODE == "999") {
		console.log("기타 선택");
		fn_selectEtc();
	} else if (dataItem.CMMN_DETAIL_CODE_NM === "선택") {
		fn_selectEtc();
	}
}

//거래처 구분
function fn_customerGb(e) {
	var dataItem = this.dataItem(e.item.index());
	var CMMN_DETAIL_CODE = dataItem.CMMN_DETAIL_CODE;
	console.log('거래처 구분');
	console.log(dataItem);
	$('#html_cmpny_name').text("거래처명");
	$('#html_cmpny_no').html("<img src=\"<c:url value='/Images/ico/ico_check01.png'/>\" alt='' />사업자등록번호");
	$('#html_div_lsft_no').show();
	$('#html_div_pin_no').hide();
	$('#html_bcnc_cmpny_cnd_ind').show();
	
	if (CMMN_DETAIL_CODE == '001') {
	//법인사업자	
		fn_setCustomerGbCompany()
	} else if (CMMN_DETAIL_CODE == '002') {
	//개인사업자	
		fn_setCustomerGbCompany()
	} else if (CMMN_DETAIL_CODE == '003') {
	//개인
		fn_setCustomerGbPerson();
	} else if (CMMN_DETAIL_CODE == '004') {
	//해외	
		fn_setCustomerGbCompany()
	}
}

//이체구분 선택
function fn_depositGb(e){
	var dataItem = this.dataItem(e.item.index());
	var CMMN_DETAIL_CODE = dataItem.CMMN_DETAIL_CODE;
	
	//거래처계좌로 이체
	var SBSACNT_TRFRSN_CODE = $("#SBSACNT_TRFRSN_CODE").data("kendoComboBox");
	
	if (CMMN_DETAIL_CODE == '001') { // 거래처계좌로이체 선택
		SBSACNT_TRFRSN_CODE.wrapper.hide();
		$("#SBSACNT_TRFRSN_CN").hide();
		
		//setTradeBankInfo();
		
	} else if (CMMN_DETAIL_CODE == '002') {
		SBSACNT_TRFRSN_CODE.wrapper.show();
		
		setBankInfo(); // 보조금계좌이체 선택 시 은행/계좌 정보 설정
		
		if (SBSACNT_TRFRSN_CODE.value() == '099') {
			$("#SBSACNT_TRFRSN_CN").show();
		} else { 
			$("#SBSACNT_TRFRSN_CN").hide();
		}
	} else if (CMMN_DETAIL_CODE == '003'){
		SBSACNT_TRFRSN_CODE.wrapper.show();
	} else if (CMMN_DETAIL_CODE == ''){
		SBSACNT_TRFRSN_CODE.wrapper.hide();
		$("#SBSACNT_TRFRSN_CN").hide();
	}

	if(SBSACNT_TRFRSN_CODE.value() == '006'){
		$("#SBSACNT_TRFRSN_CODE").data("kendoComboBox").select(25);
	}
}

//보조금계좌로 이체
function fn_depositGbCause(e){
	var dataItem = this.dataItem(e.item.index());
	var CMMN_DETAIL_CODE = dataItem.CMMN_DETAIL_CODE;
	$('#SBSACNT_TRFRSN_CN').val('');
	$('#SBSACNT_TRFRSN_CN').hide();
	
	if(CMMN_DETAIL_CODE == '001'){
	}else if(CMMN_DETAIL_CODE == '002'){
	}else if(CMMN_DETAIL_CODE == '003'){
		
	}else if(CMMN_DETAIL_CODE == '004'){
	}else if(CMMN_DETAIL_CODE == '005'){
	}else if(CMMN_DETAIL_CODE == '099'){
		$('#SBSACNT_TRFRSN_CN').show();
	}else if(CMMN_DETAIL_CODE == ''){
	}
}
//텍스트박스 초기화
function fn_initTextBox(dataItem){
	var SBSACNT_TRFRSN_CODE = $("#SBSACNT_TRFRSN_CODE").data("kendoComboBox");
	var BCNC_SE_CODE= $('#BCNC_SE_CODE').val()
	SBSACNT_TRFRSN_CODE.wrapper.hide();
	$('#SBSACNT_TRFRSN_CN').hide();
	
	if (BCNC_SE_CODE == '001') {
		//법인사업자	
		fn_setCustomerGbCompany()
	} else if (BCNC_SE_CODE == '002') {
		//개인사업자	
		fn_setCustomerGbCompany()
	} else if (BCNC_SE_CODE == '003') {
		//개인
		fn_setCustomerGbPerson();
	} else if (BCNC_SE_CODE == '004') {
		//해외	
		fn_setCustomerGbCompany()
	}
    var TRANSFR_ACNUT_SE_CODE = $("#TRANSFR_ACNUT_SE_CODE").data("kendoComboBox");
    var aa = TRANSFR_ACNUT_SE_CODE.value();
    TRANSFR_ACNUT_SE_CODE.value(aa);
    if(TRANSFR_ACNUT_SE_CODE.value() == '002'){
    	SBSACNT_TRFRSN_CODE.wrapper.show();
    	SBSACNT_TRFRSN_CODE.value(dataItem.SBSACNT_TRFRSN_CODE);
    	if( $("#SBSACNT_TRFRSN_CODE").val() == '099'){
    		$('#SBSACNT_TRFRSN_CN').show();
    		$('#SBSACNT_TRFRSN_CN').val(dataItem.SBSACNT_TRFRSN_CN);
    	}
    }
}

function fn_initCustomerGb(){}

//function setTradeBankInfo() {

//	$("#BCNC_ACNUT_NO").val($('#restrade_BA_NB').val());

//	var param = {
//			"bankCode" : $('#restrade_BTR_SEQ').val(),
//	}

//	$.ajax({
//			url : "<c:url value='/kukgoh/getBankcode' />",
//			data : param,
//			type : 'POST',
//			success : function(result) {
			
//				if (result !== null && typeof result !== 'undefined') {
//					$("#BCNC_BANK_CODE").val(result.CMMN_DETAIL_CODE);
//					$("#BCNC_BANK_CODE_NM").val(result.CMMN_DETAIL_CODE_NM);
//				}
//			}	
//		});

//}

function setBankInfo() {
	
	var param = {
			"CO_CD" : $("#CO_CD").val(),
			"PJT_CD" : $("#PJT_CD").val()
	}
	
	$.ajax({
			url : "<c:url value='/kukgoh/getPjtInfo' />",
			data : param,
			type : 'POST',
			success : function(result) {
				
				$("#BCNC_BANK_CODE_NM").val(result.BCNC_BANK_CODE_NM);
				$("#BCNC_BANK_CODE").val(result.BCNC_BANK_CODE_ENARA);
				$("#BCNC_ACNUT_NO").val(result.BCNC_ACNUT_NO);
				$("#BCNC_ACNUT_NO_ENARA").val(result.BCNC_BANK_CODE_ENARA);
			}	
		});
}

//거래처 구분(개인) 셋팅
function fn_setCustomerGbCompany(){
	$('#html_cmpny_name').text("거래처명");
	$('#html_cmpny_no').html("<img src=\"<c:url value='/Images/ico/ico_check01.png'/>\" alt='' />사업자등록번호");
	$('#html_div_lsft_no').show();
	$('#html_div_pin_no').hide();
	$('#html_bcnc_cmpny_cnd_ind').show();
}

function fn_setCustomerGbPerson(){
	$('#html_cmpny_name').text("성명");
	$('#html_cmpny_no').html("<img src=\"<c:url value='/Images/ico/ico_check01.png'/>\" alt='' />주민등록번호");
	$('#html_div_lsft_no').hide();
	$('#html_div_pin_no').show();
	$('#html_bcnc_cmpny_cnd_ind').hide();
}

function fn_setSelectInit(dataItem){
	$("#PRUF_SE_CODE").data("kendoComboBox").value(dataItem.PRUF_SE_CODE);
	$("#BCNC_SE_CODE").data("kendoComboBox").value(dataItem.BCNC_SE_CODE);
	var arr = [];
	$('.money').each(function () {
		   $(this).val(fn_formatMoney($(this).val()));
	});
	$("#MD_DT").val(fn_formatDate($("#MD_DT").val()));
}

function fn_formatDate(str){
	return str.substring(0,4) + "-" + str.substring(4,6) + "-" + str.substring(6,8) ;
}

function fn_formatMoney(str){
        str = String(str);
        return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
}
function fn_setInfo(dataItem){
	
		var anObj = dataItem;
		var keys = Object.keys(dataItem);
		
		for(var i = 0; i<keys.length; i++){
			var key = keys[i];
			
			if (key !== 'PROCESS_RESULT_MSSAGE') {
				$('#'+key).val(dataItem[key]);				
			}
		}
		
		// 사업자등록번호 셋팅
		var BCNC_LSFT_NO = $('#BCNC_LSFT_NO').val();
		
		if ((dataItem.BCNC_SE_CODE == '003')) {
			if (BCNC_LSFT_NO.length == 13){
				$('#PIN_NO_1').val(BCNC_LSFT_NO.substring(0,6));
				$('#PIN_NO_2').val(BCNC_LSFT_NO.substring(6,7));
			} else if (dataItem.PIN_NO_1 == null) {
				$('#PIN_NO_1').val("");
				$('#PIN_NO_2').val("");
			}
			
		} else {
			if (BCNC_LSFT_NO.length == 10) {
				$('#BCNC_LSFT_NO').val(BCNC_LSFT_NO.substring(0,3)+'-'+BCNC_LSFT_NO.substring(3,5)+'-'+BCNC_LSFT_NO.substring(5,11));	
			}
		}
		
		// 증빙선택 '기타' 일시 지출결의서 승인날짜
		if ($("#PRUF_SE_CODE").val() === '999') {
			$('#EXCUT_REQUST_DE').val('${data.DOC_REGDATE}');
		}
		
		
		if($('#EXCUT_REQUST_DE').val().length == '8'){
			var parseDate = $('#EXCUT_REQUST_DE').val();
			
			$('#EXCUT_REQUST_DE').val(fn_formatDate(parseDate));
		}
		
		fn_setSelectInit(dataItem);
}

//집행정보 전송
function fn_btnSubmit(){
	console.log("집행정보 전송");
	
	fn_validationCheck();
}

function fn_finalSubmit() {
	
	//폼 입력
	$('#SUM_AMOUNT').val(getNumString($('#SUM_AMOUNT').val()));
	$('#SPLPC').val(getNumString($('#SUM_AMOUNT').val()));
	$('#VAT').val(getNumString($('#VAT').val()));	
	
	// 여기 입력하자
	var dt = $('#gisuDt').val().replace(/\-/g,'');
	$('#attachGisuSeq').val(dt+""+pad($('#gisuSeq').val(), 4)+pad($('#attachLnSeq').val(), 2));
	var targetForm = $("#sendForm :input");
	
	$.each(targetForm, function(index, elem) {
	      $(this).val($(this).val().replace(/,/g, ''));
	});
	
	var frm = $("#sendForm").serialize();
	$('#btnSubmit').attr("disabled", true);
	
	makeSendParam();
	
	console.log(JSON.stringify(dataJsonArr));
	
	//곽경훈 수정
	$.ajax({
		url : "<c:url value='/kukgoh/sendInfo' />",
		data : {param : JSON.stringify(dataJsonArr)},
		type : 'POST',
		success : function(result) {
			
			alert(result.OUT_MSG);
			$('#btnSubmit').attr("disabled", true);
			
			if(result.OUT_YN == 'Y'){
				opener.fn_searchBtn();
				window.close();
			}
		},	error : function(e){
			console.log(e);
		},
		beforeSend: function() {
	    },
	    complete: function() {
	        //마우스 커서를 원래대로 돌린다
	        $('html').css("cursor", "auto");
	    	$('#loadingPop').data("kendoWindow").close();
	    	$('#btnSubmit').attr("disabled", false);
	    }
	}); 
	
	$('#SUM_AMOUNT').val(fn_formatMoney($('#SUM_AMOUNT').val()));
	$('#SPLPC').val(fn_formatMoney($('#SUM_AMOUNT').val()));
	$('#VAT').val(fn_formatMoney($('#VAT').val()));
}

function fn_validationCheck(){
	console.log("집행정보 반영 체크");
	
	if($('#PRUF_SE_CODE').val() == '999'){
		$('#PRUF_SE_NO').val('');
	}
	
	var EXCUT_PRPOS_CN = $('#EXCUT_PRPOS_CN').val()
	var PRDLST_NM = $('#PRDLST_NM').val()
	var PRUF_SE_NO = $('#PRUF_SE_NO').val()
	var EXCUT_REQUST_DE = $('#EXCUT_REQUST_DE').val().replace(/\-/g,'');
	var BCNC_SE_CODE = $('#BCNC_SE_CODE').val()
	var PRUF_SE_CODE =  $('#PRUF_SE_CODE').val()
	var BCNC_CMPNY_NM = $('#BCNC_CMPNY_NM').val()
	var BCNC_RPRSNTV_NM = $('#BCNC_RPRSNTV_NM').val()
	var BCNC_TELNO = $('#BCNC_TELNO').val()
	var BCNC_BIZCND_NM = $('#BCNC_BIZCND_NM').val()
	var BCNC_INDUTY_NM = $('#BCNC_INDUTY_NM').val()
	var BCNC_ADRES = $('#BCNC_ADRES').val();
	var BCNC_BANK_CODE = $('#BCNC_BANK_CODE').val()

	var BCNC_BANK_CODE_NM = $('#BCNC_BANK_CODE_NM').val()
	var BCNC_ACNUT_NO = $('#BCNC_ACNUT_NO').val().replace(/\-/g,'');
	var TRANSFR_ACNUT_SE_CODE = $('#TRANSFR_ACNUT_SE_CODE').val()
	var SBSACNT_TRFRSN_CODE = $('#SBSACNT_TRFRSN_CODE').val()
	var SBSACNT_TRFRSN_CN = $('#SBSACNT_TRFRSN_CN').val()
	var SBSIDY_BNKB_INDICT_CN = $('#SBSIDY_BNKB_INDICT_CN').val()
	var BCNC_BNKB_INDICT_CN = $('#BCNC_BNKB_INDICT_CN').val();
	var PIN_NO_1 =  $('#PIN_NO_1').val();
	var PIN_NO_2 =  $('#PIN_NO_2').val();
	var PIN_NO = $('#PIN_NO_1').val() + "" + $('#PIN_NO_2').val() + "000000";
	
	var frm = $("#sendForm").serialize();
	
	console.log(frm);
	
	$.ajax({
		url : "<c:url value='/kukgoh/saveCheck' />",
		data : frm,
		type : 'POST',
		async : true,
		success : function(result) {
 			if (result.OUT_YN == 'Y') {
				fn_finalSubmit();
			} else {
				alert(result.OUT_MSG);
				$('html').css("cursor", "auto");
		    	$('#loadingPop').data("kendoWindow").close();
			} 
		},	
		beforeSend: function() {
	        //마우스 커서를 로딩 중 커서로 변경
	        $('html').css("cursor", "wait");
	    	$('#loadingPop').data("kendoWindow").open();
	    },
	    complete: function() {
	        //마우스 커서를 원래대로 돌린다
	    }	
	}); 
}

//집행정보 재전송
function fn_btnCancelSubmit(){
	console.log("집행정보 재전송");
	//폼 입력
	var data = {
		CO_CD : $('#CO_CD').val()
		,GISU_DT : $('#gisuDt').val().replace(/\-/g,'')
		,GISU_SQ : $('#gisuSeq').val()
		,BG_SQ : $('#BG_SQ').val()
		,LN_SQ : $('#LN_SQ').val()
		,EMP_SEQ : ''
		,EMP_IP : ''
		,OUT_YN : ''
		,OUT_MSG :''
	}
	
	//곽경훈 수정
	$.ajax({
		url : "<c:url value='/kukgoh/cancelSendInfo' />",
		data : data,
		type : 'POST',
		success : function(result) {
			
			if (dataJson.KUKGO_STATE == '전송실패') {
				alert('정상적으로 전송 취소되었습니다.');
			} else {
				alert(result.OUT_MSG);	
			}
			
			if(result.OUT_YN == 'Y'){
				opener.fn_searchBtn();
				window.close();
			}
		}	
	}); 
}

//숫자 사릿수 만들기(첨부파일)
function pad(n, width) {
	n = n + '';
	return n.length >= width ? n : new Array(width - n.length + 1).join('0') + n;
}

</script>

<!-- 첨부파일 --> 
<script type="text/javascript">
function fileCountChenck(){
 	var dt = $('#gisuDt').val().replace(/\-/g,'');
	 var data = {
			INTRFC_ID :  $('#INTRFC_ID').val(),
			TRNSC_ID : $('#TRNSC_ID').val(),
			C_DIKEYCODE : $('#C_DIKEYCODE').val(),			
			KUKGO_STATE_YN : $('#KUKGO_STATE_YN').val(),
			targetId : dt+""+pad($('#gisuSeq').val(), 4) + ""+ $('#attachLnSeq').val(),
 			FILE_ID : dt+""+pad($('#gisuSeq').val(), 4) + ""+ $('#attachLnSeq').val()

	}
	 $('#fileDiv').empty();
	 
	 $.ajax({
	 		url: _g_contextPath_+"/kukgoh/getFileList",
	 		dataType : 'json',
	 		data : data,
	 		type : 'POST',
	 		async : true,
	 		success: function(result){
	 			$('#FILE_ID').val("1");
	 			if (result.list.length > 0) {
	 				console.log('0 이상')
	 				$('#attachFileYn').show();
	 			} else {
	 				console.log('0 이하')
	 				$('#attachFileYn').hide();
	 			}
	 		}
	 	});
}

function fileRow() {
 	var dt = $('#gisuDt').val().replace(/\-/g,'');

 	 var data = {
 			INTRFC_ID : $('#INTRFC_ID').val(),
 			TRNSC_ID : $('#TRNSC_ID').val(),
 			C_DIKEYCODE : $('#C_DIKEYCODE').val(),
 			KUKGO_STATE_YN : $('#KUKGO_STATE_YN').val(),
 			targetId : dt+""+pad($('#gisuSeq').val(), 4) + ""+ $('#attachLnSeq').val(),
 			FILE_ID : dt+""+pad($('#gisuSeq').val(), 4) + ""+ $('#attachLnSeq').val()
 	}
 	 
 	$('#fileDiv').empty();
 	 
 	$.ajax({
 		url: _g_contextPath_+"/kukgoh/getFileList",
 		dataType : 'json',
 		data : data,
 		type : 'POST',
 		success: function(result){
 			if (result.list.length > 0) {
 				$('#FILE_ID').val("1");
 				$('#attachFileYn').show();
 				var kukgohStateYn = $('#KUKGO_STATE_YN').val();
 				
 				if(kukgohStateYn == 'N'){
 					//미전송
 	 				for (var i = 0 ; i < result.list.length ; i++) {
 						fn_setFileDivN(result, i);
 					}
 				}else if(kukgohStateYn == 'Y'){
 					//전송
 	 				for (var i = 0 ; i < result.list.length ; i++) {
 						fn_setFileDivY(result, i);
	 				}

 				}
 			} else {
 				$('#attachFileYn').hide();
 				$('#fileDiv').append(
 					'<tr id="testDefault">'+
 					'<td class="" style="width:250px;">'+
 					'<span class="mr20">'+	
 					'<img src="<c:url value="/Images/ico/ico_clip02.png"/>" alt="" />'+
 					'<a href="#n" style="color: #808080;" id="fileText">&nbsp;첨부파일이 없습니다.'+
 					'</a>'+
 					'</span>'+
 					'</td>'+
 					'</tr>'
 				);
 			}
 		}
 	});
 	$('#filePop').data("kendoWindow").open();
}

function upFile() {
	$("#fileID").click();
}

function getFileNm(e) {
	var index = $(e).val().lastIndexOf('\\') + 1;
	var valLength = $(e).val().length;
	var row = $(e).closest('dl');
	var fileNm = $(e).val().substr(index, valLength);
	row.find('#fileText').text(fileNm).css({'color':'#0033FF','margin-left':'5px'});
	insertFile(fileNm);
}

function delFile(attach_file_id, file_seq) {

	 var data = {
			attach_file_id : attach_file_id,
			fileSeq : file_seq
	}
	 
	$.ajax({
		url : _g_contextPath_+'/kukgoh/deleteFile',
		type : 'GET',
		data : data,
	}).success(function(result) {
		if(result.outYn == 'Y'){
			$('#test'+result.attach_file_id).closest('tr').remove()
			}else{
			}
	});
}  
 
function insertFile(fileNm){
	var dt = $('#gisuDt').val().replace(/\-/g,'');
	var form = new FormData($("#fileForm")[0]);
	
	form.append("C_DIKEYCODE", $('#C_DIKEYCODE').val());
	form.append("targetId", dt+""+pad($('#gisuSeq').val(), 4) + ""+ $('#attachLnSeq').val());
	form.append("fileNm",fileNm);
	form.append("intrfcId", "IF-EXE-EFR-0074");
	
	$.ajax({
		url : _g_contextPath_+"/kukgoh/insertAttachFile",
		data : form,
		type : 'post',
		processData : false,
		async: false,
		contentType : false,
		success : function(result) {
			
			if(result.outYn == 'Y'){
				alert("첨부파일을 등록하였습니다.");
				$('#FILE_ID').val("1");
				$('#testDefault').remove();
				$('#fileDiv').append(
					'<tr id="test'+result.attach_file_id+'">'+
					'<td class="">'+
					'<span style=" display: block;" class="mr20">'+
					'<img src="<c:url value="/Images/ico/ico_clip02.png"/>" alt="" />&nbsp;'+								
					'<a href="#n" style="line-height: 23px; cursor: pointer; color: #0033FF" id="fileText" onclick="kukgohFileDown(this);" class="file_name">'+result.fileNm+'.'+result.ext+'</a>&nbsp;'+
					'&nbsp;'
					+'<a href="javascript:delFile('+result.attach_file_id+','+result.file_seq+')"><img src="<c:url value="/Images/btn/btn_del_reply.gif"/>" /></a>' +
					'<input type="hidden" id="fileId" class = "fileId" value="'+result.attach_file_id+'" />'+
					'<input type="hidden" id="fileSeq" class = "fileSeq" value="'+result.file_seq+'" />'+

					'</span>'+
					'</td>'+
					'</tr>'
				);
			}else{
				alert(result.outMsg);
			}
		},
		error : function(error) {
			console.log(error);
			console.log(error.status);
		}
	});
}

function filepopClose(){
	fileCountChenck();
	$('#filePop').data('kendoWindow').close();
}

function getNumString(s) {
    var rtn = parseFloat(s.replace(/,/gi, ""));
    if (isNaN(rtn)) return 0;
    else return rtn;
}

function fn_btnDocView(){
	var dikeyCode = '${data.C_DIKEYCODE}';
    var url = "http://" + g_hostName + "/ea/edoc/eapproval/docCommonDraftView.do?multiViewYN=Y&diSeqNum=undefined&miSeqNum=undefined&diKeyCode="+dikeyCode;
	window.open(url,"viewer","width=965, height=950, resizable=yes, scrollbars=yes, status=no, top=50, left=50","newWindow");						
}

function fn_docViewPop2(docId, approKey){
	/*if(deleteFlag != null && deleteFlag == "Y"){
		alert("삭제된 문서는 열 수 없습니다.");
		return
	}*/
	var  chkFlag = true;
	$.ajax({
		url : _g_contextPath_+"/approval/approveCheck.do",
		type : "POST",
		async : false,
		data : {
			docId : docId,
		},
		success : function(data) {

			if(data.cnt.DOC_CNT != 1){
				console.log("더존 전자결재 조회")
				chkFlag = false;
				fn_btnDocView(docId);
			}else{console.log("커스텀 전자결재 조회")}
		}
	});

	if(chkFlag == false){return;}

	var hostName = "";
	if(g_hostName == 'localhost' || g_hostName == '127.0.0.1'){
		var hostName = "http://121.186.165.80:8010";
	}else{
		var hostName = "http://10.10.10.114";
	}



	var mod = "V";
	var pop = "" ;
	var id = '${userInfo.id}';
	var url = hostName + '/approval/approvalDocView.do?docId='+docId+'&menuCd=' + "normal" + '&mod=' + mod + '&approKey='+ approKey  + '&id=' + id;
	var width = "1000";
	var height = "950";
	windowX = Math.ceil( (window.screen.width  - width) / 2 );
	windowY = Math.ceil( (window.screen.height - height) / 2 );
	pop = window.open(url, '결재 문서_' + docId, "width=" + width + ", height=" + height + ", top="+ windowY +", left="+ windowX +", resizable=NO, scrollbars=NO");
	//pop.focus();
}

function check(str){
	var result = true;
	if( str == '' || str == null ){
	    alert( '값을 입력해주세요' );
	    result = false;
	    return result;
	}
	var blank_pattern = /^\s+|\s+$/g;
	if( str.replace( blank_pattern, '' ) == "" ){
	    alert(' 공백만 입력되었습니다 ');
	    result = false;
	    return result;
	}
	//공백 금지
	//var blank_pattern = /^\s+|\s+$/g;(/\s/g
	var blank_pattern = /[\s]/g;
	if( blank_pattern.test( str) == true){
	    alert(' 공백은 사용할 수 없습니다. ');
	    result = false;
	    return result;
	}
	
	return result;
}

function postSearchBtn(){
	fnZipPop('temp');
}	

function fn_setFileDivY(result, i){
		$('#fileDiv').append(
					'<tr id="test'+result.list[i].attach_file_id+'">'+
					'<td class="">'+
					'<span style=" display: block;" class="mr20">'+
					'<img src="<c:url value="/Images/ico/ico_clip02.png"/>" alt="" />&nbsp;'+								
					'<a href="#n" style="line-height: 23px; cursor: pointer; color: #0033FF" id="fileText" onclick="kukgohFileDown(this);" class="file_name">'+result.list[i].real_file_name+'.'+result.list[i].file_extension+'</a>&nbsp;'+
					'<input type="hidden" id="fileId" class = "fileId" value="'+result.list[i].attach_file_id+'" />'+
					'<input type="hidden" id="fileSeq" class = "fileSeq" value="'+result.list[i].file_seq+'" />'+

					'</span>'+
					'</td>'+
					'</tr>'
			);
}

function fn_setFileDivN(result, i){
	$('#fileDiv').append(
				'<tr id="test'+result.list[i].attach_file_id+'">'+
				'<td class="">'+
				'<span style=" display: block;" class="mr20">'+
				'<img src="<c:url value="/Images/ico/ico_clip02.png"/>" alt="" />&nbsp;'+								
				'<a href="#n" style="line-height: 23px; cursor: pointer; color: #0033FF" id="fileText" onclick="kukgohFileDown(this);" class="file_name">'+result.list[i].real_file_name+'.'+result.list[i].file_extension+'</a>&nbsp;'+
				'&nbsp;<a href="javascript:delFile('+result.list[i].attach_file_id+','+result.list[i].file_seq+')"><img src="<c:url value="/Images/btn/btn_del_reply.gif"/>" /></a>' +
				'<input type="hidden" id="fileId" class = "fileId" value="'+result.list[i].attach_file_id+'" />'+
				'<input type="hidden" id="fileSeq" class = "fileSeq" value="'+result.list[i].file_seq+'" />'+

				'</span>'+
				'</td>'+
				'</tr>'
		);
}

function kukgohFileDown(e){
		var row = $(e).closest("tr");
		var attach_file_id = row.find('#fileId').val();
		var file_seq = row.find('#fileSeq').val()
		var data = {
				attach_file_id : row.find('#fileId').val(),
				file_seq : row.find('#fileSeq').val()
		}
		$.ajax({
			url : _g_contextPath_+'/kukgoh/fileDownLoad',
			type : 'get',
			data : data,
		}).success(function(data) {
			
			var downWin = window.open('','_self');
			downWin.location.href = _g_contextPath_+"/kukgoh/fileDownLoad?attach_file_id="+attach_file_id+'&file_seq='+file_seq;
		});
}

function fn_selectElecInvoice(){
	//비활성 : 거래처구분, 거래처명, 사업자등록번호, 업태 , 업종, 주소, 예금주명, 
	//대표자명, 전화번호, , 은행명, 계좌번호,  이체구분, 내통장표시, 받는통장표시
	//승인번호는 다 있다.
	
	//$('#dd_invoice').show();	//전자세금계산서 불러오기
	$('#dt_invoice').show();	//승인번호
	$('#dd_invoice1').show();	//승인번호
	$("#PRUF_SE_NO").val(typeof dataJson.PRUF_SE_NO === 'undefined' ? dataJson.ETXBL_CONFM_NO : dataJson.PRUF_SE_NO);
	$('#EXCUT_REQUST_DE').data("kendoDatePicker").readonly(true);	 //거래처구분

	//비활성
	$('#BCNC_SE_CODE').data("kendoComboBox").readonly(true);	 //거래처구분
	$('#BCNC_CMPNY_NM').prop('readonly', true);	//거래처명
	$('#BCNC_LSFT_NO').prop('readonly', true);		//사업자등록번호
	//BCNC_BIZCND_NM
	$('#BCNC_BIZCND_NM').prop('readonly', true)		//업태
	$('#BCNC_INDUTY_NM').prop('readonly', true)		//업종
	$('#POST_CD').prop('readonly', true)
	$('#BCNC_ADRES').prop('readonly', true);	//주소
	
	//활성
	$('#BCNC_RPRSNTV_NM').prop('readonly', false);	 //대표자명
	$('#BCNC_TELNO').prop('readonly', false);	//전화번호
	$('#BCNC_LSFT_NO').prop('readonly', true);
	
	//이체구분
	$('#SBSIDY_BNKB_INDICT_CN').prop('readonly', false);//내통장표시
	$('#BCNC_BNKB_INDICT_CN').prop('readonly', false);//받는통장표시
}

function fn_selectNomalInvoice(){
	//비활성 : 거래처구분, 거래처명, 사업자등록번호, 업태 , 업종, 주소, 예금주명, 
	//대표자명, 전화번호, , 은행명, 계좌번호,  이체구분, 내통장표시, 받는통장표시
	//승인번호는 다 있다.
	
	// 전자세금계산서 번호
	$("#PRUF_SE_NO").val(typeof dataJson.PRUF_SE_NO === 'undefined' ? dataJson.ETXBL_CONFM_NO : dataJson.PRUF_SE_NO);
	
	//비활성
	$('#dt_invoice').show();	//승인번호
	$('#dd_invoice1').show();	//승인번호

	$('#EXCUT_REQUST_DE').data("kendoDatePicker").readonly(true);	 //거래처구분

	$('#BCNC_SE_CODE').data("kendoComboBox").readonly(true);	 //거래처구분
	$('#BCNC_CMPNY_NM').prop('readonly', true);	//거래처명
	$('#BCNC_LSFT_NO').prop('readonly', true);		//사업자등록번호
	$('#BCNC_BIZCND_NM').prop('readonly', true)		//업태
	$('#BCNC_INDUTY_NM').prop('readonly', true)		//업종
	$('#POST_CD').prop('readonly', true)
	$('#BCNC_ADRES').prop('readonly', true);	//주소
	//활성
	$('#BCNC_RPRSNTV_NM').prop('readonly', false);	 //대표자명
	$('#BCNC_TELNO').prop('readonly', false);	//전화번호
	$('#BCNC_LSFT_NO').prop('readonly', false);		//
	//$('#BCNC_BIZCND_NM').prop('readonly', false);		//계좌번호
	//이체구분
	$('#SBSIDY_BNKB_INDICT_CN').prop('readonly', false);//내통장표시
	$('#BCNC_BNKB_INDICT_CN').prop('readonly', false);//받는통장표시

	//예금주명
	
}

function fn_selectCard(){
	//비활성 : 거래처구분, 거래처명, 사업자등록번호, 업태, 업종, 주소, 은행명(전북), 계좌번호(자동), 예금주명(태권도진흥재단), 이체구분 ->> 보조금계좌로이체 ->카드결제
	//활성 : 대표자명, 전화번호, 내푱장 표시, 받는통장표시
	//승인번호는 다 있다.
	//비활성
	$('#dt_invoice').show();	//승인번호
	$('#dd_invoice1').show();	//승인번호
	if (typeof dataJson.PRUF_SE_NO !== 'undefined') {
		$('#PRUF_SE_NO').val(dataJson.PRUF_SE_NO);
	} else {
		$('#PRUF_SE_NO').val('');
	}
	$('#EXCUT_REQUST_DE').data("kendoDatePicker").readonly(true);	 //거래처구분

	$('#BCNC_SE_CODE').data("kendoComboBox").readonly(true);	 //거래처구분
	$('#BCNC_CMPNY_NM').prop('readonly', true);	//거래처명
	$('#BCNC_LSFT_NO').prop('readonly', true);		//사업자등록번호
	$('#BCNC_BIZCND_NM').prop('readonly', true)		//업태
	$('#BCNC_INDUTY_NM').prop('readonly', true)		//업종
	$('#POST_CD').prop('readonly', true)
	$('#BCNC_ADRES').prop('readonly', true);	//주소
	$('#BCNC_LSFT_NO').prop('readonly', true);		//은행명
	$('#BCNC_BIZCND_NM').prop('readonly', true);		//계좌번호
	//이체구분
	
	//활성
	$('#BCNC_RPRSNTV_NM').prop('readonly', false);	 //대표자명
	$('#BCNC_TELNO').prop('readonly', false);	//전화번호
	$('#SBSIDY_BNKB_INDICT_CN').prop('readonly', false);//내통장표시
	$('#BCNC_BNKB_INDICT_CN').prop('readonly', false);//받는통장표시
}

function fn_selectEtc(){
	//$('#dd_invoice').hide();	//전자세금계산서 불러오기
	$('#dt_invoice').hide();	//승인번호
	$('#dd_invoice1').hide();	//승인번호
	
	$('#EXCUT_REQUST_DE').data("kendoDatePicker").readonly(false);	 //거래처구분

	
	//다오픈
	$('#BCNC_SE_CODE').data("kendoComboBox").readonly(false);	 //거래처구분
	$('#BCNC_CMPNY_NM').prop('readonly', false);	//거래처명
	$('#BCNC_LSFT_NO').prop('readonly', false);		//사업자등록번호
	$('#BCNC_BIZCND_NM').prop('readonly', false)		//업태
	$('#BCNC_INDUTY_NM').prop('readonly', false)		//업종
	$('#POST_CD').prop('readonly', false)
	$('#BCNC_ADRES').prop('readonly', false);	//주소
	$('#BCNC_LSFT_NO').prop('readonly', false);		//은행명
	$('#BCNC_BIZCND_NM').prop('readonly', false);		//계좌번호
	//이체구분
	$('#BCNC_RPRSNTV_NM').prop('readonly', false);	 //대표자명
	$('#BCNC_TELNO').prop('readonly', false);	//전화번호
	$('#SBSIDY_BNKB_INDICT_CN').prop('readonly', false);//내통장표시
	$('#BCNC_BNKB_INDICT_CN').prop('readonly', false);//받는통장표시
}

//거래처 계좌로 이체
function fn_depositToCompAccount(){
	//다오픈
}

//보조금계좌로 이체
function fn_depositToTpfAccount(){
	//다오픈
}

</script>
	
<!-- Card 그리드 -->
<script type="text/javascript">
	function cardGrid() {
		var cardGrid = $("#cardGrid").kendoGrid({
			dataSource : new kendo.data.DataSource({
				serverPaging : true,
				transport : {
					read : {
						url : _g_contextPath_ + "/kukgoh/getCardList",
						dataType : "json",
						type : "post"
					},
					parameterMap : function(data, operation) {
						// cardNo, prdUseStart, prdUseEnd, confmNo
						data.cardNo = $("#cardNo").val().replace(/[-]/gi, '');
						data.prdUseStart = $("#prdUseStart").val().replace(/[-]/gi, '');
						data.prdUseEnd = $("#prdUseEnd").val().replace(/[-]/gi, '');
						data.confmNo = $("#confmNo").val();

						return data;
					}
				},
				schema : {
					data : function(response) {
						
						//response.list.push({CARD_NO: '1234', PUCHAS_CONFM_NO:'1234', MRHST_NM:'1234', CONFM_DE:'1234', SPLPC:'1234', VAT:'1234', PUCHAS_TAMT:'1234'});
						
						console.log(response.list);
						
						return response.list;
					},
					total : function(response) {
						return response.total;
					}
				}
			}),
			dataBound : cardGridDataBound,
			height : 600,
			sortable : true,
			persistSelection : true,
			selectable : "multiple",
	        columns: [
	        	{
					field : "CARD_NO",
					title : "카드번호",
					width : 100
				},{
					field : "PUCHAS_CONFM_NO",
					title : "승인번호",
					width : 100
				},{
					field : "MRHST_NM",
					title : "사용자",
					width : 100
				},{
					field : "CONFM_DE",
					title : "사용일자",
					width : 100
				},{
					field : "SPLPC",
					title : "공급가",
					width : 100
				},{
					field : "VAT",
					title : "부가세",
					width : 100
				},{
					field : "PUCHAS_TAMT",
					title : "합계",
					width : 100
				}
			],
	        change: function (e){
	        }
	    }).data("kendoGrid");

		cardGrid.table.on("click", "[role=gridcell]", selectRow);
		
		function selectRow(){
			row = $(this).closest("tr"),
			grid = $('#cardGrid').data("kendoGrid"),
			dataItem = grid.dataItem(row);
			
			console.log(dataItem);
			
			// Card 선택 시 호출 화면에 데이터 설정
			$("#PRUF_SE_NO").val(dataItem.PUCHAS_TKBAK_NO);
			$("#EXCUT_REQUST_DE").val(dataItem.PUCHAS_DE);
			$("#SBSACNT_TRFRSN_CODE").val("004");
			$("#BCNC_SE_CODE").val(dataItem.BCNC_SE_CODE);
			$("#BCNC_LSFT_NO").val(dataItem.MRBCRB_REGIST_NO);
			$("#BCNC_CMPNY_NM").val(dataItem.MRHST_NM);
			$("#BCNC_INDUTY_NM ").val(dataItem.MRHST_INDUTY_NM);
			$("#BCNC_RPRSNTV_NM ").val(dataItem.MRHST_RPRSNTV_NM);
			$("#BCNC_ADRES").val(dataItem.ADRES);
			$("#EXCUT_SPLPC").val(dataItem.SPLPC);
			$("#EXCUT_VAT").val(dataItem.VAT);
			$("#BCNC_TELNO").val(dataItem.MRHST_TELNO);
			$("#EXCUT_SUM_AMOUNT").val(dataItem.PUCHAS_TAMT);
			$("#SPLPC").val(dataItem.SPLPC);
			$("#VAT").val(dataItem.VAT);
			$("#SUM_AMOUNT").val(dataItem.PUCHAS_TAMT);
			
			$("#cardPopup").data("kendoWindow").close();
		}
		
		function cardGridDataBound(e) {
			var grid = e.sender;

			if (grid.dataSource.total() == 0) {
				var colCount = grid.columns.length;
				$(e.sender.wrapper).find('tbody').append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
			}
		}
	}

	function cardChoiceFn() {
		$("#cardNoPopup").data("kendoWindow").open();
		
		cardNoGridReload();
	}
	
	function cardGridReload(){
		$("#cardGrid").data("kendoGrid").dataSource.read();
	}
	
	function cardSearch() {
		cardGridReload();
	}
</script>

<!-- CardNo 그리드 -->
<script type="text/javascript">

function cardNoGrid() {
		var cardNoGrid = $("#cardNoGrid").kendoGrid({
			dataSource : new kendo.data.DataSource({
				serverPaging : true,
				transport : {
					read : {
						url : _g_contextPath_ + "/kukgoh/getCardNoList",
						dataType : "json",
						type : "post"
					},
					parameterMap : function(data, operation) {
						data.cardNm = $("#cardName").val(); // 카드명
						data.cardNb = $("#cardLast4Dgts").val(); // 카드 끝 번호 4자리
						
						return data;
					}
				},
				schema : {
					data : function(response) {
						return response.list;
					},
					total : function(response) {
						return response.total;
					}
				}
			}),
			dataBound : cardGridDataBound,
			height : 600,
			sortable : true,
			persistSelection : true,
			selectable : "multiple",
	        columns: [
	        	{
					field : "TR_CD",
					title : "카드코드",
					width : 100
				},{
					field : "TR_NM",
					title : "카드명",
					width : 100
				},{
					field : "TR_NB",
					title : "카드번호",
					width : 100
				}
			]
	    }).data("kendoGrid");

		cardNoGrid.table.on("dblclick", "[role=gridcell]", selectRow);

		function selectRow(){
			row = $(this).closest("tr"),
			grid = $('#cardNoGrid').data("kendoGrid"),
			dataItem = grid.dataItem(row);

			$("#cardNo").val(dataItem.TR_NB);

			$("#cardNoPopup").data("kendoWindow").close();
		}

		function cardGridDataBound(e) {
			var grid = e.sender;

			if (grid.dataSource.total() == 0) {
				var colCount = grid.columns.length;
				$(e.sender.wrapper).find('tbody').append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
			}
		}
	}

	function cardNoGridReload(){
		$("#cardNoGrid").data("kendoGrid").dataSource.read();
	}
		
	// CardNoGrid 조회
	function cardNoSearch() {
		cardNoGridReload();
	}
	
	//전자세금계산서 팝업
	function invoiceMainGrid(){
		var kukgohInvoiceInsertGrid = $("#kukgohInvoiceInsertGrid").kendoGrid({
			dataSource : kukgohInvoiceInsertGridDataSource,
			dataBound : invoiceGridDataBound,
			height : 250,
			sortable : true,
			persistSelection : true,
			selectable : "multiple",
	        columns: [
				{
					field : "TR_NM",
					title : "거래처명",
					width : 100
				},{
					field : "BCNC_LSFT_NO",
					title : "사업자번호",
					width : 80
				},{
					template : function(dataItem){
						return fn_formatMoney(dataItem.UNIT_AM)
					},
					title : "합계금액",
					width : 80
				},{
					template : function(dataItem){
						return fn_formatMoney(dataItem.SUP_AM)
					},
					title : "공급가",
					width : 80
				},{
					template : function(dataItem){
						return fn_formatMoney(dataItem.VAT_AM)
					},
					title : "부가세",
					width : 80
				},{
					template : function  (dataItem){
						var 	result 	= '<input type="text" id="';
								result += 'txtInvoice1'
								result += '" class="" style="width:180px;"';
								
						var btnHtml = "";

						 if ((dataItem.ETXBL_CONFM_NO == '' || dataItem.ETXBL_CONFM_NO == null) && dataJson.ETXBL_CONFM_NO == '') {
							result += ' />';
							btnHtml +=	'<input type="button" id="btn1" class="text_blue"  style="width:50px;" onclick="fn_validInvoice(this)" value="전송"/>';
							return result + btnHtml;
						} else {
							result += 'value="' + dataJson.ETXBL_CONFM_NO + '" style="background-color : #c7c5c5;" ';
							
		         			if (dataItem.KUKGO_STATE_YN == "Y") {
		         				result += "disabled  />";
		         				btnHtml +=	'<input type="button" id="btn1" class="text_blue"  style="width:50px;" onclick="fn_validInvoice(this)" value="전송완료" disabled/>';
		         			} else {
		         				
		         				if (dataItem.PROCESS_RESULT_MSSAGE === '정상') {
		         					result += "disabled  />";
		         					btnHtml +=	'<input type="button" id="btn1" class="text_blue"  style="width:50px;" onclick="fn_validInvoice(this)" value="전송완료" disabled />';	         					
		         				} else {
		         					result += "/>";
		         					btnHtml +=	'<input type="button" id="btn1" class="text_blue"  style="width:50px;" onclick="fn_validInvoice(this)" value="전송" />';	         					
		         				}
		         			}
							
							return result + btnHtml;
						} 
				},
					title : "전자(세금)계산서 번호",
					width : 250
				},
				{
					field : "PROCESS_RESULT_MSSAGE",
					title : "전송결과",
					width : 80
				}
				],
	        change: function (e){
	        	invoiceGridClick(e)
	        }
	    }).data("kendoGrid");
		
		kukgohInvoiceInsertGrid.table.on("click", ".checkbox", selectRow);
		
		var checkedIds = {};
		
		// on click of the checkbox:
		function selectRow(){
			var checked = this.checked,
			row = $(this).closest("tr"),
			grid = $('#invoiceGrid').data("kendoGrid"),
			dataItem = grid.dataItem(row);
			
			checkedIds[dataItem.ANNV_USE_ID] = checked;
			if (checked) {
				//-select the row
				row.addClass("k-state-selected");
			} else {
				//-remove selection
				row.removeClass("k-state-selected");
			}
		}
		function invoiceGridClick(e){
			var dataItem = e.sender;
			console.log(dataItem);
		}
		function gridDataBound(e) {
			var grid = e.sender;
			if (grid.dataSource.total() == 0) {
				var colCount = grid.columns.length;
				$(e.sender.wrapper).find('tbody').append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
			}
		}
	}
	
	function invoiceGridDataBound(e) {
		var grid = e.sender;
		if (grid.dataSource._data.length == 0) {
			var colCount = grid.columns.length;
			$(e.sender.wrapper).find('tbody').append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
		}
	}
	
	var kukgohInvoiceInsertGridDataSource = new kendo.data.DataSource({
		serverPaging : true,
		pageSize : 10,
		transport : {
			read : {
				url : _g_contextPath_+"/kukgoh/kukgohInvoiceInsertGrid2",
				dataType : "json",
				type : 'post'
			},
			parameterMap : function(data, operation) {
				data.C_DIKEYCODE = dataJson.C_DIKEYCODE;
				data.CO_CD =  dataJson.CO_CD; 
				data.GISU_DT = dataJson.GISU_DT;
				data.GISU_SQ = dataJson.GISU_SQ;
				data.BG_SQ = dataJson.BG_SQ;
				data.LN_SQ = dataJson.LN_SQ;
				return data;
			}
		},
		schema : {
			data : function(response) {
				return response.list;
			},
			total : function(response) {
			},
			model : {
				fields : {
					ANNV_HOLI_STEP_NAME : {
						type : "string"
					},
					code_kr : {
						type : "string"
					}
				}
			}
		}
	});
	
	function fn_validInvoice(e){ // 전자(세금) 계산서 전송
		
		$(e).attr("disabled", true);
		var idSeq = e.id.replace("btn", "");
		
		data = {
				ETXBL_CONFM_NO : $('#txtInvoice1').val()	
				,OUT_YN : '1'
				,OUT_MSG : '1'
		}
		
		$.ajax({
			url : "<c:url value='/kukgoh/invoiceValidation' />",
			data : data,
			type : 'POST',
			success : function(result) {
				console.log(result);
				
				if (result.OUT_YN == 'Y'){
					fn_requestInvoice("txtInvoice1");
				} else {
					alert(result.OUT_MSG);
					$('#btn'+idSeq).attr("disabled", false);
				}
			}	
		});
	}
	
	function fn_requestInvoice(e){
		
		data = {
				CO_CD : dataJson.CO_CD
				,GISU_DT : dataJson.GISU_DT
				,GISU_SQ : dataJson.GISU_SQ
				,BG_SQ : dataJson.BG_SQ
				,LN_SQ : dataJson.LN_SQ
				,BSNSYEAR : dataJson.BSNSYEAR
				,FILE_ID : ""
				,DDTLBZ_ID : dataJson.DDTLBZ_ID
				,EXC_INSTT_ID : dataJson.EXC_INSTT_ID
				,ETXBL_CONFM_NO : $('#'+e).val()
				,EMP_SEQ : $('#empSeq').val()
		}
		
		$.ajax({
			url : "<c:url value='/kukgoh/requestInvoice' />",
			data : data,
			type : 'POST',
			success : function(result) {
				
				if (result.OUT_YN == 'Y') {
					alert("전자세금계산서 조회를 요청하였습니다. \n 10 ~ 20분 후 집행전송이 가능합니다.");
					$('#'+e).css('background-color','#c7c5c5');
					$('#popUp').data('kendoWindow').close();
				} else {
					alert(result.OUT_MSG);
					$('#btn'+LN_SQ).attr("disabled", false);
				}
			}	
		});
}
		//집행 전송 페이지에서 이체구분이 운영비 자체 이체로 들어올 때
		$(document).ajaxStop(function(){
			if($("#SBSACNT_TRFRSN_CODE").val() == '006'){
				$("#SBSACNT_TRFRSN_CODE").data("kendoComboBox").select(25); //운영비 자체 이체-사후승인
			}
		});
	
</script>

<!-- HTML Tree -->
<div class="iframe_wrap" style="min-width: 800px;">
	<div class="sub_title_wrap">
		<div class="title_div">
			<h4>지출결의서 집행전송</h4>
		</div>
		<div class="sub_contents_wrap">
			<p class="tit_p mt5 mt20">지출결의서 집행전송</p>
				<form id="sendForm" action="" method="POST">
				<input type="hidden" name="C_DIKEYCODE" id="C_DIKEYCODE" value="${data.C_DIKEYCODE}" />
				
				<div class="top_box demo-section k-content wide" id="tooltip" style="width: 1500px;">
					<dl>
						<dt  class="ar" style="width:128px;" >발의자</dt>
						<dd>
							<input   type="text" id="korNm" style="width:128px;"  value="${data.KOR_NM}"  title="${data.KOR_NM}"readonly name = "KOR_NM"/>
							<input type="hidden" id="empSeq" value='${empSeq}'/>
						</dd>	
						<dt  class="ar" style="width:128px" >발의일자</dt>
						<dd>
							<input   type="text" style="width:160px" id="gisuDt" value='${data.GISU_DT}'  title="${data.GISU_DT}"readonly name = "GISU_DT"/>
						</dd>					
					    <dt  class="ar" style="width:128px" >발의번호</dt>
  							<dd>
							<input type="text" id="gisuSeq" style="width:70px" value='${data.GISU_SQ}' title="${data.GISU_SQ}" readonly name = "GISU_SQ"/> -
							<input type="text" style="width:70px"  id="BG_SQ" value='${data.BG_SQ}' name = "BG_SQ" readonly/>
							<input type="hidden" id="stateYn" value="${data.KUKGO_STATE == '미전송' ? 'N' : 'Y'}"  name = "KUKGO_STATE_YN"/>
						</dd>	
					    <dt  class="ar" style="width:128px" >문서번호</dt>
  							<dd>
							<input type="text" id="docNumber" value='${data.DOC_NUMBER}'  title="${data.DOC_NUMBER}" readonly name="DOC_NUMBER"/>
						</dd>	
  							<dd>
							<input type="button" id="docView" value='문서보기' />
						</dd>
					</dl>
					<dl class="next2">							
					    <dt  class="ar" style="width:128px" >제목</dt>
  							<dd>
							<input type="text" id="docTitle"  value="<c:out value='${data.DOC_TITLE}' />" style="width:452px" value='${data.DOC_TITLE}' readonly name="DOC_TITLE"/>
						</dd>	
						<dt  class="ar" style="width:128px; color:#2d57d3;">e나라도움 사업명</dt>
						<dd>
							<input type="text" style="width:452px"  id="kukgoPjtNm" value='${data.KUKGO_PJTNM}' title="${data.KUKGO_PJTNM}" readonly  name="KUKGO_PJTNM"/>
						</dd>															
					</dl>
					<dl class="next2">
						<dt  class="ar" style="width:128px;" >회계단위</dt>
						<dd>
							<input type="text" style="width:128px;"  id="divNm"value='${data.DIV_NM}' title="${data.DIV_NM}" readonly name="DIV_NM"/>
						</dd>	
						<dt  class="ar" style="width:128px" >프로젝트</dt>
						<dd>
							<input type="text" id="pjtNm" style="width:160px" value='${data.PJT_NM}'  title="${data.PJT_NM}" readonly  name="PJT_NM"/>
						</dd>					
						<dt  class="ar" style="width:128px" >예산과목</dt>
						<dd>
							<input type="text" id="abgtNm" style="width:205px" value='${data.ABGT_NM}'   title="${data.ABGT_NM}"readonly  name="ABGT_NM"/>
						</dd>
					
					</dl>						
					<dl class="next2">
						
						<dt  class="ar" style="width:128px;" >결재수단</dt>
						<dd>
							<input type="text" id="setFgNm" style="width:128px;"  value='${data.SET_FG_NM}'title="${data.SET_FG_NM}"  readonly  name="SET_FG_NM"/>
						</dd>	
						<dt  class="ar" style="width:128px" >과세구분</dt>
						<dd>
							<input type="text" id="vatFgNm" style="width:160px" value='${data.VAT_FG_NM}' title="${data.VAT_FG_NM}" readonly  name="VAT_FG_NM"/>
						</dd>
						<dt  class="ar" style="width:128px" >금액</dt>
						<dd>
							<input type="text" id="unitAm" style="width:160px"value='${data.UNIT_AM}' title="${data.UNIT_AM}"  readonly  name="UNIT_AM"/>
						</dd>							
					</dl>						
					
					
				</div>
				<div style="height: 365px; width:1500px;">
					<div style=" float: left; padding-right: 25px; margin-top: 6px;">
						<div class="btn_div mt10 cl">
					</div>
						<div class="com_ta" style="">
							<div class="btn_div mt10 cl">
								<div class="left_div">
										<p class="tit_p mt5 mb0">집행정보</p>
								</div>
							</div>
							<div class="top_box gray_box">
								<dl >
									<dt style="width:100px; text-align:right; color:#2d57d3;">보조세목</dt>
									<dd>
										<!-- restrade 정보 저장 -->
<%-- 										<input type="hidden" id="restrade_BA_NB" value='${restradeInfo.ba_nb }'/> --%>
<%-- 										<input type="hidden" id="restrade_BTR_SEQ" value='${restradeInfo.btr_seq }'/> --%>
<%-- 										<input type="hidden" id="restrade_BTR_NAME" value='${restradeInfo.btr_name }'/> --%>
										
										<input type="text" id="ASSTN_TAXITM_CODE_NM" name="ASSTN_TAXITM_CODE_NM" value="${result.ASSTN_TAXITM_CODE_NM }" style="width: 140px" readonly value=""  />
										<input type="hidden" id="BSNSYEAR" name="BSNSYEAR" value='${result.BSNSYEAR }'/>
										<input type="hidden" id="FILE_ID" name="FILE_ID"  value='${result.FILE_ID }'/>
										<input type="hidden" id="DDTLBZ_ID" name="DDTLBZ_ID"  value='${result.DDTLBZ_ID }'/>
										<input type="hidden" id="EXC_INSTT_ID" name="EXC_INSTT_ID"  value='${result.EXC_INSTT_ID }'/>
										
										<!-- 집행정보 반영 -->
										<input type="hidden" id="BCNC_ACNUT_NO_ENARA" name="BCNC_ACNUT_NO_ENARA" value="" />
										<input type="hidden" id="PJT_CD" name="PJT_CD"  value="${result.PJT_CD }"/>
										<input type="hidden" id="APPLY_DIV" name="APPLY_DIV"  value="${result.APPLY_DIV }"/>
										<input type="hidden" id="INTRFC_ID" name=""  value="${result.INTRFC_ID }"/>
										<input type="hidden" id="EXCUT_TY_SE_CODE" name="EXCUT_TY_SE_CODE"  value="${result.EXCUT_TY_SE_CODE }"/>			
										<input type="hidden" id="BCNC_BANK_CODE" name="BCNC_BANK_CODE"  value="${result.BCNC_BANK_CODE }"/>	
										<input type="hidden" id="EXCUT_SPLPC" name="EXCUT_SPLPC"  value="${result.EXCUT_SPLPC }"/>		
										<input type="hidden" id="EXCUT_VAT" name="EXCUT_VAT"  value="${result.EXCUT_VAT }"/>			
										<input type="hidden" id="EXCUT_SUM_AMOUNT" name="EXCUT_SUM_AMOUNT"  value="${result.EXCUT_SUM_AMOUNT }"/>		
										<input type="hidden" id="PREPAR" name="PREPAR"  value="${result.PREPAR }"/>		
										<input type="hidden" id="EXCUT_EXPITM_TAXITM_CNT" name="EXCUT_EXPITM_TAXITM_CNT"  value="${result.EXCUT_EXPITM_TAXITM_CNT }"/>		
										<input type="hidden" id="ASSTN_TAXITM_CODE" name="ASSTN_TAXITM_CODE"  value="${result.ASSTN_TAXITM_CODE }"/>		
										<input type="hidden" id="EXCUT_TAXITM_CNTC_ID" name="EXCUT_TAXITM_CNTC_ID"  value="${result.EXCUT_TAXITM_CNTC_ID }"/>
										<input type="hidden" id="FNRSC_SE_CODE" name="FNRSC_SE_CODE"  value="${result.FNRSC_SE_CODE }"/>
										<input type="hidden" id="ACNUT_OWNER_NM" name="ACNUT_OWNER_NM" value="${result.ACNUT_OWNER_NM }"/>
										
										<input type="hidden" id="ETXBL_CONFM_NO" name="ETXBL_CONFM_NO"  value='${result.ETXBL_CONFM_NO }'/> 
										<input type="hidden" id="LN_SQ" name="LN_SQ" value="${result.LN_SQ }" />
										<input type="hidden" id="attachLnSeq" name="attachLnSeq" value="${result.attachLnSeq }" />
										<input type="hidden" id="CO_CD" name="CO_CD"  value="${data.CO_CD}"/>
										<input type="hidden" id="TRNSC_ID_TIME" name="TRNSC_ID_TIME"  value="${result.TRNSC_ID_TIME }"/>
										<input type="hidden" id="TRNSC_ID" name="TRNSC_ID"  value="${result.TRNSC_ID }"/>			
										<input type="hidden" id="CNTC_CREAT_DT" name="CNTC_CREAT_DT"  value="${result.CNTC_CREAT_DT }"/>
										<input type="hidden" id="TAXITM_FNRSC_CNT" name="TAXITM_FNRSC_CNT"  value="${result.TAXITM_FNRSC_CNT }"/>
										
										<input type="hidden" id="KUKGO_STATE_YN" name=""  value="${data.KUKGO_STATE == '미전송' ? 'N' : 'Y'}"/>
										<input type="hidden" id="attachGisuSeq" name="attachGisuSeq"  value=""/>
										
										<input type="hidden" id="tempFileSeq" name=""  value=""/>
										<input type="hidden" id="tempFileSeq1" name=""  value=""/>
										<input type="hidden" id="tmpGisu" name=""  value=""/>
										<input type="hidden" id="MD_DT" name="MD_DT" style="width: 150px" readonly value="${MD_DT }"  />
									</dd>
								</dl>
								<dl class="next2">
									<dt style="width:100px;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" />집행용도</dt>
									<dd>
										<input style="width:480px" type="text" id="EXCUT_PRPOS_CN" name="EXCUT_PROPOS_CN" value="${dataJson.EXCUT_PRPOS_CN }"/>
									</dd>
								</dl>
								<dl class="next2">
								<dt style="width:100px;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" />품목</dt>
									<dd>
										<input style="width:480px" type="text" id="PRDLST_NM" name="PRDLST_NM" value="${dataJson.PRDLST_NM }"/>
									</dd>
								</dl>
								<dl class="next2">
									<dt style="width:100px;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" />증빙선택</dt>
									<dd>
										<input type="text" style="width:118px;" name="PRUF_SE_CODE" id="PRUF_SE_CODE" onchange="" placeholder="" value=""/>
									</dd>
									<dt id="dt_invoice" class = "" style="width:65px; color:#2d57d3;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" />승인번호</dt>
									<dd id="dd_invoice1" class = "" >
										<input type="text" style="width:208px;" id="PRUF_SE_NO" name="PRUF_SE_NO"  value='${result.PRUF_SE_NO }' readonly/>
										<div class="controll_btn p0">
											<button type="button" id="" onclick="searchBtn();">조회</button>
										</div>
									</dd>
								</dl>
	
								<dl class="next2">
									<dt style="width:100px;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" />정산서류 등록</dt>
									<dd style="width:140px;">
										<input type="button"  class=""   style="width:80px; background: #ebebe4;color: #474242; border:;"name="attachFile" id="attachFile"  onclick="fileRow(this);" value="첨부">
										<img id="attachFileYn" src ="<c:url value="/Images/ico/ico_clip02.png"/>"/>
									</dd>
									<dt style="width:100px;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" />증빙일자</dt>
									<dd>
										<input type="text" id="EXCUT_REQUST_DE" name="EXCUT_REQUST_DE" value="${result.EXCUT_REQUST_DE }"/>
									</dd>												
								</dl>
							</div>
						</div>	
						<div class="com_ta" style="">
							<div class="btn_div mt10 cl">
								<div class="left_div">
										<p class="tit_p mt5 mb0">재원정보</p>
								</div>
							</div>
							<div class="top_box gray_box">
								<dl >
									<dt style="width:55px; text-align:right;">합계금액</dt>
									<dd>
										<input type="text" id="SUM_AMOUNT" name="SUM_AMOUNT" style="width: 118px;"  value="${result.SUM_AMOUNT }" readonly class= "money"/>
									</dd>
									<dt style="width:53px; text-align:right;">공급가액</dt>
									<dd>
										<input type="text" id="SPLPC" name="SPLPC" style="width: 118px"  value="${result.SPLPC }" readonly class= "money"/>
									</dd>					
									<dt style="width:60px; text-align:right;">부가세액</dt>
									<dd>
										<input type="text" id="VAT" name="VAT" style="width: 118px;"  value="${result.VAT }" readonly class= "money"/>
									</dd>																			
								</dl>
							</div>
						</div>	
					</div>
					<div style="float : left; margin-top: 16px;">
						<div class="com_ta" style="">
							<div class="btn_div mt10 cl">
								<div class="left_div">
										<p class="tit_p mt5 mb0">거래처 정보</p>
								</div>
							</div>
							<div class="top_box gray_box" style="width: 830px;">
								<dl class = "dt_etc">
									<dt style="width:90px; text-align:right;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" />거래처 구분</dt>
									<dd>
										<input type="text" id="BCNC_SE_CODE" name="BCNC_SE_CODE" style="width: 128px;"  value="" />
									</dd>
									<dt style="width:90px; text-align:right;" id="html_cmpny_name" readonly><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" />거래처명</dt>
									<dd>
										<input style="width:128px" type="text" id="BCNC_CMPNY_NM" name="BCNC_CMPNY_NM" value="${result.BCNC_CMPNY_NM }"/>
									</dd>
									<dt style="width:100px; text-align:right;" id="html_cmpny_no">사업자등록번호</dt>
									<dd>
										<div id="html_div_lsft_no"><input style="width:128px" type="text" id="BCNC_LSFT_NO" name="BCNC_LSFT_NO" value="${result.BCNC_LSFT_NO }" /></div>
										<div id="html_div_pin_no"><input style="width:75px" type="text" id="PIN_NO_1" name = "PIN_NO_1" maxlength="6" value=""/> - <input style="width:18px" type="text" id="PIN_NO_2" name = "PIN_NO_2" maxlength="1" value=""/>******</div>
									</dd>												
								</dl>
								<dl class="next2" id = "ownerInfo">
									<dt style="width:90px;">대표자명</dt>
									<dd>
										<input style="width:128px" type="text" id="BCNC_RPRSNTV_NM" name="BCNC_RPRSNTV_NM" value="${result.BCNC_RPRSNTV_NM }" />
									</dd>
									<dt style="width:90px; text-align:right;">전화번호</dt>
									<dd>
										<input style="width:128px" type="text" id="BCNC_TELNO" name="BCNC_TELNO" value="${result.BCNC_TELNO }" />
									</dd>										
								</dl>
								<dl class="next2 dt_etc" id="html_bcnc_cmpny_cnd_ind">
									<dt style="width:90px;">업태</dt>
									<dd>
										<input type="text" style="width:128px"  name="BCNC_BIZCND_NM" id="BCNC_BIZCND_NM" onchange="" placeholder="" value="${result.BCNC_BIZCND_NM }"/>
									</dd>
									<dt style="width:90px;">업종</dt>
									<dd>
										<input type="text"  style="width:128px" name="BCNC_INDUTY_NM" id="BCNC_INDUTY_NM" onchange="" placeholder="" value="${result.BCNC_INDUTY_NM }"/>
									</dd>
								</dl>
								<dl class="next2">
									<dt style="width:90px; height:85px;">주소</dt>
									<dd>
										<div>
											<input type="text" style="width:128px;" id="POST_CD" name="POST_CD" /><input type="button" style="margin-left:5px;"onclick="postSearchBtn();" value="검색">
										</div>
										<div  style="margin-top:5px;">
											<input type="text" style="width:645px;" id="BCNC_ADRES" name="BCNC_ADRES" value="${result.BCNC_ADRES }"/>
											<input type="hidden"  id="ADDR_D" name="ADDR_D" />
										</div>
									</dd>
								</dl>
								<dl class="next2">
									<dt style="width:90px; color:#2d57d3;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" />은행</dt>
									<dd>
										 <input type="text" id="BCNC_BANK_CODE_NM" name="BCNC_BANK_CODE_NM" value="${result.BCNC_BANK_CODE_NM }" /><img id="" style="margin-left:5px;" src="<c:url value='/Images/ico/ico_explain.png'/>" onclick="fn_backClick();"/>
									</dd>
									<dt style="width:78px;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" />계좌번호</dt>
									<dd>
										<input type="text" id="BCNC_ACNUT_NO" name="BCNC_ACNUT_NO" value="${result.BCNC_ACNUT_NO }"/>
									</dd>										
								</dl>		
								<dl class="next2">
									<dt style="width:90px;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" />이체구분</dt>
									<dd>
										<input type="text" style="width:128px;" id="TRANSFR_ACNUT_SE_CODE" name="TRANSFR_ACNUT_SE_CODE" value="${result.TRANSFR_ACNUT_SE_CODE }"/>
										<input type="text" style="width:180px;" id="SBSACNT_TRFRSN_CODE" name="SBSACNT_TRFRSN_CODE" value="${result.SBSACNT_TRFRSN_CODE }"/>
										<input type="text" style="width:180px;" id="SBSACNT_TRFRSN_CN" name="SBSACNT_TRFRSN_CN" value="${result.SBSACNT_TRFRSN_CN }"/>
									</dd>										
								</dl>	
								<dl class="next2">
									<dt style="width:90px;">내통장표시</dt>
									<dd>
										<input type="text" id="SBSIDY_BNKB_INDICT_CN" name="SBSIDY_BNKB_INDICT_CN" value="${result.SBSIDY_BNKB_INDICT_CN }"/>
									</dd>
									<dt style="width:100px;">받는통장표시</dt>
									<dd>
										<input type="text" id="BCNC_BNKB_INDICT_CN" name="BCNC_BNKB_INDICT_CN" value="${result.BCNC_BNKB_INDICT_CN }"/>
									</dd>										
								</dl>																										
							</div>
						</div>
					</div>					
				</div>
				<div style="float:left; right: 280px; margin-top: 51px; margin-left: 475px;">
					<div class="top_box gray_box" style="margin-top:5px;">
						<dl style="width: 550px;">
							<dt style="width: 60px; text-align: right;">전송결과</dt>
							<dd>
								<input style="width:400px"type="text" id="PROCESS_RESULT_MSSAGE" name="PROCESS_RESULT_MSSAGE" value="${result.PROCESS_RESULT_MSSAGE }" />
							</dd>
						</dl>
					</div>
					<div class="btn_cen pt12">
						<input type="button" id="btnSubmit" onclick="" value="전송">
						<input type="button" id="btnReSubmit" onclick="" value="전송취소">
						<input type="button" id="btnClosePage" onclick="" value="닫기">
					</div>
				</div>
				</form>
			</div>
		</div>
</div>

	<div>
		<form id="submitPage" action="/CustomNPEPIS/kukgoh/resolutionSubmitPage" method="POST">
			 <input type="hidden" id="submitData" name = "submitData" value=""/> 
		</form>
	</div>	
	
	<div class="pop_wrap_dir" id="filePop" style="width:400px; display: none;">
		
		<div class="pop_con">
		<form id="fileForm" method="post" enctype="multipart/form-data" >
			<!-- 타이틀/버튼 -->
			<div class="btn_div mt0">

				<div class="right_div">
					<input type="button" id = "insertFileBtn" onclick="upFile();" value="첨부파일 등록"/>
				</div>
				
			</div>
			<div class="btn_div mt0">
				<div class="left_div"  style="width: 120px;">
					<h5><span id="popupTitle"></span> 첨부파일</h5>
					<input type="hidden" id="loginEmpSeq" name="empSeq" value="${empSeq}" />
				</div>
			<div class="" style="fload : left;" id="">
				<table id="fileDiv"></table>
				<div class="le" id="addfileID">
				</div>	
			</div>
			<div class="">
			
				<span id="orgFile">
					<input type="file" id="fileID" name="fileNm" value="" onChange="getFileNm(this);" class="hidden" />
				</span>			
			</div>
			</div>
		</form>
											
	</div>
	<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" class="gray_btn" value="닫기" onclick="filepopClose();"/>
			</div>
		</div><!-- //pop_foot -->
	</div>	
	
 <div class="pop_wrap_dir" id="loadingPop" style="width: 443px;">
		<div class="pop_con">
			<table class="fwb ac" style="width:100%;">
			<tr>
				<td>
					<span class=""><img src="<c:url value='/Images/ico/loading.gif'/>" alt="" />  &nbsp;&nbsp;&nbsp;데이터를 가져오는 중입니다.</span>		
				</td>
			</tr>
		</table>
		</div>
		<!-- //pop_con -->
</div>	 
<!-- 금융기관 코드 -->
<div class="pop_wrap" id="subPopUp" style="min-width:400px; display:none;">
	<div class="pop_con">	
		<!-- 컨트롤박스 -->
		<div class="com_ta2">
			<div id="bankGrid"></div>
		</div>
	</div><!-- //pop_con -->
	
</div><!-- //pop_wrap -->

<!-- 카드 승인 자료 선택 -->
<div class="pop_wrap_dir" id="cardPopup" style='width: 1200px; display : none;'>
	<div class="pop_head">
			<h1>카드 승인 자료 선택</h1>
		</div>
		<div class="pop_con">
			<div class="com_ta" style="">
					<div class="top_box">
						<dl>
							<dt  class="ar" style="width:65px" >카드번호</dt>
							<dd>
								<div class="controll_btn p0">
									<input type="text" onclick="cardChoiceFn()" id="cardNo"value="" disabled/>
									<input type="button" onclick="cardChoiceFn()" id="searchButton"	value="검색" />
								</div>	
							</dd>
							<dt  class="ar" style="width:65px; padding-left: 85px;" >사용기간</dt>
							<dd>
								<div class="controll_btn p0">
									<input type="text" id="prdUseStart"	value="" />
									~
									<input type="text" id="prdUseEnd"	value="" />
								</div>	
							</dd>
							<dt  class="ar" style="width:65px; padding-left: 60px;" >승인번호</dt>
							<dd>
								<div class="controll_btn p0">
									<input type="text" id="confmNo" value="" />
								</div>	
							</dd>
						</dl>
					</div>
					<!-- 버튼 -->
					<div class="btn_div mt10 cl">
						<div class="right_div">
							<div class="controll_btn p0">
								<button type="button" id="" onclick="cardSearch();">조회</button>
							</div>
						</div>
					</div>
					<div class="com_ta2 mt15" >
						<div id="cardGrid"></div>
					</div>
			</div>
		</div>
</div>
<!-- // 카드 승인 자료 선택 -->

<!-- 카드 번호 선택 -->
<div class="pop_wrap_dir" id="cardNoPopup" style='width: 700px; display : none;'>
	<div class="pop_head">
			<h1>카드번호</h1>
		</div>
		<div class="pop_con">
			<div class="com_ta" style="">
					<div class="top_box">
						<dl>
							<dt  class="ar" style="width:65px" >카드명</dt>
							<dd>
								<div class="controll_btn p0">
									<input type="text" id="cardName" value=""/>
								</div>	
							</dd>
							<dt  class="ar" style="width:130px;" >카드번호 끝 4자리</dt>
							<dd>
								<div class="controll_btn p0">
									<input type="text" id="cardLast4Dgts""	value="" />
								</div>	
								<div class="controll_btn p0">
									<button type="button" id="" onclick="cardNoSearch();">조회</button>
								</div>
							</dd>
						</dl>
					</div>
					<!-- 버튼 -->
					<div class="com_ta2 mt15" >
						<div id="cardNoGrid"></div>
					</div>
			</div>
		</div>
</div>
<!-- //카드 번호 선택 -->

<!-- 세금계산서 전송 화면 -->
<div class="pop_wrap_dir" id="popUp" style="width: 1000px;">
	<div class="pop_head">
		<h1>전자(세금)계산서 승인번호 입력</h1>
	</div>
	<div class="pop_con">
			<p class="tit_p mt5 mt20">전자(세금)계산서는 승인번호 전송 기준 10분~20분 후 e나라도움 연계 집행전송이 가능합니다</p>
	
			<div class="com_ta mt15" style="">
					<input type="hidden" id="BSNSYEAR"  />
					<input type="hidden" id="DDTLBZ_ID"  />
					<input type="hidden" id="EXC_INSTT_ID"  />
					<input type="hidden" id="C_DIKEYCODE" />				
					<input type="hidden" id="GISU_DT"  />
					<input type="hidden" id="GISU_SQ"  />
					<input type="hidden" id="BG_SQ"  />
				<div id="kukgohInvoiceInsertGrid"></div>
			</div>		
	</div>
	<!-- //pop_con -->

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" class="gray_btn" id="cancle2" value="닫기" />
		</div>
	</div>
	<!-- //pop_foot -->
	
</div>	
<!-- 세금계산서 전송 화면 -->

</body>
</html>