package com.duzon.custom.commcode.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.duzon.custom.common.dao.AbstractDAO;
@Repository
public class CodeDAO extends AbstractDAO{
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectCode(Map<String, Object> map) {

		return selectList("code.codeList",map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> subCodeList(Map<String, Object> map) {

		return selectList("code.subCodeList",map);
	}
	/**
	 * 날   짜 : 2017. 9. 21.
	 * 만든이 : chan
	 * 설    명: 코드 리스트 토탈
	 */
	
	public int selectCodeTotal(Map<String, Object> map) {
		return (int) selectOne("code.codeListTotal",map);
	}
	public int subCodeListTotal(Map<String, Object> map) {
		return (int) selectOne("code.subCodeListTotal",map);
	}
	public int addCommCode(Map<String, Object> map) {
		return (int) insert("code.addCommCode", map);
	}
	
	public int addSubCode(Map<String, Object> map) {
		return (int) insert("code.addSubCode", map);
	}
	
	public int delCommCode(Map<String, Object> loginMap) {
		return (int) update("code.delCommCode", loginMap);
	}
	public int subDelCommCode(Map<String, Object> loginMap) {
		return (int) update("code.subDelCommCode", loginMap);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectCommManageList(Map<String, Object> map) {

		return selectList("code.commManageList",map);
	}
	
	public int selectCommManageListTotal(Map<String, Object> map) {
		return (int) selectOne("code.commManageListTotal",map);
	}
	public int commonMod(Map<String, Object> map) {
		return (int) update("code.commonMod", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getCommCodeList(Map<String, Object> map) {
		return (List<Map<String, Object>>)selectList("code.getCommCodeList", map);
	}
	
	
}
