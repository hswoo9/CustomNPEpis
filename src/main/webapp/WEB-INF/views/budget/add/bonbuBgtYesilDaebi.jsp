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
<script type="text/javascript" src="<c:url value='/js/budget/budgetUtil.js' />"></script>
<style>
	.green_btn {background:#0e7806 !important; height:24px; padding:0 11px; color:#fff !important;border:none; font-weight:bold; border:0px !important;}
	.k-grid-header th.k-header { white-space : normal !important; }
</style>
<script type="text/javascript">
var bgtParentData = '';
var $deptComboData = '';
var selectedPjtPop;
var viewFlag = 0; // 0 : 팝업호출, 1 : 화면직접호출
var $mainGridURL = _g_contextPath_ + "/budget/getBgtYeasilDaebi";

	$(function() {
		Init.ajax();
		if (!window.opener) {
			viewFlag = 1;	
		} else {
			bgtParentData = JSON.parse(window.opener.$bgtParentData);
			$('#pjtFrom, #pjtTo').val(bgtParentData.PJT_NM);
			$('#pjtFromCd, #pjtToCd').val(bgtParentData.PJT_CD);
		}
		
		Init.kendoFunction();
		Init.kendoGrid();
		Init.eventListener();
	})
	
	var Init = {
			ajax : function() {
				$.ajax({
					url : _g_contextPath_+ "/budget/searchDeptList6",
					data : { deptName : '', year : $('#standardDate').val() === '' ? moment().format('YYYY') : $('#standardDate').val().substring(0, 4) },
					async : false,
					type : "POST",
					success : function(result){				
						$deptComboData = result.list;
					}
				});
			},
			kendoFunction : function() {
				$("#standardDate").kendoDatePicker({
				    depth: "month",
				    start: "month",
				    culture : "ko-KR",
					format : "yyyy-MM-dd",
					value : viewFlag === 0 ? ( bgtParentData.BASE_MONTH.substring(0, 4) + "-"+ bgtParentData.BASE_MONTH.substring(4, 6) + "-" + bgtParentData.BASE_MONTH.substring(6) )
														: moment().format('YYYY') + "-" + moment().format('MM') + "-" + moment().format('DD'),
					change : changeStandardDate
				});
				
				if (viewFlag === 1) {
					$deptComboData.unshift({ DEPT_NM : '선택', DEPT_CD : 999 });
				}
				
				$("#dept").kendoComboBox({
					dataSource: $deptComboData,
				      dataTextField: "DEPT_NM",
				      dataValueField: "DEPT_CD",
				      value : viewFlag === 0 ? bgtParentData.DEPT_CD : $deptComboData[0].DEPT_CD
				});
				
				$("#projectPopup").kendoWindow({
				    width: "600px",
				   height: "650px",
				    visible: false,
				    actions: ["Close"]
				}).data("kendoWindow").center();
			},
			
			kendoGrid : function() {
				/* 메인 그리드 */
				var mainGrid = $("#mainGrid").kendoGrid({
					dataSource : new kendo.data.DataSource({
						serverPaging : true,
						pageSize : 10,
						transport : {
							read : {
								url : viewFlag === 0 ? _g_contextPath_+"/budget/getBgtYeasilDaebi" : _g_contextPath_+"/budget/initGrid",
								dataType : "json",
								type : 'post'
							},
							parameterMap: function(data, operation) {
		   	      				data.deptSeq = $("#dept").data('kendoComboBox').value();
		   	      				data.month = $('#standardDate').val().replace(/-/gi, '');
		   	      				data.pjtFrom = $('#pjtFromCd').val();
		   	      				data.pjtTo = $('#pjtToCd').val();
			    	     		return data;
			    	     	}
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
// 									AMT1 : { type : 'number' } 
								}
							}
						}
					}),
					dataBound : mainGridDataBound,
					height : 650,
					sortable : true,
					persistSelection : true,
					selectable : "multiple",
			        columns: [
						{
							field : "DEPT_NM",
							title : "부서",
							width : 40
						},
						{
							field : "PJT_CD",
							title : "프로젝트 코드",
							width : 40
						},
						{
							field : "PJT_NM2",
							title : "프로젝트명",
							width : 40
						},
						{
							title : '예산과목',
							columns : [
								 {
									field : 'BGT_CD',
									title : '코드',
									width : 40
								 },
								 {
									field : 'HBGT_NM',
									title : '관-항',
									width : 40
								 },
								 {
									field : 'BGT_NM',
									title : '목-세목',
									width : 40
								 }
							]
						},
						{
							template : function(data) {
								return Budget.fn_formatMoney(data.AMT1);
							},
							title : "예산금액",
							width : 60
						},
						{
							template : function(data) {
								return Budget.fn_formatMoney(data.AMT2);
							},
							title : "결의금액",
							width : 60
						},
						{
							template : function(data) {
								return Budget.fn_formatMoney(data.AMT3);
							},
							title : "전표금액",
							width : 60
						},
						{
							title : '결의기준',
							columns : [
								{
									template : function(data) {
										return Budget.fn_formatMoney(data.AMT4);
									},
									title : '잔액',
									width : 40
								},
								{
									template : function(data) {
										return "<div class='progress' data-flag='1' style='width : 80px'></div>";
									},
									title : '집행률(%)',
									width : 40
								}
							]
						},
						{
							title : '전표기준',
							columns : [
								{
									template : function(data) {
										return Budget.fn_formatMoney(data.AMT6);
									},
									title : '잔액',
									width : 40
								},
								{
									template : function(data) {
										return "<div class='progress' data-flag='2' style='width : 80px'></div>";
									},
									title : '집행률(%)',
									width : 40
								}
							]
						}]
			    }).data("kendoGrid");
				/* 하단 그리드 */
				
				/* 프로젝트 팝업 그리드 */
				var projectGrid = $("#projectGrid").kendoGrid({
			        dataSource: new kendo.data.DataSource({
			    	    transport: { 
			    	        read:  {
			    	            url: _g_contextPath_+'/budget/projectList3',
			    	            dataType: "json",
			    	            type: 'post'
			    	        },
			    	      	parameterMap: function(data, operation) {
		   	      				data.fiscal_year = $("#standardDate").val().substring(0, 4);
			    	      		data.project 		= $("#projectName").val();
			    	      		data.deptCd = $("#dept").data('kendoComboBox').value();
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
				/* 프로젝트 팝업 그리드 */
			},
			eventListener : function() {
				$("#pjtFromSearch, #pjtToSearch").on("click", function() {
					
					if ($(this).attr("id") === "pjtFromSearch") {
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
			}
	}
	
	function changeStandardDate(e) {
		$.ajax({
			url : _g_contextPath_+ "/budget/searchDeptList6",
			data : { deptName : '', year : $('#standardDate').val().substring(0, 4) },
			async : false,
			type : "POST",
			success : function(result){				
				$deptComboData = result.list;
			}
		});
		
		if (viewFlag === 1) {
			$deptComboData.unshift({ DEPT_NM : '선택', DEPT_CD : 999 });
		}
		
		$("#dept").kendoComboBox({
			dataSource: $deptComboData,
		      dataTextField: "DEPT_NM",
		      dataValueField: "DEPT_CD",
		      value : viewFlag === 0 ? projectParentData.DEPT_CD : $deptComboData[0].DEPT_CD 
		});
	}
	
	function projectSelect(e){		
		var row = $("#projectGrid").data("kendoGrid").dataItem($(e).closest("tr"));
		
		if (selectedPjtPop === "from") {
			$("#pjtFrom").val(row.PJT_NM);
			$("#pjtFromCd").val(row.PJT_CD);
		} else {
			$("#pjtTo").val(row.PJT_NM);
			$("#pjtToCd").val(row.PJT_CD);
		}
		
		$("#projectPopup").data("kendoWindow").close();
	}
	
	function projectPopupClose(){
		 $("#projectPopup").data("kendoWindow").close();
	}
	
	function projectGridReload() {
		$("#projectGrid").data("kendoGrid").dataSource.read();
	}
	
	function mainGridDataBound(e) {
		var grid = e.sender;

		if (grid.dataSource.total() == 0) {
			var colCount = grid.columns.length + 3;
			$(e.sender.wrapper).find('tbody').append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
		}
		
		$(".progress").each(function(){
            var row = $(this).closest("tr");
            var model = grid.dataItem(row);
            var bgColor = '';
            var percent = "";
			
            /* progress bar color */
       	    bgColor = "#86E57F";
            
       	 	/* 소계 및 합계 색 반전 */
            if (model.BGT_CD === '') {
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
            	percent = model.AMT5;           	
            } else if ($(this).data("flag") === 2) {
            	percent = model.AMT7;
            } 
            
            $(this).data("kendoProgressBar").value(percent);
          });
		
		  $(".k-progress-status").css("color", "black");
	}
	
	function searchMainGrid() {
		$('#mainGrid').data('kendoGrid').dataSource.transport.options.read.url = $mainGridURL;
		$('#mainGrid').data('kendoGrid').dataSource.read(0);
	}
	
function excel() {
		
		var mainList = $('#mainGrid').data('kendoGrid')._data;
		var templateName = 'bonbuBgtYesilDaebiTemplate';
		var title = '부서 예산과목별 예실 대비 현황';
		
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
	
</script>
<body>
<div class="iframe_wrap">
	<div class="sub_title_wrap" style='height: 15px;'>
		<div class="title_div">
		</div>
	</div>
	
	<div class="sub_contents_wrap">
		<div class="com_ta">
			<div class="top_box gray_box" id = "dataBox">
				<dl>
					<dt>기준일자</dt>
					<dd style="width:13%">
						<input type="text" style="" id = "standardDate" style = "" value=""/>
					</dd>
					<dt>부서</dt>
					<dd style="width:13%">
						<input type="text" style="" id = "dept" style = "" value=""/>
					</dd>
					<dt style="width:7%">프로젝트</dt>
					<dd style="width:35%">
						<input type="text" style="width:40%" id ="pjtFrom" disabled/>
						<input type="hidden" id ="pjtFromCd"/>
						<button type="button" id ="pjtFromSearch" value="검색">
						<img style="position:inherit;" src="<c:url value='/Images/btn/search_icon2.png'/>"></button>
							&nbsp;~&nbsp;
						<input type="text" style="width:40%" id ="pjtTo" disabled/>
						<input type="hidden" id ="pjtToCd"/>
						<button type="button" id ="pjtToSearch" value="검색">
						<img style="position:inherit;" src="<c:url value='/Images/btn/search_icon2.png'/>"></button>
					</dd>
				</dl>
			</div>
		</div>
				
		<div class="btn_div mt10 cl">
			<div class="left_div">
				<!-- <p class="tit_p mt5 mb0">※ 클릭하면 하단에서 상세 집행 내용이 조회됩니다.</p> -->
			</div>
			<div class="right_div">
				<div class="controll_btn p0">
					<button type="button" id="" onclick = "excel()">엑셀</button>
					<button type="button" id="" onclick = "searchMainGrid()">조회</button>
				</div>
			</div>
		</div>
		
		<div class="com_ta2" style="height: 650px;">
			<div  id = "mainGrid">
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
				<dd style="">
					<input type="text" id="projectName" style="width: 120px" />
				</dd>
				<dd>
					<input type="button" onclick="projectGridReload();" id="searchButton"	value="검색" />
				</dd>
			</dl>
		</div>
		<div class="com_ta mt15" style="height: 450px;">
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

