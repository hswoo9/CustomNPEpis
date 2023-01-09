/**templateinfoListView.js
 * 
 */

/** @description Determines the area of a circle that has the specified radius parameter.  
 * @param {number} radius The radius of the circle.  
 * @return {number}  
 */  

//함수 객체
var fnObj = {
		
		fnSetTinameSelectbox : function () {		//양식 샐랙트 박스 바인딩
			$("#txt_tiname").kendoComboBox({ 
					    dataSource: svlObj.ds_templateinfoList,
					    dataTextField: "C_TINAME",
						dataValueField: "C_TIKEYCODE",
						index: 0
			});
		},
		
		fnSetDeptListSelectbox : function () {	//부서 샐랙트 박스 바인딩
//			console.log('부서샐랙트');
			svlObj.ds_deptList.unshift({DEPT_NAME : '전체', DEPT_SEQ : ""});			
			$("#txt_dept_name").kendoComboBox({ 
					    dataSource: svlObj.ds_deptList,
					    dataTextField: "DEPT_NAME",
						dataValueField: "DEPT_SEQ",
						index: 0
			});
		},
			
//		msgTest : function(){console.log($("#txt_tiname").data('kendoComboBox').value())},
				 
	    fnMainGrid : function () {				//캔도 그리드 기본
//	    	console.log($("#txt_tiname").data('kendoComboBox').value());
	    	var param_search_obj = {		//조회조건 객체
	    			c_tikeycode : $("#txt_tiname").data('kendoComboBox').value(),
	    			dept_seq : $("#txt_dept_name").data('kendoComboBox').value(),
	    			
					fromDate : $('#from_date').val().replace(/[^0-9]/g, ''),
			        toDate : $('#to_date').val().replace(/[^0-9]/g, ''),
	    	};
	    		    	
	    	var dataSource = new kendo.data.DataSource({
	    		serverPaging: true,
	    		pageSize: 10,
	    	    transport: { 
	    	        read:  {
	    	            url: _g_contextPath_+'/templateinfo/recordinfoList',
	    	            dataType: "json",
	    	            type: 'post'
	    	        },
	    	      	parameterMap: function(data, operation) {    		      		
	    	        	data.c_tikeycode = param_search_obj.c_tikeycode;
	    	        	data.dept_seq = param_search_obj.dept_seq;	    	        	
	    	        	data.fromDate = ''||param_search_obj.fromDate;
	    	        	data.toDate = ''||param_search_obj.toDate;

	    	     	return data;

	    	     	}
	    	    },
	    	    schema: {
	    	      data: function(response) {
	    	        return response.list;
	    	      },
	    	      total: function(response) {
	    		        return response.totalCount;
	    		  },
	    		 model: {
			          fields: {
	    		        	  c_tikeycode  : { type: "string" },	       
			          		}
	    		      }
	    	    }
	    	});		    	
	    	
	    	var grid = $("#gridRecordinfo").kendoGrid({
	    	        dataSource: dataSource,
	    	        height: 500,
	    	        
	    	        sortable: true,
	    	        pageable: {
	    	            refresh: true,
	    	            pageSizes: true,
	    	            buttonCount: 5
	    	        },
	    	        persistSelection: true,
	    	        selectable: "multiple",
	    	        columns: [
//	    	        	{ template: "<input type='checkbox' id='pk#=common_code_id#'  class='k-checkbox checkbox'/><label for='pk#=common_code_id#' class='k-checkbox-label'></label>",
//	    	        	width:50,	
//	    	        	},
	    	        	 {
	    	            field: "C_RIREGDATE",
	    	            title: "작성일",
	    	            width: "180px"
	    	        }, {
	    	        	
	    	            field: "DEPT_NAME",
	    	            title: "작성부서",
	    	            width: "180px"
	    	            
	    	        }, {
	    	            field: "EMP_NAME",
	    	            title: "작성자",
	    	           
	    	        }, {
	    	            field: "C_RIDOCFULLNUM",
	    	            title: "문서번호",
	    	        }, {
	    	            field: "C_RIAFTERTITLE",
	    	            title: "문서명",
	    	        },{
	    				template: '<input type="button" class="cls_doc_view" onclick="eventObj.clickBtnDocView(this);"value="보기" />',
	    				title : "문서보기"
	    			}],
	    	        change: function (e){
	    	        	clickMainGrid(e)
	    	        }
	    	    }).data("kendoGrid");
	     },  
};

//이벤트 객체 
var eventObj = {
		changeTemplateinfoSelectBox : function(e){		//양식 샐랙트 박스 변경 이벤트
	        e = e || window.event;                          	//이벤트
	        var src = e.target || e.srcElement,				 //이벤트 발생 엘리먼트
	        		v_tikeycode = $(src).data('kendoComboBox').value();            
			
		},
	
		changeDeptNameSelectBox : function(e){		//부서 샐랙트 박스 변경 이벤트
	        e = e || window.event;                          	//이벤트
	        var src = e.target || e.srcElement,			 	//이벤트 발생 엘리먼트
	        		v_dept_seq = $(src).data('kendoComboBox').value();            

		},
		
	    clickSearch : function (e) {							//조회버튼 클릭 이벤트
	        e = e || window.event;                          	//이벤트
	        var src = e.target || e.srcElement;			 	//이벤트 발생 엘리먼트

	        fnObj.fnMainGrid();
     },		
     
        clickBtnDocView : function (e) {				//보기버튼 클릭 이벤트
	        e = e || window.event;                          	//이벤트
	        var src = e.target || e.srcElement;			 	//이벤트 발생 엘리먼트
	        
	        var row = $("#gridRecordinfo").data("kendoGrid").dataItem($(e).closest("tr"));
	        var key = row.c_dikeycode;
	        window.open(_local_Url_+'/ea/edoc/eapproval/docCommonDraftView.do?diKeyCode='+key , 'viewer', 'width=965, height=650, resizable=no, scrollbars = yes, status=no, top=50, left=50', 'newWindow')
	    	
	        console.log(row.C_RIREGDATE);
     },		 
     
//	    clickMainGrid : function (e) {			//그리드 클릭 이벤트
//	    	 var rows = grid.select(), record = '';
//
//				rows.each( function(){
//					record = grid.dataItem($(this));
//					console.log(record);
//				}); 
//				subReload(record);
//	     }		
};

var elObj = {
};


$(document).ready(function() {	
	fnObj.fnSetTinameSelectbox();		//양식목록 샐렉트박스
	fnObj.fnSetDeptListSelectbox();		//부서 샐렉트박스
	
	$('#txt_tiname').data('kendoComboBox').value($('#sTiKeyCode').val()) ;
	
	 
	 fnObj.fnMainGrid();
	 
	 
	 console.log($('.cls_doc_view').value);
		//이벤트 리스너
//		$('#txt_tiname').bind('change', eventObj.changeTemplateinfoSelectBox);		//양식샐랙트 박스 변경
//		$('#txt_tiname').bind('change', eventObj.changeDeptNameSelectBox);			//부서샐랙트 박스 변경	
		$('#btn_search').bind('click', eventObj.clickSearch);									//조회버튼 클릭	
});	