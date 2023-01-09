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
dt {
	text-align : left;
	width : 10%;
}
dd{
	width: 11.5%;
} 
dd input{ 
  	width : 80%;
}
.k-grid-toolbar{
	float : right;
}

</style>
<body>

<script type="text/javascript">

var $accounting_unit_list;
var $projectList;
var $budgetList;
var $mokList;
var $mokTempList;
var $rowData = {};					//그리드한줄정보
var $gridIndex = 0;					//그리드인덱스번호
var $lease_id = "";							//임대계약id
var $gridFlag = false;

var $dataSource = new kendo.data.DataSource({		//그리드데이터소스
	serverPaging : true,
	pageSize : 1000,
	transport : {
		read : {
			url : _g_contextPath_+ "/budget/caseActList",
			dataType : "json",
			type : "post"
		},
		parameterMap: function(data, operation) {

			if($gridFlag){
				data.fiscal_year = $("#fiscal_year").val();
				data.totalCount = 1;
			}else{
				data.fiscal_year = ($("#fiscal_year").val())*1 +1;
				data.totalCount = 0;
			}
			
			data.accounting_unit = $("#accounting_unit").data("kendoDropDownList").value();
			data.from_project = $("#topSearchProject").attr("code");
			data.to_project = $("#topSearchProject").attr("code");
			data.from_budget_name = $("#from_budget_name").data("kendoComboBox").value();
			data.to_budget_name = $("#to_budget_name").data("kendoComboBox").value();
			data.from_mok_name = $("#from_mok_name").data("kendoComboBox").value();
			data.to_mok_name = $("#to_mok_name").data("kendoComboBox").value();
			data.from_standard_period = $("#from_standard_period").val().replace(/-/gi,"");
			data.to_standard_period = $("#to_standard_period").val().replace(/-/gi,"");
	     	return data;
	     }
	},
	schema : {
		data : function(response){
			return response.list;
		},
	    model : {
	    	fields : {

	    	}
	    }
	}
});

var $dataSource2 = new kendo.data.DataSource({		//그리드데이터소스
	serverPaging : true,
	pageSize : 1000,
	transport : {
		read : {
			url : _g_contextPath_+ "/budget/caseActDetailList2",
			dataType : "json",
			type : "post"
		},
		parameterMap: function(data, operation) {
			
			data.from_standard_period = $("#from_standard_period").val().replace(/-/gi,"");
			data.to_standard_period = $("#to_standard_period").val().replace(/-/gi,"");
			data.budget_am = $rowData.AMT1;
			
			if($rowData.DIV_CD!=undefined){
				data.div_cd = $rowData.DIV_CD;
				data.pjt_cd = $rowData.PJT_CD;
				data.bgt_cd = $rowData.BGT_CD;
			}else{
				data.div_cd = '';
				data.pjt_cd = '';
				data.bgt_cd = '';
			}
	     	return data;
	     }
	},
	schema : {
		data : function(response){
			return response.list;
		},
		total : function(response) {
	        return response.totalCount;
	    },
	    model : {
	    	fields : {

	    	}
	    }
	}
});

	$(function(){
		
		$("#fiscal_year").kendoDatePicker({
		    depth: "decade",
		    start: "decade",
		    culture : "ko-KR",
			format : "yyyy",
			value : new Date(),
			change : changeCombo
		});
		
		makeComboList();
		
		$("#accounting_unit").kendoDropDownList({
			dataTextField : 'DIV_NM' ,
			dataValueField : 'DIV_CD' ,
			dataSource : $accounting_unit_list
		});
		
		$("[name='project']").kendoComboBox({

			filter : 'contains',
			dataTextField : 'PJT_NM' ,
			dataValueField : 'PJT_CD' ,
			dataSource : $projectList,
			change : setDropDownList
		})
		
		$("[name='budget_name']").kendoComboBox({

			filter : 'contains',
			dataTextField : 'BGT_NM' ,
			dataValueField : 'BGT_CD' ,
			dataSource : $budgetList,
			change : changeMokCombo
		})
		
		$("[name='mok']").kendoComboBox({

			filter : 'contains',
			dataTextField : 'BGT_NM' ,
			dataValueField : 'BGT_CD' ,
			dataSource : $mokList
		})
		
		
		
		$("#from_standard_period").kendoDatePicker({
		    depth: "month",
		    start: "month",
		    culture : "ko-KR",
			format : "yyyy-MM-dd",
			value : new Date(${year},0,1),
			change : makeToDateMin
		});
		
		$("#to_standard_period").kendoDatePicker({
		    depth: "month",
		    start: "month",
		    min : $("#from_standard_period").data("kendoDatePicker").value(),
		    culture : "ko-KR",
			format : "yyyy-MM-dd",
			value : new Date()
		});
		
		mainGrid();
		mainGrid2();
		console.log('${userInfo}');
		
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
			
			setDropDownList();
			
		});
		
	});
	
	var projectDataSource = new kendo.data.DataSource({
		serverPaging: true,
		pageSize: 10,
	    transport: { 
	        read:  {
	            url:  "<c:url value='/Ac/G20/Code/getErpMgtList.do' />",
	            dataType: "json",
	            type: 'post'
	        },
	      	parameterMap: function(data, operation) {
	      		data.EMP_CD = '${userInfo.erpEmpCd}'
	      		data.FG_TY = "2";
	      		data.CO_CD = '${userInfo.erpCompSeq}';
	      		console.log("dkdkdk");
	      		return data;
	     	}
	    },
	    schema: {
	      data: function(response) {
				console.log(response.selectList);
	        	return response.selectList;
	      },
	      total: function(response) {
		        return response.totalCount;
		      }
	    }
	});
	
	function makeComboList(){
		
		var data = {
				fiscal_year : $("#fiscal_year").val(),
				project : $("#topSearchProject").attr("code")
		}
		
		
		$.ajax({
			url : _g_contextPath_+ "/budget/comboList",
			data : data,
			async : false,
			type : "POST",
			success : function(result){				
				$accounting_unit_list = result.accountingUnitList;
				$projectList = result.projectList;
				$budgetList = result.budgetList;
				$mokList = result.mokList;
			}
		});
	}
	
	function setDropDownList(){

		makeComboList();		
		$("#from_budget_name").data("kendoComboBox").setDataSource($budgetList);
		$("#to_budget_name").data("kendoComboBox").setDataSource($budgetList);
		$("#from_mok_name").data("kendoComboBox").setDataSource($mokList);
		$("#to_mok_name").data("kendoComboBox").setDataSource($mokList);
		
		$("#from_budget_name").data("kendoComboBox").value('');
		$("#to_budget_name").data("kendoComboBox").value('');
		$("#from_mok_name").data("kendoComboBox").value('');
		$("#to_mok_name").data("kendoComboBox").value('');
		
	}
	
	function changeCombo(){
		
		makeComboList();
		$("#from_budget_name").data("kendoComboBox").setDataSource($budgetList);
		$("#to_budget_name").data("kendoComboBox").setDataSource($budgetList);
		$("#from_mok_name").data("kendoComboBox").setDataSource($mokList);
		$("#to_mok_name").data("kendoComboBox").setDataSource($mokList);
		
		$("#from_budget_name").data("kendoComboBox").value('');
		$("#to_budget_name").data("kendoComboBox").value('');
		$("#from_mok_name").data("kendoComboBox").value('');
		$("#to_mok_name").data("kendoComboBox").value('');
	}
	
	function changeMokCombo(){
// 		this.input.context.id
		
	}
	
	function makeToDateMin(){
		
		if($("#from_standard_period").val()>$("#to_standard_period").val()){
			$("#from_standard_period").data("kendoDatePicker").value(new Date());
			return;
		}
		
		$("#to_standard_period").data("kendoDatePicker").setOptions({
		    min: $("#from_standard_period").data("kendoDatePicker").value()
		});
	}
	
	function mainGrid(){
		
		var width = $(".sub_contents_wrap").width();
		
		var grid =  $("#grid").kendoGrid({
			excel : {
				fileName : '원인행위부.xlsx'
			},
			autoBind: false,
			dataSource: $dataSource,
			height : 300,
			dataBound : dataBound,
			selectable : "row",
// 			sortable : true,
	//			pageable : {
	//				refresh : true,
	//				pageSizes : true,
	//				buttonCount : 5
	//			},
			persistSelection : true,
			columns : [
				{
					width : width*15/100,
					field : "DIV_NM",
					title : "회계단위"
				},
				{
					width : width*15/100,
					field : "PJT_NM",
					title : "프로젝트"
				},
				
				{
					width : width*15/100,
					field : "BGT_NM1",
					title : "예산"
				},
				{
					width : width*25/100,
					field : "BGT_NM2",
					title : "목"
				},
// 				{
// 					width : width*10/100,
// 					title : "예산액",
// 					field : "AMT1",
// 					template : function(e){
// 						if(e.AMT1 == null || e.AMT1 == ""){
// 							return '';
// 						}else{
// 							return e.AMT1.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
// 						}
						
// 					}
// 				},
// 				{
// 					width : width*10/100,
// 					title : "원인액",
// 					field : "AMT2",
// 					template : function(e){
// 						if(e.AMT2 == null || e.AMT2 == ""){
// 							return '';
// 						}else{
// 							return e.AMT2.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
// 						}
						
// 					}
// 				},
// 				{
// 					width : width*10/100,
// 					title : "잔액",
// 					field : "AMT3",
// 					template : function(e){
// 						if(e.AMT3 == null || e.AMT3 == ""){
// 							return '';
// 						}else{
// 							return e.AMT3.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
// 						}
						
// 					}
// 				}
				
			],
			change : selectRow
	
		}).data("kendoGrid");
		
		function selectRow(e){		//row클릭시 data 전역변수 처리
	
			row = e.sender.select();
			grid = $('#grid').data("kendoGrid");
			data = grid.dataItem(row);
			$rowData = data;
			gridReload2();
			
		}
		
		$gridFlag = true;
		$rowData = {};
	};
	
	function mainGrid2(){
		
		var width = $(".sub_contents_wrap").width();
		
		var grid =  $("#grid2").kendoGrid({
			excel : {
				fileName : '원인행위부상세.xlsx'
			},
			autoBind: false,
			dataSource: $dataSource2,
			height : 300,
			dataBound : dataBound,
// 			sortable : true,
			persistSelection : true,
			selectable : "row",
			columns : [
				
// 				{
// 					width : width*10/100,
// 					field : "ISU_DT",
// 					title : "수납(지출)일자"rrrrr
// 				},
				{
					width : width*10/100,
					field : "GISU_DT",
					title : "발의일자"
				},
				{
					width : width*10/100,
					field : "TYPE",
					title : "구분"
				},
				
				{
					width : width*30/100,
					field : "RMK_DC",
					title : "적요"
				},
				{
					width : width*11/100,
					title : "예산액",
					field : "BUDGET_AM",
					template : function(e){
						if(e.BUDGET_AM == null || e.BUDGET_AM == ""){
							return '';
						}else{
							return e.BUDGET_AM.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
						}
						
					}
				},
				{
					width : width*11/100,
					title : "원인액",
					field : "WON_AM",
					template : function(e){
						if(e.WON_AM == null || e.WON_AM == ""){
							return '';
						}else{
							return e.WON_AM.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
						}
						
					}
				},
				{
					width : width*11/100,
					title : "징수(지출)액",
					field : "UNIT_AM",
					template : function(e){
						if(e.UNIT_AM == null || e.UNIT_AM == ""){
							return '';
						}else{
							return e.UNIT_AM.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
						}
						
					}
				},
				{
					width : width*11/100,
					title : "잔액",
					field : "JAN_AM",
					template : function(e){
						if(e.JAN_AM == null || e.JAN_AM == ""){
							return '';
						}else{
							return e.JAN_AM.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
						}
						
					}
				},
// 				{
// 					width : width*8/100,
// 					title : "문서보기",
// 					template : function(e){
// 						if(e.DIV == 1){
// 							return '<input type="button" class="blue_btn" value="보기" onclick = "watchDoc('+e.GISU_SQ+','+e.GISU_DT2+')">';
// 						}else{
// 							return '';
// 						}
// 					}
// 				}
				
			],
			change : selectRow
	
		}).data("kendoGrid");
		
		function selectRow(e){		//row클릭시 data 전역변수 처리
	
			row = e.sender.select();
			grid = $('#grid2').data("kendoGrid");
			data = grid.dataItem(row);
			
		}
		
	};
	
	function watchDoc(gisu_sq, gisu_dt){

		$.ajax({
			url : _g_contextPath_+ "/budget/causeActDocSearch",
			data : {
				co_cd : '${userInfo.erpCompSeq}',
				gisu_dt : gisu_dt,
				gisu_sq : gisu_sq
			},
			async : false,
			type : "POST",
			success : function(result){				
				if(result[0].V_OUT_YN == 'N'){
					alert(result[0].V_OUT_MSG);
				}else{
					var dikeycode = result[0].V_OUT_C_DIKEYCODE;
				}
			}
		});
		
	}
	
	function gridReload(){
	
		$gridIndex = 0;
		$('#grid').data('kendoGrid').dataSource.read();
		$rowData = {};
		
	}
	
	function gridReload2(){
		
		$gridIndex = 0;
		$('#grid2').data('kendoGrid').dataSource.read();
		
	}
	
	function dataBound(e){
		
		$gridIndex = 0;
		var grid = e.sender;
		if(grid.dataSource._data.length==0){
			var colCount = grid.columns.length;
			$(e.sender.wrapper)
				.find('tbody')
				.append('<tr class="kendo-data-row">' + 
						'<td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
		}
	};

	function gridSearch(){
		if(!$("#topSearchProject").attr("code")){
			alert("프로젝트를 선택하세요.");
			return;
		}
		$("#grid").data('kendoGrid').dataSource.page(1);
	}
	
	//프로젝트 호출
	function getProject(id){
		popupId = id;
		$('#projectPopUp').data("kendoWindow").open().center();
		$("#projectList").data('kendoGrid').dataSource.read();
		
	}
	
	function gridExcelBtn(){
		if(!$("#topSearchProject").attr("code")){
			alert("프로젝트를 선택하세요.");
			return;
		}
		$("#grid").getKendoGrid().saveAsExcel();
		
	}
	
	function gridExcelBtn2(){
		if(!$rowData.PJT_CD){
			alert("예산을 선택하세요.");
			return;
		}
		$("#grid2").getKendoGrid().saveAsExcel();
		
	}

</script>
<div class="iframe_wrap">
	<div class="sub_title_wrap">
		<div class="title_div">
			<h4>원인행위부</h4>
		</div>
	</div>
	
	<div class="sub_contents_wrap">
	
		<div class="com_ta">
			<div class="top_box gray_box" id = "dataBox">
				<dl>
					<dt>회계년도</dt>
					<dd style="width:35%">
						<input type="text" style="width:40%" id = "fiscal_year" style = "" value=""/>
					</dd>
					<dt>프로젝트</dt>
					<dd style="width:33%">
						<input type="text" id="topSearchProject" ondblclick="getProject('topSearchProject');" style="width: 35%;" readonly="readonly">
						<a class="btn_search" onclick="getProject('topSearchProject');" style="margin-top: 1px;"></a>
					</dd>
				</dl>
				
				<dl class="next2">
					<dt>회계단위</dt>
					<dd style="width:35%">
						<input type="text" style="width:40%" id ="accounting_unit"/>
					</dd>
					<dt>예 산 명</dt>
					<dd style="width:33%">
						<input type="text" style="width:40%" id="from_budget_name" name="budget_name" value="" >
<!-- 						<button type="button" id = "" onclick="searchBudget(from)" value=""> -->
<%-- 						<img style="position:inherit;" src="<c:url value='/Images/btn/search_icon2.png'/>"></button> --%>
						&nbsp;~&nbsp;
						<input type="text" style="width:40%" id="to_budget_name" name="budget_name" value="" >
<!-- 						<button type="button" id = "" onclick="searchBudget(to)" value=""> -->
<%-- 						<img style="position:inherit;" src="<c:url value='/Images/btn/search_icon2.png'/>"></button> --%>
						
					</dd>
				</dl>
				<dl class="next2">
					
					<dt>기준기간</dt>
					<dd style="width:35%">
						<input type="text" style="width:40%" id="from_standard_period" value="" >
						&nbsp;~&nbsp;
						<input type="text" style="width:40%" id="to_standard_period" value="" >
					</dd>

					<dt>목 명</dt>
					<dd style="width:33%">
						<input type="text" style="width:40%" id="from_mok_name" name="mok" value="" >
<!-- 						<button type="button" id = "" onclick="searchMok(from)" value=""> -->
<%-- 						<img style="position:inherit;" src="<c:url value='/Images/btn/search_icon2.png'/>"></button> --%>
						&nbsp;~&nbsp;
						<input type="text" style="width:40%" id="to_mok_name" name="mok" value="" >
<!-- 						<button type="button" id = "" onclick="searchMok(to)" value=""> -->
<%-- 						<img style="position:inherit;" src="<c:url value='/Images/btn/search_icon2.png'/>"></button> --%>
						
					</dd>
				</dl>
			</div>
		</div>
				
		<div class="btn_div mt10 cl">
			<div class="left_div">
				<p class="tit_p mt5 mb0">※ 클릭하면 하단에서 상세 집행 내용이 조회됩니다.</p>
			</div>
			<div class="right_div">
				<div class="controll_btn p0">
					<button type="button" id="" onclick = "gridSearch()">조회</button>
					<button type="button" onclick="gridExcelBtn();">엑셀</button>
				</div>
			</div>
		</div>
		
		<div class="com_ta2">
			<div  id = "grid">
			</div>
		</div>
		
		<div class="btn_div mt10 cl">
			<div class="left_div">
				<p class="tit_p mt5 mb0">상세 집행 내용</p>
			</div>
			<div class="right_div">
				<div class="controll_btn p0">
					<button type="button" onclick="gridExcelBtn2();">엑셀</button>
				</div>
			</div>
		</div>
		
		<div class="com_ta2">
			<div  id = "grid2">
			</div>
		</div>
		
	</div>
</div>


<div class="pop_wrap_dir" id="projectPopUp" style="width: 500px; display: none;">
	<div class="pop_con">
		<div class="com_ta2">
			<div id="projectList"></div>
		</div>
	</div>
	<!-- //pop_con -->
</div>

</body>

