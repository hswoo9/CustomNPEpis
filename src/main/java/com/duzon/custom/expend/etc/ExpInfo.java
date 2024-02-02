package com.duzon.custom.expend.etc;

import bizbox.orgchart.service.vo.LoginVO;
import org.apache.logging.log4j.LogManager;

import javax.servlet.http.HttpServletRequest;

public class ExpInfo {

    private static org.apache.logging.log4j.Logger logger = LogManager.getLogger(ExpInfo.class);

    /* ======================================================================================= */
    private static String LoginLog() {
        String r = "";
        LoginVO login = new LoginVO();

        try {
            login = CommonConvert.CommonGetEmpVO();
        } catch (NotFoundLoginSessionException e) {
            // TODO Auto-generated catch block
        }

        // 2019. 07. 25. 김상겸. groupSeq 추가
        r = "[ groupSeq : " + (login.getGroupSeq() == null || login.getGroupSeq().equals("") ? "NotFound" : login.getGroupSeq());
        r += " / compSeq : " + (login.getCompSeq() == null || login.getCompSeq().equals("") ? "NotFound" : login.getCompSeq());
        r += " / empSeq : " + (login.getUniqId() == null || login.getUniqId().equals("") ? "NotFound" : login.getUniqId()) + " ]";

        return r;
    }

    /* ======================================================================================= */
    // Controller Clog
    public static void CLog() {
        ExpInfo.CLog(null);
    }

    public static void CLog(HttpServletRequest request) {
        ExpInfo.CLog(request, null);
    }

    public static void CLog(HttpServletRequest request, Object params) {
        ExpInfo.CLog(request, params, null);
    }

    public static void CLog(HttpServletRequest request, Object params, String ip) {
        StringBuilder sb = new StringBuilder();

        sb.append("[DEF_CLog] ");
        if (request != null) {
            sb.append(request.getRequestURL());
        } else {
            sb.append("request is not defined");
        }

        sb.append(" || ");

        if (params != null) {
            sb.append(params.toString());
        } else {
            sb.append("params is not defined");
        }

        sb.append(" || ");

        if (ip != null) {
            sb.append(ip);
        } else {
            sb.append("ip is not defined");
        }

        sb.append(" || ");

        // 2019. 07. 25. 김상겸. groupSeq 추가
        sb.append(ExpInfo.LoginLog());

        // logger.info(sb.toString());
    }

    public static void CLog(String message, Object params) {
        StringBuilder sb = new StringBuilder();

        sb.append("[DEF_CLog]");

        // 2019. 07. 25. 김상겸. groupSeq 추가
        sb.append(ExpInfo.LoginLog());

        sb.append(" || ");

        if (message != null) {
            sb.append(message);
        } else {
            sb.append("message is not defined");
        }

        sb.append(" || ");

        if (params != null) {
            sb.append(params.toString());
        } else {
            sb.append("params is not defined");
        }

        // logger.info(sb.toString());
    }
    /* ======================================================================================= */

    /* ======================================================================================= */
    // Service
    public static void BLog() {
        ExpInfo.BLog(null);
    }

    public static void BLog(String message) {
        ExpInfo.BLog(message, null);
    }

    public static void BLog(String message, Object params) {
        StringBuilder sb = new StringBuilder();

        sb.append("[DEF_BLog]");

        // 2019. 07. 25. 김상겸. groupSeq 추가
        sb.append(ExpInfo.LoginLog());

        sb.append(" || ");

        if (message != null) {
            sb.append(message);
        } else {
            sb.append("message is not defined");
        }

        sb.append(" || ");

        if (params != null) {
            sb.append(params.toString());
        } else {
            sb.append("params is not defined");
        }

        // logger.info(sb.toString());
    }

    public static void FLog(String message, Object params) {
        StringBuilder sb = new StringBuilder();

        sb.append("[DEF_FLog]");

        // 2019. 07. 25. 김상겸. groupSeq 추가
        sb.append(ExpInfo.LoginLog());

        sb.append(" || ");

        if (message != null) {
            sb.append(message);
        } else {
            sb.append("message is not defined");
        }

        sb.append(" || ");

        if (params != null) {
            sb.append(params.toString());
        } else {
            sb.append("params is not defined");
        }

        // logger.info(sb.toString());
    }
    /* ======================================================================================= */

    /* ======================================================================================= */
    // DAO
    public static void DLog(String message, Object params) {
        StringBuilder sb = new StringBuilder();

        sb.append("[DEF_DLog]");

        // 2019. 07. 25. 김상겸. groupSeq 추가
        sb.append(ExpInfo.LoginLog());

        sb.append(" || ");

        if (message != null) {
            sb.append(message);
        } else {
            sb.append("message is not defined");
        }

        sb.append(" || ");

        if (params != null) {
            sb.append(params.toString());
        } else {
            sb.append("params is not defined");
        }

        // logger.info(sb.toString());
    }
    /* ======================================================================================= */

    /* ======================================================================================= */
    // TipLog
    public static void TipLog(String message) {
        ExpInfo.TipLog(message, null);
    }

    public static void TipLog(String message, Object params) {
        StringBuilder sb = new StringBuilder();

        sb.append("[DEF_TipLog]");

        // 2019. 07. 25. 김상겸. groupSeq 추가
        sb.append(ExpInfo.LoginLog());

        sb.append(" || ");

        if (message != null) {
            sb.append(message);
        } else {
            sb.append("message is not defined");
        }

        sb.append(" || ");

        if (params != null) {
            sb.append(params.toString());
        } else {
            sb.append("params is not defined");
        }

        // logger.info(sb.toString());
    }
    /* ======================================================================================= */

    /* ======================================================================================= */
    // ProcessLog
    public static void ProcessLog(String message) {
        ExpInfo.ProcessLog(message, null);
    }

    public static void ProcessLog(String message, Object params) {
        StringBuilder sb = new StringBuilder();

        sb.append(System.getProperty("line.separator"));
        sb.append("+++++ [DEF_ProcessLog] ##################################################");

        try {
            LoginVO login = new LoginVO();
            login = CommonConvert.CommonGetEmpVO();

            sb.append(System.getProperty("line.separator"));
            sb.append(">>>>> [DEF_ProcessLog] groupSeq : " + login.getGroupSeq());
            sb.append(System.getProperty("line.separator"));
            sb.append(">>>>> [DEF_ProcessLog] compSeq : " + login.getCompSeq());
            sb.append(System.getProperty("line.separator"));
            sb.append(">>>>> [DEF_ProcessLog] empSeq : " + login.getUniqId());
        } catch (Exception e) {
            sb.append(">>>>> [DEF_ProcessLog] login session is not defined");
        }

        if (message != null) {
            sb.append(System.getProperty("line.separator"));
            sb.append(">>>>> [DEF_ProcessLog] message : " + message);
        } else {
            sb.append(System.getProperty("line.separator"));
            sb.append(">>>>> [DEF_ProcessLog] message is not defined");
        }

        if (params != null) {
            sb.append(System.getProperty("line.separator"));
            sb.append(">>>>> [DEF_ProcessLog] params : " + params);
        } else {
            sb.append(System.getProperty("line.separator"));
            sb.append(">>>>> [DEF_ProcessLog] params is not defined");
        }

        sb.append(System.getProperty("line.separator"));
        sb.append("----- [DEF_ProcessLog] ##################################################");

        // logger.info(sb.toString());
    }
    /* ======================================================================================= */

    /* ======================================================================================= */
    // CoreLog
    public static void CoreLogNotLoop(String message, Object params) {
        StringBuilder sb = new StringBuilder();

        sb.append(System.getProperty("line.separator"));
        sb.append("+++++ [DEF_CoreLog] ##################################################");

        if (message != null) {
            sb.append(System.getProperty("line.separator"));
            sb.append(">>>>> [DEF_CoreLog] message : " + message);
        } else {
            sb.append(System.getProperty("line.separator"));
            sb.append(">>>>> [DEF_CoreLog] message is not defined");
        }

        if (params != null) {
            sb.append(System.getProperty("line.separator"));
            sb.append(">>>>> [DEF_CoreLog] params : " + params);
        } else {
            sb.append(System.getProperty("line.separator"));
            sb.append(">>>>> [DEF_CoreLog] params is not defined");
        }

        sb.append(System.getProperty("line.separator"));
        sb.append("----- [DEF_CoreLog] ##################################################");

        // logger.info(sb.toString());
    }

    public static void CoreLog(String message, Object params) {
        StringBuilder sb = new StringBuilder();

        sb.append(System.getProperty("line.separator"));
        sb.append("+++++ [DEF_CoreLog] ##################################################");

        if (message != null) {
            sb.append(System.getProperty("line.separator"));
            sb.append(">>>>> [DEF_CoreLog] message : " + message);
        } else {
            sb.append(System.getProperty("line.separator"));
            sb.append(">>>>> [DEF_CoreLog] message is not defined");
        }

        if (params != null) {
            sb.append(System.getProperty("line.separator"));
            sb.append(">>>>> [DEF_CoreLog] params : " + params);
        } else {
            sb.append(System.getProperty("line.separator"));
            sb.append(">>>>> [DEF_CoreLog] params is not defined");
        }

        sb.append(System.getProperty("line.separator"));
        sb.append("----- [DEF_CoreLog] ##################################################");

        logger.info(sb.toString());
    }

    public static void TempLog(String message, Object params) {
        StringBuilder sb = new StringBuilder();

        sb.append(System.getProperty("line.separator"));
        sb.append("+++++ [DEF_TempLog] ##################################################");

        if (message != null) {
            sb.append(System.getProperty("line.separator"));
            sb.append(">>>>> [DEF_TempLog] message : " + message);
        } else {
            sb.append(System.getProperty("line.separator"));
            sb.append(">>>>> [DEF_TempLog] message is not defined");
        }

        if (params != null) {
            sb.append(System.getProperty("line.separator"));
            sb.append(">>>>> [DEF_TempLog] params : " + params);
        } else {
            sb.append(System.getProperty("line.separator"));
            sb.append(">>>>> [DEF_TempLog] params is not defined");
        }

        sb.append(System.getProperty("line.separator"));
        sb.append("----- [DEF_TempLog] ##################################################");

        logger.info(sb.toString());
    }
    /* ======================================================================================= */

    /* ======================================================================================= */
    // call check
    public static void CallCheckLog(String message) {
        ExpInfo.CallCheckLog(message, null);
    }

    public static void CallCheckLog(String message, Object params) {
        // /expend/user/code/ExUserSummaryListInfoSelect.do
        // /expend/user/code/ExUserAuthListInfoSelect.do
        // /expend/user/code/ExUserProjectListInfoSelect.do
        // /expend/user/code/ExUserPartnerListInfoSelect.do
        // /expend/user/code/ExUserCardListInfoSelect.do
        // /expend/ex/user/budget/ExBudgetInfoSelect.do
        // /expend/ex/user/code/ExCodeInfoSelect.do

        StringBuilder sb = new StringBuilder();

        sb.append("[DEF_CallCheckLog]");

        // 2019. 07. 25. 김상겸. groupSeq 추가
        sb.append(ExpInfo.LoginLog());

        sb.append(" || ");

        if (message != null) {
            sb.append(message);
        } else {
            sb.append("message is not defined");
        }

        sb.append(" || ");

        if (params != null) {
            sb.append(params.toString());
        } else {
            sb.append("params is not defined");
        }

        // logger.info(sb.toString());
    }
    /* ======================================================================================= */

    /* ======================================================================================= */
    // slow process
    public static void SlowProcess(String message) {
        StringBuilder sb = new StringBuilder();

        sb.append("[DEF_SlowProcessLog] ");
        sb.append(message);

        // logger.info(sb.toString());
    }
    /* ======================================================================================= */

    /* ======================================================================================= */
    public static void InfoLog(String message) {
        logger.info(message);
    }
    /* ======================================================================================= */

}
