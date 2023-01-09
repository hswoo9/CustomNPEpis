package com.duzon.custom.loginPage.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

import com.duzon.custom.common.dao.AbstractDAO;

@Repository
public class LoginPageDAO extends AbstractDAO {

	@SuppressWarnings("unchecked")
	public Map<String, Object> existUserYn(Map<String, Object> map) {
		return (Map<String, Object>) selectOne("loginPage.existUserYn", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> loginAgreementPop(Map<String, Object> map) {
		return (Map<String, Object>) selectOne("loginPage.loginAgreementPop", map);
	}

	public void updateAgreement(Map<String, Object> map) {
		update("loginPage.updateAgreement", map);
		
	}

	public String getCurrTime(Map<String, Object> map) {
		return (String)selectOne("loginPage.getCurrTime", map);
	}

}
