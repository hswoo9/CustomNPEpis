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

table {
	border-style : solid;
	border-width : 1px;
	border-color : rgb(234,234,234);
}

input {text-align : center;}

.k-grid tbody tr{height:38px;}
</style>


<body>

<script type="text/javascript">

var $familyInfo = JSON.parse('${familyInfo}');

// $familyInfo = $.each($familyInfo, function(i,v){
	
// 	$.each($codeList.list, function(a,b){
// 		if(v.CD_RELA == b.relationship_id){
// 			v.rela_name = b.relationship_name;
// 			return;
// 		}
// 	})
// })

var $rowData = {};					//그리드한줄정보
var $gridIndex = 0;					//그리드인덱스번호
var $insertChk = true;				//신청화면 insert/update 구분
var $addIndex = 0;					//팝업그리드 인덱스
var $empRowData = [];			//신청자사원정보
var $education_expense_id = "";		//기안시PK
var $scholarRegisterData;		//학자금상세정보데이터
var $scholarRegisterDataFilter;		//학자금별 구분셀렉트박스데이터(임시)
var $dataSource = new kendo.data.DataSource({		//그리드데이터소스
	serverPaging : true,
	pageSize : 10,
	transport : {
		read : {
			url : _g_contextPath_+ "/vacationApply/scholarApplyList",
			dataType : "json",
			type : "post"
		},
		parameterMap: function(data, operation) {
			
// 			data.request_emp_seq = $("#empNo").val();
// 			data.request_emp_name = $("#empName").val();
// 			data.request_dept_seq = $("#empDept").val();
			data.apply_from_date = $("#apply_from_date").val().replace(/-/gi,'');
			data.apply_to_date = $("#apply_to_date").val().replace(/-/gi,'');
			data.status = $("#statusType").val();
			
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
			url : _g_contextPath_+ "/vacationApply/scholarApplyDetailList",
			dataType : "json",
			type : "post"
		},
		parameterMap: function(data, operation) {

			var education_expense_id = $rowData.education_expense_id;
			
			if(education_expense_id == "" || education_expense_id == null){
				
				var str = "(select education_expense_id from dj_education_expense where active = 'Y' and ";
				if($("#empNo").val()==""||$("#empNo").val()==null){
					
				}else{
					str += "request_emp_no = '" +$("#empNo").val()+"' and ";
				}
				
				if($("#empName").val()==""||$("#empName").val()==null){
					
				}else{
					str += "request_emp_name = '" +$("#empName").val()+"' and ";
				}
				
				if($("#empDept").val()==""||$("#empDept").val()==null){
					
				}else{
					str += "request_dept_seq = '" +$("#empDept").val()+"' and ";
				}
				
				str += "DATE_FORMAT(request_date, '%Y%m%d') BETWEEN '";
				str += $("#apply_from_date").val().replace(/-/gi,'') + "' and '" +$("#apply_to_date").val().replace(/-/gi,'')+"' " ;
				str += "order by request_date asc limit 1)";
				
				data.education_expense_id =	str;
					
			}else{
				data.education_expense_id = "'"+education_expense_id+"'";
			}
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

var $scholarDataSource;		//학자금유형콤보데이터변수
	$(function(){
		
		defaultSet();

		$("#apply_from_date").kendoDatePicker({
		    depth: "month",
		    start: "month",
		    culture : "ko-KR",
			format : "yyyy-MM-dd",
			value : new Date(${year}, ${mm}-2, ${dd}),
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

		$("#popUp").kendoWindow({
			resizable: false,
			width : "600px",
			height : "565px",
			visible : false,
			modal : true,
			actions : [ "Close" ],
			close : onClose
		}).data("kendoWindow").center();
		
		$("#close").click(function(){
			$("#popUp").data("kendoWindow").close();
		});

// 		$("#apply_from_date").attr("readonly", true);
// 		$("#apply_to_date").attr("readonly", true);

		mainGrid();
// 		subGrid();
// 		scholarDataSource();
		empListPop();
		console.log("${userInfo}");
		makeDropDownList();
		onlyNumber();
// 		scholarRegisterData();

	});
	
	function defaultSet(){
		
		var empSeq = "${userInfo.empSeq}";
		if(empSeq == 1){
			$("#empNo").val("${userInfo.erpEmpSeq}");
			$("#empName").val("${userInfo.empName}");
			$("#empDept").val("${userInfo.orgnztNm}");
			$("#empListPopBtn").show();
		}else{
			$("#empNo").val("${userInfo.erpEmpSeq}");
			$("#empName").val("${userInfo.empName}");
			$("#empDept").val("${userInfo.organNm}");
			$("#empListPopBtn").hide();
			
		}
	}
	
	function makeDropDownList(){
		
		$("select").kendoDropDownList({});
		

// 		$("#scholarship").kendoDropDownList({
			
// 			dataTextField: "scholar_type_name",
// 		    dataValueField: "scholar_type_id",
// 		    dataSource : $scholarDataSource 
// 		}).data("kendoDropDownList");

		
// 		if($familyInfo.length>0){
// 			$("#target_name").kendoDropDownList({
				
// 				dataTextField: "family_name",
// 			    dataValueField: "user_family_id",
// 			    dataSource : $familyInfo,
// 			    change : popSetData
// 			}).data("kendoDropDownList");
// 		}else{
// 			if($("#target_name").data("kendoDropDownList")){
// 				$("#target_name").closest("dd").append('<input type = "text" id = "target_name" check="must" class="popInput" style="width:122px; heigth: 24px;"></input>');
// 				$("#target_name").closest("dd").find("span").remove();
// 			}
// 		}
	}
	
	function scholarDataSource(){
		
		var param = {
				tableName : "dj_scholar_type",
				orderName : "scholar_type_name",
				skip : 0,
				pageSize : 100
		};
		
		$.ajax({
			url : _g_contextPath_+"/vacationApply/codeList",
			data : param,
			type : "POST",
			async: false,
			success : function(result){
				
				$scholarDataSource = result.list;
				
			}
		});
	}
	
	function scholarRegisterData(){
		
		$.ajax({
			url : _g_contextPath_+"/vacationApply/scholarDetailList",
			data : {},
			type : "POST",
			async: false,
			success : function(result){
				
				$scholarRegisterData = result.list;
				
			}
		});
	}
	
	function popSetData(e){
		if($familyInfo.length>0){
// 			var data = $("#target_name").data("kendoDropDownList").dataItem();
// 			$("#target_relationship").val(data.family_relationship_kr);
// 			$("#residence_number_front").val(data.NO_RES.substring(0,6));
// 			$("#residence_number_back").val(data.NO_RES.substring(7));
		}
	}

	function dbclickToApply(){
		var grid = $('#grid').data("kendoGrid");
		var dataItem = grid.dataItem($(".k-state-selected"));
		$("#popUp").data("kendoWindow").open();
		$("#apply").fadeOut();
		$insertChk = false;
// 		$("#scholarship").data("kendoDropDownList").value(dataItem.education_type_code);
		$("#scholarship").val(dataItem.education_type_code);
		$("#education_term").data("kendoDropDownList").value(dataItem.education_term);
// 		if($familyInfo.length>0){
// 			$("#target_name").data("kendoDropDownList").text(dataItem.target_name);
// 		}else{
			$("#target_name").val(dataItem.target_name);
// 		}
		$("#scholarship_kind").val(dataItem.scholarship_kind);
		$("#target_relationship").val(dataItem.target_relationship);
		$education_expense_id = dataItem.education_expense_id;

// 		popSetData();
		empRowDataSet();
		
		//row data를 기반으로 팝업에 내용 입력
		$("#education_institution").val(dataItem.education_institution);
		$("#education_grade").val(dataItem.education_grade);
		$("#education_sum_money").val(dataItem.education_sum_money_format);
		$("#remark").val(dataItem.remark);
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
		$education_expense_id = "";
	}

	function apply(){	//신청 팝업

		$("#popUp").data("kendoWindow").open();
		$("#apply").fadeOut();
		popGrid();
		empRowDataSet();
		popSetData();
	}
	
	function empRowDataSet(){
		if($empRowData.length<1){
			
		$.ajax({
				
				url : _g_contextPath_+'/common/empInformation',
				data : {emp_name : $("#empName").val(), skip:0, pageSize:1},
				type : "POST",
				success : function(result){
					
					if(result.list.length >0){
						$empRowData = result.list[0];
					}
				}
			});
		}
	}
	
	function popUpEmpty(){
		$("#scholarship").val();
		$("#education_term").data("kendoDropDownList").select(0);
// 		if($familyInfo.length>0){
// 			$("#target_name").data("kendoDropDownList").select(0);
// 		}
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
			var param = { education_expense_id : dataItem.education_expense_id};
			if(status == '신청'){
				
				$.ajax({
					
					url : _g_contextPath_+'/vacationApply/scholarApplyDeleteRow',
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
	
	function approvalChk(){	//결재보기함수		status_name 상신중 종결일때만 결재상태확인가능
		
		var grid = $('#grid').data("kendoGrid");
		var dataItem = grid.dataItem($(".k-state-selected"));
		
		if(!dataItem){
			alert("결재보기할 데이터를 선택해 주십시오.")
		}else{
			if(dataItem.status_name == "상신중(기안완료)" ||dataItem.status_name == "종결"){
						
				var params = {};
				params.compSeq = "${userInfo.compSeq}";
				params.empSeq = "${userInfo.empSeq}";
				params.approKey = 'S_APP' + dataItem.education_expense_id;
				params.outProcessCode = "S_APP";
				if(location.host.indexOf("127.0.0.1") > -1 || location.host.indexOf("localhost") > -1){
					params.outProcessCode = "S_APP";
				}
				params.mod = 'V';
							
				outProcessLogOnOther(params);	
						
			}else{
				alert("결재보기는 진행상태가 '상신중' 혹은 '종결' 일 때만 가능합니다.");
				return false;
			}
		}
	}
	
	function mainGrid(){
	
		var grid =  $("#grid").kendoGrid({
			dataSource: $dataSource,
			height : 600,
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
					width : "30px",
					headerTemplate : function(e){
						return '<input type="checkbox" id = "checkboxAll">';
					},
					template : function(e){
						
						return '<input type="checkbox" id = "checkbox'+e.education_expense_id+'" class = "checkbox">';
						
// 						if(e.status == '1'){
// 							return '<input type="checkbox" id = "checkbox'+e.education_expense_id+'" class = "checkbox">';
// 						}else{
// 							return "";
// 						}
					}
				},
				{
					field : "status_name",
					title : "진행상태"
				},
				{
					field : "request_date_format",
					title : "신청일자"
				},
				{
					field : "request_emp_name",
					title : "신청자"
				},
				{
					field : "request_dept_name",
					title : "신청자 부서"
				},
				{
					field : "request_duty",
					title : "신청자 직책"
				},
// 				{
// 					template : function(dataItem){	//진행상태가 미상신일때만 수정가능(더블클릭이벤트설정) 
// 							if(dataItem.education_expense_id != undefined || dataItem.education_expense_id != null){
// 								if(dataItem.status_name == '신청'){
// 									return "<span class = 'education_expense_id' ondblclick = 'dbclickToApply()'>"+dataItem.education_expense_id+"</span>"
// 								}else{
// 									return "<span class = 'education_expense_id'>"+dataItem.education_expense_id+"</span>"
// 								}
// 							}else{
// 								return "<span class = 'education_expense_id'></span>"
// 							}
// 						},
// 					title : "신청번호"
// 				},
				{
					field : "education_term",
					title : "신청학기"
				},
				{
					field : "scholarship_kind",
					title : "구분"
				},
				{ //학자금타입코드 히든
					hidden : true,
					template : function(dataItem){
						return "<span id = 'education_type_code" +dataItem.index+"'>"+dataItem.education_type_code+"</span>";
					}
				},
				{
					field : "target_relationship",
					title : "관계"
				},
				{
					field : "target_name",
					title : "대상자 성명"
				},
				{
					field : "target_birth_format",
					title : "대상자 생년월일"
				},
				{
					field : "education_institution",
					title : "학교명"
				},
				{
					field : "education_grade",
					title : "학년"
				},
				{
					field : "education_sum_money_format",
					title : "신청금액"
				},
				{
					field : "scholarship_account",
					title : "지급액",
					template : function(e){
						if(e.status == '1'){
							return '<input type="text" name="scholarship_account" style="width:80%;text-align:center;" onkeyup = "scholarCheck(this)">';
						}else{
							return kendo.toString(e.scholarship_account, "n0");
						}
					}
				},
				{
					field : "remark",
					title : "비고"
				},
				{
					width : "10%",
					field : "area",
					title : "증빙",
					template : function(e){
						if(e.attach_file_id != undefined || e.attach_file_id != null){
							
							var file_id = e.attach_file_id.split(',');
							
							var str = '';
							for (var i = 0; i < file_id.length; i++) {
								str += '<input type="butotn" class="blue_btn" style="width:8px;text-align:center;margin-right:1px;" name="file" value="'+(i+1)+'" onclick="fileDown(\''+file_id[i]+'\')">';
							}
							
							return str;
							
						}else{
							return '파일없음';
						}
					}
				},
				{
					width : "5%",
					field : "education_expense_id",
					title : "보기",
					template : function(e){
						return '<input type="butotn" class="blue_btn" style="width:25px;text-align:center;" name="preView" value="보기" onclick="preView('+e.education_expense_id+',this);">';
					}
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
		
		$("#checkboxAll").click(function(e){
			if($("#checkboxAll").is(":checked")){
				$(".checkbox").prop("checked", true);
			}else{
				$(".checkbox").prop("checked", false);
			}
		});
		
	};
	
	function scholarCheck(e){
		if($(e).val() == ""||$(e).val() == null){
			$(e).closest("tr").find(".checkbox").prop("checked",false);
		}else{
			$(e).closest("tr").find(".checkbox").prop("checked",true);
		}
	}
	
	function gridReload(){
		$gridIndex = 0;
		$('#grid').data('kendoGrid').dataSource.read();
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
	
	function fileDown(attach_file_id){
		
		$.ajax({
			url: _g_contextPath_ + '/common/fileDown',
			type: 'get',
			data: {attach_file_id : attach_file_id},
			success: function(data){
				var downWin = window.open('','_self');
				downWin.location.href = _g_contextPath_+'/common/fileDown?attach_file_id='+attach_file_id;
			}
		});
	}
	
	function preView(education_expense_id, e){
		
		dataItem = $('#grid').data("kendoGrid").dataItem($(e).closest('tr'));
// 		return false;
		var url = _g_contextPath_+"/vacationApply/scholarshipReport";
		url += "?education_expense_id="+education_expense_id;
		url += "&apply_from_date="+$("#apply_from_date").val().replace(/-/gi,'');
		url += "&apply_to_date="+$("#apply_to_date").val().replace(/-/gi,'');
		url += "&report_type=1";
		url += "&access_type=admin";
		url += "&appro_status="+dataItem.status;
		
//	 		var url = _g_contextPath_+"/aireport/bill?reportParams=useReportFile:true,reportFileSave:true";
		window.open(url, "viewer", "width=1100, height=820, resizable=yes, scrollbars = yes, status=no, toolbar=no, top=50, left=100", "newWindow");

	}
	
	function subGrid(){
		
		var grid =  $("#grid2").kendoGrid({
			dataSource: $grid2DataSource,
			sortable : true,
			height : 150,
			persistSelection : true,
			columns : [
				
				{
					field : "education_detail_type_name",
					title : "구분"
				},
				{
					hidden : true,
					template : function(dataItem){
						return "<span id = 'education_detail_type_code" +dataItem.index+"'>"+dataItem.education_detail_type_code+"</span>";
					}
				},
				{
					hidden : true,
					template : function(dataItem){
						return "<span id = 'education_expense_detail_id" +dataItem.index+"'>"+dataItem.education_expense_detail_id+"</span>";
					}
				},
				{
					field : "money_format",
					title : "금액"
				},
				{
					field : "remark",
					title : "비고"
				}
			]
		});

	}

	function save(sep){
		
		if(mustChk()){
			var target_name;
// 			if($familyInfo.length>0){
// 				target_name = $("#target_name").data("kendoDropDownList").text()
// 			}else{
				target_name = $("#target_name").val();
// 			}
			var param = {
					request_date : $("#apply_date").val().replace(/-/gi,""),
					education_type_code : $("#scholarship").val(),
// 						education_type_name : $("#scholarship").data("kendoDropDownList").text(),
					education_type_name : $("#scholarship").val(),
					target_relationship :$("#target_relationship").val(),
					target_name : target_name,
					education_institution : $("#education_institution").val(),
					education_sum_money : $("#education_sum_money").val().replace(/,/gi,""),
					education_term : $("#education_term option:selected").val(),
					education_grade : $("#education_grade").val(),
					scholarship_kind : $("#scholarship_kind").val(),
					remark : $("#remark").val(),
					request_emp_seq : $empRowData.emp_seq,
					request_emp_name : $empRowData.emp_name, 
					request_emp_no : $empRowData.erp_emp_num, 
					request_dept_seq : $empRowData.dept_seq, 
					request_dept_name : $empRowData.dept_name,
					request_duty_code : $empRowData.duty_code,
					request_duty : $empRowData.duty,
					create_emp_seq : "${userInfo.empSeq}"
			}
			if($insertChk){		//status : insert
				param.status = "insert";
					
// 					var data = [];
// 					$(".personDetail").each(function(i,v){
// 						var list = {};
// // 						list.education_detail_type_code = $(v).find("#education_detail_type_name"+(i+1)).data("kendoDropDownList").value();
// // 						list.education_detail_type_name =  $(v).find("#education_detail_type_name"+(i+1)).data("kendoDropDownList").text();
// 						list.education_detail_type_code = $(v).find("#education_detail_type_name"+(i+1)).val();
// 						list.education_detail_type_name =  $(v).find("#education_detail_type_name"+(i+1)).val();
						
// 						list.money = ($(v).find("[name=money]").val()).replace(/,/gi,"");
// 						list.remark = $(v).find("[name=remark]").val();
// 						list.create_emp_seq = "${userInfo.empSeq}";
// 						data.push(list);
// 					})
// 					param.data = JSON.stringify(data);
					
			}else{		//status : update
				param.status = "update";
				param.education_expense_id = $rowData.education_expense_id;
// 					var data = [];
// 					$(".personDetail").each(function(i,v){
// 						var list = {};
// 						list.education_expense_id = $rowData.education_expense_id;
// // 						list.education_detail_type_code = $(v).find("#education_detail_type_name"+(i+1)).data("kendoDropDownList").value();
// // 						list.education_detail_type_name =  $(v).find("#education_detail_type_name"+(i+1)).data("kendoDropDownList").text();
// 						list.education_detail_type_code = $(v).find("#education_detail_type_name"+(i+1)).val();
// 						list.education_detail_type_name =  $(v).find("#education_detail_type_name"+(i+1)).val();
// 						list.money = ($(v).find("[name=money]").val()).replace(/,/gi,"");
// 						list.remark = $(v).find("[name=remark]").val();
// 						list.create_emp_seq = "${userInfo.empSeq}";

// 						data.push(list);
// 					})
// 					param.data = JSON.stringify(data);
			}

			$.ajax({
				url : _g_contextPath_+'/vacationApply/scholarApplySave',
				data : param,
				type : "POST",
				async : false,
				success : function(result){

					$education_expense_id = result.education_expense_id;
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

		}else{
			
		}
	}
	
	function approval(){
		
		var ch = $('#grid .checkbox:checked');
		var param = {};
		var approData = [];
		var valueEmptyChk = false;
		var approChk = false;
		if(ch.length == 0){
			alert("승인할 데이터에 체크바랍니다.");
			return false;
		}else{
			$.each(ch, function(i,v){
				var dataItem = $('#grid').data("kendoGrid").dataItem($(v).closest("tr"));
				if(dataItem.status == '1'){
					
					var scholarship_account = $(v).closest("tr").find("[name='scholarship_account']").val();
					
					if(scholarship_account == "" || scholarship_account == null){
						scholarship_account = 0;
					}
					
					var list = {};
					list.education_expense_id = dataItem.education_expense_id;
					list.update_emp_seq = '${userInfo.empSeq}';
					list.scholarship_account = scholarship_account;
					
					approData.push(list);
				}else{
					approChk =  true;
					return false;
				}

			});
			if(approChk){
				alert("이미 승인된 건이 포함되어 있습니다.");
				return false;
			}
			param.approData = JSON.stringify(approData);
			
			$.ajax({
				url: _g_contextPath_ + '/vacationApply/scholarApprovalUpdate',
				type: 'post',
				dataType: 'json',
				data: param,
				async : false,
				success: function(json){

					alert("승인 완료");
					gridReload();

				}
			});
		}
	}
	
	function approCancle(){
		var ch = $('#grid .checkbox:checked');
		var param = {};
		var approData = [];
		var approChk = false;
		if(ch.length == 0){
			alert("승인취소할 데이터에 체크바랍니다.");
			return false;
		}else{
			$.each(ch, function(i,v){
				var dataItem = $('#grid').data("kendoGrid").dataItem($(v).closest("tr"));
				if(dataItem.status == '2'){
					
					var scholarship_account = $(v).closest("tr").find("[name='scholarship_account']").val();
					
					if(scholarship_account == "" || scholarship_account == null){
						scholarship_account = 0;
					}
					
					var list = {};
					list.education_expense_id = dataItem.education_expense_id;
					list.update_emp_seq = '${userInfo.empSeq}';
					list.scholarship_account = scholarship_account;
					
					approData.push(list);
				}else{
					approChk =  true;
				}

			});
			if(approChk){
				alert("신청 건이 포함되어 있습니다.");
				return false;
			}
			param.approData = JSON.stringify(approData);
			
			$.ajax({
				url: _g_contextPath_ + '/vacationApply/scholarApprovalCancle',
				type: 'post',
				dataType: 'json',
				data: param,
				async : false,
				success: function(json){

					alert("승인취소 완료");
					gridReload();

				}
			});
		}
	}
	
	function appr(){
		
		var education_expense_id = $education_expense_id;
		var params = {};
		params.compSeq = $empRowData.comp_seq;
		params.empSeq = $empRowData.emp_seq;
		params.approKey = 'S_APP' + education_expense_id;
		params.outProcessCode = "S_APP";
		if(location.host.indexOf("127.0.0.1") > -1 || location.host.indexOf("localhost") > -1){
			params.outProcessCode = "S_APP";
		}
		params.mod = 'W';
		params.title = "학자금 신청의 건";
		var data = {};
		data.title = "학자금 신청의 건";
		data.empDept = $("#empDept").val();
		data.empSeq = $("#empNo").val();
		data.empName = $("#empName").val();
// 		data.empDept = "${userInfo.deptname}";
// 		data.empSeq = "${userInfo.erpEmpSeq}";
// 		data.empName = "${userInfo.empName}";
		data.request_date = $("#apply_date").val();
		data.education_term = $("#education_term").val();
// 		data.education_type_name = $("#scholarship").data("kendoDropDownList").text();
		data.education_type_name = $("#scholarship").val();
		data.target_relationship = $("#target_relationship").val();
// 		if($familyInfo.length>0){
// 			data.target_name = $("#target_name").data("kendoDropDownList").text();
// 		}else{
			data.target_name = $("#target_name").val();
// 		}
		
		data.residence_number = $("#residence_number_front").val()+"-"+$("#residence_number_back").val();
		data.education_institution = $("#education_institution").val();
		data.education_grade = $("#education_grade").val();
		data.education_sum_money = $("#education_sum_money").val();
		data.remark = $("#remark").val();
		
		for (var i = 0; i < 3; i++) {
			data["education_detail_type_name"+i] = "";
			data["money"+i] = "";
			data["remark"+i] = "";
		}
		
		$(".personDetail").each(function(i,v){
			
// 			data["education_detail_type_name"+i] = $(v).find("#education_detail_type_name"+(i+1)).data("kendoDropDownList").text();
			data["education_detail_type_name"+i] = $(v).find("#education_detail_type_name"+(i+1)).val();
			data["money"+i] = $(v).find("[name=money]").val();
			data["remark"+i] = $(v).find("[name=remark]").val();
			
		})

		params.contentsStr = makeContentsStr(data);
// 		$("#test").html(params.contentsStr);
		outProcessLogOn(params);
		
	}
	
	function makeContentsStr(data){
		
		var contentsStr = "";
// 		contentsStr += '<table width="80%" height="50px" border="0" cellspacing="0" cellpadding="0" style="text-align: left; margin:auto;">';
		contentsStr += '<table class="com_ta" width="100%" height="42px" marginheight="0px" border="1px solid #b1b1b1" cellspacing="0" cellpadding="0" style="text-align: center;margin-left:-1px;border-top-style:hidden;border-bottom-style:none;border-right-style:hidden;border-left-style:hidden">';
		contentsStr += '<colgroup>';
		contentsStr += '<col width=""/>';
		contentsStr += '</colgroup>';
		contentsStr += '<tbody>';
		contentsStr += '<tr>';
		contentsStr += '<td class="bd_color p15" style="text-align:left;">1. 지급 대상자(자녀) 인적사항</td>';
		contentsStr += '</tr></table>';
	
// 		contentsStr += '<table width="80%" height="150px" border="1" cellspacing="0" cellpadding="0" class="mt5 area_sign"style="text-align: center; margin:auto;';
// 		contentsStr += '<colgroup>';
// 		contentsStr += '<col width="35%"/>';
// 		contentsStr += '<col width="15%"/>';
// 		contentsStr += '<col width="35%"/>';
// 		contentsStr += '<col width="15%"/>';
// 		contentsStr += '</colgroup>';
// 		contentsStr += '<tbody>';

		contentsStr += '<table class="com_ta" width="100%" height="42px" marginheight="0px" border="1px solid #b1b1b1" cellspacing="0" cellpadding="0" style="text-align: center;margin-left:-1px;border-right-style:hidden;border-left-style:hidden;border-bottom-style:hidden;border-top-style:hidden;">';
		contentsStr += '<colgroup>';
		contentsStr += '<col width="88px"/>';
		contentsStr += '<col width="235px"/>';
		contentsStr += '<col width="87px"/>';
		contentsStr += '<col width="235px"/>';
		contentsStr += '</colgroup>';
		contentsStr += '<tbody>';
		
		contentsStr += '<tr>';
		contentsStr += '<th colspan = "1" class="bd_color">신청일자</th>';
		contentsStr += '<td colspan = "1" class="bd_color">'+data.request_date+'</td>';
		contentsStr += '<th colspan = "1" class="bd_color">대상자</th>';
		contentsStr += '<td colspan = "1" class="bd_color">'+data.target_name+'</td>';
		
		contentsStr += '</tr>';
		contentsStr += '<tr>';
		contentsStr += '<th colspan = "1" class="bd_color">교육기관</th>';
		contentsStr += '<td colspan = "1" class="bd_color">'+data.education_institution+'</td>';
// 		contentsStr += '<th colspan = "1" class="bd_color">학자금</th>';
// 		contentsStr += '<td colspan = "1" class="bd_color">'+data.education_type_name+'</td>';
		contentsStr += '<th colspan = "1" class="bd_color">관계</th>';
		contentsStr += '<td colspan = "1" class="bd_color">'+data.target_relationship+'</td>';
		contentsStr += '</tr>';
		
// 		contentsStr += '<tr>';
// 		contentsStr += '<td colspan = "1" class="bd_color">대상자</td>';
// 		contentsStr += '<td colspan = "1" class="bd_color">'+data.target_name+'</td>';
// // 		contentsStr += '<td colspan = "1" class="bd_color">주민등록번호</td>';
// // 		contentsStr += '<td colspan = "1" class="bd_color">'+data.residence_number+'</td>';
// 		contentsStr += '</tr>';
		
		contentsStr += '<tr>';

		contentsStr += '<th colspan = "1" class="bd_color">학년</th>';
		contentsStr += '<td colspan = "1" class="bd_color">'+data.education_grade+'학년</td>';
		contentsStr += '<th colspan = "1" class="bd_color">신청학기</th>';
		contentsStr += '<td colspan = "1" class="bd_color">'+data.education_term+'</td>';
		contentsStr += '</tr>';
		
		contentsStr += '<tr>';
		contentsStr += '<th colspan = "1" class="bd_color">신청금액</th>';
		contentsStr += '<td colspan = "1" class="bd_color">'+data.education_sum_money+'</td>';
		contentsStr += '<th colspan = "1" class="bd_color">비고</th>';
		contentsStr += '<td colspan = "1" class="bd_color">'+data.remark+'</td>';
		contentsStr += '</tr>';
	
		contentsStr += '</tbody>';
		contentsStr += '</table>';
		
// 		contentsStr += '<table width="80%" height="30px" border="0" cellspacing="0" cellpadding="0" style="text-align: left; margin:auto;">';
		contentsStr += '<table class="com_ta" width="100%" height="42px" marginheight="0px" border="1px solid #b1b1b1" cellspacing="0" cellpadding="0" style="text-align: center;margin-left:-1px;border-left-style:none;border-top-style:none;border-bottom-style:none;border-right-style:hidden;">';
		contentsStr += '<colgroup>';
		contentsStr += '<col width=""/>';
		contentsStr += '</colgroup>';
		contentsStr += '<tbody>';
		contentsStr += '<tr>';
		contentsStr += '<td class="bd_color p15" style="text-align:left;">2. 학자금 신청 세부사항</td>';
		contentsStr += '</tr></table>';
	
// 		contentsStr += '<table width="80%" height="120px" border="1" cellspacing="0" cellpadding="0" class="area_sign" style="text-align: center; margin:auto;">';
// 		contentsStr += '<colgroup>';
// 		contentsStr += '<col width="25%"/>';
// 		contentsStr += '<col width="25%"/>';
// 		contentsStr += '<col width="25%"/>';
// 		contentsStr += '<col width="25%"/>';
// 		contentsStr += '</colgroup>';
// 		contentsStr += '<tbody>';

		contentsStr += '<table class="com_ta" width="100%" height="42px" marginheight="0px" border="1px solid #b1b1b1" cellspacing="0" cellpadding="0" style="text-align: center;margin-left:-1px;border-right-style:hidden;border-left-style:none;border-bottom-style:hidden;border-top-style:hidden;">';
		contentsStr += '<colgroup>';
		contentsStr += '<col width="88px"/>';
		contentsStr += '<col width="235px"/>';
		contentsStr += '<col width="87px"/>';
		contentsStr += '<col width="235px"/>';
		contentsStr += '</colgroup>';
		contentsStr += '<tbody>';
		
		contentsStr += '<tr>';
		contentsStr += '<td colspan = "1" class="bd_color">NO</td>';
		contentsStr += '<td colspan = "1" class="bd_color">구분</td>';
		contentsStr += '<td colspan = "1" class="bd_color">금액</td>';
		contentsStr += '<td colspan = "1" class="bd_color">비고</td>';
		contentsStr += '</tr>';
		
		contentsStr += '<tr>';
		contentsStr += '<td colspan = "1" class="bd_color">1</td>';
		contentsStr += '<td colspan = "1" class="bd_color">'+data.education_detail_type_name0+'</td>';
		contentsStr += '<td colspan = "1" class="bd_color">'+data.money0+'</td>';
		contentsStr += '<td colspan = "1" class="bd_color">'+data.remark0+'</td>';
		contentsStr += '</tr>';
		
		contentsStr += '<tr>';
		contentsStr += '<td colspan = "1" class="bd_color">2</td>';
		contentsStr += '<td colspan = "1" class="bd_color">'+data.education_detail_type_name1+'</td>';
		contentsStr += '<td colspan = "1" class="bd_color">'+data.money1+'</td>';
		contentsStr += '<td colspan = "1" class="bd_color">'+data.remark1+'</td>';
		contentsStr += '</tr>';
		
		contentsStr += '<tr>';
		contentsStr += '<td colspan = "1" class="bd_color">3</td>';
		contentsStr += '<td colspan = "1" class="bd_color">'+data.education_detail_type_name2+'</td>';
		contentsStr += '<td colspan = "1" class="bd_color">'+data.money2+'</td>';
		contentsStr += '<td colspan = "1" class="bd_color">'+data.remark2+'</td>';
		contentsStr += '</tr>';

		contentsStr += '</tbody>';
		contentsStr += '</table>';
		
// 		contentsStr += '<table width="80%" height="30px" border="0" cellspacing="0" cellpadding="0" style="text-align: center; margin:auto;">';
		contentsStr += '<table class="com_ta" width="100%" height="42px" marginheight="0px" border="1px solid #b1b1b1" cellspacing="0" cellpadding="0" style="text-align: center;margin-left:-1px;border-top-style:none;border-bottom-style:hidden;border-right-style:hidden;border-left-style:none">';
		contentsStr += '<colgroup>';
		contentsStr += '<col width=""/>';
		contentsStr += '</colgroup>';
		contentsStr += '<tbody>';
		contentsStr += '<tr>';
// 		contentsStr += '<td class="pt20"><h3>위와 같은 사유로 학자금을 신청합니다.</h3></td>';
		contentsStr += '<td class="bd_color">위와 같은 사유로 학자금을 신청합니다.</td>';
		contentsStr += '</tr></table>';

		return contentsStr;
	}
	
	function selectPopGridRow(e){
		
		$(".personDetail").removeClass("k-state-selected");
		
		$(e).addClass("k-state-selected");
	}
	
	function gridRowAdd(){
		
		if($addIndex >= 3){
			alert("학자금신청항목은 최대 3개까지 추가가능합니다.");
			return false;
		}
		
		++$addIndex;
		
		$(".Guide").remove();
		
		var oneRow = '<tr class="personDetail" onclick = "selectPopGridRow(this)"><td class="txtCenter pl5 pr5"><span id="index" name="index" style="width: 90%">'+$addIndex+ '</span>';
		
		oneRow += '<td class="txtCenter pl5 pr5"><input type="text" id="education_detail_type_name'+$addIndex+'" name="education_detail_type_name" style="width: 90%"></td>';
		
		oneRow += '<td class="txtCenter pl5 pr5"><input type="text" numberOnly id="money'+$addIndex+'" name="money" value="0" style="width: 90%" onfocusout="applySum();"></td>';
		
		oneRow += '<td class="txtCenter pl5 pr5"><input type="text" id="remark" name="remark" value="" style="width: 90%"></td></tr>'
		
		$('#personDetailTable').append(oneRow);
		
// 		$scholarRegisterDataFilter = $scholarRegisterData.filter(function (n){
// 			return n.scholar_type_id == $("#scholarship").val();
// 		})
		
// 		if($scholarRegisterDataFilter[0]){
// 			$("#money"+$addIndex).val($scholarRegisterDataFilter[0].scholar_money_format);
// 		}
		
// 		$("#education_detail_type_name"+$addIndex).kendoDropDownList({
// 			dataTextField : "classification_name",
// 			dataValueField : "classification_id",
// 			dataSource : $scholarRegisterDataFilter,
// 			change : popChangeSet
// 		}).data("kendoDropDownList");

		onlyNumber();
		applySum();
	}
	
	function popChangeSet(e){
		var data = this.dataItem();
		$(".k-state-selected").find("[name=money]").val(data.scholar_money_format);
		applySum();
	}
	
	function applySum(){
		var education_sum_money = 0;
		
		if($(".Guide").length == 0){
			$(".personDetail").each(function(i,v){
				education_sum_money += ($(this).find("[name=money]").val().replace(/,/gi,""))*1;
			})
		}
		education_sum_money = education_sum_money.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
		$("#education_sum_money").val(education_sum_money);
	}
	
	function gridGuide(){
		
		var oneRow =  '<tr class="personDetail Guide"><td colspan = "4">추가 버튼을 통해 학자금신청이 가능합니다.</td></tr>';
		
		$('#personDetailTable').append(oneRow);
	}
	
	function popGrid(){
		
		if($insertChk){
			
			gridGuide();
			
		}else{
			$.each($grid2DataSource._data, function(i,v){
				
				$addIndex = i +1;
				
				var oneRow = '<tr class="personDetail" onclick = "selectPopGridRow(this)"><td class="txtCenter pl5 pr5" ><span id="index" name="index" style="width: 90%">'+$addIndex+ '</span>';
				
				oneRow += '<td class="txtCenter pl5 pr5" ><input type="text" id="education_detail_type_name'+$addIndex+'" name="education_detail_type_name" value="'+v.education_detail_type_code+ '" style="width: 90%"></td>';
				
				oneRow += '<td class="txtCenter pl5 pr5" ><input type="text" numberOnly id="money'+$addIndex+'" name="money" value="'+v.money_format+ '" style="width: 90%"  onfocusout="applySum();"></td>';
				
				oneRow += '<td class="txtCenter pl5 pr5" ><input type="text" id="remark" name="remark" value="'+v.remark+ '" style="width: 90%"></td>'
				
				oneRow += '<input type="hidden" id="education_expense_detail_id'+$addIndex+'" name="education_expense_detail_id" value="'+v.education_expense_detail_id+'"/></tr>';
				
				$('#personDetailTable').append(oneRow);
				
// 				$scholarRegisterDataFilter = $scholarRegisterData.filter(function (n){
// 					return n.scholar_type_id == $("#scholarship").val();
// 				})
				
// 				$("#education_detail_type_name"+$addIndex).kendoDropDownList({
// 					dataTextField : "classification_name",
// 					dataValueField : "classification_id",
// 					dataSource : $scholarRegisterDataFilter
// 				});
			});
			
		}
		applySum();
		onlyNumber();
		
	}

	function gridRowDelete(){

		if($addIndex > 0){
			--$addIndex;
		}

		if($(".personDetail").length == 1){
			$(".personDetail")[$(".personDetail").length-1].remove();
			gridGuide();
		}else{
			$(".personDetail")[$(".personDetail").length-1].remove();
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
			$("#empName").val(row.emp_name);
			$("#empDept").val(row.dept_name);
			$("#empDuty").val(row.duty);
			

			myWindow.data("kendoWindow").close();
			$familyInfo = [];
			makeDropDownList();
			gridReload();
		});
	}
}

</script>


<div class="iframe_wrap">
	<div class="sub_title_wrap">
		<div class="title_div">
			<h4>학자금승인</h4>
		</div>
	</div>
	<div class="sub_contents_wrap">
		<div class="btn_div mt10 cl">
			<div class="left_div">
				<p class="tit_p mt5 mb0">학자금승인</p>
			</div>
			<div class="right_div">
				<div class="controll_btn p0">
<!-- 					<button type="button" id="approvalChk" onclick = "approvalChk()">결재보기</button> -->
					<button type="button" id="mainGrid" onclick = "mainGrid()">조회</button>
					<button type="button" id="approval" onclick = "approval()">승인</button>
					<button type="button" id="delete" onclick = "approCancle()">승인취소</button>
				</div>
			</div>
		</div>
		<div class="com_ta">
			<div class="top_box gray_box" id = "dataBox">
				<dl>
					<dt>승인여부</dt>
					<dd>
						<select id = "statusType" style="text-align:center;">
							<option value="" selected>전체</option>
							<option value="2">승인</option>
							<option value="1">미승인</option>
						</select>
					</dd>
					<dt>
<%-- 						<img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> --%>
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
<!-- 					</dd> -->
					
<!-- 					<dt> -->
<!-- 						성명 -->
<!-- 					</dt> -->
<!-- 					<dd> -->
<!-- 						<input type="text" id = "empName" name = "" value = "" readonly/> -->
<!-- 					</dd> -->
					
<!-- 					<dt> -->
<!-- 						부서 -->
<!-- 					</dt> -->
<!-- 					<dd> -->
<!-- 						<input type="text" id = "empDept" name = "" value = "" readonly/> -->
<!-- 					</dd> -->
					
<!-- 					<dt></dt> -->
<!-- 					<dd style="float:right" class = "mr20"> -->
<!-- 						<input type="hidden" id = "empDuty" name = "" value = ""/> -->
						
<!-- 						<input type="button" id="empListPopBtn" value="사원검색"></button> -->
<!-- 					</dd> -->
<!-- 				</dl> -->
<!-- 			</div> -->
<!-- 		</div> -->
		
		<div class="com_ta3">
			<div  id = "grid">
			</div>
		</div>
		
<!-- 		<div class="btn_div mt10 cl"> -->
<!-- 			<div class="left_div"> -->
<!-- 				<p class="tit_p mt5 mb0">학자금신청 세부사항</p> -->
<!-- 			</div>			 -->
<!-- 		</div> -->
		
<!-- 		<div class="com_ta4"> -->
<!-- 			<div  id = "grid2"> -->
<!-- 			</div> -->
<!-- 		</div> -->
		
		<div id = "innerhtml"></div>
		
	</div>
	
</div>

<!-- 학자금신청팝업 -->
<div class = "pop_wrap_dir" id = "popUp" stlye ="width:600px;">
	<div class = "pop_head">
		<h1>학자금승인</h1>
	</div>
	
	<div class = "pop_con">
		<div class = "top_box">
			<dl>
				<dt>신청일자</dt>
				<dd>
					<input type="text" id = "apply_date" style = "width:120px;text-align:center;" value="${nowDate}" disabled/>
				</dd>
				<dt>
					<img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="checkIcon" />대상자
				</dt>
				<dd>
					<input type = "text" id = "target_name" check="must" class="popInput" style="width:122px; heigth: 24px;text-align:center;">
					</input>
				</dd>
				
			</dl>
			<dl class = "next2">
				<dt>
					<img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="checkIcon" />학교명
				</dt>
				<dd>
					<input type="text" id = "education_institution" class="popInput" check="must" style = "width:120px;text-align:center;"/>
				</dd>
<!-- 				<dt> -->
<%-- 					<img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="checkIcon" />학자금 --%>
<!-- 				</dt> -->
<!-- 				<dd> -->
<!-- 					<select id = "scholarship" check="must" style="width:122px;">	 -->
<!-- 					</select> -->
<!-- 				</dd> -->
				<dt>관계</dt>
				<dd>
					<input type="text" id = "target_relationship" class="popInput" style="width:120px;text-align:center;" readonly/>
				</dd>
			</dl>
			<dl class="next2">
				<dt>
					<img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="checkIcon" />학년
				</dt>
				<dd>
					<input type="text" id = "education_grade" class="popInput" check="must" style = "width:120px;text-align:center;"/>
				</dd>
				<dt>신청학기</dt>
				<dd>
					<select id = "education_term" style = "width:120px;text-align:center;">
						<option value="1/4분기">1/4분기</option>
						<option value="2/4분기">2/4분기</option>
						<option value="3/4분기">3/4분기</option>
						<option value="4/4분기">4/4분기</option>
					</select>
				</dd>
			</dl>
			
			<dl class="next2">
				<dt>구분</dt>
				<dd>
					<input type="text" id = "scholarship_kind" class="popInput" style = "width:120px;text-align:center;" />
				</dd>
				<dt>금액</dt>
				<dd>
					<input type="text" id = "education_sum_money" class="popInput" style = "width:120px;text-align:center;"/>
				</dd>
			</dl>
			
			<dl class="next2">
				<dt>비고</dt>
				<dd>
					<input type="text" id = "remark" class="popInput" style = "width:380px;text-align:center;" />
					<input type="hidden" id = "scholarship" style="width:122px;" value="학자금">
				</dd>
			</dl>
		</div>
<!-- 		<div class="btn_div mt10 cl"> -->
<!-- 			<div class="right_div"> -->
<!-- 				<div class="controll_btn p0"> -->
<!-- 					<button type="button" id="gridRowAdd" class="blue_btn" onclick = "gridRowAdd()">추가</button> -->
<!-- 					<button type="button" id="gridRowDelete" class="blue_btn" onclick = "gridRowDelete()">삭제</button> -->
<!-- 				</div> -->
<!-- 			</div> -->
<!-- 		</div> -->
<!-- 		<div class="com_ta2"> -->
<!-- 			<div id = "popGrid"> -->
<!-- 			</div> -->
<!-- 						<table id="personDetailTable" style="width: 100%" > -->
<!-- 								<tr> -->
									
<!-- 									<th style="width: 20%">번호</th> -->
<!-- 									<th style="width: 30%">구분</th> -->
<!-- 									<th style="width: 20%">금액</th> -->
<!-- 									<th style="width: 30%">비고</th> -->
									
<!-- 								</tr> -->
								
<!-- 							</table> -->
						
<!-- 		</div> -->
		<div class = "top_box mt5">
			<dl class="bg_skyblue2" style="background-color: #CEF6F5">
				<dt class="ml5" style="width: 150px">
					<img src="<c:url value='/Images/ico/ico_alert.png'/>" alt="alertIcon" />&nbsp;&nbsp;학자금신청 안내
				</dt>
			</dl>
			<dl style="background-color: #ffffff">
<!-- 				<dt style="width:50px">&nbsp;</dt> -->
				<dd class="pl20 pb10">
					붙임<br>
					1. 등록금납부통지서(고지서) 또는 영수증(사본 포함)<br>
					2. 인․허가증 사본(유아교육기관 최초 신청시에 한함)
				</dd>
			</dl>
		</div>
	</div>

	<div class = "pop_foot">
		<div class = "btn_cen pt12">
			<input type="button" class = "blue_btn" id = "save" onclick="save('click')" value="신청"/>
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
