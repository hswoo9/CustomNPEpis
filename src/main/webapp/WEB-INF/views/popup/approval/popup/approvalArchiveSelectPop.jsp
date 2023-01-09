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
    body{
        font-family: Dotum,'돋움',Gulim,'굴림',sans-serif;
        font-size : 12px;
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
    .pop_con {
        padding: 20px 16px;
    }
    .top_box{
        position: relative;
        background: #f0f6fd;
        border: 1px solid #dcdcdc;
    }
    .top_box dl dt {
        font-weight: bold;
        color: #4a4a4a;
        font-size: 12px;
        float: left;
        line-height: 28px;
        margin-right: 10px;
        margin-left: 13px;
    }

    .top_box .top_box_in {
        margin: 15px 19px;
    }

    .fwb{
        font-weight: bold !important;
    }
    .lh16{
        font-size: 12px;
        line-height: 16px !important;
    }
    .tit_p {
        font-weight: bold;
        margin-bottom: 13px;
        padding-left: 12px;
        font-size: 12px;
        margin-top: 20px;
    }
    .treeViewDiv{
        border: 1px solid #dcdcdc;
    }

    .k-treeview .k-i-collapse:before{background: url("/images/ico/ico_organ03_open.png");content: "";}
    .k-treeview .k-i-expand:before{background: url("/images/ico/ico_organ03_close.png");content: "";}
    .k-treeview .k-treeview-top.k-treeview-bot .k-i-collapse:before{background: url("/images/ico/ico_organ01.png")}
    .k-treeview .k-treeview-top.k-treeview-bot .k-i-expand:before{background: url("/images/ico/ico_organ01.png")}

    .k-treeview .k-i-collapse-disabled, .k-treeview .k-i-expand-disabled {
        cursor: default
    }
    .k-treeview .k-treeview-top, .k-treeview .k-treeview-mid, .k-treeview .k-treeview-bot {
        background-image: url('/images/bg/treeview-nodes.png');
        background-repeat: no-repeat;
        margin-left: -16px;
        padding-left: 16px;
    }
    .k-treeview .k-item { background-image: url('/images/bg/treeview-line.png'); }
    .k-treeview .k-last { background-image: none; }
    .k-treeview .k-treeview-top { background-position: -91px 0; }
    .k-treeview .k-treeview-bot { background-position: -69px -17px; }
    .k-treeview .k-treeview-mid { background-position: -47px -42px; }
    /*.k-treeview .k-last .k-treeview-top { background-position: -25px -62px; }*/
    .k-treeview .k-group .k-last .k-treeview-bot { background-position: -69px -22px; }
    .k-treeview .k-item {
        background-repeat: no-repeat;
        font-size: 12px;
        line-height: 1.5;
    }
    .k-treeview .k-treeview-top.k-treeview-bot{background: none;}

    .k-treeview .k-first {
        background-repeat: no-repeat;
        background-position: 0 16px;
    }

    .formTable {
        border-top: 2px solid #000;
        border-collapse: collapse;
        border-spacing: 0;
    }

    .formTable table th, .formTable table td {
        padding: 0px;
        height: 30px;
        border: 1px solid #e1e1e1;
        word-break: break-all;
        text-align: center;
    }

    .formTable table th {
        font-weight: bold;
        background: #f0f0f0;
        color: #000;
    }
    .th-color{
        background-color: #d2e2f3;
    }
    .k-list-item{
        display: inline-block;
    }
</style>
</head>
<body>
<div class="pop_head">
    <h1>기록물철 선택 (${fn:substring(toDate, 0, 4)}년도)</h1>
    <a href="#n" class="clo"><img src="<c:url value='/images/btn/btn_pop_clo01.png'/>" alt=""></a>
</div>

<div class="pop_con">
    <div class="top_box" style="border-radius:initial">
        <div class="top_box_in lh16 fwb">
            <dl>
                <dt>
                    검색
                </dt>
                <dd>
                    <input type="text" class="k-input k-textbox k-input-solid k-input-md k-rounded-md" name="keyword" id="keyword" style="width: 80%">
                    <button type="button" class="k-button k-button-md k-rounded-md k-button-solid k-button-solid-base" onclick="gridReload()">
                        <span class="k-icon k-i-search k-button-icon"></span>
                    </button>
                </dd>
            </dl>
        </div>
    </div>

    <div class="k-mt-5 treeViewDiv" style="height: 350px">
        <div id="treeView" style="padding: 10px;"></div>
    </div>

    <div>
        <p class="tit_p">· 선택한 기록물철 정보</p>
    </div>
    <div class="formTable" style="margin-top: 10px">
        <table width="100%">
            <colgroup>
                <col/>
                <col width="30%" />
                <col width="15%" />
            </colgroup>
            <thead>
            <tr>
                <th>기록물철명</th>
                <th>분류</th>
                <th>보존기간</th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td class="al pl10" id="r_title"></td>
                <td class="ac" id="r_type"></td>
                <td class="ac" id="r_remainDt"></td>
            </tr>
            </tbody>
        </table>
    </div>


    <div class="mt-10" style="text-align: right">
        <button type="button" class="k-grid-button k-button k-button-md k-rounded-md k-button-solid k-button-solid-base" onclick="SetArchive()" style="background-color: #1088e3 !important;color: white;">
            <span class="k-button-text">선택</span>
        </button>
        <button type="button" class="k-grid-button k-button k-button-md k-rounded-md k-button-solid k-button-solid-base" onclick="window.close()">
            <span class="k-button-text">닫기</span>
        </button>
    </div>
</div>

<script>
    var content_type = "";
    var datas = JSON.parse('${data}');
    var selData;

    $("#treeView").kendoTreeView({
        dataSource: datas,
        dataTextField:['name'],
    });

    $(".k-treeview-item.k-first .k-treeview-group .k-treeview-leaf").on("click", function(){
        var item = $("#treeView").data("kendoTreeView").dataItem($(this));
        if(item.contenttype == "a"){
            fn_setJT(item);
        }
    })

    function fn_setJT(item){
        if(item != null) {
            selData = item;
            $("#r_title").text(item.text);
            $("#r_type").text(item.type);
            $("#r_remainDt").text(item.reDate);
            content_type = item.gbn_org;
        }else{
            selData = null;
            $("#r_title").text("");
            $("#r_type").text("");
            $("#r_remainDt").text("");
            content_type = "";
        }
    }

    function SetArchive(){
        if(!selData){
            alert("기록물철을 선택해주세요.");
            return;
        }
        $("#aiKeyCode", opener.parent.document).val(selData.aiKeyCode);
        $("#aiTitle", opener.parent.document).val(selData.name);

        window.close();
    }

</script>
</body>
</html>