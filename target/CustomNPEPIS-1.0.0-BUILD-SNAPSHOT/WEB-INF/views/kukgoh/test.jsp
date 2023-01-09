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
<fmt:formatDate value="${nowDate}" var="nowDate" pattern="yyyy-MM" />
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
	.k-header .k-link {
	text-align: center;
}

.k-grid th.k-header, .k-grid-header {
	background: #F0F6FD;
}

.k-grid-content>table>tbody>tr {
	text-align: center;
}
</style>
<script type="text/javascript">
$(document).ready(function() {
	ctlTradeHide(1);
ctlTradeShow(3);
ctlTradeShow(4);
ctlTradeShow(5);
ctlTradeHide(6);
//입력한 컬럼 숨김
function ctlTradeHide(n){
	var Num = n;
	$("#erpTradeInfo tr th:nth-child("+Num+")").hide();
	$("#erpTradeInfo-table tr td:nth-child("+Num+")").hide();
	$("#erpTradeInfo-tablesample tr td:nth-child("+Num+")").hide();
	$("#erpTradeInfo-tablesample-empty tr td:nth-child("+Num+")").hide();
	$("#erpTradeInfo-tablesample tr td:nth-child("+Num+") input").removeClass("requirement");	
	$("#erpTradeInfo-tablesample tr td:nth-child("+Num+") input").addClass("non-requirement");
	$("#erpTradeInfo-tablesample tr td:nth-child("+Num+") input").removeClass("show");
	
}

//입력한 컬럼 숨김
function ctlTradeShow(n, classNm){
	var Num = n;
//	$("#erpTradeInfo tr th:nth-child("+Num+")").show();
//	$("#erpTradeInfo-table tr td:nth-child("+Num+")").show();
	$("#erpTradeInfo-tablesample tr td:nth-child("+Num+")").show();
//	$("#erpTradeInfo-tablesample-empty tr td:nth-child("+Num+")").show();

	
	//$("#erpTradeInfo-tablesample tr td:nth-child("+Num+") input").removeClass("non-requirement");
	//$("#erpTradeInfo-tablesample tr td:nth-child("+Num+") input").addClass("requirement");
}

});
</script>
<body>
<div class="iframe_wrap" style="min-width: 1100px">

		<table id="erpTradeInfo-tablesample" style="">
		    <tr class="">
		        <td width="150" id="trade-td">
				    <a href="javascript:;" class="search-Event-T"><img src="<c:url value='/Images/ico/ico_explain.png' />" alt="검색" title="검색" /></a>                                      
					<input type="text" style="width:70%" id="txt_TR_NM"  class="non-requirement" tabindex="20001"/> 
					<input type="hidden" class="non-requirement" id="txt_TR_FG" />                                                                  
					<input type="hidden" class="non-requirement" id="txt_TR_FG_NM"/>                                                                  
					<input type="hidden" class="non-requirement" id="txt_ATTR_NM"/>                                                                  
					<input type="hidden" class="non-requirement" id="txt_PPL_NB"/>                                                                  
					<input type="hidden" class="non-requirement" id="txt_ADDR"/>                                                                  
					<input type="hidden" class="non-requirement" id="txt_TRCHARGE_EMP" />                                                                  
					<input type="hidden" class="non-requirement" id="txt_JIRO_CD"  />                                                                                        
					<input type="hidden" class="non-requirement" id="txt_JIRO_NM"  />
					<input type="hidden" class="non-requirement" id="txt_REG_NB"/>                        		
					<input type="hidden" class="non-requirement" id="txt_NDEP_AM"/>                                                                                               
					<input type="hidden" class="non-requirement" id="txt_INAD_AM"/>                                                                                               
					<input type="hidden" class="non-requirement" id="txt_INTX_AM"/>                                                                                               
					<input type="hidden" class="non-requirement" id="txt_RSTX_AM"/>                                                                                               
					<input type="hidden" class="non-requirement" id="txt_WD_AM" />
					<input type="hidden" class="non-requirement" id="txt_ETCRVRS_YM" />                                                                                               
					<input type="hidden" class="non-requirement" id="txt_ETCDUMMY1" />                                                                                               
					<input type="hidden" class="non-requirement" id="txt_DATA_CD"  />                                                                                               
					<input type="hidden" class="non-requirement" id="txt_ET_YN"/> 
					<input type="hidden" class="non-requirement" id="txt_CTR_NM" />
					<input type="hidden" class="non-requirement" id="txt_CTR_CD" />
					<input type="hidden" class="non-requirement" id="txt_CTR_CARD_NUM" />
					<input type="hidden" class="non-requirement" id="txt_BA_NB_H" />
					<input type="hidden" class="non-requirement" id="txt_DEPOSITOR_H" />
					<input type="hidden" class="non-requirement" id="txt_BTR_NM_H" />
					<input type="hidden" class="non-requirement" id="txt_BTR_CD_H" />
				</td>
				<td width="80"><input type="text" style="width:93%;" id="txt_CEO_NM"  class="non-requirement" tabindex="20002" /></td>
				<td width="100"><a href="javascript:;" class="search-Event-T"><img src="<c:url value='/Images/ico/ico_explain.png' />" alt="검색" title="검색" /></a> 
				    <input type="text" style="width:73%;" id="txt_BTR_NM"  class="non-requirement" tabindex="20005" />
				</td>                                                     
				<td width="120"><input type="text" style="width:93%;" id="txt_BA_NB"  class="non-requirement" tabindex="20006" /></td>                                                      
				<td width="80"><input type="text" style="width:93%;" id="txt_DEPOSITOR"  class="non-requirement" tabindex="20007" /></td> 
				
				<td width="120"><input type="text" style="width:93%;" id="ppsIdNo"  class="requirement" tabindex="20002" code="0"/></td>
				<td width="120"><input type="text" style="width:93%;" id="trNm"  class="non-requirement" tabindex="20002" code="0"/></td>
				<td width="120"><input type="text" style="width:93%;" id="regNb"  class="non-requirement" tabindex="20002" code="0"/></td>
				<td width="120"><input type="text" style="width:93%;" id="ceoNm"  class="non-requirement" tabindex="20002" code="0"/></td>
				
				<td width="100"><input type="text" style="width:93%;" id="itemType"  class="non-requirement" tabindex="20002" /></td>
				<td width="100"><input type="text" id="txt_ITEM_NM"  style="width:85%;padding-right:7px;" class="ri requirement" CODE="empty" tabindex="20002" /></td>
				<td width="80"><input type="text" id="txt_ITEM_CNT"  style="width:85%;padding-right:7px;" class="ri non-requirement" tabindex="20003" /></td>                                                                           
				<td width="100"><input type="text" style="width:93%;" id="standard"  class="non-requirement" tabindex="20002" /></td>
				<td width="100"><input type="text" style="width:93%;" id="contents"  class="non-requirement" tabindex="20002" /></td>
				<td width="110"><input type="text" style="width:93%;" id="startDate"  class="non-requirement" tabindex="20002" /></td>
				<td width="110"><input type="text" style="width:93%;" id="endDate"  class="non-requirement" tabindex="20002" /></td>
				<td width="100"><input type="text" id="txt_ITEM_AM" code="empty" style="width:85%;padding-right:7px;" class="ri requirement" tabindex="20004" /></td>                                                                           
				<td width="100"><input type="text" id="txt_UNIT_AM"  style="width:85%;padding-right:7px;" class="ri requirement" CODE="empty" tabindex="20002" /></td>
				<td width="100"><input type="text" id="txt_SUP_AM"  style="width:85%;padding-right:7px;" class="ri non-requirement" tabindex="20003" /></td>                                                                           
				<td width="100"><input type="text" id="txt_VAT_AM" code="empty" style="width:85%;padding-right:7px;" class="ri requirement" tabindex="20004" /></td>                                                                           
				<td width="100"><input type="text" style="width:85%;" id="ppsFees"  class="ri requirement" tabindex="20002" code="0" readonly="readonly"/></td>
				<td width="100"><input type="text" style="width:85%;" id="nextAm"  class="ri non-requirement" tabindex="20002" code="0"/></td>
				<td width="130"><input type="text" style="width:93%;" id="txt_RMK_DC"  class="non-requirement" tabindex="20008" part="trade"/></td>
				<td width="130">
				    <div class="controll_btn ac p0">                         
					    <button type="button" class="erpsave">저장</button>                         
						<button type="button" class="btndeleteRow">삭제</button>                         
					</div>                        		
				</td>
			</tr>
		</table>
		</div>
</body>
</html>