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
<script type="text/javascript" src='<c:url value="/js/ac/acUtil.js"></c:url>'></script>
<script type="text/javascript" src="<c:url value='/js/jquery.form.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/jszip.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/shieldui-all.min.js' />"></script>



<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
</head>
<style type="text/css">
.k-header .k-link {
	text-align: center;
}

.k-grid-content>table>tbody>tr {
	text-align: center;
}

.k-grid th.k-header, .k-grid-header {
	background: #F0F6FD;
}
.customer-photo{
	width : 70px;
	height : auto;
}
</style>
<body>
	<input type="hidden" id="nowMonth" value="${year}${mm}" />
	
	<input type="hidden" id="dayOrTimeGubun" value="0" />
	
<script type="text/javascript">
	$(document).ready(function() {
		var allDept = JSON.parse('${allDept}');
		allDept.unshift({dept_name : "전체", dept_seq : "99999"});
		$("#deptNm").kendoComboBox({
		      dataSource: allDept,
		      dataTextField: "dept_name",
			  dataValueField: "dept_seq",
			  select : onDeptSeqSelect,
			  index: 0,
		});		
		
	    $("#endMonth").kendoDatePicker({
	        start: "year",
	        depth: "year",
	        format: "yyyy-MM",
			parseFormats : ["yyyy-MM"],
	        culture : "ko-KR",
	        dateInput: true
	    });
	    
	    $("#endMonth").val( '${year}' +"-"+ '${mm}');		
		//날짜 초기화----->>
	    $("#fromMonth").kendoDatePicker({
	        start: "year",
	        depth: "year",
	        format: "yyyy-MM",
			parseFormats : ["yyyy-MM"],
	        culture : "ko-KR",
	        dateInput: true
	    });	  
	    var mm = '${mm}';
	    var year = '${year}';
	    if(mm == 01){
	    	mm = 12;
	    	year = year-1; 
	    }else{
	    	if(mm < 11){
	    		mm = '0'+ (mm-1); 
	    	}else{
	    		mm = mm-1;
	    	}
	    }
	    $("#fromMonth").val(year+"-"+mm );

	  //-----<<날짜 초기화
	  //사원정보 팝업 초기화----->>
	    $("#empSearch").click(function(){	
	    	 $('#emp_name').val("");
	    	 $('#selectedEmpName').val('');
	    	 $("#empPopUp").data("kendoWindow").open();
	    	 empGridReload();
		 });
	    
		 //팝업 초기화
		 $("#empPopUp").kendoWindow({
		     width: "600px",
		    height: "750px",
		     visible: false,
		     actions: ["Close"]
		 }).data("kendoWindow").center();
		 
	     function empPopUpClose(){
	    	 $("#empPopUp").data("kendoWindow").close();
	     }
	     
		 $("#empPopUpCancel").click(function(){
			 $("#empPopUp").data("kendoWindow").close();
		 });
		 
		  //-----<<사원정보 팝업 초기화
	  
		$("#status").kendoComboBox({
			dataSource: [
				{text : "전체", value : "9"}
		      	,{text : "전송", value : "1",}
		    	,{text : "미전송", value : "0"}
		      ],
		      dataTextField: "text",
		      dataValueField: "value",
		      index: 1,
		      select : onSelect
		});
		  
        function onSelect(e) {
    		var dataItem = this.dataItem(e.item.index());
    		//$('#retireeYnVal').val(dataItem.value);
     	}		
	});
</script>

<script type="text/javascript">

function fn_openSubmitPage(e){
	var dataItem = $("#insertResolutionMainGrid").data("kendoGrid").dataItem($(e).closest("tr"));	
	console.log(dataItem);
	window.open("", "pop", "menubar=no,width=1500,height=900,toolbar=no, scrollbars=yes");
	$('#submitData').val(JSON.stringify(dataItem));

	document.submitPage.action = _g_contextPath_+"/kukgoh/admResolutionSubmitPage";
	document.submitPage.target = "pop";
	document.submitPage.method = "post";
	document.submitPage.submit();

}

function fn_formatDate(str){
	return str.substring(0,4) + "-" + str.substring(4,6) + "-" + str.substring(6,8) ;
}

function fn_formatMoney(str){
        str = String(str);
        return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
}

function fn_openInvoicePage(e){
	var row = $(e).closest("tr");
	var grid = $('#insertResolutionMainGrid').data("kendoGrid");
	var data = grid.dataItem(row);
	
	$('#BSNSYEAR').val(data.BSNSYEAR);
	$('#DDTLBZ_ID').val(data.DDTLBZ_ID);
	$('#EXC_INSTT_ID').val(data.EXC_INSTT_ID);
	$('#GISU_DT').val(data.GISU_DT);
	$('#GISU_SQ').val(data.GISU_SQ);
	$("#BG_SQ").val(data.BG_SQ);
	$('#CO_CD').val(data.CO_CD);
	
	$('#popUp').data('kendoWindow').open();
	invoiceMainGrid();
}
function onDeptSeqSelect(e){
	var dataItem = this.dataItem(e.item.index());
	var selectDeptSeq = dataItem.dept_seq;
	$('#deptSeq').val(selectDeptSeq);
	
	if (selectDeptSeq === '99999') { // 전체
		$('#erpDeptSeq').val('');
		$('#selectedEmpName').val('');
		$('#erpEmpSeq').val('');
		return;
	}
	
	$.ajax({
 		url: _g_contextPath_+"/kukgoh/getErpDeptNum",
 		dataType : 'json',
 		data : { deptSeq : selectDeptSeq },
 		type : 'POST',
 		async : false,
 		success: function(result){
 			
 			if (result.erpDeptSeq === '') {
 				alert("해당 부서에 아무도 없습니다.");
 			} else {
	 			$('#erpDeptSeq').val(result.erpDeptSeq);
 			}
 		}
 	});
	
	$('#selectedEmpName').val('');
	$('#erpEmpSeq').val('');
	empGridReload();
}
</script>
	<!-- 사원팝업 ajax -->
	
	<!-- emp 그리드 -->
<script type="text/javascript">

$(function() {
	empGrid();
});

	//사원팝업 ajax
	var empDataSource = new kendo.data.DataSource({
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
	        	data.deptSeq = $('#deptSeq').val();
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
	});

	function empGridReload(){
		$('#empGrid').data('kendoGrid').dataSource.read(0);
	}
	
	function empGrid(){		
		//사원 팝업그리드 초기화
		var grid = $("#empGrid").kendoGrid({
	        dataSource: empDataSource,
	        height: 500,	        
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
						    template : '<input type="button" id="" class="text_blue" onclick="empSelect(this);" value="선택">'
	        		    }],
	        change: function (e){
	        	codeGridClick(e)
	        }
	    }).data("kendoGrid");
		
		grid.table.on("click", ".checkbox", selectRow);
		
		var checkedIds = {};
		
		//on click of the checkbox:
		function selectRow(){
			
			var checked = this.checked,
			row = $(this).closest("tr"),
			grid = $('#empGrid').data("kendoGrid"),
			dataItem = grid.dataItem(row);
			
			checkedIds[dataItem.CODE_CD] = checked;
			if (checked) {
				//-select the row
				row.addClass("k-state-selected");
			} else {
				//-remove selection
				row.removeClass("k-state-selected");
			}
		}
		//사원팝업 grid 클릭이벤트
		function codeGridClick(){			
			var rows = grid.select();
			var record;
			rows.each( function(){
				record = grid.dataItem($(this));
				console.log(record);
			}); 
			subReload(record);
		}
	}

	function subReload(record){
		$('#keyId').val(record.if_info_system_id);
	} 

	//선택 클릭이벤트
	function empSelect(e){		
		var row = $("#empGrid").data("kendoGrid").dataItem($(e).closest("tr"));
		$('#deptNm').val(row.dept_name);
		$('#deptSeq').val(row.dept_seq);
		$('#selectedEmpName').val(row.emp_name);
		$('#loginSeq').val(row.emp_seq);
		$('#erpEmpSeq').val(row.erp_emp_num);
		var empWindow = $("#empPopUp");		
		empWindow.data("kendoWindow").close();
	}
</script>
	<!-- 메인그리드 -->
<script type="text/javascript">	
	$(function() {
		mainGrid();
	});
	function mainGrid(){
		var insertResolutionMainGrid = $("#insertResolutionMainGrid").kendoGrid({
			dataSource : insertResolutionMainGridDataSource,
			dataBound : gridDataBound,
			height : 450,
			sortable : true,
			persistSelection : true,
			selectable : "multiple",
	        columns: [
				{
					field : "KOR_NM",
					title : "발의자",
					width : 60
				},
				{
					//field : "GISU_DT",
					template : function(dataItem){
						return fn_formatDate(dataItem.GISU_DT);
					},					
					title : "발의일자",
					width : 80
				},	{
					field : "GISU_SQ",
					title : "결의번호",
					width : 60
				},
				{
					//field : "DOC_NUMBER",
					template : function(dataItem){
						return "<a href='javascript:fn_docViewPop("+dataItem.C_DIKEYCODE+");' style='color: rgb(0, 51, 255);'>"+dataItem.DOC_NUMBER+"</a>";;
						
					},
					title : "문서번호",
					width : 105
				},
				{
					//field : "DOC_REGDATE",
					template : function(dataItem){
						return fn_formatDate(dataItem.DOC_REGDATE);
					},
					title : "결재일자",
					width : 80
				},
				{
					field : "DOC_TITLE",
					title : "제목",
					template : function(dataItem){
						return "<a href='javascript:fn_docViewPop("+dataItem.C_DIKEYCODE+");' style='color: rgb(0, 51, 255);'>"+dataItem.DOC_TITLE+"</a>";;
						
					},
					//width : 90
				},{
					field : "DIV_NM",
					title : "회계단위",
					width : 70
				},{
					field : "PJT_NM",
					title : "프로젝트",
					width : 100
				},{
					field : "ABGT_NM",
					title : "예산과목",
					width : 100
				},{
					//field : "UNIT_AM",
					template : function(dataItem){
						return fn_formatMoney(dataItem.UNIT_AM);
					},					
					title : "금액",
					width : 100
				},{
					field : "SET_FG_NM",
					title : "결제수단",
					width : 70
				},{
					field : "VAT_FG_NM",
					title : "과세구분",
					width : 70
				},{
					field : "KUKGO_STATE",
					title : "상태",
					width : 60
				},{
					template : function(dataItem){
							return '<input type="button" id="" class="text_blue" onclick="fn_openSubmitPage(this);"value="확인"/>';
					},
					title : "확인",
					width : 60
				}],
	        change: function (e){
	        	insertResolutionMainGridClick(e)
	        }
	    }).data("kendoGrid");
		
		insertResolutionMainGrid.table.on("click", ".checkbox", selectRow);
		
		var checkedIds = {};
		
		// on click of the checkbox:
		function selectRow(){
			var checked = this.checked,
			row = $(this).closest("tr"),
			grid = $('#insertResolutionMainGrid').data("kendoGrid"),
			dataItem = grid.dataItem(row);
			
			checkedIds[dataItem.ANNV_USE_ID] = checked;
			if (checked) {
				//-select the row
				row.addClass("k-state-selected");
			} else {
				//-remove selection
				row.removeClass("k-state-selected");
			}
		}
		
		function insertResolutionMainGridClick(e){
			var dataItem = e.sender;
			console.log(dataItem);
		}
		
		function gridDataBound(e) {
			var grid = e.sender;
			
			if (grid.dataSource.total() == 0) {
				var colCount = grid.columns.length;
				$(e.sender.wrapper).find('tbody').append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
			}
		}
	}
	var insertResolutionMainGridDataSource = new kendo.data.DataSource({
		serverPaging : true,
		pageSize : 10,
		transport : {
			read : {
				url : _g_contextPath_+"/kukgoh/admResolutionMainGrid",
				dataType : "json",
				type : 'post'
			},
			parameterMap : function(data, operation) {
				data.fromMonth = $('#fromMonth').val().replace(/\-/g,''); //특정문자 제거
				data.endMonth = $('#endMonth').val().replace(/\-/g,''); //특정문자 제거
				data.erpDeptSeq = $('#erpDeptSeq').val();
				data.erpEmpSeq = $('#erpEmpSeq').val();
				data.deptSeq = $('#deptSeq').val();
				
				data.status = $("#status").data('kendoComboBox').value();
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
					ANNV_HOLI_STEP_NAME : {
						type : "string"
					},
					code_kr : {
						type : "string"
					}
				}
			}
		}
	});
	function fn_searchBtn(){
		$('#insertResolutionMainGrid').data('kendoGrid').dataSource.page(1);
	}
	</script>

	<div class="iframe_wrap" style="min-width: 1070px;">
		<div class="sub_title_wrap">
			<div class="title_div">
				<h4>지출결의서 집행전송</h4>
			</div>
			<div class="sub_contents_wrap">
				<p class="tit_p mt5 mt20">지출결의서 집행전송</p>
					<div class="top_box">
						<dl>
							<dt  class="ar" style="width:30px;" >기간</dt>
							<dd>
								<input type="text" id="fromMonth" />
								<span>~</span>
								<input type="text" id="endMonth" />
							</dd>	
							<dt  class="ar" style="width:55px" >발의부서</dt>
							<dd>
								<!-- <input type="text" id="deptNm" value='${deptNm}'/>
								<input type="hidden" id="deptSeq" value='${requestDeptSeq}'/> -->
								 <input type="text" id="deptNm" />
								<input type="hidden" id="deptSeq" /> 
							</dd>					
						    <dt  class="ar" style="width:30px; margin-right: 0px;" >성명</dt>
						    <dt  class="ar">
						    	<input type="text" id="selectedEmpName" name="selectedEmpName" value="${empName}" style="width:150px;" disabled>
						    	<input type="hidden" id="loginSeq" name=""value="${empSeq}"/>
						    	<input type="hidden" id="CO_CD"  />
						    	<input type="hidden" id="erpDeptSeq" name="erpDeptSeq"value="${erpDeptSeq}"/>
						    	<input type="hidden" id="erpEmpSeq" name="erpEmpSeq"value="${erpEmpSeq}"/>
						    </dt>
						    <dd>
								<input type="button" id="empSearch" value="선택" />						
							</dd>
							<dt  class="ar" style="width:55px" >전송상태</dt>
							<dd>
								<input type="text" id="status" />
							</dd>
						</dl>
					</div>
					<div class="btn_div">	
						<div class="right_div">
							<div class="controll_btn p0">
								<button type="button" id="searchBtn" onclick="fn_searchBtn();">조회</button>
							</div>
						</div>
					</div>
					<div>
					</div>
					<div class="com_ta2 mt15">
					    <div id="insertResolutionMainGrid"></div>
					</div>		
			</div>
		</div>
	</div>
	
	
	<!-- 사원검색팝업 -->
	<div class="pop_wrap_dir" id="empPopUp" style="width:600px;">
		<div class="pop_head">
			<h1>사원 선택</h1>
		</div>
		<div class="pop_con">
			<div class="top_box">
				<dl>
					<dt class="ar" style="width: 65px; ">성명</dt>
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
		</div><!-- //pop_con -->

		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" class="gray_btn" id="empPopUpCancel" value="닫기" />
			</div>
		</div><!-- //pop_foot -->
	</div><!-- //pop_wrap -->	
	<div>
		<form id="submitPage" name="submitPage" action="/CustomNPTpf/kukgoh/resolutionSubmitPage" method="POST">
			 <input type="hidden" id="submitData" name = "submitData" value=""/> 
		</form>
	</div>	
</body>
</html>