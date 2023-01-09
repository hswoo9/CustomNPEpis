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
<script type="text/javascript" src='<c:url value="/js/jszip.min.js"></c:url>'></script>

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
	var url = _g_contextPath_ + '/Ac/G20/Ex/purcItemListData.do';
	
	$(document).ready(function() {
		datePickerInit();
		fnTpfDeptComboBoxInit('selDept');
		fnItemTypeComboBoxInit2("PURC_REQ_ITEM_TYPE", "txtItemType");
		contPopUpInit();
		mainGrid();
		var grid = $('#grid').data('kendoGrid');
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
									/* { template: "<input type='checkbox' class='checkbox'/>"
									,width:50,	
									}, */
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
	   	    	data.deptCd = $("#txtDeptCd").val();
	   	    	data.userSeq = $("#userSeq").val();
	   	    	data.purcContId = $("#purcContId").val();
	   	    	data.trNm = $("#txtTrNm").val();
	   	    	data.itemType = $("#txtItemType").val();
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
			height : 450,
			sortable : true,
			pageable : {
				refresh : true,
				pageSizes : [10,20,30,50,100],
				buttonCount : 5
			},
			persistSelection : true,
			dataBound: function(e) {
				fnItemTypeComboBoxInit("PURC_REQ_ITEM_TYPE", "itemType");
			},
			excel: {
	            fileName: "구매물품리스트.xlsx",
				allPages: true
	        },
			columns : [
						{
							field : "docNum",
							title : "문서번호",
							template : function(data){
								return "<a style='color: rgb(0, 51, 255);' href='javascript:fnDocPopOpen(\""+data.purcContId+"\",\""+data.cDikeycode+"\");'>"+data.docNum+"</a>";
							}
						},
						{
							field : "contTitle",
							title : "계약명",
							template : function(data){
								return "<a style='color: rgb(0, 51, 255);' href='javascript:fnPurcContViewPop(\""+data.purcReqId+"\",\""+data.purcReqTypeCodeId+"\",\""+data.formId+"\",\""+data.purcContId+"\");'>"+data.contTitle+"</a>";
							}
						},{
							field : "requesterEmpName",
							title : "요청자",
						},{
							field : "requesterDeptName",
							title : "부서",
						},{
							field : "trNm",
							title : "업체",
						},{
							field : "deliveryDate",
							title : "납품일",
							template : function(data){
								return data.deliveryDate.toDate();
							}
						},{
							field : "itemType",
							title : "품목구분",
							template : function(data){
								var obj = "<input type='text' id='itemType' class='itemType' value='"+data.itemTypeCodeId+"' purcContTId='"+data.purcContTId+"' onchange='fnItemTypeChange(this)' style='width:80px;'/>";
								return obj;
							}
						},{
							field : "itemNm",
							title : "품명",
						},{
							field : "itemCnt",
							title : "수량",
						},{
							field : "standard",
							title : "규격",
						},{
							field : "itemAm",
							title : "단가",
							template : function(data){
								return data.itemAm.toString().toMoney();
							}
						},{
							field : "unitAm",
							title : "금액",
							template : function(data){
								return data.unitAm.toString().toMoney();
							}
						},{
							field : "supAm",
							title : "공급가액",
							template : function(data){
								return data.supAm.toString().toMoney();
							}
						},{
							field : "vatAm",
							title : "부가세",
							template : function(data){
								return data.vatAm.toString().toMoney();
							}
						},{
							field : "remark",
							title : "비고",
						}],
						change: function (e) {
				        	gridClick(e);
				        }
					}).data("kendoGrid");
		
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
	
	/**
	 * 콤보박스 초기화
	 */
	function fnItemTypeComboBoxInit(groupCode, id){
		var commCodeList = fnTpfGetCommCodeList(groupCode);
		var itemType = $("."+id).kendoComboBox({
			dataSource : commCodeList,
			dataTextField: "code_kr",
			dataValueField: "code",
			index: 0
	    });
		$('.' + id).attr('readonly', true);
	}
	
	function fnItemTypeComboBoxInit2(groupCode, id){
		var commCodeList = fnTpfGetCommCodeList(groupCode);
		if(commCodeList){
			commCodeList[0].code_kr = "전체";
		}
		var itemType = $("."+id).kendoComboBox({
			dataSource : commCodeList,
			dataTextField: "code_kr",
			dataValueField: "code",
			index: 0
	    });
		$('.' + id).attr('readonly', true);
		delete commCode[groupCode];
	}
	
	function fnItemTypeChange(eventEle){
		
		var params = {};
		params.itemType = commCode.PURC_REQ_ITEM_TYPE.filter(function(obj){return obj.code==$(eventEle).val()})[0].code_kr;
		params.itemTypeCodeId = $(eventEle).val();
		params.purcContTId = $(eventEle).attr("purcContTId");
	    var opt = {
	    		url     : _g_contextPath_ + "/Ac/G20/Ex/updateItemType.do",
	            async   : false,
	            data    : params,
	            successFn : function(data){
	            	result = data.allDept;
	            }
	    };
	    acUtil.ajax.call(opt);
	}
	
	/*계약팝업 시작*/
	
	function contPopUpInit(){
		contGrid();
		//팝업ID	
		var contWindow = $("#contPopUp");
		//검색ID
	    contSearch = $("#contPopUpBtn");
	    //검색 클릭(팝업호출)
	    contSearch.click(function() {	
	    	 $('#dept_name').val($('#deptNameCode').val());
	    	 contWindow.data("kendoWindow").open();
	    	 contGridReload();
		     contSearch.fadeOut();
		 });
	    
	     //팝업 X 닫기버튼 이벤트
		 function onClose() {
			 contSearch.fadeIn();
		 }
	     
	     //닫기 이벤트
		 $("#cancle").click(function(){
			 contWindow.data("kendoWindow").close();
		 });
		 
		 //팝업 초기화
		 contWindow.kendoWindow({
		     width: "600px",
		     height: "705px",
		     visible: false,
		     modal: true,
		     actions: [
		    	 "Close"
		     ],
		     close: onClose
		 }).data("kendoWindow").center();
	}
	
	//계약팝업 ajax
	var contDataSource = new kendo.data.DataSource({
		serverPaging: true,
		pageSize: 10,
	    transport: { 
	        read:  {
	            url: _g_contextPath_ + "/Ac/G20/Ex/getContPopupList.do",
	            dataType: "json",
	            type: 'post'
	        },
	      	parameterMap: function(data, operation) {
	        	data.contTitle = $('#contTitle').val();
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

	function contGridReload(){
		$('#contGrid').data('kendoGrid').dataSource.read();
	}
	
	function contGrid(){		
		//사원 팝업그리드 초기화
		var grid = $("#contGrid").kendoGrid({
	        dataSource: contDataSource,
	        height: 500,	        
	        sortable: true,
	        pageable: {
	            refresh: true,
	            pageSizes: true,
	            buttonCount: 5
	        },
	        persistSelection: true,
	        selectable: "multiple",
	        columns:[ 
	        	{field: "contTitle",
		            title: "계약명",
			    },
		        {title : "선택",
				    template : '<input type="button" id="" class="text_blue" onclick="contSelect(this);" value="선택">'
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
			grid = $('#contGrid').data("kendoGrid"),
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
			}); 
			subReload(record);
		}
	}

	function subReload(record){
		$('#keyId').val(record.if_info_system_id);
	} 

	//선택 클릭이벤트
	function contSelect(e) {		
		//선택row
		var row = $("#contGrid").data("kendoGrid").dataItem($(e).closest("tr"));
		$('#txtContNm').val(row.contTitle);		
		$('#purcContId').val(row.purcContId);		
		//팝업ID	
		var contWindow = $("#contPopUp");		
		//닫기 이벤트
		contWindow.data("kendoWindow").close();
	}
	/*계약팝업 끝*/
	 
	function excelDown(){
		$("#grid").getKendoGrid().saveAsExcel();
	}
	
	function fnDocPopOpen(purcContId, docId){
		var params = {};
	    params.loginId = $('#loginId').val();
	    params.approKey = "tpfContRep" + purcContId;
	    params.docId = docId;
	    params.mod = 'V';
	    outProcessLogOn(params);
	}

	function fnPurcContViewPop(purcReqId, purcReqType, formId, purcContId){
		var url = _g_contextPath_ + '/Ac/G20/Ex/purcContConcView.do?focus=txt_BUDGET_LIST&form_tp=view&purcReqId=' + purcReqId + '&purcReqType=' + purcReqType + '&form_id=' + formId + '&purcContId=' + purcContId;
		var pop = "" ;
		var popupName = "구매계약체결";
		var width = "1000";
		var height = "950";
		windowX = Math.ceil( (window.screen.width  - width) / 2 );
		windowY = Math.ceil( (window.screen.height - height) / 2 );
		var strResize = "YES" ;
		
		pop = window.open(url, '구매계약보기', "width=" + width + ", height=" + height + ", top="+ windowY +", left="+ windowX +", scrollbars=YES, resizable=YES");
		try {pop.focus(); } catch(e){}
	}
</script>

<!-- iframe wrap -->
<div class="iframe_wrap" style="min-width: 1100px">
	<form id="outProcessFormData" action="http://211.192.144.104/gw/outProcessLogOn.do" target="outProcessLogOn"></form>
	<input type="hidden" id="compSeq" value="${loginVO.compSeq }"/>
	<input type="hidden" id="empSeq" value="${loginVO.uniqId }"/>
	<input type="hidden" id="loginId" value="${loginVO.id }"/>
	<input type="hidden" id="mng" value="${params.mng }"/>
	<!-- 컨텐츠타이틀영역 -->
	<div class="sub_title_wrap">

		<div class="title_div">
			<h4>근무계획</h4>
		</div>
	</div>

	<div class="sub_contents_wrap">

		<div class="top_box">
			<dl>
				<dt class="ar" style="width: 65px">검수기간</dt>
				<dd>
					<input type="text" value="" name="" id="txtFrDt" placeholder="" />
					&nbsp;~ 
					<input type="text" value="" name="" id="txtToDt" placeholder="" />
				</dd>
				<dt class="ar" style="width: 65px">요청부서</dt>
				<dd>
					<input id="selDept" />
					<input type="hidden" id="txtDeptName" value="" />
					<input type="hidden" id="txtDeptCd" value="" />
				</dd>
				<dt class="ar" style="width: 65px">요청자</dt>
				<dd>
					<input type="text" id="empName" disabled="disabled" value="" /> 
					<input type="hidden" id="userSeq" disabled="disabled" value="" /> 
					<input type="hidden" id="deptName2" value="" /> 
					<input type="hidden" id="deptSeq" value="" />
				</dd>
				<dd>
					<input type="button" id="empPopUpBtn" value="검색" />
				</dd>
			</dl>
			<dl>
				<dt class="ar" style="width: 65px">계약</dt>
				<dd>
					<input type="text" name="" id="txtContNm" disabled="disabled"/>
					<input type="hidden" id="purcContId" value="" />
				</dd>
				<dd>
					<input type="button" id="contPopUpBtn" value="검색" />
				</dd>
				<dt class="ar" style="width: 65px">거래처</dt>
				<dd>
					<input type="text" id="txtTrNm" class="txtTrNm"/>
				</dd>
				<dt class="ar" style="width: 65px">품목구분</dt>
				<dd>
					<input type="text" id="txtItemType" class="txtItemType"/>
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
					<button type="button" id="" onclick="excelDown();">엑셀</button>
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
	
	<!-- 계약검색팝업 -->
	<div class="pop_wrap_dir" id="contPopUp" style="width:600px;">
		<div class="pop_head">
			<h1>계약 선택</h1>
		</div>
		<div class="pop_con">
			<div class="top_box">
				<dl>
					<dt class="ar" style="width: 65px;">계약명</dt>
					<dd>
						<input type="text" id="contTitle" style="width: 120px" />
						<input type="button" onclick="contGridReload();" id="searchButton"	value="검색" />
					</dd>
				</dl>
			</div>
			<div class="com_ta mt15" style="">
				<div id="contGrid"></div>
			</div>			
		</div><!-- //pop_con -->

		<div class="pop_foot">
			<div class="btn_cen pt12">				
				<input type="button" class="gray_btn" id="cancle" value="닫기" />
			</div>
		</div><!-- //pop_foot -->
	</div><!-- //pop_wrap -->