package com.duzon.custom.common.utiles;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import bizbox.orgchart.service.vo.LoginVO;


/**
 * YH
 * 2017. 12. 18.
 * 설명 : 세션정보 호출
 */
public class CtEmpInfo {

	
	public static Map<String, Object> getEmpInfo(HttpServletRequest sr) {

		Map<String, Object> result = new HashMap<String, Object>();

		LoginVO loginVo = (LoginVO) sr.getSession().getAttribute("loginVO");
		if (loginVo == null) {

			loginVo = new bizbox.orgchart.service.vo.LoginVO();
			loginVo.setGroupSeq("demo");
			loginVo.setCompSeq("707010002050");
			loginVo.setBizSeq("707010002050");
			loginVo.setOrgnztId("707010002051");
			loginVo.setUniqId("1205");
			loginVo.setLangCode("kr");
			loginVo.setUserSe("ADMIN");
			loginVo.setErpEmpCd("1205");
			loginVo.setErpCoCd("3585");
			loginVo.setEaType("eap");
			loginVo.setEmail("devjitsu");
			loginVo.setEmailDomain("st-tech.org");
			loginVo.setId("devjitsu");
			loginVo.setEmpname("데브짓수");
			loginVo.setOrganNm("에스티");

		}
		
		result.put("organNm", loginVo.getOrganNm()); /* 부서 명 */
		result.put("empName", loginVo.getEmpname()); /* 사원 이름 */
		result.put("groupSeq", loginVo.getGroupSeq()); /* 그룹시퀀스 */
		result.put("compSeq", loginVo.getCompSeq()); /* 회사시퀀스 */
		result.put("bizSeq", loginVo.getBizSeq()); /* 사업장시퀀스 */
		result.put("deptSeq", loginVo.getOrgnztId()); /* 부서시퀀스 */
		result.put("empSeq", loginVo.getUniqId()); /* 사원시퀀스 */
		result.put("langCode", loginVo.getLangCode()); /* 사용언어코드 */
		result.put("userSe", loginVo.getUserSe()); /* 사용자접근권한 */
		result.put("erpEmpSeq", loginVo.getUniqId()); /* ERP사원번호 */
		result.put("erpCompSeq", loginVo.getErpCoCd()); /* ERP회사코드 */
		result.put("eaType", loginVo.getEaType()); /* 연동 전자결재 구분 */
		result.put("eaType", loginVo.getEaType()); /* 연동 전자결재 구분 */
		result.put("email", loginVo.getEmail() + "@" + loginVo.getEmailDomain()); /* 연동 이메일 */
		result.put("id", loginVo.getId()); /* 연동 id */

		return result;

	}

}
