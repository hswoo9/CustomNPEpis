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
.blueColor { color : blue; }
.onFont { font-weight : bold; color : green; }

html:first-child select {
    height: 24px;
    padding-right: 6px;
}
</style>

<script type="text/javascript">
	
	$(document).ready(function() {
		mainGrid();
	});


	
	var dataSource = new kendo.data.DataSource({
		transport: {
			read: {
				type: 'post',
				dataType: 'json',
				url: _g_contextPath_ + "/busTrip/getalm",
			},
			parameterMap: function(data, operation) {
				
	   	    	return data ;
			}
		},
		schema: {
	   	    data: function(response) {
	   	    	 return response.list;
	   	    	
	   	    }
		}
	});
	
	var dataSource2 = new kendo.data.DataSource({
		transport: {
			read: {
				type: 'post',
				dataType: 'json',
				url: _g_contextPath_ + "/busTrip/getalm2",
			},
			parameterMap: function(data, operation) {
				
	   	    	return data ;
			}
		},
		schema: {
	   	    data: function(response) {
	   	    	 return response.list;
	   	    	
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
		$('#grid').data('kendoGrid').dataSource.read();
		setTimeout(function(){console.log($('#grid').data("kendoGrid")._data);},1);
		$('#grid2').data('kendoGrid').dataSource.read();
		setTimeout(function(){console.log($('#grid2').data("kendoGrid")._data);},1);
	}
	
	
	
	//메인그리드
	function mainGrid() {
		
		//캔도 그리드 기본
		var grid = $("#grid").kendoGrid({
			dataSource : dataSource,
			height : 500,
			sortable : true,
			pageable :false /* {
				refresh : true,
				pageSizes : [10,20,30,50,100],
				buttonCount : 5
			} */,
			persistSelection : true,
			columns : [
						{
							field : "ALM_SEQ",
							title : "seq",
							width:100,
						},{
							field : "ALM_TYPE",
							title : "알림종류",
							width:100,
						},{
							field : "ALM_TYPE_NM",
							title : "알림종류이름",
							width:100,
						},{
							field : "ALM_TITLE",
							title : "알림제목",
							width:100,
						},{
							field : "ALM_SENDER_ID",
							title : "송신자로그인아이디",
							width:100,
						},{
							field : "ALM_SENDER_NM",
							title : "송신자이름",
							width:100,
						},{
							field : "ALM_RECV_ID",
							title : "수신자로그인아디",
							width:100,
						},{
							field : "ALM_RECV_NM",
							title : "수신자이름",
							width:100,
						},{
							field : "ALM_LINK_URL",
							title : "링크",
							width:100,
						},{
							field : "ALM_REG_DT",
							title : "등록일시",
							width:100,
						},{
							field : "ALM_READ_DT",
							title : "수신시간",
							width:100,
						},{
							field : "ALM_READ_YN",
							title : "수신여부",
							width:100,
						}],
						change: function (e) {
				        },
						dataBound : function (e) {
								
							
						}
					}).data("kendoGrid");
		var grid2 = $("#grid2").kendoGrid({
			dataSource : dataSource2,
			height : 500,
			sortable : true,
			pageable :false /* {
				refresh : true,
				pageSizes : [10,20,30,50,100],
				buttonCount : 5
			} */,
			persistSelection : true,
			columns : [
						{
							field : "MSG_ID",
							title : "seq",
							width:100,
						},{
							field : "MSG_TYPE",
							title : "알림종류",
							width:100,
						},{
							field : "MSG_TYPENAME",
							title : "알림종류이름",
							width:100,
						},{
							field : "MSG_TITLE",
							title : "알림제목",
							width:100,
						},{
							field : "SENDER_ID",
							title : "송신자로그인아이디",
							width:100,
						},{
							field : "SENDER_NAME",
							title : "송신자이름",
							width:100,
						},{
							field : "RECIPIENT_ID",
							title : "수신자로그인아디",
							width:100,
						},{
							field : "RECIPIENT_NAME",
							title : "수신자이름",
							width:100,
						},{
							field : "RECIPIENT_LINKURL",
							title : "링크",
							width:100,
						},{
							field : "INDT",
							title : "등록일시",
							width:100,
						},{
							field : "READYN",
							title : "수신여부",
							width:100,
						}],
						change: function (e) {
				        },
						dataBound : function (e) {
								
							
						}
					}).data("kendoGrid");
		
		
		
		
	}
	 
	
	
	
	
</script>

<!-- iframe wrap -->
<div class="iframe_wrap" style="min-width: 1100px">
<form id="outProcessFormData" action="http://211.192.144.104/gw/outProcessLogOn.do" target="outProcessLogOn"></form>
<input type="hidden" id="loginId" value="${loginVO.id }" />
	<!-- 컨텐츠타이틀영역 -->
	<div class="sub_title_wrap">

		<div class="title_div">
			<h4>근무계획</h4>
		</div>
	</div>

	<div class="sub_contents_wrap">


		<!-- 버튼 -->
		<div class="btn_div mt10 cl">
			<div class="left_div">
				<p class="tit_p mt5 mb0"></p>
			</div>
			<div class="right_div">
				<div class="controll_btn p0">
					<!-- <button type="button" id="btnReturn" onclick="fnPurcContRepApproval();">계약보고</button>
					<button type="button" id="btnReturn" onclick="fnPurcContRepApprovalComplete();" style="margin-right: 20px;">계약보고완료</button> -->
					<button type="button" id="" onclick="searchBtn();">조회</button>
					<button type="button" id="" onclick="setAlm();">알림보내기</button>
				</div>
			</div>
		</div>
		
		<div class="com_ta2 mt15">
			<div id="grid"></div>
		</div>
		<div class="com_ta2 mt15">
			<div id="grid2"></div>
		</div>
	</div>
</div>



<script type="text/javascript">

function dateToString() {
	var date = new Date();
	
	
	var year = date.getFullYear();
	
	var month = date.getMonth() + 1;
	month = (month>9 ? '' : '0')+ month ;
	 
	var day = date.getDate();
	day = (day>9 ? '' : '0')+ day ;
	
	var hour =date.getHours();
	hour = (hour>9 ? '' : '0')+ hour ;
	
	var mi = date.getMinutes();
	mi = (mi>9 ? '' : '0')+ mi ;
	
	var sec = date.getMilliseconds();
	
	var text = eval(year+month+day+hour+mi+sec);
	
	return text;
}


function setAlm() {
	
	var regDt = dateToString();
	  $.ajax({
    		url : "<c:url value='/busTrip/setAlm' />",
    		data : { ALM_SEQ 		: "1003", 
	    			ALM_TYPE		: "1050",	 
	    			ALM_TYPE_NM 	: "데브짓수",
	    			ALM_TITLE		: "제목입니다",	
	    			ALM_SENDER_ID	: "admin", 
	    			ALM_SENDER_NM	:"관리자",
	    			ALM_RECV_ID		:"gywls8932",
	    			ALM_RECV_NM		:"석효진",
	    			ALM_LINK_URL	:"http://10.10.10.82",
	    			ALM_REG_DT		: regDt,
	    			},
    		type : 'POST',
    		async: false,
    		success : function(result) {
    		
    		}
    		
				});
    		
    		
}
</script>