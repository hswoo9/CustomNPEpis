 /**계약서 */ 

function tab4Grid(){
	var data = {
			ISP_RQT_ID : key
	};
	
	$.ajax({
		url: "/kpc/requestAdmin/tab4GridList",
		data : data,
		async : false,
		type : 'POST',
		success: function(result){
			$('#RQST_CTRCT_ID').val(result.RQST_CTRCT_ID);
			$('#tab4_td1').text(result.CTRCT_NO)

			if(result.SND_YN == 'N'){
				$('#tab4Td4').text('미전송');
			}else{
				$('#tab4Td4').text('완료');
			}
			
			if(result.RL_FILE != ''){
				$('#tab4fileY').show();
				$('#tab4fileN').hide();
				$('#tab4fileYTxt').text(result.RL_FILE == null ? '첨부파일 없음' : result.RL_FILE);
			}
			
		}
	});
	
}

$(function(){
	
	$('#requestAdminTab4Popup').kendoWindow({
	    width: "540px",
	    title: '파일업로드',
	    visible: false,
	    modal : true,
	    actions: [
	        "Close"
	    ],
	}).data("kendoWindow").center();
	
	$(".file_input_button").on("click", function(){
		$(this).next().click();
	});
	
	
});

function tab4FileUpload(){
	$('.tab4FileUpload').val('');
	$('#requestAdminTab4Popup').data("kendoWindow").open();
	
}

function tab4PopupSave(){
	
	var formData = new FormData();
    formData.append('uploadFile', $('#tab4FileUpload')[0].files[0]);
    formData.append('ISP_RQT_ID', key);
    formData.append('RQST_CTRCT_ID', $('#RQST_CTRCT_ID').val());

	$.ajax({
		url: "/kpc/requestAdmin/tab4PopupFileSave",
		data : formData,
		type : 'POST',
		async : false,
		processData : false,
        contentType : false,
		success: function(result){
			tab4Grid();
		}
	});
	
	$('#requestAdminTab4Popup').data("kendoWindow").close();
	
}

function tab4PopupCancel(){
	$('#requestAdminTab4Popup').data("kendoWindow").close();
}

function tab4FileDownLoad(){
	var data = {
			RQST_CTRCT_ID : $('#RQST_CTRCT_ID').val()
	}
	
	$.ajax({
		url : '/kpc/requestAdmin/tab4FileDownLoad',
		type : 'GET',
		data : data,
	}).success(function(data) {
		var downWin = window.open('','_self');
		downWin.location.href = '/kpc/requestAdmin/tab4FileDownLoad?RQST_CTRCT_ID='+$('#RQST_CTRCT_ID').val();
	});
	
}

function getFileNm(e){
	var index = $(e).val().lastIndexOf('\\') +1;
	var valLength = $(e).val().length;
	$('#fileID').val($(e).val().substr(index, valLength));
}		

function tab4PopupView(){
	
	window.open('/kpc/requestAdmin/tab4PopupView?key1='+key+'&key2='+$('#RQST_CTRCT_ID').val(),"tab4PopupView", "width=750, height=800, resizable=no, scrollbars=no, status=no, top=50, left=150", "newWindow");
	
}

function tab4MailSendBtn(){
	
	if(confirm('전송하시겠습니까?')){
		var data = {
			ISP_RQT_ID : key,
			RQST_CTRCT_ID : $('#RQST_CTRCT_ID').val()
		};
		
		$.ajax({
			url: "/kpc/requestAdmin/tab4MailSend",
			data : data,
			dataType : 'json',
			type : 'POST',
			success: function(result){
				alert(result.data);
				tab4Grid();
			}
		});
		
	}
	
}



