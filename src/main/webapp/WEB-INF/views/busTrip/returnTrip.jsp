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
</style>

<script type="text/javascript">
	
	$(document).ready(function() {
		datePickerInit();
		fnTpfDeptComboBoxInit('selDept');
		mainGrid();
		var grid = $('#grid').data('kendoGrid');
		keyupInit();
	});


		$(function() {
			
			
		})
	function keyupInit() {
			$('#txtTitle').on('keyup', function(e){
				if(e.keyCode ===13){gridReLoad()} 
				});
			$('#empName').on('keyup', function(e){
				if(e.keyCode ===13){gridReLoad()} 
				});
			$('#docNo').on('keyup', function(e){
				if(e.keyCode ===13){gridReLoad()}
			});
	}
	/**
	 * 콤보박스 초기화
	 */
	function fnTpfDeptComboBoxInit(id){
		if($('#'+id)){
			var deptList = fnTpfGetDeptList();
			deptList.unshift({dept_name : "전체", dept_seq : ""});
			
			/* var deptList2 = [{dept_name : "${userInfo.orgnztNm }", dept_seq:"${userInfo.orgnztNm }"}]; */
			
			var itemType = $("#" + id).kendoComboBox({
				dataSource : deptList,
				dataTextField: "dept_name",
				dataValueField: "dept_seq",
				index: 0,
				change:function(){
					fnDeptChange();
				}
		    });
		}
	}

	
	function fnTpfGetDeptList(){
		var result = {};
		var params = {};
	    var opt = {
	    		url     : _g_contextPath_ + "/Ac/G20/Ex/getDeptList.do",
	            async   : false,
	            data    : params,
	            successFn : function(data){
	            	result = data.allDept;
	            }
	    };
	    acUtil.ajax.call(opt);
		return result;
	}
	
	function datePickerInit(){
		var toDay = new Date();
		var year = toDay.getFullYear();
		$("#txtFrDt").val(year + '-' + '01-01');
		$("#txtToDt").val(year + '-' + '12-31');
		var datePickerOpt = {
				format: "yyyy-MM-dd",
				culture : "ko-KR",
				change:function(){
					startChange();
				}
			};
		//시작날짜
		$("#txtFrDt").kendoDatePicker(datePickerOpt);
		$("#txtFrDt").attr("readonly",true);
		//종료날짜
		datePickerOpt.change = endChange;
		$("#txtToDt").kendoDatePicker(datePickerOpt);
		$("#txtToDt").attr("readonly",true);
		startChange();
		endChange();
	}
	
	function startChange() {
		var start = $('#txtFrDt').data("kendoDatePicker");
		var end = $('#txtToDt').data("kendoDatePicker");
        var startDate = start.value(),
        endDate = end.value();

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
        var endDate = end.value(),
        startDate = start.value();

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
		serverPaging: true,
		pageSize: 10,
		transport: {
			read: {
				type: 'post',
				dataType: 'json',
				url: _g_contextPath_ + "/busTrip/getSuccessBIzInfo",
			},
			parameterMap: function(data, operation) {
				
				data.emp_name = $('#empName').val();
				
				data.purpose = $('#txtTitle').val();
				
				data.txtFrDt =$('#txtFrDt').val();
				data.txtToDt =$('#txtToDt').val();

				data.docNo =$('#docNo').val();
				
				if($('#selDept').data('kendoComboBox').value() == '전체'){
					
				data.dept_seq ='';
				}else{
					
				data.dept_seq = $('#selDept').data('kendoComboBox').value();
				}
	   	    	return data ;
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
	
	//검색버튼 이벤트
	function searchBtn() {
		//메인그리드 reload 호출
		gridReLoad();
	}
	
	//메인그리드 reload
	function gridReLoad() {
		$('#grid').data('kendoGrid').dataSource.page(1);
		setTimeout(function(){console.log($('#grid').data("kendoGrid")._data);},1);
	}

	 //메인그리드
	function mainGrid() {
		
		//캔도 그리드 기본
		var grid = $("#grid").kendoGrid({
			dataSource : dataSource,
			height : 440,
			sortable : true,
			pageable : {
				refresh : true,
				pageSizes : [10,20,30,50,100],
				buttonCount : 5
			},
			persistSelection : true,
			columns : [
						 { 
							headerTemplate : "<input type='checkbox' id='headerCheckbox' class='k-checkbox header-checkbox headerCheckbox'><label class='k-checkbox-label' for='headerCheckbox'></label>",
							template: function(data){
								return '<input type="checkbox" id="'+data.biz_common_seq+'" class="k-checkbox checkbox"/><label for="'+data.biz_common_seq+'" class="k-checkbox-label"></label>';
							}
							,width:50,
						}, {
							field : "res_doc_seq",
							title : "결의서",
							width:100,
						}, {
							field : "doc_no",
							title : "문서 번호",
							width:100,
						}, {
							field : "biz_trip_no",
							title : "출장 번호",
							width:100,
						},
						{	field : "biz_emp_name",
							  title : "출장자",
							  width:100,
						},{
							field : "location",
							title : "출장지",
							width:200,
						},{
							field : "date",
							title : "출장일",
							width:80,
						},{
							field : "stime",
							title : "시작시간",
							width:80,
						},{
							field : "etime",
							title : "종료시간",
							width:80,
						},{
							field : "purpose",
							title : "목적",
							width:400,
						},{
							field : "amt_pay",
							title : "비용",
							template: function(data){
								var COST = data.amt_pay || "";
								return COST.toString().toMoney();
							}
						}/* ,{
							field : "project_name",
							title : "프로젝트명",
						},{
							field : "project_name",
							title : "예산명",
						} */,{
							field : "writer_emp_name",
							title : "기안자",
						}/* ,{
							field : "drafter_name",
							title : "결재자",
						} */,{
							field : "detail_name",
							title : "상태",
							template: function(data){
								var detail_name = data.detail_name || "미결의";
								return detail_name;
							}
						}],
						change: function (e) {
				        	gridClick(e);
				        },
						dataBound : function (e) {
							
							$(".headerCheckbox").change(function(){
								if($(this).is(":checked")){
									$(this).closest('table').parent().parent().parent().find('.checkbox').prop("checked", "checked");
						        }else{
						        	$(this).closest('table').parent().parent().parent().find('.checkbox').removeProp("checked");
						        }
							});
						}
					}).data("kendoGrid");
		
		
		
		
	}
	 
	function fnDeptChange(){
		var obj = $('#selDept').data('kendoComboBox');
		$('#txtDeptCd').val(obj._old);
		$('#txtDeptName').val(obj._prev);
		gridReLoad();
		
	}
	 
	
	function changeStatus() {
		
		var a= $('input[type=checkbox]:checked').not('.headerCheckbox');
		
		if(a.length == 0){
			
			return;
		}
		
		$.each(a, function(i,v){
		console.log($(v).attr('id'))
		
		var seq = $(v).attr('id');
		
		var data ={biz_common_seq : seq};
		
		$.ajax({
			url : "<c:url value='/busTrip/changeStatus' />",
			data : data,
			type : 'post',
			async : false,
			success : function(data) {
				console.log(data);
				gridReLoad();

			}
		});
		
		
		})
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

		<div class="top_box">
			<dl>
				<dt class="ar" style="width: 65px">요청기간</dt>
				<dd>
					<input type="text" value="" name="" id="txtFrDt" placeholder="" />
					&nbsp;~ 
					<input type="text" value="" name="" id="txtToDt" placeholder="" />
				</dd>
				<!-- <dt class="ar" style="width: 65px">구분</dt>
				<dd>
					<input id="txtPurcReqType" class="txtPurcReqType"/>
				</dd> -->
				<dt class="ar" style="width: 65px">부서</dt>
				<dd>
					<input id="selDept" />
					<input type="hidden" id="txtDeptName" value="" />
					<input type="hidden" id="txtDeptCd" value="" />
				</dd>
				<dt class="ar" style="width: 65px">출장자</dt>
				<dd>
					<input type="text" id="empName"  value="" /> 
				</dd>
				<dt class="ar" style="width: 40px">목적</dt>
				<dd>
					<input type="text" name="" id="txtTitle" style="width: 200px" class="ri"/>
				</dd>
				<dt class="ar" style="width: 65px">문서번호</dt>
				<dd>
					<input type="text" id="docNo"  value="" />
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
					<!-- <button type="button" id="btnReturn" onclick="fnPurcContRepApproval();">계약보고</button>
					<button type="button" id="btnReturn" onclick="fnPurcContRepApprovalComplete();" style="margin-right: 20px;">계약보고완료</button> -->
					<button type="button" id="" onclick="searchBtn();">조회</button>
					 <button type="button" id="" onclick="changeStatus();">상태 변경</button> 
				</div>
			</div>
		</div>
		
		<div class="com_ta2 mt15">
			<div id="grid"></div>
		</div>
	</div>
</div>
