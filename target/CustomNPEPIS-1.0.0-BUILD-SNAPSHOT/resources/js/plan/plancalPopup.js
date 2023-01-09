$(function(){
	
	$('#planModCalPopup').kendoWindow({
	    width: "998px",
	    title: '세부일정 등록',
	    visible: false,
	    modal : true,
	    actions: [
	        "Close"
	    ],
	}).data("kendoWindow").center();
	
	$('#planCalendar').fullCalendar({
		header: {
			left: 'prev,next today',
			center: 'title',
			right: ''
		},
		lang : "ko",
		eventClick: function(calEvent, jsEvent, view) {
			var caseNumber = Math.floor((Math.abs(jsEvent.offsetX + jsEvent.currentTarget.offsetLeft) / $(this).parent().parent().width() * 100) / (100 / 7));
			var table = $(this).parent().parent().parent().parent().children();
			
			$(table).each(function(){
			    if($(this).is('thead')){
			        var tds = $(this).children().children();
			        var dateClicked = $(tds[caseNumber]).attr("data-date");
			        $('#clickDay').text(' ('+dateClicked+')');
			        addSchedule(dateClicked, calEvent.key);
			    }
			});
		},
		eventMouseover: function(event, jsEvent, view) {
			$(this).css('cursor', 'pointer');
		},
		events: function(start, end, timezone, callback) {
	        $.ajax({
	            url: '/kpc/plan/planCalendarData',
	            dataType: 'json',
	            type : 'POST',
	            data: {
	                start: start.format('YYYY-MM-DD'),
	                end: end.format('YYYY-MM-DD'),
	                INS_PRSN_ID : INS_PRSN_ID,
	            },
	            success: function(doc) {
	                var events = new Array();
	            	$.each(doc.list, function(i, v){
	            		events.push({
	                        title: v.CMPY_NM + '\n' + v.MTRP_NM +' '+ v.CTY_NM + '\n' + v.ISP_TP,
	                        start: v.ISP_DT,
	                        key: v.ISP_PLN_TM_ID
	                    });
	            		
	            	});
	            	
	                callback(events);
	            }
	        });
	    }
	});
	
});

var ISP_PLN_TM_ID;
var ISP_DT;
var INS_PRSN_ID;
function planModCal(key, key2, day){
	ISP_PLN_TM_ID = key;
	INS_PRSN_ID = key2;
	 $('#clickDay').text(' (' + day + ')');
	$('#planCalendar').fullCalendar('refetchEvents');
	
	$('#sb_cal_list > ul').empty();
	
	addSchedule(day, key);
	
	$('#planModCalPopup').data("kendoWindow").open();
//	var tem = new Date();
//	addSchedule( tem.getFullYear() + '-' + getDateCH2((tem.getMonth()+1)) + '-' + getDateCH2(tem.getDate()));
}

function getDateCH2(data){
	return data.toString().length > 1 ? data : '0'+data;
}

function planCalClose(){
	
	$('#planModCalPopup').data("kendoWindow").close();
}

function addSchedule(date, key){
	ISP_DT = date;
	ISP_PLN_TM_ID = key;
	$('#sb_cal_list > ul').empty();
	var data = {
			ISP_DT : ISP_DT,
			ISP_PLN_TM_ID : ISP_PLN_TM_ID,
			INS_PRSN_ID : INS_PRSN_ID
	}
	
	$.ajax({
		url: "/kpc/plan/scheduleSearch",
		dataType : 'json',
		data : data,
		type : 'POST',
		async : false,
		success: function(result){
			$.each(result.list, function(i, v){
				var fr_h = v.ISP_TM_FR.substr(0,2);
				var fr_m = v.ISP_TM_FR.substr(2,2);
				var to_h = v.ISP_TM_TO.substr(0,2);
				var to_m = v.ISP_TM_TO.substr(2,2);
				var html = '<li>'
							+'<input type="hidden" id="frh" value="'+fr_h+'">'
							+'<input type="hidden" id="frm" value="'+fr_m+'">'
							+'<input type="hidden" id="toh" value="'+to_h+'">'
							+'<input type="hidden" id="tom" value="'+to_m+'">'
							+'<input type="hidden" id="ISP_PLN_TM_DTL_ID" value="'+v.ISP_PLN_TM_DTL_ID+'">'
							+'<input type="hidden" id="ISP_CTNT" value="'+v.ISP_CTNT+'">'
						    +'<span class="ti">'+fr_h+':'+fr_m +' ~ '+to_h+':'+to_m+'</span><span class="txt">'+v.ISP_CTNT+'</span><a href="#n" onclick="scheduleDel('+v.ISP_PLN_TM_DTL_ID+');" class="clo"></a><a href="#n" onclick="scheduleMod(this);" class="modi"></a></li>';
				$('#sb_cal_list > ul').append(html);
			});
		}
	});
	
	
}

function addScheduleTime(){
	$('#addScheduleBtn').show();
	$('#sb_cal_list > ul').append($('#addScheduleTime > li').clone());
}

function addScheduleSaveBtn(){
	var data = {
		ISP_PLN_TM_DTL_ID :  $('#sb_cal_list #ispPlnTmDtlId').val(),
		ISP_DT : ISP_DT,
		ISP_PLN_TM_ID : ISP_PLN_TM_ID,
		ISP_TM_FR : $('#sb_cal_list #fr_h').val()+$('#sb_cal_list #fr_m').val(),
		ISP_TM_TO : $('#sb_cal_list #to_h').val()+$('#sb_cal_list #to_m').val(),
		ISP_CTNT : $('#sb_cal_list #ispCtnt').val(),
	}
	
	$.ajax({
		url: "/kpc/plan/addScheduleSave",
		data : data,
		type : 'POST',
		success: function(result){
			addSchedule(ISP_DT,ISP_PLN_TM_ID);
			$('#sb_cal_list .modi_li').remove();
			$('#addScheduleBtn').hide();
		}
	});
	
}

function addScheduleCancelBtn(){
	addSchedule(ISP_DT);
	$('#sb_cal_list .modi_li').remove();
	$('#addScheduleBtn').hide();
}

function scheduleDel(ispPlnTmDtlId){
	if(!confirm('삭제하겠습니까?'))return 
	
	$.ajax({
		url: "/kpc/plan/scheduleDel",
		data : {ISP_PLN_TM_DTL_ID : ispPlnTmDtlId},
		type : 'POST',
		success: function(result){
			addSchedule(ISP_DT,ISP_PLN_TM_ID);
		}
	});
	
}

function scheduleMod(e){
	var li = $(e).closest('li');
	var liClone = $('#addScheduleTime > li').clone();
	$(liClone).find('#fr_h').val($(li).find('#frh').val());
	$(liClone).find('#fr_m').val($(li).find('#frm').val());
	$(liClone).find('#to_h').val($(li).find('#toh').val());
	$(liClone).find('#to_m').val($(li).find('#tom').val());
	$(liClone).find('#ispCtnt').val($(li).find('#ISP_CTNT').val());
	$(liClone).find('#ispPlnTmDtlId').val($(li).find('#ISP_PLN_TM_DTL_ID').val());
	$(li).after(liClone).remove();
	$('#addScheduleBtn').show();
}

