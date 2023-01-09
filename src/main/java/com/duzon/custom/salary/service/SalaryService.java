package com.duzon.custom.salary.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public interface SalaryService {
	
	public List<Map<String, Object>> getSalaryViewDetailList(Map<String, Object> params);
	
	public Map<String, Object> getHrPaySlipPop(Map<String, Object> params) throws Exception;
	
	public Map<String, Object> getJoinDay(Map<String, Object> params);
	
	public Map<String, Object> getSelectWorkingDays(Map<String, Object> params);
	
	public Map<String, Object> getSelectYetWorkingDays(Map<String, Object> params);
	
	public Map<String, Object> getSelectAnnualDays(Map<String, Object> params);
	
	public List<Map<String, Object>> getSelectOverWork(Map<String, Object> params);
	
	public List<Map<String, Object>> getSelectDalmMonthList(Map<String, Object> params);
}
