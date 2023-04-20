package com.duzon.custom.resalphag20.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.duzon.custom.resalphag20.vo.PdfEcmFileVO;
import com.duzon.custom.resalphag20.vo.PdfEcmMainVO;

public interface ResAlphaG20Service {

	Object getFormInfo(Map<String, Object> paramMap);

	String getIframeUrl(Map<String, Object> paramMap);

	Object getCustIframeHeight(Map<String, Object> paramMap);

	Object getInterfaceIds(Map<String, Object> paramMap);

	List<Map<String, Object>> getOnnaraDocs(Map<String, Object> paramMap);
	
	Map<String, Object> getOnnaraDocFile(Map<String, Object> paramMap);
	
	List<Map<String, Object>> getOnnaraDocAllFiles(Map<String, Object> paramMap);
	
	public void fileDown(Map<String, Object> map, HttpServletRequest request, HttpServletResponse response);
	
	public void downloadFile(Map<String, Object> map, HttpServletRequest request, HttpServletResponse response);
	
	public String makeZipFile(List<Map<String, Object>> list, HttpServletRequest request, HttpServletResponse response);
	
	void saveOnnaraMapping(List<Map<String, Object>> list);
	
	List<Map<String, Object>> getDocMappingOnnaraDocId(Map<String, Object> paramMap);
	
	Map<String, Object> getOnnaraDocInfo(Map<String, Object> paramMap);
	
	void saveToAttachInfo(List<Map<String, Object>> list, Map<String, Object> map);
	
	List<Map<String, Object>> getFileList(Map<String, Object> paramMap);
	
	List<Map<String, Object>> getOnnaraMovedFile(Map<String, Object> paramMap);
	
	Map<String, Object> getRiOrgCode(Map<String, Object> paramMap);
	
	void updateOnnaraUsedStatus(Map<String, Object> paramMap);
	
	void saveUseOnnaraDocs(Map<String, Object> paramMap);
	
	List<Map<String, Object>> getAttachInfo(Map<String, Object> paramMap);
	
	List<Map<String, Object>> getAttachInfo2(Map<String, Object> paramMap);

	void saveTradeBojo(HashMap<String, Object> requestMap);

	List<Map<String, Object>> getTradeBojo(List<Map<String, Object>> param);

	void updateTradeBojo(HashMap<String, Object> requestMap);

	Object getResTrade(HashMap<String, Object> requestMap);
	
	void savePdfEcmMain(PdfEcmMainVO vo);
	
	void updatePdfStatus(PdfEcmMainVO vo);
	
	void savePdfEcmFile(PdfEcmFileVO vo);
	
	Map<String, Object> getDocOrg(Map<String, Object> paramMap);
	
	Map<String, Object> userCardDetailInfo(Map<String, Object> paramMap);
	
	Map<String, Object> selectETaxDetailInfo(Map<String, Object> paramMap);
	
	Map<String, Object> getCardInfoG20(Map<String, Object> paramMap);
	
	List<Map<String, Object>> getAllTradeInfo(Map<String, Object> param);
	
	Map<String, Object> getIssNo(Map<String, Object> paramMap);
	
	Map<String, Object> getEtaxSyncId(Map<String, Object> paramMap);
	
	Map<String, Object> getBranchTradeInfo(Map<String, Object> paramMap);

	void saveWorkFee(HashMap<String, Object> params);

	Object getWorkFee(Map<String, Object> paramMap);
	
	void saveDailyExp(Map<String, Object> param);
	
	Object getDailyExp(Map<String, Object> paramMap);
	
	List<Map<String, Object>> getErpEmpSeqInDept(Map<String, Object> param);

	List<Map<String, Object>> getUnRegisteredSaupList(Map<String, Object> paramMap);
	
	List<Map<String, Object>> selectCardSeunginList(Map<String, Object> paramMap);
	
	void updateCardAqTmp(Map<String, Object> paramMap) throws Exception;
	
	void updateEtaxAqTmp(Map<String, Object> paramMap) throws Exception;
	
	void updateRestradeTbl(Map<String, Object> params) throws Exception;
	
	int checkUnRegister(Map<String, Object> params) throws Exception;

	List<Map<String, Object>> selectPdfErrorDocs(Map<String, Object> paramMap);
	
	List<Map<String, Object>> selectAdocuListByFillDt(Map<String, Object> paramMap);
	
	Map<String, Object> selectAdocuAndDailyDocs(Map<String, Object> paramMap);

	List<Map<String, Object>> selectCardFullList(Map<String, Object> paramMap);
	
	int selectCardFullListTotal(Map<String, Object> paramMap);
	
	void saveReturnCardLog(Map<String, Object> params);
	
	void saveSelfPayCard(Map<String, Object> params);
	
	void updateSelfPayCard(Map<String, Object> params);
	
	void saveAdjustPayCard(Map<String, Object> params);
	
	void updateAdjustPayCard(Map<String, Object> params);
	
	Map<String, Object> selectReturnCardLogInfo(Map<String, Object> paramMap);

	void saveCardNotionInfo(Map<String, Object> paramMap);

	void deleteCardNotionInfo(Map<String, Object> paramMap);

	List<Map<String, Object>> selectCardNotionInfoList(Map<String, Object> paramMap);
	
	List<Map<String, Object>> selectCardInfoList(Map<String, Object> paramMap);

	Map<String, Object> selectCardNotionCycle(Map<String, Object> paramMap);

	void saveCardNotionCycle(Map<String, Object> paramMap);

	void updateCardNotionCycle(Map<String, Object> paramMap);
	
	Map<String, Object> selectReturnEtaxLogInfo(Map<String, Object> paramMap);
	
	Map<String, Object> checkFinalPDF(Map<String, Object> paramMap);
	
	void saveReturnEtaxLog(Map<String, Object> params);

	List<Map<String, Object>> getMoniteringEtaxList(Map<String, Object> paramMap);

	void saveResalphaAttach(Map<String, Object> paramMap);

	void deleteResalphaAttach(Map<String, Object> paramMap);

	List<Map<String, Object>> selectResalphaAttachList(Map<String, Object> paramMap);

	Map<String, Object> insertAttachFile(Map<String, Object> map, MultipartHttpServletRequest multi) throws Exception;

	List<Map<String, Object>> getAdocuTradeList(Map<String, Object> paramMap);

	void saveInfoAboutSms(Map<String, Object> paramMap);
	
	List<Map<String, Object>> notionNotSettleCard();
	
	List<Map<String, Object>> selectCardAlamBatchLog(Map<String, Object> paramMap);
	
	void saveCardAlamBatch(Map<String, Object> paramMap);
	
	String getAdocuTradeListCnt(Map<String, Object> paramMap);
	
	String getAdocuTradeInfoTotal(Map<String, Object> paramMap);
	
	void sendCardAlamBatch();
	
	void saveSmsMessage(Map<String, Object> paramMap);
	
	void saveSmsLog(Map<String, Object> paramMap);
	
	void updateSmsMessage(Map<String, Object> paramMap);
	
	String selectSmsMessage(Map<String, Object> paramMap);
	
	void deleteAdocuTmp(Map<String, Object> paramMap);

    void saveReturnCardHist(Map<String, Object> cardReturnInfo);

    Map<String, Object> cardHistRollback(Map<String, Object> paramMap);

    void updateCardAqTmpRollback(Map<String, Object> paramMap);

    void updateRestradeTblRollback(Map<String, Object> paramMap);

    void saveReturnEtaxHist(Map<String, Object> etaxReturnInfo);

    Map<String, Object> etaxHistRollback(Map<String, Object> paramMap);

    void updateEtaxAqTmpRollback(Map<String, Object> etaxHist);
}
