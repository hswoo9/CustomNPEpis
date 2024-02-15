package com.duzon.custom.resalphag20.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.duzon.custom.common.dao.AbstractDAO;
import com.duzon.custom.resalphag20.vo.PdfEcmFileVO;
import com.duzon.custom.resalphag20.vo.PdfEcmMainVO;

@Repository("ResAlphaG20DAO")
public class ResAlphaG20DAO extends AbstractDAO{

	public Object getFormInfo(Map<String, Object> paramMap) {
		return selectOne("resalphag20.getFormInfo", paramMap);
	}

	public String getIframeUrl(Map<String, Object> paramMap) {
		return String.valueOf(selectOne("resalphag20.getIframeUrl", paramMap));
	}

	public Object getCustIframeHeight(Map<String, Object> paramMap) {
		return selectOne("resalphag20.getCustIframeHeight", paramMap);
	}

	public Object getInterfaceIds(Map<String, Object> paramMap) {
		return selectList("resalphag20.getInterfaceIds",paramMap);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getOnnaraDocs(Map<String, Object> paramMap) {
		return selectListOr("resalphag20_Ora.getOnnaraDocs", paramMap);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> getOnnaraFile(Map<String, Object> paramMap) {
		return (Map<String, Object>) selectOneOr("resalphag20_Ora.getOnnaraFile", paramMap);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getOnnaraDocAllFiles(Map<String, Object> paramMap) {
		return selectListOr("resalphag20_Ora.getOnnaraDocAllFiles", paramMap);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> getOnnaraServerInfo() {
		return (Map<String, Object>) selectOne("resalphag20.getOnnaraServerInfo");
	}
	
	public Map<String, Object> checkAttachFile(Map<String, Object> paramMap) {
		return (Map<String, Object>) selectOne("resalphag20.checkAttachFile",paramMap);
	}
	
	public Map<String, Object> downloadFileInfo(Map<String, Object> paramMap) {
		return (Map<String, Object>) selectOne("resalphag20.downloadFileInfo",paramMap);
	}
	
	public void saveFileInfo(Map<String, Object> paramMap) {
		insert("resalphag20.saveFileInfo",paramMap);
	}
	
	public void saveOnnaraMapping(Map<String, Object> paramMap) {
		insert("resalphag20.saveOnnaraMapping",paramMap);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getDocMappingOnnaraDocId(Map<String, Object> paramMap) {
		return selectList("resalphag20.getDocMappingOnnaraDocId", paramMap);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> getOnnaraDocInfo(Map<String, Object> paramMap) {
		return (Map<String, Object>) selectOneOr("resalphag20_Ora.getOnnaraDocInfo", paramMap);
	}
	
	public void saveToAttachInfo(Map<String, Object> paramMap) {
		insert("resalphag20.saveToAttachInfo",paramMap);
	}
	
	public void saveToAttachFile(Map<String, Object> paramMap) {
		insert("resalphag20.saveToAttachFile",paramMap);
	}
	
	public void saveToAttachFileDetail(Map<String, Object> paramMap) {
		insert("resalphag20.saveToAttachFileDetail",paramMap);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getFileList(Map<String, Object> paramMap) {
		return selectList("resalphag20.getFileList", paramMap);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> getRiOrgCode(Map<String, Object> paramMap) {
		return (Map<String, Object>) selectOne("resalphag20.getRiOrgCode", paramMap);
	}
	
	public int checkDupliOnnaraFileId(Map<String, Object> paramMap) {
		return (int) selectOne("resalphag20.checkDupliOnnaraFileId", paramMap);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getOnnaraMovedFile(Map<String, Object> param) {
		return selectList("resalphag20.getOnnaraMovedFile", param);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getAttachInfo(Map<String, Object> param) {
		return selectList("resalphag20.getAttachInfo", param);
	}
	
	public void updateOnnaraUsedStatus(Map<String, Object> param) {
		update("resalphag20.updateOnnaraUsedStatus", param);
	}
	
	public void saveUseOnnaraDocs(Map<String, Object> paramMap) {
		insert("resalphag20.saveUseOnnaraDocs", paramMap);
	}
	
	@SuppressWarnings("unchecked")
	public int checkUsedOnnaraDoc(Map<String, Object> paramMap) {
		return (int) selectOne("resalphag20.checkUsedOnnaraDoc", paramMap);
	}

	public void saveTradeBojo(HashMap<String, Object> requestMap) {
		insert("resalphag20.saveTradeBojo", requestMap);
	}

	public Map<String, Object> getTradeBojo(Map<String, Object> map) {
		return (Map<String, Object>) selectOne("resalphag20.getTradeBojo", map);
	}

	public void updateTradeBojo(HashMap<String, Object> requestMap) {
		update("resalphag20.updateTradeBojo", requestMap);
	}

	public Object getResTrade(HashMap<String, Object> requestMap) {
		return selectOne("resalphag20.getResTrade", requestMap);
	}
	
	public void savePdfEcmMain(PdfEcmMainVO vo) {
		insert("resalphag20.savePdfEcmMain", vo);
	}
	
	public void savePdfEcmFile(PdfEcmFileVO vo) {
		insert("resalphag20.savePdfEcmFile", vo);
	}
	
	public void updatePdfStatus(PdfEcmMainVO vo) {
		update("resalphag20.updatePdfStatus", vo);
	}
	
	public Map<String, Object> getDocOrg(Map<String, Object> map) {
		return (Map<String, Object>) selectOne("resalphag20.getDocOrg", map);
	}

	public Map<String, Object> getNewDocOrg(Map<String, Object> map) {
		return (Map<String, Object>) selectOne("resalphag20.getNewDocOrg", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getOrderedOnnnaraDocAttach(Map<String, Object> param) {
		return selectList("resalphag20.getOrderedOnnnaraDocAttach", param);
	}
	
	public Map<String, Object> userCardDetailInfo(Map<String, Object> map) {
		return (Map<String, Object>) selectOne("resalphag20.NPUserCardDetailInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getAllTradeInfo(Map<String, Object> param) {
		return selectList("resalphag20.getAllTradeInfo", param);
	}
	
	public Map<String, Object> userEtaxDetailInfo(Map<String, Object> map) {
		return (Map<String, Object>) selectOne("resalphag20.NPUserCardDetailInfo", map);
	}
	
	public Map<String, Object> getIssNo(Map<String, Object> map) {
		return (Map<String, Object>) selectOne("resalphag20.getIssNo", map);
	}
	
	public Map<String, Object> selectETaxDetailInfo(Map<String, Object> map) {
		return (Map<String, Object>) selectOneMs("resalphag20_Ms.selectETaxDetailInfo", map);
	}

	public String getTaxTy(Map<String, Object> resultMap) {
		return String.valueOf(selectOneMs("resalphag20_Ms.getTaxTy", resultMap));
	}

	public void saveWorkFee(HashMap<String, Object> params) {
		insert("resalphag20.saveWorkFee", params);
	}

	public Object getWorkFee(Map<String, Object> paramMap) {
		return selectOne("resalphag20.getWorkFee", paramMap);
	}
	public void saveDailyExp(Map<String, Object> params) {
		insert("resalphag20.saveDailyExp", params);
	}
	
	public Object getDailyExp(Map<String, Object> paramMap) {
		return selectOne("resalphag20.getDailyExp", paramMap);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getErpEmpSeqInDept(Map<String, Object> param) {
		return selectList("resalphag20.getErpEmpSeqInDept", param);
	}
	
	public Map<String, Object> getCardInfoG20(Map<String, Object> map) {
		return (Map<String, Object>) selectOneMs("resalphag20_Ms.getCardInfoG20", map);
	}

	public Map<String, Object> selectErpTradeInfo(Map<String, Object> map) {
		return (Map<String, Object>) selectOneMs("resalphag20_Ms.selectErpTradeInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public void updateCardAqTmp(Map<String, Object> param) {
		update("resalphag20.updateCardAqTmp", param);
	}
	
	@SuppressWarnings("unchecked")
	public void updateEtaxAqTmp(Map<String, Object> param) {
		update("resalphag20.updateEtaxAqTmp", param);
	}
	
	@SuppressWarnings("unchecked")
	public void updateRestradeTbl(Map<String, Object> param) {
		update("resalphag20.updateRestradeTbl", param);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectTradeAddrInfo(Map<String, Object> param) {
		return (Map<String, Object>) selectOneMs2("resalphag20_Ms.selectTradeAddrInfo", param);
	}

	public List<Map<String, Object>> selectTradeAddrInfo2(Map<String, Object> param) {
		return selectListMs2("resalphag20_Ms.selectTradeAddrInfo2", param);
	}
	
	public List<Map<String, Object>> getUnRegisteredSaupList(Map<String, Object> paramMap) {
		return selectListMs2("resalphag20_Ms.selectCardSeunginTrList", paramMap);
	}
	
	public List<Map<String, Object>> selectCardSeunginList(Map<String, Object> paramMap) {
		return selectListMs2("resalphag20_Ms.selectCardSeunginList", paramMap);
	}
	
	public String checkUnRegister(Map<String, Object> paramMap) {
		return String.valueOf(selectOneMs("resalphag20_Ms.checkUnRegister", paramMap));
	}
	
	public Map<String, Object> getEtaxSyncId(Map<String, Object> map) {
		return (Map<String, Object>) selectOne("resalphag20.getEtaxSyncId", map);
	}

	public List<Map<String, Object>> selectPdfErrorDocs(Map<String, Object> paramMap) {
		return selectList("resalphag20.selectPdfErrorDocs", paramMap);
	}
	
	public List<Map<String, Object>> selectAdocuListByFillDt(Map<String, Object> paramMap) {
		return selectListMs("resalphag20_Ms.selectAdocuListByFillDt", paramMap);
	}
	
	public Map<String, Object> selectAdocuAndDailyDocs(Map<String, Object> paramMap) {
		return (Map<String, Object>) selectOne("resalphag20.selectAdocuAndDailyDocs", paramMap);
	}

	public List<Map<String, Object>> selectCardFullList(Map<String, Object> paramMap) {
		return selectList("resalphag20.GetCardListFullList", paramMap);
	}
	
	public int selectCardFullListTotal(Map<String, Object> paramMap) {
		return  (int) selectOne("resalphag20.selectCardFullListTotal", paramMap);
	}
	
	public List<Map<String, Object>> selectReturnCardLog(Map<String, Object> paramMap) {
		return selectList("resalphag20.selectReturnCardLog", paramMap);
	}
	
	public void saveReturnCardLog(Map<String, Object> paramMap) {
		insert("resalphag20.saveReturnCardLog",paramMap);
	}
	
	public void saveSelfPayCard(Map<String, Object> paramMap) {
		insert("resalphag20.saveSelfPayCard",paramMap);
	}
	
	public void updateSelfPayCard(Map<String, Object> param) {
		update("resalphag20.updateSelfPayCard", param);
	}
	
	public void saveAdjustPayCard(Map<String, Object> paramMap) {
		insert("resalphag20.saveAdjustPayCard",paramMap);
	}
	
	public void updateAdjustPayCard(Map<String, Object> param) {
		update("resalphag20.updateAdjustPayCard", param);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectReturnCardLogInfo(Map<String, Object> param) {
		return (Map<String, Object>) selectOne("resalphag20.selectReturnCardLogInfo", param);
	}

	public void saveCardNotionInfo(Map<String, Object> paramMap) {
		insert("resalphag20.saveCardNotionInfo",paramMap);		
	}

	public void deleteCardNotionInfo(Map<String, Object> paramMap) {
		delete("resalphag20.deleteCardNotionInfo", paramMap);		
	}

	public List<Map<String, Object>> selectCardNotionInfoList(Map<String, Object> paramMap) {
		return selectList("resalphag20.selectCardNotionInfoList", paramMap);
	}

	public Map<String, Object> selectCardNotionCycle(Map<String, Object> paramMap) {
		return (Map<String, Object>) selectOne("resalphag20.selectCardNotionCycle", paramMap);
	}

	public void saveCardNotionCycle(Map<String, Object> paramMap) {
		insert("resalphag20.saveCardNotionCycle",paramMap);		
	}

	public void updateCardNotionCycle(Map<String, Object> paramMap) {
		update("resalphag20.updateCardNotionCycle", paramMap);		
	}
	
	public List<Map<String, Object>> selectCardInfoList(Map<String, Object> paramMap) {
		return selectList("resalphag20.selectCardInfoList", paramMap);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectReturnEtaxLogInfo(Map<String, Object> param) {
		return (Map<String, Object>) selectOne("resalphag20.selectReturnEtaxLogInfo", param);
	}
	
	public void saveReturnEtaxLog(Map<String, Object> paramMap) {
		insert("resalphag20.saveReturnEtaxLog",paramMap);
	}
	
	public List<Map<String, Object>> selectReturnEtaxLog(Map<String, Object> paramMap) {
		return selectList("resalphag20.selectReturnEtaxLog", paramMap);
	}
	
	public Map<String, Object> selectMoniteringDetails(Map<String, Object> paramMap) {
		return (Map<String, Object>) selectOne("resalphag20.selectMoniteringDetails", paramMap);
	}

	public List<Map<String, Object>> getMoniteringEtaxList(Map<String, Object> paramMap) {
		return selectListMs("resalphag20_Ms.getMoniteringEtaxList", paramMap);
	}
	
	public void saveResalphaAttach(Map<String, Object> paramMap) {
		insert("resalphag20.saveResalphaAttach",paramMap);		
	}
	
	public List<Map<String, Object>> selectResalphaAttachList(Map<String, Object> paramMap) {
		return selectList("resalphag20.selectResalphaAttachList", paramMap);
	}	
	
	public void deleteResalphaAttach(Map<String, Object> paramMap) {
		delete("resalphag20.deleteResalphaAttach", paramMap);		
	}

	public String getCommFileSeq(Map<String, Object> map) {
		return (String) selectOne("resalphag20.getCommFileSeq", map);
	}

	public List<Map<String, Object>> getAttachInfo2(Map<String, Object> paramMap) {
		return selectList("resalphag20.getAttachInfo2", paramMap);
	}

	public Map<String, Object> checkFinalPDF(Map<String, Object> paramMap) {
		return (Map<String, Object>) selectOne("resalphag20.checkFinalPDF", paramMap);
	}

	public List<Map<String, Object>> getAdocuTradeList(Map<String, Object> paramMap) {
		return selectListMs("resalphag20_Ms.getAdocuTradeList", paramMap);
	}
	
	public String getAdocuTradeListCnt(Map<String, Object> paramMap) {
		return (String) selectOneMs("resalphag20_Ms.getAdocuTradeListCnt", paramMap);
	}
	
	public List<Map<String, Object>> getAdocuTradeInfo(Map<String, Object> map) {
		return selectList("resalphag20.getAdocuTradeInfo", map);
	}
	
	public String getAdocuTradeInfoTotal(Map<String, Object> map) {
		return (String) selectOne("resalphag20.getAdocuTradeInfoTotal", map);
	}

	public void saveInfoAboutSms(Map<String, Object> paramMap) {
		insert("resalphag20.saveInfoAboutSms",paramMap);
	}
	
	public List<Map<String, Object>> selectCardAlamBatchLog(Map<String, Object> paramMap) {
		return selectList("resalphag20.selectCardAlamBatchLog", paramMap);
	}
	
	public void saveCardAlamBatch(Map<String, Object> paramMap) {
		insert("resalphag20.saveCardAlamBatch",paramMap);		
	}
	
	public void saveSmsMessage(Map<String, Object> paramMap) {
		insert("resalphag20.saveSmsMessage",paramMap);		
	}
	
	public void updateSmsMessage(Map<String, Object> paramMap) {
		insert("resalphag20.updateSmsMessage",paramMap);		
	}
	
	public void saveSmsLog(Map<String, Object> paramMap) {
		insert("resalphag20.saveSmsLog",paramMap);		
	}
	
	public void saveAdocuTmp(Map<String, Object> paramMap) {
		insert("resalphag20.saveAdocuTmp",paramMap);		
	}
	
	public String selectSmsMessage(Map<String, Object> map) {
		return (String) selectOne("resalphag20.selectSmsMessage", map);
	}
	
	public void deleteAdocuTmp(Map<String, Object> paramMap) {
		delete("resalphag20.deleteAdocuTmp", paramMap);		
	}

    public void saveReturnCardHist(Map<String, Object> params) {
        insert("resalphag20.saveReturnCardHist", params);

    }

    public Map<String, Object> cardHistRollback(Map<String, Object> paramMap) {
        return (Map<String, Object>) selectOne("resalphag20.cardHistRollback", paramMap);
    }

    public void updateCardAqTmpRollback(Map<String, Object> paramMap) {
        update("resalphag20.updateCardAqTmpRollback", paramMap);
    }

    public void updateRestradeTblRollback(Map<String, Object> paramMap) {
        update("resalphag20.updateRestradeTblRollback", paramMap);
    }

    public void saveReturnEtaxHist(Map<String, Object> etaxReturnInfo) {
        insert("resalphag20.saveReturnEtaxHist", etaxReturnInfo);
    }

    public Map<String, Object> etaxHistRollback(Map<String, Object> paramMap) {
        return (Map<String, Object>) selectOne("resalphag20.etaxHistRollback", paramMap);
    }

    public void updateEtaxAqTmpRollback(Map<String, Object> etaxHist) {
        update("resalphag20.updateEtaxAqTmpRollback", etaxHist);
    }
}
