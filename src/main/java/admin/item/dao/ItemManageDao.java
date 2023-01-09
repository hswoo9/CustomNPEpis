package admin.item.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Repository;

import neos.cmm.db.CommonSqlDAO;

@Repository("ItemManageDao")
public class ItemManageDao {

	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getItemSetList(Map<String, Object> paramMap) {
					
		return commonSql.list("ItemManageDAO.getItemSetList", paramMap);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getItemSetListPop(Map<String, Object> paramMap) {
		
		return commonSql.list("ItemManageDAO.getItemSetListPop", paramMap);
	}

	public void insertItem(List<Map<String, Object>> list) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("list", list);
		commonSql.insert("ItemManageDAO.insertItem", paramMap);
		
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getCalCnts(Map<String, Object> paramMap) {
		
		return (Map<String, Object>) commonSql.selectByPk("ItemManageDAO.getCountItems", paramMap);
	}

	public void deleteItem(Map<String, Object> paramMap) {
		
		commonSql.delete("ItemManageDAO.deleteItem", paramMap);
	}

	public void deleteFormItem(Map<String, Object> paramMap) {
		commonSql.delete("ItemManageDAO.deleteFormItem",paramMap);		
	}
	
	public List<Map<String, Object>> GetItemList(Map<String, Object> paramMap){
		return (List<Map<String, Object>>) commonSql.list("ItemManageDAO.GetItemList", paramMap);
	}
}
