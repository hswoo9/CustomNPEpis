package ac.g20.ex.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartHttpServletRequest;

import ac.cmm.vo.ConnectionVO;
import ac.g20.ex.dao.AcG20ExGwDAO;
import ac.g20.ex.vo.ACardVO;
import ac.g20.ex.vo.Abdocu_B;
import ac.g20.ex.vo.Abdocu_D;
import ac.g20.ex.vo.Abdocu_H;
import ac.g20.ex.vo.Abdocu_T;
import ac.g20.ex.vo.Abdocu_TD;
import ac.g20.ex.vo.Abdocu_TD2;
import ac.g20.ex.vo.Abdocu_TH;
import ac.g20.ex.vo.PayDataVO;
import ac.g20.ex.vo.proposalVO;

/**
 * @title AcG20ExService.java
 * @author doban7
 *
 * @date 2016. 9. 1. 
 */
public interface AcG20ExService {

	/** 
	 * chkErpBgtClose doban7 2016. 9. 5.
	 * @param conVo 
	 * @param paraMap
	 * @return
	 */
	HashMap<String, String> chkErpBgtClose(ConnectionVO conVo, Map<String, String> paraMap) throws Exception;

	/** 
	 * getErpGisuInfo doban7 2016. 9. 5.
	 * @param conVo
	 * @param paraMap
	 * @return
	 */
	HashMap<String, String> getErpGisuInfo(ConnectionVO conVo, Map<String, String> paraMap)throws Exception;

	/** 
	 * insertAbdocu_H doban7 2016. 9. 5.
	 * @param abdocu_H
	 * @return
	 */
	Map<String, Object> insertAbdocu_H(Abdocu_H abdocu_H) throws Exception;

	/** 
	 * updateAbdocu_H doban7 2016. 9. 5.
	 * @param abdocu_H
	 * @return
	 */
	Map<String, Object> updateAbdocu_H(Abdocu_H abdocu_H) throws Exception;

	/** 
	 * getAbdocuH doban7 2016. 9. 6.
	 * @param abdocu_H
	 * @return
	 */
	Abdocu_H getAbdocuH(Abdocu_H abdocu_H)throws Exception;

	/** 
	 * getAbdocuB doban7 2016. 9. 7.
	 * @param abdocu_H
	 * @return
	 */
	List<Abdocu_B> getAbdocuB_List(Abdocu_H abdocu_H)throws Exception;

	/** 
	 * getErpBudgetInfo doban7 2016. 9. 7.
	 * @param conVo
	 * @param paraMap
	 * @return
	 */
	HashMap<String, String> getBudgetInfo(ConnectionVO conVo, Map<String, String> paraMap)throws Exception;

	/** 
	 * insertAbdocu_B doban7 2016. 9. 7.
	 * @param abdocu_B
	 * @return
	 */
	Map<String, Object> insertAbdocu_B(Abdocu_B abdocu_B)throws Exception;

	/** 
	 * updateAbdocu_B doban7 2016. 9. 7.
	 * @param abdocu_B
	 * @return
	 */
	Map<String, Object> updateAbdocu_B(Abdocu_B abdocu_B)throws Exception;

	/** 
	 * setAbdocuT doban7 2016. 9. 7.
	 * @param abdocu_B
	 * @return
	 */
	List<Abdocu_T> getAbdocuT_List(Abdocu_B abdocu_B)throws Exception;

	/** 
	 * insertAbdocu_T doban7 2016. 9. 8.
	 * @param abdocu_T
	 * @return
	 */
	Map<String, Object> insertAbdocu_T(Abdocu_T abdocu_T) throws Exception;

	/** 
	 * updateAbdocu_T doban7 2016. 9. 8.
	 * @param abdocu_T
	 * @return
	 */
	Map<String, Object> updateAbdocu_T(Abdocu_T abdocu_T) throws Exception;
	/**
	 * 
	 * deleteAbdocu_H doban7 2016. 9. 7.
	 * @param abdocu_H
	 * @return
	 * @throws Exception
	 */
	Integer deleteAbdocu_H(Abdocu_H abdocu_H) throws Exception;
	
	/** 
	 * deleteAbdocu_B doban7 2016. 9. 7.
	 * @param abdocu_B
	 * @return
	 */
	Map<String, Object> deleteAbdocu_B(Abdocu_B abdocu_B) throws Exception;

	/**
	 * 
	 * deleteAbdocu_T doban7 2016. 9. 7.
	 * @param abdocu_T
	 * @return
	 * @throws Exception
	 */
	Map<String, Object> deleteAbdocu_T(Abdocu_T abdocu_T) throws Exception;

	/** 
	 * approvalValidation doban7 2016. 9. 19.
	 * @param conVo 
	 * @param abdocu_B
	 * @return
	 */
	Map<String, Object> approvalValidation(ConnectionVO conVo, Abdocu_B abdocu_B) throws Exception;

	/** 
	 * getTaxConifg doban7 2016. 9. 21.
	 * @param conVo
	 * @param param
	 * @return
	 */
	HashMap<String, String> getErpTaxConifg(ConnectionVO conVo, HashMap<String, String> param)throws Exception;

	/** 
	 * getBudgetInfo2 doban7 2016. 9. 26.
	 * @param abDocuParamMap
	 * @return
	 * @throws Exception 
	 */
	Map<String, String> getBudgetInfo2(HashMap<String, String> abDocuParamMap) throws Exception;

	/** 
	 * getBudgetInfo3 doban7 2016. 9. 26.
	 * @param abDocuParamMap
	 * @return
	 * @throws Exception 
	 */
	Map<String, Object> getBudgetInfo3(HashMap<String, String> abDocuParamMap) throws Exception;

	/** 
	 * getReferConfer doban7 2016. 9. 28.
	 * @param paraMap
	 * @return
	 */
	List<HashMap<String, String>> getReferConfer(HashMap<String, String> paraMap)throws Exception;

	/** 
	 * insertReferConfer doban7 2016. 9. 29.
	 * @param abdocu_H
	 * @return
	 */
	Map<String, Object> insertReferConfer(Abdocu_H abdocu_H)throws Exception;

	/** 
	 * getConferBalance doban7 2016. 9. 29.
	 * @param abdocu_b
	 * @return
	 */
	String getConferBalance(Abdocu_B abdocu_b)throws Exception;

	/** 
	 * getReturnConferBudget doban7 2016. 9. 29.
	 * @param paraMap
	 * @return
	 */
	Map<String, Object> getReturnConferBudget(HashMap<String, String> paraMap)throws Exception;

	/** 
	 * returnConferBudgetRollBack doban7 2016. 9. 29.
	 * @param paraMap
	 * @return
	 */
	Map<String, Object> returnConferBudgetRollBack(HashMap<String, String> paraMap)throws Exception;

	/** 
	 * getACardSungin_List doban7 2016. 10. 1.
	 * @param aCardVO
	 * @return
	 */
	List<ACardVO> getACardSungin_List(ACardVO aCardVO) throws Exception;

	/** 
	 * getACardList doban7 2016. 10. 2.
	 * @param paraMap
	 * @return
	 */
	List<HashMap<String, String>> getACardList(HashMap<String, Object> paraMap)throws Exception;

	/** 
	 * getCoCardAList doban7 2016. 10. 2.
	 * @param requestMap
	 * @param conVo 
	 * @return
	 */
	List<HashMap<String, String>> getErpACardSunginList(HashMap<String, String> requestMap, ConnectionVO conVo)throws Exception;

	/** 
	 * setACardSungin doban7 2016. 10. 2.
	 * @param aCardVO
	 * @return
	 */
	Map<String, Object> setACardSungin(ACardVO aCardVO)throws Exception;

	/** 
	 * getAbdocuTH doban7 2016. 10. 3.
	 * @param abdocu_h
	 * @return
	 */
	Abdocu_TH getAbdocuTH(Abdocu_H abdocu_h)throws Exception;

	/** 
	 * getAbdocuTD_List doban7 2016. 10. 3.
	 * @param abdocu_h
	 * @return
	 */
	List<Abdocu_TD> getAbdocuTD_List(Abdocu_H abdocu_h)throws Exception;

	/** 
	 * getAbdocuTD2_List doban7 2016. 10. 3.
	 * @param abdocu_h
	 * @return
	 */
	List<Abdocu_TD2> getAbdocuTD2_List(Abdocu_H abdocu_h) throws Exception;


	/** 
	 * insertAbdocu_TH doban7 2016. 10. 3.
	 * @param abdocu_th
	 * @return
	 */
	Object insertAbdocu_TH(Abdocu_TH abdocu_th) throws Exception;

	/** 
	 * updateAbdocu_TH doban7 2016. 10. 3.
	 * @param abdocu_th
	 * @return 
	 */
	int updateAbdocu_TH(Abdocu_TH abdocu_th) throws Exception;

	/** 
	 * deleteAbdocu_TH doban7 2016. 10. 3.
	 * @param abdocu_Tmp
	 * @return
	 */
	int deleteAbdocu_TH(Abdocu_TH abdocu_Tmp) throws Exception;

	/** 
	 * updateAbdocu_TD doban7 2016. 10. 4.
	 * @param abdocu_td
	 * @return 
	 */
	int updateAbdocu_TD(Abdocu_TD abdocu_td) throws Exception;

	/** 
	 * insertAbdocu_TD doban7 2016. 10. 4.
	 * @param abdocu_td
	 * @return
	 */
	Object insertAbdocu_TD(Abdocu_TD abdocu_td) throws Exception;



	/** 
	 * updateAbdocu_TD2 doban7 2016. 10. 4.
	 * @param abdocu_td2
	 * @return 
	 */
	int updateAbdocu_TD2(Abdocu_TD2 abdocu_td2) throws Exception;

	/** 
	 * insertAbdocu_TD2 doban7 2016. 10. 4.
	 * @param abdocu_td2
	 * @return
	 */
	Object insertAbdocu_TD2(Abdocu_TD2 abdocu_td2) throws Exception;

	/** 
	 * deleteAbdocu_TD doban7 2016. 10. 4.
	 * @param abdocu_td
	 * @return
	 */
	int deleteAbdocu_TD(Abdocu_TD abdocu_td)throws Exception;

	/** 
	 * deleteAbdocu_TD2 doban7 2016. 10. 4.
	 * @param abdocu_td2
	 * @return
	 */
	int deleteAbdocu_TD2(Abdocu_TD2 abdocu_td2)throws Exception;

	/** 
	 * getAbdocuD_List doban7 2016. 10. 4.
	 * @param abdocu_h
	 * @return
	 */
	List<Abdocu_D> getAbdocuD_List(Abdocu_H abdocu_h)throws Exception;

	/** 
	 * updateAbdocu_D doban7 2016. 10. 4.
	 * @param abdocu_d
	 * @return 
	 */
	int updateAbdocu_D(Abdocu_D abdocu_d)throws Exception;

	/** 
	 * insertAbdocu_D doban7 2016. 10. 4.
	 * @param abdocu_d
	 * @return
	 */
	Object insertAbdocu_D(Abdocu_D abdocu_d)throws Exception;

	/** 
	 * deleteAbdocu_D doban7 2016. 10. 4.
	 * @param abdocu_d
	 * @return
	 */
	int deleteAbdocu_D(Abdocu_D abdocu_d) throws Exception;
	/** 
	 * getItemsTotalAm doban7 2016. 10. 5.
	 * @param abdocu_H
	 * @return
	 * @throws Exception
	 */
	HashMap<String, String> getItemsTotalAm(Abdocu_H abdocu_H) throws Exception;

	/** 
	 * getETCDUMMY1_Info doban7 2016. 10. 6.
	 * @param paraMap
	 * @param conVo 
	 * @return
	 */
	HashMap<String, String> getErpETCDUMMY1_Info(HashMap<String, String> paraMap, ConnectionVO conVo)throws Exception;

	/** 
	 * getETCDUMMY1 doban7 2016. 10. 6.
	 * @param paraMap
	 * @return
	 */
	HashMap<String, String> getETCDUMMY1(HashMap<String, String> paraMap) throws Exception;

	/** 
	 * setAbdocuCause doban7 2016. 10. 6.
	 * @param abdocu
	 * @return
	 */
	Integer setAbdocuCause(Abdocu_H abdocu) throws Exception;

	/** 
	 * getThisPayDataList doban7 2016. 10. 21.
	 * @param paraMap
	 * @return
	 */
	List<PayDataVO> getThisPayDataList(HashMap<String, String> paraMap)throws Exception;

	/** 
	 * getErpPayData doban7 2016. 10. 24.
	 * @param paraMap
	 * @param conVo 
	 * @return
	 */
	List<HashMap<String, Object>> getErpPayData(HashMap<String, Object> paraMap, ConnectionVO conVo)throws Exception;

	/** 
	 * setPayData doban7 2016. 10. 24.
	 * @param payDataVO
	 * @return
	 */
	Map<String, Object> setPayData(PayDataVO payDataVO)throws Exception;

//	/** 
//	 * getErpPermission doban7 2016. 9. 21.
//	 * @param conVo
//	 * @param paraMap
//	 * @return
//	 */
//	HashMap<String, String> getErpPermission(ConnectionVO conVo, HashMap<String, String> paraMap);

	/** 
	 * insertPurcReq parkjm 2018. 3. 15.
	 * @param abdocu_H, paramMap
	 * @return
	 */
	Map<String, Object> insertPurcReq(Abdocu_H abdocu_H, HashMap<String, Object> paramMap) throws Exception;

	/** 
	 * updatePurcReq parkjm 2018. 3. 15.
	 * @param abdocu_H, paramMap
	 * @return
	 */
	Map<String, Object> updatePurcReq(Abdocu_H abdocu_H, HashMap<String, Object> paramMap) throws Exception;

	/** 
	 * getPurcReq parkjm 2018. 3. 15.
	 * @param paramMap
	 * @return
	 */
	Map<String, Object> getPurcReq(HashMap<String, Object> paramMap) throws Exception;
	
	/** 
	 * insertPurcReqB parkjm 2018. 3. 20.
	 * @param abdocu_B
	 * @return
	 */
	Map<String, Object> insertPurcReqB(Abdocu_B abdocu_B, HashMap<String, Object> paramMap)throws Exception;
	
	/** 
	 * updatePurcReqB parkjm 2018. 3. 20.
	 * @param abdocu_B
	 * @return
	 */
	Map<String, Object> updatePurcReqB(Abdocu_B abdocu_B, HashMap<String, Object> paramMap)throws Exception;

	/**
	 * 
	 * delPurcReqH doban7 2016. 9. 7.
	 * @param abdocu_H
	 * @return
	 * @throws Exception
	 */
	Integer delPurcReqH(Abdocu_H abdocu_H) throws Exception;
	
	/**
	 * 
	 * delPurcReqH doban7 2016. 9. 7.
	 * @param abdocu_H
	 * @return
	 * @throws Exception
	 */
	Integer delPurcReq_H(Abdocu_H abdocu_H) throws Exception;
	
	/** 
	 * delPurcReqB doban7 2016. 9. 7.
	 * @param abdocu_B
	 * @return
	 */
	Map<String, Object> delPurcReqB(Abdocu_B abdocu_B) throws Exception;

	/**
	 * 
	 * delPurcReqT doban7 2016. 9. 7.
	 * @param abdocu_T
	 * @return
	 * @throws Exception
	 */
	Map<String, Object> delPurcReqT(Abdocu_T abdocu_T) throws Exception;
	
	/** 
	 * getPurcReqB doban7 2016. 9. 7.
	 * @param abdocu_H
	 * @return
	 */
	List<Abdocu_B> getPurcReqB(Abdocu_H abdocu_H)throws Exception;
	
	/** 
	 * insertPurcReqT parkjm 2018. 3. 20.
	 * @param abdocu_T, paramMap
	 * @return
	 */
	Map<String, Object> insertPurcReqT(Abdocu_T abdocu_T, HashMap<String, Object> paramMap)throws Exception;

	/** 
	 * updatePurcReqT parkjm 2018. 3. 20.
	 * @param abdocu_T, paramMap
	 * @return
	 */
	Map<String, Object> updatePurcReqT(Abdocu_T abdocu_T, HashMap<String, Object> paramMap)throws Exception;
	
	/** 
	 * getPurcReqT parkjm 2018. 3. 20.
	 * @param abdocu_B
	 * @return
	 */
	List<Abdocu_T> getPurcReqT(Abdocu_B abdocu_B) throws Exception;

	/** 
	 * setPurcReqAttach parkjm 2018. 3. 22.
	 * @param paramMap
	 * @return
	 */
	Map<String, Object> setPurcReqAttach(HashMap<String, Object> paramMap) throws Exception;
	
	Map<String, Object> setPurcContAttach(HashMap<String, Object> paramMap) throws Exception;

	Map<String, Object> makePurcReqNo(HashMap<String, Object> paramMap) throws Exception;

	void updatePurcReqState(Map<String, Object> paramMap) throws Exception;

	Map<String, Object> excelUploadSave(Map<String, Object> map, MultipartHttpServletRequest multi) throws Exception;

	Object purcReqListData(Map<String, Object> map) throws Exception;

	Object purcReqListDataTotal(Map<String, Object> map) throws Exception;
	
	Object purcContListData(Map<String, Object> map) throws Exception;
	
	Object purcContListDataTotal(Map<String, Object> map) throws Exception;

	String makeContInfo(Map<String, String> paraMap) throws Exception;

	Object updatePurcCont(Map<String, String> paraMap) throws Exception;
	
	List<Abdocu_B> getPurcContB(Map<String, Object> map)throws Exception;
	
	Map<String, Object> getPurcCont(HashMap<String, Object> paramMap) throws Exception;
	
	List<Abdocu_T> getPurcContT(Abdocu_B abdocu_B) throws Exception;
	
	Map<String, Object> updatePurcContT(Abdocu_T abdocu_T, HashMap<String, Object> paramMap)throws Exception;
	
	Map<String, Object> delPurcContT(Abdocu_T abdocu_T) throws Exception;
	
	Object getPurcReqLeftAm(Abdocu_T abdocu_T) throws Exception;

	Object checkPurcContComplete(Map<String, Object> map) throws Exception;
	
	Object checkPurcContApproval(Map<String, Object> map) throws Exception;

	Object purcContRepApprovalComplete(Map<String, Object> map) throws Exception;
	
	Object updateContDocSts(Map<String, Object> map) throws Exception;

	Object purcContracted(Map<String, Object> map) throws Exception;

	String makeFileKey(HashMap<String, Object> requestMap) throws Exception;

	String makeContInspInfo(HashMap<String, Object> requestMap) throws Exception;

	Map<String, Object> getContInsp(HashMap<String, Object> requestMap) throws Exception;

	int updatePurcContInsp(HashMap<String, Object> requestMap) throws Exception;
	
	int updatePurcContInspT(HashMap<String, Object> requestMap) throws Exception;

	void updatePurcReqContent(HashMap<String, Object> requestMap) throws Exception;
	
	void makeContentsStr(HashMap<String, Object> requestMap) throws Exception;




	Map<String, Object> getPurcContDocInfo(HashMap<String, Object> requestMap) throws Exception;

	void updatePurcContContent(HashMap<String, Object> requestMap) throws Exception;

	Object purcContInspListData(Map<String, Object> map) throws Exception;

	Object purcContInspListDataTotal(Map<String, Object> map) throws Exception;

	Object inspTopBoxInit(HashMap<String, Object> requestMap) throws Exception;

	Object updatePurcReqContAm(HashMap<String, Object> requestMap) throws Exception;

	void makeContInfoUpdate(Map<String, String> map) throws Exception;

	void updatePurcContInspContent(HashMap<String, Object> requestMap) throws Exception;

	Map<String, Object> checkInspComplete(HashMap<String, Object> requestMap) throws Exception;

	Object purcContModListData(Map<String, Object> map) throws Exception;

	Object purcContModListDataTotal(Map<String, Object> map) throws Exception;

	Map<String, Object> getContMod(HashMap<String, Object> requestMap) throws Exception;

	String makeContModInfo(HashMap<String, Object> requestMap) throws Exception;

	void updatePurcContMod(HashMap<String, Object> requestMap) throws Exception;
	
	Map<String, Object> updatePurcContModT(Abdocu_T abdocu_T, HashMap<String, Object> paramMap) throws Exception;

	Object getApplyAm(HashMap<String, Object> paramMap) throws Exception;

	Object completePurcContMod(HashMap<String, Object> paramMap) throws Exception;

	Object purcContPayListData(Map<String, Object> map) throws Exception;

	Object purcContPayListDataTotal(Map<String, Object> map) throws Exception;

	Object getTemplateKey(HashMap<String, Object> paramMap) throws Exception;

	Object getPurcContPjtList(HashMap<String, Object> paramMap) throws Exception;
	
	Map<String, Object> insertPurcContPay(Abdocu_H abdocu_H, ConnectionVO conVo)throws Exception;

	void updatePurcContPay(Map<String, Object> map) throws Exception;

	Object getPurcContPay(Map<String, Object> map) throws Exception;

	Object purcContPayComplete(Map<String, Object> map) throws Exception;

	Object updatePurcContPayContent(Map<String, Object> map) throws Exception;

	Object getContPay(Map<String, Object> map) throws Exception;

	Object purcItemListData(Map<String, Object> map) throws Exception;

	Object purcItemListDataTotal(Map<String, Object> map) throws Exception;
	
	List<proposalVO> proposalEvaluationList() throws Exception;
	
	int proposalEvaluationListTotal() throws Exception;

	Object updateItemType(Map<String, Object> map) throws Exception;

	Object getContPopupListData(Map<String, Object> map) throws Exception;

	Object getContPopupListDataTotal(Map<String, Object> map) throws Exception;

	List<HashMap<String, String>> getRefDoc(Map<String, String> paraMap) throws Exception;

	Object purcContPayCompleteRollBack(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> getMainGrid(Map<String, Object> map) throws Exception;
	
	int getMainGridTotal(Map<String, Object> map) throws Exception;

	Object updateContTrInfo(Map<String, Object> map) throws Exception;

	Object insertAddTr(Map<String, Object> map) throws Exception;

	Object deleteAddTr(Map<String, Object> map) throws Exception;

	Object requestPurcContMod(HashMap<String, Object> paramMap) throws Exception;

	String insertPurcReqBidding(HashMap<String, Object> map) throws Exception;

	Object purcBiddingData(Map<String, Object> map) throws Exception;

	Object purcBiddingDataTotal(Map<String, Object> map) throws Exception;

	void updatePurcBiddingState(Map<String, Object> map) throws Exception;

	Object checkPurcBiddingApproval(Map<String, Object> map) throws Exception;

	Object selectPurcReqDept(Map<String, Object> map) throws Exception;

	void insertPurcReqBiddingEvalTr(HashMap<String, Object> map) throws Exception;

	Object selectPurcReqBiddingEvalTr(Map<String, Object> map) throws Exception;

	Map<String, Object> selectPurcReqBiddingNego(HashMap<String, Object> paramMap) throws Exception;

	Object selectPurcReqBidding(HashMap<String, Object> paramMap) throws Exception;

	Object selectPurcReqBiddingRefer(HashMap<String, Object> paramMap) throws Exception;

	Object selectRefDoc(HashMap<String, Object> paramMap) throws Exception;

	void updatePurcContModReturn(HashMap<String, Object> map) throws Exception;

	Object insertResTrade(HashMap<String, Object> map) throws Exception;

	void insertPurcContPay2(HashMap<String, Object> map) throws Exception;

	Object selectPurcReqBiddingEval(HashMap<String, Object> paramMap) throws Exception;

	Object updateContTrEvalInfo(Map<String, Object> map) throws Exception;

	Object selectFormInfo(Map<String, Object> map) throws Exception;

	Object updateResHeadNote(Map<String, Object> map) throws Exception;

	Object selectPurcReqBiddingEvalTrSocialBiz(Map<String, Object> map) throws Exception;

	int purcContModReqCheck(HashMap<String, Object> requestMap) throws Exception;

}
