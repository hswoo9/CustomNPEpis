package com.duzon.custom.commcode.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.duzon.custom.commcode.dao.CodeDAO;

@Service
public class CListService implements CodeService {
	
	@Autowired
	private CodeDAO codeDAO;
	@Override
	public void execute(Model model) {
		
	}
	@Override
	public int addCommCode(Map<String, Object> map) {
		return codeDAO.addCommCode(map);
	}
	
	
	
	
	/**2017. 9. 21.
	 * 만든이 : chan hyuk
		설명 :
	 */	
	

	@Override
	public List<Map<String, Object>> codeList(Map<String, Object> map) {
		return codeDAO.selectCode(map);
	}
	
	@Override
	public int codeListTotal(Map<String, Object> map) {

		return codeDAO.selectCodeTotal(map);
	}
	
	
	@Override
	public void delCommCode(Map<String, Object> loginMap, Map<String, Object> map) {
		String[] delCode = ((String) map.get("data")).split(",");
		for (int i = 0; i < delCode.length; i++) {
			loginMap.put("common_code_id", delCode[i]);
			codeDAO.delCommCode(loginMap);
		}
		
	}
	
	public int commonMod(Map<String, Object> map) {
		
		return codeDAO.commonMod(map);
	}
	public List<Map<String, Object>> getCommCodeList(Map<String, Object> map) {
		return codeDAO.getCommCodeList(map);
	}
}
