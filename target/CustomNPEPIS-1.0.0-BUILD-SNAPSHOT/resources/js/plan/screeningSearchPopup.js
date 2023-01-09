/**심사원 검색*/

var vacation1, vacation2, ptype, teamId1, teamCd1;
var screeningSearchPopupGridDataSource = new kendo.data.DataSource({
	serverPaging: true,
	pageSize: 10,
    transport: { 
        read:  {
            url: '/kpc/common/screeningSearchPopupGridSearch',
            dataType: "json",
            type: 'post'
        },
      	parameterMap: function(data, operation) {
      		data.vacation1 = vacation1;
      		data.vacation2 = vacation2;
      		data.ISP_RQT_ID = $('#ISP_RQT_ID').val(); 
      		
      		data.SPEC_CD = $('#screeningSelect1').val(); 
      		data.ATHR_CD = $('#screeningSelect2').val(); 
      		data.PRSN_DN = $('#screeningSelect3').val(); 
      		data.EMP_NAME = $('#screeningWord1').val(); 
      		data.DEPT_NAME = $('#screeningWord2').val(); 
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
	
	$('#screeningSearchPopup').kendoWindow({
	    width: "1000px",
	    title: '심사원 검색',
	    visible: false,
	    modal : true,
	    actions: [
	        "Close"
	    ],
	}).data("kendoWindow").center();

});

function screeningSearchPopup(type, vac1, vac2, teamId, teamCd){
	vacation1 = vac1;
	vacation2 = vac2;
	ptype = type;
	teamCd1 = teamCd;
	teamId1 = teamId;
	
	$('#screeningSearchPopup').data("kendoWindow").open();
	
	if($("#screeningSearchPopupGrid").data("kendoGrid") == null){
		screeningSearchPopupGrid();
	}else{
		$("#screeningSearchPopupGrid").data("kendoGrid").destroy();
		screeningSearchPopupGrid();
	}
	
	
	
}

function screeningSearchPopupGrid(){
	
	$('#screeningSearchPopupGrid').kendoGrid({
        dataSource: screeningSearchPopupGridDataSource,
        height: 350,
        sortable: true,
        pageable: {
            refresh: true,
            pageSizes: true,
            buttonCount: 5
        },
        dataBound: function () {
            dataView = this.dataSource.view();
            for(var i = 0; i < dataView.length; i++) {
            	var uid = dataView[i].uid;
            	$("#screeningSearchPopupGrid tbody").find("tr[data-uid=" + uid + "]").removeClass('k-alt');
            	if(dataView[i].CL == 'B'){
            		$("#screeningSearchPopupGrid tbody").find("tr[data-uid=" + uid + "]").css('background-color', 'beige');
            	}
            }
        },
        columns: [
        {
        	template : vacUser,
        	title: "이름",
        }, {
            field: "DEPT_NAME",
            title: "부서",
        },{
            field: "DP_NAME",
            title: "직위",
        },{
        	field: "SPEC_CD",
        	title: "심사규격",
        	width: 450,
        },{
        	field: "PRSN_MD",
        	title: "MD",
        },{
            title: "선택",
            template: screeningSearchHtml
        }]
    }).data("kendoGrid");
	
}

var vacUser = function(row){

	var sim = $(teamId1).closest('tbody').find('.getData');
	
	var tem = row.EMP_NAME;

	if(row.VACT == 'Y'){
		tem = row.EMP_NAME + '(휴가)';
	}else{
		$.each(sim, function(i, v){
			
			if(row.INS_PRSN_ID == $(v).find('#INS_PRSN_ID').val()){
				tem = $(v).find('#TM_MGR_YN').val() == 'Y' ? row.EMP_NAME + '(팀장)' : row.EMP_NAME + '(팀원)'; 
			}
		});
	}
	return tem; 
}


var screeningSearchHtml = function(row){
	var sim = $(teamId1).closest('tbody').find('.getData');
	var tem = false;
	
	if(row.VACT == 'N'){
		$.each(sim, function(i, v){
			
			if(row.INS_PRSN_ID == $(v).find('#INS_PRSN_ID').val()){
				tem = true;
			}
		});
		
		if(tem){
			return '<div class="controll_btn cen p0"><button type="button">선택</button></div>';
		}else{
			return '<div class="controll_btn cen p0"><button type="button" onclick="screeningSearchChoice(this);">선택</button></div>';
		}
		
	}else{
		return '<div class="controll_btn cen p0"><button type="button">선택</button></div>';
	}
}

function screeningSearchPopupCancel(){
	$('#screeningSearchPopup').data("kendoWindow").close();
	
}

function screeningSearchChoice(e){
	var rowData = $('#screeningSearchPopupGrid').data("kendoGrid").dataItem($(e).closest("tr"));

	$(teamId1).closest('tr').find('.stxt').text(rowData.EMP_NAME);
	$(teamId1).closest('tr').find('#INS_PRSN_ID').val(rowData.INS_PRSN_ID);

	if($(teamId1).closest('tr').next().attr('id') == 'simAdd'){
		addSim();
	}
	
	$('#screeningSearchPopup').data("kendoWindow").close();
	
}

function screeningSearchBtn(){
	$('#screeningSearchPopupGrid').data('kendoGrid').dataSource.read();
}

function screeningSelect1(e){
	var data = {
		key : $(e).val(),
	}
	var ts = getScreeningSelectSubData(data);
	var id = $(e).closest('dl').find('#screeningSelect2');
	$(id).empty();
	$(id).append('<option value="all">전체</option>')
	$.each(ts, function(i, v){
		$(id).append('<option value="'+v.CODE_CD+'">'+v.CODE_CD+ ' ('+v.CODE_NM+')</option>');
	})
}

function getScreeningSelectSubData(data){
	var tem;
	$.ajax({
		url: "/kpc/plan/select1Sub",
		dataType : 'json',
		data : data,
		async : false,
		type : 'POST',
		success: function(result){
			tem = result.list;
		}
	});
	
	return tem;
}