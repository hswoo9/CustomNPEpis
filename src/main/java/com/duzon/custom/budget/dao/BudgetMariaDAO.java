package com.duzon.custom.budget.dao;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.duzon.custom.common.dao.AbstractDAO;

@Repository("BudgetMariaDAO")
public class BudgetMariaDAO extends AbstractDAO {

	// 프로젝트, 하위사업, 예산과목에 대한 품의액 조회
	public Map<String, Object> getPreBudgetInfo(Map<String, Object> map) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try {
			Map<String, Object> gwBudgetConsAmt = (Map<String, Object>) selectOne("BudgetMaria.getPreBudgetInfoCons", map);
			Map<String, Object> gwBudgetResAmt = (Map<String, Object>) selectOne("BudgetMaria.getPreBudgetInfoRes", map);
			BigDecimal gw_APPLY_AM_1 = (BigDecimal)gwBudgetConsAmt.get("APPLY_AM");
			BigDecimal gw_APPLY_AM_2 = (BigDecimal)gwBudgetResAmt.get("APPLY_AM");
			BigDecimal new_REFER_AM = new_REFER_AM = gw_APPLY_AM_1.subtract(gw_APPLY_AM_2);
			resultMap.put("applyAm", new_REFER_AM);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultMap;
		//return (Map<String, Object>) selectOne("BudgetMaria.getPreBudgetInfo", map);
	}

	// 하위사업에 대한 부서 조회
	public Map<String, Object> getDeptInfo(Map<String, Object> map) {
		return (Map<String, Object>) selectOne("BudgetMaria.getDeptInfo", map);
	}
	
	// 프로젝트, 하위사업과 매핑된 부서목록 조회
	public Map<String, Object> getBtmInfoList(Map<String, Object> map) {
		return (Map<String, Object>) selectOne("BudgetMaria.getBtmInfoList", map);
	}
	
	// 프로젝트, 하위사업과 매핑된 부서정보 조회
	public Map<String, Object> getBtmDeptInfo(Map<String, Object> map) {
		return (Map<String, Object>) selectOne("BudgetMaria.getBtmDeptInfo", map);
	}
	
	// 프로젝트, 하위사업, 부서코드 저장 (Insert)
	public void insertDept(Map<String, Object> map) {
		insert("BudgetMaria.insertDept", map);
	}
	
	// 프로젝트, 하위사업, 부서코드 저장 (Update)
	public void updateDept(Map<String, Object> map) {
		update("BudgetMaria.updateDept", map);
	}
	
	// 예산집계 테이블내 데이터 존재여부 체크 (회사코드, 년월, 회계단위, 프로젝트코드, 하위사업코드, 예산코드)
	public int getBudgetCnt(Map<String, Object> map) {
		return (int) selectOne("BudgetMaria.getBudgetCnt", map);
	}
	
	// 예산집계 테이블 저장 (Insert)
	public void insertBudget(Map<String, Object> map) {
		insert("BudgetMaria.insertBudget", map);
	}
	
	// 프로젝트, 하위사업, 부서코드 저장 (Update)
	public void updateBudget(Map<String, Object> map) {
		update("BudgetMaria.updateBudget", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getPreBudgetInfo2(Map<String, Object> map) {
		return (Map<String, Object>) selectOne("BudgetMaria.getPreBudgetInfo2", map);
	}
	
}
