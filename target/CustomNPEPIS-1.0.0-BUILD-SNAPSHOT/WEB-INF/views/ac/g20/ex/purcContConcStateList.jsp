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
	var url = _g_contextPath_ + '/Ac/G20/Ex/purcContListData.do';
	
	$(document).ready(function() {
		datePickerInit();
		fnTpfComboBoxInit('PURC_REQ_TYPE', 'txtPurcReqType', $('.top_box'));
		fnTpfDeptComboBoxInit('selDept');
		mainGrid();
		var grid = $('#grid').data('kendoGrid');
		if($('#mng').val() == 'Y'){
			if($("#ac").val() == "Y"){
				grid.hideColumn(14);
			}else{
			}
		}else{
// 			grid.hideColumn(14);
		}
		$("#txtContAm").bind({
			keyup : function(){
				$(this).val($(this).val().toMoney());
			}
		})
		popUpInit();
		
		var datePickerOpt = {
			    depth: "decade",
			    start: "decade",
			    culture : "ko-KR",
				format : "yyyy",
				value : new Date(),
			}
		
		$("#pjtFromDate").kendoDatePicker(datePickerOpt);
		$("#pjtToDate").kendoDatePicker(datePickerOpt);
		
		$('#pjt_Search_btn').on({
			click: function(){
				projectListReLoad();
			}
		});
	});
	
	function popUpInit(){
		if($("#mng").val() == "Y"){
			projectPopUpInit();
		}else{
			projectPopUp2Init();
		}
		budgetPopUpInit();
	}
	
	var projectDataSource = new kendo.data.DataSource({
		serverPaging: true,
		pageSize: 10,
	    transport: { 
	        read:  {
	            url:  "<c:url value='/common/getProjectList' />",
	            dataType: "json",
	            type: 'post'
	        },
	      	parameterMap: function(data, operation) {
	      		data.erpCoCd = $("#erpCoCd").val();
	      		data.search_pNm = $('#searchPjNm').val();
	      		data.search_pCd = $('#searchPjCd').val();
	      		data.erpPjtStatus = $("#selProjectStat").val();
	      		data.pjtFromDate = $("#pjtFromDate").val() + '0101';;
	      		data.pjtToDate = $("#pjtToDate").val() + '1231';;
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

	function projectPopUpInit(){
		$('#projectPopUp').kendoWindow({
			width: "500px",
		    title: '프로젝트 조회',
		    visible: false,
		    modal : true,
		    actions: [
		        "Close"
		    ],
		}).data("kendoWindow").center();
		
		$("#projectList").kendoGrid({
	        dataSource: projectDataSource,
	        height: 460,
	        sortable: false,
	        pageable: false,
	        persistSelection: true,
	        selectable: "multiple",
	        columns: [
	       	 {
	            title: "프로젝트코드",
	            columns: [{
	                field: "pjt_cd",
	             	width: "140px",
	                headerTemplate: function(){
	    				return '<input type="text" style="width:90%;" id="searchPjCd" class="projectHeaderInput">';
	    	        },
	     		}]
	        }, {
	            title: "프로젝트명",
	            columns: [{
	                field: "pjt_nm",
	                headerTemplate: function(){
	    				return '<input type="text" style="width:90%;" id="searchPjNm" class="projectHeaderInput">';
	    	        },
	     		}]
	        }],
	    }).data("kendoGrid");
		
		$('.projectHeaderInput').on('keydown', function(key){
			if (key.keyCode == 13) {
				 $("#projectList").data('kendoGrid').dataSource.read();
	        }
		});
		
		$(document).on('dblclick', '#projectList .k-grid-content tr', function(){
			var gData = $("#projectList").data('kendoGrid').dataItem(this);
			$('#' + popupId).val(gData.pjt_nm).attr('code', gData.pjt_cd);
			$('#projectPopUp').data("kendoWindow").close();
		});
	}

	var projectDataSource2 = new kendo.data.DataSource({
		serverPaging: true,
		pageSize: 10,
	    transport: { 
	        read:  {
	            url:  "<c:url value='/Ac/G20/Code/getErpMgtList.do' />",
	            dataType: "json",
	            type: 'post'
	        },
	      	parameterMap: function(data, operation) {
	      		data.EMP_CD = $("#erpEmpCd").val();
	      		data.FG_TY = "2";
	      		data.CO_CD = $("#erpCoCd").val();
	      		data.erpPjtStatus = $("#selProjectStat").val();
	      		data.pjtFromDate = $("#pjtFromDate").val() + '0101';;
	      		data.pjtToDate = $("#pjtToDate").val() + '1231';;
	      		return data;
	     	}
	    },
	    schema: {
			data: function(response) {
				return response.selectList;
			},
			total: function(response) {
				return response.totalCount;
			}
		}
	});

	function projectPopUp2Init(){
		$('#projectPopUp').kendoWindow({
			width: "500px",
		    title: '프로젝트 조회',
		    visible: false,
		    modal : true,
		    actions: [
		        "Close"
		    ],
		}).data("kendoWindow").center();
		
		$("#projectList").kendoGrid({
	        dataSource: projectDataSource2,
	        height: 460,
	        sortable: false,
	        pageable: false,
	        persistSelection: true,
	        selectable: "multiple",
	        dataBound: function(){
	        	var e = jQuery.Event("keydown");
	        	e.keyCode = 13;
	        	$('.projectHeaderInput').trigger(e);
	        },
	        columns: [
	       	 {
	            title: "프로젝트코드",
	            columns: [{
	                field: "PJT_CD",
	             	width: "140px",
	                headerTemplate: function(){
	    				return '<input type="text" style="width:90%;" id="searchPjCd" class="projectHeaderInput">';
	    	        },
	    	        template: function(data){
	    	        	return "<span class='pjt_cd' code='" +data.PJT_CD+ "'>" + data.PJT_CD + "</span>";
	    	        },
	     		}]
	        }, {
	            title: "프로젝트명",
	            columns: [{
	                field: "PJT_NM",
	                headerTemplate: function(){
	    				return '<input type="text" style="width:90%;" id="searchPjNm" class="projectHeaderInput">';
	    	        },
	    	        template: function(data){
	    	        	return "<span class='pjt_nm' code='" +data.PJT_NM+ "'>" + data.PJT_NM + "</span>";
	    	        },
	     		}]
	        }],
	    }).data("kendoGrid");
		
		$('.projectHeaderInput').on('keydown', function(key){
			if (key.keyCode == 13) {
				$("#projectList tbody tr").show();
				$("#projectList tbody tr .pjt_cd").each(function(data){
					if($(this).attr("code").indexOf($("#searchPjCd").val()) == -1){
						$(this).closest("tr").hide();
					}
				});
				$("#projectList tbody tr .pjt_nm").each(function(data){
					if($(this).attr("code").indexOf($("#searchPjNm").val()) == -1){
						$(this).closest("tr").hide();
					}
				});
			}
		});
		
		$(document).on('dblclick', '#projectList .k-grid-content tr', function(){
			var gData = $("#projectList").data('kendoGrid').dataItem(this);
			$('#' + popupId).val(gData.PJT_NM).attr('code', gData.PJT_CD);
			$('#projectPopUp').data("kendoWindow").close();
		});
	}

	var budgetDataSource = new kendo.data.DataSource({
		serverPaging: true,
		pageSize: 10,
	    transport: { 
	        read:  {
	            url:  "<c:url value='/common/getBudgetList' />",
	            dataType: "json",
	            type: 'post'
	        },
	      	parameterMap: function(data, operation) {
	      		data.search_bCd = $('#searchBudgetCd').val();
	      		data.search_bNm = $('#searchBudgetNm').val();
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

	function budgetPopUpInit(){
		$('#budgetPopUp').kendoWindow({
			width: "600px",
		    title: '예산과목 조회',
		    visible: false,
		    modal : true,
		    actions: [
		        "Close"
		    ],
		}).data("kendoWindow").center();
		
		$("#budgetList").kendoGrid({
	        dataSource: budgetDataSource,
	        height: 460,
	        sortable: false,
	        pageable: false,
	        persistSelection: true,
	        selectable: "multiple",
	        columns: [
	       	 {
	            title: "코드",
	            columns: [{
	                field: "BGT_CD",
	                headerTemplate: function(){
	    				return '<input type="text" style="width:90%;" id="searchBudgetCd" class="budgetHeaderInput">';
	    	        },
	     		}]
	        }, {
	            title: "예산과목명",
	            columns: [{
	                field: "BGT_NM",
	                headerTemplate: function(){
	    				return '<input type="text" style="width:90%;" id="searchBudgetNm" class="budgetHeaderInput">';
	    	        },
	     		}]
	        }],
	    }).data("kendoGrid");
		
		$(document).on('dblclick', '#budgetList .k-grid-content tr', function(){
			var gData = $("#budgetList").data('kendoGrid').dataItem(this);
			$('#' + popupId).val(gData.BGT_NM).attr('code', gData.BGT_CD);
			$('#budgetPopUp').data("kendoWindow").close();
		});

		$('.budgetHeaderInput').on('keydown', function(key){
			 if (key.keyCode == 13) {
				 $("#budgetList").data('kendoGrid').dataSource.read();
	         }
		});
	}
	
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
	   	    	data.purcReqType = $("#txtPurcReqType").val();
// 	   	    	data.deptCd = $("#txtDeptCd").val();
	   	    	data.userSeq = $("#userSeq").val();
	   	    	data.contTitle = $("#txtContTitle").val();
	   	    	data.contAm = $("#txtContAm").val().replace(/,/gi,"");
	   	    	data.trNm = $("#txtTrNm").val();
	   	    	data.mgtCd = $("#topSearchProject").attr("code");
	   	    	data.abgtCd = $("#topSearchBudget1").attr("code");
	   	    	if($("#mng").val() == "V"){
		   	    	data.smallYn = $("#txtSmallYn").prop("checked") ? "" : "N";
	   	    	}
	   	    	if($("#mng").val() == "Y"){
		   	    	data.deptCd = $("#txtDeptCd").val();
	   	    		if($("#ac").val() != "Y"){
		   	    		data.smallYn = 'N';
		   	    		data.contMod = "contMod";
	   	    		}
	   	    	}
	   	    	//data.contStep = '004';
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
			height : 500,
			sortable : true,
			pageable : {
				refresh : true,
				pageSizes : [10,20,30,50,100],
				buttonCount : 5
			},
			excel: {
	            fileName: "계약체결현황.xlsx",
				allPages: true
	        },
			persistSelection : true,
			columns : [
						{
							field : "contStepNm",
							title : "단계",
						},
						{field : "purcReqType",
							  title : "구분",
						},{
							field : "contType",
							title : "계약방법",
							template : function(data){
								if(data.evalType === '150'){
									return '수의(전자시담)';
								}else{
									return data.contType;
								}
							},
						},{
							field : "requesterDeptName",
							title : "요청부서",
						},{
							field : "requesterEmpName",
							title : "요청자",
						},{
							field : "requesterPosition",
							title : "직급",
						},{
							field : "requesterDuty",
							title : "직책",
						},{
							field : "contDocNo",
							title : "계약보고 문서번호",
							template : function(data){
								var contDocNo = data.contDocNo || "결재중";
								return "<a style='color: rgb(0, 51, 255);' href='javascript:fnDocPopOpen(\""+data.purcContId+"\",\""+data.contDikey+"\");'>"+contDocNo+"</a>";
							}
						},{
							field : "contTitle",
							title : "계약명",
							template : function(data){
								var purcContId = data.purcContId
								if(data.purcContId2){
									purcContId = data.purcContId2;
								}
								return "<a style='color: rgb(0, 51, 255);' href='javascript:fnPurcContViewPop(\""+data.purcReqId+"\",\""+data.purcReqTypeCodeId+"\",\""+data.cTikeycode+"\",\""+purcContId+"\");'>"+data.contTitle+"</a>";
							}
						},{
							field : "purcReqDateTxt",
							title : "계약기간",
						},{
							field : "trNm",
							title : "거래처",
							template : function(data){
								var trNm = data.trNm;
								if(data.trNm2){
									trNm = data.trNm2;
								}
								return trNm;
							}
						},{
							field : "contAm",
							title : "계약금액",
							template : function(data){
								var contAm = data.contAm;
								if(data.contAm2){
									contAm = data.contAm2;
								}
								return (contAm + "").toMoney();
							}
						},{
							field : "",
							title : "검수율",
							template : function(data){
								var inspAm = data.inspAm;
								var contAm = data.contAm.toString().toMoney2();
								if(data.smallYn != "Y"){
									if(data.contStep == "004" || data.contStep == "005" || data.contStep == "006" || data.contStep == "007"){
										if(inspAm){
// 											return '<a style="color: rgb(0, 51, 255);" href="javascript:fnPurcInspList(\''+data.purcContId+'\',\''+data.contTypeCodeId+'\');">' + (inspAm / contAm * 100) + '%</a>';
											return '<a style="color: rgb(0, 51, 255);" href="javascript:fnPurcInspList(\''+data.purcContId+'\',\''+data.contTypeCodeId+'\');">100%</a>';
										}else{
											return '<div class="controll_btn p0 ac"><button type="button" id="" onclick="fnPurcInspList(\''+data.purcContId+'\',\''+data.contTypeCodeId+'\');">검수</button></div>';
										}
									}
								}
								return "";
							}
						},{
							field : "",
							title : "대금지급액",
							template : function(data){
								var purcContId = data.purcContId
								if(data.purcContId2){
									purcContId = data.purcContId2;
								}
								var payAm = data.payAm;
								var button = '<div class="controll_btn p0 ac">';
								if(data.smallYn == "Y"){
									button += '<button type="button" id="" onclick="fnPurcPayList(\''+purcContId+'\');">대금지급</button>';
								}else{
									if(data.contStep == "004" || data.contStep == "005" || data.contStep == "006" || data.contStep == "007"){
										button += '<button type="button" id="" onclick="fnPurcPayList(\''+purcContId+'\');">대금지급</button>';
									}
								}
								button += '</div>';
								if(payAm){
									return '<a style="color: rgb(0, 51, 255);" href="javascript:fnPurcPayList(\''+purcContId+'\');">' + payAm.toString().toMoney() + "</a>";
								}
								return button;
							},
						},{
							field : "",
							title : "",
							template : function(data){
								var button = "";
								if(data.contStep == "004" || data.contStep == "005" || data.contStep == "006"){
									if(data.reqState == "006" || data.reqState == "007" || data.reqState == "008" || data.reqState == "009"){
										if($('#mng').val() == 'Y'){
											button += '<div class="controll_btn p0 ac"><button type="button" id="" onclick="fnContModList(\''+data.purcContId+'\');">변경계약</button></div>';
										}else{
											button += '<div class="controll_btn p0 ac"><button type="button" id="" onclick="fnContModList(\''+data.purcContId+'\');">변경계약요청</button></div>';
										}
									}
								}
								return button;
							},
						}
						],
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
	 
	function fnDocPopOpen(purcContId, docId){
		var params = {};
	    params.loginId = $('#loginId').val();
	    params.approKey = "tpfContRep" + purcContId;
	    params.docId = docId;
	    params.mod = 'V';
	    outProcessLogOn(params);
	}
	function fnDocPopOpen2(docId){
		var params = {};
	    params.compSeq =$('#compSeq').val();
	    params.empSeq = $('#empSeq').val();
	    params.docId = docId;
	    params.mod = 'V';
	    outProcessLogOn(params);
	}
	
	function fnPurcInspList(purcContId, contTypeCodeId){
// 		if(contTypeCodeId == "002" || contTypeCodeId == "2"){
// 			window.location = _g_contextPath_ + "/Ac/G20/Ex/purcContInspList2.do?purcContId="+purcContId+"&mng="+$("#mng").val();
// 		}else{
// 			window.location = _g_contextPath_ + "/Ac/G20/Ex/purcContInspList.do?purcContId="+purcContId+"&mng="+$("#mng").val();
// 		}
		window.location = _g_contextPath_ + "/Ac/G20/Ex/purcContInspList2.do?purcContId="+purcContId+"&mng="+$("#mng").val();
	}
	
	function fnPurcPayList(purcContId){
		window.location = _g_contextPath_ + "/Ac/G20/Ex/purcContPayList.do?purcContId="+purcContId+"&mng="+$("#mng").val();
	}
	
	function fnContModList(purcContId){
		window.location = _g_contextPath_ + "/Ac/G20/Ex/purcContModList.do?purcContId="+purcContId+"&mng="+$("#mng").val();
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
	
	function getBudget(id){
		popupId = id;
		$('#budgetPopUp').data("kendoWindow").open().center();
		$("#budgetList").data('kendoGrid').dataSource.read();
	}
	
	function getProject(id){
		popupId = id;
		$('#projectPopUp').data("kendoWindow").open().center();
		$("#projectList").data('kendoGrid').dataSource.read();
	}
	
	function excelDown(){
		$("#grid").getKendoGrid().saveAsExcel();
	}
	
	function projectListReLoad() {
		$('#projectList').data('kendoGrid').dataSource.page(1);
		setTimeout(function(){console.log($('#projectList').data("kendoGrid")._data);},1);
	}
</script>

<!-- iframe wrap -->
<div class="iframe_wrap" style="min-width: 1400px">
	<form id="outProcessFormData" action="http://211.192.144.104/gw/outProcessLogOn.do" target="outProcessLogOn"></form>
	<input type="hidden" id="compSeq" value="${loginVO.compSeq }"/>
	<input type="hidden" id="empSeq" value="${loginVO.uniqId }"/>
	<input type="hidden" id="loginId" value="${loginVO.id }"/>
	<input type="hidden" id="mng" value="${params.mng }"/>
	<input type="hidden" id="ac" value="${params.ac }"/>
	<input type="hidden" id="erpCoCd" value="${loginVO.erpCoCd }" />
	<!-- 컨텐츠타이틀영역 -->
	<div class="sub_title_wrap">

		<div class="title_div">
			<h4>근무계획</h4>
		</div>
	</div>

	<div class="sub_contents_wrap">

		<div class="top_box">
			<dl>
				<dt class="ar" style="width: 65px">계약기간</dt>
				<dd>
					<input type="text" value="" name="" id="txtFrDt" placeholder="" />
					&nbsp;~ 
					<input type="text" value="" name="" id="txtToDt" placeholder="" />
				</dd>
				<dt class="ar" style="width: 40px">구분</dt>
				<dd>
					<input id="txtPurcReqType" class="txtPurcReqType"/>
				</dd>
				<dt class="ar" style="width: 65px">요청부서</dt>
				<dd>
					<c:choose>
						<c:when test="${params.mng eq 'Y' }">
					<input id="selDept" />
					<input type="hidden" id="txtDeptName" value="" />
					<input type="hidden" id="txtDeptCd" value="" />
						</c:when>
						<c:when test="${params.mng eq 'V' }">
					<input id="selDept" />
					<input type="hidden" id="txtDeptName" value="" />
					<input type="hidden" id="txtDeptCd" value="" />
						</c:when>
						<c:otherwise>
					<input type="text" id="txtDeptName" disabled="disabled" value="${loginVO.orgnztNm }" />
					<input type="hidden" id="txtDeptCd" value="${loginVO.orgnztId }" />
						</c:otherwise>
					</c:choose>
				</dd>
				<dt class="ar" style="width: 50px">요청자</dt>
				<dd>
					<c:choose>
						<c:when test="${params.mng ne 'Y' and params.mng ne 'V' }">
					<input type="text" id="empName" disabled="disabled" value="${loginVO.name }" /> 
					<input type="hidden" id="userSeq" disabled="disabled" value="${loginVO.uniqId }" /> 
					<input type="hidden" id="deptName2" value="" /> 
					<input type="hidden" id="deptSeq" value="" />
						</c:when>
						<c:otherwise>
					<input type="text" id="empName" disabled="disabled" value="" /> 
					<input type="hidden" id="userSeq" disabled="disabled" value="" /> 
					<input type="hidden" id="deptName2" value="" /> 
					<input type="hidden" id="deptSeq" value="" />
						</c:otherwise>
					</c:choose>
				</dd>
				<dd>
					<input type="button" id="empPopUpBtn" value="검색" />
				</dd>
			</dl>
			<dl>
				<dt class="ar" style="width: 50px">계약명</dt>
				<dd>
					<input type="text" name="" id="txtContTitle" class="ri"/>
				</dd>
			<%-- <c:if test="${params.mng eq 'V' }"> --%>
				<dt class="ar" style="width: 50px">계약금</dt>
				<dd>
					<input type="text" value="0" name="" id="txtContAm" class="ri"/>
				</dd>
				<dt class="ar" style="width: 50px">거래처</dt>
				<dd>
					<input type="text" id="txtTrNm" class="txtTrNm"/>
				</dd>
				<c:if test="${params.mng eq 'V' }">
				<dt class="ar" style="width: 120px">소액계약포함여부</dt>
				<dd>
					<input type="checkbox" id="txtSmallYn" class="txtSmallYn" style="width: 15px;height: 20px;"/>
				</dd>
				</c:if>
				<dt class="ar" style="width: 65px;">프로젝트</dt>
				<dd>
					<input type="text" id="topSearchProject" ondblclick="getProject('topSearchProject');" readonly="readonly"/>
					<input type="button" id="" value="검색" onclick="getProject('topSearchProject');">
				</dd>
				<dt class="ar" style="width: 65px;">예산과목</dt>
				<dd>
					<input type="text" id="topSearchBudget1" ondblclick="getBudget('topSearchBudget1');" readonly="readonly"/>
					<input type="button" id="" value="검색" onclick="getBudget('topSearchBudget1');">
				</dd>
			<%-- </c:if> --%>
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
	
<div class="pop_wrap_dir" id="projectPopUp" style="width: 500px; display: none;">
	<div class="top_box" style="overflow: hidden;margin: 16px 16px 0px 16px;">
		<dl class="dl2">
			<dt class="mt2">구분</dt>
			<dd>
				<select id="selProjectStat">
					<option value="1,0">사용</option>
					<option value="">전체(미사용포함)</option>
					<option value="1">진행</option>
					<option value="0">완료</option>
				</select>
			</dd>
			<dt class="mt2">년도</dt>
			<dd>
				<input type="text" id="pjtFromDate" style="width: 70px;"/>
				<input type="text" id="pjtToDate" style="width: 70px;"/>
			</dd>
			<dd>
				<input type="button" id="pjt_Search_btn" value="조회">
			</dd>
		</dl>
	</div>
	<div class="pop_con">
		<div class="com_ta2">
			<div id="projectList"></div>
		</div>
	</div>
	<!-- //pop_con -->
</div>

<div class="pop_wrap_dir" id="budgetPopUp" style="width: 600px; display: none;">
	<div class="pop_con">
		<div class="com_ta2">
			<div id="budgetList"></div>
		</div>
	</div>
	<!-- //pop_con -->
</div>