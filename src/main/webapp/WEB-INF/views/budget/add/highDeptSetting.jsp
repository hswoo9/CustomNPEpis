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
<script type="text/javascript" src="<c:url value='/js/jquery.number.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/jszip.min.js' />"></script>
<style>
	.green_btn {background:#0e7806 !important; height:24px; padding:0 11px; color:#fff !important;border:none; font-weight:bold; border:0px !important;}
</style>
<script type="text/javascript">
 var selData = '';
 var erpEmpSeq = '${erpEmpSeq}';

	$(function() {
		Init.ajax();
		Init.kendoFunction();
		Init.kendoGrid();
		Init.eventListener();
	})
	
	var Init = {
			ajax : function() {
			},
			kendoFunction : function() {
				
				$("#highDeptPopup").kendoWindow({
				     width: "600px",
				    height: "750px",
				     visible: false,
				     actions: ["Close"]
				 }).data("kendoWindow").center();
			},
			
			kendoGrid : function() {
				
				var mainGrid = $("#mainGrid").kendoGrid({
					dataSource : new kendo.data.DataSource({
						serverPaging : true,
						pageSize : 10,
						transport : {
							read : {
								url : _g_contextPath_+"/budget/getParentDept",
								dataType : "json",
								type : 'post'
							},
							parameterMap: function(data, operation) {
													
								data.deptName = $('#dept').val();
					  	 	  	return data;
					  	   },
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
									DEPT_SORT : {type : 'number'}
								}
							}
						}
					}),
					dataBound : mainGridDataBound,
					height : 650,
					sortable : true,
					editable : true,
					persistSelection : true,
					selectable : "multiple",
			        columns: [
						{
							field : "DEPT_CD",
							title : "부서코드",
							width : 60
						},
						{
							field : "DEPT_NM",
							title : "부서명",
							width : 60
						},
						{
							template : function(data) {
								if (data.HDEPT_NM === '') {
									return '<input type="button" id="' + data.DEPT_CD + '" class="blue_btn" value="선택" onclick = "openSettingPopup(this)">';
								} else {
									return '<input type="button" id="' + data.DEPT_CD + '" class="green_btn" value="'+ data.HDEPT_NM +'" onclick = "openSettingPopup(this)">';	
								}
							},
							title : "상위 부서 설정",
							width : 60
						},
						{
							template : function(data) {
								return '<input type="button" class="blue_btn" value="설정취소" onclick = "cancelSetting(this)">';
							},
							title : "설정취소",
							width : 60
						},
						{
							field : 'DEPT_SORT',
							title : "정렬순서",
							width : 30,
							editable : true
						}
						]
			    }).data("kendoGrid");
			},
			
			eventListener : function() {
				
				$('#highDeptPopupClose').on('click', function(e) {
					$("#highDeptPopup").data("kendoWindow").close();
				});
				
				$('#deptNm').on('keyup', function(e) {
					
					if (e.keyCode == 13) {
						highDeptReload();
					}
				});
				
				$('#dept').on('keyup', function(e) {
					
					if (e.keyCode == 13) {
						searchMainGrid();
					}
				})
			}
	}
	
	function popupGrid() {
		var popupGrid = $("#popupGrid").kendoGrid({
			dataSource : new kendo.data.DataSource({
				serverPaging : true,
				pageSize : 10,
				transport : {
					read : {
						url : _g_contextPath_+"/budget/searchDeptList",
						dataType : "json",
						type : 'post'
					},
					parameterMap: function(data, operation) {
						
						data.deptName = $('#deptNm').val();
				     	return data;
				     },
				},
				schema : {
					data : function(response) {
						return response.list;
					},
					total : function(response) {
						return response.total;
					},
				}
			}),
			dataBound : mainGridDataBound,
			height : 550,
			sortable : true,
			persistSelection : true,
			selectable : "multiple",
	        columns: [
				{
					field : "DEPT_CD",
					title : "부서코드",
					width : 60
				},
				{
					field : "DEPT_NM",
					title : "부서명",
					width : 60
				},
				{
					template : function(data) {
						return '<input type="button" class="blue_btn" value="선택" onclick = "setHighDept(this)">';
					},
					title : "선택",
					width : 60
				}]
	    }).data("kendoGrid");
	}
	
	function setHighDept(param) {
		var paramMap = {};
		var dataItem = $('#popupGrid').data('kendoGrid').dataItem($(param).closest('tr'));
		
		paramMap.deptSeq = selData.DEPT_CD;
		paramMap.parentDeptSeq = dataItem.DEPT_CD;
		paramMap.empSeq = erpEmpSeq;
		
		$.ajax({
			url : _g_contextPath_ + "/budget/saveSelDept",
			dataType : 'json',
			Type : 'POST',
			data : paramMap,
			success : function(result) {
				if (result.OUT_YN === 'Y') {
					$('#'+selData.DEPT_CD).val(dataItem.DEPT_NM);
					selData.set('HDEPT_CD', dataItem.DEPT_CD);
					selData.set('HDEPT_NM', dataItem.DEPT_NM);
					$('#deptNm').val('');
					selData = "";
					alert('설정 되었습니다.');
					$("#highDeptPopup").data("kendoWindow").close();
				} else {
					alert(result.OUT_MSG);
				}
			}
		})
	}
	
	function mainGridDataBound(e) {
		var grid = e.sender;
		
		if (grid.dataSource.total() == 0) {
			var colCount = grid.columns.length;
			$(e.sender.wrapper).find('tbody').append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
		}
	}
	
	function searchMainGrid() {
		$('#mainGrid').data('kendoGrid').dataSource.read(0);
	}
	
	function openSettingPopup(param) {
		
		selData = $('#mainGrid').data('kendoGrid').dataItem($(param).closest('tr'));
		
		$("#highDeptPopup").data("kendoWindow").open();
		popupGrid();
	}
	
	function cancelSetting(param) {
		var paramMap = {};
		var dataItem = $('#mainGrid').data('kendoGrid').dataItem($(param).closest('tr'));
		
		if (!(dataItem.HDEPT_NM.length > 0)) return;
		
		paramMap.deptSeq = dataItem.DEPT_CD;
		paramMap.empSeq = erpEmpSeq;
		
		$.ajax({
			url : _g_contextPath_ + "/budget/parentDeptCancel",
			dataType : 'json',
			Type : 'POST',
			data : paramMap,
			success : function(result) {
				if (result.OUT_YN === 'Y') {
					$('#'+dataItem.DEPT_CD).val('');
					dataItem.set('HDEPT_CD', '');
					dataItem.set('HDEPT_NM', '');
					$('#deptNm').val('');
					alert('취소 되었습니다.');
				} else {
					alert(result.OUT_MSG);
				}
			}
		})
	}
	
	function highDeptReload() {
		$('#popupGrid').data('kendoGrid').dataSource.read();
	}
	
	function save() {
		
		var modifiedList = $('#mainGrid').data('kendoGrid')._data.filter(function(obj) {
			return obj.dirty; 
		})
		
		$.ajax({
	 		url: _g_contextPath_+"/budget/saveHighDept",
	 		dataType : 'json',
	 		data : { param : JSON.stringify(modifiedList) },
	 		type : 'POST',
	 		async : false,
	 		success: function(result){
			
	 			if (result.OUT_YN == 'Y') {
	 				alert('저장하였습니다.');
	 			} else {
	 				alert(result.OUT_MSG);
	 			}
	 		}
	 	});
	}
</script>
<body>
	<div class="iframe_wrap">
		<div class="sub_title_wrap">
			<div class="title_div">
				<h4>상위부서 설정</h4>
			</div>
		</div>
		
		<div class="com_ta">
			<div class="top_box gray_box" id = "dataBox">
				<dl>
					<dt>부서</dt>
					<dd style="width:15%">
						<input type="text" style="" id = "dept" value="" />
						<input type="button" onclick="searchMainGrid();" id="searchButton2"	value="검색" />
					</dd>
				</dl>
			</div>
		</div>
		
		<div class="btn_div mt10 cl">
			<div class="left_div">
				<p class="tit_p mt5 mb0">상위 부서 설정</p>
			</div>
			<div class="right_div">
				<div class="controll_btn p0">
					<button type="button" id="" onclick = "save()">저장</button>
				</div>
			</div>
		</div>
		
		<div class="com_ta2">
			<div  id = "mainGrid">
			</div>
		</div>
	</div>
	
<!-- 상위 부서 조회 팝업 화면 -->
<div class="pop_wrap_dir" id="highDeptPopup" style="width:100%; display:none;">
	<div class="com_ta">
		<div class="top_box gray_box" id = "dataBox">
			<dl>
				<dt style="margin-left:8%;">부서명</dt>
				<dd style="width:20%">
					<input type="text"  style="width: 100%" id ="deptNm"  value=""/>
					<input type="hidden"  style="width: 100%" id ="deptSeq"  />
				</dd>
				<dt></dt>
				<dd style="margin-left: 10px;">
					<input type="button" onclick="highDeptReload();" id="searchButton"	value="검색" />
				</dd>
			</dl>
		</div>
	</div>
	<div class="pop_con">
		<div class="com_ta mt15">
			<div  id = "popupGrid">
			</div>
		</div>
	</div>
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" class="gray_btn" id="highDeptPopupClose" value="닫기">
		</div>
	</div>
</div>
<!-- 상위 부서 조회 팝업 화면 -->	
</body>

