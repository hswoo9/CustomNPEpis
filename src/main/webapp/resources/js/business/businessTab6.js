var tab6GridDataSource = new kendo.data.DataSource({
	serverPaging: true,
	pageSize: 10,
    transport: { 
        read:  {
            url: '/kpc/business/tab6Grid',
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


function tab6Grid(){
	$('#tab6Grid').kendoGrid({
		dataSource: tab6GridDataSource,
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
			},{
				field: "KAB_CD",
				title: "등록일시",
				width:'35%',
			},{
				title: "등록자",
			}]
	}).data("kendoGrid");
	
}

