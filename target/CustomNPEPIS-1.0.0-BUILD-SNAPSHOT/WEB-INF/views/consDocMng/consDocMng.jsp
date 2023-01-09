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
<script type="text/javascript" src='<c:url value="/js/consDocMng/consDocMng.js"></c:url>'></script>

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
	var url = _g_contextPath_ + '/consDocMng/selectConsDocMngList';
	
	$(document).ready(function() {
		init();
		eventHandlerMapping();
		mainGrid();
		var grid = $('#grid').data('kendoGrid');
	});
	
	function init(){
		consDocMng.init();
		datePickerInit();
		fnDeptComboBoxInit();
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
	}
	
	function eventHandlerMapping(){
		$('#txtTitle, #txtDocNum').on({
			keyup: function(e){
				if(e.keyCode === 13){
					searchBtn();
				}
			}
		});
		
		$('#pjt_Search_btn').on({
			click: function(){
				projectListReLoad();
			}
		});
	}
	
	function datePickerInit(){
		var toDay = moment();
		var year = toDay.year();
		var month = toDay.month() + 1;
		var date = toDay.date();
// 		$("#txtFrDt").val(year + '-' + month + '-01');
		$("#txtFrDt").val(year + '-' + 1 + '-01');
		$("#txtToDt").val(year + '-' + month + '-' + date);
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
	
	/**
	 * 콤보박스 초기화
	 */
	function fnDeptComboBoxInit(){
		if($('#mng').val() === 'Y'){
			if($('#schDeptSeq')){
				var deptList = fnGetDeptList();
				deptList.unshift({dept_name : "전체", dept_seq : ""});
				var itemType = $("#schDeptSeq").kendoComboBox({
					dataSource : deptList,
					dataTextField: "dept_name",
					dataValueField: "dept_seq",
					index: 0,
			    });
			}
		}else{
			$('.mngY').hide();
		}
	}
	
	function fnGetDeptList(){
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
	
	var dataSource = new kendo.data.DataSource({
		serverPaging: true,
		pageSize: 15,
		transport: {
			read: {
				type: 'post',
				dataType: 'json',
				url: url
			},
			parameterMap: function(data, operation) {
	   	    	data.frDt = $("#txtFrDt").val().replace(/-/gi,"");
	   	    	data.toDt = $("#txtToDt").val().replace(/-/gi,"");
	   	    	data.docTitle = $("#txtTitle").val();
	   	    	data.docNo = $("#txtDocNum").val();
	   	    	data.schDeptSeq = $("#schDeptSeq").val();
	   	    	data.mgtSeq = $("#topSearchProject").attr('code');
	   	    	data.mng = $("#mng").val();
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
			sortable : true,
			height : '620px',
			pageable : {
				refresh : true,
				pageSizes : [15,30,50,100],
				buttonCount : 5
			},
			persistSelection : true,
			columns : [
						{ 
							template: function(data){
								return "<input type='checkbox' id='check' class='checkbox' purcReqId='"+data.purcReqId+"' reqState='"+data.reqState+"'/>";
							}
							,width:50,
						},{
							field : "docNo",
							title : "문서번호",
							template : function(data){
								docNo = "<a href='javascript:fnDocViewPop("+data.docSeq+");' style='color: rgb(0, 51, 255);'>"+data.docNo+"</a>";
								return docNo;
							},
							width : 150,
						},{
							field : "tiname",
							title : "문서종류",
							width : 150,
						},{
							field : "docTitle",
							title : "제목",
						},{
							field : "docDate",
							title : "기안일자",
							template : function(data){
								return data.docDate.toDate();
							},
							width : 100,
						},{
							field : "consDocAmt",
							title : "품의금액",
							template : function(data){
								return data.consDocAmt.toString().toMoney();
							},
							width : 150,
						},{
							field : "resDocAmt",
							title : "지출금액",
							template : function(data){
								return data.resDocAmt.toString().toMoney();
							},
							width : 150,
						},{
							field : "balanceAmt",
							title : "잔여금액",
							template : function(data){
								return data.balanceAmt.toString().toMoney();
							},
							width : 150,
						},{
							field : "",
							title : "",
							template: function(data){
								if(data.confferReturnYN === 'Y'){
									return '반환';
								}else{
									return '<div class="controll_btn p0" style="text-align:center;"><button type="button" id="" onclick="consDocMng.fnContractCheck(\'' + data.consDocSeq + '\');">변경</button></div>';
								}
							},
							width:80,
						}],
						change: function (e) {
				        	gridClick(e)
				        }
					}).data("kendoGrid");
	}
	
	// 전자결재 문서 팝업(뷰)
	function fnDocViewPop(docId){
		var params = {};
	    params.loginId = $('#loginId').val();
	    params.docId = docId;
	    params.mod = 'V';
	    outProcessLogOn(params);
	}
	
	// 예산내역 변경 저장
	function fnConsDocModify(){
		if(consDocMng.fnConsDocModify('Y')){
			$('#consDocSeq').val('');
			modBudgetList = new Array();
			consDocMng.consModSeq = '';
			$('#consDocModPopUp').data('kendoWindow').close();
			searchBtn();
		}
	}
	
	function getProject(id){
		popupId = id;
		$('#projectPopUp').data("kendoWindow").open().center();
		$("#projectList").data('kendoGrid').dataSource.read();
	}
	
	function popUpInit(){
		if($("#mng").val() == "Y"){
			projectPopUpInit();
		}else{
			projectPopUp2Init();
		}
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
	
	function projectListReLoad() {
		$('#projectList').data('kendoGrid').dataSource.page(1);
		setTimeout(function(){console.log($('#projectList').data("kendoGrid")._data);},1);
	}
</script>

<!-- iframe wrap -->
<div class="iframe_wrap" style="min-width: 1200px">
<form id="outProcessFormData" action="http://211.192.144.104/gw/outProcessLogOn.do" target="outProcessLogOn"></form>
<input type="hidden" id="mng" value="${params.mng }" />
<input type="hidden" id="loginId" value="${loginVO.id }" />
<input type="hidden" id="erpCoCd" value="${loginVO.erpCoCd }" />
	<!-- 컨텐츠타이틀영역 -->
	<div class="sub_title_wrap">

		<div class="title_div">
			<h4>품의내역 변경</h4>
		</div>
	</div>

	<div class="sub_contents_wrap">

		<div class="top_box">
			<dl>
				<dt class="ar" style="width: 65px">기안일자</dt>
				<dd>
					<input type="text" value="" name="" id="txtFrDt" placeholder="" />
					&nbsp;~ 
					<input type="text" value="" name="" id="txtToDt" placeholder="" />
				</dd>
				<dt class="ar" style="width: 40px">제목</dt>
				<dd>
					<input type="text" name="" id="txtTitle" class="ri"/>
				</dd>
				<dt class="ar" style="width: 65px">문서번호</dt>
				<dd>
					<input type="text" name="" id="txtDocNum" class="ri"/>
				</dd>
				<span>
				<dt class="ar" style="width: 65px">프로젝트</dt>
				<dd>
					<input type="text" id="topSearchProject" ondblclick="getProject('topSearchProject');" readonly="readonly"/>
					<input type="button" id="" value="검색" onclick="getProject('topSearchProject');">
				</dd>
				</span>
				<dt class="ar" style="width: 65px">부서</dt>
				<dd>
					<input type="text" name="" id="schDeptSeq" class="ri"/>
				</dd>
				</span>
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

	<!-- //sub_contents_wrap -->
<!-- iframe wrap -->
