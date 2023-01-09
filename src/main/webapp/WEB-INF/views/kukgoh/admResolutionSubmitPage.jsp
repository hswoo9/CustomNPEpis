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
<script type="text/javascript" src="<c:url value='/js/common/postcode2.js' />"></script>
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
	
<script type="text/javascript">
	$(document).ready(function() {
	$('#loadingPop').parent().find('.k-window-action').css("visibility", "hidden");
 		
		$('#loadingPop').kendoWindow({
		     width: "443px",
		     visible: false,
		     modal: true,
		     actions: [
		    	 
			     ],
		     close: false
		 }).data("kendoWindow").center();	 	
		console.log('${data}')
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
        
        //tooltip.show($("#canton"));
        $('#btnClosePage').click(function() {
        	window.close();
            //window.location.href = "<c:url value='/kukgoh/insertSpendingResolution' />";
            //return false;
        });     
        var kukhoStateYN = '${data.KUKGO_STATE_YN}';
       // var kukhoStateYN = JSON.parse('${data}');
       	$('#insertFileBtn').css("display", 'none');
        //증빙선택
        console.log("증빙선택 호출");
        var evidence = JSON.parse('${resultMap.evidence}');
        evidence.unshift({CMMN_DETAIL_CODE_NM : "선택", CMMN_DETAIL_CODE : ""});
		$("#PRUF_SE_CODE").kendoComboBox({
		      dataSource: evidence,
		      dataTextField: "CMMN_DETAIL_CODE_NM",
			  dataValueField: "CMMN_DETAIL_CODE",
			  index: 0,
			  select : fn_prufSeCode,
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
		
		fn_setInit();
		
		//전송
		$('#btnSubmit').on('click', function (){
			fn_btnSubmit();
		});
		
		//재전송
		$('#btnReSubmit').on('click', function (){
			fn_btnCancelSubmit();
		});
		$('#docView').on('click', function (){
			fn_btnDocView();
		});
		
		$('#gisuDt').val(fn_formatDate($('#gisuDt').val()));
		$('#unitAm').val(fn_formatMoney($('#unitAm').val()));
		
		if($('#stateYn').val() == 'Y'){
			$('#btnRequestResolution').hide();
		}	
		
/* 		$('#BCNC_BANK_CODE_NM').dblclick(function(){
			console.log("팝업");
		}); */
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
		$('#attachFileYn').hide();
	});
</script>
<script type="text/javascript">
$(function() {
	bankGrid();
});
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
<script type="text/javascript">
//초기화
function fn_setInit(){
	$('#html_div_lsft_no').show();
	$('#html_div_pin_no').hide();
	//$('#TRANSFR_ACNUT_SE_CODE').val();
}
//증빙선택
function fn_prufSeCode(e){
	var dataItem = this.dataItem(e.item.index());
	if(dataItem.CMMN_DETAIL_CODE == "1" || dataItem.CMMN_DETAIL_CODE =="001" ){
		//fn_selectInvoice();
		fn_selectElecInvoice()
	}else if(dataItem.CMMN_DETAIL_CODE =="2" || dataItem.CMMN_DETAIL_CODE == "002"){
		fn_selectNomalInvoice()
	}else if(dataItem.CMMN_DETAIL_CODE == '004'){
		console.log("보조금전용카드 선택");
		fn_selectCard();
		//$('#dd_invoice').hide();
	}else if(dataItem.CMMN_DETAIL_CODE == "999"){
		console.log("기타 선택");
		fn_selectEtc()
		//fn_selectEtc();
	}

	}
//거래처 구분
function fn_customerGb(e){
	var dataItem = this.dataItem(e.item.index());
	var CMMN_DETAIL_CODE = dataItem.CMMN_DETAIL_CODE;
	console.log('거래처 구분');
	console.log(dataItem);
	$('#html_cmpny_name').text("거래처명");
	$('#html_cmpny_no').text("사업자등록번호");
	$('#html_div_lsft_no').show();
	$('#html_div_pin_no').hide();
	$('#html_bcnc_cmpny_cnd_ind').show();
	if(CMMN_DETAIL_CODE == '001'){
	//법인사업자	
		fn_setCustomerGbCompany()
	}else if(CMMN_DETAIL_CODE == '002'){
	//개인사업자	
		fn_setCustomerGbCompany()
	}else if(CMMN_DETAIL_CODE == '003'){
	//개인
		fn_setCustomerGbPerson();
	}else if(CMMN_DETAIL_CODE == '004'){
	//해외	
		fn_setCustomerGbCompany()
	}
}

//이체구분 선택
function fn_depositGb(e){
	//SBSACNT_TRFRSN_CODE
	//SBSACNT_TRFRSN_CN
	var dataItem = this.dataItem(e.item.index());
	var CMMN_DETAIL_CODE = dataItem.CMMN_DETAIL_CODE;
	
	//var grid = $('#accountGrid').data('kendoGrid');
	//var dataItem2 = grid.dataItem(grid.select());
	//console.log("선택이다");
	//console.log(dataItem2);	
	
	//거래처계좌로 이체
	var SBSACNT_TRFRSN_CODE = $("#SBSACNT_TRFRSN_CODE").data("kendoComboBox");
	

	if(CMMN_DETAIL_CODE == '001'){
		SBSACNT_TRFRSN_CODE.wrapper.hide();
		$("#SBSACNT_TRFRSN_CN").hide();
	}else if(CMMN_DETAIL_CODE == '002'){
		SBSACNT_TRFRSN_CODE.wrapper.show();
		if(SBSACNT_TRFRSN_CODE.value() == '099'){
			$("#SBSACNT_TRFRSN_CN").show();
		}else{
			$("#SBSACNT_TRFRSN_CN").hide();
		}
	} else if(CMMN_DETAIL_CODE == '003'){
		SBSACNT_TRFRSN_CODE.wrapper.show();
	} else if(CMMN_DETAIL_CODE == ''){
		SBSACNT_TRFRSN_CODE.wrapper.hide();
		$("#SBSACNT_TRFRSN_CN").hide();
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
	//$('#SBSACNT_TRFRSN_CODE').val('');
	//$('#SBSACNT_TRFRSN_CN').val('');
	var SBSACNT_TRFRSN_CODE = $("#SBSACNT_TRFRSN_CODE").data("kendoComboBox");
	var BCNC_SE_CODE= $('#BCNC_SE_CODE').val()
	SBSACNT_TRFRSN_CODE.wrapper.hide();
	$('#SBSACNT_TRFRSN_CN').hide();
/* 	if(BCNC_SE_CODE == '003'){
		fn_setCustomerGbPerson();
	} */
	
	
	if(BCNC_SE_CODE == '001'){
		//법인사업자	
		fn_setCustomerGbCompany()
	}else if(BCNC_SE_CODE == '002'){
	//개인사업자	
		fn_setCustomerGbCompany()
	}else if(BCNC_SE_CODE == '003'){
	//개인
		fn_setCustomerGbPerson();
	}else if(BCNC_SE_CODE == '004'){
	//해외	
		fn_setCustomerGbCompany()
	}
    var TRANSFR_ACNUT_SE_CODE = $("#TRANSFR_ACNUT_SE_CODE").data("kendoComboBox");
    var aa = TRANSFR_ACNUT_SE_CODE.value();
    TRANSFR_ACNUT_SE_CODE.value(aa);
    //$("#TRANSFR_ACNUT_SE_CODE").val(TRANSFR_ACNUT_SE_CODE.value());
    if(TRANSFR_ACNUT_SE_CODE.value() == '002'){
    	SBSACNT_TRFRSN_CODE.wrapper.show();
    	SBSACNT_TRFRSN_CODE.value(dataItem.SBSACNT_TRFRSN_CODE);
    	if( $("#SBSACNT_TRFRSN_CODE").val() == '099'){
    		$('#SBSACNT_TRFRSN_CN').show();
    		$('#SBSACNT_TRFRSN_CN').val(dataItem.SBSACNT_TRFRSN_CN);
    	}
    	
    }
    //TRANSFR_ACNUT_SE_CODE.value(dataItem.TRANSFR_ACNUT_SE_CODE);
    //$cbx.select(dataItem.TRANSFR_ACNUT_SE_CODE);
}

function fn_initCustomerGb(){
	
}
//거래처 구분(개인) 셋팅
function fn_setCustomerGbCompany(){
	$('#html_cmpny_name').text("거래처명");
	$('#html_cmpny_no').text("사업자등록번호");
	$('#html_div_lsft_no').show();
	$('#html_div_pin_no').hide();
	$('#html_bcnc_cmpny_cnd_ind').show();
}
function fn_setCustomerGbPerson(){
	$('#html_cmpny_name').text("성명");
	$('#html_cmpny_no').text("주민등록번호");
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
/* 	var myArray = $.map(dataItem, function(value, index) {
		   return [value];
		}); */
//		console.log(myArray);
		var anObj = dataItem;
		var keys = Object.keys(dataItem);
		for(var i = 0; i<keys.length; i++){
			var key = keys[i];
			$('#'+key).val(dataItem[key]);
		}
		// 사업자등록번호 셋팅
		var BCNC_LSFT_NO = $('#BCNC_LSFT_NO').val();
		console.log("BCNC_LSFT_NO : " + BCNC_LSFT_NO );
		if((dataItem.BCNC_SE_CODE == '003') ){
			if(BCNC_LSFT_NO.length == 7){
				$('#PIN_NO_1').val(BCNC_LSFT_NO.substring(0,6));
				$('#PIN_NO_2').val(BCNC_LSFT_NO.substring(6,7));
			}else if(dataItem.PIN_NO_1 == null){
				$('#PIN_NO_1').val("");
				$('#PIN_NO_2').val("");
			}
		}else{
			if(BCNC_LSFT_NO.length == 10){
				$('#BCNC_LSFT_NO').val(BCNC_LSFT_NO.substring(0,3)+'-'+BCNC_LSFT_NO.substring(3,5)+'-'+BCNC_LSFT_NO.substring(5,11));	
			}
		}
		if($('#EXCUT_REQUST_DE').val().length == '8'){
			var parseDate = $('#EXCUT_REQUST_DE').val();
			
			$('#EXCUT_REQUST_DE').val(fn_formatDate(parseDate));
		}
		fn_setSelectInit(dataItem);
		
		/* for ( var key in keys) {
			key = key.replace("\"", "");
			$('#'+key).val(dataItem[key]);
		} */
}

function fn_closePage(){
	
}
function fn_validationCheck(){
	console.log("집행정보 반영 체크");
	//폼 입력
	
	if($('#PRUF_SE_CODE').val() == '999'){
		$('#PRUF_SE_NO').val('');
	}
	var EXCUT_PRPOS_CN = $('#EXCUT_PRPOS_CN').val()
	var PRDLST_NM = $('#PRDLST_NM').val()
	var PRUF_SE_NO = $('#PRUF_SE_NO').val()
	var EXCUT_REQUST_DE = $('#EXCUT_REQUST_DE').val()
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
	var BCNC_ACNUT_NO = $('#BCNC_ACNUT_NO').val()
	var TRANSFR_ACNUT_SE_CODE = $('#TRANSFR_ACNUT_SE_CODE').val()
	var SBSACNT_TRFRSN_CODE = $('#SBSACNT_TRFRSN_CODE').val()
	var SBSACNT_TRFRSN_CN = $('#SBSACNT_TRFRSN_CN').val()
	var SBSIDY_BNKB_INDICT_CN = $('#SBSIDY_BNKB_INDICT_CN').val()
	var BCNC_BNKB_INDICT_CN = $('#BCNC_BNKB_INDICT_CN').val();
	var PIN_NO_1 =  $('#PIN_NO_1').val();
	var PIN_NO_2 =  $('#PIN_NO_2').val();
	var PIN_NO = $('#PIN_NO_1').val() + "" + $('#PIN_NO_2').val() + "000000";
	
	var frm = $("#sendForm").serialize();
	//곽경훈 수정
	$.ajax({
		url : "<c:url value='/kukgoh/saveCheck' />",
		data : frm,
		type : 'POST',
		async : true,
		success : function(result) {
 			if(result.OUT_YN == 'Y'){
				alert("집행정보가 반영 되었습니다.");	
				var grid = $('#accountGrid').data('kendoGrid');
				var dataItem = grid.dataItem(grid.select());
				dataItem.set('APPLY_DIV', '★');
				
				//원본 그리드 수정
				
				dataItem.set('EXCUT_PRPOS_CN', EXCUT_PRPOS_CN);
			 	dataItem.set('PRDLST_NM', PRDLST_NM);
				dataItem.set('PRUF_SE_NO', PRUF_SE_NO);
				dataItem.set('EXCUT_REQUST_DE',EXCUT_REQUST_DE);
				dataItem.set('BCNC_SE_CODE', BCNC_SE_CODE);
				dataItem.set('PRUF_SE_CODE', PRUF_SE_CODE);
				dataItem.set('BCNC_CMPNY_NM', BCNC_CMPNY_NM);
				dataItem.set('BCNC_BANK_CODE', BCNC_BANK_CODE);
				dataItem.set('BCNC_RPRSNTV_NM', BCNC_RPRSNTV_NM);
				dataItem.set('BCNC_TELNO', BCNC_TELNO);
				dataItem.set('BCNC_BIZCND_NM', BCNC_BIZCND_NM);
				dataItem.set('BCNC_INDUTY_NM', BCNC_INDUTY_NM);
				dataItem.set('BCNC_ADRES',  BCNC_ADRES);
				dataItem.set('BCNC_BANK_CODE_NM', BCNC_BANK_CODE_NM);
				dataItem.set('BCNC_ACNUT_NO', BCNC_ACNUT_NO);
				dataItem.set('TRANSFR_ACNUT_SE_CODE', TRANSFR_ACNUT_SE_CODE);
				dataItem.set('SBSACNT_TRFRSN_CODE', SBSACNT_TRFRSN_CODE);
				dataItem.set('SBSACNT_TRFRSN_CN', SBSACNT_TRFRSN_CN);
				dataItem.set('SBSIDY_BNKB_INDICT_CN', SBSIDY_BNKB_INDICT_CN);
				dataItem.set('BCNC_BNKB_INDICT_CN',  BCNC_BNKB_INDICT_CN);
				dataItem.set('PIN_NO_1',  PIN_NO_1);
				dataItem.set('PIN_NO_2',  PIN_NO_2);
			}else{
				alert(result.OUT_MSG);
			} 
		},	
		beforeSend: function() {
	        //마우스 커서를 로딩 중 커서로 변경
	        $('html').css("cursor", "wait");
	    	$('#loadingPop').data("kendoWindow").open();
	    },
	    complete: function() {
	        //마우스 커서를 원래대로 돌린다
	        $('html').css("cursor", "auto");
	    	$('#loadingPop').data("kendoWindow").close();
	    }	
		}); 
}

//집행정보 전송
function fn_btnSubmit(){
	console.log("집행정보 전송");
	//폼 입력
	$('#SUM_AMOUNT').val(getNumString($('#SUM_AMOUNT').val()));
	$('#SPLPC').val(getNumString($('#SUM_AMOUNT').val()));
	$('#VAT').val(getNumString($('#VAT').val()));	
	
	//
	// 여기 입력하자
	var dt = $('#gisuDt').val().replace(/\-/g,'');
	$('#attachGisuSeq').val(dt+""+pad($('#gisuSeq').val(), 4)+pad($('#attachLnSeq').val(), 2));
	var targetForm = $("#sendForm :input");
	$.each(targetForm, function(index, elem){
	      $(this).val($(this).val().replace(/,/g, ''));
	});
	var frm = $("#sendForm").serialize();
	$('#btnSubmit').attr("disabled", true);
	//var data = accountGridDataSource;#getSr
	
	data = getSendParam(accountGridDataSource._data);
	//곽경훈 수정
	$.ajax({
		url : "<c:url value='/kukgoh/sendInfo' />",
		data : {param : JSON.stringify(data)},
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
	        //마우스 커서를 로딩 중 커서로 변경
	        $('html').css("cursor", "wait");
	    	$('#loadingPop').data("kendoWindow").open();
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

//집행정보 재전송
function fn_btnCancelSubmit(){
	console.log("집행정보 재전송");
	//폼 입력
	var data = {
		CO_CD : $('#CO_CD').val()
		,GISU_DT : $('#gisuDt').val().replace(/\-/g,'')
		,GISU_SQ : $('#gisuSeq').val()
		,BG_SQ : $('#BG_SQ').val()
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
			alert(result.OUT_MSG);
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
			//FILE_ID : "",
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
function fileRow(){
 	 //$('#popupTitle').text(dataItem.education_name)
 	var dt = $('#gisuDt').val().replace(/\-/g,'');

 	 var data = {
 			INTRFC_ID : $('#INTRFC_ID').val(),
 			TRNSC_ID : $('#TRNSC_ID').val(),
 			//FILE_ID : "",
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
 				for (var i = 0 ; i < result.list.length ; i++) {
						fn_setFileDivY(result, i);
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
	//row.find('#fileID1').val(fileNm);
	row.find('#fileText').text(fileNm).css({'color':'#0033FF','margin-left':'5px'});
	insertFile(fileNm);
}
function insertFile(fileNm){
	var dt = $('#gisuDt').val().replace(/\-/g,'');
	var form = new FormData($("#fileForm")[0]);
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
	$('#BCNC_LSFT_NO').prop('readonly', true);		//
	//
	//$('#BCNC_BIZCND_NM').prop('readonly', false);		//계좌번호
	//이체구분
	$('#SBSIDY_BNKB_INDICT_CN').prop('readonly', false);//내통장표시
	$('#BCNC_BNKB_INDICT_CN').prop('readonly', false);//받는통장표시
}
function fn_selectNomalInvoice(){
	//비활성 : 거래처구분, 거래처명, 사업자등록번호, 업태 , 업종, 주소, 예금주명, 
	//대표자명, 전화번호, , 은행명, 계좌번호,  이체구분, 내통장표시, 받는통장표시
	//승인번호는 다 있다.
	//비활성
	//$('#dd_invoice').show();	//전자세금계산서 불러오기
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
	//$('#dd_invoice').show();	//전자세금계산서 불러오기
	$('#dt_invoice').show();	//승인번호
	$('#dd_invoice1').show();	//승인번호
	$('#EXCUT_REQUST_DE').data("kendoDatePicker").readonly(true);	 //거래처구분
	//$('#EXCUT_REQUST_DE').prop('readonly', true);	//거래처명

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
	<!-- 사원팝업 ajax -->
	

	<!-- 메인그리드 -->
<script type="text/javascript">	
$(function() {
	mainGrid();
});
	function mainGrid(){
		var accountGrid = $("#accountGrid").kendoGrid({
			dataSource : accountGridDataSource,
			dataBound : gridDataBound,
			dataBinding: onDataBinding,
			height : 250,
			sortable : true,
/* 			pageable : {
				refresh : true,
				pageSizes : true,
				buttonCount : 10
			},  */
			persistSelection : true,
			selectable : "multiple",
	        columns: [
	        	{
					field : "TR_NM",
					title : "거래처명",
					width : 100
				},{
					//field : "UNIT_AM",
					template : function(dataItem){
						return fn_formatMoney(dataItem.UNIT_AM);
					},	
					title : "금액",
					width : 100
				},{
					//field : "SUP_AM",
					template : function(dataItem){
						return fn_formatMoney(dataItem.SUP_AM);
					},		
					title : "공급가액",
					width : 100
				},{
					template : function(dataItem){
						return fn_formatMoney(dataItem.VAT_AM);
					},					
					title : "부가세",
					width : 80
				}],
	        change: function (e){
	        	accountGridClick(e)
	        }
	    }).data("kendoGrid");
		
		accountGrid.table.on("click", ".checkbox", selectRow);
		
		var checkedIds = {};
		
		// on click of the checkbox:
		function selectRow(){
			var checked = this.checked,
			row = $(this).closest("tr"),
			grid = $('#accountGrid').data("kendoGrid"),
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
		function accountGridClick(e){
			console.log("accountGridClick");
			var dataItem = $("#accountGrid").data("kendoGrid").dataItem($("#accountGrid").data("kendoGrid").select());
			
			$('#attachLnSeq').val(pad(dataItem.LN_SQ, 2));
			
			fn_setInfo(dataItem);
			fn_initTextBox(dataItem);
			fileCountChenck();	
			//선택시 이체구분 먹이기
		}
		function gridDataBound(e){
			var grid = e.sender;
			console.log(grid);
			if (grid.dataSource.total() == 0) {
				var colCount = grid.columns.length;
				//$(e.sender.wrapper).find('tbody').append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
			}else{
				console.log("gridDataBound");
				//console.log("그리드 첫번째 클릭");
				grid.select("tr:eq(1)");
				var purcSeCode = grid._data[0].PRUF_SE_CODE;
				console.log("그리드 데이터");
				console.log(grid._data[0]);
				$('#attachLnSeq').val(pad(grid._data[0].LN_SQ, 2));
				if(purcSeCode == "1" || purcSeCode == "001"){
					fn_selectElecInvoice();
				}else if(purcSeCode =="002" || purcSeCode =="2"){
					fn_selectNomalInvoice();
				}else if(purcSeCode == '004'){
					console.log("보조금전용카드 선택");
					fn_selectCard();
				}else if(purcSeCode == "999"){
					fn_selectEtc();
				}
			}
		}
		function onDataBinding(e){
			console.log("onDataBinding");
		}
	}
	var accountGridDataSource = new kendo.data.DataSource({
		serverPaging : false,
		//pageSize : 10,
		transport : {
			read : {
				url : _g_contextPath_+"/kukgoh/admAccountGrid",
				dataType : "json",
				type : 'post'
			},
			parameterMap : function(data, operation) {
				data.coCd =$('#CO_CD').val();
				data.gisuDt = $('#gisuDt').val().replace(/-/g,"");
				data.gisuSeq = $("#gisuSeq").val();
				data.bgSeq = $("#BG_SQ").val();
				data.stateYn = $("#stateYn").val();
				data.DOC_TITLE = $("#docTitle").val();
				data.cntcSeq = $("#CNTC_SQ").val();
				return data;
			}
		},
		schema : {
			data : function(response) {
				return response.list;
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
	var openWin;
	function fn_requestInvoice(){
        // window.name = "부모창 이름"; 
        window.name = "resolutionSubmitPage";
        // window.open("open할 window", "자식창 이름", "팝업창 옵션");
        //BSNSYEAR
        var url = _g_contextPath_+"/kukgoh/requestInvoicePage?BSNSYEAR="+$('#BSNSYEAR').val()
        		+"&FILE_ID="+$('#FILE_ID').val()
        		+"&DDTLBZ_ID="+$('#DDTLBZ_ID').val()
        		+"&EXC_INSTT_ID="+$('#EXC_INSTT_ID').val()
        		+"&ETXBL_CONFM_NO="+$('#ETXBL_CONFM_NO').val()
        		+"&empSeq="+$('#empSeq').val()
        openWin = window.open(url, "openWin", "width=1180, height=750, resizable = no, scrollbars = no");
        
	}
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
	</script>
	<script type="text/javascript">
	$(function() {
		sendGrid();
	});
		function sendGrid(){
			var sendGrid = $("#sendGrid").kendoGrid({
				dataSource : sendGridDataSource,
				dataBound : gridDataBound,
				dataBinding: onDataBinding,
				height : 250,
				sortable : true,
				persistSelection : true,
				selectable : "multiple",
		        columns: [
		        	{
						field : "CNTC_SQ",
						title : "집행전송 순번",
						width : 100
					},{
						field : "CNTC_DATETIME",
						title : "집행전송 일시",
						width : 100
					},{
						field : "CNTC_EMP",
						title : "집행전송 사원",
						width : 100
					}],
		        change: function (e){
		        	sendGridClick(e)
		        }
		    }).data("kendoGrid");
			
			sendGrid.table.on("click", ".checkbox", selectRow);
			
			var checkedIds = {};
			
			// on click of the checkbox:
			function selectRow(){
				var checked = this.checked,
				row = $(this).closest("tr"),
				grid = $('#sendGrid').data("kendoGrid"),
				dataItem = grid.dataItem(row);
				console.log("전송리스트 클릭");
				checkedIds[dataItem.ANNV_USE_ID] = checked;
				if (checked) {
					//-select the row
					row.addClass("k-state-selected");
				} else {
					//-remove selection
					row.removeClass("k-state-selected");
				}
			}
			function sendGridClick(e){
				console.log("sendGridClick");
				//$('#attachLnSeq').val(pad(dataItem.LN_SQ, 2));
				
				var rows = sendGrid.select();
				var record;
				rows.each(function() {
					record = sendGrid.dataItem($(this));
					//console.log(record);
				});
				console.log(record);
				$('#CNTC_SQ').val(record.CNTC_SQ);
				//subReload(record);
				$("#accountGrid").data('kendoGrid').dataSource.read();
				//선택시 이체구분 먹이기
			}
			function gridDataBound(e){
				var grid = e.sender;
				console.log(grid);
				if (grid.dataSource.total() == 0) {
					var colCount = grid.columns.length;
					$(e.sender.wrapper).find('tbody').append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
				}else{
					console.log("gridDataBound");
				}
			}
			function onDataBinding(e){
				console.log("onDataBinding");
			}
		}
		var sendGridDataSource = new kendo.data.DataSource({
			serverPaging : true,
			pageSize : 10,
			transport : {
				read : {
					url : _g_contextPath_+"/kukgoh/admSendGrid",
					dataType : "json",
					type : 'post'
				},
				parameterMap : function(data, operation) {
					data.coCd =$('#CO_CD').val();
					data.gisuDt = $('#gisuDt').val().replace(/-/g,"");
					data.gisuSeq = $("#gisuSeq").val();
					data.bgSeq = $("#BG_SQ").val();
					return data;
				}
			},
			schema : {
				data : function(response) {
					return response.list;
				},
				total : function(response) {
					return response.total;
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
	
	</script>
	<div class="iframe_wrap" style="min-width: 800px;">
		<div class="sub_title_wrap">
			<div class="title_div">
				<h4>지출결의서 집행전송</h4>

			</div>
			<div class="sub_contents_wrap">
				<p class="tit_p mt5 mt20">지출결의서 집행전송</p>
					<form id="sendForm" action="" method="POST">
					<div class="top_box demo-section k-content wide" id="tooltip">
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
								<input type="hidden" id="stateYn" value='${data.KUKGO_STATE_YN}'  name = "KUKGO_STATE_YN"/>
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
								<input type="text" id="docTitle"  title="${data.DOC_TITLE}" style="width:452px" value='${data.DOC_TITLE}' readonly name="DOC_TITLE"/>
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
						    <dt  class="ar" style="width:128px" >하위사업</dt>
							<dd>
								<input type="text" id="bottomNm" style="width:160px" value='${data.BOTTOM_NM}' title="${data.BOTTOM_NM}" readonly  name="BOTTOM_NM"/>
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
					<div>
					<div style="width: 580px; float: left; padding-right: 30px;">
						<div class="btn_div mt10 cl">
							<div class="left_div">
									<p class="tit_p mt5 mb0"></p>
							</div>
						</div>
						<div class="left_div">
								<p class="tit_p mt5 mb0">전송리스트</p>
						</div>					
						<div id="sendGrid">
						</div>
						<div class="left_div">
								<p class="tit_p mt5 mb0">전송(미전송) 내역</p>
						</div>						
						<div id="accountGrid">
						</div>					
						<div class="top_box gray_box" style="margin-top:5px;">
							<dl>
								<dt style="width: 60px; text-align: right;">전송결과</dt>
								<dd>
									<input style="width:400px"type="text" id="PROCESS_RESULT_MSSAGE" name="PROCESS_RESULT_MSSAGE" readonly/>
								</dd>
							</dl>
						</div>
						<div class="btn_cen pt12">
							<input type="button" id="btnClosePage" onclick="" value="닫기">
						</div>						
					</div>					
					<div style=" float: left;">
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
											<input type="text" id="ASSTN_TAXITM_CODE_NM" name="ASSTN_TAXITM_CODE_NM" style="width: 140px" readonly value=""  />
											<input type="hidden" id="BSNSYEAR" name="BSNSYEAR" value=''/>
											<input type="hidden" id="DDTLBZ_ID" name="DDTLBZ_ID"  value=''/>
											<input type="hidden" id="EXC_INSTT_ID" name="EXC_INSTT_ID"  value=''/>
											
											<!-- 집행정보 반영 -->
											<input type="hidden" id="APPLY_DIV" name="APPLY_DIV"  value=""/>
											<input type="hidden" id="INTRFC_ID" name=""  value=""/>
											
	
											<input type="hidden" id="EXCUT_TY_SE_CODE" name="EXCUT_TY_SE_CODE"  value=""/>			
											<input type="hidden" id="BCNC_BANK_CODE" name="BCNC_BANK_CODE"  value=""/>	
											<input type="hidden" id="EXCUT_SPLPC" name="EXCUT_SPLPC"  value=""/>		
											<input type="hidden" id="EXCUT_VAT" name="EXCUT_VAT"  value=""/>			
											<input type="hidden" id="EXCUT_SUM_AMOUNT" name="EXCUT_SUM_AMOUNT"  value=""/>		
											<input type="hidden" id="PREPAR" name="PREPAR"  value=""/>		
											<input type="hidden" id="EXCUT_EXPITM_TAXITM_CNT" name="EXCUT_EXPITM_TAXITM_CNT"  value=""/>		
											<input type="hidden" id="ASSTN_TAXITM_CODE" name="ASSTN_TAXITM_CODE"  value=""/>		
											<input type="hidden" id="EXCUT_TAXITM_CNTC_ID" name="EXCUT_TAXITM_CNTC_ID"  value=""/>
											<input type="hidden" id="FNRSC_SE_CODE" name="FNRSC_SE_CODE"  value=""/>
											<input type="hidden" id="ACNUT_OWNER_NM" name="ACNUT_OWNER_NM" />
											
											<!-- 거래처 순번 -->
											<input type="hidden" id="ETXBL_CONFM_NO" name="ETXBL_CONFM_NO"  value=''/> 
											<input type="hidden" id="LN_SQ" name="LN_SQ"  />
											<input type="hidden" id="attachLnSeq" name="attachLnSeq"  />
											<input type="hidden" id="CO_CD" name="CO_CD"  value="${data.CO_CD}"/>
											<input type="hidden" id="TRNSC_ID_TIME" name="TRNSC_ID_TIME"  value=""/>
											<input type="hidden" id="TRNSC_ID" name="TRNSC_ID"  value=""/>			
											<input type="hidden" id="CNTC_CREAT_DT" name="CNTC_CREAT_DT"  value=""/>
											<input type="hidden" id="TAXITM_FNRSC_CNT" name="TAXITM_FNRSC_CNT"  value=""/>
											<input type="hidden" id="FILE_ID" name="FILE_ID"  value=""/>
											<input type="hidden" id="CNTC_SQ" name="CNTC_SQ"  value=""/>
											
											
											<input type="hidden" id="KUKGO_STATE_YN" name=""  value="${data.KUKGO_STATE_YN}"/>
											<input type="hidden" id="attachGisuSeq" name="attachGisuSeq"  value=""/>
											
											<input type="hidden" id="tempFileSeq" name=""  value=""/>
											<input type="hidden" id="tempFileSeq1" name=""  value=""/>
											<input type="hidden" id="tmpGisu" name=""  value=""/>
											<input type="hidden" id="MD_DT" name="MD_DT" style="width: 150px" readonly value=""  />
											
											<!-- <input type="hidden" id="ETXBL_CONFM_NO" name="ETXBL_CONFM_NO"  value=''/> -->
										</dd>
<!-- 										<dt style="width:100px; text-align:right;">작성일자</dt>
										<dd>
											<input type="text" id="MD_DT" name="MD_DT" style="width: 150px" readonly value=""  />
										</dd>	 -->											
									</dl>
									<dl class="next2">
										<dt style="width:100px;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" />집행용도</dt>
										<dd>
											<input style="width:625px" type="text" id="EXCUT_PRPOS_CN" name="EXCUT_PROPOS_CN" disabled/>
										</dd>
									</dl>
									<dl class="next2">
									<dt style="width:100px;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" />품목</dt>
										<dd>
											<input style="width:625px" type="text" id="PRDLST_NM" name="PRDLST_NM" disabled/>
										</dd>
									</dl>
									<dl class="next2">
										<dt style="width:100px;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" />증빙선택</dt>
										<dd>
											<input type="text" style="width:118px;" name="PRUF_SE_CODE" id="PRUF_SE_CODE" onchange="" placeholder="" disabled/>
											<!-- <input type="button" style="width:100px;" id="dd_invoice" class="invoice"  onclick="fn_requestInvoice();" value='조회'> -->
										</dd>
 										<dt id="dt_invoice" class = "" style="width:122px; color:#2d57d3;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" />승인번호</dt>
										<dd id="dd_invoice1" class = "" >
											<input type="text" style="width:290px;" id="PRUF_SE_NO" name="PRUF_SE_NO"  value='' disabled/>
											
											<!-- <input type="button" style="background: #ebebe4;color: #474242; border:;" class="text_black"   name="btnGetPrufSeNo" id="btnGetPrufSeNo"  value="전자(세금)계산서 가져오기"> -->
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
											<input type="text" id="EXCUT_REQUST_DE" name="EXCUT_REQUST_DE" disabled/>
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
										<dt style="width:100px; text-align:right;">합계금액</dt>
										<dd>
											<input type="text" id="SUM_AMOUNT" name="SUM_AMOUNT" style="width: 118px;"  value="" readonly class= "money"/>
										</dd>
										<dt style="width:100px; text-align:right;">공급가액</dt>
										<dd>
											<input type="text" id="SPLPC" name="SPLPC" style="width: 118px"  value="" readonly class= "money"/>
										</dd>					
										<dt style="width:100px; text-align:right;">부가세액</dt>
										<dd>
											<input type="text" id="VAT" name="VAT" style="width: 118px;"  value="" readonly class= "money"/>
										</dd>																			
									</dl>
								</div>
							</div>	
							<div class="com_ta" style="">
								<div class="btn_div mt10 cl">
									<div class="left_div">
											<p class="tit_p mt5 mb0">거래처 정보</p>
									</div>
								</div>
								<div class="top_box gray_box">
									<dl class = "dt_etc">
										<dt style="width:90px; text-align:right;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" />거래처 구분</dt>
										<dd>
											<input type="text" id="BCNC_SE_CODE" name="BCNC_SE_CODE" style="width: 128px;"  value="" disabled/>
										</dd>
										<dt style="width:90px; text-align:right;" id="html_cmpny_name" readonly><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" />거래처명</dt>
										<dd>
											<input style="width:128px" type="text" id="BCNC_CMPNY_NM" name="BCNC_CMPNY_NM" disabled/>
										</dd>
										<dt style="width:100px; text-align:right;" id="html_cmpny_no"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" />사업자등록번호</dt>
										<dd>
											<div id="html_div_lsft_no"><input style="width:128px" type="text" id="BCNC_LSFT_NO" name="BCNC_LSFT_NO" disabled/></div>
											<div id="html_div_pin_no"><input style="width:75px" type="text" id="PIN_NO_1" name = "PIN_NO_1" maxlength="6" disabled/> - <input style="width:18px" type="text" id="PIN_NO_2" name = "PIN_NO_2" maxlength="1" disabled/>******</div>
										</dd>												
									</dl>
									<dl class="next2" id = "ownerInfo">
										<dt style="width:90px;">대표자명</dt>
										<dd>
											<input style="width:128px" type="text" id="BCNC_RPRSNTV_NM" name="BCNC_RPRSNTV_NM" disabled/>
										</dd>
										<dt style="width:90px; text-align:right;">전화번호</dt>
										<dd>
											<input style="width:128px" type="text" id="BCNC_TELNO" name="BCNC_TELNO" disabled />
										</dd>										
									</dl>
									<dl class="next2 dt_etc" id="html_bcnc_cmpny_cnd_ind">
										<dt style="width:90px;">업태</dt>
										<dd>
											<input type="text" style="width:128px"  name="BCNC_BIZCND_NM" id="BCNC_BIZCND_NM" onchange="" placeholder="" disabled/>
										</dd>
										<dt style="width:90px;">업종</dt>
										<dd>
											<input type="text"  style="width:128px" name="BCNC_INDUTY_NM" id="BCNC_INDUTY_NM" onchange="" placeholder="" disabled/>
										</dd>
									</dl>
									<dl class="next2">
										<dt style="width:90px; height:85px;">주소</dt>
										<dd>
											
											<div>
												<input type="text" style="width:128px;" id="POST_CD" name="POST_CD" disabled/>
											</div>
											<div  style="margin-top:5px;">
												<input type="text" style="width:645px;" id="BCNC_ADRES" name="BCNC_ADRES" disabled/>
												<input type="hidden"  id="ADDR_D" name="ADDR_D" />
											</div>
										</dd>
									</dl>
									<dl class="next2">
										<dt style="width:90px; color:#2d57d3;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" />은행</dt>
										<dd>
											 <input type="text" id="BCNC_BANK_CODE_NM" name="BCNC_BANK_CODE_NM" disabled/><img id="" style="margin-left:5px;" src="<c:url value='/Images/ico/ico_explain.png'/>" onclick=""/>
										</dd>
										<dt style="width:78px;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" />계좌번호</dt>
										<dd>
											<input type="text" id="BCNC_ACNUT_NO" name="BCNC_ACNUT_NO" disabled/>
										</dd>										
									</dl>		
									<dl class="next2">
										<dt style="width:90px;"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" />이체구분</dt>
										<dd>
											<input type="text" style="width:128px;" id="TRANSFR_ACNUT_SE_CODE" name="TRANSFR_ACNUT_SE_CODE" disabled/>
											<input type="text" style="width:180px;" id="SBSACNT_TRFRSN_CODE" name="SBSACNT_TRFRSN_CODE" disabled/>
											<input type="text" style="width:180px;" id="SBSACNT_TRFRSN_CN" name="SBSACNT_TRFRSN_CN" disabled/>
										</dd>										
									</dl>	
									<dl class="next2">
										<dt style="width:90px;">내통장표시</dt>
										<dd>
											<input type="text" id="SBSIDY_BNKB_INDICT_CN" name="SBSIDY_BNKB_INDICT_CN" disabled/>
										</dd>
										<dt style="width:100px;">받는통장표시</dt>
										<dd>
											<input type="text" id="BCNC_BNKB_INDICT_CN" name="BCNC_BNKB_INDICT_CN" disabled/>
										</dd>										
									</dl>																										
								</div>

							</div>												
						</div>
					</div>
					</form>
				</div>
			</div>
	</div>

	<div>
		<form id="submitPage" action="/CustomNPTpf/kukgoh/resolutionSubmitPage" method="POST">
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
					<!-- <input type="hidden" id="targetId" name="targetId" value="" /> -->
					
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
</body>
</html>