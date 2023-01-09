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
    /** @font-face{font-family:"Arial_Unicode_MS_Font";src:url(/css/Arial_Unicode_MS_Font.ttf) format("truetype")} **/
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
    .th-color{
        background-color: #d2e2f3;
    }
    .k-list-item{
        display: inline-block;
    }
    .k-column-resize-handle-wrapper, .k-row-resize-handle-wrapper, .k-element-resize-handle-wrapper{
        display: none !important;
    }
    #approveDocContent{
        font-family: 'Arial_Unicode_MS_Font' !important;
    }

    .iframe_wrap {
        padding: 0px !important;
    }

    .location_info {
        display: none;
    }

    .k-input {
        border: 1px solid #bbb !important;
        width: 100%;
    }
</style>
</head>
<body>
<div class="pop_head">
    <h1>문서 상신</h1>
    <a href="#n" class="clo"><img src="<c:url value='/Images/btn/btn_pop_clo01.png'/>" alt=""></a>
</div>
<div style="padding: 20px">
    <input type="hidden" id="empSeq" name="empSeq" value="${loginVO.uniqId}">
    <input type="hidden" id="contentId" name="contentId" value="${params.contentId}">
    <input type="hidden" id="contentValue" name="contentValue" value="${params.contentValue}">
    <div class="mb-10" id="btnDiv" style="text-align: right;">
        <button type="button" id="draftBtn" name="draft" class="k-button k-button-md k-rounded-md k-button-solid k-button-solid-base draft" onclick="draftInitValidation(this)">
            <span class="k-button-text">상신</span>
        </button>

        <button type="button" class="k-grid-button k-button k-button-md k-rounded-md k-button-solid k-button-solid-base" onclick="window.close()">
            <span class="k-button-text">닫기</span>
        </button>
    </div>

    <input type="hidden" id="menuCd" name="menuCd" value="${params.menuCd}">
    <input type="hidden" id="atFileSn" name="atFileSn">
    <input type="hidden" id="docId" name="docId">
    <div class="card-header" style="padding:20px 0; display: none;">
        <h3 class="card-title">첨부파일</h3>
        <div class="card-options">
            <div class="filebox">
                <label for="mpf" class="k-grid-button k-button k-button-md k-rounded-md k-button-solid k-button-solid-base" style="margin:0 0 0 5px; height:auto;font-size: 13px">파일첨부</label>
                <input type="file" id="mpf" name="mpf" class="hidden" onchange="multipleChange(this)" multiple />
            </div>
        </div>
    </div>
    <div>
        <div style="display: none;">
            <table class="table table-bordered mb-70">
                <colgroup>
                    <col width="50%">
                    <col width="10%">
                    <col width="30%">
                    <col width="10%">
                </colgroup>
                <thead>
                <tr class="text-center th-color">
                    <th>파일명</th>
                    <th>확장자</th>
                    <th>용량</th>
                    <th>기타</th>
                </tr>
                </thead>
                <tbody id="fileGrid">
                <tr>
                    <td colspan="4" style="text-align: center">선택된 파일이 없습니다.</td>
                </tr>
                </tbody>
            </table>
        </div>
        <div id="approveDocContent" name="approveDocContent" style="height: 842px;"></div>
    </div>
</div>

<script>
    console.log("loginVo : ${loginVO}");
    var type = "${params.type}";
    var docInfo;
    var approversArr = new Array();
    var cooperationsArr = new Array();
    var lastApprover = [];
    var originalApproversArr = new Array();
    var originalCooperationsArr = new Array();
    var attFiles;
    var editor;

    //$("#docTitle").kendoTextBox();

    CKEDITOR.replace(approveDocContent, {
        extraPlugins : 'autogrow',
        autoGrow_onStartup : true,
        uiColor: '#9AB8F3'
    });

    CKEDITOR.instances.approveDocContent.setData('${fn:trim(fn:replace(fn:replace(params.docContent, LF, ""), CR, ""))}');

    editor = CKEDITOR.instances.approveDocContent;

    //첨부파일
    function multipleChange(e) {
        attFiles = $(e)[0].files;

        var html = '';
        for(var i = 0 ; i < attFiles.length ; i++){
            html += '<tr style="text-align: center">';
            html += '   <td>'+ attFiles[i].name.split(".")[0]+'</td>';
            html += '   <td>'+ attFiles[i].name.split(".")[1]+'</td>';
            html += '   <td>'+ attFiles[i].size+'</td>';
            html += '   <td>';
            html += '       <input type="button" onclick="fnDocFileDel('+i+')" value="삭제">'
            html += '   </td>';
            html += '</tr>';
        }

        if(!$("#docId").val()){
            $("#fileGrid").html(html);
        }else{
            $("#fileGrid").append(html);
        }
    }

    //결재선 지정
    function editorHtml(){
        /** ckEditor */
        $(editor.document.$.getElementById("apprLineTr")).find("th").not(".draftingInfo").text("");
        $(editor.document.$.getElementById("apprLineTr")).next().find("th").not(":eq(0)").text("");
        $(editor.document.$.getElementById("apprLineTr")).next().next().find("th").not(":eq(0)").text("");

        /** ckEditor */
        $(editor.document.$.getElementById("cooperationLineTr")).find("th").not(":eq(0)").text("");
        $(editor.document.$.getElementById("cooperationLineTr")).next().find("th").text("");
        $(editor.document.$.getElementById("cooperationLineTr")).next().next().find("th").text("");

        for(var i = 1; i < approversArr.length; i++){

            var inputDuty = '<p style="margin: 0">'+ approversArr[i].approveDutyName +'</p>';
            var inputEmpName = '<p style="margin: 0">'+ approversArr[i].approveEmpName +'</p>';

            /** ckEditor */
            $($(editor.document.$.getElementById("apprLineTr")).find("th").not(":eq(0)")[i]).html(inputDuty);
            $($(editor.document.$.getElementById("apprLineTr")).next().next().find("th")[i]).html(inputEmpName);

            var inputEmpSeq = "";
            if(type == "drafting") {
                inputEmpSeq += '<p style="margin: 0" id="' + approversArr[i].approveEmpSeq + '"></p>';
            }else{
                if(approversArr[i].approveDt != null){
                    inputEmpSeq += '<p style="margin: 0" id="' + approversArr[i].approveEmpSeq + '">'+approversArr[i].approveDt+'</p>';
                }else{
                    inputEmpSeq += '<p style="margin: 0" id="' + approversArr[i].approveEmpSeq + '"></p>';
                }

            }

            /** ckEditor */
            $($(editor.document.$.getElementById("apprLineTr")).next().find("th")[i]).html(inputEmpSeq);
        }

        for(var i = 0; i < cooperationsArr.length; i++){
            var inputDuty = '<p style="margin: 0">'+ cooperationsArr[i].cooperationDutyName +'</p>';
            var inputEmpName = '<p style="margin: 0">'+ cooperationsArr[i].cooperationEmpName +'</p>';

            /** ckEditor */
            $($(editor.document.$.getElementById("cooperationLineTr")).find("th").not(":eq(0)")[i]).html(inputDuty);
            $($(editor.document.$.getElementById("cooperationLineTr")).next().next().find("th")[i]).html(inputEmpName);

            var inputEmpSeq = "";
            if(type == "drafting") {
                inputEmpSeq += '<p style="margin: 0" id="'+cooperationsArr[i].cooperationEmpSeq+'"></p>';
            }else{
                if(cooperationsArr[i].cooperationDt != null){
                    inputEmpSeq += '<p style="margin: 0" id="'+cooperationsArr[i].cooperationEmpSeq+'">'+ cooperationsArr[i].cooperationDt +'</p>';
                }else{
                    inputEmpSeq += '<p style="margin: 0" id="'+cooperationsArr[i].cooperationEmpSeq+'"></p>';
                }
            }
            /** ckEditor */
            $($(editor.document.$.getElementById("cooperationLineTr")).next().find("th")[i]).html(inputEmpSeq);
        }
    }
    var windowPopUrl = "";
    var popName = "";
    var popStyle ="";

    function approvalLinePop(){
        windowPopUrl = "/approval/approvalLineSettingPop.do";
        popName = "approvalLineSetting";
        popStyle ="width=1365, height=620, scrollbars=no, top=100, left=200, resizable=no, toolbars=no, menubar=no";

        window.open(windowPopUrl, popName, popStyle);
    }

    function archiveSelectPop(){
        windowPopUrl = "/approval/approvalArchiveSelectPop.do";
        popName = "approvalArchiveSelect";
        popStyle ="width=610, height=670, scrollbars=no, top=100, left=200, resizable=no, toolbars=no, menubar=no";

        window.open(windowPopUrl, popName, popStyle);
    }

    drafterArrAdd();
    function drafterArrAdd(){
        approversArr.unshift({
            approveEmpSeq : '${loginVO.uniqId}',
            approveEmpName : '${loginVO.name}',
            approveStatCodeDesc : "",
            approveStatCode : "",
            approvePositionName : '${loginVO.positionNm}',
            approveDutyName : '${loginVO.classNm}',
            approveDeptName : '${loginVO.orgnztNm}',
            approveOrder : '0',
            approveType : "approve"
        });
    }

    setTimeout(() => getCreatePdfSetting(), 500);
    function getCreatePdfSetting(){
        html2canvas(editor.document.$.getElementById("approvalDataDiv"), {
            logging : true,       // 디버그 목적 로그
            allowTaint : true, // cross-origin allow
            useCORS: true,    // CORS 사용한 서버로부터 이미지 로드할 것인지 여부
            scale : 4        // 기본 96dpi에서 해상도를 두 배로 증가
        }).then(function(canvas) {
            var imgData = canvas.toDataURL('image/jpeg');
            var imgWidth = 190; // 이미지 가로 길이(mm) / A4 기준 210mm
            var pageHeight = imgWidth * 1.414;  // 출력 페이지 세로 길이 계산 A4 기준
            var imgHeight = 285;
            /** 이미지 아래 여백 문제로 고정 */
                //canvas.height * imgWidth / canvas.width;
            var heightLeft = imgHeight;
            var margin = 10; // 출력 페이지 여백설정
            docInfo = new jsPDF('p', 'mm');
            var position = 0;
            console.log("canvas.height", canvas.height);
            console.log("canvas.width", canvas.width);
            console.log(canvas.height * imgWidth / canvas.width);
            console.log("imgWidth", imgWidth);
            console.log("imgHeight", imgHeight);
            // 첫 페이지 출력
            docInfo.addImage(imgData, "jpeg", margin, position, imgWidth, imgHeight);
            heightLeft -= pageHeight;

            // 한 페이지 이상일 경우 루프 돌면서 출력
            while (heightLeft >= 20) {       // 35
                position = heightLeft - imgHeight;
                position = position - 20 ;    // -25

                docInfo.addPage();
                docInfo.addImage(imgData, 'PNG', margin, position, imgWidth, imgHeight);
                heightLeft -= pageHeight;
            }
        });
    }

    if(type != "drafting"){
        approvalReferData('${params.docId}', $("#contentValue").val(), type);
    }

    function approvalReferData(docId, contentValue, type){
        $.ajax({
            url : getContextPath() + '/approval/getReferDocDataInfo.do',
            data : {
                docId : docId,
                cmCodeNm : type
            },
            dataType : "json",
            async : false,
            success : function (rs){
                var docFile =  rs.docFileList;
                var comCode = rs.comCode;
                var rs = rs.rs;

                var html = "";

                $("#contentValue").val(contentValue);

                $("#draftBtn").remove();
                $("#btnDiv").prepend("<input type='hidden' id='approveStatCode' name='approveStatCode' value='" + comCode.CM_CODE + "'>" +
                    "<input type='hidden' id='approveStatCodeDesc' name='approveStatCodeDesc' value='" + comCode.CM_CODE_NM + "'>" +
                    '<button type="button" id="draftBtn" name="draft" class="k-grid-button k-button k-button-md k-rounded-md k-button-solid k-button-solid-base referDraft" onclick="draftInitValidation(this)">' +
                    '  <span class="k-button-text">재상신</span>' +
                    '</button>');

                $("#atFileSn").val(rs.docInfo.ATFILE_SN);
                $("#docTitle").val(rs.docInfo.DOC_TITLE);
                $("#docId").val(rs.docInfo.DOC_ID);

                if(docFile.length > 0){
                    for(var i = 0; i < docFile.length; i++){
                        html += '<tr style="text-align: center">';
                        html += '   <td>'+ docFile[i].filename +'</td>';
                        html += '   <td>'+ docFile[i].FILE_EXT +'</td>';
                        html += '   <td>'+ docFile[i].FILE_SIZE +'</td>';
                        html += '   <td>';
                        html += '       <input type="button" onclick="fnDocFileDel('+ docFile[i].FILE_NO +')" value="삭제">'
                        html += '   </td>';
                        html += '</tr>';
                    }
                    $("#fileGrid").html(html);
                }

                for(var i = 0; i < rs.approveRoute.length; i++){
                    if(rs.approveRoute[i].APPROVE_ORDER != "0"){
                        var apprRoute = {
                            empSeq : $("#empSeq").val(),
                            approveEmpSeq : String(rs.approveRoute[i].APPROVE_EMP_SEQ),
                            approveEmpName : rs.approveRoute[i].APPROVE_EMP_NAME,
                            approveDeptName : rs.approveRoute[i].APPROVE_DEPT_NAME,
                            approvePositionName : rs.approveRoute[i].APPROVE_POSITION_NAME,
                            approveDutyName : rs.approveRoute[i].APPROVE_DUTY_NAME,
                            approveDt : rs.approveRoute[i].APPROVE_DT,
                            approveOrder : rs.approveRoute[i].APPROVE_ORDER,
                        }
                        approversArr.push(apprRoute);
                    }
                }
                originalApproversArr = approversArr;

                for(var i = 0; i < rs.cooperationRoute.length; i++){
                    if(rs.cooperationRoute[i].COOPERATION_ORDER != "0"){
                        var cooperationRoute = {
                            empSeq : $("#empSeq").val(),
                            cooperationEmpSeq : String(rs.cooperationRoute[i].COOPERATION_EMP_SEQ),
                            cooperationEmpName : rs.cooperationRoute[i].COOPERATION_EMP_NAME,
                            cooperationDeptName : rs.cooperationRoute[i].COOPERATION_DEPT_NAME,
                            cooperationPositionName : rs.cooperationRoute[i].COOPERATION_POSITION_NAME,
                            cooperationDutyName : rs.cooperationRoute[i].COOPERATION_DUTY_NAME,
                            cooperationDt : rs.cooperationRoute[i].COOPERATION_DT,
                            cooperationOrder : rs.cooperationRoute[i].COOPERATION_ORDER,
                        }
                        cooperationsArr.push(cooperationRoute);
                    }
                }
                originalCooperationsArr = cooperationsArr;

                setTimeout(() => editorHtml(), 100);
            }
        })
    }

    function draftInitValidation(e) {
        var flag = true;
        if(flag){
            if($(e).hasClass("draft")){
                if(confirm("상신하시겠습니까?")){
                    draftInit(e);
                }
            }
        }
    }

    function draftInit(e){
        var blob = docInfo.output('blob');

        var formData = new FormData();
        formData.append("type", "draft");
        formData.append("menuCd", $("#menuCd").val());
        formData.append("empSeq", $("#empSeq").val());

        formData.append($("#contentId").val(), $("#contentValue").val());
        formData.append("rmk", $(editor.document.$.getElementById("rmkPop")).text());
        /** kendo Editor
         *
         * $(editor.document.getElementById("rmkPop")).text()
         */

        formData.append("docTitle", $("#docTitle").val());
        formData.append("docContent", editor.getData());
        formData.append("cmCodeNm", $(e).attr("name"));
        formData.append("aiKeyCode", $("#aiKeyCode").val());

        //결재라인
        formData.append("approversArr", JSON.stringify(approversArr));
        //협조라인
        formData.append("cooperationsArr", JSON.stringify(cooperationsArr));

        //마지막 결재자
        formData.append("lastApproveEmpSeq", lastApprover.approveEmpSeq);

        //결재문서 blob
        formData.append("docFileName", "부서 사용자 이름 문서 번호.pdf");
        formData.append("docFilePdf", blob);

        $.ajax({
            url : getContextPath() + "/approval/setApproveDraftInit.do",
            type : 'post',
            data : formData,
            dataType : "json",
            contentType: false,
            processData: false,
            enctype : 'multipart/form-data',
            async : false,
            success : function (){
                alert("문서 상신이 완료되었습니다.");
                window.opener.gridReload();
                window.close();
            },
            error : function (){
                alert("문서 상신 중 오류가 발생했습니다.");
            }
        })
    }

    function referDraftInit(e){
        var blob = docInfo.output('blob');

        var formData = new FormData();
        formData.append("type", "refer");
        formData.append("menuCd", $("#menuCd").val());
        formData.append("empSeq", $("#empSeq").val());

        formData.append("docId", $("#docId").val());
        formData.append("atFileSn", $("#atFileSn").val());

        formData.append("approveStatCode", $("#approveStatCode").val());
        formData.append("approveStatCodeDesc", $("#approveStatCodeDesc").val());
        formData.append($("#contentId").val(), $("#contentValue").val());

        formData.append("docTitle", $("#docTitle").val());
        formData.append("docContent", editor.getData());
        formData.append("rmk", $(editor.document.$.getElementById("rmkPop")).text());
        /** kendo Editor
         *
         * $(editor.document.getElementById("rmkPop")).text()
         */

        const empSeqSort = function(a,b){
            if(a.approveEmpSeq < b.approveEmpSeq){
                return -1
            }else if(a.approveEmpSeq > b.approveEmpSeq){
                return 1;
            }else{
                return 0;
            }
        }

        originalApproversArr.sort(empSeqSort);
        originalCooperationsArr.sort(empSeqSort);
        approversArr.sort(empSeqSort);
        cooperationsArr.sort(empSeqSort);

        const compareArray = function(a, b){
            if(JSON.stringify(a) == JSON.stringify(b)){
                return "N";
            }else{
                return "Y";
            }
        }

        //결재라인
        formData.append("approversRouteChange", compareArray(originalApproversArr, approversArr));
        formData.append("approversArr", JSON.stringify(approversArr));

        //협조라인
        formData.append("cooperationsRouteChange", compareArray(originalCooperationsArr, cooperationsArr));
        formData.append("cooperationsArr", JSON.stringify(cooperationsArr));

        //마지막 결재자
        if(compareArray(originalApproversArr, approversArr) == "Y"){
            formData.append("lastApproveEmpSeq", lastApprover.approveEmpSeq);
        }

        //결재문서 blob
        formData.append("docFileName", "부서 사용자 이름 문서 번호.pdf");
        formData.append("docFilePdf", blob);

        //결재문서 관련 첨부파일
        if(attFiles != null){
            for(var i = 0; i < attFiles.length; i++){
                formData.append("mpf", attFiles[i]);
            }
        }

        $.ajax({
            url : getContextPath() + '/approval/setApproveDraftInit.do',
            type : 'POST',
            data : formData,
            dataType : "json",
            contentType: false,
            processData: false,
            enctype : 'multipart/form-data',
            async : false,
            success : function (){
                alert("문서 재상신이 완료되었습니다.");
                opener.parent.gridReload();
                window.close();
            },
            error : function (){
                alert("문서 재상신 중 오류가 발생했습니다.");
            }
        })
    }

    function referDraftInit(e){
        var blob = docInfo.output('blob');

        var formData = new FormData();
        formData.append("type", "refer");
        formData.append("menuCd", $("#menuCd").val());
        formData.append("empSeq", $("#empSeq").val());

        formData.append("docId", $("#docId").val());
        formData.append("atFileSn", $("#atFileSn").val());

        formData.append("approveStatCode", $("#approveStatCode").val());
        formData.append("approveStatCodeDesc", $("#approveStatCodeDesc").val());
        formData.append($("#contentId").val(), $("#contentValue").val());

        formData.append("docTitle", $("#docTitle").val());
        formData.append("docContent", editor.getData());
        formData.append("rmk", $(editor.document.$.getElementById("rmkPop")).text());
        /** kendo Editor
         *
         * $(editor.document.getElementById("rmkPop")).text()
         */

        const empSeqSort = function(a,b){
            if(a.approveEmpSeq < b.approveEmpSeq){
                return -1
            }else if(a.approveEmpSeq > b.approveEmpSeq){
                return 1;
            }else{
                return 0;
            }
        }

        originalApproversArr.sort(empSeqSort);
        originalCooperationsArr.sort(empSeqSort);
        approversArr.sort(empSeqSort);
        cooperationsArr.sort(empSeqSort);

        const compareArray = function(a, b){
            if(JSON.stringify(a) == JSON.stringify(b)){
                return "N";
            }else{
                return "Y";
            }
        }

        //결재라인
        formData.append("approversRouteChange", compareArray(originalApproversArr, approversArr));
        formData.append("approversArr", JSON.stringify(approversArr));

        //협조라인
        formData.append("cooperationsRouteChange", compareArray(originalCooperationsArr, cooperationsArr));
        formData.append("cooperationsArr", JSON.stringify(cooperationsArr));

        //마지막 결재자
        if(compareArray(originalApproversArr, approversArr) == "Y"){
            formData.append("lastApproveEmpSeq", lastApprover.approveEmpSeq);
        }

        //결재문서 blob
        formData.append("docFileName", "부서 사용자 이름 문서 번호.pdf");
        formData.append("docFilePdf", blob);

        //결재문서 관련 첨부파일
        if(attFiles != null){
            for(var i = 0; i < attFiles.length; i++){
                formData.append("mpf", attFiles[i]);
            }
        }

        $.ajax({
            url : getContextPath() + '/approval/setApproveDraftInit.do',
            type : 'POST',
            data : formData,
            dataType : "json",
            contentType: false,
            processData: false,
            enctype : 'multipart/form-data',
            async : false,
            success : function (){
                alert("문서 재상신이 완료되었습니다.");
                opener.parent.gridReload();
                window.close();
            },
            error : function (){
                alert("문서 재상신 중 오류가 발생했습니다.");
            }
        })
    }
</script>
</body>
</html>