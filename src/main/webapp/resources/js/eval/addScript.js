
var pageInfo = {
        refresh: true,
        pageSizes: [10, 20, 40],
        buttonCount: 5,
        messages: {
            display: "{0} - {1} of {2}",
            itemsPerPage: "",
            empty: "데이터가 없습니다.",
        }
};

function commissionerGrid() {
	
	var commissionerGrid = $("#commissionerGrid").kendoGrid({
	        dataSource: new kendo.data.DataSource({
				serverPaging: true,
				pageSize: 10,
	    	    transport: { 
	    	        read:  {
	    	            url: _g_contextPath_+'/eval/evaluationCommitteeListSearchPop',
	    	            dataType: "json",
	    	            type: 'post'
	    	        },
	    	      	parameterMap: function(data, operation) {
			      		data.searchNm = $('#searchNm').val();
			      		data.eval_s_date = eval_s_date;
			      		data.eval_e_date = eval_e_date;
			      		data.code = $('#searchSelect').val();
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
	    	}),
	        sortable: true,
	        height: 450,
	        persistSelection: true,
			pageable: pageInfo,
	        selectable: "multiple",
	        columns:[{
	        					field: "name",
		    				    title: "성명",
	        					width : 30
	        				},
	        				{
	        					field: "org_name",
		   					    title: "기관명",
	        					width : 30
	        				},
	        				{
	        					field: "biz_type_array",
	    					    title: "전문분야",
	        					width : 30
	        				},
	        				{
					    		field: "mobile",
						        title: "휴대전화",
	        					width : 30
	        				},
	        				{
	        					title : "선택",
	        					width : 15,
						    	template : '<input type="button" id="" class="text_blue" onclick="commissionerSelect(this);" value="선택">'
	    		    	    }]
	    }).data("kendoGrid");
}

function commissionerInitPopEvent() {
	
	$("#commissionerPopup").kendoWindow({
		   height: "650px",
		   visible: false,
		   title: '평가위원 선택',
		   modal : true,
		   actions: ["Close"]
		}).data("kendoWindow").center();

	$('.date_yyyymmdd').kendoDatePicker({
     	culture : "ko-KR",
	    format : "yyyy-MM-dd",
	});
	
	$(".date_yyyymmdd").attr("readonly", true);
	
	$("#searchNm, #searchOrgNm").on("keyup", function(e){
		if (e.keyCode === 13) {
			commissionerGridReload();
		}
	});
	
	$('#commissionerGridPopupCancel').on('click', function() {
		$("#commissionerPopup").data("kendoWindow").close();
	});
}

function commissionerSelect(e){

    // 선택할 때 중복 체크

    var row = $("#commissionerGrid").data("kendoGrid").dataItem($(e).closest("tr"));

    if (resultCommissionerList.some(function(v) { return v.commissioner_pool_seq == row.commissioner_pool_seq;})) {
        return;
    };

    var template = '<tr>'
        +	'<td></td>'
        +	'<td>'+ (resultCommissionerList.length + 1) +'</td>'
        +	'<td>'+ row.name +'</td>'
        +	'<td>'+ (row.birth_date || '') +'</td>'
        +	'<td>'+ (row.biz_type_array || '') +'</td>'
        +	'<td>'+ (row.org_name || '') +'</td>'
        +	'<td>'+ (row.org_grade || '') +'</td>'
        +	'<td>'+ (row.tel || '') +'</td>'
        +	'<td>'+ (row.mobile || '') +'</td>'
        +	'<td>'+ (row.email || '') +'</td>'
        +	'<td>'
        +	'	<input type="button" value="불참" onclick="" disabled>'
        +	'</td>'
        +'</tr>';


    let password = '';
    for (let i = 0; i < 6; i++) {
        password += Math.floor(Math.random() * 10)
    }
    row.password = password;

    $("#commTable").append(template);
    resultCommissionerList.push(row);
    addCommissionerList.push(row);

    $("#commissionerPopup").data("kendoWindow").close();
}

function commissionerGridReload() {
	$("#commissionerGrid").data("kendoGrid").dataSource.page(1);
}

function addCommissioner() {
	$("#commissionerPopup").data("kendoWindow").open();
}

function confirmCommissioner() {
	
	var data = {
			code : JSON.stringify(addCommissionerList),
			committee_seq : committee_seq,
			create_date : $('#create_date').val(),
			create_emp_seq : $('#create_emp_seq').val(),
			create_dept_seq : $('#create_dept_seq').val(),
			userCnt : 1,
			tabNum : 1,
			commissioner_cnt : resultCommissionerList.length,
			orderNo : resultCommissionerList.length - addCommissionerList.length
		}
	
	if(confirm('확정하시겠습니까?')){
		
		if (addCommissionerList.length == 0) {
			return;
		}
		
		var url = '';
		
		if (resultCommissionerList.length == addCommissionerList.length) { // 최초 확정 
			url = _g_contextPath_ + '/eval/setEvalCommSave';
		} else { // 이후 추가 확정
			url = _g_contextPath_ + '/eval/setEvalCommSave2';
		}
		
		$.ajax({
			url: url,
			data : data,
			type : 'POST',
			success: function(result){
				alert('성공하였습니다.');
				var url = _g_contextPath_ + '/eval/evaluationProposalDetail?code=' + committee_seq + '&tabN=' + tabNum;
				location.href = url;
			}
		});
		
	}
}

