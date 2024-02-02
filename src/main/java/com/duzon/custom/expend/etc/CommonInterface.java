package com.duzon.custom.expend.etc;

public class CommonInterface {

    public interface ifBudgetRange {

        int minG = 1; /* bizboxA 예산 연동 시작 */
        int maxG = 1000; /* bizboxA 예산 연동 종료 */
        int minU = 1001; /* ERPiU 예산 연동 시작 */
        int maxU = 2000; /* ERPiU 예산 연동 종료 */
        int minI = 2001; /* iCUBE 예산 연동 시작 */
        int maxI = 3000; /* iCUBE 예산 연동 종료 */
        int minGOrg = 3001; /* 예산편성 시작 */
        int maxGOrg = 4000; /* 예산편성 종료 */
        int minGAdj = 4001; /* 예산조정 시작 */
        int maxGAdj = 5000; /* 예산조정 종료 */
    }

    /* CMS 연동 코드 */
    public interface commonCms {
        String CmsType = "cmsType";
        String CmsERPiU = "ERPiU";
        String CmsHaha = "www.kebhana.com";
        String CmsIbk = "www.ibk.co.kr";
        String CmsKb = "www.kbstar.com";
        String CmsNh = "www.nonghyup.com";
        String CmsShinhan = "www.shinhan.com";
        String CmsWoori = "www.wooribank.com";
        String CmsSmart = "smart";
    }

    /* Log module type */
    public interface commonLogModule {

        String Batch = "BATCH";
    }

    /* 공통코드 */
    public interface commonCode {

        /* result auth type */
        String master = "MASTER";
        String admin = "ADMIN";
        String user = "USER";
        /* result code */
        String success = "SUCCESS";
        String fail = "FAIL";
        /* log code */
        String module = "moduleType";
        String type = "logType";
        String message = "message";
        String alertMessage = "alertMessage";
        String error = "ERROR";
        String info = "INFO";
        /* system type */
        String BizboxA = "BizboxA";
        String iCUBE = "iCUBE";
        String ERPiU = "ERPiU";
        String ETC = "ETC";
        String eaType = "eaType";
        String EA = "ea"; /* 비영리 전자결재 */
        String EAP = "eap"; /* 영리 전자결재 */
        String EAA = "eaa"; /* 통합 전자결재 */
        String IFSystem = "ifSystem";
        String Post = "POST";
        String Get = "GET";
        /* form_d_tp */
        String exA = "EXPENDA"; /* 지출결의서 Bizbox Alpha */
        String exI = "EXPENDI"; /* 지출결의서 iCUBE */
        String exU = "EXPENDU"; /* 지출결의서 ERPiU */
        String g20C = "G20CON"; /* G20 품의서 */
        String g20R = "G20RES"; /* G20 결의서 */
        String EziCUBE = "EziCUBE"; /* 이지바로 아이큐브 결의서 */
        String EzERPiU = "EzERPiU"; /* 이지바로 아이유 결의서 */
        String AnguI = "ANGUI"; /* iCUBE 국고보조통합시스템 연계 결의서 */
        String AnguU = "ANGUU"; /* ERPiU 국고보조통합시스템 연계 결의서 */
        String ExNpConI = "EXNPCONI"; /* G20 품의서 */
        String ExNpConU = "EXNPCONU"; /* 원인행위 품의서 */
        String ExNpResI = "EXNPRESI"; /* G20 결의서 */
        String ExNpResU = "EXNPRESU"; /* 원인행위 결의서 */

        /* 출장 복명 외부시스템 연동 코드 */
        String tripCons = "TRIPCONS"; /* 비영리 회계 - 출장복명 2.0 품의서 */
        String tripRes = "TRIPRES"; /* /* 비영리 회계 - 출장복명 2.0 품의서 */

        /* base name def */
        String expPathSeq = "1400"; /* 지출결의 pathSeq */
        String excelPath = "temp/excel"; /* 엑셀 다운로드 임시 보 */
        String expendSeq = "expendSeq";
        String listSeq = "listSeq";
        String slipSeq = "slipSeq";
        String mngSeq = "mngSeq";
        String id = "id";
        String groupSeq = "groupSeq";
        String compSeq = "compSeq";
        String compName = "compName";
        String erpCompSeq = "erpCompSeq";
        String erpCompName = "erpCompName";
        String bizSeq = "bizSeq";
        String bizName = "bizName";
        String erpBizSeq = "erpBizSeq";
        String erpBizName = "erpBizName";
        String deptSeq = "deptSeq";
        String deptName = "deptName";
        String erpDeptSeq = "erpDeptSeq";
        String erpDeptName = "erpDeptName";
        String empSeq = "empSeq";
        String empName = "empName";
        String erpEmpSeq = "erpEmpSeq";
        String erpEmpName = "erpEmpName";
        String erpPcSeq = "erpPcSeq";
        String erpPcName = "erpPcName";
        String erpCcSeq = "erpCcSeq";
        String erpCcName = "erpCcName";
        String langCode = "langCode";
        String userSe = "userSe";
        String formSeq = "formSeq";
        String exDocSeq = "exDocSeq";
        String docSeq = "docSeq";
        String docNo = "docNo";
        String approKey = "approKey";
        String formTp = "formTp";
        String formDTp = "formDTp";
        String processId = "processId";
        String docId = "docId";
        String docSts = "docSts";
        String docTitle = "docTitle";
        String docContent = "docContent";
        String interlockUrl = "interlockUrl";
        String interlockName = "interlockName";
        String useYN = "useYN";
        String fromDate = "fromDate";
        String toDate = "toDate";
        String emptyStr = "";
        String emptySeq = "0";
        String emptyNo = "N";
        String emptyYes = "Y";
        /* common code labeling */
        String codeType = "codeType";
        String Acct = "Acct";
        String Auth = "Auth";
        String BgAcct = "BgAcct";
        String Bizplan = "Bizplan";
        String Budget = "Budget";
        String Card = "Card";
        String Cc = "Cc";
        String Emp = "Emp";
        String ErpAuth = "ErpAuth";
        String Notax = "Notax";
        String Partner = "Partner";
        String Pc = "Pc";
        String Project = "Project";
        String Summary = "Summary";
        String Va = "Va";
        String VatType = "VatType";
        String ACCT = "ACCT";
        String AUTH = "AUTH";
        String BGACCT = "BGACCT";
        String BIZPLAN = "BIZPLAN";
        String BUDGET = "BUDGET";
        String CARD = "CARD";
        String CC = "CC";
        String EMP = "EMP";
        String DEPT = "DEPT";
        String EMPONE = "EMPONE";
        String ERPAUTH = "ERPAUTH";
        String NOTAX = "NOTAX";
        String PARTNER = "PARTNER";
        String PC = "PC";
        String PROJECT = "PROJECT";
        String SUMMARY = "SUMMARY";
        String BIZ = "BIZ";
        String VA = "VA";
        String VATTYPE = "VATTYPE";
        String REGNOPARTNER = "REGNOPARTNER";
        /* base code */
        String bizboxComp = "Comp";
        String bizboxForm = "Form";
        String bizboxPosition = "Position";
        String bizboxGrade = "Grade";
        String bizboxCode = "CommonCode";
        /* ex code */
        String sendYN = "ex00015";
        String drcrType = "ex00017";
        String mngMapType = "ex00018";
        String summaryType = "ex00002"; /* 표준적요구분 */
        String summarySearchType = "ex00003"; /* 검색조건(표준적요)구분 */
        /* ea code */
        String docStatus = "ea0015";
        /* ez code */
        String seq = "seq";
        /* 지출결의 매입전자세금계산서 최근 죄회 건수 설정 */
        int eTaxDeafaultCount = 100;
        String searchStr = "searchStr";

        /* np code */
        String consDocSeq = "consDocSeq";
        String resDocSeq = "resDocSeq";
        String canBgt = "canBgt";
        String EXCEED = "EXCEED";
        String expendDt = "expendDt";
        String tripConsDocSeq = "tripConsDocSeq";
        String tripResDocSeq = "tripResDocSeq";

        /* database type */
        String MSSQL = "mssql";
        String ORACLE = "oracle";

        // 20180910 soyoung, interlockName 이전단계 영문/일문/중문 추가
        String interlockNameEn = "interlockNameEn";
        String interlockNameJp = "interlockNameJp";
        String interlockNameCn = "interlockNameCn";
    }

    /* 공통코드 키 */
    public interface commonCodeKey {

        String useYN = "ex00001"; /* [ 사용 / 미사용 ] */
        String yesOrNo = "ex00004";/* [예 / 아니오] */
        String setOrNotSet = "ex00033";/* [설정 / 미설정] */
    }

    /* iCUBE 공통코드 키 */
    public interface commonCodeIKey {
    }

    /* ERPiU 공통코드 키 */
    public interface commonCodeUKey {

        String termType = "FI_N000002"; /* 기간구분 */
        String acctLevelType = "FI_B000040"; /* 계정레벨 */
        String executeType = "FI_P000008"; /* 집행구분 */
        String modulParent = "FI";
        String deptPop = "P_MA_DEPT_SUB1";
        String budgetDeptPop = "P_FI_BGCODE_DEPT_SUB1";
        String bizPlanPop = "P_FI_BIZCODEJO2_SUB1_BIZPLAN";
    }

    /* 회계모듈 테이블 */
    public static interface commonTbl {

        String anbojo = "TExAnbojo";
        String anbojoPay = "TExAnbojoAbdocuPay";
    }

}
