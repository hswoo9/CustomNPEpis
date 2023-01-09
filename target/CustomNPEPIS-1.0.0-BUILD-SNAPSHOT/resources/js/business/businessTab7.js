var tab7GridDataSource = new kendo.data.DataSource({
	serverPaging: true,
	pageSize: 10,
    transport: { 
        read:  {
            url: '/kpc/business/tab7Grid',
            dataType: "json",
            type: 'post'
        },
      	parameterMap: function(data, operation) {
      		data.CMPY_MST_ID = $('#CMPY_MST_ID').val();
      		data.CMPY_UQ_ID = $('#CMPY_UQ_ID').val();
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


function tab7Grid(){
	var grid = $('#tab7Grid').kendoGrid({
		dataSource: tab7GridDataSource,
		height: 250,
		sortable: true,
		pageable: {
			refresh: true,
			pageSizes: true,
            buttonCount: 5
		},
		persistSelection: true,
        selectable: "multiple",
		columns: [
			{
				field: "CREATE_DT",
				title: "일시",
				width:'135px',
			},{
				field: "CHG_NM",
				title: "업체 담당자",
				width:'80px',
			},{
				field: "PHN_NM",
				title: "통화자",
				width:'80px',
			},{
				field: "USER_NM",
				title: "등록자",
				width:'80px',
			},{
				field: "TEL_DESC",
				title: "내용",
			}],
		 change: function (e) {
			 tab7GridTrClick(e)
        }
	}).data("kendoGrid");
	
	function tab7GridTrClick(){
		 var rows = grid.select();
		    var record;
		    rows.each(function () {
		        record = grid.dataItem($(this));
		    });
					    
		    tab7TopInputMod(record);
	 }
}

function tab7TopInputMod(row){
	$('#MMO_MST_ID').val(row.MMO_MST_ID);
	$('#tab7_CHG_NM').val(row.CHG_NM);
	$('#tab7_PHN_NM').val(row.PHN_NM);
	$('#tab7_TEL_DESC').val(row.TEL_DESC);
}

function tab7MemoNew(){
	$('#tab7TopInput input').val('');
}

function tab7MemoSave(){
	
	var data = {
			CMPY_UQ_ID 	: $('#CMPY_UQ_ID').val(),
			CHG_NM 		: $('#tab7_CHG_NM').val(),
			PHN_NM 		: $('#tab7_PHN_NM').val(),
			TEL_DESC 	: $('#tab7_TEL_DESC').val(),
			MMO_MST_ID 	: $('#MMO_MST_ID').val()
	}
	
	$.ajax({
		url: "/kpc/business/tab7MemoSave",
		data : data,
		async : false,
		type : 'POST',
		success: function(result){
			$('#MMO_MST_ID').val(result.MMO_MST_ID);
			$('#tab7Grid').data('kendoGrid').dataSource.read();
			tab7MemoNew();
		}
	});
	
}
