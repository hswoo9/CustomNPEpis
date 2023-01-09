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
<script type="text/javascript" src="<c:url value='/js/common/outProcessUtil.js' />"></script>
<style>
	.green_btn {background:#0e7806 !important; height:24px; padding:0 11px; color:#fff !important;border:none; font-weight:bold; border:0px !important;}
	.font-underline { text-decoration : underline; }
</style>
<script type="text/javascript">
 
 var standardPrice = [ { div : '0', divName : '[원]' }, { div : '1', divName : '[천원]' }, { div : '2', divName : '[백만원]' } ]
 
	$(function() {
		Init.ajax();
		
		Init.kendoFunction();
		Init.kendoGrid();
		Init.eventListener();
	})
	
	var Init = {
			ajax : function() {
			},
			kendoFunction : function() {
				
				$('#loadingPop').parent().find('.k-window-action').css("visibility", "hidden");
				$('#loadingPop').kendoWindow({
				     width: "443px",
				     visible: false,
				     modal: true,
				     actions: [],
				     close: false
				 }).data("kendoWindow").center();
				
				$("#standardDate").kendoDatePicker({
				    depth: "year",
				    start: "year",
				    culture : "ko-KR",
					format : "yyyy-MM",
					value : new Date(),
				});
				
				$("#status").kendoComboBox({
				      dataSource: standardPrice,
				      dataTextField: "divName",
					  dataValueField: "div",
					  height : 500,
					  index : 0
				});
			},
			kendoGrid : function() {
				/* 상단 그리드 */
				var mainGrid = $("#mainGrid").kendoGrid({
					dataSource : new kendo.data.DataSource({
						transport : {
							read : {
								url : _g_contextPath_+"/budget/selectDailySchedule",
								dataType : "json",
								type : 'post'
							},
							parameterMap: function(data, operation) {
		  	      				data.baseDate = $("#standardDate").val().replace(/-/gi,'');
		    	     			return data;
		    	     		}
						},
						height : 1220,
						schema : {
							data : function(response) {
								return response.list;
							},
							total : function(response) {
								return response.total;
							},
						}
					}),
					dataBound : mainGridDataBound,
			        columns: [
			        	{ 
			                template : function(dataItem){
								
			                	if (dataItem.appr_seqn === "" || dataItem.status === 'C') {
			                		return '<input type="checkbox" class = "mainCheckBox">';            		
			                	} else {
			                		return '';
			                	}
			                },
			                width : "5px"
			             },
			        	{	
			        		template : function(dataItem) {
			        			var baseDate = dataItem.baseDate;
			        			return baseDate.substring(0, 4) + '-' + baseDate.substring(4, 6) + '-' + baseDate.substring(6); 
			        		},
			        		field : "baseDate",				title : "기준일자",	width : 15
		        		},
		        		{
		        			template : function(dataItem) {
		        				return Budget.fn_formatMoney(dataItem.amt === null ? '' : dataItem.amt);
		        			},
		        			title : '합계 금액 (원)', width : 20
		        		},
			        	{	
		        			template : function(dataItem) {
		        				if (dataItem.appr_seqn === '') {
		        					return '';
		        				} else {
				        			return  "<span class='grdCol' style='color: blue;' onclick='fn_docViewPop(" + dataItem.appr_dikey + ")'>" + dataItem.c_dititle + "</span>";
		        				}
			        		},
		        			field : "c_dititle",				title : "문서제목",	width : 40
	        			},
			        	{	field : "emp_name",			title : "기안자", 	width : 10 },
			        	{	field : "statusNm",				title : "문서상태",	width : 10 },
			        	{
			        		template : function(dataItem) {
			        			
			        			if (dataItem.status === 'D') {
			        				return '<input type="button" class="text_blue" style="width: 80px;" onclick="cancelDraft(this);" value="취소">';	
			        			} else {
			        				return '';
			        			}
			        		}, title : '취소', width : 10
			        	},
			        	{
			        		template : function(dataItem) {
			        			if (dataItem.status === 'D') {
			        				return '기안';
			        			} else if (dataItem.status === 'C') {
			        				return '취소';
			        			} else {
			        				return '';
			        			}
			        		},
			        		title : '기안상태',
			        		width : 10
			        	}
			        	]
			    }).data("kendoGrid");
				/* 상단 그리드 */
				
			},
			eventListener : function() {
				$(document).on("click", "#mainGrid td", function(e) {
					row = $(this).closest('tr');
					grid = $('#mainGrid').data("kendoGrid"),
					dataItem = grid.dataItem(row);
					
					console.log(dataItem);	
					
					var isChecked = row.find('[type=checkbox]').is(':checked');
					
					if (!isChecked) {
						$('[type=checkbox]').prop('checked', false);
					}
					row.find('[type=checkbox]').prop('checked', !isChecked);
				})
				
				$(document).on("click", ".mainCheckBox", function(e) {
					e.stopPropagation();
					
					if ($(this).is(':checked')) {
						$('[type=checkbox]').prop('checked', false);
						$(this).prop('checked', true);
					}
				})
				
				$(document).on({
		    		mouseenter : function() {
		    			$(this).addClass("font-underline");
		    		},
		    		mouseleave : function() {
		    			$(this).removeClass("font-underline");
		    		}
		    	}, '.grdCol')
			}
	}
	
 	function cancelDraft(thisObj) {
		
	 	var row = $('#mainGrid').data('kendoGrid').dataItem($(thisObj).closest('tr'));
	 	
	 	if (!confirm('취소하시겠습니까?')) {
	 		return;
	 	}
	 	
		 $.ajax({
			url : _g_contextPath_+'/budget/saveDailyScheduleStatus',
			type : 'post',
			data : { appr_dikey : row.appr_dikey },
		}).success(function(data) {
			if (data.isSucc) {
				alert('취소하였습니다.');
				searchMainGrid();
			}
		});
 }
 
	function mainGridDataBound(e) {
		var grid = e.sender;

		if (grid.dataSource.total() == 0) {
			var colCount = grid.columns.length + 3;
			$(e.sender.wrapper).find('tbody').append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
		}
		
		if ($('#status').data('kendoComboBox').value() === '0') { // 원
			$('#tlt').html('일계표 [단위(원)]');
		} else if ($('#status').data('kendoComboBox').value() === '1') { // 천원
			$('#tlt').html('일계표 [단위(천원)]');
		} else { // 백만원
			$('#tlt').html('일계표 [단위(백만원)]');
		}
	}
	
	function searchMainGrid() {
		$('#mainGrid').data('kendoGrid').dataSource.read();
	}
	
	function resDocSubmit(){
		
		$('#adocuDTbody tr').not('.fixed').remove();
		var suffix = 1;
		var row = $('#mainGrid').data('kendoGrid').dataItem($('input[type=checkbox]:checked').closest('tr'));
		
		
		if (row.appr_seqn !== '') {
			suffix = Number(row.docx_numb.split('-')[1]) + 1;
		}
		
		if ($('#status').data('kendoComboBox').value() === '0') { // 원
			$('#moneyUnit').html('( 단위 : 원 )');
		} else if ($('#status').data('kendoComboBox').value() === '1') { // 천원
			$('#moneyUnit').html('( 단위 : 천원 )');
		} else { // 백만원
			$('#moneyUnit').html('( 단위 : 백만원 )');
		}
		
		$('html').css("cursor", "wait");
		$('#loadingPop').data("kendoWindow").open();
		
		$.ajax({
			url : _g_contextPath_+'/budget/selectDailyScheduleInfo',
			type : 'post',
			data : { baseDate : row.baseDate, div : $('#status').data('kendoComboBox').value() },
		}).success(function(data) {
			
			$('html').css("cursor", "auto");
			$('#loadingPop').data("kendoWindow").close();
			
			var gridDatas = data.list;
			
			$('#gigan').html( '<br/>&nbsp;&nbsp;&nbsp;기&nbsp;간 : ' + Budget.fn_formatDate(row.baseDate) + ' ~ ' + Budget.fn_formatDate(row.baseDate));
			
			setDailyScheduleInfo(gridDatas);
			
			fnApproval(row.baseDate, suffix);
		});
	}
	
	function setDailyScheduleInfo(result) {
		
		var row = '';
		
		$.each(result, function(i, v){
			
			row += makeRowData(v);
		});
		
		$('#adocuDTbody').append(row);
	}
	
	function makeRowData(v) {
		var result = '';
		var colorCode = '';
		
		for (var i = 1; i < 8; i++) {
			v['AMT' + i] = typeof v['AMT' + i] === 'undefined' ? '' : v['AMT' + i];
			
			if (i === 4) {
				var fontWeight = 300;
				 if (v['PRT_NM'].indexOf('<< 합          계 >>') > -1 || v['PRT_NM'].indexOf('< 금  일    소  계 >') > -1) {
					fontWeight = 900;
					colorCode = '#CEECF5';
				} else if (v['PRT_NM'].indexOf('>') > -1 || (v['PRT_NM'].match(/</g) || []).length > 1) {
					fontWeight = 900;
					colorCode = '#CEF6CE';
				}
				result += '<td style="font-size: 10pt;border-top: 2px solid;border-left: 2px solid;border-bottom: 1px solid;border-right: 1px solid;text-align: center;vertical-align: middle;height: 20px;">';
				result += '<span style="font-family: \'Noto Sans CJK KR\'; font-weight: ' + fontWeight + '">' + v['PRT_NM'] + '</span>';	
			} else if (i < 4) {
				result += '<td style="font-size: 10pt;border-top: 2px solid;border-left: 2px solid;border-bottom: 1px solid;border-right: 1px solid;text-align: right;vertical-align: middle;height: 20px;">';
				result += Budget.fn_formatMoney(v['AMT' + i]) + '&nbsp;&nbsp;'; 
			} else {
				result += '<td style="font-size: 10pt;border-top: 2px solid;border-left: 2px solid;border-bottom: 1px solid;border-right: 1px solid;text-align: right;vertical-align: middle;height: 20px;">';
				result += Budget.fn_formatMoney(v['AMT' + (i - 1)]) + '&nbsp;&nbsp;';
			}
			result += '</td>';
		}
		
		if (colorCode !== "") {
			result = '<tr style="height : 38px; background-color: ' + colorCode + '">' + result + '</tr>';
		} else {
			result = '<tr style="height : 38px;">' + result + '</tr>';
		}
		
		return result;
	}

	
	function fnApproval(baseDate, suffix){
		var baseDate = baseDate;
		var divVal = $('#status').data('kendoComboBox').value();
		
		var params = {};
	    params.compSeq =$('#compSeq').val();
	    params.approKey = 'DAILYSCD' + baseDate + '-' + suffix;
	    params.outProcessCode = 'DAILYSCD';
	    params.empSeq = $('#empSeq').val();
	    params.mod = 'W';
	    params.contentsStr = makeContentsStr();
	    params.title = '[일계표] ' + baseDate;
	    outProcessLogOn3(params);
	}
	
	function makeContentsStr(){
		return $('#contentsWrap').html();
	}
	
	function outProcessLogOn3(params){
		var form = $('#outProcessFormData');
		var url = "http://10.10.10.82/gw/outProcessLogOn.do"; 
		if(location.host.indexOf("127.0.0.1") > -1 || location.host.indexOf("localhost") > -1){
	    	form.prop("action", "http://10.10.10.199/gw/outProcessLogOn.do");
	    }else{
	    	form.prop("action", "/gw/outProcessLogOn.do");
	    	url  = "/gw/outProcessLogOn.do";
	    }
		
		outProcessDocInterlockInsert(params);
		
		url = makeParames(params, form, url);
		url = url.replace("&", "?");
		
		var options = "width=965, height=900, resizable=yes, scrollbars = yes, status=no, top=50, left=50";
		
		openDialog(url, 'viewer', options, function(win) {
			searchMainGrid();
		});
	}
	
	var openDialog = function(uri, name, options, closeCallback) {
	    var win = window.open(uri, name, options, 'newWindow');
	    var interval = window.setInterval(function() {
	        try {
	        	console.log('돌아돌아');
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
<body>
<div class="iframe_wrap">
	<div class="sub_title_wrap">
		<div class="title_div">
			<h4>일계표</h4>
		</div>
	</div>
	
	<div class="sub_contents_wrap" style="width: 1120px;">
		<div class="com_ta">
			<div class="top_box gray_box" id = "dataBox">
				<dl>
					<dt>기준년월</dt>
					<dd style="width:15%">
						<input type="text" style="" id = "standardDate" style = "" value=""/>
					</dd>
					<dt>단위구분</dt>
					<dd style="width:15%">
						<input type="text" style="" id = "status" value="" />
					</dd>
				</dl>
			</div>
		</div>
				
		<div class="btn_div mt10 cl">
			<div class="left_div">
				<p class="tit_p mt5 mb0" id="tlt">일계표</p>
			</div>
			<div class="right_div">
				<div class="controll_btn p0">
					<button type="button" id="" onclick = "resDocSubmit()">기안하기</button>
					<button type="button" id="" onclick = "searchMainGrid()">조회</button>
				</div>
			</div>
		</div>
		
		<div class="com_ta2" style="height: 1220px;">
			<div  id = "mainGrid">
			</div>
		</div>
	</div>
</div>

<div style="padding: 50px;">
	<div id="contentsWrap" style="display:none; height: 1000px;">
		<table style="width: 100%;">
 			<colgroup>
 				<col width="10%"/>
 				<col width="10%"/>
 				<col width="78%"/>
 				<col width="1%"/>
 				<col width="1%"/>
 			</colgroup>
 			<tbody>
 				<tr>
 					<td></td>
 					<td></td>
 					<td rowspan="2" style="font-size: 18pt;text-indent: 28px;font-weight: bold;text-align: left; padding-left: 141px;">
 						&nbsp;&nbsp;&nbsp;&nbsp;일 계 표
 						<br/>
 						<span style="display: inline-block;background-color: gray;width: 155px;height: 2px;margin-left: 50px;"></span>
 						<br/>
 						<span style="display: inline-block;background-color: black;width: 157px;height: 2px;margin-left: 49px;"></span>
 						<br/>
 						<span id="gigan" style="font-size: 10pt;font-weight: 100;text-align: left;"></span>
 						<br/>
 						<span id="moneyUnit" style="font-size: 10pt;font-weight: 100;text-align: left; margin-left: 435px;"></span>
 					</td>
 					<td></td>
 					<td></td>
 				</tr>
 				<tr>
 					<td></td>
 					<td></td>
 					<td rowspan="2" style="font-size: 18pt;text-indent: 50px;font-weight: bold;text-align: left;">
 						<br/><br/>
 					</td>
 					<td></td>
 					<td></td>
 				</tr>
 			</tbody>
 		</table>
		<table style="width: 100%;">
			<colgroup>
				<col width="14%"/>
				<col width="14%"/>
				<col width="14%"/>
				<col width="16%"/>
				<col width="14%"/>
				<col width="14%"/>
				<col width="14%"/>
			</colgroup>
			<tbody id="adocuDTbody">
			<tr class="fixed">
 				<td colspan="3" style="font-size: 10pt;border-top: 2px solid;border-left: 2px solid;border-bottom: 1px solid;border-right: 1px solid;text-align: center;vertical-align: middle;height: 20px;">차&nbsp;&nbsp;&nbsp;&nbsp;변</td>
 				<td rowspan="2" style="font-size: 10pt;border-top: 2px solid;border-left: 2px solid;border-bottom: 1px solid;border-right: 2px solid;text-align: center;vertical-align: middle;height: 20px;">계&nbsp;&nbsp;&nbsp;정&nbsp;&nbsp;&nbsp;과&nbsp;&nbsp;&nbsp;목</td>
 				<td colspan="3" style="font-size: 10pt;border-top: 2px solid;border-left: 2px solid;border-bottom: 1px solid;border-right: 1px solid;text-align: center;vertical-align: middle;height: 20px;">대&nbsp;&nbsp;&nbsp;&nbsp;변</td>
 			</tr>
 			<tr class="fixed">
 				<td style="font-size: 10pt;border-top: 2px solid;border-left: 2px solid;border-bottom: 1px solid;border-right: 1px solid;text-align: center;vertical-align: middle;height: 20px;">&nbsp;&nbsp;계&nbsp;&nbsp;</td>
 				<td style="font-size: 10pt;border-top: 2px solid;border-left: 2px solid;border-bottom: 1px solid;border-right: 1px solid;text-align: center;vertical-align: middle;height: 20px;">대&nbsp;&nbsp;&nbsp;&nbsp;체</td>
 				<td style="font-size: 10pt;border-top: 2px solid;border-left: 2px solid;border-bottom: 1px solid;border-right: 1px solid;text-align: center;vertical-align: middle;height: 20px;">현&nbsp;&nbsp;&nbsp;&nbsp;금</td>
 				<td style="font-size: 10pt;border-top: 2px solid;border-left: 2px solid;border-bottom: 1px solid;border-right: 1px solid;text-align: center;vertical-align: middle;height: 20px;">현&nbsp;&nbsp;&nbsp;&nbsp;금</td>
 				<td style="font-size: 10pt;border-top: 2px solid;border-left: 2px solid;border-bottom: 1px solid;border-right: 1px solid;text-align: center;vertical-align: middle;height: 20px;">대&nbsp;&nbsp;&nbsp;&nbsp;체</td>
 				<td style="font-size: 10pt;border-top: 2px solid;border-left: 2px solid;border-bottom: 1px solid;border-right: 1px solid;text-align: center;vertical-align: middle;height: 20px;">&nbsp;&nbsp;계&nbsp;&nbsp;</td>
 			</tr>
			</tbody>
		</table>
		<div style="text-align: right;padding-top: 20px;font-size: 11pt;">농림수산식품교육문화정보원</div>
	</div>
</div>

<div class="pop_wrap_dir" id="loadingPop" style="width: 443px;">
	<div class="pop_con">
		<table class="fwb ac" style="width:100%;">
			<tr>
				<td>
					<span class=""><img src="<c:url value='/Images/ico/loading.gif'/>" alt="" />  &nbsp;&nbsp;&nbsp;데이터를 가져오는 중입니다. </span>		
				</td>
			</tr>
		</table>
	</div>
</div>

<input type="hidden" id="compSeq" value="${userInfo.compSeq }">
	<input type="hidden" id="erpCoCd" value="${userInfo.erpCoCd }">
	<input type="hidden" id="empSeq" value="${userInfo.uniqId }">
	<input type="hidden" id="deptSeq" value="${userInfo.orgnztId }">
</body>

