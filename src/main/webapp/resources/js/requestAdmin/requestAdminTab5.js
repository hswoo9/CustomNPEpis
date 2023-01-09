 /**부속서류 */ 

var tab5GridDataSource = new kendo.data.DataSource({
	serverPaging: true,
	pageSize: 10,
    transport: { 
        read:  {
            url: '/kpc/requestAdmin/tab5GridSearch',
            dataType: "json",
            type: 'post'
        },
      	parameterMap: function(data, operation) {
      		data.ISP_RQT_ID = $('#ISP_RQT_ID').val();
      		data.SELECT_CODE = $('#tab5Select').val();
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

function tab5Grid(){
	
	$('#tab5Grid').kendoGrid({
        dataSource: tab5GridDataSource,
        height: 250,
        sortable: true,
        pageable: {
            refresh: true,
            pageSizes: false,
        },
        columns: [ 
	    { template: "<input type='checkbox' class='checkbox'/>", width: 34 },
    	{
            title: "문서구분",
            template: fileFm
        },{
            title: "등록일시",
            field: "CREATE_DT",
        },{
            title: "등록자",
            field: "USER_NM",
        }]
    }).data("kendoGrid");
	
}

function getFileNm(e){
	var index = $(e).val().lastIndexOf('\\') +1;
	var valLength = $(e).val().length;
	$('#tab5File').val($(e).val().substr(index, valLength));
	
}	

$(function(){
	
	$('#requestAdminTab5Popup').kendoWindow({
	    width: "540px",
	    title: '부속서류 등록하기',
	    visible: false,
	    modal : true,
	    actions: [
	        "Close"
	    ],
	}).data("kendoWindow").center();
	
});

function tab5FileUpload(){
	$('.tab5FileUpload').val('');
	$('#requestAdminTab5Popup').data("kendoWindow").open();
}

function tab5PopupSave(){
	
	var formData = new FormData();
    formData.append('uploadFile', $('#tab5FileUpload')[0].files[0]);
    formData.append('ISP_RQT_ID', key);
    formData.append('CMPY_UQ_ID', $('#CMPY_UQ_ID').val());
    formData.append('SPEC_CD', $('#requestAdminTab5PopupSelect').val());

	$.ajax({
		url: "/kpc/requestAdmin/tab5PopupFileSave",
		data : formData,
		type : 'POST',
		async : false,
		processData : false,
        contentType : false,
		success: function(result){
			tab5Grid();
		}
	});
	
	$('#requestAdminTab5Popup').data("kendoWindow").close();
	
}

function tab5PopupCancel(){
	$('#requestAdminTab5Popup').data("kendoWindow").close();
}

function tab5Search(){
	$('#tab5Grid').data('kendoGrid').dataSource.read();
}

var fileFm = function(row){

	return '<span class="mr20">'+row.SPEC_CD+
		   ' <img src="../Images/ico/btn_download01.png" alt="" onclick="tab5FileDownLoad(this);"></a>'+
		   '</span>';
}

function tab5FileDownLoad(e){
	var row = $('#tab5Grid').data("kendoGrid").dataItem($(e).closest("tr"));

	$.ajax({
		url : '/kpc/requestAdmin/tab5FileDownLoad',
		type : 'GET',
		data : {'RLTN_DOC_ID' : row.RLTN_DOC_ID}
	}).success(function(data) {
		var downWin = window.open('','_self');
		downWin.location.href = '/kpc/requestAdmin/tab5FileDownLoad?RLTN_DOC_ID='+row.RLTN_DOC_ID;
	});
	
}

function tab5FileDel(){
	var chk = $('#tab5Grid tbody input[type=checkbox]:checked');
	
	var rqstDocId = new Array();
	var rltnDocId = new Array();
	if(chk.size() == 0){
		return false;
	}
	$.each(chk, function(i, v){
		rqstDocId.push($('#tab5Grid').data("kendoGrid").dataItem($(v).closest("tr")).RQST_DOC_ID);
		rltnDocId.push($('#tab5Grid').data("kendoGrid").dataItem($(v).closest("tr")).RLTN_DOC_ID);
	});
		
	$.ajax({
		url: "/kpc/requestAdmin/tab5FileDel",
		data : {RQST_DOC_ID : rqstDocId.join(), RLTN_DOC_ID : rltnDocId.join()},
		type : 'POST',
		success: function(result){
			$('#tab5Grid').data('kendoGrid').dataSource.read();
		}
	});
	
	
	
}

