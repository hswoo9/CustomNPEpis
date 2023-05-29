package com.duzon.custom.loginPage.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import bizbox.orgchart.service.vo.LoginVO;
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

	public LoginVO actionLogin(Map<String, Object> params) throws Exception {
		return (LoginVO) selectOne("loginPage.actionLogin", params);
	}

	public Map<String, Object> selectOptionSet(Map<String, Object> mp){

		Map<String, Object> option = new HashMap<>();

		@SuppressWarnings("unchecked")
		List<Map<String, Object>> listMap = selectList("loginPage.selectOption", mp);

		if(listMap != null && listMap.size() > 0){
			for (Map<String, Object> map : listMap) {
				option.put((String)map.get("optionId"), map.get("optionValue") == null ? (String)map.get("optionDValue") : (String)map.get("optionValue"));
			}
		}

		return option;
	}
}
