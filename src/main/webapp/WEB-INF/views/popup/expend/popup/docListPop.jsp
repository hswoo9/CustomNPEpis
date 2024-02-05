<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<style>
    .sendBtn {
        background: #fff;
        border-radius: 0px;
        box-shadow: none;
        padding: 0px 12px;
        height: 24px;
        line-height: 24px;
        border: 1px solid #c9cac9;
        outline: 0;
        color: #4a4a4a !important;
    }

</style>
<body>
<input type="hidden" id="syncId" value="${syncId}" />
<div id="mainGrid"></div>
<script>
$(function(){
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
                        width: "150px"
					}]
				}, {
                    title: "기안자",
                    columns: [{
                        field: "DRAFT_EMP_NAME",
                        headerTemplate: function(){
                            return '<input type="text" style="width:90%;" id="searchDraftEmpName" onkeydown="if(event.keyCode === 13) { gridReload(); }">';
                        },
                        width: "100px"
                    }]
                }, {
					title: "제목",
					columns: [{
						field: "DOC_TITLE",
						headerTemplate: function(){
							return '<input type="text" style="width:90%;" id="searchDocTitle" onkeydown="if(event.keyCode === 13) { gridReload(); }">';
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

                var dataList = new Array();
                $.ajax({
                    type : 'post',
                    url : "<c:url value='/expend/getResTradeList.do'/>",
                    dataType : 'json',
                    async : false,
                    data : { RES_DOC_SEQ : dataItem.RES_DOC_SEQ},
                    success : function(data) {
                        if(data.result != null){
                            dataList = data.result;
                        }
                    },
                    error : function(data) {
                    }
                });




                var tradeDetailTemplate = $('<div><div id="subGrid"></div></div>');

                tradeDetailTemplate.kendoWindow({
                    title: "거래처 정보",
                    visible: false,
                    modal: true,
                    width : 500,
                    position : {
                        top : 100,
                        left : 200
                    },
                    close: function () {
                        tradeDetailTemplate.remove();
                    }
                });

                tradeDetailTemplate.data("kendoWindow").open();

                $("#subGrid").kendoGrid({
                    dataSource: dataList,
                    height: 200,
                    sortable: false,
                    pageable: false,
                    persistSelection: true,
                    selectable: "multiple",
                    columns: [
                        {
                            title: "거래처",
                            field: "TR_NAME",
                        }, {
                            title: "카드명",
                            field: "CTR_NAME",
                        }, {
                            title: "",
                            field: "",
                            template : function(e){
                                return '<button type="button" class="sendBtn k-button" onclick="selectUpdate(\'' + e.TRADE_SEQ + '\')">선택</button>';
                            }
                        }],
                }).data("kendoGrid");

            });
        }
	}

    function gridReload(){
        $("#mainGrid").data("kendoGrid").dataSource.read();
    }

    function selectUpdate(key){
        var params = {
            tradeSeq : key,
            syncId : $("#syncId").val()
        };

        if(confirm("해당 거래처로 연동 하시겠습니까?")){
            $.ajax({
                type : 'post',
                url : "<c:url value='/expend/setResCardUse.do'/>",
                dataType : 'json',
                async : false,
                data : params,
                success : function(data) {
                    if(data.result.status != null){
                        if(data.result.status == "200"){
                            alert(data.result.message);
                            if(window.opener.fnCardReportSearch){
                                window.opener.fnCardReportSearch();
                            }
                            self.close();
                        }else{
                            alert(data.result.message);
                        }
                    }
                },
                error : function(data) {
                }
            });
        }

    }
</script>
</body>

