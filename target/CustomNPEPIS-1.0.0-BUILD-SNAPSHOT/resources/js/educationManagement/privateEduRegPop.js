

function getFileNm(e) {
	
	var index = $(e).val().lastIndexOf('\\') + 1;
	var valLength = $(e).val().length;
	var row = $(e).closest('tr');
	var fileNm = $(e).val().substr(index, valLength);
	row.find('#fileID1').val(fileNm);
	row.find('#fileText').text(fileNm).css({'color':'#0033FF','margin-left':'5px'});
}

$(function(){
	
	$('#fn_privateEduReg').on('click', function(){
		if ($('#education_name').val() != null && $('#education_name').val() != '' 
			&& $('#education_agency').val() != null && $('#education_agency').val() != '' 
			&& $('#education_hour').val() != null && $('#education_hour').val() != '' 
			&& $('#education_start_date').val() != null && $('#education_start_date').val() != '' 
			&& $('#education_end_date').val() != null && $('#education_end_date').val() != ''
			&& $('#fileTr #fileID1').val() != null && $('#fileTr #fileID1').val() != ''
			&& $('#fileTr2 #fileID1').val() != null && $('#fileTr2 #fileID1').val() != ''	) 
		{
			
			if ( $('#education_cost').val() > 0 ) {
				$('#education_cost_support_yn').val('Y');
			} else {
				$('#education_cost_support_yn').val('N');
			}
			if($('#required_yn').prop("checked")){
				$('#required_code_id').val($('#required_dn').val());
				$('#required_code').val($('#required_dn').data('kendoComboBox').text());
			}
			var formData = new FormData($("#fileForm")[0]);
			
		$("#fileForm").ajaxSubmit({
			url : _g_contextPath_+"/educationManagement/privateEduReg",
	
			data : {},
			type : 'post',
			processData : false,
			async: false,
			contentType : false,
			success : function(result) {
				alert("저장 되었습니다.");
				location.reload();
			},
			error : function(error) {
	
				console.log(error);
				console.log(error.status);
			}
		});
		} else {
			alert('필수항목을 작성해주세요');
		}
					
			
			
	})

	$(".file_input_button").on("click",function(){
		$(this).next().click();
	});
	
	/*$('#educationCostYn').on('change', function() {
		if ($(this).is(':checked')) {
			$('#education_cost_support_yn').val('Y');
			$('#eduCostInput').attr('disabled', false);
		} else {
			$('#education_cost_support_yn').val('N');
			$('#eduCostInput').attr('disabled', true);
			
		}
		
	});*/
	/*집합교육대상 팝업 관련*/
	var myWindow = $("#popUp");
    undo = $("#add");
    
	var endEdu = true;
	 undo.click(function() {
		 if(endEdu == false){
			 alert("교육이수 신청 기간이 종료되었습니다.");
		 }else{
			 $('#education_name').val('');
			 $('#education_id').val('');
			    $('#education_start_date').val('');
			    $('#education_end_date').val('');
			    $('#education_agency').val('');
				$('#education_hour').val('');
				$('#eduCostInput').val('');
				$('#education_cost').val('');
				$('#education_cost_support_yn').prop("checked", false);
				$('#remark').val('');
				$('#fileTr #fileID1').val('');
				$('#fileTr #fileID').val('');
				$('#fileTr2 #fileID1').val('');
				$('#fileTr2 #fileID').val('');
				$('#eduCostInput').attr('disabled', false);
				var testLength = $('#test').length;
				for (var i = 0 ; i < testLength ; i++) {
					$('#test').eq(i).empty();
				}
				$('#fileTr2').nextAll().empty();
		     myWindow.data("kendoWindow").open();
		    
		     undo.fadeOut();
		 }
		
	     
	 });
	
	 function onClose() {
	     undo.fadeIn();
	     $('#headerCheckbox').attr('checked', false);
	     gridReload();
	    /*$('#education_name').val('');
	    $('#education_start_date').val('');
	    $('#education_end_date').val('');
		$('#education_hour').val('');
		$('#education_cost').val('');
		$('#education_cost_support_yn').prop("checked", false);
		$('#remark').val('');*/
		
	 }
	 $("#cancle").click(function(){
		 myWindow.data("kendoWindow").close();
	 });
	 myWindow.kendoWindow({
	     width: "1000px",
	     visible: false,
	     modal : true,
	     actions: [
	    	 "Close"
	     ],
	     close: onClose
	 }).data("kendoWindow").center();
	 /*집합교육대상 팝업 관련*/
	
})



/* 날짜선택시 조건 처리 함수 */
/*function fn_dateCheck() {				
	
	
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
	
}*/

/* 신청일 초기화 */
/*function fn_dateReset(e) {
	
	if (e == 'sNull' && $('#education_end_date').val() != '') {
		$('#education_end_date').val('');
		alert('교육시작일을 선택해주세요.')
	} else if (e == 'eNull') {
		$('#education_end_date').val('');
		alert('시작일 이후날짜를 선택해주세요.');
	}
	
}*/

