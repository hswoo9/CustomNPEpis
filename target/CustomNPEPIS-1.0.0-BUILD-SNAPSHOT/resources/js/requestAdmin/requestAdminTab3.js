 /**신청서 검토서*/ 

function tab3Grid(){
	$('#td_1').empty();
	$('#td_2').empty();
	
	var data = {
			ISP_RQT_ID : key
	};

	$.ajax({
		url: "/kpc/requestAdmin/tab3GridList",
		dataType : 'json',
		data : data,
		async : false,
		type : 'POST',
		success: function(result){
			if(result.main.RQST_RVW_ID != null){
				$('#reviewWriteBtn').hide();
				$('#tab3NoData').hide();
				$('#tab3Data').show();
				$('#screeningSelect1').val(result.sub[0].SPEC_CD);
				screeningSelect1($('#screeningSelect1'));
				$('#screeningSelect2').val(result.sub[0].KAB_CD);

				$.each(result.sub, function(i,v){
					if(v.KAB_CD != ''){
						$('#td_1').append(v.SPEC_CD + '&nbsp; <a href="#" class="text_blue" onclick="reviewWriteMod();">'+v.KAB_CD+'</a><br>');
					}
					if(v.KPC_QA_CD != ''){
						$('#td_2').append(v.SPEC_CD + '&nbsp; <a href="#" class="text_blue" onclick="reviewWriteMod();">'+v.KPC_QA_CD+'</a><br>');
					}
				});
				CMPLT_YN = result.main.CMPLT_YN;
				MGR_RVW_YN = result.main.MGR_RVW_YN;
				$('#RQST_RVW_ID').val(result.main.RQST_RVW_ID);
				$('#td_3').text(result.main.REQ_MD);
				$('#td_4').text(result.main.DCD_MD);
				$('#td_5').text(result.main.MGR_RVW_YN == 'Y' ? '완료' : '미완료');
				$('#td_6').text(result.main.RQST_RVW_ID)
				$.each(result.team, function(i, v){
					if(v.TM_MGR_YN == 'Y'){
						$('#td_7').text(v.EMP_NAME);
						$('#teamLeader').val(v.INS_PRSN_ID);
					}else{
						$('#td_8').text(v.EMP_NAME);
						$('#teamMember').val(v.INS_PRSN_ID);
					}
				});
			}
			
		}
	});
	
	
}

$(function(){
	
	$('#reviewWritePopup').kendoWindow({
	    width: "700px",
	    title: '신청서 검토서',
	    visible: false,
	    modal : true,
	    close : reviewWritePopupClose,
	    actions: [
	        "Close"
	    ],
	}).data("kendoWindow").center();
	
	
});

function reviewWriteBtn(){
	var data = {
			ISP_RQT_ID : key
	};
	
	$.ajax({
		url: "/kpc/requestAdmin/reviewWriteList",
		dataType : 'json',
		data : data,
		async : false,
		type : 'POST',
		success: function(result){
			
			$('#LBR_CNT').text(result.topData.LBR_CNT);
			$('#REQ_MD_').text(result.topData.REQ_MD);
			
			
			$.each(result.norm, function(i, v){
				var reviewWriteTbodyTempl =
					'<tr>'
					+'<td>'+v.SPEC_CD+'<a href="#n" onclick="addWriteSelect(\''+v.SPEC_CD+'\');"><img src="../Images/btn/plus_btn.png" alt=""></a>'
					+'<input type="hidden" class="selectKey" id="'+v.SPEC_CD+'" value="'+v.ISP_RQST_ID+'">'
					+'</td>'
					+'<td>'
					+'<select class="'+v.SPEC_CD+'_kab selectmenu" id="'+v.SPEC_CD+'_kab0" onchange="selectChange(this);" style="width:70%;"><option vlaue="all" selected="selected">구분</option></select>'
					+'</td>'
					+'<td>'
					+'<select class="'+v.SPEC_CD+'_kpc selectmenu" id="'+v.SPEC_CD+'_kpc0" style="width:70%;"><option vlaue="all" selected="selected">구분</option></select>'
					+'</td>'
					+'</tr>';
				
				$('#reviewWriteTbody').append(reviewWriteTbodyTempl);
				
				$.each(result.selectOption[v.SPEC_CD], function(ii, vv){
					$('#'+v.SPEC_CD+'_kab0').append('<option data-codeNm="'+vv.CODE_NM+'" value="'+vv.CODE_CD+'">'+vv.CODE_CD+' ( '+vv.CODE_NM+' )</option>');
				});
				
			});

		}
	});
	
	$('#reviewWritePopup').data("kendoWindow").open();
	
}
function selectChange(e){
	subSelectAppend($(e).closest('tr').find('input').attr('id'), $(e).val(), $(e).attr('id').split('kab')[1]);
}

function addWriteSelect(id){
	addWriteSelectTr(id, '_kab');
//	addWriteSelectTr(id, '_kpc');
	addWriteSelectTrDe(id, '_kpc');
}

function addWriteSelectTr(id, type){
	var cnt = Number($($('.'+id+type)[$('.'+id+type).length-1]).attr('id').split(id+type)[1])+1;
	var tem = $($('.'+id+type)[0]).clone().attr('id', id+type+cnt);
	var tr = $('.'+id+type).closest('td');
	$(tr).append('<br>');
	$(tr).append(tem);
	$(tr).append('<a href="#n" onclick="addWriteSelectDel(\''+id+'\' , \''+cnt+'\', this);"><img src="../Images/btn/minus_btn.png" alt="">');
}

function addWriteSelectTrDe(id, type){
	var cnt = Number($($('.'+id+type)[$('.'+id+type).length-1]).attr('id').split(id+type)[1])+1;
	var tr = $('.'+id+type).closest('td');
	$(tr).append('<br><select class="'+id+type+' selectmenu" id="'+id+type+cnt+'" style="width:90%;"><option value="all" selected="selected">구분</option></select>');
}

function addWriteSelectDel(id, cnt, e){
	$($(e).closest('td').find('br')[$(e).closest('td').find('br').length - 1]).remove();
	$(e).closest('td').next().find('br')[$(e).closest('td').next().find('br').length - 1].remove();
	$('#'+id+'_kab'+cnt).closest('br').remove();
	$('#'+id+'_kab'+cnt).remove();
	$('#'+id+'_kpc'+cnt).remove();
	$(e).remove();

}

function subSelectAppend(id, selectValue, index){
	var data =  {
			id : id,
			selectValue : selectValue
	}
	
	$.ajax({
		url: "/kpc/requestAdmin/subSelectAppend",
		data : data,
		async : false,
		type : 'POST',
		success: function(result){
			$('#'+id+'_kpc'+index).empty();
			$('#'+id+'_kpc'+index).append('<option vlaue="all"  selected="selected">구분</option>');
			$.each(result.list, function(i, v){
				$('#'+id+'_kpc'+index).append('<option data-codeNm="'+v.CODE_NM+'" value="'+v.CODE_CD+'">'+v.CODE_CD+' ( '+v.CODE_NM+' )</option>');
			});
			
		}
	});
}

function reviewWritePopupCancel(){
	$('#reviewWriteTbody').empty();
	$('#reviewWritePopup').data("kendoWindow").close();
}

function reviewWritePopupSave(){

	var data =  {
			main : {
				RQST_RVW_ID : $('#RQST_RVW_ID').val(), //검토서 ID
				IDRS_FCTR : $('#IDRS_FCTR').val(), //증가요인
				DCD_MD : $('#DCD_MD').val(), //결정후 MD
				RVW_CPLX : $('#rvwCplxSelect').val(), //복잡성
				RVW_ETC : $('#RVW_ETC').val(), //기타
				ISP_RQT_ID : key
			},
			
			select : selectData()
	}

	$.ajax({
		url: "/kpc/requestAdmin/reviewWriteSave",
		data : {data : JSON.stringify(data)},
		type : 'POST',
		dataType : 'json',
		success: function(result){
			tab3Grid();
//			$('#screeningSelect1').empty();
//			$('#screeningSelect2').empty();
			
//			$.each(result.select1, function(i, v){
//				$('#screeningSelect1').append('<option value="'+v.CODE_CD+'">'+v.CODE_CD+'</option>');
//			});
//			$.each(result.select2, function(i, v){
//				$('#screeningSelect2').append('<option value="'+v.CODE_CD+'">'+v.CODE_CD+'</option>');
//			});
		}
	});
	
	$('#reviewWritePopup').data("kendoWindow").close();
	
}

function selectData(){
	var tx = new Array();
	$.each($('.selectKey'), function(i, v){

		$.each($('select[id^="'+$(v).attr('id')+'_kab"]'), function(ii,vv){
			var te = $(vv).attr('id').split('kab');
			var t = $('#'+te[0]+'kpc'+te[1]).val();
			var tn = $('#'+te[0]+'kpc'+te[1]+' option:selected' ).text();

				var data = {
				ISP_RQST_ID : $(v).val(),
				KAB_CD 		: $(vv).val() == '구분' ? '' : $(vv).val(),
				KPC_QA_CD 	: t == '구분' ? '' : t,
				KAB_NM		: $(vv).attr('data-codeNm'),
				KPC_QA_NM	: tn == '구분' ? '' : tn,
					
			};
			tx.push(data);
		});
		
	});
	
	return tx;
}

function reviewWritePopupClose(){
	$('#reviewWriteTbody').empty();
}

function coReqMdSum(){
	var a = $('#REQ_MD_').text();
	var b = $('#DCD_MD').val();

		$('#perText').text(((b - a) / a*100).toFixed(2) +'%');
}

function reviewWriteMod(){
	reviewWriteBtn();	
	var data = {
			ISP_RQT_ID : key
	};

	$.ajax({
		url: "/kpc/requestAdmin/tab3GridList",
		dataType : 'json',
		data : data,
		async : false,
		type : 'POST',
		success: function(result){
			$('#RQST_RVW_ID').val(result.main.RQST_RVW_ID);
			$('#IDRS_FCTR').val(result.main.IDRS_FCTR);
			$('#DCD_MD').val(result.main.DCD_MD);
			$('#rvwCplxSelect').val(result.main.RVW_CPLX);
			$('#RVW_ETC').val(result.main.RVW_ETC);
			coReqMdSum();
			var cnt = 0;
			var item = '';
			$.each(result.sub, function(i, v){
				if(item != v.SPEC_CD){
					item = v.SPEC_CD;
					cnt = 0;
				}
				if(cnt > 0){
					addWriteSelect(v.SPEC_CD);
				}
				$('#'+v.SPEC_CD+'_kab' + cnt).val(v.KAB_CD);
				subSelectAppend(v.SPEC_CD, v.KAB_CD, cnt);
				$('#'+v.SPEC_CD+'_kpc' + cnt).val(v.KPC_QA_CD);
				cnt++;
			})
			
		}
	})
	
}

function searchsim1(){
	
	screeningSearchPopup('a', $('#HPE_DT_1').val(), $('#HPE_DT_2').val(), '', '');
}

function searchsim2(){
	
	screeningSearchPopup('b', $('#HPE_DT_1').val(), $('#HPE_DT_2').val(), '', '');
}

function tab3PopupView(){
	
	if($('#teamLeader').val() == ''){
		alert('팀장을 선택하세요.');
		return;
	}
	
	window.open('/kpc/requestAdmin/tab3PopupView?key1='+key+'&key2='+$('#RQST_RVW_ID').val(),"tab3PopupView", "width=750, height=800, resizable=no, scrollbars=no, status=no, top=50, left=150", "newWindow");
	
}


