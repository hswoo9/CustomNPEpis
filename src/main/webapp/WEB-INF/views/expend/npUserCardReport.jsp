<%@ page language="java" contentType="text/html; charset=utf-8"
         pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ page import="main.web.BizboxAMessage"%>
<jsp:useBean id="year" class="java.util.Date" />
<jsp:useBean id="mm" class="java.util.Date" />
<jsp:useBean id="dd" class="java.util.Date" />
<jsp:useBean id="weekDay" class="java.util.Date" />
<jsp:useBean id="nowDate" class="java.util.Date" />
<fmt:formatDate value="${nowDate}" var="nowDate" pattern="yyyy-MM-dd" />
<fmt:formatDate value="${year}" var="year" pattern="yyyy" />
<fmt:formatDate value="${mm}" var="mm" pattern="MM" />
<fmt:formatDate value="${dd}" var="dd" pattern="dd" />
<fmt:formatDate value="${weekDay}" var="weekDay" pattern="E" type="date" />

<link rel="stylesheet" type="text/css" href='${pageContext.request.contextPath}/css/pudd.css'></link>
<script type="text/javascript" src='${pageContext.request.contextPath}/js/pudd/pudd-1.1.192.min.js'></script>
<script type="text/javascript" src='${pageContext.request.contextPath}/js/np/jquery.ucgridtable.1.0.js'></script>

<style>

    .top_box dl dt {
        font-weight: bold;
        color: #4a4a4a;
        font-size: 12px;
        float: left;
        line-height: 54px;
        margin-right: 10px;
        margin-left: 20px;
    }

    .top_box dl dd {
        float: left;
        margin-right: 5px;
        margin-top: 15px;
    }

</style>
<body>
<form id="excelDownload" name="excel" method="post">
    <input type="hidden" name="excelHeader" value="" id="excelHeader" /> <input type="hidden" name="fileName" value="" id="fileName"> <input type="hidden" name="tableData" value="" id="tableData">
</form>
<div class="iframe_wrap">
    <div class="sub_title_wrap">
        <div class="title_div">
            <h4>지출결의서 제출현황</h4>
        </div>
    </div>

    <div class="sub_contents_wrap">
        <!-- 컨트롤박스 -->
        <div class="top_box">
            <dl>
                <dt>${CL.ex_approvalDate}</dt>
                <dd>
                    <div class="dal_div">
                        <!--<input type="text" autocomplete="off" id="txtFromDate" value="" class="inpDateBox puddSetup" pudd-type="datepicker" /> <a href="#n" id="btnFromDate" class="button_dal pudd-type="datepicker""></a>  -->
                        <input type="text" autocomplete="off" id="txtFromDate" value="" class="inpDateBox puddSetup" pudd-type="datepicker" />
                    </div>
                    ~
                    <div class="dal_div">
                        <!--<input type="text" autocomplete="off" id="txtToDate" value="" class="inpDateBox" /> <a href="#n" id="btnToDate" class="button_dal"></a>-->
                        <input type="text" autocomplete="off" id="txtToDate" value="" class="inpDateBox puddSetup" pudd-type="datepicker"  />
                    </div>
                </dd>
                <dt style="width: 60px;"><%=BizboxAMessage.getMessage("TX000018786", "사용처")%></dt>
                <dd class="mr5">
                    <input id="txtMercName" type="text" value="" style="width: 300px">
                </dd>
                <dt>${CL.ex_category}</dt>
                <dd>
                    <select style="width: 70px;" id="georaeStatus" class="selectmenu">
                        <option value="">${CL.ex_all}  <!--전체--></option>
                        <option value="N">${CL.ex_approval}  <!--승인--></option>
                        <option value="Y">${CL.ex_cancel}  <!--취소--></option>
                    </select>
                </dd>
                <dd>
                    <div class="controll_btn p0">
                        <button id="btnSearch" class="btn_sc_add">${CL.ex_search}  <!--검색--></button>
                    </div>
                </dd>

            </dl>
            <span class="btn_Detail"><%=BizboxAMessage.getMessage("TX000005724", "상세검색")%><img id="all_menu_btn" src="<c:url value='/Images/ico/ico_btn_arr_down01.png'/>" /> </span>
        </div>
        <!-- 상세검색박스 -->
        <div class="SearchDetail">
            <dl>
                <dt style="width: 70px;">${CL.ex_confirmationNumber}  <!--승인번호--></dt>
                <dd style="width: 250px;">
                    <input id="txtCardAuthNum" type="text" value="" /> <input id="txtCardNum" type="hidden" value="" style="width: 300px">
                </dd>
                <dt style="width: 70px;">${CL.ex_businessNumber}  <!--사업자번호--></dt>
                <dd style="width: 250px;">
                    <input id="txtOwnerRegNo" type="text" value="" />
                </dd>
                <dt style="width: 70px;">${CL.ex_cardInfo}  <!--카드정보--></dt>
                <dd style="width: 250px;">
                    <div class="controll_btn p0">
                        <input id="txtCardInfo" type="text" readonly/>
                        <input id="hidCardInfo" type="hidden" value="" />
                        <input id="btnCardInfo" type="button" value="${CL.ex_select}" />
                        <button id="btnRefreshCardInfo" class="reload_btn k-button" data-role="button" role="button" aria-disabled="false" tabindex="0"></button>
                    </div>
                </dd>

            </dl>
            <dl>
                <dt style="width: 70px;">${CL.ex_resCondition}</dt>
                <dd style="width: 279px;" class="mr5">
                    <select style="width: 70px;" id="selDocStatus" class="selectmenu">
                        <option value="">${CL.ex_all}  <!--전체--></option>
                        <option value="Y">${CL.ex_res}  <!--${CL.ex_res}--></option>
                        <option value="N">${CL.ex_noRes}  <!--${CL.ex_noRes}--></option>
                        <option value="UN">${CL.ex_notUse}  <!--미사용--> </option>
                    </select>
                </dd>
                <dt>${CL.ex_resPerson}</dt>
                <dd class="mr5">
                    <input id="txtEmpName" type="text" value="" />
                </dd>
            </dl>
        </div>
        <div id="" class="controll_btn btn_div cl">
            <div class="left_div fwb mt5">
                ${CL.ex_yeCount} <span class="" id="cardReportCnt">-</span> ${CL.ex_gun}
            </div>
            <!-- 		<input type="checkbox" name="cancelDoneChk" id="cancelDoneChk"/>&nbsp;<label for="cancelDoneChk" class="mr10">취소완료 건 조회</label> -->
            <button id="btnCardDocStatus" class="k-button">결의상태수정</button>
            <button id="" class="k-button">해외결재 선택 </button>
            <button id="btnCardTrancefer" class="k-button">${CL.ex_cardListTrans}  <!--카드내역이관--></button>
            <button id="btnCardHistroy" class="k-button">${CL.ex_transManage}</button>
            <button id="btnCardUseN" class="k-button">${CL.ex_noUser}  <!--미사용--></button>
            <button id="btnCardUseY" class="k-button">${CL.ex_noUserClear}  <!--미사용해제--></button>
            <button id="btnExcelDown" class="k-button">${CL.ex_excelDown}  <!--엑셀다운로드--></button>
        </div>
        <div id="divGridArea">
        </div>
    </div>
</div>
</div>
<div id="" class="pop_wrap eaInfo" style="position:absolute; width:443px;display:none;left: 50%;top: 50%;margin: -105px 0 0 -222px;z-index: 104;">
    <div class="pop_head">
        <h1 id="">${CL.ex_elecdocInfo}  <!--전자결재 정보--></h1>
    </div><!-- //pop_head -->
    <div class="pop_con">
        <div class="com_ta">
            <table>
                <colgroup>
                    <col width="100" />
                    <col />
                </colgroup>
                <tr>
                    <th>${CL.ex_docNm}  <!--문서번호--></th>
                    <td id="lp_docNo"></td>
                </tr>
                <tr>
                    <th>${CL.ex_docTitle}  <!--문서제목--></th>
                    <td id="lp_docTitle"></td>
                </tr>
                <tr>
                    <th>${CL.ex_docState}  <!--문서상태--></th>
                    <td id="lp_docStatus"></td>
                </tr>
                <tr>
                    <th>${CL.ex_drafter}  <!--기안자--></th>
                    <td id="lp_docEmpSeq"></td>
                </tr>
            </table>
        </div>
    </div><!-- //pop_con -->
    <div class="pop_foot" style="" id="">
        <div class="btn_cen pt12">
            <input class="blue_btn  PLP_advBtn" value="<%=BizboxAMessage.getMessage("TX000000078","확인")%>" type="button" id="lp_btnClose" onClick="">
        </div>
    </div><!-- //pop_foot -->
</div><!-- //pop_wrap -->
<div class="modal eaInfo" style="display:none;z-index: 103;" id=""></div>

<!-- 공통팝업 위한 기능옵션 전달 폼 -->
<form id="frmPop2" name="frmPop2">
    <input type="hidden" name="popUrlStr" id="txt_popup_url" width="800" value="<c:url value='/systemx/orgChart.do' />" /> <input type="hidden" id="devMode_forCmPop" name="devMode" width="500" value="dev" /> <input type="hidden" name="devModeUrl" width="500" value="http://local.duzonnext.com:8080" /> <input type="hidden" id="langCode_forCmPop" name="langCode" width="500" /> <input type="hidden" id="groupSeq_forCmPop" name="groupSeq" width="500" /> <input type="hidden" id="compSeq_forCmPop" name="compSeq" width="500" /> <input type="hidden" id="deptSeq_forCmPop" name="deptSeq" width="500" /> <input type="hidden" id="empSeq_forCmPop" name="empSeq" width="500" /> <input type="hidden" id="compFilter_forCmPop" name="compFilter" width="500" /> <input type="hidden" name="selectMode" width="500" value="u" /> <input type="hidden" name="selectItem" width="500" value="s" /> <input type="hidden" id="selectedItems_forCmPop" name="selectedItems" width="500" /> <input type="hidden"
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        name="callback" width="500" value="fnCardTransCallback" /> <input type="hidden" name="callbackUrl" width="500" value="<c:url value='/html/common/callback/cmmOrgPopCallback.jsp' />" />
</form>
<form id="cardTranPop" name="cardTranPop" method="post"></form>
<form id="cardDocPop" name="cardDocPop" method="post"></form>
<script type="text/javascript">
    /* ## 변수정의 ## */
    /* ====================================================================================================================================================== */
    var SearchKeyCode = [ '13', '113' ];
    var SearchDateFormat = [ 'fromDate', 'toDate' ]; /* "-" 제거 처리 */
    var gCardReportData;
    var gPageLength = 0;
    var gCurrentPage = 1;
    var beforePageLength = 10;
    var gCardExcelData = [];

    /* ## 공통함수 정의 ## */
    /* ====================================================================================================================================================== */

    var Common = {
        GetIfSystem : function() {
            return '${ViewBag.ifUseSystem}';
        },
        iCUBE : function() {
            if (Common.GetIfSystem() === 'iCUBE') {
                return true;
            } else {
                return false;
            }
        },
        ERPiU : function() {
            if (Common.GetIfSystem() === 'ERPiU') {
                return true;
            } else {
                return false;
            }
        },
        GetEmpInfo : function() {
            return {
                erpEmpSeq : "${ViewBag.empInfo.erpEmpSeq}",
                langCode : "${ViewBag.empInfo.langCode}",
                erpCompSeq : "${ViewBag.empInfo.erpCompSeq}",
                groupSeq : "${ViewBag.empInfo.groupSeq}",
                empSeq : "${ViewBag.empInfo.empSeq}",
                compSeq : "${ViewBag.empInfo.compSeq}",
                userSe : "${ViewBag.empInfo.userSe}",
                deptSeq : "${ViewBag.empInfo.deptSeq}",
                bizSeq : "${ViewBag.empInfo.bizSeq}"
            }
        },
        Param : {
            GetSearchParam : function() {
                var paraemters = {};
                var searchCardInfo = '';
// 				searchCardInfo = (JSON.parse($("#hidCardInfo").val() || '[]').map(function(value){
// 					return ((value || '').toString().split('|').length > 2 ? value.toString().split('|')[2] : '');
// 				}).join('|') || '');
// 				searchCardInfo = (searchCardInfo !== '' ? '|' : '') + searchCardInfo + (searchCardInfo !== '' ? '|' : '');
                var cardList = JSON.parse( $("#hidCardInfo").val() || "[]" );
                for(var i = 0; i < cardList.length; i++){
                    var item = cardList[i];
                    searchCardInfo += ",'" + ( item.indexOf('|') > -1 ? item.split('|')[0] : "") + "'" ;
                }

                paraemters.cardAuthDateFrom = $("#txtFromDate").val().replace(/-/g, ''); /* 승인일자 시작일 */
                paraemters.cardAuthDateTo = $("#txtToDate").val().replace(/-/g, ''); /* 승인일자 종료일 */
                paraemters.searchCardInfo = searchCardInfo.substr(1); /* 카드번호 */
                paraemters.searchPartnerNo = ($("#txtOwnerRegNo").val() || ''); /* 사업자등록번호 */
                paraemters.searchSendYn = ($("#selDocStatus").val() || ''); /* 결의상태 */
                paraemters.searchApprovalEmpName = ($("#txtEmpName").val() || ''); /* 결의자 */
                paraemters.searchPartnerName = ($("#txtMercName").val() || ''); /* 사용자 */
                paraemters.searchAuthNum = ($("#txtCardAuthNum").val() || ''); /* 승인번호 */
                paraemters.searchGeoraeStat = ($("#georaeStatus").val() || ''); /* 승인/취소 */
                paraemters.orderBy = 'ASC';

                return Common.Param._GetSearchFormat(paraemters);
            },
            _GetSearchFormat : function(paraemters) {
                $.each(Object.keys(paraemters), function(idx, key) {
                    if (SearchDateFormat.indexOf(key) > -1) {
                        /* "-" 제거 처리 */
                        paraemters[key] = paraemters[key].toString().replace(/-/g, '');
                    }
                });

                return paraemters;
            }
        },
        Result : {
            GetAData : function(param) {
                param = (param === null ? {} : param);

                if (param.result) {
                    if (param.result.aData) {
                        return param.result.aData;
                    }
                }

                return {};
            },
            GetAaData : function(param) {
                param = (param === null ? [] : param);

                if (param.result) {
                    if (param.result.aaData) {
                        return param.result.aaData;
                    }
                }

                return [];
            },
            GetCode : function(param) {
                param = (param === null ? {} : param);

                if (param.result) {
                    if (param.result.resultCode) {
                        return param.result.resultCode;
                    }
                }

                return '';
            },
            GetMessage : function(param) {
                param = (param === null ? {} : param);

                if (param.result) {
                    if (param.result.resultName) {
                        return param.result.resultName;
                    }
                }

                return '';
            }
        },
        Date : {
            GetBeforeDate : function(calcDate) {
                var Today = new Date();
                Today.setDate((Today.getDate() - Number((calcDate || 0))));
                return [ Today.getFullYear(), (Today.getMonth() + 1) < 10 ? '0' + (Today.getMonth() + 1) : (Today.getMonth() + 1), (Today.getDate() < 10 ? '0' + Today.getDate() : Today.getDate()) ].join('-');
            },
            GetBeforeMonth : function() {
                var Today = new Date();
                Today.setMonth((Today.getMonth() - 1));
                return [ Today.getFullYear(), (Today.getMonth() + 1) < 10 ? '0' + (Today.getMonth() + 1) : (Today.getMonth() + 1), (Today.getDate() < 10 ? '0' + Today.getDate() : Today.getDate()) ].join('-');
            },
            GetToday : function() {
                var Today = new Date();
                return [ Today.getFullYear(), (Today.getMonth() + 1) < 10 ? '0' + (Today.getMonth() + 1) : (Today.getMonth() + 1), (Today.getDate() < 10 ? '0' + Today.getDate() : Today.getDate()) ].join('-');
            },
            SetDatepicker : function(id, format) {
                $(id).datepicker({
                    closeText : '닫기',
                    prevText : '이전달',
                    nextText : '다음달',
                    currentText : '오늘',
                    monthNames : [ '1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월' ],
                    monthNamesShort : [ '1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월' ],
                    dayNames : [ '일', '월', '화', '수', '목', '금', '토' ],
                    dayNamesShort : [ '일', '월', '화', '수', '목', '금', '토' ],
                    dayNamesMin : [ '일', '월', '화', '수', '목', '금', '토' ],
                    weekHeader : 'Wk',
                    firstDay : 0,
                    isRTL : false,
                    duration : 200,
                    showAnim : 'show',
                    showMonthAfterYear : true,
                    dateFormat : format
                });
            }
        },
        Format : {
            Amt : function(value) {
                value = (value || '0');
                value = value.toString().replace(/,/g, '').split(' ').join('');
                value = value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");

                return value;
            },
            Date : function(value) {
                value = (value || '');
                value = value.toString().replace(/-/g, '').split(' ').join('');
                value = value.replace(/([0-9]{4})([0-9]{2})([0-9]{2})/, '$1-$2-$3');

                return value;
            },
            DateTime : function(value) {
                value = (value || '');
                value = (value.length > 12 ? value.substring(0, 12) : value);
                value = value.toString().replace(/-/g, '').split(' ').join('');
                value = value.replace(/([0-9]{4})([0-9]{2})([0-9]{2})([0-9]{2})([0-9]{2})/, '$1-$2-$3 $4:$5');

                return value;
            },
            RegNo : function(value) {
                value = (value || '');
                value = value.toString().replace(/-/g, '').split(' ').join('');
                value = value.replace(/([0-9]{3})([0-9]{2})([0-9]{5})/, '$1-$2-$3');

                return value;
            },
            CardNum : function(value) {
                value = (value || '');
                value = value.toString().replace(/-/g, '').split(' ').join('');
                value = value.replace(/([0-9]{4})([0-9]{4})([0-9]{3,4})([0-9]{4})/, '$1-****-****-$4');

                return value;
            }
        },
        Util : {
            CheckboxStat : function() {
                var checkboxCount = $("input[name=chkCard]:checkbox").length
                var checkboxCheckedCount = $("input[name=chkCard]:checkbox:checked").length;

                if (checkboxCount === checkboxCheckedCount) {
                    $('#chkAll').prop('checked', true);
                } else {
                    $('#chkAll').prop('checked', false);
                }
            },
            CheckAll : function() {
                if ($("#chkAll").prop("checked")) {
                    $("#tblCardReport input[type=checkbox]").not(":disabled").prop("checked", true);
                } else {
                    $("#tblCardReport input[type=checkbox]").not(":disabled").prop("checked", false);
                }
            }
        }
    }

    /* ## document ready ## */
    /* ====================================================================================================================================================== */
    $(document).ready(function() {
        fnInit();
        fnEventInit();

        $('#btnSearch').click();

        return;
    });

    /* ## init ## */
    /* ====================================================================================================================================================== */
    function fnInit() {
        if('${ViewBag.empInfo.langCode}'=='en'){
            Pudd.Resource.Calendar.weekName = [ "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" ];
            Pudd.Resource.Calendar.todayNameStr = "today";
        }
        /* DATEPICKER */
        //Common.Date.SetDatepicker("#txtFromDate, #txtToDate", "yy-mm-dd");
        $('#txtFromDate').val(Common.Date.GetBeforeMonth());
        $('#txtToDate').val(Common.Date.GetToday());

        return;
    }

    /* ## event init ## */
    /* ====================================================================================================================================================== */
    function fnEventInit() {

        /* 검색 */
        $('#btnSearch').click(function() {
            fnCardReportSearch();
            return;
        });

        /* 결의상태수정 */
        $('#btnCardDocStatus').click(function() {
            fnCardDocStatus();
            return;
        });

        /* 카드내역이관 */
        $('#btnCardTrancefer').click(function() {
            fnCardTrans();
            return;
        });

        /* 이관관리 */
        $('#btnCardHistroy').click(function() {
            fnCardTransHistory();
            return;
        });

        /* 엑셀다운로드 */
        $('#btnExcelDown').click(function() {
            fnCardExcelDownload();
            return;
        });

        /* 카드선택 */
        $('#btnCardInfo').click(function() {
            fnCardInfoPop();
            return;
        });

        /* 사용처리 */
        $("#btnCardUseY").on("click", function() {
            fnCardUseYN('Y');
            return;
        });

        /* 미사용처리 */
        $("#btnCardUseN").on("click", function() {
            fnCardUseYN('N');
            return;
        });

        /* 엔터 / F2 검색 */
        $('#txtMercName, #txtCardAuthNum, #txtOwnerRegNo, #txtEmpName').keydown(function(e) {
            var keyCode = event.keyCode ? event.keyCode : event.which;
            if (SearchKeyCode.indexOf(keyCode.toString()) > -1) {
                $('#btnSearch').click();
            }
        });

        /* 전자결재 정보 팝업 닫기 */
        $('#lp_btnClose').click(function(){
            $('.eaInfo').hide();
        });

        /* 카드 검색 정보 초기화 */
        $('#btnRefreshCardInfo').click(function (){
            $('#txtCardInfo').val('');
            $('#hidCardInfo').val('');
        });

        return;
    }


    /* ## search report ## */
    /* ====================================================================================================================================================== */

    function fnCardReportSearch() {
        var ajaxParam = Common.Param.GetSearchParam();

        /* 카드 내역 조회 */
        $.ajax({
            type : 'post',
            url : '<c:url value="/expend/np/user/NpUserCardReportSelect2.do" />',
            datatype : 'json',
            async : true,
            data : ajaxParam,
            ajaxParam : ajaxParam,
            success : function(result) {
                var aaData = Common.Result.GetAaData(result);

                aaData = fnFilterdList(aaData);
                /* 현황 카운트 출력 */
                var cardReportCnt = ( aaData.length || 0 );
                $('#cardReportCnt').html(cardReportCnt);

                /* 기본 데이터 적용 */
                gCardReportData = aaData;
                gCardExcelData = gCardReportData;
                gCurrentPage = 1;

                /* 테이블 그리기 */
                fnRenderTable2(gCardReportData, ($("#selViewLength").val() || 10));

                Common.Util.CheckboxStat();
            },
            error : function(data) {
                console.log("! [EX] ERROR - " + JSON.stringify(data));
            }
        });
    }

    function fnCardDocStatus(){
        var chkSels = $("input[name=chkCard]:checkbox:checked").map(function(idx) {
            return $(this).data('value');
        }).get();

        if (chkSels.length > 0) {
            var cardTransList = [];

           /* $.each(chkSels, function(idx, item) {
                if ((  (item.sendYn || 'N') == 'N' ) && ( (item.transYn || 'N') === 'N' ) ) {
                    cardTransList.push(item);
                }
            });

            if (cardTransList.length > 0) {
                if (confirm('${CL.ex_transfermessage}')) {
                    var url = "/gw/systemx/orgChart.do";
                    var pop = window.open("", "cmmOrgPop", "width=760,height=780,scrollbars=no,screenX=150,screenY=150");

                    frmPop2.target = "cmmOrgPop";
                    frmPop2.method = "post";
                    frmPop2.action = url;
                    frmPop2.submit();
                    frmPop2.target = "";
                    pop.focus();
                }
            } else {
                alert('${CL.ex_PleaseSelectAnItem}');
            }*/
            var url = "<c:url value='/expend/docListPop.do'/>";
            var height = 480;

            var isFirefox = typeof InstallTrigger !== 'undefined';
            var isIE = /*@cc_on!@*/false || !!document.documentMode;
            var isEdge = !isIE && !!window.StyleMedia;
            var isChrome = !!window.chrome && !!window.chrome.webstore;
            if (isFirefox) {
                height += 4;
            }
            if (isIE) {
                height += 0;
            }
            if (isEdge) {
                height -= 26;
            }
            if (isChrome) {
                height -= 6;
            }

            window.open('', "cardDocPop", "width=" + 900 + ", height=" + height + ", left=" + 150 + ", top=" + 150);
            cardDocPop.target = "cardDocPop";
            cardDocPop.method = "post";
            cardDocPop.action = url;
            cardDocPop.submit();
            cardDocPop.target = "";

        } else {
            alert('${CL.ex_PleaseSelectAnItem}');
        }

        return;
    }

    /* ## trans card ## */
    /* ====================================================================================================================================================== */
    function fnCardTrans() {
        var chkSels = $("input[name=chkCard]:checkbox:checked").map(function(idx) {
            return $(this).data('value');
        }).get();

        if (chkSels.length > 0) {
            var cardTransList = [];

            $.each(chkSels, function(idx, item) {
                if ((  (item.sendYn || 'N') == 'N' ) && ( (item.transYn || 'N') === 'N' ) ) {
                    cardTransList.push(item);
                }
            });

            if (cardTransList.length > 0) {
                if (confirm('${CL.ex_transfermessage}')) {
                    var url = "/gw/systemx/orgChart.do";
                    var pop = window.open("", "cmmOrgPop", "width=760,height=780,scrollbars=no,screenX=150,screenY=150");

                    frmPop2.target = "cmmOrgPop";
                    frmPop2.method = "post";
                    frmPop2.action = url;
                    frmPop2.submit();
                    frmPop2.target = "";
                    pop.focus();
                }
            } else {
                alert('${CL.ex_PleaseSelectAnItem}');
            }
        } else {
            alert('${CL.ex_PleaseSelectAnItem}');
        }

        return;
    }

    function fnCardTransCallback(param) {
        var receiveEmp = {};
        var receiveParam = {};

        if (param.returnObj.length > 0) {
            receiveEmp = param.returnObj[0];
            receiveParam.receiveEmpSeq = receiveEmp.empSeq;
            receiveParam.receiveEmpName = receiveEmp.empName;
            receiveParam.receiveEmpSuperKey = receiveEmp.superKey;

            if (Common.GetEmpInfo().empSeq === receiveParam.receiveEmpSeq) {
                setTimeout(function(){ alert('자신에게 이관할 수 없습니다.'); }, 1000);
                return;
            } else {
                var chkSels = $("input[name=chkCard]:checkbox:checked").map(function(idx) {
                    return $(this).data('value');
                }).get();

                if (chkSels.length > 0) {
                    var CardTransList = [];

                    $.each(chkSels, function(idx, item) {
                        if ((item.sendYn || 'N') == 'N' && (item.transYn || 'N') === 'N') {
                            item.partnerNo = (item.partnerNo || '');
                            item.partnerName = (item.partnerName || '');
                            item.reqAmt = (item.reqAmt || 0);
                            item.cardNum = (item.cardNum || '').replace(/-/gi, '');
                            CardTransList.push(item);
                        }
                    });

                    var ajaxParam = {};
                    ajaxParam = receiveParam;
                    ajaxParam.CardTransList = JSON.stringify(CardTransList);

                    $.ajax({
                        type : 'post',
                        url : "<c:url value='/expend/np/user/NPUserCardTrans.do' />",
                        datatype : 'json',
                        async : false,
                        data : ajaxParam,
                        ajaxParam : ajaxParam,
                        success : function(result) {
                            if (Common.Result.GetCode(result) === 'SUCCESS') {
                                setTimeout(function(){ alert('이관이 완료되었습니다.'); }, 1000);
                                $('#btnSearch').click();
                            } else {
                                setTimeout(function(){ alert('이관 실패하였습니다.'); }, 1000);
                                console.error(Common.Result.GetMessage());
                            }
                        }
                    });
                }
            }
        }

        return;
    }

    /* ## use yn card ## */
    /* ====================================================================================================================================================== */
    function fnCardUseYN(useYN) {
        var chkSels = $("input[name=chkCard]:checkbox:checked").map(function(idx) {
            return $(this).data('value');
        }).get();

        if (chkSels.length > 0) {
            var cardUseYNList = [];

            $.each(chkSels, function(idx, item) {
                /* useYN : Y ( 사용 ) / N : ( 미사용 ) */
                if (((item.sendYn || 'N') == 'N' ) && (item.useYn || 'Y') !== useYN) {
                    cardUseYNList.push(item);
                }
            });

            if (cardUseYNList.length > 0) {
                var ajaxParam = {};
                ajaxParam.useYN = useYN;
                ajaxParam.cardUseYNList = JSON.stringify(cardUseYNList);

                $.ajax({
                    type : 'post',
                    url : "<c:url value='/expend/np/user/NPUserCardUseYN.do' />",
                    datatype : 'json',
                    async : false,
                    data : ajaxParam,
                    ajaxParam : ajaxParam,
                    useYN : useYN,
                    success : function(result) {
                        if (Common.Result.GetCode(result) === 'SUCCESS') {
                            if (this.useYN === 'Y') {
                                alert('${CL.ex_usedUnprocessedTurnOff}');
                            } else {
                                alert('${CL.ex_usedUnprocessed}');
                            }

                            $('#btnSearch').click();
                        } else {
                            alert((this.useYN === 'Y' ? '사용' : '미사용') + ' 처리 실패하였습니다.');
                            console.error(Common.Result.GetMessage());
                        }
                    }
                });
            } else {
                alert('${CL.ex_PleaseSelectAnItem}');
            }
        } else {
            alert('${CL.ex_PleaseSelectAnItem}');
        }

        return;
    }

    /* ## excel download ## */
    /* ====================================================================================================================================================== */
    function fnCardExcelDownload() {
        if (!gCardReportData || gCardReportData.length == undefined || gCardReportData.length == 0) {
            alert('${CL.ex_dataDoNotExists}');
            return false;
        }

        $.each(gCardExcelData, function(idx, item) {
            if (item.georaeStat === '0' || item.georaeStat === 'Y' || item.georaeStat === 'B') {
                gCardExcelData[idx].georaeStatName = '${CL.ex_cancel}';
            } else {
                gCardExcelData[idx].georaeStatName = '${CL.ex_approved}';
            }

            gCardExcelData[idx].authDt = Common.Format.DateTime((item.authDate || '') + (item.authTime || ''));

            gCardExcelData[idx].mercSaupNoCon = Common.Format.RegNo(item.partnerName);
            gCardExcelData[idx].partnerNo = Common.Format.RegNo(item.partnerNo);

            gCardExcelData[idx].cardNumCon = Common.Format.CardNum((item.cardNum || ''));

            if ([ 'Y', '0' , 'B' ].indexOf(item.georaeStat) > -1) {
                gCardExcelData[idx].requestAmountCon = Math.abs(item.reqAmt)*-1;
                gCardExcelData[idx].stdMdAmountCon = Math.abs(item.stdAmt) * -1;
                gCardExcelData[idx].vatMdAmountCon = Math.abs(item.vatAmt) * -1;
                gCardExcelData[idx].serAmountCon = Math.abs(item.serAmount) * -1;
            } else {
                gCardExcelData[idx].requestAmountCon = item.reqAmt;
                gCardExcelData[idx].stdMdAmountCon = item.stdAmt;
                gCardExcelData[idx].vatMdAmountCon = item.vatAmt;
                gCardExcelData[idx].serAmountCon = item.serAmount;
            }

            if (item.receiveYn === 'Y') {
                gCardExcelData[idx].receiveYnName = '${CL.ex_Reception2}';
            } else {
                gCardExcelData[idx].receiveYnName = '';
            }

            if ((item.send_yn || 'N') === 'Y') {
                gCardExcelData[idx].sendYnName = '${CL.ex_res}';
            } else {
                gCardExcelData[idx].sendYnName = '${CL.ex_noRes}';
            }

            if ((item.useYn || 'N') === 'Y') {
                gCardExcelData[idx].useYnName = '${CL.ex_use}';
            } else {
                gCardExcelData[idx].useYnName = '${CL.ex_notUse}';
            }

            if ((item.docStatus || '000') === '000') {
                gCardExcelData[idx].docStatus = '${CL.ex_noRes}';
            } else {
                gCardExcelData[idx].docStatus = fnGetDocStatusLabel(item.docStatus);
            }

            if ((item.receiveYn || 'N') === 'N') {
                gCardExcelData[idx].receiveYnName = '${CL.ex_notReception}';
            } else {
                gCardExcelData[idx].receiveYnName = '${CL.ex_Reception2}';
            }


        });

        var excelHeader = {
            georaeStatName : '<%=BizboxAMessage.getMessage("TX000022126","구분")%>',
            authDt : '<%=BizboxAMessage.getMessage("TX000007536","승인시간")%>' ,
            authNum : '<%=BizboxAMessage.getMessage("TX000005311","승인번호")%>',
            partnerName : '<%=BizboxAMessage.getMessage("TX000000313","거래처")%>',
            partnerNo : '사업자번호',
            cardName : '<%=BizboxAMessage.getMessage("TX000000527","카드명")%>',
            cardNumCon : '<%=BizboxAMessage.getMessage("TX000004699","카드번호")%>',
            requestAmountCon : '<%=BizboxAMessage.getMessage("TX000005709","금액")%>',
            stdMdAmountCon : '<%=BizboxAMessage.getMessage("TX000018453","공급가액")%>',
            vatMdAmountCon : '<%=BizboxAMessage.getMessage("TX000009474","부가세액")%>',
            serAmountCon : '<%=BizboxAMessage.getMessage("TX000009550","서비스금액")%>',
            receiveYnName : '수신여부(Y : 수신 / N : 미수신)',
            sendYnName : '상신여부',
            useYnName : '사용여부',
            docNo : '<%=BizboxAMessage.getMessage("TX000018128","문서번호")%>',
            docTitle : '<%=BizboxAMessage.getMessage("TX000003457","문서제목")%>',
            docStatus : '<%=BizboxAMessage.getMessage("TX000005832","문서상태")%>',
            sendEmpName : '<%=BizboxAMessage.getMessage("TX000018600","기안자")%>'
        };

// 		for(var i = 0 ; i < gCardExcelData.length; i++){
// 			gCardExcelData[i].docStatus = fnGetDocStatusLabel(gCardExcelData[i].docStatus) ;
// 		}

        $("#excelHeader").val(JSON.stringify(excelHeader));
        $("#tableData").val(JSON.stringify(gCardExcelData));
        excelDownload.method = "post";
        excelDownload.action = "<c:url value='/expend/np/user/NpUserCardReportExcel.do' />";
        excelDownload.submit();
        excelDownload.target = "";
    }

    /* ## table render2 ## */
    /* ====================================================================================================================================================== */
    function fnRenderTable2(aaData) {
        console.log('**************************** 카드 사용내역 리스트 출력 ****************************');
        var pageSize = $('#divGridArea_selectMenu option:selected').val();
        $('#eTaxTotalCount').html(aaData.length.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ','));
        $("#divGridArea").html("");
        $('.gt_paging').remove();
        $("#divGridArea").GridTable({
            'tTablename' : 'gridConsReturn',
            'nTableType' : 1,
            'nHeight' : 600,
            'module' : 'expReport',
            'bNoHover' : true,
            'oNoData' : { // 데이터가 존재하지 않는 경우
                'tText' : '${CL.ex_NotExistData}' // 출력 텍스트 설정
            },
            "data" : aaData,
            'oPage' : { // 사용자 페이징 정보
                'nItemSize' : pageSize||15 // 페이지별 아이템 갯수(기본 값. 10)
                ,
                'anPageSelector' : [ 15, 35, 50, 100 ]
                // 아이템 갯수 선택 셀렉트 구성
            },
            "aoHeaderInfo" : [ { // [*] 테이블 헤더 정보입니다.
                no : '0' // 컬럼 시퀀스입니다.
                ,
                renderValue : "<input type=\"checkbox\" id=\"all_chk\" name=\"all_chk\"\">",
                colgroup : '5'
            }, {
                no : '1',
                renderValue : "${CL.ex_category}",
                colgroup : '10',
                class : 'orderBy',
                value : 'georaeStatName'
            }, {
                no : '2',
                renderValue : '${CL.ex_dateAndTimeOfApproval}',
                colgroup : '13',
                class : 'orderBy',
                value : 'authDate'
            }, {
                no : '3',
                renderValue : '${CL.ex_confirmationNumber}',
                colgroup : '10',
                class : 'orderBy',
                value : 'authNum'
            }, {
                no : '4',
                renderValue : '${CL.ex_useArea}',
                colgroup : '28',
                class : 'orderBy',
                value : 'partnerName'
            }, {
                no : '5',
                renderValue : '${CL.ex_businessNumber}',
                colgroup : '15',
                class : 'orderBy',
                value : 'partnerNo'
            }, {
                no : '6',
                renderValue : '${CL.ex_cardNm}',
                colgroup : '15',
                class : 'orderBy',
                value : 'cardName'
            }, {
                no : '7',
                renderValue : '${CL.ex_creditCardNumber}',
                colgroup : '15',
                class : 'orderBy',
                value : 'cardNum'
            }, {
                no: '8'
                , renderValue: '${CL.ex_amount}'
                , colgroup: '15',
                class : 'orderBy',
                value : 'reqAmt'
            }, {
                no : '9',
                renderValue : '${CL.ex_purPrice}',
                colgroup : '15',
                class : 'orderBy',
                value : 'stdAmt'
            } , {
                no : '10',
                renderValue : '${CL.ex_vat}',
                colgroup : '15',
                class : 'orderBy',
                value : 'vatAmt'
            } , {
                no : '11',
                renderValue : '${CL.ex_resCondition}',
                colgroup : '15',
                class : 'orderBy',
                value : 'docStatus'
            } ],
            "aoDataRender" : [ { // [*] 실제 데이터 표기 방법에 대하여 지정합니다.
                no : '0',
                render : function(idx, item) {
                    var isDisabled = (item.receiveYn || item.transferYn || 'N') == 'Y' ? 'disabled' : '';
                    if( (item.sendYn || 'N' ) == 'Y'){
                        isDisabled = 'disabled';
                    }
                    return '<input type="checkbox" class="chk_row" name="chkCard" onclick="Common.Util.CheckboxStat();" ' + isDisabled + '/>';
                }
            }, {
                no : '1',
                render : function(idx, item) {
                    if( ( item.receiveYn || 'N') === 'Y'){
                        return '<img src="../../../Images/ico/received_arr.png" alt="" /> ' + (Common.Format.Date(item.georaeStatName)=='승인'?'${CL.ex_approval}':'${CL.ex_cancel}');
                    } else if( ( item.transferYn || 'N') === 'Y'){
                        return '<img src="../../../Images/ico/send_arr.png" alt="" /> ' + (Common.Format.Date(item.georaeStatName)=='승인'?'${CL.ex_approval}':'${CL.ex_cancel}');
                    }
                    return (Common.Format.Date(item.georaeStatName)=='승인'?'${CL.ex_approval}':'${CL.ex_cancel}');
                }
            }, {
                no : '2',
                render : function(idx, item) {
                    return Common.Format.DateTime((item.authDate || '') + (item.authTime || ''));
                },
                class : 'cen'
            }, {
                no : '3',
                render : function(idx, item) {
                    return '<a class="text_blue cardPop" style="text-decoration:underline;cursor:pointer;" title="법인카드 사용내역 상세 팝업보기">' + (item.authNum || '') + '</a>';
                },
                class : 'cen'
            }, {
                no : '4',
                render : function(idx, item) {
                    return item.partnerName;
                },
                class : 'le'
            }, {
                no : '5',
                render : function(idx, item) {
                    return Common.Format.RegNo(item.partnerNo);
                },
                class : 'cen'
            }, {
                no : '6',
                render : function(idx, item) {
                    return (item.cardName || '') ;
                },
                class : 'cen'
            }, {
                no : '7',
                render : function(idx, item) {
                    return Common.Format.CardNum((item.cardNum || ''));
                },
                class : ''
            }, {
                no: '8',
                render: function (idx, item) {
                    return (item.georaeStat=='N' || item.georaeStat=='A') ?Common.Format.Amt(item.reqAmt):Common.Format.Amt(Math.abs(item.reqAmt) * -1);
                }
                , class : 'ri colorIf'
            }, {
                no : '9',
                render : function(idx, item) {
                    return (item.georaeStat=='N' || item.georaeStat=='A') ?Common.Format.Amt(item.stdAmt + item.serAmount):Common.Format.Amt(Math.abs(item.stdAmt + item.srAmount) * -1);
                }
                , class : 'ri colorIf'
            }, {
                no : '10',
                render : function(idx, item) {
                    return (item.georaeStat=='N' || item.georaeStat=='A') ?Common.Format.Amt(item.vatAmt):Common.Format.Amt(Math.abs(item.vatAmt) * -1);
                },
                class : 'ri colorIf'
            }, {
                no : '11',
                render : function(idx, item) {
                    if (item.sendYn === 'Y') {
                        item.formSeq = item.formSeq || 0;
                        return '<a class="text_blue eaPop" style="text-decoration:underline;cursor:pointer;" onClick="javascript:fnAppdocPop(' + item.docSeq + ', ' + item.formSeq + ' )" title="전자결재 정보 상세 팝업보기">' + fnGetDocStatusLabel(item.docStatus) + '(' + item.sendEmpName + ')</a>';
                    } if((item.useYn || 'Y') == 'N'){
                        return '${CL.ex_notUse}(' + item.notUseEmpName + ')';
                    }
                    else {
                        return '${CL.ex_noRes}';
                    }
                },
                class : 'cen colorIf2'
            } ],
            'fnGetDetailInfo' : function() {
                console.log('get detail info');
            },
            'fnTableDraw' : function() {
                $('#all_chk').click(function (){
                    $('.chk_row:enabled').prop('checked', $(this).prop('checked'));
                });

                $('.orderBy').click(function(){
                    var orderType = $(this).attr('value');
                    fnTableReOrder(aaData, orderType, $(this));
                });
            },
            'fnRowCallBack' : function(row, aData) {
                if ( ( (aData.reqAmt || 0) < 0) || ((aData.georaeStat||'') == 'Y')) {
                    $(row).find('td').css('background', '#ffd5d5');
                    $(row).find('.colorIf').css('color', 'red');
                }else{
                    $(row).find('.colorIf').css('color', 'blue');
                }

                $(row).find('.cardPop').click(function(){
                    var popup = window.open("../../../expend/np/user/UserCardDetailPop.do?syncId=" + aData.syncId, "" , "width=432, height=489 , scrollbars=yes");
                });

                if ((aData.useYn || 'Y') == 'N') {
                    $(row).find('td').css('background', '#f5f5f5');
                    $(row).find('.colorIf2').css('color', 'red');
                    $(row).find('.colorIf').css('color', 'gray');
                }

                $(row).css('cursor', 'pointer');
                $(row).find('input[type=checkbox]').data('value', aData);
                $(row).click(function() {
                    // $table.find('.on').removeClass('on');
                    $(this).siblings().removeClass('on');
                    $(this).addClass('on');

                });

                $(row).find('.etaxPop').click(function() {
                    var popup = window.open("../../../expend/np/user/UserETaxDetailPop.do?syncId=" + aData.issNo, "", "width=900, height=520 , scrollbars=yes");
                });
            }
        });
    }


    var _orderBy = 1;
    var _orderType = '';
    function fnTableReOrder(aaData, orderType, $th){
        /* th배경색 변경 */
        if(_orderType != orderType){
            _orderBy = 1;
            _orderType = orderType;
        }else{
            _orderBy *= -1;
        }

        aaData.sort(function(a, b) {
            if(_orderType == 'georaeStatName'){
                if( a.georaeStatName < b.georaeStatName ){
                    return _orderBy;
                }else {
                    return _orderBy * -1;
                }
            } else if(_orderType == 'authDate'){
                var aDate = (a.authDate || '') + (a.authTime || '');
                var bDate = (b.authDate || '') + (b.authTime || '');
                if( aDate < bDate ){
                    return _orderBy;
                }else {
                    return _orderBy * -1;
                }
            } else if(_orderType == 'authNum'){
                if( a.authNum < b.authNum ){
                    return _orderBy;
                }else {
                    return _orderBy * -1;
                }
            } else if(_orderType == 'partnerName'){
                if( a.partnerName < b.partnerName ){
                    return _orderBy;
                }else {
                    return _orderBy * -1;
                }
            } else if(_orderType == 'partnerNo'){
                if( a.partnerNo < b.partnerNo ){
                    return _orderBy;
                }else {
                    return _orderBy * -1;
                }
            } else if(_orderType == 'cardName'){
                if( a.cardName < b.cardName ){
                    return _orderBy;
                }else {
                    return _orderBy * -1;
                }
            } else if(_orderType == 'cardNum'){
                if( a.cardNum < b.cardNum ){
                    return _orderBy;
                }else {
                    return _orderBy * -1;
                }
            } else if(_orderType == 'reqAmt'){
                if( a.reqAmt < b.reqAmt ){
                    return _orderBy;
                }else {
                    return _orderBy * -1;
                }
            } else if(_orderType == 'stdAmt'){
                if( a.stdAmt < b.stdAmt ){
                    return _orderBy;
                }else {
                    return _orderBy * -1;
                }
            } else if(_orderType == 'vatAmt'){
                if( a.vatAmt < b.vatAmt ){
                    return _orderBy;
                }else {
                    return _orderBy * -1;
                }
            } else if(_orderType == 'docStatus'){
                var aStatus = '' + a.sendYn + a.useYn;
                var bStatus = '' + b.sendYn + b.useYn;
                if( aStatus < bStatus ){
                    return _orderBy;
                }else {
                    return _orderBy * -1;
                }
            }
            // 이름이 같을 경우
            return 0;
        });

        fnRenderTable2(aaData);

        $('.com_ta2 table th').css('background', '#f9f9f9');
        if(_orderBy == -1){
            $('.com_ta2 table th[value='+ orderType +']').css('background', '#FFE5E5');
            $th
        }else{
            $('.com_ta2 table th[value='+ orderType +']').css('background', '#E5F4FF');
        }
    }

    /*	[그리드 출력] 그리드 출력 리스트 필터링
    -------------------------------------------------------------------- */
    function fnFilterdList(aaData){
        var filterdList = [];
        var searchParam = Common.Param.GetSearchParam();

        var authNum = searchParam.searchAuthNum;
        var partnerName = searchParam.searchPartnerName;
        var partnerNo = searchParam.searchPartnerNo.replace(/-/g, '');
        var georaeStat = searchParam.searchGeoraeStat;
        var sendYn = searchParam.searchSendYn;
        var docEmpName = searchParam.searchApprovalEmpName;
        var useYn = searchParam.searchSendYn;
        if(useYn == 'UN'){
            sendYn = useYn = 'N';
        }
        else if(useYn == 'N' || useYn == 'Y'){
            useYn = 'Y';
        }
        else {
            useYn = '';
        }


        for(var i = 0; i < aaData.length; i++){
            var item = aaData[i];

            /* 승인번호 체크 */
            if( (item.authNum || '') .indexOf(authNum) == -1){
                continue;
            }

            /* 사용처 체크 */
            if( (item.partnerName || '') .indexOf(partnerName) == -1){
                continue;
            }

            /* 사업자번호 체크 */
            if( (item.partnerNo || '') .indexOf(partnerNo) == -1){
                continue;
            }

            /* 구분 체크 */
            if( (item.georaeStat || '') .indexOf(georaeStat) == -1){
                continue;
            }

            /* 결의자 체크 */
            if( (item.sendEmpName || '') .indexOf(docEmpName) == -1){
                continue;
            }



            /* 결의상태 체크 */
            if( (item.sendYn || 'N') .indexOf(sendYn) == -1){
                continue;
            }

            /* 사용여부 체크 */
            if( (item.useYn || 'Y') .indexOf(useYn) == -1){
                continue;
            }

            /* 승인시각 누락 필터링 */
            item.authTime = item.authTime || '000000';

            filterdList.push(item);
        }
        console.log('function fnFilterdList(aaData) RESULT : ');
        return filterdList;
    }


    /* ## render table ## */
    /* ====================================================================================================================================================== */
    function fnRenderTable(data, showCount) {
        var $table = $('#tblCardReport');
        $table.empty();
        $table.append('<colgroup>' + $('.com_ta2 table colgroup:eq(0)').html() + '</colgroup>');

        if (data.length > 0) {
            /* 테이블 그리기 */
            var colorRed = ' style="color: red"';
            var colorBlue = ' style="color: blue"';
            var startIdx = (gCurrentPage * showCount) - showCount
            var endIdx = (gCurrentPage * showCount) - 1;

            $.each(data, function(idx, item) {
                if (startIdx <= idx && idx <= endIdx) {
                    var tr = document.createElement('tr');

                    $(tr).data('card', item);
                    var isDisabled = item.sendYn == 'Y' ? 'disabled' : '';
                    $(tr).append('<td>' + '<input type="checkbox" name="chkCard" onclick="Common.Util.CheckboxStat();" ' + isDisabled + ' />' + '</td>');
                    if ([ 'Y', '0', 'B' ].indexOf(item.georaeStat) > -1) {
                        $(tr).append('<td' + colorRed + '>' + (item.georaeStatName || '${CL.ex_cancel}') + '</td>'); /* 구분 */
                        $(tr).append('<td' + colorRed + '>' + Common.Format.DateTime((item.authDate || '') + (item.authTime || '')) + '</td>'); /* 승인일시 */
                    } else {
                        $(tr).append('<td>' + (item.georaeStatName || '${CL.ex_approvel}') + '</td>'); /* 구분 */
                        $(tr).append('<td>' + Common.Format.DateTime((item.authDate || '') + (item.authTime || '')) + '</td>'); /* 승인일시 */
                    }
                    // <a class="text_blue etaxPop" style="text-decoration:underline;cursor:pointer;" title="법인카드 사용내역 상세 팝업보기">' + item.authNum + '</a>
                    // 상배 : 상세팝업 보기 추가
                    $(tr).append('<td>' + '<a class="text_blue cardPop" style="text-decoration:underline;cursor:pointer;" title="법인카드 사용내역 상세 팝업보기">' + (item.authNum || '') + '</a>' + '</td>'); /* 승인번호 */
                    $(tr).append('<td class="le">' + (item.mercName || '') + '</td>'); /* 사용처 */
                    $(tr).append('<td>' + Common.Format.RegNo(item.mercSaupNo) + '</td>'); /* 사업자번호 */
                    $(tr).append('<td>' + (item.cardName || '') + '</td>'); /* 카드명 */
                    $(tr).append('<td>' + Common.Format.CardNum((item.cardNum || '')) + '</td>'); /* 카드번호 */
                    if ([ 'Y', '0' ].indexOf(item.georaeStat) > -1) {
                        if (item.requestAmount.toString().indexOf('-') > -1) {
                            $(tr).append('<td class="ri"' + colorRed + '>' + Common.Format.Amt(item.requestAmount) + '</td>'); /* 금액 */
                            $(tr).append('<td class="ri"' + colorRed + '>' + Common.Format.Amt(item.amtMdAmount) + '</td>'); /* 공급가액 */
                            $(tr).append('<td class="ri"' + colorRed + '>' + Common.Format.Amt(item.vatMdAmount) + '</td>'); /* 부가세 */
                        } else {
                            $(tr).append('<td class="ri"' + colorRed + '>-' + Common.Format.Amt(item.requestAmount) + '</td>'); /* 금액 */
                            $(tr).append('<td class="ri"' + colorRed + '>-' + Common.Format.Amt(item.amtMdAmount) + '</td>'); /* 공급가액 */
                            $(tr).append('<td class="ri"' + colorRed + '>-' + Common.Format.Amt(item.vatMdAmount) + '</td>'); /* 부가세 */
                        }
                    } else {
                        $(tr).append('<td class="ri"' + colorBlue + '>' + Common.Format.Amt(item.requestAmount) + '</td>'); /* 금액 */
                        $(tr).append('<td class="ri"' + colorBlue + '>' + Common.Format.Amt(item.amtMdAmount) + '</td>'); /* 공급가액 */
                        $(tr).append('<td class="ri"' + colorBlue + '>' + Common.Format.Amt(item.vatMdAmount) + '</td>'); /* 부가세 */
                    }

                    /* 미사용 : (R)미사용(홍길동) */
                    /* 미상신 : 미결의 */
                    /* 상신 : 결의(홍길동) */
                    if (item.useYn === 'N') {
                        $(tr).append('<td>' + '<span  style="color: red">${CL.ex_notUse}</span></td>');
                    } else {
                        if ((item.sendYn || 'N') == 'Y' || (item.send_yn || 'N') == 'Y') {
                            /* 기존 상신된 내역은 사용자 정보가 존재하지 않으므로 결의자를 확인할 수 없다. */
                            $(tr).append('<td>' + '<a class="text_blue eaPop" style="text-decoration:underline;cursor:pointer;" title="전자결재 정보 상세 팝업보기">' + (item.approvalStatName || '${CL.ex_res}').toString().replace('()', '') + '</a>' + '</td>');
                        } else {
                            $(tr).append('<td>' + '${CL.ex_noRes}' + '</td>');
                        }
                    }

                    $(tr).css('cursor', 'pointer');
                    $(tr).find('input[type=checkbox]').data('value', item);

                    // 상배 : 상세팝업 보기 추가
                    $(tr).find('.eaPop').click(function(){
                        $('.eaInfo').show();
                        $('#lp_docNo').html( '<a style="text-decoration:underline;cursor:pointer;"  title="전자결재 문서보기" onClick="javascript:fnAppdocPop(' + item.docSeq + ', ' + item.formSeq + ' )">' + item.docNo || '-' + '</a>' );
                        $('#lp_docTitle').html( item.docTitle || '' );
                        $('#lp_docStatus').html( fnGetDocStatusLabel(item.docStatus) );
                        $('#lp_docEmpSeq').html( item.docEmpName );
                    });

                    $(tr).find('.cardPop').click(function(){
                        var popup = window.open("../../../expend/np/user/UserCardDetailPop.do?syncId=" + item.syncId, "" , "width=432, height=489 , scrollbars=yes");
                    });

                    $(tr).click(function() {
                        $table.find('.on').removeClass('on');
                        $(this).addClass('on');
                    });

                    $table.append(tr);
                }
            });
        } else {
            /* 빈테이블 그리기 */
            var tr = document.createElement('tr');
            var td = document.createElement('td');

            $(td).attr('colspan', $('.com_ta2 table:eq(0) tr:eq(0) th').length);
            $(td).append('검색결과가 없습니다.');
            $(tr).append(td);

            $table.append(tr);
        }

        /* 페이지 그리기 */
        fnRenderTablePage(showCount);
        return;
    }

    /*	[공용] 결재 상태 적용
    ---------------------------------------- */
    function fnGetDocStatusLabel(value){
        /** 비영리 전자결재 상태 코드 **/
        if(value == '000'){
            return '기안대기';
        }else if(value == '001'){
            return '${CL.ex_temporarySave}';
        }else if(value == '002'){
            return '${CL.ex_progressPayment}';
        }else if(value == '003'){
            return '${CL.ex_coopering}';
        }else if(value == '004'){
            return '결재보류';
        }else if(value == '005'){
            return '${CL.ex_docReturn}';
        }else if(value == '006'){
            return '${CL.ex_multiDeptReceipting}';
        }else if(value == '007'){
            return '${CL.ex_draftCancel}';
        }else if(value == '008'){
            return '${CL.ex_appComplete}';
        }else if(value == '009'){
            return '${CL.ex_sendDemand}';
        }else if(value == '101'){
            return '감사중';
        }else if(value == '102'){
            return '감사대기';
        }else if(value == '108'){
            return '감사완료';
        }else if(value == '998'){
            return '심사취소';
        }else if(value == '999'){
            return '결재중';
        }else if(value == 'd'){
            return '${CL.ex_remove}';
        }
        /** 영리 전자결재 상태 코드 **/
        else if(value == '10'){
            return '저장';
        } else if(value == '100'){
            return '반려';
        } else if(value == '110'){
            return '보류';
        } else if(value == '20'){
            return '상신';
        } else if(value == '30'){
            return '진행';
        } else if(value == '40'){
            return '발신종결';
        } else if(value == '50'){
            return '수신상신';
        } else if(value == '60'){
            return '수신진행';
        } else if(value == '70'){
            return '수신반려';
        } else if(value == '80'){
            return '수신확인';
        } else if(value == '90'){
            return '종결';
        }
    }

    function fnRenderTablePage(showCount) {
        /* 페이지 그리기 */
        switch (gCardReportData.length.toString()) {
            case '0':
                gPageLength = 0;
                break;
            default:
                if ((gCardReportData.length % showCount) > 0) {
                    gPageLength = Math.floor(gCardReportData.length / showCount) + 1;
                } else {
                    gPageLength = Math.floor(gCardReportData.length / showCount);
                }
                break;
        }

        $("#paging").empty();
        if (gPageLength <= 5) {
            for (var i = 1; i <= gPageLength; i++) {
                if (gCurrentPage == i) {
                    $("#paging").append('<li class="on"><a href="javascript:fnMovePage(' + i + ')" id="page_' + i + '">' + i + '</a></li>');
                } else {
                    $("#paging").append('<li><a href="javascript:fnMovePage(' + i + ')" id="page_' + i + '">' + i + '</a></li>');
                }
            }
        } else {
            /* 첫번째 페이지 */
            if (gCurrentPage == 1) {
                $("#paging").append('<li class="on"><a href="javascript:fnMovePage(1)" id="page_1">1</a></li>');
            } else {
                $("#paging").append('<li><a href="javascript:fnMovePage(1)" id="page_1">1</a></li>');
            }

            if (gCurrentPage <= 3) {
                for (var i = 2; i < 5; i++) {
                    if (gCurrentPage == i) {
                        $("#paging").append('<li class="on"><a href="javascript:fnMovePage(' + i + ')" id="page_' + i + '">' + i + '</a></li>');
                    } else {
                        $("#paging").append('<li><a href="javascript:fnMovePage(' + i + ')" id="page_' + i + '">' + i + '</a></li>');
                    }
                }
                $("#paging").append('<li>…</li>');
            } else if (gCurrentPage >= (gPageLength - 2)) {
                $("#paging").append('<li>…</li>');
                for (var i = (gPageLength - 3); i < gPageLength; i++) {
                    if (gCurrentPage == i) {
                        $("#paging").append('<li class="on"><a href="javascript:fnMovePage(' + i + ')" id="page_' + i + '">' + i + '</a></li>');
                    } else {
                        $("#paging").append('<li><a href="javascript:fnMovePage(' + i + ')" id="page_' + i + '">' + i + '</a></li>');
                    }
                }
            } else {
                $("#paging").append('<li>…</li>');
                for (var i = gCurrentPage - 1; i <= (gCurrentPage + 1); i++) {
                    if (gCurrentPage == i) {
                        $("#paging").append('<li class="on"><a href="javascript:fnMovePage(' + i + ')" id="page_' + i + '">' + i + '</a></li>');
                    } else {
                        $("#paging").append('<li><a href="javascript:fnMovePage(' + i + ')" id="page_' + i + '">' + i + '</a></li>');
                    }
                }
                $("#paging").append('<li>…</li>');
            }

            /* 마지막 페이지 */
            if (gCurrentPage == gPageLength) {
                $("#paging").append('<li class="on"><a href="javascript:fnMovePage(' + gPageLength + ')" id="page_' + gPageLength + '">' + gPageLength + '</a></li>');
            } else {
                $("#paging").append('<li><a href="javascript:fnMovePage(' + gPageLength + ')" id="page_' + gPageLength + '">' + gPageLength + '</a></li>');
            }
        }

        return;
    }

    function fnMovePage(currentPage) {
        if (0 < currentPage && currentPage <= gPageLength) {
            gCurrentPage = currentPage;
            fnRenderTable(gCardReportData, ($("#selViewLength").val() || 10));
            Common.Util.CheckboxStat();
        }
        return;
    }

    /*	[결의 리스트] 전자결재 문서 창
    --------------------------------------------*/
    function fnAppdocPop(docSeq, formSeq) {
        var intWidth = '900';
        var intHeight = screen.height - 100;
        var agt = navigator.userAgent.toLowerCase();

        if (agt.indexOf("safari") != -1) {
            intHeight = intHeight - 70;
        }

        var intLeft = screen.width / 2 - intWidth / 2;
        var intTop = screen.height / 2 - intHeight / 2 - 40;

        if (agt.indexOf("safari") != -1) {
            intTop = intTop - 30;
        }
        var url = "";
        var eaType = "${loginVo.eaType}";
        var popName = "";
        if( eaType == "eap"){
            popName = "AppDoc";
            url = "/eap/ea/docpop/EAAppDocViewPop.do?doc_id=" + docSeq + "&form_id=" + formSeq + "&doc_auth=1";
        }else{
            var param = "diKeyCode=" + docSeq + "&mode=reading";
            popName = "popDocApprovalEdit";
            param= "multiViewYN=N&"+param;
            url = "/ea/edoc/eapproval/docCommonDraftView.do?"+ param;
        }
        window.open(url, popName,'menubar=0,resizable=0,scrollbars=1,status=no,titlebar=0,toolbar=no,width='
            + intWidth + ',height=' + intHeight + ',left=' + intLeft + ',top=' + intTop);
    }


    /* 카드정보 팝업 창 호출 */
    function fnCardInfoPop() {
        var code = 'card';
        var parameter = {};

        parameter.checkedCardInfo = JSON.parse(($("#hidCardInfo").val() || '[]'));
        parameter.widthSize = 780;
        parameter.heightSize = 582;

        fnCallCommonCodePop({
            code : code,
            popupType : 2,
            param : JSON.stringify(parameter),
            callbackFunction : "fnCommonPopCallback"
        });
    }

    /* 카드정보 팝업 콜백 */
    function fnCommonPopCallback(param) {
        var cardCodeHidden = '';
        var cardNameDisplay = '';

        if (param.length > 0) {
            if (param.length > 1) {
                cardNameDisplay = param[i].split("|")[1] + ' 외 ' + (param.length - 1) + '건';
            } else {
                cardNameDisplay = param[i].split("|")[1];
            }
        } else {
            cardNameDisplay = '';
        }

        $("#txtCardInfo").val(cardNameDisplay);
        $("#hidCardInfo").val(JSON.stringify(param));
    }

    /* 이관정보 콜백 함수 */
    function fnCallbackOrgPop(params) {
        var returnObj = params.returnObj;
        var length = returnObj.length;
        var showSelectedNames = '';
        var selectedItems = '';

        for (var i = 0; i < length; i++) {
            var item = returnObj[i];
            selectedItems += ',' + item.superKey;
        }
        selectedItems = selectedItems.substring(1);

        /* 이관 데이터 insert */
        $('#selectedItems_forCmPop').val(selectedItems);

        var param = {};
        param.targetData = $("#hidCardTranceferData").val();
        param.receiveInfo = JSON.stringify(returnObj);
        param.interfaceType = 'card';

        /* 서버호출 */
        $.ajax({
            type : 'post',
            url : '<c:url value="/ex/user/report/ExUserInterfaceTransfer.do" />',
            datatype : 'json',
            async : false,
            data : param,
            success : function(data) {
                if (data.result.resultCode == 'SUCCESS') {
                    setTimeout(function(){ alert('이관이 완료되었습니다.'); }, 1000);
                    $("#btnSearch").click();
                } else {
                    setTimeout(function(){ alert(data.result.resultName); }, 1000);
                }
            },
            error : function(data) {
                console.log("! [EX] ERROR - " + JSON.stringify(data));
            }
        });
        return;

    }

    /* 카드 이관관리  */
    function fnCardTransHistory() {
        /* 팝업 호출 준비 */
        var url = "/exp/expend/np/user/UserCardTransHistoryPop.do";
        var height = 480;

        var isFirefox = typeof InstallTrigger !== 'undefined';
        var isIE = /*@cc_on!@*/false || !!document.documentMode;
        var isEdge = !isIE && !!window.StyleMedia;
        var isChrome = !!window.chrome && !!window.chrome.webstore;
        if (isFirefox) {
            height += 4;
        }
        if (isIE) {
            height += 0;
        }
        if (isEdge) {
            height -= 26;
        }
        if (isChrome) {
            height -= 6;
        }

        window.open('', "cardTranPop", "width=" + 900 + ", height=" + height + ", left=" + 150 + ", top=" + 150);
        cardTranPop.target = "cardTranPop";
        cardTranPop.method = "post";
        cardTranPop.action = url;
        cardTranPop.submit();
        cardTranPop.target = "";

        return;
    }
</script>
</body>
</html>