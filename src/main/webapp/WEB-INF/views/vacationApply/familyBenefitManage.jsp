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
<script type="text/javascript" src="<c:url value='/js/jszip.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/jquery.number.min.js' />"></script>

<style>
dt {
	text-align : center;
	width : 100px;
}
input{
	text-align : center;
}

table {
	border-style : solid;
	border-width : 1px;
	border-color : rgb(234,234,234);
}

.com_ta3 table td .k-reset{
	float : left;
	padding-left : 50px;
}

.k-grid tbody tr{height:25px;}
.k-group-cell{hidden:true;}
</style>


<body>

<script type="text/javascript">

var $family_code = JSON.parse('${family_code}');
var $family_apply_id = '';
var $rowData = {};					//그리드한줄정보
var $gridIndex = 0;					//그리드인덱스번호
var $insertChk = true;				//신청화면 insert/update 구분
var $addIndex = 0;					//팝업그리드 인덱스
var $empRowData = [];			//신청자사원정보
var $scholarRegisterData;		//학자금상세정보데이터
var $dataSource = new kendo.data.DataSource({		//그리드데이터소스
	serverPaging : true,
	pageSize : 1000000,
	transport : {
		read : {
			url : _g_contextPath_+ "/vacationApply/getBenefitTypeList",
			dataType : "json",
			type : "post"
		},
		parameterMap: function(data, operation) {
			
			data.request_emp_seq = $("#empSeq").val();
			data.request_emp_name = $("#empName").val();
			data.benefit_type = '1';
			data.apply_from_date = $("#apply_from_date").val().replace(/-/gi,'');
			data.apply_to_date = $("#apply_to_date").val().replace(/-/gi,'');
			
			
			var from = $("#apply_from_date").val().replace(/-/gi,'');
			var to = $("#apply_to_date").val().replace(/-/gi,'');
			var from_year = from.substring(0,4)*1;
			var from_month = from.substring(4,6)*1;
			var yearTime = to.substring(2,4)*1 - from.substring(2,4)*1;
			var monthTime = to.substring(4,6)*1 - from.substring(4,6)*1;
			
			var sql_part1 = "SELECT AA.*";
			var sql_part2 = ", IFNULL(";
			var sql_part3 = "FROM (SELECT * FROM dj_benefit_manage_batch where benefit_type = '1' AND payday BETWEEN '"+from+"' AND '"+to+"' GROUP BY emp_seq, family_name) AA LEFT JOIN ";
			var alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
			
			for (var i = 0; i <= yearTime*12+monthTime; i++) {
				
				var now_al = '';
				if(i <26){
					now_al = alphabet[i];
				}else{
					now_al = alphabet[i-26] + i;
				}
				if(from_month == 13){
					from_year += 1;
					from_month = 1;
				}
				if((from_month+'').length == 1){
					from_month = '0'+from_month; 
				}
				var now = ''+ from_year + from_month;
				sql_part1 += ", IFNULL("+now_al+".account,0) as 'account"+now+"', IFNULL("+now_al+".payday,'"+now+"') as 'payday"+now+"'";
				sql_part2 += "IFNULL("+now_al+".account,0)+";
				sql_part3 += "(SELECT * FROM dj_benefit_manage_batch WHERE payday = '"+now+"') "+now_al+" ON "+now_al+".relationship_code = AA.relationship_code  AND "+now_al+".emp_seq = AA.emp_seq AND "+now_al+".number = AA.number AND "+now_al+".benefit_type = AA.benefit_type LEFT JOIN";
				from_month++;
				
			}
			sql_part2 = sql_part2.substring(0,sql_part2.length-1);
			sql_part2 +=", 0) AS SUM "
			sql_part3 = sql_part3.substring(0,sql_part3.length-10);
			data.sql = sql_part1 + sql_part2 + sql_part3;

	     	return data;
	     }
	},
	group : [
// 		{field : 'payday', aggregates : [{field:'account', aggregate:'sum'}, {field:'account', aggregate:'max'}]},
		{field : 'emp_name', aggregates : [{field:'SUM', aggregate:'sum'},{field:'SUM', aggregate:'count'}]}
	],
	sort : [{field : 'pay_day'}, {field : 'emp_name'}, {field : 'accumulate', dir:'asc'}],
	schema : {
		data : function(response){
			return response.list;
		},
		total : function(response) {
	        return response.totalCount;
	    },
	    model : {
	    	fields : {
				account : {type : 'number'}
	    	}
	    },
	},
    aggregate : [
    	{field : 'SUM', aggregate : 'sum'}
    ]
});


	$(function(){
		
		$("select").kendoDropDownList({});
		$("#apply_from_date").kendoDatePicker({
		    depth: "year",
		    start: "year",
		    culture : "ko-KR",
			format : "yyyy-MM",
			value : new Date(${year}, 0),
			change : makeToDateMin
		});
		
		$("#apply_to_date").kendoDatePicker({
		    depth: "year",
		    start: "year",
		    min : $("#apply_from_date").data("kendoDatePicker").value(),
		    max : new Date(),
		    culture : "ko-KR",
			format : "yyyy-MM",
			value : new Date()
		});
		
		$("#request_date").kendoDatePicker({
		    depth: "month",
		    start: "month",
		    culture : "ko-KR",
			format : "yyyy-MM-dd",
			value : new Date()
		});

		mainGrid();
		empListPop();
		console.log("${userInfo}");

	});
	
	function makeToDateMin(){		
		
		$("#apply_to_date").data("kendoDatePicker").setOptions({
		    min: $("#apply_from_date").data("kendoDatePicker").value()
		});
	}
	
	function empRowDataSet(){
		if($empRowData.length<1){
			
			$.ajax({
					url : _g_contextPath_+'/common/selectEmp',
					data : {empSeq : '${userInfo.empSeq}', skip:0, pageSize:1},
					type : "POST",
					async : false,
					success : function(result){
						
						$.ajax({
							url : _g_contextPath_+'/common/empInformation',
							data : {emp_name : result.list[0].emp_name, skip:0, pageSize:1},
							type : "POST",
							async : false,
							success : function(result){
								
								if(result.list.length >0){
									$empRowData = result.list[0];
								}
							}
						});
					}
				});
		}
	}

	function mainGrid(){
		
		var column = [
		{
			width : "15%",
			field : "emp_name",
			title : "신청자",
			groupFooterTemplate : function(e){
// 				if(e.account.max){
// 					return '당월 총 합계';
// 				}else{
					return '개인합계';
// 				}
			},
			footerTemplate : function(e){
				return '총 합계';
			}
		},
		{
			width : "15%",
			field : "relationship_name",
			title : "관계",	
		},
		{
			width : "15%",
			field : "family_name",
			title : "가족명",
			groupFooterTemplate : function(e){
					return '총가족수 : ' +kendo.toString(e.SUM.count,'n0');
			},
		},]
		
		var aggregate = [
			{field:'SUM', aggregate:'sum'}, {field:'SUM', aggregate:'count'}
		];
		
		var from = $("#apply_from_date").val().replace(/-/gi,'');
		var to = $("#apply_to_date").val().replace(/-/gi,'');
		var from_year = from.substring(0,4)*1;
		var from_month = from.substring(4,6)*1;
		var yearTime = to.substring(2,4)*1 - from.substring(2,4)*1;
		var monthTime = to.substring(4,6)*1 - from.substring(4,6)*1;
		var monthArray = [];
		
		for (var i = 0; i <= yearTime*12+monthTime; i++) {
			
			var list = {};
			if(from_month == 13){
				from_year += 1;
				from_month = 1;
			}
			if((from_month+'').length == 1){
				from_month = '0'+from_month; 
			}
			var now = ''+ from_year + from_month;
			var aggreList = {field:'account'+now, aggregate:'sum'}
			aggregate.push(aggreList);
			
			var index = 0;
			monthArray.push(now);
			list.width = '10%';
			list.title = now;
			list.field = 'account'+now;
			list.format = '{0:n0}';
			list.groupFooterTemplate = function(e){
				var key = 'account'+monthArray[index];
				var value = e[key];
				if(index == monthArray.length-1){
					index = 0;
				}else{
					index++;	
				}
				return kendo.toString(e[key].sum,'n0');
			}
			list.footerTemplate = function(e){var key = 'account'+monthArray[index];
			var value = e[key];
			if(index == monthArray.length-1){
				index = 0;
			}else{
				index++;	
			}
			return kendo.toString(e[key].sum,'n0');};
			
			
			column.push(list);
			
			from_month++;
		}

		column.push({width:'10%', title:'가족개별합계', format : '{0:n0}', field : 'SUM'});
		column.push({width:'10%', title:'누적', format : '{0:n0}', field : 'accumulate', groupFooterTemplate : function(e){return kendo.toString(e.SUM.sum,'n0');},footerTemplate : function(e){return kendo.toString(e.SUM.sum,'n0')}});
		
		var grid =  $("#grid").kendoGrid({
			dataSource: new kendo.data.DataSource({		//그리드데이터소스
				serverPaging : true,
				pageSize : 1000000,
				transport : {
					read : {
						url : _g_contextPath_+ "/vacationApply/getBenefitTypeList",
						dataType : "json",
						type : "post"
					},
					parameterMap: function(data, operation) {
						
						data.request_emp_seq = $("#empSeq").val();
						data.request_emp_name = $("#empName").val();
						data.benefit_type = '1';
						data.apply_from_date = $("#apply_from_date").val().replace(/-/gi,'');
						data.apply_to_date = $("#apply_to_date").val().replace(/-/gi,'');
						
						
						var from = $("#apply_from_date").val().replace(/-/gi,'');
						var to = $("#apply_to_date").val().replace(/-/gi,'');
						var from_year = from.substring(0,4)*1;
						var from_month = from.substring(4,6)*1;
						var yearTime = to.substring(2,4)*1 - from.substring(2,4)*1;
						var monthTime = to.substring(4,6)*1 - from.substring(4,6)*1;
						
						var sql_part1 = "SELECT TT.*, (CASE @emp WHEN TT.emp_seq THEN @sum:=@sum+TT.sum ELSE @sum:=sum END) accumulate, (@emp:=TT.emp_seq) emp FROM (SELECT AA.*";
						var sql_part2 = ", IFNULL(";
						var sql_part3 = "FROM (SELECT * FROM dj_benefit_manage_batch where benefit_type = '1' AND payday BETWEEN '"+from+"' AND '"+to+"' GROUP BY emp_seq, family_name) AA LEFT JOIN ";
						var alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
						
						for (var i = 0; i <= yearTime*12+monthTime; i++) {
							
							var now_al = '';
							if(i <26){
								now_al = alphabet[i];
							}else{
								now_al = alphabet[i-26] + i;
							}
							if(from_month == 13){
								from_year += 1;
								from_month = 1;
							}
							if((from_month+'').length == 1){
								from_month = '0'+from_month; 
							}
							var now = ''+ from_year + from_month;
							sql_part1 += ", IFNULL("+now_al+".account,0) as 'account"+now+"', IFNULL("+now_al+".payday,'"+now+"') as 'payday"+now+"'";
							sql_part2 += "IFNULL("+now_al+".account,0)+";
							sql_part3 += "(SELECT * FROM dj_benefit_manage_batch WHERE payday = '"+now+"') "+now_al+" ON "+now_al+".relationship_code = AA.relationship_code  AND "+now_al+".emp_seq = AA.emp_seq AND "+now_al+".number = AA.number AND "+now_al+".benefit_type = AA.benefit_type LEFT JOIN";
							from_month++;
							
						}
						sql_part2 = sql_part2.substring(0,sql_part2.length-1);
						sql_part2 +=", 0) AS SUM "
						sql_part3 = sql_part3.substring(0,sql_part3.length-10);
						sql_part3 += ")TT, (SELECT @emp:='', @sum:=0 FROM DUAL) BB";
						data.sql = sql_part1 + sql_part2 + sql_part3;

				     	return data;
				     }
				},
				group : [
//			 		{field : 'payday', aggregates : [{field:'account', aggregate:'sum'}, {field:'account', aggregate:'max'}]},
					{field : 'emp_name', aggregates : aggregate}
				],
				sort : [{field : 'pay_day'}, {field : 'emp_name'}, {field : 'accumulate', dir:'asc'}],
				schema : {
					data : function(response){
						return response.list;
					},
					total : function(response) {
				        return response.totalCount;
				    },
				    model : {
				    	fields : {
							account : {type : 'number'}
				    	}
				    },
				},
			    aggregate : aggregate
			}),
			height : 650,
			dataBound : dataBound,
			sortable : true,
			pageable : {
				refresh : true,
				pageSizes : true,
				buttonCount : 5
			},
			persistSelection : true,
			selectable : "row",
			columns : column,
			change : selectRow

		}).data("kendoGrid");

		function selectRow(e){		//row클릭시 data 전역변수 처리

			row = e.sender.select();
			grid = $('#grid').data("kendoGrid");
			$rowData = grid.dataItem(row);
// 			subGrid();
			
		}
		
		$("#grid1checkboxAll").click(function(e){
			if($("#grid1checkboxAll").is(":checked")){
				$("#grid .checkbox").prop("checked", true);
			}else{
				$("#grid .checkbox").prop("checked", false);
			}
		});
	};
	
	function gridReload(){
		$gridIndex = 0;
		$("#grid").getKendoGrid().thead.empty();
		mainGrid();
// 		$('#grid').data('kendoGrid').dataSource.read();
// 		$('#grid2').data('kendoGrid').dataSource.read();
		$rowData = {};
	}
	
	function dataBound(e){

		$gridIndex = 0;
		var grid = e.sender;
		if(grid.dataSource.total()==0){
			var colCount = grid.columns.length;
			$(e.sender.wrapper)
				.find('tbody')
				.append('<tr class="kendo-data-row">' + 
						'<td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
		}
	};

//신청자 검색 팝업 함수
	function empListPop(){
		/*
		시간외근무 신청 - 신청자 검색 팝업(#empListPop)
	*/
	var myWindow = $("#empListPop"),
		undo = $("#empListPopBtn");
	undo.click(function(){
		myWindow.data("kendoWindow").open();
		undo.fadeOut();
		empGrid();
	});
	$("#empListPopClose").click(function(){
		myWindow.data("kendoWindow").close();
	});
	myWindow.kendoWindow({
		width: "600px",
		height: "665px",
		visible: false,
		modal: true,
		actions: [
			"Close"
		],
		close: function(){
			undo.fadeIn();
			$("#emp_name").val("");
			$("#dept_name").val("");
		}
	}).data("kendoWindow").center();
	
	function empGridReload(){
		$("#gridEmpList"/* popUpGrid */).data("kendoGrid").dataSource.read();
	}
	$("#empSearchBtn").click(function(){
		empGridReload();
	});
	$(document).on({
		'keyup': function(event){
			if(event.keyCode===13){//enterkey
				empGridReload();
			}
		}
	},".grid_reload");
	
	var empGrid = function(){
		var grid = $("#gridEmpList"/* popUpGrid */).kendoGrid({
			dataSource: new kendo.data.DataSource({
				serverPaging: true,
				pageSize: 10,
				transport: {
					read: {
						url: _g_contextPath_ + '/common/empInformation',
						dataType: 'json',
						type: 'post'
					},
					parameterMap: function(data, operation){
						data.deptSeq = "${empInfo.deptSeq}"; //같은 부서 사람들만 대신 신청 가능
						data.emp_name = $("#emp_name").val();
						data.dept_name = $("#dept_name").val();
						return data;
					}
				},
				schema: {
					data: function(response){
						return response.list;
					},
					total: function(response){
						return response.totalCount;
					}
				}
			}),
			height: 460,
			dataBound: dataBound,
			sortable: true,
			pageable: {
				refresh: true,
				pageSizes: true,
				buttonCount: 5
			},
			persistSelection: true,
			selectable: "multiple",
			columns: [{
				field: "emp_name",
				title: "이름",
				attributes: {
					style: "padding-left: 0 !important"
				}
			},{
				field: "dept_name",
				title: "부서"
			},{
				field: "position",
				title: "직급"
			},{
				field: "duty",
				title: "직책"
			},{
				title: "선택",
				template: '<input type="button" class="text_blue emp_select" value="선택">',
				attributes: {
					style: "padding-left: 0 !important"
				}
			}],
			change: function(e){
				//codeGridClick(e)
			}
		}).data("kendoGrid");
		
		function codeGridClick(){
			var rows = grid.select();
			var record;
			rows.each(function(){
				record = grid.dataItem($(this));
				console.log(record);
			}); 
		}
		$(document).on('click', ".emp_select", function(){
			var row = $("#gridEmpList").data("kendoGrid").dataItem($(this).closest("tr"));
			$empRowData = row;
			$("#empNo").val(row.erp_emp_num);
			$("#empSeq").val(row.emp_seq);
			$("#empName").val(row.emp_name);
			$("#empDept").val(row.dept_name);
			$("#empDuty").val(row.duty);
			

			myWindow.data("kendoWindow").close();
			$familyInfo = [];
			gridReload();
		});
	}
}
	
	function excel(){
		
	      var rows = [];
	      var columns = [{width:100},{width:100},{width:100},];
	      
	      var titleCells = [
	        	{
		        	  background : "#FFCCCC", bold: true
		        	  , value: "신청자"
		        	  , vAlign: "center"
		        	  , hAlign: "center"
		        	  , borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" }
	        	  },
		        	{
		        	  background : "#FFCCCC", bold: true
		        	  , value: "가족관계"
		        	  , vAlign: "center"
		        	  , hAlign: "center"
		        	  , borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" }
	        	  },
		        	{
		        	  background : "#FFCCCC", bold: true
		        	  , value: "가족성명"
		        	  , vAlign: "center"
		        	  , hAlign: "center"
		        	  , borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" }
	        	  }
	    	  
	      ];
	      
			var from = $("#apply_from_date").val().replace(/-/gi,'');
			var to = $("#apply_to_date").val().replace(/-/gi,'');
			var from_year = from.substring(0,4)*1;
			var from_month = from.substring(4,6)*1;
			var yearTime = to.substring(2,4)*1 - from.substring(2,4)*1;
			var monthTime = to.substring(4,6)*1 - from.substring(4,6)*1;
			var monthArray = [];
			
			for (var i = 0; i <= yearTime*12+monthTime; i++) {
				
				var list = {};
				if(from_month == 13){
					from_year += 1;
					from_month = 1;
				}
				if((from_month+'').length == 1){
					from_month = '0'+from_month; 
				}
				var now = ''+ from_year + from_month;
				monthArray.push(now);
				from_month++;
			}
	      $.each(monthArray, function(i,v){
	    	  
	    	  titleCells.push({
	        	  background : "#FFCCCC", bold: true
	        	  , value: v
	        	  , vAlign: "center"
	        	  , hAlign: "center"
	        	  , borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" }
        	  })
        	  columns.push({width:100});
	      })
	      titleCells.push({
        	  background : "#FFCCCC", bold: true
        	  , value: '기간합계'
        	  , vAlign: "center"
        	  , hAlign: "center"
        	  , borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" }
       	  });
	      columns.push({width:100});
	      titleCells.push({
        	  background : "#FFCCCC", bold: true
        	  , value: '누적'
        	  , vAlign: "center"
        	  , hAlign: "center"
        	  , borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" }
       	  })
       	  columns.push({width:100});
 	  	  titleCells.push({
        	  background : "#FFCCCC", bold: true
        	  , value: '가족개별합계'
        	  , vAlign: "center"
        	  , hAlign: "center"
        	  , borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" }
       	  })
       	  columns.push({width:100});
      	  titleCells.push({
        	  background : "#FFCCCC", bold: true
        	  , value: '총합계'
        	  , vAlign: "center"
        	  , hAlign: "center"
        	  , borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" }
       	  })
	      columns.push({width:100});
       	  rows.push({cells : titleCells});
				
		    $("#grid").data("kendoGrid").dataSource;
		    $("#grid").data("kendoGrid").dataSource.sort();
	      	var view = $("#grid").data("kendoGrid").dataSource.view();
	      	var total = 0;
	      	var excelData = [];
	      	var empLength = [];

	      	for (var i = 0; i < view.length; i++) {
				var payday = view[i].value;
				total += view[i].aggregates.SUM.sum;
				var items = view[i].items;
				empLength.push(items.length);
				for (var j = 0; j < items.length; j++) {
					var emp_name = items[j].value;
					var empTotal = items[j].SUM.sum;
					var items_items = items[j].items;
					excelData.push(items[j]);
				}
			}

	      	var empLength = [];
	      	var empSumData = [];
	      	var empSum = 0;
	      	var empChk = '';
	      	var empCount = 0;
		    
	      	$.each(excelData, function(i,v){
	      		
	      		if(i == 0){empChk = v.emp_name;};
	      		
	      		if(empChk != v.emp_name){
	      			empSumData.push(empSum);
	      			empLength.push(empCount);
	      			empCount = 0;
	      			empSum = 0;
	      			empChk = v.emp_name;
	      		}
	      		empSum += v.account;
	      		empCount++;

	      		if(i == excelData.length-1){
	      			empSumData.push(empSum);
	      			empLength.push(empCount);
	      			empCount = 0;
	      			empSum = 0;
	      			empChk = '';
	      		}
	      	})


	      	
		      var finalData = [];
		      
		      $.each(excelData, function(i,v){
		    
		    	  
		    	  var rowData = [
		    		  { value: v.relationship_name,vAlign: "center", hAlign: "center", borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" } },
		    		  { value: v.family_name,vAlign: "center", hAlign: "center", borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" } },
		    	  ];
		    	  
		    	  $.each(monthArray, function(a,b){
		    		  rowData.push({ value: v['account'+b],vAlign: "center", hAlign: "center", borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" } });
		    	  })
		    	  
		    	  rowData.push({ value: v.SUM,vAlign: "center", hAlign: "center", borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" } });
		    	  rowData.push({ value: v.accumulate,vAlign: "center", hAlign: "center", borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" } });
		    	  
		    	  
		    	  if(empChk != v.emp_name){
		    		  empChk = v.emp_name;
		    		  rowData.unshift({ rowSpan: empLength[empCount],value: v.emp_name,vAlign: "center", hAlign: "center", borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" } });
		    		  rowData.push({ rowSpan: empLength[empCount],value: empSumData[empCount],vAlign: "center", hAlign: "center", borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" } });
		    		  empCount++;
		    	  }
		    	  
		    	  if(i == 0){
		    		  rowData.push({ rowSpan: excelData.length,value: total,vAlign: "center", hAlign: "center", borderTop: { color: "#000000" },borderBottom: { color: "#000000" },borderLeft: { color: "#000000" },borderRight: { color: "#000000" } })
		    	  }
		    	  finalData.push(rowData);
		      })

		    for (var i = 0; i < finalData.length; i++) {
		    	  rows.push({
		    		  cells : finalData[i]
		    	  })
			}
		      
	        var workbook = new kendo.ooxml.Workbook({
	          sheets: [
	            {
	            	 freezePane: {
	 	    	        rowSplit: 1
	 	    	      },
	              columns: columns,
	              // Title of the sheet
	              title: "test",
	              // Rows of the sheet
	              rows: rows
	            }
	          ]
	        });
	        //save the file as Excel file with extension xlsx
	        kendo.saveAs({dataURI: workbook.toDataURL(), fileName: "부양가족수당관리("+$("#apply_from_date").val().replace(/-/gi,'')+'-'+$("#apply_to_date").val().replace(/-/gi,'')+").xlsx"});
			

	}

</script>


<div class="iframe_wrap">
	<div class="sub_title_wrap">
		<div class="title_div">
			<h4>부양가족수당관리</h4>
		</div>
	</div>
	<div class="sub_contents_wrap">
		<div class="btn_div mt10 cl">
			<div class="left_div">
				<p class="tit_p mt5 mb0">부양가족수당관리</p>
			</div>
			<div class="right_div">
				<div class="controll_btn p0">
<!-- 					<button type="button" id="approvalChk" onclick = "approvalChk()">결재보기</button> -->
					<button type="button" id="mainGrid" onclick = "gridReload()">조회</button>
					<button type="button" id="delete" onclick = "excel()">엑셀</button>
<!-- 					<button type="button" id="apply" onclick = "apply('new')">신청</button> -->
				</div>
			</div>
		</div>
		<div class="com_ta">
			<div class="top_box gray_box" id = "dataBox">
				<dl>
					<dt>
<%-- 						<img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> --%>
						기간
					</dt>
					<dd>
						<input type="text" id = "apply_from_date" name = "" check="must" value = ""/>&nbsp;~
						<input type="text" id = "apply_to_date" name = "" check="must" value = ""/>
					</dd>
				</dl>
			</div>
		</div>
		
		<div class="com_ta3">
			<div  id = "grid">
			</div>
		</div>
		
	</div>
	
</div>

<!-- 신청자 검색 팝업  -->
<div class="pop_wrap_dir" id="empListPop" style="width:600px;">
	<div class="pop_head">
		<h1>사원리스트</h1>
	</div>
	<div class="pop_con">
		<div class="top_box">
			<dl>
				<dt class="ar" style="width:65px;">성명</dt>
				<dd>
					<input type="text" id="emp_name" class="grid_reload" style="width:120px;">
				</dd>
				<dt style="width:65px;">부서</dt>
				<dd>
					<input type="text" id="dept_name" class="grid_reload" style="width:120px;">
					<input type="button" id="empSearchBtn" value="검색">
				</dd>
			</dl>
		</div>
		<div class="com_ta mt15">
			<div id="gridEmpList"></div>
		</div>
	</div>
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" class="gray_btn" id="empListPopClose" value="닫기">
		</div>
	</div>
</div>
<!-- 신청자 검색 팝업 끝  -->

</body>
