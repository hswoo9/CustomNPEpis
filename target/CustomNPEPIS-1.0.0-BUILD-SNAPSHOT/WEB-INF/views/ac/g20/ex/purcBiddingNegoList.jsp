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
	var url = _g_contextPath_ + '/Ac/G20/Ex/purcReqListData.do';
	
	$(document).ready(function() {
		datePickerInit();
		fnTpfComboBoxInit('PURC_REQ_TYPE', 'txtPurcReqType', $('.top_box'));
		fnTpfDeptComboBoxInit('selDept');
		mainGrid();
		$("#txtContAm").keyup(function(){
			$(this).val($(this).val().toString().toMoney());
		});
	});
	
	/* 사원팝업 kendo 그리드 refresh */
	function empGridReload() {
		/* $('#empGrid').data('kendoGrid').dataSource.read(); */
		$("#empGrid").data("kendoGrid").dataSource.page(1);
	}

	/* 사원팝업 kendo 그리드 */
	var empDataSource = new kendo.data.DataSource({
		serverPaging : true,
		pageSize : 10,
		transport : {
			read : {
				url : _g_contextPath_+'/common/empInformation',
				dataType : "json",
				type : 'post'
			},
			parameterMap : function(data, operation) {
				data.deptSeq = $('#deptSeq').val();
				data.emp_name = $('#emp_name').val();
				data.dept_name = $('#dept_name').val();
				data.notIn = '';
				return data;
			}
		},
		schema : {
			data : function(response) {
				return response.list;
			},
			total : function(response) {
				return response.totalCount;
			}
		}
	});
	/* 사원팝업 kendo 그리드 */
	function empGrid() {
		//캔도 그리드 기본
		var empGrid = $("#empGrid")
				.kendoGrid(
						{
							dataSource : empDataSource,
							height : 460,

							pageable : {
								refresh : true,
								pageSizes : [10,20,30,50,100],
								buttonCount : 5
							},
							persistSelection : true,
							selectable : "multiple",
							columns : [
									{
										field : "emp_name",
										title : "이름",

									},
									{

										field : "dept_name",
										title : "부서",

									},
									{
										field : "position",
										title : "직급",

									},
									{
										field : "duty",
										title : "직책",

									},
									{
										title : "선택",
										template : '<input type="button" id="" class="text_blue" onclick="empSelect(this);" value="선택">'
									} ],
							change : function(e) {
							}
						}).data("kendoGrid");

		empGrid.table.on("click", ".checkbox", selectRow);

		var checkedIds = {};

		// on click of the checkbox:
		function selectRow() {

			var checked = this.checked, row = $(this).closest("tr"), empGrid = $(
					'#empGrid').data("kendoGrid"), dataItem = grid
					.dataItem(row);

			checkedIds[dataItem.emp_seq] = checked;
			if (checked) {
				//-select the row
				row.addClass("k-state-selected");
			} else {
				//-remove selection
				row.removeClass("k-state-selected");
			}
		}
	}

	/* 사원 선택 기능 */
	function empSelect(e) {
		var row = $("#empGrid").data("kendoGrid").dataItem($(e).closest("tr"));
		$('#empName').val(row.emp_name);
		$('#userSeq').val(row.emp_seq);
		$('#deptName2').val(row.dept_name);
		$('#popUp3').data("kendoWindow").close();
	}

		$(function() {
			
			$('#popUp3 .top_box input[type=text]').on('keypress', function(e) {
				if (e.key == 'Enter') {
					empGridReload();
				};
			});
			
			$('#popUp3').kendoWindow({
				width : "600px",
				height : "665px",
				visible : false,
				modal : true,
				actions : [ "Close" ],
			}).data("kendoWindow").center();
			
			$('#empPopUpBtn').on('click', function() {
				$('#popUp3').data("kendoWindow").open();
			})
			
			empGrid();
			
		})
		
	/**
	 * 콤보박스 초기화
	 */
	function fnTpfComboBoxInit(groupCode, id, parentEle){
		var commCodeList = fnTpfGetCommCodeList(groupCode);
		commCodeList.unshift({code_kr : "전체", code : ""});
		var itemType = $("." + id, parentEle).kendoComboBox({
			dataSource : commCodeList,
			dataTextField: "code_kr",
			dataValueField: "code",
			index: 0
	    });
		$('.' + id, parentEle).attr('readonly', true);
	}
	
	/**
	 * 콤보박스 초기화
	 */
	function fnTpfDeptComboBoxInit(id){
		if($('#'+id)){
			var deptList = fnTpfGetDeptList();
			deptList.unshift({dept_name : "전체", dept_seq : ""});
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

	commCode = {};
	/**
	 * 공통코드리스트 조회
	 */
	function fnTpfGetCommCodeList(groupCode){
		if(commCode[groupCode]){
			return commCode[groupCode];
		}
		var result = {};
		var params = {};
		params.group_code = groupCode;
	    var opt = {
	    		url     : _g_contextPath_ + "/commcode/getCommCodeList",
	            async   : false,
	            data    : params,
	            successFn : function(data){
	            	result = data;
	            	commCode[groupCode] = data;
	            }
	    };
	    acUtil.ajax.call(opt);
		return result;
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
				url: url
			},
			parameterMap: function(data, operation) {
	   	    	data.frDt = $("#txtFrDt").val().replace(/-/gi,"");
	   	    	data.toDt = $("#txtToDt").val().replace(/-/gi,"");
	   	    	data.purcReqType = $("#txtPurcReqType").val();
	   	    	data.deptCd = $("#txtDeptCd").val();
	   	    	data.userSeq = $("#userSeq").val();
	   	    	data.title = $("#txtTitle").val();
	   	    	data.contAm = $("#txtContAm").val().toString().toMoney2();
	   	    	data.reqState2 = '149,159,160,161,162,163,164,165,165,166,167,168,169';
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
			//autoBind: false,
			dataSource : dataSource,
			height : 500,
			sortable : true,
			pageable : {
				refresh : true,
				pageSizes : [10,20,30,50,100],
				buttonCount : 5
			},
			persistSelection : true,
			dataBound: function(e) {
				var gridData = $('#grid').data("kendoGrid")._data;
				$.each(gridData, function(){
					if(this.reqState == "005" && $('#mng').val() != "Y"){
						$('#grid .k-grid-content tr[data-uid='+this.uid+']').addClass('text_red');
					}
				});
			},
			columns : [
						{ 
							template: function(data){
								if(data.reqState === '161' || data.reqState === '162'){
									return "<input type='checkbox' class='checkbox' purcReqId='"+data.purcReqId+"' reqState='"+data.reqState+"'/>";
								}else{
									return '';
								}
							},
							width:50,
						},{
							field : "purcReqType",
							title : "구분",
							width:90,
						},{
							field : "contType",
							title : "계약방법",
							width:70,
						},{
							field : "requesterEmpName",
							title : "요청자",
							width:100,
						},{
							field : "requesterPosition",
							title : "직급",
							width:60,
						},{
							field : "requesterDuty",
							title : "직책",
							width:60,
						},{
							field : "purcReqTitle",
							title : "제목",
							template : function(data){
								var purcReqTitle = data.purcReqTitle;
								purcReqTitle = "<a href='javascript:fnPurcReqDocViewPop("+data.purcReqId+","+data.cDikeycode+");' style='color: rgb(0, 51, 255);'>"+data.purcReqTitle+"</a>";
								return purcReqTitle;
							}
						},{
							field : "regDate",
							title : "의뢰일",
							width:80,
						},{
							field : "",
							title : "사업기간",
							template: function(data){
								var purcReqDate = "";
								if(data.purcReqDate){
									purcReqDate = "계약일로 부터 " + data.purcReqDate + "일 까지";
								}else if(data.term){
									var tempDate = moment(data.contDate).add(data.term, "d").format("YYYY-MM-DD");
									if(!data.contDate){
										tempDate = moment(data.regDate).add(data.term, "d").format("YYYY-MM-DD");
									}else{
									}
									purcReqDate = "계약일로 부터 " + tempDate + "일 까지";
								}
								return purcReqDate;
							},
							width:200,
						},{
							field : "purcPurpose",
							title : "목적",
						},{
							field : "contAm",
							title : "의뢰금액",
							template: function(data){
								var contAm = data.contAm || "0";
								return contAm.toString().toMoney();
							},
							width:100,
						},{
							field : "reqStateNm",
							title : "상태",
							width:100,
						},{
							field : "",
							title : "기술협상",
							template: function(data){
								if(data.reqState === '149' || data.reqState === '159'){
									return '<div class="controll_btn p0 ac"><button type="button" id="" onclick="fnRegiPop(\''+data.purcReqId+'\', \'add\');">등록</button></div>';
								}else if(data.reqState === '161' || data.reqState === '162'){
									return '<div class="controll_btn p0 ac"><button type="button" id="" onclick="fnRegiPop(\''+data.purcReqId+'\', \'mod\');">수정</button></div>';
								}else if(data.reqState === '169'){
									return '<div class="controll_btn p0 ac"><button type="button" id="" onclick="fnRegiPop(\''+data.purcReqId+'\', \'view\');">보기</button></div>';
								}else{
									return '';
								}
							},
							width:80,
						},{
							field : "returnReason",
							title : "반려사유",
						}],
						change: function (e) {
				        	gridClick(e)
				        }
					}).data("kendoGrid");
		
		grid.table.on("click", ".checkbox", selectRow);
		
		var checkedIds = {};
		
		// on click of the checkbox:
		function selectRow(){
			var checked = this.checked,
			row = $(this).closest("tr"),
			grid = $('#grid').data("kendoGrid"),
			dataItem = grid.dataItem(row);
			
			checkedIds[dataItem.ISPC_MST_ID] = checked;
			if (checked) {
				//-select the row
				row.addClass("k-state-selected");
			} else {
				//-remove selection
				row.removeClass("k-state-selected");
			} 
		}
		
		//mainGrid 클릭이벤트
		function gridClick(){
			var rows = grid.select();
			var record;
		    rows.each(function () {
		        record = grid.dataItem($(this));
		    });
	   }
	}
	 
	function fnDeptChange(){
		var obj = $('#selDept').data('kendoComboBox');
		$('#txtDeptCd').val(obj._old);
		$('#txtDeptName').val(obj._prev);
	}
	 
	var openDialog = function(uri, name, options, closeCallback) {
	    var win = window.open(uri, name, options);
	    var interval = window.setInterval(function() {
	        try {
	            if (win == null || win.closed) {
	                window.clearInterval(interval);
	                closeCallback(win);
	            }
	        }
	        catch (e) {
	        }
	    }, 1000);
	    return win;
	};
	
	function fnPurcReqDocViewPop(purcReqId,docId){
		var params = {};
	    params.loginId = $('#loginId').val();
// 	    params.approKey = "tpfPurcReq" + purcReqId;
	    params.docId = docId;
	    params.mod = 'V';
	    outProcessLogOn(params);
	}
	
	function fnRegiPop(purcReqId, type){
		var url = _g_contextPath_ + '/Ac/G20/Ex/purcBiddingNegoRegPop.do?focus=txt_BUDGET_LIST&purcReqId=' + purcReqId + '&type=' + type;
		var pop = "" ;
		var width = "1000";
		var height = "400";
		windowX = Math.ceil( (window.screen.width  - width) / 2 );
		windowY = Math.ceil( (window.screen.height - height) / 2 );
		var strResize = 0 ;
		var popupName = "기술협상";
		var options = "width=" + width + ", height=" + height + ", top="+ windowY +", left="+ windowX +", scrollbars=YES, resizable=YES";
		openDialog(url, popupName, options, function(win) {
			gridReLoad();
		});
	}
	
	function submit(){
		if($('.checkbox:checked').length === 0){
			alert('선택된 내역이 없습니다.');
			return;
		}
		if(!confirm('기술협상내역을 제출합니다.')){
			return;
		}
		var data = {};
		data.reqState = '169';
		$.each($('.checkbox:checked'), function(){
			data.purcReqId = $(this).attr('purcReqId');
		    var opt = {
		    		url     : _g_contextPath_ + "/Ac/G20/Ex/updatePurcBiddingState.do",
		            async   : false,
		            data    : data,
		            successFn : function(data){
		            }
		    };
		    acUtil.ajax.call(opt);
		});
		alert('기술협상내역을 제출했습니다.')
		gridReLoad();
	}
	
	var openDialog = function(uri, name, options, closeCallback) {
	    var win = window.open(uri, name, options);
	    var interval = window.setInterval(function() {
	        try {
	            if (win == null || win.closed) {
	                window.clearInterval(interval);
	                closeCallback(win);
	            }
	        }
	        catch (e) {
	        }
	    }, 1000);
	    return win;
	};
</script>

<!-- iframe wrap -->
<div class="iframe_wrap" style="min-width: 1400px">
<form id="outProcessFormData" action="http://211.192.144.104/gw/outProcessLogOn.do" target="outProcessLogOn"></form>
<input type="hidden" id="mng" value="${mng }" />
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
				<dt class="ar" style="width: 40px">구분</dt>
				<dd>
					<input id="txtPurcReqType" class="txtPurcReqType"/>
				</dd>
				<c:choose>
					<c:when test="${mng eq 'Y' }">
				<dt class="ar" style="width: 65px;">요청부서</dt>
				<dd>
					<input id="selDept" />
					<input type="hidden" id="txtDeptName" value="" />
					<input type="hidden" id="txtDeptCd" value="" />
				</dd>
				<dt class="ar" style="width: 50px">요청자</dt>
				<dd>
					<input type="text" id="empName" disabled="disabled" value="" /> 
					<input type="hidden" id="userSeq" disabled="disabled" value="" /> 
					<input type="hidden" id="deptName2" value="" /> 
					<input type="hidden" id="deptSeq" value="" />
				</dd>
				<dd>
					<input type="button" id="empPopUpBtn" value="검색" />
				</dd>
					</c:when>
					<c:when test="${mng eq 'temp' }">
				<dd>
					<input type="hidden" id="userSeq" disabled="disabled" value="${loginVO.uniqId }" /> 
				</dd>
					</c:when>
					<c:otherwise>
				<dt class="ar" style="width: 65px;">요청부서</dt>
				<dd>
					<input type="text" id="txtDeptName" disabled="disabled" value="${loginVO.orgnztNm }" />
					<input type="hidden" id="txtDeptCd" value="${loginVO.orgnztId }" />
				</dd>
				<dt class="ar" style="width: 50px">요청자</dt>
				<dd>
					<input type="text" id="empName" disabled="disabled" value="" /> 
					<input type="hidden" id="userSeq" disabled="disabled" value="" /> 
					<input type="hidden" id="deptName2" value="" /> 
					<input type="hidden" id="deptSeq" value="" />
				</dd>
				<dd>
					<input type="button" id="empPopUpBtn" value="검색" />
				</dd>
					</c:otherwise>
				</c:choose>
			</dl>
			<dl>
				<dt class="ar" style="width: 40px">제목</dt>
				<dd>
					<input type="text" name="" id="txtTitle" class="ri"/>
				</dd>
				<dt class="ar" style="width: 80px">요청금액</dt>
				<dd>
					<input type="text" name="" id="txtContAm" class="ri"/>
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
					<button type="button" id="" onclick="submit();">제출</button>
					<button type="button" id="" onclick="searchBtn();">조회</button>
				</div>
			</div>
		</div>
		
		<div class="com_ta2 mt15">
			<div id="grid"></div>
		</div>
	</div>
</div>
	<!-- //sub_contents_wrap -->
<!-- iframe wrap -->

	<!-- 사원검색팝업 -->
	<div class="pop_wrap_dir" id="popUp3" style="width: 600px;">
		<div class="pop_head">
			<h1>사원 리스트</h1>
	
		</div>
		<div class="pop_con">
			<div class="top_box">
				<dl>
					<dt class="ar" style="width: 65px;">성명</dt>
					<dd>
						<input type="text" id="emp_name" style="width: 120px" />
					</dd>
					<dt>부서</dt>
					<dd>
						<input type="text" id="dept_name" style="width: 180px" /> <input
							type="button" onclick="empGridReload();" id="searchButton"
							value="검색" />
					</dd>
				</dl>
			</div>
			<div class="com_ta mt15" style="">
				<div id="empGrid"></div>
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
	<!-- //pop_wrap -->
