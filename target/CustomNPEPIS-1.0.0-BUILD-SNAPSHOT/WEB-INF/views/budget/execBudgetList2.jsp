<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<jsp:useBean id="mm" class="java.util.Date" />
<fmt:formatDate value="${mm}" var="mm" pattern="MM" />

<%
 /** 
  * @Class Name : budgetList.jsp
  * @Description : 예실대비
  * @Modification Information
  * @
  * @  수정일                 수정자             수정내용
  * @ ----------      --------    ---------------------------
  * @ 2018.05.24      이철중             최초 생성
  *
  * @author 이철중
  * @since 2018.05.24
  * @version 1.0
  * @see
  *
  */
%>

<html>
<head>
</head>
<script type="text/javascript" src='<c:url value="/js/ac/acUtil.js"></c:url>'></script>
<script type="text/javascript" src="<c:url value='/js/jszip.min.js' />"></script>
<style type="text/css">
.k-header .k-link{
   text-align: center;
}
</style>

<script type="text/javascript">

//켄도그리드 컬럼 autoFit 함수
kendo.ui.Grid.fn.fitColumns = function(parentColumn)
{
  var grid = this;
  var columns = grid.columns;
  if(parentColumn && parentColumn.columns)
    	columns = parentColumn.columns;
  columns.forEach(function(col) {
    if(col.columns)
      	return grid.fitColumns(col);
    grid.autoFitColumn(col);
  });
  grid.expandToFit();
}//fitColumns

kendo.ui.Grid.fn.expandToFit = function()
{
					var $gridHeaderTable = this.thead.closest('table');
      var gridDataWidth = $gridHeaderTable.width();
      var gridWrapperWidth = $gridHeaderTable.closest('.k-grid-header-wrap').innerWidth();
      // Since this is called after column auto-fit, reducing size
      // of columns would overflow data.
      if (gridDataWidth >= gridWrapperWidth) {
          return;
      }

      var $headerCols = $gridHeaderTable.find('colgroup > col');
      var $tableCols = this.table.find('colgroup > col');

      var sizeFactor = (gridWrapperWidth / gridDataWidth);
      $headerCols.add($tableCols).not('.k-group-col').each(function () {
          var currentWidth = $(this).width();
          var newWidth = (currentWidth * sizeFactor);
          $(this).css({
              width: newWidth
          });
      });        
}//expandToFit
var nowMonth = '<c:out value="${mm}"/>';
    $(document).ready(function() {
    	
    	$("select option[value='"+nowMonth+"']").attr("selected", true);
    	
    	$('select').kendoDropDownList();
    	
    	$("#reqYear").kendoDatePicker({
    		// defines the start view
    		start : "decade",

    		// defines when the calendar should return date
    		depth : "decade",

    		// display month and year in the input
    		format : "yyyy",
    		parseFormats : [ "yyyy" ],

    		// specifies that DateInput is used for masking the input element
    		culture : "ko-KR",
    		dateInput : true
    	});
    	
    	$("#reqYear").attr("readonly", true);
    	
    	var divWin = $("#divPopUp");
    	var pjtWin = $("#pjtPopUp");
    	var btmWin = $("#btmPopUp");
    	
    	$("#deptSearch").on("click", function() {
    		callOrgPop();
    	});

		$("#deptSeq").val("${deptSeq}");
		$("#deptNm").val("${deptNm}");
    	
    	$("#divSearch").on("click", function() {
			divWin.data("kendoWindow").open();
			$("#divSearch").fadeOut();
			
			$("#divGrid").kendoGrid({
				dataSource: divDataSource,
				height: 290,
				sortable: true,
				persistSelection: true,
				selectable: "multiple",
				scrollable: {
					endless: true
				},
				columns: [{
 					template: "<input name='chkDivCd' type='checkbox' id='divCd#=DIV_CD#' class='k-checkbox rightCheck' value='#=DIV_CD#:#=DIV_NM#' /><label for='divCd#=DIV_CD#' class='k-checkbox-label'></label>",
					width: 50
		        },
				{
		            field: "DIV_CD",
		            title: "사업장코드",
		            width: 150
		        },
				{
		            field: "DIV_NM",
		            title: "사업장명"
		        }]
		    }).data("kendoGrid");
    	});
		
		divWin.kendoWindow({
			width: "500px",
			height: "420px",
			visible: false,
			modal : true,
			actions: [
				"Close"
			],
			close: onDivClose
		}).data("kendoWindow").center();
		
		$("#divCncl").click(function() {
	    	divWin.data("kendoWindow").close();
		});
		
		$("#divOk").click(function() {
			var checkedIds = "";
			var checkedNms = "";
			var checkedDiv = new Array();
			
			
			$('input[name=chkDivCd]').each(function () {
				if (this.checked) {
					 var val = $(this).val().split(":");
					 checkedIds += val[0] + "|";
					 checkedNms += "," + val[1];
					 
					 checkedDiv.push(val[0]);
				}
			});
			
			
			$("#divCd").val(checkedDiv);
			$("#divNm").val(checkedNms.substring(1, checkedNms.length));
			
	    	divWin.data("kendoWindow").close();
		});
    	
    	$("#pjtSearch").on("click", function() {
			pjtWin.data("kendoWindow").open();
			$("#pjtSearch").fadeOut();
			
			$("#pjtGrid").kendoGrid({
				dataSource: pjtDataSource,
				height: 290,
				sortable: true,
				persistSelection: true,
				selectable: "multiple",
				scrollable: {
					endless: true
				},
				columns: [{
 					template: "<input name='chkPjtCd' type='checkbox' id='pjtCd#=PJT_CD#' class='k-checkbox rightCheck' value='#=PJT_CD#:#=PJT_NM#' /><label for='pjtCd#=PJT_CD#' class='k-checkbox-label'></label>",
					width: 50
		        },
				{
		            field: "PJT_CD",
		            title: "사업코드",
		            width: 150
		        },
				{
		            field: "PJT_NM",
		            title: "사업명"
		        }]
		    }).data("kendoGrid");
    	});
		
		pjtWin.kendoWindow({
			width: "500px",
			height: "420px",
			visible: false,
			modal : true,
			actions: [
				"Close"
			],
			close: onPjtClose
		}).data("kendoWindow").center();
		
		$("#pjtCncl").click(function() {
	    	pjtWin.data("kendoWindow").close();
		});
		
		$("#pjtOk").click(function() {
			var checkedIds = "";
			var checkedNms = "";
			var checkedPjt = new Array();
			
			$('input[name=chkPjtCd]').each(function () {
				if (this.checked) {
					 var val = $(this).val().split(":");
					 checkedIds += val[0] + "|";
					 checkedNms += "," + val[1];
					 checkedPjt.push(val[0]);
				}
			});
			
			$("#pjtCd").val(checkedPjt);
			$("#pjtNm").val(checkedNms.substring(1, checkedNms.length));
			
	    	pjtWin.data("kendoWindow").close();
		});
    	
    	$("#btmSearch").on("click", function() {
			btmWin.data("kendoWindow").open();
			$("#btmSearch").fadeOut();
			
			$("#btmGrid").kendoGrid({
				dataSource: btmDataSource,
				height: 290,
				sortable: true,
				persistSelection: true,
				selectable: "multiple",
				scrollable: {
					endless: true
				},
				columns: [{
 					template: "<input name='chkBtmCd' type='checkbox' id='btmCd#=BOTTOM_CD#' class='k-checkbox rightCheck' value='#=BOTTOM_CD#:#=BOTTOM_NM#' /><label for='btmCd#=BOTTOM_CD#' class='k-checkbox-label'></label>",
					width: 50
		        },
				{
		            field: "BOTTOM_CD",
		            title: "하위사업코드",
		            width: 150
		        },
				{
		            field: "BOTTOM_NM",
		            title: "하위사업명"
		        }]
		    }).data("kendoGrid");
    	});
		
		btmWin.kendoWindow({
			width: "500px",
			height: "420px",
			visible: false,
			modal : true,
			actions: [
				"Close"
			],
			close: onBtmClose
		}).data("kendoWindow").center();
		
		$("#btmCncl").click(function() {
	    	btmWin.data("kendoWindow").close();
		});
		
		$("#btmOk").click(function() {
			var checkedIds = "";
			var checkedNms = "";
			
			$('input[name=chkBtmCd]').each(function () {
				if (this.checked) {
					 var val = $(this).val().split(":");
					 checkedIds += val[0] + "|";
					 checkedNms += "," + val[1];
				}
			});
			
			$("#btmCd").val(checkedIds);
			$("#btmNm").val(checkedNms.substring(1, checkedNms.length));
			
	    	btmWin.data("kendoWindow").close();
		});
		
		$("#divSearchCncl").click(function() {
	    	$("#divCd").val("");
	    	$("#divNm").val("");
		});
		
		$("#pjtSearchCncl").click(function() {
	    	$("#pjtCd").val("");
	    	$("#pjtNm").val("");
		});
		
		$("#btmSearchCncl").click(function() {
	    	$("#btmCd").val("");
	    	$("#btmNm").val("");
		});
		
		$("#deptSearchCncl").click(function() {
	    	$("#deptNm").val("");
	    	$("#deptSeq").val("");
		});
		
		$('#divCd').val('1000');
		$('#divNm').val('기금');
		
		$("#mainGrid").kendoGrid({
			dataSource: mainDataSource,
			height: 590,
// 			sortable: true,
// 			persistSelection: true,
// 	        pageable: {
// 	            refresh: true,
// 	            pageSizes: true,
// 	            buttonCount: 5
// 	        },
// 			selectable: "multiple",
// 			dataBound: function(e)
// 		        {
// 		            //console.log(this.dataSource.data());
// 		            this.fitColumns();
// 		          },
			dataBound: function(e){
                var grid = this;
                
 				/* 찬혁 progress 그래프 추가 해당 class값에 kendo progressBar 추가하는 부분 */

                $(".progress").each(function(){
                  var row = $(this).closest("tr");
                  var model = grid.dataItem(row);
                  var bgColor = '';
                  if (model.GB == '1') {
                	  bgColor = "#86E57F";
                  } else if (model.GB == '2') {
                	  bgColor = "#5CD1E5";
                  } else if (model.GB == '3') {
                	  bgColor = "#14899D";
                  } else {
                	  bgColor = "#8041D9";
                  }
                  
                  $(this).kendoProgressBar({
                	  change: function(e) {
                          this.progressWrapper.css({
                            "background-color": bgColor,
                            "border-color": bgColor
                          });
                        },
                    max: 100,
                    width : 80
                  });
                  $(this).data("kendoProgressBar").value(model.APPLY_JAN_PCT);
                });
                
                $(".progress2").each(function(){
                    var row = $(this).closest("tr");
                    var model = grid.dataItem(row);
                    var bgColor = '';
                    var bdColor = '';
                    if (model.GB == '1') {
                  	  bgColor = "#86E57F";
                    } else if (model.GB == '2') {
                  	  bgColor = "#5CD1E5";
                    } else if (model.GB == '3') {
                  	  bgColor = "#14899D";
                    } else {
                  	  bgColor = "#8041D9";
                    }
                    $(this).kendoProgressBar({
                    	change: function(e) {
                            this.progressWrapper.css({
                              "background-color": bgColor,
                              "border-color": bgColor
                            });
                          },
                      max: 100,
                      width : 80
                    });
                    $(this).data("kendoProgressBar").value(model.APPLY_JAN2_PCT);
                  });
                
                $(".progress3").each(function(){
                    var row = $(this).closest("tr");
                    var model = grid.dataItem(row);
                    var bgColor = '';
                    var bdColor = '';
                    if (model.GB == '1') {
                  	  bgColor = "#86E57F";
                    } else if (model.GB == '2') {
                  	  bgColor = "#5CD1E5";
                    } else if (model.GB == '3') {
                  	  bgColor = "#14899D";
                    } else {
                  	  bgColor = "#8041D9";
                    }
                    $(this).kendoProgressBar({
                    	change: function(e) {
                            this.progressWrapper.css({
                              "background-color": bgColor,
                              "border-color": bgColor
                            });
                          },
                      max: 100,
                      width : 80
                    });
                    $(this).data("kendoProgressBar").value(model.APPLY_JAN3_PCT);
                  });
                
                /* 찬혁 progress 그래프 추가 */
                
              },
			scrollable: {
				endless: true
			},
			columns: [
			    {
			    	title: "회계단위",
			    	template : function(dataItem) {
		            	if (dataItem.GB != "1") {
							return "<b>" + dataItem.DIV_NM + "</b>";
		            	}
		            	else {
		            		
		            		return dataItem.DIV_NM;
		            	}
					},
			    	/* columns: [
						{
				            field: "DIV_CD",
				            title: "코드",
				            width: 20
				        },
						{
				            template : function(dataItem) {
				            	if (dataItem.DIV_CD == "") {
									return "<b>" + dataItem.DIV_NM + "</b>";
				            	}
				            	else {
				            		return dataItem.DIV_NM;
				            	}
							},
				            title: "명",
				            width: 30
				        }] */
			    },
			    {
			    	title: "사업",
			    	template : function(dataItem) {
		            	if (dataItem.GB != "1") {
							return "<b>" + dataItem.PJT_NM + "</b>";
		            	}
		            	else {
		            		return dataItem.PJT_NM;
		            	}
					},
			    	/* columns: [
						{
				            field: "MGT_CD",
				            title: "코드",
				            width: 20
				        },
						{
				            template : function(dataItem) {
				            	if (dataItem.MGT_CD == "") {
									return "<b>" + dataItem.MGT_NM + "</b>";
				            	}
				            	else {
				            		return dataItem.MGT_NM;
				            	}
							},
				            title: "명",
				            width: 40
				        }] */
			    },
			    
			    {
			    	title: "예산과목",
			    	columns: [
						/* {
				            field: "BGT_CD",
				            title: "코드",
				            width: 20
				        }, */
						{
				            field: "BGT_NM1",
				            title: "관",
				            //width: 40
				        },
						{
// 				            template : function(dataItem) {
// 				            	if (dataItem.BOTTOM_CD == "" || dataItem.PJT_CD == "" || dataItem.DIV_CD == "") {
// 									return "<b>" + dataItem.BGT_NM2 + "</b>";
// 				            	}
// 				            	else {
// 				            		if (dataItem.BGT_NM2 === undefined) {
// 					            		return "";
// 				            		}
// 				            		else {
// 					            		return dataItem.BGT_NM2;
// 				            		}
// 				            	}
// 							},
							field: "BGT_NM2",
				            title: "항",
				            //width: 40
				        }
				        ]
			    },
			    
				{
		            template : function(dataItem) {
		            	if (dataItem.GB != "1") {
							return "<div style='text-align:right;font-weight:bold'>" + numberFormatStr(dataItem.BGT_AM) + "&nbsp;</div>";
		            	}
		            	else {
		            		return "<div style='text-align:right;'>" + numberFormatStr(dataItem.BGT_AM) + "&nbsp;</div>";
		            	}
					},
		            /* title: "예산금액<br/>(편성금액+조정금액)", */
		            title: "예산금액",
		            //width: 40
		        },
				{
		            template : function(dataItem) {
		            	if (dataItem.GB != "1") {
							return "<div style='text-align:right;font-weight:bold'>" + numberFormatStr(dataItem.APPLY_AM) + "&nbsp;</div>";
		            	}
		            	else {
		            		return "<div style='text-align:right;'>" + numberFormatStr(dataItem.APPLY_AM) + "&nbsp;</div>";
		            	}
					},
		            title: "품의금액",
		            //width: 40
		        },
				{
		            template : function(dataItem) {
		            	if (dataItem.GB != "1") {
							return "<div style='text-align:right;font-weight:bold'>" + numberFormatStr(dataItem.AMT2) + "&nbsp;</div>";
		            	}
		            	else {
		            		return "<div style='text-align:right;'>" + numberFormatStr(dataItem.AMT2) + "&nbsp;</div>";
		            	}
					},
		            title: "결의금액",
		            //width: 40
		        },
		        {
		            template : function(dataItem) {
		            	if (dataItem.GB != "1") {
							return "<div style='text-align:right;font-weight:bold'>" + numberFormatStr(dataItem.AMT3) + "&nbsp;</div>";
		            	}
		            	else {
		            		return "<div style='text-align:right;'>" + numberFormatStr(dataItem.AMT3) + "&nbsp;</div>";
		            	}
					},
		            title: "전표금액",
		            //width: 40
		        },
			    {
			    	title: "품의기준잔액",
			    	columns: [
						{
				            template : function(dataItem) {
				            	if (dataItem.GB != "1") {
									return "<div style='text-align:right;font-weight:bold'>" + numberFormatStr(dataItem.APPLY_JAN) + "&nbsp;</div>";
				            	}
				            	else {
				            		return "<div style='text-align:right;'>" + numberFormatStr(dataItem.APPLY_JAN) + "&nbsp;</div>";
				            	}
							},
				            title: "잔액",
				            //width: 40
				        },
				        {
// 				            template : function(dataItem) {
// 				            	if (dataItem.BOTTOM_CD == "" || dataItem.PJT_CD == "" || dataItem.DIV_CD == "") {
// 									return "<div style='text-align:right;'>" + numberFormatStr(dataItem.APPLY_JAN_PCT) + "%&nbsp;</div>";
// 				            	}
// 				            	else {
// 				            		return "<div style='text-align:right;'>" + dataItem.APPLY_JAN_PCT + "%&nbsp;</div>";
// 				            	}
// 							},

							/* Progress Bar 추가를 위한 class명 template 생성 */

							template : "<div class='progress' style='width : 80px'></div>",
				            title: "집행률 (%)",
				            width: 100,
				            
				            /* Progress Bar 추가를 위한 class명 template 생성 */
				            //width: 15
				        }]
			    },
			    {
			    	title: "결의기준잔액",
			    	columns: [
						{
				            template : function(dataItem) {
				            	if (dataItem.GB != "1") {
									return "<div style='text-align:right;font-weight:bold'>" + numberFormatStr(dataItem.APPLY_JAN2) + "&nbsp;</div>";
				            	}
				            	else {
				            		return "<div style='text-align:right;'>" + numberFormatStr(dataItem.APPLY_JAN2) + "&nbsp;</div>";
				            	}
							},
				            title: "잔액",
				            //width: 40
				        },
				        {
// 				            template : function(dataItem) {
// 				            	if (dataItem.BOTTOM_CD == "" || dataItem.PJT_CD == "" || dataItem.DIV_CD == "") {
// 									return "<div style='text-align:right;'>" + numberFormatStr(dataItem.APPLY_JAN2_PCT) + "%&nbsp;</div>";
// 				            	}
// 				            	else {
// 				            		return "<div style='text-align:right;'>" + dataItem.APPLY_JAN2_PCT + "%&nbsp;</div>";
// 				            	}
// 							},
// 				            title: "집행률",
				            
				            /* Progress Bar 추가를 위한 class명 template 생성 */
				            
				            template : "<div class='progress2' style='width : 80px'></div>",
				            
				            /* Progress Bar 추가를 위한 class명 template 생성 */
				            
				            title: "집행률 (%)",
				            width: 100,
				            //width: 15
				        }]
			    },
			    {
			    	title: "전표기준잔액",
			    	columns: [
						{
				            template : function(dataItem) {
				            	if (dataItem.GB != "1") {
									return "<div style='text-align:right;font-weight:bold'>" + numberFormatStr(dataItem.APPLY_JAN3) + "&nbsp;</div>";
				            	}
				            	else {
				            		return "<div style='text-align:right;'>" + numberFormatStr(dataItem.APPLY_JAN3) + "&nbsp;</div>";
				            	}
							},
				            title: "잔액",
				            //width: 40
				        },
				        {
// 				            template : function(dataItem) {
// 				            	if (dataItem.BOTTOM_CD == "" || dataItem.PJT_CD == "" || dataItem.DIV_CD == "") {
// 									return "<div style='text-align:right;'>" + numberFormatStr(dataItem.APPLY_JAN3_PCT) + "%&nbsp;</div>";
// 				            	}
// 				            	else {
// 				            		return "<div style='text-align:right;'>" + dataItem.APPLY_JAN3_PCT + "%&nbsp;</div>";
// 				            	}
// 							},
// 				            title: "집행률",
				            
				            /* Progress Bar 추가를 위한 class명 template 생성 */
				            
				            template : "<div class='progress3' style='width : 80px'></div>",
				            
				            /* Progress Bar 추가를 위한 class명 template 생성 */
				            
				            title: "집행률 (%)",
				            width: 100,
				            //width: 15
				        }]
			    }]
	    }).data("kendoGrid");
    });
	
	function numberFormatStr(str) {
		var reg = /(\-?\d+)(\d{3})($|\.\d+)/;
		var param = str.toString();
		
		if (reg.test(param)) {
			return param.replace(/(\d)(?=(?:\d{3})+(?!\d))/g,'$1,');
	    }
		else {
			return param;
		}
	}
    
	function gridReload() {
		$('#mainGrid').data('kendoGrid').dataSource.read();
	}
    
	var mainDataSource = new kendo.data.DataSource({
		serverPaging: false,
		pageSize: 10000,
		transport: {
			read:  {
				url: "${pageContext.request.contextPath}/budget/execBudgetDataList2",
				dataType: "json",
				type: 'post'
			},
			parameterMap: function(data, operation) {
				data.reqMonthFr = $('#reqYear').val()+'01';
				data.reqMonthTo = $('#reqYear').val()+$('#reqMonth').val();
				data.deptSeq = $('#deptSeq').val();
				data.divCd   = $('#divCd').val();
				data.pjtCd   = $('#pjtCd').val();
// 				data.btmCd   = $('#btmCd').val();
				
		     	return data;
			}
		},
		schema: {
			data: function(response) {
				return response.mainList;
			}
		}
	});
    
	var divDataSource = new kendo.data.DataSource({
		serverPaging: false,
		pageSize: 10000,
		transport: {
			read:  {
				url: "${pageContext.request.contextPath}/budget/getDivList",
				dataType: "json",
				type: 'post'
			},
			parameterMap: function(data, operation) {
				data.divNm = $('#keyVal').val();
		     	return data;
			}
		},
		schema: {
			data: function(response) {
				return response.divList;
			}
		}
	});
	
    function onDivClose() {
    	$("#divSearch").fadeIn();
	}
    
	var pjtDataSource = new kendo.data.DataSource({
		serverPaging: false,
		pageSize: 10000,
		transport: {
			read:  {
				url: "${pageContext.request.contextPath}/budget/getPjtList",
				dataType: "json",
				type: 'post'
			},
			parameterMap: function(data, operation) {
				data.pjtNm = $('#keyVal').val();
		     	return data;
			}
		},
		schema: {
			data: function(response) {
				return response.pjtList;
			}
		}
	});
	
    function onPjtClose() {
    	$("#pjtSearch").fadeIn();
	}
    
	var btmDataSource = new kendo.data.DataSource({
		serverPaging: false,
		pageSize: 10000,
		transport: {
			read:  {
				url: "${pageContext.request.contextPath}/budget/getBtmList",
				dataType: "json",
				type: 'post'
			},
			parameterMap: function(data, operation) {
				data.pjtCd = $('#pjtCd').val();
		     	return data;
			}
		},
		schema: {
			data: function(response) {
				return response.btmList;
			}
		}
	});
	
    function onBtmClose() {
    	$("#btmSearch").fadeIn();
	}
    
	// 사용자 선택 팝업
	function callOrgPop() {
    	var pop = window.open("", "cmmOrgPop", "width=799,height=769,scrollbars=no");
		frmPop.target = "cmmOrgPop";
		frmPop.method = "post";
		frmPop.action = "${pageContext.request.contextPath}/budget/pop/cmmOrgPop";
		frmPop.submit();
		pop.focus();
	}
	
	function callbackSel(data) {
		var deptSeq  = [];
		var deptNm = [];
		
		for (var i = 0; i < data.returnObj.length; i++) {
			deptSeq.push(data.returnObj[i].deptSeq);
			deptNm.push(data.returnObj[i].deptName);
		}
		
		$("#deptSeq").val(deptSeq.join(","));
		$("#deptNm").val(deptNm.join(","));
	}

	function gridExcel() {
		
		var reqMonthFr = $('#reqYear').val()+'01';
		var reqMonthTo = $('#reqYear').val()+$('#reqMonth').val();
		var divCd = $('#divCd').val();
		var pjtCd = $('#pjtCd').val();
		
		var ds = new kendo.data.DataSource({
			transport : {
				read : {
					url : _g_contextPath_+'/budget/execBudgetDataList2?reqMonthFr='+reqMonthFr+'&reqMonthTo='+reqMonthTo+'&divCd='+divCd+'&pjtCd='+pjtCd,
					dataType : "json",
					type : 'GET'
				}
			},
			schema : {
				data : function(response) {
					return response.mainList;
				},
				model: {
		            fields: {
// 		            	WRITE_DATE: { type: "date" },
// 		            	DUTY_CODE_NM: { type: "string" },
// 		            	APPLY_EMP_NAME: { type: "string" },
// 		            	CHANGE_DATE: { type: "date" },
// 		            	DUTY_EMP_NAME: { type: "string" },
// 		            	CHANGE_EMP_NAME: { type: "string" },
// 		            	APPROVAL_STATUS: { type: "string" },
// 		            	CHANGE_REASON: { type: "string" }
		            }
		         }
			}
	      });
	      var rows = [{
	    	 
	        cells: [
	          { value: "회계단위",
	        	 vAlign: "center",
	             hAlign: "center",
	             rowSpan: 2
	             , borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" }
	           },
	          
	          { value: "사업",
	        	 vAlign: "center",
		         hAlign: "center",  
		         rowSpan: 2
		         , borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" }
	          },	          
	          { value: "예산과목",
	        	 vAlign: "center",
		         hAlign: "center",  
		         colSpan : 2
		         , borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" }
	          },	          
	          { value: "예산금액",
	        	 vAlign: "center",
		         hAlign: "center",   
		         rowSpan: 2
		         , borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" }
	          },
	          { value: "품의금액",
	        	 vAlign: "center",
		         hAlign: "center",   
		         rowSpan: 2
		         , borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" }
	          },
	          { value: "결의금액",
	        	 vAlign: "center",
		         hAlign: "center", 
		         rowSpan: 2
		         , borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" }
	          },
	          
	          { value: "전표금액",
	        	 vAlign: "center",
	             hAlign: "center",
	             rowSpan: 2
	             , borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" }
	           },
	          
	          { value: "품의기준잔액",
	        	 vAlign: "center",
		         hAlign: "center",   
		         colSpan : 2
		         , borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" }
	          },
	          { value: "결의기준잔액",
	        	 vAlign: "center",
		         hAlign: "center",  
		         colSpan : 2
		         , borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" }
	          },
	          { value: "전표기준잔액",
	        	 vAlign: "center",
		         hAlign: "center",   
		         colSpan : 2
		         , borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" }
	          }
	        ]
	      }];
			
		rows.push({
			cells: [
				{ value: "관",
		        	 vAlign: "center",
		             hAlign: "center"
		             , borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" }
		           },
		          
		          { value: "항",
		        	 vAlign: "center",
			         hAlign: "center"
			         , borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" }
		          },
		          { value: "잔액",
		        	 vAlign: "center",
			         hAlign: "center"   
			         , borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" }
		          },
		          { value: "집행률 (%)",
		        	 vAlign: "center",
			         hAlign: "center"   
			         , borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" }
		          },
		          { value: "잔액",
		        	 vAlign: "center",
			         hAlign: "center"   
			         , borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" }
		          },
		          { value: "집행률 (%)",
		        	 vAlign: "center",
			         hAlign: "center"   
			         , borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" }
		          },
		          { value: "잔액",
		        	 vAlign: "center",
			         hAlign: "center"   
			         , borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" }
		          },
		          { value: "집행률 (%)",
		        	 vAlign: "center",
			         hAlign: "center" 
			         , borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" }
		          }
	            ]
		})
		
	
			
	      //using fetch, so we can process the data when the request is successfully completed
	      ds.fetch(function(){
	        var data = this.data();
	        for (var i = 0; i < data.length; i++){
	          //push single row for every record
	          rows.push({
	            cells: [
	              { value: data[i].DIV_NM, borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" } },
	              { value: data[i].PJT_NM, borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" } },
	              { value: data[i].BGT_NM1, borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" } },
	              { value: data[i].BGT_NM2, borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" } },
	              { value: data[i].BGT_AM, borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" } },
	              { value: data[i].APPLY_AM, borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" } },
	              { value: data[i].AMT2, borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" } },
	              { value: data[i].AMT3, borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" } },
	              { value: data[i].APPLY_JAN, borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" } },
	              { value: data[i].APPLY_JAN_PCT, borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" } },
	              { value: data[i].APPLY_JAN2, borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" } },
	              { value: data[i].APPLY_JAN2_PCT, borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" } },
	              { value: data[i].APPLY_JAN3, borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" } },
	              { value: data[i].APPLY_JAN3_PCT, borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" } }
	            ]
	          })
	        }
	        
	        
	        var workbook = new kendo.ooxml.Workbook({
	          sheets: [
	            {
	            	 freezePane: {
	 	    	        rowSplit: 2
	 	    	      },
	              columns: [
	                // Column settings (width)
	                { width: 100 },
	                { width: 300 },
	                { width: 100 },
	                { width: 100 },
	                { width: 100 },
	                { width: 100 },
	                { width: 100 },
	                { width: 100 },
	                { width: 100 },
	                { width: 100 },
	                { width: 100 },
	                { width: 100 },
	                { width: 100 },
	                { width: 100 },
	              ],
	              // Title of the sheet
	              title: "사업별 예실대비 현황 (담당자용)",
	              // Rows of the sheet
	              rows: rows
	            }
	          ]
	        });
	        //save the file as Excel file with extension xlsx
	        kendo.saveAs({dataURI: workbook.toDataURL(), fileName: "사업별 예실대비 현황 (담당자용).xlsx"});
		
	      })
		
// 		alert("데이터 수집에 일정 시간이 소요됩니다. 다운로드 창이 보일때까지 기다리시기 바랍니다.");
// 		debugger
// 		var form = document.excelForm;
// 		form.action = "${pageContext.request.contextPath}/budget/execBudgetDataListExcel";
		
// 		/* 조건 검색 From ~ To 수정 */
		
// 		//$('#reqYearE').val($('#reqYear').val());
// 		$('#reqEFr').val($('#reqYear').val()+'01');
// 		$('#reqETo').val($('#reqYear').val()+$('#reqMonth').val());
		
// 		/* 조건 검색 From ~ To 수정 */
		
// 		$('#deptSeqE').val($('#deptSeq').val());
// 		$('#divCdE').val($('#divCd').val());
// 		$('#pjtCdE').val($('#pjtCd').val());
// 		$('#btmCdE').val($('#btmCd').val());
		
// 		form.submit();
	}
</script>

<body>
	<form id="excelForm" name="excelForm" method="post">
		<input type="hidden" id="reqEFr" name="reqEFr" />
		<input type="hidden" id="reqETo" name="reqETo" />
		<input type="hidden" id="deptSeqE" name="deptSeqE" />
		<input type="hidden" id="divCdE"   name="divCdE" />
		<input type="hidden" id="pjtCdE"   name="pjtCdE" />
		<input type="hidden" id="btmCdE"   name="btmCdE" />
	</form>

	<!-- 조직도 호출하기 위한 기본값 -->
	<form id="frmPop" name="frmPop">
		<input type="hidden" name="popUrlStr" id="txt_popup_url" width="800" value="/gw/systemx/orgChart.do">
		<input type="hidden" name="selectMode" width="500" value="d" />
		<!-- value : [u : 사용자 선택], [d : 부서 선택], [ud : 사용자 부서 선택], [od : 부서 조직도 선택], [oc : 회사 조직도 선택]  --> 
		<input type="hidden" name="selectItem" width="500" value="m" />
		<input type="hidden" name="compSeq" id="compSeq"  value="" />
		<input type="hidden" name="compFilter" id="compFilter" value="" />
		<input type="hidden" name="initMode" id="initMode" value="true" />
		<input type="hidden" name="noUseDefaultNodeInfo" id="noUseDefaultNodeInfo" value="true" />
		<input type="hidden" name="selectedItems" id="selectedItems" value="" />
		<input type="hidden" name="callbackUrl" id="callbackUrl" value="${pageContext.request.contextPath}/budget/pop/cmmOrgPopCallback">
		<input type="hidden" name="callback" id="callback" value="callbackSel"/>
	</form>

	<div class="iframe_wrap" style="min-width: 1070px;">
		<!-- 컨텐츠타이틀영역 -->
	    <div class="sub_title_wrap">       
	        <div class="title_div">
	            <h4>사업별 예실대비 현황</h4>
	        </div>
	    </div>
		<div class="sub_contents_wrap">
			<p class="tit_p mt5 mt20">사업별 예실대비 현황</p>
			<div class="top_box">
				<dl>				    
					<dt class="ar" style="width:80px" >기준년월</dt>
					<dd>
						<input type="text" value="${reqYear}" id="reqYear" name="reqYear" style="width: 90px"/> 년 
						<select class="selectNemu" name="reqMonth" id="reqMonth" style="width: 60px">
							<c:forEach var="i" begin="1" end="12" step="1">

							<c:set var="day" value="0${i}"/>
							
							<c:set var="day" value="${fn:substring(day, fn:length(day)-2, fn:length(day) )}"/>
							
							<option value="${day}">${day}</option>
							
							</c:forEach>
						</select> 월
					</dd>
					
					<dt class="ar" style="width:103px" >회계단위</dt>
					<dd>
						<input type="text" id="divNm" style="width: 300px" readonly />
						<input type="button" id="divSearch" value="선택" />
						<input type="button" id="divSearchCncl" value="선택취소" />
						<input type="hidden" id="divCd" name="divCd" />
					</dd>
				</dl>
				<dl>
					<dt class="ar" style="width:103px" >사업</dt>
					<dd>
						<input type="text" id="pjtNm" style="width: 500px" readonly />
						<input type="button" id="pjtSearch" value="선택" />
						<input type="button" id="pjtSearchCncl" value="선택취소" />
						<input type="hidden" id="pjtCd" name="divCd" />
					</dd>
					
				</dl>
			</div>
	  		    
		    <!--신청 버튼 -->
			<div class="btn_div">	
				<div class="right_div">
					<div class="controll_btn p0">										
						<button type="button" onclick="gridReload();">조회</button>
						<button type="button" onclick="gridExcel();">엑셀다운로드</button>
					</div>
				</div>
			</div>
			
			<div class="com_ta2 mt15">
				<div id="mainGrid"></div>
			</div>
		</div>
	</div>
	
	<div class="pop_wrap_dir" id="divPopUp" style="width:500px; display:none;">
		<div class="pop_head">
			<h1>예산회계단위</h1>
		</div>
		<div id="divGrid"></div>
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" class="blue_btn" id="divOk"   value="적용" />
				<input type="button" class="blue_btn" id="divCncl" value="취소" />
			</div>
		</div>
	</div>
	
	<div class="pop_wrap_dir" id="pjtPopUp" style="width:500px; display:none;">
		<div class="pop_head">
			<h1>사업</h1>
		</div>
		<div id="pjtGrid"></div>
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" class="blue_btn" id="pjtOk"   value="적용" />
				<input type="button" class="blue_btn" id="pjtCncl" value="취소" />
			</div>
		</div>
	</div>
	
	<div class="pop_wrap_dir" id="btmPopUp" style="width:500px; display:none;">
		<div class="pop_head">
			<h1>하위사업</h1>
		</div>
		<div id="btmGrid"></div>
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" class="blue_btn" id="btmOk"   value="적용" />
				<input type="button" class="blue_btn" id="btmCncl" value="취소" />
			</div>
		</div>
	</div>
</body>
</html>