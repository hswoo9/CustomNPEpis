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
dd {
	width: 11.5%;
} 
dd input { 
  	width : 80%;
}
.k-grid-toolbar {
	float : right;
}
#resolutionGrid { height: 100%; }

</style>
<body>

<script type="text/javascript">

var $accounting_unit;
var selectedPjtPop;
var $mainGridURL = _g_contextPath_ + "/budget/projectPreparationList";

var init = {
		eventListener : function() { // 이벤트 리스너
			
			$("#projectFromSearch, #projectToSearch").on("click", function() {
				
				if ($(this).attr("id") === "projectFromSearch") {
					 $('#projectName').val("");
					 $('#projectFrom').val('');
					 selectedPjtPop = "from";
				} else {
					$('#projectName').val("");
					 $('#projectTo').val('');
					 selectedPjtPop = "to";
				}
				
				 $("#projectPopup").data("kendoWindow").open();
				 projectGridReload();
			});
		
			$("#projectName").on("keyup", function(e){
				if (e.keyCode === 13) {
					projectGridReload();
				}
			});
			
			$('#projectPopupCancel').on('click', function() {
				projectPopupClose();
			});
		},
		
		gridEvent : function() {
			
			$("#standardMonth").kendoDatePicker({
			    depth: "year",
			    start: "year",
			    culture : "ko-KR",
				format : "yyyy-MM",
				value : new Date('${year}','${mm-1}'),
				dateInput: true
			});
			
			$("#accounting_unit").kendoDropDownList({
				dataTextField : 'DIV_NM' ,
				dataValueField : 'DIV_CD' ,
				dataSource : $accounting_unit
			});
			
			$("#projectPopup").kendoWindow({
			    width: "600px",
			   height: "750px",
			    visible: false,
			    actions: ["Close"]
			}).data("kendoWindow").center();
			
			$("#accounting_unit").data("kendoDropDownList").select(1); // 최초 화면 시 회계 단위 첫 번째 레코드 선택
		}
	}

var $dataSource = new kendo.data.DataSource({		//그리드데이터소스
	serverPaging : true,
	pageSize : 1000,
	transport : {
		read : {
			url : _g_contextPath_+ "/budget/initGrid",
			dataType : "json",
			type : "post"
		},
		parameterMap: function(data, operation) {
			data.MONTH 				= $("#standardMonth").val().replace(/\-/g, "");
      		data.DIV_CD 			= $("#accounting_unit").data("kendoDropDownList").value();
      		data.PJT_CD_FR 		= $("#projectFromCd").val();
      		data.PJT_CD_TO 		= $("#projectToCd").val();
      		data.FROM_MONTH 	= $("#standardMonth").val().replace(/\-/g, "").substring(0,4) + "01"
	     	return data;
	     }
	},
	schema : {
		data : function(response){
			console.log(response.list);
			return response.list;
		},
	    model : {
	    	fields : {

	    	}
	    }
	}
});

	$(function(){
		
		makeComboList();
		
		init.eventListener();
		init.gridEvent();
		
		mainGrid();
		projectGrid();
		
	});
	
	function excel() {
		
		var mainList = $('#grid').data('kendoGrid')._data;
		var templateName = 'projectPreparationTemplate';
		var title = '예실대비현황';
		
		mainList.forEach(function(e) {
			e.AMT4 = e.AMT1 - (Number(e.APPLY_AMT) + e.AMT2);
			e.AMT5 = ((e.AMT1 - (e.AMT1 - (Number(e.APPLY_AMT) + e.AMT2))) / e.AMT1 * 100).toFixed(2);
			e.AMT6 = e.AMT1 - e.AMT2;
			e.AMT7 = ((e.AMT1 - (e.AMT1 - e.AMT2)) / e.AMT1 * 100).toFixed(2);
			e.AMT8 = e.AMT1 - e.AMT3;
			e.AMT9 = ((e.AMT1 - (e.AMT1 - e.AMT3)) / e.AMT1 * 100).toFixed(2);
		})
		
		$.ajax({
	 		url: _g_contextPath_+"/budget/budgetExcel2",
	 		dataType : 'json',
	 		data : { param : JSON.stringify(mainList), templateName : templateName, title : title },
	 		type : 'POST',
	 		success: function(result){
	 			var downWin = window.open('','_self');
				downWin.location.href = _g_contextPath_+"/budget/excelDownLoad?fileName="+ escape(encodeURIComponent(result.fileName)) +'&fileFullPath='+escape(encodeURIComponent(result.fileFullPath));
	 		}
	 	});
	}
	
	function makeComboList(){
		$.ajax({
			url : _g_contextPath_+ "/budget/accountingComboList",
			data : {},
			async : false,
			type : "POST",
			success : function(result){				
				$accounting_unit = result.accountingUnitList;
			}
		});
		
		$.ajax({
			url : _g_contextPath_+ "/budget/resolutionDeptComboList",
			data : {
					
				},
			async : false,
			type : "POST",
			success : function(result){				
				$resolutionDept = result.resolutionDeptList;
			}
		});
	}
	
	function makeToDateMin(){
		
		if($("#from_period").val()>$("#to_period").val()){
			$("#from_period").data("kendoDatePicker").value(new Date());
			return;
		}
		
		$("#to_period").data("kendoDatePicker").setOptions({
		    min: $("#from_period").data("kendoDatePicker").value()
		});
	}
	
	function searchMainGrid() {
		$dataSource.transport.options.read.url = $mainGridURL;
		gridReload();
	}
	
	function mainGrid(){
		
		var grid =  $("#grid").kendoGrid({
			dataSource: $dataSource,
			height : 700,
			dataBound : dataBound,
			selectable : "row",
			sortable : true,
			persistSelection : true,
			columns : [
				{
					width : 14,
					field : "PJT_CD",
					title : "프로젝트 코드"
				},
				{
					width : 14,
					field : "PJT_NM2",
					title : "프로젝트 명"
				},
				{
					title : "예산과목",
					columns : [
						{
							width : 5,
							field : "BGT_CD",
							title : "코드"
						},
						{
							width : 10,
							field : "BGT_NM1",
							title : "관-항"
						},
						{
							width : 5,
							field : "BGT_NM2",
							title : "목-세목"
						}
					]
				},
				{
					template : function(e) {
						
						if(e.AMT1 == null || e.AMT1 == ""|| e.AMT1 == "0"){
							return '';
						}else{
							return fn_formatMoney(e.AMT1);
						}
					},
					width : 9,
					title : "예산금액"
				},
				{
					template : function(e) {
						
						if(e.APPLY_AMT == null || e.APPLY_AMT == ""|| e.APPLY_AMT == "0"){
							return '';
						}else{
							return fn_formatMoney(e.APPLY_AMT);
						}
					},
					width : 5,
					title : "품의금액"
				},
				{
					template : function(e) {
						
						if(e.AMT2 == null || e.AMT2 == ""|| e.AMT2 == "0"){
							return '';
						}else{
							return fn_formatMoney(e.AMT2);
						}
					},
					width : 9,
					title : "결의금액"
				},
				{
					template : function(e) {
						
						if(e.AMT3 == null || e.AMT3 == ""|| e.AMT3 == "0"){
							return '';
						}else{
							return fn_formatMoney(e.AMT3);
						}
					},
					width : 9,
					title : "전표금액"
				},
				{
					title : "품의기준잔액",
					columns : [
						{
							template : function(e) {
								if ((e.AMT1 - (Number(e.APPLY_AMT) + e.AMT2)) === 0) {
									return "";
								} else {
									return fn_formatMoney((e.AMT1 - (Number(e.APPLY_AMT) + e.AMT2)));									
								}
							},
							width : 8,
							title : "잔액"
						},
						{
							template : function(e) {
									return "<div class='progress' data-flag='1' style='width : 80px'></div>";
							},
							width : 6,
							title : "집행률 (%)"
						}
					]
				},
				{
					title : "결의기준잔액",
					columns : [
						{
							template : function(e) {
								if ((e.AMT1 - e.AMT2) === 0) {
									return "";
								} else {
									return fn_formatMoney((e.AMT1 - e.AMT2));									
								}
							},
							width : 8,
							title : "잔액"
						},
						{
							template : function(e) {
								return "<div class='progress' data-flag='2' style='width : 80px'></div>";
							},
							width : 6,
							title : "집행률 (%)"
						}
					]
				},
				{
					title : "전표기준잔액",
					columns : [
						{
							template : function(e) {
								if ((e.AMT1 - e.AMT3) === 0) {
									return "";
								} else {
									return fn_formatMoney((e.AMT1 - e.AMT3));
								}
							},
							width : 8,
							title : "잔액"
						},
						{
							template : function(e) {
								return "<div class='progress' data-flag='3' style='width : 80px'></div>";
							},
							width : 6,
							title : "집행률 (%)"
						}
					]
				},
				],
			change : selectRow
		}).data("kendoGrid");
		
		function selectRow(e){		//row클릭시 data 전역변수 처리
	
			row = e.sender.select();
			grid = $('#grid').data("kendoGrid");
			data = grid.dataItem(row);
			
			console.log(data);
			
			$rowData = data;
			
		}
		
		$gridFlag = true;
		$rowData = {};
	};
	
	function gridReload(){
		$gridIndex = 0;
		$('#grid').data('kendoGrid').dataSource.read();
		$rowData = {};
	}
	
	function dataBound(e){
		
		$gridIndex = 0;
		var grid = e.sender;
		
		if (grid.dataSource._data.length==0){
			var colCount = grid.columns.length + 4;
			$(e.sender.wrapper)
				.find('tbody')
				.append('<tr class="kendo-data-row">' + 
						'<td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
		}
		
		$(".progress").each(function(){
            var row = $(this).closest("tr");
            var model = grid.dataItem(row);
            var bgColor = '';
            var percent = "";
			
            /* progress bar */
            if (model.GB == '1') {
          	  bgColor = "#86E57F";
            } else if (model.GB == '2') {
          	  bgColor = "#5CD1E5";
            } else if (model.GB == '3') {
          	  bgColor = "#14899D";
            } else {
          	  bgColor = "#8041D9";
            } 
            
            /* 소계 및 합계 색 반전 */
            if (model.BGT_NM1.length === 0 ) {
            	row.css("font-weight", "bold");
            	row.css("color", "blue");
            	
            	row.children("td").each(function(i, f) {
            		$(this).css("border-bottom", "0.5px solid black");
            	});
            }
            
            $(this).kendoProgressBar({
            	type : "percent",
            	change: function(e) {
                    this.progressWrapper.css({
                      "background-color": bgColor,
                      "border-color": bgColor
                    });
                  },
              max: 100,
              width : 80
            });
            
            if ($(this).data("flag") === 1) {
            	percent = ((model.AMT1 - (model.AMT1 - (Number(model.APPLY_AMT) + model.AMT2))) / model.AMT1 * 100).toFixed(2);           	
            } else if ($(this).data("flag") === 2) {
            	percent = ((model.AMT1 - (model.AMT1 - model.AMT2)) / model.AMT1 * 100).toFixed(2);
            } else {
            	percent = ((model.AMT1 - (model.AMT1 - model.AMT3)) / model.AMT1 * 100).toFixed(2);
            }
            
            $(this).data("kendoProgressBar").value(percent);
          });
		
		  $(".k-progress-status").css("color", "black");
	};
	
	function projectGrid() {
		
		var grid = $("#projectGrid").kendoGrid({
	        dataSource: new kendo.data.DataSource({
	    	    transport: { 
	    	        read:  {
	    	            url: _g_contextPath_+'/budget/projectList',
	    	            dataType: "json",
	    	            type: 'post'
	    	        },
	    	      	parameterMap: function(data, operation) {
   	      				data.fiscal_year = $("#standardMonth").val().substring(0, 4);
	    	      		data.project 		= $("#projectName").val();
	    	     		return data;
	    	     	}
	    	    },
	    	    schema: {
	    	      data: function(response) {
	    	        return response.list;
	    	      },
	    	      total: function(response) {
	    	        return response.total;
	    	      }
	    	    }
	    	}),
	        height: 500,	        
	        sortable: true,
	        persistSelection: true,
	        selectable: "multiple",
	        columns:[{
	        					title : "프로젝트 코드",
	        					field : "PJT_CD",
	        					width : 30
	        				},
	        				{
	        					title : "프로젝트 명",
	        					field : "PJT_NM",
	        					width : 30
	        				},
	        				{
	        					title : "선택",
	        					width : 15,
						    	template : '<input type="button" id="" class="text_blue" onclick="projectSelect(this);" value="선택">'
        		    	    }]
	    }).data("kendoGrid");
	}
	
	//선택 클릭이벤트
	function projectSelect(e){		
		var row = $("#projectGrid").data("kendoGrid").dataItem($(e).closest("tr"));
		
		if (selectedPjtPop === "from") {
			$("#projectFrom").val(row.PJT_NM);
			$("#projectFromCd").val(row.PJT_CD);
		} else {
			$("#projectTo").val(row.PJT_NM);
			$("#projectToCd").val(row.PJT_CD);
		}
		
		$("#projectPopup").data("kendoWindow").close();
	}
	
	function projectPopupClose(){
		 $("#projectPopup").data("kendoWindow").close();
	}
	
	function projectGridReload() {
		$("#projectGrid").data("kendoGrid").dataSource.read();
	}
	
	function fn_formatDate(str){
		return str.substring(0,4) + "-" + str.substring(4,6) + "-" + str.substring(6,8) ;
	}

	function fn_formatMoney(str){
	        str = String(str);
	        return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
	}
	
</script>
<div class="iframe_wrap">
	<div class="sub_title_wrap">
		<div class="title_div">
			<h4>거래처원장</h4>
		</div>
	</div>
	
	<div class="sub_contents_wrap">
		<div class="com_ta">
			<div class="top_box gray_box" id = "dataBox">
				<dl>
					<dt style="width:6%">기준년월</dt>
					<dd style="width:8%">
						<input type="text" style="width:100%" id="standardMonth" name="period" value="" >
					</dd>
					<dt style="width:6%; ">회계단위</dt>
					<dd style="width:15%">
						<input type="text" style="width:100%" id ="accounting_unit"/>
					</dd>
					<dt style="width:7%">프로젝트</dt>
					<dd style="width:35%">
						<input type="text" style="width:40%" id ="projectFrom" disabled/>
						<input type="hidden" id ="projectFromCd"/>
						<button type="button" id ="projectFromSearch" value="검색">
						<img style="position:inherit;" src="<c:url value='/Images/btn/search_icon2.png'/>"></button>
							&nbsp;~&nbsp;
						<input type="text" style="width:40%" id ="projectTo" disabled/>
						<input type="hidden" id ="projectToCd"/>
						<button type="button" id ="projectToSearch" value="검색">
						<img style="position:inherit;" src="<c:url value='/Images/btn/search_icon2.png'/>"></button>
					</dd>
				</dl>
			</div>
		</div>
				
		<div class="btn_div mt10 cl">
			<div class="right_div">
				<div class="controll_btn p0">
					<button type="button" id="" onclick = "excel()">엑셀</button>
					<button type="button" id="" onclick = "searchMainGrid()">조회</button>
				</div>
			</div>
		</div>
		
		<div class="com_ta2">
			<div  id = "grid">
			</div>
		</div>
	</div>
</div>

<!-- 프로젝트검색팝업 -->
<div class="pop_wrap_dir" id="projectPopup" style="width:600px;">
	<div class="pop_head">
		<h1>프로젝트 선택</h1>
	</div>
	<div class="pop_con">
		<div class="top_box">
			<dl>
				<dt class="ar" style="width: 80px;">프로젝트 명</dt>
				<dd style="margin-right : 70px;">
					<input type="text" id="projectName" style="width: 120px" />
				</dd>
				<dd>
					<input type="button" onclick="projectGridReload();" id="searchButton"	value="검색" />
				</dd>
			</dl>
		</div>
		<div class="com_ta mt15" style="height: 500px;">
			<div id="projectGrid"></div>
		</div>			
	</div>

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" class="gray_btn" id="projectPopupCancel" value="닫기" />
		</div>
	</div>
</div>	
<!-- 프로젝트검색팝업 -->

</body>

