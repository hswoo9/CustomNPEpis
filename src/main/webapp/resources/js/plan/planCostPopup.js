$(function(){
	
	$('#planCostPopup').kendoWindow({
	    width: "798px",
	    title: '비용수정',
	    visible: false,
	    modal : true,
	    actions: [
	        "Close"
	    ],
	}).data("kendoWindow").center();
	
	$('#planCostPopup input').on('change', function(){
		setTotalSum();
	});
	
});

function planCostPopupBtn(){
	
	$.ajax({
		url: "/kpc/plan/planCostPopupData",
		dataType : 'json',
		data : {ISP_PLN_ID : ISP_PLN_ID},
		async : false,
		type : 'POST',
		success: function(result){
			planCostPopupSetData(result);
		}
	});
	
	$('#planCostPopup').data("kendoWindow").open();
	
}

function planCostPopupSave(){
	var data = {
		ISP_PLN_ID	 : ISP_PLN_ID,
		ISP_PRC_ID	 : $('#ISP_PRC_ID').val(),
		HT_PRC		 : $('#PCP_HT_PRC').val(),
		DY_PRC		 : $('#PCP_DY_PRC').val(),
		ML_PRC		 : $('#PCP_ML_PRC').val(),
		TRF_PRC		 : $('#PCP_TRF_PRC').val(),
		ISP_PRC		 : $('#PCP_ISP_PRC').val(),
		RQT_PRC		 : $('#PCP_RQT_PRC').val(),
	}

	$.ajax({
		url: "/kpc/plan/planCostPopupSave",
		data : data,
		type : 'POST',
		success: function(result){
			$('#planCostPopup').data("kendoWindow").close();
			if($("#planGrid2Table").data("kendoGrid") != null){
				$("#planGrid2Table").data("kendoGrid").dataSource.read();
			}else{
				$('#PRC_SUM').text($('#TOTAL_SUM').text());
			}
		}
	});
	
}

function planCostPopupCancel(){
	$('#planCostPopup').data("kendoWindow").close();
}



var md, cnt, day;
function planCostPopupSetData(data){
	md = data.MD;
	//TODO 심사비용 디자인에 따라 평균인원 적용, 추후 디자인 변경있으면 인원으로 변경 해야 할듯 YH
	cnt = data.CNT / data.GI_DT;
	day = data.GI_DT;
	
	$('#ISP_PRC_ID').val(data.ISP_PRC_ID);
	
	$('#PCP_CMPY_NM').text(data.CMPY_NM);
	$('#PCP_HPE_DT_1').text(data.HPE_DT_1);
	$('#PCP_TEAM_NM').text(data.TEAMNM);
	
	$('.PCP_MD').text(md);
	$('.PCP_DAY').text(day);
	$('.PCP_CNT').text(cnt);
	
	$('#PCP_RQT_PRC').val(data.RQT_PRC);
	$('#PCP_ISP_PRC').val(data.ISP_PRC);
	$('#PCP_TRF_PRC').val(data.TRF_PRC);
	$('#PCP_ML_PRC').val(data.ML_PRC);
	$('#PCP_DY_PRC').val(data.DY_PRC);
	$('#PCP_HT_PRC').val(data.HT_PRC);
	setTotalSum();
}

function setTotalSum(){
	$('#PCP_SUM_RQT_PRC').text( getNumtoCom($('#PCP_RQT_PRC').val()) );
	$('#PCP_SUM_ISP_PRC').text( getNumtoCom($('#PCP_ISP_PRC').val() * md) );
	$('#PCP_SUM_TRF_PRC').text( getNumtoCom($('#PCP_TRF_PRC').val() * day * cnt) );
	$('#PCP_SUM_ML_PRC').text( getNumtoCom($('#PCP_ML_PRC').val() * day * cnt) );
	$('#PCP_SUM_DY_PRC').text( getNumtoCom($('#PCP_DY_PRC').val() * day * cnt) );
	$('#PCP_SUM_HT_PRC').text( getNumtoCom($('#PCP_HT_PRC').val() * day * cnt) );
	
	var total = 0;
	var vat = 0;
	$.each($('.outturn'),function(i, v){
		total = Number(total)+ getComtoNum($(v).text());
	});
	vat = total*0.1;

	$('#PCP_TOTAL').text(getNumtoCom(total));
	$('#PCP_VAT').text(getNumtoCom(vat));
	$('#TOTAL_SUM').text(getNumtoCom(total+vat));
	
}