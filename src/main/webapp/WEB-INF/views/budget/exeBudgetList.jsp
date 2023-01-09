<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>

<%
 /** 
  * @Class Name : budgetList.jsp
  * @Description : 예실대비
  * @Modification Information
  * @
  * @  수정일                 수정자             수정내용
  * @ ----------      --------    ---------------------------
  * @ 2018.05.24      이철중             최초 생성
  *
  * @author 이철중
  * @since 2018.05.24
  * @version 1.0
  * @see
  *
  */
%>

<html>
<head>
</head>

<style type="text/css">
.k-header .k-link{
   text-align: center;
}
.com_ta7 table td {min-width: 150px !important;}
.com_ta7 table td.number {min-width: 100px !important; text-align:right; padding-right:10px}
.com_ta7 table td.percent {min-width: 60px !important; text-align:right; padding-right:10px}
.com_ta7 table td.text1 {min-width: 100px !important; text-align:center; padding-left:10px}
.com_ta7 table td.text2 {min-width: 200px !important; text-align:center; padding-left:10px}
</style>

<script type="text/javascript">

    $(document).ready(function() {
    	var divWin = $("#divPopUp");
    	var pjtWin = $("#pjtPopUp");
    	var btmWin = $("#btmPopUp");
    	
    	$("#deptSearch").on("click", function() {
    		callOrgPop();
    	});

		$("#reqYear").val("${reqYear}");
		$("#deptSeq").val("${deptSeq}");
		$("#deptNm").val("${deptNm}");
		$("#divCd").val("${divCd}");
		$("#divNm").val("${divNm}");
		$("#pjtCd").val("${pjtCd}");
		$("#pjtNm").val("${pjtNm}");
		$("#btmCd").val("${btmCd}");
		$("#btmNm").val("${btmNm}");
    	
    	$("#divSearch").on("click", function() {
			divWin.data("kendoWindow").open();
			$("#divSearch").fadeOut();
			
			$("#divGrid").kendoGrid({
				dataSource: divDataSource,
				height: 290,
				sortable: true,
				persistSelection: true,
				selectable: "multiple",
				scrollable: {
					endless: true
				},
				columns: [{
 					template: "<input name='chkDivCd' type='checkbox' id='divCd#=DIV_CD#' class='k-checkbox rightCheck' value='#=DIV_CD#:#=DIV_NM#' /><label for='divCd#=DIV_CD#' class='k-checkbox-label'></label>",
					width: 50
		        },
				{
		            field: "DIV_CD",
		            title: "사업장코드",
		            width: 150
		        },
				{
		            field: "DIV_NM",
		            title: "사업장명"
		        }]
		    }).data("kendoGrid");
    	});
		
		divWin.kendoWindow({
			width: "500px",
			height: "420px",
			visible: false,
			modal : true,
			actions: [
				"Close"
			],
			close: onDivClose
		}).data("kendoWindow").center();
		
		$("#divCncl").click(function() {
	    	divWin.data("kendoWindow").close();
		});
		
		$("#divOk").click(function() {
			var checkedIds = "";
			var checkedNms = "";
			
			$('input[name=chkDivCd]').each(function () {
				if (this.checked) {
					 var val = $(this).val().split(":");
					 checkedIds += val[0] + "|";
					 checkedNms += "," + val[1];
				}
			});
			
			$("#divCd").val(checkedIds);
			$("#divNm").val(checkedNms.substring(1, checkedNms.length));
			
	    	divWin.data("kendoWindow").close();
		});
    	
    	$("#pjtSearch").on("click", function() {
			pjtWin.data("kendoWindow").open();
			$("#pjtSearch").fadeOut();
			
			$("#pjtGrid").kendoGrid({
				dataSource: pjtDataSource,
				height: 290,
				sortable: true,
				persistSelection: true,
				selectable: "multiple",
				scrollable: {
					endless: true
				},
				columns: [{
 					template: "<input name='chkPjtCd' type='checkbox' id='pjtCd#=PJT_CD#' class='k-checkbox rightCheck' value='#=PJT_CD#:#=PJT_NM#' /><label for='pjtCd#=PJT_CD#' class='k-checkbox-label'></label>",
					width: 50
		        },
				{
		            field: "PJT_CD",
		            title: "프로젝트코드",
		            width: 150
		        },
				{
		            field: "PJT_NM",
		            title: "프로젝트명"
		        }]
		    }).data("kendoGrid");
    	});
		
		pjtWin.kendoWindow({
			width: "500px",
			height: "420px",
			visible: false,
			modal : true,
			actions: [
				"Close"
			],
			close: onPjtClose
		}).data("kendoWindow").center();
		
		$("#pjtCncl").click(function() {
	    	pjtWin.data("kendoWindow").close();
		});
		
		$("#pjtOk").click(function() {
			var checkedIds = "";
			var checkedNms = "";
			
			$('input[name=chkPjtCd]').each(function () {
				if (this.checked) {
					 var val = $(this).val().split(":");
					 checkedIds += val[0] + "|";
					 checkedNms += "," + val[1];
				}
			});
			
			$("#pjtCd").val(checkedIds);
			$("#pjtNm").val(checkedNms.substring(1, checkedNms.length));
			
	    	pjtWin.data("kendoWindow").close();
		});
    	
    	$("#btmSearch").on("click", function() {
			btmWin.data("kendoWindow").open();
			$("#btmSearch").fadeOut();
			
			$("#btmGrid").kendoGrid({
				dataSource: btmDataSource,
				height: 290,
				sortable: true,
				persistSelection: true,
				selectable: "multiple",
				scrollable: {
					endless: true
				},
				columns: [{
 					template: "<input name='chkBtmCd' type='checkbox' id='btmCd#=BOTTOM_CD#' class='k-checkbox rightCheck' value='#=BOTTOM_CD#:#=BOTTOM_NM#' /><label for='btmCd#=BOTTOM_CD#' class='k-checkbox-label'></label>",
					width: 50
		        },
				{
		            field: "BOTTOM_CD",
		            title: "하위사업코드",
		            width: 150
		        },
				{
		            field: "BOTTOM_NM",
		            title: "하위사업명"
		        }]
		    }).data("kendoGrid");
    	});
		
		btmWin.kendoWindow({
			width: "500px",
			height: "420px",
			visible: false,
			modal : true,
			actions: [
				"Close"
			],
			close: onBtmClose
		}).data("kendoWindow").center();
		
		$("#btmCncl").click(function() {
	    	btmWin.data("kendoWindow").close();
		});
		
		$("#btmOk").click(function() {
			var checkedIds = "";
			var checkedNms = "";
			
			$('input[name=chkBtmCd]').each(function () {
				if (this.checked) {
					 var val = $(this).val().split(":");
					 checkedIds += val[0] + "|";
					 checkedNms += "," + val[1];
				}
			});
			
			$("#btmCd").val(checkedIds);
			$("#btmNm").val(checkedNms.substring(1, checkedNms.length));
			
	    	btmWin.data("kendoWindow").close();
		});
		
		$("#divSearchCncl").click(function() {
	    	$("#divCd").val("");
	    	$("#divNm").val("");
		});
		
		$("#pjtSearchCncl").click(function() {
	    	$("#pjtCd").val("");
	    	$("#pjtNm").val("");
		});
		
		$("#btmSearchCncl").click(function() {
	    	$("#btmCd").val("");
	    	$("#btmNm").val("");
		});
		
		$("#deptSearchCncl").click(function() {
	    	$("#deptNm").val("");
	    	$("#deptSeq").val("");
		});
    });
	
	function numberFormatStr(str) {
		var reg = /(\-?\d+)(\d{3})($|\.\d+)/;
		var param = str.toString();
		
		if (reg.test(param)) {
			return param.replace(/(\d)(?=(?:\d{3})+(?!\d))/g,'$1,');
	    }
		else {
			return param;
		}
	}
    
	function gridReload() {
		var form = document.budgetForm;
		form.action = "${pageContext.request.contextPath}/budget/exeBudgetList";
		
		$("#budgetForm").submit();
	}
    
	var divDataSource = new kendo.data.DataSource({
		serverPaging: false,
		pageSize: 10000,
		transport: {
			read:  {
				url: "${pageContext.request.contextPath}/budget/getDivList",
				dataType: "json",
				type: 'post'
			},
			parameterMap: function(data, operation) {
				data.divNm = $('#keyVal').val();
		     	return data;
			}
		},
		schema: {
			data: function(response) {
				return response.divList;
			}
		}
	});
	
    function onDivClose() {
    	$("#divSearch").fadeIn();
	}
    
	var pjtDataSource = new kendo.data.DataSource({
		serverPaging: false,
		pageSize: 10000,
		transport: {
			read:  {
				url: "${pageContext.request.contextPath}/budget/getPjtList",
				dataType: "json",
				type: 'post'
			},
			parameterMap: function(data, operation) {
				data.pjtNm = $('#keyVal').val();
		     	return data;
			}
		},
		schema: {
			data: function(response) {
				return response.pjtList;
			}
		}
	});
	
    function onPjtClose() {
    	$("#pjtSearch").fadeIn();
	}
    
	var btmDataSource = new kendo.data.DataSource({
		serverPaging: false,
		pageSize: 10000,
		transport: {
			read:  {
				url: "${pageContext.request.contextPath}/budget/getBtmList",
				dataType: "json",
				type: 'post'
			},
			parameterMap: function(data, operation) {
				data.pjtCd = $('#pjtCd').val();
		     	return data;
			}
		},
		schema: {
			data: function(response) {
				return response.btmList;
			}
		}
	});
	
    function onBtmClose() {
    	$("#btmSearch").fadeIn();
	}
    
	// 사용자 선택 팝업
	function callOrgPop() {
    	var pop = window.open("", "cmmOrgPop", "width=799,height=769,scrollbars=no");
		frmPop.target = "cmmOrgPop";
		frmPop.method = "post";
		frmPop.action = "${pageContext.request.contextPath}/budget/pop/cmmOrgPop";
		frmPop.submit();
		pop.focus();
	}
	
	function callbackSel(data) {
		var deptSeq  = [];
		var deptNm = [];
		
		for (var i = 0; i < data.returnObj.length; i++) {
			deptSeq.push(data.returnObj[i].deptSeq);
			deptNm.push(data.returnObj[i].deptName);
		}
		
		$("#deptSeq").val(deptSeq.join(","));
		$("#deptNm").val(deptNm.join(","));
	}
	
	function gridExcel() {
		alert("데이터 수집에 일정 시간이 소요됩니다. 다운로드 창이 보일때까지 기다리시기 바랍니다.");
		
		var form = document.budgetForm;
		form.action = "${pageContext.request.contextPath}/budget/exeBudgetListExcel";
		
		form.submit();
	}
</script>

<body>

	<!-- 조직도 호출하기 위한 기본값 -->
	<form id="frmPop" name="frmPop">
		<input type="hidden" name="popUrlStr" id="txt_popup_url" width="800" value="/gw/systemx/orgChart.do">
		<input type="hidden" name="selectMode" width="500" value="d" />
		<!-- value : [u : 사용자 선택], [d : 부서 선택], [ud : 사용자 부서 선택], [od : 부서 조직도 선택], [oc : 회사 조직도 선택]  --> 
		<input type="hidden" name="selectItem" width="500" value="m" />
		<input type="hidden" name="compSeq" id="compSeq"  value="" />
		<input type="hidden" name="compFilter" id="compFilter" value="" />
		<input type="hidden" name="initMode" id="initMode" value="true" />
		<input type="hidden" name="noUseDefaultNodeInfo" id="noUseDefaultNodeInfo" value="true" />
		<input type="hidden" name="selectedItems" id="selectedItems" value="" />
		<input type="hidden" name="callbackUrl" id="callbackUrl" value="${pageContext.request.contextPath}/budget/pop/cmmOrgPopCallback">
		<input type="hidden" name="callback" id="callback" value="callbackSel"/>
	</form>

	<div class="iframe_wrap" style="min-width: 1070px;">
		<form id="budgetForm" name="budgetForm" action="${pageContext.request.contextPath}/budget/exeBudgetList" method="post">
		<input type="hidden" name="search" id="search" value="Y"/>
		<!-- 컨텐츠타이틀영역 -->
	    <div class="sub_title_wrap">       
	        <div class="title_div">
	            <h4>예산과목별 예실대비 현황</h4>
	        </div>
	    </div>
		<div class="sub_contents_wrap">
			<p class="tit_p mt5 mt20">예산과목별 예실대비 현황</p>
			<div class="top_box">
				<dl>				    
					<dt class="ar" style="width:80px" >년도</dt>
					<dd>
						<input type="text" id="reqYear" name="reqYear" style="width: 90px"/>
					</dd>
					<dt class="ar" style="width:103px" >부서</dt>
					<dd>
						<input type="text" id="deptNm" name="deptNm" style="width: 300px" readonly />
						<input type="button" id="deptSearch" value="선택" />
						<input type="button" id="deptSearchCncl" value="선택취소" />
						<input type="hidden" name="deptSeq" id="deptSeq">
					</dd>
					<dt class="ar" style="width:103px" >회계단위</dt>
					<dd>
						<input type="text" id="divNm" name="divNm" style="width: 300px" readonly />
						<input type="button" id="divSearch" value="선택" />
						<input type="button" id="divSearchCncl" value="선택취소" />
						<input type="hidden" id="divCd" name="divCd" />
					</dd>
				</dl>
				<dl>
					<dt class="ar" style="width:103px" >프로젝트</dt>
					<dd>
						<input type="text" id="pjtNm" name="pjtNm" style="width: 400px" readonly />
						<input type="button" id="pjtSearch" value="선택" />
						<input type="button" id="pjtSearchCncl" value="선택취소" />
						<input type="hidden" id="pjtCd" name="pjtCd" />
					</dd>
					<dt class="ar" style="width:103px" >하위사업</dt>
					<dd>
						<input type="text" id="btmNm" name="btmNm" style="width: 400px" readonly />
						<input type="button" id="btmSearch" value="선택" />
						<input type="button" id="btmSearchCncl" value="선택취소" />&nbsp;&nbsp;&nbsp;
						<input type="button" onclick="gridReload();" value="조회" />
						<input type="button" onclick="gridExcel();" value="엑셀다운로드" />
						<input type="hidden" id="btmCd" name="btmCd" />
					</dd>
				</dl>
			</div>
	  		    
		    <!--신청 버튼 -->
<!-- 			<div class="btn_div"> -->
<!-- 				<div> -->
<!-- 					<div class="controll_btn p0">										 -->
<!-- 						<button type="button" id="excelBtn">엑셀</button> -->
<!-- 						<button type="button" onclick="gridReload();">조회</button> -->
<!-- 					</div> -->
<!-- 				</div> -->
<!-- 			</div> -->
			
			<!-- <div class="com_ta2 mt15" style="overflow-x:auto;white-space:nowrap;"> -->
			<div class="com_ta7 mt15" style="overflow-x:auto;white-space:nowrap;">
		       <table id="budgetTable">
	               <tr>
	               	   <th colspan="3" rowspan="2">예산과목</td>
	               	   <th colspan="7" rowspan="2">합계</td>
						<c:forEach var="pjtInfoList" items="${pjtInfoList}" varStatus="pjtInfoStatus">
							<th colspan="${pjtInfoList.totCnt * 7}">${pjtInfoList.pjtNm}</td>
						</c:forEach>
	               </tr>
	               <tr>
						<c:forEach var="pjtList" items="${pjtBtmList}" varStatus="pjtStatus">
							<th colspan="7">${pjtList.btmNm}</td>
						</c:forEach>
	               </tr>
	               <tr>
	               	   <th>코드</th>
	               	   <th>관</th>
	               	   <th>항</th>
						<th>예산금액<br>(편성금액+조정금액)</th>
						<th>품의금액</th>
						<th>결의금액</th>
						<th colspan="2">품의기준잔액</th>
						<th colspan="2">결의기준잔액</th>
						<c:forEach var="pjtList" items="${pjtBtmList}" varStatus="pjtStatus">
							<th>예산금액<br>(편성금액+조정금액)</th>
							<th>품의금액</th>
							<th>결의금액</th>
							<th colspan="2">품의기준잔액</th>
							<th colspan="2">결의기준잔액</th>
						</c:forEach>
	               </tr>
				<c:forEach var="mainList" items="${mainList}" varStatus="mainStatus">
					<c:if test="${mainList.bgtCd == '000000'}">
		               <tr>
		               	   <td colspan="3"><b>${mainList.hBgtNm} 소계</b></td>
							<c:set var="fnamet1" value="${mainList.hBgtCd}_1" />
							<c:set var="fnamet2" value="${mainList.hBgtCd}_2" />
							<c:set var="fnamet3" value="${mainList.hBgtCd}_3" />
							<c:set var="fnamet4" value="${mainList.hBgtCd}_4" />
							<c:set var="fnamet5" value="${mainList.hBgtCd}_5" />
							<c:set var="fnamet6" value="${mainList.hBgtCd}_6" />
							<c:set var="fnamet7" value="${mainList.hBgtCd}_7" />
		               	   
		                   <td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList[fnamet1]}" /></td>
		               	   <td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList[fnamet2]}" /></td>
		               	   <td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList[fnamet3]}" /></td>
		                   <td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList[fnamet4]}" /></td>
		               	   <td class="percent"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList[fnamet5]}" />%</td>
		               	   <td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList[fnamet6]}" /></td>
		               	   <td class="percent"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList[fnamet7]}" />%</td>
		               	   
							<c:forEach var="pjtList" items="${pjtBtmList}" varStatus="pjtStatus">
								<c:set var="fname1" value="${pjtList.pjtCd}_${pjtList.btmCd}_${mainList.hBgtCd}_1" />
								<c:set var="fname2" value="${pjtList.pjtCd}_${pjtList.btmCd}_${mainList.hBgtCd}_2" />
								<c:set var="fname3" value="${pjtList.pjtCd}_${pjtList.btmCd}_${mainList.hBgtCd}_3" />
								<c:set var="fname4" value="${pjtList.pjtCd}_${pjtList.btmCd}_${mainList.hBgtCd}_4" />
								<c:set var="fname5" value="${pjtList.pjtCd}_${pjtList.btmCd}_${mainList.hBgtCd}_5" />
								<c:set var="fname6" value="${pjtList.pjtCd}_${pjtList.btmCd}_${mainList.hBgtCd}_6" />
								<c:set var="fname7" value="${pjtList.pjtCd}_${pjtList.btmCd}_${mainList.hBgtCd}_7" />
								
								<td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList[fname1]}" /></td>
								<td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList[fname2]}" /></td>
								<td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList[fname3]}" /></td>
								<td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList[fname4]}" /></td>
								<td class="percent"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList[fname5]}" />%</td>
								<td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList[fname6]}" /></td>
								<td class="percent"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList[fname7]}" />%</td>
							</c:forEach>
		               </tr>
		            </c:if>
		            <c:if test="${mainList.bgtCd != '000000' && mainList.bgtCd != '999999'}">
		               <tr>
		               	   <td class="text1">${mainList.bgtCd}</td>
		               	   <td class="text1">${mainList.hBgtNm}</td>
		               	   <td class="text2">${mainList.bgtNm}</td>
		               	   
		                   <td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList.totAmt1}" /></td>
		               	   <td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList.totAmt2}" /></td>
		               	   <td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList.totAmt3}" /></td>
		                   <td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList.totAmt4}" /></td>
		               	   <td class="percent"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList.totAmt5}" />%</td>
		               	   <td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList.totAmt6}" /></td>
		               	   <td class="percent"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList.totAmt7}" />%</td>
		               	   
							<c:forEach var="pjtList" items="${pjtBtmList}" varStatus="pjtStatus">
								<c:set var="fname1" value="${pjtList.pjtCd}_${pjtList.btmCd}_${mainList.bgtCd}_1" />
								<c:set var="fname2" value="${pjtList.pjtCd}_${pjtList.btmCd}_${mainList.bgtCd}_2" />
								<c:set var="fname3" value="${pjtList.pjtCd}_${pjtList.btmCd}_${mainList.bgtCd}_3" />
								<c:set var="fname4" value="${pjtList.pjtCd}_${pjtList.btmCd}_${mainList.bgtCd}_4" />
								<c:set var="fname5" value="${pjtList.pjtCd}_${pjtList.btmCd}_${mainList.bgtCd}_5" />
								<c:set var="fname6" value="${pjtList.pjtCd}_${pjtList.btmCd}_${mainList.bgtCd}_6" />
								<c:set var="fname7" value="${pjtList.pjtCd}_${pjtList.btmCd}_${mainList.bgtCd}_7" />
								
								<td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList[fname1]}" /></td>
								<td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList[fname2]}" /></td>
								<td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList[fname3]}" /></td>
								<td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList[fname4]}" /></td>
								<td class="percent"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList[fname5]}" />%</td>
								<td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList[fname6]}" /></td>
								<td class="percent"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList[fname7]}" />%</td>
							</c:forEach>
		               </tr>
		            </c:if>
					<c:if test="${mainList.bgtCd == '999999'}">
		               <tr>
		               	   <td colspan="3"><b>합계</b></td>
		                   <td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList.totAmt1}" /></td>
		               	   <td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList.totAmt2}" /></td>
		               	   <td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList.totAmt3}" /></td>
		                   <td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList.totAmt4}" /></td>
		               	   <td class="percent"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList.totAmt5}" />%</td>
		               	   <td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList.totAmt6}" /></td>
		               	   <td class="percent"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList.totAmt7}" />%</td>
		               	   
							<c:forEach var="pjtList" items="${pjtBtmList}" varStatus="pjtStatus">
								<c:set var="fname1" value="${pjtList.pjtCd}_${pjtList.btmCd}_1" />
								<c:set var="fname2" value="${pjtList.pjtCd}_${pjtList.btmCd}_2" />
								<c:set var="fname3" value="${pjtList.pjtCd}_${pjtList.btmCd}_3" />
								<c:set var="fname4" value="${pjtList.pjtCd}_${pjtList.btmCd}_4" />
								<c:set var="fname5" value="${pjtList.pjtCd}_${pjtList.btmCd}_5" />
								<c:set var="fname6" value="${pjtList.pjtCd}_${pjtList.btmCd}_6" />
								<c:set var="fname7" value="${pjtList.pjtCd}_${pjtList.btmCd}_7" />
								
								<td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList[fname1]}" /></td>
								<td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList[fname2]}" /></td>
								<td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList[fname3]}" /></td>
								<td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList[fname4]}" /></td>
								<td class="percent"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList[fname5]}" />%</td>
								<td class="number"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList[fname6]}" /></td>
								<td class="percent"><fmt:formatNumber type="number" maxFractionDigits="3" value="${mainList[fname7]}" />%</td>
							</c:forEach>
		               </tr>
		            </c:if>
				</c:forEach>
		       </table>
			</div>
		</div>
		</form>
	</div>
	
	<div class="pop_wrap_dir" id="divPopUp" style="width:500px; display:none;">
		<div class="pop_head">
			<h1>예산회계단위</h1>
		</div>
		<div id="divGrid"></div>
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" class="blue_btn" id="divOk"   value="적용" />
				<input type="button" class="blue_btn" id="divCncl" value="취소" />
			</div>
		</div>
	</div>
	
	<div class="pop_wrap_dir" id="pjtPopUp" style="width:500px; display:none;">
		<div class="pop_head">
			<h1>프로젝트</h1>
		</div>
		<div id="pjtGrid"></div>
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" class="blue_btn" id="pjtOk"   value="적용" />
				<input type="button" class="blue_btn" id="pjtCncl" value="취소" />
			</div>
		</div>
	</div>
	
	<div class="pop_wrap_dir" id="btmPopUp" style="width:500px; display:none;">
		<div class="pop_head">
			<h1>하위사업</h1>
		</div>
		<div id="btmGrid"></div>
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" class="blue_btn" id="btmOk"   value="적용" />
				<input type="button" class="blue_btn" id="btmCncl" value="취소" />
			</div>
		</div>
	</div>
</body>
</html>