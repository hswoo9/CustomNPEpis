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
<script type="text/javascript"	src='<c:url value="/js/ac/acUtil.js"></c:url>'></script>
<script type="text/javascript"	src="<c:url value='/js/jquery.form.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/jszip.min.js' />"></script>
<script type="text/javascript"	src="<c:url value='/js/shieldui-all.min.js' />"></script>
<script type="text/javascript"	src="<c:url value='/js/budget/budgetUtil.js' />"></script>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title></title>
</head>

<script type="text/javascript">
	var selRow = '';
	var selCardNum = ''; // 선택 된 카드번호
	
	$(function() {
		Init.kendoFunction();
		Init.kendoGrid();
		Init.eventListener();
	})

	var Init = {

		kendoGrid : function() {
			
			var mainGrid = $("#mainGrid").kendoGrid({
				dataSource : new kendo.data.DataSource({
					serverPaging : true,
					transport : {
						read : {
							url : _g_contextPath_ + "/resAlphaG20/selectCardInfoList",
							dataType : "json",
							type : "post"
						},
						parameterMap : function(data, operation) {
							data.searchWord = $("#searchWord").val(); // 카드명
							data.isOpen = $("#isOpen").data("kendoComboBox").value();
							return data;
						}
					},
					schema : {
						data : function(response) {
							return response.list;
						},
						total : function(response) {
							return response.total;
						}
					}
				}),
				dataBound : cardGridDataBound,
				height : 600,
				sortable : true,
				persistSelection : true,
				selectable : "multiple",
		        columns: [
		        	{
						field : "cardNum",
						title : "카드번호",
						width : 100
					},{
						field : "cardName",
						title : "카드명",
						width : 100
					},{
						field : "partnerName",
						title : "금융거래처",
						width : 100
					},{
						template : function(dataItem) {
							if (dataItem.cardPublicJson === "") {
								return "<span style='color : red;'>미설정</span>";
							} else {
								return "<span>설정</span>";
							}
						},
						title : "공개범위 설정여부",
						width : 100
					}
				]
		    }).data("kendoGrid");
			
			var empGrid = $("#empGrid").kendoGrid({
		        dataSource: new kendo.data.DataSource({
		        	serverPaging: true,
		        	pageSize: 10,
		            transport: { 
		                read:  {
		                    url: _g_contextPath_+'/common/empInformation',
		                    dataType: "json",
		                    type: 'post'
		                },
		              	parameterMap: function(data, operation){
		                	data.emp_name = $('#emp_name').val();
		                	data.deptSeq = '';
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
		        }),
		        height: 500,
		        width: 400,
		        sortable: true,
		        pageable: {
		            refresh: true,
		            pageSizes: true,
		            buttonCount: 5
		        },
		        persistSelection: true,
		        selectable: "multiple",
		        columns:[ {field: "emp_name",
					            title: "이름",
						    },{field: "dept_name",
					            title: "부서",
					        },{field: "position",
					            title: "직급",
		        		    }, {field: "duty",
		            		    title: "직책",
		        		    }, {title : "선택",
							    template : '<input type="button" id="" class="text_blue" onclick="empSelect(this);" value="등록">'
		        		    }],
		        change: function (e){
		        }
		    }).data("kendoGrid");
		},

		kendoFunction : function() {

			$("#isOpen").kendoComboBox({
			      dataSource: [
			    	  { value : 0, text : "전체" }
			    	  ,{ value : 1, text : "전송" }
			    	  ,{ value : 2, text : "미전송" }
			      ],
			      dataTextField: "text",
				  dataValueField: "value",
				  width: 30,
				  index: 0,
			});
			
			$("#empPopUp").kendoWindow({
				width : "1170px",
				height : "750px",
				visible : false,
				actions : [ "Close" ]
			}).data("kendoWindow").center();
		},

		eventListener : function() {
			$(document).on("click",	"#mainGrid tbody tr", function(e) {
				row = $(this)
				grid = $('#mainGrid').data("kendoGrid"),
				dataItem = grid.dataItem(row);
				
				selCardNum = dataItem.cardNum;
				getCardNotionInfo();
				$("#empPopUp").data("kendoWindow").open();
			});
			
			$(document).on("mouseover", "#mainGrid tbody tr", function(e) {
				
				$(this).css("color", "blue").css("font-weight", "bold");
				
			});
			
			$(document).on("mouseout", "#mainGrid tbody tr", function(e) {
				
				$(this).css("color", "black").css("font-weight", "normal");
				
			});

			$("#empSearch").click(function() {
				$('#emp_name').val("");
				$('#selectedEmpName').val('');
				$("#empPopUp").data("kendoWindow").open();
				empGridReload();
			});

			$("#empPopUpCancel").click(function() {
				$("#empPopUp").data("kendoWindow").close();
			});

			$("#emp_name").on("keyup", function(e) {
				if (e.keyCode === 13) {
					empGridReload();
				}
			});
			
			$("#searchWord").on("keyup", function(e) {
				if (e.keyCode === 13) {
					fn_searchBtn();
				}
			});
		}
	}

	function cardGridDataBound(e) {
		var grid = e.sender;

		if (grid.dataSource.total() == 0) {
			var colCount = grid.columns.length;
			$(e.sender.wrapper)
					.find('tbody')
					.append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
		}
	}

	function empGridReload() {
		$('#empGrid').data('kendoGrid').dataSource.read(0);
	}

	//선택 클릭이벤트
	function empSelect(e) {
		var row = $("#empGrid").data("kendoGrid").dataItem($(e).closest("tr"));
		
		var html = "<td>" + row.dept_name + "</td>";
			  html +=	"<td>" + row.emp_name + "</td>";
			  html +=	"<td>" + row.duty + "</td>";
			  html +=	"<td><input type='button' class='blue_btn' value='삭제' onclick='deleteNotionEmp(\"" + row.emp_seq + "\", this)'/></td>";
		
		if (saveNotionEmp(row)) {
				  
			$("#finalTable tfoot > tr").empty();
			$("#finalTable tbody").append("<tr>" + html + "</tr>");
		}	  
	}

	function empPopUpClose() {
		$("#empPopUp").data("kendoWindow").close();
	}

	function mainGridDataBound(e) {
		var grid = e.sender;

		if (grid.dataSource.total() == 0) {
			var colCount = grid.columns.length;
			$(e.sender.wrapper)
					.find('tbody')
					.append(
							'<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
		}
	}

	function fn_searchBtn() {
		$('#mainGrid').data('kendoGrid').dataSource.read(0);
	}
	
	function saveNotionEmp(row) {
		
		var isSucc = true;
		var data = {
				cardNum : selCardNum.replace(/-/gi, ''),
				empSeq : row.emp_seq,
				empName : row.emp_name,
				deptSeq : row.dept_seq,
				deptName : row.dept_name,
				duty : row.duty,
				notionDate : 0,
		}
		
		$.ajax({
			url : "<c:url value='/resAlphaG20/saveCardNotionInfo' />",
			data : data,
			type : 'POST',
			async : false,
			success : function(result) {
				if (result.isSucc) {
			
				} else {
					isSucc = false;
				}
			}	
		});
		
		return isSucc;
	}
	
	function getCardNotionInfo() { // 알림 등록 리스트 가져오기
		
		var data = {
				cardNum : selCardNum,
				emp_seq : ''
		}
		
		$.ajax({
			url : "<c:url value='/resAlphaG20/selectCardNotionInfoList' />",
			data : data,
			type : 'POST',
			async : false,
			success : function(result) {
				
				var row = result.list;
				var html = '';
				
				$("#finalTable tfoot > tr").empty();
				$("#finalTable tbody").empty();
				
				row.forEach(function(v, i) {
					html += "<tr>";
					html += "<td>" + v.deptName + "</td>";
					html +=	"<td>" + v.empName + "</td>";
					html +=	"<td>" + v.duty + "</td>";
					html +=	"<td><input type='button' class='blue_btn' value='삭제' onclick='deleteNotionEmp(\"" + v.empSeq + "\", this)'/></td>";
					html += "</tr>";
				})
				
				$("#finalTable tbody").append("<tr>" + html + "</tr>");
			}	
		});
	}
	
	function deleteNotionEmp(empSeq, thisObj) {
		
		var data = {
				cardNum : selCardNum,
				empSeq : empSeq
		}
		
		$.ajax({
			url : "<c:url value='/resAlphaG20/deleteCardNotionInfo' />",
			data : data,
			type : 'POST',
			async : false,
			success : function(result) {
				$(thisObj).closest("tr").remove();
			}	
		});
	}
	
	function fn_applyCycle() {
		
		var data = {
				interface_type : 'card',
				cycle : $("#cycle").val(),
		}
		
		$.ajax({
			url : "<c:url value='/resAlphaG20/saveCardNotionCycle' />",
			data : data,
			type : 'POST',
			async : false,
			success : function(result) {
				alert("알림 기한이 설정되었습니다.");
			}	
		});
	}
	
</script>

<body>
	<div class="iframe_wrap" style="min-width: 1070px;">
		<div class="sub_title_wrap">
			<div class="title_div">
				<h4></h4>
			</div>
			<div class="sub_contents_wrap">
				<p class="tit_p mt5 mt20" style="width: 90%"></p>
				<div class="top_box" style="width: 90%">
					<dl>
						<dt class="ar" style="width: 55px;">검색어</dt>
						<dd>
							<input type="text" id="searchWord" style="width: 200px;"/>
						</dd>
						<dt class="ar" style="width: 150px;">공개범위 설정여부</dt>
						<dd>
							<input type="text" id="isOpen"/>
						</dd>
						<dd>
							<button type="button" class="blue_btn" id="searchBtn" onclick="fn_searchBtn();">검색</button>
						</dd>
						<dt class="ar" style="width: 150px;">알림 기한 설정</dt>
						<dd>
							<input type="text" id="cycle" style="width: 30px;" value="${cycle }" numberOnly/>
							<dt class="ar" style="margin-left: 0px;">일</dt>
						</dd>
						<dt class="ar">
							<button type="button" class="blue_btn" id="applyCycle" onclick="fn_applyCycle();">적용</button>
						</dt>
					</dl>
				</div>
				<div class="com_ta2 mt15" style="width: 90%;">
					<div id="mainGrid"></div>
				</div>
			</div>
		</div>
	</div>

	<!-- 사원검색팝업 -->
	<div class="pop_wrap_dir" id="empPopUp" style="width: 1170px;">
		<div class="pop_head">
			<h1>사원 선택</h1>
		</div>
		<div class="pop_con" style="width:600px; display:inline-block;">
			<div class="top_box">
				<dl>
					<dt class="ar" style="width: 65px;">성명</dt>
					<dd>
						<input type="text" id="emp_name" style="width: 120px" />
					</dd>
					<dd>
						<input type="button" onclick="empGridReload();" id="searchButton"	value="검색" />
					</dd>
				</dl>
			</div>
			<div class="com_ta mt15" style="">
				<div id="empGrid"></div>
			</div>
		</div>
		
		<div style="display:inline-block; width:494px; height: 590px; position: absolute; margin-top: 16px;">
			<div class="top_box" style="display:inline-block; width:100%;">
				<dl>
					<dt class="ar" style="width: 56%; color:#058df5;">알림 등록 목록 </dt>
				</dl>
			</div>
			<div class='com_ta mt15 tb_box' style="overflow: scroll; height: 515px;">
				<table id="finalTable" style="width: 100%;">
				<colgroup>
					 <col width="11%"/>
					 <col width="10%"/>
					 <col width="10%"/>
					 <col width="9%"/>
				</colgroup>
				<thead>
					<tr style="height: 37px;">
						<th style="background-color: #f0f6fd;  padding-right:0px;   text-align: center;">부서</th>
						<th style="background-color: #f0f6fd;  padding-right:0px;   text-align: center;">이름</th>
						<th style="background-color: #f0f6fd;  padding-right:0px;   text-align: center;">직책</th>
						<th style="background-color: #f0f6fd;  padding-right:0px;   text-align: center;">삭제</th>
					</tr>
				</thead>
				<tbody style="text-align: center;">
				</tbody>
				<tfoot>
					<tr>
						<td colspan="8" style="text-align: center;">사원을 등록해주세요.</td>
					</tr>
				</tfoot>
				</table>
			</div>
		</div>

		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" class="gray_btn" id="empPopUpCancel" value="닫기" />
			</div>
		</div>
	</div>
	<!-- 사원검색팝업 -->

</body>
</html>

