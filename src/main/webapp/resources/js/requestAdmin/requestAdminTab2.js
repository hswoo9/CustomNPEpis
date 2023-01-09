 /**부속서*/



function tab2Grid(){
	
	var data = {
			ISP_RQT_ID : key
	};
	
	$.ajax({
		url: "/kpc/requestAdmin/tab2GridList",
		data : data,
		async : false,
		type : 'POST',
		success: function(result){
			setTableAdd(result.list);
		}
	});
	
}

function setTableAdd(data){
	$('#tab2Grid tbody').empty();
	
	$.each(data, function(i, v){
		var table1 = $('#tab2TableAdd1 tr').clone();
		var table2 = $('#tab2TableAdd2 tr').clone();

		$(table1).find('.tab2TableAdd1_td1').text(v.SPEC_CD);
		$(table1).find('#ISP_RQST_ID').val(v.ISP_RQST_ID);
		$(table1).find('#ISP_EXT_ID').val(v.ISP_EXT_ID);
		$(table1).find('#tab2TableAdd1_ISP_ESTMT_ID').val(v.ISP_RQST_ID);

		$(table2).find('.tab2TableAdd2_td1').text(v.SPEC_CD);
		$(table2).find('#ISP_RQST_ID').val(v.ISP_RQST_ID);
		$(table2).find('#ISP_EXT_ID').val(v.ISP_EXT_ID);

		if(v.EXT_UPLD_FILE != null){
			var kind = v.EXT_UPLD_FILE.substr(v.EXT_UPLD_FILE.lastIndexOf('.'), v.EXT_UPLD_FILE.length);
			$(table2).find('#tab2TableAdd2_td2_filePath').val(v.EXT_UPLD_DIR + v.ISP_EXT_ID + kind);
		}

		if(v.EXT_INTL_FILE == null || v.EXT_INTL_FILE == ''){
			$(table1).find('.tab2TableAdd1_td3').text('미완료');
		}else{
			$(table1).find('.tab2TableAdd1_td3').text('완료');
			$(table1).find('#tab2TableAdd1_td2_Btn1').val('수정하기');
			$(table1).find('#tab2TableAdd1_td2_Btn2').attr('disabled', false);
			$(table1).find('#tab2TableAdd1_td4_Btn1').attr('disabled', false);
			
		}
		if(v.EXT_UPLD_FILE == null || v.EXT_UPLD_FILE == ''){
			$(table2).find('#tab2TableAdd2_td2_TXT').text('첨부파일 없음');
		}else{
			$(table2).find('#tab2TableAdd2_td2_TXT').text(v.EXT_UPLD_FILE);
			$(table2).find('#tab2TableAdd2_fileDelBtn').show();
		}
		
		$('#tab2Table1').append(table1);
		$('#tab2Table2').append(table2);

		
	});
	
}

function tab2TableAdd2FileSave(e){
	var formData = new FormData();
    formData.append('uploadFile', $(e)[0].files[0]);
    formData.append('ISP_EXT_ID', $(e).closest('tr').find('#ISP_EXT_ID').val());
    formData.append('ISP_RQST_ID', $(e).closest('tr').find('#ISP_RQST_ID').val());

	$.ajax({
		url: "/kpc/requestAdmin/tab2TableAdd2FileSave",
		data : formData,
		type : 'POST',
		async : false,
		processData : false,
        contentType : false,
		success: function(result){
			tab2Grid();
		}
	});
	
}

//첨부파일 삭제
function tab2TableAdd2_fileDel(e){
	if(confirm('삭제 하겠습니까?')){
		var data = {
				ISP_RQT_ID : key,
				ISP_EXT_ID : $(e).closest('tr').find('#ISP_EXT_ID').val()
		};
		
		$.ajax({
			url: "/kpc/requestAdmin/tab2TableAdd2_fileDel",
			data : data,
			async : false,
			type : 'POST',
			success: function(result){
				tab2Grid();
			}
		});
		
	}
	
}

//부속서 작성하기
function tab2TableAdd1WriteBtn(e){
	var estmtId = $(e).closest('td').find('#tab2TableAdd1_ISP_ESTMT_ID').val();
	var ispRqstId = $(e).closest('td').find('#ISP_RQST_ID').val();
	var ISP_EXT_ID = $(e).closest('td').find('#ISP_EXT_ID').val();
	window.open("/kpc/requestAdmin/tab2TableAdd1Write?key1="+estmtId+"&key2="+ispRqstId+"&key3="+ISP_EXT_ID+"&type=1" ,"tab2TableAdd1Write", "width=750, height=800, resizable=no, scrollbars=no, status=no, top=50, left=150", "newWindow");
}

//부속서 보기
function tab2TableAdd1ViewBtn(e){
	var estmtId = $(e).closest('td').find('#tab2TableAdd1_ISP_ESTMT_ID').val();
	var ispRqstId = $(e).closest('td').find('#ISP_RQST_ID').val();
	var ISP_EXT_ID = $(e).closest('td').find('#ISP_EXT_ID').val();
	window.open("/kpc/requestAdmin/tab2TableAdd1Write?key1="+estmtId+"&key2="+ispRqstId+"&key3="+ISP_EXT_ID+"&type=7" ,"tab2TableAdd1Write", "width=750, height=800, resizable=no, scrollbars=no, status=no, top=50, left=150", "newWindow");
	
}

//부속서 파일업로드 보기
function tab2TableAdd2_td2View(e){
	var ISP_EXT_ID = $(e).closest('td').find('#ISP_EXT_ID').val();
	window.open("/kpc/requestAdmin/tab2TableAdd1Write?key1="+ISP_EXT_ID+"&type=9" ,"tab2TableAdd1Write", "width=750, height=800, resizable=no, scrollbars=no, status=no, top=50, left=150", "newWindow");
}

function tab2TableAdd2FileSearch(e){
	$(e).next().click();
}

function tab2TableAdd1DownLoad(e){
	if(confirm('다운로드 하시겠습니까?')){
		var data = {
				ISP_EXT_ID : $(e).closest('tr').find('#ISP_EXT_ID').val(),
		}
		
		$.ajax({
			url : '/kpc/requestAdmin/tab2TableAdd1DownLoad',
			type : 'GET',
			data : data,
		}).success(function(data) {
			var downWin = window.open('','_self');
			downWin.location.href = '/kpc/requestAdmin/tab2TableAdd1DownLoad?ISP_EXT_ID='+$(e).closest('tr').find('#ISP_EXT_ID').val();
		});
	}
}


