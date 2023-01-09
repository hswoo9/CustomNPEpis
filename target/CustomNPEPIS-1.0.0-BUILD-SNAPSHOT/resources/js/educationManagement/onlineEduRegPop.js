

$(function(){
	$('#eduCostInput').on('keyup', function(){
		this.value=this.value.replace(/[^0-9,]/g,'');	// 숫자만 입력가능 함수
		var eduCost = ($('#eduCostInput').val()).replace(/,/gi, "");
		$('#education_cost').val(eduCost);
		if ($('#education_cost').val() > Math.floor($('#restFundVal').val())) {
			alert('잔여교육비가 부족합니다.');
			$('#eduCostInput').val('');
			$('#education_cost').val('');
		} else {
			
		}
	});
	
	
	$('#fn_privateEduReg').on('click', function(){	
			
		var queryString = $("form[name=onlineData]").serialize();
		console.log(queryString);
			$.ajax({
			url : _g_contextPath_+"/educationManagement/onlineEduUpdate",
	
			data : queryString,
			dataType : 'json',
			type : 'post',
            error: function(xhr, status, error){
                alert(error);
            },
            success : function(json){
                location.reload();
            },
		});
			
	})

	
	
	$('#completeStatetYn').on('change', function() {
		if ($(this).is(':checked')) {
			$('#complete_state_code_id').val('EC04');
			$('#complete_state').val('수료');
		} else {
			$('#complete_state_code_id').val('EC05');
			$('#complete_state').val('미수료');
			
		}
		
	});
	/*집합교육대상 팝업 관련*/
	var myWindow = $("#popUp");
    
	
	 function onClose() {
		 $('#education_id').val('');
			$('#online_education_type').val('');
			$('#main_category').val('');
			$('#middle_category').val('');
			$('#small_category').val('');
			$('#education_process_code').val('');
			$('#education_name').val('');
			$('#education_hour').val('');
			$('#education_cost').val('');
			$('#eduCostInput').val('');
			$('#education_start_date').val('');
			$('#education_end_date').val('');
			$('#education_person_id').val('');
			$('#education_emp_seq').val('');
			$('#education_dept_name').val('');
			$('#score').val('');
			$('#completeStatetYn').prop('checked', true);
			$('#complete_state_code_id').val('EC04');
			$('#complete_state').val('수료');
			initPage();
	 }
	 
	 myWindow.kendoWindow({
	     width: "1000px",
	    height: "400px",
	     visible: false,
	     modal : true,
	     actions: [
	    	 "Close"
	     ],
	     close: onClose
	 }).data("kendoWindow").center();
	 /*집합교육대상 팝업 관련*/
	
})


