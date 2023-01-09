 /**견적서*/

var tab1GridDataSource = new kendo.data.DataSource({
	serverPaging: true,
	pageSize: 10,
    transport: { 
        read:  {
            url: '/kpc/requestAdmin/estimateSearch',
            dataType: "json",
            type: 'post'
        },
      	parameterMap: function(data, operation) {
      		data.ISP_RQT_ID = $('#ISP_RQT_ID').val();
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


var tab1Grid = function(){
	$(".tab1").show();
	
	$('#tab1Grid').kendoGrid({
        dataSource: tab1GridDataSource,
        height: 250,
        sortable: true,
        pageable: {
            refresh: true,
            pageSizes: false,
        },
        columns: [ 
    	{
            title: "작성일",
            field : "CREATE_DT"
        },{
            title: "금액(원)",
            template : totalFrm,
        },{
            title: "견적서",
            template : tab1Frm,
        },{
        	title: "견적서전송",
        	template : tab2Frm,
        },{
        	title: "전송여부",
        	template : tab3Frm,
        }]
    }).data("kendoGrid");
	
}

function totalFrm(row){
	return '<a class="text_blue" onclick="getTab1TotalMod(this);">'+row.TOTAL+'</a>';
}

function tab1Frm(row){
	return '<input type="button" onclick="tab1View(this);" value="견적서보기" />';
}

function tab2Frm(row){
	if(row.ESTMT_SND_YN == 'N'){
		return '<input type="button" onclick="tab1Submit(this);" value="전송하기" />';
	}else{
		return '<input type="button" onclick="tab1Submit(this);" value="재전송하기" />';
	}
}

function tab3Frm(row){
	return row.ESTMT_SND_YN == 'N' ? '미전송' : '전송';
}

$(function(){
	
	$('#estimateWritePopup').kendoWindow({
	    width: "548px",
	    title: '견적서',
	    visible: false,
	    modal : true,
	    actions: [
	        "Close"
	    ],
	}).data("kendoWindow").center();
	
	setTotalCnt();
	
});


function tab1View(e){
	var row = $("#tab1Grid").data("kendoGrid").dataItem($(e).closest("tr"));
	
	window.open("/kpc/requestAdmin/tab1View?key1="+row.ISP_RQT_ID +"&key2="+row.ISP_ESTMT_ID ,"tab1View", "width=750, height=800, resizable=no, scrollbars=no, status=no, top=50, left=150", "newWindow");
	
}

function estimateSubmit(data){
	
	alert('견적서 전송 : ' + data)
}

function estimateMod(data){
	
	$.ajax({
		url: "/kpc/requestAdmin/estimateMod",
		dataType : 'json',
		data : {data : data},
		async : false,
		type : 'POST',
		success: function(result){
			$.each(result, function(i, v){
				$('#'+i).val(v);
			});
			$('#estimateWritePopup').data("kendoWindow").open();
			eventSum();
		}
	});
	
}

function estimateWrite(){
	estimateWriteClean();
	$('#estimateWritePopup').data("kendoWindow").open();
}

function estimateWriteCancel(){
	$('#estimateWritePopup').data("kendoWindow").close();
}

function estimateWriteSave(){
	var data = {};
	
	$.each($('#estimateWritePopup input'), function(i, v){
		var id = $(v).attr('id');
		data[id] = getComtoNum($('#'+id).val());		
	});
	
	data['ISP_RQT_ID'] = $('#ISP_RQT_ID').val();
	data['ISP_ESTMT_ID'] = $('#ISP_ESTMT_ID').val();
	data['ESTMT_DT'] = $('#ESTMT_DT').val();
	
	$.ajax({
		url: "/kpc/requestAdmin/estimateWritePopupSave",
		data : data,
		type : 'POST',
		success: function(result){
			$('#estimateWritePopup').data("kendoWindow").close();
			$('#tab1_data2').hide();
			tab1Grid();
		}
	});
	
}

function estimateWriteClean(){
	$('#estimateWritePopup table input').val('');
	$('#MD_TOTAL').text('');
	$('#MO_TOTAL').text('');
}

function setTotalCnt(){
	$('.MD_').on('change', function(){
		eventSum();
	});

	$('.MO_').on('change', function(){
		eventSum();
	});
	
}
function eventSum(){
	var md = $('.MD_');
	var mdSum = 0;
	$.each(md, function(i, v){
		mdSum += Number($(v).val());
	});
	$('#MD_TOTAL').text(mdSum);
	
	var mo = $('.MO_');
	var moSum = 0;
	$.each(mo, function(i, v){
		moSum += getComtoNum($(v).val());
	});
	$('#MO_TOTAL').text(getNumtoCom(moSum*mdSum));
}

function tab1Submit(e){
	var row = $("#tab1Grid").data("kendoGrid").dataItem($(e).closest("tr"));

	var data = {
		ISP_RQT_ID : row.ISP_RQT_ID,
		ISP_ESTMT_ID : row.ISP_ESTMT_ID,
	}

	$.ajax({
		url: "/kpc/requestAdmin/tab1Submit",
		data : data,
		dataType : 'json',
		type : 'POST',
		success: function(result){
			alert(result.txt);
			tab1Grid();
		}
	});
	
}


function getTab1TotalMod(e){
	var row = $("#tab1Grid").data("kendoGrid").dataItem($(e).closest("tr"));
	$('#ISP_ESTMT_ID').val(row.ISP_ESTMT_ID);
	$.ajax({
		url: "/kpc/requestAdmin/getTab1TotalMod",
		dataType : 'json',
		data : { ISP_ESTMT_ID : row.ISP_ESTMT_ID},
		async : false,
		type : 'POST',
		success: function(result){
			$.each(result, function(i, v){
				$('#estimateWritePopup #'+i).val(v);
			});
			eventSum();
		}
	});
	
	$('#estimateWritePopup').data("kendoWindow").open();
	
}
