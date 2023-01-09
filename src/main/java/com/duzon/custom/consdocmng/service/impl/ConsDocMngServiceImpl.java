package com.duzon.custom.consdocmng.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.duzon.custom.consdocmng.dao.ConsDocMngDAO;
import com.duzon.custom.consdocmng.service.ConsDocMngService;

import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;

@Service("ConsDocMngService")
public class ConsDocMngServiceImpl implements ConsDocMngService {
	
	@Autowired
	private ConsDocMngDAO consDocMngDAO;

	@Override
	public Object selectConsDocMngList(Map<String, Object> params) throws Exception {
		return consDocMngDAO.selectConsDocMngList(params);
	}

	@Override
	public Object selectConsDocMngListTotalCount(Map<String, Object> params) throws Exception {
		return consDocMngDAO.selectConsDocMngListTotalCount(params);
	}

	@Override
	public Object selectConsDocMngDList(Map<String, Object> params) throws Exception {
		return consDocMngDAO.selectConsDocMngDList(params);
	}

	@Override
	public Object checkConsBudgetModify(Map<String, Object> params) throws Exception {
		return consDocMngDAO.checkConsBudgetModify(params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Object consDocModify(Map<String, Object> params) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String result = "Failed";
		List<Map<String, Object>> modBudgetList = (List<Map<String, Object>>)params.get("modBudgetList");
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("empSeq", loginVO.getUniqId());
		params.put("empName", loginVO.getName());
		consDocMngDAO.consModInsert(params);
		Map<String, Map<String, Object>> mgtSeqMap = new HashMap<String, Map<String, Object>>();
		for (Map<String, Object> modBudget : modBudgetList) {
			modBudget.put("empSeq", loginVO.getUniqId());
			modBudget.put("empName", loginVO.getName());
			modBudget.put("consModSeq", params.get("consModSeq"));
			String modMgtSeq = String.valueOf(modBudget.get("modMgtSeq"));
			if(mgtSeqMap.get(modMgtSeq) == null) {
				consDocMngDAO.consModHInsert(modBudget);
				mgtSeqMap.put((String)modBudget.get("modMgtSeq"), modBudget);
			}else {
				Map<String, Object> tempMap = mgtSeqMap.get(modMgtSeq);
				modBudget.put("modConsSeq", tempMap.get("modConsSeq"));
				modBudget.put("consModHSeq", tempMap.get("consModHSeq"));
			}
			consDocMngDAO.consModBInsert(modBudget);
			List<Map<String, Object>> modTradeList = (List<Map<String, Object>>)modBudget.get("modTradeList");
			if(modTradeList != null) {
				for (Map<String, Object> modTrade : modTradeList) {
					modTrade.put("consModBSeq", modBudget.get("consModBSeq"));
					consDocMngDAO.consModTInsert(modTrade);
				}
			}
		}
		if("Y".equals(params.get("active"))) {
			consDocModifyEnd(params);
		}
		result = "Success";
		resultMap.put("result", result);
		resultMap.put("consModSeq", params.get("consModSeq"));
		return resultMap;
	}
	
	@Override
	public void consDocModifyEnd(Map<String, Object> params) throws Exception{
		List<Map<String, Object>> consModifyEndBReturnList = consDocMngDAO.consModifyEndBReturnListSelect(params);
		for (Map<String, Object> consModifyEndBReturn : consModifyEndBReturnList) {
			consModifyEndBReturn.put("empSeq", params.get("empSeq"));
			consModifyEndBReturn.put("empName", params.get("empName"));
			consDocMngDAO.consBudgetReturn(consModifyEndBReturn);
			consDocMngDAO.consBudgetReturnAmtInsert(consModifyEndBReturn);
		}
		List<Map<String, Object>> consModifyEndHList = consDocMngDAO.consModifyEndHListSelect(params);
		Map<String, Object> purcContB = new HashMap<String, Object>();
		for (Map<String, Object> consModifyEndH : consModifyEndHList) {
			consDocMngDAO.consHeadInsert(consModifyEndH);
			consDocMngDAO.consModHUpdateSeq(consModifyEndH);
			List<Map<String, Object>> consModifyEndBList = consDocMngDAO.consModifyEndBListSelect(consModifyEndH);
			for (Map<String, Object> consModifyEndB : consModifyEndBList) {
				consModifyEndB.put("consSeq", consModifyEndH.get("consSeq"));
				consModifyEndB.put("empSeq", params.get("empSeq"));
				consModifyEndB.put("empName", params.get("empName"));
				consDocMngDAO.consBudgetInsert(consModifyEndB);
				consDocMngDAO.consModBUpdateSeq(consModifyEndB);
				
				String purcContId = null;
				if(params.get("purcContId") != null && !"".equals(params.get("purcContId"))) {
					purcContId = String.valueOf(params.get("purcContId"));
					consModifyEndB.put("purcContId", purcContId);
					Map<String, Object> purcContBTemp = consDocMngDAO.purcContBIdSelect(consModifyEndB);
					if(purcContBTemp != null) {
						consDocMngDAO.purcContBDelete(purcContBTemp);
						purcContB.put("purcReqId", purcContBTemp.get("purcReqId"));
						purcContB.put("purcReqHId", purcContBTemp.get("purcReqHId"));
						purcContB.put("purcReqBId", purcContBTemp.get("purcReqBId"));
						purcContB.put("openAm", purcContBTemp.get("openAm"));
					}
					consModifyEndB.put("purcReqId", purcContB.get("purcReqId"));
					consModifyEndB.put("purcReqHId", purcContB.get("purcReqHId"));
					consModifyEndB.put("purcReqBId", purcContB.get("purcReqBId"));
					consModifyEndB.put("openAm", purcContB.get("openAm"));
					consModifyEndB.put("empIp", params.get("empIp"));
					consDocMngDAO.purcContBInsert(consModifyEndB);
//					consDocMngDAO.purcContBUpdate(consModifyEndB);
					consDocMngDAO.purcContTDelete(consModifyEndB);
				}
				
				List<Map<String, Object>> consModifyEndTList = consDocMngDAO.consModifyEndTListSelect(consModifyEndB);
				for (Map<String, Object> consModifyEndT : consModifyEndTList) {
					consModifyEndT.put("consSeq", consModifyEndH.get("consSeq"));
					consModifyEndT.put("budgetSeq", consModifyEndB.get("budgetSeq"));
					consModifyEndT.put("empSeq", params.get("empSeq"));
					consModifyEndT.put("empName", params.get("empName"));
					consDocMngDAO.consTradeInsert(consModifyEndT);
					consDocMngDAO.consModTUpdateSeq(consModifyEndT);
					
					if(purcContId != null && !"".equals(purcContId)) {
						consModifyEndT.put("purcContId", purcContId);
						consModifyEndT.put("purcContBId", consModifyEndB.get("purcContBId"));
						consModifyEndT.put("purcReqId", consModifyEndB.get("purcReqId"));
						consModifyEndT.put("purcReqHId", consModifyEndB.get("purcReqHId"));
						consModifyEndT.put("purcReqBId", consModifyEndB.get("purcReqBId"));
						consDocMngDAO.purcContTInsert(consModifyEndT);
					}
				}
			}
		}
		consDocMngDAO.consDocModifyEnd(params);
	}

	@Override
	public Object getTreadList(Map<String, Object> params) throws Exception {
		return consDocMngDAO.getTreadList(params);
	}

	@Override
	public Object checkContract(Map<String, Object> params) throws Exception {
		return consDocMngDAO.checkContract(params);
	}
}
