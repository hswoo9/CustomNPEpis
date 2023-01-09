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
// var $codeList = JSON.parse('${codeList}');

// $familyInfo = $.each($familyInfo, function(i,v){
	
// 	$.each($codeList.list, function(a,b){
// 		if(v.CD_RELA == b.relationship_id){
// 			v.rela_name = b.relationship_name;
// 			return;
// 		}
// 	})
// })
var $welfare_apply_id = '';
var $rowData = {};					//그리드한줄정보
var $gridIndex = 0;					//그리드인덱스번호
var $insertChk = true;				//신청화면 insert/update 구분
var $addIndex = 0;					//팝업그리드 인덱스
var $empRowData = [];			//신청자사원정보
var $scholarRegisterData;		//학자금상세정보데이터
var $dataSource = new kendo.data.DataSource({		//그리드데이터소스
	serverPaging : true,
	pageSize : 10,
	transport : {
		read : {
			url : _g_contextPath_+ "/vacationApply/welfareApplyList",
			dataType : "json",
			type : "post"
		},
		parameterMap: function(data, operation) {
			
// 			data.request_emp_seq = $("#empSeq").val();
// 			data.request_emp_name = $("#empName").val();
// 			data.request_dept_seq = $("#empDept").val();
			data.status = $("#status").val();
			data.apply_from_date = $("#apply_from_date").val().replace(/-/gi,'');
			data.apply_to_date = $("#apply_to_date").val().replace(/-/gi,'');
			
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
				request_start_date_format : {editable : true},
				status_name : {editable : false},
				update_date : {editable : false},
				apply_type : {editable : false},
				apply_date_format : {editable : false},
				request_emp_name : {editable : false},
				request_dept_name : {editable : false},
				request_position : {editable : false},
				apply_family_name : {editable : false},
				apply_family_number : {editable : false},
	    	}
	    }
	}
});

var $grid2DataSource = new kendo.data.DataSource({
	serverPaging : true,
	pageSize : 5,
	transport : {
		read : {
			url : _g_contextPath_+ "/vacationApply/welfareApplyDetailList",
			dataType : "json",
			type : "post"
		},
		parameterMap: function(data, operation) {

			data.emp_seq = '${userInfo.empSeq}';
			
	     	return data;
	     }
	},
	schema : {
		data : function(response){
			return response.list;
		},
	    model : {
	    	fields : {
	    		money : {type : "number", validation: {required: true}},
	    		
	    	}
	    }
	}
});

	$(function(){
		
		defaultSet();
		$("select").kendoDropDownList({});
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
		
		$(document).on('change', "[name='file']", function(){
			var index = $(this).val().lastIndexOf('\\') + 1;
			var valLength = $(this).val().length;
			var row = $(this).closest('dd');
			var fileNm = $(this).val().substr(index, valLength);
			row.find('#fileID1').val(fileNm).css({'color':'#0033FF'});
		});
		
		mainGrid();
// 		subGrid();
		empListPop();
		console.log("${userInfo}");
		onlyNumber();

	});
	
	function defaultSet(){
		
		$("#empName").val("${userInfo.empName}");
		empRowDataSet();
		
		var empSeq = "${userInfo.empSeq}";
		$("#empNo").val($empRowData.erp_emp_num);
		$("#empSeq").val($empRowData.emp_seq);
		$("#empName").val($empRowData.emp_name);
		$("#empDept").val($empRowData.dept_name);
	}

	function dbclickToApply(e){
		
		$(e).closest("tr").addClass("k-state-selected");
		var grid = $('#grid').data("kendoGrid");
		var dataItem = grid.dataItem($(".k-state-selected"));
		$("#popUp").data("kendoWindow").open();
		$("#apply").fadeOut();
		$("#gridRowAdd").hide();
		$("#gridRowDelete").hide();
		$("#save").hide();
		$(".file_input_button").hide();
		
		$("#apply_type").data("kendoDropDownList").value(dataItem.apply_type);
		$("#request_emp_name").val(dataItem.request_emp_name);
		$("#request_emp_no").val(dataItem.request_emp_no);
		$("#request_dept_seq").val(dataItem.request_dept_seq);
		$("#request_dept_name").val(dataItem.request_dept_name);
		$("#request_position").val(dataItem.request_position);
		$("#apply_date").val(dataItem.apply_date);
		$("#residence_number").val(dataItem.residence_number);
		$("#fileID1").val(dataItem.real_file_name);
		
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
		$welfare_apply_id = "";
	}

	function apply(type){	//신청 팝업

		if(type == 'lose' && $('#grid2 .checkbox:checked').length<1){
			alert('자격상실 신고할 정보를 체크해주세요.');
			return false;
		}
		
		$("#popUp").data("kendoWindow").open();
		$("#apply").fadeOut();
		$("#gridRowAdd").show();
		$("#gridRowDelete").show();
		$("#save").show();
		$(".file_input_button").show();
		popGrid();
		empRowDataSet();
		
		$("#request_emp_seq").val($empRowData.emp_seq);
		$("#request_emp_name").val($empRowData.emp_name);
		$("#request_dept_seq").val($empRowData.dept_seq);
		$("#request_dept_name").val($empRowData.dept_name);
		$("#request_position").val($empRowData.position);
		$("#request_position_code").val($empRowData.position_code);
		var rdn = $empRowData.bday.replace(/-/gi,'')+' - ';
		if($empRowData.gender_code == 'M'){
			if($empRowData.bday.substring(0,4)*1 <2000){
				rdn += '1******';	
			}else{
				rdn += '3******';
			}
		}else{
			
			if($empRowData.bday.substring(0,4)*1 <2000){
				rdn += '2******';	
			}else{
				rdn += '4******';
			}
		}
		$("#residence_number").val(rdn);
		
		if(type == 'new'){
			$("#apply_type").data("kendoDropDownList").select(0);
			$("#gridRowAdd").show();
			$("#gridRowDelete").show();
		}else{
			$("#apply_type").data("kendoDropDownList").select(1);
			$("#gridRowAdd").hide();
			$("#gridRowDelete").hide();
			$(".Guide").remove();
			var ch = $('#grid2 .checkbox:checked');
			var approChk = false;
			$.each(ch, function(i,v){
				
				var dataItem = $('#grid2').data("kendoGrid").dataItem($(v).closest("tr"));
				if(dataItem.status != '1'){
					approChk = true;
					return false;
				}else{
					$addIndex++
					
					var oneRow = '<tr class="personDetail" onclick = "selectPopGridRow(this)">';
					oneRow += '<input type="hidden" id="user_welfare_id'+$addIndex+'" name="user_welfare_id" value="'+dataItem.user_welfare_id+ '">';
					oneRow += '<td class="txtCenter pl5 pr5"><input type="text" id="family_name'+$addIndex+'" name="family_name" value="'+dataItem.family_name+ '" style="width: 90%" readonly></td>';
					oneRow += '<td class="txtCenter pl5 pr5"><input type="text" id="family_relationship'+$addIndex+'" name="family_relationship" value="'+dataItem.family_relationship+ '" style="width: 90%" readonly></td>';
					oneRow += '<td class="txtCenter pl5 pr5"><input type="text"  id="family_birth'+$addIndex+'" name="family_birth" value="'+dataItem.family_birth+ '" style="width: 90%" readonly></td>';
					oneRow += '<td class="txtCenter pl5 pr5"><input type="text" id="family_address'+$addIndex+'" name="family_address" value="'+dataItem.family_address+ '" style="width: 90%" readonly></td>'
					oneRow += '<td class="txtCenter pl5 pr5"><input type="text" id="remark'+$addIndex+'" name="remark" value="'+dataItem.remark+ '" style="width: 90%" readonly></td></tr>'
					
					$('#personDetailTable').append(oneRow);
					$("#family_relationship"+$addIndex).kendoDropDownList({
						dataTextField : "code_kr",
						dataValueField : "code",
						dataSource : $family_code,
						enable : false
					}).data("kendoDropDownList").text(dataItem.family_relationship);

				}
			});
			
			if(approChk){
				alert('승인이외의 건이 포함되어 있습니다.');
				return false;
			}
		}
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

		$("#apply_type").data("kendoDropDownList").select(0);
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
			var param = { welfare_apply_id : dataItem.welfare_apply_id};
			if(confirm("삭제하시겠습니까?")){
				if(status == '신청'){
					
					$.ajax({
						
						url : _g_contextPath_+'/vacationApply/welfareApplyDeleteRow',
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
			height : 600,
			dataBound : dataBound,
			sortable : true,
			pageable : {
				refresh : true,
				pageSizes : true,
				buttonCount : 5
			},
			persistSelection : true,
			editable : true,
			selectable : "row",
			columns : [
				{
					width : "30px",
					headerTemplate : function(e){
						return '<input type="checkbox" id = "checkboxAll">';
					},
					template : function(e){
						
						return '<input type="checkbox" id = "checkbox'+e.welfare_apply_id+'" class = "checkbox">';

					}
				},
				{
					width : "5%",
					field : "status_name",
					title : "진행상태"
				},
				{
					width : "7%",
					field : "update_date",
// 					format : '{0: yyyy-MM-dd}',
					title : "승인일",
					template : function(e){
						if(e.update_date == undefined){
							return '';
						}else{
							return kendo.toString(new Date(e.update_date), 'yyyy-MM-dd');
						}
					}
				},
				{
					width : "5%",
					field : "apply_type",
					title : "신청타입",
					template : function(e){
						if(e.apply_type == '1'){
							return '신규';
						}else{
							return '자격상실';
						}
					}
				},
				{
					width : "7%",
					field : "apply_date_format",
					title : "신청일자"
				},
				{
					width : "5%",
					field : "request_emp_name",
					title : "신청인"
				},
				{
					width : "10%",
					field : "request_dept_name",
					title : "신청인부서"
				},
				{
					width : "7%",
					field : "request_position",
					title : "신청인직급"
				},
// 				{
// 					width : "35%",
// 					field : "welfare_apply_id",
// 					title : "신청번호"
// 				},
				{
					width : "30%",
					field : "apply_family_name",
					title : "신청가족"
				},
				{
					width : "20%",
					field : "apply_family_number",
					title : "신청가족인원"
				},
				{
					width : "10%",
					field : "request_start_date_format",
					title : "적용시작일",
					format : '{0:yyyy-MM-dd}',
					editor : requestStartDatePicker
					
// 					template : function(e){
// 						debugger
// 						return '<input type="text" name="request_start_date" value="'+e.request_start_date_format+'">' ;
// 					}
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
					field : "welfare_apply_id",
					title : "보기",
					template : function(e){
						return '<input type="butotn" class="blue_btn" style="width:25px;text-align:center;" name="preView" value="보기" onclick="preView('+e.welfare_apply_id+',this);">';
					}
				}
			],
			change : selectRow

		}).data("kendoGrid");
		
		function selectRow(e){		//row클릭시 data 전역변수 처리

			row = e.sender.select();
			grid = $('#grid').data("kendoGrid");
			$rowData = grid.dataItem(row);
// 			subGrid();
			
		}
		
		$("#checkboxAll").click(function(e){
			if($("#checkboxAll").is(":checked")){
				$("#grid .checkbox").prop("checked", true);
			}else{
				$("#grid .checkbox").prop("checked", false);
			}
		});
	};
	
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
	
	function requestStartDatePicker(container, options){
	    $('<input required name="' + options.field + '"/>')
	    .appendTo(container)
	    .kendoDatePicker({
		    depth: "month",
		    start: "month",
		    culture : "ko-KR",
			format : "yyyy-MM-dd",
			value : new Date(),
			change : function(e){
// 				debugger
				$(this).val(e.sender._oldText);
				
			}
			
		});
	}
	
	function preView(welfare_apply_id, e){
		
		dataItem = $('#grid').data("kendoGrid").dataItem($(e).closest('tr'));
		
		var url = _g_contextPath_+"/vacationApply/familyReport";
		url += "?family_apply_id="+welfare_apply_id;
		url += "&apply_from_date="+$("#apply_from_date").val().replace(/-/gi,'');
		url += "&apply_to_date="+$("#apply_to_date").val().replace(/-/gi,'');
		url += "&report_type=2";
		url += "&access_type=admin";
		url += "&apply_type="+dataItem.apply_type;
		url += "&appro_status="+dataItem.status;
		
		window.open(url, "viewer", "width=1100, height=820, resizable=yes, scrollbars = yes, status=no, toolbar=no, top=50, left=100", "newWindow");

	}
	
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
	
	function subGrid(){
		
		var grid =  $("#grid2").kendoGrid({
			dataSource: $grid2DataSource,
			sortable : true,
			height : 300,
			persistSelection : true,
			columns : [
				{
					width : "30px",
					headerTemplate : function(e){
						return '<input type="checkbox" id = "checkboxAll">';
					},
					template : function(e){
						return '<input type="checkbox" id = "checkbox'+e.user_welfare_id+'" class = "checkbox">';
// 						if(e.status == '1'){
// 							return '<input type="checkbox" id = "checkbox'+e.user_welfare_id+'" class = "checkbox">';
// 						}else{
// 							return "";
// 						}
					}
				},
				{
					width : "6%",
					field : "status",
					title : "진행상태",
					template : function(e){
						if(e.status == '1'){
							return '승인';
						}else if(e.status == '3'){
							return '상실신청중';
						}else{
							return '승인';
						}
					}
				},
				{
					field : "family_name",
					title : "성명"
				},
				{
					field : "family_relationship",
					title : "관계"
				},
				{
					field : "family_birth",
					title : "생년월일"
				},
				{
					field : "family_address",
					title : "주소"
				},
				{
					field : "remark",
					title : "비고"
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
					
					var list = {};
					list.benefit_type = '2';
					list.welfare_apply_id = dataItem.welfare_apply_id+"";
					list.update_emp_seq = '${userInfo.empSeq}';
					list.apply_type = dataItem.apply_type;
					if(dataItem.apply_type == '1'){
						list.mainStatus = '2';
						list.detailStatus  = '1';
					}else{
						list.mainStatus = '2';
						list.detailStatus  = '4';
					}
					list.emp_seq = dataItem.request_emp_seq;
					list.request_start_date = kendo.toString(dataItem.request_start_date_format,'yyyyMMdd').replace(/-/gi,'');
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
// 			debugger
// 			return false;
			
			$.ajax({
				url: _g_contextPath_ + '/vacationApply/welfareApprovalUpdate',
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

	function save(sep){
		if($("#fileID1").val()==''||$("#fileID1").val()==null){
			alert("파일첨부는 필수입니다.");
			$("#fileID1").focus();
			return false;
		}
		
		var param = {
				apply_date : $("#apply_date").val().replace(/-/gi,""),
				apply_type : $("#apply_type").val(),
				remark : '',
				request_emp_seq : $empRowData.emp_seq,
				request_emp_name : $empRowData.emp_name, 
				request_emp_no : $empRowData.erp_emp_num, 
				request_dept_seq : $empRowData.dept_seq, 
				request_dept_name : $empRowData.dept_name,
				request_position_code : $empRowData.position_code,
				request_position : $empRowData.position,
				residence_number :  $("#residence_number").val(),
				create_emp_seq : "${userInfo.empSeq}"
		}
		
		if($insertChk){		//status : insert
			param.status = "insert";
				
				var data = [];
				var apply_family_name = '';
				$(".personDetail").each(function(i,v){
					var list = {};
					if(param.apply_type == '2'){
						list.user_welfare_id = $(v).find("[name='user_welfare_id']").val();
					}
					list.emp_seq = $empRowData.emp_seq;
					list.family_name = $(v).find("[name='family_name']").val();
					list.family_relationship = $(v).find("[name='family_relationship']").data("kendoDropDownList").text();
					list.family_birth = $(v).find("[name='family_birth']").val();
					list.family_address = $(v).find("[name='family_address']").val();
					list.remark = $(v).find("[name=remark]").val();
					list.create_emp_seq = "${userInfo.empSeq}";
					data.push(list);
					apply_family_name += list.family_name + ', ';
				})
				param.data = JSON.stringify(data);
				param.apply_family_name = apply_family_name.substring(0,apply_family_name.length-2);
				
		}else{		//status : update
			param.status = "update";
			param.welfare_apply_id = $rowData.welfare_apply_id;
				var data = [];
				var apply_family_name = '';
				$(".personDetail").each(function(i,v){
					var list = {};
					list.user_welfare_id = $rowData.user_welfare_id;
					list.emp_seq = $empRowData.emp_seq;
					list.family_name = $(v).find("[name='family_name']").val();
					list.family_relationship = $(v).find("[name='family_relationship']").data("kendoDropDownList").text();
					list.family_birth = $(v).find("[name='family_birth']").val();
					list.family_address = $(v).find("[name='family_address']").val();
					list.remark = $(v).find("[name=remark]").val();
					list.create_emp_seq = "${userInfo.empSeq}";
					data.push(list);
					apply_family_name += list.family_name + ', ';
				})
				param.data = JSON.stringify(data);
				param.apply_family_name = apply_family_name.substring(0,apply_family_name.length-2);
		}
		
		$.ajax({
			url : _g_contextPath_+'/vacationApply/welfareApplySave',
			data : param,
			type : "POST",
			async : false,
			success : function(result){

				$welfare_apply_id = result.welfare_apply_id;
				if(sep == 'click'){
					if(result.status == "insert"){
						var form = $("#fileData")[0];
						var formData = new FormData(form);
						formData.append('target_table_name','family_file_attach');
						formData.append('target_id',result.welfare_apply_id);
						$.ajax({
							url: _g_contextPath_ + '/vacationApply/welfareApplyFileSave',
							type: 'post',
							dataType: 'json',
							data: formData,
							cache: false,
							contentType: false,
							processData: false,
							success: function(json){
								alert("저장완료되었습니다.");
							}
						});

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

	function appr(){
		
		var welfare_apply_id = $welfare_apply_id;
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
		if($familyInfo.length>0){
			data.target_name = $("#target_name").data("kendoDropDownList").text();
		}else{
			data.target_name = $("#target_name").val();
		}
		
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
		
		if($addIndex >= 6){
			alert("부양가족신청항목은 최대 6개까지 추가가능합니다.");
			return false;
		}
		
		++$addIndex;
		
		$(".Guide").remove();
		
		var oneRow = '<tr class="personDetail" onclick = "selectPopGridRow(this)">';
		
		oneRow += '<td class="txtCenter pl5 pr5"><input type="text" id="family_name'+$addIndex+'" name="family_name" style="width: 90%"></td>';
		
		oneRow += '<td class="txtCenter pl5 pr5"><input type="text" id="family_relationship'+$addIndex+'" name="family_relationship" style="width: 90%"></td>';
		
		oneRow += '<td class="txtCenter pl5 pr5"><input type="text"  id="family_birth'+$addIndex+'" name="family_birth" value="" style="width: 90%"></td>';
		
		oneRow += '<td class="txtCenter pl5 pr5"><input type="text" id="family_address'+$addIndex+'" name="family_address" value="" style="width: 90%"></td>'
		
		oneRow += '<td class="txtCenter pl5 pr5"><input type="text" id="remark'+$addIndex+'" name="remark" value="" style="width: 90%"></td></tr>'
		
		$('#personDetailTable').append(oneRow);
		
		$("#family_relationship"+$addIndex).kendoDropDownList({
			dataTextField : "code_kr",
			dataValueField : "code",
			dataSource : $family_code
		}).data("kendoDropDownList");

		$("#family_birth"+$addIndex).kendoDatePicker({
		    depth: "month",
		    start: "month",
		    culture : "ko-KR",
			format : "yyyy-MM-dd",
			value : new Date()
		});
		
		onlyNumber();
	}

	function gridGuide(){
		
		var oneRow =  '<tr class="personDetail Guide"><td colspan = "5">추가 버튼을 통해 부양가족신청이 가능합니다.</td></tr>';
		
		$('#personDetailTable').append(oneRow);
	}
	
	function popGrid(){
		
		if($insertChk){
			
			gridGuide();
			
		}else{
			
			var grid = $('#grid').data("kendoGrid");
			var dataItem = grid.dataItem($(".k-state-selected"));
			var welfare_apply_id = dataItem.welfare_apply_id;
			var apply_type = dataItem.apply_type;
			var familyData = [];
			
			$.ajax({
				url : _g_contextPath_+"/vacationApply/familyApplyDetailList",
				data : {emp_seq : dataItem.request_emp_seq},
				type : "POST",
				async: false,
				success : function(result){
					
					familyData = result.list;
					
				}
			});
			
			$.each(familyData, function(i,v){
				if(apply_type == '1'){
					if(v.welfare_apply_id == welfare_apply_id){
						
						$addIndex++
						
						var oneRow = '<tr class="personDetail" onclick = "selectPopGridRow(this)">';
						
						oneRow += '<td class="txtCenter pl5 pr5"><input type="text" id="family_name'+$addIndex+'" name="family_name" value="'+v.family_name+ '" style="width: 90%" readonly></td>';
						
						oneRow += '<td class="txtCenter pl5 pr5"><input type="text" id="family_relationship'+$addIndex+'" name="family_relationship" value="'+v.family_relationship+ '" style="width: 90%" readonly></td>';
						
						oneRow += '<td class="txtCenter pl5 pr5"><input type="text"  id="family_birth'+$addIndex+'" name="family_birth" value="'+v.family_birth+ '" style="width: 90%" readonly></td>';
						
						oneRow += '<td class="txtCenter pl5 pr5"><input type="text" id="family_address'+$addIndex+'" name="family_address" value="'+v.family_address+ '" style="width: 90%" readonly></td>'
						
						oneRow += '<td class="txtCenter pl5 pr5"><input type="text" id="remark'+$addIndex+'" name="remark" value="'+v.remark+ '" style="width: 90%" readonly></td></tr>'
						
						$('#personDetailTable').append(oneRow);
					
					}
				}else{
					if(v.lose_welfare_apply_id == welfare_apply_id){
						
						$addIndex++
						
						var oneRow = '<tr class="personDetail" onclick = "selectPopGridRow(this)">';
						
						oneRow += '<td class="txtCenter pl5 pr5"><input type="text" id="family_name'+$addIndex+'" name="family_name" value="'+v.family_name+ '" style="width: 90%" readonly></td>';
						
						oneRow += '<td class="txtCenter pl5 pr5"><input type="text" id="family_relationship'+$addIndex+'" name="family_relationship" value="'+v.family_relationship+ '" style="width: 90%" readonly></td>';
						
						oneRow += '<td class="txtCenter pl5 pr5"><input type="text"  id="family_birth'+$addIndex+'" name="family_birth" value="'+v.family_birth+ '" style="width: 90%" readonly></td>';
						
						oneRow += '<td class="txtCenter pl5 pr5"><input type="text" id="family_address'+$addIndex+'" name="family_address" value="'+v.family_address+ '" style="width: 90%" readonly></td>'
						
						oneRow += '<td class="txtCenter pl5 pr5"><input type="text" id="remark'+$addIndex+'" name="remark" value="'+v.remark+ '" style="width: 90%" readonly></td></tr>'
						
						$('#personDetailTable').append(oneRow);
					
					}
				}


			});
			
		}
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
			<h4>복지포인트승인</h4>
		</div>
	</div>
	<div class="sub_contents_wrap">
		<div class="btn_div mt10 cl">
			<div class="left_div">
				<p class="tit_p mt5 mb0">복지포인트승인</p>
			</div>
			<div class="right_div">
				<div class="controll_btn p0">
					<button type="button" id="mainGrid" onclick = "mainGrid()">조회</button>
					<button type="button" id="approval" onclick = "approval()">승인</button>
<!-- 					<button type="button" id="delete" onclick = "approCancle()">반려</button> -->
				</div>
			</div>
		</div>
		<div class="com_ta">
			<div class="top_box gray_box" id = "dataBox">
				<dl>
					<dt>승인여부</dt>
					<dd>
						<select id = "status" style="text-align:center;">
							<option value="" selected>전체</option>
							<option value="2">승인</option>
							<option value="1">미승인</option>
						</select>
					</dd>
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
		
<!-- 		<div class="btn_div mt10 cl"> -->
<!-- 			<div class="left_div"> -->
<!-- 				<p class="tit_p mt5 mb0">가족정보</p> -->
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
		<h1>복지포인트신청</h1>
	</div>
	
	<div class = "pop_con">
		<div class = "top_box">
			<dl>
				<dt>신청타입</dt>
				<dd>
					<select id = "apply_type" style = "width:125px;text-align:center;" value="" >
						<option value ="1" selected>신규</option>
						<option value="2">자격상실</option>
					</select>
				</dd>
				<dt>신청일자</dt>
				<dd>
					<input type="text" id = "apply_date" style = "width:125px;text-align:center;" value="${nowDate}" disabled/>
				</dd>
			</dl>
			<dl class = "next2">
				<dt>
					성명
				</dt>
				<dd>
					<input type = "text" id = "request_emp_name" class="popInput" style="width:125px; heigth: 24px;text-align:center;" disabled/>
					<input type = "hidden" id = "request_emp_seq" class="popInput" style="width:120px; heigth: 24px;text-align:center;"/>
				</dd>
				<dt>
					주민등록번호
				</dt>
				<dd>
					<input type="text" id = "residence_number" class="popInput" style = "width:125px;text-align:center;" disabled/>
				</dd>
			</dl>		
			<dl class = "next2">
				<dt>
					소속
				</dt>
				<dd>
					<input type="text" id = "request_dept_name" class="popInput" check="must" style = "width:125px;text-align:center;" disabled/>
					<input type = "hidden" id = "request_dept_seq" class="popInput" style="width:122px; heigth: 24px;text-align:center;"/>
				</dd>
<!-- 				<dt> -->
<%-- 					<img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="checkIcon" />학자금 --%>
<!-- 				</dt> -->
<!-- 				<dd> -->
<!-- 					<select id = "scholarship" check="must" style="width:122px;">	 -->
<!-- 					</select> -->
<!-- 				</dd> -->
				<dt>직급</dt>
				<dd>
					<input type="text" id = "request_position" class="popInput" style="width:125px;text-align:center;" disabled/>
					<input type = "hidden" id = "request_position_code" class="popInput" style="width:122px; heigth: 24px;text-align:center;"/>
				</dd>
			</dl>	
			
			<form id = "fileData">
			<dl class="next2">
				<dt>증빙서류</dt>
				<dd>
					<input type="text" id="fileID1" class="file_input_textbox clear popInput" style="width:220px;" readonly="readonly" placeholder="파일 선택" /> 
					<input type="button" value="업로드" class="file_input_button" style="width:40px;"/> 
					<input type="file" id="fileID" name="file" value="" class="hidden" />
				</dd>
			</dl>
			</form>
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
							<th style="width: 12%">성명</th>
							<th style="width: 25%">관계</th>
							<th style="width: 23%">생년월일</th>
							<th style="width: 30%">주소</th>
							<th style="width: 10%">비고</th>
						</tr>
				</table>
		</div>
		<div class = "top_box mt5">
			<dl class="bg_skyblue2" style="background-color: #CEF6F5">
				<dt class="ml5" style="width: 170px">
					<img src="<c:url value='/Images/ico/ico_alert.png'/>" alt="alertIcon" />&nbsp;&nbsp;부양가족신고 안내
				</dt>
			</dl>
			<dl style="background-color: #ffffff">
<!-- 				<dt style="width:50px">&nbsp;</dt> -->
				<dd class="pl20 pb10">
					첨부<br>
					1. 주민등록등본 1부.<br>
					2. 가족관계증명서 1부.<br>
					3. 기타(       )
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
