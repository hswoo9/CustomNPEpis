/**심사원 검색*/

var vacation1, vacation2, ptype, teamId, teamCd;
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
      		data.ISP_PLN_ID = $('#ispPlnId').val(); 

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
	teamCd = teamCd;
	teamId = teamId;
	
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
	var teamLeader = $('#teamLeader').val();
	var teamMember = $('#teamMember').val();
	var tem = row.EMP_NAME;

	if(row.VACT == 'Y'){
		tem = row.EMP_NAME + '(휴가)';
	}else{
		if(row.INS_PRSN_ID == teamLeader){
			tem = row.EMP_NAME + '(팀장)';
		}else if(row.INS_PRSN_ID == teamMember){
			tem = row.EMP_NAME + '(팀원)';
		}
	}
	return tem; 
}


var screeningSearchHtml = function(row){
	var teamLeader = $('#teamLeader').val();
	var teamMember = $('#teamMember').val();
	var tem = false;
	
	if(row.VACT == 'N'){
		if(row.INS_PRSN_ID == teamLeader || row.INS_PRSN_ID == teamMember){
			tem = true
		}
		
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

	var data = {
		INS_PRSN_ID : rowData.INS_PRSN_ID, //심사원id
		TM_MGR_YN : ptype == 'a' ? 'Y' : 'N', //심장여부 'a'팀장
		RQST_RVW_ID : $('#RQST_RVW_ID').val() //신청검토서 번호
	}
	
	$.ajax({
		url: "/kpc/requestAdmin/stRqstTmSave",
		data : data,
		type : 'POST',
		success: function(result){
			tab3Grid();
			$('#screeningSearchPopup').data("kendoWindow").close();
		}
	});
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