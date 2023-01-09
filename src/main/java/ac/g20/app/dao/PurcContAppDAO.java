package ac.g20.app.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.duzon.custom.commcode.dao.CodeDAO;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;

@Repository("PurcContAppDAO")
public class PurcContAppDAO extends EgovComAbstractDAO{
	
	@Autowired
	CodeDAO codeDAO;

	public void updateDocId(Map<String, Object> bodyMap) throws Exception {
		update("PurcContDAO.updateDocId", bodyMap);
	}
	
	public void updateDocSts(Map<String, Object> bodyMap) throws Exception {
		update("PurcContDAO.updateDocSts", bodyMap);
	}
	
	public int checkPurcContComplete(Map<String, Object> bodyMap) throws Exception {
		return (int)select("PurcContDAO.checkPurcContComplete", bodyMap);
	}
	
	public void updateAbdocuT(Map<String, Object> bodyMap) throws Exception {
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			update("PurcContDAO.updateAbdocuT2", bodyMap);
		}else{
			update("PurcContDAO.updateAbdocuT", bodyMap);
		}
	}
	
	public void updateAbdocuB_ApplyAm(Map<String, Object> bodyMap) throws Exception {
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			update("PurcContDAO.updateAbdocuB_ApplyAm2", bodyMap);
		}else{
			update("PurcContDAO.updateAbdocuB_ApplyAm", bodyMap);
		}
	}

	public void updateReqDocSts(Map<String, Object> bodyMap) throws Exception {
		update("PurcContDAO.updateReqDocSts", bodyMap);
	}

	public Object checkPurcReqType(Map<String, Object> bodyMap) throws Exception {
		return select("PurcContDAO.checkPurcReqType", bodyMap);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> purcContAppSelect(HashMap<String, Object> requestMap) {
		return (Map<String, Object>)select("PurcContDAO.purcContAppSelect", requestMap);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> purcContInspAppSelect(HashMap<String, Object> requestMap) throws Exception {
		return (Map<String, Object>)select("PurcContDAO.purcContInspAppSelect", requestMap);
	}
	
	public void updateInspDocId(Map<String, Object> bodyMap) throws Exception {
		update("PurcContDAO.updateInspDocId", bodyMap);
	}
	
	public void updateInspDocSts(Map<String, Object> bodyMap) throws Exception {
		update("PurcContDAO.updateInspDocSts", bodyMap);
	}

	public int checkPurcInspComplete(Map<String, Object> bodyMap) throws Exception {
		return (int)select("PurcContDAO.checkPurcInspComplete", bodyMap);
	}

	public String selectPurcReqContId(Map<String, Object> bodyMap) throws Exception {
		return String.valueOf(select("PurcContDAO.selectPurcReqContId", bodyMap));
	}

	public void updateDocDate(Map<String, Object> bodyMap) throws Exception {
		update("PurcContDAO.updateDocDate", bodyMap);
	}

	public void updatePayDocId(Map<String, Object> bodyMap) throws Exception {
		update("PurcContDAO.updatePayDocId", bodyMap);
	}

	public void updatePayDocSts(Map<String, Object> bodyMap) throws Exception {
		update("PurcContDAO.updatePayDocSts", bodyMap);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> purcContPayAppSelect(HashMap<String, Object> requestMap) throws Exception {
		return (Map<String, Object>)select("PurcContDAO.purcContPayAppSelect", requestMap);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getAbdocuInfo(String approKey) throws Exception {
		return (Map<String, Object>)select("PurcContDAO.getAbdocuInfo", approKey);
	}

	public String getPurcContId_contPay(String approKey) throws Exception {
		return (String)select("PurcContDAO.getPurcContId_contPay", approKey);
	}

	public int checkPurcContPayComplete(String purcContId) throws Exception {
		return (int)select("PurcContDAO.checkPurcContPayComplete", purcContId);
	}
	
	private String getErpType() {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("group_code", "ERP_TYPE");
		List<Map<String, Object>> erpType = codeDAO.getCommCodeList(paramMap);
		if(erpType != null && erpType.size() > 0){		// G20 품의서 2.0
			return (String)erpType.get(0).get("code");
		}else{
			return null;
		}
	}

}
