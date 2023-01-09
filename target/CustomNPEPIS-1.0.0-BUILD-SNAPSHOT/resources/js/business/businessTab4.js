var tab4GridDataSource = new kendo.data.DataSource({
	serverPaging: true,
	pageSize: 10,
    transport: { 
        read:  {
            url: '/kpc/business/tab4Grid',
            dataType: "json",
            type: 'post'
        },
      	parameterMap: function(data, operation) {
      		data.CMPY_MST_ID = $('#CMPY_MST_ID').val();
      		data.CMPY_UQ_ID = $('#CMPY_UQ_ID').val();
      		data.SELECT_CODE = $('#tab4Select').val();
      		data.CHECK_CODE = $('input[name="tab4Chk"]:checked').val();
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


function tab4Grid(){
	$('#tab4Grid').kendoGrid({
		dataSource: tab4GridDataSource,
		height: 250,
		sortable: true,
		pageable: {
			refresh: true,
			pageSizes: true,
            buttonCount: 5
		},
		columns: [
			{	template: "<input type='checkbox' class='checkbox'/>",
	        	width: 34,
        	},{
				title: "문서구분",
				width:'40%',
				template: fileFm
			},{
				field: "CREATE_DT",
				title: "등록일시",
				width:'35%',
			},{
				field: "USER_NM",
				title: "등록자",
			}]
	}).data("kendoGrid");
	
}

var fileFm = function(row){

	return '<span class="mr20">'+row.SPEC_CD+
		   ' <img src="../Images/ico/btn_download01.png" alt="" onclick="tab5FileDownLoad(this);"></a>'+
		   '</span>';
}

function tab5FileDownLoad(e){
	var row = $('#tab4Grid').data("kendoGrid").dataItem($(e).closest("tr"));

	$.ajax({
		url : '/kpc/requestAdmin/tab5FileDownLoad',
		type : 'GET',
		data : {'RLTN_DOC_ID' : row.RLTN_DOC_ID}
	}).success(function(data) {
		var downWin = window.open('','_self');
		downWin.location.href = '/kpc/requestAdmin/tab5FileDownLoad?RLTN_DOC_ID='+row.RLTN_DOC_ID;
	});
	
}

function tab4Search(){
	$('#tab4Grid').data('kendoGrid').dataSource.read();
}
