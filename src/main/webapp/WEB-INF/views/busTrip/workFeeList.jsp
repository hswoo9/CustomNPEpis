<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<jsp:useBean id="nowDate" class="java.util.Date" />
<fmt:formatDate value="${nowDate}" var="nowDate" pattern="yyyy-" />
<script type="text/javascript" src="<c:url value='/js/jszip.min.js' />"></script>
<script type="text/javascript" src='<c:url value="/js/ac/acUtil.js"></c:url>'></script>
<script type="text/javascript" src='<c:url value="/js/common/outProcessUtil.js"></c:url>'></script>

<style type="text/css">
.k-header .k-link {
	text-align: center;
}

.k-grid-content>table>tbody>tr {
	text-align: center;
}

.k-grid th.k-header, .k-grid-header {
	background: #F0F6FD;
}

.k-grid tbody tr {
	cursor: default;
}
.blueColor { color : blue; }
.onFont { font-weight : bold; color : green; }

html:first-child select {
    height: 24px;
    padding-right: 6px;
}
</style>

<script type="text/javascript">
	
	$(document).ready(function() {
		datePickerInit();
		fnTpfDeptComboBoxInit('selDept');
		mainGrid();
		var grid = $('#grid').data('kendoGrid');
		keyupInit();
		projectKendo();
	});


		$(function() {
			$(document).on("mouseover", ".docTitle", function() {
				$(this).removeClass("blueColor").addClass("onFont");
			});
			
			$(document).on("mouseout", ".docTitle", function() {
				$(this).removeClass("onFont").addClass("blueColor");
			});
			
		})
	function keyupInit() {
			$('#txtTitle').on('keyup', function(e){
				if(e.keyCode ===13){gridReLoad()} 
				});
			$('#empName').on('keyup', function(e){
				if(e.keyCode ===13){gridReLoad()} 
				});
	}
	/**
	 * 콤보박스 초기화
	 */
	function fnTpfDeptComboBoxInit(id){
		if($('#'+id)){
			var deptList = fnTpfGetDeptList();
			deptList.unshift({dept_name : "전체", dept_seq : ""});
			
			/* var deptList2 = [{dept_name : "${userInfo.orgnztNm }", dept_seq:"${userInfo.orgnztNm }"}]; */
			
			var itemType = $("#" + id).kendoComboBox({
				dataSource : deptList,
				dataTextField: "dept_name",
				dataValueField: "dept_seq",
				index: 0,
				change:function(){
					fnDeptChange();
				}
		    });
		}
	}

	
	function fnTpfGetDeptList(){
		var result = {};
		var params = {};
	    var opt = {
	    		url     : _g_contextPath_ + "/Ac/G20/Ex/getDeptList.do",
	            async   : false,
	            data    : params,
	            successFn : function(data){
	            	result = data.allDept;
	            }
	    };
	    acUtil.ajax.call(opt);
		return result;
	}
	
	function datePickerInit(){
		var smonth =  moment().add('month', -1).format('YYYY-MM-DD');
		var emonth =  moment().add('month').format('YYYY-MM-DD');
		$("#txtFrDt").val(smonth);
		$("#txtToDt").val(emonth);
		var datePickerOpt = {
				format: "yyyy-MM-dd",
				culture : "ko-KR",
				change:function(){
					startChange();
				}
			};
		//시작날짜
		$("#txtFrDt").kendoDatePicker(datePickerOpt);
		$("#txtFrDt").attr("readonly",true);
		//종료날짜
		datePickerOpt.change = endChange;
		$("#txtToDt").kendoDatePicker(datePickerOpt);
		$("#txtToDt").attr("readonly",true);
		startChange();
		endChange();
	}
	
	function startChange() {
		var start = $('#txtFrDt').data("kendoDatePicker");
		var end = $('#txtToDt').data("kendoDatePicker");
        var startDate = start.value(),
        endDate = end.value();

        if (startDate) {
            startDate = new Date(startDate);
            startDate.setDate(startDate.getDate());
            end.min(startDate);
        } else if (endDate) {
            start.max(new Date(endDate));
        } else {
            endDate = new Date();
            start.max(endDate);
            end.min(endDate);
        }
    }
	
	function endChange() {
		var start = $('#txtFrDt').data("kendoDatePicker");
		var end = $('#txtToDt').data("kendoDatePicker");
        var endDate = end.value(),
        startDate = start.value();

        if (endDate) {
            endDate = new Date(endDate);
            endDate.setDate(endDate.getDate());
            start.max(endDate);
        } else if (startDate) {
            end.min(new Date(startDate));
        } else {
            endDate = new Date();
            start.max(endDate);
            end.min(endDate);
        }
    }
	
	var dataSource = new kendo.data.DataSource({
		transport: {
			read: {
				type: 'post',
				dataType: 'json',
				url: _g_contextPath_ + "/busTrip/getWorkFeeList",
			},
			parameterMap: function(data, operation) {
				 data.start_dt =$('#txtFrDt').val();
				data.end_dt = $('#txtToDt').val();
				data.trip_code = 'A1702'
				if($('#nameSort').val() =='kyuljaeEmp'){
					/* data.emp_name =$('#empName').val();	 */				
				} else{
					data.ep_name_kor = $('#empName').val();
				}
				/* data.title = $('#txtTitle').val(); */
				data.nameSort = $('#nameSort').val();
				data.projectNm = $('#txtTitle').val();
				
				
				/* data.statusSort = $('#statusSort').val();
				data.empSameSort  = $('#empSameSort').val();
				data.sevenDaySort   = $('#sevenDaySort').val(); */
				
				
				if($('#selDept').data('kendoComboBox').text() == '전체'){
					
				}else{
					
				
				
				var aq;
	      		
		      	  $.ajax({
		      		url : "<c:url value='/busTrip/getErpEmpNumByDept' />",
		      		data : { "dept_seq" :$('#selDept').val() },
		      		type : 'POST',
		      		async: false,
		      		success : function(result) {
		      			var arr = new Array();
		      			$.each(result.result, function (i,v) {
							 arr.push(v.erp_emp_num);
		      				
						});
		      			var a = arr.join();
		      			aq = a;
		      		}	
		      		
		      		
		      	}); 
		      	  
		      	  data.empArr = aq;
				
				}
				
				
						
				
	   	    	return data ;
			}
		},
		schema: {
	   	    data: function(response) {
	   	    	if($('#statusSort').val() == '' && $('#empSameSort').val() == '' && $('#sevenDaySort').val() == ''){
		   	 		return response.list.filter(function(obj){
		   	 			
		   	 			if($('#nameSort').val() =='kyuljaeEmp'){
	   	 					if(obj.emp_name != null){
	   	 						if(obj.emp_name.indexOf($('#empName').val()) >= 0){
	   	 							
	   	 							if($('#txtTitle').val() != ''){
	   	 								var fullPjtNm = $('#txtTitle').val();
	   	 								var originPjtNm =fullPjtNm.substr(7);
	   	 						    
	   	 								if(obj.mgt_name == originPjtNm){
	   	 									
	   	 									return obj
	   	 								} 
	   	 							} else {
	   	 								return obj
	   	 							}
	   	 						}
	   	 					}
	   	 					
	   	 				}else{
	   	 					
		   	 				if($('#txtTitle').val() != ''){
	   	 						var fullPjtNm = $('#txtTitle').val();
								var originPjtNm =fullPjtNm.substr(7);
						    
								if(obj.mgt_name == originPjtNm){
										
										return obj
									} 
								} else {
									return obj
								}
	   	 				}
		   	 			
		   	 		});
		   	 	}
		   	 	if($('#statusSort').val() == '' && $('#empSameSort').val() == '' && $('#sevenDaySort').val() == 'safe'){
		   	 		return response.list.filter(function(obj){
		   	 			
			   	 		if(obj.res_date != null){
			   	 			var diffDay ;
			   	 			var resDate =obj.res_date;
			   	 			var tripDate =obj.authDate;
			   	 			
			   	 			diffDay = dayDiffCal(resDate,tripDate);
							
			   	 			if(diffDay <=7){
				   	 			if($('#nameSort').val() =='kyuljaeEmp'){
			   	 					if(obj.emp_name != null){
			   	 						if(obj.emp_name.indexOf($('#empName').val()) >= 0){
			   	 							
				   	 						if($('#txtTitle').val() != ''){
			   	 								var fullPjtNm = $('#txtTitle').val();
			   	 								var originPjtNm =fullPjtNm.substr(7);
			   	 						    
			   	 								if(obj.mgt_name == originPjtNm){
			   	 									
			   	 									return obj
			   	 								} 
			   	 							} else {
			   	 								return obj
			   	 							}
			   	 						}
			   	 					}
			   	 					
			   	 				}else{
			   	 					
				   	 				if($('#txtTitle').val() != ''){
			 								var fullPjtNm = $('#txtTitle').val();
			 								var originPjtNm =fullPjtNm.substr(7);
			 						    
			 								if(obj.mgt_name == originPjtNm){
			 									
			 									return obj
			 								} 
			 							} else {
			 								return obj
			 							}
			   	 				}
							}			   			
			   	 		}
		   	 			
		   	 		});
		   	 	}
		   	 	if($('#statusSort').val() == '' && $('#empSameSort').val() == '' && $('#sevenDaySort').val() == 'over'){
			   	 	return response.list.filter(function(obj){
		   	 			
		   	 			
			   	 		if(obj.res_date != null){
			   	 			var diffDay ;
			   	 			var resDate =obj.res_date;
			   	 			var tripDate =obj.authDate;
			   	 			
			   	 			diffDay = dayDiffCal(resDate,tripDate);
							
			   	 			if(diffDay >7){
				   	 			if($('#nameSort').val() =='kyuljaeEmp'){
			   	 					if(obj.emp_name != null){
			   	 						if(obj.emp_name.indexOf($('#empName').val()) >= 0){
			   	 							
				   	 						if($('#txtTitle').val() != ''){
			   	 								var fullPjtNm = $('#txtTitle').val();
			   	 								var originPjtNm =fullPjtNm.substr(7);
			   	 						    
			   	 								if(obj.mgt_name == originPjtNm){
			   	 									
			   	 									return obj
			   	 								} 
			   	 							} else {
			   	 								return obj
			   	 							}
			   	 						}
			   	 					}
			   	 					
			   	 				}else{
			   	 					
				   	 				if($('#txtTitle').val() != ''){
			 								var fullPjtNm = $('#txtTitle').val();
			 								var originPjtNm =fullPjtNm.substr(7);
			 						    
			 								if(obj.mgt_name == originPjtNm){
			 									
			 									return obj
			 								} 
			 							} else {
			 								return obj
			 							}
			   	 				}
								
							}			   			
			   	 		}
		   	 			
		   	 		});
		   	 	}
		   	 	
		   	 	if($('#statusSort').val() == '' && $('#empSameSort').val() == 'same' && $('#sevenDaySort').val() == ''){
			   	 	return response.list.filter(function(obj){
		   	 			
		   	 			
			   	 		if(obj.emp_name != null && obj.EP_NAME_KOR != null ){
			   	 				
			   	 			if(obj.emp_name == obj.EP_NAME_KOR ){
			   	 				
				   	 			if($('#nameSort').val() =='kyuljaeEmp'){
			   	 					if(obj.emp_name != null){
			   	 						if(obj.emp_name.indexOf($('#empName').val()) >= 0){
			   	 							
				   	 						if($('#txtTitle').val() != ''){
			   	 								var fullPjtNm = $('#txtTitle').val();
			   	 								var originPjtNm =fullPjtNm.substr(7);
			   	 						    
			   	 								if(obj.mgt_name == originPjtNm){
			   	 									
			   	 									return obj
			   	 								} 
			   	 							} else {
			   	 								return obj
			   	 							}
			   	 						}
			   	 					}
			   	 					
			   	 				}else{
			   	 					
				   	 				if($('#txtTitle').val() != ''){
			 								var fullPjtNm = $('#txtTitle').val();
			 								var originPjtNm =fullPjtNm.substr(7);
			 						    
			 								if(obj.mgt_name == originPjtNm){
			 									
			 									return obj
			 								} 
			 							} else {
			 								return obj
			 							}
			   	 				}
			   	 			}
			   	 			
								
			   	 		}
		   	 			
		   	 		});
		   	 	}
		   	 	if($('#statusSort').val() == '' && $('#empSameSort').val() == 'same' && $('#sevenDaySort').val() == 'safe'){
			   	 	return response.list.filter(function(obj){
		   	 			
			   	 		if(obj.res_date != null){
			   	 			var diffDay ;
			   	 			var resDate =obj.res_date;
			   	 			var tripDate =obj.authDate;
			   	 			
			   	 			diffDay = dayDiffCal(resDate,tripDate);
							
			   	 			if(diffDay <=7){
				   	 			if(obj.emp_name != null && obj.EP_NAME_KOR != null ){
				   	 				
					   	 			if(obj.emp_name == obj.EP_NAME_KOR ){
					   	 				
						   	 			if($('#nameSort').val() =='kyuljaeEmp'){
					   	 					if(obj.emp_name != null){
					   	 						if(obj.emp_name.indexOf($('#empName').val()) >= 0){
					   	 							
						   	 						if($('#txtTitle').val() != ''){
					   	 								var fullPjtNm = $('#txtTitle').val();
					   	 								var originPjtNm =fullPjtNm.substr(7);
					   	 						    
					   	 								if(obj.mgt_name == originPjtNm){
					   	 									
					   	 									return obj
					   	 								} 
					   	 							} else {
					   	 								return obj
					   	 							}
					   	 						}
					   	 					}
					   	 					
					   	 				}else{
					   	 					
						   	 				if($('#txtTitle').val() != ''){
			   	 								var fullPjtNm = $('#txtTitle').val();
			   	 								var originPjtNm =fullPjtNm.substr(7);
			   	 						    
			   	 								if(obj.mgt_name == originPjtNm){
			   	 									
			   	 									return obj
			   	 								} 
			   	 							} else {
			   	 								return obj
			   	 							}
					   	 				}
					   	 			}
					   	 			
										
					   	 		}
							}			   			
			   	 		}
		   	 			
		   	 		});
		   	 		
		   	 	}
		   	 	if($('#statusSort').val() == '' && $('#empSameSort').val() == 'same' && $('#sevenDaySort').val() == 'over'){
			   	 	return response.list.filter(function(obj){
		   	 			
			   	 		if(obj.res_date != null){
			   	 			var diffDay ;
			   	 			var resDate =obj.res_date;
			   	 			var tripDate =obj.authDate;
			   	 			
			   	 			diffDay = dayDiffCal(resDate,tripDate);
							
			   	 			if(diffDay >7){
				   	 			if(obj.emp_name != null && obj.EP_NAME_KOR != null ){
				   	 				
					   	 			if(obj.emp_name == obj.EP_NAME_KOR ){
					   	 				
						   	 			if($('#nameSort').val() =='kyuljaeEmp'){
					   	 					if(obj.emp_name != null){
					   	 						if(obj.emp_name.indexOf($('#empName').val()) >= 0){
					   	 							
						   	 						if($('#txtTitle').val() != ''){
					   	 								var fullPjtNm = $('#txtTitle').val();
					   	 								var originPjtNm =fullPjtNm.substr(7);
					   	 						    
					   	 								if(obj.mgt_name == originPjtNm){
					   	 									
					   	 									return obj
					   	 								} 
					   	 							} else {
					   	 								return obj
					   	 							}
					   	 						}
					   	 					}
					   	 					
					   	 				}else{
						   	 					
						   	 				if($('#txtTitle').val() != ''){
			   	 								var fullPjtNm = $('#txtTitle').val();
			   	 								var originPjtNm =fullPjtNm.substr(7);
			   	 						    
			   	 								if(obj.mgt_name == originPjtNm){
			   	 									
			   	 									return obj
			   	 								} 
			   	 							} else {
			   	 								return obj
			   	 							}
					   	 				}
					   	 			}
					   	 			
										
					   	 		}
							}			   			
			   	 		}
		   	 			
		   	 		});
		   	 	}
		   	 	if($('#statusSort').val() == '' && $('#empSameSort').val() == 'notSame' && $('#sevenDaySort').val() == ''){
			   	 	return response.list.filter(function(obj){
		   	 			
		   	 			
			   	 		if(obj.emp_name != null && obj.EP_NAME_KOR != null ){
			   	 				
			   	 			if(obj.emp_name != obj.EP_NAME_KOR ){
			   	 				
				   	 			if($('#nameSort').val() =='kyuljaeEmp'){
			   	 					if(obj.emp_name != null){
			   	 						if(obj.emp_name.indexOf($('#empName').val()) >= 0){
			   	 							
				   	 						if($('#txtTitle').val() != ''){
			   	 								var fullPjtNm = $('#txtTitle').val();
			   	 								var originPjtNm =fullPjtNm.substr(7);
			   	 						    
			   	 								if(obj.mgt_name == originPjtNm){
			   	 									
			   	 									return obj
			   	 								} 
			   	 							} else {
			   	 								return obj
			   	 							}
			   	 						}
			   	 					}
			   	 					
			   	 				}else{
			   	 					
				   	 				if($('#txtTitle').val() != ''){
			 								var fullPjtNm = $('#txtTitle').val();
			 								var originPjtNm =fullPjtNm.substr(7);
			 						    
			 								if(obj.mgt_name == originPjtNm){
			 									
			 									return obj
			 								} 
			 							} else {
			 								return obj
			 							}
			   	 				}
			   	 			}
			   	 			
								
			   	 		}
		   	 			
		   	 		});
		   	 	}
		   	 	if($('#statusSort').val() == '' && $('#empSameSort').val() == 'notSame' && $('#sevenDaySort').val() == 'safe'){
			   	 	return response.list.filter(function(obj){
		   	 			
			   	 		if(obj.res_date != null){
			   	 			var diffDay ;
			   	 			var resDate =obj.res_date;
			   	 			var tripDate =obj.authDate;
			   	 			
			   	 			diffDay = dayDiffCal(resDate,tripDate);
							
			   	 			if(diffDay <=7){
				   	 			if(obj.emp_name != null && obj.EP_NAME_KOR != null ){
				   	 				
					   	 			if(obj.emp_name != obj.EP_NAME_KOR ){
					   	 				
						   	 			if($('#nameSort').val() =='kyuljaeEmp'){
					   	 					if(obj.emp_name != null){
					   	 						if(obj.emp_name.indexOf($('#empName').val()) >= 0){
					   	 							
						   	 						if($('#txtTitle').val() != ''){
					   	 								var fullPjtNm = $('#txtTitle').val();
					   	 								var originPjtNm =fullPjtNm.substr(7);
					   	 						    
					   	 								if(obj.mgt_name == originPjtNm){
					   	 									
					   	 									return obj
					   	 								} 
					   	 							} else {
					   	 								return obj
					   	 							}
					   	 						}
					   	 					}
					   	 					
					   	 				}else{
					   	 					
						   	 				if($('#txtTitle').val() != ''){
			   	 								var fullPjtNm = $('#txtTitle').val();
			   	 								var originPjtNm =fullPjtNm.substr(7);
			   	 						    
			   	 								if(obj.mgt_name == originPjtNm){
			   	 									
			   	 									return obj
			   	 								} 
			   	 							} else {
			   	 								return obj
			   	 							}
					   	 				}
					   	 			}
					   	 			
										
					   	 		}
							}			   			
			   	 		}
		   	 			
		   	 		});
		   	 	}
		   	 	if($('#statusSort').val() == '' && $('#empSameSort').val() == 'notSame' && $('#sevenDaySort').val() == 'over'){
			   	 	return response.list.filter(function(obj){
		   	 			
			   	 		if(obj.res_date != null){
			   	 			var diffDay ;
			   	 			var resDate =obj.res_date;
			   	 			var tripDate =obj.authDate;
			   	 			
			   	 			diffDay = dayDiffCal(resDate,tripDate);
							
			   	 			if(diffDay >7){
				   	 			if(obj.emp_name != null && obj.EP_NAME_KOR != null ){
				   	 				
					   	 			if(obj.emp_name != obj.EP_NAME_KOR ){
					   	 				
						   	 			if($('#nameSort').val() =='kyuljaeEmp'){
					   	 					if(obj.emp_name != null){
					   	 						if(obj.emp_name.indexOf($('#empName').val()) >= 0){
					   	 							
						   	 						if($('#txtTitle').val() != ''){
					   	 								var fullPjtNm = $('#txtTitle').val();
					   	 								var originPjtNm =fullPjtNm.substr(7);
					   	 						    
					   	 								if(obj.mgt_name == originPjtNm){
					   	 									
					   	 									return obj
					   	 								} 
					   	 							} else {
					   	 								return obj
					   	 							}
					   	 						}
					   	 					}
					   	 					
					   	 				}else{
					   	 					
						   	 				if($('#txtTitle').val() != ''){
			   	 								var fullPjtNm = $('#txtTitle').val();
			   	 								var originPjtNm =fullPjtNm.substr(7);
			   	 						    
			   	 								if(obj.mgt_name == originPjtNm){
			   	 									
			   	 									return obj
			   	 								} 
			   	 							} else {
			   	 								return obj
			   	 							}
					   	 				}
					   	 			}
					   	 			
										
					   	 		}
							}			   			
			   	 		}
		   	 			
		   	 		});
		   	 	}
		   	 	if($('#statusSort').val() == 'no' && $('#empSameSort').val() == '' && $('#sevenDaySort').val() == ''){
			   	 	return response.list.filter(function(obj){
		   	 			
			   	 		if(obj.res_date == null){
							
			   	 			if($('#nameSort').val() =='kyuljaeEmp'){
		   	 					if(obj.emp_name != null){
		   	 						if(obj.emp_name.indexOf($('#empName').val()) >= 0){
		   	 							
			   	 						if($('#txtTitle').val() != ''){
		   	 								var fullPjtNm = $('#txtTitle').val();
		   	 								var originPjtNm =fullPjtNm.substr(7);
		   	 						    
		   	 								if(obj.mgt_name == originPjtNm){
		   	 									
		   	 									return obj
		   	 								} 
		   	 							} else {
		   	 								return obj
		   	 							}
		   	 						}
		   	 					}
		   	 					
		   	 				}else{
		   	 					
			   	 				if($('#txtTitle').val() != ''){
										var fullPjtNm = $('#txtTitle').val();
										var originPjtNm =fullPjtNm.substr(7);
								    
										if(obj.mgt_name == originPjtNm){
											
											return obj
										} 
									} else {
										return obj
									}
		   	 				}
			   	 		}
		   	 			
	   	 			});
		   	 	}
		   	 	if($('#statusSort').val() == 'no' && $('#empSameSort').val() == '' && $('#sevenDaySort').val() == 'safe'){
			   	 	return response.list.filter(function(obj){
		   	 			
			   	 		if(obj.res_date == null){
							
			   	 			if($('#nameSort').val() =='kyuljaeEmp'){
		   	 					if(obj.emp_name != null){
		   	 						if(obj.emp_name.indexOf($('#empName').val()) >= 0){
		   	 							
			   	 						if($('#txtTitle').val() != ''){
		   	 								var fullPjtNm = $('#txtTitle').val();
		   	 								var originPjtNm =fullPjtNm.substr(7);
		   	 						    
		   	 								if(obj.mgt_name == originPjtNm){
		   	 									
		   	 									return obj
		   	 								} 
		   	 							} else {
		   	 								return obj
		   	 							}
		   	 						}
		   	 					}
		   	 					
		   	 				}else{
		   	 					
			   	 				if($('#txtTitle').val() != ''){
										var fullPjtNm = $('#txtTitle').val();
										var originPjtNm =fullPjtNm.substr(7);
								    
										if(obj.mgt_name == originPjtNm){
											
											return obj
										} 
									} else {
										return obj
									}
		   	 				}
			   	 		}
		   	 			
	   	 			});
		   	 	
		   	 	}
		   	 	if($('#statusSort').val() == 'no' && $('#empSameSort').val() == '' && $('#sevenDaySort').val() == 'over'){
			   	 	return response.list.filter(function(obj){
		   	 			
			   	 		if(obj.res_date == null){
							
			   	 			if($('#nameSort').val() =='kyuljaeEmp'){
		   	 					if(obj.emp_name != null){
		   	 						if(obj.emp_name.indexOf($('#empName').val()) >= 0){
		   	 							
			   	 						if($('#txtTitle').val() != ''){
		   	 								var fullPjtNm = $('#txtTitle').val();
		   	 								var originPjtNm =fullPjtNm.substr(7);
		   	 						    
		   	 								if(obj.mgt_name == originPjtNm){
		   	 									
		   	 									return obj
		   	 								} 
		   	 							} else {
		   	 								return obj
		   	 							}
		   	 						}
		   	 					}
		   	 					
		   	 				}else{
		   	 					
			   	 				if($('#txtTitle').val() != ''){
										var fullPjtNm = $('#txtTitle').val();
										var originPjtNm =fullPjtNm.substr(7);
								    
										if(obj.mgt_name == originPjtNm){
											
											return obj
										} 
									} else {
										return obj
									}
		   	 				}
			   	 		}
		   	 			
		 			});
		   	 	}
		   	 	if($('#statusSort').val() == 'no' && $('#empSameSort').val() == 'same' && $('#sevenDaySort').val() == ''){
			   	 	return response.list.filter(function(obj){
		   	 			
			   	 		if(obj.res_date == null){
							
			   	 			if($('#nameSort').val() =='kyuljaeEmp'){
		   	 					if(obj.emp_name != null){
		   	 						if(obj.emp_name.indexOf($('#empName').val()) >= 0){
		   	 							
			   	 						if($('#txtTitle').val() != ''){
		   	 								var fullPjtNm = $('#txtTitle').val();
		   	 								var originPjtNm =fullPjtNm.substr(7);
		   	 						    
		   	 								if(obj.mgt_name == originPjtNm){
		   	 									
		   	 									return obj
		   	 								} 
		   	 							} else {
		   	 								return obj
		   	 							}
		   	 						}
		   	 					}
		   	 					
		   	 				}else{
		   	 					
			   	 				if($('#txtTitle').val() != ''){
										var fullPjtNm = $('#txtTitle').val();
										var originPjtNm =fullPjtNm.substr(7);
								    
										if(obj.mgt_name == originPjtNm){
											
											return obj
										} 
									} else {
										return obj
									}
		   	 				}
			   	 		}
		   	 			
		 			});
		   	 	}
		   	 	if($('#statusSort').val() == 'no' && $('#empSameSort').val() == 'same' && $('#sevenDaySort').val() == 'safe'){
			   	 	return response.list.filter(function(obj){
		   	 			
			   	 		if(obj.res_date == null){
							
			   	 			if($('#nameSort').val() =='kyuljaeEmp'){
		   	 					if(obj.emp_name != null){
		   	 						if(obj.emp_name.indexOf($('#empName').val()) >= 0){
		   	 							
			   	 						if($('#txtTitle').val() != ''){
		   	 								var fullPjtNm = $('#txtTitle').val();
		   	 								var originPjtNm =fullPjtNm.substr(7);
		   	 						    
		   	 								if(obj.mgt_name == originPjtNm){
		   	 									
		   	 									return obj
		   	 								} 
		   	 							} else {
		   	 								return obj
		   	 							}
		   	 						}
		   	 					}
		   	 					
		   	 				}else{
		   	 					
			   	 				if($('#txtTitle').val() != ''){
										var fullPjtNm = $('#txtTitle').val();
										var originPjtNm =fullPjtNm.substr(7);
								    
										if(obj.mgt_name == originPjtNm){
											
											return obj
										} 
									} else {
										return obj
									}
		   	 				}
			   	 		}
		   	 			
		 			});
		   	 	}
		   	 	if($('#statusSort').val() == 'no' && $('#empSameSort').val() == 'same' && $('#sevenDaySort').val() == 'over'){
			   	 	return response.list.filter(function(obj){
		   	 			
			   	 		if(obj.res_date == null){
							
			   	 			if($('#nameSort').val() =='kyuljaeEmp'){
		   	 					if(obj.emp_name != null){
		   	 						if(obj.emp_name.indexOf($('#empName').val()) >= 0){
		   	 							
			   	 						if($('#txtTitle').val() != ''){
		   	 								var fullPjtNm = $('#txtTitle').val();
		   	 								var originPjtNm =fullPjtNm.substr(7);
		   	 						    
		   	 								if(obj.mgt_name == originPjtNm){
		   	 									
		   	 									return obj
		   	 								} 
		   	 							} else {
		   	 								return obj
		   	 							}
		   	 						}
		   	 					}
		   	 					
		   	 				}else{
		   	 					
			   	 				if($('#txtTitle').val() != ''){
										var fullPjtNm = $('#txtTitle').val();
										var originPjtNm =fullPjtNm.substr(7);
								    
										if(obj.mgt_name == originPjtNm){
											
											return obj
										} 
									} else {
										return obj
									}
		   	 				}
			   	 		}
		   	 			
		 			});
		   	 	}
		   	 	if($('#statusSort').val() == 'no' && $('#empSameSort').val() == 'notSame' && $('#sevenDaySort').val() == ''){
			   	 	return response.list.filter(function(obj){
		   	 			
			   	 		if(obj.res_date == null){
							
			   	 			if($('#nameSort').val() =='kyuljaeEmp'){
		   	 					if(obj.emp_name != null){
		   	 						if(obj.emp_name.indexOf($('#empName').val()) >= 0){
		   	 							
			   	 						if($('#txtTitle').val() != ''){
		   	 								var fullPjtNm = $('#txtTitle').val();
		   	 								var originPjtNm =fullPjtNm.substr(7);
		   	 						    
		   	 								if(obj.mgt_name == originPjtNm){
		   	 									
		   	 									return obj
		   	 								} 
		   	 							} else {
		   	 								return obj
		   	 							}
		   	 						}
		   	 					}
		   	 					
		   	 				}else{
			   	 					
			   	 				if($('#txtTitle').val() != ''){
										var fullPjtNm = $('#txtTitle').val();
										var originPjtNm =fullPjtNm.substr(7);
								    
										if(obj.mgt_name == originPjtNm){
											
											return obj
										} 
									} else {
										return obj
									}
		   	 				}
			   	 		}
		   	 			
		 			});
		   	 	}
		   	 	if($('#statusSort').val() == 'no' && $('#empSameSort').val() == 'notSame' && $('#sevenDaySort').val() == 'safe'){
			   	 	return response.list.filter(function(obj){
		   	 			
			   	 		if(obj.res_date == null){
							
			   	 			if($('#nameSort').val() =='kyuljaeEmp'){
		   	 					if(obj.emp_name != null){
		   	 						if(obj.emp_name.indexOf($('#empName').val()) >= 0){
		   	 							
			   	 						if($('#txtTitle').val() != ''){
		   	 								var fullPjtNm = $('#txtTitle').val();
		   	 								var originPjtNm =fullPjtNm.substr(7);
		   	 						    
		   	 								if(obj.mgt_name == originPjtNm){
		   	 									
		   	 									return obj
		   	 								} 
		   	 							} else {
		   	 								return obj
		   	 							}
		   	 						}
		   	 					}
		   	 					
		   	 				}else{
			   	 					
			   	 				if($('#txtTitle').val() != ''){
										var fullPjtNm = $('#txtTitle').val();
										var originPjtNm =fullPjtNm.substr(7);
								    
										if(obj.mgt_name == originPjtNm){
											
											return obj
										} 
									} else {
										return obj
									}
		   	 				}
			   	 		}
		   	 			
		 			});
		   	 	}
		   	 	if($('#statusSort').val() == 'no' && $('#empSameSort').val() == 'notSame' && $('#sevenDaySort').val() == 'over'){
			   	 	return response.list.filter(function(obj){
		   	 			
			   	 		if(obj.res_date == null){
							
			   	 			if($('#nameSort').val() =='kyuljaeEmp'){
		   	 					if(obj.emp_name != null){
		   	 						if(obj.emp_name.indexOf($('#empName').val()) >= 0){
			   	 							
			   	 						if($('#txtTitle').val() != ''){
		   	 								var fullPjtNm = $('#txtTitle').val();
		   	 								var originPjtNm =fullPjtNm.substr(7);
		   	 						    
		   	 								if(obj.mgt_name == originPjtNm){
		   	 									
		   	 									return obj
		   	 								} 
		   	 							} else {
		   	 								return obj
		   	 							}
		   	 						}
		   	 					}
		   	 					
		   	 				}else{
		   	 					
			   	 				if($('#txtTitle').val() != ''){
										var fullPjtNm = $('#txtTitle').val();
										var originPjtNm =fullPjtNm.substr(7);
								    
										if(obj.mgt_name == originPjtNm){
											
											return obj
										} 
									} else {
										return obj
									}
		   	 				}
			   	 		}
		   	 			
		 			});
		   	 	}
		   	 	if($('#statusSort').val() == 'half' && $('#empSameSort').val() == '' && $('#sevenDaySort').val() == ''){
			   	 	return response.list.filter(function(obj){
		   	 			
			   	 		if(obj.res_date != null && obj.c_ridocfullnum == null){
							
			   	 			if($('#nameSort').val() =='kyuljaeEmp'){
		   	 					if(obj.emp_name != null){
		   	 						if(obj.emp_name.indexOf($('#empName').val()) >= 0){
		   	 							
			   	 						if($('#txtTitle').val() != ''){
		   	 								var fullPjtNm = $('#txtTitle').val();
		   	 								var originPjtNm =fullPjtNm.substr(7);
		   	 						    
		   	 								if(obj.mgt_name == originPjtNm){
		   	 									
		   	 									return obj
		   	 								} 
		   	 							} else {
		   	 								return obj
		   	 							}
		   	 						}
		   	 					}
		   	 					
		   	 				}else{
		   	 					
			   	 				if($('#txtTitle').val() != ''){
										var fullPjtNm = $('#txtTitle').val();
										var originPjtNm =fullPjtNm.substr(7);
								    
										if(obj.mgt_name == originPjtNm){
											
											return obj
										} 
									} else {
										return obj
									}
		   	 				}
			   	 		}
		   	 			
		 			});
		   	 	}
		   	 	if($('#statusSort').val() == 'half' && $('#empSameSort').val() == '' && $('#sevenDaySort').val() == 'safe'){
			   	 	return response.list.filter(function(obj){
		   	 			
			   	 		if(obj.res_date != null && obj.c_ridocfullnum == null){
							
				   	 		var diffDay ;
			   	 			var resDate =obj.res_date;
			   	 			var tripDate =obj.authDate;
			   	 			
			   	 			diffDay = dayDiffCal(resDate,tripDate);
							
			   	 			if(diffDay <=7){
				   	 			if($('#nameSort').val() =='kyuljaeEmp'){
			   	 					if(obj.emp_name != null){
			   	 						if(obj.emp_name.indexOf($('#empName').val()) >= 0){
				   	 							
				   	 						if($('#txtTitle').val() != ''){
			   	 								var fullPjtNm = $('#txtTitle').val();
			   	 								var originPjtNm =fullPjtNm.substr(7);
			   	 						    
			   	 								if(obj.mgt_name == originPjtNm){
			   	 									
			   	 									return obj
			   	 								} 
			   	 							} else {
			   	 								return obj
			   	 							}
			   	 						}
			   	 					}
			   	 					
			   	 				}else{
				   	 					
				   	 				if($('#txtTitle').val() != ''){
			 								var fullPjtNm = $('#txtTitle').val();
			 								var originPjtNm =fullPjtNm.substr(7);
			 						    
			 								if(obj.mgt_name == originPjtNm){
			 									
			 									return obj
			 								} 
			 							} else {
			 								return obj
			 							}
			   	 				}
							}	
			   	 		}
		   	 			
		 			});
		   	 	}
		   	 	if($('#statusSort').val() == 'half' && $('#empSameSort').val() == '' && $('#sevenDaySort').val() == 'over'){
			   	 	return response.list.filter(function(obj){
		   	 			
			   	 		if(obj.res_date != null && obj.c_ridocfullnum == null){
							
				   	 		var diffDay ;
			   	 			var resDate =obj.res_date;
			   	 			var tripDate =obj.authDate;
			   	 			
			   	 			diffDay = dayDiffCal(resDate,tripDate);
							
			   	 			if(diffDay > 7){
				   	 			if($('#nameSort').val() =='kyuljaeEmp'){
			   	 					if(obj.emp_name != null){
			   	 						if(obj.emp_name.indexOf($('#empName').val()) >= 0){
			   	 							
				   	 						if($('#txtTitle').val() != ''){
			   	 								var fullPjtNm = $('#txtTitle').val();
			   	 								var originPjtNm =fullPjtNm.substr(7);
			   	 						    
			   	 								if(obj.mgt_name == originPjtNm){
			   	 									
			   	 									return obj
			   	 								} 
			   	 							} else {
			   	 								return obj
			   	 							}
			   	 						}
			   	 					}
			   	 					
			   	 				}else{
			   	 					
				   	 				if($('#txtTitle').val() != ''){
			 								var fullPjtNm = $('#txtTitle').val();
			 								var originPjtNm =fullPjtNm.substr(7);
			 						    
			 								if(obj.mgt_name == originPjtNm){
			 									
			 									return obj
			 								} 
			 							} else {
			 								return obj
			 							}
			   	 				}
							}	
			   	 		}
		   	 			
		 			});
		   	 		
		   	 	}
		   	 	if($('#statusSort').val() == 'half' && $('#empSameSort').val() == 'same' && $('#sevenDaySort').val() == ''){
			   	 	return response.list.filter(function(obj){
		   	 			
			   	 		if(obj.res_date != null && obj.c_ridocfullnum == null){
							
				   	 			if(obj.emp_name != null && obj.EP_NAME_KOR != null ){
				   	 				
					   	 			if(obj.emp_name == obj.EP_NAME_KOR ){
					   	 				
						   	 			if($('#nameSort').val() =='kyuljaeEmp'){
					   	 					if(obj.emp_name != null){
					   	 						if(obj.emp_name.indexOf($('#empName').val()) >= 0){
					   	 							
						   	 						if($('#txtTitle').val() != ''){
					   	 								var fullPjtNm = $('#txtTitle').val();
					   	 								var originPjtNm =fullPjtNm.substr(7);
					   	 						    
					   	 								if(obj.mgt_name == originPjtNm){
					   	 									
					   	 									return obj
					   	 								} 
					   	 							} else {
					   	 								return obj
					   	 							}
					   	 						}
					   	 					}
					   	 					
					   	 				}else{
					   	 					
						   	 				if($('#txtTitle').val() != ''){
			   	 								var fullPjtNm = $('#txtTitle').val();
			   	 								var originPjtNm =fullPjtNm.substr(7);
			   	 						    
			   	 								if(obj.mgt_name == originPjtNm){
			   	 									
			   	 									return obj
			   	 								} 
			   	 							} else {
			   	 								return obj
			   	 							}
					   	 				}
					   	 			}
					   	 			
										
					   	 		}
			   	 		}
		   	 			
		 			});
		   	 	}
		   	 	if($('#statusSort').val() == 'half' && $('#empSameSort').val() == 'same' && $('#sevenDaySort').val() == 'safe'){
			   	 	return response.list.filter(function(obj){
		   	 			
			   	 		if(obj.res_date != null && obj.c_ridocfullnum == null){
							
				   	 			if(obj.emp_name != null && obj.EP_NAME_KOR != null ){
				   	 				
					   	 			var diffDay ;
					   	 			var resDate =obj.res_date;
					   	 			var tripDate =obj.authDate;
					   	 			
					   	 			diffDay = dayDiffCal(resDate,tripDate);
									
					   	 			if(diffDay <= 7){
						   	 			if(obj.emp_name == obj.EP_NAME_KOR ){
						   	 				
							   	 			if($('#nameSort').val() =='kyuljaeEmp'){
						   	 					if(obj.emp_name != null){
						   	 						if(obj.emp_name.indexOf($('#empName').val()) >= 0){
						   	 							
							   	 						if($('#txtTitle').val() != ''){
						   	 								var fullPjtNm = $('#txtTitle').val();
						   	 								var originPjtNm =fullPjtNm.substr(7);
						   	 						    
						   	 								if(obj.mgt_name == originPjtNm){
						   	 									
						   	 									return obj
						   	 								} 
						   	 							} else {
						   	 								return obj
						   	 							}
						   	 						}
						   	 					}
						   	 					
						   	 				}else{
						   	 					
							   	 				if($('#txtTitle').val() != ''){
				   	 								var fullPjtNm = $('#txtTitle').val();
				   	 								var originPjtNm =fullPjtNm.substr(7);
				   	 						    
				   	 								if(obj.mgt_name == originPjtNm){
				   	 									
				   	 									return obj
				   	 								} 
				   	 							} else {
				   	 								return obj
				   	 							}
						   	 				}
						   	 			}
									}	
										
					   	 		}
			   	 		}
		   	 			
		 			});
		   	 	}
		   	 	if($('#statusSort').val() == 'half' && $('#empSameSort').val() == 'same' && $('#sevenDaySort').val() == 'over'){
			   	 	return response.list.filter(function(obj){
		   	 			
			   	 		if(obj.res_date != null && obj.c_ridocfullnum == null){
							
				   	 			if(obj.emp_name != null && obj.EP_NAME_KOR != null ){
				   	 				
					   	 			var diffDay ;
					   	 			var resDate =obj.res_date;
					   	 			var tripDate =obj.authDate;
					   	 			
					   	 			diffDay = dayDiffCal(resDate,tripDate);
									
					   	 			if(diffDay > 7){
						   	 			if(obj.emp_name == obj.EP_NAME_KOR ){
						   	 				
							   	 			if($('#nameSort').val() =='kyuljaeEmp'){
						   	 					if(obj.emp_name != null){
						   	 						if(obj.emp_name.indexOf($('#empName').val()) >= 0){
						   	 							
							   	 						if($('#txtTitle').val() != ''){
						   	 								var fullPjtNm = $('#txtTitle').val();
						   	 								var originPjtNm =fullPjtNm.substr(7);
						   	 						    
						   	 								if(obj.mgt_name == originPjtNm){
						   	 									
						   	 									return obj
						   	 								} 
						   	 							} else {
						   	 								return obj
						   	 							}
						   	 						}
						   	 					}
						   	 					
						   	 				}else{
						   	 					
							   	 				if($('#txtTitle').val() != ''){
				   	 								var fullPjtNm = $('#txtTitle').val();
				   	 								var originPjtNm =fullPjtNm.substr(7);
				   	 						    
				   	 								if(obj.mgt_name == originPjtNm){
				   	 									
				   	 									return obj
				   	 								} 
				   	 							} else {
				   	 								return obj
				   	 							}
						   	 				}
						   	 			}
									}	
										
					   	 		}
			   	 		}
		   	 			
		 			});
		   	 		
		   	 	}
		   	 	if($('#statusSort').val() == 'half' && $('#empSameSort').val() == 'notSame' && $('#sevenDaySort').val() == ''){
			   	 	return response.list.filter(function(obj){
		   	 			
			   	 		if(obj.res_date != null && obj.c_ridocfullnum == null){
							
				   	 			if(obj.emp_name != null && obj.EP_NAME_KOR != null ){
				   	 				
					   	 			if(obj.emp_name != obj.EP_NAME_KOR ){
					   	 				
						   	 			if($('#nameSort').val() =='kyuljaeEmp'){
					   	 					if(obj.emp_name != null){
					   	 						if(obj.emp_name.indexOf($('#empName').val()) >= 0){
					   	 							
						   	 						if($('#txtTitle').val() != ''){
					   	 								var fullPjtNm = $('#txtTitle').val();
					   	 								var originPjtNm =fullPjtNm.substr(7);
					   	 						    
					   	 								if(obj.mgt_name == originPjtNm){
					   	 									
					   	 									return obj
					   	 								} 
					   	 							} else {
					   	 								return obj
					   	 							}
					   	 						}
					   	 					}
					   	 					
					   	 				}else{
					   	 					
						   	 				if($('#txtTitle').val() != ''){
			   	 								var fullPjtNm = $('#txtTitle').val();
			   	 								var originPjtNm =fullPjtNm.substr(7);
			   	 						    
			   	 								if(obj.mgt_name == originPjtNm){
			   	 									
			   	 									return obj
			   	 								} 
			   	 							} else {
			   	 								return obj
			   	 							}
					   	 				}
					   	 			}
										
					   	 		}
			   	 		}
		   	 			
		 			});
		   	 	}
		   	 	if($('#statusSort').val() == 'half' && $('#empSameSort').val() == 'notSame' && $('#sevenDaySort').val() == 'safe'){
			   	 	return response.list.filter(function(obj){
		   	 			
			   	 		if(obj.res_date != null && obj.c_ridocfullnum == null){
							
				   	 			if(obj.emp_name != null && obj.EP_NAME_KOR != null ){
				   	 				
					   	 			var diffDay ;
					   	 			var resDate =obj.res_date;
					   	 			var tripDate =obj.authDate;
					   	 			
					   	 			diffDay = dayDiffCal(resDate,tripDate);
									
					   	 			if(diffDay <= 7){
						   	 			if(obj.emp_name != obj.EP_NAME_KOR ){
						   	 				
							   	 			if($('#nameSort').val() =='kyuljaeEmp'){
						   	 					if(obj.emp_name != null){
						   	 						if(obj.emp_name.indexOf($('#empName').val()) >= 0){
						   	 							
							   	 						if($('#txtTitle').val() != ''){
						   	 								var fullPjtNm = $('#txtTitle').val();
						   	 								var originPjtNm =fullPjtNm.substr(7);
						   	 						    
						   	 								if(obj.mgt_name == originPjtNm){
						   	 									
						   	 									return obj
						   	 								} 
						   	 							} else {
						   	 								return obj
						   	 							}
						   	 						}
						   	 					}
						   	 					
						   	 				}else{
						   	 					
							   	 				if($('#txtTitle').val() != ''){
				   	 								var fullPjtNm = $('#txtTitle').val();
				   	 								var originPjtNm =fullPjtNm.substr(7);
				   	 						    
				   	 								if(obj.mgt_name == originPjtNm){
				   	 									
				   	 									return obj
				   	 								} 
				   	 							} else {
				   	 								return obj
				   	 							}
						   	 				}
						   	 			}
									}	
										
					   	 		}
			   	 		}
		   	 			
		 			});
		   	 	}
		   	 	if($('#statusSort').val() == 'half' && $('#empSameSort').val() == 'notSame' && $('#sevenDaySort').val() == 'over'){
			   	 	return response.list.filter(function(obj){
		   	 			
			   	 		if(obj.res_date != null && obj.c_ridocfullnum == null){
							
				   	 			if(obj.emp_name != null && obj.EP_NAME_KOR != null ){
				   	 				
					   	 			var diffDay ;
					   	 			var resDate =obj.res_date;
					   	 			var tripDate =obj.authDate;
					   	 			
					   	 			diffDay = dayDiffCal(resDate,tripDate);
									
					   	 			if(diffDay > 7){
						   	 			if(obj.emp_name != obj.EP_NAME_KOR ){
						   	 				
							   	 			if($('#nameSort').val() =='kyuljaeEmp'){
						   	 					if(obj.emp_name != null){
						   	 						if(obj.emp_name.indexOf($('#empName').val()) >= 0){
						   	 							
							   	 						if($('#txtTitle').val() != ''){
						   	 								var fullPjtNm = $('#txtTitle').val();
						   	 								var originPjtNm =fullPjtNm.substr(7);
						   	 						    
						   	 								if(obj.mgt_name == originPjtNm){
						   	 									
						   	 									return obj
						   	 								} 
						   	 							} else {
						   	 								return obj
						   	 							}
						   	 						}
						   	 					}
						   	 					
						   	 				}else{
						   	 					
							   	 				if($('#txtTitle').val() != ''){
				   	 								var fullPjtNm = $('#txtTitle').val();
				   	 								var originPjtNm =fullPjtNm.substr(7);
				   	 						    
				   	 								if(obj.mgt_name == originPjtNm){
				   	 									
				   	 									return obj
				   	 								} 
				   	 							} else {
				   	 								return obj
				   	 							}
						   	 				}
						   	 			}
									}	
										
					   	 		}
			   	 		}
		   	 			
		 			});
		   	 	}
		   	 	if($('#statusSort').val() == 'finish' && $('#empSameSort').val() == '' && $('#sevenDaySort').val() == ''){
			   	 	return response.list.filter(function(obj){
		   	 			
			   	 		if(obj.res_date != null && obj.c_ridocfullnum != null){
							
			   	 			if($('#nameSort').val() =='kyuljaeEmp'){
		   	 					if(obj.emp_name != null){
		   	 						if(obj.emp_name.indexOf($('#empName').val()) >= 0){
		   	 							
			   	 						if($('#txtTitle').val() != ''){
		   	 								var fullPjtNm = $('#txtTitle').val();
		   	 								var originPjtNm =fullPjtNm.substr(7);
		   	 						    
		   	 								if(obj.mgt_name == originPjtNm){
		   	 									
		   	 									return obj
		   	 								} 
		   	 							} else {
		   	 								return obj
		   	 							}
		   	 						}
		   	 					}
		   	 					
		   	 				}else{
		   	 					
			   	 				if($('#txtTitle').val() != ''){
										var fullPjtNm = $('#txtTitle').val();
										var originPjtNm =fullPjtNm.substr(7);
								    
										if(obj.mgt_name == originPjtNm){
											
											return obj
										} 
									} else {
										return obj
									}
		   	 				}
			   	 		}
		   	 			
		 			});
		   	 	}
		   	 	if($('#statusSort').val() == 'finish' && $('#empSameSort').val() == '' && $('#sevenDaySort').val() == 'safe'){
			   	 	return response.list.filter(function(obj){
		   	 			
			   	 		if(obj.res_date != null && obj.c_ridocfullnum != null){
			   	 				
				   	 			var diffDay ;
				   	 			var resDate =obj.res_date;
				   	 			var tripDate =obj.authDate;
				   	 			
				   	 			diffDay = dayDiffCal(resDate,tripDate);
								
				   	 			if(diffDay <= 7){
					   	 				
					   	 			if($('#nameSort').val() =='kyuljaeEmp'){
				   	 					if(obj.emp_name != null){
				   	 						if(obj.emp_name.indexOf($('#empName').val()) >= 0){
				   	 							
					   	 						if($('#txtTitle').val() != ''){
				   	 								var fullPjtNm = $('#txtTitle').val();
				   	 								var originPjtNm =fullPjtNm.substr(7);
				   	 						    
				   	 								if(obj.mgt_name == originPjtNm){
				   	 									
				   	 									return obj
				   	 								} 
				   	 							} else {
				   	 								return obj
				   	 							}
				   	 						}
				   	 					}
				   	 					
				   	 				}else{
					   	 					
					   	 				if($('#txtTitle').val() != ''){
		   	 								var fullPjtNm = $('#txtTitle').val();
		   	 								var originPjtNm =fullPjtNm.substr(7);
		   	 						    
		   	 								if(obj.mgt_name == originPjtNm){
		   	 									
		   	 									return obj
		   	 								} 
		   	 							} else {
		   	 								return obj
		   	 							}
				   	 				}
								}	
									
			   	 		}
		   	 			
		 			});
		   	 		
		   	 	}
		   	 	if($('#statusSort').val() == 'finish' && $('#empSameSort').val() == '' && $('#sevenDaySort').val() == 'over'){
			   	 	return response.list.filter(function(obj){
		   	 			
			   	 		if(obj.res_date != null && obj.c_ridocfullnum != null){
			   	 				
				   	 			var diffDay ;
				   	 			var resDate =obj.res_date;
				   	 			var tripDate =obj.authDate;
				   	 			
				   	 			diffDay = dayDiffCal(resDate,tripDate);
								
				   	 			if(diffDay > 7){
					   	 				
					   	 			if($('#nameSort').val() =='kyuljaeEmp'){
				   	 					if(obj.emp_name != null){
				   	 						if(obj.emp_name.indexOf($('#empName').val()) >= 0){
				   	 							
					   	 						if($('#txtTitle').val() != ''){
				   	 								var fullPjtNm = $('#txtTitle').val();
				   	 								var originPjtNm =fullPjtNm.substr(7);
				   	 						    
				   	 								if(obj.mgt_name == originPjtNm){
				   	 									
				   	 									return obj
				   	 								} 
				   	 							} else {
				   	 								return obj
				   	 							}
				   	 						}
				   	 					}
				   	 					
				   	 				}else{
				   	 					
					   	 				if($('#txtTitle').val() != ''){
		   	 								var fullPjtNm = $('#txtTitle').val();
		   	 								var originPjtNm =fullPjtNm.substr(7);
		   	 						    
		   	 								if(obj.mgt_name == originPjtNm){
		   	 									
		   	 									return obj
		   	 								} 
		   	 							} else {
		   	 								return obj
		   	 							}
				   	 				}
								}	
									
			   	 		}
		   	 			
		 			});
		   	 	}
		   	 	if($('#statusSort').val() == 'finish' && $('#empSameSort').val() == 'same' && $('#sevenDaySort').val() == ''){
			   	 	return response.list.filter(function(obj){
		   	 			
			   	 		if(obj.res_date != null && obj.c_ridocfullnum != null){
				   	 		if(obj.emp_name != null && obj.EP_NAME_KOR != null ){
		   	 				
				   	 			if(obj.emp_name == obj.EP_NAME_KOR ){
				   	 				
					   	 			if($('#nameSort').val() =='kyuljaeEmp'){
				   	 					if(obj.emp_name != null){
				   	 						if(obj.emp_name.indexOf($('#empName').val()) >= 0){
				   	 							
					   	 						if($('#txtTitle').val() != ''){
				   	 								var fullPjtNm = $('#txtTitle').val();
				   	 								var originPjtNm =fullPjtNm.substr(7);
				   	 						    
				   	 								if(obj.mgt_name == originPjtNm){
				   	 									
				   	 									return obj
				   	 								} 
				   	 							} else {
				   	 								return obj
				   	 							}
				   	 						}
				   	 					}
				   	 					
				   	 				}else{
				   	 					
					   	 				if($('#txtTitle').val() != ''){
		   	 								var fullPjtNm = $('#txtTitle').val();
		   	 								var originPjtNm =fullPjtNm.substr(7);
		   	 						    
		   	 								if(obj.mgt_name == originPjtNm){
		   	 									
		   	 									return obj
		   	 								} 
		   	 							} else {
		   	 								return obj
		   	 							}
				   	 				}
				   	 			}
								
				   	 		}	
									
			   	 		}
		   	 			
		 			});
		   	 	}
		   	 	if($('#statusSort').val() == 'finish' && $('#empSameSort').val() == 'same' && $('#sevenDaySort').val() == 'safe'){
			   	 	return response.list.filter(function(obj){
		   	 			
			   	 		if(obj.res_date != null && obj.c_ridocfullnum != null){
				   	 		if(obj.emp_name != null && obj.EP_NAME_KOR != null ){
		   	 				
					   	 		var diffDay ;
				   	 			var resDate =obj.res_date;
				   	 			var tripDate =obj.authDate;
				   	 			
				   	 			diffDay = dayDiffCal(resDate,tripDate);
								
				   	 			if(diffDay <= 7){
					   	 				
									if(obj.emp_name == obj.EP_NAME_KOR ){
					   	 				
						   	 			if($('#nameSort').val() =='kyuljaeEmp'){
					   	 					if(obj.emp_name != null){
					   	 						if(obj.emp_name.indexOf($('#empName').val()) >= 0){
					   	 							
						   	 						if($('#txtTitle').val() != ''){
					   	 								var fullPjtNm = $('#txtTitle').val();
					   	 								var originPjtNm =fullPjtNm.substr(7);
					   	 						    
					   	 								if(obj.mgt_name == originPjtNm){
					   	 									
					   	 									return obj
					   	 								} 
					   	 							} else {
					   	 								return obj
					   	 							}
					   	 						}
					   	 					}
					   	 					
					   	 				}else{
					   	 					
						   	 				if($('#txtTitle').val() != ''){
			   	 								var fullPjtNm = $('#txtTitle').val();
			   	 								var originPjtNm =fullPjtNm.substr(7);
			   	 						    
			   	 								if(obj.mgt_name == originPjtNm){
			   	 									
			   	 									return obj
			   	 								} 
			   	 							} else {
			   	 								return obj
			   	 							}
					   	 				}
					   	 			}
								}	
				   	 			
								
				   	 		}	
									
			   	 		}
		   	 			
		 			});
		   	 		
		   	 	}
		   	 	if($('#statusSort').val() == 'finish' && $('#empSameSort').val() == 'same' && $('#sevenDaySort').val() == 'over'){
			   	 	return response.list.filter(function(obj){
		   	 			
			   	 		if(obj.res_date != null && obj.c_ridocfullnum != null){
				   	 		if(obj.emp_name != null && obj.EP_NAME_KOR != null ){
		   	 				
					   	 		var diffDay ;
				   	 			var resDate =obj.res_date;
				   	 			var tripDate =obj.authDate;
				   	 			
				   	 			diffDay = dayDiffCal(resDate,tripDate);
								
				   	 			if(diffDay > 7){
					   	 				
									if(obj.emp_name == obj.EP_NAME_KOR ){
					   	 				
						   	 			if($('#nameSort').val() =='kyuljaeEmp'){
					   	 					if(obj.emp_name != null){
					   	 						if(obj.emp_name.indexOf($('#empName').val()) >= 0){
					   	 							
						   	 						if($('#txtTitle').val() != ''){
					   	 								var fullPjtNm = $('#txtTitle').val();
					   	 								var originPjtNm =fullPjtNm.substr(7);
					   	 						    
					   	 								if(obj.mgt_name == originPjtNm){
					   	 									
					   	 									return obj
					   	 								} 
					   	 							} else {
					   	 								return obj
					   	 							}
					   	 						}
					   	 					}
					   	 					
					   	 				}else{
					   	 					
						   	 				if($('#txtTitle').val() != ''){
			   	 								var fullPjtNm = $('#txtTitle').val();
			   	 								var originPjtNm =fullPjtNm.substr(7);
			   	 						    
			   	 								if(obj.mgt_name == originPjtNm){
			   	 									
			   	 									return obj
			   	 								} 
			   	 							} else {
			   	 								return obj
			   	 							}
					   	 				}
					   	 			}
								}	
								
				   	 		}	
									
			   	 		}
		   	 			
		 			});
		   	 		
		   	 	}
		   	 	if($('#statusSort').val() == 'finish' && $('#empSameSort').val() == 'notSame' && $('#sevenDaySort').val() == ''){
			   	 	return response.list.filter(function(obj){
		   	 			
			   	 		if(obj.res_date != null && obj.c_ridocfullnum != null){
				   	 		if(obj.emp_name != null && obj.EP_NAME_KOR != null ){
		   	 				
				   	 			if(obj.emp_name != obj.EP_NAME_KOR ){
				   	 				
					   	 			if($('#nameSort').val() =='kyuljaeEmp'){
				   	 					if(obj.emp_name != null){
				   	 						if(obj.emp_name.indexOf($('#empName').val()) >= 0){
				   	 							
					   	 						if($('#txtTitle').val() != ''){
				   	 								var fullPjtNm = $('#txtTitle').val();
				   	 								var originPjtNm =fullPjtNm.substr(7);
				   	 						    
				   	 								if(obj.mgt_name == originPjtNm){
				   	 									
				   	 									return obj
				   	 								} 
				   	 							} else {
				   	 								return obj
				   	 							}
				   	 						}
				   	 					}
				   	 					
				   	 				}else{
				   	 					
					   	 				if($('#txtTitle').val() != ''){
		   	 								var fullPjtNm = $('#txtTitle').val();
		   	 								var originPjtNm =fullPjtNm.substr(7);
		   	 						    
		   	 								if(obj.mgt_name == originPjtNm){
		   	 									
		   	 									return obj
		   	 								} 
		   	 							} else {
		   	 								return obj
		   	 							}
				   	 				}
				   	 			}
				   	 		}	
									
			   	 		}
		   	 			
		 			});
		   	 	}
		   	 	if($('#statusSort').val() == 'finish' && $('#empSameSort').val() == 'notSame' && $('#sevenDaySort').val() == 'safe'){
			   	 	return response.list.filter(function(obj){
		   	 			
			   	 		if(obj.res_date != null && obj.c_ridocfullnum != null){
				   	 		if(obj.emp_name != null && obj.EP_NAME_KOR != null ){
		   	 				
					   	 		var diffDay ;
				   	 			var resDate =obj.res_date;
				   	 			var tripDate =obj.authDate;
				   	 			
				   	 			diffDay = dayDiffCal(resDate,tripDate);
								
				   	 			if(diffDay <= 7){
					   	 				
									if(obj.emp_name != obj.EP_NAME_KOR ){
					   	 				
						   	 			if($('#nameSort').val() =='kyuljaeEmp'){
					   	 					if(obj.emp_name != null){
					   	 						if(obj.emp_name.indexOf($('#empName').val()) >= 0){
					   	 							
						   	 						if($('#txtTitle').val() != ''){
					   	 								var fullPjtNm = $('#txtTitle').val();
					   	 								var originPjtNm =fullPjtNm.substr(7);
					   	 						    
					   	 								if(obj.mgt_name == originPjtNm){
					   	 									
					   	 									return obj
					   	 								} 
					   	 							} else {
					   	 								return obj
					   	 							}
					   	 						}
					   	 					}
					   	 					
					   	 				}else{
					   	 					
						   	 				if($('#txtTitle').val() != ''){
			   	 								var fullPjtNm = $('#txtTitle').val();
			   	 								var originPjtNm =fullPjtNm.substr(7);
			   	 						    
			   	 								if(obj.mgt_name == originPjtNm){
			   	 									
			   	 									return obj
			   	 								} 
			   	 							} else {
			   	 								return obj
			   	 							}
					   	 				}
					   	 			}
								}	
								
				   	 		}	
									
			   	 		}
		   	 			
		 			});
		   	 	}
		   	 	if($('#statusSort').val() == 'finish' && $('#sameSort').val() == 'notSame' && $('#sevenDaySort').val() == 'over'){
			   	 	return response.list.filter(function(obj){
		   	 			
			   	 		if(obj.res_date != null && obj.c_ridocfullnum != null){
				   	 		if(obj.emp_name != null && obj.EP_NAME_KOR != null ){
		   	 				
					   	 		var diffDay ;
				   	 			var resDate =obj.res_date;
				   	 			var tripDate =obj.authDate;
				   	 			
				   	 			diffDay = dayDiffCal(resDate,tripDate);
								
				   	 			if(diffDay > 7){
					   	 				
									if(obj.emp_name != obj.EP_NAME_KOR ){
					   	 				
						   	 			if($('#nameSort').val() =='kyuljaeEmp'){
					   	 					if(obj.emp_name != null){
					   	 						if(obj.emp_name.indexOf($('#empName').val()) >= 0){
					   	 							
						   	 						if($('#txtTitle').val() != ''){
					   	 								var fullPjtNm = $('#txtTitle').val();
					   	 								var originPjtNm =fullPjtNm.substr(7);
					   	 						    
					   	 								if(obj.mgt_name == originPjtNm){
					   	 									
					   	 									return obj
					   	 								} 
					   	 							} else {
					   	 								return obj
					   	 							}
					   	 						}
					   	 					}
					   	 					
					   	 				}else{
					   	 					
						   	 				if($('#txtTitle').val() != ''){
			   	 								var fullPjtNm = $('#txtTitle').val();
			   	 								var originPjtNm =fullPjtNm.substr(7);
			   	 						    
			   	 								if(obj.mgt_name == originPjtNm){
			   	 									
			   	 									return obj
			   	 								} 
			   	 							} else {
			   	 								return obj
			   	 							}
					   	 				}
					   	 			}
								}	
								
				   	 		}	
									
			   	 		}
		   	 			
		 			});
		   	 	}
	   	    }
		}
	});
	
	//검색버튼 이벤트
	function searchBtn() {
		//메인그리드 reload 호출
		gridReLoad();
	}
	
	//메인그리드 reload
	function gridReLoad() {
		$('#grid').data('kendoGrid').dataSource.read();
		setTimeout(function(){console.log($('#grid').data("kendoGrid")._data);},1);
	}
	//프로젝트 팝업 그리드 
	function projectKendo() {
		
	var projectGrid = $("#projectGrid").kendoGrid({
        dataSource: new kendo.data.DataSource({
    	    transport: { 
    	        read:  {
    	            url: _g_contextPath_+'/budget/projectList',
    	            dataType: "json",
    	            type: 'post'
    	        },
    	      	parameterMap: function(data, operation) {
    	      		data.fiscal_year = $('#txtToDt').val().substr(0,4);
    	      		data.project 		= $("#projectName").val();
    	     		return data;
    	     	}
    	    },
    	    schema: {
    	      data: function(response) {
    	        return response.list;
    	      },
    	      total: function(response) {
    	        return response.total;
    	      }
    	    }
    	}),
        height: 500,	        
        sortable: true,
        persistSelection: true,
        selectable: "multiple",
        columns:[{
        					title : "프로젝트 코드",
        					field : "PJT_CD",
        					width : 30
        				},
        				{
        					title : "프로젝트 명",
        					field : "PJT_NM",
        					width : 30
        				},
        				{
        					title : "선택",
        					width : 15,
					    	template : '<input type="button" id="" class="text_blue" onclick="projectSelect(this);" value="선택">'
    		    	    }]
    }).data("kendoGrid");
	}
	 //메인그리드
	function mainGrid() {
		
		//캔도 그리드 기본
		var grid = $("#grid").kendoGrid({
			dataSource : dataSource,
			height : 500,
			sortable : false,
			pageable :false /* {
				refresh : true,
				pageSizes : [10,20,30,50,100],
				buttonCount : 5
			} */,
			persistSelection : true,
			columns : [
						/* { 
							headerTemplate : "<input type='checkbox' id='headerCheckbox' class='k-checkbox header-checkbox headerCheckbox'><label class='k-checkbox-label' for='headerCheckbox'></label>",
							template: function(data){
								return '<input type="checkbox" id="sts'+data.NUM+'" class="k-checkbox checkbox"/><label for="sts'+data.NUM+'" class="k-checkbox-label"></label>';
							}
							,width:50,
						}, */{
							title : "유형",
							filed:"c_tiname",
							template : function(data){
								var name =data.c_tiname == undefined ? '' : data.c_tiname ;
								
								if(name =='지출결의서(업무추진비)'){
									name = name.substr(6,5);
								}
								
								return name;
							},
							width:70,
						},{
							field : "dept_name",
							  title : "부서",
							  width:85,
						},{
							field : "mgt_name",
							title : "프로젝트",
							width:100,
						},{
							field : "authDate",
							title : "승인일시",
							width:120,
						},{
							field : "TR_NM",
							title : "사용처",
							width:100,
						},{
							field : "merc_saup_no",
							title : "사업자번호",
							width:90,
						},{
							field : "auth_num",
							title : "승인번호",
							width:70,
							template : function(item){
								
								return '<a class="text_blue cardPop" style="text-decoration:underline;cursor:pointer;" onclick="fn_pop_card_duzon('+ item.sync_id+')" title="법인카드 사용내역 상세 팝업보기">' + (item.auth_num || '') + '</a>';
								
							}
						},{
							field : "mercAddr",
							title : "주소",
							width:200,
						},{
							field : "CTR_NM", // ms 꺼 ㅋ
							title : "카드명",
							width:200,
						},{
							field : "card_num",
							title : "카드번호",
							width:150,
						},{
							field : "UNIT_AM",	
							title : "금액",
							width:100,
							template: function(data){
								var COST = data.UNIT_AM || "";
								return COST.toString().toMoney();
							}
						},{
						title : '업무추진비 집행내역',
						columns : [
							{
								title : "일시",
								width:80,
								 template : function (data) {
									 var fullDate = data.djWorkFeeDate || "";
									 var YMD;
									 if(fullDate != ''){
										 
									 YMD =fullDate.substr(0,12);
									 } else {
										YMD ="";
									 }
									 
									 return YMD;
									 
								}  
							},{
								field : "djWorkFeeUser1",
								title : "비용집행자",
								width:100,
							},{
								field : "djWorkFeeUserCnt",
								title : "참석인원",
								width:100,
							},{
								field : "djWorkFeeUser2",
								title : "참석자",
								width:150,
							},{
								field : "djWorkFeeAmt",
								title : "금액",
								 template : function (data) {
									 var fullText = data.djWorkFeeAmt || "";
									 var cost = fullText.substr(1,fullText.indexOf('(')-1);
									 
									 return cost.toString().toMoney();
									 
								}, 
								width:100,
							},{
								field : "djWorkFeeType",
								title : "집행유형",
								width:200,
							}
						]
						} ,{
							title : '결의서',
							columns : [
									{
									field : "emp_name",
									title : "결의자",
									width:80,
								},{
									field : "res_date",
									width:80,
									template : function(data){
										var resDate = "";
										
										if(data.res_date){
											 var year = data.res_date.substr(0,4);
											 var month = data.res_date.substr(4,2);
											 var day = data.res_date.substr(6,2);
											 
											 resDate = year + "-" + month + "-" + day;
										}
										
										return resDate;
									},
									title : "결재일자",
								},{
									field : "doc_no",
									width:80,
									template : function(data) {
										if(data.doc_seq){
											
										return "<span class='blueColor docTitle' onclick='fn_docViewPop(" + data.doc_seq + ")'>" + data.doc_no + "</span>";
										} else {
											return "";
										}
									},
									title : "문서번호"
								}
							]
						},{
							field : "regNo",
							title : "접수번호",
							width:100
						},{
							title : '회계',
							columns : [
									{
									field : "fill_dt",
									width:80,
									template : function(data){
										var fillDt = "";
										
										if(data.fill_dt){
											 var year = data.fill_dt.substr(2,2);
											 var month = data.fill_dt.substr(4,2);
											 var day = data.fill_dt.substr(6,2);
											 
											 fillDt = year + "-" + month + "-" + day;
										}
										
										return fillDt;
									},
									title : "확정일",
									
								},{
									field : "c_ridocfullnum",
									width:80,
									template : function(data) {
										if(data.appr_dikey && data.c_ridocfullnum != null) {
										return "<span class='blueColor docTitle' onclick='fn_docViewPop(" + data.appr_dikey + ")'>" + data.c_ridocfullnum + "</span>";
										} else {
											return "";
										}
											
									},
									title : "문서번호"
								}
							]
						}
						,{
							title : "상태",
							width:80,
							template: function(data){
								var status ="<span style='color:red;'>미처리</span>";
								
								if(data.res_date != null ){
									status = "<span style='color:darkorange;'>결의완료</span>"
								};
								
								if( data.c_ridocfullnum != null){
									status = "<span style='color:blue;'>지급완료</span>"
								};
								
								
								
								return status;
							}
						}],
						change: function (e) {
				        	gridClick(e);
				        },
						dataBound : function (e) {
							
								
								$gridIndex = 0;
								var grid = e.sender;
								if(grid.dataSource._data.length==0){
									/* var colCount = grid.columns.length; */
									var colCount = 23; //다중 컬럼이다보니 숫자를 강제로 세어서 넣오줌
									$(e.sender.wrapper)
										.find('tbody')
										.append('<tr class="kendo-data-row">' + 
												'<td colspan="' + colCount + '" class="no-data">데이터가 없습니다.</td></tr>');
								}
							
							/* $(".headerCheckbox").change(function(){
								if($(this).is(":checked")){
									$(this).closest('table').parent().parent().parent().find('.checkbox').prop("checked", "checked");
						        }else{
						        	$(this).closest('table').parent().parent().parent().find('.checkbox').removeProp("checked");
						        }
							}); */
						}
					}).data("kendoGrid");
		
		
		
		
	}
	 
	function fnDeptChange(){
		var obj = $('#selDept').data('kendoComboBox');
		$('#txtDeptCd').val(obj._old);
		$('#txtDeptName').val(obj._prev);
		gridReLoad();
		
	}
	 
	
	
	
	
	
	
</script>

<!-- iframe wrap -->
<div class="iframe_wrap" style="min-width: 1100px">
<form id="outProcessFormData" action="http://211.192.144.104/gw/outProcessLogOn.do" target="outProcessLogOn"></form>
<input type="hidden" id="loginId" value="${loginVO.id }" />
	<!-- 컨텐츠타이틀영역 -->
	<div class="sub_title_wrap">

		<div class="title_div">
			<h4>근무계획</h4>
		</div>
	</div>

	<div class="sub_contents_wrap">

		<div class="top_box">
			<dl>
				<dt class="ar" style="width: 55px">요청기간</dt>
				<dd>
					<input type="text" value="" name="" id="txtFrDt" placeholder="" />
					&nbsp;~ 
					<input type="text" value="" name="" id="txtToDt" placeholder="" />
				</dd>
				<!-- <dt class="ar" style="width: 65px">구분</dt>
				<dd>
					<input id="txtPurcReqType" class="txtPurcReqType"/>
				</dd> -->
				<dt class="ar" style="width: 30px">부서</dt>
				<dd>
					<input id="selDept" />
					<input type="hidden" id="txtDeptName" value="" />
					<input type="hidden" id="txtDeptCd" value="" />
				</dd>
				<dt class="ar" style="width: 30px">이름</dt>
				<dd style="width:80px;">
					<select id="nameSort" style="width: 100%;">
						<option value="bizEmp">출장자</option>
						<option value="kyuljaeEmp">결의자</option>
					</select>
				</dd>
				<dd>
					<input type="text" id="empName"  value="" style="width: 100px;"/>
				</dd>
				<dt class="ar" style="width: 55px">프로젝트</dt>
				<dd>
					<input type="text" name="" id="txtTitle" style="width: 100px;" readonly="readonly" class="ri"/>
					<input type="hidden"  id="txtCd"/>
					<button type="button" id ="pjtFromSearch" value="검색">
						<img style="position:inherit;" src="<c:url value='/Images/btn/search_icon2.png'/>"></button>
				</dd>
				<dt style="width:55px;">진행상태</dt>
				<dd style="width:80px;">
					<select id="statusSort" style="width: 100%;">
						<option value="">전체</option>
						<option value="no">미처리</option>
						<option value="half">결의완료</option>
						<option value="finish">지급완료</option>
					</select>
				</dd>
				<div style="display: none;">
				<dt style="width:160px;">출장자,결의자 불일치 여부</dt>
				<dd style="width:80px;">
					<select id="empSameSort" style="width: 100%;">
						<option value="">전체</option>
						<option value="same">일치</option>
						<option value="notSame">불일치</option>
					</select>
				</dd> 
				</div>
				<dt style="width:110px;">승인 7일 경과여부</dt>
				<dd style="width:80px;">
					<select id="sevenDaySort" style="width: 100%;">
						<option value="">전체</option>
						<option value="over">경과</option>
						<option value="safe">미경과</option>
					</select>
				</dd>
				
			</dl>
		</div>

		<!-- 버튼 -->
		<div class="btn_div mt10 cl">
			<div class="left_div">
				<p class="tit_p mt5 mb0"></p>
			</div>
			<div class="right_div">
				<div class="controll_btn p0">
					<!-- <button type="button" id="btnReturn" onclick="fnPurcContRepApproval();">계약보고</button>
					<button type="button" id="btnReturn" onclick="fnPurcContRepApprovalComplete();" style="margin-right: 20px;">계약보고완료</button> -->
					<button type="button" id="" onclick="excel();">엑셀다운</button>
					<button type="button" id="" onclick="searchBtn();">조회</button>
				</div>
			</div>
		</div>
		
		<div class="com_ta2 mt15">
			<div id="grid"></div>
		</div>
		<!-- 프로젝트검색팝업 -->
		<div class="pop_wrap_dir" id="projectPopup" style="width:600px;">
			<div class="pop_head">
				<h1>프로젝트 선택</h1>
			</div>
			<div class="pop_con">
				<div class="top_box">
					<dl>
						<dt class="ar" style="width: 80px;">프로젝트 명</dt>
						<dd style="">
							<input type="text" id="projectName" style="width: 120px" />
						</dd>
						<dd>
							<input type="button" onclick="projectGridReload();" id="searchButton"	value="검색" />
						</dd>
					</dl>
				</div>
				<div class="com_ta mt15">
					<div id="projectGrid"></div>
				</div>			
			</div>
		
			<div class="pop_foot">
				<div class="btn_cen pt12">
					<input type="button" class="gray_btn" id="projectPopupCancel" value="닫기" />
				</div>
			</div>
		</div>	
		<!-- 프로젝트검색팝업 -->	
	</div>
</div>



<script type="text/javascript">

/* 프로젝트팝업 - 황차장님 프로시저 param : 년도값보내면 프로젝트가져옴 */
$("#projectPopup").kendoWindow({
    width: "600px",
    visible: false,
    actions: ["Close"]
}).data("kendoWindow").center();


function projectSelect(e){		
	var row = $("#projectGrid").data("kendoGrid").dataItem($(e).closest("tr"));
	
		$("#txtTitle").val(row.PJT_NM);
		 $("#txtCd").val(row.PJT_CD); 
	$('#projectName').val('');
	$("#projectPopup").data("kendoWindow").close();
}
function projectPopupClose(){
	$('#projectName').val('');
	 $("#projectPopup").data("kendoWindow").close();
}

$("#pjtFromSearch").on("click", function() {
		 $('#txtTitle').val("");
	
	
	 $('.k-widget.k-window').css('top','50px');
	 $("#projectPopup").data("kendoWindow").open();
	 projectGridReload();
});

$("#projectName").on("keyup", function(e){
	if (e.keyCode === 13) {
		projectGridReload();
	}
});

$('#projectPopupCancel').on('click', function() {
	projectPopupClose();
});


function projectGridReload() {
	$("#projectGrid").data("kendoGrid").dataSource.read();
}

/* 프로젝트팝업 */

function fn_pop_card_duzon(syncId) {
	/* var popup = window.open("../../../expend/np/user/UserCardDetailPop.do?syncId=" + syncId, "" , "width=432, height=489 , scrollbars=yes") */
	var popup = window.open("http://10.10.10.82/custExp/expend/np/user/UserCardDetailPop.do?syncId=" + syncId, "" , "width=432, height=489 , scrollbars=yes")
};

function dayDiffCal(kyuljaeDay, tripDay) {

	var year = kyuljaeDay.substr(0,4);
 	var month = kyuljaeDay.substr(4,2);
 	var day = kyuljaeDay.substr(6,2);
 
 	var kyuljaeDt = year + "-" + month + "-" + day;
		
	
	var bizDt = tripDay.substr(0,10);
	
	
	var t1 = moment(kyuljaeDt, 'YYYY-MM-DD');
	var t2 = moment(bizDt, 'YYYY-MM-DD');
	
	var diffDay = t1.diff(t2,'days')
	
	return diffDay;
}


function excel() {
	
	var list = $('#grid').data('kendoGrid')._data;
	var title = '업무추진비 현황';
	
	$.ajax({
 		url: _g_contextPath_+"/busTrip/upMooExcel",
 		dataType : 'json',
 		data : { list : JSON.stringify(list),  title : title },
 		type : 'POST',
 		async : false,
 		success: function(result){
			
 			var downWin = window.open('','_self');
			downWin.location.href = _g_contextPath_+"/busTrip/excelDownLoad?fileName="+ escape(encodeURIComponent(result.fileName)) +'&fileFullPath='+escape(encodeURIComponent(result.fileFullPath));
 			
 		}
 	});
}
</script>