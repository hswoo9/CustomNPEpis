<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%    pageContext.setAttribute("CR", "\r");    pageContext.setAttribute("LF", "\n"); %>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
<meta name="description" content="Crush it Able The most popular Admin Dashboard template and ui kit">
<meta name="author" content="PuffinTheme the theme designer">

<!-- Theme -->
<link rel="stylesheet" type="text/css" href="<c:url value='/css/kendoui/kendo.silver.min.css' />" />

<!-- Bootstrap Core and vandor -->
<link rel="stylesheet" href="<c:url value='/assets/plugins/bootstrap/css/bootstrap.min.css' />" />
<link rel="stylesheet" href="<c:url value='/assets/plugins/charts-c3/c3.min.css' />"/>
<link rel="stylesheet" href="<c:url value='/assets/plugins/jvectormap/jvectormap-2.0.3.css' />" />

<!-- jQuery -->
<link rel="stylesheet" href="<c:url value='/css/kendoui/kendo.default-main.min.css' />"/>
<link rel="stylesheet" href="<c:url value='/css/kendoui/kendo.common.min.css' />"/>
<link rel="stylesheet" href="<c:url value='/css/kendoui/kendo.default.min.css' />"/>

<!-- main -->
<link rel="stylesheet" type="text/css" href="<c:url value='/css/approval/main.css' />">
<link rel="stylesheet" type="text/css" href="<c:url value='/css/approval/style.css' />">
<script type="text/javascript" src="<c:url value='/js/approval/jspdf.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/approval/html2canvas.min.js'/>"></script>

<!-- ckEditor -->
<script type="text/javascript" src="<c:url value='/ckEditor/ckeditor.js' />"></script>

<style>
    .k-grid-toolbar{
        justify-content: flex-end !important;
    }
    .k-widget.k-treeview {
        overflow: hidden;
    }
    #approvalLineDataTb tbody tr:hover:not(.active) {
        background-color: #ededed;
    }
    .active{
        background-color: rgb(241, 248, 255);
    }
    #treeViewDiv{
        width: auto !important;
    }

    .iframe_wrap {
        padding: 0px !important;
    }

    .location_info {
        display: none;
    }

    .k-dropdown-wrap {
        display: none;
    }

    .k-pager-info {
        display: none;
    }

    .k-treeview .k-i-collapse:before{background: url("/Images/ico/ico_organ03_open.png");content: "";}
    .k-treeview .k-i-expand:before{background: url("/Images/ico/ico_organ03_close.png");content: "";}
    .k-treeview .k-treeview-top.k-treeview-bot .k-i-collapse:before{background: url("/Images/ico/ico_organ01.png")}
    .k-treeview .k-treeview-top.k-treeview-bot .k-i-expand:before{background: url("/Images/ico/ico_organ01.png")}
    /*yh*/
    .k-treeview .k-top.k-bot .k-i-collapse{background: url("/Images/ico/ico_organ01.png")}
    .k-treeview .k-top.k-bot .k-i-expand{background: url("/Images/ico/ico_organ01.png")}

    .k-treeview .k-i-expand-disabled, .k-treeview .k-i-collapse-disabled {
        cursor: default
    }
    /*yh*/
    .k-treeview .k-treeview-top,
    .k-treeview .k-treeview-mid,
    .k-treeview .k-treeview-bot {
        background-image: url('/Images/bg/treeview-nodes.png');
        background-repeat: no-repeat;
        margin-left: -16px;
        padding-left: 16px;
    }

    .k-treeview .k-treeview-top .k-treeview-bot{background: none; background-position: -25px -66px;}

    /*yh*/
    .k-treeview .k-item { background-image: url('/Images/bg/treeview-line.png'); }
    .k-treeview .k-last { background-image: none; }
    .k-treeview .k-treeview-top { background-position: -91px 0; }
    .k-treeview .k-treeview-bot { background-position: -69px -22px; }
    .k-treeview .k-treeview-mid { background-position: -47px -44px; }
    .k-treeview .k-last .k-treeview-top { background-position: -25px -66px; }
    .k-treeview .k-group .k-last { background-position: -69px -22px; }
    .k-treeview .k-item {
        background-repeat: no-repeat;
    }

    /*yh*/
    .k-treeview .k-first {
        background-repeat: no-repeat;
        background-position: 0 16px;
    }

    .pop_head{
        height: 32px;
        position: relative;
        background: #1385db;
    }
    .pop_head h1 {
        font-size: 12px;
        color: #fff;
        line-height: 32px;
        padding-left: 16px;
    }

    #treeview {
        background: #fff;
        overflow: auto;
        font-size: 12px
    }

    .k-button {
        margin: 0;
        padding: 4px 8px;
        box-sizing: border-box;
        border-width: 1px;
        border-style: solid;
        background-repeat: repeat-x;
        background-position: 0 center;
        font: inherit;
        line-height: 1.42857143;
        text-align: center;
        text-decoration: none;
        display: -ms-inline-flexbox;
        display: inline-flex;
        overflow: hidden;
        -ms-flex-align: center;
        align-items: center;
        gap: 4px;
        -ms-flex-pack: center;
        justify-content: center;
        vertical-align: middle;
        -webkit-user-select: none;
        -ms-user-select: none;
        user-select: none;
        cursor: pointer;
        outline: 0;
        -webkit-appearance: none;
        position: relative;
        border-radius: 4px !important;
    }

    .k-grid tbody button.k-button {
        min-width: 40px;
    }

    li.k-item.k-treeview-item:last-child{background:#fff;}
    li.k-item.k-treeview-item:last-child .k-treeview-mid{padding-top:2px;}
    .k-treeview-leaf.k-selected{background-color: #1984c8!important;}
    .k-treeview-leaf.k-selected.k-hover, .k-treeview-leaf.k-selected:hover{background-color: #1A5089!important;}
    .k-drag-clue, .k-grid-header, .k-grouping-header, .k-header, .k-menu, .k-panelbar>.k-panelbar-header>.k-link, .k-progressbar, .k-state-highlight, .k-tabstrip, .k-tabstrip-items .k-item, .k-toolbar{background-color: #E4EBF3;}
    .k-grid-content tr:last-child>td, .k-grid-content-locked tr:last-child>td{border-bottom-width: 1px;}
</style>
</head>
<body>
<div class="pop_head">
    <h1>결재선 지정</h1>
    <a href="#n" class="clo"><img src="<c:url value='/Images/btn/btn_pop_clo01.png'/>" alt=""></a>
</div>
<div style="padding: 20px">
    <input type="hidden" id="empSeq" name="empSeq" value="${loginVO.uniqId}">
    <table style="padding: 20px;">
        <colgroup>
            <col width="272px">
            <col width="272px">
            <col width="500px">
        </colgroup>
        <tr>
            <td>
                <div id="apprLineTabStrip" style="width: 285px;">
                    <ul>
                        <li class="k-state-active">
                            조직도
                        </li>
                        <li>
                            즐겨찾기
                        </li>
                    </ul>
                    <div id="gridForm" style="height:445px; width: 275px;overflow: auto;border: 0px solid #dedfdf;">
                        <div id="treeview" style="background-color:#fff;width: 300px; height: 602px; border: 0px solid #dbdbde">
                        </div>
                    </div>
                    <div style="height:445px;width: 275px;">
                        <div id="favApproveGrid"></div>
                    </div>
                </div>
            </td>
            <td>
                <div id="apprLineUserInfoTabStrip" style="width: 420px;">
                    <ul>
                        <li class="k-state-active">
                            직원 정보
                        </li>
                    </ul>
                    <div style="height:445px;width: 410px;">
                        <div id="userList">
                        </div>
                    </div>
                </div>
            </td>
            <td>
                <div id="apprLineTypeTabStrip" style="width: 600px;">
                    <ul>
                        <li class="k-state-active">
                            결재
                        </li>
                        <li>
                            협조결재
                        </li>
                    </ul>
                    <div>
                        <div id="addApprLineGrid">

                        </div>
                        <div id="approvalLineDataDiv" style="max-height: 345px; height:345px; overflow-y: scroll;border: 1px solid #dedfdf;" >
                            <table class="table table-bordered mb-0" id="approvalLineDataTb" style="text-align: center;">
                                <colgroup>
                                    <col width="12%">
                                    <col width="16%">
                                    <col width="auto">
                                    <col width="24%">
                                    <col width="23.9%">
                                </colgroup>
                                <tbody>

                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div>
                        <div id="addCooperationLineGrid">

                        </div>
                        <div id="cooperationLineDataDiv" style="max-height: 345px; height:345px; overflow-y: scroll;border: 1px solid #dedfdf;" >
                            <table class="table table-bordered mb-0" id="cooperationLineDataTb" style="text-align: center;">
                                <colgroup>
                                    <col width="12%">
                                    <col width="16%">
                                    <col width="auto">
                                    <col width="24%">
                                    <col width="23.9%">
                                </colgroup>
                                <tbody>

                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </td>
        </tr>
    </table>
    <div class="mt-10" style="text-align: right">
        <button type="button" class="k-grid-button k-button k-button-md k-rounded-md k-button-solid k-button-solid-base" onclick="apprLineSave()" style="vertical-align: middle;">
            <span class="k-button-text">확인</span>
        </button>
        <button type="button" class="k-grid-button k-button k-button-md k-rounded-md k-button-solid k-button-solid-base" onclick="window.close()" style="vertical-align: middle;">
            <span class="k-button-text">닫기</span>
        </button>
    </div>
</div>
<script>
    /**
     *  조직도
     */

    $("#apprLineTabStrip, #apprLineUserInfoTabStrip, #apprLineTypeTabStrip").kendoTabStrip({
        animation:  {
            open: {
                effects: "fadeIn"
            }
        }
    });
    var datas = JSON.parse('${data}');
    var deptSeq = '${loginVO.orgnztId}';
    var deptName = '${loginVO.orgnztNm}';
    var gridDataSource = new kendo.data.DataSource({
        transport: {
            read:  {
                url: "<c:url value='/common/empInformation.do' />",
                dataType: "json",
                type: "post"
            },
            parameterMap: function(data, operation) {
                data.deptSeq = deptSeq;
                return data;
            }
        },
        schema: {
            data: function(response) {
                return response.list;
            },
        },
        pageSize: 10,
    });

    $(function() {
        $("#treeview").kendoTreeView({
            dataSource: datas,
            dataTextField: ['dept_name'],
            select: treeClick,
        });

        $("#userList").kendoGrid({
            dataSource: gridDataSource,
            height: 415,
            sortable: true,
            scrollable: true,
            pageable: {
                refresh: true,
                pageSize : 10,
                pageSizes: [10, 20, 50, "ALL"],
                buttonCount: 5,
                messages: {
                    display: "{0} - {1} of {2}",
                    itemsPerPage: "",
                    empty: "데이터가 없습니다.",
                }
            },
            columns: [
                {
                    field: "dept_name",
                    title: "부서",
                    width: "100px",
                }, {
                    field: "duty",
                    title: "직책",
                    width: "100px",
                }, {
                    field: "emp_name",
                    title: "성명",
                    width: "100px",
                }, {
                    width: "70px",
                    template: approveAddBtn,
                }],
        }).data("kendoGrid");

        /**조직도 클릭이벤트*/
        function treeClick(e) {
            var item = $("#treeview").data("kendoTreeView").dataItem(e.node);
            deptSeq = item.dept_seq;
            deptName = item.dept_name;
            $("#userList").data("kendoGrid").dataSource.read();
        }
    });

    var approveAddBtn = function (e) {
        return '<button type="button" class="k-grid-add k-button k-button-md k-rounded-md k-button-solid k-button-solid-base" onclick="addTable(\'' + e.emp_seq + '\',\'userClick\')">' +
            '<span class="k-button-text">추가</span>	' +
            '</button>';
    }

    var approversArr = opener.approversArr != null ? opener.approversArr : new Array();
    var cooperationsArr = opener.cooperationsArr != null ? opener.cooperationsArr : new Array();
    approversArrCheck();
    cooperationsArrCheck();

    /**
     *  조직도 종료
     */

    /**
     *  즐겨찾기 결재선
     */
    var favApproveDataSource = new kendo.data.DataSource({
        serverPaging: false,
        transport: {
            read : {
                url : "<c:url value='/approvalUser/getUserFavApproveRouteList.do'/>",
                dataType : "json",
                type : "post"
            },
            parameterMap: function(data, operation) {
                data.empSeq = $("#empSeq").val();
                return data;
            }
        },
        schema : {
            data: function (data) {
                return data.rs;
            },
            total: function (data) {
                return data.rs.length;
            },
        },
        pageSize: 10,
    });

    var favApproveGrid = $("#favApproveGrid").kendoGrid({
        dataSource: favApproveDataSource,
        height: 415,
        sortable: true,
        scrollable: true,
        pageable: {
            refresh: true,
            pageSize : 10,
            pageSizes: [10, 20, 50, "ALL"],
            buttonCount: 5,
            messages: {
                display: "{0} - {1} of {2}",
                itemsPerPage: "",
                empty: "데이터가 없습니다.",
            }
        },
        noRecords: {
            template: "데이터가 존재하지 않습니다."
        },
        dataBound : onDataBound,
        columns: [
            {
                field : 'FAV_APPROVE_ROUTE_NAME',
                title : "결재선 이름"
            }
        ]
    }).data("kendoGrid");

    /**
     * 즐겨찾기 결재선 종료
     */

    /**
     * 결재선 그리드
     *
     */
    var addApprLineGrid = $("#addApprLineGrid, #addCooperationLineGrid").kendoGrid({
        toolbar : [
            {
                name : 'button',
                template : function (e){
                    return "<button type=\"button\" class=\"k-button k-button-md k-rounded-md k-button-solid k-button-solid-base\" onclick=\"apprLineUpdate('up', $('#apprLineTypeTabStrip').find('.k-tab-on-top').index())\">" +
                        '	<span class="k-icon k-i-caret-double-alt-up k-button-icon"></span>' +
                        '	<span class="k-button-text">위로</span>' +
                        '</button>';
                }
            }, {
                template : function (e){
                    return "<button type=\"button\" class=\"k-button k-button-md k-rounded-md k-button-solid k-button-solid-base\" onclick=\"apprLineUpdate('down', $('#apprLineTypeTabStrip').find('.k-tab-on-top').index())\">" +
                        '	<span class="k-icon k-i-caret-double-alt-down k-button-icon"></span>' +
                        '	<span class="k-button-text">아래로</span>' +
                        '</button>';
                }
            }, {
                template : function (e){
                    return "<button type=\"button\" class=\"k-grid-add k-button k-button-md k-rounded-md k-button-solid k-button-solid-base\" onclick='newFavApprove($('#apprLineTypeTabStrip').find('.k-tab-on-top').index())'>" +
                        '		<span class="k-icon k-i-plus k-button-icon"></span>' +
                        '		<span class="k-button-text">신규</span>' +
                        '	</button>';
                }
            }
        ],
        columns: [
            {
                title : "순번",
                width : 30
            }, {
                title : "이름",
                width : 40
            }, {
                title : "부서",
                width : 60
            }, {
                title : "직급",
                width : 60
            }, {
                title : "직책",
                width : 60
            }
        ]
    });

    function approversArrCheck(){
        var htmlStr = "";
        for(var i = 0; i < approversArr.length; i++){
            htmlStr += "<tr ondblclick='rowDblClick(this)' onclick='rowsel(this)' style='cursor:pointer' class='apprLineTr'>" +
                "		<td>" +
                "			<input type='hidden' id='approveEmpSeq' name='approveEmpSeq' value='"+approversArr[i].approveEmpSeq+"'>" +
                "			<input type='hidden' id='approveEmpName' name='approveEmpName' value='"+approversArr[i].approveEmpName+"'>" +
                "			<input type='hidden' id='approveDeptName' name='approveDeptName' value='"+approversArr[i].approveDeptName+"'>" +
                "			<input type='hidden' id='approvePositionName' name='approvePositionName' value='"+approversArr[i].approvePositionName+"'>" +
                "			<input type='hidden' id='approveDutyName' name='approveDutyName' value='"+approversArr[i].approveDutyName+"'>" +
                "			<span id='approveOrder'>"+approversArr[i].approveOrder+"</span>"+
                "		</td>" +
                "		<td>"+approversArr[i].approveEmpName+"</td>" +
                "		<td>"+approversArr[i].approveDeptName+"</td>" +
                "		<td>"+approversArr[i].approvePositionName+"</td>" +
                "		<td>"+approversArr[i].approveDutyName+"</td>" +
                "	</tr>";
        }
        $("#approvalLineDataTb tbody").append(htmlStr);
    }

    function cooperationsArrCheck(){
        var htmlStr = "";
        for(var i = 0; i < cooperationsArr.length; i++){
            htmlStr += "<tr ondblclick='rowDblClick(this)' onclick='rowsel(this)' style='cursor:pointer' class='cooperationLineTr'>" +
                "		<td>" +
                "			<input type='hidden' id='cooperationEmpSeq' name='cooperationEmpSeq' value='"+cooperationsArr[i].cooperationEmpSeq+"'>" +
                "			<input type='hidden' id='cooperationEmpName' name='cooperationEmpName' value='"+cooperationsArr[i].cooperationEmpName+"'>" +
                "			<input type='hidden' id='cooperationDeptName' name='cooperationDeptName' value='"+cooperationsArr[i].cooperationDeptName+"'>" +
                "			<input type='hidden' id='cooperationPositionName' name='cooperationPositionName' value='"+cooperationsArr[i].cooperationPositionName+"'>" +
                "			<input type='hidden' id='cooperationDutyName' name='cooperationDutyName' value='"+cooperationsArr[i].cooperationDutyName+"'>" +
                "			<span id='cooperationOrder'>"+cooperationsArr[i].cooperationOrder+"</span>"+
                "		</td>" +
                "		<td>"+cooperationsArr[i].cooperationEmpName+"</td>" +
                "		<td>"+cooperationsArr[i].cooperationDeptName+"</td>" +
                "		<td>"+cooperationsArr[i].cooperationPositionName+"</td>" +
                "		<td>"+cooperationsArr[i].cooperationDutyName+"</td>" +
                "	</tr>";
        }
        $("#cooperationLineDataTb tbody").append(htmlStr);
    }

    function addClass (treeview, items){
        for (var i = 0; i < items.length; i++) {
            if(!items[i].hasChildren){
                treeview.findByUid(items[i].uid).attr("empseq", items[i].EMP_SEQ);
                $(treeview.findByUid(items[i].uid)).attr("ondblclick", "addTable(this,'userClick')");
            }
        }
    }

    function addTable(e, mode){
        if(mode == "userClick"){
            var tabNum = $("#apprLineTypeTabStrip").find(".k-tab-on-top").index();
            $.ajax({
                url: "<c:url value='/approval/getUserInfo.do'/>",
                data : {
                    empSeq : e
                },
                dataType: "json",
                type : "post",
                success : function(rs){
                    var result = rs.rs;
                    var flag = true;
                    var htmlStr = "";

                    if(tabNum == 0){
                        $.each($("input[name='approveEmpSeq']"), function(i, e){
                            if($(this).val() == result.EMP_SEQ){
                                flag = false;
                            }
                        })

                        if(flag){
                            if(result != null){
                                htmlStr += "<tr ondblclick='rowDblClick(this)' onclick='rowsel(this)' style='cursor:pointer' class='apprLineTr'>" +
                                    "		<td>" +
                                    "			<input type='hidden' id='approveEmpSeq' name='approveEmpSeq' value='"+result.EMP_SEQ+"'>" +
                                    "			<input type='hidden' id='approveEmpName' name='approveEmpName' value='"+result.EMP_NAME+"'>" +
                                    "			<input type='hidden' id='approveDeptName' name='approveDeptName' value='"+result.DEPT_NAME+"'>" +
                                    "			<input type='hidden' id='approvePositionName' name='approvePositionName' value='"+result.POSITION_NAME+"'>" +
                                    "			<input type='hidden' id='approveDutyName' name='approveDutyName' value='"+result.DUTY_NAME+"'>" +
                                    "			<span id='approveOrder'>"+$("#approvalLineDataTb tbody tr").length+"</span>"+
                                    "		</td>" +
                                    "		<td>"+result.EMP_NAME+"</td>" +
                                    "		<td>"+result.DEPT_NAME+"</td>" +
                                    "		<td>"+result.POSITION_NAME+"</td>" +
                                    "		<td>"+result.DUTY_NAME+"</td>" +
                                    "	</tr>";
                            }
                            $("#approvalLineDataTb tbody").append(htmlStr);
                        }
                    }else{
                        $.each($("input[name='cooperationEmpSeq']"), function(i, e){
                            if($(this).val() == result.EMP_SEQ){
                                flag = false;
                            }
                        })

                        if(flag){
                            if(result != null){
                                htmlStr += "<tr ondblclick='rowDblClick(this)' onclick='rowsel(this)' style='cursor:pointer' class='cooperationLineTr'>" +
                                    "		<td>" +
                                    "			<input type='hidden' id='cooperationEmpSeq' name='cooperationEmpSeq' value='"+result.EMP_SEQ+"'>" +
                                    "			<input type='hidden' id='cooperationEmpName' name='cooperationEmpName' value='"+result.EMP_NAME+"'>" +
                                    "			<input type='hidden' id='cooperationDeptName' name='cooperationDeptName' value='"+result.DEPT_NAME+"'>" +
                                    "			<input type='hidden' id='cooperationPositionName' name='cooperationPositionName' value='"+result.POSITION_NAME+"'>" +
                                    "			<input type='hidden' id='cooperationDutyName' name='cooperationDutyName' value='"+result.DUTY_NAME+"'>" +
                                    "			<span id='cooperationOrder'>"+ ($("#cooperationLineDataTb tbody tr").length+1)+"</span>"+
                                    "		</td>" +
                                    "		<td>"+result.EMP_NAME+"</td>" +
                                    "		<td>"+result.DEPT_NAME+"</td>" +
                                    "		<td>"+result.POSITION_NAME+"</td>" +
                                    "		<td>"+result.DUTY_NAME+"</td>" +
                                    "	</tr>";
                            }
                            $("#cooperationLineDataTb tbody").append(htmlStr);
                        }
                    }
                }
            })
        }else{
            $.ajax({
                url: "<c:url value='/approvalUser/getUserFavApproveRouteDetail.do'/>",
                data : {
                    empSeq : $("#empSeq").val(),
                    favRouteId : e
                },
                dataType: "json",
                type : "post",
                success : function(rs){
                    var result = rs.rs;

                    $("#approvalLineDataTb tbody tr:not(:eq(0))").remove();

                    for(var i = 0; i < result.length; i++){
                        var htmlStr = "";

                        htmlStr += "<tr ondblclick='rowDblClick(this)' onclick='rowsel(this)' style='cursor:pointer' class='apprLineTr'>" +
                            "		<td>" +
                            "			<input type='hidden' id='approveEmpSeq' name='approveEmpSeq' value='"+result[i].APPROVE_EMP_SEQ+"'>" +
                            "			<input type='hidden' id='approveEmpName' name='approveEmpName' value='"+result[i].APPROVE_EMP_NAME+"'>" +
                            "			<input type='hidden' id='approveDeptName' name='approveDeptName' value='"+result[i].APPROVE_DEPT_NAME+"'>" +
                            "			<input type='hidden' id='approvePositionName' name='approvePositionName' value='"+result[i].APPROVE_POSITION_NAME+"'>" +
                            "			<input type='hidden' id='approveDutyName' name='approveDutyName' value='"+result[i].APPROVE_DUTY_NAME+"'>" +
                            "			<span id='approveOrder'>"+result[i].APPROVE_ORDER+"</span>"+
                            "		</td>" +
                            "		<td>"+result[i].APPROVE_EMP_NAME+"</td>" +
                            "		<td>"+result[i].APPROVE_DEPT_NAME+"</td>" +
                            "		<td>"+result[i].APPROVE_POSITION_NAME+"</td>" +
                            "		<td>"+result[i].APPROVE_DUTY_NAME+"</td>" +
                            "	</tr>";

                        $("#approvalLineDataTb tbody").append(htmlStr);
                    }
                }
            })
        }
    }

    function rowsel(e){
        if($(e).hasClass("apprLineTr")){
            $(".apprLineTr").removeClass("active");
            $(e).addClass("active");
        }else{
            $(".cooperationLineTr").removeClass("active");
            $(e).addClass("active");
        }
    }

    function rowDblClick(e){
        if($(e).hasClass("apprLineTr")){
            if($(e).find("#approveOrder").text() == "0"){
                alert("기안자는 삭제하실 수 없습니다.");
                return;
            }
            $(e).remove();

            $.each($("#approvalLineDataTb tbody tr"), function(i, e){
                $(e).find("#approveOrder").text(i);
            })
        }else{
            $(e).remove();

            $.each($("#cooperationLineDataTb tbody tr"), function(i, e){
                $(e).find("#cooperationOrder").text(i+1);
            })
        }
    }

    function apprLineUpdate(mode, i){
        if(i == 0){
            $.each($("#approvalLineDataTb tbody tr"), function(i, e){
                if($(e).hasClass("active")){
                    if(i == 0 || (i-1 == 0 && mode == "up") || (i+1 == 1 && mode == "down")){
                        alert("기안자는 변경하실 수 없습니다.");
                    }else{
                        if(mode == "up"){
                            $(e).prev().before($(e));
                        }else{
                            $(e).next().after($(e));
                        }
                    }
                }
            });
            $.each($("#approvalLineDataTb tbody tr"), function(i, e){
                $(e).find("#approveOrder").text(i);
            })
        }else{
            $.each($("#cooperationLineDataTb tbody tr"), function(i, e){
                if($(e).hasClass("active")){
                    if(mode == "up"){
                        $(e).prev().before($(e));
                    }else{
                        $(e).next().after($(e));
                    }
                }
            });
            $.each($("#cooperationLineDataTb tbody tr"), function(i, e){
                $(e).find("#cooperationOrder").text(i);
            })
        }
    }

    function apprLineSave(){
        var flag = true;
        if($("#approvalLineDataTb tbody tr").length == 1){
            alert("결재선을 추가해주세요.");
            flag = false;
            return;
        }

        approversArr = [];
        cooperationsArr = [];
        opener.parent.drafterArrAdd();

        /** 결재선 */
        $.each($("#approvalLineDataTb tbody tr"), function(){
            var data = {
                approveEmpSeq : $(this).find("#approveEmpSeq").val(),
                approveEmpName : $(this).find("#approveEmpName").val(),
                approvePositionName : $(this).find("#approvePositionName").val(),
                approveDutyName : $(this).find("#approveDutyName").val(),
                approveDeptName : $(this).find("#approveDeptName").val(),
                approveOrder : $(this).find("#approveOrder").text(),
            }
            approversArr.push(data);
        });

        /** 협조 */
        $.each($("#cooperationLineDataTb tbody tr"), function(){
            var data = {
                cooperationEmpSeq : $(this).find("#cooperationEmpSeq").val(),
                cooperationEmpName : $(this).find("#cooperationEmpName").val(),
                cooperationPositionName : $(this).find("#cooperationPositionName").val(),
                cooperationDutyName : $(this).find("#cooperationDutyName").val(),
                cooperationDeptName : $(this).find("#cooperationDeptName").val(),
                cooperationOrder : $(this).find("#cooperationOrder").text(),
            }
            cooperationsArr.push(data);
        });

        opener.lastApprover = {
            approveEmpSeq : $("#approvalLineDataTb tbody tr:last").find("#approveEmpSeq").val(),
            approveEmpName : $("#approvalLineDataTb tbody tr:last").find("#approveEmpName").val(),
            approvePositionName : $("#approvalLineDataTb tbody tr:last").find("#approvePositionName").val(),
            approveDutyName : $("#approvalLineDataTb tbody tr:last").find("#approveDutyName").val(),
        }

        opener.approversArr = approversArr;
        opener.cooperationsArr = cooperationsArr;

        opener.parent.editorHtml();

        window.close();
    }

    function onDataBound(){
        var grid = this;

        grid.tbody.find("tr").dblclick(function (e) {
            var dataItem = grid.dataItem($(this));
            addTable(dataItem.FAV_ROUTE_ID, "favClick");
        });
    }

    function newFavApprove(){
        if(confirm("선택된 결재선은 초기화됩니다. 계속하시겠습니까?")){
            $("#approvalLineDataTb tbody tr:not(:eq(0))").remove();
            approversArr = [];
            opener.approversArr = [];
            opener.parent.drafterArrAdd();
            approversArr = opener.approversArr;
        }
    }
</script>
</body>
</html>