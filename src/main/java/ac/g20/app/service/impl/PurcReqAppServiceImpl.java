package ac.g20.app.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.duzon.custom.commcode.dao.CodeDAO;

import ac.g20.app.dao.PurcReqAppDAO;
import ac.g20.app.service.AcG20ExAppService;
import ac.g20.app.service.PurcReqAppService;
import ac.g20.ex.service.AcG20ExService;
import ac.g20.ex.vo.Abdocu_H;
import neos.cmm.db.CommonSqlDAO;

@Service("PurcReqAppService")
public class PurcReqAppServiceImpl implements PurcReqAppService {
	
	private org.apache.logging.log4j.Logger logger = LogManager.getLogger( PurcReqAppServiceImpl.class );
	
	@Resource(name = "AcG20ExAppService")
	private AcG20ExAppService	acG20ExAppService;
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	@Resource ( name = "PurcReqAppDAO" )
	private PurcReqAppDAO purcReqAppDAO;
	
	@Resource ( name = "AcG20ExService" )
	private AcG20ExService acG20ExService;
	
	@Autowired
	CodeDAO codeDAO;
	
	@Override
	public void updateDocState(Map<String, Object> bodyMap) throws Exception {
		String docSts = String.valueOf(bodyMap.get("docSts"));
		String approKey = String.valueOf(bodyMap.get("approKey"));
		String docId = String.valueOf(bodyMap.get("docId"));
		String processId = String.valueOf(bodyMap.get("processId"));
		String empSeq = String.valueOf(bodyMap.get("empSeq"));
		approKey = approKey.replace(processId, "");
		System.out.println(approKey);
		System.out.println(processId);
		bodyMap.put("approKey", approKey);
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("purcReqId", approKey);
		
		if("G20_2.0".equals(getErpType())){		// G20 품의서 2.0
			Map<String, Object> result = (Map<String, Object>)purcReqAppDAO.getApprovalInfo(docId);	// 결재문서정보
			if(result == null){
				result = new HashMap<String, Object>();
			}
			if("10".equals(docSts)) {
				result.put("docStatus", "001");
			}else if("20".equals(docSts)) {
				purcReqAppDAO.updateDocId(bodyMap);
				paramMap.put("reqState", "001");
				acG20ExService.updatePurcReqState(paramMap);
				
				result.put("docStatus", "002");
			}else if("90".equals(docSts)) {
				paramMap.put("reqState", "003");
				Map<String, Object> purcReq = purcReqAppDAO.getPurcReq(approKey);
				String contType = String.valueOf(purcReq.get("contTypeCodeId"));
				if("002".equals(contType)){
				}else if("003".equals(contType) || "004".equals(contType)){
					Map<String, String> map = new HashMap<String, String>();
					map.put("purcReqId", approKey);
					map.put("empSeq", "");
					map.put("empIp", "");
					map.put("smallYn", "Y");
					map.put("contStep", "004");
					map.put("contType", contType);
					acG20ExService.makeContInfo(map);
					acG20ExService.makeContInfoUpdate(map);
					paramMap.put("reqState", "007");
				}
				acG20ExService.updatePurcReqState(paramMap);
				
				result.put("docStatus", "008");
				purcReqAppDAO.updatePurcReqTrInfo(purcReq);
				purcReqAppDAO.updateConsTrInfo(purcReq);
			}else if("100".equals(docSts)) {
				paramMap.put("reqState", "002");
				acG20ExService.updatePurcReqState(paramMap);
				
				result.put("docStatus", "007");
			}else if("d".equals(docSts) || "999".equals(docSts)){
				result.put("docStatus", "d");
			}
			
			// 2.0 품의서 문서정보 업데이트
			result.put("docSeq", docId);
//			result.put("expendDate", docId);
			result.put("empSeq", empSeq);
			result.put("approKey", approKey);
			purcReqAppDAO.updateConsDocEaInfo(result);
			
			// 2.0 품의서 문서번호 업데이트
			if("90".equals(docSts)) {
				long startTime = System.currentTimeMillis();
				logger.info("========= startTime =======================================");
				logger.info(startTime);
				Thread t = new Thread(new PurcReqThread(docId, purcReqAppDAO, approKey));
				t.start();
				
				long endTime = System.currentTimeMillis();
				logger.info("========= endTime =======================================");
				logger.info(endTime);
				
				System.out.println("thread Aliveness : " + t.isAlive());
			}
		}else{
			if("20".equals(docSts)) {
				purcReqAppDAO.updateDocId(bodyMap);
				List<Abdocu_H> purcReqHList = purcReqAppDAO.getPurcReqHList(bodyMap);
				paramMap.put("reqState", "001");
				acG20ExService.updatePurcReqState(paramMap);
				for (Abdocu_H abdocuH : purcReqHList) {
					abdocuH.setC_dikeycode(docId);
					acG20ExAppService.completeApproval(abdocuH);
				}
			}else if("90".equals(docSts)) {
				paramMap.put("reqState", "003");
				Map<String, Object> purcReq = purcReqAppDAO.getPurcReq(approKey);
				String contType = String.valueOf(purcReq.get("contTypeCodeId"));
				if("002".equals(contType)){
//				Map<String, String> map = new HashMap<String, String>();
//				map.put("purcReqId", approKey);
//				map.put("empSeq", "");
//				map.put("empIp", "");
//				map.put("smallYn", "N");
//				map.put("contStep", "003");
//				acG20ExService.makeContInfo(map);
//				acG20ExService.makeContInfoUpdate(map);
//				paramMap.put("reqState", "006");
				}else if("003".equals(contType) || "004".equals(contType)){
					Map<String, String> map = new HashMap<String, String>();
					map.put("purcReqId", approKey);
					map.put("empSeq", "");
					map.put("empIp", "");
					map.put("smallYn", "Y");
					map.put("contStep", "004");
					acG20ExService.makeContInfo(map);
					acG20ExService.makeContInfoUpdate(map);
					paramMap.put("reqState", "007");
				}
				acG20ExService.updatePurcReqState(paramMap);
			}else if("100".equals(docSts)) {
				paramMap.put("reqState", "002");
				acG20ExService.updatePurcReqState(paramMap);
			}
		}
	}

	@Override
	public Map<String, Object> purcReqAppSelect(HashMap<String, Object> requestMap) throws Exception {
		String approKey = String.valueOf(requestMap.get("approKey"));
		String processId = String.valueOf(requestMap.get("processId"));
		approKey = approKey.replace(processId, "");
		System.out.println(approKey);
		System.out.println(processId);
		requestMap.put("approKey", approKey);
		
		return purcReqAppDAO.purcReqAppSelect(requestMap);
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

	@Override
	public void purcReqBiddingApp(Map<String, Object> bodyMap) throws Exception {
		String docSts = String.valueOf(bodyMap.get("docSts"));
		String approKey = String.valueOf(bodyMap.get("approKey"));
		String docId = String.valueOf(bodyMap.get("docId"));
		String processId = String.valueOf(bodyMap.get("processId"));
		String empSeq = String.valueOf(bodyMap.get("empSeq"));
		bodyMap.put("purcReqId", approKey.split("_")[1]);
		Map<String, Object> purcReq = purcReqAppDAO.getPurcReq(approKey.split("_")[1]);
		String curReqState = String.valueOf(purcReq.get("reqState"));
		if("PURCBID1".equals(processId)) {
			if("10".equals(docSts)) {
				bodyMap.put("reqState", "111");
			}else if("20".equals(docSts)) {
				bodyMap.put("reqState", "111");
			}else if("90".equals(docSts)) {
				bodyMap.put("reqState", "119");
			}else if("100".equals(docSts)) {
				bodyMap.put("reqState", "100");
			}else if("d".equals(docSts) || "999".equals(docSts)) {
				if("111".equals(curReqState) || "119".equals(curReqState)) {
					bodyMap.put("reqState", "100");
				}
			}
		}else if ("PURCBID2".equals(processId)) {
			if("10".equals(docSts)) {
				bodyMap.put("reqState", "121");
			}else if("20".equals(docSts)) {
				bodyMap.put("reqState", "121");
			}else if("90".equals(docSts)) {
				bodyMap.put("reqState", "129");
				bodyMap.put("biddingType", "120");
			}else if("100".equals(docSts)) {
				bodyMap.put("reqState", "119");
			}else if("d".equals(docSts) || "999".equals(docSts)) {
				if("121".equals(curReqState) || "129".equals(curReqState)) {
					bodyMap.put("reqState", "119");
				}
			}
		}else if ("PURCBID3".equals(processId)) {
			if("10".equals(docSts)) {
				bodyMap.put("reqState", "131");
			}else if("20".equals(docSts)) {
				bodyMap.put("reqState", "131");
			}else if("90".equals(docSts)) {
				bodyMap.put("reqState", "139");
				bodyMap.put("biddingType", "130");
			}else if("100".equals(docSts)) {
				bodyMap.put("reqState", "130");
			}else if("d".equals(docSts) || "999".equals(docSts)) {
				if("131".equals(curReqState) || "139".equals(curReqState)) {
					bodyMap.put("reqState", "130");
				}
			}
		}else if ("PURCBID4".equals(processId)) {
			if("10".equals(docSts)) {
				bodyMap.put("reqState", "171");
			}else if("20".equals(docSts)) {
				bodyMap.put("reqState", "171");
			}else if("90".equals(docSts)) {
				bodyMap.put("reqState", "179");
			}else if("100".equals(docSts)) {
				bodyMap.put("reqState", "170");
			}else if("d".equals(docSts) || "999".equals(docSts)) {
				if("171".equals(curReqState) || "004".equals(curReqState)) {
					bodyMap.put("reqState", "170");
				}
			}
		}
		if(bodyMap.get("reqState") != null && !"".equals(bodyMap.get("reqState"))) {
			acG20ExService.updatePurcReqState(bodyMap);
		}
	}
}
