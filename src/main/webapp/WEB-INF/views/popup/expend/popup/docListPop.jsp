<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>

<body>
<div id="mainGrid"></div>
<script>


$(function(){
	
	

	
	//$("#userList").data('kendoGrid').dataSource.read();


    makerGrid();
});

	function makerGrid(){
		var dataSource = new kendo.data.DataSource({
			serverPaging: false,
			pageSize: 99999,
			transport: {
				read:  {
					url:  "<c:url value='/expend/getDocListData.do' />",
					dataType: "json",
					type: 'post'
				},
				parameterMap: function(data, operation) {
                    data.searchDocNo = $("#searchDocNo").val();
                    data.searchDocTitle = $("#searchDocTitle").val();
                    data.searchDraftEmpName = $("#searchDraftEmpName").val();
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


		$("#mainGrid").kendoGrid({
			dataSource: dataSource,
			height: 460,
			sortable: false,
			pageable: false,
			persistSelection: true,
			selectable: "multiple",
            dataBound : onDataBound,
			columns: [
				{
					title: "문서번호",
					columns: [{
						field: "DOC_NO",
						headerTemplate: function(){
							return '<input type="text" style="width:90%;" id="searchDocNo" onkeydown="if(event.keyCode === 13) { gridReload(); }">';
						},
					}]
				}, {
					title: "제목",
					columns: [{
						field: "DOC_TITLE",
						headerTemplate: function(){
							return '<input type="text" style="width:90%;" id="searchDocTitle" onkeydown="if(event.keyCode === 13) { gridReload(); }">';
						},
					}]
				}, {
					title: "기안자",
					columns: [{
						field: "DRAFT_EMP_NAME",
						headerTemplate: function(){
							return '<input type="text" style="width:90%;" id="searchDraftEmpName" onkeydown="if(event.keyCode === 13) { gridReload(); }">';
						},
					}]
				}],
		}).data("kendoGrid");

        function onDataBound(){
            var grid = this;
            grid.element.off('dbclick');

            grid.tbody.find("tr").dblclick(function (e) {
                var dataItem = grid.dataItem($(this));
                console.log(dataItem);
            });
        }
	}

    function gridReload(){
        $("#mainGrid").data("kendoGrid").dataSource.read();
    }

</script>
</body>

