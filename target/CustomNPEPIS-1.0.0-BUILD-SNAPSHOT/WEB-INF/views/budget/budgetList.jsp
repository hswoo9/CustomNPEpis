<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>

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
<script src='<c:url value="/js/jszip.min.js"></c:url>'></script>

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

/* 데이터 없을 시 그리드 처리 함수 */
function gridDataBound(e) {
    var grid = e.sender;         
    if (grid.dataSource.total() == 0) {
        var colCount = grid.columns.length;
        $(e.sender.wrapper)
            .find('tbody')
            .append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
    }
};

    $(document).ready(function() {
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
			
			$('input[name=chkDivCd]').each(function () {
				if (this.checked) {
					 var val = $(this).val().split(":");
					 checkedIds += val[0] + "|";
					 checkedNms += "," + val[1];
				}
			});
			
			$("#divCd").val(checkedIds);
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
		            title: "프로젝트코드",
		            width: 150
		        },
				{
		            field: "PJT_NM",
		            title: "프로젝트명"
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
			
			$('input[name=chkPjtCd]').each(function () {
				if (this.checked) {
					 var val = $(this).val().split(":");
					 checkedIds += val[0] + "|";
					 checkedNms += "," + val[1];
				}
			});
			
			$("#pjtCd").val(checkedIds);
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
			dataBound: function(e)
		        {
		            //console.log(this.dataSource.data());
		            this.fitColumns();
		            gridDataBound(e);
		          },
			scrollable: {
				endless: true
			},
			columns: [
			    {
			    	title: "회계단위",
			    	template : function(dataItem) {
		            	if (dataItem.DIV_CD == "") {
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
			    	title: "프로젝트",
			    	template : function(dataItem) {
		            	if (dataItem.MGT_CD == "") {
							return "<b>" + dataItem.MGT_NM + "</b>";
		            	}
		            	else {
		            		return dataItem.MGT_NM;
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
			    	title: "하위사업",
			    	template : function(dataItem) {
		            	if (dataItem.BOTTOM_CD == "") {
							return "<b>" + dataItem.BOTTOM_NM + "</b>";
		            	}
		            	else {
		            		return dataItem.BOTTOM_NM;
		            	}
					},
			    	/* columns: [
						{
				            field: "BOTTOM_CD",
				            title: "코드",
				            width: 20
				        },
						{
				            template : function(dataItem) {
				            	if (dataItem.BOTTOM_CD == "") {
									return "<b>" + dataItem.BOTTOM_NM + "</b>";
				            	}
				            	else {
				            		return dataItem.BOTTOM_NM;
				            	}
							},
				            title: "명",
				            width: 80
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
				            template : function(dataItem) {
				            	if (dataItem.BOTTOM_CD == "" || dataItem.PJT_CD == "" || dataItem.DIV_CD == "") {
									return "<b>" + dataItem.BGT_NM + "</b>";
				            	}
				            	else {
				            		if (dataItem.BGT_NM === undefined) {
					            		return "";
				            		}
				            		else {
					            		return dataItem.BGT_NM;
				            		}
				            	}
							},
				            title: "항",
				            //width: 40
				        }]
			    },
			    {
		            field: "deptNm",
		            title: "부서명",
		            //width: 50
		        },
				{
		            template : function(dataItem) {
		            	if (dataItem.BOTTOM_CD == "" || dataItem.PJT_CD == "" || dataItem.DIV_CD == "") {
							return "<div style='text-align:right;'>" + numberFormatStr(dataItem.BGT_AM1) + "&nbsp;</div>";
		            	}
		            	else {
		            		return "<div style='text-align:right;'>" + numberFormatStr(dataItem.BGT_AM1) + "&nbsp;</div>";
		            	}
					},
		            title: "편성금액",
		            //width: 40
		        },
				{
		            template : function(dataItem) {
		            	if (dataItem.BOTTOM_CD == "" || dataItem.PJT_CD == "" || dataItem.DIV_CD == "") {
							return "<div style='text-align:right;'>" + numberFormatStr(dataItem.BGT_AM2) + "&nbsp;</div>";
		            	}
		            	else {
		            		return "<div style='text-align:right;'>" + numberFormatStr(dataItem.BGT_AM2) + "&nbsp;</div>";
		            	}
					},
		            title: "조정금액",
		            //width: 40
		        },
				{
		            template : function(dataItem) {
		            	if (dataItem.BOTTOM_CD == "" || dataItem.PJT_CD == "" || dataItem.DIV_CD == "") {
							return "<div style='text-align:right;'>" + numberFormatStr(dataItem.BGT_AM1 + dataItem.BGT_AM2) + "&nbsp;</div>";
		            	}
		            	else {
		            		return "<div style='text-align:right;'>" + numberFormatStr(dataItem.BGT_AM1 + dataItem.BGT_AM2) + "&nbsp;</div>";
		            	}
					},
		            title: "합계",
		            //width: 40
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
    
	function gridExcel() {
		alert("데이터 수집에 일정 시간이 소요됩니다. 다운로드 창이 보일때까지 기다리시기 바랍니다.");
		
		var form = document.excelForm;
		form.action = "${pageContext.request.contextPath}/budget/getBudgetDataListExcel";
		
		$('#reqYearE').val($('#reqYear').val());
		$('#deptSeqE').val($('#deptSeq').val());
		$('#divCdE').val($('#divCd').val());
		$('#pjtCdE').val($('#pjtCd').val());
		$('#btmCdE').val($('#btmCd').val());
		
		form.submit();
	}
	
	var mainDataSource = new kendo.data.DataSource({
		serverPaging: false,
		pageSize: 10000,
		transport: {
			read:  {
				url: "${pageContext.request.contextPath}/budget/getBudgetDataList",
				dataType: "json",
				type: 'post'
			},
			parameterMap: function(data, operation) {
				data.reqYear = $('#reqYear').val();
				data.deptSeq = $('#deptSeq').val();
				data.divCd   = $('#divCd').val();
				data.pjtCd   = $('#pjtCd').val();
				data.btmCd   = $('#btmCd').val();
				
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
</script>

<body>
	<form id="excelForm" name="excelForm" method="post">
		<input type="hidden" id="reqYearE" name="reqYearE" />
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
	            <h4>사업별 예산편성 현황</h4>
	        </div>
	    </div>
		<div class="sub_contents_wrap">
			<p class="tit_p mt5 mt20">사업별 예산편성 현황</p>
			<div class="top_box">
				<dl>				    
					<dt class="ar" style="width:80px" >년도</dt>
					<dd>
						<input type="text" value="${reqYear}" id="reqYear" name="reqYear" style="width: 90px"/>
					</dd>
					<dt class="ar" style="width:103px" >부서</dt>
					<dd>
						<input type="text" id="deptNm" name="deptNm" style="width: 300px" readonly />
						<input type="button" id="deptSearch" value="선택" />
						<input type="button" id="deptSearchCncl" value="선택취소" />
						<input type="hidden" name="deptSeq" id="deptSeq">
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
					<dt class="ar" style="width:103px" >프로젝트</dt>
					<dd>
						<input type="text" id="pjtNm" style="width: 500px" readonly />
						<input type="button" id="pjtSearch" value="선택" />
						<input type="button" id="pjtSearchCncl" value="선택취소" />
						<input type="hidden" id="pjtCd" name="divCd" />
					</dd>
					<dt class="ar" style="width:103px" >하위사업</dt>
					<dd>
						<input type="text" id="btmNm" style="width: 500px" readonly />
						<input type="button" id="btmSearch" value="선택" />
						<input type="button" id="btmSearchCncl" value="선택취소" />
						<input type="hidden" id="btmCd" name="divCd" />
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
			<h1>프로젝트</h1>
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