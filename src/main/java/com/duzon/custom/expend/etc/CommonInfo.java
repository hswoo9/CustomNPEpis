package com.duzon.custom.expend.etc;

import bizbox.orgchart.service.vo.LoginVO;
import com.duzon.custom.expend.vo.CustomLabelVO;
import org.apache.logging.log4j.LogManager;
import org.springframework.stereotype.Service;

import ac.cmm.vo.ConnectionVO2;

import javax.annotation.Resource;
import java.util.Map;

import com.duzon.custom.expend.etc.CommonInterface.commonCode;
@Service("CommonInfo")
public class CommonInfo {

    private org.apache.logging.log4j.Logger logger = LogManager.getLogger(this.getClass());

    @Resource(name = "CommonInfoDAO")
    private CommonInfoDAO dao;

    public ConnectionVO2 CommonGetConnectionInfo(LoginVO login) throws Exception, NotFoundLoginSessionException {
        if (login.getCompSeq() == null || login.getCompSeq().equals("")) {
            throw new NotFoundLoginSessionException("CommonGetConnectionInfo - 로그인 정볼를 확인할 수 없습니다.");
        } else {
            return this.CommonGetConnectionInfo(login.getCompSeq());
        }
    }

    public ConnectionVO2 CommonGetConnectionInfo(String compSeq) throws Exception, NotFoundLoginSessionException {
        /*
         * Cloud 버전 사용을 위하여, groupSeq 전송 형태로 변경 - 2018-02-13 - 김상겸
         */
        return CommonGetConnectionInfo(CommonConvert.CommonGetStr(CommonConvert.CommonGetEmpVO().getGroupSeq()), compSeq);
    }

    public ConnectionVO2 CommonGetConnectionInfo(String groupSeq, String compSeq) throws Exception {
        ConnectionVO2 conVo = new ConnectionVO2();
        conVo = dao.SelectCommonConnectionInfo(CommonConvert.CommonGetStr(groupSeq), CommonConvert.CommonGetStr(compSeq));

        if (conVo == null) {
            ExpInfo.TipLog("ERP 연동 설정이 진행되지 않았습니다. ERP 연동 설정을 확인해주세요. =>> ConnectionVO2 == null");
            throw new NotFoundConnectionException("ERP 연동정보 확인중 오류가 발생되었습니다. - 연동정보의 값이 NULL입니다.");
        } else if (conVo.getDatabaseType().equals("")) {
            ExpInfo.TipLog("ERP 연동 설정이 진행되지 않았습니다. ERP 연동 설정을 확인해주세요. =>> ConnectionVO2.getDatabaseType().equals(\"\")");
            throw new NotFoundConnectionException("ERP 연동정보 확인중 오류가 발생되었습니다. - database type의 값이 공백입니다.");
        } else if (!conVo.getErpTypeCode().equals("ERPiU") && !conVo.getErpTypeCode().equals("iCUBE")) {
            ExpInfo.TipLog("ERP 연동 설정이 진행되지 않았습니다. ERP 연동 설정을 확인해주세요. =>> !ConnectionVO2.getErpTypeCode().equals(\"ERPiU\") && !ConnectionVO2.getErpTypeCode().equals(\"iCUBE\")");
            throw new CheckErpVersionException("ERP 연동정보 확인중 오류가 발생되었습니다. - database type의 값이 ERPiU 또는 iCUBE에 해당되지 않습니다.");
        }

        return conVo;
    }

    public ConnectionVO2 CommonGetConnectionInfo(Map<String, Object> param) {
        /* 변수정의 */
        ConnectionVO2 conVo = new ConnectionVO2();
        /* 조회 */
        conVo = dao.SelectCommonConnectionInfo(param);
        /* 반환정의 */
        if (conVo == null || CommonConvert.CommonGetStr(conVo.getErpTypeCode()).equals(commonCode.emptyStr)) {
            conVo = new ConnectionVO2();
            conVo.setDatabaseType(CommonConvert.CommonGetStr(BizboxAProperties.getProperty("BizboxA.DbType")));
            conVo.setDriver(CommonConvert.CommonGetStr(BizboxAProperties.getProperty("BizboxA.DriverClassName")));
            conVo.setUrl(CommonConvert.CommonGetStr(BizboxAProperties.getProperty("BizboxA.Url")));
            conVo.setUserId(CommonConvert.CommonGetStr(BizboxAProperties.getProperty("BizboxA.UserName")));
            conVo.setPassword(CommonConvert.CommonGetStr(BizboxAProperties.getProperty("BizboxA.Password")));
            conVo.setErpTypeCode(commonCode.BizboxA);
        }
        /* 연동시스템 로그 기록 */
        /* 반환처리 */
        return conVo;
    }

    public CustomLabelVO CommonGetCustomLabelInfo(String compSeq, String langCode, String groupSeq) {
        /* 조회 */
        String pCompSeq = CommonConvert.CommonGetStr(compSeq);
        String pLangCode = CommonConvert.CommonGetStr(langCode);
        String pGroupSeq = CommonConvert.CommonGetStr(groupSeq);
        CustomLabelVO vo = new CustomLabelVO(dao.SelectCommonCustomLabelInfo(pCompSeq, pLangCode, pGroupSeq));
        return vo;
    }


}
