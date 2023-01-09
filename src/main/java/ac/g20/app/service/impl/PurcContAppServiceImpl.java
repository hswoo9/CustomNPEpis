package ac.g20.app.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.duzon.custom.commcode.dao.CodeDAO;

import ac.g20.app.dao.PurcContAppDAO;
import ac.g20.app.service.AcG20ExAppService;
import ac.g20.app.service.PurcContAppService;
import ac.g20.ex.service.AcG20ExService;
import ac.g20.ex.vo.Abdocu_H;
import neos.cmm.db.CommonSqlDAO;

@Service("PurcContAppService")
public class PurcContAppServiceImpl implements PurcContAppService {

	@Resource(name = "AcG20ExAppService")
	private AcG20ExAppService	acG20ExAppService;
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	@Resource ( name = "PurcContAppDAO" )
	private PurcContAppDAO purcContAppDAO;
	
	@Resource ( name = "AcG20ExService" )
	AcG20ExService acG20ExService;
	
	@Autowired
	CodeDAO codeDAO;
	
	@Override
	public void updateDocState(Map<String, Object> bodyMap) throws Exception {
		String docSts = String.valueOf(bodyMap.get("docSts"));
		String approKey = String.valueOf(bodyMap.get("approKey"));
		String processId = String.valueOf(bodyMap.get("processId"));
		approKey = approKey.replace(processId, "");
		System.out.println(approKey);
		System.out.println(processId);
		bodyMap.put("approKey", approKey);
		
		if("10".equals(docSts)) {
			
		}else if("20".equals(docSts)) {											// 상신
			bodyMap.put("docState", "001");
			purcContAppDAO.updateDocId(bodyMap);
			purcContAppDAO.updateDocSts(bodyMap);
		}else if("90".equals(docSts)) {									// 결재완료
			bodyMap.put("docState", "004");
			bodyMap.put("reqDocState", "007");
//			if("2".equals(purcContAppDAO.checkPurcReqType(bodyMap))){		// 종합쇼핑몰은 바로 계약체결
//				bodyMap.put("docState", "004");
//				bodyMap.put("reqDocState", "007");
//				purcContAppDAO.updateDocDate(bodyMap);
//			}
			purcContAppDAO.updateDocDate(bodyMap);
			purcContAppDAO.updateDocSts(bodyMap);
			// 예산수정
			if(purcContAppDAO.checkPurcContComplete(bodyMap) == 0) {
				purcContAppDAO.updateAbdocuT(bodyMap);
				purcContAppDAO.updateAbdocuB_ApplyAm(bodyMap);
				purcContAppDAO.updateReqDocSts(bodyMap); 	//요청서 상태병경
			}
		}else if("100".equals(docSts)) {								// 반려
			bodyMap.put("docState", "002");
			purcContAppDAO.updateDocSts(bodyMap);
		}else if("d".equals(docSts) || "999".equals(docSts)){
			
		}
	}
	
	@Override
	public Map<String, Object> purcContAppSelect(HashMap<String, Object> requestMap) throws Exception {
		String approKey = String.valueOf(requestMap.get("approKey"));
		String processId = String.valueOf(requestMap.get("processId"));
		approKey = approKey.replace(processId, "");
		System.out.println(approKey);
		System.out.println(processId);
		requestMap.put("approKey", approKey);
		
		return purcContAppDAO.purcContAppSelect(requestMap);
	}
	
	@Override
	public void updateInspDocState(Map<String, Object> bodyMap) throws Exception {
		String docSts = String.valueOf(bodyMap.get("docSts"));
		String approKey = String.valueOf(bodyMap.get("approKey"));
		String processId = String.valueOf(bodyMap.get("processId"));
		approKey = approKey.replace(processId, "");
		System.out.println(approKey);
		System.out.println(processId);
		bodyMap.put("approKey", approKey);
		if("20".equals(docSts)) {											// 상신
			bodyMap.put("docState", "001");
			purcContAppDAO.updateInspDocId(bodyMap);
			purcContAppDAO.updateInspDocSts(bodyMap);
			String purcReqContId = purcContAppDAO.selectPurcReqContId(bodyMap);
			bodyMap.put("approKey", purcReqContId);
			bodyMap.put("docState", "005");
			bodyMap.put("reqDocState", "008");
			purcContAppDAO.updateDocSts(bodyMap);
			purcContAppDAO.updateReqDocSts(bodyMap);
		}else if("90".equals(docSts)) {									// 결재완료
			bodyMap.put("docState", "003");
			purcContAppDAO.updateInspDocSts(bodyMap);
			String purcReqContId = purcContAppDAO.selectPurcReqContId(bodyMap);
			bodyMap.put("approKey", purcReqContId);
			if(!(purcContAppDAO.checkPurcInspComplete(bodyMap) > 0)) {
				bodyMap.put("docState", "006");
				bodyMap.put("reqDocState", "009");
				purcContAppDAO.updateDocSts(bodyMap);
				purcContAppDAO.updateReqDocSts(bodyMap);
			}
		}else if("100".equals(docSts)) {								// 반려
			bodyMap.put("docState", "002");
			purcContAppDAO.updateInspDocSts(bodyMap);
		}
	}
	
	@Override
	public Map<String, Object> purcContInspAppSelect(HashMap<String, Object> requestMap) throws Exception {
		String approKey = String.valueOf(requestMap.get("approKey"));
		String processId = String.valueOf(requestMap.get("processId"));
		approKey = approKey.replace(processId, "");
		System.out.println(approKey);
		System.out.println(processId);
		requestMap.put("approKey", approKey);
		
		return purcContAppDAO.purcContInspAppSelect(requestMap);
	}

	@Override
	public void updatePayDocState(Map<String, Object> bodyMap) throws Exception {
		String docSts = String.valueOf(bodyMap.get("docSts"));
		String approKey = String.valueOf(bodyMap.get("approKey"));
		String docId = String.valueOf(bodyMap.get("docId"));
		System.out.println(docSts);
		System.out.println(approKey);
		System.out.println(docId);
		bodyMap.put("approKey", approKey);
		
		Abdocu_H abdocuH = new Abdocu_H();
		abdocuH.setC_dikeycode(docId);
		abdocuH.setAbdocu_no(approKey) ;
		
		if("20".equals(docSts)) {											// 상신
			Map<String, Object> abdocuInfo = purcContAppDAO.getAbdocuInfo(approKey);
			String docu_mode = String.valueOf(abdocuInfo.get("docuMode"));
			String abdocu_no_reffer = String.valueOf(abdocuInfo.get("abdocuNoReffer"));
			String sessionid = String.valueOf(abdocuInfo.get("sessionid"));
			abdocuH.setDocu_mode(docu_mode) ;
			abdocuH.setAbdocu_no_reffer(abdocu_no_reffer) ;
			abdocuH.setSessionid(sessionid);
			
			acG20ExAppService.insertG20Data(abdocuH);
			
			bodyMap.put("docState", "001");
			purcContAppDAO.updatePayDocId(bodyMap);
			purcContAppDAO.updatePayDocSts(bodyMap);
		}else if("90".equals(docSts)) {									// 결재완료
			String docNum = (String)commonSql.select("PurcContDAO.selectDocNum", docId);
			abdocuH.setDocnumber(docNum);
			acG20ExAppService.approvalEnd(abdocuH);
			
			bodyMap.put("docState", "003");
			purcContAppDAO.updatePayDocSts(bodyMap);
			String purcContId = purcContAppDAO.getPurcContId_contPay(approKey);
			if(!(purcContAppDAO.checkPurcContPayComplete(purcContId) > 0)) {
				bodyMap.put("docState", "007");
				bodyMap.put("approKey", purcContId);
				purcContAppDAO.updateDocSts(bodyMap);
			}
		}else if("100".equals(docSts)) {								// 반려
			acG20ExAppService.approvalReturn(abdocuH);
			
			bodyMap.put("docState", "002");
			purcContAppDAO.updatePayDocSts(bodyMap);
		}
	}

	@Override
	public Map<String, Object> purcContPayAppSelect(HashMap<String, Object> requestMap) throws Exception {
		String approKey = String.valueOf(requestMap.get("approKey"));
		System.out.println(approKey);
		requestMap.put("approKey", approKey);
		
		return purcContAppDAO.purcContPayAppSelect(requestMap);
	}

	@Override
	public void updateModDocState(Map<String, Object> bodyMap) throws Exception {
		String docSts = String.valueOf(bodyMap.get("docSts"));
		String approKey = String.valueOf(bodyMap.get("approKey"));
		String docId = String.valueOf(bodyMap.get("docId"));
		System.out.println(docSts);
		System.out.println(approKey);
		System.out.println(docId);
		
		HashMap<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("purcReqId", approKey.split("_")[1]);
		paramMap.put("purcContId", approKey.split("_")[2]);
		paramMap.put("purcContIdOrg", approKey.split("_")[3]);
		if("20".equals(docSts)) {										// 상신
			
		}else if("90".equals(docSts)) {									// 결재완료
			acG20ExService.completePurcContMod(paramMap);
		}else if("100".equals(docSts)) {								// 반려
			
		}
	}
	
}
