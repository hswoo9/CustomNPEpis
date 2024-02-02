package com.duzon.custom.expend.etc;

public class CommonMapInterface {

    public static interface ExPath {
        /* iCUBE */
        public interface iCUBE {
            // 나의 지출결의 현황
            // /ex/user/report/ExApprovalList.do
            String MyExpendReport = "/expend/ex/user/content/UserReportExpendList";

            // 나의 카드 사용 현황
            // /ex/user/report/ExUseCardlList.do
            String MyCardReport = "/expend/ex/user/content/UserCardReport";

            // 나의 세금계산서 현황(iCUBE)
            // /ex/user/report/ExUserETaxiCUBEList.do
            String MyEtaxReport = "/expend/ex/user/content/UserETaxReportiCUBE";

            // 나의 예실대비 현황(iCUBE)
            // /ex/user/yesil/ExUserYesilReport.do
            String MyBudgetReport = "/expend/ex/user/content/UserYesilReport";

            // 지출결의 확인
            // /ex/admin/report/ExApprovalSendList.do
            String AdminExpendConfirmReport = "/expend/ex/admin/content/AdminExpendManagerReport";

            // 지출결의 확인(권한별)
            // /ex/admin/report/ExFormAuthApprovalSendList.do
            String AdminExpendAuthReport = "/expend/ex/admin/content/AdminExpendManagerReport";

            // 지출결의 상세현황
            // /ex/admin/report/ExApprovalSlipList.do
            String AdminExpendDetailReport = "/expend/ex/admin/content/AdminSlipReportExpendList";

            // 지출결의 현황
            // /ex/admin/report/ExApprovalList.do
            String AdminExpendReport = "/expend/ex/admin/content/AdminReportExpendList";

            // 카드 사용 현황
            // /ex/admin/report/ExUseCardlList.do
            String AdminCardReport = "/expend/ex/admin/content/AdminCardReport";

            // iCUBE 연동문서 현황
            // /ex/admin/report/ExiCUBEDocListReport.do
            String AdminiCUBELinkReport = "/expend/ex/admin/content/AdminiCUBEDocListReport";

            // 세금계산서 현황(iCUBE)
            // /ex/admin/report/ExAdminETaxlListiCUBE.do
            String AdminEtaxReport = "/expend/ex/admin/content/AdminETaxReportiCUBE";

            // 예실대비현황(iCUBE)
            // /ex/admin/yesil/ExAdminYesilReport.do
            String AdminBudgetReport = "/expend/ex/admin/content/AdminYesilReport";
        }

        /* ERPiU */
        public interface ERPiU {
            // 나의 지출결의 현황
            // /ex/user/report/ExApprovalList.do
            String MyExpendReport = "/expend/ex/user/content/UserReportExpendList";

            // 나의 카드 사용 현황
            // /ex/user/report/ExUseCardlList.do
            String MyCardReport = "/expend/ex/user/content/UserCardReport";

            // 나의 세금계산서 현황(ERPiU)
            // /ex/user/report/ExUserETaxERPiUList.do
            String MyEtaxReport = "/expend/ex/user/content/UserETaxReportERPiU";

            // 나의 예실대비 현황(ERPiU)
            // /ex/user/yesil/ExUserYesil2Report.do
            String MyBudgetReport = "/expend/ex/user/content/UserYesil2Report";

            // 지출결의 확인
            // /ex/admin/report/ExApprovalSendList.do
            String AdminExpendConfirmReport = "/expend/ex/admin/content/AdminExpendManagerReport";

            // 지출결의 확인(권한별)
            // /ex/admin/report/ExFormAuthApprovalSendList.do
            String AdminExpendAuthReport = "/expend/ex/admin/content/AdminExpendManagerReport";

            // 지출결의 상세현황
            // /ex/admin/report/ExApprovalSlipList.do
            String AdminExpendDetailReport = "/expend/ex/admin/content/AdminSlipReportExpendList";

            // 지출결의 현황
            // /ex/admin/report/ExApprovalList.do
            String AdminExpendReport = "/expend/ex/admin/content/AdminReportExpendList";

            // 카드 사용 현황
            // /ex/admin/report/ExUseCardlList.do
            String AdminCardReport = "/expend/ex/admin/content/AdminCardReport";

            // 세금계산서현황(ERPiU)
            // /ex/admin/report/ExAdminETaxlListERPiU.do
            String AdminEtaxReport = "/expend/ex/admin/content/AdminETaxReportERPiU";

            // 예실대비현황(ERPiU)
            // /ex/admin/yesil/ExAdminYesil2Report.do
            String AdminBudgetReport = "/expend/ex/admin/content/AdminYesil2Report";
        }

        /* Bizbox Alpha */
        public interface Bizbox {
            // 카드 설정
            String AdminCardConfig = "";

            // 표준적요 설정
            String AdminSummaryConfig = "";

            // 증빙유형 설정
            String AdminAuthConfig = "";

            // 양식 별 표준적요 & 증빙유형 설정
            String AdminFormLinkConfig = "";

            // 환경 설정
            String AdminConfig = "";

            // 항목 설정
            String AdminItemConfig = "";

            // 관리항목 설정
            String AdminMngConfig = "";

            // 명칭 설정
            String AdminLangConfig = "";

            // 버튼 설정
            String AdminButtonConfig = "";

            // 매입전자세금계산서 설정
            String AdminEtaxAuthConfig = "";

            // 마감설정
            String AdminExpendEndConfig = "";
        }
    }

    public static interface ExNpPath {
        /* iCUBE */
        public interface iCUBE {
            // 나의 카드 사용 현황(비영리 2.0)
            // /expend/np/user/NpUserCardReport.do
            String MyCardUseReport = "/expend/np/user/content/UserNPCardReport";

            // 나의 예실대비 현황(비영리 2.0)
            // /expend/np/user/NpUserG20Yesil.do
            String MyBudgetReport = "/expend/np/user/content/UserNpG20Yesil";

            // 나의 세금계산서 현황(비영리 2.0)
            // /expend/np/user/NpUserEtaxReport.do
            String MyEtaxReport = "/expend/np/user/content/UserNPETaxReportiCUBE";

            // 품의서 현황(2.0)
            // /expend/np/user/NpUserConsUserReport.do
            String MyConsReport = "/expend/np/user/content/UserNPConsReport";

            // 결의서 현황(2.0)
            // /expend/np/user/NpUserResUserReport.do
            String MyResReport = "/expend/np/user/content/UserNPResReport";

            // 품의서 반환(2.0)
            // /expend/np/user/NpUserConsConfferReturn.do
            String MyConsConfferReturn = "/expend/np/user/content/UserNPConsConfferReturn";
        }

        /* ERPiU */
        public interface ERPiU {
            // 나의 카드 사용 현황(비영리 2.0)
            // /expend/np/user/NpUserCardReport.do
            String MyCardUseReport = "/expend/np/user/content/UserNPCardReport";

            // 나의 세금계산서 현황(비영리 2.0)
            // /expend/np/user/NpUserEtaxReport.do
            String MyEtaxReport = "/expend/np/user/content/UserNPETaxReportERPiU";

            // 품의서 현황(2.0)
            // /expend/np/user/NpUserConsUserReport.do
            String MyConsReport = "/expend/np/user/content/UserNPConsReport";

            // 결의서 현황(2.0)
            // /expend/np/user/NpUserResUserReport.do
            String MyResReport = "/expend/np/user/content/UserNPResReport";

            // 품의서 반환(2.0)
            // /expend/np/user/NpUserConsConfferReturn.do
            String MyConsConfferReturn = "/expend/np/user/content/UserNPConsConfferReturn";
        }
    }

    /* 출장복명 Path 정의 */
    public interface commonTripPath {

        /* 출장복명 USER PATH */
        String TripUserContentPath = "/expend/trip/user/content/";
        String TripUserPopPath = "/expend/trip/user/pop/";
        /* 출장복명 ADMIN PATH */
        String TripAdminContentPath = "/expend/trip/admin/content/";
        String TripAdminPopPath = "/expend/trip/admin/pop/";
        /* 출장복명 User Page */
        String UserTripTransSetting = "UserTripTransSetting";
        String UserTripConsTestPage = "UserTripConsTestPage";
        String TripUserConsPop = "TripUserConsPop";
        String TripUserResPop = "TripUserResPop";
        String TripUserConfferPop = "TripUserConfferPop";
        String UserTestPage = "UserTestPage";
        String UserTripConsReport = "UserTripConsReport";
        String UserTripResReport = "UserTripResReport";
        /* 출장복명 Admin Page */
        String AdminTripAmtSetting = "AdminTripAmtSetting";
        String AdminTripLocationInfo = "tripAreaPop";
        String AdminTripPositionGroupInfo = "tripPositionGroupPop";
        String AdminTripTransPortInfo = "tripTransportPop";
        String AdminTripTransportSetting = "AdminTripTransPortSetting";
        String AdminTripPositionGroupSetting = "AdminTripPositionGroupSetting";
        String AdminTripLocationSetting = "AdminTripLocationSetting";
        String AdminTripConsReport = "AdminTripConsReport";
        String AdminTripResReport = "AdminTripResReport";
    }

    /* SQL Map Path 정의 */
    public interface sqlMapPath {

        /* CMS */
        String cmsPath = "/batch/cms";
        /* 지출결의 */
        String exPath = "/ex";
        /* 이지바로 */
        String ezPath = "/ez";
        /* G20 품의서 / 결의서 */
        String acPath = "/ac";
        /* 국고보조금통합관리시스템 연계 */
        String anguPath = "/angu";
        /* 업무용승용차 */
        String biPath = "/bi";
    }

    /* 개발용 Path 정의 */
    public interface commonDevPath {

        /* module path */
        /* module path - Contents Path */
        String ContentPath = "/devmanager/content/";
        /* module path - Popup Path */
        String PopPath = "/devmanager/pop/";
        /* module path - Contents Path - LangPack */
        String LangPack = "LangPack";
        /* module path - Contents Path - CMS */
        String CMS = "CMS";
        /* module path - 네비게이터 지원 */
        String BuildAssistDocu = "BuildAssistDocu";
        /* module path - 비영리 회계 2.0 설치 */
        String Np20Install = "Np20Install";
        /* module path - 신입 스크립트 연습 */
        String practiceForNewbie = "practiceForNewbie";
        /* module path - 신입 스크립트 연습 */
        String practiceForBeginner = "practiceForBeginner";
        /* module path - 신입 스크립트 연습 */
        String practiceForJunior = "practiceForJunior";
        /* module path - 신입 스크립트 연습 */
        String practiceForMaster = "practiceForMaster";
    }

    /* 공통 Path 정의 */
    public interface commonPath {

        /* module path */
        /* module path - Contents Path */
        String ContentPath = "/common/content/";
        /* module path - Popup Path */
        String PopPath = "/common/pop/";
        /* module path - Layer Popup Path */
        String LayerPath = "/common/layer/";
        /* module path - Layer Popup Path - Alert */
        String CommonAlert = "AlertLayerPop";
        /* module path - Popup Path - FileDownload */
        String CommonFileDownload = "FileDownloadPop";
        /* module path - Popup Path - CommonSuiteMigFileDownload */
        String CommonSuiteMigFileDownload = "CommonSuiteMigFileDownload";
        /* module path - Popup Path - FailPop */
        String ProcessFailPop = "ProcessFailPop";
        /* module path - Popup Path - AttachPop */
        String ApprovalAttachPop = "ApprovalAttachPop";
        /* module path - Popup Path - ListPop */
        String ApprovalListPop = "ApprovalListPop";
        /* module path - Popup Path - SlipPop */
        String ApprovalSlipPop = "ApprovalSlipPop";
        /* 표준적요 엑셀 업로드 기능 */
        String SummaryExcelUploadPop = "SummaryExcelUploadPop";
    }

    /* iCUBE G20 품의서 / 결의서 Path 정의 */
    public interface commonAcPath {

        /* module path */
        /* module path - Contents Path */
        String MasterContentPath = "/expend/ac/master/content/";
        String AdminContentPath = "/expend/ac/admin/content/";
        String UserContentPath = "/expend/ac/user/content/";
        /* module path - Popup Path */
        String MasterPopPath = "/expend/ac/master/pop/";
        String AdminPopPath = "/expend/ac/admin/pop/";
        String UserPopPath = "/expend/ac/user/pop/";
        /* module path - Popup */
        /* module path - Popup - G20(사용자) */
        /* module path - Popup - G20(사용자) - 품의서 */
        String ConsDocPop = "AcConsMasterPop";
        /* module path - Popup - G20(사용자) - 결의서 */
        String ResDocPop = "AcResMasterPop";
        /* module path - Popup - G20(사용자) - 참조품의서 */
        String ReferConferPop = "AcExReferConferPop";
        /* module path - Popup - G20(사용자) - 법인카드 승인 내역 */
        String CardSunginPop = "AcExACardSunginPop";
        /* module path - Popup - G20(사용자) - 일반 명세서 */
        String GoodsItemsPop = "AcExGoodsItemsFormPop";
        /* module path - Popup - G20(사용자) - 여비 명세서 */
        String TravelItemsPop = "AcExTravelItemsFormPop";
        /* module path - Popup - G20(사용자) - 급여자료 */
        String PayDataPop = "AcExPayDataPop";
        /* module path - Popup - G20(사용자) - 공통코드 */
        String CommonPop = "AcCommonCodePop";
    }

    /* 지출결의 Path 정의 */
    public interface commonExPath {

        ////////////////////////////////////////////////// Content
        /* module path */
        /* module path - Contents Path */
        String ContentPath = "/expend/ex/content/"; /* 지출결의 현황 기본 URL */
        String MasterContentPath = "/expend/ex/master/content/"; /* 지출결의 현황 기본 URL */
        String AdminContentPath = "/expend/ex/admin/content/"; /* 지출결의 현황 기본 URL */
        String UserContentPath = "/expend/ex/user/content/"; /* 지출결의 현황 기본 URL */
        String UserContentPath2 = "/expend/ex2/user/content/"; /* 지출결의 현황 기본 URL */
        String ErrorPagePath = "/expend/common/error/"; /* 에러출력 페이지 기본 URL */
        String NpUserContentPath = "/expend/np/user/content/"; /* [비영리]지출결의 현황 기본 URL */
        String NpAdminContentPath = "/expend/np/admin/content/"; /* [비영리]지출결의 현황 기본 URL */
        /* module path - Contents */
        ////////////////////////////////////////////////// Content - Master
        ////////////////////////////////////////////////// Content - Admin
        /* module path - Contents - 회계(관리자) */
        /* module path - Contents - 회계(관리자) - 지출결의 관리 */
        /* module path - Contents - 회계(관리자) - 지출결의 관리 - 증빙관리 */
        String AdminExpendAuth = "AdminAuthSetting";
        /* module path - Contents - 회계(관리자) - 지출결의 관리 - 지출결의 확인 */
        String AdminExpendManagerReport = "AdminExpendManagerReport";
        /* module path - Contents - 회계(관리자) - 지출결의 관리 - 계정과목관리 */
        String AdminAcctSetting = "AdminAcctSetting";
        /* module path - Contents - 회계(관리자) - 지출결의 관리 - 지출결의 현황 */
        String AdminExpendReport = "AdminReportExpendList";
        /* module path - Contents - 회계(관리자) - 지출결의 관리 - 지출결의상세 현황 */
        String AdminSlipReportExpendList = "AdminSlipReportExpendList";
        /* module path - Contents - 회계(사용자) - 지출결의 관리 - iCUBE 연동문서 현황 */
        String AdminiCUBEDocListReport = "AdminiCUBEDocListReport";
        /* module path - Contents - 회계(사용자) - 지출결의 관리 - 카드 사용 현황 */
        String AdminCardReport = "AdminCardReport";
        /* module path - Contents - 회계(관리자) - 지출결의 관리 - 증빙관리 */
        String AdminExpendSummary = "AdminSummarySetting";
        /* module path - Contents - 회계(관리자) - 지출결의 관리 - 양식 별 표준적요&증빙유형 설정 */
        String AdminFormLinkCodeSetting = "AdminFormLinkCodeSetting";
        /* module path - Contents - 회계(관리자) - 지출결의 관리 - 양식 별 표준적요&증빙유형 설정 증빙유형 선택 팝업 */
        String AdminFormLinkAuthPop = "AdminFormLinkAuthPop";
        /* module path - Contents - 회계(관리자) - 지출결의 관리 - 양식 별 표준적요&증빙유형 설정 표준적요 선택 팝업 */
        String AdminFormLinkSummaryPop = "AdminFormLinkSummaryPop";
        /* module path - Contents - 회계(관리자) - 지출결의 관리 - 지출결의 마감 설정 페이지 */
        String AdimCloseDateSetting = "AdimCloseDateSetting";
        /* module path - Contents - 회계(관리자) - 지출결의 관리 - 지출결의 마감 설정 페이지 */
        String AdminCloseDatePop = "AdminCloseDatePop";
        ////////////////////////////////////////////////// Content - User
        /* module path - Contents - 회계(사용자) */
        /* module path - Contents - 회계(사용자) - 지출결의 관리 */
        /* module path - Contents - 회계(사용자) - 지출결의 관리 - 나의 지출결의 현황 */
        // String UserExpendReport = "UserExpendReport";
        String UserExpendReport = "UserReportExpendList";
        /* module path - Contents - 회계(사용자) - 지출결의 관리 - 나의 카드 사용 현황 */
        String UserCardReport = "UserCardReport";
        /* module path - Contents - 회계(사용자) - 지출결의 관리 - 나의 세금계산서 사용 현황(iCUBE) */
        String UserETaxiCUBEReport = "UserETaxReportiCUBE";
        /* module path - Contents - 회계(사용자) - 지출결의 관리 - 나의 세금계산서 사용 현황 (ERPiU) */
        String UserETaxERPiUReport = "UserETaxReportERPiU";
        /* module path - Contents - 회계(사용자) - 지출결의 관리 - 나의 세금계산서 사용 현황 (ERPiU) */
        String ExETaxTransferHistoryPop = "ExETaxTransferHistoryPop";
        ////////////////////////////////////////////////// Popup
        /* module path - Popup Path */
        String PopPath = "/expend/ex/pop/"; /* 지출결의 팝업 기본 URL */
        String MasterPopPath = "/expend/ex/master/pop/"; /* 지출결의 팝업 기본 URL */
        String AdminPopPath = "/expend/ex/admin/pop/"; /* 지출결의 팝업 기본 URL */
        String UserPopPath = "/expend/ex/user/pop/"; /* 지출결의 팝업 기본 URL */
        String UserPopPath2 = "/expend/ex2/user/pop/"; /* 지출결의 팝업 기본 URL */
        String NpUserPopPath = "/expend/np/user/pop/"; /* 비영리 품의/결의 팝업 기본 URL */
        String NpAdminPopPath = "/expend/np/admin/pop/"; /* 비영리 품의/결의 관리자 팝업 기본 URL */
        /* module path - Popup */
        ////////////////////////////////////////////////// Popup - User
        /* module path - Popup - 회계(사용자) */
        /* module path - Popup - 회계(사용자) - 지출결의 */
        String UserExpendPop = "ExExpendMasterPopup";
        /* module path - Popup - 회계(사용자) - 항목 */
        String UserListPop = "ListPop";
        /* module path - Popup - 회계(사용자) - 분개 */
        String UserSlipPop = "SlipPop";
        /* module path - Popup - 회계(사용자) - 관리항목 */
        String UserMngPop = "UserMngPop";
        /* module path - Popup - 회계(사용자) - 공통코드 */
        /* module path - Popup - 회계(사용자) - 공통코드 - 사용자 */
        String UserEmpPop = "EmpPop";
        /* module path - Popup - 회계(사용자) - 공통코드 - 회계단위 */
        String UserPcPop = "PcPop";
        /* module path - Popup - 회계(사용자) - 공통코드 - 코스트센터 */
        String UserCcPop = "CcPop";
        /* module path - Popup - 회계(사용자) - 공통코드 - 예산단위 */
        String UserBudgetPop = "BudgetPop";
        /* module path - Popup - 회계(사용자) - 공통코드 - 사업계획 */
        String UserBizplanPop = "BizplanPop";
        /* module path - Popup - 회계(사용자) - 공통코드 - 예산계정 */
        String UserBgAcctPop = "BgAcctPop";
        /* module path - Popup - 회계(사용자) - 공통코드 - 프로젝트 */
        String UserProjectPop = "ProjectPop";
        /* module path - Popup - 회계(사용자) - 공통코드 - 거래처 */
        String UserPartnerPop = "PartnerPop";
        /* module path - Popup - 회계(사용자) - 공통코드 - 카드 */
        String UserCardPop = "CardPop";
        /* module path - Popup - 회계(사용자) - 공통코드 - 차량 */
        String UserCarPop = "CarPop";
        /* module path - Popup - 회계(사용자) - 공통코드 - 표준적요 */
        String UserSummaryPop = "SummaryPop";
        /* module path - Popup - 회계(사용자) - 공통코드 - 증빙유형 */
        String UserAuthPop = "SummaryPop";
        /* module path - Popup - 회계(사용자) - 지출결의 - 접대부 비표 */
        String UserEntertainmentFeePop = "UserEntertainmentFeePop";
        /* module path - Popup - 회계(사용자) - 공통코드 - 테스트 페이지 */
        String UserCmmCodePopTestPage = "UserCmmCodePopTestPage";
        /* module path - Popup - 회계(사용자) - 지출결의 - 접대부 비표 페이지 */
        String UserEntertainmentFeeTestPage = "UserEntertainmentFeeTestPage";
        /* module path - Popup - 회계(사용자,관리자) - 공통 레이어 - 작업 실패사요 */
        String CmmFailPopTestPage = "CmmFailPopTestPage";
        /* module path - Popup - 회계(사용자,관리자) - 명칭설정 테스트 페이지 */
        String CustomLabelTestPage = "CustomLabelTestPage";
        /* module path - Popup - 회계(사용자) - 공통코드 - 공통팝업 */
        String UserCmmCodePop = "UserCmmCodePop";
        /* module path - Popup - 회계(사용자) - 카드사용내역 - 테스트 페이지 */
        String UserCardUsageHistoryPopTestPage = "UserCardUsageHistoryPopTestPage";
        /* module path - Popup - 회계(사용자) - 지출결의 - 카드사용내역 */
        String UserCardUsageHistoryPop = "UserCardUsageHistoryPop";
        /* module path - Popup - 회계(사용자) - 지출결의 - 카드사용내역 - 카드정보 도움창 */
        String UserCardInfoHelpPop = "UserCardInfoHelpPop";
        /* module path - Popup - 회계(사용자) - 지출결의 - 카드사용 상세 내역 */
        String ExCardDetailInfoPop = "ExCardDetailInfoPop";
        /* module path - Contents - 회계(사용자) - 예실대비현황 - 샘플 페이지 */
        String UserYesilSamplePage = "UserYesilSamplePage";
        /* module path - Popup - 지출결의 - 항목관리 - 테스트 페이지 */
        String UserMngPopTestPage = "UserMngPopTestPage";
        /* module path - Popup - 지출결의 - 인터락 URL - 테스트 페이지 */
        String UserInterlockUrlTestPage = "UserInterlockUrlTestPage";
        /* module path - Popup - 지출결의 - 버튼설정 적용 - 테스트 페이지 */
        String UserButtonSettingTestPage = "UserButtonSettingTestPage";
        /* module path - Contents 관리자 - 회계 - 지출결의 설정 - 항목 설정 */
        String AdminItemSetting = "AdminExItemSetting";
        /* module path - Contents 관리자 - 회계 - 지출결의 설정 - 관리 항목 설정 */
        String AdminMngDefSetting = "AdminExMngDefSetting";
        /* module path - Contents 관리자 - 회계 - 지출결의 설정 - 환경설정 */
        String AdminExpendSetting = "AdminExExpendSetting";
        /* module path - Contents 관리자 - 회계 - 지출결의 설정 - 법인카드 설정 */
        String AdminCardSetting = "AdminCardSetting";
        /* module path - Contents 관리자 - 회계 - 지출결의 설정 - 법인카드 설정(비영리) */
        String AdminNpCardSetting = "AdminNpCardSetting";
        /* module path - Contents 관리자 - 회계 - 지출결의 설정 - 증빙유형 설정 */
        String MasterAuthSetting = "MasterAuthSetting";
        /* module path - Contents 관리자 - 회계 - 지출결의 설정 - 표준적요 설정 */
        String MasterSummarySetting = "MasterSummarySetting";
        /* module path - Contents 관리자 - 회계 - 지출결의 설정 - 계정과목 설정 */
        String MasterAcctSetting = "MasterAcctSetting";
        /* module path - Contents 관리자 - 회계 - 지출결의 설정 - 버튼 설정 */
        String AdminButtonSetting = "AdminButtonSetting";
        /* module path - Contents 관리자 - 회계 - 지출결의 설정 - 명칭 설정 */
        String AdminLabelSetting = "AdminLabelSetting";
        /* module path - Contents - 회계(사용자) - 예실대비현황조회 */
        String UserYesilReport = "UserYesilReport";
        /* module path - Contents - 회계(관리자) - 예실대비현황조회 */
        String AdminYesilReport = "AdminYesilReport";
        /* module path - Popup - 회계(관리자) - 예실대비현황조회 - 팝업 */
        String AdminYesilPop = "AdminYesilPop";
        /* module path - Popup - 회계(관리자) - 예실대비현황조회 지출결의현황 - 팝업 */
        String AdminYesilDetailPop = "AdminYesilDetailPop";
        /* module path - Popup - 회계(사용자) - 예실대비현황조회 - 팝업 */
        String UserYesilPop = "UserYesilPop";
        /* module path - Contents - 회계(관리자) - 예실대비현황2조회 */
        String AdminYesil2Report = "AdminYesil2Report";
        /* module path - Contents - 회계(사용자) - 예실대비현황2조회 */
        String UserYesil2Report = "UserYesil2Report";
        /* module path - Popup - 회계(관리자) - 예실대비현황2 지출결의현황 조회 - 팝업 */
        String AdminYesil2DetailPop = "AdminYesil2DetailPop";
        /* module path - Popup - 회계(관리자) - 예실대비현황2 결의부서조회 - 팝업 */
        String AdminYesil2DeptPop = "AdminYesil2DeptPop";
        /* module path - Popup - 회계(관리자) - 예실대비현황2 예산단위그룹 - 팝업 */
        String AdminYesil2BudgetGrPop = "AdminYesil2BudgetGrPop";
        /* module path - Popup - 회계(관리자) - 예실대비현황2 예산단위 - 팝업 */
        String AdminYesil2BudgetDeptPop = "AdminYesil2BudgetDeptPop";
        /* module path - Popup - 회계(관리자) - 예실대비현황2 사업계획 - 팝업 */
        String AdminYesil2BizPlanPop = "AdminYesil2BizPlanPop";
        /* module path - Popup - 회계(관리자) - 예실대비현황2 예산계정 - 팝업 */
        String AdminYesil2BudgetAcctPop = "AdminYesil2BudgetAcctPop";
        /* module path - Popup - 회계(사용자) - 예실대비현황2 예산단위그룹 - 팝업 */
        String UserYesil2BudgetGrPop = "UserYesil2BudgetGrPop";
        /* module path - Popup - 회계(사용자) - 예실대비현황2 예산단위 - 팝업 */
        String UserYesil2BudgetDeptPop = "UserYesil2BudgetDeptPop";
        /* module path - Popup - 회계(사용자) - 예실대비현황2 사업계획 - 팝업 */
        String UserYesil2BizPlanPop = "UserYesil2BizPlanPop";
        /* module path - Popup - 회계(사용자) - 예실대비현황2 예산계정 - 팝업 */
        String UserYesil2BudgetAcctPop = "UserYesil2BudgetAcctPop";
        /* 공통 에러 출력 페이지 */
        String cmError = "cmError";
        /* 권한 에러 출력 페이지 */
        String cmErrorCheckAuth = "cmErrorCheckAuth";
        /* 로그인 세션 에러 출력 페이지 */
        String cmErrorCheckLogin = "cmErrorCheckLogin";
        /* 전자결재 양식설정 에러 출력 페이지 */
        String cmErrorCheckDocSetting = "cmErrorCheckDocSetting";
        /* ERP 정보 에러 출력 페이지 */
        String cmErrorCheckERP = "cmErrorCheckERP";
        /* ERP iCUBE G20 설정 에러 출력 페이지 */
        String cmErrorCheckICUBEG20Type = "cmErrorCheckICUBEG20Type";
        /* ERP 사번 매핑 미진행 접근 */
        String cmErrorCheckErpEmpCdMapping = "cmErrorCheckErpEmpCdMapping";
        /* ERP 연동 정보 오류 접근 */
        String cmErrorCheckErpSetting = "cmErrorCheckErpSetting";
        /* 지출결의 가져오기 팝업 */
        String ExpendHistoryPop = "ExExpendHistoryPopup";
        /* iCUBE 매입전자세금계산서 현황 페이지 */
        String AdminiCUBEETaxReport = "AdminETaxReportiCUBE";
        /* iCUBE 매입전자세금계산서 현황 페이지 */
        String AdminERPiUETaxReport = "AdminETaxReportERPiU";
        /* NP 매입전자세금계산서 현황 페이지 */
        String AdminNPETaxReportERPiU = "AdminNPETaxReportERPiU";
        String AdminNPETaxReportiCUBE = "AdminNPETaxReportiCUBE";
        /* 세금계산서 권한 설정 페이지 */
        String AdminETaxAuthSetting = "AdminETaxAuthSetting";
        /* 카드 검색조건 카드 조회 팝업 */
        String ExSearchCardListPop = "ExSearchCardListPop";
        /*****************************************************************
         * [ 비영리 ] 컨텐트 경로
         */
        /*
         * [ 비영리 ] 상태 코드 확인 페이지
         */
        String UserConsResTestPage = "UserConsResTestPage";
        String UserStatTastPage = "UserStatTastPage";
        String UserCodeTestPage = "UserCodeTestPage";
        String UserCodePopTestPage = "UserCodePopTestPage";
        String UserBudgetBalanceTestPage = "UserBudgetBalanceTestPage";
        String UserProcedureTestPage = "UserProcedureTestPage";
        String UserCardDetailPopTestPage = "UserCardDetailPopTestPage";
        String UserETaxDetailPopTestPage = "UserETaxDetailPopTestPage";
        String UserAPITestPage = "UserAPITestPage";
        /*
         * [ 비영리 ] 지출결의 옵션 페이지
         */
        String AdminNPExpendSetting = "AdminNPExpendSetting";
        String AdminNPMasterOption = "AdminNPMasterOption";
        String AdminNPFormOption = "AdminNPFormOption";
        String AdminNPFormSetting = "AdminNPFormSetting";
        String NpAdminConsConfferReturn = "NpAdminConsConfferReturn";
        /*
         * [ 비영리 ] 지출결의 현황 페이지
         */
        String AdminResSendList = "AdminResSendList";
        String AdminNPCardReport = "AdminNPCardReport";
        String AdminNPConsReport = "AdminNPConsReport";
        String AdminNPResReport = "AdminNPResReport";
        String UserNPCardReport = "UserNPCardReport";
        String UserNPConsReport = "UserNPConsReport";
        String UserNPConsConfferReturn = "UserNPConsConfferReturn";
        String UserNPResReport = "UserNPResReport";
        String UserNPETaxReportERPiU = "UserNPETaxReportERPiU";
        String UserNPETaxReportiCUBE = "UserNPETaxReportiCUBE";
        /*
         * [ 비영리 ] 지출결의 G20 예실대비 현황
         */
        String UserNpG20Yesil = "UserNpG20Yesil";
        String AdminNpG20Yesil = "AdminNpG20Yesil";
        String AdminYesilConsAmtDetailInfo = "AdminYesilConsAmtDetailInfo";
        String AdminYesilResAmtDetailInfo = "AdminYesilResAmtDetailInfo";
        String AdminYesilERPResAmtDetailInfo = "AdminYesilERPResAmtDetailInfo";
        /*
         * [ 비영리 ] 팝업 경로
         */
        String UserConsPop = "UserConsPop";
        String UserResPop = "UserResPop";
        String NUserConsPop = "NUserConsPop";
        String NUserResPop = "NUserResPop";
        String NUserResPopTemp = "NUserResPopTemp";

        String NUserResPopOneSystem = "NUserResPopOneSystem";
        String UserCommonCodePop = "UserCommonCodePop";
        String UserConfferPop = "UserConfferPop";
        String UserCardHistoryPop = "UserCardHistoryPop";
        String UserETaxHistoryPop = "UserETaxHistoryPop";
        String UserCardTransHistoryPop = "UserCardTransHistoryPop";
        String UserETaxTransHistoryPop = "UserETaxTransHistoryPop";
        String UserCardDetailPop = "UserCardDetailPop";
        String UserETaxDetailPopI = "UserETaxDetailPopI";
        String UserETaxDetailPopU = "UserETaxDetailPopU";
        String UserConsReUsePop = "UserConsReUsePop";
        String UserResReUsePop = "UserResReUsePop";
        /******************************************************************/
    }

    /* 지출결의 리뉴얼 */
    public static interface Ex2Path {

        /* 기본 경로 */
        String AdminContent = "/expend/ex2/admin/content/";
        String UserContent = "/expend/ex2/user/content/";
        String AdminPopup = "/expend/ex2/admin/popup/";
        String UserPopup = "/expend/ex2/user/popup/";
        /* 표준적요 설정 */
        String ConfigSummary = "Ex2ConfigSummary";
        /* 증빙유형 설정 */
        String ConfigAuth = "Ex2ConfigAuth";
    }

    /* 국고보조금통합시스템 연계 Path 정의 */
    public interface commonAnguPath {

        /* module path */
        /* module path - Contents Path */
        String MasterContentPath = "/expend/angu/master/content/";
        String AdminContentPath = "/expend/angu/admin/content/";
        String UserContentPath = "/expend/angu/user/content/";
        /* module path - Popup Path */
        String MasterPopPath = "/expend/angu/master/pop/";
        String AdminPopPath = "/expend/angu/admin/pop/";
        String UserPopPath = "/expend/angu/user/pop/";
        /* module path - Popup */
        /* module path - Popup - 국고보조집행결의서 */
        String AnguMasterPop = "AnguMasterPop";
        /* module path - Popup - 국고보조집행결의서 - 인력정보 등록 */
        String AnguEmpPop = "AnguEmpPop";
        /* module path - Popup - 국고보조집행결의서 - 예산과목 코드도움 */
        String AnguBudgetListPop = "AnguBudgetListPop";
        /* module path - Popup - 국고보조 공통코드 */
        String AnguCommonCodePop = "AnguCommonCodePop";
        /* module path - Popup - 국고보조 전자세금계산서 */
        String AnguETaxPop = "AnguETaxPop";
        /* module path - Popup - 국고보조 카드거래내역 */
        String AnguCardPop = "AnguCardPop";
        /* module path - Popup - 국고보조 급여자료 */
        String AnguEmpPayPop = "AnguEmpPayPop";
        /* module path - Popup - 국고보조 기타소득자 */
        String AnguEtcPayPop = "AnguEtcPayPop";
        /* module path - Popup - 국고보조 사업소득자 */
        String AnguCompPayPop = "AnguCompPayPop";
        /* module path - Popup - 국고보조 소득 정보 */
        String AnguPaymentPop = "AnguPaymentPop";
    }

    /* 업무용승용차 Path 정의 */
    public interface commonBiPath {

        /* module path */
        /* module path - Contents Path */
        String MasterContentPath = "/expend/bi/master/content/";
        String AdminContentPath = "/expend/bi/admin/content/";
        String UserContentPath = "/expend/bi/user/content/";
        String ErrorPagePath = "/expend/common/error/"; /* 에러출력 페이지 기본 URL */
        /* module path - Popup Path */
        String MasterPopPath = "/expend/bi/master/pop/";
        String AdminPopPath = "/expend/bi/admin/pop/";
        String UserPopPath = "/expend/bi/user/pop/";
        /* 공통 에러 출력 페이지 */
        String cmError = "cmError";
        /* 권한 에러 출력 페이지 */
        String cmErrorCheckAuth = "cmErrorCheckAuth";
        /* 로그인 세션 에러 출력 페이지 */
        String cmErrorCheckLogin = "cmErrorCheckLogin";
        /* ERP 정보 에러 출력 페이지 */
        String cmErrorCheckERP = "cmErrorCheckERP";
        /* module path - Content - 차량공개범위 관리 */
        String AdminCarPublic = "AdminCarPublic";
        /* module path - Content - 사용자 운행기록부 */
        String UserCarPerson = "UserCarPerson";
        String UserCarSelectPop = "UserCarSelectPop";
    }

    /* 전자결재 연동 API URL */
    public interface commonEaApi {

        String docMake = "/ea/interface/eadocmake.do";
    }

}
