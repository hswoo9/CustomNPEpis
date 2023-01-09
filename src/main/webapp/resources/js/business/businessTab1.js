var tab1GridDataSource = new kendo.data.DataSource({
	serverPaging: true,
	pageSize: 10,
    transport: { 
        read:  {
            url: '/kpc/business/tab1Grid',
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

function tab1Grid(){
	$('#tab1Grid').kendoGrid({
		dataSource: tab1GridDataSource,
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
				title: "인증규격",
				width:'20%',
			},{
				field: "KAB_CD",
				title: "인증코드",
				width:'20%',
			},{
				template : stFm,
				title: "상태",
				width:'10%',
			},{
				template : giFm,
				field: "CHG_DESC",
				title: "유효기간",
			}]
	}).data("kendoGrid");
	
}

var stFm = function(row){
	return row.S_TXT.split('|')[0];
}

var giFm = function(row){
	var tem = row.S_TXT.split('|');

	return tem[1] == '' && tem[2] == '' ? '' : tem[2] == '' ? tem[1] : tem[1] + ' ~ ' + tem[2];
}