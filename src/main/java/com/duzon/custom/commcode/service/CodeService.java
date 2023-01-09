package com.duzon.custom.commcode.service;

import java.util.List;
import java.util.Map;

import org.springframework.ui.Model;

public interface CodeService {
	public void execute(Model model);
	
	/**
	 * 날   짜 : 2017. 9. 21.
	 * 만든이 : 찬혁
	 * 설    명: 코드리스트
	 */
	List<Map<String, Object>> codeList(Map<String, Object> map);
	
	
	
	/**
	 * 날   짜 : 2017. 9. 21.
	 * 만든이 : 찬혁
	 * 설    명: 코드저장
	 */
	
	int addCommCode(Map<String, Object> map);	
	
	
	/**
	 * 날   짜 : 2017. 9. 21.
	 * 만든이 : 찬혁
	 * 설    명: 코드리스트
	 */
	int codeListTotal(Map<String, Object> map);
	
	/**
	 * 날   짜 : 2017. 9. 21.
	 * 만든이 : 찬혁
	 * 설    명: 코드삭제
	 */
	void delCommCode(Map<String, Object> loginMap, Map<String, Object> map);
	
}
