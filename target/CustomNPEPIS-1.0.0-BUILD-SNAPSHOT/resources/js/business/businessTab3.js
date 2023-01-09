var tab3GridDataSource = new kendo.data.DataSource({
	serverPaging: true,
	pageSize: 10,
    transport: { 
        read:  {
            url: '/kpc/business/tab3Grid',
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

$(function(){
	
	$('#tab3UserPopup').kendoWindow({
	    width: "440px",
	    title: '배정심사원 상세보기',
	    visible: false,
	    modal : true,
	    actions: [
	        "Close"
	    ],
	}).data("kendoWindow").center();
	
});

function tab3Grid(){
	$('#tab3Grid').kendoGrid({
		dataSource: tab3GridDataSource,
		height: 250,
		sortable: true,
		pageable: {
			refresh: true,
			pageSizes: true,
            buttonCount: 5
		},
		columns: [
			{
				template : GetStIspRpt,
				title: "심사규격",
				width:'15%',
			},{
				field: "ISP_TP",
				title: "심사형태",
				width:'15%',
			},{
				field : "HPE_DT_1",
				title: "심사시작일",
				width:'15%',
			},{
				field: "HPE_DT_2",
				title: "심사종료일",
				width:'15%',
			},{
				template : sTxt,
				title: "상태",
				width:'15%',
			},{
				field: "KAB_CD",
				title: "인증심사코드",
				width:'15%',
			},{
				template : userClick,
				title: "배정심사원",
			}]
	}).data("kendoGrid");
	
}

var GetStIspRpt = function(row){
	return '<a onclick="tab3GetStIspRpt(\''+row.ISP_RPT_ID+'\');">'+row.SPEC_CD+'</a>'
}

var userClick = function(row){
	return '<a onclick="tab3UserClick(\''+row.ISP_PLN_ID+'\');">'+row.USER_NM+'</a>'
}

function tab3UserClick(id){
	$('#tab3UserPopupTable tbody').empty();
	
	var data = {
		ISP_PLN_ID : id	
	}
	
	$.ajax({
		url: '/kpc/business/tab3UserPopup',
		dataType : 'json',
		data : data,
		async : false,
		type : 'POST',
		success: function(result){
			$.each(result.list, function(i, v){
				var html = '<tr>'+
							'<td>'+v.EMP_NAME+'</td>'+
							'<td>'+v.TM_MGR_YN+'</td>'+
							'<td>'+v.ISP_MD+'</td>'+
							'</tr>';
				$('#tab3UserPopupTable tbody').append(html);
			});
			$('#tab3UserPopup').data("kendoWindow").open();
		}
	});
	
}

function tab3GetStIspRpt(id){
	alert('심사규격 ' + id);
//	TODO 심사보고화면 나오면 url 적용하기
//	location.href='';
	
}

function sTxt(row){
	return row.S_TXT.split('|')[0];
}

function tab3UserPopupClose(){
	
	$('#tab3UserPopup').data("kendoWindow").close();
} 