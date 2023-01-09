<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>

<%
 /** 
  * @Class Name : payCmsView.jsp
  * @Description : 급여 cms 연동조회
  * @Modification Information
  * @
  * @  수정일                 수정자             수정내용
  * @ ----------      --------    ---------------------------
  * @ 2018.05.24      권현태             최초 생성
  *
  * @author  권현태
  * @since 2018.05.24
  * @version 1.0
  * @see
  *
  */
%>

<html>
<head>
</head>
<script type="text/javascript" src="<c:url value='/js/examinant/jszip.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/examinant/shieldui-all.min.js' />"></script>
<script type="text/javascript" src='<c:url value="/js/ac/acUtil.js"></c:url>'></script>

<style type="text/css">
.k-header .k-link{
   text-align: center;
}
</style>

<script type="text/javascript">

	$(window).load(function() {
		fn_payYm();
	});	
	
    //온로드 이벤트
    $(document).ready(function() {
    	
		//단계 콤보박스 초기화
		$("#account").kendoComboBox({
            dataTextField: "text",
            dataValueField: "value",
            dataSource:  [{ text: "계좌1", value: "account1" },
		                       { text: "계좌2", value: "account2" },		                       
                     		  ],
     		   text : "계좌1"
     		 , value : "account1"
      	});
    	
		//년월 달력 초기화
	    $("#payYm").kendoDatePicker({
	        // defines the start view
	        start: "year",
	
	        // defines when the calendar should return date
	        depth: "year",
	
	        // display month and year in the input
	        format: "yyyy-MM",
			parseFormats : ["yyyy-MM"],
	
	        // specifies that DateInput is used for masking the input element
	        culture : "ko-KR",
	        
	        dateInput: true
	    });
    	
		//부서 콤보박스 초기화
		fnTpfDeptComboBoxInit('payDt');
		
		//팝업ID	
		var empWindow = $("#empPopUp");
		//검색ID
	    empSearch = $("#empSearch");
	    empSearch2 = $("#empSearch2");
		
	    //검색 클릭(팝업호출)
	    empSearch.click(function() {	
	    	
	    	$('#pyddFg').val("'P2'");
	    	
	    	 empWindow.data("kendoWindow").open();
	    	 empGridReload();
		     empSearch.fadeOut();
		 });
	    
	    //검색 클릭(팝업호출)
	    empSearch2.click(function() {
	    	$('#pyddFg').val("'P3'");
	    	
	    	 empWindow.data("kendoWindow").open();
	    	 empGridReload();
		     empSearch.fadeOut();
		 });
	    
	     //팝업 X 닫기버튼 이벤트
		 function onClose() {
			 empSearch.fadeIn();
		 }
	     
	     //닫기 이벤트
		 $("#cancle").click(function(){
			 empWindow.data("kendoWindow").close();
		 });
		 
	     //닫기 이벤트
		 $("#select").click(function(){
			 
			 var ch = $('.checkbox:checked');
			 
			 var chkedVal = "";
			 var chkedText = "";
			 var chkedCode = "";
			 
			 grid = $('#empGrid').data("kendoGrid");
			 
			 var pyddFg =$('#pyddFg').val();
			 
			 if(pyddFg == "'P2'"){
				 $.each(ch, function(i,v){
						dataItem = grid.dataItem($(v).closest("tr"));
						var payNm = dataItem.PAY_NM;
						var payCd = dataItem.PAY_CD;
						
						chkedVal += "'"+payNm+"'"+",";
						
						chkedText+= payNm+",";
						
						chkedCode += "'"+payCd+"'"+",";
				 });
				 
				 $('#payNm').val(chkedVal.slice(0,-1));
				 $('#payCd').val(chkedCode.slice(0,-1));
				 
				 $('#tkpPayCdP2').val(chkedText.slice(0,-1));
				 
				 if($('#tkpPayCdP2').val().length > 50){
					 $('#tkpPayCdP2').val(chkedText.substring(0,50)+"...");
				 }
			 }else{
				 $.each(ch, function(i,v){
						dataItem = grid.dataItem($(v).closest("tr"));
						var payNm = dataItem.PAY_NM;
						var payCd = dataItem.PAY_CD;
						
						chkedVal += "'"+payNm+"'"+",";
						
						chkedText+= payNm+",";
						
						chkedCode += "'"+payCd+"'"+",";
						
				 });
				 
				 $('#payNmD').val(chkedVal.slice(0,-1));
				 $('#payCdD').val(chkedCode.slice(0,-1));
				 
				 $('#tkpPayCdP3').val(chkedText.slice(0,-1));
				 
				 if($('#tkpPayCdP3').val().length > 50){
					 $('#tkpPayCdP3').val(chkedText.substring(0,50)+"...");
				 }
			 }
			 
			 empWindow.data("kendoWindow").close();
		 });
	     
		 //팝업 초기화
		 empWindow.kendoWindow({
		     width: "300px",
		     height: "650px",
		     visible: false,
		     actions: [
		    	 "Close"
		     ],
		     close: onClose
		 }).data("kendoWindow").center();
    });
</script>

<script type="text/javascript">
	//사원팝업 ajax
	var empDataSource = new kendo.data.DataSource({
		serverPaging: true,
		pageSize: 10,
	    transport: { 
	        read:  {
	            url: _g_contextPath_+'/cms/tkpPayCd',
	            dataType: "json",
	            type: 'post'
	        },
	      	parameterMap: function(data, operation) {
	      		data.pyddFg = $('#pyddFg').val();
	      		data.payYy = $('#year').val();
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

	function empGridReload(){
		$('#empGrid').data('kendoGrid').dataSource.page(1);
	}
	
	function empGrid(){		
		//사원 팝업그리드 초기화
		var grid = $("#empGrid").kendoGrid({
	        dataSource: empDataSource,
	        height: 500,	        
	        sortable: true,
	        persistSelection: true,
	        selectable: "multiple",
	        columns:[{headerTemplate: "<input type='checkbox' id='headerCheckbox' onclick='checkAll()'; class='k-checkbox header-checkbox'><label class='k-checkbox-label' for='headerCheckbox'></label>",
	         	  		  template: fn_workStep,
	           	 	  	  width : 50,},
	        	         {field: "PAY_NM",
				            title: "항목명",
				        }],
	        change: function (e){
	        	codeGridClick(e)
	        }
	    }).data("kendoGrid");
		
		grid.table.on("click", ".checkbox", selectRow);
		
		var checkedIds = {};
		
		//on click of the checkbox:
		function selectRow(){
			var checked = this.checked,
			row = $(this).closest("tr"),
			grid = $('#empGrid').data("kendoGrid"),
			dataItem = grid.dataItem(row);
			
			checkedIds[dataItem.CODE_CD] = checked;
			if(checked){
				//-select the row
				row.addClass("k-state-selected");
			}else{
				//-remove selection
				row.removeClass("k-state-selected");
			}
		}
		//사원팝업 grid 클릭이벤트
		function codeGridClick(){			
			var rows = grid.select();
			var record;
			rows.each( function(){
				record = grid.dataItem($(this));
				console.log(record);
			}); 
			subReload(record);
		}
	}

	function subReload(record){
		
	} 

	//선택 클릭이벤트
	function empSelect(e) {		
		//선택row
		var row = $("#empGrid").data("kendoGrid").dataItem($(e).closest("tr"));
		//사원명 셋팅
		$('#empNameSearch').val(row.emp_name);		
		//사원seq 셋팅
		$('#empSeqSearch').val(row.emp_seq);		
		//사원부서 셋팅
		$('#empDeptName').val(row.dept_name);		
		//팝업ID	
		var empWindow = $("#empPopUp");		
		//닫기 이벤트
		empWindow.data("kendoWindow").close();
	}
	
</script>

<script type="text/javascript">
	//전체선택	/ 전체해제
	function checkAll(){
		var headrChecked = $("#headerCheckbox").is(":checked");
		if(headrChecked){
			$("input[name=check]").not(":disabled").prop("checked", "checked");
		}else{
			$("input[name=check]").not(":disabled").removeProp("checked");
		}
	}
	
	//체크박스 탬플릿
	function fn_workStep(row) {
		var key = row.PAY_CD;
		return '<input type="checkbox" id="check'+key+'" name="check" class="k-checkbox checkbox"/><label for="check'+key+'" class="k-checkbox-label"></label>';
	}
</script>

<script type="text/javascript">
	//온로드 이벤트
	$(function(){
		empGrid();
		//mainGrid(); 
	}); 
	
	//메인그리드 ajax
	var dataSource = new kendo.data.DataSource({
		serverPaging : true,
		pageSize : 10,
		transport : {
			read : {
				url : _g_contextPath_+'/cms/payCmsList',
				dataType : "json",
				type : 'POST'
			},
			parameterMap : function(data, operation) {			
				data.payCd = $('#payCd').val();
				data.payCdD = $('#payCdD').val();
				data.payNm = $('#payNm').val();
				data.payNmD = $('#payNmD').val();
				data.emplNm = $('#emplNmSearch').val();
				data.account = $('#accountSearch').val();
				data.payDt = $('#payDt').val().replace(/[^0-9]/g, '');;
				
				data.remarkMonth = $('#payYm').val().substr(6,1);
				
				return data;
			}
		},
		schema : {
			data : function(response) {
				return response.list;
			},
			total : function(response) {
				return response.totalCount;
			}
		}
	});

	//검색버튼 이벤트
	function fn_nightDutySearch() {
		gridReLoad();
	}

	//메인그리드 reload
	function gridReLoad() {
		
		 var chkedVal = "";
		
		 $('input:checkbox[id="emplNm"]').each(function() {
		      if(this.checked){//checked 처리된 항목의 값
		    	  chkedVal += "'"+this.value+"'"+",";
		      }
		 });
		 
		 $('#emplNmSearch').val(chkedVal.slice(0,-1));
		 
		 $('#accountSearch').val($('#account').val());
		 
		$('#grid').data('kendoGrid').dataSource.read();
	}

	 //메인그리드
	function mainGrid() {
		//캔도 그리드 기본
		var grid = $("#grid").kendoGrid({
			dataSource : dataSource,
			toolbar: [
	            {name : "excel", text : "엑셀 내려받기"},
	       ],
	         excel: {
	            fileName: $('#payYm').val()+'_급여내역'+"(" + new Date().toISOString().substring(0, 10)+").xlsx",
	             allPages: true
	         },
			height : 500,
			sortable : true,			
			persistSelection : true,
			selectable : "multiple",			
			columns : [{
				field : "PYTB_NM",
				title : "은행",
			},{
				field : "ACCT_NO",
				title : "계좌번호",
			},{
				field : "PAY_AMT",
				title : "금액",
			},{
				field : "EMPLOYEENM",
				title : "성명",
			},{
				field : "REMARK",
				title : "비고",
			}],
			change: function (e){
	        	gridClick(e)
	        }
		}).data("kendoGrid");
		
		grid.table.on("click", ".checkbox", selectRow);
		
		var checkedIds = {};
		
		// on click of the checkbox:
		function selectRow(){	
			var checked = this.checked,
			row = $(this).closest("tr"),
			grid = $('#grid').data("kendoGrid"),
			dataItem = grid.dataItem(row);
			
			checkedIds[dataItem.ISPC_MST_ID] = checked;
			if (checked) {
				//-select the row
				row.addClass("k-state-selected");
			} else {
				//-remove selection
				row.removeClass("k-state-selected");
			} 
		}
		
		//mainGrid 클릭이벤트
		function gridClick(){
			
	   }
	}

	 var ispcID = "";
	
	function subGrid(id){
		ispcID = id;
		modBtn(id);
		$("#grid").data('kendoGrid').dataSource.read();
	}
	
</script >

<script type="text/javascript">
	function fn_payYm(){
		var payYm =$('#payYm').val().replace(/[^0-9]/g, '');
		
		var data = {
			//외부강의신고ID
			payYm : payYm,
		}
			
 		$.ajax({
			url: _g_contextPath_+"/cms/tkpPayYm",
			dataType : 'json',
			data : data,
			type : 'POST',
			success: function(result){
				$.each(result.list, function(i, v){
					var payDt =v.PAYDT;
					//년
					var year =payDt.substr(0,4);
					//월
					var month =payDt.substr(4,2);
					//일
					var day =payDt.substr(6,2);
					//날짜 형 변환
					var date =year+"-"+month+"-"+day;
					
					//$('#payDt').val(date);
					//지급일
					fnTpfDeptComboBoxInit("payDt");
					
					mainGrid();
					gridReLoad();
				});
			}
 		});	
	}
</script >

<script type="text/javascript">
	//당직근무현황 엑셀다운로드
	$(function(){
		$('#excelBtn').on('click', function() {
			var dataSource = shield.DataSource.create({
		    	 remote: {
		    	        read: {
		    	            url:  _g_contextPath_+'/cms/payCmsExcelDown',
		    	            dataType: "json",
		    	            async: true,
		    	            data: function(){
		    	            	return {
			    	    			payCd : $('#payCd').val(),
			    	    			payCdD : $('#payCdD').val(),
			    					payNm : "",
			    					payNmD : "",
			    					emplNm : $('#emplNmSearch').val(),
			    					account : $('#accountSearch').val(),
			    					payDt : $('#payDt').val().replace(/[^0-9]/g, ''),
			    					remarkMonth : $('#payYm').val().substr(6,1)
		    	    			};
		    	            },
		    	        cache: false
		      		  }
		    	 }
		    });
			
			dataSource.read().then(function (data) {
		        new shield.exp.OOXMLWorkbook({
		            author: "system",
		            worksheets: [
		                {
		                    name: $('#payYm').val()+" 급여내역",
		                    //columns: [{ width: 100 }],
		                    rows: [{cells: [{style: {bold: true,
					                                        textAlign: "center",
					                                        background : "#FFE400"
					                                       },
		                                         value: "은행"
		                                	     },		                                	     
		                                	     {style: {bold: true,
					                                        textAlign: "center",
					                                        background : "#FFE400"
					                                       },
		                                         value: "계좌번호"
		                                	     },
		                                	     {style: {bold: true,
					                                        textAlign: "center",
					                                        background : "#FFE400"
					                                       },
		                                         value: "금액"
		                                	     },
		                                	     {style: {bold: true,
					                                        textAlign: "center",
					                                        background : "#FFE400"
					                                       },
		                                         value: "성명"
		                                	     },
		                                	     {style: {bold: true,
					                                        textAlign: "center",
					                                        background : "#FFE400"
					                                       },
		                                         value: "비고"
		                                	     }
		                            	       ]
		                        	  }
		                    ].concat($.map(data.list, function(item){
		                    	return {
		                            cells: [{style: {textAlign: "center"}
		                                     ,value: item.PYTB_NM},
		                                     {style: {textAlign: "center"}
		                                     ,value: item.ACCT_NO},
		                                     {style: {textAlign: "center"}
		                                     ,value: item.PAY_AMT},
		                                     {style: {textAlign: "center"}
		                                     ,value: item.EMPLOYEENM},
		                                     {style: {textAlign: "center"}
		                                     ,value: item.REMARK}		                                    
		                            		]
		                        };
		                    }))
		                }
		            ]
		        }).saveAs({
		            fileName: $('#payYm').val()+'_급여내역'+"(" + new Date().toISOString().substring(0, 10)+")"
		        });
		    });
		});
	});
</script >

<script type="text/javascript">
	function fnTpfDeptComboBoxInit(id){
		if($('#'+id)){
			var deptList = fnTpfGetDeptList();
			//deptList.unshift({dept_name : '전체', dept_value : ""});
			var itemType = $("#" + id).kendoComboBox({
				dataSource : deptList,
				dataTextField: "PAYDT",
				dataValueField: "PAYDT",
				index: 0,
				change:function(){
					//fnDeptChange();
				}
		    });
		}
	}
	function fnTpfGetDeptList(){
		var payYm =$('#payYm').val().replace(/[^0-9]/g, '');
		var result = {};
		var params = {payYm : payYm,};
		   var opt = {
		   		url     : _g_contextPath_ + "/cms/tkpPayYm",
		           async   : false,
		           data    : params,
		           successFn : function(data){
		           	result = data.list;
		           }
		   };
		   acUtil.ajax.call(opt);
		return result;
	}
	 
	 function fnDeptChange(){
		//var obj = $('#deptNameCode').data('kendoComboBox');
	}
</script>	


<body>

<div class="iframe_wrap" style="min-width: 1070px;">

	<!-- 컨텐츠타이틀영역 -->
    <div class="sub_title_wrap">       
        <div class="title_div">
            <h4>급여 CMS연동 조회</h4>
        </div>
    </div>
	<div class="sub_contents_wrap">
	<p class="tit_p mt5 mt20">급여 CMS연동 조회</p>
		<div class="top_box">
			<dl>				    
				<dt  class="ar" style="width:80px" >급여년월</dt>
				<dd>
					<input type="text" value="${applyMonth}" id="payYm" name="payYm" onchange="fn_payYm();" style="width: 90px"/>
				</dd>
				<dt  class="ar" style="width:50px" >지급일</dt>
				<dd>
					<input type="text" id="payDt" style="width: 100px"/>
				</dd>
				<dt  class="ar" style="width:80px">사원구분</dt>
				<dd style="border-top:1px solid; border-bottom:1px solid; border-left:1px solid; border-right:1px solid; padding:5px; border-color: #4374D9; "> 
					<c:forEach var="result" items="${resultList}" varStatus="status">
						<input style="height: 13px" type="checkbox" id="emplNm" name="emplNm" value="${result.CTD_CD}"> ${result.CTD_NM}
					</c:forEach>
				</dd>
				<dt  class="ar" style="width:80px" >계좌기준</dt>
				<dd>
					<input type="text" id="account" /> 
				</dd>
			</dl>
			<dl>	
				<dt  class="ar" style="width:80px" >지급항목</dt>
				<dd>
					<input type="text" id="tkpPayCdP2" style="width: 500px" />
					<input type="button" id="empSearch" value="선택" />
					<input type="hidden" id="payNm"/>
					<input type="hidden" id="payCd"/>
					<input type="hidden" id="payNmD"/>
					<input type="hidden" id="payCdD"/>
					<input type="hidden" id="pyddFg" value="'P2'"/>
					<input type="hidden" id="emplNmSearch"/>
					<input type="hidden" id="accountSearch"/>
					<input type="hidden" id="year" value="${year}"/>
				</dd>
				<dt  class="ar" style="width:103px" >공제항목</dt>
				<dd>
					<input type="text" id=tkpPayCdP3 style="width: 500px" />
					<input type="button" id="empSearch2" value="선택" />
				</dd>				
			</dl>
		</div>
  		    
	    <!--신청 버튼 -->
		<div class="btn_div">	
			<div class="right_div">
				<div class="controll_btn p0">										
<!-- 					<button type="button" id="excelBtn">엑셀</button> -->
					<button type="button" onclick="gridReLoad();">조회</button>
				</div>
			</div>
			<p class="f11 mt5 text_gray">※지급항목 공제항목은 기본 전체 항목내역 입니다.</p>
		</div>
		<div class="com_ta2 mt15">
			<div id="grid"></div>
		</div>
	</div>
	
	<!-- 사원검색팝업 -->
	<div class="pop_wrap_dir" id="empPopUp" style="width:300px;">
		<div class="pop_head">
			<h1>지급항목 선택</h1>
		</div>
		<div class="pop_con">
			<div class="com_ta mt15" style="">
				<div id="empGrid"></div>
			</div>			
		</div><!-- //pop_con -->

		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" id="select" value="선택" />
				<input type="button" class="gray_btn" id="cancle" value="닫기" />
			</div>
		</div><!-- //pop_foot -->
	</div><!-- //pop_wrap -->	
</body>
</html>