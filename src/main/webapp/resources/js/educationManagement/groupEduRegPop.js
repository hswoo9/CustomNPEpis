function fn_changeEndDt(id, e) {
	debugger
	var key = $(e).val();
	$('#'+id).val(key).attr('readonly', true);
}


/*집합교육대상 선택 왼쪽그리드 첫 번째 select Box 함수*/
function empDnChange(id, e) {
	var key = $(e).val();
	var subKey;
	switch(key) {
		case 'all' :	//	선택이 '전체' 일 경우
			$("#detailDn").kendoComboBox({
			      dataTextField: "text",
			      dataValueField: "value",
			      dataSource: [
			    	  { text: "전체", value: "all" },			    	  
			      ],
			      value : "all"
			});
			$('#deptKey').val('');
			$('#positionKey').val('');
			$('#dutyKey').val('');
			$('#empGrid').data('kendoGrid').dataSource.read();
		break;
		case 'position' : 	//	선택이 '직급' 일 경우
			subKey = 'POSITION'; 
			
			var data = {
					subKey : subKey
				}
			
			var html = '<option value="all">전체</option>';
			
			$.ajax({
				url: _g_contextPath_+"/common/getDutyPosition",
				dataType : 'json',
				data : data,
				async : false,
				type : 'POST',
				success: function(result){
					var dutyPosition = result.getDutyPosition;										
					dutyPosition.unshift({dp_name : "전체", dp_seq : "all"});
					$("#detailDn").kendoComboBox({
						dataSource : dutyPosition,
						dataTextField: "dp_name",
						dataValueField: "dp_seq",
						index: 0,
				    });
				
				}
			})
			
			break;
		case 'duty' :  	//	선택이 '직책' 일 경우
			subKey = 'DUTY'; 
			
			var data = {
					subKey : subKey
				}
			
			var html = '<option value="all">전체</option>';
			
			$.ajax({
				url: _g_contextPath_+"/common/getDutyPosition",
				dataType : 'json',
				data : data,
				async : false,
				type : 'POST',
				success: function(result){
					var dutyPosition = result.getDutyPosition;										
					dutyPosition.unshift({dp_name : "전체", dp_seq : "all"});
					$("#detailDn").kendoComboBox({
						dataSource : dutyPosition,
						dataTextField: "dp_name",
						dataValueField: "dp_seq",
						index: 0,
				    });
				
				}
			})
			
			break;
		case 'dept' :  	//	선택이 '부서' 일 경우
			
			subKey = null;
			var data = {
					subKey : subKey
				}
			
			var html = '<option value="all">전체</option>';
			
			$.ajax({
				url: _g_contextPath_+"/common/getDeptList",
				dataType : 'json',
				data : data,
				async : false,
				type : 'POST',
				success: function(result){
					var deptList = result.getDeptList;										
					deptList.unshift({dept_name : "전체", dept_seq : "all"});
					$("#detailDn").kendoComboBox({
						dataSource : deptList,
						dataTextField: "dept_name",
						dataValueField: "dept_seq",
						index: 0,
				    });
					
				
				}
			})	; 
			break;		
	}
}
/*집합교육대상 선택 왼쪽그리드 첫 번째 select Box 함수*/



$(function(){
	
	/*집합교육대상 선택 왼쪽그리드 두 번째 select Box 함수*/
	$('#detailDn').on('change', function(){
		
		var key = $('#empDn').val();
		var subKey = $(this).val();
		
		switch (key) {
		case 'all':  	//	첫 번째 select Box 선택이 '전체' 일 경우
			$('#deptKey').val('');
			$('#positionKey').val('');
			$('#dutyKey').val('');
			break;
		case 'position':  	//	첫 번째 select Box 선택이 '직급' 일 경우	
			if (subKey == 'all') {  	//	첫 번째 select Box 선택이 '직급' 이고 두 번째 select Box 선택이 '전체' 일 경우
				$('#deptKey').val('');
				$('#positionKey').val('');
				$('#dutyKey').val('');
				
			} else {  	//	첫 번째 select Box 선택이 '직급' 이고 두 번째 select Box 선택이 '전체' 가 아닐 경우
				$('#deptKey').val('');
				$('#positionKey').val(subKey);
				$('#dutyKey').val('');
				
			}
			break;
		case 'duty':  	//	첫 번째 select Box 선택이 '직책' 일 경우	
			if (subKey == 'all') {  	//	첫 번째 select Box 선택이 '직책' 이고 두 번째 select Box 선택이 '전체' 일 경우
				$('#deptKey').val('');
				$('#positionKey').val('');
				$('#dutyKey').val('');
				
			} else {  	//	첫 번째 select Box 선택이 '직책' 이고 두 번째 select Box 선택이 '전체' 가 아닐 경우
				$('#deptKey').val('');
				$('#positionKey').val('');
				$('#dutyKey').val(subKey);
				
			}
			
			break;
		case 'dept':  	//	첫 번째 select Box 선택이 '부서' 일 경우	
			if (subKey == 'all') {  	//	첫 번째 select Box 선택이 '부서' 이고 두 번째 select Box 선택이 '전체' 일 경우
				$('#deptKey').val('');
				$('#positionKey').val('');
				$('#dutyKey').val('');
				
			} else {  	//	첫 번째 select Box 선택이 '부서' 이고 두 번째 select Box 선택이 '전체' 가 아닐 경우
				$('#deptKey').val(subKey);
				$('#positionKey').val('');
				$('#dutyKey').val('');
				
			}
			
			break;
		default:
			break;
		}
		$('#empGrid').data('kendoGrid').dataSource.read();
	})
	/*집합교육대상 선택 왼쪽그리드 두 번째 select Box 함수*/
	
})

$(document).ready(function () {
	
	/*집합교육대상 팝업 관련*/
	var myWindow = $("#popUp");
    undo = $("#add");
    /* 연말 교육 이수 접수 기간 만료 
	*  곽경훈 수정
	* endEdu
	* 시작 2018.12.01. ~  2018.12.31.
	*/
	var endEdu = true;
	 undo.click(function() {
		 if(endEdu == false){
			 alert("교육이수 신청 기간이 종료되었습니다.");
		 }else{
		 $('#keyId').val("");
		 	$('#education_name').val("");
		 	$('#education_hour').val("");
		 	$('#education_start_date').val('');
		    $('#education_end_date').val('');
		 	$('#required_yn').prop("checked", false);
		 	$('#requiredDiv').css({'display':'none'});
		 	$('#education_place').val("");
		 	$('#empDn').val('all');
		    $('#detailDn').val('all');
		    $('#deptKey').val('');
			$('#positionKey').val('');
			$('#dutyKey').val('');
			$('#keyVal').val('');
			$('#empGrid').data('kendoGrid').dataSource.read();
			$('#selectEmp').data('kendoGrid').dataSource.read();
	     myWindow.data("kendoWindow").open();
	     undo.fadeOut();
		 }
	 });
	
	 function onClose() {
	     undo.fadeIn();
	    
	 }
	 $("#cancle").click(function(){
		 myWindow.data("kendoWindow").close();
	 });
	 myWindow.kendoWindow({
	     width: "1000px",
	    height: "680px",
	     visible: false,
	     modal : true,
	     actions: [
	    	 "Close"
	     ],
	     close: onClose
	 }).data("kendoWindow").center();
	 /*집합교육대상 팝업 관련*/
	
	
	 /*집합교육대상 선택 왼쪽그리드*/
	var empDataSource = new kendo.data.DataSource({
		serverPaging: true,
		pageSize: 10000,
	    transport: { 
	        read:  {
	            url: _g_contextPath_+'/common/empInformation',
	            dataType: "json",
	            type: 'post'
	        },
	      	parameterMap: function(data, operation) {
	      		data.deptSeq = $('#deptKey').val();
	        	data.positionKey = $('#positionKey').val();
	        	data.dutyKey = $('#dutyKey').val();
	        	data.empSeq = $('#keyVal').val();
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
		      },
		      model: {
		          fields: {

		        	  emp_seq: { type: "string" },
		        	  
		        	  
		          }
		      }  
	    }
	});


	$(function(){
		
		empGrid();
		selGrid();
		$("#headerCheckbox").change(function(){
			var checkedIds = {};
	        if($("#headerCheckbox").is(":checked")){
	        	$(".leftCheck").prop("checked", "checked");
	        	var checked = this.checked,
                row = $(this).closest("tr"),
                grid = $("#empGrid").data("kendoGrid"),
                dataItem = grid.dataItem(row);

	            checkedIds[dataItem.emp_seq] = checked;
	
	            if (checked) {
	                row.addClass("k-state-selected");
	
	            } else {
	                row.removeClass("k-state-selected");
	               
	            }
	        }else{
	        	$(".leftCheck").removeProp("checked");
	        }
	    });
		
		$("#headerCheckbox2").change(function(){
			debugger
			var checkedIds = {};
	        if($("#headerCheckbox2").is(":checked")){
	        	$(".rightCheck").prop("checked", "checked");
	        	var checked = this.checked,
                row = $(this).closest("tr"),
                grid = $("#selectEmp").data("kendoGrid"),
                dataItem = grid.dataItem(row);

	            checkedIds[dataItem.emp_seq] = checked;
	
	            if (checked) {
	                row.addClass("k-state-selected");
	
	            } else {
	                row.removeClass("k-state-selected");
	               
	            }
	        }else{
	        	$(".rightCheck").removeProp("checked");
	        }
	    });
		
		$('#arrowRight').bind('click', function(){    /*오른쪽 향한 화살표 클릭했을 시 함수*/
        	var ch = $('.leftCheck:checked');
        	var keyVal = $('#keyVal').val();
       		var checked = [];
       		var checkedIds = new Array();
       		grid = $('#empGrid').data("kendoGrid");
       		$.each(ch, function(i,v){
    			dataItem = grid.dataItem($(v).closest("tr"));
    			checkedIds.push(dataItem.emp_seq);
    		});
       		if (keyVal == '' || keyVal == null) {
       			$('#keyVal').val(checkedIds.join(','));
       		} else if (checkedIds.length > 0) {
       			$('#keyVal').val(keyVal+','+checkedIds.join(','));
       		}       	
       		
       		$('#empGrid').data('kendoGrid').dataSource.read();
       		$('#selectEmp').data('kendoGrid').dataSource.read();
       		$("#headerCheckbox").removeProp("checked");
       	});
		
		$('#arrowLeft').bind('click', function(){	/*왼쪽 향한 화살표 클릭했을 시 함수*/     
			var ch = $('.rightCheck:not(:checked)');
        	$('#keyVal').val('');
       		var checked = [];
       		var checkedIds = new Array();
       		grid = $('#selectEmp').data("kendoGrid");
       		$.each(ch, function(i,v){
    			dataItem = grid.dataItem($(v).closest("tr"));
    			checkedIds.push(dataItem.emp_seq);
    		});
       		$('#keyVal').val(checkedIds.join(','));
        	
       		$('#empGrid').data('kendoGrid').dataSource.read();
       		$('#selectEmp').data('kendoGrid').dataSource.read();
       		$("#headerCheckbox2").removeProp("checked");
       	});

	});
	
	function empGridReload(){
		$('#empGrid').data('kendoGrid').dataSource.read();
	}
	
	
	
	function empGrid(){
		
		var empGrid = $("#empGrid").kendoGrid({
	        dataSource: empDataSource,
			height: 300,
	        sortable: true,	        
	        persistSelection: true,
	        selectable: "multiple",
	        scrollable:{
	            endless: true
	        },
	        columns: [
	        	
	        	{ 
	        	headerTemplate: "<input type='checkbox' id='headerCheckbox' class='k-checkbox header-checkbox'><label class='k-checkbox-label' for='headerCheckbox'></label>",	
	        	template: "<input type='checkbox' id='leftCheck#=emp_seq#' class='k-checkbox leftCheck'/><label for='leftCheck#=emp_seq#' class='k-checkbox-label'></label>"
	        	,width:50,	
	        	},
	        	 {
	            field: "emp_name",
	            title: "이름",
	            
	        }, {
	        	
	            field: "dept_name",
	            title: "부서",
	            
	        }, {
	            field: "position",
	            title: "직급",
	           
	        }, {
	            field: "duty",
	            title: "직책",
	            
	        }]
	        
	    }).data("kendoGrid");
		
        empGrid.table.on("click", ".leftCheck", selectRow);
       
       
        
       
        
        var checkedIds = {};
        function selectRow() {
            var checked = this.checked,
                row = $(this).closest("tr"),
                grid = $("#empGrid").data("kendoGrid"),
                dataItem = grid.dataItem(row);

            checkedIds[dataItem.emp_seq] = checked;
            if (checked) {               
                row.addClass("k-state-selected");

               
            } else {                
                row.removeClass("k-state-selected");
                
            }
        }
		
	}
	 /*집합교육대상 선택 왼쪽그리드*/
	
	
	 /*집합교육대상 선택 오른쪽그리드*/
	var selDataSource = new kendo.data.DataSource({
		serverPaging: false,
		pageSize: 10000,
	    transport: { 
	        read:  {
	            url: _g_contextPath_+'/common/selectEmp',
	            dataType: "json",
	            type: 'post'
	        },
	      	parameterMap: function(data, operation) {
	      		data.empSeq = $('#keyVal').val();
	        	
	     	return data;
	     	}
	    },
	    schema: {	  	
	      data: function(response) {
	        return response.list;
	      },	      
		     
	    }
	});


	$(function(){
		
		selGrid();
		

	});
	
	function selGridReload(){
		$('#selectEmp').data('kendoGrid').dataSource.read();
	}
	
	function selGrid(){
		
		var selGrid = $("#selectEmp").kendoGrid({
	        dataSource: selDataSource,
	        height: 300,
	        
	        sortable: true,	        
	        persistSelection: true,
	        selectable: "multiple",
	        scrollable:{
	            endless: true
	        },
	        columns: [
	        	
	        	{ 
	        	headerTemplate: "<input type='checkbox' id='headerCheckbox2' class='k-checkbox header-checkbox'><label class='k-checkbox-label' for='headerCheckbox2'></label>",
	        	template: "<input type='checkbox' id='rightCheck#=emp_seq#' class='k-checkbox rightCheck'/><label for='rightCheck#=emp_seq#' class='k-checkbox-label'></label>"
	        	,width:50,	
	        	}, 
	        	 {
	            field: "emp_name",
	            title: "이름",
	            
	        }, {
	        	
	            field: "dept_name",
	            title: "부서",
	            
	        }, {
	            field: "position",
	            title: "직급",
	           
	        }, {
	            field: "duty",
	            title: "직책",
	            
	        }]
	        
	    }).data("kendoGrid");
		
        selGrid.table.on("click", ".rightCheck", selectRow2);

        
        var checkedIds = {};

        function selectRow2() {
        	
            var checked = this.checked,
                row = $(this).closest("tr"),
                selGrid = $("#selectEmp").data("kendoGrid"),
                dataItem = selGrid.dataItem(row);

            checkedIds[dataItem.emp_seq] = checked;

            if (checked) {
                row.addClass("k-state-selected");

            } else {
                row.removeClass("k-state-selected");
               
            }
        }
		
	}
	/*집합교육대상 선택 오른쪽그리드*/
	
});   


/* 날짜선택시 조건 처리 함수 */
function fn_dateCheck() {				
	debugger
	
	var startDate = $('#education_start_date').val();
	var endDate = $('#education_end_date').val();
	 //-을 구분자로 연,월,일로 잘라내어 배열로 반환
     
	var startArray = startDate.split('-');
	var endArray = endDate.split('-');
	//배열에 담겨있는 연,월,일을 사용해서 Date 객체 생성
	         
	var start_date = new Date(startArray[0], Number(startArray[1])-1, startArray[2]);
	var end_date = new Date(endArray[0], Number(endArray[1])-1, endArray[2]);
	//날짜를 숫자형태의 날짜 정보로 변환하여 비교한다.	
	
	if(startDate == ''){
		// 선택한 날짜가 오늘 날짜 이전일 때 처리
		var key = 'sNull';		
		fn_dateReset(key);
	} else if (start_date.getTime() > end_date.getTime()) {
		var key = 'eNull';
		
		fn_dateReset(key);
	}
	
}


/* 신청일 초기화 */
function fn_dateReset(e) {
	
	if (e == 'sNull' && $('#education_end_date').val() != '') {
		$('#education_end_date').val('');
		alert('교육시작일을 선택해주세요.')
	} else if (e == 'eNull') {
		$('#education_end_date').val('');
		alert('시작일 이후날짜를 선택해주세요.');
	}
	
}

function fn_groupEduReg() {
	debugger
	if ($('#education_name').val() != null && $('#education_name').val() != '' 
		&& $('#education_hour').val() != null && $('#education_hour').val() != '' 
		&& $('#education_start_date').val() != null && $('#education_start_date').val() != '' 
		&& $('#education_end_date').val() != null && $('#education_end_date').val() != ''
		&& $('#education_start_time').val() != null && $('#education_start_time').val() != '' 
		&& $('#education_end_time').val() != null && $('#education_end_time').val() != ''
	) 
	{
		var data = {
				enforcement_dept_name : $('#enforcement_dept_name').val(),
				manager_emp_seq : $('#manager_emp_seq').data('kendoComboBox').value(),
				education_type_code_id : $('#education_type_code_id').val(),
				education_type : $('#education_type').val(),
				education_name : $('#education_name').val(),
				education_hour : $('#education_hour').val(),
				required_yn : $('#required_yn').is(':checked') ? 'Y' : 'N',
				education_start_date : $('#education_start_date').val(),
				education_end_date : $('#education_end_date').val(),
				education_start_time : $('#education_start_time').val().replace(/[^0-9]/g,''),
				education_end_time : $('#education_end_time').val().replace(/[^0-9]/g,''),
				education_place : $('#education_place').val(),			
				subKey : $('#keyVal').val(),
		}
		if ($('#required_yn').is(':checked')) {
			var object= $("#required_dn").data('kendoComboBox').dataItem();
			console.log(object);
			data.required_code_id = object.code;
			data.required_code = object.code_kr;
		}
		console.log(data);
		$.ajax({
			url: _g_contextPath_+"/educationManagement/groupEduReg",
			dataType : 'text',
			data : data,
			type : 'POST',
			async: false,
			success: function(result){
				alert('저장하였습니다');
				location.reload();
			}
		});
	} else {
		
		alert('필수항목을 입력하세요');
		
	}
	
	
	
}