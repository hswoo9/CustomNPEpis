<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>

<body>

	<input type="hidden" id="comp_seq" value="${userInfo.compSeq }"/>
	<!-- 컨텐츠타이틀영역 -->
	
	<div class="pop_wrap_dir" style="width:1050px;">
	<p class="tit_p mt5 mt20">사용자 조회</p>

	<div class="com_ta">
						<div class="com_ta2">
							<div id="userList"></div>
						</div>
				
			</div>

	</div><!-- //sub_contents_wrap -->




<script>


$(function(){
	
	
	var userDataSource = new kendo.data.DataSource({
		serverPaging: true,
		pageSize: 10,
	    transport: { 
	        read:  {
	            url:  "<c:url value='/busTrip/getUserInfo' />",
	            dataType: "json",
	            type: 'post'
	        },
	      	parameterMap: function(data, operation) {
	      		data.emp_name = $('#searchNm').val();
	      		data.dept_name = $('#searchDp').val();
	      		data.emp_seq = $('#searchNum').val();
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
	
	
	$("#userList").kendoGrid({
        dataSource: userDataSource,
        height: 460,
        sortable: false,
        pageable: false,
        persistSelection: true,
        selectable: "multiple",
        columns: [
       	 {
            title: "직원번호",
            columns: [{
                field: "erp_emp_num",
                headerTemplate: function(){
    				return '<input type="text" style="width:90%;" id="searchNum" class="userHeaderInput">';
    	        },
     		}]
        }, {
            title: "이름",
            columns: [{
                field: "emp_name",
                headerTemplate: function(){
    				return '<input type="text" style="width:90%;" id="searchNm" class="userHeaderInput">';
    	        },
     		}]
        }, {
            title: "부서",
            columns: [{
                field: "dept_name",
                headerTemplate: function(){
    				return '<input type="text" style="width:90%;" id="searchDp" class="userHeaderInput">';
    	        },
     		}]
        }],
    }).data("kendoGrid");
	
	$("#userList").data('kendoGrid').dataSource.read();
	
	userPopUpInit();
	
 	
});

	function userPopUpInit(){
		
		
		
		$(document).on('dblclick', '#userList .k-grid-content tr', function(){
			var gData = $("#userList").data('kendoGrid').dataItem(this);
			/* $('#' + popupId).val(gData.emp_name).attr('code', gData.emp_seq); */
			console.log(gData);
			 
			window.opener.testuser(JSON.stringify(gData));
			 
			self.close(); 
		});
		
		$('.userHeaderInput').on('keydown', function(key){
			 if (key.keyCode == 13) {
				 $("#userList").data('kendoGrid').dataSource.read();
	         }
		});
	}



</script>
</body>

