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

.k-grid tbody tr{height:38px;}
</style>


<body>

<script type="text/javascript">

var $family_code = JSON.parse('${family_code}');

// $familyInfo = $.each($familyInfo, function(i,v){
	
// 	$.each($codeList.list, function(a,b){
// 		if(v.CD_RELA == b.relationship_id){
// 			v.rela_name = b.relationship_name;
// 			return;
// 		}
// 	})
// })
var $benefit_master_main_id = '';
var $rowData = {};					//그리드한줄정보
var $gridIndex = 0;					//그리드인덱스번호
var $insertChk = true;				//신청화면 insert/update 구분
var $addIndex = 0;					//팝업그리드 인덱스
var $empRowData = [];			//신청자사원정보
var $deleteData = [];
var $dataSource = new kendo.data.DataSource({		//그리드데이터소스
	serverPaging : true,
	pageSize : 10,
	transport : {
		read : {
			url : _g_contextPath_+ "/vacationApply/benefitList",
			dataType : "json",
			type : "post"
		},
		parameterMap: function(data, operation) {
			
			data.apply_from_date = $("#apply_from_date").val().replace(/-/gi,'');
			data.apply_to_date = $("#apply_to_date").val().replace(/-/gi,'');
// 			data.benefit_type = $("#benefit_type_search").data("kendoDropDownList").vauel();
			
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

var $grid2DataSource = new kendo.data.DataSource({
	serverPaging : true,
	pageSize : 5,
	transport : {
		read : {
// 			url : _g_contextPath_+ "/vacationApply/familyApplyDetailList",
			url : _g_contextPath_+ "/vacationApply/benefitDetailList",
			dataType : "json",
			type : "post"
		},
		parameterMap: function(data, operation) {
			
			data.benefit_master_main_id = $rowData.benefit_master_main_id;
			
	     	return data;
	     }
	},
	schema : {
		data : function(response){
			return response.list;
		},
	    model : {
	    	fields : {
	    		money : {type : "number", validation: {required: true}}
	    	}
	    }
	}
});

	$(function(){
		
		$("select").kendoDropDownList({});
		$("#apply_from_date").kendoDatePicker({
		    depth: "month",
		    start: "month",
		    culture : "ko-KR",
			format : "yyyy-MM-dd",
			value : new Date(${year}-10, ${mm}-1, ${dd}),
			change : makeToDateMin
		});
		
		$("#apply_to_date").kendoDatePicker({
		    depth: "month",
		    start: "month",
		    min : $("#apply_from_date").data("kendoDatePicker").value(),
		    max : new Date(),
		    culture : "ko-KR",
			format : "yyyy-MM-dd",
			value : new Date()
		});
		
		$("#apply_start_date").kendoDatePicker({
		    depth: "month",
		    start: "month",
		    culture : "ko-KR",
			format : "yyyy-MM-dd",
			value : new Date()
		});
		
		$("#apply_end_date").kendoDatePicker({
		    depth: "month",
		    start: "month",
		    culture : "ko-KR",
			format : "yyyy-MM-dd",
			value : new Date(${year}+10, ${mm}-1, ${dd})
		});

		$("#popUp").kendoWindow({
			resizable: false,
			width : "600px",
			height : "665px",
			visible : false,
			modal : true,
			actions : [ "Close" ],
			close : onClose
		}).data("kendoWindow").center();
		
		$("#close").click(function(){
			$("#popUp").data("kendoWindow").close();
		});
		
		$(".file_input_button").on("click", function(){
			$(this).next().click();
		});

		mainGrid();
		subGrid();
		empListPop();
		console.log("${userInfo}");
		onlyNumber();
	});
	
	function dbclickToApply(){
		var grid = $('#grid').data("kendoGrid");
		var dataItem = grid.dataItem($(".k-state-selected"));
		$("#popUp").data("kendoWindow").open();
		$("#apply").fadeOut();
		
		$("#benefit_type").data("kendoDropDownList").value(dataItem.benefit_type);
		$("#apply_start_date").val(dataItem.apply_start_date_format);
		$("#apply_end_date").val(dataItem.apply_end_date_format);
		$("#subject").val(dataItem.subject);
		
		$insertChk = false;
		empRowDataSet();
		popGrid();
	}
	
	function makeToDateMin(){		
		
		$("#apply_to_date").data("kendoDatePicker").setOptions({
		    min: $("#apply_from_date").data("kendoDatePicker").value()
		});
	}

	function onClose() {
		
		$("#apply").fadeIn();
		gridReload();
		$insertChk = true;
		$gridIndex = 0;
		$addIndex = 0;
		popUpEmpty();
		$benefit_master_main_id = "";
	}

	function apply(type){	//신청 팝업

		$("#popUp").data("kendoWindow").open();
		$("#apply").fadeOut();
		popGrid();
		empRowDataSet();
		$("#benefit_type").data("kendoDropDownList").select(0);
		$("#gridRowAdd").show();
		$("#gridRowDelete").show();

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
	
	function popUpEmpty(){

		$("#benefit_type").data("kendoDropDownList").select(0);
		$(".popInput").val("");	
		$(".personDetail").remove();
	}
	
	function deleteRow(){	//삭제함수
		
		var grid = $('#grid').data("kendoGrid");
		var dataItem = grid.dataItem($(".k-state-selected"));
		
		if(!dataItem){
			alert("삭제할 데이터를 선택해 주십시오.");
			return false;
		}else{
			
			var status = dataItem.status_name;
			var param = { benefit_master_main_id : dataItem.benefit_master_main_id};
			if(confirm("삭제하시겠습니까?")){
				if(status == '신청'){
					
					$.ajax({
						
						url : _g_contextPath_+'/vacationApply/familyApplyDeleteRow',
						data : param,
						type : "POST",
						success : function(result){
							
							if(result){
								alert("삭제완료되었습니다.");
								gridReload();
							}
						}
					});
				}else{
					alert("진행상태가 " +status+"인 경우 삭제가 불가능합니다.");
					return false;
				}
			}
		}
	}
	
	function mainGrid(){
	
		var grid =  $("#grid").kendoGrid({
			dataSource: $dataSource,
			height : 300,
			dataBound : dataBound,
			sortable : true,
			pageable : {
				refresh : true,
				pageSizes : true,
				buttonCount : 5
			},
			persistSelection : true,
			selectable : "row",
			columns : [
				{
					width : "5%",
					title : "번호",
					template : function(){
						return ++$gridIndex;
					}
				},
				{
					field : "benefit_type",
					width : "15%",
					title : "신청타입",
					template : function(e){
						if(e.benefit_type == '1'){
							return '가족수당';
						}else{
							return '복지포인트';
						}
					}
				},
				{
					width : "20%",
					field : "apply_start_date_format",
					title : "적용시작일"
				},
				{
					width : "20%",
					field : "apply_end_date_format",
					title : "적용종료일"
				},
				{
					width : "30%",
					field : "subject",
					title : "제목"
				},
				{
					width : "10%",
					template : function(dataItem){	//진행상태가 미상신일때만 수정가능(더블클릭이벤트설정) 
							if(dataItem.benefit_master_main_id != undefined || dataItem.benefit_master_main_id != null){
								if(dataItem.status_name == '신청'){
									return "<span class = 'benefit_master_main_id' ondblclick = 'dbclickToApply()'>"+dataItem.benefit_master_main_id+"</span>"
								}else{
									return "<span class = 'benefit_master_main_id' ondblclick = 'dbclickToApply()'>"+dataItem.benefit_master_main_id+"</span>"
								}
							}else{
								return "<span class = 'benefit_master_main_id'></span>"
							}
						},
					title : "신청번호"
				}
			],
			change : selectRow

		}).data("kendoGrid");
		
		function selectRow(e){		//row클릭시 data 전역변수 처리

			row = e.sender.select();
			grid = $('#grid').data("kendoGrid");
			$rowData = grid.dataItem(row);
			subGrid();
			
		}
	};
	
	function gridReload(){
		$gridIndex = 0;
		$('#grid').data('kendoGrid').dataSource.read();
		$('#grid2').data('kendoGrid').dataSource.read();
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
	
	function fileDown(attach_file_id){
		
		var file_id = attach_file_id.split(',');
		
// 		for (var i = 0; i < file_id.length; i++) {

			$.ajax({
				url: _g_contextPath_ + '/common/fileDown',
				type: 'get',
				async : false,
				data: {attach_file_id : file_id[i]},
				success: function(data){
					var downWin = window.open('','_self');
					downWin.location.href = _g_contextPath_+'/common/fileDown?attach_file_id='+attach_file_id;
				}
			});
// 		}
	}
	
	function subGrid(){
		
		var grid =  $("#grid2").kendoGrid({
			dataSource: $grid2DataSource,
			sortable : true,
			height : 450,
			persistSelection : true,
			columns : [
// 				{
// 					width : "30px",
// 					headerTemplate : function(e){
// 						return '<input type="checkbox" id = "checkboxAll">';
// 					},
// 					template : function(e){
// 						return '<input type="checkbox" id = "checkbox'+e.user_family_id+'" class = "checkbox">';
// // 						if(e.status == '1'){
// // 							return '<input type="checkbox" id = "checkbox'+e.user_family_id+'" class = "checkbox">';
// // 						}else{
// // 							return "";
// // 						}
// 					}
// 				},
				{
					field : "relationship_name",
					title : "관계"
				},
				{
					field : "account",
					title : "금액",
					format : "{0:n0}"
				},
				{
					field : "number",
					title : "서열"
				}
			]
		});

		$("#checkboxAll").click(function(e){
			if($("#checkboxAll").is(":checked")){
				$(".checkbox").prop("checked", true);
			}else{
				$(".checkbox").prop("checked", false);
			}
		});
		
	}

	function save(sep){
		
		var param = {
				apply_start_date : $("#apply_start_date").val().replace(/-/gi,""),
				apply_end_date : $("#apply_end_date").val().replace(/-/gi,""),
				benefit_type : $("#benefit_type").val(),
				subject : $("#subject").val(),
				create_emp_seq : "${userInfo.empSeq}"
		}
		
		if($insertChk){		//status : insert
			param.status = "insert";
				
				var data = [];
				var apply_family_name = '';
				$("#personDetailTable .personDetail").each(function(i,v){
					var list = {};
					if(param.apply_type == '2'){
						list.user_family_id = $(v).find("[name='user_family_id']").val();
					}
					list.emp_seq = $empRowData.emp_seq;
					list.relationship_code = $(v).find("[name='relationship']").data("kendoDropDownList").value();
					list.relationship_name = $(v).find("[name='relationship']").data("kendoDropDownList").text();
					list.account = $(v).find("[name='account']").val();
					list.number = $(v).find("[name='number']").val();
					list.create_emp_seq = "${userInfo.empSeq}";
					data.push(list);
				})
				param.data = JSON.stringify(data);
		}else{		//status : update
			param.status = "update";
			param.benefit_master_main_id = $rowData.benefit_master_main_id;
				var insertData = [];
				var deleteData = [];
				var updateData = [];
				var apply_family_name = '';
				$("#personDetailTable .personDetail").each(function(i,v){
					var list = {};
					list.benefit_master_detail_id =  $(v).find("[name='benefit_master_detail_id']").val();
					list.benefit_master_main_id = $rowData.benefit_master_main_id;
					list.emp_seq = $empRowData.emp_seq;
					list.relationship_code = $(v).find("[name='relationship']").data("kendoDropDownList").value();
					list.relationship_name = $(v).find("[name='relationship']").data("kendoDropDownList").text();
					list.account = $(v).find("[name='account']").val();
					list.number = $(v).find("[name='number']").val();
					list.create_emp_seq = "${userInfo.empSeq}";
					
					if($(v).find("[name='benefit_master_detail_id']").length >0){
						updateData.push(list);
					}else{
						insertData.push(list);
					}
				})
				
				$("#personDeleteTable .personDetail").each(function(i,v){
					var list = {};
					list.benefit_master_detail_id =  $(v).find("[name='benefit_master_detail_id']").val();
					list.benefit_master_main_id = $rowData.benefit_master_main_id;
					list.emp_seq = $empRowData.emp_seq;
					list.relationship_code = $(v).find("[name='relationship']").data("kendoDropDownList").value();
					list.relationship_name = $(v).find("[name='relationship']").data("kendoDropDownList").text();
					list.account = $(v).find("[name='account']").val();
					list.number = $(v).find("[name='number']").val();
					list.create_emp_seq = "${userInfo.empSeq}";
					
					if($(v).find("[name='benefit_master_detail_id']").length >0){
						deleteData.push(list);
					}
				})
				
				param.insertData = JSON.stringify(insertData);
				param.updateData = JSON.stringify(updateData);
				param.deleteData = JSON.stringify(deleteData);
		}
		
		$.ajax({
			url : _g_contextPath_+'/vacationApply/benefitSave',
			data : param,
			type : "POST",
			async : false,
			success : function(result){

				$benefit_master_main_id = result.benefit_master_main_id;
				if(sep == 'click'){
					if(result.status == "insert"){
						alert("저장완료되었습니다.");
					}else{
						alert("수정완료되었습니다.");
					}
				}else{
// 						appr();
				}
				$("#popUp").data("kendoWindow").close();
				gridReload();
			}
		});

	}
	
	function selectPopGridRow(e){
		
		$(".personDetail").removeClass("k-state-selected");
		
		$(e).addClass("k-state-selected");
	}
	
	function gridRowAdd(){
		
		++$addIndex;
		
		$(".Guide").remove();
		
		var oneRow = '<tr class="personDetail" onclick = "selectPopGridRow(this)">';
		
		oneRow += '<td class="txtCenter pl5 pr5"><input type="text" id="relationship'+$addIndex+'" name="relationship" style="width: 90%"></td>';
		
		oneRow += '<td class="txtCenter pl5 pr5"><input type="text"  id="account'+$addIndex+'" name="account" value="" style="width: 90%"></td>';
		
		oneRow += '<td class="txtCenter pl5 pr5"><input type="text" id="number'+$addIndex+'" name="number" value="1" style="width: 90%"></td></tr>'
		
		$('#personDetailTable').append(oneRow);
		
		$("#relationship"+$addIndex).kendoDropDownList({
			dataTextField : "code_kr",
			dataValueField : "code",
			dataSource : $family_code,
		}).data("kendoDropDownList");
		
	}

	function gridGuide(){
		
		var oneRow =  '<tr class="personDetail Guide"><td colspan = "3">추가 버튼을 통해 수당(포인트) 입력가능합니다.</td></tr>';
		
		$('#personDetailTable').append(oneRow);
	}
	
	function popGrid(){
		
		if($insertChk){
			gridGuide();
		}else{
			
			var grid = $('#grid').data("kendoGrid");
			var dataItem = grid.dataItem($(".k-state-selected"));
			var benefit_master_main_id = dataItem.benefit_master_main_id;
			
			$.each($grid2DataSource._data, function(i,v){
				
				$addIndex++
				
				var oneRow = '<tr class="personDetail" onclick = "selectPopGridRow(this)">';
				
				oneRow += '<td class="txtCenter pl5 pr5"><input type="text" id="relationship'+$addIndex+'" name="relationship" value="'+v.relationship+ '" style="width: 90%" ></td>';
				
				oneRow += '<td class="txtCenter pl5 pr5"><input type="text"  id="account'+$addIndex+'" name="account" value="'+v.account+ '" style="width: 90%" ></td>';
				
				oneRow += '<input type="hidden"  id="benefit_master_detail_id'+$addIndex+'" name="benefit_master_detail_id" value="'+v.benefit_master_detail_id+ '">';
				
				oneRow += '<td class="txtCenter pl5 pr5"><input type="text" id="number'+$addIndex+'" name="number" value="'+v.number+ '" style="width: 90%" ></td></tr>'
				
				$('#personDetailTable').append(oneRow);
			
				$("#relationship"+$addIndex).kendoDropDownList({
					dataTextField : "code_kr",
					dataValueField : "code",
					dataSource : $family_code,
				}).data("kendoDropDownList").value(v.relationship_code);
					
			});
		}
	}

	function gridRowDelete(){
		$deleteData
// 		if($addIndex > 0){
// 			--$addIndex;
// 		}
		if($("#personDetailTable .k-state-selected").length>0){
			$("#personDeleteTable").append($("#personDetailTable .k-state-selected"));
			$("#personDetailTable .k-state-selected").remove();
		}else{
			if($(".personDetail").length == 1){
				$("#personDeleteTable").append($($("#personDetailTable .personDetail")[$("#personDetailTable .personDetail").length-1]));	
				$("#personDetailTable .personDetail")[$("#personDetailTable .personDetail").length-1].remove();
				gridGuide();
			}else{
				$("#personDeleteTable").append($($("#personDetailTable .personDetail")[$("#personDetailTable .personDetail").length-1]));	
				$("#personDetailTable .personDetail")[$("#personDetailTable .personDetail").length-1].remove();
			}
		}
	}

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

</script>


<div class="iframe_wrap">
	<div class="sub_title_wrap">
		<div class="title_div">
			<h4>수당관리마스터</h4>
		</div>
	</div>
	<div class="sub_contents_wrap">
		<div class="btn_div mt10 cl">
			<div class="left_div">
				<p class="tit_p mt5 mb0">수당관리마스터</p>
			</div>
			<div class="right_div">
				<div class="controll_btn p0">
<!-- 					<button type="button" id="approvalChk" onclick = "approvalChk()">결재보기</button> -->
					<button type="button" id="mainGrid" onclick = "mainGrid()">조회</button>
<!-- 					<button type="button" id="delete" onclick = "deleteRow()">삭제</button> -->
					<button type="button" id="apply" onclick = "apply('new')">신청</button>
				</div>
			</div>
		</div>
		<div class="com_ta">
			<div class="top_box gray_box" id = "dataBox">
				<dl>
					<dt>
						신청일자
					</dt>
					<dd>
						<input type="text" id = "apply_from_date" name = "" check="must" value = ""/>&nbsp;~
						<input type="text" id = "apply_to_date" name = "" check="must" value = ""/>
					</dd>
				</dl>
			</div>
		</div>
		
<!-- 		<div class = "com_ta2"> -->
<!-- 			<div class="top_box gray_box"> -->
<!-- 				<dl> -->
<!-- 					<dt> -->
<!-- 						사원번호 -->
<!-- 					</dt> -->
<!-- 					<dd> -->
<!-- 						<input type="text" id = "empNo" name = "" value = "" readonly/> -->
<!-- 						<input type="hidden" id = "empSeq" name = "" value = "" readonly/> -->
<!-- 					</dd> -->
					
<!-- 					<dt> -->
<!-- 						성명 -->
<!-- 					</dt> -->
<!-- 					<dd> -->
<%-- 						<input type="text" id = "empName" name = "" value = "${userInfo.empName}" readonly/> --%>
<!-- 					</dd> -->
					
<!-- 					<dt> -->
<!-- 						부서 -->
<!-- 					</dt> -->
<!-- 					<dd> -->
<!-- 						<input type="text" id = "empDept" name = "" value = "" readonly/> -->
<!-- 					</dd> -->
					
<!-- 					<dt></dt> -->
<!-- 					<dd style="float:right" class = "mr20"> -->
<!-- 						<input type="hidden" id = "empPosition" name = "" value = ""/> -->
						
<!-- 						<input type="button" id="empListPopBtn" value="사원검색"></button> -->
<!-- 					</dd> -->
<!-- 				</dl> -->
<!-- 			</div> -->
<!-- 		</div> -->
		
		<div class="com_ta3">
			<div  id = "grid">
			</div>
		</div>
		
		<div class="btn_div mt10 cl">
			<div class="left_div">
				<p class="tit_p mt5 mb0">가족정보</p>
			</div>			
			<div class="right_div">
				<div class="controll_btn p0">
<!-- 					<button type="button" id="loseApply" onclick = "apply('lose')">자격상실</button> -->
				</div>
			</div>
		</div>
		
		<div class="com_ta4">
			<div  id = "grid2">
			</div>
		</div>
		
		<div id = "innerhtml"></div>
	</div>
	
</div>

<!-- 학자금신청팝업 -->
<div class = "pop_wrap_dir" id = "popUp" stlye ="width:600px;">
	<div class = "pop_head">
		<h1>수당관리</h1>
	</div>
	
	<div class = "pop_con">
		<div class = "top_box">
			<dl>
				<dt>타입</dt>
				<dd>
					<select id = "benefit_type" style = "width:125px;text-align:center;" value="" >
						<option value ="1" selected>가족수당</option>
						<option value="2">복지포인트</option>
					</select>
				</dd>
				<dt>제목</dt>
				<dd>
					<input type="text" id = "subject" class="popInput" check="must" style = "width:125px;text-align:center;"/>
				</dd>
			</dl>
			<dl class = "next2">
				<dt>적용시작일</dt>
				<dd>
					<input type="text" id = "apply_start_date" style = "width:125px;text-align:center;" value="${nowDate}"/>
				</dd>
				<dt>적용종료일</dt>
				<dd>
					<input type="text" id = "apply_end_date" style = "width:125px;text-align:center;" value="${nowDate}"/>
				</dd>
			</dl>		
		</div>
		<div class="btn_div mt10 cl">
			<div class="right_div">
				<div class="controll_btn p0">
					<button type="button" id="gridRowAdd" class="gray_btn" onclick = "gridRowAdd()">추가</button>
					<button type="button" id="gridRowDelete" class="gray_btn" onclick = "gridRowDelete()">삭제</button>
				</div>
			</div>
		</div>
		<div class="com_ta2">
			<div id = "popGrid">
			</div>
				<table id="personDetailTable" style="width: 100%" >
						<tr>
							<th style="width: 33%">관계</th>
							<th style="width: 33%">지급액</th>
							<th style="width: 34%">서열</th>
						</tr>
				</table>
				<table id="personDeleteTable" style="width: 100%" hidden>
						<tr>
							<th style="width: 33%">관계</th>
							<th style="width: 33%">지급액</th>
							<th style="width: 34%">서열</th>
						</tr>
				</table>
		</div>
<!-- 		<div class = "top_box mt5"> -->
<!-- 			<dl class="bg_skyblue2" style="background-color: #CEF6F5"> -->
<!-- 				<dt class="ml5" style="width: 170px"> -->
<%-- 					<img src="<c:url value='/Images/ico/ico_alert.png'/>" alt="alertIcon" />&nbsp;&nbsp;부양가족신고 안내 --%>
<!-- 				</dt> -->
<!-- 			</dl> -->
<!-- 			<dl style="background-color: #ffffff"> -->
<!--  				<dt style="width:50px">&nbsp;</dt> --> 
<!-- 				<dd class="pl20 pb10"> -->
<!-- 					첨부<br> -->
<!-- 					1. 주민등록등본 1부.<br> -->
<!-- 					2. 가족관계증명서 1부.<br> -->
<!-- 					3. 기타(       ) -->
<!-- 				</dd> -->
<!-- 			</dl> -->
<!-- 		</div> -->
	</div>

	<div class = "pop_foot">
		<div class = "btn_cen pt12">
			<input type="button" class = "blue_btn" id = "save" onclick="save('click')" value="설정"/>
<!-- 			<input type="button" class = "blue_btn" id = "approval" onclick="approval()" value="상신"/> -->
			<input type="button" class = "blue_btn" id = "close" value="닫기"/>
		</div>
	</div>
</div>
<!-- 학자금신청팝업 끝 -->

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

<!-- <div id="idCardDiv" style="display: none;"> -->
<!-- 	<table> -->
<!-- 		<tr class="personDetail"> -->
			
<!-- 			<td class="txtCenter"> -->
<!-- 				<input type="text" id="career_start_date" name="career_start_date" onkeyup="dateCheck(this);" onkeydown="dateCheck(this);" onfocusout="dateCheck(this);" style="width: 120px"> -->
<!-- 				~ -->
<!-- 				<input type="text" id="career_end_date" name="career_end_date" onkeyup="dateCheck(this);" onkeydown="dateCheck(this);" onfocusout="dateCheck(this);" style="width: 120px"> -->
<!-- 			</td> -->
<!-- 			<td class="txtCenter"> -->
<!-- 				<input type="text" id="workplace_nm" name="workplace_nm"> -->
<!-- 			</td> -->
<!-- 			<td class="txtCenter"> -->
<!-- 				<input type="text" id="career_position" name="career_position" style="width: 80px" > -->
<!-- 			</td> -->
<!-- 			<td class="txtCenter"> -->
<!-- 				<input type="text" id="career_duty" name="career_duty" style="width: 100px" > -->
<!-- 			</td> -->
<!-- 			<td class="txtCenter"> -->
<!-- 				<input type="text" id="work_term" name="work_term" style="width: 100px" > -->
<!-- 			</td> -->
<!-- 			<td class="txtCenter"> -->
<!-- 				<input type="text" id="remark" name="remark" style="width: 300px" > -->
<!-- 			</td> -->
<!-- 			<td><input type="button" onclick="addPersonDetailDelBtn(this);" class="text_blue" value="삭제"></td> -->
<!-- 		</tr> -->
<!-- 	</table> -->
<!-- </div> -->
<div id = "test"></div>
</body>
