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

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
</head>
<style type="text/css">
.k-header .k-link {text-align: center; }
.k-grid-content>table>tbody>tr {text-align: center;}
.k-grid th.k-header, .k-grid-header { background: #F0F6FD; }
.customer-photo{	width : 70px; height : auto;}

[data-title="지출결의 정보"] { color : blue; }
[data-title="ENARA 집행 전송 정보"] { color : #CF1911; }
[data-title="집행 전송 정보"] { color : #0E15AF; }
.iframe_wrap { height: 950px; }
.yColor { color : #3f8517; font-weight : 600; } .nColor { color : red; }
.font-underline { text-decoration : underline; }
</style>

<body style="height: 200px;">
	<input type="hidden" id="nowMonth" value="${year}${mm}" />
	
	<input type="hidden" id="dayOrTimeGubun" value="0" />
<!-- 전역 변수, 이벤트 리스너 등 -->	
<script type="text/javascript">
  	var attachDataItem = "";
	var deptSeq = "${loginMap.deptSeq}";
	var deptNm = "${deptNm}";
	var pdfErrorList = [];
  	
	$(document).ready(function() {
		
		$.ajax({
			url : "<c:url value='/resAlphaG20/selectPdfErrorDocs' />",
			data : {
				fromDate : moment().format('YYYY-MM-01'),
				toDate : moment(new Date()).format("YYYY-MM-DD") + ' 23:59:59',
				searchWord : ''
			},
			type : 'POST',
			async : false,
			success : function(result) {
				
				result.list.forEach(function(v, i) {
					pdfErrorList.push(v.c_dikeycode);
				});
			}	
		});
		
		window.scrollTo(0, 48);
		
		$(document).on("click", "#mainGrid tbody tr", function(e) {
			row = $(this)
			grid = $('#mainGrid').data("kendoGrid"),
			dataItem = grid.dataItem(row);
			
			console.log(dataItem);	
		})
		
// 		$(document).on('click', '.Nbox', function() {
// 			alert('전송불가 데이터입니다.');
// 			$(this).attr('checked', false);
// 		});
		
		$('#loadingPop').parent().find('.k-window-action').css("visibility", "hidden");
		$('#loadingPop').kendoWindow({
		     width: "443px",
		     visible: false,
		     modal: true,
		     actions: [],
		     close: false
		 }).data("kendoWindow").center();
		
		var allDept = JSON.parse('${allDept}');
		
		if (deptSeq === '1208' || deptSeq === '1') { // 재무관리실만 모든 사원 조회 권한
			allDept.unshift({dept_name : "전체", dept_seq : "99999"});
			$("#deptNm").kendoComboBox({
			      dataSource: allDept,
			      dataTextField: "dept_name",
				  dataValueField: "dept_seq",
				  select : onDeptSeqSelect,
			});
			
			$("#deptNm").data('kendoComboBox').value('99999');	// 기본값 전체
		}
		
		$('#filePop').kendoWindow({
		    width: "400px",
		    title: '첨부파일 확인',
		    visible: false,
		    modal : true,
		    actions: [
		        "Close"
		    ],
		}).data("kendoWindow").center();
		
	    $("#endMonth").kendoDatePicker({
	        start: "month",
	        depth: "month",
	        format: "yyyy-MM-dd",
			parseFormats : ["yyyy-MM-dd"],
	        culture : "ko-KR",
	        dateInput: true
	    });
	    
	    $("#endMonth").val( moment(new Date()).format("YYYY-MM-DD"));		
	    
	    $("#fromMonth").kendoDatePicker({
	        start: "month",
	        depth: "month",
	        format: "yyyy-MM-dd",
			parseFormats : ["yyyy-MM-dd"],
	        culture : "ko-KR",
	        dateInput: true
	    });	  
	    
	    $("#fromMonth").val(moment().format('YYYY-MM-01'));
	  
		 //-----<<사원정보 팝업 초기화
	    $("#empSearch").click(function(){	
	    	 $('#emp_name').val("");
	    	 $("#empPopUp").data("kendoWindow").open();
	    	 empGridReload();
		 });
	    
		 //팝업 초기화
		 $("#empPopUp").kendoWindow({
		     width: "600px",
		    height: "750px",
		     visible: false,
		     actions: ["Close"]
		 }).data("kendoWindow").center();
		 
	     function empPopUpClose(){
	    	 $("#empPopUp").data("kendoWindow").close();
	     }
	     
		 $("#empPopUpCancel").click(function(){
			 $("#empPopUp").data("kendoWindow").close();
		 });
		//사원정보 팝업 초기화----->>
	  
		$("#status").kendoComboBox({
			dataSource: [
				{text : "전체", value : "999"}
				,{text : "미전송", value : "0"}
				,{text : "전송진행중", value : "2"}
		      	,{text : "전송", value : "1"}
		      ],
		      dataTextField: "text",
		      dataValueField: "value",
		      index: 1,
		      select : onSelect
		});
		
        function onSelect(e) {
    		var dataItem = this.dataItem(e.item.index());
     	}		

    	$("#btnGetPrufSeNo").on("click", function(){
    		
   			data = {
 					ETXBL_CONFM_NO : $('#ETXBL_CONFM_NO2').val()		
 					,OUT_YN : '1'
					,OUT_MSG : '1'
   			}
   			
   			$.ajax({
   				url : "<c:url value='/kukgoh/invoiceValidation' />",
   				data : data,
   				type : 'POST',
   				success : function(result) {
   					console.log(result);
   					if (result.OUT_YN == 'Y') {
   						$('#txtEtxbl').html($('#ETXBL_CONFM_NO2').val());
   					} else {
   						alert(result.OUT_MSG);
   					}
   				}	
  				});
    	});	
    	
    	$(document).on({
    		mouseenter : function() {
    			$(this).addClass("font-underline");
    		},
    		mouseleave : function() {
    			$(this).removeClass("font-underline");
    		}
    	}, '.grdCol')
	});
</script>

<script type="text/javascript">

function onDeptSeqSelect(e){
	var dataItem = this.dataItem(e.item.index());
	var selectDeptSeq = dataItem.dept_seq; 
	$('#deptSeq').val(selectDeptSeq);
	
	if (selectDeptSeq === '99999') { // 전체
		$('#selectedEmpName').val('');
		$('#erpEmpSeq').val('');
		$('#erpDeptSeq').val('');
		return;
	}
	
	$.ajax({
 		url: _g_contextPath_+"/kukgoh/getErpDeptNum",
 		dataType : 'json',
 		data : { deptSeq : selectDeptSeq },
 		type : 'POST',
 		async : false,
 		success: function(result){
 			
 			if (result.erpDeptSeq === '') {
 				alert("해당 부서에 아무도 없습니다.");
 			} else {
	 			$('#erpDeptSeq').val(result.erpDeptSeq);
 			}
 		}
 	});
	
	$('#selectedEmpName').val('');
	$('#erpEmpSeq').val('');
}

function fn_formatDate(str){
	
	return str.substring(0,4) + "-" + str.substring(4,6) + "-" + str.substring(6,8) ;
}

function fn_formatMoney(str){
        str = String(str);
        return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
}
</script>
	
<!-- emp 그리드 -->
<script type="text/javascript">
$(function() {
	empGrid();
});

	//사원팝업 ajax
	var empDataSource = new kendo.data.DataSource({
		serverPaging: true,
		pageSize: 10,
	    transport: { 
	        read:  {
	            url: _g_contextPath_+'/common/empInformation',
	            dataType: "json",
	            type: 'post'
	        },
	      	parameterMap: function(data, operation){
	        	data.emp_name = $('#emp_name').val();
	        	data.deptSeq = $('#deptSeq').val() === '99999' ? '' : $('#deptSeq').val();
	        	data.notIn = '';
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

	function empGridReload(){
		$('#empGrid').data('kendoGrid').dataSource.read();
	}
	
	function empGrid(){		
		//사원 팝업그리드 초기화
		var grid = $("#empGrid").kendoGrid({
	        dataSource: empDataSource,
	        height: 500,	        
	        sortable: true,
	        pageable: {
	            refresh: true,
	            pageSizes: true,
	            buttonCount: 5
	        },
	        persistSelection: true,
	        selectable: "multiple",
	        columns:[ {field: "emp_name",
				            title: "이름",
					    },{field: "dept_name",
				            title: "부서",
				        },{field: "position",
				            title: "직급",
	        		    }, {field: "duty",
	            		    title: "직책",
	        		    }, {title : "선택",
						    template : '<input type="button" id="" class="text_blue" onclick="empSelect(this);" value="선택">'
	        		    }],
	        change: function (e){
	        	codeGridClick(e)
	        }
	    }).data("kendoGrid");
		
		grid.table.on("click", ".checkbox", selectRow);
		
		var checkedIds = {};
		
		//on click of the checkbox:
		function selectRow(){
			
			var checked = this.checked,
			row = $(this).closest("tr"),
			grid = $('#empGrid').data("kendoGrid"),
			dataItem = grid.dataItem(row);
			
			checkedIds[dataItem.CODE_CD] = checked;
			if (checked) {
				//-select the row
				row.addClass("k-state-selected");
			} else {
				//-remove selection
				row.removeClass("k-state-selected");
			}
		}
		//사원팝업 grid 클릭이벤트
		function codeGridClick(){			
			var rows = grid.select();
			var record;
			rows.each( function(){
				record = grid.dataItem($(this));
				console.log(record);
			}); 
			subReload(record);
		}
	}

	function subReload(record){
		$('#keyId').val(record.if_info_system_id);
	} 

	//선택 클릭이벤트
	function empSelect(e){		
		var row = $("#empGrid").data("kendoGrid").dataItem($(e).closest("tr"));
		$('#selectedEmpName').val(row.emp_name);
		$('#loginSeq').val(row.emp_seq);
		$('#erpEmpSeq').val(row.erp_emp_num);
		var empWindow = $("#empPopUp");		
		empWindow.data("kendoWindow").close();
	}
</script>

<!-- 메인그리드 -->
<script type="text/javascript">	

	$(function() {
		mainGrid();
	});
	
	function mainGrid(){
		var sendResolutionGrid = $("#sendResolutionGrid").kendoGrid({
			dataSource : new kendo.data.DataSource({
				serverPaging : true,
				pageSize : 10,
				transport : {
					read : {
						url : _g_contextPath_+"/kukgoh/sendResolutionGrid",
						dataType : "json",
						type : 'post'
					},
					parameterMap : function(data, operation) {
						data.fromMonth = $('#fromMonth').val().replace(/\-/g,'');
						data.endMonth = $('#endMonth').val().replace(/\-/g,'');
						data.erpDeptSeq = $("#erpEmpSeq").val() === '' 
													? ( $("#deptNm").data('kendoComboBox').value() === '99999' ? '' : $("#deptNm").data('kendoComboBox').value() )   
													: '';
						data.erpEmpSeq = $("#erpEmpSeq").val();
						data.status = $("#status").data('kendoComboBox').value();
						return data;
					}
				},
				schema : {
					data : function(response) {
						console.log("=== sendResolutionGrid ===");
						
						response.list.forEach(function(v, i) {
							if (pdfErrorList.indexOf(v.C_DIKEYCODE) > -1) {
								v.CHK_YN = 'N';
								v.CHK_MSG = 'PDF ERROR';
							}
						});
						
						console.log(response);
						return response.list;
					},
					total : function(response) {
						return response.total;
					},
					model : {
						fields : {
						}
					}
				}
			}),
			dataBound : gridDataBound,
			height : 600,
			sortable : true,
			resizable: true,
			persistSelection : true,
	        columns: [
	        	{ 
	        		headerTemplate : function(e){
	                   return '<input type="checkbox" id = "checkboxAll">';
	                },
	                template : function(dataItem){
						
	                	if (dataItem.CHK_YN === "Y" || dataItem.KUKGO_STATE === '전송진행중') {
	                		return '<input type="checkbox" class = "mainCheckBox Ybox">';            		
	                	} else {
	                		return '<input type="checkbox" class = "mainCheckBox Nbox">';
	                	}
	                },
	                width : "25px"
	             },
	            {	field : "CHK_YN",				title : "전송가능여부",	width : 55 },
        		{	field : "CHK_MSG",			title : "전송 불가 사유",	width : 80 },
        		{	
               		template : function(dataItem) {
               			if (dataItem.KUKGO_STATE === "전송완료" || dataItem.KUKGO_STATE === '전송진행중' || dataItem.KUKGO_STATE === '전송실패') {
               				return '<input type="button" class="text_blue" style="width: 80px;" onclick="fn_openSubmitPage(this);" value="확인">';
               			} else {
               				return '<input type="button" class="text_blue" style="width: 80px;" onclick="fn_openSubmitPage(this);" value="전송">';
               			}
               		},
               		title : "전송/확인",	width : 170
           		},
        		{
        			title : "지출결의 정보",
        			color : "red",
        			columns : [
        			{	field : "KUKGO_STATE",	 	title : "상태", 				width : 70 },
    				{	field : "KOR_NM",				title : "결의자",			width : 70},
    				{	
    					template : function(dataItem) {
    						return "<span class='grdCol' style='color: blue;' onclick='fn_docViewPop(" + dataItem.C_DIKEYCODE + ")'>" + dataItem.DOC_NUMBER + "</span>";
    					},
    					title : "문서번호", 		width : 100
    				},
    				{	
    					template : function(dataItem) {
    						return "<span class='grdCol' style='color: blue;' onclick='fn_docViewPop(" + dataItem.C_DIKEYCODE + ")'>" + dataItem.DOC_TITLE + "</span>";
    					},
    					title : "문서제목", 		width : 140
    				},
    				{	field : "PJT_NM",				title : "프로젝트",		width : 110},
    				{	field : "ABGT_NM",			title : "예산과목",		width : 150},
    				{	field : "SET_FG_NM",			title : "결재수단",		width : 80},
    				{
    					template : function(dataItem) {
    						return fn_formatMoney(dataItem.SUM_AMOUNT);
    					},
    					title : "금액",
    					width : 60
    				},
    				/* {
    					template : function(dataItem) {
    						return fn_formatDate(dataItem.GISU_DT);
    					},
    					title : "결의일자", width : 70
    				},
    				{	field : "GISU_SQ",				title : "결의번호",		width : 80 },
    				{	field : "BG_SQ",				title : "예산번호",		width : 80 },
    				{	field : "LN_SQ",				title : "거래처순번",		width : 80 },
    				{	field : "DIV_NM",				title : "회계단위",		width : 170} */]   			
        		},
        		{
        			title : "ENARA 집행 전송 정보",
        			columns : [
                	{	field : "PRUF_SE_CODE_NM",	title : "<img src='<c:url value='/Images/ico/ico_check01.png'/>' />증빙선택",	width : 90 },
                	{	
                		template : function(dataItem) {
                			
                			if (dataItem.ETXBL_CONFM_NO.length > 0) {
                				if (!typeof dataItem.PRUF_SE_NO === 'undefined') {
                					if (dataItem.PRUF_SE_NO.length > 0) {
                						return dataItem.PRUF_SE_NO;
                					}
                				} else {
	                				return dataItem.ETXBL_CONFM_NO;
                				}
                			} else {
                				return typeof dataItem.PRUF_SE_NO === 'undefined' ? '' : dataItem.PRUF_SE_NO;
                			}
                		},
                		field : "PRUF_SE_NO",	title : "<img src='<c:url value='/Images/ico/ico_check01.png'/>' />승인번호",	width : 150 
               		},
               		{	
               			template : function(dataItem) {
               				
               				console.log(dataItem.EXCUT_REQUST_DE);
               				
               				if (dataItem.EXCUT_REQUST_DE.length > 1) {
	               				return fn_formatDate(dataItem.EXCUT_REQUST_DE);
               				} else {
               					return '';
               				}
               				
               			},
               			title : "<img src='<c:url value='/Images/ico/ico_check01.png'/>' />증빙일자",	width : 90 
           			},
           			{	
           				template : function(dataItem) {
           					return fn_formatMoney(dataItem.SUM_AMOUNT);
           				},
           				title : "합계금액",	width : 80
        			},
        			{	field : "BCNC_CMPNY_NM",	title : "거래처명",	width : 200 },
                	{	
                		template : function(dataItem) {
                			
                			var BCNC_SE_CODE = dataItem.BCNC_SE_CODE;
                			var BCNC_LSFT_NO = dataItem.BCNC_LSFT_NO;
							
                			if (typeof BCNC_LSFT_NO === 'undefined' || BCNC_LSFT_NO === null) {
                				BCNC_LSFT_NO = '';
                			}
                			
                			if (BCNC_SE_CODE == '003') {
                				if (dataItem.PIN_NO_1 !== null && dataItem.PIN_NO_2 !== null) {
                					return '<div>' + BCNC_LSFT_NO.substring(0,5) + '-' + BCNC_LSFT_NO.substring(5,6) + '******</div>';
                				} else if (dataItem.PIN_NO_1 == null) {
                					return '';
                				}
                			} else {
                				
                				if(BCNC_LSFT_NO.length == 10){
                					var result = BCNC_LSFT_NO.substring(0,3)+'-'+BCNC_LSFT_NO.substring(3,5)+'-'+BCNC_LSFT_NO.substring(5,11);
                					
                					return '<div>' + result + '<div/>';
                				} else {
                					return '';
                				}
                			}
                		},
                		title : "<img src='<c:url value='/Images/ico/ico_check01.png'/>' />사업자등록번호(주민등록번호)",	width : 160
                	},
                	{	field : "TRANSFR_ACNUT_SE_CODE_NM",	title : "<img src='<c:url value='/Images/ico/ico_check01.png'/>' />이체구분",	width : 120 },
                   	{	field : "SBSACNT_TRFRSN_CODE_NM",	title : "이체구분",	width : 100 },
                   	{	field : "BCNC_BANK_CODE_NM",	title : "<img src='<c:url value='/Images/ico/ico_check01.png'/>' />은행명",	width : 90 },
                   	{	field : "BCNC_ACNUT_NO",	title : "<img src='<c:url value='/Images/ico/ico_check01.png'/>' />계좌번호",	width : 100 },
                   	{	
                		template : function(dataItem) {
                			return '<input type="button"  class=""   style="width:80px; background: #ebebe4;color: #474242; border:;"name="attachFile" id="attachFile"  onclick="fileRow(this);" value="첨부">'; 
                		},
                		title : "<img src='<c:url value='/Images/ico/ico_check01.png'/>' />정산서류",
                		width : 120 
               		}]
//         			{	field : "KUKGO_PJTNM",					title : "사업명",	width : 120},
//     				{	field : "ASSTN_TAXITM_CODE_NM",	title : "보조세목",	width : 120 },
//     				{
//     					template : function(dataItem){
//     						return fn_formatDate(dataItem.MD_DT);
//     					},
//     					title : "작성일자", 	width : 70
//     				},
//     				{	
//     					template : function(dataItem) {
//     						return "[" + dataItem.DOC_NUMBER + "] " + dataItem.DOC_TITLE;
//     					},
//     					title : "<img src='<c:url value='/Images/ico/ico_check01.png'/>' />집행용도",	 width : 250 },
//                 	{	field : "PRDLST_NM",	title : "<img src='<c:url value='/Images/ico/ico_check01.png'/>' />품목",	width : 250 },
//         			{	
//            				template : function(dataItem) {
//            					return fn_formatMoney(dataItem.SPLPC);
//            				},
//            				title : "공급가액",	width : 80
//         			},
//         			{	
//            				template : function(dataItem) {
//            					return fn_formatMoney(dataItem.VAT);
//            				},
//            				title : "부가세액",	width : 80
//         			},
//                 	{	field : "BCNC_SE_CODE_NM",	title : "<img src='<c:url value='/Images/ico/ico_check01.png'/>' />거래처구분",	width : 80 },
//                 	{	field : "BCNC_RPRSNTV_NM",	title : "대표자명",	width : 80 },
//                 	{	field : "BCNC_TELNO",	title : "전화번호",	width : 90 },
//                 	{	field : "BCNC_BIZCND_NM",	title : "업태",	width : 90 },
//                 	{	field : "BCNC_INDUTY_NM",	title : "업종",	width : 90 },
//                    	{	field : "BCNC_ADRES",	title : "주소",	width : 300 },
//                    	{	field : "SBSIDY_BNKB_INDICT_CN",	title : "내통장표시",	width : 90 },
//                    	{	field : "BCNC_BNKB_INDICT_CN",	title : "받는통장표시",	width : 100 }]	
        		}]
	    }).data("kendoGrid");
		
		sendResolutionGrid.table.on("click", ".k-state-selected", selectRow);
		
		function selectRow() {
			
			var rowData = $("#sendResolutionGrid").data("kendoGrid").dataItem($(this).closest("tr"));
			
			console.log(rowData);
			
			necessaryDataColumn();
		}
		
		var checkedIds = {};
		
		// 체크박스 전체선택
		$("#checkboxAll").click(function(e) {
			
	         if ($("#checkboxAll").is(":checked")) {
	            $(".Ybox").prop("checked", true);
	         } else {
	            $(".mainCheckBox").prop("checked", false);
	         }
	      });
		
		function gridDataBound(e){
			var grid = e.sender;
			
			for (var i = 0; i < this.columns.length; i++) {
				
              this.autoFitColumn(i);
            }
			
			if (grid.dataSource.total() == 0) {
				var colCount = 40; //rid.columns.length;
				$(e.sender.wrapper).find('tbody').append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
			} else {
				// get the index of the UnitsInStock cell
	            var columns = e.sender.columns;
	            var columnIndex = this.wrapper.find(".k-grid-header [data-field=" + "CHK_YN" + "]").index();
	
	            // iterate the table rows and apply custom row and cell styling
	            var rows = e.sender.tbody.children();
	            
	            for (var j = 0; j < rows.length; j++) {
	              var row = $(rows[j]);
	              var dataItem = e.sender.dataItem(row);
	
	              var chkYn = dataItem.get("CHK_YN");
	              
	              if (chkYn === "Y") {
	            	  row.children().eq(1).addClass("yColor");
	            	  row.children().eq(2).addClass("yColor");
	              } else {
	            	  row.children().eq(1).addClass("nColor");
	            	  row.children().eq(2).addClass("nColor");
	              }
	            }
			}
			
		}
	}
	
	function fn_searchBtn(){
		$('#sendResolutionGrid').data('kendoGrid').dataSource.page(1);
	}
	</script>

<!--  커스텀 function -->
<script type="text/javascript">

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
			'&nbsp;<a href="javascript:delFile('+result.list[i].attach_file_id+','+result.list[i].file_seq+')"></a>' +
			'<input type="hidden" id="fileId" class = "fileId" value="'+result.list[i].attach_file_id+'" />'+
			'<input type="hidden" id="fileSeq" class = "fileSeq" value="'+result.list[i].file_seq+'" />'+
			'</span>'+
			'</td>'+
			'</tr>'
	);
}

function filepopClose(){
	fileCountChenck();
	$('#filePop').data('kendoWindow').close();
}

function pad(n, width) {
	n = n + '';
	return n.length >= width ? n : new Array(width - n.length + 1).join('0') + n;
}	

function fileCountChenck(){
	
 	var dt = attachDataItem.GISU_DT;
	var kukgoStateYN = attachDataItem.KUKGO_STATE === "미전송" ? "Y" : "N";
	var c_dikeycode = attachDataItem.C_DIKEYCODE;
 	
 	 var data = {
 			INTRFC_ID :attachDataItem.INTRFC_ID,
 			TRNSC_ID : attachDataItem.TRNSC_ID,
 			C_DIKEYCODE : c_dikeycode,
 			KUKGO_STATE_YN : kukgoStateYN,
 			targetId : dt+""+pad(attachDataItem.GISU_SQ, 4) + ""+ pad(attachDataItem.LN_SQ, 2),
 			FILE_ID : dt+""+pad(attachDataItem.GISU_SQ, 4) + ""+ pad(attachDataItem.LN_SQ, 2)
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

function fileRow(e) {
	attachDataItem = $("#sendResolutionGrid").data("kendoGrid").dataItem($(e).closest("tr"));
	
 	var dt = attachDataItem.GISU_DT;
	var kukgoStateYN = attachDataItem.KUKGO_STATE === "미전송" ? "N" : "Y";
	var c_dikeycode = attachDataItem.C_DIKEYCODE;
	$("#KUKGO_STATE_YN").val(kukgoStateYN);
 	
 	 var data = {
 			INTRFC_ID :attachDataItem.INTRFC_ID,
 			TRNSC_ID : attachDataItem.TRNSC_ID,
 			C_DIKEYCODE : c_dikeycode,
 			KUKGO_STATE_YN : kukgoStateYN,
 			targetId : dt+""+pad(attachDataItem.GISU_SQ, 4) + ""+ pad(attachDataItem.LN_SQ, 2),
 			FILE_ID : dt+""+pad(attachDataItem.GISU_SQ, 4) + ""+ pad(attachDataItem.LN_SQ, 2)
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
 				var kukgohStateYn = $('#KUKGO_STATE_YN').val();
 				
 				if (kukgohStateYn == 'N') { //미전송
 	 				for (var i = 0 ; i < result.list.length ; i++) {
 						fn_setFileDivN(result, i);
 					}
 				} else if (kukgohStateYn == 'Y') {//전송
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
 	$('#filePop').data("kendoWindow").center();
}
	
	//집행정보 재전송
	function fn_btnCancelSubmit(){
		console.log("집행전송 취소");
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
	
	function necessaryDataColumn() {
		
	}
	
	function fn_openSubmitPage(e){
		var flag = $(e).val() === "전송" ? 'S' : 'C'; // 전송 'S', 확인 'C'
 		var dataItem = $("#sendResolutionGrid").data("kendoGrid").dataItem($(e).closest("tr"));
		dataItem.flag = flag;
		
		var w = 1450;
		var h = 650;
		
		var dualScreenLeft = window.screenLeft != undefined ? window.screenLeft : window.screenX;
	    var dualScreenTop = window.screenTop != undefined ? window.screenTop : window.screenY;

	    var width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
	    var height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;

	    var systemZoom = width / window.screen.availWidth;
	    var left = (width - w) / 2 / systemZoom + dualScreenLeft;
	    var top = (height - h) / 2 / systemZoom + dualScreenTop;
		
		window.open("", "pop", "width=" + (w / systemZoom) + ",height=" + (h / systemZoom) + ", top=" + top + ", left=" + left + ", toolbar=no, scrollbars=yes");
		$('#submitData').val(JSON.stringify(dataItem));
		
		console.log($("#submitData").val());
		
		document.submitPage.action = _g_contextPath_+"/kukgoh/newResolutionSubmitPage";
		document.submitPage.target = "pop";
		document.submitPage.method = "post";
		document.submitPage.submit();
	}
	
	function fn_sendInvoiceBatch() {
		
	}
	
	function fn_makeSendData(dataJson) {
		
		dataJson.BCNC_ACNUT_NO = dataJson.BCNC_ACNUT_NO.replace(/\-/g,'');
		
		// 사업자등록번호 처리
		if((dataJson.BCNC_SE_CODE == '003')) {
			
			if (dataJson.BCNC_LSFT_NO.length == 7) {
				dataJson.PIN_NO_1 = dataJson.BCNC_LSFT_NO.substring(0,1);
				dataJson.PIN_NO_2 = dataJson.BCNC_LSFT_NO.substring(6,7);
			} else if (dataJson.PIN_NO_1 == null) {
				dataJson.PIN_NO_1 = "";
				dataJson.PIN_NO_2 = "";
			} else { // 개인 - 주민등록번호 있을 경우
				dataJson.PIN_NO_2 = dataJson.PIN_NO_2.substring(0, 1);
			}
		} else {
			dataJson.PIN_NO_1 = "";
			dataJson.PIN_NO_2 = "";
		}
		
		// 승인번호 없을 경우 (기타)
		if (typeof dataJson.PRUF_SE_NO === 'undefined') {
			dataJson.PRUF_SE_NO = '';
		}
		
		// 증빙일자가 없으면 최종결재승인 날짜로 입력
		/* if (dataJson.EXCUT_REQUST_DE === "") {
			dataJson.EXCUT_REQUST_DE = dataJson.DOC_REGDATE; 
		} */
		
		if (dataJson.SBSACNT_TRFRSN_CODE === null || !dataJson.SBSACNT_TRFRSN_CODE) {
			dataJson.SBSACNT_TRFRSN_CODE = "";
		}
		
		dataJson.EXCUT_PRPOS_CN = "[" + dataJson.DOC_NUMBER + "] " + dataJson.DOC_TITLE;
		dataJson.PRDLST_NM = "[" + dataJson.DOC_NUMBER + "] " + dataJson.DOC_TITLE;
		
		dataJson.SBSACNT_TRFRSN_CN = '';
		dataJson.PIN_NO = dataJson.PIN_NO_1 + dataJson.PIN_NO_2 + "000000";	
		dataJson.APPLY_DIV = '★',
		dataJson.INSERT_IP = '',
		dataJson.INSERT_DT = '',
		dataJson.OUT_TRNSC_ID = '',
		dataJson.OUT_CNTC_SN = '',
		dataJson.OUT_CNTC_CREAT_DT = '',
		dataJson.OUT_YN = '',
		dataJson.OUT_MSG = '',
		dataJson.targetId = "" + dataJson.GISU_DT +  pad(dataJson.GISU_SQ, 4) + ""+ pad(dataJson.LN_SQ, 2)
		
		return dataJson;
	}
	
	function fn_sendAccountBatch() {
		
		startLoading();
		
		var resolutionList = [];
		
		$(".Ybox:checked").each(function(i, v) {
			
			var rows = $("#sendResolutionGrid").data("kendoGrid").dataItem($(v).closest("tr"));
			
			rows = fn_makeSendData(rows);
			
			resolutionList.push(rows);
		});
		
	    $.ajax({
			url : _g_contextPath_ + "/kukgoh/sendResolutionList",
			data : { "param" : JSON.stringify(resolutionList) },
			dataType : "json",
			type : "POST",
			success : function(result) {
				alert(result.OUT_MSG);				
			},
			complete : function(result) {
				$('html').css("cursor", "auto");
		    	$('#loadingPop').data("kendoWindow").close();
				
		    	fn_searchBtn();
			}
		}) 
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
		var dt = attachDataItem.GISU_DT.replace(/\-/g,'');
		var form = new FormData($("#fileForm")[0]);
		
		form.append("C_DIKEYCODE", attachDataItem.C_DIKEYCODE);
		form.append("targetId", dt+""+pad(attachDataItem.GISU_SQ, 4) + ""+ attachDataItem.LN_SQ);
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
	
	function startLoading() {
		$('html').css("cursor", "wait");
	   	$('#loadingPop').data("kendoWindow").open();
	}
	
	function fn_exceptData() {
		
		var resolutionList = [];
		
		$(".mainCheckBox:checked").each(function(i, v) {
			
			var rows = $("#sendResolutionGrid").data("kendoGrid").dataItem($(v).closest("tr"));
			
			rows = fn_makeSendData(rows);
			
			resolutionList.push(rows);
		});
		
		 $.ajax({
				url : _g_contextPath_ + "/kukgoh/exceptEnaraDoc",
				data : { "param" : JSON.stringify(resolutionList) },
				dataType : "json",
				type : "POST",
				success : function(result) {
					alert(result.OUT_MSG);				
				},
				complete : function(result) {
					
			    	fn_searchBtn();
				}
			}) 
	}
	
	function fn_cancelData() {
		
		var resolutionList = [];
		var flag = true;
		
		$(".mainCheckBox:checked").each(function(i, v) {
			
			var rows = $("#sendResolutionGrid").data("kendoGrid").dataItem($(v).closest("tr"));
			
			if (rows.KUKGO_STATE === "전송완료" || rows.KUKGO_STATE === '전송진행중' || rows.KUKGO_STATE === '전송실패') {
				
				rows = fn_makeSendData(rows);
				
				resolutionList.push(rows);
			} else {
				flag = false;
			}
		});
		
		if (!flag) {
			alert("미전송인 건이 포함되어 있습니다.");
			return;
		}
		
		 $.ajax({
				url : _g_contextPath_ + "/kukgoh/cancelAllSendInfo",
				data : { "param" : JSON.stringify(resolutionList) },
				dataType : "json",
				type : "POST",
				success : function(result) {
					alert("전송 취소하였습니다.");				
				},
				complete : function(result) {
					
			    	fn_searchBtn();
				}
			}) 
		
	}
</script>

<!-- 상단 검색 바 -->
<div class="iframe_wrap" style="min-width: 1070px;">
	<div class="sub_title_wrap">
		<div class="title_div">
			<h4>지출결의서 집행전송</h4>
		</div>
		<div class="sub_contents_wrap">
			<p class="tit_p mt5 mt20">지출결의서 집행전송</p>
				<div class="top_box">
					<dl>
						<dt  class="ar" style="width:60px;" >발의 기간</dt>
						<dd>
							<input type="text" id="fromMonth" />
							<span>~</span>
							<input type="text" id="endMonth" />
						</dd>	
						<dt  class="ar" style="width:55px" >발의부서</dt>
						<dd>
							<c:if test="${loginMap.deptSeq eq '1208' || loginMap.deptSeq eq '1' }">
								<input type="text" id="deptNm" />
								<input type="hidden" id="deptSeq" />
							</c:if>
							<c:if test="${loginMap.deptSeq ne '1208' && loginMap.deptSeq ne '1'}">
								<input type="text" style="width:100px"  id="deptNm" value='${deptNm}'disabled="disabled"/>
								<input type="hidden" id="deptSeq" value='${requestDeptSeq}'/>
							</c:if>
						</dd>					
					    <dt  class="ar" style="width:40px;">발의자</dt>
					    <dd  class="ar">
					    	<input type="text" id="selectedEmpName" name="selectedEmpName" value="${ ( loginMap.deptSeq eq '1208'  || loginMap.deptSeq eq '1' )  ? '' : empName }" disabled="disabled" style="width:100px;">
					    	<input type="hidden" id="loginSeq" name=""value="${empSeq}"/>
					    	<input type="hidden" id="CO_CD"  />
					    	<input type="hidden" id="erpDeptSeq" name="erpDeptSeq"value="${erpDeptSeq}"/>
					    	<input type="hidden" id="erpEmpSeq" name="erpEmpSeq"value="${ loginMap.deptSeq eq '1208' ? '' : erpEmpSeq}"/>
					    </dd>
					    <dd>
							<input type="button" id="empSearch" value="선택" />						
						</dd>
						<dt  class="ar" style="width:55px" >전송상태</dt>
						<dd>
							<input type="text" id="status" />
						</dd>
					</dl>
				</div>
				<div class="btn_div">	
					<div class="right_div">
						<div class="controll_btn p0">
							<button type="button" id="" onclick="fn_cancelData();">전송취소</button>
							<button type="button" id="" onclick="fn_exceptData();">전송제외</button>
							<button type="button" id="" onclick="fn_sendAccountBatch();">집행정보 일괄전송</button>
							<button type="button" id="" onclick="fn_searchBtn();">조회</button>
						</div>
					</div>
				</div>
				<div>
				</div>
				<div class="com_ta2 mt15">
				    <div id="sendResolutionGrid"></div>
				</div>
		</div>
	</div>
</div>
	
	
	<!-- 사원검색팝업 -->
	<div class="pop_wrap_dir" id="empPopUp" style="width:600px;">
		<div class="pop_head">
			<h1>사원 선택</h1>
		</div>
		<div class="pop_con">
			<div class="top_box">
				<dl>
					<dt class="ar" style="width: 65px;">성명</dt>
					<dd>
						<input type="text" id="emp_name" style="width: 120px" />
					</dd>
					<dd>
						<input type="button" onclick="empGridReload();" id="searchButton"	value="검색" />
					</dd>
				</dl>
			</div>
			<div class="com_ta mt15" style="">
				<div id="empGrid"></div>
			</div>			
		</div><!-- //pop_con -->

		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" class="gray_btn" id="empPopUpCancel" value="닫기" />
			</div>
		</div><!-- //pop_foot -->
	</div><!-- //pop_wrap -->	
	<div>
		<form id="submitPage" name="submitPage" action="/CustomNPEPIS/kukgoh/resolutionSubmitPage" method="POST">
			 <input type="hidden" id="submitData" name = "submitData" value=""/> 
		</form>
	</div>	
	

<div class="pop_wrap_dir" id="filePop" style="width:400px; display: none;">
		<div class="pop_con">
		<form id="fileForm" method="post" enctype="multipart/form-data" >
			<!-- 타이틀/버튼 -->
			<div class="btn_div mt0">
				<input type="hidden" id="FILE_ID" name="FILE_ID"  value=''/>
				<input type="hidden" id="KUKGO_STATE_YN" name="KUKGO_STATE_YN"  value=''/>
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
					<span class=""><img src="<c:url value='/Images/ico/loading.gif'/>" alt="" />  &nbsp;&nbsp;&nbsp;지출결의서 전송 진행 중입니다. </span>		
				</td>
			</tr>
		</table>
	</div>
</div>	

</body>
</html>