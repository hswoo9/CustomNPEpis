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
    .pop_head{
        height: 40px;
        position: relative;
        background: #1385db;
    }
    .pop_head div h1 {
        font-size: 12px;
        color: #fff;
        line-height: 37px;
        padding-left: 16px;
    }
    #docControlBtnDiv{
        float: right;
        margin: 5px 5px 0 0;
    }
    .k-grid-norecords{
        justify-content: space-around;
    }

    .iframe_wrap {
        padding: 0px !important;
    }

    .location_info {
        display: none;
    }

    .k-button-solid-base {
        border-color: #bbb;
        color: #2e2e2e;
        background-color: #e9e9e9;
        background-image: linear-gradient(rgba(255,255,255,.1),rgba(255,255,255,0));
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
    }

    .k-textarea {
        height: 70px;
        width: 95%;
    }
</style>
</head>
<body>
<body>
<div class="pop_head">
    <div style="position: absolute;">
        <h1>결재 문서</h1>
    </div>
    <div id="docControlBtnDiv">

        <c:set var="flag" value="0"/>
        <c:forEach items="${rs.approveRoute}" var="item">
            <c:if test="${item.APPROVE_EMP_SEQ eq loginVO.uniqId and rs.docInfo.DRAFT_EMP_SEQ ne loginVO.uniqId}">
                <c:set var="flag" value="${flag + 1}"/>
            </c:if>
        </c:forEach>
        <script>
            console.log("${rs.STATUS}");
            console.log("${flag}");
            console.log("${rs.approveRoute}");
            console.log("기안자 = ${rs.docInfo.DRAFT_EMP_SEQ}");
            console.log("현재결재자 = ${rs.approveNowRoute.APPROVE_EMP_SEQ}");
            console.log("현재 로그인사용자 = ${loginVO.uniqId}");
        </script>
        <button type='button' class='k-button k-button-md k-rounded-md k-button-solid k-button-solid-base ApproveButton' onclick="approveKendoSetting();">
            <span class='k-icon k-i-track-changes-accept k-button-icon'></span>
            <span class='k-button-text'>결재</span>
        </button>
        <button type='button' class='k-button k-button-md k-rounded-md k-button-solid k-button-solid-base' onclick="docApprovePDFDown()">
            <!--<button type='button' class='k-button k-button-md k-rounded-md k-button-solid k-button-solid-base' onclick="docApprovePDFDown('one', '','')">-->
            <span class='k-icon k-i-file-pdf k-button-icon'></span>
            <span class='k-button-text'>PDF 저장</span>
        </button>
    </div>
</div>
<div class="pop_sign_wrap">
    <div id="approvalDocView" class="pop_wrap_dir" style="width: 100%;">
        <input type="hidden" id="docId" name="docId" value="${rs.docInfo.DOC_ID}">
        <input type="hidden" id="menuCd" name="menuCd" value="eval">
        <div id="approvalDataDiv" style="margin-top: 10px;">
            <div type="text" id="approveDocContent" name="approveDocContent"></div>
        </div>

        <%--결재문서 첨부파일 모달 --%>
        <div id="attachmentModal" class="pop_wrap_dir">
            <div id="attachmentModalGrid">

            </div>

            <div class="mt-15" style="text-align: right">
                <button type='button' class='k-button k-button-md k-rounded-md k-button-solid k-button-solid-base' onclick="$('#attachmentModal').data('kendoWindow').close();">
                    <span class='k-icon k-i-check k-button-icon'></span>
                    <span class='k-button-text'>확인</span>
                </button>
            </div>
        </div>

        <%--결재 모달 --%>
        <div id="approveModal" class="pop_wrap_dir">
            <input type="hidden" id="approveCode" name="approveCode">
            <input type="hidden" id="approveCodeNm" name="approveCodeNm">
            <table class="table table-bordered mb-0">
                <colgroup>
                    <col width="15%">
                    <col width="35%">
                </colgroup>
                <tbody>
                <tr>
                    <th class="text-center th-color"><span class="red-star">*</span>결재자</th>
                    <td>
                        <input type="hidden" id="approveEmpSeq" name="approveEmpSeq" value="${loginVO.uniqId}"/>
                        <input type="text" id="approveEmpName" name="approveEmpName" class="k-input k-textbox k-input-solid k-input-md k-rounded-md" value="${loginVO.name}"/>
                    </td>

                </tr>
                <tr>
                    <th class="text-center th-color"><span class="red-star">*</span>결재의견</th>
                    <td>
                        <textarea type="text" class="k-input k-textarea k-input-solid k-input-md k-rounded-md" id="approveOpin" name="approveOpin"></textarea>
                    </td>
                </tr>
                </tbody>
            </table>
            <div class="mt-15" style="text-align: right">
                <button type='button' class='k-button k-button-md k-rounded-md k-button-solid k-button-solid-base' onclick="docApprove('${rs.docInfo.DOC_ID}')">
                    <span class='k-icon k-i-check k-button-icon'></span>
                    <span class='k-button-text'>확인</span>
                </button>
                <button type='button' class='k-button k-button-md k-rounded-md k-button-solid k-button-solid-base' onclick="$('#approveModal').data('kendoWindow').close();">
                    <span class='k-icon k-i-cancel k-button-icon'></span>
                    <span class='k-button-text'>취소</span>
                </button>
            </div>
        </div>

        <%--반려 모달 --%>
        <div id="referModal" class="pop_wrap_dir">
            <input type="hidden" id="referCode" name="referCodeNm">
            <input type="hidden" id="referCodeNm" name="referCodeNm">
            <table class="table table-bordered mb-0">
                <colgroup>
                    <col width="15%">
                    <col width="35%">
                </colgroup>
                <tbody>
                <tr>
                    <th class="text-center th-color"><span class="red-star">*</span>반려자</th>
                    <td>
                        <input type="hidden" id="referEmpSeq" name="referEmpSeq" value="${loginVO.uniqId}"/>
                        <input type="text" id="referEmpName" name="referEmpName" value="${loginVO.name}"/>
                    </td>
                </tr>
                <tr>
                    <th class="text-center th-color"><span class="red-star">*</span>반려의견</th>
                    <td>
                        <textarea type="text" id="referOpin" name="referOpin"></textarea>
                    </td>
                </tr>
                </tbody>
            </table>
            <div class="mt-15" style="text-align: right">
                <button type='button' class='k-button k-button-md k-rounded-md k-button-solid k-button-solid-base' onclick="docRefer('${rs.docInfo.DOC_ID}')">
                    <span class='k-icon k-i-check k-button-icon'></span>
                    <span class='k-button-text'>확인</span>
                </button>
                <button type='button' class='k-button k-button-md k-rounded-md k-button-solid k-button-solid-base' onclick="$('#referModal').data('kendoWindow').close();">
                    <span class='k-icon k-i-cancel k-button-icon'></span>
                    <span class='k-button-text'>취소</span>
                </button>
            </div>
        </div>

        <%--의견보기 모달 --%>
        <div id="opinViewModal" class="pop_wrap_dir">
            <div id="opinViewModalGrid">

            </div>
            <div class="mt-15" style="text-align: right">
                <button type='button' class='k-button k-button-md k-rounded-md k-button-solid k-button-solid-base' onclick="$('#opinViewModal').data('kendoWindow').close();">
                    <span class='k-icon k-i-check k-button-icon'></span>
                    <span class='k-button-text'>확인</span>
                </button>
            </div>
        </div>

        <%--결재현황 모달 --%>
        <div id="approveHistModal" class="pop_wrap_dir">
            <div id="approveHistModalGrid">

            </div>
            <div class="mt-15" style="text-align: right">
                <button type='button' class='k-button k-button-md k-rounded-md k-button-solid k-button-solid-base' onclick="$('#approveHistModal').data('kendoWindow').close();">
                    <span class='k-icon k-i-check k-button-icon'></span>
                    <span class='k-button-text'>확인</span>
                </button>
            </div>
        </div>
    </div>
</div>
</body>
<script>
    CKEDITOR.replace(approveDocContent, {
        toolbar : [],
        extraPlugins : 'autogrow',
        autoGrow_onStartup : true,
        uiColor: '#9AB8F3'
    });

    var editor = CKEDITOR.instances.approveDocContent;
    var docInfo;

    CKEDITOR.instances.approveDocContent.setData('${fn:trim(fn:replace(fn:replace(rs.DOC_CONTENT, LF, ""), CR, ""))}');
    setTimeout(() => $(editor.document.$.getElementById("rmkPop")).attr("contenteditable", false), 300);


    <%--$("#approveDocContent").kendoEditor({--%>
    <%--    value: '${fn:trim(fn:replace(fn:replace(rs.docInfo.DOC_CONTENT, LF, ""), CR, ""))}',--%>
    <%--    encoded: false,--%>
    <%--    pdf : {--%>
    <%--        //keywords: "문서 종류(속성 - 키워드)",--%>
    <%--        //fileName: "문서이름",--%>
    <%--        //title : "제목(파일 열었을때 상단 이름, 속성 직책)",--%>
    <%--        //subject : "서브제목(속성 - 제목)",--%>
    <%--        //author : "작성자(속성 - 작성자)",--%>
    <%--        //creator: "작성자(속성 - 애플리케이션)",--%>
    <%--        paperSize : "A4"--%>
    <%--    }--%>
    <%--})--%>

    //var editor = $("#approveDocContent").data("kendoEditor");

    if (String("${rs.STATUS}") == "100") {
        $(".ApproveButton").hide();
    }

    var emp_seq = "${loginVO.uniqId}";
    var erpEmpCd = "${loginVO.erpEmpCd}";
    if (String(emp_seq) == "1" || String(erpEmpCd) == "160201001" || String(erpEmpCd) == "180319013" || String(erpEmpCd) == "120917004" || String(erpEmpCd) == "120523007" || String(erpEmpCd) == "120523022") {
    } else {
        $(".ApproveButton").hide();
    }

    /* TODO. 2022.07.28 결재 모달 생성 */
    $("#attachmentModal").kendoWindow({
        title: "첨부파일",
        visible: false,
        modal: true,
        width : 500,
        position : {
            top : 50,
            left : 255
        },
        close: function () {
            $("#attachmentModal").load(location.href + ' #attachmentModal');
        }
    });

    $("#approveModal").kendoWindow({
        title: "결재의견",
        visible: false,
        modal: true,
        width : 500,
        position : {
            top : 50,
            left : 255
        },
        close: function () {
            $("#approveModal").load(location.href + ' #approveModal');
        }
    });

    $("#referModal").kendoWindow({
        title: "반려의견",
        visible: false,
        modal: true,
        width : 500,
        position : {
            top : 50,
            left : 255
        },
        close: function () {
            $("#referModal").load(location.href + ' #referModal');
        }
    });

    $("#opinViewModal").kendoWindow({
        title: "의견보기",
        visible: false,
        modal: true,
        width : 800,
        position : {
            top : 50,
            left : 100
        },
        close: function () {
            $("#opinViewModal").load(location.href + ' #opinViewModal');
        }
    });

    $("#approveHistModal").kendoWindow({
        title: "결재현황",
        visible: false,
        modal: true,
        width : 800,
        position : {
            top : 50,
            left : 100
        },
        close: function () {
            $("#approveHistModal").load(location.href + ' #approveHistModal');
        }
    });

    <c:if test="${rs.approveNowRoute.APPROVE_EMP_SEQ eq loginVO.uniqId and rs.docInfo.DRAFT_EMP_SEQ ne loginVO.uniqId}">
    $.ajax({
        url : getContextPath() + "/approval/setDocApproveRouteReadDt.do",
        data : {
            docId : "${rs.docInfo.DOC_ID}",
            empSeq : "${loginVO.uniqId}",
        },
        dataType : "json",
        type : "POST",
        success : function(){}
    });
    </c:if>

    /** 승인 프로세스 */
    function docApprove(e){
        getCreatePdfSetting();
        setTimeout(() => docApproveAjax(e), 200);
    }

    function docApproveAjax(e){
        $.ajax({
            url : getContextPath() + "/approval/setDocApproveNRefer.do",
            type : "POST",
            data : makeApprovalFormData(e, "${params.id}", "approve"),
            dataType : "json",
            contentType: false,
            processData: false,
            enctype : 'multipart/form-data',
            async : false,
            success : function(){
                alert("결재되었습니다.");
                window.opener.gridReload();
                location.reload();
            },
            error : function(){
                alert("결재 중 에러가 발생했습니다.");
            }
        })
    }

    function approveKendoSetting(){
        var e = "";

        <c:choose>
        <c:when test="${rs.docInfo.LAST_APPROVE_EMP_SEQ ne loginVO.uniqId}">e = "approve"</c:when>
        <c:when test="${rs.docInfo.LAST_APPROVE_EMP_SEQ eq loginVO.uniqId}">e = "finalApprove"</c:when>
        </c:choose>

        $('#approveEmpName').attr('readonly', false);

        //("#approveOpin").kendoTextArea({
        //    rows:5,
        //    cols:10,
        //    resizable: "vertical"
        //});

        //$.ajax({
        //    url : getContextPath() + '/approval/getCmCodeInfo.do',
        //    data : {
        //        cmCodeNm : e,
        //    },
        //    dataType : "json",
        //    type : "POST",
        //    async : false,
        //    success : function(rs){
        //        var rs = rs.rs;
        //        $("#approveCode").val(rs.CM_CODE);
        //        $("#approveCodeNm").val(rs.CM_CODE_NM);
        //    }
        //})

        $('#approveModal').data('kendoWindow').open();
    }

    /** 반려 프로세스 */
    function docRefer(e){
        getCreatePdfSetting();
        setTimeout(() => docReferAjax(e), 200);
    }

    function docReferAjax(e){
        $.ajax({
            url : getContextPath() +"/approval/setDocApproveNRefer.do",
            type : "POST",
            data : makeApprovalFormData(e, "${params.id}", "refer"),
            dataType : "json",
            contentType: false,
            processData: false,
            enctype : 'multipart/form-data',
            async : false,
            success : function(){
                alert("반려되었습니다.");
                window.opener.gridReload();
                location.reload();
            },
            error : function(){
                alert("반려 중 에러가 발생했습니다.");
            }
        })
    }

    function referKendoSetting(){
        $("#referEmpName").kendoTextBox({
            readonly : true
        });
        $("#referOpin").kendoTextArea({
            rows:5,
            cols:10,
            resizable: "vertical"
        });

        $.ajax({
            url : getContextPath() + '/approval/getCmCodeInfo.do',
            data : {
                cmCodeNm : "refer",
            },
            dataType : "json",
            type : "POST",
            async : false,
            success : function(rs){
                var rs = rs.rs;
                $("#referCode").val(rs.CM_CODE);
                $("#referCodeNm").val(rs.CM_CODE_NM);
            }
        })

        $('#referModal').data('kendoWindow').open();
    }

    /** 의견보기 */
    function docApproveOpinView(e){
        var opinViewModalGridSource = new kendo.data.DataSource({
            serverPaging: false,
            transport: {
                read : {
                    url : getContextPath() + '/approval/getDocApproveHistOpinList.do',
                    dataType : "json",
                    type : "post"
                },
                parameterMap: function(data, operation) {
                    data.docId = e;
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
            }
        });

        $("#opinViewModalGrid").kendoGrid({
            dataSource: opinViewModalGridSource,
            height: 315,
            toolbar : [
                {
                    name : 'excel',
                    text: '엑셀다운로드'
                }
            ],
            excel : {
                fileName : "결재의견 목록.xlsx",
                filterable : true
            },
            noRecords: {
                template: "데이터가 존재하지 않습니다."
            },
            columns: [
                {
                    field : "APPROVE_STAT_CODE",
                    title: "구분",
                    template : function (e){
                        if(e.APPROVE_STAT_CODE == "20"){
                            return "결재의견";
                        }else if(e.APPROVE_STAT_CODE == "30"){
                            return "반려의견";
                        }else if(e.APPROVE_STAT_CODE == "100"){
                            return "최종결재의견";
                        }
                    }
                }, {
                    field : "APPROVE_EMP_NAME",
                    title: "작성자",
                },{
                    field : "APPROVE_OPIN",
                    title: "의견",
                },{
                    field : "APPROVE_DT",
                    title: "작성일",
                }]
        }).data("kendoGrid");

        $("#opinViewModal").data("kendoWindow").open();
    }

    /** 결재 현황 보기 */
    function docApproveRouteHistView(e){
        var approveHistModalGridSource = new kendo.data.DataSource({
            serverPaging: false,
            transport: {
                read : {
                    url : getContextPath() + '/approval/getDocApproveStatusHistList.do',
                    dataType : "json",
                    type : "post"
                },
                parameterMap: function(data, operation) {
                    data.docId = e;
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
            }
        });

        $("#approveHistModalGrid").kendoGrid({
            dataSource: approveHistModalGridSource,
            height: 315,
            toolbar : [
                {
                    name : 'excel',
                    text: '엑셀다운로드'
                }
            ],
            excel : {
                fileName : "결재현황.xlsx",
                filterable : true
            },
            noRecords: {
                template: "데이터가 존재하지 않습니다."
            },
            columns: [
                {
                    field : "GUBUN",
                    title: "구분",
                }, {
                    field : "APPROVE_EMP_NAME",
                    title: "이름",
                },{
                    field : "APPROVE_DEPT_NAME",
                    title: "부서",
                },{
                    field : "APPROVE_DUTY_NAME",
                    title: "직책(직위)",
                },{
                    field : "DOC_READ_DT",
                    title: "열람일시",
                },{
                    field : "APPROVE_DT",
                    title: "결재일시",
                },{
                    field : "APPROVE_STAT_CODE_DESC",
                    title: "상태",
                }]
        }).data("kendoGrid");

        $("#approveHistModal").data("kendoWindow").open();
    }

    function docAttachmentDown(){
        var grid = $("#attachmentModalGrid").data("kendoGrid");

        if($("input[name=filePk]:checked").length == 0){
            alert("다운로드할 파일을 선택해주세요.");
            return;
        }else if($("input[name=filePk]:checked").length == 1){
            var dataItem = grid.dataItem($("input[name=filePk]:checked").closest("tr"));
            docApprovePDFDown('one', dataItem.FILE_DOWN_PATH+dataItem.fileUUID, dataItem.filename);
        }else{
            docApprovePDFDown('zip', $("#docId").val());
        }
    }

    /**
     * 결재문서 PDF 파일 다운로드
     * type = 단일(one), 압축(zip)
     * e = 프로젝트 내 경로 webapp 이후 경로 /upload
     * n = 다운로드할 파일 이름
     * */
    function docApprovePDFDown(){

        $(editor.document.$.getElementById("${loginVO.uniqId}")).text('${today}');
        html2canvas(editor.document.$.getElementById("approvalDataDiv"), {
            allowTaint : true,	// cross-origin allow
            logging : true,		// 디버그 목적 로그
            useCORS: true,		// CORS 사용한 서버로부터 이미지 로드할 것인지 여부
            scale : 4			// 기본 96dpi에서 해상도를 두 배로 증가
        }).then(function(canvas) {
            var imgData = canvas.toDataURL('image/jpeg');
            var imgWidth = 190; // 이미지 가로 길이(mm) / A4 기준 210mm
            var pageHeight = imgWidth * 1.414;  // 출력 페이지 세로 길이 계산 A4 기준
            var imgHeight = canvas.height * imgWidth / canvas.width;
            var heightLeft = imgHeight;
            var margin = 10; // 출력 페이지 여백설정
            docInfo = new jsPDF('p', 'mm');
            var position = 0;

            // 첫 페이지 출력
            docInfo.addImage(imgData, "jpeg", margin, position, imgWidth, imgHeight);
            heightLeft -= pageHeight;

            // 한 페이지 이상일 경우 루프 돌면서 출력
            while (heightLeft >= 20) {			// 35
                position = heightLeft - imgHeight;
                position = position - 20 ;		// -25

                docInfo.addPage();
                docInfo.addImage(imgData, 'PNG', margin, position, imgWidth, imgHeight);
                heightLeft -= pageHeight;
            }
            docInfo.save('구성요청서.pdf');
        });

    }

    function docApprovePDFDown2(type, e, n){
        var dataURI = e;
        if(type == "one"){
            kendo.saveAs({
                dataURI: dataURI,
                fileName: n,
            });
            //editor.saveAsPDF();
        }else if(type == "zip"){
            dataURI = "/common/multiFileDownload.do?docId="+e+"&type=approval";
            kendo.saveAs({
                dataURI: dataURI
            });
        }
    }

    function docApprovePDFDown_test() {
        var divContents = $("#approveDocContent").val();
        var printWindow = window.open('', '', 'height=400,width=800');
        printWindow.document.write('<html><head><title>DIV Contents</title>');
        printWindow.document.write('</head><body >');
        printWindow.document.write(divContents);
        printWindow.document.write('</body></html>');
        printWindow.document.close();
        printWindow.print();
    }

    function getCreatePdfSetting(){
        $(editor.document.$.getElementById("${loginVO.uniqId}")).text('${today}');
        html2canvas(editor.document.$.getElementById("approvalDataDiv"), {
            allowTaint : true,	// cross-origin allow
            logging : true,		// 디버그 목적 로그
            useCORS: true,		// CORS 사용한 서버로부터 이미지 로드할 것인지 여부
            scale : 4			// 기본 96dpi에서 해상도를 두 배로 증가
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

            // 첫 페이지 출력
            docInfo.addImage(imgData, "jpeg", margin, position, imgWidth, imgHeight);
            heightLeft -= pageHeight;

            // 한 페이지 이상일 경우 루프 돌면서 출력
            while (heightLeft >= 20) {			// 35
                position = heightLeft - imgHeight;
                position = position - 20 ;		// -25

                docInfo.addPage();
                docInfo.addImage(imgData, 'PNG', margin, position, imgWidth, imgHeight);
                heightLeft -= pageHeight;
            }
        });
    }

    function makeApprovalFormData(e, id, type){
        var formData = new FormData();
        formData.append("type", type);
        formData.append("menuCd", $("#menuCd").val());
        formData.append("docId", e);
        formData.append("id", id);
        formData.append("docContent", editor.getData());
        formData.append("fileNo", "${rs.docInfo.ATFILE_SN}");
        formData.append("docFilePath", "${rs.docInfo.FILE_PATH}");
        formData.append("docFileName", "${rs.docInfo.FILE_UUID}");
        formData.append("docFilePdf", docInfo.output('blob'));
        if(type == "approve"){
            formData.append("approveStatCode", $("#approveCode").val());
            formData.append("approveStatCodeDesc", $("#approveCodeNm").val());
            formData.append("approveEmpSeq", $("#approveEmpSeq").val());
            formData.append("approveEmpName", $("#approveEmpName").val());
            formData.append("approveOpin", $("#approveOpin").val());
        }else{
            formData.append("approveStatCode", $("#referCode").val());
            formData.append("approveStatCodeDesc", $("#referCodeNm").val());
            formData.append("approveEmpSeq", $("#referEmpSeq").val());
            formData.append("approveEmpName", $("#referEmpName").val());
            formData.append("approveOpin", $("#referOpin").val());
        }

        return formData;
    }
</script>
</body>
</html>