package admin.option.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;

@Repository("OptionManageDAO")
public class OptionManageDAO extends EgovComAbstractDAO{
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> GetEAOptionList(Map<String, Object> paramMap) {
		
		Map<String ,Object> resultMap = new HashMap<String ,Object>();
		List<HashMap<String, Object>> resultList =  list("OptionManageDAO.GetEAOptionList", paramMap);
		
		resultMap.put("list", resultList);
		return resultMap;
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> GetEAOptionValueList(Map<String, Object> paramMap) {
		
		Map<String, Object> reultMap = new HashMap<String, Object>();
		List<HashMap<String, Object>> resultList = list("OptionManageDAO.GetEAOptionValueList", paramMap);
		
		reultMap.put("list", resultList);
		return reultMap;
	}
	
	public Integer SetEAOptionValue(Map<String, Object> paramMap){
		return (Integer) insert("OptionManageDAO.SetEAOptionValue", paramMap);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> GetOptionList(Map<String, Object> paramMap) {
		return (Map<String, Object>) selectByPk("OptionManageDAO.GetOptionList", paramMap);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> GetSubOptionList(Map<String, Object> paramMap) {
		List<Map<String, Object>> resultList = list("OptionManageDAO.GetSubOptionList", paramMap);
		return resultList;
	}
	
	/** 
	 * getOPTION doban7 2016. 11. 24.
	 * @param paramMap
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> GetOptionListAll(Map<String, Object> paramMap) {
		return list("OptionManageDAO.GetOptionListAll", paramMap);
	}
}
