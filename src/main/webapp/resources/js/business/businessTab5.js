var tab5GridDataSource = new kendo.data.DataSource({
	serverPaging: true,
	pageSize: 10,
    transport: { 
        read:  {
            url: '/kpc/business/tab5Grid',
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


function tab5Grid(){
	$('#tab5Grid').kendoGrid({
		dataSource: tab5GridDataSource,
		height: 250,
		sortable: true,
		pageable: {
			refresh: true,
			pageSizes: true,
            buttonCount: 5
		},
		columns: [
        	{
        		field: "SPEC_CD",
				title: "심사규격",
				width:'20%',
			},{
				field: "심사형태",
				title: "심사형태",
				width:'20%',
			},{
				field: "HPE_DT_1",
				title: "심사시작일",
				width:'20%',
			},{
				field: "HPE_DT_2",
				title: "심사종료일",
				width:'20%',
			},{
				field: "TOTAL",
				title: "금액(원)",
				width:'20%',
			},]
	}).data("kendoGrid");
	
}

