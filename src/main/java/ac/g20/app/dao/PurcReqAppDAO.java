package ac.g20.app.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import ac.g20.ex.vo.Abdocu_H;
import egovframework.com.cmm.service.impl.EgovComAbstractDAO;

@Repository("PurcReqAppDAO")
public class PurcReqAppDAO extends EgovComAbstractDAO{

	@SuppressWarnings("unchecked")
	public List<Abdocu_H> getPurcReqHList(Map<String, Object> paramMap) throws Exception {
		return list("PurcReqDAO.getPurcReqHList", paramMap);
	}

	public void updateDocId(Map<String, Object> bodyMap) throws Exception {
		update("PurcReqDAO.updateDocId", bodyMap);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> purcReqAppSelect(HashMap<String, Object> requestMap) {
		return (Map<String, Object>)select("PurcReqDAO.purcReqAppSelect", requestMap);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getPurcReq(String approKey) throws Exception {
		return (Map<String, Object>)select("PurcReqDAO.getPurcReq", approKey);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getErpGwLinkList(String approKey) {
		return list("PurcReqDAO.getErpGwLinkList", approKey);
	}

	public void insertErpGwLink(Map<String, Object> erpGwLink) {
		insert("PurcReqDAO.insertErpGwLink", erpGwLink);
	}

	/* G20 2.0 Start */
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> getApprovalInfo(String docId) {
		Map<String, Object> result = new HashMap<String, Object>( );
		result = (Map<String, Object>)select("PurcReqDAO.getApprovalInfo", docId);		
		return result;
	}

	public void updateConsDocEaInfo(Map<String, Object> result) {
		update("PurcReqDAO.updateConsDocEaInfo", result);
	}

	public void updatePurcReqTrInfo(Map<String, Object> purcReq) {
		update("PurcReqDAO.updatePurcReqTrInfo", purcReq);
	}

	public void updateConsTrInfo(Map<String, Object> purcReq) {
		update("PurcReqDAO.updateConsTrInfo", purcReq);
	}
	
	/* G20 2.0 End */

}
