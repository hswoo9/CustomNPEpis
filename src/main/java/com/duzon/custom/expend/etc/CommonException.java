package com.duzon.custom.expend.etc;

import ac.cmm.vo.ConnectionVO2;
import com.duzon.custom.expend.etc.CommonInterface.commonCode;
public class CommonException {

    public static void Login() throws NotFoundLoginSessionException {
        if (CommonConvert.CommonGetEmpInfo() == null) { throw new NotFoundLoginSessionException("로그인 세션 검색 실패"); }
    }

    public static void AdminAuth() throws CheckAuthorityException, NotFoundLoginSessionException {
        if (!CommonConvert.CommonGetStr(CommonConvert.CommonGetEmpInfo().get(commonCode.userSe)).equals(commonCode.admin)) { throw new CheckAuthorityException("권한이 맞지 않습니다."); }
    }

    /**
     * ERP<br />
     * - ERP 연동여부 확인
     *
     * @param conVo
     * @throws CheckErpTypeException
     */
    public static void ERP(ConnectionVO2 conVo) throws CheckErpTypeException {
        if (!CommonConvert.CommonGetStr(conVo.getErpTypeCode()).equals(commonCode.ERPiU) && !CommonConvert.CommonGetStr(conVo.getErpTypeCode()).equals(commonCode.iCUBE)) { throw new CheckErpTypeException("ERP 연동 실패"); }
    }

    /**
     * iCUBEG20<br />
     * - iCUBE G20 연동여부 확인
     *
     * @param conVo
     * @throws CheckICUBEG20TypeException
     */
    public static void iCUBEG20(ConnectionVO2 conVo) throws CheckICUBEG20TypeException {
        if (CommonConvert.CommonGetStr(conVo.getErpTypeCode()).equals(commonCode.iCUBE) && CommonConvert.CommonGetStr(conVo.getG20YN()).equals(commonCode.emptyNo)) { throw new CheckICUBEG20TypeException("iCUBE G20 설정확인이 필요함."); }
    }

}
