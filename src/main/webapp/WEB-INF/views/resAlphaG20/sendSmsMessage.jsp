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
<script type="text/javascript"	src='<c:url value="/js/ac/acUtil.js"></c:url>'></script>
<script type="text/javascript"	src="<c:url value='/js/jquery.form.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/jszip.min.js' />"></script>
<script type="text/javascript"	src="<c:url value='/js/shieldui-all.min.js' />"></script>
<script type="text/javascript"	src="<c:url value='/js/budget/budgetUtil.js' />"></script>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title></title>
</head>

<script type="text/javascript">
	var selRow = '';
	var selCardNum = ''; // 선택 된 카드번호
	var dataItem = '';
	var nowDate = '<c:out value="${nowDate}"/>';
	var nowDatem3 = "${year}"+'-'+"${mm}"+'-'+"${dd-2}";
	var deptSeq = "${deptSeq}";
	var deptNm = "${deptNm}";
	var empSeq = "${empSeq}";
	var empName = "${empName}";
	
	$(function() {
		Init.kendoFunction();
		Init.kendoGrid();
		Init.eventListener();
	})

	var Init = {

		kendoGrid : function() {
			
			var mainGrid = $("#mainGrid").kendoGrid({
				dataSource : new kendo.data.DataSource({
					serverPaging : true,
					pageSize: 20,
					transport : {
						read : {
							url : _g_contextPath_ + "/resAlphaG20/getAdocuTradeList",
							dataType : "json",
							type : "post"
						},
						parameterMap : function(data, operation) {
							data.TO_DRAFT_DT = $('#draftingTo').val().replace(/\-/g,''); 
							data.FROM_DRAFT_DT = $('#draftingFrom').val().replace(/\-/g,'');
							data.TO_FILL_DT = $('#voucherTo').val().replace(/\-/g,''); 
							data.FROM_FILL_DT = $('#voucherFrom').val().replace(/\-/g,'');
							data.TR_CD = $('#trCd').val();
							data.TR_NM = $('#trNm').val();
							data.REG_NB = $('#regNb').val();
							data.STATUS = $("#status").val();
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
				dataBound : mainGridDataBound,
				 pageable: {
		            refresh: true,
		            pageSizes: true,
		            buttonCount: 5
		        },
				sortable : true,
				persistSelection : true,
				selectable : "multiple",
		        columns: [
		        	{ 
		        		headerTemplate : function(e){
		                   return '<input type="checkbox" id = "checkboxAll">';
		                },
		                template : function(dataItem){
		                	if (dataItem.SEND_YN === "") {
		                		return '<input type="checkbox" class = "mainCheckBox">';            		
		                	} else {
		                		return '';
		                	}
		                },
		                width : "25px"
		             },
		        	{
		        		template : function(dataItem) {
	        				if (typeof dataItem.RES_DATE !== "undefined" && dataItem.RES_DATE !== "") {
								return dataItem.RES_DATE.substring(0, 4) + "-" + dataItem.RES_DATE.substring(4, 6) + "-" + dataItem.RES_DATE.substring(6);
	        				} else {
	        					return "";
	        				}
						},
						title : "결의일자",
						width : 85
					},{
						field : "ERP_EMP_NAME",
						title : "기안자",
						width : 90
					},{
						template : function(dataItem) {
								return  '<a class="text_blue" href="#" onclick="fn_docViewPop('+dataItem.C_DIKEYCODE+');">' + dataItem.DOC_NO + '</a>';
						},
						title : "문서번호",
						width : 93
					},{
						template : function(dataItem) {
							return dataItem.FILL_DT.substring(0, 4) + "-" + dataItem.FILL_DT.substring(4, 6) + "-" + dataItem.FILL_DT.substring(6);
						},
						title : "회계확정일자",
						width : 85
					},{
						template : function(dataItem) {
							if (dataItem.ADOCU_DOC_STATUS === "008") {
								return  '<a class="text_blue" href="#" onclick="fn_docViewPop('+dataItem.ADOCU_APPR_DIKEY+');">' + dataItem.ADOCU_DOC_NO + '</a>';
							} else {
								return "";
							}
						},
						title : "전표문서보기",
						width : 90
					},{
						field : "RMK_DC",
						title : "적요",
						width : 250
					},{
						field : "TR_NM",
						title : "거래처명",
						width : 150
					},{
						field : "BTR_NM",
						title : "은행",
						width : 90
					},{
						template : function(dataItem) {
							return dataItem.BA_NB.replace(/-/gi, '');
						},
						title : "계좌번호",
						width : 90
					},{
						template : function(dataItem) {
							if (dataItem.REG_NB  == null || dataItem.REG_NB == '') {
								return  '';
							} else {
								return dataItem.REG_NB.substring(0, 3) + "-" + dataItem.REG_NB.substring(3, 5) + "-" + dataItem.REG_NB.substring(5);
							}
						},
						title : "사업자등록번호",
						width : 100
					},{
						template : function(dataItem) {
							return Budget.fn_formatMoney(Math.round(dataItem.UNIT_AM));
						},
						title : "금액",
						width : 80
					},{
						template : function(dataItem) {
							return Budget.fn_formatMoney(Math.round(dataItem.SUP_AM));
						},
						title : "공급가액",
						width : 80
					},{
						template : function(dataItem) {
							return Budget.fn_formatMoney(Math.round(dataItem.VAT_AM));
						},
						title : "부가세",
						width : 80
					},{
						template : function(dataItem) {
								return  '<input type="text" class="rcNm" style="width:77px;" maxlength="11" onkeypress="return checkNumber(event)" value="'+ dataItem.SMS_PHONE +'" >'; 
						},
						title : "SMS전송번호",
						width : 90
					},{
						template : function(dataItem) {
								if (Number(dataItem.SEND_YN) > 0) {
									return  '<input type="button" id="" class="text_blue" onclick="sendMessage(this);" value="재전송">';
			                	} else {
									return  '<input type="button" id="" class="text_blue" onclick="sendMessage(this);" value="전송">';
			                	}
						},
						title : "개별전송",
						width : 75
					}
				]
		    }).data("kendoGrid");
			
		},

		kendoFunction : function() {
			
			$("#status").kendoComboBox({
				dataSource: [
					{text : "전체", value : "999"}
					,{text : "미전송", value : "0"}
			      	,{text : "전송", value : "1"}
			      ],
			      dataTextField: "text",
			      dataValueField: "value",
			      index: 1,
			});
			
			$('#draftingFrom').kendoDatePicker({
		        start: "month",
		        depth: "month",
		        format: "yyyy-MM-dd",
				parseFormats : ["yyyy-MM-dd"],
		        culture : "ko-KR",
		        dateInput: true
		    });
			$('#draftingTo').kendoDatePicker({
		        start: "month",
		        depth: "month",
		        format: "yyyy-MM-dd",
				parseFormats : ["yyyy-MM-dd"],
		        culture : "ko-KR",
		        dateInput: true
		    });
			$('#voucherFrom').kendoDatePicker({
		        start: "month",
		        depth: "month",
		        format: "yyyy-MM-dd",
				parseFormats : ["yyyy-MM-dd"],
		        culture : "ko-KR",
		        dateInput: true
		    });
			$('#voucherTo').kendoDatePicker({
		        start: "month",
		        depth: "month",
		        format: "yyyy-MM-dd",
				parseFormats : ["yyyy-MM-dd"],
		        culture : "ko-KR",
		        dateInput: true
		    });
			$("#voucherFrom").val(nowDatem3);
			$("#voucherTo").val(nowDate);
			
		},

		eventListener : function() {
			
			$("#resetDraftingDate").on("click", function(e) {
				$("#draftingFrom").val('');
				$("#draftingTo").val('');
			});
			
			// 체크박스 전체선택
			$("#checkboxAll").click(function(e) {
				
		         if ($("#checkboxAll").is(":checked")) {
		            $(".mainCheckBox").prop("checked", true);
		         } else {
		            $(".mainCheckBox").prop("checked", false);
		         }
		      });
			
			$(document).on("click", "#mainGrid tbody tr", function(e) {
				row = $(this)
				grid = $('#mainGrid').data("kendoGrid"),
				dataItem = grid.dataItem(row);
				
				 console.log(dataItem);	 
			});
			
			$(document).on("mouseover", "#mainGrid tbody tr", function(e) {
				
				$(this).css("color", "blue").css("font-weight", "bold");
				
			});
			
			$(document).on("mouseout", "#mainGrid tbody tr", function(e) {
				
				$(this).css("color", "black").css("font-weight", "normal");
				
			});

			$("#trCd, #trNm, #regNb").on("keyup", function(e) { //trNm,regNb,trCd
				if (e.keyCode === 13) {
					fn_searchBtn();
				}
			});
		}
	}

	function mainGridDataBound(e) {
		var grid = e.sender;

		if (grid.dataSource.total() == 0) {
			var colCount = grid.columns.length;
			$(e.sender.wrapper)
					.find('tbody')
					.append(
							'<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
		}
	}

	function fn_searchBtn() {	
		$('#mainGrid').data('kendoGrid').dataSource.read(0);
		$('#mainGrid').data('kendoGrid').dataSource.page(1);
	}
	
	function viewAdoc(val) {	
		console.log(val);
	}
	
	function checkNumber(event) {
		  if(event.key >= 0 && event.key <= 9) {
		    return true;
		  }
		  
		  return false;
	}
	
	function transDateFormat(date) {
		
		var result = "";
		
		if (date.length >= 6) {
			result = date.substring(0, 4) + "년" + date.substring(4, 6) + "월" + date.substring(6, 8) + "일"; 
		}
		
		return result;
	}
	
	function transBankFormat(bankName) {
		
		var check = bankName.substring(bankName.length - 2);
		
		if (check == "은행") {
			return bankName;
		} else {
			return bankName + "은행";
		}
	}
	
	function smsMessageTemplate(row) {
		var result = "";
		
		result += "[농정원 " + deptNm + "]"
		result += " " + row.TR_NM + "님이 청구하신 " + Budget.fn_formatMoney(Math.round(row.UNIT_AM)) +"원이"
		result += " " + transDateFormat(row.FILL_DT)
		result += " " + transBankFormat(row.BTR_NM) + "(으)로 입금 예정입니다."
		result += " 문의사항은 재무관리실로 연락주시기 바랍니다."
		
		return result;
	}
	
	function sendMessage(e) {	
		var row = $("#mainGrid").data("kendoGrid").dataItem($(e).closest("tr")); //data
		var forsmsNum = $(e).closest("tr").find('.rcNm').val(); //table 정보
		
		 if(forsmsNum == '' ){
			alert('받으실 분의 번호를 입력해 주세요.')
			return;			
		}
		
		var idNum = row.REG_NB == null ? '' : row.REG_NB;
		
		 var data = {
				e_id_num : idNum,
				e_phone_num : forsmsNum.replace(/\-/g,''),
				e_nm : row.TR_NM,
				sms_sender : row.ERP_EMP_NAME,
				tr_cd : row.TR_CD,
				empSeq : empSeq,
				empName : empName,
				ISU_DT : row.ISU_DT,
				ISU_SQ : row.ISU_SQ,
				LN_SQ : row.LN_SQ,
				message : smsMessageTemplate(row)
		} 
		 $.ajax({
			type : 'post',
			url : '/CustomNPEPIS/resAlphaG20/saveInfoAboutSms',
			datatype : 'json',
			data : data,
			success : function(result) {
				var statment = '성공';
				if(result == 'fail'){
					statment = '실패';
				}
				alert('전송에 '+statment+'하였습니다.');
				fn_searchBtn();
			},
			error : function(data) {
			}
		}); 
	}
	
	function fn_sendCheckedRows() {
		
		var flag = true;
		var smsList = [];
		
		$(".mainCheckBox:checked").each(function(i, v) {
			
			var rows = $("#mainGrid").data("kendoGrid").dataItem($(v).closest("tr"));
			
			rows.e_id_num 		= rows.REG_NB == null ? '' : rows.REG_NB;
			rows.e_phone_num 	= $(v).closest("tr").find('.rcNm').val().replace(/\-/g,'');
			rows.e_nm 				= rows.TR_NM					
			rows.sms_sender		= rows.ERP_EMP_NAME
			rows.tr_cd 				= rows.TR_CD						
			rows.empSeq 			= empSeq;
			rows.empName 		= empName;
			rows.message 			= smsMessageTemplate(rows);
			
			console.log(smsMessageTemplate(rows));
			
			if (rows.e_phone_num === "") {
				alert("전송번호를 확인해주세요.");
				flag = false;
			}
			
			smsList.push(rows);
		});
		
		console.log(smsList);
		
		if (flag) {
			
			 $.ajax({
					url : _g_contextPath_ + "/resAlphaG20/sendSmsCheckedAll",
					data : { "param" : JSON.stringify(smsList) },
					dataType : "json",
					type : "POST",
					success : function(result) {
						if (result.isSucc) {
							alert("전송 완료");
						} else {
							alert("전송 실패");
						}
					},
					complete : function(result) {
				    	fn_searchBtn();
					}
				}) 
		}
	}
	
</script>

<body>
	<div class="iframe_wrap" style="min-width: 1070px;">
		<div class="sub_title_wrap">
			<div class="title_div">
				<h4></h4>
			</div>
			<div class="sub_contents_wrap">
				<p class="tit_p mt5 mt20" style="width: 90%"></p>
				<div class="top_box" style="width: 90%">
					<dl>
						<dt class="ar" style="width: 100px;">결의일자</dt>
						<dd>
							<input type="text" id="draftingFrom" style="width: 100px;"/> ~
							<input type="text" id="draftingTo" style="width: 100px;"/>
							<button id="resetDraftingDate">초기화</button>
						</dd>
						<dt class="ar" style="width: 95px;">전표확정일자</dt>
						<dd>
							<input type="text" id="voucherFrom" style="width: 100px;"/> ~
							<input type="text" id="voucherTo" style="width: 100px;"/>
						</dd>
					</dl>
					<dl>
						<dt class="ar" style="width: 102px;">거래처 명</dt>
						<dd>
							<input type="text" id="trNm" style="width: 130px;"/>
						</dd>
						<dt class="ar" style="width: 98px;">사업자 등록번호</dt>
						<dd>
							<input type="text" id="regNb" style="width: 130px;"/>
						</dd>
						<dt class="ar" style="width: 71px;">거래처 코드</dt>
						<dd>
							<input type="text" id="trCd" style="width: 130px;"/>
						</dd>
						<dt  class="ar" style="width:53px" >전송상태</dt>
						<dd>
							<input type="text" id="status" style="width:70px;"/>
						</dd>
						<dd>
							<button type="button" class="blue_btn" id="searchBtn" onclick="fn_searchBtn();">검색</button>
						</dd>
					</dl>
				</div>
				<div class="btn_div" style="width:90%;">	
					<div class="right_div">
						<div class="controll_btn p0">
							<button type="button" id="" onclick="fn_sendCheckedRows();">일괄전송</button>
						</div>
					</div>
				</div>
				<div class="com_ta2 mt15" style="width: 90%;">
					<div id="mainGrid"></div>
				</div>
			</div>
		</div>
	</div>

</body>
</html>

