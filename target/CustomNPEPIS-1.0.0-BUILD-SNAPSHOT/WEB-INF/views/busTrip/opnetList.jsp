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

<script type="text/javascript"
	src='<c:url value="/js/ac/acUtil.js"></c:url>'></script>
<script type="text/javascript"
	src='<c:url value="/js/common/outProcessUtil.js"></c:url>'></script>
<script src="https://kendo.cdn.telerik.com/2020.2.617/js/jszip.min.js"></script>
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

.blueColor {
	color: blue;
}

.onFont {
	font-weight: bold;
	color: green;
}

html:first-child select {
	height: 24px;
	padding-right: 6px;
}
</style>

<script type="text/javascript">
	$(document).ready(function() {
		datePickerInit();
		mainGrid();
		var grid = $('#grid').data('kendoGrid');
		keyupInit();
	});

	$(function() {
		$(document).on("mouseover", ".docTitle", function() {
			$(this).removeClass("blueColor").addClass("onFont");
		});

		$(document).on("mouseout", ".docTitle", function() {
			$(this).removeClass("onFont").addClass("blueColor");
		});

	})
	function keyupInit() {
		$('#txtTitle').on('keyup', function(e) {
			if (e.keyCode === 13) {
				gridReLoad()
			}
		});
		$('#empName').on('keyup', function(e) {
			if (e.keyCode === 13) {
				gridReLoad()
			}
		});
	}

	function datePickerInit() {
		var smonth = moment().add('day',-7).format('YYYY-MM-DD');
		var emonth = moment().add('day').format('YYYY-MM-DD');
		$("#txtFrDt").val(smonth);
		$("#txtToDt").val(emonth);
		var datePickerOpt = {
			format : "yyyy-MM-dd",
			culture : "ko-KR",
			change : function() {
				startChange();
			}
		};
		//시작날짜
		$("#txtFrDt").kendoDatePicker(datePickerOpt);
		$("#txtFrDt").attr("readonly", true);
		//종료날짜
		datePickerOpt.change = endChange;
		$("#txtToDt").kendoDatePicker(datePickerOpt);
		$("#txtToDt").attr("readonly", true);
		startChange();
		endChange();
	}

	function startChange() {
		var start = $('#txtFrDt').data("kendoDatePicker");
		var end = $('#txtToDt').data("kendoDatePicker");
		var startDate = start.value(), endDate = end.value();

		if (startDate) {
			startDate = new Date(startDate);
			startDate.setDate(startDate.getDate());
			end.min(startDate);
		} else if (endDate) {
			start.max(new Date(endDate));
		} else {
			endDate = new Date();
			start.max(endDate);
			end.min(endDate);
		}
	}

	function endChange() {
		var start = $('#txtFrDt').data("kendoDatePicker");
		var end = $('#txtToDt').data("kendoDatePicker");
		var endDate = end.value(), startDate = start.value();

		if (endDate) {
			endDate = new Date(endDate);
			endDate.setDate(endDate.getDate());
			start.max(endDate);
		} else if (startDate) {
			end.min(new Date(startDate));
		} else {
			endDate = new Date();
			start.max(endDate);
			end.min(endDate);
		}
	}

	var dataSource = new kendo.data.DataSource({
		transport : {
			read : {
				type : 'post',
				dataType : 'json',
				url : _g_contextPath_ + "/busTrip/getOpnetInfo",
			},
			parameterMap : function(data, operation) {
				data.start_dt = $('#txtFrDt').val();
				data.end_dt = $('#txtToDt').val();
				data.PRODCD = $('#ProdCd').val();
				data.SIDOCD = $('#sidoCd').val();

				return data;
			}
		},
		schema : {
			data : function(response) {

				return response.list

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
		setTimeout(function() {
			console.log($('#grid').data("kendoGrid")._data);
		}, 1);
	}

	//메인그리드
	function mainGrid() {

		//캔도 그리드 기본
		var grid = $("#grid")
				.kendoGrid(
						{
							
							  toolbar: [{name :"excel", text : "엑셀 다운로드"}],
							  excelExport: function(e) {
								  e.workbook.fileName = "오피넷.xlsx";
								  		
								    var columns = e.workbook.sheets[0].columns;
								  
									  columns.forEach(function(column){
									     column.width = 15;
									  });
							  },
							dataSource : dataSource,
							height : 500,
							sortable : false,
							pageable : false /* {
										refresh : true,
										pageSizes : [10,20,30,50,100],
										buttonCount : 5
									} */,
							persistSelection : true,
							columns : [
							/* { 
								headerTemplate : "<input type='checkbox' id='headerCheckbox' class='k-checkbox header-checkbox headerCheckbox'><label class='k-checkbox-label' for='headerCheckbox'></label>",
								template: function(data){
									return '<input type="checkbox" id="sts'+data.NUM+'" class="k-checkbox checkbox"/><label for="sts'+data.NUM+'" class="k-checkbox-label"></label>';
								}
								,width:50,
							}, */{
								field : "DATE",
								title : "날짜",
							}, {
								field : "SIDONM",
								title : "지역",
							}, {
								title : "유류",
								template : function (data) {
									var PRODCD = data.PRODCD;
									var prodKR = "";
									if(PRODCD =="B027"){
										prodKR ='휘발유';
									}else if(PRODCD =="K015") {
										prodKR ='LPG';
										
									}else if(PRODCD =="C004") {
										prodKR ='경유';
										
									}
									
									return prodKR;
								}
							}, {
								field : "PRICE",
								title : "비용",
								template : function(data) {
									var COST = data.PRICE || "";
									return COST
								}

							} ],
							change : function(e) {
								gridClick(e);
							},
							dataBound : function(e) {

								$gridIndex = 0;
								var grid = e.sender;
								if (grid.dataSource._data.length == 0) {
									/* var colCount = grid.columns.length; */
									var colCount = 4; //다중 컬럼이다보니 숫자를 강제로 세어서 넣오줌
									$(e.sender.wrapper)
											.find('tbody')
											.append(
													'<tr class="kendo-data-row">'
															+ '<td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
								}

								/* $(".headerCheckbox").change(function(){
									if($(this).is(":checked")){
										$(this).closest('table').parent().parent().parent().find('.checkbox').prop("checked", "checked");
								    }else{
								    	$(this).closest('table').parent().parent().parent().find('.checkbox').removeProp("checked");
								    }
								}); */
							}
						}).data("kendoGrid");

	}
</script>

<!-- iframe wrap -->
<div class="iframe_wrap" style="min-width: 1100px">
	<form id="outProcessFormData"
		action="http://211.192.144.104/gw/outProcessLogOn.do"
		target="outProcessLogOn"></form>
	<input type="hidden" id="loginId" value="${loginVO.id }" />
	<!-- 컨텐츠타이틀영역 -->
	<div class="sub_title_wrap">

		<div class="title_div">
			<h4>오피넷 조회</h4>
		</div>
	</div>

	<div class="sub_contents_wrap">

		<div class="top_box">
			<dl>
				<dt class="ar" style="width: 55px">요청기간</dt>
				<dd>
					<input type="text" value="" name="" id="txtFrDt" placeholder="" />
					&nbsp;~ <input type="text" value="" name="" id="txtToDt"
						placeholder="" />
				</dd>
				<dt class="ar" style="width: 30px">유류</dt>
				<dd style="width: 80px;">
					<select id="ProdCd" style="width: 100%;">
						<option value="">전체</option>
						<option value="B027">휘발유</option>
						<option value="C004">경유</option>
						<option value="K015">LPG</option>
					</select>
				</dd>
				<dt style="width: 55px;">지역</dt>
				<dd style="width: 80px;">
					<select id="sidoCd" style="width: 100%;">
						<option value="">전체</option>
						<option value="01">서울</option>
						<option value="02">경기</option>
						<option value="03">강원</option>
						<option value="04">충북</option>
						<option value="05">충남</option>
						<option value="06">전북</option>
						<option value="07">전남</option>
						<option value="08">경북</option>
						<option value="09">경남</option>
						<option value="10">부산</option>
						<option value="11">제주</option>
						<option value="14">대구</option>
						<option value="15">인천</option>
						<option value="16">광주</option>
						<option value="17">대전</option>
						<option value="18">울산</option>
						<option value="19">세종</option>
					</select>
				</dd>

			</dl>
		</div>

		<!-- 버튼 -->
		<div class="btn_div mt10 cl">
			<div class="left_div">
				<p class="tit_p mt5 mb0"></p>
			</div>
			<div class="right_div">
				<div class="controll_btn p0">
					<button type="button" id="" onclick="searchBtn();">조회</button>
				</div>
			</div>
		</div>

		<div class="com_ta2 mt15">
			<div id="grid"></div>
		</div>
	</div>
</div>



<script type="text/javascript">
	
</script>