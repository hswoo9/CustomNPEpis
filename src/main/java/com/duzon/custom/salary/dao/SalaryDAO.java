package com.duzon.custom.salary.dao;

import java.util.List;
import java.util.Map;

import com.duzon.custom.salary.vo.TempVO;
import org.springframework.stereotype.Repository;

import com.duzon.custom.common.dao.AbstractDAO;

@Repository
public class SalaryDAO extends AbstractDAO {
	
	// 급여명세서 리스트
	@SuppressWarnings("unchecked")
	//public List<Map<String, Object>> getSalaryViewDetailList(Map<String, Object> params) { return selectList("salary.getSalaryViewDetailList", params); }
	public List<Map<String, Object>> getSalaryViewDetailList(Map<String, Object> params) { return selectListMs("salaryMs.accountingUnitList", params); }
	
	public Map<String, Object> selectErpConnection(Map<String, Object> params) { return (Map<String, Object>) selectOne("salary.selectErpConnection", params); }
	
	//public List<List<Map<String, Object>>> selectHrPaySlipPop(Map<String, Object> params) { return selectList("salary.getSalaryViewDetailList", params); }
	public List<List<Map<String, Object>>> selectHrPaySlipPop(Map<String, Object> params) { return  selectListListMs("salaryMs.selectHrPaySlipPop", params); }
	
	//public Map<String, Object> selectHrPayListEmp(Map<String, Object> params) { return (Map<String, Object>) selectOne("salary.selectErpConnection", params); }
	public Map<String, Object> selectHrPayListEmp(Map<String, Object> params) { return (Map<String, Object>) selectOneMs("salaryMs.selectHrPayListEmp", params); }
	
	public Map<String, Object> getJoinDay(Map<String, Object> params) { return (Map<String, Object>) selectOne("salary.getJoinDay", params); }
	
	public Map<String, Object> getSelectWorkingDays(Map<String, Object> params) { return (Map<String, Object>) selectOneOr2("salaryOr.getSelectWorkingDays", params); }
	
	public Map<String, Object> getSelectYetWorkingDays(Map<String, Object> params) { return (Map<String, Object>) selectOneOr2("salaryOr.getSelectYetWorkingDays", params); }
	
	public Map<String, Object> getSelectAnnualDays(Map<String, Object> params) { return (Map<String, Object>) selectOneOr2("salaryOr.getSelectAnnualDays", params); }
	
	public List<Map<String, Object>> getSelectOverWork(Map<String, Object> params) { return selectListOr2("salaryOr.getSelectOverWork", params); }
	
	public List<Map<String, Object>> getSelectDalmMonthList(Map<String, Object> params) { return selectListOr2("salaryOr.getSelectDalmMonthList", params); }
	
}
