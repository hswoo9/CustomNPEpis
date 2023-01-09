var tab2GridDataSource = new kendo.data.DataSource({
	serverPaging: true,
	pageSize: 10,
    transport: { 
        read:  {
            url: '/kpc/business/tab2Grid',
            dataType: "json",
            type: 'post'
        },
      	parameterMap: function(data, operation) {
      		data.CMPY_MST_ID = $('#CMPY_MST_ID').val();
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

function tab2Grid(){
	$('#tab2Grid').kendoGrid({
		dataSource: tab2GridDataSource,
		height: 250,
		sortable: true,
		pageable: {
			refresh: true,
			pageSizes: true,
            buttonCount: 5
		},
		columns: [
			{
				field: "CREATE_DT",
				title: "변경일",
				width:'20%',
			},{
				field: "USER_NM",
				title: "변경자",
				width:'15%',
			},{
				field: "CHG_TTL",
				title: "제목",
				width:'20%',
			},{
				field: "CHG_DESC",
				title: "내용",
			}]
	}).data("kendoGrid");
	
}